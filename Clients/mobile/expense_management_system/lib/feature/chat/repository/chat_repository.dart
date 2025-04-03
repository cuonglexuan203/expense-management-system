import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:expense_management_system/feature/auth/model/token.dart';
import 'package:expense_management_system/feature/auth/repository/token_repository.dart';
import 'package:expense_management_system/feature/chat/model/extracted_transaction.dart';
import 'package:expense_management_system/feature/chat/model/media.dart';
import 'package:expense_management_system/feature/chat/model/message.dart';
import 'package:expense_management_system/feature/chat/provider/chat_provider.dart';
import 'package:expense_management_system/shared/constants/api_endpoints.dart';
import 'package:expense_management_system/shared/constants/enum.dart';
import 'package:expense_management_system/shared/http/api_provider.dart';
import 'package:expense_management_system/shared/http/api_response.dart';
import 'package:expense_management_system/shared/http/app_exception.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signalr_netcore/signalr_client.dart';

final chatRepositoryProvider =
    Provider((ref) => ChatRepository(ref, ref.read(dioProvider)));

class ChatRepository {
  ChatRepository(this._ref, this.dio);
  final Ref _ref;
  final Dio dio;
  HubConnection? _hubConnection;
  late final ApiProvider _api = _ref.read(apiProvider);
  late final TokenRepository _tokenRepository =
      _ref.read(tokenRepositoryProvider);

  final baseUrl = dotenv.env['BASE_URL'];

  VoidCallback? _onMessageReceived;

  Message? _latestUserMessage;
  Message? get latestUserMessage => _latestUserMessage;

  bool _isProcessingUpload = false;
  bool get isProcessingUpload => _isProcessingUpload;

  // Add this method
  void setUploadProcessingStatus(bool status) {
    _isProcessingUpload = status;
  }

  void setOnMessageReceivedCallback(VoidCallback callback) {
    _onMessageReceived = callback;
  }

  bool _shouldReconnect = true;

  bool _isHandlerRegistered = false;

  Future<void> connect(String accessToken) async {
    _shouldReconnect = true;

    if (_hubConnection != null) {
      if (_hubConnection!.state != HubConnectionState.Disconnected) {
        try {
          await _hubConnection!.stop();
          await Future.delayed(const Duration(milliseconds: 500));
        } catch (e) {
          debugPrint('Error stopping connection: $e');
        }
      }
    }

    _hubConnection = HubConnectionBuilder()
        .withUrl(
          '$baseUrl/hubs/finance',
          options: HttpConnectionOptions(
            accessTokenFactory: () async => accessToken,
            skipNegotiation: true,
            transport: HttpTransportType.WebSockets,
          ),
        )
        .build();

    _hubConnection!.off('ReceiveMessage');
    _hubConnection!.on('ReceiveMessage', _handleReceivedMessage);

    await _startConnection();
  }

  Future<void> _startConnection() async {
    try {
      if (_hubConnection?.state == HubConnectionState.Disconnected) {
        await _hubConnection?.start();
      } else if (_hubConnection?.state != HubConnectionState.Connected) {
        await Future.delayed(const Duration(seconds: 1));

        if (_hubConnection?.state != HubConnectionState.Connected) {
          try {
            await _hubConnection?.stop();
            await Future.delayed(const Duration(milliseconds: 500));
            await _hubConnection?.start();
          } catch (e) {
            throw AppException.errorWithMessage("Connection failed: $e");
          }
        }
      }
    } catch (e) {
      if (e.toString().contains("401")) {
        final newAccessToken = await _refreshToken();
        if (newAccessToken != null && _shouldReconnect) {
          await connect(newAccessToken);
        } else {
          throw AppException.errorWithMessage("Làm mới access token thất bại");
        }
      } else {
        throw AppException.errorWithMessage("Connection failed: $e");
      }
    }

    _hubConnection?.onclose((error) {
      if (_shouldReconnect) {
        Future.delayed(const Duration(seconds: 5), () async {
          if (_shouldReconnect &&
              _hubConnection?.state == HubConnectionState.Disconnected) {
            await _startConnection();
          }
        });
      }
    });
  }

  Future<void> disconnect() async {
    _shouldReconnect = false;
    if (_hubConnection?.state != HubConnectionState.Disconnected) {
      try {
        await _hubConnection?.stop();
      } catch (e) {
        debugPrint('Error stopping hub connection: $e');
      }
    }
  }

  Future<void> sendMessage(
      int walletId, int chatThreadId, String message) async {
    await _ensureConnected();
    try {
      await _hubConnection
          ?.invoke("SendMessage", args: [walletId, chatThreadId, message]);
    } catch (e) {
      if (_isConnectionError(e)) {
        await _ensureConnected();
        await _hubConnection
            ?.invoke("SendMessage", args: [walletId, chatThreadId, message]);
      } else {
        throw AppException.errorWithMessage(
            "Failed to send message: ${e.toString()}");
      }
    }
  }

  Future<Message?> sendMessageViaWebSocket(
      int walletId, int chatThreadId, String message) async {
    await _ensureConnected();
    try {
      final response = await _hubConnection?.invoke("SendMessageWithFiles",
          args: [walletId, chatThreadId, message]);

      if (response != null && response is Map<String, dynamic>) {
        _latestUserMessage = Message.fromJson(response);
        return _latestUserMessage;
      } else {
        return null;
      }
    } catch (e) {
      if (_isConnectionError(e)) {
        await _ensureConnected();
        final response = await _hubConnection?.invoke("SendMessageWithFiles",
            args: [walletId, chatThreadId, message]);

        if (response != null && response is Map<String, dynamic>) {
          _latestUserMessage = Message.fromJson(response);
          return _latestUserMessage;
        }
        return null;
      } else {
        throw AppException.errorWithMessage(
            "Failed to send message: ${e.toString()}");
      }
    }
  }

  Future<void> _ensureConnected() async {
    if (_hubConnection?.state != HubConnectionState.Connected) {
      try {
        final tokenRepository = _ref.read(tokenRepositoryProvider);
        final accessToken = await tokenRepository.getAccessToken();

        if (accessToken == null) {
          final newToken = await _refreshToken();
          if (newToken == null) {
            throw AppException.errorWithMessage("Không thể lấy access token");
          }
          await connect(newToken);
        } else {
          await connect(accessToken);
        }
      } catch (e) {
        if (e.toString().contains("401")) {
          final newToken = await _refreshToken();
          if (newToken != null) {
            await connect(newToken);
          } else {
            throw AppException.errorWithMessage(
                "Không thể làm mới access token");
          }
        } else {
          throw AppException.errorWithMessage("Lỗi kết nối: ${e.toString()}");
        }
      }
    }
  }

  bool _isConnectionError(dynamic error) {
    String errorStr = error.toString().toLowerCase();
    return errorStr.contains('connection') ||
        errorStr.contains('network') ||
        errorStr.contains('socket') ||
        errorStr.contains('timeout') ||
        errorStr.contains('401');
  }

  void _handleReceivedMessage(List<Object?>? args) {
    debugPrint("SignalR received message: $args");

    if (args == null || args.isEmpty) return;

    try {
      if (args[0] is List) {
        List<dynamic> dataList = args[0] as List<dynamic>;
        for (var item in dataList) {
          _processMessageItem(item);
        }
      } else {
        _processMessageItem(args[0]);
      }
    } catch (e) {
      debugPrint('Stack trace: ${StackTrace.current}');
    }
  }

  void _processMessageItem(dynamic messageItem) {
    try {
      Map<String, dynamic> data;
      if (messageItem is String) {
        data = jsonDecode(messageItem) as Map<String, dynamic>;
      } else if (messageItem is Map<String, dynamic>) {
        data = messageItem;
      } else {
        debugPrint('Unexpected data type: ${messageItem.runtimeType}');
        return;
      }

      if (data.containsKey('userMessage') && data['userMessage'] != null) {
        final userMessageData = data['userMessage'] as Map<String, dynamic>;

        final userMessageCopy = Map<String, dynamic>.from(userMessageData);
        _convertDataTypes(userMessageCopy);

        // Store message but don't add to UI
        _latestUserMessage = Message.fromJson(userMessageCopy);

        // Only call callback if we're not currently uploading images
        if (_onMessageReceived != null && !_isProcessingUpload) {
          _onMessageReceived!();
        }
      }

      // Process system message - add to UI immediately
      if (data.containsKey('systemMessage') && data['systemMessage'] != null) {
        final systemMessageData = data['systemMessage'] as Map<String, dynamic>;
        final systemMessageCopy = Map<String, dynamic>.from(systemMessageData);
        _convertDataTypes(systemMessageCopy);

        final systemMessage = Message.fromJson(systemMessageCopy);

        List<ExtractedTransaction> extractedTransactions = [];
        if (data.containsKey('extractedTransactions') &&
            data['extractedTransactions'] is List &&
            (data['extractedTransactions'] as List).isNotEmpty) {
          final extractedTransactionsList =
              data['extractedTransactions'] as List;
          extractedTransactions = extractedTransactionsList.map((e) {
            final transactionData =
                Map<String, dynamic>.from(e as Map<String, dynamic>);
            _convertDataTypes(transactionData);
            return ExtractedTransaction.fromJson(transactionData);
          }).toList();
        }

        final messageWithTransactions = systemMessage.copyWith(
          extractedTransactions: extractedTransactions,
        );

        _ref
            .read(chatProvider.notifier)
            .addReceivedMessage(messageWithTransactions);

        if (_onMessageReceived != null) {
          _onMessageReceived!();
        }
      }
    } catch (e) {
      debugPrint('Error processing message item: $e');
      debugPrint('Stack trace: ${StackTrace.current}');
    }
  }

  void _convertDataTypes(Map<String, dynamic> data) {
    final intFields = [
      'id',
      'chatThreadId',
      'chatExtractionId',
      'chatMessageId',
      'transactionId'
    ];

    if (data.containsKey('amount')) {
      if (data['amount'] is String) {
        data['amount'] = double.tryParse(data['amount'] as String) ?? 0.0;
      } else if (data['amount'] is int) {
        data['amount'] = (data['amount'] as int).toDouble();
      }
    }

    for (final field in intFields) {
      if (data.containsKey(field)) {
        if (data[field] is String) {
          data[field] = int.tryParse(data[field] as String) ?? 0;
        }
      }
    }

    if (data.containsKey('userId') && data['userId'] is int) {
      data['userId'] = data['userId'].toString();
    }

    if (data.containsKey('type') && data['type'] is int) {
      int typeValue = data['type'] as int;
      data['type'] = typeValue == 1 ? 'Expense' : 'Income';
    }

    if (data.containsKey('confirmationMode') &&
        data['confirmationMode'] is int) {
      int modeValue = data['confirmationMode'] as int;
      data['confirmationMode'] = modeValue == 1 ? 'Manual' : 'Automatic';
    }

    if (data.containsKey('confirmationStatus') &&
        data['confirmationStatus'] is int) {
      int statusValue = data['confirmationStatus'] as int;
      switch (statusValue) {
        case 1:
          data['confirmationStatus'] = 'Pending';
          break;
        case 2:
          data['confirmationStatus'] = 'Confirmed';
          break;
        case 3:
          data['confirmationStatus'] = 'Rejected';
          break;
        default:
          data['confirmationStatus'] = 'Pending';
      }
    }

    if (data.containsKey('role') && data['role'] is int) {
      int roleValue = data['role'] as int;
      switch (roleValue) {
        case 0:
          data['role'] = 'Unknown';
          break;
        case 1:
          data['role'] = 'System';
          break;
        case 2:
          data['role'] = 'User';
          break;
        default:
          data['role'] = 'System';
      }
    }
  }

  Future<String?> _refreshToken() async {
    try {
      final token = await _tokenRepository.fetchToken();
      if (token == null || token.refreshToken!.isEmpty) {
        return null;
      }

      final baseUrl = _api.baseUrl;

      final response = await dio.post(
        '${baseUrl}${ApiEndpoints.auth.refreshToken}',
        data: {
          'accessToken': token.accessToken,
          'refreshToken': token.refreshToken,
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
          validateStatus: (status) =>
              status != null && status >= 200 && status < 300,
        ),
      );

      if (response.statusCode == 200) {
        final tokenData = response.data as Map<String, dynamic>;
        final newToken = Token(
          token: json.encode(tokenData),
          accessToken: tokenData['accessToken']?.toString() ?? '',
          refreshToken: tokenData['refreshToken']?.toString() ?? '',
          accessTokenExpiration:
              tokenData['accessTokenExpiration']?.toString() ?? '',
          refreshTokenExpiration:
              tokenData['refreshTokenExpiration']?.toString() ?? '',
        );
        await _tokenRepository.saveToken(newToken);
        return newToken.accessToken;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getChatThreads() async {
    try {
      final response = await _api.get(ApiEndpoints.chatThread.getAll);
      return response.when(
        success: (data) => List<Map<String, dynamic>>.from(data as List),
        error: (e) => throw AppException.errorWithMessage(
          "Failed to fetch chat threads: $e",
        ),
      );
    } catch (e) {
      throw AppException.errorWithMessage("Failed to fetch chat threads: $e");
    }
  }

  Future<APIResponse<Map<String, dynamic>>> getMessagesByChatThreadId({
    required int chatThreadId,
    int pageNumber = 1,
    int pageSize = 10,
  }) async {
    try {
      final response = await _api.get(
        ApiEndpoints.chatThread.getMessageById(chatThreadId),
        query: {
          'pageNumber': pageNumber.toString(),
          'pageSize': pageSize.toString()
        },
      );

      return response.when(
        success: (data) => APIResponse.success(data as Map<String, dynamic>),
        error: APIResponse.error,
      );
    } catch (e) {
      return APIResponse.error(AppException.errorWithMessage(e.toString()));
    }
  }

  Future<Map<String, dynamic>> confirmExtractedTransaction({
    required int transactionId,
    required int walletId,
    required String status,
  }) async {
    try {
      final body = {'walletId': walletId, 'confirmationStatus': status};

      final response = await _api.patch(
        ApiEndpoints.extractedTransaction
            .confirmStatusTransaction(transactionId),
        jsonEncode(body),
      );

      debugPrint('Confirm transaction response: $response');

      if (response is Map) {
        return Map<String, dynamic>.from(response as Map);
      } else {
        throw AppException.errorWithMessage(
            "Invalid response format from server");
      }
    } catch (e) {
      debugPrint('Error confirming transaction: $e');
      throw AppException.errorWithMessage("Failed to confirm transaction: $e");
    }
  }

  Future<List<Media>> uploadMediaToMessage({
    required int messageId,
    required int walletId,
    required List<XFile> files,
  }) async {
    try {
      final formData = FormData();
      formData.fields.add(MapEntry('walletId', walletId.toString()));

      for (var file in files) {
        final fileName = file.path.split('/').last;
        final extension = fileName.split('.').last.toLowerCase();

        // Determine content type based on extension
        String contentType;
        if (['jpg', 'jpeg', 'png', 'gif'].contains(extension)) {
          contentType = 'image/$extension';
        } else if (['mp3', 'm4a', 'wav', 'aac'].contains(extension)) {
          contentType = 'audio/$extension';
        } else {
          contentType = 'application/octet-stream';
        }

        formData.files.add(
          MapEntry(
            'files',
            await MultipartFile.fromFile(
              file.path,
              filename: fileName,
              contentType: MediaType(
                  contentType.split('/')[0], contentType.split('/')[1]),
            ),
          ),
        );
      }

      final response = await _api.post(
        ApiEndpoints.media.uploadFile(messageId),
        formData,
        contentType: ContentType.multipartFormData,
      );

      // Add proper return value
      return response.when(
        success: (data) {
          final mediaList =
              (data as Map<String, dynamic>)['medias'] as List<dynamic>;
          return mediaList
              .map((mediaJson) =>
                  Media.fromJson(mediaJson as Map<String, dynamic>))
              .toList();
        },
        error: (error) {
          debugPrint('Error processing upload response: $error');
          throw error;
        },
      );
    } catch (e) {
      debugPrint('Error uploading media: $e');
      throw AppException.errorWithMessage('Failed to upload media: $e');
    }
  }
}

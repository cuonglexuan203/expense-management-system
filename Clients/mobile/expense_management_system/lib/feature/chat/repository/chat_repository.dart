import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:expense_management_system/feature/auth/model/token.dart';
import 'package:expense_management_system/feature/auth/repository/token_repository.dart';
import 'package:expense_management_system/feature/chat/model/extracted_transaction.dart';
import 'package:expense_management_system/feature/chat/model/message.dart';
import 'package:expense_management_system/feature/chat/provider/chat_provider.dart';
import 'package:expense_management_system/shared/constants/api_endpoints.dart';
import 'package:expense_management_system/shared/http/api_provider.dart';
import 'package:expense_management_system/shared/http/api_response.dart';
import 'package:expense_management_system/shared/http/app_exception.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:signalr_netcore/signalr_client.dart';

final chatRepositoryProvider =
    Provider((ref) => ChatRepository(ref, ref.read(dioProvider)));

class ChatRepository {
  ChatRepository(this._ref, this.dio);
  final Ref _ref;
  final Dio dio;
  late HubConnection _hubConnection;
  late final ApiProvider _api = _ref.read(apiProvider);
  late final TokenRepository _tokenRepository =
      _ref.read(tokenRepositoryProvider);

  final baseUrl = dotenv.env['BASE_URL'];

  VoidCallback? _onMessageReceived;

  void setOnMessageReceivedCallback(VoidCallback callback) {
    _onMessageReceived = callback;
  }

  Future<void> connect(String accessToken) async {
    _hubConnection = HubConnectionBuilder()
        .withUrl(
          '$baseUrl/${ApiEndpoints.hubConnection.finance}',
          options: HttpConnectionOptions(
            accessTokenFactory: () async => accessToken,
          ),
        )
        .build();

    _hubConnection.on('ReceiveMessage', _handleReceivedMessage);
    await _startConnection();
  }

  Future<void> _startConnection() async {
    try {
      await _hubConnection.start();
    } catch (e) {
      if (e.toString().contains("401")) {
        final newAccessToken = await _refreshToken();
        if (newAccessToken != null) {
          await connect(newAccessToken);
        }
      } else {
        throw AppException.errorWithMessage("Connection failed: $e");
      }
    }

    _hubConnection.onclose((error) {
      Future.delayed(const Duration(seconds: 5), () async {
        await _startConnection();
      });
    });
  }

  Future<void> disconnect() async {
    if (_hubConnection.state == HubConnectionState.Connected) {
      await _hubConnection.stop();
    }
  }

  Future<void> sendMessage(
      int walletId, int chatThreadId, String message) async {
    if (_hubConnection.state == HubConnectionState.Connected) {
      await _hubConnection
          .invoke("SendMessage", args: [walletId, chatThreadId, message]);
    } else {
      throw AppException.errorWithMessage("Connection is not established.");
    }
  }

  void _handleReceivedMessage(List<Object?>? args) {
    print(args);
    if (args != null && args.isNotEmpty) {
      final messageData = args[0];

      try {
        Map<String, dynamic> data;
        if (messageData is String) {
          data = jsonDecode(messageData) as Map<String, dynamic>;
        } else if (messageData is Map<String, dynamic>) {
          data = messageData;
        } else {
          debugPrint(
              'Unexpected message data type: ${messageData.runtimeType}');
          return;
        }

        if (data.containsKey('systemMessage') &&
            data['systemMessage'] != null) {
          final systemMessageData =
              data['systemMessage'] as Map<String, dynamic>;

          _convertDataTypes(systemMessageData);

          final systemMessage = Message.fromJson(systemMessageData);

          if (data.containsKey('extractedTransactions') &&
              data['extractedTransactions'] is List &&
              (data['extractedTransactions'] as List).isNotEmpty) {
            final extractedTransactionsList =
                data['extractedTransactions'] as List;
            final extractedTransactions = extractedTransactionsList.map((e) {
              final transactionData = e as Map<String, dynamic>;

              _convertDataTypes(transactionData);

              return ExtractedTransaction.fromJson(transactionData);
            }).toList();

            final messageWithTransactions = systemMessage.copyWith(
              extractedTransactions: extractedTransactions,
            );

            _ref
                .read(chatProvider.notifier)
                .addReceivedMessage(messageWithTransactions);
          } else {
            _ref.read(chatProvider.notifier).addReceivedMessage(systemMessage);
          }

          if (_onMessageReceived != null) {
            _onMessageReceived!();
          }
        }
      } catch (e) {
        debugPrint('Error parsing WebSocket message: $e');
      }
    }
  }

  void _convertDataTypes(Map<String, dynamic> data) {
    final intFields = [
      'id',
      'chatThreadId',
      'chatExtractionId',
      'chatMessageId',
      'transactionId',
      'amount',
      'type',
      'confirmationMode',
      'confirmationStatus'
    ];

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

      // final response = await _api.post(
      //   ApiEndpoints.extractedTransaction.confirmTransaction(transactionId),
      //   jsonEncode(body),
      // );
      final response = await _api.patch(
          ApiEndpoints.extractedTransaction
              .confirmStatusTransaction(transactionId),
          jsonEncode(body));
      return Map<String, dynamic>.from(response as Map);
    } catch (e) {
      throw AppException.errorWithMessage("Failed to confirm transaction: $e");
    }
  }
}

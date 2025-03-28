import 'package:expense_management_system/feature/chat/model/message.dart';
import 'package:expense_management_system/feature/chat/repository/chat_repository.dart';
import 'package:expense_management_system/feature/chat/state/chat_state.dart';
import 'package:expense_management_system/shared/http/app_exception.dart';
import 'package:expense_management_system/shared/pagination/pagination_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  return ChatNotifier(ref.read(chatRepositoryProvider));
});

class ChatNotifier extends StateNotifier<ChatState> {
  final ChatRepository _repository;
  int _currentPage = 1;
  PaginationInfo? _paginationInfo;
  int? _currentChatThreadId;

  ChatNotifier(this._repository) : super(const ChatState.initial());

  Future<void> fetchMessages(int chatThreadId) async {
    state = const ChatState.loading();
    _currentChatThreadId = chatThreadId;
    _currentPage = 1;

    try {
      final response = await _repository.getMessagesByChatThreadId(
        chatThreadId: chatThreadId,
        pageNumber: _currentPage,
      );

      response.when(
        success: (data) {
          final rawItems = data['items'] as List<dynamic>?;
          final List<Message> messages = [];

          if (rawItems != null) {
            for (var item in rawItems) {
              try {
                messages.add(Message.fromJson(item as Map<String, dynamic>));
              } catch (e) {
                debugPrint('Error parsing message: $e');
              }
            }
          }

          final paginationInfo = PaginationInfo(
            pageNumber: data['pageNumber'] as int? ?? 1,
            pageSize: data['pageSize'] as int? ?? 10,
            totalPages: data['totalPages'] as int? ?? 1,
            totalCount: data['totalCount'] as int? ?? 0,
            hasPreviousPage: data['hasPreviousPage'] as bool? ?? false,
            hasNextPage: data['hasNextPage'] as bool? ?? false,
          );

          _paginationInfo = paginationInfo;

          final reversedMessages = messages.toList();
          state = ChatState.loaded(reversedMessages);
        },
        error: (error) {
          state = ChatState.error(error);
        },
      );
    } catch (e) {
      state = ChatState.error(AppException.errorWithMessage(e.toString()));
    }
  }

  Future<void> loadMoreMessages(int chatThreadId) async {
    if (_paginationInfo == null || !_paginationInfo!.hasNextPage) {
      return; // No more pages to load
    }

    if (_currentChatThreadId != chatThreadId) {
      // Chat thread changed, reset pagination
      await fetchMessages(chatThreadId);
      return;
    }

    final currentMessages = state.maybeWhen(
      loaded: (messages) => List<Message>.from(messages),
      orElse: () => <Message>[],
    );

    try {
      final nextPage = _currentPage + 1;
      final response = await _repository.getMessagesByChatThreadId(
        chatThreadId: chatThreadId,
        pageNumber: nextPage,
      );

      response.when(
        success: (data) {
          final rawItems = data['items'] as List<dynamic>?;
          final List<Message> newMessages = [];

          if (rawItems != null) {
            for (var item in rawItems) {
              try {
                newMessages.add(Message.fromJson(item as Map<String, dynamic>));
              } catch (e) {
                debugPrint('Error parsing message: $e');
              }
            }
          }

          final paginationInfo = PaginationInfo(
            pageNumber: data['pageNumber'] as int? ?? 1,
            pageSize: data['pageSize'] as int? ?? 10,
            totalPages: data['totalPages'] as int? ?? 1,
            totalCount: data['totalCount'] as int? ?? 0,
            hasPreviousPage: data['hasPreviousPage'] as bool? ?? false,
            hasNextPage: data['hasNextPage'] as bool? ?? false,
          );

          _paginationInfo = paginationInfo;
          _currentPage = nextPage;

          // Thay đổi ở đây: thêm tin nhắn cũ vào đầu danh sách
          final allMessages = [...newMessages, ...currentMessages];
          state = ChatState.loaded(allMessages);
        },
        error: (error) {
          state = ChatState.error(error);
        },
      );
    } catch (e) {
      state = ChatState.error(AppException.errorWithMessage(e.toString()));
    }
  }

  void addReceivedMessage(Message message) {
    final currentMessages = state.maybeWhen(
      loaded: (messages) => List<Message>.from(messages),
      orElse: () => <Message>[],
    );

    final updatedMessages = [message, ...currentMessages];
    state = ChatState.loaded(updatedMessages);
  }
}

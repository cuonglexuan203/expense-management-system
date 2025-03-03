import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_boilerplate/feature/chat/model/message.dart';
import 'package:flutter_boilerplate/feature/chat/state/chat_state.dart';
import 'package:flutter_boilerplate/feature/chat/repository/chat_repository.dart';
import 'package:uuid/uuid.dart';

final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  return ChatNotifier(ref.read(chatRepositoryProvider));
});

class ChatNotifier extends StateNotifier<ChatState> {
  final ChatRepository _repository;

  ChatNotifier(this._repository) : super(const ChatState.initial());

  Future<void> sendMessage(String content, {String? transactionAmount}) async {
    final message = Message(
      id: const Uuid().v4(),
      content: content,
      isUser: true,
      timestamp: DateTime.now(),
      transactionAmount: transactionAmount,
    );

    final currentMessages = state.maybeWhen(
      loaded: (messages) => List<Message>.from(messages),
      orElse: () => <Message>[],
    );

    state = ChatState.loaded([...currentMessages, message]);

    // Get AI response
    final response = await _repository.getAIResponse(content);

    response.when(
      success: (aiMessage) {
        final updatedMessages = state.maybeWhen(
          loaded: (messages) => List<Message>.from(messages),
          orElse: () => <Message>[],
        );
        state = ChatState.loaded([...updatedMessages, aiMessage]);
      },
      error: (error) {
        state = ChatState.error(error);
      },
    );
  }
}

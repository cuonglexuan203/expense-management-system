import 'package:expense_management_system/feature/chat/model/message.dart';
import 'package:expense_management_system/shared/http/api_provider.dart';
import 'package:expense_management_system/shared/http/api_response.dart';
import 'package:expense_management_system/shared/http/app_exception.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final chatRepositoryProvider = Provider((ref) => ChatRepository(ref));

class ChatRepository {
  final Ref _ref;
  late final ApiProvider _api = _ref.read(apiProvider);

  ChatRepository(this._ref);

  Future<APIResponse<Message>> getAIResponse(String userMessage) async {
    try {
      // Simulate AI response for now
      await Future.delayed(const Duration(seconds: 1));

      return APIResponse.success(
        Message(
          id: const Uuid().v4(),
          content:
              "Spending on breakfast is reasonable! Prices may vary depending on where you eat, but consider other meals during the day to reduce costs!",
          isUser: false,
          timestamp: DateTime.now(),
        ),
      );
    } catch (e) {
      return APIResponse.error(AppException.errorWithMessage(e.toString()));
    }
  }
}

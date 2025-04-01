// message.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'extracted_transaction.dart';
import 'media.dart';

part 'message.freezed.dart';
part 'message.g.dart';

@freezed
class Message with _$Message {
  const factory Message({
    required int id,
    required int chatThreadId,
    String? userId,
    required String role,
    required String content,
    required DateTime createdAt,
    @Default([]) List<Media> medias,
    @Default([]) List<ExtractedTransaction> extractedTransactions,
  }) = _Message;

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_thread.freezed.dart';
part 'chat_thread.g.dart';

@freezed
class ChatThread with _$ChatThread {
  const factory ChatThread({
    required int id,
    required String userId,
    required String title,
    required bool isActive,
    required String type,
    required DateTime createdAt,
  }) = _ChatThread;

  factory ChatThread.fromJson(Map<String, dynamic> json) =>
      _$ChatThreadFromJson(json);
}

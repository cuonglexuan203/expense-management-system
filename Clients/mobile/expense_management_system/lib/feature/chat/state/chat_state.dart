import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_boilerplate/feature/chat/model/message.dart';
import 'package:flutter_boilerplate/shared/http/app_exception.dart';

part 'chat_state.freezed.dart';

@freezed
class ChatState with _$ChatState {
  const factory ChatState.initial() = _Initial;
  const factory ChatState.loading() = _Loading;
  const factory ChatState.loaded(List<Message> messages) = _Loaded;
  const factory ChatState.error(AppException error) = _Error;
}

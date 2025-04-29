// lib/feature/notification/model/device_token.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_token.freezed.dart';
part 'device_token.g.dart';

enum DevicePlatform { android, ios }

@freezed
class DeviceToken with _$DeviceToken {
  const factory DeviceToken({
    required String token,
    required DevicePlatform platform,
  }) = _DeviceToken;

  factory DeviceToken.fromJson(Map<String, dynamic> json) =>
      _$DeviceTokenFromJson(json);
}

extension DevicePlatformX on DevicePlatform {
  String get value {
    switch (this) {
      case DevicePlatform.android:
        return 'Android';
      case DevicePlatform.ios:
        return 'Ios';
    }
  }
}

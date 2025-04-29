// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_token.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DeviceTokenImpl _$$DeviceTokenImplFromJson(Map<String, dynamic> json) =>
    _$DeviceTokenImpl(
      token: json['token'] as String,
      platform: $enumDecode(_$DevicePlatformEnumMap, json['platform']),
    );

Map<String, dynamic> _$$DeviceTokenImplToJson(_$DeviceTokenImpl instance) =>
    <String, dynamic>{
      'token': instance.token,
      'platform': _$DevicePlatformEnumMap[instance.platform]!,
    };

const _$DevicePlatformEnumMap = {
  DevicePlatform.android: 'android',
  DevicePlatform.ios: 'ios',
};

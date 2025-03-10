// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TokenImpl _$$TokenImplFromJson(Map<String, dynamic> json) => _$TokenImpl(
      accessToken: json['accessToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
      accessTokenExpiration: json['accessTokenExpiration'] as String?,
      refreshTokenExpiration: json['refreshTokenExpiration'] as String?,
      token: json['token'] as String,
    );

Map<String, dynamic> _$$TokenImplToJson(_$TokenImpl instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'accessTokenExpiration': instance.accessTokenExpiration,
      'refreshTokenExpiration': instance.refreshTokenExpiration,
      'token': instance.token,
    };

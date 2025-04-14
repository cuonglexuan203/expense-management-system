// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WalletRequestImpl _$$WalletRequestImplFromJson(Map<String, dynamic> json) =>
    _$WalletRequestImpl(
      name: json['name'] as String,
      initialBalance: (json['initialBalance'] as num).toDouble(),
    );

Map<String, dynamic> _$$WalletRequestImplToJson(_$WalletRequestImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'initialBalance': instance.initialBalance,
    };

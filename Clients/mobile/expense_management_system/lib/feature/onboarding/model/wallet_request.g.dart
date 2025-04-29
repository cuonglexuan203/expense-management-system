// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WalletRequestImpl _$$WalletRequestImplFromJson(Map<String, dynamic> json) =>
    _$WalletRequestImpl(
      name: json['name'] as String,
      balance: (json['balance'] as num).toDouble(),
    );

Map<String, dynamic> _$$WalletRequestImplToJson(_$WalletRequestImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'balance': instance.balance,
    };

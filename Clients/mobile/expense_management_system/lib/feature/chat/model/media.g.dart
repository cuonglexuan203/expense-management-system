// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MediaImpl _$$MediaImplFromJson(Map<String, dynamic> json) => _$MediaImpl(
      id: json['id'] as String,
      url: json['url'] as String,
      secureUrl: json['secureUrl'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      size: (json['size'] as num).toInt(),
      extension: json['extension'] as String,
      type: json['type'] as String,
      publicId: json['publicId'] as String,
      assetId: json['assetId'] as String,
      altText: json['altText'] as String?,
      caption: json['caption'] as String?,
      width: (json['width'] as num).toInt(),
      height: (json['height'] as num).toInt(),
      duration: (json['duration'] as num?)?.toInt(),
      status: json['status'] as String,
      metadata: json['metadata'] as String,
      isOptimized: json['isOptimized'] as bool,
      chatMessageId: (json['chatMessageId'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$MediaImplToJson(_$MediaImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'secureUrl': instance.secureUrl,
      'thumbnailUrl': instance.thumbnailUrl,
      'size': instance.size,
      'extension': instance.extension,
      'type': instance.type,
      'publicId': instance.publicId,
      'assetId': instance.assetId,
      'altText': instance.altText,
      'caption': instance.caption,
      'width': instance.width,
      'height': instance.height,
      'duration': instance.duration,
      'status': instance.status,
      'metadata': instance.metadata,
      'isOptimized': instance.isOptimized,
      'chatMessageId': instance.chatMessageId,
      'createdAt': instance.createdAt.toIso8601String(),
    };

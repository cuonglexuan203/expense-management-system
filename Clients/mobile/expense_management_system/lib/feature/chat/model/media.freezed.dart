// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'media.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Media _$MediaFromJson(Map<String, dynamic> json) {
  return _Media.fromJson(json);
}

/// @nodoc
mixin _$Media {
  String get id => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;
  String get secureUrl => throw _privateConstructorUsedError;
  String get thumbnailUrl => throw _privateConstructorUsedError;
  int get size => throw _privateConstructorUsedError;
  String get extension => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get publicId => throw _privateConstructorUsedError;
  String get assetId => throw _privateConstructorUsedError;
  String? get altText => throw _privateConstructorUsedError;
  String? get caption => throw _privateConstructorUsedError;
  int get width => throw _privateConstructorUsedError;
  int get height => throw _privateConstructorUsedError;
  int? get duration => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String get metadata => throw _privateConstructorUsedError;
  bool get isOptimized => throw _privateConstructorUsedError;
  int get chatMessageId => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this Media to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Media
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MediaCopyWith<Media> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MediaCopyWith<$Res> {
  factory $MediaCopyWith(Media value, $Res Function(Media) then) =
      _$MediaCopyWithImpl<$Res, Media>;
  @useResult
  $Res call(
      {String id,
      String url,
      String secureUrl,
      String thumbnailUrl,
      int size,
      String extension,
      String type,
      String publicId,
      String assetId,
      String? altText,
      String? caption,
      int width,
      int height,
      int? duration,
      String status,
      String metadata,
      bool isOptimized,
      int chatMessageId,
      DateTime createdAt});
}

/// @nodoc
class _$MediaCopyWithImpl<$Res, $Val extends Media>
    implements $MediaCopyWith<$Res> {
  _$MediaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Media
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? url = null,
    Object? secureUrl = null,
    Object? thumbnailUrl = null,
    Object? size = null,
    Object? extension = null,
    Object? type = null,
    Object? publicId = null,
    Object? assetId = null,
    Object? altText = freezed,
    Object? caption = freezed,
    Object? width = null,
    Object? height = null,
    Object? duration = freezed,
    Object? status = null,
    Object? metadata = null,
    Object? isOptimized = null,
    Object? chatMessageId = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      secureUrl: null == secureUrl
          ? _value.secureUrl
          : secureUrl // ignore: cast_nullable_to_non_nullable
              as String,
      thumbnailUrl: null == thumbnailUrl
          ? _value.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String,
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as int,
      extension: null == extension
          ? _value.extension
          : extension // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      publicId: null == publicId
          ? _value.publicId
          : publicId // ignore: cast_nullable_to_non_nullable
              as String,
      assetId: null == assetId
          ? _value.assetId
          : assetId // ignore: cast_nullable_to_non_nullable
              as String,
      altText: freezed == altText
          ? _value.altText
          : altText // ignore: cast_nullable_to_non_nullable
              as String?,
      caption: freezed == caption
          ? _value.caption
          : caption // ignore: cast_nullable_to_non_nullable
              as String?,
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as int,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int,
      duration: freezed == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as String,
      isOptimized: null == isOptimized
          ? _value.isOptimized
          : isOptimized // ignore: cast_nullable_to_non_nullable
              as bool,
      chatMessageId: null == chatMessageId
          ? _value.chatMessageId
          : chatMessageId // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MediaImplCopyWith<$Res> implements $MediaCopyWith<$Res> {
  factory _$$MediaImplCopyWith(
          _$MediaImpl value, $Res Function(_$MediaImpl) then) =
      __$$MediaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String url,
      String secureUrl,
      String thumbnailUrl,
      int size,
      String extension,
      String type,
      String publicId,
      String assetId,
      String? altText,
      String? caption,
      int width,
      int height,
      int? duration,
      String status,
      String metadata,
      bool isOptimized,
      int chatMessageId,
      DateTime createdAt});
}

/// @nodoc
class __$$MediaImplCopyWithImpl<$Res>
    extends _$MediaCopyWithImpl<$Res, _$MediaImpl>
    implements _$$MediaImplCopyWith<$Res> {
  __$$MediaImplCopyWithImpl(
      _$MediaImpl _value, $Res Function(_$MediaImpl) _then)
      : super(_value, _then);

  /// Create a copy of Media
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? url = null,
    Object? secureUrl = null,
    Object? thumbnailUrl = null,
    Object? size = null,
    Object? extension = null,
    Object? type = null,
    Object? publicId = null,
    Object? assetId = null,
    Object? altText = freezed,
    Object? caption = freezed,
    Object? width = null,
    Object? height = null,
    Object? duration = freezed,
    Object? status = null,
    Object? metadata = null,
    Object? isOptimized = null,
    Object? chatMessageId = null,
    Object? createdAt = null,
  }) {
    return _then(_$MediaImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      secureUrl: null == secureUrl
          ? _value.secureUrl
          : secureUrl // ignore: cast_nullable_to_non_nullable
              as String,
      thumbnailUrl: null == thumbnailUrl
          ? _value.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String,
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as int,
      extension: null == extension
          ? _value.extension
          : extension // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      publicId: null == publicId
          ? _value.publicId
          : publicId // ignore: cast_nullable_to_non_nullable
              as String,
      assetId: null == assetId
          ? _value.assetId
          : assetId // ignore: cast_nullable_to_non_nullable
              as String,
      altText: freezed == altText
          ? _value.altText
          : altText // ignore: cast_nullable_to_non_nullable
              as String?,
      caption: freezed == caption
          ? _value.caption
          : caption // ignore: cast_nullable_to_non_nullable
              as String?,
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as int,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int,
      duration: freezed == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as String,
      isOptimized: null == isOptimized
          ? _value.isOptimized
          : isOptimized // ignore: cast_nullable_to_non_nullable
              as bool,
      chatMessageId: null == chatMessageId
          ? _value.chatMessageId
          : chatMessageId // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MediaImpl implements _Media {
  const _$MediaImpl(
      {required this.id,
      required this.url,
      required this.secureUrl,
      required this.thumbnailUrl,
      required this.size,
      required this.extension,
      required this.type,
      required this.publicId,
      required this.assetId,
      this.altText,
      this.caption,
      required this.width,
      required this.height,
      this.duration,
      required this.status,
      required this.metadata,
      required this.isOptimized,
      required this.chatMessageId,
      required this.createdAt});

  factory _$MediaImpl.fromJson(Map<String, dynamic> json) =>
      _$$MediaImplFromJson(json);

  @override
  final String id;
  @override
  final String url;
  @override
  final String secureUrl;
  @override
  final String thumbnailUrl;
  @override
  final int size;
  @override
  final String extension;
  @override
  final String type;
  @override
  final String publicId;
  @override
  final String assetId;
  @override
  final String? altText;
  @override
  final String? caption;
  @override
  final int width;
  @override
  final int height;
  @override
  final int? duration;
  @override
  final String status;
  @override
  final String metadata;
  @override
  final bool isOptimized;
  @override
  final int chatMessageId;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'Media(id: $id, url: $url, secureUrl: $secureUrl, thumbnailUrl: $thumbnailUrl, size: $size, extension: $extension, type: $type, publicId: $publicId, assetId: $assetId, altText: $altText, caption: $caption, width: $width, height: $height, duration: $duration, status: $status, metadata: $metadata, isOptimized: $isOptimized, chatMessageId: $chatMessageId, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MediaImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.secureUrl, secureUrl) ||
                other.secureUrl == secureUrl) &&
            (identical(other.thumbnailUrl, thumbnailUrl) ||
                other.thumbnailUrl == thumbnailUrl) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.extension, extension) ||
                other.extension == extension) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.publicId, publicId) ||
                other.publicId == publicId) &&
            (identical(other.assetId, assetId) || other.assetId == assetId) &&
            (identical(other.altText, altText) || other.altText == altText) &&
            (identical(other.caption, caption) || other.caption == caption) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.metadata, metadata) ||
                other.metadata == metadata) &&
            (identical(other.isOptimized, isOptimized) ||
                other.isOptimized == isOptimized) &&
            (identical(other.chatMessageId, chatMessageId) ||
                other.chatMessageId == chatMessageId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        url,
        secureUrl,
        thumbnailUrl,
        size,
        extension,
        type,
        publicId,
        assetId,
        altText,
        caption,
        width,
        height,
        duration,
        status,
        metadata,
        isOptimized,
        chatMessageId,
        createdAt
      ]);

  /// Create a copy of Media
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MediaImplCopyWith<_$MediaImpl> get copyWith =>
      __$$MediaImplCopyWithImpl<_$MediaImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MediaImplToJson(
      this,
    );
  }
}

abstract class _Media implements Media {
  const factory _Media(
      {required final String id,
      required final String url,
      required final String secureUrl,
      required final String thumbnailUrl,
      required final int size,
      required final String extension,
      required final String type,
      required final String publicId,
      required final String assetId,
      final String? altText,
      final String? caption,
      required final int width,
      required final int height,
      final int? duration,
      required final String status,
      required final String metadata,
      required final bool isOptimized,
      required final int chatMessageId,
      required final DateTime createdAt}) = _$MediaImpl;

  factory _Media.fromJson(Map<String, dynamic> json) = _$MediaImpl.fromJson;

  @override
  String get id;
  @override
  String get url;
  @override
  String get secureUrl;
  @override
  String get thumbnailUrl;
  @override
  int get size;
  @override
  String get extension;
  @override
  String get type;
  @override
  String get publicId;
  @override
  String get assetId;
  @override
  String? get altText;
  @override
  String? get caption;
  @override
  int get width;
  @override
  int get height;
  @override
  int? get duration;
  @override
  String get status;
  @override
  String get metadata;
  @override
  bool get isOptimized;
  @override
  int get chatMessageId;
  @override
  DateTime get createdAt;

  /// Create a copy of Media
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MediaImplCopyWith<_$MediaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

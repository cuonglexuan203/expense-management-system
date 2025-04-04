// media.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'media.freezed.dart';
part 'media.g.dart';

@freezed
class Media with _$Media {
  const factory Media({
    required String id,
    required String url,
    required String secureUrl,
    String? thumbnailUrl,
    required int size,
    required String extension,
    required String type,
    required String publicId,
    required String assetId,
    String? altText,
    String? caption,
    int? width,
    int? height,
    int? duration,
    required String status,
    required String metadata,
    required bool isOptimized,
    required int chatMessageId,
    required DateTime createdAt,
  }) = _Media;

  factory Media.fromJson(Map<String, dynamic> json) => _$MediaFromJson(json);
}

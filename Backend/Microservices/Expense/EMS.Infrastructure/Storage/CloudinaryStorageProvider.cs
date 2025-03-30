using CloudinaryDotNet;
using CloudinaryDotNet.Actions;
using EMS.Application.Common.Interfaces.Storage;
using EMS.Application.Common.Models;
using EMS.Infrastructure.Common.Options;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;

namespace EMS.Infrastructure.Storage
{
    public class CloudinaryStorageProvider : IStorageProvider
    {
        private readonly ILogger<CloudinaryStorageProvider> _logger;
        private readonly CloudinaryOptions _options;
        private readonly Cloudinary _cloudinary;

        public CloudinaryStorageProvider(
            ILogger<CloudinaryStorageProvider> logger,
            IOptions<CloudinaryOptions> options)
        {
            _logger = logger;
            _options = options.Value;

            // Initialize Cloudinary
            var account = new Account(
                _options.CloudName,
                _options.ApiKey,
                _options.ApiSecret);

            _cloudinary = new Cloudinary(account)
            {
                Api =
                {
                    Secure = _options.Secure,
                    ApiBaseAddress = _options.ApiBaseAddress,
                }
            };
        }
        public async Task<MediaUploadResult> UploadAsync(Stream fileStream, string fileName, string contentType, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Starting upload to cloudinary: {FileName}, {ContentType}", fileName, contentType);

                ResourceType resourceType = DetermineResourceType(contentType);

                BaseParams uploadParams = resourceType switch
                {
                    ResourceType.Image => new ImageUploadParams(),
                    ResourceType.Video => new VideoUploadParams(),
                    ResourceType.Raw => new RawUploadParams(),
                    _ => new ImageUploadParams()
                };

                SetupCommonUploadParams(uploadParams, fileName, fileStream);

                UploadResult result;

                switch (resourceType)
                {
                    case ResourceType.Image:
                        {
                            result = await _cloudinary.UploadAsync(uploadParams as ImageUploadParams, cancellationToken);
                            break;
                        }
                    case ResourceType.Video:
                        {
                            result = await _cloudinary.UploadAsync(uploadParams as VideoUploadParams, cancellationToken);
                            break;
                        }
                    case ResourceType.Raw:
                        {
                            result = await _cloudinary.UploadAsync(uploadParams as RawUploadParams, "auto", cancellationToken);
                            break;
                        }
                    default:
                        {
                            result = await _cloudinary.UploadAsync(uploadParams as ImageUploadParams, cancellationToken);
                            break;
                        }
                }

                if (result.Error != null)
                {
                    _logger.LogError("Cloudinary upload failed: {Error}", result.Error.Message);

                    return new()
                    {
                        Success = false,
                        Error = result.Error.Message,
                    };
                }

                var metadata = ExtractMetadata(result);

                string? thumbnailUrl = null;
                if (resourceType is ResourceType.Image or ResourceType.Video)
                {
                    thumbnailUrl = _cloudinary.Api.UrlImgUp
                        .Transform(new Transformation()
                            .Width(_options.ThumbnailWidth)
                            .Height(_options.ThumbnailHeight)
                            .Crop(_options.ThumbnailCrop))
                        .BuildUrl(result.PublicId);
                }

                _logger.LogInformation("Successfully uploaded to Cloudinary: {PublicId}", result.PublicId);

                return new()
                {
                    Success = true,
                    Url = result.Url?.AbsoluteUri,
                    SecureUrl = result.SecureUrl?.AbsoluteUri,
                    ThumbnailUrl = thumbnailUrl,
                    PublicId = result.PublicId,
                    AssetId = result.AssetId,
                    Format = result.Format,
                    Version = result.Version,
                    Size = result.Bytes,
                    ResourceType = resourceType.ToString(),
                    Metadata = metadata,
                };
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error uploading to Cloudinary");

                return new()
                {
                    Success = true,
                    Error = $"Upload failed: {ex.Message}",
                };
            }
        }



        public async Task<bool> DeleteAsync(string publicId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Deleting resource from Cloudinary: {PublicId}", publicId);

                var deletionParams = new DeletionParams(publicId)
                {
                    ResourceType = ResourceType.Auto,
                };

                var result = await _cloudinary.DestroyAsync(deletionParams);

                if (result.Error != null)
                {
                    _logger.LogError("Cloudinary deletion failed: {Error}", result.Error.Message);
                    return false;
                }

                _logger.LogInformation("Successfully deleted resource from Cloudinary: {PublicId}", publicId);

                return result.Result == "ok";
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error deleting from Cloudinary: {PublicId}", publicId);
                return false;
            }
        }

        public string GetUrl(string publicId, MediaTransformationOptions? options = null)
        {
            var transformation = CreateTransformation(options);

            var urlBuilder = _options.Secure
                ? _cloudinary.Api.UrlImgUp.Secure()
                : _cloudinary.Api.UrlImgUp;

            if (_options.CName && !string.IsNullOrEmpty(_options.CNameSubdomain))
            {
                urlBuilder = urlBuilder.CName(_options.CNameSubdomain);
            }

            urlBuilder = urlBuilder.Transform(transformation);

            if (_options.UseSignedUrls)
            {
                urlBuilder = urlBuilder.Signed(true);
            }

            return urlBuilder.BuildUrl(publicId);
        }

        public async Task<MediaTransformationResult> TransformAsync(
            string publicId,
            MediaTransformationOptions options,
            CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Creating explicit transformation for: {PublicId}", publicId);

                var transformation = CreateTransformation(options);

                var explicitParams = new ExplicitParams(publicId)
                {
                    EagerTransforms = { transformation },
                    Type = "upload",
                    Overwrite = false,
                };

                var result = await _cloudinary.ExplicitAsync(explicitParams, cancellationToken);

                if (result.Error != null)
                {
                    _logger.LogError("Transformation failed: {Error}", result.Error.Message);

                    return new()
                    {
                        Success = false,
                        Error = result.Error.Message,
                    };
                }

                _logger.LogInformation("Successfully created transformation for: {PublicId}", publicId);

                return new()
                {
                    Success = true,
                    Url = result.SecureUrl?.AbsoluteUri,
                    PublicId = publicId,
                };
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error creating transformation: {PublicId}", publicId);

                return new()
                {
                    Success = false,
                    Error = ex.Message,
                };
            }
        }

        public async Task<Dictionary<string, string>> GetMetadataAsync(string publicId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Retrieving metadata for: {PublicId}", publicId);

                var result = await _cloudinary.GetResourceAsync(new GetResourceParams(publicId), cancellationToken);

                if (result.Error != null)
                {
                    _logger.LogError("Error retrieving metadata: {Error}", result.Error.Message);

                    return [];
                }

                var metadata = new Dictionary<string, string>
                {
                    ["publicId"] = result.PublicId,
                    ["version"] = result.Version,
                    ["format"] = result.Format,
                    ["resourceType"] = result.ResourceType.ToString(),
                    ["type"] = result.Type,
                    ["createdAt"] = result.CreatedAt,
                    ["bytes"] = result.Bytes.ToString(),
                    ["width"] = result.Width.ToString(),
                    ["height"] = result.Height.ToString(),
                };

                if (result.ResourceType == ResourceType.Video && result.JsonObj != null)
                {
                    if (result.JsonObj["duration"] != null)
                        metadata["duration"] = result.JsonObj["duration"]!.ToString();

                    if (result.JsonObj["frame_rate"] != null)
                        metadata["frameRate"] = result.JsonObj["frame_rate"]!.ToString();
                }

                if (result.ImageMetadata != null)
                {
                    foreach (var item in result.ImageMetadata)
                    {
                        metadata[item.Key] = item.Value;
                    }
                }

                return metadata;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error retrieving metadata for: {PublicId}", publicId);

                return [];
            }
        }

        #region Helper Methods
        private Dictionary<string, object> ExtractMetadata(UploadResult result)
        {
            var metadata = new Dictionary<string, object>()
            {
                ["publicId"] = result.PublicId,
                ["format"] = result.Format ?? string.Empty,
                ["version"] = result.Version
            };

            if (result.JsonObj["width"] != null)
            {
                metadata["width"] = result.JsonObj["width"]!;
            }

            if (result.JsonObj["height"] != null)
            {
                metadata["height"] = result.JsonObj["height"]!;
            }

            if (result.JsonObj["duration"] != null)
            {
                metadata["duration"] = result.JsonObj["duration"]!;
            }

            if (result.JsonObj["resource_type"] != null)
            {
                metadata["resource_type"] = result.JsonObj["resource_type"]!;
            }

            return metadata;
        }

        private void SetupCommonUploadParams(BaseParams uploadParams, string fileName, Stream fileStream)
        {
            var fileProperty = uploadParams.GetType().GetProperty("File");
            fileProperty?.SetValue(uploadParams, new FileDescription(fileName, fileStream));

            var folderProperty = uploadParams.GetType().GetProperty("Folder");
            folderProperty?.SetValue(uploadParams, _options.FolderPath);

            var useFilenameProperty = uploadParams.GetType().GetProperty("UseFilename");
            useFilenameProperty?.SetValue(uploadParams, true);

            var uniqueFilenameProperty = uploadParams.GetType().GetProperty("UniqueFilename");
            uniqueFilenameProperty?.SetValue(uploadParams, true);

            var overwriteProperty = uploadParams.GetType().GetProperty("Overwrite");
            overwriteProperty?.SetValue(uploadParams, false);

            var accessModeProperty = uploadParams.GetType().GetProperty("AccessMode");
            accessModeProperty?.SetValue(uploadParams, "public");

            if (_options.AutoTagging)
            {
                var taggingProperty = uploadParams.GetType().GetProperty("AutoTagging");
                taggingProperty?.SetValue(uploadParams, 0.7); // 70% confidence threshold
            }
        }

        private ResourceType DetermineResourceType(string contentType)
        {
            if (string.IsNullOrEmpty(contentType))
                return ResourceType.Auto;

            if (contentType.StartsWith("image/"))
                return ResourceType.Image;

            if (contentType.StartsWith("video/"))
                return ResourceType.Video;

            if (contentType.StartsWith("audio/"))
                return ResourceType.Raw;

            return ResourceType.Auto;
        }

        private Transformation CreateTransformation(MediaTransformationOptions? options)
        {
            var transformation = new Transformation();

            if (options == null)
                return transformation;

            if (options.Width.HasValue)
                transformation.Width(options.Width.Value);

            if (options.Height.HasValue)
                transformation.Height(options.Height.Value);

            if (!string.IsNullOrEmpty(options.Crop))
                transformation.Crop(options.Crop);

            if (!string.IsNullOrEmpty(options.Gravity))
                transformation.Gravity(options.Gravity);

            if (!string.IsNullOrWhiteSpace(options.Format))
                transformation.FetchFormat(options.Format);
            else if (_options.AutoOptimizeImages)
                transformation.FetchFormat(_options.DefaultImageFormat);

            if (options.Quality.HasValue)
                transformation.Quality(options.Quality.Value);
            else if (_options.DefaultQuality.HasValue)
                transformation.Quality(_options.DefaultQuality.Value);

            if (!string.IsNullOrEmpty(options.Effect))
                transformation.Effect(options.Effect);

            if (options.AutoOptimize == true || _options.AutoOptimizeImages)
                transformation.Flags("auto_optimizes");

            if (options.Radius.HasValue)
                transformation.Radius(options.Radius.Value);

            if (!string.IsNullOrEmpty(options.Background))
                transformation.Background(options.Background);

            if (options.Opacity.HasValue)
                transformation.Opacity(options.Opacity.Value);

            if (options.Progressive == true)
                transformation.Flags("progressive");

            if (options.CustomParams != null)
            {
                foreach (var param in options.CustomParams)
                {
                    transformation.Add(param.Key, param.Value);
                }
            }

            return transformation;
        }
        #endregion
    }
}

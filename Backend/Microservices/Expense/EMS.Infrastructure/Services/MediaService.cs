using AutoMapper;
using AutoMapper.QueryableExtensions;
using EMS.Application.Common.DTOs;
using EMS.Application.Common.Interfaces.DbContext;
using EMS.Application.Common.Interfaces.Services;
using EMS.Application.Common.Interfaces.Storage;
using EMS.Application.Common.Models;
using EMS.Core.Entities;
using EMS.Core.Enums;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using System.Text.Json;
using Microsoft.Extensions.Options;
using EMS.Infrastructure.Common.Options;
using EMS.Application.Common.Utils;

namespace EMS.Infrastructure.Services
{
    public class MediaService : IMediaService
    {
        private readonly ILogger<MediaService> _logger;
        private readonly IStorageProvider _storageProvider;
        private readonly CloudinaryOptions _cloudinaryOptions;
        private readonly IApplicationDbContext _context;
        private readonly IMapper _mapper;

        public MediaService(
            ILogger<MediaService> logger,
            IStorageProvider storageProvider,
            IOptions<CloudinaryOptions> cloudinaryOptions,
            IApplicationDbContext context,
            IMapper mapper)
        {
            _logger = logger;
            _storageProvider = storageProvider;
            _cloudinaryOptions = cloudinaryOptions.Value;
            _context = context;
            _mapper = mapper;
        }
        public async Task<MediaDto> UploadMediaAsync(
            Media? media,
            Stream fileStream,
            string fileName,
            string contentType,
            FileType? mediaType = null,
            CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Beginning media upload process: {FileName}, {ContentType}", fileName, contentType);

                if (mediaType == null)
                {
                    mediaType = FileUtil.GetFileType(contentType);
                }

                media ??= new Media();
                media.FileName = fileName;
                media.ContentType = contentType;
                media.Extension = Path.GetExtension(fileName).Trim('.').ToLowerInvariant();
                media.Type = mediaType.Value;
                media.Status = MediaStatus.Uploading;
                media.Size = fileStream.Length;

                _context.Media.Add(media);
                await _context.SaveChangesAsync();

                _logger.LogInformation("Created pending record with ID: {MediaId}", media.Id);

                try
                {
                    if (fileStream.CanSeek)
                    {
                        fileStream.Position = 0;
                    }

                    var uploadResult = await _storageProvider.UploadAsync(fileStream, fileName, contentType, cancellationToken);

                    if (!uploadResult.Success)
                    {
                        _logger.LogError("CDN upload failed: {Error}", uploadResult.Error);

                        media.Status = MediaStatus.Failed;
                        await _context.SaveChangesAsync();

                        throw new ApplicationException($"Failed to upload media: {uploadResult.Error}");
                    }

                    media.Url = uploadResult.Url ?? string.Empty;
                    media.SecureUrl = uploadResult.SecureUrl;
                    media.ThumbnailUrl = uploadResult.ThumbnailUrl;
                    media.PublicId = uploadResult.PublicId;
                    media.AssetId = uploadResult.AssetId;
                    media.Status = MediaStatus.Active;
                    media.IsOptimized = true;
                    media.Metadata = JsonSerializer.Serialize(uploadResult.Metadata);

                    if (uploadResult.Metadata?.TryGetValue("width", out var width) == true)
                        media.Width = Convert.ToInt32(width);

                    if (uploadResult.Metadata?.TryGetValue("height", out var height) == true)
                        media.Height = Convert.ToInt32(height);

                    if (uploadResult.Metadata?.TryGetValue("duration", out var duration) == true)
                        media.Duration = Convert.ToInt32(duration);

                    await _context.SaveChangesAsync();

                    _logger.LogInformation("Successfully uploaded media: {MediaId}, {PublicId}", media.Id, media.PublicId);

                    return _mapper.Map<MediaDto>(media);
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "Error during media upload process");

                    media.Status = MediaStatus.Failed;
                    await _context.SaveChangesAsync();

                    throw new ApplicationException($"Media upload failed: {ex.Message}", ex);
                }

            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unhandled error during media upload: {Message}", ex.Message);
                throw;
            }
        }

        public Task<MediaDto> UploadMediaAsync(
            Stream fileStream,
            string fileName,
            string contentType,
            FileType? mediaType = null,
            CancellationToken cancellationToken = default)
        {
            return UploadMediaAsync(null, fileStream, fileName, contentType, mediaType, cancellationToken);
        }

        public async Task<bool> DeleteAsync(Guid id, CancellationToken cancellationToken = default)
        {
            var media = await _context.Media
                .FirstOrDefaultAsync(e => e.Id == id && !e.IsDeleted);

            if (media == null)
            {
                _logger.LogWarning("Attempted to delete non-existent media: {MediaId}", id);

                return false;
            }

            try
            {
                if (!string.IsNullOrEmpty(media.PublicId))
                {
                    _logger.LogInformation("Deleting media from CDN: Id {MediaId}, Public Id {PublicId}", id, media.PublicId);

                    var deletedResult = await _storageProvider.DeleteAsync(media.PublicId, cancellationToken);

                    if (!deletedResult)
                    {
                        _logger.LogWarning("Failed to delete media from CDN: Id {MediaId}, Public Id {PublicId}", id, media.PublicId);
                    }
                }

                _context.Media.Remove(media);
                await _context.SaveChangesAsync();

                _logger.LogInformation("Successfully deleted media: {MediaId}", id);

                return true;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error deleting media: {MediaId}", id);

                return false;
            }
        }

        public async Task<MediaDto?> GetById(Guid id, CancellationToken cancellationToken = default)
        {
            var mediaDto = await _context.Media
                .AsNoTracking()
                .Where(e => e.Id == id && !e.IsDeleted)
                .ProjectTo<MediaDto?>(_mapper.ConfigurationProvider)
                .FirstOrDefaultAsync();

            return mediaDto;
        }

        public string GetOptimizedUrl(Media media, int? width = null, int? height = null, string? format = null)
        {
            if (string.IsNullOrEmpty(media.PublicId))
            {
                return media.Url;
            }

            var options = new MediaTransformationOptions
            {
                Width = width,
                Height = height,
                Format = format,
                AutoOptimize = true
            };

            return _storageProvider.GetUrl(media.PublicId, options);
        }

        public string GetThumbnailUrl(Media media)
        {
            if (!string.IsNullOrEmpty(media.ThumbnailUrl))
            {
                return media.ThumbnailUrl;
            }

            if (string.IsNullOrEmpty(media.PublicId))
            {
                return media.Url;
            }

            var options = new MediaTransformationOptions
            {
                Width = _cloudinaryOptions.ThumbnailWidth,
                Height = _cloudinaryOptions.ThumbnailHeight,
                Crop = _cloudinaryOptions.ThumbnailCrop,
                Quality = _cloudinaryOptions.DefaultQuality,
                AutoOptimize = true,
            };

            return _storageProvider.GetUrl(media.PublicId, options);
        }
    }
}

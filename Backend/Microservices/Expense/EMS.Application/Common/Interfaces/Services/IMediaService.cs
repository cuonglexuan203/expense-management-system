using EMS.Application.Common.DTOs;
using EMS.Core.Entities;
using EMS.Core.Enums;

namespace EMS.Application.Common.Interfaces.Services
{
    public interface IMediaService
    {
        /// <summary>
        /// Uploads media file to storage and persists database record
        /// </summary>
        Task<MediaDto> UploadMediaAsync(
            Media? media,
            Stream fileStream,
            string fileName,
            string contentType,
            MediaType? mediaType = null,
            CancellationToken cancellationToken = default);

        /// <summary>
        /// Uploads media file to storage and creates database record
        /// </summary>
        Task<MediaDto> UploadMediaAsync(
            Stream fileStream,
            string fileName,
            string contentType,
            MediaType? mediaType = null,
            CancellationToken cancellationToken = default);

        /// <summary>
        /// Deletes media from storage and database
        /// </summary>
        Task<bool> DeleteAsync(Guid id, CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves media by its ID
        /// </summary>
        Task<MediaDto?> GetById(Guid id, CancellationToken cancellationToken = default);

        /// <summary>
        /// Gets optimized URL for the media with optional transformations
        /// </summary>
        string GetOptimizedUrl(Media media, int? width = null, int? height = null, string? format = null);

        /// <summary>
        /// Gets thumbnail URL for the media
        /// </summary>
        string GetThumbnailUrl(Media media);
    }
}

using EMS.Application.Common.Models;

namespace EMS.Application.Common.Interfaces.Storage
{
    public interface IStorageProvider
    {
        Task<MediaUploadResult> UploadAsync(Stream fileStream, string fileName, string contentType, CancellationToken cancellationToken = default);
        Task<bool> DeleteAsync(string publicId, CancellationToken cancellationToken = default);
        string GetUrl(string publicId, MediaTransformationOptions? options = null);
        Task<MediaTransformationResult> TransformAsync(string publicId, MediaTransformationOptions options, CancellationToken cancellationToken = default);
        Task<Dictionary<string, string>> GetMetadataAsync(string publicId, CancellationToken cancellationToken = default);
    }
}
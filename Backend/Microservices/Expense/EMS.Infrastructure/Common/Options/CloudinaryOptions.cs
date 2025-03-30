namespace EMS.Infrastructure.Common.Options
{
    public class CloudinaryOptions
    {
        public const string Cloudinary = "Cloudinary";
        public string CloudName { get; set; } = string.Empty;
        public string ApiKey { get; set; } = string.Empty;
        public string ApiSecret { get; set; } = string.Empty;
        public string ApiBaseAddress { get; set; } = "https://api.cloudinary.com";
        public string FolderPath { get; set; } = "expense-manager";
        public bool Secure { get; set; } = true;
        public bool CName { get; set; } = false;
        public string? CNameSubdomain { get; set; }
        public bool UseSignedUrls { get; set; } = false;
        //public int SignedUrlExpiration { get; set; } = 3600;
        public bool AutoTagging { get; set; } = false;
        public int? DefaultQuality { get; set; } = 80;
        public string DefaultImageFormat { get; set; } = "auto";
        public bool AutoOptimizeImages { get; set; } = true;
        public int ThumbnailWidth { get; set; } = 200;
        public int ThumbnailHeight { get; set; } = 200;
        public string ThumbnailCrop { get; set; } = "fill";
    }
}

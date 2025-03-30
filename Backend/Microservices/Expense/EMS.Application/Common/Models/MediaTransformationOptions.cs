namespace EMS.Application.Common.Models
{
    public class MediaTransformationOptions
    {
        public int? Width { get; set; }
        public int? Height { get; set; }
        public string? Format { get; set; }
        public int? Quality { get; set; }
        public string? Crop { get; set; }
        public string? Gravity { get; set; }
        public string? Effect { get; set; }
        public bool? AutoOptimize { get; set; }
        public int? Radius { get; set; } // For rounded corners
        public string? Background { get; set; }
        public int? Opacity { get; set; }
        public bool? Progressive { get; set; } // For progressive JPEGs
        public Dictionary<string, string>? CustomParams { get; set; }
    }
}
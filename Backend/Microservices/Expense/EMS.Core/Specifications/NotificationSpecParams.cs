using EMS.Core.Enums;
using EMS.Core.Specifications.Common;

namespace EMS.Core.Specifications
{
    public class NotificationSpecParams : PaginationSpecParams
    {
        public int? Id { get; set; }
        public NotificationType? Type { get; set; }
        public string? Text { get; set; } // Filter by both Title and Body
        public string? Title { get; set; }
        public string? Body { get; set; }
        public NotificationStatus? Status { get; set; }
        public DateTimeOffset? Since { get; set; }
        public DateTimeOffset? Until { get; set; }
    }
}

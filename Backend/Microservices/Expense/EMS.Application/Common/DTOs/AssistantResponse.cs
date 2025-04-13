using EMS.Core.Enums;

namespace EMS.Application.Common.DTOs
{
    public class AssistantResponse
    {
        public string? LlmContent { get; set; }
        public MessageRole Type { get; set; }
        public string? Name { get; set; }
        public FinancialResponse? FinancialResponse { get; set; }
        public EventResponse? EventResponse { get; set; }
    }
}

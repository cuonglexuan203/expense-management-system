namespace EMS.Application.Common.DTOs.Dispatcher
{
    public class EmailDispatchRequest
    {
        public string To { get; set; } = default!;
        public string Subject { get; set; } = default!;
        public string HtmlBody { get; set; } = default!;

        public EmailDispatchRequest()
        {
            
        }

        public EmailDispatchRequest(string to, string subject, string htmlBody)
        {
            To = to;
            Subject = subject;
            HtmlBody = htmlBody;
        }
    }
}

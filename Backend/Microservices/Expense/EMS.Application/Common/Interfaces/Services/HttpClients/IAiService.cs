using EMS.Application.Common.DTOs;
using EMS.Application.Common.Interfaces.Services.HttpClients.Common;

namespace EMS.Application.Common.Interfaces.Services.HttpClients
{
    public interface IAiService : IHttpClientService
    {
        Task<MessageExtractionResponse> ExtractTransactionAsync(MessageExtractionRequest request); // extract from text
        Task<MessageExtractionResponse> ExtractTransactionFromImagesAsync(MessageWithFilesExtractionRequest request);
        Task<MessageExtractionResponse> ExtractTransactionFromAudiosAsync(MessageWithFilesExtractionRequest request);
        Task<AssistantResponse> ChatWithAssistant(AssistantRequest request);
    }
}

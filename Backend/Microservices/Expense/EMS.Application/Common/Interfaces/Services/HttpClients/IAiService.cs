using EMS.Application.Common.DTOs;
using EMS.Application.Common.Interfaces.Services.HttpClients.Common;

namespace EMS.Application.Common.Interfaces.Services.HttpClients
{
    public interface IAiService : IHttpClientService
    {
        #region Transaction analysis
        Task<MessageAnalysisResponse> AnalyzeTextMessageAsync(MessageAnalysisRequest request); // extract from text
        Task<MessageAnalysisResponse> AnalyzeImageMessageAsync(MessageWithFilesAnalysisRequest request);
        Task<MessageAnalysisResponse> AnalyzeAudioMessageAsync(MessageWithFilesAnalysisRequest request);
        #endregion

        Task<AssistantResponse> ChatWithAssistant(AssistantRequest request);
    }
}
    
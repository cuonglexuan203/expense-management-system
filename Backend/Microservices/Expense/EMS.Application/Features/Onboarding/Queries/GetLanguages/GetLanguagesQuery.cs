using EMS.Application.Common.Attributes;
using EMS.Application.Common.Utils;
using EMS.Core.Enums;
using EMS.Core.Extensions;
using MediatR;
using Microsoft.Extensions.Logging;

namespace EMS.Application.Features.Onboarding.Queries.GetLanguages
{
    [CacheableQuery(CacheKeyGenerator.GeneralKeys.Languages)]
    public record GetLanguagesQuery : IRequest<List<Language>>;

    public class GetLanguagesQueryHandler : IRequestHandler<GetLanguagesQuery, List<Language>>
    {
        private readonly ILogger<GetLanguagesQueryHandler> _logger;

        public GetLanguagesQueryHandler(
            ILogger<GetLanguagesQueryHandler> logger)
        {
            _logger = logger;
        }
        public Task<List<Language>> Handle(GetLanguagesQuery request, CancellationToken cancellationToken)
        {
            var languageCodes = Enum.GetValues<LanguageCode>();

            var result = new List<Language>();
            foreach (var languageCode in languageCodes)
            {
                result.Add(new Language(languageCode.GetDescription(), languageCode.ToString()));
            }

            return Task.FromResult(result);
        }
    }
}

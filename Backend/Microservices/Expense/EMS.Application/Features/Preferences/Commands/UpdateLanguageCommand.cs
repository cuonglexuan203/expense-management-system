using AutoMapper;
using EMS.Application.Common.Exceptions;
using EMS.Application.Common.Interfaces.DbContext;
using EMS.Application.Common.Interfaces.Services;
using EMS.Application.Features.Preferences.Dtos;
using EMS.Core.Enums;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace EMS.Application.Features.Preferences.Commands
{
    public record UpdateLanguageCommand(string LanguageCode) : IRequest<UserPreferenceDto>;

    public class UpdateLanguageCommandHandler : IRequestHandler<UpdateLanguageCommand, UserPreferenceDto>
    {
        private readonly ILogger<UpdateLanguageCommandHandler> _logger;
        private readonly ICurrentUserService _currentUserService;
        private readonly IApplicationDbContext _context;
        private readonly IMapper _mapper;

        public UpdateLanguageCommandHandler(
            ILogger<UpdateLanguageCommandHandler> logger,
            ICurrentUserService currentUserService,
            IApplicationDbContext context,
            IMapper mapper)
        {
            _logger = logger;
            _currentUserService = currentUserService;
            _context = context;
            _mapper = mapper;
        }
        public async Task<UserPreferenceDto> Handle(UpdateLanguageCommand request, CancellationToken cancellationToken)
        {
            var userId = _currentUserService.Id!;

            var userPreferences = await _context.UserPreferences
                .FirstOrDefaultAsync(e => !e.IsDeleted && e.UserId == userId)
                ?? throw new NotFoundException($"User preferences of user {userId} not found.");

            if (!Enum.TryParse<LanguageCode>(request.LanguageCode, out var languageCode))
            {
                throw new InvalidOperationException($"Invalid language code: {request.LanguageCode}");
            }

            userPreferences.LanguageCode = languageCode;
            await _context.SaveChangesAsync();

            return _mapper.Map<UserPreferenceDto>(userPreferences);
        }
    }
}

using EMS.Application.Common.Exceptions;
using EMS.Application.Common.Interfaces.Services;
using EMS.Application.Features.Profiles.Commands.UpdateProfile;
using EMS.Application.Features.Profiles.Dtos;
using EMS.Application.Features.Profiles.Services;
using EMS.Core.Exceptions;
using EMS.Infrastructure.Persistence.DbContext;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace EMS.Infrastructure.Services
{
    public class ProfileService : IProfileService
    {
        private readonly ILogger<ProfileService> _logger;
        private readonly ApplicationDbContext _context;
        private readonly IIdentityService _identityService;
        private readonly IUserPreferenceService _userPreferenceService;

        public ProfileService(
            ILogger<ProfileService> logger,
            ApplicationDbContext context,
            IIdentityService identityService,
            IUserPreferenceService userPreferenceService)
        {
            _logger = logger;
            _context = context;
            _identityService = identityService;
            _userPreferenceService = userPreferenceService;
        }
        public async Task<ProfileVm> GetUserProfileAsync(string userId, CancellationToken cancellationToken = default)
        {
            var user = await _identityService.GetUserAsync(userId, cancellationToken)
                ?? throw new NotFoundException($"User {userId} not found");

            var userPreferences = await _userPreferenceService.GetUserPreferenceByUserIdAsync(userId);

            var profileVm = new ProfileVm
            {
                User = user,
                UserPreference = userPreferences,
            };

            return profileVm;
        }

        public async Task<ProfileVm> UpdateProfileAsync(string userId, UpdateProfileCommand values, CancellationToken cancellationToken = default)
        {
            var strategy = _context.Database.CreateExecutionStrategy();
            await strategy.ExecuteAsync(async () =>
            {
                await using var dbTransaction = await _context.Database.BeginTransactionAsync(cancellationToken);
                try
                {
                    var result = await _identityService.UpdateUserAsync(userId, new(values.FullName, values.Avatar, values.Email));
                    if (!result.Succeeded)
                    {
                        await dbTransaction.RollbackAsync(cancellationToken);

                        throw new ServerException($"An error occurred while updating user {userId}");
                    }

                    if (!string.IsNullOrEmpty(values.TimeZoneId))
                    {
                        var timeZoneId = await _userPreferenceService.UpdateTimeZoneIdAsync(userId, values.TimeZoneId);
                    }

                    await dbTransaction.CommitAsync(cancellationToken);
                }
                catch (Exception ex)
                {
                    _logger.LogError("An error occurred while updating profile of user {UserId}: {ErrorMsg}", userId, ex.Message);
                    _logger.LogInformation("Rolling back");

                    await dbTransaction.RollbackAsync(cancellationToken);

                    throw;
                }
            });

            return await GetUserProfileAsync(userId);
        }
    }
}

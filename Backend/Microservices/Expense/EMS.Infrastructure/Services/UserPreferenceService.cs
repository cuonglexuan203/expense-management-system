using EMS.Application.Common.Interfaces.DbContext;
using EMS.Application.Common.Interfaces.Services;
using EMS.Application.Common.Utils;
using EMS.Core.Entities;
using EMS.Core.Exceptions;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace EMS.Infrastructure.Services
{
    public class UserPreferenceService : IUserPreferenceService
    {
        private readonly ILogger<UserPreferenceService> _logger;
        private readonly IApplicationDbContext _context;
        private readonly IDistributedCacheService _cacheService;
        private readonly ICurrentUserService _currentUserService;

        public UserPreferenceService(
            ILogger<UserPreferenceService> logger,
            IApplicationDbContext context,
            IDistributedCacheService cacheService,
            ICurrentUserService currentUserService)
        {
            _logger = logger;
            _context = context;
            _cacheService = cacheService;
            _currentUserService = currentUserService;
        }

        public async Task<UserPreference> GetUserPreferenceAsync()
        {
            var userId = _currentUserService.Id!;

            return await _cacheService.GetOrSetAsync(
                CacheKeyGenerator.GenerateForUser(CacheKeyGenerator.GeneralKeys.UserPreference, userId),
                async () => await _context.UserPreferences
                .AsNoTracking()
                .Where(e => !e.IsDeleted && e.UserId == userId)
                .FirstOrDefaultAsync() ?? throw new ServerException($"User preference of user id {userId} not found."));
        }
    }
}

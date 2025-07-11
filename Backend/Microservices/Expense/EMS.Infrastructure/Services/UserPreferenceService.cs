﻿using AutoMapper;
using AutoMapper.QueryableExtensions;
using EMS.Application.Common.Exceptions;
using EMS.Application.Common.Interfaces.DbContext;
using EMS.Application.Common.Interfaces.Services;
using EMS.Application.Common.Utils;
using EMS.Application.Features.Preferences.Dtos;
using EMS.Core.Constants;
using EMS.Core.Entities;
using EMS.Core.Enums;
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
        private readonly IMapper _mapper;

        public UserPreferenceService(
            ILogger<UserPreferenceService> logger,
            IApplicationDbContext context,
            IDistributedCacheService cacheService,
            ICurrentUserService currentUserService,
            IMapper mapper)
        {
            _logger = logger;
            _context = context;
            _cacheService = cacheService;
            _currentUserService = currentUserService;
            _mapper = mapper;
        }

        public async Task<UserPreferenceDto> GetUserPreferenceAsync(CancellationToken cancellationToken = default)
        {
            var userId = _currentUserService.Id!;

            return await GetUserPreferenceByUserIdAsync(userId);
        }

        public async Task<UserPreferenceDto> GetUserPreferenceByUserIdAsync(string userId)
        {
            return await _cacheService.GetOrSetAsync(
                CacheKeyGenerator.GenerateForUser(CacheKeyGenerator.GeneralKeys.UserPreference, userId),
                async () => await _context.UserPreferences
                .AsNoTracking()
                .Where(e => !e.IsDeleted && e.UserId == userId)
                .ProjectTo<UserPreferenceDto>(_mapper.ConfigurationProvider)
                .FirstOrDefaultAsync() ?? throw new ServerException($"User preference of user id {userId} not found."));
        }

        public async Task CreateDefaultUserPreferencesAsync(string userId, string timeZoneId = TimeZoneIds.Asia_Ho_Chi_Minh, CancellationToken cancellationToken = default)
        {
            try
            {
                var systemSettings = await _context.SystemSettings
                    .ToDictionaryAsync(s => s.SettingKey, s => s, cancellationToken);

                var userPreference = new UserPreference
                {
                    UserId = userId,
                    LanguageCode = MapSystemSettingValue(systemSettings, nameof(UserPreference.LanguageCode), LanguageCode.EN),
                    CurrencyCode = MapSystemSettingValue(systemSettings, nameof(UserPreference.CurrencyCode), CurrencyCode.USD),
                    ConfirmationMode = MapSystemSettingValue(systemSettings, nameof(UserPreference.ConfirmationMode), ConfirmationMode.Manual),
                    TimeZoneId = timeZoneId,
                };

                _context.UserPreferences.Add(userPreference);
                await _context.SaveChangesAsync(cancellationToken);

                _logger.LogInformation("Created default preferences for user {userId}", userId);
            }
            catch (Exception)
            {
                _logger.LogError("Error creating default preferences for user {userId}", userId);

                throw;
            }
        }

        private T MapSystemSettingValue<T>(Dictionary<string, SystemSetting> settings, string key, T defaultValue)
        {
            if (!settings.TryGetValue(key, out var setting) || string.IsNullOrEmpty(setting.SettingValue))
                return defaultValue;

            try
            {
                switch (setting.DataType)
                {
                    case DataType.String:
                        if (typeof(T) == typeof(string))
                            return (T)(object)setting.SettingValue;
                        break;

                    case DataType.Number:
                        if (typeof(T) == typeof(int) && int.TryParse(setting.SettingValue, out var intValue))
                            return (T)(object)intValue;
                        else if (typeof(T) == typeof(float) && float.TryParse(setting.SettingValue, out var floatValue))
                            return (T)(object)floatValue;
                        else if (typeof(T) == typeof(decimal) && decimal.TryParse(setting.SettingValue, out var decimalValue))
                            return (T)(object)decimalValue;
                        else if (typeof(T) == typeof(double) && double.TryParse(setting.SettingValue, out var doubleValue))
                            return (T)(object)doubleValue;
                        break;

                    case DataType.Boolean:
                        if (typeof(T) == typeof(bool) && bool.TryParse(setting.SettingValue, out var boolValue))
                            return (T)(object)boolValue;
                        break;

                    case DataType.Enum:
                        if (typeof(T).IsEnum && Enum.TryParse(typeof(T), setting.SettingValue, true, out var enumValue))
                            return (T)enumValue;
                        break;

                    default:
                        _logger.LogWarning(
                            "Unsupported DataType {dataType} for setting {key}. Expected one of: String, Number, Boolean, Enum. Using default value.",
                            setting.DataType, key);
                        break;
                }
            }
            catch (Exception ex)
            {
                _logger.LogWarning(ex, "Failed to convert setting {key} with value '{value}' to type {type}. Using default value.",
                    key, setting.SettingValue, typeof(T).Name);
            }

            return defaultValue;
        }

        public async Task<string?> GetTimeZoneIdAsync(string userId, CancellationToken cancellationToken = default)
        {
            var timeZoneId = await _context.UserPreferences
                .AsNoTracking()
                .Where(e => !e.IsDeleted && e.UserId == userId)
                .Select(e => e.TimeZoneId)
                .FirstOrDefaultAsync(cancellationToken);

            return timeZoneId;
        }

        public async Task<string?> UpdateTimeZoneIdAsync(string userId, string timeZoneId, CancellationToken cancellationToken = default)
        {
            var userPreference = await _context.UserPreferences
                .Where(e => !e.IsDeleted && e.UserId == userId)
                .FirstOrDefaultAsync(cancellationToken)
                ?? throw new NotFoundException($"User preference of user {userId} not found");

            userPreference.TimeZoneId = timeZoneId;

            await _context.SaveChangesAsync();

            return timeZoneId;
        }
    }
}

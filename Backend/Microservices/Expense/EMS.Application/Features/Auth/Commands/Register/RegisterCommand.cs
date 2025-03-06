using EMS.Application.Common.Exceptions;
using EMS.Application.Common.Interfaces.DbContext;
using EMS.Application.Common.Interfaces.Services;
using EMS.Core.Constants;
using EMS.Core.Entities;
using EMS.Core.Enums;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace EMS.Application.Features.Auth.Commands.Register
{
    public class RegisterCommand : IRequest<RegisterDto>
    {
        public string Email { get; set; } = default!;
        public string Password { get; set; } = default!;
    }

    public class RegisterCommandHandler : IRequestHandler<RegisterCommand, RegisterDto>
    {
        private readonly ILogger<RegisterCommandHandler> _logger;
        private readonly IIdentityService _identityService;
        private readonly IApplicationDbContext _dbContext;

        public RegisterCommandHandler(
            ILogger<RegisterCommandHandler> logger,
            IIdentityService identityService,
            IApplicationDbContext dbContext)
        {
            _logger = logger;
            _identityService = identityService;
            _dbContext = dbContext;
        }

        public async Task<RegisterDto> Handle(RegisterCommand request, CancellationToken cancellationToken)
        {
            var (result, userId) = await _identityService.CreateUserAsync(request.Email, request.Password);

            if (!result.Succeeded)
            {
                throw new BadRequestException(string.Join(", ", result.Errors));
            }

            var roleResult = await _identityService.AddToRoleAsync(userId, Roles.User);

            if (!roleResult.Succeeded)
            {
                _logger.LogError("Failed to add user {0} to role {1}", request.Email, Roles.User);
                throw new Exception(string.Join(", ", roleResult.Errors));
            }

            await CreateUserPreferencesAsync(userId, cancellationToken);

            _logger.LogInformation("User {0} registered", request.Email);
            return new(userId);
        }

        private async Task CreateUserPreferencesAsync(string userId, CancellationToken cancellationToken)
        {
            try
            {
                var systemSettings = await _dbContext.SystemSettings
                    .ToDictionaryAsync(s => s.SettingKey, s => s, cancellationToken);

                var userPreference = new UserPreference
                {
                    UserId = userId,
                    Language = MapSystemSettingValue(systemSettings, nameof(UserPreference.Language), Language.EN),
                    Currency = MapSystemSettingValue(systemSettings, nameof(UserPreference.Currency), Currency.USD),
                    RequiresConfirmation = MapSystemSettingValue(systemSettings, nameof(UserPreference.RequiresConfirmation), true)
                };

                _dbContext.UserPreferences.Add(userPreference);
                await _dbContext.SaveChangesAsync(cancellationToken);

                _logger.LogInformation("Created default preferences for user {userId}", userId);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error creating default preferences for user {userId}", userId);
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
    }
}
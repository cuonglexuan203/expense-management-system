using EMS.Application.Common.Exceptions;
using EMS.Application.Common.Interfaces.Services;
using EMS.Core.Constants;
using EMS.Core.Entities;
using EMS.Core.Enums;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using System.Reflection;
using EMS.Application.Common.Interfaces.DbContext;

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
                    UserId = userId
                };

                var userPrefPropertiesInfo = typeof(UserPreference).GetProperties()
                    .Where(p => p.CanWrite && p.Name != "Id" && p.Name != "UserId" && p.Name != "User")
                    .ToList();

                foreach (var property in userPrefPropertiesInfo)
                {
                    if (systemSettings.TryGetValue(property.Name, out var setting) &&
                        !string.IsNullOrEmpty(setting.SettingValue))
                    {
                        SetPropertyValue(userPreference, property, setting.SettingValue, setting.DataType);
                    }
                }

                _dbContext.UserPreferences.Add(userPreference);
                await _dbContext.SaveChangesAsync(cancellationToken);

                _logger.LogInformation("Created default preferences for user {userId}", userId);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error creating default preferences for user {userId}", userId);
            }
        }

        private void SetPropertyValue(UserPreference userPreference, PropertyInfo property, string valueStr, DataType dataType)
        {
            try
            {
                object value = null;

                switch (dataType)
                {
                    case DataType.String:
                        value = valueStr;
                        break;
                    case DataType.Boolean:
                        if (bool.TryParse(valueStr, out var boolValue))
                            value = boolValue;
                        break;
                    default:
                        if (property.PropertyType.IsEnum)
                        {
                            if (Enum.TryParse(property.PropertyType, valueStr, true, out var enumValue))
                                value = enumValue;
                        }
                        break;
                }

                if (value != null)
                {
                    property.SetValue(userPreference, value);
                }
            }
            catch (Exception ex)
            {
                _logger.LogError($"Failed to set {property.Name} to value {valueStr}: {ex.Message}");
            }
        }
    }
}
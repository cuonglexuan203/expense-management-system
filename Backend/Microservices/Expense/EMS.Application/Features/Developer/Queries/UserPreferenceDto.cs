using AutoMapper;
using EMS.Application.Common.Mappings;
using EMS.Core.Entities;
using EMS.Core.Enums;

namespace EMS.Application.Features.User.Queries
{
    public class UserPreferenceDto : IMapFrom<UserPreference>
    {
        public int Id { get; set; }
        public string UserId { get; set; }
        public Language Language { get; set; }
        public Currency Currency { get; set; }
        public bool RequiresConfirmation { get; set; }

        public void Mapping(Profile profile)
        {
            // Map từ UserPreference sang UserPreferenceDto
            profile.CreateMap<UserPreference, UserPreferenceDto>();

            // Map từ Dictionary<string, SystemSetting> sang UserPreference
            profile.CreateMap<Dictionary<string, SystemSetting>, UserPreference>()
                .ForMember(dest => dest.Id, opt => opt.Ignore())
                .ForMember(dest => dest.UserId, opt => opt.Ignore())
                .ForMember(dest => dest.CreatedAt, opt => opt.Ignore())
                .ForMember(dest => dest.CreatedBy, opt => opt.Ignore())
                .ForMember(dest => dest.ModifiedAt, opt => opt.Ignore())
                .ForMember(dest => dest.ModifiedBy, opt => opt.Ignore())
                .ForMember(dest => dest.IsDeleted, opt => opt.Ignore())
                .ForMember(dest => dest.DeletedAt, opt => opt.Ignore())
                .ForMember(dest => dest.DeletedBy, opt => opt.Ignore())
                .ForMember(dest => dest.Language, opt => opt.MapFrom((src, _, __, context) =>
                    MapSystemSettingValue<Language>(src, nameof(UserPreference.Language), Language.EN)))
                .ForMember(dest => dest.Currency, opt => opt.MapFrom((src, _, __, context) =>
                    MapSystemSettingValue<Currency>(src, nameof(UserPreference.Currency), Currency.USD)))
                .ForMember(dest => dest.RequiresConfirmation, opt => opt.MapFrom((src, _, __, context) =>
                    MapSystemSettingValue<bool>(src, nameof(UserPreference.RequiresConfirmation), false)));
        }

        private static T MapSystemSettingValue<T>(Dictionary<string, SystemSetting> settings, string key, T defaultValue)
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
                        else if (typeof(T) == typeof(decimal) && decimal.TryParse(setting.SettingValue, out var decimalValue))
                            return (T)(object)decimalValue;
                        else if (typeof(T) == typeof(double) && double.TryParse(setting.SettingValue, out var doubleValue))
                            return (T)(object)doubleValue;
                        break;

                    case DataType.Boolean:
                        if (typeof(T) == typeof(bool) && bool.TryParse(setting.SettingValue, out var boolValue))
                            return (T)(object)boolValue;
                        break;

                    default:
                        if (typeof(T).IsEnum && Enum.TryParse(typeof(T), setting.SettingValue, true, out var enumValue))
                            return (T)enumValue;
                        break;
                }
            }
            catch
            {
                // Ignore conversion errors and return default value
            }

            return defaultValue;
        }
    }
}
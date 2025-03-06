using AutoMapper;
using EMS.Application.Common.Mappings;
using EMS.Core.Entities;
using EMS.Core.Enums;

namespace EMS.Application.Features.Developer.Queries
{
    public class SystemSettingDto : IMapFrom<SystemSetting>
    {
        public string Key { get; set; }
        public string? Value { get; set; }
        public string? Description { get; set; }
        public SettingType Type { get; set; }
        public bool UserConfigurable { get; set; }

        public void Mapping(Profile profile)
        {
            profile.CreateMap<SystemSetting, SystemSettingDto>()
                .ForMember(d => d.Key, opt => opt.MapFrom(s => s.SettingKey))
                .ForMember(d => d.Value, opt => opt.MapFrom(s => s.SettingValue));
        }
    }
}

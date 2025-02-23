using EMS.Core.Entities.Common;
using EMS.Core.Enums;

namespace EMS.Core.Entities
{
    public class SystemSetting : BaseAuditableEntity<int>
    {
        public string SettingKey { get; set; } = default!;
        public string? SettingValue { get; set; }
        public DataType DataType { get; set; } = DataType.String;
        public string? Description { get; set; }
        public SettingType Type { get; set; } = SettingType.General;
        public bool UserConfigurable { get; set; }
    }
}
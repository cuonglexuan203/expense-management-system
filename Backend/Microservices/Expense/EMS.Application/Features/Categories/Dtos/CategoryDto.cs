using EMS.Application.Common.Mappings;
using EMS.Core.Entities;
using EMS.Core.Enums;

namespace EMS.Application.Features.Categories.Dtos
{
    public class CategoryDto : IMapFrom<Category>
    {
        public int Id { get; set; }
        public string Name { get; set; } = default!;
        //public int TransactionCount { get; set; }
        public bool IsDefault { get; set; }
        public CategoryType Type { get; set; }
        public TransactionType FinancialFlowType { get; set; }
        public Guid? IconId { get; set; }
        public string? IconUrl { get; set; }

        public void Mapping(AutoMapper.Profile profile)
        {
            profile.CreateMap<Category, CategoryDto>()
                //.ForMember(d => d.TransactionCount, opt => opt.MapFrom(s => s.Transactions.Count))
                .ForMember(d => d.IsDefault, opt => opt.MapFrom(s => s.Type == CategoryType.Default))
                .ForMember(d => d.IconUrl, opt => opt.MapFrom(s => s.Icon != null ? s.Icon.Url : null));
        }
    }
}
using AutoMapper;
using EMS.Application.Common.Mappings;
using EMS.Core.Entities;
using EMS.Core.Enums;

namespace EMS.Application.Features.Transactions.Dtos
{
    public class TransactionDto : IMapFrom<Transaction>
    {
        public int Id { get; set; }
        public int WalletId { get; set; }
        public string? Category { get; set; }
        public float Amount { get; set; }
        public string? Description { get; set; }
        public TransactionType Type { get; set; }
        public DateTimeOffset CreatedAt { get; set; }

        public void Mapping(Profile profile)
        {
            profile.CreateMap<Transaction, TransactionDto>()
                .ForMember(d => d.Category, opt => opt.MapFrom(s => s.Category!.Name));
        }
    }
}

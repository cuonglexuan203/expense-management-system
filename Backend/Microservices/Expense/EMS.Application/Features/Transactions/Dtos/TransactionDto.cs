using AutoMapper;
using EMS.Application.Common.Mappings;
using EMS.Core.Entities;
using EMS.Core.Enums;

namespace EMS.Application.Features.Transactions.Dtos
{
    public class TransactionDto : IMapFrom<Transaction>
    {
        public int Id { get; set; }
        public string Name { get; set; } = default!;
        public int WalletId { get; set; }
        public string WalletName { get; set; } = default!;
        public string? CategoryName { get; set; }
        public float Amount { get; set; }
        public string? Description { get; set; }
        public TransactionType Type { get; set; }
        public DateTimeOffset CreatedAt { get; set; }

        public void Mapping(Profile profile)
        {
            profile.CreateMap<Transaction, TransactionDto>()
                .ForMember(d => d.CategoryName, opt => opt.MapFrom(s => s.Category!.Name))
                .ForMember(d => d.WalletName, opt => opt.MapFrom(s => s.Wallet.Name));
        }
    }
}

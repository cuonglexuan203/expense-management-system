using EMS.Application.Common.Mappings;

namespace EMS.Application.Features.Wallets.Dtos
{
    public class WalletDto : IMapFrom<Core.Entities.Wallet>
    {
        public int Id { get; set; }
        public string Name { get; set; } = default!;
        public float Balance { get; set; }
        public string? Description { get; set; }

        public DateTimeOffset? CreatedAt { get; set; }

        //public int TransactionCount { get; set; }

        //public void Mapping(AutoMapper.Profile profile)
        //{
        //    profile.CreateMap<Core.Entities.Wallet, WalletDto>()
        //        .ForMember(d => d.TransactionCount, opt => opt.MapFrom(s => s.Transactions.Count));
        //}
    }
}
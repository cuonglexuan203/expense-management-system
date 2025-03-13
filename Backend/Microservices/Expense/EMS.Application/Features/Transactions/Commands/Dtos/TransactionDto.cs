using EMS.Application.Common.Mappings;
using EMS.Core.Enums;

namespace EMS.Application.Features.Transactions.Commands.Dtos
{
    public class TransactionDto : IMapFrom<EMS.Core.Entities.Transaction>
    {
        public int Id { get; set; }
        public int WalletId { get; set; }
        public string? Category { get; set; }
        public float Amount { get; set; }
        public string? Description { get; set; }
        public TransactionType Type { get; set; }
        public DateTimeOffset CreatedAt { get; set; }
    }
}

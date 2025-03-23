using FluentValidation;

namespace EMS.Application.Features.Chats.Finance.Commands.ConfirmExtractedTransaction
{
    public class ConfirmExtractedTransactionCommandValidator : AbstractValidator<ConfirmExtractedTransactionCommand>
    {
        public ConfirmExtractedTransactionCommandValidator()
        {
            RuleFor(e => e.ExtractedTransactionId).GreaterThan(0);
            RuleFor(e => e.WalletId).GreaterThan(0);
        }
    }
}

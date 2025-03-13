using FluentValidation;

namespace EMS.Application.Features.Transactions.Commands.CreateTransaction
{
    public class CreateTransactionCommandValidator : AbstractValidator<CreateTransactionCommand>
    {
        public CreateTransactionCommandValidator()
        {
            RuleFor(e => e.Name)
                .NotNull()
                .NotEmpty()
                .WithMessage("Invalid {PropertyName}");

            RuleFor(e => e.Amount)
                .GreaterThanOrEqualTo(0)
                .WithMessage("Invalid {PropertyName}");
        }
    }
}
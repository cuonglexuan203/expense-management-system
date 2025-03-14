using FluentValidation;

namespace EMS.Application.Features.Wallets.Queries.GetWalletById
{
    public class GetWalletByIdQueryValidator : AbstractValidator<GetWalletByIdQuery>
    {
        public GetWalletByIdQueryValidator()
        {
            RuleFor(e => e.WalletId)
                .GreaterThan(0)
                .WithMessage("Invalid {PropertyName}");
        }
    }
}

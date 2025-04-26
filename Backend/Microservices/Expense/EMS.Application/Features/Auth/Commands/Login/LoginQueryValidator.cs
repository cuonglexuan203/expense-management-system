using FluentValidation;

namespace EMS.Application.Features.Auth.Commands.Login
{
    public class LoginQueryValidator : AbstractValidator<LoginQuery>
    {
        public LoginQueryValidator()
        {
            RuleFor(e => e.Email)
                .NotNull()
                .NotEmpty()
                .EmailAddress()
                .WithMessage("Invalid {PropertyName}");
        }
    }
}

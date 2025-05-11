using FluentValidation;

namespace EMS.Application.Features.Auth.Commands.Login
{
    public class LoginQueryValidator : AbstractValidator<LoginCommand>
    {
        public LoginQueryValidator()
        {
            RuleFor(e => e.UserName)
                .NotNull()
                .NotEmpty()
                .WithMessage("Invalid {PropertyName}");
        }
    }
}

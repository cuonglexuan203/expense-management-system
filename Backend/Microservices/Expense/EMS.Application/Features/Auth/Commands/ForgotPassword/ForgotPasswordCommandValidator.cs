using FluentValidation;

namespace EMS.Application.Features.Auth.Commands.ForgotPassword
{
    public class ForgotPasswordCommandValidator : AbstractValidator<ForgotPasswordCommand>
    {
        public ForgotPasswordCommandValidator()
        {
            RuleFor(d => d.Email)
                .EmailAddress()
                .WithMessage("Invalid email address");
        }
    }
}

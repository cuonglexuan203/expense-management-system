using FluentValidation;

namespace EMS.Application.Features.Auth.Commands.ResetPassword
{
    public class ResetPasswordCommandValidator : AbstractValidator<ResetPasswordCommand>
    {
        public ResetPasswordCommandValidator()
        {
            RuleFor(e => e.Email)
                .EmailAddress()
                .WithMessage("Invalid email address");

            RuleFor(e => e.NewPassword)
                .NotNull()
                .NotEmpty()
                .WithMessage("Please choose a stronger password");

            RuleFor(e => e.ConfirmPassword)
                .Equal(e => e.NewPassword)
                .WithMessage("Password do not match");
        }
    }
}

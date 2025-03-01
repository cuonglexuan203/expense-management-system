using FluentValidation;

namespace EMS.Application.Features.Auth.Commands.Register
{
    public class RegisterCommandValidator : AbstractValidator<RegisterCommand>
    {
        public RegisterCommandValidator()
        {
            RuleFor(r => r.Email)
                .NotNull()
                .NotEmpty()
                .EmailAddress()
                .WithMessage("Invalid {PropertyName}");
        }
    }
}

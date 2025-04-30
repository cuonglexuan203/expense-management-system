using FluentValidation;

namespace EMS.Application.Features.Events.Commands.ScheduleEvent
{
    public class ScheduleEventCommandValidator : AbstractValidator<ScheduleEventCommand>
    {
        public ScheduleEventCommandValidator()
        {
            RuleFor(e => e.InitialTriggerDateTime)
                .GreaterThanOrEqualTo(DateTimeOffset.UtcNow)
                .WithMessage("Cannot schedule event in the past.");
        }
    }
}

using FluentValidation;

namespace EMS.Application.Features.Events.Queries.GetEventOccurrences
{
    public class GetEventOccurrencesQueryValidator : AbstractValidator<GetEventOccurrencesQuery>
    {
        public GetEventOccurrencesQueryValidator()
        {
            RuleFor(e => e.ToUtc)
                .GreaterThanOrEqualTo(e => e.FromUtc)
                .WithMessage("{PropertyName} must be greater than or equal to ToUtc property");
        }
    }
}

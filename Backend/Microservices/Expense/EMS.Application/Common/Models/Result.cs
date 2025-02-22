namespace EMS.Application.Common.Models
{
    public class Result
    {
        internal Result(bool succeeded, IEnumerable<string> errors)
        {
            Succeeded = succeeded;
            Errors = errors.ToArray();
        }

        public bool Succeeded { get; init; }
        public string[]? Errors { get; init; }

        public static Result Success() => new(true, Array.Empty<string>());
        public static Result Failed(IEnumerable<string> errors) => new(false, errors);

    }
}

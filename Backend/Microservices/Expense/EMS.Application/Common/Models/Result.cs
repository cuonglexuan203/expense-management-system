namespace EMS.Application.Common.Models
{
    public class Result
    {
        protected Result(bool succeeded, IEnumerable<string> errors)
        {
            Succeeded = succeeded;
            Errors = errors.ToArray();
        }

        public bool Succeeded { get; init; }
        public string[]? Errors { get; init; }

        public static Result Success() => new(true, []);
        public static Result<TValue> Success<TValue>(TValue value) => new(true, [], value);
        public static Result Failure(IEnumerable<string> errors) => new(false, errors);
        public static Result<TValue> Failure<TValue>(IEnumerable<string> errors) => new(false, errors);
    }
}
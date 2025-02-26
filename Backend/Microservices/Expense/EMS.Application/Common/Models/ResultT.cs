namespace EMS.Application.Common.Models
{
    public class Result<T> : Result
    {
        private Result(bool succeeded, IEnumerable<string> errors, T? value = default) : base(succeeded, errors)
        {
            Value = value;
        }

        public T? Value { get; }

        public static Result<T> Success(T value) => new(true, [], value);
        public static new Result<T> Failure(IEnumerable<string> errors) => new(false, errors);
    }
}

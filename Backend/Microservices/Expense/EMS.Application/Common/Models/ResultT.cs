namespace EMS.Application.Common.Models
{
    public class Result<TValue> : Result
    {
        protected internal Result(bool succeeded, IEnumerable<string> errors, TValue? value = default) : base(succeeded, errors)
        {
            Value = value;
        }

        public TValue? Value { get; }
    }
}

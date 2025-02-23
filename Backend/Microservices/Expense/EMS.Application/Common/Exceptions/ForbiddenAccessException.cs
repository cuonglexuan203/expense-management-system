namespace EMS.Application.Common.Exceptions
{
    public class ForbiddenAccessException : Exception
    {
        public ForbiddenAccessException()
        {

        }

        public ForbiddenAccessException(string? message) : base(message)
        {
        }
    }
}

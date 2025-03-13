namespace EMS.Application.Common.Exceptions
{
    public class BadRequestException : Exception
    {
        public BadRequestException()
        {

        }
        public BadRequestException(string? message) : base(message)
        {
        }

        public BadRequestException(string? message, Exception? innerException) : base(message, innerException)
        {
        }

        public static void ThrowIf(bool condition, string message = "Bad request exception")
        {
            if(condition)
            {
                throw new BadRequestException(message);
            }
        }
    }
}

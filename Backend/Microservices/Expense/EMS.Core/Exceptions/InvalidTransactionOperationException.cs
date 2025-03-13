namespace EMS.Core.Exceptions
{
    public class InvalidTransactionOperationException : Exception
    {
        public InvalidTransactionOperationException()
        {
            
        }

        public InvalidTransactionOperationException(string? message) : base(message)
        {

        }

        public InvalidTransactionOperationException(string? message, Exception? innerException) : base(message, innerException)
        {

        }

        public static void ThrowIf(bool condition,  string? message = "Invalid transaction operation exception")
        {
            if (condition)
            {
                throw new InvalidTransactionOperationException(message);
            }
        }
    }
}

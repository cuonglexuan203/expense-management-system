﻿namespace EMS.Application.Common.Exceptions
{
    public class NotFoundException : Exception
    {
        public NotFoundException()
        {

        }
        public NotFoundException(string? message) : base(message)
        {
        }

        public NotFoundException(string? message, Exception? innerException) : base(message, innerException)
        {
        }
        public static void ThrowIf(bool condition, string message = "Not found exception")
        {
            if (condition)
            {
                throw new NotFoundException(message);
            }
        }
    }
}

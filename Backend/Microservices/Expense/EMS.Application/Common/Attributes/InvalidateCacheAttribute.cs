namespace EMS.Application.Common.Attributes
{
    [AttributeUsage(AttributeTargets.Class, AllowMultiple = true)]
    public class InvalidateCacheAttribute : Attribute
    {
        public string KeyPrefix { get; }
        public InvalidateCacheAttribute(string keyPrefix)
        {
            KeyPrefix = keyPrefix;
        }

    }
}

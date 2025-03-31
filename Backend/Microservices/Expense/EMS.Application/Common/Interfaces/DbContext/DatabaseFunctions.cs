using Microsoft.EntityFrameworkCore;

namespace EMS.Application.Common.Interfaces.DbContext
{
    public static class DatabaseFunctions
    {
        [DbFunction("unaccent")]
        public static string Unaccent(string text) => throw new NotSupportedException();
    }
}

namespace EMS.Application.Common.Utils
{
    public static class DateTimeUtil
    {
        public static DateTimeOffset GetStartDateOfWeek(DateTimeOffset dt)
        {
            var diff = (7 + (dt.DayOfWeek - DayOfWeek.Monday)) % 7;

            return new DateTimeOffset(dt.DateTime.AddDays(-diff).Date, dt.Offset);
        }
    }
}

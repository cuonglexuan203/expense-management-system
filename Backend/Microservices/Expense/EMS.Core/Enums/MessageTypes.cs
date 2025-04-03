namespace EMS.Core.Enums
{
    [Flags]
    public enum MessageTypes
    {
        None = 0,
        Text = 1,
        Image = 2,
        Audio = 4,
        Video = 8,
    }
}

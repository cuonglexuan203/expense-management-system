namespace EMS.Infrastructure.Common.Options
{
    public class AppSettingOptions
    {
        public const string AppSettings = "AppSettings";
        public int PasswordResetTokenExpiryMinutes { get; set; } = 5;
        public string MobileResetPasswordUrl { get; set; } = default!;
        public string GoogleLoginSuccessRedirect { get; set; } = default!;

    }
}

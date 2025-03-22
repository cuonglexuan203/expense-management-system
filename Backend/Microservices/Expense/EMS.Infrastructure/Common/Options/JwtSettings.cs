namespace EMS.Infrastructure.Common.Options
{
    public class JwtSettings
    {
        public const string Jwt = "JwtSettings";
        public string SecretKey { get; set; } = default!;
        public int AccessTokenExpirationInMinutes { get; set; }
        public int RefreshTokenExpirationInDays { get; set; }
        public string? Issuer { get; set; }
        public string? Audience { get; set; }
    }
}

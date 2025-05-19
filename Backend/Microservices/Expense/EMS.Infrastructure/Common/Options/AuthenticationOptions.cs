namespace EMS.Infrastructure.Common.Options
{
    public class AuthenticationOptions
    {
        public static string Authentication { get; } = "Authentication";
        public GoogleOptions Google { get; set; } = default!;
    }

    public class GoogleOptions
    {
        public string ClientId { get; set; } = default!;
        public string ClientSecret { get; set; } = default!;
    }
}

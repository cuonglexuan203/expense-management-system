namespace EMS.Application.Common.Models
{
    public record TokenResponse(string AccessToken, string RefreshToken, DateTime AccessTokenExpiry);
}

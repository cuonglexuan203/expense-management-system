namespace EMS.Application.Features.Auth.Commands.Login
{
    public record LoginDto(
        string? UserId,
        string? Username,
        string? FullName,
        string? Email,
        string? Avatar,
        bool IsNewUser,
        string AccessToken,
        string RefreshToken,
        DateTime AccessTokenExpiration,
        DateTime RefreshTokenExpiration);
}

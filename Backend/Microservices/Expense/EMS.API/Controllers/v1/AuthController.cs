using CloudinaryDotNet;
using EMS.API.Common.Attributes;
using EMS.Application.Features.Auth.Commands.ChangePassword;
using EMS.Application.Features.Auth.Commands.ExternalLogin;
using EMS.Application.Features.Auth.Commands.ForgotPassword;
using EMS.Application.Features.Auth.Commands.Login;
using EMS.Application.Features.Auth.Commands.Logout;
using EMS.Application.Features.Auth.Commands.RefreshToken;
using EMS.Application.Features.Auth.Commands.Register;
using EMS.Application.Features.Auth.Commands.ResetPassword;
using EMS.Infrastructure.Identity.Models;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using System.Web;

namespace EMS.API.Controllers.v1
{
    [ApiRoute("auth")]
    public class AuthController : ApiControllerBase
    {
        private readonly ISender _sender;
        private readonly SignInManager<ApplicationUser> _signInManager;

        public AuthController(
            ISender sender,
            SignInManager<ApplicationUser> signInManager)
        {
            _sender = sender;
            _signInManager = signInManager;
        }

        [HttpPost("register")]
        public async Task<IActionResult> Register(RegisterCommand command)
        {
            var result = await _sender.Send(command);

            return Ok(result);
        }

        [HttpPost("login")]
        public async Task<IActionResult> Login(LoginCommand query)
        {
            var result = await _sender.Send(query);

            return Ok(result);
        }

        [HttpPost("refresh-token")]
        public async Task<IActionResult> RefreshToken(RefreshTokenCommand command)
        {
            var result = await _sender.Send(command);

            return Ok(result);
        }

        [Authorize]
        [HttpPost("logout")]
        public async Task<IActionResult> Logout(LogoutCommand command)
        {
            var result = await _sender.Send(command);

            return Ok(result);
        }

        [HttpPost("forgot-password")]
        public async Task<IActionResult> ForgotPassword(ForgotPasswordCommand command)
        {
            var result = await _sender.Send(command);

            return Ok(result);
        }

        [HttpPost("reset-password")]
        public async Task<IActionResult> ResetPassword(ResetPasswordCommand command)
        {
            var result = await _sender.Send(command);

            return Ok(result);
        }

        [Authorize]
        [HttpPatch("change-password")]
        public async Task<IActionResult> ChangePassword(ChangePasswordCommand command)
        {
            var result = await _sender.Send(command);

            return Ok(result);
        }

        [HttpGet("externallogin")]
        [AllowAnonymous]
        public IActionResult ExternalLogin([FromQuery] string provider, [FromQuery] string? returnUrl = "emsauth://")
        {
            if (string.IsNullOrEmpty(provider))
            {
                return BadRequest("Provider not specified.");
            }

            var callbackUrl = Url.Action(nameof(ExternalLoginCallback), "Auth", new { returnUrl }, Request.Scheme);

            var properties = _signInManager.ConfigureExternalAuthenticationProperties(provider, callbackUrl);

            return Challenge(properties, provider);
        }

        [HttpGet("externallogincallback")]
        [AllowAnonymous]
        public async Task<IActionResult> ExternalLoginCallback(string? returnUrl = "emsauth://", string? remoteError = default)
        {
            var loginDto = await _sender.Send(new ExternalLoginCommand(returnUrl, remoteError));

            var uriBuilder = new UrlBuilder(returnUrl);
            var query = HttpUtility.ParseQueryString(uriBuilder.Query);

            if (!string.IsNullOrEmpty(loginDto.UserId))
            {
                query["userId"] = loginDto.UserId;
            }
            if (!string.IsNullOrEmpty(loginDto.Username))
            {
                query["username"] = loginDto.Username;
            }
            if (!string.IsNullOrEmpty(loginDto.FullName))
            {
                query["fullName"] = loginDto.FullName;
            }
            if (!string.IsNullOrEmpty(loginDto.Email))
            {
                query["email"] = loginDto.Email;
            }
            if (!string.IsNullOrEmpty(loginDto.Avatar))
            {
                query["avatar"] = loginDto.Avatar;
            }

            query["isNewUser"] = loginDto.IsNewUser.ToString().ToLowerInvariant();
            query["accessToken"] = loginDto.AccessToken;
            query["refreshToken"] = loginDto.RefreshToken;

            query["accessTokenExpiration"] = loginDto.AccessTokenExpiration.ToString("o");
            query["refreshTokenExpiration"] = loginDto.RefreshTokenExpiration.ToString("o");

            uriBuilder.Query = query.ToString();

            return new RedirectResult(returnUrl + '?' + query.ToString());
        }
    }
}

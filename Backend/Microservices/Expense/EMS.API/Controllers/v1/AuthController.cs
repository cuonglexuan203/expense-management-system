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
        public IActionResult ExternalLogin([FromQuery] string provider, [FromQuery] string? returnUrl = null)
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
        public async Task<IActionResult> ExternalLoginCallback(string? returnUrl = default, string? remoteError = default)
        {
            var result = await _sender.Send(new ExternalLoginCommand(returnUrl, remoteError));

            return Ok(result);
        }
    }
}

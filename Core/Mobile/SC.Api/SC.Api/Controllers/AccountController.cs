using Microsoft.AspNet.Identity;
using Microsoft.Owin.Security;
using Microsoft.Owin.Security.OAuth;
using Newtonsoft.Json.Linq;
using System;
using System.Linq;
using System.Net.Http;
using System.Security.Claims;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;
using SC.Data;
using System.Web.Http.Description;
using SC.Api.Filters;

namespace SC.Api
{
    [RoutePrefix("api/Account"), LoggingServiceFilterAttribute]
    public class AccountController : ApiController
    {
        private IAuthRepository _repo;

        private IAuthenticationManager Authentication
        {
            get { return Request.GetOwinContext().Authentication; }
        }

        public AccountController(IAuthRepository repo)
        {
            _repo = repo;
        }

        /// <summary>
        /// Validates the Username/Password/SmartKey Combination
        /// </summary>
        /// <param name="userModel"></param>
        /// <returns></returns>
        [ApiExplorerSettings(IgnoreApi = true)]
        [AllowAnonymous]
        [Route("ValidateSmartKey"), Authorize]
        public async Task<IHttpActionResult> ValidateSmartKey(UserModel userModel)
        {
            var result = await _repo.ValidateSmartKey(userModel);

            if (result != null)
                return Ok();
            else
                return BadRequest("Please enter valid SmartKey");
        }  
    }
}

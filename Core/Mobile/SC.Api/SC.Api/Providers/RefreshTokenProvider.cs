using Microsoft.Owin.Security.Infrastructure;
using System;
using System.Threading.Tasks;
using SC.Data;

namespace SC.Api.Providers
{
    /// <summary>
    /// Used for issuing a new Token
    /// </summary>
    public class RefreshTokenProvider : IAuthenticationTokenProvider
    {
        private AuthRepository _repo;
        
        /// <summary>
        /// Sets the requires parameters which sends along with the bearer token.
        /// </summary>
        /// <param name="context"></param>
        /// <returns></returns>
        public async Task CreateAsync(AuthenticationTokenCreateContext context)
        {
            try
            {
                var clientid = context.Ticket.Properties.Dictionary["as:client_id"];
                var createdby = context.Ticket.Properties.Dictionary["userName"];

                if (string.IsNullOrEmpty(clientid))
                {
                    return;
                }

                _repo = new AuthRepository(new SCMobile());
                var refreshTokenLifeTime = context.OwinContext.Get<string>("as:clientRefreshTokenLifeTime");
                var IssuedUtc = context.OwinContext.Get<DateTime>("as:issuedUtc");
                var ExpiresUtc = context.OwinContext.Get<DateTime>("as:expiresUtc");

                var token = new MobileRefreshTokens()
                {
                    CreatedBy = createdby,
                    CreatedDate = DateTime.Now,
                    ModifiedBy = createdby,
                    ModifiedDate = DateTime.Now,
                    ClientId = clientid,
                    UserCode = context.Ticket.Identity.Name,
                    IssuedUtc = IssuedUtc,
                    ExpiresUtc = ExpiresUtc
                };


                context.Ticket.Properties.IssuedUtc = token.IssuedUtc;
                context.Ticket.Properties.ExpiresUtc = token.ExpiresUtc;

                token.ProtectedTicket = context.SerializeTicket();

                var result = await _repo.AddRefreshToken(token);

                if (result > 0)
                {
                    context.SetToken(result.ToString());
                }
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in SimpleRefreshTokenProvider.CreateAsync method." + ex.Message);
                throw excep;
            }
        }
        
        /// <summary>
        /// Issue new token
        /// </summary>
        /// <param name="context"></param>
        /// <returns></returns>
        public async Task ReceiveAsync(AuthenticationTokenReceiveContext context)
        {
            var _repo = new AuthRepository(new SCMobile());
            var allowedOrigin = context.OwinContext.Get<string>("as:clientAllowedOrigin");
            context.OwinContext.Response.Headers.Add("Access-Control-Allow-Origin", new[] { allowedOrigin });

            //string hashedTokenId = Helper.GetHash(context.Token);


            var refreshToken = await _repo.FindRefreshToken(context.Token);

            if (refreshToken != null)
            {
                //Get protectedTicket from refreshToken class
                context.DeserializeTicket(refreshToken.ProtectedTicket);
                var result = await _repo.RemoveRefreshToken(context.Token);
            }
        }
        
        /// <summary>
        /// Not implemented
        /// </summary>
        /// <param name="context"></param>
        public void Create(AuthenticationTokenCreateContext context)
        {
            throw new NotImplementedException();
        }
        
        /// <summary>
        /// Not Implemented
        /// </summary>
        /// <param name="context"></param>
        public void Receive(AuthenticationTokenReceiveContext context)
        {
            throw new NotImplementedException();
        }
    }
}
using Microsoft.Owin.Security;
using Microsoft.Owin.Security.OAuth;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using SC.Data;
using System.Globalization;

namespace SC.Api.Providers
{
    /// <summary>
    /// Used for Owin Autentication/Autherization
    /// </summary>
    public class AuthorizationServerProvider : OAuthAuthorizationServerProvider
    {
        private SCMobile _ctx;
        private Staff user;
        /// <summary>
        /// Constructor of SimpleAuthorizationServerProvider
        /// </summary>
        /// <param name="ctx"></param>
        public AuthorizationServerProvider(SCMobile ctx) { _ctx = ctx; }

        /// <summary>
        /// Validate Client Authentication
        /// </summary>
        /// <param name="context"></param>
        /// <returns></returns>
        public override Task ValidateClientAuthentication(OAuthValidateClientAuthenticationContext context)
        {
            try
            {
                string clientId = string.Empty;
                string clientSecret = string.Empty;
                MobileOrigins origin = null;
                AuthRepository _repo;

                if (!context.TryGetBasicCredentials(out clientId, out clientSecret))
                {
                    context.TryGetFormCredentials(out clientId, out clientSecret);
                }

                if (context.ClientId == null)
                {
                    context.Validated();
                    context.SetError("invalid_clientId", "ClientId should be sent.");
                    return Task.FromResult<object>(null);
                }

                _repo = new AuthRepository(new SCMobile());
                origin = _repo.FindClient(context.ClientId);

                if (origin == null)
                {
                    context.SetError("invalid_clientId", string.Format("Client '{0}' is not registered in the system.", context.ClientId));
                    return Task.FromResult<object>(null);
                }

                #region Commented code which validates the CLientId and Secret
                //if (client.ApplicationType == 46374)
                //{
                //    if (string.IsNullOrWhiteSpace(clientSecret))
                //    {
                //        context.SetError("invalid_clientId", "Client secret should be sent.");
                //        return Task.FromResult<object>(null);
                //    }
                //    //else
                //    //{
                //    //    if (client.Secret != Helper.GetHash(clientSecret))
                //    //    {
                //    //        context.SetError("invalid_clientId", "Client secret is invalid.");
                //    //        return Task.FromResult<object>(null);
                //    //    }
                //    //}
                //}
                #endregion

                if (origin.Active != "Y")
                {
                    context.SetError("invalid_clientId", "Client is inactive.");
                    return Task.FromResult<object>(null);
                }

                var currentTime = DateTime.Now;
                context.OwinContext.Set<string>("as:clientAllowedOrigin", origin.AllowedOrigin);
                context.OwinContext.Set<string>("as:clientRefreshTokenLifeTime", origin.RefreshTokenLifeTime.ToString());
                context.OwinContext.Set<string>("as:clientRefreshTokenLifeTimeType", origin.RefreshTokenLifeTimeType.ToString());
                context.OwinContext.Set<DateTime>("as:issuedUtc", currentTime);

                DateTime expiresUtc = GetExpiresUtc(origin.RefreshTokenLifeTime, origin.RefreshTokenLifeTimeType, currentTime);

                context.OwinContext.Set<DateTime>("as:expiresUtc", expiresUtc);

                context.Options.AccessTokenExpireTimeSpan = GetExpiresTimeSpan(origin.RefreshTokenLifeTime, origin.RefreshTokenLifeTimeType);

                if (context.Parameters.Any(f => f.Key == "smartkey"))
                {
                    string smartkey = context.Parameters.Where(f => f.Key == "smartkey").Select(f => f.Value).SingleOrDefault()[0];
                    context.OwinContext.Set<string>("SmartKey", smartkey);
                }

                context.Validated();
                return Task.FromResult<object>(null);
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in SimpleAuthorizationServerProvider.ValidateClientAuthentication method." + ex.Message);
                throw excep;
            }
        }
        
        /// <summary>
        /// Returns Token Expires Utc
        /// </summary>
        /// <param name="refreshTokenLifeTime"></param>
        /// <param name="refreshTokenLifeTimeType"></param>
        /// <param name="currentTime"></param>
        /// <returns></returns>
        private DateTime GetExpiresUtc(int? refreshTokenLifeTime, int? refreshTokenLifeTimeType,DateTime currentTime)
        {
            try
            {
                DateTime dateTime = DateTime.Now;

                var gc = CommonDBFunctions.GetGlobalCode(refreshTokenLifeTimeType);

                if (gc.CodeName == "Day" && gc.Code == "TOKENLIFETIMEDAY")
                {
                    dateTime = currentTime.AddDays(Convert.ToDouble(refreshTokenLifeTime));
                }
                else if (gc.CodeName == "Hour" && gc.Code == "TOKENLIFETIMEHOUR")
                {
                    dateTime = currentTime.AddHours(Convert.ToDouble(refreshTokenLifeTime));
                }
                else if (gc.CodeName == "Minute" && gc.Code == "TOKENLIFETIMEMINUTE")
                {
                    dateTime = currentTime.AddMinutes(Convert.ToDouble(refreshTokenLifeTime));
                }

                return dateTime;
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in SimpleAuthorizationServerProvider.GetExpiresUtc method." + ex.Message);
                throw excep;
            }
        }
        
        /// <summary>
        /// Returns token Expires timespan
        /// </summary>
        /// <param name="refreshTokenLifeTime"></param>
        /// <param name="refreshTokenLifeTimeType"></param>
        /// <returns></returns>
        private TimeSpan GetExpiresTimeSpan(int? refreshTokenLifeTime, int? refreshTokenLifeTimeType)
        {
            try
            {
                TimeSpan timeSpan = TimeSpan.MaxValue;

                var gc = CommonDBFunctions.GetGlobalCode(refreshTokenLifeTimeType);

                if (gc.CodeName == "Day" && gc.Code == "TOKENLIFETIMEDAY")
                {
                    timeSpan = TimeSpan.FromDays(Convert.ToDouble(refreshTokenLifeTime));
                }
                else if (gc.CodeName == "Hour" && gc.Code == "TOKENLIFETIMEHOUR")
                {
                    timeSpan = TimeSpan.FromHours(Convert.ToDouble(refreshTokenLifeTime));
                }
                else if (gc.CodeName == "Minute" && gc.Code == "TOKENLIFETIMEMINUTE")
                {
                    timeSpan = TimeSpan.FromMinutes(Convert.ToDouble(refreshTokenLifeTime));
                }

                return timeSpan;
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in SimpleAuthorizationServerProvider.GetExpiresTimeSpan method." + ex.Message);
                throw excep;
            }
        }
        
        /// <summary>
        /// Used for Granting token related information
        /// </summary>
        /// <param name="context"></param>
        /// <returns></returns>
        public override async Task GrantResourceOwnerCredentials(OAuthGrantResourceOwnerCredentialsContext context)
        {
            try
            {
                var _repo = new AuthRepository(new SCMobile());
                var allowedOrigin = context.OwinContext.Get<string>("as:clientAllowedOrigin");

                string smartkey = context.OwinContext.Get<string>("SmartKey");

                context.OwinContext.Response.Headers.Add("Access-Control-Allow-Origin", new[] { allowedOrigin });

                if (smartkey == null)
                    user = await _repo.FindSCUser(context.UserName, context.Password);
                else
                    user = await _repo.FindSCUser(context.UserName, context.Password, smartkey);

                if (user == null)
                {
                    context.SetError("invalid_grant", "The user name or password is incorrect.");
                    return;
                }

                var identity = new ClaimsIdentity(context.Options.AuthenticationType);
                identity.AddClaim(new Claim(ClaimTypes.Name, context.UserName));
                identity.AddClaim(new Claim(ClaimTypes.NameIdentifier, user.StaffId.ToString()));
                identity.AddClaim(new Claim(ClaimTypes.Role, "user"));
                identity.AddClaim(new Claim("sub", context.UserName));

                var props = new AuthenticationProperties(new Dictionary<string, string>
                {
                    {
                        "as:client_id", (context.ClientId == null) ? string.Empty : context.ClientId
                    },
                    {
                        "userName", context.UserName
                    },
                     {
                        "userNameDisplayAs", user.DisplayAs
                    },
                    {
                        "staffId",user.StaffId.ToString()
                    }
                });

                var ticket = new AuthenticationTicket(identity, props);
                context.Validated(ticket);
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in SimpleAuthorizationServerProvider.GrantResourceOwnerCredentials method." + ex.Message);
                throw excep;
            }
        }
        
        /// <summary>
        /// Override method form Granting Refresh Token
        /// </summary>
        /// <param name="context"></param>
        /// <returns></returns>
        public override Task GrantRefreshToken(OAuthGrantRefreshTokenContext context)
        {
            try
            {
                var originalClient = context.Ticket.Properties.Dictionary["as:client_id"];
                var currentClient = context.ClientId;

                if (originalClient != currentClient)
                {
                    context.SetError("invalid_clientId", "Refresh token is issued to a different clientId.");
                    return Task.FromResult<object>(null);
                }

                // Change auth ticket for refresh token requests
                var newIdentity = new ClaimsIdentity(context.Ticket.Identity);

                var newClaim = newIdentity.Claims.Where(c => c.Type == "newClaim").FirstOrDefault();
                if (newClaim != null)
                {
                    newIdentity.RemoveClaim(newClaim);
                }
                newIdentity.AddClaim(new Claim("newClaim", "newValue"));

                var newTicket = new AuthenticationTicket(newIdentity, context.Ticket.Properties);
                context.Validated(newTicket);

                return Task.FromResult<object>(null);
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in SimpleAuthorizationServerProvider.GrantRefreshToken method." + ex.Message);
                throw excep;
            }
        }
        
        /// <summary>
        /// Used return addition parameters Issued and Expires time for the token
        /// </summary>
        /// <param name="context"></param>
        /// <returns></returns>
        public override Task TokenEndpoint(OAuthTokenEndpointContext context)
        {
            try
            {
                foreach (KeyValuePair<string, string> property in context.Properties.Dictionary)
                {
                    if (property.Key == ".issued")
                    {
                        context.AdditionalResponseParameters.Add(property.Key, context.Properties.IssuedUtc.Value.ToString("o", (IFormatProvider)CultureInfo.InvariantCulture));
                    }
                    else if (property.Key == ".expires")
                    {
                        context.AdditionalResponseParameters.Add(property.Key, context.Properties.ExpiresUtc.Value.ToString("o", (IFormatProvider)CultureInfo.InvariantCulture));
                    }
                    else
                    {
                        context.AdditionalResponseParameters.Add(property.Key, property.Value);
                    }
                }

                return Task.FromResult<object>(null);
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in SimpleAuthorizationServerProvider.TokenEndpoint method." + ex.Message);
                throw excep;
            }
        }

    }
}
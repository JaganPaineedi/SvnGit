using Microsoft.Owin;
using Owin;
using System.Web.Http;
using Microsoft.Owin.Security.OAuth;
using SC.Api.Providers;
using System.Web.Http.Tracing;
using WebApiContrib.Formatting.Jsonp;
using SC.Api.Filters;

[assembly: OwinStartup(typeof(SC.Api.Startup))]

namespace SC.Api
{
    public partial class Startup
    {
        public static OAuthBearerAuthenticationOptions OAuthBearerOptions { get; private set; }
        public void Configuration(IAppBuilder app)
        {
            HttpConfiguration config = new HttpConfiguration();
            //config.Filters.Add(new LoggingServiceFilterAttribute());
            //config.Services.Replace(typeof(ITraceWriter), new MyTracer());
            config.MessageHandlers.Add(new MessageHandler());
            app.Use<GlobalExceptionMiddleware>();
            ConfigureOAuth(app);

            GlobalConfiguration.Configure(WebApiConfig.Register);
            //Add Support for JSONP
            GlobalConfiguration.Configuration.AddJsonpFormatter();            
            app.UseCors(Microsoft.Owin.Cors.CorsOptions.AllowAll);
            app.UseWebApi(config);
        }

        public void ConfigureOAuth(IAppBuilder app)
        {
            //use a cookie to temporarily store information about a user logging in with a third party login provider
            app.UseExternalSignInCookie(Microsoft.AspNet.Identity.DefaultAuthenticationTypes.ExternalCookie);
            OAuthBearerOptions = new OAuthBearerAuthenticationOptions();

            OAuthAuthorizationServerOptions OAuthServerOptions = new OAuthAuthorizationServerOptions()
            {
                AllowInsecureHttp = false,
                TokenEndpointPath = new PathString("/token"),
                Provider = new AuthorizationServerProvider(new Data.SCMobile()),
                RefreshTokenProvider = new RefreshTokenProvider()
            };

            // Token Generation
            app.UseOAuthAuthorizationServer(OAuthServerOptions);
            app.UseOAuthBearerAuthentication(OAuthBearerOptions);
        }
    }
}

using System;
using System.Web;
using System.Web.SessionState;

namespace SC.Api
{
    public class Global : System.Web.HttpApplication
    {
        private const string _WebApiPrefix = "api";
        private static string _WebApiExecutionPath = string.Format("~/{0}", _WebApiPrefix);

        protected void Application_PostAuthorizeRequest()
        {
            if (IsWebApiRequest())
            {
                HttpContext.Current.SetSessionStateBehavior(SessionStateBehavior.Required);
            }
        }

        private static bool IsWebApiRequest()
        {
            return HttpContext.Current.Request.AppRelativeCurrentExecutionFilePath.StartsWith(_WebApiExecutionPath);
        }
    }
}
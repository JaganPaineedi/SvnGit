using SHS.LOG.Client45;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http.Filters;
using System.Web.Http.Tracing;

namespace SC.Api.Filters
{
    /// <summary>
    /// Exception Filter
    /// </summary>
    [AttributeUsage(AttributeTargets.All, AllowMultiple = false, Inherited = true)]
    public class LoggingServiceFilterAttribute: ExceptionFilterAttribute
    {
        /// <summary>
        /// Overriden for Logging the exception to Mobile Central
        /// </summary>
        /// <param name="context"></param>
        public override void OnException(HttpActionExecutedContext context)
        {
            var mobileLoggingUrl = SC.Data.CommonDBFunctions.GetSystemConfigurationKeyValue("LogCentralUrl");
            var resourceOwnerGrantSecret = SC.Data.CommonDBFunctions.GetSystemConfigurationKeyValue("ResourceOwnerGrantSecretForLogCentral");
            var mobileSecurityUrl = SC.Data.CommonDBFunctions.GetSystemConfigurationKeyValue("MobileCentralAuthorityUrl");
            var customerIdentifier = SC.Data.CommonDBFunctions.GetSystemConfigurationKeyValue("CustomerIdentifier");
            var smartcareIdentifier = SC.Data.CommonDBFunctions.GetSystemConfigurationKeyValue("SmartCareInstanceIdentifier");

            var currentStaff = (CurrentLoggedInStaff)HttpContext.Current.Session["CurrentStaff"];

            LOGServiceClient client =
                new LOGServiceClient(mobileLoggingUrl, resourceOwnerGrantSecret,
                    mobileSecurityUrl, customerIdentifier, smartcareIdentifier, SmartCareModuleEnum.SCApi,
                   currentStaff == null ? "MobileApi" : currentStaff.UserCode, LogClientShortCircuitToggleEnum.On);

            client.LogException(context.Exception, "");

            if (context.Exception is NotImplementedException)
            {
                context.Response = new HttpResponseMessage(HttpStatusCode.NotImplemented);
            }

            MyTracer myTracer = new MyTracer();
            //TraceRecord traceRecord = new TraceRecord(context.Request, "Error", TraceLevel.Error);

            myTracer.Trace(context.Request, "Error", TraceLevel.Error, context.Exception);
        }
    }
}
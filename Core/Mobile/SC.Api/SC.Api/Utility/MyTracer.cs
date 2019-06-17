using SC.Data;
using System;
using System.Net.Http;
using System.Web;
using System.Web.Http.Tracing;

namespace SC.Api
{
    public class MyTracer : ITraceWriter
    {
        SCMobile _ctx = new SCMobile();
        public void Trace(HttpRequestMessage request, string category, System.Web.Http.Tracing.TraceLevel level, Action<TraceRecord> traceAction)
        {
            if (level != TraceLevel.Off)
            {
                if (traceAction != null && traceAction.Target != null)
                {
                    category = category + Environment.NewLine + "Action Parameters : " + traceAction.Target.ToString();
                }
                var record = new TraceRecord(request, category, level);
                if (traceAction != null) traceAction(record);
                WriteTrace(record);
                return;
            }


            TraceRecord rec = new TraceRecord(request, category, level);
            traceAction(rec);
            WriteTrace(rec);
        }

        protected void WriteTrace(TraceRecord record)
        {
            if (record != null && record.Exception != null)
            {
                int staffId = 0;
                string usercode = string.Empty;

                var queryString = record.Request.RequestUri.Query;
                if (!String.IsNullOrWhiteSpace(queryString))
                {
                    int.TryParse(System.Web.HttpUtility.ParseQueryString(queryString.Substring(1))["staffId"], out staffId);
                    usercode = CommonDBFunctions.GetCurrentUser(staffId);
                }
                else { usercode = "MobileApi"; }

                var errorMessage = string.Format(
                   "{0} {1}: Category={2}, Level={3} {4} {5} {6} {7}",
                   record.Request.Method.ToString(),
                   record.Request.RequestUri.ToString(),
                   record.Category,
                   record.Level,
                   record.Kind,
                   record.Operator,
                   record.Operation,
                   record.Exception != null ? record.Exception.GetBaseException().Message : !string.IsNullOrEmpty(record.Message) ? record.Message : string.Empty);

                _ctx.ssp_SCLogError(errorMessage, record.Exception.StackTrace, "MobileErrorTrace", usercode, DateTime.Now, "");
            }
        }

        public void WriteTrace(HttpRequestBase record, Exception ex)
        {
            if (ex != null)
            {
                while (ex.InnerException != null) ex = ex.InnerException;

                var innerException = ex.InnerException != null ? ex.InnerException.Message : "";

                var errorMessage = $"ErrorMessage from Owin Content is {ex.Message} and the innerException is {innerException}";

                _ctx.ssp_SCLogError(errorMessage, ex.StackTrace, "MobileErrorTrace", "ApiOwinGlobalError", DateTime.Now, "");
            }
        }
    }
}
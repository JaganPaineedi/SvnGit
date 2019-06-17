using Microsoft.Owin;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http.Tracing;

namespace SC.Api.Filters
{
    /// <summary>
    /// This Class helps to log the exception which is realted to OWIN.
    /// </summary>
    public class GlobalExceptionMiddleware : OwinMiddleware
    {
        public GlobalExceptionMiddleware(OwinMiddleware next) : base(next)
        { }

        public override async Task Invoke(IOwinContext context)
        {
            try
            {
                await Next.Invoke(context);
            }
            catch (Exception ex)
            {
                MyTracer myTracer = new MyTracer();

                HttpContextBase httpContext = context.Get<HttpContextBase>(typeof(HttpContextBase).FullName);

                HttpRequestBase requestBase = httpContext.Request;

                myTracer.WriteTrace(requestBase, ex);
            }
        }
    }
}
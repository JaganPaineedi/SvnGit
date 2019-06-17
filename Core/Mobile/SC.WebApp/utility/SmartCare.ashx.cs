using System;
using System.Web;

namespace SC.WebApp
{
    /// <summary>
    /// Summary description for SmartCare
    /// </summary>
    public class SmartCare : IHttpAsyncHandler
    {
        #region Variables
        public bool IsReusable { get { return false; } }
        #endregion

        IAsyncResult IHttpAsyncHandler.BeginProcessRequest(HttpContext context, AsyncCallback cb, object extraData)
        {
            AsynchOperation asynch = new AsynchOperation(cb, context, extraData);
            asynch.StartAsyncWork();
            return asynch;
        }

        void IHttpAsyncHandler.EndProcessRequest(IAsyncResult result)
        {
            //throw new NotImplementedException();
        }

        void IHttpHandler.ProcessRequest(HttpContext context)
        {
            //throw new NotImplementedException();
        }
    }
}
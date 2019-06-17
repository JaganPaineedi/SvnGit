using System;

namespace SC.WebApp
{
    public class Global : System.Web.HttpApplication
    {
        protected async void Application_Start(object sender, EventArgs e)
        {
            await dataservice.UpdateCacheListJson();
        }
    }
}
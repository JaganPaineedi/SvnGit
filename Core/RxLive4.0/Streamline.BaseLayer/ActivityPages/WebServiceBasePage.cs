using System;
using System.Web;
using System.Web.Services;
using System.Xml;
using System.Web.Services.Protocols;
using System.Web.Script.Services;
using System.Web.Security;


namespace Streamline.BaseLayer.WebServices
{
    /// <summary>
    /// Summary description for ClientMedications
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
   
    [ScriptService]
    public class WebServiceBasePage:System.Web.Services.WebService 
    {
        [WebMethod(EnableSession = true)]
        protected void Initialize()
        {
            try
            {
                if (Context.User.Identity.IsAuthenticated)
                {
                    //FormsAuthentication.SignOut(); 
                    if (!(Context.User is StreamlinePrinciple))
                    {
                        // ASP.NET's regular forms authentication picked up our cookie, but we
                        // haven't replaced the default context user with our own. Let's do that
                        // now. We know that the previous context.user.identity.name is the e-mail
                        // address (because we forced it to be as such in the login.aspx page)	
                        if (Session["UserContext"] != null)
                        {
                            StreamlinePrinciple newUser = Session["UserContext"] as StreamlinePrinciple;
                            //StreamlinePrinciple newUser = new StreamlinePrinciple(Context.User.Identity.Name);
                            Context.User = newUser;
                        }
                    }
                }
                else
                {
                    FormsAuthentication.RedirectToLoginPage();
                }
            }
            catch (Exception ex)
            {

            }
        }
    }
}

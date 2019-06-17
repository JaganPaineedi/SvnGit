using System;
using System.Web;
using System.Web.Security;
using System.Collections.Generic;
using System.Text;

namespace Streamline.BaseLayer.ActivityPages
{
    public class ActivityPage:System.Web.UI.Page 
    {
        protected virtual  void Page_Init(object sender, EventArgs e)
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
                        StreamlinePrinciple newUser = Session["UserContext"] as StreamlinePrinciple;
                        //StreamlinePrinciple newUser = new StreamlinePrinciple(Context.User.Identity.Name);
                        Context.User = newUser;

                    }
                }
                else
                {
                    FormsAuthentication.RedirectToLoginPage();                   
                }
            }
            catch (Exception ex)
            {                
                //throw new Exception("Session Expired");
            }
            finally
            {
                
            }
        }

        protected virtual void Page_Load(object sender, EventArgs e)
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
                        StreamlinePrinciple newUser = Session["UserContext"] as StreamlinePrinciple;
                        //StreamlinePrinciple newUser = new StreamlinePrinciple(Context.User.Identity.Name);
                        Context.User = newUser;

                    }
                }
                else
                {
                    FormsAuthentication.RedirectToLoginPage();
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Session Expired");                
            }
            finally
            {

            }
        }


        public virtual void LoadControls(string ControlPath, bool ActivateControl)
        {

        }
    }
}

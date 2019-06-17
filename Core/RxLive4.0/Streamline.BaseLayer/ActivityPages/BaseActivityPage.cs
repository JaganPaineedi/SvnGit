using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Web.Security;
namespace Streamline.BaseLayer
{
    /// <summary>
    /// Summary description for BaseActivityPage
    /// </summary>
    /// 
    public class BaseActivityPage:System.Web.UI.UserControl
    {
        public BaseActivityPage()
        {
            //
            // TODO: Add constructor logic here
            //
        }

        protected virtual void Page_Load(object sender, EventArgs e)
        {
            
        }

        public virtual bool DocumentUpdateDocument()
        {
            return true;
        }

        public virtual bool DocumentCloseDocument()
        {
            return true;
        }

        public virtual bool DocumentDeleteDocument()
        {
            return true;
        }

        public virtual bool DocumentNewDocument()
        {
            return true;
        }

        public virtual void Activate()
        {

        }

        public virtual bool  RefreshPage()
        {
            return true;
        }

        /// <summary>
        /// Virtual Method for displaying the error message to the user on the application
        /// </summary>
        /// <param name="errorMessage"></param>
        /// <param name="showError"></param>
        /// <ModifiedBy>Piyush</ModifiedBy>
        /// <ModifiedOn>5th July 2007</ModifiedOn>
        public virtual void ShowError(string errorMessage, bool showError)
        {
            try
            {
                if (showError)
                {
                    ((HtmlGenericControl)this.Parent.FindControl("DivErrorMessage")).Style["display"] = "block";
                    //((Label)this.Parent.FindControl("LabelErrorMessage")).Visible = showError;// Commented by Piyush on 20th July, so as to incorporate Div arround the Error message so that client side validation also usses the same error image label
                    ((Label)this.Parent.FindControl("LabelErrorMessage")).Text = errorMessage;
                    // Commented by Piyush on 20th July, so as to incorporate Div arround the Error message so that client side validation also usses the same error image label
                    
                }
                else// added by Piyush on 20th July, so as to incorporate Div arround the Error message so that client side validation also usses the same error image label
                {
                    ((HtmlGenericControl)this.Parent.FindControl("DivErrorMessage")).Style["display"] = "none";
                    ((Label)this.Parent.FindControl("LabelErrorMessage")).Text = "";
                }
            }
            catch (Exception ex)
            {
                //(((HtmlGenericControl)System.Web.UI.WebControls.Panel..FindControl("DivErrorMessage")).Style["display"] = "block";
                ex.Message.ToString();
            }
        }
        /// <summary>
        /// Virtual Method for displaying the error message to the user on the application
        /// </summary>
        /// <param name="errorMessage">The Error message which will be displayed to the user</param>
        /// <param name="showError"></param>
        /// <param name="Ctrl">Control of which the reference is passed to this method</param>
        /// <CreatedBy>Piyush</CreatedBy>
        /// <CreatedOn>2nd August 2007</CreatedOn>
        public virtual void ShowError(string errorMessage, bool showError, Control Ctrl)
        {
            try
            {
                if (showError)
                {
                    //((HtmlGenericControl)Ctrl.Parent.FindControl("DivErrorMessage")).Style["display"] = "block";
                    //((Label)Ctrl.Parent.FindControl("LabelErrorMessage")).Text = errorMessage;
                }
                else
                {
                    ((HtmlGenericControl)Ctrl.Parent.FindControl("DivErrorMessage")).Style["display"] = "none";
                    ((Label)Ctrl.Parent.FindControl("LabelErrorMessage")).Text = "";
                }
            }
            catch (Exception ex)
            {
                ex.Message.ToString();
            }
        }

    }
}
using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
namespace Streamline.BaseLayer
{
    /// <summary>
    /// This class some of the basic functionality which could be inherited by Child/Derived classes
    /// </summary>
    /// <author>Piyush</author>
    /// <createdOn>23rd Jan 2008</createdOn>
    public abstract class BaseContentPage : System.Web.UI.Page
    {
        public BaseContentPage()
        {
            //
            // TODO: Add constructor logic here
            //
        }

        /// <summary>
        /// Navigates to next Step
        /// </summary>
        /// <author>Piyush</author>
        /// <createdOn>23rd Jan 2007</createdOn>
        public virtual void DocumentNextDocument(ref object args)
        {
            try
            {

            }
            catch (Exception ex)
            {
            }
        }

        /// <summary>
        /// Navigates to Previous Step
        /// </summary>
        /// <author>Piyush</author>
        /// <createdOn>23rd Jan 2007</createdOn>
        public virtual void DocumentPreviousDocument(ref object args)
        {
            try
            {

            }
            catch (Exception ex)
            {
            }
        }

        /// <summary>
        /// Called when a content page is loaded into the masterpage.
        /// </summary>
        /// <param name="args">Hashtable which contains all required parameters</param>
        public virtual void Activate(object args)
        {
            try
            {

            }
            catch (Exception ex)
            {

                throw;
            }
        }
        /// Code Commented By Pramod Prakash On fet 6 2008
        /// as this function this function is not required as a virtual function

       /* public virtual void Page_Load(object sender, EventArgs e)
        {
            try
            {

            }
            catch (Exception ex)
            {
            }
        }
        * */
        public virtual void Redirect(String PageName)
        {

            try
            {
                System.Web.HttpContext.Current.Response.Redirect(PageName);

            }
            catch (Exception ex)
            {
            }
        }
    }
}
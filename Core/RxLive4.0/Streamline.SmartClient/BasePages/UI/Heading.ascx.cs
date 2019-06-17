using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using Streamline.UserBusinessServices;
using Streamline.BaseLayer;
using System.Collections.Generic;

namespace Streamline.SmartClient.UI
{
    public partial class UserControls_Heading : System.Web.UI.UserControl
    {
        private string _HeadingText;
        public string HeadingText
        {
            get { return _HeadingText; }
            set { _HeadingText = value; }

        }
        protected void Page_Load(object sender, EventArgs e)
        {
            labelText.Text = HeadingText;
           
        }
    }
}
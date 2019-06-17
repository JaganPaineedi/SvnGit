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
public partial class MedicationLogin : System.Web.UI.Page
    {   
    protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["SessionExpires"] != null)
                TdSessionExpires.Style.Add("display", "block");
        LabelCopyrightInfo.Text = "Copyright © 2001-" + DateTime.Now.Year.ToString() + " Streamline Healthcare Solutions, LLC. All Rights Reserved.";
        LabelReleaseVersion.Text = "5.0";
        }   
}

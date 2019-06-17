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

public partial class HarborConsent : Streamline.BaseLayer.ActivityPages.ActivityPage
    {
    protected override void Page_Load(object sender, EventArgs e)
        {
        if (!IsPostBack)
            {
            HarborStandardConsent.Activate();
            }
        }
    }

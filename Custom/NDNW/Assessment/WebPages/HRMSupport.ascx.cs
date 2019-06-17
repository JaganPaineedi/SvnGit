using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using SHS.BaseLayer;

namespace SHS.SmartCare
{

    public partial class ActivityPages_Client_Detail_Assessment_HRMSupport : SHS.BaseLayer.ActivityPages.DataActivityTab
    {
        public override void BindControls()
        {
            //Page.ClientScript.RegisterStartupScript(this.GetType(), "AddSupport", "<script>alert('234');</script>");
            ScriptManager.RegisterStartupScript(this, this.GetType(), "AddSupport", "javascript:AddSupport();", true);
        }
    }
}

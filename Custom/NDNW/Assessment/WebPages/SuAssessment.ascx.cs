using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;

namespace SHS.SmartCare
{
    public partial class ActivityPages_Client_Detail_Assessment_SuAssessment : SHS.BaseLayer.ActivityPages.DataActivityTab
    {
        public override void BindControls()
        {
            UserControl_CurrentSubstanceUse.Activate();
        }
    }
}

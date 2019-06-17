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

public partial class ActivityPages_Client_Detail_Documents_Threshold_FBABIP_FuntionalBehaviorAssessment : SHS.BaseLayer.ActivityPages.DataActivityTab
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    public override void BindControls()
    {
        DataSet dsGlobalCode = new DataSet();


        dsGlobalCode.Merge(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes.Select("Category='XFABIPTYPE'"));
        HiddenFieldGlobaCodes.Value = dsGlobalCode.GetXml();
        DynamicFormsFBA.FormId = 130;
        DynamicFormsFBA.Activate();
        
    }
}

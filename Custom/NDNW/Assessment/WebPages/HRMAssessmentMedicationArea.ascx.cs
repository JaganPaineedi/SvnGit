using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class ActivityPages_Client_Detail_Assessment_HRMAssessmentMedicationArea : System.Web.UI.UserControl
{
    public string RelativePath=string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
        RelativePath = Page.ResolveUrl("~");
        CustomGrid.Bind(SHS.BaseLayer.BaseCommonFunctions.ScreenId);
    }
}

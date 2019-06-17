using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SHS.BaseLayer;
using SHS.BaseLayer.ActivityPages;
using System.Data;

public partial class ActivityPages_Harbor_Client_Detail_Documents_DiagnosticAssessment_DiagnosticPresentingProblem : SHS.BaseLayer.ActivityPages.DataActivityTab
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    public override void BindControls()
    {
        Bind_Control_LevelofCare();
    }

    private void Bind_Control_LevelofCare()
    {
        if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes != null)
        {
            DataView dataViewLevelofCare = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
            dataViewLevelofCare.RowFilter = "Category='XLEVELOFCARE' AND Active='Y' AND ISNULL(RecordDeleted,'N')<>'Y'"; //"Category like 'XREFERRALPREFERENCE' and Active='Y' and ISNULL(RecordDeleted,'N')<>'Y'";
            dataViewLevelofCare.Sort = "CodeName";

            DropDownList_CustomDocumentDiagnosticAssessments_LevelofCare.DataTextField = "CodeName";
            DropDownList_CustomDocumentDiagnosticAssessments_LevelofCare.DataValueField = "GlobalCodeId";
            DropDownList_CustomDocumentDiagnosticAssessments_LevelofCare.DataSource = dataViewLevelofCare;
            DropDownList_CustomDocumentDiagnosticAssessments_LevelofCare.DataBind();
                        
        }

    }
}

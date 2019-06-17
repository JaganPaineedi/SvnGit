using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

public partial class InvoluntaryServices : SHS.BaseLayer.ActivityPages.DocumentDataActivityPage
{

    public override void BindControls()
   {
            foreach (Control ctrl in this.Controls)
            {
                if (ctrl is Streamline.DotNetDropDownGlobalCodes.DropDownGlobalCodes)
                {
                    ((Streamline.DotNetDropDownGlobalCodes.DropDownGlobalCodes)ctrl).DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
                    ((Streamline.DotNetDropDownGlobalCodes.DropDownGlobalCodes)ctrl).FillDropDownDropGlobalCodes();
                    continue;
                }
            }

            if (SHS.BaseLayer.BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomDocumentInvoluntaryServices"].Rows.Count > 0)
            {
                if (SHS.BaseLayer.BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomDocumentInvoluntaryServices"].Rows[0]["DocumentVersionId"].ToString() == "-1")
                {
                    SHS.BaseLayer.BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomDocumentInvoluntaryServices"].Rows[0]["DateOfPetition"] = DBNull.Value;
                    SHS.BaseLayer.BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomDocumentInvoluntaryServices"].Rows[0]["DateOfCommitment"] = DBNull.Value;
                    SHS.BaseLayer.BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomDocumentInvoluntaryServices"].Rows[0]["PeriodOfIntensiveTreatment"] = DBNull.Value;
                }
            }
    }

    public override string PageDataSetName
    {
        get
        {
            return "DataSetCustomInvoluntary";
        }
    }

    public override string[] TablesToBeInitialized
    {
        get { return new string[] { "CustomDocumentInvoluntaryServices" }; }
    }
}

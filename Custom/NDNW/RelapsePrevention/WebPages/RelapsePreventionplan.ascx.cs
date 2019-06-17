using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using Microsoft.ApplicationBlocks.Data;
using SHS.DataServices;



public partial class Custom_RelapsePrevention_WebPages_RelapsePreventionplan : SHS.BaseLayer.ActivityPages.DataActivityTab
{
    public override string[] TablesUsedInTab
    {
        get
        {
            return new string[] { "CustomDocumentRelapsePreventionPlans" };
        }
    }

    public override void BindControls()
    {
        DropDownList_CustomDocumentRelapsePreventionPlans_PlanStatus.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentRelapsePreventionPlans_PlanStatus.FillDropDownDropGlobalCodes();

        DropDownList_CustomDocumentRelapsePreventionPlans_HighRiskSituations.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentRelapsePreventionPlans_HighRiskSituations.FillDropDownDropGlobalCodes();

        DropDownList_CustomDocumentRelapsePreventionPlans_RecoveryActivities.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentRelapsePreventionPlans_RecoveryActivities.FillDropDownDropGlobalCodes();
    }
}

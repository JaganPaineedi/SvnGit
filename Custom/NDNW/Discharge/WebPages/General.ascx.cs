using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using SHS.BaseLayer;

public partial class Custom_Discharge_WebPages_General : SHS.BaseLayer.ActivityPages.DataActivityTab
{
    public override string[] TablesUsedInTab
    {
        get
        {
            return new string[] { "CustomDocumentDischarges", "ClientPrograms", "CustomDischargePrograms" };
        }
    }
    public override void BindControls()
    {
        DropDownList_CustomDocumentDischarges_TransitionDischarge.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentDischarges_TransitionDischarge.FillDropDownDropGlobalCodes();

        DropDownList_CustomDocumentDischarges_ClientType.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentDischarges_ClientType.FillDropDownDropGlobalCodes();
    }
}

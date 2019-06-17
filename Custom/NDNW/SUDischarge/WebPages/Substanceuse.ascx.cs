using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Custom_SUAdmission_WebPages_Substanceuse : SHS.BaseLayer.ActivityPages.DataActivityTab
{
    public override void BindControls()
    {
        //throw new NotImplementedException();

        //DropDownList_CustomDocumentSUDischarges_TobaccoUse.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        //DropDownList_CustomDocumentSUDischarges_TobaccoUse.FillDropDownDropGlobalCodes();


        DropDownList_CustomDocumentSUDischarges_PreferredUsage1.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentSUDischarges_PreferredUsage1.FillDropDownDropGlobalCodes();

        DropDownList_CustomDocumentSUDischarges_PreferredUsage2.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentSUDischarges_PreferredUsage2.FillDropDownDropGlobalCodes();

        DropDownList_CustomDocumentSUDischarges_PreferredUsage3.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentSUDischarges_PreferredUsage3.FillDropDownDropGlobalCodes();

        DropDownList_CustomDocumentSUDischarges_DrugName1.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentSUDischarges_DrugName1.FillDropDownDropGlobalCodes();

        DropDownList_CustomDocumentSUDischarges_DrugName2.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentSUDischarges_DrugName2.FillDropDownDropGlobalCodes();

        DropDownList_CustomDocumentSUDischarges_DrugName3.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentSUDischarges_DrugName3.FillDropDownDropGlobalCodes();

        DropDownList_CustomDocumentSUDischarges_Frequency1.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentSUDischarges_Frequency1.FillDropDownDropGlobalCodes();

        DropDownList_CustomDocumentSUDischarges_Frequency2.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentSUDischarges_Frequency2.FillDropDownDropGlobalCodes();

        DropDownList_CustomDocumentSUDischarges_Frequency3.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentSUDischarges_Frequency3.FillDropDownDropGlobalCodes();


        DropDownList_CustomDocumentSUDischarges_Route1.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentSUDischarges_Route1.FillDropDownDropGlobalCodes();

        DropDownList_CustomDocumentSUDischarges_Route2.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentSUDischarges_Route2.FillDropDownDropGlobalCodes();

        DropDownList_CustomDocumentSUDischarges_Route3.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentSUDischarges_Route3.FillDropDownDropGlobalCodes();

        DropDownList_CustomDocumentSUDischarges_Severity1.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentSUDischarges_Severity1.FillDropDownDropGlobalCodes();

        DropDownList_CustomDocumentSUDischarges_Severity2.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentSUDischarges_Severity2.FillDropDownDropGlobalCodes();

        DropDownList_CustomDocumentSUDischarges_Severity3.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentSUDischarges_Severity3.FillDropDownDropGlobalCodes();




    }
}

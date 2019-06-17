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

        DropDownList_CustomDocumentSUAdmissions_TobaccoUse.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentSUAdmissions_TobaccoUse.FillDropDownDropGlobalCodes();


        DropDownList_CustomDocumentSUAdmissions_PreferredUsage1.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentSUAdmissions_PreferredUsage1.FillDropDownDropGlobalCodes();

        DropDownList_CustomDocumentSUAdmissions_PreferredUsage2.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentSUAdmissions_PreferredUsage2.FillDropDownDropGlobalCodes();

        DropDownList_CustomDocumentSUAdmissions_PreferredUsage3.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentSUAdmissions_PreferredUsage3.FillDropDownDropGlobalCodes();

        DropDownList_CustomDocumentSUAdmissions_DrugName1.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentSUAdmissions_DrugName1.FillDropDownDropGlobalCodes();

        DropDownList_CustomDocumentSUAdmissions_DrugName2.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentSUAdmissions_DrugName2.FillDropDownDropGlobalCodes();

        DropDownList_CustomDocumentSUAdmissions_DrugName3.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentSUAdmissions_DrugName3.FillDropDownDropGlobalCodes();

        DropDownList_CustomDocumentSUAdmissions_Frequency1.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentSUAdmissions_Frequency1.FillDropDownDropGlobalCodes();

        DropDownList_CustomDocumentSUAdmissions_Frequency2.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentSUAdmissions_Frequency2.FillDropDownDropGlobalCodes();

        DropDownList_CustomDocumentSUAdmissions_Frequency3.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentSUAdmissions_Frequency3.FillDropDownDropGlobalCodes();


        DropDownList_CustomDocumentSUAdmissions_Route1.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentSUAdmissions_Route1.FillDropDownDropGlobalCodes();

        DropDownList_CustomDocumentSUAdmissions_Route2.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentSUAdmissions_Route2.FillDropDownDropGlobalCodes();

        DropDownList_CustomDocumentSUAdmissions_Route3.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentSUAdmissions_Route3.FillDropDownDropGlobalCodes();

        DropDownList_CustomDocumentSUAdmissions_Severity1.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentSUAdmissions_Severity1.FillDropDownDropGlobalCodes();

        DropDownList_CustomDocumentSUAdmissions_Severity2.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentSUAdmissions_Severity2.FillDropDownDropGlobalCodes();

        DropDownList_CustomDocumentSUAdmissions_Severity3.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentSUAdmissions_Severity3.FillDropDownDropGlobalCodes();

        


    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SHS.BaseLayer;

public partial class Custom_InquiryDetails_WebPages_MemberInquiryInsurance : SHS.BaseLayer.ActivityPages.DataActivityTab
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    public override void BindControls()
    {
        LoadVerificationEligibiltyControl();
        DropDownList_CustomInquiries_IncomeGeneralHouseholdComposition.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomInquiries_IncomeGeneralHouseholdComposition.FillDropDownDropGlobalCodes();
       
        DropDownList_CustomInquiries_IncomeGeneralPrimarySource.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomInquiries_IncomeGeneralPrimarySource.FillDropDownDropGlobalCodes();
        DropDownList_CustomInquiries_IncomeGeneralAlternativeSource.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomInquiries_IncomeGeneralAlternativeSource.FillDropDownDropGlobalCodes(); 
    }
    private void LoadVerificationEligibiltyControl()
    {
        //UserControl userControl = LoadUC("~/CommonUserControls/VerifyEligibility.ascx");
        //PanelVerificationEligibility.Controls.Add(userControl);
        int inquiryid;
        if (Int32.TryParse(Convert.ToString(BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomInquiries"].Rows[0]["InquiryId"]), out inquiryid))
        {
            eev1.InquiryId = inquiryid;
        }
    }

    public override string[] TablesUsedInTab
    {
        get
        {
            return new string[] { "CustomInquiriesCoverageInformations", "CoveragePlans", "CustomInquiries" };
        }
    }
}
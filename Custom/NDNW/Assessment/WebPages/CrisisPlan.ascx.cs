using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

namespace SHS.SmartCare
{
    public partial class Custom_Assessment_WebPages_CrisisPlan : SHS.BaseLayer.ActivityPages.DataActivityTab
    {
        public string DOB = string.Empty;
        public string NextCrisisPlanReviewDate = string.Empty;

        public override void BindControls()
        {
            CustomGrid_CustomCrisisPlanMedicalProviders.Bind(ParentPageObject.ScreenId);
            CustomGrid_CustomCrisisPlanNetworkProviders.Bind(ParentPageObject.ScreenId);

            DataSet dsCrisisPlan = new DataSet();
            dsCrisisPlan = SHS.BaseLayer.BaseCommonFunctions.GetScreenInfoDataSet();
            DateTime dt = new DateTime();
          
            DateTime dt1 = new DateTime();
            if (dsCrisisPlan.Tables["CustomDocumentSafetyCrisisPlans"].Rows.Count > 0)
            {
                if (!string.IsNullOrEmpty(dsCrisisPlan.Tables["CustomDocumentSafetyCrisisPlans"].Rows[0]["DOB"].ToString()))
                {
                    dt = Convert.ToDateTime(dsCrisisPlan.Tables["CustomDocumentSafetyCrisisPlans"].Rows[0]["DOB"]);
                    DOB = String.Format("{0:MM/dd/yyyy}", dt);
                }
                if (!string.IsNullOrEmpty(dsCrisisPlan.Tables["CustomDocumentSafetyCrisisPlans"].Rows[0]["NextCrisisPlanReviewDate"].ToString()))
                {
                    dt1 = Convert.ToDateTime(dsCrisisPlan.Tables["CustomDocumentSafetyCrisisPlans"].Rows[0]["NextCrisisPlanReviewDate"]);
                    NextCrisisPlanReviewDate = String.Format("{0:MM/dd/yyyy}", dt1);
                    NextCrisisPlanReviewDate = "[Next Review date:" + NextCrisisPlanReviewDate + "]";
                }
            }
            
            
            if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.Programs != null)
            {
                DataView dataViewPrograms = SHS.BaseLayer.SharedTables.GetSharedTableProgram();
                DropDownList_CustomDocumentSafetyCrisisPlans_ProgramId.DataTextField = "ProgramName";
                DropDownList_CustomDocumentSafetyCrisisPlans_ProgramId.DataValueField = "ProgramId";
                DropDownList_CustomDocumentSafetyCrisisPlans_ProgramId.DataSource = dataViewPrograms;
                DropDownList_CustomDocumentSafetyCrisisPlans_ProgramId.DataBind();

                ListItem item = new ListItem(" ", "");
                DropDownList_CustomDocumentSafetyCrisisPlans_ProgramId.Items.Insert(0, item);
                DropDownList_CustomDocumentSafetyCrisisPlans_ProgramId.SelectedValue = "";
            }

            if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.Staff != null)
            {
                DataView dataViewStaffs = SHS.BaseLayer.SharedTables.GetSharedTableStaff();
                DropDownList_CustomDocumentSafetyCrisisPlans_StaffId.DataTextField = "StaffName";
                DropDownList_CustomDocumentSafetyCrisisPlans_StaffId.DataValueField = "StaffId";
                DropDownList_CustomDocumentSafetyCrisisPlans_StaffId.DataSource = dataViewStaffs;
                DropDownList_CustomDocumentSafetyCrisisPlans_StaffId.DataBind();

                ListItem item = new ListItem(" ", "");
                DropDownList_CustomDocumentSafetyCrisisPlans_StaffId.Items.Insert(0, item);
                DropDownList_CustomDocumentSafetyCrisisPlans_StaffId.SelectedValue = "";
            }

            string CategoryType = "ADDRESSTYPE";
            DataView dViewPaperFormat = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
            dViewPaperFormat.RowFilter = "Category='" + CategoryType + "'" + "and Active = 'Y'" + "and Isnull(RecordDeleted,'N')<>'Y'";
            dViewPaperFormat.Sort = "SortOrder,CodeName";
            DropDownList_CustomCrisisPlanMedicalProviders_AddressType.DataTextField = "CodeName";
            DropDownList_CustomCrisisPlanMedicalProviders_AddressType.DataValueField = "GlobalCodeId";
            DropDownList_CustomCrisisPlanMedicalProviders_AddressType.DataSource = dViewPaperFormat;
            DropDownList_CustomCrisisPlanMedicalProviders_AddressType.DataBind();
            ListItem item1 = new ListItem(" ", "");
            DropDownList_CustomCrisisPlanMedicalProviders_AddressType.Items.Insert(0, item1);
            DropDownList_CustomCrisisPlanMedicalProviders_AddressType.SelectedValue = "";

            DropDownList_CustomCrisisPlanNetworkProviders_AddressType.DataTextField = "CodeName";
            DropDownList_CustomCrisisPlanNetworkProviders_AddressType.DataValueField = "GlobalCodeId";
            DropDownList_CustomCrisisPlanNetworkProviders_AddressType.DataSource = dViewPaperFormat;
            DropDownList_CustomCrisisPlanNetworkProviders_AddressType.DataBind();
            ListItem item2 = new ListItem(" ", "");
            DropDownList_CustomCrisisPlanNetworkProviders_AddressType.Items.Insert(0, item2);
            DropDownList_CustomCrisisPlanNetworkProviders_AddressType.SelectedValue = "";

        }
    }
}
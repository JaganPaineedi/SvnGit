using System;
using System.Data;
using System.Configuration;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using SHS.BaseLayer;

namespace SHS.SmartCare
{
    public partial class HealthHomeCommunicationPlan : SHS.BaseLayer.ActivityPages.DocumentDataActivityPage
    {

        public override void BindControls()
        {
            DataSet dsHealthHomeDocuments = new DataSet();
            dsHealthHomeDocuments = BaseCommonFunctions.GetScreenInfoDataSet();
            BindDropDowns();
            CustomGrid_CustomDocumentHealthHomeCommPlanProviders.Bind(ParentPageObject.ScreenId);
            CustomGrid_CustomDocumentHealthHomeCommPlanFamilyMembers.Bind(ParentPageObject.ScreenId);
            CustomGrid_CustomDocumentHealthHomeCommPlanSocialSupports.Bind(ParentPageObject.ScreenId);
        }

        private void BindDropDowns()
        {
            DataView dataViewClinician = SHS.BaseLayer.SharedTables.GetSharedTableStaff();
            dataViewClinician.RowFilter = "Clinician='Y' and Active='Y' and ISNULL(RecordDeleted,'N')<>'Y'";
            dataViewClinician.Sort = "StaffName ASC";
            DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamMember1.DataTextField = "StaffName";
            DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamMember1.DataValueField = "StaffId";
            DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamMember1.DataSource = dataViewClinician;
            DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamMember1.DataBind();
            DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamMember1.Items.Insert(0, new ListItem("", "0"));
            DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamMember1.SelectedIndex = 0;

            DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamMember2.DataTextField = "StaffName";
            DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamMember2.DataValueField = "StaffId";
            DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamMember2.DataSource = dataViewClinician;
            DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamMember2.DataBind();
            DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamMember2.Items.Insert(0, new ListItem("", "0"));
            DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamMember2.SelectedIndex = 0;

            DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamMember3.DataTextField = "StaffName";
            DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamMember3.DataValueField = "StaffId";
            DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamMember3.DataSource = dataViewClinician;
            DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamMember3.DataBind();
            DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamMember3.Items.Insert(0, new ListItem("", "0"));
            DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamMember3.SelectedIndex = 0;

            DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamMember4.DataTextField = "StaffName";
            DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamMember4.DataValueField = "StaffId";
            DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamMember4.DataSource = dataViewClinician;
            DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamMember4.DataBind();
            DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamMember4.Items.Insert(0, new ListItem("", "0"));
            DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamMember4.SelectedIndex = 0;

            DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamMember5.DataTextField = "StaffName";
            DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamMember5.DataValueField = "StaffId";
            DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamMember5.DataSource = dataViewClinician;
            DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamMember5.DataBind();
            DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamMember5.Items.Insert(0, new ListItem("", "0"));
            DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamMember5.SelectedIndex = 0;

            DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamMember6.DataTextField = "StaffName";
            DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamMember6.DataValueField = "StaffId";
            DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamMember6.DataSource = dataViewClinician;
            DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamMember6.DataBind();
            DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamMember6.Items.Insert(0, new ListItem("", "0"));
            DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamMember6.SelectedIndex = 0;

            DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamMember7.DataTextField = "StaffName";
            DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamMember7.DataValueField = "StaffId";
            DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamMember7.DataSource = dataViewClinician;
            DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamMember7.DataBind();
            DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamMember7.Items.Insert(0, new ListItem("", "0"));
            DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamMember7.SelectedIndex = 0;

            using (DataView DataViewGlobalCodes = BaseCommonFunctions.FillDropDown("XHHROLE", true, "", "", false))
            {
                DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamRole1.DataTextField = "CodeName";
                DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamRole1.DataValueField = "GlobalCodeId";
                DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamRole1.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamRole1.DataBind();
                DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamRole1.Items.Insert(0, new ListItem("", "0"));
                DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamRole1.SelectedIndex = 0;

                DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamRole2.DataTextField = "CodeName";
                DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamRole2.DataValueField = "GlobalCodeId";
                DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamRole2.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamRole2.DataBind();
                DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamRole2.Items.Insert(0, new ListItem("", "0"));
                DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamRole2.SelectedIndex = 0;

                DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamRole3.DataTextField = "CodeName";
                DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamRole3.DataValueField = "GlobalCodeId";
                DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamRole3.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamRole3.DataBind();
                DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamRole3.Items.Insert(0, new ListItem("", "0"));
                DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamRole3.SelectedIndex = 0;

                DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamRole4.DataTextField = "CodeName";
                DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamRole4.DataValueField = "GlobalCodeId";
                DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamRole4.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamRole4.DataBind();
                DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamRole4.Items.Insert(0, new ListItem("", "0"));
                DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamRole4.SelectedIndex = 0;

                DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamRole5.DataTextField = "CodeName";
                DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamRole5.DataValueField = "GlobalCodeId";
                DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamRole5.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamRole5.DataBind();
                DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamRole5.Items.Insert(0, new ListItem("", "0"));
                DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamRole5.SelectedIndex = 0;

                DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamRole6.DataTextField = "CodeName";
                DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamRole6.DataValueField = "GlobalCodeId";
                DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamRole6.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamRole6.DataBind();
                DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamRole6.Items.Insert(0, new ListItem("", "0"));
                DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamRole6.SelectedIndex = 0;

                DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamRole7.DataTextField = "CodeName";
                DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamRole7.DataValueField = "GlobalCodeId";
                DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamRole7.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamRole7.DataBind();
                DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamRole7.Items.Insert(0, new ListItem("", "0"));
                DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamRole7.SelectedIndex = 0;
            }
            using (DataView DataViewGC = BaseCommonFunctions.FillDropDown("XHHPayors", true, "", "", false))
            {
                DropDownList_CustomDocumentHealthHomeCommPlans_MedicaidManagedCarePlan.DataTextField = "CodeName";
                DropDownList_CustomDocumentHealthHomeCommPlans_MedicaidManagedCarePlan.DataValueField = "GlobalCodeId";
                DropDownList_CustomDocumentHealthHomeCommPlans_MedicaidManagedCarePlan.DataSource = DataViewGC;
                DropDownList_CustomDocumentHealthHomeCommPlans_MedicaidManagedCarePlan.DataBind();
                DropDownList_CustomDocumentHealthHomeCommPlans_MedicaidManagedCarePlan.Items.Insert(0, new ListItem("", "0"));
                DropDownList_CustomDocumentHealthHomeCommPlans_MedicaidManagedCarePlan.SelectedIndex = 0;
            }
        }

        public override string PageDataSetName
        {
            get{return "DataSetCustomHealthHomeDocuments";}
        }

        public override string[] TablesToBeInitialized
        {
            get { return new string[] { "CustomDocumentHealthHomeCommPlans,CustomDocumentHealthHomeCommPlanProviders,CustomDocumentHealthHomeCommPlanFamilyMembers,CustomDocumentHealthHomeCommPlanSocialSupports" }; }
        }

        public override void ChangeDataSetBeforeUpdate(ref DataSet dataSetObject)
        {

        }
    }
}

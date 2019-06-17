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
    public partial class TransitionPlan : SHS.BaseLayer.ActivityPages.DocumentDataActivityPage
    {
        public override void BindControls()
        {
            DataSet dsHealthHomeDocuments = new DataSet();
            dsHealthHomeDocuments = BaseCommonFunctions.GetScreenInfoDataSet();

            DataView dataViewClinician = SHS.BaseLayer.SharedTables.GetSharedTableStaff();
            dataViewClinician.RowFilter = "Clinician='Y' and Active='Y' and ISNULL(RecordDeleted,'N')<>'Y'";
            dataViewClinician.Sort = "StaffName ASC";
            DropDownList_CustomDocumentHealthHomeTransitionPlans_ClinicianCoordinatingDischarge.DataTextField = "StaffName";
            DropDownList_CustomDocumentHealthHomeTransitionPlans_ClinicianCoordinatingDischarge.DataValueField = "StaffId";
            DropDownList_CustomDocumentHealthHomeTransitionPlans_ClinicianCoordinatingDischarge.DataSource = dataViewClinician;
            DropDownList_CustomDocumentHealthHomeTransitionPlans_ClinicianCoordinatingDischarge.DataBind();
            DropDownList_CustomDocumentHealthHomeTransitionPlans_ClinicianCoordinatingDischarge.Items.Insert(0, new ListItem("", "0"));
            DropDownList_CustomDocumentHealthHomeTransitionPlans_ClinicianCoordinatingDischarge.SelectedIndex = 0;

            using (DataView DataViewGlobalCodes = BaseCommonFunctions.FillDropDown("XHHTRANSENTITY", true, "", "", false))
            {
                if (DataViewGlobalCodes != null)
                {
                    DataViewGlobalCodes.Sort = "SortOrder asc";
                    DropDownList_CustomDocumentHealthHomeTransitionPlans_TransitionFromEntityType.DataTextField = "CodeName";
                    DropDownList_CustomDocumentHealthHomeTransitionPlans_TransitionFromEntityType.DataValueField = "GlobalCodeID";
                    DropDownList_CustomDocumentHealthHomeTransitionPlans_TransitionFromEntityType.DataSource = DataViewGlobalCodes;
                    DropDownList_CustomDocumentHealthHomeTransitionPlans_TransitionFromEntityType.DataBind();
                    DropDownList_CustomDocumentHealthHomeTransitionPlans_TransitionFromEntityType.Items.Insert(0, new ListItem("", "0"));
                    DropDownList_CustomDocumentHealthHomeTransitionPlans_TransitionFromEntityType.SelectedIndex = 0;

                    DropDownList_CustomDocumentHealthHomeTransitionPlans_TransitionToEntityType.DataTextField = "CodeName";
                    DropDownList_CustomDocumentHealthHomeTransitionPlans_TransitionToEntityType.DataValueField = "GlobalCodeID";
                    DropDownList_CustomDocumentHealthHomeTransitionPlans_TransitionToEntityType.DataSource = DataViewGlobalCodes;
                    DropDownList_CustomDocumentHealthHomeTransitionPlans_TransitionToEntityType.DataBind();
                    DropDownList_CustomDocumentHealthHomeTransitionPlans_TransitionToEntityType.Items.Insert(0, new ListItem("", "0"));
                    DropDownList_CustomDocumentHealthHomeTransitionPlans_TransitionToEntityType.SelectedIndex = 0;
                    
                }
            }

            CustomGrid_CustomDocumentHealthHomeReferrals.Bind(ParentDetailPageObject.ScreenId);
            CustomGrid_CustomDocumentHealthHomePriorAuthorizations.Bind(ParentDetailPageObject.ScreenId);
        }
        public override string PageDataSetName
        {
            get { return "DataSetCustomTransitionPlan"; }
        }

        public override string[] TablesToBeInitialized
        {
            get { return new string[] { "CustomDocumentHealthHomeTransitionPlans,CustomDocumentHealthHomeReferrals,CustomDocumentHealthHomePriorAuthorizations" }; }
        }
        public override void CustomAjaxRequest()
        {
            Literal literalStart = new Literal();
            Literal literalHtmlText = new Literal();
            Literal literalEnd = new Literal();
            literalStart.Text = "###StartUc###";
            if (GetRequestParameterValue("CustomAjaxRequestType") == "CountSequenceNumber")
            {
                DataSet dsHealthHomeDocuments = new DataSet();
                dsHealthHomeDocuments = BaseCommonFunctions.GetScreenInfoDataSet();
                int SequenceCount = 0;
                string tablename = GetRequestParameterValue("TableName");
                if (dsHealthHomeDocuments.Tables.Contains(tablename))
                {
                    if (dsHealthHomeDocuments.Tables[tablename].Rows.Count > 0)
                    {
                        SequenceCount = Convert.ToInt32(dsHealthHomeDocuments.Tables[tablename].Rows[dsHealthHomeDocuments.Tables[tablename].Rows.Count - 1]["SequenceNumber"]);
                    }
                }
                SequenceCount = SequenceCount + 1;
                literalHtmlText.Text = GetRequestParameterValue("GridDataTable") + "^" + GetRequestParameterValue("GridDivName") + "^" + GetRequestParameterValue("DataGridID") + "^" + GetRequestParameterValue("ButtonCtrl") + "^" + SequenceCount.ToString();
            }
            literalEnd.Text = "###EndUc###";
            PanelLoadUC.Controls.Add(literalStart);
            PanelLoadUC.Controls.Add(literalHtmlText);
            PanelLoadUC.Controls.Add(literalEnd);
        }
    }
}

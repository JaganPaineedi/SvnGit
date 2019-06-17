using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Microsoft.ApplicationBlocks.Data;
using SHS.BaseLayer;
using SHS.DataServices;

namespace SHS.SmartCare
{
    public partial class Custom_Assessment_WebPages_SafetyPlan : SHS.BaseLayer.ActivityPages.DataActivityTab
    {
        public string NextSafetyPlanReviewDate = string.Empty;
        public override void BindControls()
        {
            CustomGridSupportContacts.Bind(ParentPageObject.ScreenId);
            DataTable dtCustomDocumentSafetyCrisisPlans = SHS.BaseLayer.BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomDocumentSafetyCrisisPlans"].Copy();
            DataSet dsSafetyPlan = new DataSet();
            dsSafetyPlan = SHS.BaseLayer.BaseCommonFunctions.GetScreenInfoDataSet();
            DateTime dt = new DateTime();
            if (dsSafetyPlan.Tables["CustomSafetyCrisisPlanReviews"].Rows.Count > 0)
            {
                if (!string.IsNullOrEmpty(dsSafetyPlan.Tables["CustomSafetyCrisisPlanReviews"].Rows[0]["NextSafetyPlanReviewDate"].ToString()))
                {
                    dt = Convert.ToDateTime(dsSafetyPlan.Tables["CustomSafetyCrisisPlanReviews"].Rows[0]["NextSafetyPlanReviewDate"]);
                    NextSafetyPlanReviewDate = String.Format("{0:MM/dd/yyyy}", dt);
                    NextSafetyPlanReviewDate = "[Next Review date:" + NextSafetyPlanReviewDate + "]";
                }
            }

            string ThreeMonths = string.Empty;
            string TwelveMonths = string.Empty;
            string mode = string.Empty;
            if (dtCustomDocumentSafetyCrisisPlans.Rows.Count > 0)
            {
                if (!string.IsNullOrEmpty(dtCustomDocumentSafetyCrisisPlans.Rows[0]["ThreeMonths"].ToString()))
                    ThreeMonths = dtCustomDocumentSafetyCrisisPlans.Rows[0]["ThreeMonths"].ToString().Trim();
                if (!string.IsNullOrEmpty(dtCustomDocumentSafetyCrisisPlans.Rows[0]["TwelveMonths"].ToString()))
                    TwelveMonths = dtCustomDocumentSafetyCrisisPlans.Rows[0]["TwelveMonths"].ToString().Trim();

                if (TwelveMonths == "Y")
                    mode = "12months";
                else if (ThreeMonths == "Y")
                    mode = "3months";
            }

            string strFilter = string.Empty;
            string strTodayDate = string.Empty;
            if (mode == "3months")
                strTodayDate = System.DateTime.Now.AddMonths(-3).ToString("MM/dd/yyyy");
            else if (mode == "12months")
                strTodayDate = System.DateTime.Now.AddMonths(-12).ToString("MM/dd/yyyy");
            if (strTodayDate.Trim() != string.Empty)
                strFilter = "isnull(convert(DateReviewed,'System.DateTime'),'01/01/1900') >= '" + strTodayDate + "'";

            if (strFilter == "")
                CustomGridCustomSafetyCrisisPlanReviews.Bind(ParentPageObject.ScreenId);
            else
                CustomGridCustomSafetyCrisisPlanReviews.Bind(ParentPageObject.ScreenId, strFilter);

            DataSet datasetSupportContacts = new DataSet();
            int clientId = 0;
            clientId = SHS.BaseLayer.BaseCommonFunctions.ApplicationInfo.Client.ClientId;
            datasetSupportContacts = GetSupportContactsName(clientId);
            HiddenFieldClientContactInformation.Value = datasetSupportContacts.GetXml();
            if (datasetSupportContacts.Tables.Contains("ClientContactInformation") && BaseCommonFunctions.CheckRowExists(datasetSupportContacts, "ClientContactInformation", 0))
            {
                DataView dataviewSafetyPlan = new DataView(datasetSupportContacts.Tables["ClientContactInformation"]);

                DropDownList_ClientContactInformation_Name.DataSource = dataviewSafetyPlan;
                DropDownList_ClientContactInformation_Name.DataTextField = "Name";
                DropDownList_ClientContactInformation_Name.DataValueField = "ClientContactId";
                DropDownList_ClientContactInformation_Name.DataBind();
                DropDownList_ClientContactInformation_Name.Items.Insert(0, new ListItem("", ""));
                DropDownList_ClientContactInformation_Name.SelectedIndex = -1;

            }
        }

        public DataSet GetSupportContactsName(Int32 ClientId)
        {
            SqlParameter[] _objectSqlParmeters;
            DataSet datasetSupportContacts = null;
            try
            {
                _objectSqlParmeters = new SqlParameter[1];
                _objectSqlParmeters[0] = new SqlParameter("@ClientId", ClientId);
                datasetSupportContacts = SqlHelper.ExecuteDataset(Connection.ConnectionString, CommandType.StoredProcedure, "csp_GetClientContactsName", _objectSqlParmeters);
                datasetSupportContacts.Tables[0].TableName = "ClientContactInformation";
                return datasetSupportContacts;
            }

            finally
            {
                if (datasetSupportContacts != null) datasetSupportContacts.Dispose();
                _objectSqlParmeters = null;
            }
        }
    }
}
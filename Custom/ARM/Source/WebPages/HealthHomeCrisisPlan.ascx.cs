﻿using System;
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
using System.Data.SqlClient;
using Microsoft.ApplicationBlocks.Data;
using SHS.DataServices;

namespace SHS.SmartCare
{
    public partial class HealthHomeCrisisPlan : SHS.BaseLayer.ActivityPages.DocumentDataActivityPage
    {
        public string diagnosisListInformation = "";
        public override void BindControls()
        {
            DataView dataViewClinician = SHS.BaseLayer.SharedTables.GetSharedTableStaff();
            dataViewClinician.RowFilter = "Clinician='Y' and Active='Y' and ISNULL(RecordDeleted,'N')<>'Y'";
            dataViewClinician.Sort = "StaffName ASC";
            DropDownList_CustomDocumentHealthHomeCrisisPlans_ClinicianFacilitatingDischarge.DataTextField = "StaffName";
            DropDownList_CustomDocumentHealthHomeCrisisPlans_ClinicianFacilitatingDischarge.DataValueField = "StaffId";
            DropDownList_CustomDocumentHealthHomeCrisisPlans_ClinicianFacilitatingDischarge.DataSource = dataViewClinician;
            DropDownList_CustomDocumentHealthHomeCrisisPlans_ClinicianFacilitatingDischarge.DataBind();
            DropDownList_CustomDocumentHealthHomeCrisisPlans_ClinicianFacilitatingDischarge.Items.Insert(0, new ListItem("", "0"));
            DropDownList_CustomDocumentHealthHomeCrisisPlans_ClinicianFacilitatingDischarge.SelectedIndex = 0;
            CustomGrid_CustomDocumentHealthHomeCommPlanFamilyMembers.Bind(ParentDetailPageObject.ScreenId);
            CustomGrid_CustomDocumentHealthHomeMentalHealthCrisisPlanSteps.Bind(ParentDetailPageObject.ScreenId);
            CustomGrid_CustomDocumentHealthHomeCrisisPlanTypes.Bind(ParentDetailPageObject.ScreenId);
            CustomGrid_CustomDocumentHealthHomeCarePlanDiagnoses.Bind(ParentDetailPageObject.ScreenId);

            using (DataView DataViewGlobalCodes = BaseCommonFunctions.FillDropDown("XDIAGNOSISSOURCE", true, "", "", false))
            {
                if (DataViewGlobalCodes != null)
                {
                    DataViewGlobalCodes.Sort = "SortOrder asc";
                    DropDownList_CustomDocumentHealthHomeCarePlanDiagnoses_DiagnosisSource.DataTextField = "CodeName";
                    DropDownList_CustomDocumentHealthHomeCarePlanDiagnoses_DiagnosisSource.DataValueField = "GlobalCodeID";
                    DropDownList_CustomDocumentHealthHomeCarePlanDiagnoses_DiagnosisSource.DataSource = DataViewGlobalCodes;
                    DropDownList_CustomDocumentHealthHomeCarePlanDiagnoses_DiagnosisSource.DataBind();
                    DropDownList_CustomDocumentHealthHomeCarePlanDiagnoses_DiagnosisSource.Items.Insert(0, new ListItem("", "0"));
                }
            }
        }

        public override string PageDataSetName
        {
            get { return "DataSetCustomHealthHomeCrisisPlans"; }
        }

        public override string[] TablesToBeInitialized
        {
            get { return new string[] { "CustomDocumentHealthHomeCrisisPlans" }; }
        }
        public override void ChangeDataSetBeforeUpdate(ref DataSet dataSetObject)
        {
            if(dataSetObject.IsRowExists("CurrentDiagnoses"))
            {
            dataSetObject.Tables.Remove("CurrentDiagnoses");
            }
        }
        public override void CustomAjaxRequest()
        {
            
            if (GetRequestParameterValue("CustomAjaxRequestType") == "CountSequenceNumber")
            {
                Literal literalStart = new Literal();
                Literal literalHtmlText = new Literal();
                Literal literalEnd = new Literal();
                literalStart.Text = "###StartUc###";
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
                literalEnd.Text = "###EndUc###";
                PanelLoadUC.Controls.Add(literalStart);
                PanelLoadUC.Controls.Add(literalHtmlText);
                PanelLoadUC.Controls.Add(literalEnd);
            }
            if (GetRequestParameterValue("CustomAjaxRequestType") == "GetCurrentDiagnosis")
            {
                Literal literalStart = new Literal();
                Literal literalHtmlText = new Literal();
                Literal literalEnd = new Literal();
                literalStart.Text = "###StartCurrentDiagnosisUc###";

                DataSet CurrentDiagnosis = new DataSet();
                string CurrentDiagnosisString = string.Empty;
                SqlParameter[] _objectSqlParmeters = null;
                try
                {
                    _objectSqlParmeters = new SqlParameter[1];
                    _objectSqlParmeters[0] = new SqlParameter("@ClientId", SHS.BaseLayer.BaseCommonFunctions.ApplicationInfo.Client.ClientId);
                    SqlHelper.FillDataset(Connection.ConnectionString, CommandType.StoredProcedure, "ssp_SCGetCurrentDiagnosis", CurrentDiagnosis, new string[] { "DocumentDiagnosisCodes", "DocumentDiagnosis" }, _objectSqlParmeters);
                    if (CurrentDiagnosis != null)
                    {
                        //PreviousDiagnosisString = PreviosDiagnosis.GetXml().ToString();
                        literalHtmlText.Text = CurrentDiagnosis.GetXml().ToString();
                    }

                }
                finally
                {
                    if (CurrentDiagnosis != null) CurrentDiagnosis.Dispose();
                    _objectSqlParmeters = null;
                }
                literalEnd.Text = "###EndCurrentDiagnosisUc###";
                PanelLoadUC.Controls.Add(literalStart);
                PanelLoadUC.Controls.Add(literalHtmlText);
                PanelLoadUC.Controls.Add(literalEnd);
            }
            
        }
}
}
using System;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.Script.Serialization;
using System.Web.UI;
using SHS.BaseLayer;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using SHS.UserBusinessServices;
using System.Xml.Serialization;
using SHS.BaseLayer.ActivityPages;
using System.Web;
using System.Data.Sql;
using System.Data.SqlClient;
using Microsoft.ApplicationBlocks.Data;
using SHS.DataServices;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Data;

public partial class Custom_IncidentReport_WebPages_IncidentReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string functionName = string.Empty;
        functionName = Request.QueryString["FunctionName"].ToString();
        switch (functionName)
        {
            case "GetSubGlobalCodes":
                BindSecondaryIncident();
                break;
            case "GetSignRecord":
                GetSignRecord();
                break;
            case "GetSignSuffix":
                GetSignSuffix();
                break;
            case "FillProgramDropDown":
                FillProgramDropDown();
                break;
            case "GetClientDOB" :
                GetClientDOB();
                break;
            case "GetStaff":
                GetStaff();
                break;
        }
    }
    private void BindSecondaryIncident()
    {
        DataView dataViewSecondaryIncident = null;
        int GlobalCodeId = 0;
        int.TryParse(Request.QueryString["GlobalCodeId"], out GlobalCodeId);

        dataViewSecondaryIncident = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalSubCodes);
        dataViewSecondaryIncident.RowFilter = "(RecordDeleted IS NULL OR RecordDeleted = 'N') AND Active='Y' AND GlobalCodeId='" + GlobalCodeId + "'";
        dataViewSecondaryIncident.Sort = "SubCodeName";
        if (dataViewSecondaryIncident != null)
        {
            if (dataViewSecondaryIncident.ToDataTable().Rows.Count > 0)
            {
                List<IncidentSubCodes> SecondaryIncident = dataViewSecondaryIncident.ToDataTable().Select().Select(t => new IncidentSubCodes
                {
                    CodeName = Convert.ToString(t["SubCodeName"]),
                    GlobalCodeId = Convert.ToString(t["GlobalSubCodeId"]),
                    Code = Convert.ToString(t["Code"])
                }).ToList();
                Response.Clear();
                XmlSerializer s = new XmlSerializer(SecondaryIncident.GetType());
                s.Serialize(Response.OutputStream, SecondaryIncident);
                Response.ContentType = "text/xml";
                Response.End();
            }
        }
    }
    private void GetStaff()
    {
        int ProgramId = 0;
            int.TryParse(Request.Form["ProgramId"], out ProgramId);
            DataSet dsStaff = new DataSet();
         string Staff = string.Empty;
        SqlParameter[] _Parameters=null;
        _Parameters=new SqlParameter[1];
        _Parameters[0]=new SqlParameter("@ProgramId",ProgramId);
       
        SqlHelper.FillDataset(Connection.ConnectionString, CommandType.StoredProcedure, "csp_GetStafflPrograms",dsStaff, new string[] { "StaffPrograms", "StaffSupervisorPrograms","Nurse","Behaviourist","AllStaff","Managers" }, _Parameters);
        
        if (dsStaff.Tables.Count > 0)
        {
            Staff = dsStaff.GetXml().ToString();    
        }
        Response.Clear();
        Response.Write(Staff);
        Response.End();
    }
    private void GetSignRecord()
    {
        string SignSection;
        if (Request.Form["SignSection"] != null)
        {
            SignSection = Request.Form["SignSection"].ToString();
            if (SignSection == "Details")
            {
                string IncidentReportDetailId = BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomIncidentReportDetails"].Rows[0]["IncidentReportDetailId"].ToString();
                SqlParameter[] _objectSqlParmeters = null;
                byte[] bytes = null;
                if (Request.Form["signType"] == "S")
                {
                    bytes = Encoding.UTF8.GetBytes(Request.Form["signatureString"]);
                }
                _objectSqlParmeters = new SqlParameter[4];
                _objectSqlParmeters[0] = new SqlParameter("@PKID", IncidentReportDetailId);
                _objectSqlParmeters[1] = new SqlParameter("@SignedBy", BaseCommonFunctions.ApplicationInfo.LoggedInUser.LoggedinUserId);
                _objectSqlParmeters[2] = new SqlParameter("@TableName", "CustomIncidentReportDetails");
                _objectSqlParmeters[3] = new SqlParameter("@PhysicalSignature", bytes);
                _objectSqlParmeters[3].SqlDbType = SqlDbType.Image;

                DataSet dsIP = new DataSet();
                SqlHelper.FillDataset(Connection.ConnectionString, CommandType.StoredProcedure, "CSP_UpdateSignatureDetail", dsIP, new string[] { "CustomIncidentReportDetails" }, _objectSqlParmeters);
                if (dsIP.Tables.Count > 0)
                {
                    BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomIncidentReportDetails"].Clear();
                    BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomIncidentReportDetails"].Merge(dsIP.Tables["CustomIncidentReportDetails"]);
                }
            }
            if (SignSection == "IndividualStatus")
            {
                string IncidentReportFollowUpOfIndividualStatusId = BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomIncidentReportFollowUpOfIndividualStatuses"].Rows[0]["IncidentReportFollowUpOfIndividualStatusId"].ToString();
                SqlParameter[] _objectSqlParmeters = null;
                byte[] bytes = null;
                if (Request.Form["signType"] == "S")
                {
                    bytes = Encoding.UTF8.GetBytes(Request.Form["signatureString"]);
                }
                _objectSqlParmeters = new SqlParameter[4];
                _objectSqlParmeters[0] = new SqlParameter("@PKID", IncidentReportFollowUpOfIndividualStatusId);
                _objectSqlParmeters[1] = new SqlParameter("@SignedBy", BaseCommonFunctions.ApplicationInfo.LoggedInUser.LoggedinUserId);
                _objectSqlParmeters[2] = new SqlParameter("@TableName", "CustomIncidentReportFollowUpOfIndividualStatuses");
                _objectSqlParmeters[3] = new SqlParameter("@PhysicalSignature", bytes);
                _objectSqlParmeters[3].SqlDbType = SqlDbType.Image;

                DataSet dsIP = new DataSet();
                SqlHelper.FillDataset(Connection.ConnectionString, CommandType.StoredProcedure, "CSP_UpdateSignatureDetail", dsIP, new string[] { "CustomIncidentReportFollowUpOfIndividualStatuses" }, _objectSqlParmeters);
                if (dsIP.Tables.Count > 0)
                {
                    BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomIncidentReportFollowUpOfIndividualStatuses"].Clear();
                    BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomIncidentReportFollowUpOfIndividualStatuses"].Merge(dsIP.Tables["CustomIncidentReportFollowUpOfIndividualStatuses"]);
                }
            }
            if (SignSection == "SupervisorFollowUp")
            {
                string IncidentReportSupervisorFollowUpId = BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomIncidentReportSupervisorFollowUps"].Rows[0]["IncidentReportSupervisorFollowUpId"].ToString();
                SqlParameter[] _objectSqlParmeters = null;
                byte[] bytes = null;
                if (Request.Form["signType"] == "S")
                {
                    bytes = Encoding.UTF8.GetBytes(Request.Form["signatureString"]);
                }
                _objectSqlParmeters = new SqlParameter[4];
                _objectSqlParmeters[0] = new SqlParameter("@PKID", IncidentReportSupervisorFollowUpId);
                _objectSqlParmeters[1] = new SqlParameter("@SignedBy", BaseCommonFunctions.ApplicationInfo.LoggedInUser.LoggedinUserId);
                _objectSqlParmeters[2] = new SqlParameter("@TableName", "CustomIncidentReportSupervisorFollowUps");
                _objectSqlParmeters[3] = new SqlParameter("@PhysicalSignature", bytes);
                _objectSqlParmeters[3].SqlDbType = SqlDbType.Image;

                DataSet dsIP = new DataSet();
                SqlHelper.FillDataset(Connection.ConnectionString, CommandType.StoredProcedure, "CSP_UpdateSignatureDetail", dsIP, new string[] { "CustomIncidentReportSupervisorFollowUps" }, _objectSqlParmeters);
                if (dsIP.Tables.Count > 0)
                {
                    BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomIncidentReportSupervisorFollowUps"].Clear();
                    BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomIncidentReportSupervisorFollowUps"].Merge(dsIP.Tables["CustomIncidentReportSupervisorFollowUps"]);
                }
            }
            if (SignSection == "IncidentReportManagerFollowUp")
            {
                string IncidentReportManagerFollowUpId = BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomIncidentReportManagerFollowUps"].Rows[0]["IncidentReportManagerFollowUpId"].ToString();
                SqlParameter[] _objectSqlParmeters = null;
                byte[] bytes = null;
                if (Request.Form["signType"] == "S")
                {
                    bytes = Encoding.UTF8.GetBytes(Request.Form["signatureString"]);
                }
                _objectSqlParmeters = new SqlParameter[4];
                _objectSqlParmeters[0] = new SqlParameter("@PKID", IncidentReportManagerFollowUpId);
                _objectSqlParmeters[1] = new SqlParameter("@SignedBy", BaseCommonFunctions.ApplicationInfo.LoggedInUser.LoggedinUserId);
                _objectSqlParmeters[2] = new SqlParameter("@TableName", "CustomIncidentReportManagerFollowUps");
                _objectSqlParmeters[3] = new SqlParameter("@PhysicalSignature", bytes);
                _objectSqlParmeters[3].SqlDbType = SqlDbType.Image;

                DataSet dsIP = new DataSet();
                SqlHelper.FillDataset(Connection.ConnectionString, CommandType.StoredProcedure, "CSP_UpdateSignatureDetail", dsIP, new string[] { "CustomIncidentReportManagerFollowUps" }, _objectSqlParmeters);
                if (dsIP.Tables.Count > 0)
                {
                    BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomIncidentReportManagerFollowUps"].Clear();
                    BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomIncidentReportManagerFollowUps"].Merge(dsIP.Tables["CustomIncidentReportManagerFollowUps"]);
                }
            }
            if (SignSection == "AdministratorReview")
            {
                string IncidentReportAdministratorReviewId = BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomIncidentReportAdministratorReviews"].Rows[0]["IncidentReportAdministratorReviewId"].ToString();
                SqlParameter[] _objectSqlParmeters = null;
                byte[] bytes = null;
                if (Request.Form["signType"] == "S")
                {
                    bytes = Encoding.UTF8.GetBytes(Request.Form["signatureString"]);
                }
                _objectSqlParmeters = new SqlParameter[4];
                _objectSqlParmeters[0] = new SqlParameter("@PKID", IncidentReportAdministratorReviewId);
                _objectSqlParmeters[1] = new SqlParameter("@SignedBy", BaseCommonFunctions.ApplicationInfo.LoggedInUser.LoggedinUserId);
                _objectSqlParmeters[2] = new SqlParameter("@TableName", "CustomIncidentReportAdministratorReviews");
                _objectSqlParmeters[3] = new SqlParameter("@PhysicalSignature", bytes);
                _objectSqlParmeters[3].SqlDbType = SqlDbType.Image;

                DataSet dsIP = new DataSet();
                SqlHelper.FillDataset(Connection.ConnectionString, CommandType.StoredProcedure, "CSP_UpdateSignatureDetail", dsIP, new string[] { "CustomIncidentReportAdministratorReviews" }, _objectSqlParmeters);
                if (dsIP.Tables.Count > 0)
                {
                    BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomIncidentReportAdministratorReviews"].Clear();
                    BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomIncidentReportAdministratorReviews"].Merge(dsIP.Tables["CustomIncidentReportAdministratorReviews"]);
                }
            }
            if (SignSection == "FallDetails")
            {
                string IncidentReportFallDetailId = BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomIncidentReportFallDetails"].Rows[0]["IncidentReportFallDetailId"].ToString();
                SqlParameter[] _objectSqlParmeters = null;
                byte[] bytes = null;
                if (Request.Form["signType"] == "S")
                {
                    bytes = Encoding.UTF8.GetBytes(Request.Form["signatureString"]);
                }
                _objectSqlParmeters = new SqlParameter[4];
                _objectSqlParmeters[0] = new SqlParameter("@PKID", IncidentReportFallDetailId);
                _objectSqlParmeters[1] = new SqlParameter("@SignedBy", BaseCommonFunctions.ApplicationInfo.LoggedInUser.LoggedinUserId);
                _objectSqlParmeters[2] = new SqlParameter("@TableName", "CustomIncidentReportFallDetails");
                _objectSqlParmeters[3] = new SqlParameter("@PhysicalSignature", bytes);
                _objectSqlParmeters[3].SqlDbType = SqlDbType.Image;

                DataSet dsIP = new DataSet();
                SqlHelper.FillDataset(Connection.ConnectionString, CommandType.StoredProcedure, "CSP_UpdateSignatureDetail", dsIP, new string[] { "CustomIncidentReportFallDetails" }, _objectSqlParmeters);
                if (dsIP.Tables.Count > 0)
                {
                    BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomIncidentReportFallDetails"].Clear();
                    BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomIncidentReportFallDetails"].Merge(dsIP.Tables["CustomIncidentReportFallDetails"]);
                }
            }

            if (SignSection == "FallIndividualStatus")
            {
                string IncidentReportFallFollowUpOfIndividualStatusId = BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomIncidentReportFallFollowUpOfIndividualStatuses"].Rows[0]["IncidentReportFallFollowUpOfIndividualStatusId"].ToString();
                SqlParameter[] _objectSqlParmeters = null;
                byte[] bytes = null;
                if (Request.Form["signType"] == "S")
                {
                    bytes = Encoding.UTF8.GetBytes(Request.Form["signatureString"]);
                }
                _objectSqlParmeters = new SqlParameter[4];
                _objectSqlParmeters[0] = new SqlParameter("@PKID", IncidentReportFallFollowUpOfIndividualStatusId);
                _objectSqlParmeters[1] = new SqlParameter("@SignedBy", BaseCommonFunctions.ApplicationInfo.LoggedInUser.LoggedinUserId);
                _objectSqlParmeters[2] = new SqlParameter("@TableName", "CustomIncidentReportFallFollowUpOfIndividualStatuses");
                _objectSqlParmeters[3] = new SqlParameter("@PhysicalSignature", bytes);
                _objectSqlParmeters[3].SqlDbType = SqlDbType.Image;

                DataSet dsIP = new DataSet();
                SqlHelper.FillDataset(Connection.ConnectionString, CommandType.StoredProcedure, "CSP_UpdateSignatureDetail", dsIP, new string[] { "CustomIncidentReportFallFollowUpOfIndividualStatuses" }, _objectSqlParmeters);
                if (dsIP.Tables.Count > 0)
                {
                    BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomIncidentReportFallFollowUpOfIndividualStatuses"].Clear();
                    BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomIncidentReportFallFollowUpOfIndividualStatuses"].Merge(dsIP.Tables["CustomIncidentReportFallFollowUpOfIndividualStatuses"]);
                }
            }
            if (SignSection == "FallSupervisorFollowUp")
            {
                string IncidentReportFallSupervisorFollowUpId = BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomIncidentReportFallSupervisorFollowUps"].Rows[0]["IncidentReportFallSupervisorFollowUpId"].ToString();
                SqlParameter[] _objectSqlParmeters = null;
                byte[] bytes = null;
                if (Request.Form["signType"] == "S")
                {
                    bytes = Encoding.UTF8.GetBytes(Request.Form["signatureString"]);
                }
                _objectSqlParmeters = new SqlParameter[4];
                _objectSqlParmeters[0] = new SqlParameter("@PKID", IncidentReportFallSupervisorFollowUpId);
                _objectSqlParmeters[1] = new SqlParameter("@SignedBy", BaseCommonFunctions.ApplicationInfo.LoggedInUser.LoggedinUserId);
                _objectSqlParmeters[2] = new SqlParameter("@TableName", "CustomIncidentReportFallSupervisorFollowUps");
                _objectSqlParmeters[3] = new SqlParameter("@PhysicalSignature", bytes);
                _objectSqlParmeters[3].SqlDbType = SqlDbType.Image;

                DataSet dsIP = new DataSet();
                SqlHelper.FillDataset(Connection.ConnectionString, CommandType.StoredProcedure, "CSP_UpdateSignatureDetail", dsIP, new string[] { "CustomIncidentReportFallSupervisorFollowUps" }, _objectSqlParmeters);
                if (dsIP.Tables.Count > 0)
                {
                    BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomIncidentReportFallSupervisorFollowUps"].Clear();
                    BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomIncidentReportFallSupervisorFollowUps"].Merge(dsIP.Tables["CustomIncidentReportFallSupervisorFollowUps"]);
                }
            }
            if (SignSection == "FallManagerFollowUp")
            {
                string IncidentReportFallManagerFollowUpId = BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomIncidentReportFallManagerFollowUps"].Rows[0]["IncidentReportFallManagerFollowUpId"].ToString();
                SqlParameter[] _objectSqlParmeters = null;
                byte[] bytes = null;
                if (Request.Form["signType"] == "S")
                {
                    bytes = Encoding.UTF8.GetBytes(Request.Form["signatureString"]);
                }
                _objectSqlParmeters = new SqlParameter[4];
                _objectSqlParmeters[0] = new SqlParameter("@PKID", IncidentReportFallManagerFollowUpId);
                _objectSqlParmeters[1] = new SqlParameter("@SignedBy", BaseCommonFunctions.ApplicationInfo.LoggedInUser.LoggedinUserId);
                _objectSqlParmeters[2] = new SqlParameter("@TableName", "CustomIncidentReportFallManagerFollowUps");
                _objectSqlParmeters[3] = new SqlParameter("@PhysicalSignature", bytes);
                _objectSqlParmeters[3].SqlDbType = SqlDbType.Image;

                DataSet dsIP = new DataSet();
                SqlHelper.FillDataset(Connection.ConnectionString, CommandType.StoredProcedure, "CSP_UpdateSignatureDetail", dsIP, new string[] { "CustomIncidentReportFallManagerFollowUps" }, _objectSqlParmeters);
                if (dsIP.Tables.Count > 0)
                {
                    BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomIncidentReportFallManagerFollowUps"].Clear();
                    BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomIncidentReportFallManagerFollowUps"].Merge(dsIP.Tables["CustomIncidentReportFallManagerFollowUps"]);
                }
            }
            if (SignSection == "FallAdministrators")
            {
                string IncidentReportFallAdministratorReviewId = BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomIncidentReportFallAdministratorReviews"].Rows[0]["IncidentReportFallAdministratorReviewId"].ToString();
                SqlParameter[] _objectSqlParmeters = null;
                byte[] bytes = null;
                if (Request.Form["signType"] == "S")
                {
                    bytes = Encoding.UTF8.GetBytes(Request.Form["signatureString"]);
                }
                _objectSqlParmeters = new SqlParameter[4];
                _objectSqlParmeters[0] = new SqlParameter("@PKID", IncidentReportFallAdministratorReviewId);
                _objectSqlParmeters[1] = new SqlParameter("@SignedBy", BaseCommonFunctions.ApplicationInfo.LoggedInUser.LoggedinUserId);
                _objectSqlParmeters[2] = new SqlParameter("@TableName", "CustomIncidentReportFallAdministratorReviews");
                _objectSqlParmeters[3] = new SqlParameter("@PhysicalSignature", bytes);
                _objectSqlParmeters[3].SqlDbType = SqlDbType.Image;

                DataSet dsIP = new DataSet();
                SqlHelper.FillDataset(Connection.ConnectionString, CommandType.StoredProcedure, "CSP_UpdateSignatureDetail", dsIP, new string[] { "CustomIncidentReportFallAdministratorReviews" }, _objectSqlParmeters);
                if (dsIP.Tables.Count > 0)
                {
                    BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomIncidentReportFallAdministratorReviews"].Clear();
                    BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomIncidentReportFallAdministratorReviews"].Merge(dsIP.Tables["CustomIncidentReportFallAdministratorReviews"]);
                }
            }
            if (SignSection == "SeizureDetails")
            {
                string IncidentSeizureDetailId = BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomIncidentSeizureDetails"].Rows[0]["IncidentSeizureDetailId"].ToString();
                SqlParameter[] _objectSqlParmeters = null;
                byte[] bytes = null;
                if (Request.Form["signType"] == "S")
                {
                    bytes = Encoding.UTF8.GetBytes(Request.Form["signatureString"]);
                }
                _objectSqlParmeters = new SqlParameter[4];
                _objectSqlParmeters[0] = new SqlParameter("@PKID", IncidentSeizureDetailId);
                _objectSqlParmeters[1] = new SqlParameter("@SignedBy", BaseCommonFunctions.ApplicationInfo.LoggedInUser.LoggedinUserId);
                _objectSqlParmeters[2] = new SqlParameter("@TableName", "CustomIncidentSeizureDetails");
                _objectSqlParmeters[3] = new SqlParameter("@PhysicalSignature", bytes);
                _objectSqlParmeters[3].SqlDbType = SqlDbType.Image;

                DataSet dsIP = new DataSet();
                SqlHelper.FillDataset(Connection.ConnectionString, CommandType.StoredProcedure, "CSP_UpdateSignatureDetail", dsIP, new string[] { "CustomIncidentSeizureDetails" }, _objectSqlParmeters);
                if (dsIP.Tables.Count > 0)
                {
                    BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomIncidentSeizureDetails"].Clear();
                    BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomIncidentSeizureDetails"].Merge(dsIP.Tables["CustomIncidentSeizureDetails"]);
                }
            }
            if (SignSection == "SeizureIndividualStatus")
            {
                string IncidentReportSeizureFollowUpOfIndividualStatusId = BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomIncidentReportSeizureFollowUpOfIndividualStatuses"].Rows[0]["IncidentReportSeizureFollowUpOfIndividualStatusId"].ToString();
                SqlParameter[] _objectSqlParmeters = null;
                byte[] bytes = null;
                if (Request.Form["signType"] == "S")
                {
                    bytes = Encoding.UTF8.GetBytes(Request.Form["signatureString"]);
                }
                _objectSqlParmeters = new SqlParameter[4];
                _objectSqlParmeters[0] = new SqlParameter("@PKID", IncidentReportSeizureFollowUpOfIndividualStatusId);
                _objectSqlParmeters[1] = new SqlParameter("@SignedBy", BaseCommonFunctions.ApplicationInfo.LoggedInUser.LoggedinUserId);
                _objectSqlParmeters[2] = new SqlParameter("@TableName", "CustomIncidentReportSeizureFollowUpOfIndividualStatuses");
                _objectSqlParmeters[3] = new SqlParameter("@PhysicalSignature", bytes);
                _objectSqlParmeters[3].SqlDbType = SqlDbType.Image;

                DataSet dsIP = new DataSet();
                SqlHelper.FillDataset(Connection.ConnectionString, CommandType.StoredProcedure, "CSP_UpdateSignatureDetail", dsIP, new string[] { "CustomIncidentReportSeizureFollowUpOfIndividualStatuses" }, _objectSqlParmeters);
                if (dsIP.Tables.Count > 0)
                {
                    BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomIncidentReportSeizureFollowUpOfIndividualStatuses"].Clear();
                    BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomIncidentReportSeizureFollowUpOfIndividualStatuses"].Merge(dsIP.Tables["CustomIncidentReportSeizureFollowUpOfIndividualStatuses"]);
                }
            }
            if (SignSection == "SeizureSupervisorFollowUp")
            {
                string IncidentReportSeizureSupervisorFollowUpId = BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomIncidentReportSeizureSupervisorFollowUps"].Rows[0]["IncidentReportSeizureSupervisorFollowUpId"].ToString();
                SqlParameter[] _objectSqlParmeters = null;
                byte[] bytes = null;
                if (Request.Form["signType"] == "S")
                {
                    bytes = Encoding.UTF8.GetBytes(Request.Form["signatureString"]);
                }
                _objectSqlParmeters = new SqlParameter[4];
                _objectSqlParmeters[0] = new SqlParameter("@PKID", IncidentReportSeizureSupervisorFollowUpId);
                _objectSqlParmeters[1] = new SqlParameter("@SignedBy", BaseCommonFunctions.ApplicationInfo.LoggedInUser.LoggedinUserId);
                _objectSqlParmeters[2] = new SqlParameter("@TableName", "CustomIncidentReportSeizureSupervisorFollowUps");
                _objectSqlParmeters[3] = new SqlParameter("@PhysicalSignature", bytes);
                _objectSqlParmeters[3].SqlDbType = SqlDbType.Image;

                DataSet dsIP = new DataSet();
                SqlHelper.FillDataset(Connection.ConnectionString, CommandType.StoredProcedure, "CSP_UpdateSignatureDetail", dsIP, new string[] { "CustomIncidentReportSeizureSupervisorFollowUps" }, _objectSqlParmeters);
                if (dsIP.Tables.Count > 0)
                {
                    BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomIncidentReportSeizureSupervisorFollowUps"].Clear();
                    BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomIncidentReportSeizureSupervisorFollowUps"].Merge(dsIP.Tables["CustomIncidentReportSeizureSupervisorFollowUps"]);
                }
            }
            if (SignSection == "SeizureAdministrators")
            {
                string IncidentReportSeizureAdministratorReviewId = BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomIncidentReportSeizureAdministratorReviews"].Rows[0]["IncidentReportSeizureAdministratorReviewId"].ToString();
                SqlParameter[] _objectSqlParmeters = null;
                byte[] bytes = null;
                if (Request.Form["signType"] == "S")
                {
                    bytes = Encoding.UTF8.GetBytes(Request.Form["signatureString"]);
                }
                _objectSqlParmeters = new SqlParameter[4];
                _objectSqlParmeters[0] = new SqlParameter("@PKID", IncidentReportSeizureAdministratorReviewId);
                _objectSqlParmeters[1] = new SqlParameter("@SignedBy", BaseCommonFunctions.ApplicationInfo.LoggedInUser.LoggedinUserId);
                _objectSqlParmeters[2] = new SqlParameter("@TableName", "CustomIncidentReportSeizureAdministratorReviews");
                _objectSqlParmeters[3] = new SqlParameter("@PhysicalSignature", bytes);
                _objectSqlParmeters[3].SqlDbType = SqlDbType.Image;

                DataSet dsIP = new DataSet();
                SqlHelper.FillDataset(Connection.ConnectionString, CommandType.StoredProcedure, "CSP_UpdateSignatureDetail", dsIP, new string[] { "CustomIncidentReportSeizureAdministratorReviews" }, _objectSqlParmeters);
                if (dsIP.Tables.Count > 0)
                {
                    BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomIncidentReportSeizureAdministratorReviews"].Clear();
                    BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomIncidentReportSeizureAdministratorReviews"].Merge(dsIP.Tables["CustomIncidentReportSeizureAdministratorReviews"]);
                }
            }
            if (SignSection == "SeizuretManagerFollowUp")
            {
                string IncidentReportSeizureManagerFollowUpId = BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomIncidentReportSeizureManagerFollowUps"].Rows[0]["IncidentReportSeizureManagerFollowUpId"].ToString();
                SqlParameter[] _objectSqlParmeters = null;
                byte[] bytes = null;
                if (Request.Form["signType"] == "S")
                {
                    bytes = Encoding.UTF8.GetBytes(Request.Form["signatureString"]);
                }
                _objectSqlParmeters = new SqlParameter[4];
                _objectSqlParmeters[0] = new SqlParameter("@PKID", IncidentReportSeizureManagerFollowUpId);
                _objectSqlParmeters[1] = new SqlParameter("@SignedBy", BaseCommonFunctions.ApplicationInfo.LoggedInUser.LoggedinUserId);
                _objectSqlParmeters[2] = new SqlParameter("@TableName", "CustomIncidentReportSeizureManagerFollowUps");
                _objectSqlParmeters[3] = new SqlParameter("@PhysicalSignature", bytes);
                _objectSqlParmeters[3].SqlDbType = SqlDbType.Image;

                DataSet dsIP = new DataSet();
                SqlHelper.FillDataset(Connection.ConnectionString, CommandType.StoredProcedure, "CSP_UpdateSignatureDetail", dsIP, new string[] { "CustomIncidentReportSeizureManagerFollowUps" }, _objectSqlParmeters);
                if (dsIP.Tables.Count > 0)
                {
                    BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomIncidentReportSeizureManagerFollowUps"].Clear();
                    BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomIncidentReportSeizureManagerFollowUps"].Merge(dsIP.Tables["CustomIncidentReportSeizureManagerFollowUps"]);
                }
            }
        }

        //DataSet dataSetTemp = SHS.BaseLayer.BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.GetXml();
        //string pageDataSetXml = dataSetTemp.GetXml();
        Response.Clear();
        Response.Write(SHS.BaseLayer.BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.GetXml());
        Response.End();
    }

    [Serializable]
    public class IncidentSubCodes
    {
        public string CodeName { get; set; }
        public string GlobalCodeId { get; set; }
        public string Code { get; set; }


    }
    public class Staff
    {
        public string DisplayAs { get; set; }
        public string StaffId { get; set; } 
    }
    private void GetSignSuffix()
    {
        int StaffId;
        String Suffix;
        StaffId = Convert.ToInt32(Request.Form["StaffId"].ToString());
        DataView dataViewCodeName = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.Staff);
        dataViewCodeName.RowFilter = "StaffId=" + StaffId;
        Suffix = dataViewCodeName[0]["SigningSuffix"].ToString();
        Response.Clear();
        Response.Write(Suffix);
        Response.End();
    }
    private void FillProgramDropDown()
    {
        DataSet dsProgram = new DataSet();
        SqlParameter[] _objectSqlParmeters = null;
        int ClientId = 0;
        ClientId = Convert.ToInt32(Request.QueryString["ClientId"]);
        DataSet datasetobj = new DataSet();
        datasetobj = BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet;
        if (datasetobj != null && datasetobj.Tables.Contains("CustomIncidentReports") && datasetobj.Tables["CustomIncidentReports"].Rows.Count > 0)
        {
            if (ClientId > 0)
            {
                datasetobj.Tables["CustomIncidentReports"].Rows[0]["ClientId"] = ClientId;
                BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomIncidentReports"].Merge(datasetobj.Tables["CustomIncidentReports"]);

            }
        }
        StringBuilder stringBuilderHTML = null;
        stringBuilderHTML = new StringBuilder();
        stringBuilderHTML.Append("<option  value= " + "" + ">");
        stringBuilderHTML.Append("" + "</option>");
        _objectSqlParmeters = new SqlParameter[1];
        _objectSqlParmeters[0] = new SqlParameter("@ClientId", ClientId);
        SqlHelper.FillDataset(Connection.ConnectionString, CommandType.StoredProcedure, "csp_IndividualPrograms", dsProgram, new string[] { "ClientPrograms" }, _objectSqlParmeters);
        DataView dataViewProgram = dsProgram.Tables[0].DefaultView;

        if (dataViewProgram != null)
        {
            foreach (DataRowView drv in dataViewProgram)
            {


                stringBuilderHTML.Append("<option title='" + drv.Row.ItemArray[3].ToString() + "' value= " + drv.Row.ItemArray[0].ToString() + ">");
                stringBuilderHTML.Append(drv.Row.ItemArray[3].ToString() + "</option>");
            }
        }


        PlaceHolderControlPrograms.Controls.Add(new LiteralControl(stringBuilderHTML.ToString()));



    }
    private void GetClientDOB()
    {
        DataSet dataSetIncident = null;
        try
        {
            int ClientId = 0;
            ClientId = Convert.ToInt32(Request.Form["ClientId"]);
            SqlParameter[] _objectSqlParmeters = null;
            dataSetIncident = new DataSet();
            string Cdob = string.Empty;
            string FormatdDate = string.Empty;
            SqlHelper.FillDataset(Connection.ConnectionString, CommandType.Text, "select DOB from Clients where ClientId=" + ClientId, dataSetIncident, new string[] { "Clients" }, _objectSqlParmeters);
            Cdob=Convert.ToString(dataSetIncident.Tables["Clients"].Rows[0]["DOB"]);            
            Response.Clear();
            Response.Write(Cdob);
            Response.End();
        }
        finally
        {
            if (dataSetIncident != null)
            {
                dataSetIncident.Dispose();
            }
        }
    }
}
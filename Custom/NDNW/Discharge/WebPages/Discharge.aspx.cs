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
using System.Data.Linq.SqlClient;
using System.Data.SqlClient;
using Microsoft.ApplicationBlocks.Data;
using SHS.DataServices;

public partial class Custom_Discharge_WebPages_Discharge : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string functionName = string.Empty;
        functionName = Request.QueryString["FunctionName"].ToString();
        switch (functionName)
        {
            case "ClientProgramsList":
                GetClientProgramsList();
                break;
            case "BindGoalsObjectiveOneByOne":
                int GoalId = 0;
                string IndexNumber = string.Empty;
                if (Request.Form["goalId"] != null)
                    int.TryParse(Request.Form["goalId"].ToString(), out GoalId);
                if (Request.Form["indexNumber"] != null)
                    IndexNumber = Request.Form["indexNumber"].ToString().Trim();
                Response.Clear();
                Response.Write(GoalId.ToString().Trim() + "^" + IndexNumber);
                Response.End();
                break;
            //case "CheckPrimaryProgramType":
            //    CheckPrimaryProgramType();
            //    break;

            case "GetPreviousDiagnosis":
                string PreviosDiagnosisString = "";
                PreviosDiagnosisString = getPreviousDiagnosis();
                Response.Clear();
                Response.Write(PreviosDiagnosisString);
                Response.End();
                break;

            case "CurrentMedicationsListForLMH":
                DataSet PIECurrentMedication = new DataSet();
                PIECurrentMedication = dataSetGetCurrentMedication();
                StringWriter sw = new StringWriter();
                PIECurrentMedication.WriteXml(sw);
                string resultPIE = sw.ToString();
                Response.Write(resultPIE);
                Response.End();
                break;

            case "GetGoalsObjectives":
                DataSet GoalsObjectives = new DataSet();
                GoalsObjectives = dataSetGetGoalsObjectives();
                StringWriter swgoals = new StringWriter();
                GoalsObjectives.WriteXml(swgoals);
                string resultGoals = swgoals.ToString();
                Response.Write(resultGoals);
                Response.End();
                break;
            case "GetReferralSubtypeByGlobalCode":
                GetReferralSubtypeByGlobalCodeClientInfo();
                break;

        }
    }



    public DataSet dataSetGetGoalsObjectives()
    {
        SqlParameter[] _objectSqlParmeters = null;
        DataSet dsGoals = null;        
        try
        {
            dsGoals = new DataSet();          
            _objectSqlParmeters = new SqlParameter[3];
            _objectSqlParmeters[0] = new SqlParameter("@ClientId", SHS.BaseLayer.BaseCommonFunctions.ApplicationInfo.Client.ClientId);
            _objectSqlParmeters[1] = new SqlParameter("@StaffId", SHS.BaseLayer.BaseCommonFunctions.ApplicationInfo.LoggedInUser.UserId);
            _objectSqlParmeters[2] = new SqlParameter("@CustomParameters", string.Empty);
            SqlHelper.FillDataset(Connection.ConnectionString, CommandType.StoredProcedure, "csp_ObjectiveProgressGoals", dsGoals, new string[] { "CustomDischargeCarePlanGoalReviews" }, _objectSqlParmeters);
            return dsGoals;
        }
        finally
        {
            if (dsGoals != null) dsGoals.Dispose();
            _objectSqlParmeters = null;
        }
    }

    public DataSet dataSetGetCurrentMedication()
    {
        SqlParameter[] _objectSqlParmeters = null;
        DataSet dataSetGetCurrentMedication = null;
        try
        {
            dataSetGetCurrentMedication = new DataSet();
            _objectSqlParmeters = new SqlParameter[1];
            _objectSqlParmeters[0] = new SqlParameter("@ClientId", SHS.BaseLayer.BaseCommonFunctions.ApplicationInfo.Client.ClientId);
            SqlHelper.FillDataset(Connection.ConnectionString, CommandType.StoredProcedure, "csp_SCGetDischargeSummaryCurrentMedicationlist", dataSetGetCurrentMedication, new string[] { "ClientMedications", "CurrentMedicationHistory" }, _objectSqlParmeters);
            return dataSetGetCurrentMedication;
        }
        finally
        {
            if (dataSetGetCurrentMedication != null) dataSetGetCurrentMedication.Dispose();
            _objectSqlParmeters = null;
        }
    }

    public string getPreviousDiagnosis()
    {
        DataSet PreviosDiagnosis = new DataSet();
        string PreviousDiagnosisString = string.Empty;
        SqlParameter[] _objectSqlParmeters = null;
        try
        {
            _objectSqlParmeters = new SqlParameter[1];
            _objectSqlParmeters[0] = new SqlParameter("@ClientId", SHS.BaseLayer.BaseCommonFunctions.ApplicationInfo.Client.ClientId);
            SqlHelper.FillDataset(Connection.ConnectionString, CommandType.StoredProcedure, "csp_SCGetPreviousDiagnosis", PreviosDiagnosis, new string[] { "DocumentDiagnosisCodes", "DocumentDiagnosis", "DocumentDiagnosisFactors" }, _objectSqlParmeters);
            if (PreviosDiagnosis != null)
            {
                PreviousDiagnosisString = PreviosDiagnosis.GetXml().ToString();
            }
            return PreviousDiagnosisString;
        }
        finally
        {
            if (PreviosDiagnosis != null) PreviosDiagnosis.Dispose();
            _objectSqlParmeters = null;
        }

    }

    public void GetClientProgramsList()
    {
        StringBuilder ClientProgramsList = null;
        ClientProgramsList = new StringBuilder();

        SqlParameter[] _objectSqlParmeters = null;
        _objectSqlParmeters = new SqlParameter[1];
        _objectSqlParmeters[0] = new SqlParameter("@ClientId", SHS.BaseLayer.BaseCommonFunctions.ApplicationInfo.Client.ClientId);
        DataSet dataSetClientProgramsList = new DataSet();
        SqlHelper.FillDataset(Connection.ConnectionString, CommandType.StoredProcedure, "csp_GetClientProgramsList", dataSetClientProgramsList, new string[] { "ClientProgramsList" }, _objectSqlParmeters);

        if (dataSetClientProgramsList != null)
        {
            if (dataSetClientProgramsList.Tables.Count > 0 && dataSetClientProgramsList.Tables["ClientProgramsList"].Rows.Count > 0)
            {
                ClientProgramsList.Append("[");
                string CustomDischargeNewPrimaryProgramId = string.Empty;
                string primaryAssignment = string.Empty;
                //EI#677.2 - Analysis and Resolution to Fix - Exception: "There is no row at position 0" in SmartCare Application
                if (BaseCommonFunctions.GetScreenInfoDataSet().IsDataTableFound("CustomDocumentDischarges"))
                    CustomDischargeNewPrimaryProgramId = BaseCommonFunctions.GetScreenInfoDataSet().Tables["CustomDocumentDischarges"].Rows[0]["NewPrimaryClientProgramId"].ToString();

                for (int Count = 0; Count < dataSetClientProgramsList.Tables["ClientProgramsList"].Rows.Count; Count++)
                {
                    if (CustomDischargeNewPrimaryProgramId == dataSetClientProgramsList.Tables["ClientProgramsList"].Rows[Count]["ClientProgramId"].ToString())
                    {
                        primaryAssignment = "Y";
                    }
                    else
                    {
                        primaryAssignment = Convert.ToString(dataSetClientProgramsList.Tables["ClientProgramsList"].Rows[Count]["PrimaryAssignment"]);
                    }
                    ClientProgramsList.Append("{ " + "ProgramCode: \"" + Convert.ToString(dataSetClientProgramsList.Tables["ClientProgramsList"].Rows[Count]["ProgramCode"]) + "\"," + "PrimaryAssignment: \"" + primaryAssignment + "\"," + "ClientProgramId: " + Convert.ToString(dataSetClientProgramsList.Tables["ClientProgramsList"].Rows[Count]["ClientProgramId"]) + "," + "EnrolledDate: \"" + Convert.ToString(dataSetClientProgramsList.Tables["ClientProgramsList"].Rows[Count]["EnrolledDate"]) + "\" },");
                }
                ClientProgramsList = ClientProgramsList.Remove(ClientProgramsList.Length - 1, 1);
                ClientProgramsList.Append("];");

            }
            else
            {
                ClientProgramsList.Append("[];");
            }
        }
        Response.Clear();
        Response.Write(ClientProgramsList.ToString());
        Response.End();
    }

    private void GetReferralSubtypeByGlobalCodeClientInfo()
    {
        StringBuilder stringBuilderReferralSubtype = null;
        stringBuilderReferralSubtype = new StringBuilder();
        DataView dataViewReferralSubtype = null;
        int GlobalCodeId = 0;
        int.TryParse(Request.Form["GlobalCodeId"], out GlobalCodeId);

        dataViewReferralSubtype = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalSubCodes);
        dataViewReferralSubtype.RowFilter = "(RecordDeleted IS NULL OR RecordDeleted = 'N') AND Active='Y' AND GlobalCodeId='" + GlobalCodeId + "'";
        dataViewReferralSubtype.Sort = "SubCodeName";
        if (dataViewReferralSubtype != null)
        {
            if (dataViewReferralSubtype.ToDataTable().Rows.Count > 0)
            {
                List<ClientServicesView> permissionItemscollectionsPlan = dataViewReferralSubtype.ToDataTable().Select().Select(t => new ClientServicesView
                {
                    CodeName = Convert.ToString(t["SubCodeName"]),
                    GlobalCodeId = Convert.ToString(t["GlobalSubCodeId"])
                }).ToList();
                Response.Clear();
                XmlSerializer s = new XmlSerializer(permissionItemscollectionsPlan.GetType());
                s.Serialize(Response.OutputStream, permissionItemscollectionsPlan);
                Response.ContentType = "text/xml";
                Response.End();
            }
        }
    }

    [Serializable]
    public class ClientServicesView
    {
        public string CodeName { get; set; }
        public string GlobalCodeId { get; set; }

    }

    //public void CheckPrimaryProgramType()
    //{
    ////    int NewPrimaryClientProgramId = 0;
    ////    string ProgramType = string.Empty;

    ////    if (Request.Form["NewPrimaryClientProgramId"] != null)
    ////        int.TryParse(Request.Form["NewPrimaryClientProgramId"].ToString(), out NewPrimaryClientProgramId);

    ////    SqlParameter[] _objectSqlParmeters = null;
    ////    _objectSqlParmeters = new SqlParameter[1];
    ////    _objectSqlParmeters[0] = new SqlParameter("@ClientProgramId", NewPrimaryClientProgramId);
    ////    DataSet dataSetClientProgramsList = new DataSet();
    ////    SqlHelper.FillDataset(Connection.ConnectionString, CommandType.StoredProcedure, "csp_CheckPrimaryProgramType", dataSetClientProgramsList, new string[] { "ClientPrograms" }, _objectSqlParmeters);

    ////    if (dataSetClientProgramsList.Tables.Count > 0)
    ////    {
    ////        if (dataSetClientProgramsList.Tables["ClientPrograms"].Rows.Count > 0)
    ////        {
    ////            ProgramType = dataSetClientProgramsList.Tables["ClientPrograms"].Rows[0]["CategoryCode"].ToString().Trim();
    ////        }
    ////    }


    ////    Response.Clear();
    ////    Response.Write(ProgramType);
    ////    Response.End();
    //}
}

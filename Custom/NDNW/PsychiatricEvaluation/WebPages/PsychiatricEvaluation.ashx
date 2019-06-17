<%@ WebHandler Language="C#" Class="PsychiatricEvaluation" %>

using System;
using System.Web;
using System.Data;
using System.Linq;
using System.Text;
using System.Collections;
using System.Collections.Generic;
using System.Data.SqlClient;
using SHS.BaseLayer;
using SHS.DataServices;
using Microsoft.ApplicationBlocks.Data;

public class PsychiatricEvaluation : IHttpHandler, System.Web.SessionState.IRequiresSessionState
{

    public void ProcessRequest(HttpContext context)
    {
        string functionName = context.Request.Form["FunctionName"];
        if (!functionName.IsNullOrWhiteSpace())
        {
            switch (functionName.Trim())
            {
                case "GetPreviousDiagnosis":
                    string PreviosDiagnosisString = "";
                    PreviosDiagnosisString = getPreviousDiagnosis();
                    context.Response.Clear();
                    context.Response.Write(PreviosDiagnosisString);
                    context.Response.End();
                    break;
                case "GetNextAppointment":
                    string NextAppointmentString = "";
                    NextAppointmentString = getNextAppointmentString(context);
                    context.Response.Clear();
                    context.Response.Write(NextAppointmentString);
                    context.Response.End();
                    break;
                case "LoadVitals":
                    DataSet Vitals = new DataSet();
                    Vitals = dataSetGetVitals();
                    context.Response.Write(Vitals.Tables["CustomDocumentPsychiatricServiceNoteExams"].Rows[0]["VitalsPrevious"].ToString() + "#8#2#3$" + Vitals.Tables["CustomDocumentPsychiatricServiceNoteExams"].Rows[0]["VitalsCurrent"].ToString() + "#8#2#3$" + Vitals.Tables["CustomDocumentPsychiatricServiceNoteExams"].Rows[0]["CurreentVitalDate"].ToString() + "#8#2#3$" + Vitals.Tables["CustomDocumentPsychiatricServiceNoteExams"].Rows[0]["PreviousVitalDate"].ToString());
                    context.Response.End();
                    break;
                case "GetMedications":
                    string MedicationsString = "";
                    MedicationsString = getMedicationsString(context);
                    context.Response.Clear();
                    context.Response.Write(MedicationsString);
                    context.Response.End();
                    break;
                default:
                    break;
            }
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

    public string getNextAppointmentString(HttpContext context)
    {

        DataSet NextAppointment = new DataSet();
        string NextAppointmentString = string.Empty;
        SqlParameter[] _objectSqlParmeters = null;
        try
        {
            int ServiceId = 0;
            if (Convert.ToString(context.Request.Form["ServiceId"]) != string.Empty)
            {
                int.TryParse(Convert.ToString(context.Request.Form["ServiceId"]), out ServiceId);
            }

            int ProcedureCodeId = 0;
            if (!string.IsNullOrEmpty(SHS.BaseLayer.BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables[0].Rows[0]["ProcedureCodeId"].ToString()))
            {
                int.TryParse(SHS.BaseLayer.BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables[0].Rows[0]["ProcedureCodeId"].ToString(), out ProcedureCodeId);
            }

            DateTime DateOfService = new DateTime();
            if (!string.IsNullOrEmpty(SHS.BaseLayer.BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables[0].Rows[0]["DateOfService"].ToString()))
            {
                DateTime.TryParse(SHS.BaseLayer.BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables[0].Rows[0]["DateOfService"].ToString(), out DateOfService);
            }

            _objectSqlParmeters = new SqlParameter[5];
            _objectSqlParmeters[0] = new SqlParameter("@ServiceId", ServiceId);
            _objectSqlParmeters[1] = new SqlParameter("@LoggedInStaffId", SHS.BaseLayer.BaseCommonFunctions.ApplicationInfo.LoggedInUser.LoggedinUserId);
            _objectSqlParmeters[2] = new SqlParameter("@ClientId", SHS.BaseLayer.BaseCommonFunctions.ApplicationInfo.Client.ClientId);
            _objectSqlParmeters[3] = new SqlParameter("@ProcedureCodeId", ProcedureCodeId);
            _objectSqlParmeters[4] = new SqlParameter("@DateOfService", DateOfService);

            SqlHelper.FillDataset(Connection.ConnectionString, CommandType.StoredProcedure, "csp_GetPsychEvalNextAppointments", NextAppointment, new string[] { "Appointments" }, _objectSqlParmeters);
            if (NextAppointment != null)
            {
                NextAppointmentString = NextAppointment.GetXml().ToString();
            }
            return NextAppointmentString;
        }
        finally
        {
            if (NextAppointment != null) NextAppointment.Dispose();
            _objectSqlParmeters = null;
        }
    }

    public DataSet dataSetGetVitals()
    {
        SqlParameter[] _objectSqlParmeters = null;
        DataSet datasetVitals = null;
        try
        {
            datasetVitals = new DataSet();
            _objectSqlParmeters = new SqlParameter[1];
            _objectSqlParmeters[0] = new SqlParameter("@ClientId", SHS.BaseLayer.BaseCommonFunctions.ApplicationInfo.Client.ClientId);
            SqlHelper.FillDataset(Connection.ConnectionString, CommandType.StoredProcedure, "csp_SCGetVitals", datasetVitals, new string[] { "CustomDocumentPsychiatricServiceNoteExams" }, _objectSqlParmeters);
            return datasetVitals;
        }
        finally
        {
            if (datasetVitals != null) datasetVitals.Dispose();
            _objectSqlParmeters = null;
        }
    }

    public string getMedicationsString(HttpContext context)
    {
        DataSet MedicationsDataSet = new DataSet();
        string MedicationsString = string.Empty;
        SqlParameter[] _objectSqlParmeters = null;
        try
        {
            string DateOfService = string.Empty;
            DateOfService = Convert.ToString(context.Request.Form["DateOfService"]);
            if (string.IsNullOrEmpty(DateOfService) || DateOfService == "null")
            {
                DateOfService = DateTime.Now.ToShortDateString();
            }
            _objectSqlParmeters = new SqlParameter[2];
            _objectSqlParmeters[0] = new SqlParameter("@ClientId", SHS.BaseLayer.BaseCommonFunctions.ApplicationInfo.Client.ClientId);
            _objectSqlParmeters[1] = new SqlParameter("@DateOfService", DateOfService);
            SqlHelper.FillDataset(Connection.ConnectionString, CommandType.StoredProcedure, "csp_GetPsychNoteMedications", MedicationsDataSet, new string[] { "CurrentMedications", "DiscontinuedMedications", "SelfRepotedMedications" }, _objectSqlParmeters);
            if (MedicationsDataSet != null)
            {
                MedicationsString = MedicationsDataSet.GetXml().ToString();
            }
            return MedicationsString;
        }
        finally
        {
            if (MedicationsDataSet != null) MedicationsDataSet.Dispose();
            _objectSqlParmeters = null;
        }
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}
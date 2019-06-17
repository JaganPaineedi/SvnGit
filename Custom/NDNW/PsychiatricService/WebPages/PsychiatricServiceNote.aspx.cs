using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SHS.BaseLayer;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using SHS.UserBusinessServices;
using System.Xml.Serialization;
using SHS.BaseLayer.ActivityPages;
using System.Web;
using System.Data.SqlClient;
using Microsoft.ApplicationBlocks.Data;
using SHS.DataServices;

public partial class Custom_PsychiatricService_WebPages_PsychiatricServiceNote : System.Web.UI.Page
{
    string functionName = string.Empty;
    int problemCount = 0;
    protected void Page_Load(object sender, EventArgs e)
    {
        problemCount = 0;
        functionName = Request.Form["action"].ToString();
        switch (functionName.Trim())
        {
            case "getProblemSpan":
                DataSet datasetProblemSpan = null;
                datasetProblemSpan = SHS.BaseLayer.BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Copy();
                string[] service = (from pc in datasetProblemSpan.Tables["CustomPsychiatricServiceNoteProblems"].AsEnumerable()
                                    select getProblemCount(pc.Field<int>("PsychiatricServiceNoteProblemId").ToString())
                            ).ToArray();
                string serviceHtml = string.Join("", service);
                Response.Clear();
                Response.Write(serviceHtml.Trim());
                Response.End();
                break;
            case "bindProblems":
                int PsychiatricServiceNoteProblemId = 0;
                int.TryParse(Request.Form["PsychiatricServiceNoteProblemId"].ToString(), out PsychiatricServiceNoteProblemId);
                Response.Clear();
                Response.Write(PsychiatricServiceNoteProblemId.ToString().Trim());
                Response.End();
                break;
            case "LoadVitals":
                DataSet Vitals = new DataSet();
                Vitals = dataSetGetVitals();
                Response.Write(Vitals.Tables["CustomDocumentPsychiatricServiceNoteExams"].Rows[0]["VitalsPrevious"].ToString() + "#8#2#3$" + Vitals.Tables["CustomDocumentPsychiatricServiceNoteExams"].Rows[0]["VitalsCurrent"].ToString() + "#8#2#3$" + Vitals.Tables["CustomDocumentPsychiatricServiceNoteExams"].Rows[0]["CurreentVitalDate"].ToString() + "#8#2#3$" + Vitals.Tables["CustomDocumentPsychiatricServiceNoteExams"].Rows[0]["PreviousVitalDate"].ToString());
                Response.End();
                break;
            case "GetPreviousDiagnosis":
               string PreviosDiagnosisString = "";
                PreviosDiagnosisString = getPreviousDiagnosis();
                Response.Clear();
                Response.Write(PreviosDiagnosisString);
                Response.End();
                break;
            case "GetNextAppointment":
                string NextAppointmentString = "";
                NextAppointmentString = getNextAppointmentString();
                Response.Clear();
                Response.Write(NextAppointmentString);
                Response.End();
                break;
            case "GetMedications":
                string MedicationsString = "";
                MedicationsString = getMedicationsString();
                Response.Clear();
                Response.Write(MedicationsString);
                Response.End();
                break;
            default:
                break;
        }
    }
    public string getMedicationsString()
    {
        DataSet MedicationsDataSet = new DataSet();
        string MedicationsString = string.Empty;
        SqlParameter[] _objectSqlParmeters = null;
        try
        {
            string DateOfService = string.Empty;
            DateOfService = Convert.ToString(Request.Form["DateOfService"]);
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
    public string getNextAppointmentString()
    {

        DataSet NextAppointment = new DataSet();
        string NextAppointmentString = string.Empty;
        SqlParameter[] _objectSqlParmeters = null;
        try
        {
            int ServiceId = 0;
            if (Convert.ToString(Request.Form["ServiceId"]) != string.Empty)
            {
                int.TryParse(Convert.ToString(Request.Form["ServiceId"]), out ServiceId);
            }
            _objectSqlParmeters = new SqlParameter[3];
            _objectSqlParmeters[0] = new SqlParameter("@ServiceId", ServiceId);
            _objectSqlParmeters[1] = new SqlParameter("@LoggedInStaffId", SHS.BaseLayer.BaseCommonFunctions.ApplicationInfo.LoggedInUser.LoggedinUserId);
            _objectSqlParmeters[2] = new SqlParameter("@ClientId", SHS.BaseLayer.BaseCommonFunctions.ApplicationInfo.Client.ClientId);
            SqlHelper.FillDataset(Connection.ConnectionString, CommandType.StoredProcedure, "csp_GetPsychNoteNextAppointments", NextAppointment, new string[] { "Appointments" }, _objectSqlParmeters);
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
    protected string getProblemCount(string PsychiatricServiceNoteProblemId)
    {
        string result = string.Empty;
        problemCount++;
        result = "<span id=\"span_" + PsychiatricServiceNoteProblemId + "_problem\" problemcount=\"" + problemCount + "\"></span>";
        return result;
    }
}
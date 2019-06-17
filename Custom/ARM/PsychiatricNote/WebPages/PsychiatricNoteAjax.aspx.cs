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
//using PhilhavenUserBusinessServices;
using System.Xml.Serialization;
using SHS.BaseLayer.ActivityPages;
using System.Web;
using System.Linq;
using System.Data.SqlClient;
using Microsoft.ApplicationBlocks.Data;
using SHS.DataServices;
using System.Web.UI.HtmlControls;

public partial class PsychiatricNoteAjax : System.Web.UI.Page
{
    string functionName = string.Empty;
    int ProviderType = 0;
    protected void Page_Load(object sender, EventArgs e)
    {
        functionName = Request.QueryString["FunctionName"].ToString();
        switch (functionName)
        {
            case "GetPainLocations":
                var painLocations = from g in SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes.AsEnumerable()
                                    where g.Category.Trim() == "XPainLocation"
                                    orderby g.CodeName ascending
                                    select new GlobalCodes()
                                    {
                                        GlobalCodeId = g.GlobalCodeId,
                                        CodeName = g.CodeName
                                    };
                var painLevel = from g in SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes.AsEnumerable()
                                where g.Category.Trim() == "XPainlevel"
                                select new GlobalCodes()
                                {
                                    GlobalCodeId = g.GlobalCodeId,
                                    CodeName = g.CodeName
                                };
                var painIndicator = from g in SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes.AsEnumerable()
                                    where g.Category.Trim() == "XPainLevelImpClients"
                                    orderby g.CodeName ascending
                                    select new GlobalCodes()
                                    {
                                        GlobalCodeId = g.GlobalCodeId,
                                        CodeName = g.CodeName
                                    };
                Response.Clear();
                Response.Write(painLocations.ToJSON() + "^" + painLevel.ToJSON() + "^" + painIndicator.ToJSON());
                Response.End();
                break;
            case "GetPainLevel":
                break;
            case "XPainLevelImpClients":
                break;
            case "GetProviderDetail":
                GetProviderDetail();
                break;
            case "GetProviderName":
                GetProviderName();
                break;
            case "RefreshProvideDetail":
                RefreshProvideDetail();
                break;
            case "CurrentAllergy":
                string list = string.Empty;
                int _ClientId = SHS.BaseLayer.BaseCommonFunctions.ApplicationInfo.Client.ClientId;
                list = GetCurrentAllergylist(_ClientId);
                Response.Write(list);
                Response.End();
                break;

            case "UpdateProviderDetails":
                string ReferralProviderId = Request.Form["ExternalReferralProviderId"].ToString();
                GetProviderDetails(ReferralProviderId);
                break;

            case "CurrentAllergyAndMedications":
                DataSet NursingAssessmentCurrentAllergies = new DataSet();
                NursingAssessmentCurrentAllergies = dataSetGetCurrentAllergies();
                DataSet NursingAssessmentCurrentMedication = new DataSet();
                NursingAssessmentCurrentMedication = dataSetGetCurrentMedication();
                DataSet dsResult = new DataSet();
                dsResult.Tables.Add(NursingAssessmentCurrentAllergies.Tables["ClientAllergies"].Copy());
                dsResult.Tables.Add(NursingAssessmentCurrentMedication.Tables["ClientMedications"].Copy());
                dsResult.Tables.Add(NursingAssessmentCurrentMedication.Tables["CurrentMedicationHistory"].Copy());
                StringWriter sw1 = new StringWriter();
                dsResult.WriteXml(sw1);
                string resultPIE1 = sw1.ToString();
                Response.Write(resultPIE1);
                Response.End();
                break;
            case "GetBMIPercentile":
                string listPercentile = string.Empty;
                int ClientId = BaseCommonFunctions.ApplicationInfo.Client.ClientId;
                Decimal BMI;
                BMI = Convert.ToDecimal(Request.QueryString["BMIValue"].ToString());
                Decimal.TryParse(Request.QueryString["BMIValue"].ToString(), out BMI);
                SqlParameter[] _objectSqlParmeters = new SqlParameter[2];
                _objectSqlParmeters[0] = new SqlParameter("@ClientId", ClientId);
                _objectSqlParmeters[1] = new SqlParameter("@BMI", BMI);
                listPercentile = Convert.ToString(SqlHelper.ExecuteScalar(Connection.ConnectionString, "csp_SCCalculateClientAgePercentile", _objectSqlParmeters));
                if (listPercentile == "< 3rd %ile" || listPercentile == "> 97th %ile")
                    listPercentile = "Value" + listPercentile;
                Response.Clear();
                Response.Write(listPercentile);
                Response.End();
                break;
            case "GetRecodeData":
                string Count = string.Empty;
                string ProcedureCodeId = string.Empty;
                DataTable Services = BaseCommonFunctions.GetScreenInfoDataSet().Tables["Services"];
                ProcedureCodeId = Services.Rows[0]["ProcedureCodeId"].ToString();
                DataSet Recodes = new DataSet();
               
                try
                {              
                    _objectSqlParmeters = new SqlParameter[1];
                    _objectSqlParmeters[0] = new SqlParameter("@ProcedureCodeId", Convert.ToInt32(ProcedureCodeId));
                    SqlHelper.FillDataset(Connection.ConnectionString, CommandType.StoredProcedure, "csp_RecodePresent", Recodes, new string[] { "Recodes" }, _objectSqlParmeters);

                }
                catch (Exception ex)
                {

                }

                if (Recodes.Tables["Recodes"].Rows.Count > 0)
                {
                    Count = "1";
                }
                else
                {
                    Count = "0";
                }
                Response.Clear();
                Response.Write(Count);
                Response.End();
                break;
            case "PregnentRule":
                string Y_N_A = string.Empty;
                string dob = string.Empty;
                string gender = string.Empty;
                string datetime = DateTime.Now.ToString("yyyy");
                int age = 0;
                try
                {
                    DataSet PregentRule = getPregentRule();
                    gender = PregentRule.Tables["PregnentRuleData"].Rows[0]["Sex"].ToString();
                    dob = Convert.ToDateTime(PregentRule.Tables["PregnentRuleData"].Rows[0]["DOB"].ToString()).ToString("yyyy");
                    age = Convert.ToInt32(datetime) - Convert.ToInt32(dob);
                    if (gender == "F")
                    {
                        if (age > 55 || age < 9)
                        {
                            Y_N_A = "A";
                        }

                    }
                    if (gender == "M")
                    {
                        Y_N_A = "A";
                    }

                    if (gender == "" || gender == null)
                    {
                        Y_N_A = "A";
                    }
                }
                catch (Exception ex1)
                {

                }
               
                 Response.Clear();
                 Response.Write(Y_N_A);
                 Response.End();
                break;
            default:
                break;
        }
    }

    private void RefreshProvideDetail()
    {
        int ProviderId = 0;
        if (Request.QueryString["ExternalReferralProviderId"] != "undefined" && Request.QueryString["ExternalReferralProviderId"] != string.Empty && Request.QueryString["ExternalReferralProviderId"] != null)
        {
            ProviderId = Convert.ToInt32(Request.QueryString["ExternalReferralProviderId"]);
        }
        DataSet datasetProviders = new DataSet();
        datasetProviders = getPrimaryCarePhysician();
        DataSet DatasetParentScreen = new DataSet();
        DatasetParentScreen = SHS.BaseLayer.BaseCommonFunctions.GetScreenInfoDataSet();
        DataTable DTExternalReferralProviders = DatasetParentScreen.Tables["ExternalReferralProviders"];
        DataRow[] dr = datasetProviders.Tables["ExternalReferralProviders"].Select("ExternalReferralProviderId='" + ProviderId + "' and ISNULL(RecordDeleted,'N')<>'Y'");
        if (dr.Length > 0)
        {
            string ExternalProviderId = dr[0]["ExternalProviderId"].ToString();
            var index = new System.Data.DataView(DTExternalReferralProviders).ToTable(false, new[] { "TempExternalProviderId" })
                    .AsEnumerable()
                    .Select(row => row.Field<string>("TempExternalProviderId"))
                    .ToList()
                    .FindIndex(col => col == ExternalProviderId);

            for (int i = 0; i < dr.Length; i++)
            {

                DatasetParentScreen.Tables["ExternalReferralProviders"].Rows[index]["ExternalProviderId"] = dr[i]["ExternalProviderId"].ToString();
                DatasetParentScreen.Tables["ExternalReferralProviders"].Rows[index]["OrganizationName"] = dr[i]["OrganizationName"].ToString();
                DatasetParentScreen.Tables["ExternalReferralProviders"].Rows[index]["PhoneNumber"] = dr[i]["PhoneNumber"].ToString();
                DatasetParentScreen.Tables["ExternalReferralProviders"].Rows[index]["Type"] = dr[i]["Type"].ToString();
                DatasetParentScreen.Tables["ExternalReferralProviders"].Rows[index]["TypeText"] = dr[i]["TypeText"].ToString();
                DatasetParentScreen.Tables["ExternalReferralProviders"].Rows[index]["ExternalProviderIdText"] = dr[i]["ExternalProviderIdText"].ToString();
                DatasetParentScreen.Tables["ExternalReferralProviders"].Rows[index]["Email"] = dr[i]["Email"].ToString();


            }
            Response.Clear();
            Response.Write(true);
            Response.End();
        }

    }
    private void GetProviderName()
    {
        StringBuilder stringBuilderHTML = null;
        stringBuilderHTML = new StringBuilder();
        stringBuilderHTML.Append("<option  value= " + "" + ">");
        stringBuilderHTML.Append("" + "</option>");
        DataSet datasetProviders = getProviderNameDependOnType();
        DataView dataViewProvider = datasetProviders.Tables[0].DefaultView;
        var a = "&ltCreate Provider&gt";
        if (dataViewProvider != null)
        {
            int tempCount = datasetProviders.Tables["ExternalReferralProviders"].Rows.Count;
            for (int i = 0; i < tempCount; i++)
            {
                if (i == 0)
                {

                    stringBuilderHTML.Append("<option  value= " + "-1" + ">" + a + "</option>");
                    stringBuilderHTML.Append("<option value= " + datasetProviders.Tables["ExternalReferralProviders"].Rows[i]["ExternalReferralProviderId"].ToString() + ">");
                    stringBuilderHTML.Append(datasetProviders.Tables["ExternalReferralProviders"].Rows[i]["Name"].ToString() + "</option>");


                }
                else
                {
                    stringBuilderHTML.Append("<option value= " + datasetProviders.Tables["ExternalReferralProviders"].Rows[i]["ExternalReferralProviderId"].ToString() + ">");
                    stringBuilderHTML.Append(datasetProviders.Tables["ExternalReferralProviders"].Rows[i]["Name"].ToString() + "</option>");
                }
            }

            if (tempCount == 0)
                stringBuilderHTML.Append("<option  value= " + "-1" + ">" + a + "</option>");
        }
        else
        {
            stringBuilderHTML.Append("<option  value= " + "-1" + ">" + a + "</option>");
        }
        PlaceHolderControlProvider.Controls.Add(new LiteralControl(stringBuilderHTML.ToString()));
    }

    public DataSet dataSetGetCurrentAllergies()
    {
        SqlParameter[] _objectSqlParmeters = null;
        DataSet dataSetGetCurrentAllergies = null;
        try
        {
            dataSetGetCurrentAllergies = new DataSet();
            _objectSqlParmeters = new SqlParameter[1];
            _objectSqlParmeters[0] = new SqlParameter("@ClientId", SHS.BaseLayer.BaseCommonFunctions.ApplicationInfo.Client.ClientId);
            SqlHelper.FillDataset(Connection.ConnectionString, CommandType.StoredProcedure, "csp_SCGetPIECurrentAllergylist", dataSetGetCurrentAllergies, new string[] { "ClientAllergies" }, _objectSqlParmeters);
            return dataSetGetCurrentAllergies;
        }
        finally
        {
            if (dataSetGetCurrentAllergies != null) dataSetGetCurrentAllergies.Dispose();
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
            SqlHelper.FillDataset(Connection.ConnectionString, CommandType.StoredProcedure, "csp_SCGetPIECurrentMedicationlist", dataSetGetCurrentMedication, new string[] { "ClientMedications", "CurrentMedicationHistory" }, _objectSqlParmeters);
            return dataSetGetCurrentMedication;
        }
        finally
        {
            if (dataSetGetCurrentMedication != null) dataSetGetCurrentMedication.Dispose();
            _objectSqlParmeters = null;
        }
    }

    private void GetProviderDetails(string ExternalReferralProviderId)
    {
        DataSet datasetProviders = getPrimaryCarePhysician();
        HtmlTextArea htmlTextAreaControl = new HtmlTextArea();
        DataRow[] dataRowProvider = datasetProviders.Tables[0].Select("ExternalReferralProviderId=" + ExternalReferralProviderId);
        string htmlTextarea = string.Empty;
        htmlTextAreaControl.ID = "htmlTextAreaControl";
        ExternalReferralProvider exr = new ExternalReferralProvider();
        exr.Email = "";
        exr.OrganizationName = "";
        exr.PhoneNumber = "";

        if (!Convert.ToString(dataRowProvider[0]["PhoneNumber"]).Trim().IsNullOrEmpty())
        {
            exr.PhoneNumber = dataRowProvider[0]["PhoneNumber"].ToString();
        }
        if (!Convert.ToString(dataRowProvider[0]["Email"]).Trim().IsNullOrEmpty())
        {
            exr.Email = dataRowProvider[0]["Email"].ToString();
        }
        if (!Convert.ToString(dataRowProvider[0]["OrganizationName"]).Trim().IsNullOrEmpty())
        {
            exr.OrganizationName = dataRowProvider[0]["OrganizationName"].ToString();
        }
        Response.Clear();
        Response.Write(new JavaScriptSerializer().Serialize(exr));
        Response.End();
    }

    public void GetProviderDetail()
    {
        try
        {
            int ProviderId = 0;
            if (Request.QueryString["ExternalProviderId"] != "undefined" && Request.QueryString["ExternalProviderId"] != string.Empty && Request.QueryString["ExternalProviderId"] != null)
            {
                ProviderId = Convert.ToInt32(Request.QueryString["ExternalProviderId"]);
            }

            DataSet datasetProviders = new DataSet();
            SqlParameter[] _objectSqlParmeters = new SqlParameter[1];
            _objectSqlParmeters[0] = new SqlParameter("@ExternalReferralProviderId", ProviderId);
            SqlHelper.FillDataset(SHS.DataServices.Connection.ConnectionString, CommandType.StoredProcedure, "csp_GetExternalReferralProviders", datasetProviders, new string[] { "ExternalReferralProviders" }, _objectSqlParmeters);
            HtmlTextArea htmlTextAreaControl = new HtmlTextArea();
            DataRow[] dataRowProvider = datasetProviders.Tables[0].Select("ExternalReferralProviderId=" + ProviderId);
            string htmlTextarea = string.Empty;
            htmlTextAreaControl.ID = "htmlTextAreaControl";
            ExternalReferralProvider exr = new ExternalReferralProvider();
            string Email = "";
            string PhoneNumber = "";
            string OrganizationName = "";

            if (!Convert.ToString(dataRowProvider[0]["PhoneNumber"]).Trim().IsNullOrEmpty())
            {
                PhoneNumber = dataRowProvider[0]["PhoneNumber"].ToString();
            }
            if (!Convert.ToString(dataRowProvider[0]["Email"]).Trim().IsNullOrEmpty())
            {
                Email = dataRowProvider[0]["Email"].ToString();
            }
            if (!Convert.ToString(dataRowProvider[0]["OrganizationName"]).Trim().IsNullOrEmpty())
            {
                OrganizationName = dataRowProvider[0]["OrganizationName"].ToString();
            }
            if (!Convert.ToString(dataRowProvider[0]["OrganizationName"]).Trim().IsNullOrEmpty())
            {
                OrganizationName = dataRowProvider[0]["OrganizationName"].ToString();
            }

            Response.Clear();
            Response.Write(OrganizationName + "^" + PhoneNumber + "^" + Email);
            Response.End();
        }
        catch (Exception ex)
        { }
    }

    public DataSet getPrimaryCarePhysician()
    {
        DataSet dataSetClientContacts = new DataSet();
        SqlParameter[] _objectSqlParmeters = new SqlParameter[1];
        _objectSqlParmeters[0] = new SqlParameter("@ExternalReferralProviderId", Convert.ToInt32(0));
        SqlHelper.FillDataset(SHS.DataServices.Connection.ConnectionString, CommandType.StoredProcedure, "csp_GetExternalReferralProviders", dataSetClientContacts, new string[] { "ExternalReferralProviders" }, _objectSqlParmeters);
        return dataSetClientContacts;
    }

    public string GetCurrentAllergylist(int ClientId)
    {

        SqlParameter[] _objectSqlParmeters = null;
        _objectSqlParmeters = new SqlParameter[1];
        _objectSqlParmeters[0] = new SqlParameter("@ClientID", ClientId);
        var strngCurrentMedicationlist = SqlHelper.ExecuteScalar(Connection.ConnectionString, CommandType.StoredProcedure, "csp_SCGetCurrentAllergylist", _objectSqlParmeters);
        return (string)strngCurrentMedicationlist;
    }

    public DataSet getProviderNameDependOnType()
    {
        if (Request.QueryString["Type"] != "undefined" && Request.QueryString["Type"] != string.Empty && Request.QueryString["Type"] != null)
        {
            ProviderType = Convert.ToInt32(Request.QueryString["Type"]);
        }
        DataSet getProviderNameDependOnType = new DataSet();
        SqlParameter[] _objectSqlParmeters = new SqlParameter[1];
        _objectSqlParmeters[0] = new SqlParameter("@Type", ProviderType);
        SqlHelper.FillDataset(SHS.DataServices.Connection.ConnectionString, CommandType.StoredProcedure, "csp_GetExternalProvidersDependsOnType", getProviderNameDependOnType, new string[] { "ExternalReferralProviders" }, _objectSqlParmeters);
        return getProviderNameDependOnType;
    }
    public DataSet getPregentRule()
    {
        DataSet getPregentRule = new DataSet();
        SqlParameter[] _objectSqlParmeters = null;
        
        try
        {

            _objectSqlParmeters = new SqlParameter[1];
            _objectSqlParmeters[0] = new SqlParameter("@ClientId", SHS.BaseLayer.BaseCommonFunctions.ApplicationInfo.Client.ClientId);
            SqlHelper.FillDataset(Connection.ConnectionString, CommandType.StoredProcedure, "csp_GetPregentrule", getPregentRule, new string[] { "PregnentRuleData" }, _objectSqlParmeters);  
           
        }
        
        catch (Exception ex2)
        {

        }
        return getPregentRule;
    }


    [Serializable]
    public class ExternalReferralProvider
    {
        public string PhoneNumber { get; set; }
        public string Email { get; set; }
        public string OrganizationName { get; set; }
    }
}
class GlobalCodes
{
    public int GlobalCodeId { get; set; }
    public string CodeName { get; set; }
}

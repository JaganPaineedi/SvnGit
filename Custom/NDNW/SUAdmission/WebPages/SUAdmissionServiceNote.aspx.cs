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

public partial class Custom_SUAdmission_WebPages_SUAdmissionServiceNote : System.Web.UI.Page
{

    string functionName = string.Empty;
    int problemCount = 0;
    int Globalcodeid = 0;
    protected void Page_Load(object sender, EventArgs e)
    {
        problemCount = 0;
        functionName = Request.Form["action"].ToString();
        switch (functionName.Trim())
        {
            case "GetPreviousDiagnosis":
                string PreviosDiagnosisString = "";
                PreviosDiagnosisString = getPreviousDiagnosis();
                Response.Clear();
                Response.Write(PreviosDiagnosisString);
                Response.End();
                break;


            case "GetTobaccoUse":

                Globalcodeid = Convert.ToInt32(HttpContext.Current.Request.Form["Globalcodeid"].ToString());
                string TobaccoUseString = "";
                TobaccoUseString = getTobaccoUse(Globalcodeid);
                Response.Clear();
                Response.Write(TobaccoUseString);
                Response.End();
                break;


            case "GetAdmittedPopulation":

                Globalcodeid = Convert.ToInt32(HttpContext.Current.Request.Form["Globalcodeid"].ToString());
                string AdmittedPopulationUseString = "";
                AdmittedPopulationUseString = getAdmittedPopulation(Globalcodeid);
                Response.Clear();
                Response.Write(AdmittedPopulationUseString);
                Response.End();
                break;
            
            default:
                break;
        } 
    }

    public string getTobaccoUse(int Globalcodeid)
    {
        Globalcodeid = Convert.ToInt32(HttpContext.Current.Request.Form["Globalcodeid"].ToString());
        DataView dv = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
        dv.RowFilter = "GlobalCodeId=" + Globalcodeid;               
        return dv[0]["Code"].ToString();
    }

    public string getAdmittedPopulation(int Globalcodeid)
    {
        Globalcodeid = Convert.ToInt32(HttpContext.Current.Request.Form["Globalcodeid"].ToString());
        DataView dv = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
        dv.RowFilter = "GlobalCodeId=" + Globalcodeid;
        return dv[0]["Code"].ToString();
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
}

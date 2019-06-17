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


public partial class RegistrationDocumentAjaxScript : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string functionName = string.Empty;
        functionName = Request.QueryString["FunctionName"].ToString();
        switch (functionName)
        {
            case "CalculateIncome":
                string Income = Request.Form["Income"].ToString();
                string Type = Request.Form["Type"].ToString();
                DataSet dsIncome = new DataSet();
                string ResultIncome = "";
                if(Income.IndexOf('$') >= 0)
                {
                    Income = Income.Remove(Income.IndexOf('$'), 1);
                }
                dsIncome = CalculateIncome(Convert.ToDecimal(Income), Type);
                if (dsIncome != null && dsIncome.Tables["Result"].Rows.Count > 0)
                {
                    Income = dsIncome.Tables["Result"].Rows[0]["Income"].ToString();
                }
                Response.Clear();
                Response.Write(Income);
                Response.End();
                break;
            case "GetReferralSubtypeByGlobalCode":
                GetReferralSubtypeByGlobalCodeClientInfo();
                break;
            case "EpisodeInformation":
                string EpisodeInformation = string.Empty;
                DataSet datasetEpisodeInformation = new DataSet();
                datasetEpisodeInformation = GetEpisodeInformation(SHS.BaseLayer.BaseCommonFunctions.ApplicationInfo.Client.ClientId);
                if (datasetEpisodeInformation != null)
                {
                    if (datasetEpisodeInformation.Tables.Count > 0 && datasetEpisodeInformation.Tables["EpisodeInformation"].Rows.Count > 0)
                    {
                        if (datasetEpisodeInformation.Tables.Contains("EpisodeInformation") == true)
                        {
                            EpisodeInformation = Convert.ToString(datasetEpisodeInformation.Tables["EpisodeInformation"].Rows[0]["EpisodeInformation"]);
                        }
                    }
                }

                Response.Clear();
                Response.Write(EpisodeInformation);
                Response.End();
                break;
            case "UpdateProviderDetails":
                string ReferralProviderId = Request.Form["ExternalReferralProviderId"].ToString();
                GetProviderDetails(ReferralProviderId);
                break;
        }
    }

    public static DataSet CalculateIncome(decimal MonthlyIncome, string Type)
    {
        SqlParameter[] param = new SqlParameter[2];
        param[0] = new SqlParameter("@Income", SqlDbType.Decimal);
        param[0].Value = Convert.ToDecimal(MonthlyIncome);
        param[1] = new SqlParameter("@Type", Type);
        DataSet Result = new DataSet();
        SqlHelper.FillDataset(Connection.ConnectionString, CommandType.StoredProcedure, "csp_SCGetCalculateIncome", Result, new string[] { "Result" }, param);
        return Result;
    }
    public DataSet GetEpisodeInformation(Int32 clientId)
    {
        DataSet dataSetEpisodeinfo = new DataSet();
        SqlParameter[] _objectSqlParmeters = new SqlParameter[1];
        _objectSqlParmeters[0] = new SqlParameter("@ClientId", clientId);
        SqlHelper.FillDataset(SHS.DataServices.Connection.ConnectionString, CommandType.StoredProcedure, "csp_EpisodeInformation", dataSetEpisodeinfo, new string[] { "EpisodeInformation" }, _objectSqlParmeters);
        return dataSetEpisodeinfo;
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
        if (!Convert.ToString(dataRowProvider[0]["Email"]).Trim().IsNullOrEmpty())
        {
            exr.OrganizationName = dataRowProvider[0]["OrganizationName"].ToString();
        }
        Response.Clear();
        Response.Write(new JavaScriptSerializer().Serialize(exr));
        Response.End();
    }

    public DataSet getPrimaryCarePhysician()
    {
        DataSet dataSetClientContacts = new DataSet();
        SqlParameter[] _objectSqlParmeters = new SqlParameter[1];
        _objectSqlParmeters[0] = new SqlParameter("@ExternalReferralProviderId", Convert.ToInt32(0));
        SqlHelper.FillDataset(SHS.DataServices.Connection.ConnectionString, CommandType.StoredProcedure, "ssp_GetExternalReferralProviders", dataSetClientContacts, new string[] { "ExternalReferralProviders" }, _objectSqlParmeters);
        return dataSetClientContacts;
    }

    [Serializable]
    public class ClientServicesView
    {
        public string CodeName { get; set; }
        public string GlobalCodeId { get; set; }

    }
    [Serializable]
    public class ExternalReferralProvider
    {
        public string PhoneNumber { get; set; }
        public string Email { get; set; }
        public string OrganizationName { get; set; }
    }

}
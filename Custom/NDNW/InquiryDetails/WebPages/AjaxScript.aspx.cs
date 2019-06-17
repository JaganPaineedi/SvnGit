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


public partial class Custom_InquiryDetails_WebPages_AjaxScript : System.Web.UI.Page
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
                if (Income.IndexOf('$') >= 0)
                {
                    Income = Income.Remove(Income.IndexOf('$'), 1);
                }
                using (SHS.UserBusinessServices.DetailPages objectPlan = new SHS.UserBusinessServices.DetailPages())
                {
                    dsIncome = CalculateIncome(Convert.ToDecimal(Income), Type);
                    if (dsIncome != null && dsIncome.Tables["Result"].Rows.Count > 0)
                    {
                        Income = dsIncome.Tables["Result"].Rows[0]["Income"].ToString();
                    }
                }
                Response.Clear();
                Response.Write(Income);
                Response.End();
                break;
            case "GetReferralSubtypeByGlobalCode":
                GetReferralSubtypeByGlobalCodeClientInfo();
                break;
        }
    }

    /// <summary>
    /// Created by anil gautam 
    /// date : 22 dec 2010
    /// </summary>
    /// <param name="BedId"></param>
    /// <returns></returns>
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
}
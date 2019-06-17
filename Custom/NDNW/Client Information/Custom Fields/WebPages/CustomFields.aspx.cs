using System;
using System.Data;
using System.Linq;
using System.Text;
using SHS.BaseLayer;
using System.Collections.Generic;
using System.Xml.Serialization;

public partial class Custom_Client_Information_Custom_Fields_WebPages_CustomFields : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string functionName = string.Empty;
        functionName = Request.QueryString["FunctionName"].ToString();
        switch (functionName)
        {
            case "BindPayerName":
                int InsuranceType;
                if (Int32.TryParse(Request.QueryString["selectedInsuranceType"], out InsuranceType))
                {
                    BindPayerName(InsuranceType);
                }
                break;
        }
    }

    private void BindPayerName(int InsuranceType)
    {
        StringBuilder stringBuilderPayers = null;
        stringBuilderPayers = new StringBuilder();
        DataView dataViewPayers = null;

        dataViewPayers = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.Payers);
        dataViewPayers.RowFilter = "(RecordDeleted IS NULL OR RecordDeleted = 'N') AND Active='Y' AND PayerType='" + InsuranceType + "'";
        if (dataViewPayers != null)
        {
            if (dataViewPayers.ToDataTable().Rows.Count > 0)
            {
                List<DataViewPayers> ItemscollectionsPayers = dataViewPayers.ToDataTable().Select().Select(t => new DataViewPayers
                {
                    PayerName = Convert.ToString(t["PayerName"]),
                    PayerId = Convert.ToString(t["PayerId"])
                }).OrderBy(t => t.PayerName).ToList();
                Response.Clear();
                XmlSerializer s = new XmlSerializer(ItemscollectionsPayers.GetType());
                s.Serialize(Response.OutputStream, ItemscollectionsPayers);
                Response.ContentType = "text/xml";
                Response.End();
            }
        }
    }
}

[Serializable]
public class DataViewPayers
{
    public string PayerName { get; set; }
    public string PayerId { get; set; }
}
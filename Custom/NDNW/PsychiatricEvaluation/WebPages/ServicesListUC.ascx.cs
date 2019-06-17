using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using System.Data;
using SHS.BaseLayer;
using Microsoft.ApplicationBlocks.Data;
using System.Data.SqlClient;
using SHS.DataServices;

public partial class Custom_PsychiatricService_WebPages_ServicesListUC : SHS.BaseLayer.ActivityPages.DataActivityTab
{
   bool DateSort = false;
    DataSet dsServices = null;
    public string RelativePath1 = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
        RelativePath1 = Page.ResolveUrl("~/");
        if (DateSort == false)
        {
            BindControls();
        }

    }
    public Custom_PsychiatricService_WebPages_ServicesListUC()
    {
        if (lvServices != null)
        {
            dsServices = GetServicesList("DOS","asc");
            lvServices.DataSource = dsServices.Tables["CustomAssosiatedServices"];
            lvServices.DataBind();
        }
    }

    public Custom_PsychiatricService_WebPages_ServicesListUC(string sortColumn, string sort)
    {
        DateSort = true;
        dsServices = GetServicesList(sortColumn,sort);
        lvServices.DataSource = dsServices.Tables["CustomAssosiatedServices"];
        lvServices.DataBind();
         
    }
    public override void BindControls()
    {
        dsServices = GetServicesList("DOS", "asc");
        lvServices.DataSource = dsServices.Tables["CustomAssosiatedServices"];
        lvServices.DataBind();

    }
    public DataSet GetServicesList(string sortColumn,string sort)
    {
        DataSet dataSetAssosiatedServices = null;
        SqlParameter[] _objectSqlParmeters = null;
        try
        {
            dataSetAssosiatedServices = new DataSet();
            _objectSqlParmeters = new SqlParameter[3];
            _objectSqlParmeters[0] = new SqlParameter("@ClientId", BaseCommonFunctions.ApplicationInfo.Client.ClientId);
            _objectSqlParmeters[1] = new SqlParameter("@SortColumn", sortColumn);
            _objectSqlParmeters[2] = new SqlParameter("@Sort", sort);

            SqlHelper.FillDataset(Connection.ConnectionString, CommandType.StoredProcedure, "csp_getServicesFlagedForReview", dataSetAssosiatedServices, new string[] { "CustomAssosiatedServices" }, _objectSqlParmeters);
            return dataSetAssosiatedServices;
        }
        finally
        {
            if (dataSetAssosiatedServices != null) dataSetAssosiatedServices.Dispose();
            _objectSqlParmeters = null;
        }
    }
   
    protected void LayoutCreated(object sender, EventArgs e)
    { }
    protected void lvServices_ItemDataBound(object sender, ListViewItemEventArgs e)
    {
    }
    
}

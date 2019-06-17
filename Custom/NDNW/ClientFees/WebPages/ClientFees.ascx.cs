using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using SHS.BaseLayer.ActivityPages;

public partial class Custom_ClientFees_WebPages_ClientFees : DataActivityPage
{
    public override void BindControls()
    {

        if (SHS.BaseLayer.SharedTables.ApplicationSharedTables != null && SHS.BaseLayer.SharedTables.ApplicationSharedTables.Locations != null)
        {
            DataView dataViewLocations = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.Locations);
            dataViewLocations.RowFilter = "Active='Y' and ISNULL(RecordDeleted,'N')<>'Y'";
            dataViewLocations.Sort = "LocationCode";
            LocationDD.DataTextField = "LocationCode";
            LocationDD.DataValueField = "LocationId";
            LocationDD.DataSource = dataViewLocations;
            LocationDD.DataBind();
        }

        if (SHS.BaseLayer.SharedTables.ApplicationSharedTables != null && SHS.BaseLayer.SharedTables.ApplicationSharedTables.Programs != null)
        {
            DataView dataViewPrograms = SHS.BaseLayer.SharedTables.GetSharedTableProgram();
            dataViewPrograms.RowFilter = "Active='Y' and ISNULL(ProgramCode,'')<>'' and ISNULL(RecordDeleted,'N')<>'Y'";
            ProgramDD.DataTextField = "ProgramCode";
            ProgramDD.DataValueField = "ProgramId";
            ProgramDD.DataSource = dataViewPrograms;
            ProgramDD.DataBind();
        }



        //LocationDD.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.Locations;
        //LocationDD.FillDropDownDropGlobalCodes();

        //ProgramDD.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.Programs;
        //ProgramDD.FillDropDownDropGlobalCodes();

        HiddenField_CustomClientFees_ClientId.Value = SHS.BaseLayer.BaseCommonFunctions.ApplicationInfo.Client.ClientId.ToString();
        CustomGridClientFees.Bind(ParentPageObject.ScreenId);
    }

    public override string PageDataSetName
    {
        get { return "DataSetCustomClientFees"; }
    }


    public override string[] TablesToBeInitialized
    {
        get { return new string[] { "Clients" }; }
    }


    public override string GetStoreProcedureName
    {
        get
        {
            return "csp_SCGetClientFees";
        }
    }


    public override string[] TablesNameForGetData
    {
        get
        {
            return new string[] { "Clients", "CustomClientFees" };
        }
    }


    private System.Data.SqlClient.SqlParameter[] _sqlParameterForGetData = null;
    public override System.Data.SqlClient.SqlParameter[] SqlParameterForGetData
    {
        get
        {
            _sqlParameterForGetData = null;
            DataSet datasetObject = new DataSet();
            string _ClientID = string.Empty;
            datasetObject = SHS.BaseLayer.BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet;


            if (!string.IsNullOrEmpty(GetRequestParameterValue("ClientId")))
            {
                _ClientID = base.GetRequestParameterValue("ClientId");
                if (_sqlParameterForGetData == null)
                {
                    _sqlParameterForGetData = new System.Data.SqlClient.SqlParameter[1];
                    _sqlParameterForGetData[0] = new System.Data.SqlClient.SqlParameter("@ClientID", _ClientID);
                }
            }
            else
            {
                if (datasetObject != null)
                {
                    if (datasetObject.Tables.Contains("Clients"))
                    {
                        if (datasetObject.Tables["Clients"].Rows.Count > 0)
                        {
                            _ClientID = datasetObject.Tables["Clients"].Rows[0]["ClientId"].ToString();
                            if (_sqlParameterForGetData == null)
                            {
                                _sqlParameterForGetData = new System.Data.SqlClient.SqlParameter[1];
                                _sqlParameterForGetData[0] = new System.Data.SqlClient.SqlParameter("@ClientID", _ClientID);
                            }
                        }
                    }
                    else
                    {
                        if (_sqlParameterForGetData == null)
                        {
                            _sqlParameterForGetData = new System.Data.SqlClient.SqlParameter[1];
                            _sqlParameterForGetData[0] = new System.Data.SqlClient.SqlParameter("@ClientID", SHS.BaseLayer.BaseCommonFunctions.ApplicationInfo.Client.ClientId);
                        }
                    }
                }
                else
                {
                    if (_sqlParameterForGetData == null)
                    {
                        _sqlParameterForGetData = new System.Data.SqlClient.SqlParameter[1];
                        _sqlParameterForGetData[0] = new System.Data.SqlClient.SqlParameter("@ClientID", SHS.BaseLayer.BaseCommonFunctions.ApplicationInfo.Client.ClientId);
                    }
                }
           }
            return _sqlParameterForGetData;
        }
    }

    public override void ChangeDataSetBeforeUpdate(ref DataSet dataSetObject)
    {
        DataTable table = dataSetObject.Tables["Clients"];
        dataSetObject.Tables.Remove(table);
        base.ChangeDataSetBeforeUpdate(ref dataSetObject);
    }
}

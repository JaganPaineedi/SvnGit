using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using Microsoft.ApplicationBlocks.Data;
using SHS.DataServices;


public partial class Custom_Discharge_WebPages_Demographics : SHS.BaseLayer.ActivityPages.DataActivityTab
{
    public override string[] TablesUsedInTab
    {
        get
        {
            return new string[] { "CustomDocumentDischarges" };
        }
    }
    public override void BindControls()
    {
        DropDownList_CustomDocumentDischarges_EducationLevel.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentDischarges_EducationLevel.FillDropDownDropGlobalCodes();

        DropDownList_CustomDocumentDischarges_MaritalStatus.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentDischarges_MaritalStatus.FillDropDownDropGlobalCodes();

        DropDownList_CustomDocumentDischarges_EducationStatus.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentDischarges_EducationStatus.FillDropDownDropGlobalCodes();

        DropDownList_CustomDocumentDischarges_EmploymentStatus.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentDischarges_EmploymentStatus.FillDropDownDropGlobalCodes();

        DropDownList_CustomDocumentDischarges_ForensicCourtOrdered.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentDischarges_ForensicCourtOrdered.FillDropDownDropGlobalCodes();

        DropDownList_CustomDocumentDischarges_CurrentlyServingMilitary.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentDischarges_CurrentlyServingMilitary.FillDropDownDropGlobalCodes();

        DropDownList_CustomDocumentDischarges_Legal.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentDischarges_Legal.FillDropDownDropGlobalCodes();

        DropDownList_CustomDocumentDischarges_JusticeSystem.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentDischarges_JusticeSystem.FillDropDownDropGlobalCodes();

        DropDownList_CustomDocumentDischarges_LivingArrangement.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentDischarges_LivingArrangement.FillDropDownDropGlobalCodes();

        DropDownList_CustomDocumentDischarges_AdvanceDirective.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentDischarges_AdvanceDirective.FillDropDownDropGlobalCodes();

        DropDownList_CustomDocumentDischarges_TobaccoUse.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentDischarges_TobaccoUse.FillDropDownDropGlobalCodes();
       

        int stateFips = -1;
        if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.SystemConfigurations != null)
        {
            if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.SystemConfigurations.Rows[0]["StateFips"] != DBNull.Value)
            {
                stateFips = Convert.ToInt32(SHS.BaseLayer.SharedTables.ApplicationSharedTables.SystemConfigurations.Rows[0]["StateFips"]);
            }
        }
        DataView dataViewCountyOfResidence = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.Counties);

        dataViewCountyOfResidence.Sort = "CountyName";
        dataViewCountyOfResidence.RowFilter = "StateFips=" + stateFips;
        if (dataViewCountyOfResidence.Count > 0)
        {

            DropDownList_CustomDocumentDischarges_CountyResidence.DataTextField = "CountyName";
            DropDownList_CustomDocumentDischarges_CountyResidence.DataValueField = "CountyFIPS";
            DropDownList_CustomDocumentDischarges_CountyResidence.DataSource = dataViewCountyOfResidence;
            DropDownList_CustomDocumentDischarges_CountyResidence.DataBind();

            DropDownList_CustomDocumentDischarges_CountyFinancialResponsibility.DataTextField = "CountyName";
            DropDownList_CustomDocumentDischarges_CountyFinancialResponsibility.DataValueField = "CountyFIPS";
            DropDownList_CustomDocumentDischarges_CountyFinancialResponsibility.DataSource = dataViewCountyOfResidence;
            DropDownList_CustomDocumentDischarges_CountyFinancialResponsibility.DataBind();
        }

        BindClientAddress();
    }

    public void BindClientAddress()
        {
            int clientId = -1;
            int.TryParse(Convert.ToString(SHS.BaseLayer.BaseCommonFunctions.ApplicationInfo.Client.ClientId), out clientId);
            DataSet dataSetClientAddress = new DataSet();
            SqlParameter[] _objectSqlParmeters = null;
            try
            {
                if (clientId > 0)
                {
                    _objectSqlParmeters = new SqlParameter[1];
                    _objectSqlParmeters[0] = new SqlParameter("@ClientID", clientId);
                    SqlHelper.FillDataset(Connection.ConnectionString, CommandType.StoredProcedure, "csp_GetClientDemographicsClientAddress", dataSetClientAddress, new string[] { "ClientAddress" }, _objectSqlParmeters);

                    if (dataSetClientAddress.Tables["ClientAddress"].Rows.Count > 0)
                    {
                        string Address = string.Empty;
                        string City = string.Empty;
                        string State = string.Empty;
                        string Zip = string.Empty;

                        if (!string.IsNullOrEmpty(dataSetClientAddress.Tables["ClientAddress"].Rows[0]["Zip"].ToString()))
                        {
                            Zip = dataSetClientAddress.Tables["ClientAddress"].Rows[0]["Zip"].ToString();
                            Span_Zip.InnerHtml = Zip;
                        }

                        if (!string.IsNullOrEmpty(dataSetClientAddress.Tables["ClientAddress"].Rows[0]["State"].ToString()))
                        {
                            State = dataSetClientAddress.Tables["ClientAddress"].Rows[0]["State"].ToString();
                            if (Zip != "")
                                Span_State.InnerHtml = State + "&nbsp;";
                            else
                                Span_State.InnerHtml = State;
                        }
                        
                        if (!string.IsNullOrEmpty(dataSetClientAddress.Tables["ClientAddress"].Rows[0]["City"].ToString()))
                        {
                            City = dataSetClientAddress.Tables["ClientAddress"].Rows[0]["City"].ToString();
                            if (State != "" || Zip != "")
                                Span_City.InnerHtml = City + ", ";
                            else
                                Span_City.InnerHtml = City;

                        }

                        if (!string.IsNullOrEmpty(dataSetClientAddress.Tables["ClientAddress"].Rows[0]["Address"].ToString()))
                        {
                            Address = dataSetClientAddress.Tables["ClientAddress"].Rows[0]["Address"].ToString();
                            if (City != "" || State != "" || Zip != "")
                                Span_Address.InnerHtml = Address + "<br/>";
                            else
                                Span_Address.InnerHtml = Address;
                        }
                    }
                }
            }
            finally
            {
                if (dataSetClientAddress != null) dataSetClientAddress.Dispose();
                _objectSqlParmeters = null;
            }
        }
}




        

        


        
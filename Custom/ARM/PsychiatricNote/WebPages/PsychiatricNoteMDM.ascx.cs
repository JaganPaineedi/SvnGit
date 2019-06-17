using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using SHS.BaseLayer;
using Microsoft.ApplicationBlocks.Data;
using System.Data.SqlClient;
using SHS.DataServices;
using System.Text;

public partial class Custom_PsychiatricNote_WebPages_PsychiatricNoteMDM : SHS.BaseLayer.ActivityPages.DataActivityTab
{
    string ClientOrderId = string.Empty;
    public override void BindControls()
    {
        getLabOrderList();
        #region Bind DropDownList For Transition/Discharge Reason
        using (DataView DataViewGlobalCodetransitionProblemStatus = BaseCommonFunctions.FillDropDown("XPROBLEMSTATUS", true, "", "CodeName", true))
        {
            if (DataViewGlobalCodetransitionProblemStatus != null)
            {
                DataViewGlobalCodetransitionProblemStatus.RowFilter = "GlobalCodeId is not null and Active='Y' and ISNULL(RecordDeleted,'N')<>'Y'";
                DropDownListCommon_CustomDocumentPsychiatricNoteMDMs_ProblemStatus.DataTableGlobalCodes = DataViewGlobalCodetransitionProblemStatus.ToDataTable();
                DropDownListCommon_CustomDocumentPsychiatricNoteMDMs_ProblemStatus.FillDropDownDropGlobalCodes();
                DropDownListCommon_CustomDocumentPsychiatricNoteMDMs_ProblemStatus.Items.Insert(0, new ListItem("", "0")); ;
            }
        }

        DataSet DatasetAgency = null;
        DatasetAgency = new DataSet();
        SqlHelper.FillDataset(Connection.ConnectionString, CommandType.StoredProcedure, "CSP_SCGetAgencyNameDetails", DatasetAgency, new string[] { "Agency" });
        if (DatasetAgency.Tables["Agency"].Rows.Count > 0)
            HiddenField_CustomDocumentConsentTreatments_AgencyName.Value = DatasetAgency.Tables["Agency"].Rows[0]["AgencyName"].ToString();
        HiddenField_CustomDocumentConsentTreatments_AgencyaAbbreviation.Value = DatasetAgency.Tables["Agency"].Rows[0]["AbbreviatedAgencyName"].ToString();

        #endregion
    }


    private void getLabOrderList()
    {
        SqlParameter[] _objectSqlParmeters;
        DataSet dataSetLabOrders = new DataSet();
        try
        {
            _objectSqlParmeters = new SqlParameter[1];
            _objectSqlParmeters[0] = new SqlParameter("@ClientID", BaseCommonFunctions.ApplicationInfo.Client.ClientId);
            SqlHelper.FillDataset(Connection.ConnectionString, CommandType.StoredProcedure, "csp_getLabOrdersPsycNote", dataSetLabOrders, new string[] { "LabOrders" }, _objectSqlParmeters);
            if (dataSetLabOrders != null && dataSetLabOrders.Tables.Count > 0)
            {
                if (dataSetLabOrders.Tables.Contains("LabOrders") && BaseCommonFunctions.CheckRowExists(dataSetLabOrders, "LabOrders", 0))
                {
                    DataView dataviewLabOrders = new DataView(dataSetLabOrders.Tables["LabOrders"]);
                    ClientOrderId = dataSetLabOrders.Tables["LabOrders"].Columns["ClientOrderId"].ToString();
                    GridViewLaborders.DataSource = dataviewLabOrders;
                    GridViewLaborders.DataBind();

                }
            }
        }
        finally
        {
            if (dataSetLabOrders != null) dataSetLabOrders.Dispose();
            _objectSqlParmeters = null;
        }


    }
   
}

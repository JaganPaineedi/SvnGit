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

public partial class Custom_PsychiatricService_WebPages_PsychiatricServiceMDM : SHS.BaseLayer.ActivityPages.DataActivityTab
{
    public override string[] TablesUsedInTab
    {
        get
        {
            return new string[] { "CustomDocumentPsychiatricServiceNoteMDMs" };
        }
    }
    public override void BindControls()
    {
        getLabDropDownList();
        #region Bind DropDownList For Transition/Discharge Reason
        using (DataView DataViewGlobalCodetransitionProblemStatus = BaseCommonFunctions.FillDropDown("XPROBLEMSTATUS", true, "", "CodeName", true))
        {
            if (DataViewGlobalCodetransitionProblemStatus != null)
            {
                DataViewGlobalCodetransitionProblemStatus.RowFilter = "GlobalCodeId is not null and Active='Y' and ISNULL(RecordDeleted,'N')<>'Y'";
                DropDownListCommon_CustomDocumentPsychiatricServiceNoteMDMs_ProblemStatus.DataTableGlobalCodes = DataViewGlobalCodetransitionProblemStatus.ToDataTable();
                DropDownListCommon_CustomDocumentPsychiatricServiceNoteMDMs_ProblemStatus.FillDropDownDropGlobalCodes();
                DropDownListCommon_CustomDocumentPsychiatricServiceNoteMDMs_ProblemStatus.Items.Insert(0, new ListItem("", "0")); ;
            }
        }
        #endregion
    }
    private void getLabDropDownList()
    {
        SqlParameter[] _objectSqlParmeters;
        DataSet dataSetLabOrders = new DataSet();
        try
        {
            _objectSqlParmeters = new SqlParameter[1];
            _objectSqlParmeters[0] = new SqlParameter("@ClientID", BaseCommonFunctions.ApplicationInfo.Client.ClientId);
            SqlHelper.FillDataset(Connection.ConnectionString, CommandType.StoredProcedure, "csp_getLabOrders", dataSetLabOrders, new string[] { "LabOrders" }, _objectSqlParmeters);
            if (dataSetLabOrders != null && dataSetLabOrders.Tables.Count > 0)
            {
                if (dataSetLabOrders.Tables.Contains("LabOrders") && BaseCommonFunctions.CheckRowExists(dataSetLabOrders, "LabOrders", 0))
                {
                    DataView dataviewLabOrders = new DataView(dataSetLabOrders.Tables["LabOrders"]);
                    DropDownList_CustomDocumentPsychiatricServiceNoteMDMs_LabsSelected.DataSource = dataviewLabOrders;
                    DropDownList_CustomDocumentPsychiatricServiceNoteMDMs_LabsSelected.DataTextField = "OrderName";
                    DropDownList_CustomDocumentPsychiatricServiceNoteMDMs_LabsSelected.DataValueField = "ClientOrderId";
                    DropDownList_CustomDocumentPsychiatricServiceNoteMDMs_LabsSelected.DataBind();
                    DropDownList_CustomDocumentPsychiatricServiceNoteMDMs_LabsSelected.Items.Insert(0, new ListItem("", ""));
                    DropDownList_CustomDocumentPsychiatricServiceNoteMDMs_LabsSelected.SelectedIndex = -1;
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

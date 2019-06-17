using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Microsoft.ApplicationBlocks.Data;
using SHS.BaseLayer;
using SHS.DataServices;

namespace SHS.SmartCare
{
    public partial class Custom_PsychiatricEvaluation_WebPages_MedicalDecisionMaking : SHS.BaseLayer.ActivityPages.DataActivityTab
    {
        public override void BindControls()
        {
            getLabDropDownList();
            using (DataView DataViewGlobalCodetransitionProblemStatus = BaseCommonFunctions.FillDropDown("XPSYCHEVALSTATUS", true, "", "CodeName", true))
            {
                if (DataViewGlobalCodetransitionProblemStatus != null)
                {
                    DataViewGlobalCodetransitionProblemStatus.RowFilter = "GlobalCodeId is not null and Active='Y' and ISNULL(RecordDeleted,'N')<>'Y'";
                    DropDownListCommon_CustomDocumentPsychiatricEvaluations_ProblemStatus.DataTableGlobalCodes = DataViewGlobalCodetransitionProblemStatus.ToDataTable();
                    DropDownListCommon_CustomDocumentPsychiatricEvaluations_ProblemStatus.FillDropDownDropGlobalCodes();
                    DropDownListCommon_CustomDocumentPsychiatricEvaluations_ProblemStatus.Items.Insert(0, new ListItem("", "0")); ;
                }
            }
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
                if (dataSetLabOrders != null)
                {
                    if (dataSetLabOrders.Tables.Contains("LabOrders"))
                    {
                        DataView dataviewLabOrders = new DataView(dataSetLabOrders.Tables["LabOrders"]);
                        DropDownList_CustomDocumentPsychiatricEvaluations_LabsSelected.DataSource = dataviewLabOrders;
                        DropDownList_CustomDocumentPsychiatricEvaluations_LabsSelected.DataTextField = "OrderName";
                        DropDownList_CustomDocumentPsychiatricEvaluations_LabsSelected.DataValueField = "ClientOrderId";
                        DropDownList_CustomDocumentPsychiatricEvaluations_LabsSelected.DataBind();
                        DropDownList_CustomDocumentPsychiatricEvaluations_LabsSelected.Items.Insert(0, new ListItem("", ""));
                        DropDownList_CustomDocumentPsychiatricEvaluations_LabsSelected.SelectedIndex = -1;
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
}
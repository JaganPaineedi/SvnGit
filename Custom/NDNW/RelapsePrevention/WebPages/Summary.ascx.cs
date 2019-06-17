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
using SHS.BaseLayer;
using System.Web.Script.Serialization;
using System.IO;
using System.Xml.Serialization;
using SHS.BaseLayer.BasePages;
using System.Collections;
using System.Data.SqlClient;
using Microsoft.ApplicationBlocks.Data;
using SHS.DataServices;


public partial class Custom_RelapsePrevention_WebPages_Summary : SHS.BaseLayer.ActivityPages.DataActivityTab
{
    public override void BindControls()
    {
        SqlParameter[] _objectSqlParmeters = null;
        DataSet dataSetGetCurrentSummary = null;
        try
        {
            int DocumentversionId = 0;
            DataSet Datasetsummary = BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet;           
            string DocumentVersionId = Datasetsummary.Tables["Documents"].Rows[0]["CurrentDocumentVersionId"].ToString();
            if (DocumentVersionId != "")
            {
                if (Convert.ToInt32(DocumentVersionId) > 0)
                {
                    DocumentversionId = Convert.ToInt32(DocumentVersionId);
                }
            }

            dataSetGetCurrentSummary = new DataSet();
            _objectSqlParmeters = new SqlParameter[1];
            _objectSqlParmeters[0] = new SqlParameter("@DocumentVersionId", DocumentversionId);
            SqlHelper.FillDataset(Connection.ConnectionString, CommandType.StoredProcedure, "csp_SCGetRelapsePreventionPlanSummary", dataSetGetCurrentSummary, new string[] { "RelapsePreventionPlanSummary" }, _objectSqlParmeters);
            if (dataSetGetCurrentSummary != null && dataSetGetCurrentSummary.Tables.Count > 0)
            {
                GridViewSummaryGrid.DataSource = dataSetGetCurrentSummary;
                GridViewSummaryGrid.DataBind();
            }

        }
        finally
        {
            if (dataSetGetCurrentSummary != null) dataSetGetCurrentSummary.Dispose();
            _objectSqlParmeters = null;
        }      
    }
}

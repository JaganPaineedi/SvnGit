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
using System.Data.SqlClient;
using System.IO;

public partial class IncidentReport : SHS.BaseLayer.Widget
{

    SqlParameter[] _sqlParameter = null;
    string _controlHeading = string.Empty;
    string _refreshData = "N";

    public override void BindData(SqlParameter[] sqlparameter, string spname, int widgetId)
    {
        DataSet dataSet = null;
        string notesFilterString = string.Empty;
        string txPlanFilterString = string.Empty;
        string perRevFilterString = string.Empty;
        int notesDocumentNavigationId = -1;
        int txDocumentNavigationId = -1;
        int perRevDocumentNavigationId = -1;
        int otherDocumentNavigationId = -1;
        dataSet = new DataSet();
        try
        {
            this.LabelHeading.Text = _controlHeading;

            dataSet = GetAllData(sqlparameter, spname, SqlConnection, widgetId);

            if (dataSet != null)
            {
                if (dataSet.Tables.Count > 0)
                {
                    if (dataSet.Tables[0].Rows.Count > 0)
                    {

                        if (dataSet.Tables[0].Columns.Contains("IncidentReportsProgress") == true && dataSet.Tables[0].Rows[0]["IncidentReportsProgress"] != DBNull.Value && dataSet.Tables[0].Rows[0]["IncidentReportsProgress"].ToString() != string.Empty)
                        {
                            this.LinkButtonIncidentReportsProgress.InnerText = dataSet.Tables[0].Rows[0]["IncidentReportsProgress"].ToString();
                        }
                        else { this.LinkButtonIncidentReportsProgress.InnerText = "0"; }


                        if (dataSet.Tables[0].Columns.Contains("IncidentReportsAssignedReview") == true && dataSet.Tables[0].Rows[0]["IncidentReportsAssignedReview"] != DBNull.Value && dataSet.Tables[0].Rows[0]["IncidentReportsAssignedReview"].ToString() != string.Empty)
                        {
                            this.LinkButtonIncidentReportsAssignedReview.InnerText = dataSet.Tables[0].Rows[0]["IncidentReportsAssignedReview"].ToString();
                        }
                        else { this.LinkButtonIncidentReportsAssignedReview.InnerText = "0"; }


                        if (dataSet.Tables[0].Columns.Contains("RestrictiveProgress") == true && dataSet.Tables[0].Rows[0]["RestrictiveProgress"] != DBNull.Value && dataSet.Tables[0].Rows[0]["RestrictiveProgress"].ToString() != string.Empty)
                        {
                            this.LinkButtonRestrictiveProgress.InnerText = dataSet.Tables[0].Rows[0]["RestrictiveProgress"].ToString();
                        }
                        else { this.LinkButtonRestrictiveProgress.InnerText = "0"; }
                        if (dataSet.Tables[0].Columns.Contains("RestrictiveAssignedReview") == true && dataSet.Tables[0].Rows[0]["RestrictiveAssignedReview"] != DBNull.Value && dataSet.Tables[0].Rows[0]["RestrictiveAssignedReview"].ToString() != string.Empty)
                        {
                            this.LinkButtonRestrictiveAssignedReview.InnerText = dataSet.Tables[0].Rows[0]["RestrictiveAssignedReview"].ToString();
                        }
                        else { this.LinkButtonRestrictiveAssignedReview.InnerText = "0"; }

                        #region Progress
                        LinkButtonIncidentReportsProgress.Attributes.Add("onClick", "javascript:OpenCaseLoad('5762',10915,'StartDate=" + "" + "#EndDate=" + "" + "#ProgramId=-1#Forms=1#GeneralLocationOfIncident=-1#ClientNameFilter=" + "" + "#Status=21#Staff=" + sqlparameter[0].Value + "');");
                        LinkButtonIncidentReportsAssignedReview.Attributes.Add("onClick", "javascript:OpenCaseLoad('5762',10915,'StartDate=" + "" + "#EndDate=" + "" + "#ProgramId=-1#Forms=1#GeneralLocationOfIncident=-1#ClientNameFilter=" + "" + "#FromDashboard=Y#Status=9#Staff=-1');");

                        #endregion

                        #region AssignedReview
                        LinkButtonRestrictiveProgress.Attributes.Add("onClick", "javascript:OpenCaseLoad('5762',10915,'StartDate=" + "" + "#EndDate=" + "" + "#ProgramId=-1#Forms=2#GeneralLocationOfIncident=-1#ClientNameFilter=" + "" + "#Status=21#Staff=" + sqlparameter[0].Value + "');");
                        LinkButtonRestrictiveAssignedReview.Attributes.Add("onClick", "javascript:OpenCaseLoad('5762',10915,'StartDate=" + "" + "#EndDate=" + "" + "#ProgramId=-1#Forms=2#GeneralLocationOfIncident=-1#ClientNameFilter=" + "" + "#FromDashboard=Y#Status=9#Staff=-1');");
                        #endregion
                    }
                }
            }


        }
        finally
        {
            dataSet = null;
        }
    }

    public override string Heading
    {
        get
        {
            return _controlHeading;
        }
        set
        {
            _controlHeading = value;
        }
    }

    public override string RefreshData
    {
        get
        {
            return _refreshData;
        }
        set
        {
            _refreshData = value;
        }
    }

    public override string SpName
    {
        get
        {
            return "csp_SCDashBoardIncidentReportsRestrictiveProcedure";
        }
    }

    public override string SqlConnection
    {
        get { return string.Empty; }
    }

    public override System.Data.SqlClient.SqlParameter[] SqlParameter
    {
        get
        {
            _sqlParameter = new SqlParameter[1];
            _sqlParameter[0] = new SqlParameter("@LoggedInStaffId", SHS.BaseLayer.BaseCommonFunctions.ApplicationInfo.LoggedInUser.LoggedinUserId);
            return _sqlParameter;
        }
    }

    public override int UserId
    {
        get { return SHS.BaseLayer.BaseCommonFunctions.ApplicationInfo.LoggedInUser.UserId; }
    }

}

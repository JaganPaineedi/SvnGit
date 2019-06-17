using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SHS.BaseLayer;
using Microsoft.ApplicationBlocks.Data;
using System.Data.SqlClient;
using SHS.DataServices;
using System.Data;
using System.Text;
using System.Xml.Linq;
using System.IO;


public partial class Custom_PsychiatricNote_WebPages_SubstanceUsesPopUp : SHS.BaseLayer.ActivityPages.CustomActivityPage
{
    public string PopupMode = string.Empty;

    protected override void OnLoad(EventArgs e)
    {
        if (!GetRequestParameterValue("Mode").IsNullOrWhiteSpace())
            PopupMode = GetRequestParameterValue("Mode").Trim();

        FillGridViewForAxisAndLegendPopups(PopupMode);

    }

    private void FillGridViewForAxisAndLegendPopups(string PopupMode)
    {
        SqlParameter[] _objectSqlParmeters;
        DataSet datasetDSMDescriptions = null;
        var CurrentDiagnosis = SHS.BaseLayer.BaseCommonFunctions.GetScreenInfoDataSet();

        _objectSqlParmeters = new SqlParameter[1];
        _objectSqlParmeters[0] = new SqlParameter("@Subatance", PopupMode);
        datasetDSMDescriptions = SqlHelper.ExecuteDataset(Connection.ConnectionString, CommandType.StoredProcedure, "csp_SCGetSubstanceUseDiagnosis", _objectSqlParmeters);
        if (datasetDSMDescriptions != null && datasetDSMDescriptions.Tables.Count > 0)
        {
            GridViewAxisI.DataSource = datasetDSMDescriptions;
            GridViewAxisI.DataBind();
        }
        //GridViewAxisI.DataSource = CurrentDiagnosis.Tables["DocumentDiagnosisCodes"];
        //GridViewAxisI.DataBind();

        Page.Title = "Diagnosis Code";


    }
    protected void GridViewAxisI_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        string ICD10CodeId; string code; string description; string DSMVCodeId; string LabelICD9Code; string billable;
        string codeDescriptionAxis; string raplceDoubleQuation; string value; string axisValue; string LabelSeverityText; string LabelSeverityId;
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            Label _label1 = e.Row.FindControl("LabelICD10Code") as Label;
            ICD10CodeId = ((Label)(e.Row.FindControl("ICD10CodeId"))).Text.Trim();
            LabelSeverityText = ((Label)(e.Row.FindControl("LabelSeverityText"))).Text.Trim();
            LabelSeverityId = ((Label)(e.Row.FindControl("LabelSeverityId"))).Text.Trim();
            code = ((Label)(e.Row.FindControl("LabelICD10Code"))).Text.Trim();
            LabelICD9Code = ((Label)(e.Row.FindControl("LabelICD9Code"))).Text;
            description = ((Label)(e.Row.FindControl("LabelDescription"))).Text;
            DSMVCodeId = ((Label)(e.Row.FindControl("LabelDSMVCodeId"))).Text;
            codeDescriptionAxis = code + "$$$" + description + "$$$" + LabelICD9Code + "$$$" + DSMVCodeId + "$$$" + ICD10CodeId + "$$$" + LabelSeverityText + "$$$" + LabelSeverityId;
            raplceDoubleQuation = codeDescriptionAxis.Replace("\"", "^");
            value = codeDescriptionAxis.Replace("'", "\\'").Replace("\"", "&quot;");
            e.Row.Attributes.Add("id", e.Row.RowIndex.ToString());
            e.Row.Attributes.Add("onKeyDown", "SubUseSelectRow();");
            e.Row.Attributes.Add("onclick", "SubUseGetRowValueOnSingleClick('" + value + "', " + e.Row.RowIndex + ");");
            e.Row.Attributes.Add("ondblclick", "SubUseGetRowValueOnDoubleClick('" + value + "');");
            hiddenPreviousRow.Value = e.Row.RowIndex.ToString();
        }
    }

}


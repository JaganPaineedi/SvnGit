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



public partial class Custom_PsychiatricNote_WebPages_PsychiatricNoteProblemPopup : SHS.BaseLayer.ActivityPages.CustomActivityPage
{
    //protected override void OnLoad(EventArgs e)
    //{
    //     SqlParameter[] _objectSqlParmeters;
    //    DataSet datasetDiagnosis = null;
    //    try
    //    {
    //       _objectSqlParmeters = new SqlParameter[1];
    //        _objectSqlParmeters[0] = new SqlParameter("@ClientId", SHS.BaseLayer.BaseCommonFunctions.ApplicationInfo.Client.ClientId);
    //        datasetDiagnosis = SqlHelper.ExecuteDataset(Connection.ConnectionString, CommandType.StoredProcedure, "csp_SCGetPreviousDiagnosisMedicalNote", _objectSqlParmeters);

    //        if (datasetDiagnosis != null && datasetDiagnosis.Tables.Count > 0)
    //        {
    //            DataRow[] DiagnosisDataTable = datasetDiagnosis.Tables[0].Select();
    //            List<Diagnosis> ClientDignosisList = new List<Diagnosis>();
    //            foreach (DataRow dr in DiagnosisDataTable)
    //            {
    //                Diagnosis code = new Diagnosis();
    //                code.ICD10Code  = Convert.ToString(dr[0]);
    //                code.ICD9Code = Convert.ToString(dr[1]);
    //                code.DSM5  = Convert.ToString(dr[2]);
    //                code.Description = Convert.ToString(dr[3]);
    //                ClientDignosisList.Add(code);

    //            }
    //            StringBuilder diagnosishtml = new StringBuilder();
               
    //            foreach (Diagnosis gc in ClientDignosisList)
    //            {
    //                diagnosishtml.Append("<tr style='padding-bottom:2px'>");
    //                diagnosishtml.Append("<td class='checkbox_container' style='padding-left:20px'>");
    //                diagnosishtml.Append("<input type='radio' value='" + gc.ICD10Code + "'  groupname='problemCoderadio' name='problemRadioBox'/>");
    //                diagnosishtml.Append("</td>");
    //                diagnosishtml.Append("<td class='checkbox_container' style='padding-left:20px'>");
    //                diagnosishtml.Append("<label style='padding-left:1px'/>" + gc.ICD10Code);
    //                diagnosishtml.Append("</label>");    
    //                diagnosishtml.Append("</td>");
    //                diagnosishtml.Append("</tr>");
    //            }

    //            hiddenDiagnosis.Value = diagnosishtml.ToString();
    //        }
    //    }
    //    finally
    //    {
    //        if (datasetDiagnosis != null) datasetDiagnosis.Dispose();
    //        _objectSqlParmeters = null;
    //    }
    //}

    protected override void OnLoad(EventArgs e)
    {

        FillGridViewForAxisAndLegendPopups();
       
    }

    private void FillGridViewForAxisAndLegendPopups()
    {
          SqlParameter[] _objectSqlParmeters;
          DataSet datasetDSMDescriptions = null;
          var CurrentDiagnosis = SHS.BaseLayer.BaseCommonFunctions.GetScreenInfoDataSet();

           //_objectSqlParmeters = new SqlParameter[1];
           // _objectSqlParmeters[0] = new SqlParameter("@ClientId", SHS.BaseLayer.BaseCommonFunctions.ApplicationInfo.Client.ClientId);
           // datasetDSMDescriptions = SqlHelper.ExecuteDataset(Connection.ConnectionString, CommandType.StoredProcedure, "csp_SCGetPreviousDiagnosisPsychiatricNote", _objectSqlParmeters);
           // if (datasetDSMDescriptions != null && datasetDSMDescriptions.Tables.Count>0)
           // {
           //     GridViewAxisI.DataSource = datasetDSMDescriptions;
           //     GridViewAxisI.DataBind();
           // }
          GridViewAxisI.DataSource = CurrentDiagnosis.Tables["DocumentDiagnosisCodes"];
          GridViewAxisI.DataBind();

            Page.Title = "Diagnosis Code";
        

    }
    protected void GridViewAxisI_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        string code; string description; string DSMVCodeId; string LabelICD9Code; string billable;
        string codeDescriptionAxis; string raplceDoubleQuation; string value; string axisValue;
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            Label _label1 = e.Row.FindControl("LabelICD10Code") as Label;
            code = ((Label)(e.Row.FindControl("LabelICD10Code"))).Text.Trim();
            LabelICD9Code = ((Label)(e.Row.FindControl("LabelICD9Code"))).Text;
            description = ((Label)(e.Row.FindControl("LabelDescription"))).Text;
            DSMVCodeId = ((Label)(e.Row.FindControl("LabelDSMVCodeId"))).Text;
            codeDescriptionAxis = code + "$$$" + description + "$$$" + LabelICD9Code + "$$$" + DSMVCodeId;
            raplceDoubleQuation = codeDescriptionAxis.Replace("\"", "^");
            value = codeDescriptionAxis.Replace("'", "\\'").Replace("\"", "&quot;");
            e.Row.Attributes.Add("id", e.Row.RowIndex.ToString());
            e.Row.Attributes.Add("onKeyDown", "SelectRow();");
            e.Row.Attributes.Add("onclick", "GetRowValueOnSingleClick('" + value + "', " + e.Row.RowIndex + ");");
            e.Row.Attributes.Add("ondblclick", "GetRowValueOnDoubleClick('" + value + "');");
            hiddenPreviousRow.Value = e.Row.RowIndex.ToString();
        }
    }


}
public class Diagnosis
{
    public string ICD10Code;
    public string ICD9Code;
    public string DSM5;
    public string Description;
}

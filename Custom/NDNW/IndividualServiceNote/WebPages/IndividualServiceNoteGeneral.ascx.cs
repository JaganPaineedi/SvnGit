using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Script.Serialization;
using System.Data.SqlClient;
using Microsoft.ApplicationBlocks.Data;
using SHS.BaseLayer;
using System.Text;
using SHS.BaseLayer.ActivityPages;
using System.Data;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls.WebParts;

public partial class Custom_IndividualServiceNote_WebPages_IndividualServiceNoteGeneral : SHS.BaseLayer.ActivityPages.DataActivityTab
{
    public override void BindControls()
    {
        HiddenFieldGoalsAndObjectives.Value = CreateGrid(BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomIndividualServiceNoteGoals"], BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomIndividualServiceNoteObjectives"]);
    }

    public string CreateGrid(DataTable dt, DataTable dtObj)
    {
        int count = 0;
        StringBuilder sbHtml = new StringBuilder();
        try
        {
            if (dt != null)
            {
                if (dt.Rows.Count > 0)
                {
                    sbHtml.Append("<div>");
                    foreach (DataRow drItem in dt.Rows)
                    {
                        int Goalid = Convert.ToInt32(String.IsNullOrWhiteSpace(drItem["GoalId"].ToString()) ? 0 : drItem["GoalId"]);
                        string GoalActive = drItem["CustomGoalActive"].ToString();

                        sbHtml.Append("<table style='width:100%;'><tr valign='top'>");
                        if (GoalActive == "Y")
                        {
                            sbHtml.Append("<td align='left' class='checkbox_container' valign='top'  style='color:black;width:10%;'><input runat='server' id='CheckBoxGoal_" + Goalid + "' goalidtohide= '" + Goalid + "' type='checkbox' style='cursor: default' checked='checked' onclick=\"javascript:CheckBoxJavascript('" + Goalid + "',this);\"/> <label for='CheckBoxGoal_" + Goalid + "'>Goal " + drItem["GoalNumber"] + "</label></td>");
                            sbHtml.Append("<td align='left' style='color:black;width:50%;'> <span id='spanGoalText_" + Goalid + "' class='form_label'>" + drItem["GoalText"] + "</span></td>");
                            sbHtml.Append("<td align='left' style='color:black;padding-left:35px;padding-top:5px;width:40%;'><span  id='spanStatus_" + Goalid + "' class='form_label'>Status</span></td>");

                        }
                        else
                        {
                            sbHtml.Append("<td align='left' class='checkbox_container' valign='top' style='color:black;width:10%;'><input runat='server' id='CheckBoxGoal_" + Goalid + "' goalidtohide= '" + Goalid + " ' style='cursor: default' type='checkbox' onclick=\"javascript:CheckBoxJavascript('" + Goalid + "',this);\"/> <label for='CheckBoxGoal_" + Goalid + "'>Goal " + drItem["GoalNumber"] + "</label></td>");
                            sbHtml.Append("<td align='left' style='color:black;width:50%;'> <span id='spanGoalText_" + Goalid + "' class='form_label'>" + drItem["GoalText"] + "</span></td>");
                            sbHtml.Append("<td align='left' style='color:black;padding-left:35px;padding-top:5px;width:40%;'><span id='spanStatus_" + Goalid + "' class='form_label'>Status</span></td>");
                        }
                        sbHtml.Append("</tr></table>");


                        if (dtObj.Rows.Count > 0)
                        {
                            DataView DataViewObj = new DataView(dtObj);
                            DataViewObj.RowFilter = "GoalId = " + Goalid;
                            sbHtml.Append("<div>");
                            if (DataViewObj.Count > 0)
                            {
                                foreach (DataRowView drobject in DataViewObj)
                                {
                                    int id = Convert.ToInt32(String.IsNullOrWhiteSpace(drobject["IndividualServiceNoteObjectiveId"].ToString()) ? 0 : drobject["IndividualServiceNoteObjectiveId"]);
                                    string CustomObjectiveActive = drobject["CustomObjectiveActive"].ToString();
                                    decimal ObjectiveNumber = Convert.ToDecimal(String.IsNullOrWhiteSpace(drobject["ObjectiveNumber"].ToString()) ? 0 : drobject["ObjectiveNumber"]);
                                    int Status = Convert.ToInt32(String.IsNullOrWhiteSpace(drobject["Status"].ToString()) ? 0 : drobject["Status"]);

                                    sbHtml.Append("<table style='width:100%;'><tr>");
                                    if (CustomObjectiveActive == "Y")
                                    {
                                        sbHtml.Append("<td align='left' class='checkbox_container'  style='color:black;padding-left:35px;padding-top:5px;width:60%;'><input runat='server' GoalID='" + Goalid + "' type='checkbox' style='cursor: default' id='CheckBoxObjective_" + id + "' label='lblobj' ObjectiveNumber='" + ObjectiveNumber + "' checked='checked' onclick=\"javascript:CheckBoxJavascriptObj('" + ObjectiveNumber + "',this);\"/> <label for='CheckBoxObjective_" + id + "'> Objective #" + "&nbsp" + drobject["ObjectiveNumber"] + ":" + "&nbsp" + "&nbsp" + drobject["ObjectiveText"] + "</label></td><td align='left'style='color:black;padding-left:35px;padding-top:5px;width:40%;'>" + CreateDropDown(Status, id, Goalid, GoalActive) + "</td>");
                                    }
                                    else
                                    {
                                        if (GoalActive == "Y")
                                        {
                                            sbHtml.Append("<td align='left' class='checkbox_container' style='color:black;padding-left:35px;padding-top:5px;width:60%;'><input GoalID='" + Goalid + "' runat='server' type='checkbox' style='cursor: default' id='CheckBoxObjective_" + id + "'  label='lblobj' ObjectiveNumber='" + ObjectiveNumber + "' onclick=\"javascript:CheckBoxJavascriptObj('" + ObjectiveNumber + "',this);\"/><label for='CheckBoxObjective_" + id + "'> Objective #" + "&nbsp" + drobject["ObjectiveNumber"] + ":" + "&nbsp" + "&nbsp" + drobject["ObjectiveText"] + "</label></td><td align='left'style='color:black;padding-left:35px;padding-top:5px;width:40%;'>" + CreateDropDown(Status, id, Goalid, GoalActive) + "</td>");
                                        }
                                        else
                                        {
                                            sbHtml.Append("<td align='left' class='checkbox_container' style='color:black;padding-left:35px;padding-top:5px;width:60%;'><input GoalID='" + Goalid + "' runat='server' type='checkbox' style='cursor: default' id='CheckBoxObjective_" + id + "' disabled = 'disabled' label='lblobj' ObjectiveNumber='" + ObjectiveNumber + "' onclick=\"javascript:CheckBoxJavascriptObj('" + ObjectiveNumber + "',this);\"/><label for='CheckBoxObjective_" + id + "'> Objective #" + "&nbsp" + drobject["ObjectiveNumber"] + ":" + "&nbsp" + "&nbsp" + drobject["ObjectiveText"] + "</label></td><td align='left'style='color:black;padding-left:35px;padding-top:5px;width:40%;'>" + CreateDropDown(Status, id, Goalid, GoalActive) + "</td>");
                                        }
                                    }
                                    sbHtml.Append("</tr></table>");
                                }
                            }

                            else
                            {
                                sbHtml.Append("<table><tr>");
                                sbHtml.Append("<td align='left' class='' style='color:black;padding-left:35px;padding-top:5px'><input type='text' style='cursor: default; display:none' id=''/><label> No Objectives </label></td>");
                                sbHtml.Append("</tr></table>");
                            }
                            sbHtml.Append("</div>");
                        }
                        else
                        {
                            sbHtml.Append("<div>");
                            sbHtml.Append("<table'><tr>");
                            sbHtml.Append("<td align='left' class='' style='color:black;padding-left:85px;padding-top:5px'><input type='text' style='cursor: default; display:none' id=''/><label style='padding-left:22px;padding-top:5px'> No Objectives </label></td>");
                            sbHtml.Append("</tr></table>");
                            sbHtml.Append("</div>");
                        }

                    }
                    sbHtml.Append("</div>");
                }
            }
        }
        catch (Exception ex)
        {
            string CustomExceptionInformation = string.Empty; CustomExceptionInformation = "'CreateGrid' method failed in IndividualServiceNoteGeneral.cs";
            LogManager.OnError(ex, LogManager.LoggingCategory.Error, LogManager.LoggingLevel.Error, null, CustomExceptionInformation);
        }
        sbHtml.Append("</table>");
        return sbHtml.ToString();
    }

    public string CreateDropDown(int value, int id, int goalid, string GoalActive)
    {
        StringBuilder stDropDownHtml = new StringBuilder();
        DataView dataViewCodeName = new DataView();
        DataTable dtStatusDropDown = new DataTable();
        try
        {
            if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes != null)
            {
                dataViewCodeName = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
                dataViewCodeName.RowFilter = "Category='XGOALOBJECTIVESTATUS' and  Active='Y' and ISNULL(RecordDeleted,'N')<>'Y'";
                dataViewCodeName.Sort = "SortOrder,CodeName";
            }
            dtStatusDropDown = dataViewCodeName.ToDataTable();

            if (GoalActive == "Y")
            {
                stDropDownHtml.Append("<select id='DropDownList_CustomIndividualServiceNoteObjectives_Status_" + id + "' ObjGoalID='" + goalid + "' class='form_dropdown' bindautosaveevents='False' style='width: 40%;' onchange='UpdateStatus(this)'>");
            }
            else
            {
                stDropDownHtml.Append("<select id='DropDownList_CustomIndividualServiceNoteObjectives_Status_" + id + "' disabled = 'disabled' ObjGoalID='" + goalid + "' class='form_dropdown' bindautosaveevents='False' style='width: 40%;' onchange='UpdateStatus(this)'>");
            }
            stDropDownHtml.Append("<option value=''></option>");
            for (int GlobalCodeCount = 0; GlobalCodeCount < dtStatusDropDown.Rows.Count; GlobalCodeCount++)
            {
                if (value == Convert.ToInt32(String.IsNullOrWhiteSpace(dtStatusDropDown.Rows[GlobalCodeCount]["GlobalCodeId"].ToString()) ? 0 : dtStatusDropDown.Rows[GlobalCodeCount]["GlobalCodeId"]))
                {
                    stDropDownHtml.Append("<option value= " + dtStatusDropDown.Rows[GlobalCodeCount]["GlobalCodeId"].ToString() + " selected='selected'>");
                }
                else
                {
                    stDropDownHtml.Append("<option value= " + dtStatusDropDown.Rows[GlobalCodeCount]["GlobalCodeId"].ToString() + ">");
                }
                stDropDownHtml.Append(dtStatusDropDown.Rows[GlobalCodeCount]["CodeName"].ToString() + "</option>");
            }
        }
        catch (Exception ex)
        {
            string CustomExceptionInformation = string.Empty; CustomExceptionInformation = "'CreateDropDown' method failed in IndividualServiceNoteGeneral.cs";
            LogManager.OnError(ex, LogManager.LoggingCategory.Error, LogManager.LoggingLevel.Error, null, CustomExceptionInformation);
        }
        stDropDownHtml.Append("</select>");
        return stDropDownHtml.ToString();
    }
}

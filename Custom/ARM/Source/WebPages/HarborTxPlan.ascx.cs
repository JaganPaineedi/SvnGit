using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SHS.BaseLayer;
using System.Data;
using System.Text;
using System.Data.SqlClient;
using Microsoft.ApplicationBlocks.Data;
using SHS.DataServices;
namespace SHS.SmartCare
{

    public partial class ActivityPages_Client_Detail_HarborTreatmentPlan_HarborTxPlan : SHS.BaseLayer.ActivityPages.DataActivityTab
    {
        string goalNo = string.Empty;
        public string diagnosisListInformation = "";
        /// <summary>
        /// <Description></Description>
        /// <Author></Author>
        /// <CreatedOn></CreatedOn>
        /// </summary>
        public override void BindControls()
        {
            HiddenFieldRelativePath.Value = Page.ResolveUrl("~/");
            CreateGoal();
            
        }

        /// <summary>
        /// <Description>This method is used to Make The Goal Section on the screen </Description>
        /// <Author>Rohit Katoch</Author>       
        /// </summary>
        private void CreateGoal()
        {
            DataSet dataSetTreatmentPlanHRM = null;
            DataView dataViewTPNeeds = null;
            DataRowView dataRowViewTPNeeds = null;
            StringBuilder stringBuilderHTML = null;
            int DocumentCodeId = 0;
            try
            {
                PanelTxPlanMain.Controls.Clear();

                using (dataSetTreatmentPlanHRM = BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet)
                {
                    if (dataSetTreatmentPlanHRM == null)
                    {
                        dataSetTreatmentPlanHRM = BaseCommonFunctions.GetScreenInfoDataSet();
                    }
                    DocumentCodeId = Convert.ToInt32(dataSetTreatmentPlanHRM.Tables["Documents"].Rows[0]["DocumentCodeId"]);
                    if (dataSetTreatmentPlanHRM != null && dataSetTreatmentPlanHRM.Tables.Count > 0)
                    {
                        if (dataSetTreatmentPlanHRM.Tables.Contains("CustomTPGoals") && BaseCommonFunctions.CheckRowExists(dataSetTreatmentPlanHRM, "CustomTPGoals", 0))
                        {
                            dataViewTPNeeds = new DataView(dataSetTreatmentPlanHRM.Tables["CustomTPGoals"]);
                            //Sort On the basis of Need Number because we have show Goal on Number basis
                            dataViewTPNeeds.Sort = "GoalNumber";
                            dataViewTPNeeds.RowFilter = "Isnull(RecordDeleted,'N')<>'Y'";
                            //Set Need Count in the hidden field
                            //Loop how many rows exists in the TPNeeds table for creating Goal
                            stringBuilderHTML = new StringBuilder();
                            //Adding the table Goals/Objectives/Services



                            stringBuilderHTML.Append("<table Id='TableHarborTxPlainMain1'  style='width:830px;' border='0' cellpadding='0' cellspacing='0'  BindAutoSaveEvents ='False'  BindSetFormData='False'>");

                            for (int needCount = 0; needCount < dataViewTPNeeds.Count; needCount++)
                            {
                                goalNo = dataViewTPNeeds[needCount]["GoalNumber"].ToString();
                                dataRowViewTPNeeds = dataViewTPNeeds[needCount]; //Create DataRowView 
                                stringBuilderHTML.Append("<tr>");
                                stringBuilderHTML.Append("<td style='width:100%'>");
                                stringBuilderHTML.Append("<table Id=" + needCount + "  style='width:100%;'  border='0' cellpadding='0' cellspacing='0'  BindAutoSaveEvents ='False'  BindSetFormData='False'>");

                                #region First TR of Main Table (start Section)
                                stringBuilderHTML.Append("<tr>");
                                stringBuilderHTML.Append("<td colspan=3>");
                                stringBuilderHTML.Append("<table cellspacing='0'  cellpadding='0' border='0' width='100%'>");

                                stringBuilderHTML.Append("<tr>");
                                stringBuilderHTML.Append("<td align='left' nowrap='nowrap' class='content_tab_left'>");
                                stringBuilderHTML.Append("<span name=Span_CustomTPGoals_GoalNumber_" + dataRowViewTPNeeds["GoalNumber"].ToString() + "  id=Span_CustomTPGoals_GoalNumber_" + dataRowViewTPNeeds["GoalNumber"].ToString() + " style='color:Black;font-size:11px;' BindAutoSaveEvents ='False'  BindSetFormData='False' > Goal # " + dataRowViewTPNeeds["GoalNumber"].ToString() + "</span>");
                                stringBuilderHTML.Append("</td>");
                                stringBuilderHTML.Append("<td width='17'>");
                                stringBuilderHTML.Append("<img style='vertical-align: top' height='26' width='17' alt='' src=" + RelativePath + "App_Themes/Includes/Images/content_tab_sep.gif />");
                                stringBuilderHTML.Append("</td>");

                                stringBuilderHTML.Append("<td width='100%' class='content_tab_top'>");
                                stringBuilderHTML.Append("</td>");
                                stringBuilderHTML.Append("<td width='7'>");
                                stringBuilderHTML.Append("<img style='vertical-align: top' height='26' width='7' alt='' src=" + RelativePath + "App_Themes/Includes/Images/content_tab_right.gif />");
                                stringBuilderHTML.Append("</td>");
                                stringBuilderHTML.Append(" </tr>");
                                stringBuilderHTML.Append("</table>");
                                stringBuilderHTML.Append("</td>");
                                stringBuilderHTML.Append("</tr>");

                                #endregion First TR Main Table (start Section)

                                #region 3 TR for Main Table
                                stringBuilderHTML.Append("<tr>");
                                stringBuilderHTML.Append("<td class='right_contanier_bg' colspan=3>");

                                #region Main Table
                                stringBuilderHTML.Append("<table cellspacing='0' cellpadding='0' border='0' width='100%' id=Table_" + goalNo + " GoalId='"+dataViewTPNeeds[needCount]["TPGoalId"]+"' >");
                                #region Main TR
                                stringBuilderHTML.Append("<tr>");
                                stringBuilderHTML.Append("<td style='width:100%'>");
                                stringBuilderHTML.Append("<table cellspacing='0' cellpadding='0' border='0' width='100%'>");
                                #region 2
                                //To show difference between the two rows
                                stringBuilderHTML.Append("<tr>");
                                stringBuilderHTML.Append("<td colspan='3'>");
                                stringBuilderHTML.Append("&nbsp;");
                                stringBuilderHTML.Append("</td>");
                                stringBuilderHTML.Append("</tr>");
                                //Ended Over here
                                #endregion
                                #region 1st TR opening
                                stringBuilderHTML.Append("<tr>");
                                #region 1st td in 1st tr
                                stringBuilderHTML.Append("<td colspan='3'>"); // class='right_contanier_bg'
                                stringBuilderHTML.Append("<table cellspacing='0' cellpadding='0' border='0' width='100%'>");
                                stringBuilderHTML.Append("<tr>");
                                stringBuilderHTML.Append("<td width='99px'>");

                                #region
                                if (dataRowViewTPNeeds["DeletionNotAllowed"].ToString().Trim() != "Y")
                                {
                                    stringBuilderHTML.Append("<img id=Img_CustomTPGoals_TPGoalId_" + dataRowViewTPNeeds["TPGoalId"].ToString() + "  name=Img_CustomTPGoals_TPGoalId_" + dataRowViewTPNeeds["TPGoalId"].ToString() + " src=" + RelativePath + "App_Themes/Includes/Images/deleteIcon.gif  tag=" + dataRowViewTPNeeds["TPGoalId"].ToString() + "   style='cursor:hand;' onclick = \"DaleteTxPlanGoal('" + dataRowViewTPNeeds["TPGoalId"].ToString() + "','" + dataViewTPNeeds.Count + "');\"/>");
                                }
                                #endregion

                                //Assign Goal Text e.g (Goal#1)
                                stringBuilderHTML.Append("<span name=Span_CustomTPGoals_GoalNumber_" + dataRowViewTPNeeds["TPGoalId"].ToString() + "  id=Span_CustomTPGoals_GoalNumber_" + dataRowViewTPNeeds["TPGoalId"].ToString() + " style='color:Black;font-size:11px;' ParentChildControls='True' > Goal # " + dataRowViewTPNeeds["GoalNumber"].ToString() + "</span>");
                                stringBuilderHTML.Append("</td>");
                                #endregion
                                #region 2nd td in 1st tr
                                // Code By Rohit Katoch
                                stringBuilderHTML.Append("<td align='left' style='width:700px;'>");// colspan='3' Ist Row 3rd Column
                                stringBuilderHTML.Append("<table cellspacing='0' cellpadding='0' border='0' width='99%'>");
                                stringBuilderHTML.Append("<tr>");
                                stringBuilderHTML.Append("<td>");
                                stringBuilderHTML.Append("<textarea   onChange = \"ModifyGoalValueInDataSet('" + dataRowViewTPNeeds["TPGoalId"].ToString() + "','" + "CustomTPGoals" + "','" + "GoalText" + "','" + "TextArea_CustomTPGoals_GoalText_" + dataRowViewTPNeeds["TpGoalID"].ToString() + "','" + "Edit" + "','" + "TpGoalID" + "');\"  name=TextArea_CustomTPGoals_GoalText_" + dataRowViewTPNeeds["TpGoalID"].ToString() + "  id=TextArea_CustomTPGoals_GoalText_" + dataRowViewTPNeeds["TpGoalID"].ToString() + "   class='form_textareaWithoutWidth'  parentchildcontrols='True' cols='138' rows='3' spellcheck='True'>");
                                if (dataRowViewTPNeeds["GoalText"] != DBNull.Value)
                                {
                                    stringBuilderHTML.Append(dataRowViewTPNeeds["GoalText"].ToString().Trim() + "</textarea>");
                                }
                                else
                                {
                                    stringBuilderHTML.Append("</textarea>");
                                }
                                stringBuilderHTML.Append("</td>");
                                stringBuilderHTML.Append("</tr>");
                                stringBuilderHTML.Append("</table>");
                                stringBuilderHTML.Append("</td>");
                                #endregion
                                stringBuilderHTML.Append("</tr>");
                                stringBuilderHTML.Append("</table>");
                                stringBuilderHTML.Append("</td>");
                                stringBuilderHTML.Append("</tr>");//Closing 1st row
                                #endregion

                                #region 2
                                //To show difference between the two rows
                                stringBuilderHTML.Append("<tr>");
                                stringBuilderHTML.Append("<td colspan='3'>");
                                stringBuilderHTML.Append("&nbsp;");
                                stringBuilderHTML.Append("</td>");
                                stringBuilderHTML.Append("</tr>");
                                //Ended Over here
                                #endregion

                                #region 2nd TR opening
                                stringBuilderHTML.Append("<tr>");
                                stringBuilderHTML.Append("<td colspan='3'>");

                                stringBuilderHTML.Append("<table style='width:100%;' cellborder='0' cellspacing='0' cellpadding='0' >");
                                stringBuilderHTML.Append("<tr>");
                                stringBuilderHTML.Append("<td style='width:70px;'  >");
                                stringBuilderHTML.Append("&nbsp;");
                                stringBuilderHTML.Append("</td>");
                                #region 2nd td in 2nd tr
                                stringBuilderHTML.Append("<td  colspan='2' align='left'>");
                                stringBuilderHTML.Append("<table cellspacing='0' cellpadding='0' border='0' width='100%'>");
                                stringBuilderHTML.Append("<tr>");
                                stringBuilderHTML.Append("<td style='padding-left:30px;'>");
                                stringBuilderHTML.Append("<span BindAutoSaveEvents ='False'  BindSetFormData='False'  name=Span_UseQuickGoal_" + dataRowViewTPNeeds["TPGoalId"].ToString() + "  id=Span_UseQuickGoal_" + dataRowViewTPNeeds["TPGoalId"].ToString() + " style='text-decoration:underline;cursor:hand;color:Black;font-size:11px;'  onclick=\"OpenModelDialogueQuickTxPlan('" + dataRowViewTPNeeds["TPGoalId"].ToString() + "','" + "TextArea_CustomTPGoals_GoalText_" + dataRowViewTPNeeds["TPGoalId"].ToString() + "','" + "CustomTPGlobalQuickGoals" + "','" + "CustomTPGoals" + "');\">Use Quick Goal</span>"); //Create
                                stringBuilderHTML.Append("</td>");
                                stringBuilderHTML.Append("</tr>");
                                stringBuilderHTML.Append("</table>");
                                stringBuilderHTML.Append("</td>");
                                #endregion
                                stringBuilderHTML.Append("</tr>");
                                stringBuilderHTML.Append("</table>");
                                stringBuilderHTML.Append("</td>");
                                stringBuilderHTML.Append("</tr>");

                                #endregion 2nd Row closing

                                #region 4
                                //To show difference between the two rows
                                stringBuilderHTML.Append("<tr>");
                                stringBuilderHTML.Append("<td colspan='3'>");
                                stringBuilderHTML.Append("&nbsp;");
                                stringBuilderHTML.Append("</td>");
                                stringBuilderHTML.Append("</tr>");
                                //Ended Over here
                                #endregion

                                #region 3rd Row opening
                                stringBuilderHTML.Append("<tr>");
                                stringBuilderHTML.Append("<td colspan='3'>");
                                stringBuilderHTML.Append("<table style='width:100%' cellborder='0' cellspacing='0' cellpadding='0' >");
                                stringBuilderHTML.Append("<tr>");

                                stringBuilderHTML.Append("<td style='width:70px;' >");
                                stringBuilderHTML.Append("&nbsp;");
                                stringBuilderHTML.Append("</td>");
                                #region 2
                                stringBuilderHTML.Append("<td colspan='2' align='left'>");

                                stringBuilderHTML.Append("<table cellpadding='0' cellspacing='0' border='0' width='100%'>");

                                stringBuilderHTML.Append("<tr class='date_Container'>"); //1st Row Open tag                               
                                stringBuilderHTML.Append("<td style='width:4%;padding-left:26px;' align='left' valign='middle;padding-right:5px;'>"); //1st Row 1st Open Col tag
                                stringBuilderHTML.Append("<span ParentChildControls='True' name=Span_TargetDate_" + dataRowViewTPNeeds["TpGoalId"].ToString() + "  id=Span_TargetDate_" + dataRowViewTPNeeds["TpGoalId"].ToString() + "  class='form_label'  BindAutoSaveEvents ='False'  BindSetFormData='False' >Target Date:</span>");
                                stringBuilderHTML.Append("</td>"); //1st Row 1st Col Close tag

                                stringBuilderHTML.Append("<td style='width:24%'>"); //1st Row 2nd  Col Open tag
                                stringBuilderHTML.Append("<table cellpadding='0' cellspacing='0'>"); //Create
                                stringBuilderHTML.Append("<tr class='date_Container'>"); //1st Row Open tag

                                stringBuilderHTML.Append("<td style='padding-left:3px;'>");
                                if (dataRowViewTPNeeds["TargeDate"] != DBNull.Value) //Peform DBNull Check
                                {
                                    stringBuilderHTML.Append("<input type='text' datatype='Date' value='" + Convert.ToDateTime(dataRowViewTPNeeds["TargeDate"]).ToString("MM/dd/yyyy") + "'  name=Text_CustomTPGoals_TargeDate_" + dataRowViewTPNeeds["TPGoalId"].ToString() + "  id=Text_CustomTPGoals_TargeDate_" + dataRowViewTPNeeds["TPGoalId"].ToString() + "  BindAutoSaveEvents ='False'  BindSetFormData='False' onChange = \"ModifyGoalValueInDataSet('" + dataRowViewTPNeeds["TPGoalId"].ToString() + "','" + "CustomTPGoals" + "','" + "TargeDate" + "','" + "Text_CustomTPGoals_TargeDate_" + dataRowViewTPNeeds["TpGoalID"].ToString() + "','" + "Edit" + "','" + "TpGoalID" + "');\" />"); //Create  
                                }
                                else
                                {
                                    stringBuilderHTML.Append("<input type='text'  datatype='Date' name=Text_CustomTPGoals_TargeDate_" + dataRowViewTPNeeds["TPGoalId"].ToString() + "  id=Text_CustomTPGoals_TargeDate_" + dataRowViewTPNeeds["TPGoalId"].ToString() + "     BindAutoSaveEvents ='False'  BindSetFormData='False' onChange = \"ModifyGoalValueInDataSet('" + dataRowViewTPNeeds["TPGoalId"].ToString() + "','" + "CustomTPGoals" + "','" + "TargeDate" + "','" + "Text_CustomTPGoals_TargeDate_" + dataRowViewTPNeeds["TpGoalID"].ToString() + "','" + "Edit" + "','" + "TpGoalID" + "');\" />");
                                }
                                stringBuilderHTML.Append("</td>");

                                stringBuilderHTML.Append("<td>&nbsp;"); //1st Row 3rd Column Open Tag
                                stringBuilderHTML.Append("</td>");

                                stringBuilderHTML.Append("<td align='left'>");  //1st Row 2nd Col Open tag
                                stringBuilderHTML.Append("<img id=Img_CustomTPGoals_TargetDate_" + dataRowViewTPNeeds["TPGoalId"].ToString() + " name=Img_CustomTPGoals_TargetDate_" + dataRowViewTPNeeds["TPGoalId"].ToString() + "  src=" + RelativePath + "App_Themes/Includes/Images/calender_grey.gif  style='cursor:hand;' onclick=\"return showCalendar('Text_CustomTPGoals_TargeDate_" + dataRowViewTPNeeds["TPGoalId"].ToString() + "','%m/%d/%Y');\"/>"); //Create 
                                stringBuilderHTML.Append("</td>");

                                stringBuilderHTML.Append("</tr>"); //1st Row Close tag
                                stringBuilderHTML.Append("</table>"); //Close tag
                                stringBuilderHTML.Append("</td>"); //1st Row 2nd Col  Close tag

                                stringBuilderHTML.Append("</tr>");
                                stringBuilderHTML.Append("</table>");

                                stringBuilderHTML.Append("</td>");
                                #endregion

                                stringBuilderHTML.Append("</tr>");
                                stringBuilderHTML.Append("</table>");
                                stringBuilderHTML.Append("</td>");
                                stringBuilderHTML.Append("</tr>");
                                #endregion 3rd row closing

                                #region 6
                                //To show difference between the two rows
                                stringBuilderHTML.Append("<tr>");
                                stringBuilderHTML.Append("<td colspan='3'>");
                                stringBuilderHTML.Append("&nbsp;");
                                stringBuilderHTML.Append("</td>");
                                stringBuilderHTML.Append("</tr>");
                                //Ended Over here
                                #endregion

                                #region 4th row opening
                                stringBuilderHTML.Append("<tr>");
                                #region 2
                                stringBuilderHTML.Append("<td colspan='3'>");
                                #region 4rth Row 3rd Column

                                stringBuilderHTML.Append("<table cellpadding='0' cellspacing='0' border='0' width='100%'>"); //Create
                                stringBuilderHTML.Append("<tr>"); //1st Row Open Tag

                                stringBuilderHTML.Append("<td style='width:15%;padding-right:5px;' align='right'>"); //1st Row 1st Col Open tag
                                stringBuilderHTML.Append("<span name=Span_AssociatedNeeds_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "  id=Span_AssociatedNeeds_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "  style='color:Black;font-size:11px;'>Associated Needs</span>"); //Create 
                                stringBuilderHTML.Append("</td>");

                                stringBuilderHTML.Append("<td  rowspan='2' valign='top'  width='85%'>"); //1st Row 2nd Col Open tag
                                stringBuilderHTML.Append("<table cellpadding='0' cellspacing='0' border='0' width='98%'>"); //Create
                                stringBuilderHTML.Append("<tr>");
                                stringBuilderHTML.Append("<td>");
                                #region for ListBox Control
                                DataTable dataTableResult = new DataTable("Result");
                                dataTableResult.Columns.Add("CustomTPNeedsNeedId", typeof(int));
                                dataTableResult.Columns.Add("NeedText", typeof(string));
                                dataTableResult.Columns.Add("CustomTPGoalNeeds", typeof(int));
                                dataTableResult.Columns.Add("DateNeedAddedtoPlan", typeof(DateTime));

                                DataView dataViewCustomTPGoalNeeds = new DataView(dataSetTreatmentPlanHRM.Tables["CustomTPGoalNeeds"]);

                                dataViewCustomTPGoalNeeds.RowFilter = "TPGoalId=" + Convert.ToString(dataRowViewTPNeeds["TPGoalID"] + " and IsNull(RecordDeleted,'N')<>'Y'");

                                //performs join between table.
                                string needDescription = string.Empty;

                                for (int i = 0; i < dataViewCustomTPGoalNeeds.Count; i++)
                                {
                                    DataRow newRow = dataTableResult.NewRow();
                                    if (newRow != null)
                                    {

                                        newRow["CustomTPGoalNeeds"] = dataViewCustomTPGoalNeeds[i].Row["TPGoalNeeds"];
                                        newRow["CustomTPNeedsNeedId"] = dataViewCustomTPGoalNeeds[i].Row["NeedId"];
                                        newRow["DateNeedAddedtoPlan"] = (dataViewCustomTPGoalNeeds[i].Row["DateNeedAddedtoPlan"] != DBNull.Value) ? Convert.ToDateTime(dataViewCustomTPGoalNeeds[i].Row["DateNeedAddedtoPlan"]).ToString("MM/dd/yyyy") : "";
                                        DataRowView drneedDescription = (DataRowView)dataViewCustomTPGoalNeeds[i];
                                        needDescription = dataViewCustomTPGoalNeeds[i].Row["NeedText"].ToString(); 
                                     

                                        if (needDescription.Length >= 120)
                                        {
                                            needDescription = BaseCommonFunctions.cutText(needDescription, 120);
                                            needDescription = needDescription + "...";
                                        }
                                        newRow["NeedText"] = needDescription;
                                        dataTableResult.Rows.Add(newRow);
                                    }
                                }
                                #endregion
                                #region AssoicatedNeed
                                //Create Div


                                stringBuilderHTML.Append("<div class='form_textarea' id=div_CustomClientNeeds_NeedName_" + dataRowViewTPNeeds["TPGoalID"].ToString() + " style='width:100%;height:60px;overflow-x:auto;padding-left: 20px;width: 665px;'>");
                                stringBuilderHTML.Append("<table multiple='multiple' size='2' style='width:97%;height:100%'>");
                                if (dataTableResult.Rows.Count > 0)
                                {
                                    stringBuilderHTML.Append("<tr><th align='left' width='64%'><b><u>Need </u></b></th><th width='32%' align='center'><b><u>Date Added to Plan</u></b></th></tr>");
                                    for (int tpneedClientNeedCount = 0; tpneedClientNeedCount < dataTableResult.Rows.Count; tpneedClientNeedCount++)
                                    {
                                        stringBuilderHTML.Append("<tr><td align='left' id=" + dataTableResult.Rows[tpneedClientNeedCount]["CustomTPNeedsNeedId"].ToString() + ">");
                                        stringBuilderHTML.Append(dataTableResult.Rows[tpneedClientNeedCount]["NeedText"].ToString() + "</td>");
                                        stringBuilderHTML.Append("<td align='center' id=" + dataTableResult.Rows[tpneedClientNeedCount]["CustomTPGoalNeeds"].ToString() + ">");
                                        stringBuilderHTML.Append((dataTableResult.Rows[tpneedClientNeedCount]["DateNeedAddedtoPlan"] != DBNull.Value) ? Convert.ToDateTime(dataTableResult.Rows[tpneedClientNeedCount]["DateNeedAddedtoPlan"]).ToString("MM/dd/yyyy") : "" + "</td></tr>");
                                    }
                                }
                                stringBuilderHTML.Append("</table>");
                                stringBuilderHTML.Append("</div>");
                                #endregion
                                stringBuilderHTML.Append("</td>");
                                stringBuilderHTML.Append("</tr>");

                                stringBuilderHTML.Append("</table>"); //Create
                                stringBuilderHTML.Append("</td>"); //1st Row 2nd Col Close tag


                                stringBuilderHTML.Append("</tr>"); //1st Row Close Tag

                                stringBuilderHTML.Append("<tr>"); //2nd Row Open Tag
                                stringBuilderHTML.Append("<td align='right'  valign='top' style='width:15%;padding-right:5px;' >"); //2nd Row 1st Col Open Tag                               
                                stringBuilderHTML.Append("<span name=Span_EditAssociatedNeed_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "  id=Span_EditAssociatedNeed_" + dataRowViewTPNeeds["TPGoalID"].ToString() + " style='text-decoration:underline;cursor:hand;color:Black;font-size:11px;' onclick=\"OpenModelDialogueforAssociatedNeeds('" + "div_CustomClientNeeds_NeedName_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "','" + dataRowViewTPNeeds["TPGoalID"].ToString() + "','" + dataRowViewTPNeeds["GoalNumber"].ToString() + "')\" >Edit</span>"); //Create
                                stringBuilderHTML.Append("</td>"); //2nd Row 1st Col Close Tag
                                stringBuilderHTML.Append("</tr>"); //2nd Row Close Tag

                                stringBuilderHTML.Append("</table>");
                                #endregion
                                stringBuilderHTML.Append("</td>");
                                #endregion
                                stringBuilderHTML.Append("</tr>");
                                #endregion 4th row closing

                                #region 8
                                //To show difference between the two rows
                                stringBuilderHTML.Append("<tr>");
                                stringBuilderHTML.Append("<td colspan='3'>");
                                stringBuilderHTML.Append("&nbsp;");
                                stringBuilderHTML.Append("</td>");
                                stringBuilderHTML.Append("</tr>");
                                //Ended Over here
                                #endregion

                                PanelTxPlanMain.Controls.Add(new LiteralControl(stringBuilderHTML.ToString()));

                                #region Objective Section


                                //Find Objective with respect to there NeedId from TPObjective table
                                #region 16 TR of TabContent Table

                                #region 1subtable 16 TR

                                #region 1 TR of 1subtable 16 TR
                                CreateObjective(Convert.ToInt32(dataRowViewTPNeeds["TpGoalId"]), Convert.ToInt32(dataRowViewTPNeeds["GoalNumber"]), ref dataSetTreatmentPlanHRM);
                                #endregion 1 TR of 1subtable 16 TR

                                stringBuilderHTML = new StringBuilder();

                                #region 2 TR of 1subtable 16 TR
                                stringBuilderHTML.Append("<tr>");
                                stringBuilderHTML.Append("<td colspan='3' style='height:2px;'>");
                                stringBuilderHTML.Append("&nbsp;");
                                stringBuilderHTML.Append("</td>");
                                stringBuilderHTML.Append("</tr>");
                                #endregion 2 TR of 1subtable 16 TR


                                #region 3 TR of 1subtable 16 TR
                                stringBuilderHTML.Append("<tr>"); //9th Row Open Tag                                
                                stringBuilderHTML.Append("<td align='left' colspan='3'>"); //9th Row 3rd Column Open Tag

                                #region 9th Row 3rd Column

                                if (needCount % 2 == 0)
                                {
                                    stringBuilderHTML.Append("<table cellpadding='0' border='0' cellspacing='0' width='100%;'>"); //Create
                                }
                                else
                                {
                                    stringBuilderHTML.Append("<table cellpadding='0' border='0'  style='width:100%;' cellspacing='0'>"); //Create
                                }
                                stringBuilderHTML.Append("<tr>"); //1st Row Open Tag

                                stringBuilderHTML.Append("<td width='20%;' align='right'>"); //1st Row 1st Col Open Tag
                                stringBuilderHTML.Append("<span ParentChildControls='True'  name=Span_AddObjective_" + dataRowViewTPNeeds["TpGoalID"].ToString() + "  id=Span_AddObjective_" + dataRowViewTPNeeds["TpGoalID"].ToString() + "  style='text-decoration:underline;cursor:hand;color:Black;font-size:11px;' onclick=\"AddObjective('" + dataRowViewTPNeeds["TpGoalId"].ToString() + "');\" >Add Objective</span>"); //Create
                                stringBuilderHTML.Append("</td>"); //1st Row 1st Col Close Tag

                                stringBuilderHTML.Append("<td width='40%' align='center'>"); //1st Row 2nd Col Open Tag

                                DataRow[] dataRowTpObjective = dataSetTreatmentPlanHRM.Tables["CustomTPObjectives"].Select("Isnull(RecordDeleted,'N' )<>'Y' and TpGoalId=" + dataRowViewTPNeeds["TpGoalId"].ToString());
                                if (dataRowTpObjective.Length > 0)
                                {
                                    stringBuilderHTML.Append("<span ParentChildControls='True'  name=Span_RenumberObjective_" + dataRowViewTPNeeds["TpGoalID"].ToString() + "  id=Span_RenumberObjective_" + dataRowViewTPNeeds["TPGoalId"].ToString() + " style='text-decoration:underline;cursor:hand;color:Black;font-size:11px;' onclick=\"OpenRenumberTxPlan('" + "CustomTPObjectives" + "','" + "TPObjectiveId" + "','" + dataRowViewTPNeeds["GoalNumber"].ToString() + "','" + dataRowViewTPNeeds["TPGoalId"].ToString() + "');\" >Renumber Objective</span>");
                                }
                                else
                                {
                                    stringBuilderHTML.Append("<span ParentChildControls='True'  name=Span_RenumberObjective_" + dataRowViewTPNeeds["TpGoalID"].ToString() + "  id=Span_RenumberObjective_" + dataRowViewTPNeeds["TpGoalId"].ToString() + " style='text-decoration:underline;color:Black;font-size:11px;' disabled='disabled'>Renumber Objective</span>");
                                }

                                stringBuilderHTML.Append("</td>"); //1st Row 2nd Col Close Tag

                                stringBuilderHTML.Append("<td>"); //1st Row 1st Col Open Tag
                                stringBuilderHTML.Append("&nbsp;"); //Create
                                stringBuilderHTML.Append("</td>");

                                stringBuilderHTML.Append("</tr>"); //1st Row Close Tag
                                stringBuilderHTML.Append("</table>");
                                #endregion

                                stringBuilderHTML.Append("</td>"); //9th Row 3rd Column Close Tag
                                stringBuilderHTML.Append("</tr>"); //9th Row Close Tag
                                #endregion 3 TR of 1subtable 16 TR


                                #endregion 1subtable 16 TR

                                #endregion 16 TR of TabContent Table

                                PanelTxPlanMain.Controls.Add(new LiteralControl(stringBuilderHTML.ToString()));
                                stringBuilderHTML = new StringBuilder();
                                #endregion

                                #region 8
                                //To show difference between the two rows
                                stringBuilderHTML.Append("<tr>");
                                stringBuilderHTML.Append("<td colspan='3'>");
                                stringBuilderHTML.Append("&nbsp;");
                                stringBuilderHTML.Append("</td>");
                                stringBuilderHTML.Append("</tr>");
                                //Ended Over here
                                #endregion

                                #region 1 TR of Services
                                stringBuilderHTML.Append("<tr>");
                                stringBuilderHTML.Append("<td colspan='3' style='height:2px;'>");
                                stringBuilderHTML.Append("&nbsp;");
                                stringBuilderHTML.Append("</td>");
                                stringBuilderHTML.Append("</tr>");
                                #endregion 1 TR of Services

                                #region 2 TR of Services
                                //Checking if any row for services corresponding to a Goal exists or not
                                if (dataSetTreatmentPlanHRM.Tables.Contains("CustomTPServices")) //Perform Table contain Check
                                {

                                    if (BaseCommonFunctions.CheckRowExists(dataSetTreatmentPlanHRM, "CustomTPServices", 0))
                                    {
                                        DataRow[] dataRowCustomTpServices = dataSetTreatmentPlanHRM.Tables["CustomTPServices"].Select("Isnull(RecordDeleted,'N' )<>'Y' and TpGoalId=" + dataRowViewTPNeeds["TPGoalID"].ToString() + "", "ServiceNumber Asc");
                                        if (dataRowCustomTpServices.Length > 0)
                                        {

                                            stringBuilderHTML.Append("<tr>"); //1st Row Open Tag

                                            stringBuilderHTML.Append("<td style='width:3%;' valign='top'>"); //1st Row 1st Col Open tag                              
                                            stringBuilderHTML.Append("</td>");//1st Row 1st Col Close tag
                                            stringBuilderHTML.Append("<td style='width:8%;' valign='top'>");//1st Row 2nd Col Open tag
                                            stringBuilderHTML.Append("</td>");//1st Row 2nd Col Close tag

                                            stringBuilderHTML.Append("<td align='left'>"); //1st Row 3rd Column Open Tag
                                            stringBuilderHTML.Append("<table cellpadding='0' border='0' cellspacing='0' width='99%'>"); //Create
                                            stringBuilderHTML.Append("<tr>"); //1st Row Open Tag

                                            stringBuilderHTML.Append("<td style='width:23%;text-align:left;' >");
                                            stringBuilderHTML.Append("<span class='form_label'><b>Service</b></span>");
                                            stringBuilderHTML.Append("</td>");

                                            stringBuilderHTML.Append("<td style='width:15%;text-align:center;'>");
                                            stringBuilderHTML.Append("<span class='form_label'><b>How Many</b></span>");
                                            stringBuilderHTML.Append("</td>");
                                            stringBuilderHTML.Append("<td style='width:15%;text-align:left;'>");
                                            stringBuilderHTML.Append("</td>");

                                            stringBuilderHTML.Append("<td style='width:27%;text-align:left;'>");
                                            stringBuilderHTML.Append("<span class='form_label'><b>How Often</b></span>");
                                            stringBuilderHTML.Append("</td>");
                                            stringBuilderHTML.Append("<td style='width:10%;text-align:center;'>");
                                            stringBuilderHTML.Append("</td>");
                                            stringBuilderHTML.Append("<td style='width:17%;text-align:center;'>");
                                            stringBuilderHTML.Append("</td>");
                                            stringBuilderHTML.Append("<tr>");
                                            stringBuilderHTML.Append("</table>");

                                            stringBuilderHTML.Append("</td>"); //1st Row 3rd Column Close Tag
                                            stringBuilderHTML.Append("</tr>"); //1st Row Close Tag
                                        }
                                    }
                                }
                                #endregion 2 TR of Services

                                PanelTxPlanMain.Controls.Add(new LiteralControl(stringBuilderHTML.ToString()));
                                stringBuilderHTML = new StringBuilder();
                                #region Service Section
                                #region 17 TR of TabContent Table

                                #region 1 TR of Sub table 1 of Service
                                CreateService(Convert.ToInt32(dataRowViewTPNeeds["TPGoalID"]), goalNo, ref dataSetTreatmentPlanHRM);
                                #endregion 1 TR of Sub table 1 of Service



                                #region 2 TR of Sub table 1 of Service
                                stringBuilderHTML.Append("<tr>");
                                stringBuilderHTML.Append("<td colspan='3' style='height:2px;'>");
                                stringBuilderHTML.Append("&nbsp;");
                                stringBuilderHTML.Append("</td>");
                                stringBuilderHTML.Append("</tr>");
                                #endregion 2 TR of Sub table 1 of Service


                                #region 3 TR of Sub table 1 of Service
                                stringBuilderHTML.Append("<tr>"); //9th Row Open Tag                               
                                stringBuilderHTML.Append("<td align='left' colspan='3'>"); //9th Row 3rd Column Open Tag
                                #region 9th Row 3rd Column
                                stringBuilderHTML.Append("<table cellpadding='0' border='0' style='width:100%' cellspacing='0'>"); //Create
                                stringBuilderHTML.Append("<tr>"); //1st Row Open Tag
                                stringBuilderHTML.Append("<td align='right' style='width:20%;padding-right:11px;'>"); //1st Row 1st Col Open Tag                              
                                stringBuilderHTML.Append("<span ParentChildControls='True'  name=Span_AddService_" + dataRowViewTPNeeds["TpGoalID"].ToString() + "  id=Span_AddService_" + dataRowViewTPNeeds["TPGoalId"].ToString() + " style='text-decoration:underline;cursor:hand;color:Black;font-size:11px;' onclick=\"AddService('" + dataRowViewTPNeeds["TPGoalId"].ToString() + "');\" >Add Service</span>"); //Create
                                stringBuilderHTML.Append("</td>"); //1st Row 1st Col Close Tag
                                stringBuilderHTML.Append("<td style='width:80%;'>");
                                stringBuilderHTML.Append("</td>");
                                stringBuilderHTML.Append("</tr>"); //1st Row Close Tag
                                stringBuilderHTML.Append("</table>");

                                #endregion
                                stringBuilderHTML.Append("</td>"); //9th Row 3rd Column Close Tag
                                stringBuilderHTML.Append("</tr>");
                                #endregion 3 TR of Sub table 1 of Service

                                #endregion 17 TR of TabContent Table

                                #region Show Space
                                stringBuilderHTML.Append("<tr>");
                                stringBuilderHTML.Append("<td colspan='3' style='height:15px;'>");
                                stringBuilderHTML.Append("</td>");
                                stringBuilderHTML.Append("</tr>");
                                #endregion Show Space

                                //Check as the enclosed conditional Html should not be made for Initial
                                if (DocumentCodeId != 1483 && DocumentCodeId != 1486)
                                {
                                    #region Goal Status
                                    stringBuilderHTML.Append("<tr>");
                                    stringBuilderHTML.Append("<td align='left' colspan='3'>");

                                    stringBuilderHTML.Append("<table cellpadding='0' cellspacing='0' width='100%;'>");
                                    stringBuilderHTML.Append("<tr>");
                                    stringBuilderHTML.Append("<td align='left' style='padding-left:7px;'>");
                                    stringBuilderHTML.Append("<table style='width:50%;' border='0' cellspacing='0' cellpadding='0'>");
                                    stringBuilderHTML.Append("<tr class='RadioText'>");
                                    #region 1 td
                                    stringBuilderHTML.Append("<td>");
                                    stringBuilderHTML.Append("<span class='form_label'><b>Goal Status:</b></span>");
                                    stringBuilderHTML.Append("</td>");
                                    #endregion
                                    #region 2 td
                                    stringBuilderHTML.Append("<td>"); //1st Row 1st Column Open Tag    
                                    string goalActive = string.Empty;
                                    if (dataRowViewTPNeeds["Active"] != DBNull.Value) //Peform DBNull Check
                                    {
                                        goalActive = dataRowViewTPNeeds["Active"].ToString();//Get the value of GoalActive
                                    }
                                    else
                                    {
                                        goalActive = "Y";
                                    }
                                    if (goalActive.ToUpper() == "Y")
                                    {
                                        stringBuilderHTML.Append("<input   BindAutoSaveEvents ='False'  BindSetFormData='False'  type='radio' class='RadioText'  onclick = \"ModifyGoalValueInDataSet('" + dataRowViewTPNeeds["TPGoalID"].ToString() + "','" + "CustomTPGoals" + "','" + "Active" + "','" + "Radio_CustomTPGoals_Active_Y_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "','" + "Edit" + "','" + "TPGoalID" + "');\" checked='checked' id=Radio_CustomTPGoals_Active_Y_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "  name='Radio_CustomTPGoals_Active_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "'");
                                        stringBuilderHTML.Append("value='Y'/><label for=Radio_CustomTPGoals_Active_Y_");
                                        stringBuilderHTML.Append(dataRowViewTPNeeds["TPGoalID"].ToString());
                                        stringBuilderHTML.Append(">Goal is active</label>");
                                    }
                                    else
                                    {
                                        stringBuilderHTML.Append("<input   BindAutoSaveEvents ='False'  BindSetFormData='False'  type='radio' class='RadioText'  onclick = \"ModifyGoalValueInDataSet('" + dataRowViewTPNeeds["TPGoalID"].ToString() + "','" + "CustomTPGoals" + "','" + "Active" + "','" + "Radio_CustomTPGoals_Active_Y_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "','" + "Edit" + "','" + "TPGoalID" + "');\"   id=Radio_CustomTPGoals_Active_Y_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "  name='Radio_CustomTPGoals_Active_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "'");
                                        stringBuilderHTML.Append("value='Y'/><label for=Radio_CustomTPGoals_Active_Y_");
                                        stringBuilderHTML.Append(dataRowViewTPNeeds["TPGoalID"].ToString());
                                        stringBuilderHTML.Append(">Goal is active</label>");
                                    }
                                    stringBuilderHTML.Append("</td>"); //1st Row 1st Column Close Tag
                                    #endregion
                                    #region 3 td
                                    stringBuilderHTML.Append("<td>"); //1st Row 2nd Column Open Tag
                                    if (goalActive.ToUpper() == "N")
                                    {
                                        stringBuilderHTML.Append("<input  BindAutoSaveEvents ='False'  BindSetFormData='False'  type='radio' class='RadioText'  onclick = \"ModifyGoalValueInDataSet('" + dataRowViewTPNeeds["TPGoalID"].ToString() + "','" + "CustomTPGoals" + "','" + "Active" + "','" + "Radio_CustomTPGoals_Active_N_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "','" + "Edit" + "','" + "TPGoalID" + "');\"     checked='checked' id=Radio_CustomTPGoals_Active_N_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "  name='Radio_CustomTPGoals_Active_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "'");
                                        stringBuilderHTML.Append("value='N' /><label for=Radio_CustomTPGoals_Active_N_");
                                        stringBuilderHTML.Append(dataRowViewTPNeeds["TPGoalID"].ToString());
                                        stringBuilderHTML.Append(">Goal is NOT active</label>");
                                    }
                                    else
                                    {
                                        stringBuilderHTML.Append("<input  BindAutoSaveEvents ='False'  BindSetFormData='False'  type='radio' class='RadioText'  onclick = \"ModifyGoalValueInDataSet('" + dataRowViewTPNeeds["TPGoalID"].ToString() + "','" + "CustomTPGoals" + "','" + "Active" + "','" + "Radio_CustomTPGoals_Active_N_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "','" + "Edit" + "','" + "TPGoalID" + "');\"    id=Radio_CustomTPGoals_Active_N_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "  name='Radio_CustomTPGoals_Active_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "'");
                                        stringBuilderHTML.Append("value='N' /><label for=Radio_CustomTPGoals_Active_N_");
                                        stringBuilderHTML.Append(dataRowViewTPNeeds["TPGoalID"].ToString());
                                        stringBuilderHTML.Append(">Goal is NOT active</label>");
                                    }
                                    stringBuilderHTML.Append("</td>");
                                    #endregion
                                    stringBuilderHTML.Append("</tr>");
                                    stringBuilderHTML.Append("</table>");
                                    stringBuilderHTML.Append("</td>");
                                    stringBuilderHTML.Append("</tr>");//1st Row Close tag
                                    stringBuilderHTML.Append("</table>");
                                    stringBuilderHTML.Append("</td>");
                                    stringBuilderHTML.Append("</tr>");//1st Row Close tag
                                    #endregion Goal Status

                                    #region Show Space
                                    stringBuilderHTML.Append("<tr>");
                                    stringBuilderHTML.Append("<td colspan='3' style='height:15px;'>");
                                    stringBuilderHTML.Append("</td>");
                                    stringBuilderHTML.Append("</tr>");
                                    #endregion Show Space

                                    #region Goal Progress Rate
                                    //Progress Rate row 1
                                    stringBuilderHTML.Append("<tr>");
                                    stringBuilderHTML.Append("<td colspan='3'>");
                                    stringBuilderHTML.Append("<span class='form_label'><b>Rating of progress towards goal(required when service discontinued or goal made inactive):</b></span>");
                                    stringBuilderHTML.Append("</td>");
                                    stringBuilderHTML.Append("</tr>");

                                    #region Show Space
                                    stringBuilderHTML.Append("<tr>");
                                    stringBuilderHTML.Append("<td colspan='3' style='height:9px;'>");
                                    stringBuilderHTML.Append("</td>");
                                    stringBuilderHTML.Append("</tr>");
                                    #endregion Show Space

                                    //Progress Rate row 2
                                    string RateProgress = string.Empty;
                                    if (dataRowViewTPNeeds["ProgressTowardsGoal"] != null)
                                    {
                                        RateProgress = dataRowViewTPNeeds["ProgressTowardsGoal"].ToString();
                                    }
                                    stringBuilderHTML.Append("<tr>");
                                    stringBuilderHTML.Append("<td colspan='3'>");
                                    stringBuilderHTML.Append("<table style='width:70%;' cellborder='0' cellpadding='0' cellspacing='0'>");
                                    stringBuilderHTML.Append("<tr class='RadioText'>");
                                    stringBuilderHTML.Append("<td nowrap='nowrap'>");
                                    if (RateProgress == "D")
                                    {
                                        stringBuilderHTML.Append("<input  BindAutoSaveEvents ='False'  BindSetFormData='False'  type='radio' class='RadioText'  onclick = \"ModifyGoalValueInDataSet('" + dataRowViewTPNeeds["TPGoalID"].ToString() + "','" + "CustomTPGoals" + "','" + "ProgressTowardsGoal" + "','" + "Radio_CustomTPGoals_ProgressTowardsGoal_D_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "','" + "Edit" + "','" + "TPGoalID" + "');\" checked='checked' id=Radio_CustomTPGoals_ProgressTowardsGoal_D_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "  name='Radio_CustomTPGoals_ProgressTowardsGoal_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "'");
                                        stringBuilderHTML.Append("value='D'/>");
                                    }
                                    else
                                    {
                                        stringBuilderHTML.Append("<input  BindAutoSaveEvents ='False'  BindSetFormData='False'  type='radio' class='RadioText'  onclick = \"ModifyGoalValueInDataSet('" + dataRowViewTPNeeds["TPGoalID"].ToString() + "','" + "CustomTPGoals" + "','" + "ProgressTowardsGoal" + "','" + "Radio_CustomTPGoals_ProgressTowardsGoal_D_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "','" + "Edit" + "','" + "TPGoalID" + "');\" id=Radio_CustomTPGoals_ProgressTowardsGoal_D_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "  name='Radio_CustomTPGoals_ProgressTowardsGoal_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "' ");
                                        stringBuilderHTML.Append("value='D'/>");
                                    }

                                    stringBuilderHTML.Append("<label for=Radio_CustomTPGoals_ProgressTowardsGoal_D_" + dataRowViewTPNeeds["TPGoalID"].ToString() + ">Deterioration</label>");
                                    stringBuilderHTML.Append("</td>");



                                    stringBuilderHTML.Append("<td nowrap='nowrap'>");
                                    if (RateProgress == "N")
                                    {
                                        stringBuilderHTML.Append("<input  BindAutoSaveEvents ='False'  BindSetFormData='False'  type='radio' class='RadioText'  onclick = \"ModifyGoalValueInDataSet('" + dataRowViewTPNeeds["TPGoalID"].ToString() + "','" + "CustomTPGoals" + "','" + "ProgressTowardsGoal" + "','" + "Radio_CustomTPGoals_ProgressTowardsGoal_N_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "','" + "Edit" + "','" + "TPGoalID" + "');\" checked='checked' id=Radio_CustomTPGoals_ProgressTowardsGoal_N_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "  name='Radio_CustomTPGoals_ProgressTowardsGoal_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "'");
                                        stringBuilderHTML.Append("value='N'/>");
                                    }
                                    else
                                    {
                                        stringBuilderHTML.Append("<input  BindAutoSaveEvents ='False'  BindSetFormData='False'  type='radio' class='RadioText'  onclick = \"ModifyGoalValueInDataSet('" + dataRowViewTPNeeds["TPGoalID"].ToString() + "','" + "CustomTPGoals" + "','" + "ProgressTowardsGoal" + "','" + "Radio_CustomTPGoals_ProgressTowardsGoal_N_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "','" + "Edit" + "','" + "TPGoalID" + "');\"  id=Radio_CustomTPGoals_ProgressTowardsGoal_N_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "  name='Radio_CustomTPGoals_ProgressTowardsGoal_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "' ");
                                        stringBuilderHTML.Append("value='N'/>");
                                    }

                                    stringBuilderHTML.Append("<label for=Radio_CustomTPGoals_ProgressTowardsGoal_N_" + dataRowViewTPNeeds["TPGoalID"].ToString() + ">No change</label>");
                                    stringBuilderHTML.Append("</td>");

                                    stringBuilderHTML.Append("<td nowrap='nowrap'>");
                                    if (RateProgress == "S")
                                    {
                                        stringBuilderHTML.Append("<input  BindAutoSaveEvents ='False'  BindSetFormData='False'  type='radio' class='RadioText'  onclick = \"ModifyGoalValueInDataSet('" + dataRowViewTPNeeds["TPGoalID"].ToString() + "','" + "CustomTPGoals" + "','" + "ProgressTowardsGoal" + "','" + "Radio_CustomTPGoals_ProgressTowardsGoal_S_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "','" + "Edit" + "','" + "TPGoalID" + "');\" checked='checked' id=Radio_CustomTPGoals_ProgressTowardsGoal_S_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "  name='Radio_CustomTPGoals_ProgressTowardsGoal_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "'");
                                        stringBuilderHTML.Append("value='S'/>");
                                    }
                                    else
                                    {
                                        stringBuilderHTML.Append("<input  BindAutoSaveEvents ='False'  BindSetFormData='False'  type='radio' class='RadioText'  onclick = \"ModifyGoalValueInDataSet('" + dataRowViewTPNeeds["TPGoalID"].ToString() + "','" + "CustomTPGoals" + "','" + "ProgressTowardsGoal" + "','" + "Radio_CustomTPGoals_ProgressTowardsGoal_S_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "','" + "Edit" + "','" + "TPGoalID" + "');\"  id=Radio_CustomTPGoals_ProgressTowardsGoal_S_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "  name='Radio_CustomTPGoals_ProgressTowardsGoal_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "' ");
                                        stringBuilderHTML.Append("value='S'/>");
                                    }

                                    stringBuilderHTML.Append("<label for=Radio_CustomTPGoals_ProgressTowardsGoal_S_" + dataRowViewTPNeeds["TPGoalID"].ToString() + ">Some Improvement</label>");
                                    stringBuilderHTML.Append("</td>");

                                    stringBuilderHTML.Append("<td nowrap='nowrap'>");
                                    if (RateProgress == "M")
                                    {
                                        stringBuilderHTML.Append("<input  BindAutoSaveEvents ='False'  BindSetFormData='False'  type='radio' class='RadioText'  onclick = \"ModifyGoalValueInDataSet('" + dataRowViewTPNeeds["TPGoalID"].ToString() + "','" + "CustomTPGoals" + "','" + "ProgressTowardsGoal" + "','" + "Radio_CustomTPGoals_ProgressTowardsGoal_M_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "','" + "Edit" + "','" + "TPGoalID" + "');\" checked='checked' id=Radio_CustomTPGoals_ProgressTowardsGoal_M_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "  name='Radio_CustomTPGoals_ProgressTowardsGoal_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "'");
                                        stringBuilderHTML.Append("value='M'/>");
                                    }
                                    else
                                    {
                                        stringBuilderHTML.Append("<input  BindAutoSaveEvents ='False'  BindSetFormData='False'  type='radio' class='RadioText'  onclick = \"ModifyGoalValueInDataSet('" + dataRowViewTPNeeds["TPGoalID"].ToString() + "','" + "CustomTPGoals" + "','" + "ProgressTowardsGoal" + "','" + "Radio_CustomTPGoals_ProgressTowardsGoal_M_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "','" + "Edit" + "','" + "TPGoalID" + "');\"  id=Radio_CustomTPGoals_ProgressTowardsGoal_M_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "  name='Radio_CustomTPGoals_ProgressTowardsGoal_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "' ");
                                        stringBuilderHTML.Append("value='M'/>");
                                    }

                                    stringBuilderHTML.Append("<label for=Radio_CustomTPGoals_ProgressTowardsGoal_M_" + dataRowViewTPNeeds["TPGoalID"].ToString() + ">Moderate Improvement</label>");
                                    stringBuilderHTML.Append("</td>");

                                    stringBuilderHTML.Append("<td nowrap='nowrap'>");
                                    if (RateProgress == "A")
                                    {
                                        stringBuilderHTML.Append("<input  BindAutoSaveEvents ='False'  BindSetFormData='False'  type='radio' class='RadioText'  onclick = \"ModifyGoalValueInDataSet('" + dataRowViewTPNeeds["TPGoalID"].ToString() + "','" + "CustomTPGoals" + "','" + "ProgressTowardsGoal" + "','" + "Radio_CustomTPGoals_ProgressTowardsGoal_A_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "','" + "Edit" + "','" + "TPGoalID" + "');\" checked='checked' id=Radio_CustomTPGoals_ProgressTowardsGoal_A_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "  name='Radio_CustomTPGoals_ProgressTowardsGoal_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "'");
                                        stringBuilderHTML.Append("value='A'/>");
                                    }
                                    else
                                    {
                                        stringBuilderHTML.Append("<input  BindAutoSaveEvents ='False'  BindSetFormData='False'  type='radio' class='RadioText'  onclick = \"ModifyGoalValueInDataSet('" + dataRowViewTPNeeds["TPGoalID"].ToString() + "','" + "CustomTPGoals" + "','" + "ProgressTowardsGoal" + "','" + "Radio_CustomTPGoals_ProgressTowardsGoal_A_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "','" + "Edit" + "','" + "TPGoalID" + "');\"  id=Radio_CustomTPGoals_ProgressTowardsGoal_A_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "  name='Radio_CustomTPGoals_ProgressTowardsGoal_" + dataRowViewTPNeeds["TPGoalID"].ToString() + "'");
                                        stringBuilderHTML.Append("value='A'/>");
                                    }

                                    stringBuilderHTML.Append("<label for=Radio_CustomTPGoals_ProgressTowardsGoal_A_" + dataRowViewTPNeeds["TPGoalID"].ToString() + ">Acheived</label>");
                                    stringBuilderHTML.Append("</td>");
                                    stringBuilderHTML.Append("</tr>");
                                    stringBuilderHTML.Append("</table>");
                                    stringBuilderHTML.Append("</td>");
                                    stringBuilderHTML.Append("</tr>");
                                    #endregion Goal Progress Rate

                                    #region Show Space
                                    stringBuilderHTML.Append("<tr>");
                                    stringBuilderHTML.Append("<td colspan='3' style='height:15px;'>");
                                    stringBuilderHTML.Append("</td>");
                                    stringBuilderHTML.Append("</tr>");
                                    #endregion Show Space
                                }

                                PanelTxPlanMain.Controls.Add(new LiteralControl(stringBuilderHTML.ToString()));
                                stringBuilderHTML = new StringBuilder();
                                #endregion
                                PanelTxPlanMain.Controls.Add(new LiteralControl(stringBuilderHTML.ToString()));
                                stringBuilderHTML = new StringBuilder();
                                stringBuilderHTML.Append("</table>");
                                stringBuilderHTML.Append("</td>");
                                stringBuilderHTML.Append("</tr>");
                                #endregion Main TR
                                stringBuilderHTML.Append("</table>");//Table Goal No. closed
                                #endregion MainTable

                                stringBuilderHTML.Append("</td>"); //1st Row 3rd Column Close Tag
                                stringBuilderHTML.Append("</tr>");
                                #endregion 3 TR for Main Table

                                #region 4 TR for Main Table
                                stringBuilderHTML.Append("<tr>");
                                stringBuilderHTML.Append("<td colspan=3>");
                                stringBuilderHTML.Append("<table cellspacing='0' cellpadding='0' border='0' width='100%'>");
                                stringBuilderHTML.Append("<tr>");

                                stringBuilderHTML.Append("<td width='2' class='right_bottom_cont_bottom_bg'>");
                                stringBuilderHTML.Append("<img style='vertical-align: top' height='7'  alt='' src=" + RelativePath + "App_Themes/Includes/Images/right_bottom_cont_bottom_left.gif /> ");
                                stringBuilderHTML.Append("</td>");

                                stringBuilderHTML.Append("<td width='100%' class='right_bottom_cont_bottom_bg'>");
                                stringBuilderHTML.Append("</td>");

                                stringBuilderHTML.Append("<td align='right' width='2' class='right_bottom_cont_bottom_bg'>");
                                stringBuilderHTML.Append("<img style='vertical-align: top' height='7'  alt='' src=" + RelativePath + "App_Themes/Includes/Images/right_bottom_cont_bottom_right.gif />");
                                stringBuilderHTML.Append("</td>");

                                stringBuilderHTML.Append("</tr>");
                                stringBuilderHTML.Append("</table>");
                                stringBuilderHTML.Append("</td>");
                                stringBuilderHTML.Append("</tr>");
                                #endregion 4 TR for Main Table

                                stringBuilderHTML.Append("<tr>");
                                stringBuilderHTML.Append("<td style='width:3%;height:3px;' colspan='3'>&nbsp;</td>");
                                stringBuilderHTML.Append("</tr>");

                                stringBuilderHTML.Append("</table>");//Table Need count Ends here

                                PanelTxPlanMain.Controls.Add(new LiteralControl(stringBuilderHTML.ToString()));
                                stringBuilderHTML = new StringBuilder();
                            }
                            #region Add Goal
                            stringBuilderHTML = new StringBuilder();


                            //Html to be made only for Treatment Plan Initial
                            //if (DocumentCodeId == 1483 || DocumentCodeId == 1486)
                            //{
                                #region Show Space
                                stringBuilderHTML.Append("<tr>");
                                stringBuilderHTML.Append("<td colspan='3' style='height:15px;'>");
                                stringBuilderHTML.Append("</td>");
                                stringBuilderHTML.Append("</tr>");
                                #endregion Show Space

                                #region 5th TR
                                stringBuilderHTML.Append("<tr>"); //8th Row Open Tag                           
                                stringBuilderHTML.Append("<td colspan='3' align='left'>");
                                stringBuilderHTML.Append("<table border='0' cellpadding='0' cellspacing='0' width='100%'>"); //Create
                                stringBuilderHTML.Append("<tr>");
                                stringBuilderHTML.Append("<td width='1%' >");
                                stringBuilderHTML.Append("&nbsp;"); //Create
                                stringBuilderHTML.Append("</td>");
                                stringBuilderHTML.Append("<td align='left'>");
                                stringBuilderHTML.Append("<span name=Span_AddGoal_" + dataRowViewTPNeeds["TpGoalId"].ToString() + "  id=Span_AddGoal_" + dataRowViewTPNeeds["TpGoalId"].ToString() + "  style='text-decoration:underline;cursor:hand;color:Black;font-size:11px;' onclick=\"OpenModelDialogueHRMTPGoal('" + dataRowViewTPNeeds["TpGoalId"].ToString() + "','" + "Add Goal" + "');\" >Add Goal</span>"); //Create
                                stringBuilderHTML.Append("</td>");
                                stringBuilderHTML.Append("<td width='1%' >");
                                stringBuilderHTML.Append("&nbsp;"); //Create
                                stringBuilderHTML.Append("</td>");
                                stringBuilderHTML.Append("<td align='left'>");
                                stringBuilderHTML.Append("<span BindAutoSaveEvents ='False'  BindSetFormData='False'  name=Span_RenumberGoal_" + dataRowViewTPNeeds["TPGoalId"].ToString() + "  id=Span_RenumberGoal_" + dataRowViewTPNeeds["TPGoalId"].ToString() + " style='text-decoration:underline;cursor:hand;color:Black;font-size:11px;' onclick=\"OpenRenumberTxPlan('" + "CustomTPGoals" + "','" + "TPGoalId" + "','" + dataRowViewTPNeeds["GoalNumber"].ToString() + "','" + dataRowViewTPNeeds["TPGoalId"].ToString() + "');\"> Renumber Goals</span>"); //Create 
                                stringBuilderHTML.Append("</td>");
                                stringBuilderHTML.Append("</tr>");
                                stringBuilderHTML.Append("</table>");
                                stringBuilderHTML.Append("</td>");
                                stringBuilderHTML.Append("</tr>");
                                #endregion

                            //}

                                

                            stringBuilderHTML.Append("</table>");
                            dataSetTreatmentPlanHRM.Tables["CustomTPGoals"].DefaultView.RowFilter = "";
                            PanelTxPlanMain.Controls.Add(new LiteralControl(stringBuilderHTML.ToString()));
                            #endregion
                        }

                    }
                }
            }
            finally
            {
                dataSetTreatmentPlanHRM = null;
                dataViewTPNeeds = null;
                dataRowViewTPNeeds = null;
            }
        }

        /// <summary>
        /// <Description>This method is used to Read Data from TPObjective and Create Objective Section</Description>
        /// <Author>Vikas Vyas</Author>
        /// <CreatedOn>11th-Sept-2009</CreatedOn>
        /// </summary>
        private void CreateObjective(int TpGoalId, int goalNumber, ref DataSet dataSetTreatmentPlanHRM)
        {
            StringBuilder stringBuilderHTML = null;
            DataRow[] dataRowTpObjective = null;
            DataRowView[] dataRowViewTPObjective = null;
            double objectiveNumber = 0.0;
            int DocumentCodeId = 0;
            DropDownList dropdownListObjectiveActive = null;
            try
            {
                if (dataSetTreatmentPlanHRM.Tables.Contains("CustomTPobjectives")) //Perform Table contain Check
                {
                    stringBuilderHTML = new StringBuilder();
                    if (BaseCommonFunctions.CheckRowExists(dataSetTreatmentPlanHRM, "CustomTPobjectives", 0))
                    {
                        DocumentCodeId = Convert.ToInt32(dataSetTreatmentPlanHRM.Tables["Documents"].Rows[0]["DocumentCodeId"]);
                        //Find out the Number of Objectives Corresponding to a Goal
                        dataRowTpObjective = dataSetTreatmentPlanHRM.Tables["CustomTPobjectives"].Select("Isnull(RecordDeleted,'N' )<>'Y' and TpGoalId=" + TpGoalId + "", "ObjectiveNumber Asc");
                        if (dataRowTpObjective.Length > 0)
                        {
                            for (int objectiveCount = 0; objectiveCount < dataRowTpObjective.Length; objectiveCount++)
                            {
                                DataView dataViewTPObjectives = new DataView(dataSetTreatmentPlanHRM.Tables["CustomTPobjectives"]);
                                dataViewTPObjectives.Sort = "TPObjectiveId Asc";
                                //Create DataRowView 
                                dataRowViewTPObjective = dataViewTPObjectives.FindRows(dataRowTpObjective[objectiveCount]["TPObjectiveId"]);

                                #region 1 TR of OBjective
                                stringBuilderHTML.Append("<tr>");
                                stringBuilderHTML.Append("<td colspan='3' style='height:2px;'>");
                                stringBuilderHTML.Append("&nbsp;");
                                stringBuilderHTML.Append("</td>");
                                stringBuilderHTML.Append("</tr>");
                                #endregion 1 TR of OBjective

                                #region 2 TR of OBjective
                                stringBuilderHTML.Append("<tr>"); //1st Row Open Tag
                                stringBuilderHTML.Append("<td colspan='3'>");
                                stringBuilderHTML.Append("<table style='width:100%;' cellborder='0' cellpadding='0' cellspacing='0' >");
                                stringBuilderHTML.Append("<tr>");

                                stringBuilderHTML.Append("<td style='width:9%;padding-right:5px;' align='right' valign='top'>"); //1st Row 1st Col Open tag                              
                                if (dataRowViewTPObjective[0]["DeletionNotAllowed"].ToString().Trim() != "Y")
                                    stringBuilderHTML.Append("<img style='cursor:hand;color:Black;font-size:11px;' id=Img_CustomTPObjectives_TPObjectiveId_" + dataRowViewTPObjective[0]["TPObjectiveId"].ToString() + "  name=Img_CustomTPObjectives_TPObjectiveId_" + dataRowViewTPObjective[0]["TPObjectiveId"].ToString() + " src=" + RelativePath + "App_Themes/Includes/Images/deleteIcon.gif  tag='" + dataRowViewTPObjective[0]["TPObjectiveId"].ToString() + "'  onClick= \"DeleteObjective('" + TpGoalId + "','" + dataRowViewTPObjective[0]["TPObjectiveId"].ToString() + "');\" />");
                                stringBuilderHTML.Append("</td>");//1st Row 1st Col Close tag
                                stringBuilderHTML.Append("<td style='width:35px' align='center' valign='top'>");//1st Row 2nd Col Open tag
                                objectiveNumber = Convert.ToDouble(dataRowViewTPObjective[0]["ObjectiveNumber"].ToString());
                                stringBuilderHTML.Append("<span   style='color:Black;font-size:11px;'  name=Span_CustomTPObjectives_TPObjectiveId_" + dataRowViewTPObjective[0]["TPObjectiveId"].ToString() + "  id=Span_CustomTPObjectives_TPObjectiveId_" + dataRowViewTPObjective[0]["TPObjectiveId"].ToString() + ">Objective" + objectiveNumber.ToString("0.00") + "</span>");
                                stringBuilderHTML.Append("</td>");//1st Row 2nd Col Close tag

                                stringBuilderHTML.Append("<td align='left'  style='padding-left:3px;width:80%;'>"); //1st Row 3rd Column Open Tag

                                stringBuilderHTML.Append("<textarea  spellcheck='True' BindAutoSaveEvents ='False'  BindSetFormData='False' name=TextArea_CustomTPObjectives_ObjectiveText_" + dataRowViewTPObjective[0]["TPObjectiveId"].ToString() + "  id=TextArea_CustomTPObjectives_ObjectiveText_" + dataRowViewTPObjective[0]["TPObjectiveId"].ToString() + " rows='3' cols='126' class='form_textareaWithoutWidth' onChange= \"ModifyGoalValueInDataSet('" + dataRowViewTPObjective[0]["TPObjectiveId"].ToString() + "','" + "CustomTPObjectives" + "','" + "ObjectiveText" + "','" + "TextArea_CustomTPObjectives_ObjectiveText_" + dataRowViewTPObjective[0]["TPObjectiveId"].ToString() + "','" + "Edit" + "','" + "TPObjectiveId" + "');\" >");
                                if (dataRowViewTPObjective[0]["ObjectiveText"] != DBNull.Value)
                                {
                                    stringBuilderHTML.Append(dataRowViewTPObjective[0]["ObjectiveText"].ToString() + "</textarea>");
                                }
                                else
                                {
                                    stringBuilderHTML.Append("</textarea>");
                                }

                                stringBuilderHTML.Append("</td>"); //1st Row 3rd Column Close Tag
                                stringBuilderHTML.Append("<td width='6px'>");
                                stringBuilderHTML.Append("</td>");
                                stringBuilderHTML.Append("</tr>");
                                stringBuilderHTML.Append("</table>");
                                stringBuilderHTML.Append("</td>");

                                stringBuilderHTML.Append("</tr>"); //1st Row Close Tag
                                #endregion 2 TR of OBjective

                                #region 3 TR of OBjective
                                //To show difference between the two rows
                                stringBuilderHTML.Append("<tr>");
                                stringBuilderHTML.Append("<td colspan='3'>");
                                stringBuilderHTML.Append("&nbsp;");
                                stringBuilderHTML.Append("</td>");
                                stringBuilderHTML.Append("</tr>");
                                //Ended Over here
                                #endregion 3 TR of OBjective

                                #region 4 TR of OBjective
                                stringBuilderHTML.Append("<tr>"); //2nd Row Open Tag
                                stringBuilderHTML.Append("<td align='left' colspan='3'>");//2nd Row 3rd Col Open Tag
                                #region subtable1
                                stringBuilderHTML.Append("<table border='0' cellpadding='0' cellspacing='0' width='100%'>"); //Create

                                stringBuilderHTML.Append("<tr>"); //1st Row Open Tag
                                stringBuilderHTML.Append("<td align='right' style='width:31%;padding-right:2px;'>");
                                stringBuilderHTML.Append("<span   name=Span_UseQuickObjective_" + dataRowViewTPObjective[0]["TPObjectiveId"].ToString() + "  id=Span_UseQuickObjective_" + dataRowViewTPObjective[0]["TPObjectiveId"].ToString() + "  style='text-decoration:underline;cursor:hand;color:Black;font-size:11px;' onclick=\"OpenModelDialogueQuickTxPlan('" + dataRowViewTPObjective[0]["TPObjectiveId"].ToString() + "','" + "TextArea_CustomTPObjectives_ObjectiveText_" + dataRowViewTPObjective[0]["TPObjectiveId"].ToString() + "','" + "CustomTPQuickObjectives" + "','" + "CustomTPObjectives" + "');\">Use Quick Objective</span>"); //Create
                                stringBuilderHTML.Append("</td>");

                                stringBuilderHTML.Append("<td align='center' style='width:25%'>");
                                stringBuilderHTML.Append("<span   name=Span_AddthistoQuickObjective_" + dataRowViewTPObjective[0]["TPObjectiveId"].ToString() + "  id=Span_AddthistoQuickObjective_" + dataRowViewTPObjective[0]["TPObjectiveId"].ToString() + "  style='text-decoration:underline;cursor:hand;color:Black;font-size:11px;' onclick=\"OpenModelDialogueAddQuickTxPlan('" + "CustomTPQuickObjectives" + "','" + "TextArea_CustomTPObjectives_ObjectiveText_" + dataRowViewTPObjective[0]["TPObjectiveId"].ToString() + "');\">Add this to Quick Objective</span>"); //Create 
                                stringBuilderHTML.Append("</td>");

                                //Html not be be created for Treatment Plan initial
                                if (DocumentCodeId != 1483 && DocumentCodeId != 1486)
                                {
                                    stringBuilderHTML.Append("<td>");
                                    stringBuilderHTML.Append("<span class='form_label'>Status:</span>");
                                    stringBuilderHTML.Append("</td>");

                                    stringBuilderHTML.Append("<td style='width:20%'>");
                                    PanelTxPlanMain.Controls.Add(new LiteralControl(stringBuilderHTML.ToString()));

                                    stringBuilderHTML = new StringBuilder();

                                    dropdownListObjectiveActive = new DropDownList();
                                    dropdownListObjectiveActive.ID = "DropDownList_RecordDeleted_" + dataRowViewTPObjective[0]["TPObjectiveId"].ToString();
                                    dropdownListObjectiveActive.Width = 100;
                                    dropdownListObjectiveActive.CssClass = "form_dropdown";
                                    ListItem lstItemAciive = new ListItem();
                                    lstItemAciive.Text = "Active";
                                    lstItemAciive.Value = "1";

                                    ListItem lstItemInactive = new ListItem();
                                    lstItemInactive.Text = "Inactive";
                                    lstItemInactive.Value = "0";

                                    dropdownListObjectiveActive.Items.Add(lstItemAciive);
                                    dropdownListObjectiveActive.Items.Add(lstItemInactive);
                                    dropdownListObjectiveActive.DataBind();
                                    dropdownListObjectiveActive.Items.Insert(0, "");
                                    if (dataRowViewTPObjective[0]["Status"].ToString().Trim() == "" || dataRowViewTPObjective[0]["Status"].ToString().Trim() == "1")
                                    {
                                        dropdownListObjectiveActive.SelectedValue = "1";
                                    }
                                    else
                                    {
                                        dropdownListObjectiveActive.SelectedValue = "0";
                                    }

                                    PanelTxPlanMain.Controls.Add(dropdownListObjectiveActive);
                                    dropdownListObjectiveActive.Attributes.Add("onChange", "ModifyGoalValueInDataSet('" + dataRowViewTPObjective[0]["TPObjectiveId"].ToString() + "','" + "CustomTPObjectives" + "','" + "Status" + "','" + dropdownListObjectiveActive.ClientID + "','" + "Edit" + "','" + "TPObjectiveId" + "');");
                                    dropdownListObjectiveActive.Attributes.Add("BindAutoSaveEvents", "False");
                                    dropdownListObjectiveActive.Attributes.Add("BindSetFormData", "False");

                                    stringBuilderHTML.Append("</td>");
                                }
                                else
                                {
                                    stringBuilderHTML.Append("<td>");
                                    stringBuilderHTML.Append("</td>");

                                    stringBuilderHTML.Append("<td style='width:20%'>");
                                    stringBuilderHTML.Append("</td>");
                                }
                                stringBuilderHTML.Append("<td align='center' style='padding-right:5px; width:10%'>");//1st Row  1st Col Open Tag
                                stringBuilderHTML.Append("<span   name=Span_TargetDate_" + dataRowViewTPObjective[0]["TPObjectiveId"].ToString() + "  id=Span_TargetDate_" + dataRowViewTPObjective[0]["TPObjectiveId"].ToString() + "  style='color:Black;font-size:11px;'>Target Date</span>"); //Create                                                            
                                stringBuilderHTML.Append("</td>");//1st Row  1st Col Close Tag

                                stringBuilderHTML.Append("<td align='left' style='width:24%;'>");//1st Row  2nd Col Open Tag
                                #region subtable2
                                stringBuilderHTML.Append("<table border='0' cellpadding='0' cellspacing='0'>");
                                stringBuilderHTML.Append("<tr class='date_Container'>"); //1st Row Open Tag

                                stringBuilderHTML.Append("<td>");
                                if (dataRowViewTPObjective[0]["TargetDate"] != DBNull.Value)
                                {
                                    stringBuilderHTML.Append("<input  BindAutoSaveEvents ='False'  BindSetFormData='False' type='text' datatype='Date' value='" + Convert.ToDateTime(dataRowViewTPObjective[0]["TargetDate"]).ToString("MM/dd/yyyy") + "'   name=Text_CustomTPObjectives_TargetDate_" + dataRowViewTPObjective[0]["TPObjectiveId"].ToString() + "  id=Text_CustomTPObjectives_TargetDate_" + dataRowViewTPObjective[0]["TPObjectiveId"].ToString() + "  class='form_textbox' onChange= \"ModifyGoalValueInDataSet('" + dataRowViewTPObjective[0]["TPObjectiveId"].ToString() + "','" + "CustomTPObjectives" + "','" + "TargetDate" + "','" + "Text_CustomTPObjectives_TargetDate_" + dataRowViewTPObjective[0]["TPObjectiveId"].ToString() + "','" + "Edit" + "','" + "TPObjectiveId" + "');\" />"); //Create  
                                }
                                else
                                {
                                    stringBuilderHTML.Append("<input  BindAutoSaveEvents ='False'  BindSetFormData='False' type='text' datatype='Date'  name=Text_CustomTPObjectives_TargetDate_" + dataRowViewTPObjective[0]["TPObjectiveId"].ToString() + "  id=Text_CustomTPObjectives_TargetDate_" + dataRowViewTPObjective[0]["TPObjectiveId"].ToString() + "  class='form_textbox' onChange= \"ModifyGoalValueInDataSet('" + dataRowViewTPObjective[0]["TPObjectiveId"].ToString() + "','" + "CustomTPObjectives" + "','" + "TargetDate" + "','" + "Text_CustomTPObjectives_TargetDate_" + dataRowViewTPObjective[0]["TPObjectiveId"].ToString() + "','" + "Edit" + "','" + "TPObjectiveId" + "');\" />"); //Create  
                                }
                                stringBuilderHTML.Append("</td>");

                                stringBuilderHTML.Append("<td>");
                                stringBuilderHTML.Append("&nbsp;<img id=Img_CustomTPObjectives_TargetDate_" + dataRowViewTPObjective[0]["TPObjectiveId"].ToString() + " name=Img_CustomTPObjectives_TargetDate_" + dataRowViewTPObjective[0]["TPObjectiveId"].ToString() + "  src=" + RelativePath + "App_Themes/Includes/Images/calender_grey.gif   style='cursor:hand;' onclick=\"return showCalendar('Text_CustomTPObjectives_TargetDate_" + dataRowViewTPObjective[0]["TPObjectiveId"].ToString() + "','%m/%d/%Y');\"/>"); //Create 
                                stringBuilderHTML.Append("</td>");
                                stringBuilderHTML.Append("</tr>");
                                stringBuilderHTML.Append("</table>");
                                #endregion sub table
                                stringBuilderHTML.Append("</td>");//1st Row  2nd Col Close Tag
                                stringBuilderHTML.Append("</tr>");//1st Row Close Tag
                                stringBuilderHTML.Append("</table>"); //Create
                                #endregion subtable1
                                stringBuilderHTML.Append("</td>");//2nd Row 3rd Col Close Tag
                                stringBuilderHTML.Append("</tr>"); //2nd Row Close Tag
                                #endregion 4 TR of OBjective

                                //To show difference between the two rows
                                #region 5 TR of OBjective
                                stringBuilderHTML.Append("<tr>");
                                stringBuilderHTML.Append("<td colspan='3'>");
                                stringBuilderHTML.Append("&nbsp;");
                                stringBuilderHTML.Append("</td>");
                                stringBuilderHTML.Append("</tr>");
                                //Ended Over here
                                #endregion 5 TR of OBjective

                            }
                        }
                    }
                    else
                    {
                        #region 1 TR of OBjective
                        stringBuilderHTML.Append("<tr>");
                        stringBuilderHTML.Append("<td colspan='3' style='height:2px;'>");
                        stringBuilderHTML.Append("&nbsp;");
                        stringBuilderHTML.Append("</td>");

                        stringBuilderHTML.Append("</tr>");
                        #endregion 1 TR of OBjective
                    }
                    PanelTxPlanMain.Controls.Add(new LiteralControl(stringBuilderHTML.ToString()));
                }
            }
            catch (Exception ex)
            {
                ex.ToString();
            }
            finally
            {
                dataRowTpObjective = null;
                dataRowViewTPObjective = null;
            }
        }

        /// <summary>
        /// <Description>To read data from CustomTpServices and create the Services</Description>
        ///<Author>Rohit Katoch</Author>
        /// <CreatedOn>30th-May-2011</CreatedOn>
        /// </summary>
        private void CreateService(int TpGoalId, string goalNumber, ref DataSet dataSetTreatmentPlanHRM)
        {
            StringBuilder stringBuilderHTML = null;
            DataRow[] dataRowCustomTpServices = null;
            DataRowView[] dataRowViewCustomTPServices = null;
            double serviceNumber = 0.0;
            DropDownList dropdownListServiceCode = null;
            DropDownList dropdownListServiceFrequency = null;
            DropDownList dropdownListServiceActive = null;
            int DocumentCodeId = 0;
            try
            {

                if (dataSetTreatmentPlanHRM.Tables.Contains("CustomTPServices")) //Perform Table contain Check
                {
                    stringBuilderHTML = new StringBuilder();
                    if (BaseCommonFunctions.CheckRowExists(dataSetTreatmentPlanHRM, "CustomTPServices", 0))
                    {
                        DocumentCodeId = Convert.ToInt32(dataSetTreatmentPlanHRM.Tables["Documents"].Rows[0]["DocumentCodeId"]);
                        dataRowCustomTpServices = dataSetTreatmentPlanHRM.Tables["CustomTPServices"].Select("Isnull(RecordDeleted,'N' )<>'Y' and TpGoalId=" + TpGoalId + "", "ServiceNumber Asc");

                        if (dataRowCustomTpServices.Length > 0)
                        {

                            for (int serviceCount = 0; serviceCount < dataRowCustomTpServices.Length; serviceCount++)
                            {
                                DataView dataViewTPServices = new DataView(dataSetTreatmentPlanHRM.Tables["CustomTPServices"]);
                                dataViewTPServices.Sort = "TPServiceId Asc";
                                //Create DataRowView 
                                dataRowViewCustomTPServices = dataViewTPServices.FindRows(dataRowCustomTpServices[serviceCount]["TPServiceId"]);

                                #region 1 TR of Services
                                stringBuilderHTML.Append("<tr>");
                                stringBuilderHTML.Append("<td colspan='3' style='height:2px;'>");
                                stringBuilderHTML.Append("&nbsp;");
                                stringBuilderHTML.Append("</td>");
                                stringBuilderHTML.Append("</tr>");
                                #endregion 1 TR of Services

                                #region 2 TR of Services
                                stringBuilderHTML.Append("<tr>"); //1st Row Open Tag

                                stringBuilderHTML.Append("<td style='width:9%;padding-right:5px;' valign='top' align='right'>"); //1st Row 1st Col Open tag                              
                                if (dataRowViewCustomTPServices[0]["DeletionNotAllowed"].ToString().Trim() != "Y")
                                {
                                    stringBuilderHTML.Append("<img style='cursor:hand;color:Black;font-size:11px;' id=Img_CustomTPServices_TPServiceId_" + dataRowViewCustomTPServices[0]["TPServiceId"].ToString() + "  name=Img_CustomTPServices_TPServiceId_" + dataRowViewCustomTPServices[0]["TPServiceId"].ToString() + " src=" + RelativePath + "App_Themes/Includes/Images/deleteIcon.gif  tag='" + dataRowViewCustomTPServices[0]["TPServiceId"].ToString() + "'  onClick= \"DeleteService('" + TpGoalId + "','" + dataRowViewCustomTPServices[0]["TPServiceId"].ToString() + "');\" />");
                                }
                                stringBuilderHTML.Append("</td>");//1st Row 1st Col Close tag


                                stringBuilderHTML.Append("<td style='width:8%' valign='top'>");//1st Row 2nd Col Open tag
                                serviceNumber = Convert.ToDouble(dataRowViewCustomTPServices[0]["ServiceNumber"].ToString());
                                stringBuilderHTML.Append("<span style='color:Black;font-size:11px;'  name=Span_CustomTPServices_TPServiceId_" + dataRowViewCustomTPServices[0]["TPServiceId"].ToString() + "  id=Span_CustomTPServices_TPServiceId_" + dataRowViewCustomTPServices[0]["TPServiceId"].ToString() + ">Service" + serviceNumber.ToString("0.00") + "</span>");
                                stringBuilderHTML.Append("</td>");//1st Row 2nd Col Close tag

                                //stringBuilderHTML.Append("<td align='left' style='padding-left: 20px;'>"); //1st Row 3rd Column Open Tag
                                stringBuilderHTML.Append("<td align='left' style='padding-left: 2px;'>"); //1st Row 3rd Column Open Tag
                                stringBuilderHTML.Append("<table cellpadding='0' border='0' cellspacing='0' width='99%'>"); //Create
                                stringBuilderHTML.Append("<tr>"); //1st Row Open Tag

                                stringBuilderHTML.Append("<td style='width:20%;text-align:left;' >");
                                PanelTxPlanMain.Controls.Add(new LiteralControl(stringBuilderHTML.ToString()));

                                stringBuilderHTML = new StringBuilder();

                                dropdownListServiceCode = new DropDownList();
                                dropdownListServiceCode.ID = "DropDownList_ServiceCode_" + dataRowViewCustomTPServices[0]["TPServiceId"].ToString();
                                dropdownListServiceCode.Width = 150;
                                dropdownListServiceCode.CssClass = "form_dropdown";
                                //using (DataTable DatatableAuthorizationCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.AuthorizationCodes)
                                //{
                                //    DataRow[] dataRowAuthorizationCodes = DatatableAuthorizationCodes.Select("isnull(RecordDeleted,'N')<>'Y'  and Active='Y'");
                                //    dropdownListServiceCode.DataTextField = "AuthorizationCodeName";
                                //    dropdownListServiceCode.DataValueField = "AuthorizationCodeId";
                                //    dropdownListServiceCode.DataSource = dataRowAuthorizationCodes;
                                //    dropdownListServiceCode.DataBind();
                                //    dropdownListServiceCode.Items.Insert(0, "");
                                //}

                                
                                //Modify by :RohitK,on 06-19-2012,1796,#81 Services Drop-Downs,Harbor Go Live Issues
                                //This stored procedure is designed to restrict the authorization codes available based on DocumentCodeId and ClientId
                                using (SHS.UserBusinessServices.ReferralService objectReferralService = new SHS.UserBusinessServices.ReferralService())
                                {
                                    //Added by : Amit Kumar Srivastava, Parameter @isInitialTxTab char(1), #1672, Harbor Go Live Issues, DA: Call csp_ReferralServiceDropDown with extra parameter
                                    //DataSet datasetReferralService = objectReferralService.GetReferralService(DocumentCodeId, Convert.ToInt32(BaseCommonFunctions.ApplicationInfo.Client.ClientId));
                                    DataSet datasetReferralService = objectReferralService.GetReferralService(DocumentCodeId, Convert.ToInt32(BaseCommonFunctions.ApplicationInfo.Client.ClientId),'Y');

                                        dropdownListServiceCode.DataTextField = "DisplayAs";
                                        dropdownListServiceCode.DataValueField = "AuthorizationCodeId";
                                        dropdownListServiceCode.DataSource = datasetReferralService.Tables["AuthorizationCodes"].DefaultView;
                                        dropdownListServiceCode.DataBind();
                                        dropdownListServiceCode.Items.Insert(0, "");
                                }
                                

                                if (dataRowViewCustomTPServices[0]["AuthorizationCodeId"] != DBNull.Value)
                                {
                                    dropdownListServiceCode.SelectedValue = dataRowViewCustomTPServices[0]["AuthorizationCodeId"].ToString();
                                }
                                dropdownListServiceCode.Attributes.Add("ServiceNo", dataRowViewCustomTPServices[0]["ServiceNumber"].ToString());
                                dropdownListServiceCode.Attributes.Add("required", "true");
                                PanelTxPlanMain.Controls.Add(dropdownListServiceCode);
                                dropdownListServiceCode.Attributes.Add("onChange", "OnChangeAuthorizationCodes(this," + dataRowViewCustomTPServices[0]["TPServiceId"].ToString() + ")");
                                dropdownListServiceCode.Attributes.Add("BindAutoSaveEvents", "False");
                                dropdownListServiceCode.Attributes.Add("BindSetFormData", "False");

                                stringBuilderHTML.Append("</td>");

                                stringBuilderHTML.Append("<td style='width:15%;text-align:center;'>");
                                if (dataRowViewCustomTPServices[0]["Units"] != DBNull.Value)
                                {
                                    stringBuilderHTML.Append("<input  BindAutoSaveEvents ='False'  BindSetFormData='False'  value='" + Convert.ToDouble(dataRowViewCustomTPServices[0]["Units"]).ToString() + "'   name=Text_CustomTPServices_Units_" + dataRowViewCustomTPServices[0]["TPServiceId"].ToString() + "  id=Text_CustomTPServices_Units_" + dataRowViewCustomTPServices[0]["TPServiceId"].ToString() + " class='form_textbox' style='width: 50px;' onChange= \"ModifyGoalValueInDataSetCheckInteger('" + dataRowViewCustomTPServices[0]["TPServiceId"].ToString() + "','" + "CustomTPServices" + "','" + "Units" + "','" + "Text_CustomTPServices_Units_" + dataRowViewCustomTPServices[0]["TPServiceId"].ToString() + "','" + "Edit" + "','" + "TPServiceId" + "');\" />"); //Create  
                                }
                                else
                                    stringBuilderHTML.Append("<input  BindAutoSaveEvents ='False'  BindSetFormData='False'  name=Text_CustomTPServices_Units_" + dataRowViewCustomTPServices[0]["TPServiceId"].ToString() + "  id=Text_CustomTPServices_Units_" + dataRowViewCustomTPServices[0]["TPServiceId"].ToString() + "  class='form_textbox' style='width: 50px;' onChange= \"ModifyGoalValueInDataSetCheckInteger('" + dataRowViewCustomTPServices[0]["TPServiceId"].ToString() + "','" + "CustomTPServices" + "','" + "Units" + "','" + "Text_CustomTPServices_Units_" + dataRowViewCustomTPServices[0]["TPServiceId"].ToString() + "','" + "Edit" + "','" + "TPServiceId" + "');\" />"); //Create  

                                stringBuilderHTML.Append("</td>");

                                stringBuilderHTML.Append("<td style='width:16%;text-align:left;'>");
                                stringBuilderHTML.Append("<span BindAutoSaveEvents ='False'  BindSetFormData='False' id=AuthorizationUnitType_" + dataRowViewCustomTPServices[0]["TPServiceId"].ToString() + " class='form_label' >");
                                if (dataRowViewCustomTPServices[0]["UnitType"] != DBNull.Value)
                                {
                                    stringBuilderHTML.Append(dataRowViewCustomTPServices[0]["UnitType"].ToString());
                                }
                                stringBuilderHTML.Append("</span>");
                                stringBuilderHTML.Append("</td>");

                                stringBuilderHTML.Append("<td style='width:23%;text-align:left'>");
                                PanelTxPlanMain.Controls.Add(new LiteralControl(stringBuilderHTML.ToString()));

                                stringBuilderHTML = new StringBuilder();
                                dropdownListServiceFrequency = new DropDownList();
                                dropdownListServiceFrequency.ID = "DropDownList_Frequency_" + dataRowViewCustomTPServices[0]["TPServiceId"].ToString();
                                dropdownListServiceFrequency.Width = 140;
                                dropdownListServiceFrequency.CssClass = "form_dropdown";

                                using (DataView DataViewGlobalCodes = BaseCommonFunctions.FillDropDown("TPFREQUENCYTYPE", true, "", "SortOrder", false))
                                {
                                    dropdownListServiceFrequency.DataTextField = "CodeName";
                                    dropdownListServiceFrequency.DataValueField = "GlobalCodeId";
                                    dropdownListServiceFrequency.DataSource = DataViewGlobalCodes;
                                    dropdownListServiceFrequency.DataBind();
                                    dropdownListServiceFrequency.Items.Insert(0, "");
                                }
                                if (dataRowViewCustomTPServices[0]["FrequencyType"] != DBNull.Value)
                                {
                                    dropdownListServiceFrequency.SelectedValue = dataRowViewCustomTPServices[0]["FrequencyType"].ToString();
                                }

                                PanelTxPlanMain.Controls.Add(dropdownListServiceFrequency);
                                dropdownListServiceFrequency.Attributes.Add("onChange", "ModifyGoalValueInDataSet('" + dataRowViewCustomTPServices[0]["TPServiceId"].ToString() + "','" + "CustomTPServices" + "','" + "FrequencyType" + "','" + dropdownListServiceFrequency.ClientID + "','" + "Edit" + "','" + "TPServiceId" + "');");
                                dropdownListServiceFrequency.Attributes.Add("BindAutoSaveEvents", "False");
                                dropdownListServiceFrequency.Attributes.Add("BindSetFormData", "False");
                                stringBuilderHTML.Append("</td>");

                                if (DocumentCodeId != 1483 && DocumentCodeId != 1486)
                                {
                                    stringBuilderHTML.Append("<td style='width:10%'>");
                                    stringBuilderHTML.Append("<span class='form_label' >Status:</label>");
                                    stringBuilderHTML.Append("</td>");
                                    stringBuilderHTML.Append("<td style='width:17%'>");
                                    PanelTxPlanMain.Controls.Add(new LiteralControl(stringBuilderHTML.ToString()));

                                    stringBuilderHTML = new StringBuilder();
                                    dropdownListServiceActive = new DropDownList();
                                    dropdownListServiceActive.ID = "DropDownList_ServiceActive_" + dataRowViewCustomTPServices[0]["TPServiceId"].ToString();
                                    dropdownListServiceActive.Width = 90;
                                    dropdownListServiceActive.CssClass = "form_dropdown";

                                    ListItem lstItemAciive = new ListItem();
                                    lstItemAciive.Text = "Active";
                                    lstItemAciive.Value = "1";

                                    ListItem lstItemInactive = new ListItem();
                                    lstItemInactive.Text = "Inactive";
                                    lstItemInactive.Value = "0";

                                    dropdownListServiceActive.Items.Add(lstItemAciive);
                                    dropdownListServiceActive.Items.Add(lstItemInactive);
                                    dropdownListServiceActive.DataBind();

                                    if (dataRowViewCustomTPServices[0]["Status"] == DBNull.Value || dataRowViewCustomTPServices[0]["Status"].ToString() == "1")
                                    {
                                        dropdownListServiceActive.SelectedValue = "1";
                                    }
                                    else
                                    {
                                        dropdownListServiceActive.SelectedValue = "0";
                                    }

                                    PanelTxPlanMain.Controls.Add(dropdownListServiceActive);
                                    dropdownListServiceActive.Attributes.Add("onChange", "ModifyGoalValueInDataSet('" + dataRowViewCustomTPServices[0]["TPServiceId"].ToString() + "','" + "CustomTPServices" + "','" + "Status" + "','" + dropdownListServiceActive.ClientID + "','" + "Edit" + "','" + "TPServiceId" + "');");
                                    dropdownListServiceActive.Attributes.Add("BindAutoSaveEvents", "False");
                                    dropdownListServiceActive.Attributes.Add("BindSetFormData", "False");
                                    stringBuilderHTML.Append("</td>");
                                }
                                else
                                {
                                    stringBuilderHTML.Append("<td style='width:10%'>");
                                    stringBuilderHTML.Append("</td>");
                                    stringBuilderHTML.Append("<td style='width:17%'>");
                                    stringBuilderHTML.Append("</td>");
                                }

                                stringBuilderHTML.Append("</tr>");
                                stringBuilderHTML.Append("</table>");

                                stringBuilderHTML.Append("</td>"); //1st Row 3rd Column Close Tag
                                stringBuilderHTML.Append("</tr>"); //1st Row Close Tag
                                #endregion 2 TR of Services
                            }

                        }
                        else
                        {
                            #region 1 TR of OBjective
                            stringBuilderHTML.Append("<tr>");
                            stringBuilderHTML.Append("<td colspan='3' style='height:2px;'>");
                            stringBuilderHTML.Append("&nbsp;");
                            stringBuilderHTML.Append("</td>");
                            stringBuilderHTML.Append("</tr>");
                            #endregion 1 TR of OBjective
                        }
                        PanelTxPlanMain.Controls.Add(new LiteralControl(stringBuilderHTML.ToString()));

                    }

                }

            }
            catch (Exception ex)
            {
            }
            finally
            {
                dataRowCustomTpServices = null;
                dataRowViewCustomTPServices = null;
            }
        }
        public override void CustomAjaxRequest()
        {
            if (GetRequestParameterValue("CustomAjaxRequestType") == "GetCurrentDiagnosis")
            {
                Literal literalStart = new Literal();
                Literal literalHtmlText = new Literal();
                Literal literalEnd = new Literal();
                literalStart.Text = "###StartCurrentDiagnosisUc###";

                DataSet CurrentDiagnosis = new DataSet();
                string CurrentDiagnosisString = string.Empty;
                SqlParameter[] _objectSqlParmeters = null;
                try
                {
                    _objectSqlParmeters = new SqlParameter[1];
                    _objectSqlParmeters[0] = new SqlParameter("@ClientId", SHS.BaseLayer.BaseCommonFunctions.ApplicationInfo.Client.ClientId);
                    SqlHelper.FillDataset(Connection.ConnectionString, CommandType.StoredProcedure, "csp_SCGetCurrentDiagnosis", CurrentDiagnosis, new string[] { "DocumentDiagnosisCodes", "DocumentDiagnosis" }, _objectSqlParmeters);
                    if (CurrentDiagnosis != null)
                    {
                        //PreviousDiagnosisString = PreviosDiagnosis.GetXml().ToString();
                        literalHtmlText.Text = CurrentDiagnosis.GetXml().ToString();
                    }

                }
                finally
                {
                    if (CurrentDiagnosis != null) CurrentDiagnosis.Dispose();
                    _objectSqlParmeters = null;
                }
                literalEnd.Text = "###EndCurrentDiagnosisUc###";
                PanelLoadUC.Controls.Add(literalStart);
                PanelLoadUC.Controls.Add(literalHtmlText);
                PanelLoadUC.Controls.Add(literalEnd);
            }


        }
        
    }
}
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
using SHS.BaseLayer;
using System.Text;
using Microsoft.ApplicationBlocks.Data;
using SHS.DataServices;


namespace SHS.SmartCare
{
    public partial class ActivityPages_Client_Detail_Assessment_HRMRAPQuestions : SHS.BaseLayer.ActivityPages.DataActivityTab
    {
        DropDownList _dropdownListObject = null;
        string FilterRAPColumnName;

        public override void BindControls()
        {
            //  BindRapQuestions(FilterRAPColumnName);
        }

        public void BindRapQuestions(string FilterRAPColumnName)
        {
            StringBuilder _stringBuilderHTML = null;
            DataSet DatasetRapQuestions = new DataSet();
            string tabName = string.Empty;
            string sectionName = string.Empty;
            string setDocumentVersionId = "-1";
            string CheckBoxSelectedvalue = string.Empty;
            int MessageBoxHeight = 0;
            int MessageBoxWidth = 0;

            int DocumentVersionId = Convert.ToInt32(BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["DocumentVersions"].Rows[0]["DocumentVersionId"]);
            if (DocumentVersionId > 0)
                setDocumentVersionId = DocumentVersionId.ToString();
            SqlHelper.FillDataset(Connection.ConnectionString, CommandType.StoredProcedure, "csp_GetHRMRAPQuestions", DatasetRapQuestions, new string[] { "CustomHRMRAPQuestions" });
            
            try
            {
                if (DatasetRapQuestions != null)
                {

                    if (DatasetRapQuestions.Tables.Count > 0)
                    {

                        if (DatasetRapQuestions.Tables.Contains("CustomHRMRAPQuestions") == true)
                        {

                            if (FilterRAPColumnName == "Community Inclusion")
                            {
                                tabName = "RapCommunity";
                                sectionName = "CommunityInclusion";
                                MessageBoxHeight = 220;
                                MessageBoxWidth = 550;
                            }
                            else if (FilterRAPColumnName == "Challenging Behaviors")
                            {
                                tabName = "RapBehaviours";
                                sectionName = "ChallengingBehaviour";
                                MessageBoxHeight = 260;
                                MessageBoxWidth = 550;
                            }
                            else if (FilterRAPColumnName == "Current Abilities")
                            {
                                tabName = "RapAbilities";
                                sectionName = "AbilitiesSummary";
                                MessageBoxHeight = 200;
                                MessageBoxWidth = 550;
                            }
                            else if (FilterRAPColumnName == "Health and Health Care")
                            {
                                tabName = "RapHealth";
                                sectionName = "HealthIssuesSummary";
                                MessageBoxHeight = 180;
                                MessageBoxWidth = 550;

                            }

                            _stringBuilderHTML = new StringBuilder();
                            _stringBuilderHTML.Append("<table width='100%' cellpadding='0'  cellspacing='0'  border='0'>");

                            DataView DataViewCustomHRMRAPQuestions = new DataView();
                            DataViewCustomHRMRAPQuestions.Table = DatasetRapQuestions.Tables["CustomHRMRAPQuestions"];
                            DataViewCustomHRMRAPQuestions.RowFilter = "RAPDomain = '" + FilterRAPColumnName + "'";

                            int i = 0;
                            foreach (DataRowView dr in DataViewCustomHRMRAPQuestions)
                            {
                                string FilterHRMRAPQuestionId = string.Empty;

                                DataView DataViewCustomHRMAssessmentRAPScores = new DataView();
                                DataViewCustomHRMAssessmentRAPScores.Table = SHS.BaseLayer.BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomHRMAssessmentRAPScores"];
                                //DatasetRapQuestions.Tables["Table1"];
                                DataViewCustomHRMAssessmentRAPScores.RowFilter = "HRMRAPQuestionId = '" + dr.Row[0] + "'";
                                #region COmmented Code
                                //if (DataViewCustomHRMAssessmentRAPScores.Count >0)
                                //{
                                //    foreach (DataRowView drFill in DataViewCustomHRMAssessmentRAPScores)
                                //    {
                                //        _stringBuilderHTML.Append("<tr class='checkbox_container'>");
                                //        _stringBuilderHTML.Append("<td >");
                                //        _stringBuilderHTML.Append("<input id='HiddenField_CustomHRMAssessmentRAPScores_HRMRAPQuestionId_" + drFill["HRMRAPQuestionId"] + "'  name='HiddenField_CustomHRMAssessmentRAPScores_HRMRAPQuestionId_" + drFill["HRMRAPQuestionId"] + "' type='hidden' />");
                                //        _stringBuilderHTML.Append("</td>");
                                //        _stringBuilderHTML.Append("<td width='3%' valign='top'>");
                                //        _stringBuilderHTML.Append("<span class='form_label' id='SpanQuesNo" + i + "'>" + drFill["RAPQuestionNumber"] + "</span>");
                                //        _stringBuilderHTML.Append("</td>");

                                //        _stringBuilderHTML.Append("<td width='65%' valign='top'>");
                                //        _stringBuilderHTML.Append("<span class='form_label' id='SpanQuesText" + i + "'>" + drFill["RAPQuestionText"] + "</span>");
                                //        _stringBuilderHTML.Append("</td>");

                                //        _stringBuilderHTML.Append("<td width='5%' valign='top'>");
                                //        _stringBuilderHTML.Append("<span id='SpanRAPQuestionHelp_" + i.ToString() + "'  class='span_textunderline_cursor'  onclick=\"javascript:GetRAPQuesText(this);\" style='color: #0000FF'>Help</span>");
                                //        _stringBuilderHTML.Append("<textarea  style='display:none'>" + drFill["RAPQuestionHelpText"].ToString().Replace("\r\n\r\n", "<BR>") + "</textarea>");
                                //        _stringBuilderHTML.Append("</td>");

                                //        _stringBuilderHTML.Append("<td width='5%' valign='top'>");
                                //        string[] Values = drFill["RAPAllowedValues"].ToString().Split(',');// RAPAllowedValues.Split(',');

                                //        PlaceHolderControlRAPQuestions.Controls.Add(new LiteralControl(_stringBuilderHTML.ToString()));

                                //        string[] _parameterValues = new string[5];
                                //        _parameterValues[0] = "CustomHRMAssessmentRAPScores";
                                //        _parameterValues[1] = drFill["HRMAssessmentRAPQuestionId"].ToString();//Primarykeyvalue;
                                //        _parameterValues[2] = drFill["DocumentVersionId"].ToString();// "DocumentVersionId";
                                //        _parameterValues[3] = drFill["HRMRAPQuestionId"].ToString();// "HRMRAPQuestionId";
                                //        _parameterValues[4] = drFill["RAPAssessedValue"].ToString();// "SelectedValue";
                                //        CreateDropdownHTML(Values, i, Convert.ToInt32(drFill["HRMRAPQuestionId"].ToString()),_parameterValues);
                                //        _stringBuilderHTML.Remove(0, _stringBuilderHTML.Length);
                                //        _stringBuilderHTML.Append("</td>");
                                //        _stringBuilderHTML.Append("<td width='10px'></td>");
                                //        _stringBuilderHTML.Append("<td valign='middle'>");

                                //        _stringBuilderHTML.Append("<input class='cursor_default' type='checkbox' id='Checkbox_CustomHRMRAPQuestions_RAPAllowedValues" + drFill["HRMRAPQuestionId"] + "' name='Checkbox_CustomHRMRAPQuestions_RAPAllowedValues" + drFill["HRMRAPQuestionId"] + "'BindAutoSaveEvents= 'False' onclick=\"javascript:HRMNeedList('" + drFill["AssociatedHRMNeedId"].ToString() + "',this,'" + tabName + "','" + sectionName + "');\" />");
                                //        _stringBuilderHTML.Append("<label  for='Checkbox_CustomHRMRAPQuestions_RAPAllowedValues" + drFill["HRMRAPQuestionId"] + "' > Add to Needs List");
                                //        _stringBuilderHTML.Append("</label>");
                                //        _stringBuilderHTML.Append("</td>");
                                //        _stringBuilderHTML.Append("</tr>");
                                //        _stringBuilderHTML.Append("<tr class='height2'>");
                                //        _stringBuilderHTML.Append("<td>");
                                //        _stringBuilderHTML.Append("</td>");
                                //        _stringBuilderHTML.Append("</tr>");
                                //        PlaceHolderControlRAPQuestions.Controls.Add(new LiteralControl(_stringBuilderHTML.ToString()));
                                //        _stringBuilderHTML.Remove(0, _stringBuilderHTML.Length);
                                //        i++;

                                //    }
                                //}
                                #endregion

                                _stringBuilderHTML.Append("<tr id=Row_" + i.ToString() + " class='checkbox_container'>");
                                _stringBuilderHTML.Append("<td >");
                                _stringBuilderHTML.Append("<input parentchildcontrols='True' id='HiddenField_CustomHRMRAPQuestions_HRMRAPQuestionId_" + dr["HRMRAPQuestionId"] + "'  name='HiddenField_CustomHRMRAPQuestions_HRMRAPQuestionId_" + dr["HRMRAPQuestionId"] + "' type='hidden' />");
                                _stringBuilderHTML.Append("</td>");
                                _stringBuilderHTML.Append("<td width='3%' valign='top'>");
                                _stringBuilderHTML.Append("<span parentchildcontrols='True' class='form_label' id='SpanQuesNo" + i + "'>" + dr["RAPQuestionNumber"] + "</span>");
                                _stringBuilderHTML.Append("</td>");

                                _stringBuilderHTML.Append("<td width='65%' valign='top'>");
                                _stringBuilderHTML.Append("<span parentchildcontrols='True' class='form_label' id='SpanQuesText" + i + "'>" + dr["RAPQuestionText"] + "</span><span id=span_" + i + "><span>");
                                _stringBuilderHTML.Append("</td>");

                                _stringBuilderHTML.Append("<td width='5%' valign='top'>");
                                _stringBuilderHTML.Append("<span parentchildcontrols='True' id='SpanRAPQuestionHelp_" + i.ToString() + "'  class='span_textunderline_cursor'  onclick=\"javascript:GetRAPQuesText(this,'" + MessageBoxHeight + "','" + MessageBoxWidth + "');\" style='color: #0000FF'>Help</span>");
                                _stringBuilderHTML.Append("<textarea parentchildcontrols='True'  style='display:none'>" + dr["RAPQuestionHelpText"].ToString().Replace("\r\n\r\n", "<BR>") + "</textarea>");
                                _stringBuilderHTML.Append("</td>");

                                _stringBuilderHTML.Append("<td width='5%' valign='top'>");
                                string[] Values = dr["RAPAllowedValues"].ToString().Split(',');// RAPAllowedValues.Split(',');

                                PlaceHolderControlRAPQuestions.Controls.Add(new LiteralControl(_stringBuilderHTML.ToString()));

                                string[] _parameterValues = new string[5];
                                _parameterValues[0] = "CustomHRMAssessmentRAPScores";//Table name


                                //        _parameterValues[1] = drFill["HRMAssessmentRAPQuestionId"].ToString();//Primarykeyvalue;
                                //        _parameterValues[2] = drFill["DocumentVersionId"].ToString();// "DocumentVersionId";
                                //        _parameterValues[3] = drFill["HRMRAPQuestionId"].ToString();// "HRMRAPQuestionId";
                                //        _parameterValues[4] = drFill["RAPAssessedValue"].ToString();// "SelectedValue";
                                if (DataViewCustomHRMAssessmentRAPScores.Count > 0)
                                    _parameterValues[1] = DataViewCustomHRMAssessmentRAPScores[0]["HRMAssessmentRAPQuestionId"].ToString();//"";// "SelectedValue";
                                else
                                    _parameterValues[1] = "-" + Convert.ToInt32(dr["HRMRAPQuestionId"].ToString());// "HRMAssessmentRAPQuestionId";

                                _parameterValues[2] = setDocumentVersionId;// DocumentVersionId
                                _parameterValues[3] = dr["HRMRAPQuestionId"].ToString();
                                if (DataViewCustomHRMAssessmentRAPScores.Count > 0)
                                    _parameterValues[4] = DataViewCustomHRMAssessmentRAPScores[0]["RAPAssessedvalue"].ToString();//"";// "SelectedValue";
                                else
                                    _parameterValues[4] = "";


                                CreateDropdownHTML(Values, i, Convert.ToInt32(dr["HRMRAPQuestionId"].ToString()), _parameterValues);
                                _stringBuilderHTML.Remove(0, _stringBuilderHTML.Length);
                                _stringBuilderHTML.Append("</td>");
                                _stringBuilderHTML.Append("<td width='10px'></td>");
                                _stringBuilderHTML.Append("<td valign='middle'>");
                                if (DataViewCustomHRMAssessmentRAPScores.Count > 0)
                                {
                                    CheckBoxSelectedvalue = DataViewCustomHRMAssessmentRAPScores[0]["AddToNeedsList"].ToString();//"";// "CheckBoxSelectedValue";
                                }
                                if (CheckBoxSelectedvalue == "Y")
                                {
                                    _stringBuilderHTML.Append("<input parentchildcontrols='True' class='cursor_default' checked='true' type='checkbox' id='Checkbox_CustomHRMRAPQuestions_RAPAllowedValues" + dr["HRMRAPQuestionId"] + "' name='Checkbox_CustomHRMRAPQuestions_RAPAllowedValues" + dr["HRMRAPQuestionId"] + "'BindAutoSaveEvents= 'False' onchange=\"javascript:CustomHRMRapAddToNeedList('" + dr["AssociatedHRMNeedId"].ToString() + "',this,'" + tabName + "','" + sectionName + "','CustomHRMAssessmentRAPScores','HRMAssessmentRAPQuestionId','DocumentVersionId',+'" + _parameterValues[1] + "','" + _parameterValues[2] + "','HRMRAPQuestionId:AddToNeedsList','" + dr["HRMRAPQuestionId"].ToString() + "');\" />");
                                }
                                else
                                {
                                    _stringBuilderHTML.Append("<input parentchildcontrols='True' class='cursor_default' type='checkbox' id='Checkbox_CustomHRMRAPQuestions_RAPAllowedValues" + dr["HRMRAPQuestionId"] + "' name='Checkbox_CustomHRMRAPQuestions_RAPAllowedValues" + dr["HRMRAPQuestionId"] + "'BindAutoSaveEvents= 'False' onchange=\"javascript:CustomHRMRapAddToNeedList('" + dr["AssociatedHRMNeedId"].ToString() + "',this,'" + tabName + "','" + sectionName + "','CustomHRMAssessmentRAPScores','HRMAssessmentRAPQuestionId','DocumentVersionId',+'" + _parameterValues[1] + "','" + _parameterValues[2] + "','HRMRAPQuestionId:AddToNeedsList','" + dr["HRMRAPQuestionId"].ToString() + "');\" />");
                                }
                                CheckBoxSelectedvalue = string.Empty;
                                _stringBuilderHTML.Append("<label parentchildcontrols='True'  for='Checkbox_CustomHRMRAPQuestions_RAPAllowedValues" + dr["HRMRAPQuestionId"] + "' > Add to Needs List");
                                _stringBuilderHTML.Append("</label>");
                                _stringBuilderHTML.Append("</td>");
                                _stringBuilderHTML.Append("</tr>");
                                _stringBuilderHTML.Append("<tr class='height2'>");
                                _stringBuilderHTML.Append("<td>");
                                _stringBuilderHTML.Append("</td>");
                                _stringBuilderHTML.Append("</tr>");
                                PlaceHolderControlRAPQuestions.Controls.Add(new LiteralControl(_stringBuilderHTML.ToString()));
                                _stringBuilderHTML.Remove(0, _stringBuilderHTML.Length);
                                i++;
                            }


                            _stringBuilderHTML.Append("</table>");
                            PlaceHolderControlRAPQuestions.Controls.Add(new LiteralControl(_stringBuilderHTML.ToString()));

                        }
                    }

                }
            }

            catch (Exception ex)
            {
                throw (ex);
            }
            finally
            {

            }
        }


        /// <summary>
        /// To create dropdown dynamically.
        /// </summary>

        /// <param name="value"></param>
        //protected void CreateDropdownHTML(string tableName, string columnName, int value, int primrykeyVal, int selectedVal,int drugid,string drugname)
        protected void CreateDropdownHTML(Array values, int i, int questionNumber, string[] _parameterValues)
        {
            _dropdownListObject = new DropDownList();
            _dropdownListObject.ID = "DropDownList_" + "CustomHRMAssessmentRAPScores" + "_" + "RAPAssessedValue_" + questionNumber;
            _dropdownListObject.Style["width"] = "98%";
            _dropdownListObject.CssClass = "form_dropdown";
            _dropdownListObject.Attributes.Add("BindAutoSaveEvents", "False");
            _dropdownListObject.DataSource = values;
            _dropdownListObject.DataBind();
            _dropdownListObject.Items.Insert(0, new ListItem("", ""));
            // _dropdownListObject.Attributes["OnChange"] = "SetRAPScore('CustomHRMAssessmentRAPScores','HRMAssessmentRAPQuestionId','DocumentVersionId','-'+'" + questionNumber + "','-1','HRMRAPQuestionId:RAPAssessedValue','" + questionNumber + "','" + this._dropdownListObject.ID + "')";
            _dropdownListObject.Attributes["OnChange"] = "SetRAPScore('CustomHRMAssessmentRAPScores','HRMAssessmentRAPQuestionId','DocumentVersionId',+'" + _parameterValues[1] + "','" + _parameterValues[2] + "','HRMRAPQuestionId:RAPAssessedValue','" + questionNumber + "','" + this._dropdownListObject.ID + "')";
            _dropdownListObject.Attributes.Add("pKey", _parameterValues[1]);
            _dropdownListObject.SelectedValue = _parameterValues[4];
            PlaceHolderControlRAPQuestions.Controls.Add(_dropdownListObject);
        }
    }
}

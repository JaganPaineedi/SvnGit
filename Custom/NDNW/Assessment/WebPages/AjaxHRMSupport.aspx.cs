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
using System.Text;
using SHS.BaseLayer;
using System.Data.SqlClient;
using Microsoft.ApplicationBlocks.Data;
using SHS.DataServices;

public partial class ActivityPages_Client_Detail_Assessment_AjaxHRMSupport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string functionName = string.Empty;

        /// Get the function name from Query string parameter, that function name is used to create Support sections 
        /// and return the appropriate XML result.
        /// Author: Jitender Kumar Kamboj
        /// Created On: 10-May-2010

        functionName = Request.QueryString["FunctionName"].ToString();

        int indexSupport = 0;
        string getSupport = string.Empty;
        StringBuilder _stringBuilderHTML = null;
        indexSupport = Convert.ToInt32(Request.Form["Support"]);

        switch (functionName)
        {
            case "GetSupport":

                #region private variable

                int primaryKey = -1;
                string supportDescription = string.Empty;
                string current = string.Empty;
                string paidSupport = string.Empty;
                string unpaidSupport = string.Empty;
                string clinicallyRecommended = string.Empty;
                string customerDesired = string.Empty;
                _stringBuilderHTML = new StringBuilder();

                #endregion

                try
                {
                    using (DataSet dataSetsupport = BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet)
                    {
                        //Perform table contain check
                        if (dataSetsupport != null && dataSetsupport.Tables.Contains("CustomHRMAssessmentSupports2"))
                        {
                            //Perform table contain check
                            //modified by shifali on 28Feb,2011 ref task# 867(streamline Testing)
                            DataRow[] datarowSupportArray = dataSetsupport.Tables["CustomHRMAssessmentSupports2"].Select("ISNULL(RecordDeleted,'N')<>'Y'");

                            if (datarowSupportArray.Length > 0)
                            {
                                int i = 0;
                                int index = 1;
                                foreach (DataRow dataRowSupport in datarowSupportArray)
                                {
                                    supportDescription = string.Empty;
                                    current = string.Empty;
                                    paidSupport = string.Empty;
                                    unpaidSupport = string.Empty;
                                    clinicallyRecommended = string.Empty;
                                    customerDesired = string.Empty;

                                    if (!string.IsNullOrEmpty(dataRowSupport[2].ToString()))
                                    {
                                        supportDescription = Convert.ToString(dataRowSupport[2]);
                                    }
                                    if (!string.IsNullOrEmpty(dataRowSupport[3].ToString()))
                                    {
                                        current = dataRowSupport[3].ToString();
                                    }
                                    if (!string.IsNullOrEmpty(dataRowSupport[4].ToString()))
                                    {
                                        paidSupport = dataRowSupport[4].ToString();
                                    }
                                    if (!string.IsNullOrEmpty(dataRowSupport[5].ToString()))
                                    {
                                        unpaidSupport = dataRowSupport[5].ToString();
                                    }
                                    if (!string.IsNullOrEmpty(dataRowSupport[6].ToString()))
                                    {
                                        clinicallyRecommended = dataRowSupport[6].ToString();
                                    }
                                    if (!string.IsNullOrEmpty(dataRowSupport[7].ToString()))
                                    {
                                        customerDesired = dataRowSupport[7].ToString();
                                    }
                                    // primaryKey = Convert.ToInt32(dataRowSupport[1].ToString());
                                    int.TryParse(dataRowSupport[0].ToString(), out primaryKey);

                                    _stringBuilderHTML.Append("<table id='table_" + i + "' border='0' cellpadding='0' cellspacing='0' width='97%' supportDeleteAtt=" + index + " >");
                                    _stringBuilderHTML.Append("<tr>");
                                    _stringBuilderHTML.Append("<td style='width:5%' align='center'>");
                                    _stringBuilderHTML.Append("<img class='cursor_default' style='vertical-align: top' id='DeleteSupport' src='");
                                    _stringBuilderHTML.Append(WebsiteSettings.BaseUrl);
                                    _stringBuilderHTML.Append("App_Themes/Includes/Images/deleteIcon.gif' alt='' onclick=\"javascript:deleteSupport(" + index + ",'CustomHRMAssessmentSupports2','RecordDeleted','HRMAssessmentSupportId'," + primaryKey + ",'Y');\" />");
                                    _stringBuilderHTML.Append("</td>");

                                    _stringBuilderHTML.Append("<td style=width:95%'>");
                                    _stringBuilderHTML.Append("<table border='0' cellpadding='0' cellspacing='0' width='97%' supportAtt='common'>");
                                    _stringBuilderHTML.Append("<tr>");
                                    _stringBuilderHTML.Append("<td valign='top'>");
                                    _stringBuilderHTML.Append("<table border='0' cellpadding='0' cellspacing='0' width='100%'>");
                                    _stringBuilderHTML.Append("<tr>");
                                    _stringBuilderHTML.Append("<td class='height2'>");
                                    _stringBuilderHTML.Append("</td>");
                                    _stringBuilderHTML.Append("</tr>");

                                    _stringBuilderHTML.Append("<tr>");
                                    _stringBuilderHTML.Append("<td>");
                                    _stringBuilderHTML.Append("<table width='100%' border='0' cellspacing='0' cellpadding='0'>");
                                    _stringBuilderHTML.Append("<tr>");
                                    _stringBuilderHTML.Append("<td class='content_tab_left' align='left' width='25%'>");

                                    _stringBuilderHTML.Append("<span id='SupportText" + index + "'>");
                                    _stringBuilderHTML.Append("Support" + " " + index);
                                    _stringBuilderHTML.Append("</span>");

                                    _stringBuilderHTML.Append("</td>");
                                    _stringBuilderHTML.Append("<td width='17'>");
                                    _stringBuilderHTML.Append("<img style='vertical-align: top' src='");
                                    _stringBuilderHTML.Append(WebsiteSettings.BaseUrl);
                                    _stringBuilderHTML.Append("App_Themes/Includes/Images/content_tab_sep.gif' width='17' height='26' alt='' />");
                                    _stringBuilderHTML.Append("</td>");
                                    _stringBuilderHTML.Append("<td class='content_tab_top' width='100%'>");
                                    _stringBuilderHTML.Append("</td>");
                                    _stringBuilderHTML.Append("<td width='7'>");
                                    _stringBuilderHTML.Append("<img style='vertical-align: top' src='");
                                    _stringBuilderHTML.Append(WebsiteSettings.BaseUrl);
                                    _stringBuilderHTML.Append("App_Themes/Includes/Images/content_tab_right.gif' width='7' height='26' alt='' />");
                                    _stringBuilderHTML.Append("</td>");
                                    _stringBuilderHTML.Append("</tr>");
                                    _stringBuilderHTML.Append("</table>");
                                    _stringBuilderHTML.Append("</td>");
                                    _stringBuilderHTML.Append("</tr>");
                                    _stringBuilderHTML.Append("<tr>");
                                    _stringBuilderHTML.Append("<td class='content_tab_bg'>");

                                    _stringBuilderHTML.Append("<table cellspacing='0' cellpadding='0' border='0' width='100%'>");
                                    _stringBuilderHTML.Append("<tr>");
                                    _stringBuilderHTML.Append("<td style='width:50%' class='LPadd8'>");
                                    _stringBuilderHTML.Append("<span class=\"form_label_dfa\">");
                                    _stringBuilderHTML.Append("Describe the specific assistance, support, or community activity. If known, indicate the current or recommended person or organization to provide this support and how often.");
                                    _stringBuilderHTML.Append("</span><span id='CustomHRMAssessmentSupports2_HRMAssessmentSupportId_" + i + "' rowId='table_" + i + "' pkey='" + primaryKey + "'></span>");
                                    _stringBuilderHTML.Append("</td>");
                                    _stringBuilderHTML.Append("<td>");
                                    _stringBuilderHTML.Append("</td>");
                                    _stringBuilderHTML.Append("<td>");
                                    _stringBuilderHTML.Append("</td>");
                                    _stringBuilderHTML.Append("</tr>");

                                    _stringBuilderHTML.Append("<tr>");
                                    _stringBuilderHTML.Append("<td class='height2'>");
                                    _stringBuilderHTML.Append("</td>");
                                    _stringBuilderHTML.Append("</tr>");

                                    _stringBuilderHTML.Append("<tr class='checkbox_container'>");
                                    _stringBuilderHTML.Append("<td class='LPadd8' rowspan='3'>");
                                    _stringBuilderHTML.Append(GetHTMLForMultilineTextBox("CustomHRMAssessmentSupports2", "SupportDescription" + "_" + index, primaryKey, supportDescription));
                                    _stringBuilderHTML.Append("</td>");
                                    _stringBuilderHTML.Append("<td>");
                                    _stringBuilderHTML.Append(GetHTMLForRadioButton("CustomHRMAssessmentSupports2", "Current" + "_" + index, "Y", "Current", primaryKey, current, index));
                                    _stringBuilderHTML.Append("</td>");
                                    _stringBuilderHTML.Append("<td>");
                                    _stringBuilderHTML.Append(GetHTMLForRadioButton("CustomHRMAssessmentSupports2", "Current" + "_" + index, "N", "Not Current", primaryKey, current, index));
                                    _stringBuilderHTML.Append("</td>");
                                    _stringBuilderHTML.Append("</tr>");

                                    _stringBuilderHTML.Append("<tr>");
                                    _stringBuilderHTML.Append("<td>");
                                    _stringBuilderHTML.Append(GetHTMLForCheckBox("CustomHRMAssessmentSupports2", "PaidSupport" + "_" + index, "Paid Support", primaryKey, paidSupport));
                                    _stringBuilderHTML.Append("</td>");

                                    _stringBuilderHTML.Append("<td>");
                                    _stringBuilderHTML.Append(GetHTMLForCheckBox("CustomHRMAssessmentSupports2", "ClinicallyRecommended" + "_" + index, "Clinically Recommended", primaryKey, clinicallyRecommended));
                                    _stringBuilderHTML.Append("</td>");
                                    _stringBuilderHTML.Append("</tr>");

                                    _stringBuilderHTML.Append("<tr>");
                                    _stringBuilderHTML.Append("<td>");
                                    _stringBuilderHTML.Append(GetHTMLForCheckBox("CustomHRMAssessmentSupports2", "UnpaidSupport" + "_" + index, "Unpaid Support", primaryKey, unpaidSupport));
                                    _stringBuilderHTML.Append("</td>");

                                    _stringBuilderHTML.Append("<td>");
                                    _stringBuilderHTML.Append(GetHTMLForCheckBox("CustomHRMAssessmentSupports2", "CustomerDesired" + "_" + index, "Customer Desired", primaryKey, customerDesired));
                                    _stringBuilderHTML.Append("</td>");
                                    _stringBuilderHTML.Append("</tr>");
                                    _stringBuilderHTML.Append("</table>");

                                    _stringBuilderHTML.Append("</td>");
                                    _stringBuilderHTML.Append("</tr>");
                                    _stringBuilderHTML.Append("<tr>");
                                    _stringBuilderHTML.Append("<td>");
                                    _stringBuilderHTML.Append("<table cellspacing='0' cellpadding='0' border='0' width='100%'>");
                                    _stringBuilderHTML.Append("<tr>");
                                    _stringBuilderHTML.Append("<td width='2' class='right_bottom_cont_bottom_bg'>");
                                    _stringBuilderHTML.Append("<img height='7' alt='' src='");
                                    _stringBuilderHTML.Append(WebsiteSettings.BaseUrl);
                                    _stringBuilderHTML.Append("App_Themes/Includes/Images/right_bottom_cont_bottom_left.gif' style='vertical-align: top;' />");
                                    _stringBuilderHTML.Append("</td>");
                                    _stringBuilderHTML.Append("<td width='100%' class='right_bottom_cont_bottom_bg'>");
                                    _stringBuilderHTML.Append("</td>");
                                    _stringBuilderHTML.Append("<td align='right' width='2' class='right_bottom_cont_bottom_bg'>");
                                    _stringBuilderHTML.Append("<img height='7' alt='' src='");
                                    _stringBuilderHTML.Append(WebsiteSettings.BaseUrl);
                                    _stringBuilderHTML.Append("App_Themes/Includes/Images/right_bottom_cont_bottom_right.gif' style='vertical-align: top;' />");
                                    _stringBuilderHTML.Append("</td>");
                                    _stringBuilderHTML.Append("</tr>");
                                    _stringBuilderHTML.Append("</table>");
                                    _stringBuilderHTML.Append("</td>");
                                    _stringBuilderHTML.Append("</tr>");
                                    _stringBuilderHTML.Append("</table>");
                                    _stringBuilderHTML.Append("</td>");

                                    _stringBuilderHTML.Append("</tr>");
                                    _stringBuilderHTML.Append("</table>");

                                    _stringBuilderHTML.Append("</td>");
                                    _stringBuilderHTML.Append("</tr>");
                                    _stringBuilderHTML.Append("</table>");

                                    i++;
                                    index++;


                                }

                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    throw ex;
                }
                getSupport = _stringBuilderHTML.ToString();
                Response.Write(getSupport);
                Response.End();
                break;

            case "GetSupportSection":
                //By Sonia ref ticket 867
                //primaryKey = -1 - indexSupport;
                primaryKey = indexSupport;

                _stringBuilderHTML = new StringBuilder();
                _stringBuilderHTML.Append("<table border='0' cellpadding='0' cellspacing='0' width='97%' supportDeleteAtt=" + indexSupport + " >");
                _stringBuilderHTML.Append("<tr>");
                _stringBuilderHTML.Append("<td style='width:5%' align='center'>");
                _stringBuilderHTML.Append("<img class='cursor_default' style='vertical-align: top' id='DeleteSupport' src='");
                _stringBuilderHTML.Append(WebsiteSettings.BaseUrl);
                _stringBuilderHTML.Append("App_Themes/Includes/Images/deleteIcon.gif' alt='' onclick=\"javascript:deleteSupport(" + indexSupport + ",'CustomHRMAssessmentSupports2','RecordDeleted','HRMAssessmentSupportId'," + primaryKey + ",'Y');\" ");
                _stringBuilderHTML.Append("</td>");

                _stringBuilderHTML.Append("<td style='width:95%'>");
                _stringBuilderHTML.Append("<table border='0' cellpadding='0' cellspacing='0' width='97%' supportAtt='common'>");
                _stringBuilderHTML.Append("<tr>");
                _stringBuilderHTML.Append("<td valign='top'>");
                _stringBuilderHTML.Append("<table border='0' cellpadding='0' cellspacing='0' width='100%'>");
                _stringBuilderHTML.Append("<tr>");
                _stringBuilderHTML.Append("<td class='height2'>");
                _stringBuilderHTML.Append("</td>");
                _stringBuilderHTML.Append("</tr>");

                _stringBuilderHTML.Append("<tr>");
                _stringBuilderHTML.Append("<td>");
                _stringBuilderHTML.Append("<table width='100%' border='0' cellspacing='0' cellpadding='0'>");
                _stringBuilderHTML.Append("<tr>");
                _stringBuilderHTML.Append("<td class='content_tab_left' align='left' width='25%'>");
                _stringBuilderHTML.Append("<span id='SupportText" + indexSupport + "'>");
                _stringBuilderHTML.Append("Support" + " " + indexSupport);
                _stringBuilderHTML.Append("</span>");

                _stringBuilderHTML.Append("</td>");
                _stringBuilderHTML.Append("<td width='17'>");
                _stringBuilderHTML.Append("<img style='vertical-align: top' src='");
                _stringBuilderHTML.Append(WebsiteSettings.BaseUrl);
                _stringBuilderHTML.Append("App_Themes/Includes/Images/content_tab_sep.gif' width='17' height='26' alt='' />");
                _stringBuilderHTML.Append("</td>");
                _stringBuilderHTML.Append("<td class='content_tab_top' width='100%'>");
                _stringBuilderHTML.Append("</td>");
                _stringBuilderHTML.Append("<td width='7'>");
                _stringBuilderHTML.Append("<img style='vertical-align: top' src='");
                _stringBuilderHTML.Append(WebsiteSettings.BaseUrl);
                _stringBuilderHTML.Append("App_Themes/Includes/Images/content_tab_right.gif' width='7' height='26' alt='' />");
                _stringBuilderHTML.Append("</td>");
                _stringBuilderHTML.Append("</tr>");
                _stringBuilderHTML.Append("</table>");
                _stringBuilderHTML.Append("</td>");
                _stringBuilderHTML.Append("</tr>");
                _stringBuilderHTML.Append("<tr>");
                _stringBuilderHTML.Append("<td class='content_tab_bg'>");

                _stringBuilderHTML.Append("<table cellspacing='0' cellpadding='0' border='0' width='100%'>");
                _stringBuilderHTML.Append("<tr>");
                _stringBuilderHTML.Append("<td style='width:50%' class='LPadd8'>");
                _stringBuilderHTML.Append("<span class=\"form_label_dfa\">");
                _stringBuilderHTML.Append("Describe the specific assistance, support, or community activity. If known, indicate the current or recommended person or organization to provide this support and how often.");
                _stringBuilderHTML.Append("</span>");
                _stringBuilderHTML.Append("</td>");
                _stringBuilderHTML.Append("<td>");
                _stringBuilderHTML.Append("</td>");
                _stringBuilderHTML.Append("<td>");
                _stringBuilderHTML.Append("</td>");
                _stringBuilderHTML.Append("</tr>");

                _stringBuilderHTML.Append("<tr>");
                _stringBuilderHTML.Append("<td class='height2'>");
                _stringBuilderHTML.Append("</td>");
                _stringBuilderHTML.Append("</tr>");

                _stringBuilderHTML.Append("<tr class='checkbox_container'>");
                _stringBuilderHTML.Append("<td class='LPadd8' rowspan='3'>");
                _stringBuilderHTML.Append(GetHTMLForMultilineTextBox("CustomHRMAssessmentSupports2", "SupportDescription" + "_" + indexSupport, primaryKey, ""));
                _stringBuilderHTML.Append("</td>");
                _stringBuilderHTML.Append("<td>");
                _stringBuilderHTML.Append(GetHTMLForRadioButton("CustomHRMAssessmentSupports2", "Current" + "_" + indexSupport, "Y", "Current", primaryKey, "", indexSupport));
                _stringBuilderHTML.Append("</td>");
                _stringBuilderHTML.Append("<td>");
                _stringBuilderHTML.Append(GetHTMLForRadioButton("CustomHRMAssessmentSupports2", "Current" + "_" + indexSupport, "N", "Not Current", primaryKey, "", indexSupport));
                _stringBuilderHTML.Append("</td>");

                _stringBuilderHTML.Append("</tr>");

                _stringBuilderHTML.Append("<tr>");
                _stringBuilderHTML.Append("<td>");
                _stringBuilderHTML.Append(GetHTMLForCheckBox("CustomHRMAssessmentSupports2", "PaidSupport" + "_" + indexSupport, "Paid Support", primaryKey, ""));
                _stringBuilderHTML.Append("</td>");

                _stringBuilderHTML.Append("<td>");
                _stringBuilderHTML.Append(GetHTMLForCheckBox("CustomHRMAssessmentSupports2", "ClinicallyRecommended" + "_" + indexSupport, "Clinically Recommended", primaryKey, ""));
                _stringBuilderHTML.Append("</td>");
                _stringBuilderHTML.Append("</tr>");

                _stringBuilderHTML.Append("<tr>");
                _stringBuilderHTML.Append("<td>");
                _stringBuilderHTML.Append(GetHTMLForCheckBox("CustomHRMAssessmentSupports2", "UnpaidSupport" + "_" + indexSupport, "Unpaid Support", primaryKey, ""));
                _stringBuilderHTML.Append("</td>");

                _stringBuilderHTML.Append("<td>");
                _stringBuilderHTML.Append(GetHTMLForCheckBox("CustomHRMAssessmentSupports2", "CustomerDesired" + "_" + indexSupport, "Customer Desired", primaryKey, ""));
                _stringBuilderHTML.Append("</td>");

                _stringBuilderHTML.Append("</tr>");
                _stringBuilderHTML.Append("</table>");

                _stringBuilderHTML.Append("</td>");
                _stringBuilderHTML.Append("</tr>");
                _stringBuilderHTML.Append("<tr>");
                _stringBuilderHTML.Append("<td>");
                _stringBuilderHTML.Append("<table cellspacing='0' cellpadding='0' border='0' width='100%'>");
                _stringBuilderHTML.Append("<tr>");
                _stringBuilderHTML.Append("<td width='2' class='right_bottom_cont_bottom_bg'>");
                _stringBuilderHTML.Append("<img height='7' alt='' src='");
                _stringBuilderHTML.Append(WebsiteSettings.BaseUrl);
                _stringBuilderHTML.Append("App_Themes/Includes/Images/right_bottom_cont_bottom_left.gif' style='vertical-align: top;' />");
                _stringBuilderHTML.Append("</td>");
                _stringBuilderHTML.Append("<td width='100%' class='right_bottom_cont_bottom_bg'>");
                _stringBuilderHTML.Append("</td>");
                _stringBuilderHTML.Append("<td align='right' width='2' class='right_bottom_cont_bottom_bg'>");
                _stringBuilderHTML.Append("<img height='7' alt='' src='");
                _stringBuilderHTML.Append(WebsiteSettings.BaseUrl);
                _stringBuilderHTML.Append("App_Themes/Includes/Images/right_bottom_cont_bottom_right.gif' style='vertical-align: top;' />");
                _stringBuilderHTML.Append("</td>");
                _stringBuilderHTML.Append("</tr>");
                _stringBuilderHTML.Append("</table>");
                _stringBuilderHTML.Append("</td>");
                _stringBuilderHTML.Append("</tr>");
                _stringBuilderHTML.Append("</table>");
                _stringBuilderHTML.Append("</td>");

                _stringBuilderHTML.Append("</tr>");
                _stringBuilderHTML.Append("</table>");

                _stringBuilderHTML.Append("</td>");

                _stringBuilderHTML.Append("</tr>");
                _stringBuilderHTML.Append("</table>");

                getSupport = _stringBuilderHTML.ToString();
                Response.Write(getSupport);
                Response.End();

                break;
            case "SafetyCrisisPlanReviewFilter":
                string strFilter = string.Empty;
                string strTodayDate = string.Empty;
                string mode = Request.QueryString["FilterMonth"].ToString();
                if (mode == "3months")
                    strTodayDate = System.DateTime.Now.AddMonths(-3).ToString("MM/dd/yyyy");
                else if (mode == "12months")
                    strTodayDate = System.DateTime.Now.AddMonths(-12).ToString("MM/dd/yyyy");

                if (strTodayDate.Trim() != string.Empty)
                    strFilter = strTodayDate.Trim();
                Response.Clear();
                Response.Write(strFilter);
                Response.End();
                break;

            case "GetASAM":
                string FinalDeterminationComments = string.Empty;
                SqlParameter[] _objectSqlParmeters = null;
                _objectSqlParmeters = new SqlParameter[1];
                _objectSqlParmeters[0] = new SqlParameter("@ClientId", BaseCommonFunctions.ApplicationInfo.Client.ClientId);
                DataSet dsASAM = new DataSet();
                SqlHelper.FillDataset(Connection.ConnectionString, CommandType.StoredProcedure, "CSP_GetASAMFinalDetermination", dsASAM, new string[] { "ASAM" }, _objectSqlParmeters);
                if (dsASAM.Tables.Count > 0)
                {
                    if (dsASAM.Tables["ASAM"].Rows.Count > 0)
                        FinalDeterminationComments = dsASAM.Tables["ASAM"].Rows[0]["FinalDeterminationComments"].ToString();
                }
                Response.Clear();
                Response.Write(FinalDeterminationComments);
                Response.End();
                break;

            default:
                break;
        }


        //PlaceHolderControlSupport.Controls.Add(new LiteralControl(_stringBuilderHTML.ToString()));
    }

    /// <summary>
    /// Method For getting HTML for MultilineTextbox or TextArea
    /// </summary>
    /// Created By Jitender Kumar Kamboj
    /// Created On: 10-May-2010
    private string GetHTMLForMultilineTextBox(string tableName, string columnName, int primaryKeyValue, string value)
    {
        string TextBoxMulilineHTML = string.Empty;
        try
        {
            TextBoxMulilineHTML = "<textarea class='form_textareaWithoutWidth' rows='5' datatype='String' spellcheck='True' cols='65' ";
            TextBoxMulilineHTML = TextBoxMulilineHTML + " id='TextArea_" + tableName + "_" + columnName + "' ";
            TextBoxMulilineHTML = TextBoxMulilineHTML + " name='TextArea_" + tableName + "_" + columnName + "' BindAutoSaveEvents='False' onchange=\"javascript:SetSupportValues('" + tableName + "','SupportDescription','HRMAssessmentSupportId', '" + primaryKeyValue + "' , this.value,'');\"  > ";
            TextBoxMulilineHTML = TextBoxMulilineHTML + "" + value + "</textarea>";
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return TextBoxMulilineHTML;
    }

    /// <summary>
    /// Method For getting HTML for Radio button
    /// </summary>
    /// Created By Jitender Kumar Kamboj
    /// Created On: 10-May-2010
    private string GetHTMLForRadioButton(string tableName, string columnName, string value, string textValue, int primaryKeyValue, string check, int index)
    {
        string RadioButtonHTML = "";
        try
        {
            RadioButtonHTML = "<input type ='radio' id='RadioButton_" + tableName + "_" + columnName + "_" + value + "' ";
            RadioButtonHTML = RadioButtonHTML + " name='RadioButton_" + tableName + "_" + columnName + "' ";

            string colName = columnName.Substring(0, columnName.IndexOf("_"));

            if (check == "Y" && textValue == "Current")
            {
                RadioButtonHTML += "checked='checked'";
            }
            else if (check == "N")
            {
                RadioButtonHTML += "checked='checked'";
            }

            RadioButtonHTML = RadioButtonHTML + " Value= '" + value + "' BindAutoSaveEvents='False' onClick=\"javascript:SetSupportValues('" + tableName + "','Current','HRMAssessmentSupportId', '" + primaryKeyValue + "' , this.value,'" + index + "','R');\" />";
            RadioButtonHTML = RadioButtonHTML + "<label for='RadioButton_" + tableName + "_" + columnName + "_" + value + "' >" + textValue + "</label>";
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return RadioButtonHTML;
    }

    /// <summary>
    /// Method For getting HTML for Check Box
    /// </summary>
    /// Created By Jitender Kumar Kamboj
    /// Created On: 10-May-2010 
    private string GetHTMLForCheckBox(string tableName, string columnName, string TextValue, int primaryKeyValue, string check)
    {
        StringBuilder checkBoxHTML = new StringBuilder();
        string colName = columnName.Substring(0, columnName.IndexOf("_"));
        if (check == null || check == "")
        {
            check = "N";
        }
        checkBoxHTML.Append("<table cellpadding='2' cellspacing='0' border='0' ><tr  class='checkbox_container'><td>");
        checkBoxHTML.Append("<input type ='checkbox'  id='CheckBox_" + tableName + "_" + columnName + "_" + check + "' ");
        if (check == "Y")
        {
            checkBoxHTML.Append("checked='checked'");
        }

        checkBoxHTML.Append(" name= 'CheckBox_" + tableName + "_" + columnName + "' BindAutoSaveEvents='False' onchange=\"javascript:SetSupportValues('" + tableName + "','" + colName + "','HRMAssessmentSupportId', '" + primaryKeyValue + "' , this,'');\" />");
        checkBoxHTML.Append("</td><td>");
        checkBoxHTML.Append("<label for='");
        checkBoxHTML.Append("CheckBox_" + tableName + "_" + columnName + "_" + check + "' ");
        checkBoxHTML.Append(">" + TextValue + "</label>");
        checkBoxHTML.Append("</td></tr></table>");
        return checkBoxHTML.ToString();
    }
}

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


namespace SHS.SmartCare
{
public partial class ActivityPages_Client_Detail_Assessment_UCHRMCurrentSubstanceUse : SHS.BaseLayer.ActivityPages.DataActivityTab
{
    public string TableNameCustomSUDrugs { get; set; }
    private const string _DropDownType = "DropDown";
    private const int _GlobalCodeDropDownFrequency = 0;
    private const int _GlobalCodeDropDownDrugs = 0;
    DropDownList _dropdownListObject = null;
    string _itemDropdownType = string.Empty;
    private string _TableName = string.Empty;
    private string _itemColumnName = string.Empty;
    string _itemGlobalCategoryFrequency = "SUFREQUENCY";
    string _itemGlobalCategoryRoute = "SUROUTE ";



    string _itemSharedTableName = string.Empty;
    string _itemStoreProcedureName = string.Empty;
    string _itemValueField = string.Empty;
    string _itemTextField = string.Empty;
    int _selectedFrequency = 0;
    int _selectedRoute = 0;

    string valPresc = string.Empty;
    string _familyHistory = string.Empty;

    SHS.BaseLayer.SharedTables _objectSharedTable = null;


    protected void Page_Load(object sender, EventArgs e)
    {

    }
    public void Activate()
    {
        CreateSUHistoryControls();
    }

    private void CreateSUHistoryControls()
    {
        StringBuilder _stringBuilderHTML = null;
        //try catch finally block commented by shifali in ref to task# 950 on 5 june,2010
        //try
        //{
        _objectSharedTable = Application["SharedTables"] as SHS.BaseLayer.SharedTables;

        DataSet currentDataset = BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet;
        #region HTML

        if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.CustomSUDrugs != null)
        {
            _stringBuilderHTML = new StringBuilder();
            DataSet dsDrugs = new DataSet();
            dsDrugs.Tables.Add(SHS.BaseLayer.SharedTables.ApplicationSharedTables.CustomSUDrugs.Copy());

            if (dsDrugs != null)
            {
                if (dsDrugs.Tables.Count > 0)
                {
                    _TableName = (dsDrugs.Tables[0].TableName.ToString());
                    _itemColumnName = "Frequency";

                    if (dsDrugs.Tables.Contains("CustomSUDrugs") == true)
                    {
                        _stringBuilderHTML = new StringBuilder();

                        _stringBuilderHTML.Append("<div id='mdiv' style='width: 100%; overflow-x: hidden; overflow-y: hidden;' >");
                        _stringBuilderHTML.Append("<table width='100%' cellpadding='0'  cellspacing='0'  border='0'>");
                        _stringBuilderHTML.Append("<tr> <th class='form_label'></th>");
                        _stringBuilderHTML.Append("<th class='form_label'></th>");
                        _stringBuilderHTML.Append("<th class='form_label'></th>");
                        _stringBuilderHTML.Append("<th class='form_label'>Substance</th>");
                        //----
                        _stringBuilderHTML.Append("<th class='form_label' style='width:15%;' ></th>");

                        //--
                        _stringBuilderHTML.Append("<th align='left' class='form_label'> Age of First Use </th>");
                        // _stringBuilderHTML.Append("<th align='left' class='form_label' style='cursor: pointer; text-decoration: underline;color:Green;font-size:12px;font-weight:bold; width:18%'> <span  onclick='ShowFrequencyDiv()'>Frequency</span> </th>");
                        _stringBuilderHTML.Append("<th align='left' class='form_label' style='width:18%'> Frequency  </th>");
                        _stringBuilderHTML.Append("<th align='left' class='form_label' style='width:18%;'> Route  </th>");
                        _stringBuilderHTML.Append(" <th  align='center' class='form_label' style='width:23%;'> Date Last Used </th>");
                        _stringBuilderHTML.Append("<th  align='left'  class='form_label' style='width:10px;'> Initially Prescription </th>");
                        _stringBuilderHTML.Append("<th   align='left' class='form_label' style='width:20px;'> Preference(Primary=1, Secondary=2, etc) </th>");
                        _stringBuilderHTML.Append("</tr>");
                        _stringBuilderHTML.Append("<tr><td class='height5'></td></tr>");
                        int i = 0;
                        foreach (DataRow dr in dsDrugs.Tables["CustomSUDrugs"].Rows)
                        {
                            int primaryKey = -1;


                            DataRow[] drAssementHistory = null;

                            DataTable datatableAssementHistory = BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomSubstanceUseHistory2"];
                            // DataTable datatableAssementHistory = BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomSubstanceUseHistory2"].DefaultView.ToTable(true, "SUDrugId");
                            //drAssementHistory = datatableAssementHistory.Select("SUDrugId=" + dr.ItemArray[0].ToString());
                            drAssementHistory = datatableAssementHistory.Select("SUDrugId=" + dr.ItemArray[0].ToString());

                            //Html with values To Do..........need to do refactoring
                            if (drAssementHistory.Length > 0)
                            {
                                _selectedFrequency = 0;
                                _selectedRoute = 0;
                                if (!string.IsNullOrEmpty(drAssementHistory[0].ItemArray[4].ToString()))
                                {
                                    _selectedFrequency = (int)drAssementHistory[0].ItemArray[4];
                                }
                                if (!string.IsNullOrEmpty(drAssementHistory[0].ItemArray[5].ToString()))
                                {
                                    _selectedRoute = (int)drAssementHistory[0].ItemArray[5];
                                }
                                primaryKey = (int)drAssementHistory[0].ItemArray[0];
                                string formarDate = string.Empty;

                                if (!string.IsNullOrEmpty(drAssementHistory[0].ItemArray[7].ToString()))
                                {
                                    valPresc = drAssementHistory[0].ItemArray[7].ToString();
                                }
                                //added By priya
                                else
                                {
                                    valPresc = "";
                                }
                                //end
                                if (!string.IsNullOrEmpty(drAssementHistory[0].ItemArray[6].ToString()))
                                {
                                    //DateTime valDate = (DateTime)(drAssementHistory[0].ItemArray[6]);
                                    //DateTime valDate = Convert.ToDateTime(drAssementHistory[0].ItemArray[6]);
                                    formarDate = drAssementHistory[0].ItemArray[6].ToString();
                                }
                                if (!string.IsNullOrEmpty(drAssementHistory[0].ItemArray[9].ToString()))
                                {

                                    _familyHistory = drAssementHistory[0].ItemArray[9].ToString();
                                   // _familyHistory = _familyHistory.ToString().Replace("\n", " ");


                                }

                                //CreateHTMLWithValues();

                                _stringBuilderHTML.Append(" <tr id='row_" + i + "'>");
                                _stringBuilderHTML.Append("<td class='LPadd5'></td>");

                                //------------icon
                                _stringBuilderHTML.Append(" <td>");
                                _stringBuilderHTML.Append("<img style='cursor: default ;' id='' src='");
                                _stringBuilderHTML.Append(WebsiteSettings.BaseUrl);
                                _stringBuilderHTML.Append("App_Themes/Includes/Images/info.png' title='" + dr.ItemArray[4].ToString() + " ' /><span id='CustomSubstanceUseHistory2_SubstanceUseHistoryId_" + i + "' pKey='" + primaryKey + "' rowId='row_" + i + "'></span>");
                                _stringBuilderHTML.Append(" </td>");
                                //------------ Added If Else condition by Jitender Kumar Kamboj on Dec 12, 2010 in ref task # 782(Streamline Testing project)
                                _stringBuilderHTML.Append(" <td align='left' class='LPadd5' >");
                                if ((drAssementHistory[0]["FamilyHistory"].ToString().Trim() != "") && (drAssementHistory[0]["AgeOfFirstUse"].ToString().Trim() == "") && (drAssementHistory[0]["Frequency"].ToString().Trim() == "") && (drAssementHistory[0]["Route"].ToString().Trim() == "") && (drAssementHistory[0]["LastUsed"].ToString().Trim() == "") && (drAssementHistory[0]["InitiallyPrescribed"].ToString().Trim() == "" || drAssementHistory[0]["InitiallyPrescribed"].ToString().Trim() == "N") && (drAssementHistory[0]["Preference"].ToString().Trim() == "") && (drAssementHistory[0]["RecordDeleted"].ToString().Trim() != "N"))
                                {
                                    _stringBuilderHTML.Append("<input type='checkbox' ParentChildControls='True' class='cursor_default' BindAutoSaveEvents='False' id='CheckBox_CustomSubstanceUseHistory2_SUDrugId_" + dr.ItemArray[0] + "'   value='" + dr.ItemArray[0] + "'  onclick=\"javascript:SetValuesforRecordDeleted('CustomSubstanceUseHistory2','RecordDeleted','SubstanceUseHistoryId'," + primaryKey + ",this," + dr.ItemArray[0] + " ,'unescape(" + dr.ItemArray[1].ToString().EncodeForJs() + ")" + "');\" />");
                                }
                                else if ((drAssementHistory[0]["FamilyHistory"].ToString().Trim() != "") && (drAssementHistory[0]["AgeOfFirstUse"].ToString().Trim() == "") && (drAssementHistory[0]["Frequency"].ToString().Trim() == "") && (drAssementHistory[0]["Route"].ToString().Trim() == "") && (drAssementHistory[0]["LastUsed"].ToString().Trim() == "") && (drAssementHistory[0]["InitiallyPrescribed"].ToString().Trim() == "" || drAssementHistory[0]["InitiallyPrescribed"].ToString().Trim() == "N") && (drAssementHistory[0]["Preference"].ToString().Trim() == "") && drAssementHistory[0]["RecordDeleted"].ToString().Trim() == "N")
                                {
                                    _stringBuilderHTML.Append("<input type='checkbox' ParentChildControls='True' class='cursor_default' BindAutoSaveEvents='False' id='CheckBox_CustomSubstanceUseHistory2_SUDrugId_" + dr.ItemArray[0] + "' checked='checked'  value='" + dr.ItemArray[0] + "'  onclick=\"javascript:SetValuesforRecordDeleted('CustomSubstanceUseHistory2','RecordDeleted','SubstanceUseHistoryId'," + primaryKey + ",this," + dr.ItemArray[0] + " ,'unescape(" + dr.ItemArray[1].ToString().EncodeForJs() + ")" + "');\" />");
                                }
                                else if (drAssementHistory[0]["RecordDeleted"].ToString().Trim() == "N")
                                {
                                    _stringBuilderHTML.Append("<input type='checkbox' ParentChildControls='True' class='cursor_default' BindAutoSaveEvents='False' id='CheckBox_CustomSubstanceUseHistory2_SUDrugId_" + dr.ItemArray[0] + "' checked='checked'  value='" + dr.ItemArray[0] + "'  onclick=\"javascript:SetValuesforRecordDeleted('CustomSubstanceUseHistory2','RecordDeleted','SubstanceUseHistoryId'," + primaryKey + ",this," + dr.ItemArray[0] + " ,'unescape(" + dr.ItemArray[1].ToString().EncodeForJs() + ")" + "');\" />");
                                }
                                else if ((drAssementHistory[0]["FamilyHistory"].ToString().Trim() == "") && (drAssementHistory[0]["AgeOfFirstUse"].ToString().Trim() == "") && (drAssementHistory[0]["Frequency"].ToString().Trim() == "") && (drAssementHistory[0]["Route"].ToString().Trim() == "") && (drAssementHistory[0]["LastUsed"].ToString().Trim() == "") && (drAssementHistory[0]["InitiallyPrescribed"].ToString().Trim() == "" || drAssementHistory[0]["InitiallyPrescribed"].ToString().Trim() == "N") && (drAssementHistory[0]["Preference"].ToString().Trim() == "") && (drAssementHistory[0]["RecordDeleted"].ToString().Trim() == ""))
                                {
                                    _stringBuilderHTML.Append("<input type='checkbox' ParentChildControls='True' class='cursor_default' BindAutoSaveEvents='False' id='CheckBox_CustomSubstanceUseHistory2_SUDrugId_" + dr.ItemArray[0] + "'   value='" + dr.ItemArray[0] + "'  onclick=\"javascript:SetValuesforRecordDeleted('CustomSubstanceUseHistory2','RecordDeleted','SubstanceUseHistoryId'," + primaryKey + ",this," + dr.ItemArray[0] + " ,'unescape(" + dr.ItemArray[1].ToString().EncodeForJs() + ")" + "');\" />");
                                }

                                else
                                {
                                    _stringBuilderHTML.Append("<input type='checkbox' ParentChildControls='True' class='cursor_default' BindAutoSaveEvents='False' id='CheckBox_CustomSubstanceUseHistory2_SUDrugId_" + dr.ItemArray[0] + "' checked='checked'  value='" + dr.ItemArray[0] + "'  onclick=\"javascript:SetValuesforRecordDeleted('CustomSubstanceUseHistory2','RecordDeleted','SubstanceUseHistoryId'," + primaryKey + ",this," + dr.ItemArray[0] + " ,'unescape(" + dr.ItemArray[1].ToString().EncodeForJs() + ")" + "');\" />");
                                }
                                _stringBuilderHTML.Append(" </td>");
                                _stringBuilderHTML.Append(" <td align='left' class='LPadd5' >");


                                //  _stringBuilderHTML.Append("<a href='#' BindAutoSaveEvents='False' border='0' onclick=\"javascript:GetDrugsDescrption('" + dr.ItemArray[1].ToString() + "');\" id='Frequrncy" + i + "' style='text-decoration: underline;");
                                //  _stringBuilderHTML.Append("<span onclick=\"javascript:GetDrugsDescrption('" + dr.ItemArray[1].ToString() + "');\" class='form_label span_textunderline_cursor' id='Span" + i + "'>" + dr.ItemArray[1] + "</span>");
                                _stringBuilderHTML.Append("<span ParentChildControls='True' BindAutoSaveEvents='False' class='form_label' id='Span" + i + "'>" + dr.ItemArray[1] + "</span>");
                                // _stringBuilderHTML.Append("</a>");
                                _stringBuilderHTML.Append("</td>");

                                //-----------------button---
                                _stringBuilderHTML.Append(" <td align='left'>");
                                //_stringBuilderHTML.Append("<a href='#' border='0' BindAutoSaveEvents='False' onclick=\"javascript:GetDrugsDescrption('" + dr.ItemArray[1].ToString() + "');\" id='Frequrncy" + i + "' style='text-decoration: underline;");
                                _stringBuilderHTML.Append("<span BindAutoSaveEvents='False' type='button' text='Comment' id='button" + i.ToString() + "' style='width: 90px' name='button" + i.ToString() + "' OnClick=\"javascript:FamilyHxDetails(DivFamilyHx_" + i.ToString() + "," + i.ToString() + ",  " + primaryKey + " ," + dr.ItemArray[0] + " ,'unescape(" + dr.ItemArray[1].ToString().EncodeForJs() + ")','" + _familyHistory.Replace("\r\n", "").EncodeForJs() + "');\"></span>");
                                // _stringBuilderHTML.Append("</a>");
                                _stringBuilderHTML.Append("</td>");

                                //-------------------

                                _stringBuilderHTML.Append(" <td align='center' class='LPadd5'>");
                                _stringBuilderHTML.Append("<input type='text' maxlength='3' class='form_textbox' datatype='Numeric'  style='width:50px' ParentChildControls='True' BindAutoSaveEvents='False' onblur=\"javascript:SetValues('CustomSubstanceUseHistory2','AgeOfFirstUse','SubstanceUseHistoryId'," + primaryKey + ",this.value," + dr.ItemArray[0] + " ,'unescape(" + dr.ItemArray[1].ToString().EncodeForJs() + ")" + "');\" id='TextBox_CustomSubstanceUseHistory2_AgeOfFirstUse_" + i + "'  value='" + drAssementHistory[0].ItemArray[3].ToString() + "'  />");
                                _stringBuilderHTML.Append("</td>");

                                _stringBuilderHTML.Append(" <td align='center' class='LPadd5'>");
                                PlaceHolderControlDimensions.Controls.Add(new LiteralControl(_stringBuilderHTML.ToString()));


                                CreateDropdownHTML("CustomSubstanceUseHistory2", "Frequency", i, primaryKey, _selectedFrequency, (int)(dr.ItemArray[0]), dr.ItemArray[1].ToString());
                                _stringBuilderHTML.Remove(0, _stringBuilderHTML.Length);
                                _stringBuilderHTML.Append("</td>");

                                _stringBuilderHTML.Append(" <td align='center' class='LPadd5' >");
                                PlaceHolderControlDimensions.Controls.Add(new LiteralControl(_stringBuilderHTML.ToString()));
                                CreateDropdownHTML("CustomSubstanceUseHistory2", "Route", i, primaryKey, _selectedRoute, (int)(dr.ItemArray[0]), dr.ItemArray[1].ToString());

                                _stringBuilderHTML.Remove(0, _stringBuilderHTML.Length);
                                _stringBuilderHTML.Append("</td>");

                                _stringBuilderHTML.Append("<td width='115px' align='center'>");
                                _stringBuilderHTML.Append("<table width='100%' cellpadding='0'  cellspacing='0'  border='0'>");
                                _stringBuilderHTML.Append("<tr>");
                                _stringBuilderHTML.Append("<td  width='115px' align='center' class='LPadd5'>");
                                _stringBuilderHTML.Append("<input type='text' ParentChildControls='True' BindAutoSaveEvents='False' id='TextBox_CustomSubstanceUseHistory2_LastUsed_" + i + "' value='" + formarDate + "' onchange=\"javascript:SetValues('CustomSubstanceUseHistory2','LastUsed','SubstanceUseHistoryId'," + primaryKey + ",this.value," + dr.ItemArray[0] + " ,'unescape(" + dr.ItemArray[1].ToString().EncodeForJs() + ")" + "');\" align='center'  style='width:115px' class='LPadd5 date_text' maxlength='25' />");
                                _stringBuilderHTML.Append(" </td>");
                                //_stringBuilderHTML.Append("<td>");
                                //_stringBuilderHTML.Append("<img style='padding:2px;'  id='img_TextBox_CustomSubstanceUseHistory2_LastUsed_'" + i + "  src='");
                                //_stringBuilderHTML.Append(WebsiteSettings.BaseUrl);
                                //_stringBuilderHTML.Append("App_Themes/Includes/Images/calender_grey.gif'  onclick=\"return showCalendar('TextBox_CustomSubstanceUseHistory2_LastUsed_" + i + "', '%m/%d/%Y');\" alt='calendar' />");
                                //_stringBuilderHTML.Append(" </td>");

                                _stringBuilderHTML.Append("</tr>");
                                _stringBuilderHTML.Append("</table>");
                                _stringBuilderHTML.Append("</td>");

                                _stringBuilderHTML.Append(" <td align='center' width='20px' class='LPadd5'>");
                                if (valPresc == "Y")
                                {
                                    _stringBuilderHTML.Append(" <input type='checkbox' ParentChildControls='True' BindAutoSaveEvents='False' checked='checked' onblur=\"javascript:SetValues('CustomSubstanceUseHistory2','InitiallyPrescribed','SubstanceUseHistoryId'," + primaryKey + ",this.checked," + dr.ItemArray[0] + " ,'unescape(" + dr.ItemArray[1].ToString().EncodeForJs() + ")" + "');\" id='CheckBox_CustomSubstanceUseHistory2_InitiallyPrescribed_" + i + "_Y'  align='center' class='LPadd5 cursor_default' />");
                                }
                                else
                                {
                                    _stringBuilderHTML.Append(" <input type='checkbox' ParentChildControls='True' BindAutoSaveEvents='False' onblur=\"javascript:SetValues('CustomSubstanceUseHistory2','InitiallyPrescribed','SubstanceUseHistoryId'," + primaryKey + ",this," + dr.ItemArray[0] + " ,'unescape(" + dr.ItemArray[1].ToString().EncodeForJs() + ")" + "');\" id='CheckBox_CustomSubstanceUseHistory2_InitiallyPrescribed_" + i + "_N'  align='center' class='LPadd5 cursor_default' />");
                                }
                                _stringBuilderHTML.Append("</td>");
                                _stringBuilderHTML.Append(" <td align='center' width='40px' class='LPadd5'>");
                                _stringBuilderHTML.Append("<input type='text' ParentChildControls='True' BindAutoSaveEvents='False' onblur=\"javascript:SetValues('CustomSubstanceUseHistory2','Preference','SubstanceUseHistoryId'," + primaryKey + ",this.value," + dr.ItemArray[0] + " ,'unescape(" + dr.ItemArray[1].ToString().EncodeForJs() + ")" + "');\"   id='TextBox_CustomSubstanceUseHistory2_Preference_" + i + "' value='" + drAssementHistory[0].ItemArray[8].ToString() + "'  align='right' maxlength='1' class='form_textbox' datatype='Numeric'  style='width:30px' class='LPadd5' />");
                                _stringBuilderHTML.Append("</td>");
                                _stringBuilderHTML.Append("<td class='LPadd5'></td>");
                                _stringBuilderHTML.Append("</tr>");
                                //------
                                _stringBuilderHTML.Append("<tr>");
                                _stringBuilderHTML.Append("<td colspan='11'>");
                                _stringBuilderHTML.Append("<div id='DivFamilyHx_" + i.ToString() + "'>");

                                // Code Added with reference to Task#249
                                if (_familyHistory != string.Empty)
                                {
                                    _stringBuilderHTML.Append("<table width='100%'>");
                                    _stringBuilderHTML.Append("<tr>");
                                    _stringBuilderHTML.Append("<td >");
                                    _stringBuilderHTML.Append("<table width='100%'>");
                                    _stringBuilderHTML.Append("<tr>");
                                    _stringBuilderHTML.Append("<td width='24%'>");
                                    _stringBuilderHTML.Append("</td>");
                                    _stringBuilderHTML.Append("<td width='15%'>");
                                    _stringBuilderHTML.Append("<span class='form_label'>Comment</span>");
                                    _stringBuilderHTML.Append("</td>");
                                    _stringBuilderHTML.Append("</tr>");
                                    _stringBuilderHTML.Append("</table>");
                                    _stringBuilderHTML.Append("</td>");
                                    _stringBuilderHTML.Append("<td width='61%'>");
                                    _stringBuilderHTML.Append("<textarea ParentChildControls='True' BindAutoSaveEvents='False' id='TextArea_CustomSubstanceUseHistory2_FamilyHistory_" + i + "' name='TextArea_CustomSubstanceUseHistory2_FamilyHistory_" + i + "' spellcheck='True'  datatype='String'");
                                    _stringBuilderHTML.Append("rows='4' cols='1' style='width: 412px' onchange=\"javascript:GetFamilyHistoryText('TextArea_CustomSubstanceUseHistory2_FamilyHistory_" + i + "'  ," + primaryKey + " ," + dr.ItemArray[0] + " ,'unescape(" + dr.ItemArray[1].ToString().EncodeForJs() + ")" + "');\" >" + _familyHistory + "</textarea> ");
                                    _stringBuilderHTML.Append("</td>");
                                    _stringBuilderHTML.Append("</tr>");
                                    _stringBuilderHTML.Append("</table>");
                                }
                                //Task #249 end here
                                _stringBuilderHTML.Append("</div>");
                                _stringBuilderHTML.Append("</td>");
                                _stringBuilderHTML.Append("</tr>");

                                //-----
                                PlaceHolderControlDimensions.Controls.Add(new LiteralControl(_stringBuilderHTML.ToString()));
                                _stringBuilderHTML.Remove(0, _stringBuilderHTML.Length);
                                i++;
                                _familyHistory = string.Empty;
                            }
                            //Html without values
                            else
                            {
                                primaryKey = -1 - i;
                                _familyHistory = string.Empty;
                                //CreateHTMLWithoutValues();
                                int _selectedFrequencyVal = 0;
                                _stringBuilderHTML.Append(" <tr >");
                                _stringBuilderHTML.Append("<td class='LPadd5'></td>");
                                //------------icon
                                _stringBuilderHTML.Append(" <td  >");
                                _stringBuilderHTML.Append(" <img style='cursor: default ;' id='' src='");
                                _stringBuilderHTML.Append(WebsiteSettings.BaseUrl);
                                _stringBuilderHTML.Append("App_Themes/Includes/Images/info.png' title='" + dr.ItemArray[4].ToString() + " ' />");
                                _stringBuilderHTML.Append(" </td>");
                                //------------
                                _stringBuilderHTML.Append(" <td align='left' class='LPadd5'  >");
                                _stringBuilderHTML.Append("<input type='checkbox' ParentChildControls='True' BindAutoSaveEvents='False'  class='cursor_default'  id='CheckBox_CustomSubstanceUseHistory2_SUDrugId_" + dr.ItemArray[0] + "'  value='" + dr.ItemArray[0] + "' onclick=\"javascript:SetValuesforRecordDeleted('CustomSubstanceUseHistory2','RecordDeleted','SubstanceUseHistoryId'," + primaryKey + ",this," + dr.ItemArray[0] + ",'unescape(" + dr.ItemArray[1].ToString().EncodeForJs() + ")');\" />");

                                _stringBuilderHTML.Append(" </td>");
                                _stringBuilderHTML.Append(" <td align='left' class='LPadd5' >");
                                //_stringBuilderHTML.Append("<a href='#' border='0' BindAutoSaveEvents='False' onclick=\"javascript:GetDrugsDescrption('" + dr.ItemArray[1].ToString() + "');\" id='Frequrncy" + i + "' style='text-decoration: underline;");
                                //_stringBuilderHTML.Append("<span onclick=\"javascript:GetDrugsDescrption('" + dr.ItemArray[1].ToString() + "');\" class='form_label span_textunderline_cursor' id='Span" + i + "'>" + dr.ItemArray[1] + "</span>");
                                _stringBuilderHTML.Append("<span ParentChildControls='True' BindAutoSaveEvents='False'class='form_label'  id='Span" + i + "'>" + dr.ItemArray[1] + "</span>");
                                // _stringBuilderHTML.Append("</a>");
                                _stringBuilderHTML.Append("</td>");

                                //-----------------button---
                                _stringBuilderHTML.Append(" <td align='left' style='width: 90px' >");
                                //_stringBuilderHTML.Append("<a href='#' border='0' BindAutoSaveEvents='False' onclick=\"javascript:GetDrugsDescrption('" + dr.ItemArray[1].ToString() + "');\" id='Frequrncy" + i + "' style='text-decoration: underline;");
                                _stringBuilderHTML.Append("<span ParentChildControls='True' BindAutoSaveEvents='False' type='button' text='Comment' id='button" + i.ToString() + "' style='width: 90px' name='button" + i.ToString() + "' OnClick=\"javascript:FamilyHxDetails(DivFamilyHx_" + i.ToString() + "," + i.ToString() + " , " + primaryKey + " ," + dr.ItemArray[0] + " ,'unescape(" + dr.ItemArray[1].ToString().EncodeForJs() + ")','" + _familyHistory + "');\"></span>");
                                // _stringBuilderHTML.Append("</a>");
                                _stringBuilderHTML.Append("</td>");

                                //-------------------
                                _stringBuilderHTML.Append(" <td align='center' class='LPadd5'>");
                                _stringBuilderHTML.Append("<input type='text' ParentChildControls='True' BindAutoSaveEvents='False' onblur=\"javascript:SetValues('CustomSubstanceUseHistory2','AgeOfFirstUse','SubstanceUseHistoryId'," + primaryKey + ",this.value," + dr.ItemArray[0] + ",'unescape(" + dr.ItemArray[1].ToString().EncodeForJs() + ")');\" id='TextBox_CustomSubstanceUseHistory2_AgeOfFirstUse_" + i + "' maxlength='3' class='form_textbox' datatype='Numeric' style='width:50px' />");
                                _stringBuilderHTML.Append("</td>");

                                _stringBuilderHTML.Append(" <td align='center' class='LPadd5'>");
                                PlaceHolderControlDimensions.Controls.Add(new LiteralControl(_stringBuilderHTML.ToString()));

                                CreateDropdownHTML("CustomSubstanceUseHistory2", "Frequency", i, primaryKey, _selectedFrequencyVal, (int)(dr.ItemArray[0]), dr.ItemArray[1].ToString());
                                _stringBuilderHTML.Remove(0, _stringBuilderHTML.Length);
                                _stringBuilderHTML.Append("</td>");

                                _stringBuilderHTML.Append(" <td align='center' class='LPadd5'>");
                                PlaceHolderControlDimensions.Controls.Add(new LiteralControl(_stringBuilderHTML.ToString()));
                                CreateDropdownHTML("CustomSubstanceUseHistory2", "Route", i, primaryKey, _selectedFrequencyVal, (int)(dr.ItemArray[0]), dr.ItemArray[1].ToString());

                                _stringBuilderHTML.Remove(0, _stringBuilderHTML.Length);
                                _stringBuilderHTML.Append("</td>");

                                _stringBuilderHTML.Append("<td width='115px' align='center'>");
                                _stringBuilderHTML.Append("<table width='100%' cellpadding='0'  cellspacing='0'  border='0'>");
                                _stringBuilderHTML.Append("<tr>");
                                _stringBuilderHTML.Append("<td width='115px' align='center' class='LPadd5'>");
                                // _stringBuilderHTML.Append("<input type='text' ParentChildControls='True' BindAutoSaveEvents='False' onchange=\"javascript:SetValues('CustomSubstanceUseHistory2','LastUsed','SubstanceUseHistoryId'," + primaryKey + ",this.value," + dr.ItemArray[0] + ",'unescape(" + dr.ItemArray[1].ToString().EncodeForJs() + ")');\" id='TextBox_CustomSubstanceUseHistory2_LastUsed_" + i + "' align='right' class='LPadd5 date_text' datatype='Date' />");
                                string s = "<input type='text' ParentChildControls='True' BindAutoSaveEvents='False' onchange=\"javascript:SetValues('CustomSubstanceUseHistory2','LastUsed','SubstanceUseHistoryId'," + primaryKey + ",this.value," + dr.ItemArray[0] + ",'unescape(" + dr.ItemArray[1].ToString().EncodeForJs() + ")');\" id='TextBox_CustomSubstanceUseHistory2_LastUsed_" + i + "' align='center' style='width:115px' class='LPadd5 date_text' maxlength='25' />";
                                _stringBuilderHTML.Append(s);

                                _stringBuilderHTML.Append(" </td>");
                                //_stringBuilderHTML.Append("<td>");
                                //_stringBuilderHTML.Append("<img style='cursor: default;padding:2px;' id='img_TextBox_CustomSubstanceUseHistory2_LastUsed'" + i + "  src='");
                                //_stringBuilderHTML.Append(WebsiteSettings.BaseUrl);
                                //_stringBuilderHTML.Append("App_Themes/Includes/Images/calender_grey.gif'  onclick=\"return showCalendar('TextBox_CustomSubstanceUseHistory2_LastUsed_" + i + "', '%m/%d/%Y');\" alt='calendar' />");
                                //_stringBuilderHTML.Append("</td>");

                                _stringBuilderHTML.Append("</tr>");
                                _stringBuilderHTML.Append("</table>");
                                _stringBuilderHTML.Append("</td>");

                                _stringBuilderHTML.Append("<td align='center' width='10px' class='LPadd5'>");
                                _stringBuilderHTML.Append("<input type='checkbox' ParentChildControls='True' BindAutoSaveEvents='False' onblur=\"javascript:SetValues('CustomSubstanceUseHistory2','InitiallyPrescribed','SubstanceUseHistoryId'," + primaryKey + ",this," + dr.ItemArray[0] + ",'unescape(" + dr.ItemArray[1].ToString().EncodeForJs() + ")');\" id='CheckBox_CustomSubstanceUseHistory2_InitiallyPrescribed_" + i + "_N' align='center' class='LPadd5 cursor_default'  />");
                                _stringBuilderHTML.Append("</td>");
                                _stringBuilderHTML.Append("<td align='center' width='40px' class='LPadd5'>");
                                _stringBuilderHTML.Append("<input type='text' ParentChildControls='True' BindAutoSaveEvents='False' onblur=\"javascript:SetValues('CustomSubstanceUseHistory2','Preference','SubstanceUseHistoryId'," + primaryKey + ",this.value," + dr.ItemArray[0] + ",'unescape(" + dr.ItemArray[1].ToString().EncodeForJs() + ")');\"  id='TextBox_CustomSubstanceUseHistory2_Preference_" + i + "' align='right' maxlength='1' datatype='Numeric' class='form_textbox'   style='width:30px' class='LPadd5' />");
                                _stringBuilderHTML.Append("</td>");
                                _stringBuilderHTML.Append("<td class='LPadd5'></td>");
                                _stringBuilderHTML.Append("</tr>");

                                _stringBuilderHTML.Append("</td>");
                                _stringBuilderHTML.Append("<td colspan='11'>");
                                _stringBuilderHTML.Append("<div id='DivFamilyHx_" + i.ToString() + "' width='100%' >");
                                _stringBuilderHTML.Append("</div>");
                                _stringBuilderHTML.Append("</td>");
                                _stringBuilderHTML.Append("</tr>");
                                PlaceHolderControlDimensions.Controls.Add(new LiteralControl(_stringBuilderHTML.ToString()));
                                _stringBuilderHTML.Remove(0, _stringBuilderHTML.Length);
                                i++;
                            }
                        }

                        _stringBuilderHTML.Append("</table>");
                        _stringBuilderHTML.Append("</div>");
                        PlaceHolderControlDimensions.Controls.Add(new LiteralControl(_stringBuilderHTML.ToString()));
                    }
                }
            }

        }
        #endregion HTML
        //}
        //catch (Exception ex)
        //{
        //    throw (ex);
        //}
        //finally
        //{

        //}

    }

    /// <summary>
    /// To create dropdown dynamically.
    /// </summary>
    /// <param name="tableName"></param>
    /// <param name="columnName"></param>
    /// <param name="value"></param>
    protected void CreateDropdownHTML(string tableName, string columnName, int value, int primrykeyVal, int selectedVal, int drugid, string drugname)
    {
        string dropdownHtml = string.Empty;
        DataView _dataViewDropdown = null;

        _dropdownListObject = new DropDownList();
        _dropdownListObject.ID = "DropDownList_" + tableName + "_" + columnName + "_" + value;
        _dropdownListObject.Style["width"] = "98%";
        _dropdownListObject.CssClass = "form_dropdown";
        _dropdownListObject.Attributes.Add("BindAutoSaveEvents", "False");
        _dropdownListObject.Attributes.Add("ParentChildControls", "True");


        if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes.Rows.Count > 0)
        {
            _dataViewDropdown = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes.DefaultView;

            if (columnName == "Frequency")
            {
                _dataViewDropdown.RowFilter = "Category = '" + _itemGlobalCategoryFrequency.ToString() + "'";
            }
            else if (columnName == "Route")
            {
                _dataViewDropdown.RowFilter = "Category = '" + _itemGlobalCategoryRoute.ToString() + "'";
            }


            _dropdownListObject.DataTextField = "CodeName";
            _dropdownListObject.DataValueField = "GlobalCodeId";
            _dataViewDropdown.Sort = " CodeName ASC";
            _dropdownListObject.DataSource = _dataViewDropdown;
            _dropdownListObject.DataBind();
            _dropdownListObject.Items.Insert(0, new ListItem("-- Select --", ""));
            if (columnName == "Frequency")
            {
                _dropdownListObject.Attributes.Add("onChange", "SetValues('CustomSubstanceUseHistory2','Frequency','SubstanceUseHistoryId'," + primrykeyVal + ",this.value," + drugid + ",'unescape(" + drugname.ToString().EncodeForJs() + ")');");
            }
            else if (columnName == "Route")
            {
                _dropdownListObject.Attributes.Add("onChange", "SetValues('CustomSubstanceUseHistory2','Route','SubstanceUseHistoryId'," + primrykeyVal + ",this.value," + drugid + ",'unescape(" + drugname.ToString().EncodeForJs() + ")');");
            }


        }
        _dropdownListObject.SelectedValue = (Convert.ToString(selectedVal));
        PlaceHolderControlDimensions.Controls.Add(_dropdownListObject);

    }



    public override void BindControls()
    {
        //throw new NotImplementedException();
    }
}
}


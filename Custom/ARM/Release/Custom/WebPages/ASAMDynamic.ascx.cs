using System;
using System.Data;
using System.Text;
using System.Web.UI;

namespace SHS.SmartCare
{
    public partial class ASAMDynamic : SHS.BaseLayer.ActivityPages.DataActivityTab
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            RelativePath = Page.ResolveUrl("~/");
        }

        #region Public Properties

        public string TableNameCustomASAMLevelOfCares { get; set; }
        public string TableNameCustomASAMPlacements { get; set; }
        public string ColumnNameLeftDimensionDescription { get; set; }
        public string ColumnNameRightDimensionDescription { get; set; }

        public string ColumnNameLeftDimensionLevelOfCare { get; set; }
        public string ColumnNameRightDimensionLevelOfCare { get; set; }

        public string ColumnNameLevelOfCareName { get; set; }
        public string Value { get; set; }
        public string TextValueLeftDimensionDescription { get; set; }
        public string TextValueRightDimensionDescription { get; set; }
        public string ColumnNameLeftDimensionNeed { get; set; }
        public string ColumnNameRightDimensionNeed { get; set; }

        public string LeftDimensionDescriptionTitle { get; set; }
        public string RightDimensionDescriptionTitle { get; set; }
        public string LeftDimensionNeedTitle { get; set; }
        public string RightDimensionNeedTitle { get; set; }

        #endregion
        string _PageContent = string.Empty;
       
        //SHS.BaseLayer.SharedTables _objectSharedTable = null;
        public void BindDimensions()
        {
            #region //Page
            _PageContent = @"<div style=""width: 100%;"">
    <table border=""0"" cellpadding=""0"" cellspacing=""0"" style=""width: 100%;"">
        <tr>
            <td valign=""top"">
                <table border=""0"" cellpadding=""0"" cellspacing=""0"" width=""99%"">
                    <tr>
                        <td width=""40%"">
                            <table width=""100%"" border=""0"" cellspacing=""0"" cellpadding=""0"">
                                <tr>
                                    <td class=""content_tab_left"" align=""left"" width=""99%"">
                                        %%LeftDimensionDescriptionTitle%%
                                    </td>
                                    <td width=""17"">
                                        <img style=""vertical-align: top"" src=""%%ImageUrl%%/content_tab_sep.gif""
                                            width=""17"" height=""26"" alt="""" />
                                    </td>
                                    <td class=""content_tab_top"" width=""100%"">
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <td width=""20%"" class=""content_tab_top"">
                        </td>    
                        <td width=""40%"">
                            <table width=""100%"" border=""0"" cellspacing=""0"" cellpadding=""0"">
                                <tr>
                                    <td class=""content_tab_left_dual"" align=""left"" width=""97%"" >
                                         %%RightDimensionDescriptionTitle%%
                                    </td>
                                    <td width=""17"">
                                        <img style=""vertical-align: top"" src=""%%ImageUrl%%/content_tab_sep.gif""
                                            width=""17"" height=""26"" alt="""" />
                                    </td>
                                    <td class=""content_tab_top"" width=""100%"">
                                    </td>
                                    <td width=""7"">
                                        <img style=""vertical-align: top"" src=""%%ImageUrl%%/content_tab_right.gif""
                                            width=""7"" height=""26"" alt="""" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td class=""content_tab_bg"" colspan=""3"">
                        %%DimensionBase%%
                          
                        </td>
                    </tr>
                    <tr>
                        <td colspan=""3"">
                            <table cellspacing=""0"" cellpadding=""0"" border=""0"" width=""100%"">
                                <tbody>
                                    <tr>
                                        <td width=""2"" class=""right_bottom_cont_bottom_bg"">
                                            <img height=""7"" alt="""" src=""%%ImageUrl%%/right_bottom_cont_bottom_left.gif""
                                                style=""vertical-align: top;"" />
                                        </td>
                                        <td width=""100%"" class=""right_bottom_cont_bottom_bg"">
                                        </td>
                                        <td align=""right"" width=""2"" class=""right_bottom_cont_bottom_bg"">
                                            <img height=""7"" alt="""" src=""%%ImageUrl%%/right_bottom_cont_bottom_right.gif""
                                                style=""vertical-align: top;"" />
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td class=""height2"">
            </td>
        </tr>
        <tr>
            <td>
                <table border=""0"" width=""99%"">
                    <tr>
                        <td style=""width: 40%"">
                            <table border=""0"" cellpadding=""0"" cellspacing=""0"" width=""100%"">
                                <tr>
                                    <td>
                                        <table width=""100%"" border=""0"" cellspacing=""0"" cellpadding=""0"">
                                            <tr>
                                                <td class=""content_tab_left"" align=""left"" width=""80%"" nowrap=""nowrap"">
                                                    %%LeftDimensionNeedTitle%%
                                                </td>
                                                <td width=""17"">
                                                    <img style=""vertical-align: top"" src=""%%ImageUrl%%/content_tab_sep.gif""
                                                        width=""17"" height=""26"" alt="""" />
                                                </td>
                                                <td class=""content_tab_top"" width=""100%"">
                                                </td>
                                                <td width=""7"">
                                                    <img style=""vertical-align: top"" src=""%%ImageUrl%%/content_tab_right.gif""
                                                        width=""7"" height=""26"" alt="""" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td class=""content_tab_bg"" align=""left"" style=""padding-left:10px"">
                                    %%Dimension1%%
                                       
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table cellspacing=""0"" cellpadding=""0"" border=""0"" width=""100%"">
                                            <tbody>
                                                <tr>
                                                    <td width=""2"" class=""right_bottom_cont_bottom_bg"">
                                                        <img height=""7"" alt="""" src=""%%ImageUrl%%/right_bottom_cont_bottom_left.gif""
                                                            style=""vertical-align: top;""/>
                                                    </td>
                                                    <td width=""100%"" class=""right_bottom_cont_bottom_bg"">
                                                    </td>
                                                    <td align=""right"" width=""2"" class=""right_bottom_cont_bottom_bg"">
                                                        <img height=""7"" alt="""" src=""%%ImageUrl%%/right_bottom_cont_bottom_right.gif""
                                                            style=""vertical-align: top;"" />
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <td width=""20%"">
                        </td>    
                        <td width=""40%"">
                            <table border=""0"" cellpadding=""0"" cellspacing=""0"" width=""100%"">
                                <tr>
                                    <td>
                                        <table width=""100%"" border=""0"" cellspacing=""0"" cellpadding=""0"">
                                            <tr>
                                                <td class=""content_tab_left"" align=""left"" width=""80%"" nowrap=""nowrap"">
                                                    %%RightDimensionNeedTitle%%
                                                </td>
                                                <td width=""17"">
                                                    <img style=""vertical-align: top"" src=""%%ImageUrl%%/content_tab_sep.gif""
                                                        width=""17"" height=""26"" alt="""" />
                                                </td>
                                                <td class=""content_tab_top"" width=""100%"">
                                                </td>
                                                <td width=""7"">
                                                    <img style=""vertical-align: top"" src=""%%ImageUrl%%/content_tab_right.gif""
                                                        width=""7"" height=""26"" alt="""" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td class=""content_tab_bg"" align=""left"" style=""padding-left:10px"">
                                     %%Dimension2%%
                                       
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table cellspacing=""0"" cellpadding=""0"" border=""0"" width=""100%"">
                                            <tbody>
                                                <tr>
                                                    <td width=""2"" class=""right_bottom_cont_bottom_bg"">
                                                        <img height=""7"" alt="""" src=""%%ImageUrl%%/right_bottom_cont_bottom_left.gif""
                                                            style=""vertical-align: top;"" />
                                                    </td>
                                                    <td width=""100%"" class=""right_bottom_cont_bottom_bg"">
                                                    </td>
                                                    <td align=""right"" width=""2"" class=""right_bottom_cont_bottom_bg"">
                                                        <img height=""7"" alt="""" src=""%%ImageUrl%%/right_bottom_cont_bottom_right.gif""
                                                            style=""vertical-align: top;"" />
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</div>";
            #endregion


            string _Dimension1 = string.Empty;
            string _Dimension2 = string.Empty;
            StringBuilder _stringBuilderHTML = null;
            //string _TableName = "";
            //string _itemColumnName = string.Empty;
            //string RadioButtonHTML = "";
            //_objectSharedTable = Application["SharedTables"] as SHS.BaseLayer.SharedTables;

            if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.CustomASAMLevelOfCares != null)
            {
                _stringBuilderHTML = new StringBuilder();
                DataSet dataSetASAM = new DataSet();
                dataSetASAM.Tables.Add(SHS.BaseLayer.SharedTables.ApplicationSharedTables.CustomASAMLevelOfCares.Copy());
                if (dataSetASAM != null)
                {
                    if (dataSetASAM.Tables.Count > 0)
                    {
                        if (dataSetASAM.Tables.Contains(TableNameCustomASAMLevelOfCares) == true)
                        {
                            _stringBuilderHTML = new StringBuilder();
                            _stringBuilderHTML.Append("<table cellpadding='0' cellspacing='5' width='100%' border='0'>");
                            foreach (DataRow dr in dataSetASAM.Tables[TableNameCustomASAMLevelOfCares].Rows)
                            {
                                _stringBuilderHTML.Append("<tr>");
                                _stringBuilderHTML.Append("<td width='40%' class='checkbox_container'>");
                                _stringBuilderHTML.Append(GetHTMLForRadioButton(TableNameCustomASAMPlacements, ColumnNameLeftDimensionLevelOfCare, dr[Value].ToString(), dr[TextValueLeftDimensionDescription].ToString()));
                                _stringBuilderHTML.Append("</td>");
                                _stringBuilderHTML.Append("<td valign='middle' width='20%'>");
                                _stringBuilderHTML.Append("<span class=\"form_label\">");
                                _stringBuilderHTML.Append(dr[ColumnNameLevelOfCareName].ToString());
                                _stringBuilderHTML.Append("</span>");
                                _stringBuilderHTML.Append("</td>");
                                _stringBuilderHTML.Append("<td class='checkbox_container' width='40%'>");
                                _stringBuilderHTML.Append(GetHTMLForRadioButton(TableNameCustomASAMPlacements, ColumnNameRightDimensionLevelOfCare, dr[Value].ToString(), dr[TextValueRightDimensionDescription].ToString()));
                                //_stringBuilderHTML.Append(GetHTMLForRadioButton(_TableName, "Dimension2Description", dr["ASAMLevelOfCareId"].ToString(), dr["Dimension2Description"].ToString()));
                                _stringBuilderHTML.Append("</td>");
                                _stringBuilderHTML.Append("</tr>");
                                // _stringBuilderHTML.Append("</table>");
                            }
                            _Dimension1 = GetHTMLForMultilineTextBox(TableNameCustomASAMPlacements, ColumnNameLeftDimensionNeed);
                            _Dimension2 = GetHTMLForMultilineTextBox(TableNameCustomASAMPlacements, ColumnNameRightDimensionNeed);
                            _stringBuilderHTML.Append("</table>");
                        }
                    }
                }
            }
            //_stringBuilderHTML.Append(GetHTMLForRadioButton(_TableName, _itemColumnName, dr1["ExternalCode1"].ToString(), dr1["CodeName"].ToString()));

            //string baseImageUrl = ""+RelativePath+"App_Themes/Includes/Images";
            string baseImageUrl = WebsiteSettings.BaseUrl + "App_Themes/Includes/Images";
            //string baseImageUrl = "<%=RelativePath%>App_Themes/Includes/Images";


            PlaceHolderControlDimensions.Controls.Add(new LiteralControl(_PageContent.Replace("%%ImageUrl%%", baseImageUrl)
                .Replace("%%LeftDimensionDescriptionTitle%%", LeftDimensionDescriptionTitle)
                .Replace("%%RightDimensionDescriptionTitle%%", RightDimensionDescriptionTitle)
                .Replace("%%LeftDimensionNeedTitle%%", LeftDimensionNeedTitle)
                .Replace("%%RightDimensionNeedTitle%%", RightDimensionNeedTitle)
                .Replace("%%Dimension1%%", _Dimension1)
                .Replace("%%Dimension2%%", _Dimension2)
                .Replace("%%DimensionBase%%", _stringBuilderHTML.ToString())));
        }
        /// <summary>
        /// Method For getting HTML for MultilineTextbox or TextArea
        /// </summary>
        /// <returns></returns>
        /// Created By Jitender
        private string GetHTMLForMultilineTextBox(string tableName, string columnName)
        {
            string TextBoxMulilineHTML = string.Empty;
            //try catch finally block commented by shifali in ref to task# 950 on 14 june,2010
            //try
            //{
                TextBoxMulilineHTML = "<textarea class='form_textarea' rows='5' datatype='String' style='width: 95%' spellcheck='True' ";
                TextBoxMulilineHTML = TextBoxMulilineHTML + " id='TextArea_" + tableName + "_" + columnName + "' ";
                TextBoxMulilineHTML = TextBoxMulilineHTML + "  name='TextArea_" + tableName + "_" + columnName + "' BindAutoSaveEvents='True'  > ";
                TextBoxMulilineHTML = TextBoxMulilineHTML + "  </textarea>";
            //}
            //catch (Exception ex)
            //{
            //    throw ex;
            //}
            return TextBoxMulilineHTML;
        }

        /// <summary>
        /// Method For getting HTML for Radio button
        /// </summary>
        /// <returns></returns>
        /// Created By Jitender
        private string GetHTMLForRadioButton(string tableName, string columnName, string value, string textValue)
        {
            string RadioButtonHTML = "";
            //try catch finally block commented by shifali in ref to task# 950 on 14 june,2010
            //try
            //{
                RadioButtonHTML = ("<table cellpadding='0' cellspacing='0' border='0'><tr><td>");
                RadioButtonHTML += "<input type ='radio' id='RadioButton_" + tableName + "_" + columnName + "_" + value + "' ";
                RadioButtonHTML += " name='RadioButton_" + tableName + "_" + columnName + "' ";
                RadioButtonHTML += " Value= '" + value + "' />";
                RadioButtonHTML += ("</td>");
                RadioButtonHTML += ("<td>&nbsp;");
                RadioButtonHTML += ("</td>");
                RadioButtonHTML += ("<td>");
                RadioButtonHTML += "<label for='RadioButton_" + tableName + "_" + columnName + "_" + value + "' >" + textValue + "</label>";
                RadioButtonHTML += ("</td></tr></table>");

            //}
            //catch (Exception ex)
            //{
            //    throw ex;
            //}
            return RadioButtonHTML;
        }
        public override void BindControls()
        {

        }
    }
}

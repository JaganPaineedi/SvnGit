using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Collections.Generic;
using SHS.BaseLayer;
using System.Linq;
using Microsoft.ApplicationBlocks.Data;
using System.Data.SqlClient;
using SHS.DataServices;
using System.Text;


namespace SHS.SmartCare
{

    public partial class Custom_PsychiatricNote_WebPages_PsychiatricNote : SHS.BaseLayer.ActivityPages.DocumentDataActivityMultiTabPage
    {
        string DocumentCodeId = string.Empty;
        int cellcount = 0;
       
        string checkboxfiltervalues = "[";
        string tablehtml = "<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">";
        StringBuilder sb = new StringBuilder();
        public override string PageDataSetName
        {
            get
            {
                return "DataSetPsychiatricNote";
            }
        }

        public override string[] TablesToBeInitialized
        {
            get
            {
                return new string[] { "CustomDocumentPsychiatricNoteGenerals", "CustomPsychiatricNoteProblems", "CustomDocumentPsychiatricPCPProviders", "CustomDocumentPsychiatricNoteExams", "CustomDocumentPsychiatricNoteMDMs", "CustomDocumentPsychiatricAIMSs", "CustomDocumentPsychiatricNoteChildAdolescents", "DocumentDiagnosis", "DocumentDiagnosisFactors","NoteEMCodeOptions","CustomPsychiatricNoteMedicationHistory" };
            }
        }
        public override string DefaultTab
        {
            get { return "/Custom/PsychiatricNote/WebPages/PsychiatricNoteGeneral.ascx"; }
        }
        public override string MultiTabControlName
        {
            get { return "RadMultiPage1"; }
        }
        public override void setTabIndex(int TabIndex, out ControlCollection ctlcollection, out string UcPath)
        {
            ctlcollection = this.RadMultiPage1.Controls[TabIndex].Controls;
            RadTabStrip1.SelectedIndex = (short)TabIndex;
            RadMultiPage1.SelectedIndex = (short)TabIndex;
            UcPath = RadTabStrip1.Tabs[TabIndex].Attributes["Path"];
        }
        

        //for Vitals Start

        public override System.Data.SqlClient.SqlParameter[] SqlParameterForGetData
        {
            get
            {
                int healthDataAttributeId = -1;
                if (base.GetRequestParameterValue("HealthDataAttributeId").Length > 0)
                    int.TryParse(base.GetRequestParameterValue("HealthDataAttributeId"), out healthDataAttributeId);
                SqlParameter[] _objectSqlParmeters = new SqlParameter[2];
                _objectSqlParmeters[0] = new SqlParameter("@ClientId", BaseCommonFunctions.ApplicationInfo.Client.ClientId);
                _objectSqlParmeters[1] = new SqlParameter("@HealthDataAttributeId", healthDataAttributeId);
                return _objectSqlParmeters;
            }
        }
        public override string[] TablesNameForGetData
        {
            get
            {
                return new string[] { "HealthDataAttributes", "HealthDataGraphCriteria", "HealthDataGraphCriteriaRanges", "ClientHealthDataAttributes" };
            }
        }



        public override void CustomAjaxRequest()
        {
            string ClientInfo = "<br/> Client ID: " + BaseCommonFunctions.ApplicationInfo.Client.ClientId.ToString() + "<br/> Client Name: " + BaseCommonFunctions.ApplicationInfo.Client.ClientName.ToString();

            switch (GetRequestParameterValue("pageAction"))
            {
                case "GetVitals":
                    {
                        GetHealthDataHTML();
                        ShowHidePanel("###StartBindVitals###", "###EndBindVitals###", sb.ToString());
                        break;
                    }            
            }
        }

        private string GetHealthDataHTML()
        {
            #region
                    Repeater Repeater_FlowSheet = new Repeater();
                    Int32 counter = 0, _rowheader = 0;
                    string CursorType = "";
                    string LabelClass = "";
                  
                    int HealthDataUnits = 0;
                    DateTime _StartDate, _EndDate;
                    int templateId = Convert.ToInt32(GetRequestParameterValue("templateId"));
                    _StartDate = GetRequestParameterValue("StartDate") != "" ? Convert.ToDateTime(GetRequestParameterValue("StartDate")) : DateTime.MinValue;
                    _EndDate = GetRequestParameterValue("EndDate") != "" ? Convert.ToDateTime(GetRequestParameterValue("EndDate")) : DateTime.MaxValue;
                    DataTable TblDistinctTotalHealthDataAttributes = null;
                    string HeaderText = string.Empty;

                        DataSet dataSetFlowSheet = GetClientFlowSheetData(BaseCommonFunctions.ApplicationInfo.Client.ClientId, templateId, _StartDate, _EndDate);
                    
                        if (dataSetFlowSheet.Tables["HealthRecordDates"].Rows.Count > 0)
                        {
                            string DateTimeFormat = string.Empty;
                            string HeaderTimeFormat = string.Empty;
                            DataTable dtFlowSheet = new DataTable("FlowSheet");
                            dtFlowSheet.Columns.Add(new DataColumn(" ", Type.GetType("System.String")));
                            TblDistinctTotalHealthDataAttributes = dataSetFlowSheet.Tables["TotalHealthDataAttributes"].DefaultView.ToTable(true, "HealthDataSubTemplateId", "HealthDataSubTemplateName", "IsHeading");
                            TblDistinctTotalHealthDataAttributes.DefaultView.RowFilter = "IsHeading='Y'";

                                int RowCount = 0;
                                foreach (DataRow dr in dataSetFlowSheet.Tables["HealthRecordDates"].Rows)
                                {
                                    if (RowCount <=3)
                                    {
                                    HeaderTimeFormat = "<div>" + Convert.ToDateTime(dr["HealthRecordDate"]).ToString("MM/dd/yyyy") + "</Div><br /><Div>" + Convert.ToDateTime(dr["HealthRecordDate"]).ToString("hh:mm tt") + "</Div>";
                                    DateTimeFormat = Convert.ToDateTime(dr["HealthRecordDate"]).ToString("MM/dd/yyyy") + " " + Convert.ToDateTime(dr["HealthRecordDate"]).ToString("hh:mm tt");
                                    dtFlowSheet.Columns.Add(new DataColumn(DateTimeFormat, Type.GetType("System.String")));
                                    }
                                    RowCount++;
                               }

                       
                                foreach (DataRow dr in dataSetFlowSheet.Tables["TotalHealthDataAttributes"].Rows)
                                {

                                    DataRow dataRow = dtFlowSheet.NewRow();
                                    DataRow dataRowHeader = dtFlowSheet.NewRow();
                                    DataRow[] FilterRows = dataSetFlowSheet.Tables["ClientHealthDataAttributes"].Select(" HealthDataAttributeId = " + dr["HealthDataAttributeId"] + " AND HealthDataSubTemplateId=" + dr["HealthDataSubTemplateId"]);
                                    if (dr["IsHeading"].ToString() == "Y")
                                    {
                                        if (TblDistinctTotalHealthDataAttributes.DefaultView.Count > 0 && (dr["HealthDataSubTemplateId"].ToString() == TblDistinctTotalHealthDataAttributes.DefaultView[0][0].ToString()))
                                        {
                                            dataRowHeader[0] = dr["HealthDataSubTemplateName"];
                                            dataRowHeader[1] = "HEADER";
                                            dtFlowSheet.Rows.Add(dataRowHeader);
                                            TblDistinctTotalHealthDataAttributes.DefaultView.Delete(0);
                                        }
                                    }

                                    foreach (DataRow drAtt in FilterRows)
                                    {
                                        dataRow[0] = drAtt["Description"];
                                        foreach (DataColumn DC in dtFlowSheet.Columns)
                                        {
                                            if (Convert.ToDateTime(drAtt["HealthRecordDate"]).ToString("MM/dd/yyyy hh:mm tt") == DC.ToString())
                                            {
                                                dataRow[DC.Ordinal] = drAtt["Value"];
                                            }
                                        }
                                    }
                                    if (dataRow[0].ToString() != "")
                                        dtFlowSheet.Rows.Add(dataRow);
                                  
                                }
                        

                            Repeater_FlowSheet.DataSource = dtFlowSheet;
                            Repeater_FlowSheet.DataBind();


                            if (Repeater_FlowSheet.Items.Count > 0)
                            {
                                sb.Append("<div ID='div_DynamicFlowSheetHeader' style='overflow: auto; overflow:hidden;width:850px'>");
                                sb.Append("<table id='table_FlowHeader' border='0' cellpadding='0' cellspacing='0' style='border-left:solid 1px white;border-bottom:solid 1px black;border-right:solid 1px black;border-top:solid 0px white;'>");

                            }
                            else
                                sb.Append(" ");
                            foreach (RepeaterItem repeatItem in Repeater_FlowSheet.Items)
                            {
                                if (repeatItem.ItemIndex == 0)
                                {
                                    sb.Append("<tr>");
                                    foreach (DataColumn DC in dtFlowSheet.Columns)
                                    {
                                        if (DC.ToString().Trim().IsNullOrEmpty())
                                        {
                                            sb.Append("<td class='dxgvHeader' style='padding:4px;padding-top:10px;padding-bottom:10px; border-left:solid 1px black;border-bottom:solid 1px black;border-right:solid 1px black;border-top:solid 2px black;width:100px;'><h4 style='width:100px'>Type</h4></td>");
                                            sb.Append("<td class='dxgvHeader' style='padding:4px;padding-top:10px;padding-bottom:10px; border-left:solid 1px black;border-bottom:solid 1px black;border-right:solid 1px black;border-top:solid 2px black;width:120px;'><h4 style='width:100px'>Item</h4></td>");
                                        }

                          
                                        else
                                        {
                                            String[] TimeArray = DC.ToString().Split(' ');

                                            sb.Append("<td class='dxgvHeader' style='padding:4px;padding-top:10px;padding-bottom:10px; border-left:solid 1px black;border-bottom:solid 1px black;border-right:solid 1px black;border-top:solid 2px black;width:120px;'><h4 style='width:100px'>" + Convert.ToDateTime(DC.ColumnName).ToString("MM/dd/yyyy") + " " + Convert.ToDateTime(DC.ColumnName).ToString("hh:mm tt") + "</h4></td>");
                                        }
                                    }


                                    int fixedColumns = 5 - dtFlowSheet.Columns.Count;

                                    for (int cnt = 1; cnt <= fixedColumns; cnt++)
                                    {
                                        sb.Append("<td class='dxgvHeader' style='width:120px;padding:4px; border-left:solid 1px black;border-bottom:solid 1px black;border-right:solid 1px black;border-top:solid 2px black;' >&nbsp;</td>");
                                    }


                                    sb.Append("</tr></table></div>");
                                    sb.Append("<div ID='div_DynamicFlowSheet' onscroll='syncScrolls();' style='overflow: auto; position: static; width: 850px;'>");
                                    sb.Append("<table id='table_DynamicFlowSheet' border='0' cellpadding='0' cellspacing='0'  style='border-left:solid 1px black; border-right:solid 1px black; border-bottom:solid 1px black'>");
                                }

                                sb.Append("<tr>");
                                counter = 0;
                                _rowheader = 0;
                                HeaderText = dtFlowSheet.Rows[repeatItem.ItemIndex][1].ToString();
                                if (HeaderText.ToUpper() == "HEADER")
                                {
                                    sb.Append("<tr HeaderRow='HeaderRow'><td style='float:left;font-weight:bold;padding:4px 0px 4px 4px'>" + dtFlowSheet.Rows[repeatItem.ItemIndex][0].ToString() + "</td></tr>");
                                }
                                else
                                {
                                    sb.Append("<tr NonHeader='NonHeader'>");

                                    foreach (DataColumn DC in dtFlowSheet.Columns)
                                    {
                                        DataRow[] rows = dataSetFlowSheet.Tables["ClientHealthDataAttributes"].Select("Description='" + Convert.ToString(dtFlowSheet.Rows[repeatItem.ItemIndex][0]) + "'");
                                        if (rows.Length > 0)
                                        {
                                            LabelClass = counter == 0 ? "dxgvHeader" : "form_label";
                                            CursorType = counter == 0 ? "cursor:default" : "cursor:default";
                                            string AttributeDetails = string.Empty;
                                            string HealthDataSubTemplateName = string.Empty;
                                            string Units = string.Empty;

                                            Int32 clientHealthDataAttributeId = Convert.ToInt32(dataSetFlowSheet.Tables["ClientHealthDataAttributes"].Select("Description='" + Convert.ToString(dtFlowSheet.Rows[repeatItem.ItemIndex][0]) + "'")[0]["HealthDataAttributeId"]);

                                             HealthDataSubTemplateName = dataSetFlowSheet.Tables["ClientHealthDataAttributes"].Select("Description='" + Convert.ToString(dtFlowSheet.Rows[repeatItem.ItemIndex][0]) + "'")[0]["HealthDataSubTemplateName"].ToString();

                                             Int32.TryParse(dataSetFlowSheet.Tables["ClientHealthDataAttributes"].Select("Description='" + Convert.ToString(dtFlowSheet.Rows[repeatItem.ItemIndex][0]) + "'")[0]["Units"].ToString(), out HealthDataUnits);

                                            if (HealthDataUnits != 0)
                                            {
                                               
                                                Units = GetUnitTypeName(HealthDataUnits);

                                            }

                                            if (DC.ColumnName.Trim() != "")
                                            {
                                                DataRow[] drSelectedAttr = dataSetFlowSheet.Tables["SelectedAttributeDetails"].Select("HealthDataAttributeId=" + clientHealthDataAttributeId);
                                                foreach (DataRow dr in drSelectedAttr)
                                                {
                                                    if (Convert.ToDateTime(dr["HealthRecordDate"]).ToString("MM/dd/yyyy hh:mm tt") == Convert.ToDateTime(DC.ColumnName).ToString("MM/dd/yyyy hh:mm tt"))
                                                    {
                                                        AttributeDetails = Convert.ToString(dr["SelectedAttributeDetails"]);
                                                    }
                                                }
                                            }

                                            if (_rowheader == 0)
                                            {
                                                if (Session["HealthData"] == null)
                                                {
                                                    Session["HealthData"] = "Start";
                                                }
                                                //Type
                                                if (Session["HealthData"].ToString() != HealthDataSubTemplateName)
                                                {
                                                    if (HealthDataSubTemplateName.Length > 20)
                                                    {

                                                        sb.Append("<td class='" + LabelClass + "' style='padding:4px;border-left:solid 1px black; border-right:solid 1px black;border-top:solid 1px black;width:100px;" + CursorType + "' Title='" + HealthDataSubTemplateName + "'><div style='width:100px'>" + BaseCommonFunctions.cutText(HealthDataSubTemplateName, 20) + "</div></td>");

                                                    }
                                                    else
                                                    {
                                                        sb.Append("<td class='" + LabelClass + "' style='padding:4px;border-left:solid 1px black; border-right:solid 1px black;border-top:solid 1px black;width:100px;" + CursorType + "'><div style='width:100px'>" + HealthDataSubTemplateName + "</div></td>");

                                                    }
                                                    
                                                    Session["HealthData"] = HealthDataSubTemplateName;
                                                }
                                                else
                                                {
                                                    sb.Append("<td style='padding:4px;border-left:solid 1px black; border-right:solid 1px black;'></td>");

                                                }
                                                
                                                //Items
                                                if (dtFlowSheet.Rows[repeatItem.ItemIndex][DC.Ordinal].ToString().Length > 20)
                                                {

                                                    sb.Append("<td class='" + LabelClass + "'style='padding:4px;border:solid 1px black;width:120px;" + CursorType + "' Title='" + dtFlowSheet.Rows[repeatItem.ItemIndex][DC.Ordinal].ToString() + "'><div style='width:100px'>" + BaseCommonFunctions.cutText(dtFlowSheet.Rows[repeatItem.ItemIndex][DC.Ordinal].ToString(), 20) + "</div></td>");
                                                }
                                                else
                                                {

                                                    sb.Append("<td class='" + LabelClass + "'style='padding:4px;border:solid 1px black;width:120px;" + CursorType + "'><div style='width:100px'>" + dtFlowSheet.Rows[repeatItem.ItemIndex][DC.Ordinal].ToString() + "</div></td>");

                                                }
                                            }
                                            else
                                            {
                                                if (AttributeDetails.Length > 0)
                                                {
                                                    string colorName = string.Empty;
                                                    try
                                                    {
                                                        double n;
                                                        bool isdouble = double.TryParse(dtFlowSheet.Rows[repeatItem.ItemIndex][DC.Ordinal].ToString(), out n);
                                                        if (isdouble)
                                                        {
                                                            colorName = GetHealthDataAttributeRange(dataSetFlowSheet, dtFlowSheet.Rows[repeatItem.ItemIndex][0].ToString(), Convert.ToDouble(dtFlowSheet.Rows[repeatItem.ItemIndex][DC.Ordinal].ToString()));
                                                        }
                                                    }
                                                    catch (Exception ex)
                                                    {
                                                        colorName = "";
                                                    }
                                                    if (colorName == "")
                                                        colorName = "Black";
                                                    else if (colorName == "Yellow")
                                                        colorName = "#d3c012";
                                                    else if (colorName == "Red")
                                                        colorName = "#D52424";
                                                    else if (colorName == "Green")
                                                        colorName = "#22A833";

                                                    if (dtFlowSheet.Rows[repeatItem.ItemIndex][DC.Ordinal].ToString().Length > 15)
                                                    {
                                                       if(Units !=null)
                                                           sb.Append("<td class='" + LabelClass + "'style='padding:4px;border:solid 1px black;width:120px;" + CursorType + "' Title='" + dtFlowSheet.Rows[repeatItem.ItemIndex][DC.Ordinal].ToString() + "'><div style='width:100px;color:" + colorName + "'>" + BaseCommonFunctions.cutText(dtFlowSheet.Rows[repeatItem.ItemIndex][DC.Ordinal].ToString(), 15) +" " + Units + "</div></td>");
                                                           else
                                                           sb.Append("<td class='" + LabelClass + "'style='padding:4px;border:solid 1px black;width:120px;" + CursorType + "' Title='" + dtFlowSheet.Rows[repeatItem.ItemIndex][DC.Ordinal].ToString() + "'><div style='width:100px;color:" + colorName + "'>" + BaseCommonFunctions.cutText(dtFlowSheet.Rows[repeatItem.ItemIndex][DC.Ordinal].ToString(), 15) + "</div></td>");
                                                    }
                                                    else
                                                    {
                                                        if(Units !=null)
                                                            sb.Append("<td class='" + LabelClass + "'style='padding:4px;border:solid 1px black;width:120px;" + CursorType + "'  SelectedAttributeDetails='" + AttributeDetails + "'><div style='width:100px;color:" + colorName + "'>" + dtFlowSheet.Rows[repeatItem.ItemIndex][DC.Ordinal].ToString() +" " +Units+ "</div></td>");

                                                        else
                                                        sb.Append("<td class='" + LabelClass + "'style='padding:4px;border:solid 1px black;width:120px;" + CursorType + "'   SelectedAttributeDetails='" + AttributeDetails + "'><div style='width:100px;color:" + colorName + "'>" + dtFlowSheet.Rows[repeatItem.ItemIndex][DC.Ordinal].ToString() + "</div></td>");
                                                    }
                                                }
                                                else
                                                {
                                                    if (dtFlowSheet.Rows[repeatItem.ItemIndex][DC.Ordinal].ToString().Length > 15)
                                                    {
                                                         sb.Append("<td class='" + LabelClass + "'style='padding:4px;border:solid 1px black;width:120px;" + CursorType + "' Title='" + dtFlowSheet.Rows[repeatItem.ItemIndex][DC.Ordinal].ToString() + "'><div style='width:100px'>" + BaseCommonFunctions.cutText(dtFlowSheet.Rows[repeatItem.ItemIndex][DC.Ordinal].ToString(), 15) + "</div></td>");
                                                    }
                                                    else
                                                    {
                                                       sb.Append("<td class='" + LabelClass + "'style='padding:4px;border:solid 1px black;width:120px;" + CursorType + "'  SelectedAttributeDetails='&nbsp;' ><div style='width:100px'>" + dtFlowSheet.Rows[repeatItem.ItemIndex][DC.Ordinal].ToString() + "</div></td>");
                                                    }
                                                }
                                            }
                                            counter = 1;
                                            _rowheader = _rowheader + 1;
                                        }
                                    }

                                    if (dtFlowSheet.Columns.Count > 0)
                                    {
                                        int fixedColumns = 5 - dtFlowSheet.Columns.Count;

                                        for (int cnt = 1; cnt <= fixedColumns; cnt++)
                                        {
                                            sb.Append("<td class='form_label' style='padding:4px;border:solid 1px black;width:120px;cursor:default' SelectedAttributeDetails='&nbsp;'><div style='width:100px'></div></td>");
                                        }
                                    }
                                }

                                sb.Append("</tr>");

                                if (repeatItem.ItemIndex + 1 == Repeater_FlowSheet.Items.Count)
                                {
                                    sb.Append("</table></div>");
                                    Literal literalHtml = new Literal();
                                    literalHtml.Text = sb.ToString();
                                    repeatItem.Controls.Add(literalHtml);
                                }

                            }
                        }
                        else
                        {
                            sb.Append("<table width='807px' cellpadding='1' cellspacing='1'>");
                            sb.Append("<tr height='200px'>");
                            sb.Append("<td style='padding:4px;border:solid 1px black;font-size:larger;color:Red;font-weight:bold;vertical-align:middle; font-family:Arial;' align='center'>");
                            sb.Append("No data found for the client");
                            sb.Append("</td>");
                            sb.Append("</tr>");
                            sb.Append("</table>");
                        }
                        return sb.ToString();

            #endregion
                       
                   // }

        }


        private string GetHealthDataAttributeRange(DataSet datasetFlowSheet, string attributeName, double attributeValue)
        {
            double minRange = 0, maxRange = 0, grapCriteriaRangeValue = 0;
            int healthDataGraphCriteriaId = 0;
            string colorName = string.Empty;
            DataRow[] drGrapCriteria = datasetFlowSheet.Tables["HealthDataCriteria"].Select("Description='" + attributeName + "'");
            if (drGrapCriteria.Length > 0)
            {
                healthDataGraphCriteriaId = Convert.ToInt32(drGrapCriteria[0]["HealthDataGraphCriteriaId"]);
                minRange = Convert.ToDouble(drGrapCriteria[0]["MinimumValue"]);
                maxRange = Convert.ToDouble(drGrapCriteria[0]["MaximumValue"]);


                if (attributeValue <= maxRange && attributeValue >= minRange)
                    grapCriteriaRangeValue = attributeValue;
                else if (attributeValue > maxRange)
                    grapCriteriaRangeValue = maxRange;
                else if (attributeValue < minRange)
                    grapCriteriaRangeValue = minRange;

                DataRow[] drGrapCriteriaRange = datasetFlowSheet.Tables["HealthDataCriteriaRanges"].Select("HealthDataGraphCriteriaId=" + healthDataGraphCriteriaId.ToString() + " and MinimumValue <=" + grapCriteriaRangeValue.ToString() + " AND MaximumValue >=" + grapCriteriaRangeValue.ToString());
                if (drGrapCriteriaRange.Length > 0)
                    colorName = drGrapCriteriaRange[0]["Color"].ToString();
            }
            return colorName;
        }

        private void ShowHidePanel(string startIdentifer, string endIdentifier, string responseText)
        {
            Literal literalStart = new Literal();
            Literal literalEnd = new Literal();
            Literal literalResponseText = new Literal();

            literalStart.Text = startIdentifer;
            literalEnd.Text = endIdentifier;
            literalResponseText.Text = responseText;

            //Add in Panel from start to end identifier
            PanelAjax.Controls.Add(literalStart);
            PanelAjax.Controls.Add(literalResponseText);
            PanelAjax.Controls.Add(literalEnd);
            //PanelMain.Visible = false;
            PanelAjax.Visible = true;
        }



        public DataSet GetClientFlowSheetData(int ClientId, int HealthDataTemplateId, DateTime StartDate, DateTime EndDate)
        {
            DataSet dataSetClientFlowSheet = null;
            SqlParameter[] _objectSqlParmeters = null;
            try
            {
                dataSetClientFlowSheet = new DataSet();
                _objectSqlParmeters = new SqlParameter[4];
                _objectSqlParmeters[0] = new SqlParameter("@ClientId", ClientId);
                _objectSqlParmeters[1] = new SqlParameter("@HealthDataTemplateId", HealthDataTemplateId);
                _objectSqlParmeters[2] = new SqlParameter("@StartDate", StartDate);
                if (StartDate == DateTime.MinValue)
                    _objectSqlParmeters[2].Value = DBNull.Value;
                _objectSqlParmeters[3] = new SqlParameter("@EndDate", EndDate);
                if (EndDate == DateTime.MaxValue)
                    _objectSqlParmeters[3].Value = DBNull.Value;

                SqlHelper.FillDataset(Connection.ConnectionString, CommandType.StoredProcedure, "csp_GetClientHealthData", dataSetClientFlowSheet, new string[] { "HealthDataTemplates", "HDAttrWithGraphCriteria", "HealthRecordDates", "TotalHealthDataAttributes", "ClientHealthDataAttributes", "SelectedAttributeDetails", "HealthDataCriteria", "HealthDataCriteriaRanges" }, _objectSqlParmeters);
                return dataSetClientFlowSheet;
            }
            finally
            {
                if (dataSetClientFlowSheet != null) dataSetClientFlowSheet.Dispose();
                _objectSqlParmeters = null;
            }
        }

        public string GetUnitTypeName(int unitType)
        {
            string _unitTypeName = string.Empty;
            if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes != null)
            {
                DataView dataViewPrograms = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
                dataViewPrograms.RowFilter = "GlobalCodeId=" + unitType.ToString() + " and Active='Y' and ISNULL(RecordDeleted,'N')='N'";
                if (dataViewPrograms.Count > 0)
                    _unitTypeName = Convert.ToString(dataViewPrograms[0]["CodeName"]);
            }
            return _unitTypeName;
        }



        // For Vitals End






        public override void ChangeDataSetBeforeUpdate(ref DataSet dataSetObject)
        {
            string GCName = string.Empty;
            int AcuteCount = 0;
            int ChronicCount = 0;
            int statusNew = 0;
            int StatusNewAdditional = 0;
            if (dataSetObject.Tables["CustomDocumentPsychiatricNoteGenerals"].IsRowExists())
            {
                int DocVesrionId = Convert.ToInt32(dataSetObject.Tables["CustomDocumentPsychiatricNoteGenerals"].Rows[0]["DocumentVersionId"]);
                if (DocVesrionId < 0)
                {
                    for (int j = 0; j < dataSetObject.Tables["ExternalReferralProviders"].Rows.Count; j++)
                    {

                        DataRow drnewCustomExternalProvider = dataSetObject.Tables["CustomPsychiatricPCPProviders"].NewRow();
                        drnewCustomExternalProvider.Table.DataSet.Tables["CustomPsychiatricPCPProviders"].Columns["PsychiatricPCPProviderId"].ReadOnly = false;
                        drnewCustomExternalProvider["ExternalReferralProviderId"] = dataSetObject.Tables["ExternalReferralProviders"].Rows[j]["ExternalProviderId"];
                        drnewCustomExternalProvider["DocumentVersionId"] = DocVesrionId;
                        if (dataSetObject.Tables["ExternalReferralProviders"].Rows[j]["RecordDeleted"].ToString() == "Y")
                        {
                            drnewCustomExternalProvider["RecordDeleted"] = dataSetObject.Tables["ExternalReferralProviders"].Rows[j]["RecordDeleted"];
                        }
                        BaseCommonFunctions.InitRowCredentials(drnewCustomExternalProvider);
                        dataSetObject.Tables["CustomPsychiatricPCPProviders"].Rows.Add(drnewCustomExternalProvider);

                    }
                }
            }
            if (dataSetObject.Tables["CustomPsychiatricNoteProblems"].IsRowExists() && dataSetObject.Tables["NoteEMCodeOptions"].IsRowExists())
            {
                for (int j = 0; j < dataSetObject.Tables["CustomPsychiatricNoteProblems"].Rows.Count; j++)
                {
                    if (dataSetObject.Tables["CustomPsychiatricNoteProblems"].Rows[j]["RecordDeleted"].ToString() != "Y" && dataSetObject.Tables["CustomPsychiatricNoteProblems"].Rows[j]["TypeOfProblem"] != null)
                    {
                        if (dataSetObject.Tables["CustomPsychiatricNoteProblems"].Rows[j]["TypeOfProblem"] != DBNull.Value)
                            GCName = Convert.ToString(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes.Select("GlobalCodeId=" + dataSetObject.Tables["CustomPsychiatricNoteProblems"].Rows[j]["TypeOfProblem"])[0]["CodeName"]);
                        if (GCName == "Acute")
                        {
                            AcuteCount = AcuteCount + 1;
                        }
                        if (GCName == "Chronic")
                        {
                            ChronicCount = ChronicCount + 1;
                        }


                        if (dataSetObject.Tables["CustomPsychiatricNoteProblems"].Rows[j]["ProblemStatus"] != DBNull.Value)
                            GCName = Convert.ToString(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes.Select("GlobalCodeId=" + dataSetObject.Tables["CustomPsychiatricNoteProblems"].Rows[j]["ProblemStatus"])[0]["CodeName"]);
                        if (GCName == "New")
                        {
                            statusNew = statusNew + 1;
                        }
                        if (GCName == "New - Additional Work Up")
                        {
                            StatusNewAdditional = StatusNewAdditional + 1;
                        }

                    }
                }

                if (statusNew > 0)
                {
                    dataSetObject.Tables["NoteEMCodeOptions"].Rows[0]["MDMDTONewProblem"] = "Y";
                }
                else
                {
                    dataSetObject.Tables["NoteEMCodeOptions"].Rows[0]["MDMDTONewProblem"] = "N";
                }


                if (StatusNewAdditional > 0)
                {
                    dataSetObject.Tables["NoteEMCodeOptions"].Rows[0]["MDMDTONewProblem"] = "Y";
                    dataSetObject.Tables["NoteEMCodeOptions"].Rows[0]["MDMDTOAdditionalWorkup"] = "Y";
                }
                else
                {
                    dataSetObject.Tables["NoteEMCodeOptions"].Rows[0]["MDMDTOAdditionalWorkup"] = "N";
                    if (statusNew < 0)
                    {
                        dataSetObject.Tables["NoteEMCodeOptions"].Rows[0]["MDMDTONewProblem"] = "N";
                    }
                }

                if (AcuteCount > 0)
                {
                    dataSetObject.Tables["NoteEMCodeOptions"].Rows[0]["MDMRCMMPPAcuteUncomplicated1"] = "Y";
                }
                else
                {
                    dataSetObject.Tables["NoteEMCodeOptions"].Rows[0]["MDMRCMMPPAcuteUncomplicated1"] = "N";
                }
                if (ChronicCount > 0)
                {
                    dataSetObject.Tables["NoteEMCodeOptions"].Rows[0]["MDMRCMMPPStableChronicMajor1"] = "Y";
                }
                else
                {
                    dataSetObject.Tables["NoteEMCodeOptions"].Rows[0]["MDMRCMMPPStableChronicMajor1"] = "N";
                }
            }
            //Added defensive code to avoid error in any case if audit columns like CreatedBy, CreatedDate, ModifiedBy and ModifiedDate are Null in ServiceDiagnosis table. Ref: #802 A Renewed Mind - Support.
            if (dataSetObject != null)
            {
                if (BaseCommonFunctions.CheckRowExists(dataSetObject, "ServiceDiagnosis", 0))
                {
                    for (int i = 0; i < dataSetObject.Tables["ServiceDiagnosis"].Rows.Count; i++)
                    {
                        if (String.IsNullOrEmpty(dataSetObject.Tables["ServiceDiagnosis"].Rows[i]["CreatedBy"].ToString()))
                            dataSetObject.Tables["ServiceDiagnosis"].Rows[i]["CreatedBy"] = BaseCommonFunctions.ApplicationInfo.LoggedInUser.UserCode;
                        if (String.IsNullOrEmpty(dataSetObject.Tables["ServiceDiagnosis"].Rows[i]["CreatedDate"].ToString()))
                            dataSetObject.Tables["ServiceDiagnosis"].Rows[i]["CreatedDate"] = DateTime.Now;
                        if (String.IsNullOrEmpty(dataSetObject.Tables["ServiceDiagnosis"].Rows[i]["ModifiedBy"].ToString()))
                            dataSetObject.Tables["ServiceDiagnosis"].Rows[i]["ModifiedBy"] = BaseCommonFunctions.ApplicationInfo.LoggedInUser.UserCode;
                        if (String.IsNullOrEmpty(dataSetObject.Tables["ServiceDiagnosis"].Rows[i]["ModifiedDate"].ToString()))
                            dataSetObject.Tables["ServiceDiagnosis"].Rows[i]["ModifiedDate"] = DateTime.Now;
                    }
                }
            }


            try
            {
                if (dataSetObject.Tables["CustomDocumentPsychiatricAIMSs"].IsRowExists())
                {
                    if (dataSetObject.Tables["CustomDocumentPsychiatricAIMSs"].Columns.Contains("PreviousMuscleFacialExpression"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricAIMSs"].Columns.Remove("PreviousMuscleFacialExpression");
                    }
                    if (dataSetObject.Tables["CustomDocumentPsychiatricAIMSs"].Columns.Contains("PreviousLipsPerioralArea"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricAIMSs"].Columns.Remove("PreviousLipsPerioralArea");
                    }
                    if (dataSetObject.Tables["CustomDocumentPsychiatricAIMSs"].Columns.Contains("PreviousJaw"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricAIMSs"].Columns.Remove("PreviousJaw");
                    }
                    if (dataSetObject.Tables["CustomDocumentPsychiatricAIMSs"].Columns.Contains("PreviousTongue"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricAIMSs"].Columns.Remove("PreviousTongue");
                    }
                    if (dataSetObject.Tables["CustomDocumentPsychiatricAIMSs"].Columns.Contains("PreviousExtremityMovementsUpper"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricAIMSs"].Columns.Remove("PreviousExtremityMovementsUpper");
                    }
                    if (dataSetObject.Tables["CustomDocumentPsychiatricAIMSs"].Columns.Contains("PreviousExtremityMovementsLower"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricAIMSs"].Columns.Remove("PreviousExtremityMovementsLower");
                    }
                    if (dataSetObject.Tables["CustomDocumentPsychiatricAIMSs"].Columns.Contains("PreviousNeckShouldersHips"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricAIMSs"].Columns.Remove("PreviousNeckShouldersHips");
                    }
                    if (dataSetObject.Tables["CustomDocumentPsychiatricAIMSs"].Columns.Contains("PreviousSeverityAbnormalMovements"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricAIMSs"].Columns.Remove("PreviousSeverityAbnormalMovements");
                    }

                    if (dataSetObject.Tables["CustomDocumentPsychiatricAIMSs"].Columns.Contains("PreviousIncapacitationAbnormalMovements"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricAIMSs"].Columns.Remove("PreviousIncapacitationAbnormalMovements");
                    }
                    if (dataSetObject.Tables["CustomDocumentPsychiatricAIMSs"].Columns.Contains("PreviousPatientAwarenessAbnormalMovements"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricAIMSs"].Columns.Remove("PreviousPatientAwarenessAbnormalMovements");
                    }

                    if (dataSetObject.Tables["CustomDocumentPsychiatricAIMSs"].Columns.Contains("PreviousCurrentProblemsTeeth"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricAIMSs"].Columns.Remove("PreviousCurrentProblemsTeeth");
                    }

                    if (dataSetObject.Tables["CustomDocumentPsychiatricAIMSs"].Columns.Contains("PreviousDoesPatientWearDentures"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricAIMSs"].Columns.Remove("PreviousDoesPatientWearDentures");
                    }
                    if (dataSetObject.Tables["CustomDocumentPsychiatricAIMSs"].Columns.Contains("PreviousAIMSTotalScore"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricAIMSs"].Columns.Remove("PreviousAIMSTotalScore");
                    }

                    if (dataSetObject.Tables["CustomDocumentPsychiatricAIMSs"].Columns.Contains("PreviousAIMSPositveNegative"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricAIMSs"].Columns.Remove("PreviousAIMSPositveNegative");
                    }
                    if (dataSetObject.Tables["CustomDocumentPsychiatricAIMSs"].Columns.Contains("PreviousEffectiveDate"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricAIMSs"].Columns.Remove("PreviousEffectiveDate");
                    }
                }

                if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].IsRowExists())
                {
                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousGeneralPoorlyAddresses"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousGeneralPoorlyAddresses");
                    }
                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousGeneralPoorlyGroomed"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousGeneralPoorlyGroomed");
                    }

                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousGeneralDisheveled"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousGeneralDisheveled");
                    }
                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousGeneralOdferous"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousGeneralOdferous");
                    }
                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousGeneralDeformities"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousGeneralDeformities");
                    }
                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousGeneralPoorNutrion"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousGeneralPoorNutrion");
                    }

                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousGeneralRestless"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousGeneralRestless");
                    }
                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousGeneralPsychometer"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousGeneralPsychometer");
                    }
                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousGeneralHyperActive"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousGeneralHyperActive");
                    }
                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousGeneralEvasive"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousGeneralEvasive");
                    }

                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousGeneralInAttentive"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousGeneralInAttentive");
                    }
                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousGeneralPoorEyeContact"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousGeneralPoorEyeContact");
                    }
                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousGeneralHostile"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousGeneralHostile");
                    }
                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousSpeechIncreased"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousSpeechIncreased");
                    }

                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousSpeechDecreased"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousSpeechDecreased");
                    }
                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousSpeechPaucity"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousSpeechPaucity");
                    }
                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousSpeechHyperverbal"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousSpeechHyperverbal");
                    }
                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousSpeechPoorArticulations"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousSpeechPoorArticulations");
                    }

                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousSpeechLoud"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousSpeechLoud");
                    }
                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousSpeechSoft"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousSpeechSoft");
                    }
                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousSpeechMute"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousSpeechMute");
                    }

                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousSpeechStuttering"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousSpeechStuttering");
                    }

                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousSpeechImpaired"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousSpeechImpaired");
                    }
                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousSpeechPressured"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousSpeechPressured");
                    }
                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousSpeechFlight"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousSpeechFlight");
                    }
                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousLanguageDifficultyNaming"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousLanguageDifficultyNaming");
                    }

                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousLanguageDifficultyRepeating"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousLanguageDifficultyRepeating");
                    }
                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousMoodHappy"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousMoodHappy");
                    }
                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousMoodSad"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousMoodSad");
                    }
                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousMoodAnxious"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousMoodAnxious");
                    }

                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousMoodAngry"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousMoodAngry");
                    }
                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousMoodIrritable"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousMoodIrritable");
                    }
                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousMoodElation"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousMoodElation");
                    }
                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousMoodNormal"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousMoodNormal");
                    }

                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousAffectEuthymic"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousAffectEuthymic");
                    }
                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousAffectDysphoric"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousAffectDysphoric");
                    }
                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousAffectAnxious"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousAffectAnxious");
                    }
                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousAffectIrritable"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousAffectIrritable");
                    }

                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousAffectBlunted"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousAffectBlunted");
                    }
                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousAffectLabile"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousAffectLabile");
                    }
                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousAffectEuphoric"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousAffectEuphoric");
                    }
                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousAffectCongruent"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousAffectCongruent");
                    }

                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousAttensionPoorConcentration"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousAttensionPoorConcentration");
                    }
                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousAttensionPoorAttension"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousAttensionPoorAttension");
                    }
                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousAttensionDistractible"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousAttensionDistractible");
                    }
                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousTPDisOrganised"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousTPDisOrganised");
                    }

                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousTPBlocking"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousTPBlocking");
                    }
                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousTPPersecution"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousTPPersecution");
                    }
                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousTPBroadCasting"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousTPBroadCasting");
                    }
                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousTPDetrailed"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousTPDetrailed");
                    }

                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousTPThoughtinsertion"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousTPThoughtinsertion");
                    }
                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousTPIncoherent"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousTPIncoherent");
                    }


                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousTPRacing"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousTPRacing");
                    }
                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousTPIllogical"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousTPIllogical");
                    }


                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousTCDelusional"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousTCDelusional");
                    }
                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousTCParanoid"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousTCParanoid");
                    }

                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousTCIdeas"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousTCIdeas");
                    }
                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousTCThoughtInsertion"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousTCThoughtInsertion");
                    }

                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousTCThoughtWithdrawal"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousTCThoughtWithdrawal");
                    }
                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousTCThoughtBroadcasting"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousTCThoughtBroadcasting");
                    }

                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousTCReligiosity"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousTCReligiosity");
                    }
                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousTCGrandiosity"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousTCGrandiosity");
                    }

                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousTCPerserveration"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousTCPerserveration");
                    }
                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousTCObsessions"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousTCObsessions");
                    }

                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousTCWorthlessness"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousTCWorthlessness");
                    }
                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousTCLoneliness"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousTCLoneliness");
                    }

                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousTCGuilt"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousTCGuilt");
                    }
                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousTCHopelessness"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousTCHopelessness");
                    }

                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousTCHelplessness"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousTCHelplessness");
                    }
                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousCAPoorKnowledget"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousCAPoorKnowledget");
                    }

                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousCAConcrete"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousCAConcrete");
                    }
                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousCAUnable"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousCAUnable");
                    }

                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousCAPoorComputation"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousCAPoorComputation");
                    }
                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousAssociationsLoose"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousAssociationsLoose");
                    }

                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousAssociationsClanging"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousAssociationsClanging");
                    }
                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousAssociationsWordsalad"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousAssociationsWordsalad");
                    }

                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousAssociationsCircumstantial"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousAssociationsCircumstantial");
                    }
                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousAssociationsTangential"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousAssociationsTangential");
                    }

                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousPDAuditoryHallucinations"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousPDAuditoryHallucinations");
                    }
                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousPDVisualHallucinations"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousPDVisualHallucinations");
                    }


                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousPDCommandHallucinations"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousPDCommandHallucinations");
                    }
                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousPDDelusions"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousPDDelusions");
                    }

                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousPDPreoccupation"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousPDPreoccupation");
                    }
                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousPDOlfactoryHallucinations"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousPDOlfactoryHallucinations");
                    }

                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousPDGustatoryHallucinations"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousPDGustatoryHallucinations");
                    }
                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousPDTactileHallucinations"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousPDTactileHallucinations");
                    }

                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousPDSomaticHallucinations"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousPDSomaticHallucinations");
                    }
                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousPDIllusions"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousPDIllusions");
                    }


                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousOrientationPerson"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousOrientationPerson");
                    }
                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousOrientationPlace"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousOrientationPlace");
                    }

                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousOrientationTime"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousOrientationTime");
                    }
                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousOrientationSituation"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousOrientationSituation");
                    }


                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousFundOfKnowledgeCurrentEvents"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousFundOfKnowledgeCurrentEvents");
                    }
                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousFundOfKnowledgePastHistory"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousFundOfKnowledgePastHistory");
                    }

                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousFundOfKnowledgeVocabulary"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousFundOfKnowledgeVocabulary");
                    }
                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousInsightAndJudgementSubstance"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousInsightAndJudgementSubstance");
                    }


                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousMuscleStrengthorToneAtrophy"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousMuscleStrengthorToneAtrophy");
                    }
                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousMuscleStrengthorToneAbnormal"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousMuscleStrengthorToneAbnormal");
                    }

                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousGaitandStationRestlessness"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousGaitandStationRestlessness");
                    }
                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousGaitandStationStaggered"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousGaitandStationStaggered");
                    }

                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousGaitandStationShuffling"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousGaitandStationShuffling");
                    }
                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Contains("PreviousGaitandStationUnstable"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteExams"].Columns.Remove("PreviousGaitandStationUnstable");
                    }
                }

            }
            catch (Exception ex)
            {

            }


            try
            {
                if (dataSetObject.Tables["CustomDocumentPsychiatricNoteGenerals"].IsRowExists())
                {
                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteGenerals"].Columns.Contains("Sex"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteGenerals"].Columns.Remove("Sex");
                    }

                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteGenerals"].Columns.Contains("Age"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteGenerals"].Columns.Remove("Age");
                    }

                    if (dataSetObject.Tables["CustomDocumentPsychiatricNoteGenerals"].Columns.Contains("LatestDocumentVersionID"))
                    {
                        dataSetObject.Tables["CustomDocumentPsychiatricNoteGenerals"].Columns.Remove("LatestDocumentVersionID");
                    }
                }
            }
            catch (Exception e)
            {

            }

            if (dataSetObject.Tables.Contains("CustomDocumentPsychiatricNoteMDMs"))
            {
                if (dataSetObject.Tables["CustomDocumentPsychiatricNoteMDMs"].Rows.Count > 1)
                {
                    int looplength = dataSetObject.Tables["CustomDocumentPsychiatricNoteMDMs"].Rows.Count;
                    for (int i = looplength - 1; i >= 1; i--)
                    {
                        if (i != 0 && i > 0)
                            dataSetObject.Tables["CustomDocumentPsychiatricNoteMDMs"].Rows.RemoveAt(i);
                    }
                }
            }
           


        }

        public override void ChangeDataSetAfterGetData()
        {

            DataSet ds = BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet;

        }

        public override void BindControls()
        {
            GetProcedureCodesFromRecodes();
        }
		
		private void GetProcedureCodesFromRecodes()
        {
            DataSet dsProcedureCodes = new DataSet();
            SqlHelper.FillDataset(Connection.ConnectionString, CommandType.StoredProcedure, "csp_GetEAndMProcedureCodes", dsProcedureCodes, new string[] { "ProcedureCodes" });
            if (dsProcedureCodes != null && dsProcedureCodes.Tables["ProcedureCodes"].Rows.Count > 0)
            {
                hiddenProcedureCodes.Value = dsProcedureCodes.Tables["ProcedureCodes"].Rows[0][0].ToString();
            }
        }
        

    }

}

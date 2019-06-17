using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using Streamline.UserBusinessServices;
using Streamline.BaseLayer;
using System.Text;
using System.Drawing;
using System.IO;
using System.Collections.Generic;
using System.ComponentModel;
namespace Streamline.SmartClient.UI
{
    public partial class UserControls_ConsentHistoryList : Streamline.BaseLayer.BaseActivityPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        #region--Global Variables and properties---
        private string _sortString;
        public string SortString
        {
            get { return _sortString; }
            set { _sortString = value; }
        }
        #endregion
        Streamline.UserBusinessServices.DataSets.MedicationList.MedicationsDataTable _dtMedicationTemp = null;
        Streamline.UserBusinessServices.DataSets.MedicationList.MedicationInstructionsDataTable _dtMedicationInstructionTemp = null;
        #region--User Defined Function----
        /// <summary>
        /// <Description></Description>
        /// <Author>Pradeep</Author>
        /// <CreatedOn>30 Oct 2009</CreatedOn>
        /// </summary>
        private void GenerateRows(DataTable dtClientMedication, DataTable dtClientMedicalInstructions)
        {
            try
            {
                this.PanelConsentList.Controls.Clear();
                Table tableMedication = new Table();
                tableMedication.ID = System.Guid.NewGuid().ToString();
                tableMedication.Width = new Unit(100,UnitType.Percentage);
                TableHeaderRow tableHeaderRowTitle = new TableHeaderRow();
                //-----Medication----
                TableHeaderCell tblheadCell = new TableHeaderCell();
                TableHeaderCell tableHeaderCellMedication = new TableHeaderCell();
                tableHeaderCellMedication.Text = "Medication Name";
                tableHeaderCellMedication.Attributes.Add("onClick", "onConsentHistoryHeaderClick(this)");
                tableHeaderCellMedication.Attributes.Add("ColumnName", "MedicationName");
                tableHeaderCellMedication.Attributes.Add("SortOrder", setAttributes());
                if (_sortString.Contains("MedicationName")) tblheadCell = tableHeaderCellMedication;
                if (dtClientMedicalInstructions!=null)
                {
                    if (dtClientMedicalInstructions.Rows.Count>1)
                    {
                        tableHeaderCellMedication.CssClass = "handStyle";
                        tableHeaderCellMedication.Font.Underline = true;
                    }
                }
                //-----Active-----------
                TableHeaderCell tableHeaderCellActive = new TableHeaderCell();
                tableHeaderCellActive.Text = "Active";
                tableHeaderCellActive.Attributes.Add("onClick", "onConsentHistoryHeaderClick(this)");
                tableHeaderCellActive.Attributes.Add("ColumnName", "Active");
                tableHeaderCellActive.Attributes.Add("SortOrder", setAttributes());
                if (_sortString.Contains("Active")) tblheadCell = tableHeaderCellActive;
                if (dtClientMedicalInstructions!=null)
                {
                    if (dtClientMedicalInstructions.Rows.Count > 1)
                   {
                       tableHeaderCellActive.CssClass = "handStyle";
                       tableHeaderCellActive.Font.Underline = true;
                   }
                }
                //-----OffLabel-----------
                TableHeaderCell tableHeaderCellOffLabel = new TableHeaderCell();
                //Code Added by : Malathi Shiva 
                //With Ref to task# : 33 - Community Network Services
                if (((Streamline.BaseLayer.StreamlinePrinciple)Context.User).HasPermission(Permissions.OffLabel) != false)
                {
                    tableHeaderCellOffLabel.Text = "Off Label";
                    tableHeaderCellOffLabel.Attributes.Add("onClick", "onConsentHistoryHeaderClick(this)");
                    tableHeaderCellOffLabel.Attributes.Add("ColumnName", "OffLabel");
                    tableHeaderCellOffLabel.Attributes.Add("SortOrder", setAttributes());
                    if (_sortString.Contains("OffLabel")) tblheadCell = tableHeaderCellOffLabel;
                    if (dtClientMedicalInstructions != null)
                    {
                        if (dtClientMedicalInstructions.Rows.Count > 1)
                        {
                            tableHeaderCellOffLabel.CssClass = "handStyle";
                            tableHeaderCellOffLabel.Font.Underline = true;
                        }
                    }
                }
                //-----Dosages/Schedule-----------
                TableHeaderCell tableHeaderCellDosages = new TableHeaderCell();
                tableHeaderCellDosages.Text = "Dosages/Directions";
                tableHeaderCellDosages.Attributes.Add("onClick", "onConsentHistoryHeaderClick(this)");
                tableHeaderCellDosages.Attributes.Add("ColumnName", "Instructions");
                tableHeaderCellDosages.Attributes.Add("SortOrder", setAttributes());
                if (_sortString.Contains("Instructions")) tblheadCell = tableHeaderCellDosages;
                if (dtClientMedicalInstructions!=null)
                {
                    if (dtClientMedicalInstructions.Rows.Count > 1)
                    {
                        tableHeaderCellDosages.CssClass = "handStyle";
                        tableHeaderCellDosages.Font.Underline = true;
                    }
                }
                //-----Consent Start Date-----------
                TableHeaderCell tableHeaderStartDate = new TableHeaderCell();
                tableHeaderStartDate.Text = "Consent Start Date";
                tableHeaderStartDate.Attributes.Add("onClick", "onConsentHistoryHeaderClick(this)");
                tableHeaderStartDate.Attributes.Add("ColumnName", "ConsentStartDate");
                tableHeaderStartDate.Attributes.Add("SortOrder", setAttributes());
                if (_sortString.Contains("ConsentStartDate")) tblheadCell = tableHeaderStartDate;
                if (dtClientMedicalInstructions!=null)
                {
                    if (dtClientMedicalInstructions.Rows.Count > 1)
                    {
                        tableHeaderStartDate.CssClass = "handStyle";
                        tableHeaderStartDate.Font.Underline = true;
                    }
                }
                //-----Consent End Date-----------
                TableHeaderCell tableHeaderEndDate = new TableHeaderCell();
                tableHeaderEndDate.Text = "Consent End Date";
                tableHeaderEndDate.Attributes.Add("onClick", "onConsentHistoryHeaderClick(this)");
                tableHeaderEndDate.Attributes.Add("ColumnName", "ConsentEndDate");
                tableHeaderEndDate.Attributes.Add("SortOrder", setAttributes());
                if (_sortString.Contains("ConsentEndDate")) tblheadCell = tableHeaderEndDate;
                if (dtClientMedicalInstructions!=null)
                {
                    if (dtClientMedicalInstructions.Rows.Count > 1)
                    {
                        tableHeaderEndDate.CssClass = "handStyle";
                        tableHeaderEndDate.Font.Underline = true;
                    }
                }
                //---
                tableHeaderRowTitle.Cells.Add(tableHeaderCellMedication);
                tableHeaderRowTitle.Cells.Add(tableHeaderCellActive);
                //Code Added by : Malathi Shiva 
                //With Ref to task# : 33 - Community Network Services
                if (((Streamline.BaseLayer.StreamlinePrinciple)Context.User).HasPermission(Permissions.OffLabel) != false)
                {
                    tableHeaderRowTitle.Cells.Add(tableHeaderCellOffLabel);
                }
                tableHeaderRowTitle.Cells.Add(tableHeaderCellDosages);
                tableHeaderRowTitle.Cells.Add(tableHeaderStartDate);
                tableHeaderRowTitle.Cells.Add(tableHeaderEndDate);
                tableHeaderRowTitle.CssClass = "GridViewHeaderText";
                tableMedication.Rows.Add(tableHeaderRowTitle);

                //---
                if (dtClientMedicalInstructions != null)
                {
                    DataView dvClientMedicationInstructions = new DataView(dtClientMedicalInstructions);
                    if (_sortString != string.Empty)
                    {
                        dvClientMedicationInstructions.Sort = _sortString;
                    }
                    DataTable dtMedicationInstructionTemp = dvClientMedicationInstructions.ToTable();
                    if (dvClientMedicationInstructions.Count > 0)
                    {
                        if (dtMedicationInstructionTemp.Rows.Count > 1)
                        {
                            if (_sortString.Substring(_sortString.Length - 3) == "Asc")
                                tblheadCell.Style.Add("background", "url(App_Themes/Includes/Images/ListPageUp.png) right no-repeat, url(App_Themes/Includes/Images/list_grid_header_bg.gif) left repeat-x");
                            else
                                tblheadCell.Style.Add("background", "url(App_Themes/Includes/Images/ListPageDown.png) right no-repeat, url(App_Themes/Includes/Images/list_grid_header_bg.gif) left repeat-x");
                        }
                        var rowcss = "GridViewRowStyle";
                        foreach (DataRow drClientConsent in dtMedicationInstructionTemp.Rows)
                        {
                            string MedicationName = drClientConsent["MedicationName"] == DBNull.Value ? "" : Convert.ToString(drClientConsent["MedicationName"]);
                            string Active = drClientConsent["Active"] == DBNull.Value ? "" : Convert.ToString(drClientConsent["Active"]);
                            //Code Added by : Malathi Shiva 
                            //With Ref to task# : 33 - Community Network Services
                            string OffLabel = "";
                            if (((Streamline.BaseLayer.StreamlinePrinciple)Context.User).HasPermission(Permissions.OffLabel) != false)
                            {
                                OffLabel = drClientConsent["OffLabel"] == DBNull.Value ? "" : Convert.ToString(drClientConsent["OffLabel"]);
                            }
                            string ConsentEndDate = drClientConsent["ConsentEndDate"] == DBNull.Value ? "" : Convert.ToString(drClientConsent["ConsentEndDate"]);
                            string ConsentStartDate = drClientConsent["ConsentStartDate"] == DBNull.Value ? "" : Convert.ToString(drClientConsent["ConsentStartDate"]);
                            string Instruction = drClientConsent["Instructions"] == DBNull.Value ? "" : Convert.ToString(drClientConsent["Instructions"]);
                            DateTime dateTimeConsentStartDate = new DateTime();
                            DateTime dateTimeConsentEndDate = new DateTime();
                            if (ConsentStartDate != string.Empty)
                            {
                                ConsentStartDate = Convert.ToDateTime(ConsentStartDate).ToString("MM/dd/yyyy");
                            }
                            if (ConsentEndDate != string.Empty)
                            {
                                ConsentEndDate = Convert.ToDateTime(ConsentEndDate).ToString("MM/dd/yyyy");
                            }
                            // Table tableConsentHistory = new Table();
                            TableRow tableRowConsentHistory = new TableRow();
                            tableRowConsentHistory.CssClass = rowcss;
                           // tableRowConsentHistory.CssClass = "GridViewRowStyle";
                            TableCell tableCellMedicationName = new TableCell();
                            Label labelMedicationName = new Label();
                            rowcss = rowcss == "GridViewRowStyle" ? "GridViewAlternatingRowStyle" : "GridViewRowStyle";
                            // tableCellMedicationName.Text = MedicationName.Trim();
                            labelMedicationName.Text = MedicationName.Trim();
                            labelMedicationName.ID = "Label" + drClientConsent["ClientMedicationId"].ToString();
                            tableCellMedicationName.Height = 10;
                            tableCellMedicationName.Width = new Unit(100, UnitType.Pixel);
                            tableCellMedicationName.Controls.Add(labelMedicationName);
                            if (labelMedicationName.Text != string.Empty)
                            {
                                labelMedicationName.Attributes.Add("class", "linkStyle");
                                //labelMedicationName.Attributes.Add("onclick", "alert('" + drClientConsent["ClientMedicationId"].ToString() + "," + drClientConsent["DocumentVersionId"].ToString() + "');"); 
                                labelMedicationName.Attributes.Add("onclick", "ShowConsentDetail(" + drClientConsent["ClientMedicationId"].ToString() + "," + drClientConsent["DocumentVersionId"].ToString() + ");");


                            }
                            // tableCellMedicationName.Attributes.Add("nowrap","true");
                            tableCellMedicationName.Wrap = false;
                            // tableCellMedicationName.BorderWidth = new Unit(2, UnitType.Pixel);
                            tableRowConsentHistory.Cells.Add(tableCellMedicationName);

                            //---
                            TableCell tableCellActive = new TableCell();
                            tableCellActive.Text = Active;
                            tableCellActive.Height = 10;
                            tableCellActive.Width = new Unit(2, UnitType.Pixel);
                            tableCellActive.HorizontalAlign = HorizontalAlign.Left;
                            // tableCellActive.BorderWidth = new Unit(2, UnitType.Pixel);
                            tableRowConsentHistory.Cells.Add(tableCellActive);
                            //---
                            //Code Added by : Malathi Shiva 
                            //With Ref to task# : 33 - Community Network Services
                            if (((Streamline.BaseLayer.StreamlinePrinciple)Context.User).HasPermission(Permissions.OffLabel) != false)
                            {
                                TableCell tableCellOffLabel = new TableCell();
                                tableCellOffLabel.Text = OffLabel;
                                tableCellOffLabel.Height = 10;
                                tableCellOffLabel.Width = new Unit(5, UnitType.Pixel);
                                tableCellOffLabel.HorizontalAlign = HorizontalAlign.Left;
                                //tableCellOffLabel.BorderWidth = new Unit(2, UnitType.Pixel);
                                tableRowConsentHistory.Cells.Add(tableCellOffLabel);
                            }
                            //---
                            TableCell tableCellInstruction = new TableCell();
                            tableCellInstruction.Text = Instruction.Trim();
                            tableCellInstruction.Height = 10;
                            tableCellInstruction.Width = new Unit(200, UnitType.Pixel);
                            tableCellInstruction.HorizontalAlign = HorizontalAlign.Left;
                            tableCellInstruction.Attributes.Add("nowrap", "nowrap");
                            // tableCellInstruction.Wrap = false;
                            //tableCellInstruction.BorderWidth = new Unit(2, UnitType.Pixel);
                            tableRowConsentHistory.Cells.Add(tableCellInstruction);
                            //---
                            TableCell tableCellConsentStartDate = new TableCell();
                            tableCellConsentStartDate.Text = ConsentStartDate;
                            tableCellConsentStartDate.Height = 10;
                            tableCellConsentStartDate.Width = new Unit(20, UnitType.Pixel);
                            // tableCellConsentStartDate.BorderWidth = new Unit(2, UnitType.Pixel);
                            tableRowConsentHistory.Cells.Add(tableCellConsentStartDate);
                            //---
                            TableCell tableCellConsentEndDate = new TableCell();
                            tableCellConsentEndDate.Text = ConsentEndDate;
                            tableCellConsentEndDate.Height = 10;
                            tableCellConsentEndDate.Width = new Unit(20, UnitType.Pixel);
                            //tableCellConsentEndDate.BorderWidth = new Unit(2, UnitType.Pixel);
                            tableRowConsentHistory.Cells.Add(tableCellConsentEndDate);
                            tableMedication.Rows.Add(tableRowConsentHistory);

                            //----
                            TableRow trLine = new TableRow();
                            TableCell tdHorizontalLine = new TableCell();
                            tdHorizontalLine.ColumnSpan = 6;
                            tdHorizontalLine.CssClass = "blackLine";
                            trLine.Cells.Add(tdHorizontalLine);
                            tableMedication.Rows.Add(trLine);

                        }
                    }
                }
                tableMedication.CellPadding = 0;
                tableMedication.CellSpacing = 0;
                this.PanelConsentList.Controls.Add(tableMedication);

            }
            catch(Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "";
                else
                    ex.Data["CustomExceptionInformation"] = "";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);

                }
        }
        /// <summary>
        /// <Description></Description>
        /// <Author>Pradeep</Author>
        /// <CreatedOn>30 Oct 2009</CreatedOn>
        /// </summary>
        /// <returns></returns>
        private string setAttributes()
        {
            if (_sortString == "")
            {
                return "";

            }
            else if (_sortString.Contains("Desc"))
            {
                return "Asc";

            }
            else if (_sortString.Contains("Asc"))
            {
                return "Desc";

            }
            else
            {
                return "";
            }
        }
        /// <summary>
        /// <Description>Used to assign data to controls on the page</Description>
        /// <Author>Pradeep</Author>
        /// <CreatedOn>30 Oct 2009</CreatedOn>
        /// </summary>
        public override void Activate()
        {
           
            try
            {
                CommonFunctions.Event_Trap(this); 
                base.Activate();
                _dtMedicationTemp = new Streamline.UserBusinessServices.DataSets.MedicationList.MedicationsDataTable();
                _dtMedicationInstructionTemp = new Streamline.UserBusinessServices.DataSets.MedicationList.MedicationInstructionsDataTable();
            }
            catch(Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "";
                else
                    ex.Data["CustomExceptionInformation"] = "";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);

            }
        }
        /// <summary>
        /// <Description></Description>
        /// <Author>Pradeep</Author>
        /// <CreatedOn>30 Oct 2009</CreatedOn>
        /// </summary>
        /// <param name="dtClientMedication"></param>
        /// <param name="dtClientMedicalInstructions"></param>
        public void GenerationConsentTabControlRows(DataTable dtClientMedication, DataTable dtClientMedicalInstructions)
        {
            try
            {
             //CompileDataTable(dtClientMedication,dtClientMedicalInstructions);
             GenerateRows(dtClientMedication, dtClientMedicalInstructions);
            }
            catch(Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "";
                else
                    ex.Data["CustomExceptionInformation"] = "";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);

            }
        }
        #region--Comented Code
        //private void CompileDataTable(DataTable dtClientMedication, DataTable dtClientMedicalInstructions)
        //{
        //    try
        //    {
        //        if (_dtMedicationTemp != null)
        //        {
        //            _dtMedicationTemp.Clear();
        //            _dtMedicationTemp.Merge(dtClientMedication);
        //        }
                
        //        if (_dtMedicationInstructionTemp != null)
        //        {
        //            _dtMedicationInstructionTemp.Clear();
        //            _dtMedicationInstructionTemp.Merge(dtClientMedicalInstructions);
        //        }
               
        //        DataTable dtClientMedicationCopy = dtClientMedication.Clone();
        //        DataView dvClientMedicationInstructions = new DataView(dtClientMedicalInstructions);
        //        dvClientMedicationInstructions.Sort = "ClientMedicationInstructionId desc";
        //        //int newClientMedicationInstructionId = 1;
        //        //if (dvClientMedicationInstructions.Count > 0)
        //        //    newClientMedicationInstructionId = Convert.ToInt32(dvClientMedicationInstructions[0]["ClientMedicationInstructionId"]) + 1;
        //        //foreach (DataRow dr in dtClientMedication.Rows)
        //        //{
        //        //    if (dtClientMedicalInstructions.Select("ClientMedicationId=" + Convert.ToInt32(dr["ClientMedicationId"]) + "  and ISNULL(RecordDeleted,'N')='N'").Length < 1)
        //        //    {
        //        //        DataRow drCMI = dtClientMedicalInstructions.NewRow();
        //        //        drCMI["ClientMedicationInstructionId"] = newClientMedicationInstructionId;
        //        //        drCMI["ClientMedicationId"] = dr["ClientMedicationId"];
        //        //        drCMI["MedicationName"] = dr["MedicationName"];
        //        //        drCMI["Active"] = dr["Active"];
        //        //        //drCMI["OffLabel"] = dr["OffLabel"];
        //        //        //drCMI["OffLabel"] = dr["OffLabel"];
        //        //        drCMI["ModifiedBy"] = dr["ModifiedBy"];
        //        //        drCMI["ModifiedDate"] = dr["ModifiedDate"];
        //        //        drCMI["CreatedBy"] = dr["CreatedBy"];
        //        //        drCMI["CreatedDate"] = dr["CreatedDate"];
        //        //        drCMI["Instruction"] = string.Empty;
        //        //        drCMI["RowIdentifier"] = System.Guid.NewGuid();
        //        //        dtClientMedicalInstructions.Rows.Add(drCMI);
        //        //        newClientMedicationInstructionId++;
        //        //    }
        //        //}
        //    }
        //    catch (Exception ex)
        //    {
        //        if (ex.Data["CustomExceptionInformation"] == null)
        //            ex.Data["CustomExceptionInformation"] = "";
        //        else
        //            ex.Data["CustomExceptionInformation"] = "";
        //        if (ex.Data["DatasetInfo"] == null)
        //            ex.Data["DatasetInfo"] = null;
        //        Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);
        //    }
        //}
        #endregion
        #endregion
    }
}

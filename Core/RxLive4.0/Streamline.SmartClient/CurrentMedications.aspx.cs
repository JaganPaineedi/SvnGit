using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using Streamline.UserBusinessServices;
using Streamline.BaseLayer;
using System.Text;
using System.Drawing;
using System.IO;
using System.Collections.Generic;
using System.ComponentModel;

public partial class CurrentMedications : Streamline.BaseLayer.ActivityPages.ActivityPage
{
    DataSet _DataSetCurrentMedications = null;
    Streamline.UserBusinessServices.ClientMedication objectClientMedications;
    private string _sortString = "";
    protected override void Page_Load(object sender, EventArgs e)
    {
        //if (Request.QueryString["SortBy"] != null && Request.QueryString["SortBy"] != "" && Request.QueryString["SortBy"] != string.Empty)
        //{
        //    _sortString = Request.QueryString["SortBy"].ToString();
        //}
        if (Request.QueryString["Popupheader"] != "undefined" && Request.QueryString["Popupheader"] != null)
        {
            if (Request.QueryString["Popupheader"].ToString() == "N")
            {
                TablePopUpTitleBar.Visible = false;
            }
        }
        else
        {
            TablePopUpTitleBar.Visible = true;
        }

        if (Session["SessionTimeout"] == null)
        {
            //Response.Redirect("MedicationLogin.aspx?SessionExpires='yes'");
            ScriptManager.RegisterStartupScript(lblError, lblError.GetType(), this.ClientID, "parent.location.href =' ./MedicationLogin.aspx?SessionExpires='yes'';", true);
            return;
        }        

        //Added by Loveena in ref to Task#3224-the user changes the selected client, clear the ClientMedicationScriptStrengthId
        if (Request.QueryString["ChangedclientId"] != null)
        {
            if (Request.QueryString["ChangedclientId"].ToString().ToUpper() == "TRUE")
            {
                TableError.Style.Add("display", "block");
                lblError.Text = "Select Medication respective to Selected Client";
            }
        }
        GenerateCurrentMedicationRows();
    }

    //public delegate void RadioButtonClick(object sender, Streamline.BaseLayer.UserData e);
    //public event RadioButtonClick RadioButtonClickEvent;
    //#region--Global Variables and properties---


    public string SortString
    {
        get { return _sortString; }
        set { _sortString = value; }
    }
    //#endregion
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
    private string _onHeaderClick = "onCurrentMedicationHeaderClick";

    public string OnHeaderClick
    {
        get { return _onHeaderClick; }
        set { _onHeaderClick = value; }
    }
    private string _onRadioClick = "onCurrentMedicationRadioClick";

    public string OnRadioClick
    {
        get { return _onRadioClick; }
        set { _onRadioClick = value; }
    }
    /// <summary>
    /// <Description>Used to display curren Medication record of Client</Description>
    /// <Author>Anuj</Author>
    /// <CreatedOn>4 jan 2009</CreatedOn>
    /// </summary>
    /// <param name=""></param>
    /// <param name=""></param>
    /// <param name="sortString"></param>
    private void GenerateCurrentMedicationRows()
    {
        bool _boolRowWithInteractionFound = false;
        try
        {
            CommonFunctions.Event_Trap(this);

            System.Drawing.Color[] _color = 
                { 
                System.Drawing.Color.Pink, 
                System.Drawing.Color.Red, 
                System.Drawing.Color.Yellow, 
                System.Drawing.Color.Green, 
                System.Drawing.Color.Plum, 
                System.Drawing.Color.Aqua, 
                System.Drawing.Color.PaleGoldenrod, 
                System.Drawing.Color.Peru, 
                System.Drawing.Color.Tan, 
                System.Drawing.Color.Khaki, 
                System.Drawing.Color.DarkGoldenrod, 
                System.Drawing.Color.Maroon, 
                System.Drawing.Color.OliveDrab ,
               
                System.Drawing.Color.Crimson,
                System.Drawing.Color.Beige,
                System.Drawing.Color.DimGray,
                System.Drawing.Color.ForestGreen,
                System.Drawing.Color.Indigo,
                System.Drawing.Color.LightCyan           
                };
            int ClientId = 0;
            //ClientId = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId;
            if (Request.QueryString["SelectedClientId"] != "undefined" && Request.QueryString["SelectedClientId"] != null)
            {
                ClientId = Convert.ToInt32(Request.QueryString["SelectedClientId"]);
                HiddenClientId.Value = Convert.ToString(ClientId);
            }
            int SureScriptsRefillRequestId = 0;
            if (Request.QueryString["SureScriptsRefillRequestId"] != "undefined" && Request.QueryString["SureScriptsRefillRequestId"] != null)
            {
                SureScriptsRefillRequestId = Convert.ToInt32(Request.QueryString["SureScriptsRefillRequestId"]);
                HiddenFieldSureScriptsRefillRequestId.Value = Convert.ToString(SureScriptsRefillRequestId);
            }
            objectClientMedications = new ClientMedication();
            Session["CurrentMedications"] = null;
            _DataSetCurrentMedications = objectClientMedications.GetClientCurrentMedications(ClientId);
            Session["CurrentMedications"] = _DataSetCurrentMedications;
            if (_DataSetCurrentMedications.Tables.Count > 0)
            {
                if (_DataSetCurrentMedications.Tables["TableCurrentMedications"].Rows.Count <= 0)
                {
                    ButtonSelect.Disabled = true;
                }
                else
                {
                    ButtonSelect.Disabled = false;
                }
            }
            PanelCurrentMedicationListInformation.Controls.Clear();
            Table tblMedication = new Table();
            tblMedication.ID = System.Guid.NewGuid().ToString();

            tblMedication.Width = new Unit(97, UnitType.Percentage);

            //Table Row Started
            TableHeaderRow thTitle = new TableHeaderRow();

            //Balnk  Table Header Cell
            TableHeaderCell thcBlank1 = new TableHeaderCell();

            //Table Header Cell For Medicaton Name           
            TableHeaderCell thcMedication = new TableHeaderCell();
            thcMedication.Text = "Medication";
            thcMedication.Font.Underline = true;
            thcMedication.Attributes.Add("onClick", "onCurrentMedicationHeaderClick(this)");
            thcMedication.Attributes.Add("ColumnName", "MedicationName");
            thcMedication.Attributes.Add("SortOrder", setAttributes());
            if (_DataSetCurrentMedications.Tables["TableCurrentMedications"].Rows.Count > 0)
            {
                thcMedication.CssClass = "handStyle";
            }

            //Table Header Cell For Date Initiated    
            TableHeaderCell thcStartDate = new TableHeaderCell();
            thcStartDate.Text = "Date Initiated";
            thcStartDate.Font.Underline = true;
            thcStartDate.Attributes.Add("onClick", "onCurrentMedicationHeaderClick(this)");
            thcStartDate.Attributes.Add("ColumnName", "MedicationStartDate");
            thcStartDate.Attributes.Add("SortOrder", setAttributes());
            thcStartDate.Width = 120;
            if (_DataSetCurrentMedications.Tables["TableCurrentMedications"].Rows.Count > 0)
            {
                thcStartDate.CssClass = "handStyle";
            }
            //Table Header Cell For Instruction    
            TableHeaderCell thcInstructions = new TableHeaderCell();
            thcInstructions.Text = "Instructions";
            thcInstructions.Font.Underline = true;
            thcInstructions.Attributes.Add("onClick", "onCurrentMedicationHeaderClick(this)");
            thcInstructions.Attributes.Add("ColumnName", "Instruction");
            thcInstructions.Attributes.Add("SortOrder", setAttributes());
            if (_DataSetCurrentMedications.Tables["TableCurrentMedications"].Rows.Count > 0)
            {
                thcInstructions.CssClass = "handStyle";
            }

            //Table Header Cell For DispenceQty    
            TableHeaderCell thcDispenseQty = new TableHeaderCell();
            thcDispenseQty.Text = "DispenseQty";
            thcDispenseQty.Font.Underline = true;
            thcDispenseQty.Attributes.Add("onClick", "onCurrentMedicationHeaderClick(this)");
            thcDispenseQty.Attributes.Add("ColumnName", "DispenseQuantity");
            thcDispenseQty.Attributes.Add("SortOrder", setAttributes());
            if (_DataSetCurrentMedications.Tables["TableCurrentMedications"].Rows.Count > 0)
            {
                thcDispenseQty.CssClass = "handStyle";
            }
            //Table Header Cell For Rx StartDate                          
            TableHeaderCell thcMedicationStartDate = new TableHeaderCell();
            thcMedicationStartDate.Text = "Rx Start";
            thcMedicationStartDate.Font.Underline = true;
            thcMedicationStartDate.Attributes.Add("onClick", "onCurrentMedicationHeaderClick(this)");
            thcMedicationStartDate.Attributes.Add("ColumnName", "MedicationStartDate");
            thcMedicationStartDate.Attributes.Add("SortOrder", setAttributes());
            if (_DataSetCurrentMedications.Tables["TableCurrentMedications"].Rows.Count > 0)
            {
                thcMedicationStartDate.CssClass = "handStyle";
            }

            //Table Header Cell For Rx EndDate       
            TableHeaderCell thcMedicationEndDate = new TableHeaderCell();
            thcMedicationEndDate.Text = "Rx End";
            thcMedicationEndDate.Font.Underline = true;
            thcMedicationEndDate.Attributes.Add("onClick", "onCurrentMedicationHeaderClick(this)");
            thcMedicationEndDate.Attributes.Add("ColumnName", "MedicationStartDate");
            thcMedicationEndDate.Attributes.Add("SortOrder", setAttributes());

            if (_DataSetCurrentMedications.Tables["TableCurrentMedications"].Rows.Count > 0)
            {
                thcMedicationEndDate.CssClass = "handStyle";
            }
            //Table Header Cell For Prescribed By    
            TableHeaderCell thcPrescribed = new TableHeaderCell();
            thcPrescribed.Text = "Prescribed By";
            thcPrescribed.Font.Underline = true;
            thcPrescribed.Attributes.Add("onClick", "onCurrentMedicationHeaderClick(this)");
            thcPrescribed.Attributes.Add("ColumnName", "PrescriberName");
            thcPrescribed.Attributes.Add("SortOrder", setAttributes());
            if (_DataSetCurrentMedications.Tables["TableCurrentMedications"].Rows.Count > 0)
            {
                thcPrescribed.CssClass = "handStyle";
            }

            //Adding all the header columns in Header rows
            thTitle.Cells.Add(thcBlank1);
            thTitle.Cells.Add(thcMedication);
            thTitle.Cells.Add(thcStartDate);

            thTitle.Cells.Add(thcInstructions);
            thTitle.Cells.Add(thcDispenseQty);
            thTitle.Cells.Add(thcMedicationStartDate);
            thTitle.Cells.Add(thcMedicationEndDate);
            thTitle.Cells.Add(thcPrescribed);

            thTitle.CssClass = "GridViewHeaderText";
            tblMedication.Rows.Add(thTitle);
            if (_DataSetCurrentMedications != null && _DataSetCurrentMedications.Tables.Count > 0 && _DataSetCurrentMedications.Tables["TableCurrentMedications"].Rows.Count > 0)
            {
                foreach (DataRow drMedication in _DataSetCurrentMedications.Tables["TableCurrentMedications"].Rows)
                {
                    int medicationId = Convert.ToInt32(drMedication["ClientMedicationId"]);
                    string MedicationName = drMedication["MedicationName"].ToString();
                    string prescribedBy = drMedication["PrescriberName"].ToString();
                    string DispenceQty = "";
                    //if (drMedication["DispenseQuantity"].ToString() != null || drMedication["DispenseQuantity"].ToString() != "0.00")
                    //{
                    //    DispenceQty = drMedication["DispenseQuantity"].ToString();
                    //}

                    int prescriberId = 0;
                    if (drMedication["PrescriberId"].ToString() != "" && drMedication["PrescriberId"].ToString() != null)
                    {
                        prescriberId = Convert.ToInt32(drMedication["PrescriberId"].ToString());
                    }
                    int ClientMedicationScriptDrugStrengthId = 0;
                    if (drMedication["ClientMedicationScriptDrugStrengthId"].ToString() != "" && drMedication["ClientMedicationScriptDrugStrengthId"].ToString() != null)
                    {
                        ClientMedicationScriptDrugStrengthId = Convert.ToInt32(drMedication["ClientMedicationScriptDrugStrengthId"].ToString());
                    }

                    int ClientMedicationId = 0;
                    if (drMedication["ClientMedicationId"].ToString() != "" && drMedication["ClientMedicationId"].ToString() != null)
                    {
                        ClientMedicationId = Convert.ToInt32(drMedication["ClientMedicationId"].ToString());
                    }
                    //string specialInstruction = drMedication["SpecialInstructions"].ToString();
                    int MedicationNameId = drMedication["MedicationNameId"] == DBNull.Value ? 0 : Convert.ToInt32(drMedication["MedicationNameId"]);
                    string startDate = "";
                    startDate = drMedication["MedicationStartDate"] == DBNull.Value ? "" : drMedication["MedicationStartDate"].ToString();
                    if (startDate != "")
                    {
                        startDate = Convert.ToDateTime(startDate).ToString("MM/dd/yyyy");
                    }
                    else
                    {
                        startDate = "";
                    }
                    string endDate = drMedication["MedicationEndDate"] == DBNull.Value ? "" : drMedication["MedicationEndDate"].ToString();
                    if (endDate != "")
                    {
                        endDate = Convert.ToDateTime(endDate).ToString("MM/dd/yyyy");
                    }
                    else
                    {
                        endDate = "";
                    }
                    DataRow[] drMedInstructions;
                    //drMedInstructions = _DataSetCurrentMedications.Tables["TableClientMedicationInstruction"].Select("ClientMedicationId=" + medicationId + " and ClientMedicationScriptDrugStrengthId=" + ClientMedicationScriptDrugStrengthId);
                    drMedInstructions = _DataSetCurrentMedications.Tables["TableClientMedicationInstruction"].Select("ClientMedicationScriptDrugStrengthId=" + ClientMedicationScriptDrugStrengthId);
                    //drMedInstructions = dtMedicationInstructionTemp.Select("ClientMedicationId=" + medicationId);


                    bool _showMedication = true;
                    foreach (DataRow drTemp in drMedInstructions)
                    {                        
                        tblMedication.Rows.Add(GenerateCurrentMedicationSubRows(drTemp, prescribedBy, tblMedication.ClientID, startDate, endDate, _boolRowWithInteractionFound, prescriberId, DispenceQty, _showMedication, ClientMedicationScriptDrugStrengthId,ClientMedicationId,MedicationName));
                        _showMedication = false;
                        startDate = string.Empty;
                        endDate = string.Empty;
                    }
                    TableRow trLine = new TableRow();
                    TableCell tdHorizontalLine = new TableCell();
                    tdHorizontalLine.ColumnSpan = 8;
                    tdHorizontalLine.CssClass = "blackLine";
                    trLine.Cells.Add(tdHorizontalLine);
                    tblMedication.Rows.Add(trLine);
                }
            }
            PanelCurrentMedicationListInformation.Controls.Add(tblMedication);
        }
        catch (Exception ex)
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
    /// <Description>Used to display curren Medication record of Client</Description>
    /// <Author>Anuj</Author>
    /// <CreatedOn>4 jan 2009</CreatedOn>
    /// </summary>
    /// <param name=""></param>
    /// <param name=""></param>
    /// <param name="sortString"></param>
    private TableRow GenerateCurrentMedicationSubRows(DataRow drTemp, string PrescribedBy, string tableId, string startDate, string endDate,  bool _boolRowWithInteractionFound, int prescriberId, string DispenceQty, bool Medication, int ClientMedicationScriptDrugStrengthId,int ClientMedicationId,string MedicationName)
    {
        try
        {
            CommonFunctions.Event_Trap(this);
            string newId = System.Guid.NewGuid().ToString();
            int MedicationId = Convert.ToInt32(drTemp["ClientMedicationId"]);

            string tblId = this.ClientID + this.ClientIDSeparator + tableId;
            TableRow trTemp = new TableRow();
            trTemp.ID = "Tr_" + newId;
            int client = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId;

            //Ist Column
            TableCell tdStartDate = new TableCell();
            //tdStartDate.Text = OrderDate;
            tdStartDate.Text = startDate;

            //IInd Column
            TableCell tdEndDate = new TableCell();
            tdEndDate.Text = endDate;

            //IIIrd Column
            TableCell tdOrderStart = new TableCell();
            if (drTemp["StartDate"].ToString() != "")
            {
                tdOrderStart.Text = Convert.ToDateTime(drTemp["StartDate"]).ToString("MM/dd/yyyy");
            }
            //IVth Column
            TableCell tdOrderEnd = new TableCell();
            if (drTemp["EndDate"].ToString() != "")
            {
                tdOrderEnd.Text = Convert.ToDateTime(drTemp["EndDate"]).ToString("MM/dd/yyyy");
            }
            Label lblMedication = new Label();
            lblMedication.ID = "Lbl_" + MedicationId.ToString();
            //Vth Column
            TableCell tdMedication = new TableCell();
            lblMedication.Text = MedicationName;
            tdMedication.Controls.Add(lblMedication);
            if (Medication == false)
            {
                tdMedication.Controls.Clear();
                tdMedication.Text = "";
            }
            //VIth Column
            TableCell tdRadioButton = new TableCell();
            string rowId = this.ClientID + this.ClientIDSeparator + trTemp.ClientID;
            HtmlInputRadioButton rbTemp = new HtmlInputRadioButton();
            rbTemp.Name = ClientID.ToString();//Addedd By Pradeep as per task#3299
            rbTemp.Attributes.Add("ClientMedicationId", drTemp["ClientMedicationId"].ToString());
            rbTemp.Attributes.Add("ClientMedicationInstructionId", drTemp["ClientMedicationInstructionId"].ToString());
            rbTemp.Attributes.Add("onClick", "onCurrentMedicationRadioClick(" + ClientMedicationScriptDrugStrengthId + "," + ClientMedicationId + ")");
            rbTemp.ID = "Rb_" + MedicationId.ToString();
            tdRadioButton.Controls.Add(rbTemp);
            if (Medication == false)
            {
                //myscript += "var Radiocontext" + MedicationId + "={MedicationId:" + MedicationId + ",MedicationInstructionsId:" + drTemp["MedicationInstructionId"].ToString() + ",TableId:'" + tblId + "',RowId:'" + rowId + "'};";
                //myscript += "var RadioclickCallback" + MedicationId + " =";
                //myscript += " Function.createCallback(" + this._onRadioClickEventHandler + ", Radiocontext" + MedicationId + ");";
                //myscript += "$addHandler($get('" + this.ClientID + this.ClientIDSeparator + rbTemp.ClientID + "'), 'click', RadioclickCallback" + MedicationId + ");";
            }
            //VIIth Column
            TableCell tdOrder = new TableCell();
            tdOrder.Text = drTemp["Instruction"] == DBNull.Value ? "" : drTemp["Instruction"].ToString();

            if (Medication == false)
            {
                tdRadioButton.Controls.Clear();
                tdRadioButton.Text = "";
            }
            //VIIIth Column
            TableCell tdPrescribed = new TableCell();
            tdPrescribed.Text = PrescribedBy;
            if (Medication == false)
            {
                tdPrescribed.Controls.Clear();
                tdPrescribed.Text = "";
            }
            //VIIIth Column
            TableCell tdDispenceQty = new TableCell();
            tdDispenceQty.Text = DispenceQty;
            if (drTemp["DispenseQuantity"]!=null)
            {
                tdDispenceQty.Controls.Clear();
                tdDispenceQty.Text = Convert.ToString(drTemp["DispenseQuantity"]);
            }
            if (Medication == false)
            {
                tdOrder.Controls.Clear();
                tdOrder.Text = "";
                tdDispenceQty.Controls.Clear();
                tdDispenceQty.Text = "";
                tdOrderStart.Controls.Clear();
                tdOrderStart.Text = "";
                tdOrderEnd.Controls.Clear();
                tdOrderEnd.Text = "";
            }
            trTemp.Cells.Add(tdRadioButton);
            trTemp.Cells.Add(tdMedication);
            trTemp.Cells.Add(tdStartDate);
            trTemp.Cells.Add(tdOrder);//Instruction
            trTemp.Cells.Add(tdDispenceQty);
            trTemp.Cells.Add(tdOrderStart);
            trTemp.Cells.Add(tdOrderEnd);

            trTemp.Cells.Add(tdPrescribed);

            trTemp.CssClass = "GridViewRowStyle";
            //RepeatMediactionId = MedicationId;
            return trTemp;

        }
        catch (Exception ex)
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

}

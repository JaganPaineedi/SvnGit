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
using Streamline.BaseLayer;
using Streamline.UserBusinessServices;

public partial class ClientMedicationTitration : Streamline.BaseLayer.ActivityPages.ActivityPage
{
    private string _ClientInfoTitle = "";
    DataSet _DataSetClientSummary = null;
    Streamline.UserBusinessServices.DataSets.DataSetClientMedications _DataSetClientMedications = null;

    /// <summary>
    /// <description>Page Load </description>
    /// <author>Ankesh Bharti</author>
    /// <createdDate>24/12/2008</createdDate>
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected override void Page_Load(object sender, EventArgs e)
    {
        try
        {
            Header.DataBind();
            if (Session["UserContext"] != null)
                LabelCopyrightInfo.Text = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).CopyrightInfo;

            FillClientInfo();
            FillMedicationInfo();
            CreateControls();
            TextBoxStartDate.Text = System.DateTime.Now.ToString("MM/dd/yyyy");
            TextBoxDays.Attributes.Add("onblur", "ClientMedicationTitration.CalculateEndDate('" + TextBoxStartDate.ClientID + "','" + TextBoxDays.ClientID + "','" + TextBoxRefills.ClientID + "','" + TextBoxEndDate.ClientID + "');ClientMedicationTitration.CalculatePharmacyForDaysChange();");
            TextBoxRefills.Attributes.Add("onblur", "ClientMedicationTitration.CalculateEndDate('" + TextBoxStartDate.ClientID + "','" + TextBoxDays.ClientID + "','" + TextBoxRefills.ClientID + "','" + TextBoxEndDate.ClientID + "');ClientMedicationTitration.CalculatePharmacyForDaysChange();");
            TextBoxStartDate.Attributes.Add("onblur", "ClientMedicationTitration.CalculateEndDate('" + TextBoxStartDate.ClientID + "','" + TextBoxDays.ClientID + "','" + TextBoxRefills.ClientID + "','" + TextBoxEndDate.ClientID + "');");
            ButtonSaveAsTemplate.Attributes.Add("onclick", "ClientMedicationTitration.SaveTemplate('" + HiddenMedicationNameId.ClientID + "','" + ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode + "');");
            Streamline.BaseLayer.CommonFunctions.SetErrorMegssageBackColor(LabelErrorMessage);
            Streamline.BaseLayer.CommonFunctions.SetErrorMegssageForeColor(LabelGridErrorMessage);
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }


    /// <summary>
    /// <description>Function to fill the client related information on page load to show at top of page</description>
    /// <author>Ankesh Bharti</author>
    /// <createdDate>24/12/2008</createdDate>
    /// </summary>
    private void FillClientInfo()
    {
        try
        {
            if (Session["DataSetClientSummary"] != null)
            {
                _DataSetClientSummary = (DataSet)Session["DataSetClientSummary"];
                string _dob = _DataSetClientSummary.Tables["ClientInformation"].Rows[0]["DOB"].ToString();
                if (_dob != "")
                    _ClientInfoTitle = "Titration / Taper – Client:" + _DataSetClientSummary.Tables["ClientInformation"].Rows[0]["ClientName"].ToString() + "(" + ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId + "), DOB:" + DateTime.Parse(_dob).ToString("MM/dd/yyyy");
                else
                    _ClientInfoTitle = "Titration / Taper – Client:" + _DataSetClientSummary.Tables["ClientInformation"].Rows[0]["ClientName"].ToString() + "(" + ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId + "), DOB: ";
                LabelClientInfoTitle.Text = _ClientInfoTitle;
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

    /// <summary>
    /// <description>Function used to set the titartion dataset to session on page load.</description>
    /// <author>Ankesh Bharti</author>
    /// <createdDate>24/12/2008</createdDate>
    /// </summary>
    private void FillMedicationInfo()
    {
        try
        {
            if (Session["DataSetTitration"] != null)
            {
                using (DataSet _dataSetClientTitration = ((DataSet)Session["DataSetTitration"]).Copy())
                {
                    Session["DataSetTitration"] = _dataSetClientTitration;
                }
            }
            else
            {
                _DataSetClientMedications = new Streamline.UserBusinessServices.DataSets.DataSetClientMedications();
                Session["DataSetTitration"] = _DataSetClientMedications;
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

    #region CreateControls

    /// <summary>
    /// <description>Function to Create Medication Grid at run time by creating dynamic table</description>
    /// <author>Ankesh Bharti</author>
    /// <createdDate>24/12/2008</createdDate>
    /// </summary>
    private void CreateControls()
    {
        try
        {
            CommonFunctions.Event_Trap(this);
            CreateLabelRow();
            Table tableControls = new Table();
            tableControls.Width = new Unit(90, UnitType.Percentage);
            tableControls.ID = "tableMedicationStepBuilder";
            tableControls.Attributes.Add("tableMedicationStepBuilder", "true");
            string myscript = "<script id='MedicationOrderScript' type='text/javascript'>";
            myscript += "function InitializeComponents(){;";
            for (int _RowCount = 0; _RowCount < 5; _RowCount++)
            {
                tableControls.Rows.Add(CreateMedicationRow(_RowCount, ref myscript));
            }
            myscript += "}</script>";
            PlaceHolder.Controls.Add(tableControls);
            ScriptManager.RegisterStartupScript(PlaceHolder, PlaceHolder.GetType(), PlaceHolder.ClientID.ToString(), myscript, false);
        }
        catch (Exception ex)
        {
            if (ex.Data["CustomExceptionInformation"] == null)
                ex.Data["CustomExceptionInformation"] = "";
            else
                ex.Data["CustomExceptionInformation"] = "";
            if (ex.Data["DatasetInfo"] == null)
                ex.Data["DatasetInfo"] = "";
            Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);

        }
    }


    /// <summary>
    /// <description>Function to create defining columns of table with their headers name.</description>
    /// <author>Ankesh Bharti</author>
    /// <createdDate>24/12/2008</createdDate>
    /// </summary>
    private void CreateLabelRow()
    {
        try
        {
            CommonFunctions.Event_Trap(this);
            Table _Table = new Table();
            TableRow _TableRow = new TableRow();
            TableCell _TableCell0 = new TableCell();
            TableCell _TableCell1 = new TableCell();
            TableCell _TableCell2 = new TableCell();
            TableCell _TableCell3 = new TableCell();
            TableCell _TableCell4 = new TableCell();
            TableCell _TableCell5 = new TableCell();
            TableCell _TableCell6 = new TableCell();
            TableCell _TableCell7 = new TableCell();

            _Table.ID = "Table";

            Label _lblDeleteRow = new Label();
            _lblDeleteRow.ID = "Delete";
            _lblDeleteRow.Width = 20;
            _lblDeleteRow.Height = 20;
            _lblDeleteRow.Visible = true;
            _lblDeleteRow.Text = "";

            Label _lblStrength = new Label();
            _lblStrength.ID = "Strength";
            //Modified by Loveena in ref to Task#2799
            //_lblStrength.Width = 268;
            _lblStrength.Width = 185;
            _lblStrength.Height = 20;
            _lblStrength.Visible = true;
            _lblStrength.Text = "Strength";

            Label _lblQuantity = new Label();
            _lblQuantity.ID = "Quantity";
            _lblQuantity.Width = 38;
            _lblQuantity.Height = 20;
            _lblQuantity.Visible = true;
            //Modified by Loveena in ref to Task#2799
            //_lblQuantity.Text = "Qty";
            _lblQuantity.Text = "Dose";

            Label _lblUnit = new Label();
            _lblUnit.ID = "Unit";
            _lblUnit.Width = 77;
            _lblUnit.Height = 20;
            _lblUnit.Visible = true;
            _lblUnit.Text = "Unit";

            Label _lblSchedule = new Label();
            _lblSchedule.ID = "Schedule";
            _lblSchedule.Width = 180;
            _lblSchedule.Height = 20;
            _lblSchedule.Visible = true;
            //Modified by Loveena in ref to Task#2799
            //_lblSchedule.Text = "Schedule";
            _lblSchedule.Text = "Directions";

            Label _lblPharma = new Label();
            _lblPharma.ID = "Pharm";
            //Modified by Loveena in ref to Task#2799
            //_lblPharma.Width = 47;
            _lblPharma.Width = 170;
            _lblPharma.Height = 20;
            _lblPharma.Visible = true;
            //Modified by Loveena in ref to Task#2799
            //_lblPharma.Text = "Pharm";
            _lblPharma.Text = "Dispense Qty";

            Label _lblSample = new Label();
            _lblSample.ID = "Sample";
            _lblSample.Width = 48;
            _lblSample.Height = 20;
            _lblSample.Visible = true;
            _lblSample.Text = "Sample";

            Label _lblStock = new Label();
            _lblStock.ID = "Stock";
            _lblStock.Width = 45;
            _lblStock.Height = 20;
            _lblStock.Visible = true;
            _lblStock.Text = "Stock";

            _TableCell0.Controls.Add(_lblDeleteRow);
            _TableCell1.Controls.Add(_lblStrength);
            _TableCell2.Controls.Add(_lblQuantity);
            _TableCell3.Controls.Add(_lblUnit);
            _TableCell4.Controls.Add(_lblSchedule);
            _TableCell5.Controls.Add(_lblPharma);
            _TableCell6.Controls.Add(_lblSample);
            _TableCell7.Controls.Add(_lblStock);


            _TableRow.Controls.Add(_TableCell0);
            _TableRow.Controls.Add(_TableCell1);
            _TableRow.Controls.Add(_TableCell2);
            _TableRow.Controls.Add(_TableCell3);
            _TableRow.Controls.Add(_TableCell4);
            _TableRow.Controls.Add(_TableCell5);
            _TableRow.Controls.Add(_TableCell6);
            _TableRow.Controls.Add(_TableCell7);

            _Table.CssClass = "LabelUnderlineFontNew";
            _Table.Controls.Add(_TableRow);
            PlaceLabel.Controls.Add(_Table);
        }
        catch (Exception ex)
        {
            if (ex.Data["CustomExceptionInformation"] == null)
                ex.Data["CustomExceptionInformation"] = "";
            else
                ex.Data["CustomExceptionInformation"] = "";
            if (ex.Data["DatasetInfo"] == null)
                ex.Data["DatasetInfo"] = "";
            throw (ex);
        }
    }


    private TableRow CreateMedicationRow(int rowIndex, ref string myscript)
    {
        try
        {
            HiddenField textboxButtonValue = this.Page.FindControl("txtButtonValue") as HiddenField;

            CommonFunctions.Event_Trap(this);
            Table _Table = new Table();
            TableRow _TableRow = new TableRow();
            _TableRow.ID = "TableMedicationRow_" + rowIndex;
            TableCell _TableCell0 = new TableCell();
            TableCell _TableCell1 = new TableCell();
            TableCell _TableCell2 = new TableCell();
            TableCell _TableCell3 = new TableCell();
            TableCell _TableCell4 = new TableCell();
            TableCell _TableCell5 = new TableCell();
            TableCell _TableCell6 = new TableCell();
            TableCell _TableCell7 = new TableCell();
            TableCell _TableCell8 = new TableCell();
            //Added in ref to Task#2802
            TableCell _TableCell9 = new TableCell();
            _Table.ID = "TableMedication" + rowIndex;


            HtmlImage _ImgDeleteRow = new HtmlImage();
            _ImgDeleteRow.ID = "ImageDelete" + rowIndex;
            _ImgDeleteRow.Src = "~/App_Themes/Includes/Images/deleteIcon.gif";
            _ImgDeleteRow.Attributes.Add("class", "handStyle");
            if (textboxButtonValue != null && textboxButtonValue.Value == "Refill")
                _ImgDeleteRow.Disabled = true;


            myscript += "var Imagecontext" + rowIndex + ";";
            myscript += "var ImageclickCallback" + rowIndex + " =";
            myscript += " Function.createCallback(ClientMedicationTitration.DeleteRow , Imagecontext" + rowIndex + ");";
            myscript += "$addHandler($get('" + _ImgDeleteRow.ClientID + "'), 'click', ImageclickCallback" + rowIndex + ");";


            DropDownList _DropDownListStrength = new DropDownList();
            //Modified by Loveena in ref to Task#2799 to change the labels
            //_DropDownListStrength.Width = 270;
            _DropDownListStrength.Width = 190;
            _DropDownListStrength.Height = 20;
            if (textboxButtonValue != null && textboxButtonValue.Value == "Refill")
                _DropDownListStrength.Enabled = false;
            _DropDownListStrength.EnableViewState = true;
            _DropDownListStrength.ID = "DropDownListStrength" + rowIndex;


            TextBox _txtQuantity = new TextBox();
            _txtQuantity.BackColor = System.Drawing.Color.White;
            _txtQuantity.MaxLength = 4;
            if (textboxButtonValue != null && textboxButtonValue.Value == "Refill")
                _txtQuantity.Enabled = false;
            _txtQuantity.ID = "TextBoxQuantity" + rowIndex;
            _txtQuantity.Width = 30;
            _txtQuantity.Height = 20;
            _txtQuantity.Visible = true;
            _txtQuantity.Style["text-align"] = "Right";
            //Added by Loveena in ref to Task#2414 on 2nd March 2009 to calculate Pharmacy on press of tab key of Qty.
            myscript += "$create(Streamline.SmartClient.UI.TextBox, {'ignoreEnterKey':true,Decimal:true}, {'onBlur':ClientMedicationTitration.ManipulateRowValues},{},$get('" + _txtQuantity.ClientID + "'));";
            //Code added by Loveena ends over here.

            DropDownList _DropDownListUnit = new DropDownList();
            _DropDownListUnit.Width = 80;
            _DropDownListUnit.Height = 20;
            if (textboxButtonValue != null && textboxButtonValue.Value == "Refill")
                _DropDownListUnit.Enabled = false;
            _DropDownListUnit.ID = "DropDownListUnit" + rowIndex;

            DropDownList _DropDownListSchedule = new DropDownList();
            _DropDownListSchedule.Width = 180;
            _DropDownListSchedule.Height = 20;
            if (textboxButtonValue != null && textboxButtonValue.Value == "Refill")
                _DropDownListSchedule.Enabled = false;
            _DropDownListSchedule.ID = "DropDownListSchedule" + rowIndex;

            DevExpress.Web.ASPxEditors.ASPxComboBox _comboBoxPharmText = new DevExpress.Web.ASPxEditors.ASPxComboBox();
            _comboBoxPharmText.ID = "_comboBoxPharmacy" + rowIndex;
            _comboBoxPharmText.Visible = true;
            _comboBoxPharmText.Enabled = true;
            _comboBoxPharmText.DropDownStyle = DevExpress.Web.ASPxEditors.DropDownStyle.DropDown;
            _comboBoxPharmText.Style["text-align"] = "Right";
            _comboBoxPharmText.ClientInstanceName = "ComboPharmaText" + rowIndex;
            _comboBoxPharmText.ClientSideEvents.KeyPress = "function(s, e) { ClientMedicationTitration.CheckKeyPress(" + rowIndex + "); }";
            _comboBoxPharmText.EnableFocusedStyle = false;
            _comboBoxPharmText.EnableTheming = false;
            _comboBoxPharmText.ItemStyle.Border.BorderStyle = BorderStyle.None;
            _comboBoxPharmText.Font.Name = "Microsoft Sans Serif";
            _comboBoxPharmText.Font.Size = new FontUnit(8.50, UnitType.Point);
            _comboBoxPharmText.Border.BorderColor = System.Drawing.ColorTranslator.FromHtml("#7b9ebd");
            _comboBoxPharmText.Height = new Unit(6, UnitType.Pixel);
            #endregion

            TextBox _txtSample = new TextBox();
            _txtSample.BackColor = System.Drawing.Color.White;
            _txtSample.MaxLength = 4;
            _txtSample.ID = "TextBoxSample" + rowIndex;
            _txtSample.Width = 40;
            _txtSample.Height = 20;
            _txtSample.Visible = true;
            _txtSample.Style["text-align"] = "Right";
            myscript += "$create(Streamline.SmartClient.UI.TextBox, {'ignoreEnterKey':true,Decimal:true}, {},{},$get('" + _txtSample.ClientID + "'));";

            TextBox _txtStock = new TextBox();
            _txtStock.BackColor = System.Drawing.Color.White;
            _txtStock.MaxLength = 4;
            _txtStock.ID = "TextBoxStock" + rowIndex;
            _txtStock.Width = 40;
            _txtStock.Height = 20;
            _txtStock.Visible = true;
            _txtStock.Style["text-align"] = "Right";
            myscript += "$create(Streamline.SmartClient.UI.TextBox, {'ignoreEnterKey':true,Decimal:true}, {},{},$get('" + _txtStock.ClientID + "'));";

            Label _RowIdentifier = new Label();
            _RowIdentifier.ID = "RowIdentifier" + rowIndex;

            //Added by Loveena in ref to Task#2802
            HiddenField _hiddenAutoCalcAllowed = new HiddenField();
            _hiddenAutoCalcAllowed.ID = "HiddenFieldAutoCalcAllowed" + rowIndex;

            _TableCell0.Controls.Add(_ImgDeleteRow);
            _TableCell1.Controls.Add(_DropDownListStrength);
            _TableCell2.Controls.Add(_txtQuantity);
            _TableCell3.Controls.Add(_DropDownListUnit);
            _TableCell4.Controls.Add(_DropDownListSchedule);
            //_TableCell5.Controls.Add(_txtPharma);
            _TableCell5.Controls.Add(_comboBoxPharmText);
            _TableCell6.Controls.Add(_txtSample);
            _TableCell7.Controls.Add(_txtStock);
            _TableCell8.Controls.Add(_RowIdentifier);
            _TableCell9.Controls.Add(_hiddenAutoCalcAllowed);

            _TableRow.Controls.Add(_TableCell0);
            _TableRow.Controls.Add(_TableCell1);
            _TableRow.Controls.Add(_TableCell2);
            _TableRow.Controls.Add(_TableCell3);
            _TableRow.Controls.Add(_TableCell4);
            _TableRow.Controls.Add(_TableCell5);
            _TableRow.Controls.Add(_TableCell6);
            _TableRow.Controls.Add(_TableCell7);
            _TableRow.Controls.Add(_TableCell8);
            _TableRow.Controls.Add(_TableCell9);

            _DropDownListStrength.Attributes.Add("onchange", "ClientMedicationTitration.onStrengthChange(this,'" + _DropDownListUnit.ClientID + "',null,'" + _txtQuantity.ClientID + "','" + rowIndex + "')");
            _DropDownListSchedule.Attributes.Add("onBlur", "ClientMedicationTitration.onScheduleBlur(this)");
            _DropDownListSchedule.Attributes.Add("onchange", "ClientMedicationTitration.onScheduleChange(" + rowIndex + ")");
            _DropDownListUnit.Attributes.Add("onchange", "ClientMedicationTitration.onUnitChange(" + rowIndex + ")");
            return _TableRow;
        }
        catch (Exception ex)
        {
            if (ex.Data["CustomExceptionInformation"] == null)
                ex.Data["CustomExceptionInformation"] = "";
            else
                ex.Data["CustomExceptionInformation"] = "";
            if (ex.Data["DatasetInfo"] == null)
                ex.Data["DatasetInfo"] = "";
            throw (ex);
        }
    }

}

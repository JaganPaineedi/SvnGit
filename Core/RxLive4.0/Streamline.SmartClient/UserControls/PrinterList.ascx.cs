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

public partial class UserControls_PrinterList : Streamline.BaseLayer.BaseActivityPage
{
    public delegate void DeleteButtonClick(object sender, Streamline.BaseLayer.UserData e);
    public event DeleteButtonClick DeleteButtonClickEvent;

    public delegate void RadioButtonClick(object sender, Streamline.BaseLayer.UserData e);
    public event RadioButtonClick RadioButtonClickEvent;

    private string _sortString;

    public string SortString
    {
        get { return _sortString; }
        set { _sortString = value; }
    }

    private string _onRadioClickEventHandler = "onPrinterRadioClick";

    public string onRadioClickEventHandler
    {
        get { return _onRadioClickEventHandler; }
        set { _onRadioClickEventHandler = value; }
    }

    private string _onDeleteEventHandler = "onDeleteClick";

    public string onDeleteEventHandler
    {
        get { return _onDeleteEventHandler; }
        set { _onDeleteEventHandler = value; }
    }

    private string _deleteRowMessage = "Are you sure you want to delete this row?";

    public string DeleteRowMessage
    {
        get { return _deleteRowMessage; }
        set { _deleteRowMessage = value; }
    }
    private string _onHeaderClick = "onHeaderClick";

    public string onPrinterHeaderClick
    {
        get { return _onHeaderClick; }
        set { _onHeaderClick = value; }
    }
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

    protected override void Page_Load(object sender, EventArgs e)
    {

        
        
    }
    public override void Activate()
    {

        try
        {

            CommonFunctions.Event_Trap(this);
            base.Activate();

        }
        catch (Exception ex)
        {
            if (ex.Data["CustomExceptionInformation"] == null)
                ex.Data["CustomExceptionInformation"] = "";
            else
                ex.Data["CustomExceptionInformation"] = "";
            if (ex.Data["DatasetInfo"] == null)
                ex.Data["DatasetInfo"] = null;
            Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);

        }
        finally
        {

        }


    }
    public void GenerateRows(DataTable _dtPrinter)
    {
        try
        {
            PanelPrinterList.Controls.Clear();
            Table tbPrinterList = new Table();
            tbPrinterList.ID = System.Guid.NewGuid().ToString();

            tbPrinterList.Width = new Unit(100, UnitType.Percentage);
            //tbPharmaciesList.Height = new Unit(100, UnitType.Pixel);
            TableHeaderRow thTitle = new TableHeaderRow();
            TableHeaderCell thBlank1 = new TableHeaderCell();
            thBlank1.Width = new Unit(1, UnitType.Percentage);
            TableHeaderCell thBlank2 = new TableHeaderCell();
            thBlank2.Width = new Unit(1, UnitType.Percentage);
            TableHeaderCell thc = new TableHeaderCell();

            //Printer ID
            TableHeaderCell thID = new TableHeaderCell();
            thID.Text = "ID";
            thID.Font.Underline = true;
            thID.Attributes.Add("onclick", "onPrinterHeaderClick(this)");
            thID.Attributes.Add("ColumnName", "PrinterDeviceLocationId");
            thID.Attributes.Add("SortOrder", setAttributes());
            thID.CssClass = "handStyle";
            thID.Attributes.Add("align", "left");
            thID.Width = new Unit(7, UnitType.Percentage);

            //Active
            TableHeaderCell thActive = new TableHeaderCell();
            thActive.Text = "Active";
            thActive.Font.Underline = true;
            thActive.Attributes.Add("onclick", "onPrinterHeaderClick(this)");
            thActive.Attributes.Add("ColumnName", "Active");
            thActive.Attributes.Add("SortOrder", setAttributes());
            thActive.CssClass = "handStyle";
            thActive.Attributes.Add("align", "left");
            thActive.Width = new Unit(11, UnitType.Percentage);

            // DeviceLabel
            TableHeaderCell thPrinterName = new TableHeaderCell();
            thPrinterName.Text = "Device Label";
            thPrinterName.Font.Underline = true;
            thPrinterName.Attributes.Add("onclick", "onPrinterHeaderClick(this)");
            thPrinterName.Attributes.Add("ColumnName", "DeviceLabel");
            thPrinterName.Attributes.Add("SortOrder", setAttributes());
            thPrinterName.CssClass = "handStyle";
            thPrinterName.Attributes.Add("center", "left");
            thPrinterName.Width = new Unit(35, UnitType.Percentage);

            //DeviceUNCPath
            TableHeaderCell thDeviceUNCPath = new TableHeaderCell();
            thDeviceUNCPath.Text = "Device UNC Path";
            thDeviceUNCPath.Font.Underline = true;
            thDeviceUNCPath.Attributes.Add("onclick", "onPrinterHeaderClick(this)");
            thDeviceUNCPath.Attributes.Add("ColumnName", "DeviceUNCPath");
            thDeviceUNCPath.Attributes.Add("SortOrder", setAttributes());
            thDeviceUNCPath.CssClass = "handStyle";
            thDeviceUNCPath.Attributes.Add("align", "left");
            thDeviceUNCPath.Width = new Unit(45, UnitType.Percentage);
            

            thTitle.Cells.Add(thBlank1);
            thTitle.Cells.Add(thBlank2);
            thTitle.Cells.Add(thID);
            thTitle.Cells.Add(thActive);
            thTitle.Cells.Add(thPrinterName);
            thTitle.Cells.Add(thDeviceUNCPath);

            //thTitle.Cells.Add(thPhone);
            //thTitle.Cells.Add(thFax);

            thTitle.CssClass = "GridViewHeaderText";

            tbPrinterList.Rows.Add(thTitle);
            tbPrinterList.CellSpacing = 0;
            tbPrinterList.CellPadding = 0;

            string myscript = "<script id='Printerlist' type='text/javascript'>";
            myscript += "function $deleteRecord(sender,e){";
            if (!string.IsNullOrEmpty(_deleteRowMessage))
            {
               // myscript += " if (confirm ('" + _deleteRowMessage + "') == true ){" + this._onDeleteEventHandler + "(sender,e)}}";
                myscript += this._onDeleteEventHandler + "(sender,e);  }";
            }
            else
            {
                myscript += "}";
            }

            myscript += "function RegisterPrinterListControlEvents(){try{ ";
            if (_dtPrinter.Rows.Count > 0)
            {
                if (SortString.Split(' ')[0] == "PrinterDeviceLocationId") thc = thID;
                else if (SortString.Split(' ')[0] == "Active") thc = thActive;
                else if (SortString.Split(' ')[0] == "DeviceLabel") thc = thPrinterName;
                else if (SortString.Split(' ')[0] == "DeviceUNCPath") thc = thDeviceUNCPath;
                if (SortString.Split(' ')[1] == "Asc") thc.Style.Add("background", "url(App_Themes/Includes/Images/ListPageUp.png) right no-repeat, url(App_Themes/Includes/Images/list_grid_header_bg.gif) left repeat-x");
                else thc.Style.Add("background", "url(App_Themes/Includes/Images/ListPageDown.png) right no-repeat, url(App_Themes/Includes/Images/list_grid_header_bg.gif) left repeat-x");
                string rowClass = "GridViewRowStyle";
               
                foreach (DataRow dr in _dtPrinter.Rows)
                {
                    int PrinterDeviceLocationId = Convert.ToInt32(dr["PrinterDeviceLocationId"]);
                    string DeviceLabel = dr["DeviceLabel"].ToString();
                    string active = dr["Active"].ToString();
                    //string address = string.Empty;
                    //if (dr["Address"].ToString().Length > 50)
                    //{
                    //    address = dr["Address"].ToString().Substring(0, 50) + "..";
                    //}
                    //else
                    //{
                    //    address = dr["Address"].ToString();
                    //}
                    string DeviceUNCPath = dr["DeviceUNCPath"].ToString();
                    //string fax = dr["FaxNumber"].ToString();
                    tbPrinterList.Rows.Add(GenerateSubRows(dr, PrinterDeviceLocationId, DeviceLabel, active, DeviceUNCPath, tbPrinterList.ClientID, ref myscript, rowClass));
                    rowClass = rowClass == "GridViewRowStyle" ? "GridViewAlternatingRowStyle" : "GridViewRowStyle";
                }
            }

            //TableRow trLine = new TableRow();
            //TableCell tdHorizontalLine = new TableCell();
            //tdHorizontalLine.ColumnSpan = 12;
            //tdHorizontalLine.CssClass = "blackLine";
            //trLine.Cells.Add(tdHorizontalLine);
            //tbPrinterList.Rows.Add(trLine);
           
            PanelPrinterList.Controls.Add(tbPrinterList);
            myscript += "}catch(e){  Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);}}</script>";
            Page.RegisterClientScriptBlock(this.ClientID, myscript);
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

    private TableRow GenerateSubRows(DataRow dr, Int32 PrinterDeviceLocationId, string DeviceLabel, string active, string DeviceUNCPath, string tableId, ref string myscript, string rowClass)
    {
        try
        {
            CommonFunctions.Event_Trap(this);
            string newId = System.Guid.NewGuid().ToString();
            string tblId = this.ClientID + this.ClientIDSeparator + tableId;

            TableRow tblRow = new TableRow();
            tblRow.ID = "Tr_" + newId;
            TableCell tdPrinterId = new TableCell();
            tdPrinterId.Text = PrinterDeviceLocationId.ToString();

            TableCell tdActive = new TableCell();
            tdActive.Text = active;

            TableCell tdDeviceLabel = new TableCell();
            tdDeviceLabel.Text = DeviceLabel;

            TableCell tdDeviceUNCPath = new TableCell();
            tdDeviceUNCPath.Text = DeviceUNCPath;

            //TableCell tdPhone = new TableCell();
            //tdPhone.Text = Phone;

            //TableCell tdFax = new TableCell();
            //tdFax.Text = Fax;


            TableCell tdRadioButton = new TableCell();
            string rowId = this.ClientID + this.ClientIDSeparator + tblRow.ClientID;
            HtmlInputRadioButton rbTemp = new HtmlInputRadioButton();

            rbTemp.Attributes.Add("PrinterDeviceLocationId", dr["PrinterDeviceLocationId"].ToString());
            rbTemp.ID = "Rb_" + PrinterDeviceLocationId.ToString();
            //if (Session["PrinterDeviceLocationId"] != null && Session["PrinterDeviceLocationId"].ToString() == PrinterDeviceLocationId.ToString())
            //    rbTemp.Checked = true;
            tdRadioButton.Controls.Add(rbTemp);

            myscript += "var Radiocontext" + PrinterDeviceLocationId + "={PrinterDeviceLocationId:" + PrinterDeviceLocationId + ",TableId:'" + tblId + "',RowId:'" + rowId + "'};";
            myscript += "var RadioclickCallback" + PrinterDeviceLocationId + " =";
            myscript += " Function.createCallback(" + this._onRadioClickEventHandler + ", Radiocontext" + PrinterDeviceLocationId + ");";
            myscript += "$addHandler($get('" + this.ClientID + this.ClientIDSeparator + rbTemp.ClientID + "'), 'click', RadioclickCallback" + PrinterDeviceLocationId + ");";

            TableCell tdDelete = new TableCell();
            HtmlImage imgTemp = new HtmlImage();
            imgTemp.ID = "Img_" + PrinterDeviceLocationId.ToString();


            imgTemp.Attributes.Add("PrinterDeviceLocationId", dr["PrinterDeviceLocationId"].ToString());
            imgTemp.Src = "~/App_Themes/Includes/Images/deleteIcon.gif";
            imgTemp.Attributes.Add("class", "handStyle");
            tdDelete.Controls.Add(imgTemp);

            myscript += "var Imagecontext" + PrinterDeviceLocationId + "={PrinterDeviceLocationId:" + PrinterDeviceLocationId + ",TableId:'" + tblId + "',RowId:'" + rowId + "'};";
            myscript += "var ImageclickCallback" + PrinterDeviceLocationId + " =";
            myscript += " Function.createCallback($deleteRecord, Imagecontext" + PrinterDeviceLocationId + ");";
            myscript += "$addHandler($get('" + this.ClientID + this.ClientIDSeparator + imgTemp.ClientID + "'), 'click', ImageclickCallback" + PrinterDeviceLocationId + ");";

            tblRow.Cells.Add(tdRadioButton);
            tblRow.Cells.Add(tdDelete);
            tblRow.Cells.Add(tdPrinterId);
            tblRow.Cells.Add(tdActive);
            tblRow.Cells.Add(tdDeviceLabel);
            tblRow.Cells.Add(tdDeviceUNCPath);
            //tblRow.Cells.Add(tdPhone);
            //tblRow.Cells.Add(tdFax);
            tblRow.CssClass = rowClass;
            return tblRow;
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

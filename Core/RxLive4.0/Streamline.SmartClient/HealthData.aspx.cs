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
using System.Collections.Generic;

public partial class HealthData : Streamline.BaseLayer.ActivityPages.ActivityPage
{
    string strFormula = "";
    protected override void Page_Load(object sender, EventArgs e)
    {
        try
        {
            if (Request["FunctionId"] != null)
            {
                if (Request["FunctionId"].ToString() == "GetHealthDataList")
                {
                    if (Request["par0"] != null && Request["par0"].ToString() != string.Empty)
                        GenerateHealthDataRow(Convert.ToInt32(Request["par0"]));
                }
            }
            else
            {
                if (!Page.IsPostBack)
                {

                    FillHealthDataCombo();
                    if (DropDownListHealthData.SelectedValue != "")
                        GenerateHealthDataRow(Convert.ToInt32(DropDownListHealthData.SelectedValue));

                    TextBoxDate.Text = DateTime.Now.ToString("MM/dd/yyyy");
                    if (Session["HealthDataList"] != null)
                    {
                        DataRow[] drHealthData = ((DataSet)Session["HealthDataList"]).Tables[0].Select("HealthDataId=" + Convert.ToUInt32(Request.QueryString["HealthDataId"]));
                        if (drHealthData.Length > 0)
                            TextBoxDate.Text = ((DateTime)drHealthData[0]["DateRecorded"]).ToString("MM/dd/yyyy");
                    }
                    
                    if (Request["DropDownObject"] != null)
                        HiddenDropDownObject.Value = Request["DropDownObject"].ToString();
                    if (Request["PanelHealthDataList"] != null)
                        HiddenPanelHealthDataList.Value = Request["PanelHealthDataList"].ToString();
                    DropDownListHealthData.Attributes.Add("onchange", "FillHealthDataList();");
                    ButtonSave.Attributes.Add("onclick", "SaveHealthData(" + Convert.ToString(Request.QueryString["HealthDataId"]) + ");");
                }
            }
            DropDownListHealthData.Focus();
        }
        catch (Exception ex)
        {

            throw;
        }

    }


    private void GenerateHealthDataRow(int healthDataCategoryId)
    {
        DataRow[] dataRow;
        DataSet dataSetHealthData = null;
        try
        {
            CommonFunctions.Event_Trap(this);
            PanelHelthDataControl.Controls.Clear();
            Table tableHealthDataList = new Table();
            tableHealthDataList.ID = "tableHealthDataList";
            tableHealthDataList.Width = new Unit(98, UnitType.Percentage);
            Pair pairResult = new Pair();            
            if (Session["dataSetHealthData"] != null)
            {
                dataSetHealthData = (DataSet)Session["dataSetHealthData"];

            }
            
            dataRow = dataSetHealthData.Tables[0].Select("HealthDataCategoryId=" + healthDataCategoryId);

            if (dataRow.Length > 0)
            {
                foreach (DataRow dataRowHealthDataCategory in dataRow)
                {
                    for (int loopCounter = 0; loopCounter < 12; loopCounter++)
                    {
                        tableHealthDataList.Rows.Add(this.GenerateHealthDataSubRow(dataRowHealthDataCategory, tableHealthDataList.ClientID, loopCounter));
                    }
                }
            }

            PanelHelthDataControl.Controls.Add(tableHealthDataList);
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
    /// Mohit 
    /// Fills the HealthCategoryData combo 
    /// Nov-20-2009
    /// </summary>
    private void FillHealthDataCombo()
    {

        DataSet DataSetHealthCategoryData = null;

        Streamline.UserBusinessServices.SharedTables objectSharedTables = null;
        objectSharedTables = new Streamline.UserBusinessServices.SharedTables();
        try
        {

            DataSetHealthCategoryData = objectSharedTables.getHealthCategoryData();
            CommonFunctions.Event_Trap(this);
            DataView dataViewHealthData = DataSetHealthCategoryData.Tables[0].DefaultView;
            dataViewHealthData.Sort = "CategoryName ASC";
            DropDownListHealthData.DataSource = dataViewHealthData;
            DropDownListHealthData.DataTextField = "CategoryName";
            DropDownListHealthData.DataValueField = "HealthDataCategoryId";
            DropDownListHealthData.DataBind();
            //drpData.Items.Insert(0, new ListItem("........Select Data........", "0"));
            if (Request.QueryString["HealthDataCategoryId"] != null)
                DropDownListHealthData.SelectedValue = Convert.ToString(Request.QueryString["HealthDataCategoryId"]);
            else
                DropDownListHealthData.SelectedIndex = 0;
            Session["dataSetHealthData"] = DataSetHealthCategoryData;
        }
        catch (Exception ex)
        {

            if (ex.Data["CustomExceptionInformation"] == null)
                ex.Data["CustomExceptionInformation"] = CommonFunctions.Event_FormatString("###Source Function Name - getHealthCategoryData(),ParameterCount 0 - ###");
            else
                ex.Data["CustomExceptionInformation"] = CommonFunctions.Event_FormatString(ex.Data["CustomExceptionInformation"].ToString());
            if (ex.Data["DatasetInfo"] == null)
                ex.Data["DatasetInfo"] = null;
            Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);

        }
        finally
        {

        }

    }



    private TableRow GenerateHealthDataSubRow(DataRow dataRowHealthDataCategory, string tableId, int rowIndex)
    {
        try
        {
            int rowIndexId = rowIndex + 1;
             CommonFunctions.Event_Trap(this);
            string newId = System.Guid.NewGuid().ToString();
            string tblId = this.ClientID + this.ClientIDSeparator + tableId;

            DataSet dataSetHelathDataList = new DataSet();
            DataRow[] dtRowHealthData = null;
            if (Request.QueryString["HealthDataId"] != null)
            {
                if (Session["HealthDataList"] != null)
                {
                    dataSetHelathDataList = (DataSet)Session["HealthDataList"];
                    dtRowHealthData = dataSetHelathDataList.Tables[0].Select("HealthDataId=" + Convert.ToUInt32(Request.QueryString["HealthDataId"]));
                }
            }

            TableRow tableRow = new TableRow();
            tableRow.ID = "Tr_" + newId;

            string rowId = System.Guid.NewGuid().ToString();

            TableCell tdItemName = new TableCell();
            tdItemName.CssClass = "labelFont";

            TableCell tdEmptyCell = new TableCell();
            tdEmptyCell.Width = new Unit(10, UnitType.Percentage);
            HiddenField hiddenFieldValue = new HiddenField();
            hiddenFieldValue.ID = "hiddenFieldValue";
            tdEmptyCell.Controls.Add(hiddenFieldValue);

            string itemName = "";
            itemName = dataRowHealthDataCategory["ItemName" + rowIndexId.ToString()].ToString();
            hiddenFieldValue.Value = rowIndexId.ToString();
            tdItemName.Text = itemName;



            TableCell tdItemValue = new TableCell();
            TextBox TextBoxItemValue = new TextBox();
            TextBoxItemValue.ID = "TextBoxItemValue" + rowIndexId;
            TextBoxItemValue.Width = new Unit(50, UnitType.Pixel);
            TextBoxItemValue.Style.Add("text-align", "right");
            TextBoxItemValue.MaxLength = 5;

            TextBoxItemValue.Attributes.Add("onkeypress", "doKeyPress(this);");
            CheckBox CheckBoxItem = new CheckBox();
            CheckBoxItem.ID = "CheckBoxItem" + rowIndexId;


            tdItemValue.Width = new Unit(20, UnitType.Percentage);
            tdItemValue.Attributes.Add("align", "right");

            TableCell tdUnits = new TableCell();
            string itemUnits = "";
            itemUnits = dataRowHealthDataCategory["ItemUnit" + rowIndexId.ToString()].ToString();
            if (dataRowHealthDataCategory["itemFormula" + rowIndexId.ToString()].ToString() != System.DBNull.Value.ToString())
                    {
                        TextBoxItemValue.Enabled = false;
                        if (HiddenFormula.Value == "")
                    HiddenFormula.Value = "Formula" + rowIndexId.ToString() + ":" + dataRowHealthDataCategory["itemFormula" + rowIndexId.ToString()].ToString();
                        else
                    HiddenFormula.Value += "," + "Formula" + rowIndexId.ToString() + ":" + dataRowHealthDataCategory["itemFormula" + rowIndexId.ToString()].ToString();
                        TextBoxItemValue.BackColor = System.Drawing.Color.FromName("#EFEBDE");
            }
            if (dataRowHealthDataCategory["ItemCheckBox" + rowIndexId.ToString()].ToString() != System.DBNull.Value.ToString() && dataRowHealthDataCategory["ItemCheckBox" + rowIndexId.ToString()].ToString() != "N")
            {
                        if (dtRowHealthData != null)
                        {
                            if (dtRowHealthData.Length > 0)
                            {
                        if (Convert.ToString(dtRowHealthData[0]["ItemChecked" + rowIndexId.ToString()]) == "Y")
                                    CheckBoxItem.Checked = true;
                                else
                                    CheckBoxItem.Checked = false;                               
                            }
                        }
                        else
                        CheckBoxItem.Checked = false;
                CheckBoxItem.TabIndex = (short)(rowIndexId + 1);
                        tdItemValue.Controls.Add(CheckBoxItem);

                    }
                    else
                    {
                TextBoxItemValue.TabIndex = (short)(rowIndexId + 1);
                        tdItemValue.Controls.Add(TextBoxItemValue);
                        if (dtRowHealthData != null)
                        {
                            if (dtRowHealthData.Length > 0)
                        TextBoxItemValue.Text = Decimal.Parse(dtRowHealthData[0]["ItemValue" + rowIndexId.ToString()].ToString() == "" ? "0" : dtRowHealthData[0]["ItemValue" + rowIndexId.ToString()].ToString()).ToString("0.##");
                }

            }

            if (dataRowHealthDataCategory["itemDecimalPlaces" + rowIndexId.ToString()].ToString() != System.DBNull.Value.ToString() && dataRowHealthDataCategory["itemDecimalPlaces" + rowIndexId.ToString()].ToString() != "0")
            {
                if (HiddenDecimal.Value == "")
                    HiddenDecimal.Value = "Decimal" + rowIndexId.ToString() + ":" + dataRowHealthDataCategory["itemDecimalPlaces" + rowIndexId.ToString()].ToString();
                        else
                    HiddenDecimal.Value += "," + "Decimal" + rowIndexId.ToString() + ":" + dataRowHealthDataCategory["itemDecimalPlaces" + rowIndexId.ToString()].ToString();
            }
            
            tdUnits.Text = itemUnits;
            tdUnits.CssClass = "Label";
            TextBoxItemValue.Attributes.Add("onblur", "SetFormula();");
            if (itemName != "")
            {
                tableRow.Cells.Add(tdItemName);
                tableRow.Cells.Add(tdEmptyCell);
                tableRow.Cells.Add(tdItemValue);
                tableRow.Cells.Add(tdUnits);
            }

            return tableRow;
        }
        catch (Exception ex)
        {
            throw (ex);
        }
    }

}

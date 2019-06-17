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

public partial class HealthDataList : Streamline.BaseLayer.ActivityPages.ActivityPage
    {
    protected override void Page_Load(object sender, EventArgs e)
        {
        BindhealthDataDropDown();
        BindHealthDataGraphDropDown();
        if (DropDownHealthDataCategory.SelectedValue != null)
            {
            GenerateRows(Convert.ToInt32(DropDownHealthDataCategory.SelectedValue));
            }
        //DropDownHealthDataListGraph.Attributes.Add("onchange", "GetHealthGraph();");
        if (!Page.IsPostBack)
            {
            TextBoxStartDate.Text = DateTime.Now.AddYears(-1).ToShortDateString();
            TextBoxEndDate.Text = DateTime.Now.ToShortDateString();
            }
        }
    DataSet _DataSetHealthDataList = null;
    Streamline.UserBusinessServices.ClientMedication objectClientMedications;
    private string _onDeleteEventHandler = "onHealthDataDeleteClick";

    public string onDeleteEventHandler
        {
        get { return _onDeleteEventHandler; }
        set { _onDeleteEventHandler = value; }
        }
    private string _onHeaderClick = "onHealthDataHeaderClick";

    //public string OnHeaderClick
    //{
    //    get { return _onHeaderClick; }
    //    set { _onHeaderClick = value; }
    //}
    private string _sortString = "";

    public string SortString
        {
        get { return _sortString; }
        set { _sortString = value; }
        }
    private string _deleteRowMessage = "Are you sure you want to delete this row?";

    public string DeleteRowMessage
        {
        get { return _deleteRowMessage; }
        set { _deleteRowMessage = value; }
        }
    public string setAttributes()
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
    //Added By Anuj on 25 Nov,2009 for task ref #34 SDI venture -10
    public void GenerateRows(int HealthDataCategoryId)
        {
        try
            {
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
            PanelHealthDataList.Controls.Clear();
            objectClientMedications = new ClientMedication();
            Table tblHealthdata = new Table();
            tblHealthdata.ID = System.Guid.NewGuid().ToString();
            tblHealthdata.Width = new Unit(100, UnitType.Percentage);
            TableHeaderRow thTitle = new TableHeaderRow();
            TableHeaderCell thcBlank1 = new TableHeaderCell();
            TableHeaderCell thcDateRecorded = new TableHeaderCell();
            TableHeaderCell thcItemValue1 = new TableHeaderCell();
            TableHeaderCell thcItemValue2 = new TableHeaderCell();
            TableHeaderCell thcItemValue3 = new TableHeaderCell();
            TableHeaderCell thcItemValue4 = new TableHeaderCell();
            TableHeaderCell thcItemValue5 = new TableHeaderCell();
            TableHeaderCell thcItemValue6 = new TableHeaderCell();

            int ClientId = 0;
            ClientId = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId;
            _DataSetHealthDataList = objectClientMedications.GetHeathDataListRecords(ClientId, HealthDataCategoryId);
            //Creating table header Cell
            thcDateRecorded.Text = "Date";
            thcDateRecorded.Font.Underline = true;
            //thcDateRecorded.Attributes.Add("onClick", "onHealthDataHeaderClick(this)");
            //thcDateRecorded.Attributes.Add("ColumnName", "Date");
            //thcDateRecorded.Attributes.Add("SortOrder", setAttributes());
            thcDateRecorded.CssClass = "handStyle";
            thcDateRecorded.Width = 120;

            if (_DataSetHealthDataList.Tables["HealthDataListHeader"].Rows.Count > 0)
                {
                string itemValue1 = _DataSetHealthDataList.Tables["HealthDataListHeader"].Rows[0]["ItemName1"] == DBNull.Value ? "" : _DataSetHealthDataList.Tables["HealthDataListHeader"].Rows[0]["ItemName1"].ToString();
                string itemValue2 = _DataSetHealthDataList.Tables["HealthDataListHeader"].Rows[0]["ItemName2"] == DBNull.Value ? "" : _DataSetHealthDataList.Tables["HealthDataListHeader"].Rows[0]["ItemName2"].ToString();
                string itemValue3 = _DataSetHealthDataList.Tables["HealthDataListHeader"].Rows[0]["ItemName3"] == DBNull.Value ? "" : _DataSetHealthDataList.Tables["HealthDataListHeader"].Rows[0]["ItemName3"].ToString();
                string itemValue4 = _DataSetHealthDataList.Tables["HealthDataListHeader"].Rows[0]["ItemName4"] == DBNull.Value ? "" : _DataSetHealthDataList.Tables["HealthDataListHeader"].Rows[0]["ItemName4"].ToString();
                string itemValue5 = _DataSetHealthDataList.Tables["HealthDataListHeader"].Rows[0]["ItemName5"] == DBNull.Value ? "" : _DataSetHealthDataList.Tables["HealthDataListHeader"].Rows[0]["ItemName5"].ToString();
                string itemValue6 = _DataSetHealthDataList.Tables["HealthDataListHeader"].Rows[0]["ItemName6"] == DBNull.Value ? "" : _DataSetHealthDataList.Tables["HealthDataListHeader"].Rows[0]["ItemName6"].ToString();

                thcItemValue1.Text = itemValue1;
                thcItemValue1.Font.Underline = true;
                //thcItemValue1.Attributes.Add("onClick", "onHealthDataHeaderClick(this)");
                //thcItemValue1.Attributes.Add("ColumnName", itemValue1);
                //thcItemValue1.Attributes.Add("SortOrder", setAttributes());
                thcItemValue1.CssClass = "handStyle";


                thcItemValue2.Text = itemValue2;
                thcItemValue2.Font.Underline = true;
                // thcItemValue2.Attributes.Add("onClick", "onHealthDataHeaderClick(this)");
                // thcItemValue2.Attributes.Add("ColumnName", itemValue2);
                // thcItemValue2.Attributes.Add("SortOrder", setAttributes());
                thcItemValue2.CssClass = "handStyle";


                thcItemValue3.Text = itemValue3;
                thcItemValue3.Font.Underline = true;
                // thcItemValue3.Attributes.Add("onClick", "onHealthDataHeaderClick(this)");
                // thcItemValue3.Attributes.Add("ColumnName", itemValue3);
                //  thcItemValue3.Attributes.Add("SortOrder", setAttributes());
                thcItemValue3.CssClass = "handStyle";


                thcItemValue4.Text = itemValue4;
                thcItemValue4.Font.Underline = true;
                // thcItemValue4.Attributes.Add("onClick", "onHealthDataHeaderClick(this)");
                // thcItemValue4.Attributes.Add("ColumnName", itemValue4);
                //  thcItemValue4.Attributes.Add("SortOrder", setAttributes());
                thcItemValue4.CssClass = "handStyle";

                thcItemValue5.Text = itemValue5;
                thcItemValue5.Font.Underline = true;
                // thcItemValue5.Attributes.Add("onClick", "onHealthDataHeaderClick(this)");
                // thcItemValue5.Attributes.Add("ColumnName", itemValue5);
                // thcItemValue5.Attributes.Add("SortOrder", setAttributes());
                thcItemValue5.CssClass = "handStyle";

                thcItemValue6.Text = itemValue6;
                thcItemValue6.Font.Underline = true;
                // thcItemValue6.Attributes.Add("onClick", "onHealthDataHeaderClick(this)");
                // thcItemValue6.Attributes.Add("ColumnName", itemValue6);
                //  thcItemValue6.Attributes.Add("SortOrder", setAttributes());
                thcItemValue6.CssClass = "handStyle";
                // End Creating table header cell


                //Adding HeaderCells in HeaderRow
                thTitle.Cells.Add(thcBlank1);
                thTitle.Cells.Add(thcDateRecorded);

                if (itemValue1 != null && itemValue1 != "")
                    {
                    thTitle.Cells.Add(thcItemValue1);
                    }
                if (itemValue2 != null && itemValue2 != "")
                    {
                    thTitle.Cells.Add(thcItemValue2);
                    }
                if (itemValue3 != null && itemValue3 != "")
                    {
                    thTitle.Cells.Add(thcItemValue3);
                    }
                if (itemValue4 != null && itemValue4 != "")
                    {
                    thTitle.Cells.Add(thcItemValue4);
                    }
                if (itemValue5 != null && itemValue5 != "")
                    {
                    thTitle.Cells.Add(thcItemValue5);
                    }
                if (itemValue6 != null && itemValue6 != "")
                    {
                    thTitle.Cells.Add(thcItemValue6);
                    }
                }
            //End Adding HeaderCells in HeaderRow                                  
            thTitle.CssClass = "GridViewHeaderText";
            tblHealthdata.Rows.Add(thTitle);


            string myscript = "<script id='HealthDataListScript' type='text/javascript'>";
            myscript += "function $deleteRecord(sender,e){";
            if (!string.IsNullOrEmpty(_deleteRowMessage))
                {
               // myscript += " if(confirm('" + _deleteRowMessage + " ')==true){ " + this._onDeleteEventHandler + "(sender,e);  }}";
                    myscript += this._onDeleteEventHandler + "(sender,e);  }";
                }
            else
                {
                myscript += "}";
                }
            myscript += "function RegisterHealthDataListControlEvents(){try{ ";
            //int ClientId = 0;
            //ClientId = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId;
            //_DataSetHealthDataList = objectClientMedications.GetHeathDataListRecords(ClientId, HealthDataCategoryId);
            if (_DataSetHealthDataList.Tables["HealthDataList"].Rows.Count > 0)
                {
                foreach (DataRow drHealthData in _DataSetHealthDataList.Tables["HealthDataList"].Rows)
                    {
                    int healthDataId = Convert.ToInt32(drHealthData["HealthDataId"]);
                    //int healthDataCategoryId = Convert.ToInt32(drHealthData["HealthDataCategoryId"]);
                    string itemValue1 = drHealthData["ItemValue1"] == DBNull.Value ? "" : drHealthData["ItemValue1"].ToString();
                    string itemValue2 = drHealthData["ItemValue2"] == DBNull.Value ? "" : drHealthData["ItemValue2"].ToString();
                    string itemValue3 = drHealthData["ItemValue3"] == DBNull.Value ? "" : drHealthData["ItemValue3"].ToString();
                    string itemValue4 = drHealthData["ItemValue4"] == DBNull.Value ? "" : drHealthData["ItemValue4"].ToString();
                    string itemValue5 = drHealthData["ItemValue5"] == DBNull.Value ? "" : drHealthData["ItemValue5"].ToString();
                    string itemValue6 = drHealthData["ItemValue6"] == DBNull.Value ? "" : drHealthData["ItemValue6"].ToString();
                    string DateRecorded = "";
                    //Code added by Loveena in ref to Changes for changing the text color
                    string itemColor1 = drHealthData["ItemColor1"] == DBNull.Value ? "" : drHealthData["ItemColor1"].ToString();
                    string itemColor2 = drHealthData["ItemColor2"] == DBNull.Value ? "" : drHealthData["ItemColor2"].ToString();
                    string itemColor3 = drHealthData["ItemColor3"] == DBNull.Value ? "" : drHealthData["ItemColor3"].ToString();
                    string itemColor4 = drHealthData["ItemColor4"] == DBNull.Value ? "" : drHealthData["ItemColor4"].ToString();
                    string itemColor5 = drHealthData["ItemColor5"] == DBNull.Value ? "" : drHealthData["ItemColor5"].ToString();
                    string itemColor6 = drHealthData["ItemColor6"] == DBNull.Value ? "" : drHealthData["ItemColor6"].ToString();
                    //Code ends over here.

                    DateRecorded = drHealthData["DateRecorded"] == DBNull.Value ? "" : drHealthData["DateRecorded"].ToString();
                    if (DateRecorded != "")
                        {
                        DateRecorded = Convert.ToDateTime(DateRecorded).ToString("MM/dd/yyyy");
                        }
                    else
                        {
                        DateRecorded = "";
                        }
                    string newId = System.Guid.NewGuid().ToString();
                    TableRow trHealthDataRow = new TableRow();
                    trHealthDataRow.ID = "Tr_" + newId;
                    string rowId = this.ClientID + this.ClientIDSeparator + trHealthDataRow.ClientID;
                    string tableId = this.ClientID + this.ClientIDSeparator + tblHealthdata.ClientID;
                    TableCell tdDeleteHealthData = new TableCell();
                    HtmlImage imgTemp = new HtmlImage();
                    imgTemp.ID = "Img_" + healthDataId.ToString();
                    imgTemp.Attributes.Add("HealthDataId", drHealthData["HealthDataId"].ToString());

                    imgTemp.Src = "~/App_Themes/Includes/Images/deleteIcon.gif";
                    imgTemp.Attributes.Add("class", "handStyle");
                    imgTemp.Attributes.Add("onClick", "onHealthDataDeleteClick('" + healthDataId + "','" + tableId + "','" + rowId + "')");
                    tdDeleteHealthData.Controls.Add(imgTemp);
                    //myscript += "var Imagecontext" + healthDataId + "={HealthDataId:" + healthDataId + ",TableId:'" + tableId + "',RowId:'" + rowId + "'};";
                    //myscript += "var ImageclickCallback" + healthDataId + " =";
                    //myscript += " Function.createCallback($deleteRecord, Imagecontext" + healthDataId + ");";
                    //myscript += "$addHandler($get('" + this.ClientID + this.ClientIDSeparator + imgTemp.ClientID + "'), 'click', ImageclickCallback" + healthDataId + ");";

                    trHealthDataRow.Cells.Add(tdDeleteHealthData);

                    TableCell tdDateRecorded = new TableCell();
                    //tdDateRecorded.CssClass = "textbolditalic";
                    tdDateRecorded.Text = DateRecorded;
                    trHealthDataRow.Cells.Add(tdDateRecorded);

                    TableCell tdItemValue1 = new TableCell();
                    //tdItemValue1.CssClass = "textbolditalic";
                    if (itemValue1 != null && itemValue1 != "")
                        {
                        tdItemValue1.Text = itemValue1;
                        if (itemColor1 != null && itemColor1 != "")
                            {
                            switch (itemColor1)
                                {
                                case "R":
                                    tdItemValue1.Style.Add("color", "Red");
                                    break;
                                case "Y":
                                    tdItemValue1.Style.Add("color", "#F5B800");//Added by Chandan on 17/02/2010 for list yellow color task#34
                                    break;
                                }
                            }
                        trHealthDataRow.Cells.Add(tdItemValue1);
                        }


                    TableCell tdItemValue2 = new TableCell();
                    //tdItemValue2.CssClass = "textbolditalic";
                    if (itemValue2 != null && itemValue2 != "")
                        {
                        tdItemValue2.Text = itemValue2;
                        if (itemColor2 != null && itemColor2 != "")
                            {
                            switch (itemColor2)
                                {
                                case "R":
                                    tdItemValue2.Style.Add("color", "Red");
                                    break;
                                case "Y":
                                    tdItemValue2.Style.Add("color", "#F5B800");//Added by Chandan on 17/02/2010 for list yellow color task#34
                                    break;
                                }
                            }
                        trHealthDataRow.Cells.Add(tdItemValue2);
                        }

                    TableCell tdItemValue3 = new TableCell();
                    //tdItemValue3.CssClass = "textbolditalic";
                    if (itemValue3 != null && itemValue3 != "")
                        {
                        tdItemValue3.Text = itemValue3;
                        if (itemColor3 != null && itemColor3 != "")
                            {
                            switch (itemColor3)
                                {
                                case "R":
                                    tdItemValue3.Style.Add("color", "Red");
                                    break;
                                case "Y":
                                    tdItemValue3.Style.Add("color", "#F5B800");//Added by Chandan on 17/02/2010 for list yellow color task#34
                                    break;
                                }
                            }
                        trHealthDataRow.Cells.Add(tdItemValue3);
                        }
                    TableCell tdItemValue4 = new TableCell();
                    //tdItemValue4.CssClass = "textbolditalic";
                    if (itemValue4 != null && itemValue4 != "")
                        {
                        tdItemValue4.Text = itemValue4;
                        if (itemColor4 != null && itemColor4 != "")
                            {
                            switch (itemColor4)
                                {
                                case "R":
                                    tdItemValue4.Style.Add("color", "Red");
                                    break;
                                case "Y":
                                    tdItemValue4.Style.Add("color", "#F5B800");//Added by Chandan on 17/02/2010 for list yellow color task#34
                                    break;
                                }
                            }
                        trHealthDataRow.Cells.Add(tdItemValue4);
                        }
                    TableCell tdItemValue5 = new TableCell();
                    //tdItemValue5.CssClass = "textbolditalic";
                    if (itemValue5 != null && itemValue5 != "")
                        {
                        tdItemValue5.Text = itemValue5;
                        if (itemColor5 != null && itemColor5 != "")
                            {
                            switch (itemColor5)
                                {
                                case "R":
                                    tdItemValue5.Style.Add("color", "Red");
                                    break;
                                case "Y":
                                    tdItemValue5.Style.Add("color", "#F5B800");//Added by Chandan on 17/02/2010 for list yellow color task#34
                                    break;
                                }
                            }
                        trHealthDataRow.Cells.Add(tdItemValue5);
                        }

                    TableCell tdItemValue6 = new TableCell();
                    //tdItemValue6.CssClass = "textbolditalic";
                    if (itemValue6 != null && itemValue6 != "")
                        {
                        tdItemValue6.Text = itemValue6;
                        if (itemColor6 != null && itemColor6 != "")
                            {
                            switch (itemColor6)
                                {
                                case "R":
                                    tdItemValue6.Style.Add("color", "Red");
                                    break;
                                case "Y":
                                    tdItemValue6.Style.Add("color", "#F5B800");//Added by Chandan on 17/02/2010 for list yellow color task#34
                                    break;
                                }
                            }
                        trHealthDataRow.Cells.Add(tdItemValue6);
                        }

                    tblHealthdata.Rows.Add(trHealthDataRow);


                    //TableRow trLine = new TableRow();
                    //TableCell tdHorizontalLine = new TableCell();                      
                    //tdHorizontalLine.ColumnSpan = 14;
                    //tdHorizontalLine.CssClass = "blackLine";
                    //trLine.Cells.Add(tdHorizontalLine);
                    //tblHealthdata.Rows.Add(trLine);


                    }
                }
            PanelHealthDataList.Controls.Add(tblHealthdata);
            myscript += "}catch(e){  Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);}}</script>";
            ScriptManager.RegisterStartupScript(DropDownHealthDataCategory, DropDownHealthDataCategory.GetType(), DropDownHealthDataCategory.ClientID.ToString(), myscript, false);

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
    //Added By Anuj on 25 Nov,2009 for task ref #34 SDI venture -10
    private void BindhealthDataDropDown()
        {
        DataSet _DataSetHealthDataCategory = null;
        _DataSetHealthDataCategory = new DataSet();
        int ClientId = 0;
        ClientId = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId;
        objectClientMedications = new ClientMedication();
        try
            {
            _DataSetHealthDataCategory = objectClientMedications.GetHeathDataCategories(ClientId);
            if (_DataSetHealthDataCategory.Tables["HealthDataCategory"].Rows.Count > 0)
                {
                DataView dataViewHealthData = _DataSetHealthDataCategory.Tables["HealthDataCategory"].DefaultView;
                dataViewHealthData.Sort = "CategoryName ASC";
                DropDownHealthDataCategory.DataValueField = "HealthDataCategoryId";
                DropDownHealthDataCategory.DataTextField = "CategoryName";
                DropDownHealthDataCategory.DataSource = dataViewHealthData;
                DropDownHealthDataCategory.DataBind();
                }
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

    //Added By Anuj on 27 Nov,2009 for task ref #34 SDI venture -10
    private void BindHealthDataGraphDropDown()
        {
        DataSet _DataSetHealthDataListGraph = null;
        _DataSetHealthDataListGraph = new DataSet();
        int ClientId = 0;
        ClientId = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId;
        objectClientMedications = new ClientMedication();
        try
            {
            _DataSetHealthDataListGraph = objectClientMedications.GetHeathDataGraphDropDown(ClientId);
            if (_DataSetHealthDataListGraph.Tables["HealthDataListGraph"].Rows.Count > 0)
                {
                DataView dataViewHealthDataGraph = _DataSetHealthDataListGraph.Tables["HealthDataListGraph"].DefaultView;
                dataViewHealthDataGraph.Sort = "ItemDescription ASC";
                DropDownHealthDataListGraph.DataValueField = "HealthDataCategoryId";
                DropDownHealthDataListGraph.DataTextField = "ItemDescription";
                DropDownHealthDataListGraph.DataSource = dataViewHealthDataGraph;
                DropDownHealthDataListGraph.DataBind();
                }
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
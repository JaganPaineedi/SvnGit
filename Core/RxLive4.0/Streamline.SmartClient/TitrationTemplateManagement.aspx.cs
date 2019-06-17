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

public partial class TitrationTemplateManagement : Streamline.BaseLayer.ActivityPages.ActivityPage
{
    protected override void Page_Load(object sender, EventArgs e)
    {
        try
        {
            if (Request["FunctionId"].ToString() != string.Empty)
            {
                switch (Request["FunctionId"].ToString())
                {
                    case "DeleteTitrationTemplateList":
                        {
                            try
                            {
                                int TitrationTemplateId = Convert.ToInt32(Request["par0"].ToString());
                                string filterCondition = Request["par1"].ToString();
                                DeleteTitrationTemplate(TitrationTemplateId, filterCondition);
                            }
                            catch (Exception ex)
                            {
                            }
                            break;
                        }
                    case "GetTitrationTemplateList":
                        {
                            try
                            {
                                string FilterCondition = Request["par0"].ToString();
                                GenerateTitrationTemplateRows(FilterCondition);
                            }
                            catch (Exception ex)
                            {
                            }
                            break;
                        }
                }
            }
        }
        catch(Exception ex)
        {
        }
    }
    #region--User defined Property
    private bool _showDeleteIcon;

    public bool ShowDeleteIcon
    {
        get { return _showDeleteIcon; }
        set { _showDeleteIcon = value; }
    }
    private bool _isRadioChecked;

    public bool IsRadioChecked
    {
        get { return _isRadioChecked; }
        set { _isRadioChecked = value; }
    }
    #endregion
    public void DeleteTitrationTemplate(int TitrationTemplateId, string filterCondition)
    {
        Streamline.UserBusinessServices.DataSets.DataSetTitrationTemplate.TitrationTemplatesRow _drTitrationTemplates = null;
        Streamline.UserBusinessServices.DataSets.DataSetTitrationTemplate _dsTitrationTemplate = null;

        DataTable dataTableTitrationTemplate = null;
        Streamline.UserBusinessServices.ClientMedication objClientMedication = null;
        try
        {

            if (Session["DataSetTitrationTemplate"] != null)
            {
                _dsTitrationTemplate = (Streamline.UserBusinessServices.DataSets.DataSetTitrationTemplate)Session["DataSetTitrationTemplate"];
            }
            else
            {
                _dsTitrationTemplate = new Streamline.UserBusinessServices.DataSets.DataSetTitrationTemplate();
            }
            dataTableTitrationTemplate = _dsTitrationTemplate.TitrationTemplates;
            DataRow[] dataRowTitrationTemplate = dataTableTitrationTemplate.Select("TitrationTemplateId=" + TitrationTemplateId);
            if (dataRowTitrationTemplate.Length > 0)
            {
                dataRowTitrationTemplate[0]["RecordDeleted"] = "Y";
                dataRowTitrationTemplate[0]["DeletedDate"] = Convert.ToDateTime(DateTime.Now.ToShortDateString());
                //dataRowTitrationTemplate[0]["DeletedBy"] = Context.User.Identity.Name;
                dataRowTitrationTemplate[0]["DeletedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                dataRowTitrationTemplate[0]["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                dataRowTitrationTemplate[0]["ModifiedDate"] = Convert.ToDateTime(DateTime.Now.ToShortDateString());
            }

            objClientMedication = new ClientMedication();
            DataSet temp = new DataSet();
            temp = objClientMedication.UpdateDocuments(_dsTitrationTemplate);
            _dsTitrationTemplate.Clear();
            _dsTitrationTemplate.Merge(temp.Tables["TitrationTemplates"]);
            _dsTitrationTemplate.Merge(temp.Tables["TitrationTemplateInstructions"]);
            Session["DataSetTitrationTemplate"] = _dsTitrationTemplate;
            GenerateTitrationTemplateRows(filterCondition);
            //return 1;
        }
        catch (Exception ex)
        {
            throw (ex);
        }
    }
    /// <summary>
    /// <Description>Used to generate titration template header rows as per task#15(Venture 10.0)</Description>
    /// <Author>Pradeep</Author>
    /// <CreatedOn> 12 Nov 2009</CreatedOn>
    /// </summary>
    private void GenerateTitrationTemplateRows(string condition)
    {
        DataRow[] dataRow;
        DataSet dataSetTitrationTemplate = null;
        try
        {
            CommonFunctions.Event_Trap(this);
            PanelTitrationTraperList.Controls.Clear();
            Table tableTitrationTemplateList = new Table();
            tableTitrationTemplateList.ID = System.Guid.NewGuid().ToString();
            tableTitrationTemplateList.Width = new Unit(98, UnitType.Percentage);
            TableHeaderRow tableHeaderRowTitle = new TableHeaderRow();
            TableHeaderCell tableHeaderCellBlank1 = new TableHeaderCell();
            TableHeaderCell tableHeaderCellBlank2 = new TableHeaderCell();

            TableHeaderCell tableHeaderCellTemplateName = new TableHeaderCell();
            tableHeaderCellTemplateName.Text = "Template Name";
            tableHeaderCellTemplateName.Font.Underline = true;
            tableHeaderCellTemplateName.Attributes.Add("onClick", "onHeaderClick(this)");
            tableHeaderCellTemplateName.Attributes.Add("ColumnName", "TemplateName");
            tableHeaderCellTemplateName.CssClass = "handStyle";
            TableHeaderCell tableHeaderCellCreatedBy = new TableHeaderCell();
            tableHeaderCellCreatedBy.Text = "Created By";
            tableHeaderCellCreatedBy.Font.Underline = true;
            tableHeaderCellCreatedBy.Attributes.Add("onClick", "onHeaderClick(this)");
            tableHeaderCellCreatedBy.Attributes.Add("ColumnName", "CreatedBy");
            tableHeaderCellCreatedBy.CssClass = "handStyle";
            if (condition == "Client")
            {
                tableHeaderRowTitle.Cells.Add(tableHeaderCellBlank1);
                
            }
            tableHeaderRowTitle.Cells.Add(tableHeaderCellBlank2);
            //-----
            
            tableHeaderRowTitle.Cells.Add(tableHeaderCellTemplateName);
            #region--Comented Code
            //---------Star Conmentd by Pradeep as coment on task#15(Venture)
            //tableHeaderRowTitle.Cells.Add(tableHeaderCellInstruction);
            //tableHeaderRowTitle.Cells.Add(tableHeaderCellNumberOfDays);
            //tableHeaderRowTitle.Cells.Add(tableHeaderCellStrength);
            //tableHeaderRowTitle.Cells.Add(tableHeaderCellQuantity);
            //tableHeaderRowTitle.Cells.Add(tableHeaderCellUnit);
            //tableHeaderRowTitle.Cells.Add(tableHeaderCellSchedule);
            //tableHeaderRowTitle.Cells.Add(tableHeaderCellTitrationStepNumber);
            //tableHeaderRowTitle.Cells.Add(tableHeaderCellActive);
            //---------End Conmentd by Pradeep as coment on task#15(Venture)
            #endregion
            tableHeaderRowTitle.Cells.Add(tableHeaderCellCreatedBy);
            tableHeaderRowTitle.CssClass = "GridViewHeaderText";
            //---End Adding Heade Cell in Header Row
            //-----Start 13 nov
            if (Session["DataSetTitrationTemplate"] != null)
            {
                dataSetTitrationTemplate = (DataSet)Session["DataSetTitrationTemplate"];

            }
            //if (_dsTitrationTemplate!=null)
            //{
            if (condition=="Client")
            {
                dataRow = dataSetTitrationTemplate.Tables["TitrationTemplates"].Select("ISNULL(RecordDeleted,'N')='N' and StaffId=" + ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId);
                ShowDeleteIcon = true;
            }
            //else if (condition == "Others")
            //{
            //    dataRow = dataSetTitrationTemplate.Tables["TitrationTemplates"].Select("ISNULL(RecordDeleted,'N')='N' and StaffId<>" + ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId);
            //    ShowDeleteIcon = false;
            //}
            else
            {
                dataRow = dataSetTitrationTemplate.Tables["TitrationTemplates"].Select("ISNULL(RecordDeleted,'N')='N' and StaffId<>" + ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId);
                ShowDeleteIcon = false;
            }
            
           
            //}
            //-----End 13 Nov

            tableTitrationTemplateList.Controls.Add(tableHeaderRowTitle);

            string myscript = "<script id='TitrationTemplateList' type='text/javascript'>";
            myscript += "function RegisterTitrationTemplateControlEvents(){try{ ";
            if (dataRow.Length > 0)
            {
                #region--Comented Code
                //foreach (DataRow dataRowTitrationTemplate in dataRow)
                //{
                //    tableTitrationTemplateList.Rows.Add(this.GenerateTitrationTemplateSubRow(dataRowTitrationTemplate, tableTitrationTemplateList.ClientID, ref myscript));
                //    //-----For Seperater Line---
                //    TableRow trLine = new TableRow();
                //    TableCell tdHorizontalLine = new TableCell();
                //    tdHorizontalLine.ColumnSpan = 4;//--Changed value 12 to 13 as per task#32
                //    tdHorizontalLine.CssClass = "blackLine";
                //    trLine.Cells.Add(tdHorizontalLine);
                //    tableTitrationTemplateList.Rows.Add(trLine);
                //}
                #endregion
                for (int i = 0; i < dataRow.Length;i++ )
                {
                    if (i == 0)
                    {
                        this.IsRadioChecked = true;
                        
                    }
                    else
                    {
                        IsRadioChecked = false;
                    }
                    tableTitrationTemplateList.Rows.Add(this.GenerateTitrationTemplateSubRow(dataRow[i], tableTitrationTemplateList.ClientID, ref myscript));
                    TableRow trLine = new TableRow();
                    TableCell tdHorizontalLine = new TableCell();
                    tdHorizontalLine.ColumnSpan = 4;//--Changed value 12 to 13 as per task#32
                    tdHorizontalLine.CssClass = "blackLine";
                    trLine.Cells.Add(tdHorizontalLine);
                    tableTitrationTemplateList.Rows.Add(trLine);
                }
            }
            

            PanelTitrationTraperList.Controls.Add(tableTitrationTemplateList);
            myscript += "}catch(e){  Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);}}</script>";
            ScriptManager.RegisterStartupScript(LabelScriptManager, LabelScriptManager.GetType(), LabelScriptManager.ClientID.ToString(), myscript, false);


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
    /// <Description>Used to fill data into each Row in table </Description>
    /// <Author>Pradeep</Author>
    /// <CreatedOn>Nov 12,2009</CreatedOn>
    /// </summary>
    /// <param name="dataRowTitarationTemplate"></param>
    /// <returns></returns>
    private TableRow GenerateTitrationTemplateSubRow(DataRow dataRowTitarationTemplate, string tableId, ref string myscript)
    {
        try
        {
            CommonFunctions.Event_Trap(this);
            string newId = System.Guid.NewGuid().ToString();
            // string tblId = this.ClientID + this.ClientIDSeparator + tableId;
            int titrationTemplateId = Convert.ToInt32(dataRowTitarationTemplate["TitrationTemplateId"]);


            TableRow tableRow = new TableRow();
            tableRow.ID = "Tr_" + newId;

            // string rowId = this.ClientID + this.ClientIDSeparator + tableRow.ClientID;
            //----Start For Delete Icon---
            TableCell tdDelete = new TableCell();
            if (ShowDeleteIcon)
            {
                HtmlImage imgDelete = new HtmlImage();
                imgDelete.ID = "Img_" + titrationTemplateId.ToString();
                imgDelete.Attributes.Add("TitrationTemplateId", dataRowTitarationTemplate["TitrationTemplateId"].ToString());
                imgDelete.Src = "~/App_Themes/Includes/Images/deleteIcon.gif";
                imgDelete.Attributes.Add("class", "handStyle");
                tdDelete.Controls.Add(imgDelete);
                myscript += "var Imagecontext" + titrationTemplateId + ";";
                myscript += "var ImageclickCallback" + titrationTemplateId + " =";
                myscript += " Function.createCallback(DeleteTemplateRow , Imagecontext" + titrationTemplateId + ");";
                myscript += "$addHandler($get('" + imgDelete.ClientID + "'), 'click', ImageclickCallback" + titrationTemplateId + ");";
            }
                //----End For Delete Icon---

            //----Start For Radio Button---
            TableCell tdRadioButton = new TableCell();
            HtmlInputRadioButton radioButtonTemp = new HtmlInputRadioButton();
           // RadioButton radioButtonTemp = new RadioButton();
            radioButtonTemp.Attributes.Add("TitrationTemplateId", dataRowTitarationTemplate["TitrationTemplateId"].ToString());
            radioButtonTemp.ID = "Rb_" + titrationTemplateId.ToString();
            radioButtonTemp.Name = "Select";
            //--18 Nov
           // HiddenField hdnTitrationTemplateId = new HiddenField();
            
           //----
            if (IsRadioChecked)
            {
                radioButtonTemp.Checked = true;
                HdnTitrationTemplateId.Value = Convert.ToString(titrationTemplateId);
                //hdnTitrationTemplateId.Value = Convert.ToString(titrationTemplateId);
            }
            tdRadioButton.Controls.Add(radioButtonTemp);

            //myscript += "var Radiocontext" + titrationTemplateId + "={TitrationTemplateId:" + titrationTemplateId + ",TableId:'" + tableId + "',RowId:'" + rowId + "'};";
            //myscript += "var RadioclickCallback" + titrationTemplateId + " =";
            //myscript += " Function.createCallback(" + this._onRadioClickEventHandler + ", Radiocontext" + titrationTemplateId + ");";
            //myscript += "$addHandler($get('" + this.ClientID + this.ClientIDSeparator + radioButtonTemp.ClientID + "'), 'click', RadioclickCallback" + titrationTemplateId + ");";
            myscript += "var Radiocontext" + titrationTemplateId + ";";
            myscript += "var RadioclickCallback" + titrationTemplateId + " =";
            myscript += " Function.createCallback(onRadioTemplateClick, Radiocontext" + titrationTemplateId + ");";
            myscript += "$addHandler($get('" + radioButtonTemp.ClientID + "'), 'click', RadioclickCallback" + titrationTemplateId + ");";
            //----End For Radio Button---

            //--Start For Other Columns value
            TableCell tdTemplateName = new TableCell();
            tdTemplateName.Text = dataRowTitarationTemplate["TemplateName"] == DBNull.Value ? string.Empty : Convert.ToString(dataRowTitarationTemplate["TemplateName"]);
            tdTemplateName.CssClass = "Label";
            #region--Comented Code
            //---Start Comented By Pradeep as per coment on task#15
            //TableCell tdInstruction = new TableCell();
            //tdInstruction.Text = dataRowTitarationTemplate["Instructions"] == DBNull.Value ? string.Empty : Convert.ToString(dataRowTitarationTemplate["Instructions"]);

            //TableCell tdNumberOfDays = new TableCell();
            //tdNumberOfDays.Text = dataRowTitarationTemplate["NumberOfDays"] == DBNull.Value ? string.Empty : Convert.ToString(dataRowTitarationTemplate["NumberOfDays"]);

            //TableCell tdStrength = new TableCell();
            //tdStrength.Text = dataRowTitarationTemplate["Strength"] == DBNull.Value ? string.Empty : Convert.ToString(dataRowTitarationTemplate["Strength"]);

            //TableCell tdQuantity = new TableCell();
            //tdQuantity.Text = dataRowTitarationTemplate["Quantity"] == DBNull.Value ? string.Empty : Convert.ToString(dataRowTitarationTemplate["Quantity"]);

            //TableCell tdUnit = new TableCell();
            //tdUnit.Text = dataRowTitarationTemplate["Unit"] == DBNull.Value ? string.Empty : Convert.ToString(dataRowTitarationTemplate["Unit"]);

            //TableCell tdSchedule = new TableCell();
            //tdSchedule.Text = dataRowTitarationTemplate["Schedule"] == DBNull.Value ? string.Empty : Convert.ToString(dataRowTitarationTemplate["Schedule"]);

            //TableCell tdTitrationStepNumber = new TableCell();
            //tdTitrationStepNumber.Text = dataRowTitarationTemplate["TitrationStepNumber"] == DBNull.Value ? string.Empty : Convert.ToString(dataRowTitarationTemplate["TitrationStepNumber"]);

            //TableCell tdActive = new TableCell();
            //tdActive.Text = dataRowTitarationTemplate["Active"] == DBNull.Value ? string.Empty : Convert.ToString(dataRowTitarationTemplate["Active"]);
            //---End Comented By Pradeep as per coment on task#15
            #endregion
            TableCell tdCreatedBy = new TableCell();
            tdCreatedBy.Text = Convert.ToString(dataRowTitarationTemplate["CreatedBy"]);
            tdCreatedBy.CssClass = "Label";

            //--End For Other Columns value
            if (ShowDeleteIcon)
           {
            tableRow.Cells.Add(tdDelete);
           
           }
           
            tableRow.Cells.Add(tdRadioButton);
            tableRow.Cells.Add(tdTemplateName);
            #region--Comented Code
            //---Start Comented By Pradeep as per coment on task#15
            //tableRow.Cells.Add(tdNumberOfDays);
            //tableRow.Cells.Add(tdStrength);
            //tableRow.Cells.Add(tdQuantity);
            //tableRow.Cells.Add(tdUnit);
            //tableRow.Cells.Add(tdSchedule);
            //tableRow.Cells.Add(tdTitrationStepNumber);
            //tableRow.Cells.Add(tdActive);
            //---End Comented By Pradeep as per coment on task#15
            #endregion
            //-----Nov 18

           // tdCreatedBy.Controls.Add(hdnTitrationTemplateId);
            //-----
            tableRow.Cells.Add(tdCreatedBy);

            return tableRow;
        }
        catch (Exception ex)
        {
            throw (ex);
        }
    }
    #region---User Defined Variables and Properties
    public delegate void DeleteButtonClick(object sender, Streamline.BaseLayer.UserData e);
    public event DeleteButtonClick DeleteButtonClickEvent;

    // public delegate void RadioButtonClick(object sender, Streamline.BaseLayer.UserData e);
    //public event RadioButtonClick RadioButtonClickEvent;

    Streamline.UserBusinessServices.DataSets.DataSetTitrationTemplate _dsTitrationTemplate = null;
    Streamline.UserBusinessServices.DataSets.DataSetTitrationTemplate.TitrationTemplatesDataTable _dtTitrationTemplate = null;
    Streamline.UserBusinessServices.DataSets.DataSetTitrationTemplate.TitrationTemplateInstructionsDataTable _dtTitrationTemplateInstructionsDataTable = null;

    private string _sortString;

    public string SortString
    {
        get { return _sortString; }
        set { _sortString = value; }
    }

    private string _onRadioClickEventHandler = "onRadioTemplateClick";

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

    public string OnHeaderClick
    {
        get { return _onHeaderClick; }
        set { _onHeaderClick = value; }
    }
    /// <summary>
    /// <Description>Used to set atributes for sorting purpose</Description>
    /// <Author>Pradeep</Author>
    /// <CreatedOn>Nov 12,2009</CreatedOn>
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
    #endregion
    public void GetTitrationTemplateList(string filtercondition)
    {
        try
        {
        }
        catch(Exception ex)
        {
        }
    }
}

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
    public partial class UserControls_PharmaciesList : Streamline.BaseLayer.BaseActivityPage
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

        private string _onRadioClickEventHandler = "PharmacyManagement.onRadioClickPharmacy";
        private string _onRadioClickForSearchEventHandler = "onRadioClickSearch";

        public string onRadioClickForSearchEventHandler
        {
            get { return _onRadioClickForSearchEventHandler; }
            set { _onRadioClickForSearchEventHandler = value; }
        }


        public string onRadioClickEventHandler
        {
            get { return _onRadioClickEventHandler; }
            set { _onRadioClickEventHandler = value; }
        }

        private string _onDeleteEventHandler = "PharmacyManagement.onDeleteClick";

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
        //Added By priya Ref:task no:85
        private string _onHeaderSearchClick = "onHeaderSearchClick";


        public string OnHeaderClick
        {
            get { return _onHeaderClick; }
            set { _onHeaderClick = value; }
        }
        public string onHeaderSearchClick
        {
            get { return _onHeaderClick; }
            set { _onHeaderClick = value; }
        }




        protected override void Page_Load(object sender, EventArgs e)
        {
            try
            {

            }
            catch (Exception ex)
            {

                throw;
            }
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
        //Added One Parameter for Ref:Task no:85
        public void GenerateRows(DataTable _dtPharmacies, bool IsSearchPage)
        {
            try
            {
                PanelPharmacyList.Controls.Clear();
                Table tbPharmaciesList = new Table();
                tbPharmaciesList.ID = System.Guid.NewGuid().ToString();

                tbPharmaciesList.Width = new Unit(100, UnitType.Percentage);
                //tbPharmaciesList.Height = new Unit(100, UnitType.Pixel);
                TableHeaderRow thTitle = new TableHeaderRow();
                TableHeaderCell thBlank1 = new TableHeaderCell();
                TableHeaderCell thBlank2 = new TableHeaderCell();
                TableHeaderCell thc = new TableHeaderCell();

                //Pharmacy ID
                TableHeaderCell thID = new TableHeaderCell();
                thID.Text = "ID";
                thID.Font.Underline = true;
                
                thID.Attributes.Add("ColumnName", "PharmacyId");
                thID.Attributes.Add("SortOrder", setAttributes());
                //Code added by Loveena in ref to Task#3008
                if (_dtPharmacies.Rows.Count > 0)
                {
                    thID.CssClass = "handStyle";
                    if (IsSearchPage)
                        thID.Attributes.Add("onclick", "onHeaderSearchClick(this)");
                    else
                        thID.Attributes.Add("onclick", "onHeaderClick(this)");
                }
                thID.Attributes.Add("align", "left");
                if (SortString.Split(' ')[0] == "PharmacyId") thc = thID;

                //Active
                TableHeaderCell thActive = new TableHeaderCell();
                thActive.Text = "Active";
                thActive.Font.Underline = true;
                
                thActive.Attributes.Add("ColumnName", "Active");
                thActive.Attributes.Add("SortOrder", setAttributes());
                thActive.Style.Add("padding-right", "10px");
                //Code added by Loveena in ref to Task#3008
                if (_dtPharmacies.Rows.Count > 0)
                {
                    thActive.CssClass = "handStyle";
                    if (IsSearchPage)
                        thActive.Attributes.Add("onclick", "onHeaderSearchClick(this)");
                    else
                        thActive.Attributes.Add("onclick", "onHeaderClick(this)");

                }
                thActive.Attributes.Add("align", "left");
                if (SortString.Split(' ')[0] == "Active") thc = thActive;

                //Added By Priya to add new Field for Pharmacy Search Page Date 15th Feb 2010
                TableHeaderCell thPreferredPharmacy = new TableHeaderCell();
                if (IsSearchPage)
                {
                    //Preferred Pharmacy

                    thPreferredPharmacy.Text = "Preferred";
                    thPreferredPharmacy.Font.Underline = true;                    
                    thPreferredPharmacy.Attributes.Add("ColumnName", "PreferredPharmacy");
                    thPreferredPharmacy.Attributes.Add("SortOrder", setAttributes());
                    //Code added by Loveena in ref to Task#3008
                    if (_dtPharmacies.Rows.Count > 0)
                    {
                        thPreferredPharmacy.CssClass = "handStyle";
                        thPreferredPharmacy.Attributes.Add("onclick", "onHeaderSearchClick(this)");
                    }
                    thPreferredPharmacy.Attributes.Add("align", "left");
                    if (SortString.Split(' ')[0] == "PreferredPharmacy") thc = thPreferredPharmacy;

                }
                //Pharmacy Name
                TableHeaderCell thPharmacyName = new TableHeaderCell();
                thPharmacyName.Text = "Name";
                thPharmacyName.Font.Underline = true;
               

                thPharmacyName.Attributes.Add("ColumnName", "PharmacyName");
                thPharmacyName.Attributes.Add("SortOrder", setAttributes());
                //Code added by Loveena in ref to Task#3008
                if (_dtPharmacies.Rows.Count > 0)
                {
                    thPharmacyName.CssClass = "handStyle";
                    if (IsSearchPage)
                        thPharmacyName.Attributes.Add("onclick", "onHeaderSearchClick(this)");
                    else
                        thPharmacyName.Attributes.Add("onclick", "onHeaderClick(this)");
                }
                thPharmacyName.Attributes.Add("align", "left");
                if (SortString.Split(' ')[0] == "PharmacyName") thc = thPharmacyName;

                //Address
                TableHeaderCell thAddress = new TableHeaderCell();
                thAddress.Text = "Address";
                thAddress.Font.Underline = true;
                
                thAddress.Attributes.Add("ColumnName", "Address");
                thAddress.Attributes.Add("SortOrder", setAttributes());
                //Code added by Loveena in ref to Task#3008
                if (_dtPharmacies.Rows.Count > 0)
                {
                    thAddress.CssClass = "handStyle";
                    if (IsSearchPage)
                        thAddress.Attributes.Add("onclick", "onHeaderSearchClick(this)");
                    else
                        thAddress.Attributes.Add("onclick", "onHeaderClick(this)");

                }
                thAddress.Attributes.Add("align", "left");
                if (SortString.Split(' ')[0] == "Address") thc = thAddress;

                //City
                TableHeaderCell thCity = new TableHeaderCell();
                thCity.Text = "City";
                thCity.Font.Underline = true;

                thCity.Attributes.Add("ColumnName", "City");
                thCity.Attributes.Add("SortOrder", setAttributes());
                //Code added by Loveena in ref to Task#3008
                if (_dtPharmacies.Rows.Count > 0)
                {
                    thCity.CssClass = "handStyle";
                    if (IsSearchPage)
                        thCity.Attributes.Add("onclick", "onHeaderSearchClick(this)");
                    else
                        thCity.Attributes.Add("onclick", "onHeaderClick(this)");

                }
                thCity.Attributes.Add("align", "left");
                if (SortString.Split(' ')[0] == "City") thc = thCity;

                //State
                TableHeaderCell thState = new TableHeaderCell();
                thState.Text = "State";
                thState.Font.Underline = true;

                thState.Attributes.Add("ColumnName", "State");
                thState.Attributes.Add("SortOrder", setAttributes());
                thState.Style.Add("padding-right", "10px");
                //Code added by Loveena in ref to Task#3008
                if (_dtPharmacies.Rows.Count > 0)
                {
                    thState.CssClass = "handStyle";
                    if (IsSearchPage)
                        thState.Attributes.Add("onclick", "onHeaderSearchClick(this)");
                    else
                        thState.Attributes.Add("onclick", "onHeaderClick(this)");

                }
                thState.Attributes.Add("align", "left");
                if (SortString.Split(' ')[0] == "State") thc = thState;

                //State
                TableHeaderCell thZip = new TableHeaderCell();
                thZip.Text = "Zip Code";
                thZip.Font.Underline = true;

                thZip.Attributes.Add("ColumnName", "ZipCode");
                thZip.Attributes.Add("SortOrder", setAttributes());
                //Code added by Loveena in ref to Task#3008
                if (_dtPharmacies.Rows.Count > 0)
                {
                    thZip.CssClass = "handStyle";
                    if (IsSearchPage)
                        thZip.Attributes.Add("onclick", "onHeaderSearchClick(this)");
                    else
                        thZip.Attributes.Add("onclick", "onHeaderClick(this)");

                }
                thZip.Attributes.Add("align", "left");
                if (SortString.Split(' ')[0] == "ZipCode") thc = thZip;

                //Phone
                TableHeaderCell thPhone = new TableHeaderCell();
                thPhone.Text = "Phone";
                thPhone.Font.Underline = true;                
                thPhone.Attributes.Add("ColumnName", "PhoneNumber");
                thPhone.Attributes.Add("SortOrder", setAttributes());
                //Code added by Loveena in ref to Task#3008
                if (_dtPharmacies.Rows.Count > 0)
                {
                    thPhone.CssClass = "handStyle";
                    if (IsSearchPage)
                        thPhone.Attributes.Add("onclick", "onHeaderSearchClick(this)");
                    else
                        thPhone.Attributes.Add("onclick", "onHeaderClick(this)");

                }
                thPhone.Attributes.Add("align", "left");
                if (SortString.Split(' ')[0] == "PhoneNumber") thc = thPhone;

                //Fax
                TableHeaderCell thFax = new TableHeaderCell();
                thFax.Text = "Fax";
                thFax.Font.Underline = true;               
                thFax.Attributes.Add("ColumnName", "FaxNumber");
                thFax.Attributes.Add("SortOrder", setAttributes());
                //Code added by Loveena in ref to Task#3008
                if (_dtPharmacies.Rows.Count > 0)
                {
                    thFax.CssClass = "handStyle";
                    if (IsSearchPage)
                        thFax.Attributes.Add("onclick", "onHeaderSearchClick(this)");
                    else
                        thFax.Attributes.Add("onclick", "onHeaderClick(this)");
                }
                thFax.Attributes.Add("align", "left");
                if (SortString.Split(' ')[0] == "FaxNumber") thc = thFax;

                TableHeaderCell thSpecialty = new TableHeaderCell();
                thSpecialty.Text = "Specialty";
                thSpecialty.Font.Underline = true;
                thSpecialty.Attributes.Add("ColumnName", "Specialty");
                thSpecialty.Attributes.Add("SortOrder", setAttributes());
                //Code added by Loveena in ref to Task#3008
                if (_dtPharmacies.Rows.Count > 0)
                {
                    thSpecialty.CssClass = "handStyle";
                    if (IsSearchPage)
                        thSpecialty.Attributes.Add("onclick", "onHeaderSearchClick(this)");
                    else
                        thSpecialty.Attributes.Add("onclick", "onHeaderClick(this)");
                }
                thSpecialty.Attributes.Add("align", "left");
                if (SortString.Split(' ')[0] == "Specialty") thc = thSpecialty;

                //Added By Priya
                TableHeaderCell thSureScriptsPharmacyIdentifier = new TableHeaderCell();
                if (IsSearchPage)
                {
                    //Preferred Pharmacy

                    thSureScriptsPharmacyIdentifier.Text = "SureScripts Identifier";
                    thSureScriptsPharmacyIdentifier.Font.Underline = true;                    
                    thSureScriptsPharmacyIdentifier.Attributes.Add("ColumnName", "SureScriptsPharmacyIdentifier");
                    thSureScriptsPharmacyIdentifier.Attributes.Add("SortOrder", setAttributes());
                    //Code added by Loveena in ref to Task#3008
                    if (_dtPharmacies.Rows.Count > 0)
                    {
                        thSureScriptsPharmacyIdentifier.CssClass = "handStyle";
                        thSureScriptsPharmacyIdentifier.Attributes.Add("onclick", "onHeaderSearchClick(this)");
                    }
                    thSureScriptsPharmacyIdentifier.Attributes.Add("align", "left");
                    if (SortString.Split(' ')[0] == "SureScriptsPharmacyIdentifier") thc = thSureScriptsPharmacyIdentifier;
                }

                thTitle.Cells.Add(thBlank1);
                if (!IsSearchPage)
                    thTitle.Cells.Add(thBlank2);
                thTitle.Cells.Add(thID);
                thTitle.Cells.Add(thActive);
                //added By Priya
                if (IsSearchPage)
                    thTitle.Cells.Add(thPreferredPharmacy);
                thTitle.Cells.Add(thPharmacyName);
                thTitle.Cells.Add(thAddress);
                thTitle.Cells.Add(thCity);
                thTitle.Cells.Add(thState);
                thTitle.Cells.Add(thZip);
                thTitle.Cells.Add(thPhone);
                thTitle.Cells.Add(thFax);
                thTitle.Cells.Add(thSpecialty);
                //Added By PRiya
                if (IsSearchPage)
                    thTitle.Cells.Add(thSureScriptsPharmacyIdentifier);
                thTitle.CssClass = "GridViewHeaderText";

                tbPharmaciesList.Rows.Add(thTitle);

                string myscript = "<script id='Pharmacylist' type='text/javascript'>";
                if (!IsSearchPage)
                {
                    myscript += "function $deleteRecord(sender,e){";
                    if (!string.IsNullOrEmpty(_deleteRowMessage))
                    {
                        //myscript += " if (confirm ('" + _deleteRowMessage + "') == true ){" + this._onDeleteEventHandler + "(sender,e)}}";
                        myscript += this._onDeleteEventHandler + "(sender,e);  }"; 
                    }
                    else
                    {
                        myscript += "}";
                    }
                }
                DataRow dtr = null;
                myscript += "function RegisterPharmacyListControlEvents(){try{";
                if (_dtPharmacies.Rows.Count > 0)
                {
                    if (SortString.Split(' ')[1] == "Asc")
                        thc.Style.Add("background", "url(App_Themes/Includes/Images/ListPageUp.png) right no-repeat, url(App_Themes/Includes/Images/list_grid_header_bg.gif) left repeat-x");
                    else
                        thc.Style.Add("background", "url(App_Themes/Includes/Images/ListPageDown.png) right no-repeat, url(App_Themes/Includes/Images/list_grid_header_bg.gif) left repeat-x");
                   
                    Int32 rowCount = 0;
                    foreach (DataRow dr in _dtPharmacies.Rows)
                    {
                        rowCount++;
                        string pharmacyId = Convert.ToString(dr["PharmacyId"]);
                        string pharmacyName = dr["PharmacyName"].ToString();
                        string active = dr["Active"].ToString();
                        string address = string.Empty;
                        if (dr["Address"].ToString().Length > 50)
                        {
                            address = dr["Address"].ToString().Substring(0, 50) + "..";
                        }
                        else
                        {
                            address = dr["Address"].ToString();
                        }
                        string City = dr["City"].ToString();
                        string state = dr["State"].ToString();
                        string Zip = dr["ZipCode"].ToString();
                        string phone = dr["PhoneNumber"].ToString();
                        string fax = dr["FaxNumber"].ToString();
                        string specialty = dr["Specialty"].ToString();

                        string PreferredPharmacy = dr["PreferredPharmacy"].ToString();
                        string SureScriptsPharmacyIdentifier = dr["SureScriptsPharmacyIdentifier"].ToString();
                        tbPharmaciesList.Rows.Add(GenerateSubRows(dr, pharmacyId, pharmacyName, active, address, phone, fax, SureScriptsPharmacyIdentifier, PreferredPharmacy, tbPharmaciesList.ClientID, ref myscript, IsSearchPage, City, state, Zip, specialty, rowCount));
                    }
                }
                else
                    tbPharmaciesList.Rows.Add(GenerateSubRows(dtr, "", "", "", "No Records Found", "", "", "", "", tbPharmaciesList.ClientID, ref myscript, IsSearchPage,"","","","",0));

                TableRow trLine = new TableRow();
                TableCell tdHorizontalLine = new TableCell();
                tdHorizontalLine.ColumnSpan = 12;
                tdHorizontalLine.CssClass = "blackLine";
                trLine.Cells.Add(tdHorizontalLine);
                tbPharmaciesList.Rows.Add(trLine);
                tbPharmaciesList.CellPadding = 0;
                tbPharmaciesList.CellSpacing = 0;
                PanelPharmacyList.Controls.Add(tbPharmaciesList);
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
        // Changed for Ref:Task no:85
        private TableRow GenerateSubRows(DataRow dr, string PharmacyId, string PharmacyName, string Active, string Address, string Phone, string Fax, string SureScriptsIdentifier, string PreferredPharmacy, string tableId, ref string myscript, bool IsSearchPage,string City,string State,string Zip, string Specialty, Int32 rowCount)
        {
            try
            {
                CommonFunctions.Event_Trap(this);
                string newId = System.Guid.NewGuid().ToString();
                string tblId = this.ClientID + this.ClientIDSeparator + tableId;

                TableRow tblRow = new TableRow();
                tblRow.ID = "Tr_" + newId;
                TableCell tdPharmacyId = new TableCell();
                tdPharmacyId.Text = PharmacyId.ToString();

                TableCell tdActive = new TableCell();
                tdActive.Text = Active;
                //Added By Priya to add new Field for Pharmacy Search Page Date 15th Feb 2010
                TableCell tdPreferredPharmacy = new TableCell();
                TableCell tdSureScriptsIdentifier = new TableCell();
                if (IsSearchPage)
                {

                    tdPreferredPharmacy.Text = PreferredPharmacy.ToString();
                    tdSureScriptsIdentifier.Text = SureScriptsIdentifier.ToString();
                }

                TableCell tdPharmacyName = new TableCell();
                tdPharmacyName.Text = PharmacyName;

                TableCell tdAddress = new TableCell();
                tdAddress.Text = Address;

                TableCell tdCity = new TableCell();
                tdCity.Text = City;

                TableCell tdState = new TableCell();
                tdState.Text = State;

                TableCell tdZip = new TableCell();
                tdZip.Text = Zip;

                TableCell tdPhone = new TableCell();
                tdPhone.Text = Phone;

                TableCell tdFax = new TableCell();
                tdFax.Text = Fax;

                TableCell tdSpecialty = new TableCell();
                tdSpecialty.Text = Specialty;

                string Faxno = Fax;
                string pharmacynameaddress = PharmacyName + ',' + Address;
                pharmacynameaddress = pharmacynameaddress.Replace("'", "~");
                string GetActive = Active;
                TableCell tdRadioButton = new TableCell();
                string rowId = this.ClientID + this.ClientIDSeparator + tblRow.ClientID;
                
                HtmlInputRadioButton rbTemp = new HtmlInputRadioButton();
                if (dr != null)
                {
                    rbTemp.Attributes.Add("PharmacyId", dr["PharmacyId"].ToString());
                    rbTemp.ID = "Rb_" + PharmacyId.ToString();
                    //rbTemp.Checked = true;
                    if (IsSearchPage)
                        rbTemp.Checked = false;
                    tdRadioButton.Controls.Add(rbTemp);
                    if (!IsSearchPage)
                    {
                        myscript += "var Radiocontext" + PharmacyId + "={PharmacyId:" + PharmacyId + ",TableId:'" + tblId + "',RowId:'" + rowId + "'};";
                        myscript += "var RadioclickCallback" + PharmacyId + " =";
                        myscript += " Function.createCallback(" + this._onRadioClickEventHandler + ", Radiocontext" + PharmacyId + ");";
                        myscript += "$addHandler($get('" + this.ClientID + this.ClientIDSeparator + rbTemp.ClientID + "'), 'click', RadioclickCallback" + PharmacyId + ");";
                    }
                    else
                    {
                        myscript += "var Radiocontext" + PharmacyId + "={PharmacyId:" + PharmacyId + ",TableId:'" + tblId + "',RowId:'" + rowId + "',FaxNo:'" + Faxno + "',Active:'" + GetActive + "',PharmacyName:'" + pharmacynameaddress + "',ExternalReferenceId:'" + Convert.ToString(dr["ExternalReferenceId"]) + "',SureScriptsPharmacyIdentifier:'" + Convert.ToString(dr["SureScriptsPharmacyIdentifier"]) + "'};";
                        myscript += "var RadioclickCallback" + PharmacyId + " =";
                        myscript += " Function.createCallback(" + this._onRadioClickForSearchEventHandler + ", Radiocontext" + PharmacyId + ");";
                        myscript += "$addHandler($get('" + this.ClientID + this.ClientIDSeparator + rbTemp.ClientID + "'), 'click', RadioclickCallback" + PharmacyId + ");";
                    }


                }
                else
                {
                    Label lblRadio = new Label();
                    tdRadioButton.Controls.Add(lblRadio);
                }
                

                TableCell tdDelete = new TableCell();
                TableCell tdEmpty = new TableCell();
                if (dr != null)
                {
                    HtmlImage imgTemp = new HtmlImage();
                    imgTemp.ID = "Img_" + PharmacyId.ToString();


                    imgTemp.Attributes.Add("PharmacyId", dr["PharmacyId"].ToString());
                    imgTemp.Src = "~/App_Themes/Includes/Images/deleteIcon.gif";
                    imgTemp.Attributes.Add("class", "handStyle");
                    tdDelete.Controls.Add(imgTemp);
                    //Modified the condition in ref to Task#3215 Delete icon only available if SurescriptsIdentifier is null.
                    //if (!IsSearchPage && SureScriptsIdentifier == "")//Comented by Pradeep as per task#3346 on 17 march 2011
                    //{
                        myscript += "var Imagecontext" + PharmacyId + "={PharmacyId:" + PharmacyId + ",TableId:'" + tblId + "',RowId:'" + rowId + "'};";
                        myscript += "var ImageclickCallback" + PharmacyId + " =";
                        myscript += " Function.createCallback($deleteRecord, Imagecontext" + PharmacyId + ");";
                        myscript += "$addHandler($get('" + this.ClientID + this.ClientIDSeparator + imgTemp.ClientID + "'), 'click', ImageclickCallback" + PharmacyId + ");";
                    //}
                }
                tblRow.Cells.Add(tdRadioButton);
                //Modified the condition in ref to Task#3215 Delete icon only available if SurescriptsIdentifier is null.
                #region--Code comented by Pradeep as per task#3346 on 17 March 2011
                //if (!IsSearchPage && SureScriptsIdentifier == "")
                //    tblRow.Cells.Add(tdDelete);
                //else
                //    tblRow.Cells.Add(tdEmpty);
                tblRow.Cells.Add(tdDelete);
                #endregion
                tblRow.Cells.Add(tdPharmacyId);
                tblRow.Cells.Add(tdActive);
                //Added By Priya
                if (IsSearchPage)
                    tblRow.Cells.Add(tdPreferredPharmacy);

                tblRow.Cells.Add(tdPharmacyName);
                tblRow.Cells.Add(tdAddress);
                tblRow.Cells.Add(tdCity);
                tblRow.Cells.Add(tdState);
                tblRow.Cells.Add(tdZip);
                tblRow.Cells.Add(tdPhone);
                tblRow.Cells.Add(tdFax);
                tblRow.Cells.Add(tdSpecialty);
                //Added By Priya
                if (IsSearchPage)
                    tblRow.Cells.Add(tdSureScriptsIdentifier);

                if (rowCount%2 == 0)
                {
                    tblRow.CssClass = "GridViewRowStyle ListPageHLRow ListPageAltRow";
                }
                else
                {
                    tblRow.CssClass = "GridViewRowStyle ListPageHLRow";
                }
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

}

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

public partial class ClientSearch : Streamline.BaseLayer.ActivityPages.ActivityPage
{

    Streamline.UserBusinessServices.ApplicationCommonFunctions objApplicationCommonFunctions;
    //Added by Loveena in ref to Task#85
    Streamline.UserBusinessServices.ClientMedication ObjectClientMedication = null;
    private static int GridRowNumber = 0;
    private int ClientIdToReturn;
    private string ClientNameToReturn;
    public int i = 0;
    private string SortExpression = "";
    private string SortDirection = "";

    Streamline.UserBusinessServices.DataSets.ClientSearch dsclientSearch = new Streamline.UserBusinessServices.DataSets.ClientSearch();

    private string GroupIdLists = "";

    public string CalledFrom;
    public bool _IsClose = false;
    private bool _isNewClient = false;

    private bool _IsUserCreated = false;
    //These variables are created to track whether BroadSearch,SSNSearch,DOBSearch has been clicked
    bool ButtonBroadSearch = false;
    bool ButtonSSNSearch = false;

    bool ButtonDOBSearch = false;
    bool CreateNewclient = true;
    int _SearchId = 0;
    public string ExternalInteface = System.Configuration.ConfigurationSettings.AppSettings["ExternalInterface"].ToString().ToUpper();
    private bool _PermissionsToNew = false;
    private bool _PermissionsScreenSelectedClient = false;
    public enum Permissions
    {
        New = 86
    };


    protected override void Page_Load(object sender, EventArgs e)
    {

        try
        {

            #region "error message color added by rohit ref. #121"
            Streamline.BaseLayer.CommonFunctions.SetErrorMegssageBackColor(lblError);
            Streamline.BaseLayer.CommonFunctions.SetErrorMegssageForeColor(lblError);
            #endregion

            //Added by Loveena in ref to task#2378 - CopyrightInfo


            //if (Session["UserContext"] != null)
            //    LabelCopyrightInfo.Text = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).CopyrightInfo;



            //Added by Priya on 24th Aug '07 because the the cache was maintained 
            //for the dropdown and was showing data for the previous login 'providers'
            Response.Cache.SetCacheability(HttpCacheability.NoCache);

            if (Request.QueryString["Page"] != null)
            {
                ViewState["Page"] = Request.QueryString["Page"];
            }
            if (Request.QueryString["From"] != null)
            {
                ViewState["From"] = Request.QueryString["From"];
                ViewState["pid"] = Request.QueryString["pid"];
            }
            if (Request.QueryString["SelectedClientId"] != null)
            {
                HiddenFieldSelectedClientinParent.Value = Request.QueryString["SelectedClientId"];
            }

            objApplicationCommonFunctions = new Streamline.UserBusinessServices.ApplicationCommonFunctions();

            Heading1.HeadingText = "Name Search";
            Heading2.HeadingText = "Other Search Strategies";
            Heading3.HeadingText = "Records Found";
            IsNewClient = false;
            _SearchId = 0;


            this.txtPhoneSearch.Attributes.Add("onkeydown", "if(event.which || event.keyCode){if ((event.which == 13) || (event.keyCode == 13)) {document.getElementById('" + btnPhoneSearch.UniqueID + "').click();return false;}} else {return true}; ");
            this.txtSSNSearch.Attributes.Add("onkeypress", "PostDatacs('" + btnSSNSearch.ClientID + "');");

            this.TextBoxSSNFirst.Attributes.Add("onkeydown", "if(event.which || event.keyCode){if ((event.which == 13) || (event.keyCode == 13)) {document.getElementById('" + btnSSNSearch.UniqueID + "').click();return false;}} else {return true}; ");
            this.TextBoxSSNSecond.Attributes.Add("onkeydown", "if(event.which || event.keyCode){if ((event.which == 13) || (event.keyCode == 13)) {document.getElementById('" + btnSSNSearch.UniqueID + "').click();return false;}} else {return true}; ");

            this.txtDOBSearch.Attributes.Add("onkeypress", "PostDatacs('" + btnDOBSearch.ClientID + "');");
            this.txtClientId.Attributes.Add("onkeypress", "PostDatacs('" + btnClientIdSearch.ClientID + "');");
            //this.txtDOBSearch.Attributes.Add("onfocusout", "ValidateDates('" + txtDOBSearch.ClientID + "','" + lblError.ClientID + "','" + imgError.ClientID + "');");
            this.TextBoxSSNSecond.Attributes.Add("onkeypress", "OnchangestextSSNSecond('" + TextBoxSSNSecond.ClientID + "','" + txtSSNSearch.ClientID + "');");
            this.TextBoxSSNFirst.Attributes.Add("onkeypress", "OnchangestextSSNFirst('" + TextBoxSSNFirst.ClientID + "','" + TextBoxSSNSecond.ClientID + "');");
            this.txtDOBSearch.Attributes.Add("onblur", "SetDateFormat(this)");
            this.btnBroadSearch.Attributes.Add("onclick", "return ValidateFirstLastName('" + txtLastName.ClientID + "','" + txtFirstName.ClientID + "','" + lblError.ClientID + "','" + imgError.ClientID + "');");
            this.btnSSNSearch.Attributes.Add("onclick", "return ValidateSSNSearch('" + TextBoxSSNFirst.ClientID + "','" + TextBoxSSNSecond.ClientID + "','" + txtSSNSearch.ClientID + "','" + lblError.ClientID + "');");
            this.btnNarrowSearch.Attributes.Add("onclick", "return ValidateFirstLastName('" + txtLastName.ClientID + "','" + txtFirstName.ClientID + "','" + lblError.ClientID + "');");
            // this.btnClientIdSearch.Attributes.Add("onclick", "return ValidateClientId('" + txtClientId.ClientID + "','" + lblError.ClientID + "');"); 
            this.btnPhoneSearch.Attributes.Add("onclick", "return ValidatePhoneSearch('" + txtPhoneSearch.ClientID + "','" + lblError.ClientID + "');");
            this.btnDOBSearch.Attributes.Add("onclick", "return ValidateDOBSearch('" + txtDOBSearch.ClientID + "','" + lblError.ClientID + "');");
            this.btnClientIdSearch.Attributes.Add("onclick", "return ValidateClientIDSearch('" + txtClientId.ClientID + "','" + lblError.ClientID + "','" + ExternalInteface + "');");
            #region--Code Added on 9Jan
            txtClientId.Attributes.Add("onkeydown", CommonFunctions.ReturnJSForClickEvent(btnClientIdSearch.UniqueID));
            txtDOBSearch.Attributes.Add("onkeydown", CommonFunctions.ReturnJSForClickEvent(btnDOBSearch.UniqueID));
            txtPhoneSearch.Attributes.Add("onkeydown", CommonFunctions.ReturnJSForClickEvent(btnPhoneSearch.UniqueID));
            txtFirstName.Attributes.Add("onkeydown", CommonFunctions.ReturnJSForClickEvent(btnBroadSearch.UniqueID));
            txtLastName.Attributes.Add("onkeydown", CommonFunctions.ReturnJSForClickEvent(btnBroadSearch.UniqueID));
            TextBoxSSNFirst.Attributes.Add("onkeydown", CommonFunctions.ReturnJSForClickEvent(btnSSNSearch.UniqueID));
            TextBoxSSNSecond.Attributes.Add("onkeydown", CommonFunctions.ReturnJSForClickEvent(btnSSNSearch.UniqueID));
            txtSSNSearch.Attributes.Add("onkeydown", CommonFunctions.ReturnJSForClickEvent(btnSSNSearch.UniqueID));
            #endregion
            if (Page.IsPostBack == false)
            {
                try
                {
                    //commented for nor permission to create client
                    //StaffPermissions();
                    //btnCreatePotentialClient.Visible = true;
                    divimg.Attributes.Add("style", "display:none");
                    txtLastName.Focus();

                    Cache.Remove("DataViewStaff");
                    GridRowNumber = 0;
                    ViewState["SortDirection"] = "ASC";
                    //code added by Loveena in ref to Task#85
                    if (Request.QueryString["ClientFirstName"] != null && Request.QueryString["ClientFirstName"] != "undefined")
                    {
                        txtFirstName.Text = Request.QueryString["ClientFirstName"].ToString().Trim();
                    }
                    if (Request.QueryString["ClientLastName"] != null && Request.QueryString["ClientLastName"] != "undefined")
                    {
                        txtLastName.Text = Request.QueryString["ClientLastName"].ToString().Trim();
                    }
                    //code ends over here.
                    btnSelect.Enabled = false;
                    this.PlaceHolderScript.Controls.Clear();
                }
                catch (Exception ex)
                {
                    ShowHideError(true, true, ex.Message);
                }
            }
        }
        //Exception ex  added by Pratap on 29th June 2007
        catch (Exception ex)
        {
            // Added by Pratap In order to Implement Exception Management functionality on 29th June 2007
            if (ex.Data["CustomExceptionInformation"] == null)
                ex.Data["CustomExceptionInformation"] = "### Source Function Name - Page_Load(), ParameterCount - 2, First Parameter - " + sender + ", Second Parameter - " + e + " ###";

            string ParseMessage = ex.Message;
            if (ParseMessage.IndexOf("System.Data.SqlClient.SqlException:") > 0)
            {
                int SubstringLen = ParseMessage.IndexOf("\n") - ParseMessage.IndexOf("System.Data.SqlClient.SqlException:");
                ParseMessage = ParseMessage.Substring(ParseMessage.IndexOf("System.Data.SqlClient.SqlException:") + 35, SubstringLen - 35);
                ShowError(ParseMessage, true);
            }
            Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);


        }

    }



    #region Properties
    /// <summary>
    /// This property is used to return the selected clients clientId.
    /// <Author>Author: Sandeep Kumar Trivedi</Author>
    /// <CreatedDate>Date: 21-june-2007</CreatedDate>
    /// </summary>
    /// <value>The client id.</value>
    public int ClientId
    {
        get
        {
            return ClientIdToReturn;
        }
        set
        {
            ClientIdToReturn = value;
        }
    }

    /// <summary>
    /// This property is used to return the selected clients Name.
    /// <Author>Author: Sandeep Kuamr Trivedi</Author>
    /// <CreatedDate>Date: 21-june-07</CreatedDate>
    /// </summary>
    /// <value>The name of the client.</value>
    public string ClientName
    {
        get
        {
            return ClientNameToReturn;
        }
        set
        {
            ClientNameToReturn = value;
        }
    }

    /// <summary>
    /// This property is used to send the list of selected client ids list to popup so that
    /// these clients will not be displayed in search result again.
    /// </summary>
    /// <value>The group ids.</value>
    public string GroupIds
    {
        get
        {
            return GroupIdLists;
        }
        set
        {
            GroupIdLists = value;
        }
    }

    public bool IsNewClient
    {
        get
        {
            return _isNewClient;
        }
        set
        {
            _isNewClient = value;
        }
    }


    public bool IsUserCreated
    {
        get
        {
            return _IsUserCreated;
        }
        set
        {
            _IsUserCreated = value;
        }
    }

    #endregion

    /// <summary>
    /// This function validates the search criteria entered.
    /// <Author>Author: Sonia </Author>
    /// <CreatedDate>Date: 13-Dec-07</CreatedDate>
    /// </summary>
    /// <returns>Returns whether Validation is successfull or not</returns>
    public bool ValidateInputs()
    {
        try
        {

            ShowHideError(false, false, "");
            if ((txtLastName.Text.Trim() == "") && (txtFirstName.Text.Trim() == ""))
            {
                ShowHideError(true, true, "Enter the Search Criteria");
                return false;
            }
            else
                return true;
        }

        catch (Exception ex)
        {

            if (ex.Data["CustomExceptionInformation"] == null)
                ex.Data["CustomExceptionInformation"] = "###Source Function Name - ValidateInputs(), ParameterCount - 0###";
            //Added by Priya on 24th Aug '07
            string ParseMessage = ex.Message;
            if (ParseMessage.IndexOf("System.Data.SqlClient.SqlException:") > 0)
            {
                int SubstringLen = ParseMessage.IndexOf("\n") - ParseMessage.IndexOf("System.Data.SqlClient.SqlException:");
                ParseMessage = ParseMessage.Substring(ParseMessage.IndexOf("System.Data.SqlClient.SqlException:") + 35, SubstringLen - 35);
                ShowError(ParseMessage, true);
            }
            else
                ex.Data["CustomExceptionInformation"] = "";
            if (ex.Data["DatasetInfo"] == null)
                ex.Data["DatasetInfo"] = null;
            Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);

            return false;
        }
    }

    /// <summary>
    ///Handles the Click event of btnClear.
    ///On click of this button clears the search criteria.
    /// <Author>Author: Sandeep Kumar Trivedi</Author>
    /// <CreatedDate>Date: 20-june-07</CreatedDate>
    /// </summary>
    /// <param name="sender">The source of the event.</param>
    /// <param name="e">The <see cref="System.EventArgs"/> instance containing the event data.</param>
    protected void btnClear_Click(object sender, EventArgs e)
    {
        try
        {
            txtFirstName.Text = "";
            txtLastName.Text = "";
            txtSSNSearch.Text = "";
            txtPhoneSearch.Text = "";
            txtClientId.Text = "";
            txtDOBSearch.Text = "";

            TextBoxSSNFirst.Text = "";
            TextBoxSSNSecond.Text = "";

            dgStaff.DataSource = null;
            //dgStaff.DataBindings.Clear();
            dgStaff.DataBind();

            ButtonBroadSearch = false;
            ButtonDOBSearch = false;
            ButtonSSNSearch = false;
            //  btnScreenClient.Enabled = false;
            // btnScreenClient.Font.Italic = true;
            btnSelect.Enabled = false;
            ShowHideError(false, false, " ");

            Page.Form.DefaultButton = this.btnBroadSearch.UniqueID;
            //Calling EnableScreenNewClientButton function that will enable or disable ButtonScreenNewClient
            // this.EnableScreenNewClientButton();
        }
        //Exception ex added by Pratap on 29th June 2007
        catch (Exception ex)
        {
            // Added by Pratap In order to Implement Exception Management functionality on 29th June 2007
            if (ex.Data["CustomExceptionInformation"] == null)
                ex.Data["CustomExceptionInformation"] = "###Source Function Name - Page_Load(), ParameterCount - 2, First Parameter - " + sender + ", Second Parameter - " + e + "###";
            else
                ex.Data["CustomExceptionInformation"] = "";
            if (ex.Data["DatasetInfo"] == null)
                ex.Data["DatasetInfo"] = null;

            string ParseMessage = ex.Message;
            if (ParseMessage.IndexOf("System.Data.SqlClient.SqlException:") > 0)
            {
                int SubstringLen = ParseMessage.IndexOf("\n") - ParseMessage.IndexOf("System.Data.SqlClient.SqlException:");
                ParseMessage = ParseMessage.Substring(ParseMessage.IndexOf("System.Data.SqlClient.SqlException:") + 35, SubstringLen - 35);
                ShowError(ParseMessage, true);
            }

            Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);


        }
    }


    /// <summary>
    /// Handles the Click event of the btnBroadSearch control.
    /// On click of this button searches the client with 1st character of firstname and first 3 character
    /// of last name as search criteria.
    /// <Author>Author: Sandeep Kumar Trivedi</Author>
    /// <CreatedDate>Date: 20-june-07</CreatedDate>
    /// </summary>
    /// <param name="sender">The source of the event.</param>
    /// <param name="e">The <see cref="System.EventArgs"/> instance containing the event data.</param>
    protected void btnBroadSearch_Click(object sender, EventArgs e)
    {
        try
        {


            ShowHideError(false, false, "");


            GetClientData("BROAD", txtLastName.Text.Trim(), txtFirstName.Text.Trim(), 0);
            ViewState["SearchType"] = "BROAD";
            ViewState["param1"] = txtLastName.Text.Trim();
            ViewState["param2"] = txtFirstName.Text.Trim();
            if (dsclientSearch.Tables[2].DefaultView.Count == 0)
            {
                ShowHideError(true, true, "No Records Found");
                btnSelect.Enabled = false;
                //this.AcceptButton = btnCreatePotentialClient;
                //  Page.Form.DefaultButton = this.btnScreenClient.UniqueID;
            }
            else
            {
                // RadioClicked(0, 0);
                if (dgStaff.Rows[0].Cells[1].Text != "&nbsp;")
                    this.ClientId = Convert.ToInt32(dgStaff.Rows[0].Cells[1].Text);
                this.ClientName = dgStaff.Rows[0].Cells[3].Text + ", " + dgStaff.Rows[0].Cells[2].Text;
                ViewState["ClientName"] = this.ClientName;
                //  this.AcceptButton = btnSelect;
                //  Page.Form.DefaultButton = this.btnSelect.UniqueID;
                btnSelect.Enabled = true;
                btnSelect.Focus();
            }
            if (_PermissionsToNew == true)
            {
                // btnScreenClient.Enabled = true;
                // btnScreenClient.Font.Italic = false;
            }
            else
            {
                // btnScreenClient.Font.Italic = false;
            }
            ButtonBroadSearch = true;
            EnablePotentialNewClient();
            // }

            this.EnableScreenButton();
        }
        //Exception ex added by Pratap on 29th June 2007
        catch (Exception ex)
        {

            if (ex.Data["CustomExceptionInformation"] == null)
                ex.Data["CustomExceptionInformation"] = "###Source Function Name - btnBroadSearch_Click(), ParameterCount - 2, First Parameter- " + sender + ", Second Parameter- " + e + "###";
            else
                ex.Data["CustomExceptionInformation"] = "";
            if (ex.Data["DatasetInfo"] == null)
                ex.Data["DatasetInfo"] = null;

            string ParseMessage = ex.Message;
            if (ParseMessage.IndexOf("System.Data.SqlClient.SqlException:") > 0)
            {
                int SubstringLen = ParseMessage.IndexOf("\n") - ParseMessage.IndexOf("System.Data.SqlClient.SqlException:");
                ParseMessage = ParseMessage.Substring(ParseMessage.IndexOf("System.Data.SqlClient.SqlException:") + 35, SubstringLen - 35);
                ShowError(ParseMessage, true);
            }


            Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);

        }
        finally
        {

        }
    }

    private void EnablePotentialNewClient()
    {
        try
        {
            if (ButtonBroadSearch == true && ButtonSSNSearch == true && ButtonDOBSearch == true)
            {
                if (_PermissionsToNew == true)
                {
                    //  btnScreenClient.Enabled = true;
                    // btnScreenClient.Font.Italic = false; 
                }
            }
            else
            {
                //  btnScreenClient.Enabled = false;
                // btnScreenClient.Font.Italic = true;
            }
        }
        catch (Exception ex)
        {

            if (ex.Data["CustomExceptionInformation"] == null)
                ex.Data["CustomExceptionInformation"] = "###Source Function Name - btnBroadSearch_Click(), ParameterCount - 0###";

            string ParseMessage = ex.Message;
            if (ParseMessage.IndexOf("System.Data.SqlClient.SqlException:") > 0)
            {
                int SubstringLen = ParseMessage.IndexOf("\n") - ParseMessage.IndexOf("System.Data.SqlClient.SqlException:");
                ParseMessage = ParseMessage.Substring(ParseMessage.IndexOf("System.Data.SqlClient.SqlException:") + 35, SubstringLen - 35);
                ShowError(ParseMessage, true);
            }
            Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);



        }
    }


    /// <summary>
    /// Retrieves the client data. and put it in a Typed Dataset.
    /// <Author>Author: Sandeep Kumar Trivedi</Author>
    /// <CreatedDate>Date: 20-june-07</CreatedDate>
    /// </summary>
    private void GetClientData(string SearchType, string param1, string param2, int ProviderId)
    {
        DataSet dsClientData = null;

        try
        {
            //Added by chandan for update/Insert the External Client information in streamline database
            if (System.Configuration.ConfigurationSettings.AppSettings["ExternalInterface"].ToString().ToUpper() == "TRUE")
            {
                dsClientData = objApplicationCommonFunctions.GetExternalClientSearchInfo(((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId, SearchType, param1, param2, ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode, 0);
            }
            else
                dsClientData = objApplicationCommonFunctions.GetClientSearchInfo(((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId, SearchType, param1, param2, ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode, 0);

            try
            {
                //if (dsClientData.Tables.Count > 3)
                if (dsClientData.Tables.Count > 1)
                {
                    //if (dsClientData.Tables[3].Rows.Count > 0)
                    if (dsClientData.Tables[1].Rows.Count > 0)
                        _SearchId = Convert.ToInt32(dsClientData.Tables[1].Rows[0]["SearchID"].ToString());
                }
                else
                {
                    _SearchId = 0;
                }
                ViewState["SearchId"] = _SearchId;
            }
            catch (Exception ex)
            {
                string strError = ex.Message;
            }

            MergeIntoTypedDataSet(dsClientData);
        }
        //Exception ex added by Pratap on 29th June 2007
        catch (Exception ex)
        {
            if (ex.Data["CustomExceptionInformation"] == null)
                ex.Data["CustomExceptionInformation"] = "### Source Function Name - GetClientData(), ParameterCount - 3, First Parameter - " + SearchType + ", Second Parameter - " + param1 + ", Third Parameter - " + param2 + ", Fourth Parameter -" + ProviderId + "###";
            //Added by Priya on 24th Aug '07
            string ParseMessage = ex.Message;
            if (ParseMessage.IndexOf("System.Data.SqlClient.SqlException:") > 0)
            {
                int SubstringLen = ParseMessage.IndexOf("\n") - ParseMessage.IndexOf("System.Data.SqlClient.SqlException:");
                ParseMessage = ParseMessage.Substring(ParseMessage.IndexOf("System.Data.SqlClient.SqlException:") + 35, SubstringLen - 35);
                ShowError(ParseMessage, true);
            }

            Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);
            throw (ex);


        }

    }


    /// <summary>
    /// Merge Dataset into TypeddataSet.
    /// <Author>Author: Sonia</Author>
    /// <CreatedDate>Date: 13-Dec-07</CreatedDate>
    /// </summary>
    private void MergeIntoTypedDataSet(DataSet dsClientData)
    {
        try
        {
            dsClientData.Tables[0].TableName = "ClientData";
            if (dsClientData.Tables.Count > 1)
            {
                dsClientData.Tables[1].TableName = "SearchId";
            }
            //if (dsClientData.Tables[0].Rows.Count % 10 > 0)
            //{
            //    int rowsNeeded = 10 - (dsClientData.Tables[0].Rows.Count % 10);
            //    for (int i = 0; i < rowsNeeded; i++)
            //    {
            //        DataRow dr = dsClientData.Tables["ClientData"].NewRow();
            //        dr["ClientiD"] = -1;
            //        dr["CareManagementId"] = -1;
            //        dr["Relationship"] = "";
            //        dr["LastName"] = "";
            //        dr["FirstName"] = "";
            //        dr["DOB"]  = DateTime.Now;
            //        dr["SSN"]  = "";
            //        dr["SSNToolTip"] = ""; 
            //        dr["FormattedFullSSN"] = ""; 
            //        dr["ClientName"]  = "";
            //        dr["Status"]  = "";
            //        dr["City"]  = "";
            //        dr["ClientAlias"] = "";
            //        dr["PrimaryClinician"] = "";
            //        dsClientData.Tables[0].Rows.Add(dr);
            //    }
            //}
            dsclientSearch.Clear();
            dsclientSearch.EnforceConstraints = false;
            dsclientSearch.Merge(dsClientData);
            dsclientSearch.Tables["ClientData"].Columns["ClientId"].ReadOnly = false;
            DataView DataViewStaff = dsclientSearch.Tables["ClientData"].DefaultView;
            DataViewStaff.Sort = "LastName,FirstName";
            dgStaff.DataSource = DataViewStaff;
            dgStaff.PageIndex = 0;
            dgStaff.DataBind();
            if (dgStaff.Rows.Count > 1)
            {
                foreach (TableCell cell in dgStaff.HeaderRow.Cells)
                {
                    if (cell.HasControls())
                    {
                        LinkButton lnkbtn = (LinkButton)cell.Controls[0];
                        if (lnkbtn.Text == "Last Name")
                            lnkbtn.CssClass = "SortUp";
                    }
                }
            }
            Cache.Insert("DataViewStaff", DataViewStaff, null, DateTime.Now.AddMinutes(30), TimeSpan.Zero);


        }
        catch (Exception ex)
        {
            // Added by Sandeep Kumar Trivedi In order to Implement Exception Management functionality on 29th June 2007
            if (ex.Data["CustomExceptionInformation"] == null)
                ex.Data["CustomExceptionInformation"] = "### Source Function Name - MergeIntoTypedDataSet(), ParameterCount - 1, dsClientData - " + dsClientData + "###";

            string ParseMessage = ex.Message;
            if (ParseMessage.IndexOf("System.Data.SqlClient.SqlException:") > 0)
            {
                int SubstringLen = ParseMessage.IndexOf("\n") - ParseMessage.IndexOf("System.Data.SqlClient.SqlException:");
                ParseMessage = ParseMessage.Substring(ParseMessage.IndexOf("System.Data.SqlClient.SqlException:") + 35, SubstringLen - 35);
                ShowError(ParseMessage, true);
            }


            Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);


        }
    }

    /// <summary>
    /// open Client Summary Page
    /// </summary>
    /// <Author>Sandeep Kumar Trivedi</Author>
    /// <CreatedOn>28-06-2007</CreatedOn>
    private void GenerateScript()
    {
        string _PopupScript = "";
        try
        {
            _PopupScript = "<script type='text/javascript'>" +
                   "window.opener.OpenPage('ClientSummary')</script>";
            this.PlaceHolderScript.Controls.Add(new LiteralControl(_PopupScript));
        }
        catch (Exception ex)
        {
            // Added by Pratap In order to Implement Exception Management functionality on 29th June 2007
            if (ex.Data["CustomExceptionInformation"] == null)
                ex.Data["CustomExceptionInformation"] = "### Source Function Name - GenerateScript(), ParameterCount - 0###";
            string ParseMessage = ex.Message;
            if (ParseMessage.IndexOf("System.Data.SqlClient.SqlException:") > 0)
            {
                int SubstringLen = ParseMessage.IndexOf("\n") - ParseMessage.IndexOf("System.Data.SqlClient.SqlException:");
                ParseMessage = ParseMessage.Substring(ParseMessage.IndexOf("System.Data.SqlClient.SqlException:") + 35, SubstringLen - 35);
                ShowError(ParseMessage, true);
            }

            Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);





        }
        finally
        {
            _PopupScript = "";
        }
    }



    /// <summary>
    /// Shows the error.
    /// <Author>Author: Sandeep Kumar Trivedi</Author>
    /// <CreatedDate>Date: 20-june-07</CreatedDate>
    /// </summary>
    /// <param name="showImg">if set to <c>true</c> [show img].</param>
    /// <param name="showMsg">if set to <c>true</c> [show MSG].</param>
    /// <param name="msg">The MSG.</param>
    private void ShowHideError(bool showImg, bool showMsg, string msg)
    {
        try
        {
            if (showImg == true)
            {
                divimg.Attributes.Add("style", "display:block");
            }
            else
            {
                divimg.Attributes.Add("style", "display:none");
            }
            if (showMsg == true)
            {
                lblError.Visible = true;
            }
            else
            {
            }
            lblError.Text = msg;
        }
        catch (Exception ex)
        {
            // Added by Pratap In order to Implement Exception Management functionality on 29th June 2007
            if (ex.Data["CustomExceptionInformation"] == null)
                ex.Data["CustomExceptionInformation"] = "### Source Function Name - ShowHideError(), ParameterCount - 3, First Parameter - " + showImg + ", Second Parameter - " + showMsg + ", Third Parameter - " + msg + "###";
            //Added by Priya on 24th Aug '07
            string ParseMessage = ex.Message;
            if (ParseMessage.IndexOf("System.Data.SqlClient.SqlException:") > 0)
            {
                int SubstringLen = ParseMessage.IndexOf("\n") - ParseMessage.IndexOf("System.Data.SqlClient.SqlException:");
                ParseMessage = ParseMessage.Substring(ParseMessage.IndexOf("System.Data.SqlClient.SqlException:") + 35, SubstringLen - 35);
                ShowError(ParseMessage, true);
            }
            Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);




        }

    }

    /// <summary>
    /// Handles the Click event of the btnSelect control.
    /// On click of this button sets the client id and name of client and closes the form.
    /// <Author>Author: Sandeep Kumar Trivedi</Author>
    /// <CreatedDate>Date: 22-June-07</CreatedDate>
    /// </summary>
    /// <param name="sender">The source of the event.</param>
    /// <param name="e">The <see cref="System.EventArgs"/> instance containing the event data.</param>
    protected void btnSelect_Click(object sender, EventArgs e)
    {
        DataSet dsExternalClientInfo = new DataSet();
        string ExternalClientId = "";
        string UserCode = "";
        int ReturnClientId;
        DataSet dsClient = new DataSet();


        try
        {
            string[] a;
            string selectedValue = Request.Form["RadioButtonselectclientid"];
            a = selectedValue.Split(':');
            Session["ExternalClientInformation"] = null;
            UserCode = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
            //Added by chandan for update/Insert the External Client information in streamline database
            if (System.Configuration.ConfigurationSettings.AppSettings["ExternalInterface"].ToString().ToUpper() == "TRUE")
            {
                this.ClientName = a[1].ToString();
                ExternalClientId = a[4].ToString();
                if (ExternalClientId != "")
                {
                    dsExternalClientInfo = objApplicationCommonFunctions.GetExternalClientInfo(ExternalClientId);
                    Session["ExternalClientInformation"] = dsExternalClientInfo;
                    if (dsExternalClientInfo != null)
                    {
                        if (dsExternalClientInfo.Tables.Count > 0)
                        {
                            dsClient = objApplicationCommonFunctions.UpdateExternalInformation(dsExternalClientInfo, UserCode);
                            //Calling External Web service to update the ClientViewAudit table with External ClientID and SearchID
                            if (ViewState["SearchId"] != null)
                                objApplicationCommonFunctions.UpdateClientExternalViewAudit(Convert.ToInt32(ViewState["SearchId"]), ExternalClientId, UserCode, DateTime.Now);
                            //set the return ClientId as a current client Id
                            if (dsClient != null)
                                this.ClientId = Convert.ToInt32(dsClient.Tables[0].Rows[0][0].ToString());
                        }
                    }
                }
            }
            else
            {
                this.ClientId = Convert.ToInt32(a[0].ToString());
                this.ClientName = a[1].ToString();
                ExternalClientId = a[4].ToString();
                // Calling Internal Update Method for Client Id when "ExternalInterface" value = false;
                if (ViewState["SearchId"] != null)
                    objApplicationCommonFunctions.UpdateInternalClientViewAudit(Convert.ToInt32(ViewState["SearchId"]), this.ClientId, UserCode, DateTime.Now);
            }


            // End by Chandan

            // Coded commneted by Piyush on 2nd Nov in order to to set the clientId in Common Property withoud effecting the Client Tab if the Client Serch window is opened from Some user control other then toolbar
            //Streamline.ProviderAccessBaseLibrary.BaseCommonFunctions.Singleton.Instance.ClientId = this.ClientId;
            if (a[2] != "")
            {
                if (ViewState["From"] == null)
                {
                    //ScriptManager.RegisterClientScriptBlock(lblError, lblError.GetType(), "SetCurrentProviderName", "parent.document.getElementById('LabelProviderName').innerText ='Provider: " + Streamline.ProviderAccess.CommonFunctions.CurrentProviderName + "';", true);
                }
            }
            ShowHideError(false, false, "");
            if (this.ClientName == null)
            {
                ShowHideError(true, true, "Please select Client");
            }
            else
            {
                //GenerateScript();
                if (ViewState["From"] == null)
                {
                    try
                    {
                        // Coded added by Piyush on 2nd Nov in order to to set the clientId in Common Property withoud effecting the Client Tab if the Client Serch window is opened from Some user control other then toolbar


                        ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).RefreshData = true;
                        ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).SetClientInformation(this.ClientId, true);



                    }
                    catch (Exception ex)
                    {
                        string strError = ex.Message;
                    }
                    _IsUserCreated = true;

                    //Code added by Loveena in ref to task#85 to update SureScriptsRefillRequests table with selected client
                    if (Request.QueryString["ClientFirstName"] != null && Request.QueryString["ClientFirstName"] != "undefined" && Session["DataSetSureScriptRequestRefill"] != null)
                    {
                        int SureScriptsRefillRequestId = Convert.ToInt32(Request.QueryString["SureScriptsRefillRequestId"].ToString());
                        DataSet dataSetSureScriptRefillRequest = (DataSet)Session["DataSetSureScriptRequestRefill"];
                        DataRow[] datarowSureScriptRefillRequest = dataSetSureScriptRefillRequest.Tables[0].Select("SureScriptsRefillRequestId=" + Request.QueryString["SureScriptsRefillRequestId"]);
                        //Code Added By priya Reg:Task No:3292 2.8 Refill Request DashBoard:-Error while selecting Client
                        if (System.Configuration.ConfigurationSettings.AppSettings["ExternalInterface"].ToString().ToUpper() == "TRUE")
                        {
                            datarowSureScriptRefillRequest[0]["ClientId"] = Convert.ToInt32(dsClient.Tables[0].Rows[0][0].ToString());
                            //Added by Loveena in ref to Task#3224-the user changes the selected client, clear the ClientMedicationScriptStrengthId
                            if (HiddenFieldSelectedClientinParent.Value != dsClient.Tables[0].Rows[0][0].ToString())
                            {
                                datarowSureScriptRefillRequest[0]["ClientMedicationScriptDrugStrengthId"] = System.DBNull.Value;
                                HiddenFieldChangedclientId.Value = "true";
                            }
                        }
                        else
                        {
                            datarowSureScriptRefillRequest[0]["ClientId"] = Convert.ToInt32(a[0]);
                            //Added by Loveena in ref to Task#3224-the user changes the selected client, clear the ClientMedicationScriptStrengthId
                            if (HiddenFieldSelectedClientinParent.Value != a[0].ToString())
                            {
                                datarowSureScriptRefillRequest[0]["ClientMedicationScriptDrugStrengthId"] = System.DBNull.Value;
                                HiddenFieldChangedclientId.Value = "true";
                            }
                        }
                        //end
                        string[] PatientName = a[1].ToString().Split(',');
                        //Commented and added above By priya Reg:Task No:3292 2.8 Refill Request DashBoard:-Error while selecting Client

                        //Added by Loveena in ref to Task#3224-the user changes the selected client, clear the ClientMedicationScriptStrengthId
                        //if (HiddenFieldSelectedClientinParent.Value != a[0].ToString())
                        //{
                        //    datarowSureScriptRefillRequest[0]["ClientMedicationScriptDrugStrengthId"] = System.DBNull.Value;
                        //    HiddenFieldChangedclientId.Value = "true";
                        //}
                        ObjectClientMedication = new ClientMedication();
                        DataSet dsUpdated = new DataSet();
                        dsUpdated = ObjectClientMedication.UpdateDocuments(dataSetSureScriptRefillRequest);
                        Streamline.UserBusinessServices.SureScriptRefillRequest objSureScriptRefillRequest = null;
                        using (DataSet dsSureScripts = new DataSet())
                        {
                            objSureScriptRefillRequest = new SureScriptRefillRequest();
                            dsSureScripts.Merge(objSureScriptRefillRequest.GetSureScriptRefill(((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId, Convert.ToInt32(Request.QueryString["prescriberId"])));
                            //dsSureScripts.Merge(dsUpdated.Tables["SureScriptsRefillRequests"]);
                            Session["DataSetSureScriptRequestRefill"] = dsSureScripts;
                        }
                        Session["LoadMgt"] = true;
                        Session["ClientIdForValidateToken"] = this.ClientId;
                        int selectedClient = 0;
                        if (System.Configuration.ConfigurationSettings.AppSettings["ExternalInterface"].ToString().ToUpper() == "TRUE")
                        {
                            selectedClient = Convert.ToInt32(dsClient.Tables[0].Rows[0][0].ToString());
                        }
                        else
                        {
                            selectedClient = Convert.ToInt32(a[0]);
                        }

                        Session["CurrentControl"] = "~/UserControls/ClientList.ascx";
                        Session["InitializeClient"] = true;
                        //ScriptManager.RegisterStartupScript(lblError, lblError.GetType(), ClientID.ToString(), "SelectClient();", true);
                        ScriptManager.RegisterStartupScript(lblError, lblError.GetType(), ClientID.ToString(), "SelectClient(" + selectedClient + "," + SureScriptsRefillRequestId + ");", true);

                    }
                    else
                    {
                        Session["LoadMgt"] = true;
                        Session["ClientIdForValidateToken"] = this.ClientId;

                        Session["CurrentControl"] = "~/UserControls/MedicationMgt.ascx";
                        Session["InitializeClient"] = true;
                        ScriptManager.RegisterStartupScript(lblError, lblError.GetType(), ClientID.ToString(), "closeDivSelectClient(" + this.ClientId + ");", true);
                        //Response.Redirect("ValidateToken.aspx?ClientId=" + this.ClientId + " &StaffId=" + ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId);
                        //LoadControls("~/UserControls/MedicationMgt.ascx", true);
                    }
                }
                else
                {
                    //if (ViewState["From"].ToString() == "ClaimEntry")
                    //{
                    //    string[] Names = this.ClientName.Split(',');
                    //    objApplicationCommonFunctions = new Clients();
                    //    DataSet dsClient = objApplicationCommonFunctions.GetClientInformation(this.ClientId);
                    //    string DOB = "";
                    //    string SSN = "";
                    //    string Address = "";
                    //    string State = "";
                    //    string City = "";
                    //    string Zip = "";
                    //    if (dsClient.Tables["Clients"].Rows.Count > 0)
                    //    {
                    //        DOB = dsClient.Tables["Clients"].Rows[0]["DOB"].ToString();
                    //        SSN = dsClient.Tables["Clients"].Rows[0]["SSN"].ToString();
                    //    }
                    //    if (dsClient.Tables["ClientAddresses"].Rows.Count > 0)
                    //    {
                    //        Address = "";// dsClient.Tables["ClientAddresses"].Rows[0]["Address"].ToString();
                    //        State = "";// dsClient.Tables["ClientAddresses"].Rows[0]["State"].ToString();
                    //        City = "";// dsClient.Tables["ClientAddresses"].Rows[0]["City"].ToString();
                    //        Zip = "";// dsClient.Tables["ClientAddresses"].Rows[0]["Zip"].ToString();
                    //    }
                    //    string RetVal = this.ClientId + "@" + Names[1] + "@" + Names[0] + "@" + SSN + "@" + DOB + "@" + Address + "@" + Zip + "@" + State + "@" + City;
                    //    ScriptManager.RegisterClientScriptBlock(lblError, typeof(Button), "key", "javascript:window.returnValue = '" + RetVal + "';window.close();", true);
                    //}
                    //if (ViewState["From"].ToString() == "Alerts")
                    //{
                    //    ScriptManager.RegisterClientScriptBlock(lblError, typeof(Button), "key", "javascript:window.returnValue = '" + this.ClientId + "@" + this.ClientName + "';window.close();", true);
                    //}
                    //if (ViewState["From"].ToString() == "Message")
                    //{
                    //    ScriptManager.RegisterClientScriptBlock(lblError, typeof(Button), "key", "javascript:window.returnValue = '" + this.ClientId + "@" + this.ClientName + "';window.close();", true);
                    //}
                }
            }

        }

        //Exception ex added by Pratap on 29th June 2007
        catch (Exception ex)
        {
            // Added by Pratap In order to Implement Exception Management functionality on 29th June 2007
            if (ex.Data["CustomExceptionInformation"] == null)
                ex.Data["CustomExceptionInformation"] = "### Source Function Name - btnSelect_Click(), ParameterCount - 2, First Parameter - " + sender + ", Second Parameter - " + e + " ###";

            string ParseMessage = ex.Message;
            if (ParseMessage.IndexOf("System.Data.SqlClient.SqlException:") > 0)
            {
                int SubstringLen = ParseMessage.IndexOf("\n") - ParseMessage.IndexOf("System.Data.SqlClient.SqlException:");
                ParseMessage = ParseMessage.Substring(ParseMessage.IndexOf("System.Data.SqlClient.SqlException:") + 35, SubstringLen - 35);
                ShowError(ParseMessage, true);
            }

            Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);


        }
    }


    public string formatLastName(object lastName)
    {
        string LastName;
        return LastName = ((string)lastName).Replace("'", "");
    }
    public string formatFirstName(object firstName)
    {
        string FirstName;
        return FirstName = ((string)firstName).Replace("'", "");
    }

    /// <summary>
    /// Handles the Click event of the btnNarrowSearch control.
    /// On click of this button searches the client with soundex of first name and last name as search criteria.
    /// <Author>Author: Sandeep Kumar Trivedi</Author>
    /// <CreatedDate>Date: 25-June-07</CreatedDate>
    /// </summary>
    /// <param name="sender">The source of the event.</param>
    /// <param name="e">The <see cref="System.EventArgs"/> instance containing the event data.</param>

    protected void btnNarrowSearch_Click(object sender, EventArgs e)
    {
        try
        {

            ShowHideError(false, false, "");
            //if (txtLastName.Text.Trim() == "" && txtFirstName.Text.Trim() == "")
            //{
            //    //				MessageBox.Show("Please enter the Search criteria");
            //    ShowHideError(true, true, "Please Enter Search Criteria");
            //}
            //else
            //{

            GetClientData("NARROW", txtLastName.Text.Trim(), txtFirstName.Text.Trim(), 0);
            ViewState["SearchType"] = "NARROW";
            ViewState["param1"] = txtLastName.Text.Trim();
            ViewState["param2"] = txtFirstName.Text.Trim();
            if (dsclientSearch.Tables[2].DefaultView.Count == 0)
            {
                ShowHideError(true, true, "No Records Found");
                txtLastName.Focus();
                btnSelect.Enabled = false;
                Page.Form.DefaultButton = this.btnBroadSearch.UniqueID;
            }
            else
            {
                if (dgStaff.Rows[0].Cells[1].Text != "&nbsp;")
                    this.ClientId = Convert.ToInt32(dgStaff.Rows[0].Cells[1].Text);
                this.ClientName = dgStaff.Rows[0].Cells[3].Text + ", " + dgStaff.Rows[0].Cells[2].Text;

                btnSelect.Enabled = true;
                btnSelect.Focus();
            }
            this.EnableScreenButton();
            // }
        }
        //Exception ex added by Pratap on 29th June 2007
        catch (Exception ex)
        {
            // Added by Pratap In order to Implement Exception Management functionality on 29th June 2007
            if (ex.Data["CustomExceptionInformation"] == null)
                //Modified by Priya:- sender and e parameters are not required, on 24th August 2007
                ex.Data["CustomExceptionInformation"] = "### Source Function Name - btnNarrowSearch_Click(), ParameterCount - 2, First Parameter - " + sender + ", Second Parameter - " + e + " ###";
            string ParseMessage = ex.Message;
            if (ParseMessage.IndexOf("System.Data.SqlClient.SqlException:") > 0)
            {
                int SubstringLen = ParseMessage.IndexOf("\n") - ParseMessage.IndexOf("System.Data.SqlClient.SqlException:");
                ParseMessage = ParseMessage.Substring(ParseMessage.IndexOf("System.Data.SqlClient.SqlException:") + 35, SubstringLen - 35);
                ShowError(ParseMessage, true);
            }


            Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);


        }
        finally
        {

        }

    }


    /// <summary>
    /// Handles the Click event of the btnSSNSearch control.
    /// On click of this searches the clients with SSN Number as search criteria. .
    /// <Author>Author: Sandeep Kumar Trivedi</Author>
    /// <CreatedDate>Date: 25-june-07</CreatedDate>
    /// </summary>
    /// <param name="sender">The source of the event.</param>
    /// <param name="e">The <see cref="System.EventArgs"/> instance containing the event data.</param>
    protected void btnSSNSearch_Click(object sender, EventArgs e)
    {
        try
        {

            ShowHideError(false, false, "");
            # region "Commented Code"
            //if (TextBoxSSNFirst.Text.Trim().Length > 0)
            //{
            //    if (TextBoxSSNFirst.Text.Trim().Length != 3)
            //    {
            //        ShowHideError(true, true, "Please Enter Valid SSN Number");
            //        TextBoxSSNFirst.Focus();
            //        return;
            //    }
            //}
            //if (TextBoxSSNSecond.Text.Trim().Length > 0)
            //{
            //    if (TextBoxSSNSecond.Text.Trim().Length != 2)
            //    {
            //        ShowHideError(true, true, "Please Enter Valid SSN Number");
            //        TextBoxSSNSecond.Focus();
            //        return;
            //    }
            //}

            //if (txtSSNSearch.Text.Trim().Length != 4)
            //{
            //    ShowHideError(true, true, "Please Enter Valid SSN Number");
            //    txtSSNSearch.Focus();
            //    return;
            //}

            # endregion
            GetClientData("SSN", txtSSNSearch.Text.Trim(), "", 0);
            ViewState["SearchType"] = "SSN";
            ViewState["param1"] = txtSSNSearch.Text.Trim();
            ViewState["param2"] = "";

            if (dsclientSearch.Tables[2].DefaultView.Count == 0)
            {
                ShowHideError(true, true, "No Records Found");
                txtSSNSearch.Focus();
                btnSelect.Enabled = false;
            }
            else
            {
                // RadioClicked(0, 0);  dgStaff.Rows[0].Cells[3].Text
                if (dgStaff.Rows[0].Cells[1].Text != "&nbsp;")
                    this.ClientId = Convert.ToInt32(dgStaff.Rows[0].Cells[1].Text);
                this.ClientName = dgStaff.Rows[0].Cells[3].Text + ", " + dgStaff.Rows[0].Cells[2].Text;
                btnSelect.Enabled = true;
                btnSelect.Focus();
            }
            ButtonSSNSearch = true;
            EnablePotentialNewClient();
            this.EnableScreenButton();
        }
        //Exception ex added by Pratap on 29th June 2007
        catch (Exception ex)
        {
            // Added by Pratap In order to Implement Exception Management functionality on 29th June 2007
            if (ex.Data["CustomExceptionInformation"] == null)
                //Modified by Priya:- sender and e parameters are not required, on 24th August 2007
                ex.Data["CustomExceptionInformation"] = "### Source Function Name - btnSSNSearch_Click(), ParameterCount - 2, First Parameter - " + sender + ", Second Parameter - " + e + " ###";
            string ParseMessage = ex.Message;
            if (ParseMessage.IndexOf("System.Data.SqlClient.SqlException:") > 0)
            {
                int SubstringLen = ParseMessage.IndexOf("\n") - ParseMessage.IndexOf("System.Data.SqlClient.SqlException:");
                ParseMessage = ParseMessage.Substring(ParseMessage.IndexOf("System.Data.SqlClient.SqlException:") + 35, SubstringLen - 35);
                ShowError(ParseMessage, true);
            }

            Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);


        }
        finally
        {

        }

    }

    /// <summary>
    /// Function for extracting numeric chars from a string. 
    /// </summary>
    /// <param name="alphaNumericText"></param> 
    /// <returns>string</returns>
    public static string StripNumeric(string alphaNumericText)
    {
        try
        {

            System.Text.StringBuilder sb = new System.Text.StringBuilder();
            if (alphaNumericText != string.Empty || alphaNumericText != null)
            {
                foreach (char txt in alphaNumericText)
                {
                    if (char.IsDigit(txt))
                        sb.Append(txt);
                }
                return sb.ToString();
            }
            else
                return string.Empty;
        }

        //Exception ex added by Sandeep Trivedi on 29th June 2007
        catch (Exception ex)
        {
            // Added by Sandeep Trivedi In order to Implement Exception Management functionality on 29th June 2007
            if (ex.Data["CustomExceptionInformation"] == null)
                ex.Data["CustomExceptionInformation"] = "### Source Function Name - StripNumeric(), ParameterCount - 1, First Parameter - " + alphaNumericText + "###";
            //Added by Priya on 24th Aug '07
            string ParseMessage = ex.Message;
            if (ParseMessage.IndexOf("System.Data.SqlClient.SqlException:") > 0)
            {
                int SubstringLen = ParseMessage.IndexOf("\n") - ParseMessage.IndexOf("System.Data.SqlClient.SqlException:");
                ParseMessage = ParseMessage.Substring(ParseMessage.IndexOf("System.Data.SqlClient.SqlException:") + 35, SubstringLen - 35);

                //ShowError(ParseMessage, true);
            }



            return string.Empty;
        }
    }


    /// <summary>
    /// Handles the Click event of the btnPhoneSearch control.
    /// On click of this button searches the clients with Phone number as search criteria. 
    /// <Author>Author: Sandeep Kuamr Trivedi</Author>
    /// <CreatedDate>Date: 25-june-07</CreatedDate>
    /// </summary>
    /// <param name="sender">The source of the event.</param>
    /// <param name="e">The <see cref="System.EventArgs"/> instance containing the event data.</param>
    protected void btnPhoneSearch_Click(object sender, EventArgs e)
    {
        try
        {
            ShowHideError(false, false, "");


            string s = StripNumeric(txtPhoneSearch.Text.Trim().ToString());
            if (s != string.Empty)
            {
                if (s.Length >= 10)
                {
                    GetClientData("PHONE", s.Substring(0, 10), "", 0);
                    ViewState["SearchType"] = "PHONE";
                    ViewState["param1"] = s.Substring(0, 10);
                    ViewState["param2"] = "";
                }
                else
                {
                    GetClientData("PHONE", s, "", 0);
                    ViewState["SearchType"] = "PHONE";
                    ViewState["param1"] = s;
                    ViewState["param2"] = "";
                }
            }
            else if (s == string.Empty)//No numeric chars found in input string.
            {
                ShowHideError(true, true, "Please Enter Valid Phone Number.");
                txtPhoneSearch.Focus();
                return;
            }
            if (dsclientSearch.Tables[2].DefaultView.Count == 0)
            {
                ShowHideError(true, true, "No Records Found");
                txtPhoneSearch.Focus();
            }
            else
            {
                if (dgStaff.Rows[0].Cells[1].Text != "&nbsp;")
                    this.ClientId = Convert.ToInt32(dgStaff.Rows[0].Cells[1].Text);
                this.ClientName = dgStaff.Rows[0].Cells[3].Text + ", " + dgStaff.Rows[0].Cells[2].Text;
                btnSelect.Enabled = true;
                btnSelect.Focus();
            }
            this.EnableScreenButton();
        }
        //Exception ex added by Pratap on 29th June 2007
        catch (Exception ex)
        {
            // Added by Pratap In order to Implement Exception Management functionality on 29th June 2007
            if (ex.Data["CustomExceptionInformation"] == null)
                //Statements commented by Priya:- sender and e parameters are not required, on 24th August 2007
                ex.Data["CustomExceptionInformation"] = "### Source Function Name - btnPhoneSearch_Click(), ParameterCount - 2, First Parameter - " + sender + ", Second Parameter - " + e + " ###";
            string ParseMessage = ex.Message;
            if (ParseMessage.IndexOf("System.Data.SqlClient.SqlException:") > 0)
            {
                int SubstringLen = ParseMessage.IndexOf("\n") - ParseMessage.IndexOf("System.Data.SqlClient.SqlException:");
                ParseMessage = ParseMessage.Substring(ParseMessage.IndexOf("System.Data.SqlClient.SqlException:") + 35, SubstringLen - 35);
                ShowError(ParseMessage, true);
            }


            Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);


        }
        finally
        {

        }
    }

    /// <summary>
    /// Handles the Click event of the btnDOBSearch control.
    /// On click of this searches clients with Date of Birth as search criteria.
    /// <Author>Author: Sandeep Kumar Trivedi</Author>
    /// <CreatedDate>Date: 25-june-07</CreatedDate>
    /// </summary>
    /// <param name="sender">The source of the event.</param>
    /// <param name="e">The <see cref="System.EventArgs"/> instance containing the event data.</param>
    protected void btnDOBSearch_Click(object sender, EventArgs e)
    {
        try
        {
            ShowHideError(false, false, "");
            if (txtDOBSearch.Text.Trim() == "")
            {
                ShowHideError(true, true, "Please Enter Search Criteria");
                return;
            }
            GetClientData("DOB", txtDOBSearch.Text, "", 0);
            ViewState["SearchType"] = "DOB";
            ViewState["param1"] = txtDOBSearch.Text;
            ViewState["param2"] = "";
            if (dsclientSearch.Tables[2].DefaultView.Count == 0)
            {
                ShowHideError(true, true, "No Records Found");
                //ScriptManager.RegisterClientScriptBlock(lblError, typeof(Button), "key", "javascript:ValidateRecordsingrid();", true);
                txtDOBSearch.Focus();
                ButtonDOBSearch = true;
                btnSelect.Enabled = false;
            }
            else
            {
                ButtonDOBSearch = true;
                if (dgStaff.Rows[0].Cells[1].Text != "&nbsp;")
                    this.ClientId = Convert.ToInt32(dgStaff.Rows[0].Cells[1].Text);
                this.ClientName = dgStaff.Rows[0].Cells[3].Text + ", " + dgStaff.Rows[0].Cells[2].Text;
                btnSelect.Enabled = true;
                btnSelect.Focus();
            }
            ButtonDOBSearch = true;
            EnablePotentialNewClient();
            this.EnableScreenButton();
        }
        //Exception ex added by Pratap on 29th June 2007
        catch (Exception ex)
        {
            // Added by Pratap In order to Implement Exception Management functionality on 29th June 2007
            if (ex.Data["CustomExceptionInformation"] == null)
                //Statements commented by Priya:- sender and e parameters are not required, on 24th August 2007
                ex.Data["CustomExceptionInformation"] = "### Source Function Name - btnDOBSearch_Click(), ParameterCount - 2, First Parameter - " + sender + ", Second Parameter - " + e + " ###";

            string ParseMessage = ex.Message;
            if (ParseMessage.IndexOf("System.Data.SqlClient.SqlException:") > 0)
            {
                int SubstringLen = ParseMessage.IndexOf("\n") - ParseMessage.IndexOf("System.Data.SqlClient.SqlException:");
                ParseMessage = ParseMessage.Substring(ParseMessage.IndexOf("System.Data.SqlClient.SqlException:") + 35, SubstringLen - 35);
                ShowError(ParseMessage, true);
            }

            Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);



        }
        finally
        {
        }
    }

    /// <summary>
    /// Handles the Click event of the btnClientIdSearch control.
    /// On click of this searches clients with Date of Birth as search criteria.
    /// <Author>Author: Sandeep Kumar Trivedi</Author>
    /// <CreatedDate>Date: 25-june-07</CreatedDate>
    /// </summary>
    /// <param name="sender">The source of the event.</param>
    /// <param name="e">The <see cref="System.EventArgs"/> instance containing the event data.</param>
    protected void btnClientIdSearch_Click(object sender, EventArgs e)
    {
        try
        {
            // this.Cursor = System.Windows.Forms.Cursors.WaitCursor;
            ShowHideError(false, false, "");
            try
            {
                GetClientData("CLIENTID", txtClientId.Text.Trim(), "", 0);
            }
            catch (Exception ex)
            {
                ShowHideError(true, true, "There is an error in Client search or External Interface not found.");
                txtClientId.Focus();
                btnSelect.Enabled = false;
                throw (ex);
            }
            if (dsclientSearch.Tables[2].DefaultView.Count == 0)
            {
                ShowHideError(true, true, "No Records Found");
                txtClientId.Focus();
                btnSelect.Enabled = false;
            }
            else
            {
                if (dgStaff.Rows[0].Cells[1].Text != "&nbsp;")
                    this.ClientId = Convert.ToInt32(dgStaff.Rows[0].Cells[1].Text);
                this.ClientName = dgStaff.Rows[0].Cells[3].Text + ", " + dgStaff.Rows[0].Cells[2].Text;
                btnSelect.Enabled = true;
                btnSelect.Focus();
            }
            this.EnableScreenButton();
        }
        //Exception ex added by Sandeep Trivedi on 29th June 2007
        catch (Exception ex)
        {
            // Added by Sandeep Trivedi In order to Implement Exception Management functionality on 29th June 2007
            if (ex.Data["CustomExceptionInformation"] == null)
                //Statements commented by Priya:- sender and e parameters are not required, on 24th August 2007
                ex.Data["CustomExceptionInformation"] = "### Source Function Name - btnClientIdSearch_Click(), ParameterCount - 2, First Parameter - " + sender + ", Second Parameter - " + e + " ###";
            if (ex.Data["DatasetInfo"] == null)
                ex.Data["DatasetInfo"] = dsclientSearch;
            //Added by Priya on 24th Aug '07
            string ParseMessage = ex.Message;
            if (ParseMessage.IndexOf("System.Data.SqlClient.SqlException:") > 0)
            {
                int SubstringLen = ParseMessage.IndexOf("\n") - ParseMessage.IndexOf("System.Data.SqlClient.SqlException:");
                ParseMessage = ParseMessage.Substring(ParseMessage.IndexOf("System.Data.SqlClient.SqlException:") + 35, SubstringLen - 35);
                ShowError(ParseMessage, true);
            }
            Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);




        }
        finally
        {

        }
    }


    //Property for set or get Sort Direction in grid as asc 
    ///	<Author>Author: Sandeep Kumar Trivedi</Author>
    private string GridViewSortDirection
    {
        get
        {
            return ViewState["SortDirection"] as string ?? "ASC";
        }
        set
        {

            ViewState["SortDirection"] = value;
        }
    }



    //Property for add filter in for SortExpression
    ///	<Author>Author: Sandeep Kumar Trivedi</Author>
    private string GridViewSortExpression
    {
        get
        {
            return SortExpression;
        }
        set
        {
            SortExpression = value;
        }
    }


    //Function for Sort data in grid as asc to desc or desc to asc
    ///	<Author>Author: Sandeep Kumar Trivedi</Author>
    private string GetSortDirection()
    {
        try
        {
            switch (GridViewSortDirection)
            {
                case "ASC":
                    GridViewSortDirection = "DESC";
                    break;
                case "DESC":
                    GridViewSortDirection = "ASC";
                    break;
            }
            return GridViewSortDirection;
        }

        catch (Exception ex)
        {
            // Added by Sandeep Trivedi In order to Implement Exception Management functionality on 29th June 2007
            if (ex.Data["CustomExceptionInformation"] == null)
                ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetSortDirection(), ParameterCount - 0###";

            if (ex.Data["DatasetInfo"] == null)
                ex.Data["DatasetInfo"] = dsclientSearch;
            //Added by Priya on 24th Aug '07
            string ParseMessage = ex.Message;
            if (ParseMessage.IndexOf("System.Data.SqlClient.SqlException:") > 0)
            {
                int SubstringLen = ParseMessage.IndexOf("\n") - ParseMessage.IndexOf("System.Data.SqlClient.SqlException:");
                ParseMessage = ParseMessage.Substring(ParseMessage.IndexOf("System.Data.SqlClient.SqlException:") + 35, SubstringLen - 35);
                ShowError(ParseMessage, true);
            }


            Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);


            return "";
        }

    }

    /// <summary>
    /// Function to short the Client Search Page 
    /// </summary>
    /// <param name="isPageIndexChanging"></param>
    /// <returns>Data View</returns>
    protected DataView SortDataTable(bool isPageIndexChanging)
    {
        try
        {
            DataView DataViewStaff;
            if (Cache["DataViewStaff"] == null)
            {
                GetClientData((string)ViewState["SearchType"], (string)ViewState["param1"], (string)ViewState["param2"], 0);
            }
            DataViewStaff = (DataView)Cache["DataViewStaff"];
            //DataViewStaff =(DataView) Session["DataViewStaff"];
            if (DataViewStaff != null)
            {
                if (GridViewSortExpression != string.Empty)
                {
                    if (isPageIndexChanging)
                    {
                        DataViewStaff.Sort = string.Format("{0} {1}", GridViewSortExpression, GridViewSortDirection);
                    }
                    else
                    {
                        DataViewStaff.Sort = string.Format("{0} {1}", GridViewSortExpression, GetSortDirection());
                        ViewState["SortDirectionTest"] = "ASC";
                    }
                }
                return DataViewStaff;
            }
            else
            {
                return new DataView();
            }
        }
        catch (Exception ex)
        {
            // Added by Sandeep Trivedi In order to Implement Exception Management functionality on 29th June 2007
            if (ex.Data["CustomExceptionInformation"] == null)
                ex.Data["CustomExceptionInformation"] = "### Source Function Name - SortDataTable(), ParameterCount - 1, isPageIndexChanging - " + isPageIndexChanging + " ###";

            //added by Priya on 24th August '07
            string ParseMessage = ex.Message;
            if (ParseMessage.IndexOf("System.Data.SqlClient.SqlException:") > 0)
            {
                int SubstringLen = ParseMessage.IndexOf("\n") - ParseMessage.IndexOf("System.Data.SqlClient.SqlException:");
                ParseMessage = ParseMessage.Substring(ParseMessage.IndexOf("System.Data.SqlClient.SqlException:") + 35, SubstringLen - 35);
                ShowError(ParseMessage, true);
            }

            Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);



            return new DataView();
        }

    }

    //Call when Sorting data
    ///	<Author>Author: Sandeep Kumar Trivedi</Author>
    protected void dgStaff_Sorting(object sender, GridViewSortEventArgs e)
    {
        try
        {
            GridViewSortExpression = e.SortExpression;
            //int pageIndex = dgStaff.PageIndex;
            dgStaff.DataSource = SortDataTable(false);
            dgStaff.PageIndex = 0;
            dgStaff.DataBind();
        }
        catch (Exception ex)
        {
            // Added by Pratap In order to Implement Exception Management functionality on 26th June 2007
            if (ex.Data["CustomExceptionInformation"] == null)
                //Statements commented by Priya:- sender and e parameters are not required, on 24th August 2007
                ex.Data["CustomExceptionInformation"] = "### Source Function Name - dgStaff_Sorting(), ParameterCount - 2, First Parameter - " + sender + ", Second Parameter - " + e + " ###";
            string ParseMessage = ex.Message;
            if (ParseMessage.IndexOf("System.Data.SqlClient.SqlException:") > 0)
            {
                int SubstringLen = ParseMessage.IndexOf("\n") - ParseMessage.IndexOf("System.Data.SqlClient.SqlException:");
                ParseMessage = ParseMessage.Substring(ParseMessage.IndexOf("System.Data.SqlClient.SqlException:") + 35, SubstringLen - 35);
                ShowError(ParseMessage, true);
            }

            Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);



        }
    }


    /// <summary>
    /// Fuction written to perform paging in the grid
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void dgStaff_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        try
        {
            this.dgStaff.DataSource = SortDataTable(true);
            this.dgStaff.PageIndex = e.NewPageIndex;
            this.dgStaff.DataBind();
        }
        catch (Exception ex)
        {
            if (ex.Data["CustomExceptionInformation"] == null)
                //Modified by Priya:- sender and e parameters are not required, on 24th August 2007
                ex.Data["CustomExceptionInformation"] = "### Source Function Name - dgStaff_PageIndexChanging(), ParameterCount - 2, First Parameter - " + sender + ", Second Parameter - " + e + " ###";
            string ParseMessage = ex.Message;
            if (ParseMessage.IndexOf("System.Data.SqlClient.SqlException:") > 0)
            {
                int SubstringLen = ParseMessage.IndexOf("\n") - ParseMessage.IndexOf("System.Data.SqlClient.SqlException:");
                ParseMessage = ParseMessage.Substring(ParseMessage.IndexOf("System.Data.SqlClient.SqlException:") + 35, SubstringLen - 35);
                ShowError(ParseMessage, true);
            }

            Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);




        }
    }

    protected void dgStaff_DataBound(object sender, EventArgs e)
    {
        int rowsNeeded = 10 - (dgStaff.Rows.Count % 10);
        if (rowsNeeded < 10)
        {
            for (int i = 0; i < rowsNeeded; i++)
            {
                GridViewRow gvr = new GridViewRow(rowsNeeded - i, 0, DataControlRowType.DataRow, DataControlRowState.Normal);
                for (int i2 = 0; i2 < 8; i2++)
                {
                    gvr.Controls.Add(new TableCell());
                }
                ((Table)dgStaff.Controls[0]).Rows.AddAt(((Table)dgStaff.Controls[0]).Rows.Count - 1, gvr);
            }

        }

    }

    /// <summary>
    /// Funtion to set the particular limit in the grid
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void dgStaff_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        try
        {
            if (e.Row.RowType == DataControlRowType.Header)
            {
                foreach (TableCell cell in e.Row.Cells)
                {
                    if (cell.HasControls())
                    {
                        LinkButton lnkbtn = (LinkButton)cell.Controls[0];
                        if (lnkbtn.Text.Replace(" ", String.Empty) == GridViewSortExpression || (lnkbtn.Text == "ID" && GridViewSortExpression == "ClientID"))
                            lnkbtn.CssClass += GridViewSortDirection == "ASC" ? "SortUp" : "SortDown";
                    }
                }
            }
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                //Trim  if it's length is greter than 20
                if (e.Row.Cells[5].Text.Length > 12)
                {
                    e.Row.Cells[5].Text = e.Row.Cells[5].Text.Substring(0, 12) + "..";
                }
                //Trim  if it's length is greter than 20
                if (e.Row.Cells[2].Text.Length > 12)
                {
                    e.Row.Cells[2].Text = e.Row.Cells[2].Text.Substring(0, 12) + "..";
                }
                //Trim  if it's length is greter than 20
                if (e.Row.Cells[3].Text.Length > 12)
                {
                    e.Row.Cells[3].Text = e.Row.Cells[3].Text.Substring(0, 12) + "..";
                }
                //if (System.Configuration.ConfigurationSettings.AppSettings["ExternalInterface"].ToString().ToUpper() == "TRUE")
                //{
                //    if (e.Row.Cells[8].Text != "")
                //    {
                //        //((Label)(e.Row.FindControl("LabelExternalClientId"))).Text = e.Row.Cells[8].Text;
                //        e.Row.Cells[1].Text = e.Row.Cells[8].Text;
                //    }
                //}
            }
        }
        catch (Exception ex)
        {
            if (ex.Data["CustomExceptionInformation"] == null)
                ex.Data["CustomExceptionInformation"] = "### Source Function Name - GridViewContractRates_RowDataBound(), ParameterCount - 2, First Parameter - " + sender + ", Second Parameter - " + e + " ###";
            if (ex.Data["DatasetInfo"] == null)
                ex.Data["DatasetInfo"] = null;
            string ParseMessage = ex.Message;
            if (ParseMessage.IndexOf("System.Data.SqlClient.SqlException:") > 0)
            {
                int SubstringLen = ParseMessage.IndexOf("\n") - ParseMessage.IndexOf("System.Data.SqlClient.SqlException:");
                ParseMessage = ParseMessage.Substring(ParseMessage.IndexOf("System.Data.SqlClient.SqlException:") + 35, SubstringLen - 35);
                ShowError(ParseMessage, true);
            }

            Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);


        }
    }

    /// <summary>
    /// Function added to show the error for the aspx page
    /// </summary>
    /// <param name="errorMessage"></param>
    /// <param name="showError"></param>
    /// <created by>Priya</created>
    /// <createed on>24th Aug '07</createed>
    public void ShowError(string errorMessage, bool showError)
    {
        try
        {
            if (showError)
            {
                ((HtmlGenericControl)this.FindControl("divimg")).Style["display"] = "block";
                ((Label)this.FindControl("lblError")).Text = errorMessage;
            }
            else
            {
                ((HtmlGenericControl)this.FindControl("divimg")).Style["display"] = "none";
                ((Label)this.FindControl("lblError")).Text = "";
            }
        }
        catch (Exception ex)
        {
            if (ex.Data["CustomExceptionInformation"] == null)
                ex.Data["CustomExceptionInformation"] = "### Source Function Name - ShowError(), ParameterCount - 2, errorMessage - " + errorMessage + ", showError - " + showError + " ###";

            ex.Message.ToString();
        }
    }



    public void EnableScreenButton()
    {
        //if (((txtFirstName.Text.Length > 0) || (txtLastName.Text.Length > 0))
        //    && ((TextBoxSSNFirst.Text.Length > 0) || (TextBoxSSNSecond.Text.Length > 0) || (txtSSNSearch.Text.Length > 0))
        //    && (txtDOBSearch.Text.Length > 0) && (ddlPrimaryProviderSearch.SelectedValue != "0"))
        //{

        //    if (_PermissionsToNew == true)
        //    {
        //        btnScreenClient.Enabled = true;
        //        // btnScreenClient.Font.Italic = false;
        //    }
        //    else
        //    {
        //        // btnScreenClient.Font.Italic = false;
        //    }
        //}


    }




}

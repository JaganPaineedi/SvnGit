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


public partial class AllergiesList : System.Web.UI.Page
{
    
   
   
    private static int GridRowNumber = 0;
    private int AllergenConceptIdToReturn;
    private string AllergenConceptDescriptionToReturn;
    public int i = 0;
    DataSet dsAllergiesData = null;

    //ProviderAccess.UserBusinessServices.DataSets.ClientSearch dsclientSearch = new ProviderAccess.UserBusinessServices.DataSets.ClientSearch();



    public string CalledFrom;
    public bool _IsClose = false;
    public int m_iRowIdx = 0;



    
    int _SearchId = 0;

    
  
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            Response.Cache.SetCacheability(HttpCacheability.NoCache);

            #region "error message color added by rohit ref. #121"
            Streamline.BaseLayer.CommonFunctions.SetErrorMegssageBackColor(lblError);
            Streamline.BaseLayer.CommonFunctions.SetErrorMegssageForeColor(lblError);
            #endregion
            if (Page.IsPostBack == false)
            {
                try
                {   
                    divimg.Attributes.Add("style", "display:none");
                    GetAllergiesData(Request.QueryString["SearchCriteria"].ToString());
                 
                    BindGridAllergies();
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
                ex.Data["CustomExceptionInformation"] = "";

            string ParseMessage = ex.Message;
            if (ParseMessage.IndexOf("System.Data.SqlClient.SqlException:") > 0)
            {
                int SubstringLen = ParseMessage.IndexOf("\n") - ParseMessage.IndexOf("System.Data.SqlClient.SqlException:");
                ParseMessage = ParseMessage.Substring(ParseMessage.IndexOf("System.Data.SqlClient.SqlException:") + 35, SubstringLen - 35);
                ShowError(ParseMessage, true);
            }
            

        }

    }


   


  
    


   

    #region Properties
    /// <summary>
    /// This property is used to return the selected clients clientId.
    /// <Author>Author: Sandeep Kumar Trivedi</Author>
    /// <CreatedDate>Date: 21-june-2007</CreatedDate>
    /// </summary>
    /// <value>The client id.</value>
    public int AllergyConceptId
    {
        get
        {
            return AllergenConceptIdToReturn;
        }
        set
        {
            AllergenConceptIdToReturn = value;
        }
    }

    /// <summary>
    /// This property is used to return the selected clients Name.
    /// <Author>Author: Sonia Dhamija</Author>
    /// <CreatedDate>Date: 01-NOV-2007</CreatedDate>
    /// </summary>
    /// <value>The Concept Description of the Allergy.</value>
    public string AllergenConceptDescription
    {
        get
        {
            return AllergenConceptDescriptionToReturn;
        }
        set
        {
            AllergenConceptDescriptionToReturn = value;
        }
    }

    

    

    #endregion

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
            //txtFirstName.Text = "";
            //txtLastName.Text = "";
            //txtSSNSearch.Text = "";
            //txtPhoneSearch.Text = "";
            //txtClientId.Text = "";
            //txtDOBSearch.Text = "";
            //ddlPrimaryProviderSearch.SelectedIndex = 0;
            //TextBoxSSNFirst.Text = "";
            //TextBoxSSNSecond.Text = "";

            //dgStaff.DataSource = null;
            ////dgStaff.DataBindings.Clear();
            //dgStaff.DataBind();

            //ButtonBroadSearch = false;
            //ButtonDOBSearch = false;
            //ButtonSSNSearch = false;
            //btnScreenClient.Enabled = false;
            //btnSelect.Enabled = false;
            //ShowHideError(false, false, " ");

            //Page.Form.DefaultButton = this.btnBroadSearch.UniqueID;
        }
        //Exception ex added by Pratap on 29th June 2007
        catch (Exception ex)
        {
            //// Added by Pratap In order to Implement Exception Management functionality on 29th June 2007
            //if (ex.Data["CustomExceptionInformation"] == null)
            //    ex.Data["CustomExceptionInformation"] = Streamline.ProviderAccessBaseLibrary.BaseCommonFunctions.Event_FormatString(Streamline.ProviderAccessBaseLibrary.BaseCommonFunctions.Singleton.EventString) + "###Source Function Name - Page_Load(), ParameterCount - 2, First Parameter - " + sender + ", Second Parameter - " + e + "###";

            ////Added by Priya on 24th Aug '07
            //string ParseMessage = ex.Message;
            //if (ParseMessage.IndexOf("System.Data.SqlClient.SqlException:") > 0)
            //{
            //    int SubstringLen = ParseMessage.IndexOf("\n") - ParseMessage.IndexOf("System.Data.SqlClient.SqlException:");
            //    ParseMessage = ParseMessage.Substring(ParseMessage.IndexOf("System.Data.SqlClient.SqlException:") + 35, SubstringLen - 35);
            //    ShowError(ParseMessage, true);
            //}
            //Streamline.ProviderAccessBaseLibrary.BaseCommonFunctions.Singleton.Instance.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error);
        }
    }




    /// <summary>
    /// Retrieves the Allergies data. and put it in a Grid.
    /// <Author>Author: Sonia</Author>
    /// <CreatedDate>Date: 1-Nov-07</CreatedDate>
    /// </summary>
    private void GetAllergiesData(string SearchCriteria)
    {
       
        Streamline.UserBusinessServices.ClientMedication objectClientMedications = null;
        try
        {
            objectClientMedications = new Streamline.UserBusinessServices.ClientMedication();
            dsAllergiesData = objectClientMedications.GetAllergiesData(SearchCriteria);
       
           
            
        }
        //Exception ex added by Pratap on 29th June 2007
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

    }

    private void BindGridAllergies()
    {
        
			try
			{
				CommonFunctions.Event_Trap(this);
                DataView DataViewAllergies = dsAllergiesData.Tables[0].DefaultView;
                DataViewAllergies.Sort = "ConceptDescription";
                DataGridAllergies.DataSource = DataViewAllergies;
                DataGridAllergies.PageIndex = 0;
                DataGridAllergies.DataBind();
        				
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


   


    /// <summary>
    /// open Client Summary Page
    /// </summary>
    /// <Author>Sandeep Kumar Trivedi</Author>
    /// <CreatedOn>28-06-2007</CreatedOn>
    private void GenerateScript()
    {
        //string _PopupScript = "";
        //try
        //{
        //    _PopupScript = "<script type='text/javascript'>" +
        //           "window.opener.OpenPage('ClientSummary')</script>";
        //    this.PlaceHolderScript.Controls.Add(new LiteralControl(_PopupScript));
        //}
        //catch (Exception ex)
        //{
            
        //    if (ex.Data["CustomExceptionInformation"] == null)
        //        ex.Data["CustomExceptionInformation"] = "";
        //    else
        //        ex.Data["CustomExceptionInformation"] = "";
        //    if (ex.Data["DatasetInfo"] == null)
        //        ex.Data["DatasetInfo"] = null;
        //    LogManager objLogManager = new LogManager();
        //    objLogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);
			
           
        //}
        //finally
        //{
        //    _PopupScript = "";
        //}
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
            //    if (ex.Data["CustomExceptionInformation"] == null)
            //        ex.Data["CustomExceptionInformation"] = Streamline.ProviderAccessBaseLibrary.BaseCommonFunctions.Event_FormatString(Streamline.ProviderAccessBaseLibrary.BaseCommonFunctions.Singleton.EventString) + "### Source Function Name - ShowHideError(), ParameterCount - 3, First Parameter - " + showImg + ", Second Parameter - " + showMsg + ", Third Parameter - " + msg + "###";
            //    //Added by Priya on 24th Aug '07
            //    string ParseMessage = ex.Message;
            //    if (ParseMessage.IndexOf("System.Data.SqlClient.SqlException:") > 0)
            //    {
            //        int SubstringLen = ParseMessage.IndexOf("\n") - ParseMessage.IndexOf("System.Data.SqlClient.SqlException:");
            //        ParseMessage = ParseMessage.Substring(ParseMessage.IndexOf("System.Data.SqlClient.SqlException:") + 35, SubstringLen - 35);
            //        ShowError(ParseMessage, true);
            //    }
            //    Streamline.ProviderAccessBaseLibrary.BaseCommonFunctions.Singleton.Instance.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error);
            //}
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
        Streamline.UserBusinessServices.DataSets.DataSetClientAllergies DataSetClientAllergies;
            DataView DataViewClientAllergies;
            DataRowView DataRowClientAllergies;
            Streamline.UserBusinessServices.ClientMedication objectClientMedications;
            DataSet DataSetFinal;
            try
            {
                string selectedValue = Request.Form["HiddenAllergyId"].ToString();
                DataSetClientAllergies = new Streamline.UserBusinessServices.DataSets.DataSetClientAllergies();
                DataViewClientAllergies = DataSetClientAllergies.Tables["ClientAllergies"].DefaultView;
            
                DataViewClientAllergies.AddNew();
                DataRowClientAllergies = DataViewClientAllergies[0];

                DataRowClientAllergies["ClientAllergyId"] = 0;
               // DataRowClientAllergies["ClientId"] = Convert.ToInt32(Streamline.UserBusinessServices.ApplicationCommonFunctions._ClientId);
                DataRowClientAllergies["ClientId"] = 102786;


                DataRowClientAllergies["AllergenConceptId"] = selectedValue;
                DataRowClientAllergies["CreatedBy"] = Convert.ToInt32(Streamline.UserBusinessServices.ApplicationCommonFunctions._StaffRowID);
                DataRowClientAllergies["CreatedDate"] = DateTime.Now;
                DataRowClientAllergies["ModifiedBy"] = Convert.ToInt32(Streamline.UserBusinessServices.ApplicationCommonFunctions._StaffRowID);
                DataRowClientAllergies["ModifiedDate"] = DateTime.Now;
                DataRowClientAllergies["RecordDeleted"] = 'N';
                DataRowClientAllergies["RowIdentifier"] = System.Guid.NewGuid();
                DataRowClientAllergies.EndEdit();
                objectClientMedications = new Streamline.UserBusinessServices.ClientMedication();
                DataSetFinal = objectClientMedications.UpdateClientAllergies(DataSetClientAllergies, ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId, ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode);

                string script = "<script language='javascript'>\n";
                script += "AllergySearch.closeDiv(1);";
                script += "</script>";
                RegisterStartupScript("CloseWindow", script);
      }
            //Exception ex added by Pratap on 29th June 2007
            catch (Exception ex)
            {
                // Added by Pratap In order to Implement Exception Management functionality on 29th June 2007
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "";

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
                DataViewClientAllergies = null;
                DataSetClientAllergies = null;
                DataRowClientAllergies = null;


            }
    }

    /// <summary>
    /// Handles the Click event of the btnCancel control.
    /// On click of this clears the selection of client and closes the form.
    /// <Author>Author: Sandeep Kuamr Trivedi</Author>
    /// <CreatedDate>Date: 25-june-07</CreatedDate>
    /// </summary>
    /// <param name="sender">The source of the event.</param>
    /// <param name="e">The <see cref="System.EventArgs"/> instance containing the event data.</param>

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        //try
        //{

        //    this.ClientId = 0;
        //    this.ClientName = "";
        //    _IsUserCreated = false;
        //    ScriptManager.RegisterClientScriptBlock(lblError, typeof(Button), "key", "javascript:window.returnValue=false;window.close();", true);
        //}
        ////Exception ex added by Pratap on 29th June 2007
        //catch (Exception ex)
        //{
        //    // Added by Pratap In order to Implement Exception Management functionality on 29th June 2007
        //    if (ex.Data["CustomExceptionInformation"] == null)
        //        //Modified by Priya:- sender and e parameters are not required, on 24th August 2007
        //        ex.Data["CustomExceptionInformation"] = Streamline.ProviderAccessBaseLibrary.BaseCommonFunctions.Event_FormatString(Streamline.ProviderAccessBaseLibrary.BaseCommonFunctions.Singleton.EventString) + "### Source Function Name - btnCancel_Click(), ParameterCount - 2, First Parameter - " + sender + ", Second Parameter - " + e + " ###";
        //    string ParseMessage = ex.Message;
        //    if (ParseMessage.IndexOf("System.Data.SqlClient.SqlException:") > 0)
        //    {
        //        int SubstringLen = ParseMessage.IndexOf("\n") - ParseMessage.IndexOf("System.Data.SqlClient.SqlException:");
        //        ParseMessage = ParseMessage.Substring(ParseMessage.IndexOf("System.Data.SqlClient.SqlException:") + 35, SubstringLen - 35);
        //        ShowError(ParseMessage, true);
        //    }
        //    Streamline.ProviderAccessBaseLibrary.BaseCommonFunctions.Singleton.Instance.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error);
        //}

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
        //try
        //{

        //    ShowHideError(false, false, "");
        //    //if (txtLastName.Text.Trim() == "" && txtFirstName.Text.Trim() == "")
        //    //{
        //    //    //				MessageBox.Show("Please enter the Search criteria");
        //    //    ShowHideError(true, true, "Please Enter Search Criteria");
        //    //}
        //    //else
        //    //{

        //    GetClientData("NARROW", txtLastName.Text.Trim(), txtFirstName.Text.Trim(), Convert.ToInt32(ddlPrimaryProviderSearch.SelectedItem.Value));
        //    ViewState["SearchType"] = "NARROW";
        //    ViewState["param1"] = txtLastName.Text.Trim();
        //    ViewState["param2"] = txtFirstName.Text.Trim();
        //    if (dsclientSearch.Tables[2].DefaultView.Count == 0)
        //    {
        //        ShowHideError(true, true, "No Records Found");
        //        txtLastName.Focus();
        //        btnSelect.Enabled = false;
        //        Page.Form.DefaultButton = this.btnBroadSearch.UniqueID;
        //    }
        //    else
        //    {
        //        //RadioClicked(0, 0);
        //        //dgStaff.Rows[0].Cells[3].Text
        //        this.ClientId = Convert.ToInt32(dgStaff.Rows[0].Cells[1].Text);
        //        this.ClientName = dgStaff.Rows[0].Cells[3].Text + ", " + dgStaff.Rows[0].Cells[2].Text;

        //        btnSelect.Enabled = true;
        //        btnSelect.Focus();
        //    }
        //    this.EnableScreenButton();
        //    // }
        //}
        ////Exception ex added by Pratap on 29th June 2007
        //catch (Exception ex)
        //{
        //    // Added by Pratap In order to Implement Exception Management functionality on 29th June 2007
        //    if (ex.Data["CustomExceptionInformation"] == null)
        //        //Modified by Priya:- sender and e parameters are not required, on 24th August 2007
        //        ex.Data["CustomExceptionInformation"] = Streamline.ProviderAccessBaseLibrary.BaseCommonFunctions.Event_FormatString(Streamline.ProviderAccessBaseLibrary.BaseCommonFunctions.Singleton.EventString) + "### Source Function Name - btnNarrowSearch_Click(), ParameterCount - 2, First Parameter - " + sender + ", Second Parameter - " + e + " ###";
        //    string ParseMessage = ex.Message;
        //    if (ParseMessage.IndexOf("System.Data.SqlClient.SqlException:") > 0)
        //    {
        //        int SubstringLen = ParseMessage.IndexOf("\n") - ParseMessage.IndexOf("System.Data.SqlClient.SqlException:");
        //        ParseMessage = ParseMessage.Substring(ParseMessage.IndexOf("System.Data.SqlClient.SqlException:") + 35, SubstringLen - 35);
        //        ShowError(ParseMessage, true);
        //    }
        //    Streamline.ProviderAccessBaseLibrary.BaseCommonFunctions.Singleton.Instance.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error);
        //}
        //finally
        //{

        //}

    }


   
    /// <summary>
    /// Function for extracting numeric chars from a string. 
    /// </summary>
    /// <param name="alphaNumericText"></param> 
    /// <returns>string</returns>
    //public static string StripNumeric(string alphaNumericText)
    //{
        //try
        //{

        //    System.Text.StringBuilder sb = new System.Text.StringBuilder();
        //    if (alphaNumericText != string.Empty || alphaNumericText != null)
        //    {
        //        foreach (char txt in alphaNumericText)
        //        {
        //            if (char.IsDigit(txt))
        //                sb.Append(txt);
        //        }
        //        return sb.ToString();
        //    }
        //    else
        //        return string.Empty;
        //}

        ////Exception ex added by Sandeep Trivedi on 29th June 2007
        //catch (Exception ex)
        //{
        //    // Added by Sandeep Trivedi In order to Implement Exception Management functionality on 29th June 2007
        //    if (ex.Data["CustomExceptionInformation"] == null)
        //        ex.Data["CustomExceptionInformation"] = Streamline.ProviderAccessBaseLibrary.BaseCommonFunctions.Event_FormatString(Streamline.ProviderAccessBaseLibrary.BaseCommonFunctions.Singleton.EventString) + "### Source Function Name - StripNumeric(), ParameterCount - 1, First Parameter - " + alphaNumericText + "###";
        //    //Added by Priya on 24th Aug '07
        //    string ParseMessage = ex.Message;
        //    if (ParseMessage.IndexOf("System.Data.SqlClient.SqlException:") > 0)
        //    {
        //        int SubstringLen = ParseMessage.IndexOf("\n") - ParseMessage.IndexOf("System.Data.SqlClient.SqlException:");
        //        ParseMessage = ParseMessage.Substring(ParseMessage.IndexOf("System.Data.SqlClient.SqlException:") + 35, SubstringLen - 35);

        //        //ShowError(ParseMessage, true);
        //    }
        //    Streamline.ProviderAccessBaseLibrary.BaseCommonFunctions.Singleton.Instance.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error);
        //    return string.Empty;
        //}
    //}

   


  


  

    //Property for set or get Sort Direction in grid as asc 
    ///	<Author>Author: Sandeep Kumar Trivedi</Author>
    //private string GridViewSortDirection
    //{
    //    //get
    //    //{
    //    //    //return ViewState["SortDirection"] as string ?? "ASC";
    //    //    if (pl.FilterExists("SortDirection"))
    //    //    {
    //    //        return pl.GetFilterValueByField("SortDirection") as string ?? "ASC";
    //    //    }
    //    //    else
    //    //    {
    //    //        return "ASC";
    //    //    }
    //    //}
    //    //set
    //    //{
    //    //    //ViewState["SortDirection"] = value;
    //    //    pl.RemoveFilter("SortDirection");
    //    //    pl.Filters.Add("SortDirection", value, false);
    //    //}
    //}


    //Property for add filter in for SortExpression
    ///	<Author>Author: Sandeep Kumar Trivedi</Author>
    //private string GridViewSortExpression
    //{
    //    //get
    //    //{
    //    //    //return ViewState["SortDirection"] as string ?? "ASC";
    //    //    if (pl.FilterExists("SortExpression"))
    //    //    {
    //    //        return pl.GetFilterValueByField("SortExpression") as string ?? string.Empty;
    //    //    }
    //    //    else
    //    //    {
    //    //        return string.Empty;
    //    //    }
    //    //}
    //    //set
    //    //{
    //    //    //ViewState["SortDirection"] = value;
    //    //    pl.RemoveFilter("SortExpression");
    //    //    pl.Filters.Add("SortExpression", value, false);
    //    //}
    //}


    //Function for Sort data in grid as asc to desc or desc to asc
    ///	<Author>Author: Sandeep Kumar Trivedi</Author>
 //   private string GetSortDirection()
  //  {
        //try
        //{
        //    switch (GridViewSortDirection)
        //    {
        //        case "ASC":
        //            GridViewSortDirection = "DESC";
        //            break;
        //        case "DESC":
        //            GridViewSortDirection = "ASC";
        //            break;
        //    }
        //    return GridViewSortDirection;
        //}

        //catch (Exception ex)
        //{
        //    // Added by Sandeep Trivedi In order to Implement Exception Management functionality on 29th June 2007
        //    if (ex.Data["CustomExceptionInformation"] == null)
        //        ex.Data["CustomExceptionInformation"] = Streamline.ProviderAccessBaseLibrary.BaseCommonFunctions.Event_FormatString(Streamline.ProviderAccessBaseLibrary.BaseCommonFunctions.Singleton.EventString) + "###Source Function Name - GetSortDirection(), ParameterCount - 0###";

        //    if (ex.Data["DatasetInfo"] == null)
        //        ex.Data["DatasetInfo"] = dsclientSearch;
        //    //Added by Priya on 24th Aug '07
        //    string ParseMessage = ex.Message;
        //    if (ParseMessage.IndexOf("System.Data.SqlClient.SqlException:") > 0)
        //    {
        //        int SubstringLen = ParseMessage.IndexOf("\n") - ParseMessage.IndexOf("System.Data.SqlClient.SqlException:");
        //        ParseMessage = ParseMessage.Substring(ParseMessage.IndexOf("System.Data.SqlClient.SqlException:") + 35, SubstringLen - 35);
        //        ShowError(ParseMessage, true);
        //    }
        //    Streamline.ProviderAccessBaseLibrary.BaseCommonFunctions.Singleton.Instance.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error);

        //    return "";
        //}

 //   }


    /// <summary>
    /// Function to short the Client Search Page 
    /// </summary>
    /// <param name="isPageIndexChanging"></param>
    /// <returns>Data View</returns>
    protected DataView SortDataTable(bool isPageIndexChanging)
    {
        //try
        //{
        //    DataView DataViewStaff;
        //    if (Cache["DataViewStaff"] == null)
        //    {
        //        GetClientData((string)ViewState["SearchType"], (string)ViewState["param1"], (string)ViewState["param2"], Convert.ToInt32(ddlPrimaryProviderSearch.SelectedItem.Value));
        //    }
        //    DataViewStaff = (DataView)Cache["DataViewStaff"];
        //    //DataViewStaff =(DataView) Session["DataViewStaff"];
        //    if (DataViewStaff != null)
        //    {
        //        if (GridViewSortExpression != string.Empty)
        //        {
        //            if (isPageIndexChanging)
        //            {
        //                DataViewStaff.Sort = string.Format("{0} {1}", GridViewSortExpression, GridViewSortDirection);
        //            }
        //            else
        //            {
        //                DataViewStaff.Sort = string.Format("{0} {1}", GridViewSortExpression, GetSortDirection());
        //                ViewState["SortDirectionTest"] = "ASC";
        //            }
        //        }
        //        return DataViewStaff;
        //    }
        //    else
        //    {
        //        return new DataView();
        //    }
        //}
        //catch (Exception ex)
        //{
        //    // Added by Sandeep Trivedi In order to Implement Exception Management functionality on 29th June 2007
        //    if (ex.Data["CustomExceptionInformation"] == null)
        //        ex.Data["CustomExceptionInformation"] = Streamline.ProviderAccessBaseLibrary.BaseCommonFunctions.Event_FormatString(Streamline.ProviderAccessBaseLibrary.BaseCommonFunctions.Singleton.EventString) + "### Source Function Name - SortDataTable(), ParameterCount - 1, isPageIndexChanging - " + isPageIndexChanging + " ###";

        //    //added by Priya on 24th August '07
        //    string ParseMessage = ex.Message;
        //    if (ParseMessage.IndexOf("System.Data.SqlClient.SqlException:") > 0)
        //    {
        //        int SubstringLen = ParseMessage.IndexOf("\n") - ParseMessage.IndexOf("System.Data.SqlClient.SqlException:");
        //        ParseMessage = ParseMessage.Substring(ParseMessage.IndexOf("System.Data.SqlClient.SqlException:") + 35, SubstringLen - 35);
        //        ShowError(ParseMessage, true);
        //    }
        //    Streamline.ProviderAccessBaseLibrary.BaseCommonFunctions.Singleton.Instance.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error);
           return new DataView();
        //}

    }


    //Call when Sorting data



    /// <summary>
    /// Fuction written to perform paging in the grid
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>

    /// <summary>
    /// Funtion to set the particular limit in the grid
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>

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
                ex.Data["CustomExceptionInformation"] = "";

            ex.Message.ToString();
        }
    }

    protected void btnScreenClient_Click(object sender, EventArgs e)
    {
        ////string str = "";
        //////SPMAUserBusinessServices.SPMACommonFunctions.CommonFunctions CommonFunctionsObject = null;
        ////ProviderAccess.UserBusinessServices.Clients ClientsObj = new ProviderAccess.UserBusinessServices.Clients();
        ////try
        ////{
        ////    string Ssn = TextBoxSSNFirst.Text + TextBoxSSNSecond.Text + txtSSNSearch.Text;
        ////    string guid = this.InsertClientSearchData(txtLastName.Text, txtFirstName.Text, Ssn, txtPhoneSearch.Text, txtDOBSearch.Text);

        ////    //DataWizardId
        ////    str = "DWId=2";

        ////    //DataWizardInstanceId
        ////    //if (EventId == -1)
        ////    str += "&" + "DWInstanceId=0";
        ////    //else
        ////    //    str += "&" + "DWInstanceId=" + AccessCenterObject.GetDataWizardInstanceIdFromEventId(EventId);

        ////    //PreviousDataWizardInstanceId
        ////    str += "&" + "PDWInstanceId=0";

        ////    //ClientId
        ////    str += "&" + "CId=" + ClientId;

        ////    //ClientSearchGUID
        ////    str += "&" + "CSGUID=" + guid;

        ////    //NextStepId
        ////    str += "&" + "NSId=0";

        ////    //UserCode
        ////    str += "&" + "UC=" + CommonFunctions.UserCode.Trim();

        ////    //Password
        ////    str += "&" + "Pwd=" + ClientsObj.GetPassword(CommonFunctions.UserId);

        ////    string strScript = "";
        ////    //inserting data into clientSearchData
        ////    strScript = "window.open('" + ConfigurationManager.AppSettings["DataWizardURL"].ToString() + "?input=" + BaseCommonFunctions.GetEncryptedData(str, "") + "', '', 'toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=0,width='+screen.availWidth +',height='+screen.availHeight+',left = 0,top = 0')";
        ////    ScriptManager.RegisterStartupScript(this, this.GetType(), this.ClientID, strScript, true);


        ////    //return str;
        ////}
        ////catch (Exception ex)
        ////{
        ////    if (ex.Data["CustomExceptionInformation"] == null)
        ////        ex.Data["CustomExceptionInformation"] = Streamline.ProviderAccessBaseLibrary.BaseCommonFunctions.Event_FormatString(Streamline.ProviderAccessBaseLibrary.BaseCommonFunctions.Singleton.EventString) + "### Source Function Name - ShowError(), ParameterCount - 0 ###";

        ////    ex.Message.ToString();
        ////}
        ////finally
        ////{
        ////    ClientsObj = null;
        ////}
    }
    /// <summary>
    /// 
    /// </summary>
    /// <param name="LastName"></param>
    /// <param name="FirstName"></param>
    /// <param name="SSN"></param>
    /// <param name="Phone"></param>
    /// <param name="_DOB"></param>
    /// <returns></returns>
    public string InsertClientSearchData(string LastName, string FirstName, string SSN, String Phone, string _DOB)
    {
        //try
        //{

        //    //this code will used for tracing
        //    Streamline.ProviderAccessBaseLibrary.BaseCommonFunctions.Event_Trap("");
        //    DataSet DataSetClientSearch = new DataSet();
        //    //Allocating memory to object DataWizardObj
        //    DateTime DOB = new DateTime();
        //    if (_DOB != "")
        //    {
        //        DOB = Convert.ToDateTime(_DOB);
        //    }
        //    else
        //    {
        //        DOB = Convert.ToDateTime(null);
        //    }

        //    ProviderAccess.UserBusinessServices.DataWizard DataWizardObj = new ProviderAccess.UserBusinessServices.DataWizard();
        //    //Passing Parameter and calling function that will return a dataset that contain guid
        //    DataSetClientSearch = DataWizardObj.InsertClientSearchData(LastName, FirstName, SSN, Phone, _DOB);
        //    //if we get guid then setting clietid to 0

        //    return DataSetClientSearch.Tables[0].Rows[0][0].ToString();

        //}
        //catch (Exception ex)
        //{
        //    // Exception Management functionality 
        //    if (ex.Data["CustomExceptionInformation"] == null)
        //        ex.Data["CustomExceptionInformation"] = Streamline.ProviderAccessBaseLibrary.BaseCommonFunctions.Event_FormatString(Streamline.ProviderAccessBaseLibrary.BaseCommonFunctions.Singleton.EventString) + "###Source Function Name - InsertClientSearchData(),ParameterCount - 5,First Parameter:" + LastName + ",Second Parameter:" + FirstName + "Theard Parameter:" + SSN + ",Forth Parameter:" + Phone + ",Fifth Parameter:" + _DOB + "###";
        //    else
        //        ex.Data["CustomExceptionInformation"] = Streamline.ProviderAccessBaseLibrary.BaseCommonFunctions.Event_FormatString(Streamline.ProviderAccessBaseLibrary.BaseCommonFunctions.Singleton.EventString) + ex.Data["CustomExceptionInformation"];


        //    Streamline.ProviderAccessBaseLibrary.BaseCommonFunctions.Singleton.Instance.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error);

        //    return ("Error :" + ex.Message); ;

        //}
        //finally
        //{


        //}
        return "";

    }


    protected void DataGridAllergies_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        //DataGridItem dgi;
        //String trCurrColor;

        //if (e.Row.RowType == DataControlRowType.DataRow)
        //{
        //    e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor='Silver'");
            
        //    e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor='White'");
        //}


       


    }
    protected void DataGridAllergies_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {

    }
    protected void DataGridAllergies_Sorting(object sender, GridViewSortEventArgs e)
    {

    }
    protected void DataGridAllergies_SelectedIndexChanged(object sender, EventArgs e)
    {
  
    }

    protected void DataGridAllergies_CheckedChanged(object sender, EventArgs e)
    {
            //CheckBox chkTemp  =  (CheckBox)(sender);
            //DataGridItem dgi;
       
            // dgi = (DataGridItem)(chkTemp.Parent.Parent);
            //if (chkTemp.Checked) 
            //{
            //    dgi.BackColor = DataGridAllergies.SelectedRow.BackColor;
            //    dgi.ForeColor = DataGridAllergies.SelectedRow.ForeColor;
            //} 
            //else
            //{
            //    //dgi.BackColor = DataGridAllergies.i
            //    //dgi.ForeColor = DataGridAllergies.ItemStyle.ForeColor;
            //}

    }
    protected void DataGridAllergies_RowCreated(object sender, GridViewRowEventArgs e)
    {

        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            //DataGridAllergies.DataKeys[e.Row.DataItemIndex].Value.ToString() 
            e.Row.Attributes.Add("onclick", "onGridViewRowSelected('" + m_iRowIdx  + "','"+DataGridAllergies.DataKeys[e.Row.DataItemIndex].Value.ToString() +"')");
        }
    m_iRowIdx++;
}	
    
}

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

public partial class UserControls_ClientMedicationDrug : Streamline.BaseLayer.ActivityPages.ActivityPage
{
    private static int GridRowNumber = 0;
    private int MedicationNameIdToReturn;
    private string MedicationNameToReturn;
    public int i = 0;
    public string CalledFrom;
    public bool _IsClose = false;
    public int m_iRowIdx = 0;
    int _SearchId = 0;
    //Added on 4th Jan
    private string DrugSearchCriteria;
    private int SelectedRowNumber;
    public string selectedRadioButton;
    bool flagSelected = false;

    protected override void Page_Load(object sender, EventArgs e)
    {
        try
        {
            //Code added in ref to Task#2806
            //Added by Loveena in ref to task#2378 - CopyrightInfo
            //Commented in ref to Task#2895
            //if (Session["UserContext"] != null)
            //LabelCopyrightInfo.Text = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).CopyrightInfo;
            if (Page.IsPostBack == false)
            {
                try
                {
                    selectedRadioButton = "#";
                    GetMedicationDrug();

                }
                catch (Exception ex)
                {

                }
            }
        }
        catch (Exception ex)
        {
            if (ex.Data["CustomExceptionInformation"] == null)
                ex.Data["CustomExceptionInformation"] = "";
            Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);

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
    /// This property is used to return the selected clients MedicationNameId.
    /// <Author>Author: Rishu Chopra</Author>
    /// <CreatedDate>Date: 1-Nov-2007</CreatedDate>
    /// </summary>
    /// <value>The MedicationNameId.</value>
    public int MedicationNameId
    {
        get
        {
            return MedicationNameIdToReturn;
        }
        set
        {
            MedicationNameIdToReturn = value;
        }
    }

    /// <summary>
    /// This property is used to return the selected clients MedicationName.
    /// <Author>Author: Rishu Chopra</Author>
    /// <CreatedDate>Date: 01-NOV-2007</CreatedDate>
    /// </summary>
    /// <value></value>
    public string MedicationName
    {
        get
        {
            return MedicationNameToReturn;
        }
        set
        {
            MedicationNameToReturn = value;
        }
    }

    #endregion

    /// <summary>
    ///Handles the Click event of btnClear.
    ///On click of this button clears the search criteria.
    /// <Author>Author: Rishu Chopra</Author>
    /// <CreatedDate>Date: 01-Nov-07</CreatedDate>
    /// </summary>
    /// <param name="sender">The source of the event.</param>
    /// <param name="e">The <see cref="System.EventArgs"/> instance containing the event data.</param>
    protected void btnClear_Click(object sender, EventArgs e)
    {
        try
        {

        }
        catch (Exception ex)
        {
        }
    }
    /// <summary>
    ///Handles the Click event of btnClear.
    ///On page load the function is used to get list of medications.
    /// <Author>Author: Rishu Chopra</Author>
    /// <CreatedDate>Date: 01-Nov-07</CreatedDate>
    /// </summary>    
    private void GetMedicationDrug()
    {
        Streamline.UserBusinessServices.ClientMedication ObjectClientMedication = null;
        DataSet DataSetDrug = null;
        //Code added by Loveena in ref to Tash#2571 dated 02Sep2009. 
        //DataRow[] dataRowStaff = null;
        try
        {


            ObjectClientMedication = new Streamline.UserBusinessServices.ClientMedication();
            DataSetDrug = new DataSet();
            if (System.Configuration.ConfigurationSettings.AppSettings["UseSoundexMedicationSearch"] == null || System.Configuration.ConfigurationSettings.AppSettings["UseSoundexMedicationSearch"].ToString() == "")
                System.Configuration.ConfigurationSettings.AppSettings["UseSoundexMedicationSearch"] = "N";
            char showDosagesInList =
                (System.Configuration.ConfigurationSettings.AppSettings["ShowDosagesInDrugList"].ToUpper() == "TRUE")
                    ? 'Y'
                    : 'N';

            DataSetDrug = ObjectClientMedication.ClientMedicationDrug(Request.QueryString["MedicationName"].ToString(), Convert.ToChar(System.Configuration.ConfigurationSettings.AppSettings["UseSoundexMedicationSearch"].ToString()), showDosagesInList);

            DrugSearchCriteria = Request.QueryString["MedicationName"].ToString();
            DataView DataViewDrug = new DataView(DataSetDrug.Tables[0]);
            DataViewDrug.Sort = "MedicationName";
            //DataGridDrug.DataSource = DataViewDrug;
            //DataGridDrug.PageIndex = 0;
            //DataGridDrug.DataBind();
            lvDrugData.DataSource = DataViewDrug;
            lvDrugData.DataBind();
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
        finally
        {
            ObjectClientMedication = null;
            DataSetDrug = null;

        }

    }



    /// <summary>
    /// Handles the Click event of the btnSelect control.
    /// On click of this button sets the client id and name of client and closes the form.
    /// <Author>Author: Rishu Chopra</Author>
    /// <CreatedDate>Date: 01-Nov-07</CreatedDate>
    /// </summary>
    /// <param name="sender">The source of the event.</param>
    /// <param name="e">The <see cref="System.EventArgs"/> instance containing the event data.</param>
    //protected void btnSelect_Click(object sender, EventArgs e)
    //{
    //    try
    //    {
    //        string MedicationNameId = Request.Form["HiddenMedicationNameId"].ToString();
    //        string MedicationName = Request.Form["HiddenMedicationName"].ToString();
    //    }
    //    catch (Exception ex)
    //    {
    //        if (ex.Data["CustomExceptionInformation"] == null)
    //            ex.Data["CustomExceptionInformation"] = "";

    //        string ParseMessage = ex.Message;
    //        if (ParseMessage.IndexOf("System.Data.SqlClient.SqlException:") > 0)
    //        {
    //            int SubstringLen = ParseMessage.IndexOf("\n") - ParseMessage.IndexOf("System.Data.SqlClient.SqlException:");
    //            ParseMessage = ParseMessage.Substring(ParseMessage.IndexOf("System.Data.SqlClient.SqlException:") + 35, SubstringLen - 35);
    //            ShowError(ParseMessage, true);
    //        }
    //    }

    //}

    /// <summary>
    /// Handles the Click event of the btnCancel control.
    /// On click of this clears the selection of client and closes the form.
    /// <Author>Author: Rishu Chopra</Author>
    /// <CreatedDate>Date: 01-Nov-07</CreatedDate>
    /// </summary>
    /// <param name="sender">The source of the event.</param>
    /// <param name="e">The <see cref="System.EventArgs"/> instance containing the event data.</param>

    protected void btnCancel_Click(object sender, EventArgs e)
    {


    }


    /// <summary>
    /// Function to short the Client Search Page 
    /// </summary>
    /// <param name="isPageIndexChanging"></param>
    /// <returns>Data View</returns>
    protected DataView SortDataTable(bool isPageIndexChanging)
    {
        return new DataView();
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
    /// <Author>Author: Rishu Chopra</Author>
    /// <CreatedDate>Date: 01-Nov-07</CreatedDate>
    public void ShowError(string errorMessage, bool showError)
    {
        try
        {
            if (showError)
            {
                ((HtmlGenericControl)Parent.FindControl("divimg")).Style["display"] = "block";
                ((Label)Parent.FindControl("lblError")).Text = errorMessage;
            }
            else
            {
                ((HtmlGenericControl)Parent.FindControl("divimg")).Style["display"] = "none";
                ((Label)Parent.FindControl("lblError")).Text = "";
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
        return "";
    }

    //protected void DataGridDrug_RowDataBound(object sender, GridViewRowEventArgs e)
    //{
    //    if (e.Row.RowType == DataControlRowType.DataRow)
    //    {
    //        RadioButton radioSelect = (RadioButton)e.Row.FindControl("RadioSelect");
    //        Label lblMedicationNameId = (Label)e.Row.FindControl("lblMedicationNameId");
    //        Label lblMedicationName = (Label)e.Row.FindControl("lblMedicationName");
    //        HiddenField hiddenFieldMedicationId = (HiddenField)e.Row.FindControl("hiddenFieldMedicationId");
    //        HyperLink lnkSelect = (HyperLink)e.Row.FindControl("HyperLink");
    //        e.Row.Attributes.Add("name", "lnk_" + lblMedicationNameId.Text);
    //        e.Row.Attributes.Add("medicationId", hiddenFieldMedicationId.Value);
    //        e.Row.Attributes.Add("ondblclick", "ClientMedicationDrugs.returnOnClick('" + radioSelect.ClientID + "','" + DataGridDrug.ClientID + "','" + lblMedicationNameId.Text + "','" + lblMedicationName.Text.Replace("'", "`") + "');");
    //        e.Row.Attributes.Add("OnClick", "ClientMedicationDrugs.ChangeColor('" + e.Row.ClientID + "','" + DataGridDrug.ClientID + "','" + radioSelect.ClientID + "','" + lblMedicationNameId.Text + "','" + lblMedicationName.Text.Replace("'", "`") + "','" + hiddenFieldMedicationId.Value + "');");
    //        e.Row.Attributes.Add("onkeydown", "ClientMedicationDrugs.SelectOnChange('" + DataGridDrug.ClientID + "','" + lblMedicationNameId.Text + "','" + lblMedicationName.Text.Replace("'", "`") + "'); return false");

    //        //Added and commented on 4 th Jan
    //        if (lblMedicationName.Text.ToString().Trim().ToUpper() == DrugSearchCriteria.ToUpper())
    //        {
    //            radioSelect.Checked = true;
    //            e.Row.BackColor = System.Drawing.ColorTranslator.FromHtml("#6D71FC");
    //            e.Row.Style.Add("Color", "White");
    //            Page.SetFocus(e.Row);
    //            selectedRadioButton = "#lnk_" + lblMedicationNameId.Text;
    //            HiddenMedicationNameId.Value = lblMedicationNameId.Text.ToString();
    //            HiddenMedicationName.Value = lblMedicationName.Text.ToString();
    //            HiddenMedicationId.Value = hiddenFieldMedicationId.Value;
    //            HiddenRadioObject.Value = e.Row.ClientID.ToString();
    //            HiddenRadioSelectedObject.Value = e.Row.ClientID.ToString() + "_RadioSelect";
    //            flagSelected = true;
    //            SelectedRowNumber = e.Row.RowIndex + 1;
    //            HiddenSelectedRowNumber.Value = SelectedRowNumber.ToString();
    //        }
    //    }
    //}
    //protected void DataGridDrug_PageIndexChanging(object sender, GridViewPageEventArgs e)
    //{

    //}
    //protected void DataGridDrug_Sorting(object sender, GridViewSortEventArgs e)
    //{

    //}
    //protected void DataGridDrug_SelectedIndexChanged(object sender, EventArgs e)
    //{

    //}

    //protected void DataGridDrug_CheckedChanged(object sender, EventArgs e)
    //{

    //}
    //protected void DataGridDrug_RowCreated(object sender, GridViewRowEventArgs e)
    //{


    //}

}

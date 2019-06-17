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
using Streamline.BaseLayer;

public partial class PharmacySearch : System.Web.UI.Page
{
    Streamline.UserBusinessServices.ClientMedication objClientMedications = null;
    int PharmacyId = 0;
    string PharmacyName = "";
    string Phone = "";
    string Fax = "";
    string State = "";
    string City = "";
    string Address = "";
    string Zip = "";
    string SureScriptIdentifier = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        this.TextBoxName.Focus();
        objClientMedications = new Streamline.UserBusinessServices.ClientMedication();

        FillStates();
        //for set the Search Button on Enter key
        this.TextBoxName.Attributes.Add("onkeydown", "if(event.which || event.keyCode){if ((event.which == 13) || (event.keyCode == 13)) {document.getElementById('" + buttonSearch.UniqueID + "').click();return false;}} else {return true};");
        this.TextBoxID.Attributes.Add("onkeydown", "if(event.which || event.keyCode){if ((event.which == 13) || (event.keyCode == 13)) {document.getElementById('" + buttonSearch.UniqueID + "').click();return false;}} else {return true}; ");
        this.TextBoxPhone.Attributes.Add("onkeydown", "if(event.which || event.keyCode){if ((event.which == 13) || (event.keyCode == 13)) {document.getElementById('" + buttonSearch.UniqueID + "').click();return false;}} else {return true}; ");
        this.TextBoxAddress.Attributes.Add("onkeydown", "if(event.which || event.keyCode){if ((event.which == 13) || (event.keyCode == 13)) {document.getElementById('" + buttonSearch.UniqueID + "').click();return false;}} else {return true}; ");
        this.TextBoxCity.Attributes.Add("onkeydown", "if(event.which || event.keyCode){if ((event.which == 13) || (event.keyCode == 13)) {document.getElementById('" + buttonSearch.UniqueID + "').click();return false;}} else {return true}; ");
        this.TextBoxSureScriptsIdentifier.Attributes.Add("onkeydown", "if(event.which || event.keyCode){if ((event.which == 13) || (event.keyCode == 13)) {document.getElementById('" + buttonSearch.UniqueID + "').click();return false;}} else {return true}; ");
        this.TextBoxFax.Attributes.Add("onkeydown", "if(event.which || event.keyCode){if ((event.which == 13) || (event.keyCode == 13)) {document.getElementById('" + buttonSearch.UniqueID + "').click();return false;}} else {return true}; ");
        this.TextBoxZip.Attributes.Add("onkeydown", "if(event.which || event.keyCode){if ((event.which == 13) || (event.keyCode == 13)) {document.getElementById('" + buttonSearch.UniqueID + "').click();return false;}} else {return true}; ");
        //
        //added By Priya
        if (Request.QueryString["img"] != null)
        {
            
            HiddenFieldImg.Value = Request.QueryString["img"].ToString();
            HiddenFieldPreferredDropDown1Value.Value = Request.QueryString["DropDownvalue1"].ToString();
            HiddenFieldPreferredDropDown2Value.Value = Request.QueryString["DropDownvalue2"].ToString();

        }
        ((LinkButton)PharmacySearchList.FindControl("LinkButtonNext")).Visible = false;
        ((LinkButton)PharmacySearchList.FindControl("LinkButtonPrevious")).Visible = false;
    }
    private void FillStates()
    {
        DataView _dataViewStates = null;
        try
        {
            _dataViewStates = Streamline.UserBusinessServices.SharedTables.DataSetStates.Tables[0].DefaultView;
            _dataViewStates.Sort = "StateName";
            DropDownListState.DataSource = _dataViewStates;
            DropDownListState.DataTextField = "StateName";
            DropDownListState.DataValueField = "StateAbbreviation";
            DropDownListState.DataBind();

            DropDownListState.Items.Insert(0, new ListItem("", ""));
            DropDownListState.SelectedIndex = 0;
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
            _dataViewStates = null;
        }
    }
    protected void GridViewSearchPharmacies_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        try
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                string PharmacyName = ((Label)e.Row.FindControl("LabelPharmacyName")).Text;
                string PharmacyId = ((Label)e.Row.FindControl("LabelPharmacyId")).Text;
                string Fax = ((Label)e.Row.FindControl("LabelFax")).Text;
                string Active = ((Label)e.Row.FindControl("LabelActive")).Text;
                string ExternalReferenceId = ((Label)e.Row.FindControl("LabelExternalReferenceId")).Text;
                string SureScriptsPharmacyIdentifier = ((Label)e.Row.FindControl("LabelSureScriptsPharmacyIdentifier")).Text;
                ((RadioButton)e.Row.FindControl("RadioButtonPharmacyId")).Attributes.Add("onclick", "onRadioClickSearch('" + PharmacyId + "','" + PharmacyName + "','" + Fax + "','" + Active + "','" + ExternalReferenceId + "','" + SureScriptsPharmacyIdentifier + "');");

            }
        }
        catch (Exception ex)
        {

            throw (ex);
        }
    }
    //private void GridBind()
    //{
    //    PharmacyName = TextBoxName.Text;
    //    Address = TextBoxAddress.Text;
    //    City = TextBoxCity.Text;
    //    State = DropDownListState.SelectedItem.Text;
    //    Zip = TextBoxZip.Text;
    //    Phone = TextBoxPhone.Text;
    //    Fax = TextBoxFax.Text;
    //    if (TextBoxID.Text != "")
    //        PharmacyId = Convert.ToInt32(TextBoxID.Text);
    //    SureScriptIdentifier = TextBoxSureScriptsIdentifier.Text;
    //    using (DataSet dataSetPharmacies = objClientMedications.GetSearchPharmacies(PharmacyName, Address, City, State, Zip, Phone, Fax, PharmacyId, SureScriptIdentifier))
    //    {

    //        GridViewSearchPharmacies.DataSource = dataSetPharmacies;
    //        GridViewSearchPharmacies.DataBind();
    //    }
    //}
    //protected void GridViewSearchPharmacies_PageIndexChanging(object sender, GridViewPageEventArgs e)
    //{
    //    GridViewSearchPharmacies.PageIndex = e.NewPageIndex;
    //    GridBind();
    //}
}

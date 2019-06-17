using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

public partial class UserControls_PharmacySearchList : Streamline.BaseLayer.BaseActivityPage
{
    Streamline.UserBusinessServices.ClientMedication objClientMedications = null;
    string pharmacyName, address, city, state, zip, phone, fax, sureScriptIdentifier, SortExpression, gvSortDirection;
    int pharmacyId, StartrowIndex, MaximumRows;
    //int TotalRecordForDisplay = 10;
    private const int PageSize = 5;
    protected int startrowIndex;
    protected int endRowIndex;
    protected int CurrentPage = 0;

    protected override void Page_Load(object sender, EventArgs e)
    {

    }

    public override void Activate()
    {

    }

    public void GridBind(string PharmacyName, string Address, string City, string State, string Zip, string Phone, string Fax, int PharmacyId, string SureScriptIdentifier, string Specialty, int startRowIndex, int endRowIndex, int CurrentPage, int PageSize)
    {
        objClientMedications = new Streamline.UserBusinessServices.ClientMedication();
        try
        {
            pharmacyId = PharmacyId;
            pharmacyName = PharmacyName;
            address = Address;
            city = City;
            state = State;
            zip = Zip;
            phone = Phone;
            fax = Fax;
            sureScriptIdentifier = SureScriptIdentifier;
            //SortExpression = sortExpression;
            //StartrowIndex = startrowIndex;
            //MaximumRows = maximumRows;
            //startrowIndex = CurrentPage * 1 + 1;
            //endRowIndex = PageSize * CurrentPage + 1;
            using (DataSet dataSetPharmacies = objClientMedications.GetSearchPharmacies(PharmacyName.Trim(), Address.Trim(), City.Trim(), State.Trim(), Zip.Trim(), Phone.Trim(), Fax.Trim(), PharmacyId, SureScriptIdentifier.Trim(), Specialty.Trim(), startRowIndex, endRowIndex))
            {

                GridViewSearchPharmacies.DataSource = dataSetPharmacies.Tables["Pharmacy"];
                GridViewSearchPharmacies.DataBind();
                Session["PharmacySearch"] = dataSetPharmacies;
                int totalRows = 0;
                int totalRecordsPerPage = 0;
                if (dataSetPharmacies.Tables["TotalRecords"].Rows[0]["TotalRecords"] != null)
                    totalRows = Convert.ToInt32(dataSetPharmacies.Tables["TotalRecords"].Rows[0]["TotalRecords"].ToString());
                totalRecordsPerPage = dataSetPharmacies.Tables["Pharmacy"].Rows.Count;
                int value = Convert.ToInt32((totalRows) / PageSize);
                if ((totalRows) % PageSize != 0 && value >= 0)
                    LabelTotalPages.Text = Convert.ToString(value + 1) + ")";
                else
                    LabelTotalPages.Text = Convert.ToString(value) + ")";
                if (CurrentPage == 0)
                {
                    LinkButtonPrevious.Enabled = false;

                    if (totalRows > PageSize)
                    {
                        LinkButtonNext.Enabled = true;
                    }
                    else
                        LinkButtonNext.Enabled = false;
                    LabelPageNumber.Text = "(Page " + (CurrentPage + 1).ToString() + " of";
                }

                else
                {
                    LinkButtonPrevious.Enabled = true;

                    if (totalRows<=(PageSize *(CurrentPage + 1)))
                        LinkButtonNext.Enabled = false;
                    else
                        LinkButtonNext.Enabled = true;
                    LabelPageNumber.Text = "(Page " + (CurrentPage + 1).ToString() + " of";
                }

            }

            //GridViewSearchPharmacies.DataSourceID = "ObjectDataSourcePharmacy";
            //GridViewSearchPharmacies.DataBind();

        }
        catch (Exception ex)
        {

            throw (ex);
        }
    }
    protected void GridViewSearchPharmacies_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        try
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                string PharmacyName = ((Label)e.Row.FindControl("LabelPharmacyName")).Text;
                ((Label)e.Row.FindControl("LabelPharmacyName")).ToolTip = PharmacyName;
                ((Label)e.Row.FindControl("LabelPharmacyName")).Style.Add("cursor", "default");
                ((Label)e.Row.FindControl("LabelPharmacyName")).Text = Streamline.UserBusinessServices.ApplicationCommonFunctions.cutText((((Label)e.Row.FindControl("LabelPharmacyName")).Text), 20);
                string PharmacyAddress = ((Label)e.Row.FindControl("LabelAddress")).Text;
                ((Label)e.Row.FindControl("LabelAddress")).ToolTip = PharmacyAddress;
                ((Label)e.Row.FindControl("LabelAddress")).Style.Add("cursor", "default");
                ((Label)e.Row.FindControl("LabelAddress")).Text = Streamline.UserBusinessServices.ApplicationCommonFunctions.cutText((((Label)e.Row.FindControl("LabelAddress")).Text), 40);
                string PharmacySpecialty = ((Label)e.Row.FindControl("LabelSpecialty")).Text;
                ((Label)e.Row.FindControl("LabelSpecialty")).ToolTip = PharmacySpecialty;
                ((Label)e.Row.FindControl("LabelSpecialty")).Style.Add("cursor", "default");
                ((Label)e.Row.FindControl("LabelSpecialty")).Text = Streamline.UserBusinessServices.ApplicationCommonFunctions.cutText((((Label)e.Row.FindControl("LabelSpecialty")).Text), 15);
               
                string PharmacyId = ((Label)e.Row.FindControl("LabelPharmacyId")).Text;
                string Fax = ((Label)e.Row.FindControl("LabelFax")).Text;
                string Active = ((Label)e.Row.FindControl("LabelActive")).Text;
                string ExternalReferenceId = ((Label)e.Row.FindControl("LabelExternalReferenceId")).Text;
                string SureScriptsPharmacyIdentifier = ((Label)e.Row.FindControl("LabelSureScriptsPharmacyIdentifier")).Text;
                ((Literal)e.Row.FindControl("ButtonPharmacyId")).Text = "<input type='radio' name='Literl' onclick = \"onRadioClickSearch('" + PharmacyId + "',unescape('" + PharmacyName.EncodeForJs() + "'),'" + Fax + "','" + Active + "','" + ExternalReferenceId + "','" + SureScriptsPharmacyIdentifier + "');\"/>";

            }
            if (e.Row.RowType == DataControlRowType.Header)
            {
                ((Label)e.Row.FindControl("LabelHeaderPharmacyName")).Attributes.Add("onclick", "GetPharmacySearchListSort('PharmacyName');return false;");
                ((Label)e.Row.FindControl("LabelHeaderPharmacyId")).Attributes.Add("onclick", "GetPharmacySearchListSort('PharmacyId');return false;");
                ((Label)e.Row.FindControl("LabelHeaderActive")).Attributes.Add("onclick", "GetPharmacySearchListSort('Active');return false;");
                ((Label)e.Row.FindControl("LabelHeaderPreferredPharmacy")).Attributes.Add("onclick", "GetPharmacySearchListSort('PreferredPharmacy');return false;");
                ((Label)e.Row.FindControl("LabelHeaderAddress")).Attributes.Add("onclick", "GetPharmacySearchListSort('Address');return false;");
                ((Label)e.Row.FindControl("LabelHeaderPhoneNumber")).Attributes.Add("onclick", "GetPharmacySearchListSort('PhoneNumber');return false;");
                ((Label)e.Row.FindControl("LabelHeaderFax")).Attributes.Add("onclick", "GetPharmacySearchListSort('FaxNumber');return false;");
                ((Label)e.Row.FindControl("LabelHeaderSureScriptsPharmacyIdentifier")).Attributes.Add("onclick", "GetPharmacySearchListSort('SureScriptsPharmacyIdentifier');return false;");
                if (GridViewSortExpression == "PharmacyName")
                    ((Label)e.Row.FindControl("LabelHeaderPharmacyName")).Attributes.Add("class", GridViewSortDirection == "ASC" ? "SortUp" : "SortDown");
                else if (GridViewSortExpression == "PharmacyId")
                    ((Label)e.Row.FindControl("LabelHeaderPharmacyId")).Attributes.Add("class", GridViewSortDirection == "ASC" ? "SortUp" : "SortDown");
                else if (GridViewSortExpression == "Active")
                    ((Label)e.Row.FindControl("LabelHeaderActive")).Attributes.Add("class", GridViewSortDirection == "ASC" ? "SortUp" : "SortDown");
                else if (GridViewSortExpression == "PreferredPharmacy")
                    ((Label)e.Row.FindControl("LabelHeaderPreferredPharmacy")).Attributes.Add("class", GridViewSortDirection == "ASC" ? "SortUp" : "SortDown");
                else if (GridViewSortExpression == "Address")
                    ((Label)e.Row.FindControl("LabelHeaderAddress")).Attributes.Add("class", GridViewSortDirection == "ASC" ? "SortUp" : "SortDown");
                else if (GridViewSortExpression == "PhoneNumber")
                    ((Label)e.Row.FindControl("LabelHeaderPhoneNumber")).Attributes.Add("class", GridViewSortDirection == "ASC" ? "SortUp" : "SortDown");
                else if (GridViewSortExpression == "FaxNumber")
                    ((Label)e.Row.FindControl("LabelHeaderFax")).Attributes.Add("class", GridViewSortDirection == "ASC" ? "SortUp" : "SortDown");
                else if (GridViewSortExpression == "SureScriptsPharmacyIdentifier")
                    ((Label)e.Row.FindControl("LabelHeaderSureScriptsPharmacyIdentifier")).Attributes.Add("class", GridViewSortDirection == "ASC" ? "SortUp" : "SortDown");
                else
                    ((Label)e.Row.FindControl("LabelHeaderPharmacyId")).Attributes.Add("class", "SortUp");
            }
        }
        catch (Exception ex)
        {

            throw (ex);
        }
    }

    public void GridBindOnSorting(string SortColumn, string SortDirection, int CurrentPage)
    {
        try
        {
            SortExpression = SortColumn;
            gvSortDirection = SortDirection;
            DataSet dsPharmacies = (DataSet)Session["PharmacySearch"];
            DataView dv = dsPharmacies.Tables["Pharmacy"].DefaultView;
            dv.Sort = "" + SortColumn + " " + SortDirection + "";
            GridViewSearchPharmacies.DataSource = dv;
            GridViewSearchPharmacies.DataBind();
            int totalRows = 0;
            int totalRecordsPerPage = 0;
            if (dsPharmacies.Tables["TotalRecords"].Rows[0]["TotalRecords"] != null)
                totalRows = Convert.ToInt32(dsPharmacies.Tables["TotalRecords"].Rows[0]["TotalRecords"].ToString());
            totalRecordsPerPage = dsPharmacies.Tables["Pharmacy"].Rows.Count;
            if (CurrentPage == 0)
            {
                LinkButtonPrevious.Enabled = false;

                if (totalRows > PageSize)
                {
                    LinkButtonNext.Enabled = true;
                }
                else
                    LinkButtonNext.Enabled = false;

            }

            else
            {
                LinkButtonPrevious.Enabled = true;

                if (totalRecordsPerPage < PageSize)
                    LinkButtonNext.Enabled = false;
                else
                    LinkButtonNext.Enabled = true;
            }

        }
        catch (Exception ex)
        {
            throw (ex);

        }
    }

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

    private string GridViewSortDirection
    {
        get
        {
            return gvSortDirection;
        }
        set
        {
            gvSortDirection = value;
        }
    }


}

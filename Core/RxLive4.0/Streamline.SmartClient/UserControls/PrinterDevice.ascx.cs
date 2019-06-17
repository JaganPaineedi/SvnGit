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

public partial class UserControls_PrinterDevice : Streamline.BaseLayer.BaseActivityPage
{
    protected override void Page_Load(object sender, EventArgs e)
    {
        //Added in ref to Task#2895
        if (System.Configuration.ConfigurationSettings.AppSettings["OpenFromSmartCare"].ToString().ToUpper() == "FALSE")
        {
            LinkButtonLogout.Style["display"] = "block";
            LinkButtonStartPage.Style["display"] = "block";
        }
        FillLocationsCombo();
        ScriptManager.RegisterStartupScript(this.Label1, Label1.GetType(), "", "SetDefaultFocus('" + DropDownListLocations.ClientID + "');", true);
    }
    /// <summary>
    /// Author Sonia
    /// Fills the Locations combo 
    /// </summary>
    private void FillLocationsCombo()
    {

        // To Fill Locations Combo 

        //Following commented as per Task #2394
        //DataSet DataSetLocations = null;
        //DataSetLocations = Streamline.UserBusinessServices.SharedTables.DataSetLocations;
        //Following code added as per Task #2394
        DataTable DataTableStaffLocations = null;

        DataView DataViewLocations = null;
        try
        {
            CommonFunctions.Event_Trap(this);
            DataTableStaffLocations = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).StaffPrescribingLocations;
            //Following changed as per Task #2394
            //DataViewLocations = DataSetLocations.Tables[0].DefaultView;
            DataViewLocations = DataTableStaffLocations.DefaultView;
            DataViewLocations.Sort = "LocationName Asc";
            DropDownListLocations.DataSource = DataViewLocations;
            DropDownListLocations.DataTextField = "LocationName";
            DropDownListLocations.DataValueField = "LocationId";
            DropDownListLocations.DataBind();

            DropDownListLocations.Items.Insert(0, new ListItem("........Select Location........", "0"));
            DropDownListLocations.SelectedIndex = 0;


        }
        catch (Exception ex)
        {

            if (ex.Data["CustomExceptionInformation"] == null)
                ex.Data["CustomExceptionInformation"] = CommonFunctions.Event_FormatString("###Source Function Name - FillLocationsCombo(),ParameterCount 0 - ###");
            else
                ex.Data["CustomExceptionInformation"] = CommonFunctions.Event_FormatString(ex.Data["CustomExceptionInformation"].ToString());
            if (ex.Data["DatasetInfo"] == null)
                ex.Data["DatasetInfo"] = null;
            Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);

        }
        finally
        {

            DataViewLocations = null;
            if (DataTableStaffLocations != null)
                DataTableStaffLocations.Dispose();

        }

    }

    protected void LinkButtonLogout_Click(object sender, EventArgs e)
    {
        Response.Redirect("MedicationLogin.aspx");
    }
}

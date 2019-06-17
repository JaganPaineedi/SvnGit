using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Streamline.BaseLayer;
using Streamline.UserBusinessServices;
using System.Data;

public partial class UserControls_ReconciliationDataList : Streamline.BaseLayer.BaseActivityPage
{
    DataSet _DataSetReconciliationDataList = null;
    DataSet _DataSetMedReconciliationDataList = null;
    //Streamline.UserBusinessServices.ClientMedication objectClientMedications;

    protected void Page_Load(object sender, EventArgs e)
    {

    }

    public override void Activate()
    {

        try
        {
            CommonFunctions.Event_Trap(this);
            BindReconciliationDataDropDown();
            if (DropDownReconciliationSourceFilter.SelectedValue != null && DropDownReconciliationSourceFilter.SelectedValue != "")
            {
                GenerateRows(DropDownReconciliationSourceFilter.SelectedValue);
            }

        }
        catch (Exception ex)
        {
            throw;
        }
        try
        {
            CommonFunctions.Event_Trap(this);
            BindMedReconciliationDataDropDown();
            if (DropDownMedReconciliation.SelectedValue != null && DropDownMedReconciliation.SelectedValue != "")
            {
                GenerateRows(DropDownMedReconciliation.SelectedValue);
            }
        }
        catch (Exception ex)
        {
            throw;
        }
    }

    private void BindReconciliationDataDropDown()
    {
        try
        {
            int ClientId = 0;
            ClientId = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId;
            Streamline.UserBusinessServices.ClientMedication objClientMedications = new Streamline.UserBusinessServices.ClientMedication();
            _DataSetReconciliationDataList = objClientMedications.GetReconciliationDropDown(ClientId);
            if (_DataSetReconciliationDataList.Tables["ReconciliationDropDownList"].Rows.Count > 0)
            {
                DropDownReconciliationSourceFilter.DataValueField = "DocumentVersionId";
                DropDownReconciliationSourceFilter.DataTextField = "Name";
                DropDownReconciliationSourceFilter.DataSource = _DataSetReconciliationDataList;
                DropDownReconciliationSourceFilter.DataBind();

            }
        }
        catch (Exception ex)
        {

        }
    }

    private void BindMedReconciliationDataDropDown()
    {
        try
        {

            Streamline.UserBusinessServices.ClientMedication objClientMedications = new Streamline.UserBusinessServices.ClientMedication();
            _DataSetMedReconciliationDataList = objClientMedications.GetMedReconciliationDropDown();
            if (_DataSetMedReconciliationDataList.Tables["MedReconciliationDropDownList"].Rows.Count > 0)
            {
                DropDownMedReconciliation.DataValueField = "GlobalCodeId";
                DropDownMedReconciliation.DataTextField = "CodeName";
                DropDownMedReconciliation.DataSource = _DataSetMedReconciliationDataList;
                DropDownMedReconciliation.DataBind();




            }
        }
        catch (Exception ex)
        {

        }
    }

    private void GenerateRows(string filterKey)
    {

    }

}

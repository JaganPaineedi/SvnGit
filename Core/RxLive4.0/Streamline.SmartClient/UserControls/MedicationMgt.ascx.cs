// This Module will be used to Display Medication Management Data on first page of Medication Management

//Version 1.00 

//Copyright © 2007, SDEI, Inc. All rights reserved.

// uses:

/* SHC

'

' history

' history

'v1.00 (Sonia Dhamjia 01-Nov-07)*/
//************************************************************************/

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
using Streamline.UserBusinessServices;
using System.Linq;


public partial class UserControls_MedicationMgt : BaseActivityPage
{
    private DataSet _DataSetClientSummary;
    Streamline.UserBusinessServices.ApplicationCommonFunctions objectCommonFunctions;
    Streamline.UserBusinessServices.ClientMedication objectClientMedications;
    DataView DataViewClientAllergies;
    private System.Data.DataView dataViewClients;
    private System.Data.DataSet DataSetClients;
    protected override void Page_Load(object sender, EventArgs e)
    {
        try
        {


            base.Page_Load(sender, e);
            Streamline.BaseLayer.CommonFunctions.Event_Trap(this);
            //Added in ref to Task#2895
            if (System.Configuration.ConfigurationSettings.AppSettings["OpenFromSmartCare"].ToString().ToUpper() == "FALSE")
            {
                LinkButtonLogout.Style["display"] = "block";
                LinkButtonStartPage.Style["display"] = "block";
            }
            if (DropDownListClients.DataSource != null)
            {
                DropDownListClients.SelectedIndex = 0;
            }

            #region "error message color added by rohit ref. #121"
            Streamline.BaseLayer.CommonFunctions.SetErrorMegssageBackColor(LabelError);
            Streamline.BaseLayer.CommonFunctions.SetErrorMegssageForeColor(LabelError);
            #endregion
            if (System.Configuration.ConfigurationSettings.AppSettings["OpenFromSmartCare"].ToString().ToUpper() == "TRUE")
            {
                //HomeImage.Visible = false;
            }
            //  Ref To #1566
            Streamline.DataService.SharedTables objSharedTables1 = new Streamline.DataService.SharedTables();
            DataSet datasetStaffPermissions = null;
            datasetStaffPermissions = objSharedTables1.GetPermissionforStaffToSeachClient((((StreamlineIdentity)Context.User.Identity)).UserId);
            DataTable dt = datasetStaffPermissions.Tables["StaffPermissionExceptions"];

            var dValue = from row in dt.AsEnumerable()
                         where row.Field<int>("PermissionTemplateType") == 5904
                               && row.Field<int>("PermissionItemId") == 8732
                         select row.Field<int>("StaffId");
            if (dValue.Count() != 0)
                HiddenFieldIsStaffHasPermissionforClientsDropDown.Value = "true";
            else
                HiddenFieldIsStaffHasPermissionforClientsDropDown.Value = "false";
            //ButtonViewHistory.Enabled = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).HasPermission(Permissions.ViewHistory);
            ButtonPrintList.Enabled = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).HasPermission(Permissions.PrintList);
            ButtonReOrder.Enabled = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).HasPermission(Permissions.ChangeOrder);
            ButtonRefillOrder.Enabled = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).HasPermission(Permissions.ReOrder);
            ButtonAdjustDosageSchedule.Enabled = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).HasPermission(Permissions.AdjustDosageSchedule);
            ButtonPatientContent.Enabled = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).HasPermission(Permissions.PatientConsent);
            ButtonCompleteOrder.Enabled = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).HasPermission(Permissions.CompleteOrder);

            ShowHidePMPButton();
            ButtonPMP.Enabled = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).HasPermission(Permissions.PMP);

            HiddenFieldPermissionCheckButtonReOrder.Value = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).HasPermission(Permissions.ChangeOrder) ? "Y" : "N";
            HiddenFieldPermissionCheckButtonRefillOrder.Value = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).HasPermission(Permissions.ReOrder) ? "Y" : "N";
            HiddenFieldPermissionCheckButtonCompleteOrder.Value = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).HasPermission(Permissions.CompleteOrder) ? "Y" : "N";

            //Activate the MedicationClientPersonalInformation Control
            MedicationClientPersonalInformation1.showEditableAllergyList = true;
            MedicationClientPersonalInformation1.Activate();
            //Code added by Loveena in ref to Task#3234 2.3 Show Client Demographics on All Client Pages 
            if (Session["DataSetClientSummary"] != null)
            {
                DataSet DataSetClientSummary = (DataSet)Session["DataSetClientSummary"];
                LabelClientName.Text = "";
                //Modified by Loveena in ref to Task#3265
                LabelClientName.Text = DataSetClientSummary.Tables["ClientInformation"].Rows[0]["ClientInformationLabel"].ToString();
            }
            ShowHidePatientContent();

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


    }

    protected void ButtonPMP_Click(object sender, EventArgs e)
    {
        Session["DataSetClientSummary"] = null;
        MedicationClientPersonalInformation1.Activate();
    }

    public void ShowHidePatientContent()
    {
        DataSet datasetSystemConfigurationKeys = null;

        Streamline.DataService.SharedTables objSharedTables = new Streamline.DataService.SharedTables();
        datasetSystemConfigurationKeys = objSharedTables.GetSystemConfigurationKeys();
        if (objSharedTables.GetSystemConfigurationKeys("SWITCHRXMEDICATIONCONSENTOFF", datasetSystemConfigurationKeys.Tables[0]).ToUpper() == "Y")
        {
            ButtonPatientContent.Visible = false;
            HiddenFieldDropDownListReports.Value = "Y";
            ButtonRunReport.Visible = false;
        } 
    }



    public void ShowHidePMPButton()
    {
        DataSet datasetSystemConfigurationKeys = null;

        Streamline.DataService.SharedTables objSharedTables = new Streamline.DataService.SharedTables();
        datasetSystemConfigurationKeys = objSharedTables.GetSystemConfigurationKeys();
        if (objSharedTables.GetSystemConfigurationKeys("DISPLAYPMPBUTTONINRX", datasetSystemConfigurationKeys.Tables[0]).ToUpper() == "YES")
        {
            string DisplayNameOfPMPButton = objSharedTables.GetSystemConfigurationKeys("DISPLAYNAMEOFPMPBUTTONINRX", datasetSystemConfigurationKeys.Tables[0]).ToString();
            if(DisplayNameOfPMPButton != "")
                ButtonPMP.Text = DisplayNameOfPMPButton;
            ButtonPMP.Visible = true;
        }
    }



    /// <summary>
    /// Author Rishu
    /// Purpose To enable/disable buttons based on Staff Permissions
    /// </summary>
    /// <param name="per"></param>
    /// <returns></returns>
    public string enableDisabled(Permissions per)
    {

        if (((Streamline.BaseLayer.StreamlinePrinciple)Context.User).HasPermission(per))
            return "";
        else
            return "Disabled";
    }

    /// <summary>
    /// Author Loveena
    /// Purpose To show/hide buttons based on Staff Permissions
    /// </summary>
    /// <param name="per"></param>
    /// <returns></returns>
    public string showHide(Permissions per)
    {

        if (((Streamline.BaseLayer.StreamlinePrinciple)Context.User).HasPermission(per))
            return "true";
        else
            return "style=" + "display:none" + "";
    }

    public override bool DocumentUpdateDocument()
    {
        return true;
    }

    public override bool DocumentCloseDocument()
    {
        return true;
    }

    public override bool DocumentDeleteDocument()
    {
        return true;
    }

    public override bool DocumentNewDocument()
    {
        return true;
    }
    #region Activate
    /// <summary>
    /// Author Sonia
    /// Purpose To get clientSummary and fill combo boxes on activation
    /// </summary>
    public override void Activate()
    {

        try
        {
            CommonFunctions.Event_Trap(this);
            base.Activate();
            //Fill the Client Medication Summary            
            GetClientSummaryData();

            //Fill the Clients Drop Down
            if (DropDownListClients.DataSource == null)
                fillComboBoxes();

            CheckBoxNoMedications.Visible = true;
            LabelNoMedications.Visible = true;
            var DataSetClientSummary = (DataSet)Session["DataSetClientSummary"];
            if (DataSetClientSummary.Tables["ClientMedications"].Select("ISNULL(Discontinued, 'N') = 'N' AND ISNULL(RecordDeleted, 'N') = 'N'").Length > 0)
            {
                CheckBoxNoMedications.Checked = false;
                CheckBoxNoMedications.Disabled = true;
            }
            else
            {
                CheckBoxNoMedications.Disabled = false;
                if (DataSetClientSummary.Tables["ClientInformation"].Columns.Contains("HasNoMedications"))
                {
                    CheckBoxNoMedications.Checked = (DataSetClientSummary.Tables["ClientInformation"].Rows[0]["HasNoMedications"].ToString() == "Y");
                }
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
            Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);

        }
        finally
        {

        }


    }
    #endregion




    /// <summary>
    /// Author:Sonia 
    /// Purpose:Fill the DropDown of Clients
    /// </summary>
    public void fillComboBoxes()
    {

        try
        {

            DataTable DataTableClientsList = new DataTable();
            DataTableClientsList.Clear();
            DataTableClientsList = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Clients;
            dataViewClients = new DataView();
            dataViewClients.Table = DataTableClientsList;
            dataViewClients.Sort = "Status,Name";


            this.DropDownListClients.DataSource = this.dataViewClients;
            this.DropDownListClients.DataTextField = "Name";


            this.DropDownListClients.DataValueField = "ClientId";
            this.DropDownListClients.DataBind();

            DropDownListClients.Items.Insert(0, new ListItem("View different Patients...", "0"));
            DropDownListClients.Items.Insert(1, new ListItem("     <Search Patients>    ", "1"));

            DropDownListClients.SelectedIndex = 0;

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
    }

    #region Get/Fill Client Summary Data
    /// <summary>
    /// Purpose:This function will be used to Get Client Medication Summary Data
    /// </summary>
    private void GetClientSummaryData()
    {
        Streamline.UserBusinessServices.DataSets.DataSetClientMedications DataSetClientMedications;

        try
        {
            objectClientMedications = new ClientMedication();
            objectCommonFunctions = new ApplicationCommonFunctions();
            CommonFunctions.Event_Trap(this);
            string _ClientRowIdentifier = "";
            string _ClinicianrowIdentifier = "";

            DataSetClientMedications = new Streamline.UserBusinessServices.DataSets.DataSetClientMedications();
            try
            {
                _ClinicianrowIdentifier = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).ClinicianRowIdentifier;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "";

                string ParseMessage = ex.Message;
                if (ParseMessage.Contains("Object") == true)
                {
                    throw new Exception("Session Expired");
                }
            }
            _ClientRowIdentifier = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientRowIdentifier;

            if (_ClientRowIdentifier != "" && _ClinicianrowIdentifier != "")
            {
                _DataSetClientSummary = objectClientMedications.DownloadClientMedicationSummary(_ClientRowIdentifier, _ClinicianrowIdentifier);
                Session["DataSetClientMedications"] = null;
                Session["DataSetPrescribedClientMedications"] = null;//Added As per task#3323 By Pradeep on 4 March 2011
                Session["DataSetClientSummary"] = _DataSetClientSummary;

                DataSetClientMedications.EnforceConstraints = false;
                DataSetClientMedications.Tables["ClientMedications"].Merge(_DataSetClientSummary.Tables["ClientMedications"]);
                DataSetClientMedications.Tables["ClientMedicationInstructions"].Merge(_DataSetClientSummary.Tables["ClientMedicationInstructions"]);

                //Activate the MedicationClientPersonalInformation Control
                MedicationClientPersonalInformation1.showEditableAllergyList = true;
                MedicationClientPersonalInformation1.Activate();
                LabelClientName.Text = "";
                LabelClientName.Text = _DataSetClientSummary.Tables["ClientInformation"].Rows[0]["ClientInformationLabel"].ToString(); //DataSetClientSummary.Tables["ClientInformation"].Rows[0]["ClientInformationLabel"].ToString();                                    
            }
        }
        catch (Exception ex)
        {
            if (ex.Data["CustomExceptionInformation"] == null)
                ex.Data["CustomExceptionInformation"] = "";
            else
                ex.Data["CustomExceptionInformation"] = "";
            if (ex.Data["DatasetInfo"] == null)
                ex.Data["DatasetInfo"] = _DataSetClientSummary;
            Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);

        }
        finally
        {
            objectClientMedications = null;
            objectCommonFunctions = null;
        }



    }


    public override bool RefreshPage()
    {
        if (Session["DataSetClientSummary"] != null)
        {
            MedicationClientPersonalInformation1.showEditableAllergyList = true;
            MedicationClientPersonalInformation1.Activate();
        }
        else
            ScriptManager.RegisterStartupScript(LabelClientScript, LabelClientScript.GetType(), ClientID.ToString(), "redirectToLoginPage();", true);
        return true;
    }

    /// <summary>
    ///<Author>Sony </Author>
    /// Purpose:To Get the drug Interactions between Medications and Merge the interactions in DataSet accordingly
    /// </summary>
    /// <param name="dsTemp"></param>
    private void getDrugInteraction(Streamline.UserBusinessServices.DataSets.DataSetClientMedications dsTemp)
    {

        try
        {
            CommonFunctions.Event_Trap(this);
            string MedicationIds = "";
            foreach (DataRow dr in dsTemp.ClientMedicationInstructions.Select("isnull(Recorddeleted,'N')<>'Y'"))
            {

                MedicationIds += dr["StrengthId"].ToString() + ",";
            }

            if (MedicationIds.Length > 1)
                MedicationIds = MedicationIds.TrimEnd(',');

            Streamline.UserBusinessServices.ClientMedication objClientMed = new Streamline.UserBusinessServices.ClientMedication();

            DataSet dsTempInteraction = objClientMed.GetClientMedicationDrugInteraction(MedicationIds, ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId, ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId);
            if (dsTempInteraction.Tables.Count > 0)
            {
                createClientMedicationInteraction(dsTempInteraction);
                Streamline.UserBusinessServices.DataSets.DataSetClientMedications dsClientMedicationsTemp = (Streamline.UserBusinessServices.DataSets.DataSetClientMedications)Session["DataSetClientMedications"];
                dsClientMedicationsTemp.ClientAllergiesInteraction.Merge(dsTempInteraction.Tables["ClientAllergyInteraction"]);
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
    /// <summary>
    /// Author Sony
    /// Purpose To create Client Medication Interactions 
    /// </summary>
    /// <param name="dsInteraction"></param>
    private void createClientMedicationInteraction(DataSet dsInteraction)
    {

        try
        {
            DataView dvTemp = new DataView(dsInteraction.Tables["ClientMedicationInteraction"]);
            dvTemp.RowFilter = "DrugInteractionMonographid >0";
            for (int i = 0; i < dvTemp.Count; i++)
            {
                DataRow[] drTemp = dsInteraction.Tables["ClientMedicationInteraction"].Select("DrugInteractionMonographid=" + dvTemp[i]["DrugInteractionMonographid"].ToString(), " MedicationId");
                getInteractionRows(drTemp);
                dvTemp.RowFilter = dvTemp.RowFilter + " and DrugInteractionMonographid<>" + dvTemp[i]["DrugInteractionMonographid"].ToString();
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
    /// <summary>
    /// Author Sony John
    /// Purpose to get the Interaction rows corresponding to the Passed Rows array
    /// </summary>
    /// <param name="drTemp"></param>
    private void getInteractionRows(DataRow[] drTemp)
    {

        try
        {
            Streamline.UserBusinessServices.DataSets.DataSetClientMedications dsClientMedications = (Streamline.UserBusinessServices.DataSets.DataSetClientMedications)Session["DataSetClientMedications"];
            int ClientMedicationInteractionId = 0;
            CommonFunctions.Event_Trap(this);

            for (int i = 0; i < drTemp.Length; i++)//Takes the first id and makes possible combination with all the rest of the ids
            {
                int MedicationId1 = 0;
                int MedicationId2 = 0;
                int k = i + 1;
                for (; k < drTemp.Length; k++)
                {


                    DataRow[] ClientMedication1 = dsClientMedications.ClientMedications.Select("StrengthId=" + drTemp[i]["MedicationId"] + " and isnull(recorddeleted,'N')<>'Y'");
                    if (ClientMedication1.Length > 0)
                    {
                        MedicationId1 = Convert.ToInt32(ClientMedication1[0]["ClientMedicationId"]);
                    }

                    DataRow[] ClientMedication2 = dsClientMedications.ClientMedications.Select("StrengthId=" + drTemp[k]["MedicationId"] + " and isnull(recorddeleted,'N')<>'Y'");
                    if (ClientMedication2.Length > 0)
                    {
                        MedicationId2 = Convert.ToInt32(ClientMedication2[0]["ClientMedicationId"]);
                    }

                    Streamline.UserBusinessServices.DataSets.DataSetClientMedications.ClientMedicationInteractionsRow[] drExists = null;
                    string Query = "((MedicationNameId1=" + drTemp[i]["MedicationId"] + " and MedicationNameId2=" + drTemp[k]["MedicationId"] + ") or (MedicationNameId2=" + drTemp[i]["MedicationId"] + " and MedicationNameId1=" + drTemp[k]["MedicationId"] + "))";
                    Query += " and InteractionLevel<=" + Convert.ToInt32(drTemp[i]["SeverityLevel"]);
                    Query += " and isnull(recorddeleted,'N')<>'Y'";

                    drExists = (Streamline.UserBusinessServices.DataSets.DataSetClientMedications.ClientMedicationInteractionsRow[])dsClientMedications.ClientMedicationInteractions.Select(Query);

                    bool newRow = false;
                    bool modifyrow = false;
                    drExists = (Streamline.UserBusinessServices.DataSets.DataSetClientMedications.ClientMedicationInteractionsRow[])dsClientMedications.ClientMedicationInteractions.Select(Query);
                    Streamline.UserBusinessServices.DataSets.DataSetClientMedications.ClientMedicationInteractionsRow drInteraction = null;
                    if (drExists.Length > 0)
                    {
                        ClientMedicationInteractionId = Convert.ToInt32(drExists[0]["ClientMedicationInteractionId"]);
                        newRow = false;
                        modifyrow = false;
                        if (Convert.ToInt32(drExists[0]["InteractionLevel"]) > Convert.ToInt32(drTemp[i]["SeverityLevel"]))
                        {
                            drInteraction = drExists[0];
                            modifyrow = true;
                        }


                    }
                    else
                    {
                        newRow = true;
                    }
                    if (newRow == true || modifyrow == true)
                    {

                        drInteraction = dsClientMedications.ClientMedicationInteractions.NewClientMedicationInteractionsRow();
                        drInteraction.ClientMedicationId1 = MedicationId1;
                        drInteraction.ClientMedicationId2 = MedicationId2;
                        drInteraction.InteractionLevel = drTemp[i]["SeverityLevel"].ToString();
                        drInteraction.DrugInteractionMonographId = Convert.ToInt32(drTemp[i]["DrugInteractionMonographId"]);
                        if (newRow)
                        {
                            drInteraction.CreatedBy = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                            drInteraction.CreatedDate = System.DateTime.Now;
                        }
                        drInteraction.ModifiedBy = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                        drInteraction.ModifiedDate = System.DateTime.Now;
                        drInteraction.MedicationNameId1 = Convert.ToInt32(drTemp[i]["MedicationId"]);
                        drInteraction.MedicationNameId2 = Convert.ToInt32(drTemp[k]["MedicationId"]);
                        drInteraction.PrescriberAcknowledgementRequired = "Y";
                        if (newRow)
                            dsClientMedications.ClientMedicationInteractions.Rows.Add(drInteraction);
                        ClientMedicationInteractionId = drInteraction.ClientMedicationInteractionId;
                    }

                }
                //Added into ClientMedicationInteractionDetails
                bool newDetailsRow = false;
                DataRow drClientMedicationDetail = null;
                DataRow[] DetailsExists = dsClientMedications.ClientMedicationInteractionDetails.Select("ClientMedicationInteractionId=" + ClientMedicationInteractionId + "and DrugDrugInteractionId=" + Convert.ToInt32(drTemp[i]["DrugDrugInteractionId"]) + " and isnull(recorddeleted,'N')<>'Y'");
                if (DetailsExists.Length > 0)
                {
                    drClientMedicationDetail = DetailsExists[0];
                    newDetailsRow = false;
                }
                else
                {
                    drClientMedicationDetail = dsClientMedications.ClientMedicationInteractionDetails.NewRow();
                    newDetailsRow = true;
                }
                drClientMedicationDetail["ClientMedicationInteractionId"] = ClientMedicationInteractionId;
                drClientMedicationDetail["DrugDrugInteractionId"] = drTemp[i]["DrugDrugInteractionId"];
                if (newDetailsRow == true)
                {
                    drClientMedicationDetail["RowIdentifier"] = System.Guid.NewGuid().ToString();
                    drClientMedicationDetail["CreatedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                    drClientMedicationDetail["CreatedDate"] = DateTime.Now;
                }
                drClientMedicationDetail["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                drClientMedicationDetail["ModifiedDate"] = DateTime.Now;
                if (newDetailsRow)
                    dsClientMedications.ClientMedicationInteractionDetails.Rows.Add(drClientMedicationDetail);

            }

            Session["DataSetClientMedications"] = dsClientMedications;

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









    #endregion


    /// <summary>
    /// Author Sonia
    /// Handles Add Medication Click event (To redirect the user to Non order Medications page)
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>

    protected void ButtonAddMedication_Click(object sender, EventArgs e)
    {
        Control CurrentlyLoadedControl = null;
        PlaceHolder PlaceHolderMain = (PlaceHolder)this.Parent;
        CurrentlyLoadedControl = this.Page.LoadControl("~/UserControls/ClientMedicationNonOrder.ascx");
        CurrentlyLoadedControl.ID = "Control_" + CurrentlyLoadedControl.ToString();
        Session["CurrentControl"] = "~/UserControls/ClientMedicatioNonOrder.ascx";
        PlaceHolderMain.Controls.Clear();
        PlaceHolderMain.Controls.Add(CurrentlyLoadedControl);

    }
    /// <summary>
    /// Handles the selected Index Change of DropDwon Clients
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void DropDownListClients_SelectedIndexChanged(object sender, EventArgs e)
    {
        string ClientId = "";
        string ExternalClientId = "";
        string UserCode = "";
        DataTable DataTableClientsList = new DataTable();
        DataTableClientsList.Clear();
        DataSet dsExternalClientInfo = new DataSet();
        try
        {
            Streamline.UserBusinessServices.ApplicationCommonFunctions objApplicationCommonFunctions;
            objApplicationCommonFunctions = new Streamline.UserBusinessServices.ApplicationCommonFunctions();
            Session["ExternalClientInformation"] = null;
            if (DropDownListClients.SelectedIndex > 0 && DropDownListClients.SelectedIndex == 1)
            {
                Session["LoadMgt"] = null;
                // fillComboBoxes();
                DropDownListClients.SelectedIndex = -1;
                //ScriptManager.RegisterStartupScript(LabelClientScript, LabelClientScript.GetType(), ClientID.ToString(), "MedicationMgt.ShowClientSearchDiv(" + ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId + ");", true);
                ScriptManager.RegisterStartupScript(LabelClientScript, LabelClientScript.GetType(), ClientID.ToString(), "ShowClientSearchDiv(" + ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId + ");", true);
            }

            else if (DropDownListClients.SelectedIndex > 0 && DropDownListClients.Text != "View Different Patients")
            {
                //Added by chandan for update/Insert the External Client information in streamline database
                if (System.Configuration.ConfigurationSettings.AppSettings["ExternalInterface"].ToString().ToUpper() == "TRUE")
                {
                    ClientId = DropDownListClients.SelectedValue;
                    UserCode = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                    DataTableClientsList = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Clients;
                    if (DataTableClientsList.Rows.Count > 0)
                    {
                        DataRow[] dr = DataTableClientsList.Select("clientid=" + ClientId + "");
                        ExternalClientId = dr[0]["ExternalClientId"].ToString();
                    }

                    if (ExternalClientId != "")
                    {
                        //We are passing Externalclientid as clientid  to the external interface
                        dsExternalClientInfo = objApplicationCommonFunctions.GetExternalClientInfo(ExternalClientId);
                        //dsExternalClientInfo = objApplicationCommonFunctions.GetExternalClientInfo(Convert.ToInt32(ExternalClientId));
                        Session["ExternalClientInformation"] = dsExternalClientInfo;
                        if (dsExternalClientInfo != null)
                        {
                            if (dsExternalClientInfo.Tables.Count > 0)
                                objApplicationCommonFunctions.UpdateExternalInformation(dsExternalClientInfo, UserCode);
                        }
                    }
                }
                //SetClient(Convert.ToInt32(DropDownListClients.SelectedValue));
                ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).RefreshData = true;
                ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).SetClientInformation(Convert.ToInt32(DropDownListClients.SelectedValue), true);
                GetClientSummaryData();
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
            Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);

        }
        finally
        {
            DataTableClientsList = null;
            dsExternalClientInfo = null;
        }
    }

    private void SetClient(Int32 ClientId)
    {
        //((Streamline.BaseLayer.StreamlinePrinciple)Context.User).RefreshData = true;
        //((Streamline.BaseLayer.StreamlinePrinciple)Context.User).SetClientInformation(ClientId);
        //GetClientSummaryData();
    }




    /// <summary>
    /// <Author>Loveena</Author>
    /// <CreationDate>27-April-2009</CreationDate>
    /// <Description>To open Patient Search Window as ref to Task#2433</Description>
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>

    protected void ButtonPatientSearch_Click(object sender, EventArgs e)
    {
        ScriptManager.RegisterStartupScript(LabelClientScript, LabelClientScript.GetType(), ClientID.ToString(), "ShowClientSearch(" + ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId + ");", true);
    }


    protected void LinkButtonSetClient_Click(object sender, EventArgs e)
    {
        //GetClientSummaryData();
    }
    protected void DropDownListClients_TextChanged(object sender, EventArgs e)
    {

    }
    protected void LinkButtonLogout_Click(object sender, EventArgs e)
    {
        Response.Redirect("MedicationLogin.aspx");
    }
}


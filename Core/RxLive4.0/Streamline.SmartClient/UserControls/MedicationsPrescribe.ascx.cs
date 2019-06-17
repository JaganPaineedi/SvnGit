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
using System.IO;
using System.Collections.Generic;
using Ajax;
using Microsoft.Reporting.WebForms;
using System.Text;
using System.Drawing.Printing;
using System.Drawing;
using System.Linq;
using System.Security;
using System.Runtime.InteropServices;
using System.Security.Cryptography.X509Certificates;
using System.Security.Cryptography;

namespace Streamline.SmartClient.UI
{
    public class ButtonCancel
    {
        public ButtonCancel()
        {

        }
    }
    public partial class UserControls_MedicationsPrescribe : BaseActivityPage
    {
        protected string OrderMedicationResult = "";
        DataSet _DataSetClientSummary = null;
        DataTable _DataTableClientMedications;
        DataTable _DataTableClientMedicationInstructions;
        DataTable _DataTableClientMedicationScriptDrugs;
        //code added By Pushpita Ref: task 85 SDI Projects FY10 - Venture 
        DataTable DataTableSureScriptsOutgoingMessages;
        DataRow DataRowSureScriptsOutgoingMessages;
        //Code end
        //Added By Anuj on 12 Feb,2010 for task ref 85
        DataTable _DataTableClientMedicationScriptDrugStrengths;
        public Dictionary<string, string> ElectronicScriptMappingIds = new Dictionary<string, string>();
        //Code Anded over here
        Streamline.UserBusinessServices.DataSets.DataSetClientMedications DataSetClientMedications;
        Streamline.UserBusinessServices.DataSets.DataSetClientMedications DataSetClientMedication1 = new Streamline.UserBusinessServices.DataSets.DataSetClientMedications();
        Streamline.UserBusinessServices.ClientMedication ObjectClientMedication = null;
        //Streamline.UserBusinessServices.DataSets.DataSetClientScripts DataSetClientScripts = null;
        Streamline.UserBusinessServices.DataSets.DataSetClientScripts DataSetClientScriptActivities = null;
        //Code added by Loveena in ref to Task#2660
        string FolderId = string.Empty;
        char OrderingMethod;
        private char OriginalOrderingMethod;
        private char VerbalOrderReadBack;
        private string StaffLicenseDegreeId;
        char PrintDrugInformation;
        int LocationId;
        DataSet DataSetTemp = null;
        DataSet DataSetTempMeds = null;
        DataSet dsTemp = null;
        DataSet DataSetPrinterDeviceLocations = null;
        Object sb = null;
        int NoOfRowsToBeCopied = 0;
        string _strNormalCategoryDrugIds = "";
        string _strControlledDrugIds = "";
        string _strC2DrugIds = "";
        string MyDirectory = "";
        System.Drawing.Image imageToConvert = null;
        byte[] renderedBytes;
        Microsoft.Reporting.WebForms.ReportViewer reportViewer1;
        string _strScriptIds = "";
        string strReceipeintName = "";
        string strReceipentOrganisation = "";
        string strReceipentFaxNumber = "";
        string _strChartScripts = "";
        bool _strChartCopiesToBePrinted = false;
        string _strFaxFailedScripts = "";
        bool _strFaxFailed = false;
        string _DrugsOrderMethod = "";
        private class ScriptMessageContainer
        {
            public string MessageId { get; set; }
            public string Message { get; set; }
        }
        List<ScriptMessageContainer> _scriptMessageContainer = new List<ScriptMessageContainer>();

        int counter = 0;
        int scriptId = 0;
        Streamline.UserBusinessServices.DataSets.DataSetClientMedications DataSetClientMedications_Temp;
        Streamline.UserBusinessServices.DataSets.DataSetClientMedications DataSetClientMedications_Temp1;
        bool _UpdateTempTables = false;
        bool _Queue = false;

        protected override void Page_Load(object sender, EventArgs e)
        {
            try
            {
                OrderMedicationResult = "";
                Streamline.BaseLayer.CommonFunctions.Event_Trap(this);

                if (System.Configuration.ConfigurationSettings.AppSettings["OpenFromSmartCare"].ToString().ToUpper() == "FALSE")
                {
                    LinkButtonLogout.Style["display"] = "block";
                    LinkButtonStartPage.Style["display"] = "none";
                }
                string _strPrintChartCopy = System.Configuration.ConfigurationManager.AppSettings["PrintChartCopyWithFax"].ToUpper();
                _DrugsOrderMethod = Request.Form["txtButtonValue"].ToString();
                if (((HiddenField)Parent.FindControl("HiddenFieldRedirectFrom")).Value.ToUpper() == "DASHBOARD" &&
                    (_DrugsOrderMethod.ToUpper() == "REFILL" || _DrugsOrderMethod.ToUpper() == "NEW ORDER"))
                {
                }
                else
                {
                    this.ButtonQueueOrder.Attributes.Add("onclick",
                                                         "javascript:return MedicationPrescribe.ValidateInputs('" +
                                                         DropDownListPharmacies.ClientID + "','" +
                                                         DropDownListLocations.ClientID + "','" +
                                                         RadioButtonFaxToPharmacy.ClientID + "','" +
                                                         RadioButtonElectronic.ClientID + "','" +
                                                         RadioButtonPrintScript.ClientID + "');");
                }

                Streamline.BaseLayer.CommonFunctions.SetErrorMegssageBackColor(LabelError);
                Streamline.BaseLayer.CommonFunctions.SetErrorMegssageForeColor(LabelError);

                if (Session["DataSetClientSummary"] != null)
                {
                    _DataSetClientSummary = (DataSet)Session["DataSetClientSummary"];

                    Streamline.UserBusinessServices.DataSets.DataSetClientMedications DataSetClientMedications;
                    DataSetClientMedications = new Streamline.UserBusinessServices.DataSets.DataSetClientMedications();
                    DataSetClientMedications = (Streamline.UserBusinessServices.DataSets.DataSetClientMedications)Session["DataSetClientMedications"];

                    DataTable _DataTableClientMedications = DataSetClientMedications.Tables["ClientMedications"];
                    DataTable _DataTableClientMedicationInstructions = DataSetClientMedications.Tables["ClientMedicationInstructions"];

                    //Allow Prescribers to Print/Fax for Other Prescribers
                    if ((((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity)).EnableOtherPrescriberSelection != "Y")
                    {
                        //Disable Print/Fax Button if the current user is a prescriber and the selected prescribe
                        //does not match the current user, disable the Print/Fax Order button
                        if (((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).Prescriber == "Y")
                        {
                            if (DataSetClientMedications.Tables["ClientMedications"].Rows[0]["PrescriberId"] != null)
                            {
                                if (Convert.ToInt32(DataSetClientMedications.Tables["ClientMedications"].Rows[0]["PrescriberId"]) != ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId)
                                    ButtonNewOrder.Enabled = false;
                            }
                        }
                    }
                   
                 string ShowFields_OTP_PWD = Session["ShowFields_OTP_PWD"].ToString();
                    // Added By Malathi Shiva :WRT Task# 1 EPCS
                    if (_DrugsOrderMethod.ToUpper() != "ADJUST")
                    {
                        if (DataSetClientMedications != null)
                        {
                            if (DataSetClientMedications.Tables["ClientMedicationScripts"].Rows.Count > 0)
                            {
                                if (DataSetClientMedications.Tables["ClientMedicationScripts"].Rows[0]["OrderingMethod"] != null && (DataSetClientMedications.Tables["ClientMedicationScripts"].Rows[0]["OrderingMethod"].ToString() == "F" || DataSetClientMedications.Tables["ClientMedicationScripts"].Rows[0]["OrderingMethod"].ToString() == "E"))
                                {
                               // Remove the above condition to show OTP and Password for Electronic order.
                              //  if (DataSetClientMedications.Tables["ClientMedicationScripts"].Rows[0]["OrderingMethod"] != null && (DataSetClientMedications.Tables["ClientMedicationScripts"].Rows[0]["OrderingMethod"].ToString() == "E"))
                              //  {
                                    DataRow[] drDEACode = DataSetClientMedications.Tables["ClientMedications"].Select("DrugCategory IN ('2','3','4','5')");
                                    if (drDEACode.Count() > 0)
                                    {
                                     if (((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).IsEPCSEnabled == "Y" && ShowFields_OTP_PWD=="Y")
                                        {
                                            this.LabelPassword.Visible = ((StreamlinePrinciple)Context.User).HasPermission(Permissions.EPCS);
                                            this.TextBoxPassword.Visible = ((StreamlinePrinciple)Context.User).HasPermission(Permissions.EPCS);
                                            this.LabelOneTimePassword.Visible = ((StreamlinePrinciple)Context.User).HasPermission(Permissions.EPCS);
                                            this.TextBoxOneTimePassword.Visible = ((StreamlinePrinciple)Context.User).HasPermission(Permissions.EPCS);
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                if (_DrugsOrderMethod.ToUpper() == "ADJUST")
                {
                    ButtonNewOrder.Text = "Update Order";
                }

                this.ButtonQueueOrder.Enabled = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).HasPermission(Permissions.QueueOrder);

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

        #region Activate
        /// <summary>
        /// Author Sonia
        /// Purpose To Bind controls when page is Activated
        /// </summary>
        public override void Activate()
        {
            Session["DataSetRdlTemp"] = null;
            DataRow[] DataRowPrinterDevice = null;
            DataRow[] DataRowStaffLocations = null;
            DataSet DataSetStaffLocations = null;
            string PrinterDeviceLocationId = string.Empty;
            string ChartCopyPrinterDeviceLocationId = string.Empty;
            DataRow[] DataRowClientPharmacy = null;//Added By Pradeep as per task#2640
            try
            {
                CommonFunctions.Event_Trap(this);
                base.Activate();

                //Code added by Loveena in ref to Task#3234 2.3 Show Client Demographics on All Client Pages 
                if (Session["DataSetClientSummary"] != null)
                {
                    DataSet _DataSetClientSummary = (DataSet)Session["DataSetClientSummary"];
                    //Modified by Loveena in ref to Task#3265
                    LabelClientName.Text = _DataSetClientSummary.Tables["ClientInformation"].Rows[0]["ClientInformationLabel"].ToString();
                }

                if (Session["DataSetClientSummary"] != null)
                {
                    _DataSetClientSummary = (DataSet)Session["DataSetClientSummary"];
                    DataSetClientMedications_Temp1 = new Streamline.UserBusinessServices.DataSets.DataSetClientMedications();
                    DataSetClientMedications_Temp1 = (Streamline.UserBusinessServices.DataSets.DataSetClientMedications)Session["DataSetClientMedications"];
                    DataSetClientMedications_Temp = (Streamline.UserBusinessServices.DataSets.DataSetClientMedications)DataSetClientMedications_Temp1.Copy();
                    DataTable _DataTableClientMedications = DataSetClientMedications_Temp.Tables["ClientMedications"];
                    DataTable _DataTableClientMedicationInstructions = DataSetClientMedications_Temp.Tables["ClientMedicationInstructions"];
                }
                DocumentUpdateTempDataSet();
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
        /// Author Sonia
        /// Fills the Pharmacies combo
        /// </summary>
        /// <Modified By>Chandan Srivastava </Modified>
        /// <Modified Date>10th Feb 2009</Modified>
        /// with ref Task #188 1.7.1 - Prescribe Window: Pharmacy Drop-Down Display Preferred First
        void FillPharmaciesCombo()
        {
            //Added by Loveena in ref to Task#85 to merge selected Pharmacy to existing Pharmacies Drop down
            HiddenFieldPharmacyId.Value = "";
            // To Fill Pharmacies Combo 
            DataSet DataSetPharmacies = null;
            //Added by Loveena in ref to Task#188 on 23-Feb-2009 as Stored Procedure ssp_SCGetDataFromPharmacies Modified.
            DataRow[] drPharmacies = null;
            //Code Commented in to Task#2589.
            //DataSetPharmacies = Streamline.UserBusinessServices.SharedTables.DataSetPharmacies;
            //DataView DataViewPharmacies = null;
            string ClientPharmecieIds = "";

            //Added by Chandan with ref Task #188 1.7.1 - Prescribe Window: Pharmacy Drop-Down Display Preferred First
            DataSet DataSetClientPharmecies = new DataSet();
            DataRow[] DataRowPharmecies = null;
            DataRow[] DataRowNonClientPharmecies = null;
            //DataTableClientPharmecies = _DataSetClientSummary.Tables["ClientPharmacies"];

            //Code added in ref to Task#2589
            Streamline.UserBusinessServices.SharedTables objectSharedTables = null;
            objectSharedTables = new Streamline.UserBusinessServices.SharedTables();
            try
            {
                CommonFunctions.Event_Trap(this);
                DataSetPharmacies = objectSharedTables.getPharmacies(((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId);
                DataRow[] DataRowClientPharmecies = _DataSetClientSummary.Tables["ClientPharmacies"].Select("1=1");
                foreach (DataRow dr1 in DataRowClientPharmecies)
                {
                    ClientPharmecieIds += dr1["PharmacyId"] + ",";
                }
                if (DataSetPharmacies != null)
                {
                    if (DataSetPharmacies.Tables[0].Rows.Count > 0)
                    {
                        //Added by Loveena in ref to Task#188 on 23-Feb-2009 as Stored Procedure ssp_SCGetDataFromPharmacies Modified.
                        drPharmacies = DataSetPharmacies.Tables[0].Select("LEN(FaxNumber) >= 7", "PharmacyName asc");
                        DataSet DataSetEditPharmacies = new DataSet();
                        DataSetEditPharmacies.Merge(drPharmacies);
                        //Code Added by Loveena Ends over here.
                        if (DataSetEditPharmacies != null)
                        {
                            if (DataSetEditPharmacies.Tables[0].Rows.Count > 0)
                            {
                                if (ClientPharmecieIds.Length > 0)
                                {
                                    ClientPharmecieIds = ClientPharmecieIds.TrimEnd(',');
                                    DataRowPharmecies = DataSetEditPharmacies.Tables[0].Select("PharmacyId in (" + ClientPharmecieIds + ")", "SequenceNumber asc");
                                    DataRowNonClientPharmecies = DataSetEditPharmacies.Tables[0].Select("PharmacyId not in (" + ClientPharmecieIds + ")", "PharmacyName asc");

                                    DataSetClientPharmecies.Merge(DataRowPharmecies);
                                    DataSetClientPharmecies.Merge(DataRowNonClientPharmecies);
                                }
                                else
                                {
                                    //Modified by Loveena  in ref to Task#188 to set the Pharmacies which are selected in Edit Preferred Parmacies at top of DropDown
                                    //                    DataSetClientPharmecies = DataSetPharmacies;
                                    DataSetClientPharmecies = DataSetEditPharmacies;
                                }

                                //Code Modified by Loveena in ref to Task#188 on 23-Feb-2009 as Stored Procedure ssp_SCGetDataFromPharmacies Modified
                                DropDownListPharmacies.DataSource = DataSetClientPharmecies.Tables[0];
                                //Code Modified by Loveena ends over here.
                                DropDownListPharmacies.DataTextField = "PharmacyName";
                                DropDownListPharmacies.DataValueField = "PharmacyId";
                                DropDownListPharmacies.DataBind();
                                DropDownListPharmacies.Items.Insert(0, new ListItem("........................Select Pharmacy........................", "0"));
                                DropDownListPharmacies.SelectedIndex = 0;

                            }
                        }
                        string clientPharmacyId = string.Empty;
                        if (DataRowPharmecies != null)
                        {
                            if (DataRowPharmecies.Length > 0)
                            {
                                clientPharmacyId = DataRowPharmecies[0]["PharmacyId"] == DBNull.Value ? "" : Convert.ToString(DataRowPharmecies[0]["PharmacyId"]);
                            }
                            if (clientPharmacyId != string.Empty)
                            {
                                if (this.DropDownListPharmacies.Items.FindByValue(clientPharmacyId) != null)
                                {
                                    DropDownListPharmacies.SelectedValue = clientPharmacyId;
                                    this.RadioButtonFaxToPharmacy.Checked = true;
                                }
                            }
                        }
                    }

                }
            }
            catch (Exception ex)
            {

                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = CommonFunctions.Event_FormatString("###Source Function Name - FillPharmaciesCombo(),ParameterCount 0 - ###");
                else
                    // ex.Data["CustomExceptionInformation"] =  CommonFunctions.Event_FormatString(ex.Data["CustomExceptionInformation"]);
                    if (ex.Data["DatasetInfo"] == null)
                        ex.Data["DatasetInfo"] = DataSetPharmacies;
                Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);

            }
            finally
            {

                if (DataSetPharmacies != null)
                    DataSetPharmacies.Dispose();
                if (DataSetClientPharmecies != null)
                    DataSetClientPharmecies.Dispose();
                //DataViewPharmacies = null;
                DataRowPharmecies = null;
                DataRowNonClientPharmecies = null;
            }

        }

        /// <summary>
        /// Author Sonia
        /// Fills the Locations combo 
        /// </summary>
        private void FillLocationsCombo()
        {
            DataTable DataTableStaffLocations = null;
            DataView DataViewLocations = null;
            try
            {
                CommonFunctions.Event_Trap(this);
                DataTableStaffLocations = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).StaffPrescribingLocations;
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



        /// <summary>
        /// <Description>Used to fill PrinterDeviceLocations Drop down list</Description>
        /// <Author>Pradeep</Author>
        /// <CreatedOn>18 Nov 2009</CreatedOn>
        /// </summary>
        private void PrinterDeviceLocationsCombo()
        {

            DataView DataViewPrinterDeviceLocations = null;
            int locationId = 0;
            try
            {
                CommonFunctions.Event_Trap(this);
                DataSetPrinterDeviceLocations = Streamline.UserBusinessServices.SharedTables.DataSetPrinterDeviceLocations;
                if (DropDownListLocations.SelectedValue != string.Empty)
                {
                    locationId = Convert.ToInt32(DropDownListLocations.SelectedValue);
                }
                if (DataSetPrinterDeviceLocations != null)
                {
                    if (DataSetPrinterDeviceLocations.Tables[0].Rows.Count > 0)
                    {
                        DataViewPrinterDeviceLocations = DataSetPrinterDeviceLocations.Tables[0].DefaultView;
                        DataViewPrinterDeviceLocations.RowFilter = "LocationId=" + locationId;
                        DataViewPrinterDeviceLocations.Sort = "DeviceLabel Asc";
                        DropDownListPrinterDeviceLocations.DataSource = DataViewPrinterDeviceLocations;
                        DropDownListPrinterDeviceLocations.DataTextField = "DeviceLabel";
                        DropDownListPrinterDeviceLocations.DataValueField = "PrinterDeviceLocationId";
                        DropDownListPrinterDeviceLocations.DataBind();
                    }
                }
                DropDownListPrinterDeviceLocations.Items.Insert(0, new ListItem("<Manual Selection>", ""));

            }
            catch (Exception ex)
            {

                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = CommonFunctions.Event_FormatString("###Source Function Name - PrinterDeviceLocationsCombo(),ParameterCount 0 - ###");
                else
                    ex.Data["CustomExceptionInformation"] = CommonFunctions.Event_FormatString(ex.Data["CustomExceptionInformation"].ToString());
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);

            }
            finally
            {

                DataViewPrinterDeviceLocations = null;
                if (DataSetPrinterDeviceLocations != null)
                    DataSetPrinterDeviceLocations.Dispose();

            }

        }

        private void BindControls()
        {

            try
            {
                // Name
                CommonFunctions.Event_Trap(this);

                if (System.Configuration.ConfigurationSettings.AppSettings["ExternalInterface"].ToString().ToUpper() == "TRUE" && Session["ExternalClientInformation"] != null)
                {
                    _DataSetClientSummary = null;
                    _DataSetClientSummary = (DataSet)Session["ExternalClientInformation"];
                    if (_DataSetClientSummary.Tables["ClientHTMLSummary"].Rows.Count > 0)
                    {
                        HyperLinkPatientName.InnerText = _DataSetClientSummary.Tables["ClientGeneralInfo"].Rows[0]["ClientName"].ToString();

                        // DOB/Age
                        string DOB = _DataSetClientSummary.Tables["ClientGeneralInfo"].Rows[0]["DOB"].ToString();
                        if (DOB == string.Empty)
                            HyperLinkPatientDOB.InnerText = "";
                        else
                            HyperLinkPatientDOB.InnerText = DateTime.Parse(DOB).ToShortDateString() + " (" + ApplicationCommonFunctions.GetAge(DOB) + ")";

                        // Sex

                        HyperLinkSex.InnerText = _DataSetClientSummary.Tables["ClientGeneralInfo"].Rows[0]["SEX"].ToString();

                        // Race
                        this.HyperLinkRace.InnerText = ApplicationCommonFunctions.cutText(_DataSetClientSummary.Tables["ClientGeneralInfo"].Rows[0]["ClientRace"].ToString(), 25);
                    }
                }
                else
                {
                    HyperLinkPatientName.InnerText = _DataSetClientSummary.Tables["ClientInformation"].Rows[0]["ClientName"].ToString();

                    // DOB/Age
                    string DOB = _DataSetClientSummary.Tables["ClientInformation"].Rows[0]["DOB"].ToString();
                    if (DOB == string.Empty)
                        HyperLinkPatientDOB.InnerText = "";
                    else
                        HyperLinkPatientDOB.InnerText = DateTime.Parse(DOB).ToShortDateString() + " (" + ApplicationCommonFunctions.GetAge(DOB) + ")";

                    // Sex

                    HyperLinkSex.InnerText = _DataSetClientSummary.Tables["ClientInformation"].Rows[0]["SEX"].ToString();

                    // Race
                    this.HyperLinkRace.InnerText = ApplicationCommonFunctions.cutText(_DataSetClientSummary.Tables["ClientInformation"].Rows[0]["ClientRace"].ToString(), 25);

                }


            }
            catch (Exception ex)
            {
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

        }

        private void ClearControls()
        {
            HyperLinkPatientName.InnerText = "";
            HyperLinkPatientDOB.InnerText = "";
            HyperLinkRace.InnerText = "";
            HyperLinkSex.InnerText = "";


        }


        /// <summary>
        /// <Description>Used to fill ChartCopyPrinterDeviceLocations Drop down list</Description>
        /// <Author>Loveena</Author>
        /// <CreatedOn>04Feb2010</CreatedOn>
        /// </summary>
        private void ChartCopyPrinterDeviceLocationsCombo()
        {

            DataView DataViewPrinterDeviceLocations = null;
            int locationId = 0;
            try
            {
                CommonFunctions.Event_Trap(this);
                DataSetPrinterDeviceLocations = Streamline.UserBusinessServices.SharedTables.DataSetPrinterDeviceLocations;
                if (DropDownListLocations.SelectedValue != string.Empty)
                {
                    locationId = Convert.ToInt32(DropDownListLocations.SelectedValue);
                }
                if (DataSetPrinterDeviceLocations != null)
                {
                    if (DataSetPrinterDeviceLocations.Tables[0].Rows.Count > 0)
                    {
                        DataViewPrinterDeviceLocations = DataSetPrinterDeviceLocations.Tables[0].DefaultView;
                        DataViewPrinterDeviceLocations.RowFilter = "LocationId=" + locationId;
                        DataViewPrinterDeviceLocations.Sort = "DeviceLabel Asc";
                        DropDownListChartCopyPrinter.DataSource = DataViewPrinterDeviceLocations;
                        DropDownListChartCopyPrinter.DataTextField = "DeviceLabel";
                        DropDownListChartCopyPrinter.DataValueField = "PrinterDeviceLocationId";
                        DropDownListChartCopyPrinter.DataBind();
                    }
                }
                DropDownListChartCopyPrinter.Items.Insert(0, new ListItem("--Select Printer--", ""));
            }
            catch (Exception ex)
            {

                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = CommonFunctions.Event_FormatString("###Source Function Name - ChartCopyPrinterDeviceLocationsCombo(),ParameterCount 0 - ###");
                else
                    ex.Data["CustomExceptionInformation"] = CommonFunctions.Event_FormatString(ex.Data["CustomExceptionInformation"].ToString());
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);

            }
            finally
            {

                DataViewPrinterDeviceLocations = null;
                if (DataSetPrinterDeviceLocations != null)
                    DataSetPrinterDeviceLocations.Dispose();

            }

        }

        /// <summary>
        /// Author Sonia
        /// Purpose To Update the records of Client Medications,Scripts rendering scripts,Printing and Faxing of rendered Scripts
        /// </summary>
        /// <returns></returns>
        public override bool DocumentUpdateDocument()
        {

            DataTable DataTableClientMedicationsNCSampleORStockDrugs;
            DataTable DataTableClientMedicationsNCNonSampleORStockDrugs;
            DataTable DataTableClientMedicationsC2SampleORStockDrugs;
            DataTable DataTableClientMedicationsC2NonSampleORStockDrugs;
            DataTable DataTableClientMedicationsControlledSampleORStockDrugs;
            DataTable DataTableClientMedicationsControlledNonSampleORStockDrugs;
            int PharmacyId = 0;
            string File = "";
            int seq = 1;
            bool _strScriptsTobeFaxedButPrinted = false;
            string strSendCoverLetter = "false";
            int NumberOfTimesFaxSend = 0;
            DataSet DataSetPharmacies;
            DataRow[] drSelectedPharmacy = null;
            DataRow[] drPharmacies = null;
            DataRow[] DataRowsClientMedeicationsCategory2Drugs = null;
            DataRow[] DataRowsClientMedicationsNormalCategoryDrugs = null;
            DataRow[] DataRowsClientMedicationsControlledCategoryDrugs = null;

            string _strPrintChartCopy = null;

            if (Session["IncludeChartcopy"].ToString() == "Y")
                _strPrintChartCopy = "true";
            else
                _strPrintChartCopy = "false";


            string _strMedicationInstructionIds = "";

            divReportViewer.InnerHtml = ""; //To clear the Temporary Rdl Report display div task #85 MM#1.7
            try
            {
                HiddenFieldShowError.Value = "";
                _DrugsOrderMethod = Request.Form["txtButtonValue"].ToString();
                if (Session["DataSetPrescribedClientMedications"] != null)
                {
                    //Ref to Task#2660
                    if (System.Configuration.ConfigurationSettings.AppSettings["SaveJpegOutput"].ToLower() == "true" && _DrugsOrderMethod.ToUpper() != "ADJUST")
                    {
                        if (System.IO.Directory.Exists(Server.MapPath("RDLC\\" + Context.User.Identity.Name)))
                        {
                            if (!System.IO.Directory.Exists(Server.MapPath("RDLC\\" + Context.User.Identity.Name + "\\JPEGS")))
                                System.IO.Directory.CreateDirectory(Server.MapPath("RDLC\\" + Context.User.Identity.Name + "\\JPEGS"));

                            foreach (string file in Directory.GetFiles(Server.MapPath("RDLC\\" + Context.User.Identity.Name + "\\")))
                            {
                                File = file.Substring(file.LastIndexOf("\\") + 1);
                                if ((File.IndexOf("JPEG") >= 0 || File.IndexOf("jpeg") >= 0))
                                {
                                    while (seq < 1000)
                                    {
                                        seq = seq + 1;
                                        if (!System.IO.File.Exists(Server.MapPath("RDLC\\" + Context.User.Identity.Name + "\\JPEGS") + "\\" + File))
                                        {
                                            System.IO.File.Move(file, Server.MapPath("RDLC\\" + Context.User.Identity.Name + "\\JPEGS") + "\\" + File);
                                            break;
                                        }
                                        else
                                        {
                                            File = ApplicationCommonFunctions.GetFileName(File, seq);
                                        }

                                    }
                                }
                            }
                        }
                    }

                    else
                    {
                        #region DeleteOldRenderedImages
                        try
                        {
                            using (Streamline.BaseLayer.RDLCPrint objRDLC = new RDLCPrint())
                            {
                                objRDLC.DeleteRenderedImages(Server.MapPath("RDLC\\" + Context.User.Identity.Name));
                            }
                        }
                        catch (Exception ex)
                        {
                            Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);
                        }

                        #endregion
                    }


                    ObjectClientMedication = new ClientMedication();
                    DataSetClientMedications = (Streamline.UserBusinessServices.DataSets.DataSetClientMedications)Session["DataSetPrescribedClientMedications"];
                    DataSetClientMedications.Tables["SureScriptsRefillRequests"].Merge(((DataSet)(Session["DataSetSureScriptRequestRefill"])).Tables[0]);

                    if (_DrugsOrderMethod.ToUpper() == "REFILL")//|| _DrugsOrderMethod.ToUpper() == "CHANGEAPPROVALORDER"
                    {
                        //Set the Primary Key for ClientMedications
                        DataColumn[] dcDataTableClientMedications = new DataColumn[1];
                        dcDataTableClientMedications[0] = DataSetClientMedications.Tables["ClientMedications"].Columns["ClientMedicationId"];
                        DataSetClientMedications.Tables["ClientMedications"].PrimaryKey = dcDataTableClientMedications;
                        //As in Refill case Interactions and Interaction Details need not to be created again as no new ClientMedications will be created
                        DataSet _dsClientSummary = new DataSet();
                        _dsClientSummary = (DataSet)Session["DataSetClientSummary"];
                        if (_dsClientSummary.Tables["ClientMedicationInteractions"].Rows.Count > 0)
                        {
                            //DataSetClientMedications.Tables["ClientMedicationInteractions"].Clear();
                            DataSetClientMedications.Tables["ClientMedicationInteractionDetails"].Clear();
                            DataSetClientMedications.Tables["ClientMedicationInteractions"].Clear();
                        }
                    }

                    // #tr - 2012.03.13 - allow electronic ordering method to be set
                    if (Session["OrderGotChangedFromElectronic"] != null && Session["OrderGotChangedFromElectronic"].ToString().ToLower().Equals("y"))
                    {
                        OrderingMethod = 'F';
                    }
                    else
                    {
                        if (DataSetClientMedications.Tables["ClientMedicationScripts"].Select("OrderingMethod = 'E'").Length > 0)
                            OrderingMethod = 'E';
                        else if (DataSetClientMedications.Tables["ClientMedicationScripts"].Select("OrderingMethod = 'F'").Length > 0)
                            OrderingMethod = 'F';
                        else OrderingMethod = 'P';
                    }

                    PrintDrugInformation = Convert.ToChar(DataSetClientMedications
                        .Tables["ClientMedicationScripts"].Rows[0]["PrintDrugInformation"].ToString());
                    VerbalOrderReadBack = Convert.ToChar(DataSetClientMedications
                        .Tables["ClientMedicationScripts"].Rows[0]["VerbalOrderReadBack"].ToString());
                    StaffLicenseDegreeId = DataSetClientMedications
                        .Tables["ClientMedicationScripts"].Rows[0]["StaffLicenseDegreeId"].ToString();

                    if (DataSetClientMedications.Tables["ClientMedicationScripts"]
                            .Rows[0]["LocationId"] != System.DBNull.Value)
                        LocationId = Convert.ToInt32(DataSetClientMedications
                            .Tables["ClientMedicationScripts"].Rows[0]["LocationId"]);

                    _DataTableClientMedications = DataSetClientMedications.Tables["ClientMedications"];
                    _DataTableClientMedicationInstructions = DataSetClientMedications.Tables["ClientMedicationInstructions"];
                    _DataTableClientMedicationScriptDrugs = DataSetClientMedications.Tables["ClientMedicationScriptDrugs"];
                    _DataTableClientMedicationScriptDrugStrengths = DataSetClientMedications.Tables["ClientMedicationScriptDrugStrengths"];

                    //Find out Category2,NormalCategory and ControlledCategoryDrugss
                    DataRowsClientMedeicationsCategory2Drugs = _DataTableClientMedications
                        .Select("(ISNULL(RecordDeleted,'N')='N') and (DrugCategory='2')", " [ClientMedicationId] DESC ");
                    DataRowsClientMedicationsNormalCategoryDrugs = _DataTableClientMedications
                        .Select("(ISNULL(RecordDeleted,'N')='N') and (DrugCategory IS NULL OR (DrugCategory<>'2' AND DrugCategory<>'3' " +
                            "AND DrugCategory<>'4' AND DrugCategory<>'5') OR DrugCategory='') ", " [ClientMedicationId] DESC ");
                    DataRowsClientMedicationsControlledCategoryDrugs = _DataTableClientMedications
                        .Select("(ISNULL(RecordDeleted,'N')='N') and (DrugCategory='3' OR DrugCategory='4' OR DrugCategory='5')", " [ClientMedicationId] DESC ");

                    DataTableClientMedicationsC2NonSampleORStockDrugs = null;
                    DataTableClientMedicationsControlledNonSampleORStockDrugs = null;
                    DataTableClientMedicationsNCNonSampleORStockDrugs = null;
                    DataTableClientMedicationsNCNonSampleORStockDrugs = _DataTableClientMedications.Clone();
                    DataTableClientMedicationsC2NonSampleORStockDrugs = _DataTableClientMedications.Clone();
                    DataTableClientMedicationsControlledNonSampleORStockDrugs = _DataTableClientMedications.Clone();

                    try
                    {
                        if (DataRowsClientMedicationsNormalCategoryDrugs.Length > 0)
                        {
                            foreach (DataRow dr in DataRowsClientMedicationsNormalCategoryDrugs)
                            {
                                _strMedicationInstructionIds = "";
                                DataRow[] drInstructions = _DataTableClientMedicationInstructions
                                    .Select("ClientMedicationId=" + Convert.ToInt32(dr["ClientMedicationId"].ToString()));
                                foreach (DataRow dr1 in drInstructions)
                                {
                                    _strMedicationInstructionIds += (_strMedicationInstructionIds != "" ? "," : "") +
                                                                   dr1["ClientMedicationInstructionId"].ToString();
                                }
                                if (_strMedicationInstructionIds != "")
                                {
                                    DataRow[] dr2 = _DataTableClientMedicationScriptDrugs
                                        .Select("ClientMedicationInstructionId in(" + _strMedicationInstructionIds +
                                            ") and (Pharmacy+Sample+Stock>0) and ISNULL(AutoCalcAllow,'Y')='Y' ");
                                    DataRow[] dr3 = _DataTableClientMedicationScriptDrugs
                                        .Select("ClientMedicationInstructionId in(" + _strMedicationInstructionIds +
                                            ") and ISNULL(AutoCalcAllow,'N')='N' ");

                                    if (dr2.Length > 0 || dr3.Length > 0)
                                        DataTableClientMedicationsNCNonSampleORStockDrugs.Rows.Add(dr.ItemArray);
                                }
                            }
                        }
                    }
                    catch (Exception ex) { }
                    finally
                    {
                        //DataRows to be disposed
                    }

                    //Category 2 Drugs
                    if (DataRowsClientMedeicationsCategory2Drugs.Length > 0)
                    {
                        foreach (DataRow dr in DataRowsClientMedeicationsCategory2Drugs)
                        {
                            _strMedicationInstructionIds = "";
                            DataRow[] drInstructions = _DataTableClientMedicationInstructions
                                .Select("ClientMedicationId=" + Convert.ToInt32(dr["ClientMedicationId"].ToString()));
                            foreach (DataRow dr1 in drInstructions)
                            {
                                _strMedicationInstructionIds += (_strMedicationInstructionIds != "" ? "," : "") +
                                    dr1["ClientMedicationInstructionId"].ToString();
                            }

                            if (_strMedicationInstructionIds != "")
                            {
                                DataRow[] dr2 = _DataTableClientMedicationScriptDrugs
                                    .Select("ClientMedicationInstructionId in(" + _strMedicationInstructionIds +
                                        ") and (Pharmacy+Sample+Stock>0)and ISNULL(AutoCalcAllow,'Y')='Y' ");
                                DataRow[] dr3 = _DataTableClientMedicationScriptDrugs
                                    .Select("ClientMedicationInstructionId in(" + _strMedicationInstructionIds +
                                        ") and ISNULL(AutoCalcAllow,'N')='N'");
                                if (dr2.Length > 0 || dr3.Length > 0)
                                    DataTableClientMedicationsC2NonSampleORStockDrugs.Rows.Add(dr.ItemArray);
                            }
                        }
                    }

                    //Controlled Drugs
                    if (DataRowsClientMedicationsControlledCategoryDrugs.Length > 0)
                    {
                        foreach (DataRow dr in DataRowsClientMedicationsControlledCategoryDrugs)
                        {
                            _strMedicationInstructionIds = "";
                            DataRow[] drInstructions = _DataTableClientMedicationInstructions
                                .Select("ClientMedicationId=" + Convert.ToInt32(dr["ClientMedicationId"].ToString()));
                            foreach (DataRow dr1 in drInstructions)
                            {
                                _strMedicationInstructionIds += (_strMedicationInstructionIds != "" ? "," : "") +
                                    dr1["ClientMedicationInstructionId"].ToString();
                            }
                            if (_strMedicationInstructionIds != "")
                            {
                                DataRow[] dr2 = _DataTableClientMedicationScriptDrugs
                                    .Select("ClientMedicationInstructionId in(" + _strMedicationInstructionIds + ")");

                                if (dr2.Length > 0)
                                    DataTableClientMedicationsControlledNonSampleORStockDrugs.Rows.Add(dr.ItemArray);
                            }
                        }
                    }

                    dsTemp = new DataSet();
                    dsTemp.Merge(DataTableClientMedicationsC2NonSampleORStockDrugs);
                    if (dsTemp.Tables.Count > 0)
                        dsTemp.Tables[0].TableName = "ClientMedicationsC2NonSampleORStockDrugs";
                    else
                        dsTemp.Merge(new DataTable("ClientMedicationsC2NonSampleORStockDrugs"));

                    dsTemp.Merge(DataTableClientMedicationsNCNonSampleORStockDrugs);
                    if (dsTemp.Tables.Count > 1)
                        dsTemp.Tables[1].TableName = "ClientMedicationsNCNonSampleORStockDrugs";
                    else
                        dsTemp.Merge(new DataTable("ClientMedicationsNCNonSampleORStockDrugs"));

                    dsTemp.Merge(DataTableClientMedicationsControlledNonSampleORStockDrugs);
                    if (dsTemp.Tables.Count > 2)
                        dsTemp.Tables[2].TableName = "ClientMedicationsControlledNonSampleORStockDrugs";
                    else
                        dsTemp.Merge(new DataTable("ClientMedicationsControlledNonSampleORStockDrugs"));

                    int _Category2Drugs = 0;
                    int _OtherCategoryDrugs = 0;
                    int _ControlledDrugs = 0;
                    int nCategory2ScriptCount = 0;
                    int nOtherCategoryScriptCount = 0;
                    int nControlledScriptCount = 0;
                    int iMedicationRowsCount = 0;
                    int __OtherCategorySampleOrStockDrugs = 0;
                    int _Category2SampleOrStockDrugs = 0;
                    int _ControlledSampleOrStockDrugs = 0;
                    int nCategory2SampleORStockScriptCount = 0;
                    int nOtherCategorySampleORStockScriptCount = 0;
                    int nControlledSampleORStockScriptCount = 0;
                    int iloopCounter = 0;

                    if (dsTemp.Tables["ClientMedicationsC2NonSampleORStockDrugs"] != null)
                        _Category2Drugs = dsTemp.Tables["ClientMedicationsC2NonSampleORStockDrugs"].Rows.Count;


                    if (dsTemp.Tables["ClientMedicationsNCNonSampleORStockDrugs"] != null)
                        _OtherCategoryDrugs = dsTemp.Tables["ClientMedicationsNCNonSampleORStockDrugs"].Rows.Count;

                    if (dsTemp.Tables["ClientMedicationsControlledNonSampleORStockDrugs"] != null)
                        _ControlledDrugs = dsTemp.Tables["ClientMedicationsControlledNonSampleORStockDrugs"].Rows.Count;

                    nCategory2ScriptCount = _Category2Drugs;
                    nOtherCategoryScriptCount = ScriptsCount(_OtherCategoryDrugs);
                    nControlledScriptCount = _ControlledDrugs;

                    int NoOfRowsToBeCopied = 0;
                    #region Generate Category2Scripts
                    //Code added as per chat with Tom to insert records in ClientMedycationScriptDrugStrengths for C2 MEdications
                    //on basis of Script generated
                    foreach (DataRow dr in dsTemp.Tables["ClientMedicationsC2NonSampleORStockDrugs"].Rows)
                    {
                        DataRow[] drClientMedicationDrugStrength = DataSetClientMedications
                            .Tables["ClientMedicationScriptDrugStrengths"].Select("ClientMedicationID=" + dr["clientMedicationId"]);
                        if (drClientMedicationDrugStrength.Length > 0)
                        {
                            foreach (DataRow drDrugStrength in drClientMedicationDrugStrength)
                            {
                                DataSetClientMedications.Tables["ClientMedicationScriptDrugStrengths"].Rows.Remove(drDrugStrength);
                            }
                        }
                    }
                    NoOfRowsToBeCopied = 0;

                    bool isScript = false;
                    for (int i = 0; i < dsTemp.Tables["ClientMedicationsC2NonSampleORStockDrugs"].Rows.Count; i++)
                    {
                        DataRow[] dtrowInstructions = DataSetClientMedications
                            .Tables["ClientMedicationInstructions"].Select("ClientMedicationId=" +
                                dsTemp.Tables["ClientMedicationsC2NonSampleORStockDrugs"]
                                    .Rows[i]["ClientMedicationId"] + " and Active='Y'", "StartDate Asc");
                        if (dtrowInstructions.Length > 0)
                        {
                            for (int index = 0; index < dtrowInstructions.Length; index++)
                            {
                                if (index > 0)
                                {
                                    if (dtrowInstructions[index - 1]["StartDate"].ToString() !=
                                                        dtrowInstructions[index]["StartDate"].ToString())
                                    {
                                        iMedicationRowsCount = 0;
                                        iMedicationRowsCount = dsTemp.Tables["ClientMedicationsC2NonSampleORStockDrugs"].Rows.Count;
                                        GenerateScriptsTableRows('N', iMedicationRowsCount,
                                            dsTemp.Tables["ClientMedicationsC2NonSampleORStockDrugs"], NoOfRowsToBeCopied, "C2");
                                        NoOfRowsToBeCopied = NoOfRowsToBeCopied + 1;
                                        DataRow[] drScriptInstructions = DataSetClientMedications
                                            .Tables["ClientMedicationScriptDrugs"].Select("ClientMedicationInstructionId=" +
                                                dtrowInstructions[index]["ClientMedicationInstructionId"]);
                                        if (drScriptInstructions.Length > 0)
                                            drScriptInstructions[0]["ClientMedicationScriptId"] = scriptId;

                                        DataRow dataRowClientMEdicationScriptDrugStrengths =
                                            DataSetClientMedications.Tables["ClientMedicationScriptDrugStrengths"].NewRow();

                                        int id = 0;
                                        if (DataSetClientMedications.Tables["ClientMedicationScriptDrugStrengths"].Rows.Count > 0)
                                        {
                                            id = Convert.ToInt32(DataSetClientMedications
                                                .Tables["ClientMedicationScriptDrugStrengths"]
                                                .Compute("Min(ClientMedicationScriptDrugStrengthId)", ""));
                                            dataRowClientMEdicationScriptDrugStrengths["ClientMedicationScriptDrugStrengthId"] = (id > 0 ? -1 : id - 1);
                                        }
                                        else
                                            dataRowClientMEdicationScriptDrugStrengths["ClientMedicationScriptDrugStrengthId"] = id;

                                        dataRowClientMEdicationScriptDrugStrengths["ClientMedicationScriptId"] = scriptId;
                                        dataRowClientMEdicationScriptDrugStrengths["ClientMedicationId"] = dtrowInstructions[index]["ClientMedicationId"];
                                        dataRowClientMEdicationScriptDrugStrengths["StrengthId"] = dtrowInstructions[index]["StrengthId"];
                                        dataRowClientMEdicationScriptDrugStrengths["Pharmacy"] = drScriptInstructions[0]["Pharmacy"];
                                        dataRowClientMEdicationScriptDrugStrengths["PharmacyText"] = drScriptInstructions[0]["PharmacyText"];
                                        dataRowClientMEdicationScriptDrugStrengths["Sample"] = drScriptInstructions[0]["Sample"];
                                        dataRowClientMEdicationScriptDrugStrengths["Stock"] = drScriptInstructions[0]["Stock"];
                                        dataRowClientMEdicationScriptDrugStrengths["Refills"] = 0;
                                        dataRowClientMEdicationScriptDrugStrengths["RowIdentifier"] = System.Guid.NewGuid();
                                        dataRowClientMEdicationScriptDrugStrengths["CreatedBy"] =
                                            ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                                        dataRowClientMEdicationScriptDrugStrengths["CreatedDate"] = DateTime.Now;
                                        dataRowClientMEdicationScriptDrugStrengths["ModifiedBy"] =
                                            ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                                        dataRowClientMEdicationScriptDrugStrengths["ModifiedDate"] = DateTime.Now;
                                        DataSetClientMedications.Tables["ClientMedicationScriptDrugStrengths"].Rows
                                            .Add(dataRowClientMEdicationScriptDrugStrengths);

                                        isScript = true;
                                    }
                                    else
                                    {
                                        if (isScript == false)
                                        {
                                            iMedicationRowsCount = 0;
                                            iMedicationRowsCount = dsTemp.Tables["ClientMedicationsC2NonSampleORStockDrugs"].Rows.Count;
                                            GenerateScriptsTableRows('N', iMedicationRowsCount, dsTemp
                                                .Tables["ClientMedicationsC2NonSampleORStockDrugs"], NoOfRowsToBeCopied, "C2");
                                            NoOfRowsToBeCopied = NoOfRowsToBeCopied + 1;
                                            DataRow[] drScriptInstructions = DataSetClientMedications
                                                .Tables["ClientMedicationScriptDrugs"].Select("ClientMedicationInstructionId=" +
                                                    dtrowInstructions[index]["ClientMedicationInstructionId"]);
                                            if (drScriptInstructions.Length > 0)
                                                drScriptInstructions[0]["ClientMedicationScriptId"] = scriptId;

                                            DataRow dataRowClientMEdicationScriptDrugStrengths =
                                                DataSetClientMedications.Tables["ClientMedicationScriptDrugStrengths"].NewRow();

                                            int id = 0;
                                            if (DataSetClientMedications.Tables["ClientMedicationScriptDrugStrengths"].Rows.Count > 0)
                                            {
                                                id = Convert.ToInt32(DataSetClientMedications.Tables["ClientMedicationScriptDrugStrengths"]
                                                    .Compute("Min(ClientMedicationScriptDrugStrengthId)", ""));
                                                dataRowClientMEdicationScriptDrugStrengths[
                                                    "ClientMedicationScriptDrugStrengthId"] = (id > 0 ? -1 : id - 1);
                                            }
                                            else
                                                dataRowClientMEdicationScriptDrugStrengths["ClientMedicationScriptDrugStrengthId"] = id;

                                            dataRowClientMEdicationScriptDrugStrengths["ClientMedicationScriptId"] = scriptId;
                                            dataRowClientMEdicationScriptDrugStrengths["ClientMedicationId"] = dtrowInstructions[index]["ClientMedicationId"];
                                            dataRowClientMEdicationScriptDrugStrengths["StrengthId"] = dtrowInstructions[index]["StrengthId"];
                                            dataRowClientMEdicationScriptDrugStrengths["Pharmacy"] = drScriptInstructions[0]["Pharmacy"];
                                            dataRowClientMEdicationScriptDrugStrengths["PharmacyText"] = drScriptInstructions[0]["PharmacyText"];
                                            dataRowClientMEdicationScriptDrugStrengths["Sample"] = drScriptInstructions[0]["Sample"];
                                            dataRowClientMEdicationScriptDrugStrengths["Stock"] = drScriptInstructions[0]["Stock"];
                                            dataRowClientMEdicationScriptDrugStrengths["Refills"] = 0;
                                            dataRowClientMEdicationScriptDrugStrengths["RowIdentifier"] = System.Guid.NewGuid();
                                            dataRowClientMEdicationScriptDrugStrengths["CreatedBy"] =
                                                ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                                            dataRowClientMEdicationScriptDrugStrengths["CreatedDate"] = DateTime.Now;

                                            dataRowClientMEdicationScriptDrugStrengths["ModifiedBy"] =
                                                ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                                            dataRowClientMEdicationScriptDrugStrengths["ModifiedDate"] = DateTime.Now;
                                            DataSetClientMedications.Tables["ClientMedicationScriptDrugStrengths"].Rows
                                                .Add(dataRowClientMEdicationScriptDrugStrengths);
                                            isScript = true;
                                        }
                                        else
                                        {
                                            DataRow[] drScriptInstructions = DataSetClientMedications
                                                .Tables["ClientMedicationScriptDrugs"].Select("ClientMedicationInstructionId=" +
                                                dtrowInstructions[index]["ClientMedicationInstructionId"]);
                                            if (drScriptInstructions.Length > 0)
                                            {
                                                drScriptInstructions[0]["ClientMedicationScriptId"] = scriptId;
                                            }
                                        }
                                    }
                                }
                                else
                                {
                                    iMedicationRowsCount = 0;
                                    iMedicationRowsCount = dsTemp.Tables["ClientMedicationsC2NonSampleORStockDrugs"].Rows.Count;
                                    GenerateScriptsTableRows('N', iMedicationRowsCount,
                                        dsTemp.Tables["ClientMedicationsC2NonSampleORStockDrugs"], NoOfRowsToBeCopied, "C2");
                                    NoOfRowsToBeCopied = NoOfRowsToBeCopied + 1;
                                    DataRow[] drScriptInstructions = DataSetClientMedications
                                        .Tables["ClientMedicationScriptDrugs"].Select("ClientMedicationInstructionId=" +
                                            dtrowInstructions[index]["ClientMedicationInstructionId"]);
                                    if (drScriptInstructions.Length > 0)
                                        drScriptInstructions[0]["ClientMedicationScriptId"] = scriptId;

                                    DataRow dataRowClientMEdicationScriptDrugStrengths = DataSetClientMedications
                                        .Tables["ClientMedicationScriptDrugStrengths"].NewRow();

                                    int id = 0;
                                    if (DataSetClientMedications.Tables["ClientMedicationScriptDrugStrengths"].Rows.Count > 0)
                                    {
                                        id = Convert.ToInt32(DataSetClientMedications
                                            .Tables["ClientMedicationScriptDrugStrengths"].Compute("Min(ClientMedicationScriptDrugStrengthId)", ""));
                                        dataRowClientMEdicationScriptDrugStrengths["ClientMedicationScriptDrugStrengthId"] = (id > 0 ? -1 : id - 1);
                                    }
                                    else
                                        dataRowClientMEdicationScriptDrugStrengths["ClientMedicationScriptDrugStrengthId"] = id;

                                    dataRowClientMEdicationScriptDrugStrengths["ClientMedicationScriptId"] = scriptId;
                                    dataRowClientMEdicationScriptDrugStrengths["ClientMedicationId"] = dtrowInstructions[index]["ClientMedicationId"];
                                    dataRowClientMEdicationScriptDrugStrengths["StrengthId"] = dtrowInstructions[index]["StrengthId"];
                                    dataRowClientMEdicationScriptDrugStrengths["Pharmacy"] = drScriptInstructions[0]["Pharmacy"];
                                    dataRowClientMEdicationScriptDrugStrengths["PharmacyText"] = drScriptInstructions[0]["PharmacyText"];
                                    dataRowClientMEdicationScriptDrugStrengths["Sample"] = drScriptInstructions[0]["Sample"];
                                    dataRowClientMEdicationScriptDrugStrengths["Stock"] = drScriptInstructions[0]["Stock"];
                                    dataRowClientMEdicationScriptDrugStrengths["Refills"] = 0;
                                    dataRowClientMEdicationScriptDrugStrengths["RowIdentifier"] = System.Guid.NewGuid();
                                    dataRowClientMEdicationScriptDrugStrengths["CreatedBy"] =
                                        ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                                    dataRowClientMEdicationScriptDrugStrengths["CreatedDate"] = DateTime.Now;
                                    dataRowClientMEdicationScriptDrugStrengths["ModifiedBy"] =
                                        ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                                    dataRowClientMEdicationScriptDrugStrengths["ModifiedDate"] = DateTime.Now;
                                    DataSetClientMedications.Tables["ClientMedicationScriptDrugStrengths"].Rows
                                        .Add(dataRowClientMEdicationScriptDrugStrengths);
                                    isScript = true;
                                }
                            }
                        }
                    }
                    #endregion

                    #region Generate OtherCategoryScripts
                    NoOfRowsToBeCopied = 0;
                    int RowsToBeCopiedincrmtcount = 3;

                    DataSet DatasetSystemConfigurationKeys = null;
                    Streamline.DataService.SharedTables objSharedTables = new Streamline.DataService.SharedTables();
                    DatasetSystemConfigurationKeys = objSharedTables.GetSystemConfigurationKeys();
                    if (objSharedTables.GetSystemConfigurationKeys("PRINTFOURPRESCRIPTIONSPERPAGE", DatasetSystemConfigurationKeys.Tables[0]).ToUpper() == "YES")
                    {
                        RowsToBeCopiedincrmtcount = 4;
                    }

                    for (int icount = 1; icount <= nOtherCategoryScriptCount; icount++)
                    {
                        iMedicationRowsCount = 0;
                        iloopCounter = 0;
                        iMedicationRowsCount = dsTemp.Tables["ClientMedicationsNCNonSampleORStockDrugs"].Rows.Count;
                        GenerateScriptsTableRows('N', iMedicationRowsCount,
                            dsTemp.Tables["ClientMedicationsNCNonSampleORStockDrugs"], NoOfRowsToBeCopied, "NC");
                        NoOfRowsToBeCopied = NoOfRowsToBeCopied + RowsToBeCopiedincrmtcount;
                    }

                    #endregion

                    #region Generate ControlledCategoryScripts
                    NoOfRowsToBeCopied = 0;
                    for (int icount = 1; icount <= nControlledScriptCount; icount++)
                    {
                        iMedicationRowsCount = 0;
                        iloopCounter = 0;
                        iMedicationRowsCount = dsTemp.Tables["ClientMedicationsControlledNonSampleORStockDrugs"].Rows.Count;
                        GenerateScriptsTableRows('N', iMedicationRowsCount,
                            dsTemp.Tables["ClientMedicationsControlledNonSampleORStockDrugs"], NoOfRowsToBeCopied, "CT");
                        NoOfRowsToBeCopied = NoOfRowsToBeCopied + 1;
                    }
                    #endregion

                    try
                    {
                        DataTable clientMedicationScriptsToRemove = DataSetClientMedications.Tables["ClientMedicationScripts"].Clone();
                        foreach (DataRow dr in DataSetClientMedications.Tables["ClientMedicationScripts"].Rows)
                        {
                            if (dr["ScriptEventType"].ToString().IsNullOrWhiteSpace())
                            {
                                if (_DrugsOrderMethod == "Change" || _DrugsOrderMethod == "CHANGE")
                                    dr["ScriptEventType"] = "C";
                                else if (_DrugsOrderMethod == "Refill" || _DrugsOrderMethod == "REFILL")
                                    dr["ScriptEventType"] = "R";

                                else if (_DrugsOrderMethod.ToUpper() == "APPROVEWITHCHANGESCHANGEORDER")
                                {
                                    dr["ScriptEventType"] = "C";
                                }
                                else if (_DrugsOrderMethod.ToUpper() == "CHANGEAPPROVALORDER")
                                {
                                    dr["ScriptEventType"] = "A";
                                }
                                else
                                    dr["ScriptEventType"] = "N";

                            }

                            if (Session["ValidChangeMedicationScript"] != null) // Added By PranayB w.r.t MU, if change order is not same send as Approvewithchanges-c
                            {
                                if (_DrugsOrderMethod.ToUpper() == "CHANGEAPPROVALORDER" && Session["ValidChangeMedicationScript"].ToString().ToUpper() == "INVALID")
                                {
                                    dr["ScriptEventType"] = "C";
                                }
                            }

                            //Vithobha Added below code to update default value of OrderingPrescriberId, OrderingPrescriberName in ClientMedicationScripts, Bear River - Environment Issues Tracking: #148 
                            if (DataSetClientMedications.Tables["ClientMedications"].Rows[0]["PrescriberId"].ToString() != DataSetClientMedications.Tables["ClientMedicationScripts"].Rows[0]["OrderingPrescriberId"].ToString())
                            {
                                DataSetClientMedications.Tables["ClientMedicationScripts"].Rows[0]["OrderingPrescriberId"] = DataSetClientMedications.Tables["ClientMedications"].Rows[0]["PrescriberId"].ToString();
                                DataSetClientMedications.Tables["ClientMedicationScripts"].Rows[0]["OrderingPrescriberName"] = DataSetClientMedications.Tables["ClientMedications"].Rows[0]["PrescriberName"].ToString();
                            }

                            clientMedicationScriptsToRemove.Rows.Add(dr.ItemArray);
                        }

                        foreach (DataRow dr in clientMedicationScriptsToRemove.Rows)
                        {
                            if (dr != null)
                            {
                                if (
                                    DataSetClientMedications.Tables["ClientMedicationScriptDrugStrengths"].Select(
                                        "ClientMedicationScriptId = " + dr["ClientMedicationScriptId"].ToString()) !=
                                    null &&
                                    DataSetClientMedications.Tables["ClientMedicationScriptDrugStrengths"].Select(
                                        "ClientMedicationScriptId = " + dr["ClientMedicationScriptId"].ToString())
                                        .Count() <=
                                    0)
                                {
                                    if (
                                        DataSetClientMedications.Tables["ClientMedicationScriptDrugStrengths"].Select(
                                            "ClientMedicationScriptId='" + dr["ClientMedicationScriptId"].ToString() +
                                            "'").Count() <= 0)
                                    {
                                        DataSetClientMedications.Tables["ClientMedicationScripts"].Select(
                                            "ClientMedicationScriptId='" + dr["ClientMedicationScriptId"].ToString() +
                                            "'")[0].Delete();
                                    }
                                }
                            }
                        }

                        if (DataSetClientMedications.Tables["ClientMedications"].Rows.Count > 0)
                        {
                            foreach (var x in DataSetClientMedications.Tables["ClientMedications"].Select("TitrationType='T'"))
                            {
                                foreach (var y in DataSetClientMedications.Tables["ClientMedicationInstructions"].Select("ClientMedicationId='" + x["ClientMedicationId"] + "'"))
                                {
                                    foreach (var z in DataSetClientMedications.Tables["ClientMedicationScriptDrugs"].Select("ClientMedicationInstructionId='" + y["ClientMedicationInstructionId"] + "'"))
                                    {
                                        foreach (var dr in DataSetClientMedications.Tables["ClientMedicationScripts"].Select("ClientMedicationScriptId='" + z["ClientMedicationScriptId"] + "'"))
                                        {
                                            if (dr["OrderingMethod"].ToString() == "E")
                                            {
                                                dr.BeginEdit();
                                                dr["OrderingMethod"] = "F";
                                                dr["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                                                dr["ModifiedDate"] = DateTime.Now;
                                                dr.EndEdit();
                                            }
                                        }
                                    }
                                }
                            }
                            //Vithobha added below code for CEI - Support Go Live: #476.032
                            if (_DrugsOrderMethod.ToUpper() == "REFILL" && DataSetClientMedications.Tables["ClientMedications"].Rows[0]["TitrationType"] != null)
                                DataSetClientMedications.Tables["ClientMedications"].Rows[0]["TitrationType"] = null;
                        }
                    }
                    catch (Exception exp)
                    {
                    }

                    for (int i = 0; i < DataSetClientMedications.Tables["ClientMedications"].Rows.Count; i++)
                    {
                        string _drugCategoryFromClientMedications = Convert.ToString(DataSetClientMedications.Tables["ClientMedications"].Rows[i]["DrugCategory"]);
                        if ((_drugCategoryFromClientMedications != "2" && _drugCategoryFromClientMedications != "3" && _drugCategoryFromClientMedications != "4" && _drugCategoryFromClientMedications != "5") || OrderingMethod == 'E')
                        {
                            DataTableSureScriptsOutgoingMessages = DataSetClientMedications.Tables["SureScriptsOutgoingMessages"];
                            DataRow[] dataRowClientMedicationScriptDrugStrengths =
                                DataSetClientMedications.Tables["ClientMedicationScriptDrugStrengths"]
                                    .Select("ClientMedicationId=" + DataSetClientMedications.Tables["ClientMedications"].Rows[i]["ClientMedicationId"]);
                            if (dataRowClientMedicationScriptDrugStrengths.Length > 1)
                            {
                                foreach (DataRow dr in dataRowClientMedicationScriptDrugStrengths)
                                {
                                    if (_Queue == false)
                                    {
                                        DataRowSureScriptsOutgoingMessages =
                                            DataTableSureScriptsOutgoingMessages.NewRow();
                                        DataRowSureScriptsOutgoingMessages["ClientMedicationScriptId"] =
                                            dr["ClientMedicationScriptId"];
                                        DataRowSureScriptsOutgoingMessages["MessageStatus"] = 5541;
                                        DataRowSureScriptsOutgoingMessages["RowIdentifier"] = System.Guid.NewGuid();
                                        DataRowSureScriptsOutgoingMessages["CreatedBy"] =
                                            ((Streamline.BaseLayer.StreamlineIdentity) Context.User.Identity).UserCode;
                                        DataRowSureScriptsOutgoingMessages["CreatedDate"] = DateTime.Now;
                                        DataRowSureScriptsOutgoingMessages["ModifiedBy"] =
                                            ((Streamline.BaseLayer.StreamlineIdentity) Context.User.Identity).UserCode;
                                        DataRowSureScriptsOutgoingMessages["ModifiedDate"] = DateTime.Now;
                                        DataTableSureScriptsOutgoingMessages.Rows.Add(DataRowSureScriptsOutgoingMessages);
                                    }
                                }
                            }
                            else
                            {
                                foreach (DataRow dr in dataRowClientMedicationScriptDrugStrengths)
                                {
                                    DataRow[] dataRowClientMedicationInstructions =
                                        DataSetClientMedications.Tables["ClientMedicationInstructions"]
                                            .Select("ClientMedicationId=" + dr["ClientMedicationId"] + "and StrengthId=" +
                                                    dr["StrengthId"]);
                                    foreach (DataRow dataRow in dataRowClientMedicationInstructions)
                                    {
                                        DataRow[] dataRowClientMedicationScriptDrugs =
                                            DataSetClientMedications.Tables["ClientMedicationScriptDrugs"]
                                                .Select("ClientMedicationInstructionId=" +
                                                        dataRow["ClientMedicationInstructionId"]);
                                        foreach (DataRow dtRow in dataRowClientMedicationScriptDrugs)
                                        {
                                            dtRow["ClientMedicationScriptId"] = dr["ClientMedicationScriptId"];
                                            if (_Queue == false)
                                            {
                                                DataRowSureScriptsOutgoingMessages =
                                                    DataTableSureScriptsOutgoingMessages.NewRow();
                                                DataRowSureScriptsOutgoingMessages["ClientMedicationScriptId"] =
                                                    dr["ClientMedicationScriptId"];
                                                DataRowSureScriptsOutgoingMessages["MessageStatus"] = 5541;
                                                DataRowSureScriptsOutgoingMessages["RowIdentifier"] =
                                                    System.Guid.NewGuid();
                                                DataRowSureScriptsOutgoingMessages["CreatedBy"] =
                                                    ((Streamline.BaseLayer.StreamlineIdentity) Context.User.Identity)
                                                        .UserCode;
                                                DataRowSureScriptsOutgoingMessages["CreatedDate"] = DateTime.Now;
                                                DataRowSureScriptsOutgoingMessages["ModifiedBy"] =
                                                    ((Streamline.BaseLayer.StreamlineIdentity) Context.User.Identity)
                                                        .UserCode;
                                                DataRowSureScriptsOutgoingMessages["ModifiedDate"] = DateTime.Now;
                                                DataTableSureScriptsOutgoingMessages.Rows.Add(
                                                    DataRowSureScriptsOutgoingMessages);
                                            }
                                        }
                                    }
                                }
                            }
                            DataSetClientMedications.Merge(DataTableSureScriptsOutgoingMessages);
                        }
                    }

                    DataSetTemp = new DataSet();
                    if (((HiddenField)Parent.FindControl("HiddenFieldRedirectFrom")).Value.ToUpper() == "DASHBOARD")
                    {
                        DataRow[] dataRowSureScriptRefillRequests = null;
                        if (((HiddenField)Parent.FindControl("HiddenFieldSureScriptRefillRequestId")).Value != "")
                        {
                            dataRowSureScriptRefillRequests = DataSetClientMedications
                                .Tables["SureScriptsRefillRequests"].Select("SureScriptsRefillRequestId=" +
                                    Convert.ToInt32(((HiddenField)Parent.FindControl("HiddenFieldSureScriptRefillRequestId")).Value));
                            //Added By priya Reg:Task no:3274 2.7 Surescripts Refill Requests for Schedule II-V Medications
                            if (dataRowSureScriptRefillRequests.Length > 0)
                            {
                                int _DrugCategory = Convert.ToInt32(dataRowSureScriptRefillRequests[0]["DrugCategory"].ToString());
                                if (_DrugCategory == 3 || _DrugCategory == 4 || _DrugCategory == 5)
                                {
                                    if ((((HiddenField)Parent.FindControl("HiddenFieldClickedImage")).Value.ToUpper() == "APPROVED") ||
                                        (((HiddenField)Parent.FindControl("HiddenFieldClickedImage")).Value.ToUpper() == "APPROVEDWITHCHANGES") ||
                                        (((HiddenField)Parent.FindControl("HiddenFieldClickedImage")).Value.ToUpper() == "DENIEDNEWPRESCRIPTIONS"))
                                    {
                                        dataRowSureScriptRefillRequests[0]["StatusOfRequest"] = "N";
                                        // insert record into refill denied
                                        using (var surescriptsRefillRequest = new SureScriptRefillRequest())
                                        {
                                            var denyMessageId = "RF_DenyNew_" + DateTime.UtcNow.Ticks.ToString();
                                            surescriptsRefillRequest.DenySureScriptsRefillRequestsWithNewRx(
                                                Convert.ToInt32(
                                                    dataRowSureScriptRefillRequests[0]["SureScriptsRefillRequestId"].ToString()),
                                                    0, "Prescriber system cannot transmit approved controlled e prescription",
                                                    ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode, denyMessageId);
                                        }
                                    }
                                }
                                else
                                {
                                    if (((HiddenField)Parent.FindControl("HiddenFieldClickedImage")).Value.ToUpper() ==
                                            "APPROVED" && dataRowSureScriptRefillRequests.Length > 0)
                                        dataRowSureScriptRefillRequests[0]["StatusOfRequest"] = "A";
                                    if (((HiddenField)Parent.FindControl("HiddenFieldClickedImage")).Value.ToUpper() ==
                                            "APPROVEDWITHCHANGES" && dataRowSureScriptRefillRequests.Length > 0)
                                        dataRowSureScriptRefillRequests[0]["StatusOfRequest"] = "C";
                                    if (((HiddenField)Parent.FindControl("HiddenFieldClickedImage")).Value.ToUpper() ==
                                            "DENIEDNEWPRESCRIPTIONS" && dataRowSureScriptRefillRequests.Length > 0)
                                        dataRowSureScriptRefillRequests[0]["StatusOfRequest"] = "N";
                                }
                            }
                        }
                    }
                    //Below code was added by Vithobha for EPCS: #2 04.A1-Logical Controls of Prescription
                    if (Session["ePrescription"] != null && Session["ePrescription"].ToString() == "True")
                    {
                        string ControlledSubstanceCheckedvalues = HiddenFieldControlledSubstancesList.Value;
                        string[] ControlledSubstancelist = ControlledSubstanceCheckedvalues.Split(',');
                        int ClientMedicationScriptId;
                        ElectronicScriptMappingIds = (System.Collections.Generic.Dictionary<string, string>)(Session["ElectronicScriptTempIds"]);
                        for (int i = 0; i < (ControlledSubstancelist.Length - 1); i++)
                        {
                            foreach (KeyValuePair<string, string> ESI in ElectronicScriptMappingIds)
                            {
                                if (ESI.Key == ControlledSubstancelist[i])
                                {
                                    ClientMedicationScriptId = Convert.ToInt32(ESI.Value);
                                    DataRow[] drClientMedicationScriptDrugStrengths = DataSetClientMedications.Tables["ClientMedicationScriptDrugStrengths"].Select("ClientMedicationScriptId=" + ClientMedicationScriptId + "");
                                    drClientMedicationScriptDrugStrengths[0]["ReadyToSign"] = "Y";
                                }
                            }
                        }
                        List<string> newidstoremove = new List<string>();
                        List<string> newChangedOrderMedicationIds = new List<string>();
                        List<string> clientmedicationidtoexclude = new List<string>();
                        string[] ControlledMedicationScripds = { };
                        if (Session["ChangedOrderMedicationIds"] != null)
                        {
                            ControlledMedicationScripds = Session["ChangedOrderMedicationIds"].ToString().Split(',');
                        }
                        if (Session["ControlledMedicationScriptIds"] != null)
                        {
                            string[] ControlledMedicationScriptIds = Session["ControlledMedicationScriptIds"].ToString().Replace(" ", "").Split(',');
                            if (ControlledMedicationScriptIds.Length >= (ControlledSubstancelist.Length - 1))
                            {
                                newidstoremove = ControlledMedicationScriptIds.Except(ControlledSubstancelist).ToList();
                            }
                        }
                    
                        if (clientmedicationidtoexclude.Count > 0)
                        {
                            newChangedOrderMedicationIds = ControlledMedicationScripds.Except(clientmedicationidtoexclude).ToList();
                            string newChangedMedicationIds = String.Join(",", newChangedOrderMedicationIds.ToArray());
                            Session["ChangedOrderMedicationIds"] = newChangedMedicationIds;
                        }
                    }
                         
                     int prescriberid = 0;
                            if (Convert.ToString( DataSetClientMedications.Tables["ClientMedications"].Rows[0]["PrescriberId"]) != null &&
                                Convert.ToString( DataSetClientMedications.Tables["ClientMedications"].Rows[0]["PrescriberId"]) != "")
                            {
                                prescriberid = Convert.ToInt32( DataSetClientMedications.Tables["ClientMedications"].Rows[0]["PrescriberId"].ToString());
                            }
                            ProcessScripts(0, prescriberid, OrderingMethod, DataSetClientMedications);

                    DataSetTemp = ObjectClientMedication.UpdateDocuments(DataSetClientMedications);
                    DataTable dataTableClientMedicationScripts = DataSetTemp.Tables["ClientMedicationScripts"].Clone();
                    dataTableClientMedicationScripts.Merge(DataSetTemp.Tables["ClientMedicationScripts"]);
					DataTable dt = DataSetTemp.Tables["ClientMedications"];
                    DataView view = new DataView(dt);
                    DataTable ClientMedications = view.ToTable("ClientMedications", false, "ClientMedicationId");
                    ObjectClientMedication.PostClientMedicationsPrescribe(ClientMedications);  
                    ObjectClientMedication = null;

                    #region UpdateClientScriptActivities
                    //Following code will be used to update ClientScriptActivities table
                    DataSetClientScriptActivities = new Streamline.UserBusinessServices.DataSets.DataSetClientScripts();
                    ObjectClientMedication = new ClientMedication();
                    HiddenFieldAllFaxed.Value = "1";
                    //Send Fax if ordering Method is Fax
                    bool FlagForImagesDeletion = false;
                    //checking that queue order button ic clicked
                    string Printfourprescriptionsperpage = "N";
                    string[] ClientMedicationScriptdrugidarray = new string[100];
                    if (_Queue == false)
                    {
                        DataSet DatasetSystemConfigKeys = null;
                        Streamline.DataService.SharedTables objtectSharedTables = new Streamline.DataService.SharedTables();
                        DatasetSystemConfigKeys = objtectSharedTables.GetSystemConfigurationKeys();
                        if (objtectSharedTables.GetSystemConfigurationKeys("PRINTFOURPRESCRIPTIONSPERPAGE", DatasetSystemConfigKeys.Tables[0]).ToUpper() == "YES")
                        {
                            Printfourprescriptionsperpage = "Y";
                        }

                        if (Printfourprescriptionsperpage == "Y")
                        {

                            DataTable DtClientMedicationScriptdrugstrengths = new DataTable();
                            DtClientMedicationScriptdrugstrengths = DataSetTemp.Tables["ClientMedicationScriptdrugstrengths"];

                            string DrugCategory2check = "DrugCategory = '2'";
                            DataRow[] DrugCategory2Rowsfound = DataSetTemp.Tables["ClientMedicationScriptdrugs"].Select(DrugCategory2check);

                            if (DrugCategory2Rowsfound.Length > 1)
                            {
                                DataTable ClientMedicationScriptdrugsfiltered = DataSetTemp.Tables["ClientMedicationScriptdrugs"].AsEnumerable()
                                 .Where(r => r.Field<string>("DrugCategory") == "2")
                                 .CopyToDataTable();


                                var JoinResult = (from p in DtClientMedicationScriptdrugstrengths.AsEnumerable()
                                                  join t in ClientMedicationScriptdrugsfiltered.AsEnumerable()
                                                  on p.Field<int>("ClientMedicationScriptid") equals t.Field<int>("ClientMedicationScriptid")
                                                  select new
                                                  {
                                                      Clientmedicationid = p.Field<int>("Clientmedicationid")
                                                  }).Distinct().ToList();

                                string Clientmedicationid = "";
                                DataTable Dt = new DataTable();
                                DataView dv = new DataView();
                                int dvcount = 0;
                                int m = 0;

                                for (var i = 0; i < JoinResult.Count; i++)
                                {
                                    Clientmedicationid = JoinResult[i].Clientmedicationid.ToString();
                                    dv = new DataView(DtClientMedicationScriptdrugstrengths);
                                    dv.RowFilter = "ClientMedicationid =" + Clientmedicationid;
                                    dvcount = dv.Count;

                                    if (dvcount >= 1)
                                    {
                                        foreach (DataRowView rowView in dv)
                                        {
                                            DataRow row = rowView.Row;
                                            ClientMedicationScriptdrugidarray[m] = row.ItemArray[1].ToString();
                                            m++;
                                        }
                                    }

                                    ClientMedicationScriptdrugidarray[m - 1] = null;
                                    m--;
                                }
                            }
                        }


                        for (int icount = 0;
                                                    icount < DataSetTemp.Tables["ClientMedicationScripts"].Rows.Count;
                                                    icount++)
                        {
                            OrderingMethod = Convert.ToChar(
                                        DataSetTemp.Tables["ClientMedicationScripts"].Rows[icount]["OrderingMethod"]
                                            .ToString());


                            if (OrderingMethod == 'F')
                            {
                                #region Sending Fax

                                Streamline.UserBusinessServices.SharedTables objectSharedTables = null;
                                objectSharedTables = new Streamline.UserBusinessServices.SharedTables();
                                OriginalOrderingMethod = OrderingMethod;

                                DataSetPharmacies =
                                    objectSharedTables.getPharmacies(
                                        ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId);
                                drPharmacies = DataSetPharmacies.Tables[0].Select("LEN(FaxNumber) >= 7", "PharmacyName asc");
                                DataSet DataSetEditPharmacies = new DataSet();
                                DataSetEditPharmacies.Merge(drPharmacies);

                                if (DataSetClientMedications.Tables["ClientMedicationScripts"].Rows[0]["PharmacyId"] !=
                                    System.DBNull.Value)
                                    drSelectedPharmacy = DataSetEditPharmacies.Tables[0].Select("PharmacyId=" +
                                                                                                DataSetClientMedications
                                                                                                    .Tables[
                                                                                                        "ClientMedicationScripts"
                                                                                                    ].Rows[0]["PharmacyId"]);
                                else if (((HiddenField)(Parent.FindControl("HiddenFieldPharmacyId"))).Value != "")
                                    drSelectedPharmacy = DataSetEditPharmacies.Tables[0].Select("PharmacyId=" +
                                                                                                ((HiddenField)
                                                                                                    (Parent.FindControl(
                                                                                                        "HiddenFieldPharmacyId")))
                                                                                                    .Value);

                                if (drSelectedPharmacy != null && drSelectedPharmacy.Length > 0)
                                {
                                    strReceipeintName = drSelectedPharmacy[0]["PharmacyName"].ToString();
                                    strReceipentOrganisation = drSelectedPharmacy[0]["PharmacyName"].ToString();
                                    strReceipentFaxNumber = drSelectedPharmacy[0]["FaxNumber"].ToString();

                                }
                                else if (((HiddenField)(Parent.FindControl("HiddenFieldPharmacyFaxNo"))).Value != "")
                                {
                                    HiddenField _pharmacyFaxNo =
                                        ((HiddenField)(Parent.FindControl("HiddenFieldPharmacyFaxNo")));
                                    string pharmacyFaxNo = _pharmacyFaxNo.Value.ToString();
                                    strReceipentFaxNumber = pharmacyFaxNo;
                                }

                                //for (int icount = 0;
                                //    icount < DataSetTemp.Tables["ClientMedicationScripts"].Rows.Count;
                                //    icount++)
                                //{
                                char _OrderingMethod = Convert.ToChar(DataSetTemp
                                    .Tables["ClientMedicationScripts"].Rows[icount]["OrderingMethod"].ToString());

                                if (icount == 0)
                                    FlagForImagesDeletion = true;
                                else
                                    FlagForImagesDeletion = false;
                                _strScriptsTobeFaxedButPrinted = false;
                                string strSelectClause = "ClientMedicationScriptId=" +
                                                         DataSetTemp.Tables["ClientMedicationScripts"].Rows[icount][
                                                             "ClientMedicationScriptId"].ToString();
                                string faxableSchedulesList =
                                    System.Configuration.ConfigurationSettings.AppSettings["FaxScheduledCategoryList"];
                                if (!faxableSchedulesList.IsNullOrWhiteSpace())
                                {
                                    strSelectClause += " and ISNULL(DrugCategory,0) not in (0," + faxableSchedulesList +
                                                       ")";
                                }
                                else
                                {
                                    strSelectClause += " and ISNULL(DrugCategory,0)>=2";

                                }

                                if (DataSetTemp.Tables["ClientMedicationScriptDrugs"].Select(strSelectClause).Length > 0)
                                {
                                    _strScriptsTobeFaxedButPrinted = true;
                                    OrderingMethod = _OrderingMethod = 'P';
                                    HiddenFieldAllFaxed.Value = "0";
                                }
                                else
                                {
                                    foreach (
                                        DataRow drScriptDrugs in
                                            DataSetTemp.Tables["ClientMedicationScriptDrugs"].Select(
                                                "ClientMedicationScriptId=" +
                                                DataSetTemp.Tables["ClientMedicationScripts"].Rows[icount][
                                                    "ClientMedicationScriptId"].ToString()))
                                    {
                                        foreach (
                                            DataRow drInstructions in
                                                DataSetTemp.Tables["ClientMedicationInstructions"].Select(
                                                    "ClientMedicationInstructionId=" +
                                                    drScriptDrugs["ClientMedicationInstructionId"].ToString()))
                                        {
                                            foreach (
                                                DataRow drMedication in
                                                    DataSetTemp.Tables["ClientMedications"].Select(
                                                        "ClientMedicationId=" +
                                                        drInstructions["ClientMedicationId"].ToString()))
                                            {
                                                if (
                                                    ObjectClientMedication.CheckForDrugCategory2(
                                                        Convert.ToInt32(drMedication["MedicationNameId"].ToString())) ==
                                                    true)
                                                {
                                                    _strScriptsTobeFaxedButPrinted = true;
                                                    OrderingMethod = _OrderingMethod = 'P';
                                                    HiddenFieldAllFaxed.Value = "0";

                                                    break;
                                                }
                                            }
                                        }
                                    }
                                }

                                //If Non controlled Drugs
                                if (_strScriptsTobeFaxedButPrinted)
                                {
                                    #region--Code Added by Pradeep on 14 March 2011 as per task#3336

                                    if (((HiddenField)Parent.FindControl("HiddenFieldRedirectFrom")).Value.ToUpper() ==
                                        "DASHBOARD")
                                    {
                                        if (
                                            (((HiddenField)Parent.FindControl("HiddenFieldClickedImage")).Value.ToUpper
                                                () == "APPROVED"))
                                        {
                                            bool ans = SendToPrinter(Convert.ToInt32(DataSetTemp
                                                .Tables["ClientMedicationScripts"].Rows[icount][
                                                    "ClientMedicationScriptId"]),
                                                FlagForImagesDeletion, strSendCoverLetter, "A", _OrderingMethod);
                                        }
                                        else if (
                                            (((HiddenField)Parent.FindControl("HiddenFieldClickedImage")).Value
                                                .ToUpper() == "APPROVEDWITHCHANGES"))
                                        {
                                            bool ans = SendToPrinter(Convert.ToInt32(DataSetTemp
                                                .Tables["ClientMedicationScripts"].Rows[icount][
                                                    "ClientMedicationScriptId"]),
                                                FlagForImagesDeletion, strSendCoverLetter, "C", _OrderingMethod);
                                        }
                                        else if (
                                            (((HiddenField)Parent.FindControl("HiddenFieldClickedImage")).Value
                                                .ToUpper() == "DENIEDNEWPRESCRIPTIONS"))
                                        {
                                            bool ans = SendToPrinter(Convert.ToInt32(DataSetTemp
                                                .Tables["ClientMedicationScripts"].Rows[icount][
                                                    "ClientMedicationScriptId"]),
                                                FlagForImagesDeletion, strSendCoverLetter, "N", _OrderingMethod);
                                        }
                                        else
                                        {
                                            bool ans = SendToPrinter(Convert.ToInt32(DataSetTemp
                                                .Tables["ClientMedicationScripts"].Rows[icount][
                                                    "ClientMedicationScriptId"]),
                                                FlagForImagesDeletion, strSendCoverLetter, "D", _OrderingMethod);
                                        }
                                    }
                                    else
                                    {
                                        bool ans = SendToPrinter(Convert.ToInt32(DataSetTemp
                                            .Tables["ClientMedicationScripts"].Rows[icount]["ClientMedicationScriptId"]),
                                            FlagForImagesDeletion, strSendCoverLetter, string.Empty, _OrderingMethod);
                                    }

                                    #endregion
                                }
                                //If Controlled Drugs
                                else
                                {
                                    if (_DrugsOrderMethod.ToUpper() != "ADJUST")
                                    {
                                        #region--Code Added by Pradeep as per task#3336

                                        bool ans1 = false;
                                        if (
                                            ((HiddenField)Parent.FindControl("HiddenFieldRedirectFrom")).Value.ToUpper() ==
                                            "DASHBOARD")
                                        {
                                            if (
                                                (((HiddenField)Parent.FindControl("HiddenFieldClickedImage")).Value
                                                    .ToUpper() == "APPROVED"))
                                            {
                                                ans1 = SendToFax(Convert.ToInt32(DataSetTemp
                                                    .Tables["ClientMedicationScripts"].Rows[icount][
                                                        "ClientMedicationScriptId"]),
                                                    Convert.ToInt32(
                                                        DataSetClientMedications.Tables["ClientMedicationScripts"]
                                                            .Rows[0]["PharmacyId"]), FlagForImagesDeletion,
                                                    strSendCoverLetter, "A");
                                            }
                                            else if (
                                                (((HiddenField)Parent.FindControl("HiddenFieldClickedImage")).Value
                                                    .ToUpper() == "APPROVEDWITHCHANGES"))
                                            {
                                                ans1 = SendToFax(Convert.ToInt32(DataSetTemp
                                                    .Tables["ClientMedicationScripts"].Rows[icount][
                                                        "ClientMedicationScriptId"]),
                                                    Convert.ToInt32(
                                                        DataSetClientMedications.Tables["ClientMedicationScripts"]
                                                            .Rows[0]["PharmacyId"]), FlagForImagesDeletion,
                                                    strSendCoverLetter, "C");
                                            }
                                            else if (
                                                (((HiddenField)Parent.FindControl("HiddenFieldClickedImage"))
                                                    .Value.ToUpper() == "DENIEDNEWPRESCRIPTIONS"))
                                            {
                                                ans1 = SendToFax(Convert.ToInt32(DataSetTemp
                                                    .Tables["ClientMedicationScripts"].Rows[icount][
                                                        "ClientMedicationScriptId"]),
                                                    Convert.ToInt32(
                                                        DataSetClientMedications.Tables[
                                                            "ClientMedicationScripts"]
                                                            .Rows[0]["PharmacyId"]), FlagForImagesDeletion,
                                                    strSendCoverLetter, "N");
                                            }
                                            else
                                            {
                                                ans1 = SendToFax(Convert.ToInt32(DataSetTemp
                                                    .Tables["ClientMedicationScripts"].Rows[icount][
                                                        "ClientMedicationScriptId"]),
                                                    Convert.ToInt32(
                                                        DataSetClientMedications.Tables[
                                                            "ClientMedicationScripts"]
                                                            .Rows[0]["PharmacyId"]), FlagForImagesDeletion,
                                                    strSendCoverLetter, "D");
                                            }

                                        }
                                        else
                                        {
                                            ans1 = SendToFax(Convert.ToInt32(DataSetTemp
                                                .Tables["ClientMedicationScripts"].Rows[icount][
                                                    "ClientMedicationScriptId"]),
                                                Convert.ToInt32(
                                                    DataSetClientMedications.Tables["ClientMedicationScripts"]
                                                        .Rows[0]["PharmacyId"]), FlagForImagesDeletion,
                                                strSendCoverLetter, string.Empty);
                                        }

                                        #endregion

                                        if (_strPrintChartCopy == "true" && ans1 == true)
                                        {
                                            if (
                                                ((HiddenField)Parent.FindControl("HiddenFieldRedirectFrom")).Value
                                                    .ToUpper() == "DASHBOARD")
                                            {
                                                if (
                                                    (((HiddenField)Parent.FindControl("HiddenFieldClickedImage")).Value
                                                        .ToUpper() == "APPROVED"))
                                                {
                                                    PrintChartCopy(
                                                        Convert.ToInt32(DataSetTemp.Tables["ClientMedicationScripts"]
                                                            .Rows[icount]["ClientMedicationScriptId"]),
                                                        strSendCoverLetter, "A");
                                                }
                                                else if (
                                                    (((HiddenField)Parent.FindControl("HiddenFieldClickedImage"))
                                                        .Value.ToUpper() == "APPROVEDWITHCHANGES"))
                                                {
                                                    PrintChartCopy(
                                                        Convert.ToInt32(
                                                            DataSetTemp.Tables["ClientMedicationScripts"]
                                                                .Rows[icount]["ClientMedicationScriptId"]),
                                                        strSendCoverLetter, "C");
                                                }
                                                else if (
                                                    (((HiddenField)
                                                        Parent.FindControl("HiddenFieldClickedImage")).Value
                                                        .ToUpper() == "DENIEDNEWPRESCRIPTIONS"))
                                                {
                                                    PrintChartCopy(
                                                        Convert.ToInt32(
                                                            DataSetTemp.Tables["ClientMedicationScripts"]
                                                                .Rows[icount]["ClientMedicationScriptId"]),
                                                        strSendCoverLetter, "C");
                                                }
                                                else
                                                {
                                                    PrintChartCopy(
                                                        Convert.ToInt32(
                                                            DataSetTemp.Tables["ClientMedicationScripts"]
                                                                .Rows[icount]["ClientMedicationScriptId"]),
                                                        strSendCoverLetter, "D");
                                                }

                                            }
                                            else
                                            {
                                                PrintChartCopy(
                                                    Convert.ToInt32(DataSetTemp.Tables["ClientMedicationScripts"]
                                                        .Rows[icount]["ClientMedicationScriptId"]), strSendCoverLetter,
                                                    string.Empty);
                                            }
                                        } //Faxing Check for Service Status If Sending Fax failed 
                                        else if (ans1 == false) //If Sending Fax failed
                                        {
                                            if (
                                                ((HiddenField)Parent.FindControl("HiddenFieldRedirectFrom")).Value
                                                    .ToUpper() == "DASHBOARD")
                                            {
                                                if (
                                                    (((HiddenField)Parent.FindControl("HiddenFieldClickedImage")).Value
                                                        .ToUpper() == "APPROVED"))
                                                {
                                                    PrintPrescription(
                                                        Convert.ToInt32(DataSetTemp.Tables["ClientMedicationScripts"]
                                                            .Rows[icount]["ClientMedicationScriptId"]),
                                                        strSendCoverLetter, "A");
                                                }
                                                else if (
                                                    (((HiddenField)Parent.FindControl("HiddenFieldClickedImage"))
                                                        .Value.ToUpper() == "APPROVEDWITHCHANGES"))
                                                {
                                                    PrintPrescription(
                                                        Convert.ToInt32(
                                                            DataSetTemp.Tables["ClientMedicationScripts"]
                                                                .Rows[icount]["ClientMedicationScriptId"]),
                                                        strSendCoverLetter, "C");
                                                }
                                                else if (
                                                    (((HiddenField)
                                                        Parent.FindControl("HiddenFieldClickedImage")).Value
                                                        .ToUpper() == "DENIEDNEWPRESCRIPTIONS"))
                                                {
                                                    PrintPrescription(
                                                        Convert.ToInt32(
                                                            DataSetTemp.Tables["ClientMedicationScripts"]
                                                                .Rows[icount]["ClientMedicationScriptId"]),
                                                        strSendCoverLetter, "N");
                                                }
                                                else
                                                {
                                                    PrintPrescription(
                                                        Convert.ToInt32(
                                                            DataSetTemp.Tables["ClientMedicationScripts"]
                                                                .Rows[icount]["ClientMedicationScriptId"]),
                                                        strSendCoverLetter, "D");
                                                }
                                            }
                                            else
                                            {
                                                PrintPrescription(
                                                    Convert.ToInt32(DataSetTemp.Tables["ClientMedicationScripts"]
                                                        .Rows[icount]["ClientMedicationScriptId"]), strSendCoverLetter,
                                                    string.Empty);
                                            }
                                        }
                                    }
                                }

                                if (strSendCoverLetter == "true")
                                {
                                    DataRow[] drPharmacy = DataSetClientScriptActivities.Tables["Pharmacies"]
                                        .Select("PharmacyId=" + drSelectedPharmacy[0]["PharmacyId"]);

                                    if (drPharmacy[0]["NumberOfTimesFaxed"] == System.DBNull.Value)
                                        drPharmacy[0]["NumberOfTimesFaxed"] = 0;

                                    NumberOfTimesFaxSend = Convert.ToInt32(drPharmacy[0]["NumberOfTimesFaxed"]);
                                    NumberOfTimesFaxSend += 1;
                                    drPharmacy[0]["NumberOfTimesFaxed"] = NumberOfTimesFaxSend;
                                }
                                //}

                                DataSetTempMeds =
                                    ObjectClientMedication.UpdateClientScriptActivities(DataSetClientScriptActivities);

                                #endregion
                            }
                            else if (OrderingMethod == 'P')
                            {
                                #region Sending Results to printer

                                char _OrderingMethod =
                                    Convert.ToChar(
                                        DataSetTemp.Tables["ClientMedicationScripts"].Rows[icount]["OrderingMethod"]
                                            .ToString());
                                if (icount == 0)
                                {
                                    FlagForImagesDeletion = true;
                                }
                                else
                                {
                                    FlagForImagesDeletion = false;
                                }

                                if (((HiddenField)Parent.FindControl("HiddenFieldRedirectFrom")).Value.ToUpper() ==
                                    "DASHBOARD")
                                {
                                    if (
                                        (((HiddenField)Parent.FindControl("HiddenFieldClickedImage")).Value.ToUpper() ==
                                         "APPROVED"))
                                    {
                                        bool ans =
                                            SendToPrinter(Convert.ToInt32(DataSetTemp.Tables["ClientMedicationScripts"]
                                                .Rows[icount]["ClientMedicationScriptId"]), FlagForImagesDeletion,
                                                strSendCoverLetter, "A", _OrderingMethod);
                                    }
                                    else if (
                                        (((HiddenField)Parent.FindControl("HiddenFieldClickedImage")).Value.ToUpper
                                            () == "APPROVEDWITHCHANGES"))
                                    {
                                        bool ans =
                                            SendToPrinter(
                                                Convert.ToInt32(DataSetTemp.Tables["ClientMedicationScripts"]
                                                    .Rows[icount]["ClientMedicationScriptId"]),
                                                FlagForImagesDeletion, strSendCoverLetter, "C", _OrderingMethod);
                                    }
                                    else if (
                                        (((HiddenField)Parent.FindControl("HiddenFieldClickedImage")).Value
                                            .ToUpper() == "DENIEDNEWPRESCRIPTIONS"))
                                    {
                                        bool ans =
                                            SendToPrinter(
                                                Convert.ToInt32(DataSetTemp.Tables["ClientMedicationScripts"]
                                                    .Rows[icount]["ClientMedicationScriptId"]),
                                                FlagForImagesDeletion, strSendCoverLetter, "N", _OrderingMethod);
                                    }
                                    else
                                    {
                                        bool ans =
                                            SendToPrinter(
                                                Convert.ToInt32(DataSetTemp.Tables["ClientMedicationScripts"]
                                                    .Rows[icount]["ClientMedicationScriptId"]),
                                                FlagForImagesDeletion, strSendCoverLetter, "D", _OrderingMethod);
                                    }
                                }
                                else
                                {
                                    if (Printfourprescriptionsperpage == "Y" && ClientMedicationScriptdrugidarray.Length > 0)
                                    {
                                        String Clientmedscriptid = DataSetTemp.Tables["ClientMedicationScripts"].Rows[icount]["ClientMedicationScriptId"].ToString();
                                        if (ClientMedicationScriptdrugidarray.Contains(Clientmedscriptid) == false)
                                        {
                                            bool ans =
                                        SendToPrinter(Convert.ToInt32(DataSetTemp.Tables["ClientMedicationScripts"]
                                            .Rows[icount]["ClientMedicationScriptId"]), FlagForImagesDeletion,
                                            strSendCoverLetter, string.Empty, _OrderingMethod);
                                        }

                                    }
                                    else
                                    {
                                        bool ans =
                                            SendToPrinter(Convert.ToInt32(DataSetTemp.Tables["ClientMedicationScripts"]
                                                .Rows[icount]["ClientMedicationScriptId"]), FlagForImagesDeletion,
                                                strSendCoverLetter, string.Empty, _OrderingMethod);
                                    }
                                    if (OrderingMethod != 'P')
                                    {
                                        HiddenFieldAllFaxed.Value = "0";
                                    }
                                }

                                DataSetTempMeds =
                                    ObjectClientMedication.UpdateClientScriptActivities(DataSetClientScriptActivities);

                                #endregion
                            }
                            else if (OrderingMethod == 'E')
                            {
                                //for (int icount = 0;
                                //    icount < DataSetTemp.Tables["ClientMedicationScripts"].Rows.Count;
                                //    icount++)  //Pranay
                                if (_strPrintChartCopy == "true")
                                {

                                    bool ans =
                                            SendToPrinter(Convert.ToInt32(DataSetTemp.Tables["ClientMedicationScripts"]
                                                .Rows[icount]["ClientMedicationScriptId"]), FlagForImagesDeletion,
                                                strSendCoverLetter, string.Empty, OrderingMethod);
                                }
                                //{
                                char _OrderingMethod =
                                    Convert.ToChar(
                                        DataSetTemp.Tables["ClientMedicationScripts"].Rows[icount]["OrderingMethod"]
                                            .ToString());
                                FlagForImagesDeletion = icount == 0 ? true : false;

                                #region Check if "FaxScheduledCategoryList" is set in Web.config
                                string strSelectClause = string.Empty;
                                bool ScheduledButCanBeFaxed = false;
                                string faxableSchedulesList =
                                    System.Configuration.ConfigurationSettings.AppSettings["FaxScheduledCategoryList"];
                                if (!faxableSchedulesList.IsNullOrWhiteSpace())
                                {
                                    strSelectClause += " and ISNULL(DrugCategory,0) not in (0," + faxableSchedulesList +
                                                       ")";
                                }
                                else
                                {
                                    strSelectClause += " and ISNULL(DrugCategory,0)>=2";

                                }

                                if (!strSelectClause.Equals(" ISNULL(DrugCategory,0)>=2") && !faxableSchedulesList.IsNullOrWhiteSpace() &&
                                    (faxableSchedulesList.Contains("3") || faxableSchedulesList.Contains("4") || faxableSchedulesList.Contains("5")))
                                {
                                    ScheduledButCanBeFaxed = true;
                                }
                                #endregion


                                 #region If "FaxScheduledCategoryList" doesn't exist follow original path
                                if (!ScheduledButCanBeFaxed)
                                {
                                    strSelectClause = "ISNULL(DrugCategory,0)>=2  and  ClientMedicationScriptId=" +
                                                             DataSetTemp.Tables["ClientMedicationScripts"].Rows[icount][
                                                                 "ClientMedicationScriptId"].ToString();
                                    _strScriptsTobeFaxedButPrinted = false;

                                    if (DataSetTemp.Tables["ClientMedicationScriptDrugs"].Select(strSelectClause).Length > 0)
                                    {
                                        if (Session["ePrescription"] == null)
                                        {
                                            _strScriptsTobeFaxedButPrinted = true;
                                            HiddenFieldAllFaxed.Value = "0";
                                        }
                                    }

                                    //If Non controlled Drugs
                                    if (_strScriptsTobeFaxedButPrinted)
                                    {
                                        // #tr - 2012.03.12 - Force print when going from E to P
                                        if (((HiddenField)Parent.FindControl("HiddenFieldRedirectFrom")).Value.ToUpper() ==
                                            "DASHBOARD")
                                        {
                                            if (
                                                (((HiddenField)Parent.FindControl("HiddenFieldClickedImage")).Value.ToUpper
                                                    () == "APPROVED"))
                                            {
                                                bool ans =
                                                    SendToPrinter(
                                                        Convert.ToInt32(DataSetTemp.Tables["ClientMedicationScripts"]
                                                            .Rows[icount]["ClientMedicationScriptId"]),
                                                        FlagForImagesDeletion, strSendCoverLetter, "A", 'P');
                                            }
                                            else if (
                                                (((HiddenField)Parent.FindControl("HiddenFieldClickedImage")).Value
                                                    .ToUpper() == "APPROVEDWITHCHANGES"))
                                            {
                                                bool ans =
                                                    SendToPrinter(
                                                        Convert.ToInt32(DataSetTemp.Tables["ClientMedicationScripts"]
                                                            .Rows[icount]["ClientMedicationScriptId"]),
                                                        FlagForImagesDeletion, strSendCoverLetter, "C", 'P');
                                            }
                                            else if (
                                                (((HiddenField)Parent.FindControl("HiddenFieldClickedImage")).Value
                                                    .ToUpper() == "DENIEDNEWPRESCRIPTIONS"))
                                            {
                                                bool ans =
                                                    SendToPrinter(
                                                        Convert.ToInt32(
                                                            DataSetTemp.Tables["ClientMedicationScripts"]
                                                                .Rows[icount]["ClientMedicationScriptId"]),
                                                        FlagForImagesDeletion, strSendCoverLetter, "N", 'P');
                                            }
                                            else
                                            {
                                                bool ans =
                                                    SendToPrinter(
                                                        Convert.ToInt32(
                                                            DataSetTemp.Tables["ClientMedicationScripts"]
                                                                .Rows[icount]["ClientMedicationScriptId"]),
                                                        FlagForImagesDeletion, strSendCoverLetter, "D", 'P');
                                            }
                                        }
                                        else
                                        {
                                            bool ans =
                                                SendToPrinter(Convert.ToInt32(DataSetTemp.Tables["ClientMedicationScripts"]
                                                    .Rows[icount]["ClientMedicationScriptId"]), FlagForImagesDeletion,
                                                    strSendCoverLetter, string.Empty, 'P');
                                        }

                                    }
                                    else
                                    {
                                        if (((HiddenField)Parent.FindControl("HiddenFieldRedirectFrom")).Value.ToUpper() ==
                                            "DASHBOARD" &&
                                            (_DrugsOrderMethod.ToUpper() == "REFILL" ||_DrugsOrderMethod.ToUpper() == "CHANGEAPPROVALORDER"||_DrugsOrderMethod.ToUpper()== "APPROVEWITHCHANGESCHANGEORDER"||
                                             _DrugsOrderMethod.ToUpper() == "NEW ORDER"))
                                        {
                                            HiddenField pharmacyid =
                                                (HiddenField)Page.FindControl("HiddenFieldRefillPharmacyId");
                                            PharmacyId = pharmacyid.Value != ""
                                                ? Convert.ToInt32(pharmacyid.Value)
                                                : Convert.ToInt32(
                                                    DataSetClientMedications.Tables["ClientMedicationScripts"].Rows[icount][
                                                        "PharmacyId"]);
                                        }
                                        else
                                        {
                                            if (DataSetClientMedications.Tables["ClientMedicationScripts"].Rows.Count > 0 &&
                                                DataSetClientMedications.Tables["ClientMedicationScripts"].Rows[icount][
                                                    "PharmacyId"].ToString() != string.Empty)
                                            {
                                                PharmacyId =
                                                    Convert.ToInt32(
                                                        DataSetClientMedications.Tables["ClientMedicationScripts"].Rows[
                                                            icount]["PharmacyId"]);
                                            }
                                            else if (((HiddenField)(Parent.FindControl("HiddenFieldPharmacyId"))).Value !=
                                                     "")
                                            {
                                                PharmacyId =
                                                    Convert.ToInt32(
                                                        ((HiddenField)(Parent.FindControl("HiddenFieldPharmacyId")))
                                                            .Value);
                                            }
                                        }
                                        if (((HiddenField)Parent.FindControl("HiddenFieldRedirectFrom")).Value.ToUpper() ==
                                            "DASHBOARD")
                                        {
                                            if (
                                                (((HiddenField)Parent.FindControl("HiddenFieldClickedImage")).Value.ToUpper
                                                    () == "APPROVED"))
                                            {
                                                bool ans3 =
                                                    SendByElectronically(
                                                        Convert.ToInt32(DataSetTemp.Tables["ClientMedicationScripts"]
                                                            .Rows[icount]["ClientMedicationScriptId"]), PharmacyId,
                                                        FlagForImagesDeletion, strSendCoverLetter, "A");
                                            }
                                            else if (
                                                (((HiddenField)Parent.FindControl("HiddenFieldClickedImage")).Value
                                                    .ToUpper() == "APPROVEDWITHCHANGES"))
                                            {
                                                bool ans3 =
                                                    SendByElectronically(
                                                        Convert.ToInt32(DataSetTemp.Tables["ClientMedicationScripts"]
                                                            .Rows[icount]["ClientMedicationScriptId"]), PharmacyId,
                                                        FlagForImagesDeletion, strSendCoverLetter, "C");
                                            }
                                            else if (
                                                (((HiddenField)Parent.FindControl("HiddenFieldClickedImage")).Value
                                                    .ToUpper() == "DENIEDNEWPRESCRIPTIONS"))
                                            {
                                                bool ans3 =
                                                    SendByElectronically(
                                                        Convert.ToInt32(
                                                            DataSetTemp.Tables["ClientMedicationScripts"]
                                                                .Rows[icount]["ClientMedicationScriptId"]),
                                                        PharmacyId, FlagForImagesDeletion, strSendCoverLetter, "N");
                                            }
                                            else
                                            {
                                                bool ans3 =
                                                    SendByElectronically(
                                                        Convert.ToInt32(
                                                            DataSetTemp.Tables["ClientMedicationScripts"]
                                                                .Rows[icount]["ClientMedicationScriptId"]),
                                                        PharmacyId, FlagForImagesDeletion, strSendCoverLetter, "D");
                                            }
                                        }
                                        else
                                        {
                                            bool ans3 =
                                                SendByElectronically(
                                                    Convert.ToInt32(DataSetTemp.Tables["ClientMedicationScripts"]
                                                        .Rows[icount]["ClientMedicationScriptId"]), PharmacyId,
                                                    FlagForImagesDeletion, strSendCoverLetter, string.Empty);
                                        }
                                    }
                                }
                                 #endregion

                                #region Send prescription through Fax. If Fax fails send prescription through print
                                else
                                {
                                    bool ans1 = false;
                                    if (
                                        ((HiddenField)Parent.FindControl("HiddenFieldRedirectFrom")).Value.ToUpper() ==
                                        "DASHBOARD")
                                    {
                                        if (
                                            (((HiddenField)Parent.FindControl("HiddenFieldClickedImage")).Value
                                                .ToUpper() == "APPROVED"))
                                        {
                                            ans1 = SendToFax(Convert.ToInt32(DataSetTemp
                                                .Tables["ClientMedicationScripts"].Rows[icount][
                                                    "ClientMedicationScriptId"]),
                                                Convert.ToInt32(
                                                    DataSetClientMedications.Tables["ClientMedicationScripts"]
                                                        .Rows[0]["PharmacyId"]), FlagForImagesDeletion,
                                                strSendCoverLetter, "A");
                                        }
                                        else if (
                                            (((HiddenField)Parent.FindControl("HiddenFieldClickedImage")).Value
                                                .ToUpper() == "APPROVEDWITHCHANGES"))
                                        {
                                            ans1 = SendToFax(Convert.ToInt32(DataSetTemp
                                                .Tables["ClientMedicationScripts"].Rows[icount][
                                                    "ClientMedicationScriptId"]),
                                                Convert.ToInt32(
                                                    DataSetClientMedications.Tables["ClientMedicationScripts"]
                                                        .Rows[0]["PharmacyId"]), FlagForImagesDeletion,
                                                strSendCoverLetter, "C");
                                        }
                                        else if (
                                            (((HiddenField)Parent.FindControl("HiddenFieldClickedImage"))
                                                .Value.ToUpper() == "DENIEDNEWPRESCRIPTIONS"))
                                        {
                                            ans1 = SendToFax(Convert.ToInt32(DataSetTemp
                                                .Tables["ClientMedicationScripts"].Rows[icount][
                                                    "ClientMedicationScriptId"]),
                                                Convert.ToInt32(
                                                    DataSetClientMedications.Tables[
                                                        "ClientMedicationScripts"]
                                                        .Rows[0]["PharmacyId"]), FlagForImagesDeletion,
                                                strSendCoverLetter, "N");
                                        }
                                        else
                                        {
                                            ans1 = SendToFax(Convert.ToInt32(DataSetTemp
                                                .Tables["ClientMedicationScripts"].Rows[icount][
                                                    "ClientMedicationScriptId"]),
                                                Convert.ToInt32(
                                                    DataSetClientMedications.Tables[
                                                        "ClientMedicationScripts"]
                                                        .Rows[0]["PharmacyId"]), FlagForImagesDeletion,
                                                strSendCoverLetter, "D");
                                        }

                                    }
                                    else
                                    {
                                        ans1 = SendToFax(Convert.ToInt32(DataSetTemp
                                            .Tables["ClientMedicationScripts"].Rows[icount][
                                                "ClientMedicationScriptId"]),
                                            Convert.ToInt32(
                                                DataSetClientMedications.Tables["ClientMedicationScripts"]
                                                    .Rows[0]["PharmacyId"]), FlagForImagesDeletion,
                                            strSendCoverLetter, string.Empty);
                                    }


                                    if (ans1 == false) //If Sending Fax failed
                                    {
                                        if (
                                            ((HiddenField)Parent.FindControl("HiddenFieldRedirectFrom")).Value
                                                .ToUpper() == "DASHBOARD")
                                        {
                                            if (
                                                (((HiddenField)Parent.FindControl("HiddenFieldClickedImage")).Value
                                                    .ToUpper() == "APPROVED"))
                                            {
                                                PrintPrescription(
                                                    Convert.ToInt32(DataSetTemp.Tables["ClientMedicationScripts"]
                                                        .Rows[icount]["ClientMedicationScriptId"]),
                                                    strSendCoverLetter, "A");
                                            }
                                            else if (
                                                (((HiddenField)Parent.FindControl("HiddenFieldClickedImage"))
                                                    .Value.ToUpper() == "APPROVEDWITHCHANGES"))
                                            {
                                                PrintPrescription(
                                                    Convert.ToInt32(
                                                        DataSetTemp.Tables["ClientMedicationScripts"]
                                                            .Rows[icount]["ClientMedicationScriptId"]),
                                                    strSendCoverLetter, "C");
                                            }
                                            else if (
                                                (((HiddenField)
                                                    Parent.FindControl("HiddenFieldClickedImage")).Value
                                                    .ToUpper() == "DENIEDNEWPRESCRIPTIONS"))
                                            {
                                                PrintPrescription(
                                                    Convert.ToInt32(
                                                        DataSetTemp.Tables["ClientMedicationScripts"]
                                                            .Rows[icount]["ClientMedicationScriptId"]),
                                                    strSendCoverLetter, "N");
                                            }
                                            else
                                            {
                                                PrintPrescription(
                                                    Convert.ToInt32(
                                                        DataSetTemp.Tables["ClientMedicationScripts"]
                                                            .Rows[icount]["ClientMedicationScriptId"]),
                                                    strSendCoverLetter, "D");
                                            }
                                        }
                                        else
                                        {
                                            PrintPrescription(
                                                Convert.ToInt32(DataSetTemp.Tables["ClientMedicationScripts"]
                                                    .Rows[icount]["ClientMedicationScriptId"]), strSendCoverLetter,
                                                string.Empty);
                                        }
                                    }
                                    if (_strPrintChartCopy == "true")
                                    {
                                        if (
                                            ((HiddenField)Parent.FindControl("HiddenFieldRedirectFrom")).Value
                                                .ToUpper() == "DASHBOARD")
                                        {
                                            if (
                                                (((HiddenField)Parent.FindControl("HiddenFieldClickedImage")).Value
                                                    .ToUpper() == "APPROVED"))
                                            {
                                                PrintChartCopy(
                                                    Convert.ToInt32(DataSetTemp.Tables["ClientMedicationScripts"]
                                                        .Rows[icount]["ClientMedicationScriptId"]),
                                                    strSendCoverLetter, "A");
                                            }
                                            else if (
                                                (((HiddenField)Parent.FindControl("HiddenFieldClickedImage"))
                                                    .Value.ToUpper() == "APPROVEDWITHCHANGES"))
                                            {
                                                PrintChartCopy(
                                                    Convert.ToInt32(
                                                        DataSetTemp.Tables["ClientMedicationScripts"]
                                                            .Rows[icount]["ClientMedicationScriptId"]),
                                                    strSendCoverLetter, "C");
                                            }
                                            else if (
                                                (((HiddenField)
                                                    Parent.FindControl("HiddenFieldClickedImage")).Value
                                                    .ToUpper() == "DENIEDNEWPRESCRIPTIONS"))
                                            {
                                                PrintChartCopy(
                                                    Convert.ToInt32(
                                                        DataSetTemp.Tables["ClientMedicationScripts"]
                                                            .Rows[icount]["ClientMedicationScriptId"]),
                                                    strSendCoverLetter, "C");
                                            }
                                            else
                                            {
                                                PrintChartCopy(
                                                    Convert.ToInt32(
                                                        DataSetTemp.Tables["ClientMedicationScripts"]
                                                            .Rows[icount]["ClientMedicationScriptId"]),
                                                    strSendCoverLetter, "D");
                                            }

                                        }
                                        else
                                        {
                                            PrintChartCopy(
                                                Convert.ToInt32(DataSetTemp.Tables["ClientMedicationScripts"]
                                                    .Rows[icount]["ClientMedicationScriptId"]), strSendCoverLetter,
                                                string.Empty);
                                        }
                                    } //Faxing Check for Service Status If Sending Fax failed 
                                }
                                #endregion
                                //}

                                //Malathi Shiva - Engineering Improvement Initiatives- NBL(I) Task# 267
                                // When E-prescription fails we need to fax the prescription to the pharmacy
                                if (DataSetClientScriptActivities != null && DataSetClientScriptActivities.Tables["ClientMedicationScriptActivities"].Rows.Count > 0)
                                {
                                    DataRow[] drClientMedicationScriptActivities5564 = DataSetClientScriptActivities.Tables["ClientMedicationScriptActivities"].Select("Method = 'E' AND Status = 5564");
                                    if (drClientMedicationScriptActivities5564.Count() > 0)
                                    {
                                        DataSet DataSetFailedEPrescriptions = ObjectClientMedication.GetFailedElectronicPrescriptions(Convert.ToInt32(Session["ClientIdForValidateToken"].ToString()), ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId);
                                        if (DataSetFailedEPrescriptions != null && DataSetFailedEPrescriptions.Tables[0].Rows.Count > 0)
                                        {
                                            foreach (DataRow dr in DataSetFailedEPrescriptions.Tables[0].Rows)
                                            {
                                                SendToFax(Convert.ToInt32(dr["ClientMedicationScriptId"]), Convert.ToInt32(dr["PharmacyId"]), FlagForImagesDeletion, "", "FE");
                                            }
                                        }
                                    }
                                }

                                DataSetTempMeds =
                                    ObjectClientMedication.UpdateClientScriptActivities(DataSetClientScriptActivities);
                            }
                        }
                    }
                    ObjectClientMedication = null;
                    #endregion

                    //After ClientScript Activities have been updated Discontinue old Medications in case Choosen method was Change Order
                    DataRow[] DataRowsClientMedicationsToBeDiscontinued;
                    DataRow[] DataRowsClientMedicationsToBeRefilled;
                    ObjectClientMedication = new ClientMedication();
                    DataSet _DataSetClientMedications = null;
                    try
                    {

                        if (_DrugsOrderMethod == "Refill" || _DrugsOrderMethod == "REFILL") //|| _DrugsOrderMethod.ToUpper() == "CHANGEAPPROVALORDER"
                        {
                            if (Session["ChangedOrderMedicationIds"] != null)
                            {
                                _DataSetClientMedications = new DataSet();
                                DataRowsClientMedicationsToBeRefilled = DataSetTemp.Tables["ClientMedications"]
                                    .Select("ClientMedicationId in (" + Session["ChangedOrderMedicationIds"].ToString() + ")");
                                foreach (DataRow dr in DataRowsClientMedicationsToBeRefilled)
                                {
                                    dr["MedicationEndDate"] = dr["MedicationEndDate"];
                                    dr["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                                    dr["ModifiedDate"] = DateTime.Now;
                                }
                                _DataSetClientMedications.Merge(DataRowsClientMedicationsToBeRefilled);
                                _DataSetClientMedications.Tables[0].TableName = "ClientMedications";
                                DataSetTemp = ObjectClientMedication.UpdateDocuments(_DataSetClientMedications);
                            }
                        }
                        if (_DrugsOrderMethod.ToUpper() == "CHANGE" || _DrugsOrderMethod.ToUpper() == "ADJUST" || _DrugsOrderMethod.ToUpper() == "COMPLETE")
                        {
                            if (Session["ChangedOrderMedicationIds"] != null)
                            {
                                _DataSetClientMedications = new DataSet();
                                _DataSetClientSummary = (DataSet)Session["DataSetClientSummary"];
                                DataRowsClientMedicationsToBeDiscontinued = _DataSetClientSummary.Tables["ClientMedicationInstructions"]
                                    .Select("ClientMedicationId in (" + Session["ChangedOrderMedicationIds"].ToString() + ")");
                                foreach (DataRow dr in DataRowsClientMedicationsToBeDiscontinued)
                                {
                                    dr["Active"] = "N";
                                    dr["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                                    dr["ModifiedDate"] = DateTime.Now;
                                }
                                _DataSetClientMedications.Merge(DataRowsClientMedicationsToBeDiscontinued);
                                _DataSetClientMedications.Tables[0].TableName = "ClientMedicationInstructions";
                                DataSetTemp = ObjectClientMedication.UpdateDocuments(_DataSetClientMedications);

                                if (Session["ClientMedicationInteractionIds"].ToString() != "")
                                    ObjectClientMedication.DeleteInteractions(Session["ClientMedicationInteractionIds"].ToString());
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        if (ex.Data["CustomExceptionInformation"] == null)
                            ex.Data["CustomExceptionInformation"] = "##Source Event Name -Prescribe Screen- DocumentUpdateDocument()-Discontinue Medications-Change Order Case";
                        else
                            ex.Data["CustomExceptionInformation"] = "";
                        if (ex.Data["DatasetInfo"] == null)
                            ex.Data["DatasetInfo"] = null;
                        Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);

                    }
                    finally
                    {
                        DataRowsClientMedicationsToBeDiscontinued = null;
                        DataRowsClientMedicationsToBeRefilled = null;
                        if (_DataSetClientMedications != null)
                            _DataSetClientMedications.Dispose();
                        ObjectClientMedication = null;
                    }


                    Session["DataSetPrescribedClientMedications"] = null;
                    //Checking queue order button is clicked
                    if (_Queue == false)
                    {
                        Session["medicationIdList"] = null;
                        int PrinterLocation = 0;
                        if (HiddenPrinterDeviceLocations.Value.ToString() != "" && HiddenPrinterDeviceLocations.Value != null)
                            PrinterLocation = Convert.ToInt32(HiddenPrinterDeviceLocations.Value);
                        if (Session["IncludeChartcopy"] == "Y" && DropDownListChartCopyPrinter.SelectedIndex > 0 && OrderingMethod != 'F')
                        {
                            string printerName = "";
                            string FileName = "";
                            int chartCopy = 0;
                            int ChartPrinterLocation = 0;
                            if (DropDownListChartCopyPrinter.SelectedIndex >= 0)
                                ChartPrinterLocation = Convert.ToInt32(DropDownListChartCopyPrinter.SelectedValue);

                            foreach (string file in Directory.GetFiles(Server.MapPath("RDLC\\" + Context.User.Identity.Name + "\\")))
                            {
                                //Condition 
                                for (int icount = 0; icount < dataTableClientMedicationScripts.Rows.Count; icount++)
                                {
                                    if ((file.IndexOf("001" + dataTableClientMedicationScripts.Rows[icount]["ClientMedicationScriptId"]) > 0) ||
                                        (file.IndexOf("002" + dataTableClientMedicationScripts.Rows[icount]["ClientMedicationScriptId"]) >= 0))
                                    {
                                        chartCopy = file.IndexOf("\\002");
                                        if (chartCopy > 0)
                                        {
                                            FileName = file.Substring(file.LastIndexOf("\\") + 1);
                                            DataRow[] dr = Streamline.UserBusinessServices.SharedTables.DataSetPrinterDeviceLocations
                                                .Tables[0].Select("PrinterDeviceLocationId=" + ChartPrinterLocation);
                                            PrintDocument prnDoc = new PrintDocument();

                                            if (dr.Length > 0)
                                            {
                                                printerName = dr[0]["DeviceUNCPath"].ToString();
                                            }
                                            prnDoc.PrinterSettings.PrinterName = printerName;
                                            if ((FileName.IndexOf("JPEG") >= 0 || FileName.IndexOf("jpeg") >= 0))
                                            {
                                                imageToConvert = (System.Drawing.Image)System.Drawing.Image.FromFile(Server.MapPath(".\\RDLC\\" + Context.User.Identity.Name + "\\" + FileName));

                                                if (prnDoc.PrinterSettings.IsValid)
                                                {
                                                    prnDoc.PrinterSettings.IsDirectPrintingSupported(imageToConvert);
                                                    prnDoc.PrintPage += new System.Drawing.Printing.PrintPageEventHandler(PrintFormHandler);
                                                    prnDoc.Print();
                                                    prnDoc.PrintPage -= this.PrintFormHandler;
                                                    if (((HiddenField)Parent.FindControl("HiddenFieldRedirectFrom")).Value.ToUpper() == "DASHBOARD")
                                                        ScriptManager.RegisterStartupScript(LabelClientScript, LabelClientScript.GetType(), ClientID.ToString(), "redirectToStartPage();", true);
                                                    else
                                                        ScriptManager.RegisterStartupScript(LabelClientScript, LabelClientScript.GetType(), ClientID.ToString(), "redirectToManagementPage();", true);
                                                }
                                                else
                                                {
                                                    imageToConvert = null;
                                                    //HiddenFieldShowError.Value = "Printer location path is not Valid.";
                                                    if (OrderingMethod != 'A')
                                                        ScriptManager.RegisterStartupScript(LabelClientScript, LabelClientScript.GetType(), ClientID.ToString(),
                                                            "CommonFunctions.PrintMedicationScript('" + _strScriptIds + "'," + HiddenFieldAllFaxed.Value.ToString() + ",'" + _strChartScripts + "',true);", true);
                                                    return false;
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        if (RadioButtonPrintScript.Checked == true && PrinterLocation > 0 && OrderingMethod != 'F')
                        {
                            string printerName = "";
                            string FileName = "";
                            DataRow[] dr = Streamline.UserBusinessServices.SharedTables
                                .DataSetPrinterDeviceLocations.Tables[0].Select("PrinterDeviceLocationId=" + PrinterLocation);
                            if (dr.Length > 0)
                            {
                                printerName = dr[0]["DeviceUNCPath"].ToString();
                            }
                            PrintDocument prnDoc = new PrintDocument();
                            prnDoc.PrinterSettings.PrinterName = printerName;

                            foreach (string file in Directory.GetFiles(Server.MapPath("RDLC\\" + Context.User.Identity.Name + "\\")))
                            {
                                FileName = file.Substring(file.LastIndexOf("\\") + 1);
                                // to avoid the problem of  image is still pending on print job then it will through a exception that can't delete image is used by another process
                                for (int icount = 0; icount < dataTableClientMedicationScripts.Rows.Count; icount++)
                                {
                                    if (FileName.IndexOf("001" + dataTableClientMedicationScripts.Rows[icount]["ClientMedicationScriptId"].ToString()) >= 0)
                                    {
                                        if ((FileName.IndexOf("JPEG") >= 0 || FileName.IndexOf("jpeg") >= 0))
                                        {
                                            imageToConvert = (System.Drawing.Image)System.Drawing.Image.FromFile(Server.MapPath(".\\RDLC\\" + Context.User.Identity.Name + "\\" + FileName));

                                            if (prnDoc.PrinterSettings.IsValid)
                                            {
                                                prnDoc.PrinterSettings.IsDirectPrintingSupported(imageToConvert);
                                                prnDoc.PrintPage += new System.Drawing.Printing.PrintPageEventHandler(PrintFormHandler);
                                                prnDoc.Print();
                                                prnDoc.PrintPage -= this.PrintFormHandler;
                                                ScriptManager.RegisterStartupScript(LabelClientScript, LabelClientScript.GetType(), ClientID.ToString(), "redirectToManagementPage();", true);
                                            }
                                            else
                                            {
                                                imageToConvert = null;
                                                if (OrderingMethod != 'A')
                                                    ScriptManager.RegisterStartupScript(LabelClientScript, LabelClientScript.GetType(), ClientID.ToString(), "CommonFunctions.PrintMedicationScript('" + _strScriptIds + "'," + HiddenFieldAllFaxed.Value.ToString() + ",'" + _strChartScripts + "',true);", true);
                                                return false;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        else
                        {
                            if ((HiddenFieldAllFaxed.Value.ToString() == "0" ||
                                OrderingMethod == 'P' ||
                                _strChartCopiesToBePrinted == true) &&
                                    OrderingMethod != 'A')
                            {
                                ScriptManager.RegisterStartupScript(LabelClientScript, LabelClientScript.GetType(), ClientID.ToString(),
                                    "CommonFunctions.PrintMedicationScript('" + _strScriptIds + "'," + HiddenFieldAllFaxed.Value.ToString() + ",'" + _strChartScripts + "',true);", true);
                            } //Added else if Condition and a new parameter FaxStatus , If Sending Fax failed 
                            else if (_strFaxFailed == true && OrderingMethod != 'A') // in case sending fax failed 
                            {
                                ScriptManager.RegisterStartupScript(LabelClientScript, LabelClientScript.GetType(), ClientID.ToString(),
                                    "CommonFunctions.PrintMedicationScript('" + _strFaxFailedScripts + "'," + HiddenFieldAllFaxed.Value.ToString() + ",'" + _strChartScripts + "',false);", true);
                            }
                            else if (OrderingMethod != 'E' && _strPrintChartCopy != "true")
                            {
                                if (((HiddenField)Parent.FindControl("HiddenFieldRedirectFrom")).Value.ToUpper() == "DASHBOARD")
                                    ScriptManager.RegisterStartupScript(LabelClientScript, LabelClientScript.GetType(), ClientID.ToString(), "redirectToStartPage();", true);
                                else
                                    ScriptManager.RegisterStartupScript(LabelClientScript, LabelClientScript.GetType(), ClientID.ToString(), "redirectToManagementPage();", true);
                            }
                        }
                    } //Checking queue order button is clicked
                    else
                    {
                        if (((HiddenField)Parent.FindControl("HiddenFieldRedirectFrom")).Value.ToUpper() == "DASHBOARD")
                            ScriptManager.RegisterStartupScript(LabelClientScript, LabelClientScript.GetType(), ClientID.ToString(), "redirectToStartPage();", true);
                        else
                            ScriptManager.RegisterStartupScript(LabelClientScript, LabelClientScript.GetType(), ClientID.ToString(), "redirectToManagementPage();", true);
                    }
                }
                else
                {
                    ScriptManager.RegisterStartupScript(LabelClientScript, LabelClientScript.GetType(), ClientID.ToString(), "redirectToLoginPage();", true);
                }
                if (OrderingMethod == 'E')
                {
                    if (_strPrintChartCopy == "true")
                    {
                        ScriptManager.RegisterStartupScript(LabelClientScript, LabelClientScript.GetType(), ClientID.ToString(),
                            "CommonFunctions.PrintMedicationScript('" + _strScriptIds + "'," + HiddenFieldAllFaxed.Value.ToString() + ",'" + _strChartScripts + "',true);", true);
                    }
                    else
                    {
                        ScriptManager.RegisterStartupScript(LabelClientScript, LabelClientScript.GetType(), ClientID.ToString(), "redirectToManagementPage();", true);
                    }
                }
                //true should be returned only if document has been updated successfully
                return true;
            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally
            {
                DataSetClientScriptActivities = null;
                DataSetClientMedications = null;
                _DataTableClientMedications = null;
                _DataSetClientSummary = null;
                _DataTableClientMedicationInstructions = null;

                DataTableClientMedicationsNCSampleORStockDrugs = null;
                DataTableClientMedicationsNCNonSampleORStockDrugs = null;
                DataTableClientMedicationsC2SampleORStockDrugs = null;
                DataTableClientMedicationsC2NonSampleORStockDrugs = null;
                DataSetPharmacies = null;
                drSelectedPharmacy = null;
                dsTemp = null;
                DataRowsClientMedeicationsCategory2Drugs = null;
                DataRowsClientMedicationsNormalCategoryDrugs = null;
                DataRowsClientMedicationsControlledCategoryDrugs = null;
                _strPrintChartCopy = null;
                _strMedicationInstructionIds = null;
            }
        }

        private void PrintFormHandler(object sender, PrintPageEventArgs args)
        {
            Font myFont = new Font("Microsoft San Serif", 10);
            args.Graphics.DrawImage(imageToConvert, 0, 0, imageToConvert.Width, imageToConvert.Height);
        }

        #region Generate Scripts
        protected void ButtonNewOrder_Click(object sender, EventArgs e)
        {
            Streamline.UserBusinessServices.ClientMedication objectClientMedications = null;
            objectClientMedications = new ClientMedication();
            var Reloadlistview = false;

            try
            {
                CommonFunctions.Event_Trap(this);
                //Added by Loveena in ref to Task#3208 :- 2.2 Location Selection Lost When Changing After Preview
                ((HiddenField)(Parent.FindControl("HiddenFieldPrescribingLocation"))).Value = string.Empty;
                Session["OriginalDataUpdated"] = 1;
                //Checking queue order button is clicked
                if (((HiddenField)Parent.FindControl("HiddenPageName")).Value.ToUpper() == "FROMDASHBOARD")
                    _Queue = true;
                else
                    _Queue = false;

                var substancesListCount = HiddenFieldControlledSubstancesListValidate.Value;
                if (substancesListCount == "0")
                {
                    string strErrorMessage = "Please review and click the review checkbox for controlled medication.";
                    ScriptManager.RegisterStartupScript(LabelClientScript, LabelClientScript.GetType(), ClientID.ToString(), "MedicationPrescribe.ShowGridErrorMessage('" + strErrorMessage + "');", true);
                    HiddenFieldControlledSubstancesListValidate.Value = "";
                    Reloadlistview = true;
                    goto Proceed;
                }

                // Added By Malathi Shiva :WRT Task# 1 EPCS
                if (this.TextBoxPassword.Visible == true && ButtonNewOrder.Text == "Prescribe")
                {
                    if (this.TextBoxOneTimePassword.Visible == true && ButtonNewOrder.Text == "Prescribe")
                    {
                        if (TextBoxOneTimePassword.Text.Trim() == "")
                        {
                            string strErrorMessage = "Please enter Token #/One Time Password";
                            ScriptManager.RegisterStartupScript(LabelClientScript, LabelClientScript.GetType(), ClientID.ToString(), "MedicationPrescribe.ShowGridErrorMessage('" + strErrorMessage + "', true);", true);
                            HiddenFieldShowError.Value = "";
                            Reloadlistview = true;
                            goto Proceed;
                        }
                    }
                    if (TextBoxPassword.Text.Trim() == "")
                    {
                        string strErrorMessage = "Please enter Password";
                        ScriptManager.RegisterStartupScript(LabelClientScript, LabelClientScript.GetType(), ClientID.ToString(), "MedicationPrescribe.ShowGridErrorMessage('" + strErrorMessage + "', true);", true);
                        HiddenFieldShowError.Value = "";
                        Reloadlistview = true;
                        goto Proceed;

                    }
                    string ErrorMessage = string.Empty;
                    bool isValidCredentials=false;
                    UserPrefernces staffDetails = new UserPrefernces();
                    DataSet staffDataset = staffDetails.CheckStaffPermissions(((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId);
                    TwoFactorAuthenticationRequest objTwoFactorAuthenticationRequest = new TwoFactorAuthenticationRequest();
                    TwoFactorAuthentication objTwoFactorAuthentication = new TwoFactorAuthentication();
                    TwoFactorAuthenticationResponse TwoFactorAuthenticationResponseObject = new TwoFactorAuthenticationResponse();
                    string UserEmailAccount =string.Empty;
                    string UserDevicePassword = string.Empty;
                    if (staffDataset.Tables.Count > 2 && staffDataset.Tables[3].Rows.Count > 0)
                    {
                        UserEmailAccount = staffDataset.Tables[3].Rows[0]["DeviceEmail"].ToString();
                        UserDevicePassword = staffDataset.Tables[3].Rows[0]["DevicePassword"].ToString();
                    }
                    objTwoFactorAuthenticationRequest.UserID = UserEmailAccount;
                    objTwoFactorAuthenticationRequest.Password = ApplicationCommonFunctions.GetDecryptedData(UserDevicePassword, "Y");
                    objTwoFactorAuthenticationRequest.OTP = TextBoxOneTimePassword.Text;
                    TwoFactorAuthenticationResponseObject = objTwoFactorAuthentication.Authenticate(objTwoFactorAuthenticationRequest,"Controlled Drug prescription (New Order)");

                    if (TwoFactorAuthenticationResponseObject.Passed != true)
                    {
                        string strErrorMessage = "One Time Password incorrect";
                        ScriptManager.RegisterStartupScript(LabelClientScript, LabelClientScript.GetType(), ClientID.ToString(), "MedicationPrescribe.ShowError('" + strErrorMessage + "', true);", true);
                        HiddenFieldShowError.Value = "One Time Password incorrect";
                        Reloadlistview = true;

                        goto Proceed;
                    }
                    else
                    {
                        ErrorMessage = "Success";
                        isValidCredentials = true;
                        //ScriptManager.RegisterStartupScript(Page, Page.GetType(), UniqueID, "javascript:Updatemessagestatus('" + ErrorMessage + "');", true);
                    }
                    if (isValidCredentials)
                    {
                        // Attempt AD lookup
                        MedicationLogin objMedicationLogin = null;
                        objMedicationLogin = new Streamline.UserBusinessServices.MedicationLogin();
                        DataSet userAuthenticationType = null;
                        string authType = string.Empty;
                        string enableADAuthentication = string.Empty;
                        bool isValidUser = false;
                        DataSet ds;
                        try
                        {
                            if ((SecureString)Session["ADPassword"] == null || Session["ADPassword"].ToString()=="")
                            {
                                var secureADPassword = new SecureString();
                                TextBoxPassword.Text.Trim().ToCharArray().ToList().ForEach(secureADPassword.AppendChar);
                                Session["ADPassword"] = secureADPassword;
                            }

                            userAuthenticationType =
                            objMedicationLogin.GetUserAuthenticationType(
                                ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode);

                            if (userAuthenticationType.Tables["Authentication"].Rows.Count > 0)
                            {
                                authType =
                                    userAuthenticationType.Tables["Authentication"].Rows[0]["AuthenticationType"]
                                        .ToString();
                            }

                            if (userAuthenticationType.Tables["EnableActiveDirectory"] != null)
                            {
                                enableADAuthentication =
                                    userAuthenticationType.Tables["EnableActiveDirectory"].Rows[0][
                                        "EnableADAuthentication"]
                                        .ToString();
                            }

                            if (enableADAuthentication.ToUpperInvariant().Equals("Y") &&
                                authType.ToUpperInvariant().Equals("A"))
                            {
                                string strErrorMessage = "";
                                // Decrypt password from Session variable
                                string unencryptedADPassword;
                                var valuePtr = IntPtr.Zero;
                                try
                                {
                                    valuePtr = Marshal.SecureStringToGlobalAllocUnicode((SecureString)Session["ADPassword"]);
                                    unencryptedADPassword = Marshal.PtrToStringUni(valuePtr);
                                }
                                finally
                                {
                                    Marshal.ZeroFreeGlobalAllocUnicode(valuePtr);
                                }
                                try
                                {
                                    isValidUser =
                                        objMedicationLogin.ADAuthenticateUser(
                                            ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode,
                                            unencryptedADPassword,
                                            userAuthenticationType.Tables[
                                                "Authentication"]
                                                .Rows[0]["Domain"].ToString()
                                            );
                                    if (TextBoxPassword.Text.Trim() != unencryptedADPassword)
                                    {
                                        strErrorMessage = "Password does not match the SmartCare login password.";
                                        ScriptManager.RegisterStartupScript(LabelClientScript, LabelClientScript.GetType(), ClientID.ToString(), "MedicationPrescribe.ShowError('" + strErrorMessage + "', true);", true);
                                        HiddenFieldShowError.Value = strErrorMessage;
                                        Reloadlistview = true;
                                        goto Proceed;
                                    }
                                    else if (!isValidUser)
                                    {
                                        strErrorMessage = "Active Directory Authentication Failed.";
                                        ScriptManager.RegisterStartupScript(LabelClientScript, LabelClientScript.GetType(), ClientID.ToString(), "MedicationPrescribe.ShowError('" + strErrorMessage + "', true);", true);
                                        HiddenFieldShowError.Value = strErrorMessage;
                                        Reloadlistview = true;
                                        goto Proceed;
                                    }

                                    else
                                    {
                                        strErrorMessage = "Authentication Passed";
                                        isValidCredentials = true;
                                    }
                                }
                                catch (Exception ex)
                                {
                                    Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);
                                    strErrorMessage = "Error while validating password.";
                                    ScriptManager.RegisterStartupScript(LabelClientScript, LabelClientScript.GetType(), ClientID.ToString(), "MedicationPrescribe.ShowError('" + strErrorMessage + "', true);", true);
                                    HiddenFieldShowError.Value = strErrorMessage;
                                    Reloadlistview = true;
                                    goto Proceed;
 
                                }
                                finally {

                                   // Streamline.DataService.StaticLogManager.WriteToDatabase(strErrorMessage + "Staff ID=" + ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId.ToString(), "In Exception handling of MedicationPrecriber.asax" + "AD validation-" + isValidUser.ToString() + , "AUTHLOG", "sa");
                                }
                            }
                            else
                            {
                                ds = objMedicationLogin.chkServerLogin(((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode.Trim(), TextBoxPassword.Text.Trim());
                                if (ds.Tables[0].Rows.Count == 0)
                                {
                                    string strErrorMessage = "Invalid Password.";
                                    ScriptManager.RegisterStartupScript(LabelClientScript, LabelClientScript.GetType(), ClientID.ToString(), "MedicationPrescribe.ShowError('" + strErrorMessage + "', true);", true);
                                    HiddenFieldShowError.Value = strErrorMessage;
                                    Reloadlistview = true;
                                    goto Proceed;
                                }
                                else
                                    isValidCredentials = true;
                            }
                        }
                        catch (Exception ex)
                        {
                            string strErrorMessage = "Invalid Password";
                            ScriptManager.RegisterStartupScript(LabelClientScript, LabelClientScript.GetType(), ClientID.ToString(), "MedicationPrescribe.ShowError('" + strErrorMessage + "', true);", true);
                            HiddenFieldShowError.Value = "Invalid Password";
                            Reloadlistview = true;
                            goto Proceed;
                        }
                    }
                    if (isValidCredentials)
                    {
                        goto Save;
                    }
                }

                objectClientMedications.DeleteTempTables(Session.SessionID);

            Save:

                bool _DocumentUpdatedOrNot = DocumentUpdateDocument();
                //If Document has been updated only then Cancel Button should be disabled,in case of some errors cancel button should be enabled
                if (_DocumentUpdatedOrNot == true)
                {
                    ButtonNewOrder.Enabled = false;
                    ButtonCancel.Enabled = false;
                }


            Proceed:

                if (ButtonNewOrder.Text == "Update Order")
                {
                    OrderMedicationResult = "update";
                }
                else
                {
                    OrderMedicationResult = "update";
                }
                //Below code was added by Vithobha for EPCS: #2 04.A1-Logical Controls of Prescription
                if ((Session["ePrescription"] != null && Session["ePrescription"].ToString() == "True" && Reloadlistview) || ButtonChangeOrder.Visible)
                {
                    Panel1.Controls.Add(Page.LoadControl("~/UserControls/SubstancesList.ascx"));
                }
                
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Event Name -ButtonNewOrder_Click(), ParameterCount -2, First Parameter- " + sender + ", Second Parameter- " + e + "###";
                else
                    ex.Data["CustomExceptionInformation"] = "";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);

                string strErrorMessage = "Error occured while Updating Database";
                ScriptManager.RegisterStartupScript(LabelClientScript, LabelClientScript.GetType(), ClientID.ToString(), "MedicationPrescribe.ShowError('" + strErrorMessage + "', true);", true);
                HiddenFieldShowError.Value = "Error occured while Updating Database";
            }
            finally
            {
                reportViewer1 = null;
                objectClientMedications = null;
            }
        }


        /// <summary>
        /// To insert rows into ClientMedicationScripts table and ClientMedicationScriptDrugs table
        /// </summary>
        /// <param name="SampleOrStock"></param>
        /// <param name="iMedicationRowsCount"></param>
        /// <param name="DataTableMedicationDetails"></param>
        /// <param name="NoOfRowsToBeCopied"></param>
        /// <param name="DrugCategory"></param>
        private void GenerateScriptsTableRows(char SampleOrStock, int iMedicationRowsCount, DataTable DataTableMedicationDetails, int NoOfRowsToBeCopied, string DrugCategory)
        {
            DataRow drClientMedicationScripts = null;
            DataRow drSureScriptsCancelRequest = null;
            DataColumn[] dcDataTableSureScriptsRefillRequests = new DataColumn[1];
            DataRow dr = null;
            DataRow drClientMedicationScriptDrugs = null;
            DataTable DataTableMedicationInstructionDetails = null;
            DataRow[] dataRowsClientMedicationInstructions = null;
            DataRow[] drMedication = null;
            DataRow[] dataRowsClientMedicationScriptDrugs = null;
            DataRow[] dataRowsClientMedicationScriptDrugStrengths = null;
            string _strMedicationInstructionIds = "";
            string _strMedicationIds = "";
            try
            {
                DataSet _dsTemp = new DataSet();
                if (_UpdateTempTables == true)
                    _dsTemp.Merge(DataSetClientMedications_Temp.Tables["ClientMedicationScriptDrugStrengths"]);
                else
                    _dsTemp.Merge(DataSetClientMedications.Tables["ClientMedicationScriptDrugStrengths"]);

                if ((OrderingMethod == 'E' || OrderingMethod == 'P')&& DrugCategory != "C2")
                {
                    DataRow[] drScriptDrugStrengths = null;
                    string sSelection = "";
                    foreach (DataRow drGeneralCategoryMedications in DataTableMedicationDetails.Rows)
                    {
                        sSelection = sSelection + (String.IsNullOrEmpty(sSelection) ? "" : ",") + drGeneralCategoryMedications["ClientMedicationId"].ToString();
                    }

                    if (!String.IsNullOrEmpty(sSelection))
                    {
                        drScriptDrugStrengths = _dsTemp.Tables["ClientMedicationScriptDrugStrengths"]
                            .Select("ClientMedicationId in (" + sSelection + ")");

                        for (short index = 0; index < drScriptDrugStrengths.Length; index++)
                        {
                            if (_UpdateTempTables == true)
                                drClientMedicationScripts = DataSetClientMedications_Temp.Tables["ClientMedicationScripts"].NewRow();
                            else
                                drClientMedicationScripts = DataSetClientMedications.Tables["ClientMedicationScripts"].NewRow();

                            drClientMedicationScripts["Clientid"] = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId;
                            drClientMedicationScripts["OrderingMethod"] = OrderingMethod;
                            if (_UpdateTempTables == true)
                            {
                                if (Convert.ToInt32(DataSetClientMedications_Temp1.Tables["ClientMedicationScripts"].Rows[0]["PharmacyId"]) != 0)
                                    drClientMedicationScripts["PharmacyId"] = DataSetClientMedications_Temp1.Tables["ClientMedicationScripts"].Rows[0]["PharmacyId"];
                            }
                            else
                            {
                                if (Convert.ToInt32(DataSetClientMedications.Tables["ClientMedicationScripts"].Rows[0]["PharmacyId"]) != 0)
                                    drClientMedicationScripts["PharmacyId"] = DataSetClientMedications.Tables["ClientMedicationScripts"].Rows[0]["PharmacyId"];
                            }

                            drClientMedicationScripts["PrintDrugInformation"] = PrintDrugInformation;
                            drClientMedicationScripts["VerbalOrderReadBack"] = VerbalOrderReadBack;
                            drClientMedicationScripts["StaffLicenseDegreeId"] = StaffLicenseDegreeId;
                            drClientMedicationScripts["ScriptCreationDate"] = DateTime.Now;
                            drClientMedicationScripts["OrderingPrescriberId"] = DataTableMedicationDetails.Rows[0]["PrescriberId"];
                            drClientMedicationScripts["OrderingPrescriberName"] = DataTableMedicationDetails.Rows[0]["PrescriberName"];

                            if (_UpdateTempTables == true)
                            {
                                drClientMedicationScripts["OrderDate"] = DataSetClientMedications_Temp.Tables["ClientMedicationScripts"].Rows[0]["OrderDate"];
                                if (
                                    DataSetClientMedications_Temp1.Tables["ClientMedicationScripts"].Rows[0][
                                        "LocationId"] != System.DBNull.Value)
                                    drClientMedicationScripts["LocationId"] = LocationId;
                                else
                                    drClientMedicationScripts["LocationId"] = System.DBNull.Value;

                                if (DataSetClientMedications_Temp.Tables["ClientMedicationScripts"].Rows[0]["PlanName"] != System.DBNull.Value)
                                    drClientMedicationScripts["PlanName"] = DataSetClientMedications_Temp.Tables["ClientMedicationScripts"].Rows[0]["PlanName"];
                                else
                                    drClientMedicationScripts["PlanName"] = System.DBNull.Value;
                            }
                            else
                            {
                                drClientMedicationScripts["OrderDate"] = DataSetClientMedications.Tables["ClientMedicationScripts"].Rows[0]["OrderDate"];
                                if (DataSetClientMedications.Tables["ClientMedicationScripts"].Rows[0]["LocationId"] !=
                                    System.DBNull.Value)
                                    drClientMedicationScripts["LocationId"] = LocationId;
                                else
                                    drClientMedicationScripts["LocationId"] = System.DBNull.Value;

                                if (DataSetClientMedications.Tables["ClientMedicationScripts"].Rows[0]["PlanName"] != System.DBNull.Value)
                                    drClientMedicationScripts["PlanName"] = DataSetClientMedications.Tables["ClientMedicationScripts"].Rows[0]["PlanName"];
                                else
                                    drClientMedicationScripts["PlanName"] = System.DBNull.Value;
                            }

                            if (_DrugsOrderMethod.ToUpper() == "CHANGE")
                            {
                                drClientMedicationScripts["ScriptEventType"] = "C";
                                if (_UpdateTempTables != true)
                                {
                                    DataRow[] cancelledMessages =
                                        DataTableMedicationDetails.Select("ClientMedicationId=" +
                                                                          drScriptDrugStrengths[index][
                                                                              "ClientMedicationId"].ToString() +
                                                                          " and isnull(SureScriptsOutgoingMessageId,-1) > 0");
                                    if (cancelledMessages.Length > 0)
                                    {
                                        drSureScriptsCancelRequest =
                                            DataSetClientMedications.Tables["SurescriptsCancelRequests"].NewRow();
                                        drSureScriptsCancelRequest["OriginalSurescriptsOutgoingMessageId"] =
                                            cancelledMessages[0]["SureScriptsOutgoingMessageId"];
                                        //drSureScriptsCancelRequest["ChangeRequestType"] = "C3";
                                        drSureScriptsCancelRequest["ChangeOfPrescriptionStatusFlag"] = "C";
                                        drSureScriptsCancelRequest["CreatedBy"] =
                                            ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity)
                                                .UserCode;
                                        drSureScriptsCancelRequest["CreatedDate"] = DateTime.Now;
                                        drSureScriptsCancelRequest["ModifiedBy"] =
                                            ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity)
                                                .UserCode;
                                        drSureScriptsCancelRequest["PrescriberId"] =
                                            ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity)
                                                .UserId;
                                        drSureScriptsCancelRequest["ModifiedDate"] = DateTime.Now;
                                        DataSetClientMedications.Tables["SurescriptsCancelRequests"].Rows.Add(
                                            drSureScriptsCancelRequest);

                                    }
                                }
                            }
                            else if (_DrugsOrderMethod.ToUpper() == "ADJUST")
                                drClientMedicationScripts["ScriptEventType"] = "C";
                            else if (_DrugsOrderMethod == "Refill" || _DrugsOrderMethod == "REFILL")
                                drClientMedicationScripts["ScriptEventType"] = "R";

                            else if (_DrugsOrderMethod.ToUpper() == "APPROVEWITHCHANGESCHANGEORDER")
                            {
                                drClientMedicationScripts["ScriptEventType"] = "C";
                            }
                            else if (_DrugsOrderMethod.ToUpper() == "CHANGEAPPROVALORDER")
                            {
                                drClientMedicationScripts["ScriptEventType"] = "A";
                            }
                            else
                                drClientMedicationScripts["ScriptEventType"] = "N";

                            if (((HiddenField)Parent.FindControl("HiddenFieldRedirectFrom")).Value.ToUpper() == "DASHBOARD" &&
                                (_DrugsOrderMethod.ToUpper() == "NEW ORDER" || _DrugsOrderMethod.ToUpper() == "REFILL"))
                            {
                                HiddenField hiddenFieldSureScriptRefillId = (HiddenField)Page.FindControl("HiddenFieldSureScriptRefillRequestId");
                                if (hiddenFieldSureScriptRefillId.Value != "")
                                    drClientMedicationScripts["SureScriptsRefillRequestId"] = Convert.ToInt32(hiddenFieldSureScriptRefillId.Value);
                            }

                            if (_DrugsOrderMethod.ToUpper() == "APPROVEWITHCHANGESCHANGEORDER" || _DrugsOrderMethod.ToUpper() == "CHANGEAPPROVALORDER")
                            {
                                HiddenField hiddenFieldSureScriptChangeId = (HiddenField)Page.FindControl("HiddenFieldSureScriptChangeRequestId");
                                if (hiddenFieldSureScriptChangeId.Value != "")
                                    drClientMedicationScripts["SureScriptsChangeRequestId"] = Convert.ToInt32(hiddenFieldSureScriptChangeId.Value);
                            }

                            int prescriberid = 0;
                            if (Convert.ToString(DataTableMedicationDetails.Rows[0]["PrescriberId"]) != null &&
                                Convert.ToString(DataTableMedicationDetails.Rows[0]["PrescriberId"]) != "")
                            {
                                prescriberid = Convert.ToInt32(DataTableMedicationDetails.Rows[0]["PrescriberId"].ToString());
                            }

                            if (_Queue == true)
                            {

                                drClientMedicationScripts["WaitingPrescriberApproval"] = "Y";
                            }
                            else
                            {
                                drClientMedicationScripts["WaitingPrescriberApproval"] = System.DBNull.Value;
                            }
                            drClientMedicationScripts["RowIdentifier"] = System.Guid.NewGuid();
                            drClientMedicationScripts["CreatedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                            drClientMedicationScripts["CreatedDate"] = DateTime.Now;
                            drClientMedicationScripts["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                            drClientMedicationScripts["ModifiedDate"] = DateTime.Now;

                            if (_UpdateTempTables == true)
                            {
                                DataSetClientMedications_Temp.Tables["ClientMedicationScripts"].Rows.Add(drClientMedicationScripts);

                                int strengthId = 0;
                                strengthId = Convert.ToInt32(drScriptDrugStrengths[index]["StrengthId"]);

                                foreach (
                                DataRow drMedDrugStrength in
                                    (DataSetClientMedications_Temp.Tables["ClientMedicationScriptDrugStrengths"].Select("StrengthId = "
                                                                                                                 +
                                                                                                                 strengthId))
                                )
                                {

                                    drMedDrugStrength["ClientMedicationScriptId"] = drClientMedicationScripts["ClientMedicationScriptId"];
                                }

                                foreach (
                                DataRow drMedStrength in
                                    (DataSetClientMedications_Temp.Tables["ClientMedicationInstructions"].Select("StrengthId = "
                                                                                                                 +
                                                                                                                 strengthId))
                                )
                                {
                                    for (int iDrug = 0;
                                         iDrug <
                                         DataSetClientMedications_Temp.Tables["ClientMedicationScriptDrugs"].Rows.Count;
                                         iDrug++)
                                    {
                                        if (
                                            Convert.ToInt64(
                                                DataSetClientMedications_Temp.Tables["ClientMedicationScriptDrugs"].Rows[
                                                    iDrug]["ClientMedicationInstructionId"]) ==
                                            Convert.ToInt64(drMedStrength["ClientMedicationInstructionId"]))
                                        {
                                            DataSetClientMedications_Temp.Tables["ClientMedicationScriptDrugs"].Rows[iDrug][
                                                "ClientMedicationScriptId"] =
                                                drClientMedicationScripts["ClientMedicationScriptId"];
                                        }
                                    }
                                }
                            }
                            else
                            {
                                DataSetClientMedications.Tables["ClientMedicationScripts"].Rows.Add(drClientMedicationScripts);

                                int strengthId = 0;
                                strengthId = Convert.ToInt32(drScriptDrugStrengths[index]["StrengthId"]);

                                foreach (
                                DataRow drMedDrugStrength in
                                    (DataSetClientMedications.Tables["ClientMedicationScriptDrugStrengths"].Select("StrengthId = "
                                                                                                                 +
                                                                                                                 strengthId))
                                )
                                {

                                    drMedDrugStrength["ClientMedicationScriptId"] = drClientMedicationScripts["ClientMedicationScriptId"];
                                }
                                //Update the ScriptId into ClientMedicationScriptDispenseDays
                                if (_UpdateTempTables == false && DataSetClientMedications != null)
                                {
                                    for (int idays = 0; idays < DataSetClientMedications.Tables["ClientMedicationScriptDispenseDays"].Rows.Count; idays++)
                                    {
                                        DataSetClientMedications.Tables["ClientMedicationScriptDispenseDays"].Rows[idays][
                                                                                      "ClientMedicationScriptId"] =
                                                                                      drClientMedicationScripts["ClientMedicationScriptId"];
                                    }
                                }
                                foreach (
                                DataRow drMedStrength in
                                    (DataSetClientMedications.Tables["ClientMedicationInstructions"].Select("StrengthId = "
                                                                                                                 +
                                                                                                                 strengthId))
                                )
                                {
                                    for (int iDrug = 0;
                                         iDrug <
                                         DataSetClientMedications.Tables["ClientMedicationScriptDrugs"].Rows.Count;
                                         iDrug++)
                                    {
                                        if (
                                            Convert.ToInt64(
                                                DataSetClientMedications.Tables["ClientMedicationScriptDrugs"].Rows[
                                                    iDrug]["ClientMedicationInstructionId"]) ==
                                            Convert.ToInt64(drMedStrength["ClientMedicationInstructionId"]))
                                        {
                                            DataSetClientMedications.Tables["ClientMedicationScriptDrugs"].Rows[iDrug][
                                                "ClientMedicationScriptId"] =
                                                drClientMedicationScripts["ClientMedicationScriptId"];
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                else
                {
                    if (_UpdateTempTables == true)
                        drClientMedicationScripts = DataSetClientMedications_Temp.Tables["ClientMedicationScripts"].NewRow();
                    else
                        drClientMedicationScripts = DataSetClientMedications.Tables["ClientMedicationScripts"].NewRow();

                    drClientMedicationScripts["Clientid"] = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId;
                    drClientMedicationScripts["OrderingMethod"] = OrderingMethod;
           
                    if (_UpdateTempTables == true)
                    {
                        if (Convert.ToInt32(DataSetClientMedications_Temp1.Tables["ClientMedicationScripts"].Rows[0]["PharmacyId"]) != 0)
                            drClientMedicationScripts["PharmacyId"] = DataSetClientMedications_Temp1.Tables["ClientMedicationScripts"].Rows[0]["PharmacyId"];
                    }
                    else
                    {
                        if (Convert.ToInt32(DataSetClientMedications.Tables["ClientMedicationScripts"].Rows[0]["PharmacyId"]) != 0)
                            drClientMedicationScripts["PharmacyId"] = DataSetClientMedications.Tables["ClientMedicationScripts"].Rows[0]["PharmacyId"];
                    }
                    
                    if (_UpdateTempTables == true)
                        drClientMedicationScripts["PlanName"] = DataSetClientMedications_Temp1.Tables["ClientMedicationScripts"].Rows[0]["PlanName"];
                    else
                        drClientMedicationScripts["PlanName"] = DataSetClientMedications.Tables["ClientMedicationScripts"].Rows[0]["PlanName"];


                    drClientMedicationScripts["PrintDrugInformation"] = PrintDrugInformation;
                    drClientMedicationScripts["VerbalOrderReadBack"] = VerbalOrderReadBack;
                    drClientMedicationScripts["StaffLicenseDegreeId"] = StaffLicenseDegreeId;
                    drClientMedicationScripts["ScriptCreationDate"] = DateTime.Now;
                    drClientMedicationScripts["OrderingPrescriberId"] = DataTableMedicationDetails.Rows[0]["PrescriberId"];
                    drClientMedicationScripts["OrderingPrescriberName"] = DataTableMedicationDetails.Rows[0]["PrescriberName"];

                    if (_UpdateTempTables == true)
                    {
                        drClientMedicationScripts["OrderDate"] = DataSetClientMedications_Temp.Tables["ClientMedicationScripts"].Rows[0]["OrderDate"];
                        if (DataSetClientMedications_Temp1.Tables["ClientMedicationScripts"].Rows[0]["LocationId"] != System.DBNull.Value)
                            drClientMedicationScripts["LocationId"] = LocationId;
                        else
                            drClientMedicationScripts["LocationId"] = System.DBNull.Value;
                    }
                    else
                    {
                        drClientMedicationScripts["OrderDate"] = DataSetClientMedications.Tables["ClientMedicationScripts"].Rows[0]["OrderDate"];
                        if (DataSetClientMedications.Tables["ClientMedicationScripts"].Rows[0]["LocationId"] != System.DBNull.Value)
                            drClientMedicationScripts["LocationId"] = LocationId;
                        else
                            drClientMedicationScripts["LocationId"] = System.DBNull.Value;
                    }

                    if (_DrugsOrderMethod.ToUpper() == "CHANGE")
                        drClientMedicationScripts["ScriptEventType"] = "C";
                    else if (_DrugsOrderMethod.ToUpper() == "ADJUST")
                        drClientMedicationScripts["ScriptEventType"] = "C";
                    else if (_DrugsOrderMethod == "Refill" || _DrugsOrderMethod == "REFILL")
                        drClientMedicationScripts["ScriptEventType"] = "R";
                    else if (_DrugsOrderMethod == "APPROVEWITHCHANGESCHANGEORDER")
                    {
                        drClientMedicationScripts["ScriptEventType"] = "C"; //Change to CA by Changing the len for this column
                    }
                    else if (_DrugsOrderMethod == "CHANGEAPPROVALORDER")
                    {
                        drClientMedicationScripts["ScriptEventType"] = "A"; //Change to CA by Changing the len for this column
                    }
                    else
                        drClientMedicationScripts["ScriptEventType"] = "N";

                    if (((HiddenField)Parent.FindControl("HiddenFieldRedirectFrom")).Value.ToUpper() == "DASHBOARD" &&
                        (_DrugsOrderMethod.ToUpper() == "NEW ORDER" || _DrugsOrderMethod.ToUpper() == "REFILL"))
                    {
                        HiddenField hiddenFieldSureScriptRefillId = (HiddenField)Page.FindControl("HiddenFieldSureScriptRefillRequestId");
                        if (hiddenFieldSureScriptRefillId.Value != "")
                            drClientMedicationScripts["SureScriptsRefillRequestId"] = Convert.ToInt32(hiddenFieldSureScriptRefillId.Value);
                    }

                    if (_DrugsOrderMethod.ToUpper() == "APPROVEWITHCHANGESCHANGEORDER" || _DrugsOrderMethod.ToUpper() == "CHANGEAPPROVALORDER") 
                    {
                        HiddenField hiddenFieldSureScriptChangeId = (HiddenField)Page.FindControl("HiddenFieldSureScriptChangeRequestId");
                        if (hiddenFieldSureScriptChangeId.Value != "")
                            drClientMedicationScripts["SureScriptsChangeRequestId"] = Convert.ToInt32(hiddenFieldSureScriptChangeId.Value);
                    }

                    int prescriberid = 0;
                    if (Convert.ToString(DataTableMedicationDetails.Rows[0]["PrescriberId"]) != null && Convert.ToString(DataTableMedicationDetails.Rows[0]["PrescriberId"]) != "")
                    {
                        prescriberid = Convert.ToInt32(DataTableMedicationDetails.Rows[0]["PrescriberId"].ToString());
                    }

                    if (_Queue == true)
                    {
                        drClientMedicationScripts["WaitingPrescriberApproval"] = "Y";
                    }
                    else
                    {
                        drClientMedicationScripts["WaitingPrescriberApproval"] = System.DBNull.Value;
                    }
                    drClientMedicationScripts["RowIdentifier"] = System.Guid.NewGuid();
                    drClientMedicationScripts["CreatedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                    drClientMedicationScripts["CreatedDate"] = DateTime.Now;
                    drClientMedicationScripts["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                    drClientMedicationScripts["ModifiedDate"] = DateTime.Now;

                    if (_UpdateTempTables == true)
                        DataSetClientMedications_Temp.Tables["ClientMedicationScripts"].Rows.Add(drClientMedicationScripts);
                    else
                        DataSetClientMedications.Tables["ClientMedicationScripts"].Rows.Add(drClientMedicationScripts);
                }
                if (drClientMedicationScripts != null)
                {
                    scriptId = Convert.ToInt32(drClientMedicationScripts["ClientMedicationScriptId"]);
                }
                else
                {
                    Exception ex = new Exception("Missing information in script, please click Change Order and modify the script");
                    ex.Data["CustomExceptionInformationMessage"] = "Missing information in script, please click Change Order and modify the script";
                    throw ex;
                }
                int iloopCounter = 1;
                int Maxnumberofmedsforscriptid = 3;
                DataSet DatasetSystemConfigurationKeys = null;
                Streamline.DataService.SharedTables objSharedTables = new Streamline.DataService.SharedTables();
                DatasetSystemConfigurationKeys = objSharedTables.GetSystemConfigurationKeys();
                if (objSharedTables.GetSystemConfigurationKeys("PRINTFOURPRESCRIPTIONSPERPAGE", DatasetSystemConfigurationKeys.Tables[0]).ToUpper() == "YES")
                {
                    Maxnumberofmedsforscriptid = 4;
                }

                if (DrugCategory == "C2" || DrugCategory == "C3" || DrugCategory == "C4" || DrugCategory == "C5" || DrugCategory == "CT")
                    iloopCounter = ((NoOfRowsToBeCopied + 1) > iMedicationRowsCount) ? iMedicationRowsCount : (NoOfRowsToBeCopied + 1);
                else
                    iloopCounter = ((NoOfRowsToBeCopied + Maxnumberofmedsforscriptid) > iMedicationRowsCount) ? iMedicationRowsCount : (NoOfRowsToBeCopied + Maxnumberofmedsforscriptid);

                for (int i = NoOfRowsToBeCopied; i < iloopCounter; i++)
                {
                    _strMedicationInstructionIds = "";
                    dr = null;
                    dr = DataTableMedicationDetails.Rows[i];

                    DataRow[] drInstructions = _DataTableClientMedicationInstructions.Select("ClientMedicationId=" + dr["ClientMedicationId"].ToString());
                    foreach (DataRow dr1 in drInstructions)
                    {
                        _strMedicationInstructionIds += (_strMedicationInstructionIds != "" ? "," : "") + dr1["ClientMedicationInstructionId"].ToString();
                    }

                    if (_strMedicationInstructionIds != "")
                    {
                        if (_UpdateTempTables == true)
                            dataRowsClientMedicationScriptDrugs = DataSetClientMedications_Temp.Tables["ClientMedicationScriptDrugs"]
                                .Select("ClientMedicationInstructionId in(" + _strMedicationInstructionIds + ")");
                        else
                            dataRowsClientMedicationScriptDrugs = DataSetClientMedications.Tables["ClientMedicationScriptDrugs"]
                                .Select("ClientMedicationInstructionId in(" + _strMedicationInstructionIds + ")");
                    }
                    _strMedicationIds = "";
                    DataRow[] drScriptDrugStrengths = _DataTableClientMedicationScriptDrugStrengths.Select("ClientMedicationId=" + dr["ClientMedicationId"].ToString());
                    foreach (DataRow dr1 in drScriptDrugStrengths)
                    {
                        _strMedicationIds += (_strMedicationIds != "" ? "," : "") + dr1["ClientMedicationId"].ToString();
                    }
                    if (_strMedicationIds != "")
                    {
                        if (_UpdateTempTables == true)
                            dataRowsClientMedicationScriptDrugStrengths = DataSetClientMedications_Temp.Tables["ClientMedicationScriptDrugStrengths"]
                                .Select("ClientMedicationId in(" + _strMedicationIds + ")");
                        else
                            dataRowsClientMedicationScriptDrugStrengths = DataSetClientMedications.Tables["ClientMedicationScriptDrugStrengths"]
                                .Select("ClientMedicationId in(" + _strMedicationIds + ")");
                    }

                    //Update the ScriptId into ClientMedicationScriptDispenseDays
                    if (_UpdateTempTables == false && DataSetClientMedications != null)
                    {
                        for (int idays = 0; idays < DataSetClientMedications.Tables["ClientMedicationScriptDispenseDays"].Rows.Count; idays++)
                        {
                            DataSetClientMedications.Tables["ClientMedicationScriptDispenseDays"].Rows[idays][
                                                                          "ClientMedicationScriptId"] =
                                                                          drClientMedicationScripts["ClientMedicationScriptId"];
                        }
                    }
                    //Update the ScriptId into ClientMedicationScriptDrugStrengths
                    if (dataRowsClientMedicationScriptDrugStrengths != null && OrderingMethod != 'E' && OrderingMethod != 'P' )
                    {
                        foreach (DataRow drMedicationScriptDrugStrengths in dataRowsClientMedicationScriptDrugStrengths)
                        {
                            drMedicationScriptDrugStrengths["ClientMedicationScriptId"] = drClientMedicationScripts["ClientMedicationScriptId"];
                        }
                    }

                    //Update the ScriptId into ClientMedicationScriptDrugs
                    int strengthId = 0;

                    if (dataRowsClientMedicationScriptDrugs != null)
                    {
                        foreach (DataRow drMedicationScriptDrugs in dataRowsClientMedicationScriptDrugs)
                        {
                            if (OrderingMethod != 'E' && OrderingMethod != 'P')
                                drMedicationScriptDrugs["ClientMedicationScriptId"] = drClientMedicationScripts["ClientMedicationScriptId"];
                            //Special Instructions needs to be updated in the new ClientMedicationScriptDrugs with the latest value of special Instructions in ClientMedications Table
                            drMedicationScriptDrugs["SpecialInstructions"] = dr["SpecialInstructions"];
                        }
                    }

                    if (_DrugsOrderMethod.ToLower().Equals("refill"))
                    {
                        if (_UpdateTempTables == true)
                        {
                            using (DataView DataViewClientMedicationScriptDrugs =
                                new DataView(DataSetClientMedications_Temp.Tables["ClientMedicationScriptDrugs"], "ClientMedicationInstructionId in(" +
                                    _strMedicationInstructionIds + ")", "EndDate Desc", DataViewRowState.CurrentRows))
                            {
                                DataRow DataRowClientMedication = DataSetClientMedications_Temp.Tables["ClientMedications"].Rows.Find(dr["ClientMedicationId"]);
                                DataRowClientMedication["MedicationEndDate"] = DataViewClientMedicationScriptDrugs[0]["EndDate"];
                            }
                        }
                        else
                        {
                            using (DataView DataViewClientMedicationScriptDrugs =
                                new DataView(DataSetClientMedications.Tables["ClientMedicationScriptDrugs"], "ClientMedicationInstructionId in(" +
                                    _strMedicationInstructionIds + ")", "EndDate Desc", DataViewRowState.CurrentRows))
                            {
                                DataRow DataRowClientMedication = DataSetClientMedications.Tables["ClientMedications"].Rows.Find(dr["ClientMedicationId"]);
                                DataRowClientMedication["MedicationEndDate"] = DataViewClientMedicationScriptDrugs[0]["EndDate"];
                            }
                        }
                    }
                }
                // Incase of c2 medication Clientmedicationscriptid is getting genrate for clientmedicationscriptdrugstrength
                for (int i = 0; i < DataTableMedicationDetails.Rows.Count; i++)
                {
                    _strMedicationIds += (_strMedicationIds != "" ? "," : "") + DataTableMedicationDetails.Rows[i]["ClientMedicationId"].ToString();
                }

                if (_strMedicationIds != "")
                {
                    if (_UpdateTempTables == true)
                    {
                        dataRowsClientMedicationScriptDrugStrengths = DataSetClientMedications_Temp
                            .Tables["ClientMedicationScriptDrugStrengths"].Select("ClientMedicationId in(" + _strMedicationIds + ")");
                    }
                    else
                    {
                        dataRowsClientMedicationScriptDrugStrengths = DataSetClientMedications
                            .Tables["ClientMedicationScriptDrugStrengths"].Select("ClientMedicationId in(" + _strMedicationIds + ")");
                    }
                }

                if (dataRowsClientMedicationScriptDrugStrengths != null)
                {
                    foreach (DataRow drMedicationScriptDrugStrengths in dataRowsClientMedicationScriptDrugStrengths)
                    {
                        foreach (DataRow drMedicationDetails in DataTableMedicationDetails.Select("ClientMedicationId=" +
                                                                  drMedicationScriptDrugStrengths["ClientMedicationId"])
                            )
                        {
                            if (!String.IsNullOrEmpty(drMedicationDetails["SpecialInstructions"].ToString()))
                            {
                                drMedicationScriptDrugStrengths["SpecialInstructions"] =
                                    drMedicationDetails["SpecialInstructions"];
                            }
                            else
                            {
                                drMedicationScriptDrugStrengths["SpecialInstructions"] = System.DBNull.Value;
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                string strErrorMessage = ex.Data["CustomExceptionInformationMessage"] == null
                                             ? "Error occured while Creating Scripts"
                                             : ex.Data["CustomExceptionInformationMessage"].ToString();

                ex.Data["CustomExceptionInformationMessage"] = null;

                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Event Name -GenerateScriptsTableRows()";
                else
                    ex.Data["CustomExceptionInformation"] = "";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);

                ScriptManager.RegisterStartupScript(LabelClientScript, LabelClientScript.GetType(), ClientID.ToString(), "MedicationPrescribe.ShowError('" + strErrorMessage + "', true);", true);
                HiddenFieldShowError.Value = strErrorMessage;

            }
            finally
            {
                drClientMedicationScripts = null;
                dr = null;
                drClientMedicationScriptDrugs = null;
                dataRowsClientMedicationScriptDrugs = null;

            }



        }

        private int ScriptsCount(int NumberOfDrugs)
        {
            int Maxnumberofmedsforscriptid = 3;
            DataSet DatasetSystemConfigurationKeys = null;
            Streamline.DataService.SharedTables objSharedTables = new Streamline.DataService.SharedTables();
            DatasetSystemConfigurationKeys = objSharedTables.GetSystemConfigurationKeys();
            if (objSharedTables.GetSystemConfigurationKeys("PRINTFOURPRESCRIPTIONSPERPAGE", DatasetSystemConfigurationKeys.Tables[0]).ToUpper() == "YES")
            {
                Maxnumberofmedsforscriptid = 4;
            }

            int ScriptCount = 0;
            int rem = 0;
            if (NumberOfDrugs != 0)
            {
                ScriptCount = (NumberOfDrugs / Maxnumberofmedsforscriptid);
                rem = (NumberOfDrugs % Maxnumberofmedsforscriptid);
                if (rem > 0)
                    ScriptCount++;
            }
            return ScriptCount;
        }

        public override bool RefreshPage()
        {
            Activate();
            return true;
        }

        public bool SendToFax(int ScriptId, int PharmacyId, bool FlagForImagesDeletion, string SendCoveLetter, string RefillResponseType)
        {
            #region Sending Fax
            string FaxUniqueId = "";
            try
            {
                GetRDLCContents(ScriptId, true, FlagForImagesDeletion, "F", SendCoveLetter, RefillResponseType);

                //Send Fax Contents to Fax server
                try
                {
                    Streamline.Faxing.StreamlineFax _streamlineFax = new Streamline.Faxing.StreamlineFax();
                    //FaxUniqueId = _streamlineFax.SendFax(PharmacyId, ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId, (Server.MapPath("RDLC") + "\\" + Context.User.Identity.Name + "\\MedicationScript.pdf"), "Prescription Medication Script") ? "True" : "";
                    FaxUniqueId = _streamlineFax.SendFax(PharmacyId, ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId, (Server.MapPath("RDLC") + "\\" + Context.User.Identity.Name + "\\MedicationScript.pdf"), "Prescription Medication Script");
                }
                catch (System.Runtime.InteropServices.COMException ex)
                {
                }

                #region InsertRowsIntoClientScriptActivities
                ////Insert Rows into ClientScriptActivities
                DataRow drClientMedicationScriptsActivity = DataSetClientScriptActivities.Tables["ClientMedicationScriptActivities"].NewRow();
                drClientMedicationScriptsActivity["ClientMedicationScriptId"] = ScriptId;
                drClientMedicationScriptsActivity["PharmacyId"] = PharmacyId;
                //Added by Chandan with ref Task#99 - 1.7.3 - Faxing Check for Service Status
                if (FaxUniqueId != "" && FaxUniqueId.ToLower() != "false")
                {
                    drClientMedicationScriptsActivity["Method"] = 'F';
                }
                else
                {
                    drClientMedicationScriptsActivity["Method"] = 'P';
                }

                //drClientMedicationScriptsActivity["PharmacyId"] = PharmacyId;
                if (RefillResponseType == "FE")
                {
                    DataRow[] drScriptFailure = Streamline.UserBusinessServices.SharedTables.DataSetGlobalCodes.Tables[0].Select("Category='SCRIPTREASON' And ISNULL(RecordDeleted,'N')='N' AND CodeName='Script Failure'", "SortOrder Asc");
                    if (drScriptFailure.Count() > 0)
                    {
                        drClientMedicationScriptsActivity["Reason"] = Convert.ToInt32(drScriptFailure[0]["GlobalCodeId"]);
                    }
                }
                else
                {
                    drClientMedicationScriptsActivity["Reason"] = System.DBNull.Value;
                }
                drClientMedicationScriptsActivity["FaxStatusDate"] = DateTime.Now;
                //drClientMedicationScriptsActivity["FaxStatus"] = "QUEUED";
                //Added by anuj on 24 feb, for task ref 85
                drClientMedicationScriptsActivity["Status"] = 5561;
                drClientMedicationScriptsActivity["StatusDescription"] = System.DBNull.Value;
                //Ended over here
                if (FaxUniqueId != "" && FaxUniqueId.ToLower() != "false")
                    drClientMedicationScriptsActivity["FaxExternalIdentifier"] = FaxUniqueId;
                else
                    drClientMedicationScriptsActivity["FaxExternalIdentifier"] = System.DBNull.Value;
                //Commented Currently
                //drClientMedicationScriptsActivity["FaxImageData"] = renderedBytes;

                //Added By chandan for task #85 
                //Modified by Loveena in ref to Task#3243 Sure Script:- Include Chart copy option is not working.
                //if (CheckBoxPrintChartCopy.Checked == true)
                if (Session["IncludeChartcopy"] == "Y")
                    drClientMedicationScriptsActivity["IncludeChartCopy"] = "Y";
                else
                    drClientMedicationScriptsActivity["IncludeChartCopy"] = "N";

                drClientMedicationScriptsActivity["RowIdentifier"] = System.Guid.NewGuid();
                drClientMedicationScriptsActivity["CreatedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                drClientMedicationScriptsActivity["CreatedDate"] = DateTime.Now;
                drClientMedicationScriptsActivity["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                drClientMedicationScriptsActivity["ModifiedDate"] = DateTime.Now;
                DataSetClientScriptActivities.Tables["ClientMedicationScriptActivities"].Rows.Add(drClientMedicationScriptsActivity);
                using (
                    ClientMedication _clientMedication = ObjectClientMedication != null
                                                             ? ObjectClientMedication
                                                             : new ClientMedication())
                {
                    _clientMedication.SetRenderedImageData(DataSetClientScriptActivities,
                                                                drClientMedicationScriptsActivity,
                                                                ((Streamline.BaseLayer.StreamlineIdentity)
                                                                 Context.User.Identity).UserCode, renderedBytes);
                }

                //Added by anuj on 25 feb,2010 fro task ref 85
                DataRow drClientMedicationScriptsActivityPending = DataSetClientScriptActivities.Tables["ClientMedicationScriptActivitiesPending"].NewRow();
                drClientMedicationScriptsActivityPending["ClientMedicationScriptActivityId"] = drClientMedicationScriptsActivity["ClientMedicationScriptActivityId"].ToString();
                drClientMedicationScriptsActivityPending["RowIdentifier"] = System.Guid.NewGuid();
                drClientMedicationScriptsActivityPending["CreatedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                drClientMedicationScriptsActivityPending["CreatedDate"] = DateTime.Now;
                drClientMedicationScriptsActivityPending["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                drClientMedicationScriptsActivityPending["ModifiedDate"] = DateTime.Now;
                DataSetClientScriptActivities.Tables["ClientMedicationScriptActivitiesPending"].Rows.Add(drClientMedicationScriptsActivityPending);
                //Ended over here


                #endregion

                if (FaxUniqueId != "" && FaxUniqueId.ToLower() != "false")
                    return true;
                else
                    return false;


            }

            catch (Exception ex)
            {
                throw (ex);
            }
            #endregion

        }

        //Added by anuj on 25 feb,2010 fro taskj ref 85
        public bool SendByElectronically(int ScriptId, int PharmacyId, bool FlagForImagesDeletion, string SendCoveLetter, string RefillResponseType)
        {
            try
            {
                if (_UpdateTempTables == true)
                    GetRDLCContents(ScriptId, false, FlagForImagesDeletion, "E", SendCoveLetter, RefillResponseType);
             //   _strScriptIds += (_strScriptIds != "" ? "^" : "") + ScriptId;

                DataRow drClientMedicationScriptsActivity = DataSetClientScriptActivities.Tables["ClientMedicationScriptActivities"].NewRow();
                drClientMedicationScriptsActivity["ClientMedicationScriptId"] = ScriptId;
                drClientMedicationScriptsActivity["Method"] = 'E';
                drClientMedicationScriptsActivity["PharmacyId"] = PharmacyId;
                drClientMedicationScriptsActivity["Reason"] = System.DBNull.Value;
                drClientMedicationScriptsActivity["FaxStatusDate"] = DateTime.Now;
                drClientMedicationScriptsActivity["Status"] = 5561;
                drClientMedicationScriptsActivity["StatusDescription"] = System.DBNull.Value;
                drClientMedicationScriptsActivity["FaxExternalIdentifier"] = System.DBNull.Value;
                drClientMedicationScriptsActivity["IncludeChartCopy"] = Session["IncludeChartcopy"] == "Y" ? "Y" : "N";
                drClientMedicationScriptsActivity["RowIdentifier"] = System.Guid.NewGuid();
                drClientMedicationScriptsActivity["CreatedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                drClientMedicationScriptsActivity["CreatedDate"] = DateTime.Now;
                drClientMedicationScriptsActivity["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                drClientMedicationScriptsActivity["ModifiedDate"] = DateTime.Now;
                DataSetClientScriptActivities.Tables["ClientMedicationScriptActivities"].Rows.Add(drClientMedicationScriptsActivity);
                DataRow drClientMedicationScriptsActivityPending = DataSetClientScriptActivities.Tables["ClientMedicationScriptActivitiesPending"].NewRow();
                drClientMedicationScriptsActivityPending["ClientMedicationScriptActivityId"] = drClientMedicationScriptsActivity["ClientMedicationScriptActivityId"].ToString();
                drClientMedicationScriptsActivityPending["RowIdentifier"] = System.Guid.NewGuid();
                drClientMedicationScriptsActivityPending["CreatedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                drClientMedicationScriptsActivityPending["CreatedDate"] = DateTime.Now;
                drClientMedicationScriptsActivityPending["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                drClientMedicationScriptsActivityPending["ModifiedDate"] = DateTime.Now;
                DataSetClientScriptActivities.Tables["ClientMedicationScriptActivitiesPending"].Rows.Add(drClientMedicationScriptsActivityPending);
                return true;
            }
            catch (Exception ex)
            {
                throw (ex);
            }

            finally
            {
            }

        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="ScriptId"></param>
        /// <param name="FlagForImagesDeletion"></param>
        /// <param name="SendCoveLetter"></param>
        /// <param name="RefillResponseType"></param>
        /// <returns></returns>
        /// ---------Modification History-------------------------------------
        /// ----Date------Author-----------Purpose----------------------------
        /// 14 March 2011 Pradeep          Added one more parameter RefillResponseType as per task#3336
        public bool SendToPrinter(int ScriptId, bool FlagForImagesDeletion, string SendCoveLetter, string RefillResponseType, char orderMethod)
        {
            #region Sending Results to printer
            // Declare objects
            DataSet DataSetTemp = null;
            try
            {

                //GetRDLCContents(ScriptId, false, FlagForImagesDeletion, "P", SendCoveLetter, RefillResponseType);
                GetRDLCContents(ScriptId, false, FlagForImagesDeletion, orderMethod.ToString(), SendCoveLetter, RefillResponseType);

                if (_strScriptIds == "")
                {
                    _strScriptIds += FolderId;
                }
                else
                {
                    _strScriptIds += "^" + FolderId;
                }

                if (orderMethod != 'A' && orderMethod != 'E')
                {
                    #region InsertRowsIntoClientScriptActivities
                    ////Insert Rows into ClientScriptActivities
                    DataRow drClientMedicationScriptsActivity = DataSetClientScriptActivities.Tables["ClientMedicationScriptActivities"].NewRow();
                    drClientMedicationScriptsActivity["ClientMedicationScriptId"] = ScriptId;
                    drClientMedicationScriptsActivity["Method"] = 'P';
                    drClientMedicationScriptsActivity["PharmacyId"] = System.DBNull.Value;
                    drClientMedicationScriptsActivity["Reason"] = System.DBNull.Value;
                    drClientMedicationScriptsActivity["FaxStatusDate"] = DateTime.Now;
                    //drClientMedicationScriptsActivity["FaxStatus"] = System.DBNull.Value;
                    //Added by Anuj on 24 feb, for task ref 85
                    drClientMedicationScriptsActivity["Status"] = System.DBNull.Value;
                    drClientMedicationScriptsActivity["StatusDescription"] = System.DBNull.Value;
                    //ended over here
                    drClientMedicationScriptsActivity["FaxExternalIdentifier"] = System.DBNull.Value;

                    //Added By chandan for task #85 
                    //Modified by Loveena in ref to Task#3243 Sure Script:- Include Chart copy option is not working.
                    //if (CheckBoxPrintChartCopy.Checked == true)
                    if (Session["IncludeChartcopy"] == "Y")
                        drClientMedicationScriptsActivity["IncludeChartCopy"] = "Y";
                    else
                        drClientMedicationScriptsActivity["IncludeChartCopy"] = "N";

                    drClientMedicationScriptsActivity["RowIdentifier"] = System.Guid.NewGuid();
                    drClientMedicationScriptsActivity["CreatedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                    drClientMedicationScriptsActivity["CreatedDate"] = DateTime.Now;
                    drClientMedicationScriptsActivity["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                    drClientMedicationScriptsActivity["ModifiedDate"] = DateTime.Now;
                    DataSetClientScriptActivities.Tables["ClientMedicationScriptActivities"].Rows.Add(drClientMedicationScriptsActivity);
                    using (
                        ClientMedication _clientMedication = ObjectClientMedication != null
                                                                 ? ObjectClientMedication
                                                                 : new ClientMedication())
                    {
                        _clientMedication.SetRenderedImageData(DataSetClientScriptActivities,
                                                               drClientMedicationScriptsActivity,
                                                               ((Streamline.BaseLayer.StreamlineIdentity)
                                                                Context.User.Identity).UserCode, renderedBytes);
                    }

                    #endregion

                    #region InsertRowsIntoClientScriptActivityPending
                    //Added by anuj on 25 feb,2010 fro task ref 85
                    DataRow drClientMedicationScriptsActivityPending = DataSetClientScriptActivities.Tables["ClientMedicationScriptActivitiesPending"].NewRow();
                    drClientMedicationScriptsActivityPending["ClientMedicationScriptActivityId"] = drClientMedicationScriptsActivity["ClientMedicationScriptActivityId"].ToString();
                    drClientMedicationScriptsActivityPending["RowIdentifier"] = System.Guid.NewGuid();
                    drClientMedicationScriptsActivityPending["CreatedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                    drClientMedicationScriptsActivityPending["CreatedDate"] = DateTime.Now;
                    drClientMedicationScriptsActivityPending["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                    drClientMedicationScriptsActivityPending["ModifiedDate"] = DateTime.Now;
                    DataSetClientScriptActivities.Tables["ClientMedicationScriptActivitiesPending"].Rows.Add(drClientMedicationScriptsActivityPending);
                    //Ended over here
                    #endregion
                }
                return true;



            }




            catch (System.Runtime.InteropServices.COMException ex)
            {
                string strEx = ex.Message.ToString();
                throw (ex);
            }
            finally
            {


                DataSetTemp = null;
            }

            #endregion
        }
        /// <summary>
        /// Added by sonia to Print Chart Copy in case of Fax
        /// </summary>
        /// <param name="ScriptId"></param>
        public void PrintChartCopy(int ScriptId, string strSendCoverLetter, string RefillResponseType)
        {
            try
            {
                //RDLC to be rendered for Chart Copy of Faxed Document
                //Modified in Ref to Task#2596.
                //                GetRDLCContents(ScriptId, false, false, "X", strSendCoverLetter);
                //GetRDLCContents(ScriptId, false, false, "P", strSendCoverLetter);
                //Modified by Loveena in ref to Task#609 -  Blank Page prints on fax with chart copy.

                GetRDLCContents(ScriptId, false, false, "X", strSendCoverLetter, RefillResponseType);
                _strChartCopiesToBePrinted = true;
                if (_strChartScripts == "")
                {
                    _strChartScripts += ScriptId;
                }
                else
                {
                    _strChartScripts += "^" + ScriptId;
                }
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "Source function PrintChartCopy() of Prescribe Screen";
                else
                    ex.Data["CustomExceptionInformation"] = "";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);

            }

        }

        /// <summary>
        /// Added by sonia to Print Prescription in case Fax Failed
        /// task #99 MM1.6.5 </summary>
        /// <param name="ScriptId">ScriptId</param>
        /// -------------Modification history---------------------
        /// -----Date------Author------Purpose--------------------------
        /// 14 March 2011  Pradeep     Aded one more parameter RefillResponseType as per task#3336 
        public void PrintPrescription(int ScriptId, string strSendCoverLetter, string RefillResponseType)
        {
            try
            {
                //RDLC to be rendered for Chart Copy of Faxed Document
                //Added by chandan on 21st Nov 2008 for creating report  
                try
                {
                    GetRDLCContents(ScriptId, false, true, "P", strSendCoverLetter, RefillResponseType);
                    //Added by Loveena in ref to Task#2660
                    FolderId = ScriptId.ToString() + "_" + DateTime.Now.ToString("MMddyyyymmhhss");
                    //Added by Loveena in ref to Task#3266-2.6 Print All Scripts When Fax Not Available
                    if (_strScriptIds == "")
                    {
                        _strScriptIds += FolderId;
                    }
                    else
                    {
                        _strScriptIds += "^" + FolderId;
                    }
                    using (Streamline.BaseLayer.RDLCPrint objRDLC = new RDLCPrint())
                    {
                        //Modified in ref to Task#2660
                        //objRDLC.Run(this.reportViewer1.LocalReport, Server.MapPath("RDLC\\" + Context.User.Identity.Name), ScriptId.ToString(), false, false);
                        objRDLC.Run(this.reportViewer1.LocalReport, Server.MapPath("RDLC\\" + Context.User.Identity.Name), FolderId, false, false);
                    }
                }
                catch (Exception ex)
                {
                    Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);

                }
                finally
                {
                }
                _strFaxFailed = true;
                //if (_strFaxFailedScripts == "")
                //{
                //    _strFaxFailedScripts += ScriptId;
                //}
                //else
                //{
                //    _strFaxFailedScripts += "^" + ScriptId;
                //}
                //Modified in ref to Task#2660
                if (_strFaxFailedScripts == "")
                {
                    _strFaxFailedScripts += FolderId;
                }
                else
                {
                    _strFaxFailedScripts += "^" + FolderId;
                }
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "Source function PrintPrescription() of Prescribe Screen";
                else
                    ex.Data["CustomExceptionInformation"] = "";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);

            }

        }




        #endregion



        protected void ButtonCancel_Click(object sender, EventArgs e)
        {

        }

        /// <summary>
        /// Added by Sonia
        /// Purpose : This event handler is called from Javascript when user clicks on Cancel Button of Prescribe Screen
        ///  </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void ButtonDeleteMedications_Click(object sender, EventArgs e)
        {
            ClientMedication objClientMedication = null;
            Streamline.UserBusinessServices.DataSets.DataSetClientMedications dsClientMedications = null;
            DataSet dsTemp = null;
            try
            {
                //Added by Chandan for the task #85 - 1.7.2 - Prescribe Window Changes
                objClientMedication = new ClientMedication();
                objClientMedication.DeleteTempTables(Session.SessionID);

                Session["DataSetPrescribedClientMedications"] = null;
                if (((HiddenField)Parent.FindControl("HiddenFieldRedirectFrom")).Value.ToUpper() == "DASHBOARD")
                    ScriptManager.RegisterStartupScript(LabelClientScript, LabelClientScript.GetType(), ClientID.ToString(), "redirectToStartPage();", true);
                else
                    ScriptManager.RegisterStartupScript(LabelClientScript, LabelClientScript.GetType(), ClientID.ToString(), "redirectToManagementPage();", true);

            }


            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Event Name -ButtonCancel_Click()";
                else
                    ex.Data["CustomExceptionInformation"] = "";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);
                if (((HiddenField)Parent.FindControl("HiddenFieldRedirectFrom")).Value.ToUpper() == "DASHBOARD")
                    ScriptManager.RegisterStartupScript(LabelClientScript, LabelClientScript.GetType(), ClientID.ToString(), "redirectToStartPage();", true);
                else
                    ScriptManager.RegisterStartupScript(LabelClientScript, LabelClientScript.GetType(), ClientID.ToString(), "redirectToManagementPage();", true);
            }
            finally
            {
                Session["DataSetPrescribedClientMedications"] = null;
                Session["medicationIdList"] = null;
                dsClientMedications = null;
                dsTemp = null;
            }
        }
        /// <summary>
        /// Added by Sonia to get and render the RDLC Contents of Script in PDF format or images
        /// </summary>
        /// <param name="ScriptId"></param>
        /// <param name="ToBeFaxed"></param>
        /// <param name="FlagForImagesDeletion"></param>
        /// <param name="OrderingMethod"></param>
        public void GetRDLCContents(int ScriptId, bool ToBeFaxed, bool FlagForImagesDeletion, string OrderingMethod, string SendCoveLetter, string RefillResponseType)
        {
            #region Get RDLC Contents

            string _ReportPath = "";
            string mimeType;
            string encoding;
            string fileNameExtension;
            string[] streams;

            //Added by Chandan for the task 2404 -1.7.2 - Prescribe Page: Print Chart Copy
            string _PrintChartCopy = "N";
            //Modified by Loveena in ref to Task#3243 Sure Script:- Include Chart copy option is not working.
            //if (CheckBoxPrintChartCopy.Checked == true)
            if (Session["IncludeChartcopy"] == "Y")
                _PrintChartCopy = "Y";
            else
                _PrintChartCopy = "N";

            //DataSet _DataSetRdl;

            //Code Added by Vikas Vyas 
            DataSet _DataSetGetRdlCName = null;
            DataSet _DataSetRdlForMainReport = null;
            DataSet _DataSetRdlForSubReport = null;
            DataRow[] dr = null;
            DataRow[] _drSubReport = null;
            string _OrderingMethod = "";
            string strErrorMessage = "";
            LogManager objLogManager = null;

            ReportParameter[] _RptParam = null;
            int LocationId = 1;
            //End
            //Block For ReportPath
            reportViewer1 = new Microsoft.Reporting.WebForms.ReportViewer();

            try
            {

                _ReportPath = Server.MapPath(".") + System.Configuration.ConfigurationManager.AppSettings["MedicationPerscriptionReportUrl"];
                if (_ReportPath == "")//Check For Report Path
                {
                    strErrorMessage = "ReportPath is Missing In WebConfig";
                    ScriptManager.RegisterStartupScript(LabelClientScript, LabelClientScript.GetType(), ClientID.ToString(), "MedicationPrescribe.ShowError('" + strErrorMessage + "', true);", true);
                    return;
                }
            }
            catch (Exception ex)
            {
                Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);

                strErrorMessage = "ReportPath Key is Missing In WebConfig";
                ScriptManager.RegisterStartupScript(LabelClientScript, LabelClientScript.GetType(), ClientID.ToString(), "MedicationPrescribe.ShowError('" + strErrorMessage + "', true);", true);
                return;

            }
            finally
            {
                objLogManager = null;

            }

            try
            {

                //  _DataSetRdl = new DataSet();//Commented by Vikas Vyas On Dated March 04 2008
                Streamline.UserBusinessServices.ClientMedication objectClientMedications = null;
                objectClientMedications = new ClientMedication();
                //Added by Chandan for getting Location Id
                //LocationId = Convert.ToInt32(DropDownListLocations.SelectedValue);
                if (_UpdateTempTables == true)
                {
                    if (DataSetClientMedications_Temp1.Tables["ClientMedicationScripts"].Rows[0]["LocationId"] != System.DBNull.Value)
                        LocationId = Convert.ToInt32(DataSetClientMedications_Temp1.Tables["ClientMedicationScripts"].Rows[0]["LocationId"]);
                }
                else
                {
                    if (DataSetClientMedications.Tables["ClientMedicationScripts"].Rows[0]["LocationId"] != System.DBNull.Value)
                        LocationId = Convert.ToInt32(DataSetClientMedications.Tables["ClientMedicationScripts"].Rows[0]["LocationId"]);
                }
                if (LocationId == 0)
                    LocationId = 1;
                #region Added by Vikas Vyas
                //Get the Name of the Rdlc,StoredProcedure from DocumentCodes,DocumentCodesRDLSubReports
                //Modifed in Ref to Task#2596.
                //if (ToBeFaxed == false)
                if (OrderingMethod == "P")
                    _DataSetGetRdlCName = objectClientMedications.GetRdlCNameDataBase(502);
                else if (OrderingMethod == "F")
                    _DataSetGetRdlCName = objectClientMedications.GetRdlCNameDataBase(501);
                else if (OrderingMethod == "X" && OriginalOrderingMethod == 'F')
                    _DataSetGetRdlCName = objectClientMedications.GetRdlCNameDataBase(502);
                else
                    _DataSetGetRdlCName = objectClientMedications.GetRdlCNameDataBase(1471);

                _DataSetGetRdlCName.Tables[0].TableName = "DocumentCodes";
                _DataSetGetRdlCName.Tables[1].TableName = "DocumentCodesRDLSubReports";


                if (_DataSetGetRdlCName.Tables["DocumentCodes"].Rows.Count > 0)
                {
                    dr = _DataSetGetRdlCName.Tables["DocumentCodes"].Select();//because DocumentCodes table only contain one row

                    //Commented by Sonia as now Ordering Method will be passed as a parameter to GetRDLC function
                    /*    if (ToBeFaxed == true)
                        _OrderingMethod = "F";
                    else
                        _OrderingMethod = "P";*/

                    _OrderingMethod = OrderingMethod;


                    //Check For Main Report
                    if ((dr[0]["DocumentName"] != DBNull.Value || !String.IsNullOrEmpty(dr[0]["DocumentName"].ToString())) && (dr[0]["ViewStoredProcedure"] != DBNull.Value || !String.IsNullOrEmpty(dr[0]["ViewStoredProcedure"].ToString())))
                    {

                        #region Get the StoredProceudreName and Execute
                        string _StoredProcedureName = "";
                        string _ReportName = "";
                        _StoredProcedureName = dr[0]["ViewStoredProcedure"].ToString();//Get the StoredProcedure Name
                        _ReportName = dr[0]["DocumentName"].ToString();

                        this.reportViewer1.ProcessingMode = Microsoft.Reporting.WebForms.ProcessingMode.Local;
                        this.reportViewer1.LocalReport.ReportPath = _ReportPath + "\\" + _ReportName + ".rdlc";
                        this.reportViewer1.LocalReport.DataSources.Clear();


                        //Get Data For Main Report
                        //One More Parameter Added by Chandan Task#85 MM1.7
                        _DataSetRdlForMainReport = objectClientMedications.GetDataForRdlC(_StoredProcedureName, ScriptId, _OrderingMethod, Convert.ToInt32(Session["OriginalDataUpdated"]), LocationId, _PrintChartCopy, Session.SessionID, RefillResponseType);
                        //Microsoft.Reporting.WebForms.ReportDataSource DataSource = new ReportDataSource("RdlReportDataSet_" + _StoredProcedureName, _DataSetRdlForMainReport.Tables[0]);


                        Microsoft.Reporting.WebForms.ReportDataSource DataSource = new Microsoft.Reporting.WebForms.ReportDataSource("RDLReportDataSet_" + _StoredProcedureName, _DataSetRdlForMainReport.Tables[0]);
                        //Added by Chandan 0n 18th Dec 2008
                        //Session["DataSetRdlTemp"] = null;
                        DataSet dstemp = (DataSet)Session["DataSetRdlTemp"];
                        if (dstemp == null)
                            dstemp = _DataSetRdlForMainReport;
                        else
                            dstemp.Merge(_DataSetRdlForMainReport);
                        Session["DataSetRdlTemp"] = dstemp;
                        HiddenFieldStoredProcedureName.Value = _StoredProcedureName;
                        HiddenFieldReportName.Value = _ReportName;

                        #endregion
                        if (_DataSetGetRdlCName.Tables["DocumentCodesRDLSubReports"].Rows.Count > 0)
                        {

                            _drSubReport = _DataSetGetRdlCName.Tables["DocumentCodesRDLSubReports"].Select();

                            reportViewer1.LocalReport.SubreportProcessing -= new Microsoft.Reporting.WebForms.SubreportProcessingEventHandler(SetSubDataSource);
                            reportViewer1.LocalReport.SubreportProcessing += new Microsoft.Reporting.WebForms.SubreportProcessingEventHandler(SetSubDataSource);

                            for (int i = 0; i < _drSubReport.Length; i++)//Loop 
                            {
                                if ((_drSubReport[i]["SubReportName"] != DBNull.Value || !String.IsNullOrEmpty(_drSubReport[i]["SubReportName"].ToString())) && (_drSubReport[i]["StoredProcedure"] != DBNull.Value || !String.IsNullOrEmpty(_drSubReport[i]["StoredProcedure"].ToString())))
                                {
                                    #region Get the StoredProcedureName For SubReport and Execute
                                    string _SubReportStoredProcedure = "";
                                    string _SubReportName = "";
                                    _SubReportStoredProcedure = _drSubReport[i]["StoredProcedure"].ToString();
                                    _SubReportName = _drSubReport[i]["SubReportName"].ToString();
                                    //Get Data For SubReport
                                    //Added By Chandan Task#85 MM #1.7
                                    _DataSetRdlForSubReport = objectClientMedications.GetDataForRdlC(_SubReportStoredProcedure, ScriptId, _OrderingMethod, Convert.ToInt32(Session["OriginalDataUpdated"]), LocationId, _PrintChartCopy, Session.SessionID, RefillResponseType);

                                    Microsoft.Reporting.WebForms.ReportDataSource rds = new Microsoft.Reporting.WebForms.ReportDataSource(_SubReportName, _DataSetRdlForSubReport.Tables[0]);
                                    reportViewer1.LocalReport.DataSources.Add(rds);
                                    string strRootPath = Server.MapPath(".");

                                    System.IO.StreamReader RdlSubReport = new System.IO.StreamReader(_ReportPath + "\\" + _SubReportName.Trim() + ".rdlc");

                                    reportViewer1.LocalReport.LoadReportDefinition(RdlSubReport);


                                    #endregion

                                }

                            }//End For Loop


                        }
                        //Code addded by Loveena in ref to Task#2597                        
                        if (OrderingMethod == "F" && ToBeFaxed == true)
                        {
                            if (_DataSetRdlForMainReport.Tables[0].Rows.Count > 0)
                            {
                                SendCoveLetter = _DataSetRdlForMainReport.Tables[0].Rows[0]["ShowCoverLetter"].ToString();
                            }
                        }
                        //Following parameters added with ref to Task 2371 SC-Support
                        _RptParam = new ReportParameter[3];
                        _RptParam[0] = new ReportParameter("ScriptId", ScriptId.ToString());
                        _RptParam[1] = new ReportParameter("OrderingMethod", OrderingMethod);
                        _RptParam[2] = new ReportParameter("CoverLetter", SendCoveLetter);

                        reportViewer1.LocalReport.SetParameters(_RptParam);

                        reportViewer1.LocalReport.Refresh();
                        reportViewer1.LocalReport.DataSources.Add(DataSource);


                    }


                }




                #endregion




                //Added by Rohit. Ref ticket#84
                string reportType = "PDF";
                IList<Stream> m_streams;
                m_streams = new List<Stream>();
                Microsoft.Reporting.WebForms.Warning[] warnings;
                string deviceInfo = "<DeviceInfo><OutputFormat>PDF</OutputFormat><StartPage>0</StartPage></DeviceInfo>";



                //Commented by Vikas Vyas In ref to 2334  
                //  reportViewer1 = new Microsoft.Reporting.WebForms.ReportViewer();
                //_DataSetRdl = objectClientMedications.GetClientMedicationRDLDataSet(ScriptId);
                //_ReportPath = Server.MapPath("RDLC\\MedicationReport.rdlc");
                //ProcessRdlReport("DataSetMedication_ssp_SCGetClientMedicationScriptDatatry", _DataSetRdl, _ReportPath, ToBeFaxed, ScriptId.ToString());
                //End
                //Added by Loveena in ref to Task#2660

                FolderId = ScriptId.ToString() + "_" + DateTime.Now.ToString("MMddyyyymmhhss");
                //Code Added by Vikas Vyas In ref to 2334
                if (ToBeFaxed == false)
                {
                    try
                    {
                        using (Streamline.BaseLayer.RDLCPrint objRDLC = new RDLCPrint())
                        {

                            //Code commented by Loveena in ref to Task#86 to avoid the problem of  image is still pending on print job then it will through a exception that can't delete image is used by another process
                            //In case of Ordering method as X Chart copy will be printed
                            if (OrderingMethod == "X")
                                //Modified in ref to Task#2660
                                //objRDLC.Run(this.reportViewer1.LocalReport, Server.MapPath("RDLC\\" + Context.User.Identity.Name), ScriptId.ToString(), FlagForImagesDeletion, true);
                                objRDLC.Run(this.reportViewer1.LocalReport, Server.MapPath("RDLC\\" + Context.User.Identity.Name), FolderId, FlagForImagesDeletion, true);
                            else  //In case of Ordering method as P Chart copy will not be printed
                                //Modified in ref to Task#2660
                                //objRDLC.Run(this.reportViewer1.LocalReport, Server.MapPath("RDLC\\" + Context.User.Identity.Name), ScriptId.ToString(), FlagForImagesDeletion, false);
                                objRDLC.Run(this.reportViewer1.LocalReport, Server.MapPath("RDLC\\" + Context.User.Identity.Name), FolderId, FlagForImagesDeletion, false);

                            //Added by Rohit. Ref ticket#84
                            renderedBytes = reportViewer1.LocalReport.Render(reportType, deviceInfo, out mimeType, out encoding, out fileNameExtension, out streams, out warnings);

                        }
                    }
                    catch (Exception ex)
                    {
                        Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);


                    }
                    finally
                    {
                        objLogManager = null;
                    }

                }
                //if (ToBeFaxed)//Commented by Vikas Vyas In ref to 2334
                else
                {
                    //Commented by Rohit. Ref ticket#84
                    //string reportType = "PDF";
                    //IList<Stream> m_streams;
                    //m_streams = new List<Stream>();
                    //Microsoft.Reporting.WebForms.Warning[] warnings;
                    //string deviceInfo = "<DeviceInfo><OutputFormat>PDF</OutputFormat><StartPage>0</StartPage></DeviceInfo>";
                    renderedBytes = reportViewer1.LocalReport.Render(reportType, deviceInfo, out mimeType, out encoding, out fileNameExtension, out streams, out warnings);
                    // Create PDF from rendered Bytes to send as an attachment
                    string strScriptRenderingPath = Server.MapPath("RDLC") + "\\" + Context.User.Identity.Name;
                    //  string strPath = "RDLC\\" + 
                    if (!System.IO.Directory.Exists(strScriptRenderingPath))
                        System.IO.Directory.CreateDirectory(strScriptRenderingPath);
                    Stream fs = new FileStream(strScriptRenderingPath + "\\MedicationScript.pdf", FileMode.Create);
                    fs.Write(renderedBytes, 0, renderedBytes.Length);
                    fs.Close();
                }


            }
            catch (Exception ex)
            {
                Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);

            }
            finally
            {
                //    //Added by Vikas Vyas In ref to task 2334 On Dated March 04th 2008

                _DataSetGetRdlCName = null;
                _DataSetRdlForMainReport = null;
                _DataSetRdlForSubReport = null;
                _RptParam = null;
                ////End
            }

            #endregion
        }

        /// <summary>
        /// Author Vikas Vyas
        /// Purpose To render the Sub report of RDLC
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        public void SetSubDataSource(object sender, Microsoft.Reporting.WebForms.SubreportProcessingEventArgs e)
        {
            try
            {
                Microsoft.Reporting.WebForms.LocalReport rptTemp = (Microsoft.Reporting.WebForms.LocalReport)sender;
                //Condition added by Loveena in ref to Task#2596
                if (rptTemp.DataSources[e.ReportPath.Trim()] != null)
                {
                    DataTable dtTemp = (DataTable)rptTemp.DataSources[e.ReportPath.Trim()].Value;
                    e.DataSources.Add(new Microsoft.Reporting.WebForms.ReportDataSource(e.DataSourceNames[0], dtTemp));
                }
            }
            catch (Exception ex)
            {
                Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);

            }




        }

        #region "Update Temp DataSet"
        /// <summary>Created by Chandan
        /// Task #85 MM 1.7 - Prescribe Window Changes
        /// Created a Temporary Dataset as replica of original dataset with key values 
        /// </summary>
        /// <returns></returns>
        public bool DocumentUpdateTempDataSet()
        {
            Session["OrderGotChangedFromElectronic"] = null;
            Session["OriginalDataUpdated"] = 0;
            _UpdateTempTables = true;
            string FileName = "";
            int seq = 1;
            DataTable DataTableClientMedicationsNCSampleORStockDrugs;
            DataTable DataTableClientMedicationsNCNonSampleORStockDrugs;
            DataTable DataTableClientMedicationsC2SampleORStockDrugs;
            DataTable DataTableClientMedicationsC2NonSampleORStockDrugs;
            DataTable DataTableClientMedicationsControlledSampleORStockDrugs;
            DataTable DataTableClientMedicationsControlledNonSampleORStockDrugs;
            bool _strScriptsTobeFaxedButPrinted = false;
            DataSet DataSetPharmacies;
            DataRow[] drSelectedPharmacy;
            DataRow[] DataRowsClientMedeicationsCategory2Drugs = null;
            DataRow[] DataRowsClientMedicationsNormalCategoryDrugs = null;
            DataRow[] DataRowsClientMedicationsControlledCategoryDrugs = null;
            DataSet DataSetTempLocal = null;
            _scriptMessageContainer.Clear();
            string _strPrintChartCopy = null;
            _strPrintChartCopy = Session["IncludeChartcopy"] == "Y" ? "true" : "false";
            string strSendCoverLetter = "false";
            string _strMedicationInstructionIds = "";

            try
            {
                HiddenFieldShowError.Value = "";
                _DrugsOrderMethod = Request.Form["txtButtonValue"].ToString();
                Session["_DrugsOrderMethod"] = _DrugsOrderMethod;
                if (Session["DataSetPrescribedClientMedications"] != null)
                {
                    //Ref to Task#2660
                    if (System.Configuration.ConfigurationSettings.AppSettings["SaveJpegOutput"].ToLower() == "true")
                    {
                        if (System.IO.Directory.Exists(Server.MapPath("RDLC\\" + Context.User.Identity.Name)))
                        {
                            if (
                                !System.IO.Directory.Exists(
                                    Server.MapPath("RDLC\\" + Context.User.Identity.Name + "\\JPEGS")))
                                System.IO.Directory.CreateDirectory(
                                    Server.MapPath("RDLC\\" + Context.User.Identity.Name + "\\JPEGS"));

                            foreach (
                                string file in
                                    Directory.GetFiles(Server.MapPath("RDLC\\" + Context.User.Identity.Name + "\\")))
                            {
                                FileName = file.Substring(file.LastIndexOf("\\") + 1);
                                if ((FileName.IndexOf("JPEG") >= 0 || FileName.IndexOf("jpeg") >= 0))
                                {
                                    while (seq < 1000)
                                    {
                                        seq = seq + 1;
                                        if (
                                            !System.IO.File.Exists(
                                                Server.MapPath("RDLC\\" + Context.User.Identity.Name + "\\JPEGS") + "\\" +
                                                FileName))
                                        {
                                            System.IO.File.Move(file,
                                                Server.MapPath("RDLC\\" + Context.User.Identity.Name + "\\JPEGS") + "\\" +
                                                FileName);
                                            break;
                                        }
                                        else
                                        {
                                            FileName = ApplicationCommonFunctions.GetFileName(FileName, seq);
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else
                    {
                        try
                        {
                            using (Streamline.BaseLayer.RDLCPrint objRDLC = new RDLCPrint())
                            {
                                objRDLC.DeleteRenderedImages(Server.MapPath("RDLC\\" + Context.User.Identity.Name));
                            }
                        }
                        catch (Exception ex)
                        {
                            Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General,
                                LogManager.LoggingLevel.Error, this);
                        }
                    }

                    ObjectClientMedication = new ClientMedication();
                    DataSetClientMedications_Temp1 =
                        (Streamline.UserBusinessServices.DataSets.DataSetClientMedications)
                            Session["DataSetPrescribedClientMedications"];
                    DataSetClientMedications_Temp =
                        (Streamline.UserBusinessServices.DataSets.DataSetClientMedications)
                            DataSetClientMedications_Temp1.Copy();

                    if (((HiddenField)Parent.FindControl("HiddenFieldRedirectFrom")).Value.ToUpper() == "DASHBOARD" &&(
                        _DrugsOrderMethod.ToUpper() == "REFILL")) //|| _DrugsOrderMethod.ToUpper() == "CHANGEAPPROVALORDER"
                    {
                        HiddenField pharmacyid = (HiddenField)Page.FindControl("HiddenFieldRefillPharmacyId");
                        string Pharmacyid = pharmacyid.Value.ToString();
                        RadioButtonFaxToPharmacy.Enabled = false;
                        RadioButtonElectronic.Checked = true;
                        RadioButtonPrintScript.Enabled = false;
                        RadioButtonElectronic.Enabled = false;
                        ImageSearch.Visible = false;
                        CheckBoxPrintDrugInformation.Enabled = false;
                        RadioButtonPrintScript.Enabled = false;
                        DataColumn[] dcDataTableClientMedications = new DataColumn[1];
                        dcDataTableClientMedications[0] =
                            DataSetClientMedications_Temp.Tables["ClientMedications"].Columns["ClientMedicationId"];
                        DataSetClientMedications_Temp.Tables["ClientMedications"].PrimaryKey =
                            dcDataTableClientMedications;
                        DataSetClientMedications_Temp.Tables["ClientMedicationInteractions"].Clear();
                        DataSetClientMedications_Temp.Tables["ClientMedicationInteractionDetails"].Clear();
                    }

                    if (((HiddenField)Parent.FindControl("HiddenFieldRedirectFrom")).Value.ToUpper() == "DASHBOARD" &&
                        (_DrugsOrderMethod.ToUpper() == "NEW ORDER" ))
                    {
                        HiddenField pharmacyid = (HiddenField)Page.FindControl("HiddenFieldRefillPharmacyId");
                        string Pharmacyid = pharmacyid.Value.ToString();
                        RadioButtonFaxToPharmacy.Enabled = false;
                        RadioButtonElectronic.Checked = true;
                        RadioButtonPrintScript.Enabled = false;
                        RadioButtonElectronic.Enabled = false;

                        if (Pharmacyid != "" && DropDownListPharmacies.Items.Contains(new ListItem(Pharmacyid)))
                            DropDownListPharmacies.SelectedValue = Convert.ToInt32(Pharmacyid).ToString();

                        DropDownListPharmacies.Enabled = false;
                        DropDownListPrinterDeviceLocations.Enabled = false;
                        ImageSearch.Visible = false;
                        CheckBoxPrintDrugInformation.Enabled = false;
                        RadioButtonPrintScript.Enabled = false;
                    }

                    OrderingMethod =
                        Convert.ToChar(
                            DataSetClientMedications_Temp1.Tables["ClientMedicationScripts"].Rows[0]["OrderingMethod"]
                                .ToString());
                    PrintDrugInformation =
                        Convert.ToChar(
                            DataSetClientMedications_Temp1.Tables["ClientMedicationScripts"].Rows[0][
                                "PrintDrugInformation"].ToString());
                    VerbalOrderReadBack =
                        Convert.ToChar(
                            DataSetClientMedications_Temp1.Tables["ClientMedicationScripts"].Rows[0][
                                "VerbalOrderReadBack"].ToString());
                    StaffLicenseDegreeId = DataSetClientMedications_Temp1.Tables["ClientMedicationScripts"].Rows[0][
                                "StaffLicenseDegreeId"].ToString();

                    if (DataSetClientMedications_Temp1.Tables["ClientMedicationScripts"].Rows[0]["LocationId"] !=
                        System.DBNull.Value)
                        LocationId =
                            Convert.ToInt32(
                                DataSetClientMedications_Temp1.Tables["ClientMedicationScripts"].Rows[0]["LocationId"]);

                    _DataTableClientMedications = DataSetClientMedications_Temp.Tables["ClientMedications"];
                    _DataTableClientMedicationInstructions =
                        DataSetClientMedications_Temp.Tables["ClientMedicationInstructions"];
                    _DataTableClientMedicationScriptDrugs =
                        DataSetClientMedications_Temp.Tables["ClientMedicationScriptDrugs"];
                    _DataTableClientMedicationScriptDrugStrengths =
                        DataSetClientMedications_Temp.Tables["ClientMedicationScriptDrugStrengths"];

                    //Find out Category2,NormalCategory and ControlledCategoryDrugss
                    DataRowsClientMedeicationsCategory2Drugs = _DataTableClientMedications
                        .Select("(ISNULL(RecordDeleted,'N')='N') and (DrugCategory='2')", " [ClientMedicationId] DESC ");
                    DataRowsClientMedicationsNormalCategoryDrugs = _DataTableClientMedications
                        .Select(
                            "(ISNULL(RecordDeleted,'N')='N') and (DrugCategory IS NULL OR (DrugCategory<>'2' AND DrugCategory<>'3'  AND DrugCategory<>'4' AND DrugCategory<>'5') OR DrugCategory='') ",
                            " [ClientMedicationId] DESC ");
                    DataRowsClientMedicationsControlledCategoryDrugs = _DataTableClientMedications
                        .Select(
                            "(ISNULL(RecordDeleted,'N')='N') and (DrugCategory='3' OR DrugCategory='4' OR DrugCategory='5')",
                            " [ClientMedicationId] DESC ");

                    DataTableClientMedicationsC2NonSampleORStockDrugs = null;
                    DataTableClientMedicationsControlledNonSampleORStockDrugs = null;
                    DataTableClientMedicationsNCNonSampleORStockDrugs = null;
                    DataTableClientMedicationsNCNonSampleORStockDrugs = _DataTableClientMedications.Clone();
                    DataTableClientMedicationsC2NonSampleORStockDrugs = _DataTableClientMedications.Clone();
                    DataTableClientMedicationsControlledNonSampleORStockDrugs = _DataTableClientMedications.Clone();

                    //Normal Category Drugs
                    try
                    {
                        if (DataRowsClientMedicationsNormalCategoryDrugs.Length > 0)
                        {
                            foreach (DataRow dr in DataRowsClientMedicationsNormalCategoryDrugs)
                            {
                                _strMedicationInstructionIds = "";
                                DataRow[] drInstructions =
                                    _DataTableClientMedicationInstructions.Select("ClientMedicationId=" +
                                                                                  Convert.ToInt32(
                                                                                      dr["ClientMedicationId"].ToString()));
                                foreach (DataRow dr1 in drInstructions)
                                {
                                    _strMedicationInstructionIds += (_strMedicationInstructionIds != "" ? "," : "") +
                                                                    dr1["ClientMedicationInstructionId"].ToString();
                                }
                                if (_strMedicationInstructionIds != "")
                                {
                                    DataRow[] dr2 =
                                        _DataTableClientMedicationScriptDrugs.Select(
                                            "ClientMedicationInstructionId in(" +
                                            _strMedicationInstructionIds +
                                            ") and (Pharmacy+Sample+Stock>0)  and ISNULL(AutoCalcAllow,'Y')='Y' ");
                                    DataRow[] dr3 =
                                        _DataTableClientMedicationScriptDrugs.Select(
                                            "ClientMedicationInstructionId in(" +
                                            _strMedicationInstructionIds + ") and ISNULL(AutoCalcAllow,'N')='N' ");
                                    if (dr2.Length > 0 || dr3.Length > 0)
                                        DataTableClientMedicationsNCNonSampleORStockDrugs.Rows.Add(dr.ItemArray);
                                }
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                    }
                    finally
                    {
                        //DataRows to be disposed
                    }

                    //Category 2 Drugs
                    if (DataRowsClientMedeicationsCategory2Drugs.Length > 0)
                    {
                        foreach (DataRow dr in DataRowsClientMedeicationsCategory2Drugs)
                        {
                            _strMedicationInstructionIds = "";
                            DataRow[] drInstructions =
                                _DataTableClientMedicationInstructions.Select("ClientMedicationId=" +
                                                                              Convert.ToInt32(
                                                                                  dr["ClientMedicationId"].ToString()));
                            foreach (DataRow dr1 in drInstructions)
                            {
                                _strMedicationInstructionIds += (_strMedicationInstructionIds != "" ? "," : "") +
                                                                dr1["ClientMedicationInstructionId"].ToString();
                            }
                            if (_strMedicationInstructionIds != "")
                            {
                                DataRow[] dr2 =
                                    _DataTableClientMedicationScriptDrugs.Select("ClientMedicationInstructionId in(" +
                                                                                 _strMedicationInstructionIds +
                                                                                 ") and (Pharmacy+Sample+Stock>0) and ISNULL(AutoCalcallow,'Y')='Y'");
                                DataRow[] dr3 =
                                    _DataTableClientMedicationScriptDrugs.Select("ClientMedicationInstructionId in(" +
                                                                                 _strMedicationInstructionIds +
                                                                                 ") and ISNULL(AutoCalcallow,'N')='N'");
                                if (dr2.Length > 0 || dr3.Length > 0)
                                    DataTableClientMedicationsC2NonSampleORStockDrugs.Rows.Add(dr.ItemArray);
                            }
                        }
                    }

                    //Controlled Drugs
                    if (DataRowsClientMedicationsControlledCategoryDrugs.Length > 0)
                    {
                        foreach (DataRow dr in DataRowsClientMedicationsControlledCategoryDrugs)
                        {
                            _strMedicationInstructionIds = "";
                            DataRow[] drInstructions =
                                _DataTableClientMedicationInstructions.Select("ClientMedicationId=" +
                                                                              Convert.ToInt32(
                                                                                  dr["ClientMedicationId"].ToString()));
                            foreach (DataRow dr1 in drInstructions)
                            {
                                _strMedicationInstructionIds += (_strMedicationInstructionIds != "" ? "," : "") +
                                                                dr1["ClientMedicationInstructionId"].ToString();
                            }
                            if (_strMedicationInstructionIds != "")
                            {
                                //Changed the Logic to include those Medications in Script as well where Pharm<=0 but (Pharmacy+Sample+Stock) Should be >0
                                DataRow[] dr2 =
                                    _DataTableClientMedicationScriptDrugs.Select("ClientMedicationInstructionId in(" +
                                                                                 _strMedicationInstructionIds + ")");
                                if (dr2.Length > 0)
                                    DataTableClientMedicationsControlledNonSampleORStockDrugs.Rows.Add(dr.ItemArray);
                            }
                        }
                    }

                    dsTemp = new DataSet();
                    dsTemp.Merge(DataTableClientMedicationsC2NonSampleORStockDrugs);
                    if (dsTemp.Tables.Count > 0)
                        dsTemp.Tables[0].TableName = "ClientMedicationsC2NonSampleORStockDrugs";
                    else
                        dsTemp.Merge(new DataTable("ClientMedicationsC2NonSampleORStockDrugs"));

                    dsTemp.Merge(DataTableClientMedicationsNCNonSampleORStockDrugs);
                    if (dsTemp.Tables.Count > 1)
                        dsTemp.Tables[1].TableName = "ClientMedicationsNCNonSampleORStockDrugs";
                    else
                        dsTemp.Merge(new DataTable("ClientMedicationsNCNonSampleORStockDrugs"));

                    dsTemp.Merge(DataTableClientMedicationsControlledNonSampleORStockDrugs);
                    if (dsTemp.Tables.Count > 2)
                        dsTemp.Tables[2].TableName = "ClientMedicationsControlledNonSampleORStockDrugs";
                    else
                        dsTemp.Merge(new DataTable("ClientMedicationsControlledNonSampleORStockDrugs"));

                    int _Category2Drugs = 0;
                    int _OtherCategoryDrugs = 0;
                    int _ControlledDrugs = 0;
                    int nCategory2ScriptCount = 0;
                    int nOtherCategoryScriptCount = 0;
                    int nControlledScriptCount = 0;
                    int iMedicationRowsCount = 0;
                    int __OtherCategorySampleOrStockDrugs = 0;
                    int _Category2SampleOrStockDrugs = 0;
                    int _ControlledSampleOrStockDrugs = 0;
                    int nCategory2SampleORStockScriptCount = 0;
                    int nOtherCategorySampleORStockScriptCount = 0;
                    int nControlledSampleORStockScriptCount = 0;
                    int iloopCounter = 0;

                    if (dsTemp.Tables["ClientMedicationsC2NonSampleORStockDrugs"] != null)
                        _Category2Drugs = dsTemp.Tables["ClientMedicationsC2NonSampleORStockDrugs"].Rows.Count;

                    if (dsTemp.Tables["ClientMedicationsNCNonSampleORStockDrugs"] != null)
                        _OtherCategoryDrugs = dsTemp.Tables["ClientMedicationsNCNonSampleORStockDrugs"].Rows.Count;

                    if (dsTemp.Tables["ClientMedicationsControlledNonSampleORStockDrugs"] != null)
                        _ControlledDrugs = dsTemp.Tables["ClientMedicationsControlledNonSampleORStockDrugs"].Rows.Count;

                    nCategory2ScriptCount = _Category2Drugs;
                    nOtherCategoryScriptCount = ScriptsCount(_OtherCategoryDrugs);
                    nControlledScriptCount = _ControlledDrugs;
                    int NoOfRowsToBeCopied = 0;


                    // Generate Category2Scripts
                    //insert records in ClientMedycationScriptDrugStrengths for C2 MEdications
                    //on basis of Script generated
                    foreach (DataRow dr in dsTemp.Tables["ClientMedicationsC2NonSampleORStockDrugs"].Rows)
                    {
                        DataRow[] drClientMedicationDrugStrength = DataSetClientMedications_Temp.Tables[
                            "ClientMedicationScriptDrugStrengths"]
                            .Select("ClientMedicationID=" + dr["clientMedicationId"]);
                        if (drClientMedicationDrugStrength.Length > 0)
                        {
                            foreach (DataRow drDrugStrength in drClientMedicationDrugStrength)
                            {
                                DataSetClientMedications_Temp.Tables["ClientMedicationScriptDrugStrengths"].Rows.Remove(
                                    drDrugStrength);
                            }
                        }
                    }
                    NoOfRowsToBeCopied = 0;
                    bool isScript = false;
                    for (int i = 0; i < dsTemp.Tables["ClientMedicationsC2NonSampleORStockDrugs"].Rows.Count; i++)
                    {
                        DataRow[] dtrowInstructions = DataSetClientMedications_Temp.Tables[
                            "ClientMedicationInstructions"]
                            .Select("ClientMedicationId=" + dsTemp.Tables["ClientMedicationsC2NonSampleORStockDrugs"].
                                Rows[i]["ClientMedicationId"] + " and Active='Y'", "StartDate Asc");
                        if (dtrowInstructions.Length > 0)
                        {
                            for (int index = 0; index < dtrowInstructions.Length; index++)
                            {
                                if (index > 0)
                                {
                                    if (dtrowInstructions[index - 1]["StartDate"].ToString() !=
                                        dtrowInstructions[index]["StartDate"].ToString())
                                    {
                                        iMedicationRowsCount = 0;
                                        iMedicationRowsCount = dsTemp.Tables["ClientMedicationsC2NonSampleORStockDrugs"].Rows.Count;
                                        GenerateScriptsTableRows('N', iMedicationRowsCount,
                                            dsTemp.Tables["ClientMedicationsC2NonSampleORStockDrugs"],
                                            NoOfRowsToBeCopied, "C2");
                                        NoOfRowsToBeCopied = NoOfRowsToBeCopied + 1;
                                        DataRow[] drScriptInstructions = DataSetClientMedications_Temp.Tables[
                                            "ClientMedicationScriptDrugs"]
                                            .Select("ClientMedicationInstructionId=" +
                                                    dtrowInstructions[index]["ClientMedicationInstructionId"]);
                                        if (drScriptInstructions.Length > 0)
                                            drScriptInstructions[0]["ClientMedicationScriptId"] = scriptId;

                                        DataRow dataRowClientMEdicationScriptDrugStrengths =
                                            DataSetClientMedications_Temp.Tables["ClientMedicationScriptDrugStrengths"]
                                                .NewRow();
                                        int id = 0;
                                        if (
                                            DataSetClientMedications_Temp.Tables["ClientMedicationScriptDrugStrengths"]
                                                .Rows.Count > 0)
                                        {
                                            id =
                                                Convert.ToInt32(
                                                    DataSetClientMedications_Temp.Tables[
                                                        "ClientMedicationScriptDrugStrengths"].Compute(
                                                            "Min(ClientMedicationScriptDrugStrengthId)", ""));
                                            dataRowClientMEdicationScriptDrugStrengths[
                                                "ClientMedicationScriptDrugStrengthId"] = id > 0 ? -1 : id - 1;
                                        }
                                        else
                                            dataRowClientMEdicationScriptDrugStrengths[
                                                "ClientMedicationScriptDrugStrengthId"] = id;

                                        dataRowClientMEdicationScriptDrugStrengths["ClientMedicationScriptId"] =
                                            scriptId;
                                        dataRowClientMEdicationScriptDrugStrengths["ClientMedicationId"] =
                                            dtrowInstructions[index]["ClientMedicationId"];
                                        dataRowClientMEdicationScriptDrugStrengths["StrengthId"] =
                                            dtrowInstructions[index]["StrengthId"];
                                        dataRowClientMEdicationScriptDrugStrengths["Pharmacy"] =
                                            drScriptInstructions[0]["Pharmacy"];
                                        dataRowClientMEdicationScriptDrugStrengths["PharmacyText"] =
                                            drScriptInstructions[0]["PharmacyText"];
                                        dataRowClientMEdicationScriptDrugStrengths["Sample"] =
                                            drScriptInstructions[0]["Sample"];
                                        dataRowClientMEdicationScriptDrugStrengths["Stock"] =
                                            drScriptInstructions[0]["Stock"];
                                        dataRowClientMEdicationScriptDrugStrengths["Refills"] = 0;
                                        dataRowClientMEdicationScriptDrugStrengths["RowIdentifier"] =
                                            System.Guid.NewGuid();
                                        dataRowClientMEdicationScriptDrugStrengths["CreatedBy"] =
                                            ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                                        dataRowClientMEdicationScriptDrugStrengths["CreatedDate"] = DateTime.Now;
                                        dataRowClientMEdicationScriptDrugStrengths["ModifiedBy"] =
                                            ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                                        dataRowClientMEdicationScriptDrugStrengths["ModifiedDate"] = DateTime.Now;
                                        DataSetClientMedications_Temp.Tables["ClientMedicationScriptDrugStrengths"].Rows
                                            .Add(dataRowClientMEdicationScriptDrugStrengths);
                                        isScript = true;
                                    }
                                    else
                                    {
                                        if (isScript == false)
                                        {
                                            iMedicationRowsCount = 0;
                                            iMedicationRowsCount = dsTemp.Tables["ClientMedicationsC2NonSampleORStockDrugs"].Rows.Count;
                                            GenerateScriptsTableRows('N', iMedicationRowsCount,
                                                dsTemp.Tables["ClientMedicationsC2NonSampleORStockDrugs"],
                                                NoOfRowsToBeCopied, "C2");
                                            NoOfRowsToBeCopied = NoOfRowsToBeCopied + 1;
                                            DataRow[] drScriptInstructions = DataSetClientMedications_Temp.Tables[
                                                "ClientMedicationScriptDrugs"]
                                                .Select("ClientMedicationInstructionId=" +
                                                        dtrowInstructions[index]["ClientMedicationInstructionId"]);
                                            if (drScriptInstructions.Length > 0)
                                                drScriptInstructions[0]["ClientMedicationScriptId"] = scriptId;
                                            //insert records in ClientMedycationScriptDrugStrengths for C2 MEdications
                                            //on basis of Script generated
                                            DataRow dataRowClientMEdicationScriptDrugStrengths =
                                                DataSetClientMedications_Temp.Tables[
                                                    "ClientMedicationScriptDrugStrengths"].NewRow();
                                            int id = 0;
                                            if (
                                                DataSetClientMedications_Temp.Tables[
                                                    "ClientMedicationScriptDrugStrengths"].Rows.Count > 0)
                                            {
                                                id =
                                                    Convert.ToInt32(
                                                        DataSetClientMedications_Temp.Tables[
                                                            "ClientMedicationScriptDrugStrengths"].Compute(
                                                                "Min(ClientMedicationScriptDrugStrengthId)", ""));
                                                dataRowClientMEdicationScriptDrugStrengths[
                                                    "ClientMedicationScriptDrugStrengthId"] = id > 0 ? -1 : id - 1;
                                            }
                                            else
                                                dataRowClientMEdicationScriptDrugStrengths[
                                                    "ClientMedicationScriptDrugStrengthId"] = id;

                                            dataRowClientMEdicationScriptDrugStrengths["ClientMedicationScriptId"] =
                                                scriptId;
                                            dataRowClientMEdicationScriptDrugStrengths["ClientMedicationId"] =
                                                dtrowInstructions[index]["ClientMedicationId"];
                                            dataRowClientMEdicationScriptDrugStrengths["StrengthId"] =
                                                dtrowInstructions[index]["StrengthId"];
                                            dataRowClientMEdicationScriptDrugStrengths["Pharmacy"] =
                                                drScriptInstructions[0]["Pharmacy"];
                                            dataRowClientMEdicationScriptDrugStrengths["PharmacyText"] =
                                                drScriptInstructions[0]["PharmacyText"];
                                            dataRowClientMEdicationScriptDrugStrengths["Sample"] =
                                                drScriptInstructions[0]["Sample"];
                                            dataRowClientMEdicationScriptDrugStrengths["Stock"] =
                                                drScriptInstructions[0]["Stock"];
                                            dataRowClientMEdicationScriptDrugStrengths["Refills"] = 0;
                                            dataRowClientMEdicationScriptDrugStrengths["RowIdentifier"] =
                                                System.Guid.NewGuid();
                                            dataRowClientMEdicationScriptDrugStrengths["CreatedBy"] =
                                                ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity)
                                                    .UserCode;
                                            dataRowClientMEdicationScriptDrugStrengths["CreatedDate"] = DateTime.Now;
                                            dataRowClientMEdicationScriptDrugStrengths["ModifiedBy"] =
                                                ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity)
                                                    .UserCode;
                                            dataRowClientMEdicationScriptDrugStrengths["ModifiedDate"] = DateTime.Now;
                                            DataSetClientMedications_Temp.Tables["ClientMedicationScriptDrugStrengths"]
                                                .Rows.Add(dataRowClientMEdicationScriptDrugStrengths);
                                            isScript = true;
                                        }
                                        else
                                        {
                                            DataRow[] drScriptInstructions =
                                                DataSetClientMedications_Temp.Tables["ClientMedicationScriptDrugs"]
                                                    .Select("ClientMedicationInstructionId=" +
                                                            dtrowInstructions[index]["ClientMedicationInstructionId"]);
                                            if (drScriptInstructions.Length > 0)
                                            {
                                                drScriptInstructions[0]["ClientMedicationScriptId"] = scriptId;
                                            }
                                        }
                                    }
                                }
                                else
                                {
                                    iMedicationRowsCount = 0;
                                    iMedicationRowsCount = dsTemp.Tables["ClientMedicationsC2NonSampleORStockDrugs"].Rows.Count;
                                    GenerateScriptsTableRows('N', iMedicationRowsCount,
                                        dsTemp.Tables["ClientMedicationsC2NonSampleORStockDrugs"], NoOfRowsToBeCopied,
                                        "C2");
                                    NoOfRowsToBeCopied = NoOfRowsToBeCopied + 1;
                                    DataRow[] drScriptInstructions = DataSetClientMedications_Temp.Tables[
                                        "ClientMedicationScriptDrugs"]
                                        .Select("ClientMedicationInstructionId=" +
                                                dtrowInstructions[index]["ClientMedicationInstructionId"]);
                                    if (drScriptInstructions.Length > 0)
                                        drScriptInstructions[0]["ClientMedicationScriptId"] = scriptId;

                                    DataRow dataRowClientMEdicationScriptDrugStrengths =
                                        DataSetClientMedications_Temp.Tables["ClientMedicationScriptDrugStrengths"]
                                            .NewRow();
                                    int id = 0;
                                    if (
                                        DataSetClientMedications_Temp.Tables["ClientMedicationScriptDrugStrengths"].Rows
                                            .Count > 0)
                                    {
                                        id =
                                            Convert.ToInt32(
                                                DataSetClientMedications_Temp.Tables[
                                                    "ClientMedicationScriptDrugStrengths"].Compute(
                                                        "Min(ClientMedicationScriptDrugStrengthId)", ""));
                                        dataRowClientMEdicationScriptDrugStrengths[
                                            "ClientMedicationScriptDrugStrengthId"] = id > 0 ? -1 : id - 1;
                                    }
                                    else
                                        dataRowClientMEdicationScriptDrugStrengths[
                                            "ClientMedicationScriptDrugStrengthId"] = id;

                                    dataRowClientMEdicationScriptDrugStrengths["ClientMedicationScriptId"] = scriptId;
                                    dataRowClientMEdicationScriptDrugStrengths["ClientMedicationId"] =
                                        dtrowInstructions[index]["ClientMedicationId"];
                                    dataRowClientMEdicationScriptDrugStrengths["StrengthId"] =
                                        dtrowInstructions[index]["StrengthId"];
                                    dataRowClientMEdicationScriptDrugStrengths["Pharmacy"] =
                                        drScriptInstructions[0]["Pharmacy"];
                                    dataRowClientMEdicationScriptDrugStrengths["PharmacyText"] =
                                        drScriptInstructions[0]["PharmacyText"];
                                    dataRowClientMEdicationScriptDrugStrengths["Sample"] =
                                        drScriptInstructions[0]["Sample"];
                                    dataRowClientMEdicationScriptDrugStrengths["Stock"] =
                                        drScriptInstructions[0]["Stock"];
                                    dataRowClientMEdicationScriptDrugStrengths["Refills"] = 0;
                                    dataRowClientMEdicationScriptDrugStrengths["RowIdentifier"] = System.Guid.NewGuid();
                                    dataRowClientMEdicationScriptDrugStrengths["CreatedBy"] =
                                        ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                                    dataRowClientMEdicationScriptDrugStrengths["CreatedDate"] = DateTime.Now;
                                    dataRowClientMEdicationScriptDrugStrengths["ModifiedBy"] =
                                        ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                                    dataRowClientMEdicationScriptDrugStrengths["ModifiedDate"] = DateTime.Now;
                                    DataSetClientMedications_Temp.Tables["ClientMedicationScriptDrugStrengths"].Rows.Add
                                        (dataRowClientMEdicationScriptDrugStrengths);
                                    isScript = true;
                                }
                            }
                        }
                    }

                    // Generate OtherCategoryScripts
                    NoOfRowsToBeCopied = 0;
                    int RowsToBeCopiedincrmtcount = 3;

                    DataSet DatasetSystemConfigurationKeys = null;
                    Streamline.DataService.SharedTables objSharedTables = new Streamline.DataService.SharedTables();
                    DatasetSystemConfigurationKeys = objSharedTables.GetSystemConfigurationKeys();
                    if (objSharedTables.GetSystemConfigurationKeys("PRINTFOURPRESCRIPTIONSPERPAGE", DatasetSystemConfigurationKeys.Tables[0]).ToUpper() == "YES")
                    {
                        RowsToBeCopiedincrmtcount = 4;
                    }


                    for (int icount = 1; icount <= nOtherCategoryScriptCount; icount++)
                    {
                        iMedicationRowsCount = 0;
                        iloopCounter = 0;
                        iMedicationRowsCount = dsTemp.Tables["ClientMedicationsNCNonSampleORStockDrugs"].Rows.Count;
                        GenerateScriptsTableRows('N', iMedicationRowsCount,
                            dsTemp.Tables["ClientMedicationsNCNonSampleORStockDrugs"], NoOfRowsToBeCopied, "NC");
                        NoOfRowsToBeCopied = NoOfRowsToBeCopied + RowsToBeCopiedincrmtcount;
                    }

                    // Generate ControlledCategoryScripts
                    NoOfRowsToBeCopied = 0;
                    for (int icount = 1; icount <= nControlledScriptCount; icount++)
                    {
                        iMedicationRowsCount = 0;
                        iloopCounter = 0;
                        iMedicationRowsCount =
                            dsTemp.Tables["ClientMedicationsControlledNonSampleORStockDrugs"].Rows.Count;
                        GenerateScriptsTableRows('N', iMedicationRowsCount,
                            dsTemp.Tables["ClientMedicationsControlledNonSampleORStockDrugs"], NoOfRowsToBeCopied, "CT");
                        NoOfRowsToBeCopied = NoOfRowsToBeCopied + 1;
                    }

                    try
                    {
                        DataTable clientMedicationScriptsToRemove = DataSetClientMedications_Temp.Tables["ClientMedicationScripts"].Clone();
                        foreach (DataRow dr in DataSetClientMedications_Temp.Tables["ClientMedicationScripts"].Rows)
                        {
                            if (dr["ScriptEventType"].ToString().IsNullOrWhiteSpace())
                            {
                                if (_DrugsOrderMethod == "Change" || _DrugsOrderMethod == "CHANGE")
                                    dr["ScriptEventType"] = "C";
                                else if (_DrugsOrderMethod == "Refill" || _DrugsOrderMethod == "REFILL")
                                    dr["ScriptEventType"] = "R";
                                else if (_DrugsOrderMethod.ToUpper() == "APPROVEWITHCHANGESCHANGEORDER")
                                {
                                    dr["ScriptEventType"] = "C";
                                }
                                else if (_DrugsOrderMethod.ToUpper() == "CHANGEAPPROVALORDER")
                                {
                                    dr["ScriptEventType"] = "A";
                                }
                                else
                                    dr["ScriptEventType"] = "N";

                            }
                            //Vithobha Added below code to update default value of OrderingPrescriberId, OrderingPrescriberName in ClientMedicationScripts, Bear River - Environment Issues Tracking: #148  
                            if (DataSetClientMedications_Temp.Tables["ClientMedications"].Rows[0]["PrescriberId"].ToString() != DataSetClientMedications_Temp.Tables["ClientMedicationScripts"].Rows[0]["OrderingPrescriberId"].ToString())
                            {
                                DataSetClientMedications_Temp.Tables["ClientMedicationScripts"].Rows[0]["OrderingPrescriberId"] = DataSetClientMedications_Temp.Tables["ClientMedications"].Rows[0]["PrescriberId"].ToString();
                                DataSetClientMedications_Temp.Tables["ClientMedicationScripts"].Rows[0]["OrderingPrescriberName"] = DataSetClientMedications_Temp.Tables["ClientMedications"].Rows[0]["PrescriberName"].ToString();
                            }
                            clientMedicationScriptsToRemove.Rows.Add(dr.ItemArray);
                        }

                        foreach (DataRow dr in clientMedicationScriptsToRemove.Rows)
                        {
                            if (dr != null)
                            {
                                if (
                                    DataSetClientMedications_Temp.Tables["ClientMedicationScriptDrugStrengths"].Select(
                                        "ClientMedicationScriptId = " + dr["ClientMedicationScriptId"].ToString()) !=
                                    null &&
                                    DataSetClientMedications_Temp.Tables["ClientMedicationScriptDrugStrengths"].Select(
                                        "ClientMedicationScriptId = " + dr["ClientMedicationScriptId"].ToString())
                                        .Count() <=
                                    0)
                                {
                                    if (
                                        DataSetClientMedications_Temp.Tables["ClientMedicationScriptDrugStrengths"].Select(
                                            "ClientMedicationScriptId='" + dr["ClientMedicationScriptId"].ToString() +
                                            "'").Count() <= 0)
                                    {
                                        DataSetClientMedications_Temp.Tables["ClientMedicationScripts"].Select(
                                            "ClientMedicationScriptId='" + dr["ClientMedicationScriptId"].ToString() +
                                            "'")[0].Delete();
                                    }
                                }
                            }
                        }
                    }
                    catch (Exception exp)
                    {
                    }

                    DataSetTemp = new DataSet();
                    if (_DrugsOrderMethod == "Refill" || _DrugsOrderMethod == "REFILL") //|| _DrugsOrderMethod.ToUpper() == "CHANGEAPPROVALORDER"
                    {
                        if (DataSetClientMedications_Temp.Tables["ClientMedications"] != null)
                        {
                            DataSetClientMedications_Temp.Tables["ClientMedications"].AcceptChanges();
                            for (int i = 0;
                                i <= DataSetClientMedications_Temp.Tables["ClientMedications"].Rows.Count - 1;
                                i++)
                            {
                                DataSetClientMedications_Temp.Tables["ClientMedications"].Rows[i].SetAdded();
                            }
                        }
                        if (DataSetClientMedications_Temp.Tables["ClientMedicationInstructions"] != null)
                        {
                            DataSetClientMedications_Temp.Tables["ClientMedicationInstructions"].AcceptChanges();
                            for (int i = 0;
                                i <= DataSetClientMedications_Temp.Tables["ClientMedicationInstructions"].Rows.Count - 1;
                                i++)
                            {
                                DataSetClientMedications_Temp.Tables["ClientMedicationInstructions"].Rows[i].SetAdded();
                            }
                        }
                    }
                    //Wasif Butt -  I Think this needs to be removed 
                    if (OrderingMethod == 'E')
                    {
                        foreach (
                            DataRow drCM in
                                DataSetClientMedications_Temp.ClientMedications.Select("DrugCategory <> '2'"))
                        {
                            foreach (
                                DataRow drCMSDS in
                                    DataSetClientMedications_Temp.ClientMedicationScriptDrugStrengths.Select(
                                        "ClientMedicationId=" + drCM["ClientMedicationId"]))
                            {
                                foreach (
                                    DataRow drCMI in DataSetClientMedications_Temp.ClientMedicationInstructions.Select(
                                        "ClientMedicationId=" + drCM["ClientMedicationId"] + "and StrengthId=" +
                                        drCMSDS["StrengthId"]))
                                {
                                    foreach (
                                        DataRow drCMSD in
                                            DataSetClientMedications_Temp.ClientMedicationScriptDrugs.Select(
                                                "ClientMedicationInstructionId=" +
                                                drCMI["ClientMedicationInstructionId"]))
                                    {
                                        drCMSD["ClientMedicationScriptId"] = drCMSDS["ClientMedicationScriptId"];
                                    }
                                }
                            }
                        }
                    }
                    // Insert SessionId in each table for Report View
                    if (DataSetClientMedications_Temp != null)
                    {
                        foreach (DataRow dr in DataSetClientMedications_Temp.ClientMedications)
                        {
                            dr["SessionId"] = Session.SessionID;
                        }
                        foreach (DataRow dr in DataSetClientMedications_Temp.ClientMedicationInstructions)
                        {
                            dr["SessionId"] = Session.SessionID;
                        }
                        foreach (DataRow dr in DataSetClientMedications_Temp.ClientMedicationScripts)
                        {
                            dr["SessionId"] = Session.SessionID;
                        }
                        foreach (DataRow dr in DataSetClientMedications_Temp.ClientMedicationScriptDrugs)
                        {
                            dr["SessionId"] = Session.SessionID;
                        }
                        foreach (DataRow dr in DataSetClientMedications_Temp.ClientMedicationScriptDrugStrengths)
                        {
                            dr["SessionId"] = Session.SessionID;
                        }
                    }

                    DataSetClientMedications_Temp.Tables["ClientMedicationScripts"].Rows[0]["PharmacyId"] = DataSetClientMedications_Temp1.Tables["ClientMedicationScripts"].Rows[0]["PharmacyId"];


                    DataSetTemp = ObjectClientMedication.UpdateTempDocuments(DataSetClientMedications_Temp, false,
                        Session.SessionID);

                    DataSet DataSetTempNew = new DataSet();

                    if (DataSetTemp.Tables.Contains("ClientMedicationScripts"))
                    {
                        if (DataSetTemp.Tables["ClientMedicationScripts"].Rows.Count > 0)
                        {
                            for (int _Count = 0;
                                _Count < DataSetTemp.Tables["ClientMedicationScripts"].Rows.Count;
                                _Count++)
                            {
                                string _OrderingMethod = string.Empty;
                                string _OrderingMethodAllowed = string.Empty;
                                if (
                                    DataSetTemp.Tables["ClientMedicationScripts"].Rows[_Count]["OrderingMethod"]
                                        .ToString() != string.Empty)
                                {
                                    _OrderingMethod =
                                        DataSetTemp.Tables["ClientMedicationScripts"].Rows[_Count]["OrderingMethod"]
                                            .ToString();
                                }

                                if (_OrderingMethod.ToUpper() == "E" || _OrderingMethod.ToUpper() == "F")
                                {
                                    int _ClientMedicationScriptId = 0;
                                    _ClientMedicationScriptId =
                                        Convert.ToInt32(DataSetTemp.Tables["ClientMedicationScripts"]
                                            .Rows[_Count]["ClientMedicationScriptId"].ToString());
                                    int _ClientMedicationScriptIdTemp = 0;
                                    _ClientMedicationScriptIdTemp = Convert.ToInt32(DataSetClientMedications_Temp
                                        .Tables["ClientMedicationScripts"].Rows[_Count]["ClientMedicationScriptId"]
                                        .ToString());

                                    if (_ClientMedicationScriptId != 0)
                                    {
                                        DataRow[] dr =
                                            DataSetTemp.Tables["ClientMedicationScripts"].Select(
                                                "ClientMedicationScriptId=" + _ClientMedicationScriptId);
                                        DataSet DataSetTempOrderingMethodAllowed =
                                            GetOrderingMethodAllowed(_ClientMedicationScriptId);
                                        if (DataSetTempOrderingMethodAllowed != null)
                                        {
                                            if (
                                                DataSetTempOrderingMethodAllowed.Tables["OrderingMethodAllowed"].Rows
                                                    .Count > 0)
                                            {
                                                _OrderingMethodAllowed =
                                                    DataSetTempOrderingMethodAllowed.Tables["OrderingMethodAllowed"]
                                                        .Rows[0]["OrderingMethodAllowed"].ToString();
                                                // #ka 03312011 Added for each loop to handle multiple messages ACE # 3348
                                                foreach (
                                                    DataRow drOMA in
                                                        DataSetTempOrderingMethodAllowed.Tables["OrderingMethodAllowed"]
                                                            .Rows)
                                                {
                                                    _scriptMessageContainer.Add(new ScriptMessageContainer
                                                    {
                                                        MessageId = drOMA["ClientMedicationScriptId"].ToString(),
                                                        Message = drOMA["ScriptMessage"].ToString()
                                                    });
                                                }
                                            }
                                        }
                                        if (_OrderingMethod != _OrderingMethodAllowed)
                                        {
                                            if (dr.Length > 0)
                                            {
                                                dr[0].BeginEdit();
                                                dr[0]["OrderingMethod"] = _OrderingMethodAllowed;
                                                dr[0]["ModifiedBy"] =
                                                    ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity)
                                                        .UserCode;
                                                dr[0]["ModifiedDate"] = DateTime.Now;
                                                dr[0].EndEdit();
                                            }

                                            if (_OrderingMethod == "E")
                                            {
                                                //Session["OrderGotChangedFromElectronic"] = "Y";
                                            }
                                        }
                                        else if (_OrderingMethod.ToUpper().Equals("E") &&
                                                 _DrugsOrderMethod.ToUpper() == "CHANGE")
                                        {
                                            foreach (
                                                DataRow drStrength in
                                                    DataSetTemp.Tables["ClientMedicationScriptDrugStrengths"].Select
                                                        (
                                                            "ClientMedicationScriptId=" +
                                                            _ClientMedicationScriptId.ToString()))
                                            {
                                                foreach (
                                                    DataRow drCancelled in
                                                        DataSetTemp.Tables["ClientMedications"].Select(
                                                            "ClientMedicationId=" +
                                                            drStrength[
                                                                "ClientMedicationId"]
                                                                .ToString() +
                                                            " and isnull(SureScriptsOutgoingMessageId,-1) > 0")
                                                    )
                                                {
                                                    _scriptMessageContainer.Add(new ScriptMessageContainer
                                                    {
                                                        MessageId = _ClientMedicationScriptId.ToString(),
                                                        Message =
                                                            "There is currently an active medication that was sent to:<br />" +
                                                            drCancelled["PharmacyName"].ToString() +
                                                            "<br />the previous medication will be canceled and a new script will be sent"
                                                    });
                                                }
                                            }

                                        }
                                    }
                                }
                            }

                            int prescriberid = 0;
                            if (Convert.ToString( DataSetClientMedications_Temp.Tables["ClientMedications"].Rows[0]["PrescriberId"]) != null &&
                                Convert.ToString( DataSetClientMedications_Temp.Tables["ClientMedications"].Rows[0]["PrescriberId"]) != "")
                            {
                                prescriberid = Convert.ToInt32( DataSetClientMedications_Temp.Tables["ClientMedications"].Rows[0]["PrescriberId"].ToString());
                            }

                            ProcessScripts(0, prescriberid, OrderingMethod, DataSetTemp);
                            if (DataSetTemp != null)
                            {
                                if (DataSetTemp.Tables.Count > 0)
                                {
                                    if (DataSetTemp.Tables["ClientMedicationScripts"].Rows.Count > 0)
                                    {
                                        DataSetTempLocal =
                                            ObjectClientMedication.UpdateClientMedicationScriptPreview(DataSetTemp);
                                    }
                                }
                            }
                        }
                    }
                    ObjectClientMedication = null;
                    //Below code was added by Vithobha for EPCS: #2 04.A1-Logical Controls of Prescription
                    bool ePrescription = false;
                    for (int icount = 0; icount < DataSetClientMedications_Temp.Tables["ClientMedicationScripts"].Rows.Count; icount++)
                    {
                        if (DataSetClientMedications_Temp.Tables["ClientMedicationScripts"].Rows[icount]["OrderingMethod"] != null && (DataSetClientMedications_Temp.Tables["ClientMedicationScripts"].Rows[icount]["OrderingMethod"].ToString() == "E"))
                        {
                            ePrescription = true;
                            break;
                        }
                    }

                    DataRow[] drDEACodeforControlledSubstance = DataSetClientMedications_Temp.Tables["ClientMedications"].Select("DrugCategory IN ('1','2','3','4','5')");

                    if (ePrescription && ((StreamlinePrinciple)Context.User).HasPermission(Permissions.EPCS) && drDEACodeforControlledSubstance.Count() > 0)
                    {
                        Session["ePrescription"] = true;
                    }
                    else
                    {
                        Session["ePrescription"] = null;
                    }
                    //if (Session["ePrescription"] != null && Session["ePrescription"].ToString() == "True")
                    //{
                    Session["ElectronicScriptIds"] = null;
                    Session["ElectronicScriptTempIds"] = null;
                    Session["DataSetTemp"] = DataSetTemp;
                    Session["OrderingMethod"] = OrderingMethod;
                    //int PharmacyId = 0;
                    for (int icount = 0; icount < DataSetTemp.Tables["ClientMedicationScripts"].Rows.Count; icount++)
                    {
                        _strScriptIds += (_strScriptIds != "" ? "," : "") + DataSetTemp.Tables["ClientMedicationScripts"].Rows[icount]["ClientMedicationScriptId"];
                        if (!ElectronicScriptMappingIds.ContainsKey(Convert.ToString(DataSetTemp.Tables["ClientMedicationScriptDrugStrengths"].Rows[icount]["ClientMedicationScriptId"])))
                            ElectronicScriptMappingIds.Add(DataSetTemp.Tables["ClientMedicationScriptDrugStrengths"].Rows[icount]["ClientMedicationScriptId"].ToString(), DataSetClientMedications_Temp.Tables["ClientMedicationScriptDrugStrengths"].Rows[icount]["ClientMedicationScriptId"].ToString());
                    }

                    Session["ElectronicScriptIds"] = _strScriptIds;
                    Session["ElectronicScriptTempIds"] = ElectronicScriptMappingIds;
                    Session["HiddenFieldRedirectFrom"] = ((HiddenField)Parent.FindControl("HiddenFieldRedirectFrom")).Value.ToString();
                    Session["HiddenFieldClickedImage"] = ((HiddenField)Parent.FindControl("HiddenFieldClickedImage")).Value.ToString();
                    Session["HiddenFieldPharmacyFaxNo"] = ((HiddenField)(Parent.FindControl("HiddenFieldPharmacyFaxNo"))).Value.ToString();
                    Panel1.Controls.Add(Page.LoadControl("~/UserControls/SubstancesList.ascx"));
                    Session["ClientId"] = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId;
                }
                else
                    ScriptManager.RegisterStartupScript(LabelClientScript, LabelClientScript.GetType(), ClientID.ToString(), "redirectToLoginPage();", true);

                return true; //true should be returned only if document has been updated successfully reference Task #50 MM1.5
            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally
            {
                DataSetClientScriptActivities = null;
                DataSetClientMedications_Temp = null;
                _DataTableClientMedications = null;
                _DataSetClientSummary = null;
                _DataTableClientMedicationInstructions = null;
                DataTableClientMedicationsNCSampleORStockDrugs = null;
                DataTableClientMedicationsNCNonSampleORStockDrugs = null;
                DataTableClientMedicationsC2SampleORStockDrugs = null;
                DataTableClientMedicationsC2NonSampleORStockDrugs = null;
                DataSetPharmacies = null;
                drSelectedPharmacy = null;
                dsTemp = null;
                DataRowsClientMedeicationsCategory2Drugs = null;
                DataRowsClientMedicationsNormalCategoryDrugs = null;
                DataRowsClientMedicationsControlledCategoryDrugs = null;
                _strPrintChartCopy = null;
                _strMedicationInstructionIds = null;
                counter = 0;
                DataSetTempLocal = null;
                Session["DataSetTempPrescribedClientMedications"] = null;
            }
        }

        #endregion


        /// <summary>
        /// Created by Chandan on 4th Dec 2088
        /// task #85 Build MM1.7
        /// showing rdl without update the databse</summary>
        /// <param name="_strScriptIds"></param>
        /// <param name="_strChartScriptIds"></param>
        public void ShowReport(string _strScriptIds, string _strChartScriptIds)
        {
            FileStream fs;
            TextWriter ts;
            ArrayList ScriptArrays;
            ArrayList ChartScriptArrays;
            bool _strFaxSendStatus = false;
            string _strFaxFaildMessage = "";
            string[] ClientMedicationscriptIds;
            ArrayList ScriptIdScriptMessage;
            string[] ScriptIds;
            string[] ScriptMessage;
            string[] ScriptIdMessage;
            ArrayList _arrListScriptId = null;
            ArrayList _arrListScriptMessage = null;
            ArrayList _arrListClientMedicationScriptId = null;
            ArrayList _arrListClintMedicationScriptId = null;



            try
            {
                string strPath = "";
                string FileName = "";
                fs = new FileStream(Server.MapPath("RDLC\\" + Context.User.Identity.Name + "\\Report.html"), FileMode.Create);
                ts = new StreamWriter(fs);
                divReportViewer.InnerHtml = "";

                string strPageHtml = "";
                ScriptArrays = new ArrayList();
                ScriptArrays = ApplicationCommonFunctions.StringSplit(_strScriptIds, "^");

                ChartScriptArrays = new ArrayList();
                ChartScriptArrays = ApplicationCommonFunctions.StringSplit(_strChartScriptIds, "^");

                #region--Code Added by Pradeep as on 21 Jan22011 as per task#3306

                if (_scriptMessageContainer.Count > 0)
                {
                    _arrListClintMedicationScriptId = new ArrayList();
                    //Getting ClientMedication ScriptId which is going to be prescribed start over here
                    if (_strScriptIds.IndexOf("^") > 0)
                    {
                        ClientMedicationscriptIds = _strScriptIds.Split('^');
                        for (int _count = 0; _count < ClientMedicationscriptIds.Length; _count++)
                        {
                            string[] clientMedicationScriptId = ClientMedicationscriptIds[_count].Split('_');
                            _arrListClintMedicationScriptId.Add(clientMedicationScriptId[0]);
                        }
                    }
                    else
                    {
                        string[] clientMedicationScriptId = _strScriptIds.Split('_');
                        _arrListClintMedicationScriptId.Add(clientMedicationScriptId[0]);
                    }

                    _arrListScriptId = new ArrayList();
                    _arrListScriptMessage = new ArrayList();
                    foreach (ScriptMessageContainer scriptMessageContainer in _scriptMessageContainer)
                    {
                        _arrListScriptId.Add(scriptMessageContainer.MessageId);
                        _arrListScriptMessage.Add(scriptMessageContainer.Message);
                    }
                }


                #endregion
                for (int i = 0; i < ScriptArrays.Count; i++)
                {
                    #region--Code Added by Pradeep as on 21 Jan22011 as per task#3306

                    if (_scriptMessageContainer.Count > 0)
                    {
                        if (_arrListClintMedicationScriptId.Count > 0 && _arrListScriptId.Count > 0)
                        {
                            // #ka 03312011 Added internal loop to break out multiple messages ACE # 3348
                            for (int i2 = 0, len = _arrListScriptId.Count; i2 < len; i2++)
                            {
                                if (_arrListClintMedicationScriptId[i].ToString() == _arrListScriptId[i2].ToString())
                                {

                                    if (_arrListScriptMessage[i2].ToString() != string.Empty)
                                    {
                                        StringBuilder stringBuilderObject = new StringBuilder();
                                        stringBuilderObject.Append("<table><tr><td");
                                        stringBuilderObject.Append(" ");
                                        stringBuilderObject.Append("style='font-family: Verdana; font-size:8pt;font-weight: bold;padding-left: 10px;margin-top: 10px; color:red;'");
                                        stringBuilderObject.Append(">");
                                        stringBuilderObject.Append(_arrListScriptMessage[i2]);
                                        stringBuilderObject.Append("</td></tr></table>");
                                        strPageHtml += stringBuilderObject;
                                    }

                                }
                            }
                        }
                    }
                    #endregion

                    foreach (string file in Directory.GetFiles(Server.MapPath("RDLC\\" + Context.User.Identity.Name + "\\")))
                    {
                        FileName = file.Substring(file.LastIndexOf("\\") + 1);
                        if ((FileName.IndexOf("JPEG") >= 0 || FileName.IndexOf("jpeg") >= 0) && (FileName.IndexOf(ScriptArrays[i].ToString(), 3) >= 0))
                            strPageHtml += "<img src='.\\RDLC\\" + Context.User.Identity.Name + "\\" + FileName + "'/>";
                        strPath = "'..\\RDLC\\" + Context.User.Identity.Name + "\\" + FileName;
                    }
                }

                ////Get the Images from ChartScripts Folder
                for (int i = 0; i < ChartScriptArrays.Count; i++)
                {
                    if (
                        Directory.Exists(
                            Server.MapPath("RDLC\\" + Context.User.Identity.Name + "\\" + "ChartScripts" + "\\")))
                    {
                        foreach (
                            string file in
                                Directory.GetFiles(
                                    Server.MapPath("RDLC\\" + Context.User.Identity.Name + "\\" + "ChartScripts" + "\\"))
                            )
                        {
                            FileName = file.Substring(file.LastIndexOf("\\") + 1);
                            if ((FileName.IndexOf("JPEG") >= 0 || FileName.IndexOf("jpeg") >= 0) &&
                                (FileName.IndexOf(ChartScriptArrays[i].ToString()) >= 0))
                                strPageHtml += "<img src='.\\RDLC\\" + Context.User.Identity.Name + "\\" +
                                               "ChartScripts" + "\\" + FileName + "'/>";
                            strPath = "'..\\RDLC\\" + Context.User.Identity.Name + "\\" + "ChartScripts" + "\\" +
                                      FileName;
                        }
                    }
                }

                divReportViewer.InnerHtml = "";
                divReportViewer.InnerHtml = strPageHtml;

                ts.Close();

            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally
            {
                _arrListScriptId = null;
                _arrListScriptMessage = null;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="ScriptId"></param>
        /// <param name="strSendCoverLetter"></param>
        /// ----------Modification History-----------------------------
        /// ------Date------Author--------Pyrpose----------------------
        /// 14 March 2011   Pradeep       Addedd one more parameter as per task#3336
        public void FaxChartCopyPreview(int ScriptId, string strSendCoverLetter, string RefillResponseType)
        {
            try
            {
                GetRDLCContentsFax(ScriptId, true, true, "F", strSendCoverLetter, RefillResponseType);
                _strChartCopiesToBePrinted = true;
                if (_strScriptIds == "")
                {
                    _strScriptIds += FolderId;
                }
                else
                {
                    _strScriptIds += "^" + FolderId;
                }
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "Source function PrintChartCopy() of Prescribe Screen";
                else
                    ex.Data["CustomExceptionInformation"] = "";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);

            }

        }

        /// <summary>
        ///   Pranay Bodhu
        ///   Purpose of ProcessScripts-To change the ordering method of scripts accordingly w.r.t PharmacyEPC/NON-EPCS, OrderingMethod, Prescriber Permissions..
        /// </summary>
        /// <Date>01/30/2018</Date>
        /// <returns></returns>
        public void ProcessScripts(int PharmacyId, int PrescriberId, char OrderingMethod, DataSet DataSetClientMedications_Temp)
        {
			string OrderType = _DrugsOrderMethod.ToUpper();
            Hashtable ht_Get_DDL_Values = new Hashtable();
            string ElectricPrescriptionPermissions = "";
            string PresciberSPID = "";
            string PharmacySPID = "";
            string PharmactServiceLevel = "";
            int LoggedInStaffId = ((StreamlineIdentity)Context.User.Identity).UserId;
            try
            {
                if (Session["PrescriberPharmacyPermissions"] != null)
                {
                    ht_Get_DDL_Values = (Hashtable)Session["PrescriberPharmacyPermissions"];
                    ElectricPrescriptionPermissions = ht_Get_DDL_Values.ContainsKey("ElectricPrescriptionPermissions") ? Convert.ToString(ht_Get_DDL_Values["ElectricPrescriptionPermissions"]) : "";
                    PresciberSPID = ht_Get_DDL_Values.ContainsKey("PresciberSPID") ? Convert.ToString(ht_Get_DDL_Values["PresciberSPID"]) : "";
                    PharmacySPID = ht_Get_DDL_Values.ContainsKey("PharmacySPID") ? Convert.ToString(ht_Get_DDL_Values["PharmacySPID"]) : "";
                    PharmactServiceLevel = ht_Get_DDL_Values.ContainsKey("PharmactServiceLevel") ? Convert.ToString(ht_Get_DDL_Values["PharmactServiceLevel"]) : "";
                }
                DataRow[] rowsNonControlledDrugs = DataSetClientMedications_Temp.Tables["ClientMedicationScriptDrugs"].Select(
                               "(ISNULL(RecordDeleted,'N')='N') and (DrugCategory IS NULL OR (DrugCategory<>'2' AND DrugCategory<>'3'  AND DrugCategory<>'4' AND DrugCategory<>'5') OR DrugCategory='') ",
                               " [ClientMedicationScriptId] DESC ");

                DataRow[] rowsControlledDrugs = DataSetClientMedications_Temp.Tables["ClientMedicationScriptDrugs"].Select(
                        "(ISNULL(RecordDeleted,'N')='N') and (DrugCategory='2' OR DrugCategory='3' OR DrugCategory='4' OR DrugCategory='5')",
                        " [ClientMedicationScriptId] DESC ");

                DataTable tableClientMedicationScripts = DataSetClientMedications_Temp.Tables["ClientMedicationScripts"];

                if (OrderingMethod == 'P')   //Radio button Print selected then all the scripts gets printed.
                {
                        foreach (
                            DataRow _dataRowClientMedicationScript in
                                tableClientMedicationScripts.Select(" isnull(recorddeleted,'N') <> 'Y'"))
                        {
                            _dataRowClientMedicationScript["OrderingMethod"] = 'P';
                        }
                        
                                HiddenFieldAllFaxed.Value = "1";
                }
                if (OrderingMethod == 'E') // Radio button Send Directly to Pharmacy selected then all the scripts gets printed/Electric based on the permissions
                {
                    if (Convert.ToInt32(PharmactServiceLevel) >= 2048 && ElectricPrescriptionPermissions == "Y" && LoggedInStaffId == PrescriberId)
                    {
                        foreach (
                            DataRow _dataRowClientMedicationScript in
                                tableClientMedicationScripts.Select(" isnull(recorddeleted,'N') <> 'Y'"))
                        {
                            _dataRowClientMedicationScript["OrderingMethod"] = 'E';
                        }
                    }


                    else if (!string.IsNullOrEmpty(PresciberSPID) && !string.IsNullOrEmpty(PharmacySPID))
                    {

                        if (rowsControlledDrugs.Length > 0)
                        {
                            foreach (DataRow drScripts in tableClientMedicationScripts.Rows)
                            {
                                foreach (DataRow drControllDrug in rowsControlledDrugs)
                                {
                                    if (drScripts["ClientMedicationScriptId"].ToString() == drControllDrug["ClientMedicationScriptId"].ToString())
                                    {
                                        drScripts["OrderingMethod"] = "P";
                                    }

                                }
                            }
                        }
                        //Non-Controlled Drug Order Method
                        if (rowsNonControlledDrugs.Length > 0)
                        {
                            foreach (DataRow drScripts in tableClientMedicationScripts.Rows)
                            {
                                foreach (DataRow drNonControllDrug in rowsNonControlledDrugs)
                                {
                                    if (drScripts["ClientMedicationScriptId"].ToString() == drNonControllDrug["ClientMedicationScriptId"].ToString())
                                    {
                                        drScripts["OrderingMethod"] = "E";
                                    }
                                }
                            }
                        }

                    }

                    else
                    {
                        foreach (DataRow _dataRowClientMedicationScript in
                                    tableClientMedicationScripts.Select(" isnull(recorddeleted,'N') <> 'Y'"))
                        {
                            _dataRowClientMedicationScript["OrderingMethod"] = 'P';
                        }
                    }

                }

                if (System.Configuration.ConfigurationSettings.AppSettings.AllKeys.Contains("FaxScheduledCategoryList") && ElectricPrescriptionPermissions != "Y" && OrderingMethod !='P')
                {
                    string FaxScheduledCategoryList = System.Configuration.ConfigurationSettings.AppSettings["FaxScheduledCategoryList"].ToString();
                    foreach (DataRow drClientMedicationScriptDrugs in DataSetClientMedications_Temp.Tables["ClientMedicationScriptDrugs"].Select("isnull(recorddeleted,'N') <> 'Y' and DrugCategory in (" + FaxScheduledCategoryList + ")")) //Sent as FAX based on key values 'FaxScheduledCategoryList'
                    {
                        foreach (
                            DataRow _dataRowClientMedicationScript in
                               DataSetClientMedications_Temp.Tables["ClientMedicationScripts"].Select(
                                    "ClientMedicationScriptId=" +
                                    drClientMedicationScriptDrugs["ClientMedicationScriptId"] +
                                    " and isnull(recorddeleted,'N') <> 'Y'"))
                        {
                            _dataRowClientMedicationScript["OrderingMethod"] = 'F';
                        }
                    }
                }
				if (OrderType == "REFILL")
                {
                    foreach (DataRow drClientMedicationInstructions in DataSetClientMedications_Temp.Tables["ClientMedicationInstructions"].Select("isnull(recorddeleted,'N') <> 'Y' and isnull(Active,'Y') <> 'N' and ClientMedicationInstructionId < 0 and ClientMedicationId < 0 "))
                    {

                        foreach (
                                DataRow _dataRowClientMedicationScriptDrugs in
                                   DataSetClientMedications_Temp.Tables["ClientMedicationScriptDrugs"].Select(
                                        "ClientMedicationInstructionId=" +
                                        drClientMedicationInstructions["ClientMedicationInstructionId"] +
                                        " and isnull(recorddeleted,'N') <> 'Y'"))
                        {

                            foreach (
                                DataRow _dataRowClientMedicationScript in
                                   DataSetClientMedications_Temp.Tables["ClientMedicationScripts"].Select(
                                        "ClientMedicationScriptId=" +
                                        _dataRowClientMedicationScriptDrugs["ClientMedicationScriptId"] +
                                        " and isnull(recorddeleted,'N') <> 'Y'"))
                            {
                                _dataRowClientMedicationScript["ScriptEventType"] = 'N';
                            }
                        }
                    }
                }
            }

             catch (Exception ex)
               {
                string strErrorMessage = ex.Data["CustomExceptionInformationMessage"] == null
                                                   ? "Error occured while Processing Scripts"
                                                   : ex.Data["CustomExceptionInformationMessage"].ToString();

                ex.Data["CustomExceptionInformationMessage"] = null;

                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###ClientMedicationOrder -ProcessScripts()";
                Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);
            }
        }
        

        //Ref to Task#2597
        /// <summary>
        /// 
        /// </summary>
        /// <param name="ScriptId"></param>
        /// <param name="ToBeFaxed"></param>
        /// <param name="FlagForImagesDeletion"></param>
        /// <param name="OrderingMethod"></param>
        /// <param name="SendCoveLetter"></param>
        /// ---------Modification History----------------------------------
        /// ------Date-----Author----------Purpose-------------------------
        /// 14 March 2011  Pradeep        Added one more parameter as per task#3336
        public void GetRDLCContentsFax(int ScriptId, bool ToBeFaxed, bool FlagForImagesDeletion, string OrderingMethod, string SendCoveLetter, string RefillResponseType)
        {
            #region Get RDLC Contents

            string _ReportPath = "";
            string mimeType;
            string encoding;
            string fileNameExtension;
            string[] streams;

            //Added by Chandan for the task 2404 -1.7.2 - Prescribe Page: Print Chart Copy
            string _PrintChartCopy = "N";
            //Modified by Loveena in ref to Task#3243 Sure Script:- Include Chart copy option is not working.
            //if (CheckBoxPrintChartCopy.Checked == true)
            if (Session["IncludeChartcopy"] == "Y")
                _PrintChartCopy = "Y";
            else
                _PrintChartCopy = "N";

            //DataSet _DataSetRdl;

            //Code Added by Vikas Vyas 
            DataSet _DataSetGetRdlCName = null;
            DataSet _DataSetRdlForMainReport = null;
            DataSet _DataSetRdlForSubReport = null;
            DataRow[] dr = null;
            DataRow[] _drSubReport = null;
            string _OrderingMethod = "";
            string strErrorMessage = "";
            LogManager objLogManager = null;

            ReportParameter[] _RptParam = null;
            int LocationId = 1;
            //End
            //Block For ReportPath
            reportViewer1 = new Microsoft.Reporting.WebForms.ReportViewer();

            try
            {

                _ReportPath = Server.MapPath(".") + System.Configuration.ConfigurationManager.AppSettings["MedicationPerscriptionReportUrl"];
                if (_ReportPath == "")//Check For Report Path
                {
                    strErrorMessage = "ReportPath is Missing In WebConfig";
                    ScriptManager.RegisterStartupScript(LabelClientScript, LabelClientScript.GetType(), ClientID.ToString(), "MedicationPrescribe.ShowError('" + strErrorMessage + "', true);", true);
                    return;
                }
            }
            catch (Exception ex)
            {
                Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);

                strErrorMessage = "ReportPath Key is Missing In WebConfig";
                ScriptManager.RegisterStartupScript(LabelClientScript, LabelClientScript.GetType(), ClientID.ToString(), "MedicationPrescribe.ShowError('" + strErrorMessage + "', true);", true);
                return;

            }
            finally
            {
                objLogManager = null;

            }

            try
            {

                //  _DataSetRdl = new DataSet();//Commented by Vikas Vyas On Dated March 04 2008
                Streamline.UserBusinessServices.ClientMedication objectClientMedications = null;
                objectClientMedications = new ClientMedication();
                ////Added by Chandan for getting Location Id
                //LocationId = Convert.ToInt32(DropDownListLocations.SelectedValue);
                if (_UpdateTempTables == true)
                {
                    if (DataSetClientMedications_Temp1.Tables["ClientMedicationScripts"].Rows[0]["LocationId"] != System.DBNull.Value)
                        LocationId = Convert.ToInt32(DataSetClientMedications_Temp1.Tables["ClientMedicationScripts"].Rows[0]["LocationId"]);
                }
                else
                {
                    if (DataSetClientMedications.Tables["ClientMedicationScripts"].Rows[0]["LocationId"] != System.DBNull.Value)
                        LocationId = Convert.ToInt32(DataSetClientMedications.Tables["ClientMedicationScripts"].Rows[0]["LocationId"]);
                }
                if (LocationId == 0)
                    LocationId = 1;
                #region Added by Vikas Vyas
                //Get the Name of the Rdlc,StoredProcedure from DocumentCodes,DocumentCodesRDLSubReports
                //Modifed in Ref to Task#2596.
                if (ToBeFaxed == false)
                    _DataSetGetRdlCName = objectClientMedications.GetRdlCNameDataBase(502);
                else
                    _DataSetGetRdlCName = objectClientMedications.GetRdlCNameDataBase(501);

                _DataSetGetRdlCName.Tables[0].TableName = "DocumentCodes";
                _DataSetGetRdlCName.Tables[1].TableName = "DocumentCodesRDLSubReports";


                if (_DataSetGetRdlCName.Tables["DocumentCodes"].Rows.Count > 0)
                {
                    dr = _DataSetGetRdlCName.Tables["DocumentCodes"].Select();//because DocumentCodes table only contain one row

                    //Commented by Sonia as now Ordering Method will be passed as a parameter to GetRDLC function
                    /*    if (ToBeFaxed == true)
                        _OrderingMethod = "F";
                    else
                        _OrderingMethod = "P";*/

                    _OrderingMethod = OrderingMethod;


                    //Check For Main Report
                    if ((dr[0]["DocumentName"] != DBNull.Value || !String.IsNullOrEmpty(dr[0]["DocumentName"].ToString())) && (dr[0]["ViewStoredProcedure"] != DBNull.Value || !String.IsNullOrEmpty(dr[0]["ViewStoredProcedure"].ToString())))
                    {

                        #region Get the StoredProceudreName and Execute
                        string _StoredProcedureName = "";
                        string _ReportName = "";
                        _StoredProcedureName = dr[0]["ViewStoredProcedure"].ToString();//Get the StoredProcedure Name
                        _ReportName = dr[0]["DocumentName"].ToString();

                        this.reportViewer1.ProcessingMode = Microsoft.Reporting.WebForms.ProcessingMode.Local;
                        this.reportViewer1.LocalReport.ReportPath = _ReportPath + "\\" + _ReportName + ".rdlc";
                        this.reportViewer1.LocalReport.DataSources.Clear();


                        //Get Data For Main Report
                        //One More Parameter Added by Chandan Task#85 MM1.7
                        _DataSetRdlForMainReport = objectClientMedications.GetDataForRdlC(_StoredProcedureName, ScriptId, _OrderingMethod, Convert.ToInt32(Session["OriginalDataUpdated"]), LocationId, _PrintChartCopy, Session.SessionID, RefillResponseType);
                        //Microsoft.Reporting.WebForms.ReportDataSource DataSource = new ReportDataSource("RdlReportDataSet_" + _StoredProcedureName, _DataSetRdlForMainReport.Tables[0]);


                        Microsoft.Reporting.WebForms.ReportDataSource DataSource = new Microsoft.Reporting.WebForms.ReportDataSource("RDLReportDataSet_" + _StoredProcedureName, _DataSetRdlForMainReport.Tables[0]);
                        //Added by Chandan 0n 18th Dec 2008
                        //Session["DataSetRdlTemp"] = null;
                        DataSet dstemp = (DataSet)Session["DataSetRdlTemp"];
                        if (dstemp == null)
                            dstemp = _DataSetRdlForMainReport;
                        else
                            dstemp.Merge(_DataSetRdlForMainReport);
                        Session["DataSetRdlTemp"] = dstemp;
                        HiddenFieldStoredProcedureName.Value = _StoredProcedureName;
                        HiddenFieldReportName.Value = _ReportName;

                        #endregion
                        if (_DataSetGetRdlCName.Tables["DocumentCodesRDLSubReports"].Rows.Count > 0)
                        {

                            _drSubReport = _DataSetGetRdlCName.Tables["DocumentCodesRDLSubReports"].Select();

                            reportViewer1.LocalReport.SubreportProcessing -= new Microsoft.Reporting.WebForms.SubreportProcessingEventHandler(SetSubDataSource);
                            reportViewer1.LocalReport.SubreportProcessing += new Microsoft.Reporting.WebForms.SubreportProcessingEventHandler(SetSubDataSource);

                            for (int i = 0; i < _drSubReport.Length; i++)//Loop 
                            {
                                if ((_drSubReport[i]["SubReportName"] != DBNull.Value || !String.IsNullOrEmpty(_drSubReport[i]["SubReportName"].ToString())) && (_drSubReport[i]["StoredProcedure"] != DBNull.Value || !String.IsNullOrEmpty(_drSubReport[i]["StoredProcedure"].ToString())))
                                {
                                    #region Get the StoredProcedureName For SubReport and Execute
                                    string _SubReportStoredProcedure = "";
                                    string _SubReportName = "";
                                    _SubReportStoredProcedure = _drSubReport[i]["StoredProcedure"].ToString();
                                    _SubReportName = _drSubReport[i]["SubReportName"].ToString();
                                    //Get Data For SubReport
                                    //Added By Chandan Task#85 MM #1.7
                                    _DataSetRdlForSubReport = objectClientMedications.GetDataForRdlC(_SubReportStoredProcedure, ScriptId, _OrderingMethod, Convert.ToInt32(Session["OriginalDataUpdated"]), LocationId, _PrintChartCopy, Session.SessionID, RefillResponseType);

                                    Microsoft.Reporting.WebForms.ReportDataSource rds = new Microsoft.Reporting.WebForms.ReportDataSource(_SubReportName, _DataSetRdlForSubReport.Tables[0]);
                                    reportViewer1.LocalReport.DataSources.Add(rds);
                                    string strRootPath = Server.MapPath(".");

                                    System.IO.StreamReader RdlSubReport = new System.IO.StreamReader(_ReportPath + "\\" + _SubReportName.Trim() + ".rdlc");

                                    reportViewer1.LocalReport.LoadReportDefinition(RdlSubReport);


                                    #endregion

                                }

                            }//End For Loop


                        }
                        //Code addded by Loveena in ref to Task#2597                        
                        if (OrderingMethod == "F" && ToBeFaxed == true)
                        {
                            if (_DataSetRdlForMainReport.Tables[0].Rows.Count > 0)
                            {
                                SendCoveLetter = _DataSetRdlForMainReport.Tables[0].Rows[0]["ShowCoverLetter"].ToString();
                            }
                        }
                        //Following parameters added with ref to Task 2371 SC-Support
                        _RptParam = new ReportParameter[3];
                        _RptParam[0] = new ReportParameter("ScriptId", ScriptId.ToString());
                        _RptParam[1] = new ReportParameter("OrderingMethod", OrderingMethod);
                        _RptParam[2] = new ReportParameter("CoverLetter", SendCoveLetter);
                        reportViewer1.LocalReport.SetParameters(_RptParam);

                        reportViewer1.LocalReport.Refresh();
                        reportViewer1.LocalReport.DataSources.Add(DataSource);


                    }


                }




                #endregion




                //Added by Rohit. Ref ticket#84
                string reportType = "PDF";
                IList<Stream> m_streams;
                m_streams = new List<Stream>();
                Microsoft.Reporting.WebForms.Warning[] warnings;
                string deviceInfo = "<DeviceInfo><OutputFormat>PDF</OutputFormat><StartPage>0</StartPage></DeviceInfo>";

                FolderId = ScriptId.ToString() + "_" + DateTime.Now.ToString("MMddyyyymmhhss");
                try
                {
                    using (Streamline.BaseLayer.RDLCPrint objRDLC = new RDLCPrint())
                    {
                        //In case of Ordering method as X Chart copy will be printed
                        if (OrderingMethod == "X")
                            objRDLC.Run(this.reportViewer1.LocalReport, Server.MapPath("RDLC\\" + Context.User.Identity.Name), FolderId, FlagForImagesDeletion, true);
                        else  //In case of Ordering method as P Chart copy will not be printed
                            objRDLC.Run(this.reportViewer1.LocalReport, Server.MapPath("RDLC\\" + Context.User.Identity.Name), FolderId, FlagForImagesDeletion, false);

                        //Added by Rohit. Ref ticket#84
                        renderedBytes = reportViewer1.LocalReport.Render(reportType, deviceInfo, out mimeType, out encoding, out fileNameExtension, out streams, out warnings);

                    }
                }
                catch (Exception ex)
                {
                    Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);


                }
                finally
                {
                    objLogManager = null;
                }

            }
            catch (Exception ex)
            {
                Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);

            }
            finally
            {
                //    //Added by Vikas Vyas In ref to task 2334 On Dated March 04th 2008

                _DataSetGetRdlCName = null;
                _DataSetRdlForMainReport = null;
                _DataSetRdlForSubReport = null;
                _RptParam = null;
                ////End
            }

            #endregion
        }
        /// <summary>       
        /// Added by Anuj on 19 nov,2009 for task ref #3 SDI Projects FY10 - Venture 
        ///Checking queue order button is clicked
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void ButtonQueueOrder_Click(object sender, EventArgs e)
        {
            //HiddenFieldQueueOrder.Value = "Queue";
            Streamline.UserBusinessServices.ClientMedication objectClientMedications = null;
            objectClientMedications = new ClientMedication();

            try
            {
                CommonFunctions.Event_Trap(this);
                Session["OriginalDataUpdated"] = 1;
                _Queue = true;
                objectClientMedications.DeleteTempTables(Session.SessionID); //Added  by Chandan on 4th March 2009 for task#85
                bool _DocumentUpdatedOrNot = DocumentUpdateDocument();
                if (_DocumentUpdatedOrNot == true)
                    ButtonCancel.Enabled = false;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Event Name -ButtonNewOrder_Click(), ParameterCount -2, First Parameter- " + sender + ", Second Parameter- " + e + "###";
                else
                    ex.Data["CustomExceptionInformation"] = "";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);

                string strErrorMessage = "Error occured while Updating Database";
                ScriptManager.RegisterStartupScript(LabelClientScript, LabelClientScript.GetType(), ClientID.ToString(), "MedicationPrescribe.ShowError('" + strErrorMessage + "', true);", true);
                HiddenFieldShowError.Value = "Error occured while Updating Database";
            }
            finally
            {
                //reportViewer1 = null;
                objectClientMedications = null;
            }
        }
        protected void LinkButtonLogout_Click(object sender, EventArgs e)
        {
            //----Made changes By Pradeep as per task#3329 as on 3 March 2011 Start over here 
            Session.Abandon();
            //----Made changes By Pradeep as per task#3329 as on 3 March 2011 End over here 
            Response.Redirect("MedicationLogin.aspx");
        }

        protected void setQueuedButton()
        {
            try
            {
                if (Session["DataSetClientSummary"] != null)
                {
                    _DataSetClientSummary = (DataSet)Session["DataSetClientSummary"];

                    //  Streamline.UserBusinessServices.DataSets.DataSetClientMedications DataSetClientMedications_Temp;
                    DataSetClientMedications_Temp1 = new Streamline.UserBusinessServices.DataSets.DataSetClientMedications();
                    DataSetClientMedications_Temp1 = (Streamline.UserBusinessServices.DataSets.DataSetClientMedications)Session["DataSetClientMedications"];
                    DataSetClientMedications_Temp = (Streamline.UserBusinessServices.DataSets.DataSetClientMedications)DataSetClientMedications_Temp1.Copy();
                    DataTable _DataTableClientMedications = DataSetClientMedications_Temp.Tables["ClientMedications"];
                    DataTable _DataTableClientMedicationInstructions = DataSetClientMedications_Temp.Tables["ClientMedicationInstructions"];
                    #region--Code Added by Pradeep as per task#3
                    int prescriberId = 0;
                    if (DataSetClientMedications_Temp1.Tables["ClientMedications"].Rows.Count > 0)
                    {
                        prescriberId = DataSetClientMedications_Temp1.Tables["ClientMedications"].Rows[0]["PrescriberId"] == DBNull.Value ? 0 : Convert.ToInt32(DataSetClientMedications_Temp1.Tables["ClientMedications"].Rows[0]["PrescriberId"].ToString());
                        int loggedInUserId = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId;
                        if (((Streamline.BaseLayer.StreamlinePrinciple)Context.User).HasPermission(Permissions.QueueOrder))
                        {
                            if (prescriberId == loggedInUserId)
                            {
                                ButtonQueueOrder.Enabled = false;
                            }
                            else
                            {
                                ButtonQueueOrder.Enabled = true;
                            }
                        }
                    }
                    #endregion
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        #region--Code written by Loveena as per task#3287
        /// <summary>
        /// <Description>Used to get alowed ordering method</Description>
        /// <Author>Pradeep</Author>
        /// <CreatedOn>24 Dec 2010</CreatedOn>
        /// </summary>
        /// <param name="ClientMedicationScriptId"></param>
        /// <returns></returns>
        public DataSet GetOrderingMethodAllowed(int ClientMedicationScriptId)
        {

            Streamline.UserBusinessServices.ClientMedication objectClientMedications = null;
            try
            {
                DataSet DataSetTempOrderingMethodAllowed = null;
                objectClientMedications = new ClientMedication();
                DataSetTempOrderingMethodAllowed = objectClientMedications.GetOrderingMethodAllowed(ClientMedicationScriptId);
                return DataSetTempOrderingMethodAllowed;

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        #endregion
        #region--
        /// <summary>
        /// <Description>Used to get alowed ordering method</Description>
        /// <Author>Pradeep</Author>
        /// <CreatedOn>24 Dec 2010</CreatedOn>
        /// </summary>
        /// <param name="ClientMedicationScriptId"></param>
        /// <returns></returns>
        public DataSet GetOrderingMethodAllowedFinal(int ClientMedicationScriptId)
        {

            Streamline.UserBusinessServices.ClientMedication objectClientMedications = null;
            try
            {
                DataSet DataSetTempOrderingMethodAllowed = null;
                objectClientMedications = new ClientMedication();
                DataSetTempOrderingMethodAllowed = objectClientMedications.GetOrderingMethodAllowedFinal(ClientMedicationScriptId);
                return DataSetTempOrderingMethodAllowed;

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        #endregion
        protected void ButtonPharmacyPreview_Click(object sender, EventArgs e)
        {
            string url = ResolveUrl("~/UserControls/PharmacyPreview.ascx");
            string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=1000,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=yes,titlebar=no' );";
            ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
        }
}

}



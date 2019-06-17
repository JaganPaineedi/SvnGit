using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Drawing;
using System.Drawing.Printing;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Xml.Linq;
using DevExpress.Web.ASPxEditors;
using Microsoft.Reporting.WebForms;
using Streamline.BaseLayer;
using Streamline.Faxing;
using Streamline.UserBusinessServices;
using Streamline.UserBusinessServices.DataSets;
using Image = System.Drawing.Image;
using SharedTables = Streamline.UserBusinessServices.SharedTables;
using System.Collections;

namespace Streamline.SmartClient.UI
{
    public partial class UserControls_ClientMedicationOrder : BaseActivityPage
    {
        private HiddenField ClickedImage; //Added by Pradeep as per task#3331
        private DataRow DataRowSureScriptsOutgoingMessages;
        private DataSetClientMedications DataSetClientMedications_Temp;
        private DataSetClientMedications DataSetClientMedications_Temp1;
        private DataSetClientScripts DataSetClientScriptActivities;
        private DataSet DataSetTemp;
        private DataSet DataSetTempMeds;
        private DataSetClientMedications.ClientMedicationInstructionsDataTable DataTableClientMedicationInstructions;
        private DataSetClientMedications.ClientMedicationsDataTable DataTableClientMedications;
        private DataTable DataTableSureScriptsOutgoingMessages;
        private DataView DataViewClientMedication;
        private DataView DataViewClientMedicationInstructions;
        private string FolderId = string.Empty;
        private int LocationId;
        private DataSetClientMedications ObjectClientMedication = new DataSetClientMedications();
        private char OrderingMethod;
        private char PrintDrugInformation;
        private char VerbalOrderReadBack;
        private HiddenField RedirectFrom; //Added by Pradeep as per task#3331
        private DataSet _DataSetClientSummary;
        private DataTable _DataTableClientMedicationInstructions;
        //Added By Anuj on 12 Feb,2010 for task ref 85
        private DataTable _DataTableClientMedicationScriptDrugStrengths;
        private DataTable _DataTableClientMedicationScriptDrugs;
        private DataTable _DataTableClientMedications;
        private string _DrugsOrderMethod = "";
        private bool _Queue;
        private bool _UpdateTempTables;
        //code added By Pushpita Ref: task 85 SDI Projects FY10 - Venture 
        private bool _strChartCopiesToBePrinted;
        private string _strChartScripts = "";
        private bool _strFaxFailed;
        private string _strFaxFailedScripts = ""; //added by Chandan
        private string _strScriptIds = "";
        private DataSet dsTemp;
        private HiddenField hiddenFieldConsentStatus; //Written by Pradeep as per task#12Venture10.0
        private Image imageToConvert;
        private byte[] renderedBytes;
        private ReportViewer reportViewer1;
        //Added by Chandan on 3rd Dec 2008 for task #85 MM 1.7 - Prescribe Window Changes
        private int scriptId;
        private string strReceipeintName = "";
        private string strReceipentFaxNumber = "";
        private string strReceipentOrganisation = "";
        private string strSureSriptPharmacyIdentifier = "";
        private HiddenField txtButtonValue;
        public string ToolTipTitle = "No Info";
        public HiddenField SureScriptsChangeRequestId;
        public HiddenField OrderType;

        #region--Code Added By Pradeep as per task#3205

        private ClientMedication ObjectTempClientMedication;
        private string ValidationMessage = string.Empty;
        private string ValidationStatus = string.Empty;

        #endregion

        #region Page_load

        /// <summary>
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected override void Page_Load(object sender, EventArgs e)
        {
            string UserID = (((StreamlineIdentity)Context.User.Identity)).UserId.ToString();
            string IsPrescriber = (((StreamlineIdentity)Context.User.Identity)).Prescriber.ToString();
            HiddenFieldUserId.Value = UserID;
            HiddenFieldIsPrescriber.Value = IsPrescriber;
            ButtonQueueOrder.Enabled = true;
            SureScriptsChangeRequestId = (HiddenField)Page.FindControl("HiddenFieldSureScriptChangeRequestId");
            OrderType=(HiddenField)Page.FindControl("txtButtonValue");
            DataSet datasetSystemConfigurationKeys = null;
            DataSet datasetStaffPermissions = null;  
            //Added jyothi for Task 680  
            Streamline.DataService.SharedTables objSharedTables1 = new Streamline.DataService.SharedTables();
            datasetSystemConfigurationKeys = objSharedTables1.GetSystemConfigurationKeys();
            datasetStaffPermissions = objSharedTables1.GetPermissionWithParentList((((StreamlineIdentity)Context.User.Identity)).UserId, 5921, 2, null);
            if (objSharedTables1.GetSystemConfigurationKeys("UseKeyPhrases", datasetSystemConfigurationKeys.Tables[0]).ToUpper() == "Y")
            {
                if (datasetStaffPermissions.Tables[0].Rows.Count > 0)
                {
                    if (objSharedTables1.GetPermissionWithParentList("Use Key Phrases", datasetStaffPermissions.Tables[0]).ToUpper() == "Y")
                    {
                        KeyPhrases.Visible = true;
                        aTag.Attributes.Remove("class");
                    }
                    else
                    {
                        aTag.Attributes.Add("class", "DisableKeyPharses");
                    }
                }
            }
            else
            {
                KeyPhrases.Visible = false;
            }
            try
            {
                if ((((Streamline.BaseLayer.StreamlinePrinciple)Context.User).HasPermission(Permissions.DrugFormulary)) == true)
                {
                    //var a = HiddenFieldTempPrescriberPermission.Value;
                    //HiddenFieldPrescriberPermission.Value = "True";
                    if (SureScriptsChangeRequestId.Value != "" && (OrderType.Value == "APPROVEWITHCHANGESCHANGEORDER"||OrderType.Value =="CHANGEAPPROVALORDER"))
                    {
                        HiddenFieldOrderType.Value = (OrderType.Value == "APPROVEWITHCHANGESCHANGEORDER") ? "APPROVEWITHCHANGESCHANGEORDER" : "CHANGEAPPROVALORDER";
                        HeadingMedicationList.HeadingText = "Medication List#MedicationOrderMedicationList,Formulary#MedicationOrderFormulary,ChangeOrder MedicationList#MedicationOrderChangeList";
                    }
                    else
                    {
                        HeadingMedicationList.HeadingText = "Medication List#MedicationOrderMedicationList,Formulary#MedicationOrderFormulary";
                        HiddenFieldOrderType.Value = "";
                    }
                }
                else
                {
                    //HiddenFieldPrescriberPermission.Value = "False";
                    HeadingMedicationList.HeadingText = "Medication List#MedicationOrderMedicationList";
                }
                RelativePath = Page.ResolveUrl("~");

                #region "error message color added by rohit ref. #121"

                CommonFunctions.SetErrorMegssageBackColor(LabelErrorMessage);
                CommonFunctions.SetErrorMegssageBackColor(LabelGridErrorMessage);
                CommonFunctions.SetErrorMegssageForeColor(LabelErrorMessage);
                CommonFunctions.SetErrorMegssageForeColor(LabelGridErrorMessage);
                //string CommentTextOnCheckBoxUnCheck = "Comment";
                string CommentTextOnCheckBoxUnCheck = string.Empty;
                //HiddenOrderPageCommentLabel.Value = "Comment";
                string CommentTextOnCheckBoxCheck = string.Empty;

                #endregion

                //Added by Loveena in ref to avoid the change of Tile 
                //of page incase of validations handles on Button Update

                #region added By pramod on 14 apr 2008 to show page title

                txtButtonValue = (HiddenField)Page.FindControl("txtButtonValue");
                
                DisableEnableControl();
               _DrugsOrderMethod = txtButtonValue.Value;
                Session["ButtonType"] = _DrugsOrderMethod;
                if (txtButtonValue.Value.ToUpper() == "CHANGE")
                {
                    Label1.Text = "Change Medication Order";
                }
                else if (txtButtonValue.Value.ToUpper() == "REFILL")
                {
                    Label1.Text = "Re-Order Medication Order";
                }
                else if (txtButtonValue.Value.ToUpper() == "ADJUST")
                {
                    Label1.Text = "Adjust Dosage / Schedule";
                    ButtonPrescribe.Text = "Save Adjustments";
                    ButtonPrescribe.Width = 120;
                }
                else if (txtButtonValue.Value.ToUpper() == "COMPLETE")
                {
                    Label1.Text = "Complete Medication Order";
                }
                else if (OrderType.Value == "APPROVEWITHCHANGESCHANGEORDER")
                {
                    Label1.Text = "Approving With Changes Medication Order";  
                }
                else if (OrderType.Value == "CHANGEAPPROVALORDER")
                {
                    Label1.Text = "Approving With Change Order";
                }
                else
                {
                    Label1.Text = "New Medication Order";
                }
                //changes end over here

                #endregion

                // Added new functionality that allows Dx/Purpose field to be optional based on DxPurposeIsNotMandatory application key
                HiddenFieldDxPurposeNotMandatory.Value =
                    (ConfigurationManager.AppSettings["DxPurposeIsNotMandatory"].ToUpper() == "TRUE") ? "Y" : "N";
                // Check if we're displaying dosages in the drug list
                HiddenFieldShowDosages.Value = (ConfigurationManager.AppSettings["ShowDosagesInDrugList"].ToUpper() ==
                                                "TRUE")
                                                   ? "Y"
                                                   : "N";

                if (ConfigurationManager.AppSettings["EnableRXOrderTemplates"].ToUpper() == "TRUE")
                {
                    // Load prescriber order templates
                    // Create dataset for Order templates
                    DataSetDrugOrderTemplates dsDrugOrderTemplates = null;
                    dsDrugOrderTemplates =
                        UserBusinessServices.UserInfo.GetDrugOrderTemplates(
                            ((StreamlineIdentity)Context.User.Identity).UserId);
                    Session["DrugOrderTemplates"] = dsDrugOrderTemplates;
                }

                HiddenFieldLoggedInStaffId.Value = ((StreamlineIdentity)Context.User.Identity).UserId.ToString();


                //Ref to Task#2895
                if (ConfigurationSettings.AppSettings["OpenFromSmartCare"].ToUpper() == "FALSE")
                {
                    LinkButtonLogout.Style["display"] = "block";
                    LinkButtonStartPage.Style["display"] = "block";
                }
                //Added in ref to Task#2905
                HiddenRelativePath.Value = Page.ResolveUrl("~");
                HiddenFieldDrugInfo.Value = ((StreamlinePrinciple)Context.User).Client.ClientDateOfBirth;
                
                //Setting DAENumber in ref to task#104
                if (HiddenFieldDEANumber.Value != "")
                {
                    int tempDEANumber = Convert.ToInt32(HiddenFieldDEANumber.Value);
                    if (tempDEANumber > 0)
                    {
                        ((StreamlineIdentity)Context.User.Identity).DEANumber = tempDEANumber;
                    }
                }
               // Setting location pranay
                if (HiddenFieldLocationId.Value != "")
                {
                    int tempPrescribingLocation = Convert.ToInt32(HiddenFieldLocationId.Value);
                    if (tempPrescribingLocation > 0)
                    {
                        ((StreamlineIdentity)Context.User.Identity).PrescribingLocation = tempPrescribingLocation;
                    }
                }
               // Setting the Prescriber
                if (HiddenFieldTempPrescriberId.Value != "")
                {
                    int tempPrescriber = Convert.ToInt32(HiddenFieldTempPrescriberId.Value);
                    if (tempPrescriber > 0)
                    {
                        ((StreamlineIdentity)Context.User.Identity).PrescriberId = tempPrescriber;
                    }
                }

                FillPrescriber();
                createControls();
                if (((StreamlinePrinciple)Context.User).HasPermission(Permissions.PermitChanges) &&
                    ((StreamlineIdentity)Context.User.Identity).Prescriber == "Y")
                {
                    CheckBoxPermitChanges.Attributes.Add("style", "display:block");
                }
                else
                {
                    CheckBoxPermitChanges.Attributes.Add("style", "display:none");
                }
                //Commented by Loveena as Ref to Task#129 to set focus in DropDownListPrescriber on Page Load 
                //this.TextBoxDrug.Focus();
                //Added by Loveena as Ref to Task#129 to set focus in DropDownListPrescriber on Page Load
                DropDownListPrescriber.Focus();
                ButtonUpdate.Enabled = ((StreamlinePrinciple)Context.User).HasPermission(Permissions.NewOrder);
                ButtonPrescribe.Enabled = ((StreamlinePrinciple)Context.User).HasPermission(Permissions.NewOrder);
               
                TextBoxSpecialInstructions.Attributes.Add("maxLength", "90");

                CheckBoxPermitChanges.Attributes.Add("onclick", "ClientMedicationOrder.SetDocumentDirty()");
                //---End Code added by Pradeep as per task#31
                if (Session["DataTableClientMedications"] != null)
                    DataTableClientMedications =
                        (DataSetClientMedications.ClientMedicationsDataTable)Session["DataTableClientMedications"];
                if (Session["DataTableClientMedicationInstructions"] != null)
                    DataTableClientMedicationInstructions =
                        (DataSetClientMedications.ClientMedicationInstructionsDataTable)
                        Session["DataTableClientMedicationInstructions"];
                DataViewClientMedication = new DataView(DataTableClientMedications);
                DataViewClientMedicationInstructions = new DataView(DataTableClientMedicationInstructions);
                //Code added by Loveena in ref to Task#2987
                DropDownListPrescriber.Attributes.Add("onchange", "SetPrescriberId();");

                if (((HiddenField)Parent.FindControl("HiddenFieldRedirectFrom")).Value.ToUpper() == "DASHBOARD" &&
                    (_DrugsOrderMethod.ToUpper() == "REFILL" || _DrugsOrderMethod.ToUpper() == "NEW ORDER"))
                {
                }
                else
                    ButtonQueueOrder.Attributes.Add("onclick",
                                                    "javascript:return ValidateInputs('" +
                                                    DropDownListPharmacies.ClientID + "','" +
                                                    DropDownListLocations.ClientID + "','" +
                                                    RadioButtonFaxToPharmacy.ClientID + "','" +
                                                    RadioButtonPrintScript.ClientID + "');");

                #region--Code Added by Pradeep as per task#3(Venture10.0)on 24Dec

            //    ButtonQueueOrder.Enabled = ((StreamlinePrinciple)Context.User).HasPermission(Permissions.QueueOrder);

                #endregion--Code Added by Pradeep as per task#3(Venture10.0)on 24Dec

                #region--Code Added By Pradeep as per task#3328

                if (ConfigurationManager.AppSettings["OrderPageCommentLabel"] != null)
                {
                    CommentTextOnCheckBoxUnCheck = ConfigurationManager.AppSettings["OrderPageCommentLabel"];
                    HiddenOrderPageCommentLabel.Value = CommentTextOnCheckBoxUnCheck;
                }
                if (ConfigurationManager.AppSettings["OrderPageCommentLabelIncludeOnPrescription"] != null)
                {
                    CommentTextOnCheckBoxCheck =
                        ConfigurationManager.AppSettings["OrderPageCommentLabelIncludeOnPrescription"];
                    HiddenOrderPageCommentLabelIncludeOnPrescription.Value = CommentTextOnCheckBoxCheck;
                }
                if (ConfigurationManager.AppSettings["OrderPageNoteLabel"] != null)
                {
                    LabelNote.Text = ConfigurationManager.AppSettings["OrderPageNoteLabel"];
                }


                Streamline.DataService.SharedTables objSharedTables = new Streamline.DataService.SharedTables();
                if (Streamline.UserBusinessServices.SharedTables.DataSetSystemConfigurationKeys != null)
                {
                    if (Streamline.UserBusinessServices.SharedTables.DataSetSystemConfigurationKeys.Tables.Count > 0)
                    {
                        ToolTipTitle = objSharedTables.GetSystemConfigurationKeys("OrderedMedicationPrescriptionToolTip", Streamline.UserBusinessServices.SharedTables.DataSetSystemConfigurationKeys.Tables[0]);
                    }
                    HiddenFieldInfoToolTip.Value = ToolTipTitle;
                }
                if (Streamline.UserBusinessServices.SharedTables.DataSetStaffTable != null)
                {
                    DataRow[] drStaffTable = Streamline.UserBusinessServices.SharedTables.DataSetStaffTable.Tables[0].Select("StaffId=" + ((StreamlineIdentity)Context.User.Identity).UserId + "AND ISNULL(EnableRxPopUpAcknowledgement,'N')='Y'");
                    if (drStaffTable != null)
                    {
                        if (drStaffTable.Length > 0)
                        {
                            HiddenFieldEnableRxPopUpAcknowledgement.Value = drStaffTable[0]["EnableRxPopUpAcknowledgement"].ToString();
                        }
                    }
                }



                if (ConfigurationManager.AppSettings["OrderPageCommentLabel"] != null &&
                    ConfigurationManager.AppSettings["OrderPageCommentLabelIncludeOnPrescription"] != null)
                {
                    if (CheckboxIncludeOnPrescription.Checked)
                    {
                        LabelCommentText.Text = CommentTextOnCheckBoxCheck;
                    }
                    else
                    {
                        LabelCommentText.Text = CommentTextOnCheckBoxUnCheck;
                    }
                    CheckboxIncludeOnPrescription.Attributes.Add("onclick",
                                                                 "ClientMedicationOrder.ChangeOrderPageCommentText('" +
                                                                 LabelCommentText.ClientID + "','" +
                                                                 CheckboxIncludeOnPrescription.ClientID + "','" +
                                                                 CommentTextOnCheckBoxUnCheck + "','" +
                                                                 CommentTextOnCheckBoxCheck + "');");
                }

                //Code Added by : Malathi Shiva 
                //With Ref to task# : 33 - Community Network Services
                if (((StreamlinePrinciple)Context.User).HasPermission(Permissions.OffLabel) == false)
                {
                    CheckBoxOffLabel.Attributes.Add("style", "display:none");
                    Span_OffLabel.Attributes.Add("style", "display:none");
                }

                #endregion

                DropDownListLocations.Items.Clear();
                FillLocationsCombo();

                FillCoverageCombo();
                FillPharmacies();
               // int tempPrescribingLocation = ((StreamlineIdentity)Context.User.Identity).PrescribingLocation;
                
            }

            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "";
                else
                    ex.Data["CustomExceptionInformation"] = "";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);
            }
            finally
            {
            }
        }

        #endregion

        #region Activate()

        public override void Activate()
        {
            DataSetClientMedications dsClientMedications = null;

            try
            {
                DataRow[] DataRowStaffLocations = null;
                DataSet DataSetStaffLocations = null;
                string PrinterDeviceLocationId = string.Empty;
                string ChartCopyPrinterDeviceLocationId = string.Empty;

                #region added By pramod on 14 apr 2008 to show page title

                txtButtonValue = (HiddenField)Page.FindControl("txtButtonValue");
                //Added by Pradeep as per task#3331 Start over here
                DisableEnableControl();
                //Added by Pradeep as per task#3331 End over here

                if (txtButtonValue.Value.ToUpper() == "CHANGE")
                {
                    Label1.Text = "Change Medication Order";
                }
                else if (txtButtonValue.Value.ToUpper() == "REFILL")
                {
                    Label1.Text = "Re-Order Medication Order";
                }
                else if (txtButtonValue.Value.ToUpper() == "ADJUST")
                {
                    Label1.Text = "Adjust Dosage / Schedule";
                }
                else if (txtButtonValue.Value.ToUpper() == "COMPLETE")
                {
                    Label1.Text = "Complete Medication Order";
                }
                else if (OrderType.Value == "APPROVEWITHCHANGESCHANGEORDER")
                {
                    Label1.Text = "Approving with Changes Medication Order";
                }
                else if (OrderType.Value == "CHANGEAPPROVALORDER")
                {
                    Label1.Text = "Approving Change Medication Order";
                }
                else
                {
                    Label1.Text = "New Medication Order";
                }
                //changes end over here

                #endregion

                CommonFunctions.Event_Trap(this);
                base.Activate();
                //Added by Anuj fro task ref 2955 on 19March,2010
                HiddenFieldDrugInfo.Value = ((StreamlinePrinciple)Context.User).Client.ClientDateOfBirth;
                //Ended over here
                //Code modified in ref to Task#3129
                if (Session["AssociatedLocation"] != null && DropDownListLocations.SelectedIndex == 0)
                    DropDownListLocations.SelectedValue = Session["AssociatedLocation"].ToString();
                //else if (((StreamlineIdentity)Context.User.Identity).StaffPrescribingLocationId != 0)
                //    DropDownListLocations.SelectedValue =
                //        ((StreamlineIdentity)Context.User.Identity).StaffPrescribingLocationId.ToString();
                //Added by Loveena in ref to Task#3208 :- 2.2 Location Selection Lost When Changing After Preview
                else if (((HiddenField)(Parent.FindControl("HiddenFieldPrescribingLocation"))).Value != "" &&
                         ((HiddenField)(Parent.FindControl("HiddenFieldPrescribingLocation"))).Value != null)
                    DropDownListLocations.SelectedValue =
                        ((HiddenField)(Parent.FindControl("HiddenFieldPrescribingLocation"))).Value;
                string _strPrintChartCopy = ConfigurationManager.AppSettings["PrintChartCopyWithFax"].ToUpper();
                HiddenFieldChartCopy.Value = _strPrintChartCopy;
                RadioButtonFaxToPharmacy.Attributes.Add("onclick",
                                                        "MedicationPrescribe.SetPrintChartCopy('" +
                                                        RadioButtonFaxToPharmacy.ClientID + "','" +
                                                        CheckBoxPrintChartCopy.ClientID + "','" + _strPrintChartCopy +
                                                        "');return MedicationPrescribe.EnablesDisable('" +
                                                        ButtonPrescribe.ClientID + "','" +
                                                        RadioButtonFaxToPharmacy.ClientID + "','" +
                                                        RadioButtonPrintScript.ClientID + "','" +
                                                        HiddenFieldShowError.ClientID + "');");
                RadioButtonPrintScript.Attributes.Add("onclick",
                                                      "return MedicationPrescribe.EnablesDisable('" +
                                                      ButtonPrescribe.ClientID + "','" +
                                                      RadioButtonFaxToPharmacy.ClientID + "','" +
                                                      RadioButtonPrintScript.ClientID + "')");
                //added by anuj on 26 feb,2010 for task ref 85
                //this.RadioButtonElectronic.Attributes.Add("onclick", "return EnablesDisable('" + ButtonPrescribe.ClientID + "','" + RadioButtonFaxToPharmacy.ClientID + "','" + RadioButtonElectronic.ClientID + "','" + RadioButtonPrintScript.ClientID + "')");
                //ended over here
                DropDownListLocations.Attributes.Add("onchange",
                                                     "javascript:MedicationPrescribe.RefillPrinterDropDown('" +
                                                     DropDownListPrinterDeviceLocations.ClientID + "','" +
                                                     DropDownListLocations.ClientID + "');");
                //DropDownListPharmacies.Attributes.Add("onchange",
                //                                      "ClientMedicationOrder.CheckUncheckFaxToPharmaciesRadioButton('" +
                //                                      DropDownListPharmacies.ClientID + "','" +
                //                                      RadioButtonFaxToPharmacy.ClientID + "','" +
                //                                      RadioButtonPrintScript.ClientID + "','" +
                //                                      CheckBoxPrintChartCopy.ClientID + "','" + _strPrintChartCopy +
                //                                      "');");
                DropDownListPrinterDeviceLocations.Attributes.Add("onchange",
                                                                  "MedicationPrescribe.SetPrinterDeviceLocationsId('" +
                                                                  DropDownListPrinterDeviceLocations.ClientID + "');");

                //Code added by Loveena in ref to Task#86
                CheckBoxPrintChartCopy.Attributes.Add("onclick",
                                                      "MedicationPrescribe.EnableChartCopyPrinterDeviceLocation()");
                //Code ends over here.


                DataTableClientMedications = new DataSetClientMedications.ClientMedicationsDataTable();
                DataTableClientMedicationInstructions =
                    new DataSetClientMedications.ClientMedicationInstructionsDataTable();

                HiddenOrderDateTobeSet.Value = "Y";
                if (Session["DataSetPrescribedClientMedications"] != null || Session["DataSetClientMedications"] != null)
                {
                    if (Session["DataSetPrescribedClientMedications"] != null)
                    {
                        dsClientMedications = (DataSetClientMedications)Session["DataSetPrescribedClientMedications"];
                    }
                    else
                    {
                        dsClientMedications = (DataSetClientMedications)Session["DataSetClientMedications"];
                    }
                    if (dsClientMedications.Tables[0].Rows.Count > 0)
                    {
                        //Changed by Loveena to set Date Format to MM/dd/yyyy.
                        TextBoxOrderDate.Text =
                            Convert.ToDateTime(
                                dsClientMedications.Tables["ClientMedicationScripts"].Rows[0]["OrderDate"].ToString())
                                   .ToString("MM/dd/yyyy");
                        HiddenOrderDateTobeSet.Value = "N";
                        if (dsClientMedications.Tables["ClientMedicationScripts"].Rows[0]["OrderingMethod"].ToString() == "P")
                        {
                            RadioButtonPrintScript.Checked = true;
                        }
                        else if (dsClientMedications.Tables["ClientMedicationScripts"].Rows[0]["OrderingMethod"].ToString() == "F")
                        {
                            RadioButtonFaxToPharmacy.Checked = true;
                        }

                        dsClientMedications.Dispose();
                    }
                    else
                    {
                        //Changed by Loveena to set the format as MM/dd/yyyy.
                        TextBoxOrderDate.Text = DateTime.Today.ToString("MM/dd/yyyy");
                        HiddenOrderDateTobeSet.Value = "Y";
                    }
                }
                else
                {
                    TextBoxOrderDate.Text = DateTime.Today.ToString("MM/dd/yyyy");
                    HiddenOrderDateTobeSet.Value = "Y";
                }


                //---Start Made changes as per task#12 By radeep
                hiddenFieldConsentStatus = (HiddenField)Page.FindControl("HiddenFieldConsentStatus");
                if (txtButtonValue.Value.ToUpper() == "CHANGE" || txtButtonValue.Value.ToUpper() == "REFILL" || txtButtonValue.Value.ToUpper() == "COMPLETE")
                {
                    if (hiddenFieldConsentStatus != null)
                    {
                        if (hiddenFieldConsentStatus.Value.ToUpper() == "NOCONSENTEXIST")
                        {
                            DataSet datasetSystemConfigurationKeys = null;
                            Streamline.DataService.SharedTables objSharedTables = new Streamline.DataService.SharedTables();
                            datasetSystemConfigurationKeys = objSharedTables.GetSystemConfigurationKeys();
                            LabelErrorMessage.Text = "One or more medications does not have a current consent";
                            if (objSharedTables.GetSystemConfigurationKeys("SWITCHRXMEDICATIONCONSENTOFF", datasetSystemConfigurationKeys.Tables[0]).ToUpper() == "Y")
                                tableErrorMessage.Style.Add("display", "none");
                            else
                                tableErrorMessage.Style.Add("display", "block");
                        }
                    }
                }
                //---End Made changes as per task#12 By radeep

                #region---Code Written By Pradeep as per task#31

                ScriptManager.RegisterStartupScript(LabelGridErrorMessage, LabelGridErrorMessage.GetType(), ClientID,
                                                    "CheckUncheckPermitChangeCheckBox('Checked');", true);

                #endregion---Code Written By Pradeep as per task#31

                #region---Code Added By Pradeep as per task#23

                if (RadioButtonPrintScript.Checked)
                {
                    if (DropDownListLocations.SelectedValue != string.Empty &&
                        DropDownListLocations.SelectedValue != "0")
                    {
                        int locationId = Convert.ToInt32(DropDownListLocations.SelectedValue);
                        int staffId = ((StreamlineIdentity)Context.User.Identity).UserId;
                        DataSetStaffLocations = SharedTables.DataSetStaffLocation;
                        if (DataSetStaffLocations != null)
                        {
                            if (DataSetStaffLocations.Tables[0].Rows.Count > 0)
                            {
                                DataRowStaffLocations =
                                    DataSetStaffLocations.Tables[0].Select("StaffId=" + staffId + " And LocationId=" +
                                                                           locationId);
                            }
                        }
                        if (DataRowStaffLocations != null)
                        {
                            if (DataRowStaffLocations.Length > 0)
                            {
                                PrinterDeviceLocationId = (DataRowStaffLocations[0]["PrescriptionPrinterLocationId"] ==
                                                           DBNull.Value
                                                               ? "0"
                                                               : DataRowStaffLocations[0][
                                                                   "PrescriptionPrinterLocationId"].ToString());
                                bool containsColumn = DataRowStaffLocations[0].Table.Columns.Contains("ChartCopyPrinterDeviceLocationId");
                                if (containsColumn)
                                    ChartCopyPrinterDeviceLocationId = (DataRowStaffLocations[0]["ChartCopyPrinterDeviceLocationId"] == DBNull.Value ? "0" :
                                        DataRowStaffLocations[0]["ChartCopyPrinterDeviceLocationId"].ToString());
                            }
                        }
                    }
                    //----Set Selected value of DropDownListPrinterDeviceLocations
                    if (DropDownListPrinterDeviceLocations.Items.FindByValue(PrinterDeviceLocationId) != null)
                    {
                        DropDownListPrinterDeviceLocations.SelectedValue = PrinterDeviceLocationId;
                        HiddenPrinterDeviceLocations.Value = PrinterDeviceLocationId;
                    }
                    if (DropDownListChartCopyPrinter.Items.FindByValue(ChartCopyPrinterDeviceLocationId) != null)
                    {
                        DropDownListChartCopyPrinter.SelectedValue = ChartCopyPrinterDeviceLocationId;
                        //HiddenPrinterDeviceLocations.Value = PrinterDeviceLocationId;
                    }
                }

                #endregion
                //Vithobha Added below code for binding VerbalOrderReadBack checkbox, Summit Pointe - Support: #703 
                if (Session["DataSetClientMedications"] != null && Session["DataSetClientSummary"] != null)
                {
                    int tempClientmedicationid = 0;
                    char tempVerbalOrderReadBack = 'N';
                    DataSet dataSetClientMedicationstemp = (DataSet)Session["DataSetClientMedications"];
                    if (dataSetClientMedicationstemp.Tables[0].Rows.Count > 0)
                    {
                         int.TryParse(dataSetClientMedicationstemp.Tables["ClientMedications"].Rows[0]["ClientMedicationId"].ToString(), out tempClientmedicationid);
                    }

                    DataRow[] DataRowClientSummarytemp = ((DataSet)Session["DataSetClientSummary"]).Tables["ClientMedications"].Select("ClientMedicationId in (" + tempClientmedicationid + ")");

                    if (DataRowClientSummarytemp != null)
                    {
                        foreach (DataRow dr1 in DataRowClientSummarytemp)
                        {
                            tempVerbalOrderReadBack = Convert.ToChar(dr1["VerbalOrderReadBack"]);
                        }
                    }
                    if (tempVerbalOrderReadBack.ToString() == "Y")
                        CheckBoxVerbalOrderReadBack.Checked = true;
                }

                Streamline.UserBusinessServices.ClientMedication objClientMedication = new Streamline.UserBusinessServices.ClientMedication();
                DataSet dsClientEnrolledPrograms = objClientMedication.GetClientEnrolledPrograms(((StreamlinePrinciple)Context.User).Client.ClientId, 'O');
                if (dsClientEnrolledPrograms.Tables.Count > 0)
                {
                    if (dsClientEnrolledPrograms.Tables[0].Rows.Count > 0)
                    {
                        HiddenFieldRXShownoOfDaysOfWeekPopup.Value = "Y";
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
                LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);
            }
            finally
            {
                dsClientMedications = null;
            }
        }

        #endregion

        public string RelativePath { get; set; }

        /// <summary>
        ///     Function is to set the enable state of the control on the basis of the button clicked
        ///     from the medication management page
        /// </summary>
        private void EnableDisableControls()
        {
            try
            {
                var textboxButtonValue = Page.FindControl("txtButtonValue") as HiddenField;
                if (Session["DataSetClientSummary"] != null)
                {
                    _DataSetClientSummary = (DataSet)Session["DataSetClientSummary"];
                    LabelClientName.Text =
                        _DataSetClientSummary.Tables["ClientInformation"].Rows[0]["ClientInformationLabel"].ToString();
                }
                if (textboxButtonValue != null)
                {
                    if (textboxButtonValue.Value == "Refill")
                    {
                        TextBoxStartDate.Enabled = false;
                    }
                    if (((StreamlineIdentity)Context.User.Identity).Prescriber != "Y")
                    {
                        //Code added by Loveena in ref to Task#2800 to disable Prescriber Drop-Down
                        bool flag = false;
                        if (textboxButtonValue.Value.ToUpper() == "REFILL" ||
                            textboxButtonValue.Value.ToUpper() == "CHANGE" ||
                            textboxButtonValue.Value.ToUpper() == "ADJUST" ||
                            textboxButtonValue.Value.ToUpper() == "NEW ORDER" ||
                            textboxButtonValue.Value.ToUpper() == "COMPLETE")
                        {
                            if (Session["DataSetClientMedications"] != null)
                            {
                                using (var dataSetClientMedications = (DataSet)Session["DataSetClientMedications"])
                                {
                                    if (dataSetClientMedications.Tables["ClientMedications"].Rows.Count > 1)
                                    {
                                        for (int count = 0;
                                             count < dataSetClientMedications.Tables["ClientMedications"].Rows.Count;
                                             count++)
                                        {
                                            for (int icount = 1;
                                                 icount <
                                                 dataSetClientMedications.Tables["ClientMedications"].Rows.Count;
                                                 icount++)
                                            {
                                                if (
                                                    dataSetClientMedications.Tables["ClientMedications"].Rows[count][
                                                        "PrescriberId"].ToString() !=
                                                    dataSetClientMedications.Tables["ClientMedications"].Rows[icount][
                                                        "PrescriberId"].ToString())
                                                {
                                                    flag = true;
                                                }
                                            }
                                        }
                                    }
                                    if (flag == false)
                                    {
                                        if (HiddenFieldPrescriber.Value != "")
                                        {
                                            DropDownListPrescriber.SelectedValue = HiddenFieldPrescriber.Value;
                                            if (DropDownListPrescriber.Items.FindByValue(HiddenFieldPrescriber.Value) ==
                                                null)
                                            {
                                                DropDownListPrescriber.Items.Insert(0, "");
                                                DropDownListPrescriber.SelectedIndex = 0;
                                            }
                                        }
                                        else
                                        {
                                            DropDownListPrescriber.SelectedValue =
                                                dataSetClientMedications.Tables["ClientMedications"].Rows[0][
                                                    "PrescriberId"].ToString();
                                            if (
                                                DropDownListPrescriber.Items.FindByValue(
                                                    dataSetClientMedications.Tables["ClientMedications"].Rows[0][
                                                        "PrescriberId"].ToString()) == null)
                                            {
                                                DropDownListPrescriber.Items.Insert(0, "");
                                                DropDownListPrescriber.SelectedIndex = 0;
                                            }
                                        }
                                        DropDownListPrescriber.Enabled = true;
                                    }
                                    if (flag)
                                    {
                                        if (HiddenFieldPrescriber.Value != "")
                                        {
                                            DropDownListPrescriber.SelectedValue = HiddenFieldPrescriber.Value;
                                            if (DropDownListPrescriber.Items.FindByValue(HiddenFieldPrescriber.Value) ==
                                                null)
                                            {
                                                DropDownListPrescriber.Items.Insert(0, "");
                                                DropDownListPrescriber.SelectedIndex = 0;
                                            }
                                        }
                                        else
                                        {
                                            DropDownListPrescriber.Items.Insert(0, "");
                                            DropDownListPrescriber.SelectedIndex = 0;
                                        }
                                        DropDownListPrescriber.Enabled = true;
                                    }
                                }
                            }
                            else
                            {
                                //Added in ref to Task#2741
                                if (HiddenFieldPrescriber.Value != "")
                                {
                                    DropDownListPrescriber.SelectedValue = HiddenFieldPrescriber.Value;
                                    if (DropDownListPrescriber.Items.FindByValue(HiddenFieldPrescriber.Value) == null)
                                    {
                                        DropDownListPrescriber.Items.Insert(0, "");
                                        DropDownListPrescriber.SelectedIndex = 0;
                                    }
                                }
                                else
                                {
                                    DropDownListPrescriber.Items.Insert(0, "");
                                    DropDownListPrescriber.SelectedIndex = 0;
                                }
                                DropDownListPrescriber.Enabled = true;
                            }
                        }
                    }
                    //Condtion added by Loveena in ref to Task#3040- Allow Prescribers to Print/Fax for Other Prescribers
                    if ((((StreamlineIdentity)Context.User.Identity)).EnableOtherPrescriberSelection == "Y")
                    {
                        if (((StreamlineIdentity)Context.User.Identity).Prescriber == "Y")
                        {
                            DropDownListPrescriber.SelectedValue =
                                ((StreamlineIdentity)Context.User.Identity).UserId.ToString();
                            if (
                                DropDownListPrescriber.Items.FindByValue(
                                    ((StreamlineIdentity)Context.User.Identity).UserId.ToString()) == null)
                            {
                                DropDownListPrescriber.Items.Insert(0, "");
                                DropDownListPrescriber.SelectedIndex = 0;
                            }
                        }
                        DropDownListPrescriber.Enabled = true;
                        //Added Ref:task No:3043
                        //HiddenFieldPrescriberId.Value = DropDownListPrescriber.SelectedValue;
                    }
                    else
                    {
                        if (((StreamlineIdentity)Context.User.Identity).Prescriber == "Y")
                        {
                            //Modified by Loveena in ref to Task#2987(If Staff.Prescriber = 'Y' and the user has the Queue Order permission Enable Drop-Down)
                            if ((textboxButtonValue.Value.ToUpper() == "REFILL" ||
                                 textboxButtonValue.Value.ToUpper() == "CHANGE" ||
                                 textboxButtonValue.Value.ToUpper() == "ADJUST" ||
                                 textboxButtonValue.Value.ToUpper() == "NEW ORDER" ||
                                 textboxButtonValue.Value.ToUpper() == "COMPLETE") &&
                                ((StreamlinePrinciple)Context.User).HasPermission(Permissions.QueueOrder))
                            {
                                DropDownListPrescriber.SelectedValue =
                                    ((StreamlineIdentity)Context.User.Identity).UserId.ToString();
                                if (
                                    DropDownListPrescriber.Items.FindByValue(
                                        ((StreamlineIdentity)Context.User.Identity).UserId.ToString()) == null)
                                {
                                    DropDownListPrescriber.Items.Insert(0, "");
                                    DropDownListPrescriber.SelectedIndex = 0;
                                }
                                DropDownListPrescriber.Enabled = true;
                            }
                            else if ((textboxButtonValue.Value.ToUpper() == "REFILL" ||
                                      textboxButtonValue.Value.ToUpper() == "CHANGE" ||
                                      textboxButtonValue.Value.ToUpper() == "ADJUST" ||
                                      textboxButtonValue.Value.ToUpper() == "NEW ORDER" ||
                                 textboxButtonValue.Value.ToUpper() == "COMPLETE") &&
                                     !((StreamlinePrinciple)Context.User).HasPermission(Permissions.QueueOrder))
                            {
                                DropDownListPrescriber.SelectedValue =
                                    ((StreamlineIdentity)Context.User.Identity).UserId.ToString();
                                if (
                                    DropDownListPrescriber.Items.FindByValue(
                                        ((StreamlineIdentity)Context.User.Identity).UserId.ToString()) == null)
                                {
                                    DropDownListPrescriber.Items.Insert(0, "");
                                    DropDownListPrescriber.SelectedIndex = 0;
                                }
                                DropDownListPrescriber.Enabled = false;
                            }
                            //Added Ref:task No:3043
                            //HiddenFieldPrescriberId.Value = DropDownListPrescriber.SelectedValue;
                        }
                    }
                }
                if (textboxButtonValue.Value.ToUpper() == "ADJUST")
                {
                    //#ka02212014ComboBoxDrug.Enabled = false;
                    //OrderHeader.Style.Add("display", "none");
                    ButtonQueueOrder.Visible = false;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        ///     Ref to Task#2800
        /// </summary>
        /// <returns></returns>
        /// <NOTE>Please reach WasifB/PranayB  before changing anything in the FillPrescriber()</NOTE>
        public void FillPrescriber()
        {
            var DataSetPrimaryStaff = new DataSet();
            DataRow[] DataRowRestStaff = null;
            //DataView DataViewPrimaryStaff = null;
            int tempPrescriber = 0;

            DataRow[] DataRowStaff =
                SharedTables.DataSetStaffTable.Tables[0].Select("Prescriber = 'Y' and Active = 'Y' And StaffId=" +
                                                                ((StreamlineIdentity)Context.User.Identity).UserId);
            DataSetPrimaryStaff.Merge(DataRowStaff);
            if (DataRowStaff.Length > 0)
            {
                tempPrescriber = ((StreamlineIdentity)Context.User.Identity).UserId;
                DataRowRestStaff =
                    SharedTables.DataSetStaffTable.Tables[0].Select(
                        "Prescriber = 'Y' and Active = 'Y' And StaffId<>" +
                        ((StreamlineIdentity)Context.User.Identity).UserId, "StaffName");
            }
            else
            {
                DataRowRestStaff = SharedTables.DataSetStaffTable.Tables[0].Select("Prescriber = 'Y' and Active = 'Y'",
                                                                                   "StaffName");
            }
            DataSetPrimaryStaff.Merge(DataRowRestStaff);

            DropDownListPrescriber.DataSource = DataSetPrimaryStaff.Tables[0];
            DropDownListPrescriber.DataTextField = "StaffNameWithDegree";
            DropDownListPrescriber.DataValueField = "StaffId";
            DropDownListPrescriber.DataBind();
            EnableDisableControls();
            int PrescriberStaff;
            int.TryParse(DropDownListPrescriber.SelectedValue, out PrescriberStaff);
           

            if (tempPrescriber > 0)
            {
                DropDownListPrescriber.SelectedValue = tempPrescriber.ToString();
            }
            else if (Session["ButtonType"].ToString().ToUpper() == "ADJUST")
            {
                DropDownListPrescriber.SelectedValue = (((StreamlineIdentity)Context.User.Identity)).UserId.ToString();
                DataSetClientMedications dsClientMedications = null;
                dsClientMedications = (DataSetClientMedications)Session["DataSetClientMedications"];
            }
             else if(HiddenFieldPrescriber.Value!="")
            {
               int value;
               bool success= int.TryParse(HiddenFieldPrescriber.Value.ToString(),out value);
               if (success==true)
               DropDownListPrescriber.SelectedIndex = value;
             
             }
            else
            {
                if (DropDownListPrescriber.Items.FindByText("") == null)
                {
                    DropDownListPrescriber.Items.Insert(0, "");
                }
                DropDownListPrescriber.SelectedIndex = 0;
            }
            FillDEANumberDropdown(tempPrescriber);
          
        }

        private void FillCoverageCombo()
        {
            DataSet clientSummary = (DataSet)Session["DataSetClientSummary"];
            if (clientSummary.Tables.Contains("FormularyRequestInformation") &&
                clientSummary.Tables["FormularyRequestInformation"].Rows.Count > 0 &&
                clientSummary.Tables["FormularyRequestInformation"].Rows[0]["FormularyRequestXML"] != null &&
                !clientSummary.Tables["FormularyRequestInformation"].Rows[0]["FormularyRequestXML"].ToString().IsNullOrWhiteSpace())
            {
                DataSet coverages = new DataSet();
                StringReader sr = new StringReader(clientSummary.Tables["FormularyRequestInformation"].Rows[0]["FormularyRequestXML"].ToString().Replace("&", ""));
                coverages.ReadXml(sr);
                if (coverages != null && coverages.Tables.Contains("Coverage"))
                {
                    DropDownListCoverage.DataSource = coverages.Tables["Coverage"];
                    DropDownListCoverage.DataTextField = "HEALTH_PLAN_NAME";
                    DropDownListCoverage.DataValueField = "COVERAGE_REQ_ID";
                    DropDownListCoverage.DataBind();
                    DropDownListCoverage.SelectedIndex = 0;
                }
            }
        }

        private void FillPharmacies()
        {
            /* Same logic has been used here to load the Typeable Dropdown as the old dropdown loads in Java script*/
            //HiddenFieldPharmacyId.Value = string.empty;  
            DataSet DataSetPharmacies = null;
            string[] ClientPharmecieIds = null;
            DataSet DataSetClientPharmecies = new DataSet();
            var objectSharedTables = new Streamline.UserBusinessServices.SharedTables();

            var _DataSetClientSummary = (DataSet)Session["DataSetClientSummary"];
            if (_DataSetClientSummary != null)
                ClientPharmecieIds = _DataSetClientSummary.Tables["ClientPharmacies"].Select("ISNULL(RecordDeleted,'N')='N'").AsEnumerable().Select(x => x["PharmacyId"].ToString()).ToArray();

            DataSetPharmacies = objectSharedTables.getPharmacies(((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId);
            if (DataSetPharmacies != null && DataSetPharmacies.Tables[0].Rows.Count > 0)
            {
                DataSetClientPharmecies.Merge(
                    DataSetPharmacies.Tables[0].AsEnumerable()
                                               .Select(pharmacies => pharmacies)
                                               .Where(fax => fax["FaxNumber"].ToString().Length >= 7)
                                               .OrderBy(clientpharmacies => !ClientPharmecieIds.Contains(clientpharmacies["PharmacyId"].ToString()))
                                               .ThenBy(SequenceNumber => SequenceNumber["SequenceNumber"]).CopyToDataTable());
            }
            else
            {
                DataSetClientPharmecies.Tables.Add(new DataTable());
            }

            /* Getting the Client Pharmacy Id */
            string ClientpharmacyId = ClientPharmecieIds.Length > 0 ? ClientPharmecieIds[0] : "";
            string ClientpharmacyIdExists = "";  /* Variable used to check whether the Pharmacy Id is there in the list */

            /* Adding a Temp column Fulladdress in DataSetClientPharmecies to save the Complete address by concadianting City,State and Address  */
            DataSetClientPharmecies.Tables[0].Columns.Add("Fulladdress", typeof(string));

            /* Variable Pharmacyarr which has been used to store the Pharmacy ids binded in the Type able dropdown */
            //string[] Pharmacyarr = new string[DataSetClientPharmecies.Tables[0].Rows.Count];

            string pharmacywithaddress = "";
            string pharmacyphonenumber = "";

            int pharmacylen = 0;
            int pharmacyspacing = 0;
            int maxpharmacylen = 0;
            int maxtemppharmacylen = 0;
            string pharmacyaddressforspacing = "";


            /* Logic added to find the max length of the PharmacyName in the list to align the phone number based on it */
            for (int i = 0; i < DataSetClientPharmecies.Tables[0].Rows.Count; i++)
            {
                /* Added logic with SureScriptsPharmacyIdentifier not to duplicate the address bcos a function exists in the ssp which  will return city,state and address along with the address if SureScriptsPharmacyIdentifier is not equal to empty*/
                string SureScriptsPharmacyIdtest = DataSetClientPharmecies.Tables[0].Rows[i]["SureScriptsPharmacyIdentifier"].ToString();
                if (SureScriptsPharmacyIdtest != "")
                {
                    pharmacyaddressforspacing = DataSetClientPharmecies.Tables[0].Rows[i]["PharmacyName"].ToString();
                }
                else
                {
                    pharmacyaddressforspacing = DataSetClientPharmecies.Tables[0].Rows[i]["PharmacyName"].ToString()+DataSetClientPharmecies.Tables[0].Rows[i]["City"].ToString() + DataSetClientPharmecies.Tables[0].Rows[i]["State"].ToString() + DataSetClientPharmecies.Tables[0].Rows[i]["Address"].ToString();
                }

                //maxpharmacylen = pharmacyaddressforspacing.Trim().Length;

                string upperpharmacyaddressforspacing = pharmacyaddressforspacing.ToUpper();

                maxpharmacylen = upperpharmacyaddressforspacing.Trim().Length;


                if (maxpharmacylen > maxtemppharmacylen)
                {
                    maxtemppharmacylen = maxpharmacylen;   /* Saving the pharmacy which have maximum length in the list */
                }

                if (Label1.Text != "New Medication Order" || HiddenField_PharmaciesId.Value == string.Empty)
                {
                    string pharmid = DataSetClientPharmecies.Tables[0].Rows[i]["PharmacyId"].ToString();
                    if (ClientpharmacyId == pharmid)      /* Checking whether the ClientpharmacyId is available in the list or not */
                    {
                        ClientpharmacyIdExists = ClientpharmacyId;
                    }
                }
                if (HiddenField_PharmaciesId.Value != string.Empty && ClientpharmacyIdExists == string.Empty)
                {
                    ClientpharmacyIdExists = HiddenField_PharmaciesId.Value;
                }
                /* Saving all the Pharmacyid's in Pharmacyarr variable*/
                //Pharmacyarr[i] = DataSetClientPharmecies.Tables[0].Rows[i]["PharmacyId"].ToString();

            }


            /* Loop to align the Phone number and ServiceLevel check of the pharmacy */
            for (int i = 0; i < DataSetClientPharmecies.Tables[0].Rows.Count; i++)
            {
                string SureScriptsPharmacyId = DataSetClientPharmecies.Tables[0].Rows[i]["SureScriptsPharmacyIdentifier"].ToString();
                if (SureScriptsPharmacyId != "")
                {
                    pharmacywithaddress = DataSetClientPharmecies.Tables[0].Rows[i]["PharmacyName"].ToString();
                }
                else
                {
                 
                    pharmacywithaddress = DataSetClientPharmecies.Tables[0].Rows[i]["PharmacyName"].ToString() + ", " + DataSetClientPharmecies.Tables[0].Rows[i]["Address"].ToString() + ", " + DataSetClientPharmecies.Tables[0].Rows[i]["City"].ToString() + ", " + DataSetClientPharmecies.Tables[0].Rows[i]["State"].ToString() + " "  + (DataSetClientPharmecies.Tables[0].Rows[i]["PhoneNumber"].ToString().Length.Equals(10) ? String.Format("{0:(###)-###-####}", Convert.ToInt64( DataSetClientPharmecies.Tables[0].Rows[i]["PhoneNumber"].ToString())): DataSetClientPharmecies.Tables[0].Rows[i]["PhoneNumber"].ToString());
                }

                pharmacylen = pharmacywithaddress.Trim().Length;
                if (pharmacylen <= 100)
                {
                    pharmacyspacing = (maxtemppharmacylen - pharmacylen) + 30;
                }

                bool EPCSCheck = ((StreamlinePrinciple)Context.User).HasPermission(Permissions.EPCS);    /* EPCS Permissions check for the user */
                int ServiceLevel = DataSetClientPharmecies.Tables[0].Rows[i]["ServiceLevel"].Equals(DBNull.Value) ? 0 : Convert.ToInt32(DataSetClientPharmecies.Tables[0].Rows[i]["ServiceLevel"]);  /* ServiceLevel check of the pharmacy */
                if (EPCSCheck == true)
                {
                    if (ServiceLevel >= 2048)
                    {
                        pharmacyphonenumber = (DataSetClientPharmecies.Tables[0].Rows[i]["PhoneNumber"].ToString().Length.Equals(10) ? String.Format("{0:(###)-###-####}", Convert.ToInt64(DataSetClientPharmecies.Tables[0].Rows[i]["PhoneNumber"].ToString())) : DataSetClientPharmecies.Tables[0].Rows[i]["PhoneNumber"].ToString()) + " - " + "EPCS";   /* Adding EPCS with PhoneNumber if it matches the service level */
                    }
                    else
                    {
                        pharmacyphonenumber = "";
                    }
                }
                else
                {
                    pharmacyphonenumber = "";
                }
                DataSetClientPharmecies.Tables[0].Rows[i]["Fulladdress"] = pharmacywithaddress +' '+ pharmacyphonenumber;
            }

            if (ClientpharmacyIdExists != "")
            {
                DataRow[] drPharmacyName = DataSetClientPharmecies.Tables[0].Select("PharmacyId=" + ClientpharmacyIdExists);
                if (drPharmacyName.Count() > 0)
                {
                    if (HiddenField_PharmaciesId.Value == string.Empty)
                    {
                        HiddenField_PharmaciesName.Value = drPharmacyName[0]["Fulladdress"].ToString();
                        HiddenField_PharmaciesId.Value = drPharmacyName[0]["PharmacyId"].ToString();
                    }
                }
            }

            if (Convert.ToString(Session["ScreenName"]) == "FromQueuedOrderScreen")
            {
                HiddenField_OrderingMethod.Value = Convert.ToString(Session["OrderingMethodToDefault"]);
                if (Session["PharmacyIdFromQue"] != null)
                {                    
                    HiddenField_PharmaciesId.Value = string.Empty;
                    DataRow[] drPharmacyName = DataSetClientPharmecies.Tables[0].Select("PharmacyId=" + Convert.ToString(Session["PharmacyIdFromQue"]));
                    if (drPharmacyName.Count() > 0)
                    {
                        if (HiddenField_PharmaciesId.Value == string.Empty)
                        {
                            HiddenField_PharmaciesName.Value = drPharmacyName[0]["Fulladdress"].ToString();
                            HiddenField_PharmaciesId.Value = drPharmacyName[0]["PharmacyId"].ToString();
                        }
                    }
                    HiddenFieldPharmacyId.Value = Convert.ToString(Session["PharmacyIdFromQue"]);
                    HiddenFieldScriptsPharmacyId.Value = Convert.ToString(Session["PharmacyIdFromQue"]);
                    HiddenField_PharmaciesName.Value = Convert.ToString(Session["PharamcyToDefault"]);
                    Session["PharmacyIdFromQue"] = null;
                    Session["PharamcyToDefault"] = null;
                }
            }


            /* Binding the Values to the Dropdown */
            DataTable DataTableClientPharmacies = null;
            DataTableClientPharmacies = DataSetClientPharmecies.Tables[0];

            DataView dataViewClientPharmacies = DataTableClientPharmacies.DefaultView;
           // dataViewClientPharmacies.Sort = "PharmacyName Asc";

            DropDownListPharmacies.DataSource = dataViewClientPharmacies;
            DropDownListPharmacies.DataTextField = "Fulladdress";
            DropDownListPharmacies.DataValueField = "PharmacyId";
          
            if (!string.IsNullOrEmpty(DropDownListPharmacies.BlankRowText))
            {
                DropDownListPharmacies.BlankRowText = "Select Pharmacy";
            }
            DropDownListPharmacies.DataBind();


        }
      
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
                DataTableStaffLocations = ((StreamlinePrinciple)Context.User).StaffPrescribingLocations;
                int staffDefaultLocation = ((StreamlineIdentity)Context.User.Identity).StaffPrescribingLocationId;
                //Following changed as per Task #2394
                //DataViewLocations = DataSetLocations.Tables[0].DefaultView;
                DataViewLocations = DataTableStaffLocations.DefaultView;
                DataViewLocations.Sort = "LocationName Asc";
                DropDownListLocations.DataSource = DataViewLocations;
                DropDownListLocations.DataTextField = "LocationName";
                DropDownListLocations.DataValueField = "LocationId";
                DropDownListLocations.DataBind();
                DataTableStaffLocations = DataViewLocations.ToTable();
                
                for(int i = 0 ; i < DataTableStaffLocations.Rows.Count;  i++)
                {
                 var state = DataTableStaffLocations.Rows[i]["State"].ToString();
                 DropDownListLocations.Items[i].Attributes.Add("State", state.ToString());
                }
               
                DropDownListLocations.Items.Insert(0, new ListItem("........Select Location........", "0"));
                int tempPrescribingLocation = ((StreamlineIdentity)Context.User.Identity).PrescribingLocation;

                if (staffDefaultLocation > 0) // default location of the logged in or selected prescriber  - regardless is new order, change, refill, etc Boundless - Support Task#199
                {
                    DropDownListLocations.SelectedValue = staffDefaultLocation.ToString();
                }
                else
                {
                    DropDownListLocations.SelectedIndex = 0;
                }
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] =
                        CommonFunctions.Event_FormatString(
                            "###Source Function Name - FillLocationsCombo(),ParameterCount 0 - ###");
                else
                    ex.Data["CustomExceptionInformation"] =
                        CommonFunctions.Event_FormatString(ex.Data["CustomExceptionInformation"].ToString());
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);
            }
            finally
            {
                DataViewLocations = null;
                if (DataTableStaffLocations != null)
                    DataTableStaffLocations.Dispose();
            }
        }

        private void FillDEANumberDropdown(int PrescriberStaff)
        {
            DataTable DataTableDEANumber = null;
            DataView DataViewDEANumber = null;
            try
            {
                CommonFunctions.Event_Trap(this);
                Streamline.UserBusinessServices.ClientMedication objClientMedication = new Streamline.UserBusinessServices.ClientMedication();
                if (PrescriberStaff <= 0)
                {
                    PrescriberStaff = (((StreamlineIdentity)Context.User.Identity)).UserId;
                }
                DataSet dsStaffLicenseDegrees = objClientMedication.GetStaffLicenseDegrees(PrescriberStaff);
                dsStaffLicenseDegrees.Tables[0].TableName = "StaffLicenseDegrees";
                DataViewDEANumber = dsStaffLicenseDegrees.Tables["StaffLicenseDegrees"].DefaultView;
               // DataViewDEANumber.Sort = "Billing Desc";
                DropDownListDEANumber.DataSource = DataViewDEANumber;
                DropDownListDEANumber.DataTextField = "DEANumber";
                DropDownListDEANumber.DataValueField = "StaffLicenseDegreeId";
                DropDownListDEANumber.DataBind();

                for (int i = 0; i < dsStaffLicenseDegrees.Tables[0].Rows.Count; i++)
                {
                    var state = dsStaffLicenseDegrees.Tables[0].Rows[i]["StateFIPS"].ToString();
                    DropDownListDEANumber.Items[i].Attributes.Add("DEAState", state.ToString());
                }
               
               //change in ref to Task#104
                int  tempDEANumber =  ((StreamlineIdentity)Context.User.Identity).DEANumber;
                if (tempDEANumber > 0)
                {
                    DropDownListDEANumber.SelectedValue = tempDEANumber.ToString(); // (string) Session["HiddenFieldDEANumber"];
                }
                else
                {
                    DropDownListDEANumber.SelectedIndex = 0;
                }
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] =
                        CommonFunctions.Event_FormatString(
                            "###Source Function Name - FillDEANumberDropdown(),ParameterCount 0 - ###");
                else
                    ex.Data["CustomExceptionInformation"] =
                        CommonFunctions.Event_FormatString(ex.Data["CustomExceptionInformation"].ToString());
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);
            }
            finally
            {
                DataViewDEANumber = null;
                if (DataTableDEANumber != null)
                    DataTableDEANumber.Dispose();
            }
        }

        protected void LinkButton1_Click(object sender, EventArgs e)
        {
        }


        protected void ButtonDeleteCurrentMedications_Click(object sender, EventArgs e)
        {
            ClientMedication objClientMedication = null;
            DataSetClientMedications dsClientMedications = null;
            try
            {
                CommonFunctions.Event_Trap(this);
            }

            catch (Exception ex)
            {
                LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);
            }
            finally
            {
                Session["DataSetPrescribedClientMedications"] = null;
                Session["medicationIdList"] = null;
                //Condition added by Loveena in ref to Task#85
                if (((HiddenField)Parent.FindControl("HiddenFieldRedirectFrom")).Value == "DashBoard")
                    ScriptManager.RegisterStartupScript(ButtonPrescribe, ButtonPrescribe.GetType(), ClientID,
                                                        "redirectToStartPage();", true);
                else
                    ScriptManager.RegisterStartupScript(ButtonPrescribe, ButtonPrescribe.GetType(), ClientID,
                                                        "redirectToManagementPage();", true);
            }
        }

        protected void LinkButtonLogout_Click(object sender, EventArgs e)
        {
            Response.Redirect("MedicationLogin.aspx");
        }

        private bool DocumentPrescribeDocument()
        {
            DataTable DataTableClientMedicationsNCSampleORStockDrugs;
            DataTable DataTableClientMedicationsNCNonSampleORStockDrugs;
            DataTable DataTableClientMedicationsC2SampleORStockDrugs;
            DataTable DataTableClientMedicationsC2NonSampleORStockDrugs;
            DataTable DataTableClientMedicationsControlledSampleORStockDrugs;

            DataTable DataTableClientMedicationsControlledNonSampleORStockDrugs;

            int PharmacyId = 0;
            //Task#2660
            string File = "";
            int seq = 1;
            bool _strScriptsTobeFaxedButPrinted = false;
            //Code added by Loveena in ref to Task#2597
            string strSendCoverLetter = "false";
            int NumberOfTimesFaxSend = 0;
            DataSet DataSetPharmacies;
            DataRow[] drSelectedPharmacy = null;
            //Added by Loveena in ref to Task#188 on 23-Feb-2009 as Stored Procedure ssp_SCGetDataFromPharmacies Modified.
            DataRow[] drPharmacies = null;
            DataRow[] DataRowsClientMedeicationsCategory2Drugs = null;
            DataRow[] DataRowsClientMedicationsNormalCategoryDrugs = null;
            //Task#2580
            DataRow[] DataRowsClientMedicationsControlledCategoryDrugs = null;
            ClientMedication objClientMedication = null;
            string _strPrintChartCopy = null;
            if (CheckBoxPrintChartCopy.Checked)
                _strPrintChartCopy = "true";
            else
                _strPrintChartCopy = "false";


            string _strMedicationInstructionIds = "";

            //divReportViewer.InnerHtml = ""; //To clear the Temporary Rdl Report display div task #85 MM#1.7
            try
            {
                HiddenFieldShowError.Value = "";

                _DrugsOrderMethod = txtButtonValue.Value;
                if (Session["DataSetPrescribedClientMedications"] != null)
                {
                    //Ref to Task#2660
                    if (ConfigurationSettings.AppSettings["SaveJpegOutput"].ToLower() == "true")
                    {
                        if (Directory.Exists(Server.MapPath("RDLC\\" + Context.User.Identity.Name)))
                        {
                            if (!Directory.Exists(Server.MapPath("RDLC\\" + Context.User.Identity.Name + "\\JPEGS")))
                                Directory.CreateDirectory(
                                    Server.MapPath("RDLC\\" + Context.User.Identity.Name + "\\JPEGS"));

                            foreach (
                                string file in
                                    Directory.GetFiles(Server.MapPath("RDLC\\" + Context.User.Identity.Name + "\\")))
                            {
                                File = file.Substring(file.LastIndexOf("\\") + 1);
                                if ((File.IndexOf("JPEG") >= 0 || File.IndexOf("jpeg") >= 0))
                                {
                                    //System.IO.File.Move(file, Server.MapPath("RDLC\\" + Context.User.Identity.Name + "\\JPEGS") + "\\" + File);
                                    while (seq < 1000)
                                    {
                                        seq = seq + 1;
                                        if (
                                            !System.IO.File.Exists(
                                                Server.MapPath("RDLC\\" + Context.User.Identity.Name + "\\JPEGS") + "\\" +
                                                File))
                                        {
                                            System.IO.File.Move(file,
                                                                Server.MapPath("RDLC\\" + Context.User.Identity.Name +
                                                                               "\\JPEGS") + "\\" + File);
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
                            using (var objRDLC = new RDLCPrint())
                            {
                                objRDLC.DeleteRenderedImages(Server.MapPath("RDLC\\" + Context.User.Identity.Name));
                            }
                        }
                        catch (Exception ex)
                        {
                            LogManager.LogException(ex, LogManager.LoggingCategory.General,
                                                    LogManager.LoggingLevel.Error, this);
                        }

                        #endregion
                    }


                    objClientMedication = new ClientMedication();
                    ObjectClientMedication = (DataSetClientMedications)Session["DataSetPrescribedClientMedications"];
                    if (_DrugsOrderMethod == "Refill" || _DrugsOrderMethod == "REFILL")
                    {
                        //Set the Primary Key for ClientMedications
                        var dcDataTableClientMedications = new DataColumn[1];
                        dcDataTableClientMedications[0] =
                            ObjectClientMedication.Tables["ClientMedications"].Columns["ClientMedicationId"];
                        ObjectClientMedication.Tables["ClientMedications"].PrimaryKey = dcDataTableClientMedications;
                        //Code commented by Chandan as per task #131 (Ref#2429)- 1.7.3 - ClientMedicationInteraction Not Saved on Refill
                        //As in Refill case Interactions and Interaction Details need not to be created again as no new ClientMedications will be created
                        var _dsClientSummary = new DataSet();
                        _dsClientSummary = (DataSet)Session["DataSetClientSummary"];
                        if (_dsClientSummary.Tables["ClientMedicationInteractions"].Rows.Count > 0)
                        {
                            ObjectClientMedication.Tables["ClientMedicationInteractions"].Clear();
                            ObjectClientMedication.Tables["ClientMedicationInteractionDetails"].Clear();
                        }
                    }


                    if (CheckBoxPrintDrugInformation.Checked)
                        PrintDrugInformation = 'Y';
                    else
                        PrintDrugInformation = 'N';

                    VerbalOrderReadBack = CheckBoxVerbalOrderReadBack.Checked ? 'Y' : 'N';

                    if (HiddenFieldLocationId.Value != string.Empty)
                        LocationId = Convert.ToInt32(HiddenFieldLocationId.Value);

                    _DataTableClientMedications = ObjectClientMedication.Tables["ClientMedications"];
                    _DataTableClientMedicationInstructions =
                        ObjectClientMedication.Tables["ClientMedicationInstructions"];
                    _DataTableClientMedicationScriptDrugs = ObjectClientMedication.Tables["ClientMedicationScriptDrugs"];
                    //Added By anuj on 12feb,2010 fro task ref 85
                    _DataTableClientMedicationScriptDrugStrengths =
                        ObjectClientMedication.Tables["ClientMedicationScriptDrugStrengths"];
                    //Ended over here


                    //Find out Category2,NormalCategory and ControlledCategoryDrugss

                    DataRowsClientMedeicationsCategory2Drugs =
                        _DataTableClientMedications.Select("(ISNULL(RecordDeleted,'N')='N') and (DrugCategory='2')",
                                                           " [ClientMedicationId] DESC ");
                    DataRowsClientMedicationsNormalCategoryDrugs =
                        _DataTableClientMedications.Select(
                            "(ISNULL(RecordDeleted,'N')='N') and (DrugCategory IS NULL OR (DrugCategory<>'2' AND DrugCategory<>'3'  AND DrugCategory<>'4' AND DrugCategory<>'5') OR DrugCategory='') ",
                            " [ClientMedicationId] DESC ");
                    //Task#2580
                    DataRowsClientMedicationsControlledCategoryDrugs =
                        _DataTableClientMedications.Select(
                            "(ISNULL(RecordDeleted,'N')='N') and (DrugCategory='3' OR DrugCategory='4' OR DrugCategory='5')",
                            " [ClientMedicationId] DESC ");


                    DataTableClientMedicationsC2NonSampleORStockDrugs = null;
                    //Task#2580
                    DataTableClientMedicationsControlledNonSampleORStockDrugs = null;
                    //DataTableClientMedicationsControlledNonSampleORStockDrugsC3 = null;
                    //DataTableClientMedicationsControlledNonSampleORStockDrugsC4 = null;
                    //DataTableClientMedicationsControlledNonSampleORStockDrugsC5 = null;

                    DataTableClientMedicationsNCNonSampleORStockDrugs = null;


                    DataTableClientMedicationsNCNonSampleORStockDrugs = _DataTableClientMedications.Clone();

                    DataTableClientMedicationsC2NonSampleORStockDrugs = _DataTableClientMedications.Clone();

                    //Task#2580
                    DataTableClientMedicationsControlledNonSampleORStockDrugs = _DataTableClientMedications.Clone();
                    //DataTableClientMedicationsControlledNonSampleORStockDrugsC3 = _DataTableClientMedications.Clone();
                    //DataTableClientMedicationsControlledNonSampleORStockDrugsC4 = _DataTableClientMedications.Clone();
                    //DataTableClientMedicationsControlledNonSampleORStockDrugsC5 = _DataTableClientMedications.Clone();


                    //Normal Category Drugs


                    try
                    {
                        if (DataRowsClientMedicationsNormalCategoryDrugs.Length > 0)
                        {
                            foreach (DataRow dr in DataRowsClientMedicationsNormalCategoryDrugs)
                            {
                                DataRow[] drInstructions =
                                    _DataTableClientMedicationInstructions.Select("ClientMedicationId=" +
                                                                                  Convert.ToInt32(
                                                                                      dr["ClientMedicationId"].ToString()));

                                foreach (DataRow dr1 in drInstructions)
                                {
                                    if (_strMedicationInstructionIds == "")
                                    {
                                        _strMedicationInstructionIds += dr1["ClientMedicationInstructionId"].ToString();
                                    }
                                    else
                                    {
                                        _strMedicationInstructionIds += "," + dr1["ClientMedicationInstructionId"];
                                    }
                                }
                                if (_strMedicationInstructionIds != "")
                                {
                                    //Changes by Sonia
                                    //Ref Task #64 Error Preventing Script Creation (1)
                                    //Changed the Logic to include those Medications in Script as well where Pharm<=0 but (Pharmacy+Sample+Stock) Should be >0
                                    //Modfied by Loveena in ref to Task#2802
                                    //DataRow[] dr2 = _DataTableClientMedicationScriptDrugs.Select("ClientMedicationInstructionId in(" + _strMedicationInstructionIds + ") and (Pharmacy+Sample+Stock>0) ");
                                    //Changes end over here
                                    DataRow[] dr2 =
                                        _DataTableClientMedicationScriptDrugs.Select(
                                            "ClientMedicationInstructionId in(" + _strMedicationInstructionIds +
                                            ") and (Pharmacy+Sample+Stock>0) and ISNULL(AutoCalcAllow,'Y')='Y' ");
                                    DataRow[] dr3 =
                                        _DataTableClientMedicationScriptDrugs.Select(
                                            "ClientMedicationInstructionId in(" + _strMedicationInstructionIds +
                                            ") and ISNULL(AutoCalcAllow,'N')='N' ");
                                    //if (dr2.Length > 0)
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
                    //Task#33
                    string category2Instructions = "";
                    if (DataRowsClientMedeicationsCategory2Drugs.Length > 0)
                    {
                        foreach (DataRow dr in DataRowsClientMedeicationsCategory2Drugs)
                        {
                            DataRow[] drInstructions =
                                _DataTableClientMedicationInstructions.Select("ClientMedicationId=" +
                                                                              Convert.ToInt32(
                                                                                  dr["ClientMedicationId"].ToString()));

                            foreach (DataRow dr1 in drInstructions)
                            {
                                if (_strMedicationInstructionIds == "")
                                {
                                    _strMedicationInstructionIds += dr1["ClientMedicationInstructionId"].ToString();
                                }
                                else
                                {
                                    _strMedicationInstructionIds += "," + dr1["ClientMedicationInstructionId"];
                                }
                                //Task#33
                                if (category2Instructions == "")
                                {
                                    category2Instructions += dr1["ClientMedicationInstructionId"].ToString();
                                }
                                else
                                {
                                    category2Instructions += "," + dr1["ClientMedicationInstructionId"];
                                }
                            }

                            if (_strMedicationInstructionIds != "")
                            {
                                //Changes by Sonia
                                //Ref Task #64 Error Preventing Script Creation (1)
                                //Changed the Logic to include those Medications in Script as well where Pharm<=0 but (Pharmacy+Sample+Stock) Should be >0

                                //Modified in ref to Task#2802
                                //DataRow[] dr2 = _DataTableClientMedicationScriptDrugs.Select("ClientMedicationInstructionId in(" + _strMedicationInstructionIds + ") and (Pharmacy+Sample+Stock>0) ");
                                ////Changes end over here 
                                //if (dr2.Length > 0)
                                DataRow[] dr2 =
                                    _DataTableClientMedicationScriptDrugs.Select("ClientMedicationInstructionId in(" +
                                                                                 _strMedicationInstructionIds +
                                                                                 ") and (Pharmacy+Sample+Stock>0)and ISNULL(AutoCalcAllow,'Y')='Y' ");
                                DataRow[] dr3 =
                                    _DataTableClientMedicationScriptDrugs.Select("ClientMedicationInstructionId in(" +
                                                                                 _strMedicationInstructionIds +
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
                            DataRow[] drInstructions =
                                _DataTableClientMedicationInstructions.Select("ClientMedicationId=" +
                                                                              Convert.ToInt32(
                                                                                  dr["ClientMedicationId"].ToString()));

                            foreach (DataRow dr1 in drInstructions)
                            {
                                if (_strMedicationInstructionIds == "")
                                {
                                    _strMedicationInstructionIds += dr1["ClientMedicationInstructionId"].ToString();
                                }
                                else
                                {
                                    _strMedicationInstructionIds += "," + dr1["ClientMedicationInstructionId"];
                                }
                            }
                            if (_strMedicationInstructionIds != "")
                            {
                                //Changes by Sonia
                                //Ref Task #64 Error Preventing Script Creation (1)
                                //Changed the Logic to include those Medications in Script as well where Pharm<=0 but (Pharmacy+Sample+Stock) Should be >0
                                DataRow[] dr2 =
                                    _DataTableClientMedicationScriptDrugs.Select("ClientMedicationInstructionId in(" +
                                                                                 _strMedicationInstructionIds +
                                                                                 ") and (Pharmacy+Sample+Stock>0) ");
                                //Changes end over here
                                if (dr2.Length > 0)
                                    DataTableClientMedicationsControlledNonSampleORStockDrugs.Rows.Add(dr.ItemArray);
                            }
                        }
                    }


                    dsTemp = new DataSet();
                    //commented as per Task #6 Med Mgt 1.5 -Support
                    /*  dsTemp.Merge(DataTableClientMedicationsC2SampleORStockDrugs);
                    if (dsTemp.Tables.Count > 0)
                        dsTemp.Tables[0].TableName = "ClientMedicationsC2SampleORStockDrugs";
                    else
                        dsTemp.Merge(new DataTable("ClientMedicationsC2SampleORStockDrugs"));*/

                    dsTemp.Merge(DataTableClientMedicationsC2NonSampleORStockDrugs);
                    if (dsTemp.Tables.Count > 0)
                        dsTemp.Tables[0].TableName = "ClientMedicationsC2NonSampleORStockDrugs";
                    else
                        dsTemp.Merge(new DataTable("ClientMedicationsC2NonSampleORStockDrugs"));


                    //New Code added to accomodate changes
                    //commented as per Task #6 Med Mgt 1.5 -Support
                    /*dsTemp.Merge(DataTableClientMedicationsNCSampleORStockDrugs);
                    if (dsTemp.Tables.Count > 2)
                        dsTemp.Tables[2].TableName = "ClientMedicationsNCSampleORStockDrugs";
                    else
                        dsTemp.Merge(new DataTable("ClientMedicationsNCSampleORStockDrugs"));*/
                    dsTemp.Merge(DataTableClientMedicationsNCNonSampleORStockDrugs);
                    if (dsTemp.Tables.Count > 1)
                        dsTemp.Tables[1].TableName = "ClientMedicationsNCNonSampleORStockDrugs";
                    else
                        dsTemp.Merge(new DataTable("ClientMedicationsNCNonSampleORStockDrugs"));


                    //

                    //Controlled Medications
                    //commented as per Task #6 Med Mgt 1.5 -Support
                    /*dsTemp.Merge(DataTableClientMedicationsControlledSampleORStockDrugs);
                    if (dsTemp.Tables.Count > 4)
                        dsTemp.Tables[4].TableName = "ClientMedicationsControlledSampleORStockDrugs";
                    else
                        dsTemp.Merge(new DataTable("ClientMedicationsControlledSampleORStockDrugs"));*/

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

                    //Added by Chandan for Task#2578 
                    //nCategory2ScriptCount = ScriptsCount(_Category2Drugs);
                    nCategory2ScriptCount = _Category2Drugs;
                    //Added end by Chandan for Task#2578 
                    nOtherCategoryScriptCount = ScriptsCount(_OtherCategoryDrugs);
                    //Task#2580
                    //nControlledScriptCount = ScriptsCount(_ControlledDrugs);
                    nControlledScriptCount = _ControlledDrugs;

                    int NoOfRowsToBeCopied = 0;

                    #region Generate Category2Scripts

                    //Code added as per chat with Tom to insert records in ClientMedycationScriptDrugStrengths for C2 MEdications
                    //on basis of Script generated
                    foreach (DataRow dr in dsTemp.Tables["ClientMedicationsC2NonSampleORStockDrugs"].Rows)
                    {
                        DataRow[] drClientMedicationDrugStrength =
                            ObjectClientMedication.Tables["ClientMedicationScriptDrugStrengths"].Select(
                                "ClientMedicationID=" + dr["clientMedicationId"]);
                        if (drClientMedicationDrugStrength.Length > 0)
                        {
                            foreach (DataRow drDrugStrength in drClientMedicationDrugStrength)
                            {
                                ObjectClientMedication.Tables["ClientMedicationScriptDrugStrengths"].Rows.Remove(
                                    drDrugStrength);
                            }
                        }
                    }
                    NoOfRowsToBeCopied = 0;

                    //Ref to Task#33
                    bool isScript = false;
                    for (int i = 0; i < dsTemp.Tables["ClientMedicationsC2NonSampleORStockDrugs"].Rows.Count; i++)
                    {
                        //Modified by Loveena in ref to Task#2656                        
                        DataRow[] dtrowInstructions =
                            ObjectClientMedication.Tables["ClientMedicationInstructions"].Select(
                                "ClientMedicationId=" +
                                dsTemp.Tables["ClientMedicationsC2NonSampleORStockDrugs"].Rows[i]["ClientMedicationId"] +
                                " and Active='Y'", "StartDate Asc");
                        //DataRow[] dtrowInstructions = DataSetClientMedications.Tables["ClientMedicationInstructions"].Select("ClientMedicationId=" + dsTemp.Tables["ClientMedicationsC2NonSampleORStockDrugs"].Rows[i]["ClientMedicationId"], "StartDate Asc");
                        if (dtrowInstructions.Length > 0)
                        {
                            for (int index = 0; index < dtrowInstructions.Length; index++)
                            {
                                if (index > 0)
                                {
                                    if (dtrowInstructions[index - 1]["StartDate"].ToString() !=
                                        dtrowInstructions[index]["StartDate"].ToString())
                                    {
                                        GenerateScriptsTableRows('N', iMedicationRowsCount,
                                                                 dsTemp.Tables[
                                                                     "ClientMedicationsC2NonSampleORStockDrugs"],
                                                                 NoOfRowsToBeCopied, "C2");
                                        //Ref to Task#33
                                        DataRow[] drScriptInstructions =
                                            ObjectClientMedication.Tables["ClientMedicationScriptDrugs"].Select(
                                                "ClientMedicationInstructionId=" +
                                                dtrowInstructions[index]["ClientMedicationInstructionId"]);
                                        if (drScriptInstructions.Length > 0)
                                            //for (int loopCnt = 0; loopCnt < drScriptInstructions.Length; loopCnt++)
                                            //    {
                                            //if (Convert.ToInt32(DataSetClientMedications_Temp.Tables["ClientMedicationScripts"].Rows[index]["ClientMedicationScriptId"]) == 0)

                                            drScriptInstructions[0]["ClientMedicationScriptId"] = scriptId;
                                        //Added in ref to Task#85 as per Tom's Comment to add qula no. of rows to CMSD
                                        //DataSetClientMedications_Temp.Tables["ClientMedicationScriptDrugStrengths"].Rows[index]["ClientMedicationScriptId"] = scriptId;
                                        //Code added as per chat with Tom to insert records in ClientMedycationScriptDrugStrengths for C2 MEdications
                                        //on basis of Script generated
                                        DataRow dataRowClientMEdicationScriptDrugStrengths =
                                            ObjectClientMedication.Tables["ClientMedicationScriptDrugStrengths"].NewRow();
                                        int id = 0;
                                        if (
                                            ObjectClientMedication.Tables["ClientMedicationScriptDrugStrengths"].Rows
                                                                                                                .Count >
                                            0)
                                        {
                                            id =
                                                Convert.ToInt32(
                                                    ObjectClientMedication.Tables["ClientMedicationScriptDrugStrengths"]
                                                        .Compute("Max(ClientMedicationScriptDrugStrengthId)", ""));
                                            dataRowClientMEdicationScriptDrugStrengths[
                                                "ClientMedicationScriptDrugStrengthId"] = id + 1;
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
                                        //Code added by Loveena in ref to Task#2802
                                        dataRowClientMEdicationScriptDrugStrengths["PharmacyText"] =
                                            drScriptInstructions[0]["PharmacyText"];
                                        //Code ends over here.
                                        dataRowClientMEdicationScriptDrugStrengths["Sample"] =
                                            drScriptInstructions[0]["Sample"];
                                        dataRowClientMEdicationScriptDrugStrengths["Stock"] =
                                            drScriptInstructions[0]["Stock"];
                                        dataRowClientMEdicationScriptDrugStrengths["Refills"] = 0;
                                        dataRowClientMEdicationScriptDrugStrengths["RowIdentifier"] = Guid.NewGuid();
                                        dataRowClientMEdicationScriptDrugStrengths["CreatedBy"] =
                                            ((StreamlineIdentity)Context.User.Identity).UserCode;
                                        dataRowClientMEdicationScriptDrugStrengths["CreatedDate"] = DateTime.Now;
                                        // }
                                        dataRowClientMEdicationScriptDrugStrengths["ModifiedBy"] =
                                            ((StreamlineIdentity)Context.User.Identity).UserCode;
                                        dataRowClientMEdicationScriptDrugStrengths["ModifiedDate"] = DateTime.Now;
                                        // if (newRowCMSD == true)
                                        ObjectClientMedication.Tables["ClientMedicationScriptDrugStrengths"].Rows.Add(
                                            dataRowClientMEdicationScriptDrugStrengths);
                                        // }

                                        isScript = true;
                                    }
                                    else
                                    {
                                        //if(counter< counter)
                                        if (isScript == false)
                                        {
                                            GenerateScriptsTableRows('N', iMedicationRowsCount,
                                                                     dsTemp.Tables[
                                                                         "ClientMedicationsC2NonSampleORStockDrugs"],
                                                                     NoOfRowsToBeCopied, "C2");
                                            DataRow[] drScriptInstructions =
                                                ObjectClientMedication.Tables["ClientMedicationScriptDrugs"].Select(
                                                    "ClientMedicationInstructionId=" +
                                                    dtrowInstructions[index]["ClientMedicationInstructionId"]);
                                            if (drScriptInstructions.Length > 0)
                                                //for (int loopCnt = 0; loopCnt < drScriptInstructions.Length; loopCnt++)
                                                //    {
                                                //if (Convert.ToInt32(DataSetClientMedications_Temp.Tables["ClientMedicationScripts"].Rows[index]["ClientMedicationScriptId"]) == 0)
                                                //    drScriptInstructions[0]["ClientMedicationScriptId"] = Convert.ToInt32(DataSetClientMedications_Temp.Tables["ClientMedicationScripts"].Rows[index]["ClientMedicationScriptId"]) + 1;
                                                //else
                                                //    drScriptInstructions[0]["ClientMedicationScriptId"] = Convert.ToInt32(DataSetClientMedications_Temp.Tables["ClientMedicationScripts"].Rows[index]["ClientMedicationScriptId"]);

                                                drScriptInstructions[0]["ClientMedicationScriptId"] = scriptId;
                                            //Added in ref to Task#85 as per Tom's Comment to add qula no. of rows to CMSD
                                            //DataSetClientMedications_Temp.Tables["ClientMedicationScriptDrugStrengths"].Rows[index]["ClientMedicationScriptId"] = scriptId;
                                            //Code added as per chat with Tom to insert records in ClientMedycationScriptDrugStrengths for C2 MEdications
                                            //on basis of Script generated
                                            DataRow dataRowClientMEdicationScriptDrugStrengths =
                                                ObjectClientMedication.Tables["ClientMedicationScriptDrugStrengths"]
                                                    .NewRow();
                                            int id = 0;
                                            if (
                                                ObjectClientMedication.Tables["ClientMedicationScriptDrugStrengths"]
                                                    .Rows.Count > 0)
                                            {
                                                id =
                                                    Convert.ToInt32(
                                                        ObjectClientMedication.Tables[
                                                            "ClientMedicationScriptDrugStrengths"].Compute(
                                                                "Max(ClientMedicationScriptDrugStrengthId)", ""));
                                                dataRowClientMEdicationScriptDrugStrengths[
                                                    "ClientMedicationScriptDrugStrengthId"] = id + 1;
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
                                            //Code added by Loveena in ref to Task#2802
                                            dataRowClientMEdicationScriptDrugStrengths["PharmacyText"] =
                                                drScriptInstructions[0]["PharmacyText"];
                                            //Code ends over here.
                                            dataRowClientMEdicationScriptDrugStrengths["Sample"] =
                                                drScriptInstructions[0]["Sample"];
                                            dataRowClientMEdicationScriptDrugStrengths["Stock"] =
                                                drScriptInstructions[0]["Stock"];
                                            dataRowClientMEdicationScriptDrugStrengths["Refills"] = 0;
                                            dataRowClientMEdicationScriptDrugStrengths["RowIdentifier"] = Guid.NewGuid();
                                            dataRowClientMEdicationScriptDrugStrengths["CreatedBy"] =
                                                ((StreamlineIdentity)Context.User.Identity).UserCode;
                                            dataRowClientMEdicationScriptDrugStrengths["CreatedDate"] = DateTime.Now;
                                            // }
                                            dataRowClientMEdicationScriptDrugStrengths["ModifiedBy"] =
                                                ((StreamlineIdentity)Context.User.Identity).UserCode;
                                            dataRowClientMEdicationScriptDrugStrengths["ModifiedDate"] = DateTime.Now;
                                            // if (newRowCMSD == true)
                                            ObjectClientMedication.Tables["ClientMedicationScriptDrugStrengths"].Rows
                                                                                                                .Add(
                                                                                                                    dataRowClientMEdicationScriptDrugStrengths);
                                            //}
                                            isScript = true;
                                        }
                                        else
                                        {
                                            DataRow[] drScriptInstructions =
                                                ObjectClientMedication.Tables["ClientMedicationScriptDrugs"].Select(
                                                    "ClientMedicationInstructionId=" +
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
                                    GenerateScriptsTableRows('N', iMedicationRowsCount,
                                                             dsTemp.Tables["ClientMedicationsC2NonSampleORStockDrugs"],
                                                             NoOfRowsToBeCopied, "C2");
                                    DataRow[] drScriptInstructions =
                                        ObjectClientMedication.Tables["ClientMedicationScriptDrugs"].Select(
                                            "ClientMedicationInstructionId=" +
                                            dtrowInstructions[index]["ClientMedicationInstructionId"]);
                                    if (drScriptInstructions.Length > 0)
                                        drScriptInstructions[0]["ClientMedicationScriptId"] = scriptId;
                                    //Added in ref to Task#85 as per Tom's Comment to add qula no. of rows to CMSD
                                    //DataSetClientMedications_Temp.Tables["ClientMedicationScriptDrugStrengths"].Rows[index]["ClientMedicationScriptId"] = scriptId;
                                    //Code added as per chat with Tom to insert records in ClientMedycationScriptDrugStrengths for C2 MEdications
                                    //on basis of Script generated
                                    DataRow dataRowClientMEdicationScriptDrugStrengths =
                                        ObjectClientMedication.Tables["ClientMedicationScriptDrugStrengths"].NewRow();
                                    int id = 0;
                                    if (
                                        ObjectClientMedication.Tables["ClientMedicationScriptDrugStrengths"].Rows.Count >
                                        0)
                                    {
                                        id =
                                            Convert.ToInt32(
                                                ObjectClientMedication.Tables["ClientMedicationScriptDrugStrengths"]
                                                    .Compute("Max(ClientMedicationScriptDrugStrengthId)", ""));
                                        dataRowClientMEdicationScriptDrugStrengths[
                                            "ClientMedicationScriptDrugStrengthId"] = id + 1;
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
                                    //Code added by Loveena in ref to Task#2802
                                    dataRowClientMEdicationScriptDrugStrengths["PharmacyText"] =
                                        drScriptInstructions[0]["PharmacyText"];
                                    //Code ends over here.
                                    dataRowClientMEdicationScriptDrugStrengths["Sample"] =
                                        drScriptInstructions[0]["Sample"];
                                    dataRowClientMEdicationScriptDrugStrengths["Stock"] =
                                        drScriptInstructions[0]["Stock"];
                                    dataRowClientMEdicationScriptDrugStrengths["Refills"] = 0;
                                    dataRowClientMEdicationScriptDrugStrengths["RowIdentifier"] = Guid.NewGuid();
                                    dataRowClientMEdicationScriptDrugStrengths["CreatedBy"] =
                                        ((StreamlineIdentity)Context.User.Identity).UserCode;
                                    dataRowClientMEdicationScriptDrugStrengths["CreatedDate"] = DateTime.Now;
                                    // }
                                    dataRowClientMEdicationScriptDrugStrengths["ModifiedBy"] =
                                        ((StreamlineIdentity)Context.User.Identity).UserCode;
                                    dataRowClientMEdicationScriptDrugStrengths["ModifiedDate"] = DateTime.Now;
                                    // if (newRowCMSD == true)
                                    ObjectClientMedication.Tables["ClientMedicationScriptDrugStrengths"].Rows.Add(
                                        dataRowClientMEdicationScriptDrugStrengths);
                                    //}
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
                                                 dsTemp.Tables["ClientMedicationsNCNonSampleORStockDrugs"],
                                                 NoOfRowsToBeCopied, "NC");
                        NoOfRowsToBeCopied = NoOfRowsToBeCopied + RowsToBeCopiedincrmtcount;
                    }

                    #endregion

                    #region Generate ControlledCategoryScripts

                    NoOfRowsToBeCopied = 0;

                    for (int icount = 1; icount <= nControlledScriptCount; icount++)
                    {
                        iMedicationRowsCount = 0;
                        iloopCounter = 0;
                        iMedicationRowsCount =
                            dsTemp.Tables["ClientMedicationsControlledNonSampleORStockDrugs"].Rows.Count;

                        GenerateScriptsTableRows('N', iMedicationRowsCount,
                                                 dsTemp.Tables["ClientMedicationsControlledNonSampleORStockDrugs"],
                                                 NoOfRowsToBeCopied, "CT");
                        //Task#2580
                        //NoOfRowsToBeCopied = NoOfRowsToBeCopied + 3;
                        NoOfRowsToBeCopied = NoOfRowsToBeCopied + 1;
                    }

                    #endregion

                    //Remove the Last Row From ClientMedicationScripts Table which was generated in New Order Page just to Enforce Relations
                    ObjectClientMedication.Tables["ClientMedicationScripts"].Rows[0].Delete();
                    //Code Added by Pushpita date 5th Feb 2010 Ref: task 85 SDI Projects FY10 - Venture 
                    if (OrderingMethod == 'E')
                    {
                        if (_Queue == false)
                        {
                            DataTableSureScriptsOutgoingMessages =
                                ObjectClientMedication.Tables["SureScriptsOutgoingMessages"];
                            DataRowSureScriptsOutgoingMessages = DataTableSureScriptsOutgoingMessages.NewRow();
                            DataRowSureScriptsOutgoingMessages["ClientMedicationScriptId"] =
                                ObjectClientMedication.Tables["ClientMedicationScripts"].Rows[0][
                                    "ClientMedicationScriptId"];
                            DataRowSureScriptsOutgoingMessages["MessageStatus"] = 5541;
                            DataRowSureScriptsOutgoingMessages["RowIdentifier"] = Guid.NewGuid();
                            DataRowSureScriptsOutgoingMessages["CreatedBy"] =
                                ((StreamlineIdentity)Context.User.Identity).UserCode;
                            DataRowSureScriptsOutgoingMessages["CreatedDate"] = DateTime.Now;
                            DataRowSureScriptsOutgoingMessages["ModifiedBy"] =
                                ((StreamlineIdentity)Context.User.Identity).UserCode;
                            DataRowSureScriptsOutgoingMessages["ModifiedDate"] = DateTime.Now;
                            DataTableSureScriptsOutgoingMessages.Rows.Add(DataRowSureScriptsOutgoingMessages);
                            ObjectClientMedication.Merge(DataTableSureScriptsOutgoingMessages);
                        }
                        //Code added by Loveena in ref to  Task#85
                        //The number of records in ClientMedicationScriptDrugs and ClientMedicationScriptDrugStrengths 
                        //table are the same for Paper/Fax/Electronic, what could be different is the number 
                        //of records in ClientMedicationScripts table. In case of Paper/Fax there is only 1 
                        //insert in this table for the order. In case of Electronic, there is one per strength.
                        for (int i = 0; i < ObjectClientMedication.Tables["ClientMedications"].Rows.Count; i++)
                        {
                            if (
                                Convert.ToString(
                                    ObjectClientMedication.Tables["ClientMedications"].Rows[i]["DrugCategory"]) != "2")
                            {
                                DataRow[] dataRowClientMedicationScriptDrugStrengths =
                                    ObjectClientMedication.Tables["ClientMedicationScriptDrugStrengths"].Select(
                                        "ClientMedicationId=" +
                                        ObjectClientMedication.Tables["ClientMedications"].Rows[i]["ClientMedicationId"]);
                                foreach (DataRow dr in dataRowClientMedicationScriptDrugStrengths)
                                {
                                    DataRow[] dataRowClientMedicationInstructions =
                                        ObjectClientMedication.Tables["ClientMedicationInstructions"].Select(
                                            "ClientMedicationId=" + dr["ClientMedicationId"] + "and StrengthId=" +
                                            dr["StrengthId"]);
                                    foreach (DataRow dataRow in dataRowClientMedicationInstructions)
                                    {
                                        DataRow[] dataRowClientMedicationScriptDrugs =
                                            ObjectClientMedication.Tables["ClientMedicationScriptDrugs"].Select(
                                                "ClientMedicationInstructionId=" +
                                                dataRow["ClientMedicationInstructionId"]);
                                        foreach (DataRow dtRow in dataRowClientMedicationScriptDrugs)
                                        {
                                            dtRow["ClientMedicationScriptId"] = dr["ClientMedicationScriptId"];
                                        }
                                    }
                                }
                            }
                        }

                        //Code ends over here
                    }
                    DataSetTemp = new DataSet();
                    DataSetTemp = objClientMedication.UpdateDocuments(ObjectClientMedication);
                    //Added in ref to Task#86
                    DataTable dataTableClientMedicationScripts = DataSetTemp.Tables["ClientMedicationScripts"].Clone();
                    dataTableClientMedicationScripts.Merge(DataSetTemp.Tables["ClientMedicationScripts"]);
                    ObjectClientMedication = null;

                    //Make Clear the DataSetClientScripts
                    //#region SendFax

                    #region UpdateClientScriptActivities

                    //Following code will be used to update ClientScriptActivities table
                    DataSetClientScriptActivities = new DataSetClientScripts();
                    HiddenFieldAllFaxed.Value = "1";
                    //Send Fax if ordering Method is Fax
                    bool FlagForImagesDeletion = false;
                    //Added by anuj on 19Nov,2009 for task ref #3 SDI Projects FY10 - Venture 
                    //checking that queue order button ic clicked
                    if (_Queue == false)
                    {
                        if (OrderingMethod == 'F')
                        {
                            #region Sending Fax

                            //Code modified by Loveena in ref to Task#2589
                            ////get the Fax Number of Selected Pharmacy
                            //DataSetPharmacies = Streamline.UserBusinessServices.SharedTables.DataSetPharmacies;
                            SharedTables objectSharedTables = null;
                            objectSharedTables = new SharedTables();

                            DataSetPharmacies =
                                objectSharedTables.getPharmacies(((StreamlinePrinciple)Context.User).Client.ClientId);
                            //Added by Loveena in ref to Task#188 on 23-Feb-2009 as Stored Procedure ssp_SCGetDataFromPharmacies Modified.
                            drPharmacies = DataSetPharmacies.Tables[0].Select("LEN(FaxNumber) >= 7", "PharmacyName asc");
                            var DataSetEditPharmacies = new DataSet();
                            DataSetEditPharmacies.Merge(drPharmacies);
                            //Code Added by Loveena ends over here.


                            //Code Modified by Loveena in ref to task#188 on 23-Feb-2009 as Stored Procedure ssp_SCGetDataFromPharmacies Modified.
                            //drSelectedPharmacy = DataSetPharmacies.Tables[0].Select("PharmacyId=" + DropDownListPharmacies.SelectedValue);
                            //Condition added in ref to tAsk#85 to merger\ selected pharmacy to existing pharmacies in dropdown
                            if (HiddenFieldScriptsPharmacyId.Value != string.Empty)
                                drSelectedPharmacy =
                                    DataSetEditPharmacies.Tables[0].Select("PharmacyId=" +
                                                                           HiddenFieldScriptsPharmacyId.Value);
                            else if (((HiddenField)(Parent.FindControl("HiddenFieldPharmacyId"))).Value != "")
                                drSelectedPharmacy =
                                    DataSetEditPharmacies.Tables[0].Select("PharmacyId=" +
                                                                           ((HiddenField)
                                                                            (Parent.FindControl("HiddenFieldPharmacyId")))
                                                                               .Value);
                            //Modified Cde Ends over here.

                            if (drSelectedPharmacy.Length > 0)
                            {
                                strReceipeintName = drSelectedPharmacy[0]["PharmacyName"].ToString();
                                strReceipentOrganisation = drSelectedPharmacy[0]["PharmacyName"].ToString();
                                strReceipentFaxNumber = drSelectedPharmacy[0]["FaxNumber"].ToString();
                            }
                            //added By Priya Ref:task no:85
                            else if (((HiddenField)(Parent.FindControl("HiddenFieldPharmacyFaxNo"))).Value != "")
                            {
                                var _pharmacyFaxNo = ((HiddenField)(Parent.FindControl("HiddenFieldPharmacyFaxNo")));
                                string pharmacyFaxNo = _pharmacyFaxNo.Value;
                                strReceipentFaxNumber = pharmacyFaxNo;
                            }

                            for (int icount = 0;
                                 icount < DataSetTemp.Tables["ClientMedicationScripts"].Rows.Count;
                                 icount++)
                            {
                                if (icount == 0)
                                    FlagForImagesDeletion = true;
                                else
                                    FlagForImagesDeletion = false;
                                _strScriptsTobeFaxedButPrinted = false;
                                string strSelectClause = "ISNULL(DrugCategory,0)>=2  and  ClientMedicationScriptId=" +
                                                         DataSetTemp.Tables["ClientMedicationScripts"].Rows[icount][
                                                             "ClientMedicationScriptId"];
                                //Modified Code ends over here.
                                //changes end over here

                                if (DataSetTemp.Tables["ClientMedicationScriptDrugs"].Select(strSelectClause).Length > 0)
                                {
                                    _strScriptsTobeFaxedButPrinted = true;
                                    HiddenFieldAllFaxed.Value = "0";
                                }

                                //Code added by Loveena in ref to Task#2697


                                //If Non controlled Drugs
                                if (_strScriptsTobeFaxedButPrinted)
                                {
                                    //Modified by Loveena in ref to Task#2597
                                    bool ans =
                                        SendToPrinter(
                                            Convert.ToInt32(
                                                DataSetTemp.Tables["ClientMedicationScripts"].Rows[icount][
                                                    "ClientMedicationScriptId"]), FlagForImagesDeletion,
                                            strSendCoverLetter);
                                }
                                //If Controlled Drugs
                                else
                                {
                                    //Modified by Loveena in ref to Task#2597
                                    bool ans1 =
                                        SendToFax(
                                            Convert.ToInt32(
                                                DataSetTemp.Tables["ClientMedicationScripts"].Rows[icount][
                                                    "ClientMedicationScriptId"]),
                                            Convert.ToInt32(DropDownListPharmacies.SelectedValue), FlagForImagesDeletion,
                                            strSendCoverLetter);


                                    if (_strPrintChartCopy == "true" && ans1)
                                        PrintChartCopy(
                                            Convert.ToInt32(
                                                DataSetTemp.Tables["ClientMedicationScripts"].Rows[icount][
                                                    "ClientMedicationScriptId"]), strSendCoverLetter);
                                    //Added by Chandan on 20th Nov 2008 task#99 1.6.5 - Faxing Check for Service Status
                                    //If Sending Fax failed 
                                    else if (ans1 == false) //If Sending Fax failed
                                    {
                                        PrintPrescription(
                                            Convert.ToInt32(
                                                DataSetTemp.Tables["ClientMedicationScripts"].Rows[icount][
                                                    "ClientMedicationScriptId"]), strSendCoverLetter);
                                    }
                                }


                                if (strSendCoverLetter == "true")
                                {
                                    DataRow[] drPharmacy =
                                        DataSetClientScriptActivities.Tables["Pharmacies"].Select("PharmacyId=" +
                                                                                                  drSelectedPharmacy[0][
                                                                                                      "PharmacyId"]);
                                    if (drPharmacy[0]["NumberOfTimesFaxed"] == DBNull.Value)
                                        drPharmacy[0]["NumberOfTimesFaxed"] = 0;

                                    NumberOfTimesFaxSend = Convert.ToInt32(drPharmacy[0]["NumberOfTimesFaxed"]);
                                    NumberOfTimesFaxSend += 1;
                                    drPharmacy[0]["NumberOfTimesFaxed"] = NumberOfTimesFaxSend;
                                }
                            }

                            objClientMedication = new ClientMedication();
                            DataSetTempMeds =
                                objClientMedication.UpdateClientScriptActivities(DataSetClientScriptActivities);
                            ObjectClientMedication = null;

                            #endregion
                        }
                        //added by anuj on 25 feb, 2010 fro task ref 85
                        //else 
                        else if (OrderingMethod == 'P')
                        {
                            #region Sending Results to printer

                            for (int icount = 0;
                                 icount < DataSetTemp.Tables["ClientMedicationScripts"].Rows.Count;
                                 icount++)
                            {
                                if (icount == 0)
                                    FlagForImagesDeletion = true;
                                else
                                    FlagForImagesDeletion = false;
                                bool ans =
                                    SendToPrinter(
                                        Convert.ToInt32(
                                            DataSetTemp.Tables["ClientMedicationScripts"].Rows[icount][
                                                "ClientMedicationScriptId"]), FlagForImagesDeletion, strSendCoverLetter);
                            }

                            objClientMedication = new ClientMedication();
                            DataSetTempMeds =
                                objClientMedication.UpdateClientScriptActivities(DataSetClientScriptActivities);
                            ObjectClientMedication = null;

                            #endregion
                        }

                            //added by anuj on 25 feb, 2010 fro task ref 85
                        else if (OrderingMethod == 'E')
                        {
                            for (int icount = 0;
                                 icount < DataSetTemp.Tables["ClientMedicationScripts"].Rows.Count;
                                 icount++)
                            {
                                if (icount == 0)
                                {
                                    FlagForImagesDeletion = true;
                                }
                                else
                                {
                                    FlagForImagesDeletion = false;
                                }
                                //added By Priya
                                if (((HiddenField)Parent.FindControl("HiddenFieldRedirectFrom")).Value.ToUpper() ==
                                    "DASHBOARD" &&
                                    (_DrugsOrderMethod.ToUpper() == "REFILL" ||
                                     _DrugsOrderMethod.ToUpper() == "NEW ORDER"))
                                {
                                    var pharmacyid = (HiddenField)Page.FindControl("HiddenFieldRefillPharmacyId");
                                    PharmacyId = Convert.ToInt32(pharmacyid.Value);
                                }
                                else
                                {
                                    if (HiddenFieldScriptsPharmacyId.Value != string.Empty)
                                    {
                                        PharmacyId = Convert.ToInt32(HiddenFieldScriptsPharmacyId.Value);
                                    }
                                    else if (((HiddenField)(Parent.FindControl("HiddenFieldPharmacyId"))).Value != "")
                                    {
                                        PharmacyId =
                                            Convert.ToInt32(
                                                ((HiddenField)(Parent.FindControl("HiddenFieldPharmacyId"))).Value);
                                    }
                                }
                                bool ans3 =
                                    SendByElectronically(
                                        Convert.ToInt32(
                                            DataSetTemp.Tables["ClientMedicationScripts"].Rows[icount][
                                                "ClientMedicationScriptId"]), PharmacyId, FlagForImagesDeletion,
                                        strSendCoverLetter);
                            }
                            objClientMedication = new ClientMedication();
                            DataSetTempMeds =
                                objClientMedication.UpdateClientScriptActivities(DataSetClientScriptActivities);
                            ObjectClientMedication = null;
                        }
                    }

                    #endregion

                    //After ClientScript Activities have been updated Discontinue old Medications in case Choosen method was Change Order
                    DataRow[] DataRowsClientMedicationsToBeDiscontinued;
                    DataRow[] DataRowsClientMedicationsToBeRefilled;

                    DataSet _DataSetClientMedications = null;
                    try
                    {
                        if (_DrugsOrderMethod == "Refill" || _DrugsOrderMethod == "REFILL")
                        {
                            if (Session["ChangedOrderMedicationIds"] != null)
                            {
                                //DataSetClientMedications = new Streamline.UserBusinessServices.DataSets.DataSetClientMedications();
                                _DataSetClientMedications = new DataSet();

                                DataRowsClientMedicationsToBeRefilled =
                                    DataSetTemp.Tables["ClientMedications"].Select("ClientMedicationId in (" +
                                                                                   Session["ChangedOrderMedicationIds"] +
                                                                                   ")");
                                foreach (DataRow dr in DataRowsClientMedicationsToBeRefilled)
                                {
                                    dr["MedicationEndDate"] = dr["MedicationEndDate"];
                                    dr["ModifiedBy"] = ((StreamlineIdentity)Context.User.Identity).UserCode;
                                    dr["ModifiedDate"] = DateTime.Now;
                                }
                                _DataSetClientMedications.Merge(DataRowsClientMedicationsToBeRefilled);
                                _DataSetClientMedications.Tables[0].TableName = "ClientMedications";
                                objClientMedication = new ClientMedication();
                                DataSetTemp = objClientMedication.UpdateDocuments(_DataSetClientMedications);
                                ObjectClientMedication = null;


                                //ObjectClientMedication.DiscontinueMedication(Session["ChangedOrderMedicationIds"].ToString(), 'Y', ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode, "Change Order");
                            }
                        }
                        if (_DrugsOrderMethod == "Change" || _DrugsOrderMethod == "CHANGE" || _DrugsOrderMethod.ToUpper() == "COMPLETE")
                        {
                            if (Session["ChangedOrderMedicationIds"] != null)
                            {
                                //DataSetClientMedications = new Streamline.UserBusinessServices.DataSets.DataSetClientMedications();

                                _DataSetClientMedications = new DataSet();

                                _DataSetClientSummary = (DataSet)Session["DataSetClientSummary"];
                                //Added and Commented by Chandan for task #133-1.7.3 - Change Order - ClientMedications and ClientMedicationInstructions
                                //DataRowsClientMedicationsToBeDiscontinued = _DataSetClientSummary.Tables["ClientMedications"].Select("ClientMedicationId in (" + Session["ChangedOrderMedicationIds"].ToString() + ")");
                                DataRowsClientMedicationsToBeDiscontinued =
                                    _DataSetClientSummary.Tables["ClientMedicationInstructions"].Select(
                                        "ClientMedicationId in (" + Session["ChangedOrderMedicationIds"] + ")");
                                //Added by chandan end here
                                foreach (DataRow dr in DataRowsClientMedicationsToBeDiscontinued)
                                {
                                    //Added and Commented by Chandan for task #133-1.7.3 - Change Order - ClientMedications and ClientMedicationInstructions
                                    //dr["Discontinued"] = "Y";
                                    //dr["DiscontinueDate"] = System.DateTime.Now;
                                    //dr["DiscontinuedReason"] = "Change Order";
                                    dr["Active"] = "N";
                                    //Added and Commented by Chandan end here
                                    dr["ModifiedBy"] = ((StreamlineIdentity)Context.User.Identity).UserCode;
                                    dr["ModifiedDate"] = DateTime.Now;
                                }
                                _DataSetClientMedications.Merge(DataRowsClientMedicationsToBeDiscontinued);
                                //Added and Commented by Chandan for task #133-1.7.3 - Change Order - ClientMedications and ClientMedicationInstructions
                                //_DataSetClientMedications.Tables[0].TableName = "ClientMedications";
                                _DataSetClientMedications.Tables[0].TableName = "ClientMedicationInstructions";
                                //Added and Commented by Chandan end here
                                objClientMedication = new ClientMedication();
                                DataSetTemp = objClientMedication.UpdateDocuments(_DataSetClientMedications);


                                if (Session["ClientMedicationInteractionIds"].ToString() != "")
                                    objClientMedication.DeleteInteractions(
                                        Session["ClientMedicationInteractionIds"].ToString());
                                objClientMedication = null;

                                //ObjectClientMedication.DiscontinueMedication(Session["ChangedOrderMedicationIds"].ToString(), 'Y', ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode, "Change Order");
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        if (ex.Data["CustomExceptionInformation"] == null)
                            ex.Data["CustomExceptionInformation"] =
                                "##Source Event Name -Prescribe Screen- DocumentUpdateDocument()-Discontinue Medications-Change Order Case";
                        else
                            ex.Data["CustomExceptionInformation"] = "";
                        if (ex.Data["DatasetInfo"] == null)
                            ex.Data["DatasetInfo"] = null;
                        LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error,
                                                this);
                    }
                    finally
                    {
                        DataRowsClientMedicationsToBeDiscontinued = null;
                        DataRowsClientMedicationsToBeRefilled = null;
                        if (_DataSetClientMedications != null)
                            _DataSetClientMedications.Dispose();
                    }


                    Session["DataSetPrescribedClientMedications"] = null;
                    //Added by Anuj on 19 nov,2009 for task ref #3 SDI Projects FY10 - Venture 
                    //Checking queue order button is clicked
                    if (_Queue == false)
                    {
                        Session["medicationIdList"] = null;
                        int PrinterLocation = 0;
                        if (HiddenPrinterDeviceLocations.Value != "" && HiddenPrinterDeviceLocations.Value != null)
                            PrinterLocation = Convert.ToInt32(HiddenPrinterDeviceLocations.Value);
                        //Condition added by Loveena in ref to Task#86 prescription print and chart copy to different printers based on a preference in Staff.
                        if (CheckBoxPrintChartCopy.Checked && DropDownListChartCopyPrinter.SelectedIndex > 0 &&
                            OrderingMethod != 'F')
                        {
                            string printerName = "";
                            string FileName = "";
                            int chartCopy = 0;
                            int ChartPrinterLocation = 0;
                            if (DropDownListChartCopyPrinter.SelectedIndex >= 0)
                                ChartPrinterLocation = Convert.ToInt32(DropDownListChartCopyPrinter.SelectedValue);

                            foreach (
                                string file in
                                    Directory.GetFiles(Server.MapPath("RDLC\\" + Context.User.Identity.Name + "\\")))
                            {
                                //Condition 
                                for (int icount = 0; icount < dataTableClientMedicationScripts.Rows.Count; icount++)
                                {
                                    if (
                                        (file.IndexOf("001" +
                                                      dataTableClientMedicationScripts.Rows[icount][
                                                          "ClientMedicationScriptId"]) > 0) ||
                                        (file.IndexOf("002" +
                                                      dataTableClientMedicationScripts.Rows[icount][
                                                          "ClientMedicationScriptId"]) >= 0))
                                    {
                                        chartCopy = file.IndexOf("\\002");
                                        if (chartCopy > 0)
                                        {
                                            FileName = file.Substring(file.LastIndexOf("\\") + 1);
                                            DataRow[] dr =
                                                SharedTables.DataSetPrinterDeviceLocations.Tables[0].Select(
                                                    "PrinterDeviceLocationId=" + ChartPrinterLocation);
                                            var prnDoc = new PrintDocument();

                                            if (dr.Length > 0)
                                            {
                                                printerName = dr[0]["DeviceUNCPath"].ToString();
                                            }
                                            prnDoc.PrinterSettings.PrinterName = printerName;
                                            if ((FileName.IndexOf("JPEG") >= 0 || FileName.IndexOf("jpeg") >= 0))
                                            {
                                                imageToConvert =
                                                    Image.FromFile(
                                                        Server.MapPath(".\\RDLC\\" + Context.User.Identity.Name + "\\" +
                                                                       FileName));

                                                if (prnDoc.PrinterSettings.IsValid)
                                                {
                                                    prnDoc.PrinterSettings.IsDirectPrintingSupported(imageToConvert);
                                                    prnDoc.PrintPage += PrintFormHandler;
                                                    prnDoc.Print();
                                                    prnDoc.PrintPage -= PrintFormHandler;
                                                    if (
                                                        ((HiddenField)Parent.FindControl("HiddenFieldRedirectFrom"))
                                                            .Value.ToUpper() == "DASHBOARD")
                                                        ScriptManager.RegisterStartupScript(Label1, Label1.GetType(),
                                                                                            ClientID,
                                                                                            "redirectToStartPage();",
                                                                                            true);
                                                    else
                                                        ScriptManager.RegisterStartupScript(Label1, Label1.GetType(),
                                                                                            ClientID,
                                                                                            "redirectToManagementPage();",
                                                                                            true);
                                                }
                                                else
                                                {
                                                    imageToConvert = null;
                                                    //HiddenFieldShowError.Value = "Printer location path is not Valid.";
                                                    ScriptManager.RegisterStartupScript(Label1, Label1.GetType(),
                                                                                        ClientID,
                                                                                        "CommonFunctions.PrintMedicationScript('" +
                                                                                        _strScriptIds + "'," +
                                                                                        HiddenFieldAllFaxed.Value + ",'" +
                                                                                        _strChartScripts + "',true);",
                                                                                        true);
                                                    return false;
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        //Code added by Loveena in ref to Task#23 on 30Nov2009
                        //if (RadioButtonPrintScript.Checked == true && DropDownListPrinterDeviceLocations.SelectedIndex > 0)
                        if (RadioButtonPrintScript.Checked && PrinterLocation > 0 && OrderingMethod != 'F')
                        {
                            string printerName = "";
                            string FileName = "";
                            DataRow[] dr =
                                SharedTables.DataSetPrinterDeviceLocations.Tables[0].Select("PrinterDeviceLocationId=" +
                                                                                            PrinterLocation);
                            if (dr.Length > 0)
                            {
                                printerName = dr[0]["DeviceUNCPath"].ToString();
                            }
                            var prnDoc = new PrintDocument();
                            prnDoc.PrinterSettings.PrinterName = printerName;

                            foreach (
                                string file in
                                    Directory.GetFiles(Server.MapPath("RDLC\\" + Context.User.Identity.Name + "\\")))
                            {
                                FileName = file.Substring(file.LastIndexOf("\\") + 1);
                                //Condition added by Loveena in ref to Task#86 to avoid the problem of  image is still pending on print job then it will through a exception that can't delete image is used by another process
                                for (int icount = 0; icount < dataTableClientMedicationScripts.Rows.Count; icount++)
                                {
                                    if (
                                        FileName.IndexOf("001" +
                                                         dataTableClientMedicationScripts.Rows[icount][
                                                             "ClientMedicationScriptId"]) >= 0)
                                    {
                                        if ((FileName.IndexOf("JPEG") >= 0 || FileName.IndexOf("jpeg") >= 0))
                                        {
                                            imageToConvert =
                                                Image.FromFile(
                                                    Server.MapPath(".\\RDLC\\" + Context.User.Identity.Name + "\\" +
                                                                   FileName));

                                            if (prnDoc.PrinterSettings.IsValid)
                                            {
                                                prnDoc.PrinterSettings.IsDirectPrintingSupported(imageToConvert);
                                                prnDoc.PrintPage += PrintFormHandler;
                                                prnDoc.Print();
                                                prnDoc.PrintPage -= PrintFormHandler;
                                                ScriptManager.RegisterStartupScript(Label1, Label1.GetType(), ClientID,
                                                                                    "redirectToManagementPage();", true);
                                            }
                                            else
                                            {
                                                imageToConvert = null;
                                                //HiddenFieldShowError.Value = "Printer location path is not Valid.";
                                                ScriptManager.RegisterStartupScript(Label1, Label1.GetType(), ClientID,
                                                                                    "CommonFunctions.PrintMedicationScript('" +
                                                                                    _strScriptIds + "'," +
                                                                                    HiddenFieldAllFaxed.Value + ",'" +
                                                                                    _strChartScripts + "',true);", true);
                                                return false;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        else
                        {
                            if (HiddenFieldAllFaxed.Value == "0" || OrderingMethod == 'P' || _strChartCopiesToBePrinted)
                            {
                                ScriptManager.RegisterStartupScript(Label1, Label1.GetType(), ClientID,
                                                                    "CommonFunctions.PrintMedicationScript('" +
                                                                    _strScriptIds + "'," + HiddenFieldAllFaxed.Value +
                                                                    ",'" + _strChartScripts + "',true);", true);
                            }
                            //Added by Chandan on 20th Nov 2008 task#99 1.6.5 - Faxing Check for Service Status
                            //Added else if Condition and a new parameter FaxStatus , If Sending Fax failed 
                            else if (_strFaxFailed) // in case sending fax failed 
                            {
                                ScriptManager.RegisterStartupScript(Label1, Label1.GetType(), ClientID,
                                                                    "CommonFunctions.PrintMedicationScript('" +
                                                                    _strFaxFailedScripts + "'," +
                                                                    HiddenFieldAllFaxed.Value + ",'" + _strChartScripts +
                                                                    "',false);", true);
                            }
                            //end here 
                            else
                            {
                                if (((HiddenField)Parent.FindControl("HiddenFieldRedirectFrom")).Value.ToUpper() ==
                                    "DASHBOARD")
                                    ScriptManager.RegisterStartupScript(Label1, Label1.GetType(), ClientID,
                                                                        "redirectToStartPage();", true);
                                else
                                    ScriptManager.RegisterStartupScript(Label1, Label1.GetType(), ClientID,
                                                                        "redirectToManagementPage();", true);
                            }
                        }
                    }
                    //Added by Anuj on 19 nov,2009 for task ref #3 SDI Projects FY10 - Venture 
                    //Checking queue order button is clicked
                    else
                    {
                        if (((HiddenField)Parent.FindControl("HiddenFieldRedirectFrom")).Value.ToUpper() == "DASHBOARD")
                            ScriptManager.RegisterStartupScript(Label1, Label1.GetType(), ClientID,
                                                                "redirectToStartPage();", true);
                        else
                            ScriptManager.RegisterStartupScript(Label1, Label1.GetType(), ClientID,
                                                                "redirectToManagementPage();", true);
                    }
                }
                else
                {
                    ScriptManager.RegisterStartupScript(Label1, Label1.GetType(), ClientID, "redirectToLoginPage();",
                                                        true);
                }
                if (OrderingMethod == 'E')
                    ScriptManager.RegisterStartupScript(Label1, Label1.GetType(), ClientID,
                                                        "redirectToManagementPage();", true);

                return true;
                //true should be returned only if document has been updated successfully reference Task #50 MM1.5
            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally
            {
                //DataSetClientScripts = null;
                DataSetClientScriptActivities = null;
                ObjectClientMedication = null;
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

        public bool SendToPrinter(int ScriptId, bool FlagForImagesDeletion, string SendCoveLetter)
        {
            #region Sending Results to printer

            // Declare objects
            DataSet DataSetTemp = null;
            try
            {
                GetRDLCContents(ScriptId, false, FlagForImagesDeletion, "P", SendCoveLetter);

                if (_strScriptIds == "")
                {
                    _strScriptIds += FolderId;
                }
                else
                {
                    _strScriptIds += "^" + FolderId;
                }

                #region InsertRowsIntoClientScriptActivities

                ////Insert Rows into ClientScriptActivities
                DataRow drClientMedicationScriptsActivity =
                    DataSetClientScriptActivities.Tables["ClientMedicationScriptActivities"].NewRow();
                drClientMedicationScriptsActivity["ClientMedicationScriptId"] = ScriptId;
                drClientMedicationScriptsActivity["Method"] = 'P';
                drClientMedicationScriptsActivity["PharmacyId"] = DBNull.Value;
                drClientMedicationScriptsActivity["Reason"] = DBNull.Value;
                drClientMedicationScriptsActivity["FaxStatusDate"] = DateTime.Now;
                //drClientMedicationScriptsActivity["FaxStatus"] = System.DBNull.Value;
                //Added by Anuj on 24 feb, for task ref 85
                drClientMedicationScriptsActivity["Status"] = DBNull.Value;
                drClientMedicationScriptsActivity["StatusDescription"] = DBNull.Value;
                //ended over here
                drClientMedicationScriptsActivity["FaxExternalIdentifier"] = DBNull.Value;

                //Added By chandan for task #85 
                if (CheckBoxPrintChartCopy.Checked)
                    drClientMedicationScriptsActivity["IncludeChartCopy"] = "Y";
                else
                    drClientMedicationScriptsActivity["IncludeChartCopy"] = "N";

                drClientMedicationScriptsActivity["RowIdentifier"] = Guid.NewGuid();
                drClientMedicationScriptsActivity["CreatedBy"] = ((StreamlineIdentity)Context.User.Identity).UserCode;
                drClientMedicationScriptsActivity["CreatedDate"] = DateTime.Now;
                drClientMedicationScriptsActivity["ModifiedBy"] = ((StreamlineIdentity)Context.User.Identity).UserCode;
                drClientMedicationScriptsActivity["ModifiedDate"] = DateTime.Now;
                DataSetClientScriptActivities.Tables["ClientMedicationScriptActivities"].Rows.Add(
                    drClientMedicationScriptsActivity);
                using (
                    var _clientMedication = new ClientMedication())
                {
                    _clientMedication.SetRenderedImageData(DataSetClientScriptActivities,
                                                           drClientMedicationScriptsActivity,
                                                           ((StreamlineIdentity)
                                                            Context.User.Identity).UserCode, renderedBytes);
                }

                #endregion

                #region InsertRowsIntoClientScriptActivityPending

                //Added by anuj on 25 feb,2010 fro task ref 85
                DataRow drClientMedicationScriptsActivityPending =
                    DataSetClientScriptActivities.Tables["ClientMedicationScriptActivitiesPending"].NewRow();
                drClientMedicationScriptsActivityPending["ClientMedicationScriptActivityId"] =
                    drClientMedicationScriptsActivity["ClientMedicationScriptActivityId"].ToString();
                drClientMedicationScriptsActivityPending["RowIdentifier"] = Guid.NewGuid();
                drClientMedicationScriptsActivityPending["CreatedBy"] =
                    ((StreamlineIdentity)Context.User.Identity).UserCode;
                drClientMedicationScriptsActivityPending["CreatedDate"] = DateTime.Now;
                drClientMedicationScriptsActivityPending["ModifiedBy"] =
                    ((StreamlineIdentity)Context.User.Identity).UserCode;
                drClientMedicationScriptsActivityPending["ModifiedDate"] = DateTime.Now;
                DataSetClientScriptActivities.Tables["ClientMedicationScriptActivitiesPending"].Rows.Add(
                    drClientMedicationScriptsActivityPending);
                //Ended over here

                #endregion

                return true;
            }


            catch (COMException ex)
            {
                string strEx = ex.Message;
                throw (ex);
            }
            finally
            {
                DataSetTemp = null;
            }

            #endregion
        }

        /// <summary>
        ///     Added by Sonia to get and render the RDLC Contents of Script in PDF format or images
        /// </summary>
        /// <param name="ScriptId"></param>
        /// <param name="ToBeFaxed"></param>
        /// <param name="FlagForImagesDeletion"></param>
        /// <param name="OrderingMethod"></param>
        public void GetRDLCContents(int ScriptId, bool ToBeFaxed, bool FlagForImagesDeletion, string OrderingMethod,
                                    string SendCoveLetter)
        {
            #region Get RDLC Contents

            string _ReportPath = "";
            string mimeType;
            string encoding;
            string fileNameExtension;
            string[] streams;

            //Added by Chandan for the task 2404 -1.7.2 - Prescribe Page: Print Chart Copy
            string _PrintChartCopy = "N";
            if (CheckBoxPrintChartCopy.Checked)
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
            reportViewer1 = new ReportViewer();

            try
            {
                _ReportPath = Server.MapPath(".") + ConfigurationManager.AppSettings["MedicationPerscriptionReportUrl"];
                if (_ReportPath == "") //Check For Report Path
                {
                    strErrorMessage = "ReportPath is Missing In WebConfig";
                    ScriptManager.RegisterStartupScript(Label1, Label1.GetType(), ClientID,
                                                        "ClientMedicationOrder.ShowError('" + strErrorMessage +
                                                        "', true);", true);
                    return;
                }
            }
            catch (Exception ex)
            {
                LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);

                strErrorMessage = "ReportPath Key is Missing In WebConfig";
                ScriptManager.RegisterStartupScript(Label1, Label1.GetType(), ClientID,
                                                    "ClientMedicationOrder.ShowError('" + strErrorMessage + "', true);",
                                                    true);
                return;
            }
            finally
            {
                objLogManager = null;
            }

            try
            {
                //  _DataSetRdl = new DataSet();//Commented by Vikas Vyas On Dated March 04 2008
                ClientMedication objectClientMedications = null;
                objectClientMedications = new ClientMedication();
                //Added by Chandan for getting Location Id
                if (HiddenFieldLocationId.Value != string.Empty)
                    LocationId = Convert.ToInt32(HiddenFieldLocationId.Value);
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
                else
                    _DataSetGetRdlCName = objectClientMedications.GetRdlCNameDataBase(1036);

                _DataSetGetRdlCName.Tables[0].TableName = "DocumentCodes";
                _DataSetGetRdlCName.Tables[1].TableName = "DocumentCodesRDLSubReports";


                if (_DataSetGetRdlCName.Tables["DocumentCodes"].Rows.Count > 0)
                {
                    dr = _DataSetGetRdlCName.Tables["DocumentCodes"].Select();
                    //because DocumentCodes table only contain one row

                    //Commented by Sonia as now Ordering Method will be passed as a parameter to GetRDLC function
                    /*    if (ToBeFaxed == true)
                        _OrderingMethod = "F";
                    else
                        _OrderingMethod = "P";*/

                    _OrderingMethod = OrderingMethod;


                    //Check For Main Report
                    if ((dr[0]["DocumentName"] != DBNull.Value ||
                         !String.IsNullOrEmpty(dr[0]["DocumentName"].ToString())) &&
                        (dr[0]["ViewStoredProcedure"] != DBNull.Value ||
                         !String.IsNullOrEmpty(dr[0]["ViewStoredProcedure"].ToString())))
                    {
                        #region Get the StoredProceudreName and Execute

                        string _StoredProcedureName = "";
                        string _ReportName = "";
                        _StoredProcedureName = dr[0]["ViewStoredProcedure"].ToString(); //Get the StoredProcedure Name
                        _ReportName = dr[0]["DocumentName"].ToString();

                        reportViewer1.ProcessingMode = ProcessingMode.Local;
                        reportViewer1.LocalReport.ReportPath = _ReportPath + "\\" + _ReportName + ".rdlc";
                        reportViewer1.LocalReport.DataSources.Clear();


                        //Get Data For Main Report
                        //One More Parameter Added by Chandan Task#85 MM1.7
                        _DataSetRdlForMainReport = objectClientMedications.GetDataForRdlC(_StoredProcedureName, ScriptId,
                                                                                          _OrderingMethod,
                                                                                          Convert.ToInt32(
                                                                                              Session[
                                                                                                  "OriginalDataUpdated"]),
                                                                                          LocationId, _PrintChartCopy,
                                                                                          Session.SessionID,
                                                                                          string.Empty);
                        //Microsoft.Reporting.WebForms.ReportDataSource DataSource = new ReportDataSource("RdlReportDataSet_" + _StoredProcedureName, _DataSetRdlForMainReport.Tables[0]);


                        var DataSource = new ReportDataSource("RDLReportDataSet_" + _StoredProcedureName,
                                                              _DataSetRdlForMainReport.Tables[0]);
                        //Added by Chandan 0n 18th Dec 2008
                        //Session["DataSetRdlTemp"] = null;
                        var dstemp = (DataSet)Session["DataSetRdlTemp"];
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

                            reportViewer1.LocalReport.SubreportProcessing -= SetSubDataSource;
                            reportViewer1.LocalReport.SubreportProcessing += SetSubDataSource;

                            for (int i = 0; i < _drSubReport.Length; i++) //Loop 
                            {
                                if ((_drSubReport[i]["SubReportName"] != DBNull.Value ||
                                     !String.IsNullOrEmpty(_drSubReport[i]["SubReportName"].ToString())) &&
                                    (_drSubReport[i]["StoredProcedure"] != DBNull.Value ||
                                     !String.IsNullOrEmpty(_drSubReport[i]["StoredProcedure"].ToString())))
                                {
                                    #region Get the StoredProcedureName For SubReport and Execute

                                    string _SubReportStoredProcedure = "";
                                    string _SubReportName = "";
                                    _SubReportStoredProcedure = _drSubReport[i]["StoredProcedure"].ToString();
                                    _SubReportName = _drSubReport[i]["SubReportName"].ToString();
                                    //Get Data For SubReport
                                    //Added By Chandan Task#85 MM #1.7
                                    _DataSetRdlForSubReport =
                                        objectClientMedications.GetDataForRdlC(_SubReportStoredProcedure, ScriptId,
                                                                               _OrderingMethod,
                                                                               Convert.ToInt32(
                                                                                   Session["OriginalDataUpdated"]),
                                                                               LocationId, _PrintChartCopy,
                                                                               Session.SessionID, string.Empty);

                                    var rds = new ReportDataSource(_SubReportName, _DataSetRdlForSubReport.Tables[0]);
                                    reportViewer1.LocalReport.DataSources.Add(rds);
                                    string strRootPath = Server.MapPath(".");

                                    var RdlSubReport =
                                        new StreamReader(_ReportPath + "\\" + _SubReportName.Trim() + ".rdlc");

                                    reportViewer1.LocalReport.LoadReportDefinition(RdlSubReport);

                                    #endregion
                                }
                            } //End For Loop
                        }
                        //Code addded by Loveena in ref to Task#2597                        
                        if (OrderingMethod == "F" && ToBeFaxed)
                        {
                            if (_DataSetRdlForMainReport.Tables[0].Rows.Count > 0)
                            {
                                SendCoveLetter =
                                    _DataSetRdlForMainReport.Tables[0].Rows[0]["ShowCoverLetter"].ToString();
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
                Warning[] warnings;
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
                        using (var objRDLC = new RDLCPrint())
                        {
                            //Code commented by Loveena in ref to Task#86 to avoid the problem of  image is still pending on print job then it will through a exception that can't delete image is used by another process
                            //In case of Ordering method as X Chart copy will be printed
                            if (OrderingMethod == "X")
                                //Modified in ref to Task#2660
                                //objRDLC.Run(this.reportViewer1.LocalReport, Server.MapPath("RDLC\\" + Context.User.Identity.Name), ScriptId.ToString(), FlagForImagesDeletion, true);
                                objRDLC.Run(reportViewer1.LocalReport,
                                            Server.MapPath("RDLC\\" + Context.User.Identity.Name), FolderId,
                                            FlagForImagesDeletion, true);
                            else //In case of Ordering method as P Chart copy will not be printed
                                //Modified in ref to Task#2660
                                //objRDLC.Run(this.reportViewer1.LocalReport, Server.MapPath("RDLC\\" + Context.User.Identity.Name), ScriptId.ToString(), FlagForImagesDeletion, false);
                                objRDLC.Run(reportViewer1.LocalReport,
                                            Server.MapPath("RDLC\\" + Context.User.Identity.Name), FolderId,
                                            FlagForImagesDeletion, false);

                            //Added by Rohit. Ref ticket#84
                            renderedBytes = reportViewer1.LocalReport.Render(reportType, deviceInfo, out mimeType,
                                                                             out encoding, out fileNameExtension,
                                                                             out streams, out warnings);
                        }
                    }
                    catch (Exception ex)
                    {
                        LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error,
                                                this);
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
                    renderedBytes = reportViewer1.LocalReport.Render(reportType, deviceInfo, out mimeType, out encoding,
                                                                     out fileNameExtension, out streams, out warnings);
                    // Create PDF from rendered Bytes to send as an attachment
                    string strScriptRenderingPath = Server.MapPath("RDLC") + "\\" + Context.User.Identity.Name;
                    //  string strPath = "RDLC\\" + 
                    if (!Directory.Exists(strScriptRenderingPath))
                        Directory.CreateDirectory(strScriptRenderingPath);
                    Stream fs = new FileStream(strScriptRenderingPath + "\\MedicationScript.pdf", FileMode.Create);
                    fs.Write(renderedBytes, 0, renderedBytes.Length);
                    fs.Close();
                }
            }
            catch (Exception ex)
            {
                LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);
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

        /// <summary>
        ///     To insert rows into ClientMedicationScripts table and ClientMedicationScriptDrugs table
        /// </summary>
        /// <param name="SampleOrStock"></param>
        /// <param name="iMedicationRowsCount"></param>
        /// <param name="DataTableMedicationDetails"></param>
        /// <param name="NoOfRowsToBeCopied"></param>
        /// <param name="DrugCategory"></param>
        private void GenerateScriptsTableRows(char SampleOrStock, int iMedicationRowsCount,
                                              DataTable DataTableMedicationDetails, int NoOfRowsToBeCopied,
                                              string DrugCategory)
        {
            DataRow drClientMedicationScripts = null;
            //added By Pushpita Ref: task 85 SDI Projects FY10 - Venture 
            var dcDataTableSureScriptsRefillRequests = new DataColumn[1];

            DataRow dr = null;
            DataRow drClientMedicationScriptDrugs = null;
            DataTable DataTableMedicationInstructionDetails = null;
            DataRow[] dataRowsClientMedicationInstructions = null;
            DataRow[] drMedication = null;
            DataRow[] dataRowsClientMedicationScriptDrugs = null;
            //Added By Anuj on 25 feb,2010 For task ref 85
            DataRow[] dataRowsClientMedicationScriptDrugStrengths = null;
            //Ended over here
            string _strMedicationInstructionIds = "";
            //added by anuj on 12feb,2010 For task ref 85
            string _strMedicationIds = "";
            //ended over here
            try
            {
                var _dsTemp = new DataSet();
                //if (_UpdateTempTables == true)
                //    _dsTemp.Merge(DataSetClientMedications_Temp.Tables["ClientMedicationScriptDrugStrengths"]);
                //else
                _dsTemp.Merge(ObjectClientMedication.Tables["ClientMedicationScriptDrugStrengths"]);
                if ((OrderingMethod == 'E' || OrderingMethod == 'P') && DrugCategory != "C2")
                {
                    DataRow[] drScriptDrugStrengths = null;
                    string sSelection = "";
                    int ScriptDrugStrengthsCounter = 0;
                    foreach (DataRow drGeneralCategoryMedications in DataTableMedicationDetails.Rows)
                    {
                        sSelection = sSelection + (String.IsNullOrEmpty(sSelection) ? "" : ",") + drGeneralCategoryMedications["ClientMedicationId"].ToString();
                    }
                    if (!String.IsNullOrEmpty(sSelection))
                    {
                        drScriptDrugStrengths = _dsTemp.Tables["ClientMedicationScriptDrugStrengths"].Select("ClientMedicationId in (" + sSelection + ")");

                        for (short index = 0; index < drScriptDrugStrengths.Length; index++)
                        {
                            //if (_UpdateTempTables == true)
                            //    drClientMedicationScripts = DataSetClientMedications_Temp.Tables["ClientMedicationScripts"].NewRow();
                            //else
                            drClientMedicationScripts = ObjectClientMedication.Tables["ClientMedicationScripts"].NewRow();
                            drClientMedicationScripts["Clientid"] = ((StreamlinePrinciple)Context.User).Client.ClientId;
                            drClientMedicationScripts["OrderingMethod"] = OrderingMethod;
                            //Commented By Priya and Add For Electronic Radio Button date 8th Feb 2010 Ref: Task 85
                            // if (OrderingMethod == 'F')

                            //code added by Loveena in ref to Task#3224-2.3 Refill Approval Processing Issues
                            if (((HiddenField)Parent.FindControl("HiddenFieldRedirectFrom")).Value.ToUpper() == "DASHBOARD" &&
                                (_DrugsOrderMethod.ToUpper() == "REFILL" || _DrugsOrderMethod.ToUpper() == "NEW ORDER"))
                            {
                                var pharmacyid = (HiddenField)Page.FindControl("HiddenFieldRefillPharmacyId");
                                if (pharmacyid.Value != "")
                                    drClientMedicationScripts["PharmacyId"] = Convert.ToInt32(pharmacyid.Value);
                            }
                            else
                            {
                                if (HiddenFieldScriptsPharmacyId.Value != string.Empty)
                                {
                                    drClientMedicationScripts["PharmacyId"] =
                                        Convert.ToInt32(HiddenFieldScriptsPharmacyId.Value);
                                }
                                else if (((HiddenField)(Parent.FindControl("HiddenFieldPharmacyId"))).Value != "")
                                {
                                    drClientMedicationScripts["PharmacyId"] =
                                        Convert.ToInt32(((HiddenField)(Parent.FindControl("HiddenFieldPharmacyId"))).Value);
                                }
                            }


                            drClientMedicationScripts["PrintDrugInformation"] = PrintDrugInformation;
                            drClientMedicationScripts["VerbalOrderReadBack"] = VerbalOrderReadBack;
                            drClientMedicationScripts["StaffLicenseDegreeId"] = (HiddenFieldDEANumber.Value != "" && HiddenFieldDEANumber.Value != null)
                                                 ? HiddenFieldDEANumber.Value
                                                 : (DropDownListDEANumber.SelectedValue != "")
                                                       ? DropDownListDEANumber.SelectedValue
                                                       : "";
                            drClientMedicationScripts["ScriptCreationDate"] = DateTime.Now;
                            drClientMedicationScripts["OrderingPrescriberId"] =
                                DataTableMedicationDetails.Rows[0]["PrescriberId"];
                            drClientMedicationScripts["OrderingPrescriberName"] =
                                DataTableMedicationDetails.Rows[0]["PrescriberName"];
                            drClientMedicationScripts["OrderDate"] =
                                ObjectClientMedication.Tables["ClientMedicationScripts"].Rows[0]["OrderDate"];
                            if (HiddenFieldLocationId.Value != string.Empty)
                                drClientMedicationScripts["LocationId"] = Convert.ToInt32(HiddenFieldLocationId.Value);
                            else
                                drClientMedicationScripts["LocationId"] = DBNull.Value;

                            if (_DrugsOrderMethod == "Change" || _DrugsOrderMethod == "CHANGE")
                                drClientMedicationScripts["ScriptEventType"] = "C";
                            else if (_DrugsOrderMethod == "Refill" || _DrugsOrderMethod == "REFILL") // Change here to NEW when New Med Added.
                                drClientMedicationScripts["ScriptEventType"] = "R";
                            else if (_DrugsOrderMethod.ToUpper() == "APPROVEWITHCHANGESCHANGEORDER")
                            {
                                drClientMedicationScripts["ScriptEventType"] = "C"; // Added By PranayB
                            }
                            else if (_DrugsOrderMethod.ToUpper() == "CHANGEAPPROVALORDER")
                            {
                                drClientMedicationScripts["ScriptEventType"] = "A"; //Added By PranayB
                            }
                            else
                                drClientMedicationScripts["ScriptEventType"] = "N";

                            if (((HiddenField)Parent.FindControl("HiddenFieldRedirectFrom")).Value.ToUpper() == "DASHBOARD" &&
                                (_DrugsOrderMethod.ToUpper() == "NEW ORDER" || _DrugsOrderMethod.ToUpper() == "REFILL"))
                            {
                                var hiddenFieldSureScriptRefillId =
                                    (HiddenField)Page.FindControl("HiddenFieldSureScriptRefillRequestId");
                                if (hiddenFieldSureScriptRefillId.Value != "")
                                    drClientMedicationScripts["SureScriptsRefillRequestId"] =
                                        Convert.ToInt32(hiddenFieldSureScriptRefillId.Value);
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

                            if (_Queue)
                            {
                                drClientMedicationScripts["WaitingPrescriberApproval"] = "Y";
                            }
                            else
                            {
                                drClientMedicationScripts["WaitingPrescriberApproval"] = DBNull.Value;
                            }
                            //Anuj ended over here
                            //Ended over here
                            drClientMedicationScripts["RowIdentifier"] = Guid.NewGuid();
                            drClientMedicationScripts["CreatedBy"] = ((StreamlineIdentity)Context.User.Identity).UserCode;
                            drClientMedicationScripts["CreatedDate"] = DateTime.Now;
                            drClientMedicationScripts["ModifiedBy"] = ((StreamlineIdentity)Context.User.Identity).UserCode;
                            drClientMedicationScripts["ModifiedDate"] = DateTime.Now;

                            //Added By chandan on 3rd Dec 2008 Task #85 MM 1.7 - Prescribe Window Changes
                            //DataSetClientMedications.Tables["ClientMedicationScripts"].Rows.Add(drClientMedicationScripts);

                            ObjectClientMedication.Tables["ClientMedicationScripts"].Rows.Add(drClientMedicationScripts);
                            //ObjectClientMedication.Tables["ClientMedicationScriptDrugStrengths"].Rows[index]["ClientMedicationScriptId"] = drClientMedicationScripts["ClientMedicationScriptId"];
                            //ObjectClientMedication.Tables["ClientMedicationScriptDrugs"].Rows[index]["ClientMedicationScriptId"] = drClientMedicationScripts["ClientMedicationScriptId"];

                            int strengthId = 0;
                            strengthId = Convert.ToInt32(drScriptDrugStrengths[index]["StrengthId"]);

                            foreach (DataRow drMedDrugStrength in (ObjectClientMedication.Tables["ClientMedicationScriptDrugStrengths"].Select("StrengthId = " + strengthId)))
                            {
                                drMedDrugStrength["ClientMedicationScriptId"] = drClientMedicationScripts["ClientMedicationScriptId"];
                            }

                            //Update the ScriptId into ClientMedicationScriptDispenseDays
                            foreach (DataRow drMedStrength in (ObjectClientMedication.Tables["ClientMedicationInstructions"].Select("StrengthId = " + strengthId)))
                            {
                                for (int iDrug = 0; iDrug < ObjectClientMedication.Tables["ClientMedicationScriptDrugs"].Rows.Count; iDrug++)
                                {
                                    if (Convert.ToInt64(ObjectClientMedication.Tables["ClientMedicationScriptDrugs"].Rows[iDrug]["ClientMedicationInstructionId"]) ==
                                        Convert.ToInt64(drMedStrength["ClientMedicationInstructionId"]) && Convert.ToString(ObjectClientMedication.Tables["ClientMedicationScriptDrugs"].Rows[iDrug]["ClientMedicationScriptId"]) == "0")
                                    {
                                        ObjectClientMedication.Tables["ClientMedicationScriptDrugs"].Rows[iDrug]["ClientMedicationScriptId"] = drClientMedicationScripts["ClientMedicationScriptId"];
                                    }
                                }
                            }
                        }
                    }
                }
                else
                {
                    //if (_UpdateTempTables == true)
                    //    drClientMedicationScripts = DataSetClientMedications_Temp.Tables["ClientMedicationScripts"].NewRow();
                    //else
                    drClientMedicationScripts = ObjectClientMedication.Tables["ClientMedicationScripts"].NewRow();
                    drClientMedicationScripts["Clientid"] = ((StreamlinePrinciple)Context.User).Client.ClientId;
                    drClientMedicationScripts["OrderingMethod"] = OrderingMethod;
                    //Commented By Priya and Add For Electronic Radio Button date 8th Feb 2010 Ref: Task 85
                    // if (OrderingMethod == 'F')
                    
                    //Code added by Loveena in ref to Task#3224-2.3 Refill Approval Processing Issues
                        if (((HiddenField)Parent.FindControl("HiddenFieldRedirectFrom")).Value.ToUpper() == "DASHBOARD" &&
                            (_DrugsOrderMethod.ToUpper() == "REFILL" || _DrugsOrderMethod.ToUpper() == "NEW ORDER"))
                        {
                            var pharmacyid = (HiddenField)Page.FindControl("HiddenFieldRefillPharmacyId");
                            if (pharmacyid.Value != "")
                                drClientMedicationScripts["PharmacyId"] = Convert.ToInt32(pharmacyid.Value);
                        }
                        else
                        {
                            if (HiddenFieldScriptsPharmacyId.Value != string.Empty)
                            {
                                drClientMedicationScripts["PharmacyId"] =
                                    Convert.ToInt32(HiddenFieldScriptsPharmacyId.Value);
                            }
                            else if (((HiddenField)(Parent.FindControl("HiddenFieldPharmacyId"))).Value != "")
                            {
                                drClientMedicationScripts["PharmacyId"] =
                                    Convert.ToInt32(((HiddenField)(Parent.FindControl("HiddenFieldPharmacyId"))).Value);
                            }
                        }
                    
                    drClientMedicationScripts["PrintDrugInformation"] = PrintDrugInformation;
                    drClientMedicationScripts["VerbalOrderReadBack"] = VerbalOrderReadBack;
                    drClientMedicationScripts["StaffLicenseDegreeId"] = (HiddenFieldDEANumber.Value != "" && HiddenFieldDEANumber.Value != null)
                                             ? HiddenFieldDEANumber.Value
                                             : (DropDownListDEANumber.SelectedValue != "")
                                                   ? DropDownListDEANumber.SelectedValue
                                                   : "";
                    drClientMedicationScripts["ScriptCreationDate"] = DateTime.Now;
                    drClientMedicationScripts["OrderingPrescriberId"] =
                        DataTableMedicationDetails.Rows[0]["PrescriberId"];
                    drClientMedicationScripts["OrderingPrescriberName"] =
                        DataTableMedicationDetails.Rows[0]["PrescriberName"];

                    
                    drClientMedicationScripts["OrderDate"] =
                        ObjectClientMedication.Tables["ClientMedicationScripts"].Rows[0]["OrderDate"];
                   
                    if (HiddenFieldLocationId.Value != string.Empty)
                        drClientMedicationScripts["LocationId"] = Convert.ToInt32(HiddenFieldLocationId.Value);
                    else
                        drClientMedicationScripts["LocationId"] = DBNull.Value;
                    if (_DrugsOrderMethod == "Change" || _DrugsOrderMethod == "CHANGE")
                        drClientMedicationScripts["ScriptEventType"] = "C";
                    else if (_DrugsOrderMethod == "Refill" || _DrugsOrderMethod == "REFILL") // Change to new when new med addded
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

                    //added by priyas Ref: task 85 SDI Projects FY10 - Venture 
                    // if (_DrugsOrderMethod == "New Order" || _DrugsOrderMethod == "Refill")
                    if (((HiddenField)Parent.FindControl("HiddenFieldRedirectFrom")).Value.ToUpper() == "DASHBOARD" &&
                        (_DrugsOrderMethod.ToUpper() == "NEW ORDER" || _DrugsOrderMethod.ToUpper() == "REFILL"))
                    {
                        var hiddenFieldSureScriptRefillId =
                            (HiddenField)Page.FindControl("HiddenFieldSureScriptRefillRequestId");
                        if (hiddenFieldSureScriptRefillId.Value != "")
                            drClientMedicationScripts["SureScriptsRefillRequestId"] =
                                Convert.ToInt32(hiddenFieldSureScriptRefillId.Value);
                    }
                    if (_DrugsOrderMethod.ToUpper() == "APPROVEWITHCHANGESCHANGEORDER" || _DrugsOrderMethod.ToUpper() == "CHANGEAPPROVALORDER")
                    {
                        HiddenField hiddenFieldSureScriptChangeId = (HiddenField)Page.FindControl("HiddenFieldSureScriptChangeRequestId");
                        if (hiddenFieldSureScriptChangeId.Value != "")
                            drClientMedicationScripts["SureScriptsChangeRequestId"] = Convert.ToInt32(hiddenFieldSureScriptChangeId.Value);
                    }
                    //Added by Anuj on 19 nov,2009 for task ref #3 SDI Projects FY10 - Venture 
                    //Checking queue order button is clicked
                    //Modified by anuj on 1March,2010 for task ref#2859
                    int prescriberid = 0;
                    if (Convert.ToString(DataTableMedicationDetails.Rows[0]["PrescriberId"]) != null &&
                        Convert.ToString(DataTableMedicationDetails.Rows[0]["PrescriberId"]) != "")
                    {
                        prescriberid = Convert.ToInt32(DataTableMedicationDetails.Rows[0]["PrescriberId"].ToString());
                    }

                    if (_Queue)
                    {
                        drClientMedicationScripts["WaitingPrescriberApproval"] = "Y";
                    }
                    else
                    {
                        drClientMedicationScripts["WaitingPrescriberApproval"] = DBNull.Value;
                    }
                    //Anuj ended over here
                    //Ended over here
                    drClientMedicationScripts["RowIdentifier"] = Guid.NewGuid();
                    drClientMedicationScripts["CreatedBy"] = ((StreamlineIdentity)Context.User.Identity).UserCode;
                    drClientMedicationScripts["CreatedDate"] = DateTime.Now;
                    drClientMedicationScripts["ModifiedBy"] = ((StreamlineIdentity)Context.User.Identity).UserCode;
                    drClientMedicationScripts["ModifiedDate"] = DateTime.Now;

                    
                    ObjectClientMedication.Tables["ClientMedicationScripts"].Rows.Add(drClientMedicationScripts);
                }
                //Added End By chandan on 3rd Dec 2008 Task #85 MM 1.7 - Prescribe Window Changes
                //Ref to Task#33
                scriptId = Convert.ToInt32(drClientMedicationScripts["ClientMedicationScriptId"]);
                //Code ends over here.
                //Added by Chandan for Task#2578 
                int iloopCounter = 1;
                int Maxnumberofmedsforscriptid = 3;
                DataSet DatasetSystemConfigurationKeys = null;
                Streamline.DataService.SharedTables objSharedTables = new Streamline.DataService.SharedTables();
                DatasetSystemConfigurationKeys = objSharedTables.GetSystemConfigurationKeys();
                if (objSharedTables.GetSystemConfigurationKeys("PRINTFOURPRESCRIPTIONSPERPAGE", DatasetSystemConfigurationKeys.Tables[0]).ToUpper() == "YES")
                {
                    Maxnumberofmedsforscriptid = 4;
                }

                if (DrugCategory == "C2" || DrugCategory == "C3" || DrugCategory == "C4" || DrugCategory == "C5" ||
                    DrugCategory == "CT")
                    iloopCounter = ((NoOfRowsToBeCopied + 1) > iMedicationRowsCount)
                                       ? iMedicationRowsCount
                                       : (NoOfRowsToBeCopied + 1);
                else
                    iloopCounter = ((NoOfRowsToBeCopied + Maxnumberofmedsforscriptid) > iMedicationRowsCount)
                                       ? iMedicationRowsCount
                                       : (NoOfRowsToBeCopied + Maxnumberofmedsforscriptid);
                //Added end by Chandan for Task#2578 

                for (int i = NoOfRowsToBeCopied; i < iloopCounter; i++)
                {
                    _strMedicationInstructionIds = "";
                    dr = null;
                    dr = DataTableMedicationDetails.Rows[i];


                    DataRow[] drInstructions =
                        _DataTableClientMedicationInstructions.Select("ClientMedicationId=" + dr["ClientMedicationId"]);

                    foreach (DataRow dr1 in drInstructions)
                    {
                        if (_strMedicationInstructionIds == "")
                        {
                            _strMedicationInstructionIds += dr1["ClientMedicationInstructionId"].ToString();
                        }
                        else
                        {
                            _strMedicationInstructionIds += "," + dr1["ClientMedicationInstructionId"];
                        }
                    }

                    if (_strMedicationInstructionIds != "")
                    {
                        
                        dataRowsClientMedicationScriptDrugs =
                            ObjectClientMedication.Tables["ClientMedicationScriptDrugs"].Select(
                                "ClientMedicationInstructionId in(" + _strMedicationInstructionIds + ")");
                        //Added end By chandan on 3rd Dec 2008 Task #85 MM 1.7 - Prescribe Window Changes
                    }
                    //added by anuj on 15feb,2010 For task ref 85
                    DataRow[] drScriptDrugStrengths =
                        _DataTableClientMedicationScriptDrugStrengths.Select("ClientMedicationId=" +
                                                                             dr["ClientMedicationId"]);
                    foreach (DataRow dr1 in drScriptDrugStrengths)
                    {
                        if (_strMedicationIds == "")
                        {
                            _strMedicationIds += dr1["ClientMedicationId"].ToString();
                        }
                        else
                        {
                            _strMedicationIds += "," + dr1["ClientMedicationId"];
                        }
                    }
                    if (_strMedicationIds != "")
                    {
                        //if (_UpdateTempTables == true)
                        //    dataRowsClientMedicationScriptDrugStrengths = DataSetClientMedications_Temp.Tables["ClientMedicationScriptDrugStrengths"].Select("ClientMedicationId in(" + _strMedicationIds + ")");
                        //else
                        dataRowsClientMedicationScriptDrugStrengths =
                            ObjectClientMedication.Tables["ClientMedicationScriptDrugStrengths"].Select(
                                "ClientMedicationId in(" + _strMedicationIds + ")");
                    }

                    //Update the ScriptId into ClientMedicationScriptDrugStrengths
                    if (dataRowsClientMedicationScriptDrugStrengths != null)
                    {
                        foreach (DataRow drMedicationScriptDrugStrengths in dataRowsClientMedicationScriptDrugStrengths)
                        {
                            //Changes as per New Data Model
                            if (OrderingMethod != 'E' && OrderingMethod != 'P')
                                drMedicationScriptDrugStrengths["ClientMedicationScriptId"] =
                                    drClientMedicationScripts["ClientMedicationScriptId"];
                        }
                    }
                    //Update the ScriptId into ClientMedicationScriptDrugs

                    int strengthId = 0;
                    foreach (DataRow drMedicationScriptDrugs in dataRowsClientMedicationScriptDrugs)
                    {
                        //Changes as per New Data Model
                        drMedicationScriptDrugs["ClientMedicationScriptId"] =
                            drClientMedicationScripts["ClientMedicationScriptId"];

                        //Following code added by Sonia
                        //Ref Task #67 1.6.1 - Special Instructions Changes
                        //Special Instructions needs to be updated in the new ClientMedicationScriptDrugs with the latest value of special Instructions in ClientMedications Table
                        drMedicationScriptDrugs["SpecialInstructions"] = dr["SpecialInstructions"];
                        //Code changed end over here
                    }


                    if (_DrugsOrderMethod == "Refill" || _DrugsOrderMethod == "REFILL")
                    {
                     
                        using (
                            var DataViewClientMedicationScriptDrugs =
                                new DataView(ObjectClientMedication.Tables["ClientMedicationScriptDrugs"],
                                             "ClientMedicationInstructionId in(" + _strMedicationInstructionIds + ")",
                                             "EndDate Desc", DataViewRowState.CurrentRows))
                        {
                            DataRow DataRowClientMedication =
                                ObjectClientMedication.Tables["ClientMedications"].Rows.Find(dr["ClientMedicationId"]);
                            DataRowClientMedication["MedicationEndDate"] =
                                DataViewClientMedicationScriptDrugs[0]["EndDate"];
                            //  DataSetClientMedications.Tables["ClientMedicationInstructions"].Rows[0]["ClientMedicationId"] = DataSetClientMedications.Tables["ClientMedicationInstructions"].Rows[0]["ClientMedicationId"];
                        }
                        //}
                        ////Added end By chandan on 3rd Dec 2008 Task #85 MM 1.7 - Prescribe Window Changes
                    }
                }
                /*Incase of c2 medication Clientmedicationscriptid is getting genrate for clientmedicationscriptdrugstrength
                    added by anuj on 15 feb,2010 For task ref 85
                   DataTableMedicationDetails*/
                for (int i = 0; i < DataTableMedicationDetails.Rows.Count; i++)
                {
                    if (_strMedicationIds == "")
                    {
                        _strMedicationIds += DataTableMedicationDetails.Rows[i]["ClientMedicationId"].ToString();
                    }
                    else
                    {
                        _strMedicationIds += "," + DataTableMedicationDetails.Rows[i]["ClientMedicationId"];
                    }
                }
              
                if (_strMedicationIds != "")
                {
                  
                    dataRowsClientMedicationScriptDrugStrengths =
                        ObjectClientMedication.Tables["ClientMedicationScriptDrugStrengths"].Select(
                            "ClientMedicationId in(" + _strMedicationIds + ")");
                   
                }
                
                if (dataRowsClientMedicationScriptDrugStrengths != null)
                {
                    foreach (DataRow drMedicationScriptDrugStrengths in dataRowsClientMedicationScriptDrugStrengths)
                    {
                        if (DataTableMedicationDetails.Rows.Count > 0 &&
                            DataTableMedicationDetails.Select("ClientMedicationId = '" + drMedicationScriptDrugStrengths["ClientMedicationId"] + "'").Length > 0 
                                                              && Convert.ToString(DataTableMedicationDetails.Select("ClientMedicationId = '" + drMedicationScriptDrugStrengths["ClientMedicationId"] + "'")[0]["SpecialInstructions"]) != "")
                        {
                                    drMedicationScriptDrugStrengths["SpecialInstructions"] = Convert.ToString(DataTableMedicationDetails.Select("ClientMedicationId = '" + drMedicationScriptDrugStrengths["ClientMedicationId"] + "'")[0]["SpecialInstructions"]);
                        }
                        else
                            drMedicationScriptDrugStrengths["SpecialInstructions"] = DBNull.Value;

                    }
                }

                //ended over here                               
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Event Name -GenerateScriptsTableRows()";
                else
                    ex.Data["CustomExceptionInformation"] = "";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);

                string strErrorMessage = "Error occured while Creating Scripts";
                ScriptManager.RegisterStartupScript(Label1, Label1.GetType(), ClientID,
                                                    "ClientMedicationOrder.ShowError('" + strErrorMessage + "', true);",
                                                    true);
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

        //Added by Loveena in ref to Task#23
        private void PrintFormHandler(object sender, PrintPageEventArgs args)
        {
            var myFont = new Font("Microsoft San Serif", 10);
            args.Graphics.DrawImage(imageToConvert, 0, 0, imageToConvert.Width, imageToConvert.Height);
            // new Font(myFont, FontStyle.Regular), Brushes.Black, 50, 50);

            // e.Graphics.DrawImage(imagetoprint, 0, 0, imagetoprint.Width, imagetoprint.Height); //use your own images's width & 
        }

        //Code ends over here.

        /// <summary>
        ///     Author Vikas Vyas
        ///     Purpose To render the Sub report of RDLC
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        public void SetSubDataSource(object sender, SubreportProcessingEventArgs e)
        {
            try
            {
                var rptTemp = (LocalReport)sender;
                //Condition added by Loveena in ref to Task#2596
                if (rptTemp.DataSources[e.ReportPath.Trim()] != null)
                {
                    var dtTemp = (DataTable)rptTemp.DataSources[e.ReportPath.Trim()].Value;
                    e.DataSources.Add(new ReportDataSource(e.DataSourceNames[0], dtTemp));
                }
            }
            catch (Exception ex)
            {
                LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);
            }
        }

        // <summary>
        /// Added by sonia to Print Prescription in case Fax Failed
        /// task #99 MM1.6.5
        /// </summary>
        /// <param name="ScriptId">ScriptId</param>
        public void PrintPrescription(int ScriptId, string strSendCoverLetter)
        {
            try
            {
                //RDLC to be rendered for Chart Copy of Faxed Document
                //Added by chandan on 21st Nov 2008 for creating report  
                try
                {
                    GetRDLCContents(ScriptId, false, true, "P", strSendCoverLetter);
                    //Added by Loveena in ref to Task#2660
                    FolderId = ScriptId.ToString() + "_" + DateTime.Now.ToString("MMddyyyymmhhss");
                    using (var objRDLC = new RDLCPrint())
                    {
                        //Modified in ref to Task#2660
                        //objRDLC.Run(this.reportViewer1.LocalReport, Server.MapPath("RDLC\\" + Context.User.Identity.Name), ScriptId.ToString(), false, false);
                        objRDLC.Run(reportViewer1.LocalReport, Server.MapPath("RDLC\\" + Context.User.Identity.Name),
                                    FolderId, false, false);
                    }
                }
                catch (Exception ex)
                {
                    LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);
                }
                finally
                {
                }
                _strFaxFailed = true;
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
                LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);
            }
        }

        //Added by anuj on 25 feb,2010 fro taskj ref 85
        public bool SendByElectronically(int ScriptId, int PharmacyId, bool FlagForImagesDeletion, string SendCoveLetter)
        {
            try
            {
                if (_UpdateTempTables)
                    GetRDLCContents(ScriptId, false, FlagForImagesDeletion, "E", SendCoveLetter);
                if (_strScriptIds == "")
                {
                    _strScriptIds += ScriptId;
                }
                else
                {
                    _strScriptIds += "^" + ScriptId;
                }
                DataRow drClientMedicationScriptsActivity =
                    DataSetClientScriptActivities.Tables["ClientMedicationScriptActivities"].NewRow();
                drClientMedicationScriptsActivity["ClientMedicationScriptId"] = ScriptId;
                drClientMedicationScriptsActivity["Method"] = 'E';
                drClientMedicationScriptsActivity["PharmacyId"] = PharmacyId;
                drClientMedicationScriptsActivity["Reason"] = DBNull.Value;
                drClientMedicationScriptsActivity["FaxStatusDate"] = DateTime.Now;
                drClientMedicationScriptsActivity["Status"] = 5561;
                drClientMedicationScriptsActivity["StatusDescription"] = DBNull.Value;
                drClientMedicationScriptsActivity["FaxExternalIdentifier"] = DBNull.Value;
                if (CheckBoxPrintChartCopy.Checked)
                {
                    drClientMedicationScriptsActivity["IncludeChartCopy"] = "Y";
                }
                else
                {
                    drClientMedicationScriptsActivity["IncludeChartCopy"] = "N";
                }
                drClientMedicationScriptsActivity["RowIdentifier"] = Guid.NewGuid();
                drClientMedicationScriptsActivity["CreatedBy"] = ((StreamlineIdentity)Context.User.Identity).UserCode;
                drClientMedicationScriptsActivity["CreatedDate"] = DateTime.Now;
                drClientMedicationScriptsActivity["ModifiedBy"] = ((StreamlineIdentity)Context.User.Identity).UserCode;
                drClientMedicationScriptsActivity["ModifiedDate"] = DateTime.Now;
                DataSetClientScriptActivities.Tables["ClientMedicationScriptActivities"].Rows.Add(
                    drClientMedicationScriptsActivity);
                using (
                    var _clientMedication = new ClientMedication())
                {
                    _clientMedication.SetRenderedImageData(DataSetClientScriptActivities,
                                                           drClientMedicationScriptsActivity,
                                                           ((StreamlineIdentity)
                                                            Context.User.Identity).UserCode, renderedBytes);
                }
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
        ///     Added by sonia to Print Chart Copy in case of Fax
        /// </summary>
        /// <param name="ScriptId"></param>
        public void PrintChartCopy(int ScriptId, string strSendCoverLetter)
        {
            try
            {
                GetRDLCContents(ScriptId, false, false, "P", strSendCoverLetter);
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
                LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);
            }
        }

        public bool SendToFax(int ScriptId, int PharmacyId, bool FlagForImagesDeletion, string SendCoveLetter)
        {
            #region Sending Fax

            string FaxUniqueId = "";
            try
            {
                GetRDLCContents(ScriptId, true, FlagForImagesDeletion, "F", SendCoveLetter);
                //Send Fax Contents to Fax server
                try
                {
                    var _streamlineFax = new StreamlineFax();
                    //FaxUniqueId = _streamlineFax.SendFax(PharmacyId, ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId, (Server.MapPath("RDLC") + "\\" + Context.User.Identity.Name + "\\MedicationScript.pdf"), "Prescription Medication Script") ? "True" : "";
                    FaxUniqueId = _streamlineFax.SendFax(PharmacyId,
                                                         ((StreamlinePrinciple)Context.User).Client.ClientId,
                                                         (Server.MapPath("RDLC") + "\\" + Context.User.Identity.Name +
                                                          "\\MedicationScript.pdf"), "Prescription Medication Script");
                }
                catch (COMException ex)
                {
                    if (ex.Data["CustomExceptionInformation"] == null)
                        ex.Data["CustomExceptionInformation"] = "Source function SendToFax() of Prescribe Screen";
                    else
                        ex.Data["CustomExceptionInformation"] = "";
                    if (ex.Data["DatasetInfo"] == null)
                        ex.Data["DatasetInfo"] = null;
                    LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);
                }

                #region InsertRowsIntoClientScriptActivities

                ////Insert Rows into ClientScriptActivities
                DataRow drClientMedicationScriptsActivity =
                    DataSetClientScriptActivities.Tables["ClientMedicationScriptActivities"].NewRow();
                drClientMedicationScriptsActivity["ClientMedicationScriptId"] = ScriptId;
                //Added by Chandan with ref Task#99 - 1.7.3 - Faxing Check for Service Status
                if (FaxUniqueId != "" && FaxUniqueId.ToLower() != "false")
                {
                    drClientMedicationScriptsActivity["Method"] = 'F';
                    drClientMedicationScriptsActivity["PharmacyId"] = PharmacyId;
                }
                else
                {
                    drClientMedicationScriptsActivity["Method"] = 'P';
                    drClientMedicationScriptsActivity["PharmacyId"] = DBNull.Value;
                }

                //drClientMedicationScriptsActivity["PharmacyId"] = PharmacyId;
                drClientMedicationScriptsActivity["Reason"] = DBNull.Value;
                drClientMedicationScriptsActivity["FaxStatusDate"] = DateTime.Now;
                //drClientMedicationScriptsActivity["FaxStatus"] = "QUEUED";
                //Added by anuj on 24 feb, for task ref 85
                drClientMedicationScriptsActivity["Status"] = 5561;
                drClientMedicationScriptsActivity["StatusDescription"] = DBNull.Value;
                //Ended over here
                if (FaxUniqueId != "" && FaxUniqueId.ToLower() != "false")
                    drClientMedicationScriptsActivity["FaxExternalIdentifier"] = FaxUniqueId;
                else
                    drClientMedicationScriptsActivity["FaxExternalIdentifier"] = DBNull.Value;
                //Commented Currently
                //Added By chandan for task #85 
                if (CheckBoxPrintChartCopy.Checked)
                    drClientMedicationScriptsActivity["IncludeChartCopy"] = "Y";
                else
                    drClientMedicationScriptsActivity["IncludeChartCopy"] = "N";

                drClientMedicationScriptsActivity["RowIdentifier"] = Guid.NewGuid();
                drClientMedicationScriptsActivity["CreatedBy"] = ((StreamlineIdentity)Context.User.Identity).UserCode;
                drClientMedicationScriptsActivity["CreatedDate"] = DateTime.Now;
                drClientMedicationScriptsActivity["ModifiedBy"] = ((StreamlineIdentity)Context.User.Identity).UserCode;
                drClientMedicationScriptsActivity["ModifiedDate"] = DateTime.Now;
                DataSetClientScriptActivities.Tables["ClientMedicationScriptActivities"].Rows.Add(
                    drClientMedicationScriptsActivity);
                using (
                    var _clientMedication = new ClientMedication())
                {
                    _clientMedication.SetRenderedImageData(DataSetClientScriptActivities,
                                                           drClientMedicationScriptsActivity,
                                                           ((StreamlineIdentity)
                                                            Context.User.Identity).UserCode, renderedBytes);
                }

                //Added by anuj on 25 feb,2010 fro task ref 85
                DataRow drClientMedicationScriptsActivityPending =
                    DataSetClientScriptActivities.Tables["ClientMedicationScriptActivitiesPending"].NewRow();
                drClientMedicationScriptsActivityPending["ClientMedicationScriptActivityId"] =
                    drClientMedicationScriptsActivity["ClientMedicationScriptActivityId"].ToString();
                drClientMedicationScriptsActivityPending["RowIdentifier"] = Guid.NewGuid();
                drClientMedicationScriptsActivityPending["CreatedBy"] =
                    ((StreamlineIdentity)Context.User.Identity).UserCode;
                drClientMedicationScriptsActivityPending["CreatedDate"] = DateTime.Now;
                drClientMedicationScriptsActivityPending["ModifiedBy"] =
                    ((StreamlineIdentity)Context.User.Identity).UserCode;
                drClientMedicationScriptsActivityPending["ModifiedDate"] = DateTime.Now;
                DataSetClientScriptActivities.Tables["ClientMedicationScriptActivitiesPending"].Rows.Add(
                    drClientMedicationScriptsActivityPending);
                //Ended over here

                #endregion

                //if (DataSetTemp.Tables["ClientMedicationScriptActivities"].Rows.Count > 0)
                if (FaxUniqueId != "" && FaxUniqueId.ToLower() != "false")
                    return true;
                else
                    return false;
                //else
                //{
                //    return false;
                //}
            }


            catch (Exception ex)
            {
                throw (ex);
            }

            #endregion
        }

        protected bool setQueuedButton()
        {
            try
            {
                if (Session["DataSetClientMedications"] != null)
                {
                    DataSetClientMedications_Temp1 = new DataSetClientMedications();
                    DataSetClientMedications_Temp1 = (DataSetClientMedications)Session["DataSetClientMedications"];
                    DataSetClientMedications_Temp = (DataSetClientMedications)DataSetClientMedications_Temp1.Copy();
                    DataTable _DataTableClientMedications = DataSetClientMedications_Temp.Tables["ClientMedications"];
                    DataTable _DataTableClientMedicationInstructions =
                        DataSetClientMedications_Temp.Tables["ClientMedicationInstructions"];

                    #region--Code Added by Pradeep as per task#3

                    int prescriberId = 0;
                    if (DataSetClientMedications_Temp1.Tables["ClientMedications"].Rows.Count > 0)
                    {
                        prescriberId =
                            DataSetClientMedications_Temp1.Tables["ClientMedications"].Rows[0]["PrescriberId"] ==
                            DBNull.Value
                                ? 0
                                : Convert.ToInt32(
                                    DataSetClientMedications_Temp1.Tables["ClientMedications"].Rows[0]["PrescriberId"]
                                        .ToString());
                        int loggedInUserId = ((StreamlineIdentity)Context.User.Identity).UserId;
                        if (((StreamlinePrinciple)Context.User).HasPermission(Permissions.QueueOrder))
                        {
                            if (prescriberId == loggedInUserId)
                            {
                                return true;
                                //ButtonQueueOrder.Enabled = false;
                            }
                            else
                            {
                                return false;
                                //ButtonQueueOrder.Enabled = true;
                            }
                        }
                    }

                    #endregion
                }

                return false;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        ///     Added by Anuj on 19 nov,2009 for task ref #3 SDI Projects FY10 - Venture
        ///     Checking queue order button is clicked
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void ButtonQueueOrder_Click(object sender, EventArgs e)
        {
            //HiddenFieldQueueOrder.Value = "Queue";
            ClientMedication objectClientMedications = null;
            objectClientMedications = new ClientMedication();

            try
            {
                CommonFunctions.Event_Trap(this);
                //Vithobha commented below code to allow queuing for the logged in staff. Camino - Environment Issues Tracking: #308 
                //if (setQueuedButton())
                //{
                //    ScriptManager.RegisterStartupScript(LabelChartCopyPrinter, LabelChartCopyPrinter.GetType(), ClientID,
                //                                        "ClientMedicationOrder.ShowError('Cannot queue order for yourself. You may only queue for other prescribers.', true);",
                //                                        true);
                //    return;
                //}
                //else
                //{
                //Pranay
                //string UserID = (((StreamlineIdentity)Context.User.Identity)).UserId.ToString();
                //string IsPrescriber = (((StreamlineIdentity)Context.User.Identity)).Prescriber.ToString();
                //DataSetClientMedications DataSetClientMedications;
                //DataSetClientMedications = new DataSetClientMedications();
                //DataSetClientMedications = (DataSetClientMedications)Session["DataSetClientMedications"];
                //DataTable _DataTableClientMedications = DataSetClientMedications.Tables["ClientMedications"];

                //Checks if the Logged-in user is a prescriber and then allow to prescribe control drugs. 
              
                 Session["OriginalDataUpdated"] = 1;
                                _Queue = true;
                                objectClientMedications.DeleteTempTables(Session.SessionID);
                                //Added  by Chandan on 4th March 2009 for task#85
                                bool _DocumentUpdatedOrNot = DocumentUpdateDocument();
                                if (_DocumentUpdatedOrNot)
                                {
                                    if (DocumentUpdateQueueDocument())
                                        ButtonClose.Enabled = false;
                                    else
                                    {
                                        ScriptManager.RegisterStartupScript(ButtonPrescribe, ButtonPrescribe.GetType(), ClientID,
                                                                            "ClientMedicationOrder.ShowValidationDialogue('" +
                                                                            ValidationMessage + "');", true);
                                    }
                                }
                              
                            }
                
              //  if (IsPrescriber == "Y")
              //  {
              //      if (DropDownListPrescriber.SelectedValue != UserID)
              //      {
              //          DataRow[] foundControlDrug = _DataTableClientMedications.Select("DrugCategory >= 2");
              //          if (foundControlDrug.Length > 0)
              //              {
              //                  ScriptManager.RegisterStartupScript(ButtonPrescribe,
              //                                                     ButtonPrescribe.GetType(),
              //                                                     ClientID,
              //                                                      "ClientMedicationOrder.ShowError('You are not authorized to prescribe or queue this medication for this prescriber', true);",
              //                                                                      true);
              //                  return;    
              //             }
              //              else
              //              {
              //                  Session["OriginalDataUpdated"] = 1;
              //                  _Queue = true;
              //                  objectClientMedications.DeleteTempTables(Session.SessionID);
              //                  //Added  by Chandan on 4th March 2009 for task#85
              //                  bool _DocumentUpdatedOrNot = DocumentUpdateDocument();
              //                  if (_DocumentUpdatedOrNot)
              //                  {
              //                      if (DocumentUpdateQueueDocument())
              //                          ButtonClose.Enabled = false;
              //                  }
              //              }
              //          }
              //      else
              //      {
              //          Session["OriginalDataUpdated"] = 1;
              //          _Queue = true;
              //          objectClientMedications.DeleteTempTables(Session.SessionID);
              //          //Added  by Chandan on 4th March 2009 for task#85
              //          bool _DocumentUpdatedOrNot = DocumentUpdateDocument();
              //          if (_DocumentUpdatedOrNot)
              //          {
              //              if (DocumentUpdateQueueDocument())
              //                  ButtonClose.Enabled = false;
              //          }
              //      }
              //  }

              //  else
              //  {
              //      Session["OriginalDataUpdated"] = 1;
              //      _Queue = true;
              //      objectClientMedications.DeleteTempTables(Session.SessionID);
              //      //Added  by Chandan on 4th March 2009 for task#85
              //      bool _DocumentUpdatedOrNot = DocumentUpdateDocument();
              //      if (_DocumentUpdatedOrNot)
              //      {
              //          if (DocumentUpdateQueueDocument())
              //              ButtonClose.Enabled = false;
              //      }
              //  }
              //}
            //}
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] =
                        "###Source Event Name -ButtonNewOrder_Click(), ParameterCount -2, First Parameter- " + sender +
                        ", Second Parameter- " + e + "###";
                else
                    ex.Data["CustomExceptionInformation"] = "";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);

                string strErrorMessage = "Error occured while Updating Database";
                ScriptManager.RegisterStartupScript(LabelChartCopyPrinter, LabelChartCopyPrinter.GetType(), ClientID,
                                                    "ClientMedicationOrder.ShowError('" + strErrorMessage + "', true);",
                                                    true);
                HiddenFieldShowError.Value = "Error occured while Updating Database";
            }
            finally
            {
                //reportViewer1 = null;
                objectClientMedications = null;
            }
        }

        /// <summary>
        ///     Author Sonia
        ///     Purpose To Update the records of Client Medications,Scripts rendering scripts,Printing and Faxing of rendered Scripts
        /// </summary>
        /// <returns></returns>
        private bool DocumentUpdateQueueDocument()
        {
            DataTable DataTableClientMedicationsNCSampleORStockDrugs;
            DataTable DataTableClientMedicationsNCNonSampleORStockDrugs;
            DataTable DataTableClientMedicationsC2SampleORStockDrugs;
            DataTable DataTableClientMedicationsC2NonSampleORStockDrugs;
            DataTable DataTableClientMedicationsControlledSampleORStockDrugs;
            //Task#2580
            DataTable DataTableClientMedicationsControlledNonSampleORStockDrugs;            
            int PharmacyId = 0;
            //Task#2660
            string File = "";
            int seq = 1;
            bool _strScriptsTobeFaxedButPrinted = false;
            //Code added by Loveena in ref to Task#2597
            string strSendCoverLetter = "false";
            int NumberOfTimesFaxSend = 0;
            DataSet DataSetPharmacies;
            DataRow[] drSelectedPharmacy = null;
            //Added by Loveena in ref to Task#188 on 23-Feb-2009 as Stored Procedure ssp_SCGetDataFromPharmacies Modified.
            DataRow[] drPharmacies = null;
            DataRow[] DataRowsClientMedeicationsCategory2Drugs = null;
            DataRow[] DataRowsClientMedicationsNormalCategoryDrugs = null;
            //Task#2580
            DataRow[] DataRowsClientMedicationsControlledCategoryDrugs = null;
            
            string _strPrintChartCopy = null;
            if (CheckBoxPrintChartCopy.Checked)
                _strPrintChartCopy = "true";
            else
                _strPrintChartCopy = "false";

            ClientMedication _ObjectClientMedication = null;
            string _strMedicationInstructionIds = "";

            try
            {
                HiddenFieldShowError.Value = "";
                _DrugsOrderMethod = Request.Form["txtButtonValue"];
                if (Session["DataSetPrescribedClientMedications"] != null)
                {
                    _ObjectClientMedication = new ClientMedication();
                    ObjectClientMedication = (DataSetClientMedications)Session["DataSetPrescribedClientMedications"];
                    if (_DrugsOrderMethod == "Refill" || _DrugsOrderMethod == "REFILL")
                    {
                        //Set the Primary Key for ClientMedications
                        var dcDataTableClientMedications = new DataColumn[1];
                        dcDataTableClientMedications[0] =
                            ObjectClientMedication.Tables["ClientMedications"].Columns["ClientMedicationId"];
                        ObjectClientMedication.Tables["ClientMedications"].PrimaryKey = dcDataTableClientMedications;
                        //Code commented by Chandan as per task #131 (Ref#2429)- 1.7.3 - ClientMedicationInteraction Not Saved on Refill
                        //As in Refill case Interactions and Interaction Details need not to be created again as no new ClientMedications will be created
                        var _dsClientSummary = new DataSet();
                        _dsClientSummary = (DataSet)Session["DataSetClientSummary"];
                        if (_dsClientSummary.Tables["ClientMedicationInteractions"].Rows.Count > 0)
                        {
                            ObjectClientMedication.Tables["ClientMedicationInteractions"].Clear();
                            ObjectClientMedication.Tables["ClientMedicationInteractionDetails"].Clear();
                        }
                    }


                    OrderingMethod =
                        Convert.ToChar(
                            ObjectClientMedication.Tables["ClientMedicationScripts"].Rows[0]["OrderingMethod"].ToString());
                    PrintDrugInformation =
                        Convert.ToChar(
                            ObjectClientMedication.Tables["ClientMedicationScripts"].Rows[0]["PrintDrugInformation"]
                                .ToString());


                    
                    //LocationId = Convert.ToInt32(DropDownListLocations.SelectedValue.ToString());
                    if (ObjectClientMedication.Tables["ClientMedicationScripts"].Rows[0]["LocationId"] != DBNull.Value)
                        LocationId =
                            Convert.ToInt32(
                                ObjectClientMedication.Tables["ClientMedicationScripts"].Rows[0]["LocationId"]);


                    _DataTableClientMedications = ObjectClientMedication.Tables["ClientMedications"];
                    _DataTableClientMedicationInstructions =
                        ObjectClientMedication.Tables["ClientMedicationInstructions"];
                    _DataTableClientMedicationScriptDrugs = ObjectClientMedication.Tables["ClientMedicationScriptDrugs"];
                    //Added By anuj on 12feb,2010 fro task ref 85
                    _DataTableClientMedicationScriptDrugStrengths =
                        ObjectClientMedication.Tables["ClientMedicationScriptDrugStrengths"];
                    //Ended over here


                    //Find out Category2,NormalCategory and ControlledCategoryDrugss

                    DataRowsClientMedeicationsCategory2Drugs =
                        _DataTableClientMedications.Select("(ISNULL(RecordDeleted,'N')='N') and (DrugCategory='2')",
                                                           " [ClientMedicationId] DESC ");
                    DataRowsClientMedicationsNormalCategoryDrugs =
                        _DataTableClientMedications.Select(
                            "(ISNULL(RecordDeleted,'N')='N') and (DrugCategory IS NULL OR (DrugCategory<>'2' AND DrugCategory<>'3'  AND DrugCategory<>'4' AND DrugCategory<>'5') OR DrugCategory='') ",
                            " [ClientMedicationId] DESC ");
                    //Task#2580
                    DataRowsClientMedicationsControlledCategoryDrugs =
                        _DataTableClientMedications.Select(
                            "(ISNULL(RecordDeleted,'N')='N') and (DrugCategory='3' OR DrugCategory='4' OR DrugCategory='5')",
                            " [ClientMedicationId] DESC ");
                    

                    DataTableClientMedicationsC2NonSampleORStockDrugs = null;
                    //Task#2580
                    DataTableClientMedicationsControlledNonSampleORStockDrugs = null;
                    //DataTableClientMedicationsControlledNonSampleORStockDrugsC3 = null;
                    //DataTableClientMedicationsControlledNonSampleORStockDrugsC4 = null;
                    //DataTableClientMedicationsControlledNonSampleORStockDrugsC5 = null;

                    DataTableClientMedicationsNCNonSampleORStockDrugs = null;


                    DataTableClientMedicationsNCNonSampleORStockDrugs = _DataTableClientMedications.Clone();

                    DataTableClientMedicationsC2NonSampleORStockDrugs = _DataTableClientMedications.Clone();

                    //Task#2580
                    DataTableClientMedicationsControlledNonSampleORStockDrugs = _DataTableClientMedications.Clone();
                    


                    try
                    {
                        if (DataRowsClientMedicationsNormalCategoryDrugs.Length > 0)
                        {
                            foreach (DataRow dr in DataRowsClientMedicationsNormalCategoryDrugs)
                            {
                                DataRow[] drInstructions =
                                    _DataTableClientMedicationInstructions.Select("ClientMedicationId=" +
                                                                                  Convert.ToInt32(
                                                                                      dr["ClientMedicationId"].ToString()));

                                foreach (DataRow dr1 in drInstructions)
                                {
                                    if (_strMedicationInstructionIds == "")
                                    {
                                        _strMedicationInstructionIds += dr1["ClientMedicationInstructionId"].ToString();
                                    }
                                    else
                                    {
                                        _strMedicationInstructionIds += "," + dr1["ClientMedicationInstructionId"];
                                    }
                                }
                                if (_strMedicationInstructionIds != "")
                                {
                                    
                                    DataRow[] dr2 =
                                        _DataTableClientMedicationScriptDrugs.Select(
                                            "ClientMedicationInstructionId in(" + _strMedicationInstructionIds +
                                            ") and (Pharmacy+Sample+Stock>0) and ISNULL(AutoCalcAllow,'Y')='Y' ");
                                    DataRow[] dr3 =
                                        _DataTableClientMedicationScriptDrugs.Select(
                                            "ClientMedicationInstructionId in(" + _strMedicationInstructionIds +
                                            ") and ISNULL(AutoCalcAllow,'N')='N' ");
                                    //if (dr2.Length > 0)
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
                    //Task#33
                    string category2Instructions = "";
                    if (DataRowsClientMedeicationsCategory2Drugs.Length > 0)
                    {
                        foreach (DataRow dr in DataRowsClientMedeicationsCategory2Drugs)
                        {
                            DataRow[] drInstructions =
                                _DataTableClientMedicationInstructions.Select("ClientMedicationId=" +
                                                                              Convert.ToInt32(
                                                                                  dr["ClientMedicationId"].ToString()));

                            foreach (DataRow dr1 in drInstructions)
                            {
                                if (_strMedicationInstructionIds == "")
                                {
                                    _strMedicationInstructionIds += dr1["ClientMedicationInstructionId"].ToString();
                                }
                                else
                                {
                                    _strMedicationInstructionIds += "," + dr1["ClientMedicationInstructionId"];
                                }
                                //Task#33
                                if (category2Instructions == "")
                                {
                                    category2Instructions += dr1["ClientMedicationInstructionId"].ToString();
                                }
                                else
                                {
                                    category2Instructions += "," + dr1["ClientMedicationInstructionId"];
                                }
                            }

                            if (_strMedicationInstructionIds != "")
                            {
                                
                                DataRow[] dr2 =
                                    _DataTableClientMedicationScriptDrugs.Select("ClientMedicationInstructionId in(" +
                                                                                 _strMedicationInstructionIds +
                                                                                 ") and (Pharmacy+Sample+Stock>0)and ISNULL(AutoCalcAllow,'Y')='Y' ");
                                DataRow[] dr3 =
                                    _DataTableClientMedicationScriptDrugs.Select("ClientMedicationInstructionId in(" +
                                                                                 _strMedicationInstructionIds +
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
                            DataRow[] drInstructions =
                                _DataTableClientMedicationInstructions.Select("ClientMedicationId=" +
                                                                              Convert.ToInt32(
                                                                                  dr["ClientMedicationId"].ToString()));

                            foreach (DataRow dr1 in drInstructions)
                            {
                                if (_strMedicationInstructionIds == "")
                                {
                                    _strMedicationInstructionIds += dr1["ClientMedicationInstructionId"].ToString();
                                }
                                else
                                {
                                    _strMedicationInstructionIds += "," + dr1["ClientMedicationInstructionId"];
                                }
                            }
                            if (_strMedicationInstructionIds != "")
                            {
                                //Changes by Sonia
                                //Ref Task #64 Error Preventing Script Creation (1)
                                //Changed the Logic to include those Medications in Script as well where Pharm<=0 but (Pharmacy+Sample+Stock) Should be >0
                                DataRow[] dr2 =
                                    _DataTableClientMedicationScriptDrugs.Select("ClientMedicationInstructionId in(" +
                                                                                 _strMedicationInstructionIds +
                                                                                 ") and (Pharmacy+Sample+Stock>0) ");
                                //Changes end over here
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


                    //

                    

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

                    //Added by Chandan for Task#2578 
                    //nCategory2ScriptCount = ScriptsCount(_Category2Drugs);
                    nCategory2ScriptCount = _Category2Drugs;
                    //Added end by Chandan for Task#2578 
                    nOtherCategoryScriptCount = ScriptsCount(_OtherCategoryDrugs);
                    //Task#2580
                    //nControlledScriptCount = ScriptsCount(_ControlledDrugs);
                    nControlledScriptCount = _ControlledDrugs;

                    int NoOfRowsToBeCopied = 0;

                    #region Generate Category2Scripts

                    //Code added as per chat with Tom to insert records in ClientMedycationScriptDrugStrengths for C2 MEdications
                    //on basis of Script generated
                    foreach (DataRow dr in dsTemp.Tables["ClientMedicationsC2NonSampleORStockDrugs"].Rows)
                    {
                        DataRow[] drClientMedicationDrugStrength =
                            ObjectClientMedication.Tables["ClientMedicationScriptDrugStrengths"].Select(
                                "ClientMedicationID=" + dr["clientMedicationId"]);
                        if (drClientMedicationDrugStrength.Length > 0)
                        {
                            foreach (DataRow drDrugStrength in drClientMedicationDrugStrength)
                            {
                                ObjectClientMedication.Tables["ClientMedicationScriptDrugStrengths"].Rows.Remove(
                                    drDrugStrength);
                            }
                        }
                    }
                    NoOfRowsToBeCopied = 0;

                    //Ref to Task#33
                    bool isScript = false;
                    for (int i = 0; i < dsTemp.Tables["ClientMedicationsC2NonSampleORStockDrugs"].Rows.Count; i++)
                    {
                        //Modified by Loveena in ref to Task#2656                        
                        DataRow[] dtrowInstructions =
                            ObjectClientMedication.Tables["ClientMedicationInstructions"].Select(
                                "ClientMedicationId=" +
                                dsTemp.Tables["ClientMedicationsC2NonSampleORStockDrugs"].Rows[i]["ClientMedicationId"] +
                                " and Active='Y'", "StartDate Asc");
                        //DataRow[] dtrowInstructions = ObjectClientMedication.Tables["ClientMedicationInstructions"].Select("ClientMedicationId=" + dsTemp.Tables["ClientMedicationsC2NonSampleORStockDrugs"].Rows[i]["ClientMedicationId"], "StartDate Asc");
                        if (dtrowInstructions.Length > 0)
                        {
                            for (int index = 0; index < dtrowInstructions.Length; index++)
                            {
                                if (index > 0)
                                {
                                    if (dtrowInstructions[index - 1]["StartDate"].ToString() !=
                                        dtrowInstructions[index]["StartDate"].ToString())
                                    {
                                        GenerateScriptsTableRows('N', iMedicationRowsCount,
                                                                 dsTemp.Tables[
                                                                     "ClientMedicationsC2NonSampleORStockDrugs"],
                                                                 NoOfRowsToBeCopied, "C2");
                                        //Ref to Task#33
                                        DataRow[] drScriptInstructions =
                                            ObjectClientMedication.Tables["ClientMedicationScriptDrugs"].Select(
                                                "ClientMedicationInstructionId=" +
                                                dtrowInstructions[index]["ClientMedicationInstructionId"]);
                                        if (drScriptInstructions.Length > 0)
                                            //for (int loopCnt = 0; loopCnt < drScriptInstructions.Length; loopCnt++)
                                            //    {
                                            //if (Convert.ToInt32(ObjectClientMedication_Temp.Tables["ClientMedicationScripts"].Rows[index]["ClientMedicationScriptId"]) == 0)

                                            drScriptInstructions[0]["ClientMedicationScriptId"] = scriptId;
                                        //Added in ref to Task#85 as per Tom's Comment to add qula no. of rows to CMSD
                                        //ObjectClientMedication_Temp.Tables["ClientMedicationScriptDrugStrengths"].Rows[index]["ClientMedicationScriptId"] = scriptId;
                                        //Code added as per chat with Tom to insert records in ClientMedycationScriptDrugStrengths for C2 MEdications
                                        //on basis of Script generated
                                        DataRow dataRowClientMEdicationScriptDrugStrengths =
                                            ObjectClientMedication.Tables["ClientMedicationScriptDrugStrengths"].NewRow();
                                        int id = 0;
                                        if (
                                            ObjectClientMedication.Tables["ClientMedicationScriptDrugStrengths"].Rows
                                                                                                                .Count >
                                            0)
                                        {
                                            id =
                                                Convert.ToInt32(
                                                    ObjectClientMedication.Tables["ClientMedicationScriptDrugStrengths"]
                                                        .Compute("Max(ClientMedicationScriptDrugStrengthId)", ""));
                                            dataRowClientMEdicationScriptDrugStrengths[
                                                "ClientMedicationScriptDrugStrengthId"] = id + 1;
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
                                        //Code added by Loveena in ref to Task#2802
                                        dataRowClientMEdicationScriptDrugStrengths["PharmacyText"] =
                                            drScriptInstructions[0]["PharmacyText"];
                                        //Code ends over here.
                                        dataRowClientMEdicationScriptDrugStrengths["Sample"] =
                                            drScriptInstructions[0]["Sample"];
                                        dataRowClientMEdicationScriptDrugStrengths["Stock"] =
                                            drScriptInstructions[0]["Stock"];
                                        dataRowClientMEdicationScriptDrugStrengths["Refills"] = 0;
                                        dataRowClientMEdicationScriptDrugStrengths["RowIdentifier"] = Guid.NewGuid();
                                        dataRowClientMEdicationScriptDrugStrengths["CreatedBy"] =
                                            ((StreamlineIdentity)Context.User.Identity).UserCode;
                                        dataRowClientMEdicationScriptDrugStrengths["CreatedDate"] = DateTime.Now;
                                        // }
                                        dataRowClientMEdicationScriptDrugStrengths["ModifiedBy"] =
                                            ((StreamlineIdentity)Context.User.Identity).UserCode;
                                        dataRowClientMEdicationScriptDrugStrengths["ModifiedDate"] = DateTime.Now;
                                        // if (newRowCMSD == true)
                                        ObjectClientMedication.Tables["ClientMedicationScriptDrugStrengths"].Rows.Add(
                                            dataRowClientMEdicationScriptDrugStrengths);
                                        // }

                                        isScript = true;
                                    }
                                    else
                                    {
                                        //if(counter< counter)
                                        if (isScript == false)
                                        {
                                            GenerateScriptsTableRows('N', iMedicationRowsCount,
                                                                     dsTemp.Tables[
                                                                         "ClientMedicationsC2NonSampleORStockDrugs"],
                                                                     NoOfRowsToBeCopied, "C2");
                                            DataRow[] drScriptInstructions =
                                                ObjectClientMedication.Tables["ClientMedicationScriptDrugs"].Select(
                                                    "ClientMedicationInstructionId=" +
                                                    dtrowInstructions[index]["ClientMedicationInstructionId"]);
                                            if (drScriptInstructions.Length > 0)
                                                //for (int loopCnt = 0; loopCnt < drScriptInstructions.Length; loopCnt++)
                                                //    {
                                                //if (Convert.ToInt32(ObjectClientMedication_Temp.Tables["ClientMedicationScripts"].Rows[index]["ClientMedicationScriptId"]) == 0)
                                                //    drScriptInstructions[0]["ClientMedicationScriptId"] = Convert.ToInt32(ObjectClientMedication_Temp.Tables["ClientMedicationScripts"].Rows[index]["ClientMedicationScriptId"]) + 1;
                                                //else
                                                //    drScriptInstructions[0]["ClientMedicationScriptId"] = Convert.ToInt32(ObjectClientMedication_Temp.Tables["ClientMedicationScripts"].Rows[index]["ClientMedicationScriptId"]);

                                                drScriptInstructions[0]["ClientMedicationScriptId"] = scriptId;
                                            //Added in ref to Task#85 as per Tom's Comment to add qula no. of rows to CMSD
                                            //ObjectClientMedication_Temp.Tables["ClientMedicationScriptDrugStrengths"].Rows[index]["ClientMedicationScriptId"] = scriptId;
                                            //Code added as per chat with Tom to insert records in ClientMedycationScriptDrugStrengths for C2 MEdications
                                            //on basis of Script generated
                                            DataRow dataRowClientMEdicationScriptDrugStrengths =
                                                ObjectClientMedication.Tables["ClientMedicationScriptDrugStrengths"]
                                                    .NewRow();
                                            int id = 0;
                                            if (
                                                ObjectClientMedication.Tables["ClientMedicationScriptDrugStrengths"]
                                                    .Rows.Count > 0)
                                            {
                                                id =
                                                    Convert.ToInt32(
                                                        ObjectClientMedication.Tables[
                                                            "ClientMedicationScriptDrugStrengths"].Compute(
                                                                "Max(ClientMedicationScriptDrugStrengthId)", ""));
                                                dataRowClientMEdicationScriptDrugStrengths[
                                                    "ClientMedicationScriptDrugStrengthId"] = id + 1;
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
                                            //Code added by Loveena in ref to Task#2802
                                            dataRowClientMEdicationScriptDrugStrengths["PharmacyText"] =
                                                drScriptInstructions[0]["PharmacyText"];
                                            //Code ends over here.
                                            dataRowClientMEdicationScriptDrugStrengths["Sample"] =
                                                drScriptInstructions[0]["Sample"];
                                            dataRowClientMEdicationScriptDrugStrengths["Stock"] =
                                                drScriptInstructions[0]["Stock"];
                                            dataRowClientMEdicationScriptDrugStrengths["Refills"] = 0;
                                            dataRowClientMEdicationScriptDrugStrengths["RowIdentifier"] = Guid.NewGuid();
                                            dataRowClientMEdicationScriptDrugStrengths["CreatedBy"] =
                                                ((StreamlineIdentity)Context.User.Identity).UserCode;
                                            dataRowClientMEdicationScriptDrugStrengths["CreatedDate"] = DateTime.Now;
                                            // }
                                            dataRowClientMEdicationScriptDrugStrengths["ModifiedBy"] =
                                                ((StreamlineIdentity)Context.User.Identity).UserCode;
                                            dataRowClientMEdicationScriptDrugStrengths["ModifiedDate"] = DateTime.Now;
                                            // if (newRowCMSD == true)
                                            ObjectClientMedication.Tables["ClientMedicationScriptDrugStrengths"].Rows
                                                                                                                .Add(
                                                                                                                    dataRowClientMEdicationScriptDrugStrengths);
                                            //}
                                            isScript = true;
                                        }
                                        else
                                        {
                                            DataRow[] drScriptInstructions =
                                                ObjectClientMedication.Tables["ClientMedicationScriptDrugs"].Select(
                                                    "ClientMedicationInstructionId=" +
                                                    dtrowInstructions[index]["ClientMedicationInstructionId"]);
                                            if (drScriptInstructions.Length > 0)
                                            {
                                                drScriptInstructions[0]["ClientMedicationScriptId"] = scriptId;
                                                //Added in ref to Task#85 as per Tom's Comment to add qula no. of rows to CMSD
                                                //Code commented as per chat with Tom to insert records in ClientMedycationScriptDrugStrengths for C2 MEdications
                                                //on basis of Script generated
                                                //ObjectClientMedication.Tables["ClientMedicationScriptDrugStrengths"].Rows[index]["ClientMedicationScriptId"] = scriptId;
                                            }
                                        }
                                    }
                                }
                                else
                                {
                                    GenerateScriptsTableRows('N', iMedicationRowsCount,
                                                             dsTemp.Tables["ClientMedicationsC2NonSampleORStockDrugs"],
                                                             NoOfRowsToBeCopied, "C2");
                                    DataRow[] drScriptInstructions =
                                        ObjectClientMedication.Tables["ClientMedicationScriptDrugs"].Select(
                                            "ClientMedicationInstructionId=" +
                                            dtrowInstructions[index]["ClientMedicationInstructionId"]);
                                    if (drScriptInstructions.Length > 0)
                                        //for (int loopCnt = 0; loopCnt < drScriptInstructions.Length; loopCnt++)
                                        //    {
                                        //if (Convert.ToInt32(ObjectClientMedication_Temp.Tables["ClientMedicationScripts"].Rows[index]["ClientMedicationScriptId"]) == 0)
                                        //    drScriptInstructions[0]["ClientMedicationScriptId"] = Convert.ToInt32(ObjectClientMedication_Temp.Tables["ClientMedicationScripts"].Rows[index]["ClientMedicationScriptId"]) + 1;
                                        //else
                                        //    drScriptInstructions[0]["ClientMedicationScriptId"] = Convert.ToInt32(ObjectClientMedication_Temp.Tables["ClientMedicationScripts"].Rows[index]["ClientMedicationScriptId"]);

                                        drScriptInstructions[0]["ClientMedicationScriptId"] = scriptId;
                                    //Added in ref to Task#85 as per Tom's Comment to add qula no. of rows to CMSD
                                    //ObjectClientMedication_Temp.Tables["ClientMedicationScriptDrugStrengths"].Rows[index]["ClientMedicationScriptId"] = scriptId;
                                    //Code added as per chat with Tom to insert records in ClientMedycationScriptDrugStrengths for C2 MEdications
                                    //on basis of Script generated
                                    DataRow dataRowClientMEdicationScriptDrugStrengths =
                                        ObjectClientMedication.Tables["ClientMedicationScriptDrugStrengths"].NewRow();
                                    int id = 0;
                                    if (
                                        ObjectClientMedication.Tables["ClientMedicationScriptDrugStrengths"].Rows.Count >
                                        0)
                                    {
                                        id =
                                            Convert.ToInt32(
                                                ObjectClientMedication.Tables["ClientMedicationScriptDrugStrengths"]
                                                    .Compute("Max(ClientMedicationScriptDrugStrengthId)", ""));
                                        dataRowClientMEdicationScriptDrugStrengths[
                                            "ClientMedicationScriptDrugStrengthId"] = id + 1;
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
                                    //Code added by Loveena in ref to Task#2802
                                    dataRowClientMEdicationScriptDrugStrengths["PharmacyText"] =
                                        drScriptInstructions[0]["PharmacyText"];
                                    //Code ends over here.
                                    dataRowClientMEdicationScriptDrugStrengths["Sample"] =
                                        drScriptInstructions[0]["Sample"];
                                    dataRowClientMEdicationScriptDrugStrengths["Stock"] =
                                        drScriptInstructions[0]["Stock"];
                                    dataRowClientMEdicationScriptDrugStrengths["Refills"] = 0;
                                    dataRowClientMEdicationScriptDrugStrengths["RowIdentifier"] = Guid.NewGuid();
                                    dataRowClientMEdicationScriptDrugStrengths["CreatedBy"] =
                                        ((StreamlineIdentity)Context.User.Identity).UserCode;
                                    dataRowClientMEdicationScriptDrugStrengths["CreatedDate"] = DateTime.Now;
                                    // }
                                    dataRowClientMEdicationScriptDrugStrengths["ModifiedBy"] =
                                        ((StreamlineIdentity)Context.User.Identity).UserCode;
                                    dataRowClientMEdicationScriptDrugStrengths["ModifiedDate"] = DateTime.Now;
                                    // if (newRowCMSD == true)
                                    ObjectClientMedication.Tables["ClientMedicationScriptDrugStrengths"].Rows.Add(
                                        dataRowClientMEdicationScriptDrugStrengths);
                                    //}
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
                                                 dsTemp.Tables["ClientMedicationsNCNonSampleORStockDrugs"],
                                                 NoOfRowsToBeCopied, "NC");
                        NoOfRowsToBeCopied = NoOfRowsToBeCopied + RowsToBeCopiedincrmtcount;
                    }

                    #endregion

                    #region Generate ControlledCategoryScripts

                    NoOfRowsToBeCopied = 0;

                    for (int icount = 1; icount <= nControlledScriptCount; icount++)
                    {
                        iMedicationRowsCount = 0;
                        iloopCounter = 0;
                        iMedicationRowsCount =
                            dsTemp.Tables["ClientMedicationsControlledNonSampleORStockDrugs"].Rows.Count;

                        GenerateScriptsTableRows('N', iMedicationRowsCount,
                                                 dsTemp.Tables["ClientMedicationsControlledNonSampleORStockDrugs"],
                                                 NoOfRowsToBeCopied, "CT");
                        //Task#2580
                        //NoOfRowsToBeCopied = NoOfRowsToBeCopied + 3;
                        NoOfRowsToBeCopied = NoOfRowsToBeCopied + 1;
                    }

                    #endregion

                    //Remove the Last Row From ClientMedicationScripts Table which was generated in New Order Page just to Enforce Relations
                    ObjectClientMedication.Tables["ClientMedicationScripts"].Rows[0].Delete();
                    //Code Added by Pushpita date 5th Feb 2010 Ref: task 85 SDI Projects FY10 - Venture 
                    if (OrderingMethod == 'E')
                    {
                        if (_Queue == false)
                        {
                            DataTableSureScriptsOutgoingMessages =
                                ObjectClientMedication.Tables["SureScriptsOutgoingMessages"];
                            DataRowSureScriptsOutgoingMessages = DataTableSureScriptsOutgoingMessages.NewRow();
                            DataRowSureScriptsOutgoingMessages["ClientMedicationScriptId"] =
                                ObjectClientMedication.Tables["ClientMedicationScripts"].Rows[0][
                                    "ClientMedicationScriptId"];
                            DataRowSureScriptsOutgoingMessages["MessageStatus"] = 5541;
                            DataRowSureScriptsOutgoingMessages["RowIdentifier"] = Guid.NewGuid();
                            DataRowSureScriptsOutgoingMessages["CreatedBy"] =
                                ((StreamlineIdentity)Context.User.Identity).UserCode;
                            DataRowSureScriptsOutgoingMessages["CreatedDate"] = DateTime.Now;
                            DataRowSureScriptsOutgoingMessages["ModifiedBy"] =
                                ((StreamlineIdentity)Context.User.Identity).UserCode;
                            DataRowSureScriptsOutgoingMessages["ModifiedDate"] = DateTime.Now;
                            DataTableSureScriptsOutgoingMessages.Rows.Add(DataRowSureScriptsOutgoingMessages);
                            ObjectClientMedication.Merge(DataTableSureScriptsOutgoingMessages);
                        }
                        //Code added by Loveena in ref to  Task#85
                        //The number of records in ClientMedicationScriptDrugs and ClientMedicationScriptDrugStrengths 
                        //table are the same for Paper/Fax/Electronic, what could be different is the number 
                        //of records in ClientMedicationScripts table. In case of Paper/Fax there is only 1 
                        //insert in this table for the order. In case of Electronic, there is one per strength.
                        for (int i = 0; i < ObjectClientMedication.Tables["ClientMedications"].Rows.Count; i++)
                        {
                            if (
                                Convert.ToString(
                                    ObjectClientMedication.Tables["ClientMedications"].Rows[i]["DrugCategory"]) != "2")
                            {
                                DataRow[] dataRowClientMedicationScriptDrugStrengths =
                                    ObjectClientMedication.Tables["ClientMedicationScriptDrugStrengths"].Select(
                                        "ClientMedicationId=" +
                                        ObjectClientMedication.Tables["ClientMedications"].Rows[i]["ClientMedicationId"]);
                                foreach (DataRow dr in dataRowClientMedicationScriptDrugStrengths)
                                {
                                    DataRow[] dataRowClientMedicationInstructions =
                                        ObjectClientMedication.Tables["ClientMedicationInstructions"].Select(
                                            "ClientMedicationId=" + dr["ClientMedicationId"] + "and StrengthId=" +
                                            dr["StrengthId"]);
                                    foreach (DataRow dataRow in dataRowClientMedicationInstructions)
                                    {
                                        DataRow[] dataRowClientMedicationScriptDrugs =
                                            ObjectClientMedication.Tables["ClientMedicationScriptDrugs"].Select(
                                                "ClientMedicationInstructionId=" +
                                                dataRow["ClientMedicationInstructionId"]);
                                        foreach (DataRow dtRow in dataRowClientMedicationScriptDrugs)
                                        {
                                            dtRow["ClientMedicationScriptId"] = dr["ClientMedicationScriptId"];
                                        }
                                    }
                                }
                            }
                        }

                        //Code ends over here
                    }

                   //Added By Pranay W.R.T BearRiver Task#342.

                    Streamline.UserBusinessServices.ClientMedication objClientMedication = new Streamline.UserBusinessServices.ClientMedication();
                    if (HiddenFieldPrescriber.Value != "")
                    {
                        int value;
                        bool success = int.TryParse(HiddenFieldPrescriber.Value.ToString(), out value);
                        if (success == true)
                            DropDownListPrescriber.SelectedValue = value.ToString();
                    }
                    DataSet dsElectronicPrescriptionPermissions = objClientMedication.ElectronicPrescriptionPermissions(Convert.ToInt32(DropDownListPrescriber.SelectedValue), 0);
                    string SelectedPresciberHasElectronicPermission = dsElectronicPrescriptionPermissions.Tables[0].Rows[0]["EPCSEnabled"].ToString();

                    if (OrderingMethod == 'P') // All MedicationScripts are Printed.
                    {
                        foreach (DataRow drClientMedicationScriptDrugs in ObjectClientMedication.ClientMedicationScriptDrugs.Select("isnull(recorddeleted,'N') <> 'Y'"))
                        {
                            foreach (
                                DataRow _dataRowClientMedicationScript in
                                    ObjectClientMedication.ClientMedicationScripts.Select(
                                        "ClientMedicationScriptId=" +
                                        drClientMedicationScriptDrugs["ClientMedicationScriptId"] +
                                        " and isnull(recorddeleted,'N') <> 'Y'"))
                            {
                                _dataRowClientMedicationScript["OrderingMethod"] = 'P';
                            }
                        }
                    }

                    if (OrderingMethod == 'E')
                    {
                        if (SelectedPresciberHasElectronicPermission.ToUpper() == "Y")
                        {
                            foreach (DataRow drClientMedicationScriptDrugs in ObjectClientMedication.ClientMedicationScriptDrugs.Select("isnull(recorddeleted,'N') <> 'Y'"))
                            {
                                foreach (
                                    DataRow _dataRowClientMedicationScript in
                                        ObjectClientMedication.ClientMedicationScripts.Select(
                                            "ClientMedicationScriptId=" +
                                            drClientMedicationScriptDrugs["ClientMedicationScriptId"] +
                                            " and isnull(recorddeleted,'N') <> 'Y'"))
                                {
                                    _dataRowClientMedicationScript["OrderingMethod"] = 'E';
                                }
                            }
                        }
                        else
                        {
                            foreach (DataRow drClientMedicationScriptDrugs in ObjectClientMedication.ClientMedicationScriptDrugs.Select("isnull(recorddeleted,'N') <> 'Y' and DrugCategory in ('2','3','4','5')"))
                            {
                                foreach (
                                    DataRow _dataRowClientMedicationScript in
                                        ObjectClientMedication.ClientMedicationScripts.Select(
                                            "ClientMedicationScriptId=" +
                                            drClientMedicationScriptDrugs["ClientMedicationScriptId"] +
                                            " and isnull(recorddeleted,'N') <> 'Y'"))
                                {
                                    _dataRowClientMedicationScript["OrderingMethod"] = 'P';
                                }
                            }
                            foreach (DataRow drClientMedicationScriptDrugs in ObjectClientMedication.ClientMedicationScriptDrugs.Select("isnull(recorddeleted,'N') <> 'Y' and DrugCategory in ('0','1')"))
                            {
                                foreach (
                                    DataRow _dataRowClientMedicationScript in
                                        ObjectClientMedication.ClientMedicationScripts.Select(
                                            "ClientMedicationScriptId=" +
                                            drClientMedicationScriptDrugs["ClientMedicationScriptId"] +
                                            " and isnull(recorddeleted,'N') <> 'Y'"))
                                {
                                    _dataRowClientMedicationScript["OrderingMethod"] = 'E';
                                }
                            }
                        }

                        if (System.Configuration.ConfigurationSettings.AppSettings.AllKeys.Contains("FaxScheduledCategoryList") && SelectedPresciberHasElectronicPermission.ToUpper() != "Y")
                        {
                            string FaxScheduledCategoryList = System.Configuration.ConfigurationSettings.AppSettings["FaxScheduledCategoryList"].ToString();
                            foreach (DataRow drClientMedicationScriptDrugs in ObjectClientMedication.ClientMedicationScriptDrugs.Select("isnull(recorddeleted,'N') <> 'Y' and DrugCategory in (" + FaxScheduledCategoryList + ")")) //Sent as FAX based on key values 'FaxScheduledCategoryList'
                            {
                                foreach (
                                    DataRow _dataRowClientMedicationScript in
                                        ObjectClientMedication.ClientMedicationScripts.Select(
                                            "ClientMedicationScriptId=" +
                                            drClientMedicationScriptDrugs["ClientMedicationScriptId"] +
                                            " and isnull(recorddeleted,'N') <> 'Y'"))
                                {
                                    _dataRowClientMedicationScript["OrderingMethod"] = 'F';
                                }
                            }
                        }

                    }


                    string[] Queuedvalues = new string[4];
                    DataSet DataSetTempValidationStatus = null;
                    int _ClientMedicationTempScriptId = 0;
                    if (ObjectClientMedication.Tables["ClientMedicationScripts"].Rows.Count > 0)
                    {
                        for (int _Count = 0;
                             _Count < ObjectClientMedication.Tables["ClientMedicationScripts"].Rows.Count;
                             _Count++)
                        {
                            char capNonControlled =
                                (ConfigurationManager.AppSettings["CapNonControlledSubstances"].ToUpper() == "TRUE")
                                    ? 'Y'
                                    : 'N';
                            char capControlled =
                                (ConfigurationManager.AppSettings["CapControlledSubstances"].ToUpper() == "TRUE")
                                    ? 'Y'
                                    : 'N';

                            Queuedvalues[0] = "Queued";
                            Queuedvalues[1] = ObjectClientMedication.Tables["ClientMedications"].Rows[0]["ClientId"].ToString();
							Queuedvalues[2] = ObjectClientMedication.Tables["ClientMedications"].Rows[_Count]["MedicationNameId"].ToString();
                                Queuedvalues[3] = ObjectClientMedication.Tables["ClientMedications"].Rows[_Count]["PrescriberId"].ToString();
                            DataSetTempValidationStatus = GetValidationStatus(_ClientMedicationTempScriptId,
                                                                              capNonControlled, capControlled, Queuedvalues);
                            Array.Clear(Queuedvalues, 0, 4);

                            if (DataSetTempValidationStatus != null)
                            {
                                if (DataSetTempValidationStatus.Tables.Count > 0)
                                {
                                    ValidationStatus =
                                        Convert.ToString(
                                            DataSetTempValidationStatus.Tables["ValidationStatus"].Rows[0][
                                                "ValidationStatus"]);
                                    if (ValidationStatus.ToUpper() == "INVALID")
                                    {
                                        ValidationMessage =
                                            Convert.ToString(
                                                DataSetTempValidationStatus.Tables["ValidationStatus"].Rows[0][
                                                    "ValidationMessage"]);

                                        return false;
                                    }
                                }
                            }
                        }
                    }

                    DataSetTemp = new DataSet();
                    DataSetTemp = _ObjectClientMedication.UpdateDocuments(ObjectClientMedication);
                    //Added in ref to Task#86
                    DataTable dataTableClientMedicationScripts = DataSetTemp.Tables["ClientMedicationScripts"].Clone();
                    dataTableClientMedicationScripts.Merge(DataSetTemp.Tables["ClientMedicationScripts"]);
                   
                     DataTable dt = DataSetTemp.Tables["ClientMedications"];  
                     DataView view = new DataView(dt);
                     DataTable ClientMedications = view.ToTable("ClientMedications", false, "ClientMedicationId");
                     _ObjectClientMedication.PostClientMedicationsPrescribe(ClientMedications);
                   
                    _ObjectClientMedication = null;
                    //Make Clear the DataSetClientScripts
                    //#region SendFax

                    #region UpdateClientScriptActivities

                    //Following code will be used to update ClientScriptActivities table
                    DataSetClientScriptActivities = new DataSetClientScripts();
                    HiddenFieldAllFaxed.Value = "1";
                    //Send Fax if ordering Method is Fax
                    bool FlagForImagesDeletion = false;

                    //After ClientScript Activities have been updated Discontinue old Medications in case Choosen method was Change Order
                    DataRow[] DataRowsClientMedicationsToBeDiscontinued;
                    DataRow[] DataRowsClientMedicationsToBeRefilled;

                    DataSet _DataSetClientMedications = null;
                    try
                    {
                        if (_DrugsOrderMethod == "Refill" || _DrugsOrderMethod == "REFILL")
                        {
                            if (Session["ChangedOrderMedicationIds"] != null)
                            {
                                //DataSetClientMedications = new Streamline.UserBusinessServices.DataSets.DataSetClientMedications();
                                _DataSetClientMedications = new DataSet();

                                DataRowsClientMedicationsToBeRefilled =
                                    DataSetTemp.Tables["ClientMedications"].Select("ClientMedicationId in (" +
                                                                                   Session["ChangedOrderMedicationIds"] +
                                                                                   ")");
                                foreach (DataRow dr in DataRowsClientMedicationsToBeRefilled)
                                {
                                    dr["MedicationEndDate"] = dr["MedicationEndDate"];
                                    dr["ModifiedBy"] = ((StreamlineIdentity)Context.User.Identity).UserCode;
                                    dr["ModifiedDate"] = DateTime.Now;
                                }
                                _DataSetClientMedications.Merge(DataRowsClientMedicationsToBeRefilled);
                                _DataSetClientMedications.Tables[0].TableName = "ClientMedications";
                                _ObjectClientMedication = new ClientMedication();
                                DataSetTemp = _ObjectClientMedication.UpdateDocuments(_DataSetClientMedications);
                                _ObjectClientMedication = null;


                                //ObjectClientMedication.DiscontinueMedication(Session["ChangedOrderMedicationIds"].ToString(), 'Y', ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode, "Change Order");
                            }
                        }
                        if (_DrugsOrderMethod == "Change" || _DrugsOrderMethod == "CHANGE" || _DrugsOrderMethod.ToUpper() == "COMPLETE")
                        {
                            if (Session["ChangedOrderMedicationIds"] != null)
                            {
                                //DataSetClientMedications = new Streamline.UserBusinessServices.DataSets.DataSetClientMedications();

                                _DataSetClientMedications = new DataSet();

                                _DataSetClientSummary = (DataSet)Session["DataSetClientSummary"];
                                //Added and Commented by Chandan for task #133-1.7.3 - Change Order - ClientMedications and ClientMedicationInstructions
                                //DataRowsClientMedicationsToBeDiscontinued = _DataSetClientSummary.Tables["ClientMedications"].Select("ClientMedicationId in (" + Session["ChangedOrderMedicationIds"].ToString() + ")");
                                DataRowsClientMedicationsToBeDiscontinued =
                                    _DataSetClientSummary.Tables["ClientMedicationInstructions"].Select(
                                        "ClientMedicationId in (" + Session["ChangedOrderMedicationIds"] + ")");
                                //Added by chandan end here
                                foreach (DataRow dr in DataRowsClientMedicationsToBeDiscontinued)
                                {
                                    //Added and Commented by Chandan for task #133-1.7.3 - Change Order - ClientMedications and ClientMedicationInstructions
                                    //dr["Discontinued"] = "Y";
                                    //dr["DiscontinueDate"] = System.DateTime.Now;
                                    //dr["DiscontinuedReason"] = "Change Order";
                                    dr["Active"] = "N";
                                    //Added and Commented by Chandan end here
                                    dr["ModifiedBy"] = ((StreamlineIdentity)Context.User.Identity).UserCode;
                                    dr["ModifiedDate"] = DateTime.Now;
                                }
                                _DataSetClientMedications.Merge(DataRowsClientMedicationsToBeDiscontinued);
                                //Added and Commented by Chandan for task #133-1.7.3 - Change Order - ClientMedications and ClientMedicationInstructions
                                //_DataSetClientMedications.Tables[0].TableName = "ClientMedications";
                                _DataSetClientMedications.Tables[0].TableName = "ClientMedicationInstructions";
                                //Added and Commented by Chandan end here
                                _ObjectClientMedication = new ClientMedication();
                                DataSetTemp = _ObjectClientMedication.UpdateDocuments(_DataSetClientMedications);


                                if (Session["ClientMedicationInteractionIds"].ToString() != "")
                                    _ObjectClientMedication.DeleteInteractions(
                                        Session["ClientMedicationInteractionIds"].ToString());
                                _ObjectClientMedication = null;

                                //ObjectClientMedication.DiscontinueMedication(Session["ChangedOrderMedicationIds"].ToString(), 'Y', ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode, "Change Order");
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        if (ex.Data["CustomExceptionInformation"] == null)
                            ex.Data["CustomExceptionInformation"] =
                                "##Source Event Name -Prescribe Screen- DocumentUpdateDocument()-Discontinue Medications-Change Order Case";
                        else
                            ex.Data["CustomExceptionInformation"] = "";
                        if (ex.Data["DatasetInfo"] == null)
                            ex.Data["DatasetInfo"] = null;
                        LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error,
                                                this);
                    }
                    finally
                    {
                        DataRowsClientMedicationsToBeDiscontinued = null;
                        DataRowsClientMedicationsToBeRefilled = null;
                        if (_DataSetClientMedications != null)
                            _DataSetClientMedications.Dispose();
                    }


                    Session["DataSetPrescribedClientMedications"] = null;
                    //Added by Anuj on 19 nov,2009 for task ref #3 SDI Projects FY10 - Venture 
                    //Checking queue order button is clicked
                    if (_Queue == false)
                    {
                    }
                    //Added by Anuj on 19 nov,2009 for task ref #3 SDI Projects FY10 - Venture 
                    //Checking queue order button is clicked
                    else
                    {
                        if (((HiddenField)Parent.FindControl("HiddenFieldRedirectFrom")).Value.ToUpper() == "DASHBOARD")
                            ScriptManager.RegisterStartupScript(LabelChartCopyPrinter, LabelChartCopyPrinter.GetType(),
                                                                ClientID, "redirectToStartPage();", true);
                        else
                            ScriptManager.RegisterStartupScript(LabelChartCopyPrinter, LabelChartCopyPrinter.GetType(),
                                                                ClientID, "redirectToManagementPage();", true);
                    }
                }
                else
                {
                    ScriptManager.RegisterStartupScript(LabelChartCopyPrinter, LabelChartCopyPrinter.GetType(), ClientID,
                                                        "redirectToLoginPage();", true);
                }
                if (OrderingMethod == 'E')
                    ScriptManager.RegisterStartupScript(LabelChartCopyPrinter, LabelChartCopyPrinter.GetType(), ClientID,
                                                        "redirectToManagementPage();", true);

                return true;
                //true should be returned only if document has been updated successfully reference Task #50 MM1.5
            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally
            {
                //DataSetClientScripts = null;
                DataSetClientScriptActivities = null;
                ObjectClientMedication = null;
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

        #region--Code Added by Pradeep as per task#3305

        /// <summary>
        ///     <decription>Used to Update * preview tables </decription>
        ///     <Author>Pradeep</Author>
        /// </summary>
        /// <returns></returns>
        public bool DocumentUpdateTempDataSet()
        {
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
            DataSet DataSetTempNew = null;
            DataSet DataSetTempValidationStatus = null;
            string _strPrintChartCopy = null;
            if (Session["IncludeChartcopy"] == "Y")
                _strPrintChartCopy = "true";
            else
                _strPrintChartCopy = "false";
            string strSendCoverLetter = "false";

            string _strMedicationInstructionIds = "";
            int _PharmacyId = 0;

            try
            {
                HiddenFieldShowError.Value = "";
                _DrugsOrderMethod = Request.Form["txtButtonValue"];
                if (Session["DataSetPrescribedClientMedications"] != null)
                {
                    ObjectTempClientMedication = new ClientMedication();
                    DataSetClientMedications_Temp1 =
                        (DataSetClientMedications)Session["DataSetPrescribedClientMedications"];
                    DataSetClientMedications_Temp = (DataSetClientMedications)DataSetClientMedications_Temp1.Copy();
                   
                    _PharmacyId = Convert.ToInt32(DataSetClientMedications_Temp.Tables["ClientMedicationScripts"].Rows[0]["PharmacyId"]);
                    if (((HiddenField)Parent.FindControl("HiddenFieldRedirectFrom")).Value.ToUpper() == "DASHBOARD" &&
                       (_DrugsOrderMethod.ToUpper() == "REFILL" ))
                         //(_DrugsOrderMethod.ToUpper() == "REFILL" || _DrugsOrderMethod.ToUpper() == "CHANGEAPPROVALORDER" ))
                    {
                        var pharmacyid = (HiddenField)Page.FindControl("HiddenFieldRefillPharmacyId");
                        string Pharmacyid = pharmacyid.Value;
                        var dcDataTableClientMedications = new DataColumn[1];
                        dcDataTableClientMedications[0] =
                            DataSetClientMedications_Temp.Tables["ClientMedications"].Columns["ClientMedicationId"];
                        DataSetClientMedications_Temp.Tables["ClientMedications"].PrimaryKey =
                            dcDataTableClientMedications;
                        DataSetClientMedications_Temp.Tables["ClientMedicationInteractions"].Clear();
                        DataSetClientMedications_Temp.Tables["ClientMedicationInteractionDetails"].Clear();
                    }
                    if (((HiddenField)Parent.FindControl("HiddenFieldRedirectFrom")).Value.ToUpper() == "DASHBOARD" &&
                        (_DrugsOrderMethod.ToUpper() == "NEW ORDER"))
                    {
                        var pharmacyid = (HiddenField)Page.FindControl("HiddenFieldRefillPharmacyId");
                        string Pharmacyid = pharmacyid.Value;
                    }
                    OrderingMethod =
                        Convert.ToChar(
                            DataSetClientMedications_Temp1.Tables["ClientMedicationScripts"].Rows[0]["OrderingMethod"]
                                .ToString());
                    PrintDrugInformation =
                        Convert.ToChar(
                            DataSetClientMedications_Temp1.Tables["ClientMedicationScripts"].Rows[0][
                                "PrintDrugInformation"].ToString());
                    if (DataSetClientMedications_Temp1.Tables["ClientMedicationScripts"].Rows[0]["LocationId"] !=
                        DBNull.Value)
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
                    DataRowsClientMedeicationsCategory2Drugs =
                        _DataTableClientMedications.Select("(ISNULL(RecordDeleted,'N')='N') and (DrugCategory='2')",
                                                           " [ClientMedicationId] DESC ");
                    DataRowsClientMedicationsNormalCategoryDrugs =
                        _DataTableClientMedications.Select(
                            "(ISNULL(RecordDeleted,'N')='N') and (DrugCategory IS NULL OR (DrugCategory<>'2' AND DrugCategory<>'3'  AND DrugCategory<>'4' AND DrugCategory<>'5') OR DrugCategory='') ",
                            " [ClientMedicationId] DESC ");
                    DataRowsClientMedicationsControlledCategoryDrugs =
                        _DataTableClientMedications.Select(
                            "(ISNULL(RecordDeleted,'N')='N') and (DrugCategory='3' OR DrugCategory='4' OR DrugCategory='5')",
                            " [ClientMedicationId] DESC ");
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
                                DataRow[] drInstructions =
                                    _DataTableClientMedicationInstructions.Select("ClientMedicationId=" +
                                                                                  Convert.ToInt32(
                                                                                      dr["ClientMedicationId"].ToString()));

                                foreach (DataRow dr1 in drInstructions)
                                {
                                    if (_strMedicationInstructionIds == "")
                                    {
                                        _strMedicationInstructionIds += dr1["ClientMedicationInstructionId"].ToString();
                                    }
                                    else
                                    {
                                        _strMedicationInstructionIds += "," + dr1["ClientMedicationInstructionId"];
                                    }
                                }
                                if (_strMedicationInstructionIds != "")
                                {
                                    DataRow[] dr2 =
                                        _DataTableClientMedicationScriptDrugs.Select(
                                            "ClientMedicationInstructionId in(" + _strMedicationInstructionIds +
                                            ") and (Pharmacy+Sample+Stock>0)  and ISNULL(AutoCalcAllow,'Y')='Y' ");
                                    DataRow[] dr3 =
                                        _DataTableClientMedicationScriptDrugs.Select(
                                            "ClientMedicationInstructionId in(" + _strMedicationInstructionIds +
                                            ") and ISNULL(AutoCalcAllow,'N')='N' ");
                                    if (dr2.Length > 0 || dr3.Length > 0)
                                        DataTableClientMedicationsNCNonSampleORStockDrugs.Rows.Add(dr.ItemArray);
                                }
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                    }

                    //Category 2 Drugs
                    string category2Instructions = "";
                    if (DataRowsClientMedeicationsCategory2Drugs.Length > 0)
                    {
                        foreach (DataRow dr in DataRowsClientMedeicationsCategory2Drugs)
                        {
                            DataRow[] drInstructions =
                                _DataTableClientMedicationInstructions.Select("ClientMedicationId=" +
                                                                              Convert.ToInt32(
                                                                                  dr["ClientMedicationId"].ToString()));

                            foreach (DataRow dr1 in drInstructions)
                            {
                                if (_strMedicationInstructionIds == "")
                                {
                                    _strMedicationInstructionIds += dr1["ClientMedicationInstructionId"].ToString();
                                }
                                else
                                {
                                    _strMedicationInstructionIds += "," + dr1["ClientMedicationInstructionId"];
                                }
                                if (category2Instructions == "")
                                {
                                    category2Instructions += dr1["ClientMedicationInstructionId"].ToString();
                                }
                                else
                                {
                                    category2Instructions += "," + dr1["ClientMedicationInstructionId"];
                                }
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
                            DataRow[] drInstructions =
                                _DataTableClientMedicationInstructions.Select("ClientMedicationId=" +
                                                                              Convert.ToInt32(
                                                                                  dr["ClientMedicationId"].ToString()));

                            foreach (DataRow dr1 in drInstructions)
                            {
                                if (_strMedicationInstructionIds == "")
                                {
                                    _strMedicationInstructionIds += dr1["ClientMedicationInstructionId"].ToString();
                                }
                                else
                                {
                                    _strMedicationInstructionIds += "," + dr1["ClientMedicationInstructionId"];
                                }
                            }
                            if (_strMedicationInstructionIds != "")
                            {
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

                    #region Generate Category2Scripts

                    foreach (DataRow dr in dsTemp.Tables["ClientMedicationsC2NonSampleORStockDrugs"].Rows)
                    {
                        DataRow[] drClientMedicationDrugStrength =
                            DataSetClientMedications_Temp.Tables["ClientMedicationScriptDrugStrengths"].Select(
                                "ClientMedicationID=" + dr["clientMedicationId"]);
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
                        DataRow[] dtrowInstructions =
                            DataSetClientMedications_Temp.Tables["ClientMedicationInstructions"].Select(
                                "ClientMedicationId=" +
                                dsTemp.Tables["ClientMedicationsC2NonSampleORStockDrugs"].Rows[i]["ClientMedicationId"] +
                                " and Active='Y'", "StartDate Asc");
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
                                        GenerateTempScriptsTableRows('N', iMedicationRowsCount,
                                                                     dsTemp.Tables[
                                                                         "ClientMedicationsC2NonSampleORStockDrugs"],
                                                                     NoOfRowsToBeCopied, "C2");
                                        NoOfRowsToBeCopied = NoOfRowsToBeCopied + 1;
                                        DataRow[] drScriptInstructions =
                                            DataSetClientMedications_Temp.Tables["ClientMedicationScriptDrugs"].Select(
                                                "ClientMedicationInstructionId=" +
                                                dtrowInstructions[index]["ClientMedicationInstructionId"]);
                                        if (drScriptInstructions.Length > 0)
                                        {
                                            drScriptInstructions[0]["ClientMedicationScriptId"] = scriptId;
                                        }
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
                                                            "Max(ClientMedicationScriptDrugStrengthId)", ""));
                                            dataRowClientMEdicationScriptDrugStrengths[
                                                "ClientMedicationScriptDrugStrengthId"] = id + 1;
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
                                        dataRowClientMEdicationScriptDrugStrengths["RowIdentifier"] = Guid.NewGuid();
                                        dataRowClientMEdicationScriptDrugStrengths["CreatedBy"] =
                                            ((StreamlineIdentity)Context.User.Identity).UserCode;
                                        dataRowClientMEdicationScriptDrugStrengths["CreatedDate"] = DateTime.Now;
                                        dataRowClientMEdicationScriptDrugStrengths["ModifiedBy"] =
                                            ((StreamlineIdentity)Context.User.Identity).UserCode;
                                        dataRowClientMEdicationScriptDrugStrengths["ModifiedDate"] = DateTime.Now;
                                        DataSetClientMedications_Temp.Tables["ClientMedicationScriptDrugStrengths"].Rows
                                                                                                                   .Add(
                                                                                                                       dataRowClientMEdicationScriptDrugStrengths);
                                        isScript = true;
                                    }
                                    else
                                    {
                                        //if(counter< counter)
                                        if (isScript == false)
                                        {
                                            iMedicationRowsCount = 0;
                                            iMedicationRowsCount = dsTemp.Tables["ClientMedicationsC2NonSampleORStockDrugs"].Rows.Count;
                                            GenerateTempScriptsTableRows('N', iMedicationRowsCount,
                                                                         dsTemp.Tables[
                                                                             "ClientMedicationsC2NonSampleORStockDrugs"],
                                                                         NoOfRowsToBeCopied, "C2");
                                            NoOfRowsToBeCopied = NoOfRowsToBeCopied + 1;
                                            DataRow[] drScriptInstructions =
                                                DataSetClientMedications_Temp.Tables["ClientMedicationScriptDrugs"]
                                                    .Select("ClientMedicationInstructionId=" +
                                                            dtrowInstructions[index]["ClientMedicationInstructionId"]);
                                            if (drScriptInstructions.Length > 0)
                                            {
                                                drScriptInstructions[0]["ClientMedicationScriptId"] = scriptId;
                                            }
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
                                                                "Max(ClientMedicationScriptDrugStrengthId)", ""));
                                                dataRowClientMEdicationScriptDrugStrengths[
                                                    "ClientMedicationScriptDrugStrengthId"] = id + 1;
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
                                            dataRowClientMEdicationScriptDrugStrengths["RowIdentifier"] = Guid.NewGuid();
                                            dataRowClientMEdicationScriptDrugStrengths["CreatedBy"] =
                                                ((StreamlineIdentity)Context.User.Identity).UserCode;
                                            dataRowClientMEdicationScriptDrugStrengths["CreatedDate"] = DateTime.Now;
                                            dataRowClientMEdicationScriptDrugStrengths["ModifiedBy"] =
                                                ((StreamlineIdentity)Context.User.Identity).UserCode;
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
                                    GenerateTempScriptsTableRows('N', iMedicationRowsCount,
                                                                 dsTemp.Tables[
                                                                     "ClientMedicationsC2NonSampleORStockDrugs"],
                                                                 NoOfRowsToBeCopied, "C2");
                                    NoOfRowsToBeCopied = NoOfRowsToBeCopied + 1;
                                    DataRow[] drScriptInstructions =
                                        DataSetClientMedications_Temp.Tables["ClientMedicationScriptDrugs"].Select(
                                            "ClientMedicationInstructionId=" +
                                            dtrowInstructions[index]["ClientMedicationInstructionId"]);
                                    if (drScriptInstructions.Length > 0)
                                    {
                                        drScriptInstructions[0]["ClientMedicationScriptId"] = scriptId;
                                    }
                                    DataRow dataRowClientMEdicationScriptDrugStrengths =
                                        DataSetClientMedications_Temp.Tables["ClientMedicationScriptDrugStrengths"]
                                            .NewRow();
                                    int id = 0;
                                    if (
                                        DataSetClientMedications_Temp.Tables["ClientMedicationScriptDrugStrengths"].Rows
                                                                                                                   .Count >
                                        0)
                                    {
                                        id =
                                            Convert.ToInt32(
                                                DataSetClientMedications_Temp.Tables[
                                                    "ClientMedicationScriptDrugStrengths"].Compute(
                                                        "Max(ClientMedicationScriptDrugStrengthId)", ""));
                                        dataRowClientMEdicationScriptDrugStrengths[
                                            "ClientMedicationScriptDrugStrengthId"] = id + 1;
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
                                    dataRowClientMEdicationScriptDrugStrengths["RowIdentifier"] = Guid.NewGuid();
                                    dataRowClientMEdicationScriptDrugStrengths["CreatedBy"] =
                                        ((StreamlineIdentity)Context.User.Identity).UserCode;
                                    dataRowClientMEdicationScriptDrugStrengths["CreatedDate"] = DateTime.Now;
                                    dataRowClientMEdicationScriptDrugStrengths["ModifiedBy"] =
                                        ((StreamlineIdentity)Context.User.Identity).UserCode;
                                    dataRowClientMEdicationScriptDrugStrengths["ModifiedDate"] = DateTime.Now;
                                    DataSetClientMedications_Temp.Tables["ClientMedicationScriptDrugStrengths"].Rows.Add
                                        (dataRowClientMEdicationScriptDrugStrengths);
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
                        GenerateTempScriptsTableRows('N', iMedicationRowsCount,
                                                     dsTemp.Tables["ClientMedicationsNCNonSampleORStockDrugs"],
                                                     NoOfRowsToBeCopied, "NC");
                        NoOfRowsToBeCopied = NoOfRowsToBeCopied + RowsToBeCopiedincrmtcount;
                    }

                    #endregion

                    #region Generate ControlledCategoryScripts

                    NoOfRowsToBeCopied = 0;

                    for (int icount = 1; icount <= nControlledScriptCount; icount++)
                    {
                        iMedicationRowsCount = 0;
                        iloopCounter = 0;
                        iMedicationRowsCount =
                            dsTemp.Tables["ClientMedicationsControlledNonSampleORStockDrugs"].Rows.Count;
                        GenerateTempScriptsTableRows('N', iMedicationRowsCount,
                                                     dsTemp.Tables["ClientMedicationsControlledNonSampleORStockDrugs"],
                                                     NoOfRowsToBeCopied, "CT");
                        NoOfRowsToBeCopied = NoOfRowsToBeCopied + 1;
                    }

                    #endregion

                    try
                    {
                        DataTable clientMedicationScriptsToRemove = DataSetClientMedications_Temp.Tables["ClientMedicationScripts"].Clone();
                        foreach (DataRow dr in DataSetClientMedications_Temp.Tables["ClientMedicationScripts"].Rows)
                        {
                            if (dr["ScriptEventType"].ToString().IsNullOrWhiteSpace())
                            {
                                if (_DrugsOrderMethod == "Change" || _DrugsOrderMethod == "CHANGE")
                                    dr["ScriptEventType"] = "C";
                                else if (_DrugsOrderMethod == "Refill" || _DrugsOrderMethod == "REFILL") // Change to new when new med added
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
                                        "ClientMedicationScriptId = " + dr["ClientMedicationScriptId"].ToString()) != null &&
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
                                 i <=
                                 DataSetClientMedications_Temp.Tables["ClientMedicationInstructions"].Rows.Count - 1;
                                 i++)
                            {
                                DataSetClientMedications_Temp.Tables["ClientMedicationInstructions"].Rows[i].SetAdded();
                            }
                        }
                    }
                    if (OrderingMethod == 'E' || OrderingMethod=='P')
                    {
                        for (int i = 0; i < DataSetClientMedications_Temp.Tables["ClientMedications"].Rows.Count; i++)
                        {
                            if (
                                Convert.ToString(
                                    DataSetClientMedications_Temp.Tables["ClientMedications"].Rows[i]["DrugCategory"]) !=
                                "2")
                            {
                                DataRow[] dataRowClientMedicationScriptDrugStrengths =
                                    DataSetClientMedications_Temp.Tables["ClientMedicationScriptDrugStrengths"].Select(
                                        "ClientMedicationId=" +
                                        DataSetClientMedications_Temp.Tables["ClientMedications"].Rows[i][
                                            "ClientMedicationId"]);
                                foreach (DataRow dr in dataRowClientMedicationScriptDrugStrengths)
                                {
                                    DataRow[] dataRowClientMedicationInstructions =
                                        DataSetClientMedications_Temp.Tables["ClientMedicationInstructions"].Select(
                                            "ClientMedicationId=" + dr["ClientMedicationId"] + "and StrengthId=" +
                                            dr["StrengthId"]);
                                    foreach (DataRow dataRow in dataRowClientMedicationInstructions)
                                    {
                                        DataRow[] dataRowClientMedicationScriptDrugs =
                                            DataSetClientMedications_Temp.Tables["ClientMedicationScriptDrugs"].Select(
                                                "ClientMedicationInstructionId=" +
                                                dataRow["ClientMedicationInstructionId"]);
                                        foreach (DataRow dtRow in dataRowClientMedicationScriptDrugs)
                                        {
                                            dtRow["ClientMedicationScriptId"] = dr["ClientMedicationScriptId"];
                                        }
                                    }
                                }
                            }
                        }
                    }
                    DataSetClientMedications_Temp.Tables["ClientMedicationScripts"].Rows[0]["PharmacyId"] = _PharmacyId;

                    #region Insert SessionId in each table for Report View

                    if (DataSetClientMedications_Temp != null)
                    {
                        for (int i = 0; i < DataSetClientMedications_Temp.Tables["ClientMedications"].Rows.Count; i++)
                        {
                            DataSetClientMedications_Temp.Tables["ClientMedications"].Rows[i]["SessionId"] =
                                Session.SessionID;
                        }
                        for (int i = 0;
                             i < DataSetClientMedications_Temp.Tables["ClientMedicationInstructions"].Rows.Count;
                             i++)
                        {
                            DataSetClientMedications_Temp.Tables["ClientMedicationInstructions"].Rows[i]["SessionId"] =
                                Session.SessionID;
                        }
                        for (int i = 0;
                             i < DataSetClientMedications_Temp.Tables["ClientMedicationScripts"].Rows.Count;
                             i++)
                        {
                            DataSetClientMedications_Temp.Tables["ClientMedicationScripts"].Rows[i]["SessionId"] =
                                Session.SessionID;
                        }
                        for (int i = 0;
                             i < DataSetClientMedications_Temp.Tables["ClientMedicationScriptDrugs"].Rows.Count;
                             i++)
                        {
                            DataSetClientMedications_Temp.Tables["ClientMedicationScriptDrugs"].Rows[i]["SessionId"] =
                                Session.SessionID;
                        }
                        for (int i = 0;
                             i < DataSetClientMedications_Temp.Tables["ClientMedicationScriptDrugStrengths"].Rows.Count;
                             i++)
                        {
                            DataSetClientMedications_Temp.Tables["ClientMedicationScriptDrugStrengths"].Rows[i][
                                "SessionId"] = Session.SessionID;
                        }
                    }

                    #endregion

                    int _SureScriptsChangeRequestId = 0;
                    int ClientMedicationTempScriptId = 0;
                    string validChangeMedicationList = "";
                    Int32 _prescriberId = (HiddenFieldPrescriber.Value != "" && HiddenFieldPrescriber.Value != null)
                                            ? Convert.ToInt32(HiddenFieldPrescriber.Value)
                                            : (DropDownListPrescriber.SelectedValue != "")
                                                  ? Convert.ToInt32(DropDownListPrescriber.SelectedValue)
                                                  : -1;
                    ProcessScripts(0, _prescriberId, OrderingMethod, DataSetClientMedications_Temp);
                    DataSetTemp = ObjectTempClientMedication.UpdateTempDocuments(DataSetClientMedications_Temp, false,
                                                                                 Session.SessionID);
                    
                    Session["ShowFields_OTP_PWD"] = "N";
                    foreach (DataRow drClientMedicationScriptDrugs in DataSetClientMedications_Temp.Tables["ClientMedicationScriptDrugs"].Select(
                        "(ISNULL(RecordDeleted,'N')='N') and (DrugCategory='2' OR DrugCategory='3' OR DrugCategory='4' OR DrugCategory='5')",
                        " [ClientMedicationScriptId] DESC "))
                    {
                        foreach (
                            DataRow _dataRowClientMedicationScript in
                               DataSetClientMedications_Temp.Tables["ClientMedicationScripts"].Select(
                                    "ClientMedicationScriptId=" +
                                    drClientMedicationScriptDrugs["ClientMedicationScriptId"] +
                                    " and isnull(recorddeleted,'N') <> 'Y' and OrderingMethod='E'"))
                        {
                            Session["ShowFields_OTP_PWD"] = "Y";
                        }
                        
                    }
                if (DataSetTemp.Tables["ClientMedications"] != null) //Added by PranayB w.r.t MU
                    {
                        if ((_DrugsOrderMethod.ToUpper() == "CHANGEAPPROVALORDER" || _DrugsOrderMethod.ToUpper() == "APPROVEWITHCHANGESCHANGEORDER") && DataSetTemp.Tables["ClientMedications"].Rows.Count > 1)
                        {
                            ValidationMessage = "Multiple Drugs Cannot be Prescribed For the Change Order.";
                            return false;
                        }
                    }
                    DataSetTempNew = new DataSet();
                    Session["DataSetTempPrescribedClientMedications"] = DataSetTemp;
                    //---Call Sp scsp_SCValidateScript End over here
                    int _ClientMedicationTempScriptId = 0;
                    if (DataSetTemp.Tables["ClientMedicationScripts"].Rows.Count > 0)
                    {
                        for (int _Count = 0;
                             _Count < DataSetTemp.Tables["ClientMedicationScripts"].Rows.Count;
                             _Count++)
                        {
                            _ClientMedicationTempScriptId =
                                Convert.ToInt32(
                                    DataSetTemp.Tables["ClientMedicationScripts"].Rows[_Count][
                                        "ClientMedicationScriptId"].ToString());
                            char capNonControlled =
                                (ConfigurationManager.AppSettings["CapNonControlledSubstances"].ToUpper() == "TRUE")
                                    ? 'Y'
                                    : 'N';
                            char capControlled =
                                (ConfigurationManager.AppSettings["CapControlledSubstances"].ToUpper() == "TRUE")
                                    ? 'Y'
                                    : 'N';
                            string[] Queuedvalues = null;
                            DataSetTempValidationStatus = GetValidationStatus(_ClientMedicationTempScriptId,
                                                                              capNonControlled, capControlled, Queuedvalues);
                            if (DataSetTempValidationStatus != null)
                            {
                                if (DataSetTempValidationStatus.Tables.Count > 0)
                                {
                                    ValidationStatus =
                                        Convert.ToString(
                                            DataSetTempValidationStatus.Tables["ValidationStatus"].Rows[0][
                                                "ValidationStatus"]);
                                    if (ValidationStatus.ToUpper() == "INVALID")
                                    {
                                        ValidationMessage =
                                            Convert.ToString(
                                                DataSetTempValidationStatus.Tables["ValidationStatus"].Rows[0][
                                                    "ValidationMessage"]);
                                        return false;
                                    }
                                }
                            }
                            Session["ValidChangeMedicationScript"] = null;
                            if (_DrugsOrderMethod.ToUpper() == "CHANGEAPPROVALORDER")
                            {
                                ClientMedicationTempScriptId =
                                    Convert.ToInt32(
                                        DataSetTemp.Tables["ClientMedicationScripts"].Rows[_Count][
                                            "ClientMedicationScriptId"].ToString());
                                _SureScriptsChangeRequestId =
                                Convert.ToInt32(
                                    DataSetTemp.Tables["ClientMedicationScripts"].Rows[_Count][
                                        "SureScriptsChangeRequestId"].ToString());
                                validChangeMedicationList = ValidateChangeMedicationList(ClientMedicationTempScriptId, _SureScriptsChangeRequestId);
                                if (validChangeMedicationList.ToUpper() == "INVALID")
                                {
                                    DataSetTemp.Tables["ClientMedicationScripts"].Rows[_Count]["ScriptEventType"] = "C";
                                    Session["ValidChangeMedicationScript"] = "Invalid";
                                }
                            }
                        }
                    }
                    return true;
                }
                else
                {
                    return false;
                }

                //return true;//true should be returned only if document has been updated successfully reference Task #50 MM1.5
            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally
            {
                if (DataSetTempNew != null)
                {
                    DataSetTempNew.Dispose();
                }
                if (DataSetClientScriptActivities != null)
                {
                    DataSetClientScriptActivities.Dispose();
                }
                if (DataSetClientMedications_Temp != null)
                {
                    DataSetClientMedications_Temp.Dispose();
                }
                if (_DataTableClientMedications != null)
                {
                    _DataTableClientMedications.Dispose();
                }
                if (_DataSetClientSummary != null)
                {
                    _DataSetClientSummary.Dispose();
                }
                if (_DataTableClientMedicationInstructions != null)
                {
                    _DataTableClientMedicationInstructions.Dispose();
                }
                if (DataSetTempValidationStatus != null)
                {
                    DataSetTempValidationStatus.Dispose();
                }

                DataTableClientMedicationsNCSampleORStockDrugs = null;
                DataTableClientMedicationsNCNonSampleORStockDrugs = null;
                DataTableClientMedicationsC2SampleORStockDrugs = null;
                DataTableClientMedicationsC2NonSampleORStockDrugs = null;
                DataSetPharmacies = null;
                drSelectedPharmacy = null;
                if (dsTemp != null)
                {
                    dsTemp.Dispose();
                }
                DataRowsClientMedeicationsCategory2Drugs = null;
                DataRowsClientMedicationsNormalCategoryDrugs = null;
                DataRowsClientMedicationsControlledCategoryDrugs = null;
                _strPrintChartCopy = null;
                _strMedicationInstructionIds = null;
                if (DataSetTempLocal != null)
                {
                    DataSetTempLocal.Dispose();
                }
            }
        }

        /// <summary>
        ///     <Description>Used to generate script table row as per task#3305 </Description>
        ///     <Author>Pradeep </Author>
        /// </summary>
        /// <param name="SampleOrStock"></param>
        /// <param name="iMedicationRowsCount"></param>
        /// <param name="DataTableMedicationDetails"></param>
        /// <param name="NoOfRowsToBeCopied"></param>
        /// <param name="DrugCategory"></param>
        private void GenerateTempScriptsTableRows(char SampleOrStock, int iMedicationRowsCount,
                                                  DataTable DataTableMedicationDetails, int NoOfRowsToBeCopied,
                                                  string DrugCategory)
        {
            DataRow drClientMedicationScripts = null;
            var dcDataTableSureScriptsRefillRequests = new DataColumn[1];
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
                var _dsTemp = new DataSet();
                _dsTemp.Merge(DataSetClientMedications_Temp.Tables["ClientMedicationScriptDrugStrengths"]);
                if ((OrderingMethod == 'E' || OrderingMethod == 'P') && DrugCategory != "C2")
                {
                    DataRow[] drScriptDrugStrengths = null;
                    string sSelection = "";
                    foreach (DataRow drGeneralCategoryMedications in DataTableMedicationDetails.Rows)
                    {
                        sSelection = sSelection + (String.IsNullOrEmpty(sSelection) ? "" : ",") +
                                     drGeneralCategoryMedications["ClientMedicationId"];
                    }

                    if (!String.IsNullOrEmpty(sSelection))
                    {
                        drScriptDrugStrengths =
                            _dsTemp.Tables["ClientMedicationScriptDrugStrengths"].Select("ClientMedicationId in (" +
                                                                                         sSelection + ")");

                        for (short index = 0; index < drScriptDrugStrengths.Length; index++)
                        {
                            drClientMedicationScripts =
                                DataSetClientMedications_Temp.Tables["ClientMedicationScripts"].NewRow();
                            drClientMedicationScripts["Clientid"] = ((StreamlinePrinciple)Context.User).Client.ClientId;
                            drClientMedicationScripts["OrderingMethod"] = OrderingMethod;
                            drClientMedicationScripts["PharmacyId"] =
                                DataSetClientMedications_Temp1.Tables["ClientMedicationScripts"].Rows[0]["PharmacyId"];
                            drClientMedicationScripts["PrintDrugInformation"] = PrintDrugInformation;
                            drClientMedicationScripts["VerbalOrderReadBack"] = VerbalOrderReadBack;
                            drClientMedicationScripts["StaffLicenseDegreeId"] = (HiddenFieldDEANumber.Value != "" && HiddenFieldDEANumber.Value != null)
                                             ? HiddenFieldDEANumber.Value
                                             : (DropDownListDEANumber.SelectedValue != "")
                                                   ? DropDownListDEANumber.SelectedValue
                                                   : ""; 
                            drClientMedicationScripts["ScriptCreationDate"] = DateTime.Now;
                            drClientMedicationScripts["OrderingPrescriberId"] =
                                DataTableMedicationDetails.Rows[0]["PrescriberId"];
                            drClientMedicationScripts["OrderingPrescriberName"] =
                                DataTableMedicationDetails.Rows[0]["PrescriberName"];
                            drClientMedicationScripts["OrderDate"] =
                                DataSetClientMedications_Temp.Tables["ClientMedicationScripts"].Rows[0]["OrderDate"];
                            drClientMedicationScripts["LocationId"] = LocationId;
                            if (_DrugsOrderMethod == "Change" || _DrugsOrderMethod == "CHANGE")
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
                            if (((HiddenField)Parent.FindControl("HiddenFieldRedirectFrom")).Value.ToUpper() ==
                                "DASHBOARD" &&
                                (_DrugsOrderMethod.ToUpper() == "NEW ORDER" || _DrugsOrderMethod.ToUpper() == "REFILL"))
                            {
                                var hiddenFieldSureScriptRefillId =
                                    (HiddenField)Page.FindControl("HiddenFieldSureScriptRefillRequestId");
                                if (hiddenFieldSureScriptRefillId.Value != "")
                                    drClientMedicationScripts["SureScriptsRefillRequestId"] =
                                        Convert.ToInt32(hiddenFieldSureScriptRefillId.Value);
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
                                prescriberid =
                                    Convert.ToInt32(DataTableMedicationDetails.Rows[0]["PrescriberId"].ToString());
                            }

                            if (_Queue)
                            {
                                drClientMedicationScripts["WaitingPrescriberApproval"] = "Y";
                            }
                            else
                            {
                                drClientMedicationScripts["WaitingPrescriberApproval"] = DBNull.Value;
                            }
                            drClientMedicationScripts["RowIdentifier"] = Guid.NewGuid();
                            drClientMedicationScripts["CreatedBy"] =
                                ((StreamlineIdentity)Context.User.Identity).UserCode;
                            drClientMedicationScripts["CreatedDate"] = DateTime.Now;
                            drClientMedicationScripts["ModifiedBy"] =
                                ((StreamlineIdentity)Context.User.Identity).UserCode;
                            drClientMedicationScripts["ModifiedDate"] = DateTime.Now;
                            DataSetClientMedications_Temp.Tables["ClientMedicationScripts"].Rows.Add(
                                drClientMedicationScripts);

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

                                        ////mine
                                        //DataSetClientMedications_Temp.Tables["ClientMedicationScriptDrugs"].Rows[iDrug][
                                        //  "ClientMedicationScriptId"] =
                                        //  drClientMedicationScripts["ClientMedicationScriptId"];
                                    }
                                }
                            }
                        }
                    }
                }
                else
                {
                    drClientMedicationScripts = DataSetClientMedications_Temp.Tables["ClientMedicationScripts"].NewRow();
                    drClientMedicationScripts["Clientid"] = ((StreamlinePrinciple)Context.User).Client.ClientId;
                    drClientMedicationScripts["OrderingMethod"] = OrderingMethod;
                    if (OrderingMethod == 'F' || OrderingMethod == 'E')
                    {
                        drClientMedicationScripts["PharmacyId"] =
                            DataSetClientMedications_Temp1.Tables["ClientMedicationScripts"].Rows[0]["PharmacyId"];
                    }
                    else
                    {
                        drClientMedicationScripts["PharmacyId"] = DBNull.Value;
                    }
                    drClientMedicationScripts["PrintDrugInformation"] = PrintDrugInformation;
                    drClientMedicationScripts["VerbalOrderReadBack"] = VerbalOrderReadBack;
                    drClientMedicationScripts["StaffLicenseDegreeId"] = (HiddenFieldDEANumber.Value != "" && HiddenFieldDEANumber.Value != null)
                                             ? HiddenFieldDEANumber.Value
                                             : (DropDownListDEANumber.SelectedValue != "")
                                                   ? DropDownListDEANumber.SelectedValue
                                                   : ""; 
                    drClientMedicationScripts["ScriptCreationDate"] = DateTime.Now;
                    drClientMedicationScripts["OrderingPrescriberId"] =
                        DataTableMedicationDetails.Rows[0]["PrescriberId"];
                    drClientMedicationScripts["OrderingPrescriberName"] =
                        DataTableMedicationDetails.Rows[0]["PrescriberName"];
                    drClientMedicationScripts["OrderDate"] =
                        DataSetClientMedications_Temp.Tables["ClientMedicationScripts"].Rows[0]["OrderDate"];
                    if (DataSetClientMedications_Temp1.Tables["ClientMedicationScripts"].Rows[0]["LocationId"] !=
                        DBNull.Value)
                        drClientMedicationScripts["LocationId"] = LocationId;
                    else
                        drClientMedicationScripts["LocationId"] = DBNull.Value;
                    if (_DrugsOrderMethod == "Change" || _DrugsOrderMethod == "CHANGE")
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
                        var hiddenFieldSureScriptRefillId =
                            (HiddenField)Page.FindControl("HiddenFieldSureScriptRefillRequestId");
                        if (hiddenFieldSureScriptRefillId.Value != "")
                            drClientMedicationScripts["SureScriptsRefillRequestId"] =
                                Convert.ToInt32(hiddenFieldSureScriptRefillId.Value);
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

                    if (_Queue)
                    {
                        drClientMedicationScripts["WaitingPrescriberApproval"] = "Y";
                    }
                    else
                    {
                        drClientMedicationScripts["WaitingPrescriberApproval"] = DBNull.Value;
                    }
                    //Anuj ended over here
                    //Ended over here
                    drClientMedicationScripts["RowIdentifier"] = Guid.NewGuid();
                    drClientMedicationScripts["CreatedBy"] = ((StreamlineIdentity)Context.User.Identity).UserCode;
                    drClientMedicationScripts["CreatedDate"] = DateTime.Now;
                    drClientMedicationScripts["ModifiedBy"] = ((StreamlineIdentity)Context.User.Identity).UserCode;
                    drClientMedicationScripts["ModifiedDate"] = DateTime.Now;
                    DataSetClientMedications_Temp.Tables["ClientMedicationScripts"].Rows.Add(drClientMedicationScripts);
                }
                if (drClientMedicationScripts != null)
                {
                    scriptId = Convert.ToInt32(drClientMedicationScripts["ClientMedicationScriptId"]);
                }
                else
                {
                    var ex =
                        new Exception("Missing information in script, please click Change Order and modify the script");
                    ex.Data["CustomExceptionInformationMessage"] =
                        "Missing information in script, please click Change Order and modify the script";
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

                if (DrugCategory == "C2" || DrugCategory == "C3" || DrugCategory == "C4" || DrugCategory == "C5" ||
                    DrugCategory == "CT")
                    iloopCounter = ((NoOfRowsToBeCopied + 1) > iMedicationRowsCount)
                                       ? iMedicationRowsCount
                                       : (NoOfRowsToBeCopied + 1);
                else
                    iloopCounter = ((NoOfRowsToBeCopied + Maxnumberofmedsforscriptid) > iMedicationRowsCount)
                                       ? iMedicationRowsCount
                                       : (NoOfRowsToBeCopied + Maxnumberofmedsforscriptid);
                for (int i = NoOfRowsToBeCopied; i < iloopCounter; i++)
                {
                    _strMedicationInstructionIds = "";
                    dr = null;
                    dr = DataTableMedicationDetails.Rows[i];
                    DataRow[] drInstructions =
                        _DataTableClientMedicationInstructions.Select("ClientMedicationId=" + dr["ClientMedicationId"]);

                    foreach (DataRow dr1 in drInstructions)
                    {
                        if (_strMedicationInstructionIds == "")
                        {
                            _strMedicationInstructionIds += dr1["ClientMedicationInstructionId"].ToString();
                        }
                        else
                        {
                            _strMedicationInstructionIds += "," + dr1["ClientMedicationInstructionId"];
                        }
                    }

                    if (_strMedicationInstructionIds != "")
                    {
                        dataRowsClientMedicationScriptDrugs =
                            DataSetClientMedications_Temp.Tables["ClientMedicationScriptDrugs"].Select(
                                "ClientMedicationInstructionId in(" + _strMedicationInstructionIds + ")");
                    }
                    DataRow[] drScriptDrugStrengths =
                        _DataTableClientMedicationScriptDrugStrengths.Select("ClientMedicationId=" +
                                                                             dr["ClientMedicationId"]);
                    foreach (DataRow dr1 in drScriptDrugStrengths)
                    {
                        if (_strMedicationIds == "")
                        {
                            _strMedicationIds += dr1["ClientMedicationId"].ToString();
                        }
                        else
                        {
                            _strMedicationIds += "," + dr1["ClientMedicationId"];
                        }
                    }
                    if (_strMedicationIds != "")
                    {
                        dataRowsClientMedicationScriptDrugStrengths =
                            DataSetClientMedications_Temp.Tables["ClientMedicationScriptDrugStrengths"].Select(
                                "ClientMedicationId in(" + _strMedicationIds + ")");
                    }
                    if (dataRowsClientMedicationScriptDrugStrengths != null)
                    {
                        foreach (DataRow drMedicationScriptDrugStrengths in dataRowsClientMedicationScriptDrugStrengths)
                        {
                            if (OrderingMethod != 'E' && OrderingMethod != 'P')
                                drMedicationScriptDrugStrengths["ClientMedicationScriptId"] =
                                    drClientMedicationScripts["ClientMedicationScriptId"];
                        }
                    }
                    // #tr 20120318 variable not used.  int strengthId = 0;
                    foreach (DataRow drMedicationScriptDrugs in dataRowsClientMedicationScriptDrugs)
                    {
                        if (OrderingMethod != 'E' && OrderingMethod != 'P')
                            drMedicationScriptDrugs["ClientMedicationScriptId"] =
                                drClientMedicationScripts["ClientMedicationScriptId"];
                        drMedicationScriptDrugs["SpecialInstructions"] = dr["SpecialInstructions"];
                    }


                    if (_DrugsOrderMethod == "Refill" || _DrugsOrderMethod == "REFILL")
                    {
                        using (
                            var DataViewClientMedicationScriptDrugs =
                                new DataView(DataSetClientMedications_Temp.Tables["ClientMedicationScriptDrugs"],
                                             "ClientMedicationInstructionId in(" + _strMedicationInstructionIds + ")",
                                             "EndDate Desc", DataViewRowState.CurrentRows))
                        {
                            DataRow DataRowClientMedication =
                                DataSetClientMedications_Temp.Tables["ClientMedications"].Rows.Find(
                                    dr["ClientMedicationId"]);
                            DataRowClientMedication["MedicationEndDate"] =
                                DataViewClientMedicationScriptDrugs[0]["EndDate"];
                        }
                    }
                }
                for (int i = 0; i < DataTableMedicationDetails.Rows.Count; i++)
                {
                    if (_strMedicationIds == "")
                    {
                        _strMedicationIds += DataTableMedicationDetails.Rows[i]["ClientMedicationId"].ToString();
                    }
                    else
                    {
                        _strMedicationIds += "," + DataTableMedicationDetails.Rows[i]["ClientMedicationId"];
                    }
                }

                if (_strMedicationIds != "")
                {
                    dataRowsClientMedicationScriptDrugStrengths =
                        DataSetClientMedications_Temp.Tables["ClientMedicationScriptDrugStrengths"].Select(
                            "ClientMedicationId in(" + _strMedicationIds + ")");
                }
                if (dataRowsClientMedicationScriptDrugStrengths != null)
                {
                    foreach (DataRow drMedicationScriptDrugStrengths in dataRowsClientMedicationScriptDrugStrengths)
                    {
                        for (int index = 0; index < DataTableMedicationDetails.Rows.Count; index++)
                        {
                            if (Convert.ToString(DataTableMedicationDetails.Rows[index]["SpecialInstructions"]) != "")
                                drMedicationScriptDrugStrengths["SpecialInstructions"] =
                                    DataTableMedicationDetails.Rows[index]["SpecialInstructions"];
                            else
                                drMedicationScriptDrugStrengths["SpecialInstructions"] = DBNull.Value;
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
                    ex.Data["CustomExceptionInformation"] = "###Source Event Name -DocumentUpdateTempDataSet()";
                else
                {
                    ex.Data["CustomExceptionInformation"] = "";
                }
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;

                LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);

                ScriptManager.RegisterStartupScript(Label1, Label1.GetType(), ClientID,
                                                    "ClientMedicationOrder.ShowError('" + strErrorMessage + "', true);",
                                                    true);
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

        /// <summary>
        ///     <Description>Used to get alowed ordering method</Description>
        ///     <Author>Pradeep</Author>
        ///     <CreatedOn>24 Dec 2010</CreatedOn>
        /// </summary>
        /// <param name="ClientMedicationScriptId"></param>
        /// <returns></returns>
        public DataSet GetOrderingMethodAllowed(int ClientMedicationScriptId)
        {
            ClientMedication objectClientMedications = null;
            DataSet DataSetTempOrderingMethodAllowed = null;
            try
            {
                objectClientMedications = new ClientMedication();
                DataSetTempOrderingMethodAllowed =
                    objectClientMedications.GetOrderingMethodAllowed(ClientMedicationScriptId);
                return DataSetTempOrderingMethodAllowed;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                if (DataSetTempOrderingMethodAllowed != null)
                {
                    DataSetTempOrderingMethodAllowed.Dispose();
                }
                objectClientMedications = null;
            }
        }

        /// <summary>
        ///     <Description>Used to get validation status of ChangeMedicationList</Description>
        ///     <Author>PranayB</Author>
        ///     <CreatedOn>20 OCT 2017</CreatedOn>
        /// </summary>
        /// <param name="ClientMedicationScriptId"></param>
        /// <param name="SureScriptsChangeRequestId"></param>
        /// <returns></returns>
        private string ValidateChangeMedicationList(int ClientMedicationScriptId, int SureScriptsChangeRequestId)
        {
            ClientMedication objectClientMedications = null;
            String validChangeMedicationList = null;
            try
            {
                objectClientMedications = new ClientMedication();
                validChangeMedicationList = objectClientMedications.ValidateChangeMedicationList(ClientMedicationScriptId,
                                                                                    SureScriptsChangeRequestId);
                return validChangeMedicationList;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                objectClientMedications = null;

            }
        }






        /// <summary>
        ///     <Description>Used to get validation status of  client medication script</Description>
        ///     <Author>Pradeep</Author>
        ///     <CreatedOn>24 Dec 2010</CreatedOn>
        /// </summary>
        /// <param name="ClientMedicationScriptId"></param>
        /// <returns></returns>
        private DataSet GetValidationStatus(int ClientMedicationScriptId, char capNonControlled, char capControlled, string[] Queuedvalues)
        {
            ClientMedication objectClientMedications = null;
            DataSet DataSetValidateStatus = null;
            try
            {
                objectClientMedications = new ClientMedication();
                DataSetValidateStatus = objectClientMedications.GetValidationStatus(ClientMedicationScriptId,
                                                                                    capNonControlled, capControlled, Queuedvalues);
                return DataSetValidateStatus;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                objectClientMedications = null;
                if (DataSetValidateStatus != null)
                {
                    DataSetValidateStatus.Dispose();
                }
            }
        }

        #endregion

        #region--Code written by Pradeep on 9 March2011 as per task#3331

        /// <summary>
        ///     <Description>Used to enable/disable controls as per task#3331</Description>
        ///     <Author>Pradeep</Author>
        ///     <CreatedOn>9 March 2011</CreatedOn>
        /// </summary>
        private void DisableEnableControl()
        {
            try
            {
                RedirectFrom = (HiddenField)Page.FindControl("HiddenFieldRedirectFrom");
                ClickedImage = (HiddenField)Page.FindControl("HiddenFieldClickedImage");
                if (RedirectFrom != null && ClickedImage != null)
                {
                    if (RedirectFrom.Value.Trim().ToUpper() == "DASHBOARD" &&
                        (ClickedImage.Value.Trim().ToUpper() == "APPROVED" ||
                         ClickedImage.Value.Trim().ToUpper() == "APPROVEDWITHCHANGES"))
                    {
                        TextBoxSpecialInstructions.Enabled = false;
                        TextBoxComments.Enabled = false;
                        CheckboxIncludeOnPrescription.Disabled = true;
                        CheckBoxDispense.Disabled = true;
                        if (OrderType.Value == "APPROVEWITHCHANGESCHANGEORDER" || OrderType.Value == "CHANGEAPPROVALORDER")
                        {
                            TextBoxSpecialInstructions.Enabled = true;
                            TextBoxComments.Enabled = true;
                            CheckboxIncludeOnPrescription.Disabled = false;
                            CheckBoxDispense.Disabled = false;
                        }
                    }
                    
                    else
                    {
                        TextBoxSpecialInstructions.Enabled = true;
                        TextBoxComments.Enabled = true;
                        CheckboxIncludeOnPrescription.Disabled = false;
                        CheckBoxDispense.Disabled = false;
                    }
                }
              
                 
              else
                {
                    TextBoxSpecialInstructions.Enabled = true;
                    TextBoxComments.Enabled = true;
                    CheckboxIncludeOnPrescription.Disabled = false;
                    CheckBoxDispense.Disabled = false;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        #endregion

        #region CreateControls

        private void createControls()
        {
            try
            {
                CommonFunctions.Event_Trap(this);

                CreateLabelRow();
                var tableControls = new Table();
                tableControls.Width = new Unit(100, UnitType.Percentage);
                tableControls.ID = "tableMedicationOrder";
                tableControls.Attributes.Add("tableMedicationOrder", "true");
                string myscript = "<script id='MedicationOrderScript' type='text/javascript'>";
                myscript += "function InitializeComponents(){;";
                //myscript +=
                //    "$create(Streamline.SmartClient.UI.TextBox, {'ignoreEnterKey':true,DateTime:true}, {'onBlur':ClientMedicationOrder.ManipulateRowValues},{},$get('" +
                //    TextBoxOrderDate.ClientID + "'));";
                //myscript +=
                //    "$create(Streamline.SmartClient.UI.TextBox, {'ignoreEnterKey':true,DateTime:true}, {'onBlur':ClientMedicationOrder.ManipulateRowValues},{},$get('" +
                //    TextBoxStartDate.ClientID + "'));";
                for (int _RowCount = 0; _RowCount < 2; _RowCount++)
                {
                    tableControls.Rows.Add(CreateMedicationRow(_RowCount, ref myscript));
                }
                myscript += "}</script>";
                PlaceHolder.Controls.Add(tableControls);
                ScriptManager.RegisterStartupScript(PlaceHolder, PlaceHolder.GetType(), PlaceHolder.ClientID, myscript,
                                                    false);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "";
                else
                    ex.Data["CustomExceptionInformation"] = "";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = "";
                LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);
            }
            finally
            {
            }
        }

        private void CreateLabelRow()
        {
            try
            {
                CommonFunctions.Event_Trap(this);
                var _Table = new Table();
                _Table.Width = new Unit(100, UnitType.Percentage);
                var _TableRow = new TableRow();
                var _TableCell0 = new TableCell();
                var _TableCell1 = new TableCell();
                var _TableCell1b = new TableCell();
                var _TableCell2 = new TableCell();
                var _TableCell3 = new TableCell();
                var _TableCell4 = new TableCell();
                var _TableCell5 = new TableCell();
                var _TableCell6 = new TableCell();
                var _TableCell7 = new TableCell();
                var _TableCell8 = new TableCell();
                var _TableCell8_5 = new TableCell();
                var _TableCell9 = new TableCell();
                var _TableCell10 = new TableCell();
                var _TableCell11 = new TableCell();
                var _TableCell12 = new TableCell();
                var _TableCell13 = new TableCell();
                var _TableCell14 = new TableCell();
                var _TableCell15 = new TableCell();

                _Table.ID = "Table";

                var _lblDeleteRow = new Label();
                _lblDeleteRow.ID = "Delete";
                _lblDeleteRow.Height = 20;
                _lblDeleteRow.Visible = true;
                _lblDeleteRow.Text = "";

                var _lblStrength = new Label();
                _lblStrength.ID = "Strength";
                _lblStrength.Height = 20;
                _lblStrength.Visible = true;
                _lblStrength.Text = "Strength";

                var _lblQuantity = new Label();
                _lblQuantity.ID = "Quantity";
                _lblQuantity.Height = 20;
                _lblQuantity.Visible = true;
                _lblQuantity.Text = "Dose";

                var _lblUnit = new Label();
                _lblUnit.ID = "Unit";
                _lblUnit.Height = 20;
                _lblUnit.Visible = true;
                _lblUnit.Text = "Unit";

                var _lblSchedule = new Label();
                _lblSchedule.ID = "Schedule";
                _lblSchedule.Height = 20;
                _lblSchedule.Visible = true;
                _lblSchedule.Text = "Directions";

                var _lblStartDate = new Label();
                _lblStartDate.ID = "StartDate";
                _lblStartDate.Height = 20;
                _lblStartDate.Visible = true;
                _lblStartDate.Text = "Rx Start";

                var _lblStartImg = new Label();
                _lblStartImg.ID = "StartImg";
                _lblStartImg.Height = 20;
                _lblStartImg.Visible = true;
                _lblStartImg.Text = "";

                var _lblDays = new Label();
                _lblDays.ID = "Days";
                _lblDays.Height = 20;
                _lblDays.Visible = true;
                _lblDays.Text = "Days";

                var _lblPharma = new Label();
                _lblPharma.ID = "Pharm";
                _lblPharma.Height = 20;
                _lblPharma.Visible = true;
                _lblPharma.Text = "Dispense Qty";

                var _lblPotencyUnitCode = new Label();
                _lblPotencyUnitCode.ID = "PotencyUnitCode";
                _lblPotencyUnitCode.Height = 20;
                _lblPotencyUnitCode.Visible = true;
                _lblPotencyUnitCode.Text = "Potency Unit";

                var _lblSample = new Label();
                _lblSample.ID = "Sample";
                _lblSample.Height = 20;
                _lblSample.Visible = true;
                _lblSample.Text = "Sample";

                var _lblStock = new Label();
                _lblStock.ID = "Stock";
                _lblStock.Height = 20;
                _lblStock.Visible = true;
                _lblStock.Text = "Stock";

                var _lblRefills = new Label();
                _lblRefills.ID = "Refills";
                _lblRefills.Height = 20;
                _lblRefills.Visible = true;
                _lblRefills.Text = "Refills";

                 var _ImgRefills = new HtmlImage();
                _ImgRefills.ID = "ImgRefills";
                _ImgRefills.Src = "~/App_Themes/Includes/Images/Info1.gif";
                _ImgRefills.Attributes.Add("Title", "For Schedule II medications, each refill entered will be submitted to the pharmacy as a separate script.");
                _ImgRefills.Align = "Center";
                _ImgRefills.Height = 15;

               
                var _lblEndDate = new Label();
                _lblEndDate.ID = "EndDate";
                _lblEndDate.Height = 20;
                _lblEndDate.Visible = true;
                _lblEndDate.Text = "Rx End";

                var _lblEndImg = new Label();

                _TableCell0.Controls.Add(_lblDeleteRow);
                _TableCell0.Width = new Unit(2, UnitType.Percentage);
                _TableCell1.Controls.Add(_lblStrength);
                _TableCell1.Width = new Unit(16, UnitType.Percentage);
                if (enableDisabled(Permissions.Formulary) != "Disabled")
                {
                    _TableCell1b.Controls.Add(new Label { Text = "" });
                    _TableCell1b.Width = new Unit(1, UnitType.Percentage);
                }
                _TableCell2.Controls.Add(_lblQuantity);
                _TableCell2.Width = new Unit(5, UnitType.Percentage);
                _TableCell3.Controls.Add(_lblUnit);
                _TableCell3.Width = new Unit(6, UnitType.Percentage);
                _TableCell4.Controls.Add(_lblSchedule);
                _TableCell4.Width = new Unit(14, UnitType.Percentage);
                _TableCell5.Controls.Add(_lblStartDate);
                _TableCell5.Width = new Unit(7, UnitType.Percentage);
                _TableCell6.Controls.Add(_lblStartImg);
                _TableCell6.Width = new Unit(3, UnitType.Percentage);
                _TableCell7.Controls.Add(_lblDays);
                _TableCell7.Width = new Unit(4, UnitType.Percentage);
                _TableCell8.Controls.Add(_lblPharma);
                _TableCell8.Width = new Unit(9, UnitType.Percentage);
                _TableCell8_5.Controls.Add(_lblPotencyUnitCode);
                _TableCell8_5.Width = new Unit(9, UnitType.Percentage);
                _TableCell9.Controls.Add(_lblRefills);
                _TableCell9.Controls.Add(_ImgRefills);
                _TableCell9.Width = new Unit(5, UnitType.Percentage);
                _TableCell10.Controls.Add(_lblSample);
                _TableCell10.Width = new Unit(6, UnitType.Percentage);
                _TableCell11.Controls.Add(_lblStock);
                _TableCell11.Width = new Unit(5, UnitType.Percentage);
                _TableCell12.Controls.Add(_lblEndDate);
                _TableCell12.Width = new Unit(8, UnitType.Percentage);
                _TableCell13.Controls.Add(_lblEndImg);
                _TableCell13.Width = new Unit(0, UnitType.Percentage);
                _TableCell14.Width = new Unit(0, UnitType.Percentage);
                _TableCell15.Width = new Unit(0, UnitType.Percentage);
                _TableRow.Controls.Add(_TableCell0);
                _TableRow.Controls.Add(_TableCell1);
                _TableRow.Controls.Add(_TableCell1b);
                _TableRow.Controls.Add(_TableCell2);
                _TableRow.Controls.Add(_TableCell3);
                _TableRow.Controls.Add(_TableCell4);
                _TableRow.Controls.Add(_TableCell5);
                _TableRow.Controls.Add(_TableCell6);
                _TableRow.Controls.Add(_TableCell7);
                _TableRow.Controls.Add(_TableCell8);
                _TableRow.Controls.Add(_TableCell8_5);
                _TableRow.Controls.Add(_TableCell9);
                _TableRow.Controls.Add(_TableCell10);
                _TableRow.Controls.Add(_TableCell11);
                _TableRow.Controls.Add(_TableCell12);
                _TableRow.Controls.Add(_TableCell13);
                _TableRow.Controls.Add(_TableCell14);
                _TableRow.Controls.Add(_TableCell15);
                _Table.CssClass = "LabelUnderlineFontNew";
                _Table.Controls.Add(_TableRow);
                PlaceLabel.Controls.Add(_Table);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "";
                else
                    ex.Data["CustomExceptionInformation"] = "";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = "";
                throw (ex);
            }
        }

        private TableRow CreateMedicationRow(int rowIndex, ref string myscript)
        {
            try
            {
                var textboxButtonValue = Page.FindControl("txtButtonValue") as HiddenField;

                CommonFunctions.Event_Trap(this);
                var _Table = new Table();
                _Table.Width = new Unit(100, UnitType.Percentage);
                var _TableRow = new TableRow();
                _TableRow.ID = "TableMedicationRow_" + rowIndex;
                var _TableCell0 = new TableCell();
                var _TableCell1 = new TableCell();
                var _TableCell1b = new TableCell();
                var _TableCell2 = new TableCell();
                var _TableCell3 = new TableCell();
                var _TableCell4 = new TableCell();
                var _TableCell5 = new TableCell();
                var _TableCell6 = new TableCell();
                var _TableCell7 = new TableCell();
                var _TableCell8 = new TableCell();
                var _TableCell8_5 = new TableCell();
                var _TableCell9 = new TableCell();
                var _TableCell10 = new TableCell();
                var _TableCell11 = new TableCell();
                var _TableCell12 = new TableCell();
                var _TableCell13 = new TableCell();
                var _TableCell14 = new TableCell();
                var _TableCell15 = new TableCell();
                var _TableCell16 = new TableCell();

                _Table.ID = "TableMedication" + rowIndex;

                var _ImgDeleteRow = new HtmlImage();
                _ImgDeleteRow.ID = "ImageDelete" + rowIndex;
                _ImgDeleteRow.Src = "~/App_Themes/Includes/Images/deleteIcon.gif";
                _ImgDeleteRow.Attributes.Add("class", "handStyle");
                //if (textboxButtonValue != null && textboxButtonValue.Value == "Refill")
                //    _ImgDeleteRow.Disabled = true;

                myscript += "var Imagecontext" + rowIndex + ";";
                myscript += "var ImageclickCallback" + rowIndex + " =";
                myscript += " Function.createCallback(ClientMedicationOrder.DeleteRow , Imagecontext" + rowIndex + ");";
                myscript += "$addHandler($get('" + ClientID + ClientIDSeparator + _ImgDeleteRow.ClientID +
                            "'), 'click', ImageclickCallback" + rowIndex + ");";

                var _DropDownListStrength = new DropDownList();
                _DropDownListStrength.Width = new Unit(100, UnitType.Percentage);
                _DropDownListStrength.Height = 20;

                //if (textboxButtonValue != null && textboxButtonValue.Value == "Refill")
                //    _DropDownListStrength.Enabled = false;
                _DropDownListStrength.EnableViewState = true;
                _DropDownListStrength.ID = "DropDownListStrength" + rowIndex;

                var _ImgFormulary = new System.Web.UI.WebControls.Image();
                _ImgFormulary.ID = "ImageFormulary" + rowIndex;
                _ImgFormulary.ImageUrl = "~/App_Themes/Includes/Images/formularyFont.gif";
                _ImgFormulary.Attributes.Add("onClick", "ClientMedicationOrder.FormularyCheck(this);");
                _ImgFormulary.Attributes.Add("disabled", "disabled");
                _ImgFormulary.Attributes.Add("class", "handStyle");
                if (enableDisabled(Permissions.Formulary) == "Disabled")
                {
                    _ImgFormulary.Style.Add("display", "none");
                }
                else
                {
                    _TableCell1b.Width = new Unit(18, UnitType.Pixel);
                }

                var _txtQuantity = new TextBox();
                _txtQuantity.BackColor = Color.White;
                _txtQuantity.MaxLength = 4;


                //if (textboxButtonValue != null && textboxButtonValue.Value == "Refill")
                //    _txtQuantity.Enabled = false;
                _txtQuantity.ID = "TextBoxQuantity" + rowIndex;
                _txtQuantity.Width = new Unit(96, UnitType.Percentage);
                _txtQuantity.Height = 20;
                _txtQuantity.Visible = true;
                _txtQuantity.Style["text-align"] = "Right";
                myscript +=
                    "$create(Streamline.SmartClient.UI.TextBox, {'ignoreEnterKey':true,Decimal:true}, {'onBlur':ClientMedicationOrder.ManipulateRowValues},{},$get('" +
                    ClientID + ClientIDSeparator + _txtQuantity.ClientID + "'));";

                var _DropDownListUnit = new DropDownList();
                _DropDownListUnit.Width = new Unit(100, UnitType.Percentage);
                _DropDownListUnit.Height = 20;
                //if (textboxButtonValue != null && textboxButtonValue.Value == "Refill")
                //    _DropDownListUnit.Enabled = false;
                _DropDownListUnit.ID = "DropDownListUnit" + rowIndex;

                var _DropDownListSchedule = new DropDownList();
                _DropDownListSchedule.Width = new Unit(100, UnitType.Percentage);
                _DropDownListSchedule.Height = 20;
                //if (textboxButtonValue != null && textboxButtonValue.Value == "Refill")
                //    _DropDownListSchedule.Enabled = false;
                _DropDownListSchedule.ID = "DropDownListSchedule" + rowIndex;

                var _txtStartDate = new TextBox();
                _txtStartDate.BackColor = Color.White;
                _txtStartDate.ID = "TextBoxStartDate" + rowIndex;
                _txtStartDate.Width = new Unit(96, UnitType.Percentage);
                _txtStartDate.Height = 20;
                _txtStartDate.Visible = true;
                myscript +=
                    "$create(Streamline.SmartClient.UI.TextBox, {'ignoreEnterKey':true,DateTime:true}, {'onBlur':ClientMedicationOrder.ManipulateRowValues},{},$get('" +
                    ClientID + ClientIDSeparator + _txtStartDate.ClientID + "'));";

                var _ImgStartDate = new System.Web.UI.WebControls.Image();
                _ImgStartDate.ID = "ImageStartDate" + rowIndex;
                _ImgStartDate.ImageUrl = "~/App_Themes/Includes/Images/calender_grey.gif";
                _ImgStartDate.Attributes.Add("onClick",
                                             "ClientMedicationOrder.CalShow( this,'" + ClientID + ClientIDSeparator +
                                             _txtStartDate.ClientID + "')");
                _ImgStartDate.Attributes.Add("onmouseover",
                                             "ClientMedicationOrder.CalShow( this,'" + ClientID + ClientIDSeparator +
                                             _txtStartDate.ClientID + "')");

                var _txtDays = new TextBox();
                _txtDays.BackColor = Color.White;
                _txtDays.MaxLength = 4;
                _txtDays.ID = "TextBoxDays" + rowIndex;
                _txtDays.Width = new Unit(96, UnitType.Percentage);
                _txtDays.Height = 18;
                _txtDays.Visible = true;
                _txtDays.Attributes.Add("MedicationDays",
                                        ((StreamlineIdentity)(Context.User.Identity)).MedicationDaysDefault.ToString());
                _txtDays.Style["text-align"] = "Right";
                myscript +=
                    "$create(Streamline.SmartClient.UI.TextBox, {'ignoreEnterKey':true,Numeric:true}, {'onBlur':ClientMedicationOrder.ManipulateRowValues},{},$get('" +
                    ClientID + ClientIDSeparator + _txtDays.ClientID + "'));";

                string _comboBoxPharmacyTextDivString = "<div id='ComboBoxPharmacyDDDiv_" + rowIndex +
                                                        "' style='border: solid 1px #7b9ebd; height:18px; position:relative; overflow:hidden;' onclick=\"ClientMedicationOrder.onClickPharmacyComboList(this, '#ComboBoxPharmacyDDList_" +
                                                        rowIndex +
                                                        "');\"><input type='text' id='ComboBoxPharmacyDD_" + rowIndex +
                                                        "' value='' style='border:none; width: 137px; height:18px; position:absolute; left:0;' onchange=\"ClientMedicationOrder.onChangePharmacyComboList(this, '#ComboBoxPharmacyDDList_" +
                                                        rowIndex +
                                                        "');\" onkeydown=\"ClientMedicationOrder.onKeyDownPharmacyComboList(event, '#ComboBoxPharmacyDDList_" +
                                                        rowIndex +
                                                        "');\" onBlur=\"ClientMedicationOrder.onBlurPharmacyComboList(this, '#ComboBoxPharmacyDDList_" +
                                                        rowIndex +
                                                        "');\" /><div style=' position:absolute; right:0;; height:18px; width:19px;' class='ComboBoxDrugDDImage'>&nbsp;</div></div>";

                var _comboBoxPharmacyTextDiv = new LiteralControl(_comboBoxPharmacyTextDivString);

                string _comboBoxPharmacyDDListString =
                    @"<div style='display:none; white-space:nowrap;' id='ComboBoxPharmacyDDList_" + rowIndex +
                    "' isempty='true' caller='ComboBoxPharmacyDD_" + rowIndex +
                    "' class='combolist' onclick=\"ClientMedicationOrder.onSelectedPharmacyComboList(event, this);\"></div>";

                var _comboBoxPharmacyDDList = new LiteralControl(_comboBoxPharmacyDDListString);

                var _DropDownListPotencyUnitCode = new DropDownList();
                _DropDownListPotencyUnitCode.Width = new Unit(100, UnitType.Percentage);
                _DropDownListPotencyUnitCode.Height = 20;
                _DropDownListPotencyUnitCode.ID = "_DropDownListPotencyUnitCode" + rowIndex;
                _DropDownListPotencyUnitCode.Attributes.Add("class", "ddlist");

                var _txtSample = new TextBox();
                _txtSample.BackColor = Color.White;
                _txtSample.MaxLength = 4;
                _txtSample.ID = "TextBoxSample" + rowIndex;
                _txtSample.Width = new Unit(96, UnitType.Percentage);
                _txtSample.Height = 20;
                _txtSample.Visible = true;
                _txtSample.Style["text-align"] = "Right";
                myscript +=
                    "$create(Streamline.SmartClient.UI.TextBox, {'ignoreEnterKey':true,Decimal:true}, {'onBlur':ClientMedicationOrder.ManipulateRowValues},{},$get('" +
                    ClientID + ClientIDSeparator + _txtSample.ClientID + "'));";

                var _txtStock = new TextBox();
                _txtStock.BackColor = Color.White;
                _txtStock.MaxLength = 4;
                _txtStock.ID = "TextBoxStock" + rowIndex;
                _txtStock.Width = new Unit(96, UnitType.Percentage);
                _txtStock.Height = 20;
                _txtStock.Visible = true;
                _txtStock.Style["text-align"] = "Right";
                myscript +=
                    "$create(Streamline.SmartClient.UI.TextBox, {'ignoreEnterKey':true,Decimal:true}, {'onBlur':ClientMedicationOrder.ManipulateRowValues},{},$get('" +
                    ClientID + ClientIDSeparator + _txtStock.ClientID + "'));";

                var _txtRefills = new TextBox();
                _txtRefills.BackColor = Color.White;
                _txtRefills.MaxLength = 2;
                _txtRefills.ID = "TextBoxRefills" + rowIndex;
                _txtRefills.Width = new Unit(96, UnitType.Percentage);
                _txtRefills.Height = 20;
                _txtRefills.Visible = true;
                _txtRefills.Style["text-align"] = "Right";
                myscript +=
                    "$create(Streamline.SmartClient.UI.TextBox, {'ignoreEnterKey':true,Decimal:true}, {'onBlur':ClientMedicationOrder.ManipulateRowValues},{},$get('" +
                    ClientID + ClientIDSeparator + _txtRefills.ClientID + "'));";

                var _txtEndDate = new TextBox();
                _txtEndDate.ID = "TextBoxEndDate" + rowIndex;
                _txtEndDate.Width = new Unit(96, UnitType.Percentage);
                _txtEndDate.Height = 20;
                _txtEndDate.Enabled = true;
                _txtEndDate.Style["text-align"] = "Right";
                myscript +=
                    "$create(Streamline.SmartClient.UI.TextBox, {'ignoreEnterKey':true,DateTime:true}, {},{},$get('" +
                    ClientID + ClientIDSeparator + _txtEndDate.ClientID + "'));";

                var _RowIdentifier = new Label();
                _RowIdentifier.ID = "RowIdentifier" + rowIndex;

                var _hiddenstrengthRowIdentifier = new HiddenField();
                _hiddenstrengthRowIdentifier.ID = "HiddenRowIdentifier" + rowIndex;

                var _hiddenAutoCalcAllowed = new HiddenField();
                _hiddenAutoCalcAllowed.ID = "HiddenFieldAutoCalcAllowed" + rowIndex;

                HiddenField _noOfDaysOfWeek = new HiddenField();
                _noOfDaysOfWeek.ID = "noOfDaysOfWeek" + rowIndex;

                _TableCell0.Controls.Add(_ImgDeleteRow);
                _TableCell0.Width = new Unit(2, UnitType.Percentage);
                _TableCell1.Controls.Add(_DropDownListStrength);
                _TableCell1.Width = new Unit(16, UnitType.Percentage);
                _TableCell1b.Controls.Add(_ImgFormulary);
                _TableCell1b.Width = new Unit(1, UnitType.Percentage);
                _TableCell2.Controls.Add(_txtQuantity);
                _TableCell2.Width = new Unit(5, UnitType.Percentage);
                _TableCell3.Controls.Add(_DropDownListUnit);
                _TableCell3.Width = new Unit(6, UnitType.Percentage);
                _TableCell4.Controls.Add(_DropDownListSchedule);
                _TableCell4.Width = new Unit(14, UnitType.Percentage);
                _TableCell5.Controls.Add(_txtStartDate);
                _TableCell5.Width = new Unit(7, UnitType.Percentage);
                _TableCell6.Controls.Add(_ImgStartDate);
                _TableCell6.Width = new Unit(3, UnitType.Percentage);
                _TableCell7.Controls.Add(_txtDays);
                _TableCell7.Width = new Unit(4, UnitType.Percentage);
                _TableCell8.Controls.Add(_comboBoxPharmacyTextDiv);
                _TableCell8.Controls.Add(_comboBoxPharmacyDDList);
                _TableCell8.Width = new Unit(9, UnitType.Percentage);
                _TableCell8_5.Controls.Add(_DropDownListPotencyUnitCode);
                _TableCell8_5.Width = new Unit(9, UnitType.Percentage);
                _TableCell9.Controls.Add(_txtRefills);
                _TableCell9.Width = new Unit(5, UnitType.Percentage);
                _TableCell10.Controls.Add(_txtSample);
                _TableCell10.Width = new Unit(6, UnitType.Percentage);
                _TableCell11.Controls.Add(_txtStock);
                _TableCell11.Width = new Unit(5, UnitType.Percentage);
                _TableCell12.Controls.Add(_txtEndDate);
                _TableCell12.Width = new Unit(8, UnitType.Percentage);
                _TableCell13.Controls.Add(_RowIdentifier);
                _TableCell13.Width = new Unit(0, UnitType.Percentage);
                _TableCell14.Controls.Add(_hiddenAutoCalcAllowed);
                _TableCell14.Width = new Unit(0, UnitType.Percentage);
                _TableCell15.Controls.Add(_hiddenstrengthRowIdentifier);
                _TableCell15.Width = new Unit(0, UnitType.Percentage);
                _TableCell16.Controls.Add(_noOfDaysOfWeek);
                _TableCell16.Width = new Unit(0, UnitType.Percentage);

                _TableRow.Controls.Add(_TableCell0);
                _TableRow.Controls.Add(_TableCell1);
                _TableRow.Controls.Add(_TableCell1b);
                _TableRow.Controls.Add(_TableCell2);
                _TableRow.Controls.Add(_TableCell3);
                _TableRow.Controls.Add(_TableCell4);
                _TableRow.Controls.Add(_TableCell5);
                _TableRow.Controls.Add(_TableCell6);
                _TableRow.Controls.Add(_TableCell7);
                _TableRow.Controls.Add(_TableCell8);
                _TableRow.Controls.Add(_TableCell8_5);
                _TableRow.Controls.Add(_TableCell9);
                _TableRow.Controls.Add(_TableCell10);
                _TableRow.Controls.Add(_TableCell11);
                _TableRow.Controls.Add(_TableCell12);
                _TableRow.Controls.Add(_TableCell13);
                _TableRow.Controls.Add(_TableCell14);
                _TableRow.Controls.Add(_TableCell15);
                _TableRow.Controls.Add(_TableCell16);

                _DropDownListStrength.Attributes.Add("onchange",
                                                     "ClientMedicationOrder.onStrengthChange(this,'" + ClientID +
                                                     ClientIDSeparator + _DropDownListUnit.ClientID + "',null,'" +
                                                     ClientID + ClientIDSeparator + _txtDays.ClientID + "','" +
                                                     TextBoxStartDate.ClientID + "','" + ClientID + ClientIDSeparator +
                                                     _txtStartDate.ClientID + "','" + ClientID + ClientIDSeparator +
                                                     _txtQuantity.ClientID + "','" + rowIndex + "')");
                _DropDownListUnit.Attributes.Add("onchange", "ClientMedicationOrder.onUnitChange(" + rowIndex + ")");
                _DropDownListUnit.Attributes.Add("onBlur", "ClientMedicationOrder.onUnitBlur(this)");
                _DropDownListSchedule.Attributes.Add("onchange",
                                                     "ClientMedicationOrder.onScheduleChange(" + rowIndex + ")");
                _DropDownListSchedule.Attributes.Add("onBlur", "ClientMedicationOrder.onScheduleBlur(this)");
                DropDownListDxPurpose.Attributes.Add("onchange", "ClientMedicationOrder.onDxPurposeChange()");
                DropDownListPrescriber.Attributes.Add("onchange", "SetPrescriberId()");
                _txtStartDate.Attributes.Add("onBlur",
                                             "FormatOrderDateEntered(this); ClientMedicationOrder.onStartDate(this," +
                                             rowIndex + ");");
                //#KA "RecalculateEndDate(this);");
                _txtEndDate.Attributes.Add("onBlur", "ClientMedicationOrder.onEndDate()");
                _DropDownListPotencyUnitCode.Attributes.Add("onchange",
                                                            "ClientMedicationOrder.onPotencyUnitCodeChange(this, " +
                                                            rowIndex + ");");

                _txtDays.Attributes.Add("SuspendRowManipulation", "false");
                _txtStartDate.Attributes.Add("SuspendRowManipulation", "false");
                _txtEndDate.Attributes.Add("SuspendRowManipulation", "false");

                _txtStartDate.Attributes.Add("onchange", "ClientMedicationOrder.SetDocumentDirty();");
                _txtEndDate.Attributes.Add("onchange", "ClientMedicationOrder.SetDocumentDirty();");
                _txtDays.Attributes.Add("onchange", "ClientMedicationOrder.SetDocumentDirty();");
                _txtQuantity.Attributes.Add("onchange", "ClientMedicationOrder.SetDocumentDirty();");
                _txtRefills.Attributes.Add("onchange", "ClientMedicationOrder.SetDocumentDirty();");
                _txtSample.Attributes.Add("onchange", "ClientMedicationOrder.SetDocumentDirty();");
                _txtStock.Attributes.Add("onchange", "ClientMedicationOrder.SetDocumentDirty();");
                CheckBoxDispense.Attributes.Add("onchange", "ClientMedicationOrder.SetDocumentDirty();");
                TextBoxSpecialInstructions.Attributes.Add("onchange", "ClientMedicationOrder.SetDocumentDirty();");

                TextBoxComments.Attributes.Add("onchange", "ClientMedicationOrder.SetDocumentDirty();");
                CheckBoxOffLabel.Attributes.Add("onchange", "ClientMedicationOrder.SetDocumentDirty();");
                TextBoxDesiredOutcome.Attributes.Add("onchange", "ClientMedicationOrder.SetDocumentDirty();");
                CheckBoxOffLabel.Attributes.Add("onchange", "ClientMedicationOrder.SetDocumentDirty();");
                CheckBoxVerbalOrderReadBack.Attributes.Add("onchange", "ClientMedicationOrder.SetDocumentDirty();");
                //   DropDownListDEANumber.Attributes.Add("onchange", "ClientMedicationOrder.SetDocumentDirty();");

                return _TableRow;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "";
                else
                    ex.Data["CustomExceptionInformation"] = "";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = "";
                throw (ex);
            }
            finally
            {
            }
        }

        public string enableDisabled(Permissions per)
        {
            if (((StreamlinePrinciple)Context.User).HasPermission(per))
                return "";
            else
                return "Disabled";
        }

        #endregion

        #region Update

        protected void ButtonUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                CommonFunctions.Event_Trap(this);
                if (DocumentUpdateDocument())
                    Session["IsDirty"] = false;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "";
                else
                    ex.Data["CustomExceptionInformation"] = "";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = "";
                LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);
            }
            finally
            {
            }
        }

        /// <summary>
        /// </summary>
        /// <returns></returns>
        /// ----------------------Modification History---------------
        /// ---Date------Author--------Purpose-----------------------
        /// 28 Oct 2009  Pradeep       Made changes as per task#9
        public override bool DocumentUpdateDocument()
        {
            base.DocumentUpdateDocument();
            ClientMedication objClientMedication = null;
            DataRow[] DataRowsClientMedications = null;
            DataRow[] DataRowsClientMedicationsDrugCategory = null;
            DataSetClientMedications dsClientMedicationsTobePrescribed = null;

            try
            {
                DataSetClientMedications dsClientMedications = null;
                CommonFunctions.Event_Trap(this);
                Session["SelectedMedicationId"] = null;
                if (Session["DataSetClientMedications"] != null)
                {
                    // retrieve the medication that are in session
                    dsClientMedications = (DataSetClientMedications)Session["DataSetClientMedications"];
                    if (dsClientMedications.Tables["ClientMedications"].Rows[0]["DrugCategory"] != "")
                    {
                        DataRowsClientMedicationsDrugCategory = dsClientMedications.Tables["ClientMedications"].Select("DrugCategory > 1");
                        bool CheckEPCS = ((StreamlinePrinciple)Context.User).HasPermission(Permissions.EPCS);
                        //if (DataRowsClientMedicationsDrugCategory.Length > 0 && CheckEPCS == true)
                        //{
                        //    if (HiddenFieldPharmacyPrescriber.Value != "EPCS" && RadioButtonFaxToPharmacy.Checked == true)
                        //    {
                        //        tableErrorMessage.Style["display"] = "block";
                        //        ImageError.Style["display"] = "block";
                        //        LabelErrorMessage.Text = "Controlled substance must be printed if Selected Pharmacy is not EPCS.";
                        //        return false;
                        //    }
                        //}
                    }
                   
                    if (dsClientMedications == null)
                    {
                        tableErrorMessage.Style["display"] = "block";
                        ImageError.Style["display"] = "block";
                        LabelErrorMessage.Text = "At least one medication must be ordered to prescribe.";
                        return false;
                    }

                    objClientMedication = new ClientMedication();
                    // retrieve data rows where not deleted
                    DataRowsClientMedications =
                        dsClientMedications.Tables["ClientMedications"].Select("ISNULL(RecordDeleted,'N')='N'");
                    if (DataRowsClientMedications.Length <= 0)
                    {
                        ScriptManager.RegisterStartupScript(Label1, Label1.GetType(), Label1.ClientID,
                                                            "ClientMedicationOrder.ShowMessage();", true);
                        return false;
                    }

                    string medicationNameId = "";
                    string _prescriberName = (HiddenFieldPrescriber.Value != "" && HiddenFieldPrescriber.Value != null)
                                                 ? HiddenFieldPrescriberName.Value
                                                 : DropDownListPrescriber.SelectedItem.Text;
                    Int32 _prescriberId = (HiddenFieldPrescriber.Value != "" && HiddenFieldPrescriber.Value != null)
                                              ? Convert.ToInt32(HiddenFieldPrescriber.Value)
                                              : (DropDownListPrescriber.SelectedValue != "")
                                                    ? Convert.ToInt32(DropDownListPrescriber.SelectedValue)
                                                    : -1;
                    // update each medication row to Ordered = 'Y', 
                    // set Medication start date to today if empty, set Order Date and get list of medicationNameId's
                    // set the prescriber name and id
                    foreach (DataRow drClientMedications in DataRowsClientMedications)
                    {
                        drClientMedications["Ordered"] = "Y";
                        if (drClientMedications["MedicationStartDate"] == DBNull.Value)
                            drClientMedications["MedicationStartDate"] =
                                Convert.ToDateTime(DateTime.Now).ToString("MM/dd/yyyy");

                        drClientMedications["PrescriberName"] = _prescriberName;
                        drClientMedications["PrescriberId"] = _prescriberId;

                        medicationNameId += (medicationNameId != "" ? "," : "") +
                                            drClientMedications["MedicationNameId"].ToString().Trim();

                        if (drClientMedications["DrugPurpose"].ToString() == "" &&
                            HiddenFieldDxPurposeNotMandatory.Value == "N")
                        {
                            ScriptManager.RegisterStartupScript(ButtonUpdate, ButtonUpdate.GetType(),
                                                                ClientID, "InformationNotComplete();", true);
                            return false;
                        }
                    }

                    // Check for allergy interactions
                    if (medicationNameId != "" &&
                        (((StreamlineIdentity)Context.User.Identity)).AllowAllergyMedications !=
                        "Y")
                    {
                        DataRow[] _allergyInteractions =
                            dsClientMedications.ClientAllergiesInteraction.Select(
                                "isnull(AllergyType,'A')='A' and MedicationNameid in(" + medicationNameId + ")");

                        if (_allergyInteractions.Length > 0)
                        {
                            ScriptManager.RegisterStartupScript(ButtonUpdate, ButtonUpdate.GetType(),
                                                                ClientID, "NoPrescribe();", true);
                            return false;
                        }
                    }
                    else if (
                        (((StreamlineIdentity)Context.User.Identity)).AllowAllergyMedications ==
                        "Y")
                    {
                        // Check drug interactions
                        bool hasDrugInteractions = false;
                        foreach (DataRow dr in
                            dsClientMedications.ClientMedicationInteractions.Select(
                                "InteractionLevel='1' and isnull(recorddeleted,'N') <> 'Y'"))
                        {
                            hasDrugInteractions = true;
                            if (dr["PrescriberAcknowledged"] == DBNull.Value ||
                                dr["PrescriberAcknowledged"].ToString() != "Y")
                            {
                                ScriptManager.RegisterStartupScript(ButtonUpdate, ButtonUpdate.GetType(),
                                                                    ClientID, "NotAcknowledge();", true);
                                return false;
                            }
                        }
                        if (!hasDrugInteractions)
                        {
                            // Check medications for allergy interactions
                            foreach (DataRow dr in DataRowsClientMedications)
                            {
                                if (dr["AllowAllergyMedications"].ToString() != "Y")
                                {
                                    if (dsClientMedications.ClientAllergiesInteraction.Select(
                                        "isnull(AllergyType,'A')='A' and MedicationNameid in(" +
                                        dr["MedicationNameId"].ToString().Trim() + ")").Length > 0)
                                    {
                                        ScriptManager.RegisterStartupScript(ButtonPrescribe,
                                                                            ButtonPrescribe.GetType(),
                                                                            ClientID, "NotAcknowledge();",
                                                                            true);
                                        return false;
                                    }
                                }
                            }
                        }
                    }

                    //In case Prescribers are different for Medications then Error Message will be displayed
                    if (DropDownListPrescriber.SelectedValue == "")
                    {
                        if (DataRowsClientMedications[0]["PrescriberId"].ToString() != "")
                        {
                            Int32 _MinPrescriberId =
                                Convert.ToInt32(
                                    dsClientMedications.Tables["ClientMedications"].Compute("MIN(PrescriberId)",
                                                                                            "ISNULL(RecordDeleted,'N')<>'Y'"));
                            Int32 _MaxPrescriberId =
                                Convert.ToInt32(
                                    dsClientMedications.Tables["ClientMedications"].Compute("Max(PrescriberId)",
                                                                                            "ISNULL(RecordDeleted,'N')<>'Y'"));

                            if (_MinPrescriberId != _MaxPrescriberId)
                            {
                                ScriptManager.RegisterStartupScript(ButtonUpdate, ButtonUpdate.GetType(),
                                                                    ClientID, "PrescriberNotSame();", true);
                                return false;
                            }
                        }
                    }

                    //Do not Allow Refill to Use Obsolete Diagnosis
                    txtButtonValue = (HiddenField)Page.FindControl("txtButtonValue");
                    if (txtButtonValue.Value.ToUpper() == "REFILL")
                    {
                        //string DSMCode = "";
                        bool DSMCodeFlag = false;
                        //bool DSMCodeGlobalCode = false;
                        DataSet DataSetDxPurpose = null;
                        DataSetDxPurpose = new DataSet();
                        if (
                            ConfigurationSettings.AppSettings["ExternalInterface"]
                                .ToUpper() ==
                            "TRUE" && Session["ExternalClientInformation"] != null)
                        {
                            DataSetDxPurpose.Merge((DataSet)Session["ExternalClientInformation"]);
                        }
                        else
                        {
                            DataSetDxPurpose.Merge(
                                objClientMedication.ClientMedicationDxPurpose(
                                    ((StreamlinePrinciple)Context.User).Client.ClientId));
                            DataSetDxPurpose.Tables[0].TableName = "ClientDiagnosis";
                        }

                        foreach (DataRow _dataRowDSMCode in DataRowsClientMedications)
                        {
                            DSMCodeFlag = false;
                            if (_dataRowDSMCode["DSMCode"].ToString() != "null" &&
                                _dataRowDSMCode["DSMCode"].ToString() != DBNull.Value.ToString())
                            {
                                foreach (
                                    DataRow _dataRowActiveDSMCode in
                                        DataSetDxPurpose.Tables["ClientDiagnosis"].Select("1=1"))
                                {
                                    if (_dataRowDSMCode["DSMCode"].ToString() ==
                                        _dataRowActiveDSMCode["DSMCode"].ToString())
                                        DSMCodeFlag = true;
                                }
                                if (DSMCodeFlag == false)
                                {
                                    ScriptManager.RegisterStartupScript(ButtonUpdate, ButtonUpdate.GetType(),
                                                                        ClientID, "ActiveDSMCode();", true);
                                    return false;
                                }
                            }
                        }
                    }

                    //Need to display some message on the Prescribe button event if values for Pharm+Stock+Samples = 0 for any of the instructions. 
                    if (
                        dsClientMedications.Tables["ClientMedicationScriptDrugs"].Select(
                            "ISNULL(RecordDeleted,'N')<>'Y' and (Pharmacy+stock+sample)<=0 and ISNULL(AutoCalcallow,'Y')='Y'")
                                                                                 .Length > 0)
                    {
                        ScriptManager.RegisterStartupScript(ButtonUpdate, ButtonUpdate.GetType(), ClientID,
                                                            "MedicationsScriptDataValidation();", true);
                        return false;
                    }

                    // Check for Instructions InformationComplete being set to N and check scripts with order date > rx start date
                    DateTime _orderDate = Convert.ToDateTime(TextBoxOrderDate.Text);
                    foreach (
                        DataRow dataRowclientMedicationInstructions in
                            dsClientMedications.ClientMedicationInstructions.Select(
                                "isnull(recorddeleted,'N') <> 'Y' and Active='Y'"))
                    {
                        if (dataRowclientMedicationInstructions["InformationComplete"].ToString() == "N")
                        {
                            ScriptManager.RegisterStartupScript(ButtonUpdate, ButtonUpdate.GetType(),
                                                                ClientID, "InformationNotComplete();", true);
                            return false;
                        }
                        foreach (
                            DataRow _dataRowClientMedicationScriptDrugs in
                                dsClientMedications.ClientMedicationScriptDrugs.Select(
                                    "ClientMedicationInstructionId=" +
                                    dataRowclientMedicationInstructions["ClientMedicationInstructionId"] +
                                    " and isnull(recorddeleted,'N') <> 'Y'"))
                        {
                            if (Convert.ToDateTime(_dataRowClientMedicationScriptDrugs["StartDate"]) < _orderDate)
                            {
                                ScriptManager.RegisterStartupScript(ButtonUpdate, ButtonUpdate.GetType(),
                                                                    ClientID,
                                                                    "ClientMedicationOrder.ShowError('Start date in the list cannot be before order date.',true);",
                                                                    true);
                                return false;
                            }
                        }
                    }

                    // loop through the script records and set the order date, 
                    // setting ordering method of P, E or F
                    // set location, PrintDrugInformation, pharmacy id
                    Int32 _LocationId = (HiddenFieldLocationId.Value != "")
                                            ? Convert.ToInt32(HiddenFieldLocationId.Value)
                                            : -1;

                    PrintDrugInformation = CheckBoxPrintDrugInformation.Checked ? 'Y' : 'N';
                    VerbalOrderReadBack = CheckBoxVerbalOrderReadBack.Checked ? 'Y' : 'N';
                   
                    Int32 _PharmacyId = 0;
                    if (((HiddenField)Parent.FindControl("HiddenFieldRedirectFrom")).Value.ToUpper() == "DASHBOARD" &&
                        (_DrugsOrderMethod.ToUpper() == "REFILL" || _DrugsOrderMethod.ToUpper() == "NEW ORDER" || _DrugsOrderMethod.ToUpper() == "CHANGEAPPROVALORDER" || _DrugsOrderMethod.ToUpper() == "APPROVEWITHCHANGESCHANGEORDER"))
                    {
                        var pharmacyid = (HiddenField)Page.FindControl("HiddenFieldRefillPharmacyId");
                        if (pharmacyid.Value != "")
                        {
                            _PharmacyId = Convert.ToInt32(pharmacyid.Value);
                        }
                    }
                    else
                    {
                        if (HiddenFieldScriptsPharmacyId.Value != string.Empty)
                        {
                            _PharmacyId = Convert.ToInt32(HiddenFieldScriptsPharmacyId.Value);
                        }
                        else if (((HiddenField)(Parent.FindControl("HiddenFieldPharmacyId"))).Value != "")
                        {
                            _PharmacyId =
                                Convert.ToInt32(((HiddenField)(Parent.FindControl("HiddenFieldPharmacyId"))).Value);
                        }
                        else if (((HiddenField)(FindControl("HiddenFieldPharmacyId"))).Value != "")
                        {
                            _PharmacyId =
                                Convert.ToInt32(((HiddenField)(FindControl("HiddenFieldPharmacyId"))).Value);
                        }
                    }

                    int indexClientMedication = 0;
                    foreach (
                        DataRow dataRow in
                            dsClientMedications.ClientMedicationScripts.Select("isnull(recorddeleted,'N') <> 'Y'"))
                    {
                        dataRow["OrderDate"] = _orderDate;
                        // location
                        if (_LocationId > 0)
                            dataRow["LocationId"] = _LocationId;
                        else
                            dataRow["LocationId"] = DBNull.Value;

                        dataRow["PrintDrugInformation"] = PrintDrugInformation;
                        dataRow["VerbalOrderReadBack"] = VerbalOrderReadBack;
                        dataRow["StaffLicenseDegreeId"] = (HiddenFieldDEANumber.Value != "" && HiddenFieldDEANumber.Value != null)
                                             ? HiddenFieldDEANumber.Value
                                             : (DropDownListDEANumber.SelectedValue != "")
                                                   ? DropDownListDEANumber.SelectedValue
                                                   : ""; 

                        // for printing
                        if (RadioButtonPrintScript.Checked)
                        {
                            if (dataRow["OrderingMethod"].ToString() != "A")
                            {
                                dataRow["OrderingMethod"] = "P";
                                OrderingMethod = 'P';
                                dataRow["PharmacyId"] = _PharmacyId;
                            }
                        }
                        else // check for faxing or e-prescibing
                        {
                            if (_PharmacyId == 0)
                            {
                                dataRow["PharmacyId"] = DBNull.Value;
                            }
                            else
                            {
                                dataRow["PharmacyId"] = _PharmacyId;
                            }

                            DataSet dsElectronicPrescriptionPermissions = objClientMedication.ElectronicPrescriptionPermissions(_prescriberId,_PharmacyId);
                            string SelectedPresciberHasElectronicPermission="";
                            string SelectedPresciberSPID = "";
                            string SelectedPharmacySPID = "";
                            string SelectedPharmacyServiceLevel = "";
                            if (dsElectronicPrescriptionPermissions.Tables[0].Rows.Count > 0 && dsElectronicPrescriptionPermissions.Tables[1].Rows.Count > 0)
                            {
                                 SelectedPresciberHasElectronicPermission = dsElectronicPrescriptionPermissions.Tables[0].Rows[0]["EPCSEnabled"].ToString();
                                 SelectedPresciberSPID = dsElectronicPrescriptionPermissions.Tables[0].Rows[0]["SureScriptsPrescriberId"].ToString();
                                 SelectedPharmacySPID = dsElectronicPrescriptionPermissions.Tables[1].Rows[0]["SureScriptsPharmacyIdentifier"].ToString();
                                 SelectedPharmacyServiceLevel = dsElectronicPrescriptionPermissions.Tables[1].Rows[0]["ServiceLevel"].ToString();
                             }
                            Hashtable ht_Selected_DDL_Values = new Hashtable();
                            ht_Selected_DDL_Values.Add("ElectricPrescriptionPermissions", SelectedPresciberHasElectronicPermission);
                            ht_Selected_DDL_Values.Add("PresciberSPID", SelectedPresciberSPID);
                            ht_Selected_DDL_Values.Add("PharmacySPID", SelectedPharmacySPID);
                            ht_Selected_DDL_Values.Add("PharmactServiceLevel", SelectedPharmacyServiceLevel);
                            Session["PrescriberPharmacyPermissions"] = ht_Selected_DDL_Values;
                            
                            using (
                                DataSet dsSureScriptsAvailable = objClientMedication.SureScriptsAvailable(_PharmacyId,
                                                                                                          _prescriberId,
                                                                                                          _LocationId))
                            {
                                string sureScriptsAvaliable =
                                    dsSureScriptsAvailable.Tables[0].Rows[0]["SureScriptsAvailable"].ToString();
                                dataRow["OrderingMethod"] = OrderingMethod = sureScriptsAvaliable == "Y" ? 'E' : 'F';
                                bool EPCSCheck = ((StreamlinePrinciple)Context.User).HasPermission(Permissions.EPCS);
                                if (EPCSCheck)
                                {
                                    if (sureScriptsAvaliable == "Y" && (dsClientMedications.ClientMedications[indexClientMedication].DrugCategory=="3" ||
                                        dsClientMedications.ClientMedications[indexClientMedication].DrugCategory=="4" || dsClientMedications.ClientMedications[indexClientMedication].DrugCategory == "5"))
                                    {
                                        dataRow["OrderingMethod"] = OrderingMethod = 'E';
                                        indexClientMedication++;
                                    }
                                }
                            }
                        }
                    }

                    DataRow[] drPharmacies = null;
                    if (_PharmacyId > 0)
                    {
                        SharedTables objectSharedTables = null;
                        objectSharedTables = new SharedTables();

                        DataSet DataSetPharmacies =
                            objectSharedTables.getPharmacies(((StreamlinePrinciple)Context.User).Client.ClientId);
                        drPharmacies =
                            DataSetPharmacies.Tables[0].Select(
                                "PharmacyId=" + _PharmacyId.ToString() + " and LEN(FaxNumber) >= 7",
                                "PharmacyName asc");
                    }

                    // get the pharmacy info for faxing or e-prescribing
                    //if (OrderingMethod == 'F' || OrderingMethod == 'E')
                    //{
                        if (_PharmacyId > 0)
                        {
                            //SharedTables objectSharedTables = null;
                            //objectSharedTables = new SharedTables();

                            //DataSet DataSetPharmacies =
                            //    objectSharedTables.getPharmacies(((StreamlinePrinciple)Context.User).Client.ClientId);
                            //DataRow[] drPharmacies =
                            //    DataSetPharmacies.Tables[0].Select(
                            //        "PharmacyId=" + _PharmacyId.ToString() + " and LEN(FaxNumber) >= 7",
                            //        "PharmacyName asc");

                            if (drPharmacies.Length > 0)
                            {
                                if (OrderingMethod == 'F')
                                {
                                    strReceipentOrganisation =
                                        strReceipeintName = drPharmacies[0]["PharmacyName"].ToString();
                                    strReceipentFaxNumber = drPharmacies[0]["FaxNumber"].ToString();
                                }
                                else
                                    strSureSriptPharmacyIdentifier =
                                        drPharmacies[0]["SureScriptsPharmacyIdentifier"].ToString();
                            }
                            else if (OrderingMethod == 'F' &&
                                     ((HiddenField)(Parent.FindControl("HiddenFieldPharmacyFaxNo"))).Value != "")
                            {
                                strReceipentFaxNumber =
                                    ((HiddenField)(Parent.FindControl("HiddenFieldPharmacyFaxNo"))).Value;
                            }
                            else if (OrderingMethod == 'E' &&
                                     ((HiddenField)(Parent.FindControl("HiddenFieldSureScriptIdentifier"))).Value !=
                                     "")
                            {
                                strSureSriptPharmacyIdentifier =
                                    ((HiddenField)(Parent.FindControl("HiddenFieldSureScriptIdentifier")))
                                        .Value;
                            }
                        }
                        else if (OrderingMethod == 'F' &&
                                 ((HiddenField)(Parent.FindControl("HiddenFieldPharmacyFaxNo"))).Value != "")
                        {
                            strReceipentFaxNumber =
                                ((HiddenField)(Parent.FindControl("HiddenFieldPharmacyFaxNo"))).Value;
                        }
                        else if (OrderingMethod == 'E' &&
                                 ((HiddenField)(Parent.FindControl("HiddenFieldSureScriptIdentifier"))).Value != "")
                        {
                            strSureSriptPharmacyIdentifier =
                                ((HiddenField)(Parent.FindControl("HiddenFieldSureScriptIdentifier"))).Value;
                        }
                    //}

                    //Set the chart copy option
                    Session["IncludeChartcopy"] = CheckBoxPrintChartCopy.Checked ? "Y" : "N";

                    if (Session["DataSetPrescribedClientMedications"] != null)
                    {
                        dsClientMedicationsTobePrescribed =
                            (DataSetClientMedications)Session["DataSetPrescribedClientMedications"];
                        dsClientMedicationsTobePrescribed.Merge(dsClientMedications);
                        //Enable Dx/Purpose and Prescriber Fields
                        foreach (
                            DataRow _drPrescribedMedication in
                                dsClientMedicationsTobePrescribed.Tables["ClientMedications"].Select(
                                    "ISNULL(RecordDeleted,'N')<>'Y'"))
                        {
                            _drPrescribedMedication["PrescriberId"] = _prescriberId;
                            _drPrescribedMedication["PrescriberName"] = _prescriberName;
                        }
                        Session["DataSetPrescribedClientMedications"] = dsClientMedicationsTobePrescribed;
                    }
                    else
                        Session["DataSetPrescribedClientMedications"] = dsClientMedications;

                    return true;
                }
                else
                {
                    return false;
                }
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "";
                else
                    ex.Data["CustomExceptionInformation"] = "";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = "";
                LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);

                ScriptManager.RegisterStartupScript(ButtonUpdate, ButtonUpdate.GetType(), ClientID, "ErrorUpdate();",
                                                    true);

                return false;
            }
            finally
            {
                objClientMedication = null;
                DataRowsClientMedications = null;
            }
        }

        #endregion

        #region GetClientMedicationData

        private void GetClientMedicationData(int clientMedicationId)
        {
            try
            {
                CommonFunctions.Event_Trap(this);
                var objClientMedication = new ClientMedication();
                ObjectClientMedication.Merge(objClientMedication.GetClientMedicationData(clientMedicationId,
                                                                                         ((StreamlineIdentity)
                                                                                          Context.User.Identity).UserId));
                Session["DataSetClientMedications"] = ObjectClientMedication;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "";
                else
                    ex.Data["CustomExceptionInformation"] = "";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = "";
                throw (ex);
            }
        }

        #endregion

        #region Presciber
        /// <summary>
        ///   Pranay Bodhu
        ///   Purpose of ProcessScripts-To change the ordering method of scripts accordingly w.r.t PharmacyEPC/NON-EPCS, OrderingMethod, Prescriber Permissions..
        /// </summary>
        ///<Date>01/30/2018</Date>
        /// <returns></returns>
        public void ProcessScripts(int PharmacyId, int PrescriberId, char OrderingMethod,DataSet DataSetClientMedications_Temp)
        {
               Hashtable ht_Get_DDL_Values = new Hashtable();
               string ElectricPrescriptionPermissions = "";
               string PresciberSPID = "";
               string PharmacySPID = "";
               string PharmactServiceLevel = "";
               int    LoggedInStaffId = ((StreamlineIdentity)Context.User.Identity).UserId;
			   string OrderType=_DrugsOrderMethod.ToUpper();
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

                   if (OrderingMethod == 'P') //Radio button Print selected then all the scripts gets printed.
                   {
                           foreach (
                               DataRow _dataRowClientMedicationScript in
                                   tableClientMedicationScripts.Select(" isnull(recorddeleted,'N') <> 'Y'"))
                           {
                               _dataRowClientMedicationScript["OrderingMethod"] = 'P';
                           }
                   }
                   if (OrderingMethod == 'E') // When Radio button Send Directly to Pharmacy is selected then all  scripts gets printed/Electric based on the permissions
                   {
                       if (Convert.ToInt32(PharmactServiceLevel) >= 2048 && ElectricPrescriptionPermissions == "Y" && LoggedInStaffId==PrescriberId)
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
                           //Controlled Drug Order Method-P
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
                           //Non-Controlled Drug Order Method-E
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

                   if (System.Configuration.ConfigurationSettings.AppSettings.AllKeys.Contains("FaxScheduledCategoryList") && ElectricPrescriptionPermissions != "Y" && OrderingMethod!='P')
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
        


        protected void ButtonPrescribe_Click(object sender, EventArgs e)
        {
            try
            {
                CommonFunctions.Event_Trap(this);
                ValidationMessage = string.Empty;
                ValidationStatus = string.Empty;
                Session["OriginalDataUpdated"] = 1;
                string UserID = (((StreamlineIdentity)Context.User.Identity)).UserId.ToString();
                string IsPrescriber = (((StreamlineIdentity)Context.User.Identity)).Prescriber.ToString();

                bool saveFlag = DocumentUpdateDocument();
                if (saveFlag)
                {
                 
                    bool savePreviewFlag = DocumentUpdateTempDataSet();

                    if (savePreviewFlag)
                    {
                        if (Session["DataSetClientSummary"] != null)
                        {
                            _DataSetClientSummary = (DataSet)Session["DataSetClientSummary"];

                            DataSetClientMedications DataSetClientMedications;
                            DataSetClientMedications = new DataSetClientMedications();
                            DataSetClientMedications = (DataSetClientMedications)Session["DataSetClientMedications"];
                            DataTable _DataTableClientMedications = DataSetClientMedications.Tables["ClientMedications"];
                           
                            //Checks if the Interaction Drugs are Acknowledged.   
                            if (DataSetClientMedications.Tables.Contains("ClientMedicationInteractions"))
                            {
                                if (DataSetClientMedications.Tables["ClientMedicationInteractions"].Select("InteractionLevel = 1").Length != DataSetClientMedications.Tables["ClientMedicationInteractions"].Select("PrescriberAcknowledged ='Y' and InteractionLevel = 1 and (ISNULL(RecordDeleted,'N')='N')").Length)
                                {
                                    ScriptManager.RegisterStartupScript(ButtonPrescribe,
                                                                               ButtonPrescribe.GetType(),
                                                                               ClientID,
                                                                                "ClientMedicationOrder.ShowError('Please acknowledge the drug interactions.', true);",
                                                                                                true);
                                    return;
                                }
                            }
                            Streamline.UserBusinessServices.ClientMedication objClientMedication = new Streamline.UserBusinessServices.ClientMedication();
                            DataSet dsElectronicPrescriptionPermissions = objClientMedication.ElectronicPrescriptionPermissions(Convert.ToInt32(DropDownListPrescriber.SelectedValue),0);
                            string SelectedPresciberHasElectronicPermission = dsElectronicPrescriptionPermissions.Tables[0].Rows[0]["EPCSEnabled"].ToString();
                            bool EPCSCheck = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).HasPermission(Permissions.EPCS);
                            //if (_DataTableClientMedications.Rows[0]["DrugCategory"] != "")
                            //{
                            //    DataRow[] foundControlDrug = _DataTableClientMedications.Select("DrugCategory >= 2");
                            //    //Checks if the Logged-in user is a prescriber and then allow to prescribe control drugs. 
                            //    if (_DrugsOrderMethod.ToUpper() != "ADJUST") //Added by Pranay w.r.t MHP Task#261
                            //    {
                            //        if (SelectedPresciberHasElectronicPermission != "Y" && RadioButtonPrintScript.Checked == false)
                            //        {
                            //            if (DropDownListPrescriber.SelectedValue != UserID && SelectedPresciberHasElectronicPermission == "Y")
                            //            {
                            //                if (foundControlDrug.Length > 0)
                            //                {
                            //                    ScriptManager.RegisterStartupScript(ButtonPrescribe,
                            //                                                       ButtonPrescribe.GetType(),
                            //                                                       ClientID,
                            //                                                        "ClientMedicationOrder.ShowError('Controlled substance must be queued if prescribed by any user other than the Prescriber.', true);",
                            //                                                                        true);
                            //                    return;
                            //                }
                            //            }
                            //        }
                            //        else if ((DropDownListPrescriber.SelectedValue != UserID) && ((SelectedPresciberHasElectronicPermission == "Y" && (EPCSCheck == true || EPCSCheck == false))))
                            //        {
                            //            if (DropDownListPrescriber.SelectedValue != UserID)
                            //            {
                            //                if (foundControlDrug.Length > 0)
                            //                {
                            //                    ScriptManager.RegisterStartupScript(ButtonPrescribe,
                            //                                                       ButtonPrescribe.GetType(),
                            //                                                       ClientID,
                            //                                                        "ClientMedicationOrder.ShowError('Controlled substance must be queued if prescribed by any user other than the Prescriber.', true);",
                            //                                                                        true);
                            //                    return;
                            //                }
                            //            }
                            //        }
                            //    }
                            //}
                            DataTable _DataTableClientMedicationInstructions =
                                DataSetClientMedications.Tables["ClientMedicationInstructions"];
                            //Condition added by Loveena in ref to Task#3040- Allow Prescribers to Print/Fax for Other Prescribers
                            if ((((StreamlineIdentity)Context.User.Identity)).EnableOtherPrescriberSelection != "Y")
                            {
                                //Code added by Loveena in ref to Task#2987 to Disable Print/Fax Button if the current user is a prescriber and the selected prescribe
                                //does not match the current user, disable the Print/Fax Order button
                                if (((StreamlineIdentity)Context.User.Identity).Prescriber == "Y")
                                {
                                    if (DataSetClientMedications.Tables["ClientMedications"].Rows[0]["PrescriberId"] !=
                                        null)
                                    {
                                        if (
                                            DataSetClientMedications.Tables["ClientMedications"].Rows[0]["PrescriberId"] !=
                                            DBNull.Value)
                                        {
                                            if (
                                                Convert.ToInt32(
                                                    DataSetClientMedications.Tables["ClientMedications"].Rows[0][
                                                        "PrescriberId"]) !=
                                                ((StreamlineIdentity)Context.User.Identity).UserId)
                                            {
                                                //ButtonNewOrder.Enabled = false;
                                                ScriptManager.RegisterStartupScript(LabelChartCopyPrinter,
                                                                                    LabelChartCopyPrinter.GetType(),
                                                                                    ClientID,
                                                                                    "ClientMedicationOrder.ShowError('Cannot prescribe order for others. You may only prescribe for yourself.', true);",
                                                                                    true);
                                                return;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        ScriptManager.RegisterStartupScript(ButtonPrescribe, ButtonPrescribe.GetType(), ClientID,
                                                            "redirectToPrescribePage();", true);
                        //bool prescribeFlag = DocumentPrescribeDocument(); 
                       // ButtonPrescribe.Enabled = false;
                    }
                    else
                    {
                        //Write code to show Dialog Box
                        ScriptManager.RegisterStartupScript(ButtonPrescribe, ButtonPrescribe.GetType(), ClientID,
                                                            "ClientMedicationOrder.ShowValidationDialogue('" +
                                                            ValidationMessage + "');", true);
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
                    ex.Data["DatasetInfo"] = "";
                LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);
            }
            finally
            {
            }
        }

        #endregion

        #region placeholderdelete

        /// <summary>
        ///     This function is used to Delete the Dynamic Row when user clicks on Delete button.
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void buttonDelete_Click(object sender, EventArgs e)
        {
            try
            {
                CommonFunctions.Event_Trap(this);
                ImageButton PictureBoxDeleteRow;
                PictureBoxDeleteRow = (ImageButton)sender;
                var pnl = (TableCell)PictureBoxDeleteRow.Parent;

                string rowId = Convert.ToString(PictureBoxDeleteRow.Attributes["picTemp"]);
                if (DataTableClientMedicationInstructions.Rows.Count > 0)
                {
                    DataRow[] drTemp = DataTableClientMedicationInstructions.Select("rowidentifier='" + rowId + "'");
                    if (drTemp.Length > 0)
                    {
                        //To set RecordDeleted Y so that they are not shown in MedicationList and also in Database.
                        drTemp[0]["RecordDeleted"] = "Y";
                        drTemp[0]["DeletedDate"] = Convert.ToDateTime(DateTime.Now.ToShortDateString());
                        drTemp[0]["DeletedBy"] = ((StreamlineIdentity)Context.User.Identity).UserCode;
                        // DataViewClientMedicationInstructions.Table.Rows.Remove(drTemp[0]);
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
                    ex.Data["DatasetInfo"] = "";
                LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);
            }
            finally
            {
            }
        }

        #endregion
    }
}

                    #endregion
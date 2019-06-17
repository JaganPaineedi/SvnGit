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
using System.Linq;
using System.Xml.Linq;


namespace Streamline.SmartClient.UI
{
    public partial class UserControls_ClientMedicationNonOrder : Streamline.BaseLayer.BaseActivityPage
    {
        protected string NonOrderMedicationResult = "";
        public string rxresourcerequired = "true";
        public string dateinitiatedrequired = "true";
        public string RelativePath = "";
        Streamline.UserBusinessServices.DataSets.DataSetClientMedications ObjectClientMedication = new Streamline.UserBusinessServices.DataSets.DataSetClientMedications();

        Streamline.UserBusinessServices.DataSets.DataSetClientMedications.ClientMedicationInstructionsDataTable DataTableClientMedicationInstructions = null;
        Streamline.UserBusinessServices.DataSets.DataSetClientMedications.ClientMedicationsDataTable DataTableClientMedications = null;
        private System.Data.DataView DataViewClientMedication;
        private System.Data.DataView DataViewClientMedicationInstructions;
        private HiddenField txtButtonValue = null;
        #region Page_load
        /// <summary>
        /// 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected override void Page_Load(object sender, EventArgs e)
        {
            //Task 680 Added by Jyothi  
            DataSet datasetSystemConfigurationKeys = null;
            DataSet datasetStaffPermissions = null;
            Streamline.DataService.SharedTables objSharedTables1 = new Streamline.DataService.SharedTables();
            datasetSystemConfigurationKeys = objSharedTables1.GetSystemConfigurationKeys();
            datasetStaffPermissions = objSharedTables1.GetPermissionWithParentList((((StreamlineIdentity)Context.User.Identity)).UserId, 5921, 2, null);
            if (objSharedTables1.GetSystemConfigurationKeys("UseKeyPhrases", datasetSystemConfigurationKeys.Tables[0]).ToUpper() == "Y")
            {
                if (datasetStaffPermissions.Tables[0].Rows.Count>0)
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
            //end
            try
            {
                RelativePath = Page.ResolveUrl("~");
                NonOrderMedicationResult = "";

                #region "error message color added by rohit ref. #121"
                Streamline.BaseLayer.CommonFunctions.SetErrorMegssageBackColor(LabelErrorMessage);
                Streamline.BaseLayer.CommonFunctions.SetErrorMegssageBackColor(LabelGridErrorMessage);
                Streamline.BaseLayer.CommonFunctions.SetErrorMegssageForeColor(LabelErrorMessage);
                Streamline.BaseLayer.CommonFunctions.SetErrorMegssageForeColor(LabelGridErrorMessage);
                #endregion
                string CommentTextOnCheckBoxUnCheck = string.Empty;
                string CommentTextOnCheckBoxCheck = string.Empty;
                string requiredRxSource = System.Configuration.ConfigurationSettings.AppSettings["RxSourceRequired"];
                if (requiredRxSource != null && requiredRxSource.ToString().ToLower().Equals("true"))
                {
                    rxresourcerequired = "true";
                }
                else
                    rxresourcerequired = "false";

                string requiredDateInitiated = ConfigurationManager.AppSettings["DateInitiatedRequired"];
                dateinitiatedrequired = (requiredDateInitiated != null && requiredDateInitiated.ToLower().Equals("true"))
                                            ? "true"
                                            : "false";

                //Ref to Task#2895
                if (System.Configuration.ConfigurationSettings.AppSettings["OpenFromSmartCare"].ToString().ToUpper() == "FALSE")
                {
                    LinkButtonLogout.Style["display"] = "block";
                    LinkButtonStartPage.Style["display"] = "block";
                }
                //Code added by Loveena in ref to Task#3273-  	2.6.1 Non-Ordered Medications: Allow Changes
                txtButtonValue = (HiddenField)Page.FindControl("txtButtonValue");
                if (txtButtonValue.Value == "Update Medication")
                {
                    Label1.Text = "Update Medication (Not Ordered Locally)";
                }
                //Added in ref to Task#2905
                HiddenRelativePath.Value = Page.ResolveUrl("~");

                createControls();
                //Added By Pradeep as per task#31.
                //Changes added by Loveena in ref to comment by David
                //CheckBoxPermitChanges.Enabled = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).HasPermission(Permissions.PermitChanges)
                if (((Streamline.BaseLayer.StreamlinePrinciple)Context.User).HasPermission(Permissions.PermitChanges) && ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).Prescriber == "Y")
                {
                    CheckBoxPermitChanges.Attributes.Add("style", "display:block");
                }
                else
                {
                    CheckBoxPermitChanges.Attributes.Add("style", "display:none");
                }
                this.TextBoxDrug.Focus();
                this.TextBoxDrug.Attributes.Add("onblur", "ClientMedicationNonOrder.ShowParticipantSearchDiv('" + TextBoxDrug.ClientID + "','" + LabelErrorMessage.ClientID + "','" + DivErrorMessage.ClientID + "','" + ImageError.ClientID + "','" + tableErrorMessage.ClientID + "')");
                // Add javascript handlers for paste and keypress
                //this.TextBoxSpecialInstructions.Attributes.Add("onkeypress", "doKeypress(this);");
                //this.TextBoxSpecialInstructions.Attributes.Add("onbeforepaste", "doBeforePaste(this);");
                //this.TextBoxSpecialInstructions.Attributes.Add("onpaste", "doPaste(this);");
                //Added By Chandan on 18th March 2008
                this.DropDownListDxPurpose.Attributes.Add("onchange", "ClientMedicationNonOrder.doFillHiddenFieldDxPurpose(this,'" + HiddenDrugPurpose.ClientID + "','" + HiddenDSMCode.ClientID + "','" + HiddenDxId.ClientID + "','" + HiddenDSMNumber.ClientID + "');");
                this.DropDownListPrescriber.Attributes.Add("onchange", "ClientMedicationNonOrder.doFillHiddenFieldListPrescriber(this,'" + HiddenPrescriberName.ClientID + "','" + HiddenPrescriberId.ClientID + "');");
                //ButtonUpdate.Attributes.Add("onclick", "var res=validateBlank('" + TextBoxStartDate.ClientID + "','" + TextBoxDrug.ClientID + "','" + LabelErrorMessage.ClientID + "','" + DivErrorMessage.ClientID + "','" + ImageError.ClientID + "');if (res==false) return; ");

                if (Session["DataSetClientMedications"] != null)
                {
                    Streamline.UserBusinessServices.DataSets.DataSetClientMedications dsTemp =
                        (Streamline.UserBusinessServices.DataSets.DataSetClientMedications)
                        Session["DataSetClientMedications"];
                    DataView dvMedications = new DataView(dsTemp.ClientMedications);

                    foreach (DataRowView dataRowView in dvMedications)
                    {
                        if (dataRowView["SmartcareOrderEntry"].ToString() == "Y")
                        {
                            ButtonUpdate.Enabled = false;
                        }
                    }
                }

                //Added By Chandan on 18th March 2008
                // Add attribute for access of maxlength property on client-side
                this.TextBoxSpecialInstructions.Attributes.Add("maxLength", "1000");
                //--Start Code Added By Pradeep as per task#31
                //CheckBoxPermitChanges.Attributes.Add("onclick", "SetDocumentDirty()");
                CheckBoxPermitChanges.Checked = true;
                //---End Code added by Pradeep as per task#31
                //Code added by Loveena in ref to Task#86
                //#KA02212014 DropdownDrug.Attributes.Add("onchange", "DisplayText()");
                if (Session["DataTableClientMedications"] != null)
                    DataTableClientMedications = (Streamline.UserBusinessServices.DataSets.DataSetClientMedications.ClientMedicationsDataTable)Session["DataTableClientMedications"];
                if (Session["DataTableClientMedicationInstructions"] != null)
                    DataTableClientMedicationInstructions = (Streamline.UserBusinessServices.DataSets.DataSetClientMedications.ClientMedicationInstructionsDataTable)Session["DataTableClientMedicationInstructions"];
                this.DataViewClientMedication = new DataView(DataTableClientMedications);
                this.DataViewClientMedicationInstructions = new DataView(DataTableClientMedicationInstructions);
                #region--Code Added By Pradeep as per task#3328
                if (System.Configuration.ConfigurationManager.AppSettings["OrderPageCommentLabel"] != null)
                {
                    CommentTextOnCheckBoxUnCheck = System.Configuration.ConfigurationManager.AppSettings["OrderPageCommentLabel"].ToString();
                    HiddenNonOrderPageCommentLabel.Value = CommentTextOnCheckBoxUnCheck;
                }
                if (System.Configuration.ConfigurationManager.AppSettings["OrderPageCommentLabelIncludeOnPrescription"] != null)
                {
                    CommentTextOnCheckBoxCheck = System.Configuration.ConfigurationManager.AppSettings["OrderPageCommentLabelIncludeOnPrescription"].ToString();
                    HiddenNonOrderPageCommentLabelIncludeOnPrescription.Value = CommentTextOnCheckBoxCheck;
                }
                if (System.Configuration.ConfigurationManager.AppSettings["OrderPageNoteLabel"] != null)
                {
                    LabelNonOrderNote.Text = System.Configuration.ConfigurationManager.AppSettings["OrderPageNoteLabel"].ToString();
                }

                if (System.Configuration.ConfigurationManager.AppSettings["OrderPageCommentLabel"] != null && System.Configuration.ConfigurationManager.AppSettings["OrderPageCommentLabelIncludeOnPrescription"] != null)
                {
                    if (CheckboxIncludeOnPrescription.Checked)
                    {
                        LabelNonOrderCommentText.Text = CommentTextOnCheckBoxCheck;
                    }
                    else
                    {
                        LabelNonOrderCommentText.Text = CommentTextOnCheckBoxUnCheck;
                    }
                    CheckboxIncludeOnPrescription.Attributes.Add("onclick", "ClientMedicationNonOrder.ChangeNonOrderPageCommentText('" + LabelNonOrderCommentText.ClientID + "','" + CheckboxIncludeOnPrescription.ClientID + "','" + CommentTextOnCheckBoxUnCheck + "','" + CommentTextOnCheckBoxCheck + "');");
                }

                #endregion

                //Code Added by : Malathi Shiva 
                //With Ref to task# : 33 - Community Network Services
                if (((Streamline.BaseLayer.StreamlinePrinciple)Context.User).HasPermission(Permissions.OffLabel) == false)
                {
                    this.CheckBoxOffLabel.Attributes.Add("style", "display:none");
                    this.Span_OffLabel.Attributes.Add("style", "display:none");
                }

                // Added new functionality that allows Dx/Purpose field to be optional based on dbo.SystemConfigurations.DxPurposeIsNotMandatory
                Streamline.UserBusinessServices.ApplicationCommonFunctions objApplicationCommonFunctions = null;
                objApplicationCommonFunctions = new Streamline.UserBusinessServices.ApplicationCommonFunctions();
                DataSet SystemConfigurations = objApplicationCommonFunctions.GetSystemConfigurations();
                if (SystemConfigurations.Tables.Count > 0)
                {
                    if (SystemConfigurations.Tables[0].Rows.Count > 0 && SystemConfigurations.Tables[0].Columns.Contains("DxPurposeIsNotMandatory"))
                    {
                        DataRow dataRowSystemConfigs = SystemConfigurations.Tables[0].Rows[0];
                        if (dataRowSystemConfigs.Table.Columns.Contains("DxPurposeIsNotMandatory"))
                        {
                            HiddenFieldDxPurposeNotMandatory.Value = dataRowSystemConfigs["DxPurposeIsNotMandatory"].ToString();
                        }
                    }
                }

                Streamline.UserBusinessServices.ClientMedication objClientMedication = new Streamline.UserBusinessServices.ClientMedication();
                DataSet dsClientEnrolledPrograms = objClientMedication.GetClientEnrolledPrograms(((StreamlinePrinciple)Context.User).Client.ClientId,'N');
                if (dsClientEnrolledPrograms.Tables.Count > 0)
                {
                    if (dsClientEnrolledPrograms.Tables[0].Rows.Count > 0)
                    {
                        HiddenFieldRXShownoOfDaysOfWeekPopup.Value = "Y";
                    }
                }

                Streamline.DataService.SharedTables objSharedTables = new Streamline.DataService.SharedTables();
                if (Streamline.UserBusinessServices.SharedTables.DataSetSystemConfigurationKeys != null)
                {
                    if (Streamline.UserBusinessServices.SharedTables.DataSetSystemConfigurationKeys.Tables.Count > 0)
                    {
                        //Added By Malathi Shiva: Task# 321.3 : Key Point - Customizations : 
                        //Check program enrollment for the current date for each non order locally medication on insert, then check to see if the program the client is enrolled in has the checkbox ‘Non Prescribed Meds’
                        HiddenFieldRXAddMedicationFrequencyIsRequiredField.Value = objSharedTables.GetSystemConfigurationKeys("RXAddMedicationFrequencyIsRequiredField", Streamline.UserBusinessServices.SharedTables.DataSetSystemConfigurationKeys.Tables[0]);
                        if (HiddenFieldRXAddMedicationFrequencyIsRequiredField.Value.ToLower() == "y")
                        {
                            if (dsClientEnrolledPrograms.Tables.Count > 0)
                            {
                                if (dsClientEnrolledPrograms.Tables[0].Rows.Count > 0)
                                {
                                    DataTable dt = dsClientEnrolledPrograms.Tables[0];
                                    var listClientEnrolledProgramNames = dt.AsEnumerable().Select(r => r.Field<string>("ProgramName")).ToList();

                                    if (listClientEnrolledProgramNames.Count > 1)
                                    {
                                        string delimited = String.Join(", ", new List<string>(listClientEnrolledProgramNames).Take(new List<string>(listClientEnrolledProgramNames).Count - 1).ToArray());
                                        HiddenFieldRXProgramRequireFrequency.Value = String.Concat(delimited, " and ", new List<string>(listClientEnrolledProgramNames).LastOrDefault());
                                    }
                                    else
                                    {
                                        HiddenFieldRXProgramRequireFrequency.Value = string.Join(",", new List<string>(listClientEnrolledProgramNames).ToArray());
                                    }
                                }
                            }
                        }
                    }
                }

                if (ConfigurationManager.AppSettings["EnableRXOrderTemplates"].ToUpper() == "Y")
                {
                    // Load prescriber order templates
                    // Create dataset for Order templates
                    Streamline.UserBusinessServices.DataSets.DataSetDrugOrderTemplates dsDrugOrderTemplates = null;
                    dsDrugOrderTemplates = Streamline.UserBusinessServices.UserInfo.GetDrugOrderTemplates(((StreamlineIdentity)Context.User.Identity).UserId);
                    Session["DrugOrderTemplates"] = dsDrugOrderTemplates;
                }


                HiddenFieldLoggedInStaffId.Value = ((StreamlineIdentity)Context.User.Identity).UserId.ToString();

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

        #endregion

        #region Activate()

        public override void Activate()
        {
            try
            {
                CommonFunctions.Event_Trap(this);
                base.Activate();
                DataTableClientMedications = new Streamline.UserBusinessServices.DataSets.DataSetClientMedications.ClientMedicationsDataTable();
                DataTableClientMedicationInstructions = new Streamline.UserBusinessServices.DataSets.DataSetClientMedications.ClientMedicationInstructionsDataTable();
                //Commented by Loveena in ref to Task#2934 -  Non Ordered Meds - Do not require date initiated
                //TextBoxStartDate.Text = DateTime.Today.ToString("MM/dd/yyyy");
                //Commented Code ends over here.

                //Following code added by sonia reference Task 2233 SC-Support
                //Activate the Client Summary control

                //Code added by Loveena in ref to Task#3273-  	2.6.1 Non-Ordered Medications: Allow Changes
                txtButtonValue = (HiddenField)Page.FindControl("txtButtonValue");
                if (txtButtonValue.Value == "Update Medication")
                {
                    Label1.Text = "Update Medication (Non Ordered Locally)";

                }
                MedicationClientPersonalInformation1.Activate();

                //Activate the MedicationClientPersonalInformation Control added by rohit ref ticket #80
                MedicationClientPersonalInformation1.showEditableAllergyList = false;
                MedicationClientPersonalInformation1.Activate();

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

        #endregion

        #region CreateControls

        private void createControls()
        {

            try
            {
                CommonFunctions.Event_Trap(this);

                CreateLabelRow();
                Table tableControls = new Table();
                tableControls.Width = new Unit(100, UnitType.Percentage);
                tableControls.ID = "tableMedicationOrder";
                tableControls.Attributes.Add("tableMedicationOrder", "true");
                string myscript = "<script id='MedicationOrderScript' type='text/javascript'>";
                myscript += "function InitializeComponents(){;";
                //myscript += "$create(Streamline.SmartClient.UI.TextBox, {'ignoreEnterKey':true,DateTime:true}, {'onBlur':ClientMedicationNonOrder.ManipulateRowValues},{},$get('" + TextBoxStartDate.ClientID + "'));";
                for (int _RowCount = 0; _RowCount < 2; _RowCount++)
                {
                    tableControls.Rows.Add(CreateMedicationRow(_RowCount, ref myscript));
                }
                myscript += "}</script>";
                PlaceHolder.Controls.Add(tableControls);
                ScriptManager.RegisterStartupScript(PlaceHolder, PlaceHolder.GetType(), PlaceHolder.ClientID.ToString(), myscript, false);
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


        }

        private void CreateLabelRow()
        {

            try
            {
                CommonFunctions.Event_Trap(this);
                Table _Table = new Table();
                _Table.Width = new Unit(100, UnitType.Percentage);
                TableRow _TableRow = new TableRow();
                TableCell _TableCell0 = new TableCell();
                TableCell _TableCell1 = new TableCell();
                TableCell _TableCell1b = new TableCell();
                TableCell _TableCell2 = new TableCell();
                TableCell _TableCell3 = new TableCell();
                TableCell _TableCell4 = new TableCell();
                TableCell _TableCell5 = new TableCell();
                TableCell _TableCell6 = new TableCell();
                TableCell _TableCell7 = new TableCell();
                TableCell _TableCell8 = new TableCell();
                TableCell _TableCell8_5 = new TableCell();
                TableCell _TableCell9 = new TableCell();
                TableCell _TableCell10 = new TableCell();
                TableCell _TableCell11 = new TableCell();
                TableCell _TableCell12 = new TableCell();
                TableCell _TableCell13 = new TableCell();
                TableCell _TableCell14 = new TableCell();
                TableCell _TableCell15 = new TableCell();

                _Table.ID = "Table";

                Label _lblDeleteRow = new Label();
                _lblDeleteRow.ID = "Delete";
                _lblDeleteRow.Height = 20;
                _lblDeleteRow.Visible = true;
                _lblDeleteRow.Text = "";

                Label _lblStrength = new Label();
                _lblStrength.ID = "Strength";
                _lblStrength.Height = 20;
                _lblStrength.Visible = true;
                _lblStrength.Text = "Strength";

                Label _lblQuantity = new Label();
                _lblQuantity.ID = "Quantity";
                _lblQuantity.Height = 20;
                _lblQuantity.Visible = true;
                _lblQuantity.Text = "Dose";

                Label _lblUnit = new Label();
                _lblUnit.ID = "Unit";
                _lblUnit.Height = 20;
                _lblUnit.Visible = true;
                _lblUnit.Text = "Unit";

                Label _lblSchedule = new Label();
                _lblSchedule.ID = "Schedule";
                _lblSchedule.Height = 20;
                _lblSchedule.Visible = true;
                _lblSchedule.Text = "Directions";

                Label _lblStartDate = new Label();
                _lblStartDate.ID = "StartDate";
                _lblStartDate.Height = 20;
                _lblStartDate.Visible = true;
                _lblStartDate.Text = "Rx Start";

                Label _lblStartImg = new Label();
                _lblStartImg.ID = "StartImg";
                _lblStartImg.Height = 20;
                _lblStartImg.Visible = true;
                _lblStartImg.Text = "";

                Label _lblDays = new Label();
                _lblDays.ID = "Days";
                _lblDays.Height = 20;
                _lblDays.Visible = true;
                _lblDays.Text = "Days";

                Label _lblPharma = new Label();
                _lblPharma.ID = "Pharm";
                _lblPharma.Height = 20;
                _lblPharma.Visible = true;
                _lblPharma.Text = "Dispense Qty";

                Label _lblPotencyUnitCode = new Label();
                _lblPotencyUnitCode.ID = "PotencyUnitCode";
                _lblPotencyUnitCode.Height = 20;
                _lblPotencyUnitCode.Visible = true;
                _lblPotencyUnitCode.Text = "Potency Unit";

                Label _lblSample = new Label();
                _lblSample.ID = "Sample";
                _lblSample.Height = 20;
                _lblSample.Visible = true;
                _lblSample.Text = "Sample";

                Label _lblStock = new Label();
                _lblStock.ID = "Stock";
                _lblStock.Height = 20;
                _lblStock.Visible = true;
                _lblStock.Text = "Stock";

                Label _lblRefills = new Label();
                _lblRefills.ID = "Refills";
                _lblRefills.Height = 20;
                _lblRefills.Visible = true;
                _lblRefills.Text = "Refills";

                Label _lblEndDate = new Label();
                _lblEndDate.ID = "EndDate";
                _lblEndDate.Height = 20;
                _lblEndDate.Visible = true;
                _lblEndDate.Text = "Rx End";

                Label _lblEndImg = new Label();

                _TableCell0.Controls.Add(_lblDeleteRow);
                _TableCell0.Width = new Unit(2, UnitType.Percentage);
                _TableCell1.Controls.Add(_lblStrength);
                _TableCell1.Width = new Unit(16, UnitType.Percentage);
                if (enableDisabled(Streamline.BaseLayer.Permissions.Formulary) != "Disabled")
                {
                    _TableCell1b.Controls.Add(new Label() { Text = "" });
                    _TableCell1b.Width = new Unit(18, UnitType.Pixel);
                }
                _TableCell2.Controls.Add(_lblQuantity);
                _TableCell2.Width = new Unit(5, UnitType.Percentage);
                _TableCell3.Controls.Add(_lblUnit);
                _TableCell3.Width = new Unit(6, UnitType.Percentage);
                _TableCell4.Controls.Add(_lblSchedule);
                _TableCell4.Width = new Unit(14, UnitType.Percentage);
                _TableCell5.Controls.Add(_lblStartDate);
                _TableCell5.Width = new Unit(8, UnitType.Percentage);
                _TableCell6.Controls.Add(_lblStartImg);
                _TableCell6.Width = new Unit(3, UnitType.Percentage);
                _TableCell7.Controls.Add(_lblDays);
                _TableCell7.Width = new Unit(4, UnitType.Percentage);
                _TableCell8.Controls.Add(_lblPharma);
                _TableCell8.Width = new Unit(9, UnitType.Percentage);
                _TableCell8_5.Controls.Add(_lblPotencyUnitCode);
                _TableCell8_5.Width = new Unit(9, UnitType.Percentage);
                _TableCell9.Controls.Add(_lblRefills);
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

        public string enableDisabled(Permissions per)
        {

            if (((Streamline.BaseLayer.StreamlinePrinciple)Context.User).HasPermission(per))
                return "";
            else
                return "Disabled";
        }

        //Modfied in ref to Task#2802
        private TableRow CreateMedicationRow(int rowIndex, ref string myscript)
        {
            try
            {
                HiddenField textboxButtonValue = this.Page.FindControl("txtButtonValue") as HiddenField;

                CommonFunctions.Event_Trap(this);
                Table _Table = new Table();
                _Table.Width = new Unit(100, UnitType.Percentage);
                TableRow _TableRow = new TableRow();
                _TableRow.ID = "TableMedicationRow_" + rowIndex;
                TableCell _TableCell0 = new TableCell();
                TableCell _TableCell1 = new TableCell();
                TableCell _TableCell2 = new TableCell();
                TableCell _TableCell3 = new TableCell();
                TableCell _TableCell4 = new TableCell();
                TableCell _TableCell5 = new TableCell();
                TableCell _TableCell6 = new TableCell();
                TableCell _TableCell7 = new TableCell();
                TableCell _TableCell8 = new TableCell();
                TableCell _TableCell8_5 = new TableCell();
                TableCell _TableCell9 = new TableCell();
                TableCell _TableCell10 = new TableCell();
                TableCell _TableCell11 = new TableCell();
                TableCell _TableCell12 = new TableCell();
                TableCell _TableCell13 = new TableCell();
                TableCell _TableCell14 = new TableCell();
                TableCell _TableCell15 = new TableCell();
                TableCell _TableCell16 = new TableCell();
                _Table.ID = "TableMedication" + rowIndex;


                HtmlImage _ImgDeleteRow = new HtmlImage();
                _ImgDeleteRow.ID = "ImageDelete" + rowIndex;
                _ImgDeleteRow.Src = "~/App_Themes/Includes/Images/deleteIcon.gif";
                _ImgDeleteRow.Attributes.Add("class", "handStyle");
                //if (textboxButtonValue != null && textboxButtonValue.Value == "Refill")
                //    _ImgDeleteRow.Disabled = true;

                myscript += "var Imagecontext" + rowIndex + ";";
                myscript += "var ImageclickCallback" + rowIndex + " =";
                myscript += " Function.createCallback(ClientMedicationNonOrder.DeleteRow , Imagecontext" + rowIndex + ");";
                myscript += "$addHandler($get('" + this.ClientID + this.ClientIDSeparator + _ImgDeleteRow.ClientID + "'), 'click', ImageclickCallback" + rowIndex + ");";

                DropDownList _DropDownListStrength = new DropDownList();
                _DropDownListStrength.Width = new Unit(100, UnitType.Percentage);
                _DropDownListStrength.Height = 20;

                //if (textboxButtonValue != null && textboxButtonValue.Value == "Refill")
                //    _DropDownListStrength.Enabled = false;
                _DropDownListStrength.EnableViewState = true;
                _DropDownListStrength.ID = "DropDownListStrength" + rowIndex;

                TextBox _txtQuantity = new TextBox();
                _txtQuantity.BackColor = System.Drawing.Color.White;
                _txtQuantity.MaxLength = 4;

                //if (textboxButtonValue != null && textboxButtonValue.Value == "Refill")
                //    _txtQuantity.Enabled = false;
                _txtQuantity.ID = "TextBoxQuantity" + rowIndex;
                _txtQuantity.Width = new Unit(96, UnitType.Percentage);
                _txtQuantity.Height = 20;
                _txtQuantity.Visible = true;
                _txtQuantity.Style["text-align"] = "Right";
                myscript += "$create(Streamline.SmartClient.UI.TextBox, {'ignoreEnterKey':true,Decimal:true}, {'onBlur':ClientMedicationNonOrder.ManipulateRowValues},{},$get('" + this.ClientID + this.ClientIDSeparator + _txtQuantity.ClientID + "'));";

                DropDownList _DropDownListUnit = new DropDownList();
                _DropDownListUnit.Width = new Unit(100, UnitType.Percentage);
                _DropDownListUnit.Height = 20;
                //if (textboxButtonValue != null && textboxButtonValue.Value == "Refill")
                //    _DropDownListUnit.Enabled = false;
                _DropDownListUnit.ID = "DropDownListUnit" + rowIndex;

                DropDownList _DropDownListSchedule = new DropDownList();
                _DropDownListSchedule.Width = new Unit(100, UnitType.Percentage);
                _DropDownListSchedule.Height = 20;
                //if (textboxButtonValue != null && textboxButtonValue.Value == "Refill")
                //    _DropDownListSchedule.Enabled = false;
                _DropDownListSchedule.ID = "DropDownListSchedule" + rowIndex;

                TextBox _txtStartDate = new TextBox();
                _txtStartDate.BackColor = System.Drawing.Color.White;
                _txtStartDate.ID = "TextBoxStartDate" + rowIndex;
                _txtStartDate.Width = new Unit(96, UnitType.Percentage);
                _txtStartDate.Height = 20;
                _txtStartDate.Visible = true;

                myscript += "$create(Streamline.SmartClient.UI.TextBox, {'ignoreEnterKey':true,DateTime:true}, {'onBlur':ClientMedicationNonOrder.ManipulateRowValues},{},$get('" + this.ClientID + this.ClientIDSeparator + _txtStartDate.ClientID + "'));";


                Image _ImgStartDate = new Image();
                _ImgStartDate.ID = "ImageStartDate" + rowIndex;
                _ImgStartDate.ImageUrl = "~/App_Themes/Includes/Images/calender_grey.gif";
                _ImgStartDate.Attributes.Add("onClick", "CalShow( this,'" + this.ClientID + this.ClientIDSeparator + _txtStartDate.ClientID + "')");
                _ImgStartDate.Attributes.Add("onmouseover", "CalShow( this,'" + this.ClientID + this.ClientIDSeparator + _txtStartDate.ClientID + "')");



                TextBox _txtDays = new TextBox();
                _txtDays.BackColor = System.Drawing.Color.White;
                _txtDays.MaxLength = 4;
                _txtDays.ID = "TextBoxDays" + rowIndex;
                _txtDays.Width = new Unit(96, UnitType.Percentage);
                _txtDays.Height = 20;
                _txtDays.Visible = true;
                _txtDays.Attributes.Add("MedicationDays", ((Streamline.BaseLayer.StreamlineIdentity)(Context.User.Identity)).MedicationDaysDefault.ToString());
                _txtDays.Style["text-align"] = "Right";
                myscript += "$create(Streamline.SmartClient.UI.TextBox, {'ignoreEnterKey':true,Numeric:true}, {'onBlur':ClientMedicationNonOrder.ManipulateRowValues},{},$get('" + this.ClientID + this.ClientIDSeparator + _txtDays.ClientID + "'));";

                string _comboBoxPharmacyTextDivString = "<div id='ComboBoxPharmacyDDDiv_" + rowIndex +
                   "' style='border: solid 1px #7b9ebd; height:18px; position:relative; overflow:hidden;' onclick=\"ClientMedicationNonOrder.onClickPharmacyComboList(this, '#ComboBoxPharmacyDDList_" + rowIndex +
                   "');\"><input type='text' id='ComboBoxPharmacyDD_" + rowIndex +
                   "' value='' style='border:none; width: 137px; height:18px; position:absolute; left:0;' onchange=\"ClientMedicationNonOrder.onChangePharmacyComboList(this, '#ComboBoxPharmacyDDList_" + rowIndex +
                   "');\" onkeydown=\"ClientMedicationNonOrder.onKeyDownPharmacyComboList(event, '#ComboBoxPharmacyDDList_" + rowIndex +
                   "');\" /><div style=' position:absolute; right:0;; height:18px; width:19px;' class='ComboBoxDrugDDImage'>&nbsp;</div></div>";

                var _comboBoxPharmacyTextDiv = new LiteralControl(_comboBoxPharmacyTextDivString);

                string _comboBoxPharmacyDDListString = @"<div style='display:none; white-space:nowrap;' id='ComboBoxPharmacyDDList_" + rowIndex +
                    "' isempty='true' caller='ComboBoxPharmacyDD_" + rowIndex + "' class='combolist' onclick=\"ClientMedicationNonOrder.onSelectedPharmacyComboList(event, this);\"></div>";

                var _comboBoxPharmacyDDList = new LiteralControl(_comboBoxPharmacyDDListString);

                DropDownList _DropDownListPotencyUnitCode = new DropDownList();
                _DropDownListPotencyUnitCode.Width = new Unit(100, UnitType.Percentage);
                _DropDownListPotencyUnitCode.Height = 20;
                _DropDownListPotencyUnitCode.ID = "_DropDownListPotencyUnitCode" + rowIndex;
                _DropDownListPotencyUnitCode.Attributes.Add("class", "ddlist");

                TextBox _txtSample = new TextBox();
                _txtSample.BackColor = System.Drawing.Color.White;
                _txtSample.MaxLength = 4;
                _txtSample.ID = "TextBoxSample" + rowIndex;
                _txtSample.Width = new Unit(96, UnitType.Percentage);
                _txtSample.Height = 20;
                _txtSample.Visible = true;
                _txtSample.Style["text-align"] = "Right";
                myscript += "$create(Streamline.SmartClient.UI.TextBox, {'ignoreEnterKey':true,Decimal:true}, {'onBlur':ClientMedicationNonOrder.ManipulateRowValues},{},$get('" + this.ClientID + this.ClientIDSeparator + _txtSample.ClientID + "'));";

                TextBox _txtStock = new TextBox();
                _txtStock.BackColor = System.Drawing.Color.White;
                _txtStock.MaxLength = 4;
                _txtStock.ID = "TextBoxStock" + rowIndex;
                _txtStock.Width = new Unit(96, UnitType.Percentage);
                _txtStock.Height = 20;
                _txtStock.Visible = true;
                _txtStock.Style["text-align"] = "Right";
                myscript += "$create(Streamline.SmartClient.UI.TextBox, {'ignoreEnterKey':true,Decimal:true}, {'onBlur':ClientMedicationNonOrder.ManipulateRowValues},{},$get('" + this.ClientID + this.ClientIDSeparator + _txtStock.ClientID + "'));";

                TextBox _txtRefills = new TextBox();
                _txtRefills.BackColor = System.Drawing.Color.White;
                _txtRefills.MaxLength = 2;
                _txtRefills.ID = "TextBoxRefills" + rowIndex;
                _txtRefills.Width = new Unit(96, UnitType.Percentage);
                _txtRefills.Height = 20;
                _txtRefills.Visible = true;
                _txtRefills.Style["text-align"] = "Right";
                myscript += "$create(Streamline.SmartClient.UI.TextBox, {'ignoreEnterKey':true,Decimal:true}, {'onBlur':ClientMedicationNonOrder.ManipulateRowValues},{},$get('" + this.ClientID + this.ClientIDSeparator + _txtRefills.ClientID + "'));";

                TextBox _txtEndDate = new TextBox();
                _txtEndDate.ID = "TextBoxEndDate" + rowIndex;
                _txtEndDate.Width = new Unit(96, UnitType.Percentage);
                _txtEndDate.Height = 20;
                _txtEndDate.Enabled = true;
                _txtEndDate.Style["text-align"] = "Right";

                HiddenField _hiddenAutoCalcAllowed = new HiddenField();
                _hiddenAutoCalcAllowed.ID = "HiddenFieldAutoCalcAllowed" + rowIndex;

                myscript += "$create(Streamline.SmartClient.UI.TextBox, {'ignoreEnterKey':true,DateTime:true}, {},{},$get('" + this.ClientID + this.ClientIDSeparator + _txtEndDate.ClientID + "'));";

                Label _RowIdentifier = new Label();
                _RowIdentifier.ID = "RowIdentifier" + rowIndex;

                HiddenField _hiddenstrengthRowIdentifier = new HiddenField();
                _hiddenstrengthRowIdentifier.ID = "HiddenRowIdentifier" + rowIndex;

                HiddenField _noOfDaysOfWeek = new HiddenField();
                _noOfDaysOfWeek.ID = "noOfDaysOfWeek" + rowIndex;

                _TableCell0.Controls.Add(_ImgDeleteRow);
                _TableCell0.Width = new Unit(2, UnitType.Percentage);
                _TableCell1.Controls.Add(_DropDownListStrength);
                _TableCell1.Width = new Unit(16, UnitType.Percentage);
                _TableCell2.Controls.Add(_txtQuantity);
                _TableCell2.Width = new Unit(5, UnitType.Percentage);
                _TableCell3.Controls.Add(_DropDownListUnit);
                _TableCell3.Width = new Unit(6, UnitType.Percentage);
                _TableCell4.Controls.Add(_DropDownListSchedule);
                _TableCell4.Width = new Unit(14, UnitType.Percentage);
                _TableCell5.Controls.Add(_txtStartDate);
                _TableCell5.Width = new Unit(8, UnitType.Percentage);
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

                _DropDownListStrength.Attributes.Add("onchange", "ClientMedicationNonOrder.onStrengthChange(this,'" + this.ClientID + this.ClientIDSeparator + _DropDownListUnit.ClientID + "',null,'" + this.ClientID + this.ClientIDSeparator + _txtDays.ClientID + "','" + TextBoxStartDate.ClientID + "','" + this.ClientID + this.ClientIDSeparator + _txtStartDate.ClientID + "','" + this.ClientID + this.ClientIDSeparator + _txtQuantity.ClientID + "','" + rowIndex + "')");

                _DropDownListUnit.Attributes.Add("onchange", "ClientMedicationNonOrder.onUnitChange(" + rowIndex + ")");
                _DropDownListUnit.Attributes.Add("onBlur", "ClientMedicationNonOrder.onUnitBlur(this)");
                _DropDownListSchedule.Attributes.Add("onchange", "ClientMedicationNonOrder.onScheduleChange(" + rowIndex + ")");
                _DropDownListSchedule.Attributes.Add("onBlur", "ClientMedicationNonOrder.onScheduleBlur(this)");
                DropDownListDxPurpose.Attributes.Add("onchange", "ClientMedicationNonOrder.onDxPurposeChange()");
                DropDownListPrescriber.Attributes.Add("onchange", "ClientMedicationNonOrder.onPrescriber()");

                _DropDownListPotencyUnitCode.Attributes.Add("onchange", "ClientMedicationNonOrder.onPotencyUnitCodeChange(this, " + rowIndex + ");");
                _txtStartDate.Attributes.Add("onBlur", "ClientMedicationNonOrder.onStartDate(this," + rowIndex + ")");
                _txtEndDate.Attributes.Add("onBlur", "ClientMedicationNonOrder.onEndDate()");

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
        #endregion

        #region Update

        protected void ButtonUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                CommonFunctions.Event_Trap(this);
                DocumentUpdateDocument();
                Session["IsDirty"] = false;
                Session["SelectedMedicationId"] = null;
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

        }

        public override bool DocumentUpdateDocument()
        {
            DataRow BlankRow = null; //Added by Chandan on 18th March 2008

            base.DocumentUpdateDocument();

            try
            {
                Streamline.UserBusinessServices.DataSets.DataSetClientMedications dsClientMedications = new Streamline.UserBusinessServices.DataSets.DataSetClientMedications();
                //Streamline.UserBusinessServices.DataSets.DataSetClientMedications dsClientMedications = null;
                CommonFunctions.Event_Trap(this);
                if (Session["DataSetClientMedications"] != null)
                    dsClientMedications = (Streamline.UserBusinessServices.DataSets.DataSetClientMedications)Session["DataSetClientMedications"];

                if (txtButtonValue.Value == "Update Medication")//&& HiddenInsertClick.Value == ""
                {
                    NonOrderMedicationResult = "update"; //"AddMedicationUpdated";
                    if (dsClientMedications.Tables["ClientMedications"].Rows.Count > 0)
                    {
                        DataRow[] drClientMedications = dsClientMedications.Tables["ClientMedications"].Select("ISNULL(RecordDeleted,'N')<>'Y'");
                        int newClientMedicationId = 0;
                        int newInstructionId = 0;
                        int newDispenseDayId = 0;
                        int newScriptDrugId = 0;
                        int newScriptDrugStrengthId = 0;
                        for (int index = 0; index < drClientMedications.Length; index++)
                        {

                            if (dsClientMedications.ExtendedProperties.ContainsKey("OldClientMedicationId"))
                            {
                                dsClientMedications.ExtendedProperties["OldClientMedicationId"] = drClientMedications[index]["ClientMedicationId"];
                            }
                            else { dsClientMedications.ExtendedProperties.Add("OldClientMedicationId", drClientMedications[index]["ClientMedicationId"]); }


                            if (dsClientMedications.ExtendedProperties.ContainsKey("UserCode"))
                            {
                                dsClientMedications.ExtendedProperties["UserCode"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                            }
                            else { dsClientMedications.ExtendedProperties.Add("UserCode", ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode); }



                            //drClientMedications[index].AcceptChanges();
                            //drClientMedications[index]["RecordDeleted"] = "Y";
                            //drClientMedications[index]["DeletedDate"] = System.DateTime.Now;
                            //drClientMedications[index]["DeletedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;

                            //drClientMedications[index].SetModified();
                            DataRow drNewClientMedication = dsClientMedications.Tables["ClientMedications"].NewRow();
                            drNewClientMedication["ClientMedicationId"] = newClientMedicationId;
                            drNewClientMedication["ClientId"] = drClientMedications[index]["ClientId"];
                            drNewClientMedication["Ordered"] = drClientMedications[index]["Ordered"];
                            drNewClientMedication["MedicationNameId"] = drClientMedications[index]["MedicationNameId"];
                            drNewClientMedication["DrugPurpose"] = drClientMedications[index]["DrugPurpose"];
                            drNewClientMedication["DSMCode"] = drClientMedications[index]["DSMCode"];
                            drNewClientMedication["DSMNumber"] = drClientMedications[index]["DSMNumber"];
                            drNewClientMedication["NewDiagnosis"] = drClientMedications[index]["NewDiagnosis"];
                            drNewClientMedication["PrescriberId"] = drClientMedications[index]["PrescriberId"];
                            drNewClientMedication["PrescriberName"] = drClientMedications[index]["PrescriberName"];


                            drNewClientMedication["ExternalPrescriberName"] = drClientMedications[index]["ExternalPrescriberName"];

                            drNewClientMedication["SpecialInstructions"] = drClientMedications[index]["SpecialInstructions"];

                            drNewClientMedication["DAW"] = drClientMedications[index]["DAW"];


                            drNewClientMedication["OffLabel"] = drClientMedications[index]["OffLabel"];
                            drNewClientMedication["DesiredOutcomes"] = drClientMedications[index]["DesiredOutcomes"];

                            drNewClientMedication["Comments"] = drClientMedications[index]["Comments"];
                            //Code ends over here.
                            drNewClientMedication["Discontinued"] = drClientMedications[index]["Discontinued"];
                            drNewClientMedication["DiscontinuedReason"] = drClientMedications[index]["DiscontinuedReason"];
                            drNewClientMedication["MedicationStartDate"] = drClientMedications[index]["MedicationStartDate"];
                            drNewClientMedication["MedicationEndDate"] = drClientMedications[index]["MedicationEndDate"];
                            drNewClientMedication["PermitChangesByOtherUsers"] = drClientMedications[index]["PermitChangesByOtherUsers"];
                            drNewClientMedication["MedicationName"] = drClientMedications[index]["MedicationName"];
                            drNewClientMedication["MedicationId"] = drClientMedications[index]["MedicationId"];
                            drNewClientMedication["DxId"] = drClientMedications[index]["DxId"];
                            drNewClientMedication["DrugCategory"] = drClientMedications[index]["DrugCategory"];
                            drNewClientMedication["OldClientMedicationId"] = drClientMedications[index]["OldClientMedicationId"];
                            drNewClientMedication["OrderStatus"] = drClientMedications[index]["OrderStatus"];
                            drNewClientMedication["OrderStatusDate"] = drClientMedications[index]["OrderStatusDate"];
                            drNewClientMedication["MedicationScriptId"] = System.DBNull.Value;
                            drNewClientMedication["TitrationType"] = drClientMedications[index]["TitrationType"];
                            drNewClientMedication["DateTerminated"] = drClientMedications[index]["DateTerminated"];
                            drNewClientMedication["SessionId"] = drClientMedications[index]["SessionId"];
                            drNewClientMedication["ClientMedicationConsentId"] = drClientMedications[index]["ClientMedicationConsentId"];
                            drNewClientMedication["IncludeCommentOnPrescription"] = drClientMedications[index]["IncludeCommentOnPrescription"];
                            drNewClientMedication["SignedByMD"] = drClientMedications[index]["SignedByMD"];
                            drNewClientMedication["VerbalOrder"] = drClientMedications[index]["VerbalOrder"];
                            drNewClientMedication["AllowAllergyMedications"] = drClientMedications[index]["AllowAllergyMedications"];
                            drNewClientMedication["CMOrder"] = drClientMedications[index]["CMOrder"];
                            drNewClientMedication["RowIdentifier"] = System.Guid.NewGuid();

                            drNewClientMedication["CreatedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;

                            drNewClientMedication["CreatedDate"] = DateTime.Now;
                            drNewClientMedication["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                            drNewClientMedication["ModifiedDate"] = DateTime.Now;
                            drNewClientMedication["RecordDeleted"] = System.DBNull.Value;
                            drNewClientMedication["DeletedBy"] = DBNull.Value;
                            drNewClientMedication["DeletedDate"] = DBNull.Value;
                            drNewClientMedication["MedicationName"] = drClientMedications[index]["MedicationName"];

                            drNewClientMedication["DEACode"] = drClientMedications[index]["DEACode"];

                            drNewClientMedication["DiscontinueDate"] = drClientMedications[index]["DiscontinueDate"];

                            drNewClientMedication["RXSource"] = drClientMedications[index]["RXSource"];

                            dsClientMedications.Tables["ClientMedications"].Rows.Add(drNewClientMedication);

                            DataRow[] drClientMedicationInstructions = dsClientMedications.Tables["ClientMedicationInstructions"].Select("ClientMedicationId=" + drClientMedications[index]["ClientMedicationId"] + " and ISNULL(RecordDeleted,'N')<>'Y'");

                            for (int i = 0; i < drClientMedicationInstructions.Length; i++)
                            {
                                drClientMedicationInstructions[i].AcceptChanges();
                                //drClientMedicationInstructions[i]["RecordDeleted"] = "Y";
                                //drClientMedicationInstructions[i]["DeletedDate"] = System.DateTime.Now;
                                //drClientMedicationInstructions[i]["DeletedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                                newInstructionId++;
                                //  drClientMedicationInstructions[i].SetModified();
                                DataRow drNewClientMedicationInstructions = dsClientMedications.Tables["ClientMedicationInstructions"].NewRow();
                                drNewClientMedicationInstructions["ClientMedicationInstructionId"] = newInstructionId;
                                drNewClientMedicationInstructions["ClientMedicationId"] = drNewClientMedication["ClientMedicationId"];
                                drNewClientMedicationInstructions["StrengthId"] = drClientMedicationInstructions[i]["StrengthId"];
                                drNewClientMedicationInstructions["Quantity"] = drClientMedicationInstructions[i]["Quantity"];
                                drNewClientMedicationInstructions["Unit"] = drClientMedicationInstructions[i]["Unit"];
                                drNewClientMedicationInstructions["Schedule"] = drClientMedicationInstructions[i]["Schedule"];
                                drNewClientMedicationInstructions["Active"] = "Y";

                                drNewClientMedicationInstructions["RowIdentifier"] = System.Guid.NewGuid();

                                drNewClientMedicationInstructions["CreatedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                                #region--Code Added By Pradeep on 15 Dec
                                drNewClientMedicationInstructions["RecordDeleted"] = System.DBNull.Value;
                                drNewClientMedicationInstructions["DeletedBy"] = DBNull.Value;
                                drNewClientMedicationInstructions["DeletedDate"] = DBNull.Value;
                                #endregion
                                drNewClientMedicationInstructions["CreatedDate"] = DateTime.Now;
                                drNewClientMedicationInstructions["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                                drNewClientMedicationInstructions["ModifiedDate"] = DateTime.Now;
                                drNewClientMedicationInstructions["Instruction"] = drClientMedicationInstructions[i]["Instruction"];

                                drNewClientMedicationInstructions["StartDate"] = drClientMedicationInstructions[i]["StartDate"];

                                drNewClientMedicationInstructions["EndDate"] = drClientMedicationInstructions[i]["EndDate"];
                                drNewClientMedicationInstructions["Refills"] = drClientMedicationInstructions[i]["Refills"];
                                dsClientMedications.Tables["ClientMedicationInstructions"].Rows.Add(drNewClientMedicationInstructions);

                                DataRow[] drClientMedicationScriptDispenseDays = dsClientMedications.Tables["ClientMedicationScriptDispenseDays"].Select("ClientMedicationId=" + drClientMedications[index]["ClientMedicationId"] + " and ISNULL(RecordDeleted,'N')<>'Y'");
                                for (int l = 0; l < drClientMedicationScriptDispenseDays.Length; l++)
                                {
                                    drClientMedicationScriptDispenseDays[l].AcceptChanges();
                                    newDispenseDayId++;
                                    DataRow drNewClientMedicationScriptDispenseDays = dsClientMedications.Tables["ClientMedicationScriptDispenseDays"].NewRow();
                                    drNewClientMedicationScriptDispenseDays["ClientMedicationScriptDispenseDayId"] = newDispenseDayId;
                                    drNewClientMedicationScriptDispenseDays["ClientMedicationId"] = drNewClientMedication["ClientMedicationId"];
                                    drNewClientMedicationScriptDispenseDays["ClientMedicationInstructionId"] = drNewClientMedicationInstructions["ClientMedicationInstructionId"];
                                    drNewClientMedicationScriptDispenseDays["ClientMedicationScriptId"] = System.DBNull.Value;
                                    drNewClientMedicationScriptDispenseDays["DaysOfWeek"] = drClientMedicationScriptDispenseDays[l]["DaysOfWeek"];
                                    drNewClientMedicationScriptDispenseDays["CreatedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                                    #region--Code Added By Pradeep on 15 Dec
                                    drNewClientMedicationScriptDispenseDays["RecordDeleted"] = System.DBNull.Value;
                                    drNewClientMedicationScriptDispenseDays["DeletedBy"] = DBNull.Value;
                                    drNewClientMedicationScriptDispenseDays["DeletedDate"] = DBNull.Value;
                                    #endregion
                                    drNewClientMedicationScriptDispenseDays["CreatedDate"] = DateTime.Now;
                                    drNewClientMedicationScriptDispenseDays["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                                    drNewClientMedicationScriptDispenseDays["ModifiedDate"] = DateTime.Now;
                                    dsClientMedications.Tables["ClientMedicationScriptDispenseDays"].Rows.Add(drNewClientMedicationScriptDispenseDays);
                                }

                                DataRow[] drClientMedicationScriptDrugs = dsClientMedications.Tables["ClientMedicationScriptDrugs"].Select("ClientMedicationInstructionId=" + drClientMedicationInstructions[i]["ClientMedicationInstructionId"] + " and ISNULL(RecordDeleted,'N')<>'Y'");
                                for (int j = 0; j < drClientMedicationScriptDrugs.Length; j++)
                                {
                                    drClientMedicationScriptDrugs[j].AcceptChanges();
                                    //drClientMedicationScriptDrugs[j]["RecordDeleted"] = "Y";
                                    //drClientMedicationScriptDrugs[j]["DeletedDate"] = System.DateTime.Now;
                                    //drClientMedicationScriptDrugs[j]["DeletedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;

                                    //drClientMedicationScriptDrugs[j].SetModified();
                                    DataRow drNewClientMedicationScriptDrugs = dsClientMedications.Tables["ClientMedicationScriptDrugs"].NewRow();
                                    drNewClientMedicationScriptDrugs["ClientMedicationScriptDrugId"] = newScriptDrugId;
                                    drNewClientMedicationScriptDrugs["ClientMedicationScriptId"] = System.DBNull.Value;
                                    drNewClientMedicationScriptDrugs["ClientMedicationInstructionId"] = drNewClientMedicationInstructions["ClientMedicationInstructionId"];
                                    drNewClientMedicationScriptDrugs["StartDate"] = drClientMedicationScriptDrugs[j]["StartDate"];
                                    drNewClientMedicationScriptDrugs["Days"] = drClientMedicationScriptDrugs[j]["Days"];
                                    //Code added by Loveena in ref to Task#2802
                                    drNewClientMedicationScriptDrugs["Pharmacy"] = drClientMedicationScriptDrugs[j]["Pharmacy"];
                                    drNewClientMedicationScriptDrugs["PharmacyText"] = drClientMedicationScriptDrugs[j]["PharmacyText"];
                                    drNewClientMedicationScriptDrugs["AutoCalcallow"] = drClientMedicationScriptDrugs[j]["AutoCalcallow"];
                                    //Code ends over here.
                                    drNewClientMedicationScriptDrugs["Sample"] = drClientMedicationScriptDrugs[j]["Sample"];
                                    drNewClientMedicationScriptDrugs["Stock"] = drClientMedicationScriptDrugs[j]["Stock"];
                                    //Ref to Task#33 SDI-FY-10-Venture

                                    drNewClientMedicationScriptDrugs["Refills"] = drClientMedicationScriptDrugs[j]["Refills"];
                                    //Code added by Loveena in ref to Task#2641

                                    drNewClientMedicationScriptDrugs["EndDate"] = drClientMedicationScriptDrugs[j]["EndDate"];
                                    drNewClientMedicationScriptDrugs["RowIdentifier"] = System.Guid.NewGuid();
                                    drNewClientMedicationScriptDrugs["CreatedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                                    drNewClientMedicationScriptDrugs["CreatedDate"] = DateTime.Now;

                                    drNewClientMedicationScriptDrugs["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                                    drNewClientMedicationScriptDrugs["ModifiedDate"] = DateTime.Now;

                                    drNewClientMedicationScriptDrugs["DrugCategory"] = drClientMedicationScriptDrugs[j]["DrugCategory"];
                                    dsClientMedications.Tables["ClientMedicationScriptDrugs"].Rows.Add(drNewClientMedicationScriptDrugs);
                                    //drClientMedicationScriptDrugs[j].Delete();
                                    newScriptDrugId++;
                                }
                                //drClientMedicationInstructions[i].Delete();
                                //newInstructionId++;
                            }

                            DataRow[] drClientMedicationScriptDrugStrengths = dsClientMedications.Tables["ClientMedicationScriptDrugStrengths"].Select("ClientMedicationId=" + drClientMedications[index]["ClientMedicationId"] + " and ISNULL(RecordDeleted,'N')<>'Y'");
                            for (int k = 0; k < drClientMedicationScriptDrugStrengths.Length; k++)
                            {
                                drClientMedicationScriptDrugStrengths[k].AcceptChanges();
                                //drClientMedicationScriptDrugStrengths[k]["RecordDeleted"] = "Y";
                                //drClientMedicationScriptDrugStrengths[k]["DeletedDate"] = System.DateTime.Now;
                                //drClientMedicationScriptDrugStrengths[k]["DeletedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;

                                //drClientMedicationScriptDrugStrengths[k].SetModified();
                                DataRow drNewClientMedicationScriptDrugStrengths = dsClientMedications.Tables["ClientMedicationScriptDrugStrengths"].NewRow();
                                drNewClientMedicationScriptDrugStrengths["ClientMedicationScriptDrugStrengthId"] = newScriptDrugStrengthId;
                                drNewClientMedicationScriptDrugStrengths["ClientMedicationScriptId"] = System.DBNull.Value;
                                drNewClientMedicationScriptDrugStrengths["Pharmacy"] = drClientMedicationScriptDrugStrengths[k]["Pharmacy"];
                                drNewClientMedicationScriptDrugStrengths["PharmacyText"] = drClientMedicationScriptDrugStrengths[k]["PharmacyText"];
                                drNewClientMedicationScriptDrugStrengths["Sample"] = drClientMedicationScriptDrugStrengths[k]["Sample"];
                                drNewClientMedicationScriptDrugStrengths["Stock"] = drClientMedicationScriptDrugStrengths[k]["Stock"];
                                drNewClientMedicationScriptDrugStrengths["StrengthId"] = drClientMedicationScriptDrugStrengths[k]["StrengthId"];
                                drNewClientMedicationScriptDrugStrengths["ClientMedicationId"] = drNewClientMedication["ClientMedicationId"];
                                drNewClientMedicationScriptDrugStrengths["Refills"] = drClientMedicationScriptDrugStrengths[k]["Refills"];

                                drNewClientMedicationScriptDrugStrengths["RowIdentifier"] = System.Guid.NewGuid();
                                drNewClientMedicationScriptDrugStrengths["CreatedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                                drNewClientMedicationScriptDrugStrengths["CreatedDate"] = DateTime.Now;

                                drNewClientMedicationScriptDrugStrengths["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                                drNewClientMedicationScriptDrugStrengths["ModifiedDate"] = DateTime.Now;
                                dsClientMedications.Tables["ClientMedicationScriptDrugStrengths"].Rows.Add(drNewClientMedicationScriptDrugStrengths);
                                //drClientMedicationScriptDrugStrengths[k].Delete();
                                newScriptDrugStrengthId++;
                            }
                            //drClientMedications[index].Delete();
                            newClientMedicationId++;
                        }





                    }
                }
                else { NonOrderMedicationResult = "update"; } //"AddMedicationAdded"; }
                //Modified By Chandan on 18th March 2008 Task #2377               
                if (dsClientMedications != null)
                {
                    if (dsClientMedications.Tables["ClientMedications"].Rows.Count == 0)
                    {
                        ScriptManager.RegisterStartupScript(this.Label1, Label1.GetType(), ClientID.ToString(), "ClientMedicationNonOrder.ShowErrorUpdate();", true);
                        return false;
                    }

                    if (dsClientMedications.Tables["ClientMedications"].Select("isnull(recorddeleted,'N')='N'").Length < 1)
                    {
                        //Contiton added by Loveena in ref to Task#2934 -  Non Ordered Meds - Do not require date initiated
                        ////First Check the Validations
                        //if (TextBoxStartDate.Text == "")
                        //{
                        //    ScriptManager.RegisterStartupScript(ButtonUpdate, ButtonUpdate.GetType(), ClientID.ToString(), "ErrorUpdate('Please enter medication start date');", true);                            
                        //    return false;
                        //}

                        //Modified by : Malathi Shiva : Core Bugs Task# 2210 
                        //When we delete a Medication and click on update from Add Medication screen It does not save the changes becuase it enter the below if statement
                        //The Hiddenfield gets set only when we click on the radio button on Add Medication 
                        //When try to delete a medication without selecting the radio button and delete It does not udpate into the db when we click on Update button
                        if (HiddenMedicationNameId.Value == "" && dsClientMedications.Tables["ClientMedications"].Select("MedicationNameId is NULL").Length > 0)
                        {
                            ScriptManager.RegisterStartupScript(ButtonUpdate, ButtonUpdate.GetType(), ClientID.ToString(), "ErrorUpdate('Please enter Drug Name.');", true);
                            return false;
                        }
                        #region CommentedCode
                        //Commented by Loveena as ref to task#145 not to add blank row in ClientMedications on deletion of MEdication.

                        /* BlankRow = dsClientMedications.Tables["ClientMedications"].NewRow();
                         BlankRow["MedicationStartDate"] = DateTime.Parse(TextBoxStartDate.Text).ToShortDateString();
                         BlankRow["MedicationEndDate"] = DBNull.Value;
                         BlankRow["MedicationNameId"] = HiddenMedicationNameId.Value;

                         BlankRow["DrugPurpose"] = HiddenDrugPurpose.Value;
                         BlankRow["DSMCode"] = HiddenDSMCode.Value;
                         BlankRow["DxId"] = HiddenDxId.Value;
                         if (HiddenDSMNumber.Value != "")
                         {
                             BlankRow["DSMNumber"] = Convert.ToInt32(HiddenDSMNumber.Value);
                         }
                         else
                         {
                             BlankRow["DSMNumber"] = System.DBNull.Value;
                         }
                         BlankRow["PrescriberName"] = HiddenPrescriberName.Value;
                         if (HiddenPrescriberId.Value != "")
                             BlankRow["PrescriberId"] = Convert.ToInt32(HiddenPrescriberId.Value);
                         else
                             BlankRow["PrescriberId"] = System.DBNull.Value;
                         BlankRow["SpecialInstructions"] = TextBoxSpecialInstructions.Text;
                         BlankRow["MedicationName"] = HiddenMedicationName.Value;
                         BlankRow["RowIdentifier"] = System.Guid.NewGuid().ToString();
                         BlankRow["ClientId"] = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId;
                         BlankRow["CreatedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                         BlankRow["CreatedDate"] = DateTime.Now;
                         BlankRow["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                         BlankRow["ModifiedDate"] = DateTime.Now;
                         BlankRow["RecordDeleted"] = System.DBNull.Value;
                         BlankRow["DeletedBy"] = DBNull.Value;
                         BlankRow["DeletedDate"] = DBNull.Value;
                         BlankRow["DAW"] = System.DBNull.Value;
                         int Pos = dsClientMedications.Tables["ClientMedications"].Rows.Count;
                         dsClientMedications.Tables["ClientMedications"].Rows.InsertAt(BlankRow, Pos);*/
                        #endregion
                    }
                }

                //Modified End By Chandan on 18th March 2008 Task #2377



                ClientMedication objClientMedication = new ClientMedication();
                if (dsClientMedications != null)
                {
                    //foreach (DataRow drInteraction in dsClientMedications.ClientMedicationInteractions.Select("InteractionLevel='1' and isnull(recorddeleted,'N') <> 'Y'"))
                    //{
                    DataRow[] drInteraction = dsClientMedications.ClientMedicationInteractions.Select("InteractionLevel='1' and isnull(recorddeleted,'N') <> 'Y'");
                    if (drInteraction.Length > 0)
                    {
                        foreach (DataRow drTemp in drInteraction)
                        {
                            //if (drInteraction["PrescriberAcknowledged"] == DBNull.Value || drInteraction["PrescriberAcknowledged"].ToString() != "Y")
                            if (drTemp["PrescriberAcknowledged"] == DBNull.Value || drTemp["PrescriberAcknowledged"].ToString() != "Y")
                            {
                                ScriptManager.RegisterStartupScript(ButtonUpdate, ButtonUpdate.GetType(), ClientID.ToString(), "NotAcknowledge();", true);
                                return false;
                            }
                        }
                    }
                    //}
                    else
                    {
                        DataRow[] drClientMedication = dsClientMedications.ClientMedications.Select("ISNULL(RecordDeleted,'N')='N'");
                        if (drClientMedication.Length > 0)
                        {
                            foreach (DataRow drtemp in drClientMedication)
                            {
                                DataRow[] drClientAllergyInteraction = dsClientMedications.ClientAllergiesInteraction.Select("isnull(AllergyType,'A')='A' and MedicationNameid in(" + drtemp["MedicationNameId"].ToString().Trim() + ")");
                                if (drClientAllergyInteraction.Length > 0)
                                {
                                    foreach (DataRow drtempAllergyInteractions in drClientAllergyInteraction)
                                    {
                                        //Code modified by Loveena in ref to Task#2983
                                        if ((drtempAllergyInteractions["AllergyType"].ToString().Trim().ToUpper() == "A") && (((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity)).AllowAllergyMedications == "Y" && Convert.ToString(drtemp["AllowAllergyMedications"]) != "Y")
                                        {
                                            ScriptManager.RegisterStartupScript(this.ButtonUpdate, ButtonUpdate.GetType(), ClientID.ToString(), "NotAcknowledge();", true);
                                            return false;
                                        }
                                    }
                                }
                            }

                        }
                    }
                    DataSet dsTemp = objClientMedication.UpdateDocuments(dsClientMedications);
                    Session["DataSetClientMedications"] = dsTemp;


                    //Modified by : Malathi Shiva : Core Bugs Task# 2210 
                    //When we insert a medication and click on close button without update and say "Yes" on the close pop up, the medicaiton was not saving becuase the screen was closing before save is completed.
                    //Added hiddenfield and attached the ButtonCancel to close the Add medicaition screen - This is an altenative to the redirectToManagementPage() called on close pop up - Yes click in the onCloseSucceeded()
                    if (HiddenCancelYes.Value == "Yes")
                    {
                        ScriptManager.RegisterStartupScript(ButtonCancel, ButtonCancel.GetType(), ClientID.ToString(), "redirectToManagementPage();", true);
                        HiddenCancelYes.Value = null;
                    }
                }
                return true;
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

                ScriptManager.RegisterStartupScript(ButtonUpdate, ButtonUpdate.GetType(), ClientID.ToString(), "ErrorUpdate();", true);
                return false;
            }

        }

        #endregion

        #region GetClientMedicationData

        private void GetClientMedicationData(int clientMedicationId)
        {
            ClientMedication objClientMedication = null;
            try
            {
                CommonFunctions.Event_Trap(this);
                objClientMedication = new ClientMedication();
                ObjectClientMedication.Merge(objClientMedication.GetClientMedicationData(clientMedicationId, ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId));
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
            finally
            {
                objClientMedication = null;
            }
        }

        #endregion

        #region placeholderdelete
        /// <summary>
        /// This function is used to Delete the Dynamic Row when user clicks on Delete button.
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void buttonDelete_Click(object sender, System.EventArgs e)
        {
            try
            {
                CommonFunctions.Event_Trap(this);
                ImageButton PictureBoxDeleteRow;
                PictureBoxDeleteRow = (ImageButton)sender;
                System.Web.UI.WebControls.TableCell pnl = (System.Web.UI.WebControls.TableCell)PictureBoxDeleteRow.Parent;

                string rowId = Convert.ToString(PictureBoxDeleteRow.Attributes["picTemp"].ToString());
                if (DataTableClientMedicationInstructions.Rows.Count > 0)
                {
                    DataRow[] drTemp = DataTableClientMedicationInstructions.Select("rowidentifier='" + rowId + "'");
                    if (drTemp.Length > 0)
                    {
                        //To set RecordDeleted Y so that they are not shown in MedicationList and also in Database.
                        drTemp[0]["RecordDeleted"] = "Y";
                        drTemp[0]["DeletedDate"] = Convert.ToDateTime(DateTime.Now.ToShortDateString());
                        drTemp[0]["DeletedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
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
                Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);

            }

        }


        #endregion




        protected void LinkButton1_Click(object sender, EventArgs e)
        {


        }



        protected void LinkButtonLogout_Click(object sender, EventArgs e)
        {
            Response.Redirect("MedicationLogin.aspx");
        }
    }
}


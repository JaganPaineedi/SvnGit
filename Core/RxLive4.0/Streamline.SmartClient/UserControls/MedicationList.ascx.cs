using System;
using System.Collections;
using System.Data;
using System.Drawing;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using Streamline.BaseLayer;
using Streamline.UserBusinessServices;
using Streamline.UserBusinessServices.DataSets;
using SharedTables = Streamline.UserBusinessServices.SharedTables;
using Streamline.SmartClient.WebServices;
using System.Linq;

namespace Streamline.SmartClient.UI
{
    // Modified by Kneale Alpers
    // ka03242011 fixed filter row issue causing over flow error

    public partial class UserControls_MedicationList : BaseActivityPage
    {
        public delegate void DeleteButtonClick(object sender, UserData e);

        public delegate void MedicationLabelClick(object sender, UserData e);

        public delegate void RadioButtonClick(object sender, UserData e);

        private readonly Hashtable htInformation = new Hashtable();
        private string _deleteRowMessage = "Are you sure you want to delete this row?";
        private string _drugAllergyTitle = "Drug/Allergy  Interaction Warnings";
        private MedicationList.AllergiesInteractionDataTable _dtMedicationAllergyTemp;

        private MedicationList.MedicationInstructionsDataTable _dtMedicationInstructionTemp;
        private MedicationList.MedicationInteractionsDataTable _dtMedicationInteractionTemp;
        private MedicationList.MedicationsDataTable _dtMedicationTemp;      
        private string _instructionsTitle = "Instruction";
        private string _onAcknowledgeClickEventHandler = "onAcknowledgeClick";
        private string _onButtonClickEventHandler = "MedicationPrescribe.onChButtonClick";
        private string _onCheckBoxClickEventHandler = "onCheckBoxClick";
        private string _onDAWClickEventHandler = "onDAWClick";
        private string _onDeleteEventHandler = "onDeleteClick";
        private string _onDeleteListItemEventHandler = "DeleateFromList";
        private string _onDrugInteractionClick = "onDrugInteractionClick";
        private string _onHeaderClick = "onHeaderClick";
        private string _onImageConsentClickEventHandler = "onImageConsentClick";
        private string _onLinkClickEventHandler = "onLinkClick";
        private string _onRadioClickEventHandler = "onRadioClick";
        private bool _showAcknowledge;
        private bool _showApprovalButton;
        private bool _showApprovalMessage;
        private bool _showButton;
        private bool _showEduInfoButton;  //sunil.D 07/07/2017  Add a column for natinalDrugCode #43 Meaningful Use
        private bool _showChButton;
        private bool _showCheckBox;
        private bool _showComments;
        private bool _showConsentIcon;
        private bool _showDAW;
        private bool _showDateInitiated = true;
        private bool _showDateInitiatedLabel;
        private bool _showDisContinueReasonLabel;
        private bool _showDrugWarning;
        private bool _showMedicationLink;
        private bool _showMedicationName = true;
        private bool _showMinScriptDrugsEndDate;
        private bool _showOffLabel;
        private bool _showOrderStatus;
        private bool _showOrderStatusDate;
        //Stert : Code added by Ankesh Bharti on 12/03/2008 with ref to Task # 77.
        private bool _showOrderedIcon;
        private bool _showPrescribedBy;
        private bool _showQuantity;
        private bool _showRadioButton;
        private bool _showRefill;
        private bool _showTitrateIcon;
        private string _sortString;
        private string method = "";
        private string strDiscontinuedMedications = "";

        private string _calledFromControllerName = "";

        public bool ShowOrderedIcon
        {
            get { return _showOrderedIcon; }
            set { _showOrderedIcon = value; }
        }

        //End : Code added by Ankesh Bharti on 12/03/2008 with ref to Task # 77.

        //Start : Code added by Loveena on 08-May-2009 with ref to Task # 2465.

        public bool ShowConentIcon
        {
            get { return _showConsentIcon; }
            set { _showConsentIcon = value; }
        }

        //End : Code added by Loveena on 08-May-2009 with ref to Task # 2465.
        //Added By Anuj as per task ref #3 on 16Nov,2009 SDI Projects FY10 - Venture

        public bool ShowApprovalButton
        {
            get { return _showApprovalButton; }
            set { _showApprovalButton = value; }
        }

        public bool ShowApprovalMessage
        {
            get { return _showApprovalMessage; }
            set { _showApprovalMessage = value; }
        }

        //Ended over here
        //Start: Ref to Task # 2389

        public bool ShowTitrateIcon
        {
            get { return _showTitrateIcon; }
            set { _showTitrateIcon = value; }
        }

        //End: Ref to Task # 2389

        public bool ShowDAW
        {
            get { return _showDAW; }
            set { _showDAW = value; }
        }

        //Code added by Loveena in ref to Task#2779

        public bool ShowComments
        {
            get { return _showComments; }
            set { _showComments = value; }
        }

        public Panel GetMedicationListPanel
        {
            get { return PanelMedicationList; }
        }

        public string DeleteRowMessage
        {
            get { return _deleteRowMessage; }
            set { _deleteRowMessage = value; }
        }


        public bool ShowPrescribedBy
        {
            get { return _showPrescribedBy; }
            set { _showPrescribedBy = value; }
        }

        public bool ShowAcknowledge
        {
            get { return _showAcknowledge; }
            set { _showAcknowledge = value; }
        }

        //changes as per Task #2377 needs to display OrderStatus and OrderStatusDate

        public bool ShowOrderStatus
        {
            get { return _showOrderStatus; }
            set { _showOrderStatus = value; }
        }

        public bool ShowOrderStatusDate
        {
            get { return _showOrderStatusDate; }
            set { _showOrderStatusDate = value; }
        }

        public bool ShowMedicationName
        {
            get { return _showMedicationName; }
            set { _showMedicationName = value; }
        }

        public bool ShowDateInitiated
        {
            get { return _showDateInitiated; }
            set { _showDateInitiated = value; }
        }

        public string onDeleteEventHandler
        {
            get { return _onDeleteEventHandler; }
            set { _onDeleteEventHandler = value; }
        }

        public string onRadioClickEventHandler
        {
            get { return _onRadioClickEventHandler; }
            set { _onRadioClickEventHandler = value; }
        }

        public string onButtonClickEventHandler
        {
            get { return _onButtonClickEventHandler; }
            set { _onButtonClickEventHandler = value; }
        }

        public string onAcknowledgeClickEventHandler
        {
            get { return _onAcknowledgeClickEventHandler; }
            set { _onAcknowledgeClickEventHandler = value; }
        }


        public string onDAWClickEventHandler
        {
            get { return _onDAWClickEventHandler; }
            set { _onDAWClickEventHandler = value; }
        }


        public string onCheckBoxClickEventHandler
        {
            get { return _onCheckBoxClickEventHandler; }
            set { _onCheckBoxClickEventHandler = value; }
        }


        public string onLinkClickEventHandler
        {
            get { return _onLinkClickEventHandler; }
            set { _onLinkClickEventHandler = value; }
        }

        //Added By anuj on 5 Nov,2009 in task ref # 18 SDI Projects FY10 - Venture

        public string onImageConsentClickEventHandler
        {
            get { return _onImageConsentClickEventHandler; }
            set { _onImageConsentClickEventHandler = value; }
        }

        //Changed Ended over here

        public string onDrugInteractionClick
        {
            get { return _onDrugInteractionClick; }
            set { _onDrugInteractionClick = value; }
        }

        public string OnHeaderClick
        {
            get { return _onHeaderClick; }
            set { _onHeaderClick = value; }
        }


        public string InstructionsTitle
        {
            get { return _instructionsTitle; }
            set { _instructionsTitle = value; }
        }

        public string DrugAllergyTitle
        {
            get { return _drugAllergyTitle; }
            set { _drugAllergyTitle = value; }
        }


        public bool ShowButton
        {
            get { return _showButton; }
            set { _showButton = value; }
        }
        public bool ShowEduInfoButton
        {
            get { return _showEduInfoButton; }
            set { _showEduInfoButton = value; }
        }

        public bool ShowChButton
        {
            get { return _showChButton; }
            set { _showChButton = value; }
        }

        public bool ShowAckButton { get; set; }


        public bool ShowDrugWarning
        {
            get { return _showDrugWarning; }
            set { _showDrugWarning = value; }
        }

        public bool ShowRadioButton
        {
            get { return _showRadioButton; }
            set { _showRadioButton = value; }
        }

        public bool ShowMedicationLink
        {
            get { return _showMedicationLink; }
            set { _showMedicationLink = value; }
        }


        public bool ShowRefill
        {
            get { return _showRefill; }
            set { _showRefill = value; }
        }

        public bool ShowQuantity
        {
            get { return _showQuantity; }
            set { _showQuantity = value; }
        }

        public bool ShowCheckBox
        {
            get { return _showCheckBox; }
            set { _showCheckBox = value; }
        }

        public string SortString
        {
            get { return _sortString; }
            set { _sortString = value; }
        }

        //Variable added with reference to Task #38 1.5.1 - Refill Screen: Start and Stop Date Initialization
        //To Display Min(StartDate) in case of refill only.

        public bool showMinScriptDrugsEndDate
        {
            get { return _showMinScriptDrugsEndDate; }
            set { _showMinScriptDrugsEndDate = value; }
        }

        //Added by Loveena in Ref to Task#128 to display Order Date in ViewMedicationHistory

        public bool showDateInitiatedLabel
        {
            get { return _showDateInitiatedLabel; }
            set { _showDateInitiatedLabel = value; }
        }

        //Added by Loveena in Ref to Task#2433 to display OffLabel in ViewMedicationHistory

        public bool showOffLabel
        {
            get { return _showOffLabel; }
            set { _showOffLabel = value; }
        }

        //Added by Loveena in Ref to Task#2433 to display DisContinueReason in ViewMedicationHistory

        public bool showDisContinueReasonLabel
        {
            get { return _showDisContinueReasonLabel; }
            set { _showDisContinueReasonLabel = value; }
        }

        #region Code with reference to Task # 75

        private bool _showCumulativeInfo;
        private bool _showDateWarning;
        private bool _showDayNo;
        private bool _showDays;
        private bool _showPharmacy;
        private bool _showSample;
        private bool _showStepNo;
        private bool _showStock;

        public bool ShowStepNo
        {
            get { return _showStepNo; }
            set { _showStepNo = value; }
        }

        public bool ShowDayNo
        {
            get { return _showDayNo; }
            set { _showDayNo = value; }
        }

        public bool ShowDateWarning
        {
            get { return _showDateWarning; }
            set { _showDateWarning = value; }
        }

        public bool ShowDays
        {
            get { return _showDays; }
            set { _showDays = value; }
        }

        public bool ShowPharmacy
        {
            get { return _showPharmacy; }
            set { _showPharmacy = value; }
        }

        public bool ShowSample
        {
            get { return _showSample; }
            set { _showSample = value; }
        }

        public bool ShowStock
        {
            get { return _showStock; }
            set { _showStock = value; }
        }

        public bool ShowCumulativeInfo
        {
            get { return _showCumulativeInfo; }
            set { _showCumulativeInfo = value; }
        }

        #endregion

        protected override void Page_Load(object sender, EventArgs e)
        {
        }

        protected void page_init()
        {
            if (Context.User.Identity.IsAuthenticated)
            {
                //FormsAuthentication.SignOut(); 
                if (!(Context.User is StreamlinePrinciple))
                {
                    // ASP.NET's regular forms authentication picked up our cookie, but we
                    // haven't replaced the default context user with our own. Let's do that
                    // now. We know that the previous context.user.identity.name is the e-mail
                    // address (because we forced it to be as such in the login.aspx page)	
                    var newUser = Session["UserContext"] as StreamlinePrinciple;
                    Context.User = newUser;
                }
            }
            else
            {
                FormsAuthentication.RedirectToLoginPage();
            }
        }

        public event RadioButtonClick RadioButtonClickEvent;
        public event DeleteButtonClick DeleteButtonClickEvent;

        public void Activate(string controllerName)
        {
            _calledFromControllerName = controllerName;
            Activate();
        }

        public override void Activate()
        {
            try
            {
                CommonFunctions.Event_Trap(this);
                base.Activate();
                _dtMedicationTemp = new MedicationList.MedicationsDataTable();
                _dtMedicationInstructionTemp = new MedicationList.MedicationInstructionsDataTable();
                _dtMedicationInteractionTemp = new MedicationList.MedicationInteractionsDataTable();
                _dtMedicationAllergyTemp = new MedicationList.AllergiesInteractionDataTable();
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

        private string setAttributes()
        {
            if (_sortString == "")
            {
                return "";
            }
            else if (_sortString.Contains("Desc"))
            {
                return "Asc";
            }
            else if (_sortString.Contains("Asc"))
            {
                return "Desc";
            }
            else
            {
                return "";
            }
        }

        /// <summary>
        /// </summary>
        /// -----------ModificationHistory--------------
        /// ---Date----Author---------Purpose-----------
        /// 4 Nov,2009 Pradeep       Made changes as per task#9(Venture)
        private void GenerateRows()
        {
            string rowClass = string.Empty;
            if (_calledFromControllerName == "ViewMedicationHistory")
            {
                rowClass = "RowStyle";
            }
            else
            {
                rowClass = "GridViewRowStyle";
            }
            //Variable _boolRowWithInteractionFound declared by Sonia
            //Ref Task #82 Acknowledge button should be displayed if a Client Medication has interaction with both types of medications i.e with severity level 1 & 3

            bool _boolRowWithInteractionFound = false;
            string COMPLETEORDERSTORX = "N";

            Streamline.DataService.SharedTables objSharedTables = new Streamline.DataService.SharedTables();
            if (Streamline.UserBusinessServices.SharedTables.DataSetSystemConfigurationKeys != null)
            {
                if (Streamline.UserBusinessServices.SharedTables.DataSetSystemConfigurationKeys.Tables.Count > 0)
                {
                    COMPLETEORDERSTORX = objSharedTables.GetSystemConfigurationKeys("COMPLETEORDERSTORX", Streamline.UserBusinessServices.SharedTables.DataSetSystemConfigurationKeys.Tables[0]);

                }
            }
            DataSet datasetSystemConfigurationKeys = null;
            datasetSystemConfigurationKeys = objSharedTables.GetSystemConfigurationKeys();
            if (objSharedTables.GetSystemConfigurationKeys("SWITCHRXMEDICATIONCONSENTOFF", datasetSystemConfigurationKeys.Tables[0]).ToUpper() == "Y")
            {
                _showConsentIcon = false;
            }
            try
            {
                CommonFunctions.Event_Trap(this);

                Color[] _color =
                    {
                        Color.Pink,
                        Color.Red,
                        Color.Yellow,
                        Color.Green,
                        Color.Plum,
                        Color.Aqua,
                        Color.PaleGoldenrod,
                        Color.Peru,
                        Color.Tan,
                        Color.Khaki,
                        Color.DarkGoldenrod,
                        Color.Maroon,
                        Color.OliveDrab,
                        //Added by Chandan on 21st Nov 2008 for Adding new colors on Monograph Boxes.
                        Color.Crimson,
                        Color.Beige,
                        Color.DimGray,
                        Color.ForestGreen,
                        Color.Indigo,
                        Color.LightCyan
                        //Added End here by Chanda
                    };


                PanelMedicationList.Controls.Clear();
                var tblMedication = new Table();
                tblMedication.ID = Guid.NewGuid().ToString();


                tblMedication.Width = new Unit(100, UnitType.Percentage);
                var thTitle = new TableHeaderRow();
                var thcBlank1 = new TableHeaderCell();
                thcBlank1.Width = 24;
                // Start:Code added by Ankesh Bharti on 12/01/2008 for new column having image indicating record is for ordered with ref to Task # 77.  
                var thcOrderIcon = new TableHeaderCell();
                // End:Code added by Ankesh Bharti on 12/01/2008 for new column having image indicating record is for ordered with ref to Task # 77. 

                //Code Added By Anuj on 16 nov for task ref #3(adding a new column in header for verbalOrderApproval/WaitingPrescriberApproval
                var thcApprovalButton = new TableHeaderCell();
                //Code Ended over here


                //Start: Ref to Task # 2389
                var thcTitrateIcon = new TableHeaderCell();
                //End: Ref to Task # 2389

                // Code added by Loveena in ref to Task#2465 to display Consent Icon on 08-May-2009.
                var thcConsentIcon = new TableHeaderCell();
                //Code ends over here.

                var thcBlank2 = new TableHeaderCell();
                var thcBlank3 = new TableHeaderCell();
                var thcBlank4 = new TableHeaderCell();
                var thcBlank5 = new TableHeaderCell();  

                var thcEduInfo = new TableHeaderCell();
                thcEduInfo.Style.Add("width", "3%");
               // thcEduInfo.Style.Add("align", "center");
                //sunil.D 07/07/2017  Add a column for natinalDrugCode #43 Meaningful Use

                var thcStartDate = new TableHeaderCell();
                //Added by Loveena in Ref to Task#128 to display Order Date in case of ViewMedicationHistory.
                if (showDateInitiatedLabel)
                {
                    thcStartDate.Text = "Order Date";
                    thcStartDate.Style.Add("width", "15%");
                }
                else
                {
                    thcStartDate.Style.Add("width", "17%");
                    thcStartDate.Text = "Date Initiated";
                }
               // thcStartDate.Font.Underline = true;              
                thcStartDate.Attributes.Add("ColumnName", "MedicationStartDate");
                if (_calledFromControllerName != "ViewMedicationHistory")
                {
                    thcStartDate.Attributes.Add("onClick", "onHeaderClick(this)");  
                    thcStartDate.Attributes.Add("SortOrder", setAttributes());
                }
                //Added bt Loveena on 05-Jan-2009
                if (_dtMedicationTemp.Rows.Count > 0)
                    thcStartDate.CssClass = "handStyle";

                thcStartDate.Style.Add("width", "8.8%");
                //thcStartDate.Style.Add("text-align", "center");

                var thcMedication = new TableHeaderCell();
                thcMedication.Text = "Medication";
                //thcMedication.Font.Underline = true;                           
                thcMedication.Attributes.Add("ColumnName", "MedicationName");
                if (_calledFromControllerName != "ViewMedicationHistory")
                {
                    thcMedication.Attributes.Add("onClick", "onHeaderClick(this)");
                    thcMedication.Attributes.Add("SortOrder", setAttributes());
                }
                thcMedication.Style.Add("width", "10%");

                //Added bt Loveena on 05-Jan-2009
                if (_dtMedicationTemp.Rows.Count > 0)
                    thcMedication.CssClass = "handStyle";

                //Start:Code In ref to task # 75
                var thcStepNumber = new TableHeaderCell();
                thcStepNumber.Text = "Step #";
                //thcStepNumber.Font.Underline = true;                               
                thcStepNumber.Attributes.Add("ColumnName", "TitrationStepNumber");
                if (_calledFromControllerName != "ViewMedicationHistory")
                {
                    thcStepNumber.Attributes.Add("onClick", "onHeaderClick(this)");   
                    thcStepNumber.Attributes.Add("SortOrder", setAttributes());
                }
                if (_dtMedicationTemp.Rows.Count > 0)
                    thcStepNumber.CssClass = "handStyle";

                var thcDayNumber = new TableHeaderCell();
                thcDayNumber.Text = "Day #";
                //thcDayNumber.Font.Underline = true;                      
                thcDayNumber.Attributes.Add("ColumnName", "DayNumber");
                if (_calledFromControllerName != "ViewMedicationHistory")
                {
                    thcDayNumber.Attributes.Add("onClick", "onHeaderClick(this)");   
                    thcDayNumber.Attributes.Add("SortOrder", setAttributes());
                }
                if (_dtMedicationTemp.Rows.Count > 0)
                    thcDayNumber.CssClass = "handStyle";
                //End:Code In ref to task # 75

                var thcInstructions = new TableHeaderCell();
                thcInstructions.Text = _instructionsTitle;
               // thcInstructions.Font.Underline = true;                
                thcInstructions.Attributes.Add("ColumnName", "Instruction");
                if (_calledFromControllerName != "ViewMedicationHistory")
                {
                    thcInstructions.Attributes.Add("onClick", "onHeaderClick(this)");
                    thcInstructions.Attributes.Add("SortOrder", setAttributes());
                }
                thcInstructions.Style.Add("width", "10%");
                //Added bt Loveena on 05-Jan-2009
                if (_dtMedicationTemp.Rows.Count > 0)
                    thcInstructions.CssClass = "handStyle";

                //Start:Code In ref to task # 75
                var thcDateWarning = new TableHeaderCell();
                //End:Code In ref to task # 75

                //Added by Chandan on 12th Dec 2008 task#127 1.7 - Main Page Medications List Layout Changes
                var thcMedicationStartDate = new TableHeaderCell();
                thcMedicationStartDate.Text = "Rx Start";
                thcMedicationStartDate.Style.Add("width", "7%");
               // thcMedicationStartDate.Style.Add("text-align", "center");
                //thcMedicationStartDate.Font.Underline = true;                 
                //Ref to Task#2658
                thcMedicationStartDate.Attributes.Add("ColumnName", "StartDate");
                //Code ends over here.
                if (_calledFromControllerName != "ViewMedicationHistory")
                {
                    thcMedicationStartDate.Attributes.Add("onClick", "onHeaderClick(this)");
                    thcMedicationStartDate.Attributes.Add("SortOrder", setAttributes());
                }
                //Added bt Loveena on 05-Jan-2009
                if (_dtMedicationTemp.Rows.Count > 0)
                    thcMedicationStartDate.CssClass = "handStyle";

                //Start:Code In ref to task # 75
                var thcDays = new TableHeaderCell();
                thcDays.Text = "Days";
               // thcDays.Font.Underline = true;                            
                thcDays.Attributes.Add("ColumnName", "Days");
                if (_calledFromControllerName != "ViewMedicationHistory")
                {
                    thcDays.Attributes.Add("onClick", "onHeaderClick(this)");   
                    thcDays.Attributes.Add("SortOrder", setAttributes());
                }
                if (_dtMedicationTemp.Rows.Count > 0)
                    thcDays.CssClass = "handStyle";
                //End:Code In ref to task # 75


                var thcMedicationEndDate = new TableHeaderCell();
                thcMedicationEndDate.Text = "Rx End";
                thcMedicationEndDate.Style.Add("width", "7%");
               // thcMedicationEndDate.Style.Add("text-align", "center");
                //thcMedicationEndDate.Font.Underline = true;
                //Modified by Loveena in ref to Task#2658
                thcMedicationEndDate.Attributes.Add("ColumnName", "EndDate");
                if (_calledFromControllerName != "ViewMedicationHistory")
                {
                    thcMedicationEndDate.Attributes.Add("onClick", "onHeaderClick(this)");
                    thcMedicationEndDate.Attributes.Add("SortOrder", setAttributes());
                }
                //Added bt Loveena on 05-Jan-2009
                if (_dtMedicationTemp.Rows.Count > 0)
                    thcMedicationEndDate.CssClass = "handStyle";


                if (_drugAllergyTitle == "")
                    _drugAllergyTitle = "Interactions";
                //End By Chandan

                var thcWarning = new TableHeaderCell();
                thcWarning.Text = _drugAllergyTitle;
               // thcWarning.Font.Underline = true;
                var thcPrescribed = new TableHeaderCell();
                thcPrescribed.Text = "Prescribed By";
               // thcPrescribed.Font.Underline = true;
                thcPrescribed.Attributes.Add("ColumnName", "PrescriberName");
                if (_calledFromControllerName != "ViewMedicationHistory")
                {
                    thcPrescribed.Attributes.Add("onClick", "onHeaderClick(this)");    
                    thcPrescribed.Attributes.Add("SortOrder", setAttributes());
                }
                //Start Added By Pradeep Task#32
                var thcComments = new TableHeaderCell();
                thcComments.Text = "Comments";
                //END Added By Pradeep Task#32
                //Added bt Loveena on 05-Jan-2009
                if (_dtMedicationTemp.Rows.Count > 0)
                    thcPrescribed.CssClass = "handStyle";


                //Changes as per Task #2381 and 2377 SC-Support

                var thcOrderStatus = new TableHeaderCell();
                thcOrderStatus.Text = "Order Status";
                thcOrderStatus.Style.Add("width", "5%");
                //thcOrderStatus.Style.Add("text-align", "center");
               // thcOrderStatus.Font.Underline = true;
                thcOrderStatus.Attributes.Add("ColumnName", "OrderStatus");
                if (_calledFromControllerName != "ViewMedicationHistory")
                {
                    thcOrderStatus.Attributes.Add("onClick", "onHeaderClick(this)");     
                    thcOrderStatus.Attributes.Add("SortOrder", setAttributes());
                }
                //Added bt Loveena on 05-Jan-2009
                if (_dtMedicationTemp.Rows.Count > 0)
                    thcOrderStatus.CssClass = "handStyle";


                var thcOrderStatusDate = new TableHeaderCell();
                thcOrderStatusDate.Text = "Order Status Date";
                thcOrderStatusDate.Style.Add("width", "8.8%");
               // thcOrderStatusDate.Style.Add("text-align", "center");
               // thcOrderStatusDate.Font.Underline = true;
                thcOrderStatusDate.Attributes.Add("ColumnName", "OrderStatusDate");
                if (_calledFromControllerName != "ViewMedicationHistory")
                {
                    thcOrderStatusDate.Attributes.Add("onClick", "onHeaderClick(this)");   
                    thcOrderStatusDate.Attributes.Add("SortOrder", setAttributes());
                }
                //Added bt Loveena on 05-Jan-2009
                if (_dtMedicationTemp.Rows.Count > 0)
                    thcOrderStatusDate.CssClass = "handStyle";

                //Added by Loveena in ref to Task#2433 to display OffLabel Column in View History.
                //Code Added by : Malathi Shiva 
                //With Ref to task# : 33 - Community Network Services
                var thcOffLabel = new TableHeaderCell();
                if (((StreamlinePrinciple)Context.User).HasPermission(Permissions.OffLabel))
                {
                    thcOffLabel.Text = "Off Label";
                    thcOffLabel.Style.Add("width", "5%");
                   // thcOffLabel.Style.Add("text-align", "center");
                   // thcOffLabel.Font.Underline = true;
                    thcOffLabel.Attributes.Add("ColumnName", "OffLabel");
                    if (_calledFromControllerName != "ViewMedicationHistory")
                    {
                        thcOffLabel.Attributes.Add("onClick", "onHeaderClick(this)");      
                        thcOffLabel.Attributes.Add("SortOrder", setAttributes());
                    }
                    //Added bt Loveena on 05-Jan-2009
                    if (_dtMedicationTemp.Rows.Count > 0)
                        thcOffLabel.CssClass = "handStyle";
                }
                //Added by Loveena in ref to Task#2433 to display DiscontinuedReason Column in View History.
                var thcDiscontinuedReason = new TableHeaderCell();
                thcDiscontinuedReason.Text = "Discontinue Reason";
                //thcDiscontinuedReason.Font.Underline = true;
                thcDiscontinuedReason.Attributes.Add("ColumnName", "DiscontinuedReason");
                if (_calledFromControllerName != "ViewMedicationHistory")
                {
                    thcDiscontinuedReason.Attributes.Add("onClick", "onHeaderClick(this)");   
                    thcDiscontinuedReason.Attributes.Add("SortOrder", setAttributes());
                }
                thcDiscontinuedReason.Style.Add("width", "15%");
                //Added bt Loveena on 05-Jan-2009
                if (_dtMedicationTemp.Rows.Count > 0)
                    thcDiscontinuedReason.CssClass = "handStyle";


                //Code added by Anto in ref to CEI - Support Go Live #142
                var thcMedicationPharmacy = new TableHeaderCell();
                thcMedicationPharmacy.Text = "Pharmacy";
                thcMedicationPharmacy.Style.Add("width", "3%");
               // thcMedicationPharmacy.Style.Add("text-align", "center");
               // thcMedicationPharmacy.Font.Underline = true;
                thcMedicationPharmacy.Attributes.Add("ColumnName", "Pharmacy");
                if (_calledFromControllerName != "ViewMedicationHistory")
                {
                    thcMedicationPharmacy.Attributes.Add("onClick", "onHeaderClick(this)");  
                    thcMedicationPharmacy.Attributes.Add("SortOrder", setAttributes());
                }
                if (_dtMedicationTemp.Rows.Count > 0)
                    thcMedicationPharmacy.CssClass = "handStyle";
                //Code ends here in ref to CEI - Support Go Live #142

                var thcAddedBy = new TableHeaderCell();
                thcAddedBy.Text = "Added By";
                thcAddedBy.Style.Add("width", "10%");
               // thcAddedBy.Style.Add("text-align", "center");
               // thcAddedBy.Font.Underline = true;
                thcAddedBy.Attributes.Add("ColumnName", "AddedBy");
                if (_calledFromControllerName != "ViewMedicationHistory")
                {
                    thcAddedBy.Attributes.Add("onClick", "onHeaderClick(this)");  
                    thcAddedBy.Attributes.Add("SortOrder", setAttributes());
                }
                if (_dtMedicationTemp.Rows.Count > 0)
                    thcAddedBy.CssClass = "handStyle";

                var thcDiscontinuedBy = new TableHeaderCell();
                thcDiscontinuedBy.Text = "Discontinued By";
                thcDiscontinuedBy.Style.Add("width", "10%");
                //thcDiscontinuedBy.Style.Add("text-align", "center");
                //thcDiscontinuedBy.Font.Underline = true;
                thcDiscontinuedBy.Attributes.Add("ColumnName", "DiscontinuedBy");
                if (_calledFromControllerName != "ViewMedicationHistory")
                {
                    thcDiscontinuedBy.Attributes.Add("onClick", "onHeaderClick(this)"); 
                    thcDiscontinuedBy.Attributes.Add("SortOrder", setAttributes());
                }
                if (_dtMedicationTemp.Rows.Count > 0)
                    thcDiscontinuedBy.CssClass = "handStyle";

                var thcDAW = new TableHeaderCell();
                thcDAW.Text = "DAW";
                //thcDAW.Font.Underline = true;
                var thcQty = new TableHeaderCell();
                //Code added by Loveena in ref to Task#2802
                thcQty.Text = "Dose";
               // thcQty.Font.Underline = true;
                var thcRefills = new TableHeaderCell();
                thcRefills.Text = "Refills";
                //thcRefills.Font.Underline = true;
                var thcAcknowledge = new TableHeaderCell();
                thcAcknowledge.Text = "";


                var thcPharmacy = new TableHeaderCell();
                //Code added by Loveena in ref to Task#2802
                thcPharmacy.Text = "Dispense Qty";
                //thcPharmacy.Font.Underline = true;
                var thcSample = new TableHeaderCell();
                thcSample.Text = "Sample";
               // thcSample.Font.Underline = true;
                var thcStock = new TableHeaderCell();
                thcStock.Text = "Stock";
               // thcStock.Font.Underline = true;
                var thcCumulativeInfo = new TableHeaderCell();
                thcCumulativeInfo.Text = "";


                if (_showRadioButton)
                    thTitle.Cells.Add(thcBlank1);
                if (_showCheckBox)
                    thTitle.Cells.Add(thcBlank2);
                //Code added by Ankesh Bharti on 12/02/2008 with ref to Task # 77.
                if (_showOrderedIcon)
                    thTitle.Cells.Add(thcOrderIcon);
                //Ref to Task #2389

                //Added By Anuj on 16Nov,2009 for task ref #3 SDI Projects FY10 - Venture
                if (_showApprovalButton)
                    thTitle.Cells.Add(thcApprovalButton);
                //Ended over here

                if (_showTitrateIcon)
                    thTitle.Cells.Add(thcTitrateIcon);
                if (_showChButton)
                    thTitle.Cells.Add(thcBlank3);
                if (_showButton)
                    thTitle.Cells.Add(thcBlank4);
                if (_calledFromControllerName == "ViewMedicationHistory")
                {
                    thTitle.Cells.Add(thcBlank5);
                }
                if (_calledFromControllerName == "MedicationMgt" || _calledFromControllerName == "ClientMedicationOrder")
                    thTitle.Cells.Add(thcEduInfo);

                if (_showMedicationName)
                    thTitle.Cells.Add(thcMedication);
                //Code added by Loveena in ref to Task#2465 on 08-May-2009
                if (_showConsentIcon)
                    thTitle.Cells.Add(thcConsentIcon);
                //Code ends over here.

                if (_showDateInitiated)
                    thTitle.Cells.Add(thcStartDate);

                //Start: Code in ref to task # 75
                if (_showStepNo)
                    thTitle.Cells.Add(thcStepNumber);
                if (_showDayNo)
                    thTitle.Cells.Add(thcDayNumber);
                //End: Code in ref to task # 75

                thTitle.Cells.Add(thcInstructions);

                //Start: Code in ref to task # 75
                if (_showDateWarning)
                    thTitle.Cells.Add(thcDateWarning);
                //End: Code in ref to task # 75

                //Added by Chandan on 12th Dec 2008 task#127 1.7 - Main Page Medications List Layout Changes
                thTitle.Cells.Add(thcMedicationStartDate);

                //Start: Code in ref to task # 75
                if (_showDayNo)
                    thTitle.Cells.Add(thcDays);
                //End: Code in ref to task # 75

                thTitle.Cells.Add(thcMedicationEndDate);


                if (_showQuantity)
                    thTitle.Cells.Add(thcQty);
                if (_showRefill)
                    thTitle.Cells.Add(thcRefills);
                if (_showDAW)
                    thTitle.Cells.Add(thcDAW);
                if (_showDrugWarning)
                    thTitle.Cells.Add(thcWarning);
                if (_showPrescribedBy)
                    thTitle.Cells.Add(thcPrescribed);
                //----Start By Pradeep as per task#32
                //Modified by Loveena in ref to Task#2779

                //Code added by anto in ref to task CEI - Support Go Live #142
                if (_calledFromControllerName == "MedicationMgt")
                    thTitle.Cells.Add(thcMedicationPharmacy);
                //Code ends here in ref to task CEI - Support Go Live #142
                if (_showComments)
                    thTitle.Cells.Add(thcComments);
                //----End By Pradeep as per task#32
                if (_showAcknowledge)
                    thTitle.Cells.Add(thcAcknowledge);
                //Changes as per Task #2381
                if (_showOrderStatus)
                    thTitle.Cells.Add(thcOrderStatus);
                if (_showOrderStatusDate)
                    thTitle.Cells.Add(thcOrderStatusDate);
                //Added by Loveena in ref to Task#2433 to display OffLabel Column in View History.
                if (_showOffLabel)
                    thTitle.Cells.Add(thcOffLabel);
                //Added by Loveena in ref to Task#2433 to display DiscontinuedReason Column in View History.

                if (_calledFromControllerName == "ViewMedicationHistory" || _calledFromControllerName == "MedicationMgt")
                {
                    thTitle.Cells.Add(thcAddedBy);
                    //thTitle.Cells.Add(thcDiscontinuedBy);
                }

                if (_calledFromControllerName == "ViewMedicationHistory")
                {
                    thTitle.Cells.Add(thcDiscontinuedBy);                   
                }


                if (_showDisContinueReasonLabel)
                    thTitle.Cells.Add(thcDiscontinuedReason);
                //Start: Code in ref to task # 75
                if (_showPharmacy)
                    thTitle.Cells.Add(thcPharmacy);
                if (_showSample)
                    thTitle.Cells.Add(thcSample);
                if (_showStock)
                    thTitle.Cells.Add(thcStock);
                if (_showCumulativeInfo)
                    thTitle.Cells.Add(thcCumulativeInfo);
                //End: Code in ref to task # 75

                thTitle.CssClass = "GridViewHeaderText";

                tblMedication.Rows.Add(thTitle);

                #region Added By Pramod on 9 Apr 2008 as client don't want message if user has no permission

                string myscript = "<script id='MedicationListScript' type='text/javascript'>";
                myscript += "function $deleteRecord(sender,e){";
                if (!string.IsNullOrEmpty(_deleteRowMessage))
                {
                   
                       // myscript += " if(confirm('" + _deleteRowMessage + " ')==true){ " + (_calledFromControllerName != "" ? _calledFromControllerName + "." : "") + _onDeleteListItemEventHandler +
                                 //   "(sender,e);  }}";
                   
                        myscript += _calledFromControllerName + "." + _onDeleteListItemEventHandler + "(sender,e);  }";
                  
                }
                else
                {
                    myscript += "}";
                }

                #endregion

                myscript += "function RegisterMedicationListControlEvents(){try{ ";


                int ColorCounter = 0;

                bool _OrderApprovalMessageShown = false;

                if (_dtMedicationTemp.Rows.Count > 0)
                {  
                    if (_calledFromControllerName == "ViewMedicationHistory")
                    {
                        DataView dv = _dtMedicationTemp.DefaultView;
                        dv.Sort = "Discontinued ASC,MedicationId DESC,OrderStatusDate DESC,Row# DESC ";
                        DataTable dt = dv.ToTable();
                        var list = dv.ToTable(true, "MedicationId").Rows.Cast<DataRow>().Select(row => row["MedicationId"]).ToList();
                        foreach (var MedId in list)
                        {
                            int medicationId = Convert.ToInt32(MedId);
                            DataRow[] data = dt.Select("MedicationId=" + medicationId);
                            int HRowNo;
                            if (data.Length > 1)
                            {
                                 var dr = data.OfType<DataRow>().FirstOrDefault<DataRow>();                               
                                HRowNo = Convert.ToInt32(dr["Row#"]);
                                Session["HRowNo"] = HRowNo;
                            }

                            foreach (DataRow drMedication in data)
                            {
                                if (data.Length > 1)
                                {
                                    if ((Convert.ToInt32(drMedication["Row#"]) == (int.Parse)(Session["HRowNo"].ToString())))
                                        Session["expand"] = "expand";

                                    else
                                    {
                                        Session["Collapse"] = "Collapse";
                                        Session["ChildRow"] = "ChildRow";
                                    }
                                }                                                        
                                                                
                                string MedicationOrderStatus = drMedication["OrderStatus"].ToString();
                                string prescribedBy = drMedication["PrescribedBy"].ToString();
                                //Added By Anuj for task ref #3 on 16Nov,2009 SDI Projects FY10 - Venture
                                int prescriberId = 0;
                                if (drMedication["PrescriberId"].ToString() != "" &&
                                    drMedication["PrescriberId"].ToString() != null)
                                {
                                    prescriberId = Convert.ToInt32(drMedication["PrescriberId"].ToString());
                                }
                                //Ended Over here
                                //--Start Added By Pradeep as pertask#32
                                string comments = drMedication["Comments"].ToString();
                                //-- End Added By Pradeep as pertask#32
                                string specialInstruction = drMedication["SpecialInstructions"].ToString();
                                int MedicationNameId;
                                int.TryParse(drMedication["MedicationNameId"].ToString(), out MedicationNameId);

                                string ordered = drMedication["ordered"] == DBNull.Value
                                                     ? "N"
                                                     : drMedication["ordered"].ToString();
                                string titrateMode = drMedication["TitrationType"] == DBNull.Value
                                                         ? ""
                                                         : drMedication["TitrationType"].ToString();
                                string discontinued = drMedication["Discontinued"] == DBNull.Value
                                                          ? "N"
                                                          : drMedication["Discontinued"].ToString();
                                string startDate = "";
                                //Code Added by : Malathi Shiva 
                                //With Ref to task# : 33 - Community Network Services
                                string offLabel = "";
                                if (((StreamlinePrinciple)Context.User).HasPermission(Permissions.OffLabel))
                                {
                                    //Added by Loveena in ref to Task#2433 to display OffLabel Column in View History.
                                    offLabel = drMedication["OffLabel"].ToString();
                                }
                                //Added by Loveena in ref to Task#2433 to display DiscontinuedReason Column in View History.
                                //string DiscontinuedReason = drMedication["DiscontinuedReason"].ToString();
                                //Code Modified by Loveena in ref to Tsk#2488 to display Discontinued Reason Code.
                                string DiscontinuedReason = string.Empty;
                                //Code added in ref to Task#2983
                                string AllowAllergyMedications = Convert.ToString(drMedication["AllowAllergyMedications"]);

                                DataRow[] drDiscontinueReasonCode = null;
                                if (drMedication["DiscontinuedReasonCode"].ToString() != string.Empty &&
                                    drMedication["DiscontinuedReasonCode"].ToString() != "0")
                                {
                                    drDiscontinueReasonCode =
                                        SharedTables.DataSetGlobalCodes.Tables[0].Select(
                                            "Category='MEDDISCONTINUEREASON' And ISNULL(RecordDeleted,'N')='N' And  GlobalCodeId=" +
                                            Convert.ToInt32(drMedication["DiscontinuedReasonCode"]));
                                    if (drDiscontinueReasonCode.Length > 0)
                                    {
                                        if (drMedication["DiscontinuedReason"].ToString() != string.Empty &&
                                            drMedication["DiscontinuedReason"].ToString() != "NULL")
                                            DiscontinuedReason = drDiscontinueReasonCode[0]["CodeName"] + " - " +
                                                                 drMedication["DiscontinuedReason"];
                                        else
                                            DiscontinuedReason = drDiscontinueReasonCode[0]["CodeName"].ToString();
                                    }
                                }

                                startDate = drMedication["MedicationStartDate"] == DBNull.Value
                                                ? "N"
                                                : drMedication["MedicationStartDate"].ToString();
                                //Added by Loveena on 05-Jan-2009
                                if (startDate != "")
                                    startDate = Convert.ToDateTime(startDate).ToString("MM/dd/yyyy");
                                else
                                    startDate = "";

                                string endDate = drMedication["MedicationEndDate"] == DBNull.Value
                                                     ? "N"
                                                     : drMedication["MedicationEndDate"].ToString();
                                //Added by Loveena on 05-Jan-2009
                                if (endDate != "")
                                    endDate = Convert.ToDateTime(endDate).ToString("MM/dd/yyyy");
                                else
                                    endDate = "";

                                //Changes as per Task 2381
                                string OrderStatus = drMedication["OrderStatus"] == DBNull.Value
                                                         ? ""
                                                         : drMedication["OrderStatus"].ToString();
                                string OrderStatusDate = drMedication["OrderStatusDate"] == DBNull.Value
                                                             ? ""
                                                             : drMedication["OrderStatusDate"].ToString();
                                //Added by Loveena on 05-Jan-2009
                                if (OrderStatusDate != "")
                                    OrderStatusDate = Convert.ToDateTime(OrderStatusDate).ToString("MM/dd/yyyy");
                                else
                                    OrderStatusDate = "";
                                //Added by Loveena in Ref to Task#128 on 15-Jan-2009 to display OrderDate in ViewMedicationHistory.
                                string OrderDate = drMedication["OrderDate"] == DBNull.Value
                                                       ? ""
                                                       : drMedication["OrderDate"].ToString();

                                if (OrderDate != "")
                                    OrderDate = Convert.ToDateTime(OrderDate).ToString("MM/dd/yyyy");
                                else
                                    OrderDate = "";


                                string AddedBy = drMedication["AddedBy"] == DBNull.Value
                                              ? ""
                                              : drMedication["AddedBy"].ToString(); 

                                if (AddedBy != "")
                                    AddedBy = AddedBy.ToString();
                                else
                                    AddedBy = "";


                                string DiscontinuedBy = drMedication["DiscontinuedBy"] == DBNull.Value
                                             ? ""
                                             : drMedication["DiscontinuedBy"].ToString();

                                if (DiscontinuedBy != "")
                                    DiscontinuedBy = DiscontinuedBy.ToString();
                                else
                                    DiscontinuedBy = "";


                                //Code end here.                  
                                string MedicationScriptId = drMedication["MedicationScriptId"] == DBNull.Value
                                                                ? ""
                                                                : drMedication["MedicationScriptId"].ToString();
                                string PharmacyName = drMedication["PharmacyName"] == DBNull.Value
                                                          ? ""
                                                          : drMedication["PharmacyName"].ToString().EncodeForJs();
                                string SmartCareOrderEntry = drMedication["SmartCareOrderEntry"] == DBNull.Value
                                                          ? ""
                                                          : drMedication["SmartCareOrderEntry"].ToString();
                                string SureScriptsOutgoingMessageId = drMedication["SureScriptsOutgoingMessageId"] ==
                                                                      DBNull.Value
                                                                          ? ""
                                                                          : drMedication["SureScriptsOutgoingMessageId"]
                                                                                .ToString().Equals("-1")
                                                                                ? ""
                                                                                : drMedication["SureScriptsOutgoingMessageId"]
                                                                                      .ToString();

                                //Code added by Loveena in ref to Task#2465 on 08-May-2009 to display icon if record exists in ClientMedicationConsens.
                                Int32 ClientMedicationConsnetId = 0;
                                if (drMedication["ClientMedicationConsentId"] != DBNull.Value)
                                    ClientMedicationConsnetId = Convert.ToInt32(drMedication["ClientMedicationConsentId"]);

                                //Code added by Anuj in ref to task#18 (SDI Projects FY10 - Venture on 30Oct,2009 to display yellow icon  if medication is signed by (MD)
                                Int32 SignedByMD = 0;
                                if (drMedication["SignedByMD"] != DBNull.Value)
                                    SignedByMD = Convert.ToInt32(drMedication["SignedByMD"]);

                                //Code added by Anuj in ref to task#3 (SDI Projects FY10 - Venture on 16nov,2009 to display Approval Button
                                Int32 VerbalOrder = 0;
                                if (drMedication["VerbalOrder"] != DBNull.Value)
                                    VerbalOrder = Convert.ToInt32(drMedication["VerbalOrder"]);
                                //Ended over here


                                /***Creating Drug Drug Interaction Boxes**/
                                var tblInteraction = new Table();
                                tblInteraction.Attributes.Add("MedicationId", medicationId.ToString());
                                tblInteraction.Attributes.Add("PrescriberAcknowledged", "true");


                                var trInteraction = new TableRow();
                                string AllergyType = string.Empty; //--By Pradeep

                                if (_dtMedicationInteractionTemp.Rows.Count > 0)
                                {
                                    string Query = "(ClientMedicationId1=" + medicationId + " or ClientMedicationId2=" +
                                                   medicationId + " ) and isnull(recorddeleted,'N') <> 'Y'";
                                    DataRow[] drInteraction = _dtMedicationInteractionTemp.Select(Query);

                                    _boolRowWithInteractionFound = false;
                                    foreach (DataRow drT in drInteraction)
                                    {
                                        if (!drT["InteractionLevel"].ToString().IsNullOrWhiteSpace())
                                        {
                                            int InteractionId = Convert.ToInt32(drT["ClientMedicationInteractionId"]);
                                            var backColor = new Color();
                                            var tdInteraction = new TableCell();
                                            if ((drT["Color"] == DBNull.Value) || (String.IsNullOrEmpty(drT["Color"].ToString())))
                                            {
                                                foreach (Color clr in _color)
                                                {
                                                    DataRow[] drColorExits =
                                                        _dtMedicationInteractionTemp.Select("Color='" + clr.ToArgb().ToString() +
                                                                                            "'");
                                                    if (drColorExits.Length < 1)
                                                    {
                                                        backColor = clr;
                                                        break;
                                                    }
                                                }
                                            }
                                            else
                                            {
                                                backColor = Color.FromArgb(Convert.ToInt32(drT["Color"]));
                                            }
                                            if (drT["Color"].ToString() == "0")
                                                tdInteraction.ForeColor = System.Drawing.Color.White;
                                            drT["Color"] = backColor.ToArgb().ToString();
                                            tdInteraction.BackColor = backColor;
                                            tdInteraction.Height = 10;
                                            tdInteraction.ID = "td_" + medicationId + "_" + InteractionId;
                                            tdInteraction.Width = 10;
                                            tdInteraction.CssClass = "drugInteraction";
                                            if (Convert.ToInt32(drT["InteractionLevel"]) != 1)
                                            {
                                                //Changes by Sonia
                                                //Task #82 (Drug Interactions)
                                                //Acknowledge button should be displayed if a Client Medication has interaction with both types of medications i.e with severity level 1 & 3
                                                Query = Query + " and InteractionLevel=1";
                                                if (_dtMedicationInteractionTemp.Select(Query).Length <= 0)
                                                {
                                                    tblInteraction.Attributes["MedicationId"] = null;
                                                }

                                                //Changes end over here
                                            }

                                            tdInteraction.Text = drT["InteractionLevel"].ToString();
                                            tdInteraction.ToolTip = "Drug Interaction";
                                            trInteraction.Cells.Add(tdInteraction);
                                            if (drT["PrescriberAcknowledged"] != DBNull.Value)
                                            {
                                                if (drT["PrescriberAcknowledged"].ToString() != "Y")
                                                {
                                                    tblInteraction.Attributes["PrescriberAcknowledged"] = "false";
                                                }
                                            }
                                            else
                                            {
                                                tblInteraction.Attributes["PrescriberAcknowledged"] = "false";
                                            }

                                            myscript += "var Tdcontext" + medicationId.ToString().Replace('-', '$') + "_" +
                                                        InteractionId.ToString().Replace('-', '$') + "={InteractionId:" +
                                                        InteractionId + "};";
                                            myscript += "var TdclickCallback" + medicationId.ToString().Replace('-', '$') + "_" +
                                                        InteractionId.ToString().Replace('-', '$') + " =";
                                            myscript += " Function.createCallback(" + _onDrugInteractionClick + ", Tdcontext" +
                                                        medicationId.ToString().Replace('-', '$') + "_" +
                                                        InteractionId.ToString().Replace('-', '$') + ");";
                                            myscript += "$addHandler($get('" + ClientID + ClientIDSeparator + tdInteraction.ClientID +
                                                        "'), 'click', TdclickCallback" + medicationId.ToString().Replace('-', '$') +
                                                        "_" + InteractionId.ToString().Replace('-', '$') + ");";
                                        }
                                        /***Drug Drug Interaction Boxes End Here**/
                                    }
                                }
                                //Code added by Loveena in ref to Task#2976
                                String[] columnNames =
                            {
                                "AllergenConceptId", "MedicationNameId", "ConceptDescription",
                                "AllergyType", "Color"
                            };
                                using (
                                    DataTable dataTableClientAllergies = _dtMedicationAllergyTemp.DefaultView.ToTable(true,
                                                                                                                      columnNames)
                                    )
                                {
                                    _dtMedicationAllergyTemp.Clear();
                                    _dtMedicationAllergyTemp.Merge(dataTableClientAllergies);
                                }
                                //Code ends over here.
                                if (_dtMedicationAllergyTemp.Rows.Count > 0)
                                {
                                    DataRow[] drAllergy = _dtMedicationAllergyTemp.Select("MedicationNameId=" + MedicationNameId);
                                    if (drAllergy.Length > 0)
                                    {
                                        foreach (DataRow drAType in drAllergy) //--By Pradeep
                                        {
                                            //----This if condition is written by Pradeep as per task#9
                                            AllergyType = drAType["AllergyType"] == null
                                                              ? ""
                                                              : Convert.ToString(drAType["AllergyType"]); //--By Pradeep
                                            //Commented in ref to Task#2976
                                            //if (AllergyType.ToString().Trim().ToUpper() != "F")//--By Pradeep
                                            //{
                                            int AllergyId = Convert.ToInt32(drAllergy[0]["AllergenConceptId"]);
                                            string toolTip = "";
                                            var tdColor = new Color();

                                            var tdInteraction = new TableCell();

                                            tdInteraction.Height = 10;
                                            tdInteraction.ID = "td_" + medicationId + "_" + AllergyId;
                                            tdInteraction.Width = 10;
                                            tdInteraction.CssClass = "drugInteraction";
                                            foreach (DataRow drATemp in drAllergy)
                                            {
                                                if (!toolTip.Contains(Convert.ToString(drATemp["ConceptDescription"])))
                                                    toolTip = toolTip +
                                                              (drATemp["ConceptDescription"] == DBNull.Value
                                                                   ? ""
                                                                   : Convert.ToString(drATemp["ConceptDescription"])) +
                                                              Environment.NewLine;
                                                DataRow[] checkAllergyExists =
                                                    _dtMedicationAllergyTemp.Select("AllergenConceptId=" + AllergyId +
                                                                                    " and isnull(Color,'N')<>'N'");
                                                if (checkAllergyExists.Length > 0)
                                                {
                                                    drATemp["Color"] = checkAllergyExists[0]["Color"];
                                                    tdColor = Color.FromArgb(Convert.ToInt32(checkAllergyExists[0]["Color"]));
                                                }
                                                else
                                                {
                                                    drATemp["Color"] = _color[ColorCounter].ToArgb();
                                                    tdColor = _color[ColorCounter];
                                                }
                                                //Code added in ref to Task#2983
                                                tblInteraction.Attributes["MedicationId"] = medicationId.ToString();
                                            }
                                            tdInteraction.BackColor = tdColor;
                                            tdInteraction.ToolTip = toolTip;
                                            //---Comented by Pradeep as pertask#9
                                            //tdInteraction.Text = "A";
                                            //---Start Addedd by Pradeep as pertask#9
                                            if (AllergyType != string.Empty)
                                            {
                                                tdInteraction.Text = AllergyType;
                                            }
                                            else
                                            {
                                                tdInteraction.Text = "A";
                                            }
                                            //---End Addedd by Pradeep as pertask#9
                                            trInteraction.Cells.Add(tdInteraction);
                                            ColorCounter++;
                                            if (ColorCounter > 12)
                                                ColorCounter = 0;
                                            //}
                                        }
                                    }
                                }
                                tblInteraction.Rows.Add(trInteraction);
                                DataRow[] drMedInstructions;                                

                                if (_dtMedicationInstructionTemp.Columns.Contains("MedicationOrderStatus") &&
                                    _dtMedicationInstructionTemp.Columns.Contains("MedicationScriptId"))
                                {
                                    drMedInstructions =
                                        _dtMedicationInstructionTemp.Select("MedicationId=" + medicationId +
                                                                            " and ISNULL(MedicationOrderStatus,'')='" +
                                                                            MedicationOrderStatus +
                                                                            "' and ISNULL(MedicationScriptId,'')='" +
                                                                            MedicationScriptId + "'");                                 
                                }
                                else
                                {
                                    drMedInstructions = _dtMedicationInstructionTemp.Select("MedicationId=" + medicationId);                                  
                                }
                                Session["DataSetAllergy"] = _dtMedicationAllergyTemp;
                                //Added by Anuj on 23 nov,2009 for task ref #3 SDI-Venture 10
                                //Showing  Approval message display
                                var trApprovalMessage = new TableRow();
                                var tdApprovalMessage = new TableCell();
                                if (_showApprovalMessage && _OrderApprovalMessageShown == false)
                                {
                                    if (VerbalOrder > 1)
                                    {
                                        if (discontinued != "Y")
                                        {
                                            tdApprovalMessage.CssClass = "textbolditalic";
                                            tdApprovalMessage.ColumnSpan = 10;
                                            tdApprovalMessage.Text = "Order Queued for Prescriber Approval";
                                            trApprovalMessage.Cells.Add(tdApprovalMessage);
                                            tblMedication.Rows.Add(trApprovalMessage);
                                            //Following changes by Sonia/Devinder SDI Project FY10 Ticket #3
                                            //Message needs to be shown only once
                                            _OrderApprovalMessageShown = true;
                                        }
                                    }
                                }
                                //end over here


                                foreach (DataRow drTemp in drMedInstructions)
                                {
                                    //Changes by Sonia
                                    //Task #82 (Drug Interactions)
                                    //Acknowledge button should be displayed if a Client Medication has interaction with both types of medications i.e with severity level 1 & 3
                                    string Query = "(ClientMedicationId1=" + medicationId + " or ClientMedicationId2=" +
                                                   medicationId + " ) and isnull(recorddeleted,'N') <> 'Y'";
                                    Query = Query + " and InteractionLevel=1";
                                    if (_dtMedicationInteractionTemp.Select(Query).Length > 0)
                                    {
                                        _boolRowWithInteractionFound = true;
                                    }
                                    tblMedication.Rows.Add(GenerateSubRows(drTemp, prescribedBy, tblMedication.ClientID,
                                                                           ref myscript, tblInteraction, ordered, discontinued,
                                                                           startDate, endDate, OrderStatus, OrderStatusDate,
                                                                           MedicationScriptId, _boolRowWithInteractionFound,
                                                                           OrderDate, titrateMode, offLabel, DiscontinuedReason,
                                                                           comments, ClientMedicationConsnetId, SignedByMD,
                                                                           VerbalOrder, prescriberId, AllergyType,
                                                                           AllowAllergyMedications, MedicationNameId,
                                                                           SureScriptsOutgoingMessageId, PharmacyName, SmartCareOrderEntry, COMPLETEORDERSTORX, AddedBy, DiscontinuedBy, rowClass));//
                                    if (_calledFromControllerName == "ViewMedicationHistory")
                                    {

                                        rowClass = rowClass == "RowStyle" ? "AlternatingRowStyle" : "RowStyle";
                                    }
                                    else
                                    {

                                        rowClass = rowClass == "GridViewRowStyle" ? "GridViewAlternatingRowStyle" : "GridViewRowStyle";
                                    }
                                    //Changes end over here
                                    tblInteraction = new Table();
                                    startDate = string.Empty;
                                    endDate = string.Empty;
                                }

                                var trSpecialInstructions = new TableRow();
                               // trSpecialInstructions.Attributes.Add("Class", "Rowbolditalic");
                                var tdSpInstructions = new TableCell();
                                tdSpInstructions.CssClass = "textbolditalic";
                                tdSpInstructions.ColumnSpan = 10;

                                if (Session["ChildRow"] == "ChildRow")
                                {
                                    trSpecialInstructions.Attributes.Add("Class", "Rowbolditalic");                                
                                }                               
                                tdSpInstructions.Text = specialInstruction;                               
                                trSpecialInstructions.Cells.Add(tdSpInstructions);
                                tblMedication.Rows.Add(trSpecialInstructions);


                            }
                            Session["ChildRow"] = "";
                            Session["Collapse"] = "";
                            var trLine = new TableRow();
                            trLine.Attributes.Add("Class", "RowblackLine");
                            var tdHorizontalLine = new TableCell();
                            tdHorizontalLine.ColumnSpan = 18; //Changed value 15 to 16 as per Meaning ful Use #43
                            tdHorizontalLine.CssClass = "blackLine";
                            trLine.Cells.Add(tdHorizontalLine);
                            tblMedication.Rows.Add(trLine);


                        }       
                    } 
                  
                    else {
                        foreach (DataRow drMedication in _dtMedicationTemp.Rows)
                        {
                            int medicationId = Convert.ToInt32(drMedication["MedicationId"]);

                            string MedicationOrderStatus = drMedication["OrderStatus"].ToString();
                            string prescribedBy = drMedication["PrescribedBy"].ToString();
                            //Added By Anuj for task ref #3 on 16Nov,2009 SDI Projects FY10 - Venture
                            int prescriberId = 0;
                            if (drMedication["PrescriberId"].ToString() != "" &&
                                drMedication["PrescriberId"].ToString() != null)
                            {
                                prescriberId = Convert.ToInt32(drMedication["PrescriberId"].ToString());
                            }
                            //Ended Over here
                            //--Start Added By Pradeep as pertask#32
                            string comments = drMedication["Comments"].ToString();
                            //-- End Added By Pradeep as pertask#32
                            string specialInstruction = drMedication["SpecialInstructions"].ToString();
                            int MedicationNameId;
                            int.TryParse(drMedication["MedicationNameId"].ToString(), out MedicationNameId);

                            string ordered = drMedication["ordered"] == DBNull.Value
                                                 ? "N"
                                                 : drMedication["ordered"].ToString();
                            string titrateMode = drMedication["TitrationType"] == DBNull.Value
                                                     ? ""
                                                     : drMedication["TitrationType"].ToString();
                            string discontinued = drMedication["Discontinued"] == DBNull.Value
                                                      ? "N"
                                                      : drMedication["Discontinued"].ToString();
                            string startDate = "";
                            //Code Added by : Malathi Shiva 
                            //With Ref to task# : 33 - Community Network Services
                            string offLabel = "";
                            if (((StreamlinePrinciple)Context.User).HasPermission(Permissions.OffLabel))
                            {
                                //Added by Loveena in ref to Task#2433 to display OffLabel Column in View History.
                                offLabel = drMedication["OffLabel"].ToString();
                            }
                            //Added by Loveena in ref to Task#2433 to display DiscontinuedReason Column in View History.
                            //string DiscontinuedReason = drMedication["DiscontinuedReason"].ToString();
                            //Code Modified by Loveena in ref to Tsk#2488 to display Discontinued Reason Code.
                            string DiscontinuedReason = string.Empty;
                            //Code added in ref to Task#2983
                            string AllowAllergyMedications = Convert.ToString(drMedication["AllowAllergyMedications"]);

                            DataRow[] drDiscontinueReasonCode = null;
                            if (drMedication["DiscontinuedReasonCode"].ToString() != string.Empty &&
                                drMedication["DiscontinuedReasonCode"].ToString() != "0")
                            {
                                drDiscontinueReasonCode =
                                    SharedTables.DataSetGlobalCodes.Tables[0].Select(
                                        "Category='MEDDISCONTINUEREASON' And ISNULL(RecordDeleted,'N')='N' And  GlobalCodeId=" +
                                        Convert.ToInt32(drMedication["DiscontinuedReasonCode"]));
                                if (drDiscontinueReasonCode.Length > 0)
                                {
                                    if (drMedication["DiscontinuedReason"].ToString() != string.Empty &&
                                        drMedication["DiscontinuedReason"].ToString() != "NULL")
                                        DiscontinuedReason = drDiscontinueReasonCode[0]["CodeName"] + " - " +
                                                             drMedication["DiscontinuedReason"];
                                    else
                                        DiscontinuedReason = drDiscontinueReasonCode[0]["CodeName"].ToString();
                                }
                            }

                            startDate = drMedication["MedicationStartDate"] == DBNull.Value
                                            ? "N"
                                            : drMedication["MedicationStartDate"].ToString();
                            //Added by Loveena on 05-Jan-2009
                            if (startDate != "")
                                startDate = Convert.ToDateTime(startDate).ToString("MM/dd/yyyy");
                            else
                                startDate = "";

                            string endDate = drMedication["MedicationEndDate"] == DBNull.Value
                                                 ? "N"
                                                 : drMedication["MedicationEndDate"].ToString();
                            //Added by Loveena on 05-Jan-2009
                            if (endDate != "")
                                endDate = Convert.ToDateTime(endDate).ToString("MM/dd/yyyy");
                            else
                                endDate = "";

                            //Changes as per Task 2381
                            string OrderStatus = drMedication["OrderStatus"] == DBNull.Value
                                                     ? ""
                                                     : drMedication["OrderStatus"].ToString();
                            string OrderStatusDate = drMedication["OrderStatusDate"] == DBNull.Value
                                                         ? ""
                                                         : drMedication["OrderStatusDate"].ToString();
                            //Added by Loveena on 05-Jan-2009
                            if (OrderStatusDate != "")
                                OrderStatusDate = Convert.ToDateTime(OrderStatusDate).ToString("MM/dd/yyyy");
                            else
                                OrderStatusDate = "";
                            //Added by Loveena in Ref to Task#128 on 15-Jan-2009 to display OrderDate in ViewMedicationHistory.
                            string OrderDate = drMedication["OrderDate"] == DBNull.Value
                                                   ? ""
                                                   : drMedication["OrderDate"].ToString();

                            if (OrderDate != "")
                                OrderDate = Convert.ToDateTime(OrderDate).ToString("MM/dd/yyyy");
                            else
                                OrderDate = "";


                            string AddedBy = drMedication["AddedBy"] == DBNull.Value
                                              ? ""
                                              : drMedication["AddedBy"].ToString();

                            if (AddedBy != "")
                                AddedBy = AddedBy.ToString();
                            else
                                AddedBy = "";


                            string DiscontinuedBy = drMedication["DiscontinuedBy"] == DBNull.Value
                                             ? ""
                                             : drMedication["DiscontinuedBy"].ToString();

                            if (DiscontinuedBy != "")
                                DiscontinuedBy = DiscontinuedBy.ToString();
                            else
                                DiscontinuedBy = "";


                            //Code end here.                  
                            string MedicationScriptId = drMedication["MedicationScriptId"] == DBNull.Value
                                                            ? ""
                                                            : drMedication["MedicationScriptId"].ToString();
                            string PharmacyName = drMedication["PharmacyName"] == DBNull.Value
                                                      ? ""
                                                      : drMedication["PharmacyName"].ToString().EncodeForJs();
                            string SmartCareOrderEntry = drMedication["SmartCareOrderEntry"] == DBNull.Value
                                                      ? ""
                                                      : drMedication["SmartCareOrderEntry"].ToString();
                            string SureScriptsOutgoingMessageId = drMedication["SureScriptsOutgoingMessageId"] ==
                                                                  DBNull.Value
                                                                      ? ""
                                                                      : drMedication["SureScriptsOutgoingMessageId"]
                                                                            .ToString().Equals("-1")
                                                                            ? ""
                                                                            : drMedication["SureScriptsOutgoingMessageId"]
                                                                                  .ToString();

                            //Code added by Loveena in ref to Task#2465 on 08-May-2009 to display icon if record exists in ClientMedicationConsens.
                            Int32 ClientMedicationConsnetId = 0;
                            if (drMedication["ClientMedicationConsentId"] != DBNull.Value)
                                ClientMedicationConsnetId = Convert.ToInt32(drMedication["ClientMedicationConsentId"]);

                            //Code added by Anuj in ref to task#18 (SDI Projects FY10 - Venture on 30Oct,2009 to display yellow icon  if medication is signed by (MD)
                            Int32 SignedByMD = 0;
                            if (drMedication["SignedByMD"] != DBNull.Value)
                                SignedByMD = Convert.ToInt32(drMedication["SignedByMD"]);

                            //Code added by Anuj in ref to task#3 (SDI Projects FY10 - Venture on 16nov,2009 to display Approval Button
                            Int32 VerbalOrder = 0;
                            if (drMedication["VerbalOrder"] != DBNull.Value)
                                VerbalOrder = Convert.ToInt32(drMedication["VerbalOrder"]);
                            //Ended over here


                            /***Creating Drug Drug Interaction Boxes**/
                            var tblInteraction = new Table();
                            tblInteraction.Attributes.Add("MedicationId", medicationId.ToString());
                            tblInteraction.Attributes.Add("PrescriberAcknowledged", "true");


                            var trInteraction = new TableRow();
                            string AllergyType = string.Empty; //--By Pradeep

                            if (_dtMedicationInteractionTemp.Rows.Count > 0)
                            {
                                string Query = "(ClientMedicationId1=" + medicationId + " or ClientMedicationId2=" +
                                               medicationId + " ) and isnull(recorddeleted,'N') <> 'Y'";
                                DataRow[] drInteraction = _dtMedicationInteractionTemp.Select(Query);

                                _boolRowWithInteractionFound = false;
                                foreach (DataRow drT in drInteraction)
                                {
                                    if (!drT["InteractionLevel"].ToString().IsNullOrWhiteSpace())
                                    {
                                        int InteractionId = Convert.ToInt32(drT["ClientMedicationInteractionId"]);
                                        var backColor = new Color();
                                        var tdInteraction = new TableCell();
                                        if ((drT["Color"] == DBNull.Value) || (String.IsNullOrEmpty(drT["Color"].ToString())))
                                        {
                                            foreach (Color clr in _color)
                                            {
                                                DataRow[] drColorExits =
                                                    _dtMedicationInteractionTemp.Select("Color='" + clr.ToArgb().ToString() +
                                                                                        "'");
                                                if (drColorExits.Length < 1)
                                                {
                                                    backColor = clr;
                                                    break;
                                                }
                                            }
                                        }
                                        else
                                        {
                                            backColor = Color.FromArgb(Convert.ToInt32(drT["Color"]));
                                        }
                                        if (drT["Color"].ToString() == "0")
                                            tdInteraction.ForeColor = System.Drawing.Color.White;
                                        drT["Color"] = backColor.ToArgb().ToString();
                                        tdInteraction.BackColor = backColor;
                                        tdInteraction.Height = 10;
                                        tdInteraction.ID = "td_" + medicationId + "_" + InteractionId;
                                        tdInteraction.Width = 10;
                                        tdInteraction.CssClass = "drugInteraction";
                                        if (Convert.ToInt32(drT["InteractionLevel"]) != 1)
                                        {
                                            //Changes by Sonia
                                            //Task #82 (Drug Interactions)
                                            //Acknowledge button should be displayed if a Client Medication has interaction with both types of medications i.e with severity level 1 & 3
                                            Query = Query + " and InteractionLevel=1";
                                            if (_dtMedicationInteractionTemp.Select(Query).Length <= 0)
                                            {
                                                tblInteraction.Attributes["MedicationId"] = null;
                                            }

                                            //Changes end over here
                                        }

                                        tdInteraction.Text = drT["InteractionLevel"].ToString();
                                        tdInteraction.ToolTip = "Drug Interaction";
                                        trInteraction.Cells.Add(tdInteraction);
                                        if (drT["PrescriberAcknowledged"] != DBNull.Value)
                                        {
                                            if (drT["PrescriberAcknowledged"].ToString() != "Y")
                                            {
                                                tblInteraction.Attributes["PrescriberAcknowledged"] = "false";
                                            }
                                        }
                                        else
                                        {
                                            tblInteraction.Attributes["PrescriberAcknowledged"] = "false";
                                        }

                                        myscript += "var Tdcontext" + medicationId.ToString().Replace('-', '$') + "_" +
                                                    InteractionId.ToString().Replace('-', '$') + "={InteractionId:" +
                                                    InteractionId + "};";
                                        myscript += "var TdclickCallback" + medicationId.ToString().Replace('-', '$') + "_" +
                                                    InteractionId.ToString().Replace('-', '$') + " =";
                                        myscript += " Function.createCallback(" + _onDrugInteractionClick + ", Tdcontext" +
                                                    medicationId.ToString().Replace('-', '$') + "_" +
                                                    InteractionId.ToString().Replace('-', '$') + ");";
                                        myscript += "$addHandler($get('" + ClientID + ClientIDSeparator + tdInteraction.ClientID +
                                                    "'), 'click', TdclickCallback" + medicationId.ToString().Replace('-', '$') +
                                                    "_" + InteractionId.ToString().Replace('-', '$') + ");";
                                    }
                                    /***Drug Drug Interaction Boxes End Here**/
                                }
                            }
                            //Code added by Loveena in ref to Task#2976
                            String[] columnNames =
                            {
                                "AllergenConceptId", "MedicationNameId", "ConceptDescription",
                                "AllergyType", "Color"
                            };
                            using (
                                DataTable dataTableClientAllergies = _dtMedicationAllergyTemp.DefaultView.ToTable(true,
                                                                                                                  columnNames)
                                )
                            {
                                _dtMedicationAllergyTemp.Clear();
                                _dtMedicationAllergyTemp.Merge(dataTableClientAllergies);
                            }
                            //Code ends over here.
                            if (_dtMedicationAllergyTemp.Rows.Count > 0)
                            {
                                DataRow[] drAllergy = _dtMedicationAllergyTemp.Select("MedicationNameId=" + MedicationNameId);
                                if (drAllergy.Length > 0)
                                {
                                    foreach (DataRow drAType in drAllergy) //--By Pradeep
                                    {
                                        //----This if condition is written by Pradeep as per task#9
                                        AllergyType = drAType["AllergyType"] == null
                                                          ? ""
                                                          : Convert.ToString(drAType["AllergyType"]); //--By Pradeep
                                        //Commented in ref to Task#2976
                                        //if (AllergyType.ToString().Trim().ToUpper() != "F")//--By Pradeep
                                        //{
                                        int AllergyId = Convert.ToInt32(drAllergy[0]["AllergenConceptId"]);
                                        string toolTip = "";
                                        var tdColor = new Color();

                                        var tdInteraction = new TableCell();

                                        tdInteraction.Height = 10;
                                        tdInteraction.ID = "td_" + medicationId + "_" + AllergyId;
                                        tdInteraction.Width = 10;
                                        tdInteraction.CssClass = "drugInteraction";
                                        foreach (DataRow drATemp in drAllergy)
                                        {
                                            if (!toolTip.Contains(Convert.ToString(drATemp["ConceptDescription"])))
                                                toolTip = toolTip +
                                                          (drATemp["ConceptDescription"] == DBNull.Value
                                                               ? ""
                                                               : Convert.ToString(drATemp["ConceptDescription"])) +
                                                          Environment.NewLine;
                                            DataRow[] checkAllergyExists =
                                                _dtMedicationAllergyTemp.Select("AllergenConceptId=" + AllergyId +
                                                                                " and isnull(Color,'N')<>'N'");
                                            if (checkAllergyExists.Length > 0)
                                            {
                                                drATemp["Color"] = checkAllergyExists[0]["Color"];
                                                tdColor = Color.FromArgb(Convert.ToInt32(checkAllergyExists[0]["Color"]));
                                            }
                                            else
                                            {
                                                drATemp["Color"] = _color[ColorCounter].ToArgb();
                                                tdColor = _color[ColorCounter];
                                            }
                                            //Code added in ref to Task#2983
                                            tblInteraction.Attributes["MedicationId"] = medicationId.ToString();
                                        }
                                        tdInteraction.BackColor = tdColor;
                                        tdInteraction.ToolTip = toolTip;
                                        //---Comented by Pradeep as pertask#9
                                        //tdInteraction.Text = "A";
                                        //---Start Addedd by Pradeep as pertask#9
                                        if (AllergyType != string.Empty)
                                        {
                                            tdInteraction.Text = AllergyType;
                                        }
                                        else
                                        {
                                            tdInteraction.Text = "A";
                                        }
                                        //---End Addedd by Pradeep as pertask#9
                                        trInteraction.Cells.Add(tdInteraction);
                                        ColorCounter++;
                                        if (ColorCounter > 12)
                                            ColorCounter = 0;
                                        //}
                                    }
                                }
                            }
                            tblInteraction.Rows.Add(trInteraction);
                            DataRow[] drMedInstructions;                           

                            if (_dtMedicationInstructionTemp.Columns.Contains("MedicationOrderStatus") &&
                                _dtMedicationInstructionTemp.Columns.Contains("MedicationScriptId"))
                            {
                                drMedInstructions =
                                    _dtMedicationInstructionTemp.Select("MedicationId=" + medicationId +
                                                                        " and ISNULL(MedicationOrderStatus,'')='" +
                                                                        MedicationOrderStatus +
                                                                        "' and ISNULL(MedicationScriptId,'')='" +
                                                                        MedicationScriptId + "'");
                                

                            }
                            else
                            {
                                drMedInstructions = _dtMedicationInstructionTemp.Select("MedicationId=" + medicationId);                               
                            }
                            Session["DataSetAllergy"] = _dtMedicationAllergyTemp;
                            //Added by Anuj on 23 nov,2009 for task ref #3 SDI-Venture 10
                            //Showing  Approval message display
                            var trApprovalMessage = new TableRow();
                            var tdApprovalMessage = new TableCell();
                            if (_showApprovalMessage && _OrderApprovalMessageShown == false)
                            {
                                if (VerbalOrder > 1)
                                {
                                    if (discontinued != "Y")
                                    {
                                        tdApprovalMessage.CssClass = "textbolditalic";
                                        tdApprovalMessage.ColumnSpan = 10;
                                        tdApprovalMessage.Text = "Order Queued for Prescriber Approval";
                                        trApprovalMessage.Cells.Add(tdApprovalMessage);
                                        tblMedication.Rows.Add(trApprovalMessage);
                                        //Following changes by Sonia/Devinder SDI Project FY10 Ticket #3
                                        //Message needs to be shown only once
                                        _OrderApprovalMessageShown = true;
                                    }
                                }
                            }
                            //end over here


                            foreach (DataRow drTemp in drMedInstructions)
                            {
                                //Changes by Sonia
                                //Task #82 (Drug Interactions)
                                //Acknowledge button should be displayed if a Client Medication has interaction with both types of medications i.e with severity level 1 & 3
                                string Query = "(ClientMedicationId1=" + medicationId + " or ClientMedicationId2=" +
                                               medicationId + " ) and isnull(recorddeleted,'N') <> 'Y'";
                                Query = Query + " and InteractionLevel=1";
                                if (_dtMedicationInteractionTemp.Select(Query).Length > 0)
                                {
                                    _boolRowWithInteractionFound = true;
                                }
                                tblMedication.Rows.Add(GenerateSubRows(drTemp, prescribedBy, tblMedication.ClientID,
                                                                       ref myscript, tblInteraction, ordered, discontinued,
                                                                       startDate, endDate, OrderStatus, OrderStatusDate,
                                                                       MedicationScriptId, _boolRowWithInteractionFound,
                                                                       OrderDate, titrateMode, offLabel, DiscontinuedReason,
                                                                       comments, ClientMedicationConsnetId, SignedByMD,
                                                                       VerbalOrder, prescriberId, AllergyType,
                                                                       AllowAllergyMedications, MedicationNameId,
                                                                       SureScriptsOutgoingMessageId, PharmacyName, SmartCareOrderEntry, COMPLETEORDERSTORX, AddedBy, DiscontinuedBy, rowClass));//
                                rowClass = rowClass == "GridViewRowStyle" ? "GridViewAlternatingRowStyle" : "GridViewRowStyle";
                                //Changes end over here
                                tblInteraction = new Table();
                                startDate = string.Empty;
                                endDate = string.Empty;
                            }

                            var trSpecialInstructions = new TableRow();
                            var tdSpInstructions = new TableCell();
                            tdSpInstructions.CssClass = "textbolditalic";
                            tdSpInstructions.ColumnSpan = 10;
                            tdSpInstructions.Text = specialInstruction;
                            trSpecialInstructions.Cells.Add(tdSpInstructions);
                            tblMedication.Rows.Add(trSpecialInstructions);

                            Session["Collapse"] = "";
                            var trLine = new TableRow();
                            var tdHorizontalLine = new TableCell();
                            tdHorizontalLine.ColumnSpan = 18; //Changed value 15 to 16 as per Meaning ful Use #43
                            tdHorizontalLine.CssClass = "blackLine";
                            trLine.Cells.Add(tdHorizontalLine);
                            tblMedication.Rows.Add(trLine);                            

                        }                                          
                     }
                }   
                else
                    //Condition added by sonia to Make the allergy interactions table clear in case no medications are found
                    Session["DataSetAllergy"] = null;
                tblMedication.Style.Add("border", "0px");
                tblMedication.CellPadding = 0;
                tblMedication.CellSpacing = 0;

                PanelMedicationList.Controls.Add(tblMedication);
                myscript +=
                    "}catch(e){ Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);}}</script>";
                //Page.ClientScript.re

                //if (!Page.ClientScript.IsClientScriptBlockRegistered("MedicationListScript"))
                Page.RegisterClientScriptBlock(ClientID, myscript);
                //    Page.ClientScript.RegisterStartupScript(this.GetType(), "MedicationListScript", myscript);  
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
        private void sample (DataRow drMedication)
        {
            int medicationId = Convert.ToInt32(drMedication["MedicationId"]);

            string MedicationOrderStatus = drMedication["OrderStatus"].ToString();
        
        }
        private TableRow GenerateSubRows(DataRow drTemp, string PrescribedBy, string tableId, ref string myscript,
                                         Table tblInteraction, string ordered, string Discontinued, string startDate,
                                         string endDate, string OrderStatus, string OrderStatusDate,
                                         string MedicationScriptId, bool _boolRowWithInteractionFound, string OrderDate,
                                         string titrateMode, string offLabel, string DiscontinuedReason, string Comments,
                                         int clientMedicationConsentId, int SignedByMD, int VerbalOrder,
                                         int prescriberId, string AllergyType, string AllowAllergyMedications,
                                         int MedicationNameId, string SureScriptsOutgoingMessageId, string PharmacyName, string SmartCareOrderEntry, string COMPLETEORDERSTORX, string AddedBy, string DiscontinuedBy, string rowClass)
        {
            try
            {
                CommonFunctions.Event_Trap(this);
                string newId = Guid.NewGuid().ToString();
                int MedicationId = Convert.ToInt32(drTemp["MedicationId"]);               
                string tblId = ClientID + ClientIDSeparator + tableId;
                var trTemp = new TableRow();
                trTemp.ID = "Tr_" + newId;              
                string methodName = method.Trim();
                int client = ((StreamlinePrinciple)Context.User).Client.ClientId;

                #region Code for new column to indicate that coressponding record is for ClientMedicationConsent on 08-May-2009 in ref to Task # 2465.

                var tdConsentIcon = new TableCell();
                var imgConsentIcon = new HtmlImage();
                if (_showConsentIcon)
                {
                    if (SignedByMD == 1)
                    {
                        imgConsentIcon.ID = "ImgConsent_" + newId;
                        if (enableDisabled(Permissions.PatientConsent) == "Disabled")
                        {
                            //set the Disable image of MDCheckMark.jpg
                            //Ref to Task#2989
                            imgConsentIcon.Src = "~/App_Themes/Includes/Images/NewYellow_check_disable.gif";
                        }
                        else
                        {
                            imgConsentIcon.Src = "~/App_Themes/Includes/Images/NewYellow_check.gif";
                        }
                        imgConsentIcon.Attributes.Add("title", "Patient Signature Needed on Consent");
                        tdConsentIcon.Controls.Add(imgConsentIcon);
                        string ImageConsentRowId = ClientID + ClientIDSeparator + trTemp.ClientID;

                        var lblMedicationName = new Label();
                        if (MedicationScriptId != "")
                        {
                            lblMedicationName.ID = "Lbl_" + MedicationId.ToString() + "_" + MedicationScriptId;
                        }

                        else
                        {
                            lblMedicationName.ID = "Lbl_" + MedicationId.ToString();
                        }
                        lblMedicationName.Text = drTemp["Medication"] == DBNull.Value ? "" : drTemp["Medication"].ToString();
                        if (_showRadioButton == false)
                        {
                            if (MedicationScriptId == "")
                            {
                                if (lblMedicationName.Text != "")
                                {
                                    //---Comented by Pradeep for testing as anuj is working on register script

                                    //Checking Permissions
                                    if (enableDisabled(Permissions.PatientConsent) == "Disabled")
                                    {
                                        //Do Not attaching event
                                    }
                                    else
                                    {
                                        imgConsentIcon.Attributes.Add("class", "linkStyle");
                                        myscript += "var ImageConsentcontext" + MedicationId.ToString().Replace('-', '$') +
                                                    "={MedicationId:" + MedicationId + ",MedicationScriptId:" + "-1" +
                                                    ",MedicationInstructionsId:" + drTemp["MedicationInstructionId"] +
                                                    ",TableId:'" + tblId + "',RowId:'" + ImageConsentRowId +
                                                    "',ClientMedicationConsentId:'" + clientMedicationConsentId +
                                                    "',ClientId:'" + client +
                                                    "',ViewConsentReport:'ViewReport',YellowClick:'Y'};";
                                        myscript += "var ImageConsentclickCallback" +
                                                    MedicationId.ToString().Replace('-', '$') + " =";
                                        myscript += " Function.createCallback(" + _onImageConsentClickEventHandler +
                                                    ", ImageConsentcontext" + MedicationId.ToString().Replace('-', '$') +
                                                    ");";
                                        myscript += "$addHandler($get('" + ClientID + ClientIDSeparator +
                                                    imgConsentIcon.ClientID + "'), 'click', ImageConsentclickCallback" +
                                                    MedicationId.ToString().Replace('-', '$') + ");";
                                    }
                                }
                            }
                            else
                            {
                                if (lblMedicationName.Text != "")
                                {
                                    //---Comented by Pradeep for testing as anuj is working on register script
                                    //Checking Permissions
                                    if (enableDisabled(Permissions.PatientConsent) == "Disabled")
                                    {
                                        //Do Not attaching event
                                    }
                                    else
                                    {
                                        imgConsentIcon.Attributes.Add("class", "linkStyle");
                                        myscript += "var ImageConsentcontext" + MedicationId.ToString().Replace('-', '$') +
                                                    "={MedicationId:" + MedicationId + ",MedicationScriptId:" +
                                                    MedicationScriptId + ",MedicationInstructionsId:" +
                                                    drTemp["MedicationInstructionId"] + ",TableId:'" + tblId + "',RowId:'" +
                                                    ImageConsentRowId + "',ClientMedicationConsentId:'" +
                                                    clientMedicationConsentId + "',ClientId:'" + client +
                                                    "',ViewConsentReport:'ViewReport',YellowClick:'Y'};";
                                        myscript += "var ImageConsentclickCallback" +
                                                    MedicationId.ToString().Replace('-', '$') + " =";
                                        myscript += " Function.createCallback(" + _onImageConsentClickEventHandler +
                                                    ", ImageConsentcontext" + MedicationId.ToString().Replace('-', '$') +
                                                    ");";
                                        myscript += "$addHandler($get('" + ClientID + ClientIDSeparator +
                                                    imgConsentIcon.ClientID + "'), 'click', ImageConsentclickCallback" +
                                                    MedicationId.ToString().Replace('-', '$') + ");";
                                    }
                                }
                            }
                        }
                    }
                    else if (SignedByMD > 1)
                    {
                        imgConsentIcon.ID = "ImgConsent_" + newId;
                        //imgConsentIcon.ID = "ImgConsent_" + System.Guid.NewGuid().ToString();
                        if (enableDisabled(Permissions.PatientConsent) == "Disabled")
                        {
                            imgConsentIcon.Src = "~/App_Themes/Includes/Images/NewGreen_check_disable.gif";
                        }
                        else
                        {
                            imgConsentIcon.Src = "~/App_Themes/Includes/Images/NewGreen_check.gif";
                        }
                        imgConsentIcon.Attributes.Add("title", "Consent Obtained");
                        tdConsentIcon.Controls.Add(imgConsentIcon);
                        string ImageConsentRowId1 = ClientID + ClientIDSeparator + trTemp.ClientID;
                        var lblMedicationName1 = new Label();
                        if (MedicationScriptId != "")
                        {
                            lblMedicationName1.ID = "Lbl_" + MedicationId.ToString() + "_" + MedicationScriptId;
                        }

                        else
                        {
                            lblMedicationName1.ID = "Lbl_" + MedicationId.ToString();
                        }
                        lblMedicationName1.Text = drTemp["Medication"] == DBNull.Value
                                                      ? ""
                                                      : drTemp["Medication"].ToString();

                        if (_showRadioButton == false)
                        {
                            if (MedicationScriptId != "")
                            {
                                if (lblMedicationName1.Text != "")
                                {
                                    //Checking Permissions
                                    if (enableDisabled(Permissions.PatientConsent) == "Disabled")
                                    {
                                        //Do Not attaching event
                                    }
                                    else
                                    {
                                        imgConsentIcon.Attributes.Add("class", "linkStyle");
                                        //myscript += "var ImageConsentcontext" + MedicationId + "={MedicationId:" + MedicationId + ",MedicationScriptId:" + MedicationScriptId + ",MedicationInstructionsId:" + drTemp["MedicationInstructionId"].ToString() + ",TableId:'" + tblId + "',RowId:'" + ImageConsentRowId1 + "',ClientMedicationConsentId:'" + clientMedicationConsentId + "',ClientId:'" + client + "',ViewConsentReport:'ViewReport'};";
                                        myscript += "var ImageConsentcontext" + MedicationId.ToString().Replace('-', '$') +
                                                    "={MedicationId:" + MedicationId + ",MedicationScriptId:" +
                                                    MedicationScriptId + ",MedicationInstructionsId:" +
                                                    drTemp["MedicationInstructionId"] + ",TableId:'" + tblId + "',RowId:'" +
                                                    ImageConsentRowId1 + "',ClientMedicationConsentId:'" +
                                                    clientMedicationConsentId + "',ClientId:'" + client +
                                                    "',ViewConsentReport:'ViewReport',YellowClick:'G'};";
                                        myscript += "var ImageConsentclickCallback" +
                                                    MedicationId.ToString().Replace('-', '$') + " =";
                                        myscript += " Function.createCallback(" + _onImageConsentClickEventHandler +
                                                    ", ImageConsentcontext" + MedicationId.ToString().Replace('-', '$') +
                                                    ");";
                                        myscript += "$addHandler($get('" + ClientID + ClientIDSeparator +
                                                    imgConsentIcon.ClientID + "'), 'click', ImageConsentclickCallback" +
                                                    MedicationId.ToString().Replace('-', '$') + ");";
                                    }
                                }
                            }
                            else
                            {
                                if (lblMedicationName1.Text != "")
                                {
                                    //Checking Permissions
                                    if (enableDisabled(Permissions.PatientConsent) == "Disabled")
                                    {
                                        //Do Not attaching event
                                    }
                                    else
                                    {
                                        imgConsentIcon.Attributes.Add("class", "linkStyle");
                                        //myscript += "var ImageConsentcontext" + MedicationId + "={MedicationId:" + MedicationId + ",MedicationScriptId:" + "-1" + ",MedicationInstructionsId:" + drTemp["MedicationInstructionId"].ToString() + ",TableId:'" + tblId + "',RowId:'" + ImageConsentRowId1 + "',ClientMedicationConsentId:'" + clientMedicationConsentId + "',ClientId:'" + client + "',ViewConsentReport:'ViewReport'};";
                                        myscript += "var ImageConsentcontext" + MedicationId.ToString().Replace('-', '$') +
                                                    "={MedicationId:" + MedicationId + ",MedicationScriptId:" + "-1" +
                                                    ",MedicationInstructionsId:" + drTemp["MedicationInstructionId"] +
                                                    ",TableId:'" + tblId + "',RowId:'" + ImageConsentRowId1 +
                                                    "',ClientMedicationConsentId:'" + clientMedicationConsentId +
                                                    "',ClientId:'" + client +
                                                    "',ViewConsentReport:'ViewReport',YellowClick:'G'};";
                                        myscript += "var ImageConsentclickCallback" +
                                                    MedicationId.ToString().Replace('-', '$') + " =";
                                        myscript += " Function.createCallback(" + _onImageConsentClickEventHandler +
                                                    ", ImageConsentcontext" + MedicationId.ToString().Replace('-', '$') +
                                                    ");";
                                        myscript += "$addHandler($get('" + ClientID + ClientIDSeparator +
                                                    imgConsentIcon.ClientID + "'), 'click', ImageConsentclickCallback" +
                                                    MedicationId.ToString().Replace('-', '$') + ");";
                                    }
                                }
                            }
                        }
                    }
                    //else if (SignedByMD == 0 && PrescribedBy != string.Empty)
                    //Changed the conditions as ref to Task#3099 Do not Show Consent Warning for Non-Ordered Medications
                    else if (SignedByMD == 0 && PrescribedBy != string.Empty && ordered != "N")
                    {
                        imgConsentIcon.ID = "ImgConsent_" + newId;
                        imgConsentIcon.Src = "~/App_Themes/Includes/Images/warning.gif";
                        imgConsentIcon.Attributes.Add("title", "Missing Consent");
                        tdConsentIcon.Controls.Add(imgConsentIcon);
                    }
                }
                #endregion

                //Added by Anuj for task ref #3 on 16 nov,2009 SDI Projects FY10 - Venture
                //Will show the approval button based on the Conditions.
                var tdButtonApproval = new TableCell();
                //HtmlButton buttonApproval = new HtmlButton();
                var buttonApproval = new HtmlImage();
                bool _ApprovalStatus = false;
                if (VerbalOrder == 1)
                {
                    buttonApproval.ID = "ButtonApproval" + MedicationId.ToString();
                    if (prescriberId == ((StreamlineIdentity)Context.User.Identity).UserId)
                    {
                        buttonApproval.Attributes.Add("onclick",
                                                      "ButtonVerbalOrderClick(" + drTemp["MedicationScriptId"] +
                                                      ",'V');return false;");
                        Session["OpenVerbalOrder"] = "V";
                        buttonApproval.Attributes.Add("title", "Verbal order waiting approval");
                        // Modified by Malathi Shiva: WRT Valley Customizations: Task# 68 
                        // When the logged in staff and the Prescriber matches, it should allow to Adjust/ Schedule the medication from the Medication List - Patient Summary screen
                        //_ApprovalStatus = true;
                        buttonApproval.Src = "~/App_Themes/Includes/Images/v-icon.jpg";
                    }
                    else
                    {
                        buttonApproval.Attributes.Add("disabled", "disabled");
                        _ApprovalStatus = true;
                        buttonApproval.Attributes.Add("title", "Verbal order waiting approval");
                        buttonApproval.Src = "~/App_Themes/Includes/Images/DisabledV.gif";
                    }

                    //condition added by Loveena 
                    if (((StreamlineIdentity)Context.User.Identity).VerbalOrdersRequireApproval == "Y")
                        tdButtonApproval.Controls.Add(buttonApproval);
                }
                else if (VerbalOrder == 2)
                {
                    //HtmlButton buttonOrderApproval = new HtmlButton();
                    var buttonOrderApproval = new HtmlImage();

                    buttonOrderApproval.ID = "ButtonOrderApproval" + MedicationId.ToString();
                    if (prescriberId == ((StreamlineIdentity)Context.User.Identity).UserId)
                    {
                        buttonOrderApproval.Attributes.Add("onclick",
                                                           "ButtonVerbalOrderClick(" + drTemp["MedicationScriptId"] +
                                                           ",'A');return false;");
                        Session["OpenVerbalOrder"] = "A";
                        // Modified by Malathi Shiva: WRT Valley Customizations: Task# 68 
                        // When the logged in staff and the Prescriber matches, it should allow to Adjust/ Schedule the medication from the Medication List - Patient Summary screen
                        //_ApprovalStatus = true;
                        buttonOrderApproval.Attributes.Add("title", "Requires Prescriber Approval");
                        buttonOrderApproval.Src = "~/App_Themes/Includes/Images/enabledA.gif";
                    }
                    else
                    {
                        buttonOrderApproval.Attributes.Add("disabled", "disabled");
                        buttonOrderApproval.Attributes.Add("title", "Requires Prescriber Approval");
                        _ApprovalStatus = true;
                        buttonOrderApproval.Src = "~/App_Themes/Includes/Images/disabledA.gif";
                    }
                    tdButtonApproval.Controls.Add(buttonOrderApproval);
                }
                //Ened Over here
                var tdStartDate = new TableCell();
                //tdStartDate.Text = drTemp["StartDate"] == DBNull.Value ? "" : drTemp["StartDate"].ToString();
                if (_showDateInitiatedLabel)
                {
                    tdStartDate.Text = OrderDate;
                }
                else
                {
                    tdStartDate.Text = startDate;
                }
              //  tdStartDate.Style.Add("text-align", "center");

                var tdEndDate = new TableCell();
                //tdEndDate.Text = drTemp["EndDate"] == DBNull.Value ? "" : drTemp["EndDate"].ToString();
                tdEndDate.Text = endDate;

                var tdMedication = new TableCell();
                //tdMedication.Text = drTemp["Medication"] == DBNull.Value ? "" : drTemp["Medication"].ToString();

                //Added By Chandan on 12th Dec 2008
                var tdOrderStart = new TableCell();
                //tdOrderStart.Text = drTemp["StartDate"] == DBNull.Value ? "" : drTemp["StartDate"].ToString();
                if (drTemp["StartDate"] != null && drTemp["StartDate"] != DBNull.Value &&
                    drTemp["StartDate"].ToString() != "")
                {
                    tdOrderStart.Text = Convert.ToDateTime(drTemp["StartDate"]).ToString("MM/dd/yyyy");
                }
               // tdOrderStart.Style.Add("text-align", "center");
                //else
                //    tdOrderStart.Text = startDate;

                var tdOrderEnd = new TableCell();
                //tdOrderEnd.Text = drTemp["EndDate"] == DBNull.Value ? "" : drTemp["EndDate"].ToString();
                if (drTemp["EndDate"] != null && drTemp["EndDate"] != DBNull.Value && drTemp["EndDate"].ToString() != "")
                {
                    tdOrderEnd.Text = Convert.ToDateTime(drTemp["EndDate"]).ToString("MM/dd/yyyy");
                }
                //tdOrderEnd.Style.Add("text-align", "center");
                //else
                //    tdOrderEnd.Text = endDate;
                //End BY Chandan

                var lblMedication = new Label();
                //Following added by sonia
                //Task #42 View History:"Medication" link & cross mark to discontinue are not working.
                //To avoid multiple events attaching problem scriptId needs to be provided in Label's id so that unique event is fired
                if (MedicationScriptId != "")
                    //Modified by Loveena in ref to Task#3062 to avoid On the View Medication History page, 
                    //if user clicks on the Discontinued Medication Name link then the Order Details page not opens up.
                    //lblMedication.ID = "Lbl_" + MedicationId.ToString() + "_" + MedicationScriptId.ToString() ;
                    lblMedication.ID = "Lbl_" + MedicationId.ToString() + "_" + MedicationScriptId + OrderStatus;
                //code ended by sonia
                else
                    lblMedication.ID = "Lbl_" + MedicationId.ToString();

                lblMedication.Text = drTemp["Medication"] == DBNull.Value ? "" : drTemp["Medication"].ToString();
                 tdMedication.Controls.Add(lblMedication);

                var tdRadioButton = new TableCell();
                string rowId = ClientID + ClientIDSeparator + trTemp.ClientID;
                var rbTemp = new HtmlInputRadioButton();


                if (drTemp["InformationComplete"].ToString() == "N")
                {
                    rbTemp.Style.Add("background-color", "Red");
                    //tdRadioButton.ToolTip = "Incomplete information . Please click to enter all information."; Comented by Pradeep as per task#12
                    //Modified in ref to Task#3099 Do not Show Consent Warning for Non-Ordered Medications
                    //if (SignedByMD == 0 && (methodName.ToUpper() == "CHANGE" || methodName.ToUpper() == "REFILL"))//---Written By Pradeep as per task#12(Venture)
                    if (SignedByMD == 0 &&
                        (methodName.ToUpper() == "CHANGE" || methodName.ToUpper() == "REFILL" ||
                         methodName.ToUpper() == "ADJUST") && ordered != "N")
                    //---Written By Pradeep as per task#12(Venture)
                    {
                        tdRadioButton.ToolTip =
                            "Incomplete information and also having missing consent. Please click to enter all information.";
                    }
                    else //---Written By Pradeep as per task#12(Venture)
                    {
                        tdRadioButton.ToolTip = "Incomplete information . Please click to enter all information.";
                    }
                }
                //Modified in ref to Task#3099 Do not Show Consent Warning for Non-Ordered Medications
                else if (SignedByMD == 0 &&
                         (methodName.ToUpper() == "CHANGE" || methodName.ToUpper() == "REFILL" ||
                          methodName.ToUpper() == "ADJUST") && ordered != "N")
                //---Written By Pradeep as per task#12(Venture)
                {
                    rbTemp.Style.Add("background-color", "Red");
                    tdRadioButton.ToolTip = "Missing consent";
                }
                rbTemp.Attributes.Add("MedicationId", drTemp["MedicationId"].ToString());
                rbTemp.Attributes.Add("MedicationInstructionId", drTemp["MedicationInstructionId"].ToString());

                //rbTemp.CheckedChanged += new EventHandler(rbTemp_CheckedChanged);
                rbTemp.ID = "Rb_" + MedicationId.ToString();
                //Code added by Loveena in ref to Task#2536 Ordered Medication: Radio button deselects from the Medication list grid 
                if (Session["SelectedMedicationId"] != null)
                {
                    if (Session["SelectedMedicationId"].ToString() == MedicationId.ToString())
                    {
                        rbTemp.Checked = true;
                    }
                }
                tdRadioButton.Controls.Add(rbTemp);

                if (_showMedicationLink)
                {
                    if (MedicationScriptId == "")
                    {
                        if (lblMedication.Text != "" && MedicationNameId != 0)
                        {
                            lblMedication.Attributes.Add("class", "linkStyle");
                            myscript += "var Linkcontext" + MedicationId.ToString().Replace('-', '$') +
                                        "={MedicationId:" + MedicationId + ",MedicationScriptId:" + "-1" +
                                        ",MedicationInstructionsId:" + drTemp["MedicationInstructionId"] +
                                        ",OrderType:'" + ordered + "',TableId:'" + tblId + "',RowId:'" + rowId + "'};";
                            myscript += "var LinkclickCallback" + MedicationId.ToString().Replace('-', '$') + " =";
                            //Added OrderType in ref to Task#3273 -   	2.6.1 Non-Ordered Medications: Allow Changes
                            myscript += " Function.createCallback(" + (_calledFromControllerName != "" ? _calledFromControllerName + "." : "") + _onLinkClickEventHandler + ", Linkcontext" +
                                        MedicationId.ToString().Replace('-', '$') + ");";
                            myscript += "$addHandler($get('" + ClientID + ClientIDSeparator + lblMedication.ClientID +
                                        "'), 'click', LinkclickCallback" + MedicationId.ToString().Replace('-', '$') +
                                        ");";
                        }
                        else
                        {
                            tdMedication.Attributes.Add("title", lblMedication.Text + " is an User Defined Medication");
                        }
                    }
                    //Code added by Sonia
                    //Task #42 View History:"Medication" link & cross mark to discontinue are not working.
                    //To avoid multiple events attaching problem scriptId needs to be provided in Label's id so that unique event is fired 
                    else
                    {
                        if (lblMedication.Text != "")
                        {
                            lblMedication.Attributes.Add("class", "linkStyle");
                            myscript += "var Linkcontext" + MedicationId.ToString().Replace('-', '$') +
                                        "={MedicationId:" + MedicationId + ",MedicationScriptId:" + MedicationScriptId +
                                        ",MedicationInstructionsId:" + drTemp["MedicationInstructionId"] +
                                        ",OrderType:'" + ordered + "',TableId:'" + tblId + "',RowId:'" + rowId + "'};";
                            myscript += "var LinkclickCallback" + MedicationId.ToString().Replace('-', '$') + " =";
                            //Added OrderType in ref to Task#3273 -   	2.6.1 Non-Ordered Medications: Allow Changes
                            myscript += " Function.createCallback(" + (_calledFromControllerName != "" ? _calledFromControllerName + "." : "") + _onLinkClickEventHandler + ", Linkcontext" +
                                        MedicationId.ToString().Replace('-', '$') + ");";
                            myscript += "$addHandler($get('" + ClientID + ClientIDSeparator + lblMedication.ClientID +
                                        "'), 'click', LinkclickCallback" + MedicationId.ToString().Replace('-', '$') +
                                        ");";
                        }
                    }
                    //code end over here
                }

                if (_showRadioButton)
                {
                    if (lblMedication.Text != "")
                    {
                        myscript += "var Radiocontext" + MedicationId.ToString().Replace('-', '$') + "={MedicationId:" +
                                    MedicationId + ",MedicationInstructionsId:" + drTemp["MedicationInstructionId"] +
                                    ",TableId:'" + tblId + "',RowId:'" + rowId + "'};";
                        myscript += "var RadioclickCallback" + MedicationId.ToString().Replace('-', '$') + " =";
                        myscript += " Function.createCallback(" + _onRadioClickEventHandler + ", Radiocontext" +
                                    MedicationId.ToString().Replace('-', '$') + ");";
                        myscript += "$addHandler($get('" + ClientID + ClientIDSeparator + rbTemp.ClientID +
                                    "'), 'click', RadioclickCallback" + MedicationId.ToString().Replace('-', '$') + ");";
                    }
                }


                var tdDelete = new TableCell();
                var imgTemp = new HtmlImage();
                //Code added by sonia
                //Task #42 View History:"Medication" link & cross mark to discontinue are not working.
                //To avoid multiple events attaching problem scriptId needs to be provided in Label's id so that unique event is fired
                if (MedicationScriptId == "")
                    imgTemp.ID = "Img_" + MedicationId.ToString();
                else
                    imgTemp.ID = "Img_" + MedicationId.ToString() + "_" + MedicationScriptId;


                imgTemp.Attributes.Add("MedicationId", drTemp["MedicationId"].ToString());
                imgTemp.Attributes.Add("MedicationInstructionId", drTemp["MedicationInstructionId"].ToString());

                imgTemp.Src = "~/App_Themes/Includes/Images/deleteIcon.gif";
                if (method == string.Empty)
                    imgTemp.Attributes.Add("title", "Discontinue Medication");
                else
                    imgTemp.Attributes.Add("title", "Delete Medication");
                imgTemp.Attributes.Add("class", "handStyle");
                imgTemp.Disabled = true;
                if (ordered == "Y")
                {
                    imgTemp.Disabled = !((StreamlinePrinciple)Context.User).HasPermission(Permissions.NewOrder) || methodName.ToUpper() == "ADJUST";
                    if (methodName.ToUpper() == "CHANGE" && MedicationId > 0)
                    {
                        imgTemp.Disabled = methodName.ToUpper() == "CHANGE" && MedicationId > 0;
                        imgTemp.Attributes.Add("title", "Can't delete previously ordered medication.");
                    }
                    if (methodName.ToUpper() == "ADJUST" && MedicationId > 0)
                    {
                        imgTemp.Disabled = methodName.ToUpper() == "ADJUST" && MedicationId > 0;
                        imgTemp.Attributes.Add("title", "Can't delete previously ordered medication.");
                    }
                }
                else
                {
                    if (SmartCareOrderEntry != "Y")
                    {
                        imgTemp.Disabled = !((StreamlinePrinciple)Context.User).HasPermission(Permissions.AddMedication) || methodName.ToUpper() == "ADJUST";
                        if (methodName.ToUpper() == "UPDATE MEDICATION" && MedicationId > 0)
                        {
                            imgTemp.Disabled = methodName.ToUpper() == "UPDATE MEDICATION" && MedicationId > 0;
                            imgTemp.Attributes.Add("title", "Can't delete previously added medication.");
                        }
                    }
                }
                //imgTemp.Click += new ImageClickEventHandler(imgTemp_Click);
                //imgTemp.OnClientClick = Page.GetPostBackEventReference(ImageButton1,imgTemp.ClientID);  
                tdDelete.Controls.Add(imgTemp);
                if (_showButton)
                {
                    // A new condition added by client to display Discontinued medications also
                    if (lblMedication.Text != "" && Discontinued == "N")
                    {
                        if (MedicationScriptId == "")
                        {
                            MedicationScriptId = "-1";
                        }
                        if (!imgTemp.Disabled)
                        {
                            myscript += "var Imagecontext" + MedicationId.ToString().Replace('-', '$') + "={MedicationId:" +
                                        MedicationId + ",MedicationInstructionsId:" + drTemp["MedicationInstructionId"] +
                                        ",TableId:'" + tblId + "',RowId:'" + rowId + "',AddOrder:'" +
                                        ((StreamlinePrinciple)Context.User).HasPermission(Permissions.NewOrder) +
                                        "',MedicationScriptId:'" + MedicationScriptId + "',StaffId:'" +
                                        ((StreamlineIdentity)Context.User.Identity).UserId +
                                        "',ClientMedicationConsentId:'" + clientMedicationConsentId +
                                        "',SureScriptsOutgoingMessageId:'" + SureScriptsOutgoingMessageId +
                                        "',PharmacyName:'" + PharmacyName + "'};";
                            myscript += "var ImageclickCallback" + MedicationId.ToString().Replace('-', '$') + " =";
                            myscript += " Function.createCallback($deleteRecord, Imagecontext" +
                                        MedicationId.ToString().Replace('-', '$') + ");";
                            myscript += "$addHandler($get('" + ClientID + ClientIDSeparator + imgTemp.ClientID +
                                        "'), 'click', ImageclickCallback" + MedicationId.ToString().Replace('-', '$') + ");";
                            //myscript += "alert(document.getElementById('" + this.ClientID + this.ClientIDSeparator + imgTemp.ClientID + "'));";
                        }
                    }
                }

                #region Code for new column to indicate that coressponding record is for Ordered on 12/02/2008 in ref to Task # 77.

                var tdOrderIcon = new TableCell();
                var imgOrerIcon = new HtmlImage();
                if (MedicationScriptId == "")
                    imgOrerIcon.ID = "ImgOrder_" + MedicationId.ToString();
                else
                    imgOrerIcon.ID = "ImgOrder_" + MedicationId.ToString() + "_" + MedicationScriptId;

                imgOrerIcon.Src = "~/App_Themes/Includes/Images/RX.GIF";
                imgOrerIcon.Attributes.Add("title", "Ordered Medication");
                if (ordered != "N")
                {
                    tdOrderIcon.Controls.Add(imgOrerIcon);
                }
                   
                var tdExpandCollapse = new TableCell();
                var imgExpandCollapse = new HtmlImage();

                imgExpandCollapse.ID = "ImgExpandCollapse_" + MedicationId.ToString();
               
                imgExpandCollapse.Src = "";
                imgExpandCollapse.Attributes.Add("title", "Expand/Collapse");
                imgExpandCollapse.Attributes.Add("class", "ExpandCollapse");
                tdExpandCollapse.Controls.Add(imgExpandCollapse);
                //end
                #endregion

                //Start: Ref to Task # 2389
                var tdTitrateIcon = new TableCell();
                var imgTitrateIcon = new HtmlImage();
                if (MedicationScriptId == "")
                    imgTitrateIcon.ID = "ImgTitrate_" + MedicationId.ToString();
                else
                    imgTitrateIcon.ID = "ImgTitrate_" + MedicationId.ToString() + "_" + MedicationScriptId;

                //Code Modified by Loveena on 20 -May -2009
                //imgTitrateIcon.Src = "~/App_Themes/Includes/Images/Titrate.GIF";
                if (titrateMode == "T")
                {
                    imgTitrateIcon.Src = "~/App_Themes/Includes/Images/Titrate.GIF";
                    imgTitrateIcon.Attributes.Add("title", "Titrate Medication");
                }
                else if (titrateMode == "P")
                {
                    imgTitrateIcon.Src = "~/App_Themes/Includes/Images/Taper.gif";
                    imgTitrateIcon.Attributes.Add("title", "Taper Medication");
                }
                //Modified code ends over here.


                tdTitrateIcon.Controls.Add(imgTitrateIcon);
                //End: Ref to Task # 2389
               
               
                var tdCheckbox = new TableCell();
                var chkTemp = new CheckBox();
                if (MedicationScriptId == "-1")
                    chkTemp.Visible = false;
                chkTemp.ID = "Chk_" + drTemp["MedicationId"];
                chkTemp.Attributes.Add("onclick", "EnableDisableChangeOrderButton(this)");
                if (COMPLETEORDERSTORX == "Y")
                {
                    if (SmartCareOrderEntry == "Y" && ordered != "Y")
                    {
                        chkTemp.Attributes.Add("onclick", "EnableDisableCompleteOrderbtn(this, 'SmartCareOrders')");
                        chkTemp.Attributes.Add("class", "SmartCareOrders");
                    }
                    else
                    {
                        chkTemp.Attributes.Add("onclick", "EnableDisableCompleteOrderbtn(this, 'RxMedications')");
                        chkTemp.Attributes.Add("class", "RxMedications");
                    }

                }
                else
                {
                    if (SmartCareOrderEntry == "Y" && ordered != "Y")
                    {
                        chkTemp.Attributes.Add("onclick", "EnableDisableCompleteOrderbtn(this, 'SmartCareOrders')");
                        chkTemp.Attributes.Add("class", "SmartCareOrders_N");
                    }
                }
                ClientMedications clientMed = new ClientMedications();
                DataTable dtCategory = clientMed.GetDrugCategory(MedicationNameId);
                bool enableChangeOrderButton = true;

                if ((dtCategory.Rows.Count > 0))  //Added By Pranay w.r.t Harbor - Support: #1689 Rx - Medication History Error Message
                {
                    chkTemp.InputAttributes.Add("DrugCategory", dtCategory.Rows[0][0].ToString());
                }
                if (ordered == "Y" || COMPLETEORDERSTORX == "Y"  || COMPLETEORDERSTORX == "N")
                {
                   tdCheckbox.Controls.Add(chkTemp);
                }

                if (_showCheckBox)
                {
                
                    if (lblMedication.Text != "")
                    {
                        if (dtCategory != null && dtCategory.Rows.Count > 0)
                        {
                            if (!PharmacyName.ToLower().Equals("printed") && (Convert.ToString(dtCategory.Rows[0][0]) == "2" || Convert.ToString(dtCategory.Rows[0][0]) == "3" || Convert.ToString(dtCategory.Rows[0][0]) == "4" || Convert.ToString(dtCategory.Rows[0][0]) == "5"))
                            {
                                enableChangeOrderButton = false;
                            }
                        }

                        myscript += "var Checkcontext" + MedicationId.ToString().Replace('-', '$') + "={MedicationId:" +
                                    MedicationId + ",MedicationInstructionsId:" + drTemp["MedicationInstructionId"] +
                                    ",TableId:'" + tblId + "',RowId:'" + rowId + "',ApprovalStatus:'" + _ApprovalStatus +
                                    "',Ordered:'" + ordered + "',EnableChangeOrderButton:'" + enableChangeOrderButton + "'};";
                        myscript += "var CheckclickCallback" + MedicationId.ToString().Replace('-', '$') + " =";


                        myscript += " Function.createCallback(" + _onCheckBoxClickEventHandler + ", Checkcontext" +
                                    MedicationId.ToString().Replace('-', '$') + ");";
                        if (MedicationScriptId != "-1")
                            myscript += "$addHandler($get('" + ClientID + ClientIDSeparator + chkTemp.ClientID +
                                        "'), 'click', CheckclickCallback" + MedicationId.ToString().Replace('-', '$') +
                                        ");";
                    }
                }

                var tdEduInfo = new TableCell();
                var imgEDUCA = new HtmlImage();
                imgEDUCA.ID = "ImgIcon_EducationInfo";
                imgEDUCA.Src = "~/App_Themes/Includes/Images/Educationinfo.png";
                imgEDUCA.Attributes.Add("onclick", "openEducationInformationDetalisForDiagnosis(" + MedicationNameId + ");return false;");
                tdEduInfo.Controls.Add(imgEDUCA);


                var tdchButton = new TableCell();
                var btnTemp = new HtmlButton();
                btnTemp.ID = "Btn_" + drTemp["MedicationId"];
                btnTemp.InnerText = "Ch";

                tdchButton.Controls.Add(btnTemp);

                if (_showChButton)
                {
                    if (lblMedication.Text != "")
                    {
                        myscript += "var Buttoncontext" + MedicationId.ToString().Replace('-', '$') + "={MedicationId:" +
                                    MedicationId + ",MedicationInstructionsId:" + drTemp["MedicationInstructionId"] +
                                    ",TableId:'" + tblId + "',RowId:'" + rowId + "',MethodName:'" + methodName.ToUpper() +
                                    "'};";
                        myscript += "var ButtonclickCallback" + MedicationId.ToString().Replace('-', '$') + " =";
                        myscript += " Function.createCallback(" + _onButtonClickEventHandler + ", Buttoncontext" +
                                    MedicationId.ToString().Replace('-', '$') + ");";
                        myscript += "$addHandler($get('" + ClientID + ClientIDSeparator + btnTemp.ClientID +
                                    "'), 'click', ButtonclickCallback" + MedicationId.ToString().Replace('-', '$') +
                                    ");";
                    }
                }
                //TableCell tdMedication = new TableCell();
                //tdMedication.Text = drTemp["Medication"] == DBNull.Value ? "" : drTemp["Medication"].ToString();

                var tdOrder = new TableCell();
                tdOrder.Text = drTemp["Instruction"] == DBNull.Value ? "" : drTemp["Instruction"].ToString();
                //Code added by Anto in ref to CEI - Support Go Live #142
                tdOrder.Attributes.Add("title", drTemp["Instruction"].ToString());
                //Code ends here in ref to CEI - Support Go Live #142
                var tdRefills = new TableCell();
                tdRefills.Text = drTemp["Refills"] == DBNull.Value ? "" : drTemp["Refills"].ToString();

                var tdCalculatedQty = new TableCell();
                tdCalculatedQty.Text = drTemp["CalculatedQty"] == DBNull.Value ? "" : drTemp["CalculatedQty"].ToString();

                var tdWarning = new TableCell();
                tdWarning.Controls.Add(tblInteraction);
                var tdAcknowledge = new TableCell();
                var btnAckTemp = new HtmlButton();
                //Code added in ref to task#3064
                btnAckTemp.Attributes.Add("class", "btnimgexsmall");

                #region Code in ref to task # 75

                var tdStepNumber = new TableCell();
                tdStepNumber.Text = drTemp["TitrationStepNumber"] == DBNull.Value
                                        ? ""
                                        : drTemp["TitrationStepNumber"].ToString();
                var tdDayNumber = new TableCell();
                tdDayNumber.Text = drTemp["DayNumber"] == DBNull.Value ? "" : drTemp["DayNumber"].ToString();
                var tdDays = new TableCell();
                tdDays.Text = drTemp["Days"] == DBNull.Value ? "" : drTemp["Days"].ToString();
                var tdPharmacy = new TableCell();
                tdPharmacy.Text = drTemp["Pharmacy"] == DBNull.Value ? "" : drTemp["Pharmacy"].ToString();
                var tdSample = new TableCell();
                tdSample.Text = drTemp["Sample"] == DBNull.Value ? "" : drTemp["Sample"].ToString();
                var tdStock = new TableCell();
                tdStock.Text = drTemp["Stock"] == DBNull.Value ? "" : drTemp["Stock"].ToString();

                var tdDateWarningIcon = new TableCell();
                var imgDateWarning = new HtmlImage();
                if (MedicationScriptId == "")
                    imgDateWarning.ID = "ImgOrder_" + MedicationId.ToString();
                else
                    imgDateWarning.ID = "ImgOrder_" + MedicationId.ToString() + "_" + MedicationScriptId;
                imgDateWarning.Src = "~/App_Themes/Includes/Images/warning.gif";
                imgDateWarning.Attributes.Add("class", "handStyle");
                tdDateWarningIcon.Controls.Add(imgDateWarning);

                var tdCumulativeInfoIcon = new TableCell();
                var imgCumulativeInfo = new HtmlImage();
                if (MedicationScriptId == "")
                    imgCumulativeInfo.ID = "ImgOrder_" + MedicationId.ToString();
                else
                    imgCumulativeInfo.ID = "ImgOrder_" + MedicationId.ToString() + "_" + MedicationScriptId;
                imgCumulativeInfo.Src = "~/App_Themes/Includes/Images/information.gif";
                imgCumulativeInfo.Attributes.Add("class", "handStyle");
                tdCumulativeInfoIcon.Controls.Add(imgCumulativeInfo);

                #endregion

                //Changes by Sonia
                //Task #82 (Drug Interactions)
                //Acknowledge button should be displayed if a Client Medication has interaction with both types of medications i.e with severity level 1 & 3
                if (tblInteraction.Attributes["MedicationId"] != null && tblInteraction.Rows[0].Cells.Count > 0 &&
                    _boolRowWithInteractionFound)
                {
                    btnAckTemp.ID = "BtnAck_" + drTemp["MedicationId"];
                    if (tblInteraction.Attributes["PrescriberAcknowledged"] == "false")
                    {
                        btnAckTemp.InnerText = "Acknowledge";
                        btnAckTemp.Disabled = false;

                        //Changes by Sonia
                        //Task #82 (Drug Interactions)
                        //Acknowledge button should be displayed if a Client Medication has interaction with both types of medications i.e with severity level 1 & 3
                        //and further only in Order,Change Order,Refill Order and Non order screens only

                        if (_showAcknowledge)
                        {
                            //Added one more parameter in ref to Task#2983
                            myscript += "var ButtonAckcontext" + MedicationId.ToString().Replace('-', '$') +
                                        "={MedicationId:" + MedicationId + ",MedicationInstructionsId:" +
                                        drTemp["MedicationInstructionId"] + ",ClickType:'Interaction',TableId:'" + tblId +
                                        "',RowId:'" + rowId + "'};";
                            myscript += "var ButtonAckclickCallback" + MedicationId.ToString().Replace('-', '$') + " =";
                            myscript += " Function.createCallback(" + _onAcknowledgeClickEventHandler +
                                        ", ButtonAckcontext" + MedicationId.ToString().Replace('-', '$') + ");";
                            myscript += "$addHandler($get('" + ClientID + ClientIDSeparator + btnAckTemp.ClientID +
                                        "'), 'click', ButtonAckclickCallback" +
                                        MedicationId.ToString().Replace('-', '$') + ");";
                        }
                    }
                    else
                    {
                        btnAckTemp.InnerText = "Acknowledged";
                        btnAckTemp.Disabled = true;
                    }

                    tdAcknowledge.Controls.Add(btnAckTemp);
                }

                else
                {
                    //Code added by Loveena in ref to Task#2983
                    if (_dtMedicationAllergyTemp.Rows.Count > 0)
                    {
                        DataRow[] drAllergy = _dtMedicationAllergyTemp.Select("MedicationNameId=" + MedicationNameId);
                        if (drAllergy.Length > 0)
                        {
                            if (drAllergy.Length > 0)
                            {
                                foreach (DataRow drAType in drAllergy) //--By Pradeep
                                {
                                    AllergyType = drAType["AllergyType"] == null
                                                      ? ""
                                                      : Convert.ToString(drAType["AllergyType"]); //--By Pradeep  
                                    if (AllergyType == "A" &&
                                        ((StreamlineIdentity)Context.User.Identity).AllowAllergyMedications == "Y")
                                    {
                                        btnAckTemp.ID = "BtnAck_" + drTemp["MedicationId"];
                                        if (AllowAllergyMedications == "Y")
                                        {
                                            btnAckTemp.InnerText = "Acknowledged";
                                            btnAckTemp.Disabled = true;
                                        }
                                        else
                                        {
                                            btnAckTemp.InnerText = "Acknowledge";
                                            btnAckTemp.Disabled = false;
                                            if (_showAcknowledge)
                                            {
                                                myscript += "var ButtonAckcontext" +
                                                            MedicationId.ToString().Replace('-', '$') +
                                                            "={MedicationId:" + MedicationId +
                                                            ",ClickType:'Allergy',TableId:'" + tblId + "',RowId:'" +
                                                            rowId + "'};";
                                                myscript += "var ButtonAckclickCallback" +
                                                            MedicationId.ToString().Replace('-', '$') + " =";
                                                myscript += " Function.createCallback(" +
                                                            _onAcknowledgeClickEventHandler + ", ButtonAckcontext" +
                                                            MedicationId.ToString().Replace('-', '$') + ");";
                                                myscript += "$addHandler($get('" + ClientID + ClientIDSeparator +
                                                            btnAckTemp.ClientID + "'), 'click', ButtonAckclickCallback" +
                                                            MedicationId.ToString().Replace('-', '$') + ");";
                                            }
                                        }
                                        tdAcknowledge.Controls.Add(btnAckTemp);
                                    }
                                }
                            }
                        }
                    }
                }

                var tdDAW = new TableCell();

                //Code Added by Loveena in Ref to Task#129 to add DAW Value on 19-Dec-2008
                var lblDAW = new Label();
                if (drTemp["DAWorQuantity"].ToString().ToUpper() == "Y")
                    lblDAW.Text = "Y";
                else
                    lblDAW.Text = "N";

                lblDAW.ID = "lblDAW" + newId;
                tdDAW.Controls.Add(lblDAW);

                if (_showDAW)
                {
                    if (lblMedication.Text != "")
                    {
                        myscript += "var CheckDAWcontext" + MedicationId.ToString().Replace('-', '$') +
                                    "={MedicationId:" + MedicationId + ",MedicationInstructionsId:" +
                                    drTemp["MedicationInstructionId"] + ",TableId:'" + tblId + "',RowId:'" + rowId +
                                    "'};";
                        myscript += "var CheckDAWclickCallback" + MedicationId.ToString().Replace('-', '$') + " =";
                        myscript += " Function.createCallback(" + _onDAWClickEventHandler + ", CheckDAWcontext" +
                                    MedicationId.ToString().Replace('-', '$') + ");";
                        //Code Added by Loveena in Ref to Task#129 on 19-Dec-2008
                        myscript += "$addHandler($get('" + ClientID + ClientIDSeparator + lblDAW.ClientID +
                                    "'), 'click', CheckDAWclickCallback" + MedicationId.ToString().Replace('-', '$') +
                                    ");";
                    }
                }


                if (_showRadioButton)
                {
                    if (lblMedication.Text == "")
                    {
                        tdRadioButton.Controls.Clear();
                        tdRadioButton.Text = "";
                    }
                    trTemp.Cells.Add(tdRadioButton);
                }

                if (_showCheckBox)
                {
                    //Code Modified to have the check box against non-ordered as well like ordered in ref to Task # 77. 
                    if (lblMedication.Text == "")
                    {
                        tdCheckbox.Controls.Clear();
                        tdCheckbox.Text = "";
                    }
                    trTemp.Cells.Add(tdCheckbox);
                }

                if (_showButton)
                {
                    if (lblMedication.Text == "" || Discontinued == "Y")
                    {
                        tdDelete.Controls.Clear();
                        tdDelete.Text = "";
                    }
                    trTemp.Cells.Add(tdDelete);
                }

                //Start: Code added in ref to Task #77 on 12/03/2008
                if (_showOrderedIcon)
                {
                    if (lblMedication.Text == "" || SmartCareOrderEntry == "Y")
                    {
                        if (SmartCareOrderEntry == "Y" && ordered != "Y" && lblMedication.Text!="")
                        {
                            imgOrerIcon.Src = COMPLETEORDERSTORX == "Y" ? "~/App_Themes/Includes/Images/T.GIF" : "~/App_Themes/Includes/Images/IP.GIF";
                            imgOrerIcon.Attributes.Add("title", "SmartCare Order Entry Medication");
                            tdOrderIcon.Controls.Add(imgOrerIcon);
                        }

                        else if (SmartCareOrderEntry == "Y" && ordered == "Y" && lblMedication.Text != "")
                        {
                            imgOrerIcon.Src = "~/App_Themes/Includes/Images/IP.GIF";
                            imgOrerIcon.Attributes.Add("title", "SmartCare Order Entry Medication");
                            tdOrderIcon.Controls.Add(imgOrerIcon);
                        }

                        else
                        {
                            tdOrderIcon.Controls.Clear();
                            tdOrderIcon.Text = "";
                        }
                    }
                   // trTemp.Cells.Add(tdOrderIcon);                   
                    if (_calledFromControllerName == "ViewMedicationHistory")
                    {
                        if (Session["Collapse"] == "Collapse")
                        {
                            tdOrderIcon.Controls.Clear();
                            tdOrderIcon.Text = "";
                            trTemp.Cells.Add(tdOrderIcon);
                        }
                        else
                        {
                            trTemp.Cells.Add(tdOrderIcon);
                        }
                    }
                    else
                    {
                        trTemp.Cells.Add(tdOrderIcon);
                    }                    
                }
                //End: Code added in ref to Task #77 on 12/03/2008
                if (_calledFromControllerName == "ViewMedicationHistory")
                {
                if (Session["expand"] == "expand")
                {
                    trTemp.Cells.Add(tdExpandCollapse);

                }
                else {
                    tdExpandCollapse.Controls.Clear();
                    tdExpandCollapse.Text = "";

                    trTemp.Cells.Add(tdExpandCollapse);
                }
                }
                //Added by Anuj for task ref #3 on 16nov,2009 SDI Projects FY10 - Venture
                if (_showApprovalButton)
                {
                    if (lblMedication.Text == "" || Discontinued == "Y")
                    {
                        tdButtonApproval.Controls.Clear();
                        tdButtonApproval.Text = "";
                    }
                    trTemp.Cells.Add(tdButtonApproval);
                }
                //Ended over here
                //Start: Ref to Task # 2389
                if (_showTitrateIcon)
                {
                    if (lblMedication.Text == "" || titrateMode == "")
                    {
                        tdTitrateIcon.Controls.Clear();
                        tdTitrateIcon.Text = "";
                    }
                    trTemp.Cells.Add(tdTitrateIcon);
                }
                 //End: Ref to Task # 2389
                if (_calledFromControllerName == "ViewMedicationHistory")
                {
                    if (Session["Collapse"] == "Collapse")
                    {
                        tdTitrateIcon.Controls.Clear();
                        tdTitrateIcon.Text = "";
                        trTemp.Cells.Add(tdTitrateIcon);
                    }
                    else
                    {
                        trTemp.Cells.Add(tdTitrateIcon);
                    }
                }

                if (_showChButton)
                {
                    if (lblMedication.Text == "")
                    {
                        tdchButton.Controls.Clear();
                        tdchButton.Text = "";
                    }
                    trTemp.Cells.Add(tdchButton);
                }

                if (_showStepNo)
                    trTemp.Cells.Add(tdStepNumber);
                if (_showDayNo)
                    trTemp.Cells.Add(tdDayNumber);

                if (_calledFromControllerName == "MedicationMgt" || _calledFromControllerName == "ClientMedicationOrder")
                {
                    if (lblMedication.Text == "")
                    {
                        tdEduInfo.Controls.Clear();
                        tdEduInfo.Text = "";
                    }
                    trTemp.Cells.Add(tdEduInfo);
                }

                //trTemp.Cells.Add(tdEndDate);
                if (_showMedicationName)
                    trTemp.Cells.Add(tdMedication);
                //Start: Code added in ref to Task #2465 on 08-May-2009
                if (_showConsentIcon)
                {
                    if (lblMedication.Text == "")
                    {
                        tdConsentIcon.Controls.Clear();
                        tdConsentIcon.Text = "";
                    }
                    trTemp.Cells.Add(tdConsentIcon);
                }
                //End: Code added in ref to Task #2465 on 08-May-2009
                if (_showDateInitiated)
                    trTemp.Cells.Add(tdStartDate);
                trTemp.Cells.Add(tdOrder);

                if (_showDateWarning)
                    trTemp.Cells.Add(tdDateWarningIcon);

                //Added By Chandan on 12th Dec 2008


                trTemp.Cells.Add(tdOrderStart);

                if (_showDays)
                    trTemp.Cells.Add(tdDays);

                trTemp.Cells.Add(tdOrderEnd);
                //End By Chandan

                if (_showQuantity)
                    trTemp.Cells.Add(tdCalculatedQty);
                if (_showRefill)
                    trTemp.Cells.Add(tdRefills);

                if (_showDAW)
                {
                    if (lblMedication.Text == "")
                    {
                        tdDAW.Controls.Clear();
                        tdDAW.Text = "";
                    }
                    trTemp.Cells.Add(tdDAW);
                }

                if (_showDrugWarning)
                    trTemp.Cells.Add(tdWarning);
                var tdPrescribed = new TableCell();
                tdPrescribed.Text = PrescribedBy;

                if (_showPrescribedBy)
                {
                    if (lblMedication.Text == "")
                    {
                        tdPrescribed.Controls.Clear();
                        tdPrescribed.Text = "";
                    }
                    trTemp.Cells.Add(tdPrescribed);
                }

                //Code added by Anto in ref to Task CEI - Support Go Live #142
                if (_calledFromControllerName == "MedicationMgt")
                {
                    var tdPharmacyname = new TableCell();
                    var pharmacyaddress = "";
                    var pharname = "";
                    //Code added by Malathi Shiva WRT Thresholds - Support #668, Pharmacy name with special characters where not loading correctly since the special characters where not encode/decodes
                    PharmacyName = System.Web.HttpUtility.UrlDecode(PharmacyName);
                    if (PharmacyName != "")
                    {
                        var pharmacynamesplit = PharmacyName.Split('~');
                        if (pharmacynamesplit[0].ToString() != "Printed")
                        {
                            pharname = pharmacynamesplit[0].ToString();
                            if (pharname.Length > 25) pharname = pharname.Substring(0, 25);
                            if (pharmacynamesplit.Length < 4)
                            {
                                pharmacyaddress = pharmacynamesplit[0] + ',' + pharmacynamesplit[1] + ',' + pharmacynamesplit[2];
                            }
                            else
                            {
                                pharmacyaddress = pharmacynamesplit[0] + ',' + pharmacynamesplit[1] + ',' + pharmacynamesplit[2] + ',' + pharmacynamesplit[3];

                            }
                        }
                        else
                        {
                            pharname = "Printed";
                            pharmacyaddress = "Printed";
                        }

                    }
                    tdPharmacyname.Text = pharname;
                    trTemp.Cells.Add(tdPharmacyname);
                    tdPharmacyname.Attributes.Add("title", pharmacyaddress.ToString());
                }
                //Code ends here in ref to Task CEI - Support Go Live #142


                //----Start Added By Pradeep as per task#32
                //Aded the condition by Loveena in ref to Task#2779
                if (_showComments)
                {
                    var tdComments = new TableCell();
                    var imgCommens = new HtmlImage();
                    if (MedicationScriptId == "")
                        imgCommens.ID = "ImgCommens_" + MedicationId.ToString();
                    else
                        imgCommens.ID = "ImgCommens_" + MedicationId.ToString() + "_" + MedicationScriptId;
                    imgCommens.Src = "~/App_Themes/Includes/Images/comment.png";
                    if (Comments != string.Empty)
                    {
                        imgCommens.Attributes.Add("title", Comments);
                        tdComments.Controls.Add(imgCommens);
                        //Added by Loveena in ref to Task#32
                        if (lblMedication.Text == "")
                        {
                            tdComments.Controls.Clear();
                            tdComments.Text = "";
                        }
                        //Code added by Loveena ends over here.
                    }
                    trTemp.Cells.Add(tdComments);
                }
                //----END Added By Pradeep as per task#32
                //Changes as per Task #2381 and 2377
                var tdOrderStatus = new TableCell();
                tdOrderStatus.Text = OrderStatus;
               // tdOrderStatus.Style.Add("text-align", "center");

                if (_showOrderStatus)
                {
                    if (lblMedication.Text == "")
                    {
                        tdOrderStatus.Controls.Clear();
                        tdOrderStatus.Text = "";
                    }
                    trTemp.Cells.Add(tdOrderStatus);
                }

                var tdOrderStatusDate = new TableCell();
                tdOrderStatusDate.Text = OrderStatusDate;
               // tdOrderStatusDate.Style.Add("text-align", "center");

                if (_showOrderStatusDate)
                {
                    if (lblMedication.Text == "")
                    {
                        tdOrderStatusDate.Controls.Clear();
                        tdOrderStatusDate.Text = "";
                    }
                    trTemp.Cells.Add(tdOrderStatusDate);
                }

                var tdOffLabel = new TableCell();
                tdOffLabel.Text = offLabel;
                //tdOffLabel.Style.Add("text-align", "center");

                //Added by Loveena in ref to Task#2433 on 11-April-2009 to display OffLabel and
                //DiscintinuedReason Column in View History.
                if (_showOffLabel)
                {
                    //Added by Anuj on 25May,2010 for task ref:3062
                    if (lblMedication.Text == "")
                    {
                        tdOffLabel.Controls.Clear();
                        tdOffLabel.Text = "";
                    }
                    //ended over here
                    trTemp.Cells.Add(tdOffLabel);
                }

                var tdAddedBy = new TableCell();
                tdAddedBy.Text = AddedBy;



                if (_calledFromControllerName == "ViewMedicationHistory" || _calledFromControllerName == "MedicationMgt")
                {

                    if (lblMedication.Text == "")
                    {
                        tdAddedBy.Controls.Clear();
                        tdAddedBy.Text = "";
                    }

                    trTemp.Cells.Add(tdAddedBy);
                }


                var tdDiscontinuedBy = new TableCell();
                tdDiscontinuedBy.Text = DiscontinuedBy;

              

                if (_calledFromControllerName == "ViewMedicationHistory")
                {

                    if (lblMedication.Text == "")
                    {
                        tdDiscontinuedBy.Controls.Clear();
                        tdDiscontinuedBy.Text = "";
                    }

                    trTemp.Cells.Add(tdDiscontinuedBy);
                   
                    
                }

                var tdDiscontinuedReason = new TableCell();
                tdDiscontinuedReason.Text = DiscontinuedReason;


                if (_showDisContinueReasonLabel)
                {
                    //Added by Anuj on 24May,2010 for task ref:3062
                    if (lblMedication.Text == "")
                    {
                        tdDiscontinuedReason.Controls.Clear();
                        tdDiscontinuedReason.Text = "";
                    }
                    //ended over here
                    trTemp.Cells.Add(tdDiscontinuedReason);
                }

                if (_showAcknowledge && tblInteraction.Attributes["MedicationId"] != null &&
                    tblInteraction.Rows[0].Cells.Count > 0)
                {
                    if (lblMedication.Text == "")
                    {
                        tdAcknowledge.Controls.Clear();
                        tdAcknowledge.Text = "";
                    }
                    trTemp.Cells.Add(tdAcknowledge);
                }

                if (_showPharmacy)
                    trTemp.Cells.Add(tdPharmacy);
                if (_showSample)
                    trTemp.Cells.Add(tdSample);
                if (_showStock)
                    trTemp.Cells.Add(tdStock);
                if (_showCumulativeInfo)
                    trTemp.Cells.Add(tdCumulativeInfoIcon);
                if (_calledFromControllerName == "ViewMedicationHistory")
                {
                    if (lblMedication.Text == null || lblMedication.Text == "")
                    {
                        if (Session["Collapse"] == "Collapse")
                        {
                            trTemp.CssClass = "ExpandCollapseRows";
                        }
                        else
                        {
                            if (Session["expand"] == "expand")
                                trTemp.CssClass = " GridViewRowStyle";

                            else
                                trTemp.CssClass = " ExpandCollapseRows";
                        }
                    }
                    else
                    { //if (Session["Collapse"] == "Collapse") { trTemp.CssClass = "ExpandCollapseRows"; }
                        if (Session["Collapse"] == "Collapse") { trTemp.CssClass = "ExpandCollapseRows"; }
                        else { trTemp.CssClass = "GridViewRowStyle" + " " + rowClass; }
                    }

                    Session["expand"] = "";
                }
                else
                {
                    string _strTempClass = string.Empty;

                    if (lblMedication.Text == null || lblMedication.Text == "")
                    {
                        if (Session["Collapse"] == "Collapse")
                        {
                            _strTempClass = "ExpandCollapseRows";
                        }
                        else
                        {
                            if (Session["expand"] == "expand")
                                _strTempClass = "GridViewRowStyle";

                            else
                                _strTempClass = "ExpandCollapseRows";
                        }
                    }
                    else
                    {
                        if (Session["Collapse"] == "Collapse")
                        {
                            _strTempClass = " ExpandCollapseRows ";
                        }
                        else
                        {
                            _strTempClass = " GridViewRowStyle ";
                        }
                    }

                    Session["expand"] = "";

                    trTemp.CssClass = _strTempClass.Trim() == "ExpandCollapseRows" ? " ExpandCollapseRows " + rowClass + " " : rowClass;

                } 
                return trTemp;
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

        private void imgTemp_Click(object sender, ImageClickEventArgs e)
        {
            var imgTemp = ((ImageButton)sender);
            int MedicationId = Convert.ToInt32(imgTemp.Attributes["MedicationId"]);
            int MedicationInstructionsId = Convert.ToInt32(imgTemp.Attributes["MedicationInstructionId"]);
            var pairTemp = new Pair();
            pairTemp.First = MedicationId;
            pairTemp.Second = MedicationInstructionsId;
            var objUserData = new UserData(pairTemp);
            DeleteButtonClickEvent(sender, objUserData);
        }

        private void rbTemp_CheckedChanged(object sender, EventArgs e)
        {
            var imgTemp = ((RadioButton)sender);
            int MedicationId = Convert.ToInt32(imgTemp.Attributes["MedicationId"]);
            int MedicationInstructionsId = Convert.ToInt32(imgTemp.Attributes["MedicationInstructionId"]);
            var pairTemp = new Pair();
            pairTemp.First = MedicationId;
            pairTemp.Second = MedicationInstructionsId;
            var objUserData = new UserData(pairTemp);
            RadioButtonClickEvent(sender, objUserData);
        }


        protected void ImageButton1_Click(object sender, ImageClickEventArgs e)
        {
        }


        /// <summary>
        /// </summary>
        /// <param name="dtClientMedication"></param>
        /// <param name="dtClientMedicalInstructions"></param>
        /// <param name="dtClientMedicationInteractions"></param>
        /// <param name="dtClientMedicationInteractionDetails"></param>
        /// <param name="dtClientAllergiesInteraction"></param>
        private void CompileDataTableForTitration(DataTable dtClientMedication, DataTable dtClientMedicalInstructions,
                                                  DataTable dtClientMedicationInteractions,
                                                  DataTable dtClientMedicationInteractionDetails,
                                                  DataTable dtClientAllergiesInteraction, int titrationStepNumber)
        {
            try
            {
                _dtMedicationTemp.Clear();
                _dtMedicationInstructionTemp.Clear();
                _dtMedicationInteractionTemp.Clear();
                _dtMedicationAllergyTemp.Clear();

                //Getting max of instructions Id
                var dvClientMedicationInstructions = new DataView(dtClientMedicalInstructions);
                dvClientMedicationInstructions.Sort = "ClientMedicationInstructionId desc";

                DataTable dtClientMedicationCopy = dtClientMedication.Clone();
                if (_sortString.Contains("TitrationStepNumber") || _sortString.Contains("Instruction") ||
                    _sortString.Contains("StartDate") || _sortString.Contains("Days") || _sortString.Contains("EndDate"))
                {
                    dvClientMedicationInstructions.Sort = _sortString;
                    //dvClientMedicationInstructions.RowFilter = "ClientMedicationId >= 0 ";
                    while (dvClientMedicationInstructions.Count > 0)
                    {
                        //string str = " and ClientMedicationId <> " + dvClientMedicationInstructions[0]["ClientMedicationId"].ToString();
                        string str = "ClientMedicationId <> " + dvClientMedicationInstructions[0]["ClientMedicationId"];
                        DataRow[] drTemp =
                            dtClientMedication.Select("ClientMedicationId=" +
                                                      dvClientMedicationInstructions[0]["ClientMedicationId"]);

                        if (drTemp.Length > 0)
                            dtClientMedicationCopy.ImportRow(drTemp[0]);
                        dvClientMedicationInstructions.RowFilter = str;
                        // dvClientMedicationInstructions.RowFilter + str;
                    }
                }
                else if (String.IsNullOrEmpty(_sortString))
                {
                    dvClientMedicationInstructions.Sort = "MedicationName";
                    //dvClientMedicationInstructions.RowFilter = "ClientMedicationId >= 0 ";
                    while (dvClientMedicationInstructions.Count > 0)
                    {
                        //string str = " and ClientMedicationId <> " + dvClientMedicationInstructions[0]["ClientMedicationId"].ToString();
                        string str = "ClientMedicationId <> " + dvClientMedicationInstructions[0]["ClientMedicationId"];
                        DataRow[] drTemp =
                            dtClientMedication.Select(
                                "ClientMedicationId=" + dvClientMedicationInstructions[0]["ClientMedicationId"] +
                                " and isnull(ordered,'N')='Y'", "MedicationStartDate desc");

                        if (drTemp.Length > 0)
                            dtClientMedicationCopy.ImportRow(drTemp[0]);
                        dvClientMedicationInstructions.RowFilter = str;
                        //dvClientMedicationInstructions.RowFilter + str;
                    }
                    dvClientMedicationInstructions.Sort = "MedicationName";
                    //#ka dvClientMedicationInstructions.RowFilter = "ClientMedicationId >= 0 ";
                    while (dvClientMedicationInstructions.Count > 0)
                    {
                        //string str = " and ClientMedicationId <> " + dvClientMedicationInstructions[0]["ClientMedicationId"].ToString();
                        string str = "ClientMedicationId <> " + dvClientMedicationInstructions[0]["ClientMedicationId"];
                        DataRow[] drTemp =
                            dtClientMedication.Select(
                                "ClientMedicationId=" + dvClientMedicationInstructions[0]["ClientMedicationId"] +
                                " and  isnull(ordered,'N')='N'", "MedicationStartDate desc");

                        if (drTemp.Length > 0)
                            dtClientMedicationCopy.ImportRow(drTemp[0]);
                        dvClientMedicationInstructions.RowFilter = str;
                        //dvClientMedicationInstructions.RowFilter + str;
                    }
                }

                foreach (DataRow drMedication in dtClientMedicationCopy.Rows)
                {
                    if (drMedication["RecordDeleted"] == DBNull.Value || drMedication["RecordDeleted"].ToString() == "N")
                    {
                        // Get the Medication Information...
                        string medicationID = drMedication["ClientMedicationId"].ToString();
                        string prescribedBy = drMedication["PrescriberName"].ToString();
                        //Added By Anuj for task ref #3 on 16nov,2009 SDI Projects FY10 - Venture(For Titration)
                        int PrescriberId = 0;
                        if (drMedication["PrescriberId"].ToString() != "" &&
                            drMedication["PrescriberId"].ToString() != null)
                        {
                            PrescriberId = Convert.ToInt32(drMedication["PrescriberId"].ToString());
                        }
                        //Ended Over here
                        string specialInstruction = drMedication["SpecialInstructions"].ToString();
                        string medicationName = drMedication["MedicationName"].ToString();
                        string MedicationStartDate = "";
                        if (_showMinScriptDrugsEndDate)
                        {
                            if (drMedication["MedicationEndDateForDisplay"] != null &&
                                drMedication["MedicationEndDateForDisplay"] != DBNull.Value &&
                                drMedication["MedicationEndDateForDisplay"].ToString() != "")
                            {
                                MedicationStartDate =
                                    DateTime.Parse(drMedication["MedicationEndDateForDisplay"].ToString())
                                            .ToShortDateString();
                            }
                            else
                            {
                                if (string.IsNullOrEmpty(drMedication["MedicationStartDate"].ToString()) == false)
                                {
                                    MedicationStartDate =
                                        DateTime.Parse(drMedication["MedicationStartDate"].ToString())
                                                .ToShortDateString();
                                }
                            }
                        }
                        else
                        {
                            if (string.IsNullOrEmpty(drMedication["MedicationStartDate"].ToString()) == false)
                            {
                                MedicationStartDate =
                                    DateTime.Parse(drMedication["MedicationStartDate"].ToString()).ToShortDateString();
                            }
                        }
                        string MedicationEndDate = drMedication["MedicationEndDate"] == DBNull.Value
                                                       ? ""
                                                       : DateTime.Parse(drMedication["MedicationEndDate"].ToString())
                                                                 .ToShortDateString();
                        string ordered = "Y";
                        string MedicationNameId = "";
                        string Discontinued = "N";
                        if (dtClientMedicationCopy.Columns.Contains("MedicationNameId"))
                            MedicationNameId = drMedication["MedicationNameId"].ToString();
                        if (dtClientMedicationCopy.Columns.Contains("Ordered"))
                            ordered = drMedication["Ordered"] == DBNull.Value ? "N" : drMedication["Ordered"].ToString();
                        if (dtClientMedicationCopy.Columns.Contains("Discontinued"))
                            Discontinued = drMedication["Discontinued"] == DBNull.Value
                                               ? "N"
                                               : drMedication["Discontinued"].ToString();
                        
                        // Add new row in _dtMedicationTemp
                        //Added By Anuj for task ref#3 on 16 nov,2009(For Titration)
                        if (_calledFromControllerName == "ViewMedicationHistory")
                        {
                            int RowNo = int.Parse(drMedication["Row#"].ToString());
                            _dtMedicationTemp.Rows.Add(new object[]  {
                                medicationID, prescribedBy, specialInstruction, MedicationNameId, ordered, Discontinued,
                                MedicationStartDate, MedicationEndDate, PrescriberId,RowNo
                            });
                        }
                        else
                        {
                            _dtMedicationTemp.Rows.Add(new object[]
                            {
                                medicationID, prescribedBy, specialInstruction, MedicationNameId, ordered, Discontinued,
                                MedicationStartDate, MedicationEndDate, PrescriberId
                            });
                        }
                        // Add new rows in _dtMedicationInstructionTemp 
                        DataRow[] drClientMedicationInstructions;
                        drClientMedicationInstructions =
                            dtClientMedicalInstructions.Select("ClientMedicationId='" + medicationID + "'");
                        if (drClientMedicationInstructions.Length != 0)
                        {
                            int _loopCounter = 0;
                            string _firstStepDate = "";

                            foreach (DataRow drMedInstruction in drClientMedicationInstructions)
                            {
                                if (drMedInstruction["RecordDeleted"] == DBNull.Value ||
                                    drMedInstruction["RecordDeleted"].ToString() == "N")
                                {
                                    _loopCounter = _loopCounter + 1;
                                    if (_loopCounter == 1)
                                    {
                                        _firstStepDate = drMedInstruction["StartDate"].ToString();
                                    }
                                    // Check if this start/end date already exists...
                                    // If no, then  we add a new row or we update the instructions of the already present row...
                                    string instructions = drMedInstruction["Instruction"].ToString();
                                    string selectString = "MedicationId = '" + medicationID + "'";
                                    DataRow[] drMedicationIns = _dtMedicationInstructionTemp.Select(selectString);
                                    if (drMedicationIns.Length != 0)
                                    {
                                    }
                                    DataRow drNew = _dtMedicationInstructionTemp.NewRow();
                                    drNew["MedicationId"] = medicationID;
                                    drNew["MedicationInstructionId"] = drMedInstruction["ClientMedicationInstructionId"];
                                    drNew["Medication"] = medicationName;
                                    drNew["Instruction"] = ApplicationCommonFunctions.cutText(instructions, 240);
                                    drNew["DAWorQuantity"] = drMedication["DAW"].ToString();
                                    if (drMedInstruction.Table.Columns.Contains("Refills"))
                                        drNew["Refills"] = drMedInstruction["Refills"];
                                    else
                                        drNew["Refills"] = "";
                                    if (drMedInstruction.Table.Columns.Contains("CalculatedQty"))
                                        drNew["CalculatedQty"] = drMedInstruction["CalculatedQty"];
                                    else
                                        drNew["CalculatedQty"] = "";
                                    drNew["WarningorRefillorIndicator"] = "";
                                    drNew["MedicationName"] = drMedInstruction["MedicationName"];
                                    drNew["InformationComplete"] = drMedInstruction["InformationComplete"];
                                    drNew["StartDate"] = drMedInstruction["StartDate"];
                                    drNew["EndDate"] = drMedInstruction["EndDate"];
                                    drNew["TitrationStepNumber"] = drMedInstruction["TitrationStepNumber"];
                                    drNew["Days"] = drMedInstruction["Days"];
                                    drNew["Pharmacy"] = drMedInstruction["Pharmacy"];
                                    //Acode added by Loveena in ref to Task#2802
                                    drNew["PharmacyText"] = drMedInstruction["PharmacyText"];
                                    drNew["AutoCalcallow"] = drMedInstruction["AutoCalcallow"];
                                    drNew["Sample"] = drMedInstruction["Sample"];
                                    drNew["Stock"] = drMedInstruction["Stock"];
                                    drNew["DayNumber"] = drMedInstruction["DayNumber"];
                                    // drNew["DayNumber"] = CalculateDayNumber(Convert.ToDateTime(_firstStepDate), Convert.ToDateTime(drMedInstruction["StartDate"]));
                                    drNew["StrengthId"] = drMedInstruction["StrengthId"];
                                    drNew["TitrateSummary"] = drMedInstruction["TitrateSummary"];
                                    drNew["Unit"] = drMedInstruction["Unit"];
                                    _dtMedicationInstructionTemp.Rows.Add(drNew);
                                }
                            }
                        }
                    }
                }

                int _maxStepCount = 0;
                if (_dtMedicationInstructionTemp.Rows.Count > 0)
                {
                    if (_dtMedicationInstructionTemp.Compute("Max(TitrationStepNumber)", "").ToString() != "")
                        _maxStepCount =
                            Convert.ToInt32(_dtMedicationInstructionTemp.Compute("Max(TitrationStepNumber)", ""));
                }

                for (int icount = 1; icount <= _maxStepCount; icount++)
                {
                    //DataRow dr = _dtMedicationTemp.Rows[icount];
                    //int medicationId = Convert.ToInt32(dr["MedicationId"]);
                    DataRow[] drMedInfo = _dtMedicationInstructionTemp.Select("TitrationStepNumber=" + icount + "");
                    //if (drMedInfo.Length < 1)
                    //{
                    //    _dtMedicationTemp.Rows.Remove(dr);
                    //}
                    if (drMedInfo.Length > 1)
                    {
                        for (int rowIndex = 1; rowIndex < drMedInfo.Length; rowIndex++)
                        {
                            drMedInfo[rowIndex]["Medication"] = "";
                        }
                    }
                    //if (!(dr["Discontinued"].ToString() == "Y"))
                    //{
                    //    strDiscontinuedMedications += medicationId.ToString() + ",";
                    //}
                }

                dvClientMedicationInstructions.Dispose();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        /// <summary>
        /// </summary>
        private void GenerateTitrationRows()
        {
            // bool _boolRowWithInteractionFound = false;
            bool _dateWarningFlag = false;
            DateTime _currentStepStartDate = Convert.ToDateTime(null);
            DateTime _previousStepEndDate = Convert.ToDateTime(null);
            //Code added by Loveena in ref to Task#2582
            int _previousStepDays = 0;
            DateTime _previousStepStartDate = Convert.ToDateTime(null);
            string _warningMessage = string.Empty;
            string rowClass = "GridViewRowStyle";
            try
            {
                CommonFunctions.Event_Trap(this);

                Color[] _color =
                    {
                        Color.Pink,
                        Color.Red,
                        Color.Yellow,
                        Color.Green,
                        Color.Plum,
                        Color.Aqua,
                        Color.PaleGoldenrod,
                        Color.Peru,
                        Color.Tan,
                        Color.Khaki,
                        Color.DarkGoldenrod,
                        Color.Maroon,
                        Color.OliveDrab,
                        Color.Crimson,
                        Color.Beige,
                        Color.DimGray,
                        Color.ForestGreen,
                        Color.Indigo,
                        Color.LightCyan
                    };

                PanelMedicationList.Controls.Clear();
                var tblMedication = new Table();
                tblMedication.ID = Guid.NewGuid().ToString();
                tblMedication.Width = new Unit(100, UnitType.Percentage);

                var thTitle = new TableHeaderRow();

                var thcRadioButton = new TableHeaderCell();
                var thcBlankDeleteButton = new TableHeaderCell();
                var thcStepNumber = new TableHeaderCell();
                thcStepNumber.Text = "Step #";
                //thcStepNumber.Attributes.Add("onClick", "onHeaderClick(this)");
                //thcStepNumber.Attributes.Add("ColumnName", "TitrationStepNumber");
                //thcStepNumber.Attributes.Add("SortOrder", setAttributes());
                //if (_dtMedicationTemp.Rows.Count > 0)
                //    thcStepNumber.CssClass = "handStyle";
                var thcDayNumber = new TableHeaderCell();
                thcDayNumber.Text = "Day #";
                //thcDayNumber.Attributes.Add("onClick", "onHeaderClick(this)");
                //thcDayNumber.Attributes.Add("ColumnName", "DayNumber");
                //thcDayNumber.Attributes.Add("SortOrder", setAttributes());
                //if (_dtMedicationTemp.Rows.Count > 0)
                //    thcDayNumber.CssClass = "handStyle";
                var thcInstructions = new TableHeaderCell();
                thcInstructions.Text = _instructionsTitle;
                //thcInstructions.Attributes.Add("onClick", "onHeaderClick(this)");
                //thcInstructions.Attributes.Add("ColumnName", "Instruction");
                //thcInstructions.Attributes.Add("SortOrder", setAttributes());
                //if (_dtMedicationTemp.Rows.Count > 0)
                //    thcInstructions.CssClass = "handStyle";
                var thcDateWarning = new TableHeaderCell();
                var thcMedicationStartDate = new TableHeaderCell();
                thcMedicationStartDate.Text = "Rx Start";
                //thcMedicationStartDate.Attributes.Add("onClick", "onHeaderClick(this)");
                //thcMedicationStartDate.Attributes.Add("ColumnName", "StartDate");
                //thcMedicationStartDate.Attributes.Add("SortOrder", setAttributes());
                //if (_dtMedicationTemp.Rows.Count > 0)
                //    thcMedicationStartDate.CssClass = "handStyle";
                var thcDays = new TableHeaderCell();
                thcDays.Text = "Days";
                //thcDays.Attributes.Add("onClick", "onHeaderClick(this)");
                //thcDays.Attributes.Add("ColumnName", "Days");
                //thcDays.Attributes.Add("SortOrder", setAttributes());
                //if (_dtMedicationTemp.Rows.Count > 0)
                //    thcDays.CssClass = "handStyle";
                var thcMedicationEndDate = new TableHeaderCell();
                thcMedicationEndDate.Text = "Rx End";
                //thcMedicationEndDate.Attributes.Add("onClick", "onHeaderClick(this)");
                //thcMedicationEndDate.Attributes.Add("ColumnName", "EndDate");
                //thcMedicationEndDate.Attributes.Add("SortOrder", setAttributes());
                //if (_dtMedicationTemp.Rows.Count > 0)
                //    thcMedicationEndDate.CssClass = "handStyle";
                var thcPharmacy = new TableHeaderCell();
                //Code added by Loveena in ref to Task#2802
                //thcPharmacy.Text = "Pharmacy";
                thcPharmacy.Text = "Dispense Qty";
                var thcSample = new TableHeaderCell();
                thcSample.Text = "Sample";
                var thcStock = new TableHeaderCell();
                thcStock.Text = "Stock";
                var thcCumulativeInfo = new TableHeaderCell();
                thcCumulativeInfo.Text = "";

                thTitle.Cells.Add(thcRadioButton);
                thTitle.Cells.Add(thcBlankDeleteButton);
                thTitle.Cells.Add(thcStepNumber);
                thTitle.Cells.Add(thcDayNumber);
                thTitle.Cells.Add(thcInstructions);
                thTitle.Cells.Add(thcDateWarning);
                thTitle.Cells.Add(thcMedicationStartDate);
                thTitle.Cells.Add(thcDays);
                thTitle.Cells.Add(thcMedicationEndDate);
                thTitle.Cells.Add(thcPharmacy);
                thTitle.Cells.Add(thcSample);
                thTitle.Cells.Add(thcStock);
                thTitle.Cells.Add(thcCumulativeInfo);

                thTitle.CssClass = "GridViewHeaderText";
                tblMedication.Rows.Add(thTitle);

                string myscript = "<script id='MedicationListScript' type='text/javascript'>";
                myscript += "function $deleteRecord(sender,e){";
                if (!string.IsNullOrEmpty(_deleteRowMessage))
                {
                   // myscript += " if(confirm('" + _deleteRowMessage + " ')==true){ " + _onDeleteEventHandler +
                               // "(sender,e);  }}";
                    myscript += _calledFromControllerName + "" + _onDeleteEventHandler + "(sender,e);  }";
                }
                else
                {
                    myscript += "}";
                }
                myscript += "function RegisterMedicationListControlEvents(){try{ ";

                // int ColorCounter = 0;
                if (_dtMedicationTemp.Rows.Count > 0)
                {
                    int _maxStepCount = 0;
                    if (_dtMedicationInstructionTemp.Rows.Count > 0)
                    {
                        if (_dtMedicationInstructionTemp.Compute("Max(TitrationStepNumber)", "").ToString() != "")
                            _maxStepCount =
                                Convert.ToInt32(_dtMedicationInstructionTemp.Compute("Max(TitrationStepNumber)", ""));
                    }

                    //if (_maxStepCount > 1)
                    //{
                    //    DataRow[] dr = _dtMedicationInstructionTemp.Select("TitrationStepNumber=" + (_maxStepCount - 1));
                    //    _previousStepEndDate = Convert.ToDateTime(dr[0]["EndDate"]);
                    //    DataRow[] dr1 = _dtMedicationInstructionTemp.Select("TitrationStepNumber=" + _maxStepCount);
                    //    _currentStepStartDate = Convert.ToDateTime(dr1[0]["StartDate"]);
                    //}

                    for (int i = 1; i <= _maxStepCount; i++)
                    {
                        if (i > 1)
                        {
                            DataRow[] dr = _dtMedicationInstructionTemp.Select("TitrationStepNumber=" + (i - 1));
                            //Modified by Loveena in ref to Task#2582 dated 14 Oct 2009
                            //_previousStepEndDate = Convert.ToDateTime(dr[0]["EndDate"]);
                            _previousStepStartDate = Convert.ToDateTime(dr[0]["StartDate"]);
                            _previousStepDays = Convert.ToInt32(dr[0]["Days"]);
                            DataRow[] dr1 = _dtMedicationInstructionTemp.Select("TitrationStepNumber=" + i);
                            _currentStepStartDate = Convert.ToDateTime(dr1[0]["StartDate"]);
                            if (_currentStepStartDate > _previousStepStartDate.AddDays(_previousStepDays))
                            {
                                _dateWarningFlag = true;
                                _warningMessage = "This step does not start immediately after the previous step.";
                            }
                            //else
                            //    {
                            //    _dateWarningFlag = false;
                            //    _warningMessage = "";
                            //    }
                            else if (_currentStepStartDate < _previousStepStartDate.AddDays(_previousStepDays))
                            {
                                _dateWarningFlag = true;
                                _warningMessage = "This step overlaps the previous step.";
                            }
                            else
                            {
                                _dateWarningFlag = false;
                                _warningMessage = "";
                            }
                            //if (_previousStepEndDate != _currentStepStartDate)
                            //    _dateWarningFlag = true;
                            //else
                            //    _dateWarningFlag = false;
                        }
                        //Code ends over here.
                        DataRow[] _dataRowMedInstructions;
                        _dataRowMedInstructions = _dtMedicationInstructionTemp.Select("TitrationStepNumber=" + i);
                        CumulativeDataDisplay(_dataRowMedInstructions);
                        foreach (DataRow _drTemp in _dataRowMedInstructions)
                        {
                            tblMedication.Rows.Add(GenerateSubTitrationRows(_drTemp, tblMedication.ClientID,
                                                                            ref myscript, _dateWarningFlag,
                                                                            _warningMessage, rowClass));
                            rowClass = rowClass == "GridViewRowStyle" ? "GridViewAlternatingRowStyle" : "GridViewRowStyle";
                        }

                   // }// my foreach end
                        var trLine = new TableRow();
                        var tdHorizontalLine = new TableCell();
                        tdHorizontalLine.ColumnSpan = 12;
                        tdHorizontalLine.CssClass = "blackLine";
                        trLine.Cells.Add(tdHorizontalLine);
                        tblMedication.Rows.Add(trLine);
                    }
                }
                else
                    Session["DataSetAllergy"] = null;
                tblMedication.CellPadding = 0;
                tblMedication.CellSpacing = 0;

                PanelMedicationList.Controls.Add(tblMedication);
                //Added by Chandan for Task #2382 1.7.1 - Titration Steps List: Scroll to Bottom When Step Added
                myscript += PanelMedicationList.ClientID + ".scrollTop=" + PanelMedicationList.ClientID +
                            ".scrollHeight;";
                //End here
                myscript +=
                    "}catch(e){  Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);}}</script>";
                Page.RegisterClientScriptBlock(ClientID, myscript);
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

        private TableRow GenerateSubTitrationRows(DataRow drTemp, string tableId, ref string myscript,
                                                  bool dateWarningFlag, string warningMessage, string rowClass)
        //, string medicationScriptId)
        {
            try
            {
                CommonFunctions.Event_Trap(this);
                string newId = Guid.NewGuid().ToString();
                int _medicationId = Convert.ToInt32(drTemp["MedicationId"]);
                int _stepNumber = Convert.ToInt32(drTemp["TitrationStepNumber"]);
                string tblId = ClientID + ClientIDSeparator + tableId;
                var trTemp = new TableRow();
                trTemp.ID = "Tr_" + newId;                
                var _labelMedication = new Label();
                //if (medicationScriptId != "")
                //    lblMedication.ID = "Lbl_" + _medicationId.ToString() + "_" + medicationScriptId.ToString();
                //else
                //    lblMedication.ID = "Lbl_" + _medicationId.ToString();
                _labelMedication.Text = drTemp["Medication"] == DBNull.Value ? "" : drTemp["Medication"].ToString();
                //tdMedication.Controls.Add(lblMedication);

                var tdRadioButton = new TableCell();
                string rowId = ClientID + ClientIDSeparator + trTemp.ClientID;
                var rbTemp = new HtmlInputRadioButton();
                rbTemp.Attributes.Add("MedicationId", drTemp["MedicationId"].ToString());
                rbTemp.Attributes.Add("MedicationInstructionId", drTemp["MedicationInstructionId"].ToString());
                rbTemp.ID = "Rb_" + _stepNumber.ToString();
                tdRadioButton.Controls.Add(rbTemp);

                if (_labelMedication.Text != "")
                {
                    myscript += "var Radiocontext" + _stepNumber + "={MedicationId:" + _medicationId +
                                ",MedicationInstructionsId:" + drTemp["MedicationInstructionId"] + ",TableId:'" + tblId +
                                "',RowId:'" + rowId + "',TitrationStepNumber:'" + _stepNumber + "'};";
                    myscript += "var RadioclickCallback" + _stepNumber + " =";
                    myscript += " Function.createCallback(" + _onRadioClickEventHandler + ", Radiocontext" + _stepNumber +
                                ");";
                    myscript += "$addHandler($get('" + ClientID + ClientIDSeparator + rbTemp.ClientID +
                                "'), 'click', RadioclickCallback" + _stepNumber + ");";
                }

                var tdDelete = new TableCell();
                var imgTemp = new HtmlImage();
                //if (MedicationScriptId == "")
                //    imgTemp.ID = "Img_" + MedicationId.ToString();
                //else
                //    imgTemp.ID = "Img_" + MedicationId.ToString() + "_" + MedicationScriptId.ToString();
                imgTemp.ID = "Img_" + _stepNumber.ToString();
                imgTemp.Attributes.Add("MedicationId", drTemp["MedicationId"].ToString());
                imgTemp.Attributes.Add("MedicationInstructionId", drTemp["MedicationInstructionId"].ToString());
                imgTemp.Attributes.Add("TitrationStepNumber", drTemp["TitrationStepNumber"].ToString());
                imgTemp.Src = "~/App_Themes/Includes/Images/deleteIcon.gif";
                imgTemp.Attributes.Add("class", "handStyle");
                imgTemp.Disabled = !((StreamlinePrinciple)Context.User).HasPermission(Permissions.AddMedication);
                tdDelete.Controls.Add(imgTemp);

                if (_labelMedication.Text != "")
                {
                    myscript += "var Imagecontext" + _stepNumber + "={MedicationId:" + _medicationId +
                                ",MedicationInstructionsId:" + drTemp["MedicationInstructionId"] + ",TableId:'" + tblId +
                                "',RowId:'" + rowId + "',AddOrder:'" +
                                ((StreamlinePrinciple)Context.User).HasPermission(Permissions.NewOrder) +
                                "',TitrationStepNumber:'" + _stepNumber + "'};";
                    myscript += "var ImageclickCallback" + _stepNumber + " =";
                    myscript += " Function.createCallback($deleteRecord, Imagecontext" + _stepNumber + ");";
                    myscript += "$addHandler($get('" + ClientID + ClientIDSeparator + imgTemp.ClientID +
                                "'), 'click', ImageclickCallback" + _stepNumber + ");";
                }

                var tdStepNumber = new TableCell();
                tdStepNumber.Text = drTemp["TitrationStepNumber"] == DBNull.Value
                                        ? ""
                                        : drTemp["TitrationStepNumber"].ToString();
                var tdDayNumber = new TableCell();
                tdDayNumber.Text = drTemp["DayNumber"] == DBNull.Value ? "" : drTemp["DayNumber"].ToString();
                var tdInstructions = new TableCell();
                tdInstructions.Text = drTemp["Instruction"] == DBNull.Value ? "" : drTemp["Instruction"].ToString();

                var tdDateWarningIcon = new TableCell();
                var imgDateWarning = new HtmlImage();
                //if (MedicationScriptId == "")
                //    imgDateWarning.ID = "ImgOrder_" + _medicationId.ToString();
                //else
                //    imgDateWarning.ID = "ImgOrder_" + _medicationId.ToString() + "_" + medicationScriptId.ToString();
                imgDateWarning.ID = "ImgWarning_" + _stepNumber.ToString();
                imgDateWarning.Src = "~/App_Themes/Includes/Images/warning.gif";
                imgDateWarning.Attributes.Add("class", "handStyle");
                tdDateWarningIcon.Controls.Add(imgDateWarning);
                //tdDateWarningIcon.ToolTip = "Start date does not equal to the end date of the previous step";
                tdDateWarningIcon.ToolTip = warningMessage;

                var tdRxStart = new TableCell();
                if (drTemp["StartDate"] != null && drTemp["StartDate"] != DBNull.Value &&
                    drTemp["StartDate"].ToString() != "")
                {
                    tdRxStart.Text = Convert.ToDateTime(drTemp["StartDate"]).ToString("MM/dd/yyyy");
                }

                var tdDays = new TableCell();
                tdDays.Text = drTemp["Days"] == DBNull.Value ? "" : drTemp["Days"].ToString();

                var tdRxEnd = new TableCell();
                if (drTemp["EndDate"] != null && drTemp["EndDate"] != DBNull.Value && drTemp["EndDate"].ToString() != "")
                {
                    tdRxEnd.Text = Convert.ToDateTime(drTemp["EndDate"]).ToString("MM/dd/yyyy");
                }

                var tdPharmacy = new TableCell();
                tdPharmacy.Attributes.Add("Style", "text-align:right");
                tdPharmacy.Text = drTemp["Pharmacy"] == DBNull.Value
                                      ? ""
                                      : Convert.ToDouble(drTemp["Pharmacy"].ToString()).ToString("0.00");
                //Code added in ref to Task#2802
                if (drTemp["PharmacyText"].ToString().Length > 15)
                {
                    tdPharmacy.Text = drTemp["PharmacyText"].ToString().Substring(0, 12) + "...";
                    tdPharmacy.ToolTip = drTemp["PharmacyText"].ToString();
                }
                else if ((drTemp["PharmacyText"].ToString().Length > 0) &&
                         (drTemp["PharmacyText"].ToString().Length < 15))
                {
                    tdPharmacy.Text = drTemp["PharmacyText"].ToString();
                }
                var tdSample = new TableCell();
                tdSample.Attributes.Add("Style", "text-align:right");
                tdSample.Text = drTemp["Sample"] == DBNull.Value
                                    ? ""
                                    : Convert.ToDouble(drTemp["Sample"].ToString()).ToString("0.00");
                var tdStock = new TableCell();
                tdStock.Attributes.Add("Style", "text-align:right");
                tdStock.Text = drTemp["Stock"] == DBNull.Value
                                   ? ""
                                   : Convert.ToDouble(drTemp["Stock"].ToString()).ToString("0.00");

                var tdCumulativeInfoIcon = new TableCell();
                var imgCumulativeInfo = new HtmlImage();
                //if (MedicationScriptId == "")
                //    imgCumulativeInfo.ID = "ImgOrder_" + MedicationId.ToString();
                //else
                //    imgCumulativeInfo.ID = "ImgOrder_" + MedicationId.ToString() + "_" + MedicationScriptId.ToString();
                imgCumulativeInfo.ID = "ImgInfo_" + _stepNumber.ToString();
                imgCumulativeInfo.Src = "~/App_Themes/Includes/Images/information.gif";
                imgCumulativeInfo.Attributes.Add("class", "handStyle");
                tdCumulativeInfoIcon.Controls.Add(imgCumulativeInfo);
                //Cumulative Information 
                string strCumulativeDisplay = "";
                string strCumulativeDisplay1 = "";
                foreach (DictionaryEntry item in htInformation)
                {
                    strCumulativeDisplay = item.Key.ToString();
                    strCumulativeDisplay1 = strCumulativeDisplay1 +
                                            strCumulativeDisplay.Substring(strCumulativeDisplay.IndexOf("##") + 2);
                    strCumulativeDisplay1 = strCumulativeDisplay1 + " x " + item.Value + "\n";
                }
                strCumulativeDisplay1 = "Step " + _stepNumber + " Cumulative: " + strCumulativeDisplay1;
                tdCumulativeInfoIcon.ToolTip = strCumulativeDisplay1;
                if (_labelMedication.Text == "")
                {
                    tdRadioButton.Controls.Clear();
                    tdRadioButton.Text = "";
                }
                trTemp.Cells.Add(tdRadioButton);

                if (_labelMedication.Text == "")
                {
                    tdDelete.Controls.Clear();
                    tdDelete.Text = "";
                }
                trTemp.Cells.Add(tdDelete);

                if (_labelMedication.Text == "")
                {
                    tdStepNumber.Controls.Clear();
                    tdStepNumber.Text = "";
                }
                trTemp.Cells.Add(tdStepNumber);

                if (_labelMedication.Text == "")
                {
                    tdDayNumber.Controls.Clear();
                    tdDayNumber.Text = "";
                }
                trTemp.Cells.Add(tdDayNumber);

                trTemp.Cells.Add(tdInstructions);

                if (dateWarningFlag)
                {
                    if (_labelMedication.Text == "")
                    {
                        tdDateWarningIcon.Controls.Clear();
                        tdDateWarningIcon.Text = "";
                    }
                    trTemp.Cells.Add(tdDateWarningIcon);
                }
                else
                {
                    tdDateWarningIcon.Controls.Clear();
                    tdDateWarningIcon.Text = "";
                    trTemp.Cells.Add(tdDateWarningIcon);
                }

                if (_labelMedication.Text == "")
                {
                    tdRxStart.Controls.Clear();
                    tdRxStart.Text = "";
                }
                trTemp.Cells.Add(tdRxStart);

                if (_labelMedication.Text == "")
                {
                    tdDays.Controls.Clear();
                    tdDays.Text = "";
                }
                trTemp.Cells.Add(tdDays);

                if (_labelMedication.Text == "")
                {
                    tdRxEnd.Controls.Clear();
                    tdRxEnd.Text = "";
                }
                trTemp.Cells.Add(tdRxEnd);

                trTemp.Cells.Add(tdPharmacy);
                trTemp.Cells.Add(tdSample);
                trTemp.Cells.Add(tdStock);

                if (_labelMedication.Text == "")
                {
                    tdCumulativeInfoIcon.Controls.Clear();
                    tdCumulativeInfoIcon.Text = "";
                }
                trTemp.Cells.Add(tdCumulativeInfoIcon);

                trTemp.CssClass = rowClass;
                return trTemp;
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
        /// </summary>
        /// <param name="firstStepDate"></param>
        /// <param name="currentStepDate"></param>
        /// <returns></returns>
        private int CalculateDayNumber(DateTime firstStepDate, DateTime currentStepDate)
        {
            try
            {
                TimeSpan _timeSpan = currentStepDate.Subtract(firstStepDate);
                int _dayNumber = _timeSpan.Days + 1;
                return _dayNumber;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        ///     Created by cahndan on 14th Dec 2009
        ///     Caluclate cumulative strength values
        /// </summary>
        /// <param name="_dataRowMedInstructions"></param>
        /// <returns></returns>
        private Hashtable CumulativeDataDisplay(DataRow[] _dataRowMedInstructions)
        {
            try
            {
                foreach (DataRow drInteraction in _dataRowMedInstructions)
                {
                    try
                    {
                        htInformation.Add(
                            (drInteraction["StrengthId"] + drInteraction["Unit"].ToString() + "##" +
                             drInteraction["TitrateSummary"]), drInteraction["Pharmacy"].ToString());
                    }
                    catch
                    {
                        htInformation[
                            drInteraction["StrengthId"] + drInteraction["Unit"].ToString() + "##" +
                            drInteraction["TitrateSummary"]] =
                            double.Parse(
                                htInformation[
                                    (drInteraction["StrengthId"] + drInteraction["Unit"].ToString() + "##" +
                                     drInteraction["TitrateSummary"])].ToString()) +
                            double.Parse(drInteraction["Pharmacy"].ToString());
                    }
                }
                return htInformation;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public string enableDisabled(Permissions per)
        {
            if (((StreamlinePrinciple)Context.User).HasPermission(per))
                return "";
            else
                return "Disabled";
        }

        #region Generate Data Table for given Form

        private void CompileDataTable(DataTable dtClientMedication, DataTable dtClientMedicalInstructions)
        {
            try
            {
                // clear all the rows from the data table.

                _dtMedicationTemp.Clear();
                _dtMedicationInstructionTemp.Clear();


                DataTable dtClientMedicationCopy = dtClientMedication.Clone();


                //Getting max of instructions Id
                var dvClientMedicationInstructions = new DataView(dtClientMedicalInstructions);
               
                dvClientMedicationInstructions.Sort = "ClientMedicationInstructionId desc";
                int newClientMedicationInstructionId = 1;
                if (dvClientMedicationInstructions.Count > 0)
                    newClientMedicationInstructionId =
                        Convert.ToInt32(dvClientMedicationInstructions[0]["ClientMedicationInstructionId"]) + 1;
                //Checking for medications which do not have instructions 
                //and adding a dummy row into instructions
                foreach (DataRow dr in dtClientMedication.Rows)
                {
                    if (
                        dtClientMedicalInstructions.Select("ClientMedicationId=" +
                                                           Convert.ToInt32(dr["ClientMedicationId"]) +
                                                           "  and ISNULL(RecordDeleted,'N')='N'").Length < 1)
                    {
                        DataRow drCMI = dtClientMedicalInstructions.NewRow();
                        drCMI["ClientMedicationInstructionId"] = newClientMedicationInstructionId;
                        drCMI["ClientMedicationId"] = dr["ClientMedicationId"];
                        drCMI["MedicationName"] = dr["MedicationName"];
                        //For removing duplicate instructions from a Medication in a View History page this needs to be done
                        drCMI["MedicationOrderStatus"] = dr["OrderStatus"];
                        drCMI["MedicationScriptId"] = dr["MedicationScriptId"];

                        drCMI["ModifiedBy"] = dr["ModifiedBy"];
                        drCMI["ModifiedDate"] = dr["ModifiedDate"];
                        drCMI["CreatedBy"] = dr["CreatedBy"];
                        drCMI["CreatedDate"] = dr["CreatedDate"];
                        drCMI["Instruction"] = string.Empty;
                        drCMI["RowIdentifier"] = Guid.NewGuid();
                        drCMI["Unit"] = 0;
                        //drCMI["DAWorQuantity"] = DBNull.Value;
                        dtClientMedicalInstructions.Rows.Add(drCMI);
                        newClientMedicationInstructionId++;
                    }
                }


                //if (_sortString.Contains("StartDate") || _sortString.Contains("EndDate") || _sortString.Contains("Instruction"))
                //Commented as per Task 2377 SC-Support

                #region Modified by Loveena in ref to Task#2658

                ////Changes By sonia
                ////Task #51 MM1.5 View History:Records disappear on click "Instruction" in "Medication List".
                ////Datarows needs to be distinguised by scriptid also along with MedicationId in case of View History
                //if (_sortString.Contains("Instruction"))
                //{
                //    dvClientMedicationInstructions.Sort = _sortString;
                //    dvClientMedicationInstructions.RowFilter = "(ClientMedicationId >= 0)";
                //    while (dvClientMedicationInstructions.Count > 0)
                //    {
                //        string str = "";
                //        if ((dvClientMedicationInstructions.Table.Columns.Contains("MedicationScriptId") == true) && (dvClientMedicationInstructions[0]["MedicationScriptId"] != ""))
                //        {
                //            str = " and (ClientMedicationId <> " + dvClientMedicationInstructions[0]["ClientMedicationId"].ToString() + " or MedicationScriptId <> " + dvClientMedicationInstructions[0]["MedicationScriptId"].ToString() + ")";
                //        }
                //        else
                //            str = " and ClientMedicationId <> " + dvClientMedicationInstructions[0]["ClientMedicationId"].ToString();
                //        DataRow[] drTemp = dtClientMedication.Select("ClientMedicationId=" + dvClientMedicationInstructions[0]["ClientMedicationId"] + " and MedicationScriptId=" + dvClientMedicationInstructions[0]["MedicationScriptId"]);

                //        if (drTemp.Length > 0)
                //            dtClientMedicationCopy.ImportRow(drTemp[0]);
                //        dvClientMedicationInstructions.RowFilter = dvClientMedicationInstructions.RowFilter + str;
                //    }
                //}
                ////changes end over here

                ////Added new _sortString=Ordered asc,OrderDate desc Loveena in ref to task#2387 on 10-Feb-2009 to display Non-Ordered Medications on top
                //// with null Ordered Date.
                ////Added new _sortString=DiscontinuedReason or OffLabel Loveena in ref to task#2433 on 11-April-2009 to display DisContinuedReason
                //// and OffLabel Column in ViewHistory.
                //else if (_sortString.Contains("PrescriberName") || _sortString.Contains("MedicationName") || _sortString.Contains("Ordered") || _sortString.Contains("StartDate") || _sortString.Contains("EndDate") || _sortString.Contains("OrderStatus") || _sortString.Contains("OrderStatusDate") || _sortString.Contains("Ordered asc,OrderDate desc") || _sortString.Contains("OffLabel") || _sortString.Contains("DiscontinuedReason"))
                //{
                //    foreach (DataRow drM in dtClientMedication.Select(null, _sortString))
                //        dtClientMedicationCopy.ImportRow(drM);
                //}

                #endregion

                if (_sortString.Contains("Instruction") || _sortString == "StartDate Asc" ||
                    _sortString == "StartDate Desc" || _sortString == "EndDate Asc" || _sortString == "EndDate Desc")
                {
                    dvClientMedicationInstructions.Sort = _sortString;
                    dvClientMedicationInstructions.RowFilter = "ClientMedicationId >= 0 ";
                    string filter = "ClientMedicationId not in(0)";
                    while (dvClientMedicationInstructions.Count > 0)
                    {
                        //string str = " and ClientMedicationId <> " + dvClientMedicationInstructions[0]["ClientMedicationId"].ToString();
                        string str = dvClientMedicationInstructions[0]["ClientMedicationId"].ToString();
                        //Commentd by ANuj for task ref:3062 on 25 May,2010
                        //DataRow[] drTemp = dtClientMedication.Select("ClientMedicationId=" + dvClientMedicationInstructions[0]["ClientMedicationId"]);

                        DataRow[] drTemp =
                            dtClientMedication.Select(
                                "ClientMedicationId=" + dvClientMedicationInstructions[0]["ClientMedicationId"],
                                "MedicationStartDate desc");
                        if (drTemp.Length > 0)
                        {
                            //Modified by Anuj for task ref2928 Medication Management
                            for (int MedicationId = 0; MedicationId < drTemp.Length; MedicationId++)
                            {
                                dtClientMedicationCopy.ImportRow(drTemp[MedicationId]);
                            }
                            //Ended over here
                            //dtClientMedicationCopy.ImportRow(drTemp[0]);
                        }
                        //dvClientMedicationInstructions.RowFilter = dvClientMedicationInstructions.RowFilter + str;
                        filter = filter.Substring(0, filter.Trim().Length - 1) + "," + str + ")";
                        dvClientMedicationInstructions.RowFilter = filter.Trim();
                    }
                }
                //Modified by Loveena in ref to Task#2658
                else if (_sortString.Contains("PrescriberName") || _sortString.Contains("MedicationName") ||
                         _sortString.Contains("Ordered") || _sortString.Contains("MedicationStartDate") ||
                         _sortString.Contains("MedicationEndDate") || _sortString.Contains("OrderStatus") ||
                         _sortString.Contains("OrderStatusDate") || _sortString.Contains("Ordered asc,OrderDate desc") ||
                         _sortString.Contains("OffLabel") || _sortString.Contains("DiscontinuedReason") || _sortString.Contains("DiscontinuedBy") || _sortString.Contains("AddedBy"))
                //                else if (_sortString.Contains("PrescriberName") || _sortString.Contains("MedicationName") || _sortString.Contains("Ordered") || _sortString.Contains("StartDate") || _sortString.Contains("EndDate"))
                {
                    ////Modified by Loveena in ref to Task#2658
                    //foreach (DataRow drM in dtClientMedication.Select(null, _sortString))
                    //    dtClientMedicationCopy.ImportRow(drM);
                    //dvClientMedicationInstructions.Sort = _sortString;
                    DataTable dtClientMedicationSortCopy = dtClientMedication.Clone();
                    dvClientMedicationInstructions.RowFilter = "ClientMedicationId >= 0 ";
                    string filter = "ClientMedicationId not in(0)";
                    while (dvClientMedicationInstructions.Count > 0)
                    {
                        //string str = " and ClientMedicationId <> " + dvClientMedicationInstructions[0]["ClientMedicationId"].ToString();
                        string str = dvClientMedicationInstructions[0]["ClientMedicationId"].ToString();
                        DataRow[] drTemp =
                            dtClientMedication.Select("ClientMedicationId=" +
                                                      dvClientMedicationInstructions[0]["ClientMedicationId"] + "");
                        if (drTemp.Length > 0)
                        {
                            //Modified by Anuj for task ref2928 Medication Management
                            for (int MedicationId = 0; MedicationId < drTemp.Length; MedicationId++)
                            {
                                dtClientMedicationSortCopy.ImportRow(drTemp[MedicationId]);
                            }
                            //Ended over here
                            // dtClientMedicationSortCopy.ImportRow(drTemp[MedicationId]);
                        }

                        //dvClientMedicationInstructions.RowFilter = dvClientMedicationInstructions.RowFilter + str;
                        filter = filter.Substring(0, filter.Trim().Length - 1) + "," + str + ")";
                        dvClientMedicationInstructions.RowFilter = filter.Trim();
                    }
                    //Need to change here for history tak ref:2828
                    foreach (DataRow drM in dtClientMedicationSortCopy.Select(null, _sortString))
                        dtClientMedicationCopy.ImportRow(drM);
                }
                else if (String.IsNullOrEmpty(_sortString))
                {
                    //Following commented for 2377 SC-Support
                    //dvClientMedicationInstructions.Sort = "StartDate desc,MedicationName";
                    dvClientMedicationInstructions.Sort = "MedicationName";
                    dvClientMedicationInstructions.RowFilter = "ClientMedicationId >= 0 ";
                    string filter = "ClientMedicationId not in(0)";
                    while (dvClientMedicationInstructions.Count > 0)
                    {
                        //string str = " and ClientMedicationId <> " + dvClientMedicationInstructions[0]["ClientMedicationId"].ToString();
                        string str = dvClientMedicationInstructions[0]["ClientMedicationId"].ToString();
                        //Commentd by ANuj for task ref:3062 on 25 May,2010
                        // DataRow[] drTemp = dtClientMedication.Select("ClientMedicationId=" + dvClientMedicationInstructions[0]["ClientMedicationId"] + " and isnull(ordered,'N')='Y'", "MedicationStartDate desc");
                        DataRow[] drTemp =
                            dtClientMedication.Select(
                                "ClientMedicationId=" + dvClientMedicationInstructions[0]["ClientMedicationId"],
                                "MedicationStartDate desc");

                        if (drTemp.Length > 0)
                        {
                            //Modified by Anuj for task ref2928 Medication Management
                            for (int MedicationId = 0; MedicationId < drTemp.Length; MedicationId++)
                            {
                                dtClientMedicationCopy.ImportRow(drTemp[MedicationId]);
                            }
                            //Ended over here
                            // dtClientMedicationCopy.ImportRow(drTemp[0]);
                        }
                        //dvClientMedicationInstructions.RowFilter = dvClientMedicationInstructions.RowFilter + str;
                        filter = filter.Substring(0, filter.Trim().Length - 1) + "," + str + ")";
                        dvClientMedicationInstructions.RowFilter = filter.Trim();
                    }
                    //Commented By Anuj as Same Code has used as its already defined above.
                    //  dvClientMedicationInstructions.Sort = "StartDate desc,MedicationName";
                    //dvClientMedicationInstructions.Sort = "MedicationName";
                    //dvClientMedicationInstructions.RowFilter = "ClientMedicationId >= 0 ";
                    //while (dvClientMedicationInstructions.Count > 0)
                    //{

                    //    string str = " and ClientMedicationId <> " + dvClientMedicationInstructions[0]["ClientMedicationId"].ToString();
                    //    DataRow[] drTemp = dtClientMedication.Select("ClientMedicationId=" + dvClientMedicationInstructions[0]["ClientMedicationId"] + " and  isnull(ordered,'N')='N'", "MedicationStartDate desc");

                    //    if (drTemp.Length > 0)
                    //        dtClientMedicationCopy.ImportRow(drTemp[0]);
                    //    dvClientMedicationInstructions.RowFilter = dvClientMedicationInstructions.RowFilter + str;
                    //}
                    //Ended over here
                }

                foreach (DataRow drMedication in dtClientMedicationCopy.Rows)
                {
                    if (drMedication["RecordDeleted"] == DBNull.Value || drMedication["RecordDeleted"].ToString() == "N")
                    {
                        // Get the Medication Information...
                        string medicationID = drMedication["ClientMedicationId"].ToString();
                        string MedicationOrderStatus = drMedication["OrderStatus"].ToString();
                        string MedicationScriptId = DBNull.Value.ToString();
                        if (dtClientMedicationCopy.Columns.Contains("MedicationScriptId"))
                            MedicationScriptId = drMedication["MedicationScriptId"].ToString();

                        string prescribedBy = drMedication["PrescriberName"].ToString();
                        //Added By Anuj for task ref #3 on 16Nov,2009 SDI Projects FY10 - Venture
                        int prescriberId = 0;
                        if (drMedication["PrescriberId"].ToString() != "" &&
                            drMedication["PrescriberId"].ToString() != null)
                        {
                            prescriberId = Convert.ToInt32(drMedication["PrescriberId"].ToString());
                        }
                        //Ended Over here
                        ////--Start Added By Pradeep as pertask#32
                        //string comments = drMedication["Comments"].ToString();
                        ////-- End Added By Pradeep as pertask#32
                        string specialInstruction = drMedication["SpecialInstructions"].ToString();
                        //Added by Loveena in ref to Task#2433 on 11-April-2009 to shoe OffLabel
                        // And Discontinued Reason columns in View History.
                        string offLabel = drMedication["OffLabel"].ToString();
                        //Code modified by Loveena in ref to Task#2488 to display Discontinue Reason Code instead of Discontinue Reason text
                        string discontinuedReason = drMedication["DiscontinuedReason"].ToString();
                        //string discontinuedReasonCode = string.Empty;
                        Int32 discontinuedReasonCode = 0;
                        if (drMedication["DiscontinuedReasonCode"] != DBNull.Value)
                        {
                            discontinuedReasonCode = Convert.ToInt32(drMedication["DiscontinuedReasonCode"]);
                        }
                        //code ends over here.  
                        //Start Ref to Task#32 -SDI Venture.
                        string comments = drMedication["Comments"].ToString();
                        //END Ref to Task#32 -SDI Venture.
                        string medicationName = drMedication["MedicationName"].ToString();
                        string Discontinued = "N";
                        // Code in ref to Task # 128
                        string ordered = "Y";
                        string _titrationType = drMedication["TitrationType"] == DBNull.Value
                                                    ? ""
                                                    : drMedication["TitrationType"].ToString();
                        //Changes as per Task 2377 SC-Support and 2381
                        string OrderStatus = drMedication["OrderStatus"].ToString();
                        string OrderStatusDate = "";
                        if (drMedication["OrderStatusDate"] != DBNull.Value &&
                            drMedication["OrderStatusDate"].ToString() != "" && drMedication["OrderStatusDate"] != null)
                        {
                            if (_calledFromControllerName == "ViewMedicationHistory")
                            {
                                OrderStatusDate =
                                    Convert.ToDateTime(drMedication["OrderStatusDate"]).ToString();
                            }
                            else
                            {
                                OrderStatusDate =
                                    Convert.ToDateTime(drMedication["OrderStatusDate"].ToString()).ToShortDateString();
                            }
                        }
                        else
                        {
                            OrderStatusDate = DBNull.Value.ToString();
                        }

                        //Following Code added by Loveena in Ref to Task#128 on 16-Jan-2009
                        string OrderDate = "";
                        if (drMedication["OrderDate"] != DBNull.Value && drMedication["OrderDate"].ToString() != "" &&
                            drMedication["OrderDate"] != null)
                        {
                            OrderDate = Convert.ToDateTime(drMedication["OrderDate"].ToString()).ToString("MM/dd/yyy");
                        }
                        else
                        {
                            OrderDate = DBNull.Value.ToString();
                        }
                        //Code Added by Loveena ends here.

                        //Following fields added as per Task 2377 SC-Support

                        //Following changes made by Sonia
                        //Task #38 MM 1.5.1 - Refill Screen: Start and Stop Date Initialization

                        // string MedicationStartDate = DateTime.Parse(drMedication["MedicationStartDate"].ToString()).ToShortDateString();
                        string MedicationStartDate = "";
                        if (_showMinScriptDrugsEndDate)
                        {
                            //Added condition in ref to Task#2952
                            if (drMedication["MedicationEndDateForDisplay"] != null &&
                                drMedication["MedicationEndDateForDisplay"].ToString() != "" &&
                                drMedication["MedicationEndDateForDisplay"] != DBNull.Value)
                            {
                                MedicationStartDate =
                                    DateTime.Parse(drMedication["MedicationEndDateForDisplay"].ToString())
                                            .ToShortDateString();
                            }
                        }
                        else
                        {
                            if (drMedication["MedicationStartDate"] != null &&
                                drMedication["MedicationStartDate"].ToString() != "" &&
                                drMedication["MedicationStartDate"] != DBNull.Value)
                            {
                                MedicationStartDate =
                                    DateTime.Parse(drMedication["MedicationStartDate"].ToString()).ToShortDateString();
                            }
                        }


                        string MedicationEndDate = "";
                        if (drMedication["MedicationEndDate"] != null &&
                            drMedication["MedicationEndDate"].ToString() != "" &&
                            drMedication["MedicationEndDate"] != DBNull.Value)
                        {
                            MedicationEndDate =
                                DateTime.Parse(drMedication["MedicationEndDate"].ToString()).ToShortDateString();
                        }
                        else
                        {
                            MedicationEndDate = DBNull.Value.ToString();
                        }


                        if (dtClientMedicationCopy.Columns.Contains("Discontinued"))
                        {
                            Discontinued = drMedication["Discontinued"] == DBNull.Value
                                               ? "N"
                                               : drMedication["Discontinued"].ToString();
                        }

                        // Code in ref to Task # 128
                        if (dtClientMedicationCopy.Columns.Contains("Ordered"))
                            ordered = drMedication["Ordered"] == DBNull.Value ? "N" : drMedication["Ordered"].ToString();

                        string SmartCareOrderEntry = drMedication["SmartCareOrderEntry"] == DBNull.Value
                                                  ? ""
                                                  : drMedication["SmartCareOrderEntry"].ToString();

                        string AddedBy = drMedication["AddedBy"] == DBNull.Value
                                                  ? ""
                                                  : drMedication["AddedBy"].ToString();

                        string DiscontinuedBy = drMedication["DiscontinuedBy"] == DBNull.Value
                                                 ? ""
                                                 : drMedication["DiscontinuedBy"].ToString();

                        // Add new row in _dtMedicationTemp
                        //Changed by Loveena in Ref to Task#128 to display OrdeDate in View Medication History.
                        //Modified by Loveena in ref to Task#2779 on 15Jan2010
                        //_dtMedicationTemp.Rows.Add(new object[] { medicationID, prescribedBy, specialInstruction, System.DBNull.Value, ordered, Discontinued, MedicationStartDate, MedicationEndDate, OrderStatus, OrderStatusDate, MedicationScriptId, System.DBNull.Value, OrderDate, _titrationType, offLabel, discontinuedReason, discontinuedReasonCode });
                        if (_calledFromControllerName == "ViewMedicationHistory")
                        {
                            int RowNo = int.Parse(drMedication["Row#"].ToString());

                            _dtMedicationTemp.Rows.Add(new object[]
                            {
                                medicationID, prescribedBy, specialInstruction, DBNull.Value, ordered, Discontinued,
                                MedicationStartDate, MedicationEndDate, OrderStatus, OrderStatusDate, MedicationScriptId
                                , DBNull.Value, OrderDate, _titrationType, offLabel, comments, discontinuedReason,
                                discontinuedReasonCode, DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value,
                                DBNull.Value, DBNull.Value, SmartCareOrderEntry,AddedBy,DiscontinuedBy,RowNo
                            });
                        }
                        else {
                            _dtMedicationTemp.Rows.Add(new object[]
                            {
                                medicationID, prescribedBy, specialInstruction, DBNull.Value, ordered, Discontinued,
                                MedicationStartDate, MedicationEndDate, OrderStatus, OrderStatusDate, MedicationScriptId
                                , DBNull.Value, OrderDate, _titrationType, offLabel, comments, discontinuedReason,
                                discontinuedReasonCode, DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value,
                                DBNull.Value, DBNull.Value, SmartCareOrderEntry,AddedBy,DiscontinuedBy
                            });
                        
                        }

                        // Add new rows in _dtMedicationInstructionTemp 
                        DataRow[] drClientMedicationInstructions;
                        //if (_sortString.Contains("StartDate") || _sortString.Contains("EndDate") ||  _sortString.Contains("Instruction"))
                        //{
                        //    drClientMedicationInstructions = dtClientMedicalInstructions.Select("ClientMedicationId='" + medicationID + "'", _sortString);
                        //}
                        //else
                        //{
                        //    drClientMedicationInstructions = dtClientMedicalInstructions.Select("ClientMedicationId='" + medicationID + "'","StartDate Desc");
                        //}
                        if (dtClientMedicalInstructions.Columns.Contains("MedicationOrderStatus"))
                        {
                            drClientMedicationInstructions =
                                dtClientMedicalInstructions.Select("ClientMedicationId='" + medicationID +
                                                                   "'  and ISNULL(MedicationOrderStatus,'')='" +
                                                                   MedicationOrderStatus +
                                                                   "' and ISNULL(MedicationScriptId,'')='" +
                                                                   MedicationScriptId + "'");
                        }
                        else
                        {
                            drClientMedicationInstructions =
                                dtClientMedicalInstructions.Select("ClientMedicationId='" + medicationID + "'");
                        }


                        if (drClientMedicationInstructions.Length == 0)
                        {
                            //  _dtMedicationInstructionTemp.Rows.Add(new object[] { "-1", "0", "", "", medicationName, "", "", "" });
                        }
                        else
                        {
                            foreach (DataRow drMedInstruction in drClientMedicationInstructions)
                            {
                                if (drMedInstruction["RecordDeleted"] == DBNull.Value ||
                                    drMedInstruction["RecordDeleted"].ToString() == "N")
                                {
                                    // Check if this start/end date already exists...
                                    // If no, then  we add a new row or we update the instructions of the already present row...
                                    string startDate = "";
                                    //if (drMedInstruction["StartDate"] != DBNull.Value || drMedInstruction["StartDate"].ToString() != "")
                                    //    startDate = DateTime.Parse(drMedInstruction["StartDate"].ToString()).ToShortDateString();

                                    string instructions = drMedInstruction["Instruction"].ToString();
                                    string endDate = "";

                                    //if (drMedInstruction["EndDate"] != DBNull.Value || drMedInstruction["EndDate"].ToString() != "")
                                    //    endDate = DateTime.Parse(drMedInstruction["EndDate"].ToString()).ToShortDateString();


                                    string selectString = "MedicationId = '" + medicationID + "'";

                                    // If the end date is Not Null then we need to check for same start/end date
                                    //if (startDate != "" && endDate != "")
                                    //    selectString = "MedicationId = '" + medicationID + "' AND StartDate='" + startDate + "' AND EndDate='" + endDate + "'";

                                    DataRow[] drMedicationIns = _dtMedicationInstructionTemp.Select(selectString);
                                    if (drMedicationIns.Length != 0)
                                    {
                                        //startDate = "";
                                        //endDate = "";
                                    }

                                    DataRow drNew = _dtMedicationInstructionTemp.NewRow();
                                    drNew["MedicationId"] = medicationID;
                                    drNew["MedicationInstructionId"] = drMedInstruction["ClientMedicationInstructionId"];
                                    //Changes as per Task 2377 SC-Supports
                                    //drNew["StartDate"] = startDate;
                                    //drNew["EndDate"] = endDate;
                                    drNew["Medication"] = medicationName;
                                    drNew["Instruction"] = ApplicationCommonFunctions.cutText(instructions, 240);
                                    drNew["DAWorQuantity"] = drMedication["DAW"].ToString();

                                    if (drMedInstruction.Table.Columns.Contains("Refills"))
                                        drNew["Refills"] = drMedInstruction["Refills"];
                                    else
                                        drNew["Refills"] = "";


                                    if (drMedInstruction.Table.Columns.Contains("CalculatedQty"))
                                        drNew["CalculatedQty"] = drMedInstruction["CalculatedQty"];
                                    else
                                        drNew["CalculatedQty"] = "";
                                    drNew["WarningorRefillorIndicator"] = "";
                                    drNew["MedicationName"] = drMedInstruction["MedicationName"];
                                    drNew["MedicationOrderStatus"] = drMedInstruction["MedicationOrderStatus"];
                                    drNew["MedicationScriptId"] = drMedInstruction["MedicationScriptId"];
                                    //Added by Chandan on 17th Dec 2008 for task #127
                                    drNew["StartDate"] = drMedInstruction["StartDate"];
                                    drNew["EndDate"] = drMedInstruction["EndDate"];
                                    //End By Chandan
                                    _dtMedicationInstructionTemp.Rows.Add(drNew);
                                }
                            }
                        }
                    }
                }

                // Now need to display only a single text for the medication name....
                for (int icount = 0; icount < _dtMedicationTemp.Rows.Count; icount++)
                {
                    DataRow dr = _dtMedicationTemp.Rows[icount];
                    int medicationId = Convert.ToInt32(dr["MedicationId"]);

                    string MedicationOrderStatus = dr["OrderStatus"].ToString();
                    DataRow[] drMedInfo;
                    if (_dtMedicationInstructionTemp.Columns.Contains("MedicationOrderStatus") &&
                        _dtMedicationInstructionTemp.Columns.Contains("MedicationScriptId"))
                    {
                        drMedInfo =
                            _dtMedicationInstructionTemp.Select("MedicationId='" + medicationId.ToString() +
                                                                "' and ISNULL(MedicationOrderStatus,'')='" +
                                                                MedicationOrderStatus +
                                                                "' and ISNULL(MedicationScriptId,'')='" +
                                                                dr["MedicationScriptId"] + "'");
                    }
                    else
                        drMedInfo = _dtMedicationInstructionTemp.Select("MedicationId='" + medicationId.ToString() + "'");

                    if (drMedInfo.Length < 1)
                    {
                        _dtMedicationTemp.Rows.Remove(dr);
                        //added by anuj for task ref:3062 in 24 May,2010
                        icount--;
                        //ended over here
                    }

                    if (drMedInfo.Length > 1)
                    {
                        for (int rowIndex = 1; rowIndex < drMedInfo.Length; rowIndex++)
                        {
                            drMedInfo[rowIndex]["Medication"] = "";
                            //drMedInfo[rowIndex]["PrescribedBy"] = "";
                        }
                    }
                }
                dvClientMedicationInstructions.Dispose();
            }

            catch (Exception ex)
            {
                throw ex;
            }
        }


        private void CompileDataTable(DataTable dtClientMedication, DataTable dtClientMedicalInstructions,
                                      DataTable dtClientMedicationInteractions,
                                      DataTable dtClientMedicationInteractionDetails,
                                      DataTable dtClientAllergiesInteraction)
        {
            try
            {
                // clear all the rows from the data table.

                _dtMedicationTemp.Clear();
                _dtMedicationInstructionTemp.Clear();
                _dtMedicationInteractionTemp.Clear();
                _dtMedicationAllergyTemp.Clear();

                ////Ref to Task # 182
                //DataTable dtActiveClientMedicationInstructions = dtClientMedicalInstructions.Clone();
                //DataRow[] _dataRowInstructions = dtClientMedicalInstructions.Select("ISNULL(Active,'Y')<>'N'");
                //foreach (DataRow dr in _dataRowInstructions)
                //{
                //    dtActiveClientMedicationInstructions.ImportRow(dr);
                //}

                //Getting max of instructions Id
                //Ref to Task # 182
                var dvClientMedicationInstructions = new DataView(dtClientMedicalInstructions);
                //DataView dvClientMedicationInstructions = new DataView(dtActiveClientMedicationInstructions);

                dvClientMedicationInstructions.Sort = "ClientMedicationInstructionId desc";
                int newClientMedicationInstructionId = 1;
                if (dvClientMedicationInstructions.Count > 0)
                    newClientMedicationInstructionId =
                        Convert.ToInt32(dvClientMedicationInstructions[0]["ClientMedicationInstructionId"]) + 1;
                //Checking for medications which do not have instructions 
                //and adding a dummy row into instructions
                foreach (DataRow dr in dtClientMedication.Rows)
                {
                    if (
                        dtClientMedicalInstructions.Select("ClientMedicationId=" +
                                                           Convert.ToInt32(dr["ClientMedicationId"]) +
                                                           "  and ISNULL(RecordDeleted,'N')='N'").Length < 1)
                    {
                        DataRow drCMI = dtClientMedicalInstructions.NewRow();
                        drCMI["ClientMedicationInstructionId"] = newClientMedicationInstructionId;
                        drCMI["ClientMedicationId"] = dr["ClientMedicationId"];
                        drCMI["MedicationName"] = dr["MedicationName"];
                        //drCMI["MedicationOrderStatus"] = dr["OrderStatus"];
                        drCMI["ModifiedBy"] = dr["ModifiedBy"];
                        drCMI["ModifiedDate"] = dr["ModifiedDate"];
                        drCMI["CreatedBy"] = dr["CreatedBy"];
                        drCMI["CreatedDate"] = dr["CreatedDate"];
                        drCMI["Instruction"] = string.Empty;
                        drCMI["RowIdentifier"] = Guid.NewGuid();
                        drCMI["Unit"] = 0;
                        //drCMI["DAWorQuantity"] = DBNull.Value;
                        dtClientMedicalInstructions.Rows.Add(drCMI);
                        newClientMedicationInstructionId++;
                    }
                }
                //In above foreach block changed the 'dtClientMedicalInstructions' with 'dtActiveClientMedicationInstructions'. in ref to Task # 182.

                DataTable dtClientMedicationCopy = dtClientMedication.Clone();

                // DataView dvClientMedicationInstructions = new DataView(dtClientMedicalInstructions);

                #region Modified by Loveena in ref to Task#2658

                //if (_sortString.Contains("Instruction"))
                //{
                //    dvClientMedicationInstructions.Sort = _sortString;
                //    dvClientMedicationInstructions.RowFilter = "ClientMedicationId >= 0 ";
                //    while (dvClientMedicationInstructions.Count > 0)
                //    {

                //        string str = " and ClientMedicationId <> " + dvClientMedicationInstructions[0]["ClientMedicationId"].ToString();
                //        DataRow[] drTemp = dtClientMedication.Select("ClientMedicationId=" + dvClientMedicationInstructions[0]["ClientMedicationId"]);

                //        if (drTemp.Length > 0)
                //            dtClientMedicationCopy.ImportRow(drTemp[0]);
                //        dvClientMedicationInstructions.RowFilter = dvClientMedicationInstructions.RowFilter + str;
                //    }
                //}
                //else if (_sortString.Contains("PrescriberName") || _sortString.Contains("MedicationName") || _sortString.Contains("Ordered") || _sortString.Contains("StartDate") || _sortString.Contains("EndDate"))
                //{
                //    foreach (DataRow drM in dtClientMedication.Select(null, _sortString))
                //        dtClientMedicationCopy.ImportRow(drM);
                //}

                #endregion

                //Modified by Loveena in ref to Task#2658
                //if (_sortString.Contains("Instruction"))
                if (_sortString.Contains("Instruction") || _sortString == "StartDate Asc" ||
                    _sortString == "StartDate Desc" || _sortString == "EndDate Asc" || _sortString == "EndDate Desc")
                {
                    dvClientMedicationInstructions.Sort = _sortString;
                    dvClientMedicationInstructions.RowFilter = "ClientMedicationId >= 0 ";
                    string filter = "ClientMedicationId not in(0)";
                    while (dvClientMedicationInstructions.Count > 0)
                    {
                        //string str = " and ClientMedicationId <> " + dvClientMedicationInstructions[0]["ClientMedicationId"].ToString();
                        string str = dvClientMedicationInstructions[0]["ClientMedicationId"].ToString();
                        DataRow[] drTemp =
                            dtClientMedication.Select("ClientMedicationId=" +
                                                      dvClientMedicationInstructions[0]["ClientMedicationId"]);

                        if (drTemp.Length > 0)
                            dtClientMedicationCopy.ImportRow(drTemp[0]);
                        //dvClientMedicationInstructions.RowFilter = dvClientMedicationInstructions.RowFilter + str;
                        filter = filter.Substring(0, filter.Trim().Length - 1) + "," + str + ")";
                        dvClientMedicationInstructions.RowFilter = filter.Trim();
                    }
                }
                //Modified by Loveena in ref to Task#2658
                else if (_sortString.Contains("PrescriberName") || _sortString.Contains("MedicationName") ||
                         _sortString.Contains("Ordered") || _sortString.Contains("MedicationStartDate") ||
                         _sortString.Contains("MedicationEndDate"))
                //                else if (_sortString.Contains("PrescriberName") || _sortString.Contains("MedicationName") || _sortString.Contains("Ordered") || _sortString.Contains("StartDate") || _sortString.Contains("EndDate"))
                {
                    ////Modified by Loveena in ref to Task#2658
                    //foreach (DataRow drM in dtClientMedication.Select(null, _sortString))
                    //    dtClientMedicationCopy.ImportRow(drM);
                    //dvClientMedicationInstructions.Sort = _sortString;
                    DataTable dtClientMedicationSortCopy = dtClientMedication.Clone();
                    dvClientMedicationInstructions.RowFilter = "ClientMedicationId >= 0 ";
                    string filter = "ClientMedicationId not in(0)";
                    while (dvClientMedicationInstructions.Count > 0)
                    {
                        //string str = " and ClientMedicationId <> " + dvClientMedicationInstructions[0]["ClientMedicationId"].ToString();
                        string str = dvClientMedicationInstructions[0]["ClientMedicationId"].ToString();
                        DataRow[] drTemp =
                            dtClientMedication.Select("ClientMedicationId=" +
                                                      dvClientMedicationInstructions[0]["ClientMedicationId"] + "");
                        if (drTemp.Length > 0)
                            dtClientMedicationSortCopy.ImportRow(drTemp[0]);

                        //dvClientMedicationInstructions.RowFilter = dvClientMedicationInstructions.RowFilter + str;
                        filter = filter.Substring(0, filter.Trim().Length - 1) + "," + str + ")";
                        dvClientMedicationInstructions.RowFilter = filter.Trim();
                    }
                    foreach (DataRow drM in dtClientMedicationSortCopy.Select(null, _sortString))
                        dtClientMedicationCopy.ImportRow(drM);
                }
                else if (String.IsNullOrEmpty(_sortString))
                {
                    dvClientMedicationInstructions.Sort = "MedicationName";
                    //dvClientMedicationInstructions.RowFilter = "ClientMedicationId >= 0 ";
                    string filter = "ClientMedicationId not in(0)";
                    while (dvClientMedicationInstructions.Count > 0)
                    {
                        //string str = " and ClientMedicationId <> " + dvClientMedicationInstructions[0]["ClientMedicationId"].ToString();
                        string str = dvClientMedicationInstructions[0]["ClientMedicationId"].ToString();
                        DataRow[] drTemp =
                            dtClientMedication.Select(
                                "ClientMedicationId=" + dvClientMedicationInstructions[0]["ClientMedicationId"] +
                                " and isnull(ordered,'N')='Y'", "MedicationStartDate desc, VerbalOrder desc");

                        if (drTemp.Length > 0)
                            dtClientMedicationCopy.ImportRow(drTemp[0]);
                        //dvClientMedicationInstructions.RowFilter = dvClientMedicationInstructions.RowFilter + str;
                        filter = filter.Substring(0, filter.Trim().Length - 1) + "," + str + ")";
                        dvClientMedicationInstructions.RowFilter = filter.Trim();
                    }

                    dvClientMedicationInstructions.Sort = "MedicationName";
                    dvClientMedicationInstructions.RowFilter = "ClientMedicationId >= 0 ";
                    filter = "ClientMedicationId not in(0)";
                    while (dvClientMedicationInstructions.Count > 0)
                    {
                        //string str = " and ClientMedicationId <> " + dvClientMedicationInstructions[0]["ClientMedicationId"].ToString();
                        string str = dvClientMedicationInstructions[0]["ClientMedicationId"].ToString();
                        DataRow[] drTemp =
                            dtClientMedication.Select(
                                "ClientMedicationId=" + dvClientMedicationInstructions[0]["ClientMedicationId"] +
                                " and  isnull(ordered,'N')='N'", "MedicationStartDate desc");

                        if (drTemp.Length > 0)
                            dtClientMedicationCopy.ImportRow(drTemp[0]);
                        //dvClientMedicationInstructions.RowFilter = dvClientMedicationInstructions.RowFilter + str;
                        filter = filter.Substring(0, filter.Trim().Length - 1) + "," + str + ")";
                        dvClientMedicationInstructions.RowFilter = filter.Trim();
                    }
                }

                foreach (DataRow drMedication in dtClientMedicationCopy.Rows)
                {
                    if (drMedication["RecordDeleted"] == DBNull.Value || drMedication["RecordDeleted"].ToString() == "N")
                    {
                        // Get the Medication Information...
                        string medicationID = drMedication["ClientMedicationId"].ToString();
                        string prescribedBy = drMedication["PrescriberName"].ToString();
                        //Added By Anuj for Task ref #3 on 16 Nov,2009 SDI Projects FY10 - Venture
                        int prescriberId = 0;
                        if (drMedication["PrescriberId"].ToString() != "" &&
                            drMedication["PrescriberId"].ToString() != null)
                        {
                            prescriberId = Convert.ToInt32(drMedication["PrescriberId"].ToString());
                        }
                        //Ended Over here
                        string specialInstruction = drMedication["SpecialInstructions"].ToString();
                        //Added by Loveena in ref to Task#2433 on 11-April-2009 to shoe OffLabel
                        // And Discontinued Reason columns in View History.
                        string offLabel = drMedication["OffLabel"].ToString();
                        //Code modified by Loveena in ref to Task#2488 to display Discontinue Reason Code instead of Discontinue Reason text
                        string discontinuedReason = drMedication["DiscontinuedReason"].ToString();
                        Int32 discontinuedReasonCode = 0;
                        if (drMedication["DiscontinuedReasonCode"] != DBNull.Value)
                        {
                            discontinuedReasonCode = Convert.ToInt32(drMedication["DiscontinuedReasonCode"]);
                        }
                        //code ends over here.    
                        string medicationName = drMedication["MedicationName"].ToString();
                        string MedicationStartDate = "";
                        //Code added by Ankesh Bharti in Ref to Task #2409
                        string MedicationScriptId = drMedication["MedicationScriptId"].ToString(); //Ref to Task #2409
                        //string MedicationStartDate = DateTime.Parse(drMedication["MedicationStartDate"].ToString()).ToShortDateString();

                        //if (_showMinScriptDrugsEndDate == true)
                        //    MedicationStartDate = DateTime.Parse(drMedication["MedicationEndDateForDisplay"].ToString()).ToShortDateString();
                        //else
                        //    if (string.IsNullOrEmpty(drMedication["MedicationStartDate"].ToString()) == false)
                        //        MedicationStartDate = DateTime.Parse(drMedication["MedicationStartDate"].ToString()).ToShortDateString();
                        if (_showMinScriptDrugsEndDate)
                        {
                            if (drMedication["MedicationEndDateForDisplay"] != null &&
                                drMedication["MedicationEndDateForDisplay"].ToString() != "")
                            {
                                MedicationStartDate =
                                    DateTime.Parse(drMedication["MedicationEndDateForDisplay"].ToString())
                                            .ToShortDateString();
                            }
                            else
                            {
                                if (string.IsNullOrEmpty(drMedication["MedicationStartDate"].ToString()) == false)
                                {
                                    MedicationStartDate =
                                        DateTime.Parse(drMedication["MedicationStartDate"].ToString())
                                                .ToShortDateString();
                                }
                            }
                        }
                        else
                        {
                            if (string.IsNullOrEmpty(drMedication["MedicationStartDate"].ToString()) == false)
                            {
                                MedicationStartDate =
                                    DateTime.Parse(drMedication["MedicationStartDate"].ToString()).ToShortDateString();
                            }
                        }


                        string MedicationEndDate = drMedication["MedicationEndDate"] == DBNull.Value
                                                       ? ""
                                                       : DateTime.Parse(drMedication["MedicationEndDate"].ToString())
                                                                 .ToShortDateString();
                        string _titrationType = drMedication["TitrationType"] == DBNull.Value
                                                    ? ""
                                                    : drMedication["TitrationType"].ToString();
                        string ordered = "Y";
                        string MedicationNameId = "";
                        string Discontinued = "N";
                        if (dtClientMedicationCopy.Columns.Contains("MedicationNameId"))
                            MedicationNameId = drMedication["MedicationNameId"].ToString();
                        if (dtClientMedicationCopy.Columns.Contains("Ordered"))
                            ordered = drMedication["Ordered"] == DBNull.Value ? "N" : drMedication["Ordered"].ToString();
                        //Added a New column Discontinued's value
                        if (dtClientMedicationCopy.Columns.Contains("Discontinued"))
                            Discontinued = drMedication["Discontinued"] == DBNull.Value
                                               ? "N"
                                               : drMedication["Discontinued"].ToString();
                        //Added by Loveena in ref to Task#2465 to display ConsentIcon if record exists in ClientMedicationConsent.
                        int ClientMedicationConsentId = 0;
                        if (drMedication["ClientMedicationConsentId"] != DBNull.Value)
                            ClientMedicationConsentId = Convert.ToInt32(drMedication["ClientMedicationConsentId"]);
                        //Code ends over here.
                        //Added by Anuj as task ref #18 for SDI Projects FY10 - Venture on 30oct,2009
                        int SignedByMD = 0;
                        if (drMedication["SignedByMD"] != DBNull.Value)
                            SignedByMD = Convert.ToInt32(drMedication["SignedByMD"]);
                        //Added by Anuj as task ref #3 for SDI Projects FY10 - Venture on 16Nov,2009
                        int VerbalOrder = 0;
                        if (drMedication["VerbalOrder"] != DBNull.Value)
                            VerbalOrder = Convert.ToInt32(drMedication["VerbalOrder"]);
                        //Ended Over here
                        //--Start Added by Pradeep as per task#12
                        string Comments = drMedication["Comments"] == DBNull.Value
                                              ? ""
                                              : Convert.ToString(drMedication["Comments"]);
                        //Code added by Loveena in ref to Task#2983
                        string AllowAllergyMedications = Convert.ToString(drMedication["AllowAllergyMedications"]);
                        string SureScriptsOutgoingMessageId =
                            dtClientMedicationCopy.Columns.Contains("SureScriptsOutgoingMessageId")
                                ? drMedication["SureScriptsOutgoingMessageId"]
                                      .ToString()
                                : "";
                        string PharmacyName = dtClientMedicationCopy.Columns.Contains("PharmacyName")
                                                  ? drMedication["PharmacyName"].ToString()
                                                  : "";
                        string SmartCareOrderEntry = dtClientMedicationCopy.Columns.Contains("SmartCareOrderEntry")
                                                  ? drMedication["SmartCareOrderEntry"].ToString()
                                                  : "";

                        string AddedBy = dtClientMedicationCopy.Columns.Contains("AddedBy")
                                                  ? drMedication["AddedBy"].ToString()
                                                  : "";
                        if (_calledFromControllerName == "ViewMedicationHistory")
                        {
                            int RowNo = int.Parse(drMedication["Row#"].ToString());
                            _dtMedicationTemp.Rows.Add(new object[]
                            {
                                medicationID, prescribedBy, specialInstruction, MedicationNameId, ordered, Discontinued,
                                MedicationStartDate, MedicationEndDate, DBNull.Value, DBNull.Value, MedicationScriptId,
                                DBNull.Value, DBNull.Value, _titrationType, offLabel, Comments, discontinuedReason,
                                discontinuedReasonCode, ClientMedicationConsentId, SignedByMD, VerbalOrder, prescriberId
                                , AllowAllergyMedications, SureScriptsOutgoingMessageId, PharmacyName, SmartCareOrderEntry,AddedBy,RowNo
                            });
                        }
                        else
                        {
                            _dtMedicationTemp.Rows.Add(new object[]
                            {
                                medicationID, prescribedBy, specialInstruction, MedicationNameId, ordered, Discontinued,
                                MedicationStartDate, MedicationEndDate, DBNull.Value, DBNull.Value, MedicationScriptId,
                                DBNull.Value, DBNull.Value, _titrationType, offLabel, Comments, discontinuedReason,
                                discontinuedReasonCode, ClientMedicationConsentId, SignedByMD, VerbalOrder, prescriberId
                                , AllowAllergyMedications, SureScriptsOutgoingMessageId, PharmacyName, SmartCareOrderEntry,AddedBy
                            });
                        }
                        DataRow[] drClientMedicationInstructions;
                        drClientMedicationInstructions =
                            dtClientMedicalInstructions.Select("ClientMedicationId='" + medicationID + "'");

                        if (drClientMedicationInstructions.Length == 0)
                        {
                            //  _dtMedicationInstructionTemp.Rows.Add(new object[] { "-1", "0", "", "", medicationName, "", "", "" });
                        }
                        else
                        {
                            foreach (DataRow drMedInstruction in drClientMedicationInstructions)
                            {
                                if (drMedInstruction["RecordDeleted"] == DBNull.Value ||
                                    drMedInstruction["RecordDeleted"].ToString() == "N")
                                {
                                    // Check if this start/end date already exists...
                                    // If no, then  we add a new row or we update the instructions of the already present row...
                                    //string startDate = "";
                                    //if (drMedInstruction["StartDate"] != DBNull.Value || drMedInstruction["StartDate"].ToString() != "")
                                    //    startDate = DateTime.Parse(drMedInstruction["StartDate"].ToString()).ToShortDateString();

                                    string instructions = drMedInstruction["Instruction"].ToString();
                                    string endDate = "";

                                    //if (drMedInstruction["EndDate"] != DBNull.Value || drMedInstruction["EndDate"].ToString() != "")
                                    //    endDate = DateTime.Parse(drMedInstruction["EndDate"].ToString()).ToShortDateString();

                                    string selectString = "MedicationId = '" + medicationID + "'";

                                    // If the end date is Not Null then we need to check for same start/end date
                                    //if (startDate != "" && endDate != "")
                                    //    selectString = "MedicationId = '" + medicationID + "' AND StartDate='" + startDate + "' AND EndDate='" + endDate + "'";

                                    DataRow[] drMedicationIns = _dtMedicationInstructionTemp.Select(selectString);
                                    if (drMedicationIns.Length != 0)
                                    {
                                        //startDate = "";
                                        //endDate = "";
                                    }

                                    DataRow drNew = _dtMedicationInstructionTemp.NewRow();
                                    drNew["MedicationId"] = medicationID;
                                    drNew["MedicationInstructionId"] = drMedInstruction["ClientMedicationInstructionId"];
                                    //drNew["StartDate"] = startDate;
                                    //drNew["EndDate"] = endDate;
                                    drNew["Medication"] = medicationName;
                                    drNew["Instruction"] = ApplicationCommonFunctions.cutText(instructions, 240);
                                    drNew["DAWorQuantity"] = drMedication["DAW"].ToString();
                                    //Code added by Ankesh Bharti in Ref to Task #2409     
                                    drNew["MedicationScriptId"] = drMedication["MedicationScriptId"].ToString();

                                    if (drMedInstruction.Table.Columns.Contains("Refills"))
                                        drNew["Refills"] = drMedInstruction["Refills"];
                                    else
                                        drNew["Refills"] = "";

                                    if (drMedInstruction.Table.Columns.Contains("CalculatedQty"))
                                        drNew["CalculatedQty"] = drMedInstruction["CalculatedQty"];
                                    else
                                        drNew["CalculatedQty"] = "";
                                    drNew["WarningorRefillorIndicator"] = "";
                                    drNew["MedicationName"] = drMedInstruction["MedicationName"];

                                    //Code Ref Task #77
                                    drNew["InformationComplete"] = drMedInstruction["InformationComplete"];
                                    //Code end over here
                                    drNew["StartDate"] = drMedInstruction["StartDate"];
                                    drNew["EndDate"] = drMedInstruction["EndDate"];
                                    //Start:Code in Ref to Task # 75
                                    drNew["TitrationStepNumber"] = drMedInstruction["TitrationStepNumber"];
                                    drNew["Days"] = drMedInstruction["Days"];
                                    drNew["Pharmacy"] = drMedInstruction["Pharmacy"];
                                    drNew["Sample"] = drMedInstruction["Sample"];
                                    drNew["Stock"] = drMedInstruction["Stock"];
                                    //End:Code in Ref to Task # 75
                                    _dtMedicationInstructionTemp.Rows.Add(drNew);
                                }
                            }
                        }
                    }
                }
                //// Now need to display only a single text for the medication name....
                //foreach (DataRow dr in _dtMedicationTemp.Rows)
                //{
                //    int medicationId = Convert.ToInt32(dr["MedicationId"]);
                //    DataRow[] drMedInfo = _dtMedicationInstructionTemp.Select("MedicationId='" + medicationId.ToString() + "'");

                //    if (drMedInfo.Length < 1)
                //    {
                //        _dtMedicationTemp.Rows.Remove(dr);
                //    }

                //    if (drMedInfo.Length > 1)
                //    {
                //        for (int rowIndex = 1; rowIndex < drMedInfo.Length; rowIndex++)
                //        {
                //            drMedInfo[rowIndex]["Medication"] = "";
                //            //drMedInfo[rowIndex]["PrescribedBy"] = "";
                //        }
                //    }
                //}
                // Now need to display only a single text for the medication name....

                for (int icount = 0; icount < _dtMedicationTemp.Rows.Count; icount++)
                {
                    DataRow dr = _dtMedicationTemp.Rows[icount];
                    int medicationId = Convert.ToInt32(dr["MedicationId"]);
                    DataRow[] drMedInfo =
                        _dtMedicationInstructionTemp.Select("MedicationId='" + medicationId.ToString() + "'");

                    if (drMedInfo.Length < 1)
                    {
                        _dtMedicationTemp.Rows.Remove(dr);
                    }
                    if (drMedInfo.Length > 1)
                    {
                        for (int rowIndex = 1; rowIndex < drMedInfo.Length; rowIndex++)
                        {
                            drMedInfo[rowIndex]["Medication"] = "";
                            //drMedInfo[rowIndex]["PrescribedBy"] = "";
                        }
                    }
                    if (!(dr["Discontinued"].ToString() == "Y"))
                    {
                        /*if (strDiscontinuedMedications == "")
                            strDiscontinuedMedications = medicationId.ToString();
                        else
                            strDiscontinuedMedications = strDiscontinuedMedications + "," + medicationId.ToString();*/
                        strDiscontinuedMedications += medicationId.ToString() + ",";
                    }
                }
                if (Session["DataSetClientSummary"] != null)
                {
                    using (var dsSetClientSummary = (DataSet)Session["DataSetClientSummary"])
                    {
                        for (int icount = 0; icount < dtClientMedicationInteractions.Rows.Count; icount++)
                        {
                            if (
                                dsSetClientSummary.Tables["ClientMedications"].Select(
                                    "ISNULL(RecordDeleted,'N')<>'Y' and ISNULL(Discontinued,'N')<>'Y' and ClientMedicationId=" +
                                    dtClientMedicationInteractions.Rows[icount]["ClientMedicationId1"]).Length > 0)
                            {
                                if (
                                    strDiscontinuedMedications.IndexOf(
                                        dtClientMedicationInteractions.Rows[icount]["ClientMedicationId1"].ToString()) <
                                    0)
                                {
                                    strDiscontinuedMedications +=
                                        dtClientMedicationInteractions.Rows[icount]["ClientMedicationId1"] + ",";
                                }
                            }
                            if (
                                dsSetClientSummary.Tables["ClientMedications"].Select(
                                    "ISNULL(RecordDeleted,'N')<>'Y' and ISNULL(Discontinued,'N')<>'Y' and ClientMedicationId=" +
                                    dtClientMedicationInteractions.Rows[icount]["ClientMedicationId2"]).Length > 0)
                            {
                                if (
                                    strDiscontinuedMedications.IndexOf(
                                        dtClientMedicationInteractions.Rows[icount]["ClientMedicationId2"].ToString()) <
                                    0)
                                {
                                    strDiscontinuedMedications +=
                                        dtClientMedicationInteractions.Rows[icount]["ClientMedicationId2"] + ",";
                                }
                            }
                        }
                    }
                }

                strDiscontinuedMedications = strDiscontinuedMedications.TrimEnd(',');

                if (strDiscontinuedMedications != "")
                {
                    DataRow[] drMedicationInteractions =
                        dtClientMedicationInteractions.Select("ClientMedicationId1  in (" + strDiscontinuedMedications +
                                                              ") and ClientMedicationId2  in (" +
                                                              strDiscontinuedMedications + ")");
                    //      _dtMedicationInteractionTemp.Merge(dtClientMedicationInteractions);
                    foreach (DataRow drMedInteraction in drMedicationInteractions)
                        _dtMedicationInteractionTemp.ImportRow(drMedInteraction);
                }

                //   _dtMedicationInteractionTemp.Merge(dtClientMedicationInteractions);
                _dtMedicationAllergyTemp.Merge(dtClientAllergiesInteraction);
                dvClientMedicationInstructions.Dispose();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        ///     Compiles the data table for the Medication Tab
        ///     Added by Rohit Verma on 4th Sept 2007
        /// </summary>
        private void CompileMedicationTabDataTable(DataTable dtClientMedication, DataTable dtClientMedicalInstructions,
                                                   DataTable DataTableClientMedicationInteractions,
                                                   DataTable DataTableClientMedicationInteractionDetails,
                                                   DataTable DataTableClientAllergyInteractions)
        {
            try
            {
                // Compile the data table..
                if (DataTableClientMedicationInteractions != null && DataTableClientMedicationInteractionDetails != null &&
                    DataTableClientAllergyInteractions != null)
                {
                    CompileDataTable(dtClientMedication, dtClientMedicalInstructions,
                                     DataTableClientMedicationInteractions, DataTableClientMedicationInteractionDetails,
                                     DataTableClientAllergyInteractions);
                }
                else
                {
                    CompileDataTable(dtClientMedication, dtClientMedicalInstructions);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        ///     Compiles the data table for the Medication Tab
        ///     Added by Rohit Verma on 4th Sept 2007
        /// </summary>
        private void CompileAddMedicationDataTable(DataTable dtClientMedication, DataTable dtClientMedicalInstructions)
        {
            try
            {
                // Compile the data table..
                CompileDataTable(dtClientMedication, dtClientMedicalInstructions);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        ///     Compiles the data table for the New Medication form
        ///     Added by Rohit Verma on 4th Sept 2007
        /// </summary>
        private void CompileNewMedicationDataTable(DataView dvClientMedication, DataView dvClientMedicationInstructions,
                                                   DataTable dtClientMedicationInteraction,
                                                   DataTable dtClientMedicationInteractionDetails,
                                                   DataTable dtClientAllergiesInteraction)
        {
            try
            {
                DataTable dtClientMedicationInstructions = dvClientMedicationInstructions.Table.Copy();
                dtClientMedicationInstructions.Clear();
                DataRow[] _dataRowInstructions =
                    dvClientMedicationInstructions.ToTable().Select("ISNULL(Active,'Y')<>'N'");
                foreach (DataRow dr in _dataRowInstructions)
                {
                    dtClientMedicationInstructions.ImportRow(dr);
                }

                // Get the data table from the given views
                DataTable dtMedications = dvClientMedication.Table.Copy();
                //dvClientMedicationInstructions.RowFilter = "ISNULL(Active,'Y')<>'N'";
                //DataTable dtClientMedicationInstructions = dvClientMedicationInstructions.Table.Copy();
                CompileDataTable(dtMedications, dtClientMedicationInstructions, dtClientMedicationInteraction,
                                 dtClientMedicationInteractionDetails, dtClientAllergiesInteraction);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        #endregion

        #region Generate Control Rows as per Form

        /// <summary>
        /// </summary>
        public void GenerateNewTitrationControlRows(DataView dvClientMedication, DataView dvClientMedicationInstructions,
                                                    DataTable dtClientMedicationInteraction,
                                                    DataTable dtClientMedicationInteractionDetail,
                                                    DataTable dtClientAllergiesInteraction, bool showDeleteButton,
                                                    int titrationStepNumber)
        {
            try
            {
                _showButton = showDeleteButton;
                _showChButton = false;
                _showDAW = false;
                _showMedicationLink = false;
                _showQuantity = false;
                _showCheckBox = false;
                _showPrescribedBy = false;
                _showRefill = false;
                _showAcknowledge = false;
                _showOrderedIcon = false;
                _showTitrateIcon = false;
                _showDrugWarning = false;
                _showMedicationName = false;
                _showDateInitiated = false;
                //Added By Anuj as per task ref #3 on 16 nov,2009 SDI Projects FY10 - Venture
                _showApprovalButton = false;
                _showApprovalMessage = false;
                //Ended over here
                _showRadioButton = true;
                _showStepNo = true;
                _showDayNo = true;
                _showDateWarning = true;
                _showDays = true;
                _showPharmacy = true;
                _showSample = true;
                _showStock = true;
                _showCumulativeInfo = true;
                _instructionsTitle = "Instruction";
                _deleteRowMessage = "Are you sure you want to delete this row?";
                _drugAllergyTitle = "Drug/Allergy  Interaction Warnings";

                DataTable dtClientMedications = dvClientMedication.Table.Copy();
                DataTable dtClientMedicalInstructions = dvClientMedicationInstructions.Table.Copy();
                CompileDataTableForTitration(dtClientMedications, dtClientMedicalInstructions,
                                             dtClientMedicationInteraction, dtClientMedicationInteractionDetail,
                                             dtClientAllergiesInteraction, titrationStepNumber);

                GenerateTitrationRows();
            }
            catch (Exception ex)
            {
                throw (ex);
            }
        }


        /// <summary>
        ///     Generated Medication Control Rows in New Medication Oder form
        ///     Added by Rohit Verma on 3rd Sept 2007
        /// </summary>
        public void GenerateNewMedicationControlRows(DataView dvClientMedication,
                                                     DataView dvClientMedicationInstructions,
                                                     DataTable dtClientMedicationInteraction,
                                                     DataTable dtClientMedicationInteractionDetail,
                                                     DataTable dtClientAllergiesInteraction, bool showDeleteButton,
                                                     string methodName)
        {
            try
            {
                // Set the control generation variables...
                _showButton = showDeleteButton;
                _showChButton = false;
                _showDAW = true;
                _showDrugWarning = true;
                _showRadioButton = true;
                _showEduInfoButton = true;
                _showRefill = true;
                _showMedicationLink = false;
                _showQuantity = false;
                _showCheckBox = false;
                _showPrescribedBy = false;
                _showAcknowledge = true;
                _showOrderedIcon = false; // Code added with ref to task # 77  
                _showTitrateIcon = false;
                //Added By Anuj for task ref #3 on 16 nov ,2009 SDI Projects FY10 - Venture
                _showApprovalButton = false;
                _showApprovalMessage = false;
                //Ended over here
                _instructionsTitle = "Instruction";
                _deleteRowMessage = "Are you sure you want to delete this row?";
                _drugAllergyTitle = "Drug/Allergy  Interaction Warnings";

                method = methodName;
                // Create the data table to be binded...
                CompileNewMedicationDataTable(dvClientMedication, dvClientMedicationInstructions,
                                              dtClientMedicationInteraction, dtClientMedicationInteractionDetail,
                                              dtClientAllergiesInteraction);

                // Generate the Rows...
                GenerateRows();
            }
            catch (Exception ex)
            {
                throw (ex);
            }
        }

        /// <summary>
        ///     Generated Medication Control Rows form Medication List Tab in Medications form
        ///     Added by Rohit Verma on 3rd Sept 2007
        /// </summary>
        public void GenerationMedicationTabControlRows(DataTable dtClientMedication,
                                                       DataTable dtClientMedicalInstructions,
                                                       DataTable DataTableClientMedicationInteractions,
                                                       DataTable DataTableClientMedicationInteractionDetails,
                                                       DataTable DataTableClientAllergyInteractions)
        {
            // Set the control generation variables...
            // _showButton = true;
            //Commented by Sonia as ChButton display depends upon Screen this will be set from the main Page

            //_showChButton = false;
            _showDAW = false;
            _showRadioButton = false;
            _showEduInfoButton = false;

            // _showMedicationLink = true;
            //Commented by Sonia as ChButton display depends upon Screen this will be set from the main Page
            //_showRefill = false;
            //_showQuantity = false;
            //_showCheckBox = true;
            _showPrescribedBy = true;

            _showOrderedIcon = true; // Code added in ref to Task # 77.
            _showTitrateIcon = true;
            //added By Anuj on 18nov,2009 for task ref 3 SDI venture-10
            _showApprovalButton = true;
            _showApprovalMessage = true;
            //Ended over here

            //this.labelInstruction.Text = "Instruction";

            // Create the data table to be binded...
            CompileMedicationTabDataTable(dtClientMedication, dtClientMedicalInstructions,
                                          DataTableClientMedicationInteractions,
                                          DataTableClientMedicationInteractionDetails,
                                          DataTableClientAllergyInteractions);

            //Following code added by Sonia/Devinder 
            //With Ref to Ticket #3 SDI FY10-Venture Project
            //Need to Club items Waiting for approval under one section

            var dvNotWaitigforApproval = new DataView(_dtMedicationTemp);
            dvNotWaitigforApproval.RowFilter = "ISNull(VerbalOrder,'0')<>2";
            var dvWaitingForApproval = new DataView(_dtMedicationTemp);
            dvWaitingForApproval.RowFilter = "VerbalOrder=2";
            var dtMedicationSortRow = new MedicationList.MedicationsDataTable();
            //dtMedicationSortRow = _dtMedicationTemp.Clone();

            for (int i = 0; i < dvNotWaitigforApproval.Count; i++)
            {
                dtMedicationSortRow.ImportRow(dvNotWaitigforApproval[i].Row);
            }
            for (int i = 0; i < dvWaitingForApproval.Count; i++)
            {
                dtMedicationSortRow.ImportRow(dvWaitingForApproval[i].Row);
            }
            _dtMedicationTemp = dtMedicationSortRow;
            dvNotWaitigforApproval = null;
            dvWaitingForApproval = null;
            //Changes end over here Ref to Ticket #3 SDI FY10-Venture Project

            // Generate the Rows...
            GenerateRows();
        }

        /// <summary>
        ///     Generated Medication Control Rows in Prescribe form
        ///     Added by Rohit Verma on 3rd Sept 2007
        /// </summary>
        public void GeneratePrescribeControlRows()
        {
            // Set the control generation variables...
            _showButton = false;
            _showDAW = false;
            _showChButton = false;
            _showRadioButton = false;
            _showEduInfoButton = true;
            _showDrugWarning = false;
            _showRefill = true;
            _showCheckBox = true;
            _showQuantity = true;

            // Create the data table to be binded...
            //   CompileDefaultDataTable();

            // Generate the Rows...
            GenerateRows();
        }

        /// <summary>
        ///     Generated Medication Control Rows in Add Medication (Non Order) form
        ///     Added by Rohit Verma on 3rd Sept 2007
        /// </summary>
        public void GenerateAddMedicationNonOrderControlRows(DataTable dtClientMedication,
                                                             DataTable dtClientMedicationInstructions)
        {
            // Set the control generation variables...
            _showButton = true;
            _showDAW = true;
            _showChButton = false;
            _showDrugWarning = true;
            _showRadioButton = true;
            _showRefill = true;
            _showQuantity = true;
            _showCheckBox = true;
            _showPrescribedBy = false;

            _showOrderedIcon = false; // Code added in ref to Task # 77 
            _showTitrateIcon = false;
            //Added by Anuj for task ref #3 on 16 Nov,2009
            _showApprovalButton = false;
            _showApprovalMessage = false;
            //Ended over here
            //this.labelInstruction.Text = "Order";
            _drugAllergyTitle = "Drug/Allergy  Interaction Warnings";
            // Create the data table to be binded...
            CompileAddMedicationDataTable(dtClientMedication, dtClientMedicationInstructions);

            // Generate the Rows...
            GenerateRows();
        }

        /// <summary>
        ///     Generated Medication Control Rows form Patient Consent Tab in Medications form
        ///     Added by Rohit Verma on 3rd Sept 2007
        /// </summary>
        public void GeneratePatientConsentControlRows()
        {
            // Same as for Medication List Tab in Medications form
            //   GenerationMedicationTabControlRows();
        }

        #endregion
    }
}
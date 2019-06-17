using System;
using System.Web;
using System.Web.Services;
using System.Xml;
using System.Web.Services.Protocols;
using System.Web.Script.Services;
using System.Data;
using Streamline.BaseLayer;
using Streamline.UserBusinessServices;
using System.Configuration;
using System.Collections;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Text;
using System.IO;
using Microsoft.Reporting.WebForms;
using System.Collections.Generic;
using System.Security;
using System.Runtime.InteropServices;
using System.Linq;
using System.Drawing;

namespace Streamline.SmartClient.WebServices
{
    /// <summary>
    /// Summary description for ClientMedications
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [ScriptService]
    public class ClientMedicationsNonOrder : Streamline.BaseLayer.WebServices.WebServiceBasePage
    {

        public static bool DeleteImagesInDirectory = false;
        //Ref to Task#3
        bool flag = false;
        bool lastRow = false;
        byte[] renderedBytes;
        Microsoft.Reporting.WebForms.ReportViewer reportViewer1;
        public ClientMedicationsNonOrder()
        {
            try
            {
                base.Initialize();
                //Uncomment the following line if using designed components 
                //InitializeComponent(); 
                if (Session["UserContext"] == null)
                {
                    throw new Exception("Session Expired");
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        #region ClientMedicationPropery

        public class ClientMedicationRow
        {
            private Int32 _MedicationNameId;
            public Int32 MedicationNameId
            {
                get { return _MedicationNameId; }
                set { _MedicationNameId = value; }
            }

            private Int32 _UserDefinedMedicationNameId;
            public Int32 UserDefinedMedicationNameId
            {
                get { return _UserDefinedMedicationNameId; }
                set { _UserDefinedMedicationNameId = value; }
            }

            private string _DrugPurpose;
            public string DrugPurpose
            {
                get { return _DrugPurpose; }
                set { _DrugPurpose = value; }
            }

            private string _DSMCode;
            public string DSMCode
            {
                get { return _DSMCode; }
                set { _DSMCode = value; }
            }
            private string _DSMNumber;
            public string DSMNumber
            {
                get { return _DSMNumber; }
                set { _DSMNumber = value; }
            }


            private string _DxId;

            public string DxId
            {
                get { return _DxId; }
                set { _DxId = value; }
            }


            private string _PrescriberName;
            public string PrescriberName
            {
                get { return _PrescriberName; }
                set { _PrescriberName = value; }
            }

            private Int32 _PrescriberId;
            public Int32 PrescriberId
            {
                get { return _PrescriberId; }
                set { _PrescriberId = value; }
            }

            private string _SpecialInstructions;
            public string SpecialInstructions
            {
                get { return _SpecialInstructions; }
                set { _SpecialInstructions = value; }
            }

            private string _MedicationName;
            public string MedicationName
            {
                get { return _MedicationName; }
                set { _MedicationName = value; }
            }
            private string _RowIdentifierCM;
            public string RowIdentifierCM
            {
                get { return _RowIdentifierCM; }
                set { _RowIdentifierCM = value; }
            }
            //Added by Chandan on 17th March 2008
            private string _StartDate;
            public string StartDate
            {
                get { return _StartDate; }
                set { _StartDate = value; }
            }
            private string _EndDate;
            public string EndDate
            {
                get { return _EndDate; }
                set { _EndDate = value; }
            }
            //----Start Code Written By Pradeep as per task#31
            private string _PermitChangesByOtherUsers;
            public string PermitChangesByOtherUsers
            {
                get { return _PermitChangesByOtherUsers; }
                set { _PermitChangesByOtherUsers = value; }
            }
            //---End Code Written By Pradeep as per task#31
            ///////

            //Code Commented By Loveena in Ref to Task#79 to make NonOrderedMedication Grid same as Ordered Medication Grid
            private string _DrugCategory;

            public string DrugCategory
            {
                get { return _DrugCategory; }
                set { _DrugCategory = value; }
            }

            //Added by Loveena in Ref to Task#79 to show DAW Value. 
            private string _DAW;

            public string DAW
            {
                get { return _DAW; }
                set { _DAW = value; }
            }
            //Added by Loveena in ref to Task#2433 1.9 Interface Changes on 21-April-2009
            private string _DesiredOucome;
            public string DesiredOutcome
            {
                get { return _DesiredOucome; }
                set { _DesiredOucome = value; }
            }
            private string _Comments;
            public string Comments
            {
                get { return _Comments; }
                set { _Comments = value; }
            }
            private string _OffLabel;
            public string OffLabel
            {
                get { return _OffLabel; }
                set { _OffLabel = value; }
            }
            //Code Added by Loveena ends over here.
            //Code added by Loveena in ref to Task#32
            private string _IncludeCommentOnPrescription;
            public string IncludeCommentOnPrescription
            {
                get { return _IncludeCommentOnPrescription; }
                set { _IncludeCommentOnPrescription = value; }
            }
            //Code ends over here.
            private Int32 _RXSource;
            public Int32 RXSource
            {
                get { return _RXSource; }
                set { _RXSource = value; }
            }
        }
        public class ClientMedicationInstructionRow
        {
            private Int32 _StrengthId;
            public Int32 StrengthId
            {
                get { return _StrengthId; }
                set { _StrengthId = value; }
            }

            private Int32 _UserDefinedMedicationId;
            public Int32 UserDefinedMedicationId
            {
                get { return _UserDefinedMedicationId; }
                set { _UserDefinedMedicationId = value; }
            }

            private string _Unit;
            public string Unit
            {
                get { return _Unit; }
                set { _Unit = value; }
            }
            private string _Schedule;
            public string Schedule
            {
                get { return _Schedule; }
                set { _Schedule = value; }
            }
            private Decimal _Quantity;
            public Decimal Quantity
            {
                get { return _Quantity; }
                set { _Quantity = value; }
            }
            //Modified by Chandan on 17th march 2008 Task#2377
            //private string _StartDate;
            //public string StartDate
            //{
            //    get { return _StartDate; }
            //    set { _StartDate = value; }
            //}
            //private string _EndDate;
            //public string EndDate
            //{
            //    get { return _EndDate; }
            //    set { _EndDate = value; }
            //}
            //Modified End by Chandan on 17th march 2008 Task#2377
            private string _Instruction;
            public string Instruction
            {
                get { return _Instruction; }
                set { _Instruction = value; }
            }
            private string _RowIdentifierCMI;
            public string RowIdentifierCMI
            {
                get { return _RowIdentifierCMI; }
                set { _RowIdentifierCMI = value; }
            }


            //Code Commented By Loveena in Ref to Task#79 on 28 Nov 2008 to make NonOrderedMedication Grid same as Ordered Medication Grid
            private Int32 _Days;
            public Int32 Days
            {
                get { return _Days; }
                set { _Days = value; }
            }
            private Decimal _Pharmacy;
            public Decimal Pharmacy
            {
                get { return _Pharmacy; }
                set { _Pharmacy = value; }
            }
            private Decimal _Sample;
            public Decimal Sample
            {
                get { return _Sample; }
                set { _Sample = value; }
            }
            private Decimal _Stock;
            public Decimal Stock
            {
                get { return _Stock; }
                set { _Stock = value; }
            }
            private Decimal _Refills;
            public Decimal Refills
            {
                get { return _Refills; }
                set { _Refills = value; }
            }

            private string _StartDate;
            public string StartDate
            {
                get { return _StartDate; }
                set { _StartDate = value; }
            }
            private string _EndDate;
            public string EndDate
            {
                get { return _EndDate; }
                set { _EndDate = value; }
            }
            //Code Added By Loveena End Here.
            //Code added by Loveena in ref to Task#2802
            private string _PharmaText;
            public string PharmaText
            {
                get { return _PharmaText; }
                set { _PharmaText = value; }
            }
            //Code added by Loveena in ref to Task#2802
            private string _AutoCalcallow;
            public string AutoCalcallow
            {
                get { return _AutoCalcallow; }
                set { _AutoCalcallow = value; }
            }
            //Added by Loveena in ref to Task#85 SDI-FY10 Venture
            private string _StrengthRowIdentifier;
            public string StrengthRowIdentifier
            {
                get { return _StrengthRowIdentifier; }
                set { _StrengthRowIdentifier = value; }
            }

            public string PotencyUnitCode { get; set; }

            private string _NoOfDaysOfWeek;
            public string NoOfDaysOfWeek
            {
                get { return _NoOfDaysOfWeek; }
                set { _NoOfDaysOfWeek = value; }
            }
        }
        //----Start Code Written By Pradeep as per task#31
        private string _PermitChangesByOtherUsers;
        public string PermitChangesByOtherUsers
        {
            get { return _PermitChangesByOtherUsers; }
            set { _PermitChangesByOtherUsers = value; }
        }
        //---End Code Written By Pradeep as per task#31



        #endregion



        [WebMethod(EnableSession = true)]
        [GenerateScriptType(typeof(ClientMedicationRow))]
        [GenerateScriptType(typeof(ClientMedicationInstructionRow))]
        public string SaveMedicationRow(ClientMedicationRow objClientMedication, ClientMedicationInstructionRow[] objClientMedicationInstructions, string saveTemplateFlag)
        {

            try
            {
                bool newRowCM = false;
                bool newRowCMI = false;
                bool newRowCMSD = false;
                string _MedicationStartDate = "";
                string _MedicationEndDate = "";
                bool newRowCMSDS = false;
                bool _FlagMaxScriptDrugIdSelectedFromPrescribedPage = false;
                DataSet DataSetPrescibedMedications = null;
                Streamline.UserBusinessServices.DataSets.DataSetClientMedications dsClientMedications = null;
                DataTable DataTableClientMedications = null;
                DataTable DataTableClientMedicationInstructions = null;
                //Code added By Loveena in Ref to Task#79 to make NonOrderedMedication Grid same as Ordered Medication Grid
                DataTable DataTableClientMedicationScriptDrugs = null;
                //code end over here
                //Added by anuj Tomar on 12feb,2010
                DataTable DataTableClientMedicationScriptDrugStrengths = null;
                //Code ended over here
                bool newRowCMSDD = false;
                DataTable DataTableClientMedicationScriptDispenseDays = null;

                if (Session["DataSetClientMedications"] != null)
                    dsClientMedications = (Streamline.UserBusinessServices.DataSets.DataSetClientMedications)Session["DataSetClientMedications"];
                else
                    dsClientMedications = new Streamline.UserBusinessServices.DataSets.DataSetClientMedications();
                DataTableClientMedications = dsClientMedications.ClientMedications;
                DataTableClientMedicationInstructions = dsClientMedications.ClientMedicationInstructions;
                //Code added By Loveena in Ref to Task#79 to make NonOrderedMedication Grid same as Ordered Medication Grid
                DataTableClientMedicationScriptDrugs = dsClientMedications.ClientMedicationScriptDrugs;
                //code end over here
                //added by anuj on 12feb,2010
                DataTableClientMedicationScriptDrugStrengths = dsClientMedications.ClientMedicationScriptDrugStrengths;
                //ended over here
                DataTableClientMedicationScriptDispenseDays = dsClientMedications.ClientMedicationScriptDispenseDays;

                //For Client Medication
                if (objClientMedication.RowIdentifierCM == null || objClientMedication.RowIdentifierCM == "")
                    objClientMedication.RowIdentifierCM = "-1";
                DataRow[] temprowidentifier = DataTableClientMedications.Select("RowIdentifier='" + objClientMedication.RowIdentifierCM + "'");


                DataRow DataRowClientMedication;
                if (temprowidentifier.Length > 0)
                {
                    DataRowClientMedication = temprowidentifier[0];
                    newRowCM = false;
                }
                else
                {
                    //Following changes with ref to 2587
                    //We need not to identify whether any row exists with Old Medication Names         
                    //temprowidentifier = DataTableClientMedications.Select("MedicationNameId=" + objClientMedication.MedicationNameId);
                    if (temprowidentifier.Length > 0)
                    {
                        DataRowClientMedication = temprowidentifier[0];
                        newRowCM = false;
                    }
                    else
                    {
                        DataRowClientMedication = DataTableClientMedications.NewRow();
                        newRowCM = true;
                    }
                }



                //Code Added by Loveena in Ref to Task#79 on 25-dec-2008.
                //Ref StartDate and End Date Validations
                //Check if StartDate above grid and Startdates in the grid both are empty then 
                //Error message should be raised

                bool _NoStartDateInScriptDrugs = true;
                string _MinStartDate = "";
                string _MinEndDate = "";
                //Condition is added to set DateInitiated in Medication List to Date Initiated Entered by User 
                // as well as to add data to Medication List if user don't add any information in instruction grid.
                //Condition modified in ref to Task#2934  Non Ordered Meds - Do not require date initiated
                //if (objClientMedication.StartDate != "")
                if (objClientMedication.StartDate != "" && objClientMedication.StartDate != null)
                    _MinStartDate = objClientMedication.StartDate;
                if (objClientMedication.EndDate != "" && objClientMedication.EndDate != null)
                    _MinEndDate = objClientMedication.EndDate;
                //Modified in ref to Task#2934  Non Ordered Meds - Do not require date initiated    
                //else if (objClientMedication.StartDate == "" && objClientMedicationInstructions.Length == 0)
                //    return "Please Enter Date Initiated.";    

                //Case Date Initiated is empty but there is data in Instructions Grid
                //Then check for Startdate in Instructions grid

                else if (objClientMedication.StartDate == "" && objClientMedicationInstructions.Length > 0)
                {


                    foreach (ClientMedicationInstructionRow _row in objClientMedicationInstructions)
                    {
                        if (_row.StartDate != string.Empty)
                        {
                            _NoStartDateInScriptDrugs = false;
                            //Calculate Minimum startDate from clientmedicationScriptDrugs
                            if (_MinStartDate != string.Empty)
                            {
                                if (Convert.ToDateTime(_MinStartDate) > Convert.ToDateTime(_row.StartDate))
                                    _MinStartDate = _row.StartDate;
                            }
                            else
                            {
                                _MinStartDate = _row.StartDate;
                            }
                        }
                    }
                    if (_NoStartDateInScriptDrugs == true)
                        return "Please Enter either Date Initiated or StarDate for Instructions";
                    else
                        DataRowClientMedication["MedicationStartDate"] = Convert.ToDateTime(_MinStartDate);

                }






                //Added By Chandan on 17th March 2008 Task#2377
                //Condition added by Loveena in ref to Task#2934  Non Ordered Meds - Do not require date initiated
                if (_MinStartDate != "")
                    DataRowClientMedication["MedicationStartDate"] = _MinStartDate;
                else if (_MinStartDate == "")
                    DataRowClientMedication["MedicationStartDate"] = DBNull.Value;
                if (_MinEndDate != "")
                    DataRowClientMedication["MedicationEndDate"] = _MinEndDate;
                else
                {
                    DataRowClientMedication["MedicationEndDate"] = DBNull.Value;
                }
                //Added End By Chandan on 17th March 2008 Task#2377

                DataRowClientMedication["MedicationNameId"] = objClientMedication.MedicationNameId;
                //Code Added by Loveena in Ref to Task#79 to set Ordered Field to 'N'
                DataRowClientMedication["Ordered"] = "N";
                //code ends over here.
                DataRowClientMedication["PermitChangesByOtherUsers"] = objClientMedication.PermitChangesByOtherUsers;//Added By Pradeep as per task#31
                //Added by Loveena in Ref to Task# 154 on 07-Jan-2009
                if (objClientMedication.DrugPurpose == string.Empty)
                    DataRowClientMedication["DrugPurpose"] = System.DBNull.Value;
                else
                    DataRowClientMedication["DrugPurpose"] = objClientMedication.DrugPurpose;
                //Code Ends over here.

                //Condition commented by Loveena in ref to task#175 as with this condition on radio button select
                //from Medication List if DrufPurpose is set to Side Effects then null get store in DSMCode 
                //by which selected index -1 get et in Drug Purpose.
                //if (objClientMedication.DSMCode == "-1")
                //    DataRowClientMedication["DSMCode"] = DBNull.Value;    
                //else
                DataRowClientMedication["DSMCode"] = objClientMedication.DSMCode;
                DataRowClientMedication["DSMNumber"] = Convert.ToDecimal(objClientMedication.DSMNumber);
                DataRowClientMedication["DxId"] = (objClientMedication.DxId);
                //Code Added by Loveena in ref to task#154 on 07-Jan-2009.
                if (objClientMedication.PrescriberName == string.Empty)
                {
                    DataRowClientMedication["PrescriberName"] = System.DBNull.Value;
                }
                else
                {
                    DataRowClientMedication["PrescriberName"] = objClientMedication.PrescriberName;
                }
                //Code Added by Loveena ends here.

                if (objClientMedication.PrescriberId == -1 || objClientMedication.PrescriberId == 0)
                    DataRowClientMedication["PrescriberId"] = DBNull.Value;
                else
                    DataRowClientMedication["PrescriberId"] = objClientMedication.PrescriberId;

                if (objClientMedication.RXSource == -1 || objClientMedication.RXSource == 0)
                {
                    DataRowClientMedication["RXSource"] = DBNull.Value;
                }
                else
                {
                    DataRowClientMedication["RXSource"] = objClientMedication.RXSource;
                }

                //Following added by sonia
                //Ref Task # 109 ClientMedications.SpecialInstructions field is updated with blank value 
                //In case value is blank then NULL should be inserted in DB for Special Instructions field
                if (objClientMedication.SpecialInstructions.ToString().Trim() != "")
                    DataRowClientMedication["SpecialInstructions"] = objClientMedication.SpecialInstructions;
                else
                    DataRowClientMedication["SpecialInstructions"] = System.DBNull.Value;
                //code added end over here

                //Code added by Loveena in ref to Task#2433 1.9 Interface Changes to add new fields.
                if (objClientMedication.DesiredOutcome.ToString().Trim() != "")
                    DataRowClientMedication["DesiredOutcomes"] = objClientMedication.DesiredOutcome;
                else
                    DataRowClientMedication["DesiredOutcomes"] = System.DBNull.Value;
                if (objClientMedication.Comments.ToString().Trim() != "")
                    DataRowClientMedication["Comments"] = objClientMedication.Comments;
                else
                    DataRowClientMedication["Comments"] = System.DBNull.Value;
                DataRowClientMedication["OffLabel"] = objClientMedication.OffLabel;
                //Cde added by Loveena ends over here.
                //Code added by Loveena in ref to Task#32
                DataRowClientMedication["IncludeCommentOnPrescription"] = objClientMedication.IncludeCommentOnPrescription;
                //Code ends over here.
                DataRowClientMedication["MedicationName"] = objClientMedication.MedicationName;
                //Code added by Loveena in ref to Task#2590
                DataRowClientMedication["DrugCategory"] = objClientMedication.DrugCategory;
                //Code ends over here.
                DataRowClientMedication["ClientId"] = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId;
                if (newRowCM == true)
                    DataRowClientMedication["RowIdentifier"] = System.Guid.NewGuid();
                if (newRowCM == true)
                    DataRowClientMedication["CreatedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                if (newRowCM == true)
                    DataRowClientMedication["CreatedDate"] = DateTime.Now;
                DataRowClientMedication["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                DataRowClientMedication["ModifiedDate"] = DateTime.Now;
                DataRowClientMedication["RecordDeleted"] = System.DBNull.Value;
                DataRowClientMedication["DeletedBy"] = DBNull.Value;
                DataRowClientMedication["DeletedDate"] = DBNull.Value;
                DataRowClientMedication["MedicationName"] = objClientMedication.MedicationName;
                //Code Commented by Loveena in Ref to Task#79 on 15-Jan-2009 to add DAW column value in Medication List Panel
                //DataRowClientMedication["DAW"] = System.DBNull.Value;
                //Code Commented Ends Here.

                //Code Added by Loveena in Ref to Task#79 on 15-Jan-2009 to add DAW column value in Medication List Panel
                DataRowClientMedication["DAW"] = objClientMedication.DAW;
                //Code Added by Loveena Ends Here.

                if (newRowCM == true)
                    DataTableClientMedications.Rows.Add(DataRowClientMedication);

                //Code added in ref to Task#2590.
                for (int rowindex = 0; rowindex < objClientMedicationInstructions.Length; rowindex++)
                {
                    if (rowindex > 0 && objClientMedication.DrugCategory == "2")
                    {
                        if (Convert.ToDateTime(objClientMedicationInstructions[rowindex].StartDate) != Convert.ToDateTime(objClientMedicationInstructions[0].StartDate))
                            throw new Exception("Not allowed to select different start dates for C2 medications");
                    }
                }



                //For ClientMedicationInstructions
                foreach (ClientMedicationInstructionRow row in objClientMedicationInstructions)
                {
                    // Added on 6/2/2015 by Jason Steczynski, Philhaven Testing Issues Task #553
                    bool isStrengthSpecified = false;

                    DataRow DataRowClientMedInstructions;
                    if (row.RowIdentifierCMI == null || row.RowIdentifierCMI == "")
                        row.RowIdentifierCMI = "-1";
                    DataRow[] temprowidentifierInstructions = DataTableClientMedicationInstructions.Select("RowIdentifier='" + row.RowIdentifierCMI + "'");
                    if (temprowidentifierInstructions.Length > 0)
                    {
                        DataRowClientMedInstructions = temprowidentifierInstructions[0];
                        newRowCMI = false;
                    }
                    else
                    {
                        DataRowClientMedInstructions = DataTableClientMedicationInstructions.NewRow();
                        newRowCMI = true;
                    }

                    DataRowClientMedInstructions["ClientMedicationId"] = DataRowClientMedication["ClientMedicationId"];

                    // Changed on 4/6/2015 by Jason Steczynski, Task #1252, set to Null if value < 1
                    if (row.StrengthId > 0)
                    {
                        DataRowClientMedInstructions["StrengthId"] = row.StrengthId;
                        // Added on 6/2/2015 by Jason Steczynski, Philhaven Testing Issues Task #553
                        isStrengthSpecified = true;
                    }
                    else
                    {
                        DataRowClientMedInstructions["StrengthId"] = System.DBNull.Value;
                    }
                    // end of changes

                    DataRowClientMedInstructions["Quantity"] = row.Quantity;

                    // Changed on 4/6/2015 by Jason Steczynski, Task #1252, set to -1 if value = ""
                    if (row.Unit == "")
                        DataRowClientMedInstructions["Unit"] = -1;
                    else
                    {
                        int Uni;
                        int.TryParse(row.Unit, out Uni);
                        DataRowClientMedInstructions["Unit"] = Uni;
                    }
                    // end of changes


                    if (row.Schedule == "")
                        DataRowClientMedInstructions["Schedule"] = -1;
                    else
                    {
                        int Sch;
                        int.TryParse(row.Schedule, out Sch);
                        DataRowClientMedInstructions["Schedule"] = Sch;
                    }

                    //Modified By Chandan on 17th March 2008 Task#2377
                    if (row.StartDate == "")
                        DataRowClientMedInstructions["StartDate"] = System.DBNull.Value;
                    else
                        DataRowClientMedInstructions["StartDate"] = row.StartDate;
                    if (row.EndDate == "")
                        DataRowClientMedInstructions["EndDate"] = System.DBNull.Value;
                    else
                        DataRowClientMedInstructions["EndDate"] = row.EndDate;

                    if (row.PotencyUnitCode == "")
                        DataRowClientMedInstructions["PotencyUnitCode"] = System.DBNull.Value;
                    else
                        DataRowClientMedInstructions["PotencyUnitCode"] = row.PotencyUnitCode;

                    if (newRowCMI == true)
                        DataRowClientMedInstructions["RowIdentifier"] = System.Guid.NewGuid();
                    if (newRowCMI == true)
                        DataRowClientMedInstructions["CreatedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                    if (newRowCMI == true)
                        DataRowClientMedInstructions["CreatedDate"] = DateTime.Now;
                    DataRowClientMedInstructions["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                    DataRowClientMedInstructions["ModifiedDate"] = DateTime.Now;
                    DataRowClientMedInstructions["Instruction"] = row.Instruction;
                    DataRowClientMedInstructions["Refills"] = row.Refills;
                    if (newRowCMI == true)
                        DataTableClientMedicationInstructions.Rows.Add(DataRowClientMedInstructions);

                    DataRow DatarowClientMedicationScriptDispenseDays;
                    DataRow[] _drtempDispenseDays = DataTableClientMedicationScriptDispenseDays.Select("ClientMedicationInstructionId='" + DataRowClientMedInstructions["ClientMedicationInstructionId"] + "'");
                    DatarowClientMedicationScriptDispenseDays = DataTableClientMedicationScriptDispenseDays.NewRow();

                    if (_drtempDispenseDays.Length > 0)
                    {
                        newRowCMSDD = false;
                        DatarowClientMedicationScriptDispenseDays = _drtempDispenseDays[0];
                    }
                    else
                    {
                        newRowCMSDD = true;
                    }

                    DatarowClientMedicationScriptDispenseDays["ClientMedicationId"] = DataRowClientMedication["ClientMedicationId"];
                    DatarowClientMedicationScriptDispenseDays["ClientMedicationInstructionId"] = DataRowClientMedInstructions["ClientMedicationInstructionId"];
                    DatarowClientMedicationScriptDispenseDays["ClientMedicationScriptId"] = System.DBNull.Value;
                    if (row.NoOfDaysOfWeek != "")
                    {
                        DatarowClientMedicationScriptDispenseDays["DaysOfWeek"] = row.NoOfDaysOfWeek;
                    }

                    if (newRowCMSDD == true)
                    {
                        DatarowClientMedicationScriptDispenseDays["CreatedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                        DatarowClientMedicationScriptDispenseDays["CreatedDate"] = DateTime.Now;
                    }
                    DatarowClientMedicationScriptDispenseDays["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                    DatarowClientMedicationScriptDispenseDays["ModifiedDate"] = DateTime.Now;
                    if (newRowCMSDD == true)
                        DataTableClientMedicationScriptDispenseDays.Rows.Add(DatarowClientMedicationScriptDispenseDays);

                        // Added on 6/2/2015 by Jason Steczynski, Philhaven Testing Issues Task #553
                        if (isStrengthSpecified)
                        {

                            //////Code added by loveena With reference to Task #79

                            DataRow DataRowClientMedicationScriptDrugs;
                            //Added by anuj on 12feb,2010
                            DataRow DataRowClientMedicationScriptDrugStrengths;
                            //ended over here

                            DataRow[] drTempScriptDrug = DataTableClientMedicationScriptDrugs.Select("ClientMedicationInstructionId=" + DataRowClientMedInstructions["ClientMedicationInstructionId"]);
                            if (drTempScriptDrug.Length > 0)
                            {
                                DataRowClientMedicationScriptDrugs = drTempScriptDrug[0];
                                newRowCMSD = false;
                            }
                            else
                            {

                                DataRowClientMedicationScriptDrugs = DataTableClientMedicationScriptDrugs.NewRow();
                                if (DataTableClientMedicationScriptDrugs.Rows.Count > 0)
                                {
                                    int tempcount;

                                    //Ref to Task#2593
                                    //tempcount = Convert.ToInt32(DataTableClientMedicationScriptDrugs.Rows[DataTableClientMedicationScriptDrugs.Rows.Count - 1]["ClientMedicationScriptDrugId"]);
                                    //tempcount = Convert.ToInt32(DataTableClientMedicationScriptDrugs.Compute("Max(ClientMedicationScriptDrugId)", "ISNULL(RecordDeleted,'N')<>'Y'"));
                                    tempcount = Convert.ToInt32(DataTableClientMedicationScriptDrugs.Compute("Max(ClientMedicationScriptDrugId)", ""));
                                    DataRowClientMedicationScriptDrugs["ClientMedicationScriptDrugId"] = tempcount + 1;

                                }

                                newRowCMSD = true;
                            }

                            if (row.StrengthRowIdentifier == null || row.StrengthRowIdentifier == "")
                                row.StrengthRowIdentifier = "-1";
                            DataRow[] temprowidentifierStrengthDrugs = DataTableClientMedicationScriptDrugStrengths.Select("RowIdentifier='" + row.StrengthRowIdentifier + "'");
                            if (temprowidentifierStrengthDrugs.Length > 0)
                            {
                                DataRowClientMedicationScriptDrugStrengths = temprowidentifierStrengthDrugs[0];
                                newRowCMSDS = false;
                            }
                            else
                            {

                                DataRowClientMedicationScriptDrugStrengths = DataTableClientMedicationScriptDrugStrengths.NewRow();
                                if (DataTableClientMedicationScriptDrugStrengths.Rows.Count > 0)
                                {
                                    int tempcount;
                                    if (Session["DataSetPrescribedClientMedications"] != null && _FlagMaxScriptDrugIdSelectedFromPrescribedPage == false)
                                    {
                                        DataSetPrescibedMedications = new DataSet();
                                        DataSetPrescibedMedications = (DataSet)Session["DataSetPrescribedClientMedications"];
                                        tempcount = Convert.ToInt32(DataSetPrescibedMedications.Tables["ClientMedicationScriptDrugStrengths"].Rows[DataSetPrescibedMedications.Tables["ClientMedicationScriptDrugStrengths"].Rows.Count - 1]["ClientMedicationScriptDrugStrengthId"].ToString());
                                        if (tempcount < Convert.ToInt32(DataTableClientMedicationScriptDrugStrengths.Rows[DataTableClientMedicationScriptDrugStrengths.Rows.Count - 1]["ClientMedicationScriptDrugStrengthId"]))
                                        {
                                            tempcount = Convert.ToInt32(DataTableClientMedicationScriptDrugStrengths.Rows[DataTableClientMedicationScriptDrugStrengths.Rows.Count - 1]["ClientMedicationScriptDrugStrengthId"]);
                                        }
                                        _FlagMaxScriptDrugIdSelectedFromPrescribedPage = true;
                                    }
                                    else
                                    {
                                        //tempcount = Convert.ToInt32(DataTableClientMedicationScriptDrugStrengths.Rows[DataTableClientMedicationScriptDrugStrengths.Rows.Count - 1]["ClientMedicationScriptDrugStrengthId"]);
                                        tempcount = Convert.ToInt32(DataTableClientMedicationScriptDrugStrengths.Compute("Max(ClientMedicationScriptDrugStrengthId)", ""));
                                    }

                                    DataRowClientMedicationScriptDrugStrengths["ClientMedicationScriptDrugStrengthId"] = tempcount + 1;

                                }
                                newRowCMSDS = true;
                            }
                            //Ended over here                 

                            DataRowClientMedicationScriptDrugs["ClientMedicationScriptId"] = System.DBNull.Value;
                            DataRowClientMedicationScriptDrugs["ClientMedicationInstructionId"] = DataRowClientMedInstructions["ClientMedicationInstructionId"];
                            if (row.StartDate == "")
                                DataRowClientMedicationScriptDrugs["StartDate"] = DBNull.Value;
                            else
                                DataRowClientMedicationScriptDrugs["StartDate"] = row.StartDate;
                            DataRowClientMedicationScriptDrugs["Days"] = row.Days;
                            //Code added by Loveena in ref to Task#2802                    
                            DataRowClientMedicationScriptDrugs["Pharmacy"] = row.Pharmacy;
                            DataRowClientMedicationScriptDrugs["PharmacyText"] = row.PharmaText;
                            DataRowClientMedicationScriptDrugs["AutoCalcallow"] = row.AutoCalcallow;
                            DataRowClientMedicationScriptDrugs["Sample"] = row.Sample;
                            DataRowClientMedicationScriptDrugs["Stock"] = row.Stock;
                            DataRowClientMedicationScriptDrugs["Refills"] = row.Refills;
                            //Added by Loveena on 06-Jan-2009
                            if (row.EndDate == "")
                                DataRowClientMedicationScriptDrugs["EndDate"] = DBNull.Value;
                            else
                                DataRowClientMedicationScriptDrugs["EndDate"] = row.EndDate;

                            if (objClientMedication.DrugCategory != null && objClientMedication.DrugCategory != String.Empty && objClientMedication.DrugCategory != " ")
                                DataRowClientMedicationScriptDrugs["DrugCategory"] = objClientMedication.DrugCategory;

                            if (row.StartDate != "" && row.EndDate != "")
                            {
                                if (Convert.ToDateTime(DataRowClientMedicationScriptDrugs["EndDate"]) < Convert.ToDateTime(DataRowClientMedicationScriptDrugs["StartDate"]))
                                {

                                    //DataRowClientMedication["MedicationStartDate"] = Convert.ToDateTime(_MedicationStartDate);
                                    //DataRowClientMedication["MedicationEndDate"] = Convert.ToDateTime(_MedicationEndDate);
                                    throw new Exception("End Date should be greater than Start Date");
                                }


                                //Adding minimum startDate in clientmedication
                                if (DataRowClientMedication["MedicationStartDate"] != DBNull.Value)
                                {
                                    if (Convert.ToDateTime(DataRowClientMedication["MedicationStartDate"]) > Convert.ToDateTime(row.StartDate))
                                        DataRowClientMedication["MedicationStartDate"] = row.StartDate;
                                }
                                //Removing the condition as per the Task#2934 Non Ordered Meds - Do not require date initiated
                                //else
                                //{
                                //    DataRowClientMedication["MedicationStartDate"] = row.StartDate;
                                //}

                                //Adding Maximum end date in clientmedication
                                if (DataRowClientMedication["MedicationEndDateForDisplay"] != DBNull.Value)
                                {
                                    if (Convert.ToDateTime(DataRowClientMedication["MedicationEndDateForDisplay"]) > Convert.ToDateTime(row.StartDate))
                                        DataRowClientMedication["MedicationEndDateForDisplay"] = row.StartDate;
                                }
                                else
                                {
                                    DataRowClientMedication["MedicationEndDateForDisplay"] = row.StartDate;
                                }


                                if (DataRowClientMedication["MedicationEndDate"] != DBNull.Value)
                                {
                                    if (Convert.ToDateTime(DataRowClientMedication["MedicationEndDate"]) < Convert.ToDateTime(row.EndDate))
                                        DataRowClientMedication["MedicationEndDate"] = row.EndDate;
                                }
                                //Removing the condition as per the Task#2934 Non Ordered Meds - Do not require date initiated
                                //else
                                //{
                                //    DataRowClientMedication["MedicationEndDate"] = row.EndDate;
                                //}
                            }

                            if (newRowCMSD == true)
                            {
                                DataRowClientMedicationScriptDrugs["RowIdentifier"] = System.Guid.NewGuid();
                                DataRowClientMedicationScriptDrugs["CreatedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                                DataRowClientMedicationScriptDrugs["CreatedDate"] = DateTime.Now;
                            }
                            DataRowClientMedicationScriptDrugs["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                            DataRowClientMedicationScriptDrugs["ModifiedDate"] = DateTime.Now;
                            if (newRowCMSD == true)
                                DataTableClientMedicationScriptDrugs.Rows.Add(DataRowClientMedicationScriptDrugs);

                            ///////Code added end over here

                            //Added By anuj on 15feb,2010
                            DataRowClientMedicationScriptDrugStrengths["ClientMedicationScriptId"] = System.DBNull.Value;
                            DataRowClientMedicationScriptDrugStrengths["Pharmacy"] = row.Pharmacy;
                            DataRowClientMedicationScriptDrugStrengths["PharmacyText"] = row.PharmaText;
                            DataRowClientMedicationScriptDrugStrengths["Sample"] = row.Sample;
                            DataRowClientMedicationScriptDrugStrengths["Stock"] = row.Stock;
                            DataRowClientMedicationScriptDrugStrengths["StrengthId"] = row.StrengthId;
                            DataRowClientMedicationScriptDrugStrengths["ClientMedicationId"] = DataRowClientMedication["ClientMedicationId"];


                            DataRowClientMedicationScriptDrugStrengths["Refills"] = row.Refills;

                            //if (objClientMedication.DrugCategory != null && objClientMedication.DrugCategory != String.Empty && objClientMedication.DrugCategory != " ")
                            //    DataRowClientMedicationScriptDrugs["DrugCategory"] = objClientMedication.DrugCategory;                                                                                              
                            if (newRowCMSDS == true)
                            {
                                DataRowClientMedicationScriptDrugStrengths["RowIdentifier"] = System.Guid.NewGuid();
                                DataRowClientMedicationScriptDrugStrengths["CreatedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                                DataRowClientMedicationScriptDrugStrengths["CreatedDate"] = DateTime.Now;
                            }
                            DataRowClientMedicationScriptDrugStrengths["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                            DataRowClientMedicationScriptDrugStrengths["ModifiedDate"] = DateTime.Now;
                            //Added in ref to Task#85 - SDI - FY 10 - Venture
                            if (newRowCMSDS == true)
                            {
                                bool isExist = false;
                                //if (objClientMedication.DrugCategory != "2")
                                //{
                                if (DataTableClientMedicationScriptDrugStrengths.Rows.Count > 0)
                                {
                                    if (row.AutoCalcallow == "Y")
                                    {
                                        for (int index = 0; index < DataTableClientMedicationScriptDrugStrengths.Rows.Count; index++)
                                        {
                                            if (row.StrengthId == Convert.ToInt32(DataTableClientMedicationScriptDrugStrengths.Rows[index]["StrengthId"]))
                                            {
                                                isExist = true;
                                                DataTableClientMedicationScriptDrugStrengths.Rows[index]["Pharmacy"] = row.Pharmacy + Convert.ToDecimal(DataTableClientMedicationScriptDrugStrengths.Rows[index]["Pharmacy"]);
                                                DataTableClientMedicationScriptDrugStrengths.Rows[index]["Sample"] = row.Sample + Convert.ToDecimal(DataTableClientMedicationScriptDrugStrengths.Rows[index]["Sample"]);
                                                DataTableClientMedicationScriptDrugStrengths.Rows[index]["Stock"] = row.Stock + Convert.ToDecimal(DataTableClientMedicationScriptDrugStrengths.Rows[index]["Stock"]);
                                                DataTableClientMedicationScriptDrugStrengths.Rows[index]["Refills"] = row.Refills + Convert.ToDecimal(DataTableClientMedicationScriptDrugStrengths.Rows[index]["Refills"]);
                                            }
                                        }
                                    }
                                    else if (row.AutoCalcallow == "N")
                                    {
                                        for (int index = 0; index < DataTableClientMedicationScriptDrugStrengths.Rows.Count; index++)
                                        {
                                            if (row.StrengthId == Convert.ToInt32(DataTableClientMedicationScriptDrugStrengths.Rows[index]["StrengthId"]))
                                            {
                                                isExist = true;
                                            }
                                        }
                                    }
                                    if (isExist == false)
                                    {
                                        DataTableClientMedicationScriptDrugStrengths.Rows.Add(DataRowClientMedicationScriptDrugStrengths);
                                    }
                                }
                                else
                                {
                                    DataTableClientMedicationScriptDrugStrengths.Rows.Add(DataRowClientMedicationScriptDrugStrengths);
                                }
                                //}
                                // else
                                //{
                                //DataTableClientMedicationScriptDrugStrengths.Rows.Add(DataRowClientMedicationScriptDrugStrengths);
                                // }
                            }
                            //Code ends over here.

                        } // closing brace for if strengthSpecified

                } //end of for loop of instructions
                if (DataTableClientMedicationInstructions.Columns.Contains("TempRecordDeleted"))
                {
                    foreach (DataRow drDeletedRows in DataTableClientMedicationInstructions.Select("TempRecordDeleted='Y'"))
                    {
                        drDeletedRows["RecordDeleted"] = "Y";
                        drDeletedRows["DeletedDate"] = Convert.ToDateTime(DateTime.Now.ToShortDateString());
                        drDeletedRows["DeletedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;

                    }
                }

                Session["DataSetClientMedications"] = dsClientMedications;
                Session["IsDirty"] = true;
                getDrugInteraction(dsClientMedications);
                //Code added by Loveena in ref to Task#2536 Ordered Medication: Radio button deselects from the Medication list grid 
                Session["SelectedMedicationId"] = null;
                return "";

                //Code Added By Loveena in Ref to Task#79 to make NonOrderedMedication Grid same as Ordered Medication Grid

                #region  Commented Code
                ////DataSet DataSetPrescibedMedications = null;
                ////bool _FlagMaxInstructionIdSelectedFromPrescribedPage = false;
                ////bool _FlagMaxScriptDrugIdSelectedFromPrescribedPage = false;
                ////bool _ValidateSampleStock = false;
                ////string _MedicationStartDate = "";
                ////string _MedicationEndDate = "";


                ////try
                ////{
                ////    bool newRowCM = false;
                ////    bool newRowCMI = false;
                ////    bool newRowCMSD = false;

                ////    Streamline.UserBusinessServices.DataSets.DataSetClientMedications dsClientMedications = null;
                ////    DataTable DataTableClientMedications = null;
                ////    DataTable DataTableClientMedicationInstructions = null;
                ////    DataTable DataTableClientMedicationScriptDrugs = null;
                ////    int iMaxClientMedicationInstructionId = 0;

                ////    if (Session["DataSetClientMedications"] != null)
                ////        dsClientMedications = (Streamline.UserBusinessServices.DataSets.DataSetClientMedications)Session["DataSetClientMedications"];
                ////    else
                ////        dsClientMedications = new Streamline.UserBusinessServices.DataSets.DataSetClientMedications();
                ////    DataTableClientMedications = dsClientMedications.ClientMedications;
                ////    DataTableClientMedicationInstructions = dsClientMedications.ClientMedicationInstructions;
                ////    DataTableClientMedicationScriptDrugs = dsClientMedications.ClientMedicationScriptDrugs;
                ////    //For Client Medication
                ////    if (objClientMedication.RowIdentifierCM == null || objClientMedication.RowIdentifierCM == "")
                ////        objClientMedication.RowIdentifierCM = "-1";
                ////    DataRow[] temprowidentifier = DataTableClientMedications.Select("RowIdentifier='" + objClientMedication.RowIdentifierCM + "'");


                ////    DataRow DataRowClientMedication;
                ////    if (temprowidentifier.Length > 0)
                ////    {
                ////        DataRowClientMedication = temprowidentifier[0];
                ////        newRowCM = false;
                ////    }
                ////    else
                ////    {
                ////        temprowidentifier = DataTableClientMedications.Select("MedicationNameId=" + objClientMedication.MedicationNameId);

                ////        if (temprowidentifier.Length > 0)
                ////        {
                ////            DataRowClientMedication = temprowidentifier[0];
                ////            newRowCM = false;
                ////        }
                ////        else
                ////        {
                ////            DataRowClientMedication = DataTableClientMedications.NewRow();
                ////            newRowCM = true;
                ////        }
                ////    }

                ////    //Code Added by Loveena in Ref to Task#79 on 25-dec-2008.
                ////    //DataRowClientMedication["MedicationStartDate"] = objClientMedication.StartDate;

                ////    //Check if StartDate above grid and Startdates in the grid both are empty then 
                ////    //Error message should be raised

                ////    bool _NoStartDateInScriptDrugs = true;
                ////    string _MinStartDate = "";

                ////    if (objClientMedication.StartDate == string.Empty && objClientMedicationInstructions.Length==0)
                ////        return "Please Enter Date Initiated.";

                ////    //Case Date Initiated is empty but there is data in Instructions Grid
                ////    //Then check for Startdate in Instructions grid

                ////    else if (objClientMedication.StartDate == string.Empty && objClientMedicationInstructions.Length > 0)
                ////    {


                ////        foreach (ClientMedicationInstructionRow _row in objClientMedicationInstructions)
                ////        {
                ////            if (_row.StartDate != string.Empty)
                ////            {
                ////                _NoStartDateInScriptDrugs = false;
                ////                //Calculate Minimum startDate from clientmedicationScriptDrugs
                ////                if (_MinStartDate != string.Empty)
                ////                {
                ////                    if (Convert.ToDateTime(_MinStartDate) > Convert.ToDateTime(_row.StartDate))
                ////                        _MinStartDate = _row.StartDate;
                ////                }
                ////                else
                ////                {
                ////                    _MinStartDate = _row.StartDate;
                ////                }
                ////            }
                ////        }
                ////        if (_NoStartDateInScriptDrugs == true)
                ////            return "Please Enter either Date Initiated or StarDate for Instructions";
                ////        else
                ////            DataRowClientMedication["MedicationStartDate"] = Convert.ToDateTime(_MinStartDate);

                ////    }

                ////    //Check if 



                ////    DataRowClientMedication["MedicationNameId"] = objClientMedication.MedicationNameId;
                ////    DataRowClientMedication["DrugPurpose"] = objClientMedication.DrugPurpose;
                ////    DataRowClientMedication["DSMCode"] = objClientMedication.DSMCode;
                ////    DataRowClientMedication["DSMNumber"] = Convert.ToDecimal(objClientMedication.DSMNumber);
                ////    DataRowClientMedication["DxId"] = (objClientMedication.DxId);
                ////    DataRowClientMedication["PrescriberName"] = objClientMedication.PrescriberName;
                ////    DataRowClientMedication["PrescriberId"] = objClientMedication.PrescriberId;
                ////    DataRowClientMedication["Ordered"] = System.DBNull.Value;

                ////    DataRowClientMedication["MedicationEndDateForDisplay"] = System.DBNull.Value;

                ////    _MedicationEndDate = DataRowClientMedication["MedicationEndDate"].ToString();

                ////    DataRowClientMedication["MedicationEndDate"] = System.DBNull.Value;

                ////    if (objClientMedication.SpecialInstructions.ToString().Trim() != "")
                ////        DataRowClientMedication["SpecialInstructions"] = objClientMedication.SpecialInstructions;
                ////    else
                ////        DataRowClientMedication["SpecialInstructions"] = System.DBNull.Value;

                ////    DataRowClientMedication["MedicationName"] = objClientMedication.MedicationName;
                ////    DataRowClientMedication["ClientId"] = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId;
                ////    if (newRowCM == true)
                ////        DataRowClientMedication["RowIdentifier"] = System.Guid.NewGuid();
                ////    if (newRowCM == true)
                ////        DataRowClientMedication["CreatedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                ////    if (newRowCM == true)
                ////        DataRowClientMedication["CreatedDate"] = DateTime.Now;
                ////    DataRowClientMedication["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                ////    DataRowClientMedication["ModifiedDate"] = DateTime.Now;
                ////    DataRowClientMedication["RecordDeleted"] = System.DBNull.Value;
                ////    DataRowClientMedication["DeletedBy"] = DBNull.Value;
                ////    DataRowClientMedication["DeletedDate"] = DBNull.Value;
                ////    DataRowClientMedication["MedicationName"] = objClientMedication.MedicationName;
                ////    DataRowClientMedication["DAW"] = System.DBNull.Value;
                ////    DataRowClientMedication["DrugCategory"] = objClientMedication.DrugCategory;
                ////    if (newRowCM == true)
                ////        DataTableClientMedications.Rows.Add(DataRowClientMedication);




                ////    _FlagMaxInstructionIdSelectedFromPrescribedPage = false;
                ////    _FlagMaxScriptDrugIdSelectedFromPrescribedPage = false;

                ////    //For ClientMedicationInstructions
                ////    foreach (ClientMedicationInstructionRow row in objClientMedicationInstructions)
                ////    {
                ////        DataRow DataRowClientMedInstructions;
                ////        _ValidateSampleStock = false;
                ////        _ValidateSampleStock = ValidateSampleStock(row.Days, row.Quantity, row.Schedule, row.Sample, row.Stock);

                ////        if (_ValidateSampleStock == false)
                ////        {
                ////            DataRowClientMedication["MedicationStartDate"] = Convert.ToDateTime(_MedicationStartDate);
                ////            DataRowClientMedication["MedicationEndDate"] = Convert.ToDateTime(_MedicationEndDate);
                ////            throw new Exception("Sample + Stock can not be greater than Order Quantity");
                ////        }


                ////        if (row.RowIdentifierCMI == null || row.RowIdentifierCMI == "")
                ////            row.RowIdentifierCMI = "-1";
                ////        DataRow[] temprowidentifierInstructions = DataTableClientMedicationInstructions.Select("RowIdentifier='" + row.RowIdentifierCMI + "'");
                ////        if (temprowidentifierInstructions.Length > 0)
                ////        {
                ////            DataRowClientMedInstructions = temprowidentifierInstructions[0];
                ////            newRowCMI = false;
                ////        }
                ////        else
                ////        {
                ////            DataRowClientMedInstructions = DataTableClientMedicationInstructions.NewRow();
                ////            if (DataTableClientMedicationInstructions.Rows.Count > 0)
                ////            {
                ////                int tempcount = 0;
                ////                Int32 tempCountFromDataSetClientMedications = 0;
                ////                if (Session["DataSetPrescribedClientMedications"] != null && _FlagMaxInstructionIdSelectedFromPrescribedPage == false)
                ////                {
                ////                    //Ref Task #60 MM1.5 Change Medication Order: Medication are not displaying in medication list.
                ////                    //Changes Made to calculate the InstructionId  for newly inserted Rows
                ////                    DataSetPrescibedMedications = new DataSet();
                ////                    DataSetPrescibedMedications = (DataSet)Session["DataSetPrescribedClientMedications"];
                ////                    //tempcount = Convert.ToInt32(DataSetPrescibedMedications.Tables["ClientMedicationInstructions"].Rows[DataSetPrescibedMedications.Tables["ClientMedicationInstructions"].Rows.Count - 1]["ClientMedicationInstructionId"].ToString());
                ////                    if (DataSetPrescibedMedications.Tables["ClientMedicationInstructions"].Rows.Count > 0)
                ////                        tempcount = Convert.ToInt32(DataSetPrescibedMedications.Tables["ClientMedicationInstructions"].Compute("Max(ClientMedicationInstructionId)", ""));
                ////                    if (DataTableClientMedicationInstructions.Rows.Count > 0)
                ////                        tempCountFromDataSetClientMedications = Convert.ToInt32(DataTableClientMedicationInstructions.Compute("Max(ClientMedicationInstructionId)", ""));
                ////                    if (tempcount < tempCountFromDataSetClientMedications)
                ////                    {
                ////                        tempcount = tempCountFromDataSetClientMedications;
                ////                    }
                ////                    else
                ////                    {
                ////                        tempcount = tempcount;
                ////                    }
                ////                    _FlagMaxInstructionIdSelectedFromPrescribedPage = true;
                ////                }
                ////                else
                ////                {
                ////                    //Changes by Sonia
                ////                    //Ref Task #114(Modify Medication: Error message should not be displayed on screen)
                ////                    //While finding Max Instruction Id RecordDeleted check should be skipped
                ////                    if (DataTableClientMedicationInstructions.Rows.Count > 0)
                ////                        tempcount = Convert.ToInt32(DataTableClientMedicationInstructions.Compute("Max(ClientMedicationInstructionId)", ""));
                ////                    //Changes end over here
                ////                    // tempcount = Convert.ToInt32(DataTableClientMedicationInstructions.Rows[DataTableClientMedicationInstructions.Rows.Count - 1]["ClientMedicationInstructionId"]);

                ////                }
                ////                //Changes end over here
                ////                DataRowClientMedInstructions["ClientMedicationInstructionId"] = tempcount + 1;
                ////            }
                ////            newRowCMI = true;
                ////        }

                ////        DataRowClientMedInstructions["ClientMedicationId"] = DataRowClientMedication["ClientMedicationId"];
                ////        DataRowClientMedInstructions["StrengthId"] = row.StrengthId;
                ////        DataRowClientMedInstructions["Quantity"] = row.Quantity;
                ////        DataRowClientMedInstructions["Unit"] = row.Unit;
                ////        DataRowClientMedInstructions["Schedule"] = row.Schedule;
                ////        if (newRowCMI == true)
                ////            DataRowClientMedInstructions["RowIdentifier"] = System.Guid.NewGuid();
                ////        if (newRowCMI == true)
                ////            DataRowClientMedInstructions["CreatedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                ////        if (newRowCMI == true)
                ////            DataRowClientMedInstructions["CreatedDate"] = DateTime.Now;
                ////        DataRowClientMedInstructions["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                ////        DataRowClientMedInstructions["ModifiedDate"] = DateTime.Now;
                ////        DataRowClientMedInstructions["Instruction"] = row.Instruction;

                ////        //Added By chandan
                ////        DataRowClientMedInstructions["StartDate"] =row.StartDate;
                ////        DataRowClientMedInstructions["EndDate"] = row.EndDate;

                ////        if (newRowCMI == true)
                ////            DataTableClientMedicationInstructions.Rows.Add(DataRowClientMedInstructions);

                ////        DataRow DataRowClientMedicationScriptDrugs;

                ////        DataRow[] drTempScriptDrug = DataTableClientMedicationScriptDrugs.Select("ClientMedicationInstructionId=" + DataRowClientMedInstructions["ClientMedicationInstructionId"]);
                ////        if (drTempScriptDrug.Length > 0)
                ////        {
                ////            DataRowClientMedicationScriptDrugs = drTempScriptDrug[0];
                ////            newRowCMSD = false;
                ////        }
                ////        else
                ////        {

                ////            DataRowClientMedicationScriptDrugs = DataTableClientMedicationScriptDrugs.NewRow();
                ////            if (DataTableClientMedicationScriptDrugs.Rows.Count > 0)
                ////            {
                ////                int tempcount;
                ////                if (Session["DataSetPrescribedClientMedications"] != null && _FlagMaxScriptDrugIdSelectedFromPrescribedPage == false)
                ////                {
                ////                    DataSetPrescibedMedications = new DataSet();
                ////                    DataSetPrescibedMedications = (DataSet)Session["DataSetPrescribedClientMedications"];
                ////                    tempcount = Convert.ToInt32(DataSetPrescibedMedications.Tables["ClientMedicationScriptDrugs"].Rows[DataSetPrescibedMedications.Tables["ClientMedicationScriptDrugs"].Rows.Count - 1]["ClientMedicationScriptDrugId"].ToString());
                ////                    if (tempcount < Convert.ToInt32(DataTableClientMedicationScriptDrugs.Rows[DataTableClientMedicationScriptDrugs.Rows.Count - 1]["ClientMedicationScriptDrugId"]))
                ////                    {
                ////                        tempcount = Convert.ToInt32(DataTableClientMedicationScriptDrugs.Rows[DataTableClientMedicationScriptDrugs.Rows.Count - 1]["ClientMedicationScriptDrugId"]);
                ////                    }
                ////                    _FlagMaxScriptDrugIdSelectedFromPrescribedPage = true;
                ////                }
                ////                else
                ////                {
                ////                    tempcount = Convert.ToInt32(DataTableClientMedicationScriptDrugs.Rows[DataTableClientMedicationScriptDrugs.Rows.Count - 1]["ClientMedicationScriptDrugId"]);
                ////                }
                ////                //Ref to Task#79
                ////                //DataRowClientMedicationScriptDrugs["ClientMedicationScriptDrugId"] = tempcount + 1;

                ////            }


                ////            newRowCMSD = true;
                ////        }

                ////        //DataRowClientMedicationScriptDrugs["ClientMedicationScriptId"] = dsClientMedications.Tables["ClientMedicationScripts"].Rows[0]["ClientMedicationScriptId"];
                ////        DataRowClientMedicationScriptDrugs["ClientMedicationScriptId"] = DBNull.Value;
                ////        DataRowClientMedicationScriptDrugs["ClientMedicationInstructionId"] = DataRowClientMedInstructions["ClientMedicationInstructionId"];
                ////        //Added by Loveena on 17-Dec-2008 to remove validations on StartDate
                ////        if (row.StartDate == string.Empty)
                ////        {
                ////            DataRowClientMedicationScriptDrugs["StartDate"] = DBNull.Value;
                ////        }
                ////        else
                ////        {
                ////            DataRowClientMedicationScriptDrugs["StartDate"] = row.StartDate;
                ////        }
                ////        DataRowClientMedicationScriptDrugs["Days"] = row.Days;
                ////        DataRowClientMedicationScriptDrugs["Pharmacy"] = row.Pharmacy;
                ////        DataRowClientMedicationScriptDrugs["Sample"] = row.Sample;
                ////        DataRowClientMedicationScriptDrugs["Stock"] = row.Stock;
                ////        DataRowClientMedicationScriptDrugs["Refills"] = row.Refills;
                ////        //Added by Loveena on 17-Dec-2008 to remove validations on EndDate
                ////        if (row.EndDate == string.Empty || row.StartDate == string.Empty)
                ////        {
                ////            DataRowClientMedicationScriptDrugs["EndDate"] = DBNull.Value;
                ////        }
                ////        else
                ////        {
                ////            DataRowClientMedicationScriptDrugs["EndDate"] = row.EndDate;

                ////        }
                ////        if (objClientMedication.DrugCategory != null && objClientMedication.DrugCategory != String.Empty && objClientMedication.DrugCategory != " ")
                ////            DataRowClientMedicationScriptDrugs["DrugCategory"] = objClientMedication.DrugCategory;
                ////        // else
                ////        //   DataRowClientMedicationScriptDrugs["DrugCategory"] = -1;

                ////        //Added by Loveena on 17-Dec-2008
                ////        if (DataRowClientMedicationScriptDrugs["EndDate"] != DBNull.Value)
                ////        {
                ////            if (Convert.ToDateTime(DataRowClientMedicationScriptDrugs["EndDate"]) < Convert.ToDateTime(DataRowClientMedicationScriptDrugs["StartDate"]))
                ////            {
                ////                DataRowClientMedication["MedicationStartDate"] = Convert.ToDateTime(_MedicationStartDate);
                ////                DataRowClientMedication["MedicationEndDate"] = Convert.ToDateTime(_MedicationEndDate);
                ////                throw new Exception("End Date should be greater than Start Date");
                ////            }
                ////        }
                ////        else
                ////        {
                ////            DataRowClientMedication["MedicationEndDate"] = DBNull.Value;
                ////            DataRowClientMedication["MedicationStartDate"] = DBNull.Value;

                ////        }
                ////        //Code End Here.

                ////        if (DataRowClientMedication["MedicationEndDateForDisplay"] != DBNull.Value)
                ////        {
                ////            if (Convert.ToDateTime(DataRowClientMedication["MedicationEndDateForDisplay"]) > Convert.ToDateTime(row.StartDate))
                ////                DataRowClientMedication["MedicationEndDateForDisplay"] = row.StartDate;
                ////        }
                ////        else
                ////        {
                ////            //DataRowClientMedication["MedicationEndDateForDisplay"] = row.StartDate;
                ////            //Added by Loveena on 17-Dec-2008 to remove Validations on StartDate and EndDate.
                ////            if (row.StartDate == string.Empty)
                ////            {
                ////                DataRowClientMedication["MedicationEndDateForDisplay"] = DBNull.Value;
                ////            }
                ////            else
                ////            {
                ////                if (DataRowClientMedicationScriptDrugs["StartDate"] == DBNull.Value)
                ////                {
                ////                    DataRowClientMedication["MedicationEndDateForDisplay"] = DBNull.Value;                               
                ////                }
                ////                if (DataRowClientMedicationScriptDrugs["StartDate"] != DBNull.Value && DataRowClientMedicationScriptDrugs["EndDate"] == DBNull.Value)
                ////                {
                ////                    DataRowClientMedication["MedicationEndDateForDisplay"] = row.StartDate;                              
                ////                }
                ////                //DataRowClientMedication["MedicationEndDateForDisplay"] = row.StartDate;
                ////            }

                ////        }




                ////        if (DataRowClientMedication["MedicationEndDate"] != DBNull.Value)
                ////        {
                ////            if (Convert.ToDateTime(DataRowClientMedication["MedicationEndDate"]) < Convert.ToDateTime(row.EndDate))
                ////                DataRowClientMedication["MedicationEndDate"] = row.EndDate;
                ////        }
                ////        else
                ////        {
                ////            //Commented by Loveena on 17-Dec-2008 to remove validations on EndDate
                ////            //DataRowClientMedication["MedicationEndDate"] = row.EndDate;
                ////            //Added by Loveena on 17-Dec-2008 to remove validations on EndDate
                ////            DataRowClientMedication["MedicationEndDate"] = DBNull.Value;
                ////        }



                ////        if (newRowCMSD == true)
                ////        {
                ////            DataRowClientMedicationScriptDrugs["RowIdentifier"] = System.Guid.NewGuid();
                ////            DataRowClientMedicationScriptDrugs["CreatedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                ////            DataRowClientMedicationScriptDrugs["CreatedDate"] = DateTime.Now;
                ////        }
                ////        DataRowClientMedicationScriptDrugs["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                ////        DataRowClientMedicationScriptDrugs["ModifiedDate"] = DateTime.Now;
                ////        if (newRowCMSD == true)
                ////            DataTableClientMedicationScriptDrugs.Rows.Add(DataRowClientMedicationScriptDrugs);

                ////    }

                ////    foreach (DataRow drDeletedRows in DataTableClientMedicationInstructions.Select("TempRecordDeleted='Y'"))
                ////    {
                ////        drDeletedRows["RecordDeleted"] = "Y";
                ////        drDeletedRows["DeletedDate"] = Convert.ToDateTime(DateTime.Now.ToShortDateString());
                ////        drDeletedRows["DeletedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;

                ////    }
                ////    //Code added by Sonia
                ////    //Reference Task #56 MM 1.5
                ////    //Prescribers of all Medications needs to be same as of current medications in case its not same as of current Medication being saved
                ////    Int32 _MinPrescriberId = Convert.ToInt32(DataTableClientMedications.Compute("MIN(PrescriberId)", "ISNULL(RecordDeleted,'N')<>'Y'"));
                ////    Int32 _MaxPrescriberId = Convert.ToInt32(DataTableClientMedications.Compute("Max(PrescriberId)", "ISNULL(RecordDeleted,'N')<>'Y'"));
                ////    if (_MinPrescriberId != _MaxPrescriberId)
                ////    {
                ////        foreach (DataRow drClientMedicationRow in DataTableClientMedications.Select("ISNULL(RecordDeleted,'N')<>'Y'"))
                ////        {
                ////            drClientMedicationRow["PrescriberId"] = objClientMedication.PrescriberId;
                ////            drClientMedicationRow["PrescriberName"] = objClientMedication.PrescriberName;
                ////        }
                ////    }



                ////    //Code added end over here

                ////    Session["DataSetClientMedications"] = dsClientMedications;
                ////    Session["IsDirty"] = true;
                ////    getDrugInteraction(dsClientMedications);
                ////    return "";

                #endregion


            }
            catch (Exception ex)
            {
                return ex.Message;
            }
        }



        [WebMethod(EnableSession = true)]
        [GenerateScriptType(typeof(ClientMedicationRow))]
        [GenerateScriptType(typeof(ClientMedicationInstructionRow))]
        public string SaveImportedMedicationRow(ClientMedicationRow objClientMedication, ClientMedicationInstructionRow[] objClientMedicationInstructions, string saveTemplateFlag)
        {

            try
            {
                bool newRowCM = false;
                bool newRowCMI = false;
                bool newRowCMSD = false;
                string _MedicationStartDate = "";
                string _MedicationEndDate = "";
                bool newRowCMSDS = false;
                bool _FlagMaxScriptDrugIdSelectedFromPrescribedPage = false;
                DataSet DataSetPrescibedMedications = null;
                Streamline.UserBusinessServices.DataSets.DataSetClientMedications dsClientMedications = null;
                DataTable DataTableClientMedications = null;
                DataTable DataTableClientMedicationInstructions = null;
                DataTable DataTableClientMedicationScriptDrugs = null;
                DataTable DataTableClientMedicationScriptDrugStrengths = null;

                if (Session["DataSetClientMedications"] != null)
                    dsClientMedications = (Streamline.UserBusinessServices.DataSets.DataSetClientMedications)Session["DataSetClientMedications"];
                else
                    dsClientMedications = new Streamline.UserBusinessServices.DataSets.DataSetClientMedications();
                DataTableClientMedications = dsClientMedications.ClientMedications;
                DataTableClientMedicationInstructions = dsClientMedications.ClientMedicationInstructions;
                DataTableClientMedicationScriptDrugs = dsClientMedications.ClientMedicationScriptDrugs;
                DataTableClientMedicationScriptDrugStrengths = dsClientMedications.ClientMedicationScriptDrugStrengths;
                if (objClientMedication.RowIdentifierCM == null || objClientMedication.RowIdentifierCM == "")
                    objClientMedication.RowIdentifierCM = "-1";
                DataRow[] temprowidentifier = DataTableClientMedications.Select("RowIdentifier='" + objClientMedication.RowIdentifierCM + "'");


                DataRow DataRowClientMedication;
                if (temprowidentifier.Length > 0)
                {
                    DataRowClientMedication = temprowidentifier[0];
                    newRowCM = false;
                }
                else
                {
                    if (temprowidentifier.Length > 0)
                    {
                        DataRowClientMedication = temprowidentifier[0];
                        newRowCM = false;
                    }
                    else
                    {
                        DataRowClientMedication = DataTableClientMedications.NewRow();
                        newRowCM = true;
                    }
                }
                bool _NoStartDateInScriptDrugs = true;
                string _MinStartDate = "";
                string _MinEndDate = "";
                if (objClientMedication.StartDate != "" && objClientMedication.StartDate != null)
                    _MinStartDate = objClientMedication.StartDate;
                if (objClientMedication.EndDate != "" && objClientMedication.EndDate != null)
                    _MinEndDate = objClientMedication.EndDate;
                else if (objClientMedication.StartDate == "" && objClientMedicationInstructions.Length > 0)
                {
                    foreach (ClientMedicationInstructionRow _row in objClientMedicationInstructions)
                    {
                        if (_row.StartDate != string.Empty)
                        {
                            _NoStartDateInScriptDrugs = false;
                            if (_MinStartDate != string.Empty)
                            {
                                if (Convert.ToDateTime(_MinStartDate) > Convert.ToDateTime(_row.StartDate))
                                    _MinStartDate = _row.StartDate;
                            }
                            else
                            {
                                _MinStartDate = _row.StartDate;
                            }
                        }
                    }
                    if (_NoStartDateInScriptDrugs == true)
                        return "Please Enter either Date Initiated or StarDate for Instructions";
                    else
                        DataRowClientMedication["MedicationStartDate"] = Convert.ToDateTime(_MinStartDate);
                }
                if (_MinStartDate != "")
                    DataRowClientMedication["MedicationStartDate"] = _MinStartDate;
                else if (_MinStartDate == "")
                    DataRowClientMedication["MedicationStartDate"] = DBNull.Value;
                if (_MinEndDate != "")
                    DataRowClientMedication["MedicationEndDate"] = _MinEndDate;
                else
                {
                    DataRowClientMedication["MedicationEndDate"] = DBNull.Value;
                }
                if (objClientMedication.MedicationNameId > 0)
                {
                    DataRowClientMedication["MedicationNameId"] = objClientMedication.MedicationNameId;

                }
                else
                {
                    DataRowClientMedication["UserDefinedMedicationNameId"] = objClientMedication.UserDefinedMedicationNameId;
                    DataRowClientMedication["MedicationNameId"] = System.DBNull.Value;
                }
                DataRowClientMedication["Ordered"] = "N";
                DataRowClientMedication["PermitChangesByOtherUsers"] = objClientMedication.PermitChangesByOtherUsers;//Added By Pradeep as per task#31
                if (objClientMedication.DrugPurpose == string.Empty)
                    DataRowClientMedication["DrugPurpose"] = System.DBNull.Value;
                else
                    DataRowClientMedication["DrugPurpose"] = objClientMedication.DrugPurpose;
                DataRowClientMedication["DSMCode"] = objClientMedication.DSMCode;
                DataRowClientMedication["DSMNumber"] = Convert.ToDecimal(objClientMedication.DSMNumber);
                DataRowClientMedication["DxId"] = (objClientMedication.DxId);
                if (objClientMedication.PrescriberName == string.Empty)
                {
                    DataRowClientMedication["PrescriberName"] = System.DBNull.Value;
                }
                else
                {
                    DataRowClientMedication["PrescriberName"] = objClientMedication.PrescriberName;
                }
                if (objClientMedication.PrescriberId == -1 || objClientMedication.PrescriberId == 0)
                    DataRowClientMedication["PrescriberId"] = DBNull.Value;
                else
                    DataRowClientMedication["PrescriberId"] = objClientMedication.PrescriberId;

                if (objClientMedication.RXSource == -1 || objClientMedication.RXSource == 0)
                {
                    DataRowClientMedication["RXSource"] = DBNull.Value;
                }
                else
                {
                    DataRowClientMedication["RXSource"] = objClientMedication.RXSource;
                }
                if (objClientMedication.SpecialInstructions.ToString().Trim() != "")
                    DataRowClientMedication["SpecialInstructions"] = objClientMedication.SpecialInstructions;
                else
                    DataRowClientMedication["SpecialInstructions"] = System.DBNull.Value;
                if (objClientMedication.DesiredOutcome.ToString().Trim() != "")
                    DataRowClientMedication["DesiredOutcomes"] = objClientMedication.DesiredOutcome;
                else
                    DataRowClientMedication["DesiredOutcomes"] = System.DBNull.Value;
                if (objClientMedication.Comments.ToString().Trim() != "")
                    DataRowClientMedication["Comments"] = objClientMedication.Comments;
                else
                    DataRowClientMedication["Comments"] = System.DBNull.Value;
                DataRowClientMedication["OffLabel"] = objClientMedication.OffLabel;
                DataRowClientMedication["IncludeCommentOnPrescription"] = objClientMedication.IncludeCommentOnPrescription;
                DataRowClientMedication["MedicationName"] = objClientMedication.MedicationName;
                DataRowClientMedication["DrugCategory"] = objClientMedication.DrugCategory;
                DataRowClientMedication["ClientId"] = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId;
                if (newRowCM == true)
                    DataRowClientMedication["RowIdentifier"] = System.Guid.NewGuid();
                if (newRowCM == true)
                    DataRowClientMedication["CreatedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                if (newRowCM == true)
                    DataRowClientMedication["CreatedDate"] = DateTime.Now;
                DataRowClientMedication["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                DataRowClientMedication["ModifiedDate"] = DateTime.Now;
                DataRowClientMedication["RecordDeleted"] = System.DBNull.Value;
                DataRowClientMedication["DeletedBy"] = DBNull.Value;
                DataRowClientMedication["DeletedDate"] = DBNull.Value;
                DataRowClientMedication["MedicationName"] = objClientMedication.MedicationName;
                DataRowClientMedication["DAW"] = objClientMedication.DAW;
                if (newRowCM == true)
                    DataTableClientMedications.Rows.Add(DataRowClientMedication);
                for (int rowindex = 0; rowindex < objClientMedicationInstructions.Length; rowindex++)
                {
                    if (rowindex > 0 && objClientMedication.DrugCategory == "2")
                    {
                        if (Convert.ToDateTime(objClientMedicationInstructions[rowindex].StartDate) != Convert.ToDateTime(objClientMedicationInstructions[0].StartDate))
                            throw new Exception("Not allowed to select different start dates for C2 medications");
                    }
                }
                foreach (ClientMedicationInstructionRow row in objClientMedicationInstructions)
                {
                    DataRow DataRowClientMedInstructions;
                    if (row.RowIdentifierCMI == null || row.RowIdentifierCMI == "")
                        row.RowIdentifierCMI = "-1";
                    DataRow[] temprowidentifierInstructions = DataTableClientMedicationInstructions.Select("RowIdentifier='" + row.RowIdentifierCMI + "'");
                    if (temprowidentifierInstructions.Length > 0)
                    {
                        DataRowClientMedInstructions = temprowidentifierInstructions[0];
                        newRowCMI = false;
                    }
                    else
                    {
                        DataRowClientMedInstructions = DataTableClientMedicationInstructions.NewRow();
                        newRowCMI = true;
                    }
                    DataRowClientMedInstructions["ClientMedicationId"] = DataRowClientMedication["ClientMedicationId"];
                    if (row.StrengthId > 0)
                    {
                        DataRowClientMedInstructions["StrengthId"] = row.StrengthId;
                    }
                    else
                    {
                        DataRowClientMedInstructions["UserDefinedMedicationId"] = row.UserDefinedMedicationId;
                        DataRowClientMedInstructions["StrengthId"] = System.DBNull.Value;
                    }
                    DataRowClientMedInstructions["Quantity"] = row.Quantity;
                    DataRowClientMedInstructions["Unit"] = row.Unit;
                    DataRowClientMedInstructions["Schedule"] = row.Schedule;
                    if (row.StartDate == "")
                        DataRowClientMedInstructions["StartDate"] = System.DBNull.Value;
                    else
                        DataRowClientMedInstructions["StartDate"] = row.StartDate;
                    if (row.EndDate == "")
                        DataRowClientMedInstructions["EndDate"] = System.DBNull.Value;
                    else
                        DataRowClientMedInstructions["EndDate"] = row.EndDate;

                    if (row.PotencyUnitCode == "")
                        DataRowClientMedInstructions["PotencyUnitCode"] = System.DBNull.Value;
                    else
                        DataRowClientMedInstructions["PotencyUnitCode"] = row.PotencyUnitCode;

                    if (newRowCMI == true)
                        DataRowClientMedInstructions["RowIdentifier"] = System.Guid.NewGuid();
                    if (newRowCMI == true)
                        DataRowClientMedInstructions["CreatedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                    if (newRowCMI == true)
                        DataRowClientMedInstructions["CreatedDate"] = DateTime.Now;
                    DataRowClientMedInstructions["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                    DataRowClientMedInstructions["ModifiedDate"] = DateTime.Now;
                    DataRowClientMedInstructions["Instruction"] = row.Instruction;
                    if (newRowCMI == true)
                        DataTableClientMedicationInstructions.Rows.Add(DataRowClientMedInstructions);
                    DataRow DataRowClientMedicationScriptDrugs;
                    DataRow DataRowClientMedicationScriptDrugStrengths;

                    DataRow[] drTempScriptDrug = DataTableClientMedicationScriptDrugs.Select("ClientMedicationInstructionId=" + DataRowClientMedInstructions["ClientMedicationInstructionId"]);
                    if (drTempScriptDrug.Length > 0)
                    {
                        DataRowClientMedicationScriptDrugs = drTempScriptDrug[0];
                        newRowCMSD = false;
                    }
                    else
                    {
                        DataRowClientMedicationScriptDrugs = DataTableClientMedicationScriptDrugs.NewRow();
                        if (DataTableClientMedicationScriptDrugs.Rows.Count > 0)
                        {
                            int tempcount;
                            tempcount = Convert.ToInt32(DataTableClientMedicationScriptDrugs.Compute("Max(ClientMedicationScriptDrugId)", "ISNULL(RecordDeleted,'N')<>'Y'"));
                            DataRowClientMedicationScriptDrugs["ClientMedicationScriptDrugId"] = tempcount + 1;
                        }
                        newRowCMSD = true;
                    }
                    if (row.StrengthRowIdentifier == null || row.StrengthRowIdentifier == "")
                        row.StrengthRowIdentifier = "-1";
                    DataRow[] temprowidentifierStrengthDrugs = DataTableClientMedicationScriptDrugStrengths.Select("RowIdentifier='" + row.StrengthRowIdentifier + "'");
                    if (temprowidentifierStrengthDrugs.Length > 0)
                    {
                        DataRowClientMedicationScriptDrugStrengths = temprowidentifierStrengthDrugs[0];
                        newRowCMSDS = false;
                    }
                    else
                    {
                        DataRowClientMedicationScriptDrugStrengths = DataTableClientMedicationScriptDrugStrengths.NewRow();
                        if (DataTableClientMedicationScriptDrugStrengths.Rows.Count > 0)
                        {
                            int tempcount;
                            if (Session["DataSetPrescribedClientMedications"] != null && _FlagMaxScriptDrugIdSelectedFromPrescribedPage == false)
                            {
                                DataSetPrescibedMedications = new DataSet();
                                DataSetPrescibedMedications = (DataSet)Session["DataSetPrescribedClientMedications"];
                                tempcount = Convert.ToInt32(DataSetPrescibedMedications.Tables["ClientMedicationScriptDrugStrengths"].Rows[DataSetPrescibedMedications.Tables["ClientMedicationScriptDrugStrengths"].Rows.Count - 1]["ClientMedicationScriptDrugStrengthId"].ToString());
                                if (tempcount < Convert.ToInt32(DataTableClientMedicationScriptDrugStrengths.Rows[DataTableClientMedicationScriptDrugStrengths.Rows.Count - 1]["ClientMedicationScriptDrugStrengthId"]))
                                {
                                    tempcount = Convert.ToInt32(DataTableClientMedicationScriptDrugStrengths.Rows[DataTableClientMedicationScriptDrugStrengths.Rows.Count - 1]["ClientMedicationScriptDrugStrengthId"]);
                                }
                                _FlagMaxScriptDrugIdSelectedFromPrescribedPage = true;
                            }
                            else
                            {
                                tempcount = Convert.ToInt32(DataTableClientMedicationScriptDrugStrengths.Rows[DataTableClientMedicationScriptDrugStrengths.Rows.Count - 1]["ClientMedicationScriptDrugStrengthId"]);
                            }

                            DataRowClientMedicationScriptDrugStrengths["ClientMedicationScriptDrugStrengthId"] = tempcount + 1;

                        }
                        newRowCMSDS = true;
                    }
                    DataRowClientMedicationScriptDrugs["ClientMedicationScriptId"] = System.DBNull.Value;
                    DataRowClientMedicationScriptDrugs["ClientMedicationInstructionId"] = DataRowClientMedInstructions["ClientMedicationInstructionId"];
                    if (row.StartDate == "")
                        DataRowClientMedicationScriptDrugs["StartDate"] = DBNull.Value;
                    else
                        DataRowClientMedicationScriptDrugs["StartDate"] = row.StartDate;
                    DataRowClientMedicationScriptDrugs["Days"] = row.Days;
                    DataRowClientMedicationScriptDrugs["Pharmacy"] = row.Pharmacy;
                    DataRowClientMedicationScriptDrugs["PharmacyText"] = row.PharmaText;
                    DataRowClientMedicationScriptDrugs["AutoCalcallow"] = row.AutoCalcallow;
                    DataRowClientMedicationScriptDrugs["Sample"] = row.Sample;
                    DataRowClientMedicationScriptDrugs["Stock"] = row.Stock;
                    DataRowClientMedicationScriptDrugs["Refills"] = row.Refills;
                    if (row.EndDate == "")
                        DataRowClientMedicationScriptDrugs["EndDate"] = DBNull.Value;
                    else
                        DataRowClientMedicationScriptDrugs["EndDate"] = row.EndDate;

                    if (objClientMedication.DrugCategory != null && objClientMedication.DrugCategory != String.Empty && objClientMedication.DrugCategory != " ")
                        DataRowClientMedicationScriptDrugs["DrugCategory"] = objClientMedication.DrugCategory;

                    if (row.StartDate != "" && row.EndDate != "")
                    {
                        if (Convert.ToDateTime(DataRowClientMedicationScriptDrugs["EndDate"]) < Convert.ToDateTime(DataRowClientMedicationScriptDrugs["StartDate"]))
                        {
                            throw new Exception("End Date should be greater than Start Date");
                        }
                        if (DataRowClientMedication["MedicationStartDate"] != DBNull.Value)
                        {
                            if (Convert.ToDateTime(DataRowClientMedication["MedicationStartDate"]) > Convert.ToDateTime(row.StartDate))
                                DataRowClientMedication["MedicationStartDate"] = row.StartDate;
                        }
                        if (DataRowClientMedication["MedicationEndDateForDisplay"] != DBNull.Value)
                        {
                            if (Convert.ToDateTime(DataRowClientMedication["MedicationEndDateForDisplay"]) > Convert.ToDateTime(row.StartDate))
                                DataRowClientMedication["MedicationEndDateForDisplay"] = row.StartDate;
                        }
                        else
                        {
                            DataRowClientMedication["MedicationEndDateForDisplay"] = row.StartDate;
                        }


                        if (DataRowClientMedication["MedicationEndDate"] != DBNull.Value)
                        {
                            if (Convert.ToDateTime(DataRowClientMedication["MedicationEndDate"]) < Convert.ToDateTime(row.EndDate))
                                DataRowClientMedication["MedicationEndDate"] = row.EndDate;
                        }
                    }

                    if (newRowCMSD == true)
                    {
                        DataRowClientMedicationScriptDrugs["RowIdentifier"] = System.Guid.NewGuid();
                        DataRowClientMedicationScriptDrugs["CreatedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                        DataRowClientMedicationScriptDrugs["CreatedDate"] = DateTime.Now;
                    }
                    DataRowClientMedicationScriptDrugs["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                    DataRowClientMedicationScriptDrugs["ModifiedDate"] = DateTime.Now;
                    if (newRowCMSD == true)
                        DataTableClientMedicationScriptDrugs.Rows.Add(DataRowClientMedicationScriptDrugs);
                    DataRowClientMedicationScriptDrugStrengths["ClientMedicationScriptId"] = System.DBNull.Value;
                    DataRowClientMedicationScriptDrugStrengths["Pharmacy"] = row.Pharmacy;
                    DataRowClientMedicationScriptDrugStrengths["PharmacyText"] = row.PharmaText;
                    DataRowClientMedicationScriptDrugStrengths["Sample"] = row.Sample;
                    DataRowClientMedicationScriptDrugStrengths["Stock"] = row.Stock;
                    if (row.StrengthId > 0)
                    {
                        DataRowClientMedicationScriptDrugStrengths["StrengthId"] = row.StrengthId;
                    }
                    else
                    {
                        DataRowClientMedicationScriptDrugStrengths["UserDefinedMedicationId"] = row.UserDefinedMedicationId;
                        DataRowClientMedicationScriptDrugStrengths["StrengthId"] = System.DBNull.Value;
                    }
                    
                    DataRowClientMedicationScriptDrugStrengths["ClientMedicationId"] = DataRowClientMedication["ClientMedicationId"];


                    DataRowClientMedicationScriptDrugStrengths["Refills"] = row.Refills;
                    if (newRowCMSDS == true)
                    {
                        DataRowClientMedicationScriptDrugStrengths["RowIdentifier"] = System.Guid.NewGuid();
                        DataRowClientMedicationScriptDrugStrengths["CreatedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                        DataRowClientMedicationScriptDrugStrengths["CreatedDate"] = DateTime.Now;
                    }
                    DataRowClientMedicationScriptDrugStrengths["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                    DataRowClientMedicationScriptDrugStrengths["ModifiedDate"] = DateTime.Now;
                    if (newRowCMSDS == true)
                    {
                        bool isExist = false;
                        if (DataTableClientMedicationScriptDrugStrengths.Rows.Count > 0)
                        {
                            if (row.AutoCalcallow == "Y")
                            {
                                for (int index = 0; index < DataTableClientMedicationScriptDrugStrengths.Rows.Count; index++)
                                {
                                    if (row.StrengthId == Convert.ToInt32(DataTableClientMedicationScriptDrugStrengths.Rows[index]["StrengthId"]))
                                    {
                                        isExist = true;
                                        DataTableClientMedicationScriptDrugStrengths.Rows[index]["Pharmacy"] = row.Pharmacy + Convert.ToDecimal(DataTableClientMedicationScriptDrugStrengths.Rows[index]["Pharmacy"]);
                                        DataTableClientMedicationScriptDrugStrengths.Rows[index]["Sample"] = row.Sample + Convert.ToDecimal(DataTableClientMedicationScriptDrugStrengths.Rows[index]["Sample"]);
                                        DataTableClientMedicationScriptDrugStrengths.Rows[index]["Stock"] = row.Stock + Convert.ToDecimal(DataTableClientMedicationScriptDrugStrengths.Rows[index]["Stock"]);
                                        DataTableClientMedicationScriptDrugStrengths.Rows[index]["Refills"] = row.Refills + Convert.ToDecimal(DataTableClientMedicationScriptDrugStrengths.Rows[index]["Refills"]);
                                    }
                                }
                            }
                            else if (row.AutoCalcallow == "N")
                            {
                                for (int index = 0; index < DataTableClientMedicationScriptDrugStrengths.Rows.Count; index++)
                                {
                                    if (row.StrengthId == Convert.ToInt32(DataTableClientMedicationScriptDrugStrengths.Rows[index]["StrengthId"]))
                                    {
                                        isExist = true;
                                    }
                                }
                            }
                            if (isExist == false)
                            {
                                DataTableClientMedicationScriptDrugStrengths.Rows.Add(DataRowClientMedicationScriptDrugStrengths);
                            }
                        }
                        else
                        {
                            DataTableClientMedicationScriptDrugStrengths.Rows.Add(DataRowClientMedicationScriptDrugStrengths);
                        }
                    }
                } //end of for loop of instructions
                if (DataTableClientMedicationInstructions.Columns.Contains("TempRecordDeleted"))
                {
                    foreach (DataRow drDeletedRows in DataTableClientMedicationInstructions.Select("TempRecordDeleted='Y'"))
                    {
                        drDeletedRows["RecordDeleted"] = "Y";
                        drDeletedRows["DeletedDate"] = Convert.ToDateTime(DateTime.Now.ToShortDateString());
                        drDeletedRows["DeletedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;

                    }
                }

                Session["DataSetClientMedications"] = dsClientMedications;
                Session["IsDirty"] = true;
                Session["SelectedMedicationId"] = null;
                return "";
            }
            catch (Exception ex)
            {
                return ex.Message;
            }
        }

        private void getDrugInteraction(Streamline.UserBusinessServices.DataSets.DataSetClientMedications dsTemp)
        {

            try
            {
                CommonFunctions.Event_Trap(this);
                string MedicationIds = "";
                //Getting all MedicationIds to check for interactions
                foreach (DataRow dr in dsTemp.ClientMedicationInstructions.Select("isnull(Recorddeleted,'N')<>'Y'"))
                {
                    if (string.IsNullOrEmpty(dr["StrengthId"].ToString()) == false)
                        MedicationIds += dr["StrengthId"].ToString() + ",";
                }
                //Added by Sonia
                //Ref Task #82
                //Changes made to display interactions between medications being ordered with medications in main page
                if (Session["DataSetClientSummary"] != null)
                {
                    using (DataSet dsSetClientSummary = (DataSet)Session["DataSetClientSummary"])
                    {

                        foreach (DataRow dr1 in dsSetClientSummary.Tables["ClientMedications"].Select("isnull(Recorddeleted,'N')<>'Y' and isnull(Discontinued,'N')<>'Y' "))
                        {
                            if (dr1 != null)
                            {
                                foreach (DataRow dr2 in dsSetClientSummary.Tables["ClientMedicationInstructions"].Select("isnull(Recorddeleted,'N')<>'Y' and ClientMedicationId = ' " + dr1["ClientMedicationId"].ToString() + "' "))
                                {
                                    if (string.IsNullOrEmpty(dr2["StrengthId"].ToString()) == false)
                                        MedicationIds += dr2["StrengthId"].ToString() + ",";
                                }
                            }
                        }
                    }
                }
                //Changes end over here


                if (MedicationIds.Length > 1)
                    MedicationIds = MedicationIds.TrimEnd(',');

                if (MedicationIds.Length > 1)
                {

                    Streamline.UserBusinessServices.ClientMedication objClientMed = new Streamline.UserBusinessServices.ClientMedication();

                    DataSet dsTempInteraction = objClientMed.GetClientMedicationDrugInteraction(MedicationIds, ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId, ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId);
                    if (dsTempInteraction.Tables.Count > 0)
                    {
                        createClientMedicationInteraction(dsTempInteraction);
                        Streamline.UserBusinessServices.DataSets.DataSetClientMedications dsClientMedicationsTemp = (Streamline.UserBusinessServices.DataSets.DataSetClientMedications)Session["DataSetClientMedications"];
                        dsClientMedicationsTemp.ClientAllergiesInteraction.Merge(dsTempInteraction.Tables["ClientAllergyInteraction"]);
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
                throw (ex);

            }
        }

        private void createClientMedicationInteraction(DataSet dsInteraction)
        {

            try
            {
                DataView dvTemp = new DataView(dsInteraction.Tables["ClientMedicationInteraction"]);
                dvTemp.RowFilter = "DrugInteractionMonographid >0";
                //Loops through the Interactions returned from the Stored Procedure
                for (int i = 0; i < dvTemp.Count; i++)
                {
                    DataRow[] drTemp = dsInteraction.Tables["ClientMedicationInteraction"].Select("DrugInteractionMonographid=" + dvTemp[i]["DrugInteractionMonographid"].ToString(), " MedicationId");
                    getInteractionRows(drTemp);
                    //Removes Duplicate DrugInteractionMonographIds
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

        private void getInteractionRows(DataRow[] drTemp)
        {

            try
            {
                Streamline.UserBusinessServices.DataSets.DataSetClientMedications dsClientMedications = (Streamline.UserBusinessServices.DataSets.DataSetClientMedications)Session["DataSetClientMedications"];
                int ClientMedicationInteractionId = 0;
                CommonFunctions.Event_Trap(this);
                //Added by Sonia
                //Ref Task #82
                //Changes made to display interactions between medications being ordered with medications in main page

                string ClientMedicationId1Name = "";
                string ClientMedicationId2Name = "";
                //End by Sonia

                for (int i = 0; i < drTemp.Length; i++)//Takes the first id and makes possible combination with all the rest of the ids
                {
                    if (!drTemp[i]["SeverityLevel"].ToString().IsNullOrWhiteSpace())
                    {
                        int MedicationId1 = 0;
                        int MedicationId2 = 0;
                        int k = i + 1;
                        for (; k < drTemp.Length; k++)
                        {
                            if (dsClientMedications.ClientMedicationInteractions.Rows.Count > 0)
                                ClientMedicationInteractionId = Convert.ToInt32(dsClientMedications.ClientMedicationInteractions.Compute("MAX(ClientmedicationInteractionId)", ""));

                            //Get both the Interacting MedicationId from the Instructions table 
                            DataRow[] ClientMedication1 = dsClientMedications.ClientMedicationInstructions.Select("StrengthId=" + drTemp[i]["MedicationId"] + " and isnull(recorddeleted,'N')<>'Y'");

                            //Added by Sonia
                            //Ref Task #82
                            //Changes made to display interactions between medications being ordered with medications in main page

                            if (ClientMedication1.Length <= 0)
                            {
                                if (Session["DataSetClientSummary"] != null)
                                {
                                    using (DataSet dsSetClientSummary = (DataSet)Session["DataSetClientSummary"])
                                    {
                                        ClientMedication1 = dsSetClientSummary.Tables["ClientMedicationInstructions"].Select("StrengthId=" + drTemp[i]["MedicationId"] + " and isnull(recorddeleted,'N')<>'Y'");
                                    }
                                }
                            }

                            if (ClientMedication1.Length > 0)
                            {
                                MedicationId1 = Convert.ToInt32(ClientMedication1[0]["ClientMedicationId"]);
                                //Added By Sonia 
                                //Ref Task #82
                                //Changes made to display interactions between medications being ordered with medications in main page

                                ClientMedicationId1Name = ClientMedication1[0]["MedicationName"].ToString();
                                if (ClientMedicationId1Name == string.Empty)
                                {
                                    DataRow[] _drClientMedicationName1 = dsClientMedications.ClientMedications.Select("ClientMedicationId=" + MedicationId1 + " and isnull(RecordDeleted,'N')<>'Y'");
                                    ClientMedicationId1Name = _drClientMedicationName1[0]["MedicationName"].ToString();
                                }
                                //Added End By Chandan on 19th Nov 2008
                            }

                            DataRow[] ClientMedication2 = dsClientMedications.ClientMedicationInstructions.Select("StrengthId=" + drTemp[k]["MedicationId"] + " and isnull(recorddeleted,'N')<>'Y'");
                            //Added by Sonia
                            //Ref Task #82
                            //Changes made to display interactions between medications being ordered with medications in main page

                            if (ClientMedication2.Length <= 0)
                            {
                                using (DataSet dsSetClientSummary = (DataSet)Session["DataSetClientSummary"])
                                {
                                    // dsSetClientSummary = (DataSet)Session["DataSetClientSummary"];
                                    ClientMedication2 = dsSetClientSummary.Tables["ClientMedicationInstructions"].Select("StrengthId=" + drTemp[k]["MedicationId"] + " and isnull(recorddeleted,'N')<>'Y'");

                                }
                            }
                            //code added end over here
                            if (ClientMedication2.Length > 0)
                            {
                                MedicationId2 = Convert.ToInt32(ClientMedication2[0]["ClientMedicationId"]);
                                //Added By Sonia
                                //Ref Task #82
                                //Changes made to display interactions between medications being ordered with medications in main page

                                ClientMedicationId2Name = ClientMedication2[0]["MedicationName"].ToString();
                                if (ClientMedicationId2Name == string.Empty)
                                {
                                    DataRow[] _drClientMedicationName2 = dsClientMedications.ClientMedications.Select("ClientMedicationId=" + MedicationId2 + " and isnull(RecordDeleted,'N')<>'Y'");
                                    ClientMedicationId2Name = _drClientMedicationName2[0]["MedicationName"].ToString();
                                }
                                //Changes end over here

                            }
                            if (MedicationId1 != MedicationId2)
                            {
                                Streamline.UserBusinessServices.DataSets.DataSetClientMedications.ClientMedicationInteractionsRow[] drExists = null;
                                //Check if there is already a row in the interaction table in dataset with same MedicationNameIds 
                                //and Interactionlevel < than the current level that is in the loop 
                                string Query = "((MedicationNameId1=" + drTemp[i]["MedicationId"] + " and MedicationNameId2=" + drTemp[k]["MedicationId"] + ") or (MedicationNameId2=" + drTemp[i]["MedicationId"] + " and MedicationNameId1=" + drTemp[k]["MedicationId"] + "))";
                                Query += " and InteractionLevel<=" + Convert.ToInt32(drTemp[i]["SeverityLevel"]);
                                Query += " and isnull(recorddeleted,'N')<>'Y'";
                                //Query += " and ClientMedicationId1<>ClientMedicationId2";

                                //drExists = (Streamline.UserBusinessServices.DataSets.DataSetClientMedications.ClientMedicationInteractionsRow[])dsClientMedications.ClientMedicationInteractions.Select(Query);

                                bool newRow = false;
                                bool modifyrow = false;
                                drExists = (Streamline.UserBusinessServices.DataSets.DataSetClientMedications.ClientMedicationInteractionsRow[])dsClientMedications.ClientMedicationInteractions.Select(Query);
                                Streamline.UserBusinessServices.DataSets.DataSetClientMedications.ClientMedicationInteractionsRow drInteraction = null;
                                //If there exists a row and the interactionlevel > than the current interactionlevel in the loop
                                //Modify the row
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
                                //If any newrow or modifiedrow exists add/modify to the Interactions table in the dataset
                                if (newRow == true || modifyrow == true)
                                {
                                    //Added by sonia
                                    //Ref Task #82 MM
                                    //New ClientMedicationInteractionId should be assigned to new row being added to ClientMedicationInteractions
                                    if (newRow == true)
                                    {
                                        drInteraction = dsClientMedications.ClientMedicationInteractions.NewClientMedicationInteractionsRow();
                                        drInteraction.ClientMedicationInteractionId = ClientMedicationInteractionId + 1;
                                    }
                                    //ended by sonia
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

                                    //Added by Sonia
                                    //Ref Task #82
                                    //Changes made to display interactions between medications being ordered with medications in main page
                                    drInteraction.ClientMedicationId1Name = ClientMedicationId1Name;
                                    drInteraction.ClientMedicationId2Name = ClientMedicationId2Name;
                                    //End By Sonia


                                    drInteraction.PrescriberAcknowledgementRequired = "Y";
                                    if (newRow)
                                    {
                                        //Added by sonia
                                        //Ref Task #82
                                        //New row should be added only if both clientMedications exists in this order
                                        DataRow _dr1 = dsClientMedications.ClientMedications.FindByClientMedicationId(drInteraction.ClientMedicationId1);
                                        DataRow _dr2 = dsClientMedications.ClientMedications.FindByClientMedicationId(drInteraction.ClientMedicationId2);
                                        if (_dr1 != null || _dr2 != null)
                                            dsClientMedications.ClientMedicationInteractions.Rows.Add(drInteraction);
                                        //Ended by sonia
                                    }
                                    ClientMedicationInteractionId = drInteraction.ClientMedicationInteractionId;
                                }



                                //Added into ClientMedicationInteractionDetails
                                bool newDetailsRow = false;
                                DataRow drClientMedicationDetail = null;

                                //Added by Sonia
                                //Ref Task #82
                                //Changes made to display interactions between medications being ordered with medications in main page
                                //if condition added by sonia
                                //New row to be added only if there does't exist any row with ClientMedicationInteractionId
                                if (dsClientMedications.ClientMedicationInteractions.FindByClientMedicationInteractionId(ClientMedicationInteractionId) != null)
                                {
                                    DataRow[] DetailsExists = dsClientMedications.ClientMedicationInteractionDetails.Select("ClientMedicationInteractionId=" + ClientMedicationInteractionId + "and DrugDrugInteractionId=" + Convert.ToInt32(drTemp[i]["DrugDrugInteractionId"]) + " and isnull(recorddeleted,'N')<>'Y'");
                                    if (DetailsExists.Length > 0)
                                    {
                                        drClientMedicationDetail = DetailsExists[0];
                                        drClientMedicationDetail["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                                        drClientMedicationDetail["ModifiedDate"] = DateTime.Now;
                                        newDetailsRow = false;
                                    }
                                    else
                                    {
                                        drClientMedicationDetail = dsClientMedications.ClientMedicationInteractionDetails.NewRow();
                                        newDetailsRow = true;
                                    }

                                    if (newDetailsRow == true)
                                    {
                                        drClientMedicationDetail["ClientMedicationInteractionId"] = ClientMedicationInteractionId;
                                        drClientMedicationDetail["DrugDrugInteractionId"] = drTemp[i]["DrugDrugInteractionId"];
                                        drClientMedicationDetail["InteractionDescription"] = drTemp[i]["InteractionDescription"];
                                        drClientMedicationDetail["InteractionLevel"] = drTemp[i]["SeverityLevel"];
                                        drClientMedicationDetail["DrugInteractionMonographId"] = Convert.ToInt32(drTemp[i]["DrugInteractionMonographId"]);
                                        drClientMedicationDetail["RowIdentifier"] = System.Guid.NewGuid().ToString();
                                        drClientMedicationDetail["CreatedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                                        drClientMedicationDetail["CreatedDate"] = DateTime.Now;
                                        drClientMedicationDetail["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                                        drClientMedicationDetail["ModifiedDate"] = DateTime.Now;
                                        dsClientMedications.ClientMedicationInteractionDetails.Rows.Add(drClientMedicationDetail);
                                    }
                                    //                   if (newDetailsRow)
                                    //                      dsClientMedications.ClientMedicationInteractionDetails.Rows.Add(drClientMedicationDetail);
                                } // End of If condition added for checking existence of DataRow interaction
                            }//End of If condition where MedicationId1 != MedicationId2
                        }//End of K loop
                    }//End of I loop
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

        //Code Added by Loveena in Ref to Task#79 on 28 Nov 2008 to set the MedicationNonOrderedGrid as Ordered Grid
        [WebMethod(EnableSession = true)]
        public bool ValidateSampleStock(int days, Decimal Quantity, String Schedule, Decimal Sample, Decimal Stock)
        {
            try
            {
                float _GlobalCodeMedicationScheduleExternalCode = 0;
                Decimal OrderQty;
                DataRow[] DataRowGlobalCodeMedicationSchedule = Streamline.UserBusinessServices.SharedTables.DataSetGlobalCodes.Tables[0].Select("Category='MEDICATIONSCHEDULE' and GlobalCodeId=" + Schedule.ToString());
                if (DataRowGlobalCodeMedicationSchedule != null)
                    if (DataRowGlobalCodeMedicationSchedule[0]["ExternalCode1"].ToString() == "")
                        _GlobalCodeMedicationScheduleExternalCode = 0;
                    else
                        _GlobalCodeMedicationScheduleExternalCode = (float)Convert.ToDouble(DataRowGlobalCodeMedicationSchedule[0]["ExternalCode1"].ToString());
                else
                    _GlobalCodeMedicationScheduleExternalCode = 1;


                OrderQty = Math.Round(Convert.ToDecimal((float)(Quantity) * (float)(days) * (float)(_GlobalCodeMedicationScheduleExternalCode)), 2);
                if ((Sample + Stock) > OrderQty)
                    return false;
                else
                    return true;




            }
            catch (Exception ex)
            {
                return false;
            }
        }


        [WebMethod(EnableSession = true)]
        public DataSet RadioButtonClick(int selectedMedicationId)
        {
            #region CommnetedCodeNotInUse
            /*  Streamline.UserBusinessServices.DataSets.DataSetClientMedications dsClientMedications = null;
            DataTable _DataTableClientMedications = null;
            DataTable _DataTableClientMedicationInstructions = null;
            if (Session["DataSetClientMedications"] != null)
                dsClientMedications = (Streamline.UserBusinessServices.DataSets.DataSetClientMedications)Session["DataSetClientMedications"];
            else
                dsClientMedications = new Streamline.UserBusinessServices.DataSets.DataSetClientMedications();

            _DataTableClientMedications = dsClientMedications.ClientMedications;
            _DataTableClientMedicationInstructions = dsClientMedications.ClientMedicationInstructions;

            DataRow[] drClientMedicationInstruction = _DataTableClientMedicationInstructions.Select("IsNull(RecordDeleted,'N')<>'Y' And ClientMedicationId=" + selectedMedicationId);
            DataRow[] drClientMedication = _DataTableClientMedications.Select("IsNull(RecordDeleted,'N')<>'Y' And ClientMedicationId=" + selectedMedicationId);
            DataSet dsTemp = new DataSet("ClientMedication");
            dsTemp.Merge(drClientMedication);
            dsTemp.Merge(drClientMedicationInstruction);
            return dsTemp;*/
            #endregion


            //Changes with Ref To Task #79
            Streamline.UserBusinessServices.DataSets.DataSetClientMedications dsClientMedications = null;
            DataTable _DataTableClientMedications = null;
            DataTable _DataTableClientMedicationInstructions = null;
            DataTable _DataTableClientMedicationScriptDrugs = null;
            DataTable _DataTableClientMedicationScriptDispenseDays = null;
            try
            {

                if (Session["DataSetClientMedications"] != null)
                    dsClientMedications = (Streamline.UserBusinessServices.DataSets.DataSetClientMedications)Session["DataSetClientMedications"];
                else
                    dsClientMedications = new Streamline.UserBusinessServices.DataSets.DataSetClientMedications();

                _DataTableClientMedications = dsClientMedications.ClientMedications;
                _DataTableClientMedicationInstructions = dsClientMedications.ClientMedicationInstructions;
                _DataTableClientMedicationScriptDrugs = dsClientMedications.ClientMedicationScriptDrugs;
                _DataTableClientMedicationScriptDispenseDays = dsClientMedications.ClientMedicationScriptDispenseDays;

                DataRow[] drClientMedicationInstruction = _DataTableClientMedicationInstructions.Select("IsNull(RecordDeleted,'N')<>'Y' And ClientMedicationId=" + selectedMedicationId, "ClientMedicationInstructionId");
                DataRow[] drClientMedication = _DataTableClientMedications.Select("IsNull(RecordDeleted,'N')<>'Y' And ClientMedicationId=" + selectedMedicationId);
                DataRow[] drClientMedicationScriptDispenseDays = _DataTableClientMedicationScriptDispenseDays.Select("IsNull(RecordDeleted,'N')<>'Y' And ClientMedicationId=" + selectedMedicationId, "ClientMedicationInstructionId");

                DataSet dsTemp = new DataSet("ClientMedication");
                dsTemp.Merge(drClientMedication);
                dsTemp.Merge(drClientMedicationInstruction);

                foreach (DataRow drTemp in drClientMedicationInstruction)
                {
                    DataRow[] drClientMedicationScriptDrugs = _DataTableClientMedicationScriptDrugs.Select("IsNull(RecordDeleted,'N')<>'Y' And ClientMedicationInstructionId=" + drTemp["ClientMedicationInstructionId"].ToString(), "ClientMedicationInstructionId");
                    if (drClientMedicationScriptDrugs.Length > 0)
                        if (dsTemp.Tables.Contains("ClientMedicationScriptDrugs"))
                        {

                            dsTemp.Tables["ClientMedicationScriptDrugs"].ImportRow(drClientMedicationScriptDrugs[0]);

                        }
                        else
                        {
                            dsTemp.Merge(drClientMedicationScriptDrugs);
                        }
                }

                dsTemp.Merge(drClientMedicationScriptDispenseDays);
                //Code added by Loveena in ref to Task#2536 Ordered Medication: Radio button deselects from the Medication list grid 
                Session["SelectedMedicationId"] = selectedMedicationId;
                return dsTemp;
            }
            catch (Exception ex)
            {

                return null;
            }
            finally
            {
                dsClientMedications.Dispose();

            }

        }


        /// <summary>Created By Chandan 
        /// Task #74 MM#1.7 Dynamic Grid List
        /// </summary>
        /// <returns></returns>
        [WebMethod(EnableSession = true)]
        public System.Web.UI.Pair CreateControls(string TableRowIndex, string txtButtonValue, string txtStartDate)
        {

            System.Web.UI.Pair pairResult = new Pair();
            string _strTableHtml = "";
            int RowIndex = Convert.ToInt32(TableRowIndex);
            try
            {
                CommonFunctions.Event_Trap(this);
                Table tableControls = new Table();
                tableControls.Width = new Unit(90, UnitType.Percentage);
                tableControls.ID = "tableMedicationOrder";
                string myscript = "";
                //Code modified by Anuj  in ref to Task# 22 FY10 - Venture - Add Medication Layout Optimizations 
                //for (int _RowCount = RowIndex; _RowCount < (RowIndex + 4); _RowCount++)
                //    {
                //    tableControls.Rows.Add(CreateMedicationRow(_RowCount, ref myscript, txtButtonValue, txtStartDate));
                //    }
                for (int _RowCount = RowIndex; _RowCount < (RowIndex + 2); _RowCount++)
                {
                    tableControls.Rows.Add(CreateMedicationRow(_RowCount, ref myscript, txtButtonValue, txtStartDate));
                }

                StringBuilder sb = new StringBuilder();
                using (StringWriter sw = new StringWriter(sb))
                {
                    using (HtmlTextWriter textWriter = new HtmlTextWriter(sw))
                    {
                        tableControls.RenderControl(textWriter);
                    }
                }
                _strTableHtml = sb.ToString();
                pairResult.First = _strTableHtml = _strTableHtml.Substring(66, _strTableHtml.Length - 76);
                pairResult.Second = myscript;

                return pairResult;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "";
                else
                    ex.Data["CustomExceptionInformation"] = "";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = "";
                return null;
                //Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);

            }
            finally
            {
            }
        }


        /// <summary>Created By Chandan 
        /// Task #74 MM#1.7 Dynamic Grid List 
        /// Creating new rows dynamically
        /// </summary>
        /// <returns></returns>
        [WebMethod(EnableSession = true)]
        private TableRow CreateMedicationRow(int rowIndex, ref string myscript, string textboxButtonValue, string TextBoxStartDate)
        {
            try
            {

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
                //Ref to Task#2802
                TableCell _TableCell14 = new TableCell();
                TableCell _TableCell15 = new TableCell();
                TableCell _TableCell16 = new TableCell();

                _Table.ID = "TableMedication" + rowIndex;


                HtmlImage _ImgDeleteRow = new HtmlImage();
                _ImgDeleteRow.ID = "Control_ASP.usercontrols_clientmedicationnonorder_ascx_ImageDelete" + rowIndex;
                _ImgDeleteRow.Src = WebsiteSettings.BaseUrl + "./App_Themes/Includes/Images/deleteIcon.gif";
                _ImgDeleteRow.Attributes.Add("class", "handStyle");
                //Following added as per New Data model changes 2377 SC-Support
                if (textboxButtonValue != null && textboxButtonValue == "Refill")
                    _ImgDeleteRow.Disabled = true;


                myscript += "var Imagecontext" + rowIndex + ";";
                myscript += "var ImageclickCallback" + rowIndex + " =";
                myscript += " Function.createCallback(ClientMedicationNonOrder.DeleteRow , Imagecontext" + rowIndex + ");";
                myscript += "$addHandler($get('" + _ImgDeleteRow.ClientID + "'), 'click', ImageclickCallback" + rowIndex + ");";


                DropDownList _DropDownListStrength = new DropDownList();
                //Commented by Loveena in Ref to Task#71 to increase the width of Strength Dropdownlist.
                //_DropDownListStrength.Width = 120;
                //Added by Loveena in Ref to Task#71 to increase the width of Strength Dropdownlist
                _DropDownListStrength.Width = new Unit(100, UnitType.Percentage);
                _DropDownListStrength.Height = 20;

                if (textboxButtonValue != null && textboxButtonValue == "Refill")
                    _DropDownListStrength.Enabled = false;
                _DropDownListStrength.EnableViewState = true;
                _DropDownListStrength.ID = "Control_ASP.usercontrols_clientmedicationnonorder_ascx_DropDownListStrength" + rowIndex;

                _DropDownListStrength.Attributes.Add("class", "ddlist");

                TextBox _txtQuantity = new TextBox();
                _txtQuantity.BackColor = System.Drawing.Color.White;
                _txtQuantity.MaxLength = 4;
                _txtQuantity.Style["font-size"] = "8.50pt";

                if (textboxButtonValue != null && textboxButtonValue == "Refill")
                    _txtQuantity.Enabled = false;
                _txtQuantity.ID = "Control_ASP.usercontrols_clientmedicationnonorder_ascx_TextBoxQuantity" + rowIndex;
                //Commented by Loveena in Ref to Task#71 to increase the width of Strength Dropdownlist
                //_txtQuantity.Width = 60;
                //Added by Loveena in Ref to Task#71 to increase the width of Strength Dropdownlist
                _txtQuantity.Width = new Unit(96, UnitType.Percentage);
                //_txtQuantity.Height = 20;
                _txtQuantity.Visible = true;
                _txtQuantity.Style["text-align"] = "Right";
                _txtQuantity.Attributes.Add("class", "Textbox");
                myscript += "$create(Streamline.SmartClient.UI.TextBox, {'ignoreEnterKey':true,Decimal:true}, {'onBlur':ClientMedicationNonOrder.ManipulateRowValues},{},$get('" + _txtQuantity.ClientID + "'));";


                DropDownList _DropDownListUnit = new DropDownList();
                _DropDownListUnit.Width = new Unit(100, UnitType.Percentage);
                _DropDownListUnit.Height = 20;
                if (textboxButtonValue != null && textboxButtonValue == "Refill")
                    _DropDownListUnit.Enabled = false;
                _DropDownListUnit.ID = "Control_ASP.usercontrols_clientmedicationnonorder_ascx_DropDownListUnit" + rowIndex;
                _DropDownListUnit.Attributes.Add("class", "ddlist");


                DropDownList _DropDownListSchedule = new DropDownList();
                //Commented by Loveena in Ref to Task#71 to increase the width of Strength Dropdownlist
                //_DropDownListSchedule.Width = 120;
                //Added by Loveena in Ref to Task#71 to increase the width of Strength Dropdownlist

                _DropDownListSchedule.Width = new Unit(100, UnitType.Percentage);
                _DropDownListSchedule.Height = 20;
                if (textboxButtonValue != null && textboxButtonValue == "Refill")
                    _DropDownListSchedule.Enabled = false;
                _DropDownListSchedule.ID = "Control_ASP.usercontrols_clientmedicationnonorder_ascx_DropDownListSchedule" + rowIndex;
                _DropDownListSchedule.Attributes.Add("class", "ddlist");

                TextBox _txtStartDate = new TextBox();
                _txtStartDate.BackColor = System.Drawing.Color.White;
                _txtStartDate.ID = "Control_ASP.usercontrols_clientmedicationnonorder_ascx_TextBoxStartDate" + rowIndex;
                _txtStartDate.Width = new Unit(96, UnitType.Percentage);
                //_txtStartDate.Height = 20;
                _txtStartDate.Visible = true;
                _txtStartDate.Attributes.Add("class", "Textbox");
                _txtStartDate.Style["font-size"] = "8.50pt";
                myscript += "$create(Streamline.SmartClient.UI.TextBox, {'ignoreEnterKey':true,DateTime:true}, {'onBlur':ClientMedicationNonOrder.ManipulateRowValues},{},$get('" + _txtStartDate.ClientID + "'));";

                System.Web.UI.WebControls.Image _ImgStartDate = new System.Web.UI.WebControls.Image();
                _ImgStartDate.ID = "Control_ASP.usercontrols_clientmedicationnonorder_ascx_ImageStartDate" + rowIndex;
                _ImgStartDate.ImageUrl = WebsiteSettings.BaseUrl + "./App_Themes/Includes/Images/calender_White.jpg";
                _ImgStartDate.Attributes.Add("onClick", "CalShow( this,'" + _txtStartDate.ClientID + "')");
                _ImgStartDate.Attributes.Add("onmouseover", "CalShow( this,'" + _txtStartDate.ClientID + "')");


                TextBox _txtDays = new TextBox();
                _txtDays.BackColor = System.Drawing.Color.White;
                _txtDays.MaxLength = 4;
                _txtDays.ID = "Control_ASP.usercontrols_clientmedicationnonorder_ascx_TextBoxDays" + rowIndex;
                _txtDays.Width = new Unit(96, UnitType.Percentage);
                //_txtDays.Height = 20;
                _txtDays.Visible = true;
                _txtDays.Attributes.Add("MedicationDays", ((Streamline.BaseLayer.StreamlineIdentity)(Context.User.Identity)).MedicationDaysDefault.ToString());
                _txtDays.Style["text-align"] = "Right";
                _txtDays.Attributes.Add("class", "Textbox");
                _txtDays.Style["font-size"] = "8.50pt";
                myscript += "$create(Streamline.SmartClient.UI.TextBox, {'ignoreEnterKey':true,Numeric:true}, {'onBlur':ClientMedicationNonOrder.ManipulateRowValues},{},$get('" + _txtDays.ClientID + "'));";


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
                _DropDownListPotencyUnitCode.ID = "Control_ASP.usercontrols_clientmedicationnonorder_ascx_DropDownListPotencyUnitCode" + rowIndex;
                _DropDownListPotencyUnitCode.Attributes.Add("class", "ddlist");

                TextBox _txtSample = new TextBox();
                _txtSample.BackColor = System.Drawing.Color.White;
                _txtSample.MaxLength = 4;
                _txtSample.ID = "Control_ASP.usercontrols_clientmedicationnonorder_ascx_TextBoxSample" + rowIndex;
                _txtSample.Width = new Unit(96, UnitType.Percentage);
                //_txtSample.Height = 20;
                _txtSample.Visible = true;
                _txtSample.Style["text-align"] = "Right";
                _txtSample.Attributes.Add("class", "Textbox");
                _txtSample.Style["font-size"] = "8.50pt";
                myscript += "$create(Streamline.SmartClient.UI.TextBox, {'ignoreEnterKey':true,Decimal:true}, {'onBlur':ClientMedicationNonOrder.ManipulateRowValues},{},$get('" + _txtSample.ClientID + "'));";

                TextBox _txtStock = new TextBox();
                _txtStock.BackColor = System.Drawing.Color.White;
                _txtStock.MaxLength = 4;
                _txtStock.ID = "Control_ASP.usercontrols_clientmedicationnonorder_ascx_TextBoxStock" + rowIndex;
                _txtStock.Width = new Unit(96, UnitType.Percentage);
                //_txtStock.Height = 20;
                _txtStock.Visible = true;
                _txtStock.Style["text-align"] = "Right";
                _txtStock.Attributes.Add("class", "Textbox");
                _txtStock.Style["font-size"] = "8.50pt";
                myscript += "$create(Streamline.SmartClient.UI.TextBox, {'ignoreEnterKey':true,Decimal:true}, {'onBlur':ClientMedicationNonOrder.ManipulateRowValues},{},$get('" + _txtStock.ClientID + "'));";

                TextBox _txtRefills = new TextBox();
                _txtRefills.BackColor = System.Drawing.Color.White;
                _txtRefills.MaxLength = 2;
                _txtRefills.ID = "Control_ASP.usercontrols_clientmedicationnonorder_ascx_TextBoxRefills" + rowIndex;
                _txtRefills.Width = new Unit(96, UnitType.Percentage);
                //_txtRefills.Height = 20;
                _txtRefills.Visible = true;
                _txtRefills.Style["text-align"] = "Right";
                _txtRefills.Attributes.Add("class", "Textbox");
                _txtRefills.Style["font-size"] = "8.50pt";
                myscript += "$create(Streamline.SmartClient.UI.TextBox, {'ignoreEnterKey':true,Decimal:true}, {'onBlur':ClientMedicationNonOrder.ManipulateRowValues},{},$get('" + _txtRefills.ClientID + "'));";

                TextBox _txtEndDate = new TextBox();
                _txtEndDate.ID = "Control_ASP.usercontrols_clientmedicationnonorder_ascx_TextBoxEndDate" + rowIndex;
                _txtEndDate.Width = new Unit(96, UnitType.Percentage);
                // _txtEndDate.Height = 20;
                //_txtEndDate.Visible = true;
                //Following commented as per New Data Model Changes 2377 SC-Support
                //_txtEndDate.Enabled = false;
                _txtEndDate.Enabled = true;
                _txtEndDate.Style["text-align"] = "Right";
                _txtEndDate.Attributes.Add("class", "Textbox");
                _txtEndDate.Style["font-size"] = "8.50pt";
                //_txtEndDate.ReadOnly = true;

                myscript += "$create(Streamline.SmartClient.UI.TextBox, {'ignoreEnterKey':true,DateTime:true}, {},{},$get('" + _txtEndDate.ClientID + "'));";

                Label _RowIdentifier = new Label();
                _RowIdentifier.ID = "RowIdentifier" + rowIndex;

                //Added by Loveena in ref to Task#2802
                HiddenField _hiddenAutoCalcAllowed = new HiddenField();
                _hiddenAutoCalcAllowed.ID = "HiddenFieldAutoCalcAllowed" + rowIndex;

                //Added by Loveena in ref to Task#85 SDI-FY10 Venture
                HiddenField _hiddenstrengthRowIdentifier = new HiddenField();
                _hiddenstrengthRowIdentifier.ID = "HiddenRowIdentifier" + rowIndex;
                //Code ends over here.
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
                _TableCell6.Width = new Unit(2, UnitType.Percentage);
                _TableCell7.Controls.Add(_txtDays);
                _TableCell7.Width = new Unit(4, UnitType.Percentage);
                _TableCell8.Controls.Add(_comboBoxPharmacyTextDiv);
                _TableCell8.Controls.Add(_comboBoxPharmacyDDList);
                _TableCell8.Width = new Unit(9, UnitType.Percentage);
                _TableCell8_5.Controls.Add(_DropDownListPotencyUnitCode);
                _TableCell8_5.Width = new Unit(9, UnitType.Percentage);
                _TableCell9.Controls.Add(_txtSample);
                _TableCell9.Width = new Unit(6, UnitType.Percentage);
                _TableCell10.Controls.Add(_txtStock);
                _TableCell10.Width = new Unit(5, UnitType.Percentage);
                _TableCell11.Controls.Add(_txtRefills);
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
                _DropDownListStrength.Attributes.Add("onchange", "ClientMedicationNonOrder.onStrengthChange(this,'" + _DropDownListUnit.ClientID + "',null,'" + _txtDays.ClientID + "','" + TextBoxStartDate + "','" + _txtStartDate.ClientID + "','" + _txtQuantity.ClientID + "','" + rowIndex + "')");
                _DropDownListUnit.Attributes.Add("onchange", "onUnitChange(" + rowIndex + ")");
                _DropDownListUnit.Attributes.Add("onBlur", "ClientMedicationNonOrder.onUnitBlur(this)");
                _DropDownListSchedule.Attributes.Add("onchange", "ClientMedicationNonOrder.onScheduleChange(" + rowIndex + ")");
                _DropDownListSchedule.Attributes.Add("onBlur", "ClientMedicationNonOrder.onScheduleBlur(this)");
                _txtStartDate.Attributes.Add("onBlur", "ClientMedicationNonOrder.onStartDate(this," + rowIndex + ")");
                _txtEndDate.Attributes.Add("onBlur", "ClientMedicationNonOrder.onEndDate()");
                _DropDownListPotencyUnitCode.Attributes.Add("onchange", "ClientMedicationNonOrder.onPotencyUnitCodeChange(this, " + rowIndex + ");");


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

        [WebMethod(EnableSession = true)]
        public string GetSystemReportsNewOrder(string _ReportName, string DiagnosisCode)
        {
            string ReportUrl = null;
            DataSet ds = null;
            try
            {

                Streamline.UserBusinessServices.ClientMedication ObjClientMedication = new Streamline.UserBusinessServices.ClientMedication();
                ds = ObjClientMedication.GetSystemReports(_ReportName);
                if (ds.Tables.Count > 0)
                {
                    if (ds.Tables[0].Rows.Count > 0)
                        ReportUrl = ds.Tables[0].Rows[0]["ReportUrl"].ToString();
                }
                if (ReportUrl != String.Empty && ReportUrl != null) // set the parameters values to report
                {
                    if (_ReportName == "Medication -NewOrder-DiagnosisCode")
                    {
                        ReportUrl = ReportUrl.Replace("<DiagnosisCode>", DiagnosisCode.ToString());
                        //Code ends over here.
                    }
                }
                return ReportUrl;
            }

            catch (Exception ex)
            {
                throw (ex);
            }
            finally
            {
                ds = null;
            }
        }

        [WebMethod(EnableSession = true)]
        public string GetSystemReportsMedication(string _ReportName, string MedicationNameId)
        {
            string ReportUrl = null;
            DataSet ds = null;
            try
            {

                Streamline.UserBusinessServices.ClientMedication ObjClientMedication = new Streamline.UserBusinessServices.ClientMedication();
                ds = ObjClientMedication.GetSystemReports(_ReportName);
                if (ds.Tables.Count > 0)
                {
                    if (ds.Tables[0].Rows.Count > 0)
                        ReportUrl = ds.Tables[0].Rows[0]["ReportUrl"].ToString();
                }
                if (ReportUrl != String.Empty && ReportUrl != null) // set the parameters values to report
                {
                    if (_ReportName == "Medication -NewOrder-MedicationName")
                    {
                        ReportUrl = ReportUrl.Replace("<MedicationNameId>", MedicationNameId.ToString());
                        //Code ends over here.
                    }
                }
                return ReportUrl;
            }

            catch (Exception ex)
            {
                throw (ex);
            }
            finally
            {
                ds = null;
            }
        }

        #region Code added by Loveena in ref to Task#2536 Ordered Medication: Radio button deselects from the Medication list grid
        [WebMethod(EnableSession = true)]
        public void ClearMedicationRow()
        {
            try
            {
                Session["SelectedMedicationId"] = null;
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }
        #endregion


        #region Code added by Loveena in ref to Task#3
        [WebMethod(EnableSession = true)]
        public object GetVerbalOrderReviewData(int clientMedicationScriptId)
        {
            object objDataset = "";
            DataSet ds = null;
            try
            {
                ds = (DataSet)Session["dsVerbalOrder"];
                DataRow[] dr1 = ds.Tables[0].Select("ClientMedicationScriptId=" + clientMedicationScriptId);
                if (dr1.Length > 0)
                {
                    Session["ClientId"] = dr1[0]["ClientId"].ToString();
                }

                DataRow[] dr2 = null;
                DataSet dtst = new DataSet();
                dtst.Merge(dr1);

                if (Session["OpenVerbalOrder"].ToString() == "A")
                {
                    if (ds.Tables.Count > 0)
                    {
                        dr2 = ds.Tables[1].Select("ClientMedicationScriptId=" + clientMedicationScriptId);
                        dtst.Merge(dr2);

                    }
                    DataRow[] dr3 = null;
                   
                    if (ds.Tables.Count > 1)
                     {
                        for (int i = 0; i < dr2.Count(); i++)
                        {
                            // Added To check if the Interation Drugs are acknowledged or not. -- Pranay
                            dr3 = ds.Tables[2].Select("(ClientMedicationId1=" + dr2[i]["ClientMedicationId"] + " or ClientMedicationId2=" +
                                                                            dr2[i]["ClientMedicationId"] + " ) and isnull(recorddeleted,'N') <> 'Y' and InteractionLevel=1 and (ISNULL(PrescriberAcknowledged,'N')='N')");
                        }
                        
                        if (dr3 != null && dr3.Count() > 0)
                        {
                               dtst.Merge(dr3);
                        }
                    }
                }
                objDataset = (object)dtst;
                if (dtst.Tables.Contains("ClientMedicationScripts") && dtst.Tables["ClientMedicationScripts"].Rows.Count > 0)
                Session["OrderingMethodToDefault"] = dtst.Tables["ClientMedicationScripts"].Rows[0]["OrderingMethod"].ToString();

              
            }

            catch (Exception ex)
            {
                objDataset = null;
                throw (ex);
            }
            finally
            {
                ds = null;
            }
            return objDataset;
        }

        [WebMethod(EnableSession = true)]
        public System.Web.UI.Triplet createVerbalControls(int clientMedicationScriptId, string orderType)
        {
            DataSet dsOrders = null;
            string _strTableHtml = "";
            int _rowSelected = 0;
            System.Web.UI.Triplet pairResult = new Triplet();
            try
            {
                CommonFunctions.Event_Trap(this);
                bool showSign = false;
                dsOrders = (DataSet)Session["dsVerbalOrder"];
                if (orderType == "Approve")
                {
                    DataRow[] dr = dsOrders.Tables[0].Select("ClientMedicationScriptId=" + clientMedicationScriptId);
                    if (dr.Length > 0)
                    {
                        if (Session["OpenVerbalOrder"].ToString() == "V")
                        {
                            dr[0]["VerbalOrderApproved"] = "Y";
                            showSign = true;
                        }
                        else if (Session["OpenVerbalOrder"].ToString() == "A")
                        {
                            dr[0]["WaitingPrescriberApproval"] = "N";
                            dr[0]["VerbalOrderApproved"] = "Y";
                            showSign = true;
                        }
                        Session["dsVerbalOrder"] = dsOrders;
                    }
                }
                else if (orderType == "Retract")
                {

                    DataRow[] dr = dsOrders.Tables[0].Select("ClientMedicationScriptId=" + clientMedicationScriptId);
                    if (dr.Length > 0)
                    {
                        if (Session["OpenVerbalOrder"].ToString() == "V")
                        {
                            dr[0]["VerbalOrderApproved"] = "N";
                            dr[0]["WaitingPrescriberApproval"] = "N";
                        }
                        else if (Session["OpenVerbalOrder"].ToString() == "A")
                        {
                            dr[0]["WaitingPrescriberApproval"] = "Y";
                            dr[0]["VerbalOrderApproved"] = "N";
                        }
                        Session["dsVerbalOrder"] = dsOrders;
                    }
                }
                else if (orderType == "ApproveAll")
                {
                    foreach (DataRow dr in dsOrders.Tables[0].Rows)
                    {
                        if (Session["OpenVerbalOrder"].ToString() == "V")
                        {
                            dr["VerbalOrderApproved"] = "Y";
                            showSign = true;
                        }
                        else if (Session["OpenVerbalOrder"].ToString() == "A")
                        {
                            if (dsOrders.Tables.Count > 0)
                            {
                                DataRow[] drClientMedications = dsOrders.Tables[1].Select("ClientMedicationScriptId=" + dr["ClientMedicationScriptId"]);
                              //  DataRow[] drClientMedicationsDrugCategory = dsOrders.Tables[0].Select("ClientMedicationScriptId = " + dr["ClientMedicationScriptId"]+ " and DrugCategory>0");
                                   DataRow[] drClientMedicationsDrugCategory   =dsOrders.Tables[0].Select("ClientMedicationScriptId = " + dr["ClientMedicationScriptId"] + " and DrugCategory>0 and OrderingMethod in ('F','E')");
                                    for (int i = 0; i < drClientMedications.Count(); i++)
                                    {

                                        string Query = "(ClientMedicationId1=" + drClientMedications[i]["ClientMedicationId"] + " or ClientMedicationId2=" +
                                       drClientMedications[i]["ClientMedicationId"] + " ) and isnull(recorddeleted,'N') <> 'Y'";
                                        DataRow[] drClientMedicationInteractions = dsOrders.Tables[2].Select(Query + " and InteractionLevel=1");
                                        if (drClientMedicationInteractions.Count() <= 0)
                                        {
                                            dr["WaitingPrescriberApproval"] = "N";
                                            dr["VerbalOrderApproved"] = "Y";
                                        }
                                    }
                                  //Added By Pranay Drug with CategoryII will not be approved.
                                  for (int j = 0; j < drClientMedicationsDrugCategory.Count(); j++)
                                  {
                                        dr["WaitingPrescriberApproval"] = "Y";
                                        dr["VerbalOrderApproved"] = "N";

                                   }
                            }
                        }
                        //dr["WaitingPrescriberApproval"] = "N";
                        //dr["VerbalOrderApproved"] = "Y";
                        //Ended over here
                        showSign = true;
                    }
                    Session["dsVerbalOrder"] = dsOrders;
                }
                Table tableHeader = new Table();
                tableHeader.Width = new Unit(100, UnitType.Percentage);
                tableHeader.CssClass = "Label";
                tableHeader.Rows.Add(CreateLabelRow());

                Table tableControls = new Table();
                tableControls.Width = new Unit(100, UnitType.Percentage);
                tableControls.ID = "tableApprovedOrders";
                tableControls.Attributes.Add("tableApprovedOrders", "true");
                string myscript = "";
                int _ClientMedScriptId = 0;

                for (int _RowCount = 0; _RowCount < dsOrders.Tables[0].Rows.Count; _RowCount++)
                {
                    if (Convert.ToInt32(dsOrders.Tables[0].Rows[_RowCount]["ClientMedicationScriptId"]) ==
                        clientMedicationScriptId)
                    {
                        _rowSelected = _RowCount;
                    }
                    if (_RowCount > 0)
                    {
                        if (Convert.ToInt32(dsOrders.Tables[0].Rows[_RowCount - 1]["ClientMedicationScriptId"]) == clientMedicationScriptId)
                        {
                            flag = true;
                            lastRow = false;
                            _ClientMedScriptId = Convert.ToInt32(dsOrders.Tables[0].Rows[_RowCount]["ClientMedicationScriptId"]);
                        }
                        else if (Convert.ToInt32(dsOrders.Tables[0].Rows[_RowCount]["ClientMedicationScriptId"]) == clientMedicationScriptId && _RowCount == (dsOrders.Tables[0].Rows.Count - 1))
                        {
                            lastRow = true;
                            flag = false;
                            _ClientMedScriptId = Convert.ToInt32(dsOrders.Tables[0].Rows[0]["ClientMedicationScriptId"]);

                        }
                        else
                        {
                            flag = false;
                            lastRow = false;
                        }
                    }
                    if (_RowCount == 0 && orderType == "ApproveAll")
                    {
                        flag = true;
                        _ClientMedScriptId = Convert.ToInt32(dsOrders.Tables[0].Rows[0]["ClientMedicationScriptId"]);
                    }
                    tableControls.Rows.Add(CreateOrderRow(dsOrders.Tables[0].Rows[_RowCount], _RowCount, clientMedicationScriptId, orderType, ref myscript));
                }
                StringBuilder sb = new StringBuilder();
                using (StringWriter sw = new StringWriter(sb))
                {
                    using (HtmlTextWriter textWriter = new HtmlTextWriter(sw))
                    {
                        tableControls.RenderControl(textWriter);
                    }
                }
                _strTableHtml = sb.ToString();
                pairResult.First = _strTableHtml;


                StringBuilder sbheader = new StringBuilder();
                using (StringWriter swheader = new StringWriter(sbheader))
                {
                    using (HtmlTextWriter textWriterheader = new HtmlTextWriter(swheader))
                    {
                        tableHeader.RenderControl(textWriterheader);
                    }
                }
                pairResult.Second = sbheader.ToString() + "," + showSign;
                pairResult.Third = _ClientMedScriptId + "," + lastRow + "," + _rowSelected.ToString() + "," + clientMedicationScriptId.ToString();

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
            finally
            {

            }
            return pairResult;
        }

        private TableRow CreateLabelRow()
        {

            try
            {
                CommonFunctions.Event_Trap(this);
                //Table _Table = new Table();
                //_Table.Width = new Unit(100, UnitType.Percentage);
                TableRow _TableRow = new TableRow();
                TableCell _TableCell0 = new TableCell();
                TableCell _TableCell1 = new TableCell();
                TableCell _TableCell2 = new TableCell();
                TableCell _TableCell3 = new TableCell();

                //_Table.ID = "Table";



                Label _lblClientName = new Label();
                _lblClientName.ID = "ClientName";
                _lblClientName.Visible = true;
                _lblClientName.Text = "Client Name";

                Label _lblCreatedBy = new Label();
                _lblCreatedBy.ID = "CreatedBy";
                _lblCreatedBy.Visible = true;
                _lblCreatedBy.Text = "Created By";

                Label _lblDate = new Label();
                _lblDate.ID = "Date";
                _lblDate.Visible = true;
                _lblDate.Text = "Date";

                _TableCell0.Width = new Unit(13, UnitType.Percentage);
                _TableCell1.Controls.Add(_lblClientName);
                _TableCell1.Width = new Unit(20, UnitType.Percentage);
                _TableCell1.Style.Add("noWrap", "nowrap");
                _TableCell2.Controls.Add(_lblCreatedBy);
                _TableCell2.Width = new Unit(20, UnitType.Percentage);
                _TableCell2.Style.Add("noWrap", "nowrap");
                _TableCell3.Controls.Add(_lblDate);
                _TableCell3.Width = new Unit(20, UnitType.Percentage);
                _TableCell3.Style.Add("noWrap", "nowrap");

                _TableRow.Controls.Add(_TableCell0);
                _TableRow.Controls.Add(_TableCell1);
                _TableRow.Controls.Add(_TableCell2);
                _TableRow.Controls.Add(_TableCell3);

                //if (Session["OpenVerbalOrder"] == "A")
                //{
                    TableCell _TableCell4 = new TableCell();
                    Label _lblInteraction = new Label();
                    _lblInteraction.ID = "Interaction";
                    _lblInteraction.Visible = true;
                    _lblInteraction.Text = "Interactions";
                    _TableCell4.Controls.Add(_lblInteraction);
                    _TableCell4.Width = new Unit(20, UnitType.Percentage);
                    _TableRow.Controls.Add(_TableCell4);
                //}
                //_Table.CssClass = "LabelUnderlineFontNew";
                //_Table.Controls.Add(_TableRow);
                return _TableRow;
                // PlaceLabel.Controls.Add(_Table);
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


        private TableRow CreateOrderRow(DataRow dr, int rowIndex, int scriptId, string orderType, ref string myscript)
        {
            try
            {


                CommonFunctions.Event_Trap(this);
                Table _Table = new Table();
                _Table.Width = new Unit(100, UnitType.Percentage);
                TableRow _TableRow = new TableRow();
                _TableRow.ID = "TableOrderRow_" + rowIndex + "_" + dr["ClientMedicationScriptId"];
                TableCell _TableCell0 = new TableCell();
                TableCell _TableCell1 = new TableCell();
                TableCell _TableCell2 = new TableCell();
                TableCell _TableCell3 = new TableCell();
                TableCell _TableCell4 = new TableCell();

                _Table.ID = "TableOrder" + rowIndex;
                System.Web.UI.WebControls.Image imgCheck = new System.Web.UI.WebControls.Image();
                imgCheck.ID = "imgCheck" + rowIndex;
                imgCheck.ImageUrl = WebsiteSettings.BaseUrl + "App_Themes/Includes/Images/CheckMark.jpg";
                // imgCheck.Src = Server.MapPath("..//") + "App_Themes//Includes//Images//CheckMark.jpg";
                //imgCheck.Src =" D:\\Day Users\\Loveena\\Official\\Projects\\SHC_Medication\\Streamline.SmartCareWeb\\Streamline.SmartClient\\App_Themes\\Includes\\Images\\CheckMark.jpg";
                RadioButton radioButtonOrder = new RadioButton();
                radioButtonOrder.ID = "radioButtonOrder" + rowIndex;
                radioButtonOrder.Attributes.Add("onclick", "GetVerbalOrderReviewData(" + dr["ClientMedicationScriptId"] + "," + dr["DrugCategory"] + ");");
                radioButtonOrder.GroupName = "rdo";

                Label lblClientName = new Label();
                lblClientName.CssClass = "Label";
                //lblClientName.Text = dr["FirstName"] + ", " + dr["LastName"];
                lblClientName.Text = dr["LastName"] + ", " + dr["FirstName"] + " (" + dr["ClientId"] + ")"; 

                Label lblCreatedBy = new Label();
                lblCreatedBy.CssClass = "Label";
                lblCreatedBy.Text = dr["CreatedBy"].ToString();

                Label lblDate = new Label();
                lblDate.CssClass = "Label";
                lblDate.Text = Convert.ToDateTime(dr["OrderDate"]).ToString("MM/dd/yyyy");
                /*---------------------------VerbalOrderApproved----------------------------- */
                if (Session["OpenVerbalOrder"].ToString() == "V")
                {
                    TableCell tdInteraction = new TableCell();
                    //Added by Anuj on 11March,2010 for task ref 2859
                    //if (dr["VerbalOrderApproved"].ToString() == "Y")
                    if (dr["VerbalOrderApproved"].ToString() == "Y")
                    {
                        _TableCell0.Controls.Add(imgCheck);
                        _TableCell0.Width = new Unit(2, UnitType.Percentage);
                        _TableCell1.Controls.Add(radioButtonOrder);
                        _TableCell1.Width = new Unit(2, UnitType.Percentage);
                        if (flag == true)
                            radioButtonOrder.Checked = true;
                        else
                            radioButtonOrder.Checked = false;
                        _TableCell2.Controls.Add(lblClientName);
                        _TableCell2.Width = new Unit(10, UnitType.Percentage);
                        _TableCell3.Controls.Add(lblCreatedBy);
                        _TableCell3.Width = new Unit(10, UnitType.Percentage);
                        _TableCell4.Controls.Add(lblDate);
                        _TableCell4.Width = new Unit(10, UnitType.Percentage);
                        _TableRow.Controls.Add(_TableCell0);
                        _TableRow.Controls.Add(_TableCell1);
                        _TableRow.Controls.Add(_TableCell2);
                        _TableRow.Controls.Add(_TableCell3);
                        _TableRow.Controls.Add(_TableCell4);
                        GetInteractionsafterApprove(rowIndex, _TableRow);
                    }
                    else
                    {
                        _TableCell0.Width = new Unit(2, UnitType.Percentage);
                        _TableCell1.Controls.Add(radioButtonOrder);
                        _TableCell1.Width = new Unit(2, UnitType.Percentage);
                        if (flag == true)
                            radioButtonOrder.Checked = true;
                        else
                            radioButtonOrder.Checked = false;
                        _TableCell2.Controls.Add(lblClientName);
                        _TableCell2.Width = new Unit(10, UnitType.Percentage);
                        _TableCell3.Controls.Add(lblCreatedBy);
                        _TableCell3.Width = new Unit(10, UnitType.Percentage);
                        _TableCell4.Controls.Add(lblDate);
                        _TableCell4.Width = new Unit(10, UnitType.Percentage);
                        _TableRow.Controls.Add(_TableCell0);
                        _TableRow.Controls.Add(_TableCell1);
                        _TableRow.Controls.Add(_TableCell2);
                        _TableRow.Controls.Add(_TableCell3);
                        _TableRow.Controls.Add(_TableCell4);
                        GetInteractionsafterApprove(rowIndex, _TableRow);
                    }
                }
                /*---------------------WaitingPrescriberApproval--------------------------- */
                else if (Session["OpenVerbalOrder"].ToString() == "A")
                {
                    //if (dr["WaitingPrescriberApproval"].ToString() == "N")
                    //Added by Anuj on 11March,2010 for task ref 2859
                    TableCell tdInteraction = new TableCell();



                    if (dr["WaitingPrescriberApproval"].ToString() == "N" && dr["VerbalOrderApproved"].ToString() == "Y")
                    {
                        _TableCell0.Controls.Add(imgCheck);
                        _TableCell0.Width = new Unit(2, UnitType.Percentage);
                        _TableCell1.Controls.Add(radioButtonOrder);
                        _TableCell1.Width = new Unit(2, UnitType.Percentage);
                        if (flag == true)
                            radioButtonOrder.Checked = true;
                        else
                            radioButtonOrder.Checked = false;
                        _TableCell2.Controls.Add(lblClientName);
                        _TableCell2.Width = new Unit(10, UnitType.Percentage);
                        _TableCell3.Controls.Add(lblCreatedBy);
                        _TableCell3.Width = new Unit(10, UnitType.Percentage);
                        _TableCell4.Controls.Add(lblDate);
                        _TableCell4.Width = new Unit(10, UnitType.Percentage);
                        _TableRow.Controls.Add(_TableCell0);
                        _TableRow.Controls.Add(_TableCell1);
                        _TableRow.Controls.Add(_TableCell2);
                        _TableRow.Controls.Add(_TableCell3);
                        _TableRow.Controls.Add(_TableCell4);

                        GetInteractionsafterApprove(rowIndex, _TableRow);

                    }
                    else
                    {
                        _TableCell0.Width = new Unit(2, UnitType.Percentage);
                        _TableCell1.Controls.Add(radioButtonOrder);
                        _TableCell1.Width = new Unit(2, UnitType.Percentage);
                        if (flag == true)
                            radioButtonOrder.Checked = true;
                        else
                            radioButtonOrder.Checked = false;
                        _TableCell2.Controls.Add(lblClientName);
                        _TableCell2.Width = new Unit(10, UnitType.Percentage);
                        _TableCell3.Controls.Add(lblCreatedBy);
                        _TableCell3.Width = new Unit(10, UnitType.Percentage);
                        _TableCell4.Controls.Add(lblDate);
                        _TableCell4.Width = new Unit(10, UnitType.Percentage);
                        _TableRow.Controls.Add(_TableCell0);
                        _TableRow.Controls.Add(_TableCell1);
                        _TableRow.Controls.Add(_TableCell2);
                        _TableRow.Controls.Add(_TableCell3);
                        _TableRow.Controls.Add(_TableCell4);

                        GetInteractionsafterApprove(rowIndex, _TableRow);
                    }
                }
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

        public void GetInteractionsafterApprove(int rowIndex, TableRow _TableRow)
        {
            TableCell tdInteraction = new TableCell();
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
            DataSet _dsVerbalOrder = null;
            _dsVerbalOrder = (DataSet)Session["dsVerbalOrder"];

            DataTable dtClientMedicationScripts = _dsVerbalOrder.Tables[1];
            DataTable dtClientMedications = _dsVerbalOrder.Tables[2];
            string medicationId = dtClientMedicationScripts.Rows[rowIndex]["ClientMedicationId"].ToString();
            if (dtClientMedications.Rows.Count > 0)
            {
                string Query = "(ClientMedicationId1=" + medicationId + " or ClientMedicationId2=" +
                                                      medicationId + " ) and isnull(recorddeleted,'N') <> 'Y'";
                DataRow[] drInteraction = dtClientMedications.Select(Query);

                foreach (DataRow drT in drInteraction)
                {
                    if (!drT["InteractionLevel"].ToString().IsNullOrWhiteSpace())
                    {
                        int InteractionId = Convert.ToInt32(drT["ClientMedicationInteractionId"]);
                        var backColor = new Color();
                        if ((drT["Color"] == DBNull.Value) || (String.IsNullOrEmpty(drT["Color"].ToString())))
                        {
                            foreach (Color clr in _color)
                            {
                                DataRow[] drColorExits =
                                    dtClientMedications.Select("Color='" + clr.ToArgb().ToString() +
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

                        drT["Color"] = backColor.ToArgb().ToString();

                        Label lblInteraction = new Label();

                        lblInteraction.CssClass = "drugInteraction";
                        lblInteraction.ToolTip = "Drug Interaction";
                        lblInteraction.ID = "QInteraction";
                        lblInteraction.Text = drT["InteractionLevel"].ToString();
                        lblInteraction.BackColor = backColor;

                        tdInteraction.Controls.Add(lblInteraction);
                        tdInteraction.Width = new Unit(10, UnitType.Percentage);
                        _TableRow.Controls.Add(tdInteraction);
                    }
                }
            }
        }

        [WebMethod(EnableSession = true)]
        public string GetRDLCContents(int ScriptId)
        {
            #region Get RDLC Contents
            DataSet dsClientMedicationScripts = new DataSet();
            dsClientMedicationScripts = (DataSet)(Session["dsVerbalOrder"]);
            DataRow[] dtRowClientMedicationScripts = dsClientMedicationScripts.Tables[0].Select("ClientMedicationScriptId=" + ScriptId);
            bool ToBeFaxed = false;
            bool FlagForImagesDeletion = true;
            string OrderingMethod = dtRowClientMedicationScripts[0]["OrderingMethod"].ToString();
            string SendCoveLetter = "false";
            string _ReportPath = "";
            int LocationId = Convert.ToInt32(dtRowClientMedicationScripts[0]["LocationId"]);
            string mimeType;
            string encoding;
            string fileNameExtension;
            string[] streams;

            //Added by Chandan for the task 2404 -1.7.2 - Prescribe Page: Print Chart Copy
            string _PrintChartCopy = "N";



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

            //End
            //Block For ReportPath
            reportViewer1 = new Microsoft.Reporting.WebForms.ReportViewer();

            try
            {
                #region DeleteOldRenderedImages
                try
                {
                    using (Streamline.BaseLayer.RDLCPrint objRDLC = new RDLCPrint())
                    {
                        objRDLC.DeleteRenderedImages(Server.MapPath("~/RDLC/" + Context.User.Identity.Name));
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

                #endregion
                _ReportPath = Server.MapPath("~") + System.Configuration.ConfigurationManager.AppSettings["MedicationPerscriptionReportUrl"];
                if (_ReportPath == "")//Check For Report Path
                {

                    throw new Exception("ReportPath is Missing In WebConfig");

                }
            }
            catch (Exception ex)
            {
                throw new Exception("ReportPath Key is Missing In WebConfig");

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

                if (LocationId == 0)
                    LocationId = 1;
                #region Added by Vikas Vyas
                //Get the Name of the Rdlc,StoredProcedure from DocumentCodes,DocumentCodesRDLSubReports
                //Modifed in Ref to Task#2596.
                //if (ToBeFaxed == false)
                //    _DataSetGetRdlCName = objectClientMedications.GetRdlCNameDataBase(502);
                //else
                //    _DataSetGetRdlCName = objectClientMedications.GetRdlCNameDataBase(501);

                switch (OrderingMethod)
                {
                    case "E":
                        _DataSetGetRdlCName = objectClientMedications.GetRdlCNameDataBase(1471);
                        break;
                    case "F":
                        _DataSetGetRdlCName = objectClientMedications.GetRdlCNameDataBase(501);
                        break;
                    default:
                        _DataSetGetRdlCName = objectClientMedications.GetRdlCNameDataBase(502);
                        break;
                }

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
                        _DataSetRdlForMainReport = objectClientMedications.GetDataForRdlC(_StoredProcedureName, ScriptId, _OrderingMethod, 1, LocationId, _PrintChartCopy, Session.SessionID, string.Empty);
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
                        //HiddenFieldStoredProcedureName.Value = _StoredProcedureName;
                        //HiddenFieldReportName.Value = _ReportName;

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
                                    _DataSetRdlForSubReport = objectClientMedications.GetDataForRdlC(_SubReportStoredProcedure, ScriptId, _OrderingMethod, 1, LocationId, _PrintChartCopy, Session.SessionID, string.Empty);

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

                if (ToBeFaxed == false)
                {
                    try
                    {
                        using (Streamline.BaseLayer.RDLCPrint objRDLC = new RDLCPrint())
                        {
                            //In case of Ordering method as X Chart copy will be printed
                            if (OrderingMethod == "X")
                                objRDLC.Run(this.reportViewer1.LocalReport, Server.MapPath("~/RDLC/" + Context.User.Identity.Name), ScriptId.ToString(), FlagForImagesDeletion, true);
                            else  //In case of Ordering method as P Chart copy will not be printed
                                objRDLC.Run(this.reportViewer1.LocalReport, Server.MapPath("~/RDLC/" + Context.User.Identity.Name), ScriptId.ToString(), FlagForImagesDeletion, false);

                            //Added by Rohit. Ref ticket#84
                            renderedBytes = reportViewer1.LocalReport.Render(reportType, deviceInfo, out mimeType, out encoding, out fileNameExtension, out streams, out warnings);
                            //ShowReport(Session["imgId"].ToString());
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
                    finally
                    {
                        objLogManager = null;
                    }

                }
                else
                {
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
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "";
                else
                    ex.Data["CustomExceptionInformation"] = "";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
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
            return ShowReport(ScriptId.ToString());
            #endregion
        }

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
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "";
                else
                    ex.Data["CustomExceptionInformation"] = "";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }

        }

        public string ShowReport(string _strScriptIds)
        {
            FileStream fs;
            TextWriter ts;
            ArrayList ScriptArrays;
            ArrayList ChartScriptArrays;
            bool _strFaxSendStatus = false;
            string _strFaxFaildMessage = "";



            try
            {
                string strPath = "";
                string FileName = "";
                fs = new FileStream(Server.MapPath("~/RDLC/" + Context.User.Identity.Name) + "\\Report.html", FileMode.Create);
                ts = new StreamWriter(fs);
                //divReportViewer.InnerHtml = "";

                string strPageHtml = "";
                ScriptArrays = new ArrayList();
                ScriptArrays = ApplicationCommonFunctions.StringSplit(_strScriptIds, "^");


                for (int i = 0; i < ScriptArrays.Count; i++)
                {

                    foreach (string file in Directory.GetFiles(Server.MapPath("~/RDLC/" + Context.User.Identity.Name) + "\\"))
                    {
                        FileName = file.Substring(file.LastIndexOf("\\") + 1);
                        if ((FileName.IndexOf("JPEG") >= 0 || FileName.IndexOf("jpeg") >= 0) && (FileName.IndexOf(ScriptArrays[i].ToString(), 3) >= 0))
                            //strPageHtml += "<img src='.\\RDLC\\" + Context.User.Identity.Name + "\\" + ScriptArrays[i] + "\\" + FileName + "'/>";
                            strPageHtml += "<img src='.\\RDLC\\" + Context.User.Identity.Name + "\\" + FileName + "'/>";
                        //  strPageHtml += "<img src='\\RDLC\\" +  Context.User.Identity.Name  + file.ToString() + "'>";
                        //strPath = "'..\\RDLC\\" + Context.User.Identity.Name + "\\" + ScriptArrays[i] + "\\" + FileName;
                        strPath = "'~/RDLC/" + Context.User.Identity.Name + "\\" + FileName;
                        //ts.WriteLine("<img src='" + file.ToString() + "'>");
                    }
                }


                //divReportViewer.InnerHtml = "";
                //divReportViewer.InnerHtml = strPageHtml;

                ts.Close();
                strPageHtml = strPageHtml.Replace(@"\", "/");
                return strPageHtml;

            }
            catch (Exception ex)
            {
                throw (ex);
            }
        }

        [WebMethod(EnableSession = true)]
        public System.Web.UI.Triplet CancelOrders(int clientMedicationScriptId)
        {
            Streamline.UserBusinessServices.ClientMedication objClientMed = new ClientMedication();
            DataSet dataSetUpdate = new DataSet();
            Triplet triplet = new Triplet();
            string scriptids = "";
            bool sendPrint = false;

            DataSet dsOrders = null;
            dsOrders = (DataSet)Session["dsVerbalOrder"];

            DataRow[] drtemp = dsOrders.Tables[0].Select("ClientMedicationScriptId=" + clientMedicationScriptId);
            if (drtemp.Length > 0)
            {
                drtemp[0]["Voided"] = "Y";
                drtemp[0]["VoidedReason"] = "CancelOrder";
                if (drtemp[0]["OrderingPrescriberId"] != null)
                    drtemp[0]["VoidedBy"] = ((StreamlineIdentity)Context.User.Identity).UserId;
                // Malathi Shiva: This is added because in Medication history the medications which are WaitingPrescriberApproval = N is displayed in the list whereas the Queued Order Medications have this column WaitingPrescriberApproval set to 'Y' 
                // So when we void/cancel we need to set this value to'N' for the voided medications to display in the medication history - Discussed with Katie/Wasif through mail: Valley - Customizations Task# 68
                drtemp[0]["WaitingPrescriberApproval"] = "N";
                Session["dsVerbalOrder"] = dsOrders;
            }

            if (Session["dsVerbalOrder"] != null)
            {
                if (((System.Data.DataSet)(Session["dsVerbalOrder"])).Tables.Count > 1)
                {
                    int icount = ((System.Data.DataSet)(Session["dsVerbalOrder"])).Tables.Count;
                    int j = icount;
                    for (int r = 1; r < j || r < icount; r++)
                    {
                        j = j - 1;
                        ((System.Data.DataSet)(Session["dsVerbalOrder"])).Tables.RemoveAt(j);
                    }
                }
                dataSetUpdate = objClientMed.UpdateDocuments((DataSet)Session["dsVerbalOrder"]);
                DataRow[] dr =
                   dataSetUpdate.Tables["ClientMedicationScripts"].Select("WaitingPrescriberApproval='N'");
                if (Session["OpenVerbalOrder"].ToString() == "A")
                {
                    for (int icount = 0; icount < dr.Length; icount++)
                    {
                        if (scriptids == "")
                            scriptids = dr[icount]["ClientMedicationScriptId"].ToString();
                        else
                            scriptids += "," + dr[icount]["ClientMedicationScriptId"].ToString();
                    }
                }
                triplet.First = Session["OpenVerbalOrder"];
                triplet.Second = scriptids;
                triplet.Third = sendPrint;
            }
            return triplet;
        }

        [WebMethod(EnableSession = true)]
        // public System.Web.UI.Pair SaveOnSign(string OrderingMethod, string password)
        //Modified Ref:Task No:2988
        public System.Web.UI.Triplet SaveOnSign(string OrderingMethod, string password, string pharmacyId)
        {
            Streamline.UserBusinessServices.ClientMedication objClientMed = null;
            Streamline.UserBusinessServices.DataSets.DataSetClientScripts DataSetClientScriptActivities = null;
            DataSet dataSetUpdate = new DataSet();
            //Modified Ref:Task No:2988
            //Pair pair = new Pair();
            Triplet triplet = new Triplet();
            string scriptids = "";
            //Modified Ref:Task No:2988
            bool sendPrint = false;
            //Removing the Temp tables Table1 and Table2
            if (Session["OpenVerbalOrder"] == "A" && ((System.Data.DataSet)(Session["dsVerbalOrder"])).Tables.Count > 1)
            {
                int icount = ((System.Data.DataSet)(Session["dsVerbalOrder"])).Tables.Count;
                int j = icount;
                for (int r = 1; r < j || r < icount; r++)
                {
                    j = j - 1;
                    ((System.Data.DataSet)(Session["dsVerbalOrder"])).Tables.RemoveAt(j);
                }
            }
            if (Session["OpenVerbalOrder"] == "V" && ((System.Data.DataSet)(Session["dsVerbalOrder"])).Tables.Count > 1)
            {
                int icount = ((System.Data.DataSet)(Session["dsVerbalOrder"])).Tables.Count;
                int j = icount;
                for (int r = 1; r < j || r < icount; r++)
                {
                    j = j - 1;
                    ((System.Data.DataSet)(Session["dsVerbalOrder"])).Tables.RemoveAt(j);
                }
            }
            if (password.Trim() ==
                ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).Password.Trim())
            {
                objClientMed = new ClientMedication();
                DataSetClientScriptActivities =
                    new Streamline.UserBusinessServices.DataSets.DataSetClientScripts();
                if (Session["dsVerbalOrder"] != null)
                {

                    dataSetUpdate = objClientMed.UpdateDocuments((DataSet)Session["dsVerbalOrder"]);
                    DataRow[] dr =
                        dataSetUpdate.Tables["ClientMedicationScripts"].Select("WaitingPrescriberApproval='N'");
                    if (Session["OpenVerbalOrder"].ToString() == "A")
                    {
                        for (int icount = 0; icount < dr.Length; icount++)
                        {

                            if (scriptids == "")
                                scriptids = dr[icount]["ClientMedicationScriptId"].ToString();
                            else
                                scriptids += "," + dr[icount]["ClientMedicationScriptId"].ToString();
                            ////Insert Rows into ClientScriptActivities

                            OrderingMethod = !dr[icount]["OrderingMethod"].ToString().IsNullOrWhiteSpace() ? dr[icount]["OrderingMethod"].ToString() : OrderingMethod;

                            DataRow drClientMedicationScriptsActivity = DataSetClientScriptActivities.Tables["ClientMedicationScriptActivities"].NewRow();
                            drClientMedicationScriptsActivity["ClientMedicationScriptId"] =
                                dr[icount]["ClientMedicationScriptId"];
                            //drClientMedicationScriptsActivity["Method"] = 'P';
                            drClientMedicationScriptsActivity["Method"] = OrderingMethod;
                            drClientMedicationScriptsActivity["Reason"] = System.DBNull.Value;
                            drClientMedicationScriptsActivity["FaxStatusDate"] = DateTime.Now;
                            drClientMedicationScriptsActivity["PharmacyId"] = dr[icount]["PharmacyId"]; ;
                            
                            if (OrderingMethod == "E")
                            {
                                drClientMedicationScriptsActivity["Status"] = 5561;
                            }
                            else if (OrderingMethod == "P")
                            {
                                drClientMedicationScriptsActivity["Status"] = System.DBNull.Value;
                            }
                            drClientMedicationScriptsActivity["StatusDescription"] = System.DBNull.Value;
                            drClientMedicationScriptsActivity["FaxExternalIdentifier"] = System.DBNull.Value;
                            drClientMedicationScriptsActivity["IncludeChartCopy"] = "N";

                            drClientMedicationScriptsActivity["RowIdentifier"] = System.Guid.NewGuid();
                            drClientMedicationScriptsActivity["CreatedBy"] =
                                ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                            drClientMedicationScriptsActivity["CreatedDate"] = DateTime.Now;
                            drClientMedicationScriptsActivity["ModifiedBy"] =
                                ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                            drClientMedicationScriptsActivity["ModifiedDate"] = DateTime.Now;
                            DataSetClientScriptActivities.Tables["ClientMedicationScriptActivities"].Rows.Add(drClientMedicationScriptsActivity);
                            // Vithobha added below code to show Queued order in Outbound prescriptions after sign, Camino - Environment Issues Tracking: #305 
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


                            //objClientMed.UpdateDocuments(DataSetClientScriptActivities);
                            string HiddenFieldAllFaxed = "";
                            bool _strScriptsTobeFaxedButPrinted = false;
                            bool FlagForImagesDeletion = false;
                            if (OrderingMethod == "F")
                            {
                                #region Sending Fax

                                    _strScriptsTobeFaxedButPrinted = false;
                                    string strSelectClause =
                                        "ISNULL(DrugCategory,0)=2  and  ClientMedicationScriptId=" +
                                        dr[icount]["ClientMedicationScriptId"].ToString();

                                    if (
                                        dataSetUpdate.Tables["ClientMedicationScriptDrugs"].Select(strSelectClause)
                                                                                           .Length > 0)
                                    {
                                        _strScriptsTobeFaxedButPrinted = true;
                                        HiddenFieldAllFaxed = "0";

                                    }


                                    if (_strScriptsTobeFaxedButPrinted)
                                    {
                                        bool ans =
                                            SendToPrinter(Convert.ToInt32(dr[icount]["ClientMedicationScriptId"]),
                                                          FlagForImagesDeletion, OrderingMethod);
                                        //Added Ref:Task No:2988
                                        if (sendPrint == false)
                                            sendPrint = ans;

                                    }

                                    else
                                    {
                                        if (dr[icount]["PharmacyId"] == null)
                                            dr[icount]["PharmacyId"] = 0;
                                        string FaxUniqueId =
                                            SendToFax(Convert.ToInt32(dr[icount]["ClientMedicationScriptId"]),
                                                      Convert.ToInt32(dr[icount]["PharmacyId"]),
                                                      FlagForImagesDeletion, OrderingMethod);
                                        //if (_strPrintChartCopy == "true" && ans1 == true)
                                        //    PrintChartCopy(Convert.ToInt32(dataSetUpdate.Tables[0].Rows[icount]["ClientMedicationScriptId"]));
                                        //Added Ref:Task No:2988
                                        bool ans1 = FaxUniqueId != "false";
                                        if (ans1 == false) //If Sending Fax failed
                                        {
                                            PrintPrescription(
                                                Convert.ToInt32(dr[icount]["ClientMedicationScriptId"]),
                                                OrderingMethod);
                                        }
                                        //Added Ref:Task No:2988
                                        if (sendPrint == false)
                                            sendPrint = ans1;

                                        if (DataSetClientScriptActivities.Tables.Contains("ClientMedicationScriptActivities") && DataSetClientScriptActivities.Tables["ClientMedicationScriptActivities"].Select("ClientMedicationScriptId='" + dr[icount]["ClientMedicationScriptId"] + "'").Any())
                                        {
                                            //DataRow drClientMedicationScriptsActivity =
                                            //    DataSetClientScriptActivities.Tables["ClientMedicationScriptActivities"]
                                            //        .Select("ClientMedicationScriptId='" +
                                            //                dr[icount]["ClientMedicationScriptId"] + "'")[0];

                                            using (
                                            var _clientMedication = new ClientMedication())
                                            {
                                                _clientMedication.SetRenderedImageData(DataSetClientScriptActivities,
                                                    drClientMedicationScriptsActivity,
                                                    ((StreamlineIdentity)
                                                        Context.User.Identity).UserCode, renderedBytes);
                                            }
                                            drClientMedicationScriptsActivity["FaxExternalIdentifier"] = FaxUniqueId;

                                            drClientMedicationScriptsActivity["Status"] = 5561;
                                            drClientMedicationScriptsActivity["StatusDescription"] = DBNull.Value;
                                            if (FaxUniqueId != "" && FaxUniqueId.ToLower() != "false")
                                                drClientMedicationScriptsActivity["FaxExternalIdentifier"] = FaxUniqueId;
                                            else
                                                drClientMedicationScriptsActivity["FaxExternalIdentifier"] = DBNull.Value;
                                        }
                                    }

                                #endregion
                            }
                            else if (OrderingMethod == "P")
                            {
                                #region Sending Results to printer

                                    if (icount == 0)
                                        FlagForImagesDeletion = true;
                                    else
                                        FlagForImagesDeletion = false;
                                    bool ans = SendToPrinter(
                                        Convert.ToInt32(dr[icount]["ClientMedicationScriptId"]),
                                        FlagForImagesDeletion, OrderingMethod);
                                    //Added Ref:Task No:2988
                                    if (sendPrint == false)
                                        sendPrint = ans;

                                #endregion
                            }
                            else
                            {
                                #region Update document for e-scripts
                                DataTable DataTableSureScriptsOutgoingMessages;
                                DataRow DataRowSureScriptsOutgoingMessages;
                                DataTableSureScriptsOutgoingMessages = DataSetClientScriptActivities.Tables["SureScriptsOutgoingMessages"];
                                DataRowSureScriptsOutgoingMessages = DataTableSureScriptsOutgoingMessages.NewRow();
                                DataRowSureScriptsOutgoingMessages["ClientMedicationScriptId"] = DataSetClientScriptActivities.Tables["ClientMedicationScriptActivities"].Rows[icount]["ClientMedicationScriptId"];
                                DataRowSureScriptsOutgoingMessages["MessageStatus"] = 5541;
                                DataRowSureScriptsOutgoingMessages["RowIdentifier"] = System.Guid.NewGuid();
                                DataRowSureScriptsOutgoingMessages["CreatedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                                DataRowSureScriptsOutgoingMessages["CreatedDate"] = DateTime.Now;
                                DataRowSureScriptsOutgoingMessages["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                                DataRowSureScriptsOutgoingMessages["ModifiedDate"] = DateTime.Now;
                                DataTableSureScriptsOutgoingMessages.Rows.Add(DataRowSureScriptsOutgoingMessages);
                                DataSetClientScriptActivities.Merge(DataTableSureScriptsOutgoingMessages);

                                #endregion
                            }

                        }

                        objClientMed = new ClientMedication();
                        objClientMed.UpdateDocuments(DataSetClientScriptActivities);

                        triplet.First = Session["OpenVerbalOrder"];
                        triplet.Second = scriptids;
                        triplet.Third = sendPrint;
                    }
                }
                //Added Ref:Task No:2988
                triplet.First = Session["OpenVerbalOrder"];
                triplet.Second = scriptids;
                triplet.Third = sendPrint;
            }
            else
            {
                // Attempt AD lookup
                MedicationLogin objMedicationLogin = null;
                objMedicationLogin = new Streamline.UserBusinessServices.MedicationLogin();
                DataSet userAuthenticationType = null;
                string authType = string.Empty;
                string enableADAuthentication = string.Empty;
                bool isValidUser = false;
                if ((SecureString)Session["ADPassword"] == null)
                {
                    var secureADPassword = new SecureString();
                    password.Trim().ToCharArray().ToList().ForEach(secureADPassword.AppendChar);
                    Session["ADPassword"] = secureADPassword;
                }

                try
                {
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

                        isValidUser =
                            objMedicationLogin.ADAuthenticateUser(
                                ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode,
                                unencryptedADPassword,
                                userAuthenticationType.Tables[
                                    "Authentication"]
                                    .Rows[0]["Domain"].ToString()
                                );
                        if (password.Trim() == unencryptedADPassword && isValidUser)
                        {
                            objClientMed = new ClientMedication();
                            DataSetClientScriptActivities =
                                new Streamline.UserBusinessServices.DataSets.DataSetClientScripts();
                            if (Session["dsVerbalOrder"] != null)
                            {
                                dataSetUpdate = objClientMed.UpdateDocuments((DataSet) Session["dsVerbalOrder"]);
                                DataRow[] dr =
                                    dataSetUpdate.Tables["ClientMedicationScripts"].Select(
                                        "WaitingPrescriberApproval='N'");
                                if (Session["OpenVerbalOrder"].ToString() == "A")
                                {
                                    for (int icount = 0; icount < dr.Length; icount++)
                                    {

                                        if (scriptids == "")
                                            scriptids = dr[icount]["ClientMedicationScriptId"].ToString();
                                        else
                                            scriptids += "," + dr[icount]["ClientMedicationScriptId"].ToString();
                                        ////Insert Rows into ClientScriptActivities

                                        OrderingMethod = !dr[icount]["OrderingMethod"].ToString().IsNullOrWhiteSpace()
                                            ? dr[icount]["OrderingMethod"].ToString()
                                            : OrderingMethod;

                                        DataRow drClientMedicationScriptsActivity =
                                            DataSetClientScriptActivities.Tables["ClientMedicationScriptActivities"]
                                                .NewRow();
                                        drClientMedicationScriptsActivity["ClientMedicationScriptId"] =
                                            dr[icount]["ClientMedicationScriptId"];
                                        //drClientMedicationScriptsActivity["Method"] = 'P';
                                        drClientMedicationScriptsActivity["Method"] = OrderingMethod;
                                        drClientMedicationScriptsActivity["PharmacyId"] = System.DBNull.Value;
                                        drClientMedicationScriptsActivity["Reason"] = System.DBNull.Value;
                                        drClientMedicationScriptsActivity["FaxStatusDate"] = DateTime.Now;
                                        drClientMedicationScriptsActivity["PharmacyId"] = dr[icount]["PharmacyId"];
                                        //drClientMedicationScriptsActivity["FaxStatus"] = System.DBNull.Value;
                                        //Added By Anuj on 24Feb for task ref #85
                                        if (OrderingMethod == "E")
                                        {
                                            drClientMedicationScriptsActivity["Status"] = 5561;
                                        }
                                        else if (OrderingMethod == "P")
                                        {
                                            drClientMedicationScriptsActivity["Status"] = System.DBNull.Value;
                                        }
                                        drClientMedicationScriptsActivity["StatusDescription"] = System.DBNull.Value;
                                        //Ended over here
                                        drClientMedicationScriptsActivity["FaxExternalIdentifier"] = System.DBNull.Value;
                                        drClientMedicationScriptsActivity["FaxImageData"] = renderedBytes;
                                        //if (CheckBoxPrintChartCopy.Checked == true)
                                        //    drClientMedicationScriptsActivity["IncludeChartCopy"] = "Y";
                                        //else
                                        drClientMedicationScriptsActivity["IncludeChartCopy"] = "N";

                                        drClientMedicationScriptsActivity["RowIdentifier"] = System.Guid.NewGuid();
                                        drClientMedicationScriptsActivity["CreatedBy"] =
                                            ((Streamline.BaseLayer.StreamlineIdentity) Context.User.Identity).UserCode;
                                        drClientMedicationScriptsActivity["CreatedDate"] = DateTime.Now;
                                        drClientMedicationScriptsActivity["ModifiedBy"] =
                                            ((Streamline.BaseLayer.StreamlineIdentity) Context.User.Identity).UserCode;
                                        drClientMedicationScriptsActivity["ModifiedDate"] = DateTime.Now;
                                        DataSetClientScriptActivities.Tables["ClientMedicationScriptActivities"].Rows
                                            .Add(
                                                drClientMedicationScriptsActivity);
                                        DataRow drClientMedicationScriptsActivityPending =
                                            DataSetClientScriptActivities.Tables[
                                                "ClientMedicationScriptActivitiesPending"].NewRow();
                                        drClientMedicationScriptsActivityPending["ClientMedicationScriptActivityId"] =
                                            drClientMedicationScriptsActivity["ClientMedicationScriptActivityId"]
                                                .ToString();
                                        drClientMedicationScriptsActivityPending["RowIdentifier"] = Guid.NewGuid();
                                        drClientMedicationScriptsActivityPending["CreatedBy"] =
                                            ((StreamlineIdentity) Context.User.Identity).UserCode;
                                        drClientMedicationScriptsActivityPending["CreatedDate"] = DateTime.Now;
                                        drClientMedicationScriptsActivityPending["ModifiedBy"] =
                                            ((StreamlineIdentity) Context.User.Identity).UserCode;
                                        drClientMedicationScriptsActivityPending["ModifiedDate"] = DateTime.Now;
                                        DataSetClientScriptActivities.Tables["ClientMedicationScriptActivitiesPending"]
                                            .Rows.Add(
                                                drClientMedicationScriptsActivityPending);

                                        //objClientMed.UpdateDocuments(DataSetClientScriptActivities);
                                        string HiddenFieldAllFaxed = "";
                                        bool _strScriptsTobeFaxedButPrinted = false;
                                        bool FlagForImagesDeletion = false;
                                        if (OrderingMethod == "F")
                                        {
                                            #region Sending Fax

                                            _strScriptsTobeFaxedButPrinted = false;
                                            string strSelectClause =
                                                "ISNULL(DrugCategory,0)=2  and  ClientMedicationScriptId=" +
                                                dr[icount]["ClientMedicationScriptId"].ToString();

                                            if (
                                                dataSetUpdate.Tables["ClientMedicationScriptDrugs"].Select(
                                                    strSelectClause)
                                                    .Length > 0)
                                            {
                                                _strScriptsTobeFaxedButPrinted = true;
                                                HiddenFieldAllFaxed = "0";

                                            }


                                            if (_strScriptsTobeFaxedButPrinted)
                                            {
                                                bool ans =
                                                    SendToPrinter(
                                                        Convert.ToInt32(dr[icount]["ClientMedicationScriptId"]),
                                                        FlagForImagesDeletion, OrderingMethod);
                                                //Added Ref:Task No:2988
                                                if (sendPrint == false)
                                                    sendPrint = ans;

                                            }

                                            else
                                            {
                                                if (dr[icount]["PharmacyId"] == null)
                                                    dr[icount]["PharmacyId"] = 0;
                                                string FaxUniqueId =
                                                    SendToFax(Convert.ToInt32(dr[icount]["ClientMedicationScriptId"]),
                                                        Convert.ToInt32(dr[icount]["PharmacyId"]),
                                                        FlagForImagesDeletion, OrderingMethod);
                                                //if (_strPrintChartCopy == "true" && ans1 == true)
                                                //    PrintChartCopy(Convert.ToInt32(dataSetUpdate.Tables[0].Rows[icount]["ClientMedicationScriptId"]));
                                                //Added Ref:Task No:2988
                                                bool ans1 = FaxUniqueId != "false";
                                                if (ans1 == false) //If Sending Fax failed
                                                {
                                                    PrintPrescription(
                                                        Convert.ToInt32(dr[icount]["ClientMedicationScriptId"]),
                                                        OrderingMethod);
                                                }
                                                //Added Ref:Task No:2988
                                                if (sendPrint == false)
                                                    sendPrint = ans1;
                                                if (
                                                    DataSetClientScriptActivities.Tables.Contains(
                                                        "ClientMedicationScriptActivities") &&
                                                    DataSetClientScriptActivities.Tables[
                                                        "ClientMedicationScriptActivities"].Select(
                                                            "ClientMedicationScriptId='" +
                                                            dr[icount]["ClientMedicationScriptId"] + "'").Any())
                                                {
                                                    using (
                                                        var _clientMedication = new ClientMedication())
                                                    {
                                                        _clientMedication.SetRenderedImageData(
                                                            DataSetClientScriptActivities,
                                                            drClientMedicationScriptsActivity,
                                                            ((StreamlineIdentity)
                                                                Context.User.Identity).UserCode, renderedBytes);
                                                    }
                                                    drClientMedicationScriptsActivity["FaxExternalIdentifier"] =
                                                        FaxUniqueId;

                                                    drClientMedicationScriptsActivity["Status"] = 5561;
                                                    drClientMedicationScriptsActivity["StatusDescription"] =
                                                        DBNull.Value;
                                                    if (FaxUniqueId != "" && FaxUniqueId.ToLower() != "false")
                                                        drClientMedicationScriptsActivity["FaxExternalIdentifier"] =
                                                            FaxUniqueId;
                                                    else
                                                        drClientMedicationScriptsActivity["FaxExternalIdentifier"] =
                                                            DBNull.Value;
                                                }
                                            }

                                            #endregion
                                        }
                                        else if (OrderingMethod == "P")
                                        {
                                            #region Sending Results to printer

                                            if (icount == 0)
                                                FlagForImagesDeletion = true;
                                            else
                                                FlagForImagesDeletion = false;
                                            bool ans = SendToPrinter(
                                                Convert.ToInt32(dr[icount]["ClientMedicationScriptId"]),
                                                FlagForImagesDeletion, OrderingMethod);
                                            //Added Ref:Task No:2988
                                            if (sendPrint == false)
                                                sendPrint = ans;

                                            #endregion
                                        }
                                        else
                                        {
                                            #region Update document for e-scripts

                                            DataTable DataTableSureScriptsOutgoingMessages;
                                            DataRow DataRowSureScriptsOutgoingMessages;
                                            DataTableSureScriptsOutgoingMessages =
                                                DataSetClientScriptActivities.Tables["SureScriptsOutgoingMessages"];
                                            DataRowSureScriptsOutgoingMessages =
                                                DataTableSureScriptsOutgoingMessages.NewRow();
                                            DataRowSureScriptsOutgoingMessages["ClientMedicationScriptId"] =
                                                DataSetClientScriptActivities.Tables["ClientMedicationScriptActivities"]
                                                    .Rows[icount
                                                    ]["ClientMedicationScriptId"];
                                            DataRowSureScriptsOutgoingMessages["MessageStatus"] = 5541;
                                            DataRowSureScriptsOutgoingMessages["RowIdentifier"] = System.Guid.NewGuid();
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
                                            DataSetClientScriptActivities.Merge(DataTableSureScriptsOutgoingMessages);

                                            #endregion
                                        }
                                    }
                                    objClientMed = new ClientMedication();
                                    objClientMed.UpdateDocuments(DataSetClientScriptActivities);

                                    triplet.First = Session["OpenVerbalOrder"];
                                    triplet.Second = scriptids;
                                    triplet.Third = sendPrint;
                                }
                            }
                            //Added Ref:Task No:2988
                            triplet.First = Session["OpenVerbalOrder"];
                            triplet.Second = scriptids;
                            triplet.Third = sendPrint;
                        }
                        else
                        {
                            //Added Ref:Task No:2988
                            triplet.First = Session["OpenVerbalOrder"];
                            triplet.Second = "InvalidPassword";
                            triplet.Third = sendPrint;
                        }
                    }
                    else
                    {
                        triplet.First = Session["OpenVerbalOrder"];
                        triplet.Second = "InvalidPassword";
                        triplet.Third = sendPrint;
                    }
                }
                catch (Exception ex)
                {
                    if (ex.Data["CustomExceptionInformation"] == null)
                        ex.Data["CustomExceptionInformation"] = "###Source Function Name - ClientMedicationsNonOrder --SaveOnSign(string OrderingMethod, string Password), ParameterCount -2 ###";
                    else
                        ex.Data["CustomExceptionInformation"] = "";
                    if (ex.Data["DatasetInfo"] == null)
                        ex.Data["DatasetInfo"] = null;

                    Streamline.BaseLayer.LogManager logManager = new LogManager();
                    logManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, "false");
                }
            }

            return triplet;
        }

        public string SendToFax(int ScriptId, int PharmacyId, bool FlagForImagesDeletion, string OrderingMethod)
        {
            #region Sending Fax
            try
            {
                string FaxUniqueId = "";
                GetRDLCContents(ScriptId, OrderingMethod);
                Streamline.Faxing.StreamlineFax _streamlineFax = new Streamline.Faxing.StreamlineFax();
                return _streamlineFax.SendFax(PharmacyId,
                    ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId,
                    (Server.MapPath("RDLC") + "\\" + Context.User.Identity.Name + "\\MedicationScript.pdf"),
                    "Prescription Medication Script");
            }
            catch (Exception ex)
            {
                throw (ex);
            }

            #endregion

        }


        public bool SendToPrinter(int ScriptId, bool FlagForImagesDeletion, string OrderingMethod)
        {
            #region Sending Results to printer
            // Declare objects
            DataSet DataSetTemp = null;
            try
            {
                DeleteImagesInDirectory = FlagForImagesDeletion;
                GetRDLCContents(ScriptId, OrderingMethod);

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

        public void PrintPrescription(int ScriptId, string OrderingMethod)
        {
            try
            {
                //RDLC to be rendered for Chart Copy of Faxed Document
                //Added by chandan on 21st Nov 2008 for creating report  
                try
                {
                    GetRDLCContents(ScriptId, OrderingMethod);
                    using (Streamline.BaseLayer.RDLCPrint objRDLC = new RDLCPrint())
                    {

                        objRDLC.Run(this.reportViewer1.LocalReport, Server.MapPath("~/RDLC/" + Context.User.Identity.Name), ScriptId.ToString(), false, false);
                    }
                }
                catch (Exception ex)
                {
                    //Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);

                }
                finally
                {
                }

            }
            catch (Exception ex)
            {
                //if (ex.Data["CustomExceptionInformation"] == null)
                //    ex.Data["CustomExceptionInformation"] = "Source function PrintPrescription() of Prescribe Screen";
                //else
                //    ex.Data["CustomExceptionInformation"] = "";
                //if (ex.Data["DatasetInfo"] == null)
                //    ex.Data["DatasetInfo"] = null;
                //Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);

            }

        }

        public string GetRDLCContents(int ScriptId, string OrderingMethod)
        {
            #region Get RDLC Contents
            DataSet dsClientMedicationScripts = new DataSet();
            dsClientMedicationScripts = (DataSet)(Session["dsVerbalOrder"]);
            DataRow[] dtRowClientMedicationScripts = dsClientMedicationScripts.Tables[0].Select("ClientMedicationScriptId=" + ScriptId);
            bool ToBeFaxed = false;
            bool FlagForImagesDeletion = true;
            //string OrderingMethod = dtRowClientMedicationScripts[0]["OrderingMethod"].ToString();
            string SendCoveLetter = "false";
            string _ReportPath = "";
            int LocationId = Convert.ToInt32(dtRowClientMedicationScripts[0]["LocationId"]);
            string mimeType;
            string encoding;
            string fileNameExtension;
            string[] streams;

            //Added by Chandan for the task 2404 -1.7.2 - Prescribe Page: Print Chart Copy
            string _PrintChartCopy = "N";



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

            //End
            //Block For ReportPath
            reportViewer1 = new Microsoft.Reporting.WebForms.ReportViewer();

            try
            {
                #region DeleteOldRenderedImages

                if (DeleteImagesInDirectory)
                {
                    try
                    {
                        using (Streamline.BaseLayer.RDLCPrint objRDLC = new RDLCPrint())
                        {
                            //objRDLC.DeleteRenderedImages(Server.MapPath("RDLC\\" + Context.User.Identity.Name));
                            objRDLC.DeleteRenderedImages(Server.MapPath("~/RDLC/" + Context.User.Identity.Name));
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

                #endregion
                _ReportPath = Server.MapPath("~") + System.Configuration.ConfigurationManager.AppSettings["MedicationPerscriptionReportUrl"];
                if (_ReportPath == "")//Check For Report Path
                {

                    throw new Exception("ReportPath is Missing In WebConfig");

                }
            }
            catch (Exception ex)
            {
                throw new Exception("ReportPath Key is Missing In WebConfig");

            }
            finally
            {
                objLogManager = null;

            }

            try
            {
                if (OrderingMethod == "F")
                {
                    ToBeFaxed = true;
                }

                //  _DataSetRdl = new DataSet();//Commented by Vikas Vyas On Dated March 04 2008
                Streamline.UserBusinessServices.ClientMedication objectClientMedications = null;
                objectClientMedications = new ClientMedication();
                //Added by Chandan for getting Location Id

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
                        _DataSetRdlForMainReport = objectClientMedications.GetDataForRdlC(_StoredProcedureName, ScriptId, _OrderingMethod, 1, LocationId, _PrintChartCopy, Session.SessionID, string.Empty);
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
                        //HiddenFieldStoredProcedureName.Value = _StoredProcedureName;
                        //HiddenFieldReportName.Value = _ReportName;

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
                                    _DataSetRdlForSubReport = objectClientMedications.GetDataForRdlC(_SubReportStoredProcedure, ScriptId, _OrderingMethod, 1, LocationId, _PrintChartCopy, Session.SessionID, string.Empty);

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

                if (ToBeFaxed == false)
                {
                    try
                    {
                        using (Streamline.BaseLayer.RDLCPrint objRDLC = new RDLCPrint())
                        {
                            //In case of Ordering method as X Chart copy will be printed
                            if (OrderingMethod == "X")
                                objRDLC.Run(this.reportViewer1.LocalReport, Server.MapPath("~/RDLC/" + Context.User.Identity.Name), ScriptId.ToString(), FlagForImagesDeletion, true);
                            else  //In case of Ordering method as P Chart copy will not be printed
                                objRDLC.Run(this.reportViewer1.LocalReport, Server.MapPath("~/RDLC/" + Context.User.Identity.Name), ScriptId.ToString(), FlagForImagesDeletion, false);

                            //Added by Rohit. Ref ticket#84
                            renderedBytes = reportViewer1.LocalReport.Render(reportType, deviceInfo, out mimeType, out encoding, out fileNameExtension, out streams, out warnings);
                            //ShowReport(Session["imgId"].ToString());
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
                    finally
                    {
                        objLogManager = null;
                    }

                }
                //if (ToBeFaxed)//Commented by Vikas Vyas In ref to 2334
                else
                {
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
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "";
                else
                    ex.Data["CustomExceptionInformation"] = "";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
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
            return ShowReport(ScriptId.ToString());
            #endregion
        }

        #endregion
        #region--Code written by Pradeep as per task#23
        [WebMethod(EnableSession = true)]
        public void UpdatePrinterDeviceLocation(string locationId, string printerDeviceLocationId)
        {
            DataSet DataSetStaffLocations = null;
            DataRow[] DataRowStaffLocations = null;
            DataRow DataRowNewStaffLocations = null;
            try
            {
                if (Session["DataSetPermissionsList"] != null)
                {
                    DataSetStaffLocations = (DataSet)(Session["DataSetPermissionsList"]);
                    if (DataSetStaffLocations.Tables["StaffLocations"].Rows.Count > 0)
                    {
                        DataRowStaffLocations = DataSetStaffLocations.Tables["StaffLocations"].Select("LocationId=" + locationId + "And StaffId=" + ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId);
                        if (DataRowStaffLocations.Length > 0)
                        {
                            DataRowStaffLocations[0]["PrinterDeviceLocationId"] = Convert.ToInt32(printerDeviceLocationId);
                        }
                        else
                        {
                            //Create New row
                            DataRowNewStaffLocations = DataSetStaffLocations.Tables["StaffLocations"].NewRow();
                            DataRowNewStaffLocations["RowIdentifier"] = System.Guid.NewGuid();
                            DataRowNewStaffLocations["StaffId"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId;
                            DataRowNewStaffLocations["LocationId"] = Convert.ToInt32(locationId);
                            DataRowNewStaffLocations["PrinterDeviceLocationId"] = Convert.ToInt32(printerDeviceLocationId);
                            DataRowNewStaffLocations["CreatedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                            DataRowNewStaffLocations["CreatedDate"] = System.DateTime.Now;
                            DataRowNewStaffLocations["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                            DataRowNewStaffLocations["ModifiedDate"] = System.DateTime.Now;
                            DataSetStaffLocations.Tables["StaffLocations"].Rows.Add(DataRowNewStaffLocations);
                        }
                    }
                    else
                    {
                        //Create New row
                        DataRowNewStaffLocations = DataSetStaffLocations.Tables["StaffLocations"].NewRow();
                        DataRowNewStaffLocations["RowIdentifier"] = System.Guid.NewGuid();
                        DataRowNewStaffLocations["StaffId"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId;
                        DataRowNewStaffLocations["LocationId"] = Convert.ToInt32(locationId);
                        DataRowNewStaffLocations["PrinterDeviceLocationId"] = Convert.ToInt32(printerDeviceLocationId);
                        DataRowNewStaffLocations["CreatedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                        DataRowNewStaffLocations["CreatedDate"] = System.DateTime.Now;
                        DataRowNewStaffLocations["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                        DataRowNewStaffLocations["ModifiedDate"] = System.DateTime.Now;
                        DataSetStaffLocations.Tables["StaffLocations"].Rows.Add(DataRowNewStaffLocations);
                    }
                }
                Session["DataSetPermissionsList"] = DataSetStaffLocations;
            }
            catch (Exception ex)
            {
                throw (ex);
            }
        }
        [WebMethod(EnableSession = true)]
        public void EditDefaultPrescribingLocation(string locationId)
        {
            DataSet DataSetStaff = null;
            DataRow[] dataRowStaff = null;
            try
            {
                if (Session["DataSetPermissionsList"] != null)
                {
                    DataSetStaff = (DataSet)(Session["DataSetPermissionsList"]);
                    if (DataSetStaff.Tables["Staff"].Rows.Count > 0)
                    {
                        DataSetStaff.Tables["Staff"].Rows[0]["DefaultPrescribingLocation"] = Convert.ToInt32(locationId);
                    }
                }
                Session["DataSetPermissionsList"] = DataSetStaff;
            }
            catch (Exception ex)
            {
                throw (ex);
            }
        }
        [WebMethod(EnableSession = true)]
        public void EditStaffLocations(string LocationId, string AssignCheckBoxStatus, string DefaultCheckBoxStatus)
        {
            DataSet DataSetPermissionList = null;//
            DataRow[] DataRowStaffLocation = null;


            try
            {
                string locationId = LocationId;
                int staffId = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId;
                if (Session["DataSetPermissionsList"] != null)
                {
                    DataSetPermissionList = (DataSet)(Session["DataSetPermissionsList"]);
                    DataRowStaffLocation = DataSetPermissionList.Tables["StaffLocations"].Select("LocationId=" + locationId + "And StaffId=" + staffId);
                    if (AssignCheckBoxStatus == "Assign Not Checked")
                    {
                        if (DataRowStaffLocation.Length > 0)
                        {
                            DataRowStaffLocation[0]["RecordDeleted"] = "Y";
                            DataRowStaffLocation[0]["DeletedDate"] = DateTime.Now;
                            DataRowStaffLocation[0]["DeletedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;

                        }
                        if (DefaultCheckBoxStatus == "Default Checked")
                        {
                            DataSetPermissionList.Tables["Staff"].Rows[0]["DefaultPrescribingLocation"] = DBNull.Value;
                            DataSetPermissionList.Tables["Staff"].Rows[0]["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                            DataSetPermissionList.Tables["Staff"].Rows[0]["ModifiedDate"] = System.DateTime.Now;
                        }
                    }
                    if (AssignCheckBoxStatus == "Assign Checked")
                    {
                        if (DataRowStaffLocation.Length > 0)
                        {
                            DataRowStaffLocation[0]["RecordDeleted"] = "N";
                            DataRowStaffLocation[0]["DeletedDate"] = DateTime.Now;
                            DataRowStaffLocation[0]["DeletedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                        }
                        else
                        {
                            DataRow dataRowStaffLocation = DataSetPermissionList.Tables["StaffLocations"].NewRow();
                            dataRowStaffLocation["RowIdentifier"] = System.Guid.NewGuid();
                            dataRowStaffLocation["StaffId"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId;
                            dataRowStaffLocation["LocationId"] = Convert.ToInt32(LocationId);
                            dataRowStaffLocation["CreatedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                            dataRowStaffLocation["CreatedDate"] = System.DateTime.Now;
                            dataRowStaffLocation["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                            dataRowStaffLocation["ModifiedDate"] = System.DateTime.Now;
                            DataSetPermissionList.Tables["StaffLocations"].Rows.Add(dataRowStaffLocation);
                        }
                    }
                }
                Session["DataSetPermissionsList"] = DataSetPermissionList;


            }
            catch (Exception ex)
            {
                throw (ex);
            }
        }
        #endregion--Code written by Pradeep as per task#23

        [WebMethod(EnableSession = true)]
        public DataTable FillRXSource()
        {
            DataSet ds = Streamline.UserBusinessServices.SharedTables.DataSetGlobalCodes.Clone();
            ds.Merge(Streamline.UserBusinessServices.SharedTables.DataSetGlobalCodes.Tables[0].Select("Category='NONORDERMEDSSOURCE' And ISNULL(RecordDeleted,'N')='N'"));
            return ds.Tables[0];
        }
    }
}
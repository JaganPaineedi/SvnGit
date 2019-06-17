
using System;
using System.Web;
using System.Web.Services;
using System.Xml;
using System.Web.Services.Protocols;
using System.Web.Script.Services;
using System.Data;
using Streamline.BaseLayer;
using System.Web.Script.Serialization;



namespace Streamline.SmartClient.WebServices
{
    /// <summary>
    /// Summary description for CommonService
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [ScriptService]
    public class CommonService : Streamline.BaseLayer.WebServices.WebServiceBasePage 
    {

        public CommonService()
        {
            base.Initialize(); 
            //Uncomment the following line if using designed components 
            //InitializeComponent(); 
            if (Session["UserContext"] == null)
            {            
                throw new Exception("Session Expired");                
            }
        }
        /// <summary>
        /// function which calculates the end date in medications 
        /// </summary>
        /// <param name="startDate"></param>
        /// <param name="days"></param>
        /// <param name="refill"></param>
        /// <returns>string as formated date</returns>
        [WebMethod(EnableSession = true)]
        public string CalculateEndDate(string sDate, int days, Decimal refill)
            {
            try
                {

                DateTime startDate = Convert.ToDateTime(sDate);
                DateTime endDate;

                //Formula changed as per Task 2377 SC-Support
                //endDate = startDate.AddDays(days);
                //endDate = endDate.AddDays(days * Convert.ToInt32(refill));


                //Formula changed by sonia for 
                //Task 1.5.1 #37 - New Order, Refill, Change Order: End Date Calcuation
                //Calculation of EndDate changed as per New Logic
                //Commented by Loveena in ref to Task#2582
                //endDate = startDate.AddDays(days * (Convert.ToInt32(refill) + 1));
                //Formula changes end here

                //Added by Chandan on 25th Nov 2008 for set date format as MM/DD/YYYY for End date
                //Task#106 New Medication: Date format should be same

                //return String.Format("{0:d}", endDate);
                //Added by Loveena in ref to Task#2582
                int MedicationRxEndDateOffset = 0;
                if (Streamline.UserBusinessServices.SharedTables.DataSetMedicationRxEndDateOffset.Tables[0].Rows[0]["MedicationRxEndDateOffset"] != System.DBNull.Value)
                    MedicationRxEndDateOffset = Convert.ToInt32(Streamline.UserBusinessServices.SharedTables.DataSetMedicationRxEndDateOffset.Tables[0].Rows[0]["MedicationRxEndDateOffset"]);
                //Modified in ref to Task#2633
                //endDate = startDate.AddDays((days - 1) + MedicationRxEndDateOffset);   
                //Modified as ref to Task#2633 for Final EndDate Calculation
                //double value= (Convert.ToInt32(refill)+1)*((days-1)+MedicationRxEndDateOffset);
                double value = Convert.ToDouble(refill) + (Convert.ToDouble(refill) + 1) * (days - 1);
                startDate = startDate.AddDays(value);
                endDate = startDate.AddDays(MedicationRxEndDateOffset);
                //code ends over here.
                return endDate.ToString("MM/dd/yyyy");



                }
            catch (Exception ex)
                {
                return "";
                }
            }

        //Code added by Loveena in ref to Task#2633
        [WebMethod(EnableSession = true)]
        public string CalculateTitrationEndDate(string sDate, int days, Decimal refill)
            {
            try
                {

                DateTime startDate = Convert.ToDateTime(sDate);
                DateTime endDate;


                int MedicationRxEndDateOffset = 0;
                if (Streamline.UserBusinessServices.SharedTables.DataSetMedicationRxEndDateOffset.Tables[0].Rows[0]["MedicationRxEndDateOffset"] != System.DBNull.Value)
                    MedicationRxEndDateOffset = Convert.ToInt32(Streamline.UserBusinessServices.SharedTables.DataSetMedicationRxEndDateOffset.Tables[0].Rows[0]["MedicationRxEndDateOffset"]);
                //endDate = startDate.AddDays((days - 1) + MedicationRxEndDateOffset);
                double value = Convert.ToDouble(refill) + (Convert.ToDouble(refill) + 1) * (days - 1);
                startDate = startDate.AddDays(value);
                endDate = startDate.AddDays(MedicationRxEndDateOffset);
                return endDate.ToString("MM/dd/yyyy");
                }
            catch (Exception ex)
                {
                return "";
                }
            }
        [WebMethod(EnableSession = true)]
        public string CalculateStartDate(string eDate)
            {
            try
                {

                DateTime endDate = Convert.ToDateTime(eDate);
                DateTime startDate;
                //Added by Loveena in ref to Task#2585
                int MedicationRxEndDateOffset = 0;
                if (Streamline.UserBusinessServices.SharedTables.DataSetMedicationRxEndDateOffset.Tables[0].Rows[0]["MedicationRxEndDateOffset"] != System.DBNull.Value)
                    MedicationRxEndDateOffset = Convert.ToInt32(Streamline.UserBusinessServices.SharedTables.DataSetMedicationRxEndDateOffset.Tables[0].Rows[0]["MedicationRxEndDateOffset"]);
                if (MedicationRxEndDateOffset > 0)
                    MedicationRxEndDateOffset = 0;
                else
                    MedicationRxEndDateOffset = 1;
                startDate = endDate.AddDays(MedicationRxEndDateOffset);
                return startDate.ToString("MM/dd/yyyy");



                }
            catch (Exception ex)
                {
                return "";
                }
            }

        [WebMethod(EnableSession = true)]
        public int DeductPharmacy(int Pharma,int Sample,int Stock)
        {
            try
            {               
                if (Sample.ToString() == "")
                    Sample = 0;
                if (Stock.ToString() == "")
                    Stock = 0;                
                Pharma = Pharma - Sample - Stock;
                return Pharma;

            }
            catch (Exception ex)
            {
                return 0;
            }
        }
        /// <summary>
        /// function which calculates the Pharmacy in medications 
        /// </summary>
        /// <param name="startDate"></param>
        /// <param name="days"></param>
        /// <param name="refill"></param>
        /// <returns>refill</returns>
        /// Changes in arguments Made as per Task 2361 SC-Support
        [WebMethod(EnableSession = true)]
        public decimal CalculatePharmacy(int days, Decimal Quantity, String Schedule, Decimal Sample, Decimal Stock)
        {
            try
            {                
                float _GlobalCodeMedicationScheduleExternalCode = 0;
                Decimal Pharma;
                DataRow[] DataRowGlobalCodeMedicationSchedule = Streamline.UserBusinessServices.SharedTables.DataSetGlobalCodes.Tables[0].Select("Category='MEDICATIONSCHEDULE' and GlobalCodeId=" + Schedule.ToString());
                if (DataRowGlobalCodeMedicationSchedule.Length > 0)                    
                    if (DataRowGlobalCodeMedicationSchedule[0]["ExternalCode1"].ToString() == "")
                        _GlobalCodeMedicationScheduleExternalCode = 0;
                    else
                        _GlobalCodeMedicationScheduleExternalCode =(float)Convert.ToDouble(DataRowGlobalCodeMedicationSchedule[0]["ExternalCode1"].ToString());
                else
                    _GlobalCodeMedicationScheduleExternalCode = 1;

                // Pharma = days * Quantity * _GlobalCodeMedicationScheduleExternalCode;
                //Formula changed as per Task 2361 SC-Support
                //Pharama calculation logic changed as per 2377 SC-Support
                //Pharma=Math.Round(Convert.ToDecimal((float)(Quantity) * (float)(days) * (float)(_GlobalCodeMedicationScheduleExternalCode))-(Sample+Stock),2);
                Pharma = Math.Round(Convert.ToDecimal((float)(Quantity) * (float)(days) * (float)(_GlobalCodeMedicationScheduleExternalCode)), 2);

                return Math.Ceiling(Pharma); // Added By PranayB w.r.t  AHN-Support Go Live: #135 RX

            }
            catch (Exception ex)
            {
                return 0;
            }
        }
        //[WebMethod]
        //public void SaveAllergyData(string AllergyId)
        //{
           
        //    try
        //    {
        //        //throw (new Exception("hello")); 

        //        Streamline.UserBusinessServices.DataSets.DataSetClientAllergies DataSetClientAllergies;
        //        DataView DataViewClientAllergies;
        //        DataRowView DataRowClientAllergies;
        //        Streamline.UserBusinessServices.ClientMedication objectClientMedications;
        //        DataSet DataSetFinal;
        //        string selectedValue = AllergyId;
        //        DataSetClientAllergies = new Streamline.UserBusinessServices.DataSets.DataSetClientAllergies();
        //        DataViewClientAllergies = DataSetClientAllergies.Tables["ClientAllergies"].DefaultView;
        //        DataViewClientAllergies.AddNew();
        //        DataRowClientAllergies = DataViewClientAllergies[0];
        //        DataRowClientAllergies["ClientAllergyId"] = 0;
        //        // DataRowClientAllergies["ClientId"] = Convert.ToInt32(Streamline.UserBusinessServices.ApplicationCommonFunctions._ClientId);
        //        DataRowClientAllergies["ClientId"] = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId;
               
        //        DataRowClientAllergies["AllergenConceptId"] = selectedValue;
        //        DataRowClientAllergies["CreatedBy"] = Convert.ToInt32(((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode);
        //        DataRowClientAllergies["CreatedDate"] = DateTime.Now;
        //        DataRowClientAllergies["ModifiedBy"] = Convert.ToInt32(((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode);
        //        DataRowClientAllergies["ModifiedDate"] = DateTime.Now;
        //        DataRowClientAllergies["RecordDeleted"] = 'N';
        //        DataRowClientAllergies["RowIdentifier"] = System.Guid.NewGuid();
        //        DataRowClientAllergies.EndEdit();
        //        objectClientMedications = new Streamline.UserBusinessServices.ClientMedication();
        //        DataSetFinal = objectClientMedications.UpdateClientAllergies(DataSetClientAllergies);
        //    }
        //    catch (Exception ex)
        //    {
        //        // Added by Pratap In order to Implement Exception Management functionality on 29th June 2007
        //        if (ex.Data["CustomExceptionInformation"] == null)
        //            ex.Data["CustomExceptionInformation"] = "";

        //        string ParseMessage = ex.Message;
        //        if (ParseMessage.IndexOf("System.Data.SqlClient.SqlException:") > 0)
        //        {
        //            int SubstringLen = ParseMessage.IndexOf("\n") - ParseMessage.IndexOf("System.Data.SqlClient.SqlException:");
        //            ParseMessage = ParseMessage.Substring(ParseMessage.IndexOf("System.Data.SqlClient.SqlException:") + 35, SubstringLen - 35);
        //            //  ShowError(ParseMessage, true);
        //        }
        //       // throw (ex);
        //    }
        //    finally
        //    {
        //        //DataViewClientAllergies = null;
        //        //DataSetClientAllergies = null;
        //        //DataRowClientAllergies = null;
        //    }

        //}


        //[WebMethod(EnableSession = true)]
        //public DataTable  serialize()
        //{
        //    Streamline.UserBusinessServices.DataSets.Test.ProductDataTable dtTemp = new Streamline.UserBusinessServices.DataSets.Test.ProductDataTable();
        //    DataRow drTeemp = dtTemp.NewRow();
        //    drTeemp["ProductId"] = 1;
        //    drTeemp["ProductName"]="Sony";
        //    dtTemp.Rows.Add(drTeemp);
        //    return dtTemp;
        //}
        [WebMethod(EnableSession = true)]
        [GenerateScriptType(typeof(DataTable))]
        public void serializeT(System.Data.DataTable dstTemp)
        {

            DataTable dt = dstTemp;
        }


        public class ProductData
        {
            public ProductData()
            {
                
            }

            private int _productId;

            public int ProductId
            {
                get { return _productId; }
                set { _productId = value; }
            }

            private string _productName;

            public string ProductName
            {
                get { return _productName; }
                set { _productName = value; }
            }

        }

        [WebMethod(EnableSession = true)]
        [GenerateScriptType(typeof(ProductData))]

        public void serializedatatable(ProductData dsTemp)
        {
            foreach (System.Reflection.PropertyInfo  prop in dsTemp.GetType().GetProperties())
            {
               
 
            }    
        }

        [WebMethod(EnableSession=true)]
        public void GetMedication()
        {
            

        }


        //public void SetDetailsForPatientConsentDetail(int medicationNameId,int DocumentVersionId)
        //{
        //    try
        //    {
        //        Session["MedicationIdsForConsentDetailPage"] = null;
        //        Session["VersionIdForConsentDetailPage"] = null;
        //        Session["MedicationIdsForConsentDetailPage"]=medicationNameId;
        //        Session["VersionIdForConsentDetailPage"] = DocumentVersionId;
        //    }
        //    catch (Exception ex)
        //    {
        //        throw ex;
        //    }
        //}
            //modified rEf:Task no:2975
        [WebMethod(EnableSession = true)]
        public string SetDetailsForPatientConsentDetail(int medicationNameId, int DocumentVersionId)
        {
            DataRow[] dr = null;
            string clientMedicationIds = "";
            try
            {
                Session["MedicationIdsForConsentDetailPage"] = null;
                Session["VersionIdForConsentDetailPage"] = null;
                Session["MedicationIdsForConsentDetailPage"] = medicationNameId;
                Session["VersionIdForConsentDetailPage"] = DocumentVersionId;
                Session["ChangedOrderMedicationIds"] = null;
                if (Session["DataSetConsentMedicationHistory"] != null)
                {
                    DataSet dataSetConsnetHistory = (DataSet)Session["DataSetConsentMedicationHistory"];
                    dr = dataSetConsnetHistory.Tables["ClientMedicationInstructions"].Select("DocumentVersionId=" + DocumentVersionId);
                    if (dr.Length > 0)
                    {
                        for (int index = 0; index < dr.Length; index++)
                        {
                            if (clientMedicationIds == "")
                            {
                                clientMedicationIds += Convert.ToString(dr[index]["ClientMedicationId"]);
                            }
                            else
                            {
                                clientMedicationIds += "," + Convert.ToString(dr[index]["ClientMedicationId"]);
                            }
                        }

                    }

                }
                Session["ChangedOrderMedicationIds"] = clientMedicationIds;
                return clientMedicationIds;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        //Ref to Task#2590
        [WebMethod(EnableSession = true)]
        public string CheckExistingMedication(int medicationNameId)
        {
        try
            {
            Streamline.UserBusinessServices.DataSets.DataSetClientMedications DataSet1 = null;
            if (Session["DataSetClientMedications"] != null)
                {
                DataSet1 = (Streamline.UserBusinessServices.DataSets.DataSetClientMedications)Session["DataSetClientMedications"];
                if (DataSet1.ClientMedications.Select("MedicationNameId=" + medicationNameId + " and DrugCategory=2").Length > 0)
                    {
                    return "Selected medication already exists in Medication List";
                    }
                }
            return "";
            }
        catch (Exception ex)   
            {
            
            throw ex;
            }
        }


        //Added by Loveena in ref to Task#16
        [WebMethod(EnableSession = true)]
        public string GetSystemReportsMedHistory(string _ReportName, string StartDate, string EndDate, string MedicationNameId)
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
                    if (_ReportName == "Medications - View Client Consent History")
                    {
                        ReportUrl = ReportUrl.Replace("<ClientId>", (((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId).ToString());
                        ReportUrl = ReportUrl.Replace("<StartDate>", StartDate.ToString());
                        ReportUrl = ReportUrl.Replace("<EndDate>", EndDate.ToString());                        
                        ReportUrl = ReportUrl.Replace("<Medication>", MedicationNameId.ToString());                        
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
        #region---Code Written By Pradeep
        /// <summary>
        /// <Description>Used to log errorMessage</Description>
        /// <Author>Pradeep</Author>
        /// <CreatedOn>Jan 6,2010</CreatedOn>
        /// </summary>
        /// <param name="errorMessage"></param>
        /// <param name="errorType"></param>
        /// <param name="DatasetWhichGenratedException"></param>
        [WebMethod(EnableSession = true)]
        public void WriteToDatabase(string errorMessage, string errorType, System.Data.DataSet DatasetWhichGenratedException)
        {
           try
            {
                System.Data.DataSet dsError = new System.Data.DataSet();
                System.Data.DataTable DtErrorMessage = new System.Data.DataTable("ErrorMessages");
                System.Data.DataRow drError = DtErrorMessage.NewRow();
                DtErrorMessage.Columns.Add("ErrorMessage");
                DtErrorMessage.Columns.Add("VerboseInfo");
                DtErrorMessage.Columns.Add("DatasetInfo");
                DtErrorMessage.Columns.Add("ErrorType");
                DtErrorMessage.Columns.Add("CreatedBy");
                DtErrorMessage.Columns.Add("CreatedDate");

                drError["ErrorMessage"] = errorMessage;// FilteredEntry;

                drError["VerboseInfo"] = "";// VerboseInformation;

                if (DatasetWhichGenratedException != null)
                    drError["DatasetInfo"] = DatasetWhichGenratedException.GetXml();
                else
                    drError["DatasetInfo"] = null;
                drError["ErrorType"] = errorType;
                drError["CreatedBy"] = "sa";//Streamline.ProviderAccess.CommonFunctions.UserName;
                drError["CreatedDate"] = DateTime.Now;
                DtErrorMessage.Rows.Add(drError);
                dsError.Tables.Add(DtErrorMessage);

                
                Streamline.DataService.StaticLogManager.WriteToDatabase(dsError);
            }
            catch (Exception ex)
            {
                Streamline.DataService.StaticLogManager.WriteToDatabase(ex.Message.ToString(), "In Exception handling of Global.asax", "General", "sa");
                string msg = ex.Message;
                //throw ex;
            }

        }
        #endregion

    }
}
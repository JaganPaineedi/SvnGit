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
using Microsoft.VisualBasic;
using System.IO;
using System.Reflection;
using System.Xml.Serialization;
using System.Runtime.Serialization.Formatters.Binary;
using System.Collections.Generic;
using System.Diagnostics;
using Telerik.Web.UI;
using GROWTHCHARTLib;
using System.Linq;
using System.Xml.Linq;
using System.Xml.Xsl;
using System.Runtime.InteropServices;
using System.Web.Security;
using System.Security;
using Newtonsoft.Json;

namespace Streamline.SmartClient.WebServices
{
    /// <summary>
    /// Summary description for ClientMedications
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.Web.Script.Services.ScriptService]
    public class ClientMedications : Streamline.BaseLayer.WebServices.WebServiceBasePage
    {
        private string _sigString = string.Empty;

        public ClientMedications()
        {
            try
            {
                base.Initialize();
                //Uncomment the following line if using designed components 
                //InitializeComponent(); 
                //Code added by Chandan for Session TimeOut
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

        [WebMethod(EnableSession = true)]
        public EnumerableRowCollection GetMedicationStrength(int MedicationNameId)
        {
            Streamline.UserBusinessServices.ClientMedication ObjClientMedication = new Streamline.UserBusinessServices.ClientMedication();
            return from strength in ObjClientMedication.MedicationStrength(MedicationNameId).Tables[0].AsEnumerable()
                   select new
                   {
                       Strength = strength.Field<string>("Strength"),
                       MedicationId = strength.Field<int>("MedicationId"),
                       ExternalMedicationId = strength.Field<int>("ExternalMedicationId"),
                       PotencyUnitCode = strength.Field<string>("PotencyUnitCode")
                   };
        }
        /// <summary>
        /// Author Sonia Dhamija
        /// Purpose To set the DateFormat
        /// During testing found that some error was coming when we set the Date format from AjaxScript file
        /// </summary>
        /// <param name="DateToBeSet"></param>
        /// <returns></returns>
        [WebMethod(EnableSession = true)]
        public string SetDateFormat1(string DateToBeSet)
        {
            DateTime dt;
            try
            {
                dt = Convert.ToDateTime(DateToBeSet);
                if (dt.Year > 1753 && dt.Year < 9999)
                    return dt.ToString("MM/dd/yyyy");
                else
                    throw new ArgumentOutOfRangeException();
            }
            catch (Exception ex)
            {
                return "";
            }
        }

        [WebMethod(EnableSession = true)]
        public DataTable GetDataTable()
        {
            DataTable dt = new DataTable();
            dt.Columns.Add(new DataColumn("ID", typeof(int)));
            dt.Columns.Add(new DataColumn("Text", typeof(string)));

            Random random = new Random(DateTime.Now.Millisecond);
            for (int i = 0; i < 10; i++)
            {
                dt.Rows.Add(i, random.Next().ToString());
            }

            return dt;
        }
        [WebMethod(EnableSession = true)]
        //public int DiscontinueMedication(int Medication, int MedicationScriptId, string DiscontinueReason, char disContinued, string DiscontinueReasonCode)
        public int DiscontinueMedication(
            int Medication, int MedicationScriptId, string DiscontinueReason, char disContinued,
            int DiscontinueReasonCode, int ClientMedicationConsentId, string SureScriptsOutgoingMessageId, string OrderName,int PharmacyId)
        {
            Streamline.UserBusinessServices.ClientMedication objClientMedications = null;
            DataSet dataSetClientSummary = null;
            try
            {
                objClientMedications = new Streamline.UserBusinessServices.ClientMedication();
                if (DiscontinueReason == string.Empty)
                    DiscontinueReason = "NULL";
                objClientMedications.DiscontinueMedication(
                    Medication, disContinued, ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode,
                    DiscontinueReason, DiscontinueReasonCode, ClientMedicationConsentId, SureScriptsOutgoingMessageId,
                    OrderName, ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId,PharmacyId);
                //Code modified by Ankesh Bharti in Ref to Task #2409
                //SetOrderDetailsMedicationIdForMainPage(Medication);
                SetOrderDetailsMedicationIdForMainPage(Medication, MedicationScriptId);
                //Code added by Loveena in ref to Task# dated 25 Aug 2009 to refresh the Session["DataSetClientSummary"]
                string _ClientRowIdentifier = "";
                string _ClinicianrowIdentifier = "";
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
                    dataSetClientSummary = objClientMedications.DownloadClientMedicationSummary(_ClientRowIdentifier, _ClinicianrowIdentifier);
                    //commented By anuj on 23 oct,2009(As session dataset will be refresh after printing Fax/print)
                    Session["DataSetClientSummary"] = dataSetClientSummary;
                    //Changes Ended over here
                }
                return 1;
            }
            catch (Exception ex)
            {

                return -1;
            }
            finally
            {
                objClientMedications = null;
            }
        }

        [WebMethod(EnableSession = true)]
        public DataTable FillDxPurpose()
        {
            DataSet DataSetDxPurpose = null;
            DataSetDxPurpose = new DataSet();
            DataTable dtTemp = null;
            DataRow[] drtemp = null;

            if (System.Configuration.ConfigurationSettings.AppSettings["ExternalInterface"].ToString().ToUpper() == "TRUE" && Session["ExternalClientInformation"] != null)
            {
                DataSetDxPurpose = (DataSet)Session["ExternalClientInformation"];
                dtTemp = DataSetDxPurpose.Tables["ClientDiagnosis"].Clone();
                drtemp = DataSetDxPurpose.Tables["ClientDiagnosis"].Select("", "DSMDescription");
            }
            else
            {
                ClientMedication objClientMedication = new ClientMedication();
                DataSetDxPurpose.Merge(objClientMedication.ClientMedicationDxPurpose(((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId));
                dtTemp = DataSetDxPurpose.Tables[0].Clone();
                drtemp = DataSetDxPurpose.Tables[0].Select("", "DSMDescription");
            }

            dtTemp.Columns.Add("GlobalCode");
            foreach (DataRow row in drtemp)
            {
                DataRow drNew = dtTemp.NewRow();
                drNew.ItemArray = row.ItemArray;
                dtTemp.Rows.Add(drNew);
            }

            DataRow dr = dtTemp.NewRow();
            #region "Code modified by Loveena in ref to Task#2547 1.9.5.3 Dx Purpose Drop Down Changes"
            DataRow[] dtRow = Streamline.UserBusinessServices.SharedTables.DataSetGlobalCodes.Tables[0].Select("Category = 'MEDICATIONPURPOSE' and Active='Y' and ISNULL(RecordDeleted,'N')<>'Y'");

            for (int index = 0; index < dtRow.Length; index++)
            {
                dr = dtTemp.NewRow();
                dr["DxId"] = dtRow[index]["CodeName"].ToString() + "_" + 0;
                dr["DSMCode"] = System.DBNull.Value;
                dr["DSMDescription"] = dtRow[index]["CodeName"].ToString();
                dr["DSMNumber"] = 0;

                dtTemp.Rows.Add(dr);
            }

            #endregion
            DataView DataViewDxPurpose = dtTemp.DefaultView;
            return DataViewDxPurpose.Table.Copy();

        }

        [WebMethod(EnableSession = true)]
        public DataTable FillPrescriber()
        {
            DataSet DataSetPrimaryStaff = new DataSet();
            DataRow[] DataRowRestStaff = null;

            DataRow[] DataRowStaff = Streamline.UserBusinessServices.SharedTables.DataSetStaffTable.Tables[0].Select("Prescriber = 'Y' and Active = 'Y' And StaffId=" + ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId);
            DataSetPrimaryStaff.Merge(DataRowStaff);
            if (DataRowStaff.Length > 0)
            {
                DataRowRestStaff = Streamline.UserBusinessServices.SharedTables.DataSetStaffTable.Tables[0].Select("Prescriber = 'Y' and Active = 'Y' And StaffId<>" + ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId, "StaffName");
            }
            else
            {
                DataRowRestStaff = Streamline.UserBusinessServices.SharedTables.DataSetStaffTable.Tables[0].Select("Prescriber = 'Y' and Active = 'Y' ", "StaffName");
            }
            DataSetPrimaryStaff.Merge(DataRowRestStaff);

            DataTable dtTemp = null;

            return DataSetPrimaryStaff.Tables[0];
        }

        [WebMethod(EnableSession = true)]
        public EnumerableRowCollection FillSchedule()
        {
            return
                from schedule in
                    Streamline.UserBusinessServices.SharedTables.DataSetGlobalCodes.Tables[0].AsEnumerable()
                where schedule.Field<string>("Category").Trim() == "MEDICATIONSCHEDULE" && (schedule.Field<string>("ExternalCode2") == null || schedule.Field<string>("ExternalCode2").Trim().ToUpper() == "Y")
                orderby schedule.Field<int>("SortOrder")
                select new
                    {
                        CodeName = schedule.Field<string>("CodeName"),
                        GlobalCodeId = schedule.Field<int>("GlobalCodeId"),
                        ExternalCode1 = schedule.Field<string>("ExternalCode1")
                    };
        }

        [WebMethod(EnableSession = true)]
        public string GetFormularyInformation(string ExternalMedicationNameId, string ExternalMedicationId, string CoverageReqId)
        {
            Streamline.DataService.SharedTables objSharedTables = new Streamline.DataService.SharedTables();
            if (Streamline.UserBusinessServices.SharedTables.DataSetSystemConfigurationKeys != null)
            {
                if (Streamline.UserBusinessServices.SharedTables.DataSetSystemConfigurationKeys.Tables.Count > 0)
                {
                    string enableFormulary = objSharedTables.GetSystemConfigurationKeys("RXEnableFormulary", Streamline.UserBusinessServices.SharedTables.DataSetSystemConfigurationKeys.Tables[0]);
                    if (enableFormulary.ToLower() != "y" || (((Streamline.BaseLayer.StreamlinePrinciple)Context.User).HasPermission(Permissions.DrugFormulary)) != true)
                    {
                        return "";
                    }
                }
            }

            string returnMessage = "";
            if (Session["DataSetClientSummary"] != null)
            {
                SureScriptsServices sureScriptsServices = new SureScriptsServices();
                DataSet clientSummary = (DataSet)Session["DataSetClientSummary"];
                if (clientSummary.Tables.Contains("FormularyRequestInformation") &&
                    clientSummary.Tables["FormularyRequestInformation"].Rows.Count > 0 && clientSummary.Tables["FormularyRequestInformation"].Rows[0]["FormularyRequestXML"] != null)
                {
                    string response = sureScriptsServices.GetFormularyInformation(ExternalMedicationNameId, ExternalMedicationId, CoverageReqId, clientSummary.Tables["FormularyRequestInformation"].Rows[0]["FormularyRequestXML"].ToString());
                    try
                    {
                        XslCompiledTransform xsltProc = new XslCompiledTransform();
                        xsltProc.Load(Server.MapPath("~/App_Themes/Includes/Style/Formulary.xslt"));
                        using (StringReader sr = new StringReader(response))
                        {
                            using (XmlReader xr = XmlReader.Create(sr))
                            {
                                using (StringWriter sw = new StringWriter())
                                {
                                    xsltProc.Transform(xr, null, sw);
                                    returnMessage = sw.ToString();
                                }
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        returnMessage = "";
                    }

                }
                else
                {
                    returnMessage = "";
                }
            }
            return returnMessage;
        }


        [WebMethod(EnableSession = true)]
        public string GetNarxInformation()
        {

            string returnMessage = string.Empty;

            DataSet dataSetRequest;
            Streamline.UserBusinessServices.ClientMedication obj = new Streamline.UserBusinessServices.ClientMedication();
            dataSetRequest = obj.GetClientRequestXMLForPMP(((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId, ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId);

            if (dataSetRequest.Tables.Count > 0 && dataSetRequest.Tables["ClientRequestXMLDetails"].Rows.Count > 0)
            {
                int PMPAuditTrailId = 0;
                int.TryParse(dataSetRequest.Tables["ClientRequestXMLDetails"].Rows[0]["PMPAuditTrailId"].ToString(), out PMPAuditTrailId);
                string XMLRequest = dataSetRequest.Tables["ClientRequestXMLDetails"].Rows[0]["RequestXML"].ToString();
                string PMPWebServiceURL = dataSetRequest.Tables["ClientRequestXMLDetails"].Rows[0]["PMPWebServiceURL"].ToString();
                string PMPWebServiceUname = dataSetRequest.Tables["ClientRequestXMLDetails"].Rows[0]["PMPWebServiceUname"].ToString();
                string PMPWebServicePassword = dataSetRequest.Tables["ClientRequestXMLDetails"].Rows[0]["PMPWebServicePassword"].ToString();
                string OrganizationCode = dataSetRequest.Tables["ClientRequestXMLDetails"].Rows[0]["OrganizationCode"].ToString();

                PMPGateWayServices objPMPGateWayServices = new PMPGateWayServices();
                string response = objPMPGateWayServices.GetNarxInformation(PMPWebServiceURL, PMPWebServiceUname, PMPWebServicePassword, XMLRequest, OrganizationCode, "Patient", "");
                if (response.Contains("error: (400)"))
                {
                    returnMessage = "Error: Patient Request is invalid, Please verify Staff DEA Number, NPI Number which is Primary, Agency Location Address, Client Phone number, Client SSN Number.";
                }
                else if (response.Contains("error: (401)"))
                {
                    returnMessage = "Error: Access denied, Please check if Web Service URL/User Name/Password/Organization Code are valid.";
                }
                else
                {
                    DataSet dataSetReportURL = obj.UpdateResponseXMLDetails(PMPAuditTrailId, response);
                    String ReportURL = dataSetReportURL.Tables["PMPAuditTrails"].Rows[0]["ReportURL"].ToString();
                    String PatientResponseErrorMsg = dataSetReportURL.Tables["PMPAuditTrails"].Rows[0]["PatientResponseErrorMsg"].ToString();

                    if (ReportURL != "" && PatientResponseErrorMsg == "")
                    {
                        String ReportRequestXML = dataSetReportURL.Tables["PMPAuditTrails"].Rows[0]["ReportRequestMessageXML"].ToString();
                        string ReportResponseXML = objPMPGateWayServices.GetNarxInformation(PMPWebServiceURL, PMPWebServiceUname, PMPWebServicePassword, ReportRequestXML, OrganizationCode, "REPORT", ReportURL);
                        if (ReportResponseXML.Contains("error: (403)"))
                        {
                            returnMessage = "Error: Report request is requesting a report created by a different licensee.";
                        }
                        else if (ReportResponseXML.Contains("error: (404)"))
                        {
                            returnMessage = "Error: No report request exists for that URL.";
                        }
                        else if (ReportResponseXML.Contains("error: (410)"))
                        {
                            returnMessage = "Error: Report has already been delivered. Report links can only be used once. Report Request URL has expired.";
                        }
                        else
                        {
                            dataSetReportURL = obj.GetPMPReportURL(PMPAuditTrailId, ReportResponseXML);
                            returnMessage = dataSetReportURL.Tables["PMPAuditTrails"].Rows[0]["ReportURL"].ToString();
                            if (returnMessage == "")
                            {
                                returnMessage = dataSetReportURL.Tables["PMPAuditTrails"].Rows[0]["ErrorMessage"].ToString();
                            }
                        }
                    }
                    else if (PatientResponseErrorMsg != "")
                    {
                        returnMessage = "Error: " + PatientResponseErrorMsg;
                    }

                }
            }
            else
            {
                returnMessage = "Error: Web Service Configuration is missing, Please check for Web Service URL/User Name/Password/Organization Code";
            }
            return returnMessage;
        }


//Added by Pranay.B W.R.T MeaningFulUse-Stage3
        [WebMethod(EnableSession = true)]
        public string GetChangeMedicationOrderList(string SureScriptsChangeRequestId) 
        {
            Streamline.UserBusinessServices.ClientMedication objectClientMedications = new  Streamline.UserBusinessServices.ClientMedication();
        
            DataSet ds = objectClientMedications.GetChangeMedicationOrderList(SureScriptsChangeRequestId);
          
            string returnMessage = "";
            foreach(DataRow dr in ds.Tables[0].Rows )
            {
            XslCompiledTransform xsltProc = new XslCompiledTransform();
            xsltProc.Load(Server.MapPath("~/App_Themes/Includes/Style/ChangeOrder.xslt"));
            string response=dr["ChangeOrderMedicationListXML"].ToString();
                using (StringReader sr = new StringReader(response))
                {
                    using (XmlReader xr = XmlReader.Create(sr))
                    {
                        using (StringWriter sw = new StringWriter())
                        {
                            xsltProc.Transform(xr, null, sw);
                            returnMessage += sw.ToString();
                        }
                    }
                }
            }
           return returnMessage;
           
        }

        [WebMethod(EnableSession = true)]
        public string GetClientEducationNDC(string MedicationNameId)
        {
            string returnMessage = "";

            ClientMedication objClientMedication = new ClientMedication();
            DataSet ds = objClientMedication.GetClientEducationNDC(MedicationNameId);
            if (ds.Tables["NDC"].Rows.Count > 0)
            {
                returnMessage = ds.Tables["NDC"].Rows[0]["NationalDrugCode"].ToString();
            }
            return returnMessage;
        }

        [WebMethod(EnableSession = true)]
        public EnumerableRowCollection FillPotencyUnitCodes(int MedicationNameId)
        {
            if (Session["potencyunitcode_medicationnameid"] != null &&
                Session["potencyunitcode_medicationnameid"].ToString() == MedicationNameId.ToString())
            {
                return (EnumerableRowCollection)Session["potencyunitcode_list"];
            }
            var clientMedication = new Streamline.UserBusinessServices.ClientMedication();
            EnumerableRowCollection puc =
                from potencyunitcode in
                    clientMedication.FillPotencyUnitCodesByMedicationNameId(MedicationNameId).Tables["PotencyUnitCodes"].AsEnumerable()
                select new
                    {
                        SureScriptsCode = potencyunitcode.Field<string>("SureScriptsCode"),
                        SmartCareRxCode = potencyunitcode.Field<string>("SmartCareRxCode")
                    };
            Session["potencyunitcode_medicationnameid"] = MedicationNameId.ToString();
            Session["potencyunitcode_list"] = puc;
            return puc;
        }

        [WebMethod(EnableSession = true)]
        public EnumerableRowCollection FillMedicationRelatedInformation(int MedicationId, int ClientId)
        {
            EnumerableRowCollection mri = null;
            if (Session["medicationRelatedInformation_medicationid"] != null &&
                Session["medicationRelatedInformation_medicationid"].ToString() == MedicationId.ToString())
            {
                return (EnumerableRowCollection)Session["medicationRelatedInformation_list"];
            }
            var clientMedication = new Streamline.UserBusinessServices.ClientMedication();
            DataSet MedicationRelatedInformation = clientMedication.FillMedicationRelatedInformation(MedicationId, ClientId);
            if (MedicationRelatedInformation.Tables.Count > 0)
            {
                if (MedicationRelatedInformation.Tables["MedicationRelatedInformation"].Rows.Count > 0)
                {
                    mri =
                       from medicationRelatedInformation in
                           MedicationRelatedInformation.Tables["MedicationRelatedInformation"].AsEnumerable()
                       select new
                       {
                           //SpecialInstructions = medicationRelatedInformation.Field<string>("SpecialInstructions"),
                           //DesiredOutcomes = medicationRelatedInformation.Field<string>("DesiredOutcomes"),
                           Comments = medicationRelatedInformation.Field<string>("Comments"),
                           IncludeCommentOnPrescription = medicationRelatedInformation.Field<string>("IncludeCommentOnPrescription"),
                       };
                    Session["medicationRelatedInformation_medicationid"] = MedicationId.ToString();
                    Session["medicationRelatedInformation_list"] = mri;
                }
            }
            return mri;
        }

        [WebMethod(EnableSession = true)]
        public EnumerableRowCollection FillUnit(int MedicationId)
        {
            if (Session["units_medicationid"] != null &&
                Session["units_medicationid"].ToString() == MedicationId.ToString())
            {
                return (EnumerableRowCollection)Session["units_list"];
            }

            Streamline.UserBusinessServices.ClientMedication ObjClientMedication = new Streamline.UserBusinessServices.ClientMedication();
            EnumerableRowCollection units = from unit in ObjClientMedication.MedicationUnit(MedicationId).Tables[0].AsEnumerable()
                                            select
                                                new
                                                    {
                                                        CodeName = unit.Field<string>("CodeName"),
                                                        GlobalCodeId = unit.Field<int>("GlobalCodeId")
                                                    };
            Session["units_medicationid"] = MedicationId.ToString();
            Session["units_list"] = units;
            return units;
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

            private Int32 _ExternalMedicationNameId;
            public Int32 ExternalMedicationNameId { get { return _ExternalMedicationNameId; } set { _ExternalMedicationNameId = value; } }

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
            private Char _Ordered;

            public Char Ordered
            {
                get { return _Ordered; }
                set { _Ordered = value; }
            }

            private string _VerbalOrderReadBack;
            public string VerbalOrderReadBack
            {
                get { return _VerbalOrderReadBack; }
                set { _VerbalOrderReadBack = value; }
            }

            private Int32 _StaffLicenseDegreeId;
            public Int32 StaffLicenseDegreeId
            {
                get { return _StaffLicenseDegreeId; }
                set { _StaffLicenseDegreeId = value; }
            }

            private string _OrderDate;
            public string OrderDate
            {
                get { return _OrderDate; }
                set { _OrderDate = value; }
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

            private string _DrugCategory;

            public string DrugCategory
            {
                get { return _DrugCategory; }
                set { _DrugCategory = value; }
            }

            private string _DAW;

            public string DAW
            {
                get { return _DAW; }
                set { _DAW = value; }
            }

            private Int32 _MedicationId;
            public Int32 MedicationId
            {
                get { return _MedicationId; }
                set { _MedicationId = value; }
            }

            private string _TitrateMode;
            public string TitrateMode
            {
                get { return _TitrateMode; }
                set { _TitrateMode = value; }
            }
            private string _TitrationType;
            public string TitrationType
            {
                get { return _TitrationType; }
                set { _TitrationType = value; }
            }

            //Added by Loveena in ref to Task#2433 to add new fields to New Order MM-1.9.
            private string _DesiredOutcome;
            public string DesiredOutcome
            {
                get { return _DesiredOutcome; }
                set { _DesiredOutcome = value; }
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
            //code added by Loveena iends over here.
            //----Start Code Written By Pradeep as per task#31
            private string _PermitChangesByOtherUsers;
            public string PermitChangesByOtherUsers
            {
                get { return _PermitChangesByOtherUsers; }
                set { _PermitChangesByOtherUsers = value; }
            }
            //---End Code Written By Pradeep as per task#31
            //Code added by Loveena in ref to Task#32
            private string _IncludeOnPrescription;
            public string IncludeOnPrescription
            {
                get { return _IncludeOnPrescription; }
                set { _IncludeOnPrescription = value; }
            }
            private string _PlanName;
            public string PlanName
            {
                get { return _PlanName; }
                set { _PlanName = value; }
            }            //Code ends over here.
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

            private string _Instruction;
            public string Instruction
            {
                get { return _Instruction; }
                set { _Instruction = value; }
            }
            private string _TitrateSummary;
            public string TitrateSummary
            {
                get { return _TitrateSummary; }
                set { _TitrateSummary = value; }
            }
            private string _RowIdentifierCMI;
            public string RowIdentifierCMI
            {
                get { return _RowIdentifierCMI; }
                set { _RowIdentifierCMI = value; }
            }
            private Int32 _TitrationStep;
            public Int32 TitrationStep
            {
                get { return _TitrationStep; }
                set { _TitrationStep = value; }
            }

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

            private string _PotencyUnitCode;
            public string PotencyUnitCode
            {
                get { return _PotencyUnitCode; }
                set { _PotencyUnitCode = value; }
            }

            private string _NoOfDaysOfWeek;
            public string NoOfDaysOfWeek
            {
                get { return _NoOfDaysOfWeek; }
                set { _NoOfDaysOfWeek = value; }
            }
        }
        #endregion
        /// <summary>
        /// 
        /// </summary>
        /// <param name="objClientMedication"></param>
        /// <param name="objClientMedicationInstructions"></param>
        /// <param name="method"></param>
        /// <param name="saveTemplateFlag"></param>
        /// <returns></returns>
        /// -----------Modification History--------------------------
        /// Date----------Author-----------Purpose-------------------
        /// 20 Nov 2009   Pradeep          Made changes as per task#31 
        [WebMethod(EnableSession = true)]
        [GenerateScriptType(typeof(ClientMedicationRow))]
        [GenerateScriptType(typeof(ClientMedicationInstructionRow))]
        public string SaveMedicationRow(ClientMedicationRow objClientMedication, ClientMedicationInstructionRow[] objClientMedicationInstructions, string method, string saveTemplateFlag)
        {
            DataSet DataSetPrescibedMedications = null;
            string _MedicationStartDate = "";
            string _MedicationEndDate = "";
            int MedicationNameId = 0;
            int StrengthId = 0;


            Streamline.SmartClient.WebServices.CommonService objectCommonService = null;
            try
            {
                bool newRowCM = false;
                bool newRowCMI = false;
                bool newRowCMSD = false;
                bool newRowCMSDS = false;
                bool newRowCMSDD = false;
                MedicationNameId = objClientMedication.MedicationNameId;
                StrengthId = objClientMedicationInstructions[0].StrengthId;
                bool modifyCM = !string.IsNullOrEmpty(objClientMedication.RowIdentifierCM);
                bool modifyCMI = !string.IsNullOrEmpty(objClientMedicationInstructions[0].RowIdentifierCMI);


                objectCommonService = new CommonService();
                Streamline.UserBusinessServices.DataSets.DataSetClientMedications dsClientMedications = null;
                // Create dataset for Order templates
                Streamline.UserBusinessServices.DataSets.DataSetDrugOrderTemplates dsDrugOrderTemplates = null;

                int iMinClientMedicationInstructionId = 0;

                if (Session["DataSetClientMedications"] != null)
                    dsClientMedications = (Streamline.UserBusinessServices.DataSets.DataSetClientMedications)Session["DataSetClientMedications"];
                else
                    dsClientMedications = new Streamline.UserBusinessServices.DataSets.DataSetClientMedications();

                dsDrugOrderTemplates = Streamline.UserBusinessServices.UserInfo.GetDrugOrderTemplates(((StreamlineIdentity)Context.User.Identity).UserId);

                DataTable DataTableClientMedications = dsClientMedications.ClientMedications;
                DataTable DataTableClientMedicationInstructions = dsClientMedications.ClientMedicationInstructions;

                if (method.Trim().ToUpper() == "CHANGE" || method.Trim().ToUpper() == "REFILL")
                {
                    foreach (DataRow drClientMedications in DataTableClientMedications.Select("MedicationNameId = '" + MedicationNameId + "' AND RowIdentifier='" + objClientMedication.RowIdentifierCM + "'"))
                    {
                        foreach (DataRow drClientMedicationInstructions in DataTableClientMedicationInstructions.Select("ClientMedicationId= '" + drClientMedications["ClientMedicationId"] + "'"))
                        {
                            DataRow[] DrArrCheck = dsClientMedications.ClientMedicationScriptDrugs.Select("ClientMedicationInstructionId ='" + drClientMedicationInstructions["ClientMedicationInstructionId"] + "'");
                            foreach (DataRow DrCheck in DrArrCheck)
                            {
                                dsClientMedications.ClientMedicationScriptDrugs.Rows.Remove(DrCheck);
                            }
                        }
                    }
                }
                DataTable DataTableClientMedicationScriptDrugs = dsClientMedications.ClientMedicationScriptDrugs;
                DataTable DataTableClientMedicationScriptDrugStrengths = dsClientMedications.ClientMedicationScriptDrugStrengths;
                DataTable DataTableClientMedicationScripts = dsClientMedications.ClientMedicationScripts;
                DataTable DataTableDrugOrderTemplates = dsDrugOrderTemplates.DrugOrderTemplates;
                DataTable DataTableClientMedicationScriptDispenseDays = dsClientMedications.ClientMedicationScriptDispenseDays;


                foreach (DataRow drClientMedications in DataTableClientMedications.Select("MedicationNameId = '" + MedicationNameId + "' ")) //Checks for Same Drug and Strength #Pranay
                {
                    foreach (DataRow drClientMedicationInstructions in DataTableClientMedicationInstructions.Select("ClientMedicationId= '" + drClientMedications["ClientMedicationId"] + "'"))
                    {
                        int StrengthId1 = Convert.ToInt32(drClientMedicationInstructions["StrengthId"]);
                        if (StrengthId1 == StrengthId && modifyCMI == false)
                        {
                            return "Cannot add Medication to order, a medication with same Drug and Strength already exists.";
                        }
                    }
                }

                if (saveTemplateFlag == "Save") // New template being saved
                {
                    // Check to make sure that a template doesn't already exist for this Staff/Drug/Strength
                    if (DataTableDrugOrderTemplates.Select("ISNULL(RecordDeleted, 'N') = 'N' AND MedicationId=" +
                                                           objClientMedicationInstructions[0].StrengthId).Length > 0)
                    {
                        return
                            "A template has already been saved for this Drug/Strength.  Please use the Override function instead.";
                    }
                    else
                    {
                        // Create new template data row
                        var DataRowDrugOrderTemplate = DataTableDrugOrderTemplates.NewRow();
                        DataRowDrugOrderTemplate["CreatedBy"] = ((StreamlineIdentity)Context.User.Identity).UserCode;
                        DataRowDrugOrderTemplate["CreatedDate"] = DateTime.Now;
                        DataRowDrugOrderTemplate["ModifiedBy"] = ((StreamlineIdentity)Context.User.Identity).UserCode;
                        DataRowDrugOrderTemplate["ModifiedDate"] = DateTime.Now;
                        DataRowDrugOrderTemplate["PrescriberId"] = ((StreamlineIdentity)Context.User.Identity).UserId;
                        DataRowDrugOrderTemplate["MedicationId"] = objClientMedicationInstructions[0].StrengthId;
                        DataRowDrugOrderTemplate["MedicationNameId"] = objClientMedication.MedicationNameId;
                        DataRowDrugOrderTemplate["Strength"] = objClientMedicationInstructions[0].StrengthId;
                        DataRowDrugOrderTemplate["Quantity"] = objClientMedicationInstructions[0].Quantity;
                        DataRowDrugOrderTemplate["Unit"] = objClientMedicationInstructions[0].Unit;
                        DataRowDrugOrderTemplate["Days"] = objClientMedicationInstructions[0].Days;
                        DataRowDrugOrderTemplate["Schedule"] = objClientMedicationInstructions[0].Schedule;
                        DataRowDrugOrderTemplate["Refills"] = objClientMedicationInstructions[0].Refills;
                        DataRowDrugOrderTemplate["DispenseQuantity"] = objClientMedicationInstructions[0].Pharmacy;
                        DataRowDrugOrderTemplate["DispenseQuantityText"] = objClientMedicationInstructions[0].PharmaText;
                        DataRowDrugOrderTemplate["Comment"] = objClientMedication.Comments;
                        DataRowDrugOrderTemplate["IncludeOnPrescription"] = objClientMedication.IncludeOnPrescription;
                        DataTableDrugOrderTemplates.Rows.Add(DataRowDrugOrderTemplate);

                        var objUserInfo = new UserBusinessServices.UserInfo();
                        objUserInfo.UpdateDrugOrderTemplates(dsDrugOrderTemplates);
                    }
                }
                else if (saveTemplateFlag == "Override") // Update existing template here
                {
                    if (
                        DataTableDrugOrderTemplates.Select("ISNULL(RecordDeleted, 'N') = 'N' AND MedicationId=" +
                                                           objClientMedicationInstructions[0].StrengthId).Length > 0)
                    {

                        // Get the template data row to be updated
                        var DataRowDrugOrderTemplate =
                            DataTableDrugOrderTemplates.Select("ISNULL(RecordDeleted, 'N') = 'N' AND MedicationId=" +
                                                               objClientMedicationInstructions[0].StrengthId)[0];

                        DataRowDrugOrderTemplate["CreatedBy"] = ((StreamlineIdentity)Context.User.Identity).UserCode;
                        DataRowDrugOrderTemplate["CreatedDate"] = DateTime.Now;
                        DataRowDrugOrderTemplate["ModifiedBy"] = ((StreamlineIdentity)Context.User.Identity).UserCode;
                        DataRowDrugOrderTemplate["ModifiedDate"] = DateTime.Now;
                        DataRowDrugOrderTemplate["PrescriberId"] = ((StreamlineIdentity)Context.User.Identity).UserId;
                        DataRowDrugOrderTemplate["MedicationId"] = objClientMedicationInstructions[0].StrengthId;
                        DataRowDrugOrderTemplate["MedicationNameId"] = objClientMedication.MedicationNameId;
                        DataRowDrugOrderTemplate["Strength"] = objClientMedicationInstructions[0].StrengthId;
                        DataRowDrugOrderTemplate["Quantity"] = objClientMedicationInstructions[0].Quantity;
                        DataRowDrugOrderTemplate["Unit"] = objClientMedicationInstructions[0].Unit;
                        DataRowDrugOrderTemplate["Days"] = objClientMedicationInstructions[0].Days;
                        DataRowDrugOrderTemplate["Schedule"] = objClientMedicationInstructions[0].Schedule;
                        DataRowDrugOrderTemplate["Refills"] = objClientMedicationInstructions[0].Refills;
                        DataRowDrugOrderTemplate["DispenseQuantity"] = objClientMedicationInstructions[0].Pharmacy;
                        DataRowDrugOrderTemplate["DispenseQuantityText"] = objClientMedicationInstructions[0].PharmaText;
                        DataRowDrugOrderTemplate["Comment"] = objClientMedication.Comments;
                        DataRowDrugOrderTemplate["IncludeOnPrescription"] = objClientMedication.IncludeOnPrescription;

                        var objUserInfo = new UserBusinessServices.UserInfo();
                        objUserInfo.UpdateDrugOrderTemplates(dsDrugOrderTemplates);
                    }
                    else
                    {
                        return
                            "Couldn't override template. Template not found.";
                    }
                }

                // determine if the logged in staff is allowed to modify a refill or changed order
                if (method.Trim().ToUpper() == "CHANGE" || method.Trim().ToUpper() == "REFILL")
                {
                    string _loggedInUserId = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId.ToString();
                    DataRow[] NotCorrectPrescriber =
                        DataTableClientMedications.Select("RowIdentifier='" + objClientMedication.RowIdentifierCM + "' AND isnull(PermitChangesByOtherUsers,'Y') = 'N' and PrescriberId<>" + _loggedInUserId);

                    if (NotCorrectPrescriber.Length > 0)
                    {
                        return "This Medication does not allow changes by other prescribers";
                    }
                }

                //For Client Medication
                if (objClientMedication.RowIdentifierCM == null || objClientMedication.RowIdentifierCM == "")
                    objClientMedication.RowIdentifierCM = "-1";

                // retrieve the row that is being changed from the dataset
                DataRow[] _tempClientMedications = DataTableClientMedications.Select("RowIdentifier='" + objClientMedication.RowIdentifierCM + "'");
                DataRow DataRowClientMedication;
                if (_tempClientMedications.Length > 0)
                {
                    DataRowClientMedication = _tempClientMedications[0];
                    newRowCM = false;
                }
                else
                {
                    int iMinClientMedicationId = 0;
                    int iMinClientMedicationIdFromPrescribedMedications = 0;
                    DataRowClientMedication = DataTableClientMedications.NewRow();

                    if (DataTableClientMedications.Rows.Count > 0)
                    {
                        iMinClientMedicationId = GetMinValue(Convert.ToInt32(DataTableClientMedications.Compute("Min(ClientMedicationId)", "")));
                    }
                    if (Session["DataSetPrescribedClientMedications"] != null)
                    {
                        DataSetPrescibedMedications = (DataSet)Session["DataSetPrescribedClientMedications"];
                        if (DataSetPrescibedMedications.Tables["ClientMedications"].Rows.Count > 0)
                            iMinClientMedicationIdFromPrescribedMedications = GetMinValue(Convert.ToInt32(DataSetPrescibedMedications.Tables["ClientMedications"].Compute("Min(ClientMedicationId)", "")));

                        if (iMinClientMedicationIdFromPrescribedMedications <= iMinClientMedicationId)
                        {
                            iMinClientMedicationId = iMinClientMedicationIdFromPrescribedMedications;
                        }

                        if (DataSetPrescibedMedications.Tables["ClientMedicationInstructions"].Rows.Count > 0)
                            iMinClientMedicationInstructionId = GetMinValue(Convert.ToInt32(DataSetPrescibedMedications.Tables["ClientMedicationInstructions"].Compute("Min(ClientMedicationInstructionId)", "")));

                    }
                    DataRowClientMedication["ClientMedicationId"] = iMinClientMedicationId;
                    newRowCM = true;
                }

                DataRowClientMedication["MedicationNameId"] = objClientMedication.MedicationNameId;
                DataRowClientMedication["ExternalMedicationNameId"] = objClientMedication.ExternalMedicationNameId;
                DataRowClientMedication["DrugPurpose"] = objClientMedication.DrugPurpose;
                DataRowClientMedication["DSMCode"] = objClientMedication.DSMCode;
                DataRowClientMedication["DSMNumber"] = Convert.ToDecimal(objClientMedication.DSMNumber);
                DataRowClientMedication["DxId"] = (objClientMedication.DxId);
                DataRowClientMedication["PrescriberName"] = objClientMedication.PrescriberName;
                DataRowClientMedication["PrescriberId"] = objClientMedication.PrescriberId;
                DataRowClientMedication["Ordered"] = "Y";
                DataRowClientMedication["PermitChangesByOtherUsers"] = objClientMedication.PermitChangesByOtherUsers;
                //As MedicationStartDate should not be changed in case of REFILL.
                if (method.ToUpper() != "REFILL")
                {
                    _MedicationStartDate = DataRowClientMedication["MedicationStartDate"].ToString();
                }
                else
                    DataRowClientMedication["MedicationEndDateForDisplay"] = System.DBNull.Value;

                _MedicationEndDate = DataRowClientMedication["MedicationEndDate"].ToString();
                DataRowClientMedication["MedicationEndDate"] = System.DBNull.Value;

                //In case value is blank then NULL should be inserted in DB for Special Instructions field
                if (objClientMedication.SpecialInstructions.ToString().Trim() != "")
                    DataRowClientMedication["SpecialInstructions"] = objClientMedication.SpecialInstructions;
                else
                    DataRowClientMedication["SpecialInstructions"] = System.DBNull.Value;

                if (objClientMedication.Comments.ToString().Trim() != "")
                    DataRowClientMedication["Comments"] = objClientMedication.Comments;
                else
                    DataRowClientMedication["Comments"] = System.DBNull.Value;

                if (objClientMedication.DesiredOutcome.ToString().Trim() != "")
                    DataRowClientMedication["DesiredOutcomes"] = objClientMedication.DesiredOutcome;
                else
                    DataRowClientMedication["DesiredOutcomes"] = System.DBNull.Value;

                DataRowClientMedication["OffLabel"] = objClientMedication.OffLabel;
                DataRowClientMedication["IncludeCommentOnPrescription"] = objClientMedication.IncludeOnPrescription;
                DataRowClientMedication["MedicationName"] = objClientMedication.MedicationName;
                DataRowClientMedication["ClientId"] = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId;
                DataRowClientMedication["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                DataRowClientMedication["ModifiedDate"] = DateTime.Now;
                DataRowClientMedication["RecordDeleted"] = System.DBNull.Value;
                DataRowClientMedication["DeletedBy"] = DBNull.Value;
                DataRowClientMedication["DeletedDate"] = DBNull.Value;
                DataRowClientMedication["MedicationName"] = objClientMedication.MedicationName;
                DataRowClientMedication["DAW"] = objClientMedication.DAW;
                DataRowClientMedication["DrugCategory"] = objClientMedication.DrugCategory;
                if (newRowCM == true)
                {
                    DataRowClientMedication["RowIdentifier"] = System.Guid.NewGuid();
                    DataRowClientMedication["CreatedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                    DataRowClientMedication["CreatedDate"] = DateTime.Now;
                    DataTableClientMedications.Rows.Add(DataRowClientMedication);
                }

                //for clientMedicationScripts
                DataRow drClientMedicationScripts;
                bool newRowCS = false;
                if (DataTableClientMedicationScripts.Rows.Count > 0)
                    drClientMedicationScripts = DataTableClientMedicationScripts.Rows[0];
                else
                {
                    drClientMedicationScripts = DataTableClientMedicationScripts.NewRow();
                    newRowCS = true;
                }

                drClientMedicationScripts["Clientid"] = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId;
                drClientMedicationScripts["OrderingMethod"] = "P";
                drClientMedicationScripts["PharmacyId"] = System.DBNull.Value;
                drClientMedicationScripts["PrintDrugInformation"] = System.DBNull.Value;
                drClientMedicationScripts["ScriptCreationDate"] = DateTime.Now;
                drClientMedicationScripts["OrderDate"] = objClientMedication.OrderDate;
                drClientMedicationScripts["LocationId"] = System.DBNull.Value;
                drClientMedicationScripts["ScriptEventType"] = "C";
                drClientMedicationScripts["OrderingPrescriberId"] = 731;
                drClientMedicationScripts["OrderingPrescriberName"] = "dnf";
                drClientMedicationScripts["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                drClientMedicationScripts["ModifiedDate"] = DateTime.Now;
                drClientMedicationScripts["VerbalOrderReadBack"] = objClientMedication.VerbalOrderReadBack;
                drClientMedicationScripts["StaffLicenseDegreeId"] = objClientMedication.StaffLicenseDegreeId;
                if (objClientMedication.PlanName != null)
                {
                    drClientMedicationScripts["PlanName"] = objClientMedication.PlanName;
                }
                if (newRowCS)
                {
                    drClientMedicationScripts["ScriptEventType"] = "N";
                    drClientMedicationScripts["RowIdentifier"] = System.Guid.NewGuid();
                    drClientMedicationScripts["CreatedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                    drClientMedicationScripts["CreatedDate"] = DateTime.Now;
                    DataTableClientMedicationScripts.Rows.Add(drClientMedicationScripts);
                }

                foreach (ClientMedicationInstructionRow row in objClientMedicationInstructions)
                {
                    DataRow DataRowClientMedInstructions;
                    string EndDate = (objClientMedication.DrugCategory != "2") ?
                        objectCommonService.CalculateEndDate(row.StartDate, row.Days, row.Refills) :
                        objectCommonService.CalculateEndDate(row.StartDate, row.Days, 0);
                    if (ValidateSampleStock(row.Days, row.Quantity, row.Schedule, row.Sample, row.Stock) == false)
                    {
                        if (_MedicationStartDate != "")
                            DataRowClientMedication["MedicationStartDate"] = Convert.ToDateTime(_MedicationStartDate);

                        if (_MedicationEndDate != "")
                            DataRowClientMedication["MedicationEndDate"] = Convert.ToDateTime(_MedicationEndDate);
                    }

                    if (row.RowIdentifierCMI == null || row.RowIdentifierCMI == "")
                        row.RowIdentifierCMI = "-1";

                    DataRow[] _tempInstructions = DataTableClientMedicationInstructions.Select("RowIdentifier='" + row.RowIdentifierCMI + "'");
                    if (_tempInstructions.Length > 0)
                    {
                        DataRowClientMedInstructions = _tempInstructions[0];
                        DataRowClientMedInstructions["InformationComplete"] = "";
                        if (method.ToUpper() != "REFILL")
                        {
                            newRowCMI = false;
                        }
                        else
                        {
                            newRowCMI = true;
                            _tempInstructions[0]["Active"]="N";
                            DataRowClientMedInstructions = DataTableClientMedicationInstructions.NewRow();
                        }
                    }
                    else
                    {
                        newRowCMI = true;
                        DataRowClientMedInstructions = DataTableClientMedicationInstructions.NewRow();
                        Int32 _minInstructionPrescribedId = 0;
                        Int32 _minInstructionId = 0;
                        if (Session["DataSetPrescribedClientMedications"] != null)
                        {
                            DataSetPrescibedMedications = (DataSet)Session["DataSetPrescribedClientMedications"];
                            if (DataSetPrescibedMedications.Tables["ClientMedicationInstructions"].Rows.Count > 0)
                            {
                                _minInstructionPrescribedId = GetMinValue(Convert.ToInt32(DataSetPrescibedMedications
                                           .Tables["ClientMedicationInstructions"].Compute("Min(ClientMedicationInstructionId)", "")));
                            }

                            if (DataTableClientMedicationInstructions.Rows.Count > 0)
                                _minInstructionId =
                                    GetMinValue(Convert.ToInt32(DataTableClientMedicationInstructions.Compute("Min(ClientMedicationInstructionId)", "")));

                            if (_minInstructionId > _minInstructionPrescribedId)
                            {
                                _minInstructionId = _minInstructionPrescribedId;
                            }
                        }
                        else
                        {
                            if (DataTableClientMedicationInstructions.Rows.Count > 0)
                                _minInstructionId = GetMinValue(Convert.ToInt32(
                                    DataTableClientMedicationInstructions.Compute("Min(ClientMedicationInstructionId)", "")));
                        }
                        DataRowClientMedInstructions["ClientMedicationInstructionId"] = _minInstructionId;
                    }
               
                    DataRow[] _drtempClientMedInstructions = DataTableClientMedicationInstructions.Select("Active='N'");
                    for (int i = 0; i < _drtempClientMedInstructions.Length; i++)
                    {
                        Int32 temp_clientMedicationInstructionId = Convert.ToInt32(_drtempClientMedInstructions[i]["ClientMedicationInstructionId"]);
                        if (temp_clientMedicationInstructionId < 1)
                        {
                            DataTableClientMedicationInstructions.Select("Active='N'")[i].Delete();
                        }
                    }
                 
                    DataRowClientMedInstructions["ClientMedicationId"] = DataRowClientMedication["ClientMedicationId"];
                    DataRowClientMedInstructions["StrengthId"] = row.StrengthId;
                    DataRowClientMedInstructions["Quantity"] = row.Quantity;
                    DataRowClientMedInstructions["Unit"] = row.Unit;
                    DataRowClientMedInstructions["Schedule"] = row.Schedule;
                    DataRowClientMedInstructions["Active"] = "Y";// WITH REF TO TASK # 182
                    DataRowClientMedInstructions["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                    DataRowClientMedInstructions["ModifiedDate"] = DateTime.Now;
                    DataRowClientMedInstructions["Instruction"] = row.Instruction;
                    DataRowClientMedInstructions["StartDate"] = row.StartDate;
                    DataRowClientMedInstructions["EndDate"] = EndDate;
                    DataRowClientMedInstructions["PotencyUnitCode"] = row.PotencyUnitCode;
                    DataRowClientMedInstructions["Refills"] = (objClientMedication.DrugCategory != "2") ? row.Refills : 0;
                    if (newRowCMI == true)
                    {
                        DataRowClientMedInstructions["RowIdentifier"] = System.Guid.NewGuid();
                        DataRowClientMedInstructions["CreatedBy"] =
                            ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                        DataRowClientMedInstructions["CreatedDate"] = DateTime.Now;
                        DataTableClientMedicationInstructions.Rows.Add(DataRowClientMedInstructions);
                    }

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
                    DatarowClientMedicationScriptDispenseDays["ClientMedicationScriptId"] = drClientMedicationScripts["ClientMedicationScriptId"];
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

                    Int32[] arrayId = new Int32[2];
                    if (row.Refills > 0 && objClientMedication.DrugCategory == "2")
                    {
                        for (short loopCounter = 0; loopCounter < row.Refills && loopCounter < 2; loopCounter++)
                        {
                            Int32 _minInstructionId = 0;
                            DataRow DataRowClientMedInstructionsNewRow = DataTableClientMedicationInstructions.NewRow();
                            if (DataTableClientMedicationInstructions.Rows.Count > 0)
                                _minInstructionId = GetMinValue(Convert.ToInt32(DataTableClientMedicationInstructions.Compute("Min(ClientMedicationInstructionId)", "")));

                            arrayId[loopCounter] = _minInstructionId;
                            DataRowClientMedInstructionsNewRow["ClientMedicationInstructionId"] = _minInstructionId;
                            DataRowClientMedInstructionsNewRow["ClientMedicationId"] = DataRowClientMedication["ClientMedicationId"];
                            DataRowClientMedInstructionsNewRow["StrengthId"] = row.StrengthId;
                            DataRowClientMedInstructionsNewRow["Quantity"] = row.Quantity;
                            DataRowClientMedInstructionsNewRow["Unit"] = row.Unit;
                            DataRowClientMedInstructionsNewRow["Schedule"] = row.Schedule;
                            DataRowClientMedInstructionsNewRow["Active"] = "Y";
                            DataRowClientMedInstructionsNewRow["RowIdentifier"] = System.Guid.NewGuid();
                            DataRowClientMedInstructionsNewRow["CreatedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                            DataRowClientMedInstructionsNewRow["CreatedDate"] = DateTime.Now;
                            DataRowClientMedInstructionsNewRow["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                            DataRowClientMedInstructionsNewRow["ModifiedDate"] = DateTime.Now;
                            DataRowClientMedInstructionsNewRow["Instruction"] = row.Instruction;
                            DataRowClientMedInstructionsNewRow["StartDate"] = Convert.ToDateTime(row.StartDate).AddDays((loopCounter + 1) * (row.Days)).ToShortDateString();
                            DataRowClientMedInstructionsNewRow["EndDate"] = Convert.ToDateTime(EndDate).AddDays((loopCounter + 1) * (row.Days)).ToShortDateString();
                            DataTableClientMedicationInstructions.Rows.Add(DataRowClientMedInstructionsNewRow);
                        }
                    }

                    DataRow DataRowClientMedicationScriptDrugs;
                    DataRow DataRowClientMedicationScriptDrugStrengths;
                    DataRow[] drTempScriptDrug = DataTableClientMedicationScriptDrugs
                        .Select("ClientMedicationInstructionId=" + DataRowClientMedInstructions["ClientMedicationInstructionId"]);
                    if (drTempScriptDrug.Length > 0)
                    {
                        DataRowClientMedicationScriptDrugs = drTempScriptDrug[0];
                        newRowCMSD = false;
                    }
                    else
                    {
                        newRowCMSD = true;
                        DataRowClientMedicationScriptDrugs = DataTableClientMedicationScriptDrugs.NewRow();
                        if (DataTableClientMedicationScriptDrugs.Rows.Count > 0)
                        {
                            Int32 _minScriptDrugsId = 0;
                            Int32 _minPrescribedScriptDrugsId = 0;
                            if (Session["DataSetPrescribedClientMedications"] != null)
                            {
                                DataSetPrescibedMedications = (DataSet)Session["DataSetPrescribedClientMedications"];
                                _minPrescribedScriptDrugsId = GetMinValue(Convert.ToInt32(DataSetPrescibedMedications
                                            .Tables["ClientMedicationScriptDrugs"].Compute("Min(ClientMedicationScriptDrugId)", "")));
                                _minScriptDrugsId = GetMinValue(Convert.ToInt32(DataTableClientMedicationScriptDrugs
                                            .Compute("Min(ClientMedicationScriptDrugId)", "")));
                                if (_minScriptDrugsId > _minPrescribedScriptDrugsId)
                                {
                                    _minScriptDrugsId = _minPrescribedScriptDrugsId;
                                }
                            }
                            else
                            {
                                _minScriptDrugsId = GetMinValue(Convert.ToInt32(DataTableClientMedicationScriptDrugs
                                                .Compute("Min(ClientMedicationScriptDrugId)", "")));
                            }
                            DataRowClientMedicationScriptDrugs["ClientMedicationScriptDrugId"] = _minScriptDrugsId;
                        }
                    }

                    if (row.StrengthRowIdentifier == null || row.StrengthRowIdentifier == "")
                        row.StrengthRowIdentifier = "-1";

                    DataRow[] temprowidentifierStrengthDrugs = DataTableClientMedicationScriptDrugStrengths
                                                    .Select("RowIdentifier='" + row.StrengthRowIdentifier + "'");
                    if (temprowidentifierStrengthDrugs.Length > 0)
                    {
                        DataRowClientMedicationScriptDrugStrengths = temprowidentifierStrengthDrugs[0];
                        newRowCMSDS = false;
                    }
                    else
                    {
                        newRowCMSDS = true;
                        DataRowClientMedicationScriptDrugStrengths = DataTableClientMedicationScriptDrugStrengths.NewRow();
                        if (DataTableClientMedicationScriptDrugStrengths.Rows.Count > 0)
                        {
                            Int32 _minScriptDrugStrengthId = 0;
                            Int32 _minPrescribedScriptDrugStrengthId = 0;
                            if (Session["DataSetPrescribedClientMedications"] != null)
                            {
                                DataSetPrescibedMedications = (DataSet)Session["DataSetPrescribedClientMedications"];
                                _minPrescribedScriptDrugStrengthId = GetMinValue(Convert.ToInt32(DataSetPrescibedMedications
                                    .Tables["ClientMedicationScriptDrugStrengths"].Compute("Min(ClientMedicationScriptDrugStrengthId)", "")));
                                _minScriptDrugStrengthId = GetMinValue(Convert.ToInt32(DataTableClientMedicationScriptDrugStrengths
                                        .Compute("Min(ClientMedicationScriptDrugStrengthId)", "")));

                                if (_minScriptDrugStrengthId > _minPrescribedScriptDrugStrengthId)
                                {
                                    _minScriptDrugStrengthId = _minPrescribedScriptDrugStrengthId;
                                }
                            }
                            else
                            {
                                _minScriptDrugStrengthId = GetMinValue(Convert.ToInt32(DataTableClientMedicationScriptDrugStrengths
                                    .Compute("Min(ClientMedicationScriptDrugStrengthId)", "")));
                            }
                            DataRowClientMedicationScriptDrugStrengths["ClientMedicationScriptDrugStrengthId"] = _minScriptDrugStrengthId;
                        }
                    }
                    DataRowClientMedicationScriptDrugs["ClientMedicationScriptId"] =
                            dsClientMedications.Tables["ClientMedicationScripts"].Rows[0]["ClientMedicationScriptId"];
                    DataRowClientMedicationScriptDrugs["ClientMedicationInstructionId"] =
                            DataRowClientMedInstructions["ClientMedicationInstructionId"];
                    DataRowClientMedicationScriptDrugs["StartDate"] = row.StartDate;
                    DataRowClientMedicationScriptDrugs["Days"] = row.Days;
                    if (objClientMedication.DrugCategory == "3" || objClientMedication.DrugCategory == "4" || objClientMedication.DrugCategory == "5")
                    {
                        if (!(Convert.ToDecimal(row.Pharmacy) == 0 &&
                            Convert.ToDecimal(row.Stock) == 0 &&
                            Convert.ToDecimal(row.Sample) == 0 &&
                            row.AutoCalcallow == "N"))
                        {
                            DataRowClientMedicationScriptDrugs["Pharmacy"] = row.Pharmacy;
                        }
                    }
                    else
                    {
                        DataRowClientMedicationScriptDrugs["Pharmacy"] = row.Pharmacy;
                    }
                    DataRowClientMedicationScriptDrugs["PharmacyText"] = row.PharmaText;
                    DataRowClientMedicationScriptDrugs["AutoCalcallow"] = row.AutoCalcallow;
                    DataRowClientMedicationScriptDrugs["Sample"] = row.Sample;
                    DataRowClientMedicationScriptDrugs["Stock"] = row.Stock;
                    DataRowClientMedicationScriptDrugs["Refills"] = (row.Refills > 0 &&
                                                                     objClientMedication.DrugCategory == "2")
                                                                        ? 0
                                                                        : row.Refills;
                    DataRowClientMedicationScriptDrugs["EndDate"] = EndDate;
                    if (!String.IsNullOrEmpty(objClientMedication.DrugCategory))
                        DataRowClientMedicationScriptDrugs["DrugCategory"] = objClientMedication.DrugCategory;

                    if (Convert.ToDateTime(DataRowClientMedicationScriptDrugs["EndDate"]) < Convert.ToDateTime(DataRowClientMedicationScriptDrugs["StartDate"]))
                    {
                        if (_MedicationStartDate != string.Empty)
                            DataRowClientMedication["MedicationStartDate"] = Convert.ToDateTime(_MedicationStartDate);
                        else
                            DataRowClientMedication["MedicationStartDate"] = System.DBNull.Value;

                        if (_MedicationEndDate != string.Empty)
                            DataRowClientMedication["MedicationEndDate"] = Convert.ToDateTime(_MedicationEndDate);
                        else
                            DataRowClientMedication["MedicationEndDate"] = System.DBNull.Value;

                        throw new Exception("End Date should be greater than Start Date");
                    }
                    //MedicationStartDate should not be changed in case of REFILL.
                    if (method.ToUpper() != "REFILL")
                    {
                        // Make sure that earliest Instruction "step" Start Date is used as MedicationStartDate - Chuck Blaine (Oct 6 2013) Ref task - Thresholds Support #252
                        DateTime oldRowDate;
                        DateTime newRowDate = DateTime.Parse(row.StartDate);
                        bool dateAlreadySet =
                            DateTime.TryParse(DataRowClientMedication["MedicationStartDate"].ToString(), out oldRowDate);


                        if (!dateAlreadySet || DateTime.Compare(newRowDate, oldRowDate) < 0)
                        {
                            DataRowClientMedication["MedicationStartDate"] = row.StartDate;
                        }
                    }
                    else
                    {
                        //Calculating minimum startDate in clientmedication
                        if (DataRowClientMedication["MedicationEndDateForDisplay"] != DBNull.Value)
                        {
                            if (Convert.ToDateTime(DataRowClientMedication["MedicationEndDateForDisplay"]) > Convert.ToDateTime(row.StartDate))
                                DataRowClientMedication["MedicationEndDateForDisplay"] = row.StartDate;
                        }
                        else
                        {
                            DataRowClientMedication["MedicationEndDateForDisplay"] = row.StartDate;
                        }

                        if (DataRowClientMedication["MedicationStartDate"] != DBNull.Value)
                        {
                            DataRowClientMedication["MedicationEndDateForDisplay"] = Convert.ToDateTime(DataRowClientMedication["MedicationStartDate"]);
                        }
                    }

                    if (DataRowClientMedication["MedicationEndDate"] != DBNull.Value)
                    {
                        if (Convert.ToDateTime(DataRowClientMedication["MedicationEndDate"]) < Convert.ToDateTime(row.EndDate))
                            DataRowClientMedication["MedicationEndDate"] = row.EndDate;
                    }
                    else
                    {
                        DataRowClientMedication["MedicationEndDate"] = EndDate;
                    }
                    DataRowClientMedicationScriptDrugs["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                    DataRowClientMedicationScriptDrugs["ModifiedDate"] = DateTime.Now;
                    if (newRowCMSD == true)
                    {
                        DataRowClientMedicationScriptDrugs["RowIdentifier"] = System.Guid.NewGuid();
                        DataRowClientMedicationScriptDrugs["CreatedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                        DataRowClientMedicationScriptDrugs["CreatedDate"] = DateTime.Now;
                        DataTableClientMedicationScriptDrugs.Rows.Add(DataRowClientMedicationScriptDrugs);
                    }

                    if (row.Refills > 0 && objClientMedication.DrugCategory == "2")
                    {
                        for (short loopCounter = 0; loopCounter < row.Refills && loopCounter < 2; loopCounter++)
                        {
                            DataRow DataRowClientMedicationScriptDrugsNewRow = DataTableClientMedicationScriptDrugs.NewRow();
                            int _minScriptDrugsId = 0;
                            if (DataTableClientMedicationScriptDrugs.Rows.Count > 0)
                                _minScriptDrugsId = GetMinValue(Convert.ToInt32(DataTableClientMedicationScriptDrugs.Compute("Min(ClientMedicationScriptDrugId)", "")));

                            DataRowClientMedicationScriptDrugsNewRow["ClientMedicationScriptDrugId"] = _minScriptDrugsId;
                            DataRowClientMedicationScriptDrugsNewRow["ClientMedicationScriptId"] =
                                dsClientMedications.Tables["ClientMedicationScripts"].Rows[0]["ClientMedicationScriptId"];
                            DataRowClientMedicationScriptDrugsNewRow["ClientMedicationInstructionId"] = arrayId[loopCounter];
                            DataRowClientMedicationScriptDrugsNewRow["StartDate"] = Convert.ToDateTime(row.StartDate).AddDays((loopCounter + 1) * (row.Days)).ToShortDateString();
                            DataRowClientMedicationScriptDrugsNewRow["Days"] = row.Days;
                            DataRowClientMedicationScriptDrugsNewRow["Pharmacy"] = row.Pharmacy;
                            DataRowClientMedicationScriptDrugsNewRow["PharmacyText"] = row.PharmaText;
                            DataRowClientMedicationScriptDrugsNewRow["AutoCalcallow"] = row.AutoCalcallow;
                            DataRowClientMedicationScriptDrugsNewRow["Sample"] = row.Sample;
                            DataRowClientMedicationScriptDrugsNewRow["Stock"] = row.Stock;
                            DataRowClientMedicationScriptDrugsNewRow["Refills"] = 0;
                            DataRowClientMedicationScriptDrugsNewRow["EndDate"] = Convert.ToDateTime(EndDate).AddDays((loopCounter + 1) * (row.Days)).ToShortDateString();
                            if (!String.IsNullOrEmpty(objClientMedication.DrugCategory))
                                DataRowClientMedicationScriptDrugsNewRow["DrugCategory"] = objClientMedication.DrugCategory;
                            if (Convert.ToDateTime(DataRowClientMedicationScriptDrugs["EndDate"]) < Convert.ToDateTime(DataRowClientMedicationScriptDrugs["StartDate"]))
                            {
                                if (_MedicationStartDate != string.Empty)
                                    DataRowClientMedication["MedicationStartDate"] = Convert.ToDateTime(_MedicationStartDate);
                                else
                                    DataRowClientMedication["MedicationStartDate"] = System.DBNull.Value;
                                if (_MedicationEndDate != string.Empty)
                                    DataRowClientMedication["MedicationEndDate"] = Convert.ToDateTime(_MedicationEndDate);
                                else
                                    DataRowClientMedication["MedicationEndDate"] = System.DBNull.Value;

                                throw new Exception("End Date should be greater than Start Date");
                            }
                            //MedicationStartDate should not be changed in case of REFILL.
                            if (method.ToUpper() != "REFILL")
                            {
                                DataRowClientMedication["MedicationStartDate"] = row.StartDate;
                            }
                            else
                            {
                                //Calculating minimum startDate in clientmedication
                                if (DataRowClientMedication["MedicationEndDateForDisplay"] != DBNull.Value)
                                {
                                    if (Convert.ToDateTime(DataRowClientMedication["MedicationEndDateForDisplay"]) > Convert.ToDateTime(row.StartDate))
                                        DataRowClientMedication["MedicationEndDateForDisplay"] = row.StartDate;
                                }
                                else
                                {
                                    DataRowClientMedication["MedicationEndDateForDisplay"] = row.StartDate;
                                }

                                if (DataRowClientMedication["MedicationStartDate"] != DBNull.Value)
                                {
                                    DataRowClientMedication["MedicationEndDateForDisplay"] = Convert.ToDateTime(DataRowClientMedication["MedicationStartDate"]);
                                }
                            }

                            if (DataRowClientMedication["MedicationEndDate"] != DBNull.Value)
                            {
                                if (Convert.ToDateTime(DataRowClientMedication["MedicationEndDate"]) < Convert.ToDateTime(row.EndDate))
                                    DataRowClientMedication["MedicationEndDate"] = row.EndDate;
                            }
                            else
                            {
                                DataRowClientMedication["MedicationEndDate"] = EndDate;
                            }
                            //  DataRowClientMedication["Refills"] = 0;
                            DataRowClientMedicationScriptDrugsNewRow["RowIdentifier"] = System.Guid.NewGuid();
                            DataRowClientMedicationScriptDrugsNewRow["CreatedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                            DataRowClientMedicationScriptDrugsNewRow["CreatedDate"] = DateTime.Now;
                            DataRowClientMedicationScriptDrugsNewRow["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                            DataRowClientMedicationScriptDrugsNewRow["ModifiedDate"] = DateTime.Now;
                            DataTableClientMedicationScriptDrugs.Rows.Add(DataRowClientMedicationScriptDrugsNewRow);
                        }
                    }

                    DataRowClientMedicationScriptDrugStrengths["ClientMedicationScriptId"] =
                            dsClientMedications.Tables["ClientMedicationScripts"].Rows[0]["ClientMedicationScriptId"];
                    DataRowClientMedicationScriptDrugStrengths["Pharmacy"] = row.Pharmacy;
                    DataRowClientMedicationScriptDrugStrengths["PharmacyText"] = row.PharmaText;
                    DataRowClientMedicationScriptDrugStrengths["Sample"] = row.Sample;
                    DataRowClientMedicationScriptDrugStrengths["Stock"] = row.Stock;
                    DataRowClientMedicationScriptDrugStrengths["StrengthId"] = row.StrengthId;
                    DataRowClientMedicationScriptDrugStrengths["ClientMedicationId"] = DataRowClientMedication["ClientMedicationId"];
                    DataRowClientMedicationScriptDrugStrengths["Refills"] = (row.Refills > 0 && objClientMedication.DrugCategory == "2") ? 0 : row.Refills;
                    DataRowClientMedicationScriptDrugStrengths["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                    DataRowClientMedicationScriptDrugStrengths["ModifiedDate"] = DateTime.Now;

                    if (newRowCMSDS == true)
                    {
                        DataRowClientMedicationScriptDrugStrengths["RowIdentifier"] = System.Guid.NewGuid();
                        DataRowClientMedicationScriptDrugStrengths["CreatedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                        DataRowClientMedicationScriptDrugStrengths["CreatedDate"] = DateTime.Now;
                        bool isExist = false;
                        if (objClientMedication.DrugCategory != "2")
                        {
                            if (DataTableClientMedicationScriptDrugStrengths.Rows.Count > 0)
                            {

                                foreach (DataRow dr in DataTableClientMedicationScriptDrugStrengths
                                    .Select("StrengthId=" + row.StrengthId.ToString() +
                                        " and ClientMedicationId=" + DataRowClientMedication["ClientMedicationId"]))
                                {
                                    if (row.AutoCalcallow == "Y")
                                    {
                                        isExist = true;
                                        dr["Pharmacy"] = (dr["Pharmacy"] == System.DBNull.Value
                                                              ? 0
                                                              : Convert.ToDecimal(dr["Pharmacy"])) + row.Pharmacy;
                                        dr["Sample"] = (dr["Sample"] == System.DBNull.Value
                                                            ? 0
                                                            : Convert.ToDecimal(dr["Sample"])) + row.Sample;
                                        dr["Stock"] = (dr["Stock"] == System.DBNull.Value
                                                           ? 0
                                                           : Convert.ToDecimal(dr["Stock"])) + row.Stock;
                                        dr["Refills"] = (dr["Refills"] == System.DBNull.Value
                                                             ? 0
                                                             : Convert.ToDecimal(dr["Refills"])) + row.Refills;
                                    }
                                    else if (row.AutoCalcallow == "N")
                                    {
                                        isExist = true;
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
                    }
                }

                if (DataTableClientMedicationInstructions.Columns.Contains("TempRecordDeleted"))
                {
                    foreach (DataRow drDeletedRows in DataTableClientMedicationInstructions.Select("TempRecordDeleted='Y'"))
                    {
                        drDeletedRows["RecordDeleted"] = "Y";
                        drDeletedRows["DeletedDate"] = Convert.ToDateTime(DateTime.Now.ToShortDateString());
                        drDeletedRows["DeletedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                    }
                }
                foreach (DataRow drMedicationInstructions in DataTableClientMedicationInstructions.Select("RecordDeleted='Y'"))
                {
                    DataRow[] dr = DataTableClientMedicationScriptDrugs.Select("ClientMedicationInstructionId=" + drMedicationInstructions["ClientMedicationInstructionId"]);
                    if (dr.Length > 0)
                    {
                        dr[0]["RecordDeleted"] = "Y";
                        dr[0]["DeletedDate"] = Convert.ToDateTime(DateTime.Now.ToShortDateString());
                        dr[0]["DeletedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                    }
                }

                //Prescribers of all Medications needs to be same as of current medications in case its not same as of current Medication being saved
                Int32 _MinPrescriberId = Convert.ToInt32(DataTableClientMedications.Compute("MIN(PrescriberId)", "ISNULL(RecordDeleted,'N')<>'Y'"));
                Int32 _MaxPrescriberId = Convert.ToInt32(DataTableClientMedications.Compute("Max(PrescriberId)", "ISNULL(RecordDeleted,'N')<>'Y'"));
                if (_MinPrescriberId != _MaxPrescriberId)
                {
                    foreach (DataRow drClientMedicationRow in DataTableClientMedications.Select("ISNULL(RecordDeleted,'N')<>'Y'"))
                    {
                        drClientMedicationRow["PrescriberId"] = objClientMedication.PrescriberId;
                        drClientMedicationRow["PrescriberName"] = objClientMedication.PrescriberName;
                    }
                }

                Session["DataSetClientMedications"] = dsClientMedications;
                Session["IsDirty"] = true;
                getDrugInteraction(dsClientMedications);
                Session["SelectedMedicationId"] = null;
                return "";
            }

            catch (Exception ex)
            {
                if (Session["SessionTimeOut"] == null)
                    return "Session Expired";
                else
                    return ex.Message;
            }
        }


        private void getDrugInteraction(Streamline.UserBusinessServices.DataSets.DataSetClientMedications dsTemp)
        {
            try
            {
                CommonFunctions.Event_Trap(this);
                string MedicationIds = "";
                DataSet dsSetClientSummary = null;
                string _distinctCMID1 = "";
                string _distinctCMID2 = "";
                ////Getting all MedicationIds to check for interactions

                //Start:Code modified by Ankesh Bharti on 24-Feb-2009 with ref to task # 2405.
                foreach (DataRow dr in dsTemp.ClientMedicationInstructions.Select("isnull(Recorddeleted,'N')<>'Y'", "ClientMedicationId"))
                {
                    if (_distinctCMID1 != dr["ClientMedicationId"].ToString())
                    {
                        if (string.IsNullOrEmpty(dr["StrengthId"].ToString()) == false)//added by chandan on 24th nov 2008 for check strength 
                            MedicationIds += dr["StrengthId"].ToString() + ",";
                        _distinctCMID1 = dr["ClientMedicationId"].ToString();
                    }

                }
                //End:Code modified by Ankesh Bharti on 24-Feb-2009 with ref to task # 2405.

                //Added by Chandan on 19th Nov 2008 
                //Ref Task #82 (1.6.5 - Drug Interactions Check Against Current Meds) 
                //Getting all MedicationIds for previous orders to check for interactions
                if (Session["DataSetClientSummary"] != null)
                {
                    dsSetClientSummary = new DataSet();
                    dsSetClientSummary = (DataSet)Session["DataSetClientSummary"];
                    foreach (DataRow dr1 in dsSetClientSummary.Tables["ClientMedications"].Select("isnull(Recorddeleted,'N')<>'Y' and isnull(Discontinued,'N')<>'Y' "))
                    {
                        if (dr1 != null)
                        {
                            foreach (DataRow dr2 in dsSetClientSummary.Tables["ClientMedicationInstructions"].Select("isnull(Recorddeleted,'N')<>'Y' and ClientMedicationId = ' " + dr1["ClientMedicationId"].ToString() + "' "))
                            {
                                //Start:Code modified by Ankesh Bharti on 24-Feb-2009 with ref to task # 2405.
                                if (_distinctCMID2 != dr2["ClientMedicationId"].ToString())
                                {
                                    if (string.IsNullOrEmpty(dr2["StrengthId"].ToString()) == false)//added by chandan on 24th nov 2008 for check strength 
                                        MedicationIds += dr2["StrengthId"].ToString() + ",";
                                    _distinctCMID2 = dr2["ClientMedicationId"].ToString();
                                }
                                //End:Code modified by Ankesh Bharti on 24-Feb-2009 with ref to task # 2405.
                            }
                        }
                    }
                }
                //Added by Chandan ended Here 
                if (MedicationIds.Length > 1)
                    MedicationIds = MedicationIds.TrimEnd(',');
                Streamline.UserBusinessServices.ClientMedication objClientMed = new Streamline.UserBusinessServices.ClientMedication();
                if (MedicationIds != "")
                {
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



        /// <summary>
        /// Close button
        /// </summary>
        /// <param></param>
        /// <returns></returns>

        [WebMethod(EnableSession = true)]
        public bool CloseClick()
        {
            try
            {
                if (Convert.ToBoolean(Session["IsDirty"]) == true)
                {
                    return true;
                }
                else
                {
                    return false;
                }

            }
            catch (Exception ex)
            {
                return false;
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
        }


        /// <summary>
        /// Close button
        /// </summary>
        /// <param></param>
        /// <returns></returns>

        [WebMethod(EnableSession = true)]
        public bool CloseClick1()
        {
            try
            {

                return true;


            }
            catch (Exception ex)
            {
                return false;
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
        }
        /// <summary>
        /// Get the Drug Interaction MonoGraph Text
        /// </summary>
        /// <param name="InteractionId"></param>
        /// <returns></returns>

        [WebMethod(EnableSession = true)]
        public DataTable GetDrugInteractionText(int InteractionId)
        {
            try
            {
                CommonFunctions.Event_Trap(this);

                Streamline.UserBusinessServices.DataSets.DataSetClientMedications dsClientMedications = null;
                if (Session["DataSetClientMedications"] != null)
                    dsClientMedications = (Streamline.UserBusinessServices.DataSets.DataSetClientMedications)Session["DataSetClientMedications"];
                else if (Session["DataSetClientSummary"] != null)
                {
                    DataSet dsTemp = (DataSet)Session["DataSetClientSummary"];
                    dsClientMedications = new Streamline.UserBusinessServices.DataSets.DataSetClientMedications();
                    //Added by Loveena in ref to Task#2796
                    string str = "";
                    //DataRow[] drClientMedicationtobeInserted = dsTemp.Tables["ClientMedications"].Select("ClientMedicationId");
                    foreach (DataRow dr in dsTemp.Tables["ClientMedications"].Rows)
                    {

                        if (str.IndexOf(dr["ClientMedicationId"].ToString()) < 0)
                        {
                            dsClientMedications.ClientMedications.ImportRow(dr);
                            str += dr["ClientMedicationId"] + ",";
                        }
                        //End here

                    }
                    //dsClientMedications.ClientMedications.Merge(dsTemp.Tables["ClientMedications"]);
                    //Code modified by Loveena ends over here.
                    dsClientMedications.ClientMedicationInstructions.Merge(dsTemp.Tables["ClientMedicationInstructions"]);
                    dsClientMedications.ClientMedicationInteractions.Merge(dsTemp.Tables["ClientMedicationInteractions"]);
                    dsClientMedications.ClientMedicationInteractionDetails.Merge(dsTemp.Tables["ClientMedicationInteractionDetails"]);

                }
                else
                    return null;
                DataRow[] drInteraction = dsClientMedications.ClientMedicationInteractionDetails.Select("ClientMedicationInteractionId=" + InteractionId);
                if (drInteraction.Length == 1)
                {
                    //Added by Chandan on 19th Nov 2008 
                    //Ref Task #82 (1.6.5 - Drug Interactions Check Against Current Meds) 
                    //Added more perameters "InteractionId ", Dataset in getMonographDescription method
                    //return getMonographDescription(Convert.ToInt32(drInteraction[0]["DrugInteractionMonographId"]));
                    return getMonographDescription(Convert.ToInt32(drInteraction[0]["DrugInteractionMonographId"]), InteractionId, dsClientMedications);
                }
                else
                {
                    DataTable ds = new DataTable();
                    ds.Columns.Add("Severity");
                    ds.Columns.Add("Description");
                    ds.Columns.Add("MonoGraphId");
                    ds.Columns.Add("InteractionId"); //Added By Chandan on 19th Nov 2008 Task #82

                    foreach (DataRow drDetail in drInteraction)
                    {
                        DataRow dr = ds.NewRow();
                        dr["Description"] = drDetail["InteractionDescription"];
                        dr["Severity"] = drDetail["InteractionLevel"];
                        dr["MonoGraphId"] = drDetail["DrugInteractionMonographId"];
                        dr["InteractionId"] = drDetail["ClientMedicationInteractionId"];  //Added By Chandan on 19th Nov 2008 Task #82


                        ds.Rows.Add(dr);
                    }
                    return ds;
                }

                return null;
            }
            catch (Exception ex)
            {
                return null;
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

        }

        /// <summary>
        /// Author Sony
        /// Purpose To get the MonographDescription Text
        /// </summary>
        /// <modifiedby> Chandan on 19th Nov 2008 
        ///Ref Task #82 (1.6.5 - Drug Interactions Check Against Current Meds) 
        ///Added more perameters "InteractionId ", Dataset in getMonographDescription method</modifiedby>
        /// <param name="MonoGraphId"></param>
        /// <returns></returns>
        [WebMethod(EnableSession = true)]
        public DataTable getMonographDescription(int MonoGraphId, int InteractionId, DataSet dsTemp1) //Added by Chandan two new parameters
        {

            try
            {
                //Added by Chandan on 19th Nov 2008 
                //Ref Task #82 (1.6.5 - Drug Interactions Check Against Current Meds) 
                //Adding New Line on the top of the Monograph description PopUp
                string MedicationIntraction = "";
                DataRow[] _dr1 = dsTemp1.Tables["ClientMedicationInteractions"].Select("ClientMedicationInteractionId=" + InteractionId);
                if (_dr1 != null)
                    MedicationIntraction = "INTERACTING MEDICATIONS: " + _dr1[0]["ClientMedicationId1Name"].ToString() + " / " + _dr1[0]["ClientMedicationId2Name"].ToString();
                //End By Chandan 17th Nov 2008

                CommonFunctions.Event_Trap(this);
                Streamline.UserBusinessServices.ClientMedication objClientMed = new Streamline.UserBusinessServices.ClientMedication();
                string stringTempInteraction = objClientMed.GetClientMedicationmonographtext(MonoGraphId);
                DataTable ds = new DataTable();
                ds.Columns.Add("Description");
                DataRow dr = ds.NewRow();
                dr["Description"] = MedicationIntraction + stringTempInteraction; //Added by Chandan a Concatinate a new string MedicationIntraction
                ds.Rows.Add(dr);
                return ds;

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
        /// Chandan Srivastava
        /// Overloaded method with two parameters Purpose To get the MonographDescription Text
        /// //Ref Task #82 (1.6.5 - Drug Interactions Check Against Current Meds) </summary>
        /// <param name="MonoGraphId,InteractionId"></param>
        /// <returns></returns>
        /// <Created Date>19th Nov 2008</Created>
        [WebMethod(EnableSession = true)]
        public DataTable getMonographDescription(int MonoGraphId, int InteractionId)
        {

            try
            {

                Streamline.UserBusinessServices.DataSets.DataSetClientMedications dsClientMedications = null;
                if (Session["DataSetClientMedications"] != null)
                    dsClientMedications = (Streamline.UserBusinessServices.DataSets.DataSetClientMedications)Session["DataSetClientMedications"];
                else if (Session["DataSetClientSummary"] != null)
                {
                    DataSet dsTemp = (DataSet)Session["DataSetClientSummary"];
                    dsClientMedications = new Streamline.UserBusinessServices.DataSets.DataSetClientMedications();
                    string str = "";
                    //Added by Loveena in ref to Task#2796
                    foreach (DataRow drow in dsTemp.Tables["ClientMedications"].Rows)
                    {

                        if (str.IndexOf(drow["ClientMedicationId"].ToString()) < 0)
                        {
                            dsClientMedications.ClientMedications.ImportRow(drow);
                            str += drow["ClientMedicationId"] + ",";
                        }
                        //End here

                    }
                    //dsClientMedications.ClientMedications.Merge(dsTemp.Tables["ClientMedications"]);
                    //Code ends over here.
                    dsClientMedications.ClientMedicationInstructions.Merge(dsTemp.Tables["ClientMedicationInstructions"]);
                    dsClientMedications.ClientMedicationInteractions.Merge(dsTemp.Tables["ClientMedicationInteractions"]);
                    dsClientMedications.ClientMedicationInteractionDetails.Merge(dsTemp.Tables["ClientMedicationInteractionDetails"]);

                }

                string MedicationIntraction = "";
                DataRow[] _dr1 = dsClientMedications.Tables["ClientMedicationInteractions"].Select("ClientMedicationInteractionId=" + InteractionId);
                if (_dr1 != null)
                    MedicationIntraction = "INTERACTING MEDICATIONS: " + _dr1[0]["ClientMedicationId1Name"].ToString() + " / " + _dr1[0]["ClientMedicationId2Name"].ToString();

                CommonFunctions.Event_Trap(this);
                Streamline.UserBusinessServices.ClientMedication objClientMed = new Streamline.UserBusinessServices.ClientMedication();
                string stringTempInteraction = objClientMed.GetClientMedicationmonographtext(MonoGraphId);
                DataTable ds = new DataTable();
                ds.Columns.Add("Description");
                DataRow dr = ds.NewRow();
                dr["Description"] = MedicationIntraction + stringTempInteraction;
                ds.Rows.Add(dr);
                return ds;

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
        /// Adds Interaction Rows in the Dataset 
        /// </summary>
        /// <param name="dsInteraction"></param>
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


        /// <summary>
        /// Add to DrugInteractions table and Drug InteractionsDetails table in the dataset
        /// </summary>
        /// <param name="drTemp">Datarow array of the same monographid</param>
        /// <ModifiedBy>Chandan on 19th Nov 2008 //Ref Task #82 (1.6.5 - Drug Interactions Check Against Current Meds) </ModifiedBy>
        private void getInteractionRows(DataRow[] drTemp)
        {
            //Function Changed by sonia
            try
            {
                Streamline.UserBusinessServices.DataSets.DataSetClientMedications dsClientMedications = (Streamline.UserBusinessServices.DataSets.DataSetClientMedications)Session["DataSetClientMedications"];

                int ClientMedicationInteractionId = 0;
                CommonFunctions.Event_Trap(this);

                for (int i = 0; i < drTemp.Length; i++)//Takes the first id and makes possible combination with all the rest of the ids
                {
                    if (!drTemp[i]["SeverityLevel"].ToString().IsNullOrWhiteSpace())
                    {
                        int MedicationId1 = 0;
                        int MedicationId2 = 0;
                        //Added by Chandan on 19th Nov 2008
                        string ClientMedicationId1Name = "";
                        string ClientMedicationId2Name = "";
                        //End by Chandan
                        int k = i + 1;
                        for (; k < drTemp.Length; k++)
                        {
                            //Get the Maximum of ClientMedicationInteractionId to be used for new row
                            if (dsClientMedications.ClientMedicationInteractions.Rows.Count > 0)
                                ClientMedicationInteractionId = GetMinValue(Convert.ToInt32(dsClientMedications.ClientMedicationInteractions.Compute("Min(ClientmedicationInteractionId)", "")));


                            //Get both the Interacting MedicationId from the Instructions table 
                            DataRow[] ClientMedication1 = dsClientMedications.ClientMedicationInstructions.Select("StrengthId=" + drTemp[i]["MedicationId"] + " and isnull(recorddeleted,'N')<>'Y'");
                            if (ClientMedication1.Length <= 0)
                            {
                                if (Session["DataSetClientSummary"] != null)
                                {
                                    using (DataSet dsSetClientSummary = (DataSet)Session["DataSetClientSummary"])
                                    {
                                        //dsSetClientSummary = (DataSet)Session["DataSetClientSummary"];
                                        ClientMedication1 = dsSetClientSummary.Tables["ClientMedicationInstructions"].Select("StrengthId=" + drTemp[i]["MedicationId"] + " and isnull(recorddeleted,'N')<>'Y'");
                                    }
                                }
                            }
                            if (ClientMedication1.Length > 0)
                            {
                                MedicationId1 = Convert.ToInt32(ClientMedication1[0]["ClientMedicationId"]);
                                //Added By Chandan on 19th Nov 2008 for getting MedicationIdName Task#82
                                ClientMedicationId1Name = ClientMedication1[0]["MedicationName"].ToString();
                                if (ClientMedicationId1Name == string.Empty)
                                {
                                    DataRow[] _drClientMedicationName1 = dsClientMedications.ClientMedications.Select("ClientMedicationId=" + MedicationId1 + " and isnull(RecordDeleted,'N')<>'Y'");
                                    ClientMedicationId1Name = _drClientMedicationName1[0]["MedicationName"].ToString();
                                }
                                //Added End By Chandan on 19th Nov 2008
                            }

                            DataRow[] ClientMedication2 = dsClientMedications.ClientMedicationInstructions.Select("StrengthId=" + drTemp[k]["MedicationId"] + " and isnull(recorddeleted,'N')<>'Y'");
                            if (ClientMedication2.Length <= 0)
                            {
                                using (DataSet dsSetClientSummary = (DataSet)Session["DataSetClientSummary"])
                                {
                                    // dsSetClientSummary = (DataSet)Session["DataSetClientSummary"];
                                    ClientMedication2 = dsSetClientSummary.Tables["ClientMedicationInstructions"].Select("StrengthId=" + drTemp[k]["MedicationId"] + " and isnull(recorddeleted,'N')<>'Y'");
                                }
                            }

                            if (ClientMedication2.Length > 0)
                            {
                                MedicationId2 = Convert.ToInt32(ClientMedication2[0]["ClientMedicationId"]);
                                //Added By Chandan on 19th Nov 2008 for getting MedicationIdName Task#82
                                ClientMedicationId2Name = ClientMedication2[0]["MedicationName"].ToString();
                                if (ClientMedicationId2Name == string.Empty)
                                {
                                    DataRow[] _drClientMedicationName2 = dsClientMedications.ClientMedications.Select("ClientMedicationId=" + MedicationId2 + " and isnull(RecordDeleted,'N')<>'Y'");
                                    ClientMedicationId2Name = _drClientMedicationName2[0]["MedicationName"].ToString();
                                }
                                //Added End By Chandan on 19th Nov 2008

                            }
                            //if (drTemp[i]["MedicationId"]!=null)
                            //    MedicationId1 = Convert.ToInt32(drTemp[i]["MedicationId"]);

                            //if (drTemp[k]["MedicationId"] != null)
                            //    MedicationId2 = Convert.ToInt32(drTemp[k]["MedicationId"]);

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
                                    //Changes with Ref to Task #82
                                    //New ClientMedicationInteractionId should be assigned only if its a new row for ClientMedicationInteractions

                                    if (newRow == true)
                                    {
                                        drInteraction = dsClientMedications.ClientMedicationInteractions.NewClientMedicationInteractionsRow();
                                        drInteraction.ClientMedicationInteractionId = ClientMedicationInteractionId;
                                    }
                                    //changes end over here
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
                                    //Added By Chandan on 19th Nov 2008 for Adding  MedicationIdName- Task#82
                                    drInteraction.ClientMedicationId1Name = ClientMedicationId1Name;
                                    drInteraction.ClientMedicationId2Name = ClientMedicationId2Name;
                                    //End By Chandan

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
                                //Changes With to Task #82
                                //To avoid concureency error for ClientMedicationInteraction and ClientMedicationInteractionDetails
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
                                    /*       if (newDetailsRow)
                                                dsClientMedications.ClientMedicationInteractionDetails.Rows.Add(drClientMedicationDetail);*/
                                }
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
            //Changes end over here
        }

        /// <summary>
        /// This function will be used to Delete Medication from the medication list on click of delete button in Medication List Control
        /// </summary>
        /// <param name="ClientMedicationId"></param>
        //Function Added by Sonia to Delete the Medication from the list only
        [WebMethod(EnableSession = true)]
        public int DeleteMedicationFromList(int Medicationid)
        {
            Streamline.UserBusinessServices.DataSets.DataSetClientMedications DataSetClientMedications;
            ClientMedication objClientMedication = null;
            int oldMedicationId = 0;

            try
            {
                if (Session["DataSetPrescribedClientMedications"] != null)
                {
                    // DataSetClientMedications = (Streamline.UserBusinessServices.DataSets.DataSetClientMedications)Session["DataSetPrescribedClientMedications"];
                    ///New Code///
                    Streamline.UserBusinessServices.DataSets.DataSetClientMedications dsClientMedications = null;
                    CommonFunctions.Event_Trap(this);
                    if (Session["DataSetPrescribedClientMedications"] != null)
                        dsClientMedications = (Streamline.UserBusinessServices.DataSets.DataSetClientMedications)Session["DataSetPrescribedClientMedications"];

                    DataRow[] drClientMedications = dsClientMedications.Tables["ClientMedications"].Select("ClientMedicationId=" + Medicationid.ToString());
                    DataRow[] drClientMedicationInstructions = dsClientMedications.Tables["ClientMedicationInstructions"].Select("ClientMedicationId=" + Medicationid.ToString());

                    /* if (drClientMedicationInstructions.Length > 0)
                     {
                         foreach (DataRow dr1 in drClientMedications)
                         {
                             dr1.Delete();
                         }
                     }*/
                    if (drClientMedications.Length > 0)
                    {
                        foreach (DataRow dr in drClientMedications)
                        {
                            if (String.IsNullOrEmpty(dr["OldClientMedicationId"].ToString()) == false)
                                oldMedicationId = Convert.ToInt32(dr["OldClientMedicationId"].ToString());
                            else
                                oldMedicationId = Convert.ToInt32(dr["ClientMedicationId"].ToString());

                            dr.Delete();
                        }
                    }
                    Session["DataSetPrescribedClientMedications"] = dsClientMedications;
                    DeleteMedicationIdFromSession(oldMedicationId);

                    return dsClientMedications.Tables["ClientMedications"].Select("ISNULL(RecordDeleted,'N')='N'").Length;


                }




                    ///New Code for Deletion ended over here ///




                else
                    return -1;
            }





            catch (Exception ex)
            {
                return -1;
            }
            finally
            {

                objClientMedication = null;
            }

        }

        /// <summary>
        /// Author Sonia
        /// Purpose To Delete the MedicationId from Session's MedicationId's List
        /// </summary>
        /// <param name="DeleteMedicationId"></param>
        public void DeleteMedicationIdFromSession(int DeleteMedicationId)
        {
            ArrayList ArrayListClientMedicationIds = null;
            string Medicationids = "";
            try
            {
                if (Session["ChangedOrderMedicationIds"] != null)
                {
                    Medicationids = Session["ChangedOrderMedicationIds"].ToString();
                    ArrayListClientMedicationIds = ApplicationCommonFunctions.StringSplit(Medicationids, ",");
                    Medicationids = "";
                    for (int i = 0; i < ArrayListClientMedicationIds.Count; i++)
                    {
                        if (Convert.ToInt32(ArrayListClientMedicationIds[i].ToString()) != DeleteMedicationId)
                            Medicationids = Medicationids + ArrayListClientMedicationIds[i] + ",";
                    }
                    Medicationids = Medicationids.TrimEnd(',');
                    Session["ChangedOrderMedicationIds"] = Medicationids;
                }
            }
            catch (Exception ex)
            {

            }
            finally
            {
                ArrayListClientMedicationIds = null;
                Medicationids = null;
            }
        }


        /// <summary>
        /// Acknowledge medications
        /// </summary>
        /// <param name="MedicationId"></param>
        /// <returns></returns>

        [WebMethod(EnableSession = true)]
        //Modified by Loveena in ref to Task#2983 as added one parameter
        public bool AcknowledgeInteraction(int MedicationId, string AllergyType)
        {
            try
            {
                Streamline.UserBusinessServices.DataSets.DataSetClientMedications dsClientMedications = (Streamline.UserBusinessServices.DataSets.DataSetClientMedications)Session["DataSetClientMedications"];
                bool flag = false;
                if (AllergyType == "Interaction")
                {
                    DataRow[] drInteraction = dsClientMedications.ClientMedicationInteractions.Select("ClientMedicationId1=" + MedicationId + "or ClientMedicationId2=" + MedicationId);
                    foreach (DataRow drTemp in drInteraction)
                    {
                        drTemp["PrescriberAcknowledged"] = "Y";
                        flag = true;
                    }
                }
                else if (AllergyType == "Allergy")
                {
                    DataRow[] drClientMedicationId = dsClientMedications.ClientMedications.Select("ClientMedicationId=" + MedicationId);
                    foreach (DataRow drTemp in drClientMedicationId)
                    {
                        drTemp["AllowAllergyMedications"] = "Y";
                        flag = true;
                    }
                }
                return flag;
            }
            catch (Exception ex)
            {

                return false;
            }
        }

        [WebMethod(EnableSession = true)]
        public bool UpdateDAW(int MedicationId, bool status)
        {
            try
            {
                Streamline.UserBusinessServices.DataSets.DataSetClientMedications dsClientMedications;
                if (Session["DataSetClientMedications"] != null)
                    dsClientMedications = (Streamline.UserBusinessServices.DataSets.DataSetClientMedications)Session["DataSetClientMedications"];
                else
                    dsClientMedications = new Streamline.UserBusinessServices.DataSets.DataSetClientMedications();
                DataRow[] drMedication = dsClientMedications.ClientMedications.Select("ClientMedicationId=" + MedicationId);
                if (drMedication.Length > 0)
                {
                    if (status == true)
                        drMedication[0]["DAW"] = "Y";
                    else
                        drMedication[0]["DAW"] = "N";
                    Session["IsDirty"] = true;
                    Session["DataSetClientMedications"] = dsClientMedications;
                }
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
            Streamline.UserBusinessServices.DataSets.DataSetClientMedications dsClientMedications = null;
            DataTable _DataTableClientMedications = null;
            DataTable _DataTableClientMedicationInstructions = null;
            DataTable _DataTableClientMedicationScriptDrugs = null;
            DataTable _DataTableClientMedicationScriptDrugStrengths = null;
            DataTable _DataTableClientMedicationData = null;
            DataTable _DataTableClientMedicationScriptDispenseDays = null;
            try
            {
                if (Session["DataSetClientMedications"] != null)
                    dsClientMedications = (Streamline.UserBusinessServices.DataSets.DataSetClientMedications)Session["DataSetClientMedications"];
                else
                    dsClientMedications = new Streamline.UserBusinessServices.DataSets.DataSetClientMedications();
                _DataTableClientMedicationInstructions = dsClientMedications.ClientMedicationInstructions.Clone();
                DataRow[] _dataRowInstructions = dsClientMedications.ClientMedicationInstructions.Select("ISNULL(Active,'Y')<>'N'");
                foreach (DataRow dr in _dataRowInstructions)
                {
                    _DataTableClientMedicationInstructions.ImportRow(dr);
                }

                _DataTableClientMedications = dsClientMedications.ClientMedications;
                _DataTableClientMedicationData = dsClientMedications.ClientMedicationData;
                _DataTableClientMedicationScriptDrugs = dsClientMedications.ClientMedicationScriptDrugs;
                _DataTableClientMedicationScriptDispenseDays = dsClientMedications.ClientMedicationScriptDispenseDays;

                DataRow[] drClientMedicationInstruction = _DataTableClientMedicationInstructions.Select("IsNull(RecordDeleted,'N')<>'Y' And ClientMedicationId=" + selectedMedicationId, "ClientMedicationInstructionId");

                foreach (var dataRow in drClientMedicationInstruction)
                {
                    dataRow["StartDate2"] = String.Format("{0:MM/dd/yyyy}", dataRow["StartDate"]);
                }

                DataRow[] drClientMedication = _DataTableClientMedications.Select("IsNull(RecordDeleted,'N')<>'Y' And ClientMedicationId=" + selectedMedicationId);
                DataRow[] drClientMedicationData = _DataTableClientMedicationData.Select("ClientMedicationId=" + selectedMedicationId);
                DataRow[] drClientMedicationScriptDispenseDays = _DataTableClientMedicationScriptDispenseDays.Select("IsNull(RecordDeleted,'N')<>'Y' And ClientMedicationId=" + selectedMedicationId, "ClientMedicationInstructionId");

                _DataTableClientMedicationScriptDrugStrengths = dsClientMedications.ClientMedicationScriptDrugStrengths.Clone();
                DataRow[] _dataRowScriptDrugStrengths = dsClientMedications.ClientMedicationScriptDrugStrengths.Select("IsNull(RecordDeleted,'N')<>'Y'");
                foreach (DataRow dr in _dataRowScriptDrugStrengths)
                {
                    _DataTableClientMedicationScriptDrugStrengths.ImportRow(dr);
                }
                DataRow[] drClientMedicationScriptDrugStrengths = _DataTableClientMedicationScriptDrugStrengths.Select("IsNull(RecordDeleted,'N')<>'Y' And ClientMedicationId=" + selectedMedicationId, "ClientMedicationScriptDrugStrengthId");
                DataSet dsTemp = new DataSet("ClientMedication");
                dsTemp.Merge(drClientMedication);
                var drCMI =
                    drClientMedicationInstruction.AsEnumerable()
                                                          .OrderBy(
                                                              cmi =>
                                                              Convert.ToInt32(
                                                                  cmi["ClientMedicationInstructionId"].ToString()) > 0
                                                                  ? 0
                                                                  : 1).ThenBy(cmi2 => Convert.ToInt32(
                                                                  cmi2["ClientMedicationInstructionId"].ToString()) >= 0 ? Convert.ToInt32(
                                                                  cmi2["ClientMedicationInstructionId"].ToString()) : Convert.ToInt32(
                                                                  cmi2["ClientMedicationInstructionId"].ToString()) * -1).CopyToDataTable<DataRow>();
                drCMI.TableName = "ClientMedicationInstruction";
                dsTemp.Merge(drCMI);

                foreach (DataRow drTemp in drCMI.AsEnumerable()) // drClientMedicationInstruction)
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
                dsTemp.Merge(drClientMedicationScriptDrugStrengths);
                dsClientMedications.ClientMedicationScripts.Rows[0]["ScriptEventType"] = "N";
                dsTemp.Merge(dsClientMedications.ClientMedicationScripts);
                dsTemp.Merge(drClientMedicationData);
                if (drClientMedicationScriptDispenseDays.Length > 0)
                {
                    var drCMDD =
                        drClientMedicationScriptDispenseDays.AsEnumerable()
                                                              .OrderBy(
                                                                  cmi =>
                                                                  Convert.ToInt32(
                                                                      cmi["ClientMedicationInstructionId"].ToString()) > 0
                                                                      ? 0
                                                                      : 1).ThenBy(cmi2 => Convert.ToInt32(
                                                                      cmi2["ClientMedicationInstructionId"].ToString()) >= 0 ? Convert.ToInt32(
                                                                      cmi2["ClientMedicationInstructionId"].ToString()) : Convert.ToInt32(
                                                                      cmi2["ClientMedicationInstructionId"].ToString()) * -1).CopyToDataTable<DataRow>();
                    drCMDD.TableName = "ClientMedicationScriptDispenseDays";
                    dsTemp.Merge(drCMDD);
                }

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

        /// <summary>
        /// 
        /// </summary>
        /// <param name="selectedMedicationId"></param>
        /// <returns></returns>
        [WebMethod(EnableSession = true)]
        public DataSet RadioButtonClickTitration(int medicationId, int titrationStepNumber)
        {
            Streamline.UserBusinessServices.DataSets.DataSetClientMedications dsClientMedications = null;
            DataTable _DataTableClientMedications = null;
            DataTable _DataTableClientMedicationInstructions = null;
            DataTable _DataTableClientMedicationScriptDrugs = null;
            try
            {

                if (Session["DataSetTitration"] != null)
                    dsClientMedications = (Streamline.UserBusinessServices.DataSets.DataSetClientMedications)Session["DataSetTitration"];
                else
                    dsClientMedications = new Streamline.UserBusinessServices.DataSets.DataSetClientMedications();

                _DataTableClientMedications = dsClientMedications.ClientMedications;
                _DataTableClientMedicationInstructions = dsClientMedications.ClientMedicationInstructions;
                _DataTableClientMedicationScriptDrugs = dsClientMedications.ClientMedicationScriptDrugs;

                DataRow[] drClientMedicationInstruction = _DataTableClientMedicationInstructions.Select("IsNull(RecordDeleted,'N')<>'Y' And TitrationStepNumber=" + titrationStepNumber, "TitrationStepNumber");
                DataRow[] drClientMedication = _DataTableClientMedications.Select("IsNull(RecordDeleted,'N')<>'Y' And ClientMedicationId=" + medicationId);

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

        // <summary>
        /// This function will be used to Populate Medication Row on click of Ch Button in Prescribe List
        ///  //Function Added by Sonia
        /// </summary>
        /// <param name="ClientMedicationId"></param>

        [WebMethod(EnableSession = true)]
        public int PopulateRowDataOfMedicationList(int Medicationid, string method)
        {
            DataTable _DataTableClientMedications;
            DataTable _DataTableClientMedicationInstructions;
            DataTable _DataTableClientMedicationScriptDrugs;
            //DataTable _DataTableClientMedicationInteractions;
            //DataTable _DataTableClientMedicationInteractionDetails;
            DataTable dtTemp;
            DataTable dtTemp1;
            DataTable dtTemp2;
            //DataTable dtTemp3;
            Streamline.UserBusinessServices.DataSets.DataSetClientMedications DataSetClientMedications;
            Streamline.UserBusinessServices.DataSets.DataSetClientMedications DataSetPrescribedClientMedications;
            DataSet _DataSetClientSummary;

            try
            {
                DataSetClientMedications = new Streamline.UserBusinessServices.DataSets.DataSetClientMedications();
                DataSetPrescribedClientMedications = (Streamline.UserBusinessServices.DataSets.DataSetClientMedications)Session["DataSetPrescribedClientMedications"];

                DataSetClientMedications.EnforceConstraints = false;
                DataSetClientMedications.Tables["ClientMedications"].Merge(DataSetPrescribedClientMedications.Tables["ClientMedications"]);
                DataSetClientMedications.Tables["ClientMedicationInstructions"].Merge(DataSetPrescribedClientMedications.Tables["ClientMedicationInstructions"]);
                DataSetClientMedications.Tables["ClientMedicationScriptDrugs"].Merge(DataSetPrescribedClientMedications.Tables["ClientMedicationScriptDrugs"]);

                DataSetClientMedications.Tables["ClientMedicationInteractions"].Merge(DataSetPrescribedClientMedications.Tables["ClientMedicationInteractions"]);
                DataSetClientMedications.Tables["ClientMedicationInteractionDetails"].Merge(DataSetPrescribedClientMedications.Tables["ClientMedicationInteractionDetails"]);


                _DataTableClientMedications = DataSetClientMedications.Tables["ClientMedications"];
                _DataTableClientMedicationInstructions = DataSetClientMedications.Tables["ClientMedicationInstructions"];
                _DataTableClientMedicationScriptDrugs = DataSetClientMedications.Tables["ClientMedicationScriptDrugs"];

                dtTemp = _DataTableClientMedications.Clone();
                dtTemp1 = _DataTableClientMedicationInstructions.Clone();
                dtTemp2 = _DataTableClientMedicationScriptDrugs.Clone();


                //Set the Primary Key for ClientMedications
                DataColumn[] dcDataTableClientMedications = new DataColumn[1];
                dcDataTableClientMedications[0] = _DataTableClientMedications.Columns["ClientMedicationId"];
                _DataTableClientMedications.PrimaryKey = dcDataTableClientMedications;


                //Add the Rows into ClientMedications based on ClientMedicationId
                DataRow drClientMedicationtobeInserted = _DataTableClientMedications.Rows.Find(Medicationid);
                dtTemp.Rows.Add(drClientMedicationtobeInserted.ItemArray);

                //Add the Rows into ClientMedicationInstructions based on ClientMedicationId
                DataRow[] drClientMedicationInstructionRows = _DataTableClientMedicationInstructions.Select("ClientMedicationId=" + Medicationid.ToString());
                foreach (DataRow dr1 in drClientMedicationInstructionRows)
                {
                    dtTemp1.Rows.Add(dr1.ItemArray);

                    DataRow[] drClientMedicationScriptDrugs = _DataTableClientMedicationScriptDrugs.Select("ClientMedicationInstructionId=" + Convert.ToInt32(dr1["ClientMedicationInstructionId"]));
                    if (drClientMedicationScriptDrugs.Length > 0)
                        dtTemp2.Rows.Add(drClientMedicationScriptDrugs[0].ItemArray);
                }

                DataSetClientMedications.Clear();

                //Adding a Dummy row in the ClientMedicationScripts table
                //So that the clientmedicationscriptdrugs does not throw a foreignkey voilation error
                DataRow drClientMedicationScripts;
                if (DataSetClientMedications.Tables["ClientMedicationScripts"].Rows.Count < 1)
                    drClientMedicationScripts = DataSetClientMedications.Tables["ClientMedicationScripts"].NewRow();
                else
                    drClientMedicationScripts = DataSetClientMedications.Tables["ClientMedicationScripts"].Rows[0];

                drClientMedicationScripts["Clientid"] = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId;
                drClientMedicationScripts["OrderingMethod"] = "P";

                drClientMedicationScripts["PharmacyId"] = System.DBNull.Value;
                drClientMedicationScripts["PrintDrugInformation"] = System.DBNull.Value;
                drClientMedicationScripts["ScriptCreationDate"] = DateTime.Now;
                drClientMedicationScripts["OrderDate"] = DateTime.Now;
                drClientMedicationScripts["LocationId"] = System.DBNull.Value;
                drClientMedicationScripts["ScriptEventType"] = "C";

                drClientMedicationScripts["OrderingPrescriberId"] = 731;
                drClientMedicationScripts["OrderingPrescriberName"] = "sdjfsdj";

                drClientMedicationScripts["RowIdentifier"] = System.Guid.NewGuid();
                drClientMedicationScripts["CreatedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                drClientMedicationScripts["CreatedDate"] = DateTime.Now;
                drClientMedicationScripts["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                drClientMedicationScripts["ModifiedDate"] = DateTime.Now;
                if (DataSetClientMedications.Tables["ClientMedicationScripts"].Rows.Count < 1)
                    DataSetClientMedications.Tables["ClientMedicationScripts"].Rows.Add(drClientMedicationScripts);


                DataSetClientMedications.Tables["ClientMedications"].Merge(dtTemp);
                DataSetClientMedications.Tables["ClientMedicationInstructions"].Merge(dtTemp1);
                DataSetClientMedications.Tables["ClientMedicationScriptDrugs"].Merge(dtTemp2);


                Session["DataSetClientMedications"] = DataSetClientMedications;
                getDrugInteraction(DataSetClientMedications);
                Session["IsDirty"] = true;
                return 1;
            }
            catch (Exception ex)
            {

                return -1;
            }



        }


        /// <summary>
        /// This function will be called from javascript to fill GridViewClientAllergies
        /// </summary>
        /// <param name="SiteId"></param>
        /// <param name="Providerid"></param>
        /// <returns></returns>
        /// -----Modification History---------------
        /// Date -----Author-----------Purpose-------
        /// 20 Oct 2009 Pradeep        Ref.task#9(Addedd one parameter FilterCriteria)
        [WebMethod(EnableSession = true)]
        public StringBuilder GetAllergy_Html(DataSet DataSetClientAllergies, char EditableList, string FilterCriteriaList, string UpdateInformation)
        {
            try
            {
                string[] filterlist = FilterCriteriaList.Split(',');
                string FilterCriteria = filterlist.Length > 0 ? filterlist[0] : FilterCriteriaList;
                string FilterCriteriaActiveInactive = filterlist.Length > 1 ? filterlist[1] : "active";
                //Creating Object of StringBuilder
                StringBuilder GridHtml = new StringBuilder();
                //Createing Variables that will store integer value of parameter
                //DataSet DataSetSiteContact;
                DataView DataViewClientAllergies;
                Streamline.UserBusinessServices.DataSets.MedicationList.AllergiesInteractionDataTable DataTableAllergies;
                //Creating object of bll class
                string AllergenConceptId;
                string ClientAllergyId;
                string ConceptDescription;
                string ControlId;
                string controlRowID = "";
                string AllergyType = string.Empty;
                string LastModified = string.Empty;
                //Boolean ShowToolTip = false;
                string ToolTipToShow = string.Empty;
                //Added By Priya Ref: Task No:-2829
                string CommentId;

                DataViewClientAllergies = DataSetClientAllergies.Tables[0].DefaultView;
                //Sorting Dataview
                DataViewClientAllergies.Sort = "ConceptDescription";
                //Filter dataview
                #region--refTask#9Venture
                if (FilterCriteria.Trim() != "All")
                {
                    if (FilterCriteria.Trim().ToUpper() == "A")//if AllergyType is null then treat it as "Allergy"
                    {
                        DataViewClientAllergies.RowFilter = "ISNULL(AllergyType,'A')='A'";
                    }
                    else
                    {
                        DataViewClientAllergies.RowFilter = "AllergyType='" + FilterCriteria + "'";
                    }
                }
                #endregion
                GridHtml.Append(" <input type='hidden' id='allergyresultresponse' value='");
                GridHtml.Append(UpdateInformation);
                GridHtml.Append("' />");
                GridHtml.Append(" <div id='DIVAllergies' style='width: 100%; height: 100%; overflow: auto'>");
                GridHtml.Append("<div>");
                GridHtml.Append("<table class='SumarryLabel' id='ClientAllergyList' cellspacing='0'  cellpadding='0' border='0' style='width:90%;border-collapse:collapse;'>");

                var theresData = false;
                var rowClass = "GridViewRowStyle";

                //Set the Header Row
                if (DataViewClientAllergies.Count > 0)
                {
                    for (int i = 0; i < DataViewClientAllergies.Count; i++)
                    {
                        var allergyActive = DataViewClientAllergies[i]["Active"].ToString();

                        if ((!allergyActive.ToLower().Equals("n") && FilterCriteriaActiveInactive == "active") || (FilterCriteriaActiveInactive == "inactive"))
                        {
                            theresData = true;
                            ClientAllergyId = DataViewClientAllergies[i]["ClientAllergyId"].ToString();
                            //Triming Text length if it is larger
                            ConceptDescription = DataViewClientAllergies[i]["ConceptDescription"].ToString();
                            AllergenConceptId = DataViewClientAllergies[i]["AllergenConceptId"].ToString();
                            #region----cahanges as per task#9 By Pradeep
                            AllergyType = DataViewClientAllergies[i]["AllergyType"].ToString();
                            LastModified = DataViewClientAllergies[i]["LastModifiedDate"].ToString();
                            if (AllergyType.Trim() != string.Empty)
                            {
                                if (AllergyType.Trim().ToUpper() == "A")
                                {
                                    AllergyType = "(Allergy)";
                                }
                                else if (AllergyType.Trim().ToUpper() == "I")
                                {
                                    AllergyType = "(Intolerances)";
                                }
                                else if (AllergyType.Trim().ToUpper() == "F")
                                {
                                    AllergyType = "(Failed Trials)";
                                }
                            }
                            else
                            {
                                AllergyType = "(Allergy)";
                            }
                            #endregion

                            ControlId = "Control_ASP.usercontrols_medicationmgt_ascx$MedicationClientPersonalInformation1$GridViewAllergies$ctl" + i + "$btnDelete";
                            //added By Priya ref: Task no:2829
                            CommentId = "Control_ASP.usercontrols_medicationmgt_ascx$MedicationClientPersonalInformation1$GridViewAllergies$ctl" + i + "$HiddenComment";

                            controlRowID = "ClientAllergyListRow_" + i;

                            //if (EditableList == 'Y')
                            {
                                //GridHtml.Append("<tr id='" + controlRowID.Trim() + "' class='GridViewRowStyle'>");
                                 GridHtml.Append("<tr id='" + controlRowID.Trim() + "' class='" + rowClass + "'>");
                                 rowClass = rowClass == "GridViewRowStyle" ? "GridViewAlternatingRowStyle" : "GridViewRowStyle";
                                GridHtml.Append("<td valign='top' style='height:15px;'><table cellspacing='0' cellpadding='0'><tr");
                                if (allergyActive.ToLower().Equals("n"))
                                    GridHtml.Append(" class='GridViewRowStyleInactive'");
                                GridHtml.Append(">");
                                if (Session["DataSetAllergy"] != null)
                                {
                                    DataTableAllergies = (Streamline.UserBusinessServices.DataSets.MedicationList.AllergiesInteractionDataTable)Session["DataSetAllergy"];
                                    DataRow[] DataRowAllergies = DataTableAllergies.Select("AllergenConceptId=" + AllergenConceptId);

                                    if (DataRowAllergies.Length > 0)
                                    {

                                        #region---Code Written By Pradeep
                                        //--Following line is written by pradeep as converting DataRowAllergies[0]["Color"] value into int if this is not null
                                        string ColorCode = DataRowAllergies[0]["Color"] == DBNull.Value ? "" : Convert.ToString(DataRowAllergies[0]["Color"]);
                                        if (ColorCode != string.Empty)
                                        {
                                            System.Drawing.Color objectBackColor = System.Drawing.Color.FromArgb(Convert.ToInt32(ColorCode));
                                            string BackColor = objectBackColor.Name.ToString();
                                            BackColor = BackColor.Substring(2, 6);
                                            GridHtml.Append("<td style='border: #000 thin solid;width:1%;height:5px;background-color:#" + BackColor + ";' valign='top' align='left'>&nbsp;</td>");
                                        }
                                        else
                                        {
                                            GridHtml.Append("<td style='border: #000 thin solid;width:1%;height:5px;' valign='top' align='left'>&nbsp;</td>");
                                        }
                                        #endregion
                                    }
                                   // else
                                       // GridHtml.Append("<td style='width:1%;height:5px;' valign='top'></td>");
                                }
                                //else
                                //{
                                //    GridHtml.Append("<td style='width:1%;height:5px;' valign='top'></td>");

                                //}
                                //Added By Priya Ref:task No:2829
                               // GridHtml.Append("<td valign='top' style='width:2%' align='left'>&nbsp;</td>");
                                GridHtml.Append(
                                    "<td align='center' valign='top' style='width:3%'><img  Width='12px' Height='12px' title='Delete' src='App_Themes/Includes/Images/deleteIcon.gif' style='cursor:hand;border-width:0px;' ");
                                if (
                                    ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).HasPermission(
                                        Permissions.AddAllergy) == true)
                                {
                                    GridHtml.Append("onclick=\"DeleteAllergy(" + ClientAllergyId + ",'#" +
                                                    controlRowID + "','#ClientAllergyList');return false;\" />");
                                }
                                else
                                {
                                    GridHtml.Append(" />");
                                }
                                GridHtml.Append("</td>");
                                var allergyComment = DataViewClientAllergies[i]["Comment"].ToString();
                                var allergyCommentImg = allergyComment.Trim().Equals(String.Empty) ? "no_comment.png" : "comment.png";
                                // HttpContext.Current.Server.HtmlEncode(allergyComment)
                                GridHtml.Append("<td align='center' valign='top' style='width:3%'><img Height='12px' title=\"" + allergyComment.Replace("\"", "''") + "\" src='App_Themes/Includes/Images/" + allergyCommentImg.Trim() + "' ");
                                if (((Streamline.BaseLayer.StreamlinePrinciple)Context.User).HasPermission(Permissions.AddAllergy) == true)
                                {
                                    GridHtml.Append("onclick=\"OpenAllergyCommentDetails(" + ClientAllergyId + ",'" + DataViewClientAllergies[i]["AllergyType"].ToString() + "','" + allergyActive.Trim() + "','" + System.Uri.EscapeDataString(allergyComment).Replace("'", "%27") + "');return false;\"  style='cursor:hand ;border-width:0px;' />");
                                }
                                else
                                {
                                    GridHtml.Append("style='border-width:0px;' disabled='disabled' />");
                                }
                                GridHtml.Append("</td>");



                                #region---Code written by Pradeep as per task#9

                                var reactionCode = DataViewClientAllergies[i]["AllergyReaction"].ToString() == "" ? "None" : DataViewClientAllergies[i]["AllergyReaction"].ToString();
                                var SeverityCode = DataViewClientAllergies[i]["AllergySeverity"].ToString() == "" ? "None" : DataViewClientAllergies[i]["AllergySeverity"].ToString();
                                var reactionSeverityCode = "Reaction - " + reactionCode + System.Environment.NewLine +
                                                           "Severity - " + SeverityCode;

                                GridHtml.Append("<td align='left'  valign='top' style='width:3%;'><img Height='12px' title=\"" + reactionSeverityCode + "\" src='App_Themes/Includes/Images/info1.gif'");
                                GridHtml.Append("style='border-width:0px;' disabled='disabled' />");
                                GridHtml.Append("</td>");

                                GridHtml.Append("<td valign='top' style='width:70%' align='left'>" + ConceptDescription + " " + AllergyType + "</td>");
                                GridHtml.Append("<td valign='top' style='width:5%' align='left'>" + LastModified.ToString() + "</td>");
                                GridHtml.Append("</tr></table>");
                                GridHtml.Append("</td></tr>");
                                #endregion
                            }
                            //else
                            //{
                            //    GridHtml.Append("<tr class='GridViewRowStyle'>");
                            //    if (DataViewClientAllergies[i]["Comment"].ToString() != "")
                            //    {
                            //        GridHtml.Append("<td align='center' valign='top' style='width:15%'>");
                            //        GridHtml.Append("<IMG Height='15px' name='" + ControlId + "' id='" + ControlId);
                            //        GridHtml.Append("' title=\"" + DataViewClientAllergies[i]["Comment"].ToString() + "\" src='App_Themes/Includes/Images/comment.png' style='border-width:0px;' />");
                            //        GridHtml.Append("</td>");

                            //    }
                            //    else
                            //    {
                            //        GridHtml.Append("<td align='center' valign='top' style='width:15%'>");
                            //        GridHtml.Append("<IMG Height='15px' name='" + ControlId + "' id='" + ControlId);
                            //        GridHtml.Append("' title=\"" + DataViewClientAllergies[i]["Comment"].ToString() + "\" src='App_Themes/Includes/Images/no_comment.png' style='border-width:0px;' />");
                            //        GridHtml.Append("</td>");
                            //    }
                            //    #region--Code Comented By Pradeep as per task#9
                            //    GridHtml.Append("<td  colspan='3' valign='top' align='left' nowrap='false'>" + ConceptDescription + " " + AllergyType + "</td>");
                            //    GridHtml.Append("</tr>");
                            //    #endregion
                            //}

                        }
                    }
                    if (theresData == false)
                    {
                        //GridHtml.Append("<tr><td>&nbsp;</td></tr><tr class='GridViewRowStyle'><td align='center' colspan=3><td>No Known Medication/Other Allergies </td></tr>");
                        GridHtml.Append("<tr><td>&nbsp;</td></tr><tr class='GridViewRowStyle'><td align='center' colspan=3><td></td></tr>");
                    }
                }
                else
                    //GridHtml.Append("<tr><td>&nbsp;</td></tr><tr class='GridViewRowStyle'><td align='center' colspan=3><td>No Known Medication/Other Allergies </td></tr>");
                    GridHtml.Append("<tr><td>&nbsp;</td></tr><tr class='GridViewRowStyle'><td align='center' colspan=3><td></td></tr>");

                GridHtml.Append("</table></div></div>");
                return GridHtml;
            }
            catch (Exception ex)
            {
                return null;

            }
        }






        /// <summary>
        /// This function will be used to Delete Allergy from the Client Allergy list on click of delete button in Allergy List 
        /// </summary>
        /// <param name="ClientAllergyId"></param>
        //Function Added by Sonia 
        [WebMethod(EnableSession = true)]
        public string DeleteAllergy(int ClientAllergyId)
        {
            DataSet DataSetFinal;
            DataSet _DataSetClientSummary;
            DataTable DataTableClientAllergies;
            string result = "";
            string allergyType = "";
            try
            {
                if (Session["DataSetClientSummary"] != null)
                {

                    DataSetFinal = new DataSet();
                    _DataSetClientSummary = new DataSet();

                    _DataSetClientSummary = (DataSet)Session["DataSetClientSummary"];
                    DataTableClientAllergies = _DataSetClientSummary.Tables["ClientAllergies"].Clone();
                    Streamline.UserBusinessServices.ClientMedication objClientMedications = new Streamline.UserBusinessServices.ClientMedication();
                    objClientMedications.DeleteAllergy(ClientAllergyId, ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId, ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode);
                    DataRow[] DataRowAllergies = _DataSetClientSummary.Tables["ClientAllergies"].Select("ClientAllergyId<>" + ClientAllergyId);
                    DataRow[] drDelAllergy = _DataSetClientSummary.Tables["ClientAllergies"].Select("ClientAllergyId = " + ClientAllergyId);
                    if (drDelAllergy.Length > 0)
                    {
                        switch (drDelAllergy[0]["AllergyType"].ToString())
                        {
                            case "A":
                                result = "update"; //"AllergyDeleted";
                                break;
                            case "I":
                                result = "update"; //"IntolleranceDeleted";
                                break;
                            case "F":
                                result = "update"; //"FailedTrialDeleted";
                                break;
                        }
                    }

                    if (DataRowAllergies.Length > 0)
                    {
                        foreach (DataRow dr in DataRowAllergies)
                        {

                            DataTableClientAllergies.Rows.Add(dr.ItemArray);

                        }

                        _DataSetClientSummary.Tables["ClientAllergies"].Clear();
                        _DataSetClientSummary.Tables["ClientAllergies"].Merge(DataTableClientAllergies);
                    }
                    else if (DataRowAllergies.Length == 0)
                    {
                        _DataSetClientSummary.Tables["ClientAllergies"].Clear();
                        _DataSetClientSummary.Tables["ClientAllergies"].Merge(DataTableClientAllergies);
                    }
                    // DataSetFinal = objClientMedications.GetClientAllergiesData(((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId);


                    Session["DataSetClientSummary"] = _DataSetClientSummary;
                    FillClientAllergyInteractionTable();
                    return result;
                }
                else
                    return result;
            }
            catch (Exception ex)
            {
                return result;
            }
            finally
            {
                DataSetFinal = null;
                _DataSetClientSummary = null;
            }
        }

        /// <summary>
        /// This function will be used to insert the Allergy Record into  Client Allergy list on click of select button in Allergy List 
        /// </summary>
        /// <param name="ClientAllergyId"></param>
        //Function Added by Sonia 
        //Modfied by Loveena in ref to Task#86 added one more parameter Comments
        [WebMethod(EnableSession = true)]
        public string SaveAllergyId(int AllergyId, string AllergyType, string comments, string active, int AllergyReaction, int AllergySeverity)
        {
            Streamline.UserBusinessServices.ClientMedication objClientMedications;
            DataView DataViewClientAllergies;
            DataRowView DataRowClientAllergies;
            DataSet DataSetFinal;
            DataSet _DataSetClientSummary;
            //Streamline.UserBusinessServices.DataSets.DataSetClientMedications.ClientAllergiesInteractionDataTable DataTableClientAllergiesInteraction;
            Streamline.UserBusinessServices.DataSets.DataSetClientAllergies DataSetClientAllergies;
            string result = "";
            try
            {
                if (Session["DataSetClientSummary"] != null)
                {

                    objClientMedications = new ClientMedication();
                    _DataSetClientSummary = new DataSet();
                    _DataSetClientSummary = (DataSet)Session["DataSetClientSummary"];
                    //Modified in ref to Task#2935 1.9.8.12 Duplicate Allergies Check
                    //DataRow[] DataRowTemps = _DataSetClientSummary.Tables["ClientAllergies"].Select("AllergenConceptId=" + AllergyId);
                    DataRow[] DataRowTemps = _DataSetClientSummary.Tables["ClientAllergies"].Select("AllergenConceptId=" + AllergyId + " and AllergyType='" + AllergyType + "'");
                    if (DataRowTemps.Length > 0)
                    {
                        return "AlreadyExists";

                    }
                    else
                    {

                        //string selectedValue = AllergyId;
                        DataSetClientAllergies = new Streamline.UserBusinessServices.DataSets.DataSetClientAllergies();
                        DataViewClientAllergies = DataSetClientAllergies.Tables["ClientAllergies"].DefaultView;
                        DataViewClientAllergies.AddNew();
                        DataRowClientAllergies = DataViewClientAllergies[0];
                        DataRowClientAllergies["ClientAllergyId"] = 0;
                        DataRowClientAllergies["ClientId"] = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId;
                        DataRowClientAllergies["AllergenConceptId"] = AllergyId;
                        //Code added by Loveena in ref to Task#86
                        if (comments != "")
                            DataRowClientAllergies["Comment"] = comments;
                        else
                            DataRowClientAllergies["Comment"] = System.DBNull.Value;

                        //Added By Arjun K R #49 MeaningfullUse Stage 3
                        if (AllergyReaction != -1)
                        {
                            DataRowClientAllergies["AllergyReaction"] = AllergyReaction;
                        }
                        else
                        {
                            DataRowClientAllergies["AllergyReaction"] = System.DBNull.Value;

                        }

                        if (AllergySeverity != -1)
                        {
                            DataRowClientAllergies["AllergySeverity"] = AllergySeverity;
                        }
                        else
                        {
                            DataRowClientAllergies["AllergySeverity"] = System.DBNull.Value;

                        }
                        //End here

                        DataRowClientAllergies["Active"] = active;
                        //Code ends over here.
                        #region--Changes as per task#9 By Pradeep
                        DataRowClientAllergies["AllergyType"] = AllergyType;
                        #endregion
                        //Code added by Loveena in ref to Task#2626
                        //Start---CodeComented By Pradeep 21 Nov 2009 as we have written DataRowClientAllergies["AllergyType"] = AllergyType; in above section  
                        //DataRowClientAllergies["AllergyType"] = System.DBNull.Value;
                        //End---CodeComented By Pradeep 21 Nov 2009

                        DataRowClientAllergies["CreatedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode.ToString();
                        DataRowClientAllergies["CreatedDate"] = DateTime.Now;
                        DataRowClientAllergies["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode.ToString();
                        DataRowClientAllergies["ModifiedDate"] = DateTime.Now;
                        DataRowClientAllergies["RecordDeleted"] = 'N';
                        DataRowClientAllergies["RowIdentifier"] = System.Guid.NewGuid();
                        DataRowClientAllergies.EndEdit();
                        DataSetFinal = objClientMedications.UpdateClientAllergies(DataSetClientAllergies, ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId, ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode);

                        switch (AllergyType)
                        {
                            case "A":
                                result = "update"; //"AllergyAdded";
                                break;
                            case "I":
                                result = "update"; //"IntoleranceAdded";
                                break;
                            case "F":
                                result = "update"; //"FailedTrialAdded";
                                break;
                        }

                    }

                    DataSetFinal = objClientMedications.GetClientAllergiesData(((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId);

                    _DataSetClientSummary.Tables["ClientAllergies"].Clear();
                    _DataSetClientSummary.Tables["ClientAllergies"].Merge(DataSetFinal.Tables[0]);
                    Session["DataSetClientSummary"] = _DataSetClientSummary;


                    FillClientAllergyInteractionTable();
                    return result;
                }
                else
                    return result;
            }
            catch (Exception ex)
            {
                return result;
            }
            finally
            {
                objClientMedications = null;
                DataViewClientAllergies = null;
                DataRowClientAllergies = null;
                DataSetFinal = null;

                DataSetClientAllergies = null;

            }

        }

        /// <summary>
        /// This function will be used to Refresh Patient Overview on save of EditPreferredPharmacies.
        /// </summary>        
        //Function Added by Loveena in Ref to Task#92.
        [WebMethod(EnableSession = true)]
        public string GetPatientOverviewContents()
        {
            DataSet _DataSetClientSummary = null;
            string GridHTML = string.Empty;
            try
            {
                //Modified by Loveena in ref to Task#2433 on 15-April-2009 to get HTML area
                //from External Interface if External interface is true.
                if (System.Configuration.ConfigurationSettings.AppSettings["ExternalInterface"].ToString().ToUpper() == "TRUE" && Session["ExternalClientInformation"] != null)
                {
                    _DataSetClientSummary = (DataSet)Session["ExternalClientInformation"];
                    GridHTML = _DataSetClientSummary.Tables["ClientHTMLSummary"].Rows[0][0].ToString();
                }
                else
                {
                    _DataSetClientSummary = (DataSet)Session["DataSetClientSummary"];
                    GridHTML = _DataSetClientSummary.Tables["ClientInfoAreaHtml"].Rows[0][0].ToString();
                }
                return GridHTML.ToString();
            }
            catch (Exception ex)
            {

                return null;
            }
        }

        [WebMethod(EnableSession = true)]
        public bool DeleteClientMedication(int selectedMedicationId)
        {
            bool tempflag = false;
            ArrayList ArrayListClientMedicationIds;
            int oldMedicationId = -1;
            try
            {
                Streamline.UserBusinessServices.DataSets.DataSetClientMedications dsClientMedications = null;
                DataTable _DataTableClientMedication = null;
                DataTable _DataTableClientMedicationInstructions = null;
                DataTable _DataTableClientMedicationInteraction = null;
                //Code added by Loveena in Ref to Task# 149 on 08-Jan-2009 to set Record Deleted to 'Y' in ClientMedicationScriptDrugs
                DataTable _DataTableClientMedicationScriptDrugs = null;
                //Code added by Loveena ends over here.

                DataTable _DataTableClientMedicationScriptDrugStrengths = null;
                //DataTable DtTemp = null;
                if (Session["DataSetClientMedications"] != null)
                    dsClientMedications = (Streamline.UserBusinessServices.DataSets.DataSetClientMedications)Session["DataSetClientMedications"];
                else
                    dsClientMedications = new Streamline.UserBusinessServices.DataSets.DataSetClientMedications();

                _DataTableClientMedication = dsClientMedications.ClientMedications;
                _DataTableClientMedicationInstructions = dsClientMedications.ClientMedicationInstructions;
                _DataTableClientMedicationInteraction = dsClientMedications.ClientMedicationInteractions;
                //Code added by Loveena in Ref to Task# 149 on 08-Jan-2009 to set Record Deleted to 'Y' in ClientMedicationScriptDrugs
                _DataTableClientMedicationScriptDrugs = dsClientMedications.ClientMedicationScriptDrugs;
                //Code added by Loveena ends over here.
                _DataTableClientMedicationScriptDrugStrengths = dsClientMedications.ClientMedicationScriptDrugStrengths;

                DataRow[] drClientMedicationInteraction = _DataTableClientMedicationInteraction.Select("ClientMedicationId1=" + selectedMedicationId + " or ClientMedicationId2=" + selectedMedicationId);
                if (drClientMedicationInteraction.Length > 0)
                {
                    for (int i = 0; i < drClientMedicationInteraction.Length; i++)
                    {
                        drClientMedicationInteraction[i]["RecordDeleted"] = "Y";
                        drClientMedicationInteraction[i]["DeletedDate"] = Convert.ToDateTime(DateTime.Now.ToShortDateString());
                        drClientMedicationInteraction[i]["DeletedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                    }
                }
                DataRow[] drClientMedication = _DataTableClientMedication.Select("ClientMedicationId=" + selectedMedicationId);
                if (drClientMedication.Length > 0)
                {
                    if (drClientMedication[0].RowState == DataRowState.Added)
                    {
                        if (drClientMedication[0]["OldClientMedicationId"] != System.DBNull.Value)
                            oldMedicationId = Convert.ToInt32(drClientMedication[0]["OldClientMedicationId"].ToString());
                        else
                            oldMedicationId = Convert.ToInt32(drClientMedication[0]["ClientMedicationId"]);
                        drClientMedication[0].Delete();
                        tempflag = true;
                    }
                    else
                    {
                        //To set RecordDeleted Y so that they are not shown in MedicationList and also in Database.
                        drClientMedication[0]["RecordDeleted"] = "Y";
                        drClientMedication[0]["DeletedDate"] = Convert.ToDateTime(DateTime.Now.ToShortDateString());
                        drClientMedication[0]["DeletedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                    }
                }
                //DtTemp = _DataTableClientMedicationInstructions.Clone();
                DataRow[] drClientMedicationInstruction = _DataTableClientMedicationInstructions.Select("ClientMedicationId=" + selectedMedicationId);
                if (drClientMedicationInstruction.Length > 0)
                {
                    for (int i = 0; i < drClientMedicationInstruction.Length; i++)
                    {
                        //To set RecordDeleted Y so that they are not shown in MedicationList and also in Database.
                        drClientMedicationInstruction[i]["RecordDeleted"] = "Y";
                        drClientMedicationInstruction[i]["DeletedDate"] = Convert.ToDateTime(DateTime.Now.ToShortDateString());
                        drClientMedicationInstruction[i]["DeletedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                        //DtTemp.Rows.Add(drClientMedicationInstruction);                        
                        tempflag = true;
                        //Code added by Loveena in Ref to Task#149 on 08-Jan-2009 to set Record Deleted to 'Y' in ClientMedicationScriptDrugs.
                        DataRow[] drClientMedicationScriptDrugs = _DataTableClientMedicationScriptDrugs.Select("ClientMedicationInstructionId=" + drClientMedicationInstruction[i]["ClientMedicationInstructionId"]);
                        for (int j = 0; j < drClientMedicationScriptDrugs.Length; j++)
                        {
                            //To set RecordDeleted Y so that they are not shown in MedicationList and also in Database.
                            drClientMedicationScriptDrugs[j]["RecordDeleted"] = "Y";
                            drClientMedicationScriptDrugs[j]["DeletedDate"] = Convert.ToDateTime(DateTime.Now.ToShortDateString());
                            drClientMedicationScriptDrugs[j]["DeletedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode; ;
                        }
                        //Code added by Loveena end over here.

                        /* Code added for Core Bugs #2145*/
                        DataRow[] drClientMedicationScriptDrugStrengths = _DataTableClientMedicationScriptDrugStrengths.Select("ClientMedicationId=" +

selectedMedicationId);
                        for (int k = 0; k < drClientMedicationScriptDrugStrengths.Length; k++)
                        {
                            drClientMedicationScriptDrugStrengths[k]["RecordDeleted"] = "Y";
                            drClientMedicationScriptDrugStrengths[k]["DeletedDate"] = Convert.ToDateTime(DateTime.Now.ToShortDateString());
                            drClientMedicationScriptDrugStrengths[k]["DeletedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode; ;
                        }


                    }
                }
                DeleteMedicationIdFromSession(oldMedicationId);
                Session["IsDirty"] = true;
                Session["DataSetClientMedications"] = dsClientMedications;
                return tempflag;
            }
            catch (Exception ex)
            {

                return false;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="clientMedicationId"></param>
        [WebMethod(EnableSession = true)]
        public int PopulateRowforTitrationList(string clientMedicationId)
        {
            DataTable _dataTableClientMedications;
            DataTable _dataTableClientMedicationInstructions;
            DataTable _dataTableClientMedicationScriptDrugs;
            DataTable _dataTableClientMedicationScripts;
            Streamline.UserBusinessServices.DataSets.DataSetClientMedications _dataSetClientMedications = null;
            Streamline.UserBusinessServices.DataSets.DataSetClientMedications _dataSetClientMedicationsTemp = null;
            try
            {
                int permissionFlag = 1;
                string permit = "Y";
                Session["DataSetTitration"] = null;
                if (clientMedicationId != "")
                {
                    if (Session["DataSetClientMedications"] != null)
                    {
                        _dataSetClientMedications = (Streamline.UserBusinessServices.DataSets.DataSetClientMedications)(Session["DataSetClientMedications"]);
                        _dataTableClientMedications = _dataSetClientMedications.ClientMedications;
                        _dataTableClientMedicationInstructions = _dataSetClientMedications.ClientMedicationInstructions;
                        _dataTableClientMedicationScriptDrugs = _dataSetClientMedications.ClientMedicationScriptDrugs;
                        _dataTableClientMedicationScripts = _dataSetClientMedications.ClientMedicationScripts;

                        _dataSetClientMedicationsTemp = new Streamline.UserBusinessServices.DataSets.DataSetClientMedications();
                        _dataSetClientMedicationsTemp.EnforceConstraints = false;
                        _dataSetClientMedicationsTemp.Merge(_dataTableClientMedications.Select("ClientMedicationId=" + clientMedicationId));

                        //Start: Calculating the DayNumber for every titration step.
                        DataRow[] _drStepOneInstruction = _dataTableClientMedicationInstructions.Select("TitrationStepNumber=" + 1 + "and ISNULL(RecordDeleted,'N')<>'Y'");
                        DateTime _firstStepDate = Convert.ToDateTime(_drStepOneInstruction[0]["StartDate"]);
                        DataRow[] _dataRowAllInstructions = _dataTableClientMedicationInstructions.Select("ISNULL(RecordDeleted,'N')<>'Y'");
                        foreach (DataRow _drInstruction in _dataRowAllInstructions)
                        {
                            _drInstruction["DayNumber"] = CalculateDayNumber(_firstStepDate, Convert.ToDateTime(_drInstruction["StartDate"]));
                        }
                        //End: Calculating the DayNumber for every titration step.


                        _dataSetClientMedicationsTemp.Merge(_dataTableClientMedicationInstructions.Select("ClientMedicationId=" + clientMedicationId));
                        _dataSetClientMedicationsTemp.Merge(_dataTableClientMedicationScripts);
                        for (int i = 0; i < _dataSetClientMedicationsTemp.Tables["ClientMedicationInstructions"].Rows.Count; i++)
                        {
                            string _clientMedicationInstructionId = _dataSetClientMedicationsTemp.Tables["ClientMedicationInstructions"].Rows[i]["ClientMedicationInstructionId"].ToString();
                            _dataSetClientMedicationsTemp.Merge(_dataTableClientMedicationScriptDrugs.Select("ClientMedicationInstructionId=" + _clientMedicationInstructionId));
                        }
                        if (_dataSetClientMedicationsTemp.Tables["ClientMedications"].Rows[0]["PermitChangesByOtherUsers"] != null)
                            permit = _dataSetClientMedicationsTemp.Tables["ClientMedications"].Rows[0]["PermitChangesByOtherUsers"].ToString();
                        int prescriberId = Convert.ToInt32(_dataSetClientMedicationsTemp.Tables["ClientMedications"].Rows[0]["PrescriberId"] == DBNull.Value ? "0" : _dataSetClientMedicationsTemp.Tables["ClientMedications"].Rows[0]["PrescriberId"].ToString());
                        // if(permit.ToUpper()=="N" &&


                        int loggedInUserId = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId;
                        if (permit.Trim().ToUpper() == "N")
                        {
                            if (prescriberId != loggedInUserId)
                            {

                                permissionFlag = 0;
                            }
                        }


                    }
                    Session["DataSetTitration"] = _dataSetClientMedicationsTemp;
                }
                return permissionFlag;
            }
            catch (Exception)
            {
                return -1;
            }
            finally
            {
                if (_dataSetClientMedicationsTemp != null)
                    _dataSetClientMedicationsTemp.Dispose();
            }
        }



        /// </summary>
        /// <param name="ClientMedicationId"></param>
        /// </summary>
        ///  This function will be used to Populate Medication Rows on click of Reorder Button in Medication Management
        ///  //Function Added by Sonia
        /// <param name="Medicationids"></param>
        /// <returns></returns>

        [WebMethod(EnableSession = true)]
        public int PopulateRowsforMedicationList(string Medicationids, string method, int NumberOfRefills, decimal QuantityValue, string ClickedImage, string Quantity, string NumberOfDaysSupply, string PotencyUnitCode)
        {
            string medicationId = string.Empty;
            DataTable _DataTableClientMedications;
            DataTable _DataTableClientMedicationInstructions;
            DataTable _DataTableClientMedicationScriptDrugs;
            //Uncommented By Chandan for task #2429 and Task#131
            DataTable _DataTableClientMedicationInteractions;
            DataTable _DataTableClientMedicationInteractionDetails;
            //Added by Anuj on 24 oct,2009 for task ref# 19, in SDI Projects FY10 - Venture
            DataTable _DataTableClientMedicationConsents;
            //Changes Ended over here
            string _clientMedicationInteractionIds = "";
            ArrayList EventArray = new ArrayList();
            //End: By Chandan for task #2429 and Task#131

            //Added by Loveena in ref to Task#85
            DataTable _DataTableClientMedicationScriptDrugsStrength;
            //Code ends over here.

            // #ka 08252011
            DataTable _DataTableClientMedicationData;
            DataTable _DataTableClientMedicationScriptDispenseDays;

            DataTable dtTemp;
            DataTable dtTemp1;
            DataTable dtTemp2;
            //DataTable dtTemp3;
            //Added By Anuj on 24 Oct,2009 for Task Ref#19, in SDI Projects FY10 - Venture
            DataTable dtTemp4;
            //Changes Ended over here

            //Added by Loveena in ref to Task#85
            DataTable dtTemp5;
            //Code ends over here.

            // #ka 08252011 
            DataTable dtTemp6;
            DataTable dtTemp7;

            Streamline.UserBusinessServices.DataSets.DataSetClientMedications DataSetClientMedications;
            DataSet _DataSetClientSummary;
            string _clientMedicationInstructionIds = "";
            bool _infoComplete = true; //Code added by Ankesh with ref to Task#77 on 12/15/2008 
            bool _titrateFlag = false;
            int returnValue = 1;//Added By Pradeep as per task#12Ventur10.0
            //Code Implemented by Loveena as Ref to Task #103 to display Pharm Value on basis of formula generated.
            Streamline.SmartClient.WebServices.CommonService objectCommonService = null;
            //Implemented Code Ends Here.

            //Code added by Loveena in ref to Task#2465 on 07-MAy-2009
            Streamline.UserBusinessServices.ClientMedication objClientMedication = new Streamline.UserBusinessServices.ClientMedication();
            DataSet DataSetClientMedicationsCopy = null;
            //Code ends over here.

            DateTime RxStartDate = System.DateTime.Now;
            DateTime RxEndDate;
            try
            {
                Session["SelectedMedicationId"] = null;
                Session["ChangedOrderMedicationIds"] = Medicationids;
                DataSetClientMedications = new Streamline.UserBusinessServices.DataSets.DataSetClientMedications();
                _DataSetClientSummary = (DataSet)Session["DataSetClientSummary"];
                if (_DataSetClientSummary == null || ClickedImage.ToString() == "FromQueuedOrderScreen")
                {
                    int ClientId;
                    int.TryParse(Session["ClientId"].ToString(), out ClientId);
                    SetClientInformation(ClientId, true);
                    _DataSetClientSummary = (DataSet)Session["DataSetClientSummary"];
                }
                DataSetClientMedications.EnforceConstraints = false;
                DataSetClientMedications.Tables["ClientMedications"].Merge(_DataSetClientSummary.Tables["ClientMedications"]);
                //----Start By Pradeep as per task#12
                if (method.ToUpper() == "CHANGE" || method.ToUpper() == "REFILL" || method.ToUpper() == "ADJUST" || method.ToUpper() == "COMPLETE" || method.ToUpper() == "CHANGEAPPROVALORDER")
                {
                    medicationId = Medicationids.TrimEnd(',');
                    //Modified by Loveena in ref to Task#3099 Do not Show Consent Warning for Non-Ordered Medications
                    //DataRow[] dataRowChangeOrder = DataSetClientMedications.Tables["ClientMedications"].Select("ClientmedicationId in (" + medicationId + ") and SignedByMd=0 and ISNULL(RecordDeleted,'N')='N'");
                    DataRow[] dataRowChangeOrder = DataSetClientMedications.Tables["ClientMedications"].Select("ClientmedicationId in (" + medicationId + ") and SignedByMd=0 and ISNULL(RecordDeleted,'N')='N' and ISNULL(Ordered,'N')='Y'");
                    if (dataRowChangeOrder.Length > 0)
                    {
                        returnValue = 0;
                    }

                    dataRowChangeOrder = DataSetClientMedications.Tables["ClientMedications"].Select("ClientmedicationId in (" + medicationId + ") and ISNULL(RecordDeleted,'N')='N'");
                    if (dataRowChangeOrder.Length > 0)
                    {
                        foreach (DataRow dr in dataRowChangeOrder)
                        {
                            if ((((StreamlineIdentity)Context.User.Identity)).EnableOtherPrescriberSelection == "Y")
                            {
                                if (((StreamlineIdentity)Context.User.Identity).Prescriber == "Y")
                                {
                                    dr["PrescriberId"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId;
                                    dr["PrescriberName"] = (((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity)).LastName + ", " + (((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity)).FirstName;

                                }
                            }
                        }
                    }
                }
                //----End By Pradeep as per task#12
                DataSetClientMedications.Tables["ClientMedicationInstructions"].Merge(_DataSetClientSummary.Tables["ClientMedicationInstructions"]);
                DataSetClientMedications.Tables["ClientMedicationScriptDispenseDays"].Merge(_DataSetClientSummary.Tables["ClientMedicationScriptDispenseDays"]);
                DataSetClientMedications.Tables["ClientMedicationScriptDrugs"].Merge(_DataSetClientSummary.Tables["ClientMedicationScriptDrugs"]);

                //Added by Loveena in ref to Task#85
                DataSetClientMedications.Tables["ClientMedicationScriptDrugStrengths"].Merge(_DataSetClientSummary.Tables["ClientMedicationScriptDrugStrengths"]);
                //Ends over here.

                //Added By Anuj on 24 Oct,2009 for Task Ref#19, in SDI Projects FY10 - Venture
                //Adding ClientMedicationConsent table to the dataset
                DataSetClientMedications.Tables["ClientMedicationConsents"].Merge(_DataSetClientSummary.Tables["ClientMedicationConsents"]);
                //Changes Ended Over Here

                DataSetClientMedications.Tables["ClientMedicationInteractions"].Merge(_DataSetClientSummary.Tables["ClientMedicationInteractions"]);
                DataSetClientMedications.Tables["ClientMedicationInteractionDetails"].Merge(_DataSetClientSummary.Tables["ClientMedicationInteractionDetails"]);

                // #ka 08252011
                DataSetClientMedications.Tables["ClientMedicationData"].Merge(_DataSetClientSummary.Tables["ClientMedicationData"]);

                //Added By Anuj on 24 oct,2009 For task #19 in SDI Projects FY10 - Venture
                _DataTableClientMedicationConsents = DataSetClientMedications.Tables["ClientMedicationConsents"];
                //Chnages Ended Over here

                _DataTableClientMedications = DataSetClientMedications.Tables["ClientMedications"];
                // #ka 08252011
                _DataTableClientMedicationData = DataSetClientMedications.Tables["ClientMedicationData"];

                _DataTableClientMedicationInstructions = DataSetClientMedications.Tables["ClientMedicationInstructions"];
                _DataTableClientMedicationScriptDrugs = DataSetClientMedications.Tables["ClientMedicationScriptDrugs"];
                //Uncommented By Chandan for task #2429 and Task#131
                _DataTableClientMedicationInteractions = DataSetClientMedications.Tables["ClientMedicationInteractions"];
                //End: By Chandan for task #2429 and Task#131
                //_DataTableClientMedicationInteractionDetails = DataSetClientMedications.Tables["ClientMedicationInteractionDetails"];

                //Added by Loveena in ref to Task#85
                _DataTableClientMedicationScriptDrugsStrength = DataSetClientMedications.Tables["ClientMedicationScriptDrugStrengths"];
                //Code Ends over here.
                _DataTableClientMedicationScriptDispenseDays = DataSetClientMedications.Tables["ClientMedicationScriptDispenseDays"];

                int newInstructionId = 0;

                if (method != "UpdateMedication")
                {
                    foreach (DataRow dr in DataSetClientMedications.Tables["ClientMedications"].Rows)
                    {

                        if (DataSetClientMedications.Tables["ClientMedicationInstructions"].Select("ClientMedicationId=" + Convert.ToInt32(dr["ClientMedicationId"]) + "  and ISNULL(RecordDeleted,'N')='N'").Length < 1)
                        {
                            DataRow drCMI = DataSetClientMedications.Tables["ClientMedicationInstructions"].NewRow();
                            if (DataSetClientMedications.Tables["ClientMedicationInstructions"].Rows.Count > 0)
                            {
                                newInstructionId = GetMinValue(Convert.ToInt32(DataSetClientMedications.Tables["ClientMedicationInstructions"].Compute("Min(ClientMedicationInstructionId)", "")));
                                drCMI["ClientMedicationInstructionId"] = newInstructionId;
                            }
                            else
                                drCMI["ClientMedicationInstructionId"] = newInstructionId;

                            drCMI["ClientMedicationId"] = dr["ClientMedicationId"];
                            drCMI["MedicationName"] = dr["MedicationName"];
                            //For removing duplicate instructions from a Medication in a View History page this needs to be done
                            if (drCMI.Table.Columns.Contains("MedicationOrderStatus"))
                            {
                                drCMI["MedicationOrderStatus"] = dr["OrderStatus"];
                            }
                            drCMI["MedicationScriptId"] = dr["MedicationScriptId"];

                            drCMI["ModifiedBy"] = dr["ModifiedBy"];
                            drCMI["ModifiedDate"] = dr["ModifiedDate"];
                            drCMI["CreatedBy"] = dr["CreatedBy"];
                            drCMI["CreatedDate"] = dr["CreatedDate"];
                            drCMI["Instruction"] = string.Empty;
                            //drCMI["PrescriberId"] = dr["PrescriberId"];
                            //drCMI["MedicationNameId"] = dr["MedicationNameId"];
                            drCMI["RowIdentifier"] = System.Guid.NewGuid();
                            drCMI["Unit"] = 0;
                            //drCMI["DAWorQuantity"] = DBNull.Value;
                            DataSetClientMedications.Tables["ClientMedicationInstructions"].Rows.Add(drCMI);
                            newInstructionId++;
                            //}
                            //Ended over here
                        }
                    }
                }
                dtTemp = _DataTableClientMedications.Clone();
                dtTemp1 = _DataTableClientMedicationInstructions.Clone();
                dtTemp2 = _DataTableClientMedicationScriptDrugs.Clone();
                //dtTemp3 = _DataTableClientMedicationInteractionDetails.Clone();

                //Added By Anuj on 24 oct,2009 For task #19 in SDI Projects FY10 - Venture
                dtTemp4 = _DataTableClientMedicationConsents.Clone();
                //Changes Ended over here

                //Added by Loveena in ref to Task#85
                dtTemp5 = _DataTableClientMedicationScriptDrugsStrength.Clone();
                //Code ends over here.

                // #ka 08252011
                dtTemp6 = _DataTableClientMedicationData.Clone();
                dtTemp7 = _DataTableClientMedicationScriptDispenseDays.Clone();

                //Set the Primary Key for ClientMedications
                DataColumn[] dcDataTableClientMedications = new DataColumn[1];
                dcDataTableClientMedications[0] = _DataTableClientMedications.Columns["ClientMedicationId"];
                _DataTableClientMedications.PrimaryKey = dcDataTableClientMedications;


                //Added by Chandan for task#2429 and task#131 
                EventArray = Streamline.BaseLayer.CommonFunctions.StringSplit(Medicationids, ",");
                //string MedicationNameIds = "";

                for (int i = 0; i < EventArray.Count; i++)
                {
                    DataRow[] drClientMedicationInteractiontobeDeleted = _DataTableClientMedicationInteractions.Select("ClientMedicationId1=" + EventArray[i] + " or ClientMedicationId2 =" + EventArray[i] + " ");
                    foreach (DataRow dr in drClientMedicationInteractiontobeDeleted)
                    {
                        _clientMedicationInteractionIds = _clientMedicationInteractionIds + dr["ClientMedicationInteractionId"] + ",";
                    }
                }

                _clientMedicationInteractionIds = _clientMedicationInteractionIds.TrimEnd(',');
                Session["ClientMedicationInteractionIds"] = _clientMedicationInteractionIds;

                //End : by Chandan for task#2429 and task#131

                //Add the Rows into ClientMedications based on ClientMedicationId
                //Ref to Task#2599
                string str = "";
                DataRow[] drClientMedicationtobeInserted = _DataTableClientMedications.Select("ClientMedicationId in (" + Medicationids + ")");
                foreach (DataRow dr in drClientMedicationtobeInserted)
                {
                    if (str.IndexOf(dr["ClientMedicationId"].ToString()) < 0)
                    {
                        dtTemp.ImportRow(dr);
                        str += dr["ClientMedicationId"] + ",";
                    }
                }

                dtTemp4 = _DataTableClientMedicationConsents.Copy();

                // #ka 08252011
                DataRow[] drClientMedicationDataTobeInserted = _DataTableClientMedicationData.Select("ClientMedicationId in (" + Medicationids + ")");
                foreach (DataRow dr in drClientMedicationDataTobeInserted)
                {
                    dtTemp6.ImportRow(dr);
                }


                //DataRow[] drClientMedicationScriptDispenseDaysRows = _DataTableClientMedicationScriptDispenseDays.Select("ClientMedicationId in (" + Medicationids + ")");
                //foreach (DataRow dr in drClientMedicationScriptDispenseDaysRows)
                //{
                //    dtTemp7.ImportRow(dr);
                //}

                //Add the Rows into ClientMedicationInstructions based on ClientMedicationId
                DataRow[] drClientMedicationInstructionRows = _DataTableClientMedicationInstructions.Select("ClientMedicationId in (" + Medicationids + ")");
                foreach (DataRow dr1 in drClientMedicationInstructionRows)
                {
                    if (method.ToUpper() == "REFILL" || method.ToUpper() == "CHANGEAPPROVALORDER")
                    {
                        if (ClickedImage == "Approved" || ClickedImage == "ApprovedWithChanges")
                        {
                            dr1["PotencyUnitCode"] = PotencyUnitCode;
                            dr1["Refills"] = NumberOfRefills;
                        }
                        dtTemp1.ImportRow(dr1);
                    }
                    else
                    {
                        //Changes by Sonia
                        //Ref Task #63 1.5.4 - Change Order Process - Row Metadata not Initialized Correctly
                        //MetaData needs to be initialized again for ClientMedicationInstructions as new row is being added in Database in case of change Order Process
                        dr1["CreatedDate"] = DateTime.Now;
                        dr1["CreatedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                        dr1["ModifiedDate"] = DateTime.Now;
                        dr1["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                        dr1["RowIdentifier"] = System.Guid.NewGuid();

                        //Code added by Ankesh with ref to Task#77 on 12/15/2008 
                        //If any information is null then set a flag _infoComplete to 'N'.
                        if (dr1["Schedule"].ToString() == "" || dr1["StrengthId"].ToString() == "" || dr1["Quantity"].ToString() == "" || dr1["Unit"].ToString() == "0")
                        {
                            _infoComplete = false;
                        }
                        if (ClickedImage == "Approved" || ClickedImage == "ApprovedWithChanges")
                        {
                            dr1["PotencyUnitCode"] = PotencyUnitCode;
                            dr1["Refills"] = NumberOfRefills;
                        }
                        //Code end over here

                        dtTemp1.Rows.Add(dr1.ItemArray);
                    }

                    objectCommonService = new CommonService();
                    DataRow[] drClientMedicationDispenseDays = _DataTableClientMedicationScriptDispenseDays.Select("ClientMedicationInstructionId=" + Convert.ToInt32(dr1["ClientMedicationInstructionId"]));
                    if (drClientMedicationDispenseDays.Length > 0)
                    {
                        DataRow[] dr = _DataTableClientMedicationInstructions.Select("ClientMedicationInstructionId=" + Convert.ToInt32(dr1["ClientMedicationInstructionId"]));
                        drClientMedicationDispenseDays[0]["CreatedDate"] = DateTime.Now;
                        drClientMedicationDispenseDays[0]["CreatedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                        drClientMedicationDispenseDays[0]["ModifiedDate"] = DateTime.Now;
                        drClientMedicationDispenseDays[0]["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;

                        dtTemp7.Rows.Add(drClientMedicationDispenseDays[0].ItemArray);
                    }

                    DataRow[] drClientMedicationScriptDrugs = _DataTableClientMedicationScriptDrugs.Select("ClientMedicationInstructionId=" + Convert.ToInt32(dr1["ClientMedicationInstructionId"]), "StartDate desc");
                    if (drClientMedicationScriptDrugs.Length > 0)
                    {
                        //Changes by Sonia
                        //Ref Task #63 1.5.4 - Change Order Process - Row Metadata not Initialized Correctly
                        //MetaData needs to be initialized again for ClientMedicationScriptDrugs as new row is being added in Database in case of change Order Process

                        //Code Implemented by Loveena as Ref to Task #103 to display Pharm Value on basis of formula generated.
                        DataRow[] dr = _DataTableClientMedicationInstructions.Select("ClientMedicationInstructionId=" + Convert.ToInt32(dr1["ClientMedicationInstructionId"]));
                        //Condition added by Loveena in ref to Task#2802 to calculate Pharmacy 
                        //for AutoCalcallowed == "Y" as there is no column for this
                        objClientMedication = new Streamline.UserBusinessServices.ClientMedication();
                        DataSet dsTemp = objClientMedication.CalculateAutoCalcAllow(Convert.ToInt32(dr1["StrengthId"]));
                        //if (dsTemp.Tables[0].Rows[0]["AutoCalcAllowed"].ToString() == "Y")
                        //{
                        //    if (drClientMedicationScriptDrugs[0]["Days"] != DBNull.Value && drClientMedicationScriptDrugs[0]["Sample"] != DBNull.Value && drClientMedicationScriptDrugs[0]["Stock"] != DBNull.Value)
                        //        drClientMedicationScriptDrugs[0]["Pharmacy"] = objectCommonService.CalculatePharmacy(Convert.ToInt32(drClientMedicationScriptDrugs[0]["Days"]), Convert.ToDecimal(dr[0]["Quantity"]), Convert.ToString(dr[0]["Schedule"]), Convert.ToDecimal(drClientMedicationScriptDrugs[0]["Sample"]), Convert.ToDecimal(drClientMedicationScriptDrugs[0]["Stock"]));
                        //}
                        drClientMedicationScriptDrugs[0]["AutoCalcallow"] = dsTemp.Tables[0].Rows[0]["AutoCalcAllowed"];
                        //Implemented Code Ends Here.
                        drClientMedicationScriptDrugs[0]["CreatedDate"] = DateTime.Now;
                        drClientMedicationScriptDrugs[0]["CreatedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                        drClientMedicationScriptDrugs[0]["ModifiedDate"] = DateTime.Now;
                        drClientMedicationScriptDrugs[0]["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                        drClientMedicationScriptDrugs[0]["RowIdentifier"] = System.Guid.NewGuid();
                        //Conition added in ref to Task#3224 For approve button, we are required to disable some additional fields in the grid.
                        if (ClickedImage == "Approved" || ClickedImage == "ApprovedWithChanges")
                        {
                            #region--Code Added by Pradeep as per task#3274
                            if (dtTemp != null)
                            {
                                foreach (DataRow dataRow in dtTemp.Rows)
                                {
                                    drClientMedicationScriptDrugs[0]["Pharmacy"] = 0.00;
                                    drClientMedicationScriptDrugs[0]["Refills"] = NumberOfRefills;
                                    drClientMedicationScriptDrugs[0]["PharmacyText"] = Quantity;
                                }
                            }
                            #endregion
                            drClientMedicationScriptDrugs[0]["AutoCalcallow"] = "N";//Written by Loveena as per task#3285 
                            if ((NumberOfDaysSupply == string.Empty || NumberOfDaysSupply == "0") && method.ToUpper() != "CHANGEAPPROVALORDER")
                            {
                                drClientMedicationScriptDrugs[0]["Days"] = 30;
                            }
                           else if((NumberOfDaysSupply == string.Empty || NumberOfDaysSupply == "0") && method.ToUpper() == "CHANGEAPPROVALORDER")
                            {
                                drClientMedicationScriptDrugs[0]["Days"] = 1; // Check with wasif
                            }
                            else
                            {
                                drClientMedicationScriptDrugs[0]["Days"] = Convert.ToInt32(NumberOfDaysSupply);
                            }

                        }
                        dtTemp2.Rows.Add(drClientMedicationScriptDrugs[0].ItemArray);
                        objectCommonService = null;

                        //Start:Code added by Ankesh with ref to Task#77 on 12/15/2008 
                        if (_infoComplete == true)
                        {
                            if (drClientMedicationScriptDrugs[0]["Days"].ToString() == "0" || drClientMedicationScriptDrugs[0]["StartDate"].ToString() == "" || drClientMedicationScriptDrugs[0]["EndDate"].ToString() == "")
                            {
                                _infoComplete = false;
                            }
                        }
                        //End:Code added by Ankesh with ref to Task#77 on 12/15/2008 
                    }
                    else
                    {
                        _infoComplete = false;
                    }
                    //Start:Code added by Ankesh with ref to Task#77 on 12/15/2008 
                    if (_infoComplete == false)
                    {
                        DataRow[] _drInfoComplete = dtTemp1.Select("ClientMedicationId=" + Convert.ToInt32(dr1["ClientMedicationId"]));
                        _drInfoComplete[0]["InformationComplete"] = "N";
                        _infoComplete = true;
                    }
                    //End:Code added by Ankesh with ref to Task#77 on 12/15/2008 
                }

                //Add the Rows into ClientMedicationScriptDrugsStrenght based on ClientMedicationId

                DataRow[] drClientMedicationScriptDrugStrengthRows = _DataTableClientMedicationScriptDrugsStrength.Select("ClientMedicationId in (" + Medicationids + ")");
                if (drClientMedicationScriptDrugStrengthRows.Length > 0)
                {
                    foreach (DataRow drScriptDrugStrength in drClientMedicationScriptDrugStrengthRows)
                    {
                        if (ClickedImage == "Approved" || ClickedImage == "ApprovedWithChanges")
                        {
                            #region--Code Added by Pradeep as per task#3274
                            if (dtTemp != null)
                            {
                                foreach (DataRow dataRow in dtTemp.Rows)
                                {
                                    //if (dataRow["DrugCategory"].ToString() != "3" || dataRow["DrugCategory"].ToString() != "4" || dataRow["DrugCategory"].ToString() != "5")
                                    //{
                                    drScriptDrugStrength["Pharmacy"] = 0.00;
                                    drScriptDrugStrength["Refills"] = NumberOfRefills;
                                    drScriptDrugStrength["PharmacyText"] = Quantity;
                                    //}
                                }
                            }
                            #endregion
                        }
                        drScriptDrugStrength["CreatedDate"] = DateTime.Now;
                        drScriptDrugStrength["CreatedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                        drScriptDrugStrength["ModifiedDate"] = DateTime.Now;
                        drScriptDrugStrength["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                        drScriptDrugStrength["RowIdentifier"] = System.Guid.NewGuid();
                        dtTemp5.Rows.Add(drScriptDrugStrength.ItemArray);
                    }
                }
                if (method.ToUpper() == "REFILL" || method.ToUpper() == "CHANGE" || method.ToUpper() == "ADJUST" || method.ToUpper() == "COMPLETE" || method.ToUpper() == "CHANGEAPPROVALORDER")
                {
                    DataTable dtInstructions = _DataTableClientMedicationInstructions.Clone();
                    DataTable dataTableClientMedicationScriptDrugsStrength = _DataTableClientMedicationScriptDrugsStrength.Clone();
                    foreach (DataRow dataRow in dtTemp.Rows)
                    {
                        DateTime _RxStartDate = Convert.ToDateTime(null);
                        if (dataRow["DrugCategory"].ToString() == "2")
                        {
                            _RxStartDate = Convert.ToDateTime(dtTemp1.Compute("Max(StartDate)", "ClientMedicationId=" + dataRow["ClientMedicationId"] + " And ISNULL(RecordDeleted,'N')<>'Y'"));

                            DataRow[] drInstructions = dtTemp1.Select("StartDate<>'" + _RxStartDate + "' And ClientMedicationId=" + dataRow["ClientMedicationId"]);
                            foreach (DataRow drtr in drInstructions)
                            {
                                DataRow[] drClientMedicationScriptDrugs = dtTemp2.Select("ClientMedicationInstructionId=" + Convert.ToInt32(drtr["ClientMedicationInstructionId"]));
                                foreach (DataRow dRowScriptDrugs in drClientMedicationScriptDrugs)
                                {
                                    DataRow[] dataRowClienMedicationScriptDrugsStrength = dtTemp5.Select("clientMedicationScriptId=" + Convert.ToInt32(dRowScriptDrugs["ClientMedicationScriptId"]));
                                    foreach (DataRow dRowScriptDrugStrengths in dataRowClienMedicationScriptDrugsStrength)
                                    {
                                        dtTemp5.Rows.Remove(dRowScriptDrugStrengths);
                                    }
                                }

                            }
                        }
                    }
                }

                #region Code by Ankesh on '05-Feb-2009' to implemented logic to set the Activate flag 'N' for instructions in ClientMedicationInstructions table except last titrationstep instructions.(Ref Task # 182)

                if (method.ToUpper() == "REFILL" || method.ToUpper() == "CHANGEAPPROVALORDER")
                {
                    foreach (DataRow dr in drClientMedicationtobeInserted)
                    {
                        DataView _dataViewDistinct = new DataView(dtTemp1);
                        _dataViewDistinct.RowFilter = "ClientMedicationId =" + dr["ClientMedicationId"].ToString();
                        DataTable _dataTableDistinct = _dataViewDistinct.ToTable("ClientMedicationInstructions", true, "TitrationStepNumber");

                        objectCommonService = new CommonService();
                        int MedicationRxEndDateOffset = 0;
                        if (_dataTableDistinct.Rows.Count > 1)
                        {
                            int _maxStepNumber = 0;
                            if (dr["TitrationType"].ToString() == "T" || dr["TitrationType"].ToString() == "P")
                            {
                                if (dtTemp1.Compute("Max(TitrationStepNumber)", "ClientMedicationId =" + dr["ClientMedicationId"].ToString() + "AND ISNULL(RecordDeleted,'N')<>'Y'").ToString() != "")
                                    _maxStepNumber = Convert.ToInt32(dtTemp1.Compute("Max(TitrationStepNumber)", "ClientMedicationId =" + dr["ClientMedicationId"].ToString() + "AND ISNULL(RecordDeleted,'N')<>'Y'"));

                                DateTime _minRXStartDate = Convert.ToDateTime(dtTemp1.Compute("Min(StartDate)", "ClientMedicationId =" + dr["ClientMedicationId"].ToString() + "AND ISNULL(RecordDeleted,'N')<>'Y'"));
                                DateTime _maxRXEndDate = Convert.ToDateTime(dtTemp1.Compute("Max(EndDate)", "ClientMedicationId =" + dr["ClientMedicationId"].ToString() + "AND ISNULL(RecordDeleted,'N')<>'Y'"));
                                TimeSpan _dateDifference = _maxRXEndDate.Subtract(_minRXStartDate);
                                //Modified in ref to Task#3087 to count the day of Min Start Date
                                //int _days = _dateDifference.Days; 

                                if (Streamline.UserBusinessServices.SharedTables.DataSetMedicationRxEndDateOffset.Tables[0].Rows[0]["MedicationRxEndDateOffset"] != System.DBNull.Value)
                                    MedicationRxEndDateOffset = Convert.ToInt32(Streamline.UserBusinessServices.SharedTables.DataSetMedicationRxEndDateOffset.Tables[0].Rows[0]["MedicationRxEndDateOffset"]);
                                int _days = (_dateDifference.Days) + 1 - MedicationRxEndDateOffset;
                                //DataRow[] _dataRowsTitrateRefills = dtTemp1.Select("TitrationStepNumber <>" + _maxStepNumber + "AND ClientMedicationId =" + dr["ClientMedicationId"].ToString() + "AND ISNULL(RecordDeleted,'N')<>'Y'");
                                DataRow[] _dataRowsTitrateRefills = dtTemp1.Select("ClientMedicationId =" + dr["ClientMedicationId"].ToString() + "AND ISNULL(RecordDeleted,'N')<>'Y'");
                                foreach (DataRow drRefills in _dataRowsTitrateRefills)
                                {
                                    if (Convert.ToInt32(drRefills["TitrationStepNumber"]) != _maxStepNumber)
                                    {
                                        drRefills["Active"] = "N";
                                        DataRow[] _dataRowInActiveInstructions = dtTemp2.Select("ClientMedicationInstructionId=" + drRefills["ClientMedicationInstructionId"].ToString());
                                        ///Code added by Loveena in ref to over come the Bug1 of Task#3087
                                        if (_dataRowInActiveInstructions.Length > 0)
                                            _dataRowInActiveInstructions[0].Delete();
                                    }
                                    else
                                    {
                                        drRefills["StartDate"] = Convert.ToDateTime(System.DateTime.Now.ToShortDateString());
                                        drRefills["Days"] = _days;
                                        Decimal _refills, _quantity, _sample, _stock;
                                        string _schedule = "";
                                        if (drRefills["Refills"] == System.DBNull.Value || drRefills["Refills"].ToString() == "")
                                            _refills = 0;
                                        else
                                            _refills = Convert.ToDecimal(drRefills["Refills"]);

                                        if (drRefills["Quantity"] == System.DBNull.Value || drRefills["Quantity"].ToString() == "")
                                            _quantity = 0;
                                        else
                                            _quantity = Convert.ToDecimal(drRefills["Quantity"]);

                                        if (drRefills["Sample"] == System.DBNull.Value || drRefills["Sample"].ToString() == "")
                                            _sample = 0;
                                        else
                                            _sample = Convert.ToDecimal(drRefills["Sample"]);

                                        if (drRefills["Stock"] == System.DBNull.Value || drRefills["Stock"].ToString() == "")
                                            _stock = 0;
                                        else
                                            _stock = Convert.ToDecimal(drRefills["Sample"]);

                                        _schedule = drRefills["Schedule"].ToString();

                                        //drRefills["EndDate"] = Convert.ToDateTime(CalculateEndDate(Convert.ToString(drRefills["StartDate"]), _days, _refills));
                                        drRefills["EndDate"] = Convert.ToDateTime(objectCommonService.CalculateEndDate(Convert.ToString(drRefills["StartDate"]), _days, _refills));
                                        drRefills["Pharmacy"] = Convert.ToDecimal(objectCommonService.CalculatePharmacy(_days, _quantity, _schedule, _sample, _stock));

                                        DataRow[] _dataRowInActiveInstructions = dtTemp2.Select("ClientMedicationInstructionId=" + drRefills["ClientMedicationInstructionId"].ToString());
                                        _dataRowInActiveInstructions[0]["StartDate"] = Convert.ToDateTime(System.DateTime.Now.ToShortDateString());
                                        _dataRowInActiveInstructions[0]["Days"] = _days;
                                        _dataRowInActiveInstructions[0]["EndDate"] = Convert.ToDateTime(objectCommonService.CalculateEndDate(Convert.ToString(_dataRowInActiveInstructions[0]["StartDate"]), _days, _refills));
                                        _dataRowInActiveInstructions[0]["Pharmacy"] = Convert.ToDecimal(objectCommonService.CalculatePharmacy(_days, _quantity, _schedule, _sample, _stock));
                                    }
                                }
                            }
                        }
                    }
                }
                #endregion

                DataSetClientMedications.Clear();

                //Adding a Dummy row in the ClientMedicationScripts table
                //So that the clientmedicationscriptdrugs does not throw a foreignkey voilation error
                //Condition added by Loveen ain ref to Task#3273 -2.6.1 Non-Ordered Medications: Allow Changes 
                if (method != "UpdateMedication")
                {
                    DataRow drClientMedicationScripts;
                    if (DataSetClientMedications.Tables["ClientMedicationScripts"].Rows.Count < 1)
                        drClientMedicationScripts = DataSetClientMedications.Tables["ClientMedicationScripts"].NewRow();
                    else
                        drClientMedicationScripts = DataSetClientMedications.Tables["ClientMedicationScripts"].Rows[0];

                    drClientMedicationScripts["Clientid"] = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId;
                    drClientMedicationScripts["OrderingMethod"] = "P";

                    drClientMedicationScripts["PharmacyId"] = System.DBNull.Value;
                    drClientMedicationScripts["PrintDrugInformation"] = System.DBNull.Value;
                    drClientMedicationScripts["ScriptCreationDate"] = DateTime.Now;
                    drClientMedicationScripts["OrderDate"] = DateTime.Now;
                    drClientMedicationScripts["LocationId"] = System.DBNull.Value;
                    if (method == "Change" || method == "CHANGE")
                        drClientMedicationScripts["ScriptEventType"] = "C";
                    else if (method == "Refill" || method == "REFILL" ||method.ToUpper()== "CHANGEAPPROVALORDER")
                        drClientMedicationScripts["ScriptEventType"] = "A";
                    else if (method.ToUpper() == "COMPLETE")
                        drClientMedicationScripts["ScriptEventType"] = "N";
                    else
                        drClientMedicationScripts["ScriptEventType"] = "N";

                    drClientMedicationScripts["OrderingPrescriberId"] = 731;
                    drClientMedicationScripts["OrderingPrescriberName"] = "sdjfsdj";

                    drClientMedicationScripts["RowIdentifier"] = System.Guid.NewGuid();
                    drClientMedicationScripts["CreatedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                    drClientMedicationScripts["CreatedDate"] = DateTime.Now;
                    drClientMedicationScripts["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                    drClientMedicationScripts["ModifiedDate"] = DateTime.Now;
                    if (DataSetClientMedications.Tables["ClientMedicationScripts"].Rows.Count < 1)
                        DataSetClientMedications.Tables["ClientMedicationScripts"].Rows.Add(drClientMedicationScripts);
                }
                int newClientMedicationId = 0;
                int clientMedicationId = 0;
                int newClientMedicationInstructionId = 0;
                string _drugCategory = "";
                DateTime minStartDate = Convert.ToDateTime(null);
                DateTime maxEndDate = Convert.ToDateTime(null);

                DateTime minStartDateFromMedInstructions = DateTime.Now;
                foreach (DataRow drTemp in dtTemp.Rows)
                {
                    //added By Pramod on 18 apr 2008 to calculate enddate
                    if (drTemp["MedicationStartDate"].ToString() != "")
                        minStartDate = Convert.ToDateTime(drTemp["MedicationStartDate"]); ;

                    if (drTemp["MedicationEndDate"].ToString() != "")
                        maxEndDate = Convert.ToDateTime(drTemp["MedicationEndDate"]);
                    //code ends here
                    clientMedicationId = Convert.ToInt32(drTemp["ClientMedicationId"]);
                    _drugCategory = drTemp["DrugCategory"].ToString();
                    //condition added as per 2377
                    if (method.ToUpper() == "CHANGE" || method.ToUpper() == "ADJUST" || method.ToUpper() == "COMPLETE")
                    {
                        //Start:Code by Ankesh on 06 Feb 2009 to implement the logic for converting Titrate Medication to Normal Medication in case Change Order, if Titrate Medication have only one step(Ref Task # 182).
                        DataView _dataViewDistinct1 = new DataView(dtTemp1);
                        _dataViewDistinct1.RowFilter = "ClientMedicationId =" + drTemp["ClientMedicationId"].ToString();
                        DataTable _dataTableDistinct1 = _dataViewDistinct1.ToTable("ClientMedicationInstructions", true, "TitrationStepNumber");
                        //Code modified by Chandan in ref to Task# 133 1.7.3 - Change Order - ClientMedications and ClientMedicationInstructions
                        //drTemp["ClientMedicationId"] = newClientMedicationId;
                        if (_dataTableDistinct1.Rows.Count == 1 && (drTemp["TitrationType"].ToString() == "T" || drTemp["TitrationType"].ToString() == "P"))
                        {
                            drTemp["TitrationType"] = System.DBNull.Value;
                            _titrateFlag = true;
                        }
                        //End:Code by Ankesh on 06 Feb 2009 to implement the logic for converting Titrate Medication to Normal Medication in case Change Order, if Titrate Medication have only one step(Ref Task # 182).
                    }

                    DataRow[] drMedicationInstruction = dtTemp1.Select("ClientMedicationId=" + clientMedicationId + "AND ISNULL(ACTIVE,'Y')='Y'");
                    // #ka 08232011 determine the rx start date based on the max end date of the medication instructions plus one day 
                    // #tr 01032012 If there is not a valid row value, use Now
                    DateTime EndRefilDatePlusOne = DateTime.Now;
                    if (!(dtTemp1.Compute("Max(EndDate)", "ClientMedicationId=" + clientMedicationId + " And ISNULL(RecordDeleted,'N')<>'Y'").Equals(System.DBNull.Value)))
                        EndRefilDatePlusOne = (Convert.ToDateTime(dtTemp1.Compute("Max(EndDate)", "ClientMedicationId=" + clientMedicationId + " And ISNULL(RecordDeleted,'N')<>'Y'"))).AddDays(1);

                    if (dtTemp6 != null && dtTemp6.Rows.Count > 0)
                    {
                        DateTime StartDateFromMedInstructions;
                        if ((method.ToUpper() == "CHANGE")
                            && ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).ChangeOrderStartDateUseToday == "Y")
                        {
                            StartDateFromMedInstructions = DateTime.Now;
                        }
                        else
                        {
                            // #tr 01032012 if value is null use Now
                            if ((dtTemp1.Compute("Min(StartDate)", "ClientMedicationId=" + clientMedicationId + " And ISNULL(RecordDeleted,'N')<>'Y'").Equals(System.DBNull.Value)))
                                StartDateFromMedInstructions = DateTime.Now;
                            else
                                StartDateFromMedInstructions = (Convert.ToDateTime(dtTemp1.Compute("Min(StartDate)", "ClientMedicationId=" + clientMedicationId + " And ISNULL(RecordDeleted,'N')<>'Y'")));
                        }
                        foreach (DataRow drMedData in dtTemp6.Select("ClientMedicationId=" + clientMedicationId))
                        {
                            drMedData["MedicationInstrStartDate"] = StartDateFromMedInstructions;
                        }
                        if (minStartDateFromMedInstructions > StartDateFromMedInstructions) { minStartDateFromMedInstructions = StartDateFromMedInstructions; }
                    }

                    foreach (DataRow drTemp1 in drMedicationInstruction)
                    {
                        DataRow[] drClientMedicationScriptDrugs = dtTemp2.Select("ClientMedicationInstructionId=" + Convert.ToInt32(drTemp1["ClientMedicationInstructionId"]));
                        DataRow[] drClientMedicationScriptDispenseDays = dtTemp7.Select("ClientMedicationInstructionId=" + Convert.ToInt32(drTemp1["ClientMedicationInstructionId"]));
                        //condition added as per 2377
                        if (method.ToUpper() == "CHANGE" || method.ToUpper() == "ADJUST" || method.ToUpper() == "COMPLETE")
                        {
                            //Code modified by Chandan in ref to Task# 133 1.7.3 - Change Order - ClientMedications and ClientMedicationInstructions
                            //drTemp1["ClientMedicationId"] = newClientMedicationId;
                            drTemp1["ClientMedicationInstructionId"] = newClientMedicationInstructionId;
                            if (_titrateFlag == true)
                                drTemp1["TitrationStepNumber"] = System.DBNull.Value;

                            if (drTemp1["EndDate"] != System.DBNull.Value || drTemp1["EndDate"].ToString() != "")
                            {
                                drTemp["DateTerminated"] = Convert.ToDateTime(dtTemp1.Compute("Max(EndDate)", "ISNULL(RecordDeleted,'N')<>'Y'"));
                            }
                        }
                        //Code added by Loveena in ref to Task#3273
                        if (method != "UpdateMedication")
                        {
                            if (drClientMedicationScriptDispenseDays.Length > 0)
                            {
                                drClientMedicationScriptDispenseDays[0]["ClientMedicationScriptDispenseDayId"] = newClientMedicationInstructionId;
                                if (DataSetClientMedications.Tables["ClientMedicationScripts"].Rows.Count > 0)
                                    drClientMedicationScriptDispenseDays[0]["ClientMedicationScriptId"] = DataSetClientMedications.Tables["ClientMedicationScripts"].Rows[0]["ClientMedicationScriptId"];
                                if (method.ToUpper() == "CHANGE" || method.ToUpper() == "ADJUST" || method.ToUpper() == "COMPLETE")
                                    drClientMedicationScriptDispenseDays[0]["ClientMedicationInstructionId"] = newClientMedicationInstructionId;
                                else
                                    drClientMedicationScriptDispenseDays[0]["ClientMedicationInstructionId"] = drTemp1["ClientMedicationInstructionId"];
                            }

                            if (drClientMedicationScriptDrugs.Length > 0)
                            {
                                drClientMedicationScriptDrugs[0]["ClientMedicationScriptDrugId"] = newClientMedicationInstructionId;
                                if (DataSetClientMedications.Tables["ClientMedicationScripts"].Rows.Count > 0)
                                    drClientMedicationScriptDrugs[0]["ClientMedicationScriptId"] = DataSetClientMedications.Tables["ClientMedicationScripts"].Rows[0]["ClientMedicationScriptId"];
                                drClientMedicationScriptDrugs[0]["DrugCategory"] = _drugCategory;
                                if (method.ToUpper() == "CHANGE" || method.ToUpper() == "ADJUST" || method.ToUpper() == "COMPLETE")
                                    drClientMedicationScriptDrugs[0]["ClientMedicationInstructionId"] = newClientMedicationInstructionId;
                                else
                                    drClientMedicationScriptDrugs[0]["ClientMedicationInstructionId"] = drTemp1["ClientMedicationInstructionId"];

                                //condition modified by Loveena in ref to Task#3145
                                // #ka 08232011 Added check for refill and refill start use end plus one for start date
                                if ((method == "Refill" || (method.ToUpper() == "CHANGE" && ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).ChangeOrderStartDateUseToday == "Y")) ||
                                    method == "Refill" && ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).RefillStartUseEndPlusOne == "Y")
                                {
                                    objectCommonService = new CommonService();
                                    //Condition added by Loveena in ref to Task#2656 on 17Dec2009 to display max start date in grid
                                    //if (drTemp["DrugCategory"].ToString() != "2")
                                    //{
                                    DateTime startDate;  // #ka 08232011 = Convert.ToDateTime(System.DateTime.Now.ToShortDateString());
                                    DateTime endDate;

                                    if (method == "Refill" && ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).RefillStartUseEndPlusOne == "Y")
                                    {
                                        if (maxEndDate >= DateTime.Now)
                                            startDate = EndRefilDatePlusOne;
                                        else
                                            startDate = Convert.ToDateTime(System.DateTime.Now.ToShortDateString());
                                    }
                                    else
                                    {
                                        startDate = Convert.ToDateTime(System.DateTime.Now.ToShortDateString());
                                    }

                                    //Code added by Loveena on 28-May-2009 as exception is coming Object cannot cast Dbnull to other type as Days are not eneterd in case of non-order medication.
                                    if (drClientMedicationScriptDrugs[0]["Days"] != DBNull.Value && drClientMedicationScriptDrugs[0]["Refills"] != DBNull.Value)
                                        endDate = Convert.ToDateTime(objectCommonService.CalculateEndDate(startDate.ToString(), Convert.ToInt32(drClientMedicationScriptDrugs[0]["Days"]), Convert.ToInt32(drClientMedicationScriptDrugs[0]["Refills"])));
                                    else
                                        endDate = startDate;

                                    drTemp1["StartDate"] = startDate;
                                    drTemp1["EndDate"] = endDate;

                                    //Code Commented by Loveena in ref to task#188
                                    drClientMedicationScriptDrugs[0]["StartDate"] = startDate;
                                    drClientMedicationScriptDrugs[0]["EndDate"] = endDate;

                                    //}
                                }
                            }
                        }
                        //Code ended by Sonia
                        //Task #38 and #39 1.5.1 - Change/Refill Order Screen: Start and Stop Date Initialization
                        //so that without clicking radio button also Modified date changed

                        //Code ended by Sonia
                        //Task #38  and #39 1.5.1 - Change/Refill Order Screen: Start and Stop Date Initialization

                        newClientMedicationInstructionId++;
                        if (drClientMedicationScriptDrugs.Length > 0)
                            _clientMedicationInstructionIds = _clientMedicationInstructionIds + drClientMedicationScriptDrugs[0]["ClientMedicationInstructionId"].ToString() + ",";

                    }
                    //Added By PranayB w.r.t Valley - Support Go Live: #1433
                    //Calculating Start And End Dates.
                    if (_drugCategory == "2" && method == "Refill")
                    {
                        DateTime tempStartDate;
                        DateTime tempEndDate;
                        int tempDays = 0;
                        tempStartDate = Convert.ToDateTime(System.DateTime.Now.ToShortDateString());
                        foreach (DataRow drMedData in drMedicationInstruction)
                        {
                            tempDays = Convert.ToInt32(drMedData["Days"]);
                            drMedData["StartDate"] = tempStartDate;
                            drMedData["EndDate"] = Convert.ToDateTime(tempStartDate.AddDays(tempDays).ToShortDateString());
                            tempStartDate = Convert.ToDateTime(drMedData["EndDate"].ToString());
                            DataRow[] drClientMedicationScriptDrugs = dtTemp2.Select("ClientMedicationInstructionId=" + Convert.ToInt32(drMedData["ClientMedicationInstructionId"]));
                            drClientMedicationScriptDrugs[0]["StartDate"]= Convert.ToDateTime(drMedData["StartDate"].ToString());
                            drClientMedicationScriptDrugs[0]["EndDate"] = Convert.ToDateTime(drMedData["EndDate"].ToString());
                        }
                    }

                    //Code added by Loveena in ref to Task#3273
                    if (method != "UpdateMedication")
                    {
                        DataRow[] drMedicationScriptDrugStrengthRows = dtTemp5.Select("ClientMedicationId in (" + Medicationids + ")");
                        int newMedicationScriptDrugStrengthId = 0;
                        if (drMedicationScriptDrugStrengthRows.Length > 0)
                        {
                            foreach (DataRow drScriptDrugStrength in drMedicationScriptDrugStrengthRows)
                            {
                                drScriptDrugStrength["ClientMedicationScriptDrugStrengthId"] = newMedicationScriptDrugStrengthId;
                                if (DataSetClientMedications.Tables["ClientMedicationScripts"].Rows.Count > 0)
                                    drScriptDrugStrength["ClientMedicationScriptId"] = DataSetClientMedications.Tables["ClientMedicationScripts"].Rows[0]["ClientMedicationScriptId"];
                                newMedicationScriptDrugStrengthId++;
                            }

                        }
                    }
                    newClientMedicationId++;
                    if (_clientMedicationInstructionIds.Length > 1)
                    {
                        _clientMedicationInstructionIds = _clientMedicationInstructionIds.Substring(0, _clientMedicationInstructionIds.Length - 1);
                    }

                    //Code Commented by Loveen ends over here.
                    if (_clientMedicationInstructionIds != "")
                    {
                        drTemp["MedicationEndDate"] = dtTemp2.Compute("MAX(EndDate)", "ClientMedicationInstructionId in (" + _clientMedicationInstructionIds + ")");
                        //condition modified by Loveena in ref to Task#3145
                        if (method == "Refill" || (method.ToUpper() == "CHANGE" && ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).ChangeOrderStartDateUseToday == "Y"))
                        {
                            ////Condition added by Loveena in ref to Task#2656 on 17Dec2009 to display max start date in grid
                            //if (drTemp["DrugCategory"] != "2")
                            //{
                            drTemp["MedicationEndDateForDisplay"] = drTemp["MedicationStartDate"];
                            drTemp["MedicationEndDateForDisplay"] = System.DBNull.Value;
                            //}
                        }
                        else
                        {
                            drTemp["MedicationEndDateForDisplay"] = dtTemp2.Compute("MIN(StartDate)", "ClientMedicationInstructionId in (" + _clientMedicationInstructionIds + ")");
                        }
                    }
                    _clientMedicationInstructionIds = "";

                }

                if (method.ToUpper() == "ADJUST")
                {
                    foreach (DataRow drClientMeds in DataSetClientMedications.Tables["ClientMedicationScripts"].Rows)
                    {
                        drClientMeds["OrderDate"] = minStartDateFromMedInstructions;
                    }
                }

                //Added by Loveena on 07-May-2009 in ref to Task#2465
                //to get PatientEducationMonographId to retrieve CommonSideEffects.
                if (method == "PatientConsent")
                {
                    DataSet dataSetMonogragphId = null;
                    objClientMedication = new ClientMedication();
                    DataSetClientMedicationsCopy = DataSetClientMedications.Clone();
                    dataSetMonogragphId = objClientMedication.GetPatientMonographId(Medicationids);
                    if (dataSetMonogragphId.Tables[0].Rows.Count > 0)
                    {
                        DataSetClientMedicationsCopy.Tables.Add("PatientMonographId");
                        DataSetClientMedicationsCopy.Tables["PatientMonographId"].Merge(dataSetMonogragphId.Tables[0]);
                    }
                }
                DataSetClientMedications.Tables["ClientMedications"].Merge(dtTemp);
                //Condition added by Loveena in ref to Task#2656 on 17Dec2009 to display max start date in grid
                if (method.ToUpper() == "REFILL" || method.ToUpper() == "CHANGE" || method.ToUpper() == "ADJUST" || method.ToUpper() == "COMPLETE" || method.ToUpper() == "CHANGEAPPROVALORDER")
                {
                    DataTable dtInstructions = _DataTableClientMedicationInstructions.Clone();
                    DataTable dataTableNonC2Instructions = _DataTableClientMedicationInstructions.Clone();
                    foreach (DataRow dataRow in dtTemp.Rows)
                    {
                        DateTime _RxStartDate = Convert.ToDateTime(null);
                        //Condition added in ref to Task#3087 as for C2 medications need to carry forward just step1 with maximum step number
                        //regardless of c2 medication status 
                        if (dataRow["TitrationType"].ToString() != "T" && dataRow["TitrationType"].ToString() != "P")
                        {
                            //if (dataRow["DrugCategory"].ToString() == "2")
                            //{
                            //    DataRow[] dtRow = dtTemp1.Select("ClientMedicationId=" + dataRow["ClientMedicationId"] + " And ISNULL(RecordDeleted,'N')<>'Y'");

                            //    foreach (DataRow row in dtRow)
                            //    {
                            //        row["Active"] = "N";
                            //        dtInstructions.ImportRow(row);
                            //    }
                            //    _RxStartDate = Convert.ToDateTime(dtInstructions.Compute("Max(StartDate)", "ClientMedicationId=" + dataRow["ClientMedicationId"] + " And ISNULL(RecordDeleted,'N')<>'Y'"));
                            //    DataRow[] drInstructions = dtInstructions.Select("StartDate='" + _RxStartDate + "' And ClientMedicationId=" + dataRow["ClientMedicationId"]);
                            //    foreach (DataRow drtr in drInstructions)
                            //    {
                            //        DataRow[] drClientMedicationScriptDrugs = dtTemp2.Select("ClientMedicationInstructionId=" + Convert.ToInt32(drtr["ClientMedicationInstructionId"]));
                            //        //Condition added by Loveena in ref to Task#2656 as per condition for Medicationbuild 1.9.6.6.
                            //        //Condition modified by Loveena in ref to Task#3415
                            //        if (method.ToUpper() == "REFILL" || (method.ToUpper() == "CHANGE" && ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).ChangeOrderStartDateUseToday == "Y"))
                            //        {
                            //            DateTime startDate = Convert.ToDateTime(System.DateTime.Now.ToShortDateString());
                            //            DateTime endDate;
                            //            //Condition added in ref to Taks#2807 as to avoid exception of Index outside range
                            //            if (drClientMedicationScriptDrugs.Length > 0)
                            //            {
                            //                if (drClientMedicationScriptDrugs[0]["Days"] != DBNull.Value && drClientMedicationScriptDrugs[0]["Refills"] != DBNull.Value)
                            //                    endDate = Convert.ToDateTime(objectCommonService.CalculateEndDate(startDate.ToString(), Convert.ToInt32(drClientMedicationScriptDrugs[0]["Days"]), Convert.ToInt32(drClientMedicationScriptDrugs[0]["Refills"])));
                            //                else
                            //                    endDate = startDate;

                            //                drtr["StartDate"] = startDate;
                            //                drtr["EndDate"] = endDate;

                            //                drClientMedicationScriptDrugs[0]["StartDate"] = startDate;
                            //                drClientMedicationScriptDrugs[0]["EndDate"] = endDate;
                            //            }
                            //        }
                            //        drtr["Active"] = "Y";
                            //        //dtInstructions.ImportRow(drtr);
                            //    }

                            //}
                            //else
                            //{
                            //Condition added in ref to Task#3087 as for C2 medications need to carry forward just step1 with maximum step number
                            //regardless of c2 medication status 
                            DataRow[] drInstructions = dtTemp1.Select("ClientMedicationId=" + dataRow["ClientMedicationId"]);
                            foreach (DataRow drtr in drInstructions)
                            {
                                //dtInstructions.ImportRow(drtr);
                                dataTableNonC2Instructions.ImportRow(drtr);
                            }
                            //}
                        }
                        else
                        {
                            //Code added in ref to Task#3087 to set ClientMedications.TitrationType is not set as NULL.
                            if (method.ToUpper() == "REFILL" || method.ToUpper() == "RXCHANGE")
                                dataRow["TitrationType"] = System.DBNull.Value;
                            DataRow[] dtRow = dtTemp1.Select("ClientMedicationId=" + dataRow["ClientMedicationId"] + " And ISNULL(RecordDeleted,'N')<>'Y'");

                            foreach (DataRow row in dtRow)
                            {
                                dataTableNonC2Instructions.ImportRow(row);
                            }
                        }
                    }
                    dtInstructions.Merge(dataTableNonC2Instructions);
                    DataSetClientMedications.Tables["ClientMedicationInstructions"].Merge(dtInstructions);
                }
                if (method.ToUpper() != "REFILL" && method.ToUpper() != "CHANGE" && method.ToUpper() != "ADJUST" && method.ToUpper() != "COMPLETE" && method.ToUpper() != "CHANGEAPPROVALORDER")
                    DataSetClientMedications.Tables["ClientMedicationInstructions"].Merge(dtTemp1);
                DataSetClientMedications.Tables["ClientMedicationScriptDrugs"].Merge(dtTemp2);

                //Added By Anuj on 24 oct,2009 for task ref#19 SDI Projects FY10 - Venture
                DataSetClientMedications.Tables["ClientMedicationConsents"].Merge(dtTemp4);
                //Chnages ended over here

                //Added by Loveena in ref to Task#85 to add rows in ClientMedicationScriptDrugsStrength
                DataSetClientMedications.Tables["ClientMedicationScriptDrugStrengths"].Merge(dtTemp5);
                //Code ends over here.

                // #ka 08252011
                DataSetClientMedications.Tables["ClientMedicationData"].Merge(dtTemp6);
                DataSetClientMedications.Tables["ClientMedicationScriptDispenseDays"].Merge(dtTemp7);

                //changes by sonia
                Session["DataSetClientMedications"] = DataSetClientMedications;

                getDrugInteraction(DataSetClientMedications);

                Session["DataSetClientMedications"] = DataSetClientMedications;
                //changes end over here sonia

                if (method == "PatientConsent")
                {
                    DataSetClientMedicationsCopy.Tables["ClientMedications"].Merge(dtTemp);
                    DataSetClientMedicationsCopy.Tables["ClientMedicationInstructions"].Merge(dtTemp1);
                    DataSetClientMedicationsCopy.Tables["ClientMedicationScriptDrugs"].Merge(dtTemp2);


                    //Added by Anuj on oct 24,2009 for task Ref #19 in SDI Projects FY10 - Venture
                    DataSetClientMedicationsCopy.Tables["ClientMedicationConsents"].Merge(dtTemp4);
                    //Changes Ended Over here

                    // #ka 08252011
                    DataSetClientMedicationsCopy.Tables["ClientMedicationData"].Merge(dtTemp6);

                    Session["DataSetClientMedications"] = DataSetClientMedicationsCopy;
                }
                //Modified code ends over here.

                Session["IsDirty"] = true;
                if (ClickedImage.ToString() == "FromQueuedOrderScreen")
                {
                    Session["ScreenName"] = "FromQueuedOrderScreen";
                    DataRow[] drPharamcyToDefault = _DataSetClientSummary.Tables["ClientMedications"].Select("ClientMedicationId = " + medicationId);

                    if (drPharamcyToDefault.Length > 0)
                    {
                        if (drPharamcyToDefault[0]["PharmacyId"].ToString() != "")
                        {
                            Session["PharmacyIdFromQue"] = drPharamcyToDefault[0]["PharmacyId"].ToString();
                            Session["PharamcyToDefault"] = drPharamcyToDefault[0]["PharmacyName"].ToString();
                        }
                    }
                }
                return returnValue;
            }
            catch (Exception ex)
            {
                return -1;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="clientId"></param>
        [WebMethod(EnableSession = true)]
        public void SetClientInformation(int clientId, bool requirePharmacies)
        {
            try
            {
                ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).RefreshData = true;
                ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).SetClientInformation(clientId, requirePharmacies);
                GetClientSummaryData();

            }
            catch (Exception ex)
            {

                throw (ex);
            }
        }

        private void GetClientSummaryData()
        {
            Streamline.UserBusinessServices.DataSets.DataSetClientMedications DataSetClientMedications;
            Streamline.UserBusinessServices.ClientMedication objectClientMedications = null;
            DataSet dataSetClientSummary = null;
            try
            {
                objectClientMedications = new Streamline.UserBusinessServices.ClientMedication();
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
                    dataSetClientSummary = objectClientMedications.DownloadClientMedicationSummary(_ClientRowIdentifier, _ClinicianrowIdentifier);
                    Session["DataSetClientMedications"] = null;
                    Session["DataSetClientSummary"] = dataSetClientSummary;

                    DataSetClientMedications.EnforceConstraints = false;
                    DataSetClientMedications.Tables["ClientMedications"].Merge(dataSetClientSummary.Tables["ClientMedications"]);
                    DataSetClientMedications.Tables["ClientMedicationInstructions"].Merge(dataSetClientSummary.Tables["ClientMedicationInstructions"]);

                }
            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally
            {
                objectClientMedications = null;
            }



        }

        /// <summary>
        /// Author:Sonia
        /// Purpose:-To Set the Medication Id for Order Details Page
        /// </summary>
        /// <param name="Medicationids"></param>
        /// <returns></returns>
        [WebMethod(EnableSession = true)]
        public int SetOrderDetailsMedicationIdForMainPage(int Medicationid, int MedicationScriptId)
        {
            try
            {
                ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientOrderDetailsMedicationId = Medicationid;
                //Code added by Ankesh Bharti in Ref to Task #2409 
                ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientOrderDetailsMedicationScriptId = MedicationScriptId;
                return 1;
            }
            catch (Exception ex)
            {
                return -1;
            }

        }
        //Following added by Sonia with reference to Task #38 and #39 MM#1.5.2
        /// <summary>
        /// Author:Sonia
        /// Purpose:-To Set the Medication Id and ScriptId for Order Details Page
        /// </summary>
        /// <param name="Medicationids"></param>
        /// <returns></returns>
        [WebMethod(EnableSession = true)]
        public int SetOrderDetailsMedicationId(int Medicationid, int ScriptId)
        {
            try
            {
                ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientOrderDetailsMedicationId = Medicationid;
                ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientOrderDetailsMedicationScriptId = ScriptId;
                return 1;
            }
            catch (Exception ex)
            {
                return -1;
            }

        }

        [WebMethod(EnableSession = true)]
        public bool DeleteClientMedicationInstructions(int MedicationId, int MedicationInstructionId, string DrugStrengthRowId)
        {
            bool tempflag = false;
            try
            {

                Streamline.UserBusinessServices.DataSets.DataSetClientMedications dsClientMedications = null;

                DataTable _DataTableClientMedicationInstructions = null;
                if (Session["DataSetClientMedications"] != null)
                    dsClientMedications = (Streamline.UserBusinessServices.DataSets.DataSetClientMedications)Session["DataSetClientMedications"];
                else
                    dsClientMedications = new Streamline.UserBusinessServices.DataSets.DataSetClientMedications();


                _DataTableClientMedicationInstructions = dsClientMedications.ClientMedicationInstructions;

                DataRow[] drClientMedicationInstruction = _DataTableClientMedicationInstructions.Select("ClientMedicationId=" + MedicationId + " and ClientMedicationInstructionId=" + MedicationInstructionId);
                if (drClientMedicationInstruction.Length > 0)
                {
                    if (DrugStrengthRowId != null)
                    {
                        DataRow[] drDrugStrengths =
                            dsClientMedications.Tables["ClientMedicationScriptDrugStrengths"].Select("RowIdentifier='" +
                                                                                                     DrugStrengthRowId +
                                                                                                     "'");
                        if (drDrugStrengths.Length > 0)
                        {
                            drDrugStrengths[0].Delete();
                        }
                    }
                    DataRow[] drScriptDrugs =
                        dsClientMedications.Tables["ClientMedicationScriptDrugs"].Select(
                            "ClientMedicationInstructionId=" + MedicationInstructionId);
                    if (drScriptDrugs.Length > 0)
                    {
                        drScriptDrugs[0].Delete();
                    }
                    if (MedicationId > 0)
                    {
                        drClientMedicationInstruction[0]["Active"] = "N";
                    }
                    else
                    {
                        drClientMedicationInstruction[0].Delete();
                    }
                    
                    tempflag = true;
                }
                return tempflag;
                Session["DataSetClientMedications"] = dsClientMedications;
            }
            catch (Exception ex)
            {

                return false;
            }
        }

        /// <summary>
        /// This function will be used to insert the Allergy Record into  Client Allergy list on click of select button in Allergy List 
        /// </summary>
        /// <param name="ClientAllergyId"></param>
        //Function Added by Sonia 
        /// Date -----Author-----------Purpose-------
        /// 26 Oct 2009 Pradeep        Ref.task#9(Addedd one parameter FilterCriteria)
        [WebMethod(EnableSession = true)]
        public string DisplayClientAllergyList(char EditableList, string FilterCriteria)
        {
            DataSet DataSetFinal = null;
            Streamline.UserBusinessServices.ClientMedication objClientMedications;
            try
            {
                objClientMedications = new Streamline.UserBusinessServices.ClientMedication();
                DataSetFinal = objClientMedications.GetClientAllergiesData(((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId);
                #region--Code Comented By Pradeep as per task#9
                //StringBuilder GridHTML = GetAllergy_Html(DataSetFinal, EditableList);
                //return GridHTML.ToString();
                #endregion--Code Comented By Pradeep as per task#9
                #region---Changes as per task#9 By Pradeep
                StringBuilder GridHTML = GetAllergy_Html(DataSetFinal, EditableList, FilterCriteria, "");
                return GridHTML.ToString();
                #endregion
            }
            catch (Exception ex)
            {

                return null;
            }
            finally
            {
                DataSetFinal = null;
                objClientMedications = null;
            }
        }

        /// <summary>
        /// Author:Sonia Dhamija
        /// Purpose:To get the HTML of ScriptHistory on Sorting option
        /// </summary>
        /// <param name="AscDesc"></param>
        /// <param name="FieldName"></param>
        /// <returns></returns>
        [WebMethod(EnableSession = true)]
        public string SortGridViewClientScriptHistory(string AscDesc, string FieldName, string ShowHidePillImage)
        {
            DataView DataViewClientScriptHistory = null;
            DataSet DataSetClientScriptHistory = new DataSet();
            Streamline.UserBusinessServices.ClientMedication objectClientMedications;
            DataSet _DataSetClientMedicationScriptHistory;


            StringBuilder GridViewClientScriptsHTML = new StringBuilder();
            try
            {



                if (Session["DataViewClientMedicationScriptHistory"] != null)
                {
                    //DataSetGridViewClaims = AuthorizationDetailsObject.GetAuthorizationDetailsHistoryClaims(ProviderAuthorizationId);
                    DataViewClientScriptHistory = new DataView();
                    DataViewClientScriptHistory = (DataView)Session["DataViewClientMedicationScriptHistory"];


                    DataViewClientScriptHistory.Sort = FieldName + " " + AscDesc;

                    GridViewClientScriptsHTML.Append("<div id='DivClientScriptHistory'  >");
                    //GridViewClientScriptsHTML.Append("<input type='hidden' name='Control_ASP.usercontrols_medicationorderdetails_ascx$HiddenFieldAscDescClientScriptHistory' id='Control_ASP.usercontrols_medicationorderdetails_ascx$HiddenFieldAscDescClientScriptHistory' value='ASC' />");
                    GridViewClientScriptsHTML.Append("<div >");

                    GridViewClientScriptsHTML.Append("<table cellspacing='0' border='0' id='Control_ASP.usercontrols_medicationorderdetails_ascx_DataGridScriptHistory' style='width:100%;border-collapse:collapse;'>");

                    // GridViewClientScriptsHTML.Append("<table id='HeadingTableGeneral' CellPadding='0' CellSpacing='0' >");
                    //GridViewClientScriptsHTML.Append("<tr class='TableFixedHeader' style='background-color:#DEE7EF;Height:20Px'>");
                    GridViewClientScriptsHTML.Append("<tr class='DataGridFixedHeader' align='left' style='position:static; color:Black;background-color:#DEE7EF;font-family:Sans-Serif;font-weight:bold;text-decoration:none;height:20px;'>");
                    GridViewClientScriptsHTML.Append("<td align='left' scope='col'></td>");


                    GridViewClientScriptsHTML.Append("<td style='cursor:hand;text-decoration:underline' align='left' scope='col'><a style='color:Black' href=javascript:SortGridScriptHistory('DeliveryMethod')>Delivery Method</a></td>");
                    GridViewClientScriptsHTML.Append("<td align='left' scope='col'></td>");
                    GridViewClientScriptsHTML.Append("<td style='cursor:hand;text-decoration:underline' align='left' scope='col'><a style='color:Black' href=javascript:SortGridScriptHistory('ScriptCreationDate')>Date/Time</a></td>");
                    GridViewClientScriptsHTML.Append("<td  align='left' scope='col'></td>");
                    GridViewClientScriptsHTML.Append("<td style='cursor:hand;text-decoration:underline' align='left' scope='col'><a style='color:Black' href=javascript:SortGridScriptHistory('CreatedBy')>Created By</a></td>");
                    //Code Added by Loveena in Ref to Task#83
                    GridViewClientScriptsHTML.Append("<td align='left' scope='col'></td>");
                    GridViewClientScriptsHTML.Append("<td style='cursor:hand;text-decoration:underline' align='left' scope='col'><a style='color:Black' href=javascript:SortGridScriptHistory('Reason')>Reprint Reason</a></td>");

                    //Code Added by Loveena in Ref to Task#83
                    GridViewClientScriptsHTML.Append("<td align='left' scope='col'></td>");
                    GridViewClientScriptsHTML.Append("<td style='cursor:hand;text-decoration:underline' align='left' scope='col'><a style='color:Black' href=javascript:SortGridScriptHistory('LocationName')>Location</a></td>");

                    GridViewClientScriptsHTML.Append("<td align='left' scope='col'></td>");
                    GridViewClientScriptsHTML.Append("<td  align='left' scope='col'><a style='color:Black' href=javascript:SortGridScriptHistory('PharmacyName')>Pharmacy Name</a></td>");
                    //  GridViewClientScriptsHTML.Append("</tr></table>");

                    GridViewClientScriptsHTML.Append("<td align='left' scope='col'></td>");
                    GridViewClientScriptsHTML.Append("<td style='cursor:hand;text-decoration:underline' align='left' scope='col'><a style='color:Black'>Stock/Sample</a></td>");
                    GridViewClientScriptsHTML.Append("</tr>");
                    //   GridViewClientScriptsHTML.Append("<DIV>");





                    // GridViewClientScriptsHTML.Append("<table cellspacing='0' border='0' id='Control_ASP.usercontrols_medicationorderdetails_ascx_DataGridScriptHistory' style='width:100%;border-collapse:collapse;'>");
                    if (DataViewClientScriptHistory.Table.Rows.Count > 0)
                    {

                        for (int RowIndex = 0; RowIndex < DataViewClientScriptHistory.Table.Rows.Count; RowIndex++)
                        {
                            GridViewClientScriptsHTML.Append("<tr class='GridViewRowStyle'>");
                            GridViewClientScriptsHTML.Append("<td align='left' scope='col' style='width:3%;'></td>");
                            GridViewClientScriptsHTML.Append("<td align='left' valign='middle' style='width:10%;'>");
                            GridViewClientScriptsHTML.Append(" <span id='Control_ASP.usercontrols_medicationorderdetails_ascx_DataGridScriptHistory_ctl02_LabelDeliveryMethod'>" + DataViewClientScriptHistory[RowIndex]["DeliveryMethod"] + " </span>");
                            GridViewClientScriptsHTML.Append("</td><td style='width:2%' align='left' scope='col'></td><td align='left' valign='middle' style='width:10%;'>");
                            GridViewClientScriptsHTML.Append(" <span id='Control_ASP.usercontrols_medicationorderdetails_ascx_DataGridScriptHistory_ctl02_LabelScriptCreationDate'>" + Convert.ToDateTime(DataViewClientScriptHistory[RowIndex]["ScriptCreationDate"]).ToString("MM/dd/yyyy HH:mm tt") + " </span>");
                            GridViewClientScriptsHTML.Append("</td><td style='width:2%' align='left' scope='col'></td><td align='left' valign='middle' style='width:10%;'>");
                            GridViewClientScriptsHTML.Append(" <span id='usercontrols_medicationorderdetails_ascx_DataGridScriptHistory_ctl02_LabelCreatedBy'>" + DataViewClientScriptHistory[RowIndex]["CreatedBy"] + " </span>");
                            GridViewClientScriptsHTML.Append("</td><td align='left' scope='col' style='width:2%;'></td><td align='left' valign='middle' style='width:15%;'>");
                            GridViewClientScriptsHTML.Append(" <span id='usercontrols_medicationorderdetails_ascx_DataGridScriptHistory_ctl02_LabelReason'>" + DataViewClientScriptHistory[RowIndex]["Reason"] + " </span>");
                            GridViewClientScriptsHTML.Append("</td><td align='left' scope='col' style='width:2%;'></td><td align='left' valign='middle' style='width:15%;'>");
                            GridViewClientScriptsHTML.Append(" <span id='usercontrols_medicationorderdetails_ascx_DataGridScriptHistory_ctl02_LabelLocation'>" + DataViewClientScriptHistory[RowIndex]["LocationName"] + " </span>");
                            GridViewClientScriptsHTML.Append("</td><td align='left' scope='col' style='width:2%;'></td><td align='left' valign='middle' style='width:15%;'>");
                            GridViewClientScriptsHTML.Append(" <span id='Control_ASP.usercontrols_medicationorderdetails_ascx_DataGridScriptHistory_ctl03_LabelPharmacyName'>" + DataViewClientScriptHistory[RowIndex]["PharmacyName"] + " </span>");
                            if (ShowHidePillImage == "display:block")
                            {
                                GridViewClientScriptsHTML.Append("</td><td align='left' scope='col' style='width:2%;'></td><td align='left' valign='middle' style='width:10%;'>");
                                GridViewClientScriptsHTML.Append(" <img id='Control_ASP.usercontrols_medicationorderdetails_ascx_DataGridScriptHistory_ctl02_Pillbottle_Image' src='App_Themes/Includes/Images/pill-bottle.JPG' style='Width:15px' alt='Pill bottle'> </span>");
                            }
                            GridViewClientScriptsHTML.Append("</td>");
                            GridViewClientScriptsHTML.Append("</tr>");

                        }
                    }
                    else
                    {
                        GridViewClientScriptsHTML.Append("<tr class='GridViewRowStyle'>");
                        GridViewClientScriptsHTML.Append("<td colspan='4' align='center'>");
                        GridViewClientScriptsHTML.Append("No Records Found");
                        GridViewClientScriptsHTML.Append("</td></tr>");

                    }

                    GridViewClientScriptsHTML.Append("</table></div></div>");

                }
                return GridViewClientScriptsHTML.ToString();






            }
            catch (Exception ex)
            {
                return GridViewClientScriptsHTML.ToString();
            }
        }



        /// <summary>
        /// Author:Sonia Dhamija
        /// Purpose:To get the HTML of ScriptHistory 
        /// </summary>
        /// <returns></returns>
        /// <ModifiedBy>Sonia</ModifiedBy>
        /// <ModificationPurpose>To send one more parameter i.e ClientMedicationScriptId to get the Details for ScriptHistory </ModificationPurpose>
        [WebMethod(EnableSession = true)]
        public string FillGridScriptHistoryHtml(string ClientMedicationId, string ClientMedicationScriptId, string ShowHidePillImage)
        {
            DataView DataViewClientScriptHistory = null;
            DataSet DataSetClientScriptHistory = new DataSet();
            Streamline.UserBusinessServices.ClientMedication objectClientMedications;
            DataSet _DataSetClientMedicationScriptHistory;
            StringBuilder GridViewClientScriptsHTML = new StringBuilder();

            try
            {

                objectClientMedications = new ClientMedication();
                _DataSetClientMedicationScriptHistory = objectClientMedications.DownloadClientMedicationScriptHistory(((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId, Convert.ToInt32(ClientMedicationId), Convert.ToInt32(ClientMedicationScriptId));
                DataViewClientScriptHistory = _DataSetClientMedicationScriptHistory.Tables["ClientMedicationScripts"].DefaultView;
                DataViewClientScriptHistory.Sort = "ClientMedicationScriptId desc";
                Session["DataViewClientMedicationScriptHistory"] = DataViewClientScriptHistory;

                if (Session["DataViewClientMedicationScriptHistory"] != null)
                {
                    //DataSetGridViewClaims = AuthorizationDetailsObject.GetAuthorizationDetailsHistoryClaims(ProviderAuthorizationId);
                    DataViewClientScriptHistory = new DataView();
                    DataViewClientScriptHistory = (DataView)Session["DataViewClientMedicationScriptHistory"];


                    DataViewClientScriptHistory.Sort = "ScriptCreationDate Desc";



                    GridViewClientScriptsHTML.Append("<div id='DivClientScriptHistory'  >");
                    //GridViewClientScriptsHTML.Append("<input type='hidden' name='Control_ASP.usercontrols_medicationorderdetails_ascx$HiddenFieldAscDescClientScriptHistory' id='Control_ASP.usercontrols_medicationorderdetails_ascx$HiddenFieldAscDescClientScriptHistory' value='ASC' />");
                    GridViewClientScriptsHTML.Append("<div >");

                    GridViewClientScriptsHTML.Append("<table cellspacing='0' border='0' id='Control_ASP.usercontrols_medicationorderdetails_ascx_DataGridScriptHistory' style='width:100%;border-collapse:collapse;'>");

                    // GridViewClientScriptsHTML.Append("<table id='HeadingTableGeneral' CellPadding='0' CellSpacing='0' >");
                    //GridViewClientScriptsHTML.Append("<tr class='TableFixedHeader' style='background-color:#DEE7EF;Height:20Px'>");
                    GridViewClientScriptsHTML.Append("<tr class='DataGridFixedHeader' align='left' style=' position:static; color:Black;background-color:#DEE7EF;font-family:Sans-Serif;font-weight:bold;text-decoration:none;height:20px;'>");
                    GridViewClientScriptsHTML.Append("<td align='left' scope='col'></td>");


                    GridViewClientScriptsHTML.Append("<td style='cursor:hand;text-decoration:underline' align='left' scope='col'><a style='color:Black' href=javascript:SortGridScriptHistory('DeliveryMethod')>Delivery Method</a></td>");
                    GridViewClientScriptsHTML.Append("<td align='left' scope='col'></td>");
                    GridViewClientScriptsHTML.Append("<td style='cursor:hand;text-decoration:underline' align='left' scope='col'><a style='color:Black' href=javascript:SortGridScriptHistory('ScriptCreationDate')>Date/Time</a></td>");
                    GridViewClientScriptsHTML.Append("<td  align='left' scope='col'></td>");
                    GridViewClientScriptsHTML.Append("<td style='cursor:hand;text-decoration:underline' align='left' scope='col'><a style='color:Black' href=javascript:SortGridScriptHistory('CreatedBy')>Created By</a></td>");
                    //Code Added by Loveena in Ref to Task#83
                    GridViewClientScriptsHTML.Append("<td align='left' scope='col'></td>");
                    GridViewClientScriptsHTML.Append("<td style='cursor:hand;text-decoration:underline' align='left' scope='col'><a style='color:Black' href=javascript:SortGridScriptHistory('Reason')>Reprint Reason</a></td>");

                    //Code Added by Loveena in Ref to Task#83
                    GridViewClientScriptsHTML.Append("<td align='left' scope='col'></td>");
                    GridViewClientScriptsHTML.Append("<td style='cursor:hand;text-decoration:underline' align='left' scope='col'><a style='color:Black' href=javascript:SortGridScriptHistory('LocationName')>Location</a></td>");

                    GridViewClientScriptsHTML.Append("<td align='left' scope='col'></td>");
                    GridViewClientScriptsHTML.Append("<td  align='left' scope='col'><a style='color:Black' href=javascript:SortGridScriptHistory('PharmacyName')>Pharmacy Name</a></td>");
                    //  GridViewClientScriptsHTML.Append("</tr></table>");

                    GridViewClientScriptsHTML.Append("<td align='left' scope='col'></td>");
                    GridViewClientScriptsHTML.Append("<td style='cursor:hand;text-decoration:underline' align='left' scope='col'><a style='color:Black'>Stock/Sample</a></td>");
                    GridViewClientScriptsHTML.Append("</tr>");
                    //   GridViewClientScriptsHTML.Append("<DIV>");





                    // GridViewClientScriptsHTML.Append("<table cellspacing='0' border='0' id='Control_ASP.usercontrols_medicationorderdetails_ascx_DataGridScriptHistory' style='width:100%;border-collapse:collapse;'>");
                    if (DataViewClientScriptHistory.Table.Rows.Count > 0)
                    {

                        for (int RowIndex = 0; RowIndex < DataViewClientScriptHistory.Table.Rows.Count; RowIndex++)
                        {
                            GridViewClientScriptsHTML.Append("<tr class='GridViewRowStyle'>");
                            GridViewClientScriptsHTML.Append("<td align='left' scope='col' style='width:3%;'></td>");
                            GridViewClientScriptsHTML.Append("<td align='left' valign='middle' style='width:10%;'>");
                            GridViewClientScriptsHTML.Append(" <span id='Control_ASP.usercontrols_medicationorderdetails_ascx_DataGridScriptHistory_ctl02_LabelDeliveryMethod'>" + DataViewClientScriptHistory[RowIndex]["DeliveryMethod"] + " </span>");
                            GridViewClientScriptsHTML.Append("</td><td style='width:2%' align='left' scope='col'></td><td align='left' valign='middle' style='width:10%;'>");
                            GridViewClientScriptsHTML.Append(" <span id='Control_ASP.usercontrols_medicationorderdetails_ascx_DataGridScriptHistory_ctl02_LabelScriptCreationDate'>" + Convert.ToDateTime(DataViewClientScriptHistory[RowIndex]["ScriptCreationDate"]).ToString("MM/dd/yyyy HH:mm tt") + " </span>");
                            GridViewClientScriptsHTML.Append("</td><td style='width:2%' align='left' scope='col'></td><td align='left' valign='middle' style='width:10%;'>");
                            GridViewClientScriptsHTML.Append(" <span id='usercontrols_medicationorderdetails_ascx_DataGridScriptHistory_ctl02_LabelCreatedBy'>" + DataViewClientScriptHistory[RowIndex]["CreatedBy"] + " </span>");
                            GridViewClientScriptsHTML.Append("</td><td align='left' scope='col' style='width:2%;'></td><td align='left' valign='middle' style='width:15%;'>");
                            GridViewClientScriptsHTML.Append(" <span id='usercontrols_medicationorderdetails_ascx_DataGridScriptHistory_ctl02_LabelReason'>" + DataViewClientScriptHistory[RowIndex]["Reason"] + " </span>");
                            GridViewClientScriptsHTML.Append("</td><td align='left' scope='col' style='width:2%;'></td><td align='left' valign='middle' style='width:15%;'>");
                            GridViewClientScriptsHTML.Append(" <span id='usercontrols_medicationorderdetails_ascx_DataGridScriptHistory_ctl02_LabelLocation'>" + DataViewClientScriptHistory[RowIndex]["LocationName"] + " </span>");
                            GridViewClientScriptsHTML.Append("</td><td align='left' scope='col' style='width:2%;'></td><td align='left' valign='middle' style='width:15%;'>");
                            GridViewClientScriptsHTML.Append(" <span id='Control_ASP.usercontrols_medicationorderdetails_ascx_DataGridScriptHistory_ctl03_LabelPharmacyName'>" + DataViewClientScriptHistory[RowIndex]["PharmacyName"] + " </span>");
                            if (ShowHidePillImage == "display:block")
                            {
                                GridViewClientScriptsHTML.Append("</td><td align='left' scope='col' style='width:2%;'></td><td align='left' valign='middle' style='width:10%;'>");
                                GridViewClientScriptsHTML.Append(" <img id='Control_ASP.usercontrols_medicationorderdetails_ascx_DataGridScriptHistory_ctl02_Pillbottle_Image' src='App_Themes/Includes/Images/pill-bottle.JPG' style='Width:15px' alt='Pill bottle'> </span>");
                            }
                            GridViewClientScriptsHTML.Append("</td>");
                            GridViewClientScriptsHTML.Append("</tr>");

                        }
                    }
                    else
                    {
                        GridViewClientScriptsHTML.Append("<tr class='GridViewRowStyle'>");
                        GridViewClientScriptsHTML.Append("<td colspan='4' align='center'>");
                        GridViewClientScriptsHTML.Append("No Records Found");
                        GridViewClientScriptsHTML.Append("</td></tr>");

                    }

                    GridViewClientScriptsHTML.Append("</table></div></div>");

                    return GridViewClientScriptsHTML.ToString();
                }
                return GridViewClientScriptsHTML.ToString();






            }
            catch (Exception ex)
            {
                return GridViewClientScriptsHTML.ToString();
            }
        }

        private void FillClientAllergyInteractionTable()
        {
            DataTable DataTableClientAllergiesInteraction;
            DataSet _DataSetClientSummary;
            Streamline.UserBusinessServices.ClientMedication objClientMedications;
            try
            {
                objClientMedications = new Streamline.UserBusinessServices.ClientMedication();
                DataTableClientAllergiesInteraction = objClientMedications.GetClientDrugAllergyInteraction(((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId, ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId);
                _DataSetClientSummary = new DataSet();
                _DataSetClientSummary = (DataSet)Session["DataSetClientSummary"];
                _DataSetClientSummary.Tables["ClientMedicationAllergyInteracions"].Clear();
                _DataSetClientSummary.Tables["ClientMedicationAllergyInteracions"].Merge(DataTableClientAllergiesInteraction);
                Session["DataSetClientSummary"] = _DataSetClientSummary;
            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally
            {
                DataTableClientAllergiesInteraction = null;
                _DataSetClientSummary = null;

            }

        }

        /// <summary>
        /// Author:Rishu 
        /// Purpose:GetSystemReports
        /// </summary>
        /// 
        [WebMethod(EnableSession = true)]
        public string GetSystemReportsMedHistory(string _ReportName, string StartDate, string EndDate, string DateType, string MedicationNameId, string PrescriberId)
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
                    if (_ReportName == "Medications - View History")
                    {
                        ReportUrl = ReportUrl.Replace("<ClientId>", (((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId).ToString());
                        ReportUrl = ReportUrl.Replace("<StartDate>", StartDate.ToString());
                        ReportUrl = ReportUrl.Replace("<EndDate>", EndDate.ToString());
                        //Added by Loveena in ref to Task#2424 View History - Pass New Filter Paramters to RDL
                        ReportUrl = ReportUrl.Replace("<DateType>", DateType.ToString());
                        ReportUrl = ReportUrl.Replace("<Medication>", MedicationNameId.ToString());
                        ReportUrl = ReportUrl.Replace("<Prescriber>", PrescriberId.ToString());
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


        /// <summary>
        /// Author:Loveena 
        /// Purpose:GetUniquePrescribers
        /// CreatedDate:17-Dec-2008
        /// Task#128
        /// </summary>
        /// 
        [WebMethod(EnableSession = true)]
        public DataSet GetUniquePrescribers(int _ClientId)
        {
            DataSet ds = null;
            try
            {
                Streamline.UserBusinessServices.ClientMedication ObjClientMedication = new Streamline.UserBusinessServices.ClientMedication();
                ds = ObjClientMedication.GetUniquePrescribers(_ClientId);
                return ds;
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


        /// <summary>
        /// Author:Rishu 
        /// Purpose:GetSystemReports
        /// </summary>
        /// 
        [WebMethod(EnableSession = true)]
        public string GetSystemReportsMedManagement(string _ReportName)
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
                if (!String.IsNullOrEmpty(ReportUrl)) // set the parameters values to report
                {
                    if (_ReportName == "Medications - Current")
                        ReportUrl = ReportUrl.Replace("<ClientId>", (((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId).ToString());
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

        public DataTable C2C5Drugs(int MedicationId)
        {
            Streamline.UserBusinessServices.ClientMedication ObjClientMedication = new Streamline.UserBusinessServices.ClientMedication();
            string _temp;
            using (DataSet dsTemp = ObjClientMedication.C2C5Drugs(MedicationId))
            {
                if (dsTemp.Tables.Count > 0)
                    dsTemp.Tables[0].TableName = "DrugCategory";
                return dsTemp.Tables[0];
            }
        }


        public DataTable GetDrugCategory(int MedicationNameId)
        {
            Streamline.UserBusinessServices.ClientMedication ObjClientMedication = new Streamline.UserBusinessServices.ClientMedication();
            string _temp;
            using (DataSet dsTemp = ObjClientMedication.GetDrugCategory(MedicationNameId))
            {
                if (dsTemp.Tables.Count > 0)
                    dsTemp.Tables[0].TableName = "DrugCategory";
                return dsTemp.Tables[0];
            }
        }

        /// <summary>
        /// function which Validates the Sample/Stock in Medications
        /// </summary>
        /// <param name="startDate"></param>
        /// <param name="days"></param>
        /// <param name="refill"></param>
        /// <returns>refill</returns>

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
        /// <summary>
        /// Function added to clear the Temporary deleted rows flags when clearing the rows
        /// </summary>
        /// <returns></returns>
        [WebMethod(EnableSession = true)]
        public bool ClearTemporaryDeletedRowsFlags()
        {
            try
            {
                if (Session["DataSetClientMedications"] != null)
                {
                    using (Streamline.UserBusinessServices.DataSets.DataSetClientMedications _DataSetClientMedications = (Streamline.UserBusinessServices.DataSets.DataSetClientMedications)Session["DataSetClientMedications"])
                    {
                        if (_DataSetClientMedications.ClientMedicationInstructions.Columns.Contains("TempRecordDeleted"))
                        {
                            DataRow[] _drTemporaryDeletedRows = _DataSetClientMedications.ClientMedicationInstructions.Select("TempRecordDeleted='Y' AND ISNULL(RecordDeleted,'N')<>'Y'");
                            foreach (DataRow dr in _drTemporaryDeletedRows)
                            {
                                dr.BeginEdit();
                                dr["TempRecordDeleted"] = System.DBNull.Value;
                                dr.EndEdit();
                            }
                        }
                        Session["DataSetClientMedications"] = _DataSetClientMedications;
                    }
                }
                return true;
            }
            catch (Exception ex)
            {
                return false;
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
                //Code modified by Anuj Tomar in ref to Task#22 SDI FY-10-venture  - New Medication Order Layout Optimizations 
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
                return null;
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "";
                else
                    ex.Data["CustomExceptionInformation"] = "";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = "";
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
                _Table.ID = "TableMedication" + rowIndex;
                TableRow _TableRow = new TableRow();
                _TableRow.ID = "TableMedicationRow_" + rowIndex;
                //_Table.Rows.Add(_TableRow);
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
                TableCell _TableCell16 = new TableCell();

                HtmlImage _ImgDeleteRow = new HtmlImage();
                _ImgDeleteRow.ID = "Control_ASP.usercontrols_clientmedicationorder_ascx_ImageDelete" + rowIndex;
                _ImgDeleteRow.Src = WebsiteSettings.BaseUrl + "./App_Themes/Includes/Images/deleteIcon.gif";
                _ImgDeleteRow.Attributes.Add("class", "handStyle");
                //Following added as per New Data model changes 2377 SC-Support
                //if (textboxButtonValue != null && textboxButtonValue == "Refill")
                //    _ImgDeleteRow.Disabled = true;

                myscript += "var Imagecontext" + rowIndex + ";";
                myscript += "var ImageclickCallback" + rowIndex + " =";
                myscript += " Function.createCallback(ClientMedicationOrder.DeleteRow , Imagecontext" + rowIndex + ");";
                myscript += "$addHandler($get('" + _ImgDeleteRow.ClientID + "'), 'click', ImageclickCallback" + rowIndex + ");";

                System.Web.UI.WebControls.Image _ImgFormulary = new System.Web.UI.WebControls.Image();
                _ImgFormulary.ID = "ImageFormulary" + rowIndex;
                _ImgFormulary.ImageUrl = WebsiteSettings.BaseUrl + "./App_Themes/Includes/Images/formularyFont.gif";
                _ImgFormulary.Attributes.Add("onClick", "ClientMedicationOrder.FormularyCheck(this);");
                _ImgFormulary.Attributes.Add("disabled", "disabled");
                _ImgFormulary.Attributes.Add("class", "handStyle");
                if (enableDisabled(Streamline.BaseLayer.Permissions.Formulary) == "Disabled")
                {
                    _ImgFormulary.Style.Add("display", "none");
                }
                else
                {
                    _TableCell1b.Width = new Unit(18, UnitType.Pixel);
                }


                DropDownList _DropDownListStrength = new DropDownList();
                _DropDownListStrength.Width = new Unit(100, UnitType.Percentage);
                _DropDownListStrength.Height = 20;

                //if (textboxButtonValue != null && textboxButtonValue == "Refill")
                //    _DropDownListStrength.Enabled = false;
                _DropDownListStrength.EnableViewState = true;
                _DropDownListStrength.ID = "Control_ASP.usercontrols_clientmedicationorder_ascx_DropDownListStrength" + rowIndex;
                _DropDownListStrength.Attributes.Add("class", "ddlist");

                TextBox _txtQuantity = new TextBox();
                _txtQuantity.BackColor = System.Drawing.Color.White;
                _txtQuantity.MaxLength = 4;
                _txtQuantity.Style["font-size"] = "8.50pt";

                //if (textboxButtonValue != null && textboxButtonValue == "Refill")
                //    _txtQuantity.Enabled = false;
                _txtQuantity.ID = "Control_ASP.usercontrols_clientmedicationorder_ascx_TextBoxQuantity" + rowIndex;
                _txtQuantity.Width = new Unit(94, UnitType.Percentage);
                //_txtQuantity.Height = 20;
                _txtQuantity.Visible = true;
                _txtQuantity.Style["text-align"] = "Right";
                _txtQuantity.Attributes.Add("class", "Textbox");
                myscript += "$create(Streamline.SmartClient.UI.TextBox, {'ignoreEnterKey':true,Decimal:true}, {'onBlur':ClientMedicationOrder.ManipulateRowValues},{},$get('" + _txtQuantity.ClientID + "'));";


                DropDownList _DropDownListUnit = new DropDownList();
                _DropDownListUnit.Width = new Unit(100, UnitType.Percentage);
                _DropDownListUnit.Height = 20;
                //if (textboxButtonValue != null && textboxButtonValue == "Refill")
                //    _DropDownListUnit.Enabled = false;
                _DropDownListUnit.ID = "Control_ASP.usercontrols_clientmedicationorder_ascx_DropDownListUnit" + rowIndex;
                _DropDownListUnit.Attributes.Add("class", "ddlist");

                DropDownList _DropDownListSchedule = new DropDownList();
                _DropDownListSchedule.Width = new Unit(100, UnitType.Percentage);
                _DropDownListSchedule.Height = 20;
                //if (textboxButtonValue != null && textboxButtonValue == "Refill")
                //    _DropDownListSchedule.Enabled = false;
                _DropDownListSchedule.ID = "Control_ASP.usercontrols_clientmedicationorder_ascx_DropDownListSchedule" + rowIndex;
                _DropDownListSchedule.Style["font-size"] = "9.00pt";
                _DropDownListSchedule.Attributes.Add("class", "ddlist");

                TextBox _txtStartDate = new TextBox();
                _txtStartDate.BackColor = System.Drawing.Color.White;
                _txtStartDate.ID = "Control_ASP.usercontrols_clientmedicationorder_ascx_TextBoxStartDate" + rowIndex;
                _txtStartDate.Width = new Unit(94, UnitType.Percentage);
                _txtStartDate.Visible = true;
                _txtStartDate.Attributes.Add("class", "Textbox");
                _txtStartDate.Style["font-size"] = "8.50pt";
                myscript += "$create(Streamline.SmartClient.UI.TextBox, {'ignoreEnterKey':true,DateTime:true}, {'onBlur':ClientMedicationOrder.ManipulateRowValues},{},$get('" + _txtStartDate.ClientID + "'));";

                Image _ImgStartDate = new Image();
                _ImgStartDate.ID = "Control_ASP.usercontrols_clientmedicationorder_ascx_ImageStartDate" + rowIndex;
                _ImgStartDate.ImageUrl = WebsiteSettings.BaseUrl + "./App_Themes/Includes/Images/calender_White.jpg";
                _ImgStartDate.Attributes.Add("onClick", "ClientMedicationOrder.CalShow( this,'" + _txtStartDate.ClientID + "')");
                _ImgStartDate.Attributes.Add("onmouseover", "ClientMedicationOrder.CalShow( this,'" + _txtStartDate.ClientID + "')");

                TextBox _txtDays = new TextBox();
                _txtDays.BackColor = System.Drawing.Color.White;
                _txtDays.MaxLength = 4;
                _txtDays.ID = "Control_ASP.usercontrols_clientmedicationorder_ascx_TextBoxDays" + rowIndex;
                _txtDays.Width = new Unit(94, UnitType.Percentage);
                _txtDays.Height = 18;
                _txtDays.Visible = true;
                _txtDays.Attributes.Add("MedicationDays", ((Streamline.BaseLayer.StreamlineIdentity)(Context.User.Identity)).MedicationDaysDefault.ToString());
                _txtDays.Style["text-align"] = "Right";
                _txtDays.Attributes.Add("class", "Textbox");
                _txtDays.Style["font-size"] = "8.50pt";
                myscript += "$create(Streamline.SmartClient.UI.TextBox, {'ignoreEnterKey':true,Numeric:true}, {'onBlur':ClientMedicationOrder.ManipulateRowValues},{},$get('" + _txtDays.ClientID + "'));";

                string _comboBoxPharmacyTextDivString = "<div id='ComboBoxPharmacyDDDiv_" + rowIndex +
                   "' style='border: solid 1px #7b9ebd; height:18px; position:relative; overflow:hidden;' onclick=\"ClientMedicationOrder.onClickPharmacyComboList(this, '#ComboBoxPharmacyDDList_" + rowIndex +
                   "');\"><input type='text' id='ComboBoxPharmacyDD_" + rowIndex +
                   "' value='' style='border:none; width: 137px; height:18px; position:absolute; left:0;' onchange=\"ClientMedicationOrder.onChangePharmacyComboList(this, '#ComboBoxPharmacyDDList_" + rowIndex +
                   "');\" onkeydown=\"ClientMedicationOrder.onKeyDownPharmacyComboList(event, '#ComboBoxPharmacyDDList_" + rowIndex +
                   "');\" onBlur=\"ClientMedicationOrder.onBlurPharmacyComboList(event, '#ComboBoxPharmacyDDList_" + rowIndex +
                   "');\" /><div style=' position:absolute; right:0;; height:18px; width:19px;' class='ComboBoxDrugDDImage'>&nbsp;</div></div>";

                var _comboBoxPharmacyTextDiv = new LiteralControl(_comboBoxPharmacyTextDivString);

                string _comboBoxPharmacyDDListString = @"<div style='display:none; white-space:nowrap;' id='ComboBoxPharmacyDDList_" + rowIndex +
                    "' isempty='true' caller='ComboBoxPharmacyDD_" + rowIndex + "' class='combolist' onclick=\"ClientMedicationOrder.onSelectedPharmacyComboList(event, this);\"></div>";

                var _comboBoxPharmacyDDList = new LiteralControl(_comboBoxPharmacyDDListString);

                DropDownList _DropDownListPotencyUnitCode = new DropDownList();
                _DropDownListPotencyUnitCode.Width = new Unit(100, UnitType.Percentage);
                _DropDownListPotencyUnitCode.Height = 20;
                _DropDownListPotencyUnitCode.ID = "Control_ASP.usercontrols_clientmedicationorder_ascx_DropDownListPotencyUnitCode" + rowIndex;
                _DropDownListPotencyUnitCode.Attributes.Add("class", "ddlist");

                TextBox _txtSample = new TextBox();
                _txtSample.BackColor = System.Drawing.Color.White;
                _txtSample.MaxLength = 4;
                _txtSample.ID = "Control_ASP.usercontrols_clientmedicationorder_ascx_TextBoxSample" + rowIndex;
                _txtSample.Width = new Unit(94, UnitType.Percentage);
                _txtSample.Height = 20;
                _txtSample.Visible = true;
                _txtSample.Style["text-align"] = "Right";
                _txtSample.Attributes.Add("class", "Textbox");
                _txtSample.Style["font-size"] = "8.50pt";
                myscript += "$create(Streamline.SmartClient.UI.TextBox, {'ignoreEnterKey':true,Decimal:true}, {'onBlur':ClientMedicationOrder.ManipulateRowValues},{},$get('" + _txtSample.ClientID + "'));";

                TextBox _txtStock = new TextBox();
                _txtStock.BackColor = System.Drawing.Color.White;
                _txtStock.MaxLength = 4;
                _txtStock.ID = "Control_ASP.usercontrols_clientmedicationorder_ascx_TextBoxStock" + rowIndex;
                _txtStock.Width = new Unit(94, UnitType.Percentage);
                _txtStock.Height = 20;
                _txtStock.Visible = true;
                _txtStock.Style["text-align"] = "Right";
                _txtStock.Attributes.Add("class", "Textbox");
                _txtStock.Style["font-size"] = "8.50pt";
                myscript += "$create(Streamline.SmartClient.UI.TextBox, {'ignoreEnterKey':true,Decimal:true}, {'onBlur':ClientMedicationOrder.ManipulateRowValues},{},$get('" + _txtStock.ClientID + "'));";

                TextBox _txtRefills = new TextBox();
                _txtRefills.BackColor = System.Drawing.Color.White;
                _txtRefills.MaxLength = 2;
                _txtRefills.ID = "Control_ASP.usercontrols_clientmedicationorder_ascx_TextBoxRefills" + rowIndex;
                _txtRefills.Width = new Unit(94, UnitType.Percentage);
                _txtRefills.Height = 20;
                _txtRefills.Visible = true;
                _txtRefills.Style["text-align"] = "Right";
                _txtRefills.Attributes.Add("class", "Textbox");
                _txtRefills.Style["font-size"] = "8.50pt";
                myscript += "$create(Streamline.SmartClient.UI.TextBox, {'ignoreEnterKey':true,Decimal:true}, {'onBlur':ClientMedicationOrder.ManipulateRowValues},{},$get('" + _txtRefills.ClientID + "'));";

                TextBox _txtEndDate = new TextBox();
                _txtEndDate.ID = "Control_ASP.usercontrols_clientmedicationorder_ascx_TextBoxEndDate" + rowIndex;
                _txtEndDate.Width = new Unit(96, UnitType.Percentage);
                _txtEndDate.Height = 20;
                _txtEndDate.Enabled = true;
                _txtEndDate.Style["text-align"] = "Right";
                _txtEndDate.Attributes.Add("class", "Textbox");
                _txtEndDate.Style["font-size"] = "8.50pt";
                myscript += "$create(Streamline.SmartClient.UI.TextBox, {'ignoreEnterKey':true,DateTime:true}, {},{},$get('" + _txtEndDate.ClientID + "'));";

                //Added by Loveena in ref to Task#2802
                HiddenField _hiddenAutoCalcAllowed = new HiddenField();
                _hiddenAutoCalcAllowed.ID = "HiddenFieldAutoCalcAllowed" + rowIndex;

                Label _RowIdentifier = new Label();
                _RowIdentifier.ID = "RowIdentifier" + rowIndex;

                //Added by Loveena in ref to Task#85 SDI-FY10 Venture
                HiddenField _hiddenstrengthRowIdentifier = new HiddenField();

                HiddenField _noOfDaysOfWeek = new HiddenField();
                _noOfDaysOfWeek.ID = "noOfDaysOfWeek" + rowIndex;

                _hiddenstrengthRowIdentifier.ID = "HiddenRowIdentifier" + rowIndex;
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
                _TableCell6.Width = new Unit(2, UnitType.Percentage);
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

                _DropDownListStrength.Attributes.Add("onchange", "ClientMedicationOrder.onStrengthChange(this,'" + _DropDownListUnit.ClientID + "',null,'" + _txtDays.ClientID + "','" + TextBoxStartDate + "','" + _txtStartDate.ClientID + "','" + _txtQuantity.ClientID + "','" + rowIndex + "')");
                _DropDownListUnit.Attributes.Add("onchange", "ClientMedicationOrder.onUnitChange()");
                _DropDownListUnit.Attributes.Add("onBlur", "ClientMedicationOrder.onUnitBlur(this)");
                _DropDownListSchedule.Attributes.Add("onchange", "ClientMedicationOrder.onScheduleChange()");
                _DropDownListSchedule.Attributes.Add("onBlur", "ClientMedicationOrder.onScheduleBlur(this)");
                _DropDownListPotencyUnitCode.Attributes.Add("onchange", "ClientMedicationOrder.onPotencyUnitCodeChange(this, " + rowIndex + ");");
                _txtStartDate.Attributes.Add("onBlur", "ClientMedicationOrder.onStartDate()");
                _txtEndDate.Attributes.Add("onBlur", "ClientMedicationOrder.onEndDate()");

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

        private string enableDisabled(Permissions per)
        {

            if (((Streamline.BaseLayer.StreamlinePrinciple)Context.User).HasPermission(per))
                return "";
            else
                return "Disabled";
        }


        /// <summary>
        /// Author:Rohit. ref #90 
        /// Purpose:GetSystemReports
        /// </summary>
        /// 
        [WebMethod(EnableSession = true)]
        public string ShowSystemReports(string _ReportName, string _ReportURL, string stringMedicationIds)
        {
            try
            {

                //return "1,2,3,4,5,6,7,8"; 
                //DataTable DataTableClientsList = new DataTable();
                //DataTableClientsList=((Streamline.BaseLayer.StreamlinePrinciple)Context.User).SystemReports; 

                System.Guid sessionId = System.Guid.NewGuid();
                System.Data.SqlClient.SqlParameter[] _ParametersObject = null;

                DataTable _MedicationIds = new DataTable();
                _MedicationIds.Columns.Add(new DataColumn("Value"));
                _MedicationIds.Columns.Add(new DataColumn("Type"));
                DataRow r;
                if (stringMedicationIds != "")
                {
                    foreach (string str in stringMedicationIds.Split(','))
                    {
                        r = _MedicationIds.NewRow();
                        r["Value"] = str;
                        r["Type"] = "Integer";
                        _MedicationIds.Rows.Add(r);
                    }


                    Streamline.UserBusinessServices.UserInfo _userInfo = new Streamline.UserBusinessServices.UserInfo();
                    _userInfo.InsertReport(sessionId, _MedicationIds, "");// (Streamline.BaseLayer.StreamlinePrinciple)Context.User.Identity);                
                }
                _ReportURL = _ReportURL.Replace("<SessionId>", sessionId.ToString());
                _ReportURL = _ReportURL.Replace("<ClientId>", ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId.ToString());
                return _ReportURL;
            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally
            {
                //ds = null;
            }
        }



        /// <summary>
        /// Author:Rohit. ref #90 
        /// Purpose:GetSystemReports
        /// </summary>
        /// 
        [WebMethod(EnableSession = true)]
        public string FillSystemReports()
        {
            try
            {
                //return "1><2><3><4><5><6><7><8<>one><two><thr><fou><fiv><six><swv><eight";
                DataTable _dtReports = new DataTable();
                _dtReports = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).SystemReports;

                string _text;
                string _value;
                string _rptName;
                string _rptUrl;
                _text = "";
                _value = "";
                _rptName = "";
                _rptUrl = "";

                for (int i = 0; i < _dtReports.Rows.Count; i++)
                {
                    _rptName = _dtReports.Rows[i]["ReportName"].ToString();

                    if (_rptName == "")
                        _rptName = " ";

                    if (_text == "")
                        _text = _rptName;
                    else
                        _text = _text + "><" + _rptName;

                    _rptUrl = _dtReports.Rows[i]["ReportURL"].ToString();
                    if (_rptUrl == null || _rptUrl == "")
                        _rptUrl = " ";

                    if (_value == "")
                        _value = _rptUrl;
                    else
                        _value = _value + "><" + _rptUrl;

                }

                return _text + "<>" + _value;

            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally
            {
                //ds = null;
            }
        }

        // <summary>
        /// This function will be used to Populate Medication Row on Change Order Button in Prescribe List
        ///  //Function Added Chandan Srivastava
        /// Task #85 Build MM #1.7
        /// </summary>
        /// <param name="ClientMedicationId"></param>
        [WebMethod(EnableSession = true)]
        public int PopulateDataOfMedicationList()
        {
            try
            {
                Session["IsDirty"] = true;
                return 1;
            }
            catch (Exception ex)
            {

                return -1;
            }
        }

        // <summary>
        /// This function will be used to Populate Medication Row on Change Order Button in Prescribe List
        ///  //Function Added Chandan Srivastava
        /// Task #85 Build MM #1.7
        /// </summary>
        /// <param name="ClientMedicationId"></param>
        /// ----------Modification History----------------
        /// ---Date------Author------Purpose--------------
        /// 23 Dec 2009  Pradeep     Made changes as per task#2722
        [WebMethod(EnableSession = true)]
        public void UpdateLocationForRdl(int LocationId)
        {
            Streamline.UserBusinessServices.SharedTables objectSharedTables = null;
            objectSharedTables = new Streamline.UserBusinessServices.SharedTables();
            DataSet DataSetLocations = new DataSet();
            DataSet dstemptables = new DataSet();
            //DataRow drtemptables = new DataRow();
            try
            {

                //if (Session["DataSetRdlTemp"] != null)
                //{
                //    DataSetLocations = objectSharedTables.getLocations(Convert.ToInt32(((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId));
                //    dstemptables = (DataSet)Session["DataSetRdlTemp"];

                //    DataRow[] drLocation = DataSetLocations.Tables[0].Select("locationId= '" + LocationId + "'");

                //    for (int i = 0; i <= dstemptables.Tables[0].Rows.Count-1; i++)
                //    {
                //        dstemptables.Tables[0].Rows[i]["LocationAddress"]= drLocation[0]["Address"].ToString() ;
                //        dstemptables.Tables[0].Rows[i]["LocationName"] = drLocation[0]["LocationName"].ToString();
                //        dstemptables.Tables[0].Rows[i]["LocationPhone"] = drLocation[0]["PhoneNumber"].ToString();
                //        dstemptables.Tables[0].Rows[i]["LocationFax"] = drLocation[0]["FaxNumber"].ToString();
                //    }
                //    Session["DataSetRdlTemp"] = dstemptables;
                //}
            }
            catch (Exception ex)
            {
                throw (ex);
            }
        }

        #region Functions used for Titration



        /// <summary>
        /// <description>Initialize the Titration dataset for first time.</description>
        /// <author>Ankesh Bharti</author>
        /// <createdDate>26/12/2008</createdDate>
        /// <aceTask#>75</aceTask#>
        /// </summary>
        /// <param name="MedicationId"></param>
        /// <param name="MedicationNameId"></param>
        /// <param name="MedicationName"></param>
        /// <param name="OrderDate"></param>
        /// <param name="MedicationDAW"></param>
        /// <param name="SpecialInstructions"></param>
        /// <param name="DxPurpose"></param>
        /// <param name="Prescriber"></param>
        /// <param name="TitrateMode"></param>
        [WebMethod(EnableSession = true)]
        [GenerateScriptType(typeof(ClientMedicationRow))]
        public string UpdateDatasetForTitration(ClientMedicationRow objTitrateMedication)
        {
            Streamline.UserBusinessServices.DataSets.DataSetClientMedications _dataSetClientMedications = null;
            DataSet _dataSetTitration = null;
            DataSet _dataSetTitrationTemp = null;
            DataTable _dataTableClientMedications = null;
            int _maxMedicationId = 0;
            string _titrationType = "";

            try
            {
                if (Session["DataSetTitration"] != null)
                {
                    _dataSetClientMedications = (Streamline.UserBusinessServices.DataSets.DataSetClientMedications)Session["DataSetTitration"];
                }
                else
                {
                    _dataSetClientMedications = new Streamline.UserBusinessServices.DataSets.DataSetClientMedications();
                }
                if (Session["DataSetClientMedications"] != null)
                {
                    _dataSetTitrationTemp = (Streamline.UserBusinessServices.DataSets.DataSetClientMedications)Session["DataSetClientMedications"];
                    if (_dataSetTitrationTemp.Tables["ClientMedications"].Rows.Count > 0)
                    {
                        _maxMedicationId = GetMinValue(Convert.ToInt32(_dataSetTitrationTemp.Tables["ClientMedications"].Compute("Min(ClientMedicationId)", "")));
                    }
                }
                _dataSetTitration = _dataSetClientMedications.Copy();
                _dataTableClientMedications = _dataSetTitration.Tables["ClientMedications"];

                if (objTitrateMedication.TitrateMode == "New")
                {
                    DataRow _dataRowClientMedication;
                    _dataRowClientMedication = _dataTableClientMedications.NewRow();
                    _dataRowClientMedication["ClientMedicationId"] = _maxMedicationId;
                    _dataRowClientMedication["MedicationNameId"] = objTitrateMedication.MedicationNameId;
                    _dataRowClientMedication["ClientId"] = (((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId);
                    _dataRowClientMedication["SpecialInstructions"] = objTitrateMedication.SpecialInstructions;
                    //Code added by Loveena on 06-May-2009.
                    if (objTitrateMedication.DesiredOutcome.Trim() != string.Empty)
                    {
                        _dataRowClientMedication["DesiredOutComes"] = objTitrateMedication.DesiredOutcome;
                    }
                    else
                    {
                        _dataRowClientMedication["DesiredOutComes"] = DBNull.Value;
                    }
                    if (objTitrateMedication.Comments.Trim() != string.Empty)
                    {
                        _dataRowClientMedication["Comments"] = objTitrateMedication.Comments;
                    }
                    else
                    {
                        _dataRowClientMedication["Comments"] = DBNull.Value;
                    }


                    if (objTitrateMedication.OffLabel == "True")
                        _dataRowClientMedication["OffLabel"] = "Y";
                    //Code ends over here.
                    _dataRowClientMedication["MedicationName"] = objTitrateMedication.MedicationName;
                    if (objTitrateMedication.DAW == "True")
                        _dataRowClientMedication["DAW"] = "Y";
                    _dataRowClientMedication["DrugPurpose"] = objTitrateMedication.DrugPurpose;
                    _dataRowClientMedication["DSMCode"] = objTitrateMedication.DSMCode;
                    _dataRowClientMedication["DSMNumber"] = Convert.ToDecimal(objTitrateMedication.DSMNumber);
                    _dataRowClientMedication["DxId"] = (objTitrateMedication.DxId);
                    _dataRowClientMedication["DrugCategory"] = objTitrateMedication.DrugCategory;
                    _dataRowClientMedication["PrescriberName"] = objTitrateMedication.PrescriberName;
                    _dataRowClientMedication["PrescriberId"] = objTitrateMedication.PrescriberId;
                    _dataRowClientMedication["Ordered"] = "Y";
                    _dataRowClientMedication["TitrationType"] = "T";
                    _titrationType = _dataRowClientMedication["TitrationType"].ToString();
                    _dataRowClientMedication["RowIdentifier"] = System.Guid.NewGuid();
                    _dataRowClientMedication["CreatedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                    _dataRowClientMedication["CreatedDate"] = DateTime.Now;
                    _dataRowClientMedication["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                    _dataRowClientMedication["ModifiedDate"] = DateTime.Now;
                    _dataRowClientMedication["RecordDeleted"] = System.DBNull.Value;
                    _dataRowClientMedication["DeletedBy"] = DBNull.Value;
                    _dataRowClientMedication["DeletedDate"] = DBNull.Value;
                    _dataTableClientMedications.Rows.Add(_dataRowClientMedication);
                }
                else
                {
                    DataRow[] _dataRowClientMedication = _dataTableClientMedications.Select("ClientMedicationId=" + objTitrateMedication.MedicationId);
                    _dataRowClientMedication[0]["SpecialInstructions"] = objTitrateMedication.SpecialInstructions;
                    //Code added by Loveena on 06-May-2009.
                    if (objTitrateMedication.DesiredOutcome.Trim() != string.Empty)
                    {
                        _dataRowClientMedication[0]["DesiredOutComes"] = objTitrateMedication.DesiredOutcome;
                    }
                    else
                    {
                        _dataRowClientMedication[0]["DesiredOutComes"] = DBNull.Value;
                    }
                    if (objTitrateMedication.Comments.Trim() != string.Empty)
                    {
                        _dataRowClientMedication[0]["Comments"] = objTitrateMedication.Comments;
                    }
                    else
                    {
                        _dataRowClientMedication[0]["Comments"] = DBNull.Value;
                    }

                    //Code ends over here.
                    _dataRowClientMedication[0]["DrugPurpose"] = objTitrateMedication.DrugPurpose;
                    _dataRowClientMedication[0]["DSMCode"] = objTitrateMedication.DSMCode;
                    _dataRowClientMedication[0]["DSMNumber"] = Convert.ToDecimal(objTitrateMedication.DSMNumber);
                    _dataRowClientMedication[0]["DxId"] = (objTitrateMedication.DxId);
                    _dataRowClientMedication[0]["PrescriberName"] = objTitrateMedication.PrescriberName;
                    _dataRowClientMedication[0]["PrescriberId"] = objTitrateMedication.PrescriberId;
                    _titrationType = _dataRowClientMedication[0]["TitrationType"].ToString();
                }
                Session["DataSetTitration"] = _dataSetTitration;
                return _titrationType;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {

            }
        }

        /// <summary>
        /// <description>Function called on the click of 'Add Step' button to create/modify titration step.</description>
        /// <author>Ankesh Bharti</author>
        /// <createdDate>27/12/2008</createdDate>
        /// <aceTask#>75</aceTask#>
        /// </summary>
        /// <param name="category"></param>
        /// <param name="objClientMedicationInstructions"></param>
        /// <param name="method"></param>
        /// <returns></returns>
        [WebMethod(EnableSession = true)]
        [GenerateScriptType(typeof(ClientMedicationInstructionRow))]
        public string SaveTitrationRow(int medicationNameId, string category, string RowIdentifierCM, string addStepFlag, ClientMedicationInstructionRow[] objClientMedicationInstructions, string method, int currentStepNumber, DateTime currentStepStartDate, string toModifyStepNumber)
        {
            DataSet DataSetPrescibedMedications = null;
            DataSet _dataSetTitrationTemp = null;
            bool _FlagMaxInstructionIdSelectedFromPrescribedPage = false;
            bool _FlagMaxScriptDrugIdSelectedFromPrescribedPage = false;
            bool _ValidateSampleStock = false;
            string _MedicationStartDate = "";
            string _MedicationEndDate = "";
            int _maxStepCount = 0;
            DateTime _firstStepDate = Convert.ToDateTime(null);
            string NextDate = "";

            try
            {
                bool newRowCM = false;
                bool newRowCMI = false;
                bool newRowCMSD = false;
                bool newRowCMSDS = false;
                Streamline.UserBusinessServices.DataSets.DataSetClientMedications _dataSetTitration = null;
                DataTable DataTableClientMedications = null;
                DataTable DataTableClientMedicationInstructions = null;
                DataTable DataTableClientMedicationScriptDrugs = null;
                DataTable DataTableClientMedicationScriptDrugStrengths = null;
                int iMaxClientMedicationInstructionId = 0;
                int iMaxClientMedicationScriptDrugId = 0;
                int iMaxClientMedicationScriptDrugStrengthId = 0;

                if (Session["DataSetTitration"] != null)
                    _dataSetTitration = (Streamline.UserBusinessServices.DataSets.DataSetClientMedications)Session["DataSetTitration"];
                else
                    _dataSetTitration = new Streamline.UserBusinessServices.DataSets.DataSetClientMedications();

                DataTableClientMedications = _dataSetTitration.ClientMedications;
                DataTableClientMedicationInstructions = _dataSetTitration.ClientMedicationInstructions;
                DataTableClientMedicationScriptDrugs = _dataSetTitration.ClientMedicationScriptDrugs;
                DataTableClientMedicationScriptDrugStrengths = _dataSetTitration.ClientMedicationScriptDrugStrengths;

                if (Session["DataSetClientMedications"] != null)
                {
                    _dataSetTitrationTemp = (Streamline.UserBusinessServices.DataSets.DataSetClientMedications)Session["DataSetClientMedications"];
                    if (_dataSetTitrationTemp.Tables["ClientMedicationInstructions"].Rows.Count > 0)
                    {
                        iMaxClientMedicationInstructionId = GetMinValue(
                            Convert.ToInt32(_dataSetTitrationTemp.Tables["ClientMedicationInstructions"].Compute("Min(ClientMedicationInstructionId)", "")),
                            Convert.ToInt32(
                            _dataSetTitration.Tables["ClientMedicationInstructions"] != null &&
                            _dataSetTitration.Tables["ClientMedicationInstructions"].Rows.Count > 0 ?
                            _dataSetTitration.Tables["ClientMedicationInstructions"].Compute("Min(ClientMedicationInstructionId)", "") : 0));
                    }
                    if (_dataSetTitrationTemp.Tables["ClientMedicationScriptDrugs"].Rows.Count > 0)
                    {
                        iMaxClientMedicationScriptDrugId = GetMinValue(
                            Convert.ToInt32(_dataSetTitrationTemp.Tables["ClientMedicationScriptDrugs"].Compute("Min(ClientMedicationScriptDrugId)", "")),
                            Convert.ToInt32(
                            _dataSetTitration.Tables["ClientMedicationScriptDrugs"] != null &&
                            _dataSetTitration.Tables["ClientMedicationScriptDrugs"].Rows.Count > 0 ?
                            _dataSetTitration.Tables["ClientMedicationScriptDrugs"].Compute("Min(ClientMedicationScriptDrugId)", "") : 0));
                    }
                    if (_dataSetTitrationTemp.Tables["ClientMedicationScriptDrugStrengths"].Rows.Count > 0)
                    {
                        iMaxClientMedicationScriptDrugStrengthId = GetMinValue(
                            Convert.ToInt32(_dataSetTitrationTemp.Tables["ClientMedicationScriptDrugStrengths"].Compute("Min(ClientMedicationScriptDrugStrengthId)", "")),
                            Convert.ToInt32(
                            _dataSetTitration.Tables["ClientMedicationScriptDrugStrengths"] != null &&
                            _dataSetTitration.Tables["ClientMedicationScriptDrugStrengths"].Rows.Count > 0 ?
                            _dataSetTitration.Tables["ClientMedicationScriptDrugStrengths"].Compute("Min(ClientMedicationScriptDrugStrengthId)", "") : 0));
                    }
                }

                if (RowIdentifierCM == null || RowIdentifierCM == "")
                    RowIdentifierCM = "-1";

                DataRow[] temprowidentifier = DataTableClientMedications.Select("RowIdentifier='" + RowIdentifierCM + "'");
                DataRow DataRowClientMedication;
                if (temprowidentifier.Length > 0)
                {
                    DataRowClientMedication = temprowidentifier[0];
                    newRowCM = false;
                }
                else
                {
                    temprowidentifier = DataTableClientMedications.Select("MedicationNameId=" + medicationNameId);
                    DataRowClientMedication = temprowidentifier[0];
                }

                if (method.ToUpper() != "REFILL")
                {
                    _MedicationStartDate = DataRowClientMedication["MedicationStartDate"].ToString();
                    DataRowClientMedication["MedicationStartDate"] = System.DBNull.Value;
                }
                else
                    DataRowClientMedication["MedicationEndDateForDisplay"] = System.DBNull.Value;

                _MedicationEndDate = DataRowClientMedication["MedicationEndDate"].ToString();
                DataRowClientMedication["MedicationEndDate"] = System.DBNull.Value;

                DataRow drClientMedicationScripts;
                if (_dataSetTitration.Tables["ClientMedicationScripts"].Rows.Count < 1)
                    drClientMedicationScripts = _dataSetTitration.Tables["ClientMedicationScripts"].NewRow();
                else
                    drClientMedicationScripts = _dataSetTitration.Tables["ClientMedicationScripts"].Rows[0];

                drClientMedicationScripts["Clientid"] = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId;

                drClientMedicationScripts["OrderingMethod"] = "P";

                drClientMedicationScripts["PharmacyId"] = System.DBNull.Value;
                drClientMedicationScripts["PrintDrugInformation"] = System.DBNull.Value;
                drClientMedicationScripts["ScriptCreationDate"] = DateTime.Now;
                drClientMedicationScripts["OrderDate"] = DateTime.Now;
                drClientMedicationScripts["LocationId"] = System.DBNull.Value;
                drClientMedicationScripts["ScriptEventType"] = "C";
                drClientMedicationScripts["OrderingPrescriberId"] = 731;
                drClientMedicationScripts["OrderingPrescriberName"] = "dnf";
                drClientMedicationScripts["RowIdentifier"] = System.Guid.NewGuid();
                drClientMedicationScripts["CreatedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                drClientMedicationScripts["CreatedDate"] = DateTime.Now;
                drClientMedicationScripts["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                drClientMedicationScripts["ModifiedDate"] = DateTime.Now;
                if (_dataSetTitration.Tables["ClientMedicationScripts"].Rows.Count < 1)
                    _dataSetTitration.Tables["ClientMedicationScripts"].Rows.Add(drClientMedicationScripts);

                _FlagMaxInstructionIdSelectedFromPrescribedPage = false;
                _FlagMaxScriptDrugIdSelectedFromPrescribedPage = false;
                int _loopCounter = 0;

                if (currentStepNumber == 1)
                {
                    _firstStepDate = currentStepStartDate;
                }
                else
                {
                    DataRow[] _dataRowCMInstructions = null;
                    if (toModifyStepNumber == "1" && addStepFlag == "Modify")
                    {
                        _dataRowCMInstructions = DataTableClientMedicationInstructions.Select("TitrationStepNumber=" + 2 + "and ISNULL(RecordDeleted,'N')<>'Y'");
                    }
                    else
                    {
                        _dataRowCMInstructions = DataTableClientMedicationInstructions.Select("TitrationStepNumber=" + 1 + " and ISNULL(RecordDeleted,'N')<>'Y'");
                    }

                    if (_dataRowCMInstructions.Length > 0)
                    {
                        _firstStepDate = Convert.ToDateTime(_dataRowCMInstructions[0]["StartDate"]);
                    }
                    else
                    {
                        _firstStepDate = currentStepStartDate;
                    }
                }
                // Logic for Renumbering of steps.
                if (DataTableClientMedicationInstructions.Rows.Count > 0)
                {
                    if (DataTableClientMedicationInstructions.Compute("Max(TitrationStepNumber)", "ISNULL(RecordDeleted,'N')<>'Y'").ToString() != "")
                        _maxStepCount = Convert.ToInt32(DataTableClientMedicationInstructions.Compute("Max(TitrationStepNumber)", "ISNULL(RecordDeleted,'N')<>'Y'"));
                }

                if (addStepFlag != "Modify")
                {
                    for (int _rowCount = _maxStepCount; _rowCount >= objClientMedicationInstructions[0].TitrationStep; _rowCount--)
                    {
                        DataRow[] _dataRowInstructions = DataTableClientMedicationInstructions.Select("TitrationStepNumber=" + _rowCount + " and ISNULL(RecordDeleted,'N')<>'Y'");
                        foreach (DataRow dr in _dataRowInstructions)
                        {
                            dr["TitrationStepNumber"] = _rowCount + 1;
                            dr["DayNumber"] = CalculateDayNumber(_firstStepDate, Convert.ToDateTime(dr["StartDate"]));
                        }
                    }
                }
                else // Case for renumbering of steps on "Modify".
                {
                    if (currentStepNumber == Convert.ToInt32(toModifyStepNumber))  //If CurrentStepNumber is equal to ToModifyStepNumber.
                    {
                        DataRow[] _dataRowInstructionsTemp = DataTableClientMedicationInstructions.Select("ISNULL(RecordDeleted,'N')<>'Y'");
                        foreach (DataRow _dataRow in _dataRowInstructionsTemp)
                        {
                            _dataRow["DayNumber"] = CalculateDayNumber(_firstStepDate, Convert.ToDateTime(_dataRow["StartDate"]));
                        }
                    }
                    else
                    {
                        if (currentStepNumber > _maxStepCount)
                            throw new Exception("" + currentStepNumber + " is not valid step number for modifying the current step.");

                        // ReCalculating DayNumber if we have changed the date in case of modifying the step. 
                        DataRow[] _dataRowToModifyInstructionTemp = DataTableClientMedicationInstructions.Select("TitrationStepNumber=" + toModifyStepNumber + "and ISNULL(RecordDeleted,'N')<>'Y'");
                        foreach (DataRow drToModifyInstructionTemp in _dataRowToModifyInstructionTemp)
                        {
                            drToModifyInstructionTemp["TitrationStepNumber"] = -1;
                        }

                        if (currentStepNumber > Convert.ToInt32(toModifyStepNumber))// If CurrentStepNumber is greater than ToModifyStepNumber.
                        {
                            for (int _stepCount = Convert.ToInt32(toModifyStepNumber) + 1; _stepCount <= currentStepNumber; _stepCount++)
                            {
                                DataRow[] _dataRowTempInstructions = DataTableClientMedicationInstructions.Select("TitrationStepNumber=" + _stepCount + "and ISNULL(RecordDeleted,'N')<>'Y'");
                                foreach (DataRow dr in _dataRowTempInstructions)
                                {
                                    dr["TitrationStepNumber"] = Convert.ToInt32(dr["TitrationStepNumber"]) - 1;
                                    dr["DayNumber"] = CalculateDayNumber(_firstStepDate, Convert.ToDateTime(dr["StartDate"]));
                                }
                            }
                        }
                        else // If CurrentStepNumber is smaller than ToModifyStepNumber.
                        {
                            for (int _stepCount = Convert.ToInt32(toModifyStepNumber) - 1; _stepCount >= currentStepNumber; _stepCount--)
                            {
                                DataRow[] _dataRowTempInstructions = DataTableClientMedicationInstructions.Select("TitrationStepNumber=" + _stepCount + "and ISNULL(RecordDeleted,'N')<>'Y'");
                                foreach (DataRow dr in _dataRowTempInstructions)
                                {
                                    dr["TitrationStepNumber"] = Convert.ToInt32(dr["TitrationStepNumber"]) + 1;
                                    dr["DayNumber"] = CalculateDayNumber(_firstStepDate, Convert.ToDateTime(dr["StartDate"]));
                                }
                            }
                        }

                        DataRow[] _dataRowToModifyInstruction = DataTableClientMedicationInstructions.Select("TitrationStepNumber=-1 and ISNULL(RecordDeleted,'N')<>'Y'");
                        foreach (DataRow drToModifyInstruction in _dataRowToModifyInstruction)
                        {
                            drToModifyInstruction["TitrationStepNumber"] = currentStepNumber;
                        }
                    }
                }


                foreach (ClientMedicationInstructionRow row in objClientMedicationInstructions)
                {
                    DataRow DataRowClientMedInstructions;
                    _ValidateSampleStock = false;
                    _ValidateSampleStock = ValidateSampleStock(row.Days, row.Quantity, row.Schedule, row.Sample, row.Stock);

                    _loopCounter = _loopCounter + 1;

                    if (_ValidateSampleStock == false)
                    {
                        // Start: Logic to reverse the logic of renumbering if exception occurs.
                        if (addStepFlag != "Modify")
                        {
                            if (DataTableClientMedicationInstructions.Rows.Count > 0)
                            {
                                if (DataTableClientMedicationInstructions.Compute("Max(TitrationStepNumber)", "ISNULL(RecordDeleted,'N')<>'Y'").ToString() != "")
                                    _maxStepCount = Convert.ToInt32(DataTableClientMedicationInstructions.Compute("Max(TitrationStepNumber)", "ISNULL(RecordDeleted,'N')<>'Y'"));
                            }
                            for (int _rowCount = objClientMedicationInstructions[0].TitrationStep + 1; _rowCount <= _maxStepCount; _rowCount++)
                            {
                                DataRow[] _dataRowInstructions = DataTableClientMedicationInstructions.Select("TitrationStepNumber=" + _rowCount + " and ISNULL(RecordDeleted,'N')<>'Y'");
                                foreach (DataRow dr in _dataRowInstructions)
                                {
                                    dr["TitrationStepNumber"] = _rowCount - 1;
                                }
                            }
                        }
                    }

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
                        if (DataTableClientMedicationInstructions.Rows.Count > 0)
                        {
                            int tempcount = 0;
                            Int32 tempCountFromDataSetClientMedications = 0;
                            if (Session["DataSetPrescribedClientMedications"] != null && _FlagMaxInstructionIdSelectedFromPrescribedPage == false)
                            {
                                DataSetPrescibedMedications = new DataSet();
                                DataSetPrescibedMedications = (DataSet)Session["DataSetPrescribedClientMedications"];
                                if (DataSetPrescibedMedications.Tables["ClientMedicationInstructions"].Rows.Count > 0)
                                    tempcount = GetMinValue(Convert.ToInt32(DataSetPrescibedMedications.Tables["ClientMedicationInstructions"].Compute("Min(ClientMedicationInstructionId)", "")));

                                if (DataTableClientMedicationInstructions.Rows.Count > 0)
                                    tempCountFromDataSetClientMedications = GetMinValue(Convert.ToInt32(DataTableClientMedicationInstructions.Compute("Min(ClientMedicationInstructionId)", "")));

                                if (tempcount > tempCountFromDataSetClientMedications)
                                {
                                    tempcount = tempCountFromDataSetClientMedications;
                                }

                                _FlagMaxInstructionIdSelectedFromPrescribedPage = true;
                            }
                            else
                            {
                                if (DataTableClientMedicationInstructions.Rows.Count > 0)
                                    tempcount = GetMinValue(Convert.ToInt32(DataTableClientMedicationInstructions.Compute("Min(ClientMedicationInstructionId)", "")));
                            }
                            DataRowClientMedInstructions["ClientMedicationInstructionId"] = tempcount;
                        }
                        newRowCMI = true;
                    }
                    //Added for generat unique Instruction ID for new dataset with comparing the original dataset because we have to merge it with original dataset
                    if (DataTableClientMedicationInstructions.Rows.Count > 0)
                    {
                        if (newRowCMI == true)
                            DataRowClientMedInstructions["ClientMedicationInstructionId"] =
                                GetMinValue(Convert.ToInt32(DataTableClientMedicationInstructions.Compute("Min(ClientMedicationInstructionId)", "")));
                    }
                    else
                    {
                        DataRowClientMedInstructions["ClientMedicationInstructionId"] = iMaxClientMedicationInstructionId;
                    }
                    DataRowClientMedInstructions["ClientMedicationId"] = DataTableClientMedications.Rows[0]["ClientMedicationId"];
                    DataRowClientMedInstructions["StrengthId"] = row.StrengthId;
                    DataRowClientMedInstructions["Quantity"] = row.Quantity;
                    DataRowClientMedInstructions["Unit"] = row.Unit;
                    DataRowClientMedInstructions["Schedule"] = row.Schedule;
                    DataRowClientMedInstructions["Active"] = "Y"; // WITH REF TO TASK # 182
                    if (newRowCMI == true)
                        DataRowClientMedInstructions["RowIdentifier"] = System.Guid.NewGuid();
                    if (newRowCMI == true)
                        DataRowClientMedInstructions["CreatedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                    if (newRowCMI == true)
                        DataRowClientMedInstructions["CreatedDate"] = DateTime.Now;
                    DataRowClientMedInstructions["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                    DataRowClientMedInstructions["ModifiedDate"] = DateTime.Now;
                    DataRowClientMedInstructions["Instruction"] = row.Instruction;
                    DataRowClientMedInstructions["StartDate"] = row.StartDate;
                    DataRowClientMedInstructions["Refills"] = row.Refills;
                    //added By Priya Ref:task no:2985
                    Streamline.SmartClient.WebServices.CommonService objectCommonService = null;
                    objectCommonService = new Streamline.SmartClient.WebServices.CommonService();
                    //Modified in ref to Task#3090
                    //string EndDate = objectCommonService.CalculateTitrationEndDate(row.StartDate, row.Days, 0);
                    string EndDate = objectCommonService.CalculateTitrationEndDate(row.StartDate, row.Days, row.Refills);
                    if (row.EndDate == "")
                    {
                        DataRowClientMedInstructions["EndDate"] = EndDate;

                    }
                    else
                        DataRowClientMedInstructions["EndDate"] = row.EndDate;
                    //end
                    DataRowClientMedInstructions["TitrationStepNumber"] = row.TitrationStep;
                    DataRowClientMedInstructions["Days"] = row.Days;
                    DataRowClientMedInstructions["Pharmacy"] = row.Pharmacy;
                    //Added in ref to Task#2802
                    DataRowClientMedInstructions["PharmacyText"] = row.PharmaText;
                    DataRowClientMedInstructions["AutoCalcallow"] = row.AutoCalcallow;
                    DataRowClientMedInstructions["Sample"] = row.Sample;
                    DataRowClientMedInstructions["Stock"] = row.Stock;
                    DataRowClientMedInstructions["TitrateSummary"] = row.TitrateSummary;
                    DataRowClientMedInstructions["DayNumber"] = CalculateDayNumber(_firstStepDate, Convert.ToDateTime(row.StartDate));
                    DataRowClientMedInstructions["PotencyUnitCode"] = row.PotencyUnitCode;
                    if (newRowCMI == true)
                        DataTableClientMedicationInstructions.Rows.Add(DataRowClientMedInstructions);

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
                            if (Session["DataSetPrescribedClientMedications"] != null && _FlagMaxScriptDrugIdSelectedFromPrescribedPage == false)
                            {
                                DataSetPrescibedMedications = new DataSet();
                                DataSetPrescibedMedications = (DataSet)Session["DataSetPrescribedClientMedications"];
                                tempcount = Convert.ToInt32(DataSetPrescibedMedications.Tables["ClientMedicationScriptDrugs"].Rows[DataSetPrescibedMedications.Tables["ClientMedicationScriptDrugs"].Rows.Count - 1]["ClientMedicationScriptDrugId"].ToString());
                                if (tempcount < Convert.ToInt32(DataTableClientMedicationScriptDrugs.Rows[DataTableClientMedicationScriptDrugs.Rows.Count - 1]["ClientMedicationScriptDrugId"]))
                                {
                                    tempcount = Convert.ToInt32(DataTableClientMedicationScriptDrugs.Rows[DataTableClientMedicationScriptDrugs.Rows.Count - 1]["ClientMedicationScriptDrugId"]);
                                }
                                _FlagMaxScriptDrugIdSelectedFromPrescribedPage = true;
                            }
                            else
                            {
                                tempcount = Convert.ToInt32(DataTableClientMedicationScriptDrugs.Rows[DataTableClientMedicationScriptDrugs.Rows.Count - 1]["ClientMedicationScriptDrugId"]);
                            }
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
                            if (Session["DataSetPrescribedClientMedications"] != null &&
                                _FlagMaxScriptDrugIdSelectedFromPrescribedPage == false)
                            {
                                DataSetPrescibedMedications = new DataSet();
                                DataSetPrescibedMedications = (DataSet)Session["DataSetPrescribedClientMedications"];
                                tempcount =
                                    Convert.ToInt32(
                                        DataSetPrescibedMedications.Tables["ClientMedicationScriptDrugStrengths"].Rows[
                                            DataSetPrescibedMedications.Tables["ClientMedicationScriptDrugStrengths"]
                                                .Rows.Count - 1]["ClientMedicationScriptDrugStrengthId"].ToString());
                                if (tempcount <
                                    Convert.ToInt32(
                                        DataTableClientMedicationScriptDrugStrengths.Rows[
                                            DataTableClientMedicationScriptDrugStrengths.Rows.Count - 1][
                                                "ClientMedicationScriptDrugStrengthId"]))
                                {
                                    tempcount =
                                        Convert.ToInt32(
                                            DataTableClientMedicationScriptDrugStrengths.Rows[
                                                DataTableClientMedicationScriptDrugStrengths.Rows.Count - 1][
                                                    "ClientMedicationScriptDrugStrengthId"]);
                                }
                                _FlagMaxScriptDrugIdSelectedFromPrescribedPage = true;
                            }
                            else
                            {
                                tempcount =
                                    Convert.ToInt32(
                                        DataTableClientMedicationScriptDrugStrengths.Rows[
                                            DataTableClientMedicationScriptDrugStrengths.Rows.Count - 1][
                                                "ClientMedicationScriptDrugStrengthId"]);
                            }

                            DataRowClientMedicationScriptDrugStrengths["ClientMedicationScriptDrugStrengthId"] =
                                tempcount - 1;
                        }
                        else
                        {
                            DataRowClientMedicationScriptDrugStrengths["ClientMedicationScriptDrugStrengthId"] =
                                iMaxClientMedicationScriptDrugStrengthId;
                        }
                        newRowCMSDS = true;
                    }
                    //Added for generat unique Instruction ID for new dataset with comparing the original dataset because we have to merge it with original dataset

                    if (DataTableClientMedicationScriptDrugs.Rows.Count > 0)
                    {
                        int tempcount = 0;
                        tempcount = Convert.ToInt32(
                            DataTableClientMedicationScriptDrugs.Rows[DataTableClientMedicationScriptDrugs.Rows.Count - 1]["ClientMedicationScriptDrugId"]);
                        if (newRowCMSD == true)
                            DataRowClientMedicationScriptDrugs["ClientMedicationScriptDrugId"] = tempcount - 1;
                    }
                    else
                    {
                        DataRowClientMedicationScriptDrugs["ClientMedicationScriptDrugId"] = iMaxClientMedicationScriptDrugId;
                    }
                    DataRowClientMedicationScriptDrugs["ClientMedicationScriptId"] = _dataSetTitration.Tables["ClientMedicationScripts"].Rows[0]["ClientMedicationScriptId"];
                    DataRowClientMedicationScriptDrugs["ClientMedicationInstructionId"] = DataRowClientMedInstructions["ClientMedicationInstructionId"];
                    DataRowClientMedicationScriptDrugs["StartDate"] = row.StartDate;
                    DataRowClientMedicationScriptDrugs["Days"] = row.Days;
                    DataRowClientMedicationScriptDrugs["Pharmacy"] = row.Pharmacy;
                    //Added in ref to Task#2802
                    DataRowClientMedicationScriptDrugs["PharmacyText"] = row.PharmaText;
                    DataRowClientMedicationScriptDrugs["AutoCalcallow"] = row.AutoCalcallow;
                    DataRowClientMedicationScriptDrugs["Sample"] = row.Sample;
                    DataRowClientMedicationScriptDrugs["Stock"] = row.Stock;
                    DataRowClientMedicationScriptDrugs["Refills"] = row.Refills;
                    //added By Priya Ref:Task No:2985
                    if (row.EndDate == "")
                    {
                        DataRowClientMedicationScriptDrugs["EndDate"] = EndDate;
                    }
                    else
                        DataRowClientMedicationScriptDrugs["EndDate"] = row.EndDate;
                    if (category != null && category != String.Empty && category != " ")
                        DataRowClientMedicationScriptDrugs["DrugCategory"] = category;
                    if (Convert.ToDateTime(DataRowClientMedicationScriptDrugs["EndDate"]) < Convert.ToDateTime(DataRowClientMedicationScriptDrugs["StartDate"]))
                    {
                        DataRowClientMedication["MedicationStartDate"] = Convert.ToDateTime(_MedicationStartDate);
                        DataRowClientMedication["MedicationEndDate"] = Convert.ToDateTime(_MedicationEndDate);
                        throw new Exception("End Date should be greater than Start Date");
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
                    NextDate = objectCommonService.CalculateStartDate(EndDate);

                    //Added By anuj on 15feb,2010
                    DataRowClientMedicationScriptDrugStrengths["ClientMedicationScriptId"] = _dataSetTitration.Tables["ClientMedicationScripts"].Rows[0]["ClientMedicationScriptId"];
                    DataRowClientMedicationScriptDrugStrengths["Pharmacy"] = row.Pharmacy;
                    DataRowClientMedicationScriptDrugStrengths["PharmacyText"] = row.PharmaText;
                    DataRowClientMedicationScriptDrugStrengths["Sample"] = row.Sample;
                    DataRowClientMedicationScriptDrugStrengths["Stock"] = row.Stock;
                    DataRowClientMedicationScriptDrugStrengths["StrengthId"] = row.StrengthId;
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
                    //Added in ref to Task#85 - SDI - FY 10 - Venture
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
                    //Code ends over here.
                }

                if (DataTableClientMedicationInstructions.Columns.Contains("TempRecordDeleted"))
                {
                    foreach (DataRow drDeletedRows in DataTableClientMedicationInstructions.Select("TempRecordDeleted='Y'"))
                    {
                        drDeletedRows["RecordDeleted"] = "Y";
                        drDeletedRows["DeletedDate"] = Convert.ToDateTime(DateTime.Now.ToShortDateString());
                        drDeletedRows["DeletedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;

                    }
                }

                //Code added by Loveena in ref to Task#3091
                foreach (DataRow drMedicationInstructions in DataTableClientMedicationInstructions.Select("RecordDeleted='Y'"))
                {
                    DataRow[] dr = DataTableClientMedicationScriptDrugs.Select("ClientMedicationInstructionId=" + drMedicationInstructions["ClientMedicationInstructionId"]);
                    if (dr.Length > 0)
                    {
                        dr[0]["RecordDeleted"] = "Y";
                        dr[0]["DeletedDate"] = Convert.ToDateTime(DateTime.Now.ToShortDateString());
                        dr[0]["DeletedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                    }
                }
                //Prescribers of all Medications needs to be same as of current medications in case its not same as of current Medication being saved
                Int32 _MinPrescriberId = Convert.ToInt32(DataTableClientMedications.Compute("MIN(PrescriberId)", "ISNULL(RecordDeleted,'N')<>'Y'"));
                Int32 _MaxPrescriberId = Convert.ToInt32(DataTableClientMedications.Compute("Max(PrescriberId)", "ISNULL(RecordDeleted,'N')<>'Y'"));
                if (_MinPrescriberId != _MaxPrescriberId)
                {
                    foreach (DataRow drClientMedicationRow in DataTableClientMedications.Select("ISNULL(RecordDeleted,'N')<>'Y'"))
                    {
                        drClientMedicationRow["PrescriberId"] = DataRowClientMedication["PrescriberId"];
                        drClientMedicationRow["PrescriberName"] = DataRowClientMedication["PrescriberName"];
                    }
                }
                Session["DataSetTitration"] = _dataSetTitration;
                Session["IsDirty"] = true;
                //getDrugInteractionForTitration(_dataSetTitration);
                return NextDate;
            }
            catch (Exception ex)
            {
                if (Session["SessionTimeOut"] == null)
                    return "Session Expired";
                else
                    return ex.Message;
            }
            finally
            {
                _dataSetTitrationTemp = null;
            }
        }

        /// <summary>
        /// <description>To delete the titration step.</description>
        /// <author>Ankesh Bharti</author>
        /// <createdDate>27/12/2008</createdDate>
        /// <aceTask#>75</aceTask#>
        /// </summary>
        /// <param name="selectedMedicationId"></param>
        /// <returns></returns>
        [WebMethod(EnableSession = true)]
        public bool DeleteTitrationStep(int selectedMedicationId, int titrationStepNumber)
        {
            bool _tempflag = false;
            try
            {
                Streamline.UserBusinessServices.DataSets.DataSetClientMedications _dataSetTitration = null;
                DataTable _DataTableClientMedication = null;
                DataTable _DataTableClientMedicationInstructions = null;
                DataTable _DataTableClientMedicationScriptDrugs = null;
                if (Session["DataSetTitration"] != null)
                    _dataSetTitration = (Streamline.UserBusinessServices.DataSets.DataSetClientMedications)Session["DataSetTitration"];
                else
                    _dataSetTitration = new Streamline.UserBusinessServices.DataSets.DataSetClientMedications();
                _DataTableClientMedication = _dataSetTitration.ClientMedications;
                _DataTableClientMedicationInstructions = _dataSetTitration.ClientMedicationInstructions;
                _DataTableClientMedicationScriptDrugs = _dataSetTitration.ClientMedicationScriptDrugs;
                DataRow[] drClientMedicationInstruction = _DataTableClientMedicationInstructions.Select("TitrationStepNumber=" + titrationStepNumber + "and ISNULL(RecordDeleted,'N')<>'Y'");
                if (drClientMedicationInstruction.Length > 0)
                {
                    for (int i = 0; i < drClientMedicationInstruction.Length; i++)
                    {
                        if (drClientMedicationInstruction[i]["DBdata"].ToString() != "Y")
                        {
                            drClientMedicationInstruction[i].Delete();
                            _tempflag = true;
                        }
                        else
                        {
                            drClientMedicationInstruction[i]["RecordDeleted"] = "Y";
                            drClientMedicationInstruction[i]["DeletedDate"] = Convert.ToDateTime(DateTime.Now.ToShortDateString());
                            drClientMedicationInstruction[i]["DeletedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                            _tempflag = true;

                            DataRow[] drClientMedicationScriptDrugs = _DataTableClientMedicationScriptDrugs.Select("ClientMedicationInstructionId=" + drClientMedicationInstruction[i]["ClientMedicationInstructionId"]);
                            for (int j = 0; j < drClientMedicationScriptDrugs.Length; j++)
                            {
                                drClientMedicationScriptDrugs[j]["RecordDeleted"] = "Y";
                                drClientMedicationScriptDrugs[j]["DeletedDate"] = Convert.ToDateTime(DateTime.Now.ToShortDateString());
                                drClientMedicationScriptDrugs[j]["DeletedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode; ;
                            }
                        }
                        #region Logic for renumbering on click of delete for titration step.
                        int _maxStepCount = 0;
                        if (_DataTableClientMedicationInstructions.Rows.Count > 0)
                        {
                            if ((_DataTableClientMedicationInstructions.Compute("Max(TitrationStepNumber)", "ISNULL(RecordDeleted,'N')<>'Y'")).ToString() != "")
                                _maxStepCount = Convert.ToInt32(_DataTableClientMedicationInstructions.Compute("Max(TitrationStepNumber)", "ISNULL(RecordDeleted,'N')<>'Y'"));
                        }
                        for (int _rowCount = (titrationStepNumber + 1); _rowCount <= _maxStepCount; _rowCount++)
                        {
                            DataRow[] _dataRowInstructions = _DataTableClientMedicationInstructions.Select("TitrationStepNumber=" + _rowCount + "and ISNULL(RecordDeleted,'N')<>'Y'");
                            foreach (DataRow dr in _dataRowInstructions)
                            {
                                dr["TitrationStepnumber"] = titrationStepNumber;
                            }
                            titrationStepNumber = titrationStepNumber + 1;
                        }
                        #endregion
                    }
                }

                //Start: Recalculating the DayNumber for every step on deleting the titration step.
                DataRow[] _drStepOneInstruction = _dataSetTitration.Tables["ClientMedicationInstructions"].Select("TitrationStepNumber=" + 1 + "and ISNULL(RecordDeleted,'N')<>'Y'");
                DateTime _firstStepDate = DateTime.Now;
                if (_drStepOneInstruction.Length > 0)
                    _firstStepDate = Convert.ToDateTime(_drStepOneInstruction[0]["StartDate"]);
                DataRow[] _dataRowAllInstructions = _dataSetTitration.Tables["ClientMedicationInstructions"].Select("ISNULL(RecordDeleted,'N')<>'Y'");
                foreach (DataRow _drInstruction in _dataRowAllInstructions)
                {
                    _drInstruction["DayNumber"] = CalculateDayNumber(_firstStepDate, Convert.ToDateTime(_drInstruction["StartDate"]));
                }
                //End: Recalculating the DayNumber for every step on deleting the titration step.

                Session["IsDirty"] = true;
                Session["DataSetTitration"] = _dataSetTitration;
                return _tempflag;
            }
            catch (Exception)
            {
                return false;
            }
        }

        /// <summary>
        /// Task # 75
        /// </summary>
        /// <param name="MedicationId"></param>
        /// <param name="MedicationInstructionId"></param>
        /// <returns></returns>
        [WebMethod(EnableSession = true)]
        public bool DeleteTitrateInstructions(int MedicationId, int MedicationInstructionId)
        {
            bool tempflag = false;
            try
            {
                Streamline.UserBusinessServices.DataSets.DataSetClientMedications _dataSetTitration = null;
                DataTable _DataTableClientMedicationInstructions = null;

                if (Session["DataSetTitration"] != null)
                    _dataSetTitration = (Streamline.UserBusinessServices.DataSets.DataSetClientMedications)Session["DataSetTitration"];
                else
                    _dataSetTitration = new Streamline.UserBusinessServices.DataSets.DataSetClientMedications();

                _DataTableClientMedicationInstructions = _dataSetTitration.ClientMedicationInstructions;

                DataRow[] drClientMedicationInstruction = _DataTableClientMedicationInstructions.Select("ClientMedicationId=" + MedicationId + " and ClientMedicationInstructionId=" + MedicationInstructionId);
                if (drClientMedicationInstruction.Length > 0)
                {
                    drClientMedicationInstruction[0]["TempRecordDeleted"] = "Y";
                    tempflag = true;
                }
                return tempflag;
                Session["DataSetTitration"] = _dataSetTitration;
            }
            catch (Exception)
            {
                return false;
            }
        }

        /// <summary>
        /// Added by Chandan for StepNumbers in Titration page
        /// </summary>
        /// <param name="FillStepNumbers"></param>
        /// <returns></returns>
        [WebMethod(EnableSession = true)]
        public ArrayList FillStepNumbers()
        {
            DataSet _dataSetTitration = null;
            ArrayList _arrylistSteps = new ArrayList();
            int iMaxStepId = 0;
            string _strSteps = "";
            try
            {
                if (Session["DataSetTitration"] != null)
                    _dataSetTitration = (Streamline.UserBusinessServices.DataSets.DataSetClientMedications)Session["DataSetTitration"];
                else
                    _dataSetTitration = new Streamline.UserBusinessServices.DataSets.DataSetClientMedications();
                if (_dataSetTitration.Tables["ClientMedicationInstructions"].Rows.Count > 0)
                {
                    if (_dataSetTitration.Tables["ClientMedicationInstructions"].Compute("Max(TitrationStepNumber)", "ISNULL(RecordDeleted,'N')<>'Y'").ToString() != "")
                        iMaxStepId = Convert.ToInt32(_dataSetTitration.Tables["ClientMedicationInstructions"].Compute("Max(TitrationStepNumber)", "ISNULL(RecordDeleted,'N')<>'Y'")) + 1;
                    for (int i = 1; i <= iMaxStepId; i++)
                    {
                        _strSteps += i + ",";
                    }
                    _strSteps = _strSteps.TrimEnd(',');
                    _arrylistSteps = ApplicationCommonFunctions.StringSplit(_strSteps, ",");
                }
                else
                {
                    _arrylistSteps = ApplicationCommonFunctions.StringSplit("1", ",");
                }
                if (_arrylistSteps.Count <= 0)
                    _arrylistSteps = ApplicationCommonFunctions.StringSplit("1", ",");
                return _arrylistSteps;
            }
            catch (Exception ex)
            {
                return null;
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "";
                else
                    ex.Data["CustomExceptionInformation"] = "";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = "";
            }
            finally
            {
            }
        }

        /// <summary>
        /// Added by Chandan for StepNumbers in Titration page
        /// </summary>
        /// <param name="FillStepNumbers"></param>
        /// <returns></returns>
        [WebMethod(EnableSession = true)]
        public System.Web.UI.Triplet TitrationSummary()
        {
            DataSet _dataSetTitration = null;
            System.Web.UI.Triplet pairResult = new Triplet();
            string OldStrengthId = "";
            string NewStrengthId = "";
            double ToatlPharm = 0;
            string OrderSummary = "";
            int row = 0;
            int iMaxStepId = 0;
            string _strTableHtml = "";
            ArrayList _arrylistOrderSummary = new ArrayList();
            ArrayList _arrayListStartEndDate = new ArrayList();
            DataView _dvClientMedicationInstructions = null;
            try
            {
                if (Session["DataSetTitration"] != null)
                    _dataSetTitration = (Streamline.UserBusinessServices.DataSets.DataSetClientMedications)Session["DataSetTitration"];
                else
                    _dataSetTitration = new Streamline.UserBusinessServices.DataSets.DataSetClientMedications();

                if (_dataSetTitration != null)
                {
                    if (_dataSetTitration.Tables["ClientMedicationInstructions"].Rows.Count > 0)
                    {
                        //For StartDate calculation and End date Calculation
                        if (_dataSetTitration.Tables["ClientMedicationInstructions"].Compute("Min(StartDate)", "ISNULL(RecordDeleted,'N')<>'Y'").ToString() != "")
                            _arrayListStartEndDate.Add(Convert.ToDateTime(_dataSetTitration.Tables["ClientMedicationInstructions"].Compute("Min(StartDate)", "ISNULL(RecordDeleted,'N')<>'Y'")).ToString("MM/dd/yyyy"));
                        if (_dataSetTitration.Tables["ClientMedicationInstructions"].Compute("Max(EndDate)", "ISNULL(RecordDeleted,'N')<>'Y'").ToString() != "")
                            _arrayListStartEndDate.Add(Convert.ToDateTime(_dataSetTitration.Tables["ClientMedicationInstructions"].Compute("Max(EndDate)", "ISNULL(RecordDeleted,'N')<>'Y'")).ToString("MM/dd/yyyy"));
                        //For Step Number
                        if (_dataSetTitration.Tables["ClientMedicationInstructions"].Compute("Max(TitrationStepNumber)", "ISNULL(RecordDeleted,'N')<>'Y'").ToString() != "")
                            iMaxStepId = Convert.ToInt32(_dataSetTitration.Tables["ClientMedicationInstructions"].Compute("Max(TitrationStepNumber)", "ISNULL(RecordDeleted,'N')<>'Y'"));
                        _dvClientMedicationInstructions = new DataView(_dataSetTitration.Tables["ClientMedicationInstructions"]);
                        _dvClientMedicationInstructions.Sort = "StrengthId desc,unit desc";
                        _dvClientMedicationInstructions.RowFilter = "(ISNULL(RecordDeleted,'N')<>'Y')";
                        for (row = 0; row < _dvClientMedicationInstructions.Count; row++)
                        {
                            if (_dvClientMedicationInstructions[row]["StrengthId"].ToString() != "")
                                NewStrengthId = (_dvClientMedicationInstructions[row]["StrengthId"].ToString() + _dvClientMedicationInstructions[row]["Unit"].ToString());
                            if (NewStrengthId != OldStrengthId)
                            {
                                if (OldStrengthId != "")
                                {
                                    if (_dvClientMedicationInstructions[row - 1]["TitrateSummary"].ToString() != "")
                                        OrderSummary = _dvClientMedicationInstructions[row - 1]["TitrateSummary"].ToString() + " x " + ToatlPharm;
                                    else
                                        OrderSummary = _dvClientMedicationInstructions[row - 1]["Instruction"].ToString().Substring(0, _dvClientMedicationInstructions[row - 1]["Instruction"].ToString().IndexOf(_dvClientMedicationInstructions[row - 1]["quantity"].ToString())) + " x " + ToatlPharm;

                                    _arrylistOrderSummary.Add(OrderSummary);
                                    OrderSummary = "";
                                    ToatlPharm = 0;
                                    OldStrengthId = NewStrengthId;
                                }

                                if (_dvClientMedicationInstructions[row]["Pharmacy"].ToString() != "")
                                    ToatlPharm += Convert.ToDouble(_dvClientMedicationInstructions[row]["Pharmacy"].ToString());
                                else
                                    ToatlPharm += 0;
                                if (_dvClientMedicationInstructions[row]["TitrateSummary"].ToString() != "")
                                {
                                    OrderSummary = _dvClientMedicationInstructions[row]["TitrateSummary"].ToString() + " x " + ToatlPharm;
                                }
                                else
                                {
                                    OrderSummary = _dvClientMedicationInstructions[row]["Instruction"].ToString().Substring(0, _dvClientMedicationInstructions[row]["Instruction"].ToString().IndexOf(_dvClientMedicationInstructions[row]["quantity"].ToString())) + " x " + ToatlPharm; // _dvClientMedicationInstructions[row]["TitrateSummary"].ToString() + " x " + ToatlPharm;
                                }
                                OldStrengthId = NewStrengthId;
                            }
                            else
                            {
                                if (_dvClientMedicationInstructions[row]["Pharmacy"].ToString() != "")
                                    ToatlPharm += Convert.ToDouble(_dvClientMedicationInstructions[row]["Pharmacy"].ToString());
                                else
                                    ToatlPharm += 0;
                                OldStrengthId = NewStrengthId;
                            }
                        }
                        if (row > 0)
                        {
                            if (_dvClientMedicationInstructions[row - 1]["TitrateSummary"].ToString() != "")
                                OrderSummary = _dvClientMedicationInstructions[row - 1]["TitrateSummary"].ToString() + " x " + ToatlPharm;
                            else
                                OrderSummary = _dvClientMedicationInstructions[row - 1]["Instruction"].ToString().Substring(0, _dvClientMedicationInstructions[row - 1]["Instruction"].ToString().IndexOf(_dvClientMedicationInstructions[row - 1]["quantity"].ToString())) + " x " + ToatlPharm;
                        }
                        _arrylistOrderSummary.Add(OrderSummary);
                        OrderSummary = "";
                        ToatlPharm = 0;
                    }
                }
                //Create table for Order Summary
                Table _tableOrderSummary = new Table();
                _tableOrderSummary.ID = "TableOrderSummary";
                for (int rowIndex = 0; rowIndex < _arrylistOrderSummary.Count; rowIndex++)
                {
                    TableRow _TableRow = new TableRow();
                    _TableRow.ID = "TableOrderSummaryRow" + rowIndex;
                    TableCell _TableCell0 = new TableCell();
                    Label _labelOredrSummary = new Label();
                    _labelOredrSummary.ID = "LabelOredrSummary" + rowIndex;
                    _labelOredrSummary.Width = 500;
                    _labelOredrSummary.Text = _arrylistOrderSummary[rowIndex].ToString();
                    _labelOredrSummary.Attributes.Add("class", "SumarryLabel");
                    _TableCell0.Controls.Add(_labelOredrSummary);
                    _TableRow.Controls.Add(_TableCell0);
                    _tableOrderSummary.Rows.Add(_TableRow);
                }
                StringBuilder sb = new StringBuilder();
                using (StringWriter sw = new StringWriter(sb))
                {
                    using (HtmlTextWriter textWriter = new HtmlTextWriter(sw))
                    {
                        _tableOrderSummary.RenderControl(textWriter);
                    }
                }
                _strTableHtml = sb.ToString();

                pairResult.First = _strTableHtml;
                pairResult.Second = _arrayListStartEndDate;
                pairResult.Third = iMaxStepId;
                return pairResult;
            }
            catch (Exception ex)
            {
                return null;
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "";
                else
                    ex.Data["CustomExceptionInformation"] = "";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = "";
            }
            finally
            {
            }
        }

        /// <summary>
        /// <description>To calculate the day number for to show against each titration step.</description>
        /// <author>Ankesh Bharti</author>
        /// <createdDate>12-Jan-2009</createdDate>
        /// </summary>
        /// <param name="firstStepDate"></param>
        /// <param name="currentStepDate"></param>
        /// <returns></returns>
        [WebMethod(EnableSession = true)]
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
        /// Added by Chandan for merging DataSetTitration to main dataset.
        /// </summary>
        /// <param name="objTitrateMedication"></param>
        /// <returns></returns>
        [WebMethod(EnableSession = true)]
        public string UpdateTitration(ClientMedicationRow objTitrateMedication, int refills)
        {
            DataSet _dataSetTitration = new DataSet();
            DataSet _dataSetMedication = new DataSet();
            int MedicationId = 0;
            DateTime _minRXStartDate = Convert.ToDateTime(null);
            DateTime _maxRXEndDate = Convert.ToDateTime(null);

            try
            {
                if (Session["DataSetTitration"] != null)
                {
                    _dataSetTitration = (Streamline.UserBusinessServices.DataSets.DataSetClientMedications)Session["DataSetTitration"];
                    if (_dataSetTitration.Tables["ClientMedicationInstructions"].Rows.Count > 0)
                    {
                        DataRow[] _dataRowClientMedicationInstructions = _dataSetTitration.Tables["ClientMedicationInstructions"].Select("ISNULL(RecordDeleted,'N')<>'Y'");
                        DataRow[] _dataRowClientMedicationScriptDrugs = _dataSetTitration.Tables["ClientMedicationScriptDrugs"].Select("ISNULL(RecordDeleted,'N')<>'Y'");
                        if (_dataRowClientMedicationInstructions.Length <= 0)
                        {
                            throw new Exception("Please add atleast one titration step.");//return "false";
                        }
                        else
                        {
                            //Start:Code added by Ankesh Bharti on 02/10/2009 in Ref To Task# 2385
                            foreach (DataRow _drInstructions in _dataRowClientMedicationInstructions)
                            {
                                if (Convert.ToInt32(_drInstructions["DayNumber"]) < 0)
                                    throw new Exception("One or more start dates are out of sequence. Please correct before saving.");
                            }
                            //End:Code added by Ankesh Bharti on 02/10/2009 in Ref To Task# 2385
                        }

                        //if (_dataRowClientMedicationScriptDrugs.Length > 0)
                        //{
                        //    foreach (DataRow _dataRowScriptDrugs in _dataRowClientMedicationScriptDrugs)
                        //    {
                        //        _dataRowScriptDrugs["Refills"] = refills;
                        //    }
                        //}
                        DataRow[] _dataRowClientMedication = _dataSetTitration.Tables["ClientMedications"].Select("ISNULL(RecordDeleted,'N')<>'Y'");
                        if (_dataRowClientMedication.Length > 0)
                        {
                            //Start:Code added by Ankesh Bharti on 02/09/2009 in Ref To Task# 2380
                            _minRXStartDate = Convert.ToDateTime(_dataSetTitration.Tables["ClientMedicationInstructions"].Compute("Min(StartDate)", "ISNULL(RecordDeleted,'N')<>'Y'"));
                            _maxRXEndDate = Convert.ToDateTime(_dataSetTitration.Tables["ClientMedicationInstructions"].Compute("Max(EndDate)", "ISNULL(RecordDeleted,'N')<>'Y'"));
                            _dataRowClientMedication[0]["MedicationStartDate"] = _minRXStartDate;
                            TimeSpan _dateDifference = _maxRXEndDate.Subtract(_minRXStartDate);
                            _dataRowClientMedication[0]["MedicationEndDate"] = Convert.ToDateTime(_dataRowClientMedication[0]["MedicationStartDate"]).AddDays(_dateDifference.Days * (refills + 1));
                            //End:Code added by Ankesh Bharti on 02/09/2009 in Ref To Task# 2380

                            MedicationId = int.Parse(_dataRowClientMedication[0]["ClientMedicationId"].ToString());
                            if (objTitrateMedication.SpecialInstructions.Trim().ToString() == "")
                                _dataRowClientMedication[0]["SpecialInstructions"] = System.DBNull.Value;
                            else
                                _dataRowClientMedication[0]["SpecialInstructions"] = objTitrateMedication.SpecialInstructions;
                            _dataRowClientMedication[0]["DAW"] = objTitrateMedication.DAW;
                            _dataRowClientMedication[0]["TitrationType"] = objTitrateMedication.TitrationType;
                            _dataRowClientMedication[0]["PermitChangesByOtherUsers"] = objTitrateMedication.PermitChangesByOtherUsers;
                            if (Session["DataSetClientMedications"] != null)
                            {
                                _dataSetMedication = ((DataSet)Session["DataSetClientMedications"]);
                                DataRow[] drClientMedicationInstruction = _dataSetMedication.Tables["ClientMedicationInstructions"].Select(" ClientMedicationId = " + MedicationId + " AND ISNULL(RecordDeleted,'N')<>'Y' ");
                                if (drClientMedicationInstruction.Length > 0)
                                {
                                    for (int i = 0; i < drClientMedicationInstruction.Length; i++)
                                    {
                                        if (drClientMedicationInstruction[i]["DBdata"].ToString() != "Y")
                                        {
                                            drClientMedicationInstruction[i].Delete();
                                        }
                                    }
                                }
                                ((DataSet)Session["DataSetClientMedications"]).Merge(_dataSetTitration);
                            }
                            else
                                Session["DataSetClientMedications"] = _dataSetTitration;


                            getDrugInteraction((Streamline.UserBusinessServices.DataSets.DataSetClientMedications)Session["DataSetClientMedications"]);
                            Session["DataSetTitration"] = null;
                            return "true";
                        }
                        else
                            throw new Exception("Please add atleast one titration step.");//return "false";
                    }
                    else
                    {
                        throw new Exception("Please add atleast one titration step.");//return "false";
                    }
                }
                return "true";
            }
            catch (Exception ex)
            {
                //return "null";
                if (Session["SessionTimeOut"] == null)
                    return "Session Expired";
                else
                    return ex.Message;
            }
            finally
            {
                _dataSetTitration = null;
            }
        }

        /// <summary>
        /// Function added to clear the Temporary deleted rows flags when clearing the rows
        /// </summary>
        /// <returns></returns>
        [WebMethod(EnableSession = true)]
        public bool ClearTemporaryTitrationDeletedRowsFlags()
        {
            try
            {
                if (((DataSet)Session["DataSetTitration"]).Tables["ClientMedicationInstructions"].Rows.Count > 0)
                {
                    using (Streamline.UserBusinessServices.DataSets.DataSetClientMedications _dataSetTitration = (Streamline.UserBusinessServices.DataSets.DataSetClientMedications)Session["DataSetTitration"])
                    {
                        DataRow[] _drTemporaryDeletedRows = _dataSetTitration.ClientMedicationInstructions.Select("TempRecordDeleted='Y' AND ISNULL(RecordDeleted,'N')<>'Y'");
                        foreach (DataRow dr in _drTemporaryDeletedRows)
                        {
                            dr.BeginEdit();
                            dr["TempRecordDeleted"] = System.DBNull.Value;
                            dr.EndEdit();
                        }
                        Session["DataSetTitration"] = _dataSetTitration;
                    }
                }
                return true;
            }
            catch (Exception)
            {
                return false;
            }
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="sDate"></param>
        /// <param name="days"></param>
        /// <param name="refill"></param>
        /// <returns></returns>
        public string CalculateEndDate(string sDate, int days, Decimal refill)
        {
            try
            {
                //commented and added by Priya Ref:task no:2977 

                //    DateTime startDate = Convert.ToDateTime(sDate);
                //    DateTime endDate;
                //    endDate = startDate.AddDays(days * (Convert.ToInt32(refill) + 1));
                //    return endDate.ToString("MM/dd/yyyy");
                DateTime startDate = Convert.ToDateTime(sDate);
                DateTime endDate;
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
            catch (Exception)
            {
                return "";
            }
        }


        #endregion

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
                        ReportUrl = ReportUrl.Replace("<DiagnosisCode>", Convert.ToString(DiagnosisCode));
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

        [WebMethod(EnableSession = true)]
        //public System.Web.UI.Pair GenerateDiscontinueReasonDropDown()
        public DataTable GenerateDiscontinueReasonDropDown()
        {
            DataRow[] DataRowDiscontinueReason = Streamline.UserBusinessServices.SharedTables.DataSetGlobalCodes.Tables[0].Select("Category='MEDDISCONTINUEREASON' And ISNULL(RecordDeleted,'N')='N'");

            StringBuilder DropDownListDiscontinueReasonHTML = new StringBuilder();
            //System.Web.UI.Pair Pairresult = new Pair();
            DataTable Pairresult = new DataTable();
            Pairresult.Columns.Add("PairResult", typeof(int));
            Pairresult.Columns.Add("PairResultData", typeof(String));

            try
            {

                // DropDownListDiscontinueReasonHTML.Append("<select width='250px' name='dropdownDiscontinueReason' runat='server' id='dropdownDiscontinueReason' onchange='EnableDiscontinueButton();'>");
                DropDownListDiscontinueReasonHTML.Append("<option value='0'>.....Select Discontinue Reason.....</option>");
                if (DataRowDiscontinueReason.Length > 0)
                {
                    for (int RowIndex = 0; RowIndex < DataRowDiscontinueReason.Length; RowIndex++)
                    {
                        DropDownListDiscontinueReasonHTML.Append("<option value='" + DataRowDiscontinueReason[RowIndex]["GlobalCodeId"] + "'>" + DataRowDiscontinueReason[RowIndex]["CodeName"] + "</option>");
                    }
                }

                DataSet DataSetPharmacies = null;
                //DataSetPharmacies = Streamline.UserBusinessServices.SharedTables.DataSetPharmacies;

                Streamline.UserBusinessServices.SharedTables objectSharedTables = new Streamline.UserBusinessServices.SharedTables();
                DataSetPharmacies = objectSharedTables.getPharmacies(((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId);               
                DataRow[] drPreferredPharmacy3 = DataSetPharmacies.Tables[0].Select("SequenceNumber=3");

                DataRow[] DataRowPharmacies = DataSetPharmacies.Tables[0].Select("", "SequenceNumber asc");
                StringBuilder DropDownListPharmaciesHTML = new StringBuilder();

                // DropDownListDiscontinueReasonHTML.Append("<select width='250px' name='dropdownDiscontinueReason' runat='server' id='dropdownDiscontinueReason' onchange='EnableDiscontinueButton();'>");
                DropDownListPharmaciesHTML.Append("<option value='0'>........Select Pharmacy........</option>");
                if (DataRowPharmacies.Length > 0)
                {
                    for (int RowIndex = 0; RowIndex < DataRowPharmacies.Length; RowIndex++)
                    {
                        //Decoder( encodeForJavaScript( (inputString [,canonicalize])
                        DropDownListPharmaciesHTML.Append("<option value='" + DataRowPharmacies[RowIndex]["PharmacyId"] + "'>" + DataRowPharmacies[RowIndex]["PharmacyName"] + "</option>");
                    }
                }
                //Pairresult.First = DropDownListDiscontinueReasonHTML.ToString();
                DataRow dr1 = Pairresult.NewRow();
                dr1["PairResult"] = 1;
                dr1["PairResultData"] = DropDownListDiscontinueReasonHTML.ToString();
                Pairresult.Rows.Add(dr1);
                //Pairresult.Second = DropDownListPharmaciesHTML.ToString();
                DataRow dr2 = Pairresult.NewRow();
                dr2["PairResult"] = 2;
                dr2["PairResultData"] = DropDownListPharmaciesHTML.ToString();
                Pairresult.Rows.Add(dr2);

                bool DicontinueNone = (enableDisabled(Streamline.BaseLayer.Permissions.DiscontinueNone) == "Disabled");
                DataRow dr3 = Pairresult.NewRow();
                dr3["PairResult"] = 3;
                dr3["PairResultData"] = "<input type='radio' id='RadioButton_Print' value='P' onclick='SelectMethodNameForSystemReport(this)'; " + (DicontinueNone == true ? "checked='checked' " : "") + "name='SelectReport'><span class='RadioDiscontinue' style='vertical-align:middle;' >Print</span></input>" +
                    (DicontinueNone == true ? "<input type='radio' id='RadioButton_None' value='N' name='SelectReport' style='display:none;'>" : "<br/><input type='radio' id='RadioButton_None' value='N' onclick='SelectMethodNameForSystemReport(this)'; checked='checked' name='SelectReport'><span style='vertical-align:middle;' class='RadioDiscontinue'>None</span></input>");
                Pairresult.Rows.Add(dr3);               

                DataRow dr6 = Pairresult.NewRow();
                dr6["PairResult"] = 1003;
                dr6["PairResultData"] = drPreferredPharmacy3.Length > 0 ? Convert.ToString(drPreferredPharmacy3[0]["PharmacyName"]) : "";
                Pairresult.Rows.Add(dr6);
                // DropDownListDiscontinueReasonHTML.Append("</select>");
                return Pairresult;



            }

            catch (Exception ex)
            {
                return Pairresult;
            }
        }


        private byte[] GetSignatureImage(string ImageString)
        {
            SIGPLUSLib.SigPlus SigPlusObject = null;
            //SIGIDLib.SigID SigIDObject = null;

            try
            {
                SigPlusObject = new SIGPLUSLib.SigPlus();
                SigPlusObject.InitSigPlus();
                SigPlusObject.AutoKeyStart();
                //use the same data to decrypt signature
                //SigPlusObject.AutoKeyData = Convert.ToString(((SitePrinciple)HttpContext.Current.Session["UserContext"]).DataRowUser["Username"]);
                SigPlusObject.AutoKeyFinish();
                SigPlusObject.SigCompressionMode = 1;
                SigPlusObject.EncryptionMode = 2;
                SigPlusObject.SigString = ImageString;
                //Now, get sigstring from client
                //Sigstring can be stored in a database if 
                //a biometric signature is desired rather than an image
                if (SigPlusObject.NumberOfTabletPoints() > 0)
                {

                    SigPlusObject.ImageFileFormat = 0;
                    SigPlusObject.ImageXSize = 256;
                    SigPlusObject.ImageYSize = 128;
                    SigPlusObject.ImagePenWidth = 8;
                    SigPlusObject.SetAntiAliasParameters(1, 600, 700);
                    SigPlusObject.JustifyX = 5;
                    SigPlusObject.JustifyY = 5;
                    SigPlusObject.JustifyMode = 5;
                    Int64 size;
                    Byte[] byteValue;
                    SigPlusObject.BitMapBufferWrite();
                    size = SigPlusObject.BitMapBufferSize();
                    byteValue = new byte[size];
                    byteValue = (byte[])SigPlusObject.GetBitmapBufferBytes();
                    return byteValue;
                }


            }
            catch (Exception Ex)
            {
                throw Ex;
            }

            return null;
        }

        // Added by ponnin For task #215 of Engineering Improvement Initiatives- NBL(I)
        public string EncodeBase64(string data)
        {
            string str = data.Trim().Replace(" ", "+");
            if (str.Length % 4 > 0)
            {
                str = str.PadRight(str.Length + 4 - str.Length % 4, '=');
            }
            return str;
        }


        //Anuj Ref Ticket #2557
        [WebMethod(EnableSession = true)]
        public string UpdatePatientConsent1(string ObjValue, int IsCustomPage, bool RadioButtonMedicalStaff, bool RadioButtonPatient, bool RadioButtonRelation, string TextBoxSignatureName, int DropDownRelationShip, string eSignature, bool IsSignaturePad, string IsClientSignedPaper, string ClientMedicationConsentId, string sigString)
        {
            _sigString = sigString;
            return UpdatePatientConsent(ObjValue, IsCustomPage, RadioButtonMedicalStaff, RadioButtonPatient, RadioButtonRelation, TextBoxSignatureName, DropDownRelationShip, eSignature, IsSignaturePad, IsClientSignedPaper, ClientMedicationConsentId);

        }

        //Modified by anuj on 1 Dec,2009
        // public string UpdatePatientConsent(string ObjValue, int IsCustomPage, bool RadioButtonMedicalStaff, bool RadioButtonPatient, bool RadioButtonRelation, string TextBoxSignatureName, int DropDownRelationShip, string eSignature, bool IsSignaturePad, string IsClientSignedPaper)
        [WebMethod(EnableSession = true)]
        public string UpdatePatientConsent(string ObjValue, int IsCustomPage, bool RadioButtonMedicalStaff, bool RadioButtonPatient, bool RadioButtonRelation, string TextBoxSignatureName, int DropDownRelationShip, string eSignature, bool IsSignaturePad, string IsClientSignedPaper, string ClientMedicationConsentId)
        {



            DataSet DataSetClientMedications = null;
            DataSet _dsCustomDoc = null;
            Streamline.UserBusinessServices.DataSets.DataSetHarborConsent.DocumentsRow _drDocuments = null;
            Streamline.UserBusinessServices.DataSets.DataSetHarborConsent.DocumentVersionsRow _drDocumentVersions = null;
            Streamline.UserBusinessServices.DataSets.DataSetHarborConsent.DocumentSignaturesRow _drDocumentSignatures = null;
            Streamline.UserBusinessServices.DataSets.DataSetCustomDocuments _dsCustomDocuments = null;
            Streamline.UserBusinessServices.DataSets.DataSetHarborConsent _dsHarborConsent = null;
            Streamline.UserBusinessServices.ClientMedication objClientMedication = null;
            System.Text.ASCIIEncoding enc = new System.Text.ASCIIEncoding();
            byte[] eSignatureASCI = null;

            string _documentVersionId = string.Empty;
            DataSet dsTemp = null;
            try
            {
                // Added by ponnin For task #230 of Engineering Improvement Initiatives- NBL(I)
                if (IsSignaturePad == true)
                {
                    if (_sigString.StartsWith("SIGWEBINSTALLED"))
                    {
                        eSignatureASCI = Convert.FromBase64String(this.EncodeBase64(_sigString.Replace("SIGWEBINSTALLED", "")));
                    }
                    else
                    {
                        eSignatureASCI = GetSignatureImage(_sigString);
                    }
                }
                // End ConvertImageToByte

                objClientMedication = new ClientMedication();
                // _dsHarborConsent = new Streamline.UserBusinessServices.DataSets.DataSetHarborConsent();
                if (Session["StandardHarborConsent"] != null)
                {
                    _dsHarborConsent = (Streamline.UserBusinessServices.DataSets.DataSetHarborConsent)Session["StandardHarborConsent"];
                }
                else
                {
                    _dsHarborConsent = new Streamline.UserBusinessServices.DataSets.DataSetHarborConsent();
                }
                if (IsCustomPage == 0)
                {
                    _dsCustomDocuments = new Streamline.UserBusinessServices.DataSets.DataSetCustomDocuments();
                    if (RadioButtonMedicalStaff == true)
                    {
                        Session["DocumentVersionId"] = null;
                        //Documents
                        _drDocuments = (Streamline.UserBusinessServices.DataSets.DataSetHarborConsent.DocumentsRow)_dsHarborConsent.Documents.NewRow();
                        _drDocuments.AuthorId = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId;
                        _drDocuments.ClientId = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId;
                        _drDocuments.CreatedBy = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                        _drDocuments.CreatedDate = DateTime.Now;
                        _drDocuments.DocumentShared = "Y";
                        _drDocuments.EffectiveDate = Convert.ToDateTime(DateTime.Now.ToShortDateString());
                        _drDocuments.ModifiedBy = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                        _drDocuments.ModifiedDate = DateTime.Now;
                        _drDocuments.RowIdentifier = System.Guid.NewGuid();
                        _drDocuments.SignedByAll = "N";
                        _drDocuments.Status = 22;
                        if (RadioButtonMedicalStaff == true)
                        {
                            _drDocuments.SignedByAuthor = "Y";
                        }
                        else
                        {
                            _drDocuments.SignedByAuthor = "N";
                        }
                        _drDocuments.Status = 22;
                        _dsHarborConsent.Documents.Rows.Add(_drDocuments);
                        //DocumentVersion
                        _drDocumentVersions = (Streamline.UserBusinessServices.DataSets.DataSetHarborConsent.DocumentVersionsRow)_dsHarborConsent.DocumentVersions.NewRow();
                        _drDocumentVersions.CreatedBy = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                        _drDocumentVersions.CreatedDate = DateTime.Now;
                        _drDocumentVersions.ModifiedBy = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                        _drDocumentVersions.ModifiedDate = DateTime.Now;
                        _drDocumentVersions.DocumentId = _drDocuments.DocumentId;
                        _drDocumentVersions.EffectiveDate = DateTime.Now;
                        _drDocumentVersions.RowIdentifier = System.Guid.NewGuid();
                        _drDocumentVersions.Version = 1;
                        _dsHarborConsent.DocumentVersions.Rows.Add(_drDocumentVersions);

                        if (Session["DataSetClientMedications"] != null)
                        {
                            //ClientMedicationConsentDocuments
                            //Added By Anuj task ref #14 (SDI Projects FY10 - Venture)
                            Streamline.UserBusinessServices.DataSets.DataSetHarborConsent.ClientMedicationConsentsRow _drClientMedicationConsent = null;
                            DataSetClientMedications = (DataSet)Session["DataSetClientMedications"];
                            Streamline.UserBusinessServices.DataSets.DataSetHarborConsent.ClientMedicationConsentDocumentsRow _drClientMedicationConsentDocument = null;
                            _drClientMedicationConsentDocument = (Streamline.UserBusinessServices.DataSets.DataSetHarborConsent.ClientMedicationConsentDocumentsRow)_dsHarborConsent.ClientMedicationConsentDocuments.NewRow();
                            _drClientMedicationConsentDocument.CreatedBy = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                            _drClientMedicationConsentDocument.CreatedDate = DateTime.Now;
                            _drClientMedicationConsentDocument.ModifiedBy = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                            _drClientMedicationConsentDocument.ModifiedDate = DateTime.Now;
                            _drClientMedicationConsentDocument.RowIdentifier = System.Guid.NewGuid();
                            _drClientMedicationConsentDocument.DocumentVersionId = _drDocumentVersions.DocumentVersionId;
                            // _drClientMedicationConsentDocument.ConsentStartDate = Convert.ToDateTime(DateTime.Now.ToShortDateString());
                            _drClientMedicationConsentDocument.SignedByPrescriber = "Y";
                            _dsHarborConsent.ClientMedicationConsentDocuments.Rows.Add(_drClientMedicationConsentDocument);

                            //ClientMedicationConsent
                            foreach (DataRow drMedication in DataSetClientMedications.Tables["ClientMedications"].Rows)
                            {
                                //Commented as per the datamodel changes
                                //_drClientMedicationConsent = (Streamline.UserBusinessServices.DataSets.DataSetHarborConsent.ClientMedicationConsentsRow)_dsHarborConsent.ClientMedicationConsents.NewRow();
                                //Code ends over here.

                                //Modified by Anuj Tomar on 24 Oct,2009
                                //Conditions changed for task Ref.19 SDI Projects FY10 - Venture
                                if (Convert.ToString(drMedication["OffLabel"]) == "Y")
                                {
                                    DataRow[] _drClientMedicationId = DataSetClientMedications.Tables["ClientMedicationConsents"].Select("ClientMedicationId=" + Convert.ToInt32(drMedication["ClientMedicationId"]));

                                    //Added by Loveena in ref to Task#19 as per the datamodel changes of ClientMedicationId to ClientMedicationInstructionId
                                    DataRow[] _drClientMedicationInstructionId = DataSetClientMedications.Tables["ClientMedicationInstructions"].Select("ClientMedicationId=" + Convert.ToInt32(drMedication["ClientMedicationId"]));
                                    int iMaxClientMedicationConsentId = 0;
                                    for (short index = 0; index < _drClientMedicationInstructionId.Length; index++)
                                    {
                                        _drClientMedicationConsent = (Streamline.UserBusinessServices.DataSets.DataSetHarborConsent.ClientMedicationConsentsRow)_dsHarborConsent.ClientMedicationConsents.NewRow();
                                        if (_dsHarborConsent.ClientMedicationConsents.Rows.Count > 0)
                                        {
                                            iMaxClientMedicationConsentId = GetMinValue(Convert.ToInt32(_dsHarborConsent.ClientMedicationConsents.Compute("Min(ClientMedicationConsentId)", "")));
                                        }
                                        _drClientMedicationConsent.ClientMedicationConsentId = iMaxClientMedicationConsentId;
                                        _drClientMedicationConsent.ClientMedicationInstructionId = Convert.ToInt32(_drClientMedicationInstructionId[index]["ClientMedicationInstructionId"]);
                                        _drClientMedicationConsent.DocumentVersionId = _drClientMedicationConsentDocument.DocumentVersionId;
                                        _drClientMedicationConsent.CreatedBy = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                                        _drClientMedicationConsent.CreatedDate = DateTime.Now;
                                        _drClientMedicationConsent.ModifiedBy = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                                        _drClientMedicationConsent.ModifiedDate = DateTime.Now;
                                        _drClientMedicationConsent.RowIdentifier = System.Guid.NewGuid();
                                        _dsHarborConsent.ClientMedicationConsents.Rows.Add(_drClientMedicationConsent);
                                    }
                                }
                                else
                                {
                                    _drClientMedicationConsent = (Streamline.UserBusinessServices.DataSets.DataSetHarborConsent.ClientMedicationConsentsRow)_dsHarborConsent.ClientMedicationConsents.NewRow();
                                    _drClientMedicationConsent.MedicationNameId = Convert.ToInt32(drMedication["MedicationNameId"]);
                                    //_drClientMedicationConsent.ClientMedicationId = Convert.ToInt32(drMedication["ClientMedicationId"]);
                                    _drClientMedicationConsent.DocumentVersionId = _drClientMedicationConsentDocument.DocumentVersionId;
                                    _drClientMedicationConsent.CreatedBy = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                                    _drClientMedicationConsent.CreatedDate = DateTime.Now;
                                    _drClientMedicationConsent.ModifiedBy = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                                    _drClientMedicationConsent.ModifiedDate = DateTime.Now;
                                    _drClientMedicationConsent.RowIdentifier = System.Guid.NewGuid();
                                    _dsHarborConsent.ClientMedicationConsents.Rows.Add(_drClientMedicationConsent);
                                }
                            }
                        }
                        //DocumentSignatures
                        _drDocumentSignatures = (Streamline.UserBusinessServices.DataSets.DataSetHarborConsent.DocumentSignaturesRow)_dsHarborConsent.DocumentSignatures.NewRow();
                        _drDocumentSignatures.CreatedBy = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                        _drDocumentSignatures.CreatedDate = DateTime.Now;
                        _drDocumentSignatures.ModifiedBy = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                        _drDocumentSignatures.ModifiedDate = DateTime.Now;
                        _drDocumentSignatures.DocumentId = _drDocuments.DocumentId;
                        _drDocumentSignatures.RowIdentifier = System.Guid.NewGuid();
                        _drDocumentSignatures.SignatureDate = DateTime.Now;
                        _drDocumentSignatures.SignatureOrder = 1;
                        Session["SignatureOrder"] = null;
                        //Code added by Loveena in ref to Task#2563
                        Session["PatientAlreadySignedDocument"] = null;
                        Session["DataSetCustomDocuments"] = null;
                        Session["SignatureId"] = null;
                        //code ends over here.
                        Session["SignatureOrder"] = 1;
                        if (eSignature != "")
                        {
                            _drDocumentSignatures.PhysicalSignature = eSignatureASCI;
                            //Added by Loveena in ref to Task#2805 DocumentSignature: Verificationmode not updated
                            _drDocumentSignatures.VerificationMode = "S";
                        }
                        //Conditions added by Loveena in ref to Task#2805                       
                        else if (IsClientSignedPaper != "Y")
                            _drDocumentSignatures.VerificationMode = "P";
                        //Code ends over here.
                        //else
                        //    _drDocumentSignatures.PhysicalSignature = System.DBNull.Value;

                        //Code modified by Loveena to send SignerName as StaffName
                        //if (TextBoxSignatureName != string.Empty)
                        //    _drDocumentSignatures.SignerName = TextBoxSignatureName;
                        _drDocumentSignatures.SignerName = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).FirstName + " " + ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).LastName;
                        _drDocumentSignatures.StaffId = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId;
                        _drDocumentSignatures.SignedDocumentVersionId = _drDocumentVersions.DocumentVersionId;
                        _dsHarborConsent.DocumentSignatures.Rows.Add(_drDocumentSignatures);
                        objClientMedication = new ClientMedication();
                        dsTemp = objClientMedication.UpdateDocuments(_dsHarborConsent);
                        if (dsTemp.Tables["Documents"].Rows.Count > 0)
                        {
                            //commented By anuj
                            //Session["StandardHarborConsent"] = _dsHarborConsent;
                            Session["DocumentId"] = dsTemp.Tables["Documents"].Rows[0]["DocumentId"];
                            _documentVersionId = dsTemp.Tables["DocumentVersions"].Rows[0]["DocumentVersionId"].ToString();
                            Session["DocumentVersionId"] = _documentVersionId;
                        }
                    }
                    else if (RadioButtonPatient == true)
                    {
                        if (Session["PatientAlreadySignedDocument"] == null)
                        {
                            //Modified by Anuj on  1 dec,2009 for task ref #18 SDi Venture 10
                            if (ClientMedicationConsentId != null && ClientMedicationConsentId != "")
                            {
                                DataSet _datasetSignatureStatus = null;
                                objClientMedication = new ClientMedication();
                                _datasetSignatureStatus = objClientMedication.GetSignatureStatusRecord(Convert.ToInt32(ClientMedicationConsentId));
                                if (_datasetSignatureStatus != null && _datasetSignatureStatus.Tables["SignatureStatusRecord"].Rows.Count > 0)
                                {
                                    Streamline.UserBusinessServices.DataSets.DataSetCustomDocuments.DocumentSignaturesRow _drCustomDocumentsDocumentSignatures = null;
                                    _drCustomDocumentsDocumentSignatures = (Streamline.UserBusinessServices.DataSets.DataSetCustomDocuments.DocumentSignaturesRow)_dsCustomDocuments.DocumentSignatures.NewRow();
                                    _drCustomDocumentsDocumentSignatures.CreatedBy = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                                    _drCustomDocumentsDocumentSignatures.CreatedDate = DateTime.Now;
                                    _drCustomDocumentsDocumentSignatures.ModifiedBy = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                                    _drCustomDocumentsDocumentSignatures.ModifiedDate = DateTime.Now;
                                    _drCustomDocumentsDocumentSignatures.DocumentId = Convert.ToInt32(_datasetSignatureStatus.Tables["SignatureStatusRecord"].Rows[0]["DocumentId"].ToString());
                                    _drCustomDocumentsDocumentSignatures.RowIdentifier = System.Guid.NewGuid();
                                    _drCustomDocumentsDocumentSignatures.SignatureDate = DateTime.Now;
                                    Session["PatientAlreadySignedDocument"] = "Y";
                                    _drCustomDocumentsDocumentSignatures.SignatureOrder = Convert.ToInt32(_datasetSignatureStatus.Tables["SignatureStatusRecord"].Rows[0]["SignatureOrder"].ToString()) + 1;
                                    Session["SignatureOrder"] = _drCustomDocumentsDocumentSignatures.SignatureOrder;
                                    _drCustomDocumentsDocumentSignatures.ClientId = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId;
                                    _drCustomDocumentsDocumentSignatures.IsClient = "Y";
                                    _drCustomDocumentsDocumentSignatures.ClientSignedPaper = IsClientSignedPaper;
                                    if (eSignature != "")
                                    {
                                        _drCustomDocumentsDocumentSignatures.PhysicalSignature = eSignatureASCI;
                                        //Added in ref to Task#2805
                                        _drCustomDocumentsDocumentSignatures.VerificationMode = "S";
                                    }
                                    else if (IsClientSignedPaper != "Y")
                                        _drCustomDocumentsDocumentSignatures.VerificationMode = "P";
                                    //Code ends overe here.
                                    _drCustomDocumentsDocumentSignatures.SignerName = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.FirstName + " " + ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.LastName;
                                    _drCustomDocumentsDocumentSignatures.StaffId = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId;
                                    _drCustomDocumentsDocumentSignatures.SignedDocumentVersionId = Convert.ToInt32(_datasetSignatureStatus.Tables["SignatureStatusRecord"].Rows[0]["SignedDocumentVersionId"].ToString());
                                    _dsCustomDocuments.DocumentSignatures.Rows.Add(_drCustomDocumentsDocumentSignatures);
                                    objClientMedication = new ClientMedication();
                                    dsTemp = objClientMedication.UpdateDocuments(_dsCustomDocuments);

                                    Session["StandardHarborConsent"] = null;
                                    Session["DataSetCustomDocuments"] = dsTemp.Tables["DocumentSignatures"];
                                    Session["SignatureId"] = dsTemp.Tables["DocumentSignatures"].Rows[0]["SignatureId"];
                                    Session["DocumentVersionId"] = _datasetSignatureStatus.Tables["SignatureStatusRecord"].Rows[0]["DocumentVersionId"].ToString();

                                    //Updating ClientMedicationConsentDocuments Table                                    
                                    string ModifiedBy = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                                    int isUpadteConsentDocument = 0;
                                    objClientMedication = new ClientMedication();
                                    isUpadteConsentDocument = objClientMedication.UpdateClientMedicationConsentDocuments(Convert.ToInt32(ClientMedicationConsentId), ModifiedBy);
                                }
                            }
                            else
                            {
                                Streamline.UserBusinessServices.DataSets.DataSetCustomDocuments.DocumentSignaturesRow _drCustomDocumentsDocumentSignatures = null;
                                _drCustomDocumentsDocumentSignatures = (Streamline.UserBusinessServices.DataSets.DataSetCustomDocuments.DocumentSignaturesRow)_dsCustomDocuments.DocumentSignatures.NewRow();
                                _drCustomDocumentsDocumentSignatures.CreatedBy = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                                _drCustomDocumentsDocumentSignatures.CreatedDate = DateTime.Now;
                                _drCustomDocumentsDocumentSignatures.ModifiedBy = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                                _drCustomDocumentsDocumentSignatures.ModifiedDate = DateTime.Now;
                                _drCustomDocumentsDocumentSignatures.DocumentId = Convert.ToInt32(Session["DocumentId"]);
                                _drCustomDocumentsDocumentSignatures.RowIdentifier = System.Guid.NewGuid();
                                _drCustomDocumentsDocumentSignatures.SignatureDate = DateTime.Now;
                                //Added Session Variable tn ref to Task#2563 dated 26-Aug-2009
                                Session["PatientAlreadySignedDocument"] = "Y";
                                if (Session["SignatureOrder"] != null)
                                    _drCustomDocumentsDocumentSignatures.SignatureOrder = Convert.ToInt32(Session["SignatureOrder"]) + 1;
                                Session["SignatureOrder"] = _drCustomDocumentsDocumentSignatures.SignatureOrder;
                                _drCustomDocumentsDocumentSignatures.ClientId = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId;
                                _drCustomDocumentsDocumentSignatures.IsClient = "Y";
                                _drCustomDocumentsDocumentSignatures.ClientSignedPaper = IsClientSignedPaper;
                                // _drCustomDocumentsDocumentSignatures.RelationToClient = DropDownRelationShip;
                                if (eSignature != "")
                                {
                                    _drCustomDocumentsDocumentSignatures.PhysicalSignature = eSignatureASCI;
                                    //Adedd by Loveena in ref to Task#2805
                                    _drCustomDocumentsDocumentSignatures.VerificationMode = "S";
                                }
                                else if (IsClientSignedPaper != "Y")
                                {
                                    _drCustomDocumentsDocumentSignatures.VerificationMode = "P";
                                }
                                //else
                                //    _drCustomDocumentsDocumentSignatures.PhysicalSignature = System.DBNull.Value;
                                //Code modified by Loveena to send Signer Name
                                //if (TextBoxSignatureName != string.Empty)
                                //    _drCustomDocumentsDocumentSignatures.SignerName = TextBoxSignatureName;
                                _drCustomDocumentsDocumentSignatures.SignerName = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.FirstName + " " + ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.LastName;
                                _drCustomDocumentsDocumentSignatures.StaffId = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId;
                                _drCustomDocumentsDocumentSignatures.SignedDocumentVersionId = Convert.ToInt32(Session["DocumentVersionId"]);
                                _dsCustomDocuments.DocumentSignatures.Rows.Add(_drCustomDocumentsDocumentSignatures);
                                objClientMedication = new ClientMedication();
                                dsTemp = objClientMedication.UpdateDocuments(_dsCustomDocuments);
                                Session["StandardHarborConsent"] = null;
                                Session["DataSetCustomDocuments"] = dsTemp.Tables["DocumentSignatures"];
                                Session["SignatureId"] = dsTemp.Tables["DocumentSignatures"].Rows[0]["SignatureId"];
                                // Added on 20 Dec for task ref 18 SDi venture 10
                                //Updating ClientMedicationConsentDocuments Table                                    
                                DataSet _datasetVersionId = null;
                                objClientMedication = new ClientMedication();
                                _datasetVersionId = objClientMedication.GetDocumentVersionId(Convert.ToInt32(Session["DocumentId"]));
                                if (_datasetVersionId != null && _datasetVersionId.Tables.Count > 0)
                                {
                                    if (_datasetVersionId.Tables["DocumentVersionIds"].Rows.Count > 0)
                                    {
                                        string ModifiedBy = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                                        int isUpadteConsentDocument = 0;
                                        string DocumentVersionId = "";
                                        objClientMedication = new ClientMedication();
                                        for (int i = 0; i < _datasetVersionId.Tables["DocumentVersionIds"].Rows.Count; i++)
                                        {
                                            DocumentVersionId = _datasetVersionId.Tables["DocumentVersionIds"].Rows[i]["DocumentVersionId"].ToString();
                                            isUpadteConsentDocument = objClientMedication.UpdateMultipleClientMedicationConsentDocuments(Convert.ToInt32(DocumentVersionId), ModifiedBy);
                                        }
                                    }
                                }
                            }
                            //Ended over here
                        }
                        //Code added by Loveena in ref to Task#2563 1.9.5.5 Patient Consent - Subsequent Patient Signatures 
                        else if (Session["PatientAlreadySignedDocument"] != null)
                        {
                            if (Session["DataSetCustomDocuments"] != null)
                            {
                                _dsCustomDocuments.Merge((DataTable)Session["DataSetCustomdocuments"]);
                            }
                            Streamline.UserBusinessServices.DataSets.DataSetCustomDocuments.DocumentSignaturesRow[] _drCustomDocumentsDocumentSignatures = null;
                            _drCustomDocumentsDocumentSignatures = (Streamline.UserBusinessServices.DataSets.DataSetCustomDocuments.DocumentSignaturesRow[])_dsCustomDocuments.DocumentSignatures.Select("DocumentId =" + Convert.ToInt32(Session["DocumentId"]) + " and SignatureId=" + Convert.ToInt32(Session["SignatureId"]));
                            if (_drCustomDocumentsDocumentSignatures.Length > 0)
                            {
                                //Added Session Variable in ref to Task#2563 dated 26-Aug-2009
                                Session["PatientAlreadySignedDocument"] = "Y";
                                if (Session["SignatureOrder"] != null)
                                    _drCustomDocumentsDocumentSignatures[0]["SignatureOrder"] = Convert.ToInt32(Session["SignatureOrder"]) + 1;
                                Session["SignatureOrder"] = _drCustomDocumentsDocumentSignatures[0]["SignatureOrder"];
                                if (eSignature != "")
                                {
                                    _drCustomDocumentsDocumentSignatures[0]["PhysicalSignature"] = eSignatureASCI;
                                    //Adedd by Loveena in ref to Task#2805
                                    _drCustomDocumentsDocumentSignatures[0]["VerificationMode"] = "S";
                                }
                                else if (IsClientSignedPaper != "Y")
                                {
                                    _drCustomDocumentsDocumentSignatures[0]["VerificationMode"] = "P";
                                }
                                _drCustomDocumentsDocumentSignatures[0]["ClientSignedPaper"] = IsClientSignedPaper;
                                objClientMedication = new ClientMedication();
                                dsTemp = objClientMedication.UpdateDocuments(_dsCustomDocuments);
                                Session["DataSetCustomdocuments"] = dsTemp.Tables["DocumentSignatures"];
                                Session["StandardHarborConsent"] = null;
                            }
                        }
                        //Code added by Loveena ends over here.
                    }
                    else if (RadioButtonRelation == true)
                    {
                        //Modified By Anuj on 1 Dec,2009 for task ref #18 SDI venture 10
                        if (ClientMedicationConsentId != null && ClientMedicationConsentId != "")
                        {
                            DataSet _datasetSignatureStatus = null;
                            objClientMedication = new ClientMedication();
                            _datasetSignatureStatus = objClientMedication.GetSignatureStatusRecord(Convert.ToInt32(ClientMedicationConsentId));
                            if (_datasetSignatureStatus != null && _datasetSignatureStatus.Tables["SignatureStatusRecord"].Rows.Count > 0)
                            {
                                Streamline.UserBusinessServices.DataSets.DataSetCustomDocuments.DocumentSignaturesRow _drCustomDocumentsDocumentSignatures = null;
                                _drCustomDocumentsDocumentSignatures = (Streamline.UserBusinessServices.DataSets.DataSetCustomDocuments.DocumentSignaturesRow)_dsCustomDocuments.DocumentSignatures.NewRow();
                                _drCustomDocumentsDocumentSignatures.CreatedBy = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                                _drCustomDocumentsDocumentSignatures.CreatedDate = DateTime.Now;
                                _drCustomDocumentsDocumentSignatures.ModifiedBy = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                                _drCustomDocumentsDocumentSignatures.ModifiedDate = DateTime.Now;
                                _drCustomDocumentsDocumentSignatures.DocumentId = Convert.ToInt32(_datasetSignatureStatus.Tables["SignatureStatusRecord"].Rows[0]["DocumentId"].ToString());
                                _drCustomDocumentsDocumentSignatures.RowIdentifier = System.Guid.NewGuid();
                                _drCustomDocumentsDocumentSignatures.SignatureDate = DateTime.Now;
                                if (Session["SignatureOrder"] != null)
                                {
                                    _drCustomDocumentsDocumentSignatures.SignatureOrder = Convert.ToInt32(Session["SignatureOrder"]) + 1;
                                }
                                else
                                {
                                    _drCustomDocumentsDocumentSignatures.SignatureOrder = Convert.ToInt32(_datasetSignatureStatus.Tables["SignatureStatusRecord"].Rows[0]["SignatureOrder"].ToString()) + 1;
                                }
                                Session["SignatureOrder"] = _drCustomDocumentsDocumentSignatures.SignatureOrder;
                                _drCustomDocumentsDocumentSignatures.ClientId = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId;
                                _drCustomDocumentsDocumentSignatures.IsClient = "N";
                                _drCustomDocumentsDocumentSignatures.ClientSignedPaper = IsClientSignedPaper;
                                _drCustomDocumentsDocumentSignatures.RelationToClient = DropDownRelationShip;
                                if (eSignature != "")
                                {
                                    _drCustomDocumentsDocumentSignatures.PhysicalSignature = eSignatureASCI;
                                    //Added in ref to Task#2805
                                    _drCustomDocumentsDocumentSignatures.VerificationMode = "S";
                                }
                                else if (IsClientSignedPaper != "Y")
                                    _drCustomDocumentsDocumentSignatures.VerificationMode = "P";

                                if (TextBoxSignatureName != string.Empty)
                                {
                                    _drCustomDocumentsDocumentSignatures.SignerName = TextBoxSignatureName;
                                }
                                _drCustomDocumentsDocumentSignatures.StaffId = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId;
                                _drCustomDocumentsDocumentSignatures.SignedDocumentVersionId = Convert.ToInt32(_datasetSignatureStatus.Tables["SignatureStatusRecord"].Rows[0]["SignedDocumentVersionId"].ToString());
                                _dsCustomDocuments.DocumentSignatures.Rows.Add(_drCustomDocumentsDocumentSignatures);
                                objClientMedication = new ClientMedication();
                                dsTemp = objClientMedication.UpdateDocuments(_dsCustomDocuments);
                                Session["StandardHarborConsent"] = null;
                                Session["DocumentVersionId"] = _datasetSignatureStatus.Tables["SignatureStatusRecord"].Rows[0]["DocumentVersionId"].ToString();
                                //Updating ClientMedicationConsentDocuments Table                                    
                                string ModifiedBy = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                                int isUpadteConsentDocument = 0;
                                objClientMedication = new ClientMedication();
                                isUpadteConsentDocument = objClientMedication.UpdateClientMedicationConsentDocuments(Convert.ToInt32(ClientMedicationConsentId), ModifiedBy);
                            }
                        }
                        else
                        {
                            Streamline.UserBusinessServices.DataSets.DataSetCustomDocuments.DocumentSignaturesRow _drCustomDocumentsDocumentSignatures = null;
                            _drCustomDocumentsDocumentSignatures = (Streamline.UserBusinessServices.DataSets.DataSetCustomDocuments.DocumentSignaturesRow)_dsCustomDocuments.DocumentSignatures.NewRow();
                            _drCustomDocumentsDocumentSignatures.CreatedBy = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                            _drCustomDocumentsDocumentSignatures.CreatedDate = DateTime.Now;
                            _drCustomDocumentsDocumentSignatures.ModifiedBy = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                            _drCustomDocumentsDocumentSignatures.ModifiedDate = DateTime.Now;
                            _drCustomDocumentsDocumentSignatures.DocumentId = Convert.ToInt32(Session["DocumentId"]);
                            _drCustomDocumentsDocumentSignatures.RowIdentifier = System.Guid.NewGuid();
                            _drCustomDocumentsDocumentSignatures.SignatureDate = DateTime.Now;
                            //_drCustomDocumentsDocumentSignatures.SignatureOrder = 2;
                            if (Session["SignatureOrder"] != null)
                                _drCustomDocumentsDocumentSignatures.SignatureOrder = Convert.ToInt32(Session["SignatureOrder"]) + 1;
                            Session["SignatureOrder"] = _drCustomDocumentsDocumentSignatures.SignatureOrder;
                            _drCustomDocumentsDocumentSignatures.ClientId = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId;
                            _drCustomDocumentsDocumentSignatures.IsClient = "N";
                            _drCustomDocumentsDocumentSignatures.ClientSignedPaper = IsClientSignedPaper;
                            _drCustomDocumentsDocumentSignatures.RelationToClient = DropDownRelationShip;
                            if (eSignature != "")
                            {
                                _drCustomDocumentsDocumentSignatures.PhysicalSignature = eSignatureASCI;
                                //Added in ref to Task#2805
                                _drCustomDocumentsDocumentSignatures.VerificationMode = "S";
                            }
                            else if (IsClientSignedPaper != "Y")
                                _drCustomDocumentsDocumentSignatures.VerificationMode = "P";
                            //else
                            //    _drCustomDocumentsDocumentSignatures.PhysicalSignature = System.DBNull.Value;
                            if (TextBoxSignatureName != string.Empty)
                                _drCustomDocumentsDocumentSignatures.SignerName = TextBoxSignatureName;
                            _drCustomDocumentsDocumentSignatures.StaffId = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId;
                            _drCustomDocumentsDocumentSignatures.SignedDocumentVersionId = Convert.ToInt32(Session["DocumentVersionId"]);
                            _dsCustomDocuments.DocumentSignatures.Rows.Add(_drCustomDocumentsDocumentSignatures);
                            objClientMedication = new ClientMedication();
                            dsTemp = objClientMedication.UpdateDocuments(_dsCustomDocuments);
                            Session["StandardHarborConsent"] = null;
                            // Added on 20 Dec for task ref 18 SDi venture 10
                            //Updating ClientMedicationConsentDocuments Table                                    
                            DataSet _datasetVersionId = null;
                            objClientMedication = new ClientMedication();
                            _datasetVersionId = objClientMedication.GetDocumentVersionId(Convert.ToInt32(Session["DocumentId"]));
                            if (_datasetVersionId != null && _datasetVersionId.Tables.Count > 0)
                            {
                                if (_datasetVersionId.Tables["DocumentVersionIds"].Rows.Count > 0)
                                {
                                    string ModifiedBy = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                                    int isUpadteConsentDocument = 0;
                                    string DocumentVersionId = "";
                                    objClientMedication = new ClientMedication();
                                    for (int i = 0; i < _datasetVersionId.Tables["DocumentVersionIds"].Rows.Count; i++)
                                    {
                                        DocumentVersionId = _datasetVersionId.Tables["DocumentVersionIds"].Rows[i]["DocumentVersionId"].ToString();
                                        isUpadteConsentDocument = objClientMedication.UpdateMultipleClientMedicationConsentDocuments(Convert.ToInt32(DocumentVersionId), ModifiedBy);
                                    }
                                }
                            }
                        }
                        //Ended over here
                    }
                    //DataSet dsTemp = objClientMedication.UpdateDocuments(_dsHarborConsent);

                }
                if (IsCustomPage > 0)
                {
                    string strObj = Server.HtmlDecode(ObjValue);
                    _dsCustomDoc = DeserializeDataSet(strObj);

                    if (_dsCustomDoc.Tables.Count > 0)
                    {
                        Session["DocumentId"] = _dsCustomDoc.Tables["DocumentVersions"].Rows[0]["DocumentId"];
                        _documentVersionId = _dsCustomDoc.Tables["DocumentVersions"].Rows[0]["DocumentVersionId"].ToString();
                        _dsCustomDocuments = new Streamline.UserBusinessServices.DataSets.DataSetCustomDocuments();
                        _dsCustomDoc.Tables["Documents"].Rows[0]["Status"] = 22;

                        if (RadioButtonMedicalStaff == true)
                        {
                            Session["DocumentVersionId"] = null;
                            Session["DocumentVersionId"] = _documentVersionId;
                            //Code added by Loveena.
                            Session["SignatureOrder"] = null;
                            //Code added by Loveena in ref to Task#2563
                            Session["PatientAlreadySignedDocument"] = null;
                            Session["DataSetCustomDocuments"] = null;
                            Session["SignatureId"] = null;
                            //code ends over here.
                            Session["SignatureOrder"] = 1;
                            //Code added by Loveena ends over there.
                            //ClientMedicationConsent
                            if (Session["DataSetClientMedications"] != null)
                            {
                                Streamline.UserBusinessServices.DataSets.DataSetCustomDocuments.ClientMedicationConsentsRow _drCustomDocumentsClientMedicationConsent = null;
                                DataSetClientMedications = (DataSet)Session["DataSetClientMedications"];

                                foreach (DataRow drMedication in DataSetClientMedications.Tables["ClientMedications"].Rows)
                                {
                                    _drCustomDocumentsClientMedicationConsent = (Streamline.UserBusinessServices.DataSets.DataSetCustomDocuments.ClientMedicationConsentsRow)_dsCustomDocuments.ClientMedicationConsents.NewRow();
                                    _drCustomDocumentsClientMedicationConsent.CreatedBy = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                                    _drCustomDocumentsClientMedicationConsent.CreatedDate = DateTime.Now;
                                    _drCustomDocumentsClientMedicationConsent.ModifiedBy = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                                    _drCustomDocumentsClientMedicationConsent.ModifiedDate = DateTime.Now;
                                    _drCustomDocumentsClientMedicationConsent.RowIdentifier = System.Guid.NewGuid();
                                    _drCustomDocumentsClientMedicationConsent.MedicationNameId = Convert.ToInt32(drMedication["MedicationNameId"]);
                                    if (_dsCustomDoc.Tables["DocumentVersions"].Rows.Count > 0)
                                        _drCustomDocumentsClientMedicationConsent.DocumentVersionId = Convert.ToInt32(_dsCustomDoc.Tables["DocumentVersions"].Rows[0]["DocumentVersionId"]);

                                    _dsCustomDocuments.ClientMedicationConsents.Rows.Add(_drCustomDocumentsClientMedicationConsent);
                                }
                            }

                            if (!_dsCustomDoc.Tables["Documents"].Columns.Contains("GroupServiceId"))
                                _dsCustomDoc.Tables["Documents"].Columns.Add("GroupServiceId", System.Type.GetType("System.Int32"));
                            objClientMedication = new ClientMedication();
                            DataSet dsCustDocuments = objClientMedication.UpdateDocuments(_dsCustomDoc);

                        }
                        else if (RadioButtonPatient == true)
                        {
                            //DocumentSignatures
                            if (Session["PatientAlreadySignedDocument"] == null)
                            {

                                //Modified by Anuj on  1 dec,2009 for task ref #18 SDi Venture 10
                                if (ClientMedicationConsentId != null && ClientMedicationConsentId != "")
                                {
                                    DataSet _datasetSignatureStatus = null;
                                    objClientMedication = new ClientMedication();
                                    _datasetSignatureStatus = objClientMedication.GetSignatureStatusRecord(Convert.ToInt32(ClientMedicationConsentId));
                                    if (_datasetSignatureStatus != null && _datasetSignatureStatus.Tables["SignatureStatusRecord"].Rows.Count > 0)
                                    {
                                        Streamline.UserBusinessServices.DataSets.DataSetCustomDocuments.DocumentSignaturesRow _drCustomDocumentsDocumentSignatures = null;
                                        _drCustomDocumentsDocumentSignatures = (Streamline.UserBusinessServices.DataSets.DataSetCustomDocuments.DocumentSignaturesRow)_dsCustomDocuments.DocumentSignatures.NewRow();
                                        _drCustomDocumentsDocumentSignatures.CreatedBy = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                                        _drCustomDocumentsDocumentSignatures.CreatedDate = DateTime.Now;
                                        _drCustomDocumentsDocumentSignatures.ModifiedBy = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                                        _drCustomDocumentsDocumentSignatures.ModifiedDate = DateTime.Now;
                                        _drCustomDocumentsDocumentSignatures.DocumentId = Convert.ToInt32(_datasetSignatureStatus.Tables["SignatureStatusRecord"].Rows[0]["DocumentId"].ToString());
                                        _drCustomDocumentsDocumentSignatures.RowIdentifier = System.Guid.NewGuid();
                                        _drCustomDocumentsDocumentSignatures.SignatureDate = DateTime.Now;

                                        Session["PatientAlreadySignedDocument"] = "Y";
                                        _drCustomDocumentsDocumentSignatures.SignatureOrder = Convert.ToInt32(_datasetSignatureStatus.Tables["SignatureStatusRecord"].Rows[0]["SignatureOrder"].ToString()) + 1;
                                        Session["SignatureOrder"] = _drCustomDocumentsDocumentSignatures.SignatureOrder;
                                        _drCustomDocumentsDocumentSignatures.ClientId = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId;
                                        _drCustomDocumentsDocumentSignatures.IsClient = "Y";
                                        _drCustomDocumentsDocumentSignatures.ClientSignedPaper = IsClientSignedPaper;
                                        if (eSignature != "")
                                        {
                                            _drCustomDocumentsDocumentSignatures.PhysicalSignature = eSignatureASCI;
                                            //Added in ref to Task#2805
                                            _drCustomDocumentsDocumentSignatures.VerificationMode = "S";
                                        }
                                        else if (IsClientSignedPaper != "Y")
                                            _drCustomDocumentsDocumentSignatures.VerificationMode = "P";
                                        _drCustomDocumentsDocumentSignatures.SignerName = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.FirstName + " " + ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.LastName;
                                        _drCustomDocumentsDocumentSignatures.StaffId = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId;
                                        _drCustomDocumentsDocumentSignatures.SignedDocumentVersionId = Convert.ToInt32(_datasetSignatureStatus.Tables["SignatureStatusRecord"].Rows[0]["SignedDocumentVersionId"].ToString());
                                        _dsCustomDocuments.DocumentSignatures.Rows.Add(_drCustomDocumentsDocumentSignatures);
                                    }
                                }

                                else
                                {
                                    Streamline.UserBusinessServices.DataSets.DataSetCustomDocuments.DocumentSignaturesRow _drCustomDocumentsDocumentSignatures = null;
                                    _drCustomDocumentsDocumentSignatures = (Streamline.UserBusinessServices.DataSets.DataSetCustomDocuments.DocumentSignaturesRow)_dsCustomDocuments.DocumentSignatures.NewRow();
                                    _drCustomDocumentsDocumentSignatures.CreatedBy = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                                    _drCustomDocumentsDocumentSignatures.CreatedDate = DateTime.Now;
                                    _drCustomDocumentsDocumentSignatures.ModifiedBy = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                                    _drCustomDocumentsDocumentSignatures.ModifiedDate = DateTime.Now;
                                    _drCustomDocumentsDocumentSignatures.DocumentId = Convert.ToInt32(Session["DocumentId"]);
                                    _drCustomDocumentsDocumentSignatures.RowIdentifier = System.Guid.NewGuid();
                                    _drCustomDocumentsDocumentSignatures.SignatureDate = DateTime.Now;
                                    //Code added by Loveena in ref to Task#2563
                                    Session["PatientAlreadySignedDocument"] = "Y";
                                    //code ends over here
                                    //_drCustomDocumentsDocumentSignatures.SignatureOrder = 2;
                                    if (Session["SignatureOrder"] != null)
                                        _drCustomDocumentsDocumentSignatures.SignatureOrder = Convert.ToInt32(Session["SignatureOrder"]) + 1;
                                    Session["SignatureOrder"] = _drCustomDocumentsDocumentSignatures.SignatureOrder;
                                    _drCustomDocumentsDocumentSignatures.ClientId = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId;
                                    _drCustomDocumentsDocumentSignatures.IsClient = "Y";
                                    _drCustomDocumentsDocumentSignatures.ClientSignedPaper = IsClientSignedPaper;
                                    if (eSignature != "")
                                    {
                                        _drCustomDocumentsDocumentSignatures.PhysicalSignature = eSignatureASCI;
                                        //Added in ref to Task#2805
                                        _drCustomDocumentsDocumentSignatures.VerificationMode = "S";
                                    }
                                    else if (IsClientSignedPaper != "Y")
                                        _drCustomDocumentsDocumentSignatures.VerificationMode = "P";
                                    //Code modified by Loveena to send SignerName as ClientName;
                                    //if (TextBoxSignatureName != string.Empty)
                                    //    _drCustomDocumentsDocumentSignatures.SignerName = TextBoxSignatureName;
                                    _drCustomDocumentsDocumentSignatures.SignerName = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.FirstName + " " + ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.LastName;
                                    _drCustomDocumentsDocumentSignatures.StaffId = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId;
                                    _drCustomDocumentsDocumentSignatures.SignedDocumentVersionId = Convert.ToInt32(Session["DocumentVersionId"]);
                                    _dsCustomDocuments.DocumentSignatures.Rows.Add(_drCustomDocumentsDocumentSignatures);
                                }
                            }
                            else if (Session["PatientAlreadySignedDocument"] != null)
                            {
                                if (Session["DataSetCustomDocuments"] != null)
                                {
                                    _dsCustomDocuments.Merge((DataTable)Session["DataSetCustomdocuments"]);
                                }
                                Streamline.UserBusinessServices.DataSets.DataSetCustomDocuments.DocumentSignaturesRow[] _drCustomDocumentsDocumentSignatures = null;
                                _drCustomDocumentsDocumentSignatures = (Streamline.UserBusinessServices.DataSets.DataSetCustomDocuments.DocumentSignaturesRow[])_dsCustomDocuments.DocumentSignatures.Select("DocumentId =" + Convert.ToInt32(Session["DocumentId"]) + " and SignatureId=" + Convert.ToInt32(Session["SignatureId"]));
                                if (_drCustomDocumentsDocumentSignatures.Length > 0)
                                {
                                    //Added Session Variable in ref to Task#2563 dated 26-Aug-2009
                                    Session["PatientAlreadySignedDocument"] = "Y";
                                    if (Session["SignatureOrder"] != null)
                                        _drCustomDocumentsDocumentSignatures[0]["SignatureOrder"] = Convert.ToInt32(Session["SignatureOrder"]) + 1;
                                    Session["SignatureOrder"] = _drCustomDocumentsDocumentSignatures[0]["SignatureOrder"];
                                    if (eSignature != "")
                                    {
                                        _drCustomDocumentsDocumentSignatures[0]["PhysicalSignature"] = eSignatureASCI;
                                        //Added in ref to Task#2805
                                        _drCustomDocumentsDocumentSignatures[0]["VerificationMode"] = "S";
                                    }
                                    else if (IsClientSignedPaper != "Y")
                                        _drCustomDocumentsDocumentSignatures[0]["VerificationMode"] = "P";
                                    _drCustomDocumentsDocumentSignatures[0]["ClientSignedPaper"] = IsClientSignedPaper;

                                    Session["DataSetCustomdocuments"] = dsTemp.Tables["DocumentSignatures"];
                                    Session["StandardHarborConsent"] = null;
                                }
                            }
                            //Code added by Loveena ends over here.
                        }
                        else if (RadioButtonRelation == true)
                        {
                            //DocumentSignatures
                            //Modified By Anuj on 1 Dec,2009 for task ref #18 SDI venture 10
                            if (ClientMedicationConsentId != null && ClientMedicationConsentId != "")
                            {
                                DataSet _datasetSignatureStatus = null;
                                objClientMedication = new ClientMedication();
                                _datasetSignatureStatus = objClientMedication.GetSignatureStatusRecord(Convert.ToInt32(ClientMedicationConsentId));
                                if (_datasetSignatureStatus != null && _datasetSignatureStatus.Tables["SignatureStatusRecord"].Rows.Count > 0)
                                {
                                    Streamline.UserBusinessServices.DataSets.DataSetCustomDocuments.DocumentSignaturesRow _drCustomDocumentsDocumentSignatures = null;
                                    _drCustomDocumentsDocumentSignatures = (Streamline.UserBusinessServices.DataSets.DataSetCustomDocuments.DocumentSignaturesRow)_dsCustomDocuments.DocumentSignatures.NewRow();
                                    _drCustomDocumentsDocumentSignatures.CreatedBy = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                                    _drCustomDocumentsDocumentSignatures.CreatedDate = DateTime.Now;
                                    _drCustomDocumentsDocumentSignatures.ModifiedBy = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                                    _drCustomDocumentsDocumentSignatures.ModifiedDate = DateTime.Now;
                                    _drCustomDocumentsDocumentSignatures.DocumentId = Convert.ToInt32(_datasetSignatureStatus.Tables["SignatureStatusRecord"].Rows[0]["DocumentId"].ToString());
                                    _drCustomDocumentsDocumentSignatures.RowIdentifier = System.Guid.NewGuid();
                                    _drCustomDocumentsDocumentSignatures.SignatureDate = DateTime.Now;
                                    //_drCustomDocumentsDocumentSignatures.SignatureOrder = 2;
                                    if (Session["SignatureOrder"] != null)
                                    {
                                        _drCustomDocumentsDocumentSignatures.SignatureOrder = Convert.ToInt32(Session["SignatureOrder"]) + 1;
                                    }
                                    else
                                    {
                                        _drCustomDocumentsDocumentSignatures.SignatureOrder = Convert.ToInt32(_datasetSignatureStatus.Tables["SignatureStatusRecord"].Rows[0]["SignatureOrder"].ToString()) + 1;
                                    }
                                    Session["SignatureOrder"] = _drCustomDocumentsDocumentSignatures.SignatureOrder;
                                    _drCustomDocumentsDocumentSignatures.ClientId = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId;
                                    _drCustomDocumentsDocumentSignatures.IsClient = "N";
                                    _drCustomDocumentsDocumentSignatures.ClientSignedPaper = IsClientSignedPaper;
                                    if (eSignature != "")
                                    {
                                        _drCustomDocumentsDocumentSignatures.PhysicalSignature = eSignatureASCI;
                                        //Added in ref to Task#2805
                                        _drCustomDocumentsDocumentSignatures.VerificationMode = "S";
                                    }
                                    else if (IsClientSignedPaper != "Y")
                                        _drCustomDocumentsDocumentSignatures.VerificationMode = "P";
                                    if (TextBoxSignatureName != string.Empty)
                                    {
                                        _drCustomDocumentsDocumentSignatures.SignerName = TextBoxSignatureName;
                                    }
                                    _drCustomDocumentsDocumentSignatures.StaffId = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId;
                                    _drCustomDocumentsDocumentSignatures.SignedDocumentVersionId = Convert.ToInt32(_datasetSignatureStatus.Tables["SignatureStatusRecord"].Rows[0]["SignedDocumentVersionId"].ToString());
                                    _drCustomDocumentsDocumentSignatures.RelationToClient = DropDownRelationShip;
                                    _dsCustomDocuments.DocumentSignatures.Rows.Add(_drCustomDocumentsDocumentSignatures);
                                }
                            }
                            else
                            {
                                Streamline.UserBusinessServices.DataSets.DataSetCustomDocuments.DocumentSignaturesRow _drCustomDocumentsDocumentSignatures = null;
                                _drCustomDocumentsDocumentSignatures = (Streamline.UserBusinessServices.DataSets.DataSetCustomDocuments.DocumentSignaturesRow)_dsCustomDocuments.DocumentSignatures.NewRow();
                                _drCustomDocumentsDocumentSignatures.CreatedBy = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                                _drCustomDocumentsDocumentSignatures.CreatedDate = DateTime.Now;
                                _drCustomDocumentsDocumentSignatures.ModifiedBy = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                                _drCustomDocumentsDocumentSignatures.ModifiedDate = DateTime.Now;
                                _drCustomDocumentsDocumentSignatures.DocumentId = Convert.ToInt32(Session["DocumentId"]);
                                _drCustomDocumentsDocumentSignatures.RowIdentifier = System.Guid.NewGuid();
                                _drCustomDocumentsDocumentSignatures.SignatureDate = DateTime.Now;
                                //_drCustomDocumentsDocumentSignatures.SignatureOrder = 2;
                                if (Session["SignatureOrder"] != null)
                                    _drCustomDocumentsDocumentSignatures.SignatureOrder = Convert.ToInt32(Session["SignatureOrder"]) + 1;
                                Session["SignatureOrder"] = _drCustomDocumentsDocumentSignatures.SignatureOrder;
                                _drCustomDocumentsDocumentSignatures.ClientId = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId;
                                _drCustomDocumentsDocumentSignatures.IsClient = "N";
                                _drCustomDocumentsDocumentSignatures.ClientSignedPaper = IsClientSignedPaper;
                                if (eSignature != "")
                                {
                                    _drCustomDocumentsDocumentSignatures.PhysicalSignature = eSignatureASCI;
                                    //Added in ref to Task#2805
                                    _drCustomDocumentsDocumentSignatures.VerificationMode = "S";
                                }
                                else if (IsClientSignedPaper != "Y")
                                    _drCustomDocumentsDocumentSignatures.VerificationMode = "P";
                                if (TextBoxSignatureName != string.Empty)
                                    _drCustomDocumentsDocumentSignatures.SignerName = TextBoxSignatureName;
                                _drCustomDocumentsDocumentSignatures.StaffId = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId;
                                _drCustomDocumentsDocumentSignatures.SignedDocumentVersionId = Convert.ToInt32(Session["DocumentVersionId"]);
                                _drCustomDocumentsDocumentSignatures.RelationToClient = DropDownRelationShip;
                                _dsCustomDocuments.DocumentSignatures.Rows.Add(_drCustomDocumentsDocumentSignatures);
                            }
                        }
                        objClientMedication = new ClientMedication();
                        DataSet dsCustomDocumentsTemp = objClientMedication.UpdateDocuments(_dsCustomDocuments);
                        //Code added by Loveena in ref to Task#2563 dated 26-Aug-2009
                        Session["DataSetCustomdocuments"] = dsCustomDocumentsTemp.Tables["DocumentSignatures"];
                        Session["SignatureId"] = dsCustomDocumentsTemp.Tables["DocumentSignatures"].Rows[0]["SignatureId"];
                        //code ends over here.
                    }
                }
                return Session["DocumentVersionId"].ToString();
            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally
            {
                if (_dsCustomDoc != null)
                    _dsCustomDoc = null;
            }
        }




        //<summary>
        //     This function will be used to Deserialize the dataset
        //      //Function Added Chandan Srivastava
        //     Task #2433 Build MM #1.9.4
        //     </summary>
        //     <param name="xmlizedString,type"></param>
        public static Object DeserializeObject(String xmlizedString, Type type)
        {
            XmlSerializer _xmlSerializerObject = null;
            MemoryStream _memoryStreamObject = null;
            Object _deserializeObject = null;
            try
            {
                //XmlSerializer xs = new XmlSerializer(typeof(System.Data.DataSet));
                _xmlSerializerObject = new XmlSerializer(type);
                _memoryStreamObject = new MemoryStream(StringToUTF8ByteArray(xmlizedString));
                //XmlTextWriter _xmlTextWriterObject = new XmlTextWriter(_memoryStreamObject, Encoding.UTF8);
                _deserializeObject = _xmlSerializerObject.Deserialize(_memoryStreamObject);

                return _deserializeObject;
            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally
            {
                if (_memoryStreamObject != null)
                {
                    _memoryStreamObject.Close();
                }
                _xmlSerializerObject = null;

            }
        }

        public static DataSet DeserializeDataSet(String xmlizedString)
        {
            try
            {
                return DeserializeObject(xmlizedString, typeof(System.Data.DataSet)) as DataSet;
            }
            catch (Exception ex)
            {
                throw (ex);
            }
        }

        private static Byte[] StringToUTF8ByteArray(String xmlString)
        {
            try
            {
                UTF8Encoding _uTF8EncodingObject = new UTF8Encoding();
                Byte[] _byteArray = _uTF8EncodingObject.GetBytes(xmlString);
                return _byteArray;
            }
            catch (Exception ex)
            {
                throw ex;
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

        //Added by Anuj Tomar on 11 Nov,2009 for task ref # 15 SDI Projects FY10 - Venture
        //This Function will create the rows(stote the TitrationTemplate) in TitrationTemplates and TitrationTemplateInstructions tables in DataBase.
        [WebMethod(EnableSession = true)]
        public string SaveTitrationTemplate(int MedicationNameId, string TemplateName)
        {
            DataSet _dataSetTitrationTemplate = new DataSet();
            DataSet _dataSetMedication = new DataSet();
            Streamline.UserBusinessServices.DataSets.DataSetTitrationTemplate.TitrationTemplatesRow _drTitrationTemplates = null;
            Streamline.UserBusinessServices.DataSets.DataSetTitrationTemplate.TitrationTemplateInstructionsRow _drTitrationTemplateInstructions = null;
            Streamline.UserBusinessServices.DataSets.DataSetTitrationTemplate _dsTitrationTemplate = null;
            Streamline.UserBusinessServices.ClientMedication objClientMedication = null;
            int MedicationId = 0;
            try
            {
                if (Session["DataSetTitration"] != null)
                {
                    Int32 _TitrationTemplateId = -1;
                    Int32 _TitrationTemplateInstructionsId = -1;
                    _dsTitrationTemplate = new Streamline.UserBusinessServices.DataSets.DataSetTitrationTemplate();
                    _dataSetTitrationTemplate = (Streamline.UserBusinessServices.DataSets.DataSetClientMedications)Session["DataSetTitration"];
                    objClientMedication = new ClientMedication();
                    if (TemplateName != "" && TemplateName != null)
                    {
                        string isTemplateNameExist = objClientMedication.SelectTemplateName(TemplateName);
                        if (isTemplateNameExist == "N")
                        {
                            if (_dataSetTitrationTemplate.Tables["ClientMedicationInstructions"].Rows.Count > 0)
                            {
                                DataRow[] _dataRowClientMedication = _dataSetTitrationTemplate.Tables["ClientMedications"].Select("ISNULL(RecordDeleted,'N')<>'Y'");
                                _drTitrationTemplates = (Streamline.UserBusinessServices.DataSets.DataSetTitrationTemplate.TitrationTemplatesRow)_dsTitrationTemplate.TitrationTemplates.NewRow();
                                _drTitrationTemplates.StaffId = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId;
                                _drTitrationTemplates.MedicationNameId = MedicationNameId;
                                _drTitrationTemplates.CreatedDate = DateTime.Now;
                                _drTitrationTemplates.CreatedBy = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                                _drTitrationTemplates.ModifiedBy = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                                _drTitrationTemplates.ModifiedDate = DateTime.Now;
                                _drTitrationTemplates.RowIdentifier = System.Guid.NewGuid();
                                //_drTitrationTemplates.TemplateName = Convert.ToString(_dataRowClientMedication[0]["MedicationName"]) + " " + (_drTitrationTemplates.CreatedBy);
                                _drTitrationTemplates.TemplateName = TemplateName;
                                _drTitrationTemplates.TitrationTemplateId = _TitrationTemplateId;
                                _dsTitrationTemplate.TitrationTemplates.Rows.Add(_drTitrationTemplates);
                                _TitrationTemplateId = _TitrationTemplateId - 1;
                                DataRow[] _dataRowClientMedicationInstructions = _dataSetTitrationTemplate.Tables["ClientMedicationInstructions"].Select("ISNULL(RecordDeleted,'N')<>'Y'");
                                if (_dataRowClientMedicationInstructions.Length <= 0)
                                {
                                    throw new Exception("Please add atleast one titration step.");//return "false";
                                }
                                else
                                {
                                    foreach (DataRow _drInstructions in _dataRowClientMedicationInstructions)
                                    {
                                        _drTitrationTemplateInstructions = (Streamline.UserBusinessServices.DataSets.DataSetTitrationTemplate.TitrationTemplateInstructionsRow)_dsTitrationTemplate.TitrationTemplateInstructions.NewRow();
                                        _drTitrationTemplateInstructions.TitrationTemplateId = _drTitrationTemplates.TitrationTemplateId;
                                        _drTitrationTemplateInstructions.NumberOfDays = Convert.ToInt32(_drInstructions["Days"]);
                                        _drTitrationTemplateInstructions.Active = Convert.ToString(_drInstructions["Active"]);
                                        _drTitrationTemplateInstructions.StrengthId = Convert.ToInt32(_drInstructions["StrengthId"]);
                                        _drTitrationTemplateInstructions.Quantity = Convert.ToDecimal(_drInstructions["Quantity"]);
                                        _drTitrationTemplateInstructions.Unit = Convert.ToInt32(_drInstructions["Unit"]);
                                        _drTitrationTemplateInstructions.Schedule = Convert.ToInt32(_drInstructions["Schedule"]);
                                        _drTitrationTemplateInstructions.TitrationStepNumber = Convert.ToInt32(_drInstructions["TitrationStepNumber"]);
                                        _drTitrationTemplateInstructions.CreatedBy = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                                        _drTitrationTemplateInstructions.CreatedDate = DateTime.Now;
                                        _drTitrationTemplateInstructions.ModifiedBy = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                                        _drTitrationTemplateInstructions.ModifiedDate = DateTime.Now;
                                        _drTitrationTemplateInstructions.RowIdentifier = System.Guid.NewGuid();
                                        _drTitrationTemplateInstructions.TitrationTemplateInstructionId = _TitrationTemplateInstructionsId;
                                        _dsTitrationTemplate.TitrationTemplateInstructions.Rows.Add(_drTitrationTemplateInstructions);
                                        _TitrationTemplateInstructionsId = _TitrationTemplateInstructionsId - 1;
                                    }
                                    objClientMedication = new ClientMedication();
                                    DataSet dsTempTitration;
                                    dsTempTitration = objClientMedication.UpdateDocuments(_dsTitrationTemplate);
                                    return "true";
                                }
                                //DataRow[] _dataRowClientMedication = _dataSetTitrationTemplate.Tables["ClientMedications"].Select("ISNULL(RecordDeleted,'N')<>'Y'");
                                //if (_dataRowClientMedication.Length > 0)
                                //{
                                //    MedicationId = int.Parse(_dataRowClientMedication[0]["ClientMedicationId"].ToString());
                                //    if (Session["DataSetClientMedications"] != null)
                                //    {
                                //        _dataSetMedication = ((DataSet)Session["DataSetClientMedications"]);
                                //        DataRow[] drClientMedicationInstruction = _dataSetMedication.Tables["ClientMedicationInstructions"].Select(" ClientMedicationId = " + MedicationId + " AND ISNULL(RecordDeleted,'N')<>'Y' ");
                                //        if (drClientMedicationInstruction.Length > 0)
                                //        {

                                //        }
                                //    }
                                //    else
                                //    {
                                //    }
                                //    return "true";
                                //}
                                //else
                                //{
                                //    throw new Exception("Please add atleast one titration step.");//return "false";
                                //}
                            }
                            else
                            {
                                throw new Exception("Please add atleast one titration step.");//return "false";
                            }
                        }
                        else
                        {
                            return "false";
                        }
                    }
                    else
                    {
                        throw new Exception("Please enter template name.");//return "false";
                    }
                }
                return "true";
            }
            catch (Exception ex)
            {
                if (Session["SessionTimeOut"] == null)
                {
                    return "Session Expired";
                }
                else
                {
                    return ex.Message;
                }
            }
            finally
            {
                _dataSetTitrationTemplate = null;
            }
        }
        #region--Function Written By Pradeep as per task#15(Venture)
        /// <summary>
        /// <Decription>Used to pass parameters to UBS to get data for titration template</Decription>
        /// <Author>Pradeep</Author>
        /// <CreatedOn>Nov 12,2009</CreatedOn>
        /// </summary>
        /// <param name="MadicationNameId"></param>
        /// <returns></returns>
        [WebMethod(EnableSession = true)]
        public void GetTitrationTemplateData(int MadicationNameId)
        {
            Streamline.UserBusinessServices.ClientMedication objClientMedication = null;
            DataSet _dataSetTitrationTemplate = new DataSet();
            Streamline.UserBusinessServices.DataSets.DataSetTitrationTemplate _dsTitrationTemplate = null;
            try
            {
                objClientMedication = new ClientMedication();
                _dataSetTitrationTemplate = objClientMedication.GetTitrationTemplateData(MadicationNameId);
                _dsTitrationTemplate = new Streamline.UserBusinessServices.DataSets.DataSetTitrationTemplate();
                if (_dataSetTitrationTemplate != null)
                {
                    _dsTitrationTemplate.Merge(_dataSetTitrationTemplate);
                }

                if (_dsTitrationTemplate != null)
                {
                    Session["DataSetTitrationTemplate"] = _dsTitrationTemplate;
                }

            }
            catch (Exception ex)
            {
                throw (ex);
            }
        }
        [WebMethod(EnableSession = true)]
        public int DeleteTitrationTemplate(int TitrationTemplateId)
        {
            Streamline.UserBusinessServices.DataSets.DataSetTitrationTemplate.TitrationTemplatesRow _drTitrationTemplates = null;
            Streamline.UserBusinessServices.DataSets.DataSetTitrationTemplate _dsTitrationTemplate = null;

            DataTable dataTableTitrationTemplate = null;
            Streamline.UserBusinessServices.ClientMedication objClientMedication = null;
            try
            {

                if (Session["DataSetTitrationTemplate"] != null)
                {
                    _dsTitrationTemplate = (Streamline.UserBusinessServices.DataSets.DataSetTitrationTemplate)Session["DataSetTitrationTemplate"];
                }
                else
                {
                    _dsTitrationTemplate = new Streamline.UserBusinessServices.DataSets.DataSetTitrationTemplate();
                }
                dataTableTitrationTemplate = _dsTitrationTemplate.TitrationTemplates;
                DataRow[] dataRowTitrationTemplate = dataTableTitrationTemplate.Select("TitrationTemplateId=" + TitrationTemplateId);
                if (dataRowTitrationTemplate.Length > 0)
                {
                    //for (int i = 0; i < dataRowTitrationTemplate.Length;i++ )
                    //{
                    //    dataRowTitrationTemplate[i]["RecordDeleted"] = "Y";
                    //    dataRowTitrationTemplate[i]["DeletedDate"] = Convert.ToDateTime(DateTime.Now.ToShortDateString());
                    //    dataRowTitrationTemplate[i]["DeletedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                    //}
                    dataRowTitrationTemplate[0]["RecordDeleted"] = "Y";
                    dataRowTitrationTemplate[0]["DeletedDate"] = Convert.ToDateTime(DateTime.Now.ToShortDateString());
                    dataRowTitrationTemplate[0]["DeletedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                }

                objClientMedication = new ClientMedication();
                DataSet temp = new DataSet();
                temp = objClientMedication.UpdateDocuments(_dsTitrationTemplate);
                _dsTitrationTemplate.Clear();
                _dsTitrationTemplate.Merge(temp.Tables["TitrationTemplates"]);
                _dsTitrationTemplate.Merge(temp.Tables["TitrationTemplateInstructions"]);
                Session["DataSetTitrationTemplate"] = _dsTitrationTemplate;
                GenerateTitrationTemplateRows();
                return 1;
            }
            catch (Exception ex)
            {
                throw (ex);
            }
        }
        /// <summary>
        /// <Description>Used to generate titration template header rows as per task#15(Venture 10.0)</Description>
        /// <Author>Pradeep</Author>
        /// <CreatedOn> 12 Nov 2009</CreatedOn>
        /// </summary>
        private void GenerateTitrationTemplateRows()
        {
            DataRow[] dataRow;
            DataSet dataSetTitrationTemplate = null;
            try
            {
                CommonFunctions.Event_Trap(this);
                //PanelTitrationTraperList.Controls.Clear();
                Table tableTitrationTemplateList = new Table();
                tableTitrationTemplateList.ID = System.Guid.NewGuid().ToString();
                tableTitrationTemplateList.Width = new Unit(98, UnitType.Percentage);
                TableHeaderRow tableHeaderRowTitle = new TableHeaderRow();
                TableHeaderCell tableHeaderCellBlank1 = new TableHeaderCell();
                TableHeaderCell tableHeaderCellBlank2 = new TableHeaderCell();

                TableHeaderCell tableHeaderCellTemplateName = new TableHeaderCell();
                tableHeaderCellTemplateName.Text = "Template Name";
                tableHeaderCellTemplateName.Font.Underline = true;
                tableHeaderCellTemplateName.Attributes.Add("onClick", "ClientMedicationOrder.onHeaderClick(this)");
                tableHeaderCellTemplateName.Attributes.Add("ColumnName", "TemplateName");
                // tableHeaderCellTemplateName.Attributes.Add("SortOrder", setAttributes());
                tableHeaderCellTemplateName.CssClass = "handStyle";
                TableHeaderCell tableHeaderCellCreatedBy = new TableHeaderCell();
                tableHeaderCellCreatedBy.Text = "Created By";
                tableHeaderCellCreatedBy.Font.Underline = true;
                tableHeaderCellCreatedBy.Attributes.Add("onClick", "ClientMedicationOrder.onHeaderClick(this)");
                tableHeaderCellCreatedBy.Attributes.Add("ColumnName", "CreatedBy");
                // tableHeaderCellCreatedBy.Attributes.Add("SortOrder", setAttributes());
                tableHeaderCellCreatedBy.CssClass = "handStyle";
                //---Start Adding Heade Cell in Header Row
                tableHeaderRowTitle.Cells.Add(tableHeaderCellBlank1);
                tableHeaderRowTitle.Cells.Add(tableHeaderCellBlank2);
                tableHeaderRowTitle.Cells.Add(tableHeaderCellTemplateName);
                #region--Comented Code By Pradeep
                //---------Star Conmentd by Pradeep as coment on task#15(Venture)
                //tableHeaderRowTitle.Cells.Add(tableHeaderCellInstruction);
                //tableHeaderRowTitle.Cells.Add(tableHeaderCellNumberOfDays);
                //tableHeaderRowTitle.Cells.Add(tableHeaderCellStrength);
                //tableHeaderRowTitle.Cells.Add(tableHeaderCellQuantity);
                //tableHeaderRowTitle.Cells.Add(tableHeaderCellUnit);
                //tableHeaderRowTitle.Cells.Add(tableHeaderCellSchedule);
                //tableHeaderRowTitle.Cells.Add(tableHeaderCellTitrationStepNumber);
                //tableHeaderRowTitle.Cells.Add(tableHeaderCellActive);
                //---------End Conmentd by Pradeep as coment on task#15(Venture)
                #endregion
                tableHeaderRowTitle.Cells.Add(tableHeaderCellCreatedBy);
                tableHeaderRowTitle.CssClass = "GridViewHeaderText";
                //---End Adding Heade Cell in Header Row
                //-----Start 13 nov
                if (Session["DataSetTitrationTemplate"] != null)
                {
                    dataSetTitrationTemplate = (DataSet)Session["DataSetTitrationTemplate"];

                }
                dataRow = dataSetTitrationTemplate.Tables["TitrationTemplates"].Select();
                tableTitrationTemplateList.Controls.Add(tableHeaderRowTitle);

                string myscript = "<script id='TitrationTemplateList' type='text/javascript'>";
                myscript += "function RegisterTitrationTemplateControlEvents(){try{ ";
                if (dataRow.Length > 0)
                {
                    // this.LabelDrugName.Text = dataRow[0]["MedicationName"].ToString();
                    foreach (DataRow dataRowTitrationTemplate in dataRow)
                    {
                        tableTitrationTemplateList.Rows.Add(this.GenerateTitrationTemplateSubRow(dataRowTitrationTemplate, tableTitrationTemplateList.ClientID, ref myscript));
                    }
                }
                //-----For Seperater Line---
                TableRow trLine = new TableRow();
                TableCell tdHorizontalLine = new TableCell();
                tdHorizontalLine.ColumnSpan = 4;//--Changed value 12 to 13 as per task#32
                tdHorizontalLine.CssClass = "blackLine";
                trLine.Cells.Add(tdHorizontalLine);
                tableTitrationTemplateList.Rows.Add(trLine);

                //PanelTitrationTraperList.Controls.Add(tableTitrationTemplateList);
                myscript += "}catch(e){  Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);}}</script>";
                // Page.RegisterClientScriptBlock(this.ClientID, myscript);
                //ScriptManager.RegisterStartupScript(this.LabelDrugName, LabelDrugName.GetType(), LabelDrugName.ClientID.ToString(), myscript, false);


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
        /// <Description>Used to fill data into each Row in table </Description>
        /// <Author>Pradeep</Author>
        /// <CreatedOn>Nov 12,2009</CreatedOn>
        /// </summary>
        /// <param name="dataRowTitarationTemplate"></param>
        /// <returns></returns>
        private TableRow GenerateTitrationTemplateSubRow(DataRow dataRowTitarationTemplate, string tableId, ref string myscript)
        {
            try
            {
                CommonFunctions.Event_Trap(this);
                string newId = System.Guid.NewGuid().ToString();
                // string tblId = this.ClientID + this.ClientIDSeparator + tableId;
                int titrationTemplateId = Convert.ToInt32(dataRowTitarationTemplate["TitrationTemplateId"]);


                TableRow tableRow = new TableRow();
                tableRow.ID = "Tr_" + newId;

                // string rowId = this.ClientID + this.ClientIDSeparator + tableRow.ClientID;
                //----Start For Delete Icon---
                TableCell tdDelete = new TableCell();
                HtmlImage imgDelete = new HtmlImage();
                imgDelete.ID = "Img_" + titrationTemplateId.ToString();
                imgDelete.Attributes.Add("TitrationTemplateId", dataRowTitarationTemplate["TitrationTemplateId"].ToString());
                imgDelete.Src = "~/App_Themes/Includes/Images/deleteIcon.gif";
                imgDelete.Attributes.Add("class", "handStyle");
                tdDelete.Controls.Add(imgDelete);

                //myscript += "var Imagecontext" + titrationTemplateId + "={TitrationTemplateId:'" + titrationTemplateId + "',TableId:'" + tableId + "',RowId:'" + rowId + "'};";
                //myscript += "var ImageclickCallback" + titrationTemplateId + " =";
                //myscript += " Function.createCallback($deleteRecord, Imagecontext" + titrationTemplateId + ");";
                //myscript += "$addHandler($get('" + this.ClientID + this.ClientIDSeparator + imgDelete.ClientID + "'), 'click', ImageclickCallback" + titrationTemplateId + ");";

                myscript += "var Imagecontext" + titrationTemplateId + ";";
                myscript += "var ImageclickCallback" + titrationTemplateId + " =";
                myscript += " Function.createCallback(ClientMedicationOrder.DeleteRow , Imagecontext" + titrationTemplateId + ");";
                myscript += "$addHandler($get('" + imgDelete.ClientID + "'), 'click', ImageclickCallback" + titrationTemplateId + ");";



                //----End For Delete Icon---
                TableCell tdRadioButton = new TableCell();
                HtmlInputRadioButton radioButtonTemp = new HtmlInputRadioButton();
                radioButtonTemp.Attributes.Add("TitrationTemplateId", dataRowTitarationTemplate["TitrationTemplateId"].ToString());
                radioButtonTemp.ID = "Rb_" + titrationTemplateId.ToString();
                tdRadioButton.Controls.Add(radioButtonTemp);
                TableCell tdTemplateName = new TableCell();
                tdTemplateName.Text = dataRowTitarationTemplate["TemplateName"] == DBNull.Value ? string.Empty : Convert.ToString(dataRowTitarationTemplate["TemplateName"]);
                tdTemplateName.CssClass = "Label";
                TableCell tdCreatedBy = new TableCell();
                tdCreatedBy.Text = Convert.ToString(dataRowTitarationTemplate["CreatedBy"]);
                tdCreatedBy.CssClass = "Label";

                //--End For Other Columns value

                tableRow.Cells.Add(tdDelete);
                tableRow.Cells.Add(tdRadioButton);
                tableRow.Cells.Add(tdTemplateName);
                //---Start Comented By Pradeep as per coment on task#15
                //tableRow.Cells.Add(tdNumberOfDays);
                //tableRow.Cells.Add(tdStrength);
                //tableRow.Cells.Add(tdQuantity);
                //tableRow.Cells.Add(tdUnit);
                //tableRow.Cells.Add(tdSchedule);
                //tableRow.Cells.Add(tdTitrationStepNumber);
                //tableRow.Cells.Add(tdActive);
                //---End Comented By Pradeep as per coment on task#15
                tableRow.Cells.Add(tdCreatedBy);

                return tableRow;
            }
            catch (Exception ex)
            {
                throw (ex);
            }
        }
        #region---User Defined Variables and Properties
        public delegate void DeleteButtonClick(object sender, Streamline.BaseLayer.UserData e);
        public event DeleteButtonClick DeleteButtonClickEvent;

        // public delegate void RadioButtonClick(object sender, Streamline.BaseLayer.UserData e);
        //public event RadioButtonClick RadioButtonClickEvent;

        Streamline.UserBusinessServices.DataSets.DataSetTitrationTemplate _dsTitrationTemplate = null;
        Streamline.UserBusinessServices.DataSets.DataSetTitrationTemplate.TitrationTemplatesDataTable _dtTitrationTemplate = null;
        Streamline.UserBusinessServices.DataSets.DataSetTitrationTemplate.TitrationTemplateInstructionsDataTable _dtTitrationTemplateInstructionsDataTable = null;

        private string _sortString;

        public string SortString
        {
            get { return _sortString; }
            set { _sortString = value; }
        }

        private string _onRadioClickEventHandler = "onRadioClick";

        public string onRadioClickEventHandler
        {
            get { return _onRadioClickEventHandler; }
            set { _onRadioClickEventHandler = value; }
        }
        private string _onDeleteEventHandler = "onDeleteClick";

        public string onDeleteEventHandler
        {
            get { return _onDeleteEventHandler; }
            set { _onDeleteEventHandler = value; }
        }

        private string _deleteRowMessage = "Are you sure you want to delete this row?";
        public string DeleteRowMessage
        {
            get { return _deleteRowMessage; }
            set { _deleteRowMessage = value; }
        }

        private string _onHeaderClick = "ClientMedicationOrder.onHeaderClick";

        public string OnHeaderClick
        {
            get { return _onHeaderClick; }
            set { _onHeaderClick = value; }
        }
        /// <summary>
        /// <Description>Used to set atributes for sorting purpose</Description>
        /// <Author>Pradeep</Author>
        /// <CreatedOn>Nov 12,2009</CreatedOn>
        /// </summary>
        /// <returns></returns>
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
        #endregion
        #endregion

        /// <summary>
        /// <Decription>Used to Delete all titration instructions from ClientMedicationInstructions table</Decription>
        /// <Author>Anuj</Author>
        /// <CreatedOn>Nov 13,2009</CreatedOn>
        /// </summary>               
        /// <returns></returns>
        [WebMethod(EnableSession = true)]
        public bool DeleteAllTitrateInstructions()
        {
            bool _tempflag = false;
            try
            {
                Streamline.UserBusinessServices.DataSets.DataSetClientMedications _dataSetTitration = null;
                DataTable _DataTableClientMedication = null;
                DataTable _DataTableClientMedicationInstructions = null;
                DataTable _DataTableClientMedicationScriptDrugs = null;
                if (Session["DataSetTitration"] != null)
                {
                    _dataSetTitration = (Streamline.UserBusinessServices.DataSets.DataSetClientMedications)Session["DataSetTitration"];
                }
                else
                {
                    _dataSetTitration = new Streamline.UserBusinessServices.DataSets.DataSetClientMedications();
                }
                _DataTableClientMedication = _dataSetTitration.ClientMedications;
                _DataTableClientMedicationInstructions = _dataSetTitration.ClientMedicationInstructions;
                _DataTableClientMedicationScriptDrugs = _dataSetTitration.ClientMedicationScriptDrugs;
                DataRow[] drClientMedicationInstruction = _DataTableClientMedicationInstructions.Select("ISNULL(RecordDeleted,'N')<>'Y'");
                if (drClientMedicationInstruction.Length > 0)
                {
                    for (int i = 0; i < drClientMedicationInstruction.Length; i++)
                    //foreach (DataRow drClientMedicationInstruction in drMedInstructions)
                    {
                        if (drClientMedicationInstruction[i]["DBdata"].ToString() != "Y")
                        {
                            drClientMedicationInstruction[i].Delete();
                            _tempflag = true;
                        }
                        else
                        {
                            drClientMedicationInstruction[i]["RecordDeleted"] = "Y";
                            drClientMedicationInstruction[i]["DeletedDate"] = Convert.ToDateTime(DateTime.Now.ToShortDateString());
                            drClientMedicationInstruction[i]["DeletedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                            _tempflag = true;

                            DataRow[] drClientMedicationScriptDrugs = _DataTableClientMedicationScriptDrugs.Select("ClientMedicationInstructionId=" + drClientMedicationInstruction[i]["ClientMedicationInstructionId"]);
                            for (int j = 0; j < drClientMedicationScriptDrugs.Length; j++)
                            //foreach (DataRow drClientMedicationScriptDrugs in _DataTableClientMedicationScriptDrugs.Rows)
                            {
                                drClientMedicationScriptDrugs[j]["RecordDeleted"] = "Y";
                                drClientMedicationScriptDrugs[j]["DeletedDate"] = Convert.ToDateTime(DateTime.Now.ToShortDateString());
                                drClientMedicationScriptDrugs[j]["DeletedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode; ;
                            }
                        }
                    }
                }
                return _tempflag;
                Session["DataSetTitration"] = _dataSetTitration;
            }
            catch (Exception)
            {
                return false;
            }
        }
        /// <summary>
        /// <Decription>Used to Set the titration template on Titration Page</Decription>
        /// <Author>Anuj</Author>
        /// <CreatedOn>Nov 17,2009</CreatedOn>
        /// </summary>               
        /// <returns></returns>
        [WebMethod(EnableSession = true)]
        public string SetTitrationTemplate(int TitrationTemplateId, DateTime TitrationStartDate)
        {
            //bool _tempflag = false;
            DateTime TitrationNextStartDate = new DateTime();
            //Added by Malathi Shiva: Harbor 3.5 Implementation Task# 197 , Purpose: Titrate Functionality was not working correctly in case of "Use Template". The Start/End date calculation was incorrect
            DateTime TitrationTaperDate = new DateTime();
            TitrationTaperDate = Convert.ToDateTime(TitrationStartDate);
            DataSet _dataSetTitrationTemplateSet = new DataSet();
            //DataSet _dataSetTitration = new DataSet();
            Streamline.UserBusinessServices.DataSets.DataSetClientMedications _dataSetTitration = null;
            Streamline.SmartClient.WebServices.CommonService objectCommonService = null;
            objectCommonService = new CommonService();
            bool newRowCMSD = true;
            bool newRowCMI = true;
            int iMaxClientMedicationScriptDrugId = 0;
            int iMaxClientMedicationInstructionId = 0;
            int iMaxClientMedicationScriptDrugStrengthId = 0;
            DataSet _dataSetTitrationTemp = null;
            DataTable DataTableClientMedicationScriptDrugs = null;
            DataTable DataTableClientMedicationInstructions = null;
            DataTable DataTableClientMedicationScriptDrugsStrengths = null;
            try
            {

                if (Session["DataSetClientMedications"] != null)
                {
                    _dataSetTitrationTemp = (Streamline.UserBusinessServices.DataSets.DataSetClientMedications)Session["DataSetClientMedications"];
                    iMaxClientMedicationInstructionId = GetMinValue(Convert.ToInt32(_dataSetTitrationTemp.Tables["ClientMedicationInstructions"].Compute("Min(ClientMedicationInstructionId)", "")));
                    iMaxClientMedicationScriptDrugId = GetMinValue(Convert.ToInt32(_dataSetTitrationTemp.Tables["ClientMedicationScriptDrugs"].Compute("Min(ClientMedicationScriptDrugId)", "")));
                    iMaxClientMedicationScriptDrugStrengthId = GetMinValue(Convert.ToInt32(_dataSetTitrationTemp.Tables["ClientMedicationScriptDrugStrengths"].Compute("Min(ClientMedicationScriptDrugStrengthId)", "")));
                }
                _dataSetTitrationTemplateSet = (DataSet)Session["DataSetTitrationTemplate"];
                // _dataSetTitration = (DataSet)Session["DataSetTitration"];
                if (Session["DataSetTitration"] != null)
                    _dataSetTitration = (Streamline.UserBusinessServices.DataSets.DataSetClientMedications)Session["DataSetTitration"];
                else
                    _dataSetTitration = new Streamline.UserBusinessServices.DataSets.DataSetClientMedications();

                if (_dataSetTitrationTemplateSet != null && _dataSetTitrationTemplateSet.Tables["TitrationTemplateInstructions"].Rows.Count > 0)
                {
                    DataRow[] _dataRowTitrationTemplateInstructions = _dataSetTitrationTemplateSet.Tables["TitrationTemplateInstructions"].Select("TitrationTemplateId=" + TitrationTemplateId + "and ISNULL(RecordDeleted,'N')='N'");//"ISNULL(RecordDeleted,'N')<>'Y'");                   
                    int _clientMedicationId = 0;

                    if (_dataRowTitrationTemplateInstructions.Length > 0)
                    {
                        if (_dataSetTitration != null)
                        {
                            _clientMedicationId = Convert.ToInt32(_dataSetTitration.Tables["ClientMedications"].Rows[0]["ClientMedicationId"].ToString());
                            DeleteAllTitrateInstructions();

                            //Added by Chandan to add records in Client Medication Scripts tabls
                            DataRow drClientMedicationScripts;
                            if (_dataSetTitration.Tables["ClientMedicationScripts"].Rows.Count < 1)
                                drClientMedicationScripts = _dataSetTitration.Tables["ClientMedicationScripts"].NewRow();
                            else
                                drClientMedicationScripts = _dataSetTitration.Tables["ClientMedicationScripts"].Rows[0];
                            drClientMedicationScripts["Clientid"] = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId;
                            drClientMedicationScripts["OrderingMethod"] = "P";
                            drClientMedicationScripts["PharmacyId"] = System.DBNull.Value;
                            drClientMedicationScripts["PrintDrugInformation"] = System.DBNull.Value;
                            drClientMedicationScripts["ScriptCreationDate"] = DateTime.Now;
                            drClientMedicationScripts["OrderDate"] = DateTime.Now;
                            drClientMedicationScripts["LocationId"] = System.DBNull.Value;
                            drClientMedicationScripts["ScriptEventType"] = "C";
                            drClientMedicationScripts["OrderingPrescriberId"] = 731;
                            drClientMedicationScripts["OrderingPrescriberName"] = "dnf";
                            drClientMedicationScripts["RowIdentifier"] = System.Guid.NewGuid();
                            drClientMedicationScripts["CreatedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                            drClientMedicationScripts["CreatedDate"] = DateTime.Now;
                            drClientMedicationScripts["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                            drClientMedicationScripts["ModifiedDate"] = DateTime.Now;
                            if (_dataSetTitration.Tables["ClientMedicationScripts"].Rows.Count < 1)
                                _dataSetTitration.Tables["ClientMedicationScripts"].Rows.Add(drClientMedicationScripts);


                            int NewStepNumber = 0;
                            double PreviousStepDays = 0;
                            foreach (DataRow _drTitrationTemplateInstructions in _dataRowTitrationTemplateInstructions)
                            {

                                //DataRow _drClientMedicationInstructions = _dataSetTitration.Tables["ClientMedicationInstructions"].NewRow();
                                DataRow _drClientMedicationInstructions = null;
                                DataRow[] _dataRowTitrationStepCalculation = null;
                                DataTableClientMedicationInstructions = _dataSetTitration.ClientMedicationInstructions;
                                _drClientMedicationInstructions = DataTableClientMedicationInstructions.NewRow();
                                if (DataTableClientMedicationInstructions.Rows.Count > 0)
                                {
                                    if (newRowCMI == true)
                                        _drClientMedicationInstructions["ClientMedicationInstructionId"] = GetMinValue(Convert.ToInt32(DataTableClientMedicationInstructions.Compute("Min(ClientMedicationInstructionId)", "")));
                                }
                                else
                                {
                                    _drClientMedicationInstructions["ClientMedicationInstructionId"] = iMaxClientMedicationInstructionId;
                                }


                                NewStepNumber = Convert.ToInt32(_drTitrationTemplateInstructions["TitrationStepNumber"]);
                                _drClientMedicationInstructions["ClientMedicationId"] = iMaxClientMedicationInstructionId;
                                _drClientMedicationInstructions["ClientMedicationId"] = Convert.ToInt32(_clientMedicationId);
                                _drClientMedicationInstructions["StrengthId"] = Convert.ToInt32(_drTitrationTemplateInstructions["StrengthId"]);
                                _drClientMedicationInstructions["Quantity"] = Convert.ToDecimal(_drTitrationTemplateInstructions["Quantity"]);
                                _drClientMedicationInstructions["Unit"] = Convert.ToInt32(_drTitrationTemplateInstructions["Unit"]);
                                _drClientMedicationInstructions["Schedule"] = Convert.ToString(_drTitrationTemplateInstructions["Schedule"]);
                                _drClientMedicationInstructions["TitrationStepNumber"] = Convert.ToInt32(_drTitrationTemplateInstructions["TitrationStepNumber"]);
                                _drClientMedicationInstructions["Active"] = Convert.ToString(_drTitrationTemplateInstructions["Active"]);

                                _drClientMedicationInstructions["Days"] = Convert.ToInt32(_drTitrationTemplateInstructions["NumberOfDays"]);
                                //_drClientMedicationInstructions["MedicationNameId"] = Convert.ToInt32(_drTitrationTemplateInstructions["MedicationNameId"]);
                                _drClientMedicationInstructions["Instruction"] = Convert.ToString(_drTitrationTemplateInstructions["Instruction"]);
                                if (NewStepNumber > 1)
                                {
                                    //Added by Malathi Shiva: Harbor 3.5 Implementation Task# 197 , Purpose: Titrate Functionality was not working correctly in case of "Use Template". The Start/End date calculation was incorrect
                                    _dataRowTitrationStepCalculation = _dataSetTitrationTemplateSet.Tables["TitrationTemplateInstructions"].Select("TitrationStepNumber<>" + (Convert.ToInt32(_drTitrationTemplateInstructions["TitrationStepNumber"])) + " and TitrationTemplateId=" + TitrationTemplateId + "and ISNULL(RecordDeleted,'N')='N' and TitrationStepNumber<" + (Convert.ToInt32(_drTitrationTemplateInstructions["TitrationStepNumber"])));
                                    for (int i = 0; i < _dataRowTitrationStepCalculation.Count(); i++)
                                    {
                                        PreviousStepDays = PreviousStepDays + Convert.ToDouble(_dataRowTitrationStepCalculation[i]["NumberOfDays"]);
                                    }
                                    TitrationStartDate = TitrationTaperDate.AddDays(PreviousStepDays);
                                    PreviousStepDays = 0;
                                }
                                else
                                {
                                    TitrationStartDate = TitrationTaperDate;
                                }

                                _drClientMedicationInstructions["StartDate"] = TitrationStartDate;

                                //DateTime _firstStepDate = Convert.ToDateTime(_dataRowTitrationTemplateInstructions[0]["StartDate"]);
                                //DataRow[] _dataRowAllInstructions = _dataTableClientMedicationInstructions.Select("ISNULL(RecordDeleted,'N')<>'Y'");
                                //foreach (DataRow _drInstruction in _dataRowAllInstructions)
                                //{
                                //    _drInstruction["DayNumber"] = CalculateDayNumber(TitrationStartDate, Convert.ToDateTime(_drInstruction["StartDate"]));
                                //}
                                _drClientMedicationInstructions["DayNumber"] = CalculateDayNumber(TitrationStartDate, Convert.ToDateTime(_drClientMedicationInstructions["StartDate"]));




                                _drClientMedicationInstructions["EndDate"] = Convert.ToDateTime(CalculateEndDate(Convert.ToString(TitrationStartDate), Convert.ToInt32(_drTitrationTemplateInstructions["NumberOfDays"]), 0));
                                TitrationNextStartDate = Convert.ToDateTime(CalculateEndDate(Convert.ToString(TitrationStartDate), Convert.ToInt32(_drTitrationTemplateInstructions["NumberOfDays"]), 0));
                                _drClientMedicationInstructions["Refills"] = 0;
                                _drClientMedicationInstructions["Pharmacy"] = Convert.ToDecimal(objectCommonService.CalculatePharmacy(Convert.ToInt32(_drTitrationTemplateInstructions["NumberOfDays"]), Convert.ToDecimal(_drTitrationTemplateInstructions["Quantity"]), _drTitrationTemplateInstructions["Schedule"].ToString(), 0, 0));
                                _drClientMedicationInstructions["Sample"] = 0;
                                _drClientMedicationInstructions["Stock"] = 0;
                                _drClientMedicationInstructions["AutoCalcallow"] = "Y";

                                _drClientMedicationInstructions["CreatedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                                _drClientMedicationInstructions["CreatedDate"] = DateTime.Now;
                                _drClientMedicationInstructions["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                                _drClientMedicationInstructions["ModifiedDate"] = DateTime.Now;
                                _drClientMedicationInstructions["RowIdentifier"] = System.Guid.NewGuid();
                                _dataSetTitration.Tables["ClientMedicationInstructions"].Rows.Add(_drClientMedicationInstructions);

                                //_tempflag = true;
                                //Added by Chandan on 20th Dec 2009
                                //Added for generat unique Instruction ID for new dataset with comparing the original dataset because we have to merge it with original dataset

                                DataRow DataRowClientMedicationScriptDrugs = null;
                                DataRow DataRowClientMedicationScriptDrugStrengths = null;
                                DataTableClientMedicationScriptDrugs = _dataSetTitration.ClientMedicationScriptDrugs;
                                DataRowClientMedicationScriptDrugs = DataTableClientMedicationScriptDrugs.NewRow();
                                if (DataTableClientMedicationScriptDrugs.Rows.Count > 0)
                                {
                                    int tempcount = 0;

                                    tempcount = Convert.ToInt32(DataTableClientMedicationScriptDrugs.Rows[DataTableClientMedicationScriptDrugs.Rows.Count - 1]["ClientMedicationScriptDrugId"]);
                                    if (newRowCMSD == true)
                                        DataRowClientMedicationScriptDrugs["ClientMedicationScriptDrugId"] = tempcount + 1;
                                }
                                else
                                {
                                    DataRowClientMedicationScriptDrugs["ClientMedicationScriptDrugId"] = iMaxClientMedicationScriptDrugId;
                                }
                                DataRowClientMedicationScriptDrugs["ClientMedicationScriptId"] = _dataSetTitration.Tables["ClientMedicationScripts"].Rows[0]["ClientMedicationScriptId"];
                                DataRowClientMedicationScriptDrugs["ClientMedicationInstructionId"] = _drClientMedicationInstructions["ClientMedicationInstructionId"];
                                DataRowClientMedicationScriptDrugs["StartDate"] = TitrationStartDate;
                                DataRowClientMedicationScriptDrugs["Days"] = Convert.ToInt32(_drTitrationTemplateInstructions["NumberOfDays"]);
                                DataRowClientMedicationScriptDrugs["Pharmacy"] = Convert.ToDecimal(objectCommonService.CalculatePharmacy(Convert.ToInt32(_drTitrationTemplateInstructions["NumberOfDays"]), Convert.ToDecimal(_drTitrationTemplateInstructions["Quantity"]), _drTitrationTemplateInstructions["Schedule"].ToString(), 0, 0));
                                DataRowClientMedicationScriptDrugs["Sample"] = 0;
                                DataRowClientMedicationScriptDrugs["Stock"] = 0;
                                DataRowClientMedicationScriptDrugs["Refills"] = 0;
                                DataRowClientMedicationScriptDrugs["EndDate"] = Convert.ToDateTime(CalculateEndDate(Convert.ToString(TitrationStartDate), Convert.ToInt32(_drTitrationTemplateInstructions["NumberOfDays"]), 0));

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
                                
                               //////////////////////////Added By Prem Reddy as part Valley Build Cycle tasks #16
                                DataTableClientMedicationScriptDrugsStrengths = _dataSetTitration.ClientMedicationScriptDrugStrengths;
                                DataRowClientMedicationScriptDrugStrengths = DataTableClientMedicationScriptDrugsStrengths.NewRow();
                                if (DataTableClientMedicationScriptDrugsStrengths.Rows.Count > 0)
                                {
                                    int rowcount = 0;

                                    rowcount = Convert.ToInt32(DataTableClientMedicationScriptDrugsStrengths.Rows[DataTableClientMedicationScriptDrugsStrengths.Rows.Count - 1]["ClientMedicationScriptDrugStrengthId"]);
                                    if (newRowCMSD == true)
                                        DataRowClientMedicationScriptDrugStrengths["ClientMedicationScriptDrugStrengthId"] = rowcount + 1;
                                }
                                else
                                {
                                    DataRowClientMedicationScriptDrugStrengths["ClientMedicationScriptDrugStrengthId"] = iMaxClientMedicationScriptDrugStrengthId;
                                }
                                DataRowClientMedicationScriptDrugStrengths["ClientMedicationScriptId"] = _dataSetTitration.Tables["ClientMedicationScripts"].Rows[0]["ClientMedicationScriptId"];
                                DataRowClientMedicationScriptDrugStrengths["Pharmacy"] = Convert.ToDecimal(objectCommonService.CalculatePharmacy(Convert.ToInt32(_drTitrationTemplateInstructions["NumberOfDays"]), Convert.ToDecimal(_drTitrationTemplateInstructions["Quantity"]), _drTitrationTemplateInstructions["Schedule"].ToString(), 0, 0));
                                DataRowClientMedicationScriptDrugStrengths["PharmacyText"] = null;
                                DataRowClientMedicationScriptDrugStrengths["Sample"] = 0;
                                DataRowClientMedicationScriptDrugStrengths["Stock"] = 0;
                                DataRowClientMedicationScriptDrugStrengths["StrengthId"] = Convert.ToInt32(_drTitrationTemplateInstructions["StrengthId"]);
                                DataRowClientMedicationScriptDrugStrengths["ClientMedicationId"] = Convert.ToInt32(_clientMedicationId);
                                DataRowClientMedicationScriptDrugStrengths["Refills"] = 0;
                                DataRowClientMedicationScriptDrugStrengths["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                                DataRowClientMedicationScriptDrugStrengths["ModifiedDate"] = DateTime.Now;

                                if (newRowCMSD == true)
                                {
                                    DataRowClientMedicationScriptDrugStrengths["RowIdentifier"] = System.Guid.NewGuid();
                                    DataRowClientMedicationScriptDrugStrengths["CreatedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                                    DataRowClientMedicationScriptDrugStrengths["CreatedDate"] = DateTime.Now;
                                }
                                if (newRowCMSD == true)
                                    DataTableClientMedicationScriptDrugsStrengths.Rows.Add(DataRowClientMedicationScriptDrugStrengths);
                                //////////////////////////Changes End
                            }
                            Session["DataSetTitration"] = _dataSetTitration;
                            //Added by Malathi Shiva - TAsk# 197 Harbor 3.5 Implementation
                            if (((System.DateTime)(DataTableClientMedicationScriptDrugs.Compute("MAX(EndDate)", null))).Date != null)
                            {
                                TitrationNextStartDate = ((System.DateTime)(DataTableClientMedicationScriptDrugs.Compute("MAX(EndDate)", null))).Date;
                            }
                            return TitrationNextStartDate.ToString(); ;
                        }
                    }
                }

                return TitrationNextStartDate.ToString();
            }
            catch (Exception ex)
            {
                return null;
            }
        }
        #region--Code Written by Pradeep as per task#23
        /// <summary>
        /// <Description>Used to filter data on basis of passed parameter from PrinterDeviceLocation table</Description>
        /// <Author>Pradeep</Author>
        /// <CreatedOn>19 Nov 2009</CreatedOn>
        /// </summary>
        /// <param name="selectedValue"></param>
        /// <returns></returns>
        [WebMethod(EnableSession = true)]
        public System.Web.UI.Pair FillPrinterDropDown(string selectedValue)
        {
            DataSet DataSetPrinterDeviceLocations = null;
            DataView DataViewPrinterDeviceLocations = null;
            DataRow[] DataRowPrinterDeviceLocations = null;
            DataRow[] DataRowStaffLocation = null;
            DataSet DataSetStaffLocation = null;
            int staffId;
            int locationId = 0;
            int printerDeviceLocationId = 0;
            try
            {

                if (selectedValue != string.Empty)
                {
                    locationId = Convert.ToInt32(selectedValue);
                    //Code added by Loveena in ref to Task#3129
                    Session["AssociatedLocation"] = selectedValue;
                }
                DataSetPrinterDeviceLocations = Streamline.UserBusinessServices.SharedTables.DataSetPrinterDeviceLocations.Clone();
                if (DataSetPrinterDeviceLocations != null)
                {
                    DataRowPrinterDeviceLocations = Streamline.UserBusinessServices.SharedTables.DataSetPrinterDeviceLocations.Tables[0].Select("LocationId=" + locationId, "DeviceLabel asc");
                    DataSetPrinterDeviceLocations.Merge(DataRowPrinterDeviceLocations);
                    DataSetPrinterDeviceLocations.Tables[0].TableName = "PrinterDeviceLocations";
                }
                staffId = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId;
                DataSetStaffLocation = Streamline.UserBusinessServices.SharedTables.DataSetStaffLocation;
                if (DataSetStaffLocation != null)
                {
                    DataRowStaffLocation = DataSetStaffLocation.Tables[0].Select("StaffId=" + staffId + " And LocationId=" + locationId);
                }
                if (DataRowStaffLocation.Length > 0)
                {
                    printerDeviceLocationId = Convert.ToInt32(DataRowStaffLocation[0]["PrescriptionPrinterLocationId"] == DBNull.Value ? "0" : DataRowStaffLocation[0]["PrescriptionPrinterLocationId"].ToString());
                }
                System.Web.UI.Pair pairToReturn = new Pair();
                pairToReturn.First = DataSetPrinterDeviceLocations.Tables[0];
                pairToReturn.Second = printerDeviceLocationId;
                return pairToReturn;
            }
            catch (Exception ex)
            {
                throw (ex);
            }

        }
        #endregion
        #region--Code Written By Pradeep as per task#32
        /// <summary>
        /// <Description>Used to send request to ubs to save permitchangesbyotherusers field in ClientMedication as per task#32</Description>
        /// <Author>Pradeep</Author>
        /// <CreatedOn>Nov 25,2009</CreatedOn>
        /// </summary>
        /// <param name="MedicationId"></param>
        /// <param name="PermithangesByOtherUsers"></param>
        /// <returns></returns>
        [WebMethod(EnableSession = true)]
        public int SavePermitChangesByOtherUsers(int MedicationId, char PermithangesByOtherUsers)
        {
            Streamline.UserBusinessServices.ClientMedication objClientMedications = null;

            try
            {
                objClientMedications = new Streamline.UserBusinessServices.ClientMedication();
                objClientMedications.SavePermitChangesByOtherUsers(MedicationId, PermithangesByOtherUsers, ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode);
                return 1;
            }
            catch (Exception ex)
            {

                return -1;
            }
            finally
            {
                objClientMedications = null;
            }
        }
        #endregion

        #region DeleteHealthDataRecord
        /// <summary>
        /// <Decription>Used to delete the health Data record  for passes HealthDataId</Decription>
        /// <Author>Anuj</Author>
        /// <CreatedOn>Nov 26,2009</CreatedOn>
        /// </summary>               
        /// <returns></returns>
        [WebMethod(EnableSession = true)]
        public string DeleteHealthDataRecord(int HealthDataId)
        {
            string result = "";
            Streamline.UserBusinessServices.ClientMedication objectClientMedications;
            objectClientMedications = new ClientMedication();
            try
            {
                objectClientMedications.DeleteHeathDataRecord(HealthDataId, ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode);
                result = "update"; //"HealthDataDeleted";
            }
            catch (Exception ex)
            {
            }
            finally
            {

            }
            return result;
        }
        #endregion


        [WebMethod(EnableSession = true)]
        public DataTable FillHealthData()
        {
            Streamline.UserBusinessServices.ClientMedication objectClientMedications;
            DataSet _DataSetHealthDataCategory = null;
            _DataSetHealthDataCategory = new DataSet();
            int ClientId = 0;
            ClientId = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId;
            objectClientMedications = new ClientMedication();
            _DataSetHealthDataCategory = objectClientMedications.GetHeathDataCategories(ClientId);
            return _DataSetHealthDataCategory.Tables["HealthDataCategory"];
        }

        [WebMethod(EnableSession = true)]
        public DataTable FillReconciliationDropDown()
        {
            Streamline.UserBusinessServices.ClientMedication objectClientMedications;
            DataSet _DataSetReconciliationDataCategory = new DataSet();
            int ClientId = 0;
            ClientId = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId;
            objectClientMedications = new ClientMedication();
            _DataSetReconciliationDataCategory = objectClientMedications.GetReconciliationDropDown(ClientId);
            return _DataSetReconciliationDataCategory.Tables["ReconciliationDropDownList"];
        }


        [WebMethod(EnableSession = true)]
        public DataTable FillMedReconciliationDropDown()
        {
            Streamline.UserBusinessServices.ClientMedication objectClientMedications;
            DataSet _DataSetMedReconciliationDataCategory = new DataSet();
            // int ClientId = 0;
            //ClientId = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId;
            objectClientMedications = new ClientMedication();
            _DataSetMedReconciliationDataCategory = objectClientMedications.GetMedReconciliationDropDown();
            return _DataSetMedReconciliationDataCategory.Tables["MedReconciliationDropDownList"];
        }

        [WebMethod(EnableSession = true)]
        public DataTable GetGrowthChartCategories()
        {
            Streamline.UserBusinessServices.ClientMedication objClientMed = new ClientMedication();
            return objClientMed.GetGrowthChartCategories(((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId);
        }

        [WebMethod(EnableSession = true)]
        public string GetGrowthChartImage(string dropdownVal, string reqType)
        {
            Streamline.UserBusinessServices.ClientMedication objClientMed = new ClientMedication();
            DataSet growthChartDS = objClientMed.GetGrowthChartData(((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId, Convert.ToInt32(dropdownVal));

            string returnval = "";
            GROWTHCHARTLib.GrowthChart myChart = new GROWTHCHARTLib.GrowthChart();
            if (growthChartDS != null && growthChartDS.Tables["GrowthChartClient"] != null && growthChartDS.Tables["GrowthChartClient"].Rows.Count > 0)
            {
                try
                {
                    // init the growth chart
                    myChart.GrowthChartType = Convert.ToInt32(dropdownVal);
                    myChart.FirstName = growthChartDS.Tables["GrowthChartClient"].Rows[0]["FirstName"].ToString();
                    myChart.LastName = growthChartDS.Tables["GrowthChartClient"].Rows[0]["LastName"].ToString();
                    myChart.Gender = Convert.ToInt32(growthChartDS.Tables["GrowthChartClient"].Rows[0]["Gender"].ToString());
                    myChart.RecordID = Convert.ToInt32(growthChartDS.Tables["GrowthChartClient"].Rows[0]["ClientId"].ToString());

                    foreach (DataRow dr in growthChartDS.Tables["GrowthChartData"].Rows)
                    {
                        int index = myChart.AddNewData();
                        if (!String.IsNullOrEmpty(dr["AgeInMonths"].ToString())) { myChart.SetAge(index, (Int32)dr["AgeInMonths"]); }
                        if (!String.IsNullOrEmpty(dr["WeightInKg"].ToString())) { myChart.SetWeight(index, (float)Convert.ToDecimal(dr["WeightInKg"])); }
                        if (!String.IsNullOrEmpty(dr["HeightInCM"].ToString())) { myChart.SetHeight(index, (float)Convert.ToDecimal(dr["HeightInCM"])); }
                        if (!String.IsNullOrEmpty(dr["HeadCircumferenceInCM"].ToString())) { myChart.SetHeadCir(index, (float)Convert.ToDecimal(dr["HeadCircumferenceInCM"])); }
                        if (!String.IsNullOrEmpty(dr["DateRecorded"].ToString())) { myChart.SetTestDate(index, (DateTime)dr["DateRecorded"]); }
                    }
                }
                catch (Exception ex) { }
            }
            if (reqType.ToLower().Equals("img"))
            {
                // remove all images inside the folder
                try
                {
                    using (Streamline.BaseLayer.RDLCPrint objRDLC = new RDLCPrint())
                    {
                        objRDLC.DeleteRenderedImages(Server.MapPath("~/RDLC/JPEGS/" + Context.User.Identity.Name.Replace(" ", "_")));
                    }
                }
                catch (Exception ex) { }

                string strFilename;
                DateTime dtCurr = DateTime.Now;
                strFilename = dtCurr.ToString("MMddyyyyhhmmss") + ".bmp";
                string szFile = Server.MapPath("~/RDLC/JPEGS/" + Context.User.Identity.Name.Replace(" ", "_") + "/");
                if (!System.IO.Directory.Exists(szFile))
                    System.IO.Directory.CreateDirectory(szFile);
                myChart.SaveChartToBMP(szFile + strFilename);
                returnval = "RDLC/JPEGS/" + Context.User.Identity.Name.Replace(" ", "_") + "/" + strFilename;
            }
            else
            {
                myChart.PrintChart();
            }
            return returnval;
        }

        [WebMethod(EnableSession = true)]
        public DataTable FillHealthGraph()
        {
            Streamline.UserBusinessServices.ClientMedication objectClientMedications;
            DataSet _DataSetHealthDataListGraph = null;
            _DataSetHealthDataListGraph = new DataSet();
            int ClientId = 0;
            ClientId = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId;
            objectClientMedications = new ClientMedication();
            _DataSetHealthDataListGraph = objectClientMedications.GetHeathDataCategories(ClientId);
            return _DataSetHealthDataListGraph.Tables["HealthDataCategory"];
        }
        //Added by Anuj Tomar on 14 Dec,2009 for task ref # 15 SDI Projects FY10 - Venture
        //This Function will check TitrationTemplateInstructions in table.
        [WebMethod(EnableSession = true)]
        public string CheckTitrationInstructions(int MedicationNameId)
        {
            DataSet _dataSetTitrationTemplate = new DataSet();
            DataSet _dataSetMedication = new DataSet();
            Streamline.UserBusinessServices.ClientMedication objClientMedication = null;
            try
            {
                if (Session["DataSetTitration"] != null)
                {
                    _dataSetTitrationTemplate = (Streamline.UserBusinessServices.DataSets.DataSetClientMedications)Session["DataSetTitration"];
                    objClientMedication = new ClientMedication();


                    if (_dataSetTitrationTemplate.Tables["ClientMedicationInstructions"].Rows.Count > 0)
                    {

                        DataRow[] _dataRowClientMedicationInstructions = _dataSetTitrationTemplate.Tables["ClientMedicationInstructions"].Select("ISNULL(RecordDeleted,'N')<>'Y'");
                        if (_dataRowClientMedicationInstructions.Length <= 0)
                        {
                            throw new Exception("Please add atleast one titration step.");
                        }
                        else
                        {

                            return "true";
                        }
                    }
                    else
                    {
                        throw new Exception("Please add atleast one titration step.");//return "false";
                    }

                }
                return "Session has expired";
            }
            catch (Exception ex)
            {
                if (Session["SessionTimeOut"] == null)
                {
                    return "Session Expired";
                }
                else
                {
                    return ex.Message;
                }
            }
            finally
            {
                _dataSetTitrationTemplate = null;
            }
        }

        //Getting latest version id
        [WebMethod(EnableSession = true)]
        public int GetLatestDocumentVersionIdForClientMedication(int ClientMedicationConsentId)
        {
            DataSet _dataSetCleintMedicationVersionId = new DataSet();
            Streamline.UserBusinessServices.ClientMedication objClientMedication = null;
            int clientMedicationversionId = 0;
            try
            {
                objClientMedication = new ClientMedication();
                _dataSetCleintMedicationVersionId = objClientMedication.GetClientMedicationversionId(ClientMedicationConsentId);
                if (_dataSetCleintMedicationVersionId.Tables.Count > 0 && _dataSetCleintMedicationVersionId.Tables["TableClientMedicationVersionId"].Rows.Count > 0 && _dataSetCleintMedicationVersionId != null)
                {
                    clientMedicationversionId = Convert.ToInt32(_dataSetCleintMedicationVersionId.Tables["TableClientMedicationVersionId"].Rows[0]["documentversionID"].ToString());
                }

                Session["VersionIdForConsentDetailPage"] = clientMedicationversionId;
                return clientMedicationversionId;
            }
            catch (Exception ex)
            {
                if (Session["SessionTimeOut"] == null)
                {

                }
                else
                {

                }
                return 0;
            }
            finally
            {
                _dataSetCleintMedicationVersionId = null;
            }
        }

        [WebMethod(EnableSession = true)]
        public System.Web.UI.Pair GetClientMedicationId(int ClientMedicationConsentId)
        {
            Streamline.UserBusinessServices.ClientMedication objClientMedication = null;
            string clientMedicationIds = "";
            DataRow[] dr = null;
            System.Web.UI.Pair pairResult = new Pair();
            try
            {
                objClientMedication = new ClientMedication();
                Session["ChangedOrderMedicationIds"] = null;
                DataSet dataSetConsentInstruction = objClientMedication.GetClientMedicationversionId(ClientMedicationConsentId);

                if (Session["DataSetClientSummary"] != null)
                {
                    DataSet dataSetConsnetHistory = (DataSet)Session["DataSetClientSummary"];
                    for (short index = 0; index < dataSetConsentInstruction.Tables["ClientMedicationInstructions"].Rows.Count; index++)
                    {
                        dr = dataSetConsnetHistory.Tables["ClientMedicationInstructions"].Select("ClientMedicationInstructionId=" + dataSetConsentInstruction.Tables["ClientMedicationInstructions"].Rows[index]["ClientMedicationInstructionId"]);
                        if (dr.Length > 0)
                        {
                            if (clientMedicationIds == "")
                            {
                                clientMedicationIds += Convert.ToString(dr[0]["ClientMedicationId"]);
                            }
                            else
                            {
                                clientMedicationIds += "," + Convert.ToString(dr[0]["ClientMedicationId"]);
                            }
                        }
                    }
                }
                Session["ChangedOrderMedicationIds"] = clientMedicationIds;
                Session["VersionIdForConsentDetailPage"] = Convert.ToInt32(dataSetConsentInstruction.Tables["DocumentVersionId"].Rows[0]["DocumentVersionId"]);
                pairResult.First = Convert.ToInt32(dataSetConsentInstruction.Tables["DocumentVersionId"].Rows[0]["DocumentVersionId"]);
                pairResult.Second = clientMedicationIds;
                return pairResult;
            }
            catch (Exception ex)
            {
                throw (ex);
            }
        }
        [WebMethod(EnableSession = true)]
        public string SaveComments(int AllergyId, string AllergyType, string AllergyActive, string comments, string FilterList)
        {
            Streamline.UserBusinessServices.ClientMedication objClientMedications;
            DataSet DataSetFinal = null;
            DataSet _DataSetClientSummary;
            Streamline.UserBusinessServices.DataSets.DataSetClientAllergies DataSetClientAllergies = null;
            string result = "";
            try
            {
                if (Session["DataSetClientSummary"] != null)
                {

                    objClientMedications = new ClientMedication();
                    _DataSetClientSummary = new DataSet();
                    _DataSetClientSummary = (DataSet)Session["DataSetClientSummary"];
                    DataSetFinal = objClientMedications.GetClientAllergies(((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId);
                    DataRow[] DataRowTemps = DataSetFinal.Tables["ClientAllergies"].Select("ClientAllergyId=" + AllergyId);

                    if (DataRowTemps.Length > 0)
                    {
                        DataRow drAllergyHistory = DataSetFinal.Tables["ClientAllergyHistory"].NewRow();
                        drAllergyHistory["Active"] = DataRowTemps[0]["Active"];
                        drAllergyHistory["AllergyType"] = DataRowTemps[0]["AllergyType"];
                        drAllergyHistory["ClientAllergyId"] = DataRowTemps[0]["ClientAllergyId"];
                        drAllergyHistory["Comment"] = DataRowTemps[0]["Comment"];
                        drAllergyHistory["CreatedBy"] = DataRowTemps[0]["CreatedBy"];
                        drAllergyHistory["CreatedDate"] = DataRowTemps[0]["CreatedDate"];
                        drAllergyHistory["DeletedBy"] = DataRowTemps[0]["DeletedBy"];
                        drAllergyHistory["DeletedDate"] = DataRowTemps[0]["DeletedDate"];
                        drAllergyHistory["ModifiedBy"] = DataRowTemps[0]["ModifiedBy"];
                        drAllergyHistory["ModifiedDate"] = DataRowTemps[0]["ModifiedDate"];
                        drAllergyHistory["RecordDeleted"] = DataRowTemps[0]["RecordDeleted"];

                        DataRowTemps[0]["Comment"] = System.Uri.UnescapeDataString(comments).Replace("%27", "'");
                        DataRowTemps[0]["Active"] = AllergyActive;
                        DataRowTemps[0]["AllergyType"] = AllergyType;

                        DataRowTemps[0]["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode.ToString();
                        DataRowTemps[0]["ModifiedDate"] = DateTime.Now;
                        DataSetFinal.Tables["ClientAllergyHistory"].Rows.Add(drAllergyHistory);
                        objClientMedications.UpdateClientAllergies(DataSetFinal, ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId, ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode);
                        switch (drAllergyHistory["AllergyType"].ToString())
                        {
                            case "A":
                                result = "update"; //"AllergyUpdated";
                                break;
                            case "I":
                                result = "update"; //"IntoleranceUpdated";
                                break;
                            case "F":
                                result = "update"; //"FailedTrialUpdated";
                                break;
                        }

                    }

                    DataSetFinal = objClientMedications.GetClientAllergiesData(((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId);

                    _DataSetClientSummary.Tables["ClientAllergies"].Clear();
                    _DataSetClientSummary.Tables["ClientAllergies"].Merge(DataSetFinal.Tables[0]);
                    Session["DataSetClientSummary"] = _DataSetClientSummary;

                    FillClientAllergyInteractionTable();

                    return GetAllergy_Html(DataSetFinal, 'Y', FilterList, result).ToString();
                }
                else
                {
                    return "";
                }

            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally
            {
                objClientMedications = null;
                DataSetFinal = null;

                DataSetClientAllergies = null;

            }

        }

        [WebMethod(EnableSession = true)]
        public DataTable FillDrugDropdown(int MedicationNameId)
        {
            Streamline.UserBusinessServices.ClientMedication ObjClientMedication = new Streamline.UserBusinessServices.ClientMedication();
            using (DataSet dsTemp = ObjClientMedication.FillDrugDropDown(MedicationNameId))
            {
                if (dsTemp.Tables.Count > 0)
                    dsTemp.Tables[0].TableName = "MedicationNames";
                return dsTemp.Tables[0];
            }
        }

        [WebMethod(EnableSession = true)]
        public DataTable GetHealthGraphItem(int HealtDataCategoryId)
        {
            Streamline.UserBusinessServices.ClientMedication objectClientMedications;
            DataSet _DataSetHealthDataListGraph = null;
            _DataSetHealthDataListGraph = new DataSet();
            int ClientId = 0;
            ClientId = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId;
            objectClientMedications = new ClientMedication();
            _DataSetHealthDataListGraph = objectClientMedications.GetHeathDataGraphItems(ClientId, HealtDataCategoryId);
            return _DataSetHealthDataListGraph.Tables["HealthDataListGraph"];

        }

        /// <summary>
        /// <CreatedBy>Loveena</CreatedBy>
        /// <Purpose>Ref to Task#2802</Purpose>
        /// </summary>
        /// <returns></returns>
        [WebMethod(EnableSession = true)]
        public DataTable CalculateAutoCalcAllow(int MedicationId)
        {
            try
            {
                Streamline.UserBusinessServices.ClientMedication ObjClientMedication = new Streamline.UserBusinessServices.ClientMedication();
                string _temp;
                using (DataSet dsTemp = ObjClientMedication.CalculateAutoCalcAllow(MedicationId))
                {
                    if (dsTemp.Tables.Count > 0)
                        dsTemp.Tables[0].TableName = "AutoCalcAllow";
                    return dsTemp.Tables[0];
                }
            }
            catch (Exception ex)
            {

                throw;
            }
        }

        /// <summary>
        /// <CreatedBy>Loveena</CreatedBy>
        /// <Purpose>Ref to Task#2802</Purpose>
        /// </summary>
        /// <returns></returns>
        [WebMethod(EnableSession = true)]
        public DataTable CalculateDispenseQuantity(int MedicationId, float dosage, string schedule, int days)
        {
            try
            {
                Streamline.UserBusinessServices.ClientMedication ObjClientMedication = new Streamline.UserBusinessServices.ClientMedication();
                using (DataSet dsTemp = ObjClientMedication.CalculateDispenseQuantity(MedicationId, dosage, schedule, days))
                {
                    if (dsTemp.Tables.Count > 0)
                        dsTemp.Tables[0].TableName = "AutoCalcAllow";
                    return dsTemp.Tables[0];
                }
            }
            catch (Exception ex)
            {

                throw;
            }
        }
        /// <summary>
        /// <CreatedBy>Anuj TOmar</CreatedBy>
        /// <Purpose>Ref to Task#2932</Purpose>
        /// </summary>
        /// <returns></returns>
        [WebMethod(EnableSession = true)]
        public int RevokeConsent(string SignedBy, int DocumentVersionId)
        {
            Streamline.UserBusinessServices.ClientMedication objClientMedication = null;
            try
            {
                string ModifiedBy = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                if (SignedBy == "Signed by Medical Staff")
                {
                    objClientMedication = new Streamline.UserBusinessServices.ClientMedication();
                    objClientMedication.RevokeMedication("M", DocumentVersionId, ModifiedBy);
                }
                else if (SignedBy == "Signed by Patient")
                {

                    objClientMedication = new Streamline.UserBusinessServices.ClientMedication();
                    objClientMedication.RevokeMedication("P", DocumentVersionId, ModifiedBy);
                }
                return 1;

            }
            catch (Exception ex)
            {
                return -1;
            }
            finally
            {
                objClientMedication = null;
            }
        }
        //Added by Anj for task ref 2955 (Medication Management) on 17 March,2010
        [WebMethod(EnableSession = true)]
        public DataTable FillDosageInfoText(int MedicationNameId, string ClientDOB)
        {
            Streamline.UserBusinessServices.ClientMedication ObjClientMedication = new Streamline.UserBusinessServices.ClientMedication();
            using (DataSet dsTemp = ObjClientMedication.FillDosageInfoText(MedicationNameId, ClientDOB))
            {
                if (dsTemp.Tables.Count > 0)
                {
                    dsTemp.Tables[0].TableName = "DoseInformation";
                }
                return dsTemp.Tables[0];
            }
        }

        [WebMethod(EnableSession = true)]
        public DataTable LoadDrugOrderTemplate(int MedicationId, int StaffId)
        {
            Streamline.UserBusinessServices.ClientMedication ObjClientMedication = new Streamline.UserBusinessServices.ClientMedication();
            using (DataSet dsTemp = ObjClientMedication.LoadDrugOrderTemplate(MedicationId, StaffId))
            {
                if (dsTemp.Tables.Count > 0)
                {
                    dsTemp.Tables[0].TableName = "DrugOrderTemplate";
                }
                return dsTemp.Tables[0];
            }
        }

        [WebMethod(EnableSession = true)]
        public void UpdateSureScriptsRefillRequests(int SureScriptsRefillRequestId, int ClientMedicationScriptDrugStrengthId)
        {
            try
            {
                Streamline.UserBusinessServices.ClientMedication objClientMedication = null;
                //int SureScriptsRefillRequestId = Convert.ToInt32(Request.QueryString["SureScriptsRefillRequestId"].ToString());
                DataSet dataSetSureScriptRefillRequest = (DataSet)Session["DataSetSureScriptRequestRefill"];
                DataRow[] datarowSureScriptRefillRequest = dataSetSureScriptRefillRequest.Tables[0].Select("SureScriptsRefillRequestId=" + SureScriptsRefillRequestId);
                if (datarowSureScriptRefillRequest.Length > 0)
                {
                    datarowSureScriptRefillRequest[0]["ClientMedicationScriptDrugStrengthId"] = Convert.ToInt32(ClientMedicationScriptDrugStrengthId);
                    datarowSureScriptRefillRequest[0]["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                    datarowSureScriptRefillRequest[0]["ModifiedDate"] = System.DateTime.Now;
                }
                //string[] PatientName = a[1].ToString().Split(',');
                //datarowSureScriptRefillRequest[0]["ClientFirstName"] = PatientName[0].ToString();
                //datarowSureScriptRefillRequest[0]["ClientLastName"] = PatientName[1].ToString();
                //datarowSureScriptRefillRequest[0]["PatientName"] = a[1].ToString();
                objClientMedication = new ClientMedication();
                DataSet dsUpdated = new DataSet();
                dsUpdated = objClientMedication.UpdateDocuments(dataSetSureScriptRefillRequest);
                using (DataSet dsSureScripts = new DataSet())
                {

                    dsSureScripts.Merge(dsUpdated.Tables["SureScriptsRefillRequests"]);
                    Session["DataSetSureScriptRequestRefill"] = dsSureScripts;
                }
            }
            catch (Exception ex)
            {
                throw (ex);
            }

        }
        [WebMethod(EnableSession = true)]
        public string SaveClientPharmacies(string PharmacyId)
        {
            try
            {
                Streamline.UserBusinessServices.ClientMedication objClientMedication = null;
                objClientMedication = new ClientMedication();
                DataSet dsClientPharmacies = null;
                dsClientPharmacies = new DataSet();
                dsClientPharmacies.Merge(objClientMedication.GetClientPharmacies(Convert.ToInt32(((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId), false, "-1", "-1", "-1"));
                if (dsClientPharmacies != null && dsClientPharmacies.Tables["ClientPharmacies"].Rows.Count < 3)
                {
                    DataRow drClientPharmacies = dsClientPharmacies.Tables["ClientPharmacies"].NewRow();
                    drClientPharmacies["ClientId"] = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId;
                    drClientPharmacies["SequenceNumber"] = 1;
                    drClientPharmacies["PharmacyId"] = Convert.ToInt32(PharmacyId);
                    drClientPharmacies["CreatedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                    drClientPharmacies["CreatedDate"] = DateTime.Now.ToShortDateString();
                    drClientPharmacies["RowIdentifier"] = System.Guid.NewGuid();
                    drClientPharmacies["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                    drClientPharmacies["ModifiedDate"] = DateTime.Now.ToShortDateString();
                    dsClientPharmacies.Tables["ClientPharmacies"].Rows.Add(drClientPharmacies);
                    objClientMedication.UpdateDocuments(dsClientPharmacies);
                }

                return "";
            }
            catch (Exception ex)
            {
                return "";
            }

        }

        [WebMethod(EnableSession = true)]
        public bool ValidatePassword(string Password, string NoPasswordRequired)
        {
            if (NoPasswordRequired == "True")
                return true;
            DataSet userAuthenticationType = null;
            DataSet ds = null;
            string authType = string.Empty;
            Streamline.UserBusinessServices.MedicationLogin objMedicationLogin = new Streamline.UserBusinessServices.MedicationLogin();
            userAuthenticationType = objMedicationLogin.GetUserAuthenticationType(((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode);
            if (userAuthenticationType.Tables["Authentication"].Rows.Count > 0)
            {
                authType =
                    userAuthenticationType.Tables["Authentication"].Rows[0]["AuthenticationType"]
                        .ToString();
            }
            if (((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).Password != "" && !authType.ToUpperInvariant().Equals("A"))
            {
                if (Password == ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).Password)
                    return true;
            }
            else
            {
                
                string enableADAuthentication = string.Empty;
                bool isValidUser = false;
                try
                {
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

                        return isValidUser = objMedicationLogin.ADAuthenticateUser(((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode,
                                        Password, userAuthenticationType.Tables["Authentication"].Rows[0]["Domain"].ToString());
                    }
                    
                    else
                    {
                        ds = objMedicationLogin.chkServerLogin(((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode, Password);
                        if (ds!= null && ds.Tables["ClientInfo"] != null && ds.Tables["ClientInfo"].Rows.Count > 0)
                        {
                            return isValidUser = true;
                        }
                    }
                }
                catch (Exception ex)
                {
                    if (ex.Data["CustomExceptionInformation"] == null)
                        ex.Data["CustomExceptionInformation"] = "###Source Function Name - MedicationLogin--Page_Load(), ParameterCount -0 ###";
                    else
                        ex.Data["CustomExceptionInformation"] = "";
                    if (ex.Data["DatasetInfo"] == null)
                        ex.Data["DatasetInfo"] = null;

                    Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error);
                }
            }

            return false;
        }

        [WebMethod(EnableSession = true)]
        public Triplet FillLocationsCombo()
        {
            Triplet triplet = new Triplet();

            var DataTableStaffLocations = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).StaffPrescribingLocations;
            //Code modified in ref to Task#3129
            if (Session["AssociatedLocation"] != null)
                triplet.First = Session["AssociatedLocation"];
            else if (((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).StaffPrescribingLocationId != 0)
                triplet.Second = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).StaffPrescribingLocationId.ToString();

            DataView dv = DataTableStaffLocations.DefaultView;
            dv.Sort = "LocationName ASC";
            DataTableStaffLocations = dv.ToTable();

            triplet.Third = DataTableStaffLocations;
            return triplet;
        }

        [WebMethod(EnableSession = true)]
        public DataTable PrinterDeviceLocationsCombo(int locationId)
        {

            DataSet DataSetPrinterDeviceLocations = null;
            DataSetPrinterDeviceLocations = Streamline.UserBusinessServices.SharedTables.DataSetPrinterDeviceLocations;
            if (DataSetPrinterDeviceLocations != null)
            {
                DataRow[] drPrinter;
                if (locationId != 0)
                    drPrinter = DataSetPrinterDeviceLocations.Tables[0].Select("LocationId=" + locationId, "DeviceLabel Asc");
                else
                    drPrinter = DataSetPrinterDeviceLocations.Tables[0].Select("1=1", "DeviceLabel Asc");
                DataSet dtSetPrinter = new DataSet();
                if (drPrinter != null)
                    dtSetPrinter.Merge(drPrinter);
                if (dtSetPrinter.Tables.Count > 0)
                    return dtSetPrinter.Tables[0];
                else
                    return DataSetPrinterDeviceLocations.Tables[0];
            }
            return DataSetPrinterDeviceLocations.Tables[0];
        }

        /// <summary>
        /// Grabs the client pharmacy list, grabbing a list of pharmacies for the staff and then sorting this list
        /// with the client pharmacies showing in the list first.  Pass back this list and the top client pharmacy.
        /// </summary>
        /// <returns></returns>
        [WebMethod(EnableSession = true)]
        public System.Web.UI.Pair FillPharmaciesCombo()
        {
            DataSet DataSetPharmacies = null;
            string[] ClientPharmecieIds = null;
            DataSet DataSetClientPharmecies = new DataSet();

            var objectSharedTables = new Streamline.UserBusinessServices.SharedTables();

            var _DataSetClientSummary = (DataSet)Session["DataSetClientSummary"];
            if (_DataSetClientSummary != null)
                ClientPharmecieIds = _DataSetClientSummary.Tables["ClientPharmacies"].AsEnumerable().Select(x => x["PharmacyId"].ToString()).ToArray();


            DataSetPharmacies = objectSharedTables.getPharmacies(((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId);
            if (DataSetPharmacies != null && DataSetPharmacies.Tables[0].Rows.Count > 0)
            {
                DataSetClientPharmecies.Merge(
                    DataSetPharmacies.Tables[0].AsEnumerable()
                                               .Select(pharmacies => pharmacies)
                                               .Where(fax => fax["FaxNumber"].ToString().Length >= 7)
                                               .OrderBy(clientpharmacies => !ClientPharmecieIds.Contains(clientpharmacies["PharmacyId"].ToString()))
                                               .ThenBy(pharmacy => pharmacy["PharmacyName"]).CopyToDataTable());

            }
            else
            {
                DataSetClientPharmecies.Tables.Add(new DataTable());
            }
            System.Web.UI.Pair pairToReturn = new System.Web.UI.Pair();
            pairToReturn.First = DataSetClientPharmecies.Tables[0];
            pairToReturn.Second = ClientPharmecieIds.Length > 0 ? ClientPharmecieIds[0] : "";
            return pairToReturn;
        }

        /// <summary>
        /// Grabs the DEA# based on the selected Presciber abd the places the Primary DEA # on top of the List.
        /// </summary>
        /// <returns></returns>
        [WebMethod(EnableSession = true)]
        public System.Web.UI.Pair FillDEANumberCombo(int prescriberStaff)
        {
            DataSet dsStaffLicenseDegrees = null;
            var objClientMedication = new Streamline.UserBusinessServices.ClientMedication();
            dsStaffLicenseDegrees = objClientMedication.GetStaffLicenseDegrees(prescriberStaff);
            System.Web.UI.Pair pairToReturn = new System.Web.UI.Pair();
            pairToReturn.First = dsStaffLicenseDegrees.Tables[0];
            return pairToReturn;
        }



        #region CharCopyPrinter
        /// <summary>
        /// <Description>Used to fill ChartCopyPrinterDeviceLocations Drop down list</Description>
        /// <Author>Loveena</Author>
        /// <CreatedOn>04Feb2010</CreatedOn>
        /// </summary>
        [WebMethod(EnableSession = true)]
        public DataTable ChartCopyPrinterDeviceLocationsCombo(int locationId)
        {

            DataView DataViewPrinterDeviceLocations = null;

            DataSet DataSetPrinterDeviceLocations = Streamline.UserBusinessServices.SharedTables.DataSetPrinterDeviceLocations;
            if (DataSetPrinterDeviceLocations != null)
            {
                DataRow[] drPrinter;
                if (locationId != 0)
                    drPrinter = DataSetPrinterDeviceLocations.Tables[0].Select("LocationId=" + locationId, "DeviceLabel Asc");
                else
                    drPrinter = DataSetPrinterDeviceLocations.Tables[0].Select("1=1", "DeviceLabel Asc");
                DataSet dtSetPrinter = new DataSet();
                if (drPrinter != null)
                    dtSetPrinter.Merge(drPrinter);
                if (dtSetPrinter.Tables.Count > 0)
                    return dtSetPrinter.Tables[0];
                else
                    return DataSetPrinterDeviceLocations.Tables[0];
            }
            return DataSetPrinterDeviceLocations.Tables[0];
        }
        #endregion

        [WebMethod(EnableSession = true)]
        public void CheckSessionExpiration()
        {
            try
            {

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

        [WebMethod(EnableSession = true)]
        public DataSet ReprintAllowed(int ClientMedicationScriptId, string Method)
        {
            Streamline.UserBusinessServices.ClientMedication objClientMedication = null;
            DataSet datasetReprintAllowed = null;
            try
            {
                objClientMedication = new ClientMedication();
                datasetReprintAllowed = objClientMedication.ReprintAllowed(ClientMedicationScriptId, Method);
                return (datasetReprintAllowed);
            }
            catch (Exception ex)
            {
                throw (ex);
            }
        }

        [WebMethod(EnableSession = true)]
        public bool GetNoKnownAllergyFlag(string CheckboxFlag)
        {
            Streamline.UserBusinessServices.ClientMedication obj = new Streamline.UserBusinessServices.ClientMedication();
            return obj.GetNoKnownAllergiesFlag(((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId, CheckboxFlag);
        }

        [WebMethod(EnableSession = true)]
        public void UpdateNoMedicationsFlag(string CheckboxFlag)
        {
            Streamline.UserBusinessServices.ClientMedication obj = new Streamline.UserBusinessServices.ClientMedication();
            obj.UpdateNoMedicationsFlag(((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId, CheckboxFlag);
        }
        //Vithobha Added below function to send A08 message, for Philhaven Development: #376 HL7 - Rx - No Known Allergies
        [WebMethod(EnableSession = true)]
        public void UpdateClientAllergyforHL7()
        {
            if (Session["DataSetClientSummary"] != null)
            {
                if (((DataSet)Session["DataSetClientSummary"]).Tables["ClientAllergies"].Rows.Count < 1)
                {
                    Streamline.DataService.ClientMedication objClientMedications;
                    objClientMedications = new DataService.ClientMedication();
                    objClientMedications.ClientAllergiesPostUpdate(((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId, ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId, ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode, "O");
                }
            }
        }
        public class ClientKeyPhraseRow
        {
            private Int32 _KeyPhraseId;
            public Int32 KeyPhraseId
            {
                get { return _KeyPhraseId; }
                set { _KeyPhraseId = value; }
            }

            private Int32 _HiddenKeyPhraseId;
            public Int32 HiddenKeyPhraseId
            {
                get { return _HiddenKeyPhraseId; }
                set { _HiddenKeyPhraseId = value; }
            }


            private string _RowIdentifierKeyPhrase;
            public string RowIdentifierKeyPhrase
            {
                get { return _RowIdentifierKeyPhrase; }
                set { _RowIdentifierKeyPhrase = value; }
            }


            private string _PhraseText;
            public string PhraseText
            {
                get { return _PhraseText; }
                set { _PhraseText = value; }
            }

            private Int32 _KeyPhraseCategory;

            public Int32 KeyPhraseCategory
            {
                get { return _KeyPhraseCategory; }
                set { _KeyPhraseCategory = value; }
            }

            private string _KeyPhraseCategoryName;
            public string KeyPhraseCategoryName
            {
                get { return _KeyPhraseCategoryName; }
                set { _KeyPhraseCategoryName = value; }
            }



            private string _Favorite;
            public string Favorite
            {
                get { return _Favorite; }
                set { _Favorite = value; }
            }

            private string _KeyPhraseButtonValue;
            public string KeyPhraseButtonValue
            {
                get { return _PhraseText; }
                set { _PhraseText = value; }
            }

            private string _ModifiedDate;
            public string ModifiedDate
            {
                get { return _ModifiedDate; }
                set { _ModifiedDate = value; }
            }


        }

        public class ClientAgencyKeyPhraseRow
        {
            private Int32 _AgencyKeyPhraseId;
            public Int32 AgencyKeyPhraseId
            {
                get { return _AgencyKeyPhraseId; }
                set { _AgencyKeyPhraseId = value; }
            }

            private string _RowIdentifierKeyPhrase;
            public string RowIdentifierKeyPhrase
            {
                get { return _RowIdentifierKeyPhrase; }
                set { _RowIdentifierKeyPhrase = value; }
            }


            private string _PhraseText;
            public string PhraseText
            {
                get { return _PhraseText; }
                set { _PhraseText = value; }
            }

            private Int32 _KeyPhraseCategory;

            public Int32 KeyPhraseCategory
            {
                get { return _KeyPhraseCategory; }
                set { _KeyPhraseCategory = value; }
            }

            private string _KeyPhraseCategoryName;
            public string KeyPhraseCategoryName
            {
                get { return _KeyPhraseCategoryName; }
                set { _KeyPhraseCategoryName = value; }
            }

            private Int32 _HiddenKeyPhraseId;
            public Int32 HiddenKeyPhraseId
            {
                get { return _HiddenKeyPhraseId; }
                set { _HiddenKeyPhraseId = value; }
            }
        }

        [WebMethod(EnableSession = true)]
        [GenerateScriptType(typeof(ClientKeyPhraseRow))]
        public string SaveKeyPhraseRow(ClientKeyPhraseRow objClientKeyPhrases)
        {
            try
            {
                bool newRowKeyPhrase = false;
                if (Session["DataSetKeyPhrases"] != null)
                {
                    DataSet dsTemp = null;

                    dsTemp = (DataSet)Session["DataSetKeyPhrases"];
                    DataTable DataTableClientKeyPhrases = dsTemp.Tables["KeyPhrases"];
                    //For Key Phrases
                    // retrieve the row that is being changed from the dataset
                    DataRow[] _tempKeyPhrases = DataTableClientKeyPhrases.Select("KeyPhraseId='" + objClientKeyPhrases.HiddenKeyPhraseId + "'");
                    DataRow DataRowKeyPhrase;
                    if (_tempKeyPhrases.Length > 0)
                    {
                        DataRowKeyPhrase = _tempKeyPhrases[0];
                        newRowKeyPhrase = false;
                    }
                    else
                    {
                        int iMinClientMedicationId = 0;

                        DataRowKeyPhrase = DataTableClientKeyPhrases.NewRow();
                        if (DataTableClientKeyPhrases.Rows.Count > 0)
                        {
                            iMinClientMedicationId = GetMinValue(Convert.ToInt32(DataTableClientKeyPhrases.Compute("Min(KeyPhraseId)", "")));
                            DataRowKeyPhrase["KeyPhraseId"] = iMinClientMedicationId;

                        }
                        else
                        {
                            DataRowKeyPhrase["KeyPhraseId"] = -1;

                        }
                        newRowKeyPhrase = true;
                    }

                    DataRowKeyPhrase["KeyPhraseCategoryName"] = objClientKeyPhrases.KeyPhraseCategoryName;
                    DataRowKeyPhrase["KeyPhraseCategory"] = objClientKeyPhrases.KeyPhraseCategory;
                    DataRowKeyPhrase["Favorite"] = objClientKeyPhrases.Favorite;
                    DataRowKeyPhrase["PhraseText"] = objClientKeyPhrases.PhraseText;
                    DataRowKeyPhrase["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                    DataRowKeyPhrase["StaffId"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId;
                    DataRowKeyPhrase["RecordDeleted"] = System.DBNull.Value;
                    DataRowKeyPhrase["DeletedBy"] = DBNull.Value;
                    DataRowKeyPhrase["DeletedDate"] = DBNull.Value;

                    if (newRowKeyPhrase == true)
                    {
                        DataRowKeyPhrase["CreatedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                        DataRowKeyPhrase["CreatedDate"] = DateTime.Now;
                        DataRowKeyPhrase["ModifiedDate"] = DateTime.Now;
                        DataTableClientKeyPhrases.Rows.Add(DataRowKeyPhrase);
                    }

                    Session["DataSetKeyPhrases"] = dsTemp;
                }

                Session["IsDirty"] = true;
                return "";
            }

            catch (Exception ex)
            {
                if (Session["SessionTimeOut"] == null)
                    return "Session Expired";
                else
                    return ex.Message;
            }

        }

        [WebMethod(EnableSession = true)]
        public DataSet ModifyPhraseList(int selectedKeyPhraseId)
        {
            if (Session["DataSetKeyPhrases"] != null)
            {
                DataRow[] drClientKeyPhrase = ((DataSet)Session["DataSetKeyPhrases"]).Tables[0].Select("KeyPhraseId=" + selectedKeyPhraseId);

                if (drClientKeyPhrase.Length > 0)
                {
                    DataSet dsTemp = new DataSet("ClientKeyPhrases");
                    dsTemp.Merge(drClientKeyPhrase);
                    Session["IsDirty"] = true;
                    return dsTemp;
                }

            }
            return null;
        }
        
        [WebMethod(EnableSession = true)]
        public bool DeleteKeyPhraseRow(int selectedKeyPhraseId)
        {

            if (Session["DataSetKeyPhrases"] != null)
            {
                DataRow[] drClientKeyPhrase = ((DataSet)Session["DataSetKeyPhrases"]).Tables[0].Select("KeyPhraseId=" + selectedKeyPhraseId);
                if (drClientKeyPhrase.Length > 0)
                {
                    drClientKeyPhrase[0]["RecordDeleted"] = "Y";
                    drClientKeyPhrase[0]["DeletedDate"] = Convert.ToDateTime(DateTime.Now.ToShortDateString());
                    drClientKeyPhrase[0]["DeletedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                    // drClientKeyPhrase[0].Delete();


                    Session["IsDirty"] = true;

                    return true;
                }

            }
            return false;
        }

        [WebMethod(EnableSession = true)]
        public bool SaveKeyPhrases(String chkObj)
        {
            Streamline.UserBusinessServices.ClientMedication objectClientMedications;
            objectClientMedications = new Streamline.UserBusinessServices.ClientMedication();
            CommonFunctions.Event_Trap(this);
            DataSet dtKeyPhrases = null;
            dtKeyPhrases = new DataSet();

            if (Session["DataSetKeyPhrases"] != null)
            {

                //Added By Arjun K R
                DataSet dsKeyPhrases = (DataSet)Session["DataSetKeyPhrases"];
                DataTable dtStaffAgencyKeyPhrases = dsKeyPhrases.Tables["staffAgencyKeyPhrases"];

                try
                {
                    var json = JsonConvert.DeserializeObject<Dictionary<string, tempAgencyKeySelected>>(chkObj);

                    foreach (var item in json)
                    {
                        var AgencyKeyId = item.Value.AgencyKeyId;
                        var Value = item.Value.Value;

                        DataRow[] drStaffAgencyKeyPhrases = dtStaffAgencyKeyPhrases.Select("AgencyKeyPhraseId=" + AgencyKeyId);
                        if (drStaffAgencyKeyPhrases.Length > 0)
                        {
                            if (Value == "Y")
                            {
                                drStaffAgencyKeyPhrases[0]["RecordDeleted"] = "N";
                            }
                            else
                            {
                                drStaffAgencyKeyPhrases[0]["RecordDeleted"] = "Y";
                            }
                        }
                        else
                        {
                            DataRow DataRowKeyPhrase = dsKeyPhrases.Tables["staffAgencyKeyPhrases"].NewRow();
                            DataRowKeyPhrase["StaffAgencyKeyPhraseId"] = -1;
                            DataRowKeyPhrase["CreatedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                            DataRowKeyPhrase["CreatedDate"] = DateTime.Now;
                            DataRowKeyPhrase["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                            DataRowKeyPhrase["ModifiedDate"] = DateTime.Now;
                            DataRowKeyPhrase["RecordDeleted"] = System.DBNull.Value;
                            DataRowKeyPhrase["DeletedBy"] = DBNull.Value;
                            DataRowKeyPhrase["DeletedDate"] = DBNull.Value;
                            DataRowKeyPhrase["StaffId"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId;
                            DataRowKeyPhrase["AgencyKeyPhraseId"] = AgencyKeyId;
                            dsKeyPhrases.Tables["staffAgencyKeyPhrases"].Rows.Add(DataRowKeyPhrase);

                        }
                    }

                    dtKeyPhrases = objectClientMedications.UpdateKeyPhrases(dsKeyPhrases);

                    Session["DataSetKeyPhrases"] = dtKeyPhrases;
                    objectClientMedications = new Streamline.UserBusinessServices.ClientMedication();

                    return true;
                }
                catch (Exception e)
                {

                }
            }
            return false;
        }

        [WebMethod(EnableSession = true)]
        public bool CloseKeyPhrase()
        {
            try
            {
                if (Convert.ToBoolean(Session["IsDirty"]) == true)
                {
                    return true;
                }
                else
                {
                    return false;
                }

            }
            catch (Exception ex)
            {
                return false;
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
        }

        [WebMethod(EnableSession = true)]
        [GenerateScriptType(typeof(ClientAgencyKeyPhraseRow))]
        public string SaveAgencyKeyPhraseRow(ClientAgencyKeyPhraseRow objClientAgencyKeyPhraseRow)
        {
            try
            {
                bool newRowAgencyKeyPhrase = false;
                if (Session["DataSetAgencyKeyPhrases"] != null)
                {
                    DataSet dsAgencyKeyPhrasesTemp = null;
                    dsAgencyKeyPhrasesTemp = (DataSet)Session["DataSetAgencyKeyPhrases"];
                    DataTable DataTableAgencyKeyPhrases = dsAgencyKeyPhrasesTemp.Tables["AgencyKeyPhrases"];
                    DataRow[] _tempAgencyKeyPhrases = DataTableAgencyKeyPhrases.Select("AgencyKeyPhraseId='" + objClientAgencyKeyPhraseRow.HiddenKeyPhraseId + "'");
                    DataRow DataRowAgencyKeyPhrases;
                    if (_tempAgencyKeyPhrases.Length > 0)
                    {
                        DataRowAgencyKeyPhrases = _tempAgencyKeyPhrases[0];
                        newRowAgencyKeyPhrase = false;
                    }
                    else
                    {
                        int iMinAgencyKeyPhraseId = 0;

                        DataRowAgencyKeyPhrases = DataTableAgencyKeyPhrases.NewRow();
                        if (DataTableAgencyKeyPhrases.Rows.Count > 0)
                        {
                            iMinAgencyKeyPhraseId = GetMinValue(Convert.ToInt32(DataTableAgencyKeyPhrases.Compute("Min(AgencyKeyPhraseId)", ""))); DataRowAgencyKeyPhrases["AgencyKeyPhraseId"] = iMinAgencyKeyPhraseId;
                        }
                        else
                        {
                            DataRowAgencyKeyPhrases["AgencyKeyPhraseId"] = -1;
                        }

                        newRowAgencyKeyPhrase = true;
                    }


                    DataRowAgencyKeyPhrases["KeyPhraseCategoryName"] = objClientAgencyKeyPhraseRow.KeyPhraseCategoryName;
                    DataRowAgencyKeyPhrases["KeyPhraseCategory"] = objClientAgencyKeyPhraseRow.KeyPhraseCategory;
                    DataRowAgencyKeyPhrases["PhraseText"] = objClientAgencyKeyPhraseRow.PhraseText;
                    DataRowAgencyKeyPhrases["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                    DataRowAgencyKeyPhrases["ModifiedDate"] = DateTime.Now;
                    DataRowAgencyKeyPhrases["RecordDeleted"] = System.DBNull.Value;
                    DataRowAgencyKeyPhrases["DeletedBy"] = DBNull.Value;
                    DataRowAgencyKeyPhrases["DeletedDate"] = DBNull.Value;

                    if (newRowAgencyKeyPhrase == true)
                    {
                        DataRowAgencyKeyPhrases["CreatedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                        DataRowAgencyKeyPhrases["CreatedDate"] = DateTime.Now;
                        DataTableAgencyKeyPhrases.Rows.Add(DataRowAgencyKeyPhrases);
                    }

                    Session["DataSetAgencyKeyPhrases"] = dsAgencyKeyPhrasesTemp;
                }
                Session["IsDirty"] = true;

                return "";
            }
            catch (Exception ex)
            {
                if (Session["SessionTimeOut"] == null)
                    return "Session Expired";
                else
                    return ex.Message;

            }

        }

       [WebMethod(EnableSession = true)]
       public DataSet ModifyAgencyKeyPhraseList(int selectedAgencyKeyPhraseId)
        {
            if (Session["DataSetAgencyKeyPhrases"] != null)
            {
                DataRow[] drAgencyKeyPhrases = ((DataSet)Session["DataSetAgencyKeyPhrases"]).Tables["AgencyKeyPhrases"].Select("AgencyKeyPhraseId=" + selectedAgencyKeyPhraseId);
                if (drAgencyKeyPhrases.Length > 0)
                {
                    DataSet dsTemp = new DataSet("AgencyKeyPhrases");
                    dsTemp.Merge(drAgencyKeyPhrases);
                    Session["IsDirty"] = true;
                    return dsTemp;
                }

            }
            return null;
        }

       [WebMethod(EnableSession = true)]
       public bool DeleteAgencyKeyPhraseRow(int selectedAgencyKeyPhraseId)
       {
           if (Session["DataSetAgencyKeyPhrases"] != null)
           {
               DataRow[] drClientAgencyKeyPhrase = ((DataSet)Session["DataSetAgencyKeyPhrases"]).Tables["AgencyKeyPhrases"].Select("AgencyKeyPhraseId=" + selectedAgencyKeyPhraseId);
               if (drClientAgencyKeyPhrase.Length > 0)
               {
                   drClientAgencyKeyPhrase[0]["RecordDeleted"] = "Y";
                   drClientAgencyKeyPhrase[0]["DeletedDate"] = Convert.ToDateTime(DateTime.Now.ToShortDateString());
                   drClientAgencyKeyPhrase[0]["DeletedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;

                   Session["IsDirty"] = true;

                   return true;
               }
           }
           return false;
       }

       [WebMethod(EnableSession = true)]
       public bool SaveAgencyKeyPhrases()
       {
           Streamline.UserBusinessServices.ClientMedication objectAgencyKeyPhrases;
           objectAgencyKeyPhrases = new Streamline.UserBusinessServices.ClientMedication();
           CommonFunctions.Event_Trap(this);
           DataSet dtAgencyKeyPhrases = null;
           dtAgencyKeyPhrases = new DataSet();
           if (Session["DataSetAgencyKeyPhrases"] != null)
           {
               DataSet dsTemp = null;
               dsTemp = (DataSet)Session["DataSetAgencyKeyPhrases"];
               dtAgencyKeyPhrases = objectAgencyKeyPhrases.UpdateAgencyKeyPhrases(dsTemp);

               Session["DataSetAgencyKeyPhrases"] = dtAgencyKeyPhrases;
               objectAgencyKeyPhrases = new Streamline.UserBusinessServices.ClientMedication();

               return true;
           }

           return false;
       }

       [WebMethod(EnableSession = true)]
       public bool CloseAgencyKeyPhrases()
       {
           try
           {
               if (Convert.ToBoolean(Session["IsDirty"]) == true)
               {
                   return true;
               }
               else
               {
                   return false;
               }

           }
           catch (Exception ex)
           {
               return false;
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
       }

       class tempAgencyKeySelected
       {
           public int AgencyKeyId { get; set; }
           public string Value { get; set; }
       }

        private int GetMinValue(int id)
        {
            return id > 0 ? -1 : id - 1;
        }

        private int GetMinValue(int id1, int id2)
        {
            int _id1 = GetMinValue(id1);
            int _id2 = GetMinValue(id2);
            return _id1 < _id2 ? _id1 : _id2;
        }

    }
}

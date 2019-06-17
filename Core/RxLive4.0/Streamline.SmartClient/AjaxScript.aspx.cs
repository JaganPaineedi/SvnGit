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
using System.Text;
using System.Data.Sql;
using System.Data.SqlClient;
using System.Collections.Generic;
using System.Linq;

public partial class AjaxScript : System.Web.UI.Page
{
    private string _sortString = "";
    int prescriberId = 0;

    public static string ConnectionString = System.Configuration.ConfigurationSettings.AppSettings["SCConnectionString"];
    private string _ConnectionString = ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            string MedicationId = "";
            string Filter = "";
            //base.Page_Load(sender,e); 
            Response.Expires = -1;
            string[] arguments = new string[20];
            int intLoop = 0;

            if (Request.QueryString["FunctionID"] != null && Request.QueryString["FunctionID"].ToString() == "ApproveEPrescription")
            {
                ApproveEPrescription();
            }

            //Added by Anuj (task #85 Sure Script)
            if (Request["CurrentClientMedicationList"] != null && Request["CurrentClientMedicationList"] != "")
            {
                {
                    int ClientId = 0;
                    if (Request.QueryString["ClientId"] != null && Request.QueryString["ClientId"] != "" && Request.QueryString["ClientId"] != string.Empty)
                    {
                        ClientId = Convert.ToInt32(Request.QueryString["ClientId"].ToString());
                    }
                    if (Request.QueryString["SortBy"] != null && Request.QueryString["SortBy"] != "" && Request.QueryString["SortBy"] != string.Empty)
                    {
                        _sortString = Request.QueryString["SortBy"].ToString();
                    }
                    Streamline.UserBusinessServices.ClientMedication objectClientMedications;
                    objectClientMedications = new ClientMedication();
                    DataSet _DataSetCurrentMedications = null;
                    if (Session["CurrentMedications"] == null)
                        _DataSetCurrentMedications = objectClientMedications.GetClientCurrentMedications(ClientId);
                    else
                        _DataSetCurrentMedications = (DataSet)Session["CurrentMedications"];
                    GenerateCurrentMedicationRows(_DataSetCurrentMedications, _sortString);
                }
            }
            if (Request["SearchInboundPrescription"] != null && Request["SearchInboundPrescription"] != "" && Request["SearchInboundPrescription"] != "undefined")
            {
                int _prescriberId = 0;
                if (Request["PrescriberID"] != null && Request["PrescriberID"] != "" && Request["PrescriberID"] != string.Empty)
                {
                    _prescriberId = Convert.ToInt32(Request["PrescriberID"].ToString());
                    string sortString = "";
                    sortString = Convert.ToString(Request["sortInString"]);

                    GetSureScriptRefill(_prescriberId, sortString);

                }
            }
            //Added By Priya Ref: task 85 Date 17th Feb 2010
            if (Request["SortInboundRecord"] != null && Request["SortInboundRecord"] != "" && Request["SortInboundRecord"] != "undefined")
            {
                int _prescriberId = 0;
                if (Request["PrescriberID"] != null && Request["PrescriberID"] != "" && Request["PrescriberID"] != string.Empty)
                {
                    _prescriberId = Convert.ToInt32(Request["PrescriberID"].ToString());
                    string sortString = "";
                    sortString = Convert.ToString(Request["sortInString"]);
                    GetSureScriptRefill(_prescriberId, sortString);   
                }
            }

            if (Request["CalledFrom"] == "RxChange")
            {
                int _prescriberId = 0;
                if (Request["PrescriberID"] != null && Request["PrescriberID"] != "" && Request["PrescriberID"] != string.Empty)
                {
                    _prescriberId = Convert.ToInt32(Request["PrescriberID"].ToString());
                    string sortString = "";
                    sortString = Convert.ToString(Request["sortInString"]);
                    GetSureScriptChange(_prescriberId, sortString);

                }
            }

            if (Request["functionName"] != null && Request["functionName"] != "" && Request["functionName"] != "undefined")
            {
                string functionName = "";
                functionName = Convert.ToString(Request["FunctionName"]);
                switch (functionName)
                {
                    case "Updatestaff":
                        string selectedstaffid = Request.Form["selectedstaff"];
                        string enable = Request.Form["enable"];
                        string password = Request.Form["password"];
                        string otp = Request.Form["otp"];
                        Updatestaff(selectedstaffid, enable, password, otp);
                        break;
                }
            }

            if (Session["DataSetClientSummary"] != null)
            {
                for (intLoop = 0; intLoop <= 19; intLoop++)
                {
                    arguments[intLoop] = Request["par" + intLoop.ToString()];
                }
                Response.Clear();
                Response.ContentType = "text/xml";
                if (Request["FunctionId"] != null)
                {
                    switch (Request["FunctionId"].ToString())
                    {
                        ///New function added by sonia for ViewHistory window
                        case "GetMedicationMgtHistory":
                            {
                                if (Session["DataSetMedMgtHistory"] != null)
                                {
                                    DataSet _DataSetClientMedications = (DataSet)Session["DataSetMedMgtHistory"];
                                    DisplayMedicationData(_DataSetClientMedications.Tables[0], _DataSetClientMedications.Tables[1], null, null, null, false, false, false, false, "Instruction", false, "Are you sure to Discontinue this Medication?", true, arguments[0].ToString(), true, true, true, false, false, true, true, true, false, true, "ViewMedicationHistory");
                                }
                                break;
                            }
                        //---Added By Pradeep as per task#16---
                        case "GetClientConsentHistory":
                            {
                                if (Session["DataSetConsentMedicationHistory"] != null)
                                {
                                    DataSet _DataSetClientConsentHistory = (DataSet)Session["DataSetConsentMedicationHistory"];
                                    DisplayConsentMedicationData(_DataSetClientConsentHistory.Tables["ClientMedications"], _DataSetClientConsentHistory.Tables["ClientMedicationInstructions"], arguments[0].ToString());
                                }
                                break;
                            }

                        case "setDateFormat":
                            {
                                DateTime dt;
                                try
                                {
                                    try
                                    {
                                        dt = Convert.ToDateTime(arguments[0]);
                                        if (dt.Year > 1753 && dt.Year < 9999)
                                            Response.Write(dt.ToString("MM/dd/yyyy"));
                                        else
                                            throw new ArgumentOutOfRangeException();
                                    }
                                    catch
                                    {
                                    }
                                }
                                catch (Exception ex)
                                {
                                    throw (ex);
                                }
                                Response.End();
                                break;
                            }
                        case "GetMedicationList":
                            {
                                if (Session["DataSetClientMedications"] != null)
                                {
                                  
                                    Streamline.UserBusinessServices.DataSets.DataSetClientMedications dsTemp =
                                        (Streamline.UserBusinessServices.DataSets.DataSetClientMedications)
                                        Session["DataSetClientMedications"];
                                    DataView dvMedications = new DataView(dsTemp.ClientMedications);
                                    DataView dvMedicationInstructions = new DataView(dsTemp.ClientMedicationInstructions);
                                    string calledFromControllerName = Request.QueryString["container"] != null ? Request.QueryString["container"].ToString() : "";
                                    MedicationList1.Activate(calledFromControllerName);
                                    MedicationList1.SortString = arguments[0] == null ? "" : arguments[0].ToString();
                                    bool showDeleteButton = true;
                                    if (arguments[1] == "Refill")
                                    {
                                        showDeleteButton = false;
                                        MedicationList1.showMinScriptDrugsEndDate = true;
                                    }
                                    if (arguments[1] == null)
                                        arguments[1] = string.Empty;
                                    MedicationList1.GenerateNewMedicationControlRows(dvMedications,
                                                                                     dvMedicationInstructions,
                                                                                     dsTemp.ClientMedicationInteractions,
                                                                                     dsTemp
                                                                                         .ClientMedicationInteractionDetails,
                                                                                     dsTemp.ClientAllergiesInteraction,
                                                                                     showDeleteButton,
                                                                                     arguments[1].ToString());

                                }
                                break;
                            }
                       case "GetMedicationMgtList":
                            {
                                if (Session["DataSetClientSummary"] != null)
                                {
                                    DataSet _DataSetClientSummary = new DataSet();
                                    _DataSetClientSummary = (DataSet)Session["DataSetClientSummary"];

                                    using (DataSet dataSetTemp = _DataSetClientSummary.Clone())
                                    {
                                        dataSetTemp.Merge(_DataSetClientSummary);
                                        DisplayMedicationData(dataSetTemp.Tables["ClientMedications"], dataSetTemp.Tables["ClientMedicationInstructions"], dataSetTemp.Tables["ClientMedicationInteractions"], dataSetTemp.Tables["ClientMedicationInteractionDetails"], dataSetTemp.Tables["ClientMedicationAllergyInteracions"], true, false, false, false, "Instruction", true, "Are you sure you want to Discontinue this Medication?", true, arguments[0].ToString(), false, false, false, false, true, false, false, false, true, true, "MedicationMgt");
                                    }
                                }
                                break;
                            }

                        case "GetMedicationPrescribeList":
                            {
                                if (Session["DataSetPrescribedClientMedications"] != null)
                                {
                                    int _NoOfDays;
                                    float _GlobalCodeMedicationUnitExternalCode = 0;
                                    long _Quantity;



                                    Streamline.UserBusinessServices.DataSets.DataSetClientMedications DataSetClientMedications;
                                    DataSetClientMedications = new Streamline.UserBusinessServices.DataSets.DataSetClientMedications();
                                    DataSetClientMedications = (Streamline.UserBusinessServices.DataSets.DataSetClientMedications)Session["DataSetPrescribedClientMedications"];

                                    DataTable _DataTableClientMedications = DataSetClientMedications.Tables["ClientMedications"];
                                    DataTable _DataTableClientMedicationInstructions = DataSetClientMedications.Tables["ClientMedicationInstructions"];

                                    foreach (DataRow dr in _DataTableClientMedicationInstructions.Rows)
                                    {
                                        DataRow[] DataRowGlobalCodeMedicationSchedule = null;
                                        DataRow[] DataRowClientMedicationScriptDrugs = null;
                                        try
                                        {
                                            if (dr.RowState != DataRowState.Deleted)
                                            {
                                                DataRowClientMedicationScriptDrugs = DataSetClientMedications.Tables["ClientMedicationScriptDrugs"].Select("ClientMedicationInstructionId=" + Convert.ToInt32(dr["ClientMedicationInstructionId"].ToString()));
                                                _NoOfDays = Convert.ToInt32(DataRowClientMedicationScriptDrugs[0]["Days"].ToString());
                                                _GlobalCodeMedicationUnitExternalCode = 0;
                                                _Quantity = (long)Convert.ToDouble(dr["Quantity"].ToString());
                                                //Logic for Qty changed as per Task #2345 
                                                DataRowGlobalCodeMedicationSchedule = Streamline.UserBusinessServices.SharedTables.DataSetGlobalCodes.Tables[0].Select("Category='MEDICATIONSCHEDULE' and GlobalCodeId=" + Convert.ToInt32(dr["SCHEDULE"].ToString()));
                                                if (DataRowGlobalCodeMedicationSchedule != null && DataRowGlobalCodeMedicationSchedule[0]["ExternalCode1"].ToString().Trim() != "")
                                                    _GlobalCodeMedicationUnitExternalCode = (float)Convert.ToDouble(DataRowGlobalCodeMedicationSchedule[0]["ExternalCode1"].ToString());
                                                else
                                                    _GlobalCodeMedicationUnitExternalCode = 1;
                                                //Formula changed as per Task 2361 SC-Support
                                                dr["CalculatedQty"] = Math.Round(Convert.ToDecimal((float)(_Quantity) * (float)(_NoOfDays) * (float)(_GlobalCodeMedicationUnitExternalCode)), 2);
                                                //dr["CalculatedQty"] = _NoOfDays * _GlobalCodeMedicationUnitExternalCode * _Quantity;
                                                //Following Code added by Sonia
                                                //Reference Task #55 (1.5.3 - Order Process - Prescribe Screen - Refills Empty)
                                                //Refills column value added in DataSet's Instructions Table just for Display purpose
                                                dr["Refills"] = DataRowClientMedicationScriptDrugs[0]["Refills"];
                                                //Code ended by sonia

                                            }
                                        }

                                        catch (Exception ex)
                                        {
                                            dr["CalculatedQty"] = dr["Quantity"];
                                        }
                                        finally
                                        {
                                            DataRowGlobalCodeMedicationSchedule = null;
                                            DataRowClientMedicationScriptDrugs = null;
                                        }

                                    }
                                    //Task #38 MM 1.5.1 - Refill Screen: Start and Stop Date Initialization
                                    //Method of Order checked so that ScriptDrugs display can be handled accordingly
                                    if (arguments[1] == "Refill")
                                        DisplayMedicationData(_DataTableClientMedications, _DataTableClientMedicationInstructions, null, null, null, false, true, true, true, "Order", false, "Are you sure to Delete this Medication from Prescribe List?", false, arguments[0].ToString(), false, false, false, true, false, false, false, false, false, false, "");
                                    else
                                        DisplayMedicationData(_DataTableClientMedications, _DataTableClientMedicationInstructions, null, null, null, false, true, true, true, "Order", false, "Are you sure to Delete this Medication from Prescribe List?", false, arguments[0].ToString(), false, false, false, false, true, false, false, false, false, false, "");




                                }
                                break;
                            }
                        case "Test":
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
                                        StreamlinePrinciple newUser = Session["UserContext"] as StreamlinePrinciple;
                                        //StreamlinePrinciple newUser = new StreamlinePrinciple(Context.User.Identity.Name);
                                        Context.User = newUser;
                                    }
                                }
                                Streamline.UserBusinessServices.ClientMedication objectClientMedications = new Streamline.UserBusinessServices.ClientMedication();
                                //CommonFunctions.Event_Trap(this);
                                string _ClientRowIdentifier = "";
                                string _ClinicianrowIdentifier = "";
                                DataSet _DataSetClientSummary = null;

                                _ClinicianrowIdentifier = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).ClinicianRowIdentifier;

                                _ClientRowIdentifier = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientRowIdentifier;

                                if (_ClientRowIdentifier != "" && _ClinicianrowIdentifier != "")
                                {
                                    _DataSetClientSummary = objectClientMedications.DownloadClientMedicationSummary(_ClientRowIdentifier, _ClinicianrowIdentifier);
                                }


                                foreach (DataRow dr in _DataSetClientSummary.Tables["ClientMedications"].Rows)
                                {
                                    dr["PrescriberName"] = dr["PrescribedByName"];
                                }


                                // Filter out the instructions for Today >=startdate and <= EndDate
                                string currentDate = DateTime.Now.ToShortDateString();
                                DataTable dtTemp = _DataSetClientSummary.Tables["ClientMedications"].Clone();

                                foreach (DataRow dr in _DataSetClientSummary.Tables["ClientMedications"].Rows)
                                {
                                    if (dr["Discontinued"] == DBNull.Value || dr["Discontinued"].ToString().ToUpper() == "N")
                                        dtTemp.Rows.Add(dr.ItemArray);
                                }
                                //Control dsTemp = this.Page.LoadControl("~/UserControls/MedicationList.ascx");
                                MedicationList1.Activate();
                                DataView dv1 = new DataView(dtTemp);
                                DataView dv2 = new DataView(_DataSetClientSummary.Tables["ClientMedicationInstructions"]);
                                MedicationList1.GenerateNewMedicationControlRows(dv1, dv2, null, null, null, true, arguments[1].ToString());
                                //System.Text.StringBuilder SB = new System.Text.StringBuilder();
                                //try
                                //{
                                //    System.IO.StringWriter SW = new System.IO.StringWriter(SB);
                                //    System.Web.UI.HtmlTextWriter htmlTW = new HtmlTextWriter(SW);
                                //    MedicationList1.GetMedicationListPanel.RenderControl(htmlTW);     
                                //}
                                //catch (Exception Ex)
                                //{
                                //    //return "";
                                //}
                                //string msg = (SB.ToString());
                                //Response.Write(msg);
                                break;
                                //Write Your Code  here to Pass the Data to control
                                //System.Web.UI.Control tp =
                                //MedicationList1.Activate();
                                //MedicationList1.GenerationMedicationTabControlRows(dtTemp, _DataSetClientSummary.Tables["ClientMedicationInstructions"]);
                            }

                        case "GetTitrationList":
                            {
                                int _titrationStepNumber = 0;
                                if (Session["DataSetTitration"] != null)
                                {
                                    Streamline.UserBusinessServices.DataSets.DataSetClientMedications dsTemp = (Streamline.UserBusinessServices.DataSets.DataSetClientMedications)Session["DataSetTitration"];
                                    DataView dvMedications = new DataView(dsTemp.ClientMedications);
                                    DataView dvMedicationInstructions = new DataView(dsTemp.ClientMedicationInstructions);
                                    MedicationList1.Activate();
                                    MedicationList1.SortString = arguments[0] == null ? "" : arguments[0].ToString();
                                    bool showDeleteButton = true;
                                    if (arguments[1] == "Refill")
                                    {
                                        showDeleteButton = false;
                                        MedicationList1.showMinScriptDrugsEndDate = true;
                                    }

                                    if (Request["TitrationStepNumber"] != "")
                                        _titrationStepNumber = Convert.ToInt32(Request["TitrationStepNumber"]);

                                    MedicationList1.GenerateNewTitrationControlRows(dvMedications, dvMedicationInstructions, dsTemp.ClientMedicationInteractions, dsTemp.ClientMedicationInteractionDetails, dsTemp.ClientAllergiesInteraction, showDeleteButton, _titrationStepNumber);
                                }
                                break;
                            }
                        case "GetPhrasesList":
                            {
                                if (Session["DataSetKeyPhrases"] != null)
                                {
                                    var SelectedCategoryId = Request["SelectedCategoryId"].ToString();
                                    var SelectedCategoryText = Request["SelectedCategoryName"].ToString();
                                    if (Request["SelectedCategoryId"] != null && Request["SelectedCategoryId"].ToString() != string.Empty)
                                    {
                                        DataSet dsTemp = null;
                                        dsTemp = (DataSet)Session["DataSetKeyPhrases"];
                                        DataView dvKeyPhrases = new DataView(dsTemp.Tables["KeyPhrases"]);
                                        if (SelectedCategoryText != "All")
                                        {
                                            DataTable dtKeyPhrases = dvKeyPhrases.Table.Copy();
                                            dtKeyPhrases.Clear();
                                            DataRow[] _dataRowKeyPhrases = dvKeyPhrases.ToTable().Select("KeyPhraseCategory = " + SelectedCategoryId);
                                            foreach (DataRow dr in _dataRowKeyPhrases)
                                            {
                                                dtKeyPhrases.ImportRow(dr);
                                            }
                                            DataView dvKeyPhrasesByCategory = new DataView(dtKeyPhrases);
                                            string calledFromControllerName = Request.QueryString["container"] != null ? Request.QueryString["container"].ToString() : "";
                                            KeyPhraseList1.Activate(calledFromControllerName);
                                            KeyPhraseList1.GenerateKeyPhraseRows(dvKeyPhrasesByCategory);
                                        }
                                        else
                                        {
                                            string calledFromControllerName = Request.QueryString["container"] != null ? Request.QueryString["container"].ToString() : "";
                                            KeyPhraseList1.Activate(calledFromControllerName);
                                            KeyPhraseList1.GenerateKeyPhraseRows(dvKeyPhrases);
                                        }
                                    }
                                }
                                break;
                            }
                        case "GetAgencyKeyPhrasesByCategory":
                            {
                                if (Session["DataSetAgencyKeyPhrases"] != null)
                                {
                                    var SelectedCategoryId = Request["SelectedCategoryId"].ToString();
                                    var SelectedCategoryText = Request["SelectedCategoryName"].ToString();
                                    if (Request["SelectedCategoryId"] != null && Request["SelectedCategoryId"].ToString() != string.Empty)
                                    {
                                        DataSet dsTemp = null;
                                        dsTemp = (DataSet)Session["DataSetAgencyKeyPhrases"];
                                        DataView dvAgencyKeyPhrases = new DataView(dsTemp.Tables["AgencyKeyPhrases"]);
                                        if (SelectedCategoryText != "All")
                                        {
                                            DataTable dtAgencyKeyPhrases = dvAgencyKeyPhrases.Table.Copy();
                                            dtAgencyKeyPhrases.Clear();
                                            DataRow[] _dataRowAgencyKeyPhrases = dvAgencyKeyPhrases.ToTable().Select("KeyPhraseCategory = " + SelectedCategoryId);
                                            foreach (DataRow dr in _dataRowAgencyKeyPhrases)
                                            {
                                                dtAgencyKeyPhrases.ImportRow(dr);
                                            }
                                            DataView dvAgencyKeyPhrasesByCategory = new DataView(dtAgencyKeyPhrases);
                                            string calledFromControllerName = Request.QueryString["container"] != null ? Request.QueryString["container"].ToString() : "";
                                            AgencyKeyPhraseList1.Activate(calledFromControllerName);
                                            AgencyKeyPhraseList1.GenerateAgencyKeyPhrasesControlRows(dvAgencyKeyPhrasesByCategory);

                                        }
                                        else
                                        {
                                            string calledFromControllerName = Request.QueryString["container"] != null ? Request.QueryString["container"].ToString() : "";
                                            AgencyKeyPhraseList1.Activate(calledFromControllerName);
                                            AgencyKeyPhraseList1.GenerateAgencyKeyPhrasesControlRows(dvAgencyKeyPhrases);
                                        }
                                    }
                                }
                                break;
                            }

                    }
                }
            }
            else
            {
                ScriptManager.RegisterStartupScript(LabelClientScript, LabelClientScript.GetType(), ClientID.ToString(), "redirectToLoginPage();", true);
            }
        }
        catch (Exception ex)
        {
            Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);
        }
    }

    /// <summary>
    /// <Description>Used to display consentMedicationData as per task#16</Description>
    /// <Author>Pradeep</Author>
    /// <CreatedOn>3 Nov 2009</CreatedOn>
    /// </summary>
    /// <param name="DataTableMedications"></param>
    /// <param name="DataTableMedicationInstructions"></param>
    /// <param name="sortString"></param>
    private void DisplayConsentMedicationData(DataTable DataTableMedications, DataTable DataTableMedicationInstructions, string sortString)
    {
        try
        {
            ConsentHistoryList1.Activate();
            ConsentHistoryList1.SortString = sortString;
            ConsentHistoryList1.GenerationConsentTabControlRows(DataTableMedications, DataTableMedicationInstructions);
        }
        catch (Exception ex)
        {
            throw (ex);
        }
    }

    //Two factor authentication for Queue order page -pranay
    private bool ApproveEPrescription()
    {
        string ErrorMessage = string.Empty;
        string passwordOTP = Request.QueryString["passwordOTP"].ToString();
        UserPrefernces staffDetails = new UserPrefernces();
        DataSet staffDataset = staffDetails.CheckStaffPermissions(((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId);
        TwoFactorAuthenticationRequest objTwoFactorAuthenticationRequest = new TwoFactorAuthenticationRequest();
        TwoFactorAuthentication objTwoFactorAuthentication = new TwoFactorAuthentication();
        TwoFactorAuthenticationResponse TwoFactorAuthenticationResponseObject = new TwoFactorAuthenticationResponse();
        string UserEmailAccount = string.Empty;
        string UserDevicePassword = string.Empty;
        if (staffDataset.Tables.Count > 2 && staffDataset.Tables[3].Rows.Count > 0)
        {
            UserEmailAccount = staffDataset.Tables[3].Rows[0]["DeviceEmail"].ToString();
            UserDevicePassword = staffDataset.Tables[3].Rows[0]["DevicePassword"].ToString();
        }
        objTwoFactorAuthenticationRequest.UserID = UserEmailAccount;
        objTwoFactorAuthenticationRequest.Password = ApplicationCommonFunctions.GetDecryptedData(UserDevicePassword, "Y");
        objTwoFactorAuthenticationRequest.OTP = passwordOTP;
        TwoFactorAuthenticationResponseObject = objTwoFactorAuthentication.Authenticate(objTwoFactorAuthenticationRequest,"Controlled Drug prescription (In queue)");
        try
        {
            if (TwoFactorAuthenticationResponseObject.Passed != true)
            {
                ErrorMessage = "OTP";
                ScriptManager.RegisterStartupScript(Page, Page.GetType(), UniqueID, "javascript:Updatemessagestatus('" + ErrorMessage + "');", true);
                Context.Response.Clear();
                Context.Response.Write("<input value=false type=hidden name=_hiddentemp1 id=_hiddentemp1 />");
                Context.Response.Flush();
                return false;
            }
            else
            {
                ErrorMessage = "Success";
                Context.Response.Clear();
                Context.Response.Write("<input value=true type=hidden name=_hiddentemp1 id=_hiddentemp1/>");
                Context.Response.Flush();
                return true;
            }
        }

        catch (Exception ex)
        {
            throw (ex);
        }
    }

    
    /// <summary>
    /// Purpose:This function is used to display Medication data in Medication List Control
    /// </summary>
    /// <param name="DataTableMedications"></param>
    /// <param name="DataTableMedicationInstructions"></param>
    private void DisplayMedicationData(DataTable DataTableMedications, DataTable DataTableMedicationInstructions, DataTable DataTableClientMedicationInteractions, DataTable DataTableClientMedicationInteractionDetails, DataTable DataTableClientAllergyInteractions, bool showCheckBox, bool ChButton, bool ShowQty, bool ShowRefills, string InstructionTitle, bool ShowDrugWarning, string DeleteRowMessage, bool ShowMedicationLink, string sortString, bool includeDiscontinued, bool ShowOrderStatus, bool ShowOrderStatusDate, bool ShowMinScriptDrugsEndDate, bool ShowButton, bool ShowDateInitiatedLabel, bool ShowOffLabel, bool ShowDiscontinuedReason, bool ShowConsentIcon, bool ShowComments, string ContainerCalledFrom)
    {
        try
        {
            // Filter out the instructions for Today >=startdate and <= EndDate
            string currentDate = DateTime.Now.ToShortDateString();
            DataTable dtTemp = DataTableMedications.Clone();

            if (includeDiscontinued == false)
            {

                foreach (DataRow dr in DataTableMedications.Rows)
                {
                    if (dr["Discontinued"] == DBNull.Value || dr["Discontinued"].ToString().ToUpper() == "N")
                        dtTemp.Rows.Add(dr.ItemArray);
                }
            }
            else
                dtTemp = DataTableMedications.Copy();

            //foreach (DataRow dr in dtTemp.Rows)
            //{
            //    dr["PrescriberName"] = dr["PrescribedByName"];
            //}

            //Write Your Code  here to Pass the Data to control
            MedicationList1.Activate(ContainerCalledFrom);
            MedicationList1.ShowCheckBox = showCheckBox;
            MedicationList1.ShowChButton = ChButton;
            MedicationList1.ShowQuantity = ShowQty;
            MedicationList1.ShowRefill = ShowRefills;
            MedicationList1.SortString = sortString;
            MedicationList1.InstructionsTitle = InstructionTitle;
            MedicationList1.ShowMedicationLink = ShowMedicationLink;
            MedicationList1.showMinScriptDrugsEndDate = ShowMinScriptDrugsEndDate;
            MedicationList1.ShowButton = ShowButton;
            MedicationList1.showDateInitiatedLabel = ShowDateInitiatedLabel;
            //Added by Loveena in ref to Task#2465 to display ConsentIcon if record exists in ClientMedicationConsent.
            MedicationList1.ShowConentIcon = ShowConsentIcon;
            //Code ends over here.
            if (((Streamline.BaseLayer.StreamlinePrinciple)Context.User).HasPermission(Permissions.AddMedication) || ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).HasPermission(Permissions.NewOrder))
            {
                if (ShowButton == true)
                    MedicationList1.DeleteRowMessage = DeleteRowMessage;
                else
                    MedicationList1.DeleteRowMessage = String.Empty;
            }
            else
            {
                MedicationList1.DeleteRowMessage = String.Empty;
            }
            MedicationList1.ShowDrugWarning = ShowDrugWarning;
            MedicationList1.DrugAllergyTitle = "";
            //Changes as per Task 2381 SC-Support
            MedicationList1.ShowOrderStatus = ShowOrderStatus;
            MedicationList1.ShowOrderStatusDate = ShowOrderStatusDate;
            //Added by Loveena in ref to Task#2433 to display OffLabel and DiscontinuedReason on View History on Header Click
            MedicationList1.showOffLabel = ShowOffLabel;
            MedicationList1.showDisContinueReasonLabel = ShowDiscontinuedReason;
            //Code ends over here.
            //Code added by Loveena in ref to Task#2779
            MedicationList1.ShowComments = ShowComments;
            //Code ends over here.
            MedicationList1.GenerationMedicationTabControlRows(dtTemp, DataTableMedicationInstructions, DataTableClientMedicationInteractions, DataTableClientMedicationInteractionDetails, DataTableClientAllergyInteractions);
            //MedicationList1.ge
            //Response.End();
        }
        catch (Exception ex)
        {
            throw (ex);
        }
    }

    public string SortString
    {
        get { return _sortString; }
        set { _sortString = value; }
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
    private string _onRadioClick = "onCurrentMedicationRadioClick";

    public string OnRadioClick
    {
        get { return _onRadioClick; }
        set { _onRadioClick = value; }
    }
    /// <summary>
    /// <Description>Used to display curren Medication record of Client task #85</Description>
    /// <Author>Anuj</Author>
    /// <CreatedOn>4 jan 2009</CreatedOn>
    /// </summary>
    /// <param name=""></param>
    /// <param name=""></param>
    /// <param name="sortString"></param>
    public void GenerateCurrentMedicationRows(DataSet _DataSetCurrentMedications, string sortString)
    {
        bool _boolRowWithInteractionFound = false;
        try
        {
            CommonFunctions.Event_Trap(this);

            System.Drawing.Color[] _color = 
                { 
                System.Drawing.Color.Pink, 
                System.Drawing.Color.Red, 
                System.Drawing.Color.Yellow, 
                System.Drawing.Color.Green, 
                System.Drawing.Color.Plum, 
                System.Drawing.Color.Aqua, 
                System.Drawing.Color.PaleGoldenrod, 
                System.Drawing.Color.Peru, 
                System.Drawing.Color.Tan, 
                System.Drawing.Color.Khaki, 
                System.Drawing.Color.DarkGoldenrod, 
                System.Drawing.Color.Maroon, 
                System.Drawing.Color.OliveDrab ,
               
                System.Drawing.Color.Crimson,
                System.Drawing.Color.Beige,
                System.Drawing.Color.DimGray,
                System.Drawing.Color.ForestGreen,
                System.Drawing.Color.Indigo,
                System.Drawing.Color.LightCyan           
                };
            PanelCurrentMedicationListInformation.Controls.Clear();
            Table tblMedication = new Table();
            tblMedication.ID = System.Guid.NewGuid().ToString();

            tblMedication.Width = new Unit(98, UnitType.Percentage);

            //Table Row Started
            TableHeaderRow thTitle = new TableHeaderRow();

            //Balnk  Table Header Cell
            TableHeaderCell thcBlank1 = new TableHeaderCell();

            //Table Header Cell For Medicaton Name           
            TableHeaderCell thcMedication = new TableHeaderCell();
            thcMedication.Text = "Medication";
            thcMedication.Font.Underline = true;
            thcMedication.Attributes.Add("onClick", "onCurrentMedicationHeaderClick(this)");
            thcMedication.Attributes.Add("ColumnName", "MedicationName");
            thcMedication.Attributes.Add("SortOrder", setAttributes());
            if (_DataSetCurrentMedications.Tables["TableCurrentMedications"].Rows.Count > 0)
            {
                thcMedication.CssClass = "handStyle";
            }

            //Table Header Cell For Date Initiated    
            TableHeaderCell thcStartDate = new TableHeaderCell();
            thcStartDate.Text = "Date Initiated";
            thcStartDate.Font.Underline = true;
            thcStartDate.Attributes.Add("onClick", "onCurrentMedicationHeaderClick(this)");
            thcStartDate.Attributes.Add("ColumnName", "MedicationStartDate");
            thcStartDate.Attributes.Add("SortOrder", setAttributes());
            thcStartDate.Width = 120;
            if (_DataSetCurrentMedications.Tables["TableCurrentMedications"].Rows.Count > 0)
            {
                thcStartDate.CssClass = "handStyle";
            }
            //Table Header Cell For Instruction    
            TableHeaderCell thcInstructions = new TableHeaderCell();
            thcInstructions.Text = "Instructions";
            thcInstructions.Font.Underline = true;
            thcInstructions.Attributes.Add("onClick", "onCurrentMedicationHeaderClick(this)");
            thcInstructions.Attributes.Add("ColumnName", "Instruction");
            thcInstructions.Attributes.Add("SortOrder", setAttributes());
            if (_DataSetCurrentMedications.Tables["TableCurrentMedications"].Rows.Count > 0)
            {
                thcInstructions.CssClass = "handStyle";
            }

            //Table Header Cell For DispenceQty    
            TableHeaderCell thcDispenseQty = new TableHeaderCell();
            thcDispenseQty.Text = "DispenseQty";
            thcDispenseQty.Font.Underline = true;
            thcDispenseQty.Attributes.Add("onClick", "onCurrentMedicationHeaderClick(this)");
            thcDispenseQty.Attributes.Add("ColumnName", "DispenseQuantity");
            thcDispenseQty.Attributes.Add("SortOrder", setAttributes());
            if (_DataSetCurrentMedications.Tables["TableCurrentMedications"].Rows.Count > 0)
            {
                thcDispenseQty.CssClass = "handStyle";
            }
            //Table Header Cell For Rx StartDate                          
            TableHeaderCell thcMedicationStartDate = new TableHeaderCell();
            thcMedicationStartDate.Text = "Rx Start";
            thcMedicationStartDate.Font.Underline = true;
            thcMedicationStartDate.Attributes.Add("onClick", "onCurrentMedicationHeaderClick(this)");
            thcMedicationStartDate.Attributes.Add("ColumnName", "MedicationStartDate");
            thcMedicationStartDate.Attributes.Add("SortOrder", setAttributes());
            if (_DataSetCurrentMedications.Tables["TableCurrentMedications"].Rows.Count > 0)
            {
                thcMedicationStartDate.CssClass = "handStyle";
            }

            //Table Header Cell For Rx EndDate       
            TableHeaderCell thcMedicationEndDate = new TableHeaderCell();
            thcMedicationEndDate.Text = "Rx End";
            thcMedicationEndDate.Font.Underline = true;
            thcMedicationEndDate.Attributes.Add("onClick", "onCurrentMedicationHeaderClick(this)");
            thcMedicationEndDate.Attributes.Add("ColumnName", "MedicationStartDate");
            thcMedicationEndDate.Attributes.Add("SortOrder", setAttributes());

            if (_DataSetCurrentMedications.Tables["TableCurrentMedications"].Rows.Count > 0)
            {
                thcMedicationEndDate.CssClass = "handStyle";
            }
            //Table Header Cell For Prescribed By    
            TableHeaderCell thcPrescribed = new TableHeaderCell();
            thcPrescribed.Text = "Prescribed By";
            thcPrescribed.Font.Underline = true;
            thcPrescribed.Attributes.Add("onClick", "onCurrentMedicationHeaderClick(this)");
            thcPrescribed.Attributes.Add("ColumnName", "PrescriberName");
            thcPrescribed.Attributes.Add("SortOrder", setAttributes());
            if (_DataSetCurrentMedications.Tables["TableCurrentMedications"].Rows.Count > 0)
            {
                thcPrescribed.CssClass = "handStyle";
            }

            //Adding all the header columns in Header rows
            thTitle.Cells.Add(thcBlank1);
            thTitle.Cells.Add(thcMedication);
            thTitle.Cells.Add(thcStartDate);

            thTitle.Cells.Add(thcInstructions);
            thTitle.Cells.Add(thcDispenseQty);
            thTitle.Cells.Add(thcMedicationStartDate);
            thTitle.Cells.Add(thcMedicationEndDate);
            thTitle.Cells.Add(thcPrescribed);

            thTitle.CssClass = "GridViewHeaderText";
            tblMedication.Rows.Add(thTitle);
            if (_DataSetCurrentMedications != null && _DataSetCurrentMedications.Tables.Count > 0 && _DataSetCurrentMedications.Tables["TableCurrentMedications"].Rows.Count > 0)
            {
                DataView dataViewCurrentMedications = null; ;
                if (_sortString.Contains("Instruction") || _sortString.Contains("StartDate") || _sortString.Contains("EndDate") || _sortString.Contains("DispenseQuantity"))
                {
                    DataTable dtClientMedication = _DataSetCurrentMedications.Tables["TableCurrentMedications"].Clone();
                    DataView dvClientMedicationInstructions = new DataView(_DataSetCurrentMedications.Tables["TableClientMedicationInstruction"]);
                    dvClientMedicationInstructions.Sort = _sortString;
                    dvClientMedicationInstructions.RowFilter = "ClientMedicationId >= 0 ";
                    while (dvClientMedicationInstructions.Count > 0)
                    {

                        string str = " and ClientMedicationId <> " + dvClientMedicationInstructions[0]["ClientMedicationId"].ToString();
                        DataRow[] drTemp = _DataSetCurrentMedications.Tables["TableCurrentMedications"].Select("ClientMedicationId=" + dvClientMedicationInstructions[0]["ClientMedicationId"]);

                        if (drTemp.Length > 0)
                            dtClientMedication.ImportRow(drTemp[0]);
                        dvClientMedicationInstructions.RowFilter = dvClientMedicationInstructions.RowFilter + str;
                    }
                    dataViewCurrentMedications = dtClientMedication.DefaultView;
                }
                else
                {
                    dataViewCurrentMedications = _DataSetCurrentMedications.Tables["TableCurrentMedications"].DefaultView;
                    dataViewCurrentMedications.Sort = _sortString;
                }

                //foreach (DataRow drMedication in dataViewCurrentMedications)
                for (int index = 0; index < dataViewCurrentMedications.Count; index++)
                {
                    int medicationId = Convert.ToInt32(dataViewCurrentMedications[index]["ClientMedicationId"]);
                    string MedicationName = dataViewCurrentMedications[index]["MedicationName"].ToString();
                    string prescribedBy = dataViewCurrentMedications[index]["PrescriberName"].ToString();
                    string DispenceQty = "";
                    int prescriberId = 0;
                    if (dataViewCurrentMedications[index]["PrescriberId"].ToString() != "" && dataViewCurrentMedications[index]["PrescriberId"].ToString() != null)
                    {
                        prescriberId = Convert.ToInt32(dataViewCurrentMedications[index]["PrescriberId"].ToString());
                    }
                    int ClientMedicationScriptDrugStrengthId = 0;
                    if (dataViewCurrentMedications[index]["ClientMedicationScriptDrugStrengthId"].ToString() != "" && dataViewCurrentMedications[index]["ClientMedicationScriptDrugStrengthId"].ToString() != null)
                    {
                        ClientMedicationScriptDrugStrengthId = Convert.ToInt32(dataViewCurrentMedications[index]["ClientMedicationScriptDrugStrengthId"].ToString());
                    }

                    int ClientMedicationId = 0;
                    if (dataViewCurrentMedications[index]["ClientMedicationId"].ToString() != "" && dataViewCurrentMedications[index]["ClientMedicationId"].ToString() != null)
                    {
                        ClientMedicationId = Convert.ToInt32(dataViewCurrentMedications[index]["ClientMedicationId"].ToString());
                    }
                    //string specialInstruction = drMedication["SpecialInstructions"].ToString();
                    int MedicationNameId = dataViewCurrentMedications[index]["MedicationNameId"] == DBNull.Value ? 0 : Convert.ToInt32(dataViewCurrentMedications[index]["MedicationNameId"]);
                    string startDate = "";
                    startDate = dataViewCurrentMedications[index]["MedicationStartDate"] == DBNull.Value ? "" : dataViewCurrentMedications[index]["MedicationStartDate"].ToString();
                    if (startDate != "")
                    {
                        startDate = Convert.ToDateTime(startDate).ToString("MM/dd/yyyy");
                    }
                    else
                    {
                        startDate = "";
                    }
                    string endDate = dataViewCurrentMedications[index]["MedicationEndDate"] == DBNull.Value ? "" : dataViewCurrentMedications[index]["MedicationEndDate"].ToString();
                    if (endDate != "")
                    {
                        endDate = Convert.ToDateTime(endDate).ToString("MM/dd/yyyy");
                    }
                    else
                    {
                        endDate = "";
                    }
                    DataRow[] drMedInstructions;
                    drMedInstructions = _DataSetCurrentMedications.Tables["TableClientMedicationInstruction"].Select("ClientMedicationId=" + medicationId + " and ClientMedicationScriptDrugStrengthId=" + ClientMedicationScriptDrugStrengthId, _sortString);
                    //drMedInstructions = dtMedicationInstructionTemp.Select("ClientMedicationId=" + medicationId);


                    bool _showMedication = true;
                    foreach (DataRow drTemp in drMedInstructions)
                    {
                        tblMedication.Rows.Add(GenerateCurrentMedicationSubRows(drTemp, prescribedBy, tblMedication.ClientID, startDate, endDate, _boolRowWithInteractionFound, prescriberId, DispenceQty, _showMedication, ClientMedicationScriptDrugStrengthId, ClientMedicationId, MedicationName));
                        _showMedication = false;
                        startDate = string.Empty;
                        endDate = string.Empty;
                    }
                    TableRow trLine = new TableRow();
                    TableCell tdHorizontalLine = new TableCell();
                    tdHorizontalLine.ColumnSpan = 8;
                    tdHorizontalLine.CssClass = "blackLine";
                    trLine.Cells.Add(tdHorizontalLine);
                    tblMedication.Rows.Add(trLine);
                }
            }
            PanelCurrentMedicationListInformation.Controls.Add(tblMedication);
            //return 
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
    /// <Description>Used to display sub rows of CurrentMedication record of Client</Description>
    /// <Author>Anuj</Author>
    /// <CreatedOn>4 jan 2009</CreatedOn>
    /// </summary>
    /// <param name=""></param>
    /// <param name=""></param>
    /// <param name="sortString"></param>
    private TableRow GenerateCurrentMedicationSubRows(DataRow drTemp, string PrescribedBy, string tableId, string startDate, string endDate, bool _boolRowWithInteractionFound, int prescriberId, string DispenceQty, bool Medication, int ClientMedicationScriptDrugStrengthId, int ClientMedicationId, string MedicationName)
    {
        try
        {
            CommonFunctions.Event_Trap(this);
            string newId = System.Guid.NewGuid().ToString();
            int MedicationId = Convert.ToInt32(drTemp["ClientMedicationId"]);

            string tblId = this.ClientID + this.ClientIDSeparator + tableId;
            TableRow trTemp = new TableRow();
            trTemp.ID = "Tr_" + newId;
            int client = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId;

            //Ist Column
            TableCell tdStartDate = new TableCell();
            //tdStartDate.Text = OrderDate;
            tdStartDate.Text = startDate;

            //IInd Column
            TableCell tdEndDate = new TableCell();
            tdEndDate.Text = endDate;

            //IIIrd Column
            TableCell tdOrderStart = new TableCell();
            if (drTemp["StartDate"].ToString() != "")
            {
                tdOrderStart.Text = Convert.ToDateTime(drTemp["StartDate"]).ToString("MM/dd/yyyy");
            }
            //IVth Column
            TableCell tdOrderEnd = new TableCell();
            if (drTemp["EndDate"].ToString() != "")
            {
                tdOrderEnd.Text = Convert.ToDateTime(drTemp["EndDate"]).ToString("MM/dd/yyyy");
            }
            Label lblMedication = new Label();
            lblMedication.ID = "Lbl_" + MedicationId.ToString();
            //Vth Column
            TableCell tdMedication = new TableCell();
            lblMedication.Text = MedicationName;
            tdMedication.Controls.Add(lblMedication);
            if (Medication == false)
            {
                tdMedication.Controls.Clear();
                tdMedication.Text = "";
            }
            //VIth Column
            TableCell tdRadioButton = new TableCell();
            string rowId = this.ClientID + this.ClientIDSeparator + trTemp.ClientID;
            HtmlInputRadioButton rbTemp = new HtmlInputRadioButton();
            rbTemp.Name = ClientID.ToString();//Addedd By Pradeep as per task#3299
            rbTemp.Attributes.Add("ClientMedicationId", drTemp["ClientMedicationId"].ToString());
            rbTemp.Attributes.Add("ClientMedicationInstructionId", drTemp["ClientMedicationInstructionId"].ToString());
            rbTemp.Attributes.Add("onClick", "onCurrentMedicationRadioClick(" + ClientMedicationScriptDrugStrengthId + "," + ClientMedicationId + ")");
            rbTemp.ID = "Rb_" + MedicationId.ToString();
            tdRadioButton.Controls.Add(rbTemp);
            if (Medication == false)
            {
                //myscript += "var Radiocontext" + MedicationId + "={MedicationId:" + MedicationId + ",MedicationInstructionsId:" + drTemp["MedicationInstructionId"].ToString() + ",TableId:'" + tblId + "',RowId:'" + rowId + "'};";
                //myscript += "var RadioclickCallback" + MedicationId + " =";
                //myscript += " Function.createCallback(" + this._onRadioClickEventHandler + ", Radiocontext" + MedicationId + ");";
                //myscript += "$addHandler($get('" + this.ClientID + this.ClientIDSeparator + rbTemp.ClientID + "'), 'click', RadioclickCallback" + MedicationId + ");";
            }
            //VIIth Column
            TableCell tdOrder = new TableCell();
            tdOrder.Text = drTemp["Instruction"] == DBNull.Value ? "" : drTemp["Instruction"].ToString();

            if (Medication == false)
            {
                tdRadioButton.Controls.Clear();
                tdRadioButton.Text = "";
            }
            //VIIIth Column
            TableCell tdPrescribed = new TableCell();
            tdPrescribed.Text = PrescribedBy;
            if (Medication == false)
            {
                tdPrescribed.Controls.Clear();
                tdPrescribed.Text = "";
            }
            //VIIIth Column
            TableCell tdDispenceQty = new TableCell();
            tdDispenceQty.Text = DispenceQty;
            if (drTemp["DispenseQuantity"] != null)
            {
                tdDispenceQty.Controls.Clear();
                tdDispenceQty.Text = Convert.ToString(drTemp["DispenseQuantity"]);
            }

            trTemp.Cells.Add(tdRadioButton);
            trTemp.Cells.Add(tdMedication);
            trTemp.Cells.Add(tdStartDate);
            trTemp.Cells.Add(tdOrder);//Instruction
            trTemp.Cells.Add(tdDispenceQty);
            trTemp.Cells.Add(tdOrderStart);
            trTemp.Cells.Add(tdOrderEnd);

            trTemp.Cells.Add(tdPrescribed);

            trTemp.CssClass = "GridViewRowStyle";
            //RepeatMediactionId = MedicationId;
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
    //Added By Priya Date 17th Feb 2010 Ref:Task 85
    private void GetSureScriptRefill(int PrescriberID, string sortString)
    {
        Streamline.UserBusinessServices.SureScriptRefillRequest objSureScriptRefillRequest = null;
        DataSet dataSetSureScriptsRefillRequest = null;
        objSureScriptRefillRequest = new SureScriptRefillRequest();
        //DataView dataViewProxyPrescriber = null;
        string prescribers = string.Empty;
        try
        {
            prescriberId = PrescriberID;
            if (Request["CalledFrom"] == "CurrentMedications")
            {
                dataSetSureScriptsRefillRequest =
                    objSureScriptRefillRequest.GetSureScriptRefill(((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId, PrescriberID);
            }
            else
            {
                if (sortString != null && sortString != string.Empty)
                {
                    if (Session["DataSetSureScriptRequestRefill"] == null)
                    {
                        dataSetSureScriptsRefillRequest =
                            objSureScriptRefillRequest.GetSureScriptRefill(((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId, PrescriberID);
                    }
                    else
                    {
                        dataSetSureScriptsRefillRequest = (DataSet)Session["DataSetSureScriptRequestRefill"];
                    }
                }
                else
                {
                    dataSetSureScriptsRefillRequest =
                        objSureScriptRefillRequest.GetSureScriptRefill(((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId, PrescriberID);
                }
            }
            Session["DataSetSureScriptRequestRefill"] = null;
            Session["DataSetSureScriptRequestRefill"] = dataSetSureScriptsRefillRequest;
            DataView dataViewResult = dataSetSureScriptsRefillRequest.Tables[0].DefaultView;

            DataView dvSureScriptsRefillRequest = new DataView();
            dvSureScriptsRefillRequest = dataViewResult;
            dataViewResult.Sort = sortString;
            //GridViewRefillRequests.DataSource = AddEmptyRow(dataViewResult);
            //GridViewRefillRequests.DataBind();

            RefillList.DataSource = dataViewResult;
            RefillList.DataBind();

        }
        catch (Exception ex)
        {

            throw ex;
        }
        finally
        {
        }
    }
    private void GetSureScriptChange(int PrescriberID, string sortString)
    {
        Streamline.UserBusinessServices.SureScriptRefillRequest objSureScriptRefillRequest = null;
        DataSet dataSetSureScriptsRefillRequest = null;
        objSureScriptRefillRequest = new SureScriptRefillRequest();
        //DataView dataViewProxyPrescriber = null;
        string prescribers = string.Empty;
        try
        {
            prescriberId = PrescriberID;
            if (Request["CalledFrom"] == "RxChange")
            {
                dataSetSureScriptsRefillRequest =
                    objSureScriptRefillRequest.GetSureScriptChange(((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId, PrescriberID);
            }
            else
            {
                if (sortString != null && sortString != string.Empty)
                {
                    if (Session["DataSetSureScriptsChangeRequest"] == null)
                    {
                        dataSetSureScriptsRefillRequest =
                            objSureScriptRefillRequest.GetSureScriptRefill(((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId, PrescriberID);
                    }
                    else
                    {
                        dataSetSureScriptsRefillRequest = (DataSet)Session["DataSetSureScriptsChangeRequest"];
                    }
                }
                else
                {
                    dataSetSureScriptsRefillRequest =
                        objSureScriptRefillRequest.GetSureScriptChange(((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId, PrescriberID);
                }
            }
            Session["DataSetSureScriptsChangeRequest"] = null;
            Session["DataSetSureScriptsChangeRequest"] = dataSetSureScriptsRefillRequest;
            DataView dataViewResult = dataSetSureScriptsRefillRequest.Tables[0].DefaultView;

            DataView dvSureScriptsRefillRequest = new DataView();
            dvSureScriptsRefillRequest = dataViewResult;
            dataViewResult.Sort = sortString;
            //GridViewRefillRequests.DataSource = AddEmptyRow(dataViewResult);
            //GridViewRefillRequests.DataBind();

            ChangeList.DataSource = dataViewResult;
            ChangeList.DataBind();

        }
        catch (Exception ex)
        {

            throw ex;
        }
        finally
        {
        }
    }

  

    private void GenerateOutboundRows(DataSet dataSetSureScriptsOutboundPrescriptions)
    {

        bool _boolRowWithInteractionFound = false;
        try
        {
            CommonFunctions.Event_Trap(this);

            System.Drawing.Color[] _color = 
                { 
                System.Drawing.Color.Pink, 
                System.Drawing.Color.Red, 
                System.Drawing.Color.Yellow, 
                System.Drawing.Color.Green, 
                System.Drawing.Color.Plum, 
                System.Drawing.Color.Aqua, 
                System.Drawing.Color.PaleGoldenrod, 
                System.Drawing.Color.Peru, 
                System.Drawing.Color.Tan, 
                System.Drawing.Color.Khaki, 
                System.Drawing.Color.DarkGoldenrod, 
                System.Drawing.Color.Maroon, 
                System.Drawing.Color.OliveDrab ,
               
                System.Drawing.Color.Crimson,
                System.Drawing.Color.Beige,
                System.Drawing.Color.DimGray,
                System.Drawing.Color.ForestGreen,
                System.Drawing.Color.Indigo,
                System.Drawing.Color.LightCyan           
                };
            PanelOutBoundPrescription.Controls.Clear();
            Table tblOutBoundPrescriptions = new Table();
            tblOutBoundPrescriptions.ID = System.Guid.NewGuid().ToString();

            tblOutBoundPrescriptions.Width = new Unit(98, UnitType.Percentage);

            //Table Row Started
            TableHeaderRow thTitle = new TableHeaderRow();

            //Balnk  Table Header Cell
            TableHeaderCell thcBlank1 = new TableHeaderCell();

            //Table Header Cell For Prescriber             
            TableHeaderCell thcPrescriber = new TableHeaderCell();
            thcPrescriber.Text = "Prescriber";
            thcPrescriber.Font.Underline = true;
            thcPrescriber.Attributes.Add("onClick", "onOutboundPrescriptionHeaderClick(this)");
            thcPrescriber.Attributes.Add("ColumnName", "OrderingPrescriberName");
            //thcPrescriber.Attributes.Add("SortOrder", setAttributes());
            if (dataSetSureScriptsOutboundPrescriptions.Tables["ClientMedicationScriptActivitiesPending"].Rows.Count > 0)
            {
                thcPrescriber.CssClass = "handStyle";
            }

            //Table Header Cell For Patient Name    
            TableHeaderCell thcPatientName = new TableHeaderCell();
            thcPatientName.Text = "Patient Name";
            thcPatientName.Font.Underline = true;
            thcPatientName.Attributes.Add("onClick", "onOutboundPrescriptionHeaderClick(this)");
            thcPatientName.Attributes.Add("ColumnName", "PatientName");
            //thcPatientName.Attributes.Add("SortOrder", setAttributes());
            thcPatientName.Width = 120;
            if (dataSetSureScriptsOutboundPrescriptions.Tables["ClientMedicationScriptActivitiesPending"].Rows.Count > 0)
            {
                thcPatientName.CssClass = "handStyle";
            }
            //Table Header Cell For Date    
            TableHeaderCell thcDate = new TableHeaderCell();
            thcDate.Text = "Date";
            thcDate.Font.Underline = true;
            thcDate.Attributes.Add("onClick", "onOutboundPrescriptionHeaderClick(this)");
            thcDate.Attributes.Add("ColumnName", "CreatedDate");
            //thcDate.Attributes.Add("SortOrder", setAttributes());
            if (dataSetSureScriptsOutboundPrescriptions.Tables["ClientMedicationScriptActivitiesPending"].Rows.Count > 0)
            {
                thcDate.CssClass = "handStyle";
            }

            //Table Header Cell For Medication    
            TableHeaderCell thcMedication = new TableHeaderCell();
            thcMedication.Text = "Medication";
            thcMedication.Font.Underline = true;
            thcMedication.Attributes.Add("onClick", "onOutboundPrescriptionHeaderClick(this)");
            thcMedication.Attributes.Add("ColumnName", "MedicationName");
            //thcMedication.Attributes.Add("SortOrder", setAttributes());
            if (dataSetSureScriptsOutboundPrescriptions.Tables["ClientMedicationScriptActivitiesPending"].Rows.Count > 0)
            {
                thcMedication.CssClass = "handStyle";
            }
            //Table Header Cell For Instructions                         
            TableHeaderCell thcInstruction = new TableHeaderCell();
            thcInstruction.Text = "Strength/Instructions";
            thcInstruction.Font.Underline = true;
            thcInstruction.Attributes.Add("onClick", "onOutboundPrescriptionHeaderClick(this)");
            thcInstruction.Attributes.Add("ColumnName", "Instruction");
            //thcInstruction.Attributes.Add("SortOrder", setAttributes());
            if (dataSetSureScriptsOutboundPrescriptions.Tables["ClientMedicationScriptActivitiesPending"].Rows.Count > 0)
            {
                thcInstruction.CssClass = "handStyle";
            }

            //Table Header Cell For Pharmacy       
            TableHeaderCell thcPharmacy = new TableHeaderCell();
            thcPharmacy.Text = "Pharmacy";
            thcPharmacy.Font.Underline = true;
            thcPharmacy.Attributes.Add("onClick", "onOutboundPrescriptionHeaderClick(this)");
            thcPharmacy.Attributes.Add("ColumnName", "PharmacyName");
            //thcPharmacy.Attributes.Add("SortOrder", setAttributes());

            if (dataSetSureScriptsOutboundPrescriptions.Tables["ClientMedicationScriptActivitiesPending"].Rows.Count > 0)
            {
                thcPharmacy.CssClass = "handStyle";
            }
            //Table Header Cell For Method    
            TableHeaderCell thcMethod = new TableHeaderCell();
            thcMethod.Text = "Method";
            thcMethod.Font.Underline = true;
            thcMethod.Attributes.Add("onClick", "onOutboundPrescriptionHeaderClick(this)");
            thcMethod.Attributes.Add("ColumnName", "Method");
            //thcMethod.Attributes.Add("SortOrder", setAttributes());
            if (dataSetSureScriptsOutboundPrescriptions.Tables["ClientMedicationScriptActivitiesPending"].Rows.Count > 0)
            {
                thcMethod.CssClass = "handStyle";
            }

            //Table Header Cell For Status
            TableHeaderCell thcStatus = new TableHeaderCell();
            thcStatus.Text = "Status";
            thcStatus.Font.Underline = true;
            thcStatus.Attributes.Add("onClick", "onOutboundPrescriptionHeaderClick(this)");
            thcStatus.Attributes.Add("ColumnName", "Status");
            //thcStatus.Attributes.Add("SortOrder", setAttributes());
            if (dataSetSureScriptsOutboundPrescriptions.Tables["ClientMedicationScriptActivitiesPending"].Rows.Count > 0)
            {
                thcStatus.CssClass = "handStyle";
            }

            //Table Header Cell For Description
            TableHeaderCell thcDescription = new TableHeaderCell();
            thcDescription.Text = "Description";
            thcDescription.Font.Underline = true;
            thcDescription.Attributes.Add("onClick", "onOutboundPrescriptionHeaderClick(this)");
            thcDescription.Attributes.Add("ColumnName", "StatusDescription");
            //thcDescription.Attributes.Add("SortOrder", setAttributes());
            if (dataSetSureScriptsOutboundPrescriptions.Tables["ClientMedicationScriptActivitiesPending"].Rows.Count > 0)
            {
                thcDescription.CssClass = "handStyle";
            }

            //Adding all the header columns in Header rows
            thTitle.Cells.Add(thcBlank1);
            thTitle.Cells.Add(thcPrescriber);
            thTitle.Cells.Add(thcPatientName);

            thTitle.Cells.Add(thcDate);
            thTitle.Cells.Add(thcMedication);
            thTitle.Cells.Add(thcInstruction);
            thTitle.Cells.Add(thcPharmacy);
            thTitle.Cells.Add(thcMethod);
            thTitle.Cells.Add(thcStatus);
            thTitle.Cells.Add(thcDescription);

            thTitle.CssClass = "GridViewHeaderText";
            tblOutBoundPrescriptions.Rows.Add(thTitle);
            if (dataSetSureScriptsOutboundPrescriptions != null && dataSetSureScriptsOutboundPrescriptions.Tables["ClientMedicationScriptActivitiesPending"].Rows.Count > 0)
            {
                DataView dataViewOutBoundPrescriptions = null;
                if (Request.Form["sortString"] != null)
                {
                    if (Request.Form["sortString"].ToString().Contains("Instruction"))
                    {
                        dataViewOutBoundPrescriptions = dataSetSureScriptsOutboundPrescriptions.Tables["ClientMedicationScriptActivitiesPending"].DefaultView;
                    }
                    else
                    {
                        dataViewOutBoundPrescriptions = dataSetSureScriptsOutboundPrescriptions.Tables["ClientMedicationScriptActivitiesPending"].DefaultView;
                        dataViewOutBoundPrescriptions.Sort = Request.Form["sortString"].ToString();
                    }
                }
                else
                {
                    dataViewOutBoundPrescriptions = dataSetSureScriptsOutboundPrescriptions.Tables["ClientMedicationScriptActivitiesPending"].DefaultView;
                }
                for (int index = 0; index < dataViewOutBoundPrescriptions.Count; index++)
                {
                    string prescriberName = Convert.ToString(dataViewOutBoundPrescriptions[index]["OrderingPrescriberName"]);
                    //Commented by Loveena in ref to Task#3253-2.4 Outbound Prescriptions
                    //prescriberName = ApplicationCommonFunctions.cutText((prescriberName), 15);
                    string patientName = Convert.ToString(dataViewOutBoundPrescriptions[index]["PatientName"]);
                    //patientName = ApplicationCommonFunctions.cutText((patientName), 15);
                    string date = Convert.ToDateTime(dataViewOutBoundPrescriptions[index]["CreatedDate"]).ToString("MM/dd/yyyy");
                    string medication = Convert.ToString(dataViewOutBoundPrescriptions[index]["MedicationName"]);
                    string pharmacy = Convert.ToString(dataViewOutBoundPrescriptions[index]["PharmacyName"]);
                    string method = Convert.ToString(dataViewOutBoundPrescriptions[index]["Method"]);
                    string status = Convert.ToString(dataViewOutBoundPrescriptions[index]["Status"]);
                    string description = Convert.ToString(dataViewOutBoundPrescriptions[index]["StatusDescription"]);
                    int clientMedicationScriptActivityId = Convert.ToInt32(dataViewOutBoundPrescriptions[index]["ClientMedicationScriptActivityId"]);
                    DataRow[] drMedInstructions;
                    if (Request.Form["sortString"] != null)
                    {
                        if (Convert.ToString(Request.Form["sortString"]).Contains("Instruction"))
                            drMedInstructions = dataSetSureScriptsOutboundPrescriptions.Tables["ClientMedicationInstructions"].Select("ClientMedicationScriptActivityId=" + dataViewOutBoundPrescriptions[index]["ClientMedicationScriptActivityId"] + " and ClientMedicationId=" + dataViewOutBoundPrescriptions[index]["ClientMedicationId"], Request.Form["sortString"].ToString());
                        else
                            drMedInstructions = dataSetSureScriptsOutboundPrescriptions.Tables["ClientMedicationInstructions"].Select("ClientMedicationScriptActivityId=" + dataViewOutBoundPrescriptions[index]["ClientMedicationScriptActivityId"] + " and ClientMedicationId=" + dataViewOutBoundPrescriptions[index]["ClientMedicationId"]);
                    }
                    else
                        drMedInstructions = dataSetSureScriptsOutboundPrescriptions.Tables["ClientMedicationInstructions"].Select("ClientMedicationScriptActivityId=" + dataViewOutBoundPrescriptions[index]["ClientMedicationScriptActivityId"] + " and ClientMedicationId=" + dataViewOutBoundPrescriptions[index]["ClientMedicationId"]);
                    bool showMedication = true;
                    bool showPrescriber = true;
                    bool showPatientName = true;
                    bool showDate = true;
                    bool showPharmacy = true;
                    bool showMethod = true;
                    bool showStatus = true;
                    bool showDescription = true;
                    bool showDelete = false;
                    if (status == "Failed")
                        showDelete = true;
                    foreach (DataRow drTemp in drMedInstructions)
                    {
                        tblOutBoundPrescriptions.Rows.Add(GenerateOutBoundSubRows(drTemp, showPrescriber, showPatientName, showMedication, showDate, showPharmacy, showMethod, showStatus, showDescription, tblOutBoundPrescriptions.ClientID, prescriberName, patientName, date, medication, pharmacy, method, status, description, showDelete, clientMedicationScriptActivityId));
                        showMedication = false;
                        showPrescriber = false;
                        showPatientName = false;
                        showDate = false;
                        showPharmacy = false;
                        showMethod = false;
                        showStatus = false;
                        showDescription = false;
                        showDelete = false;
                    }
                    TableRow trLine = new TableRow();
                    //TableCell tdHorizontalLine = new TableCell();
                    //tdHorizontalLine.ColumnSpan = 10;
                    //tdHorizontalLine.CssClass = "blackLine";
                    //trLine.Cells.Add(tdHorizontalLine);
                    //tblOutBoundPrescriptions.Rows.Add(trLine);
                }
            }
            else
            {
                tblOutBoundPrescriptions.Rows.Add(GenerateOutBoundSubRows(null, false, false, true, false, false, false, false, false, tblOutBoundPrescriptions.ClientID, "", "", "", "No Records Found", "", "", "", "", false, 0));
                //TableRow trLine = new TableRow();
                //TableCell tdHorizontalLine = new TableCell();
                //tdHorizontalLine.ColumnSpan = 10;
                //tdHorizontalLine.CssClass = "blackLine";
                //trLine.Cells.Add(tdHorizontalLine);
                //tblOutBoundPrescriptions.Rows.Add(trLine);
            }
            PanelOutBoundPrescription.Controls.Add(tblOutBoundPrescriptions);
        }
        catch (Exception ex)
        {

            throw (ex);
        }
    }

    private TableRow GenerateOutBoundSubRows(DataRow drTemp, bool showPrescriber, bool showPatientName, bool showMedication, bool showDate, bool showPharmacy, bool showMethod, bool showStatus, bool showDescription, string tableId, string prescriberName, string patientName, string date, string medication, string pharmacy, string method, string status, string description, bool showDelete, int clientMedicationScriptActivityId)
    {
        try
        {
            CommonFunctions.Event_Trap(this);
            string newId = System.Guid.NewGuid().ToString();
            //int MedicationId = Convert.ToInt32(drTemp["ClientMedicationScriptActivityId"]);

            string tblId = this.ClientID + this.ClientIDSeparator + tableId;
            TableRow trTemp = new TableRow();
            trTemp.ID = "Tr_" + newId;
            int client = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId;

            //0th Column
            TableCell tdDelete = new TableCell();
            HtmlImage imgTemp = new HtmlImage();
            imgTemp.ID = "Img" + clientMedicationScriptActivityId;
            imgTemp.Src = "~/App_Themes/Includes/Images/deleteIcon.gif";
            imgTemp.Style.Add("cursor", "hand");
            imgTemp.Attributes.Add("onclick", "deleteScriptActivityPending(" + clientMedicationScriptActivityId + " )");
            if (showDelete == true)
                tdDelete.Controls.Add(imgTemp);
            else
                tdDelete.Controls.Clear();
            //Ist Column                   
            TableCell tdPrescriber = new TableCell();
            if (showPrescriber == true)
                tdPrescriber.Text = prescriberName;
            else
                tdPrescriber.Text = "";

            //IInd Column
            TableCell tdPatientName = new TableCell();
            if (showPatientName == true)
                tdPatientName.Text = patientName;
            else
                tdPatientName.Text = "";

            //IIIrd Column
            TableCell tdDate = new TableCell();
            if (showDate == true)
                tdDate.Text = date;
            else
                tdDate.Text = "";

            //IVth Column
            TableCell tdMedication = new TableCell();
            if (showMedication == true)
                tdMedication.Text = medication;
            else
                tdMedication.Text = "";

            //Vth Column
            TableCell tdInstructions = new TableCell();
            if (drTemp != null)
                tdInstructions.Text = drTemp["Instruction"].ToString();

            //VIth Column
            TableCell tdPharmacy = new TableCell();
            if (showPharmacy == true)
                tdPharmacy.Text = pharmacy;
            else
                tdPharmacy.Text = "";


            //VIIth Column            
            TableCell tdMethod = new TableCell();
            if (showMethod == true)
                tdMethod.Text = method;
            else
                tdMethod.Text = "";

            //VIIIth Column
            TableCell tdStatus = new TableCell();
            if (showStatus == true)
                tdStatus.Text = status;
            else
                tdStatus.Text = "";

            //VIIIth Column
            TableCell tdDescription = new TableCell();
            if (showDescription == true)
                tdDescription.Text = description;
            else
                tdDescription.Text = "";

            trTemp.Cells.Add(tdDelete);
            trTemp.Cells.Add(tdPrescriber);
            trTemp.Cells.Add(tdPatientName);
            trTemp.Cells.Add(tdDate);
            trTemp.Cells.Add(tdMedication);//Instruction
            trTemp.Cells.Add(tdInstructions);
            trTemp.Cells.Add(tdPharmacy);
            trTemp.Cells.Add(tdMethod);
            trTemp.Cells.Add(tdStatus);
            trTemp.Cells.Add(tdDescription);

            trTemp.CssClass = "GridViewRowStyle";
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

    //Added in ref to Task#3254-2.4 Refill Requests Layout Changes
    private DataView AddEmptyRow(DataView dataViewResult)
    {

        DataTable originalDataTable = dataViewResult.ToTable();
        DataTable newDataTable = originalDataTable.Clone();
        DataView newDataView = newDataTable.DefaultView;
        if (originalDataTable.Rows.Count > 0)
        {
            string SureScriptsRefillRequestId = originalDataTable.Rows[0]["SureScriptsRefillRequestId"].ToString();
            foreach (DataRow dRow in originalDataTable.Rows)
            {
                if (SureScriptsRefillRequestId != dRow["SureScriptsRefillRequestId"].ToString())
                {
                    DataRow newDataRow = newDataView.Table.NewRow();
                    newDataView.Table.Rows.Add(newDataRow);
                    SureScriptsRefillRequestId = dRow["SureScriptsRefillRequestId"].ToString();
                }
                newDataView.Table.ImportRow(dRow);
            }
        }
        return newDataView;
    }

    public void RenderRefillRequestRow(object sender, ListViewItemEventArgs e)
    {
        if (e.Item.ItemType == ListViewItemType.DataItem)
        {
            try
            {
                string userCode = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                ListViewDataItem item = (ListViewDataItem)e.Item;

                ((Label)e.Item.FindControl("ImageDenyLabel")).Attributes.Add("onclick", "openRefillDeniedReason(" + DataBinder.Eval(item.DataItem, "SureScriptsRefillRequestId") + ", '" + userCode + "');");
                ((Label)e.Item.FindControl("ImageSearchLabel")).Attributes.Add("onclick", "ShowClientSearch('" + DataBinder.Eval(item.DataItem, "ClientId") + "','" + CommonFunctions.ReplaceSpecialChars(DataBinder.Eval(item.DataItem, "ClientFirstName").ToString()) + "','" + CommonFunctions.ReplaceSpecialChars(DataBinder.Eval(item.DataItem, "ClientLastName").ToString()) + "'," + DataBinder.Eval(item.DataItem, "SureScriptsRefillRequestId") + ", " + DataBinder.Eval(item.DataItem, "PrescriberId") + ");");

                Label age = (Label)e.Item.FindControl("ClientDOBAge");
                DateTime dob = (DateTime)DataBinder.Eval(item.DataItem, "ClientDOB");
                DateTime now = DateTime.Now;
                int years = (int)(now.Year - dob.Year);
                if (now < dob.AddYears(years)) years--;
                age.Text = "(" + years.ToString() + ")";

                var _clientid = DataBinder.Eval(item.DataItem, "ClientId");
                var _clientMedicationScriptDrugStrengthid = DataBinder.Eval(item.DataItem,
                                                                            "ClientMedicationScriptDrugStrengthId");

                string _imageApproved = "~/App_Themes/Includes/Images/disable_41.png";
                string _imageApprovedWithChanges = "~/App_Themes/Includes/Images/disable_43.png";
                string _imageDeniedNewPrescriptions = "~/App_Themes/Includes/Images/disable_45.png";
                Label _errorSpan = ((Label)e.Item.FindControl("ErrorSpan"));

                Int16[] _surescriptsServiceLevels =
                    {
                        1, // New Rx
                        2, // Refill
                        16 // Cancel
                    };
                var _serviceLevel = Convert.ToInt16(DataBinder.Eval(item.DataItem, "ServiceLevel"));

                if (_serviceLevel > 0)
                {
                    _errorSpan.Text = "Prescriber is not<br />Authorized";
                    _errorSpan.Visible = true;

                    for (int i = 0; i < _surescriptsServiceLevels.Length; i++)
                    {
                        if ((_serviceLevel & _surescriptsServiceLevels[i]) == _surescriptsServiceLevels[i])
                        {
                            _errorSpan.Text = string.Empty;
                            _errorSpan.Visible = false;
                            break;
                        }
                    }

                    if ((_serviceLevel & 2) != 2)
                    {
                        _errorSpan.Text = "Prescriber not<br />allowed to refill";
                        _errorSpan.Visible = true;
                    }
                }
                else // No Surescripts
                {
                    _errorSpan.Visible = true;
                    _errorSpan.Text = "Prescriber is not<br />Authorized";
                }
                if (_clientid != System.DBNull.Value)
                {
                    if ((_serviceLevel & 2) == 2)
                    {
                        _errorSpan.Visible = false;
                        if (_clientMedicationScriptDrugStrengthid != System.DBNull.Value)
                        {
                            _imageApproved = "~/App_Themes/Includes/Images/enable_16.png";
                            _imageApprovedWithChanges = "~/App_Themes/Includes/Images/enable_18.png";
                        }
                        _imageDeniedNewPrescriptions = "~/App_Themes/Includes/Images/enable_20.png";
                    }
                }
                ((Image)e.Item.FindControl("ImageApproved")).ImageUrl = _imageApproved;
                ((Image)e.Item.FindControl("ImageApprovedWithChanges")).ImageUrl = _imageApprovedWithChanges;
                ((Image)e.Item.FindControl("ImageDeniedNewPrescriptions")).ImageUrl = _imageDeniedNewPrescriptions;


                if (_clientid != System.DBNull.Value)
                {
                    ((Label)e.Item.FindControl("ImageDeniedNewPrescriptionsLabel")).Attributes.Add("onclick",
                                                                                                    "redirectToOrderPageFromDenialScreen(" +
                                                                                                    DataBinder.Eval(
                                                                                                        item.DataItem,
                                                                                                        "ClientId")
                                                                                                        + "," +
                                                                                              DataBinder.Eval(
                                                                                                  item.DataItem,
                                                                                                  "SureScriptsRefillRequestId") +
                                                                                                    "," +
                                                                                                    DataBinder.Eval(
                                                                                                        item.DataItem,
                                                                                                        "PharmacyId") +
                                                                                                    ",'" +
                                                                                                    CommonFunctions.ReplaceSpecialChars(DataBinder.Eval(
                                                                                                        item.DataItem,
                                                                                                        "PharmacyName").ToString()) +
                                                                                                    "'," + (String.IsNullOrEmpty(DataBinder.Eval(item.DataItem, "DrugCode").ToString()) ? "0" : DataBinder.Eval(item.DataItem, "DrugCode")) + ",'" +
                                                                                                    userCode + "');");
                    ((Label)e.Item.FindControl("ImageSearchMedicationLabel")).Attributes.Add("onclick",
                                                                                              "redirectToCurrentMedications(" +
                                                                                              DataBinder.Eval(
                                                                                                  item.DataItem,
                                                                                                  "ClientId") + "," +
                                                                                              DataBinder.Eval(
                                                                                                  item.DataItem,
                                                                                                  "SureScriptsRefillRequestId") +
                                                                                              ");");


                    if (_clientMedicationScriptDrugStrengthid != System.DBNull.Value)
                    {
                        ((Label)e.Item.FindControl("ImageApprovedLabel")).Attributes.Add("onclick", "ButtonDashBoardReFillOrderClick(" + DataBinder.Eval(item.DataItem, "ClientMedicationId") + ",'Refill'," + DataBinder.Eval(item.DataItem, "ClientId") + "," + DataBinder.Eval(item.DataItem, "SureScriptsRefillRequestId") + "," + DataBinder.Eval(item.DataItem, "PharmacyId") + ",'Approved'," + DataBinder.Eval(item.DataItem, "DispensedNumberOfRefills") + "," + DataBinder.Eval(item.DataItem, "DispensedQuantityValue", "{0:0.##}") + "," + DataBinder.Eval(item.DataItem, "DispensedQuantityValue", "{0:0.##}") + "," + DataBinder.Eval(item.DataItem, "DispensedNumberOfDaysSupply") + ",this," + (String.IsNullOrEmpty(DataBinder.Eval(item.DataItem, "DispensedDrugCode").ToString()) ? "0" : DataBinder.Eval(item.DataItem, "DispensedDrugCode")) + ",'" + CommonFunctions.ReplaceSpecialChars(DataBinder.Eval(item.DataItem, "PharmacyName").ToString()) + "', '" + DataBinder.Eval(item.DataItem, "DispensedPotencyUnitCode").ToString() + "');");
                        ((Label)e.Item.FindControl("ImageApprovedWithChangesLabel")).Attributes.Add("onclick", "ButtonDashBoardReFillOrderClick(" + DataBinder.Eval(item.DataItem, "ClientMedicationId") + ",'Refill'," + DataBinder.Eval(item.DataItem, "ClientId") + "," + DataBinder.Eval(item.DataItem, "SureScriptsRefillRequestId") + "," + DataBinder.Eval(item.DataItem, "PharmacyId") + ",'ApprovedWithChanges'," + DataBinder.Eval(item.DataItem, "DispensedNumberOfRefills") + "," + DataBinder.Eval(item.DataItem, "DispensedQuantityValue", "{0:0.##}") + "," + DataBinder.Eval(item.DataItem, "DispensedQuantityValue", "{0:0.##}") + "," + DataBinder.Eval(item.DataItem, "DispensedNumberOfDaysSupply") + ",this," + (String.IsNullOrEmpty(DataBinder.Eval(item.DataItem, "DispensedDrugCode").ToString()) ? "0" : DataBinder.Eval(item.DataItem, "DispensedDrugCode")) + ",'" + CommonFunctions.ReplaceSpecialChars(DataBinder.Eval(item.DataItem, "PharmacyName").ToString()) + "', '" + DataBinder.Eval(item.DataItem, "DispensedPotencyUnitCode").ToString() + "');");
                    }
                }
                else
                {
                    ((Label)e.Item.FindControl("ImageSearchMedicationLabel")).Visible = false;
                }

            }
            catch (Exception ex)
            {

            }
        }
    }

    public void RenderChangeRequestRow(object sender, ListViewItemEventArgs e)
    {
        if (e.Item.ItemType == ListViewItemType.DataItem)
        {
            try
            {
                string userCode = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                ListViewDataItem item = (ListViewDataItem)e.Item;

                ((Label)e.Item.FindControl("ImageDenyLabel")).Attributes.Add("onclick", "openRefillDeniedReason(" + DataBinder.Eval(item.DataItem, "SureScriptsChangeRequestId") + ", '" + userCode + "'" + ",'CHANGE');");
                ((Label)e.Item.FindControl("ImageSearchLabel")).Attributes.Add("onclick", "ShowClientSearch('" + DataBinder.Eval(item.DataItem, "ClientId") + "','" + CommonFunctions.ReplaceSpecialChars(DataBinder.Eval(item.DataItem, "ClientFirstName").ToString()) + "','" + CommonFunctions.ReplaceSpecialChars(DataBinder.Eval(item.DataItem, "ClientLastName").ToString()) + "'," + DataBinder.Eval(item.DataItem, "SureScriptsChangeRequestId") + ", " + DataBinder.Eval(item.DataItem, "PrescriberId") + ");");

                Label age = (Label)e.Item.FindControl("ClientDOBAge");
                DateTime dob = (DateTime)DataBinder.Eval(item.DataItem, "ClientDOB");
                DateTime now = DateTime.Now;
                int years = (int)(now.Year - dob.Year);
                if (now < dob.AddYears(years)) years--;
                age.Text = "(" + years.ToString() + ")";

                var _clientid = DataBinder.Eval(item.DataItem, "ClientId");
                var _clientMedicationScriptDrugStrengthid = DataBinder.Eval(item.DataItem, "ClientMedicationScriptDrugStrengthId");
                //     var RequestedDrugDescription = DataBinder.Eval(item.DataItem,"RequestedDrugDescription");
                var DrugDescritpion = DataBinder.Eval(item.DataItem, "DrugDescription");
                var ChangeRequestType = DataBinder.Eval(item.DataItem, "ChangeRequestType");

                var _drugSchedule = DataBinder.Eval(item.DataItem, "DrugCategory");
                bool _isDrugSchedule2OrMissingClientDemographics = !_drugSchedule.ToString().IsNullOrWhiteSpace() && Convert.ToInt16(_drugSchedule) == 2;

                //firstname, lastname, ODB, Gender, Address line 1, city, state, zip, phone,
                _isDrugSchedule2OrMissingClientDemographics = DataBinder.Eval(item.DataItem, "ClientLastName").ToString().IsNullOrWhiteSpace();
                _isDrugSchedule2OrMissingClientDemographics = DataBinder.Eval(item.DataItem, "ClientFirstName").ToString().IsNullOrWhiteSpace();
                _isDrugSchedule2OrMissingClientDemographics = DataBinder.Eval(item.DataItem, "PatientName").ToString().IsNullOrWhiteSpace();
                _isDrugSchedule2OrMissingClientDemographics = DataBinder.Eval(item.DataItem, "ClientAddress1").ToString().IsNullOrWhiteSpace();
                _isDrugSchedule2OrMissingClientDemographics = DataBinder.Eval(item.DataItem, "ClientCity").ToString().IsNullOrWhiteSpace();
                _isDrugSchedule2OrMissingClientDemographics = DataBinder.Eval(item.DataItem, "ClientState").ToString().IsNullOrWhiteSpace();
                _isDrugSchedule2OrMissingClientDemographics = DataBinder.Eval(item.DataItem, "ClientZip").ToString().IsNullOrWhiteSpace();
                _isDrugSchedule2OrMissingClientDemographics = DataBinder.Eval(item.DataItem, "ClientPhone").ToString().IsNullOrWhiteSpace();
                _isDrugSchedule2OrMissingClientDemographics = DataBinder.Eval(item.DataItem, "ClientSex").ToString().IsNullOrWhiteSpace();
                _isDrugSchedule2OrMissingClientDemographics = DataBinder.Eval(item.DataItem, "ClientDOB").ToString().IsNullOrWhiteSpace();
                _isDrugSchedule2OrMissingClientDemographics = DataBinder.Eval(item.DataItem, "ClientPhone").ToString().IsNullOrWhiteSpace();
                //ClientLastName	ClientFirstName	PatientName	ClientMiddleName	ClientAddress1	ClientCity	ClientState	ClientZip	ClientPhone	ClientSex	ClientDOB


                string _imageApproved = "~/App_Themes/Includes/Images/disable_41.png";
                string _imageApprovedWithChanges = "~/App_Themes/Includes/Images/disable_43.png";
                string _imageDeniedNewPrescriptions = "~/App_Themes/Includes/Images/disable_45.png";
                Label _errorSpan = ((Label)e.Item.FindControl("ErrorSpan"));

                Int16[] _surescriptsServiceLevels =
                {
                        1, // New Rx
                        2, // Refill
                        16 // Cancel
                    };
                var _serviceLevel = Convert.ToInt16(DataBinder.Eval(item.DataItem, "ServiceLevel"));

                if (_serviceLevel > 0)
                {
                    _errorSpan.Text = "Prescriber is not<br />Authorized";
                    _errorSpan.Visible = true;

                    for (int i = 0; i < _surescriptsServiceLevels.Length; i++)
                    {
                        if ((_serviceLevel & _surescriptsServiceLevels[i]) == _surescriptsServiceLevels[i])
                        {
                            _errorSpan.Text = string.Empty;
                            _errorSpan.Visible = false;
                            break;
                        }
                    }

                    if ((_serviceLevel & 2) != 2)
                    {
                        _errorSpan.Text = "Prescriber not<br />allowed to refill";
                        _errorSpan.Visible = true;
                    }
                }
                else // No Surescripts
                {
                    _errorSpan.Visible = true;
                    _errorSpan.Text = "Prescriber is not<br />Authorized";
                }
                if (_clientid != System.DBNull.Value) // Enables Approve,ApproveWithChangesButton
                {
                    if ((_serviceLevel & 2) == 2)
                    {
                        _errorSpan.Visible = false;
                        if (_clientMedicationScriptDrugStrengthid != System.DBNull.Value && !_isDrugSchedule2OrMissingClientDemographics)
                        {
                            _imageApproved = "~/App_Themes/Includes/Images/enable_16.png";
                            _imageApprovedWithChanges = "~/App_Themes/Includes/Images/enable_18.png";
                        }
                        _imageDeniedNewPrescriptions = "~/App_Themes/Includes/Images/enable_20.png";
                    }
                }
                //   if (RequestedDrugDescription.ToString().ToUpper() != DrugDescritpion.ToString().ToUpper())
                //   {
                //_imageApproved = "~/App_Themes/Includes/Images/disable_41.png";

                //  }
                if (ChangeRequestType.ToString().ToUpper() == "P")
                {
                    _imageApprovedWithChanges = "~/App_Themes/Includes/Images/disable_43.png";

                }
                ((Image)e.Item.FindControl("ImageApproved")).ImageUrl = _imageApproved;
                ((Image)e.Item.FindControl("ImageApprovedWithChanges")).ImageUrl = _imageApprovedWithChanges;
                //((Image)e.Item.FindControl("ImageDeniedNewPrescriptions")).ImageUrl = _imageDeniedNewPrescriptions;


                if (_clientid != System.DBNull.Value)
                {
                    string pharmacyId = Convert.ToString(DataBinder.Eval(item.DataItem, "PharmacyId"));
                    DataTable dataTablePharmacy;
                    string pharmacyFullName = CommonFunctions.ReplaceSpecialChars(DataBinder.Eval(item.DataItem, "PharmacyName").ToString());
                    if (!string.IsNullOrEmpty(pharmacyId))
                    {
                        dataTablePharmacy = GetFullAddressForPharmacy();
                        IEnumerable<DataRow> pharmacy = dataTablePharmacy.AsEnumerable().Where(row => row["PharmacyId"].ToString() == pharmacyId);
                        if (pharmacy.Count() == 1)
                        {
                            pharmacyFullName = Convert.ToString(pharmacy.First()["Fulladdress"]);
                        }
                    }


                    ((Label)e.Item.FindControl("ImageSearchMedicationLabel")).Attributes.Add("onclick",
                                                                                              "redirectToCurrentMedications(" +
                                                                                              DataBinder.Eval(
                                                                                                  item.DataItem,
                                                                                                  "ClientId") + "," +
                                                                                              DataBinder.Eval(
                                                                                                  item.DataItem,
                                                                                                  "SureScriptsChangeRequestId") +
                                                                                              ");");


                    if (_clientMedicationScriptDrugStrengthid != System.DBNull.Value && !_isDrugSchedule2OrMissingClientDemographics)
                    {
                        if (ChangeRequestType.ToString().ToUpper() == "P")
                        {
                            ((Label)e.Item.FindControl("ImageApprovedLabel")).Attributes.Add("onclick", "ButtonAuthorizeChangeOrderClick(" + DataBinder.Eval(item.DataItem, "SureScriptsChangeRequestId") + ");");
                        }
                        else
                        {
                            ((Label)e.Item.FindControl("ImageApprovedLabel")).Attributes.Add("onclick", "ButtonDashBoardChangeOrderClick(" + DataBinder.Eval(item.DataItem, "ClientMedicationId") + ",'CHANGEAPPROVALORDER'," + DataBinder.Eval(item.DataItem, "ClientId") + "," + DataBinder.Eval(item.DataItem, "SureScriptsChangeRequestId") + "," + DataBinder.Eval(item.DataItem, "PharmacyId") + ",'Approved'," + DataBinder.Eval(item.DataItem, "NumberOfRefills") + "," + DataBinder.Eval(item.DataItem, "QuantityValue", "{0:0.##}") + "," + DataBinder.Eval(item.DataItem, "QuantityValue", "{0:0.##}") + "," + DataBinder.Eval(item.DataItem, "NumberOfDaysSupply") + ",this," + (String.IsNullOrEmpty(DataBinder.Eval(item.DataItem, "DrugCode").ToString()) ? "0" : DataBinder.Eval(item.DataItem, "DrugCode")) + ",'" + pharmacyFullName + "', '" + DataBinder.Eval(item.DataItem, "PotencyUnitCode").ToString() + "');");
                            ((Label)e.Item.FindControl("ImageApprovedWithChangesLabel")).Attributes.Add("onclick", "ButtonDashBoardChangeOrderClick(" + DataBinder.Eval(item.DataItem, "ClientMedicationId") + ",'CHANGEAPPROVALORDER'," + DataBinder.Eval(item.DataItem, "ClientId") + "," + DataBinder.Eval(item.DataItem, "SureScriptsChangeRequestId") + "," + DataBinder.Eval(item.DataItem, "PharmacyId") + ",'ApprovedWithChanges'," + DataBinder.Eval(item.DataItem, "NumberOfRefills") + "," + DataBinder.Eval(item.DataItem, "QuantityValue", "{0:0.##}") + "," + DataBinder.Eval(item.DataItem, "QuantityValue", "{0:0.##}") + "," + DataBinder.Eval(item.DataItem, "NumberOfDaysSupply") + ",this," + (String.IsNullOrEmpty(DataBinder.Eval(item.DataItem, "DrugCode").ToString()) ? "0" : DataBinder.Eval(item.DataItem, "DrugCode")) + ",'" + pharmacyFullName + "', '" + DataBinder.Eval(item.DataItem, "PotencyUnitCode").ToString() + "');");
                        }
                    }
                }
                else
                {
                    ((Label)e.Item.FindControl("ImageSearchMedicationLabel")).Visible = false;
                }

            }
            catch (Exception ex)
            {

            }
        }

    }
    public void Updatestaff(string selectedstaff, string Enable, string Password, string Otp)
    {
        string strErrorMessage = "";
        UserPrefernces staffDetails = new UserPrefernces();
        bool isValidUser = false;
        string staffpassword = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).Password.ToString();
        try
        {
            isValidUser = AuthenticateUser(selectedstaff, Password);
            
            if (!isValidUser)
            {
                strErrorMessage = "PasswordFail";
            }
            else
            {
                Streamline.UserBusinessServices.DataSets.DataSetUserPrefrences.TwoFactorAuthenticationDeviceRegistrationsRow _dataRowTwoFactorAuthenticationDeviceRegistrations = null;
                TwoFactorAuthenticationResponse TwoFactorAuthenticationResponseObject = new TwoFactorAuthenticationResponse();
                TwoFactorAuthenticationRequest objTwoFactorAuthenticationRequest = new TwoFactorAuthenticationRequest();
                TwoFactorAuthentication objTwoFactorAuthentication = new TwoFactorAuthentication();
                objTwoFactorAuthenticationRequest.UserID = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).DeviceEmail;
                objTwoFactorAuthenticationRequest.Password = ApplicationCommonFunctions.GetDecryptedData(((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).DevicePassword, "Y");
                objTwoFactorAuthenticationRequest.OTP = Otp;
                string selectedStaffName = GetSelectedStaffName(selectedstaff);
                TwoFactorAuthenticationResponseObject = objTwoFactorAuthentication.Authenticate(objTwoFactorAuthenticationRequest, "Update Staff device registration for staff: " + selectedStaffName);
                if (TwoFactorAuthenticationResponseObject.Passed != true)
                {
                    strErrorMessage = "Fail";
                }
                else
                {
                    int EPCSAssignorStaffId = ((Streamline.BaseLayer.StreamlineIdentity)HttpContext.Current.User.Identity).UserId;
                    string CreatedBy = ((Streamline.BaseLayer.StreamlineIdentity)HttpContext.Current.User.Identity).UserCode;
                    strErrorMessage = staffDetails.UpdateStaff(selectedstaff, EPCSAssignorStaffId, CreatedBy, Enable, strErrorMessage);
                }

            }
        }
        catch (Exception ex)
        {
            strErrorMessage = "PasswordFail";
            if (ex.Data["CustomExceptionInformation"] == null)
                ex.Data["CustomExceptionInformation"] = "###Source Event Name -Updatestaff(), StaffID- " + selectedstaff +"###";
            else
                ex.Data["CustomExceptionInformation"] = "";
            if (ex.Data["DatasetInfo"] == null)
                ex.Data["DatasetInfo"] = null;
            Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);
           
        }
        Response.Clear();
        Response.Write(strErrorMessage);
        Response.End();

    }


    /// <summary>
    /// This function will return boolean value after authenticating username/password combination against Active Directory
    /// </summary>
    /// <Author>Pranay Bodhu</Author>
    /// <param name="username"></param>
    /// <param name="password"></param>
    /// <returns>True(If UserName/Password combination is Correct</returns>
    /// <returns>False(If UserName/Password combination is InCorrect</returns>
    public bool AuthenticateUser(string StaffId,String Password)
    {
        MedicationLogin objMedicationLogin = null;
        objMedicationLogin = new Streamline.UserBusinessServices.MedicationLogin();
        DataSet userAuthenticationType = null;
        string authType = string.Empty;
        string enableADAuthentication = string.Empty;
        bool isValidUser = false;
        string staffpassword = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).Password.ToString();
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
                isValidUser =
                                           objMedicationLogin.ADAuthenticateUser(
                                               ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode,
                                               Password,
                                               userAuthenticationType.Tables[
                                                   "Authentication"]
                                                   .Rows[0]["Domain"].ToString()
                                               );

            }
            else
            {
                if (staffpassword != Password)
                {
                    isValidUser = false;
                }
                else
                {
                    isValidUser = true ;
                }
            }
        }
        catch (Exception ex)
        {

            if (ex.Data["CustomExceptionInformation"] == null)
                ex.Data["CustomExceptionInformation"] = "###Source Event Name -AuthenticateUser(), StaffID- " + StaffId + "###";
            else
                ex.Data["CustomExceptionInformation"] = "";
            if (ex.Data["DatasetInfo"] == null)
                ex.Data["DatasetInfo"] = null;
            Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);

        }
        return isValidUser;
    }

    private DataTable GetFullAddressForPharmacy()
    {
        DataSet DataSetPharmacies = null;
        string[] ClientPharmecieIds = null;
        DataSet DataSetClientPharmecies = new DataSet();
        var objectSharedTables = new Streamline.UserBusinessServices.SharedTables();

        var _DataSetClientSummary = (DataSet)Session["DataSetClientSummary"];
        if (_DataSetClientSummary != null)
            ClientPharmecieIds = _DataSetClientSummary.Tables["ClientPharmacies"].AsEnumerable().Select(x => x["PharmacyId"].ToString()).ToArray();

        DataSetPharmacies = objectSharedTables.getPharmacies(((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId);
        //if (DataSetPharmacies != null && DataSetPharmacies.Tables[0].Rows.Count > 0)
        //{
        //    DataSetClientPharmecies.Merge(
        //        DataSetPharmacies.Tables[0].AsEnumerable()
        //                                   .Select(pharmacies => pharmacies)
        //                                   .Where(fax => fax["FaxNumber"].ToString().Length >= 7)
        //                                   .OrderBy(clientpharmacies => !ClientPharmecieIds.Contains(clientpharmacies["PharmacyId"].ToString()))
        //                                   .ThenBy(pharmacy => pharmacy["PharmacyName"]).CopyToDataTable());
        //}
        //else
        //{
        DataSetClientPharmecies = DataSetPharmacies;
        //}


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
                pharmacywithaddress = DataSetClientPharmecies.Tables[0].Rows[i]["PharmacyName"].ToString() + ", " + DataSetClientPharmecies.Tables[0].Rows[i]["Address"].ToString() + ", " + DataSetClientPharmecies.Tables[0].Rows[i]["City"].ToString() + ", " + DataSetClientPharmecies.Tables[0].Rows[i]["State"].ToString() + "," + DataSetClientPharmecies.Tables[0].Rows[i]["PhoneNumber"].ToString();
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
                    pharmacyphonenumber = DataSetClientPharmecies.Tables[0].Rows[i]["PhoneNumber"].ToString() + " - " + "EPCS";   /* Adding EPCS with PhoneNumber if it matches the service level */
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
            DataSetClientPharmecies.Tables[0].Rows[i]["Fulladdress"] = pharmacywithaddress + pharmacyphonenumber;
        }

        /* Binding the Values to the Dropdown */
        DataTable DataTableClientPharmacies = null;
        DataTableClientPharmacies = DataSetClientPharmecies.Tables[0];
        return DataTableClientPharmacies;
    }


    private string GetSelectedStaffName(string selectedstaff)
    {
        SqlParameter[] _objectSqlParmeters = null;
        _objectSqlParmeters = new SqlParameter[1];
        _objectSqlParmeters[0] = new SqlParameter("@Selectedstaff", selectedstaff);
        DataSet dataSetStaffName = SqlHelper.ExecuteDataset(_ConnectionString, "ssp_SCGetStaffNameByID", _objectSqlParmeters);
        return Convert.ToString(dataSetStaffName.Tables[0].Rows[0][0]) + " " + Convert.ToString(dataSetStaffName.Tables[0].Rows[0][1]); //0 - FirstName, 1 - LastName
    }

}



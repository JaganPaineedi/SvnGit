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
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.IO;
/// <summary>
/// Summary description for SureScriptRefillRequest
/// </summary>
namespace Streamline.SmartClient.WebServices
{
    /// <summary>
    /// Summary description for ClientMedications
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [ScriptService]
    public class SureScriptRefillRequest : Streamline.BaseLayer.WebServices.WebServiceBasePage
    {

        public SureScriptRefillRequest()
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

        [WebMethod(EnableSession = true)]
        public void OpenPatientMainPage(int clientId)
        {
            try
            {
                ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).RefreshData = true;
                ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).SetClientInformation(clientId, true);
                Session["LoadMgt"] = true;
                Session["ClientIdForValidateToken"] = clientId;

                Session["CurrentControl"] = "~/UserControls/MedicationMgt.ascx";
                Session["InitializeClient"] = true;

            }
            catch (Exception ex)
            {

                throw (ex);
            }
        }

        // Used by Refill  Approval order.
        [WebMethod(EnableSession = true)]
        public void SetClientInformation(int clientId, bool RequirePharamcies)
        {
            try
            {
                ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).RefreshData = true;
                ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).SetClientInformation(clientId, RequirePharamcies);
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
            Session["DataSetClientSummary"] = null;
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

        [WebMethod(EnableSession = true)]
        public void DenySureScriptsChangeRequests(Int32 SureScriptChangeRequestId, string DenialReasonCode, string DenialReasonText, string UserCode, int PrescriberId)
        {
            string denialMessageId = "CH_Deny_" + DateTime.UtcNow.Ticks.ToString();
            Streamline.UserBusinessServices.SureScriptRefillRequest objSureScriptsRefillrequest = null;
            Streamline.UserBusinessServices.ClientMedication ObjectClientMedication = null;
            try
            {
                objSureScriptsRefillrequest = new Streamline.UserBusinessServices.SureScriptRefillRequest();
                string GetDenialReasonText = DenialReasonText.Replace("\n", "");
                GetDenialReasonText = GetDenialReasonText.Replace("\r", "");
                int DenialReasonID = 0;
                if (DenialReasonCode != "")
                    DenialReasonID = Convert.ToInt32(DenialReasonCode);
                objSureScriptsRefillrequest.DenySureScriptsChangeRequests(SureScriptChangeRequestId, DenialReasonID, GetDenialReasonText, UserCode, denialMessageId);
                using (DataSet dataSetSureScriptsChangeRequest = (DataSet)(Session["DataSetSureScriptsChangeRequest"]))
                {
                    DataRow[] drSureScriptsChangeRequests = dataSetSureScriptsChangeRequest.Tables["SureScriptsChangeRequests"].Select("SureScriptsChangeRequestId=" + SureScriptChangeRequestId);
                    if (drSureScriptsChangeRequests.Length > 0)
                        drSureScriptsChangeRequests[0]["StatusOfRequest"] = "D";
                    ObjectClientMedication = new ClientMedication();
                    ObjectClientMedication.UpdateDocuments(dataSetSureScriptsChangeRequest);

                    //using(Streamline.UserBusinessServices.SureScriptRefillRequest objSureScriptRefillRequest = new Streamline.UserBusinessServices.SureScriptRefillRequest() )
                    //{
                    using (DataSet dsSureScripts = new DataSet())
                    {
                        objSureScriptsRefillrequest = new Streamline.UserBusinessServices.SureScriptRefillRequest();
                        dsSureScripts.Merge(objSureScriptsRefillrequest.GetSureScriptChange(((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId, PrescriberId));
                        Session["DataSetSureScriptRequestChange"] = dsSureScripts;
                    }
                    //}
                }
            }
            catch (Exception ex)
            {

                throw (ex);
            }
        }

        [WebMethod(EnableSession = true)]
        public void DenySureScriptsChangeRequestsWithNewRx(Int32 SureScriptREfillRequestId, string DenialReasonCode, string DenialReasonText, string UserCode, int PrescriberId)
        {
            string denialMessageId = "RF_DenyNew_" + DateTime.UtcNow.Ticks.ToString();
            Streamline.UserBusinessServices.SureScriptRefillRequest objSureScriptsRefillrequest = null;
            Streamline.UserBusinessServices.ClientMedication ObjectClientMedication = null;
            try
            {
                objSureScriptsRefillrequest = new Streamline.UserBusinessServices.SureScriptRefillRequest();
                string GetDenialReasonText = DenialReasonText.Replace("\n", "");
                GetDenialReasonText = GetDenialReasonText.Replace("\r", "");
                int DenialReasonID = 0;
                if (DenialReasonCode != "")
                    DenialReasonID = Convert.ToInt32(DenialReasonCode);
                objSureScriptsRefillrequest.DenySureScriptsRefillRequestsWithNewRx(SureScriptREfillRequestId, DenialReasonID, GetDenialReasonText, UserCode, denialMessageId);
            }
            catch (Exception ex)
            {

                throw (ex);
            }
        }

        [WebMethod(EnableSession = true)]
        public int AuthorizeChangeOrder(int SureScriptChangeRequestId)
        {
            Streamline.UserBusinessServices.SureScriptRefillRequest objSureScriptsRefillrequest = null;
            try
            {
                objSureScriptsRefillrequest = new Streamline.UserBusinessServices.SureScriptRefillRequest();
                return objSureScriptsRefillrequest.AuthorizeChangeOrder(SureScriptChangeRequestId);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - AuthorizeChangeOrder(),Parameter Count=2,Parameter Name=SureScriptChangeRequestId";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }
            finally
            {

            }
        }


        [WebMethod(EnableSession = true)]
        public void DenySureScriptsRefillRequests(Int32 SureScriptREfillRequestId, string DenialReasonCode, string DenialReasonText, string UserCode, int PrescriberId)
        {
            string denialMessageId = "RF_Deny_" + DateTime.UtcNow.Ticks.ToString();
            Streamline.UserBusinessServices.SureScriptRefillRequest objSureScriptsRefillrequest = null;
            Streamline.UserBusinessServices.ClientMedication ObjectClientMedication = null;
            try
            {
                objSureScriptsRefillrequest = new Streamline.UserBusinessServices.SureScriptRefillRequest();
                string GetDenialReasonText = DenialReasonText.Replace("\n", "");
                GetDenialReasonText = GetDenialReasonText.Replace("\r", "");
                int DenialReasonID = 0;
                if (DenialReasonCode != "")
                    DenialReasonID = Convert.ToInt32(DenialReasonCode);
                objSureScriptsRefillrequest.DenySureScriptsRefillRequests(SureScriptREfillRequestId, DenialReasonID, GetDenialReasonText, UserCode, denialMessageId);
                using (DataSet dataSetSureScriptsRefillRequest = (DataSet)(Session["DataSetSureScriptRequestRefill"]))
                {
                    DataRow[] drSureScriptsRefillRequests = dataSetSureScriptsRefillRequest.Tables["SureScriptsRefillRequests"].Select("SureScriptsRefillRequestId=" + SureScriptREfillRequestId);
                    if (drSureScriptsRefillRequests.Length > 0)
                        drSureScriptsRefillRequests[0]["StatusOfRequest"] = "D";
                    ObjectClientMedication = new ClientMedication();
                    ObjectClientMedication.UpdateDocuments(dataSetSureScriptsRefillRequest);

                   //using(Streamline.UserBusinessServices.SureScriptRefillRequest objSureScriptRefillRequest = new Streamline.UserBusinessServices.SureScriptRefillRequest() )
                   //{
                    using (DataSet dsSureScripts = new DataSet())
                    {
                        objSureScriptsRefillrequest = new Streamline.UserBusinessServices.SureScriptRefillRequest();
                        dsSureScripts.Merge(objSureScriptsRefillrequest.GetSureScriptRefill(((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId, PrescriberId));
                        Session["DataSetSureScriptRequestRefill"] = dsSureScripts;
                    }
                   //}
                }
            }
            catch (Exception ex)
            {

                throw (ex);
            }
        }

        [WebMethod(EnableSession = true)]
        public void DenySureScriptsRefillRequestsWithNewRx(Int32 SureScriptREfillRequestId, string DenialReasonCode, string DenialReasonText, string UserCode, int PrescriberId)
        {
            string denialMessageId = "RF_DenyNew_" + DateTime.UtcNow.Ticks.ToString();
            Streamline.UserBusinessServices.SureScriptRefillRequest objSureScriptsRefillrequest = null;
            Streamline.UserBusinessServices.ClientMedication ObjectClientMedication = null;
            try
            {
                objSureScriptsRefillrequest = new Streamline.UserBusinessServices.SureScriptRefillRequest();
                string GetDenialReasonText = DenialReasonText.Replace("\n", "");
                GetDenialReasonText = GetDenialReasonText.Replace("\r", "");
                int DenialReasonID = 0;
                if (DenialReasonCode != "")
                    DenialReasonID = Convert.ToInt32(DenialReasonCode);
                objSureScriptsRefillrequest.DenySureScriptsRefillRequestsWithNewRx(SureScriptREfillRequestId, DenialReasonID, GetDenialReasonText, UserCode, denialMessageId);
            }
            catch (Exception ex)
            {

                throw (ex);
            }
        }
    }

}

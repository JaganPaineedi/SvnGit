using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using Streamline.DataService;

namespace Streamline.UserBusinessServices
{
    public class SureScriptRefillRequest : IDisposable
    {
        Streamline.DataService.SureScriptRefillRequest objSureScriptRefillRequest = null;
        public SureScriptRefillRequest()
        {
            objSureScriptRefillRequest = new Streamline.DataService.SureScriptRefillRequest();
        }

        /// <summary>
        /// <Description>The Prescriber dropdown has values of All, Name of the Current User and 
        /// PrescriberProxies.PrescriberId where currentuser = ProxyStaffId</Description>
        /// <CreatedBy>Loveena</CreatedBy>
        /// <CreationDate>30Jan2010</CreationDate>
        /// </summary>
        /// <param name="staffId"></param>
        /// <returns></returns>
        public DataSet GetPrescriberProxies(int staffId)
        {
            try
            {
                return objSureScriptRefillRequest.GetPrescriberProxies(staffId);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetPrescriberProxies(), ParameterCount - 1, First Parameter- " + staffId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }

        }

        /// <summary>
        /// <Description>The Refill Requests tab gets records from SureScriptsRefillRequests table where StatusOfRequest = 'R' and 
        ///(CUrrentUSer = PrescriberId or the PrescriberId exists in PrescriberProxies where CurrentUser = ProxyStaffId)</Description>
        /// </summary>
        /// <param name="staffId"></param>
        /// <returns></returns>
        public DataSet GetSureScriptRefill(int staffId,int prescriberId)
        {
            try
            {
                return objSureScriptRefillRequest.GetSureScriptRefill(staffId,prescriberId);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetSureScriptRefill(), ParameterCount - 1, First Parameter- " + staffId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }

        }

        /// <summary>
        /// <Description> Used to get records for outbound prescription on clientlist page</Description>
        /// </summary>
        /// <param name="staffId"></param>
        /// <returns>dataset</returns>
        /// <Creater>Anuj Tomar on 15feb,2010</Creater>
        public DataSet GetSureScriptOutboundPrescription(int staffId,int prescriberId)
        {
            try
            {
                return objSureScriptRefillRequest.GetSureScriptOutboundPrescription(staffId,prescriberId);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetSureScriptOutboundPrescription(int staffId), ParameterCount - 1, First Parameter- " + staffId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }

        }
        /// <summary>
        /// <Description> Used to set the RecoredDeleted="Y" in ClientMedicationScriptActivitiesPending for passes Parameter</Description>
        /// </summary>
        /// <param name="staffId"></param>
        /// <returns></returns>
        /// <Creater>Anuj Tomar on 31March,2010</Creater>
        /// 
        public int DeleteClientMedicationScriptActivitiesPending(int ScriptActivitiesPendingId, string DeletedBy)
        {

            try
            {
                return objSureScriptRefillRequest.DeleteClientMedicationScriptActivitiesPending(ScriptActivitiesPendingId, DeletedBy);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - DeleteClientMedicationScriptActivitiesPending(),Parameter Count=2,Parameter Name=ScriptActivitiesPendingId";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }
            finally
            {

            }


        }


        public int AuthorizeChangeOrder(int SureScriptChangeRequestId)
        {
            try
            {
                return objSureScriptRefillRequest.AuthorizeChangeOrder(SureScriptChangeRequestId);
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

        /// <summary>
        /// <Description>Called on on Click of Deny Button in ref to Task#285</Description>
        /// <Author>Loveena</Author>
        /// <CreatedDat>13April2010</CreatedDat>
        /// </summary>
        /// <param name="SureScriptREfillRequestId"></param>
        /// <param name="UserCode"></param>
        public void DenySureScriptsRefillRequests(Int32 SureScriptREfillRequestId, Int32 DenialReasonCode, string DenialReasonText, string UserCode, string DeniedMessageId)
        {
            try
            {
                objSureScriptRefillRequest.DenySureScriptsRefillRequests(SureScriptREfillRequestId, DenialReasonCode, DenialReasonText, UserCode, DeniedMessageId);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - DenySureScriptsRefillRequests, ParameterCount - 2, First Parameter- " + SureScriptREfillRequestId + ", SecondParameter- " + UserCode + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
        }

        public void DenySureScriptsRefillRequestsWithNewRx(Int32 SureScriptREfillRequestId, Int32 DenialReasonCode, string DenialReasonText, string UserCode, string DeniedMessageId)
        {
            try
            {
                objSureScriptRefillRequest.DenySureScriptsRefillRequestsWithNewRx(SureScriptREfillRequestId, DenialReasonCode, DenialReasonText, UserCode, DeniedMessageId);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - DenySureScriptsRefillRequests, ParameterCount - 2, First Parameter- " + SureScriptREfillRequestId + ", SecondParameter- " + UserCode + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
        }

          /// <summary>
        /// <Description>The Change Requests tab gets records from SureScriptsCancelRequests table where StatusOfRequest = 'R' and 
        ///(CUrrentUSer = PrescriberId or the PrescriberId exists in PrescriberProxies where CurrentUser = ProxyStaffId)</Description>
        /// </summary>
        /// <param name="staffId"></param>
        /// <returns></returns>


        public DataSet GetSureScriptChange(int staffId, int prescriberId)
        {
            try
            {
                return objSureScriptRefillRequest.GetSureScriptChange(staffId, prescriberId);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetSureScriptChange(), ParameterCount - 1, First Parameter- " + staffId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }

        }



        public void DenySureScriptsChangeRequests(Int32 SureScriptCHANGERequestId, Int32 DenialReasonCode, string DenialReasonText, string UserCode, string DeniedMessageId)
        {
            try
            {
                objSureScriptRefillRequest.DenySureScriptsChangeRequests(SureScriptCHANGERequestId, DenialReasonCode, DenialReasonText, UserCode, DeniedMessageId);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - DenySureScriptsRefillRequests, ParameterCount - 2, First Parameter- " + SureScriptCHANGERequestId + ", SecondParameter- " + UserCode + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
        }


        /// <summary>
        /// <Description>The Start Requests tab gets records from SureScriptsCancelRequests table where StatusOfRequest = 'R' and 
        ///(CUrrentUSer = PrescriberId or the PrescriberId exists in PrescriberProxies where CurrentUser = ProxyStaffId)</Description>
        /// </summary>
        /// <param name="staffId"></param>
        /// <returns></returns>


        public DataSet GetSureScriptFill(int staffId, int prescriberId)
        {
            try
            {
                return objSureScriptRefillRequest.GetSureScriptFill(staffId, prescriberId);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetSureScriptStart(), ParameterCount - 1, First Parameter- " + staffId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }

        }



        #region IDisposable Members

        public void Dispose()
        {
            
        }

        #endregion
    }
}

using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace Streamline.DataService
{
    public class SureScriptRefillRequest
    {
        private SqlTransaction SqlTransactionObject = null;
        private SqlConnection SqlConnectionObject = null;

        private static SqlConnection _SqlConnectionObject = null;

        public static string ConnectionString = System.Configuration.ConfigurationSettings.AppSettings["SCConnectionString"];
        private string _ConnectionString = ConnectionString;

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
            SqlParameter[] _ParametersObject = null;
            try
            {
                _ParametersObject = new SqlParameter[1];
                _ParametersObject[0] = new SqlParameter("@StaffId ", staffId);
                return SqlHelper.ExecuteDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_SCGetPrescriberProxies", _ParametersObject);
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
            SqlParameter[] _ParametersObject = null;
            try
            {
                DataSet dsTemp = new DataSet();
                _ParametersObject = new SqlParameter[2];
                _ParametersObject[0] = new SqlParameter("@StaffId ", staffId);
                _ParametersObject[1] = new SqlParameter("@PrescriberId ", prescriberId);
                string[] _TableNames = { "SureScriptsRefillRequests" };
                SqlHelper.FillDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_SCGetRefillRequests", dsTemp, _TableNames, _ParametersObject);
                return dsTemp;
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

       public int AuthorizeChangeOrder(int SureScriptChangeRequestId)
       {
       
        SqlParameter[] _ParametersObject = null;
            try
            {
                DataSet dsTemp = new DataSet();
                _ParametersObject = new SqlParameter[1];
                _ParametersObject[0] = new SqlParameter("@SureScriptChangeRequestId", SureScriptChangeRequestId);
                int result = SqlHelper.ExecuteNonQuery(_ConnectionString, CommandType.StoredProcedure, "ssp_SureScriptsAuthorizeChangeRequest", _ParametersObject);
                return result;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - AuthorizeChangeOrder(), ParameterCount - 1, First Parameter- " + SureScriptChangeRequestId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
       
       
       }


        /// <summary>
        /// <Description>The Change Requests tab gets records from SureScriptsChangeRequests table where StatusOfRequest = 'R' and 
        ///(CUrrentUSer = PrescriberId or the PrescriberId exists in PrescriberProxies where CurrentUser = ProxyStaffId)</Description>
        /// </summary>
        /// <param name="staffId"></param>
        /// <returns></returns>
        public DataSet GetSureScriptChange(int staffId, int prescriberId)
        {
            SqlParameter[] _ParametersObject = null;
            try
            {
                DataSet dsTemp = new DataSet();
                _ParametersObject = new SqlParameter[2];
                _ParametersObject[0] = new SqlParameter("@StaffId ", staffId);
                _ParametersObject[1] = new SqlParameter("@PrescriberId ", prescriberId);
                string[] _TableNames = { "SureScriptsChangeRequests" };
                SqlHelper.FillDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_SCGetChangeRequests", dsTemp, _TableNames, _ParametersObject);
                return dsTemp;
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

        // <summary>
        /// <Description>Called on on Click of Deny Button in ref to Meaningul uses</Description>
        /// <Author>Pranay</Author>
        /// <CreatedDat>11Sep2017</CreatedDat>
        /// </summary>
        /// <param name="SureScriptChangeRequestId"></param>
        /// <param name="UserCode"></param>
        public void DenySureScriptsChangeRequests(Int32 SureScriptChangeRequestId, Int32 DenialReasonCode, string DenialReasonText, string UserCode, string DeniedMessageId)
        {
            SqlParameter[] _ParametersObject = null;
            try
            {
                int retInt = 0;
                _ParametersObject = new SqlParameter[6];
                _ParametersObject[0] = new SqlParameter("@SureScriptsChangeRequestId", SureScriptChangeRequestId);
                _ParametersObject[1] = new SqlParameter("@DenialReasonCode", DenialReasonCode);
                _ParametersObject[2] = new SqlParameter("@DenialReasonText", DenialReasonText);
                _ParametersObject[3] = new SqlParameter("@UserCode", UserCode);
                _ParametersObject[4] = new SqlParameter("@NewRxScriptToFollow", "N");
                _ParametersObject[5] = new SqlParameter("@DeniedMessageId", DeniedMessageId);

                SqlHelper.ExecuteNonQuery(_ConnectionString, CommandType.StoredProcedure, "ssp_SureScriptsDenyChangeRequest", _ParametersObject);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - DenySureScriptsChangeRequests, ParameterCount - 4, First Parameter- " + SureScriptChangeRequestId + " Second Parameter- " + DenialReasonCode + " Third Parameter- " + DenialReasonText + " Fourth Parameter- " + UserCode + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
        }



        /// <summary>
        /// <Description>The Start Requests tab gets records from SureScriptsChangeRequests table where StatusOfRequest = 'R' and 
        ///(CUrrentUSer = PrescriberId or the PrescriberId exists in PrescriberProxies where CurrentUser = ProxyStaffId)</Description>
        /// </summary>
        /// <param name="staffId"></param>
        /// <returns></returns>
        public DataSet GetSureScriptFill(int staffId, int prescriberId)
        {
            SqlParameter[] _ParametersObject = null;
            try
            {
                DataSet dsTemp = new DataSet();
                _ParametersObject = new SqlParameter[2];
                _ParametersObject[0] = new SqlParameter("@StaffId ", staffId);
                _ParametersObject[1] = new SqlParameter("@PrescriberId ", prescriberId);
                string[] _TableNames = { "SureScriptsStartRequests" };
                SqlHelper.FillDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_SCGetfillRequests", dsTemp, _TableNames, _ParametersObject);
                return dsTemp;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetSureScriptFill(), ParameterCount - 1, First Parameter- " + staffId + "###";
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
            SqlParameter[] _ParametersObject = null;
            try
            {
                DataSet dsTemp = new DataSet();
                _ParametersObject = new SqlParameter[2];
                _ParametersObject[0] = new SqlParameter("@StaffId ", staffId);
                _ParametersObject[1] = new SqlParameter("@PrescriberId ", prescriberId);
                string[] _TableNames = { "ClientMedicationScriptActivitiesPending" };
                SqlHelper.FillDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_SCGetSureScriptOutboundPrescription", dsTemp, _TableNames, _ParametersObject);
                return dsTemp;
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
        public int DeleteClientMedicationScriptActivitiesPending(int ScriptActivitiesPendingId, string DeletedBy)
        {
            SqlParameter[] _ParametersObject = null;
            try
            {
                int retInt = 0;
                _ParametersObject = new SqlParameter[2];
                _ParametersObject[0] = new SqlParameter("@ScriptActivitiesPendingId", ScriptActivitiesPendingId);
                _ParametersObject[1] = new SqlParameter("@DeletedBy", DeletedBy);
                retInt = SqlHelper.ExecuteNonQuery(_ConnectionString, CommandType.StoredProcedure, "ssp_SCDeleteClientMedicationScriptActivitiesPending", _ParametersObject);
                return retInt;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - DeleteClientMedicationScriptActivitiesPending, ParameterCount - 1, First Parameter- " + ScriptActivitiesPendingId + " Second Parameter- " + DeletedBy + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
        }

        // <summary>
        /// <Description>Called on on Click of Deny Button in ref to Task#285</Description>
        /// <Author>Loveena</Author>
        /// Modified By Priya
        /// <CreatedDat>13April2010</CreatedDat>
        /// </summary>
        /// <param name="SureScriptREfillRequestId"></param>
        /// <param name="UserCode"></param>
        public void DenySureScriptsRefillRequests(Int32 SureScriptREfillRequestId, Int32 DenialReasonCode, string DenialReasonText, string UserCode, string DeniedMessageId)
        {
            SqlParameter[] _ParametersObject = null;
            try
            {
                int retInt = 0;
                _ParametersObject = new SqlParameter[6];
                _ParametersObject[0] = new SqlParameter("@SureScriptsRefillRequestId", SureScriptREfillRequestId);
                _ParametersObject[1] = new SqlParameter("@DenialReasonCode", DenialReasonCode);
                _ParametersObject[2] = new SqlParameter("@DenialReasonText", DenialReasonText);
                _ParametersObject[3] = new SqlParameter("@UserCode", UserCode);
                _ParametersObject[4] = new SqlParameter("@NewRxScriptToFollow", "N");
                _ParametersObject[5] = new SqlParameter("@DeniedMessageId", DeniedMessageId);

                SqlHelper.ExecuteNonQuery(_ConnectionString, CommandType.StoredProcedure, "ssp_SureScriptsDenyRefillRequest", _ParametersObject);               
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - DenySureScriptsRefillRequests, ParameterCount - 4, First Parameter- " + SureScriptREfillRequestId + " Second Parameter- " + DenialReasonCode + " Third Parameter- " + DenialReasonText + " Fourth Parameter- " + UserCode + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
        }

        public void DenySureScriptsRefillRequestsWithNewRx(Int32 SureScriptREfillRequestId, Int32 DenialReasonCode, string DenialReasonText, string UserCode, string DeniedMessageId)
        {
            SqlParameter[] _ParametersObject = null;
            try
            {
                int retInt = 0;
                _ParametersObject = new SqlParameter[6];
                _ParametersObject[0] = new SqlParameter("@SureScriptsRefillRequestId", SureScriptREfillRequestId);
                _ParametersObject[1] = new SqlParameter("@DenialReasonCode", DenialReasonCode);
                _ParametersObject[2] = new SqlParameter("@DenialReasonText", DenialReasonText);
                _ParametersObject[3] = new SqlParameter("@UserCode", UserCode);
                _ParametersObject[4] = new SqlParameter("@NewRxScriptToFollow", "Y");
                _ParametersObject[5] = new SqlParameter("@DeniedMessageId", DeniedMessageId);

                SqlHelper.ExecuteNonQuery(_ConnectionString, CommandType.StoredProcedure, "ssp_SureScriptsDenyRefillRequest", _ParametersObject);               
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - DenySureScriptsRefillRequests, ParameterCount - 4, First Parameter- " + SureScriptREfillRequestId + " Second Parameter- " + DenialReasonCode + " Third Parameter- " + DenialReasonText + " Fourth Parameter- " + UserCode + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
        }
    }
}

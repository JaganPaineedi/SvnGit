using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Data.SqlClient;

namespace Streamline.DataService
{
    public class UserPreferences
    {
        public static string ConnectionString = System.Configuration.ConfigurationSettings.AppSettings["SCConnectionString"];
        private string _ConnectionString = ConnectionString;
        public DataSet DownloadStaffMedicationDetail()
        {
            DataSet dsTemp = null;
            try
            {
                dsTemp = new DataSet();
                string[] _TableNames = { };
                SqlHelper.FillDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_SCStaffMedicationDetail", dsTemp, _TableNames);
                return dsTemp;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - DownloadStaffMedicationDetail(), ParameterCount - 0, ###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
        }

        //Changes to merge.
        public DataSet CheckStaffPermissions(Int32 StaffId)
        {
            DataSet dsTemp = null;
            SqlParameter[] _ParametersObject = null;
            try
            {
                _ParametersObject = new SqlParameter[1];
                _ParametersObject[0] = new SqlParameter("@varStaffID", StaffId);
                return SqlHelper.ExecuteDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_MMCheckPermissionsForMedication", _ParametersObject);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - CheckStaffPermissions(), ParameterCount - 0, ###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
        }

        //Ref to Task#2595
        public DataSet GetSecurityQuestions(Int32 StaffId)
        {
            DataSet dsTemp = null;
            SqlParameter[] _ParametersObject = null;
            try
            {
                _ParametersObject = new SqlParameter[1];
                _ParametersObject[0] = new SqlParameter("@varStaffID", StaffId);
                dsTemp = new DataSet();
                string[] _TableNames = { "StaffSecurityQuestion" };
                SqlHelper.FillDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_GetSecurityQuestions", dsTemp, _TableNames, _ParametersObject);
                return dsTemp;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetSecurityQuestions(), ParameterCount - 1, ###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
        }

        public string UpdateStaff(string selectedstaff,int EPCSAssignorStaffId,string CreatedBy, string Enable, string strErrorMessage)
        {
            SqlParameter[] _objectSqlParmeters = null;
            _objectSqlParmeters = new SqlParameter[4];
            _objectSqlParmeters[0] = new SqlParameter("@Selectedstaff", selectedstaff);
            _objectSqlParmeters[1] = new SqlParameter("@EPCSAssignorStaffId", EPCSAssignorStaffId);
            _objectSqlParmeters[2] = new SqlParameter("@CreatedBy", CreatedBy);
            _objectSqlParmeters[3] = new SqlParameter("@Enable", Convert.ToChar(Enable));
            SqlHelper.ExecuteDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_UpdateStaffEPCSAssignment", _objectSqlParmeters);
            strErrorMessage = "Success";
            return strErrorMessage;
        }

        public bool CheckUserNameExists(int staffId, string userCode)
        {
            //DataSet ds;
            try
            {
                SqlParameter[] sp = new SqlParameter[2];
                sp[0] = new SqlParameter("@StaffId", staffId);
                sp[1] = new SqlParameter("@UserCode", userCode);

                ///Following code commented by Jatinder on 4th-Mar-08
                ///as we only need to return 1 value and there is no need for dataset
                //ds = SqlHelper.ExecuteDataset(sqlConnection,"StaffCheckUserCodeExists",sp);
                //if(Convert.ToInt32(ds.Tables[0].Rows[0][0]) == 0 )
                if (Convert.ToInt32(SqlHelper.ExecuteScalar(_ConnectionString, "StaffCheckUserCodeExists", sp)) == 0)
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
                throw ex;
            }
            //Added by Chandan on 05th March 2008
            finally
            {
                //sqlConnection.Dispose();
            }
            //////////
            //return false;
        }


        //Added by chandan With ref task#2604
        public int ApprovePrescription(int PrescriberId, string LastReviewDateTime, string RDLDateTime)
        {
            SqlParameter[] _ParametersObject = null;
            int retInt = 0;
            try
            {
                _ParametersObject = new SqlParameter[3];
                _ParametersObject[0] = new SqlParameter("@PrescriberId", PrescriberId);
                _ParametersObject[1] = new SqlParameter("@LastReviewDateTime", LastReviewDateTime);
                _ParametersObject[2] = new SqlParameter("@RDLDateTime", RDLDateTime);
                retInt = SqlHelper.ExecuteNonQuery(_ConnectionString, CommandType.StoredProcedure, "ssp_MMApprovePrescription", _ParametersObject);
                return retInt;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - LastPrescriptionReviewTime(), ParameterCount - 2, PrescriberId- " + PrescriberId + " LastPrescriptionReviewTime- " + LastReviewDateTime + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
        }
        #region--Code Written By Pradeep on 27 Nov 2009 as per task#23(Venture 10.0)
        /// <summary>
        /// <Description>Used to get data from location as per task#23(Venture10.0)</Description>
        /// <Author>Pradeep</Author>
        /// <Createdon>Nov 27,2009</Createdon>
        /// </summary>
        /// <param name="staffId"></param>
        /// <returns></returns>
        public DataSet GetUserPreferancesLocationList(int staffId)
        {
            SqlParameter[] _ParametersObject = null;
            DataSet _DataSetLocationList = null;
            try
            {
                _ParametersObject = new SqlParameter[1];
                _ParametersObject[0] = new SqlParameter("@staffId", staffId);
                _DataSetLocationList = SqlHelper.ExecuteDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_SCGetUserPreferancesLocationList", _ParametersObject);
                if (_DataSetLocationList != null)
                {
                    if (_DataSetLocationList.Tables.Count > 0)
                    {
                        _DataSetLocationList.Tables[0].TableName = "Locations";
                    }
                    if (_DataSetLocationList.Tables.Count > 2)
                    {
                        _DataSetLocationList.Tables[1].TableName = "StaffLocations";
                    }
                    if (_DataSetLocationList.Tables.Count > 2)
                    {
                        _DataSetLocationList.Tables[2].TableName = "PrinterDeviceLocations";
                    }
                }
                return _DataSetLocationList;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "### Source Function Name - GetUserPreferancesLocationList(int staffId), ParameterCount - 1,First Parameter-" + staffId.ToString() + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
            finally
            {
                if (_DataSetLocationList != null)
                {
                    _DataSetLocationList.Dispose();
                }
            }
        }
        #endregion--Code Written By Pradeep on 27 Nov 2009 as per task#23(Venture 10.0)        


        //Ref to Task#3155 2.1.1 Add/Update Prescriber Interface
        public DataSet GetSureScriptPrescriberId(Int32 StaffId)
        {
            DataSet dsTemp = null;
            SqlParameter[] _ParametersObject = null;
            try
            {
                _ParametersObject = new SqlParameter[1];
                _ParametersObject[0] = new SqlParameter("@StaffID", StaffId);
                dsTemp = new DataSet();
                string[] _TableNames = { "SureScriptPresciberId" };
                SqlHelper.FillDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_SureScriptsAddUpdatePrescriberDetails", dsTemp, _TableNames, _ParametersObject);
                return dsTemp;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetSureScriptPrescriberId(), ParameterCount - 1, ###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
        }

        //Adedd by Loveena in ref to Task#3215
        public DataSet MergePharmacies(int DetailsPharmacyId, int SearchPharmacyId)
        {
            DataSet dsTemp = null;
            SqlParameter[] _ParametersObject = null;
            try
            {
                dsTemp = new DataSet();
                string[] _TableNames = {"MergeStatus","MergeMessage" };
                _ParametersObject = new SqlParameter[2];
                _ParametersObject[0] = new SqlParameter("@DetailsPharmacyId", DetailsPharmacyId);
                _ParametersObject[1] = new SqlParameter("@SearchedPharmacyId", SearchPharmacyId);
                SqlHelper.FillDataset(_ConnectionString, CommandType.StoredProcedure, "scsp_MMMergePharmacies", dsTemp, _TableNames,_ParametersObject);
                return dsTemp;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - DownloadStaffMedicationDetail(), ParameterCount - 0, ###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
        }

        //Adedd by Loveena in ref to Task#3236
        public void UpdatePreferredPharmacy(int PharmacyId)
        {           
            SqlParameter[] _ParametersObject = null;
            try
            {                                
                _ParametersObject = new SqlParameter[1];
                _ParametersObject[0] = new SqlParameter("@PharmacyId", PharmacyId);
                SqlHelper.ExecuteNonQuery(ConnectionString, CommandType.StoredProcedure, "ssp_MMUpdatePreferredPharmacy",_ParametersObject);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - UpdatePreferredPharmacy(), ParameterCount - 1" + PharmacyId + ", ###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
        }

        // To Check EPCS Permissions
        public DataSet CheckForEPCS(Int32 staffId, Int32 clientId)
        {
            SqlParameter[] _ParametersObject = null;
            try
            {
                _ParametersObject = new SqlParameter[2];
                DataSet dsTemp = new DataSet();
                _ParametersObject[0] = new SqlParameter("@LoggedInStaffId", staffId);
                _ParametersObject[1] = new SqlParameter("@StaffId", clientId);
                string[] _TableNames = { "EPCSPermissions" };
                SqlHelper.FillDataset(ConnectionString, CommandType.StoredProcedure, "ssp_EPCSAssignmentValid", dsTemp, _TableNames, _ParametersObject);
                return dsTemp;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - CheckForEPCS(Int32 staffId, Int32 clientId), ParameterCount - 2, First Parameter- " + staffId + " SearchPharmacyId- " + clientId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }
            
           
        }
    }
}

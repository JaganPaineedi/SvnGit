using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Text;
using System.Security.Cryptography;
using System.IO;
using Microsoft.ApplicationBlocks.Data;
using System.DirectoryServices;
using System.DirectoryServices.AccountManagement;

namespace Streamline.DataService
{
    public class MedicationLogin
    {
        private static byte[] KEY = new byte[] { 0x12, 0xe3, 0x4a, 0xa1, 0x45, 0xd2, 0x56, 0x7c, 0x54, 0xac, 0x67, 0x9f, 0x45, 0x6e, 0xaa, 0x56 };
        private static byte[] IV = new byte[] { 0x12, 0xe3, 0x4a, 0xa1, 0x45, 0xd2, 0x56, 0x7c };

        private SqlTransaction SqlTransactionObject = null;
        private SqlConnection SqlConnectionObject = null;

        private static SqlConnection _SqlConnectionObject = null;

        public static string ConnectionString = System.Configuration.ConfigurationSettings.AppSettings["SCConnectionString"];
        private string _ConnectionString = ConnectionString;

        /// <summary>
        /// <Description>This is used to get user authentication type</Description>
        /// <Author>Wasif Butt</Author>
        /// <CreatedOn>Sep 22,2011</CreatedOn>
        /// </summary>
        /// <param name="userName"></param>
        /// <returns>DataSet</returns>
        public DataSet GetUserAuthenticationType(string userName)
        {
            SqlParameter[] _objectSqlParmeters = null;
            DataSet dataSetUserInfo = new DataSet();
            _objectSqlParmeters = new SqlParameter[1];
            _objectSqlParmeters[0] = new SqlParameter("@UserCode", userName);
            SqlHelper.FillDataset(_ConnectionString, "ssp_SCStaffAuthenticationType", dataSetUserInfo, new string[] { "Authentication", "EnableActiveDirectory" }, _objectSqlParmeters);
            return dataSetUserInfo;
        }

        /// <summary>
        /// <Description>This is used to get user information after authentication</Description>
        /// <Author>Wasif Butt</Author>
        /// <CreatedOn>Sep 22,20011</CreatedOn>
        /// </summary>
        /// <param name="staffId">int</param>
        /// <param name="userName">string</param>
        /// <returns>DataSet</returns>
        public DataSet GetAuthenticatedStaffInfo(int staffId, string userName)
        {
            SqlParameter[] _objectSqlParmeters = null;
            DataSet dataSetUserInfo = new DataSet();
            _objectSqlParmeters = new SqlParameter[2];
            _objectSqlParmeters[0] = new SqlParameter("@StaffId", staffId);
            _objectSqlParmeters[1] = new SqlParameter("@UserCode", userName);
            SqlHelper.FillDataset(_ConnectionString, "ssp_SCGetAuthenticatedStaffInfo", dataSetUserInfo, new string[1] { "UserInfo" }, _objectSqlParmeters);
            return dataSetUserInfo;
        }

        /// <summary>
        /// This function will return boolean value after authenticating username/password combination against Active Directory
        /// </summary>
        /// <Author>Wasif Butt</Author>
        /// <param name="username"></param>
        /// <param name="password"></param>
        /// <param name="domain"></param>
        /// <returns>True(If UserName/Password combination is Correct</returns>
        /// <returns>False(If UserName/Password combination is InCorrect</returns>
        public Boolean ADAuthenticateUser(string username, string password, string domain)
        {
            Boolean result = false;
            DataSet datasetSystemConfigurationKeys = null;
            try
            {
                Streamline.DataService.SharedTables objSharedTables = new Streamline.DataService.SharedTables();
                datasetSystemConfigurationKeys = objSharedTables.GetSystemConfigurationKeys();

                if (objSharedTables.GetSystemConfigurationKeys("ValidateFromWebService", datasetSystemConfigurationKeys.Tables[0]) == "Y")
                {

                    SHSADAuthentication.ADAuthenticationService ADA = new SHSADAuthentication.ADAuthenticationService();
                    ADA.Credentials = System.Net.CredentialCache.DefaultCredentials;
                    ADA.Url = objSharedTables.GetSystemConfigurationKeys("AuthWebServiceURL", datasetSystemConfigurationKeys.Tables[0]);
                    SHSADAuthentication.Authentication a = new SHSADAuthentication.Authentication();
                    a.TokenKey = objSharedTables.GetSystemConfigurationKeys("WebServiceKeyToken", datasetSystemConfigurationKeys.Tables[0]);
                    ADA.AuthenticationValue = a;
                    result = ADA.ValidateUser(username.Trim(), password.Trim(), domain.Trim());
                }
                else
                {
                    //create context for domain
                    using (PrincipalContext pc = new PrincipalContext(ContextType.Domain, domain))
                    {
                        // validate the credentials
                        result = pc.ValidateCredentials(username, password);
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Error checking user authentication. " + ex.Message);
            }
            return result;
        }

        /// <summary>
        /// <CreatedBy>Loveena</CreatedBy>
        /// <CreationDate>10-March-2009</CreationDate>
        /// <Description></Description>
        /// </summary>
        /// <returns></returns>
        public string getLastUserName()
        {
            try
            {
                return (SqlHelper.ExecuteScalar(_ConnectionString, CommandType.StoredProcedure, "ssp_SCGetLastUserNameFromSystemConfiguration")).ToString();
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - getLastUserName(), ParameterCount - 0 ###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }

        }

        /// <summary>
        /// <Author>Loveena</Author>
        /// <CreationDate>10-March-2009</CreationDate>
        /// <Description>To get User First Name,Last Name and Staff Id</Description>
        /// </summary>
        /// <param name="varUsername"></param>
        /// <param name="varPassword"></param>
        /// <returns></returns>
        public DataSet chkServerLogin(string varUsername, string varPassword)
        {
            SqlParameter[] _ParamObject = null;
            SqlParameter[] _UpdateParamObject = null;
            try
            {
                _ParamObject = new SqlParameter[2];
                _ParamObject[0] = new SqlParameter("@UserCode", varUsername);
                _ParamObject[1] = new SqlParameter("@UserPassword", GetEncryptedData(varPassword, "Y"));

                _UpdateParamObject = new SqlParameter[1];
                _UpdateParamObject[0] = new SqlParameter("@Lastusername", varUsername);

                DataSet dataSetClientLogin = new DataSet();

                SqlHelper.FillDataset(_ConnectionString, "ssp_SCStaffIdentity", dataSetClientLogin, new string[1] { "ClientInfo" }, _ParamObject);
                SqlHelper.ExecuteNonQuery(_ConnectionString, "ssp_SCSetLastUserNameInSytemConfig", _UpdateParamObject);
                SqlHelper.ExecuteNonQuery(_ConnectionString, "ssp_SCSetLastVisitInStaff", _UpdateParamObject);
                return dataSetClientLogin;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - chkServerLogin(), ParameterCount - 2, varUserName= " + varUsername + ", varPassword= " + varPassword + " ###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
            finally
            {
                _ParamObject = null;
                _UpdateParamObject = null;
            }
        }

        /// <summary>
        /// <CreatedBy>Loveena</CreatedBy>
        /// <CreationDate>10-March-2009</CreationDate>
        /// <Description>Get Encrypted Password</Description>
        /// </summary>
        /// <param name="input"></param>
        /// <param name="strEncryption"></param>
        /// <returns></returns>
        public static string GetEncryptedData(string input, string strEncryption)
        {
            try
            {
                if (strEncryption == "N") return input;
                return EncryptBase64(input, KEY, IV);
            }
            catch
            {
                return input;
            }
        }

        public static string EncryptBase64(string StringToEncrypt, byte[] Key, byte[] IV)
        {
            TripleDESCryptoServiceProvider tripledes = new TripleDESCryptoServiceProvider();

            byte[] inputByteArray = Encoding.UTF8.GetBytes(StringToEncrypt);

            MemoryStream ms = new MemoryStream();

            CryptoStream cs = new CryptoStream(ms, tripledes.CreateEncryptor(Key, IV), CryptoStreamMode.Write);

            cs.Write(inputByteArray, 0, inputByteArray.Length);
            cs.FlushFinalBlock();

            String str = Convert.ToBase64String(ms.ToArray());
            cs.Clear();
            return str;
        }

        public void ChangePassword(string userCode, string userPassword, int expiresNextLogin)
        {
            SqlParameter[] _ParametersObject = null;
            try
            {
                _ParametersObject = new SqlParameter[3];
                _ParametersObject[0] = new SqlParameter("@varUserName", userCode);
                _ParametersObject[1] = new SqlParameter("@varPassword", userPassword);
                if (expiresNextLogin == 1)
                {
                    _ParametersObject[2] = new SqlParameter("@PasswordExpiresNextLogin", "Y");
                }
                else
                {
                    _ParametersObject[2] = new SqlParameter("@PasswordExpiresNextLogin", "N");
                }

                SqlHelper.ExecuteScalar(_ConnectionString, "ssp_ChangePassword", _ParametersObject);

            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally
            {
                _ParametersObject = null;
            }
        }

        /// <summary>
        /// <CreatedBy>Chandan for Task#2604</CreatedBy>
        /// <CreationDate>28 Oct 2009</CreationDate>
        /// <Description></Description>
        /// </summary>
        /// <returns></returns>
        /// Changed By Priya Ref:Task no:2846
        //public int GetPrescriptionsReviewStatus(int PrescriberId, string LastPrescriptionReviewTime)
        //{
        //    SqlParameter[] _ParametersObject = null;
        //    try
        //    {
        //        int retInt = 0;
        //        _ParametersObject = new SqlParameter[2];
        //        _ParametersObject[0] = new SqlParameter("@PrescriberId", PrescriberId);
        //        _ParametersObject[1] = new SqlParameter("@LastPrescriptionReviewTime", LastPrescriptionReviewTime);
        //        retInt = SqlHelper.ExecuteNonQuery(_ConnectionString, CommandType.StoredProcedure, "ssp_ValidateReviewPrescriptions", _ParametersObject);
        //        return retInt;
        //    }
        //    catch (Exception ex)
        //    {
        //        if (ex.Data["CustomExceptionInformation"] == null)
        //            ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetPrescriptionsReviewStatus(), ParameterCount - 2, PrescriberId= " + PrescriberId + ", LastPrescriptionReviewTime= " + LastPrescriptionReviewTime + " ###";
        //        if (ex.Data["DatasetInfo"] == null)
        //            ex.Data["DatasetInfo"] = null;
        //        throw (ex);
        //    }
        //}

        /// Changed By Priya Ref:Task no:2846
        public int GetPrescriptionsReviewStatus(int PrescriberId, string LastPrescriptionReviewTime)
        {
            SqlParameter[] _ParametersObject = null;
            try
            {
                int retInt = 0;
                _ParametersObject = new SqlParameter[2];
                _ParametersObject[0] = new SqlParameter("@PrescriberId", PrescriberId);
                if (LastPrescriptionReviewTime != "")
                    _ParametersObject[1] = new SqlParameter("@LastPrescriptionReviewTime", LastPrescriptionReviewTime);
                else
                    _ParametersObject[1] = new SqlParameter("@LastPrescriptionReviewTime", System.DBNull.Value);
                //Added by Chandan for task#2846
                //retInt = SqlHelper.ExecuteNonQuery(_ConnectionString, CommandType.StoredProcedure, "ssp_ValidateReviewPrescriptions", _ParametersObject);
                retInt = Convert.ToInt32(SqlHelper.ExecuteScalar(_ConnectionString, CommandType.StoredProcedure, "ssp_ValidateReviewPrescriptions", _ParametersObject));
                return retInt;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetPrescriptionsReviewStatus(), ParameterCount - 2, PrescriberId= " + PrescriberId + ", LastPrescriptionReviewTime= " + LastPrescriptionReviewTime + " ###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
        }
        //Ref to Task#2595
        public void chkCountLogin(string varUsername)
        {
            SqlParameter[] _ParamObject = null;
            try
            {
                _ParamObject = new SqlParameter[1];
                _ParamObject[0] = new SqlParameter("@UserCode", varUsername);

                DataSet dataSetCheckLogin = new DataSet();

                //SqlHelper.FillDataset(_ConnectionString, "ssp_SCStaffIdentity", dataSetClientLogin, new string[1] { "ClientInfo" }, _ParamObject);
                SqlHelper.ExecuteNonQuery(_ConnectionString, "ssp_SCActiveInStaff", _ParamObject);

                //return dataSetClientLogin;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - chkServerLogin(), ParameterCount - 1, varUserName= " + varUsername + " ###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
            finally
            {
                _ParamObject = null;
            }
        }
        public DataSet GetVerbalOrderStatus(int PrescriberId)
        {
            SqlParameter[] _ParametersObject = null;
            try
            {
                DataSet datasetVerbalOrder = new DataSet();
                _ParametersObject = new SqlParameter[1];
                _ParametersObject[0] = new SqlParameter("@PrescriberId", PrescriberId);
                //retInt = SqlHelper.ExecuteNonQuery(_ConnectionString, CommandType.StoredProcedure, "ssp_SCGetCountQueuedVerbalOrderData", _ParametersObject);
                //retInt = Convert.ToInt32(SqlHelper.ExecuteScalar(_ConnectionString, CommandType.StoredProcedure, "ssp_SCGetCountQueuedVerbalOrderData", _ParametersObject));
                //DataSet dataSetClientLogin = new DataSet();

                SqlHelper.FillDataset(_ConnectionString, "ssp_SCGetCountQueuedVerbalOrderData", datasetVerbalOrder, new string[1] { "VerbalOrder" }, _ParametersObject);
                //SqlHelper.ExecuteNonQuery(_ConnectionString, "ssp_SCSetLastUserNameInSytemConfig", _UpdateParamObject);

                return datasetVerbalOrder;
                //return retInt;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - SCGetCountQueuedVerbalOrderData(), ParameterCount - 1, PrescriberId= " + PrescriberId + " ###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
        }

    }
}

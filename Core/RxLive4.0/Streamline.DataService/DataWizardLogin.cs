using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Data.SqlClient;

namespace Streamline.DataService
{
    public class DataWizardLogin
    {

        //Contains database connection string.
        string ConnectionString = "";

        public DataWizardLogin()
        {
            //ConnectionString = @"Data Source=Streamline\Streamline;Initial Catalog=LatestProviderAccessDB;uid=shc;pwd=shc";
            ConnectionString = System.Configuration.ConfigurationSettings.AppSettings["SCConnectionString"];
        }

        /// <summary>
        /// Verifies user credentials and return user details.
        /// </summary>
        /// <param name="userCode">UserName</param>
        /// <param name="userPassword">User Password</param>
        /// <returns>Dataset containing user login details</returns>
        /// <Author>Jatinder Singh</Author>
        /// <CreatedOn>29-05-2007</CreatedOn>
        public DataSet AuthenticateUser(string userCode, string userPassword)
        {
            DataSet DataSetLoginStatus = null;
            SqlParameter[] _SqlparameterObject = null;

            try
            {
                _SqlparameterObject = new SqlParameter[2];
                _SqlparameterObject[0] = new SqlParameter("@UserCode", userCode);
                _SqlparameterObject[1] = new SqlParameter("@UserPassword", userPassword);

                //csp_DWPACheckLoginUsers
                DataSetLoginStatus = SqlHelper.ExecuteDataset(ConnectionString, "csp_DWPMCheckLoginStaff", _SqlparameterObject);
                DataSetLoginStatus.Tables[0].TableName = "Users";

                return DataSetLoginStatus;
            }
            catch (Exception ex)
            {
                ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetLoginStatus(), ParameterCount - 2, First Parameter- " + userCode + ", Second Parameter- " + userPassword + "###";
                ex.Data["DatasetInfo"] = DataSetLoginStatus;
                throw (ex);
            }
            finally
            {
                DataSetLoginStatus = null;
                _SqlparameterObject = null;
            }
        }


        /// <summary>
        /// Verifies token credentials and return user details.
        /// </summary>
        /// <param name="token">token</param>
        /// <returns>Dataset containing user login details</returns>
        /// <Author>Jatinder Singh</Author>
        /// <CreatedOn>12-11-2007</CreatedOn>
        public DataSet ValidateToken(string token)
        {
            DataSet DataSetLoginStatus = null;
            SqlParameter[] _SqlparameterObject = null;

            try
            {
                _SqlparameterObject = new SqlParameter[1];
                _SqlparameterObject[0] = new SqlParameter("@UserGuid", token);

                //csp_DWPACheckLoginUsers
                DataSetLoginStatus = SqlHelper.ExecuteDataset(ConnectionString, "ssp_ValidateLoginToken", _SqlparameterObject);
                if (DataSetLoginStatus.Tables.Count > 0)
                    DataSetLoginStatus.Tables[0].TableName = "Users";

                return DataSetLoginStatus;
            }
            catch (Exception ex)
            {
                ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetLoginStatus(), ParameterCount - 1, First Parameter- " + token + "###";
                ex.Data["DatasetInfo"] = DataSetLoginStatus;
                throw (ex);
            }
            finally
            {
                DataSetLoginStatus = null;
                _SqlparameterObject = null;
            }
        }
    }
}

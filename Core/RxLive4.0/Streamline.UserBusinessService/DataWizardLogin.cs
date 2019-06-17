using System;
using System.Collections.Generic;
using System.Text;
using System.Data;

namespace Streamline.UserBusinessServices
{
    public class DataWizardLogin
    {
        Streamline.DataService.DataWizardLogin objDataWizardLogin = null;

        /// <summary>
        /// Constructor to instantiate object of Class DataWizardLogin
        /// </summary>
        public DataWizardLogin()
        {
            objDataWizardLogin = new Streamline.DataService.DataWizardLogin();
        }

        /// <summary>
        /// Verifies user credentials and return user details.
        /// </summary>
        /// <param name="userCode">UserName</param>
        /// <param name="userPassword">User Password</param>
        /// <returns>Dataset containing user login details</returns>
        /// <Author>Jatinder Singh</Author>
        /// <CreatedOn>12-09-2007</CreatedOn>
        public DataSet AuthenticateUser(string userCode, string userPassword)
        {
            try
            {
                return objDataWizardLogin.AuthenticateUser(userCode, userPassword);
            }
            catch (Exception ex)
            {
                // Added by Pratap In order to Implement Exception Management functionality on 27th June 2007
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetLoginStatus(), ParameterCount - 2, First Parameter- " + userCode + ", Second Parameter- " + userPassword + "###";
                throw (ex);
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
            try
            {
                return objDataWizardLogin.ValidateToken(token);
            }
            catch (Exception ex)
            {
                // Added by Pratap In order to Implement Exception Management functionality on 27th June 2007
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetLoginStatus(), ParameterCount - 1, First Parameter- " + token + "###";
                throw (ex);
            }
        }
    }
}

using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using Streamline.DataService;

namespace Streamline.UserBusinessServices
{
    public class MedicationLogin
    {
        Streamline.DataService.MedicationLogin objMedicationLogin = null;
        public MedicationLogin()
        {
            objMedicationLogin = new Streamline.DataService.MedicationLogin();
        }

        /// <summary>
        /// <CreatedBy>Loveena</CreatedBy>
        /// <CreationDate>10-March-2009</CreationDate>
        /// </summary>            
        /// <returns></returns>
        public string getLastUserName()
        {
            try
            {
                return objMedicationLogin.getLastUserName();
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - getLastUserName(), ParameterCount - 0 ###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }

        }

        /// <summary>
        /// <Description>This is used to get user authentication type</Description>
        /// <Author>Wasif Butt</Author>
        /// <CreatedOn>Sep 22,2011</CreatedOn>
        /// </summary>
        /// <param name="userName"></param>
        /// <returns>DataSet</returns>
        public DataSet GetUserAuthenticationType(string UserName)
        {
            try
            {
                return objMedicationLogin.GetUserAuthenticationType(UserName);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetUserAuthenticationType, ParameterCount - 0 ###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }
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
            return objMedicationLogin.GetAuthenticatedStaffInfo(staffId, userName);
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
            try
            {
                return objMedicationLogin.ADAuthenticateUser(username, password, domain);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - ADAuthenticateUser, ParameterCount - 0 ###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }
        }

        public DataSet chkServerLogin(string varUsername, string varPassword)
        {
            try
            {
                return objMedicationLogin.chkServerLogin(varUsername, varPassword);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        //Ref to Task#2595
        public void chkCountLogin(string varUsername)
        {
            try
            {
                objMedicationLogin.chkCountLogin(varUsername);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public void ChangePassword(string userCode, string userPassword, int expiresNextLogin)
        {
            try
            {
                objMedicationLogin.ChangePassword(userCode, userPassword, expiresNextLogin);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        //Added by chandan ref task#2604
        public int GetPrescriptionsReviewStatus(int PrescriberId, string LastPrescriptionReviewTime)
        {
            try
            {
                return objMedicationLogin.GetPrescriptionsReviewStatus(PrescriberId, LastPrescriptionReviewTime);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetPrescriptionsReviewStatus(), ParameterCount - 2 ###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }

        }

       
        public DataSet GetVerbalOrderStatus(int PrescriberId)
        {
            try
            {
                return objMedicationLogin.GetVerbalOrderStatus(PrescriberId);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetPrescriptionsReviewStatus(), ParameterCount - 2 ###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }

        }

    }
}

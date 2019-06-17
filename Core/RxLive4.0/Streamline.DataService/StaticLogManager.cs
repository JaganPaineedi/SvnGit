using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Data.SqlClient;

namespace Streamline.DataService
{
    public static class StaticLogManager
    {

        //Connection String used for connecting the database
        public static string ConnectionString;//= System.Configuration.ConfigurationSettings.AppSettings["SCConnectionString"];

        /// <summary>
        /// Constructor of the Class used for initialising the value of ConnectionString
        /// <Author>Jatinder Singh</Author>
        /// <Date Created>30-May-2007</Date>
        /// </summary>
        static StaticLogManager()
        {
            ConnectionString = System.Configuration.ConfigurationSettings.AppSettings["SCConnectionString"];
        }

        /// <summary>
        /// This is used to insert the error messages in to the database
        /// </summary>
        /// <param name="dsError"></param>
        /// <CreatedOn>20th June 2007</CreatedOn>
        /// <Author>Chandan</Author>
        /// <ModifiedBy>Chandan</ModifiedBy>
        /// <ModificationCause>Added a new parameter for storing Verbose Information in separate column</ModificationCause>
        public static void WriteToDatabase(DataSet dsError)
        {
            SqlParameter[] objParm = null;
            try
            {
                objParm = new SqlParameter[6];
                objParm[0] = new SqlParameter("@ErrorMessage", dsError.Tables["ErrorMessages"].Rows[0]["ErrorMessage"].ToString());
                objParm[1] = new SqlParameter("@VerboseInfo", dsError.Tables["ErrorMessages"].Rows[0]["VerboseInfo"].ToString());
                objParm[2] = new SqlParameter("@ErrorType", dsError.Tables["ErrorMessages"].Rows[0]["ErrorType"].ToString());
                objParm[3] = new SqlParameter("@CreatedBy", dsError.Tables["ErrorMessages"].Rows[0]["CreatedBy"].ToString());
                objParm[4] = new SqlParameter("@CreatedDate", Convert.ToDateTime(dsError.Tables["ErrorMessages"].Rows[0]["CreatedDate"]));
                objParm[5] = new SqlParameter("@DatasetInfo", dsError.Tables["ErrorMessages"].Rows[0]["DatasetInfo"].ToString());// Added by Piyush on 21st June 2007, so as to pass another parameter for Dataset
                SqlHelper.ExecuteNonQuery(ConnectionString, CommandType.StoredProcedure, "ssp_SCLogError", objParm);
            }
            catch (Exception ex)
            {
                // Added by Pratap In order to Implement Exception Management functionality on 28th June 2007
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - WriteToDatabase(), ParameterCount - 1, First Parameter- " + dsError + "###";
                //Statements commented by Pratap:- to avoid null condition check, on 18th July 2007
                /*if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;*/
                throw (ex);
            }
            finally
            {
                objParm = null;
            }
        }



        /// <summary>
        /// This is used to insert the error messages in to the database
        /// </summary>
        /// <param name="dsError"></param>
        /// <CreatedOn>20th June 2007</CreatedOn>
        /// <Author>Chandan</Author>
        /// <ModifiedBy>Chandan</ModifiedBy>
        /// <ModificationCause>Added a new parameter for storing Verbose Information in separate column</ModificationCause>
        public static void WriteToDatabase(string ErrorMessage, string VerboseInfo, string ErrorType, string CreatedBy)
        {
            SqlParameter[] objParm = null;
            try
            {
                objParm = new SqlParameter[6];
                objParm[0] = new SqlParameter("@ErrorMessage", ErrorMessage);
                objParm[1] = new SqlParameter("@VerboseInfo", VerboseInfo);
                objParm[2] = new SqlParameter("@ErrorType", ErrorType);
                objParm[3] = new SqlParameter("@CreatedBy", CreatedBy);
                objParm[4] = new SqlParameter("@CreatedDate", DateTime.Now);
                objParm[5] = new SqlParameter("@DatasetInfo", "");
                SqlHelper.ExecuteNonQuery(ConnectionString, CommandType.StoredProcedure, "ssp_SCLogError", objParm);
            }
            catch (Exception ex)
            {
                // Added by Pratap In order to Implement Exception Management functionality on 28th June 2007
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - WriteToDatabase(), ParameterCount - 4, ErrorMessage- " + ErrorMessage + ", VerboseInfo- " + VerboseInfo + ", ErrorType" + ErrorType + ", CreatedBy" + CreatedBy + "###";
                //Statements commented by Pratap:- to avoid null condition check, on 18th July 2007
                /*if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;*/
                throw (ex);
            }
            finally
            {
                objParm = null;
            }
        }

    }
}

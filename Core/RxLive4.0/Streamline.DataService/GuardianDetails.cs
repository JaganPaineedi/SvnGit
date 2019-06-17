using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Data.SqlClient;

namespace Streamline.DataService
{
    /// <summary>
    /// Created By Priya Sareen
    /// Created On 12th Feb 2008
    /// This Class will be used for Getdata For guardiandetails.aspx page and Update guardiandetails.aspx page data
    /// </summary>
    public class GuardianDetalis
    {

        //Contains database connection string.
        string _ConnectionString = "";

        /// <summary>
        /// Storing ConnectionString into Variable while Object of Class is created.
        /// Created By Priya Sareen
        /// Created date 12th Feb 2008
        /// </summary>
        public GuardianDetalis()
        {
            //Storing Connection String into _ConnectionString from webconfig
            _ConnectionString = System.Configuration.ConfigurationSettings.AppSettings["SCConnectionString"];
           // _ConnectionString = @"Data Source=Streamline\Streamline;Initial Catalog=Test;uid=shc;pwd=shc;";
        }
        /// <summary>
        /// Created By Priya Sareen
        /// Created On 12th Feb 2008
        /// This fucntion will fetch guardiandetails Data from DataBase according to DocumentId and VersionId
        /// </summary>
        /// <param name="DocumentId"></param>
        /// <param name="VersionId"></param>
        /// <returns></returns>


        public DataSet GetGuardianDetails(int DocumentId, int VersionId)
        {
            //Declaring SalParamentArray that will hold Parament that will be passed to the stored Procedure
            SqlParameter[] _ParameterObject = null;
            //Declaring a dataset
            DataSet DataSetGuardianDetails = null;
            try
            {
                //Initialization 
                DataSetGuardianDetails = new DataSet();
                _ParameterObject = new SqlParameter[2];
                _ParameterObject[0] = new SqlParameter("@DocumentId", DocumentId);
                _ParameterObject[1] = new SqlParameter("@VersionId", VersionId);
                DataSetGuardianDetails = SqlHelper.ExecuteDataset(_ConnectionString, System.Data.CommandType.StoredProcedure, "csp_SCGetAssessmentInitialGuardianDescription ", _ParameterObject);
                DataSetGuardianDetails.Tables[0].TableName = "Gaurdian";
                DataSetGuardianDetails.Tables[1].TableName = "CustomHRMAssessments";
                return DataSetGuardianDetails;

            }
            catch (Exception ex)
            {

                return DataSetGuardianDetails;
            }
            finally
            {

                _ParameterObject = null;

            }

        }
    }
}
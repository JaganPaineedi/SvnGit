using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Data.SqlClient;

namespace Streamline.UserBusinessServices
{
    /// <summary>
    /// Created By Priya Sareen
    /// Created On 12th Feb 2008
    /// </summary>
    public class GuardianDetails
    {
        //Declaring Object of GuardianDetalis Class of DataAccess Layer
        private Streamline.DataService.GuardianDetalis ObjectGuardianDetails = null;
        //Constructor of Class will initialize Object of GuardianDetalis Class of DataAccess Layer
        public GuardianDetails()
        {
            ObjectGuardianDetails = new Streamline.DataService.GuardianDetalis();

        }
        /// 
        /// <summary>
        /// Created By Priya Sareen
        /// Created On 12th Feb 2008
        /// this fucntion will Call a fucntion of DataAccess layer named GetGuardianDetails
        /// </summary>
        /// <param name="DocumentId"></param>
        /// <param name="VersionId"></param>
        /// <returns></returns>
        public DataSet GetGuardianDetails(int DocumentId, int VersionId)
        {
            //Declaring a Dataset 
            DataSet DataSetGuardianDetails = null;
            try
            {
                //Initializing Object of dataset with New Dataset; 
                DataSetGuardianDetails = new DataSet();
                ObjectGuardianDetails = new Streamline.DataService.GuardianDetalis();
                //Calling DataAssess Layer  and assign it to DataSetGuardianDetails
                DataSetGuardianDetails = ObjectGuardianDetails.GetGuardianDetails(DocumentId, VersionId);
                return DataSetGuardianDetails;
            }
            catch (Exception ex)
            {

                return DataSetGuardianDetails;
            }
            finally
            {
              
                ObjectGuardianDetails = null;

            }

        }
    }
}



using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using System.Collections;


namespace Streamline.DataService
{
    /// <summary>
    /// Created By Pramod Prakash Mishra
    /// On 11 Feb 2008
    /// This Class will Impliment all function that will be required by all Custom Assessment pages.
    /// </summary>
   public  class AssessmentCustom : System.IDisposable
    {

        private SqlTransaction SqlTransactionObject = null;
        private SqlConnection SqlConnectionObject = null;
        public static string ConnectionString = System.Configuration.ConfigurationSettings.AppSettings["SCConnectionString"];
        private string _ConnectionString = ConnectionString;
        public void Dispose()
        {
            if (SqlTransactionObject != null)
                SqlTransactionObject.Dispose();
            if (SqlConnectionObject != null)
                SqlConnectionObject.Dispose();
        }
       /// <summary>
       /// This function is created for Filling the Datset for Symptoms page
       /// <CreatedBy>Chandan Srivastava</CreatedBy> 
       /// <CreatedDate>11th Feb 2007</CreatedDate>
       /// </summary>
       /// <param name="DocumentId"></param>
       /// <param name="VersionId"></param>
       /// <returns></returns>
       public DataSet FillDataSetSymptoms(int DocumentId, int VersionId)
       {
           SqlParameter[] _SqlparametersObject = null;
           DataSet DataSetSymptoms = null;
           //DataRow DataRowBlank = null;
           try
           {
               DataSetSymptoms = new DataSet();
               _SqlparametersObject = new SqlParameter[2];
               _SqlparametersObject[0] = new SqlParameter("@DocumentId", DocumentId);
               _SqlparametersObject[1] = new SqlParameter("@Version", VersionId);

               DataSetSymptoms = SqlHelper.ExecuteDataset(ConnectionString, "csp_SCGetSymptomChecklist", _SqlparametersObject);
               if (DataSetSymptoms != null)
                   if (DataSetSymptoms.Tables.Count > 0)
                   {
                       DataSetSymptoms.Tables[0].TableName = "CustomHRMAssessmentSymptoms";
                       DataSetSymptoms.Tables[1].TableName = "CustomHRMSymptoms";
                   }

               return DataSetSymptoms;


           }
           catch (Exception ex)
           {
               ex.Data["DatasetInfo"] = DataSetSymptoms;
               throw (ex);
           }
           finally
           {
               DataSetSymptoms = null;
               _SqlparametersObject = null;

           }

       }

    }
}

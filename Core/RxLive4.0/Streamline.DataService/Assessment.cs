using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Data.SqlClient;
namespace Streamline.DataService
{
    /// <summary>
    /// Created By Pramod Prakash Mishra
    /// Created On 21 Jan 2008
    /// This Class will be used for Getdata For assessment.aspx page and Update Assessment.aspx page data
    /// </summary>
    public class AssessmentWizardNeedList:IDisposable 
    {

        private SqlTransaction SqlTransactionObject = null;
        private SqlConnection SqlConnectionObject = null;
        public static string ConnectionString = System.Configuration.ConfigurationSettings.AppSettings["SCConnectionString"];
        private string _ConnectionString = ConnectionString;
        DataSet DataSetAssessmentNeed = null;
        /// <summary>
        /// Storing ConnectionString into Variable while Object of Class is created.
        /// Created By Pramod Prakash Mishra
        /// Created date 21 Jan 2008
        /// </summary>
        public AssessmentWizardNeedList()
        {
            ////Storing Connection String into _ConnectionString from webconfig
            //_ConnectionString = System.Configuration.ConfigurationSettings.AppSettings["SCConnectionString"];

        }
        /// <summary>
        /// This function will Updated the Dataset of AssessementNeedList
        /// </summary>
        /// <param name="DataSetAssessmentNeedlist"></param>
        /// <returns></returns>
        public DataSet UpdateAssessementNeedList(DataSet DataSetAssessmentNeedlist)
        {
            try
            {
                //Storing DataSetAssessmentNeedlist into DataSetAssessmentNeed so that it can be assess OnRowUpdated
                DataSetAssessmentNeed = DataSetAssessmentNeedlist;
                string _SelectQuery = "";
                DataTable dtDocuments = null;
                if (DataSetAssessmentNeedlist.Tables.Contains("Documents"))
                {
                    dtDocuments = DataSetAssessmentNeedlist.Tables["Documents"].Copy();
                    DataSetAssessmentNeedlist.Tables.Remove("Documents");
                }

                //Create a new dataset with the same structure of the dataset passed to the function.
                // To maintain all the keys and constraints of the dataset.
                DataSet datasetUpdated = DataSetAssessmentNeedlist.Clone();
                int _TableCount;
                int _documentId = 0;
                int _version = 0;

                try
                {
                    SqlConnectionObject = new SqlConnection(_ConnectionString);
                    SqlConnectionObject.Open();
                    SqlTransactionObject = SqlConnectionObject.BeginTransaction();
                }
                catch (SqlException sqlEx)
                {
                    throw sqlEx;
                }

                if (DataSetAssessmentNeedlist.Tables.Count > 0)
                {
                    if (DataSetAssessmentNeedlist.Tables[0].Rows.Count > 0)
                    {
                        SqlParameter[] SqlParametersCollection = new SqlParameter[15];
                        SqlParametersCollection[0] = new SqlParameter("@ClientId", dtDocuments.Rows[0]["ClientId"]);
                        SqlParametersCollection[1] = new SqlParameter("@ServiceId", dtDocuments.Rows[0]["ServiceId"]);
                        SqlParametersCollection[2] = new SqlParameter("@DocumentCodeId", dtDocuments.Rows[0]["DocumentCodeId"]);
                        SqlParametersCollection[3] = new SqlParameter("@Status", dtDocuments.Rows[0]["Status"]);
                        SqlParametersCollection[4] = new SqlParameter("@AuthorId", dtDocuments.Rows[0]["AuthorId"]);
                        SqlParametersCollection[5] = new SqlParameter("@EffectiveDate", dtDocuments.Rows[0]["EffectiveDate"]);
                        SqlParametersCollection[6] = new SqlParameter("@DocumentId", Convert.ToInt32(DataSetAssessmentNeedlist.Tables["CustomHRMAssessmentNeeds"].Rows[0]["DocumentId"]));

                        SqlParametersCollection[7] = new SqlParameter("@Version", Convert.ToInt32(DataSetAssessmentNeedlist.Tables["CustomHRMAssessmentNeeds"].Rows[0]["Version"]));
                        SqlParametersCollection[8] = new SqlParameter("@ExternalRefId", dtDocuments.Rows[0]["ExternalRefId"]);
                        SqlParametersCollection[9] = new SqlParameter("@CreatedBy", dtDocuments.Rows[0]["CreatedBy"]);
                        SqlParametersCollection[10] = new SqlParameter("@CreatedDate", System.DateTime.Now);
                        SqlParametersCollection[11] = new SqlParameter("@ModifiedBy", dtDocuments.Rows[0]["ModifiedBy"]);
                        SqlParametersCollection[12] = new SqlParameter("@ModifiedDate", System.DateTime.Now);
                        SqlParametersCollection[13] = new SqlParameter("@ToSign", dtDocuments.Rows[0]["ToSign"]);
                        SqlParametersCollection[14] = new SqlParameter("@ProxyId", dtDocuments.Rows[0]["ProxyId"]);



                        //_ParametersObject[6].Direction = ParameterDirection.InputOutput  ;
                        //_ParametersObject[7].Direction = ParameterDirection.InputOutput;
                        using (DataSet dsTemp = SqlHelper.ExecuteDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_SCInsertNewDocumentAndVersion", SqlParametersCollection))
                        {
                            if (dsTemp.Tables.Count > 0)
                            {
                                _documentId = Convert.ToInt32(dsTemp.Tables[0].Rows[0]["DocumentId"]);
                                _version = Convert.ToInt32(dsTemp.Tables[0].Rows[0]["Version"]);
                            }
                        }

                        //if (SqlHelper.ExecuteNonQuery(_ConnectionString, CommandType.StoredProcedure, "ssp_SCInsertNewDocumentAndVersion", SqlParametersCollection) > 0)
                        //{
                        //     _documentId = Convert.ToInt32(SqlParametersCollection[6].Value);
                        //     _version = Convert.ToInt32(SqlParametersCollection[7].Value);
                        //}

                    }
                }


                for (_TableCount = 0; _TableCount <= DataSetAssessmentNeedlist.Tables.Count - 1; _TableCount++)
                {

                    foreach (DataRow dr in DataSetAssessmentNeedlist.Tables[_TableCount].Rows)
                    {
                        if (DataSetAssessmentNeedlist.Tables[_TableCount].TableName == "CustomHRMAssessmentNeeds")
                        {
                            dr["DocumentId"] = _documentId;
                            dr["Version"] = _version;
                            //dr["HRMNeedId"] = 1;
                        }
                    }

                    //_SelectQuery = "Select * from " + DataSetAssessmentNeedlist.Tables[_TableCount];
                    _SelectQuery = Streamline.DataService.ApplicationCommonFunctions.GetSelectSQL(DataSetAssessmentNeedlist.Tables[_TableCount]);

                    SqlCommand sqlSelectCommand;
                    sqlSelectCommand = new SqlCommand(_SelectQuery, SqlConnectionObject, SqlTransactionObject);
                    SqlDataAdapter _SqlDataAdapter = new SqlDataAdapter(sqlSelectCommand);
                    SqlCommandBuilder _SqlCommandBuilder = new SqlCommandBuilder(_SqlDataAdapter);
                    _SqlDataAdapter.InsertCommand = _SqlCommandBuilder.GetInsertCommand();
                    _SqlDataAdapter.UpdateCommand = _SqlCommandBuilder.GetUpdateCommand();
                    _SqlDataAdapter.InsertCommand.Transaction = SqlTransactionObject;
                    _SqlDataAdapter.UpdateCommand.Transaction = SqlTransactionObject;

                    if (DataSetAssessmentNeedlist.Tables[_TableCount].TableName == "CustomHRMNeeds")
                    {
                        _SqlDataAdapter.RowUpdated += new SqlRowUpdatedEventHandler(OnRowUpdated);
                    }
                    _SqlDataAdapter.Update(DataSetAssessmentNeedlist.Tables[_TableCount]);
                    //datasetUpdated.Merge(getData(DataSetAssessmentNeedlist.Tables[_TableCount].PrimaryKey, DataSetAssessmentNeedlist.Tables[_TableCount].TableName, SqlTransactionObject));
                }

                SqlTransactionObject.Commit();

                //datasetUpdated = SqlHelper.ExecuteDataset(SqlConnectionObject, CommandType.StoredProcedure, "csp_DwPAAddUpdateSmartCare");

                return DataSetAssessmentNeedlist;

            }
            catch (Exception ex)
            {
                SqlTransactionObject.Rollback();
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - UpdateDocuments(), ParameterCount - 1, First Parameter- " + DataSetAssessmentNeedlist + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
        }
        /// <summary>
        /// Create By Pramod Prakash On 14 Feb 2008
        /// This function will store HRMNeedId in CustomHRMAssessmentNeeds table
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="args"></param>
        private void OnRowUpdated(object sender, SqlRowUpdatedEventArgs args)
        {
            try
            {
                if (args.Errors == null)
                {

                   
                                int newID = 0;
                                SqlCommand idCMD = new SqlCommand("SELECT @@IDENTITY as HRMNeedId", args.Command.Connection, args.Command.Transaction);

                                if (args.StatementType == StatementType.Insert)
                                {
                                    //To Retrive Identity Value
                                    newID = Convert.ToInt32(idCMD.ExecuteScalar());
                                    foreach (DataRow dr in DataSetAssessmentNeed.Tables["CustomHRMAssessmentNeeds"].Rows)
                                    {
                                        dr["HRMNeedId"] = newID;

                                    }
                                }
                                

                        
                    

                }

                else
                {

                    throw new Exception(args.Errors.Message);

                }


            }
            catch (Exception ex)
            {
                throw (ex);
            }
        }
        /// <summary>
        /// This function will  Dispose objects
        /// Created By Pramod Prakash Mishra
        /// </summary>
        public void Dispose()
        {
            DisposeObjects();
            //GC.SuppressFinalize(this);
        }
        /// <summary>
        /// Created By Pramod Prakash
        /// </summary>
        public void DisposeObjects()
        {
            if (SqlTransactionObject != null)
                SqlTransactionObject.Dispose();
            //if (SqlConnectionObject != null)
            //    SqlConnectionObject.Dispose();
            if (DataSetAssessmentNeed != null)
                DataSetAssessmentNeed.Dispose();
        }
        /// <summary>
        /// Finilizer of Class to prevent memory leak
        /// </summary>
        ~AssessmentWizardNeedList()
        {
            DisposeObjects();
        }

    }
}

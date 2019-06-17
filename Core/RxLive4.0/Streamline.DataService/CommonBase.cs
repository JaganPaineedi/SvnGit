using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using System.Collections;
using System.Collections;

namespace Streamline.DataService
{
    public class CommonBase : System.IDisposable
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
        /// Updates the dataset passed to the database
        /// Add Row to Documents and DocumentVersions Table
        /// </summary>
        /// <param name="DataSetUpdate"></param>
        /// <returns></returns>
        public DataSet UpdateDocuments(DataSet DataSetUpdate)
        {
            try
            {
                string _SelectQuery = "";
                DataTable dtDocuments = null;
                if (DataSetUpdate.Tables.Contains("Documents"))
                {
                    dtDocuments = DataSetUpdate.Tables["Documents"].Copy();
                    DataSetUpdate.Tables.Remove("Documents");
                }

                //Create a new dataset with the same structure of the dataset passed to the function.
                // To maintain all the keys and constraints of the dataset.
                DataSet datasetUpdated = DataSetUpdate.Clone();
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

                if (DataSetUpdate.Tables.Count > 0)
                {
                    if (DataSetUpdate.Tables[0].Rows.Count > 0)
                    {
                        SqlParameter[] SqlParametersCollection = new SqlParameter[15];
                        SqlParametersCollection[0] = new SqlParameter("@ClientId", dtDocuments.Rows[0]["ClientId"]);
                        SqlParametersCollection[1] = new SqlParameter("@ServiceId", dtDocuments.Rows[0]["ServiceId"]);
                        SqlParametersCollection[2] = new SqlParameter("@DocumentCodeId", dtDocuments.Rows[0]["DocumentCodeId"]);
                        SqlParametersCollection[3] = new SqlParameter("@Status", dtDocuments.Rows[0]["Status"]);
                        SqlParametersCollection[4] = new SqlParameter("@AuthorId", dtDocuments.Rows[0]["AuthorId"]);
                        SqlParametersCollection[5] = new SqlParameter("@EffectiveDate", dtDocuments.Rows[0]["EffectiveDate"]);
                        SqlParametersCollection[6] = new SqlParameter("@DocumentId", Convert.ToInt32(DataSetUpdate.Tables[0].Rows[0]["DocumentId"]));

                        SqlParametersCollection[7] = new SqlParameter("@Version", Convert.ToInt32(DataSetUpdate.Tables[0].Rows[0]["Version"]));
                        SqlParametersCollection[8] = new SqlParameter("@ExternalRefId", dtDocuments.Rows[0]["ExternalRefId"]);
                        SqlParametersCollection[9] = new SqlParameter("@CreatedBy", dtDocuments.Rows[0]["CreatedBy"]);
                        SqlParametersCollection[10] = new SqlParameter("@CreatedDate", System.DateTime.Now);
                        SqlParametersCollection[11] = new SqlParameter("@ModifiedBy", dtDocuments.Rows[0]["ModifiedBy"]);
                        SqlParametersCollection[12] = new SqlParameter("@ModifiedDate", System.DateTime.Now);
                        SqlParametersCollection[13] = new SqlParameter("@ToSign", dtDocuments.Rows[0]["ToSign"]);
                        SqlParametersCollection[14] = new SqlParameter("@ProxyId", dtDocuments.Rows[0]["ProxyId"]);



                        //_ParametersObject[6].Direction = ParameterDirection.InputOutput  ;
                        //_ParametersObject[7].Direction = ParameterDirection.InputOutput;
                        using (DataSet datasetTemp = SqlHelper.ExecuteDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_SCInsertNewDocumentAndVersion", SqlParametersCollection))
                        {
                            if (datasetTemp.Tables.Count > 0)
                            {
                                _documentId = Convert.ToInt32(datasetTemp.Tables[0].Rows[0]["DocumentId"]);
                                _version = Convert.ToInt32(datasetTemp.Tables[0].Rows[0]["Version"]);
                            }
                        }

                        //if (SqlHelper.ExecuteNonQuery(_ConnectionString, CommandType.StoredProcedure, "ssp_SCInsertNewDocumentAndVersion", SqlParametersCollection) > 0)
                        //{
                        //     _documentId = Convert.ToInt32(SqlParametersCollection[6].Value);
                        //     _version = Convert.ToInt32(SqlParametersCollection[7].Value);
                        //}

                    }
                }


                for (_TableCount = 0; _TableCount <= DataSetUpdate.Tables.Count - 1; _TableCount++)
                {

                    foreach (DataRow dr in DataSetUpdate.Tables[_TableCount].Rows)
                    {
                        dr["DocumentId"] = _documentId;
                        dr["Version"] = _version;
                    }

                    //_SelectQuery = "Select * from " + DataSetUpdate.Tables[_TableCount];
                    _SelectQuery = Streamline.DataService.ApplicationCommonFunctions.GetSelectSQL(DataSetUpdate.Tables[_TableCount]);

                    SqlCommand sqlSelectCommand;
                    sqlSelectCommand = new SqlCommand(_SelectQuery, SqlConnectionObject, SqlTransactionObject);
                    SqlDataAdapter _SqlDataAdapter = new SqlDataAdapter(sqlSelectCommand);
                    SqlCommandBuilder _SqlCommandBuilder = new SqlCommandBuilder(_SqlDataAdapter);
                    _SqlDataAdapter.InsertCommand = _SqlCommandBuilder.GetInsertCommand();
                    _SqlDataAdapter.UpdateCommand = _SqlCommandBuilder.GetUpdateCommand();
                    _SqlDataAdapter.InsertCommand.Transaction = SqlTransactionObject;
                    _SqlDataAdapter.UpdateCommand.Transaction = SqlTransactionObject;
                    //_SqlDataAdapter.RowUpdated += new SqlRowUpdatedEventHandler(OnRowUpdated);
                    _SqlDataAdapter.Update(DataSetUpdate.Tables[_TableCount]);
                    //datasetUpdated.Merge(getData(DataSetUpdate.Tables[_TableCount].PrimaryKey, DataSetUpdate.Tables[_TableCount].TableName, SqlTransactionObject));
                }

                SqlTransactionObject.Commit();

                //datasetUpdated = SqlHelper.ExecuteDataset(SqlConnectionObject, CommandType.StoredProcedure, "csp_DwPAAddUpdateSmartCare");

                return DataSetUpdate;

            }
            catch (Exception ex)
            {
                SqlTransactionObject.Rollback();
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - UpdateDocuments(), ParameterCount - 1, First Parameter- " + DataSetUpdate + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
        }
        /// <summary>
        /// Updates the dataset with relations passed to the database
        /// Add Row to Documents and DocumentVersions Table
        /// </summary>
        /// <param name="DataSetUpdate"></param>
        /// <returns></returns>
        public DataSet UpdateRelationalDataSet(DataSet DataSetUpdate)
        {
            try
            {
                string _SelectQuery = "";
                DataTable dtDocuments = null;
                if (DataSetUpdate.Tables.Contains("Documents"))
                {
                    dtDocuments = DataSetUpdate.Tables["Documents"].Copy();
                    DataSetUpdate.Tables.Remove("Documents");
                }

                //Create a new dataset with the same structure of the dataset passed to the function.
                // To maintain all the keys and constraints of the dataset.
                DataSet datasetUpdated = DataSetUpdate.Clone();
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

                if (DataSetUpdate.Tables.Count > 0)
                {
                    if (DataSetUpdate.Tables[0].Rows.Count > 0)
                    {
                        SqlParameter[] SqlParametersCollection = new SqlParameter[15];
                        SqlParametersCollection[0] = new SqlParameter("@ClientId", dtDocuments.Rows[0]["ClientId"]);
                        SqlParametersCollection[1] = new SqlParameter("@ServiceId", dtDocuments.Rows[0]["ServiceId"]);
                        SqlParametersCollection[2] = new SqlParameter("@DocumentCodeId", dtDocuments.Rows[0]["DocumentCodeId"]);
                        SqlParametersCollection[3] = new SqlParameter("@Status", dtDocuments.Rows[0]["Status"]);
                        SqlParametersCollection[4] = new SqlParameter("@AuthorId", dtDocuments.Rows[0]["AuthorId"]);
                        SqlParametersCollection[5] = new SqlParameter("@EffectiveDate", dtDocuments.Rows[0]["EffectiveDate"]);
                        SqlParametersCollection[6] = new SqlParameter("@DocumentId", Convert.ToInt32(DataSetUpdate.Tables[0].Rows[0]["DocumentId"]));

                        SqlParametersCollection[7] = new SqlParameter("@Version", Convert.ToInt32(DataSetUpdate.Tables[0].Rows[0]["Version"]));
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


                for (_TableCount = 0; _TableCount <= DataSetUpdate.Tables.Count - 1; _TableCount++)
                {

                    foreach (DataRow dr in DataSetUpdate.Tables[_TableCount].Rows)
                    {
                        dr["DocumentId"] = _documentId;
                        dr["Version"] = _version;
                    }

                    //_SelectQuery = "Select * from " + DataSetUpdate.Tables[_TableCount];
                    _SelectQuery = Streamline.DataService.ApplicationCommonFunctions.GetSelectSQL(DataSetUpdate.Tables[_TableCount]);
                    SqlCommand sqlSelectCommand;
                    sqlSelectCommand = new SqlCommand(_SelectQuery, SqlConnectionObject, SqlTransactionObject);
                    SqlDataAdapter _SqlDataAdapter = new SqlDataAdapter(sqlSelectCommand);
                    SqlCommandBuilder _SqlCommandBuilder = new SqlCommandBuilder(_SqlDataAdapter);
                    _SqlDataAdapter.InsertCommand = _SqlCommandBuilder.GetInsertCommand();
                    _SqlDataAdapter.UpdateCommand = _SqlCommandBuilder.GetUpdateCommand();
                    _SqlDataAdapter.InsertCommand.Transaction = SqlTransactionObject;
                    _SqlDataAdapter.UpdateCommand.Transaction = SqlTransactionObject;
                    _SqlDataAdapter.RowUpdated += new SqlRowUpdatedEventHandler(OnRowUpdated);
                    _SqlDataAdapter.Update(DataSetUpdate.Tables[_TableCount]);
                    //datasetUpdated.Merge(getData(DataSetUpdate.Tables[_TableCount].PrimaryKey, DataSetUpdate.Tables[_TableCount].TableName, SqlTransactionObject));
                }

                SqlTransactionObject.Commit();

                //datasetUpdated = SqlHelper.ExecuteDataset(SqlConnectionObject, CommandType.StoredProcedure, "csp_DwPAAddUpdateSmartCare");

                return DataSetUpdate;

            }
            catch (Exception ex)
            {
                SqlTransactionObject.Rollback();
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - UpdateDocuments(), ParameterCount - 1, First Parameter- " + DataSetUpdate + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
        }
        private void OnRowUpdated(object sender, SqlRowUpdatedEventArgs args)
        {
            try
            {
                if (args.Errors == null)
                {

                    DataColumn[] _DataColumns = args.Row.Table.PrimaryKey;
                    if (_DataColumns.Length > 0)
                    {
                        foreach (DataColumn col in _DataColumns)
                        {
                            if (col.AutoIncrement == true)
                            {
                                int newID = 0;
                                SqlCommand idCMD = new SqlCommand("SELECT @@IDENTITY as MedicationId", args.Command.Connection, args.Command.Transaction);

                                if (args.StatementType == StatementType.Insert)
                                {
                                    //To Retrive Identity Value
                                    newID = Convert.ToInt32(idCMD.ExecuteScalar());
                                    args.Row[0] = newID;
                                }
                                break;

                            }
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
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - OnRowUpdated(), ParameterCount - 2, Sender- " + sender + ", args" + args + "###";
                throw (ex);
            }
        }


        /// <summary>
        /// Takes primarykey collection of a table and creates parameter accordingly and 
        /// fires the sp_GetData procedures with the parameter collection.
        /// Returns the fetched dataset.
        /// </summary>
        /// <param name="dc"></param>
        /// <param name="tableName"></param>
        /// <param name="trans"></param>
        /// <returns></returns>
        private DataSet getData(DataColumn[] dc, string tableName, SqlTransaction trans)
        {
            SqlParameter[] _ParametersObject = null;
            try
            {
                _ParametersObject = new SqlParameter[dc.Length];

                int cnt = 0;
                foreach (DataColumn c in dc)
                {
                    _ParametersObject[cnt] = new SqlParameter("@" + c.ColumnName.ToString(), c.Table.Rows[0][c]);
                    cnt++;
                }
                using (DataSet ds = SqlHelper.ExecuteDataset(trans, CommandType.StoredProcedure, "sp_GetData", _ParametersObject))
                {
                    ds.Tables[0].TableName = tableName;
                    return ds;
                }
                return null;

            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - getData(), ParameterCount - 3, dc- " + dc + ", tableName" + tableName + ", trans" + trans + "###";
                throw (ex);
            }

        }



        /// </summary>
        /// <author>Chandan</author>
        /// <CreatedOn>16th Jan '08</CreatedOn>
        /// <param name="DocumentId,Version"></param>
        /// <returns>DataSet</returns>
        public DataSet FillDropDown(string SelectType, string SelectCase)
        {
            SqlParameter[] _SqlparametersObject = null;
            DataSet DataSetFillDropDown = null;
            //DataRow DataRowBlank = null;

            try
            {
                DataSetFillDropDown = new DataSet();
                _SqlparametersObject = new SqlParameter[2];
                _SqlparametersObject[0] = new SqlParameter("@SelectType", SelectType);
                _SqlparametersObject[1] = new SqlParameter("@SelectCase", SelectCase);

                DataSetFillDropDown = SqlHelper.ExecuteDataset(ConnectionString, "ssp_SCGetFillDropDown", _SqlparametersObject);
                if (DataSetFillDropDown != null)
                    if (DataSetFillDropDown.Tables.Count > 0)
                    {
                        DataSetFillDropDown.Tables[0].TableName = "FillDropDown";
                    }

                return DataSetFillDropDown;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - FillDropDown(), ParameterCount - 2, SelectType- " + SelectType + ", SelectCase " + SelectCase + "###";
                ex.Data["DatasetInfo"] = DataSetFillDropDown;
                throw (ex);
            }
            finally
            {
                DataSetFillDropDown = null;
                _SqlparametersObject = null;

            }

        }

        //public DataSet FillDataSetSymptoms(int DocumentId, int VersionId)
        //{
        //    SqlParameter[] _SqlparametersObject = null;
        //    DataSet DataSetSymptoms = null;
        //    //DataRow DataRowBlank = null;
        //    try
        //    {
        //        DataSetSymptoms = new DataSet();
        //        _SqlparametersObject = new SqlParameter[2];
        //        _SqlparametersObject[0] = new SqlParameter("@DocumentId", DocumentId);
        //        _SqlparametersObject[1] = new SqlParameter("@Version", VersionId);

        //        DataSetSymptoms = SqlHelper.ExecuteDataset(ConnectionString, "csp_SCGetSymptomChecklist", _SqlparametersObject);
        //        if (DataSetSymptoms != null)
        //            if (DataSetSymptoms.Tables.Count > 0)
        //            {
        //                DataSetSymptoms.Tables[0].TableName = "CustomHRMAssessmentSymptoms";
        //                DataSetSymptoms.Tables[1].TableName = "CustomHRMSymptoms";
        //            }

        //        return DataSetSymptoms;


        //    }
        //    catch (Exception ex)
        //    {
        //        ex.Data["DatasetInfo"] = DataSetSymptoms;
        //        throw (ex);
        //    }
        //    finally
        //    {
        //        DataSetSymptoms = null;
        //        _SqlparametersObject = null;

        //    }

        //}

        //public DataSet FillDataSetMentalStatus(int DocumentId, int VersionId)
        //{
        //    SqlParameter[] _SqlparametersObject = null;
        //    DataSet DataSetMentalStatus = null;
        //    //DataRow DataRowBlank = null;
        //    try
        //    {
        //        DataSetMentalStatus = new DataSet();
        //        _SqlparametersObject = new SqlParameter[2];
        //        _SqlparametersObject[0] = new SqlParameter("@DocumentId", DocumentId);
        //        _SqlparametersObject[1] = new SqlParameter("@Version", VersionId);

        //        DataSetMentalStatus = SqlHelper.ExecuteDataset(ConnectionString, "csp_SCGetMentalStatusInformation", _SqlparametersObject);
        //        if (DataSetMentalStatus != null)
        //            if (DataSetMentalStatus.Tables.Count > 0)
        //            {
        //                DataSetMentalStatus.Tables[0].TableName = "CustomHRMMentalStatusSections";
        //                DataSetMentalStatus.Tables[1].TableName = "CustomHRMMentalStatusItems";
        //                DataSetMentalStatus.Tables[2].TableName = "CustomHRMAssessmentMentalStatusItems";
        //            }

        //        return DataSetMentalStatus;


        //    }
        //    catch (Exception ex)
        //    {
        //        ex.Data["DatasetInfo"] = DataSetMentalStatus;
        //        throw (ex);
        //    }
        //    finally
        //    {
        //        DataSetMentalStatus = null;
        //        _SqlparametersObject = null;

        //    }

        //}

        /// <summary>
        /// Created By Priya sareen
        /// Created On 8 Feb 2008
        /// </summary>
        /// <param name="DocumentId"></param>
        /// <param name="VersionId"></param>
        /// <returns></returns>

        //public DataSet FillDataSetInitial(int DocumentId, int VersionId)
        //{
        //    SqlParameter[] _SqlparametersObject = null;
        //    DataSet DataSetInitial = null;

        //    try
        //    {
        //        DataSetInitial = new DataSet();
        //        _SqlparametersObject = new SqlParameter[2];
        //        _SqlparametersObject[0] = new SqlParameter("@DocumentId", DocumentId);
        //        _SqlparametersObject[1] = new SqlParameter("@Version", VersionId);

        //        DataSetInitial = SqlHelper.ExecuteDataset(ConnectionString, "csp_SCGetAssessmentInitial", _SqlparametersObject);
        //        if (DataSetInitial != null)
        //            if (DataSetInitial.Tables.Count > 0)
        //            {
        //                DataSetInitial.Tables[0].TableName = "GlobalCodes";
        //                DataSetInitial.Tables[1].TableName = "CustomHRMAssessments";
        //            }

        //        return DataSetInitial;


        //    }
        //    catch (Exception ex)
        //    {
        //        ex.Data["DatasetInfo"] = DataSetInitial;
        //        throw (ex);
        //    }
        //    finally
        //    {
        //        DataSetInitial = null;
        //        _SqlparametersObject = null;

        //    }

        //}





        /// <summary>
        /// Created By Pramod Prakash Mishra
        /// Created On 6 Feb 2008
        /// </summary>
        /// <param name="Spname"></param>
        /// <param name="HashtableObject"></param>
        /// <returns></returns>
        //public DataSet RetrieveDataset(string Spname, string[] tableNames, Hashtable HashtableObject)
        //{
        //    try
        //    {
        //        //Creating an object of type Dataset
        //        DataSet DataSetRetrieve = new DataSet();

        //        //Creating array of type SqlParameter
        //        SqlParameter[] sSqlParameter;

        //        IDictionaryEnumerator EnumObject = HashtableObject.GetEnumerator();

        //        int i = 0;
        //        try
        //        {
        //            //Initialising the array object and setting its value to the parameter passed from UBS
        //            sSqlParameter = new SqlParameter[HashtableObject.Count];

        //            while (EnumObject.MoveNext())
        //            {
        //                sSqlParameter[i] = new SqlParameter("@" + EnumObject.Key.ToString(), EnumObject.Value);
        //                i++;
        //            }

        //            //Executing the stored procedure and getting the values in dataset with the help of Class SqlHelper
        //            SqlHelper.FillDataset(ConnectionString, CommandType.StoredProcedure, Spname, DataSetRetrieve, tableNames, sSqlParameter);
        //            return DataSetRetrieve;
        //            //return SqlHelper.ExecuteDataset(ConnectionString, CommandType.StoredProcedure, Spname, sSqlParameter);

        //        }
        //        catch (Exception ex)
        //        {
        //            throw ex;
        //        }


        //    }
        //    catch (Exception ex)
        //    {
        //        throw ex;
        //    }

        //}

        public DataSet RetrieveDataset(string Spname, string[] tableNames, Hashtable HashtableObject)
        {
            try
            {
                //Creating an object of type Dataset
                DataSet DataSetRetrieve = new DataSet();

                //Creating array of type SqlParameter
                SqlParameter[] sSqlParameter;

                try
                {   //checking HashTable.if it is null then no paramenter needs to pass to stored procedure
                    if (HashtableObject != null)
                    {
                        IDictionaryEnumerator EnumObject = HashtableObject.GetEnumerator();
                        int i = 0;
                        //Initialising the array object and setting its value to the parameter passed from UBS
                        sSqlParameter = new SqlParameter[HashtableObject.Count];

                        while (EnumObject.MoveNext())
                        {
                            sSqlParameter[i] = new SqlParameter("@" + EnumObject.Key.ToString(), EnumObject.Value);
                            i++;
                        }
                        //Executing the stored procedure and getting the values in dataset with the help of Class SqlHelper
                        SqlHelper.FillDataset(ConnectionString, CommandType.StoredProcedure, Spname, DataSetRetrieve, tableNames, sSqlParameter);
                        return DataSetRetrieve;
                        //return SqlHelper.ExecuteDataset(ConnectionString, CommandType.StoredProcedure, Spname, sSqlParameter);

                    }
                    else
                    {


                        //Executing the stored procedure and getting the values in dataset with the help of Class SqlHelper
                        SqlHelper.FillDataset(ConnectionString, CommandType.StoredProcedure, Spname, DataSetRetrieve, tableNames);
                        return DataSetRetrieve;
                        //return SqlHelper.ExecuteDataset(ConnectionString, CommandType.StoredProcedure, Spname, sSqlParameter);
                    }

                }
                catch (Exception ex)
                {
                    throw ex;
                }


            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - RetrieveDataset(), ParameterCount - 3, Spname- " + Spname + ", tableNames " + tableNames + ", HashtableObject " + HashtableObject + "###";
                throw ex;
            }

        }
    }




}

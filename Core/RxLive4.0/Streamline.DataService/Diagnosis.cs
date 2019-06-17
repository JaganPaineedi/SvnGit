using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Data.SqlClient;

namespace Streamline.DataService
{
    public class Diagnosis
    {
        string ConnectionString;
        int newID = 0;
        private SqlTransaction sqlTransactionDx = null;
        private SqlConnection sqlConnectionDx = null;
        private static SqlConnection _SqlConnectionObject = null;
        string _SqlQuery = "";

        /// <summary>
        /// For Database connection of Diagnosis Document.
        /// Created by Pratap Singh as on 26/09/2007
        /// </summary>
        /// <param name=""></param>
        /// <returns></returns>
        public Diagnosis()
        {
            try
            {
                //Made a dataBase connection
                //ConnectionString = @"Data Source=Streamline\Streamline;Initial Catalog=Pines_5.4;uid=shc;pwd=shc";
                ConnectionString = System.Configuration.ConfigurationSettings.AppSettings["SCConnectionString"];
                // TODO: Add constructor logic here

            }
            catch (Exception ex)
            {
                //if (ex.Data["CustomExceptionInformation"] == null)
                //    ex.Data["CustomExceptionInformation"] = "###Source Function Name - Diagnosis(), ParameterCount - 0###";
                throw ex;
            }
        }
        /// <summary>
        /// For fetching the values from database throw store procedure
        /// Created by Pratap Singh as on 26/09/2007
        /// </summary>
        /// <param name=""></param>
        /// <returns></returns>
        public DataSet GetDiagnosisData(string _SPName, int userid, int DataWizardInstanceId, int PreviousDataWizardInstanceId, int NextStepId, int NextWizardId, int EventId, int ClientID, string ClientSearchGUID)
        {
            DataSet DataSetDiagnosis = null;
            SqlParameter[] _ParameterObject = null;
            Guid ClientGuid = new Guid();
            try
            {
                if (ClientSearchGUID.Length > 1)
                {
                    ClientGuid = new Guid(ClientSearchGUID);
                }

                DataSetDiagnosis = new DataSet();
                _ParameterObject = new SqlParameter[8];
                //_ParameterObject[0] = new SqlParameter("@dsmcode", dsmcode);

                _ParameterObject[0] = new SqlParameter("@userid", SqlDbType.Int);
                _ParameterObject[0].Value = userid;

                _ParameterObject[1] = new SqlParameter("@DataWizardInstanceId", SqlDbType.Int);
                if (DataWizardInstanceId != 0)
                    _ParameterObject[1].Value = DataWizardInstanceId;
                else
                    _ParameterObject[1].Value = System.DBNull.Value;

                _ParameterObject[2] = new SqlParameter("@PreviousDataWizardInstanceId", SqlDbType.Int);
                _ParameterObject[2].Value = PreviousDataWizardInstanceId;

                _ParameterObject[3] = new SqlParameter("@NextStepId", SqlDbType.Char);
                if (NextStepId != ' ')
                    _ParameterObject[3].Value = NextStepId;
                else
                    _ParameterObject[3].Value = System.DBNull.Value;

                _ParameterObject[4] = new SqlParameter("@NextWizardId", SqlDbType.Int);
                if (NextWizardId != 0)
                    _ParameterObject[4].Value = NextWizardId;
                else
                    _ParameterObject[4].Value = System.DBNull.Value;

                _ParameterObject[5] = new SqlParameter("@EventId", SqlDbType.Int);
                if (EventId != 0)
                    _ParameterObject[5].Value = EventId;
                else
                    _ParameterObject[5].Value = System.DBNull.Value;

                _ParameterObject[6] = new SqlParameter("@ClientID", SqlDbType.Int);
                if (ClientID != 0)
                    _ParameterObject[6].Value = ClientID;
                else
                    _ParameterObject[6].Value = System.DBNull.Value;
                if (ClientSearchGUID.Length > 1)
                {

                    _ParameterObject[7] = new SqlParameter("@ClientSearchGUID", ClientGuid);
                }
                else
                {
                    _ParameterObject[7] = new SqlParameter("@ClientSearchGUID", System.DBNull.Value);

                }
                DataSetDiagnosis = SqlHelper.ExecuteDataset(ConnectionString, _SPName, _ParameterObject);
                //DataSetDiagnosis.Tables[0].TableName = "Type";
                //DataSetDiagnosis.Tables[1].TableName = "Serverity";
                //DataSetDiagnosis.Tables[2].TableName = "Diagnosis";
                DataSetDiagnosis.Tables[0].TableName = "Diagnosis";
                DataSetDiagnosis.Tables[1].TableName = "Type";
                DataSetDiagnosis.Tables[2].TableName = "Severity";
                DataSetDiagnosis.Tables[3].TableName = "Events";

                if (DataSetDiagnosis.Tables.Count > 4)
                {
                    DataSetDiagnosis.Tables[4].TableName = "Drugs";
                }

                return DataSetDiagnosis;
            }
            catch (Exception ex)
            {
                //if (ex.Data["CustomExceptionInformation"] == null)
                //    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetDiagnosisData(), ParameterCount - 9,First Param" + _SPName + ",Second Param" + userid + ",Third Param" + DataWizardInstanceId + ",Fourth Param" + PreviousDataWizardInstanceId + ",Fifth Param" + NextStepId + ",Sixth Param" + NextWizardId + ",Seventh Param" + EventId + ",Eighth Param" + ClientID + ",Ninth Param" + ClientSearchGUID + "###";
                throw ex;
            }
            finally
            {
                DataSetDiagnosis = null;
                _ParameterObject = null;

            }


        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="dsmcode"></param>
        /// <returns></returns>
        public DataSet GetDSMCodeData(string DSMCode, string DSMDesc)
        {
            DataSet DataSetDiagnosisDSMCode = null;
            SqlParameter[] _ParameterObject = null;
            try
            {
                DataSetDiagnosisDSMCode = new DataSet();
                _ParameterObject = new SqlParameter[2];
                _ParameterObject[0] = new SqlParameter("@DSMCode", DSMCode);
                _ParameterObject[1] = new SqlParameter("@DSMDesc", DSMDesc);


                DataSetDiagnosisDSMCode = SqlHelper.ExecuteDataset(ConnectionString, CommandType.StoredProcedure, "csp_DwPAGetDiagnosisPopUp", _ParameterObject);
                DataSetDiagnosisDSMCode.Tables[0].TableName = "DiagnosisPopup";

                return DataSetDiagnosisDSMCode;
            }
            catch (Exception ex)
            {
                //if (ex.Data["CustomExceptionInformation"] == null)
                //    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetDSMCodeData(), ParameterCount - 2, First Parameter- " + DSMCode + ", Second Parameter-" + DSMDesc + "###";
                throw ex;
            }
            finally
            {
                DataSetDiagnosisDSMCode = null;
                _ParameterObject = null;
            }


        }


        /// <summary>
        /// Checks and gets the DSMCode for the code selected by the user
        /// </summary>
        /// <Author>Vindu Puri</Author>
        /// <Date Created>13-Feb-2008</Date>
        /// <param name="DSMCode"></param>
        /// <returns></returns>
        public string GetDSMCode(string DSMCode, string DSMDesc)
        {

            SqlParameter[] _ParameterObject = null;
            try
            {
                _ParameterObject = new SqlParameter[2];
                _ParameterObject[0] = new SqlParameter("@DSMCode", DSMCode);
                _ParameterObject[1] = new SqlParameter("@DSMDesc", DSMDesc);

                return SqlHelper.ExecuteScalar(ConnectionString, CommandType.StoredProcedure, "csp_SCGetDSMCode", _ParameterObject).ToString();
                //DataSetDiagnosisDSMCode.Tables[0].TableName = "DiagnosisPopup";

                //return DataSetDiagnosisDSMCode;
            }
            catch (Exception ex)
            {
                //if (ex.Data["CustomExceptionInformation"] == null)
                //    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetDSMCodeData(), ParameterCount - 1, First Parameter- " + DSMCode + "###";
                throw ex;
            }
            finally
            {
                //DataSetDiagnosisDSMCode = null;
                _ParameterObject = null;
            }


        }


        /// <summary>
        /// Accepts DataSet from the UBS Layer and
        /// Updates the values in the database using CommandBuilder
        /// <Author>Jatinder Singh</Author>
        /// <Date Created>3-Oct-2007</Date>
        /// </summary>
        /// <param name="DataSetDiagnosis">DataSet.</param>
        /// <returns>bool</returns>
        public bool UpdateDiagnosis(DataSet DataSetDiagnosis)
        {
            //Declare a SqlDataAdapter Object
            SqlDataAdapter objSqlDataAdapter = null;

            //Declare a SqlCommandBuilder Object
            SqlCommandBuilder objSqlCommandBuilder = null;

            //Declare a SqlConnection Object
            SqlConnection SqlCon = null;

            //Declare a SQLTransaction Object
            SqlCommand objSqlCommand = null;

            //Declare a SQLTransaction Object
            SqlTransaction objSqlTransaction = null;
            string _SqlQuery = "";

            try
            {

                #region "Open Connection"
                //Passing the connectionstring as parameter to SqlConnection object
                SqlCon = new SqlConnection(ConnectionString);

                //Open the Connection
                SqlCon.Open();

                //Attach the transaction object with connection
                objSqlTransaction = SqlCon.BeginTransaction();
                #endregion

                _SqlQuery = "Select DiagnosisId,EventId,Axis,";
                _SqlQuery += " Severity,DiagnosisOrder,DSMCode,Specifier,";
                _SqlQuery += " RuleOut,Billable,ModifiedBy,ModifiedDate";
                _SqlQuery += " from EventDiagnosesIAndII where EventId=" + DataSetDiagnosis.Tables["Diagnosis"].Rows[0]["EventId"].ToString();

                #region "Update Diagnosis"

                objSqlCommand = new SqlCommand(_SqlQuery, SqlCon);

                //Create a SQL Data Adapter for the Table to be updated
                objSqlDataAdapter = new SqlDataAdapter(objSqlCommand);

                //Create a Command builder for the data adapter
                objSqlCommandBuilder = new SqlCommandBuilder(objSqlDataAdapter);
                objSqlDataAdapter.SelectCommand.Transaction = objSqlTransaction;

                #region "Commented Commands"

                objSqlDataAdapter.InsertCommand = objSqlCommandBuilder.GetInsertCommand();
                objSqlDataAdapter.InsertCommand.Transaction = objSqlTransaction;

                //objSqlDataAdapter.DeleteCommand = objSqlCommandBuilder.GetDeleteCommand();
                //objSqlDataAdapter.DeleteCommand.Transaction = objSqlTransaction;
                #endregion

                //objSqlCommandBuilder.SetAllValues = false;

                //Assign Update command of command builder to data adapter
                objSqlDataAdapter.UpdateCommand = objSqlCommandBuilder.GetUpdateCommand(true);

                //Attach the transaction object with the update command of Data Adapter
                objSqlDataAdapter.UpdateCommand.Transaction = objSqlTransaction;

                // Set the MissingSchemaAction property to AddWithKey because Fill will not cause primary
                // key & unique key information to be retrieved unless AddWithKey is specified.
                //objSqlDataAdapter.MissingSchemaAction = MissingSchemaAction.AddWithKey;

                //Update the data adapter for given Datatable 
                objSqlDataAdapter.Update(DataSetDiagnosis.Tables["Diagnosis"]);
                #endregion

                //Commit the transaction
                objSqlTransaction.Commit();

                //Close the connection
                SqlCon.Close();
                return true;
            }
            catch (Exception ex)
            {
                // Added by Pratap In order to Implement Exception Management functionality on 27th June 2007
                //if (ex.Data["CustomExceptionInformation"] == null)
                //    ex.Data["CustomExceptionInformation"] = "###Source Function Name - UpdateDiagnosis(), ParameterCount - 1, First Parameter- " + DataSetDiagnosis + "###";
                //if (ex.Data["DatasetInfo"] == null)
                //    ex.Data["DatasetInfo"] = DataSetDiagnosis;
                throw (ex);
            }
            finally
            {
                objSqlDataAdapter = null;
                objSqlCommandBuilder = null;
                SqlCon = null;
                objSqlCommand = null;
                objSqlTransaction = null;
            }
        }



        /// <summary>
        /// This function updates the Diagnosis passed in the DataSet
        /// </summary>
        /// <param name="DataSetDiagnosis"></param>
        /// <Author>Jatinder Singh</Author>
        /// <Date Created>3-Oct-2007</Date>
        public DataSet UpdateDiagnosisData(DataSet DataSetDiagnosis, string _SPName, int userid, int DataWizardInstanceId, int PreviousDataWizardInstanceId, int NextStepId, int NextWizardId, int EventId, int ClientID, string ClientSearchGUID, bool Validate, Int32 ProviderId)
        {
            SqlDataAdapter _SqlDataAdapterObject = null;
            SqlCommandBuilder _SqlCommandBuilderObject = null;
            SqlCommand sqlSelCommand;

            //DataSet DataSetDiagnosis = null;
            SqlParameter[] _ParameterObject = null;
            Guid ClientGuid = new Guid();

            try
            {
                try
                {
                    sqlConnectionDx = new SqlConnection(ConnectionString);
                    sqlConnectionDx.Open();
                    sqlTransactionDx = sqlConnectionDx.BeginTransaction();
                }
                catch (SqlException sqlEx)
                {
                    throw sqlEx;
                }


                //**********
                newID = 0;

                _SqlQuery = "select EventId,UserId,ClientId,EventTypeId,Status,EventDateTime,ProviderId from Events";// where EventId=" + DataSetDiagnosis.Tables["Events"].Rows[0]["EventId"].ToString();
                sqlSelCommand = new SqlCommand(_SqlQuery, sqlConnectionDx, sqlTransactionDx); // , transDiagnosis);
                _SqlDataAdapterObject = new SqlDataAdapter(sqlSelCommand);
                _SqlDataAdapterObject.RowUpdated += new SqlRowUpdatedEventHandler(OnRowUpdatedMain);
                _SqlCommandBuilderObject = new SqlCommandBuilder(_SqlDataAdapterObject);
                _SqlDataAdapterObject.InsertCommand = _SqlCommandBuilderObject.GetInsertCommand();
                _SqlDataAdapterObject.InsertCommand.Transaction = sqlTransactionDx;
                _SqlDataAdapterObject.UpdateCommand = _SqlCommandBuilderObject.GetUpdateCommand();
                _SqlDataAdapterObject.UpdateCommand.Transaction = sqlTransactionDx;
                //_SqlDataAdapterObject.DeleteCommand = _SqlCommandBuilderObject.GetDeleteCommand();
                //_SqlDataAdapterObject.DeleteCommand.Transaction = sqlTransactionDx;
                _SqlDataAdapterObject.Update(DataSetDiagnosis, DataSetDiagnosis.Tables["Events"].TableName);


                //UserID = UserId;
                _SqlQuery = "Select DiagnosisId,EventId,Axis,";
                _SqlQuery += " Severity,DiagnosisType,DiagnosisOrder,DSMCode,DSMNumber,Specifier,";
                _SqlQuery += " RuleOut,Billable,ModifiedBy,ModifiedDate,RecordDeleted,DeletedBy,DeletedDate";
                _SqlQuery += " from EventDiagnosesIAndII ";//where EventId=" + DataSetDiagnosis.Tables["Events"].Rows[0]["EventId"].ToString();

                sqlSelCommand = new SqlCommand(_SqlQuery, sqlConnectionDx, sqlTransactionDx); // , transDiagnosis);
                _SqlDataAdapterObject = new SqlDataAdapter(sqlSelCommand);
                //_SqlDataAdapterObject.RowUpdated += new SqlRowUpdatedEventHandler(OnRowUpdatedClaimLines);
                _SqlDataAdapterObject.RowUpdating += new SqlRowUpdatingEventHandler(_SqlDataAdapterObject_RowUpdating);
                _SqlCommandBuilderObject = new SqlCommandBuilder(_SqlDataAdapterObject);
                _SqlDataAdapterObject.InsertCommand = _SqlCommandBuilderObject.GetInsertCommand();
                _SqlDataAdapterObject.InsertCommand.Transaction = sqlTransactionDx;
                _SqlDataAdapterObject.UpdateCommand = _SqlCommandBuilderObject.GetUpdateCommand();
                _SqlDataAdapterObject.UpdateCommand.Transaction = sqlTransactionDx;
                //_SqlDataAdapterObject.DeleteCommand = _SqlCommandBuilderObject.GetDeleteCommand();
                //_SqlDataAdapterObject.DeleteCommand.Transaction = sqlTransactionDx;
                _SqlDataAdapterObject.Update(DataSetDiagnosis, DataSetDiagnosis.Tables["Diagnosis"].TableName);
                sqlTransactionDx.Commit();



                #region ------------------- Calling the custom stored procedure to go to next step ---------------------------------

                if (ClientSearchGUID.Length > 0)
                {
                    ClientGuid = new Guid(ClientSearchGUID);
                }

                DataSetDiagnosis = new DataSet();
                _ParameterObject = new SqlParameter[9];
                //_ParameterObject[0] = new SqlParameter("@dsmcode", dsmcode);

                _ParameterObject[0] = new SqlParameter("@Userid", SqlDbType.Int);
                _ParameterObject[0].Value = userid;

                _ParameterObject[1] = new SqlParameter("@DataWizardInstanceId", SqlDbType.Int);
                if (DataWizardInstanceId != 0)
                    _ParameterObject[1].Value = DataWizardInstanceId;
                else
                    _ParameterObject[1].Value = System.DBNull.Value;

                _ParameterObject[2] = new SqlParameter("@PreviousDataWizardInstanceId", SqlDbType.Int);
                _ParameterObject[2].Value = PreviousDataWizardInstanceId;

                _ParameterObject[3] = new SqlParameter("@NextStepId", SqlDbType.Char);

                if (NextStepId != ' ')
                    _ParameterObject[3].Value = NextStepId;
                else
                    _ParameterObject[3].Value = System.DBNull.Value;

                _ParameterObject[4] = new SqlParameter("@NextWizardId", SqlDbType.Int);

                if (NextWizardId != 0)
                    _ParameterObject[4].Value = NextWizardId;
                else
                    _ParameterObject[4].Value = System.DBNull.Value;

                _ParameterObject[5] = new SqlParameter("@EventId", SqlDbType.Int);
                _ParameterObject[5].Value = newID == 0 ? EventId : newID;

                _ParameterObject[6] = new SqlParameter("@ClientID", SqlDbType.Int);
                if (ClientID != 0)
                    _ParameterObject[6].Value = ClientID;
                else
                    _ParameterObject[6].Value = System.DBNull.Value;

                _ParameterObject[7] = new SqlParameter("@ClientSearchGUID", ClientGuid);
                if (ClientSearchGUID != "")
                    _ParameterObject[7].Value = ClientGuid;
                else
                    _ParameterObject[7].Value = System.DBNull.Value;


                _ParameterObject[8] = new SqlParameter("@Validate", Validate == true ? 1 : 0);
                //_ParameterObject[8].Value = Validate == true ? 1 : 0;


                DataSetDiagnosis = null;
                DataSetDiagnosis = SqlHelper.ExecuteDataset(ConnectionString, _SPName, _ParameterObject);

                return DataSetDiagnosis;


                #endregion


            }
            catch (System.Data.DBConcurrencyException DBCEX)
            {
                sqlTransactionDx.Rollback();
                //if (DBCEX.Data["CustomExceptionInformation"] == null)
                //    DBCEX.Data["CustomExceptionInformation"] = "###Source Function Name - UpdateDiagnosisData(), ParameterCount - 1, First Parameter- " + DataSetDiagnosis + " ###";
                //if (DBCEX.Data["DatasetInfo"] == null)
                //    DBCEX.Data["DatasetInfo"] = DataSetDiagnosis;
                throw (DBCEX);
            }
            catch (Exception ex)
            {
                sqlTransactionDx.Rollback();
                //if (ex.Data["CustomExceptionInformation"] == null)
                //    ex.Data["CustomExceptionInformation"] = "###Source Function Name - UpdateDiagnosisData(), ParameterCount - 1, First Parameter- " + DataSetDiagnosis + " ###";
                //if (ex.Data["DatasetInfo"] == null)
                //    ex.Data["DatasetInfo"] = DataSetDiagnosis;
                throw (ex);
            }
            finally
            {
                DataSetDiagnosis = null;
                _ParameterObject = null;
                //ClientGuid = null;

                _SqlDataAdapterObject = null;
                _SqlCommandBuilderObject = null;
            }
        }


        /// <summary>
        /// This will be called when the master table (Events) is updated
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        /// <Author>Jatinder Singh</Author>
        /// <Date Created>3-Oct-2007</Date>
        private void OnRowUpdatedMain(object sender, SqlRowUpdatedEventArgs e)
        {
            SqlCommand _SqlCommandObject = null;
            try
            {
                if (e.Errors == null)
                {
                    _SqlCommandObject = new SqlCommand("SELECT @@IDENTITY", e.Command.Connection);
                    _SqlCommandObject.Transaction = e.Command.Transaction;

                    if (e.StatementType == StatementType.Insert)
                    {
                        object ob = _SqlCommandObject.ExecuteScalar();
                        if (ob != DBNull.Value)
                            newID = Convert.ToInt32(ob);
                        //else
                        //    newID = 0;
                    }
                    else
                    {
                        newID = Convert.ToInt32(e.Row["EventId"]);
                    }
                }
                else
                    throw new Exception(e.Errors.Message);
            }
            catch (Exception ex)
            {
                //sqlTransactionDx.Rollback();
                //if (ex.Data["CustomExceptionInformation"] == null)
                //    ex.Data["CustomExceptionInformation"] = "###Source Function Name - UpdateClaim(), ParameterCount - 2, First Parameter- " + sender.ToString() + ", Second Parameter- " + e.ToString() + "###";
                throw (ex);
            }
            finally
            {
                _SqlConnectionObject = null;
                _SqlCommandObject = null;
            }
        }


        /// <summary>
        /// The procedure is called when row in the child table is updating to the database
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        /// <Author>Jatinder Singh</Author>
        /// <Date Created>3-Oct-2007</Date>
        private void _SqlDataAdapterObject_RowUpdating(object sender, SqlRowUpdatingEventArgs e)
        {
            try
            {
                if (e.StatementType == StatementType.Insert)
                {
                    if (newID != 0)
                        e.Row["EventId"] = newID;
                }
                //else if (e.Row["RecordDeleted"] == DBNull.Value || Convert.ToString(e.Row["RecordDeleted"]) == "N")
                //{
                //    _ClaimLineStatus = (int)SqlHelper.ExecuteScalar(e.Command.Transaction, CommandType.Text, "Exec ssp_PAGetClaimLinesStatus " + e.Row["ClaimLineID"]);
                //    if (_ClaimLineStatus != (int)e.Row["Status"])
                //        _ClaimLineStatus = 1;

                //}
            }
            catch (Exception ex)
            {
                //sqlTransactionDx.Rollback();
                //if (ex.Data["CustomExceptionInformation"] == null)
                //    ex.Data["CustomExceptionInformation"] = "###Source Function Name - _SqlDataAdapterObject_RowUpdating(), ParameterCount - 2, First Parameter- " + sender.ToString() + ", Second Parameter- " + e.ToString() + "###";
                throw (ex);
            }
        }

       
    }
}

using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Linq;
using System.Xml;

namespace Streamline.DataService
{
    public class ClientMedication
    {
        private SqlTransaction SqlTransactionObject = null;
        private SqlConnection SqlConnectionObject = null;

        private static SqlConnection _SqlConnectionObject = null;

        public static string ConnectionString = System.Configuration.ConfigurationSettings.AppSettings["SCConnectionString"];
        public static string _ImageServerString = System.Configuration.ConfigurationSettings.AppSettings["ImageServer"];
        private string _ConnectionString = ConnectionString;
        private int _oldclientMedId = -1;
        private string GetImageServerString()
        {
            return _ImageServerString;
        }

        public bool HasImageServerString()
        {
            return !String.IsNullOrEmpty(GetImageServerString());
        }

        /// <summary>
        /// Author Rishu Chopra
        /// it is used to get the MedicationDrug
        /// </summary>
        /// /// <ModifedBy>Loveena</ModifedBy>
        /// in ref to Task#2571-1.9.5.6: Add Soundex Search Opton to My Preferences
        /// added one more parameter char UseSoundexMedicationSearch
        /// <returns></returns>
        public DataSet ClientMedicationDrug(string _MedicationName, char UseSoundexMedicationSearch, char ShowDosagesInList)
        {
            SqlParameter[] _ParametersObject = null;
            try
            {
                _ParametersObject = new SqlParameter[3];
                _ParametersObject[0] = new SqlParameter("@MedicationName ", _MedicationName);
                _ParametersObject[1] = new SqlParameter("@UseSoundexMedicationSearch", UseSoundexMedicationSearch);
                _ParametersObject[2] = new SqlParameter("@ShowDosages", ShowDosagesInList);
                return SqlHelper.ExecuteDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_SCClientMedicationDrug", _ParametersObject);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - ClientMedicationDrug(), ParameterCount - 2, First Parameter- " + _MedicationName + ",Second Parameter-" + UseSoundexMedicationSearch + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }

        }

        /// <summary>
        /// Author Malathi Shiva.
        /// It is used to retrieve Medication drug in textbox.
        /// <ModifedBy></ModifedBy>
        /// WRT Key Point - Customizations Task# 321.3 - Frequency/Direction should be required only if the Client is enrolled in Programs, which has 'Non Prescribed Meds' checked
        /// </summary>
        /// <param name="clientId"></param>
        /// <returns></returns>
        public DataSet GetClientEnrolledPrograms(int clientId, char Order)
        {
            SqlParameter[] _ParametersObject = null;
            try
            {
                _ParametersObject = new SqlParameter[2];
                _ParametersObject[0] = new SqlParameter("@ClientId ", clientId);
                _ParametersObject[1] = new SqlParameter("@Order ", Order);
                return SqlHelper.ExecuteDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_RxClientEnrolledPrograms", _ParametersObject);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetClientEnrolledPrograms(), ParameterCount - 1, First Parameter- " + clientId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }

        }



        /// <summary>
        /// Author Malathi Shiva.
        /// It is used to retrieve Staff License Degree details of a particular Staff.
        /// <ModifedBy></ModifedBy>
        /// WRT EPCS Task# 8 - To bind DEA Numbers of the selected Prescriber
        /// </summary>
        /// <param name="staffId"></param>
        /// <returns></returns>
        public DataSet GetStaffLicenseDegrees(int staffId)
        {
            SqlParameter[] _ParametersObject = null;
            try
            {
                _ParametersObject = new SqlParameter[1];
                _ParametersObject[0] = new SqlParameter("@StaffId", staffId);
                return SqlHelper.ExecuteDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_RxGetStaffLicenseDegrees", _ParametersObject);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - ssp_RxGetStaffLicenseDegrees(), ParameterCount - 1, First Parameter- " + staffId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }

        }

        /// <summary>
        /// Author Rishu Chopra
        /// it is used to fill Dropdown DxPurpose the MedicationDrug.
        /// </summary>
        /// <returns></returns>
        public DataSet ClientMedicationDxPurpose(int _ClientId)
        {
            SqlParameter[] _ParametersObject = null;
            try
            {
                _ParametersObject = new SqlParameter[1];
                _ParametersObject[0] = new SqlParameter("@ClientId ", _ClientId);
                return SqlHelper.ExecuteDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_SCClientMedicationDxpurpose", _ParametersObject);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - ClientMedicationDxPurpose(), ParameterCount - 1, First Parameter- " + _ClientId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }

        }

        /// <summary>
        /// Author:Vikas Vyas
        /// Purpose:Get the Name of the Rdlc,StoredProcedure from DocumentCodes,DocumentCodesRDLSubReports
        /// </summary>
        /// <param name="_DocumentCodeId"></param>
        /// <returns></returns>
        public DataSet GetRdlCNameDataBase(int _DocumentCodeId)
        {

            SqlParameter[] _ParametersObject = null;
            try
            {
                _ParametersObject = new SqlParameter[1];
                _ParametersObject[0] = new SqlParameter("@DocumentCodeId", _DocumentCodeId);
                return SqlHelper.ExecuteDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_SCGetRdlCName ", _ParametersObject);

            }
            catch (Exception ex)
            {

                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetRdlCNameDataBase(), ParameterCount - 1, First Parameter- " + _DocumentCodeId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }

        }


        /// <summary>
        /// Author:Vikas Vyas
        /// Purpose:This function is use to get Data For Main Report / SubReport
        /// On the Basis of ScriptId,__OrderingMethod
        /// </summary>
        /// <param name="_StoredProcedureName"></param>
        /// <param name="ScriptId"></param>
        /// <param name="_OrderingMethod"></param>
        /// <returns></returns>
        /// -------------Modification History----------------------------------
        /// -----Date-----Author---------Purpose-------------------------------
        /// 14 March 2011 Pradeep        Added one more parameter RefillResponseType as per task#3336 
        public DataSet GetDataForRdlC(string _StoredProcedureName, int ScriptId, string _OrderingMethod, int OriginalDataUpdated, int LocationId, string PrintChartCopy, string SessionId, string RefillResponseType)
        {
            SqlParameter[] _ParametersObject = null;
            try
            {
                if (_StoredProcedureName == "ssp_RDLClientPrescriptionMain")
                {
                    _ParametersObject = new SqlParameter[6];
                    _ParametersObject[0] = new SqlParameter("@ClientMedicationScriptIds", ScriptId);
                    _ParametersObject[1] = new SqlParameter("@OrderingMethod", _OrderingMethod);
                    _ParametersObject[2] = new SqlParameter("@OriginalData", OriginalDataUpdated);
                    _ParametersObject[3] = new SqlParameter("@LocationId", LocationId);
                    _ParametersObject[4] = new SqlParameter("@PrintChartCopy", PrintChartCopy);
                    _ParametersObject[5] = new SqlParameter("@SessionId", SessionId);
                }
                else
                {
                    _ParametersObject = new SqlParameter[7];
                    _ParametersObject[0] = new SqlParameter("@ClientMedicationScriptIds", ScriptId);
                    _ParametersObject[1] = new SqlParameter("@OrderingMethod", _OrderingMethod);
                    _ParametersObject[2] = new SqlParameter("@OriginalData", OriginalDataUpdated);
                    _ParametersObject[3] = new SqlParameter("@LocationId", LocationId);
                    _ParametersObject[4] = new SqlParameter("@PrintChartCopy", PrintChartCopy);
                    _ParametersObject[5] = new SqlParameter("@SessionId", SessionId);
                    if (RefillResponseType != string.Empty)
                    {
                        _ParametersObject[6] = new SqlParameter("@RefillResponseType", RefillResponseType);
                    }
                    else
                    {
                        _ParametersObject[6] = new SqlParameter("@RefillResponseType", DBNull.Value);
                    }
                }

                //Commented by Chandan for testing
                return SqlHelper.ExecuteDataset(_ConnectionString, CommandType.StoredProcedure, _StoredProcedureName, _ParametersObject);
                //return SqlHelper.ExecuteDataset(_ConnectionString, CommandType.StoredProcedure, "csp_RDLClientPrescriptionMain_temp", _ParametersObject);


            }
            catch (Exception ex)
            {

                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetDataForRdlC(), ParameterCount - 1, First Parameter- " + _StoredProcedureName + ",Second Paramenter- " + ScriptId + "Third Parameter- " + _OrderingMethod + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);

            }

        }

        public DataSet MedicationGlobalCodeUnit()
        {
            try
            {
                return SqlHelper.ExecuteDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_SCMedicationGlobalCodeUnit");
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - MedicationGlobalCodeUnit(), ParameterCount - 0, ###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }

        }

        /// <summary>
        /// Author Rishu Chopra
        /// it is used to fill Dropdown Medication Strength.
        /// </summary>
        /// <returns></returns>
        public DataSet MedicationStrength(int _MedicationNameId)
        {
            SqlParameter[] _ParametersObject = null;
            try
            {
                _ParametersObject = new SqlParameter[1];
                _ParametersObject[0] = new SqlParameter("@MedicationNameId", _MedicationNameId);
                return SqlHelper.ExecuteDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_SCMedicationStrength", _ParametersObject);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - MedicationStrength(), ParameterCount - 1, First Parameter- " + _MedicationNameId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
        }

        /// <summary>
        /// Author Rishu Chopra
        /// it is used to fill Dropdown MedicationUnit.
        /// </summary>
        /// <returns></returns>
        public DataSet MedicationUnit(int _MedicationId)
        {
            SqlParameter[] _ParametersObject = null;
            try
            {
                _ParametersObject = new SqlParameter[1];
                _ParametersObject[0] = new SqlParameter("@MedicationId", _MedicationId);
                return SqlHelper.ExecuteDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_SCMedicationUnits", _ParametersObject);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - MedicationUnit(), ParameterCount - 1, First Parameter- " + _MedicationId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }

        }


        /// <summary>
        /// This function is used to retrieve all the failed Electronic Prescriptions.	
        /// <Author>Malathi Shiva</Author>        
        /// </summary>
        /// <returns>Dataset with all the respective tables of the document filled</returns>
        public DataSet GetFailedElectronicPrescriptions(int clientId, int staffId)
        {
            SqlParameter[] _ParametersObject = null;
            try
            {
                _ParametersObject = new SqlParameter[2];
                _ParametersObject[0] = new SqlParameter("@ClientId", clientId);
                _ParametersObject[1] = new SqlParameter("@LoggedInStaffId", staffId);
                return SqlHelper.ExecuteDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_RxGetFailedElectronicPrescriptions", _ParametersObject);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetFailedElectronicPrescriptions(), ParameterCount - 2, First Parameter-" + clientId + "Second Parameter-" + staffId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }

        }
        


        /// <summary>
        /// Author Rishu Chopra
        /// it is used to Update the MedicationDocument.
        /// </summary>
        /// <returns></returns>
        public DataSet UpdateDocuments(DataSet DataSetClientMedication)
        {
            try
            {
                string _SelectQuery = "";
                int _TableCount;
                string deviceRegistrationId = "";
                if(DataSetClientMedication.Tables.Contains("TwoFactorAuthenticationDeviceRegistrations") && DataSetClientMedication.Tables["TwoFactorAuthenticationDeviceRegistrations"].Rows.Count > 0)
                deviceRegistrationId = DataSetClientMedication.Tables["TwoFactorAuthenticationDeviceRegistrations"].Rows[0]["TwoFactorAuthenticationDeviceRegistrationId"].ToString();

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
                // to keep only those rows that have been changed
                DataSet dsAdded = DataSetClientMedication.GetChanges(DataRowState.Added);
                DataSet dsModified = DataSetClientMedication.GetChanges(DataRowState.Modified);
                DataSet dsDeleted = DataSetClientMedication.GetChanges(DataRowState.Deleted);
                DataSet dsUnchanged = DataSetClientMedication.GetChanges(DataRowState.Unchanged);
                DataSet dsUpdate = new DataSet();
                if (dsAdded != null)
                    dsUpdate.Merge(dsAdded);
                if (dsModified != null)
                {
                    if (!DataSetClientMedication.ExtendedProperties.ContainsKey("OldClientMedicationId"))
                    {
                        dsUpdate.Merge(dsModified);
                    }
                }
                if (dsDeleted != null)
                    dsUpdate.Merge(dsDeleted);
                DataSetClientMedication = dsUpdate;

                if (DataSetClientMedication.ExtendedProperties.ContainsKey("OldClientMedicationId"))
                {
                    _oldclientMedId = Convert.ToInt32(DataSetClientMedication.ExtendedProperties["OldClientMedicationId"].ToString());
                }

                for (_TableCount = 0; _TableCount <= DataSetClientMedication.Tables.Count - 1; _TableCount++)
                {
                    // Changed on 6/2/2015 by Jason Steczynski, Philhaven Testing Issues Task #553 
                    // If condition reverted back to match that of revision 97816, as a change to prevent the insertion of invalid data was made in Streamline.SmartClient/App_Code/ClientMedicationsNonOrder.cs
                    if (DataSetClientMedication.Tables[_TableCount].TableName != "ClientAllergiesInteraction" && DataSetClientMedication.Tables[_TableCount].TableName != "ClientMedicationData")
                    {
                        //_SelectQuery = "Select * from " + DataSetClientMedication.Tables[_TableCount];
                        _SelectQuery = Streamline.DataService.ApplicationCommonFunctions.GetSelectSQL(DataSetClientMedication.Tables[_TableCount]);
                        SqlCommand sqlSelectCommand;
                        sqlSelectCommand = new SqlCommand(_SelectQuery, SqlConnectionObject, SqlTransactionObject);

                        SqlDataAdapter _SqlDataAdapter = new SqlDataAdapter(sqlSelectCommand);
                        SqlCommandBuilder _SqlCommandBuilder = new SqlCommandBuilder(_SqlDataAdapter);
                        if (DataSetClientMedication.Tables[_TableCount].ToString() == "ClientMedications")
                        {
                            _SqlCommandBuilder.ConflictOption = ConflictOption.OverwriteChanges;
                        }
                        _SqlDataAdapter.InsertCommand = _SqlCommandBuilder.GetInsertCommand();
                        _SqlDataAdapter.UpdateCommand = _SqlCommandBuilder.GetUpdateCommand();
                        _SqlDataAdapter.InsertCommand.Transaction = SqlTransactionObject;
                        _SqlDataAdapter.UpdateCommand.Transaction = SqlTransactionObject;

                        if (DataSetClientMedication.Tables[_TableCount].TableName != "ClientMedicationInteractionDetails" && DataSetClientMedication.Tables[_TableCount].TableName != "ClientMedicationScripts")
                        {
                            _SqlDataAdapter.RowUpdated += new SqlRowUpdatedEventHandler(OnRowUpdated);
                        }
                        if (DataSetClientMedication.Tables[_TableCount].ToString() == "ClientMedicationInstructions")
                        {
                            _SqlDataAdapter.RowUpdated += new SqlRowUpdatedEventHandler(OnClientMedicationInstructionRowUpdated);
                        }
                        if (DataSetClientMedication.Tables[_TableCount].ToString() == "ClientMedicationScripts")
                        {
                            _SqlDataAdapter.RowUpdated += new SqlRowUpdatedEventHandler(OnClientScriptRowUpdated);
                        }
                        if (DataSetClientMedication.Tables[_TableCount].ToString() == "TwoFactorAuthenticationDeviceRegistrations")
                        {
                            _SqlDataAdapter.RowUpdated += new SqlRowUpdatedEventHandler(OnClientScriptRowUpdated);
                        }
                        if (DataSetClientMedication.Tables[_TableCount].ToString() == "TwoFactorAuthenticationDeviceRegistrationHistory")
                        {
                            _SqlDataAdapter.RowUpdated += new SqlRowUpdatedEventHandler(OnClientScriptRowUpdated);
                        }
                        _SqlDataAdapter.Update(DataSetClientMedication.Tables[_TableCount]);

                    }
                }
                if (DataSetClientMedication.Tables["Documents"] != null && DataSetClientMedication.Tables["DocumentVersions"] != null)
                {
                    if (DataSetClientMedication.Tables["Documents"].Rows.Count > 0 && DataSetClientMedication.Tables["DocumentVersions"].Rows.Count > 0)
                    {
                        //To update current Document version Id in Documents.CurrentDocumentVersionId
                        for (int loopCounter = 0; loopCounter < DataSetClientMedication.Tables["Documents"].Rows.Count; loopCounter++)
                        {
                            UpdateCurrentDocumentVersionId(Convert.ToInt32(DataSetClientMedication.Tables["Documents"].Rows[loopCounter]["DocumentId"]), Convert.ToInt32(DataSetClientMedication.Tables["DocumentVersions"].Rows[loopCounter]["DocumentVersionId"]), SqlTransactionObject);
                            DataSetClientMedication.Tables["Documents"].Rows[loopCounter]["CurrentDocumentVersionId"] = Convert.ToInt32(DataSetClientMedication.Tables["DocumentVersions"].Rows[loopCounter]["DocumentVersionId"]);
                        }
                        DataSetClientMedication.AcceptChanges();
                    }
                }

                if (DataSetClientMedication.ExtendedProperties.ContainsKey("OldClientMedicationId"))
                {
                    Int32 _clientMedId = -1;
                    int.TryParse(DataSetClientMedication.ExtendedProperties["OldClientMedicationId"].ToString(), out _clientMedId);
                    SqlParameter[] _objectSqlParmeters = null;

                    string _userCode = "shc";
                    if (DataSetClientMedication.ExtendedProperties.ContainsKey("UserCode"))
                    {
                        _userCode = DataSetClientMedication.ExtendedProperties["UserCode"].ToString();
                    }

                    try
                    {
                        _objectSqlParmeters = new SqlParameter[2];
                        _objectSqlParmeters[0] = new SqlParameter("@ClientMedicationId", _clientMedId);
                        _objectSqlParmeters[1] = new SqlParameter("@DeletedBy", _userCode);
                        SqlHelper.ExecuteNonQuery(SqlTransactionObject, "ssp_UpdateClientMedicationsNonOrder", _objectSqlParmeters);
                    }
                    finally { _objectSqlParmeters = null; }
                }

                SqlTransactionObject.Commit();
                if (dsUnchanged != null)
                {
                    if (!DataSetClientMedication.ExtendedProperties.ContainsKey("OldClientMedicationId"))
                    {
                        DataSetClientMedication.Merge(dsUnchanged);
                    }
                }
                DataSetClientMedication.AcceptChanges();
                return DataSetClientMedication;

            }
            catch (Exception ex)
            {
                SqlTransactionObject.Rollback();
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - UpdateDocuments(), ParameterCount - 1, First Parameter- " + DataSetClientMedication + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
        }

        public void OnRowUpdated(object sender, SqlRowUpdatedEventArgs args)
        {
            DataRow[] _drClientMedicationRows1 = null;
            DataRow[] _drClientMedicationRows2 = null;
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
                                SqlCommand idCMD = new SqlCommand("SELECT @@IDENTITY as ClientMedicationId", args.Command.Connection, args.Command.Transaction);

                                if (args.StatementType == StatementType.Insert)
                                {
                                    //To Retrive Identity Value
                                    newID = Convert.ToInt32(idCMD.ExecuteScalar());


                                    //Changes related to Drug Interactions
                                    if (args.Row.Table.TableName == "ClientMedications")
                                    {
                                        using (DataSet _dsTemp = args.Row.Table.DataSet)
                                        {
                                            if (_dsTemp.Tables.Contains("ClientMedicationInteractions") == true)
                                            {

                                                DataRow[] _drClientMedicationId1Rowscheck = null;
                                                DataRow[] _drClientMedicationId2Rowscheck = null;

                                                var ordered = _dsTemp.Tables["ClientMedications"].AsEnumerable().Where(t => t["ClientMedicationId"].ToString() == args.Row["ClientMedicationId"].ToString()).Select(t => t["Ordered"]).FirstOrDefault().ToString();
                                                if (ordered == "Y")
                                                {
                                                    _drClientMedicationRows1 = _dsTemp.Tables["ClientMedicationInteractions"].Select("ClientMedicationId1=" + args.Row["ClientMedicationId"].ToString());
                                                    _drClientMedicationRows2 = _dsTemp.Tables["ClientMedicationInteractions"].Select("ClientMedicationId2=" + args.Row["ClientMedicationId"].ToString());
                                                }
                                                else if (ordered == "N")
                                                {
                                                    _drClientMedicationId1Rowscheck = _dsTemp.Tables["ClientMedicationInteractions"].Select("ClientMedicationId1=" + _oldclientMedId.ToString());
                                                    _drClientMedicationId2Rowscheck = _dsTemp.Tables["ClientMedicationInteractions"].Select("ClientMedicationId2=" + _oldclientMedId.ToString());

                                                    if (_drClientMedicationId1Rowscheck.Length > 0 || _drClientMedicationId2Rowscheck.Length > 0)
                                                    {
                                                        _drClientMedicationRows1 = _dsTemp.Tables["ClientMedicationInteractions"].Select("ClientMedicationId1=" + _oldclientMedId.ToString());
                                                        _drClientMedicationRows2 = _dsTemp.Tables["ClientMedicationInteractions"].Select("ClientMedicationId2=" + _oldclientMedId.ToString());
                                                    }
                                                    else
                                                    {
                                                        _drClientMedicationRows1 = _dsTemp.Tables["ClientMedicationInteractions"].Select("ClientMedicationId1=" + args.Row["ClientMedicationId"].ToString());
                                                        _drClientMedicationRows2 = _dsTemp.Tables["ClientMedicationInteractions"].Select("ClientMedicationId2=" + args.Row["ClientMedicationId"].ToString());
                                                    }
                                                }

                                                args.Row[0] = newID;

                                                foreach (DataRow _dr1 in _drClientMedicationRows1)
                                                    _dr1["ClientMedicationId1"] = newID;

                                                foreach (DataRow _dr1 in _drClientMedicationRows2)
                                                    _dr1["ClientMedicationId2"] = newID;

                                            }

                                        }

                                    }

                                   //Changes end over here
                                    else

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
                throw (ex);
            }
        }


        public void UpdateCurrentDocumentVersionId(int documentId, int documentVersionId, SqlTransaction SQLTrans)
        {
            SqlParameter[] _objectSqlParmeters = null;
            try
            {

                _objectSqlParmeters = new SqlParameter[3];
                _objectSqlParmeters[0] = new SqlParameter("@DocumentID", documentId);
                _objectSqlParmeters[1] = new SqlParameter("@CurrentDocumentVersionID", documentVersionId);
                _objectSqlParmeters[2] = new SqlParameter("@InitializedXml", "");
                SqlHelper.ExecuteNonQuery(SQLTrans, "SSP_SCUpdateCurrentDocumentVersion", _objectSqlParmeters);
            }
            finally { _objectSqlParmeters = null; }
        }

        public void OnClientMedicationInstructionRowUpdated(object sender, SqlRowUpdatedEventArgs args)
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
                                SqlCommand idCMD = new SqlCommand("SELECT @@IDENTITY as ClientMedicationInstructionId", args.Command.Connection, args.Command.Transaction);

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
                throw (ex);
            }
        }


        public void OnRowUpdatedAllergy(object sender, SqlRowUpdatedEventArgs args)
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
                                SqlCommand idCMD = new SqlCommand("SELECT @@IDENTITY as ClientAllergyId", args.Command.Connection, args.Command.Transaction);

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
                throw (ex);
            }
        }

        /// <summary>
        /// Author Vithobha.
        /// It is used to retrieve Electronic Prescribed Medication data of Particular Client.
        /// </summary>
        /// <param name="ClientMedicationScriptIds"></param>
        /// <param name="OriginalData"></param>
        /// <returns></returns>        
        public DataSet GetElectronicPrescriptionData(string ClientMedicationScriptIds, int OriginalData)
        {
            SqlParameter[] _ParametersObject = null;
            try
            {
                _ParametersObject = new SqlParameter[2];
                DataSet dsTemp = new DataSet();
                _ParametersObject[0] = new SqlParameter("@ClientMedicationScriptIds", ClientMedicationScriptIds);
                _ParametersObject[1] = new SqlParameter("@OriginalData", OriginalData);
                string[] _TableNames = { "MedicationData", "OtherData" };
                SqlHelper.FillDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_RxGetElectronicPrescriptions", dsTemp, _TableNames, _ParametersObject);
                return dsTemp;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetElectronicPrescriptionData(), ParameterCount - 2, First Parameter- " + ClientMedicationScriptIds + "Second Parameter- " + OriginalData + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }
            return null;

        }

        /// <summary>
        /// Author Pranay.
        /// It is used to retrieve Electronic Prescribed Medication data of Particular Client.
        /// </summary>
        /// <param name="ClientMedicationScriptIds"></param>
        /// <returns></returns>        
        public DataSet GetClientMedicationScriptDrugsPreview(string ClientMedicationScriptIds)
        {
            SqlParameter[] _ParametersObject = null;
            try
            {
                _ParametersObject = new SqlParameter[1];
                DataSet dsTemp = new DataSet();
                _ParametersObject[0] = new SqlParameter("@ClientMedicationScriptIds", ClientMedicationScriptIds);
                string[] _TableNames = { "ClientMedicationScriptDrugsPreview" };
                SqlHelper.FillDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_GetClientMedicationScriptDrugsPreview", dsTemp, _TableNames, _ParametersObject);
                return dsTemp;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetClientMedicationScriptDrugsPreview(), ParameterCount - 1, First Parameter- " + ClientMedicationScriptIds + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }
            return null;
        }


        /// <summary>
        /// Author Rishu Chopra
        /// it is used to retrieve particular Clients Data to be shown in Medicationlist.
        /// </summary>
        /// <returns></returns>
        public DataSet GetMedicationData(int ClientId, int StaffId)
        {
            SqlParameter[] _ParametersObject = null;
            try
            {
                _ParametersObject = new SqlParameter[2];
                DataSet dsTemp = new DataSet();
                //string[] _TableNames = { "ClientMedications", "ClientMedicationInstructions" };
                string[] _TableNames = { "ClientMedications", "ClientMedicationInstructions", "ClientMedicationScriptDrugs", "ClientMedicationInteractions", "ClientMedicationInteractionDetails", "ClientMedicationAllergyInteracions", "ClientMedicationConsents", "ClientMedicationScriptDrugStrengths", "ClientMedicationScriptDispenseDays" };
                _ParametersObject[0] = new SqlParameter("@ClientId", ClientId);
                _ParametersObject[1] = new SqlParameter("@PrescriberId", StaffId);
                SqlHelper.FillDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_SCGetClientMedicationDataWithOverrides", dsTemp, _TableNames, _ParametersObject);
                return dsTemp;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetMedicationData(), ParameterCount - 2, First Parameter- " + ClientId + "Second Parameter- " + StaffId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
        }

        # region Client Medication Order Details
        /// <summary>
        /// <Author>Sonia</Author>
        /// <Purpose>To get the Order Details of  a Particular Medication</Purpose>
        /// </summary>
        /// <param name="clientMedicationId"></param>
        /// <returns></returns>
        public DataSet GetMedicationOrderDetails(int clientMedicationId, int ClientMedicationScriptId)
        {
            SqlParameter[] _ParametersObject = null;
            try
            {
                _ParametersObject = new SqlParameter[2];
                DataSet dsTemp = new DataSet();
                string[] _TableNames = { "ClientMedications", "ClientMedicationInstructions", "DrugCategory" };
                _ParametersObject[0] = new SqlParameter("@ClientMedicationId", clientMedicationId);
                _ParametersObject[1] = new SqlParameter("@ClientMedicationScriptId", ClientMedicationScriptId);
                SqlHelper.FillDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_SCGetClientMedicationOrderDetails", dsTemp, _TableNames, _ParametersObject);
                return dsTemp;
            }

            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetMedicationOrderDetails(), ParameterCount - 1, First Parameter- " + clientMedicationId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }


        }

        public void DeleteMedicationOrderDetails(int clientMedicationId)
        {
            SqlParameter[] _ParameterObj = null;
            try
            {
                _ParameterObj = new SqlParameter[1];
                _ParameterObj[0] = new SqlParameter("@ClientMedicationId", clientMedicationId);
                SqlHelper.ExecuteNonQuery(_ConnectionString, CommandType.StoredProcedure, "ssp_SCDeleteMedicationOrderDetails", _ParameterObj);

            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - DeleteMedicationOrderDetails(), ParameterCount - 1, First Parameter- " + clientMedicationId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }



        }

        # endregion Client Medication Order Details
        /// <summary>
        /// <Author>Sonia</Author>
        /// <Purpose>To get the Allergies Data based on Search Criteria</Purpose>
        /// </summary>
        /// <param name="SearchCriteria"></param>
        /// <returns></returns>
        public DataSet GetAllergiesData(string SearchCriteria)
        {
            SqlParameter[] _ParametersObject = null;
            try
            {

                _ParametersObject = new SqlParameter[1];
                _ParametersObject[0] = new SqlParameter("@SearchCriteria", SearchCriteria);
                DataSet dsTemp = new DataSet();
                string[] _TableNames = { "AllergenConcepts" };
                SqlHelper.FillDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_SCGetAllergiesData", dsTemp, _TableNames, _ParametersObject);
                return dsTemp;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetAllergiesData(),Parameter Count=0";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }

            return null;


        }

        /// <summary>
        /// <Author>Sonia</Author>
        /// <Purpose>To get the Client Allergies Data to be displayed on First page of MM</Purpose>
        /// </summary>
        /// <param name="ClientId"></param>
        /// <returns></returns>
        public DataSet GetClientAllergiesData(Int32 ClientId)
        {
            SqlParameter[] _ParametersObject = null;
            try
            {

                _ParametersObject = new SqlParameter[1];
                _ParametersObject[0] = new SqlParameter("@ClientId", ClientId);
                DataSet dsTemp = new DataSet();
                string[] _TableNames = { "ClientAllergies", "ClientAllergiesHistory" };
                //SqlHelper.FillDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_SCGetClientAllergiesData", dsTemp, _TableNames, _ParametersObject);
                SqlHelper.FillDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_SCClientAllergyData", dsTemp, _TableNames, _ParametersObject);
                return dsTemp;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetClientAllergiesData(),Parameter Count=1";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }

            return null;


        }

        /// <summary>
        /// <Author>Loveena</Author>
        /// <Purpose>To get the Client Allergies Data to be displayed on First page of MM</Purpose>
        /// </summary>
        /// <param name="ClientId"></param>
        /// <returns></returns>
        public DataSet GetClientAllergies(Int32 ClientId)
        {
            SqlParameter[] _ParametersObject = null;
            try
            {

                _ParametersObject = new SqlParameter[1];
                _ParametersObject[0] = new SqlParameter("@ClientId", ClientId);
                DataSet dsTemp = new DataSet();
                string[] _TableNames = { "ClientAllergies", "ClientAllergyHistory" };
                SqlHelper.FillDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_SCGetClientAllergies", dsTemp, _TableNames, _ParametersObject);
                return dsTemp;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetClientAllergies(),Parameter Count=1";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }

            return null;


        }


        public DataSet UpdateClientAllergies(DataSet DataSetClientAllergies, int UserId, string UserCode)
        {
            try
            {
                string _SelectQuery = "";
                int _TableCount;
                bool allergiesUpdated = false;


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


                for (_TableCount = 0; _TableCount <= DataSetClientAllergies.Tables.Count - 1; _TableCount++)
                {
                    //_SelectQuery = "Select * from " + DataSetClientAllergies.Tables[_TableCount];
                    _SelectQuery = Streamline.DataService.ApplicationCommonFunctions.GetSelectSQL(DataSetClientAllergies.Tables[_TableCount]);
                    SqlCommand sqlSelectCommand;
                    sqlSelectCommand = new SqlCommand(_SelectQuery, SqlConnectionObject, SqlTransactionObject); // , transDiagnosis);


                    SqlDataAdapter _SqlDataAdapter = new SqlDataAdapter(sqlSelectCommand);
                    SqlCommandBuilder _SqlCommandBuilder = new SqlCommandBuilder(_SqlDataAdapter);
                    _SqlDataAdapter.InsertCommand = _SqlCommandBuilder.GetInsertCommand();
                    _SqlDataAdapter.UpdateCommand = _SqlCommandBuilder.GetUpdateCommand();
                    _SqlDataAdapter.InsertCommand.Transaction = SqlTransactionObject;
                    _SqlDataAdapter.UpdateCommand.Transaction = SqlTransactionObject;
                    if (DataSetClientAllergies.Tables[_TableCount].ToString() == "ClientMedications")
                    {
                        _SqlDataAdapter.RowUpdated += new SqlRowUpdatedEventHandler(OnRowUpdatedAllergy);
                    }
                    if (DataSetClientAllergies.Tables[_TableCount].ToString() == "ClientAllergies")
                    {
                        allergiesUpdated = true;
                        _SqlDataAdapter.RowUpdated += new SqlRowUpdatedEventHandler(OnRowUpdatedAllergy);
                    }
                    _SqlDataAdapter.Update(DataSetClientAllergies.Tables[_TableCount]);
                }
                SqlTransactionObject.Commit();

                if(allergiesUpdated)
                {
                    if(DataSetClientAllergies.Tables.Contains("ClientAllergies") && DataSetClientAllergies.Tables["ClientAllergies"].Rows.Count > 0)
                    {
                        int clientAllergyId = Convert.ToInt32(DataSetClientAllergies.Tables["ClientAllergies"].Rows[0]["ClientAllergyId"].ToString());
                        ClientAllergiesPostUpdate(clientAllergyId, UserId, UserCode, "I");
                    }
                }

                return DataSetClientAllergies;

            }
            catch (Exception ex)
            {
                SqlTransactionObject.Rollback();
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - UpdateClientAllergies(), ParameterCount - 1, First Parameter- " + DataSetClientAllergies + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = DataSetClientAllergies;
                throw (ex);
            }
        }

        /// <summary>
        /// Author:Sonia Dhamija
        /// DeleteAllergy()--->This will execute when user clicks delete option of grid (Known Allergies)
        /// </summary>
        /// <param name="ClientAllergyId"></param>
        /// <returns>int</returns>



        public int DeleteAllergy(int ClientAllergyId, int UserId, string UserCode)
        {
            // ssp_SCDeleteClientAllergy contains an insert statement that pulls history data before it is deleted
            SqlParameter[] parm = new SqlParameter[2];
            try
            {
                int retInt = 0;
                parm = new SqlParameter[2];
                parm[0] = new SqlParameter("@ClientAllergyId", ClientAllergyId);
                parm[1] = new SqlParameter("@DeletedBy", UserCode);
                retInt = SqlHelper.ExecuteNonQuery(_ConnectionString, CommandType.StoredProcedure, "ssp_SCDeleteClientAllergy", parm);
                ClientAllergiesPostUpdate(ClientAllergyId, UserId, UserCode, "D");
                return retInt;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - DeleteAllergy(),Parameter Count=1,Parameter Name=ClientAllergyId";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }
            finally
            {
                parm = null;
            }


        }

        public int ClientAllergiesPostUpdate(int clientAllergyId, int UserId, string UserCode, string action)
        {
            SqlParameter[] parm = new SqlParameter[4];
            try
            {
                int retInt = 0;
                XmlDocument xm = new XmlDocument();
                xm.LoadXml(string.Format("<root><action>{0}</action></root>", action));
                parm = new SqlParameter[4];
                parm[0] = new SqlParameter("@ScreenKeyId", clientAllergyId);
                parm[1] = new SqlParameter("@StaffId", UserId);
                parm[2] = new SqlParameter("@CurrentUser", UserCode);
                parm[3] = new SqlParameter("@CustomParameters", xm.InnerXml);
                retInt = SqlHelper.ExecuteNonQuery(_ConnectionString, CommandType.StoredProcedure, "ssp_MMPostUpdateClientAllergy", parm);
                return retInt;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - ssp_MMPostUpdateClientAllergy(),Parameter Count=4,Parameter Name=ClientAllergyId";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }
            finally
            {
                parm = null;
            }


        }

        /// <summary>
        /// This function gets Medication's Data
        /// </summary>
        /// <author>Sonia Dhamija</author>
        /// <param name="ClinicianId"></param>
        /// <param name="ClientId"></param>
        /// <returns>DataSet</returns>
        public DataSet DownloadClientMedicationSummary(string ClientRowIdentifier, string ClinicianRowIdentifier, bool RequirePharamcies)
        {
            SqlParameter[] objParam;
            DataSet dsTemp = null;
            try
            {
                dsTemp = new DataSet();
                objParam = new SqlParameter[3];
                objParam[0] = new SqlParameter("@ClientRowIdentifier", ClientRowIdentifier);
                objParam[1] = new SqlParameter("@StaffRowIdentifier", ClinicianRowIdentifier);
                objParam[2] = new SqlParameter("@RequirePharamcies", RequirePharamcies == true ? 1 : 0);
                string[] _TableNames = { "ClientAllergies", "ClientAllergyHistory", "ClientMedications", "ClientMedicationInstructions", "ClientMedicationScriptDrugs", "ClientMedicationInteractions", "ClientMedicationInteractionDetails", "ClientMedicationAllergyInteracions", "ClientMedicationConsents", "ClientMedicationScriptDrugStrengths", "ClientMedicationScriptDispenseDays", "DiagnosisIIICodes", "ClientInfoAreaHtml", "ClientInformation", "FormularyRequestInformation", "ClientPharmacies", "AllPharmacies" };
                //string[] _TableNames = { "ClientAllergies", "ClientAllergyHistory", "ClientMedications", "ClientMedicationInstructions", "ClientMedicationScriptDrugs", "ClientMedicationInteractions", "ClientMedicationInteractionDetails", "ClientMedicationAllergyInteracions", "ClientMedicationConsents", "ClientMedicationScriptDrugStrengths", "DiagnosisIIICodes", "ClientInfoAreaHtml", "ClientInformation", "ClientPharmacies", "AllPharmacies" };


                SqlHelper.FillDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_SCClientMedicationSummaryInfo", dsTemp, _TableNames, objParam);
                return dsTemp;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - DownloadClientMedicationSummary(), ParameterCount - 2, First Parameter- " + ClientRowIdentifier + " Second Parameter- " + ClinicianRowIdentifier + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);

            }
            finally
            {
                objParam = null;
            }
        }
        //Added By Sonia to Get Client's Medication History Only to Display on View Medication History
        public DataSet DownloadClientMedicationHistory(Int64 ClientId)
        {
            SqlParameter[] objParam;
            try
            {
                DataSet dsTemp;
                dsTemp = new DataSet();
                objParam = new SqlParameter[1];
                objParam[0] = new SqlParameter("@ClientId", ClientId);

                string[] _TableNames = { "ClientMedications", "ClientMedicationInstructions" };
                SqlHelper.FillDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_SCGetClientMedicationDetails", dsTemp, _TableNames, objParam);
                // return SqlHelper.ExecuteDataset(_ConnectionString,CommandType.StoredProcedure,"ssp_SCGetClientMedicationDetails",
                //(_ConnectionString, CommandType.StoredProcedure, "ssp_SCGetClientMedicationDetails", objParam);
                return dsTemp;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - DownloadClientMedicationHistory(), ParameterCount -1, First Parameter- " + ClientId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);

            }
            finally
            {
                objParam = null;
            }
        }



        /// <summary>
        /// Added by Sonia to Discontinue Medication From Medication List
        /// DiscontinueMedication()--->This will execute when user clicks delete option of grid in Medication Management
        /// </summary>

        //public int DiscontinueMedication(int ClientMedicationId, char TobeDiscontinued, string ModifiedBy, string DiscontinueReason, string DiscontinueReasonCode)
        public int DiscontinueMedication(int ClientMedicationId, char TobeDiscontinued, string ModifiedBy, string DiscontinueReason, int DiscontinueReasonCode, int ClientMedicationConsentId, string SureScriptsOutgoingMessageId, string MethodName, int PrescriberId,int PharmacyId)
        {
            SqlParameter[] parm;
            try
            {
                int retInt = 0;
                parm = new SqlParameter[10];
                parm[0] = new SqlParameter("@ClientMedicationid", ClientMedicationId);
                parm[1] = new SqlParameter("@Discontinue", TobeDiscontinued);
                parm[2] = new SqlParameter("@ModifiedBy", ModifiedBy);
                parm[3] = new SqlParameter("@DiscontinueReason", DiscontinueReason);
                if (DiscontinueReasonCode == 0)
                {
                    parm[4] = new SqlParameter("@DiscontinueReasonCode", System.DBNull.Value);
                }
                else
                {
                    parm[4] = new SqlParameter("@DiscontinueReasonCode", DiscontinueReasonCode);
                }
                parm[5] = new SqlParameter("@ClientMedicationConsentId", ClientMedicationConsentId);
                parm[6] = new SqlParameter("@SureScriptsOutgoingMessageId", SureScriptsOutgoingMessageId);
                parm[7] = new SqlParameter("@MethodName", MethodName);
                parm[8] = new SqlParameter("@PrescriberId", PrescriberId);

                if (PharmacyId == 0)
                {
                    parm[9] = new SqlParameter("@PharmacyId", System.DBNull.Value);
                }
                else
                {
                    parm[9] = new SqlParameter("@PharmacyId", PharmacyId);
                }
                retInt = SqlHelper.ExecuteNonQuery(_ConnectionString, CommandType.StoredProcedure, "ssp_SCDiscontinueMedication", parm);
                return retInt;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - DiscontinueMedication(), ParameterCount - 2, First Parameter- " + ClientMedicationId + " Second Parameter- " + TobeDiscontinued + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
            finally
            {
                parm = null;
            }



        }

        /// <summary>
        /// Added By Rishu to return Monographtext
        /// </summary>
        /// <param name="druginteractionmonographid"></param>
        /// <returns>Dataset</returns>
        public DataSet GetClientMedicationmonographtext(int DrugInteractionMonographId)
        {
            SqlParameter[] _ParametersObject = null;
            try
            {
                _ParametersObject = new SqlParameter[1];
                _ParametersObject[0] = new SqlParameter("@druginteractionmonographid", DrugInteractionMonographId);
                DataSet dsTemp = new DataSet();
                string[] _TableNames = { "MDDrugDrugInteractionMonographText" };
                SqlHelper.FillDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_SCGetClientMedicationmonographtext", dsTemp, _TableNames, _ParametersObject);
                return dsTemp;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetClientAllergiesData(),Parameter Count=1";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }

            return null;
        }

        #region ClientScripts

        public DataSet UpdateClientScripts(DataSet DataSetMedicationScripts)
        {
            try
            {
                string _SelectQuery = "";
                int _TableCount;
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


                for (_TableCount = 0; _TableCount <= DataSetMedicationScripts.Tables.Count - 1; _TableCount++)
                {
                    //_SelectQuery = "Select * from " + DataSetMedicationScripts.Tables[_TableCount];
                    _SelectQuery = Streamline.DataService.ApplicationCommonFunctions.GetSelectSQL(DataSetMedicationScripts.Tables[_TableCount]);
                    SqlCommand sqlSelectCommand;
                    sqlSelectCommand = new SqlCommand(_SelectQuery, SqlConnectionObject, SqlTransactionObject); // , transDiagnosis);


                    SqlDataAdapter _SqlDataAdapter = new SqlDataAdapter(sqlSelectCommand);
                    SqlCommandBuilder _SqlCommandBuilder = new SqlCommandBuilder(_SqlDataAdapter);
                    _SqlDataAdapter.InsertCommand = _SqlCommandBuilder.GetInsertCommand();
                    _SqlDataAdapter.UpdateCommand = _SqlCommandBuilder.GetUpdateCommand();
                    _SqlDataAdapter.InsertCommand.Transaction = SqlTransactionObject;
                    _SqlDataAdapter.UpdateCommand.Transaction = SqlTransactionObject;
                    if (DataSetMedicationScripts.Tables[_TableCount].ToString() == "ClientMedicationScripts")
                    {
                        _SqlDataAdapter.RowUpdated += new SqlRowUpdatedEventHandler(OnClientScriptRowUpdated);
                    }
                    _SqlDataAdapter.Update(DataSetMedicationScripts.Tables[_TableCount]);
                }
                SqlTransactionObject.Commit();
                return DataSetMedicationScripts;

            }
            catch (Exception ex)
            {
                SqlTransactionObject.Rollback();
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - UpdateDocuments(), ParameterCount - 1, First Parameter- " + DataSetMedicationScripts + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
        }

        public DataSet UpdateClientScriptActivities(DataSet DataSetClientScriptActivities)
        {
            try
            {
                string _SelectQuery = "";
                int _TableCount;
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

                for (_TableCount = 0; _TableCount <= DataSetClientScriptActivities.Tables.Count - 1; _TableCount++)
                {
                    if (DataSetClientScriptActivities.Tables[_TableCount].ToString() !=
                        "ClientMedicationScriptActivitiesFaxData")
                    {
                        //_SelectQuery = "Select * from " + DataSetClientScriptActivities.Tables[_TableCount];
                        _SelectQuery = Streamline.DataService.ApplicationCommonFunctions.GetSelectSQL(DataSetClientScriptActivities.Tables[_TableCount]);
                        SqlCommand sqlSelectCommand;
                        sqlSelectCommand = new SqlCommand(_SelectQuery, SqlConnectionObject, SqlTransactionObject);


                        SqlDataAdapter _SqlDataAdapter = new SqlDataAdapter(sqlSelectCommand);
                        SqlCommandBuilder _SqlCommandBuilder = new SqlCommandBuilder(_SqlDataAdapter);
                        _SqlDataAdapter.InsertCommand = _SqlCommandBuilder.GetInsertCommand();
                        _SqlDataAdapter.UpdateCommand = _SqlCommandBuilder.GetUpdateCommand();
                        _SqlDataAdapter.InsertCommand.Transaction = SqlTransactionObject;
                        _SqlDataAdapter.UpdateCommand.Transaction = SqlTransactionObject;
                        if (DataSetClientScriptActivities.Tables[_TableCount].ToString() ==
                            "ClientMedicationScriptActivities")
                        {
                            _SqlDataAdapter.RowUpdated += new SqlRowUpdatedEventHandler(OnClientScriptActivityRowUpdated);
                        }
                        _SqlDataAdapter.Update(DataSetClientScriptActivities.Tables[_TableCount]);
                    }
                }
                SqlTransactionObject.Commit();
                UpdateClientScriptActivitiesFaxData(DataSetClientScriptActivities);
                return DataSetClientScriptActivities;

            }
            catch (Exception ex)
            {
                SqlTransactionObject.Rollback();
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - UpdateClientScriptActivities(), ParameterCount - 1, First Parameter- " + DataSetClientScriptActivities + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
        }

        private void UpdateClientScriptActivitiesFaxData(DataSet ds)
        {
            if (HasImageServerString() && ds.Tables.Contains("ClientMedicationScriptActivitiesFaxData") && ds.Tables["ClientMedicationScriptActivitiesFaxData"].Rows.Count > 0)
            {
                try
                {
                    using (SqlConnection conn = new SqlConnection(GetImageServerString()))
                    {
                        conn.Open();
                        SqlCommand cmd = new SqlCommand("Select * from ClientMedicationScriptActivitiesFaxData", conn);
                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        SqlCommandBuilder cb = new SqlCommandBuilder(da);
                        da.InsertCommand = cb.GetInsertCommand();
                        da.UpdateCommand = cb.GetUpdateCommand();
                        da.Update(ds.Tables["ClientMedicationScriptActivitiesFaxData"]);
                        conn.Close();
                    }
                }
                catch (Exception ex)
                {
                    if (ex.Data["CustomExceptionInformation"] == null)
                        ex.Data["CustomExceptionInformation"] = "###Source Function Name - UpdateClientScriptActivitiesFaxData(), ParameterCount - 1, First Parameter- " + ds + "###";
                    if (ex.Data["DatasetInfo"] == null)
                        ex.Data["DatasetInfo"] = null;
                    throw (ex);
                }
            }
        }

        public void OnClientScriptRowUpdated(object sender, SqlRowUpdatedEventArgs args)
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
                                SqlCommand idCMD = new SqlCommand("SELECT @@IDENTITY as ClientMedicationScriptId", args.Command.Connection, args.Command.Transaction);

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
                throw (ex);
            }
        }

        public void OnClientScriptActivityRowUpdated(object sender, SqlRowUpdatedEventArgs args)
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
                                SqlCommand idCMD = new SqlCommand("SELECT @@IDENTITY as ClientMedicationScriptActivityId", args.Command.Connection, args.Command.Transaction);

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
                throw (ex);
            }
        }


        /// <summary>
        /// Author:Sonia Dhamija
        /// Purpose:Added By Sonia to Get Client's Medication Script History Only
        /// </summary>
        /// <param name="ClientId"></param>
        /// <param name="ClientMedicationScriptId"></param>
        /// <ModifiedBy>Sonia</ModifiedBy>
        /// <ModifiedDate>27thMay2008</ModifiedDate>
        /// <ModificationPurpose>New Parameter ClientMedicationScriptId so that ScriptHistory is fetched along with MedicationId </ModificationPurpose>
        /// <returns>DataSet</returns>

        public DataSet DownloadClientMedicationScriptHistory(Int64 ClientId, Int64 ClientMedicationId, Int32 ClientMedicationScriptId)
        {
            SqlParameter[] objParam;
            try
            {
                DataSet dsTemp;
                dsTemp = new DataSet();
                objParam = new SqlParameter[3];
                objParam[0] = new SqlParameter("@ClientId", ClientId);
                objParam[1] = new SqlParameter("@ClientMedicationId", ClientMedicationId);
                //A new parameter ClientMedicationScriptId needs to be passed so that Medication Script History Details can be fetched along with other parameters
                objParam[2] = new SqlParameter("@ClientMedicationScriptId", ClientMedicationScriptId);

                string[] _TableNames = { "ClientMedicationScripts" };
                SqlHelper.FillDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_SCGetClientMedicationScriptHistory", dsTemp, _TableNames, objParam);
                return dsTemp;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - DownloadClientMedicationScriptHistory(), ParameterCount -1, First Parameter- " + ClientId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
            finally
            {
                objParam = null;
            }
        }
        /// <summary>
        /// Author:Sonia
        /// Pupose:-To insert the record into ClientMedicationScriptActivities
        /// </summary>
        /// <param name="ClientMedicationScriptId"></param>
        /// <param name="Method"></param>
        /// <param name="PharmacyId"></param>
        /// <param name="Reason"></param>
        /// <param name="CreatedBy"></param>
        /// <returns></returns>
        public int InsertIntoClientMedicationScriptActivities(int ClientMedicationScriptId, char Method, int PharmacyId, int Reason, string CreatedBy)
        {
            SqlParameter[] objParam;
            try
            {
                DataSet dsTemp;
                dsTemp = new DataSet();
                objParam = new SqlParameter[6];
                objParam[0] = new SqlParameter("@ClientMedicationScriptId", ClientMedicationScriptId);
                objParam[1] = new SqlParameter("@Method", Method);
                if (PharmacyId == 0)
                    objParam[2] = new SqlParameter("@PharmacyId", System.DBNull.Value);
                else
                    objParam[2] = new SqlParameter("@PharmacyId", PharmacyId);

                objParam[3] = new SqlParameter("@Reason", Reason);
                objParam[4] = new SqlParameter("@CreatedBy", CreatedBy);
                objParam[5] = new SqlParameter("@ClientMedicationScriptActivityId", 0);
                objParam[5].Direction = ParameterDirection.Output;
                SqlHelper.ExecuteNonQuery(_ConnectionString, CommandType.StoredProcedure, "ssp_SCClientScriptActivitiesInsertNew", objParam);
                return Convert.ToInt32(objParam[5].Value.ToString());
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - InsertIntoClientMedicationScriptActivities(), ParameterCount -5, First Parameter- " + ClientMedicationScriptId + "Second Parameter- " + Method + "Third Parameter- " + PharmacyId + "Fourth Parameter- " + Reason + "Fifth Parameter- " + CreatedBy + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
            finally
            {
                objParam = null;
            }

        }



        /// <summary>
        /// Added By Sony to Get  Medication Drug Interaction
        /// </summary>
        /// <param name="MedicationIds></param>
        /// <param name="ClientId"></param>
        /// <param name="StaffId"></param>
        /// <returns></returns>
        public DataSet GetClientMedicationDrugInteraction(string MedicationIds, int ClientId, int StaffId)
        {
            SqlParameter[] objParam;
            try
            {
                DataSet dsTemp;
                dsTemp = new DataSet();
                objParam = new SqlParameter[3];
                objParam[0] = new SqlParameter("@MedicationIds", MedicationIds);
                objParam[1] = new SqlParameter("@ClientId", ClientId);
                objParam[2] = new SqlParameter("@PrescriberId", StaffId);

                string[] _TableNames = { "ClientMedicationInteraction", "ClientAllergyInteraction" };
                SqlHelper.FillDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_SCGetClientMedicationDrugInteractionWithOverrides", dsTemp, _TableNames, objParam);
                return dsTemp;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetClientMedicationDrugInteraction(), ParameterCount -3, First Parameter- " + MedicationIds + "Second Parameter- " + ClientId + "Third Parameter- " + StaffId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
            finally
            {
                objParam = null;
            }
        }

        /// <summary>
        /// Added By Malathi Shiva to Get Request XML for PMP Gateway 
        /// </summary>
        /// <param name="ClientId"></param>
        /// <param name="StaffId"></param>
        /// <returns></returns>
        public DataSet GetClientRequestXMLForPMP(int ClientId, int StaffId)
        {
            SqlParameter[] objParam;
            try
            {
                DataSet dsTemp;
                dsTemp = new DataSet();
                objParam = new SqlParameter[2];
                objParam[0] = new SqlParameter("@ClientId", ClientId);
                objParam[1] = new SqlParameter("@StaffId", StaffId);

                string[] _TableNames = { "ClientRequestXMLDetails" };
                SqlHelper.FillDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_RxPMPClientRequestXMLGeneration", dsTemp, _TableNames, objParam);
                return dsTemp;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetClientRequestXMLForPMP(), ParameterCount -2, First Parameter- " + ClientId + "Second Parameter- " + StaffId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
            finally
            {
                objParam = null;
            }
        }

        /// <summary>
        /// Added By Malathi Shiva to save Response XML received from PMP Gateway
        /// </summary>
        /// <param name="ClientId"></param>
        /// <param name="StaffId"></param>
        /// <returns></returns>
        public DataSet UpdateResponseXMLDetails(int PMPAuditTrailId, string response)
        {
            SqlParameter[] objParam;
            try
            {
                DataSet dsTemp;
                dsTemp = new DataSet();
                objParam = new SqlParameter[2];
                objParam[0] = new SqlParameter("@PMPAuditTrailId", PMPAuditTrailId);
                objParam[1] = new SqlParameter("@ResponseXML", response);

                string[] _TableNames = { "PMPAuditTrails" };
                SqlHelper.FillDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_RxUpdatePMPAuditTrails", dsTemp, _TableNames, objParam);
                return dsTemp;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetClientMedicationDrugInteraction(), ParameterCount -2, First Parameter- " + PMPAuditTrailId + "Second Parameter- " + response + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
            finally
            {
                objParam = null;
            }
        }


        /// <summary>
        /// Added by Sonia to get Allergy and Medication interactions
        /// </summary>
        /// <param name="ClientId"></param>
        /// <param name="StaffId"></param>
        /// <returns></returns>
        public DataTable GetClientDrugAllergyInteraction(int ClientId, int StaffId)
        {
            SqlParameter[] objParam;
            try
            {
                DataSet dsTemp;
                dsTemp = new DataSet();
                objParam = new SqlParameter[2];

                objParam[0] = new SqlParameter("@ClientId", ClientId);
                objParam[1] = new SqlParameter("@PrescriberId", StaffId);

                string[] _TableNames = { "ClientAllergyInteraction" };
                SqlHelper.FillDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_SCGetClientDrugAllergyInteractionWithOverrides", dsTemp, _TableNames, objParam);
                return dsTemp.Tables[0];
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetClientDrugAllergyInteraction(), ParameterCount -2, First Parameter- " + ClientId + "Second Parameter- " + StaffId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
            finally
            {
                objParam = null;
            }
        }

        #endregion

        /// <summary>
        /// Created by Chandan for UpdateClientScripts for re-print and re fax the prescriptions
        /// </summary>
        /// Date 024th March 2009
        /// <param name="ScriptId,DrugInformation,PharmacyId,OrderingMethod"></param>
        public void UpdateClientScripts(int ScriptId, string DrugInformation, int PharmacyId, char OrderingMethod)
        {
            SqlParameter[] _ParametersObject = null;
            try
            {
                _ParametersObject = new SqlParameter[4];
                _ParametersObject[0] = new SqlParameter("@ScriptId ", ScriptId);
                _ParametersObject[1] = new SqlParameter("@DrugInformation ", DrugInformation);
                _ParametersObject[2] = new SqlParameter("@PharmacyId", PharmacyId);
                _ParametersObject[3] = new SqlParameter("@OrderingMethod", OrderingMethod);
                SqlHelper.ExecuteDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_UpdateMedicationScript", _ParametersObject);
            }

            catch (Exception ex)
            {
                SqlTransactionObject.Rollback();
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - ssp_UpdateMedicationScript(), ParameterCount - 1, First Parameter- " + ScriptId + " second Parameter- " + DrugInformation + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
            finally
            {
                _ParametersObject = null;
            }
        }

        /// <summary>
        /// This function is used to Execute the StoredProcedure for Main Report
        /// <author>Sonia Dhamija </author>
        /// <Dated>Dec 20th 2007</Dated>
        /// </summary>
        /// <param name="_StoredProcedure"></param>
        /// <param name="_ClientId"></param>
        /// <returns></returns>
        public DataSet ExecuteStoredProcedureforMainReport(string _StoredProcedure, int _ClientID)
        {


            SqlParameter[] _sParam = null;
            DataSet _DataSetRdl = null;
            try
            {
                _sParam = new SqlParameter[1];
                _sParam[0] = new SqlParameter("@ClientId", _ClientID);
                _DataSetRdl = new DataSet();
                _DataSetRdl = SqlHelper.ExecuteDataset(_ConnectionString, _StoredProcedure, _sParam);
                return _DataSetRdl;
            }
            catch (Exception ex)
            {

                throw ex;
            }
            finally
            {
                _sParam = null;
                _DataSetRdl = null;

            }

        }

        /// <summary>
        /// This function is used to Execute the StoredProcedure for Sub Report of Client Medication Script
        /// <author>Sonia Dhamija </author>
        /// <Dated>Dec 20th 2007</Dated>
        /// </summary>
        /// <param name="_StoredProcedure"></param>
        /// <param name="_ClientId"></param>
        /// <returns></returns>
        public DataSet ExecuteStoredProcedureforSubReport(string _StoredProcedure, string _ClientMedicationScriptIDs)
        {
            SqlParameter[] _sParam = null;
            DataSet _DataSetRdl = null;
            try
            {
                _sParam = new SqlParameter[1];
                _sParam[0] = new SqlParameter("@ClientMedicationScriptIDs", _ClientMedicationScriptIDs);
                _DataSetRdl = new DataSet();
                _DataSetRdl = SqlHelper.ExecuteDataset(_ConnectionString, _StoredProcedure, _sParam);
                return _DataSetRdl;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                _sParam = null;
                _DataSetRdl = null;

            }

        }


        /// <summary>
        /// This function is used to get values from SystemReports table.
        /// <author>Rishu Chopra</author>
        /// <Dated>Jan 24th 2007</Dated>
        /// </summary>
        /// <param name="_StoredProcedure"></param>
        /// <param name="_ClientId"></param>
        /// <returns></returns>
        public DataSet GetSystemReports(string _ReportName)
        {
            SqlParameter[] _ParametersObject = null;
            try
            {
                _ParametersObject = new SqlParameter[1];
                _ParametersObject[0] = new SqlParameter("@ReportName", _ReportName);
                DataSet dsTemp = new DataSet();
                string[] _TableNames = { "SystemReports" };
                SqlHelper.FillDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_SCGetClientMedicationSystemReports", dsTemp, _TableNames, _ParametersObject);
                return dsTemp;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetSystemReports(),Parameter Count=1,First Parameter- " + _ReportName + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }

            return null;

        }


        /// <summary>
        /// This function is used to get values from PMPAuditTrails table.
        /// <author>Malathi Shiva</author>
        /// <Dated>July 17th 2018</Dated>
        /// </summary>
        /// <param name="_StoredProcedure"></param>
        /// <param name="_ClientId"></param>
        /// <returns></returns>
        public DataSet GetPMPReportURL(int PMPAuditTrailId, string ReportResponseXML)
        {
            SqlParameter[] _ParametersObject = null;
            try
            {
                _ParametersObject = new SqlParameter[2];
                _ParametersObject[0] = new SqlParameter("@PMPAuditTrailId", PMPAuditTrailId);
                _ParametersObject[1] = new SqlParameter("@ReportResponseXML", ReportResponseXML);
                DataSet dsTemp = new DataSet();
                string[] _TableNames = { "PMPAuditTrails", "PMPStaffAuthentications" };
                SqlHelper.FillDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_RxGetPMPClientReport", dsTemp, _TableNames, _ParametersObject);
                return dsTemp;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetPMPReportURL(),Parameter Count=1,First Parameter- " + PMPAuditTrailId + "Second Parameter- " + ReportResponseXML + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }

            return null;
        }



        /// <summary>
        /// This function is used to get unique Prescribers Ref to Task#128.
        /// <author>Loveena</author>
        /// <Dated>17-Dec-2008</Dated>
        /// </summary>        
        /// <param name="_ClientId"></param>
        /// <returns></returns>
        public DataSet GetUniquePrescribers(int _ClientId)
        {
            SqlParameter[] _ParametersObject = null;
            try
            {
                _ParametersObject = new SqlParameter[1];
                _ParametersObject[0] = new SqlParameter("@ClientId", _ClientId);
                DataSet dsTemp = new DataSet();
                string[] _TableNames = { "ClientMedications" };
                SqlHelper.FillDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_MMGetClientMedicationPrescribers", dsTemp, _TableNames, _ParametersObject);
                return dsTemp;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetUniquePrescribers(),Parameter Count=1,First Parameter- " + _ClientId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }

            return null;

        }

        /// <summary>
        /// This function is used to get unique Prescribers Ref to Task#92.
        /// <author>Loveena</author>
        /// <Dated>22-Dec-2008</Dated>
        /// </summary>        
        /// <param name="_ClientId"></param>
        /// <returns></returns>
        public DataSet GetPharmacies()
        {
            SqlParameter[] _ParametersObject = null;
            try
            {
                _ParametersObject = new SqlParameter[1];
                DataSet dsTemp = new DataSet();
                string[] _TableNames = { "Pharmacies" };
                SqlHelper.FillDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_MMGetPharmacies", dsTemp, _TableNames, _ParametersObject);
                return dsTemp;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetPharmacies(),Parameter Count=0,###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }

            return null;

        }

        /// <summary>
        /// This function is used to set Selected Values for PreferredPharmacies as Ref to Task#92.
        /// <author>Loveena</author>
        /// <Dated>23-Dec-2008</Dated>
        /// </summary>        
        /// <param name="_ClientId"></param>       
        /// <returns></returns>
        public DataSet GetClientPharmacies(int _ClientId, bool RequirePharamcies, string _PreferredPharmacy1, string _PreferredPharmacy2, string _PreferredPharmacy3)
        {
            SqlParameter[] _ParametersObject = null;
            try
            {
                _ParametersObject = new SqlParameter[5];
                _ParametersObject[0] = new SqlParameter("@ClientId", _ClientId);
                _ParametersObject[1] = new SqlParameter("@RequirePharamcies", RequirePharamcies == true ? 1 : 0);
                _ParametersObject[2] = new SqlParameter("@PreferredPharmacy1", _PreferredPharmacy1);
                _ParametersObject[3] = new SqlParameter("@PreferredPharmacy2", _PreferredPharmacy2);
                _ParametersObject[4] = new SqlParameter("@PreferredPharmacy3", _PreferredPharmacy3);
                DataSet dsTemp = new DataSet();
                string[] _TableNames = { "ClientPharmacies", "Pharmacies" };
                SqlHelper.FillDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_MMGetClientPharmacies", dsTemp, _TableNames, _ParametersObject);
                return dsTemp;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetClientPharmacies(), ParameterCount - 1,FirstParameter-" + _ClientId + " ###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }

        }

        /// <summary>
        /// This function is used to set all Pharmacies for Pharmacy Management.
        /// <author>Loveena</author>
        /// <Dated>03-April-2009</Dated>
        /// </summary>                
        public DataSet GetPharmaciesData()
        {
            try
            {
                DataSet dsTemp = new DataSet();
                string[] _TableNames = { "Pharmacies" };
                SqlHelper.FillDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_SCGetDataFromAllPharmacies", dsTemp, _TableNames);
                return dsTemp;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetClientPharmacies(), ParameterCount - 0  ###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }

        }

        public DataSet GetPrinterData()
        {
            try
            {
                DataSet dsTemp = new DataSet();
                string[] _TableNames = { "PrinterDeviceLocations" };
                SqlHelper.FillDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_SCGetDataFromAllPrinter", dsTemp, _TableNames);
                return dsTemp;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetClientPharmacies(), ParameterCount - 0  ###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }

        }

        /// <summary>
        /// This function is used to get Category of Drugs.
        /// <author>Rishu Chopra</author>
        /// <Dated>Feb 09th 2008</Dated>
        /// </summary>
        /// <param name="_StoredProcedure"></param>
        /// <param name="MedicationID"></param>
        /// <returns></returns>
        public DataSet C2C5Drugs(int _MedicationId)
        {
            SqlParameter[] _ParametersObject = null;
            try
            {
                _ParametersObject = new SqlParameter[1];
                _ParametersObject[0] = new SqlParameter("@MedicationId", _MedicationId);
                return SqlHelper.ExecuteDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_SCClientMedicationC2C5Drugs", _ParametersObject);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - C2C5Drugs(), ParameterCount - 1, First Parameter- " + _MedicationId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }

        }


        /// <summary>
        /// This function is used to get Category of Drugs.
        /// <author>Rishu Chopra</author>
        /// <Dated>Feb 09th 2008</Dated>
        /// </summary>
        /// <param name="_StoredProcedure"></param>
        /// <param name="MedicationID"></param>
        /// <returns></returns>
        public DataSet GetDrugCategory(int MedicationNameId)
        {
            SqlParameter[] _ParametersObject = null;
            try
            {
                _ParametersObject = new SqlParameter[1];
                _ParametersObject[0] = new SqlParameter("@MedicationNameId", MedicationNameId);
                return SqlHelper.ExecuteDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_GetDrugCategory", _ParametersObject);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetDrugCategory(), ParameterCount - 1, First Parameter- " + MedicationNameId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }

        }


        /// <summary>
        /// This function is used to get dataset of RDL.
        /// <author>Rishu Chopra</author>
        /// <Dated>Feb 12th 2008</Dated>
        /// </summary>
        /// <param name="_StoredProcedure"></param>
        /// <param name="GeneratedScriptId"></param>
        /// <returns></returns>
        public DataSet GetClientMedicationRDLDataSet(int _ClientMedicationScriptIds)
        {
            SqlParameter[] _ParametersObject = null;
            try
            {
                _ParametersObject = new SqlParameter[1];
                _ParametersObject[0] = new SqlParameter("@ClientMedicationScriptIds", _ClientMedicationScriptIds);
                return SqlHelper.ExecuteDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_SCGetClientMedicationScriptDatatry", _ParametersObject);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetClientMedicationRDLDataSet(), ParameterCount - 1, First Parameter- " + _ClientMedicationScriptIds + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }

        }


        /// <summary>
        /// Added by Sonia to Change the OrderStatus of Re-ordered Medications
        ///
        /// </summary>

        public int ChangeMedicationsOrderStatus(string MedicationidsToBeChanged, string MedicationidsToBeReorderd, string ModifiedBy)
        {
            SqlParameter[] parm;
            try
            {
                int retInt = 0;
                parm = new SqlParameter[3];
                parm[0] = new SqlParameter("@MedicationidsToBeChanged", MedicationidsToBeChanged);
                parm[1] = new SqlParameter("@MedicationidsToBeReorderd", MedicationidsToBeReorderd);
                parm[2] = new SqlParameter("@ModifiedBy", ModifiedBy);
                retInt = SqlHelper.ExecuteNonQuery(_ConnectionString, CommandType.StoredProcedure, "ssp_SCUpdateMedicationOrderStatus", parm);
                return retInt;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - ChangeMedicationsStatus(), ParameterCount - 2, First Parameter- " + MedicationidsToBeChanged + " Second Parameter- " + MedicationidsToBeReorderd + "Third Parameter-" + ModifiedBy + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
            finally
            {
                parm = null;
            }



        }


        /// <summary> 
        /// <author>Chandan Srivastava</author>
        /// <Dated>3rd Dec 2008</Dated>
        /// Task #85 MM 1.7 - Prescribe Window Changes
        /// </summary>
        /// <param name="DataSetDocumentsforUpdate"></param>
        /// <param name="_updatedOnce"></param>
        /// <returns></returns>
        public DataSet UpdateTempDocuments(DataSet DataSetClientMedication, bool _updatedOnce, string SessionId)
        {
            try
            {
                string _SelectQuery = "";
                int _TableCount;
                SqlParameter[] _ParametersObject = null;
                DataSet dsTemp = new DataSet();

                SqlConnectionObject = new SqlConnection(_ConnectionString);
                SqlConnectionObject.Open();
                SqlTransactionObject = SqlConnectionObject.BeginTransaction();

                //start: Code modified by Chandan in ref to Task# 133 1.7.3 - Change Order - ClientMedications and ClientMedicationInstructions
                if (DataSetClientMedication.Tables.Contains("ClientMedications"))
                {
                    if (DataSetClientMedication.Tables["ClientMedications"].Rows.Count > 0)
                    {
                        DataRow[] drClientMedications = DataSetClientMedication.Tables["ClientMedications"].Select("1=1");
                        foreach (DataRow dr in drClientMedications)
                        {
                            dr.AcceptChanges();
                            dr.SetAdded();
                        }
                    }
                }
                //end: Code modified by Chandan in ref to Task# 133 1.7.3 - Change Order - ClientMedications and ClientMedicationInstructions

                // to keep only those rows that have been changed
                DataSet dsAdded = DataSetClientMedication.GetChanges(DataRowState.Added);
                DataSet dsModified = DataSetClientMedication.GetChanges(DataRowState.Modified);
                DataSet dsDeleted = DataSetClientMedication.GetChanges(DataRowState.Deleted);
                DataSet dsUnchanged = DataSetClientMedication.GetChanges(DataRowState.Unchanged);
                DataSet dsUpdate = new DataSet();
                if (dsAdded != null)
                    dsUpdate.Merge(dsAdded);
                if (dsModified != null)
                    dsUpdate.Merge(dsModified);
                if (dsDeleted != null)
                    dsUpdate.Merge(dsDeleted);
                DataSetClientMedication = dsUpdate;

                #region "Code to create Temp tables"

                //SqlHelper.ExecuteNonQuery(_ConnectionString, CommandType.StoredProcedure, "ssp_DeleteTempTables", null);

                //Delete the Preview Tables record for current session 
                DeletePreviewTables(SessionId);


                //Rename tables in dataset to the temporary table names .
                int _Count = 0;
                DataSet DatasetClientMedications_Temp = DataSetClientMedication;
                for (_Count = 0; _Count < DatasetClientMedications_Temp.Tables.Count; _Count++)
                {
                    //if (DatasetClientMedications_Temp.Tables[_Count].TableName != "ClientAllergiesInteraction" && DatasetClientMedications_Temp.Tables[_Count].TableName != "ClientMedicationInteractions" && DatasetClientMedications_Temp.Tables[_Count].TableName != "ClientMedicationInteractionDetails")
                    //Modified By Anuj on & 7dec,2009 for task ref #18 SDI Venture 10
                    //Modified by Pushpita Date 9th Feb 2010
                    if (DatasetClientMedications_Temp.Tables[_Count].TableName != "ClientAllergiesInteraction"
                        && DatasetClientMedications_Temp.Tables[_Count].TableName != "ClientMedicationInteractions"
                        && DatasetClientMedications_Temp.Tables[_Count].TableName != "ClientMedicationInteractionDetails"
                        && DatasetClientMedications_Temp.Tables[_Count].TableName != "ClientMedicationConsents"
                        && DatasetClientMedications_Temp.Tables[_Count].TableName != "SureScriptsOutgoingMessages"
                        && DatasetClientMedications_Temp.Tables[_Count].TableName != "SurescriptsCancelRequests"
                        && DatasetClientMedications_Temp.Tables[_Count].TableName != "SureScriptsRefillRequests"
                        && DatasetClientMedications_Temp.Tables[_Count].TableName != "ClientMedicationData")
                    {
                        DatasetClientMedications_Temp.Tables[_Count].TableName =
                            DatasetClientMedications_Temp.Tables[_Count].TableName + "Preview";
                    }
                }

                #endregion



                for (_TableCount = 0; _TableCount <= DatasetClientMedications_Temp.Tables.Count - 1; _TableCount++)
                {
                    //if (DatasetClientMedications_Temp.Tables[_TableCount].TableName != "ClientAllergiesInteraction" && DatasetClientMedications_Temp.Tables[_TableCount].TableName != "ClientMedicationInteractions" && DatasetClientMedications_Temp.Tables[_TableCount].TableName != "ClientMedicationInteractionDetails")
                    //Modified by Anuj on 7 dec,2009 for task ref #18 SDI venture 10
                    //Modified By Pushpita Dated 9th Feb 2010
                    if (DatasetClientMedications_Temp.Tables[_TableCount].TableName != "ClientAllergiesInteraction"
                        && DatasetClientMedications_Temp.Tables[_TableCount].TableName != "ClientMedicationInteractions"
                        && DatasetClientMedications_Temp.Tables[_TableCount].TableName != "ClientMedicationInteractionDetails"
                        && DatasetClientMedications_Temp.Tables[_TableCount].TableName != "ClientMedicationConsents"
                        && DatasetClientMedications_Temp.Tables[_TableCount].TableName != "SureScriptsOutgoingMessages"
                        && DatasetClientMedications_Temp.Tables[_TableCount].TableName != "SurescriptsCancelRequests"
                        && DatasetClientMedications_Temp.Tables[_TableCount].TableName != "SureScriptsRefillRequests"
                        && DatasetClientMedications_Temp.Tables[_TableCount].TableName != "ClientMedicationData"
                        && DatasetClientMedications_Temp.Tables[_TableCount].TableName != "ClientMedicationScriptDispenseDaysPreview"
                        )
                    {
                        //_SelectQuery = "Select * from " + DatasetClientMedications_Temp.Tables[_TableCount];
                        _SelectQuery = Streamline.DataService.ApplicationCommonFunctions.GetSelectSQL(DatasetClientMedications_Temp.Tables[_TableCount]);
                        SqlCommand sqlSelectCommand;
                        sqlSelectCommand = new SqlCommand(_SelectQuery, SqlConnectionObject, SqlTransactionObject); // , transDiagnosis);


                        SqlDataAdapter _SqlDataAdapter = new SqlDataAdapter(sqlSelectCommand);
                        SqlCommandBuilder _SqlCommandBuilder = new SqlCommandBuilder(_SqlDataAdapter);
                        _SqlDataAdapter.InsertCommand = _SqlCommandBuilder.GetInsertCommand();
                        _SqlDataAdapter.UpdateCommand = _SqlCommandBuilder.GetUpdateCommand();
                        _SqlDataAdapter.InsertCommand.Transaction = SqlTransactionObject;
                        _SqlDataAdapter.UpdateCommand.Transaction = SqlTransactionObject;
                        if (DatasetClientMedications_Temp.Tables[_TableCount].TableName != "ClientMedicationInteractionDetails" && DatasetClientMedications_Temp.Tables[_TableCount].TableName != "ClientMedicationScripts")
                        {
                            _SqlDataAdapter.RowUpdated += new SqlRowUpdatedEventHandler(OnRowUpdated);
                        }
                        if (DatasetClientMedications_Temp.Tables[_TableCount].ToString() == "ClientMedicationInstructionsPreview")
                        {
                            _SqlDataAdapter.RowUpdated += new SqlRowUpdatedEventHandler(OnClientMedicationInstructionRowUpdated);
                        }
                        if (DatasetClientMedications_Temp.Tables[_TableCount].ToString() == "ClientMedicationScriptsPreview")
                        {
                            _SqlDataAdapter.RowUpdated += new SqlRowUpdatedEventHandler(OnClientScriptRowUpdated);
                        }
                        int _primaryKeyCount = 0;
                        System.Random r1 = new Random();
                        for (_primaryKeyCount = 0; _primaryKeyCount < DatasetClientMedications_Temp.Tables[_TableCount].Rows.Count; _primaryKeyCount++)
                        {
                            DatasetClientMedications_Temp.Tables[_TableCount].Rows[_primaryKeyCount][0] = r1.Next();
                            DatasetClientMedications_Temp.Tables[_TableCount].Rows[_primaryKeyCount]["RowIdentifier"] = System.Guid.NewGuid();
                        }
                        _SqlDataAdapter.Update(DatasetClientMedications_Temp.Tables[_TableCount]);

                    }
                }
                //dsTemp = SqlHelper.ExecuteDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_testTemp", _ParametersObject);


                SqlTransactionObject.Commit();

                //_ParametersObject = new SqlParameter[3];
                //_ParametersObject[0] = new SqlParameter("@ClientMedicationScriptIds", 1); //ScriptId);
                //_ParametersObject[1] = new SqlParameter("@OrderingMethod", 'P');//_OrderingMethod);
                //_ParametersObject[2] = new SqlParameter("@OriginalData", 0);
                //DataSet dstempTable = new DataSet();
                ////Commented by Chandan for testing
                ////return SqlHelper.ExecuteDataset(_ConnectionString, CommandType.StoredProcedure, _StoredProcedureName, _ParametersObject);
                //dstempTable = SqlHelper.ExecuteDataset(_ConnectionString, CommandType.StoredProcedure, "csp_RDLClientPrescriptionMain_temp", _ParametersObject);

                for (_Count = 0; _Count < DatasetClientMedications_Temp.Tables.Count; _Count++)
                {
                    //if (DatasetClientMedications_Temp.Tables[_Count].TableName != "ClientAllergiesInteraction" && DatasetClientMedications_Temp.Tables[_Count].TableName != "ClientMedicationInteractions" && DatasetClientMedications_Temp.Tables[_Count].TableName != "ClientMedicationInteractionDetails")
                    //Modified By Anuj on 7 Dec, 2009 for task ref #18 SDI venture 10
                    //Modified by pushpita date 9th Feb 2010
                    if (DatasetClientMedications_Temp.Tables[_Count].TableName != "ClientAllergiesInteraction" &&
                        DatasetClientMedications_Temp.Tables[_Count].TableName != "ClientMedicationInteractions" &&
                        DatasetClientMedications_Temp.Tables[_Count].TableName != "ClientMedicationInteractionDetails" &&
                        DatasetClientMedications_Temp.Tables[_Count].TableName != "ClientMedicationConsents" &&
                        DatasetClientMedications_Temp.Tables[_Count].TableName != "SureScriptsOutgoingMessages" &&
                        DatasetClientMedications_Temp.Tables[_Count].TableName != "SurescriptsCancelRequests" &&
                        DatasetClientMedications_Temp.Tables[_Count].TableName != "SureScriptsRefillRequests" &&
                        DatasetClientMedications_Temp.Tables[_Count].TableName != "ClientMedicationData")
                    {
                        DatasetClientMedications_Temp.Tables[_Count].TableName = DatasetClientMedications_Temp.Tables[_Count].TableName.Substring(0, DatasetClientMedications_Temp.Tables[_Count].TableName.IndexOf("Preview")).ToString();


                    }
                }
                if (dsUnchanged != null)
                    DatasetClientMedications_Temp.Merge(dsUnchanged);




                DatasetClientMedications_Temp.AcceptChanges();
                return DatasetClientMedications_Temp;

            }
            catch (Exception ex)
            {
                SqlTransactionObject.Rollback();
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - UpdateDocuments(), ParameterCount - 1, First Parameter- " + DataSetClientMedication + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
        }


        ////public DataSet UpdateTempDocumentsAccess()
        ////{
        ////    try
        ////    {

        ////        SqlConnectionObject = new SqlConnection(_ConnectionString);
        ////        SqlConnectionObject.Open();
        ////        SqlTransactionObject = SqlConnectionObject.BeginTransaction();
        ////    }
        ////    catch (SqlException sqlEx)
        ////    {
        ////        throw sqlEx;
        ////    }
        ////}
       /// <summary>
        /// Created by jyothi
        /// </summary>
        /// Date 21th sep 2018
        /// <param name="ClientMedicationIds"></param>
        public DataSet PostClientMedicationsPrescribe(DataTable ClientMedicationIds)
        {           
            SqlParameter[] _ParametersObject = null;

            try
            {
                _ParametersObject = new SqlParameter[1];
                _ParametersObject[0] = new SqlParameter("@ClientMedicationIds", SqlDbType.Structured);
                if (ClientMedicationIds != null)
                {
                    _ParametersObject[0].Value = ClientMedicationIds;
                }
               return SqlHelper.ExecuteDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_RxPostUpdateOrderedPrescription", _ParametersObject);               
            }
            catch (Exception ex)
            {
                SqlTransactionObject.Rollback();
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - PostClientMedicationsPrescribe(), ParameterCount - 1, First Parameter- " + ClientMedicationIds + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
            finally
            {
                _ParametersObject = null;
            }
        }
      
        /// <summary>
        /// Created by Chandan for Deleting the Preview tables according to Session Id
        /// </summary>
        /// Date 05th March 2009
        /// <param name="SessionId"></param>
        public void DeletePreviewTables(string SessionId)
        {
            SqlParameter[] _ParametersObject = null;
            try
            {
                _ParametersObject = new SqlParameter[1];
                _ParametersObject[0] = new SqlParameter("@SessionId ", SessionId);
                SqlHelper.ExecuteDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_DeleteTempTables", _ParametersObject);
            }

            catch (Exception ex)
            {
                SqlTransactionObject.Rollback();
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - DeletePreviewTables(), ParameterCount - 1, First Parameter- " + SessionId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
            finally
            {
                _ParametersObject = null;
            }
        }


        /// <summary>
        /// Created by Chandan for Deleting the Preview tables according to Session Id
        /// </summary>
        /// Date 05th March 2009
        /// <param name="SessionId"></param>
        public void DeleteInteractions(string MedicationInteractionIds)
        {
            SqlParameter[] _ParametersObject = null;
            try
            {
                _ParametersObject = new SqlParameter[1];
                _ParametersObject[0] = new SqlParameter("@MedicationInteractionIds ", MedicationInteractionIds);
                SqlHelper.ExecuteDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_DeleteMedicationInteractions", _ParametersObject);
            }

            catch (Exception ex)
            {
                SqlTransactionObject.Rollback();
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - DeleteInteractions(), ParameterCount - 1, First Parameter- " + MedicationInteractionIds + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
            finally
            {
                _ParametersObject = null;
            }
        }

        /// <summary>
        /// <Description>Get PatientEducationMonographId on the basis of ClientMedicationId</Description>
        /// <Task>#2465</Task>
        /// <Author>Loveena</Author>
        /// <CreationDate>07-May-2009</CreationDate>
        /// </summary>
        /// <param name="MedicationIds"></param>
        /// <returns></returns>
        public DataSet GetPatientMonographId(string MedicationIds)
        {
            SqlParameter[] _ParametersObject = null;
            try
            {
                _ParametersObject = new SqlParameter[1];
                _ParametersObject[0] = new SqlParameter("@ClientMedicationId", MedicationIds);
                return SqlHelper.ExecuteDataset(_ConnectionString, CommandType.StoredProcedure, "scsp_MMGetPatientMonographId", _ParametersObject);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetPatientMonographId(), ParameterCount - 1, First Parameter- " + MedicationIds + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
        }
        /// <summary>
        /// <Description>Get PatientEducationMonographFormatedText on the basis of PatientEducationMonographId</Description>
        /// <Task>#2465</Task>
        /// <Author>Loveena</Author>
        /// <CreationDate>07-May-2009</CreationDate>
        /// </summary>
        /// <param name="PatientEducationMonographId"></param>
        /// <returns></returns>
        public DataSet GetPatientEducationMonographSideEffects(Int32 PatientEducationMonographId)
        {
            SqlParameter[] _ParametersObject = null;
            try
            {
                _ParametersObject = new SqlParameter[1];
                _ParametersObject[0] = new SqlParameter("@PatientEducationMonographId", PatientEducationMonographId);
                return SqlHelper.ExecuteDataset(_ConnectionString, CommandType.StoredProcedure, "scsp_MMPatientEducationMonographSideEffects", _ParametersObject);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetPatientEducationMonographSideEffects(), ParameterCount - 1, First Parameter- " + PatientEducationMonographId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
        }

        public DataSet GetDataForHarborStandardConsentRdlC(string _StoredProcedureName, int ClientId, string ClientMedicationId, int DocumentVersionId)
        {
            SqlParameter[] _ParametersObject = null;
            try
            {
                if (_StoredProcedureName == "csp_RDLMedicationInstructions")
                {
                    _ParametersObject = new SqlParameter[2];
                    _ParametersObject[0] = new SqlParameter("@ClientMedicationId", ClientMedicationId);
                    _ParametersObject[1] = new SqlParameter("@ClientId", ClientId);
                }
                else if (_StoredProcedureName == "csp_RDLHarborConsentElectronicSignature")
                {
                    _ParametersObject = new SqlParameter[1];
                    _ParametersObject[0] = new SqlParameter("@DocumentVersionId", DocumentVersionId);
                }
                else if (_StoredProcedureName == "csp_GetPharmacynames")
                {
                    _ParametersObject = new SqlParameter[2];
                    _ParametersObject[0] = new SqlParameter("@ClientMedicationId", ClientMedicationId);
                    _ParametersObject[1] = new SqlParameter("@ClientId", ClientId);
                }
                else if (_StoredProcedureName == "csp_RDLSubReportSignatureImages") // Implementing custom signature sub-report for Thresholds.  Feb 8 2013.  Chuck Blaine.  Task# 2612
                {
                    _ParametersObject = new SqlParameter[1];
                    _ParametersObject[0] = new SqlParameter("@DocumentVersionId", DocumentVersionId);
                }
                else
                {
                    _ParametersObject = new SqlParameter[1];
                    _ParametersObject[0] = new SqlParameter("@ClientMedicationId", ClientMedicationId);
                }

                //Commented by Chandan for testing
                return SqlHelper.ExecuteDataset(_ConnectionString, CommandType.StoredProcedure, _StoredProcedureName, _ParametersObject);
                //return SqlHelper.ExecuteDataset(_ConnectionString, CommandType.StoredProcedure, "csp_RDLClientPrescriptionMain_temp", _ParametersObject);


            }
            catch (Exception ex)
            {

                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetDataForHarborStandardConsentRdlC(), ParameterCount - 3, First Parameter- " + _StoredProcedureName + ",Second Paramenter- " + ClientId + "Third Parameter- " + ClientMedicationId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);

            }

        }


        //Added in ref to Task#2604
        public DataSet GetDataForPrescriberRdlC(string _StoredProcedureName, int PrescriberId, string LastReviewTime, string CurrentServerTime)
        {
            SqlParameter[] _ParametersObject = null;
            try
            {
                //if (_StoredProcedureName == "ssp_SCGetClientMedicationForPrescriber")
                //{
                //    _ParametersObject = new SqlParameter[3];
                //    _ParametersObject[0] = new SqlParameter("@PrescriberId", PrescriberId);
                //    _ParametersObject[1] = new SqlParameter("@LastReviewTime", LastReviewTime);
                //    _ParametersObject[2] = new SqlParameter("@ServerTime", CurrentServerTime);
                //}

                DataSet ds = new DataSet();
                SqlConnection conn = new SqlConnection(_ConnectionString);
                SqlDataAdapter da = new SqlDataAdapter();
                SqlCommand cmd = conn.CreateCommand();

                if (_StoredProcedureName == "ssp_SCGetClientMedicationForPrescriber")
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = _StoredProcedureName;
                    cmd.Parameters.AddWithValue("@PrescriberId", PrescriberId);
                    cmd.Parameters.AddWithValue("@LastReviewTime", LastReviewTime);
                    cmd.Parameters.AddWithValue("@ServerTime", CurrentServerTime);
                    cmd.CommandTimeout = 500;
                    da.SelectCommand = cmd;
                    conn.Open();
                    da.Fill(ds);
                    conn.Close();

                }
                return ds;
                //Commented by Chandan for testing
                //return SqlHelper.ExecuteDataset(_ConnectionString, CommandType.StoredProcedure, _StoredProcedureName, _ParametersObject);
                //return SqlHelper.ExecuteDataset(_ConnectionString, CommandType.StoredProcedure, "csp_RDLClientPrescriptionMain_temp", _ParametersObject);


            }
            catch (Exception ex)
            {

                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetDataForPrescriberRdlC(), ParameterCount - 1, First Parameter- " + _StoredProcedureName + ",Second Paramenter- " + PrescriberId + "Third Parameter- " + LastReviewTime + "Fourth Parameter- " + CurrentServerTime + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);

            }

        }
        /// <summary>
        /// <Description>Used to get client consent history data as per task#16 </Description>
        /// <author>Pradeep</author>
        /// <CreatedOn>Oct 28,2009</CreatedOn>
        /// </summary>
        /// <param name="ClientId"></param>
        /// <returns></returns>
        public DataSet DownloadClientConsentHistory(Int64 ClientId)
        {
            SqlParameter[] objParam;
            try
            {
                DataSet dsTemp;
                dsTemp = new DataSet();
                objParam = new SqlParameter[1];
                objParam[0] = new SqlParameter("@ClientId", ClientId);

                string[] _TableNames = { "ClientMedications", "ClientMedicationInstructions" };
                SqlHelper.FillDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_SCGetClientConsentHistoryList", dsTemp, _TableNames, objParam);
                return dsTemp;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - DownloadClientConsentHistory(), ParameterCount -1, First Parameter- " + ClientId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);

            }
            finally
            {
                objParam = null;
            }
        }

        #region--Code written by Pradeep as per task#15Venture
        /// <summary>
        /// <Decription>Used to get titration template data from database</Decription>
        /// <Author>Pradeep</Author>
        /// <CreatedOn>Nov 12,2009</CreatedOn>
        /// </summary>
        /// <param name="medicationNameId"></param>
        /// <returns></returns>
        public DataSet GetTitrationTemplateData(int medicationNameId)
        {
            SqlParameter[] _ParametersObject = null;
            DataSet _DataSetTitrationTemplate = null;
            try
            {
                _ParametersObject = new SqlParameter[1];
                _ParametersObject[0] = new SqlParameter("@MedicationNameId", medicationNameId);
                _DataSetTitrationTemplate = SqlHelper.ExecuteDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_SCGetTitrationTemplate", _ParametersObject);
                if (_DataSetTitrationTemplate != null)
                {
                    if (_DataSetTitrationTemplate.Tables.Count > 0)
                    {
                        _DataSetTitrationTemplate.Tables[0].TableName = "TitrationTemplates";
                    }
                    if (_DataSetTitrationTemplate.Tables.Count > 1)
                    {
                        _DataSetTitrationTemplate.Tables[1].TableName = "TitrationTemplateInstructions";
                    }
                }
                return _DataSetTitrationTemplate;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetTitrationTemplateData(int medicationNameId ), ParameterCount - 1, First Parameter- " + medicationNameId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
            finally
            {
                if (_DataSetTitrationTemplate != null)
                {
                    _DataSetTitrationTemplate.Dispose();
                }
            }
        }
        #endregion
        /// <summary>
        /// <Decription>Used to get titration template Name  from database</Decription>
        /// <Author>Anuj</Author>
        /// <CreatedOn>Nov 14,2009</CreatedOn>
        /// </summary>
        /// <param name="medicationNameId"></param>
        /// <returns></returns>

        public string SelectTemplateName(string TitrationTemplateName)
        {
            SqlParameter[] _ParametersObject = null;
            //DataSet _DataSetTitrationTemplate = null;
            string isTemplateNameExist = string.Empty;
            int i;
            try
            {
                _ParametersObject = new SqlParameter[1];
                _ParametersObject[0] = new SqlParameter("@TitrationTemplateName", TitrationTemplateName);
                i = Convert.ToInt32(SqlHelper.ExecuteScalar(_ConnectionString, CommandType.StoredProcedure, "ssp_SCGetTitrationTemplateName", _ParametersObject));
                if (i == 1)
                {
                    isTemplateNameExist = "Y";
                }
                else if (i == 2)
                {
                    isTemplateNameExist = "N";
                }
                return isTemplateNameExist;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - SelectTemplateName(string TitrationTemplateName ), ParameterCount - 1, First Parameter- " + TitrationTemplateName + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
            finally
            {
            }
        }
        #region--Code written By Pradeep as per task#32
        /// <summary>
        /// <Description>Used to update PermithangesByOtherUsers field in ClientMedication table against passed clientMedicationId </Description>
        /// <Author>Pradeep</Author>
        /// <CreatedOn>Nov 25,2009</CreatedOn>
        /// </summary>
        /// <param name="ClientMedicationId"></param>
        /// <param name="PermithangesByOtherUsers"></param>
        /// <param name="ModifiedBy"></param>
        /// <returns></returns>
        public int SavePermitChangesByOtherUsers(int ClientMedicationId, char PermithangesByOtherUsers, string ModifiedBy)
        {
            SqlParameter[] parm;
            try
            {
                int retInt = 0;
                parm = new SqlParameter[3];
                parm[0] = new SqlParameter("@ClientMedicationId", ClientMedicationId);
                parm[1] = new SqlParameter("@PermitChangesByOtherUsers", PermithangesByOtherUsers);
                parm[2] = new SqlParameter("@ModifiedBy", ModifiedBy);
                retInt = SqlHelper.ExecuteNonQuery(_ConnectionString, CommandType.StoredProcedure, "[ssp_SCUpdatePermitChangesByOtherUsers]", parm);
                return retInt;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name -SavePermitChangesByOtherUsers, ParameterCount - 3, First Parameter- " + ClientMedicationId + " Second Parameter- " + PermithangesByOtherUsers + " Third Parameter- " + ModifiedBy + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
        }
        #endregion

        /// <summary>
        /// <Decription>Used to get the data for HealthDataList (task ref # 34 SDI-Venture 10</Decription>
        /// <Author>Anuj</Author>
        /// <CreatedOn>Nov 25,2009</CreatedOn>
        /// </summary>
        /// <param name="medicationNameId"></param>
        /// <returns></returns>

        public DataSet GetHeathDataListRecords(int ClientId, int HealthDataCategoryId)
        {
            SqlParameter[] _ParametersObject = null;
            try
            {
                _ParametersObject = new SqlParameter[2];
                DataSet dsTemp = new DataSet();
                string[] _TableNames = { "HealthDataList", "HealthDataListHeader", "HealthData" };
                _ParametersObject[0] = new SqlParameter("@ClientId", ClientId);
                _ParametersObject[1] = new SqlParameter("@HealthDataCategoryId", HealthDataCategoryId);
                SqlHelper.FillDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_HealthDataList", dsTemp, _TableNames, _ParametersObject);
                return dsTemp;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetHeathDataListRecords(int ClientId, int HealthDataCategoryId ), ParameterCount - 2, First Parameter- " + ClientId + "Second Parameter-" + HealthDataCategoryId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
            finally
            {
            }
        }

        /// <summary>
        /// <Decription>Used to get the data for HealthDataAlerts</Decription>
        /// <CreatedOn>Oct 24,2014</CreatedOn>
        /// </summary>
        public DataSet GetHealthMaintenaceAlertData(int ClientId, int StaffId)
        {
            SqlParameter[] _ParametersObject = null;
            try
            {
                _ParametersObject = new SqlParameter[2];
                DataSet dsTemp = new DataSet();
                string[] _TableNames = { "HMTemplateDetails", "HMAlertCount", "HMCriteriaDetails" };
                _ParametersObject[0] = new SqlParameter("@ClientId", ClientId);
                _ParametersObject[1] = new SqlParameter("@StaffId", StaffId);
                SqlHelper.FillDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_getHealthMaintenaceAlertData", dsTemp, _TableNames, _ParametersObject);
                return dsTemp;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetHealthMaintenaceAlertData(int ClientId, int StaffId ), ParameterCount - 2, First Parameter- " + ClientId + "Second Parameter-" + StaffId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
            finally
            {
            }
        }

        public DataTable GetGrowthChartCategories(int clientId)
        {
            SqlParameter[] _ParametersObject = null;
            try
            {
                _ParametersObject = new SqlParameter[1];
                DataSet dsTemp = new DataSet();
                string[] _TableNames = { "GrowthChartCategory" };
                _ParametersObject[0] = new SqlParameter("@ClientId", clientId);
                SqlHelper.FillDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_GrowthChartCategoriesDropDownList", dsTemp, _TableNames, _ParametersObject);
                return dsTemp.Tables["GrowthChartCategory"];
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetGrowthChartData(int ClientId,string growthchartvalue), ParameterCount - 1, First Parameter- " + clientId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }

        }

        public DataSet GetGrowthChartData(int clientId, int graphType)
        {
            SqlParameter[] _ParametersObject = null;
            try
            {
                _ParametersObject = new SqlParameter[2];
                DataSet dsTemp = new DataSet();
                string[] _TableNames = { "GrowthChartClient", "GrowthChartData" };
                _ParametersObject[0] = new SqlParameter("@ClientId", clientId);
                _ParametersObject[1] = new SqlParameter("@GraphType", graphType);
                SqlHelper.FillDataset(_ConnectionString, CommandType.StoredProcedure, "csp_GrowthChartData", dsTemp, _TableNames, _ParametersObject);
                return dsTemp;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetGrowthChartData(int clientId, int graphType), ParameterCount - 2, First Parameter- " + clientId + ", Second Parameter- " + graphType + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }
        }

        /// <summary>
        /// <Decription>Used to Bind HealthData DropDown (task ref # 34 SDI-Venture 10</Decription>
        /// <Author>Anuj</Author>
        /// <CreatedOn>Nov 25,2009</CreatedOn>
        /// </summary>
        /// <param name="medicationNameId"></param>
        /// <returns></returns>

        public DataSet GetHeathDataCategories(int ClientId)
        {
            SqlParameter[] _ParametersObject = null;
            try
            {
                _ParametersObject = new SqlParameter[1];
                DataSet dsTemp = new DataSet();
                string[] _TableNames = { "HealthDataCategory" };
                _ParametersObject[0] = new SqlParameter("@ClientId", ClientId);
                SqlHelper.FillDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_HealthDataCategoriesDropDownList", dsTemp, _TableNames, _ParametersObject);
                return dsTemp;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetHeathDataCategories(int ClientId), ParameterCount - 1, First Parameter- " + ClientId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
            finally
            {
            }
        }

        /// <summary>
        /// <Decription>Used to Delete the HealthData Record (task ref # 34 SDI-Venture 10</Decription>
        /// <Author>Anuj</Author>
        /// <CreatedOn>Nov 26,2009</CreatedOn>
        /// </summary>
        /// <param name="medicationNameId"></param>
        /// <returns></returns>

        public int DeleteHeathDataRecord(int HealthDataId, string DeletedBy)
        {
            SqlParameter[] _ParametersObject = null;
            try
            {
                int retInt = 0;
                _ParametersObject = new SqlParameter[2];
                _ParametersObject[0] = new SqlParameter("@HealthDataId", HealthDataId);
                _ParametersObject[1] = new SqlParameter("@DeletedBy", DeletedBy);
                retInt = SqlHelper.ExecuteNonQuery(_ConnectionString, CommandType.StoredProcedure, "ssp_SCDeleteHealthData", _ParametersObject);
                return retInt;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - DeleteHeathDataRecord(int HealthDataId), ParameterCount - 1, First Parameter- " + HealthDataId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
            finally
            {
            }
        }
        /// <summary>
        /// <Decription>Used to Bind HealthDataGraphDropDown (task ref # 34 SDI-Venture 10</Decription>
        /// <Author>Anuj</Author>
        /// <CreatedOn>Nov 27,2009</CreatedOn>
        /// </summary>
        /// <param name="medicationNameId"></param>
        /// <returns></returns>

        public DataSet GetHeathDataGraphDropDown(int ClientId)
        {
            SqlParameter[] _ParametersObject = null;
            try
            {
                _ParametersObject = new SqlParameter[1];
                DataSet dsTemp = new DataSet();
                string[] _TableNames = { "HealthDataListGraph" };
                _ParametersObject[0] = new SqlParameter("@ClientId", ClientId);
                SqlHelper.FillDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_HealthDataCategoriesGraphDropDownList", dsTemp, _TableNames, _ParametersObject);
                return dsTemp;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetHeathDataGraphDropDown(int ClientId), ParameterCount - 1, First Parameter- " + ClientId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
            finally
            {
            }
        }

        //Code added by Mohit Madaan in ref to Task#3
        public DataSet GetVerbalOrderReviewData(int StaffId, string OrderType)
        {
            SqlParameter[] _ParametersObject = null;
            try
            {
                _ParametersObject = new SqlParameter[2];
                DataSet dsTemp = new DataSet();
                string[] _TableNames = { "ClientMedicationScripts" };
                _ParametersObject[0] = new SqlParameter("@StaffId", StaffId);
                _ParametersObject[1] = new SqlParameter("@OrderType", OrderType);
                SqlHelper.FillDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_SCGetVerbalOrderReviewData", dsTemp, _TableNames, _ParametersObject);
                return dsTemp;
            }

            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetMedicationOrderDetails(), ParameterCount - 1, First Parameter- " + StaffId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }


        }
        /// <summary>
        /// <Decription>Used to get the record from Signature table (task ref # 18 SDI-Venture 10</Decription>
        /// <Author>Anuj</Author>
        /// <CreatedOn>Dec 1,2009</CreatedOn>
        /// </summary>
        /// <param name="medicationNameId"></param>
        /// <returns></returns>
        /// 
        //public DataSet GetSignatureStatusRecord(int ClientMedicationId)
        public DataSet GetSignatureStatusRecord(int ClientMedicationConsentId)
        {
            SqlParameter[] _ParametersObject = null;
            try
            {
                _ParametersObject = new SqlParameter[1];
                DataSet dsTemp = new DataSet();
                string[] _TableNames = { "SignatureStatusRecord" };
                //_ParametersObject[0] = new SqlParameter("@ClientMedicationId", ClientMedicationId);
                _ParametersObject[0] = new SqlParameter("@ClientMedicationConsentId", ClientMedicationConsentId);
                SqlHelper.FillDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_SCGetSignatureStatusRecord", dsTemp, _TableNames, _ParametersObject);
                return dsTemp;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetSignatureStatusRecord(int ClientMedicationId), ParameterCount - 1, First Parameter- " + ClientMedicationConsentId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
            finally
            {
            }
        }
        #region--Code Written By Pradeep as per task#1
        /// <summary>
        /// <Description>Used to get data for Discontinued RDLC against passed parameters</Description>
        /// <Author>Pradeep</Author>
        /// <CreatedOn>2 Dec,2009</CreatedOn>
        /// </summary>
        /// <param name="_StoredProcedureName"></param>
        /// <param name="ClientMedicationId"></param>
        /// <param name="Method"></param>
        /// <param name="InitiatedBy"></param>
        /// <param name="PharmacyId"></param>
        /// <returns></returns>
        public DataSet GetDataForDisContinueRdlC(string _StoredProcedureName, int ClientMedicationId, string Method, int InitiatedBy, int PharmacyId)
        {
            SqlParameter[] _ParametersObject = null;
            try
            {
                if (_StoredProcedureName == "csp_RDLDiscontinueMedicationNotice")
                {
                    _ParametersObject = new SqlParameter[4];
                    _ParametersObject[0] = new SqlParameter("@ClientMedicationId", ClientMedicationId);
                    _ParametersObject[1] = new SqlParameter("@Method", Method);
                    _ParametersObject[2] = new SqlParameter("@InitiatedBy", InitiatedBy);
                    if (PharmacyId != 0)
                    {
                        _ParametersObject[3] = new SqlParameter("@PharmacyId", PharmacyId);
                    }
                    else
                    {
                        _ParametersObject[3] = new SqlParameter("@PharmacyId", DBNull.Value);
                    }

                }
                return SqlHelper.ExecuteDataset(_ConnectionString, CommandType.StoredProcedure, _StoredProcedureName, _ParametersObject);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - public DataSet GetDataForDisContinueRdlC(string _StoredProcedureName, int ClientMedicationId, string Method, int InitiatedBy, int PharmacyId), ParameterCount - 5, First Parameter- " + ClientMedicationId + "Second Parameter-" + ClientMedicationId.ToString() + "Third Parameter-" + Method.ToString() + "Fourth Parameter-" + InitiatedBy.ToString() + "Fifth Parameter-" + PharmacyId.ToString() + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
        }
        #endregion
        /// <summary>
        /// <Decription>Updating ClientMedicationConsentDocuments (task ref # 18 SDI-Venture 10</Decription>        
        /// <CreatedOn>Dec 20,2009</CreatedOn>
        /// </summary>
        /// <param name="medicationNameId"></param>
        /// <returns></returns>
        /// 
        public int UpdateClientMedicationConsentDocuments(int ClientMedicationConsentId, string ModifiedBy)
        {
            SqlParameter[] _ParametersObject = null;
            try
            {
                int retInt = 0;
                _ParametersObject = new SqlParameter[2];
                _ParametersObject[0] = new SqlParameter("@ClientMedicationConsentId", ClientMedicationConsentId);
                _ParametersObject[1] = new SqlParameter("ModifiedBy", ModifiedBy);
                retInt = SqlHelper.ExecuteNonQuery(_ConnectionString, CommandType.StoredProcedure, "ssp_SCUpdateClientMedicationConsentDocument", _ParametersObject);
                return retInt;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - UpdateClientMedicationConsentDocuments(int ClientMedicationId,string ModifiedBy), ParameterCount - 1, First Parameter- " + ClientMedicationConsentId + " , Second Parameter- " + ModifiedBy + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
            finally
            {
            }
        }
        /// <summary>
        /// <Decription>Will Ger the DocumentVersionIds (task ref # 18 SDI-Venture 10</Decription>        
        /// <CreatedOn>Dec 20,2009</CreatedOn>
        /// </summary>
        /// <param name="medicationNameId"></param>
        /// <returns></returns>
        /// 
        public DataSet GetDocumentVersionId(int DocumentId)
        {
            SqlParameter[] _ParametersObject = null;
            try
            {
                _ParametersObject = new SqlParameter[1];
                DataSet dsTemp = new DataSet();
                string[] _TableNames = { "DocumentVersionIds" };
                _ParametersObject[0] = new SqlParameter("@DocumentId", DocumentId);
                SqlHelper.FillDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_SCGetDocumetVersionId", dsTemp, _TableNames, _ParametersObject);
                return dsTemp;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetDocumentVersionId(int DocumentId), ParameterCount - 1, First Parameter- " + DocumentId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
            finally
            {
            }
        }
        /// <summary>
        /// <Decription>Used to Update ClientMedicationConsentDocument if the consent happens for checkboxes</Decription>        
        /// <CreatedOn>Dec 20,2009</CreatedOn>
        /// </summary>
        /// <param name="medicationNameId"></param>
        /// <returns></returns>
        /// 
        public int UpdateMultipleClientMedicationConsentDocuments(int DocumentVersionId, string ModifiedBy)
        {
            SqlParameter[] _ParametersObject = null;
            try
            {
                int retInt = 0;
                _ParametersObject = new SqlParameter[2];
                _ParametersObject[0] = new SqlParameter("@DocumentVersionId", DocumentVersionId);
                _ParametersObject[1] = new SqlParameter("ModifiedBy", ModifiedBy);
                retInt = SqlHelper.ExecuteNonQuery(_ConnectionString, CommandType.StoredProcedure, "ssp_SCUpdateMultipleClientMedicationConsentDocument", _ParametersObject);
                return retInt;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - UpdateMultipleClientMedicationConsentDocuments(int DocumentVersionId,string ModifiedBy), ParameterCount - 1, First Parameter- " + DocumentVersionId + " , Second Parameter- " + ModifiedBy + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
            finally
            {
            }
        }
        /// <summary>
        /// <Decription>Will Get all the clientMedicationID of same versionId for Passed ClientMedicationID(task ref # 18 SDI-Venture 10</Decription>        
        /// <CreatedOn>Dec 22,2009</CreatedOn>
        /// </summary>
        /// <param name=ClientMedicationId></param>
        /// <returns></returns>
        /// 
        //public DataSet GetClientMedicationIds(int ClientMedicationId)
        public DataSet GetClientMedicationIds(int ClientMedicationConsentId, int ClientId)
        {
            SqlParameter[] _ParametersObject = null;
            try
            {
                _ParametersObject = new SqlParameter[2];
                DataSet dsTemp = new DataSet();
                string[] _TableNames = { "TableClientMedicationId" };
                _ParametersObject[0] = new SqlParameter("@ClientMedicationConsentId", ClientMedicationConsentId);
                _ParametersObject[1] = new SqlParameter("@ClientId", ClientId);
                SqlHelper.FillDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_SCGetAllClientMedicationId", dsTemp, _TableNames, _ParametersObject);
                return dsTemp;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetClientMedicationIds(int ClientMedicationId), ParameterCount - 1, First Parameter- " + ClientMedicationConsentId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
            finally
            {
            }
        }
        //Getting latest version id
        public DataSet GetClientMedicationversionId(int ClientMedicationConsentId)
        {
            SqlParameter[] _ParametersObject = null;
            try
            {
                _ParametersObject = new SqlParameter[1];
                DataSet dsTemp = new DataSet();
                string[] _TableNames = { "DocumentVersionId", "ClientMedicationInstructions" };
                _ParametersObject[0] = new SqlParameter("@ClientMedicationConsentId", ClientMedicationConsentId);
                SqlHelper.FillDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_SCGetConsentDocumentVersionId", dsTemp, _TableNames, _ParametersObject);
                return dsTemp;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetClientMedicationversionId(int ClientMedicationConsentId), ParameterCount - 1, First Parameter- " + ClientMedicationConsentId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
            finally
            {
            }
        }

        /// <summary>
        /// Loveena
        /// it is used to fill Drug DropDown.
        /// </summary>
        /// <returns></returns>
        public DataSet FillDrugDropDown(int medicationId)
        {
            SqlParameter[] _ParametersObject = null;
            try
            {
                _ParametersObject = new SqlParameter[1];
                _ParametersObject[0] = new SqlParameter("@MedicationNameId", medicationId);
                return SqlHelper.ExecuteDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_MMGetAlternativeMedicationNames", _ParametersObject);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - FillDrugDropDown(), ParameterCount - 1, First Parameter- " + medicationId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }

        }

        /// <summary>
        /// <Decription>Used to Get HealthData Item  for a Client </Decription>
        /// <Author>Chandan </Author>
        /// <CreatedOn>Feb 04 2010</CreatedOn>
        /// </summary>
        /// <param name="medicationNameId"></param>
        /// <returns></returns>

        public DataSet GetHeathDataGraphItems(int ClientId, int HealthDataCategoryId)
        {
            SqlParameter[] _ParametersObject = null;
            try
            {
                _ParametersObject = new SqlParameter[2];
                DataSet dsTemp = new DataSet();
                string[] _TableNames = { "HealthDataListGraph" };
                _ParametersObject[0] = new SqlParameter("@ClientId", ClientId);
                _ParametersObject[1] = new SqlParameter("@HealthDataCategoryId", HealthDataCategoryId);

                SqlHelper.FillDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_HealthDataCategoriesItems", dsTemp, _TableNames, _ParametersObject);
                return dsTemp;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetHeathDataGraphItems(int ClientId), ParameterCount - 1, First Parameter- " + ClientId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
            finally
            {
            }
        }

        /// <summary>
        /// <CreatedBy>Loveena</CreatedBy>
        /// <Purpose>Ref to Task#2802</Purpose>
        /// </summary>
        /// <param name="MedicationId"></param>
        /// <returns></returns>
        public DataSet CalculateAutoCalcAllow(int MedicationId)
        {
            SqlParameter[] _ParametersObject = null;
            try
            {
                _ParametersObject = new SqlParameter[1];
                _ParametersObject[0] = new SqlParameter("@MedicationId", MedicationId);
                return SqlHelper.ExecuteDataset(_ConnectionString, CommandType.StoredProcedure, "scsp_MMStrengthAllowsAutoCalculation", _ParametersObject);
            }
            catch (Exception ex)
            {


                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - CalculateAutoCalcAllow(), ParameterCount - 1, First Parameter- " + MedicationId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);

            }
        }

        /// <summary>
        /// <CreatedBy>Loveena</CreatedBy>
        /// <Purpose>Ref to Task#2905</Purpose>
        /// </summary>
        /// <param name="MedicationId"></param>
        /// <returns></returns>
        public DataSet CalculateDispenseQuantity(int MedicationId, float dosage, string schedule, int days)
        {
            SqlParameter[] _ParametersObject = null;
            try
            {
                _ParametersObject = new SqlParameter[4];
                _ParametersObject[0] = new SqlParameter("@MedicationId", MedicationId);
                _ParametersObject[1] = new SqlParameter("@Dosage", dosage);
                _ParametersObject[2] = new SqlParameter("@Schedules", schedule);
                _ParametersObject[3] = new SqlParameter("@Days", days);
                return SqlHelper.ExecuteDataset(_ConnectionString, CommandType.StoredProcedure, "scsp_MMCalculateDispenseQuantity", _ParametersObject);
            }
            catch (Exception ex)
            {


                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - CalculateDispenseQuantity(), ParameterCount - 4, First Parameter- " + MedicationId + ",Second Parameter- " + dosage + ",Third Parameter- " + schedule + ",Fourth Parameter- " + days + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);

            }
        }
        /// <summary>
        /// Added By Anuj Tomar TO revoke the Medication Consent
        /// </summary>
        /// <param name="DocumentVersionId"></param>
        /// <param name=""></param>
        /// <param name="ModifiedBy"></param>
        /// <returns>int</returns>      
        public int RevokeMedication(string SignedBy, int DocumentVersionId, string ModifiedBy)
        {
            SqlParameter[] parm;
            try
            {
                int retInt = 0;
                parm = new SqlParameter[3];
                parm[0] = new SqlParameter("@SignedBy", SignedBy);
                parm[1] = new SqlParameter("@DocumentVersionId", DocumentVersionId);
                parm[2] = new SqlParameter("@ModifiedBy", ModifiedBy);
                retInt = SqlHelper.ExecuteNonQuery(_ConnectionString, CommandType.StoredProcedure, "ssp_SCRevokeMedicationConsent", parm);
                return retInt;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - DiscontinueMedication(), ParameterCount - 2, First Parameter- " + DocumentVersionId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
            finally
            {
                parm = null;
            }
        }
        /// <summary>
        /// Anuj Tomar
        /// Added By Anuj Tomar TO get the Dose information 
        /// </summary>
        /// <returns></returns>
        public DataSet FillDosageInfoText(int MedicationNameId, string ClientDOB)
        {
            SqlParameter[] _ParametersObject = null;
            try
            {
                _ParametersObject = new SqlParameter[2];
                _ParametersObject[0] = new SqlParameter("@MedicationNameId", MedicationNameId);
                _ParametersObject[1] = new SqlParameter("@ClientDOB", ClientDOB);
                return SqlHelper.ExecuteDataset(_ConnectionString, CommandType.StoredProcedure, "scsp_MMDosageInfoByMedicationName", _ParametersObject);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - FillDosageInfoText(), ParameterCount - 1, First Parameter- " + MedicationNameId + " Second Parameter- " + ClientDOB + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }

        }

        /// <summary>
        /// Returns dataset with drug order template for this prescriber/drug/strength
        /// </summary>
        /// <author>Chuck Blaine</author>
        /// <WrittenOn>July 15 2013</WrittenOn>
        /// <param name="MedicationId">MedicationId</param>
        /// <returns>Dataset</returns>     
        public DataSet LoadDrugOrderTemplate(int MedicationId, int staffId)
        {
            try
            {
                SqlParameter[] _ParametersObject = null;
                _ParametersObject = new SqlParameter[2];
                _ParametersObject[0] = new SqlParameter("@MedicationId", MedicationId);
                _ParametersObject[1] = new SqlParameter("@StaffId", staffId);
                return SqlHelper.ExecuteDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_GetDrugOrderTemplateByMedicationIdStaffId", _ParametersObject);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - LoadDrugOrderTemplate(), ParameterCount - 2, First Parameter- " + MedicationId + "Second Parameter- " + staffId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
        }

        /// <summary>
        /// <Decription>Will Get all the Current Client Medications</Decription>        
        /// <CreatedOn>Feb 1,2010</CreatedOn>
        /// </summary>
        /// <param name=ClientId></param>
        /// <returns></returns>
        /// 
        public DataSet GetClientCurrentMedications(int ClientId)
        {
            SqlParameter[] _ParametersObject = null;
            try
            {
                _ParametersObject = new SqlParameter[1];
                DataSet dsTemp = new DataSet();
                string[] _TableNames = { "TableCurrentMedications", "TableClientMedicationInstruction", "TableClentMedicationScriptDrug" };
                _ParametersObject[0] = new SqlParameter("@ClientId", ClientId);
                SqlHelper.FillDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_GetClientCurrentMedicationsData", dsTemp, _TableNames, _ParametersObject);
                return dsTemp;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetClientCurrentMedications(int ClientId), ParameterCount - 1, First Parameter- " + ClientId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
            finally
            {
            }
        }
        public DataSet GetSearchPharmacies(string PharmacyName, string Address, string City, string State, string Zip, string Phone, string Fax, int PharmacyId, string SureScriptIdentifier, string Specialty, int startrowIndex, int endRowIndex)
        {
            SqlParameter[] _ParametersObject = null;
            try
            {
                _ParametersObject = new SqlParameter[12];
                DataSet dsTemp = new DataSet();
                string[] _TableNames = { "Pharmacy", "TotalRecords" };
                _ParametersObject[0] = new SqlParameter("@pharmacyName", PharmacyName);
                _ParametersObject[1] = new SqlParameter("@Address", Address);
                _ParametersObject[2] = new SqlParameter("@City", City);
                _ParametersObject[3] = new SqlParameter("@State", State);
                _ParametersObject[4] = new SqlParameter("@Zip", Zip);
                _ParametersObject[5] = new SqlParameter("@PhoneNumber", Phone);
                _ParametersObject[6] = new SqlParameter("@FaxNumber", Fax);
                _ParametersObject[7] = new SqlParameter("@pharmacyId", PharmacyId);
                _ParametersObject[8] = new SqlParameter("@SureScriptsIdentifier", SureScriptIdentifier);
                _ParametersObject[9] = new SqlParameter("@Specialty", Specialty);
                _ParametersObject[10] = new SqlParameter("@startRowIndex", startrowIndex);
                _ParametersObject[11] = new SqlParameter("@endRowIndex", endRowIndex);


                SqlHelper.FillDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_SCGetPharmacySearch", dsTemp, _TableNames, _ParametersObject);
                return dsTemp;

            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetClientCurrentMedications(int ClientId), ParameterCount - 1, First Parameter- " + PharmacyName + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
        }
        /// <summary>
        /// Author Sahil Bhagat
        /// it is used to merge the Pharmacies.
        /// <createdDate>Feb. 09,2010 </createdDate>
        /// Modified By Priya Ref:Task no:85
        /// <param name="mergePharmacyId"></param>
        /// <param name="parentPharmacyId"></param>
        /// <param name="UserCode"></param>
        /// </summary>
        /// <returns></returns>
        public void MergePharmacy(int PreferredPharmacyId, int SureScriptsPharmacyId, string UserCode)
        {
            SqlParameter[] _ParametersObject = null;
            try
            {
                if (SureScriptsPharmacyId != null)
                {
                    _ParametersObject = new SqlParameter[3];
                    _ParametersObject[0] = new SqlParameter("@PreferredPharmacyId", PreferredPharmacyId);
                    _ParametersObject[1] = new SqlParameter("@SureScriptsPharmacyId", SureScriptsPharmacyId);
                    _ParametersObject[2] = new SqlParameter("@UserCode", UserCode);
                    SqlHelper.ExecuteNonQuery(_ConnectionString, CommandType.StoredProcedure, "ssp_PharmaciesMerge", _ParametersObject);
                }
            }
            catch (Exception ex)
            {
                SqlTransactionObject.Rollback();
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - ssp_PharmaciesMerge(), ParameterCount - 3, First Parameter- " + PreferredPharmacyId + " , Second Parameter- " + SureScriptsPharmacyId + ", Third Parameter- " + UserCode + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
        }

        /// <summary>
        /// Author Loveena
        /// determine whether the script(s) can be sent via SureScripts.
        /// </summary>       
        /// <returns></returns>
        /// <Modified>In ref to Task#3214 2.3 ssp_SCSureScriptsAvailable add @LocationId Parameter </Modified>
        public DataSet SureScriptsAvailable(int PharmacyId, int PrescriberId, int LocationId)
        {
            SqlParameter[] _ParametersObject = null;
            try
            {
                _ParametersObject = new SqlParameter[3];
                _ParametersObject[0] = new SqlParameter("@PharmacyId", PharmacyId);
                _ParametersObject[1] = new SqlParameter("@PrescriberId", PrescriberId);
                _ParametersObject[2] = new SqlParameter("@LocationId", LocationId);
                return SqlHelper.ExecuteDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_SCSureScriptsAvailable", _ParametersObject);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - ClientMedicationDrug(), ParameterCount - 2, First Parameter- " + PharmacyId + ",Second Parameter-" + PrescriberId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }

        }


        /// <summary>
        /// Author PranayB
        /// Check ElectroninPrescriptionPermissions.
        /// </summary>       
        /// <returns>Table</returns>   
        public DataSet ElectronicPrescriptionPermissions(int PrescriberId,int PharmacyId=0)
        {
            SqlParameter[] _ParametersObject = null;
            try
            {
                _ParametersObject = new SqlParameter[2];
                _ParametersObject[0] = new SqlParameter("@PrescriberId", PrescriberId);
                _ParametersObject[1] = new SqlParameter("@PharmacyId", PharmacyId);
                return SqlHelper.ExecuteDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_GetElecronicPresciptionPermissions", _ParametersObject);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - ElectronicPrescriptionPermissions(), ParameterCount - 2, First Parameter- " + PrescriberId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }

        }


        /// <summary>
        /// Author Loveena
        /// task#3233 - 2.3 Order Details / Print Medication Order Dialog Changes
        /// </summary>       
        /// <returns></returns>        
        public DataSet ReprintAllowed(int ClientMedicationScriptId, string Method)
        {
            SqlParameter[] _ParametersObject = null;
            try
            {
                _ParametersObject = new SqlParameter[2];
                _ParametersObject[0] = new SqlParameter("@ClientMedicationScriptId", ClientMedicationScriptId);
                _ParametersObject[1] = new SqlParameter("@Method", Method);
                return SqlHelper.ExecuteDataset(_ConnectionString, CommandType.StoredProcedure, "scsp_SmartCareRxScriptReprintAllowed", _ParametersObject);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - ClientMedicationDrug(), ParameterCount - 2, First Parameter- " + ClientMedicationScriptId + ",Second Parameter-" + Method + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }

        }

        /// <summary>
        /// This function is used to set all Pharmacies for Pharmacy Management.
        /// <author>Loveena</author>
        /// <Dated>08 Nov 2010</Dated>
        /// </summary>                
        public DataSet GetAllPharmacies()
        {
            try
            {
                DataSet dsTemp = new DataSet();
                string[] _TableNames = { "Pharmacies" };
                SqlHelper.FillDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_SCGetAllPharmacies", dsTemp, _TableNames);
                return dsTemp;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetAllPharmacies(), ParameterCount - 0  ###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }

        }
        #region--Code Addeed By Loveena as per task#3287
        /// <summary>
        /// <Description>Used to get allowed ordering method</Description>
        /// <Author>Pradeep</Author>
        /// <CreatedOn>24 Dec 2010</CreatedOn>
        /// </summary>
        /// <param name="ClientMedicationScriptId"></param>
        /// <returns></returns>
        public DataSet GetOrderingMethodAllowed(int ClientMedicationScriptId)
        {
            SqlParameter[] _ParametersObject = null;
            try
            {
                DataSet dsTemp = new DataSet();
                _ParametersObject = new SqlParameter[1];
                _ParametersObject[0] = new SqlParameter("@ClientMedicationScriptId", ClientMedicationScriptId);
                string[] _TableNames = { "OrderingMethodAllowed" };
                SqlHelper.FillDataset(_ConnectionString, CommandType.StoredProcedure, "scsp_SCValidateOderingMethod", dsTemp, _TableNames, _ParametersObject);
                return dsTemp;

            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetOrderingMethodAllowed(int ClientMedicationScriptId), ParameterCount - 1  ###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }
        }

        /// <summary>
        /// <Description>Used to get allowed ordering method</Description>
        /// <Author>Pradeep</Author>
        /// <CreatedOn>24 Dec 2010</CreatedOn>
        /// </summary>
        /// <param name="ClientMedicationScriptId"></param>
        /// <returns></returns>
        public DataSet GetOrderingMethodAllowedFinal(int ClientMedicationScriptId)
        {
            SqlParameter[] _ParametersObject = null;
            try
            {
                DataSet dsTemp = new DataSet();
                _ParametersObject = new SqlParameter[1];
                _ParametersObject[0] = new SqlParameter("@ClientMedicationScriptId", ClientMedicationScriptId);
                string[] _TableNames = { "OrderingMethodAllowed" };
                SqlHelper.FillDataset(_ConnectionString, CommandType.StoredProcedure, "scsp_SCValidateOderingMethodFinal", dsTemp, _TableNames, _ParametersObject);
                return dsTemp;

            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetOrderingMethodAllowedFinal(int ClientMedicationScriptId), ParameterCount - 1  ###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }
        }

        /// <summary>
        /// <Description>Used to get allowed ordering method as per task#3305</Description>
        /// <Author>Pradeep</Author>
        /// <CreatedOn>24 Dec 2010</CreatedOn>
        /// </summary>
        /// <param name="ClientMedicationScriptId"></param>
        /// <returns></returns>
        public DataSet GetValidationStatus(int ClientMedicationScriptId, char capNonControlled, char capControlled, string[] Queuedvalues)
        {
            SqlParameter[] _ParametersObject = null;
            if (Queuedvalues != null && Queuedvalues.Contains("Queued"))
            {
                try
                {
                    DataSet dsTemp = new DataSet();
                    _ParametersObject = new SqlParameter[3];
                    _ParametersObject[0] = new SqlParameter("@Clientid", Queuedvalues[1]);
                    _ParametersObject[1] = new SqlParameter("@MedicationNameId", Queuedvalues[2]);
                    _ParametersObject[2] = new SqlParameter("@PrescriberId", Queuedvalues[3]);

                    string[] _TableNames = { "ValidationStatus" };
                    SqlHelper.FillDataset(_ConnectionString, CommandType.StoredProcedure, "scsp_SCValidateQueueorderScript", dsTemp, _TableNames, _ParametersObject);
                    return dsTemp;

                }
                catch (Exception ex)
                {
                    if (ex.Data["CustomExceptionInformation"] == null)
                        ex.Data["CustomExceptionInformation"] = "### Queuedorder click  ###";
                    if (ex.Data["DatasetInfo"] == null)
                        ex.Data["DatasetInfo"] = null;
                    throw ex;
                }
            }

                else
                {
                    try
                    {
                        DataSet dsTemp = new DataSet();
                        _ParametersObject = new SqlParameter[3];
                        _ParametersObject[0] = new SqlParameter("@ClientMedicationScriptId", ClientMedicationScriptId);
                        _ParametersObject[1] = new SqlParameter("@CapNonControlled", capNonControlled);
                        _ParametersObject[2] = new SqlParameter("@CapControlled", capControlled);
                        string[] _TableNames = { "ValidationStatus" };
                        SqlHelper.FillDataset(_ConnectionString, CommandType.StoredProcedure, "scsp_SCValidateScript", dsTemp, _TableNames, _ParametersObject);
                        return dsTemp;

                    }
                    catch (Exception ex)
                    {
                        if (ex.Data["CustomExceptionInformation"] == null)
                            ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetOrderingMethodAllowed(int ClientMedicationScriptId), ParameterCount - 1  ###";
                        if (ex.Data["DatasetInfo"] == null)
                            ex.Data["DatasetInfo"] = null;
                        throw ex;
                    }
                }
        }

        /// <summary>
        /// <Description>Used to get check if the MedicationPrescibed and ChangeMedication are Same</Description>
        /// <Author>PranayB</Author>
        /// <CreatedOn>10 OCT 2017</CreatedOn>
        /// </summary>
        /// <param name="ClientMedicationScriptId"></param>
        /// <returns></returns> 
        public string ValidateChangeMedicationList(int ClientMedicationScriptId,int SureScriptsChangeRequestId)
        {
            SqlParameter[] _ParametersObject = null;
            string ValidMedicationList = "";
            try
            {
               
                _ParametersObject = new SqlParameter[3];
                _ParametersObject[0] = new SqlParameter("@ClientMedicationScriptId", ClientMedicationScriptId);
                _ParametersObject[1] = new SqlParameter("@SureScriptsChangeRequestId", SureScriptsChangeRequestId);
                _ParametersObject[2] = new SqlParameter("@Status", SqlDbType.NVarChar,10);
                _ParametersObject[2].Direction = ParameterDirection.Output;
                SqlHelper.ExecuteNonQuery(_ConnectionString, CommandType.StoredProcedure, "ssp_ValidateChangeMedicationScript", _ParametersObject);
                ValidMedicationList =  _ParametersObject[2].Value.ToString();
                return ValidMedicationList;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "### Queuedorder click  ###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }
            

        }



        /// <summary>
        /// <Decription>Used to update client MedicationScriptPreview tables</Decription>
        /// <Author>Pradeep</Author>
        /// </summary>
        /// <param name="DataSetClientMedicationScriptPreview"></param>
        /// <returns></returns>
        public DataSet UpdateClientMedicationScriptPreview(DataSet DataSetClientMedicationScriptPreview)
        {
            try
            {

                string _SelectQuery = "";
                int _TableCount;
                SqlParameter[] _ParametersObject = null;
                DataSet dsTemp = new DataSet();

                SqlConnectionObject = new SqlConnection(_ConnectionString);
                SqlConnectionObject.Open();
                SqlTransactionObject = SqlConnectionObject.BeginTransaction();
                // to keep only those rows that have been changed
                DataSet dsAdded = DataSetClientMedicationScriptPreview.GetChanges(DataRowState.Added);
                DataSet dsModified = DataSetClientMedicationScriptPreview.GetChanges(DataRowState.Modified);
                DataSet dsDeleted = DataSetClientMedicationScriptPreview.GetChanges(DataRowState.Deleted);
                DataSet dsUnchanged = DataSetClientMedicationScriptPreview.GetChanges(DataRowState.Unchanged);
                DataSet dsUpdate = new DataSet();
                if (dsAdded != null)
                    dsUpdate.Merge(dsAdded);
                if (dsModified != null)
                    dsUpdate.Merge(dsModified);
                if (dsDeleted != null)
                    dsUpdate.Merge(dsDeleted);
                DataSetClientMedicationScriptPreview = dsUpdate;


                for (_TableCount = 0; _TableCount <= DataSetClientMedicationScriptPreview.Tables.Count - 1; _TableCount++)
                {
                    if (DataSetClientMedicationScriptPreview.Tables[_TableCount].TableName.ToString() == "ClientMedicationScripts")
                    {
                        DataSetClientMedicationScriptPreview.Tables[_TableCount].TableName = DataSetClientMedicationScriptPreview.Tables[_TableCount].TableName + "Preview";
                        SqlCommand sqlSelectCommand;
                        //_SelectQuery = "Select * from " + DataSetClientMedicationScriptPreview.Tables[_TableCount].TableName.ToString();
                        _SelectQuery = Streamline.DataService.ApplicationCommonFunctions.GetSelectSQL(DataSetClientMedicationScriptPreview.Tables[_TableCount]);
                        sqlSelectCommand = new SqlCommand(_SelectQuery, SqlConnectionObject, SqlTransactionObject); // , transDiagnosis);
                        SqlDataAdapter _SqlDataAdapter = new SqlDataAdapter(sqlSelectCommand);
                        SqlCommandBuilder _SqlCommandBuilder = new SqlCommandBuilder(_SqlDataAdapter);
                        _SqlDataAdapter.UpdateCommand = _SqlCommandBuilder.GetUpdateCommand();
                        _SqlDataAdapter.UpdateCommand.Transaction = SqlTransactionObject;
                        _SqlDataAdapter.Update(DataSetClientMedicationScriptPreview.Tables[_TableCount]);
                    }
                }
                SqlTransactionObject.Commit();

                for (_TableCount = 0; _TableCount < DataSetClientMedicationScriptPreview.Tables.Count; _TableCount++)
                {
                    if (DataSetClientMedicationScriptPreview.Tables[_TableCount].TableName.ToString() == "ClientMedicationScriptsPreview")
                    {
                        DataSetClientMedicationScriptPreview.Tables[_TableCount].TableName = DataSetClientMedicationScriptPreview.Tables[_TableCount].TableName.Substring(0, DataSetClientMedicationScriptPreview.Tables[_TableCount].TableName.IndexOf("Preview")).ToString();
                    }

                }
                if (dsUnchanged != null)
                    DataSetClientMedicationScriptPreview.Merge(dsUnchanged);
                DataSetClientMedicationScriptPreview.AcceptChanges();
                return DataSetClientMedicationScriptPreview;


            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - UpdateClientMedicationScriptPreview(DataSet ClientMedicationScriptPreview), ParameterCount - 1  ###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }
        }
        #endregion
        #region--Code Added by Pradeep as per task#3346 on 17 March 2011
        /// <summary>
        /// <Description>Used to get Pharmacy edit aloowed status as per task#3346</Description>
        /// <Author>Pradeep</Author>
        /// <CreatedOn>17 March 2011</CreatedOn>
        /// </summary>
        /// <param name="PharmacyId"></param>
        /// <returns></returns>
        public DataSet GetPharmacyEditAllowedStaus(int PharmacyId)
        {
            SqlParameter[] _ParametersObject = null;
            try
            {
                DataSet dsTemp = new DataSet();
                _ParametersObject = new SqlParameter[1];
                _ParametersObject[0] = new SqlParameter("@PharmacyId", PharmacyId);
                string[] _TableNames = { "PharmacyEditAllowedStatus" };
                SqlHelper.FillDataset(_ConnectionString, CommandType.StoredProcedure, "scsp_MMPharmacyEditAllowed", dsTemp, _TableNames, _ParametersObject);
                return dsTemp;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetPharmacyEditAllowedStaus(int PharmacyId), ParameterCount - 1  ###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }
            finally
            {
                _ParametersObject = null;
            }
        }
        /// <summary>
        /// <Description>Used to validate pharmacy as per task#3346 </Description>
        /// <Author>Pradeep</Author>
        /// <CreatedOn>17 March 2011</CreatedOn>
        /// </summary>
        /// <param name="PharmacyName"></param>
        /// <param name="Active"></param>
        /// <param name="PreferredPharmacy"></param>
        /// <param name="PhoneNumber"></param>
        /// <param name="FaxNumber"></param>
        /// <param name="Email"></param>
        /// <param name="Address"></param>
        /// <param name="City"></param>
        /// <param name="State"></param>
        /// <param name="ZipCode"></param>
        /// <param name="SurescriptsPharmacyIdentifier"></param>
        /// <returns></returns>
        public DataSet GetPharmacyValidationStatus(string PharmacyName, char Active, char PreferredPharmacy, string PhoneNumber, string FaxNumber, string Email, string Address, string City, string State, string ZipCode, string SurescriptsPharmacyIdentifier, Int32 PharamacyId)
        {
            SqlParameter[] _ParametersObject = null;
            DataSet dsTemp = null;
            try
            {
                dsTemp = new DataSet();
                _ParametersObject = new SqlParameter[12];
                _ParametersObject[0] = new SqlParameter("@PharmacyName", PharmacyName);
                _ParametersObject[1] = new SqlParameter("@Active", Active);
                _ParametersObject[2] = new SqlParameter("@PreferredPharmacy", PreferredPharmacy);
                _ParametersObject[3] = new SqlParameter("@PhoneNumber", PhoneNumber);
                _ParametersObject[4] = new SqlParameter("@FaxNumber", FaxNumber);
                _ParametersObject[5] = new SqlParameter("@Email", Email);
                _ParametersObject[6] = new SqlParameter("@Address", Address);
                _ParametersObject[7] = new SqlParameter("@City", City);
                _ParametersObject[8] = new SqlParameter("@State", State);
                _ParametersObject[9] = new SqlParameter("@ZipCode", ZipCode);
                _ParametersObject[10] = new SqlParameter("@SurescriptsPharmacyIdentifier", SurescriptsPharmacyIdentifier);
                _ParametersObject[11] = new SqlParameter("@PharmacyId", PharamacyId);
                string[] _TableNames = { "PharmacyValidateStatus" };
                SqlHelper.FillDataset(_ConnectionString, CommandType.StoredProcedure, "scsp_MMPharmacyValidate", dsTemp, _TableNames, _ParametersObject);
                return dsTemp;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetPharmacyEditAllowedStaus(int PharmacyId), ParameterCount - 1  ###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }
            finally
            {
                _ParametersObject = null;
                if (dsTemp != null)
                {
                    dsTemp.Dispose();
                }
            }

        }

        /// <summary>
        /// Retrieves the NoKnownAllergy Flag from the client table using the scsp_SCClientMedicationClientInformation proc
        /// </summary>
        /// <param name="ClientId"></param>
        /// <returns></returns>
        public bool GetNoKnownAllergiesFlag(Int32 ClientId, string CheckboxFlag)
        {
            DataSet ds = new DataSet();
            SqlParameter[] parms = new SqlParameter[2];
            try
            {
                parms[0] = new SqlParameter("@ClientId", ClientId);
                parms[1] = new SqlParameter("@Flag", CheckboxFlag);
                string[] tableNames = { "NoKnownAllergiesFlag" };
                SqlHelper.FillDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_SCUpdateClientAllergyNoKnownAllergies", ds, tableNames, parms);
                if (ds.Tables["NoKnownAllergiesFlag"].Rows.Count > 0)
                {
                    return ds.Tables["NoKnownAllergiesFlag"].Rows[0]["NoKnownAllergies"].ToString().ToLower().Equals("y") ? true : false;
                }
                else
                {
                    return false;
                }
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetNoKnownAllergiesFlag(int ClientId, string CheckboxFlag), ParameterCount - 2  ###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }
            finally
            {
                parms = null;
                if (ds != null)
                {
                    ds.Dispose();
                }
            }

        }

        public void UpdateNoMedicationsFlag(Int32 ClientId, string CheckboxFlag)
        {
            SqlParameter[] parms = new SqlParameter[2];
            try
            {
                parms[0] = new SqlParameter("@ClientId", ClientId);
                parms[1] = new SqlParameter("@Flag", CheckboxFlag);
                SqlHelper.ExecuteScalar(_ConnectionString, CommandType.StoredProcedure, "ssp_MMUpdateNoMedicationsFlag",
                                        parms);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - UpdateNoMedicationsFlag(int ClientId, string CheckboxFlag), ParameterCount - 2  ###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }
            finally
            {
                parms = null;
            }

        }

        /// <summary>
        /// Get the Reconciliation Drop Down list and Data 
        /// </summary>
        /// <param name="ClientId"></param>
        /// <returns></returns>
        public DataSet GetReconciliationData(Int32 DocumentVersionId, Int32 ReconciliationTypeId)
        {
            DataSet ds = new DataSet();
            SqlParameter[] parms = new SqlParameter[2];
            try
            {
                parms[0] = new SqlParameter("@DocumentVersionId", DocumentVersionId);
                parms[1] = new SqlParameter("@ReconciliationTypeId", ReconciliationTypeId);
                string[] tableNames = { "ReconciliationDataList" };
                SqlHelper.FillDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_MedicationInformation", ds, tableNames, parms);
                return ds;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetReconciliationData(int DocumentVersionId) ###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }
            finally
            {
                parms = null;
                if (ds != null)
                {
                    ds.Dispose();
                }
            }

        }

        public void GetMedReconciliationData(Int32 GlobalCodeId, Int32 DocumentVersionId, Int32 ClientId, Int32 StaffId, Int32 ReconciliationTypeId, String RowIdentifier)
        {
            DataSet ds = new DataSet();
            SqlParameter[] parms = new SqlParameter[6];
            try
            {
                parms[0] = new SqlParameter("@ClientId", ClientId);
                parms[1] = new SqlParameter("@StaffId", StaffId);
                parms[2] = new SqlParameter("@GlobalCodeId", GlobalCodeId);
                parms[3] = new SqlParameter("@ReconciliationTypeId", ReconciliationTypeId);
                parms[4] = new SqlParameter("@DocumentVersionId", DocumentVersionId);
                parms[5] = new SqlParameter("@RowIdentifier", RowIdentifier);
                string[] tableNames = { "MedReconciliationDataList" };
                SqlHelper.FillDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_MedicationReconciliationInformation", ds, tableNames, parms);
                //return ds;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetMedReconciliationData(int GlobalCodeId,int DocumentVersionId,int ClientId, int StaffId,char ReconciliationType) ###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }
            finally
            {
                parms = null;
                if (ds != null)
                {
                    ds.Dispose();
                }
            }

        }

        public DataSet GetRecData(Int32 DocumentVersionId, Int32 ReconciliationTypeId, Int32 ClientId, Int32 StaffId)
        {
            DataSet ds = new DataSet();
            SqlParameter[] parms = new SqlParameter[4];
            try
            {
                parms[0] = new SqlParameter("@DocumentVersionId", DocumentVersionId);
                parms[1] = new SqlParameter("@ReconciliationTypeId", ReconciliationTypeId);
                parms[2] = new SqlParameter("@ClientId", ClientId);
                parms[3] = new SqlParameter("@StaffId", StaffId);
                string[] tableNames = { "RecDataList" };
                SqlHelper.FillDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_GetMedReconciliationInformation", ds, tableNames, parms);
                return ds;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetReconciliationData(int DocumentVersionId) ###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }
            finally
            {
                parms = null;
                if (ds != null)
                {
                    ds.Dispose();
                }
            }

        }

        /// <summary>
        /// Get the Reconciliation Drop Down list
        /// </summary>
        /// <param name="ClientId"></param>
        /// <returns></returns>
        public DataSet GetReconciliationDropDown(Int32 ClientId)
        {
            DataSet ds = new DataSet();
            SqlParameter[] parms = new SqlParameter[1];
            try
            {
                parms[0] = new SqlParameter("@ClientId", ClientId);
                string[] tableNames = { "ReconciliationDropDownList" };
                SqlHelper.FillDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_MedicationReconciliationDocumentVersions", ds, tableNames, parms);
                return ds;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetReconciliationData(int ClientId) ###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }
            finally
            {
                parms = null;
                if (ds != null)
                {
                    ds.Dispose();
                }
            }

        }

        public DataSet GetMedReconciliationDropDown()
        {
            DataSet ds = new DataSet();
            try
            {
                string[] tableNames = { "MedReconciliationDropDownList" };
                SqlHelper.FillDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_GetMedicationReconciliationData", ds, tableNames);
                return ds;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetMedReconciliationData() ###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }
            finally
            {

                if (ds != null)
                {
                    ds.Dispose();
                }
            }

        }



        #endregion



        public DataRow GetPharmacyById(int pharmacyId)
        {
            try
            {
                DataSet dsTemp = new DataSet();
                DataRow dr = null;
                string[] _TableNames = { "Pharmacy" };
                SqlParameter[] _ParametersObject = null;
                _ParametersObject = new SqlParameter[1];
                _ParametersObject[0] = new SqlParameter("@PharmacyId", pharmacyId.ToString());
                SqlHelper.FillDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_SCGetPharmacyById", dsTemp, _TableNames, _ParametersObject);
                if (dsTemp.Tables["Pharmacy"].Rows.Count > 0)
                {
                    return dsTemp.Tables["Pharmacy"].Rows[0];
                }
                else
                {
                    return dr;
                }
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetPharmacyById(pharmacyId), ParameterCount - 1  ###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }
        }

        public bool CheckForDrugCategory2(Int32 MedicationNameId)
        {
            try
            {
                DataSet dsTemp = new DataSet();
                SqlParameter[] parms = new SqlParameter[1];
                parms[0] = new SqlParameter("@MedicationNameId", MedicationNameId.ToString());
                string[] _TableNames = { "DrugCategory2Exists" };
                SqlHelper.FillDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_CheckForDrugCategory2", dsTemp, _TableNames, parms);
                if (dsTemp.Tables.Count > 0 || dsTemp.Tables[0].Rows.Count > 0)
                {
                    if (dsTemp.Tables[0].Rows[0][0].ToString() == "N")
                    {
                        return false;
                    }
                    else
                    {
                        return true;
                    }
                }
                return true;

            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - CheckForDrugCategory2(), ParameterCount - 1  ###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }

        }

        public DataSet FillPotencyUnitCodesByMedicationNameId(Int32 MedicationNameId)
        {
            DataSet dsTemp = new DataSet();
            string[] _TableNames = { "PotencyUnitCodes" };
            SqlParameter[] parms = new SqlParameter[1];
            parms[0] = new SqlParameter("@MedicationNameId", MedicationNameId.ToString());
            SqlHelper.FillDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_GetPotencyUnitCodesByMedicationNameId", dsTemp, _TableNames, parms);
            return dsTemp;
        }

        public DataSet FillMedicationRelatedInformation(Int32 MedicationId,Int32 ClientId)
        {
            DataSet dsTemp = new DataSet();
            string[] _TableNames = { "MedicationRelatedInformation" };
            SqlParameter[] parms = new SqlParameter[2];
            parms[0] = new SqlParameter("@ClientId", ClientId.ToString());
            parms[1] = new SqlParameter("@MedicationId", MedicationId.ToString());
            SqlHelper.FillDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_GetMedicationRelatedInformation", dsTemp, _TableNames, parms);
            return dsTemp;
        }


        public DataSet GetChangeMedicationOrderList(string SureScriptsChangeRequestId)
        {
            DataSet dsTemp = new DataSet();
            string[] _TableNames = { "ChangeOrderMedicationList" };
            SqlParameter[] parms = new SqlParameter[1];
            parms[0] = new SqlParameter("@SureScriptChangeRequestId", Convert.ToInt32(SureScriptsChangeRequestId));
            SqlHelper.FillDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_GetChangeOrderMedicationList", dsTemp, _TableNames, parms);
            return dsTemp;
        }

        public DataSet GetClientEducationNDC(string MedicationNameId)
        {
            DataSet dsTemp = new DataSet();
            string[] _TableNames = { "NDC" };
            SqlParameter[] parms = new SqlParameter[1];
            parms[0] = new SqlParameter("@MedicationNameId", Convert.ToInt32(MedicationNameId.ToString()));
            SqlHelper.FillDataset(_ConnectionString, CommandType.StoredProcedure, "ssp_SCPatientEducationMedicationNDC", dsTemp, _TableNames, parms);
            return dsTemp;
        }


        /// <summary>
        /// This function gets Patientoverviewdetails
        /// </summary>
        /// <author>Anto</author>
        /// <param name="ClientId"></param>
        /// <returns>DataSet</returns>
        public DataSet GetPatientoverviewdetails(int Clientid)
        {
            SqlParameter[] objParam;
            DataSet dsTemp = null;
            try
            {
                dsTemp = new DataSet();
                objParam = new SqlParameter[1];
                objParam[0] = new SqlParameter("@ClientId", Clientid);
                string[] _TableNames = { "ClientInfoAreaHtml", "ClientInformation", "FormularyRequestInformation" };
                SqlHelper.FillDataset(_ConnectionString, CommandType.StoredProcedure, "scsp_SCClientMedicationClientInformation", dsTemp, _TableNames, objParam);
                return dsTemp;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetPatientoverviewdetails(), ParameterCount - 1, First Parameter- " + Clientid + "";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);

            }
            finally
            {
                objParam = null;
            }
        }

        //Author:Aravind 
        //Functions to Update KeyPhrases
        //Task #476.04 - CEI Enhancements 
        public DataSet UpdateKeyPhrases(DataSet DataSetKeyPhrases)
        {
            try
            {
                string _SelectQuery = "";
                int _TableCount;

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
                // to keep only those rows that have been changed
                DataSet dsAdded = DataSetKeyPhrases.GetChanges(DataRowState.Added);
                DataSet dsModified = DataSetKeyPhrases.GetChanges(DataRowState.Modified);
                DataSet dsDeleted = DataSetKeyPhrases.GetChanges(DataRowState.Deleted);
                DataSet dsUnchanged = DataSetKeyPhrases.GetChanges(DataRowState.Unchanged);
                DataSet dsUpdate = new DataSet();
                if (dsAdded != null)
                    dsUpdate.Merge(dsAdded);
                if (dsModified != null)
                {
                    dsUpdate.Merge(dsModified);

                }
                if (dsDeleted != null)
                    dsUpdate.Merge(dsDeleted);
                //DataSetKeyPhrases = dsUpdate;



                for (_TableCount = 0; _TableCount <= DataSetKeyPhrases.Tables.Count - 1; _TableCount++)
                {

                    //_SelectQuery = "Select * from " + DataSetClientMedication.Tables[_TableCount];
                    _SelectQuery = Streamline.DataService.ApplicationCommonFunctions.GetSelectSQL(DataSetKeyPhrases.Tables[_TableCount]);
                    SqlCommand sqlSelectCommand;
                    sqlSelectCommand = new SqlCommand(_SelectQuery, SqlConnectionObject, SqlTransactionObject);

                    SqlDataAdapter _SqlDataAdapter = new SqlDataAdapter(sqlSelectCommand);
                    SqlCommandBuilder _SqlCommandBuilder = new SqlCommandBuilder(_SqlDataAdapter);
                    _SqlDataAdapter.InsertCommand = _SqlCommandBuilder.GetInsertCommand();
                    _SqlDataAdapter.UpdateCommand = _SqlCommandBuilder.GetUpdateCommand();
                    _SqlDataAdapter.InsertCommand.Transaction = SqlTransactionObject;
                    _SqlDataAdapter.UpdateCommand.Transaction = SqlTransactionObject;

                    if (DataSetKeyPhrases.Tables[_TableCount].ToString() == "KeyPhrases")
                    {
                        _SqlDataAdapter.RowUpdated += new SqlRowUpdatedEventHandler(OnKeyPhraseRowUpdated);
                    }

                    _SqlDataAdapter.Update(DataSetKeyPhrases.Tables[_TableCount]);
                }

                SqlTransactionObject.Commit();
                DataSetKeyPhrases.AcceptChanges();
                return DataSetKeyPhrases;

            }
            catch (Exception ex)
            {
                SqlTransactionObject.Rollback();
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - UpdateDocuments(), ParameterCount - 1, First Parameter- " + DataSetKeyPhrases + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
        }
        public void OnKeyPhraseRowUpdated(object sender, SqlRowUpdatedEventArgs args)
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
                                SqlCommand idCMD = new SqlCommand("SELECT @@IDENTITY as KeyPhraseId", args.Command.Connection, args.Command.Transaction);

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
                throw (ex);
            }
        }

        public DataSet UpdateAgencyKeyPhrases(DataSet DataSetKeyPhrases)
        {
            try
            {
                string _SelectQuery = "";
                int _TableCount;

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
                // to keep only those rows that have been changed
                DataSet dsAdded = DataSetKeyPhrases.GetChanges(DataRowState.Added);
                DataSet dsModified = DataSetKeyPhrases.GetChanges(DataRowState.Modified);
                DataSet dsDeleted = DataSetKeyPhrases.GetChanges(DataRowState.Deleted);
                DataSet dsUnchanged = DataSetKeyPhrases.GetChanges(DataRowState.Unchanged);
                DataSet dsUpdate = new DataSet();
                if (dsAdded != null)
                    dsUpdate.Merge(dsAdded);
                if (dsModified != null)
                {
                    dsUpdate.Merge(dsModified);

                }
                if (dsDeleted != null)
                    dsUpdate.Merge(dsDeleted);
               // DataSetKeyPhrases = dsUpdate;
                
                for (_TableCount = 0; _TableCount <= DataSetKeyPhrases.Tables.Count - 1; _TableCount++)
                {

                    //_SelectQuery = "Select * from " + DataSetClientMedication.Tables[_TableCount];
                    _SelectQuery = Streamline.DataService.ApplicationCommonFunctions.GetSelectSQL(DataSetKeyPhrases.Tables[_TableCount]);
                    SqlCommand sqlSelectCommand;
                    sqlSelectCommand = new SqlCommand(_SelectQuery, SqlConnectionObject, SqlTransactionObject);

                    SqlDataAdapter _SqlDataAdapter = new SqlDataAdapter(sqlSelectCommand);
                    SqlCommandBuilder _SqlCommandBuilder = new SqlCommandBuilder(_SqlDataAdapter);
                    _SqlDataAdapter.InsertCommand = _SqlCommandBuilder.GetInsertCommand();
                    _SqlDataAdapter.UpdateCommand = _SqlCommandBuilder.GetUpdateCommand();
                    _SqlDataAdapter.InsertCommand.Transaction = SqlTransactionObject;
                    _SqlDataAdapter.UpdateCommand.Transaction = SqlTransactionObject;

                    if (DataSetKeyPhrases.Tables[_TableCount].ToString() == "AgencyKeyPhrases")
                    {
                        _SqlDataAdapter.RowUpdated += new SqlRowUpdatedEventHandler(OnAgencyKeyPhraseRowUpdated);
                    }

                    _SqlDataAdapter.Update(DataSetKeyPhrases.Tables[_TableCount]);

                }

                SqlTransactionObject.Commit();

                DataSetKeyPhrases.AcceptChanges();
                return DataSetKeyPhrases;

            }
            catch (Exception ex)
            {
                SqlTransactionObject.Rollback();
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - UpdateDocuments(), ParameterCount - 1, First Parameter- " + DataSetKeyPhrases + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
        }


        public void OnAgencyKeyPhraseRowUpdated(object sender, SqlRowUpdatedEventArgs args)
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
                                SqlCommand idCMD = new SqlCommand("SELECT @@IDENTITY as AgencyKeyPhraseId", args.Command.Connection, args.Command.Transaction);

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
                throw (ex);
            }
        }
    }
}

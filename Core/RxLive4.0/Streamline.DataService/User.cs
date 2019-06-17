using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Data.SqlClient;

namespace Streamline.DataService
{
    public class UserInfo
    {
        private static readonly string _ConnectionString = System.Configuration.ConfigurationSettings.AppSettings["SCConnectionString"];
        private static SqlTransaction SqlTransactionObject = null;
        private static SqlConnection SqlConnectionObject = null;

        public DataSet ValidateLogin(string varUsername, string varPassword)
        {
            SqlParameter[] _ParamObject = null;

            try
            {
                _ParamObject = new SqlParameter[2];
                _ParamObject[0] = new SqlParameter("@UserCode", varUsername);
                _ParamObject[1] = new SqlParameter("@UserPassword", varPassword);
                SqlConnection connectionToSmartClient = null;
                connectionToSmartClient = new SqlConnection(ApplicationCommonFunctions.ConnectionString);
                DataSet dataSetClientLogin = new DataSet();
                SqlHelper.FillDataset(connectionToSmartClient, "ssp_SCStaffIdentity", dataSetClientLogin, new string[1] { "ClientInfo" }, _ParamObject);
                return dataSetClientLogin;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                _ParamObject = null;

            }
        }


        public DataSet ValidateToken(string Token)
        {

            DataSet dataSetStaff = null;
            SqlParameter[] _ParamObject = null;
            try
            {
                _ParamObject = new SqlParameter[1];
                _ParamObject[0] = new SqlParameter("@Token", Token);
                dataSetStaff = new DataSet();

                SqlConnection connectionToSmartClient = null;
                connectionToSmartClient = new SqlConnection(ApplicationCommonFunctions.ConnectionString);

                //Added by Chandan on 11th Feb 2009 for task # 2378 1.7.1 - Copyright info
                SqlHelper.FillDataset(connectionToSmartClient, "ssp_ValidateLoginToken", dataSetStaff, new string[1] { "Staff" }, _ParamObject);
                //SqlHelper.FillDataset(connectionToSmartClient, "ssp_ValidateLoginToken", dataSetStaff, new string[2] { "Staff","CopyrightInfo" }, _ParamObject);
                return dataSetStaff;

            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "";
                else
                    ex.Data["CustomExceptionInformation"] = "";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = dataSetStaff;
                throw (ex);

            }

            finally
            {
                _ParamObject = null;

            }
        }


        /// <summary>
        /// Validates the Token genrated through desktop (smartCare) application
        /// </summary>
        /// <param name="Token"></param>
        /// <returns></returns>
        /// <author>Piyush</author>
        /// <createdOn>24th Jan 2008</createdOn>
        public DataSet ValidateWebToken(string Token)
        {
            DataSet DatasetDocumentVersion = null;
            SqlParameter[] _ParamObject = null;
            try
            {
                _ParamObject = new SqlParameter[1];
                _ParamObject[0] = new SqlParameter("@Token", Token);
                DatasetDocumentVersion = new DataSet();

                SqlConnection connectionToSmartClient = null;
                connectionToSmartClient = new SqlConnection(ApplicationCommonFunctions.ConnectionString);

                SqlHelper.FillDataset(connectionToSmartClient, "ssp_ValidateWebLoginToken", DatasetDocumentVersion, new string[1] { "Staff" }, _ParamObject);
                return DatasetDocumentVersion;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "";
                else
                    ex.Data["CustomExceptionInformation"] = "";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = DatasetDocumentVersion;
                throw (ex);
            }
            finally
            {
                _ParamObject = null;
                DatasetDocumentVersion = null;
            }
        }


        /// <summary>
        /// <Author>Sonia</Author>
        /// <Purpose>To get the Personal Information as well as Medication Information for a particular client</Purpose>
        /// </summary>
        /// <param name="ClientId"></param>
        /// <returns></returns>
        public DataSet GetClientInfo(int ClientId)
        {

            DataSet dataSetClients = null;
            SqlParameter[] _ParamObject = null;
            try
            {
                _ParamObject = new SqlParameter[1];
                _ParamObject[0] = new SqlParameter("@ClientId", ClientId);
                dataSetClients = new DataSet();

                SqlConnection connectionToSmartClient = null;
                connectionToSmartClient = new SqlConnection(ApplicationCommonFunctions.ConnectionString);
                string[] _TableNames = { "ClientInformation" };
                // new string[3] { "Staff"}{"MedicationPlan"}{"PrimaryClinician"},
                SqlHelper.FillDataset(connectionToSmartClient, "ssp_SCGetClientInformationForMedication", dataSetClients, _TableNames, _ParamObject);
                //ssp_SCGetClientInformation
                return dataSetClients;

            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "";
                else
                    ex.Data["CustomExceptionInformation"] = "";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = dataSetClients;
                throw (ex);

            }

            finally
            {
                _ParamObject = null;

            }
        }

        public DataTable getSharedClients(string ClinicianRowIdentifier, int StaffId)
        {
            DataSet DataSetClients = null;
            DataSet DataSetSharedClients = null;
            DataTable dt = null;
            string _RowIdentifierStaff = "";
            SqlParameter[] parmDocument = null;
            DataSet[] dsClientStaff = null;

            try
            {

                parmDocument = new SqlParameter[1];
                parmDocument[0] = new SqlParameter("@RowIdentifier", SqlDbType.UniqueIdentifier);
                parmDocument[0].Value = new Guid(ClinicianRowIdentifier);
                int ClinicianId;


                if (StaffId > 0)
                    ClinicianId = StaffId;
                else
                    ClinicianId = Convert.ToInt32(SqlHelper.ExecuteScalar(ApplicationCommonFunctions.ConnectionString, "ssp_SCGetStaffIdByRowIdentifier", parmDocument));

                DataSetSharedClients = new DataSet("Clients");
                DataSet dsBlank = new DataSet();
                try
                {
                    _RowIdentifierStaff = ClinicianRowIdentifier;
                    DataSetClients = DownloadClientsInfoWithoutDecode(ClinicianId.ToString());
                    #region CommentedCode
                    //if (strEncryption == "Y")
                    //{
                    //    dt = new DataTable("Table");
                    //    dt.Columns.Add("ClientId", System.Type.GetType("System.Int32"));
                    //    dt.Columns.Add("LastName", System.Type.GetType("System.String"));
                    //    dt.Columns.Add("FirstName", System.Type.GetType("System.String"));
                    //    dt.Columns.Add("Name", System.Type.GetType("System.String"));
                    //    dt.Columns.Add("RowIdentifier", System.Type.GetType("System.String"));
                    //    dt.Columns.Add("Status", System.Type.GetType("System.Int32"));

                    //    for (int loopVar = 0; loopVar < DataSetClients.Tables[0].Rows.Count; loopVar++)
                    //    {
                    //        DataRow dr = dt.NewRow();
                    //        dr["ClientId"] = DataSetClients.Tables[0].Rows[loopVar]["ClientId"];
                    //        dr["LastName"] = GetDecryptedData(DataSetClients.Tables[0].Rows[loopVar]["LastName"].ToString().Trim());
                    //        dr["FirstName"] = GetDecryptedData(DataSetClients.Tables[0].Rows[loopVar]["FirstName"].ToString().Trim());

                    //        dr["Name"] = dr["LastName"] + ", " + dr["FirstName"];
                    //        dr["RowIdentifier"] = DataSetClients.Tables[0].Rows[loopVar]["RowIdentifier"];
                    //        dr["Status"] = 1;

                    //        dt.Rows.Add(dr);
                    //    }

                    //    DataSetSharedClients.Tables.Add(dt);
                    //}
                    //else
                    #endregion

                    DataSetSharedClients.Tables.Add(DataSetClients.Tables[0].Copy());

                    //return DataSetSharedClients.Tables[0];

                }
                catch (Exception ex)
                {
                    throw ex;
                }
                finally
                {
                    dt = null;
                    DataSetClients = null;
                }

                return DataSetSharedClients.Tables[0];
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "";
                else
                    ex.Data["CustomExceptionInformation"] = "";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = DataSetClients;
                throw (ex);
            }
            finally
            {
                DataSetSharedClients = null;

            }
        }

        public DataSet DownloadClientsInfoWithoutDecode(string varStaffid)
        {
            try
            {
                DataSet DatasetClientInfoMessages = new DataSet();
                SqlParameter[] objParam = new SqlParameter[2];

                objParam[0] = new SqlParameter("@LoggedInStaffId", varStaffid);
                objParam[1] = new SqlParameter("@StaffId", varStaffid);
                DatasetClientInfoMessages = SqlHelper.ExecuteDataset(ApplicationCommonFunctions.ConnectionString, "SSP_SCGetPrimaryStaffClients", objParam);

                return DatasetClientInfoMessages;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// <CreatedBy>Loveena</CreatedBy>
        /// <CreationDate>10-March-2009</CreationDate>
        /// <Description>To get Staff Detail from Staff on basis of Staff Id</Description>
        /// </summary>
        /// <param name="StaffId"></param>
        /// <returns></returns>
        public DataSet StaffDetail(int StaffId)
        {

            DataSet dataSetStaff = null;
            SqlParameter[] _ParamObject = null;
            try
            {
                _ParamObject = new SqlParameter[1];
                _ParamObject[0] = new SqlParameter("@StaffId", StaffId);
                dataSetStaff = new DataSet();

                SqlConnection connectionToSmartClient = null;
                connectionToSmartClient = new SqlConnection(ApplicationCommonFunctions.ConnectionString);
                SqlHelper.FillDataset(connectionToSmartClient, "ssp_LoginStaffDetail", dataSetStaff, new string[1] { "Staff" }, _ParamObject);
                return dataSetStaff;

            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "";
                else
                    ex.Data["CustomExceptionInformation"] = "";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = dataSetStaff;
                throw (ex);

            }

            finally
            {
                _ParamObject = null;

            }
        }

        //Rohit ref #90
        public DataTable GetSystemReports()
        {
            DataSet dataSetReports = null;
            try
            {
                dataSetReports = new DataSet();

                SqlConnection connectionToSmartClient = null;
                connectionToSmartClient = new SqlConnection(ApplicationCommonFunctions.ConnectionString);
                string[] _TableNames = { "SystemReports" };
                SqlHelper.FillDataset(connectionToSmartClient, "ssp_SCGetSystemReportsForMedication", dataSetReports, _TableNames, null);
                return dataSetReports.Tables[0];

            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "";
                else
                    ex.Data["CustomExceptionInformation"] = "";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = dataSetReports;
                throw (ex);

            }

            finally
            {


            }
        }

        //Rohit ref #90
        public int InsertReport(System.Guid sessionId, DataTable DataTableValues, string UserCode)
        {
            int Result = 0;
            SqlParameter[] _ParametersObject = null;

            SqlConnection _SqlConnectionObject = null;
            SqlTransaction sqlTransactionDx = null;
            SqlConnection sqlConnectionDx = null;

            try
            {

                try
                {
                    _SqlConnectionObject = new SqlConnection(ApplicationCommonFunctions.ConnectionString);
                    _SqlConnectionObject.Open();
                    sqlTransactionDx = _SqlConnectionObject.BeginTransaction();
                }
                catch (SqlException sqlEx)
                {
                    throw (sqlEx);
                }
                for (int i = 0; i < DataTableValues.Rows.Count; i++)
                {
                    _ParametersObject = new SqlParameter[3];
                    _ParametersObject[0] = new SqlParameter("@Value", DataTableValues.Rows[i]["Value"]);
                    _ParametersObject[1] = new SqlParameter("@SessionId", sessionId);

                    if (DataTableValues.Rows[i]["Type"].ToString() == "String")
                        _ParametersObject[2] = new SqlParameter("@Type", "Varchar");
                    else
                        _ParametersObject[2] = new SqlParameter("@Type", "Integer");

                    // _ParametersObject[3] = new SqlParameter("@UserCode", UserCode);


                    Result = SqlHelper.ExecuteNonQuery(sqlTransactionDx, "ssp_MMInsertReportParameters", _ParametersObject);
                }



                sqlTransactionDx.Commit();
                return Result;

            }
            catch (System.Data.DBConcurrencyException DBCEX)
            {
                sqlTransactionDx.Rollback();
                throw (DBCEX);
            }
            catch (Exception ex)
            {
                sqlTransactionDx.Rollback();
                throw (ex);
            }
            finally
            {

            }

        }

        /// <summary> 
        /// <author>Chuck Blaine</author>
        /// <Dated>July 12 2013</Dated>
        /// </summary>
        /// <param name="DataSetDrugOrderTemplates"></param>
        /// <returns></returns>
        public static void UpdateDrugOrderTemplates(DataSet DataSetDrugOrderTemplates)
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
                DataSet dsAdded = DataSetDrugOrderTemplates.GetChanges(DataRowState.Added);
                DataSet dsModified = DataSetDrugOrderTemplates.GetChanges(DataRowState.Modified);
                DataSet dsDeleted = DataSetDrugOrderTemplates.GetChanges(DataRowState.Deleted);
                DataSet dsUnchanged = DataSetDrugOrderTemplates.GetChanges(DataRowState.Unchanged);
                DataSet dsUpdate = new DataSet();
                if (dsAdded != null)
                    dsUpdate.Merge(dsAdded);
                if (dsModified != null)
                    dsUpdate.Merge(dsModified);
                if (dsDeleted != null)
                    dsUpdate.Merge(dsDeleted);

                DataSetDrugOrderTemplates = dsUpdate;


                //_SelectQuery = "SELECT * FROM " + DataSetDrugOrderTemplates.Tables[0];
                _SelectQuery = Streamline.DataService.ApplicationCommonFunctions.GetSelectSQL(DataSetDrugOrderTemplates.Tables[0]);
                var sqlSelectCommand = new SqlCommand(_SelectQuery, SqlConnectionObject, SqlTransactionObject);

                var _SqlDataAdapter = new SqlDataAdapter(sqlSelectCommand);
                var _SqlCommandBuilder = new SqlCommandBuilder(_SqlDataAdapter);
                _SqlDataAdapter.InsertCommand = _SqlCommandBuilder.GetInsertCommand();
                _SqlDataAdapter.UpdateCommand = _SqlCommandBuilder.GetUpdateCommand();
                _SqlDataAdapter.InsertCommand.Transaction = SqlTransactionObject;
                _SqlDataAdapter.UpdateCommand.Transaction = SqlTransactionObject;

                _SqlDataAdapter.Update(DataSetDrugOrderTemplates.Tables[0]);

                SqlTransactionObject.Commit();

                if (dsUnchanged != null)
                    DataSetDrugOrderTemplates.Merge(dsUnchanged);

                DataSetDrugOrderTemplates.AcceptChanges();

            }
            catch (Exception ex)
            {
                SqlTransactionObject.Rollback();
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - UpdateDrugOrderTemplates(), ParameterCount - 1, First Parameter- " + DataSetDrugOrderTemplates + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
        }
    }
}

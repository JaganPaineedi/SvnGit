using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

using System.IO;
using System.Security.Cryptography;
using System.Text;

using System.Text.RegularExpressions;
using System.Collections;
using System.Diagnostics;
using System.Data.OleDb;

using System.Linq;
using System.Collections.Generic;


namespace Streamline.DataService
    {
    public class ApplicationCommonFunctions : IDisposable
        {

        private SqlTransaction sqlTransactionDx = null;
        private SqlConnection sqlConnectionDx = null;
        private static SqlConnection _SqlConnectionObject = null;

        public static string ConnectionString = System.Configuration.ConfigurationSettings.AppSettings["SCConnectionString"];
        private string _ConnectionString = ConnectionString;
        ///Created By Pramod Prakash Mishra
        ///this fucntion will make the unmanaged object dispose

        public void Dispose()
            {
            if (sqlTransactionDx != null)
                sqlTransactionDx.Dispose();
            if (sqlConnectionDx != null)
                sqlConnectionDx.Dispose();
            if (_SqlConnectionObject != null)
                _SqlConnectionObject.Dispose();
            }
        //Key to be used for encryption

        /// <summary>
        /// Get data for ClientSearch for Client Search page
        /// </summary>        
        /// <returns>Dataset containing ClientSearch Data</returns>
        /// <Author>Sandeep Kumar Trivedi</Author>
        /// <CreatedOn>20-06-2007</CreatedOn>
        /// <modified on>24th August '07</modified>
        /// <modified by>Priya</modified>
        /// 



        public DataSet GetClientSearchInfo(int UserId, string SearchType, string param1, string param2, string CreatedBy, int ProviderId)
            {

            DataSet DataSetMember = null;
            //Added by Priya on 24th August '07
            //Vithobha added 4 more Parameters to sync with SC application Network 180 - Customizations: #609.1 Rx
            SqlParameter[] param = null;


            try
                {

                param = new SqlParameter[22];
                param[0] = new SqlParameter("@UserId", UserId);
                param[1] = new SqlParameter("@ClientId", 0);
                param[2] = new SqlParameter("@LastName", "");
                param[3] = new SqlParameter("@FirstName", "");
                param[4] = new SqlParameter("@SSN", "");
                param[5] = new SqlParameter("@Phone", "");
                param[6] = new SqlParameter("@DOB", DBNull.Value);
                //param[7] = new SqlParameter("@MedicaidId", "");
                param[7] = new SqlParameter("@PrimaryProviderId", DBNull.Value);
                param[8] = new SqlParameter("@SearchType", SearchType);
                param[9] = new SqlParameter("@CreatedDate", DateTime.Now.ToString());
                param[10] = new SqlParameter("@CreatedBy", CreatedBy);
                param[11] = new SqlParameter("@Paging", 'N');//05/03/2010
                param[12] = new SqlParameter("@MasterClientId", 0);//SweetyK  fro MasterclientId search//05/03/2010
                param[13] = new SqlParameter("@IncludeClientContacts", 'N');
                param[14] = new SqlParameter("@ProgramId", "0");
                param[15] = new SqlParameter("@InsuredId", "0");
                param[16] = new SqlParameter("@ClientStatus", 'Y');
                param[17] = new SqlParameter("@ProviderId", DBNull.Value);
                param[18] = new SqlParameter("@ClientType", 'I');
                param[19] = new SqlParameter("@OrganizationName", DBNull.Value);
                param[20] = new SqlParameter("@AuthorizationID", DBNull.Value);
                param[21] = new SqlParameter("@EIN", DBNull.Value);

                //  //Code Added by Priya on 24th August '07 for checking the case of 'All Providers'
                ////  if (ProviderId != 0)
                //      param[12] = new SqlParameter("@ProviderId", ProviderId);
                //  else if (ProviderId == 0)
                //      param[12] = new SqlParameter("@ProviderId", System.DBNull.Value);

                switch (SearchType)
                    {
                    case ("BROAD"):
                        param[2].Value = param1;
                        param[3].Value = param2;
                        break;
                    case ("NARROW"):
                        param[2].Value = param1;
                        param[3].Value = param2;
                        break;
                    case ("SSN"):
                        param[4].Value = param1;
                        break;
                    case ("PHONE"):
                        param[5].Value = param1;
                        break;
                    case ("DOB"):
                        param[6].Value = Convert.ToDateTime(param1);
                        break;
                    //case ("MEDICAIDID"):
                    //    param[7].Value = param1;
                    //    break;
                    case ("PRIMARYPROVIDER"):
                        param[7].Value = param1;
                        break;
                    case "CLIENTID":
                        param[1].Value = param1;
                        break;

                    }
                //DataSetMember = SqlHelper.ExecuteDataset(ClientMedication.ConnectionString, "ssp_MMClientSel", param);
                DataSetMember = SqlHelper.ExecuteDataset(ClientMedication.ConnectionString, "ssp_SCClientSearch", param);

                }
            catch (SqlException ex)
                {
                // Added by Pratap In order to Implement Exception Management functionality on 28th June 2007
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetClientSearchInfo(), ParameterCount - 5, First Parameter- " + UserId + ", Second Parameter- " + SearchType + ", Third Parameter- " + param1 + ", Fourth Parameter- " + param2 + ", Fifth Parameter- " + CreatedBy + "##";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = DataSetMember;
                throw (ex);
                }

            return DataSetMember;
            }
        /// <summary>
        /// A new function added to get the status of Fax Requests
        /// Author:Sonia
        /// </summary>
        /// <returns>DataSet</returns>
        public DataSet GetFaxRequestsStatus()
            {
            DataSet DataSetFaxRequests = null;
            SqlParameter[] param = null;

            try
                {
                //param = new SqlParameter[2];
                //param[0] = new SqlParameter("@UserId", UserId);
                //param[1] = new SqlParameter("@ClientId", 0);
                // DataSetFaxRequests = SqlHelper.ExecuteDataset(ClientMedication.ConnectionString, "ClientSel", param);
                DataSetFaxRequests = SqlHelper.ExecuteDataset(ClientMedication.ConnectionString, "ssp_SCGetFaxRequestsData");
                return DataSetFaxRequests;
                }
            catch (SqlException ex)
                {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetFaxRequestsStatus(), ParameterCount - 0";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = DataSetFaxRequests;
                throw (ex);
                }
            finally
                {
                DataSetFaxRequests = null;
                param = null;
                }


            }
        /// <summary>
        /// <Author>Sonia</Author> 
        /// <Purpose>To log the Exception information</Purpose> 
        /// </summary>
        /// <param name="entry"></param>
        /// <param name="type"></param>
        public void WriteToDatabase(string entry, string type)
            {
            SqlParameter[] objParm = null;
            try
                {
                objParm = new SqlParameter[4];
                objParm[0] = new SqlParameter("@ErrorMessage", entry);
                objParm[1] = new SqlParameter("@ErrorType", type);
                objParm[2] = new SqlParameter("@CreatedBy", "SmartcareRx");
                objParm[3] = new SqlParameter("@CreatedDate", DateTime.Now);
                SqlHelper.ExecuteNonQuery(ClientMedication.ConnectionString, CommandType.StoredProcedure, "ssp_SCErrorInsertNew", objParm);

                }
            catch (Exception ex)
                {
                throw ex;
                }
            }

        /// <summary>
        /// Created by Chandan for Updating the Client information fetched from External Interface 
        /// </summary>
        /// <param name="ClientId"></param>
        /// <param name="LastName"></param>
        /// <param name="FirstName"></param>
        /// <param name="MiddleName"></param>
        /// <param name="Prefix"></param>
        /// <param name="Suffix"></param>
        /// <param name="SSN"></param>
        /// <param name="DOB"></param>
        /// <param name="PhoneType"></param>
        /// <param name="PhoneNumber"></param>
        /// <param name="PhoneNumberText"></param>
        /// <param name="IsPrimary"></param>
        /// <param name="DoNotContact"></param>
        /// <param name="AddressType"></param>
        /// <param name="Address"></param>
        /// <param name="City"></param>
        /// <param name="State"></param>
        /// <param name="Zip"></param>
        /// <param name="Display"></param>
        /// <param name="UserCode"></param>
        /// Modified by Loveena in ref to Task#2431 to Change the stored Procedure.
        //public DataSet UpdateClientInformations(int ClientId,string ExternalClientId, string LastName,string FirstName,string MiddleName, string Prefix,string Suffix,string SSN,
        //    string DOB,int PhoneType,string PhoneNumber,string PhoneNumberText,string IsPrimary,string DoNotContact,int AddressType,
        //    string Address, string City, string State, string Zip, string Display, string UserCode, string Active, string FinanciallyResponsible, string DoesNotSpeakEnglish)
        public DataSet UpdateClientInformations(string ExternalClientId, string LastName, string FirstName, string MiddleName, string Prefix, string Suffix, string SSN,
            string DOB, int PhoneType, string PhoneNumber, string PhoneNumberText, string IsPrimary, string DoNotContact, int AddressType,
            string Address, string City, string State, string Zip, string Display, string UserCode, string Active, string FinanciallyResponsible, string DoesNotSpeakEnglish,string Sex,string ClientRace)
            {
            SqlParameter[] objParm = null;
            DataSet DataSetClient = null;
            try
                {
                objParm = new SqlParameter[25];
                objParm[0] = new SqlParameter("@ExternalClientId", ExternalClientId);
                objParm[1] = new SqlParameter("@LastName", LastName);
                objParm[2] = new SqlParameter("@FirstName", FirstName);
                if (MiddleName != "")
                    objParm[3] = new SqlParameter("@MiddleName", MiddleName);
                else
                    objParm[3] = new SqlParameter("@MiddleName", System.DBNull.Value);
                //Code Commented by Loveena in ref to Task#2431 to Change the Stored Procedure.
                if (Prefix != "")
                    objParm[4] = new SqlParameter("@Prefix", Prefix);
                else
                    objParm[4] = new SqlParameter("@Prefix", System.DBNull.Value);
                if (Suffix != "")
                    objParm[5] = new SqlParameter("@Suffix", Suffix);
                else
                    objParm[5] = new SqlParameter("@Suffix", System.DBNull.Value);
                objParm[6] = new SqlParameter("@SSN", SSN);
                if (DOB != "")
                    objParm[7] = new SqlParameter("@DOB", DOB);
                else
                    objParm[7] = new SqlParameter("@DOB", System.DBNull.Value);
                objParm[8] = new SqlParameter("@PhoneType", PhoneType);
                objParm[9] = new SqlParameter("@PhoneNumber", PhoneNumber);
                objParm[10] = new SqlParameter("@PhoneNumberText", PhoneNumberText);
                objParm[11] = new SqlParameter("@IsPrimary", IsPrimary);
                objParm[12] = new SqlParameter("@DoNotContact", DoNotContact);
                objParm[13] = new SqlParameter("@AddressType", AddressType);
                objParm[14] = new SqlParameter("@Address", Address);
                objParm[15] = new SqlParameter("@City", City);
                objParm[16] = new SqlParameter("@State", State);
                objParm[17] = new SqlParameter("@Zip", Zip);
                objParm[18] = new SqlParameter("@Display", Display);
                objParm[19] = new SqlParameter("@UserCode", UserCode);
                //objParm[20] = new SqlParameter("@ExternalClientId", ExternalClientId);
                objParm[20] = new SqlParameter("@Active", Active);
                objParm[21] = new SqlParameter("@FinanciallyResponsible", FinanciallyResponsible);
                objParm[22] = new SqlParameter("@DoesNotSpeakEnglish", DoesNotSpeakEnglish);
                objParm[23] = new SqlParameter("@RowIdentifier", System.Guid.NewGuid().ToString());
                objParm[24] = new SqlParameter("@Sex", Sex);

                //                DataSetClient = SqlHelper.ExecuteDataset(ClientMedication.ConnectionString, "ssp_UpdateExternalClientInformation", objParm);
                //Commented Code ends over here.
                DataSetClient = SqlHelper.ExecuteDataset(ClientMedication.ConnectionString, "scsp_MMInsertUpdateClients", objParm);
                return DataSetClient;

                //return SqlHelper.ExecuteNonQuery(ClientMedication.ConnectionString, CommandType.StoredProcedure, "ssp_UpdateExternalClientInformation", objParm);
                }
            catch (Exception ex)
                {
                throw ex;
                }
            finally
                {
                objParm = null;
                }
            }

        /// <summary>
        /// Created by Mohit Madaan for task #2448 - 1.9 Patient Search - Update ClientViewAudit after patient select
        /// This Method is used to update the Internal client information</summary>
        /// <param name="searchID"></param>      
        /// <param name="ExternalClientID"></param>      
        /// <param name="ModifiedBy"></param>
        /// <param name="ModifiedDate"></param>
        /// <returns></returns>
        /// 
        public void UpdateInternalClientViewAudit(Int32 SearchId, Int32 ClientId, string ModifiedBy, DateTime ModifiedDate)
            {
            SqlParameter[] objParm = null;
            DataSet DataSetClient = null;
            try
                {
                objParm = new SqlParameter[4];
                objParm[0] = new SqlParameter("@SearchId", SearchId);
                objParm[1] = new SqlParameter("@ClientId", ClientId);
                objParm[2] = new SqlParameter("@ModifiedBy", ModifiedBy);
                objParm[3] = new SqlParameter("@ModifiedDate", ModifiedDate);

                DataSetClient = SqlHelper.ExecuteDataset(ClientMedication.ConnectionString, "ssp_PMUpdateClientViewAudit", objParm);

                }
            catch (Exception ex)
                {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - UpdateInternalClientViewAudit(), ParameterCount - 4";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = DataSetClient;
                throw (ex);
                }
            finally
                {
                DataSetClient = null;
                objParm = null;
                }
            }

        /// <summary>
        /// <Description>To get Graph Data as per task#34</Description>
        /// </summary>
        /// <param name="HealthDataCategory"></param>
        /// <param name="ItemName"></param>
        /// <returns></returns>
        public DataSet GetGraphData(int HealthDataCategoryId, string ItemName, double MinValue, double MaxValue)
            {
            SqlParameter[] objParm = null;
            DataSet DataSetHealthGraph = null;
            try
                {
                objParm = new SqlParameter[4];
                objParm[0] = new SqlParameter("@HealthDataCategoryId", HealthDataCategoryId);
                objParm[1] = new SqlParameter("@ItemName", ItemName);
                objParm[2] = new SqlParameter("@MinValue", MinValue);
                objParm[3] = new SqlParameter("@MaxValue", MaxValue);
                return DataSetHealthGraph = SqlHelper.ExecuteDataset(ClientMedication.ConnectionString, "ssp_HealthDataGraphColors", objParm);
                }
            catch (Exception ex)
                {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetGraphData(), ParameterCount - 2";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = DataSetHealthGraph;
                throw (ex);
                }
            }
        /// <summary>
        /// <Description>To get Graph Data as per task#34</Description>
        /// </summary>
        /// <param name="ClientId"></param>
        /// <param name="HealthDataCategory"></param>
        /// <param name="ItemName"></param>
        /// <returns></returns>
        public DataSet GetGraphValue(int ClientId, int HealthDataCategoryId, string ItemName,DateTime StartDate, DateTime EndDate)
            {
            SqlParameter[] objParm = null;
            DataSet DataSetHealthGraph = null;
            try
                {
                objParm = new SqlParameter[5];
                objParm[0] = new SqlParameter("@ClientId", ClientId);
                objParm[1] = new SqlParameter("@HealthDataCategoryId", HealthDataCategoryId);
                objParm[2] = new SqlParameter("@ItemName", ItemName);
                objParm[3] = new SqlParameter("@StartDate", StartDate);
                objParm[4] = new SqlParameter("@EndDate", EndDate);
                return DataSetHealthGraph = SqlHelper.ExecuteDataset(ClientMedication.ConnectionString, "ssp_HealthDataGraphData", objParm);
                }
            catch (Exception ex)
                {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetGraphValue(), ParameterCount - 2";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = DataSetHealthGraph;
                throw (ex);
                }
            }

        /// <summary>
        /// <Description>Gather System Configuration information : Thresholds task#2158</Description>
        /// </summary>
        /// <returns>Dataset</returns>
        public DataSet GetSystemConfigurations()
        {
            DataSet SystemConfigurations = null;
            try
            {
                return SystemConfigurations = SqlHelper.ExecuteDataset(ClientMedication.ConnectionString, "ssp_SCGetDataFromSystemConfigurations");
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetGraphValue(), ParameterCount - 2";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = SystemConfigurations;
                throw (ex);
            }
        }


        /// <summary>
        /// This function will provide the select statement with all the available columns in the DataSet
        /// </summary>
        /// <param name="dataTable"></param>
        /// <returns></returns>
        public static string GetSelectSQL(DataTable dataTable)
        {
            return GetSelectSQL(dataTable, true);
        }
        /// <summary>
        /// This function will provide the select statement with all the available columns in the DataSet
        /// </summary>
        /// <param name="dataTable"></param>
        /// <param name="removeTempColumns"></param>
        /// <returns></returns>
        public static string GetSelectSQL(DataTable dataTable, bool removeTempColumns)
        {
            DataTable dtProcessed = new DataTable();
            List<string> columnNames = new List<string>();
            if (removeTempColumns == true)
            {
                dtProcessed = null;
                dtProcessed = RemoveTempColumns(dataTable.Clone());
            }
            string columns = string.Empty;
            StringBuilder SQL = new StringBuilder();
            foreach (DataColumn columnname in dtProcessed.Columns)
            {
                columnNames.Add("[" + columnname + "]");
            }
            SQL.Append("SELECT ");
            SQL.Append(string.Join(",", columnNames.ToArray()));
            //SQL.Append(string.Join(",", columnNames);
            SQL.Append(" FROM ");
            SQL.Append(dtProcessed.TableName);
            return SQL.ToString();
        }
        /// <summary>
        /// This method is used to remove the columns not in the DB
        /// </summary>
        /// <param name="dataTable"></param>
        /// <returns></returns>
        public static DataTable RemoveTempColumns(DataTable dataTable)
        {
            DataTable dt = dataTable;
            SqlCommand sqlSelectCommand = null;
            SqlConnection _sqlConnection = null;
            SqlParameter[] _sqlParameters = null;
            string selectQuery = string.Empty;
            try
            {
                _sqlConnection = new SqlConnection(ClientMedication.ConnectionString);
                _sqlConnection.Open();
                sqlSelectCommand = new SqlCommand();
                sqlSelectCommand.Connection = _sqlConnection;
                sqlSelectCommand.CommandType = CommandType.StoredProcedure;
                sqlSelectCommand.CommandText = "ssp_GetSQLTableColumnNames";
                _sqlParameters = new SqlParameter[1];
                _sqlParameters[0] = new SqlParameter("@TableName", dataTable.TableName);
                sqlSelectCommand.Parameters.Add(_sqlParameters[0]);
                string Columns = sqlSelectCommand.ExecuteScalar().ToString();
                string[] ColumnArray = Columns.Split(',');
                // Get the list of columns to be removed
                var results = (from row in dt.Columns.Cast<DataColumn>().AsEnumerable()
                               where !ColumnArray.Contains(row.ColumnName)
                               select row).ToList();
                // Remove the columns from the dataTable              
                results.ForEach(r => dt.Columns.Remove(r));
            }
            catch (Exception)
            {
            }
            finally
            {
                sqlSelectCommand = null;
                if (_sqlConnection.State != ConnectionState.Closed)
                {
                    _sqlConnection.Close();
                }
            }
            return dt;
        }

    }



    }

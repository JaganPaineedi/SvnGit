using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Data.SqlClient;

namespace Streamline.DataService
{
    public class SharedTables
    {

       
      
        /// <summary>
        /// Author:-Sonia Dhamija
       /// Purpose:- To fill the Shared Tables Data of DSM Descriptions
        /// </summary>
        /// <returns></returns>
        public DataSet getDSMDescriptions()
        {
            DataSet datasetDSMDescription = new DataSet();
            try
            {
                
                datasetDSMDescription = SqlHelper.ExecuteDataset(ClientMedication.ConnectionString, CommandType.StoredProcedure, "ssp_SCDiagnosisDSMDescriptionsSelAll");
                datasetDSMDescription.Tables[0].TableName = "DiagnosisDSMDescriptions";
                return datasetDSMDescription;

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// Author:-Rishu Chopra
        /// Purpose:- To fill the Shared Tables Data of Globalcodes
        /// </summary>
        /// <returns></returns>
        public DataSet getGlobalCodes()
        {
            try
            {
                return SqlHelper.ExecuteDataset(ClientMedication.ConnectionString, CommandType.StoredProcedure, "ssp_SCGetDataFromGlobalCodes");
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public DataSet getSureScriptCodes()
        {
            try
            {
                return SqlHelper.ExecuteDataset(ClientMedication.ConnectionString, CommandType.StoredProcedure, "ssp_SCGetDataFromSureScriptCodes");
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        // <summary>
        /// Author:-Loveena
        /// Purpose:- To fill the Shared Tables Data of States
        /// </summary>
        /// <returns></returns>
        public DataSet getStates()
            {
            try
                {
                    return SqlHelper.ExecuteDataset(ClientMedication.ConnectionString,CommandType.StoredProcedure,"ssp_SCGetDataFromStates");
                }
            catch (Exception ex)   
                {
                
                throw ex;
                }
            }

        /// <summary>
        /// Author:-Rishu Chopra
        /// Purpose:- To fill the Shared Tables Data of StaffTable.
        /// </summary>
        /// <returns></returns>
        public DataSet getStaffTable()
        {
            try
            {               
                DataSet _DataSetStaff = new DataSet();
                _DataSetStaff = SqlHelper.ExecuteDataset(ClientMedication.ConnectionString, CommandType.StoredProcedure, "ssp_MMGetStaffDetails");                
                //code commented by the pramod on 14 Apr 2008 as this code is not need
                    //for (int loopVar = 0; loopVar < _DataSetStaff.Tables[0].Rows.Count; loopVar++)
                    //{
                    //    _DataSetStaff.Tables[0].Rows[loopVar]["LastName"] = _DataSetStaff.Tables[0].Rows[loopVar]["LastName"].ToString();
                    //    _DataSetStaff.Tables[0].Rows[loopVar]["FirstName"] = _DataSetStaff.Tables[0].Rows[loopVar]["FirstName"].ToString();
                    //    _DataSetStaff.Tables[0].Rows[loopVar]["SSN"] = _DataSetStaff.Tables[0].Rows[loopVar]["SSN"].ToString();
                    //    _DataSetStaff.Tables[0].Rows[loopVar]["StaffName"] = _DataSetStaff.Tables[0].Rows[loopVar]["LastName"] + ", " + _DataSetStaff.Tables[0].Rows[loopVar]["FirstName"];
                    //}                
                //code comment ends here
                return _DataSetStaff;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// Added by Sonia 
        /// Purpose:-To populate the Data from Pharmacies 
        /// </summary>
        /// <returns></returns>
        /// Added new parameter ClientId in ref to Task#2589
        public DataSet getPharmacies(int ClientId)
        {
            try
            {
            SqlParameter[] _SqlParameters = new SqlParameter[1];
            _SqlParameters[0] = new SqlParameter("@ClientId", ClientId);
                return SqlHelper.ExecuteDataset(ClientMedication.ConnectionString, CommandType.StoredProcedure, "ssp_SCGetDataFromPharmacies",_SqlParameters);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        /// <summary>
        /// Added by Sonia 
        /// Purpose:-To populate the Data from StaffLocations and Locations based on StaffId 
        /// </summary>
        /// <returns></returns>
        public DataSet getLocations(int StaffId)
        {
            try
            {
                SqlParameter[] _SqlParameters = new SqlParameter[1];
                _SqlParameters[0] = new SqlParameter("@StaffID", StaffId);
                return SqlHelper.ExecuteDataset(ClientMedication.ConnectionString, CommandType.StoredProcedure, "ssp_SCGetMedicationPrescribingLocations", _SqlParameters);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

      /// <summary>
      /// <Author>Sonia</Author>
      /// <Purpose>To get the System Actions Data based on Staff Permissions</Purpose>
      /// </summary>
      /// <param name="StaffId"></param>
      /// <returns></returns>
        public SqlDataReader getSystemActions(int StaffId)
        {
            try
            {
                SqlParameter[] _SqlParameters = new SqlParameter[1];
                _SqlParameters[0] = new SqlParameter("@varStaffID", StaffId);
                return SqlHelper.ExecuteReader(ClientMedication.ConnectionString, CommandType.StoredProcedure, "ssp_SCCheckPermissions", _SqlParameters);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// Added by Mohit Madaan, April 12 2009
        /// Purpose:-To populate the Data From DocumentCodes for Patient Consent
        /// </summary>
        /// <returns></returns>
        public DataSet getDocumentCodesForPatientConsent()
        {
            try
            {
                return SqlHelper.ExecuteDataset(ClientMedication.ConnectionString, CommandType.StoredProcedure, "csp_SCGetDocumentCodeForPatientConsent");
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        //Changes to merge.
        // <summary>
        /// Added by Loveena 
        /// Purpose:-To populate the Data from System Actions 
        /// </summary>
        /// <returns></returns>
        public DataSet GetSystemActionsForPermissions()
            {
            try
                {
                return SqlHelper.ExecuteDataset(ClientMedication.ConnectionString, CommandType.StoredProcedure, "ssp_MMGetDataFromSystemActions");
                }
            catch (Exception ex)
                {
                throw ex;
                }
            }

        /// <summary>
        /// Author:-Loveena
        /// Purpose:- To get MedicationRxEndDateOffset from SystemConfigurations as per the Task#2582
        /// </summary>
        /// <returns></returns>
        public DataSet getMedicationRxEndDateOffset()
            {
            try
                {
                return SqlHelper.ExecuteDataset(ClientMedication.ConnectionString, CommandType.StoredProcedure, "ssp_SCGetMedicationRxEndDateOffsetInSytemConfig");
                }
            catch (Exception ex)
                {
                throw ex;
                }
            }
            #region--Code Written By Pradeep as per task#23
            /// <summary>
            /// <Description>Used to get PrinterDeviceLocations data</Description>
            /// <Author>Pradeep</Author>
            /// <CreatedOn>Nov 18,2009</CreatedOn>
            /// </summary>
            /// <returns></returns>
            public DataSet getPrinterDeviceLocations()
            {
                try
                {
                    return SqlHelper.ExecuteDataset(ClientMedication.ConnectionString, CommandType.StoredProcedure, "ssp_SCGetPrinterDeviceLocations");
                }
                catch (Exception ex)
                {
                    throw ex;
                }
            }
            /// <summary>
            /// <Description>Used to get PrinterDeviceLocations data</Description>
            /// <Author>Pradeep</Author>
            /// <CreatedOn>Nov 18,2009</CreatedOn>
            /// </summary>
            /// <returns></returns>
            public DataSet getStaffLocation()
            {
                try
                {
                    return SqlHelper.ExecuteDataset(ClientMedication.ConnectionString, CommandType.StoredProcedure, "ssp_SCGetStaffLocations");
                }
                catch (Exception ex)
                {
                    throw ex;
                }
            }
            #endregion


        /// <summary>
        /// Author:-Loveena
        /// Purpose:- To Fill Health DataEntry DropDown as per the Task#3
        /// </summary>
        /// <returns></returns>
        public DataSet getHealthCategoryData()
            {
            try
                {
                return SqlHelper.ExecuteDataset(ClientMedication.ConnectionString, CommandType.StoredProcedure, "ssp_SCGetHealthCategoryData");
                }
            catch (Exception ex)
                {
                throw ex;
                }
            }
            #region--Code Written By Pradeep on 27 Nov 2009 as per task#23(Venture 10.0)
            /// <summary>
            /// <Description>Used to get data from location as per task#23(Venture10.0)</Description>
            /// <Author>Pradeep</Author>
            /// <Createdon>Nov 27,2009</Createdon>
            /// </summary>
            /// <param name="staffId"></param>
            /// <returns></returns>
            public DataSet GetUserPreferancesLocationList(int staffId)
            {
                SqlParameter[] _ParametersObject = null;
                DataSet _DataSetLocationList = null;
                try
                {
                    _ParametersObject = new SqlParameter[1];
                    _ParametersObject[0] = new SqlParameter("@staffId", staffId);
                    _DataSetLocationList = SqlHelper.ExecuteDataset(ClientMedication.ConnectionString, CommandType.StoredProcedure, "ssp_SCGetUserPreferancesLocationList", _ParametersObject);
                    if (_DataSetLocationList != null)
                    {
                        if (_DataSetLocationList.Tables.Count > 0)
                        {
                            _DataSetLocationList.Tables[0].TableName = "Locations";
                        }
                        if (_DataSetLocationList.Tables.Count > 2)
                        {
                            _DataSetLocationList.Tables[1].TableName = "StaffLocations";
                        }
                        if (_DataSetLocationList.Tables.Count > 2)
                        {
                            _DataSetLocationList.Tables[2].TableName = "PrinterDeviceLocations";
                        }
                    }
                    return _DataSetLocationList;
                }
                catch (Exception ex)
                {
                    if (ex.Data["CustomExceptionInformation"] == null)
                        ex.Data["CustomExceptionInformation"] = "### Source Function Name - GetUserPreferancesLocationList(int staffId), ParameterCount - 1,First Parameter-" + staffId.ToString() + "###";
                    if (ex.Data["DatasetInfo"] == null)
                        ex.Data["DatasetInfo"] = null;
                    throw (ex);
                }
                finally
                {
                    if (_DataSetLocationList != null)
                    {
                        _DataSetLocationList.Dispose();
                    }
                }
            }
            #endregion--Code Written By Pradeep on 27 Nov 2009 as per task#23(Venture 10.0)

            /// <summary>
            /// Added by Loveena 
            /// Purpose:-To populate the Data from StaffLocations and Locations based on StaffId 
            /// </summary>
            /// <returns></returns>
            public DataSet GetAssociatedLocations(int StaffId)
            {
                try
                {
                    SqlParameter[] _SqlParameters = new SqlParameter[1];
                    _SqlParameters[0] = new SqlParameter("@StaffID", StaffId);
                    return SqlHelper.ExecuteDataset(ClientMedication.ConnectionString, CommandType.StoredProcedure, "ssp_MMGetStaffLocations", _SqlParameters);
                }
                catch (Exception ex)
                {
                    throw ex;
                }
            }
            public DataSet GetSystemConfigurationKeys()
            {
                try
                {
                    return SqlHelper.ExecuteDataset(ClientMedication.ConnectionString, CommandType.StoredProcedure, "SSP_GetSystemConfigurationKeyValues");
                }
                catch (Exception ex)
                {
                    throw ex;
                }
            }
            public string GetSystemConfigurationKeys(string Key, DataTable dataTable)
            {
                string Value = string.Empty;

                if (!string.IsNullOrEmpty(Key))
                {
                    DataRow[] KeyValuePair = dataTable.Select("Key='" + Key + "'");
                    if (KeyValuePair.Length > 0 && KeyValuePair[0]["Value"] != DBNull.Value && KeyValuePair[0]["Value"] != null)
                    {
                        Value = KeyValuePair[0]["Value"].ToString().Trim();
                    }
                }
                return Value;
            }
            ///<summary>
            ///<Description>Permission List</Description>           
            ///</summary>
            ///<returns></returns>
            public DataSet GetPermissionWithParentList(int staffId, int PermissionTemplateType, int ParentId, string PermissionStatus)
            {
                DataSet dataSetDocumentList = null;
                SqlParameter[] _objectSqlParmeters;
                try
                {
                    dataSetDocumentList = new DataSet();
                    _objectSqlParmeters = new SqlParameter[4];
                    _objectSqlParmeters[0] = new SqlParameter("@StaffId", staffId);
                    _objectSqlParmeters[1] = new SqlParameter("@PermissionTemplateType", PermissionTemplateType);
                    _objectSqlParmeters[2] = new SqlParameter("@ParentId", ParentId);
                    _objectSqlParmeters[3] = new SqlParameter("@PermissionStatus", PermissionStatus);
                    SqlHelper.FillDataset(ClientMedication.ConnectionString, CommandType.StoredProcedure, "ssp_GetStaffPermissionItems", dataSetDocumentList, new string[] { "StaffPermissionExceptions", "TablePagingInformation" }, _objectSqlParmeters);
                    return dataSetDocumentList;                    
                }
                finally
                {
                    if (dataSetDocumentList != null) dataSetDocumentList.Dispose();
                    _objectSqlParmeters = null;
                }
            }
            public string GetPermissionWithParentList(string Key, DataTable dataTable)
            {
                string Value = string.Empty;

                if (!string.IsNullOrEmpty(Key))
                {
                    DataRow[] KeyValuePair = dataTable.Select("PermissionItemName='" + Key + "'");
                    if (KeyValuePair.Length > 0 && KeyValuePair[0]["Granted"] != DBNull.Value && KeyValuePair[0]["Granted"] != null)
                    {
                        Value = KeyValuePair[0]["Granted"].ToString().Trim();
                    }
                }
                return Value;
            }
            // Ref To #1566
            public DataSet GetPermissionforStaffToSeachClient(int staffId)
            {
                DataSet dataSetDocumentList = null;
                SqlParameter[] _objectSqlParmeters;
                try
                {
                    dataSetDocumentList = new DataSet();
                    _objectSqlParmeters = new SqlParameter[1];
                    _objectSqlParmeters[0] = new SqlParameter("@LoggedInStaffId", staffId);                    
                    SqlHelper.FillDataset(ClientMedication.ConnectionString, CommandType.StoredProcedure, "SSP_SCGetLoggedinStaffPermissions", dataSetDocumentList, new string[] { "StaffPermissionExceptions", "TablePagingInformation" }, _objectSqlParmeters);
                    return dataSetDocumentList;
                }
                finally
                {
                    if (dataSetDocumentList != null) dataSetDocumentList.Dispose();
                    _objectSqlParmeters = null;
                }
            }
            /// <summary>
            /// <Description>To refresh the staff clients table</Description>
            /// <Author>Jyothi</Author>
            /// <CreatedOn>Dec 22,2018</CreatedOn>
            /// </summary>
            /// <returns></returns>
            public void getStaffClientsData(int StaffId)
            {
                 DataSet dataSetDocumentList = null;
                SqlParameter[] _objectSqlParmeters;
                try
                {                   
                    _objectSqlParmeters = new SqlParameter[2];
                    _objectSqlParmeters[0] = new SqlParameter("@StaffId", StaffId);                
                    SqlHelper.ExecuteDataset(ClientMedication.ConnectionString, CommandType.StoredProcedure, "ssp_RefreshStaffClients", _objectSqlParmeters);
                }
                finally
                {
                    if (dataSetDocumentList != null) dataSetDocumentList.Dispose();
                    _objectSqlParmeters = null;
                }
            }        
    }
}

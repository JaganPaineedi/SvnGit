using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using Microsoft.ApplicationBlocks.Data;

namespace Streamline.DataService
{
    public class HealthMaintenanceTemplate : IDisposable
    {
        #region Global Variables
        SqlParameter[] _objectSqlParmeters = null;
        public static string ConnectionString = System.Configuration.ConfigurationSettings.AppSettings["SCConnectionString"];
        #endregion
        public void Dispose()
        {
            this.DisposeObject();
        }
        public void DisposeObject()
        {
            _objectSqlParmeters = null;
        }


        /// <summary>
        /// <Description>This function will return Dataset bind List Page Grid For Health Data Template List Page</Description>
        /// <Author>Rohit Katoch</Author>
        /// <CreatedOn>10-Aug-2012</CreatedOn>
        /// <ModifiedBy>Rakesh Garg</ModifiedBy>
        /// <ModifiedDate>29August2012 </ModifiedDate>
        /// <Purpose>Change in Parametes and sp name pass ActionValue</Purpose>
        /// </summary>
        /// <returns>DataSet</returns>
        public DataSet GetHealthMaintenanceTriggeringList(int pageNumber, int pageSize, string sortExpression, string searchCriteria, string ActionValue)
        {
            DataSet dataSetHealthDataTemplateList = null;
            SqlParameter[] _objectSqlParmeters = null;
            try
            {
                dataSetHealthDataTemplateList = new DataSet();
                _objectSqlParmeters = new SqlParameter[5];
                
                _objectSqlParmeters[0] = new SqlParameter("@PageNumber", pageNumber);
                _objectSqlParmeters[1] = new SqlParameter("@PageSize", pageSize);
                _objectSqlParmeters[2] = new SqlParameter("@SortExpression", sortExpression);             
                _objectSqlParmeters[3] = new SqlParameter("@ActionValue", ActionValue);
                _objectSqlParmeters[4] = new SqlParameter("@SearchText", searchCriteria);
               // _objectSqlParmeters[5] = new SqlParameter("@PrimaryKey", primaryKey);
                SqlHelper.FillDataset(ConnectionString, CommandType.StoredProcedure, "ssp_ListPageSCGetHealthMaintenanceTrigInfo", dataSetHealthDataTemplateList, new string[] { "TablePagingInformation", "HealthMaintenanceTriggeringInformation" }, _objectSqlParmeters);
                return dataSetHealthDataTemplateList;
            }
            finally
            {
                if (dataSetHealthDataTemplateList != null) dataSetHealthDataTemplateList.Dispose();
                _objectSqlParmeters = null;
            }
        }
        /// <summary>
        /// <Author>Veena S Mani</Author>
        /// <CreatedOn>18-July-2014</CreatedOn>
        /// </summary>
        /// <param name="pageNumber"></param>
        /// <param name="pageSize"></param>
        /// <param name="sortExpression"></param>
        /// <param name="HealthMaintenanceTriggeringFactorGroupId"></param>
        /// <param name="OtherFilter"></param>
        /// <returns></returns>

        public DataSet GetHealthMaintenanceTriggeringFactorList(int pageNumber, int pageSize, string sortExpression, string FactorName, int OtherFilter)
        {
            DataSet dataSetHealthDataTemplateList = null;
            SqlParameter[] _objectSqlParmeters = null;
            try
            {
                dataSetHealthDataTemplateList = new DataSet();
                _objectSqlParmeters = new SqlParameter[5];

                _objectSqlParmeters[0] = new SqlParameter("@PageNumber", pageNumber);
                _objectSqlParmeters[1] = new SqlParameter("@PageSize", pageSize);
                _objectSqlParmeters[2] = new SqlParameter("@SortExpression", sortExpression);
                _objectSqlParmeters[3] = new SqlParameter("@FactorName", FactorName);
                _objectSqlParmeters[4] = new SqlParameter("@OtherFilter", OtherFilter);
                // _objectSqlParmeters[5] = new SqlParameter("@PrimaryKey", primaryKey);
                SqlHelper.FillDataset(ConnectionString, CommandType.StoredProcedure, "ssp_SCListHealthMaintenanceTriggeringFactors", dataSetHealthDataTemplateList, new string[] { "TablePagingInformation", "HealthMaintenanceTriggeringFactorGroups" }, _objectSqlParmeters);
                return dataSetHealthDataTemplateList;
            }
            finally
            {
                if (dataSetHealthDataTemplateList != null) dataSetHealthDataTemplateList.Dispose();
                _objectSqlParmeters = null;
            }
        }


        /// <summary>
        /// <Description>This function will return Dataset bind List Page Grid For Client Health Maintenace Template List Page</Description>
        /// <Author>Rakesh Garg</Author>
        /// <CreatedOn>27-Aug-2012</CreatedOn>
        /// </summary>
        /// <returns>DataSet</returns>
        public DataSet GetClientHealthMaintenaceListPageData(int pageNumber, int pageSize, string sortExpression, string status, string FromDate, string ToDate, int ClientID, int otherFilter)
        {
            DataSet dataSetHealthMaintenanceTemplateList = null;
            SqlParameter[] _objectSqlParmeters = null;
            try
            {
                dataSetHealthMaintenanceTemplateList = new DataSet();
                _objectSqlParmeters = new SqlParameter[8];
                _objectSqlParmeters[0] = new SqlParameter("@PageNumber", pageNumber);
                _objectSqlParmeters[1] = new SqlParameter("@PageSize", pageSize);
                _objectSqlParmeters[2] = new SqlParameter("@SortExpression", sortExpression);
                _objectSqlParmeters[3] = new SqlParameter("@Status", status);
                _objectSqlParmeters[4] = new SqlParameter("@FromDate", FromDate);
                _objectSqlParmeters[5] = new SqlParameter("@ToDate", ToDate);
                _objectSqlParmeters[6] = new SqlParameter("@ClientID", ClientID);
                _objectSqlParmeters[7] = new SqlParameter("@OtherFilter", otherFilter);
                SqlHelper.FillDataset(ConnectionString, CommandType.StoredProcedure, "ssp_ListPageSCClientHealthMaintenance", dataSetHealthMaintenanceTemplateList, new string[] { "TablePagingInformation", "ClientHealthMaintenaceList" }, _objectSqlParmeters);
                return dataSetHealthMaintenanceTemplateList;
            }
            finally
            {
                if (dataSetHealthMaintenanceTemplateList != null) dataSetHealthMaintenanceTemplateList.Dispose();
                _objectSqlParmeters = null;
            }
        }

        /// <summary>
        /// <Description>This function will return Dataset for binding List Page Grid For Health Maintenance Template List Page</Description>
        /// <Author>Swapan Mohan</Author>
        /// <CreatedOn>27-Aug-2012</CreatedOn>
        /// </summary>
        /// <returns>DataSet</returns>
        public DataSet GetHealthMaintenanceTemplate(int pageNumber, int pageSize, string sortExpression, int otherFilter, string templateName, string status)
        {
            DataSet dataSetHealthMaintenanceTemplateList = null;
            SqlParameter[] _objectSqlParmeters = null;
            try
            {
                dataSetHealthMaintenanceTemplateList = new DataSet();
                _objectSqlParmeters = new SqlParameter[6];
                _objectSqlParmeters[0] = new SqlParameter("@Pagenumber", pageNumber);
                _objectSqlParmeters[1] = new SqlParameter("@Pagesize", pageSize);
                _objectSqlParmeters[2] = new SqlParameter("@Sortexpression", sortExpression);
                _objectSqlParmeters[3] = new SqlParameter("@Otherfilter", otherFilter);
                _objectSqlParmeters[4] = new SqlParameter("@templateName", templateName);
                _objectSqlParmeters[5] = new SqlParameter("@status", status);
                SqlHelper.FillDataset(ConnectionString, CommandType.StoredProcedure, "ssp_SCGetHealthMaintenanceTemplate", dataSetHealthMaintenanceTemplateList, new string[] { "TablePagingInformation", "PrimaryCareHealthMaintenanceTemplate" }, _objectSqlParmeters);
                return dataSetHealthMaintenanceTemplateList;
            }
            finally
            {
                if (dataSetHealthMaintenanceTemplateList != null)
                    dataSetHealthMaintenanceTemplateList.Dispose();
                _objectSqlParmeters = null;
            }
        }

        /// <summary>
        /// <Description>This function will return Dataset bind List Page Grid For Client Health Maintenace Template List Page Popup</Description>
        /// <Author>Davinder K</Author>
        /// <CreatedOn>27-Aug-2012</CreatedOn>
        /// </summary>
        /// <returns>DataSet</returns>
        public DataSet GetHealthMaintenaceTemplateListPageData(Int32 ClientID, String SearchText)
        {
            DataSet dataSetHealthMaintenanceTemplateList = null;
            SqlParameter[] _objectSqlParmeters = null;
            try
            {
                dataSetHealthMaintenanceTemplateList = new DataSet();
                _objectSqlParmeters = new SqlParameter[2];
                _objectSqlParmeters[0] = new SqlParameter("@ClientID", ClientID);
                _objectSqlParmeters[1] = new SqlParameter("@SearchText", SearchText);

                SqlHelper.FillDataset(ConnectionString, CommandType.StoredProcedure, "ssp_ListPageSCClientHealthMaintenanceTemplate", dataSetHealthMaintenanceTemplateList, new string[] { "HealthMaintenaceTemplateList" }, _objectSqlParmeters);
                return dataSetHealthMaintenanceTemplateList;
            }
            finally
            {
                if (dataSetHealthMaintenanceTemplateList != null) dataSetHealthMaintenanceTemplateList.Dispose();
                _objectSqlParmeters = null;
            }
        }

        public DataSet GetHealthMaintenaceOrdersSelected(Int32 OrderType, String SearchText)
        {
            DataSet dataSetHealthMaintenanceOrders = null;
            SqlParameter[] _objectSqlParmeters = null;
            try
            {
                dataSetHealthMaintenanceOrders = new DataSet();
                _objectSqlParmeters = new SqlParameter[2];
                _objectSqlParmeters[0] = new SqlParameter("@OrderType", OrderType);
                _objectSqlParmeters[1] = new SqlParameter("@OrderName", SearchText);

                SqlHelper.FillDataset(ConnectionString, CommandType.StoredProcedure, "ssp_SCGetOrderNames", dataSetHealthMaintenanceOrders, new string[] { "HealthMaintenaceOrders" }, _objectSqlParmeters);
                return dataSetHealthMaintenanceOrders;
            }
            finally
            {
                if (dataSetHealthMaintenanceOrders != null) dataSetHealthMaintenanceOrders.Dispose();
                _objectSqlParmeters = null;
            }
        }

        /// <summary>
        /// Gets the  Client HealthMaintenance Template.
        /// <Author>Author: Rahul An</Author>
        /// <CreatedDate>Date: 11-sep-2012</CreatedDate>
        /// </summary>
        /// <returns>Returns DataSet containing the Template  List</returns>
        public DataSet GetClientHealthMaintenaceTemplate(int pageNumber, int pageSize, string sortExpression, int otherFilter, string status, int TemplatedID)
        {
            DataSet dsClientHealthMaintenace = null;
            SqlParameter[] _objectSqlParmeters = null;
            try
            {
                dsClientHealthMaintenace = new DataSet();
                _objectSqlParmeters = new SqlParameter[6];
                _objectSqlParmeters[0] = new SqlParameter("@Pagenumber", pageNumber);
                _objectSqlParmeters[1] = new SqlParameter("@Pagesize", pageSize);
                _objectSqlParmeters[2] = new SqlParameter("@Sortexpression", sortExpression);
                _objectSqlParmeters[3] = new SqlParameter("@Otherfilter", otherFilter);
                _objectSqlParmeters[4] = new SqlParameter("@Active", status);
                _objectSqlParmeters[5] = new SqlParameter("@PCHealthMaintenanceTemplateId", TemplatedID);
                SqlHelper.FillDataset(ConnectionString, CommandType.StoredProcedure, "ssp_SCGetPCHealthMaintenanceClientTemplate", dsClientHealthMaintenace, new string[] { "TablePagingInformation", "ClientHealthMaintenanceTemplate" }, _objectSqlParmeters);
                return dsClientHealthMaintenace;
            }
            finally
            {
                if (dsClientHealthMaintenace != null)
                    dsClientHealthMaintenace.Dispose();
                _objectSqlParmeters = null;
            }
        }
        /// <summary>
        /// <Author>Author:Veena S Mani</Author>
        /// <CreatedDate>Date: 18 july 2014</CreatedDate> 
        /// </summary>
        /// <param name="HealthMaintenanceTriggeringFactorGroupId"></param>
        /// <returns></returns>
        public DataSet GetHealthMaintenaceGroups()
        {
            DataSet dsHealthMaintenaceGroups = null;
            SqlParameter[] _objectSqlParmeters = null;
            try
            {
                dsHealthMaintenaceGroups = new DataSet();
                
                SqlHelper.FillDataset(ConnectionString, CommandType.StoredProcedure, "ssp_SCGetHealthMaintenanceTriggeringFactorGroups", dsHealthMaintenaceGroups, new string[] { "HealthMaintenanceTriggeringFactorGroups" }, null);
                return dsHealthMaintenaceGroups;
            }
            finally
            {
                if (dsHealthMaintenaceGroups != null)
                    dsHealthMaintenaceGroups.Dispose();
                _objectSqlParmeters = null;
            }
        }
        /// <summary>
        /// Gets the  Client HealthMaintenance Template Name.
        /// <Author>Author: Rahul An</Author>
        /// <CreatedDate>Date: 12-sep-2012</CreatedDate>
        /// </summary>
        /// <returns>Returns DataSet containing the TemplateName</returns>
        public DataSet GetClientHealthMaintenaceTemplateName(int ClientId)
        {
            DataSet dsClientHealthMaintenaceTemplate = null;
            SqlParameter[] _objectSqlParmeters = null;
            try
            {
                dsClientHealthMaintenaceTemplate = new DataSet();
                _objectSqlParmeters = new SqlParameter[1];
                _objectSqlParmeters[0] = new SqlParameter("@ClientId", ClientId);
                SqlHelper.FillDataset(ConnectionString, CommandType.StoredProcedure, "ssp_SCGetClientTemplateName", dsClientHealthMaintenaceTemplate, new string[] { "ClientHealthMaintenanceTemplate" }, _objectSqlParmeters);
                return dsClientHealthMaintenaceTemplate;
            }
            finally
            {
                if (dsClientHealthMaintenaceTemplate != null)
                    dsClientHealthMaintenaceTemplate.Dispose();
                _objectSqlParmeters = null;
            }
        }

        /// <summary>
        /// Gets the  PrimaryCare ProcedureCode.
        /// <Author>Author: Rahul An</Author>
        /// <CreatedDate>Date: 20-sep-2012</CreatedDate>
        /// </summary>
        /// <returns>Returns DataSet containing the ProcedureCode and Description</returns>
        public DataSet GetPrimaryCareProcedureCodes()
        {
            DataSet dsPrimaryCareProcedureCodes = null;
            try
            {
                dsPrimaryCareProcedureCodes = new DataSet();
                SqlHelper.FillDataset(ConnectionString, CommandType.StoredProcedure, "ssp_SCGetPrimaryCareProcedureCodes", dsPrimaryCareProcedureCodes, new string[] { "PCProcedureCodes" });
                return dsPrimaryCareProcedureCodes;
            }
            finally
            {
                if (dsPrimaryCareProcedureCodes != null)
                    dsPrimaryCareProcedureCodes.Dispose();
            }
        }
    /// <summary>
    /// Added By Mamta Gupta - To create Client Compliance - Primary Care - Summit Pointe Ref Task No. 15
    /// </summary>
    /// <param name="ClientId"></param>
    /// <param name="PrimaryCareHealthMaintenanceTemplateId"></param>
    /// <returns></returns>
        public DataSet GetClientHealthMaintenaceTemplateCompliance(Int32 ClientId, Int32 PrimaryCareHealthMaintenanceTemplateId)
        {
            DataSet dsClientHealthMaintenaceCompliance = null;
            SqlParameter[] _objectSqlParmeters = null;
            try
            {
                dsClientHealthMaintenaceCompliance = new DataSet();
                _objectSqlParmeters = new SqlParameter[2];
                _objectSqlParmeters[0] = new SqlParameter("@ClientId", ClientId);
                _objectSqlParmeters[1] = new SqlParameter("@HealthMaintenanceTemplateId", PrimaryCareHealthMaintenanceTemplateId);
                SqlHelper.FillDataset(ConnectionString, CommandType.StoredProcedure, "ssp_ClientHealthMaintenanceCompliance", dsClientHealthMaintenaceCompliance, new string[] { "HealthMaintenanceCriteria","ClientAttachedTemplate","ClientActionCompleted" }, _objectSqlParmeters);
                return dsClientHealthMaintenaceCompliance;
            }
            finally
            {
                if (dsClientHealthMaintenaceCompliance != null)
                    dsClientHealthMaintenaceCompliance.Dispose();
                _objectSqlParmeters = null;
            }
        }

        /// <summary>
        /// <Description>To check for Health Maintenance Alerts, Ref : Meaningful Use -> Task No. 31.1</Description>
        /// <Author>Prasan</Author>
        /// <CreatedOn>30-July-2014</CreatedOn>
        /// </summary>
        /// <returns>DataSet</returns>
        public DataSet HealthMaintenanceAlertCheck(int clientID, int staffID)
        {
            DataSet dsHealthMaintenanceAlert = null;
            SqlParameter[] _objectSqlParmeters = null;
            try
            {
                dsHealthMaintenanceAlert = new DataSet();
                _objectSqlParmeters = new SqlParameter[2];
                _objectSqlParmeters[0] = new SqlParameter("@clientId", clientID);
                _objectSqlParmeters[1] = new SqlParameter("@staffId", staffID);
                SqlHelper.FillDataset(ConnectionString, CommandType.StoredProcedure, "ssp_HealthMaintenaceAlert", dsHealthMaintenanceAlert, new string[] { "tempTriggerFactorTrack", "effectedClientHealthMaintenanceAlertTrack", "TotalHMAlertCount" }, _objectSqlParmeters);
                return dsHealthMaintenanceAlert;
            }
            finally
            {
                if (dsHealthMaintenanceAlert != null)
                    dsHealthMaintenanceAlert.Dispose();
                _objectSqlParmeters = null;
            }

        }

        /// <summary>
        /// <Description>To Get Health Maintenance Alert Data, Ref : Meaningful Use -> Task No. 31.1</Description>
        /// <Author>Prasan</Author>
        /// <CreatedOn>1-AUG-2014</CreatedOn>
        /// </summary>
        /// <returns>DataSet</returns>
        public DataSet GetHealthMaintenaceAlertData(int clientID, int staffID)
        {
            DataSet dsHealthMaintenanceAlert = null;
            SqlParameter[] _objectSqlParmeters = null;
            try
            {
                dsHealthMaintenanceAlert = new DataSet();
                _objectSqlParmeters = new SqlParameter[2];
                _objectSqlParmeters[0] = new SqlParameter("@clientId", clientID);
                _objectSqlParmeters[1] = new SqlParameter("@staffId", staffID);
                SqlHelper.FillDataset(ConnectionString, CommandType.StoredProcedure, "ssp_getHealthMaintenaceAlertData", dsHealthMaintenanceAlert, new string[] { "tempHMTemplateDetails", "tempHMCriteriaDetails" }, _objectSqlParmeters);
                return dsHealthMaintenanceAlert;
            }
            finally
            {
                if (dsHealthMaintenanceAlert != null)
                    dsHealthMaintenanceAlert.Dispose();
                _objectSqlParmeters = null;
            }

        }

        /// <summary>
        /// <Description>To Save Health Maintenance Alert Data, Ref : Meaningful Use -> Task No. 31.1</Description>
        /// <Author>Prasan</Author>
        /// <CreatedOn>1-AUG-2014</CreatedOn>
        /// </summary>
        /// <returns>DataSet</returns>
        public DataSet SaveHealthMaintenaceUserDecisions(string acceptedKeys, string rejectedKeys, int clientId)
        {
            DataSet dsHealthMaintenanceAlert = null;
            SqlParameter[] _objectSqlParmeters = null;
            try
            {
                dsHealthMaintenanceAlert = new DataSet();
                _objectSqlParmeters = new SqlParameter[3];
                _objectSqlParmeters[0] = new SqlParameter("@acceptedKeys", acceptedKeys);
                _objectSqlParmeters[1] = new SqlParameter("@rejectedKeys", rejectedKeys);
                _objectSqlParmeters[2] = new SqlParameter("@clientId", clientId);
                SqlHelper.FillDataset(ConnectionString, CommandType.StoredProcedure, "ssp_saveHealthMaintenaceUserDecisions", dsHealthMaintenanceAlert, new string[] { "statusTbl" }, _objectSqlParmeters);
                return dsHealthMaintenanceAlert;
            }
            finally
            {
                if (dsHealthMaintenanceAlert != null)
                    dsHealthMaintenanceAlert.Dispose();
                _objectSqlParmeters = null;
            }
        }
        
        public DataSet InitHealthMaintenanceAlertCheck(int staffID)
        {
            DataSet dsHealthMaintenanceAlert = null;
            SqlParameter[] _objectSqlParmeters = null;
            try
            {
                dsHealthMaintenanceAlert = new DataSet();
                _objectSqlParmeters = new SqlParameter[1];
                _objectSqlParmeters[0] = new SqlParameter("@staffID", staffID);
                SqlHelper.FillDataset(ConnectionString, CommandType.StoredProcedure, "ssp_initHealthMaintenanceAlertCheck", dsHealthMaintenanceAlert, new string[] { "statusTbl","screensTbl" }, _objectSqlParmeters);
                return dsHealthMaintenanceAlert;
            }
            finally
            {
                if (dsHealthMaintenanceAlert != null)
                    dsHealthMaintenanceAlert.Dispose();
                _objectSqlParmeters = null;
            }

        }
    }
}

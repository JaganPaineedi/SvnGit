using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using SC.Data;
using System.Data.SqlClient;
using System.Net;
using System.Data;
using Microsoft.ApplicationBlocks.Data;

namespace SC.Api
{
    /// <summary>
    /// This KPIReportingRepository class.
    /// Contains method for saving IIS data files logs.
    /// </summary>
    public class KPIReportingRepository : IKPIReportingRepository
    {
        private SCMobile _scm;

        /// <summary>
        /// Assigns object of SCMobile to a variable.
        /// </summary>

        public KPIReportingRepository(SCMobile ctx)
        {
            _scm = ctx;
        }

        /// <summary>
        /// Saves IIS data files logs.
        /// </summary>
        public void SaveMetricDataLogs(DataTable dtTable, int kpid, int customerId, string environmentType)
        {
            try
            {
                using (SqlBulkCopy bulkCopy = new SqlBulkCopy(_scm.Database.Connection.ConnectionString))
                {
                    var objkpimaster = _scm.KPIMasters.First(kpim => kpim.KPIMasterId == kpid);
                    string strTableName = objkpimaster.RawDataTableName;
                    string strProcessingSP = objkpimaster.ProcessingStoredProcedure;
                    bool IsActive = objkpimaster.Active == "Y" ? true : false;
                    bool IsRawData = objkpimaster.RawData == "Y" ? true : false;
                    bulkCopy.DestinationTableName = "dbo." + strTableName;

                    _scm.Database.Connection.Open();
                    DataTable dt = _scm.Database.Connection.GetSchema("Columns", new[] { "PortalApp", null, strTableName });
                    int envType = 0;
                    if (environmentType != "")
                        envType = _scm.GlobalCodes
                               .Where(g => g.Category == "EnvironmentType" && g.Active == "Y" && g.RecordDeleted != "Y" && g.Code == environmentType)
                               .FirstOrDefault().GlobalCodeId;
                    int intOrdinal = 0;
                    foreach (DataRow drow in dt.Rows)
                    {
                        if (!dtTable.Columns.Contains(drow["COLUMN_NAME"].ToString()))
                        {
                            dtTable.Columns.Add(drow["COLUMN_NAME"].ToString());
                            dtTable.Columns[drow["COLUMN_NAME"].ToString()].SetOrdinal(intOrdinal);
                            intOrdinal++;
                        }
                    }
                    string strReportingip = string.Empty;
                    foreach (var ip in Dns.GetHostEntry(Dns.GetHostName()).AddressList)
                        if (ip.AddressFamily == System.Net.Sockets.AddressFamily.InterNetwork) strReportingip = ip.ToString();
                    List<int> lstKpid = new List<int>();
                    int KPILogkpid;
                    foreach (DataRow drow in dtTable.Rows)
                    {
                        drow["ReportingIP"] = strReportingip;
                        drow["ReportingTime"] = drow["ModifiedDate"] = drow["CreatedDate"] = DateTime.Now;
                        drow["CustomerId"] = customerId;
                        if (environmentType != "" && !String.IsNullOrEmpty(strProcessingSP) && IsActive && IsRawData)
                        {
                            int.TryParse(drow["KPIMasterId"].ToString(), out KPILogkpid);
                            if (!lstKpid.Contains(KPILogkpid)) lstKpid.Add(KPILogkpid);
                        }
                        else
                            drow["KPIMasterId"] = kpid;
                        drow["CreatedBy"] = drow["ModifiedBy"] = "SmartCareKPIReporterService";
                        if (strTableName.Contains("KPILog")) drow["EnvironmentType"] = envType;
                    }
                    bulkCopy.BulkCopyTimeout = 0;
                    bulkCopy.WriteToServer(dtTable);
                    if (environmentType != "" && !String.IsNullOrEmpty(strProcessingSP) && IsActive)
                    {
                        if (IsRawData)
                        {
                            foreach (int kpikpid in lstKpid)                         
                                InsertDataCollection(kpikpid, customerId, envType, strProcessingSP); 
                        }
                        else
                            InsertDataCollection(kpid, customerId, envType, strProcessingSP); 
                    }                   
                }               
            }
                
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in KPIReportingRepository.SaveMetricDataLogs method." + ex.Message);
                throw excep;
            }

        }

        /// <summary>
        /// Calls the stored procedure mentioned in the column of ProcessingStoredProcedure of kpimaster table.
        /// </summary>
        public void InsertDataCollection(int kpid, int customerId, int envType, string strProcessingSP)
        {
            try
            {
                DataSet dataSetDocumentList = new DataSet();
                SqlParameter[] _objectSqlParmeters = new SqlParameter[3];
                _objectSqlParmeters[0] = new SqlParameter("@KPIMasterId", kpid);
                _objectSqlParmeters[1] = new SqlParameter("@CustomerId", customerId);
                _objectSqlParmeters[2] = new SqlParameter("@EnvironmentType", envType);
                SqlHelper.ExecuteNonQuery(_scm.Database.Connection.ConnectionString, CommandType.StoredProcedure, strProcessingSP, _objectSqlParmeters);
            }

            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in KPIReportingRepository.InsertDataCollection method." + ex.Message);
                throw excep;
            }
        }
    }
}
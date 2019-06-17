using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.SqlClient;
using System.Data;
using Newtonsoft.Json;
using System.IO;

namespace SC.Data
{
    public static class DataService
    {
        #region Variables
        private static SqlParameter[] _parameters = null;
        private static SqlCommand cmd = null;
        private static SqlConnection conn = null;
        private static SqlDataAdapter adaptor = null;
        private static SqlCommandBuilder cmdbuilder = null;
        private static SqlDataReader reader = null;
        private static string selectQuery = string.Empty;
        private static SCMobile _ctx = new SCMobile();
        #endregion

        public static string Connection { get { return _ctx.Database.Connection.ConnectionString; } }

        public static bool isExist(int ? primaryKey, string primaryKeyName, string tableName, string Active = "")
        {
            conn = new SqlConnection(Connection);
            conn.Open();
            _parameters = new SqlParameter[4];
            _parameters[0] = new SqlParameter("@PrimaryKeyValue", primaryKey);
            _parameters[1] = new SqlParameter("@PrimaryKeyName", primaryKeyName);
            _parameters[2] = new SqlParameter("@TableName", tableName);
            _parameters[3] = new SqlParameter("@Active", Active);

            cmd = new SqlCommand("SMSP_IsTableDataExist", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            foreach (var param in _parameters)
            {
                cmd.Parameters.Add(param);
            }

            var exist = cmd.ExecuteScalar();

            if (exist != null && (int)exist > 0)
                return true;
            else
                return false;
        }

        public static void save(string json, int ? primaryKeyValue, string primaryKeyName)
        {
            DataSet orgData = new DataSet();
            conn = new SqlConnection(Connection);
            conn.Open();
            DataSet ds = new DataSet();
            Dictionary<string, object> customNote = JsonConvert.DeserializeObject<Dictionary<string, object>>(json);
            //Dictionary<string, object> customNote = JsonConvert.DeserializeObject<Dictionary<string, object>>(JsonConvert.DeserializeObject<Dictionary<string, object>>(json).FirstOrDefault());
            foreach (var item in customNote)
            {
                DataTable dt = new DataTable();
                dt = JsonConvert.DeserializeObject<DataTable>(item.Value.ToString().ToString());
                dt = createAndInitializeTable(primaryKeyName, primaryKeyValue, dt);

                dt.TableName = item.Key;
                selectQuery = GetSelectSQL(dt, true);
                cmd = new SqlCommand(selectQuery, conn);
                cmd.CommandType = CommandType.Text;
                adaptor = new SqlDataAdapter(cmd);

                cmdbuilder = new SqlCommandBuilder(adaptor);


                if (isExist(primaryKeyValue, primaryKeyName, item.Key))
                {
                    orgData = getTableData(primaryKeyValue, primaryKeyName, item.Key);

                    DataRow row = orgData.Tables[0].Rows[0];

                    foreach (DataRow dr in dt.Rows)
                    {
                        foreach (DataColumn col in row.Table.Columns)
                        {
                            if (dt.Columns.Contains(col.Caption) && !string.IsNullOrEmpty(dr[col.Caption].ToString()))
                            {
                                switch (col.DataType.Name.ToLower())
                                {
                                    case "int32":
                                        row[col.ColumnName] = Convert.ToInt32(dr[col.Caption]);
                                        break;
                                    case "string":
                                        row[col.ColumnName] = (string)dr[col.Caption];
                                        break;
                                    case "datetime":
                                        row[col.ColumnName] = Convert.ToDateTime(dr[col.Caption]);
                                        break;
                                    case "decimal":
                                        row[col.ColumnName] = Convert.ToDecimal(dr[col.Caption]);
                                        break;
                                    case "double":
                                        row[col.ColumnName] = Convert.ToDouble(dr[col.Caption]);
                                        break;
                                    default:
                                        row[col.ColumnName] = DBNull.Value;
                                        break;
                                }
                            }
                            else
                                row[col.Caption] = DBNull.Value;
                            //row[col.ColumnName] = dr[col];
                            //row.Add(col.ColumnName, dr[col]);
                        }
                        orgData.Merge(new DataRow[] { row });
                    }
                    //DataTable dtclone = orgData.Tables[0].Clone();

                    //dtclone.Merge(dt, true, MissingSchemaAction.Ignore);
                    //ConvertColumnType(dt, orgData);
                    //orgData.Tables[item.Key].Merge(dtclone);
                    adaptor.UpdateCommand = cmdbuilder.GetUpdateCommand();
                }
                else { orgData.Tables.Add(dt); adaptor.InsertCommand = cmdbuilder.GetInsertCommand(); }

                adaptor.Update(orgData, orgData.Tables[0].TableName.ToString());
            }

            //if (orgData != null && orgData.Tables.Count > 0)
            //    return JsonConvert.SerializeObject(orgData.Tables[0]);
            //else
            //    return null;
        }
        /// <summary>
        /// Accessing the record 0 index is used Considering we will have only one entry. Future it may change.
        /// </summary>
        /// <param name="primaryKeyName"></param>
        /// <param name="primaryKeyValue"></param>
        /// <param name="dtable"></param>
        private static DataTable createAndInitializeTable(string primaryKeyName, int ? primaryKeyValue, DataTable dtable)
        {
            DataTable dtClone = dtable.Clone();
            
            if (primaryKeyName.ToLower().Trim() == "serviceid")
            {
                if (!dtClone.Columns.Contains(primaryKeyName)) { dtClone.Columns.Add("ServiceId", typeof(int)); }
                else { dtClone.Columns["ServiceId"].DataType = typeof(int); }
            }
            else if (primaryKeyName.ToLower().Trim() == "documentversionid")
            {
                if (!dtClone.Columns.Contains(primaryKeyName)) { dtClone.Columns.Add("DocumentVersionId", typeof(int)); }
                else { dtClone.Columns["DocumentVersionId"].DataType = typeof(int); }
            }

            if (!dtClone.Columns.Contains("CreatedBy"))
            { dtClone.Columns.Add("CreatedBy", typeof(string)); }
            else { dtClone.Columns["CreatedBy"].DataType = typeof(string); }

            if (!dtClone.Columns.Contains("CreatedDate"))
            { dtClone.Columns.Add("CreatedDate", typeof(DateTime)); }
            else { dtClone.Columns["CreatedDate"].DataType = typeof(DateTime); }

            if (!dtClone.Columns.Contains("ModifiedBy"))
            { dtClone.Columns.Add("ModifiedBy", typeof(string)); }
            else { dtClone.Columns["ModifiedBy"].DataType = typeof(string); }

            if (!dtClone.Columns.Contains("ModifiedDate"))
            { dtClone.Columns.Add("ModifiedDate", typeof(DateTime)); }
            else { dtClone.Columns["ModifiedDate"].DataType = typeof(DateTime); }

            if (!dtClone.Columns.Contains("RecordDeleted"))
            { dtClone.Columns.Add("RecordDeleted", typeof(string)); }
            else { dtClone.Columns["RecordDeleted"].DataType = typeof(string); }

            if (!dtClone.Columns.Contains("DeletedBy"))
            { dtClone.Columns.Add("DeletedBy", typeof(string)); }
            else { dtClone.Columns["DeletedBy"].DataType = typeof(string); }

            if (!dtClone.Columns.Contains("DeletedDate"))
            { dtClone.Columns.Add("DeletedDate", typeof(DateTime)); }
            else { dtClone.Columns["DeletedDate"].DataType = typeof(DateTime); }

            dtClone.Merge(dtable,false,MissingSchemaAction.Ignore);

            foreach (DataRow row in dtClone.Rows)
            {
                row[primaryKeyName] = primaryKeyValue;
                row["CreatedBy"] = "Service";
                row["CreatedDate"] = DateTime.Now;
                row["ModifiedBy"] = "Service";
                row["ModifiedDate"] = DateTime.Now;
                row["RecordDeleted"] = DBNull.Value;
                row["DeletedBy"] = DBNull.Value;
                row["DeletedDate"] = DBNull.Value;
            }

            DataColumn dcprimarykey = dtClone.Columns[primaryKeyName];
            dcprimarykey.AutoIncrement = false;
            dtClone.PrimaryKey = new DataColumn[1] { dcprimarykey };

            return dtClone;
        }

        public static object get(int primaryKey, SqlParameter[] parameters, string storedProcedureName,string tableList)
        {
            object note = null;
            DataSet orgObj = new DataSet();
            Dictionary<string, object> _clientDictionary = new Dictionary<string, object>();
           
            conn = new SqlConnection(Connection);
            conn.Open();
            cmd = new SqlCommand(storedProcedureName, conn);
            cmd.CommandType = CommandType.StoredProcedure;

            foreach (var parameter in parameters)
            {
                cmd.Parameters.Add(parameter);
            }

            reader = cmd.ExecuteReader();

            DataTable dt = new DataTable();
            dt.Load(reader);
            dt.TableName = char.ToLower(tableList[0]) + tableList.Substring(1); ;

            if (dt != null && dt.Rows.Count > 0)
            {
                _clientDictionary.Add(dt.TableName, JsonConvert.SerializeObject(dt));//.Trim(new char[] { '[', ']' })
                note = _clientDictionary;
            }
            if (note != null)
                return Newtonsoft.Json.Linq.JObject.Parse(JsonConvert.SerializeObject(note));
            else
                return null;
        }

        public static DataSet getTableData(int  ? primaryKey, string primaryKeyName, string tableName) {
            DataSet dsData = new DataSet();
            conn = new SqlConnection(Connection);
            cmd = new SqlCommand("SELECT * FROM " + tableName + " WHERE " + primaryKeyName + "=" + primaryKey, conn);
            cmd.CommandType = CommandType.Text;

            adaptor = new SqlDataAdapter(cmd);
            adaptor.Fill(dsData, tableName);

            return dsData;
        }

        public static string GetSelectSQL(DataTable dataTable, bool removeTempColumns)
        {
            dataTable.CaseSensitive = false;
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
            SQL.Append(" FROM ");
            SQL.Append(dtProcessed.TableName);
            return SQL.ToString();
        }

        public static DataTable RemoveTempColumns(DataTable dataTable)
        {
            DataTable dt = dataTable;
            string selectQuery = string.Empty;
            try
            {
                cmd = new SqlCommand("ssp_GetSQLTableColumnNames", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                _parameters = new SqlParameter[1];

                _parameters[0] = new SqlParameter("@TableName", dataTable.TableName);
                cmd.Parameters.Add(_parameters[0]);
                string Columns = cmd.ExecuteScalar().ToString();
                string[] ColumnArray = Columns.ToLower().Split(',');
                var results = (from row in dt.Columns.Cast<DataColumn>().AsEnumerable()
                               where !ColumnArray.Contains(row.ColumnName.ToLower())
                               select row).ToList();
                results.ForEach(r => dt.Columns.Remove(r));
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                cmd = null;
                if (conn != null && conn.State != ConnectionState.Closed)
                {
                    conn.Close();
                }
            }
            return dt;
        }

        public static DataTable ValidateService(int primaryKey, string primaryKeyName, int currentUserId)
        {
            DataTable validationErrors = new DataTable();
            DataSet dsValidation = new DataSet();
            DataTable dtValidationErrors = new DataTable("ServiceValidationErrors");
            //DataTable dtValidationStatus = new DataTable("ServiceValidationStatus");
            dsValidation.Tables.Add(dtValidationErrors);
            //dsValidation.Tables.Add(dtValidationStatus);

            if (primaryKeyName.Trim().ToLower() == "serviceid")
            {
                var servicevalidationStoredProc = _ctx.Screens
                    .Where(s => s.ScreenId == 29)
                    .Select(s => s.ValidationStoredProcedureUpdate)
                    .FirstOrDefault();

                if (!string.IsNullOrEmpty(servicevalidationStoredProc))
                {
                    _parameters = new SqlParameter[2];

                    _parameters[0] = new SqlParameter("@CurrentUsreId", currentUserId);
                    _parameters[1] = new SqlParameter("@ScreenKeyId", primaryKey);
                    using (conn = new SqlConnection(Connection))
                    {
                        conn.Open();
                        cmd = new SqlCommand(servicevalidationStoredProc, conn);
                        cmd.CommandType = CommandType.StoredProcedure;

                        foreach (var parameter in _parameters)
                        {
                            cmd.Parameters.Add(parameter);
                        }

                        reader = cmd.ExecuteReader();

                        dsValidation.Load(reader, LoadOption.OverwriteChanges, dtValidationErrors);
                        if (dsValidation != null && dsValidation.Tables["ServiceValidationErrors"].Rows.Count > 0)
                            validationErrors = dsValidation.Tables["ServiceValidationErrors"];
                    }
                }
            }
            else if (primaryKeyName.Trim().ToLower() == "documentid")
            {
                var documentcodeId = _ctx.Documents
                    .Where(s => s.DocumentId == primaryKey)
                    .Select(s => s.DocumentCodeId).FirstOrDefault();

                if (documentcodeId > 0)
                {
                    var ValidationStoredProcedureComplete = _ctx.Screens
                        .Where(a => a.DocumentCodeId == documentcodeId)
                        .Select(a => a.ValidationStoredProcedureComplete).FirstOrDefault();

                    if (!string.IsNullOrEmpty(ValidationStoredProcedureComplete))
                    {
                        _parameters = new SqlParameter[3];

                        _parameters[0] = new SqlParameter("@CurrentUserId", currentUserId);
                        _parameters[1] = new SqlParameter("@DocumentId", primaryKey);
                        _parameters[2] = new SqlParameter("@CustomValidationStoreProcedureName", ValidationStoredProcedureComplete);

                        using (conn = new SqlConnection(Connection))
                        {
                            conn.Open();
                            cmd = new SqlCommand("ssp_SCValidateDocument", conn);
                            cmd.CommandType = CommandType.StoredProcedure;

                            foreach (var parameter in _parameters)
                            {
                                cmd.Parameters.Add(parameter);
                            }

                            reader = cmd.ExecuteReader();

                            dsValidation.Load(reader, LoadOption.OverwriteChanges, dtValidationErrors);
                            if (dsValidation != null && dsValidation.Tables["ServiceValidationErrors"].Rows.Count > 0)
                                validationErrors = dsValidation.Tables["ServiceValidationErrors"];
                        }

                    }
                }
            }
            return validationErrors;
        }

        public static string GetClinicianName(int ClinicianId)
        {
            return (from a in _ctx.Staffs
                    where a.StaffId == ClinicianId
                    select (a.LastName + ", " + a.FirstName)).FirstOrDefault();
        }

        public static DataTable ConvertColumnType(DataTable dtTemp,DataSet dsOrg)
        {
            DataSet ds = new DataSet();
            ds.Tables.Add(dtTemp);

            string strxml = ds.GetXml();

            TextReader stringReader = null;
            DataSet datasetXMLReader = null;

            try
            {
                DataSet dataSetMain = new DataSet();
                if (!string.IsNullOrEmpty(strxml) && strxml.IndexOf("xmlns:xsi=", StringComparison.Ordinal) == -1)
                {
                    int index = strxml.IndexOf("xmlns", StringComparison.Ordinal);
                    if (index != -1)
                    {
                        strxml = strxml.Insert(index - 1, " " + "xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"" + " ");
                    }
                }
                if (!string.IsNullOrEmpty(strxml))
                {
                    stringReader = new StringReader(strxml);
                    datasetXMLReader = new DataSet();
                    datasetXMLReader.ReadXml(stringReader);
                    datasetXMLReader.EnforceConstraints = false;
                    datasetXMLReader.SchemaSerializationMode = SchemaSerializationMode.ExcludeSchema;
                    //DataTable dataTableUnchangedRecords = BaseCommonFunctions.GetUnChangedRows(datasetXMLReader, dataSetPageDataSet);


                    try
                    {
                        if (dsOrg != null)
                            dsOrg.Merge(datasetXMLReader, false, MissingSchemaAction.Ignore);
                        // dataSetPageDataSet.Merge(datasetXMLReader);

                    }
                    catch (Exception)
                    {
                        //dataSetPageDataSet.Clear();
                        if (dsOrg != null)
                            dsOrg.Merge(datasetXMLReader, false, MissingSchemaAction.Ignore);
                        //dataSetPageDataSet.Merge(datasetXMLReader);
                    }                    
                }
            }
            catch (Exception ex)
            {
                //string CustomExceptionInformation = string.Empty;
                //CustomExceptionInformation = "Failed in MergeXMLInDataSet() method of BaseCommonFunctions.cs";
                //LogManager.OnError(ex, LogManager.LoggingCategory.Error, LogManager.LoggingLevel.Error, dataSetPageDataSet, CustomExceptionInformation);
            }
            //try/catch block commented by shifali in ref to task# 950 on 01 july,2010
            //catch (Exception ex)
            //{
            //    //Code needs to be added for exception handling
            //}
            finally
            {
                stringReader = null;
            }

            return dsOrg.Tables[0];
        }
    }
}

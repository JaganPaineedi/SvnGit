using System.Data;
using System.Data.SqlClient;

namespace SC.Data
{
    public class GenericRepository
    {
        public bool IsExist(int primaryKey, string primaryKeyName, string TableName)
        {
            return DataService.isExist(primaryKey, primaryKeyName, TableName);
        }

        public void Save(string json, int ? primaryKeyValue,string primaryKeyName)
        {
            DataService.save(json,primaryKeyValue,primaryKeyName);
        }

        public object Get(int primaryKey,SqlParameter[] parameters,  string storedProcedureName,string tableList)
        {
            return DataService.get(primaryKey, parameters, storedProcedureName, tableList);
        }

        public DataTable ValidateService(int primaryKey, string primaryKeyName, int currentUserId)
        {
            return DataService.ValidateService(primaryKey, primaryKeyName, currentUserId);
        }
             
    }
}

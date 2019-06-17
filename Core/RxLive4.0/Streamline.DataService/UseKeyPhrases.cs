using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;

namespace Streamline.DataService
{
    public class UseKeyPhrases : IDisposable
    {

        public DataSet GetKeyPhrases(int StaffId, int ClientId)
        {
            DataSet datasetKeyPhrases = new DataSet();
            SqlParameter[] _SqlParameters = new SqlParameter[4];
            _SqlParameters[0] = new SqlParameter("@StaffId", StaffId);
            _SqlParameters[1] = new SqlParameter("@ClientId", ClientId);
            _SqlParameters[2] = new SqlParameter("@ScreenId", null);
            _SqlParameters[3] = new SqlParameter("@PrimaryKeyName", null);

            try
            {
                //datasetKeyPhrases = SqlHelper.ExecuteDataset(ClientMedication.ConnectionString, CommandType.StoredProcedure, "ssp_GetAgencyKeyPhrases", _SqlParameters);
                datasetKeyPhrases = SqlHelper.ExecuteDataset(ClientMedication.ConnectionString, CommandType.StoredProcedure, "ssp_SCGetUseKeyPhrases", _SqlParameters); // changed Sp to make common Key Phrases  to sc and Rx
                datasetKeyPhrases.Tables[0].TableName = "KeyPhrases";
                datasetKeyPhrases.Tables[1].TableName = "AgencyKeyPhrases";
                return datasetKeyPhrases;

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public DataSet GetAgencyPhrasesForSecondTab(int StaffId, int ClientId)
        {
            DataSet datasetKeyPhrases = new DataSet();
            SqlParameter[] _SqlParameters = new SqlParameter[2];
            _SqlParameters[0] = new SqlParameter("@StaffId", StaffId);
            _SqlParameters[1] = new SqlParameter("@ClientId", ClientId);

            try
            {
                datasetKeyPhrases = SqlHelper.ExecuteDataset(ClientMedication.ConnectionString, CommandType.StoredProcedure, "ssp_GetAgencyKeyAndStaffAgencyKeyPhrases", _SqlParameters);
                datasetKeyPhrases.Tables[0].TableName = "AgencyKeyPhrases";
                datasetKeyPhrases.Tables[1].TableName = "staffAgencyKeyPhrases";
                return datasetKeyPhrases;

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }



        public void Dispose()
        {

        }
    }
}

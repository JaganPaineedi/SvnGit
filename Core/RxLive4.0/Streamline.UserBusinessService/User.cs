using System;
using System.Collections.Generic;
using System.Text;
using System.Collections;
using System.Web.Configuration;
using Streamline.DataService;
using System.Data;
using System.Data.SqlClient;
using Streamline.UserBusinessServices.DataSets;

namespace Streamline.UserBusinessServices
{
    public class UserInfo
    {
        
        public ArrayList GetPermission(int userID)
        {
            try
            {
                //DataSetSystemActions  added by Rishu to populate SystemActions Table Information
                Streamline.DataService.SharedTables objectDataService = null;
                objectDataService = new Streamline.DataService.SharedTables();

                using (SqlDataReader DataReaderSystemActions = objectDataService.getSystemActions(userID))
                {
                    ArrayList arraySystemActions = new ArrayList();
                    while (DataReaderSystemActions.Read())
                    {
                        arraySystemActions.Add(DataReaderSystemActions["ActionId"]);
                    }
                    DataReaderSystemActions.Close();
                    return arraySystemActions;
                }
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "";
                else
                    ex.Data["CustomExceptionInformation"] = "";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;

                throw (ex);
            }
            finally
            {
                
            }
        }

        public ArrayList GetPermission(string userCode)
        {
            ArrayList ar = new ArrayList();
            ar.Add("105");
            return ar;
        }

        //Added By Sonia to populate the DataTable for Clincian's clients

        public DataTable GetSharedClients(string ClinicianRowIdentifier, int StaffId)
        {
            DataTable DataTableClients;
            Streamline.DataService.UserInfo objectUser;
			try
			{
			    //CommonFunctions.Event_Trap(this);
                DataTableClients= new DataTable();
                objectUser = new Streamline.DataService.UserInfo();
                DataTableClients=objectUser.getSharedClients(ClinicianRowIdentifier, StaffId);
                //DataRow drBlank = DataTableClients.NewRow();
                //drBlank["ClientId"] = "-1";
                //drBlank["Name"] = "View different Patients...";
                //drBlank["Status"] = 0;
                //DataTableClients.Rows.InsertAt(drBlank, 0);
                //drBlank["ClientId"] = "-2";
                //drBlank["Name"] = "Search Patients";
                //drBlank["Status"] = 0;
                //DataTableClients.Rows.InsertAt(drBlank, 1);
                return DataTableClients;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "";
                else
                    ex.Data["CustomExceptionInformation"] = "";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;

                throw (ex);
            }
            finally
            {
                DataTableClients = null;
                objectUser = null;
            }


        }

        public System.Data.DataSet ValidateLogin(string userCode, string cPassword)
        {

            try
            {
                UserInfo objUser = new UserInfo();
                return objUser.ValidateLogin(userCode, ApplicationCommonFunctions.GetEncryptedData(cPassword, "Y"));
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = null;
                else
                    ex.Data["CustomExceptionInformation"] = "";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);

            }
        }

        public System.Data.DataSet ValidateToken(string Token)
        {

            try
            {
                Streamline.DataService.UserInfo objUser = new Streamline.DataService.UserInfo();
                return objUser.ValidateToken(Token);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = null;
                else
                    ex.Data["CustomExceptionInformation"] = "";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);

            }
        }

        public System.Data.DataSet StaffDetail(int StaffId)
        {

            try
            {
                Streamline.DataService.UserInfo objUser = new Streamline.DataService.UserInfo();
                return objUser.StaffDetail(StaffId);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = null;
                else
                    ex.Data["CustomExceptionInformation"] = "";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);

            }
        }

        /// <summary>
        /// Validates the Token genrated through desktop (smartCare) application
        /// </summary>
        /// <param name="Token"></param>
        /// <returns></returns>
        /// <author>Piyush</author>
        /// <createdOn>24th Jan 2008</createdOn>
        public System.Data.DataSet ValidateWebToken(string Token)
        {
            try
            {
                Streamline.DataService.UserInfo objUser = new Streamline.DataService.UserInfo();
                return objUser.ValidateWebToken(Token);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = null;
                else
                    ex.Data["CustomExceptionInformation"] = "";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
        }


        public System.Data.DataSet GetClientInfo(int ClientId)
        {

            try
            {
                Streamline.DataService.UserInfo objUser = new Streamline.DataService.UserInfo();
                return objUser.GetClientInfo(ClientId);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = null;
                else
                    ex.Data["CustomExceptionInformation"] = "";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);

            }
        }

        //Added By Rohit to populate the DataTable for System Reports. Ref ticket #90

        public DataTable GetSystemReports()
        {
            DataTable DataTableClients;
            Streamline.DataService.UserInfo objectUser;
            try
            {               
                DataTableClients = new DataTable();
                objectUser = new Streamline.DataService.UserInfo();
                DataTableClients = objectUser.GetSystemReports();              
                return DataTableClients;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "";
                else
                    ex.Data["CustomExceptionInformation"] = "";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;

                throw (ex);
            }
            finally
            {
                DataTableClients = null;
                objectUser = null;
            }


        }

        //Added By Rohit to insert report parameters into SystemReports table. Ref ticket #90
        public int InsertReport(System.Guid sessionId, DataTable _MedicationIds, string UserCode)
        {

            //DataTable DataTableClients;
            Streamline.DataService.UserInfo objectUser;
            try
            {
                //DataTableClients = new DataTable();
                objectUser = new Streamline.DataService.UserInfo();
                objectUser.InsertReport(sessionId, _MedicationIds, UserCode);
                //return DataTableClients;
                return 1;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "";
                else
                    ex.Data["CustomExceptionInformation"] = "";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;

                throw (ex);
            }
            finally
            {
                //DataTableClients = null;
                objectUser = null;
            }
        }

        /// <summary>
        /// Gets previously saved Drug Order Templates for currently logged in user
        /// </summary>
        /// <param name="staffId">StaffId</param>
        /// <returns>Order Template Dataset</returns>
        /// <author>Chuck Blaine</author>
        /// <createdOn>July 9 2013</createdOn>
        public static DataSets.DataSetDrugOrderTemplates GetDrugOrderTemplates(int staffId)
        {
            var dataSetDrugOrderTemplates = new DataSetDrugOrderTemplates();

            using (var connection = new SqlConnection(WebConfigurationManager.AppSettings["SCConnectionString"]))
            {
                try
                {
                    using (var command = new SqlCommand("ssp_GetStaffDrugOrderTemplates", connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.Add(new SqlParameter("@StaffId", SqlDbType.Int)).Value = staffId;

                        var dataAdapter = new SqlDataAdapter(command);
                        dataAdapter.Fill(dataSetDrugOrderTemplates, "DrugOrderTemplates");
                    }

                    return dataSetDrugOrderTemplates;
                }
                catch (Exception ex)
                {
                    throw ex;
                }
                finally
                {
                    connection.Dispose();
                }
            }
        }

        /// <summary> 
        /// <author>Chuck Blaine</author>
        /// <Dated>July 12 2013</Dated>
        /// </summary>
        /// <param name="DataSetDrugOrderTemplates"></param>
        /// <returns></returns>
        public void UpdateDrugOrderTemplates(DataSet DataSetDrugOrderTemplates)
        {
            try
            {
                if (DataSetDrugOrderTemplates.GetChanges() != null)
                {
                    DataService.UserInfo.UpdateDrugOrderTemplates(DataSetDrugOrderTemplates);
                }
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - UpdateDocuments(), ParameterCount - 1, First Parameter- " + DataSetDrugOrderTemplates + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
        }
    }


}

using System;
using System.Collections.Generic;
using System.Text;
using System.Data;


namespace Streamline.UserBusinessServices
{
    public class SharedTables
    {
        public static DataSet DataSetDSMDescriptions;
        public static DataSet DataSetStaffTable;
        public static DataSet DataSetGlobalCodes;
        public static DataSet DataSetPharmacies;
        public static DataSet DataSetLocations;
        public static DataSet DataSetSystemActions;
        public static DataSet DataSetStates;
        public static DataSet DataSetDocumentCodes;
        //Added as per the Task#2582
        public static DataSet DataSetMedicationRxEndDateOffset;
        //Start Added by Pradeep as per task#23(Venture 10.0)
        public static DataSet DataSetPrinterDeviceLocations;
        public static DataSet DataSetStaffLocation;
        public static DataSet DataSetSureScriptCodes;
        public static DataSet DataSetSystemConfigurationKeys;
        //End Added by Pradeep as per task#23(Venture 10.0)
        Streamline.DataService.SharedTables objectSharedTables = null;


        public SharedTables()
        {

            //
            // TODO: Add constructor logic here
            objectSharedTables = new Streamline.DataService.SharedTables();

        }
        /// <summary>
        /// Author:Sonia 
        /// Purpose:To fill the Shared Tables Data in the DataSets of UserBusinessServices
        /// </summary>

        public void getSharedTablesData()
        {
            try
            {

                //DataSetDSM Descriptions added by Sonia to populated DSMDescriptions Information
                DataSetDSMDescriptions = new DataSet();
                DataSetDSMDescriptions = objectSharedTables.getDSMDescriptions();
                DataSetDSMDescriptions.Tables[0].TableName = "DiagnosisDSMDescriptions";
                DataSetDSMDescriptions.EnforceConstraints = false;
                DataColumn[] dcDSMDesc = new DataColumn[2];
                dcDSMDesc[0] = DataSetDSMDescriptions.Tables["DiagnosisDSMDescriptions"].Columns["DSMCode"];
                dcDSMDesc[1] = DataSetDSMDescriptions.Tables["DiagnosisDSMDescriptions"].Columns["DSMNumber"];
                DataSetDSMDescriptions.Tables["DiagnosisDSMDescriptions"].PrimaryKey = dcDSMDesc;

                //DataSetStaffTable  added by Rishu to populated Staff Table Information
                DataSetStaffTable = new DataSet();
                DataSetStaffTable = objectSharedTables.getStaffTable();

                //DataSetGlobalCodes  added by Rishu to populated Globalcodes Table Information
                DataSetGlobalCodes = new DataSet();
                DataSetGlobalCodes = objectSharedTables.getGlobalCodes();

                DataSetSureScriptCodes = objectSharedTables.getSureScriptCodes();

                //Modified by Loveena in ref to Task#2589
                ////DataSetPharmacies  added by Sonia to populate Pharmacies Table Information
                //DataSetPharmacies = new DataSet();
                //DataSetPharmacies = objectSharedTables.getPharmacies();

                //DataSetDocumentCode Added By Mohit Madaan to Populate the DocumentCode Table Information
                DataSetDocumentCodes = new DataSet();
                DataSetDocumentCodes = objectSharedTables.getDocumentCodesForPatientConsent();

                DataSetStates = new DataSet();
                DataSetStates = objectSharedTables.getStates();
                //DataSetLocations  added by Sonia to populate Locations Table Information
                DataSetLocations = new DataSet();

                //Changes to merge.
                DataSetSystemActions = new DataSet();
                DataSetSystemActions = objectSharedTables.GetSystemActionsForPermissions();

                //Added as ref to Task#2582                
                DataSetMedicationRxEndDateOffset = new DataSet();
                DataSetMedicationRxEndDateOffset = objectSharedTables.getMedicationRxEndDateOffset();
                #region--Code Written By Pradeep as per task#23(Venture 10.0)
                DataSetPrinterDeviceLocations = new DataSet();
                DataSetPrinterDeviceLocations = objectSharedTables.getPrinterDeviceLocations();
                DataSetStaffLocation = new DataSet();
                DataSetStaffLocation = objectSharedTables.getStaffLocation();
                #endregion
                DataSetSystemConfigurationKeys = new DataSet();
                DataSetSystemConfigurationKeys = objectSharedTables.GetSystemConfigurationKeys();
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

        public DataSet getStates()
        {

            try
            {

                return objectSharedTables.getStates();

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

        public DataSet getLocations(int StaffId)
        {

            try
            {

                return objectSharedTables.getLocations(StaffId);

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

        /// <summary>
        /// Ref To Task#2589
        /// </summary>
        /// <param name="ClientId"></param>
        /// <returns></returns>
        public DataSet getPharmacies(int ClientId)
        {

            try
            {

                return objectSharedTables.getPharmacies(ClientId);

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
        #region--Code Written By Pradeep as per task#23(Venture 10.0)
        /// <summary>
        /// <Description>Used to send request to DAL to get data for PrinterDeviceLocations</Description>
        /// <Author>Pradeep</Author>
        /// <CreatedOn>18 Nov 2009</CreatedOn>
        /// </summary>
        /// <returns></returns>
        public DataSet getPrinterDeviceLocations()
        {

            try
            {

                return objectSharedTables.getPrinterDeviceLocations();

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
        /// <summary>
        /// <Description>Used to send request to DAL to get data for PrinterDeviceLocations</Description>
        /// <Author>Pradeep</Author>
        /// <CreatedOn>18 Nov 2009</CreatedOn>
        /// </summary>
        /// <returns></returns>
        public DataSet getStaffLocation()
        {

            try
            {

                return objectSharedTables.getStaffLocation();

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

                return objectSharedTables.getHealthCategoryData();

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
        #region--Code Written By Pradeep on 27 Nov 2009 as per task#23(Venture 10.0)
        public DataSet GetUserPreferancesLocationList(int staffId)
        {
            try
            {
                return objectSharedTables.GetUserPreferancesLocationList(staffId);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - public DataSet GetUserPreferancesLocationList(int staffId), ParameterCount - 1,First Parameter-" + staffId.ToString() + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }
        }
        #endregion--Code Written By Pradeep on 27 Nov 2009 as per task#23(Venture 10.0)

        /// <summary>
        /// <Description>Created in ref to Task#2954</Description>
        /// </summary>
        /// <param name="StaffId"></param>
        /// <returns></returns>
        public DataSet GetAssociatedLocations(int StaffId)
        {

            try
            {

                return objectSharedTables.GetAssociatedLocations(StaffId);

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
        /// <summary>
        /// <Description>Created in ref to Task Jorney Go Live Support-#1566</Description>
        /// </summary>
        /// <param name="StaffId"></param>
        /// <returns></returns>
        public void getStaffClientsData(int StaffId)
        {
            try{               
                objectSharedTables.getStaffClientsData(StaffId);
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
}
}

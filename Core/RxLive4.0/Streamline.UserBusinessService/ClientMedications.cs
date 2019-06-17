using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Text;
using System.Data;
using System.Linq;
using Streamline.DataService;
using Streamline.UserBusinessServices.DataSets;

// #KA 08252011 - Kneale Alpers Added code to generate ClientMedicationData table

namespace Streamline.UserBusinessServices
{
    public class ClientMedication : IDisposable
    {
        Streamline.DataService.ClientMedication objectClientMedications = null;

        public bool HasImageServerString()
        {
            return objectClientMedications.HasImageServerString();
        }

        public ClientMedication()
        {
            objectClientMedications = new Streamline.DataService.ClientMedication();
        }

        /// <summary>
        /// Author Rishu Chopra.
        /// It is used to retrieve Medication drug in textbox.
        /// <ModifedBy>Loveena</ModifedBy>
        /// in ref to Task#2571-1.9.5.6: Add Soundex Search Opton to My Preferences
        /// added one more parameter char UseSoundexMedicationSearch
        /// </summary>
        /// <param name="MedicationName"></param>
        /// <returns></returns>
        public DataSet ClientMedicationDrug(string MedicationName, char UseSoundexMedicationSearch, char ShowDosagesInList)
        {
            try
            {
                return objectClientMedications.ClientMedicationDrug(MedicationName, UseSoundexMedicationSearch, ShowDosagesInList);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - ClientMedicationDrug(), ParameterCount - 2, First Parameter- " + MedicationName + ",Second Parameter-" + UseSoundexMedicationSearch + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }

        }

        /// <summary>
        /// Author Malathi Shiva.
        /// It is used to retrieve Medication drug in textbox.
        /// <ModifedBy></ModifedBy>
        /// WRT Key Point - Customizations Task# 321.3 - Frequency/Direction should be required only if the Client is enrolled in Programs, which has 'Non Prescribed Meds' checked
        /// </summary>
        /// <param name="clientId"></param>
        /// <returns></returns>
        public DataSet GetClientEnrolledPrograms(int clientId, char Order)
        {
            try
            {
                return objectClientMedications.GetClientEnrolledPrograms(clientId, Order);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetClientEnrolledPrograms(), ParameterCount - 1, First Parameter- " + clientId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }

        }


        /// <summary>
        /// Author Malathi Shiva.
        /// It is used to retrieve Staff License Degree details of a particular Staff.
        /// <ModifedBy></ModifedBy>
        /// WRT EPCS Task# 8 - To bind DEA Numbers of the selected Prescriber
        /// </summary>
        /// <param name="staffId"></param>
        /// <returns></returns>
        public DataSet GetStaffLicenseDegrees(int staffId)
        {
            try
            {
                return objectClientMedications.GetStaffLicenseDegrees(staffId);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetStaffLicenseDegrees(), ParameterCount - 1, First Parameter- " + staffId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }

        }


        /// <summary>
        /// Author Rishu Chopra.
        /// It is used to retrieve Medication drug in textbox.
        /// </summary>
        /// <param name="MedicationName"></param>
        /// <returns></returns>
        public DataSet GetSystemReports(string _ReportName)
        {
            try
            {
                return objectClientMedications.GetSystemReports(_ReportName);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - ClientMedicationDrug(), ParameterCount - 1, First Parameter- " + _ReportName + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }

        }


        /// <summary>
        /// Author Loveena.
        /// It is used to retrieve Prescribers ref to Task#128.
        /// </summary>
        /// <param name="_ClientId"></param>
        /// <returns></returns>
        public DataSet GetUniquePrescribers(int _ClientId)
        {
            try
            {
                return objectClientMedications.GetUniquePrescribers(_ClientId);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetUniquePrescribers(), ParameterCount - 1, First Parameter- " + _ClientId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }

        }

        /// <summary>
        /// Author Loveena.
        /// It is used to retrieve Pharmacies ref to Task#92.
        /// <CreatedOn>22-Dec-2008</CreatedOn>
        /// </summary>
        /// <returns></returns>
        public DataSet GetPharmacies()
        {
            try
            {
                return objectClientMedications.GetPharmacies();
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetPharmacies(), ParameterCount - 0 , ###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }

        }

        /// <summary>
        /// <Author>Loveena.</Author>
        /// It is used to GetClientPharmacies as ref to Task#92.
        /// <CreatedOn>23-Dec-2008</CreatedOn>
        /// <param name="_ClientId"></param>       
        /// </summary>
        /// <returns></returns>
        public DataSet GetClientPharmacies(int _ClientId, bool RequirePharamcies, string _PreferredPharmacy1, string _PreferredPharmacy2, string _PreferredPharmacy3)
        {
            try
            {
                return objectClientMedications.GetClientPharmacies(_ClientId, RequirePharamcies, _PreferredPharmacy1, _PreferredPharmacy2, _PreferredPharmacy3);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetClientPharmacies(), ParameterCount - 1,FirstParameter-" + _ClientId + " ###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }

        }
        /// <summary>
        /// <Author>Loveena.</Author>
        /// It is used to GetPharmacies .
        /// <CreatedOn>03-April-2009</CreatedOn>              
        /// </summary>        
        public DataSet GetPharmaciesData()
        {
            try
            {
                return objectClientMedications.GetPharmaciesData();
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetClientPharmacies(), ParameterCount - 0 ###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }

        }
        /// <summary>
        /// <Author>Mohit Madaan.</Author>
        /// It is used to get Printer Data
        /// <CreatedOn>16-Nov-2009</CreatedOn> 
        /// </summary>
        /// <returns></returns>
        public DataSet GetPrinterData()
        {
            try
            {
                return objectClientMedications.GetPrinterData();
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetClientPharmacies(), ParameterCount - 0 ###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }

        }

        public DataSet GetClientEducationNDC(string MedicationNameId)
        {
            try
            {
                return objectClientMedications.GetClientEducationNDC(MedicationNameId);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetClientEducationNDC(), ParameterCount - 0 ###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }

        }
        /// <summary>
        /// Author Rishu Chopra.
        /// It is used to Fill DropDown DxPurpose.
        /// </summary>
        /// <param name="MedicationName"></param>
        /// <returns></returns>

        public DataSet ClientMedicationDxPurpose(int ClientId)
        {
            try
            {
                return objectClientMedications.ClientMedicationDxPurpose(ClientId);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - ClientMedicationDxPurpose(), ParameterCount - 1, First Parameter- " + ClientId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }

        }



        /// <summary>
        /// Author:Vikas Vyas
        /// Purpose:Get the Name of the Rdlc,StoredProcedure from DocumentCodes,DocumentCodesRDLSubReports 
        /// </summary>
        /// <param name="_DocumentCodeId"></param>
        /// <returns></returns>
        public DataSet GetRdlCNameDataBase(int _DocumentCodeId)
        {
            try
            {
                return objectClientMedications.GetRdlCNameDataBase(_DocumentCodeId);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetRdlCNameDataBase(), ParameterCount - 1, First Parameter- " + _DocumentCodeId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;


            }


        }

        /// <summary>
        /// Author:Vikas Vyas
        /// Purpose:This function is use to get Data For Main Report / SubReport
        /// On the Basis of ScriptId,__OrderingMethod
        /// </summary>
        /// <param name="_StoredProcedureName"></param>
        /// <param name="ScriptId"></param>
        /// <param name="_OrderingMethod"></param>
        /// <returns></returns>
        /// <Modified By>Chandan for task #85 Build MM#1.7 </Modified>
        /// <Modified By>Pradeep for task #3336 on 14 March2011 </Modified>
        public DataSet GetDataForRdlC(string _StoredProcedureName, int ScriptId, string _OrderingMethod, int OriginalDataUpdated, int LocationId, string PrintChartCopy, string SessionId, string RefillResponseType)
        {
            try
            {
                return objectClientMedications.GetDataForRdlC(_StoredProcedureName, ScriptId, _OrderingMethod, OriginalDataUpdated, LocationId, PrintChartCopy, SessionId, RefillResponseType);

            }
            catch (Exception ex)
            {

                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetDataForRdlC(), ParameterCount - 1, First Parameter- " + _StoredProcedureName + ",Second Paramenter- " + ScriptId + "Third Parameter- " + _OrderingMethod + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }


        }







        public DataSet MedicationGlobalCodeUnit()
        {

            try
            {

                return objectClientMedications.MedicationGlobalCodeUnit();
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - MedicationGlobalCodeUnit(), ParameterCount - 0, ###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }

        }

        /// <summary>
        /// Author Rishu Chopra.
        /// It is used to Fill Medication Strength dropdown.
        /// </summary>
        /// <param name="MedicationName"></param>
        /// <returns></returns>

        public DataSet MedicationStrength(int MedicationId)
        {
            try
            {
                return objectClientMedications.MedicationStrength(MedicationId);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - MedicationStrength(), ParameterCount - 1, First Parameter- " + MedicationId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }

        }

        //public DataSet GetCodeName(int _globalcodeid)
        //{           
        //        try
        //        {                    
        //            return objectClientMedications.GetCodeName(_globalcodeid);
        //        }
        //        catch (Exception ex)
        //        {
        //            if (ex.Data["CustomExceptionInformation"] == null)
        //                ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetCodeName(), ParameterCount - 1, First Parameter- " + _globalcodeid + "###";
        //            if (ex.Data["DatasetInfo"] == null)
        //                ex.Data["DatasetInfo"] = null;
        //            throw ex;
        //        }

        //}


        /// <summary>
        /// Author Rishu Chopra.
        /// It is used to Fill Medication Unit Dropdown.
        /// </summary>
        /// <param name="MedicationName"></param>
        /// <returns></returns>

        public DataSet MedicationUnit(int MedicationId)
        {
            try
            {
                return objectClientMedications.MedicationUnit(MedicationId);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - MedicationUnit(), ParameterCount - 1, First Parameter- " + MedicationId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }

        }

        /// <summary>
        /// This function is used to update the documents.	
        /// <Author>Rishu Chopra</Author>        
        /// </summary>
        /// <returns>Dataset with all the respective tables of the document filled</returns>
        public DataSet UpdateDocuments(DataSet DataSetDocumentsforUpdate)
        {
            try
            {
                Streamline.UserBusinessServices.DataSets.DataSetClientMedications dsUpdated = new Streamline.UserBusinessServices.DataSets.DataSetClientMedications();
                if (DataSetDocumentsforUpdate.GetChanges() != null)
                {

                    DataSetDocumentsforUpdate = objectClientMedications.UpdateDocuments(DataSetDocumentsforUpdate);
                }
                if (!DataSetDocumentsforUpdate.Tables.Contains("ClientMedications"))
                    dsUpdated.EnforceConstraints = false;
                dsUpdated.Merge(DataSetDocumentsforUpdate);
                return dsUpdated;

            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - UpdateDocuments(), ParameterCount - 1, First Parameter- " + DataSetDocumentsforUpdate + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
            finally
            {
                objectClientMedications = null;
            }


            return null;
        }

        /// <summary>
        /// This function is used to retrieve all the failed Electronic Prescriptions.	
        /// <Author>Malathi Shiva</Author>        
        /// </summary>
        /// <returns>Dataset with all the respective tables of the document filled</returns>
        public DataSet GetFailedElectronicPrescriptions(int clientId, int staffId)
        {//ssp_RxGetFailedElectronicPrescriptions
            try
            {
                return objectClientMedications.GetFailedElectronicPrescriptions(clientId, staffId);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetFailedElectronicPrescriptions(), ParameterCount - 2, First Parameter-" + clientId + "Second Parameter-" + staffId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }
            return null;
        }

        /// <summary>
        /// Author Vithobha.
        /// It is used to retrieve Electronic Prescribed Medication data of Particular Client.
        /// </summary>
        /// <param name="ClientMedicationScriptIds"></param>
        /// <param name="OriginalData"></param>
        /// <returns></returns>        
        public DataSet GetElectronicPrescriptionData(string ClientMedicationScriptIds, int OriginalData)
        {
            try
            {
                return objectClientMedications.GetElectronicPrescriptionData(ClientMedicationScriptIds, OriginalData);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetElectronicPrescriptionData(), ParameterCount - 2, First Parameter- " + ClientMedicationScriptIds + "Second Parameter- " + OriginalData + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }
            return null;

        }


        public DataSet GetChangeMedicationOrderList(string SureScriptsChangeRequestId)
        {

            try
            {
                return objectClientMedications.GetChangeMedicationOrderList(SureScriptsChangeRequestId);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetChangeMedicationOrderList(), ParameterCount - 2, First Parameter- " + SureScriptsChangeRequestId  ;
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }
            return null;



        }



        /// <summary>
        /// Author Pranay.
        /// It is used to retrieve Client Medication Script Drugs Preview data of Particular Client.
        /// </summary>
        /// <param name="ClientMedicationScriptIds"></param>
        /// <returns></returns>        
        public DataSet GetClientMedicationScriptDrugsPreview(string ClientMedicationScriptIds)
        {
            try
            {
                return objectClientMedications.GetClientMedicationScriptDrugsPreview(ClientMedicationScriptIds);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetClientMedicationScriptDrugsPreview(), ParameterCount - 1, First Parameter- " + ClientMedicationScriptIds + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }
            return null;
        }


        /// <summary>
        /// Author Rishu Chopra.
        /// It is used to retrieve Medication data of Particular Client.
        /// </summary>
        /// <param name="MedicationName"></param>
        /// <param name="StaffId"></param>
        /// <returns></returns>        
        public DataSet GetClientMedicationData(int ClientId, int StaffId)
        {
            try
            {
                return objectClientMedications.GetMedicationData(ClientId, StaffId);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetMedicationData(), ParameterCount - 2, First Parameter- " + ClientId + "Second Parameter- " + StaffId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }
            return null;

        }

        #region Medication Order Details
        public DataSet GetMedicationOrderDetails(int clientMedicationId, int ClientMedicationScriptId)
        {
            try
            {
                return objectClientMedications.GetMedicationOrderDetails(clientMedicationId, ClientMedicationScriptId);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetMedicationOrderDetails(), ParameterCount - 1, First Parameter- " + clientMedicationId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }

        }

        public void DeleteMedicationOrderDetails(int clientMedicationId)
        {




            try
            {

                objectClientMedications.DeleteMedicationOrderDetails(clientMedicationId);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - DeleteMedicationOrderDetails(), ParameterCount - 1, First Parameter- " + clientMedicationId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }




        }


        # endregion
        //This region contains functions to Add,Get,update and Delete Data in Client Allergies List
        #region Allergies Data


        public DataSet GetAllergiesData(string SearchCriteria)
        {
            try
            {
                return objectClientMedications.GetAllergiesData(SearchCriteria);

            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetAllergiesData(), ParameterCount - 0, ###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }

            return null;
        }

        public DataSet GetClientAllergiesData(Int32 ClientId)
        {
            try
            {
                return objectClientMedications.GetClientAllergiesData(ClientId);

            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetClientAllergiesData(), ParameterCount - 1, ###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }
            return null;


        }

        public DataSet GetClientAllergies(Int32 ClientId)
        {
            try
            {
                return objectClientMedications.GetClientAllergies(ClientId);

            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetClientAllergies(), ParameterCount - 1, ###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }
            return null;


        }


        public DataSet UpdateClientAllergies(DataSet DataSetClientAllergies, int UserId, string UserCode)
        {
            DataSet dsChanges;
            try
            {
                dsChanges = DataSetClientAllergies.GetChanges();
                if (dsChanges != null)
                {

                    DataSetClientAllergies = objectClientMedications.UpdateClientAllergies(DataSetClientAllergies, UserId, UserCode);
                    return DataSetClientAllergies;

                }
                return null;

            }
            catch (Exception ex)
            {

                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - UpdateClientAllergies(), ParameterCount - 1, First Parameter- " + DataSetClientAllergies + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = DataSetClientAllergies;
                throw (ex);
            }
        }


        /// <summary>
        /// Author:Sonia Dhamija
        /// Purpose:-Deleting the selected Client Allergy from Known Allergies List
        /// </summary>
        /// <param name="ClientAllergyId"></param>

        /// <returns>int</returns>
        public int DeleteAllergy(int ClientAllergyId, int UserId, string UserCode)
        {

            try
            {
                return objectClientMedications.DeleteAllergy(ClientAllergyId, UserId, UserCode);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - DeleteAllergy(),Parameter Count=1,Parameter Name=ClientAllergyId";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }
            finally
            {

            }


        }

        #endregion





        /// <summary>
        /// Author:Sonia Dhamija
        /// </summary>
        /// <param name="ClientRowIdentifier"></param>
        /// <param name="ClinicianRowIdentifier"></param>
        /// <returns>DataSet</returns>
        public DataSet DownloadClientMedicationSummary(string ClientRowIdentifier, string ClinicianRowIdentifier)
        {

            try
            {
                // #KA 08252011 add the additional table ClientMedicationData 

                DataSet ds = objectClientMedications.DownloadClientMedicationSummary(ClientRowIdentifier, ClinicianRowIdentifier, true);
                DataSets.DataSetClientMedications.ClientMedicationDataDataTable dt = new DataSets.DataSetClientMedications.ClientMedicationDataDataTable();
                if (ds.Tables["ClientMedications"] != null)
                {

                    var distinctMedicationIdRows = (from DataRow dRow in ds.Tables["ClientMedications"].AsEnumerable()
                                                    select new { ClientMedicationId = Int32.Parse(dRow["ClientMedicationId"].ToString()) }).Distinct();

                    foreach (var row in distinctMedicationIdRows)
                    {
                        try
                        {
                            DataSets.DataSetClientMedications.ClientMedicationDataRow drdata =
                                dt.NewClientMedicationDataRow();
                            drdata["ClientMedicationId"] = row.ClientMedicationId;
                            dt.AddClientMedicationDataRow(drdata);
                        }
                        catch (Exception ex)
                        {
                        }
                    }
                    
                }
                ds.Tables.Add(dt);
                return ds;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - DownloadClientMedicationSummary(), ParameterCount - 2, First Parameter- " + ClientRowIdentifier + " Second Parameter- " + ClinicianRowIdentifier + "###";
                throw (ex);
            }
            finally
            {

            }


        }

        /// <summary>
        /// Author:Sonia Dhamija
        /// Purpose:Added By Sonia to Get Client's Medication History Only
        /// </summary>
        /// <param name="ClientId"></param>
        /// <returns>DataSet</returns>

        public DataSet DownloadClientMedicationHistory(Int64 ClientId)
        {

            try
            {
                return objectClientMedications.DownloadClientMedicationHistory(ClientId);

            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - DownloadClientMedicationHistory(), ParameterCount -1, First Parameter- " + ClientId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);

            }
            finally
            {

            }
        }

        /// <summary>
        /// Added By Sonia to Discontinue Medications
        /// </summary>
        /// <param name="ClientMedicationId"></param>
        /// <param name="TobeDiscontinued"></param>
        /// <param name="ModifiedBy"></param>
        /// <returns>int</returns>
        // public int DiscontinueMedication(int ClientMedicationId, char TobeDiscontinued, string ModifiedBy, string DiscontinueReason, string DiscontinueReasonCode)
        public int DiscontinueMedication(int ClientMedicationId, char TobeDiscontinued, string ModifiedBy, string DiscontinueReason, int DiscontinueReasonCode, int ClientMedicationConsentId, string SureScriptsOutgoingMessageId, string MethodName, int PrescriberId, int PharmacyId)
        {

            try
            {
                return objectClientMedications.DiscontinueMedication(ClientMedicationId, TobeDiscontinued, ModifiedBy, DiscontinueReason, DiscontinueReasonCode, ClientMedicationConsentId, SureScriptsOutgoingMessageId, MethodName, PrescriberId, PharmacyId);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - DiscontinueMedication(), ParameterCount - 2, First Parameter- " + ClientMedicationId + " Second Parameter- " + TobeDiscontinued + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
            finally
            {

            }

        }

        /// <summary>
        /// Added By Rishu to return Monographtext
        /// </summary>
        /// <param name="druginteractionmonographid"></param>
        /// <returns>Dataset</returns>        
        public string GetClientMedicationmonographtext(Int32 DrugInteractionMonographId)
        {
            try
            {
                DataSet dsTemp = new DataSet();
                string stringMonographtext = "<p style='max-width: 590px; white-space: pre-line;'>";
                dsTemp = objectClientMedications.GetClientMedicationmonographtext(DrugInteractionMonographId);
                foreach (DataRow dr in dsTemp.Tables[0].Rows)
                {
                    stringMonographtext += dr["monographtext"] == DBNull.Value ? "" : dr["monographtext"].ToString();
                    if (dr["LineIdentifier"].ToString() == "B")
                    {
                        stringMonographtext = stringMonographtext + "</p><p style='max-width: 590px; white-space: pre-line;'>";
                    }
                }
                stringMonographtext = stringMonographtext + "</p>";
                return stringMonographtext;

            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetClientAllergiesData(), ParameterCount - 1, ###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }
            return null;


        }

        #region ClientScripts

        public DataSet UpdateClientScripts(DataSet DataSetClientScripts)
        {
            DataSet dsChanges;
            try
            {
                dsChanges = DataSetClientScripts.GetChanges();
                if (dsChanges != null)
                {

                    DataSetClientScripts = objectClientMedications.UpdateClientScripts(DataSetClientScripts);
                    return DataSetClientScripts;

                }
                return null;

            }
            catch (Exception ex)
            {

                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - UpdateClientScripts(), ParameterCount - 1, First Parameter- " + DataSetClientScripts + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = DataSetClientScripts;
                throw (ex);
            }
        }

        public DataSet UpdateClientScriptActivities(DataSet DataSetClientScriptActivities)
        {
            DataSet dsChanges;
            try
            {
                dsChanges = DataSetClientScriptActivities.GetChanges();
                if (dsChanges != null)
                {
                    DataSetClientScriptActivities = objectClientMedications.UpdateClientScriptActivities(DataSetClientScriptActivities);
                    return DataSetClientScriptActivities;

                }
                return null;

            }
            catch (Exception ex)
            {

                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - UpdateClientScriptActivities(), ParameterCount - 1, First Parameter- " + DataSetClientScriptActivities + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = DataSetClientScriptActivities;
                throw (ex);
            }
        }

        #endregion

        #region Created by Chandan for UpdateClientScripts for re-print and re fax the prescriptions in ref to Task#2439
        public void UpdateClientScripts(int ScriptId, string DrugInformation, int PharmacyId, char OrderingMethod)
        {
            try
            {
                objectClientMedications.UpdateClientScripts(ScriptId, DrugInformation, PharmacyId, OrderingMethod);
            }
            catch (Exception ex)
            {

                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - UpdateClientScripts(), ParameterCount - 2, First Parameter- " + ScriptId + "second Parameter- " + DrugInformation + "###";

                throw (ex);
            }
        }
        #endregion

        /// <summary>
        /// Author:Sonia Dhamija
        /// Purpose:Added By Sonia to Get Client's Medication Script History Only
        /// </summary>
        /// <param name="ClientId"></param>
        /// <param name="ClientMedicationScriptId"></param>
        /// <ModifiedBy>Sonia</ModifiedBy>
        /// <ModifiedDate>27thMay2008</ModifiedDate>
        /// <ModificationPurpose>New Parameter ClientMedicationScriptId so that ScriptHistory is fetched along with MedicationId </ModificationPurpose>
        /// <returns>DataSet</returns>

        public DataSet DownloadClientMedicationScriptHistory(Int32 ClientId, Int32 ClientMedicationId, Int32 ClientMedicationScriptId)
        {

            try
            {
                return objectClientMedications.DownloadClientMedicationScriptHistory(ClientId, ClientMedicationId, ClientMedicationScriptId);

            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - DownloadClientMedicationScriptHistory(), ParameterCount -1, First Parameter- " + ClientId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);

            }
            finally
            {

            }
        }

        /// <summary>
        /// Author:Sonia
        /// Pupose:-To insert the record into ClientMedicationScriptActivities
        /// </summary>
        /// <param name="ClientMedicationScriptId"></param>
        /// <param name="Method"></param>
        /// <param name="PharmacyId"></param>
        /// <param name="Reason"></param>
        /// <param name="CreatedBy"></param>
        /// <returns></returns>
        public int InsertIntoClientMedicationScriptActivities(int ClientMedicationScriptId, char Method, int PharmacyId, int Reason, string CreatedBy)
        {

            try
            {
                return objectClientMedications.InsertIntoClientMedicationScriptActivities(ClientMedicationScriptId, Method, PharmacyId, Reason, CreatedBy);

            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - InsertIntoClientMedicationScriptActivities(), ParameterCount -5, First Parameter- " + ClientMedicationScriptId + "Second Parameter- " + Method + "Third Parameter- " + PharmacyId + "Fourth Parameter- " + Reason + "Fifth Parameter- " + CreatedBy + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
            finally
            {

            }

        }



        /// <summary>
        /// Added By Sony to Get  Medication Drug Interaction
        /// </summary>
        /// <param name="MedicationIds></param>
        /// <param name="ClientId"></param>
        /// <param name="StaffId"></param>
        /// <returns></returns>
        public DataSet GetClientMedicationDrugInteraction(string MedicationIds, int ClientId, int StaffId)
        {

            try
            {
                Streamline.DataService.ClientMedication objClientMedication = new Streamline.DataService.ClientMedication();
                return objClientMedication.GetClientMedicationDrugInteraction(MedicationIds, ClientId, StaffId);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - DownloadClientMedicationScriptHistory(), ParameterCount -3, First Parameter- " + MedicationIds + "Third Parameter- " + StaffId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }

        }


        /// <summary>
        /// Added By Malathi Shiva to Get Request XML for PMP Gateway
        /// </summary>
        /// <param name="ClientId"></param>
        /// <param name="StaffId"></param>
        /// <returns></returns>
        public DataSet GetClientRequestXMLForPMP(int ClientId, int StaffId)
        {
            try
            {
                Streamline.DataService.ClientMedication objClientMedication = new Streamline.DataService.ClientMedication();
                return objClientMedication.GetClientRequestXMLForPMP(ClientId, StaffId);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetClientRequestXMLForPMP(), ParameterCount -2, First Parameter- " + ClientId + "Second Parameter- " + StaffId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }

        }


        /// <summary>
        /// Added By Malathi Shvia to save Response XML received from PMP Gateway
        /// </summary>
        /// <param name="PMPAuditTrailId"></param>
        /// <param name="response"></param>
        /// <returns></returns>
        public DataSet UpdateResponseXMLDetails(int PMPAuditTrailId, string response)
        {
            try
            {
                Streamline.DataService.ClientMedication objClientMedication = new Streamline.DataService.ClientMedication();
                return objClientMedication.UpdateResponseXMLDetails(PMPAuditTrailId, response);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - UpdateResponseXMLDetails(), ParameterCount -2, First Parameter- " + PMPAuditTrailId + "Second Parameter- " + response + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }

        }

        /// <summary>
        /// This function is used to get values from PMPAuditTrails table.
        /// <author>Malathi Shiva</author>
        /// <Dated>July 17th 2018</Dated>
        /// </summary>
        /// <returns></returns>
        public DataSet GetPMPReportURL(int PMPAuditTrailId, string ReportResponseXML)
        {
            try
            {
                return objectClientMedications.GetPMPReportURL(PMPAuditTrailId, ReportResponseXML);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetPMPReportURL(),Parameter Count=1,First Parameter- " + PMPAuditTrailId + "Second Parameter- " + ReportResponseXML + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }

        }


        /// <summary>
        /// Added By Sonia to Get  Drug Allergy Interaction
        /// </summary>
        /// <param name="ClientId></param>
        /// <returns></returns>
        public DataTable GetClientDrugAllergyInteraction(int ClientId, int StaffId)
        {

            try
            {
                Streamline.DataService.ClientMedication objClientMedication = new Streamline.DataService.ClientMedication();
                return objClientMedication.GetClientDrugAllergyInteraction(ClientId, StaffId);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetClientDrugAllergyInteraction(), ParameterCount -2, First Parameter- " + ClientId + "Second Parameter- " + StaffId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }

        }

        ///// <summary>
        ///// Author:Sonia
        ///// Purpose:-Download Client Medication Non Prescribed Data
        ///// </summary>
        ///// <param name="ClientId"></param>
        ///// <returns>DataSet</returns>
        //public DataSet DownloadClientMedicationNonPrescribedData(Int64 ClientId, string MedicationIds)
        //{
        //    try
        //    {
        //        Streamline.DataService.ClientMedication objClientMedication = new Streamline.DataService.ClientMedication();
        //        return objClientMedication.DownloadClientMedicationNonPrescribedData(ClientId, MedicationIds);
        //    }
        //    catch (Exception ex)
        //    {
        //        if (ex.Data["CustomExceptionInformation"] == null)
        //            ex.Data["CustomExceptionInformation"] = "###Source Function Name - DownloadClientMedicationNonPrescribedData(), ParameterCount -1, First Parameter- " + ClientId + "###";
        //        if (ex.Data["DatasetInfo"] == null)
        //            ex.Data["DatasetInfo"] = null;
        //        throw (ex);

        //    }
        //    finally
        //    {

        //    }
        //}


        /// <summary>
        /// This function is used to Execute the StoredProcedure for Main Report
        /// <author>Sonia Dhamija </author>
        /// <Dated>Dec 20th 2007</Dated>
        /// </summary>
        /// <param name="_StoredProcedure"></param>
        /// <param name="_ClientId"></param>
        /// <returns></returns>
        public DataSet ExecuteStoredProcedureforMainReport(string _StoredProcedure, int _ClientID)
        {
            Streamline.DataService.ClientMedication objectClientMedications;
            DataSet _DataSetRdl = null;
            try
            {
                _DataSetRdl = new DataSet();
                objectClientMedications = new Streamline.DataService.ClientMedication();
                _DataSetRdl = objectClientMedications.ExecuteStoredProcedureforMainReport(_StoredProcedure, _ClientID);
                return _DataSetRdl;
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
                objectClientMedications = null;
                _DataSetRdl = null;
            }

        }

        /// <summary>
        /// This function is used to Execute the StoredProcedure for Main Report
        /// <author>Sonia Dhamija </author>
        /// <Dated>Dec 20th 2007</Dated>
        /// </summary>
        /// <param name="_StoredProcedure"></param>
        /// <param name="_ClientMedicationScriptId"></param>
        /// <returns></returns>
        public DataSet ExecuteStoredProcedureforSubReport(string _StoredProcedure, string _ClientMedicationScriptIds)
        {
            Streamline.DataService.ClientMedication objClientMedication = null;
            DataSet _DataSetSubReportRdl = null;
            try
            {
                objClientMedication = new Streamline.DataService.ClientMedication();
                _DataSetSubReportRdl = new DataSet();
                _DataSetSubReportRdl = objClientMedication.ExecuteStoredProcedureforSubReport(_StoredProcedure, _ClientMedicationScriptIds);
                return _DataSetSubReportRdl;
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
                return null;
            }

            finally
            {
                objectClientMedications = null;
                _DataSetSubReportRdl = null;
            }

        }

        /// <summary>
        /// Author Rishu Chopra.
        /// This function is used to get Category of Drugs.
        /// </summary>
        /// <param name="MedicationID"></param>
        /// <returns></returns>

        public DataSet C2C5Drugs(int MedicationId)
        {
            try
            {
                return objectClientMedications.C2C5Drugs(MedicationId);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - MedicationUnit(), ParameterCount - 1, First Parameter- " + MedicationId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }

        }


        /// <summary>
        /// Author Rishu Chopra.
        /// This function is used to get Category of Drugs.
        /// </summary>
        /// <param name="MedicationID"></param>
        /// <returns></returns>

        public DataSet GetDrugCategory(int MedicationNameId)
        {
            try
            {
                return objectClientMedications.GetDrugCategory(MedicationNameId);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - MedicationUnit(), ParameterCount - 1, First Parameter- " + MedicationNameId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }

        }


        /// <summary>
        /// This function is used to get dataset of RDL.
        /// <author>Rishu Chopra</author>
        /// <Dated>Feb 12th 2008</Dated>
        /// </summary>
        /// <param name="_StoredProcedure"></param>
        /// <param name="GeneratedScriptId"></param>
        /// <returns></returns>
        public DataSet GetClientMedicationRDLDataSet(int _ClientMedicationScriptIds)
        {
            try
            {
                return objectClientMedications.GetClientMedicationRDLDataSet(_ClientMedicationScriptIds);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetClientMedicationRDLDataSet(), ParameterCount - 1, First Parameter- " + _ClientMedicationScriptIds + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }

        }


        /// <summary> 
        /// <author>Chandan Srivastava</author>
        /// <Dated>3rd Dec 2008</Dated>
        /// Task #85 MM 1.7 - Prescribe Window Changes
        /// </summary>
        /// <param name="DataSetDocumentsforUpdate"></param>
        /// <param name="_updatedOnce"></param>
        /// <returns></returns>
        public DataSet UpdateTempDocuments(DataSet DataSetDocumentsforUpdate, bool _updatedOnce, string SessionId)
        {
            try
            {
                Streamline.UserBusinessServices.DataSets.DataSetClientMedications dsUpdated = new Streamline.UserBusinessServices.DataSets.DataSetClientMedications();
                if (DataSetDocumentsforUpdate.GetChanges() != null)
                {
                    //The following object initialization is written by Pradeep
                    if (objectClientMedications == null)
                    {
                        objectClientMedications = new Streamline.DataService.ClientMedication();
                    }
                    DataSetDocumentsforUpdate = objectClientMedications.UpdateTempDocuments(DataSetDocumentsforUpdate, _updatedOnce, SessionId);
                }
                dsUpdated.Merge(DataSetDocumentsforUpdate);
                return dsUpdated;

            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - UpdateDocuments(), ParameterCount - 1, First Parameter- " + DataSetDocumentsforUpdate + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
            finally
            {
                objectClientMedications = null;
            }


            return null;
        }


        /// <summary> 
        /// <author>Chandan Srivastava</author>
        /// <Dated>3rd Dec 2008</Dated>
        /// Task #85 MM 1.7 - Prescribe Window Changes
        /// </summary>
        /// <param name="DataSetDocumentsforUpdate"></param>
        /// <param name="_updatedOnce"></param>
        /// <returns></returns>
        ////public DataSet UpdateTempDocumentsAccess()
        ////{
        ////    try
        ////    {
        ////        Streamline.UserBusinessServices.DataSets.DataSetClientMedications dsUpdated = new Streamline.UserBusinessServices.DataSets.DataSetClientMedications();
        ////        if (DataSetDocumentsforUpdate.GetChanges() != null)
        ////        {

        ////            DataSetDocumentsforUpdate = objectClientMedications.UpdateTempDocumentsAccess();
        ////        }
        ////        //dsUpdated.Merge(DataSetDocumentsforUpdate);
        ////        return dsUpdated;

        ////    }
        ////    catch (Exception ex)
        ////    {
        ////        if (ex.Data["CustomExceptionInformation"] == null)
        ////            ex.Data["CustomExceptionInformation"] = "###Source Function Name - UpdateDocuments(), ParameterCount - 1, First Parameter- " + DataSetDocumentsforUpdate + "###";
        ////        if (ex.Data["DatasetInfo"] == null)
        ////            ex.Data["DatasetInfo"] = null;
        ////        throw (ex);
        ////    }
        ////    finally
        ////    {
        ////        objectClientMedications = null;
        ////    }


        ////    return null;
        ////}
        /// <summary> 
        /// <author>Jyothi Bellapu</author>
        /// <Dated>21th sept 2018</Dated>        
        /// </summary>
        /// <param name="ClientMedicationIds"></param>       
        /// <returns></returns>
        public DataSet PostClientMedicationsPrescribe(DataTable ClientMedicationIds)
        {
            Streamline.DataService.ClientMedication objClientMedication = new Streamline.DataService.ClientMedication();
            try
            {
                return objClientMedication.PostClientMedicationsPrescribe(ClientMedicationIds);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - PostClientMedicationsPrescribe(), ParameterCount - 1, First Parameter- " + ClientMedicationIds + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
            finally
            {

            }
        }
        /// <summary> 
        /// <author>Chandan Srivastava</author>
        /// <Dated>04th March 2009</Dated>
        /// Task #85 MM 1.7 - Prescribe Window Changes
        /// </summary>
        /// <param name="SessionId"></param>       
        /// <returns></returns>
        public void DeleteTempTables(string SessionID)
        {
            Streamline.DataService.ClientMedication objClientMedication = new Streamline.DataService.ClientMedication();
            try
            {
                objClientMedication.DeletePreviewTables(SessionID);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - DeleteTempTables(), ParameterCount - 1, First Parameter- " + SessionID + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
            finally
            {

            }
        }

        /// <summary> 
        /// <author>Chandan Srivastava</author>
        /// <Dated>04th March 2009</Dated>
        /// Task #2429 MM 1.7.3 - and Task #131
        /// </summary>
        /// <param name="SessionId"></param>       
        /// <returns></returns>
        public void DeleteInteractions(string MedicationInteractionIds)
        {
            Streamline.DataService.ClientMedication objClientMedication = new Streamline.DataService.ClientMedication();
            try
            {
                objClientMedication.DeleteInteractions(MedicationInteractionIds);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - DeleteInteractions(), ParameterCount - 1, First Parameter- " + MedicationInteractionIds + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
            finally
            {

            }
        }

        /// <summary>
        /// <Description>Get PatientEducationMonographId on the basis of ClientMedicationId</Description>
        /// <Task>#2465</Task>
        /// <Author>Loveena</Author>
        /// <CreationDate>07-May-2009</CreationDate>
        /// </summary>
        /// <param name="MedicationIds"></param>
        /// <returns></returns>
        public DataSet GetPatientMonographId(string MedicationIds)
        {
            try
            {
                return objectClientMedications.GetPatientMonographId(MedicationIds);

            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetPatientMonographId(), ParameterCount - 1, ###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }
            return null;


        }
        /// <summary>
        /// <Description>Get PatientEducationMonographFormatedText on the basis of PatientEducationMonographId</Description>
        /// <Task>#2465</Task>
        /// <Author>Loveena</Author>
        /// <CreationDate>07-May-2009</CreationDate>
        /// </summary>
        /// <param name="PatientEducationMonographId"></param>
        /// <returns></returns>
        public DataSet GetPatientEducationMonographSideEffects(Int32 PatientEducationMonographId)
        {
            try
            {
                return objectClientMedications.GetPatientEducationMonographSideEffects(PatientEducationMonographId);

            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetPatientEducationMonographSideEffects(), ParameterCount - 1, ###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }
            return null;


        }

        public DataSet GetDataForHarborStandardConsentRdlC(string _StoredProcedureName, int ClientId, string ClientMedicationId, int DocumentVersionId)
        {

            try
            {

                return objectClientMedications.GetDataForHarborStandardConsentRdlC(_StoredProcedureName, ClientId, ClientMedicationId, DocumentVersionId);

            }
            catch (Exception ex)
            {

                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetDataForHarborStandardConsentRdlC(), ParameterCount - 3, First Parameter- " + _StoredProcedureName + ",Second Paramenter- " + ClientId + "Third Parameter- " + ClientMedicationId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);

            }

        }
        #region--Code written by Pradeep as per task#15(Venture 10.0)
        /// <summary>
        /// <Decription>Used to pass parameters value  and send to dataservice layer to get titration template data from database</Decription>
        /// <Author>Pradeep</Author>
        /// <CreatedOn>Nov 12,2009</CreatedOn>
        /// </summary>
        /// <param name="medicationNameId"></param>
        /// <returns></returns>
        public DataSet GetTitrationTemplateData(int medicationNameId)
        {
            try
            {
                return objectClientMedications.GetTitrationTemplateData(medicationNameId);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - public DataSet GetTitrationTemplateData(int medicationNameId), ParameterCount - 2, First Parameter- " + medicationNameId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
        }
        #endregion

        public DataSet GetDataForPrescriberRdlC(string _StoredProcedureName, int PrescriberId, string LastReviewTime, string CurrentServerTime)
        {
            try
            {
                return objectClientMedications.GetDataForPrescriberRdlC(_StoredProcedureName, PrescriberId, LastReviewTime, CurrentServerTime);

            }
            catch (Exception ex)
            {

                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetDataForPrescriberRdlC(), ParameterCount - 1, First Parameter- " + _StoredProcedureName + ",Second Paramenter- " + PrescriberId + "Third Parameter- " + LastReviewTime + "Fourth Parameter- " + CurrentServerTime + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }


        }
        /// <summary>
        /// <Description>Used to get client consent history as per task#16</Description>
        /// <Author>Pradeep</Author>
        /// <CreatedOn>Oct 28,2009</CreatedOn>
        /// </summary>
        /// <param name="ClientId"></param>
        /// <returns></returns>
        public DataSet DownloadClientConsentHistory(Int64 ClientId)
        {

            try
            {
                return objectClientMedications.DownloadClientConsentHistory(ClientId);

            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - DownloadClientConsentHistory(), ParameterCount -1, First Parameter- " + ClientId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);

            }
            finally
            {

            }
        }
        /// <summary>
        /// <Decription>Used to get titration template Name  from database</Decription>
        /// <Author>Anuj</Author>
        /// <CreatedOn>Nov 14,2009</CreatedOn>
        /// </summary>
        /// <param name="medicationNameId"></param>
        /// <returns></returns>
        public string SelectTemplateName(string TitrationTemplateName)
        {
            try
            {
                return objectClientMedications.SelectTemplateName(TitrationTemplateName);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - public string SelectTemplateName(string TitrationTemplateName), ParameterCount - 1, First Parameter- " + TitrationTemplateName + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
        }
        //Code added by Loveena in ref to Task#32
        //public DataSet GetVerbalOrderReviewData(int StaffId, string OrderType)
        //{
        //    try
        //    {
        //        return objectClientMedications.GetVerbalOrderReviewData(StaffId, OrderType);
        //    }
        //    catch (Exception ex)
        //    {
        //        if (ex.Data["CustomExceptionInformation"] == null)
        //            ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetMedicationOrderDetails(), ParameterCount - 1, First Parameter- " + StaffId + "###";
        //        if (ex.Data["DatasetInfo"] == null)
        //            ex.Data["DatasetInfo"] = null;
        //        throw ex;
        //    }

        //}
        #region--Code Written By Pradeep as per task#31
        /// <summary>
        /// <Description>Used to send parameters to DAL to update PermitChangesByOtherUsers field in ClientMedication table</Description>
        /// <Author>Pradeep</Author>
        /// <CreatedOn>Nov 25,2009</CreatedOn>
        /// </summary>
        /// <param name="ClientMedicationId"></param>
        /// <param name="PermithangesByOtherUsers"></param>
        /// <param name="ModifiedBy"></param>
        /// <returns></returns>
        public int SavePermitChangesByOtherUsers(int ClientMedicationId, char PermithangesByOtherUsers, string ModifiedBy)
        {
            try
            {
                return objectClientMedications.SavePermitChangesByOtherUsers(ClientMedicationId, PermithangesByOtherUsers, ModifiedBy);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - SavePermitChangesByOtherUsers(), ParameterCount - 3, First Parameter- " + ClientMedicationId + " Second Parameter- " + PermithangesByOtherUsers + " ThirdParameter- " + ModifiedBy + " ###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
        }
        #endregion

        /// <summary>
        /// <Decription>Used to get the data for HealthDataList (task ref # 34 SDI-Venture 10</Decription>
        /// <Author>Anuj</Author>
        /// <CreatedOn>Nov 25,2009</CreatedOn>
        /// </summary>
        /// <param name="medicationNameId"></param>
        /// <returns></returns>
        public DataSet GetHeathDataListRecords(int ClientId, int HealthDataCategoryId)
        {
            try
            {
                return objectClientMedications.GetHeathDataListRecords(ClientId, HealthDataCategoryId);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetHeathDataListRecords(), ParameterCount - 2, First Parameter- " + ClientId + "Second Parameter-" + HealthDataCategoryId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }

        }
        /// <summary>
        /// <Decription>Used to get the data for HealthDataAlerts</Decription>
        /// <CreatedOn>Oct 24,2014</CreatedOn>
        /// </summary>
        public DataSet GetHealthMaintenaceAlertData(int ClientId, int StaffId)
        {
            try
            {
                return objectClientMedications.GetHealthMaintenaceAlertData(ClientId, StaffId);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetHealthMaintenaceAlertData(), ParameterCount - 2, First Parameter- " + ClientId + "Second Parameter-" + StaffId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }

        }

        public DataTable GetGrowthChartCategories(int clientId)
        {
            try
            {
                return objectClientMedications.GetGrowthChartCategories(clientId);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetGrowthChartData(int ClientId,string growthchartvalue), ParameterCount - 1, First Parameter- " + clientId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }
        }

        public DataSet GetGrowthChartData(int clientId, int graphType)
        {
            try
            {
                return objectClientMedications.GetGrowthChartData(clientId, graphType);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetGrowthChartData(int clientId, int graphType), ParameterCount - 2, First Parameter- " + clientId + ", Second Parameter- " + graphType + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }
        }

        /// <summary>
        /// <Decription>Used to Bind HealthData DropDown (task ref # 34 SDI-Venture 10</Decription>
        /// <Author>Anuj</Author>
        /// <CreatedOn>Nov 25,2009</CreatedOn>
        /// </summary>
        /// <param name="medicationNameId"></param>
        /// <returns></returns>
        public DataSet GetHeathDataCategories(int ClientId)
        {
            try
            {
                return objectClientMedications.GetHeathDataCategories(ClientId);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetHeathDataListRecords(int ClientId), ParameterCount - 1, First Parameter- " + ClientId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }

        }
        /// <summary>
        /// <Decription>Used to Delete the HealthData Record (task ref # 34 SDI-Venture 10</Decription>
        /// <Author>Anuj</Author>
        /// <CreatedOn>Nov 26,2009</CreatedOn>
        /// </summary>
        /// <param name="medicationNameId"></param>
        /// <returns></returns>
        public int DeleteHeathDataRecord(int HealthDataId, string DeletedBy)
        {
            try
            {
                return objectClientMedications.DeleteHeathDataRecord(HealthDataId, DeletedBy);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - DeleteHeathDataRecord(int HealthDataId), ParameterCount - 1, First Parameter- " + HealthDataId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }

        }
        /// <summary>
        /// <Decription>Used to Bind HealthDataGraphDropDown (task ref # 34 SDI-Venture 10</Decription>
        /// <Author>Anuj</Author>
        /// <CreatedOn>Nov 27,2009</CreatedOn>
        /// </summary>
        /// <param name="medicationNameId"></param>
        /// <returns></returns>
        public DataSet GetHeathDataGraphDropDown(int ClientId)
        {
            try
            {
                return objectClientMedications.GetHeathDataGraphDropDown(ClientId);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetHeathDataGraphDropDown(int ClientId), ParameterCount - 1, First Parameter- " + ClientId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }

        }

        //Code added by Loveena in ref to Task#3
        public DataSet GetVerbalOrderReviewData(int StaffId, string OrderType)
        {
            try
            {
                return objectClientMedications.GetVerbalOrderReviewData(StaffId, OrderType);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetMedicationOrderDetails(), ParameterCount - 1, First Parameter- " + StaffId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }

        }
        /// <summary>
        /// <Decription>Used to Bind HealthDataGraphDropDown (task ref # 34 SDI-Venture 10</Decription>
        /// <Author>Anuj</Author>
        /// <CreatedOn>Nov 27,2009</CreatedOn>
        /// </summary>
        /// <param name="medicationNameId"></param>
        /// <returns></returns>
        //public DataSet GetSignatureStatusRecord(int ClientMedicationId)
        public DataSet GetSignatureStatusRecord(int ClientMedicationConsentId)
        {
            try
            {
                return objectClientMedications.GetSignatureStatusRecord(ClientMedicationConsentId);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetSignatureStatusRecord(int ClientMedicationId), ParameterCount - 1, First Parameter- " + ClientMedicationConsentId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }

        }
        #region--Code Written By Pradeep as per task#1
        /// <summary>
        /// <Description>Used to send parameters to DAL to get data for Discontinued RDLC against passed parameters</Description>
        /// <Author>Pradeep</Author>
        /// <CreatedOn>2 Dec,2009</CreatedOn>
        /// </summary>
        /// <param name="_StoredProcedureName"></param>
        /// <param name="ClientMedicationId"></param>
        /// <param name="Method"></param>
        /// <param name="InitiatedBy"></param>
        /// <param name="PharmacyId"></param>
        /// <returns></returns>
        public DataSet GetDataForDisContinueRdlC(string _StoredProcedureName, int ClientMedicationId, string Method, int InitiatedBy, int PharmacyId)
        {
            try
            {
                return objectClientMedications.GetDataForDisContinueRdlC(_StoredProcedureName, ClientMedicationId, Method, InitiatedBy, PharmacyId);

            }
            catch (Exception ex)
            {

                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - public DataSet GetDataForDisContinueRdlC(string _StoredProcedureName, int ClientMedicationId, string Method, int InitiatedBy, int PharmacyId), ParameterCount - 5, First Parameter- " + ClientMedicationId + "Second Parameter-" + ClientMedicationId.ToString() + "Third Parameter-" + Method.ToString() + "Fourth Parameter-" + InitiatedBy.ToString() + "Fifth Parameter-" + PharmacyId.ToString() + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }


        }
        #endregion
        /// <summary>
        /// <Decription>Used to Update ClientMedicationConsentDocument</Decription>
        /// <Author>Anuj</Author>
        /// <CreatedOn>Dec 20,2009</CreatedOn>
        /// </summary>
        /// <param name="medicationNameId"></param>
        /// <returns></returns>
        public int UpdateClientMedicationConsentDocuments(int ClientMedicationConsentId, string ModifiedBy)
        {
            try
            {
                return objectClientMedications.UpdateClientMedicationConsentDocuments(ClientMedicationConsentId, ModifiedBy);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - UpdateClientMedicationConsentDocuments(int ClientMedicationId,string ModifiedBy), ParameterCount - 1, First Parameter- " + ClientMedicationConsentId + " , Second Parameter- " + ModifiedBy + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }

        }
        /// <summary>
        /// <Decription>Will Get the DocumentVersionIds (task ref # 18 SDI-Venture 10</Decription>
        /// <Author>Anuj</Author>
        /// <CreatedOn>20 Dec,2009</CreatedOn>
        /// </summary>
        /// <param name="medicationNameId"></param>
        /// <returns></returns>
        public DataSet GetDocumentVersionId(int DocumentId)
        {
            try
            {
                return objectClientMedications.GetDocumentVersionId(DocumentId);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetDocumentVersionId(int DocumentId), ParameterCount - 1, First Parameter- " + DocumentId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }

        }
        /// <summary>
        /// <Decription>Used to Update ClientMedicationConsentDocument if the consent happens for checkboxes</Decription>
        /// <Author>Anuj</Author>
        /// <CreatedOn>Dec 20,2009</CreatedOn>
        /// </summary>
        /// <param name="medicationNameId"></param>
        /// <returns></returns>
        public int UpdateMultipleClientMedicationConsentDocuments(int DocumentVersionId, string ModifiedBy)
        {
            try
            {
                return objectClientMedications.UpdateMultipleClientMedicationConsentDocuments(DocumentVersionId, ModifiedBy);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - UpdateMultipleClientMedicationConsentDocuments(int DocumentVersionId,string ModifiedBy), ParameterCount - 1, First Parameter- " + DocumentVersionId + " , Second Parameter- " + ModifiedBy + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }

        }
        /// <summary>
        /// <Decription>Will Get all the clientMedicationID of same versionId for Passed ClientMedicationID(task ref # 18 SDI-Venture 10</Decription>
        /// <Author>Anuj Tomar</Author>
        /// <CreatedOn>22 Dec,2009</CreatedOn>
        /// </summary>
        /// <param name="medicationNameId"></param>
        /// <returns></returns>
        //public DataSet GetClientMedicationIds(int ClientMedicationId)
        public DataSet GetClientMedicationIds(int ClientMedicationConsentId, int ClientId)
        {
            try
            {
                return objectClientMedications.GetClientMedicationIds(ClientMedicationConsentId, ClientId);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetClientMedicationIds(int ClientMedicationId), ParameterCount - 1, First Parameter- " + ClientMedicationConsentId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }

        }
        //Getting latest version id
        public DataSet GetClientMedicationversionId(int ClientMedicationConsentId)
        {
            try
            {
                return objectClientMedications.GetClientMedicationversionId(ClientMedicationConsentId);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetClientMedicationIds(int ClientMedicationId), ParameterCount - 1, First Parameter- " + ClientMedicationConsentId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }

        }

        /// <summary>
        /// Author Loveena.
        /// It is used to Fill Drug Dropdown.
        /// </summary>
        /// <param name="MedicationName"></param>
        /// <returns></returns>

        public DataSet FillDrugDropDown(int medicationId)
        {
            try
            {
                return objectClientMedications.FillDrugDropDown(medicationId);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - FillDrugDropDown(), ParameterCount - 1, First Parameter- " + medicationId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }

        }

        //Getting latest version id
        public DataSet GetHeathDataGraphItems(int ClientId, int HealthDataCategoryId)
        {
            try
            {
                return objectClientMedications.GetHeathDataGraphItems(ClientId, HealthDataCategoryId);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetHeathDataGraphItems(int ClientMedicationId), ParameterCount - 1, First Parameter- " + ClientId + "- Second Parameter- " + HealthDataCategoryId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }

        }

        //// <summary>
        /// <CreatedBy>Loveena</CreatedBy>
        /// <Purpose>Ref to Task#2802</Purpose>
        /// </summary>
        /// <param name="MedicationId"></param>
        /// <returns></returns>
        public DataSet CalculateAutoCalcAllow(int MedicationId)
        {
            try
            {
                return objectClientMedications.CalculateAutoCalcAllow(MedicationId);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - CalculateAutoCalcAllow(), ParameterCount -1, First Parameter- " + MedicationId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
        }

        /// <summary>
        /// <CreatedBy>Loveena</CreatedBy>
        /// <Purpose>Ref to Task#2905</Purpose>
        /// </summary>
        /// <param name="MedicationId"></param>
        /// <returns></returns>
        public DataSet CalculateDispenseQuantity(int MedicationId, float dosage, string schedule, int days)
        {
            try
            {
                return objectClientMedications.CalculateDispenseQuantity(MedicationId, dosage, schedule, days);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - CalculateDispenseQuantity(), ParameterCount -1, First Parameter- " + MedicationId + "###";
                    
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
        }
        /// <summary>
        /// Added By Anuj Tomar TO revoke the Medication Consent
        /// </summary>
        /// <param name="DocumentVersionId"></param>
        /// <param name=""></param>
        /// <param name="ModifiedBy"></param>
        /// <returns>int</returns>       
        public int RevokeMedication(string SignedBy, int DocumentVersionId, string ModifiedBy)
        {

            try
            {
                return objectClientMedications.RevokeMedication(SignedBy, DocumentVersionId, ModifiedBy);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - RevokeMedication(), ParameterCount - 2, First Parameter- " + DocumentVersionId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
            finally
            {

            }

        }
        /// <summary>
        /// Added By Anuj Tomar To get the Dose Information 
        /// </summary>
        /// <param name="DocumentVersionId"></param>
        /// <param name=""></param>
        /// <param name="ModifiedBy"></param>
        /// <returns>int</returns>     
        public DataSet FillDosageInfoText(int MedicationNameId, string ClientDOB)
        {
            try
            {
                return objectClientMedications.FillDosageInfoText(MedicationNameId, ClientDOB);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - FillDosageInfoText(), ParameterCount - 1, First Parameter- " + MedicationNameId + " Second Parameter- " + ClientDOB + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }

        }

        /// <summary>
        /// Returns dataset with drug order template for this prescriber/drug/strength
        /// </summary>
        /// <author>Chuck Blaine</author>
        /// <WrittenOn>July 15 2013</WrittenOn>
        /// <param name="MedicationId">MedicationId</param>
        /// <returns>Dataset</returns>     
        public DataSet LoadDrugOrderTemplate(int MedicationId, int staffId)
        {
            try
            {
                return objectClientMedications.LoadDrugOrderTemplate(MedicationId, staffId);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - LoadDrugOrderTemplate(), ParameterCount - 1, First Parameter- " + MedicationId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }

        }

        /// <summary>
        /// <Decription>Will Get all the Current Client Medications</Decription>
        /// <Author>Anuj</Author>
        /// <CreatedOn>Feb 1,2010</CreatedOn>
        /// </summary>
        /// <param name="ClientId"></param>
        /// <returns></returns>
        public DataSet GetClientCurrentMedications(int ClientId)
        {
            try
            {
                return objectClientMedications.GetClientCurrentMedications(ClientId);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetClientCurrentMedications(int ClientId), ParameterCount - 1, First Parameter- " + ClientId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }

        }
        /// <summary>
        /// <Author>Chandan.</Author>
        /// It is used to SearchPharmacies .
        /// <CreatedOn>01st Feb 2010</CreatedOn>              
        /// </summary>        
        public DataSet GetSearchPharmacies(string PharmacyName, string Address, string City, string State, string Zip, string PhoneNumber, string FaxNumber, int PharmacyId, string SureScriptIdentifier, string Specialty, int startrowIndex, int endRowIndex)
        {
            try
            {
                DataSet dataSetPharmacies = objectClientMedications.GetSearchPharmacies(PharmacyName, Address, City, State, Zip, PhoneNumber, FaxNumber, PharmacyId, SureScriptIdentifier, Specialty, startrowIndex, endRowIndex);
                //TotalRecords = int.Parse(dataSetPharmacies.Tables["TotalRecords"].Rows[0]["TotalRecords"].ToString());
                return dataSetPharmacies;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetClientPharmacies(), ParameterCount - 0 ###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }

        }
        /// <summary> 
        /// <author>Sahil Bhagat</author>
        /// <Dated>Feb. 09,2010</Dated>
        /// Task #85 
        /// </summary>
        /// <param name="PreferredPharmacyId"></param>
        /// <param name="SureScriptsPharmacyId"></param>
        /// <param name="User Code"></param>
        /// Modified By Priya Ref:Task no:85
        /// <returns></returns>
        public DataSet MergePharmacy(int PreferredPharmacyId, int SureScriptsPharmacyId, string UserCode)
        {
            try
            {
                if (SureScriptsPharmacyId != null)
                {
                    objectClientMedications.MergePharmacy(PreferredPharmacyId, SureScriptsPharmacyId, UserCode);
                }
            }
            catch (Exception ex)
            {

                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - ssp_PharmaciesMerge(), ParameterCount - 3, First Parameter- " + PreferredPharmacyId + " , Second Parameter- " + SureScriptsPharmacyId + ", Third Parameter- " + UserCode + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
            finally
            {
                objectClientMedications = null;
            }


            return null;
        }

        /// <summary>
        /// Author Loveena
        /// determine whether the script(s) can be sent via SureScripts.
        /// </summary>       
        /// <returns></returns>
        public DataSet SureScriptsAvailable(int PharmacyId, int PrescriberId, int LocationId)
        {
            try
            {
                return objectClientMedications.SureScriptsAvailable(PharmacyId, PrescriberId, LocationId);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetClientPharmacies(), ParameterCount - 0 ###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }
        }


        /// <summary>
        /// Author PranayB
        /// Check ElectroninPrescriptionPermissions.
        /// </summary>       
        /// <returns>Table</returns>
        public DataSet ElectronicPrescriptionPermissions(int PrescriberId,int PharmacyId)
        {
            try
            {
                return objectClientMedications.ElectronicPrescriptionPermissions(PrescriberId,PharmacyId);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - ElectronicPrescriptionPermissions(), ParameterCount - 0 ###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }
        }


        /// <summary>
        /// Author Loveena
        /// task#3233 - 2.3 Order Details / Print Medication Order Dialog Changes
        /// </summary>       
        /// <returns></returns>
        public DataSet ReprintAllowed(int ClientMedicationScriptId, string Method)
        {
            try
            {
                return objectClientMedications.ReprintAllowed(ClientMedicationScriptId, Method);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - ReprintAllowed(), ParameterCount - 2 ###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }
        }

        public DataRow GetPharmacyById(Int32 pharmacyId)
        {
            try
            {
                return objectClientMedications.GetPharmacyById(pharmacyId)
                ;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetPharmacyById(pharmacyId), ParameterCount - 1 ###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }
        }

        /// <summary>
        /// <Author>Loveena.</Author>
        /// It is used to GetPharmacies .
        /// <CreatedOn>08 Nov 2010</CreatedOn>              
        /// </summary>        
        public DataSet GetAllPharmacies()
        {
            try
            {
                return objectClientMedications.GetAllPharmacies();
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetAllPharmacies(), ParameterCount - 0 ###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }

        }
        #region--Code written by Loveena as per task#3287
        public DataSet GetOrderingMethodAllowed(int ClientMedicationScriptId)
        {
            try
            {
                return objectClientMedications.GetOrderingMethodAllowed(ClientMedicationScriptId);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - ReprintAllowed(), ParameterCount - 2 ###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }
        }

        public DataSet GetOrderingMethodAllowedFinal(int ClientMedicationScriptId)
        {
            try
            {
                return objectClientMedications.GetOrderingMethodAllowedFinal(ClientMedicationScriptId);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - ReprintAllowed(), ParameterCount - 2 ###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }
        }
        //GetValidationStatus
        /// <summary>
        /// <Description>Used to get validation status of script as per task#3305</Description>
        /// </summary>
        /// <param name="ClientMedicationScriptId"></param>
        /// <returns></returns>
        public DataSet GetValidationStatus(int ClientMedicationScriptId, char capNonControlled, char capControlled, string[] Queuedvalues)
        {
            try
            {
                return objectClientMedications.GetValidationStatus(ClientMedicationScriptId, capNonControlled, capControlled, Queuedvalues);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - ReprintAllowed(), ParameterCount - 2 ###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }
        }


       
        /// <summary>
        /// <Description>Used to get check if the MedicationPrescibed and ChangeMedication are Same</Description>
        /// </summary>
        /// <param name="ClientMedicationScriptId"></param>
        /// <returns></returns>
        public string   ValidateChangeMedicationList(int ClientMedicationScriptId, int SureScriptsChangeRequestId)
        {
          try
          {
              return objectClientMedications.ValidateChangeMedicationList(ClientMedicationScriptId, SureScriptsChangeRequestId);
          }
          catch(Exception ex)
          {
            if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - ValidateChangeMedicationList(), ParameterCount - 2 ###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
          }
        }
          




        /// <summary>
        /// <Description>Used to update clientMedicationScriptPreview tables</Description>
        /// <Author>Pradeep</Author>
        /// </summary>
        /// <param name="DataSetClientMedicationScriptPreview"></param>
        /// <returns></returns>
        public DataSet UpdateClientMedicationScriptPreview(DataSet DataSetClientMedicationScriptPreview)
        {
            try
            {
                Streamline.UserBusinessServices.DataSets.DataSetClientMedications dsUpdated = new Streamline.UserBusinessServices.DataSets.DataSetClientMedications();
                if (DataSetClientMedicationScriptPreview.GetChanges() != null)
                {
                    //The following object initialization is written by Pradeep
                    if (objectClientMedications == null)
                    {
                        objectClientMedications = new Streamline.DataService.ClientMedication();
                    }
                    DataSetClientMedicationScriptPreview = objectClientMedications.UpdateClientMedicationScriptPreview(DataSetClientMedicationScriptPreview);
                }
                dsUpdated.Merge(DataSetClientMedicationScriptPreview);
                return dsUpdated;

            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - UpdateDocuments(), ParameterCount - 1, First Parameter- " + DataSetClientMedicationScriptPreview + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
            finally
            {
                objectClientMedications = null;
            }


            return null;
        }

        #endregion
        #region--Code Written by Pradeep as per task#3346 on 17 March 2011
        /// <summary>
        /// <Description>Used to get pharmacy edit alowed status</Description>
        /// <Author>Pradeep</Author>
        /// <CreatedOn>17 March 2011</CreatedOn>
        /// </summary>
        /// <param name="PharmacyId"></param>
        /// <returns></returns>
        public DataSet GetPharmacyEditAllowedStaus(int PharmacyId)
        {
            try
            {
                return objectClientMedications.GetPharmacyEditAllowedStaus(PharmacyId);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - DataSet GetPharmacyEditAllowedStaus(int PharmacyId), ParameterCount - 1 ###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }

        }
        /// <summary>
        /// <Description>Used to get pharmacy insert/Update Ststus</Description>
        /// <Author>Pradeep</Author>
        /// <CreatedOn>17 March 2011</CreatedOn>
        /// </summary>
        /// <param name="PharmacyId"></param>
        /// <returns></returns>
        public DataSet GetPharmacyValidationStatus(string PharmacyName, char Active, char PreferredPharmacy, string PhoneNumber, string FaxNumber, string Email, string Address, string City, string State, string ZipCode, string SurescriptsPharmacyIdentifier, Int32 PharmacyId)
        {
            try
            {
                return objectClientMedications.GetPharmacyValidationStatus(PharmacyName, Active, PreferredPharmacy, PhoneNumber, FaxNumber, Email, Address, City, State, ZipCode, SurescriptsPharmacyIdentifier, PharmacyId);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - public DataSet GetPharmacyValidationStatus(string PharmacyName, char Active, char PreferredPharmacy, string PhoneNumber, string FaxNumber, string Email, string Address, string City, string State, string ZipCode, string SurescriptsPharmacyIdentifier), ParameterCount - 11 ###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }

        }

        /// <summary>
        /// Retrieves the NoKnownAllergy Flag from the client table using the scsp_SCClientMedicationClientInformation proc
        /// </summary>
        /// <param name="ClientId"></param>
        /// <returns></returns>
        public bool GetNoKnownAllergiesFlag(Int32 ClientId, string CheckboxFlag)
        {
            try
            {
                return objectClientMedications.GetNoKnownAllergiesFlag(ClientId, CheckboxFlag);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - public bool GetNoKnownAllergiesFlag(int32 ClientId), ParameterCount - 1 ###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }
        }

	public void UpdateNoMedicationsFlag(Int32 ClientId, string CheckboxFlag)
        {
            try
            {
                objectClientMedications.UpdateNoMedicationsFlag(ClientId, CheckboxFlag);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - public void UpdateNoMedicationsFlag(int32 ClientId), ParameterCount - 1 ###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }
        }

        /// <summary>
        /// Get the Reconciliation Drop Down list and Data 
        /// </summary>
        /// <param name="ClientId"></param>
        /// <returns></returns>
        public DataSet GetReconciliationData(Int32 DocumentVersionId,Int32 ReconciliationTypeId)
        {
            try
            {
                return objectClientMedications.GetReconciliationData(DocumentVersionId,ReconciliationTypeId);

            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetReconciliationData(int ClientId) ###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }
        }

        public void GetMedReconciliationData(Int32 GlobalCodeId, Int32 DocumentVersionId, Int32 ClientId, Int32 StaffId, Int32 ReconciliationTypeId, String RowIdentifier)
        {
            try
            {
                objectClientMedications.GetMedReconciliationData(GlobalCodeId, DocumentVersionId, ClientId, StaffId, ReconciliationTypeId, RowIdentifier);

            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetMedReconciliationData(int GlobalCodeId,int DocumentVersionId,int ClientId, int StaffId,char ReconciliationType) ###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }
        }


        public DataSet GetRecData(Int32 DocumentVersionId,Int32 ReconciliationTypeId,Int32 ClientId, Int32 StaffId)
        {
            try
            {
                return objectClientMedications.GetRecData(DocumentVersionId,ReconciliationTypeId,ClientId,StaffId);

            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetReconciliationData(int ClientId) ###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }
        }

        /// <summary>
        /// Get the Reconciliation Drop Down list
        /// </summary>
        /// <param name="ClientId"></param>
        /// <returns></returns>
        public DataSet GetReconciliationDropDown(Int32 ClientId)
        {
            try
            {
                return objectClientMedications.GetReconciliationDropDown(ClientId);

            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetReconciliationDropDown(int ClientId) ###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }
        }
        public DataSet GetMedReconciliationDropDown()
        {
            try
            {
                return objectClientMedications.GetMedReconciliationDropDown();

            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetMedReconciliationDropDown() ###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }
        }

        #endregion

        /// <summary>
        /// Check Image Server Connection String, if not blank then create a new FaxData record, 
        /// set passed in datarow FaxImageData to blank otherwise set the passed in datarow FaxImageData to rendered data
        /// </summary>
        /// <param name="ds"></param>
        /// <param name="dr"></param>
        /// <param name="ScriptId"></param>
        public void SetRenderedImageData(DataSet ds, DataRow dr, string userCode, byte[] renderedBytes)
        {
            if (HasImageServerString())
            {
                dr["FaxImageData"] = System.DBNull.Value;
                DataRow drClientMedicationScriptsActivityFaxData = ds.Tables["ClientMedicationScriptActivitiesFaxData"].NewRow();
                drClientMedicationScriptsActivityFaxData["FaxImageData"] = renderedBytes;
                drClientMedicationScriptsActivityFaxData["CreatedBy"] = userCode;
                drClientMedicationScriptsActivityFaxData["CreatedDate"] = DateTime.Now;
                drClientMedicationScriptsActivityFaxData["ModifiedBy"] = userCode;
                drClientMedicationScriptsActivityFaxData["ModifiedDate"] = DateTime.Now;
                drClientMedicationScriptsActivityFaxData["ClientMedicationScriptActivityId"] = dr["ClientMedicationScriptActivityId"];
                ds.Tables["ClientMedicationScriptActivitiesFaxData"].Rows.Add(
                    drClientMedicationScriptsActivityFaxData);
            }
            else
            {
                dr["FaxImageData"] = renderedBytes;
            }
        }

        public bool CheckForDrugCategory2(Int32 MedicationNameId)
        {
            return objectClientMedications.CheckForDrugCategory2(MedicationNameId);
        }

        public DataSet FillPotencyUnitCodesByMedicationNameId(int MedicationNameId)
        {
            try
            {
                return objectClientMedications.FillPotencyUnitCodesByMedicationNameId(MedicationNameId);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - FillPotencyUnitCodesByMedicationNameId(), ParameterCount - 1, First Parameter- " + MedicationNameId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }

        }

        public DataSet FillMedicationRelatedInformation(int MedicationId, int ClientId)
        {
            try
            {
                return objectClientMedications.FillMedicationRelatedInformation(MedicationId,ClientId);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - FillPotencyUnitCodesByMedicationNameId(), ParameterCount - 1, First Parameter- " + MedicationId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }

        }
        /// <summary>
        /// Author:Anto
        /// </summary>
        /// <param name="clientid"></param>
        /// <returns>DataSet</returns>
        public DataSet GetPatientoverviewdetails(int clientid)
        {
            try
            {
                DataSet ds = objectClientMedications.GetPatientoverviewdetails(clientid);
                return ds;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetPatientoverviewdetails(), ParameterCount - 1,  Parameter- " + clientid + "";
                throw (ex);
            }
            finally
            {

            }

        }
        //Author:Aravind 
        //Functions to Update KeyPhrases
        //Task #476.04 - CEI Enhancements 
        public DataSet UpdateKeyPhrases(DataSet DataSetKeyPhrases)
        {
            try
            {
                Streamline.UserBusinessServices.DataSets.DataSetKeyPhrases dsUpdated = new Streamline.UserBusinessServices.DataSets.DataSetKeyPhrases();
                if (DataSetKeyPhrases.GetChanges() != null)
                {

                    DataSetKeyPhrases = objectClientMedications.UpdateKeyPhrases(DataSetKeyPhrases);
                }
                if (!DataSetKeyPhrases.Tables.Contains("KeyPhrases"))
                //    dsUpdated.EnforceConstraints = false;
                //dsUpdated.Merge(DataSetKeyPhrases);
                return DataSetKeyPhrases;

            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - UpdateKeyPhrases(), ParameterCount - 1, First Parameter- " + DataSetKeyPhrases + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
            finally
            {
                objectClientMedications = null;
            }


            return null;
        }

        public DataSet UpdateAgencyKeyPhrases(DataSet DataSetKeyPhrases)
        {
            try
            {
                Streamline.UserBusinessServices.DataSets.DataSetKeyPhrases dsUpdated = new Streamline.UserBusinessServices.DataSets.DataSetKeyPhrases();
                if (DataSetKeyPhrases.GetChanges() != null)
                {

                    DataSetKeyPhrases = objectClientMedications.UpdateAgencyKeyPhrases(DataSetKeyPhrases);
                }
                if (DataSetKeyPhrases.Tables.Contains("AgencyKeyPhrases"))
                //    dsUpdated.EnforceConstraints = false;
                //dsUpdated.Merge(DataSetKeyPhrases);
                return DataSetKeyPhrases;

            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - UpdateAgencyKeyPhrases(), ParameterCount - 1, First Parameter- " + DataSetKeyPhrases + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
            finally
            {
                objectClientMedications = null;
            }


            return null;
        }


        #region IDisposable Members

        public void Dispose()
        {
           
        }

        #endregion
    }
}


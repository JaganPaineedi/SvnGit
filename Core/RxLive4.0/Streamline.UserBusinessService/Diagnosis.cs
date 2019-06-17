using System;
using System.Collections.Generic;
using System.Text;
using System.Data;

namespace Streamline.UserBusinessServices
{
    public class Diagnosis
    {
        private Streamline.DataService.Diagnosis diagnosisObject = null;
        

        /// <summary>
        /// This gets the Data for the Diagnosis to be shown in the Grid
        /// </summary>
        /// <param name="dsmcode"></param>
        /// <param name="userid"></param>
        /// <param name="DataWizardInstanceId"></param>
        /// <param name="PreviousDataWizardInstanceId"></param>
        /// <param name="NextStepId"></param>
        /// <param name="NextWizardId"></param>
        /// <param name="EventId"></param>
        /// <param name="ClientID"></param>
        /// <param name="ClientSearchGUID"></param>
        /// <returns>DataSet</returns>
        /// <Author>Jatinder Singh</Author>
        /// <Date Created>3-Oct-2007</Date>
        public DataSet GetDiagnosisData(string SPName, int userid, int DataWizardInstanceId, int PreviousDataWizardInstanceId, int NextStepId, int NextWizardId, int EventId, int ClientID, string ClientSearchGUID)
        {
            try
            {
                diagnosisObject = new Streamline.DataService.Diagnosis();
                return diagnosisObject.GetDiagnosisData(SPName, userid, DataWizardInstanceId, PreviousDataWizardInstanceId, NextStepId, NextWizardId, EventId, ClientID, ClientSearchGUID);
            }
            catch (Exception ex)
            {                
                throw ex;
            }

        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="dsmcode"></param>
        /// <returns></returns>
        public DataSet GetDSMCodeData(string DSMCode, string DSMDesc)
        {
            try
            {
                diagnosisObject = new Streamline.DataService.Diagnosis();
                return diagnosisObject.GetDSMCodeData(DSMCode, DSMDesc);
            }
            catch (Exception ex)
            {
               throw ex;
            }
        }



        /// <summary>
        /// Gets the Code for the code selected by the user
        /// </summary>
        /// <Author>Vindu Puri</Author>
        /// <Date Created>13-Feb-2008</Date>
        /// <param name="dsmcode"></param>
        /// <returns></returns>
        public string GetDSMCode(string DSMCode, string DSMDesc)
        {
            try
            {
                diagnosisObject = new Streamline.DataService.Diagnosis();
                return diagnosisObject.GetDSMCode(DSMCode, DSMDesc);
            }
            catch (Exception ex)
            {               
                throw ex;
            }
        }

        /// <summary>
        /// Accepts DataSet from the Presentation Layer and
        /// Passes it to DataServices Layer and return boolean value if succeeded
        /// </summary>
        /// <Author>Jatinder Singh</Author>
        /// <Date Created>3-Oct-2007</Date>
        /// <param name="DataSetDiagnosis">DataSet.</param>
        /// <returns>bool</returns>
        public bool UpdateDiagnosis(DataSet DataSetDiagnosis)
        {
            try
            {
                //Allocating memory to object DiagnosisObj 
                diagnosisObject = new Streamline.DataService.Diagnosis();

                //Returns true if data is updated in the database
                return diagnosisObject.UpdateDiagnosis(DataSetDiagnosis);

            }
            catch (Exception ex)
            {             
                throw (ex);
            }
            finally
            {
                //Assigning null to object MyPreferenceObj 
                diagnosisObject = null;
            }
        }

        /// <summary>
        /// Accepts DataSet from the Presentation Layer and
        /// Passes it to DataServices Layer and return boolean value if succeeded
        /// </summary>
        /// <Author>Jatinder Singh</Author>
        /// <Date Created>3-Oct-2007</Date>
        /// <param name="DataSetDiagnosis">DataSet.</param>
        /// <returns>bool</returns>
        public DataSet UpdateDiagnosisData(DataSet DataSetDiagnosis, string _SPName, int userid, int DataWizardInstanceId, int PreviousDataWizardInstanceId, int NextStepId, int NextWizardId, int EventId, int ClientID, string ClientSearchGUID, bool Validate, Int32 ProviderId)
        {
            try
            {
                //Allocating memory to object DiagnosisObj 
                diagnosisObject = new Streamline.DataService.Diagnosis();

                //Returns true if data is updated in the database
                return diagnosisObject.UpdateDiagnosisData(DataSetDiagnosis, _SPName, userid, DataWizardInstanceId, PreviousDataWizardInstanceId, NextStepId, NextWizardId, EventId, ClientID, ClientSearchGUID, Validate, ProviderId);

            }
            catch (Exception ex)
            {               
                throw (ex);
            }
            finally
            {
                //Assigning null to object MyPreferenceObj 
                diagnosisObject = null;
            }
        }
    }
}

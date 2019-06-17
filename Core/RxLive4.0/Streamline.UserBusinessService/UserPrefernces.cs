using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
namespace Streamline.UserBusinessServices
{
    public class UserPrefernces
    {
        Streamline.DataService.UserPreferences objUserPreferences = null;
        public UserPrefernces()
        {
            objUserPreferences = new Streamline.DataService.UserPreferences();
        }
        public DataSet DownloadStaffMedicationDetail()
        {
            try
            {
                return objUserPreferences.DownloadStaffMedicationDetail();
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - DownloadStaffMedicationDetail(), ParameterCount - 0 ###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }
        }
        //Changes to merge.
        public DataSet CheckStaffPermissions(int StaffId)
        {
            try
            {
                return objUserPreferences.CheckStaffPermissions(StaffId);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - CheckStaffPermissions(), ParameterCount - 0 ###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }
        }
        public bool CheckUserNameExists(Int32 StaffId, string userCode)
        {
            try
            {
                return objUserPreferences.CheckUserNameExists(StaffId, userCode);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - CheckUserNameExists(), ParameterCount - 2 ###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }
        }
        //Ref to Task#2595
        public DataSet GetSecurityQuestions(int StaffId)
        {
            try
            {
                return objUserPreferences.GetSecurityQuestions(StaffId);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetSecurityQuestions(), ParameterCount - 1 ###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }
        }

        //Added by chandan for task#2604
        public int ApprovePrescription(int PrescriberId, string LastPrescriptionReviewTime, string RDLDateTime)
        {
            try
            {
                return objUserPreferences.ApprovePrescription(PrescriberId, LastPrescriptionReviewTime, RDLDateTime);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - ApprovePrescription(), ParameterCount - 2, PrescriberId- " + PrescriberId + " LastPrescriptionReviewTime- " + LastPrescriptionReviewTime + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }
        }
        #region--Code Written By Pradeep on 27 Nov 2009 as per task#23(Venture 10.0)
        public DataSet GetUserPreferancesLocationList(int staffId)
        {
            try
            {
                return objUserPreferences.GetUserPreferancesLocationList(staffId);
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

        //Ref to Task#3155 2.1.1 Add/Update Prescriber Interface
        public DataSet GetSureScriptPrescriberId(Int32 StaffId)
        {
            return objUserPreferences.GetSureScriptPrescriberId(StaffId);
        }
        public DataSet MergePharmacies(int DetailsPharmacyId, int SearchPharmacyId)
        {

            try
            {
                return objUserPreferences.MergePharmacies(DetailsPharmacyId, SearchPharmacyId);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - MergePharmacies(), ParameterCount - 2, DetailsPharmacyId- " + DetailsPharmacyId + " SearchPharmacyId- " + SearchPharmacyId + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }
        }
        
        //Adedd by Loveena in ref to Task#3236
        public void UpdatePreferredPharmacy(int PharmacyId)
        {
            try
            {
                objUserPreferences.UpdatePreferredPharmacy(PharmacyId);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - UpdatePreferredPharmacy(), ParameterCount - 1, PharmacyId- " + PharmacyId + " ###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }
        }
   
    
    
     // To Check EPCS Permissions
        public DataSet CheckForEPCS(Int32 staffId, Int32 clientId)
        {
            try
            {

             return   objUserPreferences.CheckForEPCS(staffId, clientId);
            
            }
            
             catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - CheckForEPCS(Int32 staffId, Int32 clientId), ParameterCount - 2, First Parameter- " + staffId + " SearchPharmacyId- " + clientId +  "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }
            
            
            


        }

        public string UpdateStaff(string selectedstaff, int EPCSAssignorStaffId, string CreatedBy, string Enable, string strErrorMessage)
        {
            try
            {

                return objUserPreferences.UpdateStaff(selectedstaff,EPCSAssignorStaffId,CreatedBy, Enable, strErrorMessage);
            }

            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - UpdateStaff(string selectedstaff, int EPCSAssignorStaffId, string CreatedBy, string Enable, string strErrorMessage)";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw ex;
            }
        }
    }
}

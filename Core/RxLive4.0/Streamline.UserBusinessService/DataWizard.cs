using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Collections;

namespace Streamline.UserBusinessServices
{
    public class DataWizard
    {
        //Creation of module level object of class MyPreferences in DataServices and initializing its value to null
        Streamline.DataService.DataWizard DataWizardObj = null;

        /// <summary>
        /// Constructor of the Class used for initialising the object DataWizardObj
        /// <Author>Jatinder Singh</Author>
        /// <Date Created>30-May-2007</Date>
        /// </summary>
        public DataWizard()
        {
            //Allocating memory to object MyPreferencesObj 
            DataWizardObj = new Streamline.DataService.DataWizard();

        }


        public void WizardDropDownLogic(Hashtable HashtableObject)
        {
            try
            {
                //Return the dataset to calling function returned by procedure ReadMyPreferences in UBS
                DataWizardObj.WizardDropDownLogic(HashtableObject);

            }
            catch (Exception ex)
            {
                //throw exception (if any) to Presentation Layer
                // Added by Pratap In order to Implement Exception Management functionality on 27th June 2007
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - WizardDropDownLogic(), ParameterCount - 1," + HashtableObject + "###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
        }

        public DataSet ReadWizard(Hashtable HashtableObject)
        {
            try
            {

                //Returns the dataset to calling function returned by procedure ReadMyPreferences in UBS
                return DataWizardObj.ReadWizard(HashtableObject);

            }
            catch (Exception ex)
            {
                //throw exception (if any) to Presentation Layer
                // Added by Pratap In order to Implement Exception Management functionality on 27th June 2007
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - ReadWizard(), ParameterCount - 0 ###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);

            }
        }
        /// <summary>
        /// Created By Pramod Prakash on Feb 6 2008
        /// this will get then next step
        /// </summary>
        /// <param name="StaffId"></param>
        /// <param name="DataWizardInstanceId"></param>
        /// <param name="PreviousDataWizardInstanceId"></param>
        /// <param name="NextStepId"></param>
        /// <param name="NextWizardId"></param>
        /// <param name="DocumentId"></param>
        /// <param name="Version"></param>
        /// <param name="ClientID"></param>
        /// <param name="ClientSearchGUID"></param>
        /// <param name="Validate"></param>
        /// <returns></returns>
        public DataSet GetStep(int StaffId, int DataWizardInstanceId, int PreviousDataWizardInstanceId, int NextStepId, int NextWizardId, int DocumentId, int Version, int ClientID, string ClientSearchGUID, bool Validate)
        {
            try
            {
                //Return the dataset to calling function returned by procedure ReadMyPreferences in UBS
             return    DataWizardObj.GetStep(StaffId, DataWizardInstanceId, PreviousDataWizardInstanceId, NextStepId, NextWizardId, DocumentId, Version, ClientID, ClientSearchGUID, Validate);

            }
            catch (Exception ex)
            {
                
                throw (ex);
            }

        }

        ///// <summary>
        ///// This function returns the Dataset 
        ///// (It contains the values for filling dropdowns and other controls )
        ///// </summary>
        ///// <Author>Jatinder Singh</Author>
        ///// <Created>5th July 2007</Created>
        ///// <Param>SPName</Param>
        ///// <returns>DataSet</returns>
        //public DataSet ReadWizardValues(string SPName, int UserId, int DataWizardInstanceId, int PreviousDataWizardInstanceId, int NextStepId, int NextWizardId, int EventId, int ClientId, string ClientSearchGUID, int ProviderId)
        //{
        //    try
        //    {
        //        ////Allocating memory to object MyPreferencesObj 
        //        //DataWizardObj = new ProviderAccess.DataServices.DataWizard();

        //        //Return the dataset to calling function returned by procedure ReadMyPreferences in UBS
        //        return DataWizardObj.ReadWizardValues(SPName, UserId, DataWizardInstanceId, PreviousDataWizardInstanceId, NextStepId, NextWizardId, EventId, ClientId, ClientSearchGUID, ProviderId);

        //    }
        //    catch (Exception ex)
        //    {
        //        //throw exception (if any) to Presentation Layer
        //        // Added by Pratap In order to Implement Exception Management functionality on 27th June 2007
        //        if (ex.Data["CustomExceptionInformation"] == null)
        //            ex.Data["CustomExceptionInformation"] = "###Source Function Name - ReadWizardValues(), ParameterCount - 1,First Param" + SPName + " ###";
        //        if (ex.Data["DatasetInfo"] == null)
        //            ex.Data["DatasetInfo"] = null;
        //        throw (ex);

        //    }
        //    //finally
        //    //{
        //    //    //Assigning null to object DataWizardObj 
        //    //    DataWizardObj = null;
        //    //}
        //}


        ///// <summary>
        ///// This function returns the Dataset 
        ///// (It contains the values for filling dropdowns and other controls )
        ///// </summary>
        ///// <Author>Jatinder Singh</Author>
        ///// <Created>5th July 2007</Created>
        ///// <Param>SPName</Param>
        ///// <returns>DataSet</returns>
        //public DataSet ReadWizardDependentControls(string SPName, string ControlType, string SelectedValue)
        //{
        //    try
        //    {
        //        ////Allocating memory to object MyPreferencesObj 
        //        //DataWizardObj = new ProviderAccess.DataServices.DataWizard();

        //        //Return the dataset to calling function returned by procedure ReadMyPreferences in UBS
        //        return DataWizardObj.ReadWizardDependentControls(SPName, ControlType, SelectedValue);

        //    }
        //    catch (Exception ex)
        //    {
        //        //throw exception (if any) to UBS Layer
        //        // Added by Pratap In order to Implement Exception Management functionality on 27th June 2007
        //        if (ex.Data["CustomExceptionInformation"] == null)
        //            ex.Data["CustomExceptionInformation"] = "###Source Function Name - ReadWizardDependentControls(), ParameterCount - 3, FirstParam=" + SPName + ",SecondParam=" + ControlType + ",ThirdParam=" + SelectedValue + " ###";
        //        throw (ex);
        //    }
        //    //finally
        //    //{
        //    //    //Assigning null to object DataWizardObj 
        //    //    DataWizardObj = null;
        //    //}

        //}


        ///// <summary>
        ///// Accepts DataSet from the Presentation Layer and
        ///// Passes it to DataServices Layer and return boolean value if succeeded
        ///// </summary>
        ///// <Author>Jatinder S</Author>
        ///// <Date Created>1-June-2007</Date>
        ///// <param name="DataSetWizard">DataSet</param>
        ///// <returns>bool</returns>
        //public DataSet UpdateWizard(DataSet DataSetWizard, string SPName, int _TableCount, int _FieldCount, int UserId, int DataWizardInstanceId, int PreviousDataWizardInstanceId, int NextStepId, int NextWizardId, int EventId, int ClientId, string ClientSearchGUID, bool Validate, int ProviderId, bool Finish)
        //{
        //    try
        //    {
        //        ////Allocating memory to object WizardObj
        //        //DataWizardObj = new ProviderAccess.DataServices.DataWizard();

        //        //Returns true if data is updated in the database
        //        return DataWizardObj.UpdateWizard(DataSetWizard, SPName, _TableCount, _FieldCount, UserId, DataWizardInstanceId, PreviousDataWizardInstanceId, NextStepId, NextWizardId, EventId, ClientId, ClientSearchGUID, Validate, ProviderId, Finish);

        //    }
        //    catch (Exception ex)
        //    {
        //        //throw exception (if any) to Presentation Layer
        //        // Added by Pratap In order to Implement Exception Management functionality on 27th June 2007
        //        if (ex.Data["CustomExceptionInformation"] == null)
        //            ex.Data["CustomExceptionInformation"] = "###Source Function Name - UpdateWizard(), ParameterCount - 1, First Parameter- " + DataSetWizard + "###";
        //        if (ex.Data["DatasetInfo"] == null)
        //            ex.Data["DatasetInfo"] = null;
        //        throw (ex);
        //    }
        //    //finally
        //    //{
        //    //    //Assigning null to object MyPreferenceObj 
        //    //    DataWizardObj = null;
        //    //}
        //}
        //public DataSet InsertClientSearchData(string LastName, string FirstName, string SSN, String Phone, string DOB)
        //{
        //    try
        //    {

        //        ////Allocating memory to object WizardObj
        //        //DataWizardObj = new ProviderAccess.DataServices.DataWizard();

        //        //Returns true if data is updated in the database
        //        return DataWizardObj.InsertClientSearchData(LastName, FirstName, SSN, Phone, DOB);



        //    }


        //    catch (Exception ex)
        //    {
        //        if (ex.Data["CustomExceptionInformation"] == null)
        //            ex.Data["CustomExceptionInformation"] = "###Source Function Name - InsertClientSearchData(), ParameterCount - 1,FirstParam=" + LastName + "Second Param=" + FirstName + "TheardParam=" + SSN + "ForthParam=" + Phone + "FifthParam=" + DOB + " ###";
        //        if (ex.Data["DatasetInfo"] == null)
        //            ex.Data["DatasetInfo"] = null;
        //        throw (ex);

        //    }
        //    //finally
        //    //{
        //    //    //Assigning null to object DataWizardObj 
        //    //    DataWizardObj = null;
        //    //}

        //}
    }
}

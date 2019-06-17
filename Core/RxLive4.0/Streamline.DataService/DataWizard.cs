using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using System.Collections;

namespace Streamline.DataService
{

    public class DataWizard
    {
        //Connection String used for connecting the database
        string ConnectionString;

        /// <summary>
        /// Constructor of the Class used for initialising the value of ConnectionString
        /// <Author>Jatinder Singh</Author>
        /// <Date Created>30-May-2007</Date>
        /// </summary>
        public DataWizard()
        {
            ConnectionString = System.Configuration.ConfigurationSettings.AppSettings["SCConnectionString"];
        }

        /// <summary>
        /// This function returns the Dataset 
        /// (HTML and corresponding stored procedures to be used are column values in the DataSet)
        /// </summary>
        /// <Author>Jatinder Singh</Author>
        /// <Created>5th July 2007</Created>
        /// <returns></returns>
        public void WizardDropDownLogic(Hashtable HashtableObject)
        {
            //Creating an object of type Dataset
            DataSet DataSetWizard = null;

            //Creating array of type SqlParameter
            SqlParameter[] sSqlParameter;

            IDictionaryEnumerator EnumObject = HashtableObject.GetEnumerator();

            int i = 0;
            try
            {
                //Initialising the array object and setting its value to the parameter passed from UBS
                sSqlParameter = new SqlParameter[HashtableObject.Count];

                while (EnumObject.MoveNext())
                {
                    sSqlParameter[i] = new SqlParameter("@" + EnumObject.Key.ToString(), EnumObject.Value);
                    i++;
                }

                //Executing the stored procedure and getting the values in dataset with the help of Class SqlHelper
                SqlHelper.ExecuteNonQuery(ConnectionString, CommandType.StoredProcedure, "ssp_PAWizardDropDownLogic", sSqlParameter);


            }
            catch (Exception ex)
            {
                //throw exception (if any) to UBS Layer
               
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - WizardDropDownLogic(), ParameterCount -1,First Parameter" + HashtableObject + " ###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = DataSetWizard;
                throw (ex);
            }
            finally
            {
                sSqlParameter = null;
                HashtableObject = null;
            }
        }


        /// <summary>
        /// This function returns the Dataset 
        /// (HTML and corresponding stored procedures to be used are column values in the DataSet)
        /// </summary>
        /// <Author>Jatinder Singh</Author>
        /// <Created>5th July 2007</Created>
        /// <returns></returns>
        public DataSet ReadWizard(Hashtable HashtableObject)
        {
            //Creating an object of type Dataset
            DataSet DataSetWizard = null;

            //Creating array of type SqlParameter
            SqlParameter[] sSqlParameter;

            IDictionaryEnumerator EnumObject = HashtableObject.GetEnumerator();

            int i = 0;
            try
            {
                //Initialising the array object and setting its value to the parameter passed from UBS
                sSqlParameter = new SqlParameter[HashtableObject.Count + 1];

                while (EnumObject.MoveNext())
                {
                    sSqlParameter[i] = new SqlParameter("@" + EnumObject.Key.ToString(), EnumObject.Value);
                    i++;
                }
                sSqlParameter[i] = new SqlParameter("@Type", 2);
                //ssp_PAWizardDropDownLogic

                //Executing the stored procedure and getting the values in dataset with the help of Class SqlHelper
                DataSetWizard = SqlHelper.ExecuteDataset(ConnectionString, CommandType.StoredProcedure, "ssp_PAWizardFramework", sSqlParameter);

                //Setting the table name to the tables in the dataset
                #region "Setting Table Names in the Dataset"
                DataSetWizard.Tables[0].TableName = "Wizard";
                DataSetWizard.Tables[1].TableName = "NextStep";
                DataSetWizard.Tables[2].TableName = "DataWizardTitle";
                #endregion
            }
            catch (Exception ex)
            {
                //throw exception (if any) to UBS Layer
                // Added by Pratap In order to Implement Exception Management functionality on 27th June 2007
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - ReadWizard(), ParameterCount -1,First Parameter" + HashtableObject + " ###";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = DataSetWizard;
                throw (ex);
            }
            finally
            {
                sSqlParameter = null;
                HashtableObject = null;
            }
            return DataSetWizard;
        }
        /// <summary>
        /// Created By Pramod Prakash On 6 Feb 2008
        /// this function will get next step
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
            //Declaring SalParamentArray that will hold Parament that will be passed to the stored Procedure
            SqlParameter[] _ParameterObject = null;
            //Declaring a dataset
            DataSet DataSetAssement = null;
            try
            {
                //Initialization 
                DataSetAssement = new DataSet();
                _ParameterObject = new SqlParameter[10];
                _ParameterObject[0] = new SqlParameter("@StaffId", StaffId);
                _ParameterObject[1] = new SqlParameter("@DataWizardInstanceId", DataWizardInstanceId);
                _ParameterObject[2] = new SqlParameter("@PreviousDataWizardInstanceId", PreviousDataWizardInstanceId);
                _ParameterObject[3] = new SqlParameter("@NextStepId", NextStepId);
                _ParameterObject[4] = new SqlParameter("@NextWizardId", NextWizardId);
                _ParameterObject[5] = new SqlParameter("@DocumentId", DocumentId);

                _ParameterObject[6] = new SqlParameter("@Version", Version);
                _ParameterObject[7] = new SqlParameter("@ClientID", ClientID);
                if (ClientSearchGUID.Length > 1)
                {

                    _ParameterObject[8] = new SqlParameter("@ClientSearchGUID", ClientSearchGUID);
                }
                else
                {

                    _ParameterObject[8] = new SqlParameter("@ClientSearchGUID", System.DBNull.Value);
                }
                _ParameterObject[9] = new SqlParameter("@Validate", Validate);
                DataSetAssement = SqlHelper.ExecuteDataset(ConnectionString, System.Data.CommandType.StoredProcedure, "csp_DwPAAddUpdateSmartCare", _ParameterObject);
                
                DataSetAssement.Tables[0].TableName = "NextStep";
                DataSetAssement.Tables[1].TableName = "Steps";
                return DataSetAssement;

            }
            catch (Exception ex)
            {

                return DataSetAssement;
            }
            finally
            {

                _ParameterObject = null;

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
        //public DataSet ReadWizardValues(string SPName, int UserId, int DataWizardInstanceId, int PreviousDataWizardInstanceId, int NextStepId, int NextWizardId, int EventId, int ClientId, string _ClientSearchGUID, int ProviderId)
        //{
        //    //Creating an object of type Dataset
        //    DataSet DataSetWizard = null;

        //    DataSet DataSetSP = null;
        //    //Creating array of type SqlParameter
        //    SqlParameter[] sSqlParameter;
        //    Guid ClientSearchGUID = new Guid();

        //    bool _ParamFound = false;
        //    try
        //    {

        //        if (_ClientSearchGUID.Length > 1)
        //        {

        //            ClientSearchGUID = new Guid(_ClientSearchGUID);

        //        }
        //        //Initialising the array object and setting its value to the parameter passed from UBS
        //        sSqlParameter = new SqlParameter[1];
        //        sSqlParameter[0] = new SqlParameter("@objname", SPName);

        //        //Executing the stored procedure and getting the values in dataset with the help of Class SqlHelper
        //        DataSetSP = SqlHelper.ExecuteDataset(ConnectionString, CommandType.StoredProcedure, "sp_help", sSqlParameter);

        //        for (int i = 0; i < DataSetSP.Tables[1].Rows.Count; i++)
        //        {
        //            if (DataSetSP.Tables[1].Rows[i][0].ToString().ToUpper() == "@ProviderId".ToUpper())
        //            {
        //                _ParamFound = true;
        //                break;
        //            }
        //        }

        //        //Initialising the array object and setting its value to the parameter passed from UBS
        //        if (_ParamFound == true)
        //        {
        //            sSqlParameter = new SqlParameter[9];
        //        }
        //        else
        //        {
        //            sSqlParameter = new SqlParameter[8];
        //        }

        //        sSqlParameter[0] = new SqlParameter("@UserId", UserId);
        //        sSqlParameter[1] = new SqlParameter("@DataWizardInstanceId", DataWizardInstanceId);
        //        sSqlParameter[2] = new SqlParameter("@PreviousDataWizardInstanceId", PreviousDataWizardInstanceId);
        //        sSqlParameter[3] = new SqlParameter("@NextStepId", NextStepId);
        //        sSqlParameter[4] = new SqlParameter("@NextWizardId", NextWizardId);
        //        sSqlParameter[5] = new SqlParameter("@EventId", EventId);
        //        sSqlParameter[6] = new SqlParameter("@ClientId", ClientId);
        //        if (_ClientSearchGUID.Length > 1)
        //        {
        //            sSqlParameter[7] = new SqlParameter("@ClientSearchGUID", ClientSearchGUID);
        //        }
        //        else
        //        {

        //            sSqlParameter[7] = new SqlParameter("@ClientSearchGUID", System.DBNull.Value);
        //        }

        //        if (_ParamFound == true)
        //        {
        //            sSqlParameter[8] = new SqlParameter("@Providerid", ProviderId);
        //        }
        //        //Executing the stored procedure and getting the values in dataset with the help of Class SqlHelper
        //        DataSetWizard = SqlHelper.ExecuteDataset(ConnectionString, CommandType.StoredProcedure, SPName, sSqlParameter);

        //    }
        //    catch (Exception ex)
        //    {
        //        //throw exception (if any) to UBS Layer
        //        // Added by Pratap In order to Implement Exception Management functionality on 27th June 2007
        //        if (ex.Data["CustomExceptionInformation"] == null)
        //            ex.Data["CustomExceptionInformation"] = "###Source Function Name - ReadWizardValues(), ParameterCount - 1,FirstParam=" + SPName + "Second Parameter:" + UserId + "Theard Parameter:" + DataWizardInstanceId + "Forth Parameter:" + PreviousDataWizardInstanceId + ",Fifth Parameter:" + NextStepId + ",Sixth Parameter:" + NextWizardId + ",Seventh Parameter:" + EventId + "Eightth Prameter:" + _ClientSearchGUID + " ###";
        //        if (ex.Data["DatasetInfo"] == null)
        //            ex.Data["DatasetInfo"] = DataSetWizard;
        //        throw (ex);
        //    }
        //    finally
        //    {
        //        sSqlParameter = null;
        //        //HashtableObject = null;
        //    }
        //    return DataSetWizard;
        //}

        ///// <summary>
        ///// This function returns the Dataset 
        ///// (It contains the values for filling dropdowns and other controls )
        ///// </summary>
        ///// <Author>Jatinder Singh</Author>
        ///// <Created>6th Aug 2007</Created>
        ///// <Param>SPName</Param>
        ///// <Param>ControlType</Param>
        ///// <Param>SelectedValue</Param>
        ///// <returns>DataSet</returns>
        //public DataSet ReadWizardDependentControls(string SPName, string ControlType, string SelectedValue)
        //{
        //    //Creating an object of type Dataset
        //    DataSet DataSetWizard = null;

        //    //Creating array of type SqlParameter
        //    SqlParameter[] sSqlParameter;

        //    try
        //    {
        //        //Initialising the array object and setting its value to the parameter passed from UBS
        //        sSqlParameter = new SqlParameter[2];
        //        sSqlParameter[0] = new SqlParameter("@ControlType", ControlType);
        //        sSqlParameter[1] = new SqlParameter("@SelectedValue", SelectedValue);

        //        //Executing the stored procedure and getting the values in dataset with the help of Class SqlHelper
        //        DataSetWizard = SqlHelper.ExecuteDataset(ConnectionString, CommandType.StoredProcedure, SPName, sSqlParameter);

        //    }
        //    catch (Exception ex)
        //    {
        //        //throw exception (if any) to UBS Layer
        //        // Added by Pratap In order to Implement Exception Management functionality on 27th June 2007
        //        if (ex.Data["CustomExceptionInformation"] == null)
        //            ex.Data["CustomExceptionInformation"] = "###Source Function Name - ReadWizardDependentControls(), ParameterCount - 3, FirstParam=" + SPName + ",SecondParam=" + ControlType + ",ThirdParam=" + SelectedValue + " ###";
        //        if (ex.Data["DatasetInfo"] == null)
        //            ex.Data["DatasetInfo"] = DataSetWizard;
        //        throw (ex);
        //    }
        //    return DataSetWizard;
        //}

        ///// <summary>
        ///// Accepts DataSet from the UBS Layer and
        ///// Updates the values in the database by calling the Stored Procedure(passed in as 4th parameter),
        ///// _TableCount will be used to get the values from the particular table,
        ///// _FieldCount will be used for the loop and for the Parameter values
        ///// <Author>Jatinder Singh</Author>
        ///// <Date Created>1-June-2007</Date>
        ///// </summary>
        ///// <param name="DataSetWizard">DataSetWizard</param>
        ///// <param name="_TableCount">_TableCount</param>
        ///// <param name="_FieldCount">_FieldCount</param>
        ///// <param name="SPName">SPName</param>
        ///// <returns>bool</returns>
        //public DataSet UpdateWizard(DataSet DataSetWizard, string SPName, int _TableCount, int _FieldCount, int UserId, int DataWizardInstanceId, int PreviousDataWizardInstanceId, int NextStepId, int NextWizardId, int EventId, int ClientId, string _ClientSearchGUID, bool Validate, int ProviderId, bool Finish)
        //{
        //    ////Creating an object of type Dataset
        //    DataSet DataSetSP = null;

        //    //Creating array of type SqlParameter
        //    SqlParameter[] sSqlParameter;
        //    Guid ClientSearchGUID = new Guid();
        //    bool _ParamFound = false;


        //    try
        //    {
        //        if (_ClientSearchGUID.Length > 1)
        //        {
        //            ClientSearchGUID = new Guid(_ClientSearchGUID);

        //        }

        //        //Initialising the array object and setting its value to the parameter passed from UBS
        //        sSqlParameter = new SqlParameter[1];
        //        sSqlParameter[0] = new SqlParameter("@objname", SPName);

        //        //Executing the stored procedure and getting the values in dataset with the help of Class SqlHelper
        //        DataSetSP = SqlHelper.ExecuteDataset(ConnectionString, CommandType.StoredProcedure, "sp_help", sSqlParameter);

        //        for (int i = 0; i < DataSetSP.Tables[1].Rows.Count; i++)
        //        {
        //            if (DataSetSP.Tables[1].Rows[i][0].ToString().ToUpper() == "@ProviderId".ToUpper())
        //            {
        //                _ParamFound = true;
        //                break;
        //            }
        //        }

        //        //Initialising the array object and setting its value to the paramUserIdeter passed from UBS
        //        if (_ParamFound == true)
        //        {
        //            sSqlParameter = new SqlParameter[_FieldCount + 10];
        //        }
        //        else
        //        {
        //            sSqlParameter = new SqlParameter[_FieldCount + 9];
        //        }
        //        //For the fixed parameters

        //        for (int i = 1; i < _FieldCount; i++)
        //        {
        //            sSqlParameter[i - 1] = new SqlParameter("@val" + i, DataSetWizard.Tables[_TableCount].Rows[0][i].ToString() == "" ? DBNull.Value : DataSetWizard.Tables[_TableCount].Rows[0][i]);
        //        }

        //        sSqlParameter[_FieldCount - 1] = new SqlParameter("@UserId", UserId);
        //        sSqlParameter[_FieldCount] = new SqlParameter("@DataWizardInstanceId", DataWizardInstanceId);
        //        sSqlParameter[_FieldCount + 1] = new SqlParameter("@PreviousDataWizardInstanceId", PreviousDataWizardInstanceId);
        //        sSqlParameter[_FieldCount + 2] = new SqlParameter("@NextStepId", NextStepId);
        //        sSqlParameter[_FieldCount + 3] = new SqlParameter("@NextWizardId", NextWizardId);
        //        sSqlParameter[_FieldCount + 4] = new SqlParameter("@EventId", EventId);
        //        sSqlParameter[_FieldCount + 5] = new SqlParameter("@ClientId", ClientId);
        //        if (_ClientSearchGUID.Length > 1)
        //        {
        //            sSqlParameter[_FieldCount + 6] = new SqlParameter("@ClientSearchGUID", ClientSearchGUID);
        //        }
        //        else
        //        {
        //            sSqlParameter[_FieldCount + 6] = new SqlParameter("@ClientSearchGUID", DBNull.Value);

        //        }
        //        sSqlParameter[_FieldCount + 7] = new SqlParameter("@Validate", Validate == true ? 1 : 0);

        //        sSqlParameter[_FieldCount + 8] = new SqlParameter("@Finish", Finish == true ? 1 : 0);

        //        if (_ParamFound == true)
        //        {
        //            sSqlParameter[_FieldCount + 9] = new SqlParameter("@Providerid", ProviderId);
        //        }

        //        //Assigning null to DataSet
        //        DataSetWizard = null;

        //        //Executing the stored procedure and getting the values in dataset with the help of Class SqlHelper
        //        DataSetWizard = SqlHelper.ExecuteDataset(ConnectionString, CommandType.StoredProcedure, SPName, sSqlParameter);

        //        return DataSetWizard;
        //    }
        //    catch (Exception ex)
        //    {
        //        // Added by Pratap In order to Implement Exception Management functionality on 27th June 2007
        //        if (ex.Data["CustomExceptionInformation"] == null)
        //            ex.Data["CustomExceptionInformation"] = "###Source Function Name - UpdateWizard(), ParameterCount -13, First Parameter- " + DataSetWizard + ", Second Parameter :" + SPName + ",Theard Parameter:" + _TableCount + ",Forth Parameter:" + _FieldCount + ",Fifth Prameter:" + UserId + " Sixth Parameter:" + DataWizardInstanceId + ",Seventh Parameter:" + PreviousDataWizardInstanceId + ",Eightth Parameter:" + NextStepId + "Ninth Parameter:" + NextWizardId + "Tenth Parameter" + EventId + ",Eleventh Parameter:" + ClientId + ",Twowelth Parameter:" + _ClientSearchGUID + ",Therteenth Parameter:" + Validate + "###";
        //        if (ex.Data["DatasetInfo"] == null)
        //            ex.Data["DatasetInfo"] = DataSetWizard;
        //        throw (ex);
        //    }
        //    finally
        //    {
        //        //objSqlDataAdapter = null;
        //        //objSqlCommandBuilder = null;
        //        //SqlCon = null;
        //        //objSqlCommand = null;
        //        //objSqlTransaction = null;
        //    }
        //}



        ///// <summary>
        ///// This function will insert into ClientSearchData when user fill data into client search and there is no reocrd
        ///// </summary>
        ///// Created By Pramod Prakash Mishra
        ///// <param name="LastName"></param>
        ///// <param name="FirstName"></param>
        ///// <param name="SSN"></param>
        ///// <param name="Phone"></param>
        ///// <param name="DOB"></param>
        ///// <returns></returns>
        //public DataSet InsertClientSearchData(string LastName, string FirstName, string SSN, String Phone, string DOB)
        //{
        //    //Creating an object of type Dataset
        //    DataSet DataSetWizard = null;

        //    //Creating array of type SqlParameter
        //    SqlParameter[] sSqlParameter;
        //    try
        //    {
        //        //Initialising the array object and setting its value to the parameter passed from UBS
        //        sSqlParameter = new SqlParameter[5];
        //        sSqlParameter[0] = new SqlParameter("@LastName", LastName);
        //        sSqlParameter[1] = new SqlParameter("@FirstName", FirstName);
        //        sSqlParameter[2] = new SqlParameter("@SSN", SSN);
        //        sSqlParameter[3] = new SqlParameter("@Phone", Phone);
        //        if (DOB == "")
        //            sSqlParameter[4] = new SqlParameter("@DOB", DBNull.Value);
        //        else
        //            sSqlParameter[4] = new SqlParameter("@DOB", Convert.ToDateTime(DOB));


        //        //Executing the stored procedure and getting the values in dataset with the help of Class SqlHelper
        //        DataSetWizard = SqlHelper.ExecuteDataset(ConnectionString, CommandType.StoredProcedure, "ssp_PAInsertClientSearchData", sSqlParameter);

        //    }
        //    catch (Exception ex)
        //    {
        //        if (ex.Data["CustomExceptionInformation"] == null)
        //            ex.Data["CustomExceptionInformation"] = "###Source Function Name - InsertClientSearchData(), ParameterCount - 1,FirstParam=" + LastName + "Second Param=" + FirstName + "TheardParam=" + SSN + "ForthParam=" + Phone + "FifthParam=" + DOB + " ###";
        //        if (ex.Data["DatasetInfo"] == null)
        //            ex.Data["DatasetInfo"] = DataSetWizard;
        //        throw (ex);
        //    }
        //    return DataSetWizard;
        //}

    }

}

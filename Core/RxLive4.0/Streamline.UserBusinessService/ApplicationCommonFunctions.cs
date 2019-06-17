using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Security.Cryptography;
using System.Collections;
using System.IO;
using Streamline.DataService;
using System.Text.RegularExpressions;
using System.Drawing;

namespace Streamline.UserBusinessServices
{
    public class ApplicationCommonFunctions
    {
        Streamline.DataService.ApplicationCommonFunctions objApplicationCommonFunctions = null;
        //Added by Sonia 
        public static int _ClientId;
        public static int _StaffRowID;
        public static string _ClinicianRowIdentifier;
        public static string _ClientRowIdentifier;
        public static string _loggedUserName;
        private static byte[] KEY = new byte[] { 0x12, 0xe3, 0x4a, 0xa1, 0x45, 0xd2, 0x56, 0x7c, 0x54, 0xac, 0x67, 0x9f, 0x45, 0x6e, 0xaa, 0x56 };
        private static byte[] IV = new byte[] { 0x12, 0xe3, 0x4a, 0xa1, 0x45, 0xd2, 0x56, 0x7c };
        private DataSet _DataSetClientSummary;
        //Start Added by Pradeep as per task#2640
        public static string _defaultPrescribingQuantity;
        //End Added by Pradeep as per task#2640
        //Added by Loveena in ref to Task#2700
        public static string _QuestionsAnswered;
        public static string _allowRePrintFax;
        public ApplicationCommonFunctions()
        {
            objApplicationCommonFunctions = new Streamline.DataService.ApplicationCommonFunctions();
            //
            // TODO: Add constructor logic here
            //
            StaffRowID = 0;
            ClientId = 0;

        }
        ///// <summary>
        ///// Added by Sonia 
        ///// </summary>
        //public DataSet DataSetClientSummary
        //{
        //    get
        //    {
        //        return (DataSet)Session["DataSetClientSummary"];
        //    }
        //    set
        //    {
        //        _DataSetClientSummary = value;
        //    }
        //}


        /// <summary>
        /// Added by Sonia 
        /// </summary>
        public static int ClientId
        {
            get
            {
                return _ClientId;
            }
            set
            {
                _ClientId = value;
            }
        }

        ///// <summary>
        ///// Added by Loveena in ref to Task#2700
        ///// </summary>
        //public static string QuestionsAnswered
        //{
        //    get
        //    {
        //        return _QuestionsAnswered;
        //    }
        //    set
        //    {
        //        _QuestionsAnswered = value;
        //    }
        //}

        /// <summary>
        /// Added by Sonia 
        /// </summary>
        public static int StaffRowID
        {
            get
            {
                return _StaffRowID;
            }
            set
            {
                _StaffRowID = value;
            }
        }

        /// <summary>
        /// Added by Sonia 
        /// </summary>
        public static string ClinicianRowIdentifier
        {
            get
            {
                return _ClinicianRowIdentifier;
            }
            set
            {
                _ClinicianRowIdentifier = value;

            }
        }
        /// <summary>
        /// Added by Sonia 
        /// </summary>
        public static string ClientRowIdentifier
        {
            get
            {
                return _ClientRowIdentifier;
            }
            set
            {
                _ClientRowIdentifier = value;

            }
        }

        /// <summary>
        /// Added by Sonia 
        /// </summary>
        public static string loggedUserName
        {
            get
            {
                return _loggedUserName;
            }
            set
            {
                _loggedUserName = value;

            }
        }
        /// <summary>
        /// Added by Chandan with ref Task#2797
        /// </summary>
        public static string AllowRePrintFax
        {
            get
            {
                return _allowRePrintFax;
            }
            set
            {
                _allowRePrintFax = value;
            }
        }

        #region--Code Written By Pradeep as per task#2640
        /// <summary>
        ///<Description>Used to set and get defaultPrescribingQuantity as per task#2640</Description>
        /// <Author>Pradeep</Author>
        /// <CreatedOn>Nov 25,2009</CreatedOn>
        /// </summary>
        public static string defaultPrescribingQuantity
        {
            get
            {
                return _defaultPrescribingQuantity;
            }
            set
            {
                _defaultPrescribingQuantity = value;

            }
        }
        #endregion--Code Written By Pradeep as per task#2640


        /// <summary>
        /// it is used to give the text upto the given length
        /// </summary>
        /// <param name="strValue"></param>
        /// <param name="strLength"></param>
        /// <returns></returns>
        public static string cutText(string strValue, int strLength)
        {
            if (strValue.Length > strLength)
            {
                return strValue.Substring(0, strLength) + "..";
            }
            else
            {
                return strValue;
            }

        }


        public static string GetEncryptedData(string input, string strEncryption)
        {
            try
            {
                if (strEncryption == "N") return input;
                //				byte[] encdata = ASCIIEncoding.ASCII.GetBytes(input);
                //				string strenc = Convert.ToBase64String(encdata );
                //				return strenc;
                return EncryptBase64(input, KEY, IV);
            }
            catch (Exception ex)
            {
                return input;
            }
        }


        public static string EncryptBase64(string StringToEncrypt, byte[] Key, byte[] IV)
        {
            TripleDESCryptoServiceProvider tripledes = new TripleDESCryptoServiceProvider();

            byte[] inputByteArray = Encoding.UTF8.GetBytes(StringToEncrypt);

            MemoryStream ms = new MemoryStream();

            CryptoStream cs = new CryptoStream(ms, tripledes.CreateEncryptor(Key, IV), CryptoStreamMode.Write);

            cs.Write(inputByteArray, 0, inputByteArray.Length);
            cs.FlushFinalBlock();

            String str = Convert.ToBase64String(ms.ToArray());
            cs.Clear();
            return str;
        }

        public static string GetDecryptedData(string input, string strEncryption)
        {
            try
            {
                if (strEncryption == "N") return input;
                //				byte[] decdata = Convert.FromBase64String(input);
                //				string strdec = ASCIIEncoding.ASCII.GetString(decdata);
                //				return strdec;
                return DecryptBase64(input, KEY, IV);
            }

            catch
            {
                return input;
            }
        }

        public static string DecryptBase64(string ciphertext, byte[] Key, byte[] IV)
        {
            TripleDESCryptoServiceProvider tripledes = new TripleDESCryptoServiceProvider();

            MemoryStream ms = new MemoryStream();

            CryptoStream cs = new CryptoStream(ms, tripledes.CreateDecryptor(Key, IV), CryptoStreamMode.Write);

            byte[] cipherbytes = Convert.FromBase64String(ciphertext);

            cs.Write(cipherbytes, 0, cipherbytes.Length);
            cs.FlushFinalBlock();

            //construct the string
            byte[] DecryptedArray = ms.ToArray();
            Char[] characters = new Char[43693];
            Decoder dec = Encoding.UTF8.GetDecoder();

            int charlen = dec.GetChars(DecryptedArray, 0, DecryptedArray.Length, characters, 0);

            string DecrpytedString = new string(characters, 0, charlen);

            return DecrpytedString;
        }

        public static bool IsValidDateValue(string DateValue)
        {
            Regex RegexDateObject = new Regex(@"(^(([1-9]|0[1-9]|1[0-2]))/((0[1-9]|[1-9])|([12][0-9])|(3[0-1]))/(([0-9][0-9][0-9][0-9]))$)");
            if (!(RegexDateObject.IsMatch(DateValue)))
            {
                return false;
            }
            else
            {
                return true;
            }
        }

        /// <summary>
        /// Function added by Sonia to Wrap the Multiline text in Control
        /// </summary>
        /// <param name="source"></param>
        /// <returns>string</returns>
        public static string WrappableText(string source)
        {
            string nwln = Environment.NewLine;
            return "<p>" +
            source.Replace(nwln + nwln, "</p><p>")
            .Replace(nwln, "<br />") + "</p>";
        }
        /// <summary>
        /// Function added by Sonia to calculate Age From DOB
        /// </summary>
        /// <param name="DOB"></param>
        /// <returns>string</returns>
        public static string GetAge(string DOB)
        {
            DateTime dateOfBirth = DateTime.Parse(DOB);
            DateTime currentDate = DateTime.Now;
            System.TimeSpan TS = new System.TimeSpan(currentDate.Ticks - dateOfBirth.Ticks);
            long ageInYears = (long)TS.Days / 365;
            return ageInYears.ToString();
        }

        public DataSet GetClientSearchInfo(int UserId, string SearchType, string param1, string param2, string CreatedBy, int ProviderId)
        {
            DataSet DataSetMember = null;
            try
            {
                DataSetMember = objApplicationCommonFunctions.GetClientSearchInfo(UserId, SearchType, param1, param2, CreatedBy, ProviderId);
                return DataSetMember;
            }
            catch (Exception ex)
            {
                // Added by Pratap In order to Implement Exception Management functionality on 28th June 2007
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetClientSearchInfo(), ParameterCount - 5, First Parameter- " + UserId + ", Second Parameter- " + SearchType + ", Third Parameter- " + param1 + ", Fourth Parameter- " + param2 + ", Fifth Parameter- " + CreatedBy + "##";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = DataSetMember;
                throw (ex);
            }
            finally
            {
                DataSetMember = null;

            }

        }


        public static byte[] ConvertImageToByteArray(System.Drawing.Image imageToConvert, System.Drawing.Imaging.ImageFormat formatOfImage)
        {

            byte[] Ret;

            try
            {

                using (System.IO.MemoryStream ms = new System.IO.MemoryStream())
                {

                    imageToConvert.Save(ms, formatOfImage);

                    Ret = ms.ToArray();

                }

            }

            catch (Exception ex)
            {

                throw ex;

            }
            finally
            {
                //  imageToConvert.Dispose(); 
            }


            return Ret;

        }

        public static System.Drawing.Image ConvertByteArrayToImage(byte[] myByteArray)
        {

            try
            {

                System.Drawing.Image newImage;

                using (System.IO.MemoryStream ms = new System.IO.MemoryStream(myByteArray, 0, myByteArray.Length))
                {

                    ms.Write(myByteArray, 0, myByteArray.Length);

                    newImage = Image.FromStream(ms, true);

                    return (System.Drawing.Image)newImage.Clone();

                }

            }

            catch (Exception ex)
            {

                throw (ex);

            }

        }

        public static System.Drawing.Image ConvertByteArrayToImage(byte[] myByteArray, bool CloseStream)
        {
            try
            {
                System.Drawing.Image newImage;
                System.IO.MemoryStream ms = new System.IO.MemoryStream(myByteArray, 0, myByteArray.Length);
                ms.Write(myByteArray, 0, myByteArray.Length);
                newImage = Image.FromStream(ms, true);
                return (System.Drawing.Image)newImage.Clone();
            }
            catch (Exception ex)
            {
                throw (ex);
            }

        }

        public DataSet GetFaxRequestsStatus()
        {

            try
            {
                return objApplicationCommonFunctions.GetFaxRequestsStatus();
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

        public static ArrayList StringSplit(string StringValue, string SplitString)
        {
            try
            {
                ArrayList items = new ArrayList();
                //string[] strTemp;
                Int16 i = 0;
                Int16 startString = 0;
                string tmp = null;
                Int16 SplitStringLength = (Int16)SplitString.Length;
                while (true)
                {
                    Int16 pos = (Int16)StringValue.IndexOf(SplitString, startString);
                    if (pos > -1)
                    {

                        tmp = StringValue.Substring(startString, pos - startString);
                        items.Add(Convert.ToString(tmp));
                        startString = (Int16)(Convert.ToInt16(pos) + Convert.ToInt16(SplitStringLength));
                        i++;
                    }
                    else
                    {

                        if (StringValue.Length > startString)
                        {
                            tmp = StringValue.Substring(startString, StringValue.Length - startString);
                            items.Add(Convert.ToString(tmp));

                        } break;
                    }
                }
                return items;
            }

            catch (Exception ex)
            {
                throw (ex);
            }
        }


        public void WriteToDatabase(string entry, string type)
        {

            try
            {
                objApplicationCommonFunctions.WriteToDatabase(entry, type);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// Created by Chandan for task #2416 Harbor use External web service for client Informations 
        /// </summary>
        /// <param name="UserId"></param>
        /// <param name="SearchType"></param>
        /// <param name="param1"></param>
        /// <param name="param2"></param>
        /// <param name="CreatedBy"></param>
        /// <param name="ProviderId"></param>
        /// <returns></returns>
        public DataSet GetExternalClientSearchInfo(int UserId, string SearchType, string param1, string param2, string CreatedBy, int ProviderId)
        {
            DataSet DataSetMember = null;
            ExternalWebService.ExternalWebService objExternalWebService = null;
            try
            {
                objExternalWebService = new ExternalWebService.ExternalWebService();
                DataSetMember = objExternalWebService.GetClientSearchInfo(UserId, SearchType, param1, param2, CreatedBy, ProviderId);
                return DataSetMember;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetClientSearchInfo(), ParameterCount - 5, First Parameter- " + UserId + ", Second Parameter- " + SearchType + ", Third Parameter- " + param1 + ", Fourth Parameter- " + param2 + ", Fifth Parameter- " + CreatedBy + "##";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = DataSetMember;
                throw (ex);
            }
            finally
            {
                DataSetMember = null;
            }
        }


        /// <summary>
        /// Created by Chandan for task #2432 - 1.9 Patient selection to call External Web Service 
        /// This method is use for getting ClientInformation according to External Client Information</summary>
        /// <param name="ExternalClientId"></param>      
        /// <returns></returns>
        public DataSet GetExternalClientInfo(string ExternalClientId)
        {
            DataSet DataSetMember = null;
            ExternalWebService.ExternalWebService objExternalWebService = null;
            try
            {
                objExternalWebService = new ExternalWebService.ExternalWebService();
                DataSetMember = objExternalWebService.GetExternalClientInfo(ExternalClientId);
                //DataSetMember = objExternalWebService.GetExternalClientInfo(ClientId);
                return DataSetMember;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetClientSearchInfo(), ParameterCount - 1, First Parameter- " + ClientId + "##";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = DataSetMember;
                throw (ex);
            }
            finally
            {
                DataSetMember = null;
            }
        }

        /// <summary>
        /// Created by Mohit Madaan for task #2448 - 1.9 Patient Search - Update ClientViewAudit after patient select
        /// This Method is used to update the External client information</summary>
        /// <param name="searchID"></param>      
        /// <param name="ExternalClientID"></param>      
        /// <param name="ModifiedBy"></param>
        /// <param name="ModifiedDate"></param>
        /// <returns></returns>
        /// 
        public void UpdateClientExternalViewAudit(int SearchId, string ExternalClientId, string ModifiedBy, DateTime ModifiedDate)
        {
            ExternalWebService.ExternalWebService objExternalWebService = null;
            try
            {
                objExternalWebService = new ExternalWebService.ExternalWebService();
                objExternalWebService.UpdateClientExternalViewAudit(SearchId, ExternalClientId, ModifiedBy, ModifiedDate);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - UpdateClientExternalViewAudit(), ParameterCount - 4, First Parameter- " + SearchId + "##";
                throw (ex);
            }
            finally
            {

            }
        }
        /// <summary>
        /// Created by Mohit Madaan for task #2448 - 1.9 Patient Search - Update ClientViewAudit after patient select
        /// This Method is used to update the Internal client information</summary>
        /// <param name="searchID"></param>      
        /// <param name="ExternalClientID"></param>      
        /// <param name="ModifiedBy"></param>
        /// <param name="ModifiedDate"></param>
        /// <returns></returns>
        /// 
        public void UpdateInternalClientViewAudit(Int32 SearchId, Int32 ClientId, string ModifiedBy, DateTime ModifiedDate)
        {
            try
            {
                objApplicationCommonFunctions.UpdateInternalClientViewAudit(SearchId, ClientId, ModifiedBy, ModifiedDate);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - UpdateInternalClientViewAudit(), ParameterCount - 4, First Parameter- " + SearchId + "##";
                throw (ex);
            }
            finally
            {

            }
        }

        /// <summary>
        /// Created by Chandan for task #2432 - 1.9 Patient selection to call External Web Service 
        /// This method is use for Update ClientInformation in Streamline Database</summary>
        /// <param name="dsExternalClientInfo"></param>      
        /// <returns></returns>
        public DataSet UpdateExternalInformation(DataSet dsExternalClientInfo, string UserCode)
        {
            int ClientId = 0;
            DataSet DataSetClient = null;
            string ExternalClientId = "";
            string LastName = "";
            string FirstName = "";
            string MiddleName = "";
            string Prefix = "";
            string Suffix = "";
            string SSN = "";
            string DOB = "";
            int PhoneType = 0;
            string PhoneNumber = "";
            string PhoneNumberText = "";
            string IsPrimary = "N";
            string DoNotContact = "N";
            int AddressType = 0;
            string Address = "";
            string City = "";
            string State = "";
            string Zip = "";
            string Display = "";
            string Active = "";
            string DoesNotSpeakEnglish = "";
            string FinanciallyResponsible = "";
            //Added by Loveena in ref to Task#3265-2.5.1 Client at Top-Left of Page Does Not Match Selected Client
            string Sex = null;
            string ClientRace = "";
            try
            {
                if (dsExternalClientInfo != null)
                {
                    if (dsExternalClientInfo.Tables["ClientInfo"].Rows.Count > 0)
                    {
                        //if (dsExternalClientInfo.Tables["ClientInfo"].Rows[0]["ClientId"].ToString() != "")
                        //    ClientId = Convert.ToInt32(dsExternalClientInfo.Tables["ClientInfo"].Rows[0]["ClientId"]);
                        if (dsExternalClientInfo.Tables["ClientInfo"].Rows[0]["ExternalClientId"].ToString() != "")
                            ExternalClientId = Convert.ToString(dsExternalClientInfo.Tables["ClientInfo"].Rows[0]["ExternalClientId"]);
                        //ExternalClientId = Convert.ToString(dsExternalClientInfo.Tables["ClientInfo"].Rows[0]["ExternalClientId"]);
                        if (dsExternalClientInfo.Tables["ClientInfo"].Rows[0]["LastName"].ToString() != "")
                            LastName = Convert.ToString(dsExternalClientInfo.Tables["ClientInfo"].Rows[0]["LastName"]);
                        if (dsExternalClientInfo.Tables["ClientInfo"].Rows[0]["FirstName"].ToString() != "")
                            FirstName = Convert.ToString(dsExternalClientInfo.Tables["ClientInfo"].Rows[0]["FirstName"]);
                        if (dsExternalClientInfo.Tables["ClientInfo"].Rows[0]["MiddleName"].ToString() != "")
                            MiddleName = Convert.ToString(dsExternalClientInfo.Tables["ClientInfo"].Rows[0]["MiddleName"]);
                        //Code Commented by Loveena in ref to Task#2431 to Change the Stored Procedure.
                        if (dsExternalClientInfo.Tables["ClientInfo"].Rows[0]["Prefix"].ToString() != "")
                            Prefix = Convert.ToString(dsExternalClientInfo.Tables["ClientInfo"].Rows[0]["Prefix"]);
                        if (dsExternalClientInfo.Tables["ClientInfo"].Rows[0]["Suffix"].ToString() != "")
                            Suffix = Convert.ToString(dsExternalClientInfo.Tables["ClientInfo"].Rows[0]["Suffix"]);
                        if (dsExternalClientInfo.Tables["ClientInfo"].Rows[0]["SSN"].ToString() != "")
                            SSN = Convert.ToString(dsExternalClientInfo.Tables["ClientInfo"].Rows[0]["SSN"]);
                        if (dsExternalClientInfo.Tables["ClientInfo"].Rows[0]["Sex"].ToString() != "")
                            Sex = Convert.ToString(dsExternalClientInfo.Tables["ClientInfo"].Rows[0]["Sex"]);

                        if (dsExternalClientInfo.Tables["ClientInfo"].Rows[0]["DOB"].ToString() != "")
                            DOB = Convert.ToDateTime(dsExternalClientInfo.Tables["ClientInfo"].Rows[0]["DOB"]).ToString("MM/dd/yyyy");

                        if (dsExternalClientInfo.Tables["ClientInfo"].Rows[0]["Active"].ToString() != "")
                            Active = Convert.ToString(dsExternalClientInfo.Tables["ClientInfo"].Rows[0]["Active"]);
                        if (dsExternalClientInfo.Tables["ClientInfo"].Rows[0]["DoesNotSpeakEnglish"].ToString() != "")
                            DoesNotSpeakEnglish = Convert.ToString(dsExternalClientInfo.Tables["ClientInfo"].Rows[0]["DoesNotSpeakEnglish"]);
                        if (dsExternalClientInfo.Tables["ClientInfo"].Rows[0]["FinanciallyResponsible"].ToString() != "")
                            FinanciallyResponsible = Convert.ToString(dsExternalClientInfo.Tables["ClientInfo"].Rows[0]["FinanciallyResponsible"]);



                    }
                    if (dsExternalClientInfo.Tables["ClientGeneralInfo"].Rows.Count > 0)
                    {
                        ClientRace = dsExternalClientInfo.Tables["ClientGeneralInfo"].Rows[0]["ClientRace"].ToString();
                    }
                    if (dsExternalClientInfo.Tables["ClientPhones"].Rows.Count > 0)
                    {
                        DataRow[] dr = dsExternalClientInfo.Tables["ClientPhones"].Select("PhoneType=30");
                        if (dr.Length > 0)
                        {
                            if (dr[0].Table.Rows[0]["PhoneType"].ToString() != "")
                                PhoneType = Convert.ToInt32(dr[0].Table.Rows[0]["PhoneType"]);
                            if (dr[0].Table.Rows[0]["PhoneNumber"].ToString() != "")
                                PhoneNumber = Convert.ToString(dr[0].Table.Rows[0]["PhoneNumber"]);
                            if (dr[0].Table.Rows[0]["PhoneNumberText"].ToString() != "")
                                PhoneNumberText = Convert.ToString(dr[0].Table.Rows[0]["PhoneNumberText"]);
                            if (dr[0].Table.Rows[0]["IsPrimary"].ToString() != "")
                                IsPrimary = Convert.ToString(dr[0].Table.Rows[0]["IsPrimary"]);
                            if (dr[0].Table.Rows[0]["DoNotContact"].ToString() != "")
                                DoNotContact = Convert.ToString(dr[0].Table.Rows[0]["DoNotContact"]);
                        }
                    }
                    if (dsExternalClientInfo.Tables["ClientAddress"].Rows.Count > 0)
                    {
                        DataRow[] drAddresses = dsExternalClientInfo.Tables["ClientAddress"].Select("AddressType=90");
                        if (drAddresses.Length > 0)
                        {
                            if (drAddresses[0].Table.Rows[0]["AddressType"].ToString() != "")
                                AddressType = Convert.ToInt32(drAddresses[0].Table.Rows[0]["AddressType"]);
                            if (drAddresses[0].Table.Rows[0]["Address"].ToString() != "")
                                Address = Convert.ToString(drAddresses[0].Table.Rows[0]["Address"]);
                            if (drAddresses[0].Table.Rows[0]["City"].ToString() != "")
                                City = Convert.ToString(drAddresses[0].Table.Rows[0]["City"]);
                            if (drAddresses[0].Table.Rows[0]["State"].ToString() != "")
                                State = Convert.ToString(drAddresses[0].Table.Rows[0]["State"]);
                            if (drAddresses[0].Table.Rows[0]["Zip"].ToString() != "")
                                Zip = Convert.ToString(drAddresses[0].Table.Rows[0]["Zip"]);
                            if (drAddresses[0].Table.Rows[0]["Display"].ToString() != "")
                                Display = Convert.ToString(drAddresses[0].Table.Rows[0]["Display"]);
                        }
                    }
                    //if (ClientId != 0)
                    //DataSetClient = objApplicationCommonFunctions.UpdateClientInformations(ClientId, ExternalClientId, LastName, FirstName, MiddleName, Prefix, Suffix, SSN, DOB, PhoneType, PhoneNumber, PhoneNumberText, IsPrimary, DoNotContact, AddressType, Address, City, State, Zip, Display, UserCode, DoesNotSpeakEnglish, Active, FinanciallyResponsible);
                    //Comented Code ends over here.
                    if (ExternalClientId != "")
                        //Modified by Loveena in ref to Task#2432 0n 09-May-2009
                        //DataSetClient = objApplicationCommonFunctions.UpdateClientInformations(ExternalClientId, LastName, FirstName, MiddleName);
                        DataSetClient = objApplicationCommonFunctions.UpdateClientInformations(ExternalClientId, LastName, FirstName, MiddleName, Prefix, Suffix, SSN, DOB, PhoneType, PhoneNumber, PhoneNumberText, IsPrimary, DoNotContact, AddressType, Address, City, State, Zip, Display, UserCode, DoesNotSpeakEnglish, Active, FinanciallyResponsible, Sex, ClientRace);

                }
                return DataSetClient;
            }
            catch (Exception ex)
            {
                throw ex;

            }
        }

        /// <summary>
        /// <Descripttion> To get Graph data as per task#34</Descripttion>
        /// </summary>
        /// <param name="HealthDataCategory"></param>
        /// <param name="ItemName"></param>
        /// <returns></returns>
        public DataSet GetGraphData(int HealthDataCategoryId, string ItemName, double MinValue, double MaxValue)
        {
            try
            {
                return objApplicationCommonFunctions.GetGraphData(HealthDataCategoryId, ItemName, MinValue, MaxValue);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetGraphData(), ParameterCount - 2##";
                throw (ex);
            }
        }

        /// <summary>
        /// <Descripttion> To get Graph data as per task#34</Descripttion>
        /// </summary>
        /// <param name="HealthDataCategory"></param>
        /// <param name="ItemName"></param>
        /// <returns></returns>
        public DataSet GetGraphValue(int ClientId, int HealthDataCategory, string ItemName, DateTime StartDate, DateTime EndDate)
        {
            try
            {
                return objApplicationCommonFunctions.GetGraphValue(ClientId, HealthDataCategory, ItemName, StartDate, EndDate);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetGraphValue(), ParameterCount - 2##";
                throw (ex);
            }
        }
        public static string GetFileName(string filename, int seq)
        {
            try
            {
                string result = "";
                if (filename.Substring(filename.IndexOf(".") + 1) == "jpeg")
                {
                    filename = filename.Substring(0, filename.IndexOf("."));
                    result = String.Format("{0}.{1}.jpeg", filename, seq);
                }
                else
                    result = filename.Replace(filename.Substring(filename.IndexOf(".") + 1).Substring(0, filename.Substring(filename.IndexOf(".") + 1).IndexOf(".")), seq.ToString());
                return result;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetFileName(), ParameterCount - 1##";
                throw (ex);
            }
        }
        /// <summary>
        /// <Descripttion>Gather System Configuration information : Thresholds task#2158</Descripttion>
        /// </summary>
        /// <returns>Dataset</returns>
        public DataSet GetSystemConfigurations()
        {
            try
            {
                return objApplicationCommonFunctions.GetSystemConfigurations();
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "###Source Function Name - GetSystemConfigurations(), ParameterCount - 0##";
                throw (ex);
            }
        }
    }
}

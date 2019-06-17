using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Text;
using System.Security.Cryptography;
using System.IO;

// #KA 08232011 Kneale Alpers code was added to set flag for refill start date. Harbor Customizations Task 2

/// <summary>
/// Summary description for StreamlineIdentity
/// </summary>
/// 
namespace Streamline.BaseLayer
{
    public class StreamlineIdentity : System.Security.Principal.IIdentity
    {

        /**********Interface Elements*****************/

        // Summary:
        //     Gets the type of authentication used.
        //
        // Returns:
        //     The type of authentication used to identify the user.
        private static byte[] KEY = new byte[] { 0x12, 0xe3, 0x4a, 0xa1, 0x45, 0xd2, 0x56, 0x7c, 0x54, 0xac, 0x67, 0x9f, 0x45, 0x6e, 0xaa, 0x56 };
        private static byte[] IV = new byte[] { 0x12, 0xe3, 0x4a, 0xa1, 0x45, 0xd2, 0x56, 0x7c };

        public string AuthenticationType
        {
            /// Assuming that all the instance of CbizIdentity are authenticated
            get { return "Custom Authentication"; }
            set { }
        }
        //
        // Summary:
        //     Gets a value that indicates whether the user has been authenticated.
        //
        // Returns:
        //     true if the user was authenticated; otherwise, false.
        public bool IsAuthenticated
        {
            get { return true; }
        }
        //
        // Summary:
        //     Gets the name of the current user.
        //
        // Returns:
        //     The name of the user on whose behalf the code is running.
        public string Name
        {
            get { return _firstName + " " + _lastName; }
        }

        /*********************************************/
        private int _userId;
        private string _password;
        private string _userCode;
        private string _ClinicianRowIdentifier;
        private int _medicationDaysDefault;
        private int _staffPrescribingLocationId;//added by Loveena ref ticket #78
        private string _copyrightInfo; //Added by Chandan for task 2378 1.7.1 - Copyright info
        private string _administrator; //Added by Chandan for task #2416 Harbor
        private string _firstName;
        private string _prescriber; // Added by Loveena in ref to Task#2595.
        private string _EnablePrecriberSecurityQuestion; //Added by Loveena in ref to Task#2595
        private string _SecurityQuestion1; //Added by Loveena in ref to Task#2595
        private string _SecurityQuestion2; //Added by Loveena in ref to Task#2595
        private string _SecurityQuestion3; //Added by Loveena in ref to Task#2595
        private string _SecurityAnswer1; //Added by Loveena in ref to Task#2595
        private string _SecurityAnswer2; //Added by Loveena in ref to Task#2595
        private string _SecurityAnswer3; //Added by Loveena in ref to Task#2595
        private int _PharmacyCoverLetter; //Added by Loveena in ref to Task#2597
        private int _NumberOfPrescriberSecurityQuestions; // Added by Loveena in ref to Task#2595.
        private string _EnablePrescriptionReview; // Added by chandan in ref to Task#2604.
        private string _LastPrescriptionReviewTime; // Added by chandan in ref to Task#2604.
        private string _VerbalOrdersRequireApproval;//Added in ref to Task#34
        private string _StaffDegree;
        private string _releaseNumber;//Added in ref to Task#2895
        private string _AllowAllergyMedications;//Added by Loveena in ref to Task#2983
        private string _EnableOtherPrescriberSelection;//Added in ref to Task#3040
        private int _QuestionsAnswered;//Added in ref to Task#2700
        private string _ChangeOrderStartDateUseToday;//Added in ref to Task#3145
        private string _RefillStartUseEndPlusOne; // #ka 08232011
        private string _CanSignUsingSignaturePad; // Added by Malathi Shiva WRT Engineering Improvement Initiatives- NBL(I): Task# 291 
        private string _IsEPCSEnabled; // Added by Anto WRT EPCS: Task# 3 
        private string _DeviceEmail;// Added by Anto WRT EPCS: Task# 3 
        private string _DevicePassword;// Added byAnto WRT EPCS:Task# 3 
        private int _DEANumber;
        private int _PrescribingLocation;
        private int _PrescriberId;
        public string FirstName
        {
            get { return _firstName; }
            set { _firstName = value; }
        }
        private string _lastName;
        public string LastName
        {
            get { return _lastName; }
            set { _lastName = value; }
        }

        public int UserId
        {
            get { return _userId; }
        }

        public int StaffPrescribingLocationId //added by Loveena ref ticket #78
        {
            get { return _staffPrescribingLocationId; }
            set { _staffPrescribingLocationId = value; }
        }

        public string UserCode
        {
            get { return _userCode; }
            set { _userCode = value; }
        }

        public string ClinicianRowIdentifier
        {
            get { return _ClinicianRowIdentifier; }
            set { _ClinicianRowIdentifier = value; }
        }



        public int MedicationDaysDefault
        {
            get { return _medicationDaysDefault; }
            set { _medicationDaysDefault = value; }
        }
        //Added by Chandan for task 2378 1.7.1 - Copyright info
        public string CopyrightInfo
        {
            get { return _copyrightInfo; }
            set { _copyrightInfo = value; }
        }
        //Modified by Chandan  for task 2378 1.7.1 - Copyright info --Add new parameter DataRow SystemConfig


        public string Administrator
        {
            get { return _administrator; }
            set { _administrator = value; }
        }


        public string Password
        {
            get { return _password; }
            set { _password = value; }
        }
        //Ref to Task#2595
        public string Prescriber
        {
            get { return _prescriber; }
            set { _prescriber = value; }
        }
        public string EnablePrecriberSecurityQuestion
        {
            get { return _EnablePrecriberSecurityQuestion; }
            set { _EnablePrecriberSecurityQuestion = value; }
        }
        public string SecurityQuestion1
        {
            get { return _SecurityQuestion1; }
            set { _SecurityQuestion1 = value; }
        }
        public string SecurityQuestion2
        {
            get { return _SecurityQuestion2; }
            set { _SecurityQuestion2 = value; }
        }
        public string SecurityQuestion3
        {
            get { return _SecurityQuestion3; }
            set { _SecurityQuestion3 = value; }
        }
        public string SecurityAnswer1
        {
            get { return _SecurityAnswer1; }
            set { _SecurityAnswer1 = value; }
        }
        public string SecurityAnswer2
        {
            get { return _SecurityAnswer2; }
            set { _SecurityAnswer2 = value; }
        }
        public string SecurityAnswer3
        {
            get { return _SecurityAnswer3; }
            set { _SecurityAnswer3 = value; }
        }
        //Ref to Task#2595
        public int PharmacyCoverLetters
        {
            get { return _PharmacyCoverLetter; }
            set { _PharmacyCoverLetter = value; }
        }
        //Ref to Task#2595
        public Int32 NumberOfPrescriberSecurityQuestions
        {
            get { return _NumberOfPrescriberSecurityQuestions; }
            set { _NumberOfPrescriberSecurityQuestions = value; }
        }

        //Ref to Task#2604
        public string EnablePrescriptionReview
        {
            get { return _EnablePrescriptionReview; }
            set { _EnablePrescriptionReview = value; }
        }
        public string LastPrescriptionReviewTime
        {
            get { return _LastPrescriptionReviewTime; }
            set { _LastPrescriptionReviewTime = value; }
        }
        //End by chadan ref Task#2604

        //Added in ref to Task#34
        public string VerbalOrdersRequireApproval
        {
            get { return _VerbalOrdersRequireApproval; }
            set { _VerbalOrdersRequireApproval = value; }
        }
        //Added in ref to Task#34
        public string StaffDegree
        {
            get { return _StaffDegree; }
            set { _StaffDegree = value; }
        }

        //Added in ref to Task#2895
        public string ReleaseNumber
        {
            get { return _releaseNumber; }
            set { _releaseNumber = value; }
        }
        //Added in ref to Task#2983
        public string AllowAllergyMedications
        {
            get { return _AllowAllergyMedications; }
            set { _AllowAllergyMedications = value; }
        }
        //Added in ref to Task#3040
        public string EnableOtherPrescriberSelection
        {
            get { return _EnableOtherPrescriberSelection; }
            set { _EnableOtherPrescriberSelection = value; }
        }
        //Added in ref to Task#2700
        public int QuestionsAnswered
        {
            get { return _QuestionsAnswered; }
            set { _QuestionsAnswered = value; }
        }
        //Added in ref to Task#3145
        public string ChangeOrderStartDateUseToday
        {
            get { return _ChangeOrderStartDateUseToday; }
            set { _ChangeOrderStartDateUseToday = value; }
        }
        // #ka 08232011 Added in ref Task Harbor Customizations / Task# 2 Re-Order: Set Rx Start Date to the previous order's Rx End Day plus 1
        public string RefillStartUseEndPlusOne
        {
            get { return _RefillStartUseEndPlusOne;  } 
            set { _RefillStartUseEndPlusOne = value; }
        }
        public string CanSignUsingSignaturePad
        {
            get { return _CanSignUsingSignaturePad; }
            set { _CanSignUsingSignaturePad = value; }
        }

        public string DevicePassword
        {
            get { return _DevicePassword; }
            set { _DevicePassword = value; }
        }

        public string DeviceEmail
        {
            get { return _DeviceEmail; }
            set { _DeviceEmail = value; }
        }

        public string IsEPCSEnabled
        {
            get { return _IsEPCSEnabled; }
            set { _IsEPCSEnabled = value; }
        }

        public int DEANumber 
        {

            get { return _DEANumber; }
            set { _DEANumber = value; }
        }

        public int PrescribingLocation
        {
            get { return _PrescribingLocation; }
            set { _PrescribingLocation = value; }
        
        }
        
        public int PrescriberId
        {
            get { return _PrescriberId; }
            set { _PrescriberId = value; }
        }

        public StreamlineIdentity(DataRow drUser)
        {

            try
            {

                _userId = Convert.ToInt32(drUser["Staffid"]);
                _userCode = (string)drUser["UserCode"];
                _firstName = (string)drUser["FirstName"];
                _ClinicianRowIdentifier = drUser["RowIdentifier"].ToString();
                _medicationDaysDefault = Convert.ToInt32(drUser["MedicationDaysDefault"]);
                _administrator = (string)drUser["Administrator"];
                if (drUser["LastName"].ToString() == "")
                {
                    _lastName = "";
                }
                else
                {
                    _lastName = (string)drUser["LastName"];
                }

                //added by Loveena ref ticket #78
                if (drUser["StaffPrescribingLocationId"] != System.DBNull.Value)
                    _staffPrescribingLocationId = Convert.ToInt32(drUser["StaffPrescribingLocationId"]);
                else
                    _staffPrescribingLocationId = 0;

                string password = GetOrignalData(drUser["UserPassword"].ToString());
                //_password = "";
                _password = password;
                //Added by Loveena in ref to Task#2595

                _prescriber = drUser["Prescriber"].ToString();
                _StaffDegree = drUser["DegreeName"].ToString();

                _EnablePrecriberSecurityQuestion = drUser["EnablePrescriberSecurityQuestion"].ToString();
                if (drUser["NumberOfPrescriberSecurityQuestions"] != System.DBNull.Value)
                    _NumberOfPrescriberSecurityQuestions = Convert.ToInt32(drUser["NumberOfPrescriberSecurityQuestions"]);
                else
                    _NumberOfPrescriberSecurityQuestions = 0;
                //Added by chandan in ref to Task#2604
                _EnablePrescriptionReview = drUser["EnablePrescriptionReview"].ToString();
                _LastPrescriptionReviewTime = drUser["LastPrescriptionReviewTime"].ToString();
                //Added end by chandan in ref to Task#2604

                //Added in ref to Task#34
                _VerbalOrdersRequireApproval = drUser["VerbalOrdersRequireApproval"].ToString();

                //_SecurityQuestion1 = drUser["SecurityQuestion1"].ToString();

                //_SecurityQuestion2 = drUser["SecurityQuestion2"].ToString();

                //_SecurityQuestion3 = drUser["SecurityQuestion3"].ToString();

                //_SecurityAnswer1 = drUser["SecurityAnswer1"].ToString();

                //_SecurityAnswer2 = drUser["SecurityAnswer2"].ToString();

                //_SecurityAnswer3 = drUser["SecurityAnswer3"].ToString();

                if (drUser["PharmacyCoverLetters"] != System.DBNull.Value)
                    _PharmacyCoverLetter = Convert.ToInt32(drUser["PharmacyCoverLetters"]);
                else
                    _PharmacyCoverLetter = 0;
                //Code ends over here.
                _copyrightInfo = "";
                //if(SystemConfig["CopyrightInfo"].ToString()!="")
                //    _copyrightInfo = (string)SystemConfig["CopyrightInfo"]; //Added by Chandan task #2378 CopyrightInfo
                _copyrightInfo = "Copyright © 2001-" + DateTime.Now.Year.ToString() + " Streamline Healthcare Solutions, LLC. All Rights Reserved.";
                //Added in ref to Task#2895
                _releaseNumber = "4.0";
                _AllowAllergyMedications = Convert.ToString(drUser["AllowAllergyMedications"]);
                _EnableOtherPrescriberSelection = Convert.ToString(drUser["EnableOtherPrescriberSelection"]);
                if (drUser["QuestionsAnswered"] != System.DBNull.Value)
                    _QuestionsAnswered = Convert.ToInt32(drUser["QuestionsAnswered"]);
                else
                    _QuestionsAnswered = 0;
                //Added in ref to Task#3145
                if (drUser["ChangeOrderStartDateUseToday"] != System.DBNull.Value)
                    _ChangeOrderStartDateUseToday = drUser["ChangeOrderStartDateUseToday"].ToString();
                else
                    _ChangeOrderStartDateUseToday = "N";
                // #ka 08232011
                if (drUser["RefillStartUseEndPlusOne"] != System.DBNull.Value)
                    _RefillStartUseEndPlusOne = drUser["RefillStartUseEndPlusOne"].ToString();
                else
                    _RefillStartUseEndPlusOne = "N";
                _CanSignUsingSignaturePad = drUser["CanSignUsingSignaturePad"].ToString();
                _IsEPCSEnabled = drUser["IsEPCSEnabled"].ToString();
                _DevicePassword = drUser["DevicePassword"].ToString();
                _DeviceEmail = drUser["DeviceEmail"].ToString(); 
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


        }

        
        public static string GetOrignalData(string input)
        {
            try
            {
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
        
    }
}

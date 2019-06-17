using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Linq;
using System.Web;
using System.Data;

namespace MedlinePlusLib
{
    /// <summary>
    /// Implementation of the Medline Plus Connect web service.
    /// See: http://www.nlm.nih.gov/medlineplus/connect/service.html 
    /// </summary>
    public static class ConnectMedlinePlus
    {
        //public const string MedlinePlusConnectBaseURL = "https://connect.medlineplus.gov/service";
        public static DataSet datasetSystemConfigurationKeys = null;
        public static Streamline.DataService.SharedTables objSharedTables = new Streamline.DataService.SharedTables();
        public static string MedlinePlusConnectBaseURL { get; set; }

        /// <summary>
        /// Returns Medline Plus Connect web service URL from the database using System Configuartion Key.
        /// </summary>
        static ConnectMedlinePlus()
        {
            datasetSystemConfigurationKeys = objSharedTables.GetSystemConfigurationKeys();
            string MedlinePlusConnectWebServiceURL = objSharedTables.GetSystemConfigurationKeys("URLForMedlinePlusConnectBase", datasetSystemConfigurationKeys.Tables[0]).ToString();
            if (!string.IsNullOrEmpty(MedlinePlusConnectWebServiceURL))
                MedlinePlusConnectBaseURL = MedlinePlusConnectWebServiceURL;
        }
        /// <summary>
        /// Identifies the code system to be used for Problem Code inquiries
        /// </summary>
        public enum PCCodeSystem
        {
            ICD9CM,
            ICD10CM,
            SNOMED_CT_CORE_Problem_List_Subset
        }

        public static string getPCCodeSystemValue(PCCodeSystem cs)
        {
            string codeSystemValue = "";

            switch (cs)
            {
                case PCCodeSystem.ICD9CM:
                    codeSystemValue = "2.16.840.1.113883.6.103";
                    break;
                case PCCodeSystem.ICD10CM:
                    codeSystemValue = "2.16.840.1.113883.6.90";
                    break;
                case PCCodeSystem.SNOMED_CT_CORE_Problem_List_Subset:
                    codeSystemValue = "2.16.840.1.113883.6.96";
                    break;
                default:
                    codeSystemValue = "2.16.840.1.113883.6.96";
                    break;
            }

            return codeSystemValue;
        }

        /// <summary>
        /// Identifies the language of the request
        /// </summary>
        public enum Language
        {
            English,
            Spanish
        }

        public static string getLanguageValue(Language lang)
        {
            string l = "";

            switch (lang)
            {
                case Language.English:
                    l = "en";
                    break;
                case Language.Spanish:
                    l = "sp";
                    break;
                default:
                    l = "en";
                    break;
            }

            return l;
        }

        /// <summary>
        /// Identifies the code systems to be used for Drug Information inquiries
        /// </summary>
        public enum DICodeSystem
        {
            NDC,
            RXCUI
        }

        public static string getDICodeSystemValue(DICodeSystem dicv)
        {
            string DICodeSystemValue = "";

            switch (dicv)
            {
                case DICodeSystem.NDC:
                    DICodeSystemValue = "2.16.840.1.113883.6.69";
                    break;
                case DICodeSystem.RXCUI:
                    DICodeSystemValue = "2.16.840.1.113883.6.88";
                    break;
                default:
                    DICodeSystemValue = "2.16.840.1.113883.6.88";
                    break;
            }

            return DICodeSystemValue;
        }

        /// <summary>
        /// Identifies the code systems to be used for Lab Test inquiries
        /// </summary>
        public enum LTCodeSystem
        {
            LOINC,
            Other
        }

        public static string getLTCodeSystemValue(LTCodeSystem ltcv)
        {
            string LTCodeSystemValue = "";

            switch (ltcv)
            {
                case LTCodeSystem.LOINC:
                    LTCodeSystemValue = "2.16.840.1.113883.6.1";
                    break;
                case LTCodeSystem.Other:
                    LTCodeSystemValue = "2.16.840.1.113883.11.79";
                    break;
                default:
                    LTCodeSystemValue = "2.16.840.1.113883.6.1";
                    break;
            }


            return LTCodeSystemValue;
        }

#region Problem Code Requests

        /// <summary>
        /// Returns summary information for the specified problem code
        /// </summary>
        /// <param name="pcValue">The value associated with the problem code</param>
        /// <param name="cs">The code system in which the problem code has meaning</param>
        /// <param name="objAppErr">The application error object</param>
        /// <returns></returns>
        public static XElement getProblemCode(string pcValue, PCCodeSystem cs, Language lang )
        {
            XElement problemCode = null;
            string url = MedlinePlusConnectBaseURL + "?mainSearchCriteria.v.cs=" + getPCCodeSystemValue(cs);
            url += "&mainSearchCriteria.v.c=" +  HttpUtility.UrlEncode(pcValue);
            url += "&informationRecipient.languageCode.c=" + getLanguageValue(lang);

            try
            {
                problemCode = XElement.Load(url);
            }
            catch (Exception ex)
            {
             
            }

            return problemCode;
        }

#endregion

#region Drug Information Requests

        /// <summary>
        /// Returns summary information for the specified drug code
        /// </summary>
        /// <param name="dcValue">The value associated with the drug code</param>
        /// <param name="cs">The code system in which the drug code has meaning</param>
        /// <param name="lang">The language in which the response should be returned</param>
        /// <param name="objAppErr">The application error object</param>
        /// <returns></returns>
        public static XElement getDrugInfoByCode(string dcValue, DICodeSystem cs, Language lang)
        {
            XElement result = null;
            string url = MedlinePlusConnectBaseURL + "?mainSearchCriteria.v.cs=" + getDICodeSystemValue(cs);
            url += "&mainSearchCriteria.v.c=" + HttpUtility.UrlEncode(dcValue);
            url += "&informationRecipient.languageCode.c=" + getLanguageValue(lang);

            try
            {
                result = XElement.Load(url);
            }
            catch (Exception ex)
            {
               
            }

            return result;
        }

        /// <summary>
        /// Returns drug information based on the name of the drug
        /// </summary>
        /// <param name="dnValue">The name of the drug</param>
        /// <param name="cs">The code system in which the drug name has meaning</param>
        /// <param name="lang">The language in which the response should be returned</param>
        /// <param name="objAppErr">The application error object</param>
        /// <returns></returns>
        public static XElement getDrugInfoByName(string dnValue, DICodeSystem cs, Language lang)
        {
            XElement result = null;
            string url = MedlinePlusConnectBaseURL + "?mainSearchCriteria.v.cs=" + getDICodeSystemValue(cs);
            url += "&mainSearchCriteria.v.dn=" + HttpUtility.UrlEncode(dnValue);
            url += "&informationRecipient.languageCode.c=" + getLanguageValue(lang);

            try
            {
                result = XElement.Load(url);
            }
            catch (Exception ex)
            {
              
            }

            return result;
        }

#endregion

#region Lab Test Requests

        /// <summary>
        /// Returns information about the lab test
        /// </summary>
        /// <param name="ltValue"></param>
        /// <param name="cs">The code system in which the lab test has meaning</param>
        /// <param name="lang">The language in which the response should be returned</param>
        /// <param name="objAppErr">The application error object</param>
        /// <returns></returns>
        public static XElement getLabTestInfo(string ltValue, LTCodeSystem cs, Language lang)
        {
            XElement result = null;
            string url = MedlinePlusConnectBaseURL + "?mainSearchCriteria.v.cs=" + getLTCodeSystemValue(cs);
            url += "&mainSearchCriteria.v.c=" + HttpUtility.UrlEncode(ltValue);
            url += "&informationRecipient.languageCode.c=" + getLanguageValue(lang);

            try
            {
                result = XElement.Load(url);
            }
            catch (Exception ex)
            {
              
            }

            return result;
        }

#endregion

    }
}

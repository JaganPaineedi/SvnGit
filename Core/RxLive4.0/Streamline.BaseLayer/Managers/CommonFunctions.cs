using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Security.Cryptography;
using System.Text.RegularExpressions;
using System.IO;
using System.Text;
using System.Collections;
using System.Diagnostics;
using System.Reflection;

namespace Streamline.BaseLayer
{
    /// <summary>
    /// Summary description for CommonFunctions
    /// </summary>
    /// 

    public class CommonFunctions
    {

        private static byte[] KEY = new byte[] { 0x12, 0xe3, 0x4a, 0xa1, 0x45, 0xd2, 0x56, 0x7c, 0x54, 0xac, 0x67, 0x9f, 0x45, 0x6e, 0xaa, 0x56 };
        private static byte[] IV = new byte[] { 0x12, 0xe3, 0x4a, 0xa1, 0x45, 0xd2, 0x56, 0x7c };
        private string _guidpath;
        public string guidpath
        {
            get
            {
                return _guidpath;
            }
            set
            {
                _guidpath = value;
            }
        }
        public CommonFunctions()
        {
            //
            // TODO: Add constructor logic here
            //
        }

        /// <summary>
        ///  This Function is used to Trap the Last Events For Error Log  
        /// </summary>
        /// <param name="number"></param>
        /// <param name="length">Date as String </param>
        /// <returns></returns>
        /// <author>Chandan Srivastava</author>

        public static void Event_Trap(object classInfo)
        {
            try
            {
                //Streamline.ProviderAccessBaseLibrary.BaseCommonFunctions.Singleton.EventCount = Streamline.ProviderAccessBaseLibrary.BaseCommonFunctions.Singleton.EventCount + 1;
                StackTrace objTrace = new StackTrace();
                StackFrame objFrame = objTrace.GetFrame(1);
                MethodBase objMethod = objFrame.GetMethod();
                string MethodName = objMethod.Name;
                //string StringEvent = System.Web.HttpContext.Current.Session["CurrentPage"].ToString() + "~!" + MethodName + "~!" + KeyParameters + "#|";
                //if (Streamline.ProviderAccessBaseLibrary.BaseCommonFunctions.Singleton.EventCount <= int.Parse(System.Configuration.ConfigurationSettings.AppSettings["CountEvent"].ToString()))
                //{
                //    //System.Web.HttpContext.Current.Session["TrapString"] = System.Web.HttpContext.Current.Session["TrapString"] + StringEvent;
                //    Streamline.ProviderAccessBaseLibrary.BaseCommonFunctions.Singleton.EventString = Streamline.ProviderAccessBaseLibrary.BaseCommonFunctions.Singleton.EventString + StringEvent;
                //}
                //else if (Streamline.ProviderAccessBaseLibrary.BaseCommonFunctions.Singleton.EventCount > int.Parse(System.Configuration.ConfigurationSettings.AppSettings["CountEvent"].ToString()))
                //{
                //    int x = Streamline.ProviderAccessBaseLibrary.BaseCommonFunctions.Singleton.EventString.IndexOf("#|");
                //    Streamline.ProviderAccessBaseLibrary.BaseCommonFunctions.Singleton.EventString = Streamline.ProviderAccessBaseLibrary.BaseCommonFunctions.Singleton.EventString.Substring(x + 2);
                //    Streamline.ProviderAccessBaseLibrary.BaseCommonFunctions.Singleton.EventString = Streamline.ProviderAccessBaseLibrary.BaseCommonFunctions.Singleton.EventString + StringEvent;
                //    Streamline.ProviderAccessBaseLibrary.BaseCommonFunctions.Singleton.EventCount = Streamline.ProviderAccessBaseLibrary.BaseCommonFunctions.Singleton.EventCount - 1;
                //}
            }
            catch (Exception ex)
            {
                throw (ex);
            }
        }
        /// <summary>
        ///  This Function is used to Trap the Last Events For Error Log. Overloaded function if the user does'nt pass any parameter.
        /// </summary>
        /// <param name="number"></param>
        /// <param name="length">Date as String </param>
        /// <returns></returns>
        /// <author>Chandan Srivastava</author>
        public static void Event_Trap()
        {
            try
            {
                // Streamline.ProviderAccessBaseLibrary.BaseCommonFunctions.Singleton.EventCount = Streamline.ProviderAccessBaseLibrary.BaseCommonFunctions.Singleton.EventCount + 1;
                string KeyParameters = "";
                StackTrace objTrace = new StackTrace();
                StackFrame objFrame = objTrace.GetFrame(1);
                MethodBase objMethod = objFrame.GetMethod();
                string MethodName = objMethod.Name;
                string StringEvent = System.Web.HttpContext.Current.Session["CurrentPage"].ToString() + "~!" + MethodName + "~!" + KeyParameters + "#|";
                //if (Streamline.ProviderAccessBaseLibrary.BaseCommonFunctions.Singleton.EventCount <= int.Parse(System.Configuration.ConfigurationSettings.AppSettings["CountEvent"].ToString()))
                //{
                //    //System.Web.HttpContext.Current.Session["TrapString"] = System.Web.HttpContext.Current.Session["TrapString"] + StringEvent;
                //    Streamline.ProviderAccessBaseLibrary.BaseCommonFunctions.Singleton.EventString = Streamline.ProviderAccessBaseLibrary.BaseCommonFunctions.Singleton.EventString + StringEvent;
                //}
                //else if (Streamline.ProviderAccessBaseLibrary.BaseCommonFunctions.Singleton.EventCount > int.Parse(System.Configuration.ConfigurationSettings.AppSettings["CountEvent"].ToString()))
                //{
                //    int x = Streamline.ProviderAccessBaseLibrary.BaseCommonFunctions.Singleton.EventString.IndexOf("#|");
                //    Streamline.ProviderAccessBaseLibrary.BaseCommonFunctions.Singleton.EventString = Streamline.ProviderAccessBaseLibrary.BaseCommonFunctions.Singleton.EventString.Substring(x + 2);
                //    Streamline.ProviderAccessBaseLibrary.BaseCommonFunctions.Singleton.EventString = Streamline.ProviderAccessBaseLibrary.BaseCommonFunctions.Singleton.EventString + StringEvent;
                //    Streamline.ProviderAccessBaseLibrary.BaseCommonFunctions.Singleton.EventCount = Streamline.ProviderAccessBaseLibrary.BaseCommonFunctions.Singleton.EventCount - 1;
                //}
            }
            catch (Exception ex)
            {
                throw (ex);
            }
        }
        /// <summary>
        ///  This Function is used to Build a xml string on Error occurence  
        /// </summary>
        /// <param name="number"></param>
        /// <param name="length">Trap String </param>
        /// <returns></returns>
        /// <author>Chandan Srivastava</author>
        public static string Event_FormatString(string EventString)
        {
            try
            {
                string EventFormatString;
                ArrayList EventArray = new ArrayList();
                ArrayList MethodArray = new ArrayList();

                string[] ParameterArray = null;

                string StringParameterName = null;
                string StringParameterValue = null;
                string StringClassName;
                string StringModuleName;
                string StringParameters;
                string RemaningString;
                StringBuilder XmlEventString = new StringBuilder();
                int x;
                if (EventString != null && EventString.Length > 0)
                {

                    if (EventString.IndexOf("#|") > 0)
                    {
                        XmlEventString.Append("<EventLog>");   //EventLog Tag                
                        //XmlEventString = "<EventLog>";   //EventLog Tag
                        EventFormatString = EventString;
                        EventArray = StringSplit(EventFormatString, "#|");

                        for (int i = 0; i <= EventArray.Count - 1; i++)
                        {
                            if (EventArray[i] != null && EventArray[i].ToString().Length > 0)
                            {
                                XmlEventString.Append("<Event>");   //<Event Tag>                           
                                MethodArray = StringSplit(EventArray[i].ToString(), "~!");
                                StringClassName = MethodArray[0].ToString();
                                StringModuleName = MethodArray[1].ToString();
                                if (MethodArray.Count > 2)
                                {
                                    StringParameters = MethodArray[2].ToString();
                                }
                                else
                                {
                                    StringParameters = "";
                                }

                                XmlEventString.Append("<ClassName>" + StringClassName + "</ClassName>");  //Class Tag                        
                                XmlEventString.Append("<Method>");
                                XmlEventString.Append("<MethodName>" + StringModuleName + "</MethodName>");
                                if (StringParameters.Length > 0)
                                {

                                    ParameterArray = StringParameters.Split('^');
                                    XmlEventString.Append("<Parameters>");
                                    for (int j = 0; j <= ParameterArray.Length - 1; j++)
                                    {
                                        if (ParameterArray[j] != null && ParameterArray[j].ToString().Length > 0)
                                        {
                                            StringParameterValue = "";
                                            StringParameterName = "";
                                            x = StringParameters.IndexOf("^");
                                            x = ParameterArray[j].ToString().IndexOf("-");
                                            if (x > 0)
                                            {
                                                StringParameterName = ParameterArray[j].ToString().Substring(0, ParameterArray[j].ToString().IndexOf("-"));
                                                x = ParameterArray[j].ToString().IndexOf("-");
                                                StringParameterValue = ParameterArray[j].ToString().Substring(x + 1);
                                            }
                                            else
                                            {
                                                StringParameterName = ParameterArray[j].ToString();
                                                StringParameterValue = "";
                                            }
                                            char[] invalidChars ={ '<', '>', '#', '@', '&', ':' };
                                            if (StringParameterValue.IndexOfAny(invalidChars) != -1)
                                            {
                                                XmlEventString.Append("<" + StringParameterName + ">" + "<![CDATA[" + StringParameterValue + "]]>" + "</" + StringParameterName + ">");
                                            }
                                            else
                                            {
                                                XmlEventString.Append("<" + StringParameterName + ">" + StringParameterValue + "</" + StringParameterName + ">");
                                            }
                                        }
                                    }
                                    XmlEventString.Append("</Parameters>");
                                }
                                XmlEventString.Append("</Method>");
                                XmlEventString.Append("</Event>");
                            }
                        }
                        XmlEventString.Append("</EventLog>");
                    }
                    //TextWriter tw = new StreamWriter(System.Web.HttpContext.Current.Server.MapPath("abc.txt"));
                    //tw.WriteLine(XmlEventString.ToString());
                    //tw.Close();
                    System.Web.HttpContext.Current.Session["XmlTrapString"] = XmlEventString.ToString();
                }
                return XmlEventString.ToString();
            }
            catch (Exception ex)
            {
                return "<EventLog>None</EventLog>";
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


        /// <summary>
        ///  This Function is used to set the ForeColor of error message label from configuration settings.
        /// </summary>
        /// <param name="ErrorLabel"></param>       
        /// <returns></returns>
        /// <author>Rohit Verma</author>
        /// <CreatedDate>12/dec/2008 </CreatedDate>
        public static void SetErrorMegssageBackColor(Label ErrorLabel)
        {
            string _backColor = System.Configuration.ConfigurationSettings.AppSettings["ErrorMessageBackColor"];
            if (_backColor != null)
            {
                try
                {
                    System.Drawing.ColorConverter colConvert = new System.Drawing.ColorConverter();
                    ErrorLabel.BackColor = (System.Drawing.Color)colConvert.ConvertFromString(_backColor);
                }
                catch (Exception ex)
                {
                    //throw (ex);                    
                }
            }
        }
        /// <summary>
        /// <Description>Used to dispose application session as per task#3323</Description>
        /// <Author>PradeeP</Author>
        /// <CreatedOn>4th March 2011</CreatedOn>
        /// </summary>
        public static void DisposeMMApplicationSessions(bool tokenExists)
        {
            try
            {
                if (tokenExists) //If open MM instance from outside MM all sessions should be destroyed
                {
                    HttpContext.Current.Session["DataSetTitration"] = null;
                    HttpContext.Current.Session["SelectedMedicationId"] = null;
                    HttpContext.Current.Session["IsDirty"] = null;
                    HttpContext.Current.Session["ChangedOrderMedicationIds"] = null;
                    HttpContext.Current.Session["DataSetAllergy"] = null;
                    HttpContext.Current.Session["ChangedOrderMedicationIds"] = null;
                    HttpContext.Current.Session["PopulateRowDataOfMedicationList"] = null;
                    HttpContext.Current.Session["StandardHarborConsent"] = null;
                    HttpContext.Current.Session["DocumentId"] = null;
                    HttpContext.Current.Session["SignatureOrder"] = null;
                    HttpContext.Current.Session["DataSetCustomdocuments"] = null;
                    HttpContext.Current.Session["SignatureId"] = null;
                    HttpContext.Current.Session["StandardHarborConsent"] = null;
                    HttpContext.Current.Session["DocumentVersionId"] = null;
                    HttpContext.Current.Session["PatientAlreadySignedDocument"] = null;
                    HttpContext.Current.Session["DataViewClientMedicationScriptHistory"] = null;
                    HttpContext.Current.Session["DataSetConsentMedicationHistory"] = null;
                    HttpContext.Current.Session["ExternalClientInformation"] = null;
                }
                //These session instances should always be set to null on client Change
                HttpContext.Current.Session["DataSetClientSummary"] = null;
                HttpContext.Current.Session["DataSetClientMedications"] = null;
                HttpContext.Current.Session["DataSetPrescribedClientMedications"] = null;


            }
            catch (Exception ex)
            {
                throw (ex);
            }
        }

        /// <summary>
        ///  This Function is used to set the ForeColor of error message label from configuration settings.
        /// </summary>
        /// <param name="ErrorLabel"></param>       
        /// <returns></returns>
        /// <author>Rohit Verma</author>
        /// <CreatedDate>12/dec/2008 </CreatedDate>
        public static void SetErrorMegssageForeColor(Label ErrorLabel)
        {
            string _foreColor = System.Configuration.ConfigurationSettings.AppSettings["ErrorMessageForeColor"];
            if (_foreColor != null)
            {
                try
                {
                    System.Drawing.ColorConverter colConvert = new System.Drawing.ColorConverter();
                    ErrorLabel.ForeColor = (System.Drawing.Color)colConvert.ConvertFromString(_foreColor);
                }
                catch (Exception ex)
                {
                    throw (ex);
                }
            }
        }
        #region--Code Added By Pradeep as per task#333
        /// <summary>
        /// <Description>Used to handle special character encoding</Description>
        /// <Author>Pradeep</Author>
        /// <CreatedOn>12 March 2011</CreatedOn>
        /// </summary>
        /// <param name="val"></param>
        /// <returns></returns>
        public static string ReplaceSpecialChars(string val)
        {
            try
            {
                //return val.Replace("!", "%21").Replace("\"", "%22").Replace("#", "%23").Replace("$", "%24").Replace("'", "%27").Replace("&", "%26").Replace("(", "%28").Replace(")", "%29").Replace("*", "%2A").Replace("+", "%2B").Replace(",", "%2C").Replace("-", "%2D").Replace("/", "%2F").Replace("\\", "%5C").Replace("]", "%5D").Replace("[", "%5B").Replace("^", "%5E").Replace("{", "%7B").Replace("|", "%7C").Replace("~", "%7D").Replace("@", "%40").Replace("?", "%3F").Replace(">", "%3E").Replace("=", "%3D").Replace("<", "%3C").Replace(";", "%3B").Replace(":", "%3A").Replace("%", "%25");
                return val.Replace("!", "%21").Replace("\"", "%22").Replace("#", "%23").Replace("$", "%24").Replace("'", "%27").Replace("+", "%2B").Replace(",", "%2C").Replace("-", "%2D").Replace("/", "%2F").Replace("\\", "%5C").Replace(">", "%3E").Replace("<", "%3C").Replace("&", "%26").Replace("*", "%2A");
                
            }
            catch (Exception ex)
            {
                throw (ex);
            }
        }
        #endregion
        #region--Code Added By TOM as per task#3341
        
        /// <summary>
        /// trimToPrecision() trims a numeric string to the given number of decimal places.
        /// if significant digits exist beyond iDemcimalPlaces parameter, these are retained.
        /// </summary>
        /// <param name="sDec"></param>
        /// String containing a decimal number
        /// <param name="iDecimalPlaces"></param>
        /// Minimum number of decimal places to retain.
        /// <returns>string containing formatted string</returns>
        public static string trimToPrecision(string sDec, int iDecimalPlaces)
        {
            if (string.IsNullOrEmpty(sDec))
                return "";


            if (sDec.Contains("."))
            {
                // remove all trailing zeroes that exist to the right of the decimal
                sDec = sDec.TrimEnd('0');
            }
            else
            {
                // tack on a decimal point
                sDec = sDec + ".";
            }

            // add decimal digits to specified number of places
            while (sDec.IndexOf('.') >= (sDec.Length - iDecimalPlaces))
            {
                sDec = sDec + '0';
            }

            // trim multiple leading zeroes to just one
            while ((sDec.IndexOf('0') == 0) && (sDec.IndexOf('.') > 1))
            {
                sDec = sDec.Substring(1);
            }

            return sDec;
        }

        #endregion
        /// <summary>
        /// <Description>This function is used to get encrypted password</Description>
        /// <Author>Loveena</Author>
        /// <CreationDate>04/May/2009</CreationDate>
        /// </summary>
        /// <param name="input"></param>
        /// <returns></returns>
        public static string GetEncryptedData(string input)
        {
            try
            {
                return EncryptBase64(input, KEY, IV);
            }
            catch
            {
                return input;
            }
        }
        #region---Code Added on 9Jan,2010
        /// <summary>
        /// To Call Click Event Of Button on 
        /// </summary>
        /// Created By Sanvir Kumar on Sept 19, 2007
        /// <param name="ImageID"></param>
        /// <param name="page"></param>
        public static string ReturnJSForClickEvent(string ButtonUniqueID)
        {
            try
            {
                string var = "HandleEnterKey('" + ButtonUniqueID + "','',event);";
                return var;
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }

        public static string ReturnJSForClickEvent(string ButtonUniqueID, string JavaScriptValidateFunction)
        {
            try
            {
                string newval = JavaScriptValidateFunction.Replace("'", "\\'");
                //string var="if(event.which || event.keyCode){if ((event.which == 13) || (event.keyCode == 13)) { if(eval('"+JavaScriptValidateFunction +"')){ document.getElementById('" + ButtonUniqueID + "').focus();document.getElementById('" + ButtonUniqueID + "').click();}else {return false;}}} else {return false;} ";
                string var = "HandleEnterKey('" + ButtonUniqueID + "','" + newval + "',event)";
                return var;
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }
        #endregion---Code Ended on 9Jan,2010
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

    }

    /// <summary>
    /// 
    /// </summary>
    /// -------ModificationHistory---------------
    /// Date--------Author--------Purpose------------
    /// 7 Nov 2009  Pradeep       As per task#31
    /// 24 Dec 2009 Pradeep       Added permissions for Queue Order button as per task#
    public enum Permissions
    {
        ViewHistory = 10023,
        NewOrder = 10024,
        AddMedication = 10025,
        AddAllergy = 10026,
        PrintList = 10027,
        ReOrder = 10040,
        ChangeOrder = 10028,
        EditPreferredPharmacy = 10042,
        RefreshSharedTables = 10043,
        PatientConsent = 10050,
        PermitChanges = 10051, //Added By Pradeep as per task#31
        QueueOrder = 10052,//Added By Pradeep as per task#3
        HealthData = 10053, //Added by Loveena in ref to Task#34
        ApproveAllOrder=10054,//Added by Priya Ref:task no:2924
        Reconciliation=10061, //#KA 01/26/2012 added as a request by Tom
        Formulary = 10062, //#KA 01/26/2012 added as a request by Tom
        DiscontinueNone = 10063,
        GrowthChart = 10064,
        AdjustDosageSchedule = 10065,
        OffLabel = 10066,
        ViewOnlyConsent = 10067,
		MedOrderTemplate = 10070,
        Eligibility = 10071,
        MedicationHistory = 10072,
        DrugFormulary = 10073,
        EPCS = 10074,
        CompleteOrder = 10075,
        PMP = 10167
    }

}
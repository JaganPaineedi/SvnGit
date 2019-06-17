using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using Microsoft.ApplicationBlocks.ExceptionManagement;
using System.Collections;
using System.Diagnostics;
using System.Reflection;
using System.IO;
using System.Text;
using System.Data.SqlClient;

namespace Streamline.BaseLayer
{
    /// <summary>
    /// Summary description for LogManager
    /// </summary>
    public static class StaticLogManager
    {
        public enum LoggingLevel
        {
            Error = 10,
            Warning = 8,
            Informational = 6,
            Debug = 4,
            Extended = 2,
            All = 0
        }

        public enum LoggingCategory
        {
            General = 0
        }

        private static LoggingLevel _AuditLogLevel;

        private static LoggingLevel _AuditQueueLevel;

        public static LoggingLevel AuditLogLevel
        {
            get
            {
                return _AuditLogLevel;
            }
            set
            {
                _AuditLogLevel = value;
            }
        }
        public static LoggingLevel AuditQueueLevel
        {
            get
            {
                return _AuditQueueLevel;
            }
            set
            {
                _AuditQueueLevel = value;
            }
        }

        /// <summary>
        /// This Method will log Exception and Display Error message to the user
        /// </summary>
        /// <param name="ex">ex Object, containing Exception Information</param>
        /// <param name="category">Category- General</param>
        /// <param name="level">Logging Level- error, Warning or Information</param>
        /// <returns>bool value- True/False</returns>
        /// <CreatedBy>Chandan</CreatedBy>
        /// <CreatedOn>Feb 13 2008</CreatedOn>
        /// <ModifiedBy>Chandan</ModifiedBy>
        /// <ModifiedOn>Feb 13 2008</ModifiedOn>
        public static bool LogException(System.Exception ex, LoggingCategory category, LoggingLevel level)
        {
            BaseActivityPage ObjectActivityPage = null;
            try
            {
                ExceptionManager.Publish(ex);

                ObjectActivityPage = new BaseActivityPage();
                string ParseMessage = ex.Message;
                if (ex.Message.IndexOf("Concurrency") != -1)
                {
                    ObjectActivityPage.ShowError("The information you are updating has been changed by another user. Please refresh the information you are updating.", true);
                }
                else if (ParseMessage.IndexOf("System.Data.SqlClient.SqlException:") > 0)
                {
                    int SubstringLen = ParseMessage.IndexOf("\n") - ParseMessage.IndexOf("System.Data.SqlClient.SqlException:");
                    ParseMessage = ParseMessage.Substring(ParseMessage.IndexOf("System.Data.SqlClient.SqlException:") + 35, SubstringLen - 35);
                    ObjectActivityPage.ShowError(ParseMessage, true);
                }
                else
                {
                    ObjectActivityPage.ShowError("Error Occurred - Please Contact Your System Administrator!", true);
                }
            }
            catch
            {
                string str = ex.Message.ToString();
                if (ObjectActivityPage == null)
                {
                    ObjectActivityPage = new BaseActivityPage();
                }
                ObjectActivityPage.ShowError("Error Occurred - Please Contact Your System Administrator!", true);
            }
            finally
            {
                ObjectActivityPage = null;
            }

            return true;

        }

        /// <summary>
        /// This Method will log Exception and Display Error message to the user
        /// </summary>
        /// <param name="ex">ex Object, containing Exception Information</param>
        /// <param name="category">Category- General</param>
        /// <param name="level">Logging Level- error, Warning or Information</param>
        /// <returns>bool value- True/False</returns>
        /// <CreatedBy>Chandan</CreatedBy>
        /// <CreatedOn>Feb 13 2008</CreatedOn>
        public static bool LogException(System.Exception ex, LoggingCategory category, LoggingLevel level, Control Ctrl)
        {
            BaseActivityPage ObjectActivityPage = null;
            try
            {
                ExceptionManager.Publish(ex);
                ObjectActivityPage = new BaseActivityPage();
                string ParseMessage = ex.Message;

                string ErrorNumber = "";
                if (ParseMessage.IndexOf("*****") > 0)
                {
                    ErrorNumber = ParseMessage.Substring(0, ParseMessage.IndexOf("*****"));
                    Int32 Index = ParseMessage.IndexOf("*****") + 5;
                    ParseMessage = ParseMessage.Substring(Index);
                    ParseMessage = ParseMessage.Substring(0, ParseMessage.IndexOf("*****"));
                    ObjectActivityPage.ShowError(ParseMessage, true, Ctrl);
                }
                else
                {
                    if (ex.Message.IndexOf("Concurrency") != -1)
                    {
                        ObjectActivityPage.ShowError("The information you are updating has been changed by another user. Please refresh the information you are updating.", true, Ctrl);
                    }
                    else if (ParseMessage.IndexOf("System.Data.SqlClient.SqlException:") > 0)
                    {
                        int SubstringLen = ParseMessage.IndexOf("\n") - ParseMessage.IndexOf("System.Data.SqlClient.SqlException:");
                        ParseMessage = ParseMessage.Substring(ParseMessage.IndexOf("System.Data.SqlClient.SqlException:") + 35, SubstringLen - 35);
                        ObjectActivityPage.ShowError(ParseMessage, true, Ctrl);
                    }

                    else
                    {
                        ObjectActivityPage.ShowError("Error Occurred - Please Contact Your System Administrator!", true, Ctrl);
                    }
                }
            }
            catch
            {
                string str = ex.Message.ToString();
                if (ObjectActivityPage == null)
                {
                    ObjectActivityPage = new BaseActivityPage();
                }
                ObjectActivityPage.ShowError("Error Occurred - Please Contact Your System Administrator!", true);
            }
            finally
            {
                ObjectActivityPage = null;
            }
            return true;
        }


        /// <summary>
        /// This function logs the exception along with logging the Verbose Mode
        /// </summary>
        /// <param name="ex"></param>
        /// <param name="category"></param>
        /// <param name="level"></param>
        /// <param name="VerboseMode"></param>
        /// <returns></returns>
        /// <CreatedBy>Chandan</CreatedBy>
        /// <CreatedOn>Feb 13 2008</CreatedOn>
        public static bool LogException(System.Exception ex, LoggingCategory category, LoggingLevel level, string VerboseMode)
        {
            BaseActivityPage ObjectActivityPage = null;
            try
            {
                ex.Data["CustomExceptionInformation"] = VerboseMode;
                ExceptionManager.Publish(ex);
                return true;
            }
            catch
            {
                string str = ex.Message.ToString();
                ObjectActivityPage = new BaseActivityPage();
                ObjectActivityPage.ShowError("Error Occurred - Please Contact Your System Administrator!", true);
                throw;
            }
            finally
            {
                ObjectActivityPage = null;
            }
        }


        /// <summary>
        ///  This Function is used to Trap the Last Events For Error Log  
        /// </summary>
        /// <param name="number"></param>
        /// <param name="length">Date as String </param>
        /// <returns></returns>
        /// <author>Chandan Srivastava</author>
        public static void Event_Trap(string KeyParameters)
        {
            try
            {
                System.Web.HttpContext.Current.Session["EventCount"] = Convert.ToInt32(System.Web.HttpContext.Current.Session["EventCount"]) + 1;
                StackTrace objTrace = new StackTrace();
                StackFrame objFrame = objTrace.GetFrame(1);
                MethodBase objMethod = objFrame.GetMethod();
                string MethodName = objMethod.Name;
                string StringEvent = System.Web.HttpContext.Current.Session["CurrentPage"].ToString() + "~!" + MethodName + "~!" + KeyParameters + "#|";
                if (Convert.ToInt32(System.Web.HttpContext.Current.Session["EventCount"]) <= int.Parse(System.Configuration.ConfigurationSettings.AppSettings["CountEvent"].ToString()))
                {
                    //System.Web.HttpContext.Current.Session["TrapString"] = System.Web.HttpContext.Current.Session["TrapString"] + StringEvent;
                    System.Web.HttpContext.Current.Session["EventString"] = System.Web.HttpContext.Current.Session["EventString"] + StringEvent;
                }
                else if (Convert.ToInt32(System.Web.HttpContext.Current.Session["EventCount"]) > int.Parse(System.Configuration.ConfigurationSettings.AppSettings["CountEvent"].ToString()))
                {
                    int x = System.Web.HttpContext.Current.Session["EventString"].ToString().IndexOf("#|");
                    System.Web.HttpContext.Current.Session["EventString"] = System.Web.HttpContext.Current.Session["EventString"].ToString().Substring(x + 2);
                    System.Web.HttpContext.Current.Session["EventString"] = System.Web.HttpContext.Current.Session["EventString"] + StringEvent;
                    System.Web.HttpContext.Current.Session["EventCount"] = Convert.ToInt32(System.Web.HttpContext.Current.Session["EventCount"]) - 1;
                }

                //// Following Block of code added by Piyush on 9th Dec 2007, so as to write each an every method call to the text file when the Some key is set to Y in Web config file 
                //try
                //{
                //    if (System.Configuration.ConfigurationSettings.AppSettings["VerboseMethodCallLogToTextfile"].ToString() == "Y" || System.Configuration.ConfigurationSettings.AppSettings["VerboseMethodCallLogToTextfile"].ToString() == "y")
                //    {
                //        //TextWriter ObjectTextWrite = new StreamWriter(System.Web.HttpContext.Current.Server.MapPath(@"~\MethodLog_" + System.Web.HttpContext.Current.Session.SessionID + "_" + Streamline.ProviderAccessBaseLibrary.BaseCommonFunctions.Singleton.Instance.UserCode + ".txt"), true);
                //        TextWriter ObjectTextWrite = new StreamWriter(System.Web.HttpContext.Current.Server.MapPath(@"~\MethodLog_" + System.Web.HttpContext.Current.Session.SessionID + ".txt"), true);
                //        if (KeyParameters == "")
                //            ObjectTextWrite.WriteLine("\r\n Screen Name - " + System.Web.HttpContext.Current.Session["CurrentPage"].ToString() + " ### Method Name - " + MethodName + " ### Key Parameters - None");
                //        else if (KeyParameters.IndexOf("^") > 0)// as KepParameters if are more than one in no. then they contain "^" sign which will now be replaced with ", " to distinguish between two parameters
                //        {
                //            string ManipulatedKeyParameters = "";
                //            ManipulatedKeyParameters = KeyParameters.Replace("^", ", ");
                //            ObjectTextWrite.WriteLine("\r\n Screen Name - " + System.Web.HttpContext.Current.Session["CurrentPage"].ToString() + " ### Method Name - " + MethodName + " ### Key Parameters - " + ManipulatedKeyParameters);
                //        }
                //        else
                //            ObjectTextWrite.WriteLine("\r\n Screen Name - " + System.Web.HttpContext.Current.Session["CurrentPage"].ToString() + " ### Method Name - " + MethodName + " ### Key Parameters - " + KeyParameters);
                //        ObjectTextWrite.Close();
                //        ObjectTextWrite.Dispose();
                //    }
                //}
                //catch (Exception excep)
                //{
                //    excep.Message.ToString();
                //}
                // code addition ends here by Piyush on 9th Dec 2007, so as to write each an every method call to the text file when the Some key is set to Y in Web config file 
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
                //System.Web.HttpContext.Current.Session["EventCount"]
                //System.Web.HttpContext.Current.Session["EventString"]
                System.Web.HttpContext.Current.Session["EventCount"] = Convert.ToInt32(System.Web.HttpContext.Current.Session["EventCount"]) + 1;
                string KeyParameters = "";
                StackTrace objTrace = new StackTrace();
                StackFrame objFrame = objTrace.GetFrame(1);
                MethodBase objMethod = objFrame.GetMethod();
                string MethodName = objMethod.Name;
                string StringEvent = System.Web.HttpContext.Current.Session["CurrentPage"].ToString() + "~!" + MethodName + "~!" + KeyParameters + "#|";
                if (Convert.ToInt32(System.Web.HttpContext.Current.Session["EventCount"]) <= int.Parse(System.Configuration.ConfigurationSettings.AppSettings["CountEvent"].ToString()))
                {
                    //System.Web.HttpContext.Current.Session["TrapString"] = System.Web.HttpContext.Current.Session["TrapString"] + StringEvent;
                    System.Web.HttpContext.Current.Session["EventString"] = System.Web.HttpContext.Current.Session["EventString"] + StringEvent;
                }
                else if (Convert.ToInt32(System.Web.HttpContext.Current.Session["EventCount"]) > int.Parse(System.Configuration.ConfigurationSettings.AppSettings["CountEvent"].ToString()))
                {
                    int x = System.Web.HttpContext.Current.Session["EventString"].ToString().IndexOf("#|");
                    System.Web.HttpContext.Current.Session["EventString"] = System.Web.HttpContext.Current.Session["EventString"].ToString().Substring(x + 2);
                    System.Web.HttpContext.Current.Session["EventString"] = System.Web.HttpContext.Current.Session["EventString"] + StringEvent;
                    System.Web.HttpContext.Current.Session["EventCount"] = Convert.ToInt32(System.Web.HttpContext.Current.Session["EventCount"]) - 1;
                }

                //// Following Block of code added by Piyush on 9th Dec 2007, so as to write each an every method call to the text file when the Some key is set to Y in Web config file 
                //try
                //{
                //    if (System.Configuration.ConfigurationSettings.AppSettings["VerboseMethodCallLogToTextfile"].ToString() == "Y" || System.Configuration.ConfigurationSettings.AppSettings["VerboseMethodCallLogToTextfile"].ToString() == "y")
                //    {
                //        TextWriter ObjectTextWrite = new StreamWriter(System.Web.HttpContext.Current.Server.MapPath(@"~/MethodLog_" + System.Web.HttpContext.Current.Session.SessionID + "_" + Streamline.ProviderAccessBaseLibrary.BaseCommonFunctions.Singleton.Instance.UserCode + ".txt"), true);
                //        if (KeyParameters == "")
                //            ObjectTextWrite.WriteLine("\r\n Screen Name - " + System.Web.HttpContext.Current.Session["CurrentPage"].ToString() + " ### Method Name - " + MethodName + " ### Key Parameters - None");
                //        else if (KeyParameters.IndexOf("^") > 0)// as KepParameters if are more than one in no. then they contain "^" sign which will now be replaced with ", " to distinguish between two parameters
                //        {
                //            string ManipulatedKeyParameters = "";
                //            ManipulatedKeyParameters = KeyParameters.Replace("^", ", ");
                //            ObjectTextWrite.WriteLine("\r\n Screen Name - " + System.Web.HttpContext.Current.Session["CurrentPage"].ToString() + " ### Method Name - " + MethodName + " ### Key Parameters - " + ManipulatedKeyParameters);
                //        }
                //        else
                //            ObjectTextWrite.WriteLine("Screen Name - " + System.Web.HttpContext.Current.Session["CurrentPage"].ToString() + " ### Method Name - " + MethodName + " ### Key Parameters - " + KeyParameters);
                //        ObjectTextWrite.Close();
                //        ObjectTextWrite.Dispose();
                //    }
                //}
                //catch (Exception excep)
                //{
                //    excep.Message.ToString();
                //}
                // code addition ends here by Piyush on 9th Dec 2007, so as to write each an every method call to the text file when the Some key is set to Y in Web config file 
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
                //string RemaningString;
                StringBuilder XmlEventString = new StringBuilder();
                int x;
                EventString = System.Web.HttpContext.Current.Session["EventString"].ToString();
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
        /// 
        /// </summary>
        /// <param name="fileName"></param>
        /// <returns></returns>
        //public static bool SaveQueue(string fileName)
        //{
        //    try
        //    {
        //        // TODO: Implement Method - LogManager.SaveQueue()

        //        string path = "";

        //        // to be replaced with data table of queue
        //        System.Data.DataTable dt = null;

        //        path = System.Configuration.ConfigurationSettings.AppSettings["XmlLogPath"];

        //        if (!System.IO.Directory.Exists(path))
        //        {
        //            System.IO.Directory.CreateDirectory(path);
        //        }

        //        if (!path.EndsWith("\\"))
        //        {
        //            path = path + "\\";
        //        }

        //        System.Data.DataSet ds = new System.Data.DataSet();

        //        ds.Tables.Add(dt);

        //        ds.WriteXml(path + fileName, System.Data.XmlWriteMode.IgnoreSchema);

        //        ds.Dispose();

        //        return true;
        //    }
        //    catch (Exception ex)
        //    {

        //        throw;
        //    }
        //}
    }
}


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

namespace Streamline.BaseLayer
{
    /// <summary>
    /// Summary description for LogManager
    /// </summary>
    public class LogManager
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

        private LoggingLevel _AuditLogLevel;

        private LoggingLevel _AuditQueueLevel;

        public LoggingLevel AuditLogLevel
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
        public LoggingLevel AuditQueueLevel
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
        //public bool LogMessage(string message,
        public void LogMessage(string message, LoggingCategory category, LoggingLevel level)
        {
            // TODO: Implement Method - LogManager.LogMessage()
            DataSet objds = new DataSet();
            if (_AuditLogLevel == level || _AuditLogLevel < level)
            {

                //				LogEntry logEntry	= new LogEntry();
                //				logEntry.Message	= message;
                //				logEntry.Category = System.Convert.ToString(category);
                //				Logger.Write(logEntry);

                //
                //				MSDE obj = new MSDE();
                //				obj.InsertIntoLog(logEntry);


                //				
                //				obj.InsertIntoLog(dsMgr);
            }

            //			if(_AuditQueueLevel == level  || _AuditQueueLevel < level)
            //			{
            //				//Circular queue;
            //			}

            //return true;
        }

        /// <summary>
        /// This Method will log Exception and Display Error message to the user
        /// </summary>
        /// <param name="ex">ex Object, containing Exception Information</param>
        /// <param name="category">Category- General</param>
        /// <param name="level">Logging Level- error, Warning or Information</param>
        /// <returns>bool value- True/False</returns>
        /// <ModifiedBy>Piyush</ModifiedBy>
        /// <ModifiedOn>2nd August 2007</ModifiedOn>
        public static bool LogException(System.Exception ex, LoggingCategory category, LoggingLevel level)
        {
            BaseActivityPage ObjectActivityPage = null;
            try
            {
                ExceptionManager.Publish(ex);
                // Following line of code added by Piyush on 2nd August 2007, so as to check Concurrency and SQl Exception and display the Exception to the user
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
                // Addition ends here by Piyush on 2nd August 2007, so as to check Concurrency and SQl Exception and display the Exception to the user
            }
            catch
            {
                string str = ex.Message.ToString();
                //if (MessageBox.Show("Event Log is full Press Yes if you want to clear event log", "Streamline.ProviderClaim", MessageBoxButtons.YesNo, MessageBoxIcon.Information) == DialogResult.Yes)
                //{
                //    System.Diagnostics.EventLog objLog = new System.Diagnostics.EventLog("Application");
                //    objLog.Clear();
                //    ExceptionManager.Publish(ex);

                //}
            }
            finally
            {
                ObjectActivityPage = null;
            }




            //			string message="";
            //
            //			message = "Error Message: " + ex.Message + "\n";
            //			message += "Source of Error: " + ex.Source + "\n";
            //			message += "Stack Trace: " +  ex.StackTrace;
            //
            //			// TODO: Implement Method - LogManager.LogMessage()
            //			if(_AuditLogLevel == level  || _AuditLogLevel < level)
            //			{
            //				LogEntry logEntry	= new LogEntry();
            //				logEntry.Message	= "Starting up the application";
            //				logEntry.Category = System.Convert.ToString(category);
            //				Logger.Write(message,System.Convert.ToString(category));
            //
            ////				MSDE obj = new MSDE();
            ////				obj.InsertIntoLog(logEntry);
            //			}
            //			
            //			if(_AuditQueueLevel == level  || _AuditQueueLevel < level)
            //			{
            //				//Circular queue;
            //				
            //			}            
            return true;

        }

        /// <summary>
        /// This Method will log Exception and Display Error message to the user
        /// </summary>
        /// <param name="ex">ex Object, containing Exception Information</param>
        /// <param name="category">Category- General</param>
        /// <param name="level">Logging Level- error, Warning or Information</param>
        /// <returns>bool value- True/False</returns>
        /// <CreatedBy>Piyush</CreatedBy>
        /// <CreatedOn>2nd August 2007</CreatedOn>
        public static bool LogException(System.Exception ex, LoggingCategory category, LoggingLevel level, Control Ctrl)
        {
            BaseActivityPage ObjectActivityPage = null;
            try
            {
                
                
                if (ex.GetType().FullName != "System.Threading.ThreadAbortException")
                {
                    ExceptionManager.Publish(ex);
                }
                //ExceptionManager.Publish(ex);
                // Following line of code added by Piyush on 2nd August 2007, so as to check Concurrency and SQl Exception and display the Exception to the user
                ObjectActivityPage = new BaseActivityPage();
                string ParseMessage = ex.Message;

                // Code Added by Piyush on 6th September 2007 so as to check error number emerged in case of business rule voilation
                string ErrorNumber = "";
                if (ParseMessage.IndexOf("*****") > 0)
                {
                    ErrorNumber = ParseMessage.Substring(0, ParseMessage.IndexOf("*****"));
                    Int32 Index = ParseMessage.IndexOf("*****") + 5;
                    ParseMessage = ParseMessage.Substring(Index);
                    ParseMessage = ParseMessage.Substring(0,ParseMessage.IndexOf("*****"));
                    ObjectActivityPage.ShowError(ParseMessage, true, Ctrl);
                }
                // Code Addition ends here by Piyush on 6th September 2007 so as to check error number emerged in case of business rule voilation
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
                    // Addition ends here by Piyush on 2nd August 2007, so as to check Concurrency and SQl Exception and display the Exception to the user
                }
            }
            catch
            {
                string str = ex.Message.ToString();
            }
            finally
            {
                ObjectActivityPage = null;
            }           
            return true;
        }


        public bool LogException(System.Exception ex, LoggingCategory category, LoggingLevel level, string VerboseMode)
        {
            //ex.Source = VerboseMode;
            ex.Data["CustomExceptionInformation"] = VerboseMode;
            ExceptionManager.Publish(ex);
            return true;
        }
        public bool SaveQueue(string fileName)
        {
            // TODO: Implement Method - LogManager.SaveQueue()

            string path = "";

            // to be replaced with data table of queue
            System.Data.DataTable dt = null;

            path = System.Configuration.ConfigurationSettings.AppSettings["XmlLogPath"];

            if (!System.IO.Directory.Exists(path))
            {
                System.IO.Directory.CreateDirectory(path);
            }

            if (!path.EndsWith("\\"))
            {
                path = path + "\\";
            }

            System.Data.DataSet ds = new System.Data.DataSet();

            ds.Tables.Add(dt);

            ds.WriteXml(path + fileName, System.Data.XmlWriteMode.IgnoreSchema);

            ds.Dispose();

            return true;
        }
    }
}

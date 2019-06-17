using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Streamline.UserBusinessServices;
using System.Data;

/// <summary>
/// Holds the system configurations properties
/// </summary>
public class SystemConfigurations
{
    private static SystemConfigurations systemConfigurations = null;
    
    public string ReportFolder { get; set; }
    public string ReportServerDomain { get; set; }
    public string ReportServerUserName { get; set; }
    public string ReportServerPassword { get; set; }
    public string ReportURL { get; set; }

    public SystemConfigurations() { }

    public static SystemConfigurations GetInstance()
    {
        if (systemConfigurations == null)
        {
            systemConfigurations = new SystemConfigurations();
            //ApplicationCommonFunctions applicationCommonFunctions = new ApplicationCommonFunctions();
            //DataSet ds = applicationCommonFunctions.GetSystemConfigurations();
            //if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            //{
                //systemConfigurations.ReportFolder = ds.Tables[0].Rows[0]["ReportFolderName"].ToString();
                //systemConfigurations.ReportServerDomain = ds.Tables[0].Rows[0]["ReportServerDomain"].ToString();
                //systemConfigurations.ReportServerUserName = ds.Tables[0].Rows[0]["ReportServerUserName"].ToString();
                //systemConfigurations.ReportServerPassword = ds.Tables[0].Rows[0]["ReportServerPassword"].ToString();
                //systemConfigurations.ReportURL = ds.Tables[0].Rows[0]["ReportURL"].ToString();
            //}
            //else
            //{
                systemConfigurations.ReportFolder = System.Configuration.ConfigurationManager.AppSettings["ReportFolderName"];
                systemConfigurations.ReportServerDomain = System.Configuration.ConfigurationManager.AppSettings["ReportServerDomain"];
                systemConfigurations.ReportServerUserName = System.Configuration.ConfigurationManager.AppSettings["ReportServerUserName"];
                systemConfigurations.ReportServerPassword = System.Configuration.ConfigurationManager.AppSettings["ReportServerPassword"];
                systemConfigurations.ReportURL = System.Configuration.ConfigurationManager.AppSettings["ReportURL"];
            //}
        }

        return systemConfigurations;

    }
    
}
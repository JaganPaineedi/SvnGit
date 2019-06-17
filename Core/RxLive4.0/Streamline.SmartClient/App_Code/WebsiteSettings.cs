using System;
using System.Data;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using Streamline.UserBusinessServices;

/// <summary>
/// Summary description for WebsiteSettings
/// </summary>
public class WebsiteSettings
{
    public static string BaseUrl
    {
        get
        {
            string Port = System.Web.HttpContext.Current.Request.ServerVariables["SERVER_PORT"];
            if (Port == null || Port == "80" || Port == "443")
                Port = string.Empty;
            else
                Port = string.Format("{0}{1}", ":", Port);
            string Protocol = System.Web.HttpContext.Current.Request.IsSecureConnection ? "https://" : "http://";

            string p = string.Format("{0}{1}{2}{3}", Protocol, System.Web.HttpContext.Current.Request.ServerVariables["SERVER_NAME"], Port, System.Web.HttpContext.Current.Request.ApplicationPath);

            p = p.Trim();
            if (!p.EndsWith("/"))
                p = string.Format("{0}{1}", p, "/");
            return p;
        }
    }
    /// <summary>
    /// Return current session size in Byte
    /// </summary>
    public static long CurrentSessionSize
    {
        get
        {

            long totalSessionBytes = 0;
            System.Runtime.Serialization.Formatters.Binary.BinaryFormatter b = new System.Runtime.Serialization.Formatters.Binary.BinaryFormatter();
            System.IO.MemoryStream m = null;
            try
            {
                for (int i = 0; i < HttpContext.Current.Session.Count; i++)
                {
                    m = new System.IO.MemoryStream();
                    if (HttpContext.Current.Session[i] != null)
                    {
                        b.Serialize(m, HttpContext.Current.Session[i]);

                        totalSessionBytes += m.Length;
                    }
                }
            }
            finally
            {
                if (m != null) m.Dispose();
                b = null;
            }
            return totalSessionBytes;

        }

    }

    //public static ReportServerSetting ReportServerSettings
    //{
    //    get
    //    {
    //        return ReportServerSetting.GetInstance();
    //    }
    //}

}


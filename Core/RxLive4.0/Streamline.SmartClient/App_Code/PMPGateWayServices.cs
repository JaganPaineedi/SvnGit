using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Xml.Serialization;
using Newtonsoft.Json;
using System.Net;
using System.IO;
using System.Text;
using System.Security.Cryptography;
using System.Security.Cryptography.X509Certificates;
using System.Xml.Linq;
using Streamline.DataService;
using Streamline.UserBusinessServices;



/// <summary>
/// Summary description for PMPGateWayServices
/// </summary>
public class PMPGateWayServices
{
    public PMPGateWayServices()
    {
        System.Net.ServicePointManager.CertificatePolicy = new MyPolicy();
    }



    public string GetNarxInformation(string PMPWebServiceURL,string PMPWebServiceUname, string PMPWebServicePassword, string RequestXML, string OrganizationCode, string RequestName, string ReportEndPointURL)
    {
        string response = string.Empty;
        try
        {
            if (PMPWebServiceURL != "")
            {
                Uri url = new Uri(PMPWebServiceURL);

                byte[] bytes = System.Text.Encoding.ASCII.GetBytes(JsonConvert.SerializeObject(new PMPRequest
                {
                    OrganizationCode = OrganizationCode,
                    RequestData = RequestXML,
                    RequestName = RequestName,
                    ReportEndPointURL = ReportEndPointURL

                }));

                HttpWebRequest requestResponse = (HttpWebRequest)WebRequest.Create(url.AbsoluteUri);
                requestResponse.Method = "POST";
                requestResponse.ContentType = "application/json";
                requestResponse.ContentLength = bytes.Length;

                Stream rs = requestResponse.GetRequestStream();
                rs.Write(bytes, 0, bytes.Length);
                rs.Close();

                HttpWebResponse resp = (HttpWebResponse)requestResponse.GetResponse();
                Stream respStream = resp.GetResponseStream();
                StreamReader sr = new StreamReader(respStream, Encoding.UTF8);

                response = sr.ReadToEnd();

                sr.Close();
                respStream.Close();
             
            }
        }
        catch (Exception ex)
        { }

         return response;
    }




    public static DateTime UnixTimeStampToDateTime(double unixTimeStamp)
    {
        // Unix timestamp is seconds past epoch
        System.DateTime dtDateTime = new DateTime(1970, 1, 1, 0, 0, 0, 0, System.DateTimeKind.Utc);
        dtDateTime = dtDateTime.AddSeconds(unixTimeStamp).ToLocalTime();
        return dtDateTime;
    }

    //"UTC does not change with a change of seasons, but local time or civil time may change if a time zone jurisdiction observes 
    //daylight saving time (summer time). For example, UTC is 5 hours ahead of (that is, later in the day than) 
    //local time on the east coast of the United States during winter, but 4 hours ahead while daylight saving is observed there."
    

    public string TestComputeHash(string test)
    {
        var buffer = Encoding.UTF8.GetBytes(test);
        var hashAlgorithm = new SHA256Managed();
        var hash = hashAlgorithm.ComputeHash(buffer);
        return HexStringFromBytes(hash);
    }

    public static string HexStringFromBytes(byte[] bytes)
    {
        var sb = new StringBuilder();
        foreach (byte b in bytes)
        {
            var hex = b.ToString("x2");
            sb.Append(hex);
        }
        return sb.ToString();
    }

}



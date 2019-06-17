using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Net;
using System.Net.Http;
using System.Net.Sockets;
using System.Text;
using System.Threading.Tasks;
using System.Web;

namespace SC.WebApp
{
    public static class dataservice
    {
        #region Variables
        static string templateFileName = string.Empty;
        static string templateLocation = string.Empty;
        static string customLocation = string.Empty;
        static bool IsCacheListModified = false;
        static List<string> cachefilelist = new List<string>();
        static string appLocation = string.Empty;
        static HttpClient client = new HttpClient();
        #endregion


        public static string Connection { get { return ConfigurationManager.AppSettings["Connection"].ToString(); } }

        public static DataSet GetDFAInformation()
        {
            DataSet ds = new DataSet();

            SqlConnection conn = new SqlConnection(Connection);

            SqlCommand cmd = new SqlCommand("smsp_GetDFAFormInformations", conn);

            cmd.CommandType = CommandType.StoredProcedure;

            SqlDataAdapter adapt = new SqlDataAdapter(cmd);

            adapt.TableMappings.Add("Table", "DFAInformation");
            adapt.TableMappings.Add("Table1", "WebFarm");

            adapt.Fill(ds);
            return ds;
        }

        public async static Task<bool> UpdateCacheListJson(HttpRequest request = null)
        {
            DataSet data = GetDFAInformation();

            if (request != null)
            {
                string myIP = string.Empty;

                var host = Dns.GetHostEntry(Dns.GetHostName());
                foreach (var ip in host.AddressList)
                {
                    if (ip.AddressFamily == AddressFamily.InterNetwork)
                    {
                        myIP = ip.ToString();
                    }
                }

                foreach (DataRow row in data.Tables["WebFarm"].Rows)
                {
                    if (row["Ip"] != DBNull.Value && row["Ip"].ToString() != myIP)
                    {
                        string Url = "http://" + row["Ip"] + "/" + row["InstanceName"] + request.RawUrl;
                        HttpResponseMessage response = await client.GetAsync(Url);
                    }
                }
            }
            appLocation = HttpRuntime.AppDomainAppPath;
            customLocation = "app/views/custom";

            Directory.CreateDirectory(appLocation + customLocation);

            if (data != null && data.Tables.Contains("DFAInformation"))
            {
                #region Create list of lines from cache list
                using (StreamReader r = new StreamReader(appLocation + "files-to-cache.json"))
                {
                    string json = r.ReadToEnd();
                    cachefilelist = JsonConvert.DeserializeObject<List<string>>(json);
                }
                #endregion

                foreach (DataRow row in data.Tables["DFAInformation"].Rows)
                {
                    #region Decide FileName and Template Location
                    if (row["DocumentCodeId"] != DBNull.Value && row["MobileFormHTML"] != DBNull.Value
                            && row["TableName"] != DBNull.Value && row["IsCustomService"] != DBNull.Value
                            && row["IsCustomService"].ToString().Trim() == "N")
                    {
                        templateFileName = "document_" + row["DocumentCodeId"].ToString() + ".html";
                        templateLocation = "app/views/custom/document/";
                        Directory.CreateDirectory(appLocation + templateLocation);
                    }
                    else if (row["MobileFormHTML"] != DBNull.Value
                            && row["TableName"] != DBNull.Value && row["IsCustomService"] != DBNull.Value
                            && row["IsCustomService"].ToString().Trim() == "Y")
                    {
                        templateFileName = "customservices.html";
                        templateLocation = "app/views/custom/customfield/";
                        Directory.CreateDirectory(appLocation + templateLocation);
                    }
                    #endregion

                    #region Insert File location in cache file list

                    if (!cachefilelist.Exists(a => a == templateLocation + templateFileName))
                    {
                        IsCacheListModified = true;
                        cachefilelist.Insert(cachefilelist.Count, templateLocation + templateFileName);
                    }

                    #endregion

                    #region Create DFA template HTML File
                    if (File.Exists(appLocation + templateLocation + templateFileName))
                    {
                        if (File.ReadAllText(appLocation + templateLocation + templateFileName).Trim() != row["MobileFormHTML"].ToString().Trim())
                        {
                            File.Delete(appLocation + templateLocation + templateFileName);
                        }
                    }



                    using (FileStream stream = File.Create(appLocation + templateLocation + templateFileName))
                    {
                        Byte[] info = new UTF8Encoding(true).GetBytes(row["MobileFormHTML"].ToString());

                        stream.Write(info, 0, info.Length);

                        IsCacheListModified = true;
                    }
                    #endregion

                    #region Modify cache list file
                    if (IsCacheListModified)
                    {
                        string output = Newtonsoft.Json.JsonConvert.SerializeObject(cachefilelist, Newtonsoft.Json.Formatting.Indented);
                        File.WriteAllText(appLocation + "files-to-cache.json", output);

                    }
                    #endregion

                }
            }

            return IsCacheListModified;
        }
    }
}
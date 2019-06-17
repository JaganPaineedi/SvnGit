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
using System.Security.Cryptography.X509Certificates;
using System.Xml.Linq;

/// <summary>
/// Summary description for SureScriptsServices
/// </summary>
public class SureScriptsServices
{
    public SureScriptsServices()
    {
        System.Net.ServicePointManager.CertificatePolicy = new MyPolicy();
    }

    public string GetFormularyInformation(string ExternalMedicationNameId, string ExternalMedicationId, string CoverageReqId, string Message)
    {
        try
        {
            XDocument xml = XDocument.Parse(Message.Replace("&", "&amp;"));
            if (xml.Element("FormularyRequest") != null  && System.Configuration.ConfigurationSettings.AppSettings["FormularyWebServiceURL"] != null) {

                if (xml.Element("FormularyRequest").Element("ExternalMedicationNameId") != null && ExternalMedicationNameId != "")
                {
                    xml.Element("FormularyRequest").Element("ExternalMedicationNameId").Value = ExternalMedicationNameId;
                }

                // Changed by Jason Steczynski on 4/23/15, include ExternalMedicationId even if ExternalMedicationNameId is known
                // Note: this is needed to identify the requested strength and form of medication
                if (xml.Element("FormularyRequest").Element("ExternalMedicationId") != null && ExternalMedicationId != "")
                {
                    xml.Element("FormularyRequest").Element("ExternalMedicationId").Value = ExternalMedicationId;
                }


                DataSet coverages = new DataSet();
                StringReader srxml = new StringReader(xml.ToString());
                coverages.ReadXml(srxml);

                if (!CoverageReqId.IsNullOrWhiteSpace())
                {
                    DataRow[] dr = coverages.Tables["Coverage"].Select("COVERAGE_REQ_ID <> '" + CoverageReqId + "'");
                    foreach (DataRow cov in dr)
                    {
                        cov.Delete();
                    }
                }

                Uri url = new Uri(System.Configuration.ConfigurationSettings.AppSettings["FormularyWebServiceURL"].ToString());
                var message = JsonConvert.SerializeObject(new FormularyRequest()
                    {
                        EligibilityData = coverages.GetXml()
                    });
                byte[] bytes = System.Text.Encoding.ASCII.GetBytes(message);
                HttpWebRequest requestResponse = (HttpWebRequest)WebRequest.Create(url.AbsoluteUri);
                requestResponse.Method = "POST";
                requestResponse.ContentType = "application/json";
                requestResponse.ContentLength = bytes.Length;
                requestResponse.Timeout = 60000;
                Stream rs = requestResponse.GetRequestStream();
                rs.Write(bytes, 0, bytes.Length);
                rs.Close();

                HttpWebResponse resp = (HttpWebResponse)requestResponse.GetResponse();
                Stream respStream = resp.GetResponseStream();
                StreamReader sr = new StreamReader(respStream, Encoding.UTF8);

                string response = sr.ReadToEnd();

                sr.Close();
                respStream.Close();

                return response;
            }
            else
            {
                return "";
            }
        }
        catch (Exception ex)
        {
            return "";
        }

    }



    public PrescriberReturning RegisterPrescriberInformation(string prescriberURL, string StaffId, string SurescriptsOrganizationId,
                                                 string OrganizationName, string ActiveStartTime, string ActiveEndTime,
                                                 string DEANumber, string NPI, string LastName, string FirstName,
                                                 string MiddleName, string NamePrefix, string SpecialtyCode, string ServiceLevel, string City,
                                                 string State, string Zip, string Address, string PhoneNumber,
                                                 string FaxNumber, string Email, string SPI_Id)
    {
        var message = JsonConvert.SerializeObject(new PrescriberOutgoing()
            {
                StaffId = StaffId,
                SurescriptsOrganizationId = SurescriptsOrganizationId,
                OrganizationName = OrganizationName,
                ActiveStartTime = ActiveStartTime,
                ActiveEndTime = ActiveEndTime,
                DEANumber = DEANumber,
                NPI = NPI,
                LastName = LastName,
                FirstName = FirstName,
                MiddleName = MiddleName,
                NamePrefix = NamePrefix,
                SpecialtyCode = SpecialtyCode,
                ServiceLevel = ServiceLevel,
                City = City,
                State = State,
                Zip = Zip,
                Address = Address,
                PhoneNumber = PhoneNumber,
                FaxNumber = FaxNumber,
                Email = Email,
                SPI_Id = SPI_Id
            });

        Uri url = new Uri(prescriberURL);
        byte[] bytes = System.Text.Encoding.ASCII.GetBytes(message);
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

        string response = sr.ReadToEnd();

        sr.Close();
        respStream.Close();

        return JsonConvert.DeserializeObject<PrescriberReturning>(response);
    }

    internal class PrescriberOutgoing
    {
        public string StaffId { get; set; }
        public string SurescriptsOrganizationId { get; set; }
        public string OrganizationName { get; set; }
        public string ActiveStartTime { get; set; }
        public string ActiveEndTime { get; set; }
        public string DEANumber { get; set; }
        public string NPI { get; set; }
        public string LastName { get; set; }
        public string FirstName { get; set; }
        public string MiddleName { get; set; }
        public string NamePrefix { get; set; }
        public string SpecialtyCode { get; set; }
        public string ServiceLevel { get; set; }
        public string City { get; set; }
        public string State { get; set; }
        public string Zip { get; set; }
        public string Address { get; set; }
        public string PhoneNumber { get; set; }
        public string FaxNumber { get; set; }
        public string Email { get; set; }
        public string SPI_Id { get; set; }
    }

    internal class FormularyRequest
    {
        public string EligibilityData { get; set; }
    }
}

public class PrescriberReturning
{
    public string StaffId { get; set; }
    public string Status { get; set; }
    /// <summary>
    /// Full SPI + Location Id
    /// </summary>
    public string SPI_Id { get; set; }
    public bool Valid { get; set; }
    public string ErrorText { get; set; }
    /// <summary>
    /// SPI from SPI_ID
    /// </summary>
    public string SPI
    {
        get
        {
            if (SPI_Id.Length >= 10)
                return SPI_Id.Substring(0, 10);
            else
                return SPI_Id;
        }
    }
    /// <summary>
    /// Location Id from SPI_ID
    /// </summary>
    public string LocationId
    {
        get
        {
            if (SPI_Id.Length > 10)
                return SPI_Id.Substring(10);
            else
                return "";
        }
    }
}

public class MyPolicy : ICertificatePolicy
{
    public bool CheckValidationResult(ServicePoint srvPoint,
      X509Certificate certificate, WebRequest request,
      int certificateProblem)
    {
        //Return True to force the certificate to be accepted.
        return true;
    }
}
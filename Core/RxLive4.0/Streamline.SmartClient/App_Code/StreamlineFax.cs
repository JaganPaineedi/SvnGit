using System;
using System.Web;
using System.Web.Services;
using System.Xml;
using System.Web.Services.Protocols;
using System.Web.Script.Services;
using System.Data;
using Streamline.BaseLayer;
using Streamline.UserBusinessServices;
using System.Configuration;
using System.Collections;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Text;
using System.IO;
using Microsoft.Reporting.WebForms;
using System.Collections.Generic;
using Zetafax;
using ZfLib;
using Zetafax.Common;
using FAXCOMLib;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading.Tasks;

namespace Streamline.Faxing
{
    public class StreamlineFax
    {
        enum FAXSERVRES { none, faxcom, zetafax, rightfax };
        public StreamlineFax()
        {

        }

        private string SendToFaxCom(string _pharmacyName, string _faxNumber, string _scriptFilePath, string _subject)
        {
            string output = "false";
            ResultMessage result = null;
            LOGINTYPE faxcomlogintype = LOGINTYPE.USERCONFLOGIN;
            PRIORITY faxcompriority = PRIORITY.HIGH;
            RESOLUTION faxresolution = RESOLUTION.HIRES;

            //Set configuration
            string faxcomserver = System.Configuration.ConfigurationSettings.AppSettings["FaxcomQueuePath"];
            string faxcomuser = System.Configuration.ConfigurationSettings.AppSettings["FaxcomUser"];
            string faxcompasswd = System.Configuration.ConfigurationSettings.AppSettings["FaxcomPasswd"];
            string temppath = System.Configuration.ConfigurationSettings.AppSettings["TempPath"];

            try
            {

                using (fcapi FCAPI = new fcapi())
                {
                    //Try to connect to server
                    result = FCAPI.LogOn(faxcomlogintype, faxcomserver, faxcomuser, faxcompasswd);
                    if (result.Result == true)
                    {
                        //Login successful
                        FaxMessage faxmessage = FCAPI.NewFaxMessage();
                        if (faxmessage != null)
                        {
                            //Set the sender info
                            faxmessage.FaxSender = FCAPI.Sender;
                            //Create blank recipient
                            FAXCOMLib.Recipient recipient = faxmessage.FaxRecipients.Add(0);
                            //Valid recipient fax number
                            recipient.FaxNumber = _faxNumber;
                            faxmessage.Subject = _subject;
                            //Message priority
                            faxmessage.Priority = faxcompriority;
                            //Message Resolution
                            faxmessage.Resolution = faxresolution;
                            //No Coverpage
                            faxmessage.Coverpage = "(none)";
                            FAXCOMLib.Attachments attachment = faxmessage.Attachments;
                            attachment.Add(_scriptFilePath, false);

                            //Send Now
                            faxmessage.SendTime = "0.0";
                            //Try to send fax message
                            try
                            {
                                faxmessage.SubmitFax();
                            }
                            catch (Exception ex)
                            {
                                throw new Exception("Failed to submit fax. " + ex.Message);
                            }
                        }
                    }
                    else
                    {
                        throw new Exception("Faxcom server login failed.");
                    }
                }
            }
            catch (Exception ex)
            {
                return "false";
            }

            return "true";
        }

        private string SendToZetaFax(string _pharmacyName, string _faxNumber, string _scriptFilePath, string _subject)
        {
            ZfLib.NewMessage _newMessage = null;
            ZfLib.UserSession _userSession = null;
            ZfLib.ZfAPIClass _zfAPI;
            string _zetaFaxUserName = System.Configuration.ConfigurationSettings.AppSettings["ZetaFaxUserName"];
            _zfAPI = new ZfLib.ZfAPIClass();
            if (ZetafaxConfiguration.ZetafaxServer != String.Empty)
            {
                _zfAPI.SetZetafaxDirs(ZetafaxConfiguration.ZetafaxServer,
                        ZetafaxConfiguration.ZetafaxSystem,
                        ZetafaxConfiguration.ZetafaxUsers,
                        ZetafaxConfiguration.ZetafaxRequest);
            }
            _zfAPI.Escape("APPLICATION", 0x1057);    // don't check for an API licence
            _zfAPI.AutoTempDirectory = true;			// use \zfax\users\<user> for temp directory
            _zfAPI.EnableImpersonation = ZetafaxConfiguration.APIImpersonation;
            try
            {
                if (_zfAPI != null)
                {
                    _userSession = _zfAPI.Logon(_zetaFaxUserName, false);
                    _newMessage = _userSession.CreateNewMsg();
                    _newMessage.Recipients.AddFaxRecipient(_pharmacyName, _pharmacyName, _faxNumber);
                    _newMessage.Subject = _subject;
                    _newMessage.Priority = ZfLib.PriorityEnum.zfPriorityUrgent;
                    _newMessage.Files.Add(_scriptFilePath);
                    _newMessage.Send();
                }
                if (_newMessage.Body != "")
                    return _newMessage.Body;

                return "false";
            }
            catch (System.Runtime.InteropServices.COMException ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                {
                    ex.Data["CustomExceptionInformation"] = "Source function SendToFax()";
                }
                else
                {
                    ex.Data["CustomExceptionInformation"] = "";
                }
                if (ex.Data["DatasetInfo"] == null)
                {
                    ex.Data["DatasetInfo"] = null;
                }
                return "false";
            }
        }
        public string SendFax(int _pharmacyId, int _clientId, string _scriptFilePath, string _subject)
        {
            Streamline.UserBusinessServices.SharedTables objectSharedTables = new Streamline.UserBusinessServices.SharedTables();
            DataSet DataSetPharmacies = objectSharedTables.getPharmacies(_clientId);
            DataRow[] drPharmacies = DataSetPharmacies.Tables[0].Select("PharmacyId=" + _pharmacyId);
            string _pharmacyName = "";
            string _faxNumber = "";
            if (drPharmacies.Length > 0)
            {
                _pharmacyName = drPharmacies[0]["PharmacyName"].ToString();
                _faxNumber = drPharmacies[0]["FaxNumber"].ToString();
            }
            FAXSERVRES _faxserver = FAXSERVRES.none;
            switch (System.Configuration.ConfigurationSettings.AppSettings["FaxServer"])
            {
                case "faxcom":
                    _faxserver = FAXSERVRES.faxcom;
                    break;
                case "zetafax":
                    _faxserver = FAXSERVRES.zetafax;
                    break;
                case "RightFax":
                    _faxserver = FAXSERVRES.rightfax;
                    break;
                default:
                    _faxserver = FAXSERVRES.faxcom;
                    break;
            }
            if (_faxserver == FAXSERVRES.faxcom)
            {
                return SendToFaxCom(_pharmacyName, _faxNumber, _scriptFilePath, _subject);
            }
            else if (_faxserver == FAXSERVRES.zetafax)
            {
                return SendToZetaFax(_pharmacyName, _faxNumber, _scriptFilePath, _subject);
            }
            else if (_faxserver == FAXSERVRES.rightfax)
            {
                SendToRightFaxAsync(_pharmacyName, _faxNumber, _scriptFilePath, _subject);
                return "true";
            }
            else
            {
                return "false";
            }
        }

        static async Task<Uri> UploadAttachment(HttpClient client, FileInfo file)
        {
            // Upload the file using standard multipart form data.
            var content = new MultipartFormDataContent();
            var streamContent = new StreamContent(file.OpenRead(), 16384);
            streamContent.Headers.ContentType = new MediaTypeHeaderValue("application/binary");
            content.Add(streamContent, file.Name, file.Name);

            // POST the data; the response's location header will be the URL of the uploaded file
            var response = await client.PostAsync("Attachments", content);
            response.EnsureSuccessStatusCode();
            //System.Windows.Forms.MessageBox.Show(response.ToString());
            return response.Headers.Location;
        }

        private async Task SendToRightFaxAsync(string pharmacyName, string faxNumber, string scriptFilePath, string subject)
        {
            HttpClient client = new HttpClient();
            //Set configuration
            string rightfaxAPIURL = System.Configuration.ConfigurationSettings.AppSettings["rightfaxAPIURL"];
            string rightfaxuser = System.Configuration.ConfigurationSettings.AppSettings["rightfaxuser"];
            string rightfaxpasswd = System.Configuration.ConfigurationSettings.AppSettings["rightfaxpasswd"];
            string temppath = System.Configuration.ConfigurationSettings.AppSettings["TempPath"];

            client.BaseAddress = new Uri(rightfaxAPIURL);
            var byteArray = Encoding.ASCII.GetBytes(rightfaxuser + ":" + rightfaxpasswd);
            client.DefaultRequestHeaders.Accept.Clear();
            client.DefaultRequestHeaders.Accept.Add(
                new MediaTypeWithQualityHeaderValue("application/json"));
            client.DefaultRequestHeaders.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue("Basic", Convert.ToBase64String(byteArray));

            try
            {
                //Upload attachment and get the generated URL location for the attachment
                Uri resultAttachmentURI = await UploadAttachment(client, new System.IO.FileInfo(scriptFilePath));
                RFAttachmentUrl oRFAttachmentURL = new RFAttachmentUrl
                {
                    AttachmentUrl = resultAttachmentURI.ToString()
                };


                // Create a new recipient
                RFRecipient oRecipient = new RFRecipient
                {
                    Name = pharmacyName,
                    Destination = faxNumber
                };

                // Create a new fax
                SendJobRequest oSendJobRequest = new SendJobRequest
                {
                    UserID = rightfaxuser,
                    HoldForPreview = "true",
                    Priority = "High",
                    Resolution = "Fine",
                    CoversheetTemplateId = "1",
                    SendAfter = DateTime.Now.ToString(), //UTC time
                    Recipients = new List<RFRecipient> { oRecipient },
                    Attachments = new List<RFAttachmentUrl> { oRFAttachmentURL }
                };

                var url = await SubmitJobAsync(oSendJobRequest);

            }
            catch (Exception e)
            {
                throw new Exception("Failed to submit fax. " + e.Message);
            }
        }

        static async Task<Uri> SubmitJobAsync(SendJobRequest oSendJobRequest)
        {
            HttpClient client = new HttpClient();
            HttpResponseMessage response = await client.PostAsJsonAsync("SendJobs", oSendJobRequest);
            response.EnsureSuccessStatusCode();
            //System.Windows.Forms.MessageBox.Show(response.ToString());
            return response.Headers.Location;
        }
    }


    //SendJobs class
    public class SendJobRequest
    {
        public string UserID { get; set; }
        public string HoldForPreview { get; set; }
        public string Priority { get; set; }
        public string Resolution { get; set; }
        public string CoversheetTemplateId { get; set; }
        public string SendAfter { get; set; }
        public List<RFRecipient> Recipients { get; set; }
        public List<RFAttachmentUrl> Attachments { get; set; }
    }

    //Recipient class
    public class RFRecipient
    {
        public string Name { get; set; }
        public string Destination { get; set; }
    }

    //Attachment class
    public class RFAttachmentUrl
    {
        public string AttachmentUrl { get; set; }
    }
}
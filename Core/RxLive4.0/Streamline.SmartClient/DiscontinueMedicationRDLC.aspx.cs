using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using Streamline.BaseLayer;
using Streamline.UserBusinessServices;
//using ZfLib;
//using Zetafax.Common;
//using System.Resources;
//using Zetafax;
using System.IO;
using System.Collections.Generic;
using Ajax;
using Microsoft.Reporting.WebForms;
using System.Text;


public partial class DiscontinueMedicationRDLC : Streamline.BaseLayer.ActivityPages.ActivityPage
{

    #region--Global variables
    byte[] renderedBytes;
    Microsoft.Reporting.WebForms.ReportViewer reportViewer1;
    int clientMedicationId = 0;
    string method = string.Empty;
    int staffId = 0;
    int pharmacyId = 0;
    int ClientMedicationId = 0;
    bool _strFaxFailed = false;
    string strPageHtml = string.Empty;
    string faxUniqueId = string.Empty;
    //Code added by Loveena in ref to Task#2660
    string FolderId = string.Empty;
    #endregion
    protected override void Page_Load(object sender, EventArgs e)
    {
        try
        {
            if ((Request.QueryString["PharmacyId"] != null) && (Request.QueryString["PharmacyId"] != ""))
            {
                if (Request.QueryString["PharmacyId"] != "undefined")
                {
                    pharmacyId = Convert.ToInt32(Request.QueryString["PharmacyId"].ToString());
                }
            }
            GetRDLCContents();
            if ((Request.QueryString["MedicationId"] != null) && (Request.QueryString["MedicationId"] != "") && (Request.QueryString["MedicationId"] != "undefined") && (Request.QueryString["PharmacyId"] != null) && (Request.QueryString["PharmacyId"] != "") && (Request.QueryString["PharmacyId"] != "undefined"))
            {
                ClientMedicationId = Convert.ToInt32(Request.QueryString["MedicationId"].ToString());
                //added By Priya ref: Task no:2877 Date 8th April 2010               
                if (_strFaxFailed == false)
                    InsertFaxActivity(ClientMedicationId, pharmacyId);

            }
        }
        catch (Exception ex)
        {
            Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);
        }

    }
    #region--User Defined Function

    /// <summary>
    /// <Description>Used to get Rdlc contents as per task#1(Venture)</Description>
    ///<Author>Pradeep</Author> 
    /// <CreatedOn>2Dec,2009</CreatedOn>
    /// </summary>
    public void GetRDLCContents()
    {
        string _ReportPath = "";
        string mimeType;
        string encoding;
        string fileNameExtension;
        string[] streams;

        DataSet _DataSetGetRdlCName = null;
        DataSet _DataSetRdlForMainReport = null;
        DataSet _DataSetRdlForSubReport = null;
        DataRow[] dr = null;
        DataRow[] _drSubReport = null;
        string _OrderingMethod = "";
        string strErrorMessage = "";
        LogManager objLogManager = null;
        //Ref to Task#2660
        string FileName = "";
        int seq = 1;
        ReportParameter[] _RptParam = null;

        reportViewer1 = new Microsoft.Reporting.WebForms.ReportViewer();
        try
        {
            _ReportPath = Server.MapPath(".") + System.Configuration.ConfigurationManager.AppSettings["MedicationPerscriptionReportUrl"];
            if (_ReportPath == "")//Check For Report Path
            {
                strErrorMessage = "ReportPath is Missing In WebConfig";
                //ScriptManager.RegisterStartupScript(Label1, Label1.GetType(), ClientID.ToString(), "ShowError('" + strErrorMessage + "', true);", true);
                return;
            }
        }
        catch (Exception ex)
        {
            Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);

            strErrorMessage = "ReportPath Key is Missing In WebConfig";
            //ScriptManager.RegisterStartupScript(Label1, Label1.GetType(), ClientID.ToString(), "ShowError('" + strErrorMessage + "', true);", true);
            return;
        }
        finally
        {
            objLogManager = null;

        }
        try
        {
            //Ref to Task#2660
            if (System.Configuration.ConfigurationSettings.AppSettings["SaveJpegOutput"].ToLower() == "true")
            {
                if (System.IO.Directory.Exists(Server.MapPath("RDLC\\" + Context.User.Identity.Name)))
                {
                    if (!System.IO.Directory.Exists(Server.MapPath("RDLC\\" + Context.User.Identity.Name + "\\JPEGS")))
                        System.IO.Directory.CreateDirectory(Server.MapPath("RDLC\\" + Context.User.Identity.Name + "\\JPEGS"));

                    foreach (string file in Directory.GetFiles(Server.MapPath("RDLC\\" + Context.User.Identity.Name + "\\")))
                    {
                        FileName = file.Substring(file.LastIndexOf("\\") + 1);
                        if ((FileName.IndexOf("JPEG") >= 0 || FileName.IndexOf("jpeg") >= 0))
                        {
                            //Added by Chandan on 16th Feb2010 ref task#2797
                            if (System.IO.File.Exists(Server.MapPath("RDLC\\" + Context.User.Identity.Name + "\\JPEGS") + "\\" + FileName))
                            {
                                if (FileName.ToUpper().IndexOf(".RDLC") == -1)
                                    System.IO.File.Delete(Server.MapPath("RDLC\\" + Context.User.Identity.Name + "\\" + FileName));
                            }
                            else
                            {
                                while (seq < 1000)
                                {
                                    seq = seq + 1;
                                    if (!System.IO.File.Exists(Server.MapPath("RDLC\\" + Context.User.Identity.Name + "\\JPEGS") + "\\" + FileName))
                                    {
                                        System.IO.File.Move(file, Server.MapPath("RDLC\\" + Context.User.Identity.Name + "\\JPEGS") + "\\" + FileName);
                                        break;
                                    }
                                    else
                                    {
                                        //string FirstName = FileName.Substring(0, FileName.IndexOf("."));
                                        //string LastName = FileName.Substring(FileName.IndexOf(".") + 1);
                                        //string MiddleName = LastName.Substring(0, LastName.IndexOf("."));
                                        //MiddleName = MiddleName.Replace(MiddleName, seq.ToString());

                                        //FileName = FileName.Replace(FileName.Substring(FileName.IndexOf(".") + 1).Substring(0, FileName.Substring(FileName.IndexOf(".") + 1).IndexOf(".")), seq.ToString());
                                        FileName = ApplicationCommonFunctions.GetFileName(FileName, seq);
                                    }

                                }

                            }
                        }
                    }
                }
            }
            else
            {
                //Code added to delete the rendered images
                try
                {
                    using (Streamline.BaseLayer.RDLCPrint objRDLC = new RDLCPrint())
                    {
                        objRDLC.DeleteRenderedImages(Server.MapPath("RDLC\\" + Context.User.Identity.Name));
                    }
                }
                catch (Exception ex)
                {
                    Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);


                }

            }
            Streamline.UserBusinessServices.ClientMedication objectClientMedications = null;
            objectClientMedications = new ClientMedication();
            _DataSetGetRdlCName = objectClientMedications.GetRdlCNameDataBase(1035);

            _DataSetGetRdlCName.Tables[0].TableName = "DocumentCodes";
            _DataSetGetRdlCName.Tables[1].TableName = "DocumentCodesRDLSubReports";
            if (Request.QueryString["MedicationId"] != null || Request.QueryString["MedicationId"] != string.Empty)
            {
                clientMedicationId = Convert.ToInt32(Request.QueryString["MedicationId"].ToString());
            }
            if (Request.QueryString["OrderName"] != null || Request.QueryString["OrderName"] != string.Empty)
            {
                method = Convert.ToString(Request.QueryString["OrderName"].ToString());
            }
            if (Request.QueryString["StaffId"] != null || Request.QueryString["StaffId"] != string.Empty)
            {
                staffId = Convert.ToInt32(Request.QueryString["StaffId"].ToString());
            }
            //if (Request.QueryString["PharmacyId"] != null || Request.QueryString["PharmacyId"] != string.Empty)
            //{
            //    pharmacyId = Convert.ToInt32(Request.QueryString["PharmacyId"].ToString());
            //}
            DataSet dataSetClientSummary = null;
            if (Session["DataSetClientSummary"] != null)
            {
                dataSetClientSummary = (DataSet)Session["DataSetClientSummary"];
                DataRow[] dataRowPharmacy = dataSetClientSummary.Tables["ClientPharmacies"].Select("SequenceNumber=1");
                if (dataRowPharmacy.Length > 0)
                {
                    string _PharmacyId = dataRowPharmacy[0]["PharmacyId"] == DBNull.Value ? string.Empty : dataRowPharmacy[0]["PharmacyId"].ToString();
                    if (_PharmacyId.Trim() != string.Empty && pharmacyId == 0)
                    {
                        pharmacyId = Convert.ToInt32(_PharmacyId);
                    }
                }
            }
            if (_DataSetGetRdlCName.Tables["DocumentCodes"].Rows.Count > 0)
            {
                dr = _DataSetGetRdlCName.Tables["DocumentCodes"].Select();//because DocumentCodes table only contain one row
                //Check For Main Report
                if ((dr[0]["DocumentName"] != DBNull.Value || !String.IsNullOrEmpty(dr[0]["DocumentName"].ToString())) && (dr[0]["ViewStoredProcedure"] != DBNull.Value || !String.IsNullOrEmpty(dr[0]["ViewStoredProcedure"].ToString())))
                {
                    #region--Get the StoredProceudreName and Execute
                    string _StoredProcedureName = "";
                    string _ReportName = "";
                    _StoredProcedureName = dr[0]["ViewStoredProcedure"].ToString();//Get the StoredProcedure Name
                    _ReportName = dr[0]["DocumentName"].ToString();
                    this.reportViewer1.ProcessingMode = Microsoft.Reporting.WebForms.ProcessingMode.Local;
                    this.reportViewer1.LocalReport.ReportPath = _ReportPath + "\\" + _ReportName + ".rdlc";
                    this.reportViewer1.LocalReport.DataSources.Clear();

                    _DataSetRdlForMainReport = objectClientMedications.GetDataForDisContinueRdlC(_StoredProcedureName, clientMedicationId, method, staffId, pharmacyId);

                    Microsoft.Reporting.WebForms.ReportDataSource DataSource = new Microsoft.Reporting.WebForms.ReportDataSource("RDLDiscontinueDataSet_" + _StoredProcedureName, _DataSetRdlForMainReport.Tables[0]);
                    DataSet dataSetTemp = new DataSet();
                    dataSetTemp.Merge(_DataSetRdlForMainReport);
                    #endregion--Get the StoredProceudreName and Execute
                    _RptParam = new ReportParameter[4];
                    _RptParam[0] = new ReportParameter("ClientMedicationId", Convert.ToString(clientMedicationId));
                    _RptParam[1] = new ReportParameter("Method", method);
                    _RptParam[2] = new ReportParameter("InitiatedBy", Convert.ToString(staffId));
                    _RptParam[3] = new ReportParameter("PharmacyId", "0");
                    reportViewer1.LocalReport.SetParameters(_RptParam);

                    reportViewer1.LocalReport.Refresh();
                    reportViewer1.LocalReport.DataSources.Add(DataSource);
                }
            }
            string reportType = "PDF";
            IList<Stream> m_streams;
            m_streams = new List<Stream>();
            Microsoft.Reporting.WebForms.Warning[] warnings;
            string deviceInfo = "<DeviceInfo><OutputFormat>PDF</OutputFormat><StartPage>0</StartPage></DeviceInfo>";

            if (Session["imgId"] == null)
                Session["imgId"] = 0;
            else
                Session["imgId"] = Convert.ToInt32(Session["imgId"]) + 1;

            string ScriptId = Session["imgId"] + "_" + DateTime.Now.ToString("yyyyMMHHMMss") + "." + seq.ToString();

            try
            {
                using (Streamline.BaseLayer.RDLCPrint objRDLC = new RDLCPrint())
                {
                    //In case of Ordering method as X Chart copy will be printed

                    //objRDLC.RunPreview(this.reportViewer1.LocalReport, Server.MapPath("RDLC\\" + Context.User.Identity.Name), Session["imgId"].ToString(), false, false);
                    objRDLC.Run(this.reportViewer1.LocalReport, Server.MapPath("RDLC\\" + Context.User.Identity.Name), ScriptId, false, false);

                    //Added by Rohit. Ref ticket#84
                    renderedBytes = reportViewer1.LocalReport.Render(reportType, deviceInfo, out mimeType, out encoding, out fileNameExtension, out streams, out warnings);

                    ShowReport(ScriptId);

                }
            }
            catch (Exception ex)
            {
                Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);


            }
            finally
            {
                objLogManager = null;
            }
        }
        catch (Exception ex)
        {
            Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);
        }
    }
    public void ShowReport(string _strScriptIds)
    {
        FileStream fs;
        TextWriter ts;
        ArrayList ScriptArrays;
        ArrayList ChartScriptArrays;
        bool _strFaxSendStatus = false;
        string _strFaxFaildMessage = "";
        try
        {
            string strPath = "";
            string FileName = "";
            fs = new FileStream(Server.MapPath("RDLC\\" + Context.User.Identity.Name + "\\Report.html"), FileMode.Create);
            ts = new StreamWriter(fs);
            divReportViewer.InnerHtml = "";

            string strPageHtml = "";
            ScriptArrays = new ArrayList();
            ScriptArrays = ApplicationCommonFunctions.StringSplit(_strScriptIds, "^");
            if (method.Trim().ToUpper() == "P")
            {
                //using (Streamline.BaseLayer.RDLCPrint objRDLC = new RDLCPrint())
                //{

                //    objRDLC.Run(this.reportViewer1.LocalReport, Server.MapPath("RDLC\\" + Context.User.Identity.Name), this.HiddenFieldAllFaxed.ToString(), false, false);
                //}
                ScriptManager.RegisterStartupScript(LabelClientScript, LabelClientScript.GetType(), ClientID.ToString(), "printRDLC();", true);
                _strFaxFailed = true;
            }
            else if (method.Trim().ToUpper() == "F")
            {
                if (pharmacyId != 0)
                {
                    //Send to Fax
                    SendToFax(pharmacyId);
                    if (_strFaxFailed == true)
                    {

                        _strFaxFaildMessage = "Script could not be faxed at this time.  The fax server is not available.  Please print the script or re-fax the script later.";
                        strPageHtml += "<span style='float:left;position:absolute;padding-left:30%;color:Red;text-align:center;font-size: 12px;font-family:Microsoft Sans Serif;'><b>" + _strFaxFaildMessage + "</b></span><br/>";
                        //---Send for printing  
                        //using (Streamline.BaseLayer.RDLCPrint objRDLC = new RDLCPrint())
                        //{

                        //    objRDLC.Run(this.reportViewer1.LocalReport, Server.MapPath("RDLC\\" + Context.User.Identity.Name), this.HiddenFieldAllFaxed.ToString(), false, false);
                        //}
                        ScriptManager.RegisterStartupScript(LabelClientScript, LabelClientScript.GetType(), ClientID.ToString(), "printRDLC();", true);

                    }
                }
                else
                {
                    //Send to Printer
                    ScriptManager.RegisterStartupScript(LabelClientScript, LabelClientScript.GetType(), ClientID.ToString(), "printRDLC();", true);
                }
            }

            for (int i = 0; i < ScriptArrays.Count; i++)
            {

                foreach (string file in Directory.GetFiles(Server.MapPath("RDLC\\" + Context.User.Identity.Name + "\\")))
                {
                    FileName = file.Substring(file.LastIndexOf("\\") + 1);
                    if ((FileName.IndexOf("JPEG") >= 0 || FileName.IndexOf("jpeg") >= 0) && (FileName.IndexOf(ScriptArrays[i].ToString(), 3) >= 0))
                        strPageHtml += "<img src='.\\RDLC\\" + Context.User.Identity.Name + "\\" + FileName + "' style='width:100%' />";
                    strPath = "'..\\RDLC\\" + Context.User.Identity.Name + "\\" + FileName;
                }
            }


            divReportViewer.InnerHtml = "";
            divReportViewer.InnerHtml = strPageHtml;

            ts.Close();
            //Response.Write(strPageHtml);
        }
        catch (Exception ex)
        {
            throw (ex);
        }
    }

    public void SendToFax(int PharmacyId)
    {
        try
        {
            Stream fs = new FileStream(Server.MapPath("RDLC\\" + Context.User.Identity.Name + "\\DiscontinueMedicationScript.pdf"), FileMode.Create);
            fs.Write(renderedBytes, 0, renderedBytes.Length);
            fs.Close();
            Streamline.Faxing.StreamlineFax _streamlineFax = new Streamline.Faxing.StreamlineFax();
            //_strFaxFailed = _streamlineFax.SendFax(PharmacyId, ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId, (Server.MapPath("RDLC") + "\\" + Context.User.Identity.Name + "\\DiscontinueMedicationScript.pdf"), "Prescription Medication Script");
            faxUniqueId = _streamlineFax.SendFax(PharmacyId,
                                                 ((Streamline.BaseLayer.StreamlinePrinciple) Context.User).Client
                                                                                                          .ClientId,
                                                 (Server.MapPath("RDLC") + "\\" + Context.User.Identity.Name +
                                                  "\\DiscontinueMedicationScript.pdf"), "Prescription Medication Script");
            _strFaxFailed = (faxUniqueId == "false");
        }
        catch (System.Runtime.InteropServices.COMException ex)
        {
            if (ex.Data["CustomExceptionInformation"] == null)
                ex.Data["CustomExceptionInformation"] = "Source function SendToFax() of DiscontinuationMedicationRdlc";
            else
                ex.Data["CustomExceptionInformation"] = "";
            if (ex.Data["DatasetInfo"] == null)
                ex.Data["DatasetInfo"] = null;
            Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);
        }
    }

    public void InsertFaxActivity(int ClientMedicationId, int pharmacyId)
    {
        try
        {
            DataSet DataSetDiscontinueMedications = null;
            Streamline.UserBusinessServices.ClientMedication ObjClientMedication = new Streamline.UserBusinessServices.ClientMedication();
            Streamline.UserBusinessServices.DataSets.DataSetDiscontinueMedication _dsDiscontinueMedication = null;
            Streamline.UserBusinessServices.DataSets.DataSetDiscontinueMedication.ClientMedicationFaxActivitiesRow _drFaxActivitiesRow = null;
            _dsDiscontinueMedication = new Streamline.UserBusinessServices.DataSets.DataSetDiscontinueMedication();
            _drFaxActivitiesRow = (Streamline.UserBusinessServices.DataSets.DataSetDiscontinueMedication.ClientMedicationFaxActivitiesRow)_dsDiscontinueMedication.ClientMedicationFaxActivities.NewRow();
            _drFaxActivitiesRow.ClientMedicationId = ClientMedicationId;
            _drFaxActivitiesRow.FaxEventType = 5582;
            _drFaxActivitiesRow.FaxStatus = "Queued";
            _drFaxActivitiesRow.PharmacyId = pharmacyId;
            _drFaxActivitiesRow.FaxStatusDate = DateTime.Now;
            _drFaxActivitiesRow.FaxExternalIdentifier = faxUniqueId;
            _drFaxActivitiesRow.RowIdentifier = System.Guid.NewGuid();
            _drFaxActivitiesRow.CreatedBy = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
            _drFaxActivitiesRow.CreatedDate = DateTime.Now;
            _drFaxActivitiesRow.ModifiedBy = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
            _drFaxActivitiesRow.ModifiedDate = DateTime.Now;
            _dsDiscontinueMedication.ClientMedicationFaxActivities.Rows.Add(_drFaxActivitiesRow);
            ObjClientMedication = new ClientMedication();
            ObjClientMedication.SetRenderedImageData(_dsDiscontinueMedication, _drFaxActivitiesRow, ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode, renderedBytes);
            DataSetDiscontinueMedications = ObjClientMedication.UpdateDocuments(_dsDiscontinueMedication);
        }
        catch (Exception ex)
        {
            Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);
        }
    }

    #endregion

}

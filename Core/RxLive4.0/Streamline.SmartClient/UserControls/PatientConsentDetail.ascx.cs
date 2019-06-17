using System;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using Streamline.BaseLayer;
using Streamline.UserBusinessServices;
using System.IO;
using System.Xml.Serialization;
using System.Runtime.Serialization.Formatters.Binary;
using System.Xml;
using Microsoft.Reporting.WebForms;
using System.Text;
using System.Collections.Generic;
using System.Data;

namespace Streamline.SmartClient.UI
{

    public partial class UserControls_PatientConsentDetail : Streamline.BaseLayer.BaseActivityPage
    {
        int _CustomWebDocumentCodeId = 0;
        Streamline.UserBusinessServices.DataSets.DataSetCustomWebDocument _dsCustomDocuments = null;
        Microsoft.Reporting.WebForms.ReportViewer reportViewer1;
        byte[] renderedBytes;
        private HiddenField HiddenFieldPageCalledFrom = null;
        public override void Activate()
        {
            try
            {               
                HiddenFieldPageCalledFrom = (HiddenField)Page.FindControl("HiddenFieldPageCalledFrom");
                if (HiddenFieldPageCalledFrom.Value == "ConsentHistoryPage")
                {
                    ButtonClose.Visible = true;
                    ButtonClose1.Visible = false;
                }
                else
                {
                    ButtonClose.Visible = false;
                    ButtonClose1.Visible = true;
                }
                HiddenFieldLatestDocumentVersionId.Value = Session["VersionIdForConsentDetailPage"].ToString();
                GetRDLCContents();
                ShowReport();
            }
            catch (Exception ex)
            {

            }
        }
        protected override void Page_Load(object sender, EventArgs e)
        {
            //Added in ref to Task#2895
            if (System.Configuration.ConfigurationSettings.AppSettings["OpenFromSmartCare"].ToString().ToUpper() == "FALSE")
            {
                LinkButtonLogout.Style["display"] = "block";
                LinkButtonStartPage.Style["display"] = "block";
            }
        }
        public void GetRDLCContents()
        {
            #region Get RDLC Contents

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

            ReportParameter[] _RptParam = null;
            int LocationId = 1;
            reportViewer1 = new Microsoft.Reporting.WebForms.ReportViewer();
            string strIds ="";
            try
            {
                _ReportPath = Server.MapPath(".") + System.Configuration.ConfigurationManager.AppSettings["MedicationPerscriptionReportUrl"];
                if (_ReportPath == "")
                {
                    strErrorMessage = "ReportPath is Missing In WebConfig";
                    ScriptManager.RegisterStartupScript(Label1, Label1.GetType(), ClientID.ToString(), "ShowError('" + strErrorMessage + "', true);", true);
                    return;
                }
            }
            catch (Exception ex)
            {
                Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);
                strErrorMessage = "ReportPath Key is Missing In WebConfig";
                ScriptManager.RegisterStartupScript(Label1, Label1.GetType(), ClientID.ToString(), "ShowError('" + strErrorMessage + "', true);", true);
                return;
            }
            finally
            {
                objLogManager = null;
            }
            try
            {
                Streamline.UserBusinessServices.ClientMedication objectClientMedications = null;
                objectClientMedications = new ClientMedication();
                _DataSetGetRdlCName = objectClientMedications.GetRdlCNameDataBase(1026);
                _DataSetGetRdlCName.Tables[0].TableName = "DocumentCodes";
                _DataSetGetRdlCName.Tables[1].TableName = "DocumentCodesRDLSubReports";
                if (_DataSetGetRdlCName.Tables["DocumentCodes"].Rows.Count > 0)
                {
                    dr = _DataSetGetRdlCName.Tables["DocumentCodes"].Select();
                    if ((dr[0]["DocumentName"] != DBNull.Value || !String.IsNullOrEmpty(dr[0]["DocumentName"].ToString())) && (dr[0]["ViewStoredProcedure"] != DBNull.Value || !String.IsNullOrEmpty(dr[0]["ViewStoredProcedure"].ToString())))
                    {
                        #region Get the StoredProceudreName and Execute
                        string _StoredProcedureName = "";
                        string _ReportName = "";
                        _StoredProcedureName = dr[0]["ViewStoredProcedure"].ToString();
                        _ReportName = dr[0]["DocumentName"].ToString();
                        this.reportViewer1.ProcessingMode = Microsoft.Reporting.WebForms.ProcessingMode.Local;
                        this.reportViewer1.LocalReport.ReportPath = _ReportPath + "\\" + _ReportName + ".rdlc";
                        this.reportViewer1.LocalReport.DataSources.Clear();
                        //Testing By Vikas Vyas
                        reportViewer1.LocalReport.Refresh();
                        //End

                        string str = Session["MedicationIdsForConsentDetailPage"].ToString();
                        _DataSetRdlForMainReport = objectClientMedications.GetDataForHarborStandardConsentRdlC(_StoredProcedureName, Convert.ToInt32((((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId)), str, Convert.ToInt32(HiddenFieldLatestDocumentVersionId.Value));
                        Microsoft.Reporting.WebForms.ReportDataSource DataSource = new Microsoft.Reporting.WebForms.ReportDataSource("RDLReportDataSet_" + _StoredProcedureName, _DataSetRdlForMainReport.Tables[0]);
                        DataSet dstemp = (DataSet)Session["DataSetRdlTemp"];
                        if (dstemp == null)
                        {
                            dstemp = _DataSetRdlForMainReport;
                        }
                        else
                        {
                            dstemp.Merge(_DataSetRdlForMainReport);
                        }
                        Session["DataSetRdlTemp"] = dstemp;

                        #endregion
                        if (_DataSetGetRdlCName.Tables["DocumentCodesRDLSubReports"].Rows.Count > 0)
                        {
                            _drSubReport = _DataSetGetRdlCName.Tables["DocumentCodesRDLSubReports"].Select();
                            reportViewer1.LocalReport.SubreportProcessing -= new Microsoft.Reporting.WebForms.SubreportProcessingEventHandler(SetSubDataSource);
                            reportViewer1.LocalReport.SubreportProcessing += new Microsoft.Reporting.WebForms.SubreportProcessingEventHandler(SetSubDataSource);
                            for (int i = 0; i < _drSubReport.Length; i++)
                            {
                                if ((_drSubReport[i]["SubReportName"] != DBNull.Value || !String.IsNullOrEmpty(_drSubReport[i]["SubReportName"].ToString())) && (_drSubReport[i]["StoredProcedure"] != DBNull.Value || !String.IsNullOrEmpty(_drSubReport[i]["StoredProcedure"].ToString())))
                                {
                                    #region Get the StoredProcedureName For SubReport and Execute
                                    string _SubReportStoredProcedure = "";
                                    string _SubReportName = "";
                                    _SubReportStoredProcedure = _drSubReport[i]["StoredProcedure"].ToString();
                                    _SubReportName = _drSubReport[i]["SubReportName"].ToString();
                                    string str2 = Session["MedicationIdsForConsentDetailPage"].ToString();
                                    _DataSetRdlForSubReport = objectClientMedications.GetDataForHarborStandardConsentRdlC(_SubReportStoredProcedure, Convert.ToInt32((((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId)), str2, Convert.ToInt32(HiddenFieldLatestDocumentVersionId.Value));
                                    Microsoft.Reporting.WebForms.ReportDataSource rds = new Microsoft.Reporting.WebForms.ReportDataSource(_SubReportName, _DataSetRdlForSubReport.Tables[0]);
                                    reportViewer1.LocalReport.DataSources.Add(rds);
                                    string strRootPath = Server.MapPath(".");
                                    System.IO.StreamReader RdlSubReport = new System.IO.StreamReader(_ReportPath + "\\" + _SubReportName.Trim() + ".rdlc");
                                    reportViewer1.LocalReport.LoadReportDefinition(RdlSubReport);
                                    #endregion
                                }
                            }
                        }
                        _RptParam = new ReportParameter[3];
                        _RptParam[0] = new ReportParameter("ClientId", Convert.ToString(((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId));
                        string str1 = Session["MedicationIdsForConsentDetailPage"].ToString();
                        _RptParam[1] = new ReportParameter("ClientMedicationId", str1);
                        _RptParam[2] = new ReportParameter("ClientName", Convert.ToString(((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.LastName + ", " + ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.FirstName));
                        reportViewer1.LocalReport.SetParameters(_RptParam);
                        reportViewer1.LocalReport.Refresh();
                        reportViewer1.LocalReport.DataSources.Add(DataSource);
                        strIds = str1;
                        //ScriptManager.RegisterStartupScript(Label1, Label1.GetType(), ClientID.ToString(), "ShowPrintDiv('" + Session["ChangedOrderMedicationIds"].ToString() + "');", true);
                    }
                }
            #endregion
                try
                {
                    if (Session["imgId1"] == null || Session["imgId1"] == "")
                    {
                        string str = Session["MedicationIdsForConsentDetailPage"].ToString();
                        Session["imgId1"] = str;
                    }
                    else
                    {
                        Session["imgId1"] = Convert.ToInt32(Session["imgId1"]) + 1;
                    }
                }
                catch (Exception ex)
                {
                }
                #region DeleteOldRenderedImages
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
                #endregion

                string reportType = "PDF";
                IList<Stream> m_streams;
                m_streams = new List<Stream>();
                Microsoft.Reporting.WebForms.Warning[] warnings;
                string deviceInfo = "<DeviceInfo><OutputFormat>PDF</OutputFormat><StartPage>0</StartPage></DeviceInfo>";
                //try
                //{
                //    if (Session["imgId1"] == null)
                //    {
                //        string str = Session["MedicationIdsForConsentDetailPage"].ToString();
                //        Session["imgId1"] = str;
                //    }
                //    else
                //    {
                //        Session["imgId1"] = Convert.ToInt32(Session["imgId1"]) + 1;
                //    }
                //}
                //catch (Exception ex)
                //{
                //}
                if (Session["imgId1"] == null)
                    Session["imgId1"] = strIds;
                using (Streamline.BaseLayer.RDLCPrint objRDLC = new RDLCPrint())
                {

                    //objRDLC.Run(this.reportViewer1.LocalReport, Server.MapPath("RDLC\\" + Context.User.Identity.Name), Session["imgId1"].ToString(), false, false);
                    objRDLC.RunConsent(this.reportViewer1.LocalReport, Server.MapPath("RDLC\\" + Context.User.Identity.Name), Session["imgId1"].ToString(), false, false);

                    renderedBytes = reportViewer1.LocalReport.Render(reportType, deviceInfo, out mimeType, out encoding, out fileNameExtension, out streams, out warnings);
                }
                //ScriptManager.RegisterStartupScript(Label1, Label1.GetType(), ClientID.ToString(), "ShowPrintDiv('" + Session["imgId1"].ToString() + "');", true);
            }
            catch (Exception ex)
            {
                Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);

            }
            finally
            {
                _DataSetGetRdlCName = null;
                _DataSetRdlForMainReport = null;
                _DataSetRdlForSubReport = null;
                _RptParam = null;
            }
        }


        public void ShowReport()
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
                divPatientConsentReport.InnerHtml = "";
                string strPageHtml = "";
                ScriptArrays = new ArrayList();
                ScriptArrays = ApplicationCommonFunctions.StringSplit(Convert.ToString(Session["imgId1"]), "^");
                for (int i = 0; i < ScriptArrays.Count; i++)
                {

                    foreach (string file in Directory.GetFiles(Server.MapPath("RDLC\\" + Context.User.Identity.Name + "\\")))
                    {
                        FileName = file.Substring(file.LastIndexOf("\\") + 1);
                        if ((FileName.IndexOf("JPEG") >= 0 || FileName.IndexOf("jpeg") >= 0) && (FileName.IndexOf(ScriptArrays[i].ToString(), 3) >= 0))

                            strPageHtml += "<img src='.\\RDLC\\" + Context.User.Identity.Name + "\\" + FileName + "'/>";
                        strPath = "'..\\RDLC\\" + Context.User.Identity.Name + "\\" + FileName;
                    }
                }
                divPatientConsentReport.InnerHtml = "";
                divPatientConsentReport.InnerHtml = strPageHtml;
                ts.Close();
            }
            catch (Exception ex)
            {
                throw (ex);
            }
        }
        public void SetSubDataSource(object sender, Microsoft.Reporting.WebForms.SubreportProcessingEventArgs e)
        {
            try
            {
                Microsoft.Reporting.WebForms.LocalReport rptTemp = (Microsoft.Reporting.WebForms.LocalReport)sender;
                DataTable dtTemp = (DataTable)rptTemp.DataSources[e.ReportPath.Trim()].Value;
                e.DataSources.Add(new Microsoft.Reporting.WebForms.ReportDataSource(e.DataSourceNames[0], dtTemp));
            }
            catch (Exception ex)
            {
                Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);

            }
        }
        protected void LinkButtonLogout_Click(object sender, EventArgs e)
        {
            Response.Redirect("MedicationLogin.aspx");
        }
}
}

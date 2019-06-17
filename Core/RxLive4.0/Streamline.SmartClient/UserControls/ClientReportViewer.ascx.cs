using System;
using System.Linq;
using System.Web.UI.WebControls;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.IO;
using System.Net;
using System.Text;
using System.Security.Authentication;
using System.Security.Principal;
using System.Collections.Generic;
using Microsoft.Reporting.WebForms;
using Streamline.BaseLayer;
using Streamline.UserBusinessServices;
using System.Text.RegularExpressions;
using System.Drawing.Printing;


public partial class UserControls_ClientReportViewer : BaseActivityPage
{
    ReportParameter[] parameters = null;
    string SystemText = string.Empty;
    Warning[] warnings;
    string[] streamids;
    string mimeType = string.Empty;
    string encoding = string.Empty;
    string extension = string.Empty;
    byte[] bytes = null;
    Microsoft.Reporting.WebForms.IReportServerCredentials irsc = null;

    protected override void Page_Load(object sender, EventArgs e)
    {
        BindControl();
    }

    public void BindControl()
    {
        DataSet dSClientEducationResources = null;
        DataTable dtClientEducationResources = null;
        string reportUrl = null;
        DataSet ds = null;
        string clientId = null;
        try
        {
            var _ReportName = Request.QueryString["reportName"];

            Streamline.UserBusinessServices.ClientMedication ObjClientMedication = new Streamline.UserBusinessServices.ClientMedication();
            ds = ObjClientMedication.GetSystemReports(_ReportName);
            if (ds.Tables.Count > 0)
            {
                if (ds.Tables[0].Rows.Count > 0)
                    reportUrl = ds.Tables[0].Rows[0]["ReportUrl"].ToString();
            }

            if (!_ReportName.IsNullOrWhiteSpace())
            {
                clientId = (((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId).ToString();

                if (reportUrl.IndexOf("<SessionId>") > -1)
                {
                    string selectedMedicationIds = Request.QueryString["medicationIds"];

                    Guid sessionId = Guid.NewGuid();
                    System.Data.SqlClient.SqlParameter[] reportParameters = null;

                    var dtMedicationIds = new DataTable();
                    dtMedicationIds.Columns.Add(new DataColumn("Value"));
                    dtMedicationIds.Columns.Add(new DataColumn("Type"));
                    DataRow dr;
                    if (!string.IsNullOrEmpty(selectedMedicationIds))
                    {
                        foreach (var medicationId in selectedMedicationIds.Split(','))
                        {
                            dr = dtMedicationIds.NewRow();
                            dr["Value"] = medicationId;
                            dr["Type"] = "Integer";
                            dtMedicationIds.Rows.Add(dr);
                        }
                    }

                    var objUserInfo = new UserInfo();
                    objUserInfo.InsertReport(sessionId, dtMedicationIds, "");

                    reportUrl = reportUrl.Replace("<SessionId>", sessionId.ToString());
                    parameters = new ReportParameter[1];
                    parameters[0] = new ReportParameter("SessionId", sessionId.ToString());
                    writeByteArray(reportUrl);
                }
                else
                {
                    switch (_ReportName)
                    {
                        case "Medications - Current":
                            reportUrl = reportUrl.Replace("<ClientId>", clientId);
                            parameters = new ReportParameter[1];
                            parameters[0] = new ReportParameter("ClientId", clientId);
                            writeByteArray(reportUrl);
                            break;
                        case "Medication Card":
                            reportUrl = reportUrl.Replace("<ClientId>", clientId);
                            parameters = new ReportParameter[1];
                            parameters[0] = new ReportParameter("ClientId", clientId);
                            writeByteArray(reportUrl);
                            break;
                        case "Medications - View History":
                            reportUrl = reportUrl.Replace("<ClientId>", clientId);
                            reportUrl = reportUrl.Replace("<StartDate>", Request.QueryString["StartDate"]);
                            reportUrl = reportUrl.Replace("<EndDate>", Request.QueryString["EndDate"]);
                            reportUrl = reportUrl.Replace("<ExpandCollapseAll>", Request.QueryString["ExpandCollapseAll"]);
                            parameters = new ReportParameter[4];
                            parameters[0] = new ReportParameter("ClientId", clientId);
                            parameters[1] = new ReportParameter("StartDate", Request.QueryString["StartDate"]);
                            parameters[2] = new ReportParameter("EndDate", Request.QueryString["EndDate"]);
                            parameters[3] = new ReportParameter("ExpandCollapseAll", Request.QueryString["ExpandCollapseAll"]);
                            writeByteArray(reportUrl);
                            break;
                        case "ClientHistory":
                            reportUrl = reportUrl.Replace("<ClientId>", clientId);
                            parameters = new ReportParameter[1];
                            parameters[0] = new ReportParameter("ClientId", clientId);
                            writeByteArray(reportUrl);
                            break;
                        case "Medications - View Client Consent History":
                            string _medicationNameId = Request.QueryString["MedicationNameId"];
                            if (_medicationNameId == "null")
                            {
                                _medicationNameId = "0";
                            }
                            reportUrl = reportUrl.Replace("<ClientId>", clientId);
                            reportUrl = reportUrl.Replace("<StartDate>", Request.QueryString["StartDate"]);
                            reportUrl = reportUrl.Replace("<EndDate>", Request.QueryString["EndDate"]);
                            reportUrl = reportUrl.Replace("<MedicationNameId>", _medicationNameId);
                            parameters = new ReportParameter[4];
                            parameters[0] = new ReportParameter("ClientId", clientId);
                            parameters[1] = new ReportParameter("StartDate", Request.QueryString["StartDate"]);
                            parameters[2] = new ReportParameter("EndDate", Request.QueryString["EndDate"]);
                            parameters[3] = new ReportParameter("MedicationNameId", _medicationNameId);
                            writeByteArray(reportUrl);
                            break;
                        default:
                            try
                            {
                                reportUrl = reportUrl.Replace("<ClientId>", clientId);
                                parameters = new ReportParameter[1];
                                parameters[0] = new ReportParameter("ClientId", clientId);
                                writeByteArray(reportUrl);
                            }
                            catch (Exception ex)
                            {
                                Response.End();
                            }
                            break;
                            return;
                    }
                }
            }
            else
            {
                Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "ErrorReport", "alert('Failed to load report.\\nPlease check the report server settings or contact your system administrator.');window.close();", true);
            }
        }
        catch (ArgumentOutOfRangeException ex)
        {
            Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);
            Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "ErrorReport", "alert('Failed to load report.\\nPlease check the report server settings or contact your system administrator.');window.close();", true);
        }
        catch (System.Threading.ThreadAbortException)
        {
        }
        catch (Exception ex)
        {
            Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);
            Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "ErrorReport", "alert('Failed to load report. Some unknown error occured. \\nPlease check the log for detail error or contact your system administrator.');window.close();", true);
        }
        finally
        {
            if (dSClientEducationResources != null)
                dSClientEducationResources.Dispose();
            if (dtClientEducationResources != null)
                dtClientEducationResources.Dispose();
        }
    }

    private void writeByteArray(string reportUrl)
    {
        MyReportServerConnection myreportconfiguration = new MyReportServerConnection();
        byte[] byteResponse = null;
        ReportViewer1.ShowPrintButton = true;
        ReportViewer1.SizeToReportContent = true;
        ReportViewer1.ServerReport.ReportServerCredentials = myreportconfiguration;
        reportUrl = Server.UrlDecode(reportUrl);



        Regex regReportURLCI = new Regex("^[^?]+");
        var reportURLMatchCI = regReportURLCI.Match(reportUrl);
        ReportViewer1.ServerReport.ReportServerUrl = myreportconfiguration.ReportServerUrl;
        ReportViewer1.ServerReport.ReportPath = GetReportPath(reportUrl);
        ReportViewer1.ServerReport.Timeout = myreportconfiguration.Timeout;
        ReportViewer1.ServerReport.SetParameters(parameters);
        ReportViewer1.ServerReport.Refresh();
        bytes = ReportViewer1.ServerReport.Render("PDF", null, out mimeType, out encoding, out extension, out streamids, out warnings);
        Response.Buffer = true;
        Response.Clear();
        Response.ClearContent();
        Response.ClearHeaders();
        Response.ContentType = "application/pdf";
        Response.AddHeader("Content-Disposition", "inline;filename=report.pdf");
        Response.BinaryWrite(bytes);
        Response.End();
    }

    private string GetReportPath(string rptUrl)
    {
        try
        {
            string reportPath = string.Empty;
            int indexStart = rptUrl.IndexOf('?');
            int indexEnd = rptUrl.IndexOf('&');
            reportPath = rptUrl.Substring(indexStart + 1, (indexEnd - indexStart) - 1);
            return reportPath;
        }
        finally
        {
        }
    }
    public byte[] RenderPDFFromReportViewObject(string reportName, ReportParameter[] reportParameters)
    {
        CustomReportCredentials objCustomReportCredentials = null;
        Uri reportServerURL = null;
        try
        {
            SystemConfigurations systemConfigurations = SystemConfigurations.GetInstance();
            reportServerURL = new Uri(systemConfigurations.ReportURL);
            string reportServerDomain = systemConfigurations.ReportServerDomain;
            string reportServerUserName = systemConfigurations.ReportServerUserName;
            string reportServerPassword = systemConfigurations.ReportServerPassword;
            string reportFolder = systemConfigurations.ReportFolder;
            string[] streamids;

            objCustomReportCredentials = new CustomReportCredentials(reportServerUserName, reportServerPassword, reportServerDomain);
            ReportViewer1.ServerReport.ReportServerCredentials = objCustomReportCredentials;
            ReportViewer1.ServerReport.ReportServerUrl = reportServerURL;
            ReportViewer1.ServerReport.ReportPath = "/" + reportFolder + "/" + reportName;
            ReportViewer1.ServerReport.SetParameters(reportParameters);
            ReportViewer1.ServerReport.Refresh();
            return ReportViewer1.ServerReport.Render("PDF", null, out mimeType, out encoding, out extension, out streamids, out warnings);

        }
        finally
        {
            if (reportServerURL != null)
                reportServerURL = null;
            if (objCustomReportCredentials != null)
                objCustomReportCredentials = null;

        }
    }
}

public class CustomReportCredentials : Microsoft.Reporting.WebForms.IReportServerCredentials
{

    // local variable for network credential.
    private string _UserName;
    private string _PassWord;
    private string _DomainName;
    public CustomReportCredentials(string UserName, string PassWord, string DomainName)
    {
        _UserName = UserName;
        _PassWord = PassWord;
        _DomainName = DomainName;
    }
    public WindowsIdentity ImpersonationUser
    {
        get
        {
            return null; // not use ImpersonationUser
        }
    }
    public ICredentials NetworkCredentials
    {
        get
        {
            return new NetworkCredential(_UserName, _PassWord, _DomainName);
        }
    }

    #region IReportServerCredentials Members

    public bool GetFormsCredentials(out Cookie authCookie, out string user, out string password, out string authority)
    {

        // not use FormsCredentials unless you have implements a custom autentication.
        authCookie = null;
        //user = password = authority = null;
        //return false;
        user = _UserName;
        password = _PassWord;
        authority = _DomainName;
        return false;
    }

    #endregion
}

public sealed class MyReportServerConnection : IReportServerConnection2
{

    #region IReportServerConnection2 Members

    public IEnumerable<Cookie> Cookies
    {
        get { return null; }
    }

    public IEnumerable<string> Headers
    {
        get { return null; }
    }

    #endregion

    #region IReportServerConnection Members

    public Uri ReportServerUrl
    {
        get
        {
            SystemConfigurations systemConfigurations = SystemConfigurations.GetInstance();
            if (string.IsNullOrEmpty(systemConfigurations.ReportURL))
                throw new Exception(
                    "Missing url from the Web.config file");
            return new Uri(systemConfigurations.ReportURL);
        }
    }

    public int Timeout
    {
        get { return 600000; }
    }

    #endregion

    #region IReportServerCredentials Members

    public bool GetFormsCredentials(out Cookie authCookie, out string userName, out string password, out string authority)
    {
        authCookie = null;
        userName = null;
        password = null;
        authority = null;

        return false;
    }

    public WindowsIdentity ImpersonationUser
    {
        get { return null; }
    }

    public ICredentials NetworkCredentials
    {
        get
        {
            SystemConfigurations systemConfigurations = SystemConfigurations.GetInstance();
            string userName = systemConfigurations.ReportServerUserName;
            string password = systemConfigurations.ReportServerPassword;
            string domain = systemConfigurations.ReportServerDomain;

            return new NetworkCredential(userName, password, domain);
        }
    }

    #endregion
}


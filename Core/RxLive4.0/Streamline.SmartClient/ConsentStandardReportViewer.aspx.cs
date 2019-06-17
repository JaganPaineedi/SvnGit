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
using System.IO;
using Streamline.BaseLayer;
using Streamline.UserBusinessServices;

public partial class ConsentStandardReportViewer : Streamline.BaseLayer.ActivityPages.ActivityPage
{
    protected override void Page_Load(object sender, EventArgs e)
    {
        FileStream fs;
        TextWriter ts;
        string _strClientMedicationIds = "";
        ArrayList MedicationArrays;
        Response.Cache.SetCacheability(HttpCacheability.NoCache);
        Response.Cache.SetExpires(DateTime.Now - new TimeSpan(0, 0, 0));
        Response.Cache.SetLastModified(DateTime.Now);
        Response.Cache.SetAllowResponseInBrowserHistory(false);
        Response.Expires = 0;
        Response.Cache.SetNoStore();
        Response.AppendHeader("Pragma", "no-cache");
        divReportViewer1.Visible = true;
        divNonReportViewer.Visible = false;

        try
        {

            #region "error message color added by rohit ref. #121"
            Streamline.BaseLayer.CommonFunctions.SetErrorMegssageBackColor(LabelError);
            Streamline.BaseLayer.CommonFunctions.SetErrorMegssageForeColor(LabelError);
            #endregion

            string strPath = "";
            string FileName = "";


            fs = new FileStream(Server.MapPath("RDLC\\" + Context.User.Identity.Name + "\\Report.html"), FileMode.Create);
            ts = new StreamWriter(fs);
            _strClientMedicationIds = Request.QueryString["varClientMedicationIds"].ToString();
            divReportViewer1.InnerHtml = "";
            
            string strPageHtml = "";
            MedicationArrays = new ArrayList();
            MedicationArrays = ApplicationCommonFunctions.StringSplit(_strClientMedicationIds, "^");


            for (int i = 0; i < MedicationArrays.Count; i++)
            {

                foreach (string file in Directory.GetFiles(Server.MapPath("RDLC\\" + Context.User.Identity.Name + "\\")))
                {
                    FileName = file.Substring(file.LastIndexOf("\\") + 1);
                    if ((FileName.IndexOf("JPEG") >= 0 || FileName.IndexOf("jpeg") >= 0) && (FileName.IndexOf(MedicationArrays[i].ToString()) >= 0))
                        strPageHtml += "<img src='.\\RDLC\\" + Context.User.Identity.Name + "\\" + FileName + "' style='width:108%' />";
                    strPath = "'..\\RDLC\\" + Context.User.Identity.Name + "\\" + FileName;
                }
            }

            if (Request.QueryString["ReportViewer"].ToString() == "true")
            {
                divReportViewer1.InnerHtml = "";
                strPageHtml = strPageHtml.Replace(@"\", "/");
                divReportViewer1.InnerHtml = strPageHtml;
                ts.Close();
            }
            else if (Request.QueryString["ReportViewer"].ToString() == "false")
            {
                ts.Close();
                //Response.Write(strPageHtml);
                strPageHtml = strPageHtml.Replace(@"\", "/");
                divNonReportViewer.InnerHtml = strPageHtml;
                divReportViewer1.Visible = false;
                divNonReportViewer.Visible = true;
                ScriptManager.RegisterStartupScript(LabelError, LabelError.GetType(), ClientID.ToString(), "printScript1();", true);
            }

        }
        catch (Exception ex)
        {
            if (ex.Data["CustomExceptionInformation"] == null)
                ex.Data["CustomExceptionInformation"] = "###Source Event Name -Page_Load()";
            else
                ex.Data["CustomExceptionInformation"] = "";
            if (ex.Data["DatasetInfo"] == null)
                ex.Data["DatasetInfo"] = null;
            Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);
        }
        finally
        {
            fs = null;
            ts = null;

        }


    }
}




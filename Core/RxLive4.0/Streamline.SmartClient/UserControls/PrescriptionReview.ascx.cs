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
using Microsoft.Reporting.WebForms;
using System.IO;
using System.Collections.Generic;

public partial class UserControls_PrescriptionReview : Streamline.BaseLayer.BaseActivityPage
{
    byte[] renderedBytes;
    Microsoft.Reporting.WebForms.ReportViewer reportViewer1;
    Streamline.UserBusinessServices.UserPrefernces objUserPreferences = null;
    Streamline.UserBusinessServices.MedicationLogin objMedicationLogin = null;
    protected override void Page_Load(object sender, EventArgs e)
    {
        //Code added in ref to Task#3054
        this.TextBoxAnswer.Attributes.Add("onkeydown", "if(event.which || event.keyCode){if ((event.which == 13) || (event.keyCode == 13)) {document.getElementById('" + ButtonApprove.UniqueID + "').click();return false;}} else {return true}; ");
        // LabelPrescriberName.Text = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).Name;
        // LabelReviewDateTime.Text = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).LastPrescriptionReviewTime;
        //Ref to Task#2895
        if (System.Configuration.ConfigurationSettings.AppSettings["OpenFromSmartCare"].ToString().ToUpper() == "FALSE")
        {
            LinkButtonLogout.Style["display"] = "block";
            LinkButtonStartPage.Style["display"] = "block";
        }
    }
    public override void Activate()
    {
        DataSet dsTemp = null;
        try
        {
            if (System.Configuration.ConfigurationSettings.AppSettings["OpenFromSmartCare"].ToString().ToUpper() == "FALSE")
            {
                LinkButtonLogout.Style["display"] = "block";
                LinkButtonStartPage.Style["display"] = "block";
            }
            LabelPrescriberName.Text = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).LastName + ", " + ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).FirstName + " " + (((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity)).StaffDegree;
            #region--Made changes by Pradeep as per task#2711
            string LastPrescriptionReviewTime = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).LastPrescriptionReviewTime;
            if (LastPrescriptionReviewTime.ToString() != string.Empty)
            {
                LabelReviewDateTime.Text = Convert.ToDateTime(LastPrescriptionReviewTime).ToString("MM/dd/yyyy hh:mm tt"); ;
            }

            #endregion--
            //LabelReviewDateTime.Text = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).LastPrescriptionReviewTime;
            HiddenFieldRDLCurrentDateTime.Value = DateTime.Now.ToString();
            if (Session["DataSetSecurityQustion"] != null)
            {
                dsTemp = (DataSet)Session["DataSetSecurityQustion"];
                Random random = new Random();
                int num = random.Next(0, dsTemp.Tables[0].Rows.Count);
                if (dsTemp.Tables[0].Rows.Count > 0)
                {
                    LabelSecurityQuestion.Text = dsTemp.Tables["StaffSecurityQuestion"].Rows[num]["CodeName"].ToString();
                    HiddenFieldSecurityAnswer.Value = dsTemp.Tables["StaffSecurityQuestion"].Rows[num]["SecurityAnswer"].ToString();
                }
            }
            else
            {
                objUserPreferences = new UserPrefernces();
                dsTemp = objUserPreferences.GetSecurityQuestions(Convert.ToInt32((((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId)));
                Session["DataSetSecurityQustion"] = dsTemp;
                Random random = new Random();
                int num = random.Next(0, dsTemp.Tables[0].Rows.Count);
                if (dsTemp.Tables[0].Rows.Count > 0)
                {
                    LabelSecurityQuestion.Text = dsTemp.Tables["StaffSecurityQuestion"].Rows[num]["CodeName"].ToString();
                    HiddenFieldSecurityAnswer.Value = dsTemp.Tables["StaffSecurityQuestion"].Rows[num]["SecurityAnswer"].ToString();
                }
            }
            GetRDLCContents();
            //if (Session["DataSetSecurityQustion"] != null)
            //{
            //    dsSecurityQuestion = new DataSet();
            //    dsSecurityQuestion = (DataSet)Session["DataSetSecurityQustion"];
            //    Random ran = new Random();
            //    int randomNumber = ran.Next(0,dsSecurityQuestion.Tables["StaffSecurityQuestion"].Rows.Count);
            //    LabelSecurityQuestion.Text = dsSecurityQuestion.Tables["StaffSecurityQuestion].Rows[randomNumber]["CodeName"];
            //    HiddenFieldSecurityAnswer.Value = dsSecurityQuestion.Tables[StaffSecurityQuestion].Rows[randomNumber]["Answer"];
            //}
        }
        catch (Exception ex)
        {

            throw ex;
        }
        finally
        {
            objUserPreferences = null;
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
        //Ref to Task#2660
        string FileName = "";
        int seq = 1;
        reportViewer1 = new Microsoft.Reporting.WebForms.ReportViewer();

        try
        {

            _ReportPath = Server.MapPath(".") + System.Configuration.ConfigurationManager.AppSettings["MedicationPerscriptionReportUrl"];
            if (_ReportPath == "")//Check For Report Path
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
            }
            //  _DataSetRdl = new DataSet();//Commented by Vikas Vyas On Dated March 04 2008
            Streamline.UserBusinessServices.ClientMedication objectClientMedications = null;
            objectClientMedications = new ClientMedication();
            //Added by Chandan for getting Location Id

            #region Added by Vikas Vyas


            _DataSetGetRdlCName = objectClientMedications.GetRdlCNameDataBase(1028);

            _DataSetGetRdlCName.Tables[0].TableName = "DocumentCodes";
            _DataSetGetRdlCName.Tables[1].TableName = "DocumentCodesRDLSubReports";


            if (_DataSetGetRdlCName.Tables["DocumentCodes"].Rows.Count > 0)
            {
                dr = _DataSetGetRdlCName.Tables["DocumentCodes"].Select();//because DocumentCodes table only contain one row



                //Check For Main Report
                if ((dr[0]["DocumentName"] != DBNull.Value || !String.IsNullOrEmpty(dr[0]["DocumentName"].ToString())) && (dr[0]["ViewStoredProcedure"] != DBNull.Value || !String.IsNullOrEmpty(dr[0]["ViewStoredProcedure"].ToString())))
                {

                    #region Get the StoredProceudreName and Execute
                    string _StoredProcedureName = "";
                    string _ReportName = "";
                    _StoredProcedureName = dr[0]["ViewStoredProcedure"].ToString();//Get the StoredProcedure Name
                    _ReportName = dr[0]["DocumentName"].ToString();

                    this.reportViewer1.ProcessingMode = Microsoft.Reporting.WebForms.ProcessingMode.Local;
                    this.reportViewer1.LocalReport.ReportPath = _ReportPath + "\\" + _ReportName + ".rdlc";
                    this.reportViewer1.LocalReport.DataSources.Clear();


                    //Get Data For Main Report
                    //One More Parameter Added by Chandan Task#85 MM1.7
                    _DataSetRdlForMainReport = objectClientMedications.GetDataForPrescriberRdlC(_StoredProcedureName, ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId, LabelReviewDateTime.Text, HiddenFieldRDLCurrentDateTime.Value);
                    //Microsoft.Reporting.WebForms.ReportDataSource DataSource = new ReportDataSource("RdlReportDataSet_" + _StoredProcedureName, _DataSetRdlForMainReport.Tables[0]);


                    Microsoft.Reporting.WebForms.ReportDataSource DataSource = new Microsoft.Reporting.WebForms.ReportDataSource("RDLReportDataSet_" + _StoredProcedureName, _DataSetRdlForMainReport.Tables[0]);
                    //Added by Chandan 0n 18th Dec 2008
                    //Session["DataSetRdlTemp"] = null;
                    DataSet dstemp = (DataSet)Session["DataSetRdlTemp"];
                    if (dstemp == null)
                        dstemp = _DataSetRdlForMainReport;
                    else
                        dstemp.Merge(_DataSetRdlForMainReport);
                    Session["DataSetRdlTemp"] = dstemp;
                    //HiddenFieldStoredProcedureName.Value = _StoredProcedureName;
                    //HiddenFieldReportName.Value = _ReportName;

                    #endregion

                    //Code addded by Loveena in ref to Task#2597                        
                    //Following parameters added with ref to Task 2371 SC-Support
                    _RptParam = new ReportParameter[3];
                    _RptParam[0] = new ReportParameter("PrescriberId", ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId.ToString());
                    _RptParam[1] = new ReportParameter("LastReviewTime", LabelReviewDateTime.Text);
                    _RptParam[2] = new ReportParameter("ServerTime", HiddenFieldRDLCurrentDateTime.Value);
                    reportViewer1.LocalReport.SetParameters(_RptParam);

                    reportViewer1.LocalReport.Refresh();
                    reportViewer1.LocalReport.DataSources.Add(DataSource);


                }


            }




            #endregion




            //Added by Rohit. Ref ticket#84
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

                    objRDLC.RunPreview(this.reportViewer1.LocalReport, Server.MapPath("RDLC\\" + Context.User.Identity.Name), ScriptId, false, false);

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
        finally
        {
            //    //Added by Vikas Vyas In ref to task 2334 On Dated March 04th 2008

            _DataSetGetRdlCName = null;
            _DataSetRdlForMainReport = null;
            _DataSetRdlForSubReport = null;
            _RptParam = null;
            ////End
        }

        #endregion
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


            for (int i = 0; i < ScriptArrays.Count; i++)
            {

                foreach (string file in Directory.GetFiles(Server.MapPath("RDLC\\" + Context.User.Identity.Name + "\\")))
                {
                    FileName = file.Substring(file.LastIndexOf("\\") + 1);
                    if ((FileName.IndexOf("JPEG") >= 0 || FileName.IndexOf("jpeg") >= 0) && (FileName.IndexOf(ScriptArrays[i].ToString(), 3) >= 0))
                        //strPageHtml += "<img src='.\\RDLC\\" + Context.User.Identity.Name + "\\" + ScriptArrays[i] + "\\" + FileName + "'/>";
                        strPageHtml += "<img src='.\\RDLC\\" + Context.User.Identity.Name + "\\" + FileName + "'/>";
                    //  strPageHtml += "<img src='\\RDLC\\" +  Context.User.Identity.Name  + file.ToString() + "'>";
                    //strPath = "'..\\RDLC\\" + Context.User.Identity.Name + "\\" + ScriptArrays[i] + "\\" + FileName;
                    strPath = "'..\\RDLC\\" + Context.User.Identity.Name + "\\" + FileName;
                    //ts.WriteLine("<img src='" + file.ToString() + "'>");
                }
            }


            divReportViewer.InnerHtml = "";
            divReportViewer.InnerHtml = strPageHtml;

            ts.Close();


        }
        catch (Exception ex)
        {
            throw (ex);
        }
    }

    protected void ButtonApprove_Click(object sender, EventArgs e)
    {
        int count = 0;
        new Streamline.UserBusinessServices.MedicationLogin();
        DataSet dsTemp = null;
        try
        {
            if (LabelErrorMessage.Text == "Your account is disabled.Please contact system administrator.")
                Response.Redirect("MedicationLogin.aspx");
            if (HiddenFieldFirstChance.Value == "")
                HiddenFieldFirstChance.Value = "0";

            if (HiddenFieldSecurityAnswer.Value.Trim().ToLower() == TextBoxAnswer.Text.Trim().ToLower())
            {
                ImageError.Style.Add("display", "none");
                ImageError.Style.Add("display", "none");
                LabelErrorMessage.Style.Add("display", "none");
                TextBoxAnswer.Focus();
                LabelErrorMessage.Text = "";
                objUserPreferences = new Streamline.UserBusinessServices.UserPrefernces();
                count = objUserPreferences.ApprovePrescription(((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId, ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).LastPrescriptionReviewTime, HiddenFieldRDLCurrentDateTime.Value);
                ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).LastPrescriptionReviewTime = HiddenFieldRDLCurrentDateTime.Value;
                ScriptManager.RegisterStartupScript(LabelErrorMessage, LabelErrorMessage.GetType(), ClientID.ToString(), "redirectToStartPage();", true);
                //return count;
            }
            else
            {
                HiddenFieldFirstChance.Value = Convert.ToString(Convert.ToInt32(HiddenFieldFirstChance.Value) + 1);
                if (Convert.ToInt32(HiddenFieldFirstChance.Value) >= 2)
                {
                    if (HiddenFieldSecondChance.Value == "")
                        HiddenFieldSecondChance.Value = "0";
                    HiddenFieldSecondChance.Value = Convert.ToString(Convert.ToInt32(HiddenFieldSecondChance.Value) + 1);
                    if (HiddenFieldSecondChance.Value == "1")
                    {
                        dsTemp = (DataSet)Session["DataSetSecurityQustion"];
                        Random random = new Random();
                        if (dsTemp != null)
                        {
                            int num = random.Next(0, dsTemp.Tables[0].Rows.Count);
                            if (dsTemp.Tables[0].Rows.Count > 0)
                            {
                                LabelSecurityQuestion.Text = dsTemp.Tables["StaffSecurityQuestion"].Rows[num]["CodeName"].ToString();
                                HiddenFieldSecurityAnswer.Value = dsTemp.Tables["StaffSecurityQuestion"].Rows[num]["SecurityAnswer"].ToString();
                            }

                        }
                    }
                    if (Convert.ToInt32(HiddenFieldSecondChance.Value) > 2)
                    {
                        objMedicationLogin = new Streamline.UserBusinessServices.MedicationLogin();
                        objMedicationLogin.chkCountLogin(((StreamlineIdentity)(Context.User.Identity)).UserCode);

                        ImageError.Style.Add("display", "block");
                        ImageError.Style.Add("display", "block");
                        LabelErrorMessage.Style.Add("display", "block");
                        TextBoxAnswer.Focus();
                        LabelErrorMessage.Text = "Your account is disabled.Please contact system administrator.";
                        return;
                    }


                }
                ImageError.Style.Add("display", "block");
                ImageError.Style.Add("display", "block");
                LabelErrorMessage.Style.Add("display", "block");
                TextBoxAnswer.Focus();
                LabelErrorMessage.Text = "The answers provided do not match the answers on record.";
            }

        }
        catch (Exception ex)
        {

            throw;
        }
    }
    protected void LinkButtonLogout_Click(object sender, EventArgs e)
    {
        Response.Redirect("MedicationLogin.aspx");
    }
}

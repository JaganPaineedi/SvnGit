using Streamline.BaseLayer;
using Streamline.UserBusinessServices;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Microsoft.Reporting.WebForms;
using System.Collections;
using System.Text;
using System.Drawing;
using System.Drawing.Imaging;
using System.Drawing.Drawing2D;
using DevExpress.Utils.Zip;
using System.IO;
using System.IO.Compression;

public partial class PreviewPharmacy : System.Web.UI.Page
{
    string _strScriptIds = "";
    Dictionary<string, string> ElectronicScriptMappingIds = new Dictionary<string, string>();
    DataSet DataSetTemp;
    char OrderingMethod;
    Streamline.UserBusinessServices.DataSets.DataSetClientScripts DataSetClientScriptActivities;
    DataSet DataSetPharmacies = null;
    DataRow[] drSelectedPharmacy;
    Streamline.UserBusinessServices.DataSets.DataSetClientMedications DataSetClientMedications_Temp;
    Streamline.UserBusinessServices.DataSets.DataSetClientMedications DataSetClientMedications_Temp1;
    Streamline.UserBusinessServices.ClientMedication ObjectClientMedication = null;
    Microsoft.Reporting.WebForms.ReportViewer reportViewer1;
    Streamline.UserBusinessServices.DataSets.DataSetClientMedications DataSetClientMedications;
    char OriginalOrderingMethod;
    byte[] renderedBytes;

    string strReceipeintName = "";
    string strReceipentOrganisation = "";
    string strReceipentFaxNumber = "";
    string _strChartScripts = "";
    bool _strChartCopiesToBePrinted = false;
    string _strFaxFailedScripts = "";
    bool _strFaxFailed = false;
    bool _strScriptsTobeFaxedButPrinted = false;
    string strSendCoverLetter = "false";
    string FolderId = string.Empty;
    bool _UpdateTempTables = false;
    string _DrugsOrderMethod = "";
    bool FlagForImagesDeletion = false;
    int PharmacyId = 0;
    private class ScriptMessageContainer
    {
        public string MessageId { get; set; }
        public string Message { get; set; }
    }
    List<ScriptMessageContainer> _scriptMessageContainer = new List<ScriptMessageContainer>();

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            CreateRDLCFile();
            DataSetClientMedications_Temp1 = new Streamline.UserBusinessServices.DataSets.DataSetClientMedications();
            DataSetClientMedications_Temp1 = (Streamline.UserBusinessServices.DataSets.DataSetClientMedications)Session["DataSetClientMedications"];
            DataSetClientMedications_Temp = (Streamline.UserBusinessServices.DataSets.DataSetClientMedications)DataSetClientMedications_Temp1.Copy();
            bool openElectronically = false;
            if (Session["DataSetTemp"] != null && Session["OrderingMethod"] != null)
            {
                DataSetTemp = Session["DataSetTemp"] as DataSet;
                if (DataSetTemp != null && DataSetTemp.Tables.Count > 0)
                {
                    for (int icount = 0; icount < DataSetTemp.Tables["ClientMedicationScripts"].Rows.Count; icount++)
                    {
                        OrderingMethod = Convert.ToChar(Session["OrderingMethod"]);
                        if (Session["ePrescription"] != null && Session["ePrescription"].ToString() == "True")
                        {
                            openElectronically = true;
                        }
                        OrderingMethod = Convert.ToChar(DataSetTemp.Tables["ClientMedicationScripts"].Rows[icount]["OrderingMethod"].ToString());

                        //Following code will be used to update ClientScriptActivities table
                        DataSetClientScriptActivities = new Streamline.UserBusinessServices.DataSets.DataSetClientScripts();

                        //Send Fax if ordering Method is Fax
                        char _OrderingMethod = Convert.ToChar(DataSetTemp.Tables["ClientMedicationScripts"].Rows[icount]["OrderingMethod"].ToString());
                        if (_OrderingMethod == 'P')
                        {
                            openElectronically = false;
                        }
                        if (OrderingMethod == 'F' && !openElectronically)
                        {
                            //get the Fax Number of Selected Pharmacy
                            Streamline.UserBusinessServices.SharedTables objectSharedTables = null;
                            objectSharedTables = new Streamline.UserBusinessServices.SharedTables();

                            int clientId = Session["ClientId"] != null ? Convert.ToInt32(Session["ClientId"]) : 0;
                            DataSetPharmacies = objectSharedTables.getPharmacies(clientId);
                            drSelectedPharmacy = DataSetPharmacies.Tables[0].Select("PharmacyId=" + DataSetClientMedications_Temp1.Tables["ClientMedicationScripts"].Rows[0]["PharmacyId"]);
                            if (drSelectedPharmacy != null && drSelectedPharmacy.Length > 0)
                            {
                                strReceipeintName = drSelectedPharmacy[0]["PharmacyName"].ToString();
                                strReceipentOrganisation = drSelectedPharmacy[0]["PharmacyName"].ToString();
                                strReceipentFaxNumber = drSelectedPharmacy[0]["FaxNumber"].ToString();

                            }
                            else if (Session["HiddenFieldPharmacyFaxNo"] != "" && DataSetClientMedications_Temp1.Tables["ClientMedicationScripts"] != null && DataSetClientMedications_Temp1.Tables["ClientMedicationScripts"].Rows.Count > 0 &&
                                     DataSetClientMedications_Temp1.Tables["ClientMedicationScripts"].Rows[0]["PharmacyId"] != System.DBNull.Value)
                            {
                                string pharmacyFaxNo = Session["HiddenFieldPharmacyFaxNo"].ToString();
                                strReceipentFaxNumber = pharmacyFaxNo;
                            }

                            //for (int icount = 0;
                            //    icount < DataSetTemp.Tables["ClientMedicationScripts"].Rows.Count;
                            //    icount++)
                            //{
                            if (icount == 0)
                                FlagForImagesDeletion = true;
                            else
                                FlagForImagesDeletion = false;
                            _strScriptsTobeFaxedButPrinted = false;

                            //Check if Drugs in this Script are  Non-Controlled Drugs or Controlled Drugs
                            string strSelectClause = "ISNULL(DrugCategory,0)<>0  and  ClientMedicationScriptId=" + DataSetTemp.Tables["ClientMedicationScripts"].Rows[icount]["ClientMedicationScriptId"].ToString();
                            if (DataSetTemp.Tables["ClientMedicationScriptDrugs"].Select(strSelectClause).Length > 0)
                            {
                                _strScriptsTobeFaxedButPrinted = true;
                            }

                            if (_strScriptsTobeFaxedButPrinted)
                            {
                                if (Session["HiddenFieldRedirectFrom"] != null && Session["HiddenFieldRedirectFrom"].ToString().ToUpper() == "DASHBOARD")
                                {
                                    if (Session["HiddenFieldClickedImage"].ToString().ToUpper() == "APPROVED")
                                    {
                                        bool ans = SendToPrinter(Convert.ToInt32(DataSetTemp.Tables["ClientMedicationScripts"].Rows[icount]["ClientMedicationScriptId"]), FlagForImagesDeletion, strSendCoverLetter, "A", _OrderingMethod);
                                    }
                                    else if (Session["HiddenFieldClickedImage"] != null && Session["HiddenFieldClickedImage"].ToString().ToUpper() == "APPROVEDWITHCHANGES")
                                    {
                                        bool ans = SendToPrinter(Convert.ToInt32(DataSetTemp.Tables["ClientMedicationScripts"].Rows[icount]["ClientMedicationScriptId"]), FlagForImagesDeletion, strSendCoverLetter, "C", _OrderingMethod);
                                    }
                                    else if (Session["HiddenFieldClickedImage"] != null && Session["HiddenFieldClickedImage"].ToString().ToUpper() == "DENIEDNEWPRESCRIPTIONS")
                                    {
                                        bool ans = SendToPrinter(Convert.ToInt32(DataSetTemp.Tables["ClientMedicationScripts"].Rows[icount]["ClientMedicationScriptId"]), FlagForImagesDeletion, strSendCoverLetter, "N", _OrderingMethod);
                                    }
                                    else
                                    {
                                        bool ans = SendToPrinter(Convert.ToInt32(DataSetTemp.Tables["ClientMedicationScripts"].Rows[icount]["ClientMedicationScriptId"]), FlagForImagesDeletion, strSendCoverLetter, "D", _OrderingMethod);
                                    }
                                }
                                else
                                {
                                    bool ans = SendToPrinter(Convert.ToInt32(DataSetTemp.Tables["ClientMedicationScripts"].Rows[icount]["ClientMedicationScriptId"]), FlagForImagesDeletion, strSendCoverLetter, "", _OrderingMethod);
                                }
                            }
                            else
                            {
                                if (Session["HiddenFieldRedirectFrom"] != null && Session["HiddenFieldRedirectFrom"].ToString().ToUpper() == "DASHBOARD")
                                {
                                    if (Session["HiddenFieldClickedImage"].ToString().ToUpper() == "APPROVED")
                                    {
                                        FaxChartCopyPreview(Convert.ToInt32(DataSetTemp.Tables["ClientMedicationScripts"].Rows[icount]["ClientMedicationScriptId"]), strSendCoverLetter, "A");
                                    }
                                    else if (Session["HiddenFieldClickedImage"] != null && Session["HiddenFieldClickedImage"].ToString().ToUpper() == "APPROVEDWITHCHANGES")
                                    {
                                        FaxChartCopyPreview(Convert.ToInt32(DataSetTemp.Tables["ClientMedicationScripts"].Rows[icount]["ClientMedicationScriptId"]), strSendCoverLetter, "C");
                                    }
                                    else if (Session["HiddenFieldClickedImage"] != null && Session["HiddenFieldClickedImage"].ToString().ToUpper() == "DENIEDNEWPRESCRIPTIONS")
                                    {
                                        FaxChartCopyPreview(Convert.ToInt32(DataSetTemp.Tables["ClientMedicationScripts"].Rows[icount]["ClientMedicationScriptId"]), strSendCoverLetter, "N");
                                    }
                                    else
                                    {
                                        FaxChartCopyPreview(Convert.ToInt32(DataSetTemp.Tables["ClientMedicationScripts"].Rows[icount]["ClientMedicationScriptId"]), strSendCoverLetter, "D");
                                    }
                                }
                                else
                                {
                                    FaxChartCopyPreview(Convert.ToInt32(DataSetTemp.Tables["ClientMedicationScripts"].Rows[icount]["ClientMedicationScriptId"]), strSendCoverLetter, "");
                                }
                            }
                            //}
                        }
                        else if ((OrderingMethod == 'P' || OrderingMethod == 'A') && !openElectronically)
                        {
                            //for (int icount = 0;
                            //    icount < DataSetTemp.Tables["ClientMedicationScripts"].Rows.Count;
                            //    icount++)
                            //{
                            if (DataSetTemp.Tables["ClientMedicationScripts"].Rows[icount]["RecordDeleted"] != "Y")
                            {
                                
                                if (icount == 0)
                                {
                                    FlagForImagesDeletion = true;
                                }
                                else
                                {
                                    FlagForImagesDeletion = false;
                                }

                                if (Session["HiddenFieldRedirectFrom"] != null && Session["HiddenFieldRedirectFrom"].ToString().ToUpper() == "DASHBOARD")
                                {
                                    if (Session["HiddenFieldClickedImage"] != null && Session["HiddenFieldClickedImage"].ToString().ToUpper() == "APPROVED")
                                    {
                                        bool ans = SendToPrinter(Convert.ToInt32(DataSetTemp.Tables["ClientMedicationScripts"].Rows[icount]["ClientMedicationScriptId"]), FlagForImagesDeletion, strSendCoverLetter, "A", _OrderingMethod);
                                    }
                                    else if (Session["HiddenFieldClickedImage"] != null && Session["HiddenFieldClickedImage"].ToString().ToUpper() == "APPROVEDWITHCHANGES")
                                    {
                                        bool ans = SendToPrinter(Convert.ToInt32(DataSetTemp.Tables["ClientMedicationScripts"].Rows[icount]["ClientMedicationScriptId"]), FlagForImagesDeletion, strSendCoverLetter, "C", _OrderingMethod);
                                    }
                                    else if (Session["HiddenFieldClickedImage"] != null && Session["HiddenFieldClickedImage"].ToString().ToUpper() == "DENIEDNEWPRESCRIPTIONS")
                                    {
                                        bool ans = SendToPrinter(Convert.ToInt32(DataSetTemp.Tables["ClientMedicationScripts"].Rows[icount]["ClientMedicationScriptId"]), FlagForImagesDeletion, strSendCoverLetter, "N", _OrderingMethod);
                                    }
                                    else
                                    {
                                        bool ans = SendToPrinter(Convert.ToInt32(DataSetTemp.Tables["ClientMedicationScripts"].Rows[icount]["ClientMedicationScriptId"]), FlagForImagesDeletion, strSendCoverLetter, "D", _OrderingMethod);
                                    }
                                }
                                else
                                {
                                    bool ans = SendToPrinter(Convert.ToInt32(DataSetTemp.Tables["ClientMedicationScripts"].Rows[icount]["ClientMedicationScriptId"]), FlagForImagesDeletion, strSendCoverLetter, "", _OrderingMethod);
                                }

                            }
                            //}
                        }
                        if (openElectronically)
                        {
                            OpenElectronicPDF(icount);
                        }
                        if (OrderingMethod == 'E' && !openElectronically)
                        {
                            bool ans = SendToPrinter(Convert.ToInt32(DataSetTemp.Tables["ClientMedicationScripts"].Rows[icount]["ClientMedicationScriptId"]), FlagForImagesDeletion, strSendCoverLetter, "", _OrderingMethod);
                        }
                    }
                }

                if (Convert.ToInt32(Session["OriginalDataUpdated"]) == 0)
                {
                    if (DataSetClientMedications_Temp1.Tables["ClientMedicationScripts"].Rows[0]["LocationId"] != System.DBNull.Value)
                        ShowReport(_strScriptIds, _strChartScripts);
                }
            }
        }
        catch (Exception ex)
        {
            throw (ex);
        }
    }

    private void OpenElectronicPDF(int icount)
    {
        _DrugsOrderMethod = Convert.ToString(Session["_DrugsOrderMethod"]);
        if (_DrugsOrderMethod.ToUpper() != "ADJUST")
        {
            //for (int icount = 0;
            //    icount < DataSetTemp.Tables["ClientMedicationScripts"].Rows.Count;
            //    icount++)
            //{
            if (icount == 0)
                FlagForImagesDeletion = true;
            else
                FlagForImagesDeletion = false;

            if (DataSetClientMedications_Temp1.Tables["ClientMedicationScripts"].Rows[0]["PharmacyId"] != System.DBNull.Value)
                PharmacyId = Convert.ToInt32(DataSetClientMedications_Temp1.Tables["ClientMedicationScripts"].Rows[0]["PharmacyId"]);

            if (Session["HiddenFieldRedirectFrom"] != null && Session["HiddenFieldRedirectFrom"].ToString().ToUpper() == "DASHBOARD")
            {
                if (Session["HiddenFieldClickedImage"] != null && Session["HiddenFieldClickedImage"].ToString().ToUpper() == "APPROVED")
                {
                    bool ans = SendByElectronically(Convert.ToInt32(DataSetTemp.Tables["ClientMedicationScripts"].Rows[icount]["ClientMedicationScriptId"]), PharmacyId, FlagForImagesDeletion, strSendCoverLetter, "A");
                }
                else if (Session["HiddenFieldClickedImage"] != null && Session["HiddenFieldClickedImage"].ToString().ToUpper() == "APPROVEDWITHCHANGES")
                {
                    bool ans = SendByElectronically(Convert.ToInt32(DataSetTemp.Tables["ClientMedicationScripts"].Rows[icount]["ClientMedicationScriptId"]), PharmacyId, FlagForImagesDeletion, strSendCoverLetter, "C");
                }
                else if (Session["HiddenFieldClickedImage"] != null && Session["HiddenFieldClickedImage"].ToString().ToUpper() == "DENIEDNEWPRESCRIPTIONS")
                {
                    bool ans = SendByElectronically(Convert.ToInt32(DataSetTemp.Tables["ClientMedicationScripts"].Rows[icount]["ClientMedicationScriptId"]), PharmacyId, FlagForImagesDeletion, strSendCoverLetter, "N");
                }
                else
                {
                    bool ans = SendByElectronically(Convert.ToInt32(DataSetTemp.Tables["ClientMedicationScripts"].Rows[icount]["ClientMedicationScriptId"]), PharmacyId, FlagForImagesDeletion, strSendCoverLetter, "D");
                }
            }
            else
            {
                bool ans = SendByElectronically(Convert.ToInt32(DataSetTemp.Tables["ClientMedicationScripts"].Rows[icount]["ClientMedicationScriptId"]), PharmacyId, FlagForImagesDeletion, strSendCoverLetter, "");
            }
        }
    }

    private void CreateRDLCFile()
    {
        string _DrugsOrderMethod = Convert.ToString(Session["_DrugsOrderMethod"]);
        string FileName = "";
        int seq = 1;
        if (Session["DataSetPrescribedClientMedications"] != null)
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
                            while (seq < 1000)
                            {
                                seq = seq + 1;
                                if (!System.IO.File.Exists(Server.MapPath("RDLC\\" + Context.User.Identity.Name + "\\JPEGS") + "\\" +FileName))
                                {
                                    System.IO.File.Move(file,Server.MapPath("RDLC\\" + Context.User.Identity.Name + "\\JPEGS") + "\\" +FileName);
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
            else
            {
                try
                {
                    using (Streamline.BaseLayer.RDLCPrint objRDLC = new RDLCPrint())
                    {
                        objRDLC.DeleteRenderedImages(Server.MapPath("RDLC\\" + Context.User.Identity.Name));
                    }
                }
                catch (Exception ex)
                {
                    Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General,
                        LogManager.LoggingLevel.Error, this);
                }
            }
        }
    }

    /// <summary>
    /// Added by Sonia to get and render the RDLC Contents of Script in PDF format or images
    /// </summary>
    /// <param name="ScriptId"></param>
    /// <param name="ToBeFaxed"></param>
    /// <param name="FlagForImagesDeletion"></param>
    /// <param name="OrderingMethod"></param>
    public void GetRDLCContents(int ScriptId, bool ToBeFaxed, bool FlagForImagesDeletion, string OrderingMethod, string SendCoveLetter, string RefillResponseType)
    {
        #region Get RDLC Contents

        string _ReportPath = "";
        string mimeType;
        string encoding;
        string fileNameExtension;
        string[] streams;

        string _PrintChartCopy = "N";
        if (Session["IncludeChartcopy"] == "Y")
            _PrintChartCopy = "Y";
        else
            _PrintChartCopy = "N";

        DataSet _DataSetGetRdlCName = null;
        DataSet _DataSetRdlForMainReport = null;
        DataSet _DataSetRdlForSubReport = null;
        DataRow[] dr = null;
        DataRow[] _drSubReport = null;
        string _OrderingMethod = "";
        string strErrorMessage = "";
        LogManager objLogManager = null;

        Microsoft.Reporting.WebForms.ReportParameter[] _RptParam = null;
        int LocationId = 1;
        //End
        //Block For ReportPath
        reportViewer1 = new Microsoft.Reporting.WebForms.ReportViewer();

        try
        {

            _ReportPath = Server.MapPath(".") + System.Configuration.ConfigurationManager.AppSettings["MedicationPerscriptionReportUrl"];
            if (_ReportPath == "")//Check For Report Path
            {
                strErrorMessage = "ReportPath is Missing In WebConfig";
                ScriptManager.RegisterStartupScript(LabelClientScript, LabelClientScript.GetType(), ClientID.ToString(), "PharmacyPreview.ShowError('" + strErrorMessage + "', true);", true);
                return;
            }
        }
        catch (Exception ex)
        {
            Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);

            strErrorMessage = "ReportPath Key is Missing In WebConfig";
            ScriptManager.RegisterStartupScript(LabelClientScript, LabelClientScript.GetType(), ClientID.ToString(), "PharmacyPreview.ShowError('" + strErrorMessage + "', true);", true);
            return;

        }
        finally
        {
            objLogManager = null;

        }

        try
        {

            //  _DataSetRdl = new DataSet();//Commented by Vikas Vyas On Dated March 04 2008
            Streamline.UserBusinessServices.ClientMedication objectClientMedications = null;
            objectClientMedications = new ClientMedication();
            DataSetClientMedications = new Streamline.UserBusinessServices.DataSets.DataSetClientMedications();
            DataSetClientMedications = (Streamline.UserBusinessServices.DataSets.DataSetClientMedications)Session["DataSetClientMedications"];
            //Added by Chandan for getting Location Id
            //LocationId = Convert.ToInt32(DropDownListLocations.SelectedValue);
            if (_UpdateTempTables == true)
            {
                if (DataSetClientMedications_Temp1.Tables["ClientMedicationScripts"].Rows[0]["LocationId"] != System.DBNull.Value)
                    LocationId = Convert.ToInt32(DataSetClientMedications_Temp1.Tables["ClientMedicationScripts"].Rows[0]["LocationId"]);
            }
            else
            {
                if (DataSetClientMedications.Tables["ClientMedicationScripts"].Rows[0]["LocationId"] != System.DBNull.Value)
                    LocationId = Convert.ToInt32(DataSetClientMedications.Tables["ClientMedicationScripts"].Rows[0]["LocationId"]);
            }
            if (LocationId == 0)
                LocationId = 1;
            #region Added by Vikas Vyas
            //Get the Name of the Rdlc,StoredProcedure from DocumentCodes,DocumentCodesRDLSubReports
            //Modifed in Ref to Task#2596.
            //if (ToBeFaxed == false)
            if (OrderingMethod == "P")
                _DataSetGetRdlCName = objectClientMedications.GetRdlCNameDataBase(502);
            else if (OrderingMethod == "F")
                _DataSetGetRdlCName = objectClientMedications.GetRdlCNameDataBase(501);
            else if (OrderingMethod == "X" && OriginalOrderingMethod == 'F')
                _DataSetGetRdlCName = objectClientMedications.GetRdlCNameDataBase(502);
            else
                _DataSetGetRdlCName = objectClientMedications.GetRdlCNameDataBase(1471);

            _DataSetGetRdlCName.Tables[0].TableName = "DocumentCodes";
            _DataSetGetRdlCName.Tables[1].TableName = "DocumentCodesRDLSubReports";


            if (_DataSetGetRdlCName.Tables["DocumentCodes"].Rows.Count > 0)
            {
                dr = _DataSetGetRdlCName.Tables["DocumentCodes"].Select();//because DocumentCodes table only contain one row

                //Commented by Sonia as now Ordering Method will be passed as a parameter to GetRDLC function
                /*    if (ToBeFaxed == true)
                    _OrderingMethod = "F";
                else
                    _OrderingMethod = "P";*/

                _OrderingMethod = OrderingMethod;


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
                    _DataSetRdlForMainReport = objectClientMedications.GetDataForRdlC(_StoredProcedureName, ScriptId, _OrderingMethod, Convert.ToInt32(Session["OriginalDataUpdated"]), LocationId, _PrintChartCopy, Session.SessionID, RefillResponseType);
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
                    if (_DataSetGetRdlCName.Tables["DocumentCodesRDLSubReports"].Rows.Count > 0)
                    {

                        _drSubReport = _DataSetGetRdlCName.Tables["DocumentCodesRDLSubReports"].Select();

                        reportViewer1.LocalReport.SubreportProcessing -= new Microsoft.Reporting.WebForms.SubreportProcessingEventHandler(SetSubDataSource);
                        reportViewer1.LocalReport.SubreportProcessing += new Microsoft.Reporting.WebForms.SubreportProcessingEventHandler(SetSubDataSource);

                        for (int i = 0; i < _drSubReport.Length; i++)//Loop 
                        {
                            if ((_drSubReport[i]["SubReportName"] != DBNull.Value || !String.IsNullOrEmpty(_drSubReport[i]["SubReportName"].ToString())) && (_drSubReport[i]["StoredProcedure"] != DBNull.Value || !String.IsNullOrEmpty(_drSubReport[i]["StoredProcedure"].ToString())))
                            {
                                #region Get the StoredProcedureName For SubReport and Execute
                                string _SubReportStoredProcedure = "";
                                string _SubReportName = "";
                                _SubReportStoredProcedure = _drSubReport[i]["StoredProcedure"].ToString();
                                _SubReportName = _drSubReport[i]["SubReportName"].ToString();
                                //Get Data For SubReport
                                //Added By Chandan Task#85 MM #1.7
                                _DataSetRdlForSubReport = objectClientMedications.GetDataForRdlC(_SubReportStoredProcedure, ScriptId, _OrderingMethod, Convert.ToInt32(Session["OriginalDataUpdated"]), LocationId, _PrintChartCopy, Session.SessionID, RefillResponseType);

                                Microsoft.Reporting.WebForms.ReportDataSource rds = new Microsoft.Reporting.WebForms.ReportDataSource(_SubReportName, _DataSetRdlForSubReport.Tables[0]);
                                reportViewer1.LocalReport.DataSources.Add(rds);
                                string strRootPath = Server.MapPath(".");

                                System.IO.StreamReader RdlSubReport = new System.IO.StreamReader(_ReportPath + "\\" + _SubReportName.Trim() + ".rdlc");

                                reportViewer1.LocalReport.LoadReportDefinition(RdlSubReport);


                                #endregion

                            }

                        }//End For Loop


                    }
                    //Code addded by Loveena in ref to Task#2597                        
                    if (OrderingMethod == "F" && ToBeFaxed == true)
                    {
                        if (_DataSetRdlForMainReport.Tables[0].Rows.Count > 0)
                        {
                            SendCoveLetter = _DataSetRdlForMainReport.Tables[0].Rows[0]["ShowCoverLetter"].ToString();
                        }
                    }
                    //Following parameters added with ref to Task 2371 SC-Support
                    _RptParam = new ReportParameter[3];
                    _RptParam[0] = new ReportParameter("ScriptId", ScriptId.ToString());
                    _RptParam[1] = new ReportParameter("OrderingMethod", OrderingMethod);
                    _RptParam[2] = new ReportParameter("CoverLetter", SendCoveLetter);

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

            FolderId = ScriptId.ToString() + "_" + DateTime.Now.ToString("MMddyyyymmhhss");
            //Code Added by Vikas Vyas In ref to 2334
            if (ToBeFaxed == false)
            {
                try
                {
                    using (Streamline.BaseLayer.RDLCPrint objRDLC = new RDLCPrint())
                    {

                        //Code commented by Loveena in ref to Task#86 to avoid the problem of  image is still pending on print job then it will through a exception that can't delete image is used by another process
                        //In case of Ordering method as X Chart copy will be printed
                        if (OrderingMethod == "X")
                            //Modified in ref to Task#2660
                            //objRDLC.Run(this.reportViewer1.LocalReport, Server.MapPath("RDLC\\" + Context.User.Identity.Name), ScriptId.ToString(), FlagForImagesDeletion, true);
                            objRDLC.Run(this.reportViewer1.LocalReport, Server.MapPath("RDLC\\" + Context.User.Identity.Name), FolderId, FlagForImagesDeletion, true);
                        else  //In case of Ordering method as P Chart copy will not be printed
                            //Modified in ref to Task#2660
                            //objRDLC.Run(this.reportViewer1.LocalReport, Server.MapPath("RDLC\\" + Context.User.Identity.Name), ScriptId.ToString(), FlagForImagesDeletion, false);
                            objRDLC.Run(this.reportViewer1.LocalReport, Server.MapPath("RDLC\\" + Context.User.Identity.Name), FolderId, FlagForImagesDeletion, false);

                        //Added by Rohit. Ref ticket#84
                        renderedBytes = reportViewer1.LocalReport.Render(reportType, deviceInfo, out mimeType, out encoding, out fileNameExtension, out streams, out warnings);

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
            //if (ToBeFaxed)//Commented by Vikas Vyas In ref to 2334
            else
            {
                renderedBytes = reportViewer1.LocalReport.Render(reportType, deviceInfo, out mimeType, out encoding, out fileNameExtension, out streams, out warnings);
                // Create PDF from rendered Bytes to send as an attachment
                string strScriptRenderingPath = Server.MapPath("RDLC") + "\\" + Context.User.Identity.Name;
                //  string strPath = "RDLC\\" + 
                if (!System.IO.Directory.Exists(strScriptRenderingPath))
                    System.IO.Directory.CreateDirectory(strScriptRenderingPath);
                Stream fs = new FileStream(strScriptRenderingPath + "\\MedicationScript.pdf", FileMode.Create);
                fs.Write(renderedBytes, 0, renderedBytes.Length);
                fs.Close();
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

    /// <summary>
    /// 
    /// </summary>
    /// <param name="ScriptId"></param>
    /// <param name="FlagForImagesDeletion"></param>
    /// <param name="SendCoveLetter"></param>
    /// <param name="RefillResponseType"></param>
    /// <returns></returns>
    /// ---------Modification History-------------------------------------
    /// ----Date------Author-----------Purpose----------------------------
    /// 14 March 2011 Pradeep          Added one more parameter RefillResponseType as per task#3336
    public bool SendToPrinter(int ScriptId, bool FlagForImagesDeletion, string SendCoveLetter, string RefillResponseType, char orderMethod)
    {
        #region Sending Results to printer
        // Declare objects
        DataSet DataSetTemp = null;
        try
        {

            //GetRDLCContents(ScriptId, false, FlagForImagesDeletion, "P", SendCoveLetter, RefillResponseType);
            GetRDLCContents(ScriptId, false, FlagForImagesDeletion, orderMethod.ToString(), SendCoveLetter, RefillResponseType);

            if (_strScriptIds == "")
            {
                _strScriptIds += FolderId;
            }
            else
            {
                _strScriptIds += "^" + FolderId;
            }

            if (orderMethod != 'A')
            {
                #region InsertRowsIntoClientScriptActivities
                ////Insert Rows into ClientScriptActivities
                DataRow drClientMedicationScriptsActivity = DataSetClientScriptActivities.Tables["ClientMedicationScriptActivities"].NewRow();
                drClientMedicationScriptsActivity["ClientMedicationScriptId"] = ScriptId;
                drClientMedicationScriptsActivity["Method"] = 'P';
                drClientMedicationScriptsActivity["PharmacyId"] = System.DBNull.Value;
                drClientMedicationScriptsActivity["Reason"] = System.DBNull.Value;
                drClientMedicationScriptsActivity["FaxStatusDate"] = DateTime.Now;
                //drClientMedicationScriptsActivity["FaxStatus"] = System.DBNull.Value;
                //Added by Anuj on 24 feb, for task ref 85
                drClientMedicationScriptsActivity["Status"] = System.DBNull.Value;
                drClientMedicationScriptsActivity["StatusDescription"] = System.DBNull.Value;
                //ended over here
                drClientMedicationScriptsActivity["FaxExternalIdentifier"] = System.DBNull.Value;

                //Added By chandan for task #85 
                //Modified by Loveena in ref to Task#3243 Sure Script:- Include Chart copy option is not working.
                //if (CheckBoxPrintChartCopy.Checked == true)
                if (Session["IncludeChartcopy"] == "Y")
                    drClientMedicationScriptsActivity["IncludeChartCopy"] = "Y";
                else
                    drClientMedicationScriptsActivity["IncludeChartCopy"] = "N";

                drClientMedicationScriptsActivity["RowIdentifier"] = System.Guid.NewGuid();
                drClientMedicationScriptsActivity["CreatedBy"] = Context.User.Identity.Name;
                drClientMedicationScriptsActivity["CreatedDate"] = DateTime.Now;
                drClientMedicationScriptsActivity["ModifiedBy"] = Context.User.Identity.Name;
                drClientMedicationScriptsActivity["ModifiedDate"] = DateTime.Now;
                DataSetClientScriptActivities.Tables["ClientMedicationScriptActivities"].Rows.Add(drClientMedicationScriptsActivity);
                using (
                    ClientMedication _clientMedication = ObjectClientMedication != null
                                                             ? ObjectClientMedication
                                                             : new ClientMedication())
                {
                    _clientMedication.SetRenderedImageData(DataSetClientScriptActivities,
                                                           drClientMedicationScriptsActivity,
                                                            Context.User.Identity.Name, renderedBytes);
                }

                #endregion

                #region InsertRowsIntoClientScriptActivityPending
                //Added by anuj on 25 feb,2010 fro task ref 85
                DataRow drClientMedicationScriptsActivityPending = DataSetClientScriptActivities.Tables["ClientMedicationScriptActivitiesPending"].NewRow();
                drClientMedicationScriptsActivityPending["ClientMedicationScriptActivityId"] = drClientMedicationScriptsActivity["ClientMedicationScriptActivityId"].ToString();
                drClientMedicationScriptsActivityPending["RowIdentifier"] = System.Guid.NewGuid();
                drClientMedicationScriptsActivityPending["CreatedBy"] = Context.User.Identity.Name;
                drClientMedicationScriptsActivityPending["CreatedDate"] = DateTime.Now;
                drClientMedicationScriptsActivityPending["ModifiedBy"] = Context.User.Identity.Name;
                drClientMedicationScriptsActivityPending["ModifiedDate"] = DateTime.Now;
                DataSetClientScriptActivities.Tables["ClientMedicationScriptActivitiesPending"].Rows.Add(drClientMedicationScriptsActivityPending);
                //Ended over here
                #endregion
            }
            return true;
        }
        catch (System.Runtime.InteropServices.COMException ex)
        {
            string strEx = ex.Message.ToString();
            throw (ex);
        }
        finally
        {
            DataSetTemp = null;
        }

        #endregion
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="ScriptId"></param>
    /// <param name="strSendCoverLetter"></param>
    /// ----------Modification History-----------------------------
    /// ------Date------Author--------Pyrpose----------------------
    /// 14 March 2011   Pradeep       Addedd one more parameter as per task#3336
    public void FaxChartCopyPreview(int ScriptId, string strSendCoverLetter, string RefillResponseType)
    {
        try
        {
            GetRDLCContentsFax(ScriptId, true, true, "F", strSendCoverLetter, RefillResponseType);
            _strChartCopiesToBePrinted = true;
            if (_strScriptIds == "")
            {
                _strScriptIds += FolderId;
            }
            else
            {
                _strScriptIds += "^" + FolderId;
            }
        }
        catch (Exception ex)
        {
            if (ex.Data["CustomExceptionInformation"] == null)
                ex.Data["CustomExceptionInformation"] = "Source function PrintChartCopy() of Prescribe Screen";
            else
                ex.Data["CustomExceptionInformation"] = "";
            if (ex.Data["DatasetInfo"] == null)
                ex.Data["DatasetInfo"] = null;
            Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);

        }

    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="ScriptId"></param>
    /// <param name="ToBeFaxed"></param>
    /// <param name="FlagForImagesDeletion"></param>
    /// <param name="OrderingMethod"></param>
    /// <param name="SendCoveLetter"></param>
    /// ---------Modification History----------------------------------
    /// ------Date-----Author----------Purpose-------------------------
    /// 14 March 2011  Pradeep        Added one more parameter as per task#3336
    public void GetRDLCContentsFax(int ScriptId, bool ToBeFaxed, bool FlagForImagesDeletion, string OrderingMethod, string SendCoveLetter, string RefillResponseType)
    {
        #region Get RDLC Contents

        string _ReportPath = "";
        string mimeType;
        string encoding;
        string fileNameExtension;
        string[] streams;

        //Added by Chandan for the task 2404 -1.7.2 - Prescribe Page: Print Chart Copy
        string _PrintChartCopy = "N";
        //Modified by Loveena in ref to Task#3243 Sure Script:- Include Chart copy option is not working.
        //if (CheckBoxPrintChartCopy.Checked == true)
        if (Session["IncludeChartcopy"] == "Y")
            _PrintChartCopy = "Y";
        else
            _PrintChartCopy = "N";

        //DataSet _DataSetRdl;

        //Code Added by Vikas Vyas 
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
        //End
        //Block For ReportPath
        reportViewer1 = new Microsoft.Reporting.WebForms.ReportViewer();

        try
        {

            _ReportPath = Server.MapPath(".") + System.Configuration.ConfigurationManager.AppSettings["MedicationPerscriptionReportUrl"];
            if (_ReportPath == "")//Check For Report Path
            {
                strErrorMessage = "ReportPath is Missing In WebConfig";
                ScriptManager.RegisterStartupScript(LabelClientScript, LabelClientScript.GetType(), ClientID.ToString(), "MedicationPrescribe.ShowError('" + strErrorMessage + "', true);", true);
                return;
            }
        }
        catch (Exception ex)
        {
            Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);

            strErrorMessage = "ReportPath Key is Missing In WebConfig";
            ScriptManager.RegisterStartupScript(LabelClientScript, LabelClientScript.GetType(), ClientID.ToString(), "MedicationPrescribe.ShowError('" + strErrorMessage + "', true);", true);
            return;

        }
        finally
        {
            objLogManager = null;

        }

        try
        {

            //  _DataSetRdl = new DataSet();//Commented by Vikas Vyas On Dated March 04 2008
            Streamline.UserBusinessServices.ClientMedication objectClientMedications = null;
            objectClientMedications = new ClientMedication();
            ////Added by Chandan for getting Location Id
            //LocationId = Convert.ToInt32(DropDownListLocations.SelectedValue);
            DataSetClientMedications = (Streamline.UserBusinessServices.DataSets.DataSetClientMedications)Session["DataSetClientMedications"];
            if (_UpdateTempTables == true)
            {
                if (DataSetClientMedications_Temp1.Tables["ClientMedicationScripts"].Rows[0]["LocationId"] != System.DBNull.Value)
                    LocationId = Convert.ToInt32(DataSetClientMedications_Temp1.Tables["ClientMedicationScripts"].Rows[0]["LocationId"]);
            }
            else
            {
                if (DataSetClientMedications.Tables["ClientMedicationScripts"].Rows[0]["LocationId"] != System.DBNull.Value)
                    LocationId = Convert.ToInt32(DataSetClientMedications.Tables["ClientMedicationScripts"].Rows[0]["LocationId"]);
            }
            if (LocationId == 0)
                LocationId = 1;
            #region Added by Vikas Vyas
            //Get the Name of the Rdlc,StoredProcedure from DocumentCodes,DocumentCodesRDLSubReports
            //Modifed in Ref to Task#2596.
            if (ToBeFaxed == false)
                _DataSetGetRdlCName = objectClientMedications.GetRdlCNameDataBase(502);
            else
                _DataSetGetRdlCName = objectClientMedications.GetRdlCNameDataBase(501);

            _DataSetGetRdlCName.Tables[0].TableName = "DocumentCodes";
            _DataSetGetRdlCName.Tables[1].TableName = "DocumentCodesRDLSubReports";


            if (_DataSetGetRdlCName.Tables["DocumentCodes"].Rows.Count > 0)
            {
                dr = _DataSetGetRdlCName.Tables["DocumentCodes"].Select();//because DocumentCodes table only contain one row

                //Commented by Sonia as now Ordering Method will be passed as a parameter to GetRDLC function
                /*    if (ToBeFaxed == true)
                    _OrderingMethod = "F";
                else
                    _OrderingMethod = "P";*/

                _OrderingMethod = OrderingMethod;


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
                    _DataSetRdlForMainReport = objectClientMedications.GetDataForRdlC(_StoredProcedureName, ScriptId, _OrderingMethod, Convert.ToInt32(Session["OriginalDataUpdated"]), LocationId, _PrintChartCopy, Session.SessionID, RefillResponseType);
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
                    if (_DataSetGetRdlCName.Tables["DocumentCodesRDLSubReports"].Rows.Count > 0)
                    {

                        _drSubReport = _DataSetGetRdlCName.Tables["DocumentCodesRDLSubReports"].Select();

                        reportViewer1.LocalReport.SubreportProcessing -= new Microsoft.Reporting.WebForms.SubreportProcessingEventHandler(SetSubDataSource);
                        reportViewer1.LocalReport.SubreportProcessing += new Microsoft.Reporting.WebForms.SubreportProcessingEventHandler(SetSubDataSource);

                        for (int i = 0; i < _drSubReport.Length; i++)//Loop 
                        {
                            if ((_drSubReport[i]["SubReportName"] != DBNull.Value || !String.IsNullOrEmpty(_drSubReport[i]["SubReportName"].ToString())) && (_drSubReport[i]["StoredProcedure"] != DBNull.Value || !String.IsNullOrEmpty(_drSubReport[i]["StoredProcedure"].ToString())))
                            {
                                #region Get the StoredProcedureName For SubReport and Execute
                                string _SubReportStoredProcedure = "";
                                string _SubReportName = "";
                                _SubReportStoredProcedure = _drSubReport[i]["StoredProcedure"].ToString();
                                _SubReportName = _drSubReport[i]["SubReportName"].ToString();
                                //Get Data For SubReport
                                //Added By Chandan Task#85 MM #1.7
                                _DataSetRdlForSubReport = objectClientMedications.GetDataForRdlC(_SubReportStoredProcedure, ScriptId, _OrderingMethod, Convert.ToInt32(Session["OriginalDataUpdated"]), LocationId, _PrintChartCopy, Session.SessionID, RefillResponseType);

                                Microsoft.Reporting.WebForms.ReportDataSource rds = new Microsoft.Reporting.WebForms.ReportDataSource(_SubReportName, _DataSetRdlForSubReport.Tables[0]);
                                reportViewer1.LocalReport.DataSources.Add(rds);
                                string strRootPath = Server.MapPath(".");

                                System.IO.StreamReader RdlSubReport = new System.IO.StreamReader(_ReportPath + "\\" + _SubReportName.Trim() + ".rdlc");

                                reportViewer1.LocalReport.LoadReportDefinition(RdlSubReport);


                                #endregion
                            }

                        }//End For Loop
                    }
                    //Code addded by Loveena in ref to Task#2597                        
                    if (OrderingMethod == "F" && ToBeFaxed == true)
                    {
                        if (_DataSetRdlForMainReport.Tables[0].Rows.Count > 0)
                        {
                            SendCoveLetter = _DataSetRdlForMainReport.Tables[0].Rows[0]["ShowCoverLetter"].ToString();
                        }
                    }
                    //Following parameters added with ref to Task 2371 SC-Support
                    _RptParam = new ReportParameter[3];
                    _RptParam[0] = new ReportParameter("ScriptId", ScriptId.ToString());
                    _RptParam[1] = new ReportParameter("OrderingMethod", OrderingMethod);
                    _RptParam[2] = new ReportParameter("CoverLetter", SendCoveLetter);
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

            FolderId = ScriptId.ToString() + "_" + DateTime.Now.ToString("MMddyyyymmhhss");
            try
            {
                using (Streamline.BaseLayer.RDLCPrint objRDLC = new RDLCPrint())
                {
                    //In case of Ordering method as X Chart copy will be printed
                    if (OrderingMethod == "X")
                        objRDLC.Run(this.reportViewer1.LocalReport, Server.MapPath("RDLC\\" + Context.User.Identity.Name), FolderId, FlagForImagesDeletion, true);
                    else  //In case of Ordering method as P Chart copy will not be printed
                        objRDLC.Run(this.reportViewer1.LocalReport, Server.MapPath("RDLC\\" + Context.User.Identity.Name), FolderId, FlagForImagesDeletion, false);

                    //Added by Rohit. Ref ticket#84
                    renderedBytes = reportViewer1.LocalReport.Render(reportType, deviceInfo, out mimeType, out encoding, out fileNameExtension, out streams, out warnings);

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

    /// <summary>
    /// Author Vikas Vyas
    /// Purpose To render the Sub report of RDLC
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    public void SetSubDataSource(object sender, Microsoft.Reporting.WebForms.SubreportProcessingEventArgs e)
    {
        try
        {
            Microsoft.Reporting.WebForms.LocalReport rptTemp = (Microsoft.Reporting.WebForms.LocalReport)sender;
            //Condition added by Loveena in ref to Task#2596
            if (rptTemp.DataSources[e.ReportPath.Trim()] != null)
            {
                DataTable dtTemp = (DataTable)rptTemp.DataSources[e.ReportPath.Trim()].Value;
                e.DataSources.Add(new Microsoft.Reporting.WebForms.ReportDataSource(e.DataSourceNames[0], dtTemp));
            }
        }
        catch (Exception ex)
        {
            Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);

        }
    }

    public bool SendByElectronically(int ScriptId, int PharmacyId, bool FlagForImagesDeletion, string SendCoveLetter, string RefillResponseType)
    {
        try
        {
            GetRDLCContents(ScriptId, false, FlagForImagesDeletion, "E", SendCoveLetter, RefillResponseType);
            _strScriptIds += (_strScriptIds != "" ? "^" : "") + ScriptId;

            DataSetClientScriptActivities = new Streamline.UserBusinessServices.DataSets.DataSetClientScripts();
            DataRow drClientMedicationScriptsActivity = DataSetClientScriptActivities.Tables["ClientMedicationScriptActivities"].NewRow();
            drClientMedicationScriptsActivity["ClientMedicationScriptId"] = ScriptId;
            drClientMedicationScriptsActivity["Method"] = 'E';
            drClientMedicationScriptsActivity["PharmacyId"] = PharmacyId;
            drClientMedicationScriptsActivity["Reason"] = System.DBNull.Value;
            drClientMedicationScriptsActivity["FaxStatusDate"] = DateTime.Now;
            drClientMedicationScriptsActivity["Status"] = 5561;
            drClientMedicationScriptsActivity["StatusDescription"] = System.DBNull.Value;
            drClientMedicationScriptsActivity["FaxExternalIdentifier"] = System.DBNull.Value;
            drClientMedicationScriptsActivity["IncludeChartCopy"] = Session["IncludeChartcopy"] == "Y" ? "Y" : "N";
            drClientMedicationScriptsActivity["RowIdentifier"] = System.Guid.NewGuid();
            drClientMedicationScriptsActivity["CreatedBy"] = Context.User.Identity.Name;
            drClientMedicationScriptsActivity["CreatedDate"] = DateTime.Now;
            drClientMedicationScriptsActivity["ModifiedBy"] = Context.User.Identity.Name;
            drClientMedicationScriptsActivity["ModifiedDate"] = DateTime.Now;
            DataSetClientScriptActivities.Tables["ClientMedicationScriptActivities"].Rows.Add(drClientMedicationScriptsActivity);

            DataRow drClientMedicationScriptsActivityPending = DataSetClientScriptActivities.Tables["ClientMedicationScriptActivitiesPending"].NewRow();
            drClientMedicationScriptsActivityPending["ClientMedicationScriptActivityId"] = drClientMedicationScriptsActivity["ClientMedicationScriptActivityId"].ToString();
            drClientMedicationScriptsActivityPending["RowIdentifier"] = System.Guid.NewGuid();
            drClientMedicationScriptsActivityPending["CreatedBy"] = Context.User.Identity.Name;
            drClientMedicationScriptsActivityPending["CreatedDate"] = DateTime.Now;
            drClientMedicationScriptsActivityPending["ModifiedBy"] = Context.User.Identity.Name;
            drClientMedicationScriptsActivityPending["ModifiedDate"] = DateTime.Now;
            DataSetClientScriptActivities.Tables["ClientMedicationScriptActivitiesPending"].Rows.Add(drClientMedicationScriptsActivityPending);
            return true;
        }
        catch (Exception ex)
        {
            throw (ex);
        }

        finally
        {
        }

    }

    /// <summary>
    /// Created by Chandan on 4th Dec 2088
    /// task #85 Build MM1.7
    /// showing rdl without update the databse</summary>
    /// <param name="_strScriptIds"></param>
    /// <param name="_strChartScriptIds"></param>
    public void ShowReport(string _strScriptIds, string _strChartScriptIds)
    {
        FileStream fs;
        TextWriter ts;
        ArrayList ScriptArrays;
        ArrayList ChartScriptArrays;
        bool _strFaxSendStatus = false;
        string _strFaxFaildMessage = "";
        string[] ClientMedicationscriptIds;
        ArrayList ScriptIdScriptMessage;
        string[] ScriptIds;
        string[] ScriptMessage;
        string[] ScriptIdMessage;
        ArrayList _arrListScriptId = null;
        ArrayList _arrListScriptMessage = null;
        ArrayList _arrListClientMedicationScriptId = null;
        ArrayList _arrListClintMedicationScriptId = null;
        string imagePath = string.Empty;
        Dictionary<string, string> filePathList = new Dictionary<string, string>();

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

            ChartScriptArrays = new ArrayList();
            ChartScriptArrays = ApplicationCommonFunctions.StringSplit(_strChartScriptIds, "^");

            #region--Code Added by Pradeep as on 21 Jan22011 as per task#3306

            if (_scriptMessageContainer.Count > 0)
            {
                _arrListClintMedicationScriptId = new ArrayList();
                //Getting ClientMedication ScriptId which is going to be prescribed start over here
                if (_strScriptIds.IndexOf("^") > 0)
                {
                    ClientMedicationscriptIds = _strScriptIds.Split('^');
                    for (int _count = 0; _count < ClientMedicationscriptIds.Length; _count++)
                    {
                        string[] clientMedicationScriptId = ClientMedicationscriptIds[_count].Split('_');
                        _arrListClintMedicationScriptId.Add(clientMedicationScriptId[0]);
                    }
                }
                else
                {
                    string[] clientMedicationScriptId = _strScriptIds.Split('_');
                    _arrListClintMedicationScriptId.Add(clientMedicationScriptId[0]);
                }

                _arrListScriptId = new ArrayList();
                _arrListScriptMessage = new ArrayList();
                foreach (ScriptMessageContainer scriptMessageContainer in _scriptMessageContainer)
                {
                    _arrListScriptId.Add(scriptMessageContainer.MessageId);
                    _arrListScriptMessage.Add(scriptMessageContainer.Message);
                }
            }


            #endregion
            for (int i = 0; i < ScriptArrays.Count; i++)
            {
                #region--Code Added by Pradeep as on 21 Jan22011 as per task#3306

                if (_scriptMessageContainer.Count > 0)
                {
                    if (_arrListClintMedicationScriptId.Count > 0 && _arrListScriptId.Count > 0)
                    {
                        // #ka 03312011 Added internal loop to break out multiple messages ACE # 3348
                        for (int i2 = 0, len = _arrListScriptId.Count; i2 < len; i2++)
                        {
                            if (_arrListClintMedicationScriptId[i].ToString() == _arrListScriptId[i2].ToString())
                            {

                                if (_arrListScriptMessage[i2].ToString() != string.Empty)
                                {
                                    StringBuilder stringBuilderObject = new StringBuilder();
                                    stringBuilderObject.Append("<table><tr><td");
                                    stringBuilderObject.Append(" ");
                                    stringBuilderObject.Append("style='font-family: Verdana; font-size:8pt;font-weight: bold;padding-left: 10px;margin-top: 10px; color:red;'");
                                    stringBuilderObject.Append(">");
                                    stringBuilderObject.Append(_arrListScriptMessage[i2]);
                                    stringBuilderObject.Append("</td></tr></table>");
                                    strPageHtml += stringBuilderObject;
                                }

                            }
                        }
                    }
                }
                #endregion
                foreach (string file in Directory.GetFiles(Server.MapPath("RDLC\\" + Context.User.Identity.Name + "\\")))
                {
                    FileName = file.Substring(file.LastIndexOf("\\") + 1);
                    if ((FileName.IndexOf("JPEG") >= 0 || FileName.IndexOf("jpeg") >= 0) && (FileName.IndexOf(ScriptArrays[i].ToString(), 3) >= 0))
                    {
                        strPageHtml += "<img src='.\\RDLC\\" + Context.User.Identity.Name + "\\" + FileName + "'/>";
                        imagePath = "RDLC\\" + Context.User.Identity.Name + "\\" + FileName;
                        filePathList.Add(FileName, imagePath);
                    }
                    strPath = "'..\\RDLC\\" + Context.User.Identity.Name + "\\" + FileName;
                    strPath = strPath.Replace(@"\", "/");
                }
            }

            ////Get the Images from ChartScripts Folder
            for (int i = 0; i < ChartScriptArrays.Count; i++)
            {
                if (Directory.Exists(Server.MapPath("RDLC\\" + Context.User.Identity.Name + "\\" + "ChartScripts" + "\\")))
                {
                    foreach (string file in Directory.GetFiles(Server.MapPath("RDLC\\" + Context.User.Identity.Name + "\\" + "ChartScripts" + "\\")))
                    {
                        FileName = file.Substring(file.LastIndexOf("\\") + 1);
                        if ((FileName.IndexOf("JPEG") >= 0 || FileName.IndexOf("jpeg") >= 0) && (FileName.IndexOf(ChartScriptArrays[i].ToString()) >= 0))
                            strPageHtml += "<img src='.\\RDLC\\" + Context.User.Identity.Name + "\\" + "ChartScripts" + "\\" + FileName + "'/>";
                        strPath = "'..\\RDLC\\" + Context.User.Identity.Name + "\\" + "ChartScripts" + "\\" + FileName;
                    }
                }
            }
            //byte[] photo = org_logo(imagePath);
            string pageHTMLWithWatermark = string.Empty;
            foreach (KeyValuePair<string, string> imageParameters in filePathList)
            {
                string phyisicalPathName=AddWatermark(imageParameters.Value, imageParameters.Key);
                pageHTMLWithWatermark += "<img src='.\\RDLC\\" + Context.User.Identity.Name + "\\" + phyisicalPathName + "'/>";
                pageHTMLWithWatermark = pageHTMLWithWatermark.Replace(@"\", "/");
            }

            divReportViewer.InnerHtml = "";
            divReportViewer.InnerHtml = pageHTMLWithWatermark;

            ts.Close();

        }
        catch (Exception ex)
        {
            throw (ex);
        }
        finally
        {
            _arrListScriptId = null;
            _arrListScriptMessage = null;
        }
    }

    private string AddWatermark(string virtualPath,string fileName)
    {
        string watermarkText = "VOID VOID VOID VOID VOID VOID";

        //Read the File into a Bitmap.
        using (Bitmap bmp = new Bitmap(System.IO.Path.Combine(AppDomain.CurrentDomain.BaseDirectory, virtualPath), false))
        {
            using (Graphics grp = Graphics.FromImage(bmp))
            {
                //Set the Color of the Watermark text.
                Brush brush = new SolidBrush(Color.Gray);

                double tangent = (double)bmp.Height /
                           (double)bmp.Width;

                // convert arctangent to degrees
                double angle = Math.Atan(tangent) * (180 / Math.PI);

                // Pythagoras here :-/
                // a^2 = b^2 + c^2 ; a = sqrt(b^2 + c^2)
                double halfHypotenuse = Math.Sqrt((bmp.Height
                                       * bmp.Height) +
                                       (bmp.Width *
                                       bmp.Width)) / 2;

                // Horizontally and vertically aligned the string
                // This makes the placement Point the physical 
                // center of the string instead of top-left.
                StringFormat stringFormat = new StringFormat();
                stringFormat.Alignment = StringAlignment.Center;
                stringFormat.LineAlignment = StringAlignment.Center;

                // Calculate the size of the string (Graphics
                // .MeasureString)
                // and see if it fits in the bitmap completely. 
                // If it doesn’t, strink the font and check 
                // again... and again until it does fit.
                FontStyle fontStyle = FontStyle.Regular;
                int maxFontSize = 75;
                string fontName = "Arial";
                Font font = new Font(fontName, maxFontSize,
                                     fontStyle);
                Color color = Color.FromArgb(40, Color.Gray);
                for (int i = maxFontSize; i > 0; i--)
                {
                    font = new Font(fontName, i, fontStyle);
                    SizeF sizef = grp.MeasureString(watermarkText,
                                   font, int.MaxValue);

                    double sin = Math.Sin(angle * (Math.PI / 180));
                    double cos = Math.Cos(angle * (Math.PI / 180));

                    double opp1 = sin * sizef.Width;
                    double adj1 = cos * sizef.Height;

                    double opp2 = sin * sizef.Height;
                    double adj2 = cos * sizef.Width;

                    if (opp1 + adj1 < bmp.Height &&
                        opp2 + adj2 < bmp.Width)
                    {
                        break;
                    }
                }

                grp.SmoothingMode = SmoothingMode.AntiAlias;
                grp.RotateTransform((float)angle);

                ////Set the Font and its size.
                //Font font = new System.Drawing.Font("Arial", 30, FontStyle.Bold, GraphicsUnit.Pixel);

                //Determine the size of the Watermark text.
                SizeF textSize = new SizeF();
                textSize = grp.MeasureString(watermarkText, font);
                grp.CompositingMode = CompositingMode.SourceOver;

                StringFormat sf = new StringFormat();
                sf.FormatFlags = StringFormatFlags.DirectionVertical;

                //Position the text and draw it on the image.
                Point position = new Point(10, 150);
                grp.DrawString(watermarkText, font, new SolidBrush(color), new Point((int)halfHypotenuse, 0), stringFormat);

                using (MemoryStream memoryStream = new MemoryStream())
                {
                    //Save the Watermarked image to the MemoryStream.
                    bmp.Save(memoryStream, ImageFormat.Jpeg);
                    System.Drawing.Image img = System.Drawing.Image.FromStream(memoryStream);
                    string phyisicalPathName = System.IO.Path.Combine(AppDomain.CurrentDomain.BaseDirectory, virtualPath);
                    string fileNameWithWatermark = string.Empty;
                    if (phyisicalPathName.Contains(".jpeg"))
                    {
                        int start = phyisicalPathName.IndexOf(".jpeg");
                        phyisicalPathName = phyisicalPathName.Insert(start, "_WatermarkAdded");
                        int index1 = phyisicalPathName.LastIndexOf('\\');
                        fileNameWithWatermark = phyisicalPathName.Remove(0, index1).Replace("\\", "");
                    }

                    img.Save(System.IO.Path.Combine(AppDomain.CurrentDomain.BaseDirectory, phyisicalPathName));

                    return fileNameWithWatermark;
                }
            }
        }
    }


    public byte[] org_logo(string filename)
    {
        string physicalFilePath = System.IO.Path.Combine(AppDomain.CurrentDomain.BaseDirectory, filename);
        byte[] photo = File.ReadAllBytes(physicalFilePath);
        return photo;
    }

}
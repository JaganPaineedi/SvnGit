using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.IO;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using System.Xml.Serialization;
using Microsoft.Reporting.WebForms;
using Streamline.BaseLayer;
using Streamline.UserBusinessServices;
using Streamline.UserBusinessServices.DataSets;
using SharedTables = Streamline.UserBusinessServices.SharedTables;

public partial class UserControls_MadicationPatientContent : BaseActivityPage
{
    private HiddenField HiddenFieldCheckImageClick;
    private HiddenField HiddenFieldClientmedicationIdForConsent;
    private HiddenField HiddenFieldImageClientmedicationConsentId;
    private HiddenField HiddenFieldImageConsentClick;
    private int _CustomWebDocumentCodeId;
    private DataSetCustomWebDocument _dsCustomDocuments;
    private byte[] renderedBytes;
    private ReportViewer reportViewer1;
    //Added By Anuj on 30Nov,2009 for task ref #18, SDI Venture 10
    //Ended over here
    protected override void Page_Load(object sender, EventArgs e)
    {
        if (((StreamlinePrinciple)Context.User).HasPermission(Permissions.ViewOnlyConsent))
        {
            ButtonRevokeHolder.Text =
                "<input type='hidden' id='ButtonRevoke' disabled='disabled' />";
        }
        else
        {
            ButtonRevokeHolder.Text =
                "<input type='button' id='ButtonRevoke' disabled='disabled' value='Revoke' class='btnimgexsmall' onclick='javascript:RevokeConsent();' />";
        }

        // ButtonSign.Focus();
        if (ConfigurationSettings.AppSettings["OpenFromSmartCare"].ToUpper() == "FALSE")
        {
            LinkButtonLogout.Style["display"] = "block";
            LinkButtonStartPage.Style["display"] = "block";
            //Response.Cache.SetNoServerCaching();
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.Cache.SetExpires(DateTime.Now - new TimeSpan(0, 0, 0));
            Response.Cache.SetLastModified(DateTime.Now);
            Response.Cache.SetAllowResponseInBrowserHistory(false);
            Response.Expires = 0;
            Response.Cache.SetNoStore();
            Response.AppendHeader("Pragma", "no-cache");
        }
    }

    public override void Activate()
    {
        try
        {
            LabelMedicalStaffName.Text = ((StreamlineIdentity)Context.User.Identity).LastName + ", " +
                                         ((StreamlineIdentity)Context.User.Identity).FirstName;
            //Code added by Loveena in ref to Task#3234 2.3 Show Client Demographics on All Client Pages 
            if (Session["DataSetClientSummary"] != null)
            {
                var _DataSetClientSummary = (DataSet)Session["DataSetClientSummary"];
                //Modified by Loveena in ref to Task#3265
                LabelClientName.Text =
                    _DataSetClientSummary.Tables["ClientInformation"].Rows[0]["ClientInformationLabel"].ToString();
            }
            FillDocumentCodes();
            FillRelationShips();

            RadioButtonMedicalStaff.Text = ((StreamlineIdentity)Context.User.Identity).LastName + ", " +
                                           ((StreamlineIdentity)Context.User.Identity).FirstName + " (Medical Staff)";
            RadioButtonPatient.Text = ((StreamlinePrinciple)Context.User).Client.LastName + ", " +
                                      ((StreamlinePrinciple)Context.User).Client.FirstName + " (Patient)";
            HiddenFieldImageConsentClick = (HiddenField)Page.FindControl("HiddenFieldImageConsentClick");
            HiddenFieldImageClientmedicationConsentId =
                (HiddenField)Page.FindControl("HiddenFieldImageClientmedicationConsentId");
            HiddenFieldClientmedicationIdForConsent =
                (HiddenField)Page.FindControl("HiddenFieldClientmedicationIdForConsent");
            HiddenFieldCheckImageClick = (HiddenField)Page.FindControl("HiddenFieldCheckImageClick");
            SetBrowsersUrl();
            CreateDocumentDataSet();
            ApplicationCommonFunctions objApplicationCommonFunctions = null;
            objApplicationCommonFunctions = new ApplicationCommonFunctions();
            DataSet SystemConfigurations = objApplicationCommonFunctions.GetSystemConfigurations();
            if (SystemConfigurations.Tables.Count > 0)
            {
                if (SystemConfigurations.Tables[0].Rows.Count > 0)
                {
                    DataRow dataRowSystemConfigs = SystemConfigurations.Tables[0].Rows[0];
                    if (dataRowSystemConfigs.Table.Columns.Contains("DocumentSignaturesNoPassword") &&
                        dataRowSystemConfigs["DocumentSignaturesNoPassword"].ToString() == "Y")
                    {
                        HiddenFieldDocumentSignaturesNoPassword.Value = "True";
                    }
                    HiddenFieldStaffPassword.Value = ((StreamlineIdentity)Context.User.Identity).Password;
                }
            }

            if (HiddenFieldImageConsentClick.Value != "" && HiddenFieldImageConsentClick.Value != null)
            {
                if (HiddenFieldImageConsentClick.Value == "Patient Consent")
                {
                    GetRDLCContents();
                }
                else
                {
                    LabelSignedNotSigned.Text = "Signed by Medical Staff";
                    RadioButtonPatient.Enabled = true;
                    RadioButtonPatient.Checked = true;
                    RadioButtonRelation.Enabled = true;
                    DropDownRelationShip.Enabled = true;
                    TextBoxSignatureName.Enabled = true;
                    GetRDLCContents();
                }
            }
            else
            {
                Session["VersionIdForConsentDetailPage"] = null;
            }
            RadioButtonMedicalStaff.Attributes.Add("onkeydown",
                                                   CommonFunctions.ReturnJSForClickEvent(ButtonSign.UniqueID));
            RadioButtonPatient.Attributes.Add("onkeydown", CommonFunctions.ReturnJSForClickEvent(ButtonSign.UniqueID));
            RadioButtonRelation.Attributes.Add("onkeydown", CommonFunctions.ReturnJSForClickEvent(ButtonSign.UniqueID));
            TextBoxSignatureName.Attributes.Add("onkeydown",
                                                "if(event.which || event.keyCode){if ((event.which == 13) || (event.keyCode == 13)) {document.getElementById('" +
                                                ButtonSign.UniqueID + "').click();return false;}} else {return true}; ");
            DropDownRelationShip.Attributes.Add("onkeydown", CommonFunctions.ReturnJSForClickEvent(ButtonSign.UniqueID));
        }
        catch (Exception ex)
        {
        }
    }

    private void FillDocumentCodes()
    {
        DataSet DataSetDocumentCode = null;
        try
        {
            DataSetDocumentCode = new DataSet();
            DataSetDocumentCode = SharedTables.DataSetDocumentCodes;
            if (DataSetDocumentCode.Tables[0].Rows.Count != 0)
            {
                DropDownConsentList.DataTextField = "DocumentName";
                DropDownConsentList.DataValueField = "DocumentCodeId";
                DropDownConsentList.DataSource = DataSetDocumentCode.Tables[0];
                DropDownConsentList.DataBind();

                if (DropDownConsentList.Items.Count > 0)
                {
                    _CustomWebDocumentCodeId = Convert.ToInt32(DropDownConsentList.SelectedValue);
                    DataRow[] _dataRowDocumentCodes =
                        SharedTables.DataSetDocumentCodes.Tables[0].Select("DocumentCodeId=" +
                                                                           DropDownConsentList.SelectedValue);
                    if (_dataRowDocumentCodes.Length > 0)
                        HiddenFieldReportUrl.Value = ConfigurationManager.AppSettings["CustomDocumentsReportURL"] + "/" +
                                                     "Pages/ReportViewer.aspx?%2f" +
                                                     ConfigurationManager.AppSettings["ReportFolderUrl"] + "%2f" +
                                                     _dataRowDocumentCodes[0]["ViewDocumentURL"] +
                                                     "&rs%3aCommand=Render&rs:UniqueGuid=" + Guid.NewGuid();
                }
            }
            DropDownConsentList.Items.Insert(0, new ListItem("Standard", "0"));
            DropDownConsentList.SelectedIndex = 0;
        }
        catch (Exception ex)
        {
            if (ex.Data["CustomExceptionInformation"] == null)
                ex.Data["CustomExceptionInformation"] = "";
            else
                ex.Data["CustomExceptionInformation"] = "";
            if (ex.Data["DatasetInfo"] == null)
                ex.Data["DatasetInfo"] = null;
            LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);
        }
        finally
        {
            DataSetDocumentCode = null;
        }
    }


    private void FillRelationShips()
    {
        DataSet DataSetRelationShip = null;
        try
        {
            DataSetRelationShip = new DataSet();
            DataRow[] DataRowRelationShip =
                SharedTables.DataSetGlobalCodes.Tables[0].Select(
                    "Category='CONSENTRELATIONSHIP' And ISNULL(RecordDeleted,'N')='N'");
            DataSetRelationShip.Merge(DataRowRelationShip);
            DropDownRelationShip.DataSource = DataSetRelationShip;
            DropDownRelationShip.DataTextField = "CodeName";
            DropDownRelationShip.DataValueField = "GlobalCodeID";
            DropDownRelationShip.DataBind();
            DropDownRelationShip.Items.Insert(0, new ListItem("---Select Relation---", "0"));
            DropDownRelationShip.SelectedIndex = 0;
        }
        catch (Exception ex)
        {
            if (ex.Data["CustomExceptionInformation"] == null)
                ex.Data["CustomExceptionInformation"] = "";
            else
                ex.Data["CustomExceptionInformation"] = "";
            if (ex.Data["DatasetInfo"] == null)
                ex.Data["DatasetInfo"] = null;
            LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);
        }
        finally
        {
            DataSetRelationShip = null;
        }
    }

    private void SetBrowsersUrl()
    {
        string _documentUrl = string.Empty;
        //DataRow[] _dataRowDocumentCodes = null;       
        string _queryStringVariables = string.Empty;
        string _ClientName = string.Empty;
        Int32 _ClientId = 0;
        DataSet _DataSetClientSummary = null;
        try
        {
            //            _dataRowDocumentCodes = Streamline.UserBusinessServices.SharedTables.dataSetDocumentCodes.Tables[0].Select("DocumentCodeId=" + _CustomWebDocumentCodeId + " and DocumentType=18");            
            if (DropDownConsentList.SelectedIndex > 0)
            {
                //ScriptManager.RegisterStartupScript(Label1, Label1.GetType(), "key", "javascript:fnShowParentDiv('Communicating with server...',150,25);", true);
                _CustomWebDocumentCodeId = Convert.ToInt32(DropDownConsentList.SelectedValue);
                _documentUrl = ConfigurationSettings.AppSettings["WebDocumentsApplicationURL"] + "ApplicationForm.aspx";
                Encoding _xmlDataInBytes = Encoding.UTF8;
                if (Session["DataSetClientSummary"] != null)
                {
                    _DataSetClientSummary = (DataSet)Session["DataSetClientSummary"];
                    _ClientName = _DataSetClientSummary.Tables["ClientInformation"].Rows[0]["ClientName"].ToString();
                    _ClientId = Convert.ToInt32((((StreamlinePrinciple)Context.User).Client.ClientId));
                }

                string _postedData = "?DcId=" + _CustomWebDocumentCodeId + "&SId=" +
                                     ((StreamlineIdentity)(Context.User.Identity)).UserId + "&CN=" + _ClientName +
                                     "&Cid=" + _ClientId + "&DId=" + "0" + "&PId=1&GId=" + Guid.NewGuid() + "&UC=" +
                                     ((StreamlineIdentity)(Context.User.Identity)).UserCode + "&DVID=" + "0" +
                                     "&CFrom=" + "MM";


                _documentUrl += _postedData;
            }
            else if (DropDownConsentList.SelectedIndex == 0)
            {
                _documentUrl = "HarborConsent.aspx";
            }
            //ScriptManager.RegisterStartupScript(Label1, Label1.GetType(), "key", "javascript:OpenDocuments('" + _documentUrl + "');", true);
            //Modified by anuj on 30nov,2009 for task ref #18 SDI venture 10
            ScriptManager.RegisterStartupScript(Label1, Label1.GetType(), "key",
                                                "javascript:OpenDocuments('" + _documentUrl + "','" +
                                                HiddenFieldImageConsentClick.Value + "','" +
                                                HiddenFieldCheckImageClick.Value + "' );", true);
            //Ended over here

            //ScriptManager.RegisterStartupScript(LabelConsentFrom, LabelConsentFrom.GetType(), "key", "javascript:OpenDocuments('" + _documentUrl + "');", true);
        }
        catch (Exception ex)
        {
            if (ex.Data["CustomExceptionInformation"] == null)
                ex.Data["CustomExceptionInformation"] = "";
            else
                ex.Data["CustomExceptionInformation"] = "";
            if (ex.Data["DatasetInfo"] == null)
                ex.Data["DatasetInfo"] = null;
            LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);
        }
    }

    protected void DropDownConsentList_SelectedIndexChanged(object sender, EventArgs e)
    {
        DataRow[] _dataRowDocumentCodes =
            SharedTables.DataSetDocumentCodes.Tables[0].Select("DocumentCodeId=" + DropDownConsentList.SelectedValue);
        if (_dataRowDocumentCodes.Length > 0)
            HiddenFieldReportUrl.Value = ConfigurationManager.AppSettings["CustomDocumentsReportURL"] + "/" +
                                         "Pages/ReportViewer.aspx?%2f" +
                                         ConfigurationManager.AppSettings["ReportFolderUrl"] + "%2f" +
                                         _dataRowDocumentCodes[0]["ViewDocumentURL"] +
                                         "&rs%3aCommand=Render&rs:UniqueGuid=" + Guid.NewGuid();
        CreateDocumentDataSet();
        SetBrowsersUrl();
    }

    protected void CreateDocumentDataSet()
    {
        DataRow _DataRowDocuments = null;
        DataRow _DataRowDocumentVersions = null;
        var _dsCustomDoc = new DataSet();
        try
        {
            HiddenFieldDataSet.Value = "";
            _dsCustomDocuments = new DataSetCustomWebDocument();
            _DataRowDocuments = _dsCustomDocuments.Documents.NewRow();
            _DataRowDocuments["ClientId"] = ((StreamlinePrinciple)Context.User).Client.ClientId;
            _DataRowDocuments["DocumentCodeId"] = Convert.ToInt32(DropDownConsentList.SelectedValue);
            _DataRowDocuments["EffectiveDate"] = DateTime.Now;
            _DataRowDocuments["Status"] = 21;
            _DataRowDocuments["SignedByAuthor"] = "N";
            _DataRowDocuments["SignedByAll"] = "N";
            _DataRowDocuments["AuthorId"] = ((StreamlineIdentity)Context.User.Identity).UserId;
            _DataRowDocuments["CurrentDocumentVersionId"] = 1;
            _DataRowDocuments["DocumentShared"] = "Y";
            _DataRowDocuments["RowIdentifier"] = Guid.NewGuid();
            _DataRowDocuments["CreatedBy"] = ((StreamlineIdentity)Context.User.Identity).UserCode;
            _DataRowDocuments["CreatedDate"] = DateTime.Now;
            _DataRowDocuments["ModifiedBy"] = ((StreamlineIdentity)Context.User.Identity).UserCode;
            _DataRowDocuments["ModifiedDate"] = DateTime.Now;
            _DataRowDocuments.EndEdit();
            _dsCustomDocuments.Documents.Rows.Add(_DataRowDocuments);

            _DataRowDocumentVersions = _dsCustomDocuments.DocumentVersions.NewRow();
            _DataRowDocumentVersions["DocumentId"] = _DataRowDocuments["DocumentId"];
            _DataRowDocumentVersions["DocumentVersionId"] = -1;
            _DataRowDocumentVersions["Version"] = 1;
            _DataRowDocumentVersions["RowIdentifier"] = Guid.NewGuid();
            _DataRowDocumentVersions["CreatedBy"] = ((StreamlineIdentity)Context.User.Identity).UserCode;
            _DataRowDocumentVersions["CreatedDate"] = DateTime.Now;
            _DataRowDocumentVersions["ModifiedBy"] = ((StreamlineIdentity)Context.User.Identity).UserCode;
            _DataRowDocumentVersions["ModifiedDate"] = DateTime.Now;
            _DataRowDocumentVersions.EndEdit();
            _dsCustomDocuments.DocumentVersions.Rows.Add(_DataRowDocumentVersions);

            string strDataset = SerializeObject(_dsCustomDocuments, typeof(DataSet));
            HiddenFieldDataSet.Value = Server.HtmlEncode(strDataset);
        }
        catch (Exception ex)
        {
            if (ex.Data["CustomExceptionInformation"] == null)
                ex.Data["CustomExceptionInformation"] = "";
            else
                ex.Data["CustomExceptionInformation"] = "";
            if (ex.Data["DatasetInfo"] == null)
                ex.Data["DatasetInfo"] = null;
            LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);
        }
    }


    public String SerializeObject(Object pObject, Type _type)
    {
        try
        {
            String XmlizedString = null;
            var memoryStream = new MemoryStream();
            var xs = new XmlSerializer(_type);
            var xmlTextWriter = new XmlTextWriter(memoryStream, Encoding.UTF8);
            xs.Serialize(xmlTextWriter, pObject);
            memoryStream = (MemoryStream)xmlTextWriter.BaseStream;
            XmlizedString = UTF8ByteArrayToString(memoryStream.ToArray());
            return XmlizedString;
        }
        catch (Exception e)
        {
            return null;
        }
    }

    private Byte[] StringToUTF8ByteArray(String pXmlString)
    {
        var encoding = new UTF8Encoding();
        Byte[] byteArray = encoding.GetBytes(pXmlString);
        return byteArray;
    }

    private String UTF8ByteArrayToString(Byte[] characters)
    {
        var encoding = new UTF8Encoding();
        String constructedString = encoding.GetString(characters);
        return (constructedString);
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
        //End
        //Block For ReportPath
        reportViewer1 = new ReportViewer();
        //Ref to Task#2660
        string FileName = "";
        int seq = 1;
        try
        {
            _ReportPath = Server.MapPath(".") + ConfigurationManager.AppSettings["MedicationPerscriptionReportUrl"];
            if (_ReportPath == "") //Check For Report Path
            {
                strErrorMessage = "ReportPath is Missing In WebConfig";
                ScriptManager.RegisterStartupScript(Label1, Label1.GetType(), ClientID,
                                                    "ShowError('" + strErrorMessage + "', true);", true);
                return;
            }
        }
        catch (Exception ex)
        {
            LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);

            strErrorMessage = "ReportPath Key is Missing In WebConfig";
            ScriptManager.RegisterStartupScript(Label1, Label1.GetType(), ClientID,
                                                "ShowError('" + strErrorMessage + "', true);", true);
            return;
        }
        finally
        {
            objLogManager = null;
        }

        try
        {
            //  _DataSetRdl = new DataSet();//Commented by Vikas Vyas On Dated March 04 2008
            ClientMedication objectClientMedications = null;
            objectClientMedications = new ClientMedication();

            //Get the Name of the Rdlc,StoredProcedure from DocumentCodes,DocumentCodesRDLSubReports
            _DataSetGetRdlCName = objectClientMedications.GetRdlCNameDataBase(1026);
            _DataSetGetRdlCName.Tables[0].TableName = "DocumentCodes";
            _DataSetGetRdlCName.Tables[1].TableName = "DocumentCodesRDLSubReports";


            if (_DataSetGetRdlCName.Tables["DocumentCodes"].Rows.Count > 0)
            {
                dr = _DataSetGetRdlCName.Tables["DocumentCodes"].Select();
                //because DocumentCodes table only contain one row


                //_OrderingMethod = OrderingMethod;


                //Check For Main Report
                if ((dr[0]["DocumentName"] != DBNull.Value || !String.IsNullOrEmpty(dr[0]["DocumentName"].ToString())) &&
                    (dr[0]["ViewStoredProcedure"] != DBNull.Value ||
                     !String.IsNullOrEmpty(dr[0]["ViewStoredProcedure"].ToString())))
                {
                    #region Get the StoredProceudreName and Execute

                    string _StoredProcedureName = "";
                    string _ReportName = "";
                    _StoredProcedureName = dr[0]["ViewStoredProcedure"].ToString(); //Get the StoredProcedure Name
                    _ReportName = dr[0]["DocumentName"].ToString();

                    reportViewer1.ProcessingMode = ProcessingMode.Local;
                    reportViewer1.LocalReport.ReportPath = _ReportPath + "\\" + _ReportName + ".rdlc";
                    reportViewer1.LocalReport.DataSources.Clear();

                    if (Session["VersionIdForConsentDetailPage"] != null)
                    {
                        _DataSetRdlForMainReport =
                            objectClientMedications.GetDataForHarborStandardConsentRdlC(_StoredProcedureName,
                                                                                        Convert.ToInt32(
                                                                                            (((StreamlinePrinciple)
                                                                                              Context.User).Client
                                                                                                           .ClientId)),
                                                                                        Convert.ToString(
                                                                                            HiddenFieldClientmedicationIdForConsent
                                                                                                .Value),
                                                                                        Convert.ToInt32(
                                                                                            Session[
                                                                                                "VersionIdForConsentDetailPage"
                                                                                                ].ToString()));
                    }
                    else if (Session["ChangedOrderMedicationIds"] != null)
                    {
                        //Codition modified by Loveena in ref to Task#2962
                        if (HiddenFieldDocumentVersionId.Value != "")
                        {
                            _DataSetRdlForMainReport =
                                objectClientMedications.GetDataForHarborStandardConsentRdlC(_StoredProcedureName,
                                                                                            Convert.ToInt32(
                                                                                                (((StreamlinePrinciple)
                                                                                                  Context.User).Client
                                                                                                               .ClientId)),
                                                                                            Session[
                                                                                                "ChangedOrderMedicationIds"
                                                                                                ].ToString(),
                                                                                            Convert.ToInt32(
                                                                                                HiddenFieldDocumentVersionId
                                                                                                    .Value));
                        }
                        else
                        {
                            if (HiddenFieldImageConsentClick == null)
                            {
                                HiddenFieldImageConsentClick =
                                    (HiddenField)Page.FindControl("HiddenFieldImageConsentClick");
                                HiddenFieldImageConsentClick.Value =
                                    ((HiddenField)Page.FindControl("HiddenFieldImageConsentClick")).Value;
                            }
                            if (HiddenFieldImageConsentClick.Value == "Patient Consent")
                            {
                                _DataSetRdlForMainReport =
                                    objectClientMedications.GetDataForHarborStandardConsentRdlC(_StoredProcedureName,
                                                                                                Convert.ToInt32(
                                                                                                    (((
                                                                                                      StreamlinePrinciple
                                                                                                      )Context.User)
                                                                                                        .Client.ClientId)),
                                                                                                Session[
                                                                                                    "ChangedOrderMedicationIds"
                                                                                                    ].ToString(), 0);
                            }
                        }
                    }

                    var DataSource = new ReportDataSource("RDLReportDataSet_" + _StoredProcedureName,
                                                          _DataSetRdlForMainReport.Tables[0]);
                    var dstemp = (DataSet)Session["DataSetRdlTemp"];
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

                        reportViewer1.LocalReport.SubreportProcessing -= SetSubDataSource;
                        reportViewer1.LocalReport.SubreportProcessing += SetSubDataSource;

                        for (int i = 0; i < _drSubReport.Length; i++) //Loop 
                        {
                            if ((_drSubReport[i]["SubReportName"] != DBNull.Value ||
                                 !String.IsNullOrEmpty(_drSubReport[i]["SubReportName"].ToString())) &&
                                (_drSubReport[i]["StoredProcedure"] != DBNull.Value ||
                                 !String.IsNullOrEmpty(_drSubReport[i]["StoredProcedure"].ToString())))
                            {
                                #region Get the StoredProcedureName For SubReport and Execute

                                string _SubReportStoredProcedure = "";
                                string _SubReportName = "";
                                _SubReportStoredProcedure = _drSubReport[i]["StoredProcedure"].ToString();
                                _SubReportName = _drSubReport[i]["SubReportName"].ToString();
                                //Get Data For SubReport
                                //Added By Chandan Task#85 MM #1.7
                                if (Session["VersionIdForConsentDetailPage"] != null) //By Anuj for Yellow checkBox
                                {
                                    _DataSetRdlForSubReport =
                                        objectClientMedications.GetDataForHarborStandardConsentRdlC(
                                            _SubReportStoredProcedure,
                                            Convert.ToInt32((((StreamlinePrinciple)Context.User).Client.ClientId)),
                                            Convert.ToString(HiddenFieldClientmedicationIdForConsent.Value),
                                            Convert.ToInt32(Session["VersionIdForConsentDetailPage"].ToString()));
                                }
                                else if (HiddenFieldDocumentVersionId.Value != "")
                                {
                                    _DataSetRdlForSubReport =
                                        objectClientMedications.GetDataForHarborStandardConsentRdlC(
                                            _SubReportStoredProcedure,
                                            Convert.ToInt32((((StreamlinePrinciple)Context.User).Client.ClientId)),
                                            Session["ChangedOrderMedicationIds"].ToString(),
                                            Convert.ToInt32(HiddenFieldDocumentVersionId.Value));
                                }
                                else
                                {
                                    if (HiddenFieldImageConsentClick.Value == "Patient Consent")
                                    {
                                        //Code added by Loveena in ref to Task#2962
                                        if (_SubReportStoredProcedure != "csp_RDLHarborConsentElectronicSignature")
                                            _DataSetRdlForSubReport =
                                                objectClientMedications.GetDataForHarborStandardConsentRdlC(
                                                    _SubReportStoredProcedure,
                                                    Convert.ToInt32(
                                                        (((StreamlinePrinciple)Context.User).Client.ClientId)),
                                                    Session["ChangedOrderMedicationIds"].ToString(), 0);
                                    }
                                }
                                var rds = new ReportDataSource(_SubReportName, _DataSetRdlForSubReport.Tables[0]);
                                reportViewer1.LocalReport.DataSources.Add(rds);
                                string strRootPath = Server.MapPath(".");

                                var RdlSubReport = new StreamReader(_ReportPath + "\\" + _SubReportName.Trim() + ".rdlc");

                                reportViewer1.LocalReport.LoadReportDefinition(RdlSubReport);

                                #endregion
                            }
                        } //End For Loop
                    }
                    //Following parameters added with ref to Task 2371 SC-Support
                    _RptParam = new ReportParameter[3];
                    _RptParam[0] = new ReportParameter("ClientId",
                                                       Convert.ToString(
                                                           ((StreamlinePrinciple)Context.User).Client.ClientId));
                    if (Session["VersionIdForConsentDetailPage"] != null)
                    {
                        _RptParam[1] = new ReportParameter("ClientMedicationId",
                                                           Convert.ToString(
                                                               HiddenFieldClientmedicationIdForConsent.Value));
                    }
                    else
                    {
                        _RptParam[1] = new ReportParameter("ClientMedicationId",
                                                           Session["ChangedOrderMedicationIds"].ToString());
                    }
                    _RptParam[2] = new ReportParameter("ClientName",
                                                       Convert.ToString(
                                                           ((StreamlinePrinciple)Context.User).Client.LastName + ", " +
                                                           ((StreamlinePrinciple)Context.User).Client.FirstName));
                    reportViewer1.LocalReport.SetParameters(_RptParam);

                    reportViewer1.LocalReport.Refresh();
                    reportViewer1.LocalReport.DataSources.Add(DataSource);
                    //ScriptManager.RegisterStartupScript(Label1, Label1.GetType(), ClientID.ToString(), "ShowPrintDiv('" + Session["ChangedOrderMedicationIds"].ToString() + "');", true);
                }
            }

        #endregion

            //Ref to Task#2660
            if (ConfigurationSettings.AppSettings["SaveJpegOutput"].ToLower() == "true")
            {
                if (Directory.Exists(Server.MapPath("RDLC\\" + Context.User.Identity.Name)))
                {
                    if (!Directory.Exists(Server.MapPath("RDLC\\" + Context.User.Identity.Name + "\\JPEGS")))
                        Directory.CreateDirectory(Server.MapPath("RDLC\\" + Context.User.Identity.Name + "\\JPEGS"));

                    foreach (
                        string file in Directory.GetFiles(Server.MapPath("RDLC\\" + Context.User.Identity.Name + "\\")))
                    {
                        FileName = file.Substring(file.LastIndexOf("\\") + 1);
                        if ((FileName.IndexOf("JPEG") >= 0 || FileName.IndexOf("jpeg") >= 0))
                        {
                            //Added by Chandan on 16th Feb2010 ref task#2797
                            if (
                                File.Exists(Server.MapPath("RDLC\\" + Context.User.Identity.Name + "\\JPEGS") + "\\" +
                                            FileName))
                            {
                                if (FileName.ToUpper().IndexOf(".RDLC") == -1)
                                    File.Delete(Server.MapPath("RDLC\\" + Context.User.Identity.Name + "\\" + FileName));
                            }
                            else
                            {
                                while (seq < 1000)
                                {
                                    seq = seq + 1;
                                    if (
                                        !File.Exists(Server.MapPath("RDLC\\" + Context.User.Identity.Name + "\\JPEGS") +
                                                     "\\" + FileName))
                                    {
                                        File.Move(file,
                                                  Server.MapPath("RDLC\\" + Context.User.Identity.Name + "\\JPEGS") +
                                                  "\\" + FileName);
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
                    using (var objRDLC = new RDLCPrint())
                    {
                        objRDLC.DeleteRenderedImages(Server.MapPath("RDLC\\" + Context.User.Identity.Name));
                    }
                }
                catch (Exception ex)
                {
                    LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);
                }

                #endregion
            }

            string ScriptId = "";
            ////Added by Rohit. Ref ticket#84
            string reportType = "PDF";
            IList<Stream> m_streams;
            m_streams = new List<Stream>();
            Warning[] warnings;
            string deviceInfo = "<DeviceInfo><OutputFormat>PDF</OutputFormat><StartPage>0</StartPage></DeviceInfo>";
            try
            {
                if (Session["imgId"] == null)
                {
                    var rand = new Random();
                    if (Session["ChangedOrderMedicationIds"] != null)
                    {
                        string[] ClientMedicationIds = Session["ChangedOrderMedicationIds"].ToString().Split(',');
                        //Modified by Malathi Shiva on 09/July/2015 - Modified the conversion to handle null values
                        //Int32 ClientMedicationId = Convert.ToInt32(ClientMedicationIds[0]);
                        Int32 ClientMedicationId;
                        int.TryParse(ClientMedicationIds[0].ToString(), out ClientMedicationId);

                        ClientMedicationId = ClientMedicationId + rand.Next();
                        Session["imgId"] = ClientMedicationId;
                        //Session["imgId"] = Session["ChangedOrderMedicationIds"];
                    }
                    else
                    {
                        if (HiddenFieldClientmedicationIdForConsent.Value != "" &&
                            HiddenFieldClientmedicationIdForConsent.Value != null)
                            Session["imgId"] = Convert.ToInt32(HiddenFieldClientmedicationIdForConsent.Value) +
                                               rand.Next();
                        //                        Session["imgId"] = Convert.ToString(HiddenFieldClientmedicationIdForConsent.Value);
                    }
                }
                else
                {
                    Session["imgId"] = Convert.ToInt32(Session["imgId"]) + 1;
                }
                ScriptId = Session["imgId"] + "_" + DateTime.Now.ToString("yyyyMMHHMMss") + "." + seq.ToString();
            }
            catch (Exception ex)
            {
            }

            using (var objRDLC = new RDLCPrint())
            {
                //In case of Ordering method as X Chart copy will be printed                       
                //objRDLC.Run(this.reportViewer1.LocalReport, Server.MapPath("RDLC\\" + Context.User.Identity.Name), Session["imgId"].ToString(), false, false);
                objRDLC.RunConsent(reportViewer1.LocalReport, Server.MapPath("RDLC\\" + Context.User.Identity.Name),
                                   ScriptId, false, false);

                //Added by Rohit. Ref ticket#84
                renderedBytes = reportViewer1.LocalReport.Render(reportType, deviceInfo, out mimeType, out encoding,
                                                                 out fileNameExtension, out streams, out warnings);
            }
            if (Session["VersionIdForConsentDetailPage"] != null)
            {
                if (HiddenFieldCheckImageClick.Value == "G")
                {
                    ScriptManager.RegisterStartupScript(Label1, Label1.GetType(), ClientID,
                                                        "ShowPrintDiv('" + ScriptId + "','G');", true);
                }
                else
                {
                    ScriptManager.RegisterStartupScript(Label1, Label1.GetType(), ClientID,
                                                        "ShowPrintDiv('" + ScriptId + "','Y');", true);
                }
            }
            else
            {
                ScriptManager.RegisterStartupScript(Label1, Label1.GetType(), ClientID,
                                                    "ShowPrintDiv('" + ScriptId + "');", true);
            }
            //Session["ImgIdForMDSigned"] = Session["imgId"];
            Session["ImgIdForMDSigned"] = ScriptId;
        }
        catch (Exception ex)
        {
            LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);
        }
        finally
        {
            //    //Added by Vikas Vyas In ref to task 2334 On Dated March 04th 2008

            _DataSetGetRdlCName = null;
            _DataSetRdlForMainReport = null;
            _DataSetRdlForSubReport = null;
            _RptParam = null;
            if (Session["VersionIdForConsentDetailPage"] != null)
            {
                Session["VersionIdForConsentDetailPage"] = null;
            }
            if (Session["imgId"] != null)
                Session["imgId"] = null;

            ////End
        }
    }

    public void SetSubDataSource(object sender, SubreportProcessingEventArgs e)
    {
        try
        {
            var rptTemp = (LocalReport)sender;
            var dtTemp = (DataTable)rptTemp.DataSources[e.ReportPath.Trim()].Value;
            e.DataSources.Add(new ReportDataSource(e.DataSourceNames[0], dtTemp));
        }
        catch (Exception ex)
        {
            LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);
        }
    }

    protected void GetStandardRDLCContents(object sender, EventArgs e)
    {
        try
        {
            GetRDLCContents();
        }
        catch (Exception ex)
        {
            if (ex.Data["CustomExceptionInformation"] == null)
                ex.Data["CustomExceptionInformation"] = "";
            else
                ex.Data["CustomExceptionInformation"] = "";
            if (ex.Data["DatasetInfo"] == null)
                ex.Data["DatasetInfo"] = null;
            LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);
        }
    }


    protected void ButtonUpdate_Click(object sender, EventArgs e)
    {
    }

    protected void ButtonPrint_Click(object sender, EventArgs e)
    {
        try
        {
            ScriptManager.RegisterStartupScript(Label1, Label1.GetType(), ClientID,
                                                "PrintMedicationScript('" + Session["ChangedOrderMedicationIds"] + "'," +
                                                1 + ",'" + Session["ChangedOrderMedicationIds"] + "',true);", true);
            GetRDLCContents();
        }
        catch (Exception ex)
        {
            if (ex.Data["CustomExceptionInformation"] == null)
                ex.Data["CustomExceptionInformation"] = "";
            else
                ex.Data["CustomExceptionInformation"] = "";
            if (ex.Data["DatasetInfo"] == null)
                ex.Data["DatasetInfo"] = null;
            LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);
        }
    }

    protected void LinkButtonLogout_Click(object sender, EventArgs e)
    {
        Response.Redirect("MedicationLogin.aspx");
    }
}
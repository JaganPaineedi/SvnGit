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
using Streamline.UserBusinessServices;
using Streamline.BaseLayer;
using System.Text;
using System.IO;
using System.Collections.Generic;

public partial class MedicationPrintOrderDialog : Streamline.BaseLayer.ActivityPages.ActivityPage
{
    //int _ClientMedicationScriptId;

    Streamline.UserBusinessServices.DataSets.DataSetClientScripts DataSetClientScriptActivities = null;
    Streamline.UserBusinessServices.ClientMedication objectClientMedications = null;


    protected override void Page_Load(object sender, EventArgs e)
    {

        try
        {
            CommonFunctions.Event_Trap(this);
            //Added by Loveena in ref to task#2378 - CopyrightInfo
            if (Session["UserContext"] != null)
                LabelCopyrightInfo.Text = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).CopyrightInfo;

            #region "error message color added by rohit ref. #121"
            Streamline.BaseLayer.CommonFunctions.SetErrorMegssageBackColor(LabelError);
            Streamline.BaseLayer.CommonFunctions.SetErrorMegssageForeColor(LabelError);
            #endregion
            if (!Page.IsPostBack)
            {
                this.RadioButtonFaxToPharmacy.Attributes.Add("onclick", "return EnablesDisable('" + ButtonOk.ClientID + "','" + RadioButtonFaxToPharmacy.ClientID + "','" + RadioButtonPrintScript.ClientID + "')");
                this.RadioButtonPrintScript.Attributes.Add("onclick", "return EnablesDisable('" + ButtonOk.ClientID + "','" + RadioButtonFaxToPharmacy.ClientID + "','" + RadioButtonPrintScript.ClientID + "')");
                this.ButtonOk.Attributes.Add("onclick", "javascript:return ValidateInputsPrint('" + DropDownListPharmacies.ClientID + "','" + RadioButtonFaxToPharmacy.ClientID + "','" + RadioButtonPrintScript.ClientID + "','" + DropDownListScriptReason.ClientID + "');");
                FillPharmaciesCombo();
                FillScriptReasonCombo();
                HiddenFieldLatestClientMedicationScriptId.Value = Request.QueryString["ClientMedicationScriptId"].ToString();
                HiddenFieldOrderMethod.Value = Request.QueryString["OrderingMethod"].ToString();
            }

        }
        catch (Exception ex)
        {
            if (ex.Data["CustomExceptionInformation"] == null)
                ex.Data["CustomExceptionInformation"] = "###Source Function Name - MedicationPrintOrderDialog--Page_Load(), ParameterCount -0 ###";
            else
                ex.Data["CustomExceptionInformation"] = "";
            if (ex.Data["DatasetInfo"] == null)
                ex.Data["DatasetInfo"] = null;
            Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);

            string strErrorMessage = "";

            ScriptManager.RegisterStartupScript(LabelError, LabelError.GetType(), ClientID.ToString(), "closeDiv();", true);
        }
        finally
        {

        }

    }

    #region FillDropDowns
    /// <summary>
    /// Fills the Pharmacies combo
    /// </summary>
    private void FillPharmaciesCombo()
    {
        // To Fill Pharmacies Combo 
        DataSet DataSetPharmacies = null;
        DataSetPharmacies = Streamline.UserBusinessServices.SharedTables.DataSetPharmacies;
        try
        {
            CommonFunctions.Event_Trap(this);


            DropDownListPharmacies.DataSource = DataSetPharmacies.Tables[0];
            DropDownListPharmacies.DataTextField = "PharmacyName";
            DropDownListPharmacies.DataValueField = "PharmacyId";
            DropDownListPharmacies.DataBind();
            DropDownListPharmacies.Items.Insert(0, new ListItem("........Select Pharmacy........", "0"));
            DropDownListPharmacies.SelectedIndex = 0;

        }
        catch (Exception ex)
        {

            if (ex.Data["CustomExceptionInformation"] == null)
                ex.Data["CustomExceptionInformation"] = CommonFunctions.Event_FormatString("###Source Function Name - FillPharmaciesCombo(),ParameterCount 0 - ###");
            else
                // ex.Data["CustomExceptionInformation"] =  CommonFunctions.Event_FormatString(ex.Data["CustomExceptionInformation"]);
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = DataSetPharmacies;
            Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);

        }
        finally
        {
            DataSetPharmacies = null;

        }

    }

    private void FillScriptReasonCombo()
    {

        // To Fill Locations Combo 

        DataSet DataSetScriptReasons = null;


        try
        {
            CommonFunctions.Event_Trap(this);
            DataRow[] DataRowScriptReasons = Streamline.UserBusinessServices.SharedTables.DataSetGlobalCodes.Tables[0].Select("CATEGORY='SCRIPTREASON' AND ISNULL(RecordDeleted,'N')<>'Y' and Active='Y' ");
            DataSetScriptReasons = new DataSet();
            DataSetScriptReasons.Merge(DataRowScriptReasons);
            if (DataSetScriptReasons.Tables.Count > 0)
            {
                DataSetScriptReasons.Tables[0].TableName = "GlobalCodesScriptReasons";
                if (DataSetScriptReasons.Tables["GlobalCodesScriptReasons"].Rows.Count > 0)
                {
                    DropDownListScriptReason.DataSource = DataSetScriptReasons.Tables["GlobalCodesScriptReasons"];
                    DropDownListScriptReason.DataTextField = "CodeName";
                    DropDownListScriptReason.DataValueField = "GlobalCodeId";
                    DropDownListScriptReason.DataBind();

                    DropDownListScriptReason.Items.Insert(0, new ListItem("........Select Script Reason........", "0"));
                    DropDownListScriptReason.SelectedIndex = 0;
                }
            }

        }
        catch (Exception ex)
        {

            if (ex.Data["CustomExceptionInformation"] == null)
                ex.Data["CustomExceptionInformation"] = CommonFunctions.Event_FormatString("###Source Function Name - FillScriptReasonCombo(),ParameterCount 0 - ###");
            else
                ex.Data["CustomExceptionInformation"] = CommonFunctions.Event_FormatString(ex.Data["CustomExceptionInformation"].ToString());
            if (ex.Data["DatasetInfo"] == null)
                ex.Data["DatasetInfo"] = DataSetScriptReasons;
            Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);

        }
        finally
        {
            DataSetScriptReasons = null;

        }

    }


    #endregion


    protected void ButtonOk_Click(object sender, EventArgs e)
    {




        int PharmacyId = 0;
        char OrderingMethod = 'F';

        int ScriptReason = -1;

        bool strUpdateDatabase = false;
        try
        {
            CommonFunctions.Event_Trap(this);
            objectClientMedications = new ClientMedication();

            if (RadioButtonFaxToPharmacy.Checked == true)
                OrderingMethod = 'F';
            else
                OrderingMethod = 'P';


            if (OrderingMethod == 'F')
            {
                if (DropDownListPharmacies.SelectedIndex != 0)
                    PharmacyId = Convert.ToInt32(DropDownListPharmacies.SelectedValue.ToString());
            }


            if (DropDownListScriptReason.SelectedIndex != 0)
                ScriptReason = Convert.ToInt32(DropDownListScriptReason.SelectedValue.ToString());

            //ClientMedicationScriptActivityId = objectClientMedications.InsertIntoClientMedicationScriptActivities(Convert.ToInt32(HiddenFieldLatestClientMedicationScriptId.Value), OrderingMethod, PharmacyId, ScriptReason, CreatedBy);
            //Send Fax for non-controlled medications if ordering Method is Fax
            if (OrderingMethod == 'F')
            {
                if (HiddenFieldOrderMethod.Value.IndexOf("Faxed") < 0 && HiddenFieldOrderMethod.Value.IndexOf("F") < 0)
                {
                    strUpdateDatabase = SendToPrinter(ScriptReason, PharmacyId);
                    ScriptManager.RegisterStartupScript(LabelError, LabelError.GetType(), ClientID.ToString(), "alert('Some Medications could not be Faxed,Please review script History!');", true);
                }
                strUpdateDatabase = SendToFax(ScriptReason, PharmacyId);

            }

            if (strUpdateDatabase)
                ScriptManager.RegisterStartupScript(LabelError, LabelError.GetType(), ClientID.ToString(), "closeDiv();", true);
            else
            {
                string strErrorMessage = "Error in Updating Database";
                ScriptManager.RegisterStartupScript(LabelError, LabelError.GetType(), ClientID.ToString(), "ShowError('" + strErrorMessage + "', true);", true);
            }




        }


        catch (Exception ex)
        {
            if (ex.Data["CustomExceptionInformation"] == null)
                ex.Data["CustomExceptionInformation"] = "Source function ButtonOk_Click of Print Order Dialog";
            else
                ex.Data["CustomExceptionInformation"] = "";
            if (ex.Data["DatasetInfo"] == null)
                ex.Data["DatasetInfo"] = null;
            Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);

            string strErrorMessage = "Error in Updating Database";
            ScriptManager.RegisterStartupScript(LabelError, LabelError.GetType(), ClientID.ToString(), "ShowError('" + strErrorMessage + "', true);", true);
        }
        finally
        {
            DataSetClientScriptActivities = null;
        }



    }

    public bool SendToFax(int ScriptReason, int PharmacyId)
    {
        #region Sending Fax
        // Declare objects
        DataSet DataSetTemp = null;
        string FaxUniqueId = "";
        try
        {
            DataSetClientScriptActivities = new Streamline.UserBusinessServices.DataSets.DataSetClientScripts();

            #region Get RDLC Contents

            string _ReportPath = "";
            string mimeType;
            string encoding;
            string fileNameExtension;
            string[] streams;
            byte[] renderedBytes;

            DataSet _DataSetRdl = new DataSet();
            Streamline.UserBusinessServices.ClientMedication objectClientMedications = null;

            objectClientMedications = new ClientMedication();
            reportViewer1 = new Microsoft.Reporting.WebForms.ReportViewer();
            _DataSetRdl = objectClientMedications.GetClientMedicationRDLDataSet(Convert.ToInt32(HiddenFieldLatestClientMedicationScriptId.Value));
            _ReportPath = Server.MapPath("RDLC\\MedicationReport.rdlc");
            ProcessRdlReport("DataSetMedication_ssp_SCGetClientMedicationScriptDatatry", _DataSetRdl, _ReportPath);


            string reportType = "PDF";
            IList<Stream> m_streams;
            m_streams = new List<Stream>();
            Microsoft.Reporting.WebForms.Warning[] warnings;
            string deviceInfo = "<DeviceInfo><OutputFormat>PDF</OutputFormat><StartPage>0</StartPage></DeviceInfo>";
            renderedBytes = reportViewer1.LocalReport.Render(reportType, deviceInfo, out mimeType, out encoding, out fileNameExtension, out streams, out warnings);

            // Create PDF from rendered Bytes to send as an attachment

            //Stream fs = new FileStream(Server.MapPath("RDLC\\MedicationScript.pdf"), FileMode.Create);
            Stream fs = new FileStream(Server.MapPath("RDLC") + "\\" + Context.User.Identity.Name + "\\MedicationScript.pdf", FileMode.Create);
            fs.Write(renderedBytes, 0, renderedBytes.Length);
            fs.Close();

            #endregion

            //Send to Fax server

            try
            {
                Streamline.Faxing.StreamlineFax _streamlineFax = new Streamline.Faxing.StreamlineFax();
                //FaxUniqueId = _streamlineFax.SendFax(PharmacyId, ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId, (Server.MapPath("RDLC") + "\\" + Context.User.Identity.Name + "\\MedicationScript.pdf"), "Prescription Medication Script") ? "True" : "";
                FaxUniqueId = _streamlineFax.SendFax(PharmacyId, ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientId, (Server.MapPath("RDLC") + "\\" + Context.User.Identity.Name + "\\MedicationScript.pdf"), "Prescription Medication Script");
            }
            catch (System.Runtime.InteropServices.COMException ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "Source function SendToFax() of Print Order Dialog";
                else
                    ex.Data["CustomExceptionInformation"] = "";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);
            }


            #region InsertRowsIntoClientScriptActivities
            ////Insert Rows into ClientScriptActivities
            DataRow drClientMedicationScriptsActivity = DataSetClientScriptActivities.Tables["ClientMedicationScriptActivities"].NewRow();
            drClientMedicationScriptsActivity["ClientMedicationScriptId"] = Convert.ToInt32(HiddenFieldLatestClientMedicationScriptId.Value);
            drClientMedicationScriptsActivity["Method"] = 'F';
            drClientMedicationScriptsActivity["PharmacyId"] = PharmacyId;
            drClientMedicationScriptsActivity["Reason"] = ScriptReason;
            drClientMedicationScriptsActivity["FaxStatusDate"] = DateTime.Now;
            drClientMedicationScriptsActivity["FaxStatus"] = "QUEUED";
            drClientMedicationScriptsActivity["FaxExternalIdentifier"] = FaxUniqueId;
            drClientMedicationScriptsActivity["RowIdentifier"] = System.Guid.NewGuid();
            drClientMedicationScriptsActivity["CreatedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
            drClientMedicationScriptsActivity["CreatedDate"] = DateTime.Now;
            drClientMedicationScriptsActivity["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
            drClientMedicationScriptsActivity["ModifiedDate"] = DateTime.Now;
            DataSetClientScriptActivities.Tables["ClientMedicationScriptActivities"].Rows.Add(drClientMedicationScriptsActivity);
            using (
                ClientMedication _clientMedication = objectClientMedications != null
                                                         ? objectClientMedications
                                                         : new ClientMedication())
            {
                _clientMedication.SetRenderedImageData(DataSetClientScriptActivities, drClientMedicationScriptsActivity,
                                                       ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity)
                                                           .UserCode, renderedBytes);
            }
            DataSetTemp = objectClientMedications.UpdateClientScriptActivities(DataSetClientScriptActivities);


            #endregion



            if (DataSetTemp.Tables["ClientMedicationScriptActivities"].Rows.Count > 0)
                return true;
            else
            {
                return false;
            }

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
    //Rishu for RDLC
    #region rdlc

    private void ProcessRdlReport(string _DataSetName, DataSet _DataSetRdl, string _ReportPath)
    {
        try
        {
            this.reportViewer1.ProcessingMode = Microsoft.Reporting.WebForms.ProcessingMode.Local;
            //this.reportViewer1.LocalReport.ReportPath = _ReportPath;
            this.reportViewer1.LocalReport.DataSources.Clear();
            this.reportViewer1.LocalReport.ReportPath = _ReportPath;
            Microsoft.Reporting.WebForms.ReportDataSource _DataSource = new Microsoft.Reporting.WebForms.ReportDataSource(_DataSetName, _DataSetRdl.Tables[0]);
            this.reportViewer1.LocalReport.DataSources.Add(_DataSource);
            this.reportViewer1.LocalReport.Refresh();
        }
        catch (Exception ex)
        {

        }
    }


    #endregion

    public bool SendToPrinter(int ScriptReason, int PharmacyId)
    {
        #region Sending Results to printer
        // Declare objects

        DataSet DataSetTemp = null;
        try
        {
            DataSetClientScriptActivities = new Streamline.UserBusinessServices.DataSets.DataSetClientScripts();

            #region InsertRowsIntoClientScriptActivities
            ////Insert Rows into ClientScriptActivities
            DataRow drClientMedicationScriptsActivity = DataSetClientScriptActivities.Tables["ClientMedicationScriptActivities"].NewRow();
            drClientMedicationScriptsActivity["ClientMedicationScriptId"] = Convert.ToInt32(HiddenFieldLatestClientMedicationScriptId.Value);
            drClientMedicationScriptsActivity["Method"] = 'P';
            drClientMedicationScriptsActivity["PharmacyId"] = PharmacyId;
            drClientMedicationScriptsActivity["Reason"] = ScriptReason;
            drClientMedicationScriptsActivity["FaxStatusDate"] = DateTime.Now;
            drClientMedicationScriptsActivity["FaxStatus"] = System.DBNull.Value;
            drClientMedicationScriptsActivity["FaxExternalIdentifier"] = System.DBNull.Value;
            drClientMedicationScriptsActivity["RowIdentifier"] = System.Guid.NewGuid();
            drClientMedicationScriptsActivity["CreatedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
            drClientMedicationScriptsActivity["CreatedDate"] = DateTime.Now;
            drClientMedicationScriptsActivity["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
            drClientMedicationScriptsActivity["ModifiedDate"] = DateTime.Now;
            DataSetClientScriptActivities.Tables["ClientMedicationScriptActivities"].Rows.Add(drClientMedicationScriptsActivity);
            using (
                ClientMedication _clientMedication = objectClientMedications != null
                                                         ? objectClientMedications
                                                         : new ClientMedication())
            {
                _clientMedication.SetRenderedImageData(DataSetClientScriptActivities, drClientMedicationScriptsActivity,
                                                       ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity)
                                                           .UserCode, null);
            }
            DataSetTemp = objectClientMedications.UpdateClientScriptActivities(DataSetClientScriptActivities);


            #endregion


            if (DataSetTemp.Tables["ClientMedicationScriptActivities"].Rows.Count > 0)
                return true;
            else
            {
                return false;
            }


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

}

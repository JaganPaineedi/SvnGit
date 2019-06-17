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
using AjaxControlToolkit;

public partial class UserControls_MedicationClientPersonalInformation : Streamline.BaseLayer.BaseActivityPage
{

    DataSet _DataSetClientSummary = null;
    DataView DataViewClientAllergies;
    Streamline.UserBusinessServices.ClientMedication objectClientMedications;

    protected string ActiveTab = "0";

    private bool _showEditableAllergyList;

    public bool showEditableAllergyList
    {
        get { return _showEditableAllergyList; }
        set { _showEditableAllergyList = value; }
    }

    private bool _showAllergyList;

    public bool showAllergyList
    {
        get { return _showAllergyList; }
        set { _showAllergyList = value; }
    }

    protected override void Page_Load(object sender, EventArgs e)
    {
        try
        {
            if (Session["ActiveTab"] != null) { ActiveTab = Session["ActiveTab"].ToString(); Session["ActiveTab"] = null; }
            LinkButtonAddAllergy.Disabled = !((Streamline.BaseLayer.StreamlinePrinciple)Context.User).HasPermission(Permissions.AddAllergy);
        }
        catch (Exception ex)
        {

            if (Session["UserContext"] == null)
            {
                Response.Redirect("./MedicationLogin.aspx?SessionExpires='yes'");
            }
        }

    }

    /// <summary>
    /// <CreatedBy>Loveena</CreatedBy>
    /// Purpose To enable/disable buttons based on Staff Permissions on 26-Dec-2008 as Ref to Task#92
    /// </summary>
    /// <param name="per"></param>
    /// <returns></returns>
    public string enableDisabled(Permissions per)
    {

        if (((Streamline.BaseLayer.StreamlinePrinciple)Context.User).HasPermission(per))
            return "";
        else
            return "Disabled";
    }

    public override void Activate()
    {
        try
        {
            CommonFunctions.Event_Trap(this);

            if (Session["DataSetClientSummary"] == null) { GetClientSummaryData(); }

            this.TextBoxAddAllergy.Attributes.Add("onkeydown", "if(event.which || event.keyCode){if ((event.which == 13) || (event.keyCode == 13)) {document.getElementById('" + LinkButtonAddAllergy.UniqueID + "').focus();return false;}} else {return true}; ");
            this.LinkButtonAddAllergy.Attributes.Add("onfocus", "ShowAllergySearchDivonLostFocus1('" + TextBoxAddAllergy.ClientID + "')");

            base.Activate();
            if (Session != null)
            {
                if (System.Configuration.ConfigurationSettings.AppSettings["ExternalInterface"].ToString().ToUpper() == "TRUE" && Session["ExternalClientInformation"] != null)
                {
                    _DataSetClientSummary = (DataSet)Session["ExternalClientInformation"];
                    if (_DataSetClientSummary.Tables["ClientHTMLSummary"].Rows.Count > 0)
                        BindControls();
                    else
                        ClearControls();
                }
                else
                {
                    _DataSetClientSummary = (DataSet)Session["DataSetClientSummary"];
                    if (_DataSetClientSummary.Tables["ClientInfoAreaHtml"].Rows.Count > 0)
                        BindControls();
                    else
                        ClearControls();
                }
                //if (!IsPostBack)
                //{
                //    HealthData.Activate();
                //    HealthGraph.Activate();
                //}
            }
            else
            {
                ScriptManager.RegisterStartupScript(LabelClientScript, LabelClientScript.GetType(), ClientID.ToString(), "redirectToLoginPage();", true);
                return;
            }

        }
        catch (Exception ex)
        {
            if (ex.Data["CustomExceptionInformation"] == null)
                ex.Data["CustomExceptionInformation"] = "";
            else
                ex.Data["CustomExceptionInformation"] = "";
            if (ex.Data["DatasetInfo"] == null)
                ex.Data["DatasetInfo"] = null;

            Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);

        }
        finally
        {

        }


    }

    private void BindControls()
    {

        try
        {
            // Name
            CommonFunctions.Event_Trap(this);
            ClearControls();

            //Added by Loveena in ref to task# 2417 MM-1.9 to retrieve HTML Client Summary
            if (_DataSetClientSummary.Tables.Contains("ClientHTMLSummary") == true)
            {
                lableClientInformation.Text = _DataSetClientSummary.Tables["ClientHTMLSummary"].Rows[0][0].ToString();
                EligibilityView.EligibilityResponse = "";
                MedHistoryView.MedHistoryResponse = "";
            }
            else if (_DataSetClientSummary.Tables.Contains("ClientInfoAreaHtml") == true)
            {
               string ClientInformationHTMLOutput = _DataSetClientSummary.Tables["ClientInfoAreaHtml"].Rows[0]["ClientInformationHTMLOutput"].ToString();                
               string titledata = FindDataBetween(ClientInformationHTMLOutput, "title=", ">");
               if (titledata == "\"\"")
               {
                   ClientInformationHTMLOutput = ClientInformationHTMLOutput.Replace("<img", "<img style=\"" + "display:none" + '"');
               }
               lableClientInformation.Text = ClientInformationHTMLOutput;

                EligibilityView.EligibilityResponse = _DataSetClientSummary.Tables["ClientInfoAreaHtml"].Rows[0]["CLientEligibilityXML"].ToString();
                MedHistoryView.MedHistoryResponse = _DataSetClientSummary.Tables["ClientInfoAreaHtml"].Rows[0]["MedicationHistoryXML"].ToString();
                MedHistoryView.EligibilityResponse = _DataSetClientSummary.Tables["ClientInfoAreaHtml"].Rows[0]["CLientEligibilityXML"].ToString();
            }
        }
        catch (Exception ex)
        {
            throw (ex);
        }

    }


    public static string FindDataBetween(string strSource, string strStart, string strEnd)
    {
        int Start, End;
        if (strSource.Contains(strStart) && strSource.Contains(strEnd))
        {
            Start = strSource.IndexOf(strStart, 0) + strStart.Length;
            End = strSource.IndexOf(strEnd, Start);
            return strSource.Substring(Start, End - Start);
        }
        else
        {
            return "";
        }
    }


    private void ClearControls()
    {

    }
    private string GetAge(string DOB)
    {
        DateTime dateOfBirth = DateTime.Parse(DOB);
        DateTime currentDate = DateTime.Now;
        System.TimeSpan TS = new System.TimeSpan(currentDate.Ticks - dateOfBirth.Ticks);
        long ageInYears = (long)TS.Days / 365;
        return ageInYears.ToString();
    }

    private string GetDiagnosisValue()
    {
        string diagnosisAxisIandIIValue = "";
        try
        {
            CommonFunctions.Event_Trap(this);
            int index = 0;
            foreach (DataRow dr in _DataSetClientSummary.Tables["DiagnosesIandII"].Rows)
            {
                string[] val = new string[2];
                val[0] = dr["DSMCode"].ToString();
                val[1] = dr["DSMNumber"].ToString();
                DataTable DataTableDSMDescriptions = Streamline.UserBusinessServices.SharedTables.DataSetDSMDescriptions.Tables[0].Clone();
                DataRow drDSMDesc = Streamline.UserBusinessServices.SharedTables.DataSetDSMDescriptions.Tables["DiagnosisDSMDescriptions"].Rows.Find(val);
                if (drDSMDesc != null)
                {
                    if (index >= 3)
                    {
                        //Following changes made as per Task #2373 of SC-Support
                        //diagnosisAxisIandIIValue += "...";
                        //break;
                        diagnosisAxisIandIIValue += val[0] + " " + drDSMDesc["DSMDescription"].ToString() + "<BR>";
                        index++;
                    }
                    else
                    {
                        diagnosisAxisIandIIValue += val[0] + " " + drDSMDesc["DSMDescription"].ToString() + "<BR>";
                        index++;
                    }
                }
            }

        }


        catch (Exception ex)
        {
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "";
                else
                    ex.Data["CustomExceptionInformation"] = "";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;

                Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);

            }
        }
        return diagnosisAxisIandIIValue;

    }

    /// <summary>
    /// Author:Sonia Dhamija
    /// Pupose:To Display Axis III codes
    /// </summary>
    /// <returns>string</returns>
    private string GetDiagnosisAxisIIIValues()
    {
        string diagnosisAxisIIIValues = "";
        DataView DataViewDiagnosisAxisIII = null;

        try
        {
            DataViewDiagnosisAxisIII = _DataSetClientSummary.Tables["DiagnosisIIICodes"].DefaultView;

            CommonFunctions.Event_Trap(this);


            int index = 0;
            DataViewDiagnosisAxisIII.RowFilter = "";
            DataViewDiagnosisAxisIII.RowFilter = "Axis=3";

            foreach (DataRowView dr in DataViewDiagnosisAxisIII)
            {
                string[] val = new string[2];
                val[0] = dr["DSMCode"].ToString();
                if (index >= 3)
                {
                    diagnosisAxisIIIValues += val[0] + " " + dr["DSMDescription"].ToString() + "<BR>";
                    index++;
                }
                else
                {
                    diagnosisAxisIIIValues += val[0] + " " + dr["DSMDescription"].ToString() + "<BR>";
                    index++;
                }

            }

        }
        catch (Exception ex)
        {

            if (ex.Data["CustomExceptionInformation"] == null)
                ex.Data["CustomExceptionInformation"] = "";
            else
                ex.Data["CustomExceptionInformation"] = "";
            if (ex.Data["DatasetInfo"] == null)
                ex.Data["DatasetInfo"] = null;

            Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);



        }
        finally
        {


        }

        return diagnosisAxisIIIValues;

    }


    #region Allergies




    public override bool RefreshPage()
    {
        Activate();
        return true;
    }
    #endregion

    /// <summary>
    /// Purpose:This function will be used to Get Client Medication Summary Data
    /// </summary>
    private void GetClientSummaryData()
    {
        Streamline.UserBusinessServices.DataSets.DataSetClientMedications DataSetClientMedications;

        try
        {
            objectClientMedications = new ClientMedication();
            //objectCommonFunctions = new ApplicationCommonFunctions();
            CommonFunctions.Event_Trap(this);
            string _ClientRowIdentifier = "";
            string _ClinicianrowIdentifier = "";

            DataSetClientMedications = new Streamline.UserBusinessServices.DataSets.DataSetClientMedications();
            try
            {
                _ClinicianrowIdentifier = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).ClinicianRowIdentifier;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "";

                string ParseMessage = ex.Message;
                if (ParseMessage.Contains("Object") == true)
                {
                    throw new Exception("Session Expired");
                }
            }
            _ClientRowIdentifier = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).Client.ClientRowIdentifier;

            if (_ClientRowIdentifier != "" && _ClinicianrowIdentifier != "")
            {
                _DataSetClientSummary = objectClientMedications.DownloadClientMedicationSummary(_ClientRowIdentifier, _ClinicianrowIdentifier);
                Session["DataSetClientMedications"] = null;
                Session["DataSetPrescribedClientMedications"] = null;//Added As per task#3323 By Pradeep on 4 March 2011
                Session["DataSetClientSummary"] = _DataSetClientSummary;

                DataSetClientMedications.EnforceConstraints = false;
                DataSetClientMedications.Tables["ClientMedications"].Merge(_DataSetClientSummary.Tables["ClientMedications"]);
                DataSetClientMedications.Tables["ClientMedicationInstructions"].Merge(_DataSetClientSummary.Tables["ClientMedicationInstructions"]);

                //Activate the MedicationClientPersonalInformation Control
                //MedicationClientPersonalInformation1.showEditableAllergyList = true;
                //MedicationClientPersonalInformation1.Activate();
                //LabelClientName.Text = "";
                //LabelClientName.Text = _DataSetClientSummary.Tables["ClientInformation"].Rows[0]["ClientInformationLabel"].ToString(); //DataSetClientSummary.Tables["ClientInformation"].Rows[0]["ClientInformationLabel"].ToString();                                    
            }
        }
        catch (Exception ex)
        {
            if (ex.Data["CustomExceptionInformation"] == null)
                ex.Data["CustomExceptionInformation"] = "";
            else
                ex.Data["CustomExceptionInformation"] = "";
            if (ex.Data["DatasetInfo"] == null)
                ex.Data["DatasetInfo"] = _DataSetClientSummary;
            Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);

        }
        finally
        {
            objectClientMedications = null;
            //objectCommonFunctions = null;
        }



    }

}

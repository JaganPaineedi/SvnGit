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


public partial class UserControls_MedicationPatientOverview : Streamline.BaseLayer.BaseActivityPage
{
    DataSet _DataSetClientSummary = null;
    DataView DataViewClientAllergies;
    Streamline.UserBusinessServices.ClientMedication objectClientMedications;


    protected void Page_Load(object sender, EventArgs e)
    {

    }


    public override void Activate()
    {
        try
        {
            CommonFunctions.Event_Trap(this);

            base.Activate();
            if (Session != null)
            {
                _DataSetClientSummary = (DataSet)Session["DataSetClientSummary"];
                if (_DataSetClientSummary.Tables["ClientInformation"].Rows.Count > 0)
                    BindControls();
                else
                    ClearControls();
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


            HyperLinkPatientName.InnerText = ApplicationCommonFunctions.cutText((_DataSetClientSummary.Tables["ClientInformation"].Rows[0]["LastName"].ToString() + ", " + _DataSetClientSummary.Tables["ClientInformation"].Rows[0]["FirstName"].ToString()), 15);

            // DOB/Age
            string DOB = _DataSetClientSummary.Tables["ClientInformation"].Rows[0]["DOB"].ToString();
            if (DOB == string.Empty)
                HyperLinkPatientDOB.InnerText = "";
            else
                HyperLinkPatientDOB.InnerText = DateTime.Parse(DOB).ToShortDateString() + " (" + GetAge(DOB) + ")";

            // Sex

            HyperLinkSex.InnerText = _DataSetClientSummary.Tables["ClientInformation"].Rows[0]["SEX"].ToString();

            // Race
            this.HyperLinkRace.InnerText = ApplicationCommonFunctions.cutText(_DataSetClientSummary.Tables["ClientInformation"].Rows[0]["ClientRace"].ToString(), 20); ;

            // Diagnosis
            if (_DataSetClientSummary.Tables["DiagnosesIandII"].Rows.Count > 0)
            {

                this.HyperlinkDiagnosis.InnerHtml = Streamline.UserBusinessServices.ApplicationCommonFunctions.WrappableText(GetDiagnosisValue());
                //this.HyperlinkDiagnosis.InnerHtml = GetDiagnosisValue();
                //this.linkLabelDiagnosis.Tag = _DataSetClientSummary.Tables[1].Rows[0]["DocumentId"].ToString() + "," + _DataSetClientSummary.Tables[1].Rows[0]["Version"].ToString();
            }
            else
            {
                this.HyperlinkDiagnosis.InnerText = "";
                //this.linkLabelDiagnosis.Tag = "";
            }

            //Axis III Code display added as per 2373 SC-Support
            if (_DataSetClientSummary.Tables["DiagnosisIIICodes"].Rows.Count > 0)
            {
                this.HyperLinkAxisIII.InnerHtml = Streamline.UserBusinessServices.ApplicationCommonFunctions.WrappableText(GetDiagnosisAxisIIIValues());
            }
            else
            {
                this.HyperLinkAxisIII.InnerText = "";
            }


            // Last Seen Date
            if (_DataSetClientSummary.Tables["LastMedicationVisit"].Rows.Count > 0)
            {
                DateTime prevDate = DateTime.Parse(_DataSetClientSummary.Tables["LastMedicationVisit"].Rows[0]["DateOfService"].ToString());
                string procedureName = _DataSetClientSummary.Tables["LastMedicationVisit"].Rows[0]["ProcedureName"].ToString();
                string staffName = _DataSetClientSummary.Tables["LastMedicationVisit"].Rows[0]["StaffName"].ToString();
                this.HyperLinkLastMedicationVisit.InnerText = prevDate.ToShortDateString() + " " + prevDate.ToShortTimeString() + " " + procedureName + " " + staffName;
            }
            else
                this.HyperLinkLastMedicationVisit.InnerText = "";


            // Next Date
            if (_DataSetClientSummary.Tables["NextMedicationVisit"].Rows.Count > 0)
            {
                DateTime nextDate = DateTime.Parse(_DataSetClientSummary.Tables["NextMedicationVisit"].Rows[0]["DateOfService"].ToString());
                this.HyperLinkNextMedicationVisit.InnerText = nextDate.ToShortDateString() + " " + nextDate.ToShortTimeString();
            }
            else
                HyperLinkNextMedicationVisit.InnerText = "";
            //DisplayAllergiesData(_DataSetClientSummary.Tables[7]);




        }
        catch (Exception ex)
        {
            throw (ex);
        }

    }


    private void ClearControls()
    {
        //this.linkLabelClientIdValue.Text = "";
        HyperlinkDiagnosis.InnerText = "";
        HyperLinkLastMedicationVisit.InnerText = "";
        HyperLinkNextMedicationVisit.InnerText = "";
        HyperLinkPatientName.InnerText = "";
        HyperLinkPatientDOB.InnerText = "";
        HyperLinkRace.InnerText = "";
        HyperLinkSex.InnerText = "";


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

            /*     switch (_DataSetClientSummary.Tables[1].Rows.Count)
                 {
                     case 0:
                         diagnosisAxisIandIIValue += "&nbsp;<BR /><BR /><BR />";
                         break;
                     case 1:
                         diagnosisAxisIandIIValue += "&nbsp;<BR /><BR />";
                         break;
                     case 2:
                         diagnosisAxisIandIIValue += "&nbsp;<BR />";
                         break;



                 }*/


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
            /*     switch (DataViewDiagnosisAxisIII.Table.Rows.Count)
                  {
                      case 0:
                          diagnosisAxisIIIValues += "&nbsp;<BR /><BR /><BR />";
                          break;
                      case 1:
                          diagnosisAxisIIIValues += "&nbsp;<BR /><BR />";
                          break;
                      case 2:
                          diagnosisAxisIIIValues += "&nbsp;<BR />";
                          break;
                  }*/


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
}

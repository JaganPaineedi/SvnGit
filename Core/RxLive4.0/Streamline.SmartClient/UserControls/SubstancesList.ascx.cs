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
using System.Text.RegularExpressions;
using Streamline.BaseLayer;
using Streamline.UserBusinessServices;
using System.Text;

namespace Streamline.SmartClient.UI
{
    public partial class UserControls_SubstancesList : BaseActivityPage
    {
        public string ClientInformation { get; private set; }
        public string PrescriberInformation { get; private set; }
        public string PharmacyInformation { get; private set; }
        public bool ShowDisclaimer { get; private set;}
        public string DisclaimerText { get; private set; }

        protected override void Page_Load(object sender, EventArgs e)
        {
            Streamline.UserBusinessServices.ClientMedication objClientMedications = new ClientMedication();
            DataSet _dsReconciliationDataList = objClientMedications.GetElectronicPrescriptionData(Session["ElectronicScriptIds"].ToString(), 0);
            SubstancesListView.DataSource = _dsReconciliationDataList.Tables["MedicationData"];
            SubstancesListView.DataBind();

            Disclaimer.Text = "";
            Disclaimer.Visible = false;
            DataTable dt = _dsReconciliationDataList.Tables["MedicationData"];
            bool EPCSCheck = ((StreamlinePrinciple)Context.User).HasPermission(Permissions.EPCS);
            if (EPCSCheck == false)
            {
                HiddenEPCSPermisions.Value= "false";
            
            }

            if (dt.Rows.Count > 0)
            {
                foreach (DataRow dr in dt.Rows)
                {
                    if (dr[21].ToString() != "0")
                    {
                        Disclaimer.Text = "By completing the two-factor authentication protocol at this time, you are legally sigining the prescriptions(s) \n and authorizing the transmission of the above information to the pharmacy for dispensing. The two-factor authentication protocol may only be completed by the practitioner whose name and DEA registration number appear above.".Replace("\n",Environment.NewLine);
                        Disclaimer.Visible = true;
                        break;
                    }
                }
            }

            if (_dsReconciliationDataList.Tables["OtherData"] != null)
            {
                ClientInformation = _dsReconciliationDataList.Tables["OtherData"].Rows[0]["PATIENTDETAILS"].ToString();
                PrescriberInformation = _dsReconciliationDataList.Tables["OtherData"].Rows[0]["PRESCRIBERDETAILS"].ToString();
                PharmacyInformation = _dsReconciliationDataList.Tables["OtherData"].Rows[0]["PHARMACYDETIALS"].ToString();
              //  _dsReconciliationDataList.Tables["MedicationData"].Rows[0]["WRITTENDATE"];
            }
            if (_dsReconciliationDataList.Tables["MedicationData"].Rows.Count>0 && _dsReconciliationDataList.Tables["MedicationData"].Rows[0]["ControlledMedicationScriptIds"] != null)
                Session["ControlledMedicationScriptIds"] = _dsReconciliationDataList.Tables["MedicationData"].Rows[0]["ControlledMedicationScriptIds"].ToString();
        }
    }
}
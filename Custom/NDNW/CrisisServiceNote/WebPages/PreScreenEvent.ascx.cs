using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;

namespace SHS.SmartCare
{
    public partial class ActivityPages_Client_CMDocuments_PreScreenEvent : SHS.BaseLayer.ActivityPages.DocumentDataActivityMultiTabPage
    {
        //protected void Page_Load(object sender, EventArgs e)
        //{

        //}
        public override string DefaultTab
        {
            get { return "/ActivityPages/Client/CMDocuments/General.ascx"; }
        }

        public override string MultiTabControlName
        {
            get { return "RadMultiPage1"; }
        }

        public override void setTabIndex(int TabIndex, out ControlCollection ctlcollection, out string UcPath)
        {
            ctlcollection = this.RadMultiPage1.Controls[TabIndex].Controls;
            RadTabStrip1.SelectedIndex = (short)TabIndex;
            RadMultiPage1.SelectedIndex = (short)TabIndex;
            UcPath = RadTabStrip1.Tabs[TabIndex].Attributes["Path"];

        }

        public override string PageDataSetName
        {
            get { return "DataSetPreScreens"; }
        }

        public override string[] TablesToBeInitialized
        {
            get { return new string[] { "CustomAcuteServicesPrescreens,DocumentDiagnosisCodes,DocumentDiagnosis,DocumentDiagnosisFactors" }; }
        }

        public override void BindControls()
        {

        }

        /// <summary>
        /// Added By Damanpreet Kaur
        /// Added On 7th Aug 2010
        /// </summary>
        /// <param name="dataSetObject"></param>
        public override void ChangeDataSetBeforeUpdate(ref DataSet dataSetObject)
        {
            //CheckDSNNumberDiagnosisIandII(ref dataSetObject);
            string[] dataTables = new string[] { "DiagnosesIANDIIMaxOrder" };

            if (dataSetObject != null)
            {
                for (int count = 0; count < dataTables.Length; count++)
                {
                    if (dataSetObject.Tables.Contains(dataTables[count]) == true)
                    {
                        dataSetObject.Tables.Remove(dataTables[count].ToString());
                    }
                }
                if (dataSetObject.Tables.Contains("CustomMedicationHistory")) //Added By Vichee CWN-Support #148
                {
                    if (dataSetObject.Tables["CustomMedicationHistory"].Rows.Count > 0) //Added By Vichee CWN-Support #148
                    {
                for (int count = 0; count < dataSetObject.Tables["CustomMedicationHistory"].Rows.Count; count++)
                {
                    if (dataSetObject.Tables.Contains("CustomMedicationHistory") && dataSetObject.Tables["CustomMedicationHistory"].Rows.Count > 0)
                    {
                        dataSetObject.Tables["CustomMedicationHistory"].Rows[count]["PrescribingPhysician"] = Server.HtmlDecode(dataSetObject.Tables["CustomMedicationHistory"].Rows[count]["PrescribingPhysician"].ToString());

                        dataSetObject.Tables["CustomMedicationHistory"].Rows[count]["MedicationName"] = Server.HtmlDecode(dataSetObject.Tables["CustomMedicationHistory"].Rows[count]["MedicationName"].ToString());

                        dataSetObject.Tables["CustomMedicationHistory"].Rows[count]["DosageFrequency"] = Server.HtmlDecode(dataSetObject.Tables["CustomMedicationHistory"].Rows[count]["DosageFrequency"].ToString());
                    }
                }
                }
            }
            }
            else
            {
                throw new ApplicationException("DataSet is Null");
            }
        }

        //private void CheckDSNNumberDiagnosisIandII(ref DataSet dataSetObject)
        //{
        //    if (dataSetObject != null)
        //    {
        //        if (dataSetObject.Tables.Contains("DiagnosesIAndII"))
        //        {
        //            if (dataSetObject.Tables["DiagnosesIAndII"].Rows.Count > 0)
        //            {
        //                for (int rows = 0; rows < dataSetObject.Tables["DiagnosesIAndII"].Rows.Count; rows++)
        //                {
        //                    try
        //                    {
        //                        if (Convert.ToInt32(dataSetObject.Tables["DiagnosesIAndII"].Rows[rows]["DSMNumber"]) > 9)
        //                        {
        //                            throw new SHS.BaseLayer.CustomException("Please Enter valid value for DSNNumber.", 0, null);
        //                            //throw new ApplicationException("Please Enter valid value for DSNNumber");
        //                        }
        //                    }
        //                    catch (Exception ex)
        //                    {
        //                       // throw new ApplicationException("Please Enter valid value for DSNNumber");
        //                        throw new SHS.BaseLayer.CustomException("Please Enter valid value for DSNNumber.",0, null);
        //                    }
        //                }
        //            }
        //        }
        //    }
        //}

    }
}

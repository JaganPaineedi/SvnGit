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
using System.Collections.Generic;

namespace Streamline.SmartClient.UI
{
    public partial class UserControls_PharmacyManagement : Streamline.BaseLayer.BaseActivityPage
    {
        Streamline.UserBusinessServices.DataSets.DataSetPharmacies _dsPharmacies;
        Streamline.UserBusinessServices.ClientMedication objectClientMedications = null;
        public override void Activate()
        {
            try
            {
                CommonFunctions.Event_Trap(this);               
                _dsPharmacies = new Streamline.UserBusinessServices.DataSets.DataSetPharmacies();
                CheckBoxActive.Checked = true;
                FillStates();
                HiddenRadioButtonValue.Value = "Activate";
                ScriptManager.RegisterStartupScript(this.Label1, Label1.GetType(), "", "SetDefaultFocus('" + TextBoxName.ClientID + "');", true);
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

        private void GetPharmacies()
        {
            DataSet dsTemp = null;
            DataSet dsPharmacies = null;
            DataRow[] _dr = null;
            try
            {
                CommonFunctions.Event_Trap(this);
                Session["PharmacyId"] = null;
                dsTemp = new DataSet();
                dsPharmacies = new DataSet();
                objectClientMedications = new ClientMedication();
                dsTemp = objectClientMedications.GetPharmaciesData();
                _dr = dsTemp.Tables["Pharmacies"].Select("Active = 'Y' And IsNull(RecordDeleted,'N')<>'Y'", "PharmacyName asc");
                dsPharmacies.Merge(_dr);
                ScriptManager.RegisterStartupScript(Label1, Label1.GetType(), "key", "PharmacyManagement.FillPharmacies();", true);
            }
            catch (Exception ex)
            {

                throw;
            }
            finally
            {
                _dsPharmacies = null;
                dsTemp = null;
            }
        }
        protected override void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (System.Configuration.ConfigurationSettings.AppSettings["OpenFromSmartCare"].ToString().ToUpper() == "FALSE")
                {
                    LinkButtonLogout.Style["display"] = "block";
                    LinkButtonStartPage.Style["display"] = "block";
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

        }
        
        private void FillStates()
        {
            DataView _dataViewStates = null;
            try
            {
                _dataViewStates = Streamline.UserBusinessServices.SharedTables.DataSetStates.Tables[0].DefaultView;
                _dataViewStates.Sort = "StateName";
                DropDownListState.DataSource = _dataViewStates;
                DropDownListState.DataTextField = "StateName";
                DropDownListState.DataValueField = "StateAbbreviation";
                DropDownListState.DataBind();

                DropDownListState.Items.Insert(0, new ListItem("........Select State........", "0"));
                DropDownListState.SelectedIndex = 0;
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
                _dataViewStates = null;
            }
        }

        protected void LinkButtonLogout_Click(object sender, EventArgs e)
        {
            Response.Redirect("MedicationLogin.aspx");
        }
    }
}

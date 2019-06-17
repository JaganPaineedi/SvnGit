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
using System.Data.SqlTypes;

namespace Streamline.SmartClient.UI
{
    public partial class UserControls_UserPreferences : Streamline.BaseLayer.BaseActivityPage
    {
        Streamline.UserBusinessServices.DataSets.DataSetUserPrefrences dsUserPreferences = null;
        Streamline.UserBusinessServices.UserPrefernces objUserPreferences = null;
        Streamline.UserBusinessServices.ClientMedication objectClientMedications = null;
        Streamline.UserBusinessServices.ApplicationCommonFunctions objApplicationCommonFunctions;
        int count = 0;
        char isEPCSPermissionSet = 'N';
        //Changes to merge.
        private string _onDeleteEventHandler = "onDeleteClick";

        public string onDeleteEventHandler
        {
            get { return _onDeleteEventHandler; }
            set { _onDeleteEventHandler = value; }
        }

        private string _deleteRowMessage = "Are you sure you want to delete this row?";

        public override void Activate()
        {
            try
            {
                Session["EPCSAssignor"]=((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId;
                //Code added by Loveena in ref to Task#2538 to disable Delete Button to unable the user to Delete himself/herself
                if (((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId == Convert.ToInt32(Session["StaffIdForPreferences"]))
                {
                   // ButtonDelete.Enabled = false;
                    ButtonDelete.Attributes.Add("class", "DisableKeyPharses");
                }
                //Code added ends over here.
                //Changes for merge.
                //This condition check if Page is opened from ClientList page then opens the page
                //with the information filled of login user.
                if (((HiddenField)(Page.FindControl("HiddenPageName"))).Value == "ClientList")
                {
                   // ButtonDelete.Enabled = false;
                    ButtonDelete.Attributes.Add("class", "DisableKeyPharses");
                    Session["StaffIdForPreferences"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId;
                }
                //Code added by Loveena in ref to Task#3216 User Preference:-Delete Button enable for New user creation. 
                if (Session["StaffIdForPreferences"] == null)
                {
                  //  ButtonDelete.Enabled = false;
                    ButtonDelete.Attributes.Add("class", "DisableKeyPharses");
                }
                Session["Permissions"] = "";
                HiddenStaffPermissionId.Value = "";
                CommonFunctions.Event_Trap(this);
                Session["DataSetPermissionsList"] = null;
                objUserPreferences = new UserPrefernces();
                dsUserPreferences = new Streamline.UserBusinessServices.DataSets.DataSetUserPrefrences();
                //Start Code Comented By Pradeep as per task#23
                //FillLocationsCombo();
                //End Code Comented By Pradeep as per task#23
                FillDegree();
                FillPasswordExpiresCombo();
                //--Code Added by Pradeep as per task#3315 Strt Over Here
                FillServiceLevel();
                //--Code Added by Pradeep as per task#3315 END Over Here
                //Added in ref to Task#2655.
                TextBoxPassword.Font.Bold = true;
                TextBoxPassword.Attributes.Add("onfocus", "RemoveUserPassword();");
                TextBoxPassword.Attributes.Add("onblur", "AddUserPassword();");

                TextBoxConfirmPassword.Font.Bold = true;
                TextBoxConfirmPassword.Attributes.Add("onfocus", "RemoveConfirmPassword();");
                TextBoxConfirmPassword.Attributes.Add("onblur", "AddConfirmPassword();");
                GetStaffData();
                #region--Code Added by Pradeep as per task#23
                GenerateUserPreferancesLocationListRows();
                #endregion
                if (Session["StaffIdForPreferences"] == null)
                {
                    CheckBoxListActive.Items[0].Selected = true;
                    //LabelVisit.Text = DateTime.Now.ToString("MM/dd/yyyy hh:mm tt");
                    LabelVisit.Text = string.Empty;
                }
                TextBoxFirstName.Attributes.Add("onBlur", "ValidateName(this,'FirstName');");
                TextBoxLastName.Attributes.Add("onBlur", "ValidateName(this,'LastName');");
                TextBoxDeviceUsername.Attributes.Add("onBlur", "TrimUserName();");
                TextBoxEmail.Attributes.Add("onBlur", "Validate(this,'Please enter valid email.');");                
                TextBoxMedicationDays.Attributes.Add("onkeypress", "doKeyPress(this);");
                //Start Code Added by Pradeep as per task#2639 on Nov 25,2009
                this.TextBoxDefaultPrescribingQuantity.Attributes.Add("onkeypress", "doKeyPress(this);");
                //End Code Added by Pradeep as per task#2639 on Nov 25,2009
                TextBoxPhone.Attributes.Add("onBlur", "GetFormatedPhoneNumber();");
                TextBoxFaxNumber.Attributes.Add("onBlur", "GetFormatedFaxNumber();");
                CheckBoxPasswordExpires.Attributes.Add("onclick", "EnableDisableDropDownList();");
                //added as Per Task No:3046
                #region--Code commented by Pradeep as per task#3056
                //TextBoxFirstName.Attributes.Add("onkeydown", "if(event.which || event.keyCode){if ((event.which == 13) || (event.keyCode == 13)) {document.getElementById('" + ButtonUpdate.UniqueID + "').focus();return false;}} else {return true}; ");
                //TextBoxLastName.Attributes.Add("onkeydown", "if(event.which || event.keyCode){if ((event.which == 13) || (event.keyCode == 13)) {document.getElementById('" + ButtonUpdate.UniqueID + "').focus();return false;}} else {return true}; ");
                //TextBoxPhone.Attributes.Add("onkeydown", "if(event.which || event.keyCode){if ((event.which == 13) || (event.keyCode == 13)) {document.getElementById('" + ButtonUpdate.UniqueID + "').focus();return false;}} else {return true}; ");
                //TextBoxFaxNumber.Attributes.Add("onkeydown", "if(event.which || event.keyCode){if ((event.which == 13) || (event.keyCode == 13)) {document.getElementById('" + ButtonUpdate.UniqueID + "').focus();return false;}} else {return true}; ");
                //TextBoxEmail.Attributes.Add("onkeydown", "if(event.which || event.keyCode){if ((event.which == 13) || (event.keyCode == 13)) {document.getElementById('" + ButtonUpdate.UniqueID + "').focus();return false;}} else {return true}; ");
                //TextBoxUserName.Attributes.Add("onkeydown", "if(event.which || event.keyCode){if ((event.which == 13) || (event.keyCode == 13)) {document.getElementById('" + ButtonUpdate.UniqueID + "').focus();return false;}} else {return true}; ");
                //TextBoxAddress.Attributes.Add("onkeydown", "if(event.which || event.keyCode){if ((event.which == 13) || (event.keyCode == 13)) {document.getElementById('" + ButtonUpdate.UniqueID + "').focus();return false;}} else {return true}; ");
                //TextBoxLicense.Attributes.Add("onkeydown", "if(event.which || event.keyCode){if ((event.which == 13) || (event.keyCode == 13)) {document.getElementById('" + ButtonUpdate.UniqueID + "').focus();return false;}} else {return true}; ");
                //TextBoxDEA.Attributes.Add("onkeydown", "if(event.which || event.keyCode){if ((event.which == 13) || (event.keyCode == 13)) {document.getElementById('" + ButtonUpdate.UniqueID + "').focus();return false;}} else {return true}; ");
                //TextBoxNPI.Attributes.Add("onkeydown", "if(event.which || event.keyCode){if ((event.which == 13) || (event.keyCode == 13)) {document.getElementById('" + ButtonUpdate.UniqueID + "').focus();return false;}} else {return true}; ");
                //TextBoxSureScriptsPrescriberId.Attributes.Add("onkeydown", "if(event.which || event.keyCode){if ((event.which == 13) || (event.keyCode == 13)) {document.getElementById('" + ButtonUpdate.UniqueID + "').focus();return false;}} else {return true}; ");
                //TextBoxPassword.Attributes.Add("onkeydown", "if(event.which || event.keyCode){if ((event.which == 13) || (event.keyCode == 13)) {document.getElementById('" + ButtonUpdate.UniqueID + "').focus();return false;}} else {return true}; ");
                //TextBoxConfirmPassword.Attributes.Add("onkeydown", "if(event.which || event.keyCode){if ((event.which == 13) || (event.keyCode == 13)) {document.getElementById('" + ButtonUpdate.UniqueID + "').focus();return false;}} else {return true}; ");
                //TextBoxSigning.Attributes.Add("onkeydown", "if(event.which || event.keyCode){if ((event.which == 13) || (event.keyCode == 13)) {document.getElementById('" + ButtonUpdate.UniqueID + "').focus();return false;}} else {return true}; ");
                #endregion
                #region--Code Added by Pradeep as per task#3056
                TextBoxFirstName.Attributes.Add("onkeydown", "if(event.which || event.keyCode){if ((event.which == 13) || (event.keyCode == 13)) {document.getElementById('" + ButtonUpdate.ClientID + "').click();return false;}} else {return true}; ");
                TextBoxLastName.Attributes.Add("onkeydown", "if(event.which || event.keyCode){if ((event.which == 13) || (event.keyCode == 13)) {document.getElementById('" + ButtonUpdate.ClientID + "').click();return false;}} else {return true}; ");
                TextBoxPhone.Attributes.Add("onkeydown", "if(event.which || event.keyCode){if ((event.which == 13) || (event.keyCode == 13)) {document.getElementById('" + ButtonUpdate.ClientID + "').click();return false;}} else {return true}; ");
                TextBoxFaxNumber.Attributes.Add("onkeydown", "if(event.which || event.keyCode){if ((event.which == 13) || (event.keyCode == 13)) {document.getElementById('" + ButtonUpdate.ClientID + "').click();return false;}} else {return true}; ");
                TextBoxEmail.Attributes.Add("onkeydown", "if(event.which || event.keyCode){if ((event.which == 13) || (event.keyCode == 13)) {document.getElementById('" + ButtonUpdate.ClientID + "').click();return false;}} else {return true}; ");
                TextBoxUserName.Attributes.Add("onkeydown", "if(event.which || event.keyCode){if ((event.which == 13) || (event.keyCode == 13)) {document.getElementById('" + ButtonUpdate.ClientID + "').click();return false;}} else {return true}; ");
                //TextBoxAddress.Attributes.Add("onkeydown", "if(event.which || event.keyCode){if ((event.which == 13) || (event.keyCode == 13)) {document.getElementById('" + ButtonUpdate.ClientID + "').click();return false;}} else {return true}; ");
                TextBoxAddress.Attributes.Add("onchange", "document.getElementById('" + ButtonUpdate.ClientID + "').click();return false; ");
                //TextBoxLicense.Attributes.Add("onkeydown", "if(event.which || event.keyCode){if ((event.which == 13) || (event.keyCode == 13)) {document.getElementById('" + ButtonUpdate.ClientID + "').click();return false;}} else {return true}; ");
                //TextBoxDEA.Attributes.Add("onkeydown", "if(event.which || event.keyCode){if ((event.which == 13) || (event.keyCode == 13)) {document.getElementById('" + ButtonUpdate.ClientID + "').click();return false;}} else {return true}; ");
                //TextBoxNPI.Attributes.Add("onkeydown", "if(event.which || event.keyCode){if ((event.which == 13) || (event.keyCode == 13)) {document.getElementById('" + ButtonUpdate.ClientID + "').click();return false;}} else {return true}; ");
                TextBoxSureScriptsPrescriberId.Attributes.Add("onkeydown", "if(event.which || event.keyCode){if ((event.which == 13) || (event.keyCode == 13)) {document.getElementById('" + ButtonUpdate.ClientID + "').click();return false;}} else {return true}; ");
                TextBoxPassword.Attributes.Add("onkeydown", "if(event.which || event.keyCode){if ((event.which == 13) || (event.keyCode == 13)) {document.getElementById('" + ButtonUpdate.ClientID + "').click();return false;}} else {return true}; ");
                TextBoxConfirmPassword.Attributes.Add("onkeydown", "if(event.which || event.keyCode){if ((event.which == 13) || (event.keyCode == 13)) {document.getElementById('" + ButtonUpdate.ClientID + "').click();return false;}} else {return true}; ");
                TextBoxSigning.Attributes.Add("onkeydown", "if(event.which || event.keyCode){if ((event.which == 13) || (event.keyCode == 13)) {document.getElementById('" + ButtonUpdate.ClientID + "').click();return false;}} else {return true}; ");
                TextBoxMedicationDays.Attributes.Add("onkeydown", "if(event.which || event.keyCode){if ((event.which == 13) || (event.keyCode == 13)) {document.getElementById('" + ButtonUpdate.ClientID + "').click();return false;}} else {return true}; ");
                TextBoxDefaultPrescribingQuantity.Attributes.Add("onkeydown", "if(event.which || event.keyCode){if ((event.which == 13) || (event.keyCode == 13)) {document.getElementById('" + ButtonUpdate.ClientID + "').click();return false;}} else {return true}; ");
                #endregion

                //end
                HiddenPasswordExpires.Value = string.Empty;
                HiddenPasswordExpiresSelectedValue.Value = string.Empty;
                // ScriptManager.RegisterStartupScript(this.Label1, Label1.GetType(), "", "SetDefaultFocus('" + TextBoxFirstName.ClientID + "');", true);
                ScriptManager.RegisterStartupScript(LabelEmail, LabelEmail.GetType(), "", "javascript:PasswordInput();", true);
                //Added on 26 dec
                if (((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).Administrator == "Y")
                {
                    TableGeneral.Enabled = true;

                }
                else
                {
                    TableGeneral.Enabled = false;

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
                objUserPreferences = null;
            }
        }
        protected override void Page_Load(object sender, EventArgs e)
        {
            try
            {
                //Changes for merge.
                //GenerateRows(); 
                //Added in ref to Task#2895
                if (System.Configuration.ConfigurationSettings.AppSettings["OpenFromSmartCare"].ToString().ToUpper() == "FALSE")
                {
                    LinkButtonLogout.Style["display"] = "block";
                    LinkButtonStartPage.Style["display"] = "block";
                }
                //#region--Code Added By Pradeep as per task#3155
                if (((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).Administrator == "Y")
                {
                    if (HiddenIDGenerated.Value == "Y")
                    {
                        this.ButtonRegister.Value = "Update Registration";
                    }
                }

                
                if (Session["DataSetPermissionsList"] != null)
                {
                    if (((DataSet)(Session["DataSetPermissionsList"])).Tables.Count > 0)
                    {
                        DataRow[] drEPCS = ((DataSet)(Session["DataSetPermissionsList"])).Tables["StaffPermissions"].Select("ActionId=10074 AND ISNULL(RecordDeleted,'N')='N'");
                        if (drEPCS.Length > 0)
                        {
                            //tableDeviceRegistration.Style.Add("display", "block");
                            isEPCSPermissionSet = 'Y';
                        }
                        else
                        {
                            //tableDeviceRegistration.Style.Add("display", "none");
                            isEPCSPermissionSet = 'N';
                        }
                    }

                }
                else if (((StreamlinePrinciple)Context.User).HasPermission(Streamline.BaseLayer.Permissions.EPCS))
                {
                    //tableDeviceRegistration.Style.Add("display", "block");
                    isEPCSPermissionSet = 'Y';
                }
                else
                {
                    //tableDeviceRegistration.Style.Add("display", "none");
                    isEPCSPermissionSet = 'N';
                }
                
                //isEPCSPermissionSet = 'Y';


                if (HiddenSureScriptPrescriberId.Value != "")
                {
                    TextBoxSureScriptsPrescriberId.Text = HiddenSureScriptPrescriberId.Value.ToString();
                }
                //----Code Added by Pradeep as per task#3315 Strt Over Here
                TextBoxActiveStartTime.Attributes.Add("onBlur", " return ValidateDateField('" + TextBoxActiveStartTime.ClientID + "');");
                TextBoxActiveEndTime.Attributes.Add("onBlur", " return ValidateDateField('" + TextBoxActiveEndTime.ClientID + "');");
                //----Code Added by Pradeep as per task#3315 End Over Here
                //#endregion

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

        private void FillDegree()
        {
            DataSet DataSetDegree = null;
            try
            {
                DataSetDegree = new DataSet();
                DataSetDegree = Streamline.UserBusinessServices.SharedTables.DataSetGlobalCodes.Clone();
                DataRow[] DataRowDegree = Streamline.UserBusinessServices.SharedTables.DataSetGlobalCodes.Tables[0].Select("Category='DEGREE' And ISNULL(RecordDeleted,'N')='N'", "CodeName Asc");
                DataSetDegree.Merge(DataRowDegree);
                DropDownListDegree.DataSource = DataSetDegree;
                DropDownListDegree.DataTextField = "CodeName";
                DropDownListDegree.DataValueField = "GlobalCodeID";
                DropDownListDegree.DataBind();

                DropDownListDegree.Items.Insert(0, new ListItem("........Select Degree........", "0"));
                DropDownListDegree.SelectedIndex = 0;
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
                DataSetDegree = null;
            }
        }
        #region--CodeComented By Pradeep as per task#23
        //private void FillLocationsCombo()
        //{

        //DataTable DataTableStaffLocations = null;

        //DataView DataViewLocations = null;
        //try
        //    {
        //    CommonFunctions.Event_Trap(this);
        //    DataTableStaffLocations = ((Streamline.BaseLayer.StreamlinePrinciple)Context.User).StaffPrescribingLocations;
        //    DataViewLocations = DataTableStaffLocations.DefaultView;
        //    DataViewLocations.Sort = "LocationName Asc";
        //    DropDownListDefaultLocation.DataSource = DataViewLocations;
        //    DropDownListDefaultLocation.DataTextField = "LocationName";
        //    DropDownListDefaultLocation.DataValueField = "LocationId";
        //    DropDownListDefaultLocation.DataBind();

        //    DropDownListDefaultLocation.Items.Insert(0, new ListItem("........Select Location........", "0"));
        //    DropDownListDefaultLocation.SelectedIndex = 0;


        //    }
        //catch (Exception ex)
        //    {

        //    if (ex.Data["CustomExceptionInformation"] == null)
        //        ex.Data["CustomExceptionInformation"] = CommonFunctions.Event_FormatString("###Source Function Name - FillLocationsCombo(),ParameterCount 0 - ###");
        //    else
        //        ex.Data["CustomExceptionInformation"] = CommonFunctions.Event_FormatString(ex.Data["CustomExceptionInformation"].ToString());
        //    if (ex.Data["DatasetInfo"] == null)
        //        ex.Data["DatasetInfo"] = null;
        //    Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);

        //    }
        //finally
        //    {

        //    DataViewLocations = null;
        //    if (DataTableStaffLocations != null)
        //        DataTableStaffLocations.Dispose();

        //    }

        //}
        #endregion
        private void FillPasswordExpiresCombo()
        {
            DataSet DataSetPasswordExpires = null;
            try
            {
                DataSetPasswordExpires = new DataSet();
                DataSetPasswordExpires = Streamline.UserBusinessServices.SharedTables.DataSetGlobalCodes.Clone();
                DataRow[] DataRowPasswordExpires = Streamline.UserBusinessServices.SharedTables.DataSetGlobalCodes.Tables[0].Select("Category = 'PasswordExpires' AND Active = 'Y' AND (RecordDeleted='N' OR RecordDeleted IS NULL)");
                DataSetPasswordExpires.Merge(DataRowPasswordExpires);
                DropDownListPasswordExpires.DataSource = DataSetPasswordExpires;
                DropDownListPasswordExpires.DataTextField = "CodeName";
                DropDownListPasswordExpires.DataValueField = "GlobalCodeID";
                DropDownListPasswordExpires.DataBind();

                DropDownListPasswordExpires.Items.Insert(0, new ListItem("", "0"));
                DropDownListPasswordExpires.SelectedIndex = 0;
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
                DataSetPasswordExpires = null;
            }
        }
        private void GetStaffData()
        {
            DataRow[] _dataRowView;
            DataSet dsTemp = new DataSet();
            DataSet DataSetStaff = new DataSet();
            DataSet DataSetLocationList = null;//Added By Pradeep as per task#23
            //dsUserPreferences = new Streamline.UserBusinessServices.DataSets.DataSetUserPrefrences();
            try
            {
                LabelDate.Text = DateTime.Now.ToString("MM/dd/yyyy");
                CommonFunctions.Event_Trap(this);
                //Code added in Ref to Task32595
                int numberOfSecurityQuestionsAnswered = 0;
                if (Session["StaffIdForPreferences"] != null)
                {
                    dsTemp = objUserPreferences.CheckStaffPermissions(Convert.ToInt32(Session["StaffIdForPreferences"]));
                    //--Start Code Written by Pradeep as per task#23
                    // DataSetLocationList = objUserPreferences.GetUserPreferancesLocationList(Convert.ToInt32(((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId));
                    DataSetLocationList = objUserPreferences.GetUserPreferancesLocationList(Convert.ToInt32(Session["StaffIdForPreferences"]));
                    dsUserPreferences.Locations.Merge(DataSetLocationList.Tables["Locations"]);
                    dsUserPreferences.StaffLocations.Merge(DataSetLocationList.Tables["StaffLocations"]);
                    dsUserPreferences.PrinterDeviceLocations.Merge(DataSetLocationList.Tables["PrinterDeviceLocations"]);
                    //End Code Writen By Pradeep as per task#23
                    dsUserPreferences.Staff.Merge(dsTemp.Tables[0]);
                    dsUserPreferences.TwoFactorAuthenticationDeviceRegistrations.Merge(dsTemp.Tables[3]);
                    //Code added in ref to Task#2595
                    dsUserPreferences.StaffSecurityQuestions.Merge(dsTemp.Tables[2]);
                    numberOfSecurityQuestionsAnswered = dsUserPreferences.StaffSecurityQuestions.Rows.Count;
                    _dataRowView = dsUserPreferences.Tables[0].Select("StaffId=" + Convert.ToInt32(Session["StaffIdForPreferences"]));
                    if (_dataRowView.Length > 0)
                    {
                        DataSetStaff.Merge(_dataRowView);
                        TextBoxFirstName.Text = DataSetStaff.Tables[0].Rows[0]["FirstName"].ToString();
                        TextBoxLastName.Text = DataSetStaff.Tables[0].Rows[0]["LastName"].ToString();
                        TextBoxEmail.Text = DataSetStaff.Tables[0].Rows[0]["Email"].ToString();
                        TextBoxPhone.Text = DataSetStaff.Tables[0].Rows[0]["PhoneNumber"].ToString();
                        TextBoxFaxNumber.Text = DataSetStaff.Tables[0].Rows[0]["FaxNumber"].ToString();
                        TextBoxSigning.Text = DataSetStaff.Tables[0].Rows[0]["SigningSuffix"].ToString();
                        TextBoxUserName.Text = DataSetStaff.Tables[0].Rows[0]["UserCode"].ToString();
                        TextBoxLicense.Text = DataSetStaff.Tables[0].Rows[0]["LicenseNumber"].ToString();
                        TextBoxAddress.Text = DataSetStaff.Tables[0].Rows[0]["AddressDisplay"].ToString();
                        TextBoxNPI.Text = DataSetStaff.Tables[0].Rows[0]["NationalProviderId"].ToString();
                        TextBoxNADEA.Text = DataSetStaff.Tables[0].Rows[0]["NADEANumber"].ToString();

                        //Added by Loveena in ref to Task#85

                        //TextBoxSureScriptsPrescriberId.Text = Convert.ToString(DataSetStaff.Tables[0].Rows[0]["SureScriptsPrescriberId"]);//Commented by Pradeep as per task#3155
                        #region--Code Added By Pradeep as per task#3155
                        if (DataSetStaff.Tables[0].Rows[0]["SureScriptsPrescriberId"].ToString() != string.Empty)
                        {
                            if (DataSetStaff.Tables[0].Rows[0]["SureScriptsLocationId"].ToString() != string.Empty)
                            {
                                TextBoxSureScriptsPrescriberId.Text = Convert.ToString(DataSetStaff.Tables[0].Rows[0]["SureScriptsPrescriberId"]) + Convert.ToString(DataSetStaff.Tables[0].Rows[0]["SureScriptsLocationId"]);
                            }
                            else
                            {
                                TextBoxSureScriptsPrescriberId.Text = Convert.ToString(DataSetStaff.Tables[0].Rows[0]["SureScriptsPrescriberId"]);
                            }
                        }

                        #endregion
                        #region--Code Added By Pradeep as per task#3155 on 13 Jan 2011
                        if (((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).Administrator == "Y")
                        {
                            if (DataSetStaff.Tables[0].Rows[0]["SureScriptsPrescriberId"].ToString() != string.Empty)
                            {

                                ButtonRegister.Value = "Update Registration";
                                ButtonRegister.Disabled = false;

                            }
                            else
                            {
                                ButtonRegister.Disabled = true;
                                ButtonRegister.Value = "Register";
                            }
                        }
                        else
                        {
                            ButtonRegister.Disabled = true;
                            ButtonRegister.Value = "Register";
                        }
                        #endregion
                        #region--Code Added by Pradeep as per task#3315
                        if (!string.IsNullOrEmpty(DataSetStaff.Tables[0].Rows[0]["SureScriptsActiveStartTime"].ToString()))
                        {
                            this.TextBoxActiveStartTime.Text = Convert.ToDateTime(DataSetStaff.Tables[0].Rows[0]["SureScriptsActiveStartTime"].ToString()).ToString("MM/dd/yyyy hh:mm tt");
                        }
                        if (!string.IsNullOrEmpty(DataSetStaff.Tables[0].Rows[0]["SureScriptsActiveEndTime"].ToString()))
                        {
                            this.TextBoxActiveEndTime.Text = Convert.ToDateTime(DataSetStaff.Tables[0].Rows[0]["SureScriptsActiveEndTime"].ToString()).ToString("MM/dd/yyyy hh:mm tt");
                        }
                        if (DataSetStaff.Tables[0].Rows[0]["SureScriptsServiceLevel"].ToString() != string.Empty)
                        {
                            if (DropDownListServiceLevel.Items.FindByValue(DataSetStaff.Tables[0].Rows[0]["SureScriptsServiceLevel"].ToString()) != null)
                            {
                                DropDownListServiceLevel.SelectedValue = DataSetStaff.Tables[0].Rows[0]["SureScriptsServiceLevel"].ToString();
                            }
                        }
                        #endregion --Code Added by Pradeep as per task#3315
                        TextBoxMedicationDays.Text = DataSetStaff.Tables[0].Rows[0]["MedicationDaysDefault"].ToString();
                        //---Start Added by Pradeep as per on 25 Nov task#2639
                        this.TextBoxDefaultPrescribingQuantity.Text = DataSetStaff.Tables[0].Rows[0]["DefaultPrescribingQuantity"] == DBNull.Value ? "" : DataSetStaff.Tables[0].Rows[0]["DefaultPrescribingQuantity"].ToString();
                        //---End Added by Pradeep as per task#2639
                        TextBoxDEA.Text = DataSetStaff.Tables[0].Rows[0]["DEANumber"].ToString();

                        if (DataSetStaff.Tables[0].Rows[0]["AuthenticationType"].ToString().Equals("A"))
                        {
                            HiddenAuthenticationType.Value =
                                DataSetStaff.Tables[0].Rows[0]["AuthenticationType"].ToString();
                        }

                        if (!DataSetStaff.Tables[0].Rows[0]["UserPassword"].ToString().IsNullOrWhiteSpace())
                        {
                            TextBoxPassword.Text =
                                ApplicationCommonFunctions.GetDecryptedData(
                                    DataSetStaff.Tables[0].Rows[0]["UserPassword"].ToString(), "Y");
                        }

                        if (TextBoxPassword.Text.Trim().Equals(string.Empty))
                            TextBoxPassword.Text = "**********";
                        HiddenPassword.Value = TextBoxPassword.Text;
                        if (DataSetStaff.Tables[0].Rows[0]["Active"].ToString() == "Y")
                        {
                            CheckBoxListActive.Items[0].Selected = true;
                        }
                        if (DataSetStaff.Tables[0].Rows[0]["Prescriber"].ToString() == "Y")
                        {
                            CheckBoxListActive.Items[1].Selected = true;
                        }


                            if (dsUserPreferences.TwoFactorAuthenticationDeviceRegistrations.Rows.Count > 0)
                            {
                                TextBoxDeviceName.Text = dsUserPreferences.TwoFactorAuthenticationDeviceRegistrations.Rows[0]["DeviceName"].ToString();
                                HiddenDevicePassword.Value = ApplicationCommonFunctions.GetDecryptedData(
                                            dsUserPreferences.TwoFactorAuthenticationDeviceRegistrations.Rows[0]["DevicePassword"].ToString(), "Y"); 

                                if (!dsUserPreferences.TwoFactorAuthenticationDeviceRegistrations.Rows[0]["DeviceSerialNumber"].ToString().IsNullOrWhiteSpace())
                                {
                                    TextBoxDeviceSerialNum.Text = dsUserPreferences.TwoFactorAuthenticationDeviceRegistrations.Rows[0]["DeviceSerialNumber"].ToString();
                                }

                                if (!dsUserPreferences.TwoFactorAuthenticationDeviceRegistrations.Rows[0]["DeviceEmail"].ToString().IsNullOrWhiteSpace())
                                {
                                    TextBoxDeviceUsername.Text = dsUserPreferences.TwoFactorAuthenticationDeviceRegistrations.Rows[0]["DeviceEmail"].ToString();
                                }

                                if (dsUserPreferences.TwoFactorAuthenticationDeviceRegistrations.Rows[0]["Authenticated"].ToString() == "Y")
                                {
                                    LabelAuthenticated.Text = "Yes";
                                    Devicesuccessimage.Visible = true;
                                }
                            }

                            if (dsUserPreferences.Tables["Staff"].Rows[0][0].ToString() != ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId.ToString())
                            {        
                                TextBoxOTP.Enabled = false;                          
                            }


                        //Password Expires :Code added by Loveena in ref to Task#2415 on 4May2009
                        if (DataSetStaff.Tables[0].Rows[0]["PasswordExpiresNextLogin"].ToString() == "Y")
                        {
                            CheckBoxPasswordExpires.Checked = true;
                            DropDownListPasswordExpires.Enabled = false;
                        }
                        else if (DataSetStaff.Tables[0].Rows[0]["PasswordExpiresNextLogin"].ToString() == "N")
                        {
                            CheckBoxPasswordExpires.Checked = false;
                            DropDownListPasswordExpires.Enabled = true;
                        }
                        if (DataSetStaff.Tables[0].Rows[0]["PasswordExpires"].ToString() != "")
                        {
                            DropDownListPasswordExpires.SelectedValue = DataSetStaff.Tables[0].Rows[0]["PasswordExpires"].ToString();
                        }
                        DropDownListDegree.SelectedValue = DataSetStaff.Tables[0].Rows[0]["Degree"].ToString();

                        //Start Code Comented By Pradeep as per task#23
                        //DropDownListDefaultLocation.SelectedValue = DataSetStaff.Tables[0].Rows[0]["DefaultPrescribingLocation"].ToString();
                        //End Code Comented By Pradeep as per task#23
                        if (DataSetStaff.Tables[0].Rows[0]["CreatedDate"] != System.DBNull.Value)
                            LabelDate.Text = Convert.ToDateTime(DataSetStaff.Tables[0].Rows[0]["CreatedDate"]).ToString("MM/dd/yyyy");
                        if (DataSetStaff.Tables[0].Rows[0]["LastVisit"] != System.DBNull.Value)
                            LabelVisit.Text = Convert.ToDateTime(DataSetStaff.Tables[0].Rows[0]["LastVisit"]).ToString("MM/dd/yyyy hh:mm tt");
                        //Commented in ref to Task#3073
                        //else
                        //    LabelVisit.Text = DateTime.Now.ToString("MM/dd/yyyy hh:mm tt");
                        //changes to merge.
                        //Check if Login User is Administrator or not.
                        //if Administartor is 'Y' then can provide permissions else not.
                        if (((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).Administrator == "Y")
                        {
                            TablePermissions.Visible = true;
                            trDropDownPasswordExpires.Visible = true;
                            trPasswordExpires.Visible = true;
                            GenerateRows();
                            //Add by mohit for task #2632 Nov-18-2009
                            CheckBoxListActive.Enabled = true;
                            //Code ends over here.

                            ////Code added by Loveena in ref to Task#2595
                            //TrSecurity.Visible = false;
                            //if (Convert.ToInt32(Session["StaffIdForPreferences"]) != ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId)
                            //{
                            if (((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).EnablePrecriberSecurityQuestion == "Y")
                            {
                                TrSecurity.Visible = false;
                                PanelSecurityQuestions.Visible = true;
                                TrPrescriberSecurityQuestions.Style.Add("display", "block");
                                TrSecurityQuestionsAnswered.Style.Add("display", "block");
                                LabelNumberofPrescrioberSecurityQuestions.Text = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).NumberOfPrescriberSecurityQuestions.ToString();
                                LabelNumberofSecurityQuestionsAnswered.Text = numberOfSecurityQuestionsAnswered.ToString();
                            }
                            else
                            {
                                PanelSecurityQuestions.Visible = true;
                                TrPrescriberSecurityQuestions.Style.Add("display", "none");
                                TrSecurityQuestionsAnswered.Style.Add("display", "none");
                                TrSecurity.Visible = false;
                                tdSecurityQuestions.Style.Add("display", "none");
                                //tdSpace.Style.Add("display", "none");
                                //Permissions.Style.Add("width", "50%");
                                //TablePermissions.Visible = true;
                            }
                            //}
                            //else
                            //{
                            //    //Code added by Loveena in ref to Task#2595
                            //    PanelSecurityQuestions.Visible = true;
                            //    TrPrescriberSecurityQuestions.Style.Add("display", "none");
                            //    TrSecurityQuestionsAnswered.Style.Add("display", "none");
                            //    TrSecurity.Visible = true;
                            //    createSecurityControls();
                            //    TablePermissions.Visible = false;
                            //    trDropDownPasswordExpires.Visible = false;
                            //    trPasswordExpires.Visible = false;

                            //}
                        }
                        else
                        {
                            //Code added by Loveena in ref to Task#2595
                            PanelSecurityQuestions.Visible = true;
                            TrPrescriberSecurityQuestions.Style.Add("display", "none");
                            TrSecurityQuestionsAnswered.Style.Add("display", "none");
                            TrSecurity.Visible = true;
                            createSecurityControls();
                            TablePermissions.Visible = false;
                            trDropDownPasswordExpires.Visible = false;
                            trPasswordExpires.Visible = false;
                            //Add by mohit for task #2632 Nov-18-2009
                            CheckBoxListActive.Enabled = false;
                            //Code ends over here.
                        }

                        //Code is added by Loveena in ref to Task#3155 to check the condition to Enable
                        //Register Button
                        string unFormatedPhoneNumber = string.Empty;
                        #region--Code Added by Pradeep as per task#3155
                        if (DataSetStaff.Tables[0].Rows[0]["PhoneNumber"].ToString() != string.Empty)
                        {
                            unFormatedPhoneNumber = getUnformatedPhoneNumber(dsUserPreferences.Tables[0].Rows[0]["PhoneNumber"].ToString().Trim());
                        }
                        string unFormatedFaxNumber = string.Empty;
                        if (DataSetStaff.Tables[0].Rows[0]["FaxNumber"].ToString() != string.Empty)
                        {
                            unFormatedFaxNumber = getUnformatedPhoneNumber(dsUserPreferences.Tables[0].Rows[0]["FaxNumber"].ToString().Trim());
                        }
                        #endregion
                        //Made changes as per task#3155 for FaxNumber and Phone Number
                        if (DataSetStaff.Tables[0].Rows[0]["FirstName"].ToString() != string.Empty && DataSetStaff.Tables[0].Rows[0]["LastName"].ToString() != string.Empty && DataSetStaff.Tables[0].Rows[0]["SigningSuffix"].ToString() != string.Empty && DataSetStaff.Tables[0].Rows[0]["Degree"].ToString() != string.Empty && dsUserPreferences.Tables[0].Rows[0]["Degree"].ToString() != "0" && DataSetStaff.Tables[0].Rows[0]["NationalProviderId"].ToString() != string.Empty && unFormatedPhoneNumber.Length >= 7 && unFormatedFaxNumber.Length >= 7 && DataSetStaff.Tables[0].Rows[0]["SureScriptsActiveStartTime"].ToString() != string.Empty && DataSetStaff.Tables[0].Rows[0]["SureScriptsActiveEndTime"].ToString() != string.Empty && DataSetStaff.Tables[0].Rows[0]["SureScriptsServiceLevel"].ToString() != string.Empty)
                        {

                            if (ButtonRegister.Value == "Update Registration")
                            {
                                ButtonRegister.Disabled = false;
                                ButtonRegister.Visible = false;
                                LabelRegister.Visible = true;
                            }
                            else if (TextBoxSureScriptsPrescriberId.Text == string.Empty && ButtonRegister.Value == "Register")
                            {
                                ButtonRegister.Disabled = false;
                                ButtonRegister.Visible = true;
                                LabelRegister.Visible = false;
                            }


                            if (ButtonRegister.Disabled == false)
                                ButtonRegister.Attributes.Add("onclick", "GetSureScriptsPrescriberId(" + Convert.ToInt32(Session["StaffIdForPreferences"]) + ");");
                        }
                        else
                        {
                            ButtonRegister.Disabled = true;
                        }

                    }
                    else
                    {
                        TextBoxPassword.Text = "**********";
                        HiddenPassword.Value = "**********";
                    }
                }
                else if (Session["StaffIdForPreferences"] == null)
                {

                    TextBoxPassword.Text = "**********";
                    HiddenPassword.Value = "**********";

                    //Code added in ref to Task#2595
                    if (((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).Administrator == "Y")
                    {
                        ////Code added by Loveena in ref to Task#2595
                        //PanelSecurityQuestions.Style.Add("display", "none");                                         
                        //TrSecurity.Visible = false;

                        //Code added by Loveena in ref to Task#2595
                        TrSecurity.Visible = false;
                        if (((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).EnablePrecriberSecurityQuestion == "Y")
                        {
                            PanelSecurityQuestions.Visible = true;
                            TrPrescriberSecurityQuestions.Style.Add("display", "block");
                            TrSecurityQuestionsAnswered.Style.Add("display", "block");
                            LabelNumberofPrescrioberSecurityQuestions.Text = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).NumberOfPrescriberSecurityQuestions.ToString();
                            LabelNumberofSecurityQuestionsAnswered.Text = numberOfSecurityQuestionsAnswered.ToString();
                        }
                        else
                        {
                            PanelSecurityQuestions.Visible = true;
                            TrPrescriberSecurityQuestions.Style.Add("display", "none");
                            TrSecurityQuestionsAnswered.Style.Add("display", "none");
                            TrSecurity.Visible = false;
                            //tdSpace.Style.Add("display", "none");
                            //Permissions.Style.Add("width", "50%");
                            tdSecurityQuestions.Style.Add("display", "none");
                            TablePermissions.Visible = true;
                        }
                    }
                    dsUserPreferences = new Streamline.UserBusinessServices.DataSets.DataSetUserPrefrences();
                    Streamline.UserBusinessServices.DataSets.DataSetUserPrefrences.StaffRow _dataRowUserPrefernces = null;
                    _dataRowUserPrefernces = (Streamline.UserBusinessServices.DataSets.DataSetUserPrefrences.StaffRow)dsUserPreferences.Tables[0].NewRow();
                    _dataRowUserPrefernces.CreatedBy = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                    _dataRowUserPrefernces.CreatedDate = DateTime.Now;
                    _dataRowUserPrefernces.ModifiedBy = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                    _dataRowUserPrefernces.ModifiedDate = DateTime.Now;
                    _dataRowUserPrefernces.CoSigner = "N";
                    _dataRowUserPrefernces.Clinician = "N";
                    _dataRowUserPrefernces.CosignRequired = "N";
                    _dataRowUserPrefernces.Attending = "N";
                    _dataRowUserPrefernces.ProgramManager = "N";
                    _dataRowUserPrefernces.IntakeStaff = "N";
                    _dataRowUserPrefernces.AppointmentSearch = "Y";
                    _dataRowUserPrefernces.AdminStaff = "N";
                    _dataRowUserPrefernces.AllowedPrinting = "Y";
                    _dataRowUserPrefernces.InLineSpellCheck = "N";
                    _dataRowUserPrefernces.DisplayPrimaryClients = "Y";
                    _dataRowUserPrefernces.EncryptionSwitch = "N";
                    _dataRowUserPrefernces.Administrator = "N";
                    _dataRowUserPrefernces.CanViewStaffProductivity = "N";
                    _dataRowUserPrefernces.CanCreateManageStaff = "N";
                    _dataRowUserPrefernces.RowIdentifier = System.Guid.NewGuid();
                    if (CheckBoxListActive.Items[0].Selected == true)
                    {
                        _dataRowUserPrefernces.Active = "Y";
                    }
                    else
                    {
                        _dataRowUserPrefernces.Active = "N";
                    }
                    if (CheckBoxListActive.Items[1].Selected == true)
                    {
                        _dataRowUserPrefernces.Prescriber = "Y";
                    }
                    else
                    {
                        _dataRowUserPrefernces.Prescriber = "N";
                    }
                    dsUserPreferences.Staff.Rows.Add(_dataRowUserPrefernces);
                    DataSetLocationList = objUserPreferences.GetUserPreferancesLocationList(0);
                    dsUserPreferences.Locations.Merge(DataSetLocationList.Tables["Locations"]);
                    dsUserPreferences.StaffLocations.Merge(DataSetLocationList.Tables["StaffLocations"]);
                    dsUserPreferences.PrinterDeviceLocations.Merge(DataSetLocationList.Tables["PrinterDeviceLocations"]);
                    dsUserPreferences.TwoFactorAuthenticationDeviceRegistrations.Merge(dsTemp.Tables[3]);
                }
                Session["DataSetPermissionsList"] = dsUserPreferences;
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
                dsUserPreferences = null;
                DataSetStaff = null;
                _dataRowView = null;
                dsTemp = null;
            }
        }
        protected void ButtonUpdate_Click(object sender, EventArgs e)
        {
            DataSet DataSetStaff = new DataSet();
            DataSet dsTemp = new DataSet();
            DataSet dsTempTwoFactor = new DataSet();            

            try
            {
                CommonFunctions.Event_Trap(this);
                objUserPreferences = new UserPrefernces();
                objectClientMedications = new ClientMedication();
                Streamline.UserBusinessServices.DataSets.DataSetUserPrefrences.StaffRow _dataRowUserPrefernces = null;

                if (Session["DataSetPermissionsList"] != null)
                {
                    dsUserPreferences = (Streamline.UserBusinessServices.DataSets.DataSetUserPrefrences)(Session["DataSetPermissionsList"]);
                    #region "Update Staff"
                    //Streamline.UserBusinessServices.DataSets.DataSetUserPrefrences.StaffRow _dataRowUserPrefernces = null;
                    _dataRowUserPrefernces = (Streamline.UserBusinessServices.DataSets.DataSetUserPrefrences.StaffRow)dsUserPreferences.Tables[0].Rows[0];


                    Streamline.UserBusinessServices.DataSets.DataSetUserPrefrences.TwoFactorAuthenticationDeviceRegistrationsRow _dataRowTwoFactorAuthenticationDeviceRegistrations = null;
                    TwoFactorAuthenticationResponse TwoFactorAuthenticationResponseObject = new TwoFactorAuthenticationResponse();

                    Streamline.UserBusinessServices.DataSets.DataSetUserPrefrences.TwoFactorAuthenticationDeviceRegistrationHistoryRow _dataRowTwoFactorAuthenticationDeviceRegistrationHistory = null;

                        if (TextBoxDEA.Text == ""  )
                        {
                            if (isEPCSPermissionSet == 'Y') // Added by Pranay w.r.t Renaissance - Environment Issues Tracking Task# 83
                            {
                                string strErrorMessage = "DEA";
                                ScriptManager.RegisterStartupScript(Page, Page.GetType(), UniqueID, "javascript:Updatemessagestatus('" + strErrorMessage + "');", true);
                                goto Proceed;
                            }
                        }
                        TwoFactorAuthenticationRequest objTwoFactorAuthenticationRequest = new TwoFactorAuthenticationRequest();
                        TwoFactorAuthentication objTwoFactorAuthentication = new TwoFactorAuthentication();

                        if (TextBoxOTP.Text != string.Empty)
                        {
                            objTwoFactorAuthenticationRequest.UserID = TextBoxDeviceUsername.Text;
                            objTwoFactorAuthenticationRequest.Password = TextBoxDevicePassword.Text;
                            objTwoFactorAuthenticationRequest.OTP = TextBoxOTP.Text;
                            TwoFactorAuthenticationResponseObject = objTwoFactorAuthentication.Authenticate(objTwoFactorAuthenticationRequest, "Device Registration");

                            HiddenDevicePassword.Value = TextBoxPassword.Text;
                            if (TwoFactorAuthenticationResponseObject.Passed != true)
                            {
                                string strErrorMessage = "OTP";
                                ScriptManager.RegisterStartupScript(Page, Page.GetType(), UniqueID, "javascript:Updatemessagestatus('" + strErrorMessage + "');", true);
                                goto Proceed;
                            }
                            else
                            {
                                string strErrorMessage = "Success";
                                ScriptManager.RegisterStartupScript(Page, Page.GetType(), UniqueID, "javascript:Updatemessagestatus('" + strErrorMessage + "');", true);
                            }
                        }
                        

                        if (isEPCSPermissionSet == 'Y')
                        {
                            _dataRowUserPrefernces.IsEPCSEnabled = "Y";
                        }
                        else
                        {
                            _dataRowUserPrefernces.IsEPCSEnabled = "N";
                        }

                    _dataRowUserPrefernces.FirstName = (TextBoxFirstName.Text == string.Empty ? System.DBNull.Value.ToString() : TextBoxFirstName.Text);
                    _dataRowUserPrefernces.LastName = (TextBoxLastName.Text == string.Empty ? System.DBNull.Value.ToString() : TextBoxLastName.Text);
                    if (TextBoxPhone.Text != string.Empty)
                        _dataRowUserPrefernces.PhoneNumber = TextBoxPhone.Text;
                    else
                        _dataRowUserPrefernces.PhoneNumber = null;
                    if (TextBoxFaxNumber.Text != string.Empty)
                        _dataRowUserPrefernces.FaxNumber = TextBoxFaxNumber.Text;
                    else
                        _dataRowUserPrefernces.FaxNumber = null;
                    if (TextBoxEmail.Text != string.Empty)
                        _dataRowUserPrefernces.Email = TextBoxEmail.Text;
                    else
                        _dataRowUserPrefernces.Email = null;
                    if (TextBoxAddress.Text != string.Empty)
                        _dataRowUserPrefernces.Address = TextBoxAddress.Text;
                    else
                        _dataRowUserPrefernces.Address = null;
                    _dataRowUserPrefernces.UserCode = TextBoxUserName.Text;
                    if (HiddenPassword.Value != "**********")
                        _dataRowUserPrefernces.UserPassword = ApplicationCommonFunctions.GetEncryptedData(HiddenPassword.Value, "Y");
                    if (TextBoxSigning.Text != string.Empty)
                        _dataRowUserPrefernces.SigningSuffix = TextBoxSigning.Text;
                    else
                        _dataRowUserPrefernces.SigningSuffix = null;

                    //if (TextBoxLicense.Text != string.Empty)
                    //    _dataRowUserPrefernces.LicenseNumber = TextBoxLicense.Text;
                    //else
                    //    _dataRowUserPrefernces.LicenseNumber = null;
                    //if (TextBoxNPI.Text != string.Empty)
                    //    _dataRowUserPrefernces.NationalProviderId = TextBoxNPI.Text;
                    //else
                    //    _dataRowUserPrefernces.NationalProviderId = null;
                    //Added by Loveena in ref to Task#85
                    #region--Code Commented by Pradeep as per task#3155
                    //if (TextBoxSureScriptsPrescriberId.Text != string.Empty)
                    //{
                    //    _dataRowUserPrefernces.SureScriptsPrescriberId = TextBoxSureScriptsPrescriberId.Text;
                    //}
                    //else
                    //{
                    //    _dataRowUserPrefernces.SetSureScriptsPrescriberIdNull();
                    //}
                    #endregion
                    #region--Code Added By Pradeep as per task#3155
                    if (TextBoxSureScriptsPrescriberId.Text != string.Empty)
                    {
                        if (TextBoxSureScriptsPrescriberId.Text.ToString().Trim().Length >= 10)
                        {
                            _dataRowUserPrefernces.SureScriptsPrescriberId = TextBoxSureScriptsPrescriberId.Text.ToString().Trim().Substring(0, 10);
                            _dataRowUserPrefernces.SureScriptsLocationId = TextBoxSureScriptsPrescriberId.Text.ToString().Trim().Substring(10, TextBoxSureScriptsPrescriberId.Text.Trim().Length - 10);
                        }
                        else
                        {
                            _dataRowUserPrefernces.SureScriptsPrescriberId = TextBoxSureScriptsPrescriberId.Text;

                        }

                    }
                    else
                    {
                        _dataRowUserPrefernces.SetSureScriptsPrescriberIdNull();
                    }

                    #endregion
                    #region--Code Added by Pradeep as per task#3315
                    if (!string.IsNullOrEmpty(TextBoxActiveStartTime.Text.ToString()))
                    {
                        _dataRowUserPrefernces.SureScriptsActiveStartTime = Convert.ToDateTime(TextBoxActiveStartTime.Text.ToString());
                    }
                    else
                    {
                        _dataRowUserPrefernces.SetSureScriptsActiveStartTimeNull();
                    }
                    if (!string.IsNullOrEmpty(TextBoxActiveEndTime.Text.ToString()))
                    {
                        _dataRowUserPrefernces.SureScriptsActiveEndTime = Convert.ToDateTime(TextBoxActiveEndTime.Text.ToString());
                    }
                    else
                    {
                        _dataRowUserPrefernces.SetSureScriptsActiveEndTimeNull();
                    }
                    if (DropDownListServiceLevel.SelectedValue != "0")
                    {
                        _dataRowUserPrefernces.SureScriptsServiceLevel = Convert.ToInt32(DropDownListServiceLevel.SelectedValue);
                    }
                    else
                    {
                        _dataRowUserPrefernces.SetSureScriptsServiceLevelNull();
                    }

                    #endregion
                    //#region--Code Added by Pradeep as per task#3155 on 2 Feb 2011
                    //_dataRowUserPrefernces.StaffName = this.TextBoxLastName.Text.Trim() + ", " + this.TextBoxFirstName.Text.Trim();
                    //#endregion
                    if (TextBoxDEA.Text != string.Empty)
                        _dataRowUserPrefernces.DEANumber = TextBoxDEA.Text;
                    else
                        _dataRowUserPrefernces.DEANumber = null;
                    if (TextBoxMedicationDays.Text != string.Empty)
                        _dataRowUserPrefernces.MedicationDaysDefault = Convert.ToInt32(TextBoxMedicationDays.Text);
                    else
                        _dataRowUserPrefernces.MedicationDaysDefault = 0;
                    //Start Code Added by Pradeep as per task#2639 on Nov 25,2009
                    if (this.TextBoxDefaultPrescribingQuantity.Text.Trim() != string.Empty)
                    {
                        _dataRowUserPrefernces.DefaultPrescribingQuantity = Convert.ToInt32(TextBoxDefaultPrescribingQuantity.Text.Trim());
                    }
                    else
                    {
                        _dataRowUserPrefernces.SetDefaultPrescribingQuantityNull();
                    }
                    //End Code Added by Pradeep as per task#2639 on Nov 25,2009
                    //Commented by Loveena in ref to Task#3073 to update Last Visit on click of Login Button from Login Screen
                    //_dataRowUserPrefernces.LastVisit = DateTime.Now;
                    if (Session["StaffIdForPreferences"] == null)
                        _dataRowUserPrefernces.CreatedDate = DateTime.Now;

                    if (DropDownListDegree.SelectedValue != "0")
                        _dataRowUserPrefernces.Degree = Convert.ToInt32(DropDownListDegree.SelectedValue);
                    else
                        _dataRowUserPrefernces.Degree = 0;

                    //--Start Code Comented By Pradeep as per task#23
                    //if (DropDownListDefaultLocation.SelectedValue != "0")
                    //    _dataRowUserPrefernces.DefaultPrescribingLocation = Convert.ToInt32(DropDownListDefaultLocation.SelectedValue);
                    //--End Code Comented By Pradeep as per task#23
                    if (Session["StaffIdForPreferences"] == null)
                        _dataRowUserPrefernces.CreatedBy = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                    _dataRowUserPrefernces.ModifiedBy = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                    _dataRowUserPrefernces.ModifiedDate = DateTime.Now;
                    //_dataRowUserPrefernces.CoSigner = "N";
                    //_dataRowUserPrefernces.Clinician = "N";
                    //_dataRowUserPrefernces.CosignRequired = "N";
                    //_dataRowUserPrefernces.Attending = "N";
                    //_dataRowUserPrefernces.ProgramManager = "N";
                    //_dataRowUserPrefernces.IntakeStaff = "N";
                    //_dataRowUserPrefernces.AppointmentSearch = "Y";
                    //_dataRowUserPrefernces.AdminStaff = "N";
                    //_dataRowUserPrefernces.AllowedPrinting = "Y";
                    //_dataRowUserPrefernces.InLineSpellCheck = "N";
                    //_dataRowUserPrefernces.DisplayPrimaryClients = "Y";
                    //_dataRowUserPrefernces.EncryptionSwitch = "N";
                    //_dataRowUserPrefernces.Administrator = "N";
                    //_dataRowUserPrefernces.CanViewStaffProductivity = "N";
                    //_dataRowUserPrefernces.CanCreateManageStaff = "N";
                    //_dataRowUserPrefernces.RowIdentifier = System.Guid.NewGuid();
                    if (CheckBoxListActive.Items[0].Selected == true)
                    {
                        _dataRowUserPrefernces.Active = "Y";
                        //Added by Loveena in ref to Task#3269-2.6 User Management: When Staff Created or Updated Set AccessSmartCare flag
                        _dataRowUserPrefernces.AccessSmartCare = "Y";
                    }
                    else
                    {
                        _dataRowUserPrefernces.Active = "N";
                        //Added by Loveena in ref to Task#3269-2.6 User Management: When Staff Created or Updated Set AccessSmartCare flag
                        _dataRowUserPrefernces.AccessSmartCare = "N";
                    }
                    if (CheckBoxListActive.Items[1].Selected == true)
                    {
                        _dataRowUserPrefernces.Prescriber = "Y";
                    }
                    else
                    {
                        _dataRowUserPrefernces.Prescriber = "N";
                    }
                    //Password Expires.
                    if (CheckBoxPasswordExpires.Checked == true)
                        _dataRowUserPrefernces.PasswordExpiresNextLogin = "Y";
                    else if (CheckBoxPasswordExpires.Checked == false)
                        _dataRowUserPrefernces.PasswordExpiresNextLogin = "N";
                    if (CheckBoxPasswordExpires.Checked == true)
                    {
                        if (DropDownListPasswordExpires.SelectedIndex > 0)
                        {


                            if (Convert.ToInt32(DropDownListPasswordExpires.SelectedValue) > 0)
                                _dataRowUserPrefernces.PasswordExpires = Convert.ToInt32(DropDownListPasswordExpires.SelectedValue);
                            if (Convert.ToInt32(DropDownListPasswordExpires.SelectedIndex) > 1)
                            {
                                switch (Convert.ToInt32(DropDownListPasswordExpires.SelectedIndex))
                                {
                                    case 2://1 Month
                                        _dataRowUserPrefernces.PasswordExpirationDate = DateTime.Today.AddMonths(1);
                                        break;

                                    case 3://3 Months
                                        _dataRowUserPrefernces.PasswordExpirationDate = DateTime.Today.AddMonths(3);
                                        break;

                                    case 4://6 Months
                                        _dataRowUserPrefernces.PasswordExpirationDate = DateTime.Today.AddMonths(6);
                                        break;

                                    case 5://Every Year
                                        _dataRowUserPrefernces.PasswordExpirationDate = DateTime.Today.AddYears(1);
                                        break;
                                }
                            }
                        }
                    }
                    else if (CheckBoxPasswordExpires.Checked == false)
                    {
                        if (Convert.ToInt32(DropDownListPasswordExpires.SelectedValue) > 0)
                            _dataRowUserPrefernces.PasswordExpires = Convert.ToInt32(DropDownListPasswordExpires.SelectedValue);
                        //else
                        //    _dataRowUserPrefernces.PasswordExpires = Convert.ToInt32(DBNull.Value);

                        if (Convert.ToInt32(DropDownListPasswordExpires.SelectedIndex) > 1)
                        {
                            switch (Convert.ToInt32(DropDownListPasswordExpires.SelectedIndex))
                            {
                                case 2://1 Month
                                    _dataRowUserPrefernces.PasswordExpirationDate = DateTime.Today.AddMonths(1);
                                    break;

                                case 3://3 Months
                                    _dataRowUserPrefernces.PasswordExpirationDate = DateTime.Today.AddMonths(3);
                                    break;

                                case 4://6 Months
                                    _dataRowUserPrefernces.PasswordExpirationDate = DateTime.Today.AddMonths(6);
                                    break;

                                case 5://Every Year
                                    _dataRowUserPrefernces.PasswordExpirationDate = DateTime.Today.AddYears(1);
                                    break;
                            }
                        }
                        //Added by Loveena in ref to Task#2595 
                        //if (DropDownListSecurityQuestion1.SelectedIndex > 0)
                        //    _dataRowUserPrefernces.SecurityQuestion1 = Convert.ToInt32(DropDownListSecurityQuestion1.SelectedValue);
                        //if (TextBoxSecurityAnswer1.Text != string.Empty)
                        //    _dataRowUserPrefernces.SecurityAnswer1 = TextBoxSecurityAnswer1.Text;
                        ////SecurityQuestion2
                        //if (DropDownListSecurityQuestion2.SelectedIndex > 0)
                        //    _dataRowUserPrefernces.SecurityQuestion2 = Convert.ToInt32(DropDownListSecurityQuestion2.SelectedValue);
                        //if (TextBoxSecurityAnswer2.Text != string.Empty)
                        //    _dataRowUserPrefernces.SecurityAnswer2 = TextBoxSecurityAnswer2.Text;
                        //if (DropDownListSecurityQuestion3.SelectedIndex > 0)
                        //    _dataRowUserPrefernces.SecurityQuestion3 = Convert.ToInt32(DropDownListSecurityQuestion3.SelectedValue);
                        //if (TextBoxSecurityAnswer3.Text != string.Empty)
                        //    _dataRowUserPrefernces.SecurityAnswer3 = TextBoxSecurityAnswer3.Text;
                        //Code ends over here.
                        //else
                        //    {
                        //    DateTime? dt;
                        //    dt.Value=null;
                        //    _dataRowUserPrefernces.PasswordExpirationDate = dt;
                        //    }
                    }
 					_dataRowUserPrefernces.DisplayAs = _dataRowUserPrefernces.LastName + ", " + _dataRowUserPrefernces.FirstName;

                  
                    dsTempTwoFactor = objUserPreferences.CheckStaffPermissions(Convert.ToInt32(Session["StaffIdForPreferences"]));
                    dsUserPreferences.TwoFactorAuthenticationDeviceRegistrations.Merge(dsTempTwoFactor.Tables[3]);



                    //DataRow[] drEPCS = dsUserPreferences.Tables["StaffPermissions"].Select("ActionId=10074 AND ISNULL(NewlyAddedColumn,'N')='N' AND ISNULL(RecordDeleted,'N')='N'");
                    //if (drEPCS.Length > 0)
                    //{
                    if (dsUserPreferences.Tables["TwoFactorAuthenticationDeviceRegistrations"].Rows.Count > 0)
                    {
                        _dataRowTwoFactorAuthenticationDeviceRegistrations =
                            (
                                Streamline.UserBusinessServices.DataSets.DataSetUserPrefrences.
                                    TwoFactorAuthenticationDeviceRegistrationsRow)
                                dsUserPreferences.Tables["TwoFactorAuthenticationDeviceRegistrations"].Rows[0];

                        if (!string.IsNullOrEmpty(TextBoxPassword.Text))
                        {
                            _dataRowTwoFactorAuthenticationDeviceRegistrations["ModifiedBy"] =
                                Context.User.Identity.Name;
                            _dataRowTwoFactorAuthenticationDeviceRegistrations["ModifiedDate"] = DateTime.Now;
                            if (TextBoxDeviceName.Text != string.Empty)
                                _dataRowTwoFactorAuthenticationDeviceRegistrations["DeviceName"] =
                                    TextBoxDeviceName.Text;
                            else
                                _dataRowTwoFactorAuthenticationDeviceRegistrations["DeviceName"] = null;

                            if (TextBoxDevicePassword.Text != "**********" || TextBoxDevicePassword.Text != string.Empty)
                            {
                                _dataRowTwoFactorAuthenticationDeviceRegistrations["DevicePassword"] =
                                    ApplicationCommonFunctions.GetEncryptedData(TextBoxDevicePassword.Text, "Y");
                            }

                            if (TextBoxDeviceSerialNum.Text != string.Empty)
                                _dataRowTwoFactorAuthenticationDeviceRegistrations["DeviceSerialNumber"] =
                                    TextBoxDeviceSerialNum.Text;
                            else
                                _dataRowTwoFactorAuthenticationDeviceRegistrations["DeviceSerialNumber"] = null;

                            if (TextBoxDeviceUsername.Text != string.Empty)
                                _dataRowTwoFactorAuthenticationDeviceRegistrations["DeviceEmail"] =
                                    TextBoxDeviceUsername.Text;
                            else
                                _dataRowTwoFactorAuthenticationDeviceRegistrations["DeviceEmail"] = null;

                            if (TwoFactorAuthenticationResponseObject.Passed == true)
                            {
                                _dataRowTwoFactorAuthenticationDeviceRegistrations["Authenticated"] = "Y";
                                LabelAuthenticated.Text = "Yes";
                                Devicesuccessimage.Visible = true;
                            }

                            if (TextBoxDeviceUsername.Text == "" && TextBoxDevicePassword.Text == "" && TextBoxOTP.Text == "" && TextBoxDeviceName.Text == "" && TextBoxDeviceSerialNum.Text == "")
                            {
                                _dataRowTwoFactorAuthenticationDeviceRegistrations["Authenticated"] = "N";
                                LabelAuthenticated.Text = "No";
                                Devicesuccessimage.Visible = false;
                                TextBoxDevicePassword.Attributes["value"] = "";

                                dsUserPreferences = (Streamline.UserBusinessServices.DataSets.DataSetUserPrefrences)(Session["DataSetPermissionsList"]);
                                DataRow[] drEPCS = ((DataSet)(Session["DataSetPermissionsList"])).Tables["StaffPermissions"].Select("ActionId=10074 AND ISNULL(RecordDeleted,'N')='N'");
                                if (drEPCS.Length > 0)
                                    dsUserPreferences.Tables["StaffPermissions"].Rows.Remove(drEPCS[0]);
                                _dataRowUserPrefernces.IsEPCSEnabled = "N";
                                DisableEPCS();
                            }


                            _dataRowTwoFactorAuthenticationDeviceRegistrationHistory =
                                (
                                    Streamline.UserBusinessServices.DataSets.DataSetUserPrefrences.
                                        TwoFactorAuthenticationDeviceRegistrationHistoryRow)
                                    dsUserPreferences.Tables["TwoFactorAuthenticationDeviceRegistrationHistory"].NewRow();
                            //_dataRowTwoFactorAuthenticationDeviceRegistrations["TwoFactorAuthenticationDeviceRegistrationId"] = TwoFactorAuthenticationDeviceRegistrationId;
                            _dataRowTwoFactorAuthenticationDeviceRegistrationHistory["StaffId"] =
                                Convert.ToInt32(dsUserPreferences.Staff.Rows[0]["StaffId"]);
                            _dataRowTwoFactorAuthenticationDeviceRegistrationHistory["CreatedBy"] =
                                Context.User.Identity.Name;
                            // ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                            _dataRowTwoFactorAuthenticationDeviceRegistrationHistory["CreatedDate"] = DateTime.Now;
                            _dataRowTwoFactorAuthenticationDeviceRegistrationHistory["ModifiedBy"] =
                                Context.User.Identity.Name;
                            //((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                            _dataRowTwoFactorAuthenticationDeviceRegistrationHistory["ModifiedDate"] = DateTime.Now;
                            if (TextBoxDeviceName.Text != string.Empty)
                                _dataRowTwoFactorAuthenticationDeviceRegistrationHistory["DeviceName"] =
                                    TextBoxDeviceName.Text;
                            if (TextBoxDeviceSerialNum.Text != string.Empty)
                                _dataRowTwoFactorAuthenticationDeviceRegistrationHistory["DeviceSerialNumber"] =
                                    TextBoxDeviceSerialNum.Text;
                            if (TextBoxDeviceUsername.Text != string.Empty)
                                _dataRowTwoFactorAuthenticationDeviceRegistrationHistory["DeviceEmail"] =
                                    TextBoxDeviceUsername.Text;
                            if (TextBoxDevicePassword.Text != "**********" || TextBoxDevicePassword.Text != string.Empty)
                            {
                                _dataRowTwoFactorAuthenticationDeviceRegistrationHistory["DevicePassword"] =
                                    ApplicationCommonFunctions.GetEncryptedData(TextBoxDevicePassword.Text, "Y");

                            }

                            _dataRowTwoFactorAuthenticationDeviceRegistrationHistory[
                                "TwoFactorAuthenticationDeviceRegistrationId"] =
                                _dataRowTwoFactorAuthenticationDeviceRegistrations[
                                    "TwoFactorAuthenticationDeviceRegistrationId"];

                            if (TwoFactorAuthenticationResponseObject.Passed == true)
                            {
                                _dataRowTwoFactorAuthenticationDeviceRegistrationHistory["Authenticated"] = "Y";
                            }
                            dsUserPreferences.TwoFactorAuthenticationDeviceRegistrationHistory.Rows.Add(
                                _dataRowTwoFactorAuthenticationDeviceRegistrationHistory);
                        }
                    }
                    else
                    {
                        _dataRowTwoFactorAuthenticationDeviceRegistrations =
                            (
                                Streamline.UserBusinessServices.DataSets.DataSetUserPrefrences.
                                    TwoFactorAuthenticationDeviceRegistrationsRow)
                                dsUserPreferences.Tables["TwoFactorAuthenticationDeviceRegistrations"].NewRow();
                        //_dataRowTwoFactorAuthenticationDeviceRegistrations["TwoFactorAuthenticationDeviceRegistrationId"] = TwoFactorAuthenticationDeviceRegistrationId;
                        _dataRowTwoFactorAuthenticationDeviceRegistrations["StaffId"] =
                            Convert.ToInt32(dsUserPreferences.Staff.Rows[0]["StaffId"]);
                        _dataRowTwoFactorAuthenticationDeviceRegistrations["CreatedBy"] = Context.User.Identity.Name;
                            // ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                        _dataRowTwoFactorAuthenticationDeviceRegistrations["CreatedDate"] = DateTime.Now;
                        _dataRowTwoFactorAuthenticationDeviceRegistrations["ModifiedBy"] = Context.User.Identity.Name;
                            //((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                        _dataRowTwoFactorAuthenticationDeviceRegistrations["ModifiedDate"] = DateTime.Now;
                        if (TextBoxDeviceName.Text != string.Empty)
                            _dataRowTwoFactorAuthenticationDeviceRegistrations["DeviceName"] = TextBoxDeviceName.Text;
                        if (TextBoxDeviceSerialNum.Text != string.Empty)
                            _dataRowTwoFactorAuthenticationDeviceRegistrations["DeviceSerialNumber"] =
                                TextBoxDeviceSerialNum.Text;
                        if (TextBoxDeviceUsername.Text != string.Empty)
                            _dataRowTwoFactorAuthenticationDeviceRegistrations["DeviceEmail"] = TextBoxDeviceUsername.Text;
                        if (TextBoxDevicePassword.Text != "**********" || TextBoxDevicePassword.Text != string.Empty)
                        {
                            _dataRowTwoFactorAuthenticationDeviceRegistrations["DevicePassword"] =
                                ApplicationCommonFunctions.GetEncryptedData(TextBoxDevicePassword.Text, "Y");

                        }

                        if (TwoFactorAuthenticationResponseObject.Passed == true)
                        {
                            _dataRowTwoFactorAuthenticationDeviceRegistrations["Authenticated"] = "Y";
                            TextBoxOTP.Enabled = false;
                        }

                        if (TextBoxDeviceUsername.Text == "" && TextBoxDevicePassword.Text == "" && TextBoxOTP.Text == "" && TextBoxDeviceName.Text == "" && TextBoxDeviceSerialNum.Text == "")
                        {
                            _dataRowTwoFactorAuthenticationDeviceRegistrations["Authenticated"] = "N";
                            LabelAuthenticated.Text = "No";
                            Devicesuccessimage.Visible = false;
                            TextBoxDevicePassword.Attributes["value"] = "";
                            dsUserPreferences = (Streamline.UserBusinessServices.DataSets.DataSetUserPrefrences)(Session["DataSetPermissionsList"]);
                            DataRow[] drEPCS = ((DataSet)(Session["DataSetPermissionsList"])).Tables["StaffPermissions"].Select("ActionId=10074 AND ISNULL(RecordDeleted,'N')='N'");
                            if (drEPCS.Length > 0)
                                dsUserPreferences.Tables["StaffPermissions"].Rows.Remove(drEPCS[0]);
                            _dataRowUserPrefernces.IsEPCSEnabled = "N";
                            DisableEPCS();
                        }

                        dsUserPreferences.TwoFactorAuthenticationDeviceRegistrations.Rows.Add(
                            _dataRowTwoFactorAuthenticationDeviceRegistrations);

                        _dataRowTwoFactorAuthenticationDeviceRegistrationHistory = (Streamline.UserBusinessServices.DataSets.DataSetUserPrefrences.TwoFactorAuthenticationDeviceRegistrationHistoryRow)dsUserPreferences.Tables["TwoFactorAuthenticationDeviceRegistrationHistory"].NewRow();
                        //_dataRowTwoFactorAuthenticationDeviceRegistrations["TwoFactorAuthenticationDeviceRegistrationId"] = TwoFactorAuthenticationDeviceRegistrationId;
                        _dataRowTwoFactorAuthenticationDeviceRegistrationHistory["StaffId"] = Convert.ToInt32(dsUserPreferences.Staff.Rows[0]["StaffId"]);
                        _dataRowTwoFactorAuthenticationDeviceRegistrationHistory["CreatedBy"] = Context.User.Identity.Name;// ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                        _dataRowTwoFactorAuthenticationDeviceRegistrationHistory["CreatedDate"] = DateTime.Now;
                        _dataRowTwoFactorAuthenticationDeviceRegistrationHistory["ModifiedBy"] = Context.User.Identity.Name;//((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                        _dataRowTwoFactorAuthenticationDeviceRegistrationHistory["ModifiedDate"] = DateTime.Now;
                        if (TextBoxDeviceName.Text != string.Empty)
                            _dataRowTwoFactorAuthenticationDeviceRegistrationHistory["DeviceName"] = TextBoxDeviceName.Text;
                        if (TextBoxDeviceSerialNum.Text != string.Empty)
                            _dataRowTwoFactorAuthenticationDeviceRegistrationHistory["DeviceSerialNumber"] = TextBoxDeviceSerialNum.Text;
                        if (TextBoxDeviceUsername.Text != string.Empty)
                            _dataRowTwoFactorAuthenticationDeviceRegistrationHistory["DeviceEmail"] = TextBoxDeviceUsername.Text;
                        if (TextBoxDevicePassword.Text != "**********" || TextBoxDevicePassword.Text != string.Empty)
                        {
                            _dataRowTwoFactorAuthenticationDeviceRegistrationHistory["DevicePassword"] = ApplicationCommonFunctions.GetEncryptedData(TextBoxDevicePassword.Text, "Y");

                        }
                        _dataRowTwoFactorAuthenticationDeviceRegistrationHistory[
                               "TwoFactorAuthenticationDeviceRegistrationId"] =
                               _dataRowTwoFactorAuthenticationDeviceRegistrations[
                                   "TwoFactorAuthenticationDeviceRegistrationId"];

                        if (TwoFactorAuthenticationResponseObject.Passed == true)
                        {
                            _dataRowTwoFactorAuthenticationDeviceRegistrationHistory["Authenticated"] = "Y";
                        }
                        dsUserPreferences.TwoFactorAuthenticationDeviceRegistrationHistory.Rows.Add(_dataRowTwoFactorAuthenticationDeviceRegistrationHistory);
                    }
                
                    }

                    #endregion
                //Code added in Ref to Task#2595
                if (Session["StaffSecurityQuestions"] != null)
                {
                    DataSet dtstTemp = new DataSet();
                    dtstTemp.Merge((DataSet)Session["StaffSecurityQuestions"]);
                    //dsUserPreferences.EnforceConstraints = false;
                    dsUserPreferences.StaffSecurityQuestions.Merge(dtstTemp.Tables[0]);
                }
                try
                {
                    objectClientMedications.UpdateDocuments(dsUserPreferences);
                }
                catch (Exception ex)
                {
                }


                Proceed:

                //Code is added by Loveena in ref to Task#3155 to check the condition to Enable
                //Register Button
                #region--Code Added by Pradeep as per task#3155
                string unFormatedPhoneNumber = string.Empty;
                if (dsUserPreferences.Tables[0].Rows[0]["PhoneNumber"].ToString() != string.Empty)
                {
                    unFormatedPhoneNumber = getUnformatedPhoneNumber(dsUserPreferences.Tables[0].Rows[0]["PhoneNumber"].ToString().Trim());
                }
                string unFormatedFaxNumber = string.Empty;
                if (dsUserPreferences.Tables[0].Rows[0]["FaxNumber"].ToString() != string.Empty)
                {
                    unFormatedFaxNumber = getUnformatedPhoneNumber(dsUserPreferences.Tables[0].Rows[0]["FaxNumber"].ToString().Trim());
                }
                #endregion
                //Made changes for check for Phone number and faxnumber as per task#3155
                
                if (dsUserPreferences.Tables[0].Rows[0]["FirstName"].ToString() != string.Empty && dsUserPreferences.Tables[0].Rows[0]["LastName"].ToString() != string.Empty && dsUserPreferences.Tables[0].Rows[0]["SigningSuffix"].ToString() != string.Empty && dsUserPreferences.Tables[0].Rows[0]["Degree"].ToString() != string.Empty && dsUserPreferences.Tables[0].Rows[0]["Degree"].ToString() != "0"  && dsUserPreferences.Tables[0].Rows[0]["NationalProviderId"].ToString() != string.Empty && unFormatedPhoneNumber.Length >= 7 && unFormatedFaxNumber.Length >= 7 && dsUserPreferences.Tables[0].Rows[0]["SureScriptsActiveStartTime"].ToString() != string.Empty && dsUserPreferences.Tables[0].Rows[0]["SureScriptsActiveEndTime"].ToString() != string.Empty && dsUserPreferences.Tables[0].Rows[0]["SureScriptsServiceLevel"].ToString() != string.Empty)
                {
                    if (ButtonRegister.Value == "Update Registration")
                    {
                        ButtonRegister.Disabled = false;
                        ButtonRegister.Visible = false;
                        LabelRegister.Visible = true;
                        Page.ClientScript.RegisterStartupScript(this.GetType(), "GetSureScriptsPrescriberIdMethodCall", "GetSureScriptsPrescriberId(" + Convert.ToInt32(Session["StaffIdForPreferences"]) + ");", true);
                    }
                    else if (TextBoxSureScriptsPrescriberId.Text == string.Empty && ButtonRegister.Value == "Register")
                    {
                        ButtonRegister.Disabled = false;
                        ButtonRegister.Visible = true;
                        LabelRegister.Visible = false;
                    }


                    // ButtonRegister.Disabled = false;
                    if (ButtonRegister.Disabled == false)
                    {
                        //added By priya
                        if (Session["StaffIdForPreferences"] == null)
                        {
                            dsTemp = null;
                            dsTemp = objUserPreferences.DownloadStaffMedicationDetail();
                            Session["StaffIdForPreferences"] = dsTemp.Tables[0].Compute("Max(StaffId)", "");
                        }
                        ButtonRegister.Attributes.Add("onclick", "GetSureScriptsPrescriberId(" + Convert.ToInt32(Session["StaffIdForPreferences"]) + ");");
                        //Added By priya
                        if (((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).Administrator == "Y")
                        {
                            HiddenIsAdmin.Value = "Y";
                        }
                        else
                        {
                            HiddenIsAdmin.Value = "N";
                        }
                    }
                }
                else
                {
                    ButtonRegister.Disabled = true;
                }
                ScriptManager.RegisterStartupScript(LabelEmail, LabelEmail.GetType(), "", "javascript:PasswordInput();", true);
                dsTemp = null;
                dsTemp = objUserPreferences.DownloadStaffMedicationDetail();

                if (Session["StaffIdForPreferences"] == null)
                    Session["StaffIdForPreferences"] = dsTemp.Tables[0].Compute("Max(StaffId)", "");



                #region "Refill Permissions List
                //To Refill The Permissions List after Update.

                if (((Streamline.BaseLayer.StreamlineIdentity) Context.User.Identity).Administrator == "Y")
                {
                DataSet DataSetPermissions = null;
                    DataSetPermissions =
                        objUserPreferences.CheckStaffPermissions(Convert.ToInt32(Session["StaffIdForPreferences"]));
                if (DataSetPermissions != null && DataSetPermissions.Tables[0].Rows.Count > 0)
                {

                    PanelPermissionsList.Controls.Clear();
                    Table tbPermissionsList = new Table();
                    tbPermissionsList.ID = System.Guid.NewGuid().ToString();

                    tbPermissionsList.Width = new Unit(100, UnitType.Percentage);

                    TableHeaderRow thTitle = new TableHeaderRow();
                    TableHeaderCell thBlank1 = new TableHeaderCell();

                    //Screen Name
                    TableHeaderCell thScreenName = new TableHeaderCell();
                    thScreenName.Text = "Screen Name";
                    thScreenName.Attributes.Add("onclick", "onHeaderClick(this)");
                    thScreenName.Attributes.Add("ColumnName", "ScreenName");
                    //thScreenName.CssClass = "handStyle";
                    thScreenName.Attributes.Add("align", "left");

                    //Action
                    TableHeaderCell thAction = new TableHeaderCell();
                    thAction.Text = "Action";
                    thAction.Attributes.Add("onclick", "onHeaderClick(this)");
                    thAction.Attributes.Add("ColumnName", "Action");
                    //thAction.CssClass = "handStyle";
                    thAction.Attributes.Add("align", "left");

                    thTitle.Cells.Add(thBlank1);
                    thTitle.Cells.Add(thScreenName);
                    thTitle.Cells.Add(thAction);

                    thTitle.CssClass = "GridViewHeaderText";
                    string rowClass = "GridViewRowStyle";
                    tbPermissionsList.Rows.Add(thTitle);

                    string staffPermissionId;

                    string myscript = "<script id='Permissionslist' type='text/javascript'>";
                    myscript += "function $deleteRecord(sender,e){";
                    if (!string.IsNullOrEmpty(_deleteRowMessage))
                    {
                            myscript += " if (confirm ('" + _deleteRowMessage + "') == true ){" +
                                        this._onDeleteEventHandler + "(sender,e)}}";
                    }
                    else
                    {
                        myscript += "}";
                    }
                    if (DataSetPermissions != null && DataSetPermissions.Tables.Count > 1)
                    {
                        myscript += "function RegisterPermissionsListControlEvents(){try{";
                        if (DataSetPermissions.Tables[1].Rows.Count > 0)
                        {
                            Random ran = new Random();
                            foreach (DataRow dr in DataSetPermissions.Tables[1].Rows)
                            {
                                if (dr["RecordDeleted"].ToString() != "Y")
                                {
                                    if (DataSetPermissions.Tables[1].Columns.Contains("StaffPermissionId"))
                                    {
                                        if (dr["StaffPermissionId"].ToString() != "")
                                            staffPermissionId = dr["StaffPermissionId"].ToString();
                                        else
                                            staffPermissionId = ran.Next().ToString();
                                    }
                                    else
                                        staffPermissionId = ran.Next().ToString();
                                    string screeName = "Medication Management";
                                    //string action = dr["Action"].ToString();
                                        DataRow[] _DataRowAction =
                                            Streamline.UserBusinessServices.SharedTables.DataSetSystemActions.Tables[0]
                                                .Select("ActionId in(" + Convert.ToInt32(dr["ActionId"]) + ")");
                                    string action = _DataRowAction[0]["Action"].ToString();
                                        tbPermissionsList.Rows.Add(GenerateSubRows(dr, staffPermissionId, screeName,
                                                                                   action, tbPermissionsList.ClientID,
                                                                                   ref myscript, rowClass));
                                        rowClass = rowClass == "GridViewRowStyle" ? "GridViewAlternatingRowStyle" : "GridViewRowStyle";
                                }
                            }
                        }
                        DataSet dataSetNewStaff = new DataSet();
                        //Start Code Written By Pradeep as per task#23
                        DataSet dataSetLocationList = new DataSet();
                            dataSetLocationList =
                                objUserPreferences.GetUserPreferancesLocationList(
                                    Convert.ToInt32(Session["StaffIdForPreferences"]));
                        //End Code Written By Pradeep as per task#23
                            dataSetNewStaff =
                                objUserPreferences.CheckStaffPermissions(
                                    Convert.ToInt32(Session["StaffIdForPreferences"]));
                        dsUserPreferences = null;
                        dsUserPreferences = new Streamline.UserBusinessServices.DataSets.DataSetUserPrefrences();
                        dsUserPreferences.Staff.Merge(dataSetNewStaff.Tables[0]);
                        dsUserPreferences.StaffPermissions.Merge(dataSetNewStaff.Tables[1]);
                        //Start Code Written By Pradeep as per task#23
                        dsUserPreferences.StaffLocations.Merge(dataSetLocationList.Tables["StaffLocations"]);
                        dsUserPreferences.Locations.Merge(dataSetLocationList.Tables["Locations"]);
                            dsUserPreferences.PrinterDeviceLocations.Merge(
                                dataSetLocationList.Tables["PrinterDeviceLocations"]);
                        //End Code Written By Pradeep as per task#23
                        //Code added in ref to Task#2595
                        dsUserPreferences.StaffSecurityQuestions.Merge(dataSetNewStaff.Tables[2]);
                        tbPermissionsList.CellPadding = 0;
                        tbPermissionsList.CellSpacing = 0;
                        Session["DataSetPermissionsList"] = dsUserPreferences;                        
                        PanelPermissionsList.Controls.Add(tbPermissionsList);
                            myscript +=
                                "}catch(e){  Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);}}</script>";
                        Page.RegisterClientScriptBlock(this.ClientID, myscript);
                        Session["ActionIds"] = null;
                    }

                }
                }

                #endregion

                #region "Refill Password Expires DropDown List"
                if (HiddenPasswordExpires.Value != string.Empty)
                {
                    DropDownListPasswordExpires.SelectedIndex = Convert.ToInt32(HiddenPasswordExpires.Value);
                }
                if (CheckBoxPasswordExpires.Checked == true)
                {
                    DropDownListPasswordExpires.Enabled = false;
                }
                else if (CheckBoxPasswordExpires.Checked == false)
                {
                    DropDownListPasswordExpires.Enabled = true;
                }
                #endregion

                #region "Refill Security Questions"
                //Code added by Loveena in ref to Task#2595
                //                if (((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).Administrator == "Y")
                if (Convert.ToInt32(Session["StaffIdForPreferences"]) != ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId)
                {
                    TrSecurity.Visible = false;
                }
                else
                {
                    TrSecurity.Visible = true;
                    createSecurityControls();
                }
                //Code ends over here.
                #endregion
                HiddenStaffPermissionId.Value = string.Empty;
                #region--Code Written By Pradeep as per task#23
                this.GenerateUserPreferancesLocationListRows();
                //GetStaffData();//Code Added by Pradeep on 14 jan 2011
                #endregion

                if (Session["StaffIdForPreferences"] != null && ((HiddenField)(Page.FindControl("HiddenPageName"))).Value != "ClientList")
                {
                   // ButtonDelete.Enabled = true;
                    ButtonDelete.Attributes.Remove("class");     
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
                objUserPreferences = null;
                dsTemp = null;
                dsUserPreferences = null;
                objectClientMedications = null;
                Session["StaffSecurityQuestions"] = null;
            }
        }

        private void DisableEPCS()
        {
            UserPrefernces staffDetails = new UserPrefernces();
            int selectedstaff = Convert.ToInt32(dsUserPreferences.Tables["Staff"].Rows[0]["StaffId"]);
            int EPCSAssignorStaffId = ((Streamline.BaseLayer.StreamlineIdentity)HttpContext.Current.User.Identity).UserId;
            string CreatedBy = ((Streamline.BaseLayer.StreamlineIdentity)HttpContext.Current.User.Identity).UserCode;
            string Enable = "N";
            string strErrorMessage = staffDetails.UpdateStaff(selectedstaff.ToString(), EPCSAssignorStaffId, CreatedBy, Enable, "");
        }
        //protected void ButtonDelete_Click(object sender, EventArgs e)
        //{
        //    DataSet dsTemp = null;
        //    try
        //    {
        //        CommonFunctions.Event_Trap(this);
        //        objUserPreferences = new UserPrefernces();
        //        dsUserPreferences = new Streamline.UserBusinessServices.DataSets.DataSetUserPrefrences();
        //        dsTemp = objUserPreferences.DownloadStaffMedicationDetail();
        //        dsUserPreferences.Staff.Merge(dsTemp.Tables[0]);
        //        objectClientMedications = new ClientMedication();
        //        DataRow[] _dataRowUserPrefernces = null;
        //        _dataRowUserPrefernces = dsUserPreferences.Tables[0].Select("StaffId=" + Convert.ToInt32(Session["StaffIdForPreferences"]));
        //        if (_dataRowUserPrefernces.Length > 0)
        //        {
        //            _dataRowUserPrefernces[0]["RecordDeleted"] = "Y";
        //            _dataRowUserPrefernces[0]["DeletedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
        //            _dataRowUserPrefernces[0]["DeletedDate"] = Convert.ToDateTime(DateTime.Now.ToShortDateString());
        //            objectClientMedications.UpdateDocuments(dsUserPreferences);
        //            Session["StaffIdForPreferences"] = null;
        //        }
        //        ScriptManager.RegisterStartupScript(LabelErrorMessage, LabelErrorMessage.GetType(), "key", "OpenStartPage();", true);
        //    }
        //    catch (Exception ex)
        //    {
        //        if (ex.Data["CustomExceptionInformation"] == null)
        //            ex.Data["CustomExceptionInformation"] = "";
        //        else
        //            ex.Data["CustomExceptionInformation"] = "";
        //        if (ex.Data["DatasetInfo"] == null)
        //            ex.Data["DatasetInfo"] = null;
        //        Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);
        //    }
        //    finally
        //    {
        //        objUserPreferences = null;
        //        dsTemp = null;
        //        dsUserPreferences = null;
        //        objectClientMedications = null;
        //    }
        //}

        /// <summary>
        /// <Author>Loveena</Author>
        /// <Description>In ref to Task#2595 to fill Security Questions Dropdown</Description>
        /// </summary>
        private string FillSecurityQuestions(DropDownList DropDownListSecurityQuestion)
        {
            DataSet DataSetGlobalCodes = null;
            int counter;
            string BindText = "", GlobalQuestions = "";
            try
            {
                DataSetGlobalCodes = Streamline.UserBusinessServices.SharedTables.DataSetGlobalCodes.Clone();
                DataRow[] DataRowGlobalCodes = Streamline.UserBusinessServices.SharedTables.DataSetGlobalCodes.Tables[0].Select("Category='SECURITYQUESTION' And ISNULL(RecordDeleted,'N')='N'", "SortOrder Asc");
                DataSetGlobalCodes.Merge(DataRowGlobalCodes);
                DataSetGlobalCodes.Tables[0].TableName = "SECURITYQUESTIONS";
                BindSecurityQuestionDropdown(DropDownListSecurityQuestion, DataSetGlobalCodes);
                //BindSecurityQuestionDropdown(DropDownListSecurityQuestion2, DataSetGlobalCodes);
                //BindSecurityQuestionDropdown(DropDownListSecurityQuestion3, DataSetGlobalCodes);

                /*************************************************************/
                for (counter = 0; counter < DataSetGlobalCodes.Tables["SECURITYQUESTIONS"].Rows.Count; counter++)
                {
                    GlobalQuestions += DataSetGlobalCodes.Tables["SECURITYQUESTIONS"].Rows[counter]["CodeName"].ToString() + ";" + DataSetGlobalCodes.Tables["SECURITYQUESTIONS"].Rows[counter]["GlobalCodeId"].ToString() + "|";
                }
                GlobalQuestions = GlobalQuestions.Replace("'", "\\'");
                //GlobalQuestions string structure -  GlobalQuestions = "What was the name of your first school?;1131|Who was your childhood hero?;1132|What is your Mobile No ?;1134";
                //GlobalQuestions= GlobalQuestions.Replace("'", "''");
                if (GlobalQuestions.Length > 0)
                {
                    GlobalQuestions = GlobalQuestions.Substring(0, GlobalQuestions.Length - 1);
                }
                //try
                //    {
                //    BindText = GetLocalResourceObject("SelectQuestionMessage").ToString();
                //    }
                //catch { BindText = "Select a Question"; }
                BindText = "Select a Question";
                //DropDownListSecurityQuestion.Attributes.Add("onChange", "FillDistinctQuestions('" + DropDownListSecurityQuestion.ClientID + "','" + DropDownListSecurityQuestion2.ClientID + "','" + DropDownListSecurityQuestion3.ClientID + "','" + GlobalQuestions + "','" + BindText + "');");
                //DropDownListSecurityQuestion2.Attributes.Add("onChange", "FillDistinctQuestions('" + DropDownListSecurityQuestion1.ClientID + "','" + DropDownListSecurityQuestion2.ClientID + "','" + DropDownListSecurityQuestion3.ClientID + "','" + GlobalQuestions + "','" + BindText + "');");
                //DropDownListSecurityQuestion3.Attributes.Add("onChange", "FillDistinctQuestions('" + DropDownListSecurityQuestion1.ClientID + "','" + DropDownListSecurityQuestion2.ClientID + "','" + DropDownListSecurityQuestion3.ClientID + "','" + GlobalQuestions + "','" + BindText + "');");
                return GlobalQuestions;
                /******************************************************************************/

            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "";
                else
                    ex.Data["CustomExceptionInformation"] = "";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
            finally
            {
                if (DataSetGlobalCodes != null)
                {
                    DataSetGlobalCodes.Dispose();
                }
            }
        }

        /// <summary>
        /// Bind DropDownlist With Security Questions
        /// </summary>
        /// <param name="DropDownListSecurityQuestion">Security Question DropDownlist</param>
        /// <param name="DataSetSecurityQuestion">Security Question Dataset</param>
        /// <Author>Loveena </Author>
        /// <createdOn>Oct 23, 2009</createdOn>
        private void BindSecurityQuestionDropdown(DropDownList DropDownListSecurityQuestion, DataSet DataSetSecurityQuestion)
        {
            string BindText = "";
            try
            {
                try
                {
                    string path = Page.ResolveUrl("~/");
                    BindText = HttpContext.GetLocalResourceObject(path, "SelectQuestionMessage").ToString();

                }
                catch { BindText = "Select a Question"; }
                DropDownListSecurityQuestion.DataTextField = "CodeName";
                DropDownListSecurityQuestion.DataValueField = "GlobalCodeId";
                DropDownListSecurityQuestion.DataSource = DataSetSecurityQuestion.Tables["SECURITYQUESTIONS"];
                DropDownListSecurityQuestion.DataBind();
                DropDownListSecurityQuestion.Items.Insert(0, new ListItem(BindText, "0"));
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "";
                else
                    ex.Data["CustomExceptionInformation"] = "";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
        }

        //Changes to merge.
        private void Clear_Controls()
        {
            try
            {
                CheckBoxListActive.Items.Clear();
                TextBoxAddress.Text = string.Empty;
                TextBoxConfirmPassword.Text = string.Empty;
                //TextBoxDEA.Text = string.Empty;
                TextBoxEmail.Text = string.Empty;
                TextBoxFirstName.Text = string.Empty;
                TextBoxLastName.Text = string.Empty;
                //TextBoxLicense.Text = string.Empty;
                TextBoxMedicationDays.Text = string.Empty;
                //--Start Code Added by Pradeep as per task#2639 on Nov 25,2009
                this.TextBoxDefaultPrescribingQuantity.Text = string.Empty;
                //--End Code Added by Pradeep as per task#2639 on Nov 25,2009
                //TextBoxNPI.Text = string.Empty;
                //Added by Loveena in ref to Task#85
                TextBoxSureScriptsPrescriberId.Text = string.Empty;
                //Modified in ref to Task#2656
                //TextBoxPassword.Text = string.Empty;
                TextBoxPassword.Text = "**********";
                TextBoxConfirmPassword.Text = "**********";
                TextBoxPassword.Font.Bold = true;
                TextBoxPhone.Text = string.Empty;
                TextBoxFaxNumber.Text = string.Empty;
                TextBoxSigning.Text = string.Empty;
                TextBoxUserName.Text = string.Empty;
                //Start Code comented by Pradeep as per task#23
                //DropDownListDefaultLocation.SelectedIndex = 0;
                //End Code comented by Pradeep as per task#23
                DropDownListDegree.SelectedIndex = 0;
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

        private void GenerateRows()
        {
            objUserPreferences = new UserPrefernces();
            DataSet DataSetPermissions = null;
            DataSet dsTemp = null;
            DataSet dsStaff = null;
            dsUserPreferences = new Streamline.UserBusinessServices.DataSets.DataSetUserPrefrences();
            DataSet DataSetLocationList = null;//Added By pradeep as per task#23
            try
            {
                DataSet dtst = new DataSet();
                Session["Permissions"] = "";
                string rowClass = "GridViewRowStyle";
                DataSetPermissions = new DataSet();
                if (Session["StaffIdForPreferences"] != null && HiddenStaffPermissionId.Value == string.Empty)
                {
                    dsTemp = objUserPreferences.CheckStaffPermissions(Convert.ToInt32(Session["StaffIdForPreferences"]));
                    //--Start Code Written by Pradeep as per task#23
                    DataSetLocationList = objUserPreferences.GetUserPreferancesLocationList(Convert.ToInt32(Session["StaffIdForPreferences"]));
                    dsUserPreferences.Locations.Merge(DataSetLocationList.Tables["Locations"]);
                    dsUserPreferences.StaffLocations.Merge(DataSetLocationList.Tables["StaffLocations"]);
                    dsUserPreferences.PrinterDeviceLocations.Merge(DataSetLocationList.Tables["PrinterDeviceLocations"]);
                    //End Code Writen By Pradeep as per task#23
                    dsUserPreferences.Staff.Merge(dsTemp.Tables[0]);
                    dsUserPreferences.TwoFactorAuthenticationDeviceRegistrations.Merge(dsTemp.Tables[3]);
                    dsUserPreferences.StaffPermissions.Merge(dsTemp.Tables[1]);
                    //Added in ref to Task#2595
                    dsUserPreferences.StaffSecurityQuestions.Merge(dsTemp.Tables[2]);
                }
                //Changes for merge.
                else if (Session["StaffIdForPreferences"] != null && HiddenStaffPermissionId.Value != string.Empty)
                {
                    if (Session["DataSetPermissionsList"] != null)
                    {
                        if (((DataSet)(Session["DataSetPermissionsList"])).Tables.Count > 0)
                        {
                            dsUserPreferences = (Streamline.UserBusinessServices.DataSets.DataSetUserPrefrences)(Session["DataSetPermissionsList"]);
                        }
                    }
                    DataRow[] _DataRowPermissions = Streamline.UserBusinessServices.SharedTables.DataSetSystemActions.Tables[0].Select("ActionId in(" + HiddenStaffPermissionId.Value + ")");
                    for (int i = 0; i < _DataRowPermissions.Length; i++)
                    {
                        DataRow DataRowNewPermissiosn = dsUserPreferences.StaffPermissions.NewRow();
                        DataRowNewPermissiosn["StaffId"] = Convert.ToInt32(dsUserPreferences.Staff.Rows[0]["StaffId"]);
                        DataRowNewPermissiosn["ActionId"] = _DataRowPermissions[i]["ActionId"];
                        DataRowNewPermissiosn["RowIdentifier"] = System.Guid.NewGuid();
                        DataRowNewPermissiosn["CreatedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                        DataRowNewPermissiosn["CreatedDate"] = DateTime.Now;
                        DataRowNewPermissiosn["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                        DataRowNewPermissiosn["ModifiedDate"] = DateTime.Now;
                        DataRowNewPermissiosn["NewlyAddedColumn"] = "Y";
                        dsUserPreferences.StaffPermissions.Rows.Add(DataRowNewPermissiosn);
                    }
                }
                else if (Session["StaffIdForPreferences"] == null && HiddenStaffPermissionId.Value != string.Empty)
                {
                    DataRow[] _dataRow = Streamline.UserBusinessServices.SharedTables.DataSetSystemActions.Tables[0].Select("ActionId in (" + HiddenStaffPermissionId.Value + ")");
                    String[] ActionId = HiddenStaffPermissionId.Value.Split(',');
                    if (ActionId.Length > 0)
                    {
                        if (Session["DataSetPermissionsList"] == null)
                        {
                            DataSetPermissions = new DataSet();
                            DataSetPermissions.Tables.Add("StaffPermissions");
                            DataSetPermissions.Tables[0].Columns.Add("ActionId", System.Type.GetType("System.Int32"));
                            DataSetPermissions.Tables[0].Columns.Add("StaffPermissionId", System.Type.GetType("System.Int32"));
                            DataSetPermissions.Tables[0].Columns.Add("NewlyAddedColumn");
                            DataSetPermissions.Tables[0].Columns.Add("StaffId", System.Type.GetType("System.Int32"));
                            DataSetPermissions.Tables[0].Columns.Add("CreatedBy");
                            DataSetPermissions.Tables[0].Columns.Add("CreatedDate", System.Type.GetType("System.DateTime"));
                            DataSetPermissions.Tables[0].Columns.Add("ModifiedBy");
                            DataSetPermissions.Tables[0].Columns.Add("ModifiedDate", System.Type.GetType("System.DateTime"));
                            DataSetPermissions.Tables[0].Columns.Add("RecordDeleted");
                            DataSetPermissions.Tables[0].Columns.Add("DeletedBy");
                            DataSetPermissions.Tables[0].Columns.Add("DeletedDate", System.Type.GetType("System.DateTime"));
                            DataSetPermissions.Tables[0].Columns.Add("RowIdentifier", System.Type.GetType("System.Guid"));
                        }
                        else
                        {
                            dsTemp = (DataSet)Session["DataSetPermissionsList"];
                            dsUserPreferences.Merge(dsTemp);
                        }
                        Random ran = new Random();
                        for (int i = 0; i < ActionId.Length; i++)
                        {
                            //Random ran = new Random();
                            DataRow DataRowNewPermissiosn = dsUserPreferences.StaffPermissions.NewRow();
                            DataRowNewPermissiosn["StaffPermissionId"] = Convert.ToInt32(ran.Next().ToString());
                            DataRowNewPermissiosn["StaffId"] = Convert.ToInt32(dsUserPreferences.Staff.Rows[0]["StaffId"]);
                            DataRowNewPermissiosn["ActionId"] = Convert.ToInt32(_dataRow[i]["ActionId"]);
                            DataRowNewPermissiosn["RowIdentifier"] = System.Guid.NewGuid();
                            DataRowNewPermissiosn["CreatedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                            DataRowNewPermissiosn["CreatedDate"] = DateTime.Now;
                            DataRowNewPermissiosn["ModifiedBy"] = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserCode;
                            DataRowNewPermissiosn["ModifiedDate"] = DateTime.Now;
                            DataRowNewPermissiosn["NewlyAddedColumn"] = "Y";
                            dsUserPreferences.StaffPermissions.Rows.Add(DataRowNewPermissiosn);
                        }
                    }
                }
                DataSetPermissions.Merge(dsUserPreferences.StaffPermissions);
                PanelPermissionsList.Controls.Clear();
                Table tbPermissionsList = new Table();
                tbPermissionsList.ID = System.Guid.NewGuid().ToString();

                tbPermissionsList.Width = new Unit(100, UnitType.Percentage);

                TableHeaderRow thTitle = new TableHeaderRow();
                TableHeaderCell thBlank1 = new TableHeaderCell();

                //Screen Name
                TableHeaderCell thScreenName = new TableHeaderCell();
                thScreenName.Text = "Screen Name";
                thScreenName.Attributes.Add("onclick", "onHeaderClick(this)");
                thScreenName.Attributes.Add("ColumnName", "ScreenName");
                //thScreenName.CssClass = "handStyle";
                thScreenName.Attributes.Add("align", "left");

                //Action
                TableHeaderCell thAction = new TableHeaderCell();
                thAction.Text = "Action";
                thAction.Attributes.Add("onclick", "onHeaderClick(this)");
                thAction.Attributes.Add("ColumnName", "Action");
                //thAction.CssClass = "handStyle";
                thAction.Attributes.Add("align", "left");

                thTitle.Cells.Add(thBlank1);
                thTitle.Cells.Add(thScreenName);
                thTitle.Cells.Add(thAction);

                thTitle.CssClass = "GridViewHeaderText";

                tbPermissionsList.Rows.Add(thTitle);

                string staffPermissionId;
                string myscript = "<script id='Permissionslist' type='text/javascript'>";
                myscript += "function $deleteRecord(sender,e){";
                if (!string.IsNullOrEmpty(_deleteRowMessage))
                {
                    myscript += " if (confirm ('" + _deleteRowMessage + "') == true ){" + this._onDeleteEventHandler + "(sender,e)}}";
                }
                else
                {
                    myscript += "}";
                }
                if (DataSetPermissions != null && DataSetPermissions.Tables["StaffPermissions"].Rows.Count > 0)
                {
                    myscript += "function RegisterPermissionsListControlEvents(){try{";
                    if (DataSetPermissions.Tables[0].Rows.Count > 0)
                    {
                        Random ran = new Random();
                        DataRow[] dtr = DataSetPermissions.Tables[0].Select("ISNULL(RecordDeleted,'N')<>'Y'");
                        DataView dtv = DataSetPermissions.Tables[0].DefaultView;
                        dtv.RowFilter = "ISNULL(RecordDeleted,'N')<>'Y'";

                        dtst.Merge(dtr);
                        foreach (DataRow dr in dtst.Tables[0].Rows)
                        {
                            if (dtst.Tables[0].Columns.Contains("StaffPermissionId"))
                            {
                                if (dr["StaffPermissionId"].ToString() != "")
                                    staffPermissionId = dr["StaffPermissionId"].ToString();
                                else
                                {
                                    staffPermissionId = ran.Next().ToString();
                                    dr["StaffPermissionId"] = staffPermissionId;
                                }
                            }
                            else
                                staffPermissionId = ran.Next().ToString();
                            string screeName = "Medication Management";
                            DataRow[] _DataRowAction = Streamline.UserBusinessServices.SharedTables.DataSetSystemActions.Tables[0].Select("ActionId in(" + Convert.ToInt32(dr["ActionId"]) + ")");
                            string action = _DataRowAction[0]["Action"].ToString();
                            if (Session["Permissions"].ToString() == "")
                                Session["Permissions"] = _DataRowAction[0]["ActionId"].ToString();
                            else
                                Session["Permissions"] = Session["Permissions"] + "," + _DataRowAction[0]["ActionId"].ToString();
                            tbPermissionsList.Rows.Add(GenerateSubRows(dr, staffPermissionId, screeName, action, tbPermissionsList.ClientID, ref myscript, rowClass));
                            rowClass = rowClass == "GridViewRowStyle" ? "GridViewAlternatingRowStyle" : "GridViewRowStyle";
                        }
                    }
                    Session["DataSetPermissionsList"] = dsUserPreferences;
                    tbPermissionsList.CellSpacing = 0;
                    tbPermissionsList.CellPadding = 0;
                    PanelPermissionsList.Controls.Add(tbPermissionsList);
                    myscript += "}catch(e){  Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);}}</script>";
                    Page.RegisterClientScriptBlock(this.ClientID, myscript);
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
                throw (ex);

            }
        }
        protected void PermissionsList(object sender, EventArgs e)
        {
            if (TextBoxPassword.Text != "")
            {
                HiddenPassword.Value = TextBoxPassword.Text;
                ScriptManager.RegisterStartupScript(LabelEmail, LabelEmail.GetType(), "", "javascript:PasswordInput();", true);
            }
            GenerateRows();
        }
        private TableRow GenerateSubRows(DataRow dr, string staffPermissionId, string ScreenName, string Action, string tableId, ref string myscript, string rowClass)
        {
            try
            {

                CommonFunctions.Event_Trap(this);
                string newId = System.Guid.NewGuid().ToString();
                string tblId = this.ClientID + this.ClientIDSeparator + tableId;

                TableRow tblRow = new TableRow();
                tblRow.ID = "Tr_" + newId;
                TableCell tdScreenName = new TableCell();
                tdScreenName.Text = ScreenName.ToString();

                TableCell tdAction = new TableCell();
                tdAction.Text = Action;

                TableCell tdDelete = new TableCell();
                HtmlImage imgTemp = new HtmlImage();
                imgTemp.ID = "Img_" + staffPermissionId.ToString();

                string rowId = this.ClientID + this.ClientIDSeparator + tblRow.ClientID;

                imgTemp.Attributes.Add("StaffPermissionId", staffPermissionId);
                imgTemp.Src = "~/App_Themes/Includes/Images/deleteIcon.gif";
                imgTemp.Attributes.Add("class", "handStyle");
                tdDelete.Controls.Add(imgTemp);

                myscript += "var Imagecontext" + staffPermissionId + "={StaffPermissionId:" + staffPermissionId + ",TableId:'" + tblId + "',RowId:'" + rowId + "'};";
                myscript += "var ImageclickCallback" + staffPermissionId + " =";
                myscript += " Function.createCallback($deleteRecord, Imagecontext" + staffPermissionId + ");";
                myscript += "$addHandler($get('" + this.ClientID + this.ClientIDSeparator + imgTemp.ClientID + "'), 'click', ImageclickCallback" + staffPermissionId + ");";

                tblRow.Cells.Add(tdDelete);
                tblRow.Cells.Add(tdScreenName);
                tblRow.Cells.Add(tdAction);
                tblRow.CssClass = rowClass;
               // tblRow.CssClass = "GridViewRowStyle";
                return tblRow;
            }
            catch (Exception ex)
            {

                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "";
                else
                    ex.Data["CustomExceptionInformation"] = "";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);
            }
        }
        private void createSecurityControls()
        {

            try
            {
                HiddenSecurityQuestions.Value = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).NumberOfPrescriberSecurityQuestions.ToString();
                if (((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).NumberOfPrescriberSecurityQuestions > 0)
                {
                    PanelSecurityQuestions.Visible = true;
                    TrSecurity.Visible = true;
                    Table tableControls = new Table();
                    tableControls.Width = new Unit(100, UnitType.Percentage);
                    tableControls.ID = "tableSecrityQuestions";
                    tableControls.Attributes.Add("tableSecrityQuestions", "true");
                    string myscript = "<script id='UserPreferencesSecurityQuestions' type='text/javascript'>";
                    myscript += "function InitializeComponents(){;";
                    for (int _RowCount = 0; _RowCount < ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).NumberOfPrescriberSecurityQuestions; _RowCount++)
                    {
                        tableControls.Rows.Add(CreateSecurityQuestionsRow(_RowCount, ref myscript));
                        tableControls.Rows.Add(CreateSecurityAnswersRow(_RowCount, ref myscript));
                    }
                    myscript += "}</script>";
                    PlaceHolder.Controls.Add(tableControls);
                    ScriptManager.RegisterStartupScript(PlaceHolder, PlaceHolder.GetType(), PlaceHolder.ClientID.ToString(), myscript, false);
                    count = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).NumberOfPrescriberSecurityQuestions;
                    ScriptManager.RegisterStartupScript(Label1, Label1.GetType(), "bgfg", "javascript:SecurityAnswersInput(" + count + ");", true);
                }
                else
                {
                    //PanelSecurityQuestions.Visible = false;
                    //TrSecurity.Visible = false;
                }
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "";
                else
                    ex.Data["CustomExceptionInformation"] = "";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = "";

            }
            finally
            {

            }

        }

        private TableRow CreateSecurityQuestionsRow(int rowIndex, ref string myscript)
        {
            try
            {

                Table _Table = new Table();
                _Table.Width = new Unit(100, UnitType.Percentage);
                TableRow _TableRow = new TableRow();
                _TableRow.ID = "TableSecurityQuestionsRow_" + rowIndex;

                TableCell _TableCell0 = new TableCell();
                _TableCell0.CssClass = "labelFont";

                TableCell _TableCell1 = new TableCell();
                TableCell _TableCell2 = new TableCell();
                TableCell _TableCell3 = new TableCell();

                _Table.ID = "TableSecurityQuestion" + rowIndex;

                //Label _lblSecurityQuestion = new Label();
                //_lblSecurityQuestion.ID = "SecurityQuestion";
                //_lblSecurityQuestion.Height = 20;
                //_lblSecurityQuestion.Visible = true;
                //_lblSecurityQuestion.Text = "Question";

                _TableCell0.Text = "Question";

                //Label _lblRequired = new Label();
                //_lblRequired.ID = "Required";
                //_lblRequired.Text = "*";
                //_lblRequired.ForeColor = System.Drawing.Color.Red;
                _TableCell1.Text = "*";
                _TableCell1.Style.Add("color", "Red");

                DropDownList _DropDownListSecurityQuestion = new DropDownList();
                _DropDownListSecurityQuestion.Width = new Unit(100, UnitType.Percentage);
                _DropDownListSecurityQuestion.Height = 20;
                _DropDownListSecurityQuestion.ID = "_DropDownListSecurityQuestion" + rowIndex;

                HiddenField hiddenStaffSecurityQuestionId = new HiddenField();
                hiddenStaffSecurityQuestionId.ID = "hiddenStaffSecurityQuestionId" + rowIndex;


                //_TableCell0.Controls.Add(_lblSecurityQuestion);
                //Change width for task #2635 by mohit nov-18-2009
                //_TableCell0.Width = new Unit(35, UnitType.Percentage);
                _TableCell0.Width = new Unit(15, UnitType.Percentage);
                //Code ends over here.

                _TableCell1.Width = new Unit(2, UnitType.Percentage);
                //_TableCell1.Controls.Add(_lblRequired);
                _TableCell2.Controls.Add(_DropDownListSecurityQuestion);
                //Change width for task #2635 by mohit nov-18-2009
                //_TableCell2.Width = new Unit(60, UnitType.Percentage);
                _TableCell2.Width = new Unit(80, UnitType.Percentage);
                //Code ends over here.

                _TableCell3.Controls.Add(hiddenStaffSecurityQuestionId);


                string GlobalQuestions = FillSecurityQuestions(_DropDownListSecurityQuestion);
                ScriptManager.RegisterStartupScript(Label1, Label1.GetType(), ClientID.ToString(), "FillDistinctQuestions('" + _DropDownListSecurityQuestion.ID + "','" + GlobalQuestions + "','" + "Select a Question" + "','" + ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).NumberOfPrescriberSecurityQuestions + "');", true);
                _DropDownListSecurityQuestion.Attributes.Add("onChange", "FillDistinctQuestions('" + _DropDownListSecurityQuestion.ID + "','" + GlobalQuestions + "','" + "Select a Question" + "','" + ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).NumberOfPrescriberSecurityQuestions + "');");
                if (dsUserPreferences.StaffSecurityQuestions.Rows.Count > 0)
                {
                    if (dsUserPreferences.StaffSecurityQuestions.Rows.Count > rowIndex)
                    {
                        _DropDownListSecurityQuestion.SelectedValue = dsUserPreferences.StaffSecurityQuestions.Rows[rowIndex]["SecurityQuestion"].ToString();
                        hiddenStaffSecurityQuestionId.Value = dsUserPreferences.StaffSecurityQuestions.Rows[rowIndex]["StaffSecurityQuestionId"].ToString();
                    }
                    else
                        _DropDownListSecurityQuestion.SelectedValue = "-1";
                }
                _TableRow.Controls.Add(_TableCell0);
                _TableRow.Controls.Add(_TableCell1);
                _TableRow.Controls.Add(_TableCell2);
                _TableRow.Controls.Add(_TableCell3);

                return _TableRow;


            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "";
                else
                    ex.Data["CustomExceptionInformation"] = "";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = "";
                throw (ex);
            }
            finally
            {

            }
        }

        private TableRow CreateSecurityAnswersRow(int rowIndex, ref string myscript)
        {
            try
            {

                Table _Table = new Table();
                _Table.Width = new Unit(100, UnitType.Percentage);
                TableRow _TableRow = new TableRow();
                _TableRow.ID = "TableSecurityAnswersRow_" + rowIndex;
                TableCell _TableCell0 = new TableCell();
                _TableCell0.CssClass = "labelFont";
                TableCell _TableCell1 = new TableCell();
                TableCell _TableCell2 = new TableCell();
                TableCell _TableCell3 = new TableCell();

                _Table.ID = "TableSecurityAnswer" + rowIndex;

                //Label _lblSecurityQuestion = new Label();
                //_lblSecurityQuestion.ID = "SecurityAnswer";
                //_lblSecurityQuestion.Height = 20;
                //_lblSecurityQuestion.Visible = true;
                //_lblSecurityQuestion.Text = "Answer";

                //Label _lblRequired = new Label();
                //_lblRequired.ID = "Required";
                //_lblRequired.Text = "*";
                //_lblRequired.ForeColor = System.Drawing.Color.Red;

                _TableCell0.Text = "Answer";
                _TableCell1.Text = "*";
                _TableCell1.Style.Add("color", "red");

                TextBox _txtSecurityAnswer = new TextBox();
                _txtSecurityAnswer.BackColor = System.Drawing.Color.White;
                _txtSecurityAnswer.Width = new Unit(99, UnitType.Percentage);
                _txtSecurityAnswer.ID = "TextBoxSecurityAnswer" + rowIndex;
                //Code added in ref to Task#2655.
                _txtSecurityAnswer.TextMode = TextBoxMode.Password;
                //_txtSecurityAnswer.Text = "..........";
                _txtSecurityAnswer.Font.Bold = true;

                _txtSecurityAnswer.Attributes.Add("onfocus", "RemovePassword(" + rowIndex + ");");
                _txtSecurityAnswer.Attributes.Add("onblur", "AddPassword(" + rowIndex + ");");
                //added as Per Task No:3046
                _txtSecurityAnswer.Attributes.Add("onkeydown", "if(event.which || event.keyCode){if ((event.which == 13) || (event.keyCode == 13)) {document.getElementById('" + ButtonUpdate.UniqueID + "').focus();return false;}} else {return true}; ");
                //end
                HiddenField hiddenStaffSecurityAnswerId = new HiddenField();
                hiddenStaffSecurityAnswerId.ID = "hiddenStaffSecurityAnswerId" + rowIndex;

                if (dsUserPreferences.StaffSecurityQuestions.Rows.Count > 0)
                {
                    if (dsUserPreferences.StaffSecurityQuestions.Rows.Count > rowIndex)
                        //_txtSecurityAnswer.Text = ApplicationCommonFunctions.GetDecryptedData(dsUserPreferences.StaffSecurityQuestions.Rows[rowIndex]["SecurityAnswer"].ToString(),"Y");
                        //Modified in ref to Task#2655
                        //hiddenStaffSecurityAnswerId.Value = ApplicationCommonFunctions.GetDecryptedData(dsUserPreferences.StaffSecurityQuestions.Rows[rowIndex]["SecurityAnswer"].ToString(), "Y");
                        hiddenStaffSecurityAnswerId.Value = dsUserPreferences.StaffSecurityQuestions.Rows[rowIndex]["SecurityAnswer"].ToString();
                    //_txtSecurityAnswer.Attributes.Add("value","
                    else
                        _txtSecurityAnswer.Text = "";
                }
                //_TableCell0.Controls.Add(_lblSecurityQuestion);
                //Change width for task #2635 by mohit nov-18-2009
                //_TableCell0.Width = new Unit(35, UnitType.Percentage);
                _TableCell0.Width = new Unit(15, UnitType.Percentage);
                //code ends over here.
                _TableCell3.Controls.Add(hiddenStaffSecurityAnswerId);

                _TableCell1.Width = new Unit(2, UnitType.Percentage);
                //_TableCell1.Controls.Add(_lblRequired);
                _TableCell2.Controls.Add(_txtSecurityAnswer);
                //Change width for task #2635 by mohit nov-18-2009
                //_TableCell2.Width = new Unit(60, UnitType.Percentage);
                _TableCell2.Width = new Unit(80, UnitType.Percentage);
                //Code ends over here.

                _TableRow.Controls.Add(_TableCell0);
                _TableRow.Controls.Add(_TableCell1);
                _TableRow.Controls.Add(_TableCell2);
                _TableRow.Controls.Add(_TableCell3);

                return _TableRow;


            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "";
                else
                    ex.Data["CustomExceptionInformation"] = "";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = "";
                throw (ex);
            }
            finally
            {

            }
        }

        private void GetSecurityQuestions()
        {
            try
            {
                DataSet dtst = new DataSet();
                DataSet dsTemp = new DataSet();
                Session["Permissions"] = "";
                DataSet DataSetPermissions = new DataSet();
                if (Session["StaffIdForPreferences"] != null)
                {
                    dsTemp = objUserPreferences.CheckStaffPermissions(Convert.ToInt32(Session["StaffIdForPreferences"]));
                    dsUserPreferences.Staff.Merge(dsTemp.Tables[0]);
                    dsUserPreferences.StaffSecurityQuestions.Merge(dsTemp.Tables[2]);
                }
                createSecurityControls();
            }
            catch (Exception ex)
            {

                throw;
            }
        }
        #region---Code Written by Pradeep as per task#23
        /// <summary>
        /// <Description>Used to generate rows for location list</Description>
        /// <Author>Pradeep</Author>
        /// <CreatedOn>Nov 26,2009</CreatedOn>
        /// </summary>
        public void GenerateUserPreferancesLocationListRows()
        {
            //DataSet dataSetLocationList = null;
            DataRow[] dataRowLocationList = null;
            DataRow[] dataRowStaffLocations = null;
            DataRow[] dataRowstaff = null;


            try
            {
                CommonFunctions.Event_Trap(this);
                objUserPreferences = new UserPrefernces();
                //dataSetLocationList = objUserPreferences.GetUserPreferancesLocationList(Convert.ToInt32(((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).UserId));
                //dsUserPreferences

                PanelUserLocationList.Controls.Clear();
                //CreateLocationsLabelRow();
                TableRow _TableRow = new TableRow();
                TableCell _TableCell0 = new TableHeaderCell();
                TableCell _TableCell1 = new TableHeaderCell();
                TableCell _TableCell2 = new TableHeaderCell();
                TableCell _TableCell3 = new TableHeaderCell();
                TableCell _TableCell4 = new TableHeaderCell();

                Label labelLocationName = new Label();
                labelLocationName.ID = "LocationName";
                labelLocationName.Visible = true;
                labelLocationName.Text = "Location Name";

                Label labelDefault = new Label();
                labelDefault.ID = "Default";

                labelDefault.Visible = true;
                labelDefault.Text = "Default";
                //labelDefault.Font.Bold = true;

                Label labelScriptPrinter = new Label();
                labelScriptPrinter.ID = "ScriptPrinter";

                labelScriptPrinter.Visible = true;
                labelScriptPrinter.Text = "ScriptPrinter";
                //labelScriptPrinter.Font.Bold = true;

                Label labelChartcopyPrinter = new Label();
                labelChartcopyPrinter.ID = "ChartCopyPrinter";

                labelChartcopyPrinter.Visible = true;
                labelChartcopyPrinter.Text = "Chart Copy Printer";
                //labelChartcopyPrinter.Font.Bold = true;

                _TableCell1.Controls.Add(labelLocationName);
                _TableCell2.Controls.Add(labelDefault);
                _TableCell3.Controls.Add(labelScriptPrinter);
                _TableCell4.Controls.Add(labelChartcopyPrinter);

                _TableRow.Controls.Add(_TableCell0);
                _TableRow.Controls.Add(_TableCell1);
                _TableRow.Controls.Add(_TableCell2);
                _TableRow.Controls.Add(_TableCell3);
                _TableRow.Controls.Add(_TableCell4);
                _TableRow.CssClass = "GridViewHeaderText";
                //PanelUserLocationList.ScrollBars = ScrollBars.Vertical;
                Table tableUserLocationList = new Table();
                tableUserLocationList.ID = "tableUserLocationList";
                tableUserLocationList.Width = new Unit(100, UnitType.Percentage);
                //string myscript = "<script id='Stafflist' type='text/javascript'>";
                //myscript += "function RegisterStaffListControlEvents(){try{";
                tableUserLocationList.CellSpacing = 0;
                tableUserLocationList.CellPadding = 0;
                tableUserLocationList.Rows.Add(_TableRow);
                PanelUserLocationList.Controls.Add(tableUserLocationList);

                string newId = System.Guid.NewGuid().ToString();
                int rowIndex = 0;
                if (Session["DataSetPermissionsList"] != null)
                {
                    if (((DataSet)(Session["DataSetPermissionsList"])).Tables.Count > 0)
                    {
                        dsUserPreferences = (Streamline.UserBusinessServices.DataSets.DataSetUserPrefrences)(Session["DataSetPermissionsList"]);
                    }
                }

                var rowStyle = "GridViewRowStyle";

                if (dsUserPreferences != null)
                {
                    if (dsUserPreferences.Tables["Locations"].Rows.Count > 0)
                    {
                        dataRowLocationList = dsUserPreferences.Tables["Locations"].Select("1=1", "LocationName ASC");
                        if (dataRowLocationList.Length > 0)
                        {
                            tableLocation.Style.Add("display", "block");
                            foreach (DataRow dr in dataRowLocationList)
                            {

                                rowIndex = rowIndex + 1;
                                TableRow tableRow = new TableRow();
                                tableRow.ID = "Tr_" + newId;
                                TableCell tableCellLocationName = new TableCell();
                                /*******  Location Name ********/
                                tableCellLocationName.Text = dr["LocationName"].ToString();
                                tableCellLocationName.CssClass = "Label";
                               // tableCellLocationName.Style["padding-left"] = "5px";
                                tableCellLocationName.HorizontalAlign = HorizontalAlign.Left;
                              //  tableCellLocationName.Width = new Unit(63, UnitType.Percentage);
                                //----Assigned check box
                                TableCell tableCellAssigned = new TableCell();
                                //tableCellAssigned.Width = new Unit(2, UnitType.Percentage);
                                CheckBox checkBoxAssigned = new CheckBox();
                                checkBoxAssigned.ID = "CheckBoxAssigned" + rowIndex;
                                checkBoxAssigned.CssClass = "Label";
                                //checkBoxAssigned.Width = new Unit(2, UnitType.Percentage);

                                string locationId = dr["LocationId"] == DBNull.Value ? "" : dr["LocationId"].ToString();
                                dataRowStaffLocations = dsUserPreferences.Tables["StaffLocations"].Select("LocationId=" + locationId + "And StaffId=" + Convert.ToInt32(Session["StaffIdForPreferences"]));
                                if (dataRowStaffLocations.Length > 0)
                                {
                                    checkBoxAssigned.Checked = true;
                                }
                                tableCellAssigned.Controls.Add(checkBoxAssigned);
                                //---Default CheckBox
                                dataRowstaff = dsUserPreferences.Tables["Staff"].Select("StaffId=" + Convert.ToInt32(Session["StaffIdForPreferences"]));
                                string defaultPrescribingLocationId = string.Empty;
                                if (dataRowstaff.Length > 0)
                                {
                                    defaultPrescribingLocationId = dataRowstaff[0]["DefaultPrescribingLocation"] == DBNull.Value ? "" : dataRowstaff[0]["DefaultPrescribingLocation"].ToString();
                                }

                                TableCell tableCellDefault = new TableCell();
                               // tableCellDefault.Width = new Unit(5, UnitType.Percentage);
                                CheckBox checkBoxDefault = new CheckBox();
                                checkBoxDefault.ID = "CheckBoxDefault" + rowIndex;
                                checkBoxDefault.CssClass = "Label";
                               // checkBoxDefault.Width = new Unit(2, UnitType.Percentage);
                               tableCellDefault.Style["padding-left"] = "15px";
                                if (defaultPrescribingLocationId != string.Empty)
                                {
                                    if (defaultPrescribingLocationId == locationId)
                                    {
                                        checkBoxDefault.Checked = true;
                                    }
                                }

                                checkBoxDefault.Attributes.Add("onclick", "UnCheckOtherDefaultCheckBoxes('" + checkBoxDefault.ClientID + "'," + locationId + ");");

                                tableCellDefault.Controls.Add(checkBoxDefault);



                                DataView dataViewPrinterDeviceLocation = dsUserPreferences.Tables["PrinterDeviceLocations"].DefaultView;
                                dataViewPrinterDeviceLocation.RowFilter = "LocationId=" + locationId;
                                dataViewPrinterDeviceLocation.Sort = "DeviceLabel";
                                TableCell tableCellDropDownList = new TableCell();
                                //tableCellDropDownList.Width = new Unit(15, UnitType.Percentage);
                                //tableCellDropDownList.Style["padding-left"] = "5px";
                                DropDownList DropDownListDefaultPrinterLoc = new DropDownList();
                                DropDownListDefaultPrinterLoc.ID = "DropDownListDefaultPrinterLoc" + rowIndex;
                                DropDownListDefaultPrinterLoc.Width = new Unit(130, UnitType.Pixel);
                                //DropDownListDefaultPrinterLoc.DataSource = dsUserPreferences.Tables["PrinterDeviceLocations"];
                                if (dataViewPrinterDeviceLocation.Count > 0)
                                {
                                    DropDownListDefaultPrinterLoc.DataSource = dataViewPrinterDeviceLocation;
                                    DropDownListDefaultPrinterLoc.DataTextField = "DeviceLabel";
                                    DropDownListDefaultPrinterLoc.DataValueField = "PrinterDeviceLocationId";
                                    DropDownListDefaultPrinterLoc.DataBind();
                                }
                                DropDownListDefaultPrinterLoc.Items.Insert(0, new ListItem("", ""));
                                checkBoxAssigned.Attributes.Add("onclick", "MakeDisableDefaultCheckBox('" + checkBoxAssigned.ClientID + "','" + checkBoxDefault.ClientID + "'," + locationId + ",'" + DropDownListDefaultPrinterLoc.ClientID + "');");
                                //else//--By Pradeep on 14Dec 2009
                                //{
                                //    checkBoxDefault.Enabled = false;
                                //    checkBoxAssigned.Enabled = false;
                                //}


                                tableCellDropDownList.Controls.Add(DropDownListDefaultPrinterLoc);
                                string printerDevice = string.Empty;
                                if (dataRowStaffLocations.Length > 0)
                                {
                                    if (dataRowStaffLocations[0]["PrescriptionPrinterLocationId"] != DBNull.Value)
                                    {
                                        printerDevice = Convert.ToString(dataRowStaffLocations[0]["PrescriptionPrinterLocationId"].ToString());
                                    }
                                }

                                //printerDevice = dataRowStaffLocations[0]["PrinterDeviceLocationId"] == DBNull.Value ? "0" : Convert.ToString(dataRowStaffLocations[0]["PrinterDeviceLocationId"].ToString());
                                if (printerDevice != string.Empty)
                                {
                                    if (DropDownListDefaultPrinterLoc.Items.FindByValue(printerDevice) != null)
                                    {
                                        DropDownListDefaultPrinterLoc.SelectedValue = printerDevice;
                                    }
                                }
                                DropDownListDefaultPrinterLoc.Attributes.Add("onchange", "SetPrinterDeviceLocation('" + DropDownListDefaultPrinterLoc.ClientID + "'," + locationId + ",'" + checkBoxAssigned.ClientID + "');");

                                //Code added by Loveena in ref to Task#86 to add CharCopyPrinter                                
                                TableCell tableCellDropDownListCharCopy = new TableCell();
                               // tableCellDropDownListCharCopy.Width = new Unit(15, UnitType.Percentage);
                                //tableCellDropDownListCharCopy.Style["padding-left"] = "5px";
                                DropDownList DropDownListChartCopyPrinter = new DropDownList();
                                DropDownListChartCopyPrinter.ID = "DropDownListChartCopyPrinter" + rowIndex;
                                DropDownListChartCopyPrinter.Width = new Unit(130, UnitType.Pixel);
                                if (dataViewPrinterDeviceLocation.Count > 0)
                                {
                                    DropDownListChartCopyPrinter.DataSource = dataViewPrinterDeviceLocation;
                                    DropDownListChartCopyPrinter.DataTextField = "DeviceLabel";
                                    DropDownListChartCopyPrinter.DataValueField = "PrinterDeviceLocationId";
                                    DropDownListChartCopyPrinter.DataBind();
                                }
                                DropDownListChartCopyPrinter.Items.Insert(0, new ListItem("", ""));
                                string chartCopyPrinterDevice = string.Empty;
                                if (dataRowStaffLocations.Length > 0)
                                {
                                    if (dataRowStaffLocations[0]["ChartCopyPrinterDeviceLocationId"] != DBNull.Value)
                                    {
                                        chartCopyPrinterDevice = Convert.ToString(dataRowStaffLocations[0]["ChartCopyPrinterDeviceLocationId"].ToString());
                                    }
                                }

                                //printerDevice = dataRowStaffLocations[0]["PrinterDeviceLocationId"] == DBNull.Value ? "0" : Convert.ToString(dataRowStaffLocations[0]["PrinterDeviceLocationId"].ToString());
                                if (chartCopyPrinterDevice != string.Empty)
                                {
                                    if (DropDownListChartCopyPrinter.Items.FindByValue(chartCopyPrinterDevice) != null)
                                    {
                                        DropDownListChartCopyPrinter.SelectedValue = chartCopyPrinterDevice;
                                    }
                                }
                                DropDownListChartCopyPrinter.Attributes.Add("onchange", "SetChartCopyPrinterDeviceLocation('" + DropDownListChartCopyPrinter.ClientID + "'," + locationId + ");");
                                tableCellDropDownListCharCopy.Controls.Add(DropDownListChartCopyPrinter);
                                //Code end over here.

                                //------
                               // TableCell tableCellBlank = new TableCell();
                              //  tableCellBlank.Width = new Unit(10, UnitType.Pixel);
                                //----
                                tableRow.Cells.Add(tableCellAssigned);
                                tableRow.Cells.Add(tableCellLocationName);
                                //                                tableRow.Cells.Add(tableCellAssigned);
                                tableRow.Cells.Add(tableCellDefault);
                                tableRow.Cells.Add(tableCellDropDownList);
                                //Code added by Loveena in ref to Task#86
                                tableRow.Cells.Add(tableCellDropDownListCharCopy);
                              //  tableRow.Controls.Add(tableCellBlank);
                                rowStyle = rowStyle == "GridViewRowStyle" ? "GridViewAlternatingRowStyle" : "GridViewRowStyle";
                                tableRow.CssClass = rowStyle;

                                tableUserLocationList.Rows.Add(tableRow);

                                // TableRow trLine = new TableRow();
                                // TableCell tdHorizontalLine = new TableCell();
                                // tdHorizontalLine.ColumnSpan = 4;
                                // tdHorizontalLine.CssClass = "blackLine";
                                //  trLine.Cells.Add(tdHorizontalLine);
                                //  tableUserLocationList.Rows.Add(trLine);

                                if (!checkBoxAssigned.Checked)
                                {

                                    //checkBoxDefault.Attributes.Add("disabled", "disabled");

                                    ScriptManager.RegisterStartupScript(checkBoxDefault, checkBoxDefault.GetType(), checkBoxDefault.ClientID, "DisableDefaultCheckboxs('" + checkBoxDefault.ClientID + "');", true);
                                }

                            }
                        }
                        else
                        {
                            tableLocation.Style.Add("display", "none");
                        }
                    }
                    else
                    {
                        //tableLocation.Style.Add("display", "none");
                    }
                    // myscript += "}catch(e){  Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);}}</script>";

                }

                //Page.RegisterClientScriptBlock(this.ClientID, myscript);



            }
            catch (Exception ex)
            {
            }
        }
        #endregion

        private void CreateLocationsLabelRow()
        {

            try
            {
                CommonFunctions.Event_Trap(this);
                Table _Table = new Table();
                _Table.Width = new Unit(100, UnitType.Percentage);
                TableRow _TableRow = new TableRow();
                TableCell _TableCell0 = new TableHeaderCell();
                TableCell _TableCell1 = new TableHeaderCell();
                TableCell _TableCell2 = new TableHeaderCell();
                TableCell _TableCell3 = new TableHeaderCell();
                TableCell _TableCell4 = new TableHeaderCell();
                #region--Code Added by Pradeep as per task#3315

                #endregion
                _Table.ID = "Table";

                Label labelLocationName = new Label();
                labelLocationName.ID = "LocationName";
                labelLocationName.Height = 20;
                labelLocationName.Visible = true;
                labelLocationName.Text = "Location Name";
                #region--Code Added by Pradeep as per task#3315

                labelLocationName.Style.Add("align", "left");
                #endregion

                Label labelDefault = new Label();
                labelDefault.ID = "Default";
                labelDefault.Height = 20;
                labelDefault.Visible = true;
                labelDefault.Text = "Default";

                Label labelScriptPrinter = new Label();
                labelScriptPrinter.ID = "ScriptPrinter";
                labelScriptPrinter.Height = 20;
                labelScriptPrinter.Visible = true;
                labelScriptPrinter.Text = "ScriptPrinter";

                Label labelChartcopyPrinter = new Label();
                labelChartcopyPrinter.ID = "ChartCopyPrinter";
                labelChartcopyPrinter.Height = 20;
                labelChartcopyPrinter.Visible = true;
                labelChartcopyPrinter.Text = "Chart Copy Printer";

                _TableCell0.Width = new Unit(2, UnitType.Percentage);
                _TableCell1.Controls.Add(labelLocationName);
                _TableCell1.Width = new Unit(63, UnitType.Percentage);
                _TableCell2.Controls.Add(labelDefault);
                _TableCell2.Width = new Unit(5, UnitType.Percentage);
                _TableCell3.Controls.Add(labelScriptPrinter);
                _TableCell3.Width = new Unit(15, UnitType.Percentage);
                _TableCell4.Controls.Add(labelChartcopyPrinter);
                _TableCell4.Width = new Unit(15, UnitType.Percentage);

                _TableRow.Controls.Add(_TableCell0);
                _TableRow.Controls.Add(_TableCell1);
                _TableRow.Controls.Add(_TableCell2);
                _TableRow.Controls.Add(_TableCell3);
                _TableRow.Controls.Add(_TableCell4);
                _Table.Controls.Add(_TableRow);
               // _Table.CssClass = "LabelHeader";
                _Table.CellPadding = 0;
                _Table.CellSpacing = 0;
                PanelUserLocationList.Controls.Add(_Table);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "";
                else
                    ex.Data["CustomExceptionInformation"] = "";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = "";
                throw (ex);
            }
        }

        protected void LinkButtonLogout_Click(object sender, EventArgs e)
        {
            Response.Redirect("MedicationLogin.aspx");
        }
        #region--Code Added By Pradeep as per task#3155
        public string getUnformatedPhoneNumber(string pPhoneNumber)
        {
            try
            {
                string PhoneNumber = "";
                if (pPhoneNumber == null)
                {
                    return PhoneNumber;
                }
                if (pPhoneNumber.Trim() == "")
                {
                    return PhoneNumber;
                }
                char cOldLeft = '(';
                char cOldRight = ')';
                char cOldMinus = '-';

                char cNew = ' ';
                PhoneNumber = pPhoneNumber.Replace(cOldLeft, cNew);
                PhoneNumber = PhoneNumber.Replace(cOldRight, cNew);
                PhoneNumber = PhoneNumber.Replace(cOldMinus, cNew);

                PhoneNumber = RemoveSpacesFromString(PhoneNumber);

                return PhoneNumber;
            }
            catch (Exception ex)
            {
                // Exception Hadling
                throw (ex);
                return "";
            }
        }
        public string RemoveSpacesFromString(string pPhoneNumber)
        {
            pPhoneNumber = pPhoneNumber.Replace(" ", "");
            return pPhoneNumber;
        }
        #endregion
        #region--Code Added by Pradeep as per task#3315
        /// <summary>
        /// <Description>Used to fill ServiceLevel dropdown list with globalcode category="SURESCRIPTS" as per task#3315</Description>
        /// <Author>Pradeep</Author>
        /// <CreatedOn>15 Feb 2011</CreatedOn>
        /// </summary>
        private void FillServiceLevel()
        {
            DataSet DataSetServiceLevel = null;
            try
            {
                DataSetServiceLevel = new DataSet();
                DataSetServiceLevel = Streamline.UserBusinessServices.SharedTables.DataSetGlobalCodes.Clone();
                DataRow[] DataRowDataSetServiceLevel = Streamline.UserBusinessServices.SharedTables.DataSetGlobalCodes.Tables[0].Select("Category='SURESCRIPTSLEVEL' And ISNULL(RecordDeleted,'N')='N'", "SortOrder");
                DataSetServiceLevel.Merge(DataRowDataSetServiceLevel);
                DropDownListServiceLevel.DataSource = DataSetServiceLevel;
                DropDownListServiceLevel.DataTextField = "CodeName";
                DropDownListServiceLevel.DataValueField = "GlobalCodeID";
                DropDownListServiceLevel.DataBind();

                DropDownListServiceLevel.Items.Insert(0, new ListItem("........Select........", "0"));
                DropDownListServiceLevel.SelectedIndex = 0;
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "";
                else
                    ex.Data["CustomExceptionInformation"] = "";
                if (ex.Data["DataSetServiceLevel"] == null)
                    ex.Data["DataSetServiceLevel"] = null;
                Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);
            }
            finally
            {
                DataSetServiceLevel = null;
            }
        }
        #endregion
    }
}

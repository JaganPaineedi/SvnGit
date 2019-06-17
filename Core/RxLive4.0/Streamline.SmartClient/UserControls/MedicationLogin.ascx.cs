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
using System.Security;
using System.Linq;

public partial class UserControls_MedicationLogin : System.Web.UI.UserControl
{
    Streamline.UserBusinessServices.MedicationLogin objMedicationLogin = null;
    public static string UserName = "";
    public static string password = " ";
    int loginStatus;
    public string _logoPath=string.Empty;

    protected void Page_Load(object sender, EventArgs e)
    {
        objMedicationLogin = new Streamline.UserBusinessServices.MedicationLogin();
        try
        {
           DataSet datasetSystemConfigurationKeys = null;
            Streamline.DataService.SharedTables objSharedTables = new Streamline.DataService.SharedTables();
            datasetSystemConfigurationKeys = objSharedTables.GetSystemConfigurationKeys();
            _logoPath = objSharedTables.GetSystemConfigurationKeys("CustomLogoPath", datasetSystemConfigurationKeys.Tables[0]);
            if (_logoPath == null)
                _logoPath = "App_Themes/Includes/Images/logo.gif";

            ButtonOk.Attributes.Add("onclick", "var varValidate=Validates(); return varValidate;");
            //-----------Code Adedd by Pradeep as per task#3329 on 3 March 2011 Start over here
            Session["DataSetPrescribedClientMedications"] = null;
            //-----------Code Adedd by Pradeep as per task#3329 on 3 March 2011 End over here
            if (!IsPostBack)
            {
                
                CommonFunctions.Event_Trap(this);
                //TextBoxUsername.Text = objMedicationLogin.getLastUserName().Trim();
                TextBoxUsername.Focus();
                HiddenFieldUseName.Value = TextBoxUsername.Text;
                //TextBoxPassword.Focus();
                DivLogin.Style.Add("display", "block");
            }
        }
        catch (Exception ex)
        {
            if (ex.Data["CustomExceptionInformation"] == null)
                ex.Data["CustomExceptionInformation"] = "###Source Function Name - MedicationLogin--Page_Load(), ParameterCount -0 ###";
            else
                ex.Data["CustomExceptionInformation"] = "";
            if (ex.Data["DatasetInfo"] == null)
                ex.Data["DatasetInfo"] = null;

            Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);
        }
        finally
        {
            objMedicationLogin = null;
        }
        //Below code was added by Vithobha for Engineering Improvement Initiatives- NBL(I): #283 In Rx login page(Chrome) after entering Usernae/Password and on enter Key, Password was clearing
        Page.Form.DefaultFocus = TextBoxUsername.UniqueID;
        Page.Form.DefaultButton = ButtonLogon.UniqueID;
    }
    protected void ButtonLogon_Click(object sender, EventArgs e)
    {
        objMedicationLogin = new Streamline.UserBusinessServices.MedicationLogin();
        //Optimization Added by Sony
        DataSet ds = null;
        DataSet userAuthenticationType = null;
        string authType = string.Empty;
        string enableADAuthentication = string.Empty;
        bool isValidUser = false;
        try
        {
            if (TextBoxUsername.Text.Trim() == string.Empty || TextBoxPassword.Text.Trim() == string.Empty)
            {
                this.LabelError.Text = "Please enter Username/Password";
                return;
            }
            try
            {
                userAuthenticationType = objMedicationLogin.GetUserAuthenticationType(TextBoxUsername.Text.Trim());

                if (userAuthenticationType.Tables["Authentication"].Rows.Count > 0)
                {
                    authType = userAuthenticationType.Tables["Authentication"].Rows[0]["AuthenticationType"].ToString();
                }

                if (userAuthenticationType.Tables["EnableActiveDirectory"] != null)
                {
                    enableADAuthentication = userAuthenticationType.Tables["EnableActiveDirectory"].Rows[0]["EnableADAuthentication"].ToString();
                }

                if (enableADAuthentication.ToUpperInvariant().Equals("Y") && authType.ToUpperInvariant().Equals("A"))
                {
                    isValidUser = objMedicationLogin.ADAuthenticateUser(TextBoxUsername.Text.Trim(), TextBoxPassword.Text.Trim(),
                        userAuthenticationType.Tables["Authentication"].Rows[0]["Domain"].ToString()
                        );
                    if (isValidUser)
                    {
                        var secureADPassword = new SecureString();
                        ds = objMedicationLogin.GetAuthenticatedStaffInfo(Convert.ToInt32(userAuthenticationType.Tables["Authentication"].Rows[0]["StaffId"]), TextBoxUsername.Text.Trim());
                        TextBoxPassword.Text.ToCharArray().ToList().ForEach(secureADPassword.AppendChar);
                        Session["ADPassword"] = secureADPassword;
                    }
                }
                else
                {
                    ds = objMedicationLogin.chkServerLogin(TextBoxUsername.Text.Trim(), TextBoxPassword.Text.Trim());
                }

                if (HiddenFieldUseName.Value.Trim().ToLower() != TextBoxUsername.Text.Trim().ToLower())
                {
                    HiddenFieldLoginCount.Value = "0";
                    HiddenFieldUseName.Value = TextBoxUsername.Text;
                }
                HiddenFieldLoginCount.Value = Convert.ToString(Convert.ToInt32(HiddenFieldLoginCount.Value) + 1);
                hiddenOldPassword.Value = TextBoxPassword.Text.Trim();
            }
            catch (Exception ex)
            {
                this.LabelError.Text = "Invalid Username/Password";
                TextBoxPassword.Text = "";
                throw ex;
            }
            //Added in ref to Task#2595
            if (Convert.ToInt32(HiddenFieldLoginCount.Value) > 5)
            {
                objMedicationLogin.chkCountLogin(TextBoxUsername.Text.Trim());
                this.LabelError.Text = "Your account is disabled.Please contact system administrator.";
                TextBoxPassword.Focus();
                HiddenFieldLoginCount.Value = "";
                return;
            }
            if (ds.Tables[0].Rows.Count <= 0)
            {
                this.LabelError.Text = "Invalid Username/Password";
                TextBoxPassword.Text = "";
                return;
            }

            //if (ds.Tables[0].Rows.Count > 0)
            //    {
            //    Response.Redirect("ValidatePage.aspx?ClientId=0&StaffId=" + ds.Tables[0].Rows[0]["StaffID"].ToString());
            //    }
            else
            {
                //Added by Loveena in ref to Task#3269-2.6 User Management: When Staff Created or Updated Set AccessSmartCare flag.
                if (ds.Tables[0].Rows.Count > 0)
                {
                    if (ds.Tables[0].Rows[0][0].ToString() == "Not an authorized user")
                    {
                        this.LabelError.Text = "Not an authorized user";
                    }
                    else
                    {
                        int _logStatus = Convert.ToInt32((ds.Tables[0].Rows[0][5]).ToString());
                        // Password Expire Functionality
                        if (_logStatus == 1 || _logStatus == 2)
                        {
                            ScriptManager.RegisterStartupScript(LabelError, LabelError.GetType(), "key", "javascript:OpenChangePassword('" + TextBoxPassword.Text + "','" + TextBoxUsername.Text + "');", true);

                            if (hiddenCancelled.Value == "0")
                            {
                                ScriptManager.RegisterClientScriptBlock(LabelError, LabelError.GetType(), "key", "javascript:alert('Password changed successfully')", true);
                                TextBoxPassword.Text = hiddenOldPassword.Value;

                            }
                            if (hiddenCancelled.Value == "1")
                            {
                                ScriptManager.RegisterClientScriptBlock(LabelError, LabelError.GetType(), "key", "alert('Password changed failed')", true);
                                return;
                            }
                        }
                        else
                        {
                            //Added in ref to Task#2595
                            //Comented by Pradeep for testing needs to be uncoment later
                            //if (ds.Tables[0].Rows[0]["QuestionsAnswered"] != System.DBNull.Value)
                            //    {
                            //    this.LabelError.Text = ds.Tables[0].Rows[0]["QuestionsAnswered"].ToString();
                            //    TextBoxPassword.Focus();
                            //    }
                            //else
                            //    {
                            //Commented in ref to Task#2700   
                            Response.Redirect("ValidatePage.aspx?ClientId=0&StaffId=" + ds.Tables[0].Rows[0]["StaffID"].ToString(), false);
                            //}
                            //Added in ref to Task#2595
                            //if (ds.Tables[0].Rows[0]["QuestionsAnswered"] != System.DBNull.Value)
                            //{
                            //    //Modified by Loveena in ref to Task#2700
                            //    //this.LabelError.Text = ds.Tables[0].Rows[0]["QuestionsAnswered"].ToString();
                            //    //TextBoxPassword.Focus();
                            //    Response.Redirect("ValidatePage.aspx?ClientId=0&StaffId=" + ds.Tables[0].Rows[0]["StaffID"].ToString() + "&QuestionsAnswered=" + ds.Tables[0].Rows[0]["QuestionsAnswered"].ToString());
                            //}
                            //else
                            //{
                            //    Response.Redirect("ValidatePage.aspx?ClientId=0&StaffId=" + ds.Tables[0].Rows[0]["StaffID"].ToString() + "&QuestionsAnswered=");
                            //}
                        }
                    }
                }
            }
        }
        catch (Exception ex)
        {
            if (ex.Data["CustomExceptionInformation"] == null)
                ex.Data["CustomExceptionInformation"] = "###Source Function Name - MedicationLogin--Page_Load(), ParameterCount -0 ###";
            else
                ex.Data["CustomExceptionInformation"] = "";
            if (ex.Data["DatasetInfo"] == null)
                ex.Data["DatasetInfo"] = null;

            Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);
        }

    }

    protected void ButtonOk_Click(object sender, EventArgs e)
    {
        string strEncryptedPassword = "";
        try
        {
            Streamline.UserBusinessServices.MedicationLogin objLogIn = new Streamline.UserBusinessServices.MedicationLogin();
            strEncryptedPassword = Streamline.BaseLayer.CommonFunctions.GetEncryptedData(TextBoxNewPassword.Text);
            objLogIn.ChangePassword(TextBoxChangePasswordUserName.Text, strEncryptedPassword, loginStatus);
            ScriptManager.RegisterStartupScript(LabelConfirmPassword, LabelConfirmPassword.GetType(), "key", "SetNewValues('" + TextBoxNewPassword.Text + "');", true);
        }
        catch
        {
            ScriptManager.RegisterClientScriptBlock(lblError, lblError.GetType(), "key", "javascript:alert('Could not change Password.')", true);
        }
    }
    protected void ButtonCancel_Click(object sender, EventArgs e)
    {
        ScriptManager.RegisterStartupScript(LabelConfirmPassword, LabelConfirmPassword.GetType(), "key", "CloseWindow();", true);
    }
}

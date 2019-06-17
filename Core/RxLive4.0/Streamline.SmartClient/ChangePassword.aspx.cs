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

public partial class ChangePassword : System.Web.UI.Page
    {
    string userName, oldPassword;
    int loginStatus;
    string newPassword;
    int cancelled;    
    public int IsCancelled
        {
        get
            {
            return cancelled;
            }
        }
    public string NewPassword
        {
        get
            {
            return newPassword;
            }
        }
    private bool Validates()
        {
        ShowHideError(false, "");
        if (TextBoxUserName.Text.Trim() == "")
            {
            ShowHideError(true, "Please enter User Name");
            return false;
            }
        if (TextBoxOldPassword.Text.Trim() != Request["oldPassword"].ToString().Trim())
            {
            ShowHideError(true, "Old password do not match");
            return false;
            }
        if (TextBoxNewPassword.Text.Trim() == "")
            {
            ShowHideError(true, "Please enter New password");
            return false;
            }
        if (TextBoxConfirmPassword.Text.Trim() == "")
            {
            ShowHideError(true, "Please enter Confirm Password");
            return false;
            }
        if (TextBoxNewPassword.Text.Trim() == Request["oldPassword"].ToString().Trim())
            {
            ShowHideError(true, "New password should be different than old password");
            return false;
            }
        if (TextBoxNewPassword.Text != TextBoxConfirmPassword.Text)
            {
            ShowHideError(true, "New password and Confirm Password do not match");
            return false;
            }
        return true;
        }

    protected void Page_Load(object sender, EventArgs e)
        {
        TextBoxUserName.Text = Request["UserName"].ToString();
        TextBoxOldPassword.Focus();
        }
    private void ShowHideError(bool show, string msg)
        {
        //        imgError.Visible = show;
        lblError.Visible = show;
        lblError.Text = msg;
        }
    protected void ButtonOk_Click(object sender, EventArgs e)
        {
        string strEncryptedPassword = "";
        try
            {
            if (!Validates())
                return;
            Streamline.UserBusinessServices.MedicationLogin objLogIn = new Streamline.UserBusinessServices.MedicationLogin();
            strEncryptedPassword = Streamline.BaseLayer.CommonFunctions.GetEncryptedData(TextBoxNewPassword.Text);
            objLogIn.ChangePassword(TextBoxUserName.Text, strEncryptedPassword, loginStatus);
            cancelled = 0;
            newPassword = TextBoxNewPassword.Text;            
            ScriptManager.RegisterStartupScript(LabelConfirmPassword, LabelConfirmPassword.GetType(), "key", "SetNewValues('" + cancelled + "','" + newPassword + "');", true);
            }       
        catch
            {
            cancelled = 2;
            ScriptManager.RegisterClientScriptBlock(lblError, lblError.GetType(), "key", "javascript:alert('Could not change Password.')", true);            
            }
        }
    protected void ButtonCancel_Click(object sender, EventArgs e)
        {
        cancelled = 1;
        ScriptManager.RegisterStartupScript(LabelConfirmPassword, LabelConfirmPassword.GetType(), "key", "CloseWindow();", true);
        }
    }

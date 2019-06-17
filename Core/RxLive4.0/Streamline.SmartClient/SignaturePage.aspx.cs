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
using System.Runtime.InteropServices;
using System.Text;
using System.Security;

public partial class SignaturePage : Streamline.BaseLayer.ActivityPages.ActivityPage
{
    protected override void Page_Load(object sender, EventArgs e)
    {
        DataSet ds = null;
        Streamline.UserBusinessServices.MedicationLogin objMedicationLogin = new Streamline.UserBusinessServices.MedicationLogin();
        try
        {
            clearBrowserCache();
            if (!IsPostBack)
            {

                // Check if the Staff folder is created or not
                if (!System.IO.Directory.Exists(Server.MapPath("RDLC\\" + Context.User.Identity.Name) + "\\"))
                    System.IO.Directory.CreateDirectory(Server.MapPath("RDLC\\" + Context.User.Identity.Name) + "\\");

                RadioPassword.Checked = true;
                RadioPassword.Attributes.Add("onclick", "onRadioPasswordChange();");
                RadioSignaturePad.Attributes.Add("onclick", "onRadioSignatureMouseTouchPadChange();");
                RadioCanvasSignature.Attributes.Add("onclick", "onRadioSignatureMouseTouchPadChange();");
                CheckBoxSignedPaperDocument.Attributes.Add("onclick", "onCheckBoxSignedPaperDocumentChange();");
                HiddenFiledApplicationPath.Value = Server.MapPath("RDLC\\" + Context.User.Identity.Name);

                ButtonSign.Attributes.Add("onclick", "UpdateDocuments('', 'False');");
                
                TextBoxPassword.Attributes.Add("onkeydown",
                                                   CommonFunctions.ReturnJSForClickEvent(ButtonSign.UniqueID));
                CheckBoxSignedPaperDocument.Attributes.Add("onkeydown",
                                                           CommonFunctions.ReturnJSForClickEvent(ButtonSign.UniqueID));
                RadioSignaturePad.Attributes.Add("onkeydown",
                                                 CommonFunctions.ReturnJSForClickEvent(ButtonSign.UniqueID));
                TextBoxPassword.Focus();
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
            Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General,
                                                         LogManager.LoggingLevel.Error, this);
        }
    }

    public static void clearBrowserCache()
    {
        try
        {
            HttpContext.Current.Response.AddHeader("Pragma", "no-cache");

            HttpContext.Current.Response.AddHeader("Cache-Control", "no-cache");

            HttpContext.Current.Response.CacheControl = "no-cache";

            HttpContext.Current.Response.Expires = -1;

            HttpContext.Current.Response.ExpiresAbsolute = new DateTime(1900, 1, 1);

            HttpContext.Current.Response.Cache.SetCacheability(HttpCacheability.NoCache);
        }
        catch (Exception ex)
        {

            throw (ex);
        }
    }

    public bool StaffUseSignaturePad
    {
        get
        {
            return GetStaffUseSignaturePad();
        }
    }

    private bool GetStaffUseSignaturePad()
    {
        bool _flag = false;
        string canSignUsingSignaturePad = ((Streamline.BaseLayer.StreamlineIdentity)Context.User.Identity).CanSignUsingSignaturePad;
        if (canSignUsingSignaturePad != string.Empty && canSignUsingSignaturePad.ToUpper() == "N")
        {
            _flag = true;
        }
        return _flag;
    }
    
    public string UseSignaturePad
    {
        get
        {
            return GetUseSignaturePadValue();
        }
    }

    private string GetUseSignaturePadValue()
    {
       Streamline.DataService.SharedTables objSharedTables1 = new Streamline.DataService.SharedTables();
        string useSignaturePad = string.Empty;
        if (Streamline.UserBusinessServices.SharedTables.DataSetSystemConfigurationKeys != null)
        {
            if (Streamline.UserBusinessServices.SharedTables.DataSetSystemConfigurationKeys.Tables.Count > 0)
            {
                useSignaturePad = objSharedTables1.GetSystemConfigurationKeys("UseSignaturePad", Streamline.UserBusinessServices.SharedTables.DataSetSystemConfigurationKeys.Tables[0]);
                if (useSignaturePad != "N")
                {
                    useSignaturePad = string.Empty;
                }
            }
        }
        return useSignaturePad;
    }


    public string UseHTML5Signature
    {
        get
        {
            return GetUseHTML5SignatureValue();
        }
    }

    private string GetUseHTML5SignatureValue()
    {
        Streamline.DataService.SharedTables objSharedTables2 = new Streamline.DataService.SharedTables();
        string UseHTML5Signature = "N";
        if (Streamline.UserBusinessServices.SharedTables.DataSetSystemConfigurationKeys != null)
        {
            if (Streamline.UserBusinessServices.SharedTables.DataSetSystemConfigurationKeys.Tables.Count > 0)
            {
                UseHTML5Signature = objSharedTables2.GetSystemConfigurationKeys("UseHTML5Signature", Streamline.UserBusinessServices.SharedTables.DataSetSystemConfigurationKeys.Tables[0]);
                if (UseHTML5Signature == "")
                {
                   UseHTML5Signature = "N";
                }

            }
        }
        return UseHTML5Signature;
    }

    public string InstallSigPadDriverPrompt
    {
        get
        {
            return GetInstallSigPadDriverPromptValue();
        }
    }

    private string GetInstallSigPadDriverPromptValue()
    {
        Streamline.DataService.SharedTables objSharedTables = new Streamline.DataService.SharedTables();
        string InstallSigPadDriverPrompt = "Y";
        if (Streamline.UserBusinessServices.SharedTables.DataSetSystemConfigurationKeys != null)
        {
            if (Streamline.UserBusinessServices.SharedTables.DataSetSystemConfigurationKeys.Tables.Count > 0)
            {
                InstallSigPadDriverPrompt = objSharedTables.GetSystemConfigurationKeys("InstallSigPadDriverPrompt", Streamline.UserBusinessServices.SharedTables.DataSetSystemConfigurationKeys.Tables[0]);

                if (InstallSigPadDriverPrompt == "")
                {
                    InstallSigPadDriverPrompt = "Y";
                }
            }
        }
        return InstallSigPadDriverPrompt;
    }

   

    


}

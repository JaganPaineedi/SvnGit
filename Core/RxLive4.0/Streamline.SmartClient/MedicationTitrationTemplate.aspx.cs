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

public partial class MedicationTitrationTemplate : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            if (Request.QueryString["MedicationName"] != null && Request.QueryString["MedicationName"] != "" && Request.QueryString["CreatedBy"] != null && Request.QueryString["CreatedBy"] != "")
            {
                TextBoxTempalteName.Text = Convert.ToString(((Request.QueryString["MedicationName"]) + " " + (Request.QueryString["CreatedBy"]))).Trim().ToLower();
                HiddenFieldMedicationNameId.Value = Convert.ToString(Request.QueryString["MedicationNameId"]).Trim();
                //HiddenFieldTemplateName.Value = TextBoxTempalteName.Text.Trim().ToLower();
            }
        }
        catch (Exception ex)
        {
            ex.ToString();
        }
    }
}

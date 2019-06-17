using System;
using System.Collections;
using System.Configuration;
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

public partial class AllergyComment : Streamline.BaseLayer.ActivityPages.ActivityPage
    {
        protected override void Page_Load(object sender, EventArgs e)
        {
            try
            {
                HiddenClientAllergyFilterList.Value = Request.QueryString["FilterList"] != "undefined" ? Request.QueryString["FilterList"] : "All,active";
                HiddenClientAllergyId.Value = Request.QueryString["ClientAllergyId"] != "undefined" ? Request.QueryString["ClientAllergyId"] : "";
                ClientAllergies_IsActive.Checked = Request.QueryString["Active"] != "undefined" ? Request.QueryString["Active"].ToString().ToLower().Equals("n") ? false : true : false;
                ClientAllergies_Comment.Value = Request.QueryString["Comments"] != "undefined" ? System.Uri.UnescapeDataString(Request.QueryString["Comments"].ToString()).Replace("%27", "'") : "";
                
                string allergyType = Request.QueryString["AllergyType"] != "undefined" ? Request.QueryString["AllergyType"].ToString().ToLower() : "";
                if (allergyType == "" || allergyType == "a")
                {
                    ClientAllergies_AllergyType_A.Checked = true;
                    ClientAllergies_AllergyType_F.Disabled = true;
                } 
                else if (allergyType == "i") {
                    ClientAllergies_AllergyType_I.Checked = true;
                    ClientAllergies_AllergyType_F.Disabled = true;
                }
                else if (allergyType == "f")
                {
                    ClientAllergies_AllergyType_F.Checked = true;
                    ClientAllergies_AllergyType_A.Disabled = true;
                    ClientAllergies_AllergyType_I.Disabled = true;
                }

                ClientAllergies_Comment.Focus();
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "";

                string ParseMessage = ex.Message;
                if (ParseMessage.IndexOf("System.Data.SqlClient.SqlException:") > 0)
                {
                    int SubstringLen = ParseMessage.IndexOf("\n") - ParseMessage.IndexOf("System.Data.SqlClient.SqlException:");
                    ParseMessage = ParseMessage.Substring(ParseMessage.IndexOf("System.Data.SqlClient.SqlException:") + 35, SubstringLen - 35);
                    //  ShowError(ParseMessage, true);
                }
                Streamline.BaseLayer.LogManager.LogException(ex, LogManager.LoggingCategory.General, LogManager.LoggingLevel.Error, this);
            }
        }
    }


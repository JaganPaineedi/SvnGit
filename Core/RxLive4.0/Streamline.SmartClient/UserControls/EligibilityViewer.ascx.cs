using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using System.Xml.Xsl;

public partial class UserControls_EligibilityViewer : System.Web.UI.UserControl
{
    private string eligibilityResponse = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!String.IsNullOrEmpty(eligibilityResponse))
        {
            XslCompiledTransform xsltProc = new XslCompiledTransform();
            xsltProc.Load(Server.MapPath("App_Themes/Includes/Style/Eligibility.xslt"));
            using (StringReader sr = new StringReader(eligibilityResponse))
            {
                using (XmlReader xr = XmlReader.Create(sr))
                {
                    using (StringWriter sw = new StringWriter())
                    {
                        xsltProc.Transform(xr, null, sw);
                        string markup = sw.ToString();
                        EligilityViewDiv.Controls.Add(Page.ParseControl(markup));
                    }
                }
            }
        }
        else
        {
            Label missingResponse = new Label();
            missingResponse.Text = "Missing an Eligibility document";
            EligilityViewDiv.Controls.Add(missingResponse);
        }
    }

    public string EligibilityResponse { set { eligibilityResponse = value; } }

}
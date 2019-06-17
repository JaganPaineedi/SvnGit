using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using System.Xml.Xsl;

public partial class UserControls_MedicationHistoryViewer : System.Web.UI.UserControl
{
    private string medHistoryResponse = "";
    private string eligibilityResponse = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        string markupElig = "";
        string markup = "";
        XslCompiledTransform xsltProc = new XslCompiledTransform();

        if (!String.IsNullOrEmpty(medHistoryResponse))
        {
            if (!String.IsNullOrEmpty(eligibilityResponse))
            {
                xsltProc = new XslCompiledTransform();
                xsltProc.Load(Server.MapPath("App_Themes/Includes/Style/EligibilityDemographics.xslt"));
                using (StringReader sr = new StringReader(eligibilityResponse))
                {
                    using (XmlReader xr = XmlReader.Create(sr))
                    {
                        using (StringWriter sw = new StringWriter())
                        {
                            xsltProc.Transform(xr, null, sw);
                            markupElig = sw.ToString();
                        }
                    }
                }
            }


            
            xsltProc = new XslCompiledTransform();
            xsltProc.Load(Server.MapPath("App_Themes/Includes/Style/MedicationHistory.xslt"));
            using (StringReader sr = new StringReader(medHistoryResponse))
            {
                using (XmlReader xr = XmlReader.Create(sr))
                {
                    using (StringWriter sw = new StringWriter())
                    {
                        xsltProc.Transform(xr, null, sw);
                        markup = sw.ToString();
                        MedicationHistoryViewDiv.Controls.Add(Page.ParseControl(markupElig + "<br />" + markup));
                    }
                }
            }
        }
        else
        {
            Label missingResponse = new Label();
            missingResponse.Text = "Missing a Medication History document";
            MedicationHistoryViewDiv.Controls.Add(missingResponse);
        }
    }

    public string MedHistoryResponse { set { medHistoryResponse = value; } }
    public string EligibilityResponse { set { eligibilityResponse = value; } }
}
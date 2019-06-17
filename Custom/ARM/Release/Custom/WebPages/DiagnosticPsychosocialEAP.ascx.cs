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

public partial class ActivityPages_Harbor_Client_Detail_Documents_DiagnosticAssessment_DiagnosticPsychosocialEAP : SHS.BaseLayer.ActivityPages.DataActivityTab
{
    /// <summary>
    /// <Description>This overridable function inherited from DataActivityTab is used to bind controls</Description>
    /// <Author>Jagdeep Hundal</Author>
    /// <CreatedOn>09 June 2011</CreatedOn>
    /// </summary>

    public override void BindControls()
    {
        try
        {
            DynamicFormsDiagnosticPsychosocialEAP.FormId = 70;
            DynamicFormsDiagnosticPsychosocialEAP.Activate();
        }
        finally
        {
        }
    }
}

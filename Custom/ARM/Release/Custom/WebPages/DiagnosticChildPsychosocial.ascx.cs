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

public partial class ActivityPages_Harbor_Client_Detail_Documents_DiagnosticAssessment_DiagnosticChildPsychosocial : SHS.BaseLayer.ActivityPages.DataActivityTab
{
    /// <summary>
    /// <Description>This overridable function inherited from DataActivityTab is used to bind controls</Description>
    /// <Author>Ashwani</Author>
    /// <CreatedOn>02 june 2011</CreatedOn>
    /// </summary>
    public override void BindControls()
    {
        try
        {
            DynamicFormsDiagnosticChildPsychosocial.FormId = 55;
            DynamicFormsDiagnosticChildPsychosocial.Activate();
        }
        finally
        {
        }
    }
}

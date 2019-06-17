using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class ActivityPages_Harbor_Client_Detail_Documents_DiagnosticAssessment_DiagnosticPsychosocial : SHS.BaseLayer.ActivityPages.DataActivityTab
{
    /// <summary>
    /// <Description>This overridable function inherited from DataActivityTab is used to bind controls</Description>
    /// <Author>Jagdeep Hundal</Author>
    /// <CreatedOn>01 June 2011</CreatedOn>
    /// </summary>

    public override void BindControls()
    {
        try
        {
            DynamicFormsDiagnosticPsychosocial.FormId = 56;
            DynamicFormsDiagnosticPsychosocial.Activate();
        }
        finally
        {
        }
    }
}

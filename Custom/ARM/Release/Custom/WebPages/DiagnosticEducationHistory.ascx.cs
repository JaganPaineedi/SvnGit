using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class ActivityPages_Harbor_Client_Detail_Documents_DiagnosticAssessment_DiagnosticEducationHistory : SHS.BaseLayer.ActivityPages.DataActivityTab
{
    /// <summary>
    /// <Description>This overridable function inherited from DataActivityTab is used to bind controls</Description>
    /// <Author>Jagdeep Hundal</Author>
    /// <CreatedOn>06 June 2011</CreatedOn>
    /// </summary>

    public override void BindControls()
    {
        try
        {
            DynamicFormsDiagnosticEducationHistory.FormId = 62;
            DynamicFormsDiagnosticEducationHistory.Activate();
        }
        finally
        {
        }
    }
}

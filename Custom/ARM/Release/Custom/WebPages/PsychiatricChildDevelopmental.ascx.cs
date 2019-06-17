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

public partial class ActivityPages_Harbor_Client_Detail_Documents_PsychiatricEvaluation_PsychiatricChildDevelopmental : SHS.BaseLayer.ActivityPages.DataActivityTab
{
    /// <summary>
    /// <Description>This overridable function inherited from DataActivityTab is used to bind controls</Description>
    /// <Author>Jagdeep Hundal</Author>
    /// <CreatedOn>07 July 2011</CreatedOn>
    /// </summary>

    public override void BindControls()
    {
        try
        {
            DynamicFormsPsychiatricEvaluationChildDevelopmental.FormId = 77;
            DynamicFormsPsychiatricEvaluationChildDevelopmental.Activate();
        }
        finally
        {
        }
    }
    public override string[] TablesUsedInTab
    {
        get
        {
            return new string[] { "CustomDocumentPsychiatricEvaluations" };
        }
    }
}

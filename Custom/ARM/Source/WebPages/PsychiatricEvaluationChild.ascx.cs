using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class ActivityPages_Harbor_Client_Detail_Documents_PsychiatricEvaluation_PsychiatricEvaluationChild : SHS.BaseLayer.ActivityPages.DataActivityTab
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    public override void BindControls()
    {
        DynamicFormsPhsychatricEvaluationChild.FormId = 76;
        DynamicFormsPhsychatricEvaluationChild.Activate();
    }
    public override string[] TablesUsedInTab
    {
        get
        {
            return new string[] { "CustomDocumentPsychiatricEvaluations" };
        }
    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Custom_PsychiatricService_WebPages_PsychiatricServiceExam : SHS.BaseLayer.ActivityPages.DataActivityTab
{
    public override string[] TablesUsedInTab
    {
        get
        {
            return new string[] { "CustomDocumentPsychiatricServiceNoteExams" };
        }

    }
    public override void BindControls()
    {        
    }
}
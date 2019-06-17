using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SHS.SmartCare
{
    public partial class Custom_PsychiatricService_WebPages_PsychiatricServiceHistory : SHS.BaseLayer.ActivityPages.DataActivityTab
    {
        public override void BindControls()
        {
            DropDownList_CustomPsychiatricServiceNoteProblems_s8s2s3s_Severity.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
            DropDownList_CustomPsychiatricServiceNoteProblems_s8s2s3s_Severity.FillDropDownDropGlobalCodes();

            DropDownList_CustomPsychiatricServiceNoteProblems_s8s2s3s_Intensity.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
            DropDownList_CustomPsychiatricServiceNoteProblems_s8s2s3s_Intensity.FillDropDownDropGlobalCodes();

            DropDownList_CustomPsychiatricServiceNoteProblems_s8s2s3s_AssociatedSignsSymptoms.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
            DropDownList_CustomPsychiatricServiceNoteProblems_s8s2s3s_AssociatedSignsSymptoms.FillDropDownDropGlobalCodes();
        }
    }
}
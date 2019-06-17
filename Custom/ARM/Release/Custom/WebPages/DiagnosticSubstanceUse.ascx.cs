using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

public partial class ActivityPages_Harbor_Client_Detail_Documents_DiagnosticAssessment_DiagnosticSubstanceUse : SHS.BaseLayer.ActivityPages.DataActivityTab
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    public override void BindControls()
    {
        DataTable dataTableSubstanceUse = null;
        try
        {
            dataTableSubstanceUse = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
            DropDownList_CustomDocumentDiagnosticAssessments_AlcoholUseCurrentFrequency.DataTableGlobalCodes = dataTableSubstanceUse;
            DropDownList_CustomDocumentDiagnosticAssessments_AlcoholUseCurrentFrequency.FillDropDownDropGlobalCodes();
            
            DropDownList_CustomDocumentDiagnosticAssessments_AlcoholUsePastFrequency.DataTableGlobalCodes = dataTableSubstanceUse;
            DropDownList_CustomDocumentDiagnosticAssessments_AlcoholUsePastFrequency.FillDropDownDropGlobalCodes();
            
            DropDownList_CustomDocumentDiagnosticAssessments_CocaineUseCurrentFrequency.DataTableGlobalCodes = dataTableSubstanceUse;
            DropDownList_CustomDocumentDiagnosticAssessments_CocaineUseCurrentFrequency.FillDropDownDropGlobalCodes();
            
            DropDownList_CustomDocumentDiagnosticAssessments_CocaineUsePastFrequency.DataTableGlobalCodes = dataTableSubstanceUse;
            DropDownList_CustomDocumentDiagnosticAssessments_CocaineUsePastFrequency.FillDropDownDropGlobalCodes();
            
            DropDownList_CustomDocumentDiagnosticAssessments_SedtativeUseCurrentFrequency.DataTableGlobalCodes = dataTableSubstanceUse;
            DropDownList_CustomDocumentDiagnosticAssessments_SedtativeUseCurrentFrequency.FillDropDownDropGlobalCodes();
            
            DropDownList_CustomDocumentDiagnosticAssessments_SedtativeUsePastFrequency.DataTableGlobalCodes = dataTableSubstanceUse;
            DropDownList_CustomDocumentDiagnosticAssessments_SedtativeUsePastFrequency.FillDropDownDropGlobalCodes();
            
            DropDownList_CustomDocumentDiagnosticAssessments_HallucinogenUseCurrentFrequency.DataTableGlobalCodes = dataTableSubstanceUse;
            DropDownList_CustomDocumentDiagnosticAssessments_HallucinogenUseCurrentFrequency.FillDropDownDropGlobalCodes();
            
            DropDownList_CustomDocumentDiagnosticAssessments_HallucinogenUsePastFrequency.DataTableGlobalCodes = dataTableSubstanceUse;
            DropDownList_CustomDocumentDiagnosticAssessments_HallucinogenUsePastFrequency.FillDropDownDropGlobalCodes();
            
            DropDownList_CustomDocumentDiagnosticAssessments_StimulantUseCurrentFrequency.DataTableGlobalCodes = dataTableSubstanceUse;
            DropDownList_CustomDocumentDiagnosticAssessments_StimulantUseCurrentFrequency.FillDropDownDropGlobalCodes();

            DropDownList_CustomDocumentDiagnosticAssessments_StimulantUsePastFrequency.DataTableGlobalCodes = dataTableSubstanceUse;
            DropDownList_CustomDocumentDiagnosticAssessments_StimulantUsePastFrequency.FillDropDownDropGlobalCodes();
            
            DropDownList_CustomDocumentDiagnosticAssessments_NarcoticUseCurrentFrequency.DataTableGlobalCodes = dataTableSubstanceUse;
            DropDownList_CustomDocumentDiagnosticAssessments_NarcoticUseCurrentFrequency.FillDropDownDropGlobalCodes();
            
            DropDownList_CustomDocumentDiagnosticAssessments_NarcoticUsePastFrequency.DataTableGlobalCodes = dataTableSubstanceUse;
            DropDownList_CustomDocumentDiagnosticAssessments_NarcoticUsePastFrequency.FillDropDownDropGlobalCodes();
            
            DropDownList_CustomDocumentDiagnosticAssessments_MarijuanaUseCurrentFrequency.DataTableGlobalCodes = dataTableSubstanceUse;
            DropDownList_CustomDocumentDiagnosticAssessments_MarijuanaUseCurrentFrequency.FillDropDownDropGlobalCodes();
            
            DropDownList_CustomDocumentDiagnosticAssessments_MarijuanaUsePastFrequency.DataTableGlobalCodes = dataTableSubstanceUse;
            DropDownList_CustomDocumentDiagnosticAssessments_MarijuanaUsePastFrequency.FillDropDownDropGlobalCodes();
            
            DropDownList_CustomDocumentDiagnosticAssessments_InhalantsUseCurrentFrequency.DataTableGlobalCodes = dataTableSubstanceUse;
            DropDownList_CustomDocumentDiagnosticAssessments_InhalantsUseCurrentFrequency.FillDropDownDropGlobalCodes();
            
            DropDownList_CustomDocumentDiagnosticAssessments_InhalantsUsePastFrequency.DataTableGlobalCodes = dataTableSubstanceUse;
            DropDownList_CustomDocumentDiagnosticAssessments_InhalantsUsePastFrequency.FillDropDownDropGlobalCodes();
            
            DropDownList_CustomDocumentDiagnosticAssessments_OtherUseCurrentFrequency.DataTableGlobalCodes = dataTableSubstanceUse;
            DropDownList_CustomDocumentDiagnosticAssessments_OtherUseCurrentFrequency.FillDropDownDropGlobalCodes();
            
            DropDownList_CustomDocumentDiagnosticAssessments_OtherUsePastFrequency.DataTableGlobalCodes = dataTableSubstanceUse;
            DropDownList_CustomDocumentDiagnosticAssessments_OtherUsePastFrequency.FillDropDownDropGlobalCodes();

        }
        finally
        {
            if (dataTableSubstanceUse != null)
            {
                dataTableSubstanceUse.Dispose();
            }
        }
    }
}

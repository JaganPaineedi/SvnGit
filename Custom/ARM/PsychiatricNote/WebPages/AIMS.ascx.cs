using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using SHS.BaseLayer;
using System.Web.Script.Serialization;

public partial class Custom_PsychiatricNote_WebPages_AIMS : SHS.BaseLayer.ActivityPages.DataActivityTab
{
    
    public override void BindControls()
    {
        DropDownList_CustomDocumentPsychiatricAIMSs_MuscleFacialExpression.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentPsychiatricAIMSs_MuscleFacialExpression.FillDropDownDropGlobalCodes();

        DropDownList_CustomDocumentPsychiatricAIMSs_LipsPerioralArea.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentPsychiatricAIMSs_LipsPerioralArea.FillDropDownDropGlobalCodes();

         DropDownList_CustomDocumentPsychiatricAIMSs_PatientAwarenessAbnormalMovements.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentPsychiatricAIMSs_PatientAwarenessAbnormalMovements.FillDropDownDropGlobalCodes();

        DropDownList_CustomDocumentPsychiatricAIMSs_IncapacitationAbnormalMovements.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentPsychiatricAIMSs_IncapacitationAbnormalMovements.FillDropDownDropGlobalCodes();

         DropDownList_CustomDocumentPsychiatricAIMSs_SeverityAbnormalMovements.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentPsychiatricAIMSs_SeverityAbnormalMovements.FillDropDownDropGlobalCodes();

        DropDownList_CustomDocumentPsychiatricAIMSs_NeckShouldersHips.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentPsychiatricAIMSs_NeckShouldersHips.FillDropDownDropGlobalCodes();

         DropDownList_CustomDocumentPsychiatricAIMSs_ExtremityMovementsLower.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentPsychiatricAIMSs_ExtremityMovementsLower.FillDropDownDropGlobalCodes();

          DropDownList_CustomDocumentPsychiatricAIMSs_ExtremityMovementsUpper.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentPsychiatricAIMSs_ExtremityMovementsUpper.FillDropDownDropGlobalCodes();

         DropDownList_CustomDocumentPsychiatricAIMSs_Tongue.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentPsychiatricAIMSs_Tongue.FillDropDownDropGlobalCodes();

        DropDownList_CustomDocumentPsychiatricAIMSs_Jaw.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentPsychiatricAIMSs_Jaw.FillDropDownDropGlobalCodes();

        DropDownList_CustomDocumentPsychiatricAIMSs_LipsPerioralArea.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentPsychiatricAIMSs_LipsPerioralArea.FillDropDownDropGlobalCodes();
        /*---------Previous -----------------*/

        DropDownList_CustomDocumentPsychiatricAIMSs_PreviousMuscleFacialExpression.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentPsychiatricAIMSs_PreviousMuscleFacialExpression.FillDropDownDropGlobalCodes();

        DropDownList_CustomDocumentPsychiatricAIMSs_PreviousLipsPerioralArea.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentPsychiatricAIMSs_PreviousLipsPerioralArea.FillDropDownDropGlobalCodes();

        DropDownList_CustomDocumentPsychiatricAIMSs_PreviousPatientAwarenessAbnormalMovements.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentPsychiatricAIMSs_PreviousPatientAwarenessAbnormalMovements.FillDropDownDropGlobalCodes();

        DropDownList_CustomDocumentPsychiatricAIMSs_PreviousIncapacitationAbnormalMovements.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentPsychiatricAIMSs_PreviousIncapacitationAbnormalMovements.FillDropDownDropGlobalCodes();

        DropDownList_CustomDocumentPsychiatricAIMSs_PreviousSeverityAbnormalMovements.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentPsychiatricAIMSs_PreviousSeverityAbnormalMovements.FillDropDownDropGlobalCodes();

        DropDownList_CustomDocumentPsychiatricAIMSs_PreviousNeckShouldersHips.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentPsychiatricAIMSs_PreviousNeckShouldersHips.FillDropDownDropGlobalCodes();

        DropDownList_CustomDocumentPsychiatricAIMSs_PreviousExtremityMovementsLower.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentPsychiatricAIMSs_PreviousExtremityMovementsLower.FillDropDownDropGlobalCodes();

        DropDownList_CustomDocumentPsychiatricAIMSs_PreviousExtremityMovementsUpper.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentPsychiatricAIMSs_PreviousExtremityMovementsUpper.FillDropDownDropGlobalCodes();

        DropDownList_CustomDocumentPsychiatricAIMSs_PreviousTongue.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentPsychiatricAIMSs_PreviousTongue.FillDropDownDropGlobalCodes();

        DropDownList_CustomDocumentPsychiatricAIMSs_PreviousJaw.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentPsychiatricAIMSs_PreviousJaw.FillDropDownDropGlobalCodes();

        DropDownList_CustomDocumentPsychiatricAIMSs_PreviousLipsPerioralArea.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentPsychiatricAIMSs_PreviousLipsPerioralArea.FillDropDownDropGlobalCodes();

        var xAIMSMovements = (from p in SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes.Select("Category='xAIMSMovements' AND Code='0'").AsEnumerable()
                              select new
                              {
                                  GlobalCodeId = p.Field<int>("GlobalCodeId"),
                                  CodeName = p.Field<string>("CodeName")
                              }).ToList();
        var pajsonSerialiser = new JavaScriptSerializer();
        var paajson = pajsonSerialiser.Serialize(xAIMSMovements);
        HiddenFieldxAIMSMovements.Value = paajson.ToString();



        var AIMSJudgments1 = (from p in SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes.Select("Category='xAIMSJudgments1' AND Code='0' ").AsEnumerable()
                              select new
                              {
                                  GlobalCodeId = p.Field<int>("GlobalCodeId"),
                                  CodeName = p.Field<string>("CodeName")
                              }).ToList();

        var pajsonSerialiser1 = new JavaScriptSerializer();
        var paajson1 = pajsonSerialiser.Serialize(AIMSJudgments1);

        HiddenFieldxAIMSJudgments1.Value = paajson1.ToString();

        var AIMSJudgments2 = (from p in SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes.Select("Category='xAIMSJudgments2' AND Code='0' ").AsEnumerable()
                              select new
                              {
                                  GlobalCodeId = p.Field<int>("GlobalCodeId"),
                                  CodeName = p.Field<string>("CodeName")
                              }).ToList();

        var pajsonSerialiser2 = new JavaScriptSerializer();
        var paajson2 = pajsonSerialiser.Serialize(AIMSJudgments2);

        HiddenFieldxAIMSJudgments2.Value = paajson2.ToString();
    
    
    }
   
}
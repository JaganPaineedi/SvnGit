using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using SHS.BaseLayer;
using SHS.DataServices;
using System.Collections.Generic;
using System.Reflection;
using System.Text;
using SHS.BaseLayer.ActivityPages;
namespace SHS.SmartCare
{
    public partial class Custom_Screenings_WebPages_BrainInjury : DataActivityTab
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        public override void BindControls()
        {
            Bind_Filter_BlowToTheHead();
            Bind_Filter_CauseAConcussion();
            Bind_Filter_ReceiveTreatmentForHeadInjury();
            Bind_Filter_PhysicalAbilities();
            Bind_Filter_Mood();
            Bind_Filter_CareForYourSelf();
            Bind_Filter_Temper();
            Bind_Filter_Speech();
            Bind_Filter_RelationshipWithOthers();
            Bind_Filter_Hearing();
            Bind_Filter_AbilityToWork();
            Bind_Filter_Memory();
            Bind_Filter_UseOfAlcohol();
            Bind_Filter_AbilityToConcentrate();
            Bind_Filter_ChangedAfterInjury();
        }

        private void Bind_Filter_BlowToTheHead()
        {
            DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_BlowToTheHead.AddBlankRow = true;
            DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_BlowToTheHead.BlankRowValue = "";
            DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_BlowToTheHead.BlankRowValue = "";
            if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes != null)
            {
                DataView dataViewPrograms = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
                dataViewPrograms.RowFilter = "Category='RADIOYNNA' and ISNULL(RecordDeleted,'N')<>'Y' and Active='Y' and GlobalCodeId <> 5352";
                dataViewPrograms.Sort = "SortOrder,CodeName";
                DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_BlowToTheHead.DataTextField = "CodeName";
                DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_BlowToTheHead.DataValueField = "GlobalCodeId";
                DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_BlowToTheHead.DataSource = dataViewPrograms;
                DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_BlowToTheHead.DataBind();
                DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_BlowToTheHead.SelectedItem.Value = "";
            }

        }
        private void Bind_Filter_CauseAConcussion()
        {
            DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_CauseAConcussion.AddBlankRow = true;
            DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_CauseAConcussion.BlankRowValue = "";
            DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_CauseAConcussion.BlankRowValue = "";
            if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes != null)
            {
                DataView dataViewPrograms = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
                dataViewPrograms.RowFilter = "Category='RADIOYNNA' and ISNULL(RecordDeleted,'N')<>'Y' and Active='Y' and GlobalCodeId <> 5352";
                dataViewPrograms.Sort = "SortOrder,CodeName";
                DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_CauseAConcussion.DataTextField = "CodeName";
                DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_CauseAConcussion.DataValueField = "GlobalCodeId";
                DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_CauseAConcussion.DataSource = dataViewPrograms;
                DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_CauseAConcussion.DataBind();
                DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_CauseAConcussion.SelectedItem.Value = "";
            }

        }
        private void Bind_Filter_ReceiveTreatmentForHeadInjury()
        {
            DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_ReceiveTreatmentForHeadInjury.AddBlankRow = true;
            DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_ReceiveTreatmentForHeadInjury.BlankRowValue = "";
            DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_ReceiveTreatmentForHeadInjury.BlankRowValue = "";
            if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes != null)
            {
                DataView dataViewPrograms = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
                dataViewPrograms.RowFilter = "Category='RADIOYNNA' and ISNULL(RecordDeleted,'N')<>'Y' and Active='Y' and GlobalCodeId <> 5352";
                dataViewPrograms.Sort = "SortOrder,CodeName";
                DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_ReceiveTreatmentForHeadInjury.DataTextField = "CodeName";
                DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_ReceiveTreatmentForHeadInjury.DataValueField = "GlobalCodeId";
                DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_ReceiveTreatmentForHeadInjury.DataSource = dataViewPrograms;
                DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_ReceiveTreatmentForHeadInjury.DataBind();
                DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_ReceiveTreatmentForHeadInjury.SelectedItem.Value = "";
            }

        }
        
        private void Bind_Filter_PhysicalAbilities()
        {
            DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_PhysicalAbilities.AddBlankRow = true;
            DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_PhysicalAbilities.BlankRowValue = "";
            DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_PhysicalAbilities.BlankRowValue = "";
            if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes != null)
            {
                DataView dataViewPrograms = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
                dataViewPrograms.RowFilter = "Category='RADIOYNNA' and ISNULL(RecordDeleted,'N')<>'Y' and Active='Y' and GlobalCodeId <> 5352";
                dataViewPrograms.Sort = "SortOrder,CodeName";
                DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_PhysicalAbilities.DataTextField = "CodeName";
                DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_PhysicalAbilities.DataValueField = "GlobalCodeId";
                DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_PhysicalAbilities.DataSource = dataViewPrograms;
                DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_PhysicalAbilities.DataBind();
                DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_PhysicalAbilities.SelectedItem.Value = "";
            }

        }
        private void Bind_Filter_Mood()
        {
            DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_Mood.AddBlankRow = true;
            DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_Mood.BlankRowValue = "";
            DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_Mood.BlankRowValue = "";
            if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes != null)
            {
                DataView dataViewPrograms = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
                dataViewPrograms.RowFilter = "Category='RADIOYNNA' and ISNULL(RecordDeleted,'N')<>'Y' and Active='Y' and GlobalCodeId <> 5352";
                dataViewPrograms.Sort = "SortOrder,CodeName";
                DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_Mood.DataTextField = "CodeName";
                DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_Mood.DataValueField = "GlobalCodeId";
                DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_Mood.DataSource = dataViewPrograms;
                DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_Mood.DataBind();
                DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_Mood.SelectedItem.Value = "";
            }

        }
        private void Bind_Filter_CareForYourSelf()
        {
            DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_CareForYourSelf.AddBlankRow = true;
            DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_CareForYourSelf.BlankRowValue = "";
            DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_CareForYourSelf.BlankRowValue = "";
            if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes != null)
            {
                DataView dataViewPrograms = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
                dataViewPrograms.RowFilter = "Category='RADIOYNNA' and ISNULL(RecordDeleted,'N')<>'Y' and Active='Y' and GlobalCodeId <> 5352";
                dataViewPrograms.Sort = "SortOrder,CodeName";
                DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_CareForYourSelf.DataTextField = "CodeName";
                DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_CareForYourSelf.DataValueField = "GlobalCodeId";
                DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_CareForYourSelf.DataSource = dataViewPrograms;
                DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_CareForYourSelf.DataBind();
                DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_CareForYourSelf.SelectedItem.Value = "";
            }

        }
        private void Bind_Filter_Speech()
        {
            DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_Speech.AddBlankRow = true;
            DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_Speech.BlankRowValue = "";
            DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_Speech.BlankRowValue = "";
            if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes != null)
            {
                DataView dataViewPrograms = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
                dataViewPrograms.RowFilter = "Category='RADIOYNNA' and ISNULL(RecordDeleted,'N')<>'Y' and Active='Y' and GlobalCodeId <> 5352";
                dataViewPrograms.Sort = "SortOrder,CodeName";
                DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_Speech.DataTextField = "CodeName";
                DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_Speech.DataValueField = "GlobalCodeId";
                DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_Speech.DataSource = dataViewPrograms;
                DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_Speech.DataBind();
                DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_Speech.SelectedItem.Value = "";
            }

        }

        private void Bind_Filter_Temper()
        {
            DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_Temper.AddBlankRow = true;
            DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_Temper.BlankRowValue = "";
            DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_Temper.BlankRowValue = "";
            if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes != null)
            {
                DataView dataViewPrograms = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
                dataViewPrograms.RowFilter = "Category='RADIOYNNA' and ISNULL(RecordDeleted,'N')<>'Y' and Active='Y' and GlobalCodeId <> 5352";
                dataViewPrograms.Sort = "SortOrder,CodeName";
                DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_Temper.DataTextField = "CodeName";
                DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_Temper.DataValueField = "GlobalCodeId";
                DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_Temper.DataSource = dataViewPrograms;
                DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_Temper.DataBind();
                DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_Temper.SelectedItem.Value = "";
            }

        }
        private void Bind_Filter_RelationshipWithOthers()
        {
            DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_RelationshipWithOthers.AddBlankRow = true;
            DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_RelationshipWithOthers.BlankRowValue = "";
            DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_RelationshipWithOthers.BlankRowValue = "";
            if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes != null)
            {
                DataView dataViewPrograms = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
                dataViewPrograms.RowFilter = "Category='RADIOYNNA' and ISNULL(RecordDeleted,'N')<>'Y' and Active='Y' and GlobalCodeId <> 5352";
                dataViewPrograms.Sort = "SortOrder,CodeName";
                DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_RelationshipWithOthers.DataTextField = "CodeName";
                DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_RelationshipWithOthers.DataValueField = "GlobalCodeId";
                DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_RelationshipWithOthers.DataSource = dataViewPrograms;
                DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_RelationshipWithOthers.DataBind();
                DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_RelationshipWithOthers.SelectedItem.Value = "";
            }

        }
        private void Bind_Filter_Hearing()
        {
            DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_Hearing.AddBlankRow = true;
            DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_Hearing.BlankRowValue = "";
            DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_Hearing.BlankRowValue = "";
            if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes != null)
            {
                DataView dataViewPrograms = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
                dataViewPrograms.RowFilter = "Category='RADIOYNNA' and ISNULL(RecordDeleted,'N')<>'Y' and Active='Y' and GlobalCodeId <> 5352";
                dataViewPrograms.Sort = "SortOrder,CodeName";
                DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_Hearing.DataTextField = "CodeName";
                DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_Hearing.DataValueField = "GlobalCodeId";
                DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_Hearing.DataSource = dataViewPrograms;
                DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_Hearing.DataBind();
                DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_Hearing.SelectedItem.Value = "";
            }

        }
        private void Bind_Filter_AbilityToWork()
        {
            DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_AbilityToWork.AddBlankRow = true;
            DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_AbilityToWork.BlankRowValue = "";
            DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_AbilityToWork.BlankRowValue = "";
            if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes != null)
            {
                DataView dataViewPrograms = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
                dataViewPrograms.RowFilter = "Category='RADIOYNNA' and ISNULL(RecordDeleted,'N')<>'Y' and Active='Y' and GlobalCodeId <> 5352";
                dataViewPrograms.Sort = "SortOrder,CodeName";
                DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_AbilityToWork.DataTextField = "CodeName";
                DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_AbilityToWork.DataValueField = "GlobalCodeId";
                DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_AbilityToWork.DataSource = dataViewPrograms;
                DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_AbilityToWork.DataBind();
                DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_AbilityToWork.SelectedItem.Value = "";
            }

        }
        private void Bind_Filter_Memory()
        {
            DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_Memory.AddBlankRow = true;
            DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_Memory.BlankRowValue = "";
            DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_Memory.BlankRowValue = "";
            if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes != null)
            {
                DataView dataViewPrograms = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
                dataViewPrograms.RowFilter = "Category='RADIOYNNA' and ISNULL(RecordDeleted,'N')<>'Y' and Active='Y' and GlobalCodeId <> 5352";
                dataViewPrograms.Sort = "SortOrder,CodeName";
                DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_Memory.DataTextField = "CodeName";
                DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_Memory.DataValueField = "GlobalCodeId";
                DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_Memory.DataSource = dataViewPrograms;
                DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_Memory.DataBind();
                DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_Memory.SelectedItem.Value = "";
            }

        }
        private void Bind_Filter_UseOfAlcohol()
        {
            DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_UseOfAlcohol.AddBlankRow = true;
            DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_UseOfAlcohol.BlankRowValue = "";
            DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_UseOfAlcohol.BlankRowValue = "";
            if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes != null)
            {
                DataView dataViewPrograms = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
                dataViewPrograms.RowFilter = "Category='RADIOYNNA' and ISNULL(RecordDeleted,'N')<>'Y' and Active='Y' and GlobalCodeId <> 5352";
                dataViewPrograms.Sort = "SortOrder,CodeName";
                DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_UseOfAlcohol.DataTextField = "CodeName";
                DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_UseOfAlcohol.DataValueField = "GlobalCodeId";
                DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_UseOfAlcohol.DataSource = dataViewPrograms;
                DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_UseOfAlcohol.DataBind();
                DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_UseOfAlcohol.SelectedItem.Value = "";
            }

        }

        private void Bind_Filter_AbilityToConcentrate()
        {
            DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_AbilityToConcentrate.AddBlankRow = true;
            DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_AbilityToConcentrate.BlankRowValue = "";
            DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_AbilityToConcentrate.BlankRowValue = "";
            if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes != null)
            {
                DataView dataViewPrograms = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
                dataViewPrograms.RowFilter = "Category='RADIOYNNA' and ISNULL(RecordDeleted,'N')<>'Y' and Active='Y' and GlobalCodeId <> 5352";
                dataViewPrograms.Sort = "SortOrder,CodeName";
                DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_AbilityToConcentrate.DataTextField = "CodeName";
                DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_AbilityToConcentrate.DataValueField = "GlobalCodeId";
                DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_AbilityToConcentrate.DataSource = dataViewPrograms;
                DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_AbilityToConcentrate.DataBind();
                DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_AbilityToConcentrate.SelectedItem.Value = "";
            }

        }
        private void Bind_Filter_ChangedAfterInjury()
        {
            DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_ChangedAfterInjury.AddBlankRow = true;
            DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_ChangedAfterInjury.BlankRowValue = "";
            DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_ChangedAfterInjury.BlankRowValue = "";
            if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes != null)
            {
                DataView dataViewPrograms = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
                dataViewPrograms.RowFilter = "Category='RADIOYNNA' and ISNULL(RecordDeleted,'N')<>'Y' and Active='Y' and GlobalCodeId <> 5352";
                dataViewPrograms.Sort = "SortOrder,CodeName";
                DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_ChangedAfterInjury.DataTextField = "CodeName";
                DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_ChangedAfterInjury.DataValueField = "GlobalCodeId";
                DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_ChangedAfterInjury.DataSource = dataViewPrograms;
                DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_ChangedAfterInjury.DataBind();
                DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_ChangedAfterInjury.SelectedItem.Value = "";
            }

        }
    }
}

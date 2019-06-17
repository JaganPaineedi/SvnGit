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

    public partial class Custom_Screenings_WebPages_MentalHealth : DataActivityTab
    {
        public override void BindControls()
        {
            Bind_Filter_Social();
            Bind_Filter_Mind();
            Bind_Filter_HearVoices();
            Bind_Filter_SpendTimeKilling();
            Bind_Filter_TriedToCommitSuicide();
            Bind_Filter_WatchYourStep();
            Bind_Filter_FeelAnxious();
            Bind_Filter_ThoughtsComeQuickly();
            Bind_Filter_DestroyedProperty();
            Bind_Filter_FeelTrapped();
            Bind_Filter_DissatifiedWithLife();
            Bind_Filter_UnPleasantThoughts();
            Bind_Filter_DifficultyInSleeping();
            Bind_Filter_PhysicallyHarmed();
            Bind_Filter_LostInterest();
            Bind_Filter_FeelAngry();
            Bind_Filter_GetIntoTrouble();
            Bind_Filter_FeelAfraid();
            Bind_Filter_FeelDepressed();
            Bind_Filter_SpendTimeOnThinkingAboutWeight();

        }

        private void Bind_Filter_Social()
        {
            DropDownList_CustomDocumentMentalHealthScreenings_PayingAttentionAtSchool.AddBlankRow = true;
            DropDownList_CustomDocumentMentalHealthScreenings_PayingAttentionAtSchool.BlankRowValue = "";
            DropDownList_CustomDocumentMentalHealthScreenings_PayingAttentionAtSchool.BlankRowValue = "";
            if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes != null)
            {
                DataView dataViewPrograms = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
                dataViewPrograms.RowFilter = "Category='RADIOYNNA' and ISNULL(RecordDeleted,'N')<>'Y' and Active='Y' and GlobalCodeId <> 5352";
                dataViewPrograms.Sort = "SortOrder,CodeName";
                DropDownList_CustomDocumentMentalHealthScreenings_PayingAttentionAtSchool.DataTextField = "CodeName";
                DropDownList_CustomDocumentMentalHealthScreenings_PayingAttentionAtSchool.DataValueField = "GlobalCodeId";
                DropDownList_CustomDocumentMentalHealthScreenings_PayingAttentionAtSchool.DataSource = dataViewPrograms;
                DropDownList_CustomDocumentMentalHealthScreenings_PayingAttentionAtSchool.DataBind();
                DropDownList_CustomDocumentMentalHealthScreenings_PayingAttentionAtSchool.SelectedItem.Value = "";
            }

        }
        private void Bind_Filter_Mind()
        {
            DropDownList_CustomDocumentMentalHealthScreenings_CanNotGetRidOfThought.AddBlankRow = true;
            DropDownList_CustomDocumentMentalHealthScreenings_CanNotGetRidOfThought.BlankRowValue = "";
            DropDownList_CustomDocumentMentalHealthScreenings_CanNotGetRidOfThought.BlankRowValue = "";
            if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes != null)
            {
                DataView dataViewPrograms = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
                dataViewPrograms.RowFilter = "Category='RADIOYNNA' and ISNULL(RecordDeleted,'N')<>'Y' and Active='Y' and GlobalCodeId <> 5352";
                dataViewPrograms.Sort = "SortOrder,CodeName";
                DropDownList_CustomDocumentMentalHealthScreenings_CanNotGetRidOfThought.DataTextField = "CodeName";
                DropDownList_CustomDocumentMentalHealthScreenings_CanNotGetRidOfThought.DataValueField = "GlobalCodeId";
                DropDownList_CustomDocumentMentalHealthScreenings_CanNotGetRidOfThought.DataSource = dataViewPrograms;
                DropDownList_CustomDocumentMentalHealthScreenings_CanNotGetRidOfThought.DataBind();
                DropDownList_CustomDocumentMentalHealthScreenings_CanNotGetRidOfThought.SelectedItem.Value = "";
            }

        }
        private void Bind_Filter_HearVoices()
        {
            DropDownList_CustomDocumentMentalHealthScreenings_HearVoices.AddBlankRow = true;
            DropDownList_CustomDocumentMentalHealthScreenings_HearVoices.BlankRowValue = "";
            DropDownList_CustomDocumentMentalHealthScreenings_HearVoices.BlankRowValue = "";
            if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes != null)
            {
                DataView dataViewPrograms = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
                dataViewPrograms.RowFilter = "Category='RADIOYNNA' and ISNULL(RecordDeleted,'N')<>'Y' and Active='Y' and GlobalCodeId <> 5352";
                dataViewPrograms.Sort = "SortOrder,CodeName";
                DropDownList_CustomDocumentMentalHealthScreenings_HearVoices.DataTextField = "CodeName";
                DropDownList_CustomDocumentMentalHealthScreenings_HearVoices.DataValueField = "GlobalCodeId";
                DropDownList_CustomDocumentMentalHealthScreenings_HearVoices.DataSource = dataViewPrograms;
                DropDownList_CustomDocumentMentalHealthScreenings_HearVoices.DataBind();
                DropDownList_CustomDocumentMentalHealthScreenings_HearVoices.SelectedItem.Value = "";
            }

        }
        private void Bind_Filter_SpendTimeKilling()
        {
            DropDownList_CustomDocumentMentalHealthScreenings_SpendTimeKilling.AddBlankRow = true;
            DropDownList_CustomDocumentMentalHealthScreenings_SpendTimeKilling.BlankRowValue = "";
            DropDownList_CustomDocumentMentalHealthScreenings_SpendTimeKilling.BlankRowValue = "";
            if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes != null)
            {
                DataView dataViewPrograms = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
                dataViewPrograms.RowFilter = "Category='RADIOYNNA' and ISNULL(RecordDeleted,'N')<>'Y' and Active='Y' and GlobalCodeId <> 5352";
                dataViewPrograms.Sort = "SortOrder,CodeName";
                DropDownList_CustomDocumentMentalHealthScreenings_SpendTimeKilling.DataTextField = "CodeName";
                DropDownList_CustomDocumentMentalHealthScreenings_SpendTimeKilling.DataValueField = "GlobalCodeId";
                DropDownList_CustomDocumentMentalHealthScreenings_SpendTimeKilling.DataSource = dataViewPrograms;
                DropDownList_CustomDocumentMentalHealthScreenings_SpendTimeKilling.DataBind();
                DropDownList_CustomDocumentMentalHealthScreenings_SpendTimeKilling.SelectedItem.Value = "";
            }

        }
        private void Bind_Filter_TriedToCommitSuicide()
        {
            DropDownList_CustomDocumentMentalHealthScreenings_TriedToCommitSuicide.AddBlankRow = true;
            DropDownList_CustomDocumentMentalHealthScreenings_TriedToCommitSuicide.BlankRowValue = "";
            DropDownList_CustomDocumentMentalHealthScreenings_TriedToCommitSuicide.BlankRowValue = "";
            if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes != null)
            {
                DataView dataViewPrograms = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
                dataViewPrograms.RowFilter = "Category='RADIOYNNA' and ISNULL(RecordDeleted,'N')<>'Y' and Active='Y' and GlobalCodeId <> 5352";
                dataViewPrograms.Sort = "SortOrder,CodeName";
                DropDownList_CustomDocumentMentalHealthScreenings_TriedToCommitSuicide.DataTextField = "CodeName";
                DropDownList_CustomDocumentMentalHealthScreenings_TriedToCommitSuicide.DataValueField = "GlobalCodeId";
                DropDownList_CustomDocumentMentalHealthScreenings_TriedToCommitSuicide.DataSource = dataViewPrograms;
                DropDownList_CustomDocumentMentalHealthScreenings_TriedToCommitSuicide.DataBind();
                DropDownList_CustomDocumentMentalHealthScreenings_TriedToCommitSuicide.SelectedItem.Value = "";
            }

        }
        private void Bind_Filter_WatchYourStep()
        {
            DropDownList_CustomDocumentMentalHealthScreenings_WatchYourStep.AddBlankRow = true;
            DropDownList_CustomDocumentMentalHealthScreenings_WatchYourStep.BlankRowValue = "";
            DropDownList_CustomDocumentMentalHealthScreenings_WatchYourStep.BlankRowValue = "";
            if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes != null)
            {
                DataView dataViewPrograms = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
                dataViewPrograms.RowFilter = "Category='RADIOYNNA' and ISNULL(RecordDeleted,'N')<>'Y' and Active='Y' and GlobalCodeId <> 5352";
                dataViewPrograms.Sort = "SortOrder,CodeName";
                DropDownList_CustomDocumentMentalHealthScreenings_WatchYourStep.DataTextField = "CodeName";
                DropDownList_CustomDocumentMentalHealthScreenings_WatchYourStep.DataValueField = "GlobalCodeId";
                DropDownList_CustomDocumentMentalHealthScreenings_WatchYourStep.DataSource = dataViewPrograms;
                DropDownList_CustomDocumentMentalHealthScreenings_WatchYourStep.DataBind();
                DropDownList_CustomDocumentMentalHealthScreenings_WatchYourStep.SelectedItem.Value = "";
            }

        }
        private void Bind_Filter_FeelAnxious()
        {
            DropDownList_CustomDocumentMentalHealthScreenings_FeelAnxious.AddBlankRow = true;
            DropDownList_CustomDocumentMentalHealthScreenings_FeelAnxious.BlankRowValue = "";
            DropDownList_CustomDocumentMentalHealthScreenings_FeelAnxious.BlankRowValue = "";
            if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes != null)
            {
                DataView dataViewPrograms = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
                dataViewPrograms.RowFilter = "Category='RADIOYNNA' and ISNULL(RecordDeleted,'N')<>'Y' and Active='Y' and GlobalCodeId <> 5352";
                dataViewPrograms.Sort = "SortOrder,CodeName";
                DropDownList_CustomDocumentMentalHealthScreenings_FeelAnxious.DataTextField = "CodeName";
                DropDownList_CustomDocumentMentalHealthScreenings_FeelAnxious.DataValueField = "GlobalCodeId";
                DropDownList_CustomDocumentMentalHealthScreenings_FeelAnxious.DataSource = dataViewPrograms;
                DropDownList_CustomDocumentMentalHealthScreenings_FeelAnxious.DataBind();
                DropDownList_CustomDocumentMentalHealthScreenings_FeelAnxious.SelectedItem.Value = "";
            }

        }
        private void Bind_Filter_ThoughtsComeQuickly()
        {
            DropDownList_CustomDocumentMentalHealthScreenings_ThoughtsComeQuickly.AddBlankRow = true;
            DropDownList_CustomDocumentMentalHealthScreenings_ThoughtsComeQuickly.BlankRowValue = "";
            DropDownList_CustomDocumentMentalHealthScreenings_ThoughtsComeQuickly.BlankRowValue = "";
            if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes != null)
            {
                DataView dataViewPrograms = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
                dataViewPrograms.RowFilter = "Category='RADIOYNNA' and ISNULL(RecordDeleted,'N')<>'Y' and Active='Y' and GlobalCodeId <> 5352";
                dataViewPrograms.Sort = "SortOrder,CodeName";
                DropDownList_CustomDocumentMentalHealthScreenings_ThoughtsComeQuickly.DataTextField = "CodeName";
                DropDownList_CustomDocumentMentalHealthScreenings_ThoughtsComeQuickly.DataValueField = "GlobalCodeId";
                DropDownList_CustomDocumentMentalHealthScreenings_ThoughtsComeQuickly.DataSource = dataViewPrograms;
                DropDownList_CustomDocumentMentalHealthScreenings_ThoughtsComeQuickly.DataBind();
                DropDownList_CustomDocumentMentalHealthScreenings_ThoughtsComeQuickly.SelectedItem.Value = "";
            }

        }
        private void Bind_Filter_DestroyedProperty()
        {
            DropDownList_CustomDocumentMentalHealthScreenings_DestroyedProperty.AddBlankRow = true;
            DropDownList_CustomDocumentMentalHealthScreenings_DestroyedProperty.BlankRowValue = "";
            DropDownList_CustomDocumentMentalHealthScreenings_DestroyedProperty.BlankRowValue = "";
            if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes != null)
            {
                DataView dataViewPrograms = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
                dataViewPrograms.RowFilter = "Category='RADIOYNNA' and ISNULL(RecordDeleted,'N')<>'Y' and Active='Y' and GlobalCodeId <> 5352";
                dataViewPrograms.Sort = "SortOrder,CodeName";
                DropDownList_CustomDocumentMentalHealthScreenings_DestroyedProperty.DataTextField = "CodeName";
                DropDownList_CustomDocumentMentalHealthScreenings_DestroyedProperty.DataValueField = "GlobalCodeId";
                DropDownList_CustomDocumentMentalHealthScreenings_DestroyedProperty.DataSource = dataViewPrograms;
                DropDownList_CustomDocumentMentalHealthScreenings_DestroyedProperty.DataBind();
                DropDownList_CustomDocumentMentalHealthScreenings_DestroyedProperty.SelectedItem.Value = "";
            }

        }
        private void Bind_Filter_FeelTrapped()
        {
            DropDownList_CustomDocumentMentalHealthScreenings_FeelTrapped.AddBlankRow = true;
            DropDownList_CustomDocumentMentalHealthScreenings_FeelTrapped.BlankRowValue = "";
            DropDownList_CustomDocumentMentalHealthScreenings_FeelTrapped.BlankRowValue = "";
            if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes != null)
            {
                DataView dataViewPrograms = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
                dataViewPrograms.RowFilter = "Category='RADIOYNNA' and ISNULL(RecordDeleted,'N')<>'Y' and Active='Y' and GlobalCodeId <> 5352";
                dataViewPrograms.Sort = "SortOrder,CodeName";
                DropDownList_CustomDocumentMentalHealthScreenings_FeelTrapped.DataTextField = "CodeName";
                DropDownList_CustomDocumentMentalHealthScreenings_FeelTrapped.DataValueField = "GlobalCodeId";
                DropDownList_CustomDocumentMentalHealthScreenings_FeelTrapped.DataSource = dataViewPrograms;
                DropDownList_CustomDocumentMentalHealthScreenings_FeelTrapped.DataBind();
                DropDownList_CustomDocumentMentalHealthScreenings_FeelTrapped.SelectedItem.Value = "";
            }

        }
        private void Bind_Filter_DissatifiedWithLife()
        {
            DropDownList_CustomDocumentMentalHealthScreenings_DissatifiedWithLife.AddBlankRow = true;
            DropDownList_CustomDocumentMentalHealthScreenings_DissatifiedWithLife.BlankRowValue = "";
            DropDownList_CustomDocumentMentalHealthScreenings_DissatifiedWithLife.BlankRowValue = "";
            if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes != null)
            {
                DataView dataViewPrograms = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
                dataViewPrograms.RowFilter = "Category='RADIOYNNA' and ISNULL(RecordDeleted,'N')<>'Y' and Active='Y' and GlobalCodeId <> 5352";
                dataViewPrograms.Sort = "SortOrder,CodeName";
                DropDownList_CustomDocumentMentalHealthScreenings_DissatifiedWithLife.DataTextField = "CodeName";
                DropDownList_CustomDocumentMentalHealthScreenings_DissatifiedWithLife.DataValueField = "GlobalCodeId";
                DropDownList_CustomDocumentMentalHealthScreenings_DissatifiedWithLife.DataSource = dataViewPrograms;
                DropDownList_CustomDocumentMentalHealthScreenings_DissatifiedWithLife.DataBind();
                DropDownList_CustomDocumentMentalHealthScreenings_DissatifiedWithLife.SelectedItem.Value = "";
            }

        }
        private void Bind_Filter_UnPleasantThoughts()
        {
            DropDownList_CustomDocumentMentalHealthScreenings_UnPleasantThoughts.AddBlankRow = true;
            DropDownList_CustomDocumentMentalHealthScreenings_UnPleasantThoughts.BlankRowValue = "";
            DropDownList_CustomDocumentMentalHealthScreenings_UnPleasantThoughts.BlankRowValue = "";
            if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes != null)
            {
                DataView dataViewPrograms = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
                dataViewPrograms.RowFilter = "Category='RADIOYNNA' and ISNULL(RecordDeleted,'N')<>'Y' and Active='Y' and GlobalCodeId <> 5352";
                dataViewPrograms.Sort = "SortOrder,CodeName";
                DropDownList_CustomDocumentMentalHealthScreenings_UnPleasantThoughts.DataTextField = "CodeName";
                DropDownList_CustomDocumentMentalHealthScreenings_UnPleasantThoughts.DataValueField = "GlobalCodeId";
                DropDownList_CustomDocumentMentalHealthScreenings_UnPleasantThoughts.DataSource = dataViewPrograms;
                DropDownList_CustomDocumentMentalHealthScreenings_UnPleasantThoughts.DataBind();
                DropDownList_CustomDocumentMentalHealthScreenings_UnPleasantThoughts.SelectedItem.Value = "";
            }

        }
        private void Bind_Filter_DifficultyInSleeping()
        {
            DropDownList_CustomDocumentMentalHealthScreenings_DifficultyInSleeping.AddBlankRow = true;
            DropDownList_CustomDocumentMentalHealthScreenings_DifficultyInSleeping.BlankRowValue = "";
            DropDownList_CustomDocumentMentalHealthScreenings_DifficultyInSleeping.BlankRowValue = "";
            if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes != null)
            {
                DataView dataViewPrograms = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
                dataViewPrograms.RowFilter = "Category='RADIOYNNA' and ISNULL(RecordDeleted,'N')<>'Y' and Active='Y' and GlobalCodeId <> 5352";
                dataViewPrograms.Sort = "SortOrder,CodeName";
                DropDownList_CustomDocumentMentalHealthScreenings_DifficultyInSleeping.DataTextField = "CodeName";
                DropDownList_CustomDocumentMentalHealthScreenings_DifficultyInSleeping.DataValueField = "GlobalCodeId";
                DropDownList_CustomDocumentMentalHealthScreenings_DifficultyInSleeping.DataSource = dataViewPrograms;
                DropDownList_CustomDocumentMentalHealthScreenings_DifficultyInSleeping.DataBind();
                DropDownList_CustomDocumentMentalHealthScreenings_DifficultyInSleeping.SelectedItem.Value = "";
            }

        }
        private void Bind_Filter_PhysicallyHarmed()
        {
            DropDownList_CustomDocumentMentalHealthScreenings_PhysicallyHarmed.AddBlankRow = true;
            DropDownList_CustomDocumentMentalHealthScreenings_PhysicallyHarmed.BlankRowValue = "";
            DropDownList_CustomDocumentMentalHealthScreenings_PhysicallyHarmed.BlankRowValue = "";
            if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes != null)
            {
                DataView dataViewPrograms = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
                dataViewPrograms.RowFilter = "Category='RADIOYNNA' and ISNULL(RecordDeleted,'N')<>'Y' and Active='Y' and GlobalCodeId <> 5352";
                dataViewPrograms.Sort = "SortOrder,CodeName";
                DropDownList_CustomDocumentMentalHealthScreenings_PhysicallyHarmed.DataTextField = "CodeName";
                DropDownList_CustomDocumentMentalHealthScreenings_PhysicallyHarmed.DataValueField = "GlobalCodeId";
                DropDownList_CustomDocumentMentalHealthScreenings_PhysicallyHarmed.DataSource = dataViewPrograms;
                DropDownList_CustomDocumentMentalHealthScreenings_PhysicallyHarmed.DataBind();
                DropDownList_CustomDocumentMentalHealthScreenings_PhysicallyHarmed.SelectedItem.Value = "";
            }

        }
        private void Bind_Filter_LostInterest()
        {
            DropDownList_CustomDocumentMentalHealthScreenings_LostInterest.AddBlankRow = true;
            DropDownList_CustomDocumentMentalHealthScreenings_LostInterest.BlankRowValue = "";
            DropDownList_CustomDocumentMentalHealthScreenings_LostInterest.BlankRowValue = "";
            if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes != null)
            {
                DataView dataViewPrograms = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
                dataViewPrograms.RowFilter = "Category='RADIOYNNA' and ISNULL(RecordDeleted,'N')<>'Y' and Active='Y' and GlobalCodeId <> 5352";
                dataViewPrograms.Sort = "SortOrder,CodeName";
                DropDownList_CustomDocumentMentalHealthScreenings_LostInterest.DataTextField = "CodeName";
                DropDownList_CustomDocumentMentalHealthScreenings_LostInterest.DataValueField = "GlobalCodeId";
                DropDownList_CustomDocumentMentalHealthScreenings_LostInterest.DataSource = dataViewPrograms;
                DropDownList_CustomDocumentMentalHealthScreenings_LostInterest.DataBind();
                DropDownList_CustomDocumentMentalHealthScreenings_LostInterest.SelectedItem.Value = "";
            }

        }
        private void Bind_Filter_FeelAngry()
        {
            DropDownList_CustomDocumentMentalHealthScreenings_FeelAngry.AddBlankRow = true;
            DropDownList_CustomDocumentMentalHealthScreenings_FeelAngry.BlankRowValue = "";
            DropDownList_CustomDocumentMentalHealthScreenings_FeelAngry.BlankRowValue = "";
            if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes != null)
            {
                DataView dataViewPrograms = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
                dataViewPrograms.RowFilter = "Category='RADIOYNNA' and ISNULL(RecordDeleted,'N')<>'Y' and Active='Y' and GlobalCodeId <> 5352";
                dataViewPrograms.Sort = "SortOrder,CodeName";
                DropDownList_CustomDocumentMentalHealthScreenings_FeelAngry.DataTextField = "CodeName";
                DropDownList_CustomDocumentMentalHealthScreenings_FeelAngry.DataValueField = "GlobalCodeId";
                DropDownList_CustomDocumentMentalHealthScreenings_FeelAngry.DataSource = dataViewPrograms;
                DropDownList_CustomDocumentMentalHealthScreenings_FeelAngry.DataBind();
                DropDownList_CustomDocumentMentalHealthScreenings_FeelAngry.SelectedItem.Value = "";
            }

        }
        private void Bind_Filter_GetIntoTrouble()
        {
            DropDownList_CustomDocumentMentalHealthScreenings_GetIntoTrouble.AddBlankRow = true;
            DropDownList_CustomDocumentMentalHealthScreenings_GetIntoTrouble.BlankRowValue = "";
            DropDownList_CustomDocumentMentalHealthScreenings_GetIntoTrouble.BlankRowValue = "";
            if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes != null)
            {
                DataView dataViewPrograms = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
                dataViewPrograms.RowFilter = "Category='RADIOYNNA' and ISNULL(RecordDeleted,'N')<>'Y' and Active='Y' and GlobalCodeId <> 5352";
                dataViewPrograms.Sort = "SortOrder,CodeName";
                DropDownList_CustomDocumentMentalHealthScreenings_GetIntoTrouble.DataTextField = "CodeName";
                DropDownList_CustomDocumentMentalHealthScreenings_GetIntoTrouble.DataValueField = "GlobalCodeId";
                DropDownList_CustomDocumentMentalHealthScreenings_GetIntoTrouble.DataSource = dataViewPrograms;
                DropDownList_CustomDocumentMentalHealthScreenings_GetIntoTrouble.DataBind();
                DropDownList_CustomDocumentMentalHealthScreenings_GetIntoTrouble.SelectedItem.Value = "";
            }

        }
        private void Bind_Filter_FeelAfraid()
        {
            DropDownList_CustomDocumentMentalHealthScreenings_FeelAfraid.AddBlankRow = true;
            DropDownList_CustomDocumentMentalHealthScreenings_FeelAfraid.BlankRowValue = "";
            DropDownList_CustomDocumentMentalHealthScreenings_FeelAfraid.BlankRowValue = "";
            if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes != null)
            {
                DataView dataViewPrograms = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
                dataViewPrograms.RowFilter = "Category='RADIOYNNA' and ISNULL(RecordDeleted,'N')<>'Y' and Active='Y' and GlobalCodeId <> 5352";
                dataViewPrograms.Sort = "SortOrder,CodeName";
                DropDownList_CustomDocumentMentalHealthScreenings_FeelAfraid.DataTextField = "CodeName";
                DropDownList_CustomDocumentMentalHealthScreenings_FeelAfraid.DataValueField = "GlobalCodeId";
                DropDownList_CustomDocumentMentalHealthScreenings_FeelAfraid.DataSource = dataViewPrograms;
                DropDownList_CustomDocumentMentalHealthScreenings_FeelAfraid.DataBind();
                DropDownList_CustomDocumentMentalHealthScreenings_FeelAfraid.SelectedItem.Value = "";
            }

        }
        private void Bind_Filter_FeelDepressed()
        {
            DropDownList_CustomDocumentMentalHealthScreenings_FeelDepressed.AddBlankRow = true;
            DropDownList_CustomDocumentMentalHealthScreenings_FeelDepressed.BlankRowValue = "";
            DropDownList_CustomDocumentMentalHealthScreenings_FeelDepressed.BlankRowValue = "";
            if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes != null)
            {
                DataView dataViewPrograms = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
                dataViewPrograms.RowFilter = "Category='RADIOYNNA' and ISNULL(RecordDeleted,'N')<>'Y' and Active='Y' and GlobalCodeId <> 5352";
                dataViewPrograms.Sort = "SortOrder,CodeName";
                DropDownList_CustomDocumentMentalHealthScreenings_FeelDepressed.DataTextField = "CodeName";
                DropDownList_CustomDocumentMentalHealthScreenings_FeelDepressed.DataValueField = "GlobalCodeId";
                DropDownList_CustomDocumentMentalHealthScreenings_FeelDepressed.DataSource = dataViewPrograms;
                DropDownList_CustomDocumentMentalHealthScreenings_FeelDepressed.DataBind();
                DropDownList_CustomDocumentMentalHealthScreenings_FeelDepressed.SelectedItem.Value = "";
            }

        }
        private void Bind_Filter_SpendTimeOnThinkingAboutWeight()
        {
            DropDownList_CustomDocumentMentalHealthScreenings_SpendTimeOnThinkingAboutWeight.AddBlankRow = true;
            DropDownList_CustomDocumentMentalHealthScreenings_SpendTimeOnThinkingAboutWeight.BlankRowValue = "";
            DropDownList_CustomDocumentMentalHealthScreenings_SpendTimeOnThinkingAboutWeight.BlankRowValue = "";
            if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes != null)
            {
                DataView dataViewPrograms = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
                dataViewPrograms.RowFilter = "Category='RADIOYNNA' and ISNULL(RecordDeleted,'N')<>'Y' and Active='Y' and GlobalCodeId <> 5352";
                dataViewPrograms.Sort = "SortOrder,CodeName";
                DropDownList_CustomDocumentMentalHealthScreenings_SpendTimeOnThinkingAboutWeight.DataTextField = "CodeName";
                DropDownList_CustomDocumentMentalHealthScreenings_SpendTimeOnThinkingAboutWeight.DataValueField = "GlobalCodeId";
                DropDownList_CustomDocumentMentalHealthScreenings_SpendTimeOnThinkingAboutWeight.DataSource = dataViewPrograms;
                DropDownList_CustomDocumentMentalHealthScreenings_SpendTimeOnThinkingAboutWeight.DataBind();
                DropDownList_CustomDocumentMentalHealthScreenings_SpendTimeOnThinkingAboutWeight.SelectedItem.Value = "";
            }

        }
        
    }
}

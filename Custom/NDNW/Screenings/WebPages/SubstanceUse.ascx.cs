using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SHS.BaseLayer.ActivityPages;
using System.Data;
using SHS.DataServices;
using SHS.UserBusinessServices;
using SHS.BaseLayer;
using System.IO;
using System.Xml.Serialization;

namespace SHS.SmartCare
{
    public partial class Custom_Screenings_WebPages_SubstanceUse : DataActivityTab
    {
       
        public override void BindControls()
        {
            Bind_Filter_Inhalants();
            Bind_Filter_MissedSchool();
            Bind_Filter_PastYearDrunk();
            Bind_Filter_RiskyWhenHigh();
            Bind_Filter_ProblemWithDrinking();
            Bind_Filter_ThingsWithoutThinking();
            Bind_Filter_MissFamilyActivities();
            Bind_Filter_WorryAboutUsingAlcohol();
            Bind_Filter_HurtLovedOne();
            Bind_Filter_ToFeelNormal();
            Bind_Filter_MakeYouMad();
            Bind_Filter_DidMotherDrinkInPregnancy();
            Bind_Filter_WorryAboutGamblingActivities();
            Bind_Filter_GuiltyAboutAlcohol();
            Bind_Filter_HasMotherConsumedAlcohol();
        }

        private void Bind_Filter_Inhalants()
        {
            DropDownList_CustomDocumentSubstanceAbuseScreenings_Inhalants.AddBlankRow = true;
            DropDownList_CustomDocumentSubstanceAbuseScreenings_Inhalants.BlankRowValue = "";
            DropDownList_CustomDocumentSubstanceAbuseScreenings_Inhalants.BlankRowValue = "";
            if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes != null)
            {
                DataView dataViewPrograms = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
                dataViewPrograms.RowFilter = "Category='RADIOYNNA' and ISNULL(RecordDeleted,'N')<>'Y' and Active='Y' and GlobalCodeId <> 5352";
                dataViewPrograms.Sort = "SortOrder,CodeName";
                DropDownList_CustomDocumentSubstanceAbuseScreenings_Inhalants.DataTextField = "CodeName";
                DropDownList_CustomDocumentSubstanceAbuseScreenings_Inhalants.DataValueField = "GlobalCodeId";
                DropDownList_CustomDocumentSubstanceAbuseScreenings_Inhalants.DataSource = dataViewPrograms;
                DropDownList_CustomDocumentSubstanceAbuseScreenings_Inhalants.DataBind();
                DropDownList_CustomDocumentSubstanceAbuseScreenings_Inhalants.SelectedItem.Value = "";
            }

        }
        private void Bind_Filter_MissedSchool()
        {
            DropDownList_CustomDocumentSubstanceAbuseScreenings_MissedSchool.AddBlankRow = true;
            DropDownList_CustomDocumentSubstanceAbuseScreenings_MissedSchool.BlankRowValue = "";
            DropDownList_CustomDocumentSubstanceAbuseScreenings_MissedSchool.BlankRowValue = "";
            if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes != null)
            {
                DataView dataViewPrograms = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
                dataViewPrograms.RowFilter = "Category='RADIOYNNA' and ISNULL(RecordDeleted,'N')<>'Y' and Active='Y' and GlobalCodeId <> 5352";
                dataViewPrograms.Sort = "SortOrder,CodeName";
                DropDownList_CustomDocumentSubstanceAbuseScreenings_MissedSchool.DataTextField = "CodeName";
                DropDownList_CustomDocumentSubstanceAbuseScreenings_MissedSchool.DataValueField = "GlobalCodeId";
                DropDownList_CustomDocumentSubstanceAbuseScreenings_MissedSchool.DataSource = dataViewPrograms;
                DropDownList_CustomDocumentSubstanceAbuseScreenings_MissedSchool.DataBind();
                DropDownList_CustomDocumentSubstanceAbuseScreenings_MissedSchool.SelectedItem.Value = "";
            }

        }
        private void Bind_Filter_PastYearDrunk()
        {
            DropDownList_CustomDocumentSubstanceAbuseScreenings_PastYearDrunk.AddBlankRow = true;
            DropDownList_CustomDocumentSubstanceAbuseScreenings_PastYearDrunk.BlankRowValue = "";
            DropDownList_CustomDocumentSubstanceAbuseScreenings_PastYearDrunk.BlankRowValue = "";
            if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes != null)
            {
                DataView dataViewPrograms = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
                dataViewPrograms.RowFilter = "Category='RADIOYNNA' and ISNULL(RecordDeleted,'N')<>'Y' and Active='Y' and GlobalCodeId <> 5352";
                dataViewPrograms.Sort = "SortOrder,CodeName";
                DropDownList_CustomDocumentSubstanceAbuseScreenings_PastYearDrunk.DataTextField = "CodeName";
                DropDownList_CustomDocumentSubstanceAbuseScreenings_PastYearDrunk.DataValueField = "GlobalCodeId";
                DropDownList_CustomDocumentSubstanceAbuseScreenings_PastYearDrunk.DataSource = dataViewPrograms;
                DropDownList_CustomDocumentSubstanceAbuseScreenings_PastYearDrunk.DataBind();
                DropDownList_CustomDocumentSubstanceAbuseScreenings_PastYearDrunk.SelectedItem.Value = "";
            }

        }
        private void Bind_Filter_RiskyWhenHigh()
        {
            DropDownList_CustomDocumentSubstanceAbuseScreenings_RiskyWhenHigh.AddBlankRow = true;
            DropDownList_CustomDocumentSubstanceAbuseScreenings_RiskyWhenHigh.BlankRowValue = "";
            DropDownList_CustomDocumentSubstanceAbuseScreenings_RiskyWhenHigh.BlankRowValue = "";
            if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes != null)
            {
                DataView dataViewPrograms = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
                dataViewPrograms.RowFilter = "Category='RADIOYNNA' and ISNULL(RecordDeleted,'N')<>'Y' and Active='Y' and GlobalCodeId <> 5352";
                dataViewPrograms.Sort = "SortOrder,CodeName";
                DropDownList_CustomDocumentSubstanceAbuseScreenings_RiskyWhenHigh.DataTextField = "CodeName";
                DropDownList_CustomDocumentSubstanceAbuseScreenings_RiskyWhenHigh.DataValueField = "GlobalCodeId";
                DropDownList_CustomDocumentSubstanceAbuseScreenings_RiskyWhenHigh.DataSource = dataViewPrograms;
                DropDownList_CustomDocumentSubstanceAbuseScreenings_RiskyWhenHigh.DataBind();
                DropDownList_CustomDocumentSubstanceAbuseScreenings_RiskyWhenHigh.SelectedItem.Value = "";
            }

        }
        private void Bind_Filter_ProblemWithDrinking()
        {
            DropDownList_CustomDocumentSubstanceAbuseScreenings_ProblemWithDrinking.AddBlankRow = true;
            DropDownList_CustomDocumentSubstanceAbuseScreenings_ProblemWithDrinking.BlankRowValue = "";
            DropDownList_CustomDocumentSubstanceAbuseScreenings_ProblemWithDrinking.BlankRowValue = "";
            if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes != null)
            {
                DataView dataViewPrograms = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
                dataViewPrograms.RowFilter = "Category='RADIOYNNA' and ISNULL(RecordDeleted,'N')<>'Y' and Active='Y' and GlobalCodeId <> 5352";
                dataViewPrograms.Sort = "SortOrder,CodeName";
                DropDownList_CustomDocumentSubstanceAbuseScreenings_ProblemWithDrinking.DataTextField = "CodeName";
                DropDownList_CustomDocumentSubstanceAbuseScreenings_ProblemWithDrinking.DataValueField = "GlobalCodeId";
                DropDownList_CustomDocumentSubstanceAbuseScreenings_ProblemWithDrinking.DataSource = dataViewPrograms;
                DropDownList_CustomDocumentSubstanceAbuseScreenings_ProblemWithDrinking.DataBind();
                DropDownList_CustomDocumentSubstanceAbuseScreenings_ProblemWithDrinking.SelectedItem.Value = "";
            }

        }
        private void Bind_Filter_ThingsWithoutThinking()
        {
            DropDownList_CustomDocumentSubstanceAbuseScreenings_ThingsWithoutThinking.AddBlankRow = true;
            DropDownList_CustomDocumentSubstanceAbuseScreenings_ThingsWithoutThinking.BlankRowValue = "";
            DropDownList_CustomDocumentSubstanceAbuseScreenings_ThingsWithoutThinking.BlankRowValue = "";
            if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes != null)
            {
                DataView dataViewPrograms = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
                dataViewPrograms.RowFilter = "Category='RADIOYNNA' and ISNULL(RecordDeleted,'N')<>'Y' and Active='Y' and GlobalCodeId <> 5352";
                dataViewPrograms.Sort = "SortOrder,CodeName";
                DropDownList_CustomDocumentSubstanceAbuseScreenings_ThingsWithoutThinking.DataTextField = "CodeName";
                DropDownList_CustomDocumentSubstanceAbuseScreenings_ThingsWithoutThinking.DataValueField = "GlobalCodeId";
                DropDownList_CustomDocumentSubstanceAbuseScreenings_ThingsWithoutThinking.DataSource = dataViewPrograms;
                DropDownList_CustomDocumentSubstanceAbuseScreenings_ThingsWithoutThinking.DataBind();
                DropDownList_CustomDocumentSubstanceAbuseScreenings_ThingsWithoutThinking.SelectedItem.Value = "";
            }

        }
        private void Bind_Filter_MissFamilyActivities()
        {
            DropDownList_CustomDocumentSubstanceAbuseScreenings_MissFamilyActivities.AddBlankRow = true;
            DropDownList_CustomDocumentSubstanceAbuseScreenings_MissFamilyActivities.BlankRowValue = "";
            DropDownList_CustomDocumentSubstanceAbuseScreenings_MissFamilyActivities.BlankRowValue = "";
            if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes != null)
            {
                DataView dataViewPrograms = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
                dataViewPrograms.RowFilter = "Category='RADIOYNNA' and ISNULL(RecordDeleted,'N')<>'Y' and Active='Y' and GlobalCodeId <> 5352";
                dataViewPrograms.Sort = "SortOrder,CodeName";
                DropDownList_CustomDocumentSubstanceAbuseScreenings_MissFamilyActivities.DataTextField = "CodeName";
                DropDownList_CustomDocumentSubstanceAbuseScreenings_MissFamilyActivities.DataValueField = "GlobalCodeId";
                DropDownList_CustomDocumentSubstanceAbuseScreenings_MissFamilyActivities.DataSource = dataViewPrograms;
                DropDownList_CustomDocumentSubstanceAbuseScreenings_MissFamilyActivities.DataBind();
                DropDownList_CustomDocumentSubstanceAbuseScreenings_MissFamilyActivities.SelectedItem.Value = "";
            }

        }
        private void Bind_Filter_WorryAboutUsingAlcohol()
        {
            DropDownList_CustomDocumentSubstanceAbuseScreenings_WorryAboutUsingAlcohol.AddBlankRow = true;
            DropDownList_CustomDocumentSubstanceAbuseScreenings_WorryAboutUsingAlcohol.BlankRowValue = "";
            DropDownList_CustomDocumentSubstanceAbuseScreenings_WorryAboutUsingAlcohol.BlankRowValue = "";
            if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes != null)
            {
                DataView dataViewPrograms = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
                dataViewPrograms.RowFilter = "Category='RADIOYNNA' and ISNULL(RecordDeleted,'N')<>'Y' and Active='Y' and GlobalCodeId <> 5352";
                dataViewPrograms.Sort = "SortOrder,CodeName";
                DropDownList_CustomDocumentSubstanceAbuseScreenings_WorryAboutUsingAlcohol.DataTextField = "CodeName";
                DropDownList_CustomDocumentSubstanceAbuseScreenings_WorryAboutUsingAlcohol.DataValueField = "GlobalCodeId";
                DropDownList_CustomDocumentSubstanceAbuseScreenings_WorryAboutUsingAlcohol.DataSource = dataViewPrograms;
                DropDownList_CustomDocumentSubstanceAbuseScreenings_WorryAboutUsingAlcohol.DataBind();
                DropDownList_CustomDocumentSubstanceAbuseScreenings_WorryAboutUsingAlcohol.SelectedItem.Value = "";
            }

        }
        private void Bind_Filter_HurtLovedOne()
        {
            DropDownList_CustomDocumentSubstanceAbuseScreenings_HurtLovedOne.AddBlankRow = true;
            DropDownList_CustomDocumentSubstanceAbuseScreenings_HurtLovedOne.BlankRowValue = "";
            DropDownList_CustomDocumentSubstanceAbuseScreenings_HurtLovedOne.BlankRowValue = "";
            if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes != null)
            {
                DataView dataViewPrograms = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
                dataViewPrograms.RowFilter = "Category='RADIOYNNA' and ISNULL(RecordDeleted,'N')<>'Y' and Active='Y' and GlobalCodeId <> 5352";
                dataViewPrograms.Sort = "SortOrder,CodeName";
                DropDownList_CustomDocumentSubstanceAbuseScreenings_HurtLovedOne.DataTextField = "CodeName";
                DropDownList_CustomDocumentSubstanceAbuseScreenings_HurtLovedOne.DataValueField = "GlobalCodeId";
                DropDownList_CustomDocumentSubstanceAbuseScreenings_HurtLovedOne.DataSource = dataViewPrograms;
                DropDownList_CustomDocumentSubstanceAbuseScreenings_HurtLovedOne.DataBind();
                DropDownList_CustomDocumentSubstanceAbuseScreenings_HurtLovedOne.SelectedItem.Value = "";
            }

        }
        private void Bind_Filter_ToFeelNormal()
        {
            DropDownList_CustomDocumentSubstanceAbuseScreenings_ToFeelNormal.AddBlankRow = true;
            DropDownList_CustomDocumentSubstanceAbuseScreenings_ToFeelNormal.BlankRowValue = "";
            DropDownList_CustomDocumentSubstanceAbuseScreenings_ToFeelNormal.BlankRowValue = "";
            if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes != null)
            {
                DataView dataViewPrograms = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
                dataViewPrograms.RowFilter = "Category='RADIOYNNA' and ISNULL(RecordDeleted,'N')<>'Y' and Active='Y' and GlobalCodeId <> 5352";
                dataViewPrograms.Sort = "SortOrder,CodeName";
                DropDownList_CustomDocumentSubstanceAbuseScreenings_ToFeelNormal.DataTextField = "CodeName";
                DropDownList_CustomDocumentSubstanceAbuseScreenings_ToFeelNormal.DataValueField = "GlobalCodeId";
                DropDownList_CustomDocumentSubstanceAbuseScreenings_ToFeelNormal.DataSource = dataViewPrograms;
                DropDownList_CustomDocumentSubstanceAbuseScreenings_ToFeelNormal.DataBind();
                DropDownList_CustomDocumentSubstanceAbuseScreenings_ToFeelNormal.SelectedItem.Value = "";
            }

        }
        private void Bind_Filter_MakeYouMad()
        {
            DropDownList_CustomDocumentSubstanceAbuseScreenings_MakeYouMad.AddBlankRow = true;
            DropDownList_CustomDocumentSubstanceAbuseScreenings_MakeYouMad.BlankRowValue = "";
            DropDownList_CustomDocumentSubstanceAbuseScreenings_MakeYouMad.BlankRowValue = "";
            if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes != null)
            {
                DataView dataViewPrograms = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
                dataViewPrograms.RowFilter = "Category='RADIOYNNA' and ISNULL(RecordDeleted,'N')<>'Y' and Active='Y' and GlobalCodeId <> 5352";
                dataViewPrograms.Sort = "SortOrder,CodeName";
                DropDownList_CustomDocumentSubstanceAbuseScreenings_MakeYouMad.DataTextField = "CodeName";
                DropDownList_CustomDocumentSubstanceAbuseScreenings_MakeYouMad.DataValueField = "GlobalCodeId";
                DropDownList_CustomDocumentSubstanceAbuseScreenings_MakeYouMad.DataSource = dataViewPrograms;
                DropDownList_CustomDocumentSubstanceAbuseScreenings_MakeYouMad.DataBind();
                DropDownList_CustomDocumentSubstanceAbuseScreenings_MakeYouMad.SelectedItem.Value = "";
            }

        }
        private void Bind_Filter_GuiltyAboutAlcohol()
        {
            DropDownList_CustomDocumentSubstanceAbuseScreenings_GuiltyAboutAlcohol.AddBlankRow = true;
            DropDownList_CustomDocumentSubstanceAbuseScreenings_GuiltyAboutAlcohol.BlankRowValue = "";
            DropDownList_CustomDocumentSubstanceAbuseScreenings_GuiltyAboutAlcohol.BlankRowValue = "";
            if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes != null)
            {
                DataView dataViewPrograms = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
                dataViewPrograms.RowFilter = "Category='RADIOYNNA' and ISNULL(RecordDeleted,'N')<>'Y' and Active='Y' and GlobalCodeId <> 5352";
                dataViewPrograms.Sort = "SortOrder,CodeName";
                DropDownList_CustomDocumentSubstanceAbuseScreenings_GuiltyAboutAlcohol.DataTextField = "CodeName";
                DropDownList_CustomDocumentSubstanceAbuseScreenings_GuiltyAboutAlcohol.DataValueField = "GlobalCodeId";
                DropDownList_CustomDocumentSubstanceAbuseScreenings_GuiltyAboutAlcohol.DataSource = dataViewPrograms;
                DropDownList_CustomDocumentSubstanceAbuseScreenings_GuiltyAboutAlcohol.DataBind();
                DropDownList_CustomDocumentSubstanceAbuseScreenings_GuiltyAboutAlcohol.SelectedItem.Value = "";
            }

        }
        private void Bind_Filter_WorryAboutGamblingActivities()
        {
            DropDownList_CustomDocumentSubstanceAbuseScreenings_WorryAboutGamblingActivities.AddBlankRow = true;
            DropDownList_CustomDocumentSubstanceAbuseScreenings_WorryAboutGamblingActivities.BlankRowValue = "";
            DropDownList_CustomDocumentSubstanceAbuseScreenings_WorryAboutGamblingActivities.BlankRowValue = "";
            if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes != null)
            {
                DataView dataViewPrograms = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
                dataViewPrograms.RowFilter = "Category='RADIOYNNA' and ISNULL(RecordDeleted,'N')<>'Y' and Active='Y' and GlobalCodeId <> 5352";
                dataViewPrograms.Sort = "SortOrder,CodeName";
                DropDownList_CustomDocumentSubstanceAbuseScreenings_WorryAboutGamblingActivities.DataTextField = "CodeName";
                DropDownList_CustomDocumentSubstanceAbuseScreenings_WorryAboutGamblingActivities.DataValueField = "GlobalCodeId";
                DropDownList_CustomDocumentSubstanceAbuseScreenings_WorryAboutGamblingActivities.DataSource = dataViewPrograms;
                DropDownList_CustomDocumentSubstanceAbuseScreenings_WorryAboutGamblingActivities.DataBind();
                DropDownList_CustomDocumentSubstanceAbuseScreenings_WorryAboutGamblingActivities.SelectedItem.Value = "";
            }

        }
        private void Bind_Filter_DidMotherDrinkInPregnancy()
        {
            DropDownList_CustomDocumentSubstanceAbuseScreenings_DidMotherDrinkInPregnancy.AddBlankRow = true;
            DropDownList_CustomDocumentSubstanceAbuseScreenings_DidMotherDrinkInPregnancy.BlankRowValue = "";
            DropDownList_CustomDocumentSubstanceAbuseScreenings_DidMotherDrinkInPregnancy.BlankRowValue = "";
            if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes != null)
            {
                DataView dataViewPrograms = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
                dataViewPrograms.RowFilter = "Category='RADIOYNNA' and ISNULL(RecordDeleted,'N')<>'Y' and Active='Y' and GlobalCodeId <> 5352";
                dataViewPrograms.Sort = "SortOrder,CodeName";
                DropDownList_CustomDocumentSubstanceAbuseScreenings_DidMotherDrinkInPregnancy.DataTextField = "CodeName";
                DropDownList_CustomDocumentSubstanceAbuseScreenings_DidMotherDrinkInPregnancy.DataValueField = "GlobalCodeId";
                DropDownList_CustomDocumentSubstanceAbuseScreenings_DidMotherDrinkInPregnancy.DataSource = dataViewPrograms;
                DropDownList_CustomDocumentSubstanceAbuseScreenings_DidMotherDrinkInPregnancy.DataBind();
                DropDownList_CustomDocumentSubstanceAbuseScreenings_DidMotherDrinkInPregnancy.SelectedItem.Value = "";
            }

        }

        private void Bind_Filter_HasMotherConsumedAlcohol()
        {
            DropDownList_CustomDocumentSubstanceAbuseScreenings_HasMotherConsumedAlcohol.AddBlankRow = true;
            DropDownList_CustomDocumentSubstanceAbuseScreenings_HasMotherConsumedAlcohol.BlankRowValue = "";
            DropDownList_CustomDocumentSubstanceAbuseScreenings_HasMotherConsumedAlcohol.BlankRowValue = "";
            if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes != null)
            {
                DataView dataViewPrograms = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
                dataViewPrograms.RowFilter = "Category='RADIOYNNA' and ISNULL(RecordDeleted,'N')<>'Y' and Active='Y' and GlobalCodeId <> 5352";
                dataViewPrograms.Sort = "SortOrder,CodeName";
                DropDownList_CustomDocumentSubstanceAbuseScreenings_HasMotherConsumedAlcohol.DataTextField = "CodeName";
                DropDownList_CustomDocumentSubstanceAbuseScreenings_HasMotherConsumedAlcohol.DataValueField = "GlobalCodeId";
                DropDownList_CustomDocumentSubstanceAbuseScreenings_HasMotherConsumedAlcohol.DataSource = dataViewPrograms;
                DropDownList_CustomDocumentSubstanceAbuseScreenings_HasMotherConsumedAlcohol.DataBind();
                DropDownList_CustomDocumentSubstanceAbuseScreenings_HasMotherConsumedAlcohol.SelectedItem.Value = "";
            }

        }
      
    }
}
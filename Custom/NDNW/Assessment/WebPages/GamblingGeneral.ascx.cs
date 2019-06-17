using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
public partial class GamblingGeneral : SHS.BaseLayer.ActivityPages.DataActivityTab
{

    public override void BindControls()
    {
        if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes != null)
        {
            DataView dataViewXGAMBLINGINSURANCE = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
            dataViewXGAMBLINGINSURANCE.RowFilter = "Category='XGAMBLINGINSURANCE' and Active='Y' and ISNULL(RecordDeleted,'N')='N'";
            dataViewXGAMBLINGINSURANCE.Sort = "SortOrder ASC";
            DropDownList_CustomDocumentGambling_HealthInsurance.DataTextField = "CodeName";
            DropDownList_CustomDocumentGambling_HealthInsurance.DataValueField = "GlobalCodeId";
            DropDownList_CustomDocumentGambling_HealthInsurance.DataSource = dataViewXGAMBLINGINSURANCE;
            DropDownList_CustomDocumentGambling_HealthInsurance.DataBind();
            DropDownList_CustomDocumentGambling_HealthInsurance.Items.Insert(0, new ListItem("", ""));
          

            DataView dataViewXGAMBLINGINCOME = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
            dataViewXGAMBLINGINCOME.RowFilter = "Category='XGAMBLINGINCOME' and Active='Y' and ISNULL(RecordDeleted,'N')='N'";
            dataViewXGAMBLINGINCOME.Sort = "SortOrder ASC";
            DropDownList_CustomDocumentGambling_PrimarySourceOfIncome.DataTextField = "CodeName";
            DropDownList_CustomDocumentGambling_PrimarySourceOfIncome.DataValueField = "GlobalCodeId";
            DropDownList_CustomDocumentGambling_PrimarySourceOfIncome.DataSource = dataViewXGAMBLINGINCOME;
            DropDownList_CustomDocumentGambling_PrimarySourceOfIncome.DataBind();
            DropDownList_CustomDocumentGambling_PrimarySourceOfIncome.Items.Insert(0, new ListItem("", ""));
        }
        using (DataView dataViewGlobalCodes = SHS.BaseLayer.BaseCommonFunctions.FillDropDown("XGAMBLINGGENERAL", true, "", "SortOrder", true))
        {
            DropDownList_CustomDocumentGambling_LifeInGeneral.DataTextField = "CodeName";
            DropDownList_CustomDocumentGambling_LifeInGeneral.DataValueField = "GlobalCodeId";
            DropDownList_CustomDocumentGambling_LifeInGeneral.DataSource = dataViewGlobalCodes;
            DropDownList_CustomDocumentGambling_LifeInGeneral.DataBind();

            DropDownList_CustomDocumentGambling_RelationshipWithFriends.DataTextField = "CodeName";
            DropDownList_CustomDocumentGambling_RelationshipWithFriends.DataValueField = "GlobalCodeId";
            DropDownList_CustomDocumentGambling_RelationshipWithFriends.DataSource = dataViewGlobalCodes;
            DropDownList_CustomDocumentGambling_RelationshipWithFriends.DataBind();

            DropDownList_CustomDocumentGambling_OverallPhysicalHealth.DataTextField = "CodeName";
            DropDownList_CustomDocumentGambling_OverallPhysicalHealth.DataValueField = "GlobalCodeId";
            DropDownList_CustomDocumentGambling_OverallPhysicalHealth.DataSource = dataViewGlobalCodes;
            DropDownList_CustomDocumentGambling_OverallPhysicalHealth.DataBind();

            DropDownList_CustomDocumentGambling_RelationshipWithOtherFamilyMembers.DataTextField = "CodeName";
            DropDownList_CustomDocumentGambling_RelationshipWithOtherFamilyMembers.DataValueField = "GlobalCodeId";
            DropDownList_CustomDocumentGambling_RelationshipWithOtherFamilyMembers.DataSource = dataViewGlobalCodes;
            DropDownList_CustomDocumentGambling_RelationshipWithOtherFamilyMembers.DataBind();

            DropDownList_CustomDocumentGambling_OverallEmotionalWellbeing.DataTextField = "CodeName";
            DropDownList_CustomDocumentGambling_OverallEmotionalWellbeing.DataValueField = "GlobalCodeId";
            DropDownList_CustomDocumentGambling_OverallEmotionalWellbeing.DataSource = dataViewGlobalCodes;
            DropDownList_CustomDocumentGambling_OverallEmotionalWellbeing.DataBind();

            DropDownList_CustomDocumentGambling_Job.DataTextField = "CodeName";
            DropDownList_CustomDocumentGambling_Job.DataValueField = "GlobalCodeId";
            DropDownList_CustomDocumentGambling_Job.DataSource = dataViewGlobalCodes;
            DropDownList_CustomDocumentGambling_Job.DataBind();

            DropDownList_CustomDocumentGambling_RelationshipWithSpouse.DataTextField = "CodeName";
            DropDownList_CustomDocumentGambling_RelationshipWithSpouse.DataValueField = "GlobalCodeId";
            DropDownList_CustomDocumentGambling_RelationshipWithSpouse.DataSource = dataViewGlobalCodes;
            DropDownList_CustomDocumentGambling_RelationshipWithSpouse.DataBind();

            DropDownList_CustomDocumentGambling_School.DataTextField = "CodeName";
            DropDownList_CustomDocumentGambling_School.DataValueField = "GlobalCodeId";
            DropDownList_CustomDocumentGambling_School.DataSource = dataViewGlobalCodes;
            DropDownList_CustomDocumentGambling_School.DataBind();

            DropDownList_CustomDocumentGambling_RelationshipWithChildren.DataTextField = "CodeName";
            DropDownList_CustomDocumentGambling_RelationshipWithChildren.DataValueField = "GlobalCodeId";
            DropDownList_CustomDocumentGambling_RelationshipWithChildren.DataSource = dataViewGlobalCodes;
            DropDownList_CustomDocumentGambling_RelationshipWithChildren.DataBind();

            DropDownList_CustomDocumentGambling_SpiritualWellbeing.DataTextField = "CodeName";
            DropDownList_CustomDocumentGambling_SpiritualWellbeing.DataValueField = "GlobalCodeId";
            DropDownList_CustomDocumentGambling_SpiritualWellbeing.DataSource = dataViewGlobalCodes;
            DropDownList_CustomDocumentGambling_SpiritualWellbeing.DataBind();

            DropDownList_CustomDocumentGambling_AccomplishedResponsibilitiesAtWork.DataTextField = "CodeName";
            DropDownList_CustomDocumentGambling_AccomplishedResponsibilitiesAtWork.DataValueField = "GlobalCodeId";
            DropDownList_CustomDocumentGambling_AccomplishedResponsibilitiesAtWork.DataSource = dataViewGlobalCodes;
            DropDownList_CustomDocumentGambling_AccomplishedResponsibilitiesAtWork.DataBind();

            DropDownList_CustomDocumentGambling_ProblemsAssociatedWithIllegalDrugs.DataTextField = "CodeName";
            DropDownList_CustomDocumentGambling_ProblemsAssociatedWithIllegalDrugs.DataValueField = "GlobalCodeId";
            DropDownList_CustomDocumentGambling_ProblemsAssociatedWithIllegalDrugs.DataSource = dataViewGlobalCodes;
            DropDownList_CustomDocumentGambling_ProblemsAssociatedWithIllegalDrugs.DataBind();

            DropDownList_CustomDocumentGambling_PaidBillsOnTime.DataTextField = "CodeName";
            DropDownList_CustomDocumentGambling_PaidBillsOnTime.DataValueField = "GlobalCodeId";
            DropDownList_CustomDocumentGambling_PaidBillsOnTime.DataSource = dataViewGlobalCodes;
            DropDownList_CustomDocumentGambling_PaidBillsOnTime.DataBind();

            DropDownList_CustomDocumentGambling_UseOfTobacco.DataTextField = "CodeName";
            DropDownList_CustomDocumentGambling_UseOfTobacco.DataValueField = "GlobalCodeId";
            DropDownList_CustomDocumentGambling_UseOfTobacco.DataSource = dataViewGlobalCodes;
            DropDownList_CustomDocumentGambling_UseOfTobacco.DataBind();

            DropDownList_CustomDocumentGambling_AccomplishedResponsibilitiesAtHome.DataTextField = "CodeName";
            DropDownList_CustomDocumentGambling_AccomplishedResponsibilitiesAtHome.DataValueField = "GlobalCodeId";
            DropDownList_CustomDocumentGambling_AccomplishedResponsibilitiesAtHome.DataSource = dataViewGlobalCodes;
            DropDownList_CustomDocumentGambling_AccomplishedResponsibilitiesAtHome.DataBind();

            DropDownList_CustomDocumentGambling_CommitIllegalActs.DataTextField = "CodeName";
            DropDownList_CustomDocumentGambling_CommitIllegalActs.DataValueField = "GlobalCodeId";
            DropDownList_CustomDocumentGambling_CommitIllegalActs.DataSource = dataViewGlobalCodes;
            DropDownList_CustomDocumentGambling_CommitIllegalActs.DataBind();

            DropDownList_CustomDocumentGambling_HaveThoughtsOfSuicide.DataTextField = "CodeName";
            DropDownList_CustomDocumentGambling_HaveThoughtsOfSuicide.DataValueField = "GlobalCodeId";
            DropDownList_CustomDocumentGambling_HaveThoughtsOfSuicide.DataSource = dataViewGlobalCodes;
            DropDownList_CustomDocumentGambling_HaveThoughtsOfSuicide.DataBind();

            DropDownList_CustomDocumentGambling_MaintainSupportiveNetworkOfFamily.DataTextField = "CodeName";
            DropDownList_CustomDocumentGambling_MaintainSupportiveNetworkOfFamily.DataValueField = "GlobalCodeId";
            DropDownList_CustomDocumentGambling_MaintainSupportiveNetworkOfFamily.DataSource = dataViewGlobalCodes;
            DropDownList_CustomDocumentGambling_MaintainSupportiveNetworkOfFamily.DataBind();

            DropDownList_CustomDocumentGambling_AttemptToCommitSuicide.DataTextField = "CodeName";
            DropDownList_CustomDocumentGambling_AttemptToCommitSuicide.DataValueField = "GlobalCodeId";
            DropDownList_CustomDocumentGambling_AttemptToCommitSuicide.DataSource = dataViewGlobalCodes;
            DropDownList_CustomDocumentGambling_AttemptToCommitSuicide.DataBind();

            DropDownList_CustomDocumentGambling_DrinkAlcohol.DataTextField = "CodeName";
            DropDownList_CustomDocumentGambling_DrinkAlcohol.DataValueField = "GlobalCodeId";
            DropDownList_CustomDocumentGambling_DrinkAlcohol.DataSource = dataViewGlobalCodes;
            DropDownList_CustomDocumentGambling_DrinkAlcohol.DataBind();

            DropDownList_CustomDocumentGambling_EatHealthyFood.DataTextField = "CodeName";
            DropDownList_CustomDocumentGambling_EatHealthyFood.DataValueField = "GlobalCodeId";
            DropDownList_CustomDocumentGambling_EatHealthyFood.DataSource = dataViewGlobalCodes;
            DropDownList_CustomDocumentGambling_EatHealthyFood.DataBind();

            DropDownList_CustomDocumentGambling_ProblemsAssociatedWithAlcohol.DataTextField = "CodeName";
            DropDownList_CustomDocumentGambling_ProblemsAssociatedWithAlcohol.DataValueField = "GlobalCodeId";
            DropDownList_CustomDocumentGambling_ProblemsAssociatedWithAlcohol.DataSource = dataViewGlobalCodes;
            DropDownList_CustomDocumentGambling_ProblemsAssociatedWithAlcohol.DataBind();

            DropDownList_CustomDocumentGambling_Exercise.DataTextField = "CodeName";
            DropDownList_CustomDocumentGambling_Exercise.DataValueField = "GlobalCodeId";
            DropDownList_CustomDocumentGambling_Exercise.DataSource = dataViewGlobalCodes;
            DropDownList_CustomDocumentGambling_Exercise.DataBind();

            DropDownList_CustomDocumentGambling_UseOfIllegalDrugs.DataTextField = "CodeName";
            DropDownList_CustomDocumentGambling_UseOfIllegalDrugs.DataValueField = "GlobalCodeId";
            DropDownList_CustomDocumentGambling_UseOfIllegalDrugs.DataSource = dataViewGlobalCodes;
            DropDownList_CustomDocumentGambling_UseOfIllegalDrugs.DataBind();

           
            DropDownList_CustomDocumentGambling_TakeTimeToRelax.DataTextField = "CodeName";
            DropDownList_CustomDocumentGambling_TakeTimeToRelax.DataValueField = "GlobalCodeId";
            DropDownList_CustomDocumentGambling_TakeTimeToRelax.DataSource = dataViewGlobalCodes;
            DropDownList_CustomDocumentGambling_TakeTimeToRelax.DataBind();

            DropDownList_CustomDocumentGambling_AttendCommunitySupport.DataTextField = "CodeName";
            DropDownList_CustomDocumentGambling_AttendCommunitySupport.DataValueField = "GlobalCodeId";
            DropDownList_CustomDocumentGambling_AttendCommunitySupport.DataSource = dataViewGlobalCodes;
            DropDownList_CustomDocumentGambling_AttendCommunitySupport.DataBind();

            foreach (Control ctrl in this.Controls)
            {
                if (ctrl is Streamline.DotNetDropDownGlobalCodes.DropDownGlobalCodes)
                {
                    ((Streamline.DotNetDropDownGlobalCodes.DropDownGlobalCodes)ctrl).DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
                    ((Streamline.DotNetDropDownGlobalCodes.DropDownGlobalCodes)ctrl).FillDropDownDropGlobalCodes();
                    continue;
                }
            }
        }
    }



}

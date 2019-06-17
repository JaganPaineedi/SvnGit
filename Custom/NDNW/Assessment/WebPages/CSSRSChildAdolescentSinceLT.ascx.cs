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
using SHS.BaseLayer;
using SHS.BaseLayer.ActivityPages;
namespace SHS.SmartCare
{
    public partial class Custom_Assessment_WebPages_CSSRSChildAdolescentSinceLT : SHS.BaseLayer.ActivityPages.DataActivityTab
    {
        public override void BindControls()
        {
            DataSet ds = BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet;
            using (DataView DataViewGlobalCodes = BaseCommonFunctions.FillDropDown("XCSSRSYESNO", true, "", "", false))
            {
                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_WishToBeDead.DataTextField = "CodeName";
                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_WishToBeDead.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_WishToBeDead.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_WishToBeDead.DataBind();
                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_WishToBeDead.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_NonSpecificActiveSuicidalThoughts.DataTextField = "CodeName";
                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_NonSpecificActiveSuicidalThoughts.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_NonSpecificActiveSuicidalThoughts.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_NonSpecificActiveSuicidalThoughts.DataBind();
                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_NonSpecificActiveSuicidalThoughts.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_ActiveSuicidalIdeationWithAnyMethodsWithoutIntentToAct.DataTextField = "CodeName";
                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_ActiveSuicidalIdeationWithAnyMethodsWithoutIntentToAct.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_ActiveSuicidalIdeationWithAnyMethodsWithoutIntentToAct.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_ActiveSuicidalIdeationWithAnyMethodsWithoutIntentToAct.DataBind();
                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_ActiveSuicidalIdeationWithAnyMethodsWithoutIntentToAct.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_ActiveSuicidalIdeationWithSomeIntentToActWithoutSpecificPlan.DataTextField = "CodeName";
                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_ActiveSuicidalIdeationWithSomeIntentToActWithoutSpecificPlan.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_ActiveSuicidalIdeationWithSomeIntentToActWithoutSpecificPlan.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_ActiveSuicidalIdeationWithSomeIntentToActWithoutSpecificPlan.DataBind();
                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_ActiveSuicidalIdeationWithSomeIntentToActWithoutSpecificPlan.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_AciveSuicidalIdeationWithSpecificPlanAndIntent.DataTextField = "CodeName";
                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_AciveSuicidalIdeationWithSpecificPlanAndIntent.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_AciveSuicidalIdeationWithSpecificPlanAndIntent.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_AciveSuicidalIdeationWithSpecificPlanAndIntent.DataBind();
                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_AciveSuicidalIdeationWithSpecificPlanAndIntent.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_ActualAttempt.DataTextField = "CodeName";
                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_ActualAttempt.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_ActualAttempt.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_ActualAttempt.DataBind();
                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_ActualAttempt.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_HasSubjectEngagedInNonSuicidalSelfInjuriousBehavior.DataTextField = "CodeName";
                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_HasSubjectEngagedInNonSuicidalSelfInjuriousBehavior.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_HasSubjectEngagedInNonSuicidalSelfInjuriousBehavior.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_HasSubjectEngagedInNonSuicidalSelfInjuriousBehavior.DataBind();
                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_HasSubjectEngagedInNonSuicidalSelfInjuriousBehavior.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_HasSubjectEngagedInSelfInjuriousBehaviorIntentUnknown.DataTextField = "CodeName";
                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_HasSubjectEngagedInSelfInjuriousBehaviorIntentUnknown.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_HasSubjectEngagedInSelfInjuriousBehaviorIntentUnknown.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_HasSubjectEngagedInSelfInjuriousBehaviorIntentUnknown.DataBind();
                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_HasSubjectEngagedInSelfInjuriousBehaviorIntentUnknown.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_InterruptedAttempt.DataTextField = "CodeName";
                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_InterruptedAttempt.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_InterruptedAttempt.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_InterruptedAttempt.DataBind();
                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_InterruptedAttempt.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_AbortedOrSelfInterruptedAttempt.DataTextField = "CodeName";
                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_AbortedOrSelfInterruptedAttempt.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_AbortedOrSelfInterruptedAttempt.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_AbortedOrSelfInterruptedAttempt.DataBind();
                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_AbortedOrSelfInterruptedAttempt.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_PreparatoryActsOrBehavior.DataTextField = "CodeName";
                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_PreparatoryActsOrBehavior.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_PreparatoryActsOrBehavior.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_PreparatoryActsOrBehavior.DataBind();
                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_PreparatoryActsOrBehavior.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_SuicidalBehavior.DataTextField = "CodeName";
                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_SuicidalBehavior.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_SuicidalBehavior.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_SuicidalBehavior.DataBind();
                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_SuicidalBehavior.Items.Insert(0, new ListItem("", ""));
            }
            using (DataView DataViewGlobalCodes = BaseCommonFunctions.FillDropDown("XCSSRSCASLTSEVERE", true, "", "", false))
            {
                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_MostSevereIdeation.DataTextField = "CodeName";
                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_MostSevereIdeation.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_MostSevereIdeation.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_MostSevereIdeation.DataBind();
                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_MostSevereIdeation.Items.Insert(0, new ListItem("", ""));
            }
            using (DataView DataViewGlobalCodes = BaseCommonFunctions.FillDropDown("XCSSRSCASLTFREQUENCY", true, "", "", false))
            {
                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_Frequency.DataTextField = "CodeName";
                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_Frequency.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_Frequency.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_Frequency.DataBind();
                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_Frequency.Items.Insert(0, new ListItem("", ""));
            }

            using (DataView DataViewGlobalCodes = BaseCommonFunctions.FillDropDown("XActualLethality", true, "", "", false))
            {
                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_ActualLethalityMedicalDamage.DataTextField = "CodeName";
                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_ActualLethalityMedicalDamage.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_ActualLethalityMedicalDamage.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_ActualLethalityMedicalDamage.DataBind();
                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_ActualLethalityMedicalDamage.Items.Insert(0, new ListItem("", ""));
            }

            using (DataView DataViewGlobalCodes = BaseCommonFunctions.FillDropDown("XPotentialLethality", true, "", "", false))
            {
                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_PotentialLethality.DataTextField = "CodeName";
                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_PotentialLethality.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_PotentialLethality.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_PotentialLethality.DataBind();
                DropDownList_CustomDocumentCSSRSChildSinceLastVisits_PotentialLethality.Items.Insert(0, new ListItem("", ""));
            }
        }
    }
}
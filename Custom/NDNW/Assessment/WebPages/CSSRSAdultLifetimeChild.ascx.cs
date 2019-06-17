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


namespace SHS.SmartCare
{
    public partial class Custom_Assessment_WebPages_CSSRSAdultLifetimeChild : SHS.BaseLayer.ActivityPages.DataActivityTab
    {
        public override void BindControls()
        {
            using (DataView DataViewGlobalCodes = BaseCommonFunctions.FillDropDown("XCSSRSYESNO", true, "", "", false))
            {
                DropDownList_CustomDocumentChildLTs_DeadLifeTime.DataTextField = "CodeName";
                DropDownList_CustomDocumentChildLTs_DeadLifeTime.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentChildLTs_DeadLifeTime.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentChildLTs_DeadLifeTime.DataBind();
                DropDownList_CustomDocumentChildLTs_DeadLifeTime.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentChildLTs_DeadPast1Month.DataTextField = "CodeName";
                DropDownList_CustomDocumentChildLTs_DeadPast1Month.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentChildLTs_DeadPast1Month.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentChildLTs_DeadPast1Month.DataBind();
                DropDownList_CustomDocumentChildLTs_DeadPast1Month.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentChildLTs_NonSpecificLifeTime.DataTextField = "CodeName";
                DropDownList_CustomDocumentChildLTs_NonSpecificLifeTime.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentChildLTs_NonSpecificLifeTime.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentChildLTs_NonSpecificLifeTime.DataBind();
                DropDownList_CustomDocumentChildLTs_NonSpecificLifeTime.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentChildLTs_NonSpecificPast1Month.DataTextField = "CodeName";
                DropDownList_CustomDocumentChildLTs_NonSpecificPast1Month.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentChildLTs_NonSpecificPast1Month.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentChildLTs_NonSpecificPast1Month.DataBind();
                DropDownList_CustomDocumentChildLTs_NonSpecificPast1Month.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentChildLTs_ActiveSuicidalIdeationLifeTime.DataTextField = "CodeName";
                DropDownList_CustomDocumentChildLTs_ActiveSuicidalIdeationLifeTime.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentChildLTs_ActiveSuicidalIdeationLifeTime.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentChildLTs_ActiveSuicidalIdeationLifeTime.DataBind();
                DropDownList_CustomDocumentChildLTs_ActiveSuicidalIdeationLifeTime.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentChildLTs_ActiveSuicidalIdeationPast1Month.DataTextField = "CodeName";
                DropDownList_CustomDocumentChildLTs_ActiveSuicidalIdeationPast1Month.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentChildLTs_ActiveSuicidalIdeationPast1Month.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentChildLTs_ActiveSuicidalIdeationPast1Month.DataBind();
                DropDownList_CustomDocumentChildLTs_ActiveSuicidalIdeationPast1Month.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentChildLTs_ASILifeTime.DataTextField = "CodeName";
                DropDownList_CustomDocumentChildLTs_ASILifeTime.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentChildLTs_ASILifeTime.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentChildLTs_ASILifeTime.DataBind();
                DropDownList_CustomDocumentChildLTs_ASILifeTime.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentChildLTs_ASIPast1Month.DataTextField = "CodeName";
                DropDownList_CustomDocumentChildLTs_ASIPast1Month.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentChildLTs_ASIPast1Month.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentChildLTs_ASIPast1Month.DataBind();
                DropDownList_CustomDocumentChildLTs_ASIPast1Month.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentChildLTs_ASISPILifeTime.DataTextField = "CodeName";
                DropDownList_CustomDocumentChildLTs_ASISPILifeTime.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentChildLTs_ASISPILifeTime.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentChildLTs_ASISPILifeTime.DataBind();
                DropDownList_CustomDocumentChildLTs_ASISPILifeTime.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentChildLTs_ASISPIPast1Month.DataTextField = "CodeName";
                DropDownList_CustomDocumentChildLTs_ASISPIPast1Month.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentChildLTs_ASISPIPast1Month.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentChildLTs_ASISPIPast1Month.DataBind();
                DropDownList_CustomDocumentChildLTs_ASISPIPast1Month.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentChildLTs_SuicidalBehaviourLifeTime.DataTextField = "CodeName";
                DropDownList_CustomDocumentChildLTs_SuicidalBehaviourLifeTime.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentChildLTs_SuicidalBehaviourLifeTime.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentChildLTs_SuicidalBehaviourLifeTime.DataBind();
                DropDownList_CustomDocumentChildLTs_SuicidalBehaviourLifeTime.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentChildLTs_SuicidalBehaviourPast3Monts.DataTextField = "CodeName";
                DropDownList_CustomDocumentChildLTs_SuicidalBehaviourPast3Monts.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentChildLTs_SuicidalBehaviourPast3Monts.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentChildLTs_SuicidalBehaviourPast3Monts.DataBind();
                DropDownList_CustomDocumentChildLTs_SuicidalBehaviourPast3Monts.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentChildLTs_SelfInjuriesOne.DataTextField = "CodeName";
                DropDownList_CustomDocumentChildLTs_SelfInjuriesOne.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentChildLTs_SelfInjuriesOne.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentChildLTs_SelfInjuriesOne.DataBind();
                DropDownList_CustomDocumentChildLTs_SelfInjuriesOne.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentChildLTs_SuicidalBehaviourPast3Monts.DataTextField = "CodeName";
                DropDownList_CustomDocumentChildLTs_SuicidalBehaviourPast3Monts.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentChildLTs_SuicidalBehaviourPast3Monts.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentChildLTs_SuicidalBehaviourPast3Monts.DataBind();
                DropDownList_CustomDocumentChildLTs_SuicidalBehaviourPast3Monts.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentChildLTs_SelfInjuriesTwo.DataTextField = "CodeName";
                DropDownList_CustomDocumentChildLTs_SelfInjuriesTwo.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentChildLTs_SelfInjuriesTwo.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentChildLTs_SelfInjuriesTwo.DataBind();
                DropDownList_CustomDocumentChildLTs_SelfInjuriesTwo.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentChildLTs_InterruptedAttemptLifeTime.DataTextField = "CodeName";
                DropDownList_CustomDocumentChildLTs_InterruptedAttemptLifeTime.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentChildLTs_InterruptedAttemptLifeTime.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentChildLTs_InterruptedAttemptLifeTime.DataBind();
                DropDownList_CustomDocumentChildLTs_InterruptedAttemptLifeTime.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentChildLTs_InterruptedAttemptPast3Months.DataTextField = "CodeName";
                DropDownList_CustomDocumentChildLTs_InterruptedAttemptPast3Months.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentChildLTs_InterruptedAttemptPast3Months.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentChildLTs_InterruptedAttemptPast3Months.DataBind();
                DropDownList_CustomDocumentChildLTs_InterruptedAttemptPast3Months.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentChildLTs_AbortedLifeTime.DataTextField = "CodeName";
                DropDownList_CustomDocumentChildLTs_AbortedLifeTime.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentChildLTs_AbortedLifeTime.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentChildLTs_AbortedLifeTime.DataBind();
                DropDownList_CustomDocumentChildLTs_AbortedLifeTime.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentChildLTs_AbortedPast3Months.DataTextField = "CodeName";
                DropDownList_CustomDocumentChildLTs_AbortedPast3Months.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentChildLTs_AbortedPast3Months.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentChildLTs_AbortedPast3Months.DataBind();
                DropDownList_CustomDocumentChildLTs_AbortedPast3Months.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentChildLTs_PreparatoryLifeTime.DataTextField = "CodeName";
                DropDownList_CustomDocumentChildLTs_PreparatoryLifeTime.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentChildLTs_PreparatoryLifeTime.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentChildLTs_PreparatoryLifeTime.DataBind();
                DropDownList_CustomDocumentChildLTs_PreparatoryLifeTime.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentChildLTs_PreparatoryPast3Months.DataTextField = "CodeName";
                DropDownList_CustomDocumentChildLTs_PreparatoryPast3Months.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentChildLTs_PreparatoryPast3Months.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentChildLTs_PreparatoryPast3Months.DataBind();
                DropDownList_CustomDocumentChildLTs_PreparatoryPast3Months.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentChildLTs_SuicidalBehaviorLifeTime.DataTextField = "CodeName";
                DropDownList_CustomDocumentChildLTs_SuicidalBehaviorLifeTime.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentChildLTs_SuicidalBehaviorLifeTime.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentChildLTs_SuicidalBehaviorLifeTime.DataBind();
                DropDownList_CustomDocumentChildLTs_SuicidalBehaviorLifeTime.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentChildLTs_SuicidalBehaviorPast3Months.DataTextField = "CodeName";
                DropDownList_CustomDocumentChildLTs_SuicidalBehaviorPast3Months.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentChildLTs_SuicidalBehaviorPast3Months.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentChildLTs_SuicidalBehaviorPast3Months.DataBind();
                DropDownList_CustomDocumentChildLTs_SuicidalBehaviorPast3Months.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentChildLTs_SelfInjuriesIntentOne.DataTextField = "CodeName";
                DropDownList_CustomDocumentChildLTs_SelfInjuriesIntentOne.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentChildLTs_SelfInjuriesIntentOne.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentChildLTs_SelfInjuriesIntentOne.DataBind();
                DropDownList_CustomDocumentChildLTs_SelfInjuriesIntentOne.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentChildLTs_SelfInjuriesIntentTwo.DataTextField = "CodeName";
                DropDownList_CustomDocumentChildLTs_SelfInjuriesIntentTwo.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentChildLTs_SelfInjuriesIntentTwo.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentChildLTs_SelfInjuriesIntentTwo.DataBind();
                DropDownList_CustomDocumentChildLTs_SelfInjuriesIntentTwo.Items.Insert(0, new ListItem("", ""));
            }
            using (DataView DataViewGlobalCodes = BaseCommonFunctions.FillDropDown("XSEVERITY", true, "", "", false))
            {
                DropDownList_CustomDocumentChildLTs_LifeTimeMostSevere.DataTextField = "CodeName";
                DropDownList_CustomDocumentChildLTs_LifeTimeMostSevere.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentChildLTs_LifeTimeMostSevere.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentChildLTs_LifeTimeMostSevere.DataBind();
                DropDownList_CustomDocumentChildLTs_LifeTimeMostSevere.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentChildLTs_RecentMostSevere.DataTextField = "CodeName";
                DropDownList_CustomDocumentChildLTs_RecentMostSevere.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentChildLTs_RecentMostSevere.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentChildLTs_RecentMostSevere.DataBind();
                DropDownList_CustomDocumentChildLTs_RecentMostSevere.Items.Insert(0, new ListItem("", ""));
            }
            using (DataView DataViewGlobalCodes = BaseCommonFunctions.FillDropDown("FREQUENCYONE", true, "", "", false))
            {
                DropDownList_CustomDocumentChildLTs_FrequencyMostSevereOne.DataTextField = "CodeName";
                DropDownList_CustomDocumentChildLTs_FrequencyMostSevereOne.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentChildLTs_FrequencyMostSevereOne.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentChildLTs_FrequencyMostSevereOne.DataBind();
                DropDownList_CustomDocumentChildLTs_FrequencyMostSevereOne.Items.Insert(0, new ListItem("", ""));
            }

            using (DataView DataViewGlobalCodes = BaseCommonFunctions.FillDropDown("FREQUENCYTWO", true, "", "", false))
            {
                DropDownList_CustomDocumentChildLTs_FrequencyMostSevereTwo.DataTextField = "CodeName";
                DropDownList_CustomDocumentChildLTs_FrequencyMostSevereTwo.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentChildLTs_FrequencyMostSevereTwo.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentChildLTs_FrequencyMostSevereTwo.DataBind();
                DropDownList_CustomDocumentChildLTs_FrequencyMostSevereTwo.Items.Insert(0, new ListItem("", ""));
            }

            using (DataView DataViewGlobalCodes = BaseCommonFunctions.FillDropDown("XActualLethality", true, "", "", false))
            {
                DropDownList_CustomDocumentChildLTs_ActualLethality1.DataTextField = "CodeName";
                DropDownList_CustomDocumentChildLTs_ActualLethality1.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentChildLTs_ActualLethality1.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentChildLTs_ActualLethality1.DataBind();
                DropDownList_CustomDocumentChildLTs_ActualLethality1.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentChildLTs_ActualLethality2.DataTextField = "CodeName";
                DropDownList_CustomDocumentChildLTs_ActualLethality2.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentChildLTs_ActualLethality2.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentChildLTs_ActualLethality2.DataBind();
                DropDownList_CustomDocumentChildLTs_ActualLethality2.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentChildLTs_ActualLethality3.DataTextField = "CodeName";
                DropDownList_CustomDocumentChildLTs_ActualLethality3.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentChildLTs_ActualLethality3.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentChildLTs_ActualLethality3.DataBind();
                DropDownList_CustomDocumentChildLTs_ActualLethality3.Items.Insert(0, new ListItem("", ""));
            }

            using (DataView DataViewGlobalCodes = BaseCommonFunctions.FillDropDown("XPotentialLethality", true, "", "", false))
            {
                DropDownList_CustomDocumentChildLTs_PotentialLethality1.DataTextField = "CodeName";
                DropDownList_CustomDocumentChildLTs_PotentialLethality1.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentChildLTs_PotentialLethality1.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentChildLTs_PotentialLethality1.DataBind();
                DropDownList_CustomDocumentChildLTs_PotentialLethality1.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentChildLTs_PotentialLethality2.DataTextField = "CodeName";
                DropDownList_CustomDocumentChildLTs_PotentialLethality2.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentChildLTs_PotentialLethality2.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentChildLTs_PotentialLethality2.DataBind();
                DropDownList_CustomDocumentChildLTs_PotentialLethality2.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentChildLTs_PotentialLethality3.DataTextField = "CodeName";
                DropDownList_CustomDocumentChildLTs_PotentialLethality3.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentChildLTs_PotentialLethality3.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentChildLTs_PotentialLethality3.DataBind();
                DropDownList_CustomDocumentChildLTs_PotentialLethality3.Items.Insert(0, new ListItem("", ""));
            }
        }
    }
}



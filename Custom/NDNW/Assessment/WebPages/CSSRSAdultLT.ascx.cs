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
    public partial class Custom_Assessment_WebPages_CSSRSAdultLT : SHS.BaseLayer.ActivityPages.DataActivityTab
    {
        public override void BindControls()
        {
            using (DataView DataViewGlobalCodes = BaseCommonFunctions.FillDropDown("XCSSRSYESNO", true, "", "", false))
            {
                DropDownList_CustomDocumentAdultLTs_DeadLifeTime.DataTextField = "CodeName";
                DropDownList_CustomDocumentAdultLTs_DeadLifeTime.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentAdultLTs_DeadLifeTime.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentAdultLTs_DeadLifeTime.DataBind();
                DropDownList_CustomDocumentAdultLTs_DeadLifeTime.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentAdultLTs_DeadPast1Month.DataTextField = "CodeName";
                DropDownList_CustomDocumentAdultLTs_DeadPast1Month.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentAdultLTs_DeadPast1Month.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentAdultLTs_DeadPast1Month.DataBind();
                DropDownList_CustomDocumentAdultLTs_DeadPast1Month.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentAdultLTs_NonSpecificLifeTime.DataTextField = "CodeName";
                DropDownList_CustomDocumentAdultLTs_NonSpecificLifeTime.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentAdultLTs_NonSpecificLifeTime.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentAdultLTs_NonSpecificLifeTime.DataBind();
                DropDownList_CustomDocumentAdultLTs_NonSpecificLifeTime.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentAdultLTs_NonSpecificPast1Month.DataTextField = "CodeName";
                DropDownList_CustomDocumentAdultLTs_NonSpecificPast1Month.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentAdultLTs_NonSpecificPast1Month.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentAdultLTs_NonSpecificPast1Month.DataBind();
                DropDownList_CustomDocumentAdultLTs_NonSpecificPast1Month.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentAdultLTs_ActiveSuicidalIdeationLifeTime.DataTextField = "CodeName";
                DropDownList_CustomDocumentAdultLTs_ActiveSuicidalIdeationLifeTime.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentAdultLTs_ActiveSuicidalIdeationLifeTime.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentAdultLTs_ActiveSuicidalIdeationLifeTime.DataBind();
                DropDownList_CustomDocumentAdultLTs_ActiveSuicidalIdeationLifeTime.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentAdultLTs_ActiveSuicidalIdeationPast1Month.DataTextField = "CodeName";
                DropDownList_CustomDocumentAdultLTs_ActiveSuicidalIdeationPast1Month.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentAdultLTs_ActiveSuicidalIdeationPast1Month.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentAdultLTs_ActiveSuicidalIdeationPast1Month.DataBind();
                DropDownList_CustomDocumentAdultLTs_ActiveSuicidalIdeationPast1Month.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentAdultLTs_ASILifeTime.DataTextField = "CodeName";
                DropDownList_CustomDocumentAdultLTs_ASILifeTime.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentAdultLTs_ASILifeTime.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentAdultLTs_ASILifeTime.DataBind();
                DropDownList_CustomDocumentAdultLTs_ASILifeTime.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentAdultLTs_ASIPast1Month.DataTextField = "CodeName";
                DropDownList_CustomDocumentAdultLTs_ASIPast1Month.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentAdultLTs_ASIPast1Month.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentAdultLTs_ASIPast1Month.DataBind();
                DropDownList_CustomDocumentAdultLTs_ASIPast1Month.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentAdultLTs_ASISPILifeTime.DataTextField = "CodeName";
                DropDownList_CustomDocumentAdultLTs_ASISPILifeTime.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentAdultLTs_ASISPILifeTime.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentAdultLTs_ASISPILifeTime.DataBind();
                DropDownList_CustomDocumentAdultLTs_ASISPILifeTime.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentAdultLTs_ASISPIPast1Month.DataTextField = "CodeName";
                DropDownList_CustomDocumentAdultLTs_ASISPIPast1Month.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentAdultLTs_ASISPIPast1Month.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentAdultLTs_ASISPIPast1Month.DataBind();
                DropDownList_CustomDocumentAdultLTs_ASISPIPast1Month.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentAdultLTs_SuicidalBehaviourLifeTime.DataTextField = "CodeName";
                DropDownList_CustomDocumentAdultLTs_SuicidalBehaviourLifeTime.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentAdultLTs_SuicidalBehaviourLifeTime.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentAdultLTs_SuicidalBehaviourLifeTime.DataBind();
                DropDownList_CustomDocumentAdultLTs_SuicidalBehaviourLifeTime.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentAdultLTs_SuicidalBehaviourPast3Monts.DataTextField = "CodeName";
                DropDownList_CustomDocumentAdultLTs_SuicidalBehaviourPast3Monts.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentAdultLTs_SuicidalBehaviourPast3Monts.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentAdultLTs_SuicidalBehaviourPast3Monts.DataBind();
                DropDownList_CustomDocumentAdultLTs_SuicidalBehaviourPast3Monts.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentAdultLTs_SelfInjuriesOne.DataTextField = "CodeName";
                DropDownList_CustomDocumentAdultLTs_SelfInjuriesOne.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentAdultLTs_SelfInjuriesOne.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentAdultLTs_SelfInjuriesOne.DataBind();
                DropDownList_CustomDocumentAdultLTs_SelfInjuriesOne.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentAdultLTs_SuicidalBehaviourPast3Monts.DataTextField = "CodeName";
                DropDownList_CustomDocumentAdultLTs_SuicidalBehaviourPast3Monts.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentAdultLTs_SuicidalBehaviourPast3Monts.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentAdultLTs_SuicidalBehaviourPast3Monts.DataBind();
                DropDownList_CustomDocumentAdultLTs_SuicidalBehaviourPast3Monts.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentAdultLTs_SelfInjuriesTwo.DataTextField = "CodeName";
                DropDownList_CustomDocumentAdultLTs_SelfInjuriesTwo.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentAdultLTs_SelfInjuriesTwo.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentAdultLTs_SelfInjuriesTwo.DataBind();
                DropDownList_CustomDocumentAdultLTs_SelfInjuriesTwo.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentAdultLTs_InterruptedAttemptLifeTime.DataTextField = "CodeName";
                DropDownList_CustomDocumentAdultLTs_InterruptedAttemptLifeTime.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentAdultLTs_InterruptedAttemptLifeTime.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentAdultLTs_InterruptedAttemptLifeTime.DataBind();
                DropDownList_CustomDocumentAdultLTs_InterruptedAttemptLifeTime.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentAdultLTs_InterruptedAttemptPast3Months.DataTextField = "CodeName";
                DropDownList_CustomDocumentAdultLTs_InterruptedAttemptPast3Months.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentAdultLTs_InterruptedAttemptPast3Months.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentAdultLTs_InterruptedAttemptPast3Months.DataBind();
                DropDownList_CustomDocumentAdultLTs_InterruptedAttemptPast3Months.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentAdultLTs_AbortedLifeTime.DataTextField = "CodeName";
                DropDownList_CustomDocumentAdultLTs_AbortedLifeTime.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentAdultLTs_AbortedLifeTime.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentAdultLTs_AbortedLifeTime.DataBind();
                DropDownList_CustomDocumentAdultLTs_AbortedLifeTime.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentAdultLTs_AbortedPast3Months.DataTextField = "CodeName";
                DropDownList_CustomDocumentAdultLTs_AbortedPast3Months.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentAdultLTs_AbortedPast3Months.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentAdultLTs_AbortedPast3Months.DataBind();
                DropDownList_CustomDocumentAdultLTs_AbortedPast3Months.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentAdultLTs_PreparatoryLifeTime.DataTextField = "CodeName";
                DropDownList_CustomDocumentAdultLTs_PreparatoryLifeTime.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentAdultLTs_PreparatoryLifeTime.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentAdultLTs_PreparatoryLifeTime.DataBind();
                DropDownList_CustomDocumentAdultLTs_PreparatoryLifeTime.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentAdultLTs_preparatoryPast3Months.DataTextField = "CodeName";
                DropDownList_CustomDocumentAdultLTs_preparatoryPast3Months.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentAdultLTs_preparatoryPast3Months.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentAdultLTs_preparatoryPast3Months.DataBind();
                DropDownList_CustomDocumentAdultLTs_preparatoryPast3Months.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentAdultLTs_SuicidalBehaviorLifeTime.DataTextField = "CodeName";
                DropDownList_CustomDocumentAdultLTs_SuicidalBehaviorLifeTime.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentAdultLTs_SuicidalBehaviorLifeTime.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentAdultLTs_SuicidalBehaviorLifeTime.DataBind();
                DropDownList_CustomDocumentAdultLTs_SuicidalBehaviorLifeTime.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentAdultLTs_SuicidalBehaviorPast3Months.DataTextField = "CodeName";
                DropDownList_CustomDocumentAdultLTs_SuicidalBehaviorPast3Months.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentAdultLTs_SuicidalBehaviorPast3Months.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentAdultLTs_SuicidalBehaviorPast3Months.DataBind();
                DropDownList_CustomDocumentAdultLTs_SuicidalBehaviorPast3Months.Items.Insert(0, new ListItem("", ""));              
            }
            using (DataView DataViewGlobalCodes = BaseCommonFunctions.FillDropDown("XSEVERITY", true, "", "", false))
            {
                DropDownList_CustomDocumentAdultLTs_LifeTimeMostSevere.DataTextField = "CodeName";
                DropDownList_CustomDocumentAdultLTs_LifeTimeMostSevere.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentAdultLTs_LifeTimeMostSevere.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentAdultLTs_LifeTimeMostSevere.DataBind();
                DropDownList_CustomDocumentAdultLTs_LifeTimeMostSevere.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentAdultLTs_RecentMostSevere.DataTextField = "CodeName";
                DropDownList_CustomDocumentAdultLTs_RecentMostSevere.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentAdultLTs_RecentMostSevere.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentAdultLTs_RecentMostSevere.DataBind();
                DropDownList_CustomDocumentAdultLTs_RecentMostSevere.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentAdultLTs_DurationMostSevereOne.DataTextField = "CodeName";
                DropDownList_CustomDocumentAdultLTs_DurationMostSevereOne.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentAdultLTs_DurationMostSevereOne.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentAdultLTs_DurationMostSevereOne.DataBind();
                DropDownList_CustomDocumentAdultLTs_DurationMostSevereOne.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentAdultLTs_DurationMostSevereTwo.DataTextField = "CodeName";
                DropDownList_CustomDocumentAdultLTs_DurationMostSevereTwo.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentAdultLTs_DurationMostSevereTwo.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentAdultLTs_DurationMostSevereTwo.DataBind();
                DropDownList_CustomDocumentAdultLTs_DurationMostSevereTwo.Items.Insert(0, new ListItem("", ""));            
            }
            using (DataView DataViewGlobalCodes = BaseCommonFunctions.FillDropDown("XFrequencyOne", true, "", "", false))
            {
                DropDownList_CustomDocumentAdultLTs_FrequencyMostSevereOne.DataTextField = "CodeName";
                DropDownList_CustomDocumentAdultLTs_FrequencyMostSevereOne.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentAdultLTs_FrequencyMostSevereOne.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentAdultLTs_FrequencyMostSevereOne.DataBind();
                DropDownList_CustomDocumentAdultLTs_FrequencyMostSevereOne.Items.Insert(0, new ListItem("", ""));             
            }

            using (DataView DataViewGlobalCodes = BaseCommonFunctions.FillDropDown("XFrequencyTwo", true, "", "", false))
            {
                DropDownList_CustomDocumentAdultLTs_FrequencyMostSevereTwo.DataTextField = "CodeName";
                DropDownList_CustomDocumentAdultLTs_FrequencyMostSevereTwo.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentAdultLTs_FrequencyMostSevereTwo.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentAdultLTs_FrequencyMostSevereTwo.DataBind();
                DropDownList_CustomDocumentAdultLTs_FrequencyMostSevereTwo.Items.Insert(0, new ListItem("", "")); 
            }
            using (DataView DataViewGlobalCodes = BaseCommonFunctions.FillDropDown("XConDetReason", true, "", "", false))
            {
                DropDownList_CustomDocumentAdultLTs_ControllabilityMostSevereOne.DataTextField = "CodeName";
                DropDownList_CustomDocumentAdultLTs_ControllabilityMostSevereOne.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentAdultLTs_ControllabilityMostSevereOne.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentAdultLTs_ControllabilityMostSevereOne.DataBind();
                DropDownList_CustomDocumentAdultLTs_ControllabilityMostSevereOne.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentAdultLTs_ControllabilityMostSevereTwo.DataTextField = "CodeName";
                DropDownList_CustomDocumentAdultLTs_ControllabilityMostSevereTwo.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentAdultLTs_ControllabilityMostSevereTwo.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentAdultLTs_ControllabilityMostSevereTwo.DataBind();
                DropDownList_CustomDocumentAdultLTs_ControllabilityMostSevereTwo.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentAdultLTs_DeterrentsMostSevereOne.DataTextField = "CodeName";
                DropDownList_CustomDocumentAdultLTs_DeterrentsMostSevereOne.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentAdultLTs_DeterrentsMostSevereOne.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentAdultLTs_DeterrentsMostSevereOne.DataBind();
                DropDownList_CustomDocumentAdultLTs_DeterrentsMostSevereOne.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentAdultLTs_DeterrentsMostSevereTwo.DataTextField = "CodeName";
                DropDownList_CustomDocumentAdultLTs_DeterrentsMostSevereTwo.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentAdultLTs_DeterrentsMostSevereTwo.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentAdultLTs_DeterrentsMostSevereTwo.DataBind();
                DropDownList_CustomDocumentAdultLTs_DeterrentsMostSevereTwo.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentAdultLTs_ReasonsMostSevereOne.DataTextField = "CodeName";
                DropDownList_CustomDocumentAdultLTs_ReasonsMostSevereOne.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentAdultLTs_ReasonsMostSevereOne.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentAdultLTs_ReasonsMostSevereOne.DataBind();
                DropDownList_CustomDocumentAdultLTs_ReasonsMostSevereOne.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentAdultLTs_ReasonsMostSevereTwo.DataTextField = "CodeName";
                DropDownList_CustomDocumentAdultLTs_ReasonsMostSevereTwo.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentAdultLTs_ReasonsMostSevereTwo.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentAdultLTs_ReasonsMostSevereTwo.DataBind();
                DropDownList_CustomDocumentAdultLTs_ReasonsMostSevereTwo.Items.Insert(0, new ListItem("", ""));
            }

            using (DataView DataViewGlobalCodes = BaseCommonFunctions.FillDropDown("XActualLethality", true, "", "", false))
            {
                DropDownList_CustomDocumentAdultLTs_ActualLethality1.DataTextField = "CodeName";
                DropDownList_CustomDocumentAdultLTs_ActualLethality1.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentAdultLTs_ActualLethality1.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentAdultLTs_ActualLethality1.DataBind();
                DropDownList_CustomDocumentAdultLTs_ActualLethality1.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentAdultLTs_ActualLethality2.DataTextField = "CodeName";
                DropDownList_CustomDocumentAdultLTs_ActualLethality2.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentAdultLTs_ActualLethality2.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentAdultLTs_ActualLethality2.DataBind();
                DropDownList_CustomDocumentAdultLTs_ActualLethality2.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentAdultLTs_ActualLethality3.DataTextField = "CodeName";
                DropDownList_CustomDocumentAdultLTs_ActualLethality3.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentAdultLTs_ActualLethality3.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentAdultLTs_ActualLethality3.DataBind();
                DropDownList_CustomDocumentAdultLTs_ActualLethality3.Items.Insert(0, new ListItem("", ""));
            }

            using (DataView DataViewGlobalCodes = BaseCommonFunctions.FillDropDown("XPotentialLethality", true, "", "", false))
            {
                DropDownList_CustomDocumentAdultLTs_PotentialLethality1.DataTextField = "CodeName";
                DropDownList_CustomDocumentAdultLTs_PotentialLethality1.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentAdultLTs_PotentialLethality1.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentAdultLTs_PotentialLethality1.DataBind();
                DropDownList_CustomDocumentAdultLTs_PotentialLethality1.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentAdultLTs_PotentialLethality2.DataTextField = "CodeName";
                DropDownList_CustomDocumentAdultLTs_PotentialLethality2.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentAdultLTs_PotentialLethality2.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentAdultLTs_PotentialLethality2.DataBind();
                DropDownList_CustomDocumentAdultLTs_PotentialLethality2.Items.Insert(0, new ListItem("", ""));

                DropDownList_CustomDocumentAdultLTs_PotentialLethality3.DataTextField = "CodeName";
                DropDownList_CustomDocumentAdultLTs_PotentialLethality3.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentAdultLTs_PotentialLethality3.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentAdultLTs_PotentialLethality3.DataBind();
                DropDownList_CustomDocumentAdultLTs_PotentialLethality3.Items.Insert(0, new ListItem("", ""));
            }
        }
    }
}
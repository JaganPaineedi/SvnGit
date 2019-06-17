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

    public partial class ActivityPages_Client_CMDocuments_Risk : SHS.BaseLayer.ActivityPages.DataActivityTab
    {

        public override void BindControls()
        {


            using (SHS.UserBusinessServices.ClientInformation objectClientInformation = new SHS.UserBusinessServices.ClientInformation())
            {
                DataSet dataSetHospitalList = objectClientInformation.GetHospital();
                DataView dataViewHospitalList = dataSetHospitalList.Tables["Hospital"].DefaultView;
                dataViewHospitalList.RowFilter = "Hospital = 'Y' AND Active='Y'";
                DropDownList_CustomAcuteServicesPrescreens_ActionTakenPsychiatricPlacementHospital.DataTextField = "ProviderName";
                DropDownList_CustomAcuteServicesPrescreens_ActionTakenPsychiatricPlacementHospital.DataValueField = "SiteId";
                DropDownList_CustomAcuteServicesPrescreens_ActionTakenPsychiatricPlacementHospital.DataSource = dataViewHospitalList;
                DropDownList_CustomAcuteServicesPrescreens_ActionTakenPsychiatricPlacementHospital.Items.Insert(0, new ListItem(""));
                DropDownList_CustomAcuteServicesPrescreens_ActionTakenPsychiatricPlacementHospital.DataBind();
            }
           
            DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomicidePlanDetails.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
            DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomicidePlanDetails.FillDropDownDropGlobalCodes();


            DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomicidePlanAvailability.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
            DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomicidePlanAvailability.FillDropDownDropGlobalCodes();

            
            DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomicidePlanTime.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
            DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomicidePlanTime.FillDropDownDropGlobalCodes();

            
            DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomicidePlanLethalityMethod.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
            DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomicidePlanLethalityMethod.FillDropDownDropGlobalCodes();


           
            DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideAttempts.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
            DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideAttempts.FillDropDownDropGlobalCodes();

            
            DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideIsolation.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
            DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideIsolation.FillDropDownDropGlobalCodes();

           
            DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideProbabilityTiming.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
            DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideProbabilityTiming.FillDropDownDropGlobalCodes();

            
            DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisidePrecaution.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
            DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisidePrecaution.FillDropDownDropGlobalCodes();

           
            DropDownList_CustomAcuteServicesPrescreens_RiskSuicidePresentingDangersOtherHarmToSelf.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
            DropDownList_CustomAcuteServicesPrescreens_RiskSuicidePresentingDangersOtherHarmToSelf.FillDropDownDropGlobalCodes();

           
            DropDownList_CustomAcuteServicesPrescreens_RiskSuicidePresentingDangersHarmToOthers.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
            DropDownList_CustomAcuteServicesPrescreens_RiskSuicidePresentingDangersHarmToOthers.FillDropDownDropGlobalCodes();

           
            DropDownList_CustomAcuteServicesPrescreens_RiskSuicidePresentingDangersHarmToProperty.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
            DropDownList_CustomAcuteServicesPrescreens_RiskSuicidePresentingDangersHarmToProperty.FillDropDownDropGlobalCodes();


            DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideActingToGetHelp.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
            DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideActingToGetHelp.FillDropDownDropGlobalCodes();

            DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideFinalAct.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
            DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideFinalAct.FillDropDownDropGlobalCodes();

           
            DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideActiveForAttempt.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
            DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideActiveForAttempt.FillDropDownDropGlobalCodes();

           
            DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideSucideNote.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
            DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideSucideNote.FillDropDownDropGlobalCodes();

            
            DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideOvertCommunication.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
            DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideOvertCommunication.FillDropDownDropGlobalCodes();


            DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideAllegedPurposed.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
            DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideAllegedPurposed.FillDropDownDropGlobalCodes();

           
            DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideExpectationFatality.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
            DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideExpectationFatality.FillDropDownDropGlobalCodes();


            DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideConceptionOfMethod.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
            DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideConceptionOfMethod.FillDropDownDropGlobalCodes();

            
            DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideSeriousnessOfAttempt.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
            DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideSeriousnessOfAttempt.FillDropDownDropGlobalCodes();

           
            DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideAttitudeLivingDying.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
            DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideAttitudeLivingDying.FillDropDownDropGlobalCodes();

            DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideConceptMedicalRescue.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
            DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideConceptMedicalRescue.FillDropDownDropGlobalCodes();

           
            DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideStress.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
            DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideStress.FillDropDownDropGlobalCodes();

            
            DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideDegreePremeditation.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
            DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideDegreePremeditation.FillDropDownDropGlobalCodes();

           
            DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideCopingBehavior.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
            DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideCopingBehavior.FillDropDownDropGlobalCodes();

           
            DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideDepression.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
            DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideDepression.FillDropDownDropGlobalCodes();

           
            DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomicidePlanDetails.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
            DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomicidePlanDetails.FillDropDownDropGlobalCodes();


           
            DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideResource.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
            DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideResource.FillDropDownDropGlobalCodes();

           
            DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideLifeStyle.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
            DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideLifeStyle.FillDropDownDropGlobalCodes();

            
            DropDownList_CustomAcuteServicesPrescreens_RiskSuicidePresentingDangersSuicide.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
            DropDownList_CustomAcuteServicesPrescreens_RiskSuicidePresentingDangersSuicide.FillDropDownDropGlobalCodes();

            
            DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideMedicalStatus.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
            DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideMedicalStatus.FillDropDownDropGlobalCodes();
            

        }
    }
}

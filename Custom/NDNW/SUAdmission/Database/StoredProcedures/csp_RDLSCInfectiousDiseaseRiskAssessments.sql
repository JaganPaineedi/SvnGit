IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSCInfectiousDiseaseRiskAssessments]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[csp_RDLSCInfectiousDiseaseRiskAssessments]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_RDLSCInfectiousDiseaseRiskAssessments] 
@DocumentVersionId INT
/********************************************************************************      
-- Stored Procedure: dbo.csp_RDLSCInfectiousDiseaseRiskAssessments        
--     
-- Copyright: Streamline Healthcate Solutions   
--      
-- Updates:                                                             
-- Date			Author		Purpose      
-- 18-mar-2015  Revathi		What:Get Infectious Disease Risk Assessments
--							Why:task #4 New Direction - Customization  
*********************************************************************************/
AS
BEGIN
	BEGIN TRY
	
	 SELECT 
	 (CASE WHEN CIA.AnyHealthCareProvider='Y' THEN 'Yes' 
	 ELSE CASE WHEN CIA.AnyHealthCareProvider='U' THEN 'Don''t Know'
	 ELSE CASE WHEN CIA.AnyHealthCareProvider='N' THEN 'No'  ELSE '' END END END) AS AnyHealthCareProvider,
	 (CASE WHEN CIA.LivedStreetOrShelter='Y' THEN 'Yes' 
	 ELSE CASE WHEN CIA.LivedStreetOrShelter='U' THEN 'Don''t Know'
	 ELSE CASE WHEN CIA.LivedStreetOrShelter='N' THEN 'No'  ELSE '' END END END) AS LivedStreetOrShelter,
	 (CASE WHEN CIA.EverBeenJailPrisonJuvenile='Y' THEN 'Yes' 
	 ELSE CASE WHEN CIA.EverBeenJailPrisonJuvenile='U' THEN 'Don''t Know'
	 ELSE CASE WHEN CIA.EverBeenJailPrisonJuvenile='N' THEN 'No'  ELSE '' END END END) AS EverBeenJailPrisonJuvenile,
	 (CASE WHEN CIA.EverBeenCareFacility='Y' THEN 'Yes' 
	 ELSE CASE WHEN CIA.EverBeenCareFacility='U' THEN 'Don''t Know'
	 ELSE CASE WHEN CIA.EverBeenCareFacility='N' THEN 'No'  ELSE '' END END END) AS EverBeenCareFacility,
	 CIA.WhereBorn,
	 (CASE WHEN CIA.TraveledOrLivedOutsideUS='Y' THEN 'Yes' 
	 ELSE CASE WHEN CIA.TraveledOrLivedOutsideUS='U' THEN 'Don''t Know'
	 ELSE CASE WHEN CIA.TraveledOrLivedOutsideUS='N' THEN 'No'  ELSE '' END END END) AS TraveledOrLivedOutsideUS,
	 CIA.HowLongBeenInUS,
	(CASE WHEN CIA.CombatVeteran='Y' THEN 'Yes' 
	 ELSE CASE WHEN CIA.CombatVeteran='U' THEN 'Don''t Know'
	 ELSE CASE WHEN CIA.CombatVeteran='N' THEN 'No'  ELSE '' END END END) AS CombatVeteran,
	 (CASE WHEN CIA.HadTatooEarPiercingAcupunture='Y' THEN 'Yes' 
	 ELSE CASE WHEN CIA.HadTatooEarPiercingAcupunture='U' THEN 'Don''t Know'
	 ELSE CASE WHEN CIA.HadTatooEarPiercingAcupunture='N' THEN 'No'  ELSE '' END END END) AS HadTatooEarPiercingAcupunture,
	 ISNULL(CIA.Nausea,'N') AS Nausea,
	 ISNULL(CIA.Fever,'N') AS Fever,
	 ISNULL(CIA.DrenchingNightSweats,'N') AS DrenchingNightSweats,
	 ISNULL(CIA.ProductiveCough,'N') AS ProductiveCough,
	 ISNULL(CIA.CoughingUpBlood,'N') AS CoughingUpBlood,
	 ISNULL(CIA.ShortnessOfBreath,'N') AS ShortnessOfBreath,
	 ISNULL(CIA.LumpsSwollenGlands,'N') AS LumpsSwollenGlands,
	 ISNULL(CIA.DiarrheaLastingMoreThanWeek,'N') AS DiarrheaLastingMoreThanWeek,
	 ISNULL(CIA.LosingWeightWithoutMeaning,'N') AS LosingWeightWithoutMeaning,
	 ISNULL(CIA.BrownTingedUrine,'N') AS BrownTingedUrine,
	 ISNULL(CIA.ExtremeFatigue,'N') AS ExtremeFatigue,
	 ISNULL(CIA.Jaundice,'N') AS Jaundice,
	 ISNULL(CIA.NoSymptoms,'N') AS NoSymptoms,
	 (CASE WHEN CIA.MissedLastTwoPeriods='Y' THEN 'Yes' 
	 ELSE CASE WHEN CIA.MissedLastTwoPeriods='A' THEN 'N/A'
	 ELSE CASE WHEN CIA.MissedLastTwoPeriods='N' THEN 'No'  ELSE '' END END END) AS MissedLastTwoPeriods,
	 CIA.WomanMissedLast2Periods AS WomanMissedLast2Periods,
	(CASE WHEN CIA.EverBeenToldYouHaveTB='Y' THEN 'Yes' 
	 ELSE CASE WHEN CIA.EverBeenToldYouHaveTB='U' THEN 'Don''t Know'
	 ELSE CASE WHEN CIA.EverBeenToldYouHaveTB='N' THEN 'No'  ELSE '' END END END) AS EverBeenToldYouHaveTB,
	 (CASE WHEN CIA.EverBeenHadPositiveSkinTestTB='Y' THEN 'Yes' 
	 ELSE CASE WHEN CIA.EverBeenHadPositiveSkinTestTB='U' THEN 'Don''t Know'
	 ELSE CASE WHEN CIA.EverBeenHadPositiveSkinTestTB='N' THEN 'No'  ELSE '' END END END) AS EverBeenHadPositiveSkinTestTB,
	 (CASE WHEN CIA.EverBeenTreatedForTB='Y' THEN 'Yes' 
	 ELSE CASE WHEN CIA.EverBeenTreatedForTB='U' THEN 'Don''t Know'
	 ELSE CASE WHEN CIA.EverBeenTreatedForTB='N' THEN 'No'  ELSE '' END END END) AS EverBeenTreatedForTB,
	 (CASE WHEN CIA.EverBeenToldYouHaveHepatitisA='Y' THEN 'Yes' 
	 ELSE CASE WHEN CIA.EverBeenToldYouHaveHepatitisA='U' THEN 'Don''t Know'
	 ELSE CASE WHEN CIA.EverBeenToldYouHaveHepatitisA='N' THEN 'No'  ELSE '' END END END) AS EverBeenToldYouHaveHepatitisA,
	  (CASE WHEN CIA.EverBeenToldYouHaveHepatitisB='Y' THEN 'Yes' 
	 ELSE CASE WHEN CIA.EverBeenToldYouHaveHepatitisB='U' THEN 'Don''t Know'
	 ELSE CASE WHEN CIA.EverBeenToldYouHaveHepatitisB='N' THEN 'No'  ELSE '' END END END) AS EverBeenToldYouHaveHepatitisB,
	 (CASE WHEN CIA.EverBeenToldYouHaveHepatitisC='Y' THEN 'Yes' 
	 ELSE CASE WHEN CIA.EverBeenToldYouHaveHepatitisC='U' THEN 'Don''t Know'
	 ELSE CASE WHEN CIA.EverBeenToldYouHaveHepatitisC='N' THEN 'No'  ELSE '' END END END) AS EverBeenToldYouHaveHepatitisC,
	 (CASE WHEN CIA.EverUsedNeedlesToShootDrugs='Y' THEN 'Yes' 
	 ELSE CASE WHEN CIA.EverUsedNeedlesToShootDrugs='U' THEN 'Don''t Know'
	 ELSE CASE WHEN CIA.EverUsedNeedlesToShootDrugs='N' THEN 'No'  ELSE '' END END END) AS EverUsedNeedlesToShootDrugs,
	  (CASE WHEN CIA.EverSharedNeedlesSyringesToInjectDrugs='Y' THEN 'Yes' 
	 ELSE CASE WHEN CIA.EverSharedNeedlesSyringesToInjectDrugs='U' THEN 'Don''t Know'
	 ELSE CASE WHEN CIA.EverSharedNeedlesSyringesToInjectDrugs='N' THEN 'No'  ELSE '' END END END) AS EverSharedNeedlesSyringesToInjectDrugs,
	 (CASE WHEN CIA.EverHadNeedleStickInjuriesOrBloodContact='Y' THEN 'Yes' 
	 ELSE CASE WHEN CIA.EverHadNeedleStickInjuriesOrBloodContact='U' THEN 'Don''t Know'
	 ELSE CASE WHEN CIA.EverHadNeedleStickInjuriesOrBloodContact='N' THEN 'No'  ELSE '' END END END) AS EverHadNeedleStickInjuriesOrBloodContact,
	 (CASE WHEN CIA.UseStimulants='Y' THEN 'Yes' 
	 ELSE CASE WHEN CIA.UseStimulants='U' THEN 'Don''t Know'
	 ELSE CASE WHEN CIA.UseStimulants='N' THEN 'No'  ELSE '' END END END) AS UseStimulants,
	  (CASE WHEN CIA.PastTwelveMonthsHadSexWithAnyWithHepatitis='Y' THEN 'Yes' 
	 ELSE CASE WHEN CIA.PastTwelveMonthsHadSexWithAnyWithHepatitis='U' THEN 'Don''t Know'
	 ELSE CASE WHEN CIA.PastTwelveMonthsHadSexWithAnyWithHepatitis='N' THEN 'No'  ELSE '' END END END) AS PastTwelveMonthsHadSexWithAnyWithHepatitis,
	 (CASE WHEN CIA.ReceiveBloodTransfusionBefore1992='Y' THEN 'Yes' 
	 ELSE CASE WHEN CIA.ReceiveBloodTransfusionBefore1992='U' THEN 'Don''t Know'
	 ELSE CASE WHEN CIA.ReceiveBloodTransfusionBefore1992='N' THEN 'No'  ELSE '' END END END) AS ReceiveBloodTransfusionBefore1992,
	 (CASE WHEN CIA.ReceivedBloodProductsBefore1987='Y' THEN 'Yes' 
	 ELSE CASE WHEN CIA.ReceivedBloodProductsBefore1987='U' THEN 'Don''t Know'
	 ELSE CASE WHEN CIA.ReceivedBloodProductsBefore1987='N' THEN 'No'  ELSE '' END END END) AS ReceivedBloodProductsBefore1987,
	 (CASE WHEN CIA.BirthMotherInfectedWithHepatitisC='Y' THEN 'Yes' 
	 ELSE CASE WHEN CIA.BirthMotherInfectedWithHepatitisC='U' THEN 'Don''t Know'
	 ELSE CASE WHEN CIA.BirthMotherInfectedWithHepatitisC='N' THEN 'No'  ELSE '' END END END) AS BirthMotherInfectedWithHepatitisC,
	  (CASE WHEN CIA.EverBeenLongTermKidneyDialysis='Y' THEN 'Yes' 
	 ELSE CASE WHEN CIA.EverBeenLongTermKidneyDialysis='U' THEN 'Don''t Know'
	 ELSE CASE WHEN CIA.EverBeenLongTermKidneyDialysis='N' THEN 'No'  ELSE '' END END END) AS EverBeenLongTermKidneyDialysis,
	  (CASE WHEN CIA.UnprotectedSexWithHemophiliaPatient='Y' THEN 'Yes' 
	 ELSE CASE WHEN CIA.UnprotectedSexWithHemophiliaPatient='U' THEN 'Don''t Know'
	 ELSE CASE WHEN CIA.UnprotectedSexWithHemophiliaPatient='N' THEN 'No'  ELSE '' END END END) AS UnprotectedSexWithHemophiliaPatient,
	 (CASE WHEN CIA.UnprotectedSexWithManWithOtherMen='Y' THEN 'Yes' 
	 ELSE CASE WHEN CIA.UnprotectedSexWithManWithOtherMen='U' THEN 'Don''t Know'
	 ELSE CASE WHEN CIA.UnprotectedSexWithManWithOtherMen='N' THEN 'No'  ELSE '' END END END) AS UnprotectedSexWithManWithOtherMen,
	 (CASE WHEN CIA.HadSexExchangeMoneyOrDrugs='Y' THEN 'Yes' 
	 ELSE CASE WHEN CIA.HadSexExchangeMoneyOrDrugs='U' THEN 'Don''t Know'
	 ELSE CASE WHEN CIA.HadSexExchangeMoneyOrDrugs='N' THEN 'No'  ELSE '' END END END) AS HadSexExchangeMoneyOrDrugs,
	  (CASE WHEN CIA.HadSexMoreThanOnePersonPastSixMonths='Y' THEN 'Yes' 
	 ELSE CASE WHEN CIA.HadSexMoreThanOnePersonPastSixMonths='U' THEN 'Don''t Know'
	 ELSE CASE WHEN CIA.HadSexMoreThanOnePersonPastSixMonths='N' THEN 'No'  ELSE '' END END END) AS HadSexMoreThanOnePersonPastSixMonths,
	 (CASE WHEN CIA.HadSexWithAIDSPersonOrHepatitisC='Y' THEN 'Yes' 
	 ELSE CASE WHEN CIA.HadSexWithAIDSPersonOrHepatitisC='U' THEN 'Don''t Know'
	 ELSE CASE WHEN CIA.HadSexWithAIDSPersonOrHepatitisC='N' THEN 'No'  ELSE '' END END END) AS HadSexWithAIDSPersonOrHepatitisC,
	  (CASE WHEN CIA.EverInjectedDrugsEvenOnce='Y' THEN 'Yes' 
	 ELSE CASE WHEN CIA.EverInjectedDrugsEvenOnce='U' THEN 'Don''t Know'
	 ELSE CASE WHEN CIA.EverInjectedDrugsEvenOnce='N' THEN 'No'  ELSE '' END END END) AS EverInjectedDrugsEvenOnce,
	 (CASE WHEN CIA.EvenBeenPrickedByNeedle='Y' THEN 'Yes' 
	 ELSE CASE WHEN CIA.EvenBeenPrickedByNeedle='U' THEN 'Don''t Know'
	 ELSE CASE WHEN CIA.EvenBeenPrickedByNeedle='N' THEN 'No'  ELSE '' END END END) AS EvenBeenPrickedByNeedle,
	 (CASE WHEN CIA.EverHadDrinkingProblemCounselling='Y' THEN 'Yes' 
	 ELSE CASE WHEN CIA.EverHadDrinkingProblemCounselling='U' THEN 'Don''t Know'
	 ELSE CASE WHEN CIA.EverHadDrinkingProblemCounselling='N' THEN 'No'  ELSE '' END END END) AS EverHadDrinkingProblemCounselling,
	 (CASE WHEN CIA.EverBeenToldDrinkingProblem='Y' THEN 'Yes' 
	 ELSE CASE WHEN CIA.EverBeenToldDrinkingProblem='U' THEN 'Don''t Know'
	 ELSE CASE WHEN CIA.EverBeenToldDrinkingProblem='N' THEN 'No'  ELSE '' END END END) AS EverBeenToldDrinkingProblem,
	ISNULL(CIA.EverHadBloodTestForHIVAntibody,'N') AS EverHadBloodTestForHIVAntibody,
	ISNULL(CIA.BeenTestedWithinLastSixMonthsHIV,'N') AS BeenTestedWithinLastSixMonthsHIV,
	ISNULL(CIA.WouldYouLikeBloodTestHIV,'N') AS WouldYouLikeBloodTestHIV,
	ISNULL(CIA.EverHadBloodTestForHepatitisC,'N') AS EverHadBloodTestForHepatitisC,
	ISNULL(CIA.BeenTestedWithinLastSixMonthsHepatitisC,'N') AS BeenTestedWithinLastSixMonthsHepatitisC,
	ISNULL(CIA.WouldYouLikeBloodTestHepatitisC,'N') AS WouldYouLikeBloodTestHepatitisC,
	(CASE WHEN CIA.JudgeOwnRiskInfectedWithHIV='S' THEN 'I am not sure what my risk is' 
	 ELSE CASE WHEN CIA.JudgeOwnRiskInfectedWithHIV='N' THEN 'I think I am at NO risk'
	 ELSE CASE WHEN CIA.JudgeOwnRiskInfectedWithHIV='L' THEN 'I think I am  at low risk' 
	  ELSE CASE WHEN CIA.JudgeOwnRiskInfectedWithHIV='H' THEN 'I think I am  at high risk'
	   ELSE CASE WHEN CIA.JudgeOwnRiskInfectedWithHIV='I' THEN 'I think I am  infected'  
	  ELSE '' END END END END END) AS JudgeOwnRiskInfectedWithHIV,
	  (CASE WHEN CIA.JudgeOwnRiskInfectedWithHepatitisC='S' THEN 'I am not sure what my risk is' 
	 ELSE CASE WHEN CIA.JudgeOwnRiskInfectedWithHepatitisC='N' THEN 'I think I am at NO risk'
	 ELSE CASE WHEN CIA.JudgeOwnRiskInfectedWithHepatitisC='L' THEN 'I think I am  at low risk' 
	  ELSE CASE WHEN CIA.JudgeOwnRiskInfectedWithHepatitisC='H' THEN 'I think I am  at high risk'
	   ELSE CASE WHEN CIA.JudgeOwnRiskInfectedWithHepatitisC='I' THEN 'I think I am  infected'  
	  ELSE '' END END END END END) AS JudgeOwnRiskInfectedWithHepatitisC,
	  ISNULL(CIA.ClientAssessed,'N') AS ClientAssessed,
	   ISNULL(CIA.ClientReferredHealthOrAgency,'N') AS ClientReferredHealthOrAgency,
	  CIA.ClientReferredWhere
	 FROM 
	 CustomDocumentInfectiousDiseaseRiskAssessments CIA 	 
	 WHERE CIA.DocumentVersionId=@DocumentVersionId AND ISNULL(CIA.RecordDeleted,'N')='N'
	END TRY
	BEGIN CATCH  
    DECLARE @error varchar(8000)  
  
    SET @error = CONVERT(varchar, ERROR_NUMBER()) + '*****'  
    + CONVERT(varchar(4000), ERROR_MESSAGE())  
    + '*****'  
    + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()),  
    'csp_RDLSCInfectiousDiseaseRiskAssessments')  
    + '*****' + CONVERT(varchar, ERROR_LINE())  
    + '*****' + CONVERT(varchar, ERROR_SEVERITY())  
    + '*****' + CONVERT(varchar, ERROR_STATE())  
  
    RAISERROR (@error,-- Message text.  
    16,-- Severity.  
    1 -- State.  
    );  
  END CATCH  
END
GO
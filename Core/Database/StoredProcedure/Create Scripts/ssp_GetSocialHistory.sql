SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetSocialHistory]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetSocialHistory]
GO

Create   PROCEDURE [dbo].[ssp_GetSocialHistory]
/*********************************************************************************/    
-- Copyright: Streamline Healthcate Solutions    
--    
-- Purpose: Customization support for Reception list page depending on the custom filter selection.    
--    
-- Author:  Vaibhav khare    
-- Date:    20 May 2011    
--    
-- *****History****    
/* 2012-09-21   Vaibhav khare  Created											  */ 
/* 2013-03-11	Modified by SHS-US team for Summit Point Review					  */    
/* 2013-03-15   Modified by MJW.  Polished output and simplified join.            */
/* 2013-03-21    New two parameters added by Deej. As per the discussion with Wasif*/
/* 2014-06-19   Formated test*/
/* 2017-09-06   jcarlson Andrews Center SGL 63: Added logic to prevent the ssp from erroring out if the custom table CustomDocumentSocialHealthHistory does not exist
												removed unneeded comments*/
/******************************************************************************** */    

@ClientId INT  
 ,@DocumentId INT
 ,@EffectiveDate DATETIME     
AS    
BEGIN  
declare @temp as varchar(max) = '<b>Social History</b><br>';

declare @name varchar(max);  
	set @name = '<b>Family History</b><br>';

	IF OBJECT_ID(N'CustomDocumentSocialHealthHistory',N'U') IS NOT NULL
	begin
 select  @temp += '<br>Safety<br>'
+ case When HearWithoutHearingAids IS not null then 
		'How well do you hear without hearing aids? - ' + dbo.csf_GetGlobalCodeNameById(HearWithoutHearingAids) /*GC.Codename*/ + '<br>'  Else '' end  
+ case When HearingAidsUsed is not null then  'Do you use hearing aids? - ' 
	+ case when HearingAidsUsed='Y' then 'Yes' Else 'No' End 	+ '<br>'  Else '' end  
+ case When HearingAidsRecommendation is not null then  
		'Add to Recommendations - ' + cast(isnull(HearingAidsRecommendationComment,'') as varchar(max)) 
	+ '<br>'   Else '' end 
+ case When SeeWithoutVisualAids is not null then 
		'How well do you see without visual aids? - ' + dbo.csf_GetGlobalCodeNameById(SeeWithoutVisualAids)/*GC1.Codename*/ + '<br>' Else '' end 
+ case When VisualAidsUsed is not null then  'Do you use a visual aid? - ' 
	+ case when VisualAidsUsed='Y' then 'Yes' Else 'No' End + '<br>'  Else '' end  
+ case When VisualAidsRecommendation is not null then  'Add to Recommendations - ' 
	+ cast(isnull(VisualAidsRecommendationComment,'') as varchar(max)) + '<br>'   Else '' end 
+ case When SeatBeltUsage is not null then  'Seat Belt Usage - ' 
	+ case when SeatBeltUsage='Y' then 'Yes' Else 'No' End  + '<br>'  Else '' end  
+ case When SeatBeltUsageRecommendation is not null then  'Add to Recommendations - ' 
	+ cast(isnull(SeatBeltUsageRecommendationComment,'') as varchar(max)) + '<br>'   Else '' end 
+ case When HaveAccessToGun is not null then  'Own/have access to Guns - ' 
	+ case when HaveAccessToGun='Y' then 'Yes' Else 'No,' End + '<br>'  Else '' end  
+ case When AccessToGunsRecommendation is not null then  'Add to Recommendations - ' 
	+ cast(isnull(AccessToGunsRecommendationComment,'') as varchar(max)) + '<br>'   Else '' end 
+ case When ExcessiveExposureFume is not null or 
			ExcessiveExposureDust is not null or 
			ExcessiveExposureSolvents is not null or 
			ExcessiveExposureAirborneParticle is not null or 
			ExcessiveExposureNoise is not null then 
			 'Excessive exposure at home or work to: - ' Else '' end 
	+ case when isnull(ExcessiveExposureFume,'N')='Y' then 'Fumes ' else '' end 
	+ case when isnull(ExcessiveExposureDust,'N')='Y' then 'Dust '	 else '' end 
	+ case when isnull(ExcessiveExposureSolvents,'N')='Y' then 'Solvents '  else '' end 
	+ case when isnull(ExcessiveExposureAirborneParticle,'N')='Y'  then 'Airborne particles '  else '' end 
	+ case when isnull(ExcessiveExposureNoise,'N')='Y' then 'Noise ' else '' end  + '<br>'  
+ case When ExcessiveExposureRecommendation is not null then  'Add to Recommendations - ' 
	+ cast(isnull(ExcessiveExposureRecommendationComment,'') as varchar(max)) + '<br>'   Else '' end 
+ case When UseOfAlcohol is not null then  'Use of Alcohol: - ' 
	+ case when UseOfAlcohol='N' then 'Never'
		   when UseOfAlcohol='R' then 'Rarely'
		   when UseOfAlcohol='M' then 'Moderate'
		   when UseOfAlcohol='D' then 'Daily'  
		   Else 'Undefined' 
	 End +'<br>'  Else '' end  
+ case When AlcoholUsageRecommendation is not null then  'Add to Recommendations - ' 
	+ cast(isnull(AlcoholUsageRecommendationComment,'') as varchar(max)) + '<br>'   Else '' end 
+ case When UseOfTobacoo is not null then  'Use of Tobacco: - ' 
	+ case when UseOfTobacoo='N' then 'Never<br>'
		   when UseOfTobacoo='P' then 'Previously, but Quit - ' 
			+ case when UseOfTobacooPreviousDate is not null then convert(varchar(12),UseOfTobacooPreviousDate,101) + '<br>' Else '<br>' 
			  End Else '' 
	  End Else '' 
  end 
+ case When UseOfTobacooPacksOrDay is not null then 'Current Packs/Day: - ' + dbo.csf_GetGlobalCodeNameById(UseOfTobacooPacksOrDay) /*GC2.Codename*/ + '<br>' Else '' end 
+ case When TobaccoUsageRecommendation is not null then  'Add to Recommendations - ' 
	+ cast(isnull(TobaccoUsageRecommendationComment,'') as varchar(max)) + '<br>'   Else '' end 
+ case When UseOfDrug is not null then  'Use of Drugs: - ' 
	+ case when UseOfDrug='N' then 'Never<br>'
		   when UseOfDrug='T' then 'Type/Frequency: - '
		   + case when DrugTypeAndFreqDesc is not null then DrugTypeAndFreqDesc + '<br>' Else '<br>' 
		     End Else '' 
	  End   Else '' 
  end 
+ case When DrugUsageRecommendation is not null then  'Add to Recommendations - ' 
	+ cast(isnull(DrugUsageRecommendationComment,'') as varchar(max)) + '<br>'   Else '' end 
+ case When UseOfCaffeine is not null then  'Caffeine Intake: - ' 
	+ case when UseOfCaffeine='N' then 'Never<br>'
		   when UseOfCaffeine='T' then 'Type/Frequency: - '
		   	+ case when CaffeineTypeAndFreqDesc is not null then CaffeineTypeAndFreqDesc + '<br>' Else '<br>' 
		   	  End Else '' 
      End   Else '' 
  end 
+ case When CaffeineUsageRecommendation is not null then  'Add to Recommendations - '
	+ cast(isnull(CaffeineUsageRecommendationComment,'') as varchar(max)) + '<br>'   Else '' end 
-- /Safety Section
-- Nutrition Section
+ Case when (
			(NOT (ISNULL(UsualMealsADays,0)=0)) OR
			(RecentWeightChange IS not null) OR 
			(RecentAppetiteChange IS not null) OR 
			(DiscontentCurrentWeight IS not null) OR 
			(SpecialDietNeed IS not null) OR 
			(UnawareBasicFoodGroup IS not null) OR 
			(DietaryDeficit IS not null) OR 
			(InappropriateFluidIntake IS not null) OR 
			(FoodUsedAsCopingMechanism IS not null) OR 
			(EatingDisorder IS not null) OR 
			(EatFastFood IS not null) OR 
			(EatFruitVegetablesPriority IS not null) OR 
			(LostOrGainWeightMoreThen20 IS not null) OR 
			(InformedRiskDueToWeight IS not null) OR 
			(HospitalizedDueToEatingDisorder IS not null) OR 
			(DiagnosedDueToEatingDisorder IS not null) OR 
			(NutritionRecommendation is not null) 
			) then
	+ '<br>Nutrition<br>'
	+ case When ISNULL(UsualMealsADays,0)=0 then '' else 'Usual # of Meals a Day'  + ' - ' 
		+ cast(isnull(CDSHH.UsualMealsADays,'') as varchar(10))+ '<br>' end 
	+ case When RecentWeightChange IS not null then  'Recent Weight Change - ' 
		+ case when RecentWeightChange='Y' then 'Yes' Else 'No' End 	+ '<br>'  Else ''  end 
	+ case When RecentAppetiteChange IS not null then  'Recent Change in Appetite - ' 
		+ case when RecentAppetiteChange='Y' then 'Yes' Else 'No' End  + '<br>' Else '' end 
	+ case When DiscontentCurrentWeight IS not null then  'Discontent with Current Weight - ' 
		+ case when DiscontentCurrentWeight='Y' then 'Yes' Else 'No' End + '<br>' Else '' end 
	+ case When SpecialDietNeed IS not null then  'Special Diet Need - ' 
		+ case when SpecialDietNeed='Y' then 'Yes' Else 'No' End  + '<br>' Else '' end 
	+ case When UnawareBasicFoodGroup IS not null then  'Unaware of Basic Food Groups - ' 
		+ case when UnawareBasicFoodGroup ='Y' then 'Yes' Else 'No' End + '<br>'  Else '' end 
	+ case When DietaryDeficit  IS not null then  'Dietary Deficits - ' 
		+ case when DietaryDeficit ='Y' then 'Yes' Else 'No' End  + '<br>'  Else '' end 
	+ case When InappropriateFluidIntake  IS not null then  'Inappropriate Fluid intake  - ' 
		+ case when InappropriateFluidIntake ='Y' then 'Yes' Else 'No' End  +'<br>' Else '' end 
	+ case When FoodUsedAsCopingMechanism  IS not null then  'Food Used as Coping Mechanism - ' 
		+ case when FoodUsedAsCopingMechanism ='Y' then 'Yes' Else 'No' End + '<br>' Else '' end 
	+ case When EatingDisorder IS not null then  'Eating Disorder - ' 
		+ case when EatingDisorder ='Y' then 'Yes' Else 'No' End + '<br>' Else '' end 
	+ case When EatFastFood IS not null then  'Eat Fast Food - ' 
		+ case when EatFastFood ='Y' then 'Yes' Else 'No' End  + '<br>' Else '' end 
	+ case When EatFruitVegetablesPriority IS not null then  'Eat Fruit/Vegetables Priority - ' 
		+ case when EatFruitVegetablesPriority ='Y' then 'Yes' Else 'No' End + '<br>'  Else '' end 
	+ case When LostOrGainWeightMoreThen20 IS not null then  'Without wanting to, have you lost or gained 20 pounds or more in the last six months? - ' 
		+ case when LostOrGainWeightMoreThen20 ='Y' then 'Yes' Else 'No' End + '<br>'  Else '' end 
	+ case When InformedRiskDueToWeight IS not null then  'Has your physician ever informed you that you have or are at risk for disease because of your weight? - ' 
		+ case when InformedRiskDueToWeight ='Y' then 'Yes' Else 'No' End + '<br>' Else '' end 
	+ case When HospitalizedDueToEatingDisorder IS not null then  'Have you been hospitalized in the last year for an eating disorder? - ' 
		+ case when HospitalizedDueToEatingDisorder ='Y' then 'Yes' Else 'No' End  + '<br>' Else '' end 
	+ case When DiagnosedDueToEatingDisorder IS not null then  'Have you ever been diagnosed with an eating disorder? - ' 
		+ case when DiagnosedDueToEatingDisorder ='Y' then 'Yes' Else 'No' End + '<br>'  Else '' end 
	+ case When NutritionRecommendation is not null then  'Add to Recommendations - ' 
		+ cast(isnull(NutritionRecommendationcomment,'') as nvarchar(max)) + '<br>'   Else '' end 
-- /Nutrition Section
else '' end	
 	
-- Depression / Anxiety Section
+ Case when (
			(FeltDepressedHopeless IS not null) OR 
			(FeltinterestPleasure IS not null) OR 
			(FamilyFriendFeelingsCausedDistress IS not null) OR 
			(FeltNervousAnxious IS not null) OR 
			(NotAbleToStopWorrying IS not null) OR 
			(StressPeoblemForHandlingThing IS not null) OR 
			(SocialAndEmotionalNeed IS not null) OR 
			(DepressionAnxietyRecommendation is not null) 
			) then
	+ '<br>Depression / Anxiety<br>'
	+ case When FeltDepressedHopeless IS not null then  'How often have you felt down,depressed,or hopeless in the past two weeks? - ' 
		+ dbo.csf_GetGlobalCodeNameById(FeltDepressedHopeless) /*GC13.CodeName*/ + '<br>' else '' end 
	+ case When FeltinterestPleasure IS not null then  'How often have you felt little interest or pleasure in doing things in the past two weeks? - ' 
	+     dbo.csf_GetGlobalCodeNameById(FeltinterestPleasure)/*GC14.CodeName*/ +'<br>' else '' end 
	+ case When FamilyFriendFeelingsCausedDistress IS not null then  'Have your feelings caused you distress or interfered with your ability to get along socially with friends or family? ' 
		+ case when FamilyFriendFeelingsCausedDistress='Y' then 'Yes' Else 'No' End + '<br>'  Else '' end 
	+ case When FeltNervousAnxious IS not null then  'How often have you felt nervous,anxious,or on edge? - ' 
		+ dbo.csf_GetGlobalCodeNameById(FeltNervousAnxious) /*GC15.CodeName*/ + '<br>' else '' end 
	+ case When NotAbleToStopWorrying IS not null then  'How often were you not able to stop worrying or controlling your worry? - ' 
		+ dbo.csf_GetGlobalCodeNameById(NotAbleToStopWorrying) /*GC16.CodeName*/ + '<br>' else '' end 
	+ case When StressPeoblemForHandlingThing IS not null then  'How often is stress a problem for you handling such things as:  Health, Finances, Family or Social Relations, Work? - ' 
		+ dbo.csf_GetGlobalCodeNameById(StressPeoblemForHandlingThing) /*GC17.CodeName*/ + '<br>' else '' end  
	+ case When SocialAndEmotionalNeed IS not null then  'How often do you get the social and emotional support you need? - ' 
		+ dbo.csf_GetGlobalCodeNameById(SocialAndEmotionalNeed) /*GC18.CodeName*/+'<br>' else '' end 
	+ case When DepressionAnxietyRecommendation is not null then  'Add to Recommendations - ' 
		+ cast(isnull(DepressionAnxietyRecommendationComment,'') as nvarchar(max)) + '<br>'   Else '' end 
-- /Depression / Anxiety Section
else '' end 
-- Physical Activity Section
+ Case when (
			(ExercisePerWeekDay IS not null) OR 
			(Not (isnull(ExerciseADay,0)= 0)) OR
			(TypicalWorkoutIntense Is not null) OR
			(PhysicalActivityRecommendation is not null) 
			) then
	+ '<br>Physical Activity<br>'
	+ case When ExercisePerWeekDay IS not null then 'How many Days do you exercise per week? - ' + dbo.csf_GetGlobalCodeNameById(ExercisePerWeekDay) /*GC20.Codename*/ + '<br>' Else '' end  
	+ case When isnull(ExerciseADay,0)= 0 then  ' ' else 'On days you do exercise, how long did you exercise? - ' 
		+ cast(isnull(CDSHH.ExerciseADay,'') as varchar(10))+ ' Mins' + '<br>' end 
	+ case When TypicalWorkoutIntense Is not null then 'How intense is your typical workout?' +' - ' + dbo.csf_GetGlobalCodeNameById(TypicalWorkoutIntense) /*GC21.codename*/ + '<br>' else '' end 
	+ case When PhysicalActivityRecommendation is not null then  'Add to Recommendations - ' 
		+ cast(isnull(PhysicalActivityRecommendationComment,'') as nvarchar(max)) + '<br>'   Else '' end 
-- /Physical Activity Section
else '' end

-- /Daily Living Section
+ Case when (
			(InGeneralHealth IS not null) OR 
			(MouthAndTeethCondition IS not null) OR
			(NeedHelpInDailyActivity IS not null) OR
			(NeedHelpToTakeCare IS not null) OR
			(DailyLivingRecommendation is not null) 
			) then
	+ '<br>Daily Living<br>'
	+ case When InGeneralHealth IS not null then 'In general, would you say your health is? - ' + dbo.csf_GetGlobalCodeNameById(InGeneralHealth) /*GC22.Codename*/ + '<br>' Else '' end 
	+ case When MouthAndTeethCondition IS not null then 'How would you describe the condition of your mouth and teeth including false teeth and dentures? - ' 
	+ dbo.csf_GetGlobalCodeNameById(MouthAndTeethCondition) + /*GC23.Codename*/ + '<br>' Else '' end 
	+ case When NeedHelpInDailyActivity IS not null then  'Do you need help from others performing everyday activities such as eating, getting dressed, grooming, walking, bathing or using the toilet? - ' 
		+ case when NeedHelpInDailyActivity='Y' then 'Yes' Else 'No' End  + '<br>' Else '' end  
	+ case When NeedHelpToTakeCare IS not null then  'Do you need help from others to take care of things such as laundry and housekeeping, banking, shopping, using the telephone, food preparation, transportation, or taking your own medications? - ' 
		+ case when NeedHelpToTakeCare='Y' then 'Yes' Else 'No' End +'<br>' Else '' end 
	+ case When DailyLivingRecommendation is not null then  'Add to Recommendations - ' 
		+ cast(isnull(DailyLivingRecommendationComment,'') as nvarchar(max)) + '<br>'   Else '' end
-- /Daily Living Section
else '' end 

from CustomDocumentSocialHealthHistory CDSHH 
Join Documentversions DV ON CDSHH.DocumentVersionId=DV.DocumentVersionId 
Join documents ds ON DV.DocumentVersionId=ds.CurrentDocumentVersionId  --get most recent version of a doc

 Where ds.ClientId=@ClientId 
		AND isnull(CDSHH.RecordDeleted,'N') = 'N'
		AND isnull(DV.RecordDeleted,'N') = 'N'
		AND isnull(DS.RecordDeleted,'N') = 'N'
		AND DS.Status = 22 --signed
		
		   and not exists ( select *
                                             from   Documents as ds2
                                             where  ds2.ClientId = ds.ClientId
													and ds2.DocumentCodeId = ds.DocumentCodeId
                                                    and ds2.Status = 22 -- signed
                                                    and ISNULL(ds2.RecordDeleted,
                                                              'N') <> 'Y'
                                                    and (
                                                         (ds2.EffectiveDate > ds.EffectiveDate)
                                                         or (
                                                             ds2.EffectiveDate = ds.EffectiveDate
                                                             and ds2.DocumentId > ds.DocumentId
                                                            )
                                                        ) )
      END 
	  ELSE 
	  BEGIN
	  SET @temp += 'none';
	  END                                            
   -- check to see if there is any output.  If not, write out section with none
   select case when len(@temp) > 2 then '<span style=''color:black''>'+ @temp +'</span>' else '<span style=''color:black''><b>Social History</b><br>None</span>' end

 END 
GO

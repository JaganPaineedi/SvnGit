
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetMedicalHistory]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetMedicalHistory]
GO
 
CREATE  PROCEDURE [dbo].[ssp_GetMedicalHistory]       
/*********************************************************************************/          
-- Copyright: Streamline Healthcate Solutions          
--          
-- Purpose: Customization support for Reception list page depending on the custom filter selection.          
--          
-- Author:  Vaibhav khare          
-- Date:    20 May 2011          
--          
-- *****History****          
/* 2012-09-21   Vaibhav khare  Created          */    
/* 2013-03-15   MJW Optimized Select and added code to grab most recent doc      */    
/* 2013-03-21    New two parameters added by Deej. As per the discussion with Wasif*/ 
/* 2013-07-18  resolved nbsp issue    */      
/* 2017-09-06   jcarlson Andrews Center SGL 63: Added logic to prevent the ssp from erroring out if the custom table CustomDocumentHealthMedicalHistory does not exist
												removed unneeded comments*/   
/*********************************************************************************/          
          
         
 @ClientId INT        
 ,@DocumentId INT    
 ,@EffectiveDate DATETIME       
           
AS          
BEGIN           
     
 DECLARE @temp VARCHAR(max)      
 DECLARE @tempComment VARCHAR(Max)      
 DECLARE @temp1 varchar(max)      
 DECLARE @temp1Comment VARCHAR(Max)      
 DECLARE @temp2 varchar(max)        
 DECLARE @temp2Comment varchar(max)      
 DECLARE @temp3 varchar(max)        
 DECLARE @temp3Comment varchar(max)      
 DECLARE @temp4 varchar(max)      
 DECLARE @temp4Comment varchar(max)      
 DECLARE @temp5 varchar(max)      
 DECLARE @temp5Comment varchar(max)      
 DECLARE @temp6 varchar(max)     
 DECLARE @temp6Comment varchar(max)      
 DECLARE  @temp7 varchar(max)      
 DECLARE  @temp7Comment varchar(max)      
 DECLARE  @temp8 varchar(max)   
 DECLARE  @temp8Comment varchar(max) 
 DECLARE  @temp9 varchar(max)    -- added for allegan task 28
 --DECLARE  @temp10 varchar(max)
 DECLARE  @temp11 varchar(max)
 DECLARE  @temp9Comment varchar(max) 
 
 DECLARE  @notfound as varchar(max)    
 declare @tempbase as varchar(max)    
 declare @tempbase1 as varchar(max)    
 declare @tempbase2 as varchar(max)    
 declare @tempbase3 as varchar(max)    
 declare @tempbase4 as varchar(max)    
 declare @tempbase5 as varchar(max)    
 declare @tempbase6 as varchar(max)    
 declare @tempbase7 as varchar(max)    
 declare @tempbase8 as varchar(max)  
 declare @tempbase9 as varchar(max)   
 declare @tempbase10 as varchar(max) 
 declare @tempbase11 as varchar(max)         
    
 set @notfound = '<b>Medical History</b><br>None'    
 IF OBJECT_ID(N'CustomDocumentHealthMedicalHistory',N'U') IS NOT NULL
	BEGIN
    
 SET @temp ='<b>Medical History</b><br>Neurological123:&nbsp;&nbsp; ' 
 SET @temp1='<br>Respiratory:&nbsp;&nbsp;'        
 SET @temp2='<br>Endocrine:&nbsp;&nbsp;'      
 SET @temp3='<br>Cardiovascular:&nbsp;&nbsp;'        
 SET @temp4='<br>Gastrointestinal:&nbsp;&nbsp;'        
 SET @temp5='<br>Musculosketal:&nbsp;&nbsp;'        
 SET @temp6='<br>Genitourinary:&nbsp;&nbsp;'       
 SET @temp7='<br>Skin/Breast:&nbsp;&nbsp;'      
 SET @temp8='<br>Ear/Nose/Throat:&nbsp;&nbsp;<br>'        
 --SET @temp9='<br><br><b>Significant Medical/Health Problems</b>:&nbsp;&nbsp;' 
 SET @temp9= '<br><br><b>Significant Medical/Health Problems</b><br><br>'    
 SET @temp11 = '<br>'   
 
 
 SET @tempbase = @temp    
 SET @tempbase1 = @temp1    
 SET @tempbase2 = @temp2    
 SET @tempbase3 = @temp3    
 SET @tempbase4 = @temp4    
 SET @tempbase5 = @temp5    
 SET @tempbase6 = @temp6    
 SET @tempbase7 = @temp7    
 SET @tempbase8 = @temp8    
 SET @tempbase9 = @temp9
 SET @tempbase9 = @temp9
              
  Select     
  @temp += CASE When ISNULL(NeurologicalNotApplicable,'N')<>'N' then ' Not Applicable, ' else '' END,      
  @temp += CASE When ISNULL(NeurologicalNoChange,'N')<>'N' then ' No Change, '  else '' END,      
  @temp += CASE When  ISNULL(NeurologicalParalysisSpasticity,'N')<>'N'  then ' Paralysis/Spasticity, ' else ''  END,      
  @temp += CASE When ISNULL(NeurologicalLightHeadedDizzy,'N')<>'N'   then ' Light Headed/Dizzy, '  else ''  END,      
  @temp += CASE When ISNULL(NeurologicalConvulsionsOrSeizure,'N')<>'N'  then ' Convulsions or Seizures, '  else '' END,      
  @temp += CASE When ISNULL(NeurologicalSleepProblem,'N')<>'N'  then ' Sleep Problems, '  else ''  END,      
  @temp += CASE When ISNULL(NeurologicalNumbnessTinglingParaethsia,'N')<>'N' then ' Numbness/Tingling/Paraethsia, '  else '' END,      
  @temp += CASE When ISNULL(NeurologicalHeadInjury,'N')<>'N' then '  Head Injury, '  else '' END,      
  @temp += CASE When ISNULL(NeurologicalTremor,'N')<>'N' then' Tremors, '  else ''  END,      
  @temp += CASE When ISNULL(NeurologicalFrequentSevereHeadaches,'N')<>'N' then '  Frequent/Severe Headaches, '  else '' END,      
  @temp += CASE When ISNULL(NeurologicalCVAStokeTIA,'N')<>'N' then ' CVA (Stoke/TIA), '  else ''  END,      
  @temp += CASE When ISNULL(NeurologicalTardiveDyskinesia,'N')<>'N' then '  Tardive Dyskinesia, '  else '' END,      
  @temp += CASE When ISNULL(NeurologicalLossOfConsciousness,'N')<>'N' then ' Loss of Consciousness, '  else '' END,      
  @temp += CASE When ISNULL(NeurologicalImpairedBalanceCoordination,'N')<>'N' then ' Impaired Balance/Coordination, '  else ''  END,      
  @tempComment =CASE When ISNULL(CAST(NeurologicalComment AS varchar) ,'N')<>'N' then ' <br>Comments:&nbsp;&nbsp; ' +CAST(NeurologicalComment AS varchar(max)) else ''END,      
      
  @temp1 += CASE When ISNULL(RespiratoryNotApplicable,'N')<>'N' then ' Not Applicable, ' else '' END,      
  @temp1 += CASE When ISNULL(RespiratoryNoChange,'N')<>'N' then ' No Change, '  else '' END,      
  @temp1 += CASE When ISNULL(RespiratoryAsthma,'N')<>'N'  then ' Asthma, ' else ''  END,      
  @temp1 += CASE When ISNULL(RespiratoryShortnessOfBreath,'N')<>'N'   then ' Shortness of Breath, '  else ''  END,      
  @temp1 += CASE When ISNULL(NeurologicalConvulsionsOrSeizure,'N')<>'N'  then ' Convulsions or Seizures, '  else '' END,      
  @temp1 += CASE When ISNULL(RespiratorySmoke,'N')<>'N'  then ' Smoke, '  else ''  END,      
  @temp1 += CASE When ISNULL(RespiratoryWheezing,'N')<>'N' then ' Wheezing, '  else '' END,      
  @temp1 += CASE When ISNULL(RespiratoryChronicOrFrequentCough,'N')<>'N' then ' Chronic or Frequent Coughs, '  else '' END,      
  @temp1 += CASE When ISNULL(RespiratorySpittingUpBlood,'N')<>'N' then' Spitting up Blood, '  else ''  END,      
  @temp1 += CASE When ISNULL(RespiratoryCOPDEmphysema,'N')<>'N' then '  COPD/Emphysema, '  else '' END,      
  @temp1 += CASE When ISNULL(RespiratoryHistoryOfPneumonia,'N')<>'N' then '  History of Pneumonia, '  else ''  END,      
  @temp1 += CASE When ISNULL(RespiratoryLastTBTest,'N')<>'N' then '  Last "TB" Test: '  else '' END,      
  @temp1 += Case When ISNULL(cast(RespiratoryLastTBTestDate AS varchar),'None') <> 'None' then cast(RespiratoryLastTBTestDate AS varchar) + ',' else 'None,' END,    
  /** Last TB Test Result Logic to go here if there is time  **/    
  @temp1Comment =CASE When ISNULL(cast(RespiratoryComment AS varchar),'N')<>'N' then '<br>Comments:&nbsp;&nbsp; '+ cast( RespiratoryComment as Varchar(max)) else '' END,    
      
  @temp2 += CASE When ISNULL(EndocrineNotApplicable,'N')<>'N' then ' Not Applicable, ' else '' END,      
  @temp2 += CASE When ISNULL(EndocrineNoChange,'N')<>'N' then ' No Change, '  else '' END,      
  @temp2 += CASE When ISNULL(EndocrineSkinSwellingThickening,'N')<>'N'  then ' Skin Swelling/Thickening, ' else ''  END,      
  @temp2 += CASE When ISNULL(EndocrineChangeShoeRingSize,'N')<>'N'   then ' Change in Shoe/Ring Size, '  else ''  END,      
  @temp2 += CASE When ISNULL(EndocrineTemperatureSensitivity,'N')<>'N'  then ' Temperature Sensitivity, '  else '' END,      
  @temp2 += CASE When ISNULL(EndocrineLossPotencyLibido,'N')<>'N'  then ' Loss of Potency/Libido, '  else ''  END,      
  @temp2 += CASE When ISNULL(EndocrineBreastSecretion,'N')<>'N' then '  Breast Secretion, '  else '' END,      
  @temp2 += CASE When ISNULL(EndocrineSkinOtherInfection,'N')<>'N' then ' Skin/Other Infections, '  else '' END,      
  @temp2 += CASE When ISNULL(EndocrineIncreaseThirst,'N')<>'N' then' Increase Thirst, '  else ''  END,      
  @temp2 += CASE When ISNULL(EndocrineSkinBecomingDryer,'N')<>'N' then '  EndocrineSkinBecomingDryer, '  else '' END,      
  @temp2 += CASE When ISNULL(MuscleCrampsTwitchesFatiqueWeakness,'N')<>'N' then '  Muscle Cramps/Twitches/Fatique/Weakness, '  else ''  END,      
  @temp2 += CASE When ISNULL(EndocrineIncreaseFacialHairAcne,'N')<>'N' then '  Increase Facial Hair/Acne, '  else '' END,      
  @temp2 += CASE When ISNULL(IncreaseVolumeFrequencyUrination,'N')<>'N' then '  Increase Volume/Frequency of Urination), '  else ''  END,      
  @temp2 += CASE When ISNULL(EndocrineVoiceHearingChange,'N')<>'N' then '  Voice/Hearing Changes, '  else '' END,      
  @temp2 += CASE When ISNULL(EndocrineHypoglycemia,'N')<>'N' then ' Hypoglycemia, '  else '' END,      
  @temp2 += CASE When ISNULL(EndocrineDiabetes,'N')<>'N' then '  Diabetes, '  else ''  END,      
  @temp2 += CASE When ISNULL(EndocrineThyroidDsyfunction,'N')<>'N' then '  Thyroid Dsyfunction, '  else '' END,      
  @temp2Comment=CASE When ISNULL(cast(EndocrineComment AS varchar),'N')<>'N' then '<br>Comments:&nbsp;&nbsp; '+ cast( EndocrineComment as Varchar(max)) else '' END,    
      
  @temp3 += CASE When ISNULL(CardiovascularNotApplicable,'N')<>'N' then ' Not Applicable, ' else '' END,      
  @temp3 += CASE When ISNULL(CardiovascularNoChange,'N')<>'N' then ' No Change, '  else '' END,      
  @temp3 += CASE When ISNULL(CardiovascularPalpitation,'N')<>'N'  then ' Palpitations, ' else ''  END,      
  @temp3 += CASE When ISNULL(CardiovascularCongestiveHeartFailure,'N')<>'N'   then ' Congestive Heart Failure, '  else ''  END,      
  @temp3 += CASE When ISNULL(CardiovascularChestPain,'N')<>'N'  then ' Chest Pain, '  else '' END,      
  @temp3 += CASE When ISNULL(CardiovascularBrusing,'N')<>'N'  then ' Brusing, '  else ''  END,      
  @temp3 += CASE When ISNULL(CardiovascularSwellingAnkle,'N')<>'N' then '  Swelling of Ankles, '  else '' END,      
  @temp3 += CASE When ISNULL(CardiovascularNoseBleed,'N')<>'N' then ' Nose Bleeds, '  else '' END,      
  @temp3 += CASE When ISNULL(CardiovascularHyperlipidemia,'N')<>'N' then' Hyperlipidemia, '  else ''  END,      
  @temp3 += CASE When ISNULL(CardiovascularHypertension,'N')<>'N' then '  Hypertension, '  else '' END,      
  @temp3 += CASE When ISNULL(CardiovascularEdema,'N')<>'N' then '  Edema, '  else ''  END,      
  @temp3 += CASE When ISNULL(CardiovascularIrregularPulse,'N')<>'N' then '  Irregular Pulse, '  else '' END,      
  @temp3 += CASE When ISNULL(CardiovascularNumbColdHandsFeet,'N')<>'N' then ' Numb/Cold Hands or Feet, '  else '' END,      
  @temp3 += CASE When ISNULL(CardiovascularMIHeartAttack,'N')<>'N' then '  MI/Heart Attack, '  else ''  END,      
  @temp3Comment = CASE When ISNULL(cast(CardiovascularComment AS varchar),'N')<>'N' then '<br>Comments:&nbsp;&nbsp; '+ cast( CardiovascularComment as Varchar(max)) else '' END,    
         
  @temp4 += CASE When ISNULL(GastrointestinalNotApplicable,'N')<>'N' then ' Not Applicable, ' else '' END,      
  @temp4 += CASE When ISNULL(GastrointestinalNoChange,'N')<>'N' then ' No Change, '  else '' END,      
  @temp4 += CASE When ISNULL(GastrointestinalGERD,'N')<>'N'  then ' GERD, ' else ''  END,      
  @temp4 += CASE When ISNULL(GastrointestinalNausea,'N')<>'N'   then ' Nausea, '  else ''  END,      
  @temp4 += CASE When ISNULL(GastrointestinalConstipation,'N')<>'N'  then ' Constipation, '  else '' END,      
  @temp4 += CASE When ISNULL(GastrointestinalSoreThroat,'N')<>'N'  then ' Sore Throat, '  else ''  END,      
  @temp4 += CASE When ISNULL(GastrointestinalVomiting,'N')<>'N' then '  Vomiting, '  else '' END,      
  @temp4 += CASE When ISNULL(GastrointestinalRectalBleeding,'N')<>'N' then ' Rectal Bleeding, '  else '' END,      
  @temp4 += CASE When ISNULL(GastrointestinalDiarrhea,'N')<>'N' then' Diarrhea, '  else ''  END,      
  @temp4 += CASE When ISNULL(GastrointestinalHemorrhiod,'N')<>'N' then ' Hemorrhiods, '  else '' END,      
  @temp4 += CASE When ISNULL(GastrointestinalEdma,'N')<>'N' then '  Edema, '  else ''  END,      
  @temp4 += CASE When ISNULL(GastrointestinalAbdominalStomachPain,'N')<>'N' then ' Abdominal/Stomach Pain, '  else '' END,      
  @temp4 += CASE When ISNULL(GastrointestinalTroubleSwollening,'N')<>'N' then ' Trouble Swollowing, '  else '' END,      
  @temp4 += CASE When ISNULL(GastrointestinalHoarseness,'N')<>'N' then ' Hoarseness, '  else ''  END,      
  @temp4 += CASE When ISNULL(GastrointestinalFrequentHeartburn,'N')<>'N' then ' Frequent Heartburn, '  else '' END,      
  @temp4 += CASE When ISNULL(GastrointestinalNeedsDentalWork,'N')<>'N' then ' Needs Dental Work, '  else ''  END,      
  @temp4 += CASE When ISNULL(GastrointestinalDenture,'N')<>'N' then ' Dentures, '  else '' END,      
  @temp4 += CASE When ISNULL(GastrointestinalUlcer,'N')<>'N' then ' Ulcers, '  else '' END,      
  @temp4 += CASE When ISNULL(GastrointestinalUseLaxative,'N')<>'N' then ' Use of Laxatives, '  else ''  END,      
  @temp4 += CASE When ISNULL(GastrointestinalOddColoredStool,'N')<>'N' then ' Odd Colored Stool, '  else '' END,      
  @temp4Comment = CASE When ISNULL(cast(GastrointestinalComment AS varchar),'N')<>'N' then '<br>Comments:&nbsp;&nbsp; '+ cast( GastrointestinalComment as Varchar(max)) else '' END,      
      
  @temp5 += CASE When ISNULL(MusculosketalNotApplicable,'N')<>'N' then ' Not Applicable, ' else '' END,      
  @temp5 += CASE When ISNULL(MusculosketalNoChange,'N')<>'N' then ' No Change, '  else '' END,      
  @temp5 += CASE When ISNULL(MusculosketalOftenTired,'N')<>'N'  then '  Often Tired, ' else ''  END,      
  @temp5 += CASE When ISNULL(MusculosketalPainfulSwollenJoint,'N')<>'N'   then ' Painful/Swollen Joints, '  else ''  END,      
  @temp5 += CASE When ISNULL(MusculosketalWeakness,'N')<>'N'  then ' Weakness, '  else '' END,      
  @temp5 += CASE When ISNULL(ProsthesisOrthopedicAppliance,'N')<>'N'  then ' Orthopedic Appliance, '  else '' END,      
  @temp5 += CASE When ISNULL(MusculosketalImpairedROM,'N')<>'N'  then ' Impaired ROM, '  else ''  END,      
  @temp5 += CASE When ISNULL(MusculosketalDeformities,'N')<>'N' then '  Deformities, '  else '' END,      
  @temp5 += CASE When ISNULL(MusculosketalFractures,'N')<>'N' then ' Fractures, '  else '' END,      
  @temp5 += CASE When ISNULL(MusculosketalMusclePainCramps,'N')<>'N' then' Muscle Pain/Cramps, '  else ''  END,      
  @temp5 += CASE When ISNULL(MusculosketalBackPain,'N')<>'N' then '  Back Pain, '  else '' END,      
  @temp5 += CASE When ISNULL(MusculosketalColdExtremities,'N')<>'N' then ' Cold Extremities, '  else ''  END,      
  @temp5Comment=CASE When ISNULL(cast(MusculosketalComment AS varchar),'N')<>'N' then '<br>Comments:&nbsp;&nbsp; '+ cast( MusculosketalComment as Varchar(max)) else '' END,    
      
  @temp6 += CASE When ISNULL(GenitourinaryNotApplicable,'N')<>'N' then ' Not Applicable, ' else '' END,      
  @temp6 += CASE When ISNULL(GenitourinaryNoChange,'N')<>'N' then ' No Change, '  else '' END,      
  @temp6 += CASE When ISNULL(GenitourinarySexuallyActive,'N')<>'N'  then ' Sexually Active, ' else ''  END,      
  @temp6 += CASE When ISNULL(GenitourinaryUseProtectionAgainstSTD,'N')<>'N'   then '  Use Protection Against STD, '  else ''  END,      
  @temp6 += CASE When ISNULL(GenitourinaryFrequentUrination,'N')<>'N'  then ' Frequent Urination, '  else '' END,      
  @temp6 += CASE When ISNULL(PainBurningduringUrination,'N')<>'N'  then ' Pain/Burning during Urination, '  else ''  END,      
  @temp6 += CASE When ISNULL(GenitourinaryUseDiuretics,'N')<>'N' then '  Use of Diuretics, '  else '' END,      
  @temp6 += CASE When ISNULL(GenitourinaryCloudyBloodyUrine,'N')<>'N' then ' Cloudy/Bloody Urine, '  else '' END,      
  @temp6 += CASE When ISNULL(GenitourinaryFlankPain,'N')<>'N' then' Flank Pain, '  else ''  END,      
  @temp6 += CASE When ISNULL(GenitourinaryKidneyStone,'N')<>'N' then ' Kidney Stones, '  else '' END,      
  @temp6 += CASE When ISNULL(GenitourinaryVaginalPenisDischarge,'N')<>'N' then ' Vaginal/Penis Discharge, '  else ''  END,      
  @temp6 += CASE When ISNULL(GenitourinaryItchingGenitalArea,'N')<>'N' then ' Itching in genital Area, '  else '' END,       
  @temp6 += CASE When ISNULL(GenitourinarySTDs,'N')<>'N' then ' STD�s, '  else '' END,      
  @temp6 += CASE When ISNULL(GenitourinarySexualDysfunction,'N')<>'N' then ' Sexual Dysfunction, '  else ''  END,       
  @temp6 += CASE When ISNULL(GenitourinaryHyperlactermia,'N')<>'N' then ' Hyperlactermia, '  else '' END,      
  @temp6 += CASE When ISNULL(GenitourinaryPenileSore,'N')<>'N' then ' Penile Sores, '  else ''  END,      
  @temp6 += CASE When ISNULL(GenitourinaryTesticularPain,'N')<>'N' then ' Testicular Pain, '  else '' END,        
  @temp6 += CASE When ISNULL(GenitourinaryProstateProblem,'N')<>'N' then ' Prostate Problems, '  else '' END,      
  @temp6 += CASE When ISNULL(GenitourinaryRegularPeriod,'N')<>'N' then ' Regular Periods, '  else ''  END,      
  @temp6 += CASE When ISNULL(GenitourinaryMeopause,'N')<>'N' then ' Menopause, '  else '' END,      
  @temp6 += CASE When ISNULL(GenitourinaryPregnant,'N')<>'N' then ' Pregnant, '  else '' END,      
  @temp6 += CASE When ISNULL(GenitourinaryDateLastPapSmear,'N')<>'N' then ' Date of Last Pap Smear, '  else ''  END,      
  @temp6 += CASE When GenitourinaryDateLastPapSmearDate IS Not null then CAST(GenitourinaryDateLastPapSmearDate AS VARCHAR(20)) +', ' else '' END,      
  @temp6 += CASE When GenitourinaryTotalNumberPregnancy IS Not null then ' Total Number of Pregnancies '+  CAST (GenitourinaryTotalNumberPregnancy AS Varchar(10))+', ' else '' END,      
  @temp6 += CASE When GenitourinaryNoOfLiveBirth IS Not null then ' # of Live Births, ' + CAST(GenitourinaryNoOfLiveBirth AS Varchar(10))+', '  else ''  END,      
  @temp6 += CASE When GenitourinaryNoOfMiscarriage IS Not null then ' # of Miscarriages '+ CAST(GenitourinaryNoOfMiscarriage AS Varchar(10))+', ' else '' END,        
  @temp6 += CASE When GenitourinaryNoOfAbortion IS Not null then ' # of Miscarriages '+ CAST(GenitourinaryNoOfAbortion AS Varchar(10))+', ' else '' END,        
  @temp6Comment = CASE When ISNULL(cast(GenitourinaryComment AS varchar),'N')<>'N' then '<br>Comments:&nbsp;&nbsp; '+ cast( GenitourinaryComment as Varchar(max)) else '' END,      
      
  @temp7 += CASE When ISNULL(SkinBreastNotApplicable,'N')<>'N' then ' Not Applicable, ' else '' END,      
  @temp7 += CASE When ISNULL(SkinBreastNoChange,'N')<>'N' then ' No Change, '  else '' END,      
  @temp7 += CASE When ISNULL(SkinBreastInadequateHygiene,'N')<>'N'  then ' Inadequate Hygiene, ' else ''  END,      
  @temp7 += CASE When ISNULL(SkinBreastFlushedJaundiced,'N')<>'N'   then '  Flushed Jaundiced, '  else ''  END,      
  @temp7 += CASE When ISNULL(SkinBreastPoorSkinTurgor,'N')<>'N'  then ' Poor Skin Turgor, '  else '' END,      
  @temp7 += CASE When ISNULL(SkinBreastRash,'N')<>'N'  then ' Rash, '  else ''  END,      
  @temp7 += CASE When ISNULL(SkinBreastSore,'N')<>'N' then '  Sores, '  else '' END,      
  @temp7 += CASE When ISNULL(SkinBreastitching,'N')<>'N' then ' itching, '  else '' END,      
  @temp7 += CASE When ISNULL(SkinBreastDrySkin,'N')<>'N' then' Dry Skin, '  else ''  END,      
  @temp7 += CASE When ISNULL(SkinBreastChangeSkinColor,'N')<>'N' then ' Change in Skin Color, '  else '' END,      
  @temp7 += CASE When ISNULL(SkinBreastChangeHairNail,'N')<>'N' then '  Change in Hair/Nails, '  else ''  END,      
  @temp7 += CASE When ISNULL(SkinBreastVaricoseVain,'N')<>'N' then ' Varicose Veins, '  else '' END,      
  @temp7 += CASE When ISNULL(SkinBreastBreastPain,'N')<>'N' then ' Breast Pain, '  else '' END,      
  @temp7 += CASE When ISNULL(SkinBreastBreastLump,'N')<>'N' then ' Breast Lumps, '  else ''  END,        
  @temp7 += CASE When ISNULL(SkinBreastBreastDischarge,'N')<>'N' then ' Breast Discharge, '  else '' END,       
  @temp7Comment = CASE When ISNULL(cast(SkinBreastComment AS varchar),'N')<>'N' then '<br>Comments:&nbsp;&nbsp; '+ cast( SkinBreastComment as Varchar(max)) else '' END,    
     
  @temp8 += CASE When ISNULL(ENTNotApplicable,'N')<>'N' then ' Not Applicable, ' else '' END,      
  @temp8 += CASE When ISNULL(ENTNoChange,'N')<>'N' then ' No Change, '  else '' END,      
  @temp8 += CASE When ISNULL(ENTHearingLossRinin,'N')<>'N'  then ' Hearing Loss or Rining, ' else ''  END,      
  @temp8 += CASE When ISNULL(ENTEarachesDrainage,'N')<>'N'   then '  Earaches or Drainage, '  else ''  END,      
  @temp8 += CASE When ISNULL(ENTChronicSinusProblemsRhinitis,'N')<>'N'  then ' Chronic Sinus Problems or Rhinitis, '  else '' END,      
  @temp8 += CASE When ISNULL(ENTNoseBleed,'N')<>'N'  then ' Nose Bleeds, '  else ''  END,      
  @temp8 += CASE When ISNULL(ENTMouthSore,'N')<>'N' then ' Mouth Sores, '  else '' END,      
  @temp8 += CASE When ISNULL(ENTBleedingGum,'N')<>'N' then ' Bleeding Gums, '  else '' END,      
  @temp8 += CASE When ISNULL(ENTBadBreathTaste,'N')<>'N' then' Bad Breath/Taste, '  else ''  END,      
  @temp8 += CASE When ISNULL(ENTSoreThroat,'N')<>'N' then ' Sore Throat, '  else '' END,      
  @temp8 += CASE When ISNULL(ENTVoiceChange,'N')<>'N' then ' Voice Change, '  else ''  END,      
  @temp8 += CASE When ISNULL(ENTSwollenGlandsNeck,'N')<>'N' then ' Swollen Glands in Neck, '  else '' END , 
  @temp8Comment = CASE When ISNULL(cast(ENTComment AS varchar),'N')<>'N' then '<br>Comments:&nbsp;&nbsp; '+ cast(ENTComment as Varchar(max)) else '' END  
 
 
 from CustomDocumentHealthMedicalHistory AS HMH    
 Left outer Join CustomLMHSMedicalHealthProblems CMHP on HMH.DocumentVersionId = CMHP.DocumentVersionId
 Join Documentversions DV ON HMH.DocumentVersionId=DV.DocumentVersionId     
 Join documents ds ON DV.DocumentVersionId=ds.CurrentDocumentVersionId      
    Where ds.ClientId=@ClientId    
     AND isnull(HMH.RecordDeleted,'N') ='N'    
  AND isnull(DV.RecordDeleted,'N') = 'N'    
  AND isnull(DS.RecordDeleted,'N') = 'N'    
  AND DS.Status = 22 --signed    (Commented for testing need to uncomment)
  and not exists ( select *    
                                     from   Documents as ds2    
                                     where  ds2.ClientId = ds.ClientId    
           and ds2.DocumentCodeId = ds.DocumentCodeId    
                                            and ds2.Status = 22 -- signed     (Commented for testing need to uncomment)
                                            and ISNULL(ds2.RecordDeleted,    
                                                      'N') <> 'Y'    
                                            and (    
                                                 (ds2.EffectiveDate > ds.EffectiveDate)    
                                                 or (    
                                                     ds2.EffectiveDate = ds.EffectiveDate    
                                                     and ds2.DocumentId > ds.DocumentId    
                                                    )    
                                                ) )    
                                                
   
   
   DECLARE @LatestHealthHistoryDocumentVersionId int
   
   SELECT TOP 1 @LatestHealthHistoryDocumentVersionId=a.CurrentDocumentVersionid
      FROM Documents a
      INNER JOIN DocumentCodes Dc ON Dc.DocumentCodeid = a.DocumentCodeid
      WHERE a.ClientId = @Clientid
            AND a.[Status] = 22
            AND Dc.DocumentCodeId = 40001
            AND CAST(a.EffectiveDate AS DATE) <= CAST(getdate() AS DATE)
            AND ISNULL(a.RecordDeleted, 'N') <> 'Y'
            AND ISNULL(Dc.RecordDeleted, 'N') <> 'Y'
      ORDER BY a.EffectiveDate DESC,a.ModifiedDate DESC                                             
     --- Cursor---
     
     
declare @ProblemHeader varchar(max)
declare @ProblemBody varchar(max)
declare @FinalProblemHTML varchar(max)

Declare @ProblemId int
Declare @ProblemId_old int
set @ProblemId_old =0
  Declare @CodeName VARCHAR(100)
	Declare @HistoricalOrCurrent VARCHAR(100) 
	Declare @HealthProblemDate datetime
	Declare @HealthProblemDateString nvarchar(MAX)
	Declare @Description VARCHAR(100) 
	 set @FinalProblemHTML='' 
	 Set @ProblemBody = '' 
	 set @ProblemHeader = ''
	 set @HealthProblemDateString=''
 DECLARE Significant_cursor CURSOR FOR
Select CMHP.ProblemId, CMHP.HistoricalOrCurrent,CMHP.HealthProblemDate,CMHP.Description,gc.CodeName
				from CustomDocumentHealthMedicalHistory AS HMH    
				  join CustomLMHSMedicalHealthProblems CMHP on HMH.DocumentVersionId = CMHP.DocumentVersionId
				  LEFT join Globalcodes gc on gc.globalcodeid=CMHP.ProblemId
				   Where CMHP.DocumentVersionId=@LatestHealthHistoryDocumentVersionId
				AND isnull(CMHP.RecordDeleted,'N') ='N'    
				   AND isnull(HMH.RecordDeleted,'N') ='N'    
				  
				  
				  order By gc.CodeName,CMHP.HealthProblemDate Desc
  Open Significant_cursor
   
  FETCH NEXT FROM Significant_cursor
	  INTO @ProblemId, @HistoricalOrCurrent,@HealthProblemDate,@Description,@CodeName


	WHILE @@FETCH_STATUS = 0
	BEGIN
	
		IF (@HistoricalOrCurrent = 'H') 
		SET @HistoricalOrCurrent= 'Historical' 
		Else 
		SET @HistoricalOrCurrent= 'Current' 
		
	 IF( @ProblemId_old <> @ProblemId)
	 BEGIN
	
	  set @temp11= @temp11 +   @ProblemHeader +  @ProblemBody 
	
	    if(len(@temp11) >1)
	  --set @temp11= @temp11 + '</table>'
	  
		 --set @ProblemHeader=  '<table><tr><td colspan=3>' + @CodeName  + '</td></tr><tr><td colspan=2><b>Type</b</td><td colspan=2><b>Date</b></td><td colspan=2><b>Description</b></td></tr>'
		   SET @ProblemHeader = '<br><b>' + @CodeName + '</b><br><b>Type</b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Date</b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Description</b><br>' 
	  Set @ProblemBody=''
	 END
	 --Set @ProblemBody = ISNULL(@ProblemBody, '')  + '<tr><td colspan=2>'  + @HistoricalOrCurrent + '</td><td colspan=2>'+CASE WHEN @HealthProblemDate IS NOT NULL THEN Convert(Varchar(10),@HealthProblemDate,101) ELSE 'Unknown' END +'</td><td colspan=2>'+ ISNULL(@Description, '')+'</td></tr>'
	   SET @ProblemBody = ISNULL(@ProblemBody, '') + @HistoricalOrCurrent + CASE WHEN @HistoricalOrCurrent='Current' THEN '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' ELSE '&nbsp;&nbsp;&nbsp;&nbsp;' end + CASE  
		 
		 WHEN @HealthProblemDate IS NOT NULL  
			THEN Convert(VARCHAR(10), @HealthProblemDate, 101)  
			ELSE 'Unknown'+'&nbsp;&nbsp;&nbsp;'  
		 END + '&nbsp;&nbsp;&nbsp;&nbsp;' + ISNULL(@Description, '') + '<br>'  	
		 
		 Set @ProblemId_old = @ProblemId
		 
		 FETCH NEXT FROM Significant_cursor
	  INTO @ProblemId, @HistoricalOrCurrent,@HealthProblemDate,@Description,@CodeName
	END
	  CLOSE Significant_cursor;
	 DEALLOCATE Significant_cursor;
--set @FinalProblemHTML= @FinalProblemHTML + @ProblemHeader +  @ProblemBody + '</table>'

set @temp11= @temp11 + @ProblemHeader +  @ProblemBody + '</table>'


 --  Declare @ProblemId int
 --  Declare @CodeName VARCHAR(100)
   
 --  Declare @ProblemId_old int
 --  -- FOR Inner cursor
 --  Declare @Type VARCHAR(100)
 --  Declare @Date datetime
 --  Declare @Decription VARCHAR(500)
   

 --  Declare @inner_cursor cursor
 --  declare @fetch_inner_cursor int
 --  Declare @HealthProblemDate VARCHAR(50)
    
 --  SET @ProblemId = 0
 --  SET @ProblemId_old = 0
   
 --  DECLARE Significant_cursor CURSOR FOR
	--   Select  CMHP.ProblemId,gc.CodeName  from CustomDocumentHealthMedicalHistory AS HMH    
	--  join CustomLMHSMedicalHealthProblems CMHP on HMH.DocumentVersionId = CMHP.DocumentVersionId
	--   Join Documentversions DV ON HMH.DocumentVersionId=DV.DocumentVersionId 
	--   Join documents ds ON DV.DocumentVersionId= ds.CurrentDocumentVersionId 
	--   Join globalcodes gc on gc.GlobalCodeId =  CMHP.ProblemId
	--   Where ds.ClientId = @ClientId 
	--   AND isnull(HMH.RecordDeleted,'N') ='N'    
	--  AND isnull(DV.RecordDeleted,'N') = 'N'    
	--  AND isnull(DS.RecordDeleted,'N') = 'N' 
	--  Order by ProblemId
	  
		
 -- --PRINT  '@ProblemId 1:' + cast(@ProblemId  as varchar(50))    
  
 -- Open Significant_cursor
  
 -- FETCH NEXT FROM Significant_cursor
 --     INTO @ProblemId,@CodeName 

	--WHILE @@FETCH_STATUS = 0
	--BEGIN
	--  --PRINT  '@ProblemId 2 :' + cast(@ProblemId  as varchar(50))     
	  
	---- Set @temp10  =  @temp10 + '<br>' +@CodeName 
	 
	--    IF( @ProblemId_old <> @ProblemId)
	--      BEGIN
	--		  SET @temp9 = @temp9 + '<br><br>' + @CodeName  
	--		  SET @temp9  = @temp9 + '<br>''---------------------------------------------'
	--		  --Print @CodeName 
	--		 -- Print '------------------'
			  
	--		  set @inner_cursor  = cursor static local for
	--			Select CMHP.HistoricalOrCurrent,
	--			CMHP.HealthProblemDate,CMHP.Description 
	--			from CustomDocumentHealthMedicalHistory AS HMH    
	--			  join CustomLMHSMedicalHealthProblems CMHP on HMH.DocumentVersionId = CMHP.DocumentVersionId
	--			   Join Documentversions DV ON HMH.DocumentVersionId=DV.DocumentVersionId 
	--			   Join documents ds ON DV.DocumentVersionId= ds.CurrentDocumentVersionId 
	--			   Join globalcodes gc on gc.GlobalCodeId =  CMHP.ProblemId
	--			   Where ds.ClientId = 1001970 
	--			   and CMHP.ProblemId = @ProblemId
	--			   AND isnull(HMH.RecordDeleted,'N') ='N'    
	--			  AND isnull(DV.RecordDeleted,'N') = 'N'    
	--			  AND isnull(DS.RecordDeleted,'N') = 'N' 
		  
	--		open @inner_cursor
	--				fetch next from @inner_cursor into @Type, @Date , @Decription 
	--				set @fetch_inner_cursor = @@FETCH_STATUS
	--		while @fetch_inner_cursor = 0
	--		begin
	--		     Set @HealthProblemDate =  CONVERT(varchar(23), @Date, 121)
	--		     --Print '@HealthProblemDate' +  @HealthProblemDate
			     
	--			 --print cast(@Type  as varchar(50)) + ','  + cast(@Decription as varchar(500)) 
	--			 SET @temp11 = @temp11 + '<br>' + @Type + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' 
	--	         SET @temp11 = @temp11  +  @Decription
	--		fetch next from @inner_cursor into @Type, @Date, @Decription
	--			set @fetch_inner_cursor = @@FETCH_STATUS
	--		end
		
	--		close @inner_cursor
	--		deallocate @inner_cursor
 --         END
 
	-- Set @ProblemId_old = @ProblemId
	
	-- FETCH NEXT FROM Significant_cursor
 --     INTO @ProblemId,@CodeName 
 --   --PRINT  '@ProblemId 2 :' + cast(@ProblemId  as varchar(50))     
 --   --PRINT  '@@ProblemId_old 2 :' + cast(@ProblemId_old  as varchar(50))     
   
	--END
	
 --    CLOSE Significant_cursor;
 --    DEALLOCATE Significant_cursor;
 
 --- End Cursor ----
     
        
    set @temp =substring(@temp,  1, (len(@temp)  - 1))+ISNULL(@tempComment,'')      
    set @temp1=substring(@temp1, 1, (len(@temp1) - 1))+ISNULL(@temp1Comment,'')      
    set @temp2=substring(@temp2, 1, (len(@temp2) - 1))+ISNULL(@temp2Comment,'')      
    set @temp3=substring(@temp3, 1, (len(@temp3) - 1))+ISNULL(@temp3Comment,'')      
    set @temp4=substring(@temp4, 1, (len(@temp4) - 1))+isnull(@temp4Comment,'')      
    set @temp5=substring(@temp5, 1, (len(@temp5) - 1))+ISNULL(@temp5Comment,'')      
    set @temp6=substring(@temp6, 1, (len(@temp6) - 1))+ISNULL(@temp6Comment,'')      
    set @temp7=substring(@temp7, 1, (len(@temp7) - 1))+ISNULL(@temp7Comment,'')      
    set @temp8=substring(@temp8, 1, (len(@temp8) - 1))+ISNULL(@temp8Comment,'')
    set @temp9=substring(@temp9, 1, (len(@temp9) - 1))+ISNULL(@temp9Comment,'')
   -- set @temp10=substring(@temp10, 1, (len(@temp10) - 1))+ISNULL(@temp9Comment,'')
    set @temp11=substring(@temp11, 1, (len(@temp11) - 1))+ISNULL(@temp9Comment,'')
    --set @temp9=substring(@temp9, 1, (len(@temp9) - 1))   
      END
  -- Select  @FinalProblemHTML  AS FinalProblemHTML
   
   IF LEN(@temp) > LEN(@tempbase) OR    
  LEN(@temp1)> LEN(@tempbase1) OR    
  LEN(@temp2)> LEN(@tempbase2) OR      
  LEN(@temp3)> LEN(@tempbase3) OR        
  LEN(@temp4)> LEN(@tempbase4) OR        
  LEN(@temp5)> LEN(@tempbase5) OR        
  LEN(@temp6)> LEN(@tempbase6) OR       
  LEN(@temp7)> LEN(@tempbase7) OR      
  LEN(@temp8)> LEN(@tempbase8) OR   
  LEN(@temp9)> LEN(@tempbase9) OR
  --LEN(@temp10)> LEN(@tempbase10) OR
  LEN(@temp11)> LEN(@tempbase11) 
  
    
     
 begin  
  
   --select '<span style=''color:black''>' + @temp+@temp1+@temp2+@temp3+@temp4+@temp5+@temp6+@temp7+@temp8+@temp9+@temp10+ @temp11'</span>'   
   select '<span style=''color:black''>' + @temp+@temp1+@temp2+@temp3+@temp4+@temp5+@temp6+@temp7+@temp8+@temp9 + @temp11'</span>'         
   end    
   else    
   select '<span style=''color:black''>' + @notfound + '</span>'      
   --print @temp9
       
       

END 
GO
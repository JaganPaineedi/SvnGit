If Exists (Select * From   sys.Objects 
           Where  Object_Id = Object_Id(N'dbo.csp_validateCustomDocumentSUAdmissions') 
                  And Type In ( N'P', N'PC' )) 
	Drop Procedure dbo.csp_validateCustomDocumentSUAdmissions
Go

Set Ansi_Nulls On
Set Quoted_Identifier On
Go

Create Procedure [dbo].[csp_validateCustomDocumentSUAdmissions]          
@DocumentVersionId INT

AS          
/******************************************************************************                                          
**  File: [csp_validateCustomDocumentSUAdmissions]                                      
**  Name: [csp_validateCustomDocumentSUAdmissions]                  
**  Desc: For Validation  on SUAdmissions
**  Return values: Resultset having validation messages                                          
**  Called by:                                           
**  Parameters:                      
**  Auth:  Anto                        
**  Date:  FEB 02 2015       
--23-March-2015 SuryaBalan Copied from valley to New Directions Customization Task 4    
--23-March-2015 SuryaBalan Fixed Validation foe "Where client was referred"  
--26-March-2015  SuryaBalan Commented Diagnosis -A&D Dx is required validation Task 4 New Directions Customizations  
--26-March-2015  SuryaBalan  Fixed Number of Arrests In Past 30 Days is required     
--26-March-2015 SuryaBalan Commented ReferredASAM  
Rev#1 07/10/15 Paul Ongwela -	Fix error when "Age of First Use" the radio button for 'NA' or 'unknown' is selected,
								it still requires a number to be entered into the field.      
*******************************************************************************/                                        
          
Begin                                                        
                  
  Begin try               
--*TABLE CREATE*--                       
--DECLARE  @CustomDocumentSUAdmissions TABLE(     

DECLARE  @CustomDocumentSUAdmissions TABLE(     

		DocumentVersionId				int						NOT NULL,	
		RecordDeleted					type_YOrN				NULL,
		DeletedBy						type_UserId				NULL,
		DeletedDate						datetime				NULL,
		ProgramId						int						NULL,	
		AdmissionEntryDate 				datetime 				NULL,
		AssessmentDate					datetime 				NULL,
		AdmissionType					type_GlobalCode		    NULL,
		AdmissionProgramType			type_GlobalCode		    NULL,
		ReferralSource 					type_GlobalCode		    NULL,
		SourceOfPayment 				type_GlobalCode		    NULL,
		PregnantAdmission 				varchar(20)				NULL,  
		PriorEpisode    				type_GlobalCode		    NULL,
		SocialSupports 					type_GlobalCode		    NULL,
		VeteransStatus					type_GlobalCode		    NULL,
		AdmittedPopulation 				type_GlobalCode		    NULL,
		AdmittedASAM					type_GlobalCode		    NULL,
		ReferredASAM					type_GlobalCode		    NULL,
		StateCode						type_GlobalCode		    NULL,
		NumberOfArrests 				int 					NULL,
		NumberOfArrestsLast12Months     int                     NULL,
		DrugCourtParticipation 			type_GlobalCode		    NULL,
		--DoraStatus 						type_GlobalCode		    NULL,
		CurrentlyOnProbation			varchar(20)   			NULL,
		Jurisdiction 					varchar(20)    			NULL,								
		CurrentlyOnParole  				varchar(20)				NULL,		
		LivingArrangement 				type_GlobalCode		    NULL,
		Household 						varchar(100)		    NULL,
		Children						varchar(100)		    NULL,
		HouseholdIncome					varchar(100)		    NULL,
		MaritalStatus					type_GlobalCode		    NULL,
		EmploymentStatus    			type_GlobalCode		    NULL,
		PrimarySourceOfIncome  			type_GlobalCode		    NULL,
		EnrolledEducation				type_GlobalCode		    NULL,
		Gender							type_GlobalCode		    NULL,		
		Race							type_GlobalCode		    NULL,
		Ethnicity						type_GlobalCode		    NULL,
		CoDependent 					type_YOrN             	NULL,
		CoOccurringMentalHealth         type_YOrN             	NULL,
		PharmocotherapyPlanned          type_YOrN             	NULL,
		--OpioidReplacementTherapy  		type_GlobalCode		    NULL,
		TobaccoUse   					type_GlobalCode		    NULL,
		AgeOfFirstTobaccoText			varchar(25)				NULL,
		AgeOfFirstTobacco				char(1)					NULL,
		PreferredUsage1					type_GlobalCode		    NULL,
		DrugName1  						type_GlobalCode		    NULL,
		Frequency1   					type_GlobalCode		    NULL,
		Route1  						type_GlobalCode		    NULL,
		AgeOfFirstUseText1				varchar(25)				NULL,
		AgeOfFirstUse1					char(1)					NULL,
		PreferredUsage2					type_GlobalCode		    NULL,
		DrugName2  						type_GlobalCode		    NULL,
		Frequency2    					type_GlobalCode		    NULL,
		Route2  						type_GlobalCode		    NULL,
		AgeOfFirstUseText2				varchar(25)				NULL,
		AgeOfFirstUse2					char(1)					NULL,
		PreferredUsage3					type_GlobalCode		    NULL,
		DrugName3  						type_GlobalCode		    NULL,
		Frequency3    					type_GlobalCode		    NULL,
		Route3  						type_GlobalCode		    NULL,
		AgeOfFirstUseText3				varchar(25)				NULL,
		AgeOfFirstUse3					char(1)					NULL

)      
DECLARE  @CustomDocumentInfectiousDiseaseRiskAssessments TABLE(
			DocumentVersionId						int ,
					
			RecordDeleted							type_YOrN NULL,
			DeletedBy								type_UserId NULL,
			DeletedDate								datetime ,
			AnyHealthCareProvider					char(1) ,
			LivedStreetOrShelter					char(1)  ,
			EverBeenJailPrisonJuvenile				char(1)  ,
			EverBeenCareFacility					char(1)  ,
			WhereBorn								varchar(50) ,
			TraveledOrLivedOutsideUS				char(1)  ,
			HowLongBeenInUS							varchar(50) ,
			CombatVeteran							char(1)  ,
			HadTatooEarPiercingAcupunture			char(1)  ,
			Nausea									char(1) ,
			Fever									char(1) ,
			DrenchingNightSweats					char(1) ,
			ProductiveCough							char(1) ,
			CoughingUpBlood							char(1) ,
			ShortnessOfBreath						char(1) ,
			LumpsSwollenGlands						char(1) ,
			DiarrheaLastingMoreThanWeek				char(1) NULL,
			LosingWeightWithoutMeaning				char(1) ,
			BrownTingedUrine						char(1) ,
			ExtremeFatigue							char(1) ,
			Jaundice								char(1) ,
			NoSymptoms								char(1) ,
			MissedLastTwoPeriods					char(1) ,
			WomanMissedLast2Periods					varchar(100) ,
			EverBeenToldYouHaveTB					char(1)  ,
			EverBeenHadPositiveSkinTestTB			char(1)  ,
			EverBeenTreatedForTB					char(1)  ,
			EverBeenToldYouHaveHepatitisA			char(1)  ,
			EverBeenToldYouHaveHepatitisB			char(1)  ,
			EverBeenToldYouHaveHepatitisC			char(1)  ,
			EverUsedNeedlesToShootDrugs				char(1)  ,
			EverSharedNeedlesSyringesToInjectDrugs	char(1)  ,
			EverHadNeedleStickInjuriesOrBloodContact	char(1)  ,
			UseStimulants							char(1) ,
			PastTwelveMonthsHadSexWithAnyWithHepatitis	char(1)  ,
			ReceiveBloodTransfusionBefore1992		char(1)  ,
			ReceivedBloodProductsBefore1987			char(1)  ,
			BirthMotherInfectedWithHepatitisC		char(1)  ,
			EverBeenLongTermKidneyDialysis			char(1)  ,
			UnprotectedSexWithHemophiliaPatient		char(1)  ,
			UnprotectedSexWithManWithOtherMen		char(1)  ,
			HadSexExchangeMoneyOrDrugs				char(1)  ,
			HadSexMoreThanOnePersonPastSixMonths	char(1)  ,
			HadSexWithAIDSPersonOrHepatitisC		char(1)  ,
			EverInjectedDrugsEvenOnce				char(1)  ,
			EvenBeenPrickedByNeedle					char(1)  ,
			EverHadDrinkingProblemCounselling		char(1)  ,
			EverBeenToldDrinkingProblem				char(1)  ,
			EverHadBloodTestForHIVAntibody			char(1) ,
			BeenTestedWithinLastSixMonthsHIV		char(1) ,
			WouldYouLikeBloodTestHIV				char(1) ,
			EverHadBloodTestForHepatitisC			char(1) ,
			BeenTestedWithinLastSixMonthsHepatitisC	char(1) ,
			WouldYouLikeBloodTestHepatitisC			char(1) ,
			JudgeOwnRiskInfectedWithHIV				char ,
			JudgeOwnRiskInfectedWithHepatitisC		char ,
			ClientAssessed							char(1) ,
			ClientReferredHealthOrAgency			char(1) ,
			ClientReferredWhere						varchar(100)    )  
			
			
INSERT INTO @CustomDocumentInfectiousDiseaseRiskAssessments(
			DocumentVersionId,
			
			RecordDeleted,
			DeletedBy,
			DeletedDate,
			AnyHealthCareProvider,
			LivedStreetOrShelter,
			EverBeenJailPrisonJuvenile,
			EverBeenCareFacility,
			WhereBorn,
			TraveledOrLivedOutsideUS,
			HowLongBeenInUS,
			CombatVeteran,
			HadTatooEarPiercingAcupunture,
			Nausea,
			Fever,
			DrenchingNightSweats,
			ProductiveCough,
			CoughingUpBlood,
			ShortnessOfBreath,
			LumpsSwollenGlands,
			DiarrheaLastingMoreThanWeek,
			LosingWeightWithoutMeaning,
			BrownTingedUrine,
			ExtremeFatigue,
			Jaundice,
			NoSymptoms,
			MissedLastTwoPeriods,
			WomanMissedLast2Periods,
			EverBeenToldYouHaveTB,
			EverBeenHadPositiveSkinTestTB,
			EverBeenTreatedForTB,
			EverBeenToldYouHaveHepatitisA,
			EverBeenToldYouHaveHepatitisB,
			EverBeenToldYouHaveHepatitisC,
			EverUsedNeedlesToShootDrugs,
			EverSharedNeedlesSyringesToInjectDrugs,
			EverHadNeedleStickInjuriesOrBloodContact,
			UseStimulants,
			PastTwelveMonthsHadSexWithAnyWithHepatitis,
			ReceiveBloodTransfusionBefore1992,
			ReceivedBloodProductsBefore1987,
			BirthMotherInfectedWithHepatitisC,
			EverBeenLongTermKidneyDialysis,
			UnprotectedSexWithHemophiliaPatient,
			UnprotectedSexWithManWithOtherMen,
			HadSexExchangeMoneyOrDrugs,
			HadSexMoreThanOnePersonPastSixMonths,
			HadSexWithAIDSPersonOrHepatitisC,
			EverInjectedDrugsEvenOnce,
			EvenBeenPrickedByNeedle,
			EverHadDrinkingProblemCounselling,
			EverBeenToldDrinkingProblem,
			EverHadBloodTestForHIVAntibody,
			BeenTestedWithinLastSixMonthsHIV,
			WouldYouLikeBloodTestHIV,
			EverHadBloodTestForHepatitisC,
			BeenTestedWithinLastSixMonthsHepatitisC,
			WouldYouLikeBloodTestHepatitisC,
			JudgeOwnRiskInfectedWithHIV,
			JudgeOwnRiskInfectedWithHepatitisC,
			ClientAssessed,
			ClientReferredHealthOrAgency,
			ClientReferredWhere		)	 
			
SELECT DocumentVersionId,
			
			RecordDeleted,
			DeletedBy,
			DeletedDate,
			AnyHealthCareProvider,
			LivedStreetOrShelter,
			EverBeenJailPrisonJuvenile,
			EverBeenCareFacility,
			WhereBorn,
			TraveledOrLivedOutsideUS,
			HowLongBeenInUS,
			CombatVeteran,
			HadTatooEarPiercingAcupunture,
			Nausea,
			Fever,
			DrenchingNightSweats,
			ProductiveCough,
			CoughingUpBlood,
			ShortnessOfBreath,
			LumpsSwollenGlands,
			DiarrheaLastingMoreThanWeek,
			LosingWeightWithoutMeaning,
			BrownTingedUrine,
			ExtremeFatigue,
			Jaundice,
			NoSymptoms,
			MissedLastTwoPeriods,
			WomanMissedLast2Periods,
			EverBeenToldYouHaveTB,
			EverBeenHadPositiveSkinTestTB,
			EverBeenTreatedForTB,
			EverBeenToldYouHaveHepatitisA,
			EverBeenToldYouHaveHepatitisB,
			EverBeenToldYouHaveHepatitisC,
			EverUsedNeedlesToShootDrugs,
			EverSharedNeedlesSyringesToInjectDrugs,
			EverHadNeedleStickInjuriesOrBloodContact,
			UseStimulants,
			PastTwelveMonthsHadSexWithAnyWithHepatitis,
			ReceiveBloodTransfusionBefore1992,
			ReceivedBloodProductsBefore1987,
			BirthMotherInfectedWithHepatitisC,
			EverBeenLongTermKidneyDialysis,
			UnprotectedSexWithHemophiliaPatient,
			UnprotectedSexWithManWithOtherMen,
			HadSexExchangeMoneyOrDrugs,
			HadSexMoreThanOnePersonPastSixMonths,
			HadSexWithAIDSPersonOrHepatitisC,
			EverInjectedDrugsEvenOnce,
			EvenBeenPrickedByNeedle,
			EverHadDrinkingProblemCounselling,
			EverBeenToldDrinkingProblem,
			EverHadBloodTestForHIVAntibody,
			BeenTestedWithinLastSixMonthsHIV,
			WouldYouLikeBloodTestHIV,
			EverHadBloodTestForHepatitisC,
			BeenTestedWithinLastSixMonthsHepatitisC,
			WouldYouLikeBloodTestHepatitisC,
			JudgeOwnRiskInfectedWithHIV,
			JudgeOwnRiskInfectedWithHepatitisC,
			ClientAssessed,
			ClientReferredHealthOrAgency,
			ClientReferredWhere	
			
			FROM CustomDocumentInfectiousDiseaseRiskAssessments	 CDIDR
			where  CDIDR.DocumentVersionId=@DocumentVersionId   and isnull(CDIDR.RecordDeleted,'N')<>'Y'    

			
INSERT INTO @CustomDocumentSUAdmissions(    
			DocumentVersionId,			
			RecordDeleted,
			DeletedBy,
			DeletedDate,
			ProgramId,
			AdmissionEntryDate, 
			AssessmentDate,
			AdmissionType,
			AdmissionProgramType,
			ReferralSource, 
			SourceOfPayment, 
			PregnantAdmission, 
			PriorEpisode,    
			SocialSupports, 
			VeteransStatus,
			AdmittedPopulation, 
			AdmittedASAM,
			ReferredASAM,
			StateCode,
			NumberOfArrests, 
			NumberOfArrestsLast12Months,
			DrugCourtParticipation, 
			--DoraStatus, 
			CurrentlyOnProbation,
			Jurisdiction, 
			CurrentlyOnParole, 
			LivingArrangement, 
			Household, 
			Children,
			HouseholdIncome,
			MaritalStatus,
			EmploymentStatus,    
			PrimarySourceOfIncome,  
			EnrolledEducation,
			Gender,
			Race,
			Ethnicity,
			CoDependent,
			CoOccurringMentalHealth, 
			PharmocotherapyPlanned,
			--OpioidReplacementTherapy,  
			TobaccoUse,   
			AgeOfFirstTobaccoText,
			AgeOfFirstTobacco,
			PreferredUsage1,
			DrugName1, 
			Frequency1,   
			Route1,  
			AgeOfFirstUseText1,
			AgeOfFirstUse1,
			PreferredUsage2,
			DrugName2,  
			Frequency2,    
			Route2,  
			AgeOfFirstUseText2,
			AgeOfFirstUse2,
			PreferredUsage3,
			DrugName3,  
			Frequency3,    
			Route3,  
			AgeOfFirstUseText3,
			AgeOfFirstUse3

)
             
--*Select LIST*--                  
SELECT  
			DocumentVersionId,			
			RecordDeleted,
			DeletedBy,
			DeletedDate,
			ProgramId,
			AdmissionEntryDate, 
			AssessmentDate,
			AdmissionType,
			AdmissionProgramType,
			ReferralSource, 
			SourceOfPayment, 
			PregnantAdmission, 
			PriorEpisode,    
			SocialSupports, 
			VeteransStatus,
			AdmittedPopulation, 
			AdmittedASAM,
			ReferredASAM,
			StateCode,
			NumberOfArrests, 
			NumberOfArrestsLast12Months,
			DrugCourtParticipation, 
			--DoraStatus, 
			CurrentlyOnProbation,
			Jurisdiction, 
			CurrentlyOnParole, 
			LivingArrangement, 
			Household, 
			Children,
			HouseholdIncome,
			MaritalStatus,
			EmploymentStatus,    
			PrimarySourceOfIncome,  
			EnrolledEducation,
			Gender,
			Race,
			Ethnicity,
			CoDependent, 
			CoOccurringMentalHealth,
			PharmocotherapyPlanned,
			--OpioidReplacementTherapy,  
			TobaccoUse,   
			AgeOfFirstTobaccoText,
			AgeOfFirstTobacco,
			PreferredUsage1,
			DrugName1, 
			Frequency1,   
			Route1,  
			AgeOfFirstUseText1,
			AgeOfFirstUse1,
			PreferredUsage2,
			DrugName2,  
			Frequency2,    
			Route2,  
			AgeOfFirstUseText2,
			AgeOfFirstUse2,
			PreferredUsage3,
			DrugName3,  
			Frequency3,    
			Route3,  
			AgeOfFirstUseText3,
			AgeOfFirstUse3
		  

from dbo.CustomDocumentSUAdmissions C               
where  C.DocumentVersionId=@DocumentVersionId   and isnull(C.RecordDeleted,'N')<>'Y'    
DECLARE @Code varchar(50)
DECLARE @AdmissionCode varchar(50)
DECLARE @DrugnoneId varchar(50)   
Select @Code = code from GlobalCodes where GlobalCodeId = (Select TobaccoUse  from  CustomDocumentSUAdmissions where  DocumentVersionId=@DocumentVersionId)  
Select @AdmissionCode = code from GlobalCodes where GlobalCodeId = (Select AdmittedPopulation  from  CustomDocumentSUAdmissions where  DocumentVersionId=@DocumentVersionId)  
select @DrugnoneId = GlobalCodeId  from globalcodes where Category = 'xSUdrugname' and CodeName = 'None'     

--FOR ICD10Code --

		DECLARE @EffectiveDate VARCHAR(30);
		DECLARE @LatestICD10DocumentVersionID INT
		DECLARE @LatestICD9DocumentVersionID INT
		DECLARE @ClientId INT
		DECLARE @ICD10Code VARCHAR(30)
		DECLARE @RecodeCategoryId int
		DECLARE @ICD10CodeCount int 		
		
		SELECT @ClientId = ClientId from Documents where CurrentDocumentVersionId = @DocumentVersionId

		SELECT TOP 1 @LatestICD10DocumentVersionID = CurrentDocumentVersionId
			,@EffectiveDate = CONVERT(VARCHAR(10), a.EffectiveDate, 101)
		FROM Documents a
		INNER JOIN DocumentCodes Dc ON Dc.DocumentCodeid = a.DocumentCodeid
		WHERE a.ClientId = @ClientID
			AND a.EffectiveDate <= convert(DATETIME, convert(VARCHAR, getDate(), 101))
			AND a.STATUS = 22
			AND Dc.DiagnosisDocument = 'Y'
			AND isNull(a.RecordDeleted, 'N') <> 'Y'
			AND isNull(Dc.RecordDeleted, 'N') <> 'Y'
		ORDER BY a.EffectiveDate DESC
			,a.ModifiedDate DESC
			
			IF @LatestICD10DocumentVersionID IS NOT NULL
		BEGIN
			SELECT @ICD10Code = D.ICD10Code 	FROM DocumentDiagnosisCodes AS D               
				INNER JOIN DiagnosisICD10Codes ICD10 ON ICD10.ICD10CodeId = D.ICD10CodeId
			WHERE (D.DocumentVersionId = @LatestICD10DocumentVersionID)
				AND (ISNULL(D.RecordDeleted, 'N') = 'N')
		END
							
		SELECT  @RecodeCategoryId = RecodeCategoryId from RecodeCategories where CategoryCode = 'XAANDDDX'	
		--SELECT CharacterCodeId from Recodes	Where RecodeCategoryId = @RecodeCategoryId	
		SELECT @ICD10CodeCount = Count(*) from Recodes WHERE RecodeCategoryId = @RecodeCategoryId	 AND CharacterCodeId = @ICD10Code
		
		
-- END --
                
DECLARE @validationReturnTable TABLE        
(          
	TableName varchar(200),              
	ColumnName varchar(200),      
	ErrorMessage varchar(1000),
	PageIndex       int,        
	TabOrder int,        
	ValidationOrder int          
)           
 
Insert into @validationReturnTable        
(          
	TableName,              
	ColumnName,              
	ErrorMessage,
	ValidationOrder             
)              
--This validation returns three fields              
--Field1 = TableName              
--Field2 = ColumnName              
--Field3 = ErrorMessage                         
              
Select 'CustomDocumentSUAdmissions', 'ProgramId', 'General - Admission Information - Program is required' , 1        
FROM @CustomDocumentSUAdmissions  
WHERE IsNULL (ProgramId,0) <= 0        
--WHERE ProgramId is NULL

       
        
Union          
Select 'CustomDocumentSUAdmissions', 'AssessmentDate', 'General - Admission Information - Assessment Date is required' ,2             
FROM @CustomDocumentSUAdmissions 
WHERE AssessmentDate is NULL   
--WHERE IsNULL (AssessmentDate,'') = ''     

Union          
Select 'CustomDocumentSUAdmissions', 'AdmissionType', 'General - Admission Information - Admission Type is required ',3             
FROM @CustomDocumentSUAdmissions   
WHERE IsNULL (AdmissionType,0) <= 0     
--WHERE AdmissionType is NULL  

Union
Select 'CustomDocumentSUAdmissions', 'AdmissionProgramType', 'General - Admission Information - Admission Program Type is required ',4         
FROM @CustomDocumentSUAdmissions  
WHERE IsNULL (AdmissionProgramType,0) <= 0    
--WHERE AdmissionProgramType is NULL  

Union
Select 'CustomDocumentSUAdmissions', 'ReferralSource', 'General - Admission Information - Referral Type is required',5        
FROM @CustomDocumentSUAdmissions 
WHERE IsNULL (ReferralSource,0) <= 0    
--WHERE ReferralSource is NULL  
           
Union
Select 'CustomDocumentSUAdmissions', 'SourceOfPayment', 'General - Admission Information - Expected Primary Source of Payment is required',6         
FROM @CustomDocumentSUAdmissions  
WHERE IsNULL (SourceOfPayment,0) <= 0  
--WHERE SourceOfPayment is NULL  

Union
Select 'CustomDocumentSUAdmissions', 'PregnantAdmission', 'General - Admission Information - Pregnant At Time Of Admission is required',7         
FROM @CustomDocumentSUAdmissions  
WHERE PregnantAdmission is NULL 

Union
Select 'CustomDocumentSUAdmissions', 'PriorEpisode', 'General - Admission Information - Prior Episode is required',8         
FROM @CustomDocumentSUAdmissions  
WHERE IsNULL (PriorEpisode,0) <= 0  
--WHERE PriorEpisode is NULL  

Union
Select 'CustomDocumentSUAdmissions', 'SocialSupports', 'General - Admission Information - Number of self - help groups attending  is required',9        
FROM @CustomDocumentSUAdmissions 
WHERE IsNULL (SocialSupports,0) <= 0   
--WHERE SocialSupports is NULL   
          
Union
Select 'CustomDocumentSUAdmissions', 'VeteransStatus', 'General - Admission Information - Veteran Status is required',10        
FROM @CustomDocumentSUAdmissions  
WHERE IsNULL (VeteransStatus,0) <= 0  
--WHERE VeteransStatus is NULL   

Union
Select 'CustomDocumentSUAdmissions', 'AdmittedPopulation', 'General - Admission Information - Admitted Population is required',11        
FROM @CustomDocumentSUAdmissions  
WHERE IsNULL (AdmittedPopulation,0) <= 0  
--WHERE AdmittedPopulation is NULL   

Union
Select 'CustomDocumentSUAdmissions', 'AdmittedASAM', 'General - Admission Information - Admitted ASAM is required',12        
FROM @CustomDocumentSUAdmissions  
WHERE IsNULL (AdmittedASAM,0) <= 0  
--WHERE AdmittedASAM is NULL 

Union
Select 'CustomDocumentSUAdmissions', 'NumberOfArrests', 'General - Legal Information - Number of Arrests In Past 30 Days is required',15        
FROM @CustomDocumentSUAdmissions  
WHERE IsNULL (NumberOfArrests,-1) < 0    --OR IsNULL (NumberOfArrests,'') = '' 

Union
Select 'CustomDocumentSUAdmissions', 'NumberOfArrestsLast12Months', 'General-Legal Information- Number of Arrests In last 12 months is required',16        
FROM @CustomDocumentSUAdmissions  
WHERE IsNULL (NumberOfArrestsLast12Months,-1) < 0 --OR IsNULL (NumberOfArrestsLast12Months,'') = '' 
--WHERE NumberOfArrests is NULL   

Union
Select 'CustomDocumentSUAdmissions', 'DrugCourtParticipation', 'General - Legal Information - Drug Court Participation is required',17        
FROM @CustomDocumentSUAdmissions  
WHERE IsNULL (DrugCourtParticipation,0) <= 0 

--Union
--Select 'CustomDocumentSUAdmissions', 'DoraStatus', 'General-Legal Information-DORA Status is required',17        
--FROM @CustomDocumentSUAdmissions  
--WHERE IsNULL (DoraStatus,0) <= 0  
--WHERE DoraStatus is NULL

Union
Select 'CustomDocumentSUAdmissions', 'CurrentlyOnProbation', 'General - Legal Information - Currently  On Probation is required',18        
FROM @CustomDocumentSUAdmissions  
WHERE IsNULL (CurrentlyOnProbation,'') = ''  
--WHERE CurrentlyOnProbation is NULL


          
Union
Select 'CustomDocumentSUAdmissions', 'Jurisdiction', 'General - Legal Information - Currently Under DCFS or DJJS Jurisdiction is required',19        
FROM @CustomDocumentSUAdmissions 
WHERE IsNULL (Jurisdiction,'') = ''  
--WHERE Jurisdiction is NULL

Union
Select 'CustomDocumentSUAdmissions', 'CurrentlyOnParole', 'General - Legal Information - Currently On Parole  is required',20       
FROM @CustomDocumentSUAdmissions 
WHERE IsNULL (CurrentlyOnParole,'') = ''  
--WHERE CurrentlyOnParole is NULL
   
Union
Select 'CustomDocumentSUAdmissions', 'LivingArrangement', 'General - Household Information - Household Composition is required',21        
FROM @CustomDocumentSUAdmissions  
WHERE IsNULL (LivingArrangement,0) <= 0 
--WHERE LivingArrangement is NULL
     
Union
Select 'CustomDocumentSUAdmissions', 'Household', 'General - Household Information - # in Household is required ',22        
FROM @CustomDocumentSUAdmissions  
WHERE IsNULL (Household,'') = ''  
--WHERE Household is NULL

Union
Select 'CustomDocumentSUAdmissions', 'HouseholdIncome', 'General - Household Information - Household Income is required',23        
FROM @CustomDocumentSUAdmissions  
WHERE IsNULL (HouseholdIncome,'') = ''
--WHERE HouseholdIncome is NULL
      
Union
Select 'CustomDocumentSUAdmissions', 'Children', 'General - Household Information - # of Children is required',24        
FROM @CustomDocumentSUAdmissions 
WHERE IsNULL (Children,'') = '' 
--WHERE Children is NULL
      
Union
Select 'CustomDocumentSUAdmissions', 'MaritalStatus', 'General - Demographic Information Update - Marital Status is required',25        
FROM @CustomDocumentSUAdmissions  
WHERE IsNULL (MaritalStatus,0) <= 0 
--WHERE MaritalStatus is NULL

Union
Select 'CustomDocumentSUAdmissions', 'EmploymentStatus', 'General-Demographic Information Update-Employment Status is required',26        
FROM @CustomDocumentSUAdmissions 
WHERE IsNULL (EmploymentStatus,0) <= 0  
--WHERE EmploymentStatus is NULL


Union
Select 'CustomDocumentSUAdmissions', 'PrimarySourceOfIncome', 'General - Demographic Information Update - Primary Source of Income  is required',27        
FROM @CustomDocumentSUAdmissions  
WHERE IsNULL (PrimarySourceOfIncome,0) <= 0 
--WHERE PrimarySourceOfIncome is NULL

Union
Select 'CustomDocumentSUAdmissions', 'EnrolledEducation', 'General-Demographic Information Update - Education Status is required',28        
FROM @CustomDocumentSUAdmissions 
WHERE IsNULL (EnrolledEducation,0) <= 0  
--WHERE EnrolledEducation is NULL

Union
Select 'CustomDocumentSUAdmissions', 'Gender', 'General - Demographic Information Update - Gender is required',29        
FROM @CustomDocumentSUAdmissions  
WHERE IsNULL (Gender,0) <= 0  
--WHERE Gender is NULL

Union
Select 'CustomDocumentSUAdmissions', 'Race', 'General - Demographic Information Update - Race is Required',30        
FROM @CustomDocumentSUAdmissions 
WHERE IsNULL (Race,0) <= 0  
--WHERE Race is NULL

Union
Select 'CustomDocumentSUAdmissions', 'Ethnicity', 'General - Demographic Information Update - Ethnicity is required',31        
FROM @CustomDocumentSUAdmissions  
WHERE IsNULL (Ethnicity,0) <= 0 
--WHERE Ethnicity is NULL


Union
Select 'CustomDocumentSUAdmissions', 'CoDependent', 'Substance Use - Substance Use Hx - Co-Dependant/Collateral is required',32        
FROM @CustomDocumentSUAdmissions  
WHERE CoDependent is NULL

Union
Select 'CustomDocumentSUAdmissions', 'CoOccurringMentalHealth', 'Substance Use-Substance Use Hx- Co-Occurring for Mental Health is required',33        
FROM @CustomDocumentSUAdmissions  
WHERE CoOccurringMentalHealth is NULL

Union
Select 'CustomDocumentSUAdmissions', 'PharmocotherapyPlanned', 'Substance Use-Substance Use Hx- Co- Pharmocotherapy Planned is required',34        
FROM @CustomDocumentSUAdmissions  
WHERE PharmocotherapyPlanned is NULL


Union
Select 'CustomDocumentSUAdmissions', 'TobaccoUse', 'Substance Use-Substance Use Hx - Tobacco Use is required',35        
FROM @CustomDocumentSUAdmissions 
WHERE IsNULL (TobaccoUse,0) <= 0 OR IsNULL (TobaccoUse,'') = '' 
--WHERE TobaccoUse is NULL

Union
Select 'CustomDocumentSUAdmissions', 'AgeOfFirstTobaccoText', 'Substance Use - Substance Use Hx - Age of First Tobacco Use if ever Used Tobacco is required',36        
FROM @CustomDocumentSUAdmissions  
WHERE AgeOfFirstTobaccoText is NULL AND @Code IN ('2','3','4','6') AND ISNULL(AgeOfFirstTobacco,'') <> 'U'  




Union
Select 'CustomDocumentSUAdmissions', 'DrugName1', 'Substance Use - Substance Use - At least 1 drug is required',37      
FROM @CustomDocumentSUAdmissions  
WHERE ISNULL(DrugName1,'') = '' AND ISNULL(DrugName2,'') = ''  AND ISNULL(DrugName3,'') = '' 
AND @AdmissionCode IN('1','2','5','6','99','19','22') 
--AND  ISNULL(AgeOfFirstUse1,'') <> ''
--AND  ISNULL(AgeOfFirstUse2,'') <> ''
--AND  ISNULL(AgeOfFirstUse3,'') <> ''



Union
Select 'CustomDocumentSUAdmissions', 'PreferredUsage1', 'Substance Use - Substance Use - Preferred Usage is required ',38       
FROM @CustomDocumentSUAdmissions  
WHERE PreferredUsage1 is NULL AND ISNULL(DrugName1,@DrugnoneId) <> @DrugnoneId

--Union
--Select 'CustomDocumentSUAdmissions', 'DrugName1', 'Substance Use-Substance Use- Detailed Drug Use  is required',36       
--FROM @CustomDocumentSUAdmissions  
--WHERE ISNULL(DrugName1,'')=''

Union
Select 'CustomDocumentSUAdmissions', 'Frequency1', 'Substance Use-Substance Use - Frequency is required; Not Applicable is only allowed when Detailed Drug Use is None',39       
FROM @CustomDocumentSUAdmissions  
WHERE Frequency1 is NULL AND ISNULL(DrugName1,@DrugnoneId) <> @DrugnoneId

Union
Select 'CustomDocumentSUAdmissions', 'Route1', 'Substance Use-Substance Use - Method is required; Not Applicable is only allowed when Detailed Drug Use is None',40       
FROM @CustomDocumentSUAdmissions  
WHERE Route1 is NULL AND ISNULL(DrugName1,@DrugnoneId) <> @DrugnoneId 

Union
Select 'CustomDocumentSUAdmissions', 'AgeOfFirstUseText1', 'Substance Use - Substance Use - Age of First Use is required',41      
FROM @CustomDocumentSUAdmissions  
--Rev#1 Removed--WHERE AgeOfFirstUseText1 is NULL AND ISNULL(DrugName1,@DrugnoneId) <> @DrugnoneId 
/*Rev#1 Added*/WHERE AgeOfFirstUseText1 is NULL AND AgeOfFirstUse1 Not In('U','N') 







Union
Select 'CustomDocumentSUAdmissions', 'PreferredUsage2', 'Substance Use-Substance Use-Preferred Usage is required ',42       
FROM @CustomDocumentSUAdmissions  
WHERE PreferredUsage2 is NULL AND ISNULL(DrugName2,@DrugnoneId) <> @DrugnoneId

--Union
--Select 'CustomDocumentSUAdmissions', 'DrugName2', 'Substance Use-Substance Use- Detailed Drug Use  is required',41       
--FROM @CustomDocumentSUAdmissions  
--WHERE ISNULL(DrugName2,'')=''

Union
Select 'CustomDocumentSUAdmissions', 'Frequency2', 'Substance Use-Substance Use-Frequency is required; Not Applicable is only allowed when Detailed Drug Use is None',43       
FROM @CustomDocumentSUAdmissions  
WHERE Frequency2 is NULL AND ISNULL(DrugName2,@DrugnoneId) <> @DrugnoneId

Union
Select 'CustomDocumentSUAdmissions', 'Route2', 'Substance Use-Substance Use-Method is required; Not Applicable is only allowed when Detailed Drug Use is None',44       
FROM @CustomDocumentSUAdmissions  
WHERE Route2 is NULL AND ISNULL(DrugName2,@DrugnoneId) <> @DrugnoneId 

Union
Select 'CustomDocumentSUAdmissions', 'AgeOfFirstUseText2', 'Substance Use-Substance Use-Age of First Use is required',45     
FROM @CustomDocumentSUAdmissions  
--Rev#1 Removed--WHERE AgeOfFirstUseText2 is NULL AND ISNULL(DrugName2,@DrugnoneId) <> @DrugnoneId 
/*Rev#1 Added*/WHERE AgeOfFirstUseText2 is NULL AND AgeOfFirstUse2 Not In('U','N')






Union
Select 'CustomDocumentSUAdmissions', 'PreferredUsage3', 'Substance Use-Substance Use-Preferred Usage is required ',46       
FROM @CustomDocumentSUAdmissions  
WHERE PreferredUsage3 is NULL AND ISNULL(DrugName3,@DrugnoneId) <> @DrugnoneId

--Union
--Select 'CustomDocumentSUAdmissions', 'DrugName3', 'Substance Use-Substance Use- Detailed Drug Use  is required',45       
--FROM @CustomDocumentSUAdmissions  
--WHERE ISNULL(DrugName3,'')<> ''

Union
Select 'CustomDocumentSUAdmissions', 'Frequency3', 'Substance Use-Substance Use-Frequency is required; Not Applicable is only allowed when Detailed Drug Use is None',47       
FROM @CustomDocumentSUAdmissions  
WHERE Frequency3 is NULL AND ISNULL(DrugName3,@DrugnoneId) <> @DrugnoneId

Union
Select 'CustomDocumentSUAdmissions', 'Route3', 'Substance Use-Substance Use-Method is required; Not Applicable is only allowed when Detailed Drug Use is None',48       
FROM @CustomDocumentSUAdmissions  
WHERE Route3 is NULL AND ISNULL(DrugName3,@DrugnoneId) <> @DrugnoneId 

Union
Select 'CustomDocumentSUAdmissions', 'AgeOfFirstUseText3', 'Substance Use-Substance Use-Age of First Use is required',49     
FROM @CustomDocumentSUAdmissions  
--Rev#1 Removed--WHERE AgeOfFirstUseText3 is NULL AND ISNULL(DrugName3,@DrugnoneId) <> @DrugnoneId 
/*Rev#1 Added*/WHERE AgeOfFirstUseText3 is NULL AND AgeOfFirstUse3 Not In('U','N')


--Union
--Select 'CustomDocumentSUAdmissions', 'AgeOfFirstUseText3', 'Diagnosis -A&D Dx is required',50     
--FROM @CustomDocumentSUAdmissions  
--WHERE @ICD10CodeCount = 0 AND @AdmissionCode NOT IN('4','7','20','21','24') 

Union
Select 'CustomDocumentInfectiousDiseaseRiskAssessments', 'AnyHealthCareProvider', 'Infectious Disease - General -  Have you seen a doctor or other health care is required',51     
FROM @CustomDocumentInfectiousDiseaseRiskAssessments  
WHERE  ISNULL(AnyHealthCareProvider,'') = ''

Union
Select 'CustomDocumentInfectiousDiseaseRiskAssessments', 'LivedStreetOrShelter', 'Infectious Disease - General - Do you live or have you lived on the street or in a shelter is required',52     
FROM @CustomDocumentInfectiousDiseaseRiskAssessments  
WHERE  ISNULL(LivedStreetOrShelter,'') = ''

Union
Select 'CustomDocumentInfectiousDiseaseRiskAssessments', 'EverBeenJailPrisonJuvenile', 'Infectious Disease  - General - Have you ever been in jail/prison/juvenile detention is required',53     
FROM @CustomDocumentInfectiousDiseaseRiskAssessments  
WHERE ISNULL(EverBeenJailPrisonJuvenile,'') = ''

Union
Select 'CustomDocumentInfectiousDiseaseRiskAssessments', 'EverBeenCareFacility', 'Infectious Disease - General - Have you ever been in a long-term care facility is required',54     
FROM @CustomDocumentInfectiousDiseaseRiskAssessments  
WHERE ISNULL(EverBeenCareFacility,'') = ''

Union
Select 'CustomDocumentInfectiousDiseaseRiskAssessments', 'WhereBorn', 'Infectious Disease - General - Where were you born is required',55     
FROM @CustomDocumentInfectiousDiseaseRiskAssessments  
WHERE ISNULL(WhereBorn,'') = ''

Union
Select 'CustomDocumentInfectiousDiseaseRiskAssessments', 'TraveledOrLivedOutsideUS', 'Infectious Disease - General - In the past 3 years have you traveled/lived outside the U.S. is required',56     
FROM @CustomDocumentInfectiousDiseaseRiskAssessments  
WHERE ISNULL(TraveledOrLivedOutsideUS,'') = ''

Union
Select 'CustomDocumentInfectiousDiseaseRiskAssessments', 'HowLongBeenInUS', 'Infectious Disease – General – How long have you been in the U.S. is required',57     
FROM @CustomDocumentInfectiousDiseaseRiskAssessments  
WHERE  ISNULL(HowLongBeenInUS,'') = ''

Union
Select 'CustomDocumentInfectiousDiseaseRiskAssessments', 'CombatVeteran', 'Infectious Disease – General – Are you a combat veteran is required',58     
FROM @CustomDocumentInfectiousDiseaseRiskAssessments  
WHERE ISNULL(CombatVeteran,'') = ''

Union
Select 'CustomDocumentInfectiousDiseaseRiskAssessments', 'HadTatooEarPiercingAcupunture', 'Infectious Disease – General – In the past 12months have you had a tattoo is required',59     
FROM @CustomDocumentInfectiousDiseaseRiskAssessments  
WHERE ISNULL(HadTatooEarPiercingAcupunture,'') = ''

Union
Select 'CustomDocumentInfectiousDiseaseRiskAssessments', 'HadTatooEarPiercingAcupunture', 'Infectious Disease – Symptoms – Within the last 30 days, have you had is required',60     
FROM @CustomDocumentInfectiousDiseaseRiskAssessments  
WHERE ISNULL(Nausea,'') = '' AND ISNULL(Fever,'') = '' AND ISNULL(DrenchingNightSweats,'') = '' AND ISNULL(DiarrheaLastingMoreThanWeek,'') = '' AND ISNULL(CoughingUpBlood,'') = '' AND ISNULL(ShortnessOfBreath,'') = '' 
		AND ISNULL(LumpsSwollenGlands,'') = ''  AND ISNULL(ProductiveCough,'') = '' AND ISNULL(LosingWeightWithoutMeaning,'') = '' AND ISNULL(BrownTingedUrine,'') = ''  AND ISNULL(ExtremeFatigue,'') = '' 
		AND ISNULL(Jaundice,'') = '' AND ISNULL(NoSymptoms,'') = ''
		
Union
Select 'CustomDocumentInfectiousDiseaseRiskAssessments', 'MissedLastTwoPeriods', 'Infectious Disease – Symptoms – Women: Have you missed your last two periods is required',61     
FROM @CustomDocumentInfectiousDiseaseRiskAssessments  
WHERE ISNULL(MissedLastTwoPeriods,'') = ''

Union
Select 'CustomDocumentInfectiousDiseaseRiskAssessments', 'EverBeenToldYouHaveTB', 'Infectious Disease – TB Questions – Have you ever been told you have TB is required',62     
FROM @CustomDocumentInfectiousDiseaseRiskAssessments  
WHERE ISNULL(EverBeenToldYouHaveTB,'') = ''	

Union
Select 'CustomDocumentInfectiousDiseaseRiskAssessments', 'EverBeenHadPositiveSkinTestTB', 'Infectious Disease – TB Questions – Have you ever had a positive skin test for TB is required',63     
FROM @CustomDocumentInfectiousDiseaseRiskAssessments  
WHERE ISNULL(EverBeenHadPositiveSkinTestTB,'') = ''

Union
Select 'CustomDocumentInfectiousDiseaseRiskAssessments', 'EverBeenTreatedForTB', 'Infectious Disease – TB Questions – Have you ever been treated for TB is required',64     
FROM @CustomDocumentInfectiousDiseaseRiskAssessments  
WHERE ISNULL(EverBeenTreatedForTB,'') = ''

Union
Select 'CustomDocumentInfectiousDiseaseRiskAssessments', 'EverBeenToldYouHaveHepatitisA', 'Infectious Disease – Hepatitis – Have you ever been told you have Hepatitis A is required',65     
FROM @CustomDocumentInfectiousDiseaseRiskAssessments  
WHERE ISNULL(EverBeenToldYouHaveHepatitisA,'') = ''

Union
Select 'CustomDocumentInfectiousDiseaseRiskAssessments', 'EverBeenToldYouHaveHepatitisB', 'Infectious Disease – Hepatitis – Have you ever been told you have Hepatitis B is required',66     
FROM @CustomDocumentInfectiousDiseaseRiskAssessments  
WHERE ISNULL(EverBeenToldYouHaveHepatitisB,'') = ''

Union
Select 'CustomDocumentInfectiousDiseaseRiskAssessments', 'EverBeenToldYouHaveHepatitisC', 'Infectious Disease – Hepatitis – Have you ever been told you have Hepatitis C is required',67     
FROM @CustomDocumentInfectiousDiseaseRiskAssessments  
WHERE  ISNULL(EverBeenToldYouHaveHepatitisC,'') = ''

Union
Select 'CustomDocumentInfectiousDiseaseRiskAssessments', 'EverUsedNeedlesToShootDrugs', 'Infectious Disease – Drug/Sexual Related Questions – Have you ever used needles to shoot drugs is required',68     
FROM @CustomDocumentInfectiousDiseaseRiskAssessments  
WHERE  ISNULL(EverUsedNeedlesToShootDrugs,'') = ''

Union
Select 'CustomDocumentInfectiousDiseaseRiskAssessments', 'EverSharedNeedlesSyringesToInjectDrugs', 'Infectious Disease – Drug/Sexual Related Questions – Have you ever shared needles or syringes (“rigs”) to inject drugs is required',69     
FROM @CustomDocumentInfectiousDiseaseRiskAssessments  
WHERE  ISNULL(EverSharedNeedlesSyringesToInjectDrugs,'') = ''

Union
Select 'CustomDocumentInfectiousDiseaseRiskAssessments', 'EverHadNeedleStickInjuriesOrBloodContact', 'Infectious Disease – Drug/Sexual Related Questions – Have you ever had a job that put you in danger of needle stick injuries is required',70     
FROM @CustomDocumentInfectiousDiseaseRiskAssessments  
WHERE  ISNULL(EverHadNeedleStickInjuriesOrBloodContact,'') = ''

Union
Select 'CustomDocumentInfectiousDiseaseRiskAssessments', 'UseStimulants', 'Infectious Disease – Drug/Sexual Related Questions – Do you use stimulants is required',71     
FROM @CustomDocumentInfectiousDiseaseRiskAssessments  
WHERE  ISNULL(UseStimulants,'') = ''

Union
Select 'CustomDocumentInfectiousDiseaseRiskAssessments', 'PastTwelveMonthsHadSexWithAnyWithHepatitis', 'Infectious Disease – Drug/Sexual Related Questions – In the past 12 months, have you, or anyone ',72     
FROM @CustomDocumentInfectiousDiseaseRiskAssessments  
WHERE  ISNULL(PastTwelveMonthsHadSexWithAnyWithHepatitis,'') = ''

Union
Select 'CustomDocumentInfectiousDiseaseRiskAssessments', 'ReceiveBloodTransfusionBefore1992', 'Infectious Disease – Additional Questions – Did you receive a blood transfusion before 1992 is required',73     
FROM @CustomDocumentInfectiousDiseaseRiskAssessments  
WHERE  ISNULL(ReceiveBloodTransfusionBefore1992,'') = ''

Union
Select 'CustomDocumentInfectiousDiseaseRiskAssessments', 'ReceivedBloodProductsBefore1987', 'Infectious Disease – Additional Questions – Have you received blood products produced before 1987 for clotting problems is required',74     
FROM @CustomDocumentInfectiousDiseaseRiskAssessments  
WHERE  ISNULL(ReceivedBloodProductsBefore1987,'') = ''

Union
Select 'CustomDocumentInfectiousDiseaseRiskAssessments', 'BirthMotherInfectedWithHepatitisC', 'Infectious Disease – Additional Questions – Was your birth mother infected with Hepatitis C virus is required',75     
FROM @CustomDocumentInfectiousDiseaseRiskAssessments  
WHERE ISNULL(BirthMotherInfectedWithHepatitisC,'') = ''

Union
Select 'CustomDocumentInfectiousDiseaseRiskAssessments', 'EverBeenLongTermKidneyDialysis', 'Infectious Disease – Additional Questions – Have you been, or are your currently, on long-term kidney is required',76     
FROM @CustomDocumentInfectiousDiseaseRiskAssessments  
WHERE ISNULL(EverBeenLongTermKidneyDialysis,'') = ''

Union
Select 'CustomDocumentInfectiousDiseaseRiskAssessments', 'UnprotectedSexWithHemophiliaPatient', 'Infectious Disease – Additional Questions – Have you had unprotected sex with someone who has the blood disease hemophilia is required',77     
FROM @CustomDocumentInfectiousDiseaseRiskAssessments  
WHERE  ISNULL(UnprotectedSexWithHemophiliaPatient,'') = ''


Union
Select 'CustomDocumentInfectiousDiseaseRiskAssessments', 'UnprotectedSexWithManWithOtherMen', 'Infectious Disease – Additional Questions – Have you had unprotected sex with a man who has sex with other men is required',78     
FROM @CustomDocumentInfectiousDiseaseRiskAssessments  
WHERE ISNULL(UnprotectedSexWithManWithOtherMen,'') = ''

Union
Select 'CustomDocumentInfectiousDiseaseRiskAssessments', 'HadSexExchangeMoneyOrDrugs', 'Infectious Disease – Additional Questions – Have you had sex in exchange for money or drugs, or in order to survive is required',79     
FROM @CustomDocumentInfectiousDiseaseRiskAssessments  
WHERE ISNULL(HadSexExchangeMoneyOrDrugs,'') = ''

Union
Select 'CustomDocumentInfectiousDiseaseRiskAssessments', 'HadSexMoreThanOnePersonPastSixMonths', 'Infectious Disease – Additional Questions – Have you had sex with more than one person in the past 6 months is required',80     
FROM @CustomDocumentInfectiousDiseaseRiskAssessments  
WHERE ISNULL(HadSexMoreThanOnePersonPastSixMonths,'') = ''

Union
Select 'CustomDocumentInfectiousDiseaseRiskAssessments', 'HadSexWithAIDSPersonOrHepatitisC', 'Infectious Disease – Additional Questions – Have you had sex or shared needles to inject drugs with a person who has AIDS is required',81     
FROM @CustomDocumentInfectiousDiseaseRiskAssessments  
WHERE ISNULL(HadSexWithAIDSPersonOrHepatitisC,'') = ''

Union
Select 'CustomDocumentInfectiousDiseaseRiskAssessments', 'EverInjectedDrugsEvenOnce', 'Infectious Disease – Additional Questions – Have you ever injected drugs, even once is required',82     
FROM @CustomDocumentInfectiousDiseaseRiskAssessments  
WHERE ISNULL(EverInjectedDrugsEvenOnce,'') = ''

Union
Select 'CustomDocumentInfectiousDiseaseRiskAssessments', 'EvenBeenPrickedByNeedle', 'Infectious Disease – Additional Questions – Have you ever been pricked by a needle or syringe that may have been infected with HIV or Hepatitis C virus is required',83     
FROM @CustomDocumentInfectiousDiseaseRiskAssessments  
WHERE  ISNULL(EvenBeenPrickedByNeedle,'') = ''

Union
Select 'CustomDocumentInfectiousDiseaseRiskAssessments', 'EverHadDrinkingProblemCounselling', 'Infectious Disease – Additional Questions – Have you ever had a drinking problem that required medical care or counseling is required',84    
FROM @CustomDocumentInfectiousDiseaseRiskAssessments  
WHERE ISNULL(EverHadDrinkingProblemCounselling,'') = ''

Union
Select 'CustomDocumentInfectiousDiseaseRiskAssessments', 'EverBeenToldDrinkingProblem', 'Infectious Disease – Additional Questions – Have you ever been told or thought that you have a drinking problem is required',85    
FROM @CustomDocumentInfectiousDiseaseRiskAssessments  
WHERE ISNULL(EverBeenToldDrinkingProblem,'') = ''
 
Union
Select 'CustomDocumentInfectiousDiseaseRiskAssessments', 'EverHadBloodTestForHIVAntibody', 'Infectious Disease – Blood Test - Have you ever had a blood test for the HIV antibody is required',86   
FROM @CustomDocumentInfectiousDiseaseRiskAssessments  
WHERE ISNULL(EverHadBloodTestForHIVAntibody,'') = ''

Union
Select 'CustomDocumentInfectiousDiseaseRiskAssessments', 'BeenTestedWithinLastSixMonthsHIV', 'Infectious Disease – Blood Test - Have you been tested within the last six months is required',87    
FROM @CustomDocumentInfectiousDiseaseRiskAssessments  
WHERE ISNULL(BeenTestedWithinLastSixMonthsHIV,'') = '' AND ISNULL(EverHadBloodTestForHIVAntibody,'') = 'Y'

Union
Select 'CustomDocumentInfectiousDiseaseRiskAssessments', 'WouldYouLikeBloodTestHIV', 'Infectious Disease – Blood Test - Would you like a blood test is required',88    
FROM @CustomDocumentInfectiousDiseaseRiskAssessments  
WHERE ISNULL(WouldYouLikeBloodTestHIV,'') = '' AND ISNULL(EverHadBloodTestForHIVAntibody,'') = 'N'

Union
Select 'CustomDocumentInfectiousDiseaseRiskAssessments', 'EverHadBloodTestForHepatitisC', 'Infectious Disease – Blood Test - Have you ever had a blood test for the Hepatitis C virus is required',89    
FROM @CustomDocumentInfectiousDiseaseRiskAssessments  
WHERE ISNULL(EverHadBloodTestForHepatitisC,'') = ''

Union
Select 'CustomDocumentInfectiousDiseaseRiskAssessments', 'BeenTestedWithinLastSixMonthsHepatitisC', 'Infectious Disease – Blood Test - Have you been tested within the last six months is required',90    
FROM @CustomDocumentInfectiousDiseaseRiskAssessments  
WHERE ISNULL(BeenTestedWithinLastSixMonthsHepatitisC,'') = '' AND  ISNULL(EverHadBloodTestForHepatitisC,'') = 'Y'

Union
Select 'CustomDocumentInfectiousDiseaseRiskAssessments', 'WouldYouLikeBloodTestHepatitisC', 'Infectious Disease – Blood Test - Would you like a blood test is required',91   
FROM @CustomDocumentInfectiousDiseaseRiskAssessments  
WHERE  ISNULL(WouldYouLikeBloodTestHepatitisC,'') = '' AND  ISNULL(EverHadBloodTestForHepatitisC,'') = 'N'

Union
Select 'CustomDocumentInfectiousDiseaseRiskAssessments', 'JudgeOwnRiskInfectedWithHIV', 'Infectious Disease – Assess - How would you judge your own risk for being infected with HIV (the AIDS virus) is required',92    
FROM @CustomDocumentInfectiousDiseaseRiskAssessments  
WHERE ISNULL(JudgeOwnRiskInfectedWithHIV,'') = ''

Union
Select 'CustomDocumentInfectiousDiseaseRiskAssessments', 'JudgeOwnRiskInfectedWithHepatitisC', 'Infectious Disease – Assess - How would you judge your own risk for being infected with Hepatitis C is required',93    
FROM @CustomDocumentInfectiousDiseaseRiskAssessments  
WHERE  ISNULL(JudgeOwnRiskInfectedWithHepatitisC,'') = ''

Union
Select 'CustomDocumentInfectiousDiseaseRiskAssessments', 'ClientAssessed', 'Infectious Disease – Assess - Was client assessed is required',94    
FROM @CustomDocumentInfectiousDiseaseRiskAssessments  
WHERE  ISNULL(ClientAssessed,'') = ''

Union
Select 'CustomDocumentInfectiousDiseaseRiskAssessments', 'ClientReferredHealthOrAgency', 'Infectious Disease – Assess - Client was referred to health department or other agency is required',95    
FROM @CustomDocumentInfectiousDiseaseRiskAssessments  
WHERE ISNULL(ClientReferredHealthOrAgency,'') = ''

Union
Select 'CustomDocumentInfectiousDiseaseRiskAssessments', 'ClientReferredWhere', 'Infectious Disease – Assess – Where client was referred is required',96    
FROM @CustomDocumentInfectiousDiseaseRiskAssessments  
WHERE  ISNULL(ClientReferredWhere,'') = '' AND ISNULL(JudgeOwnRiskInfectedWithHepatitisC,'') = 'Y'



Select TableName, ColumnName, ErrorMessage ,PageIndex,TabOrder,ValidationOrder               
from @validationReturnTable  order by  ValidationOrder asc     
        
        
          
              
end try                                                            
                                                                                            
BEGIN CATCH                
              
DECLARE @Error varchar(8000)                                                             
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                           
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'[csp_validateCustomDocumentSUAdmissions]')                                                                                           
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                            
    + '*****' + Convert(varchar,ERROR_STATE())                                  RAISERROR                                                                                           
 (                                                             
  @Error, -- Message text.                                                                                          
  16, -- Severity.                                                                                          
  1 -- State.                                                                                          
 );                                                                                       
END CATCH                                      
END             
              
              
        
              
              

GO



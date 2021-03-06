IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomDocumentSUAdmissions]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetCustomDocumentSUAdmissions]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[csp_SCGetCustomDocumentSUAdmissions] @DocumentVersionId INT
AS
/*********************************************************************/
/* Stored Procedure: [csp_SCGetcsp_SCGetCustomDocumentSUAdmissions]   */
/*       Date              Author                  Purpose                   */
/*       01/FEB/2015      SuryaBalan               To Retrieve Data           */
--23-March-2015 SuryaBalan Copied from valley to New Directions Customization Task 4
--23-March-2015 SuryaBalan Addded Colm "GenderOther"
/*********************************************************************/
BEGIN
	BEGIN TRY
	DECLARE @ClientId INT
	DECLARE @SSN Varchar(20)
	DECLARE @TitleXXNo Varchar(50)
	DECLARE @SamhisId Varchar(50)

	select @ClientId = ClientId from documents where InProgressDocumentVersionId = @DocumentVersionId
	SELECT @SSN = SUBSTRING(SSN,1,4) from clients where ClientId = @ClientID
	
	SELECT @TitleXXNo = TitleXXNo,@SamhisId = SamhisId  from CustomClients where ClientId = @ClientID
	
		SELECT DocumentVersionId,
		CreatedBy,
		CreatedDate,
		ModifiedBy,
		ModifiedDate,
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
		AgeOfFirstUse3,
		@SSN as SSN,
		@TitleXXNo as TitleXXNo,
		@SamhisId as SamhisId,
		NumberOfArrestsLast12Months,
		EducationCompleted,
		CoOccurringMentalHealth,
		Severity1,
		Severity2,
		Severity3,
		PharmocotherapyPlanned,
		GenderOther
		


		FROM CustomDocumentSUAdmissions Where DocumentVersionId = @DocumentVersionId	

        SELECT 
        DocumentVersionId
		,CreatedBy
		,CreatedDate
		,ModifiedBy
		,ModifiedDate
		,RecordDeleted
		,DeletedBy
		,DeletedDate
		,AnyHealthCareProvider
		,LivedStreetOrShelter
		,EverBeenJailPrisonJuvenile
		,EverBeenCareFacility
		,WhereBorn
		,TraveledOrLivedOutsideUS
		,HowLongBeenInUS
		,CombatVeteran
		,HadTatooEarPiercingAcupunture
		,Nausea
		,Fever
		,DrenchingNightSweats
		,ProductiveCough
		,CoughingUpBlood
		,ShortnessOfBreath
		,LumpsSwollenGlands
		,DiarrheaLastingMoreThanWeek
		,LosingWeightWithoutMeaning
		,BrownTingedUrine
		,ExtremeFatigue
		,Jaundice
		,NoSymptoms
		,MissedLastTwoPeriods
		,WomanMissedLast2Periods
		,EverBeenToldYouHaveTB
		,EverBeenHadPositiveSkinTestTB
		,EverBeenTreatedForTB
		,EverBeenToldYouHaveHepatitisA
		,EverBeenToldYouHaveHepatitisB
		,EverBeenToldYouHaveHepatitisC
		,EverUsedNeedlesToShootDrugs
		,EverSharedNeedlesSyringesToInjectDrugs
		,EverHadNeedleStickInjuriesOrBloodContact
		,UseStimulants
		,PastTwelveMonthsHadSexWithAnyWithHepatitis
		,ReceiveBloodTransfusionBefore1992
		,ReceivedBloodProductsBefore1987
		,BirthMotherInfectedWithHepatitisC
		,EverBeenLongTermKidneyDialysis
		,UnprotectedSexWithHemophiliaPatient
		,UnprotectedSexWithManWithOtherMen
		,HadSexExchangeMoneyOrDrugs
		,HadSexMoreThanOnePersonPastSixMonths
		,HadSexWithAIDSPersonOrHepatitisC
		,EverInjectedDrugsEvenOnce
		,EvenBeenPrickedByNeedle
		,EverHadDrinkingProblemCounselling
		,EverBeenToldDrinkingProblem
		,EverHadBloodTestForHIVAntibody
		,BeenTestedWithinLastSixMonthsHIV
		,WouldYouLikeBloodTestHIV
		,EverHadBloodTestForHepatitisC
		,BeenTestedWithinLastSixMonthsHepatitisC
		,WouldYouLikeBloodTestHepatitisC
		,JudgeOwnRiskInfectedWithHIV
		,JudgeOwnRiskInfectedWithHepatitisC
		,ClientAssessed
		,ClientReferredHealthOrAgency
		,ClientReferredWhere

FROM    CustomDocumentInfectiousDiseaseRiskAssessments Where DocumentVersionId = @DocumentVersionId	
		  
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_SCGetCustomDocumentSUAdmissions') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.
				16
				,-- Severity.
				1 -- State.
				);
	END CATCH
END

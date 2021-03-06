IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomDocumentSUAdmissions]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCustomDocumentSUAdmissions]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_InitCustomDocumentSUAdmissions] 
 (
	@ClientID INT
	,@StaffID INT
	,@CustomParameters XML
	)
AS
-- =============================================    
-- Author      : SuryaBalan
-- Date        : 23/FEB/2015  
-- Purpose     : Initializing SP Created.	
--Copied from valley to New Directions Customization Task 4
--26-March-2015 Added CoOccurringMentalHealth,PharmocotherapyPlanned
--26-March-2015 Initialize Referral Type and Marital Status
--26-March-2015  HouseholdIncome Change Null Value
--26-March-2015 Initialize If Marital Status is not there in Registration we have to pull it from Client Demographics
-- =============================================   
BEGIN
	BEGIN TRY
	DECLARE @LatestDocumentVersionID INT
	DECLARE @LatestASAMDocumentVersionID INT
	DECLARE @LatestRegDocumentVersionID INT
	DECLARE @ASAMReferred INT
	DECLARE @SSN Varchar(20)
	DECLARE @TitleXXNo Varchar(50)
	DECLARE @SamhisId Varchar(50)
	DECLARE @Sex Varchar(10)
	--DECLARE @MaritalStatus Varchar(100)
	DECLARE @RegMartialStatus INT
	DECLARE @ReferralType INT
	
	
	SELECT TOP 1 @LatestDocumentVersionID = CurrentDocumentVersionId
	FROM CustomDocumentSUAdmissions CDSA
	INNER JOIN Documents Doc ON CDSA.DocumentVersionId = Doc.CurrentDocumentVersionId
	WHERE Doc.ClientId = @ClientID
		AND Doc.[Status] = 22
		AND ISNULL(CDSA.RecordDeleted, 'N') = 'N'
		AND ISNULL(Doc.RecordDeleted, 'N') = 'N'
	ORDER BY Doc.EffectiveDate DESC
		,Doc.ModifiedDate DESC
	
	SET @LatestDocumentVersionID = ISNULL(@LatestDocumentVersionID, - 1)
	
	--SELECT @SSN = SUBSTRING(SSN,1,4),@Sex=Sex,@MaritalStatus=MaritalStatus from clients where ClientId = @ClientID
	SELECT @SSN = SUBSTRING(SSN,1,4),@Sex=Sex from clients where ClientId = @ClientID
	
	SELECT @TitleXXNo = TitleXXNo,@SamhisId = SamhisId  from CustomClients where ClientId = @ClientID
	
	
	
	--ASAM--
	
	--SELECT TOP 1 @LatestASAMDocumentVersionID = CurrentDocumentVersionId
	--FROM CustomDocumentASAMs CDCD
	--INNER JOIN Documents Doc ON CDCD.DocumentVersionId = Doc.CurrentDocumentVersionId
	--WHERE Doc.ClientId = @ClientID
	--	AND Doc.[Status] = 22
	--	AND ISNULL(CDCD.RecordDeleted, 'N') = 'N'
	--	AND ISNULL(Doc.RecordDeleted, 'N') = 'N'
	--ORDER BY Doc.EffectiveDate DESC
	--	,Doc.ModifiedDate DESC
	
	--SELECT top 1 @ASAMReferred = IndicatedReferredLevel from CustomDocumentASAMs where DocumentVersionId = @LatestASAMDocumentVersionID
	--END ASAM
	
	
	--REGISTRATION--
	SELECT TOP 1 @LatestRegDocumentVersionID = CurrentDocumentVersionId
	FROM CustomDocumentRegistrations CDR
	INNER JOIN Documents Doc ON CDR.DocumentVersionId = Doc.CurrentDocumentVersionId
	WHERE Doc.ClientId = @ClientID
		AND Doc.[Status] = 22
		AND ISNULL(CDR.RecordDeleted, 'N') = 'N'
		AND ISNULL(Doc.RecordDeleted, 'N') = 'N'
	ORDER BY Doc.EffectiveDate DESC
		,Doc.ModifiedDate DESC
	
	SELECT top 1 @RegMartialStatus = MaritalStatus from CustomDocumentRegistrations where DocumentVersionId = @LatestRegDocumentVersionID
	if(@RegMartialStatus is NULL)
	BEGIN
			SELECT top 1 @RegMartialStatus = MaritalStatus from Clients where ClientId = @ClientID
	END
	SELECT @ReferralType =ReferralType from ClientEpisodes where ClientId = @ClientID
	
	
	--END REGISTRATION--
	
	
	
SELECT 'CustomDocumentSUAdmissions' AS TableName
		,- 1 AS DocumentVersionId
		,'' AS CreatedBy
		,GETDATE() AS CreatedDate
		,'' AS ModifiedBy
		,GETDATE() AS ModifiedDate,
		RecordDeleted,
		DeletedBy,
		DeletedDate,
		NULL as ProgramId,
		AdmissionEntryDate, 
		--AssessmentDate,
		NULL as AdmissionType,
		AdmissionProgramType,
		
		SourceOfPayment, 
		--CASE When @Sex = 'M' THEN 'A' ELSE PregnantAdmission END as PregnantAdmission, 
		CASE When @Sex = 'M' THEN 'A' ELSE NULL END as PregnantAdmission, 
		PriorEpisode,    
		SocialSupports, 
		VeteransStatus,
		NULL as AdmittedPopulation, 
		AdmittedASAM,
		@ASAMReferred as ReferredASAM,
		--ReferredASAM,
		NULL as StateCode,
		NULL as NumberOfArrests, 
		NULL as DrugCourtParticipation, 
		--DrugCourtParticipation, 
		--NULL as DoraStatus, 
		--'' as CurrentlyOnProbation,
		--Jurisdiction, 
		--CurrentlyOnParole,  
		NULL as LivingArrangement, 
		'' as Household, 
		'' as Children,
		HouseholdIncome,
		@RegMartialStatus as MaritalStatus,
		--CASE When ISNULL(@MaritalStatus,0) = 0 THEN 0 ELSE @MaritalStatus END as MaritalStatus,		
		NULL as EmploymentStatus,    
		NULL as PrimarySourceOfIncome,  
		NULL as EnrolledEducation,
		NULL as Gender,
		NULL as Race,
		NULL as Ethnicity,
		CoDependent, 
		
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
		CoOccurringMentalHealth,
         PharmocotherapyPlanned,
         @ReferralType as ReferralSource,
         Severity1,
         Severity2,
         Severity3
         
		

	FROM systemconfigurations s
	LEFT OUTER JOIN CustomDocumentSUAdmissions  ON DocumentVersionId = @LatestDocumentVersionID
	
	SELECT 
         'CustomDocumentInfectiousDiseaseRiskAssessments' AS TableName
		,- 1 AS DocumentVersionId
		,'' AS CreatedBy
		,GETDATE() AS CreatedDate
		,'' AS ModifiedBy
		,GETDATE() AS ModifiedDate,
		RecordDeleted,
		DeletedBy,
		DeletedDate
		--,CreatedBy
		--,CreatedDate
		--,ModifiedBy
		--,ModifiedDate
		--,RecordDeleted
		--,DeletedBy
		--,DeletedDate
		--,AnyHealthCareProvider
		--,LivedStreetOrShelter
		--,EverBeenJailPrisonJuvenile
		--,EverBeenCareFacility
		--,WhereBorn
		--,TraveledOrLivedOutsideUS
		--,HowLongBeenInUS
		--,CombatVeteran
		--,HadTatooEarPiercingAcupunture
		--,Nausea
		--,Fever
		--,DrenchingNightSweats
		--,ProductiveCough
		--,CoughingUpBlood
		--,ShortnessOfBreath
		--,LumpsSwollenGlands
		--,DiarrheaLastingMoreThanWeek
		--,LosingWeightWithoutMeaning
		--,BrownTingedUrine
		--,ExtremeFatigue
		--,Jaundice
		--,NoSymptoms
		--,MissedLastTwoPeriods
		--,WomanMissedLast2Periods
		--,EverBeenToldYouHaveTB
		--,EverBeenHadPositiveSkinTestTB
		--,EverBeenTreatedForTB
		--,EverBeenToldYouHaveHepatitisA
		--,EverBeenToldYouHaveHepatitisB
		--,EverBeenToldYouHaveHepatitisC
		--,EverUsedNeedlesToShootDrugs
		--,EverSharedNeedlesSyringesToInjectDrugs
		--,EverHadNeedleStickInjuriesOrBloodContact
		--,UseStimulants
		--,PastTwelveMonthsHadSexWithAnyWithHepatitis
		--,ReceiveBloodTransfusionBefore1992
		--,ReceivedBloodProductsBefore1987
		--,BirthMotherInfectedWithHepatitisC
		--,EverBeenLongTermKidneyDialysis
		--,UnprotectedSexWithHemophiliaPatient
		--,UnprotectedSexWithManWithOtherMen
		--,HadSexExchangeMoneyOrDrugs
		--,HadSexMoreThanOnePersonPastSixMonths
		--,HadSexWithAIDSPersonOrHepatitisC
		--,EverInjectedDrugsEvenOnce
		--,EvenBeenPrickedByNeedle
		--,EverHadDrinkingProblemCounselling
		--,EverBeenToldDrinkingProblem
		--,EverHadBloodTestForHIVAntibody
		--,BeenTestedWithinLastSixMonthsHIV
		--,WouldYouLikeBloodTestHIV
		--,EverHadBloodTestForHepatitisC
		--,BeenTestedWithinLastSixMonthsHepatitisC
		--,WouldYouLikeBloodTestHepatitisC
		--,JudgeOwnRiskInfectedWithHIV
		--,JudgeOwnRiskInfectedWithHepatitisC
		--,ClientAssessed
		--,ClientReferredHealthOrAgency
		--,ClientReferredWhere
      FROM systemconfigurations s
	    --LEFT OUTER JOIN CustomDocumentSUAdmissions  ON DocumentVersionId = @LatestDocumentVersionID
        LEFT OUTER JOIN    CustomDocumentInfectiousDiseaseRiskAssessments ON DocumentVersionId = @LatestDocumentVersionID
		
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'csp_InitCustomDocumentSUAdmissions') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                                                  
				16
				,-- Severity.                                                                                                  
				1 -- State.                                                                                                  
				);
	END CATCH
END


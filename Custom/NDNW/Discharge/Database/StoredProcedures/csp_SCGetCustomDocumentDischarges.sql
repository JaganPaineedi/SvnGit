IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomDocumentDischarges]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetCustomDocumentDischarges]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[csp_SCGetCustomDocumentDischarges] @DocumentVersionId INT
AS
/*********************************************************************/
/* Stored Procedure: [csp_SCGetcsp_SCGetCustomDocumentSUAdmissions]   */
/*       Date              Author                  Purpose                   */
/*       12/FEB/2015      Anto               To Retrieve Data           
		 29/11/2018		Dasari Sunil		What:Removed code which is used check for the discharged client programs of the services.
											Why:Discharge document failing to pull forward services,Doing a discharge document, there is a section titled "summary of services provided.
											New Directions - Support Go Live #892 */
/*********************************************************************/
BEGIN
	BEGIN TRY
	
	DECLARE @SummaryOfServiceProvided VARCHAR(MAX)
	DECLARE @ProgramIDs VARCHAR(200)
	DECLARE @PresentingProblem VARCHAR(MAX)
	DECLARE @LatestAssessmentDocumentVersionID INT
	
		DECLARE @ClientId int                                                                                                                                                                                               
		SELECT @ClientId = ClientId from Documents where                                                                                                                                                                                               
		InProgressDocumentVersionId = @DocumentVersionId and IsNull(RecordDeleted,'N')= 'N'  
		
	
	SELECT @ProgramIDs = COALESCE(@ProgramIDs + ', ' + CONVERT(VARCHAR(20), ClientProgramId), CONVERT(VARCHAR(20), ClientProgramId))
		FROM ClientPrograms
		WHERE ClientId = @ClientID
			AND IsNull(RecordDeleted, 'N') = 'N'
			--AND [Status] <> 5   
	EXEC csp_SCGetSummaryServicesProvided @ClientId =@ClientId,@ProgramIdCSV=@ProgramIDs,@SummaryOfService=@SummaryOfServiceProvided OUTPUT        	

	
	--Assessment PresentingProblem--
	
	SELECT TOP 1 @LatestAssessmentDocumentVersionID = CurrentDocumentVersionId
	FROM CustomHRMAssessments CDCD
	INNER JOIN Documents Doc ON CDCD.DocumentVersionId = Doc.CurrentDocumentVersionId
	WHERE Doc.ClientId = @ClientID
		AND Doc.[Status] = 22
		AND ISNULL(CDCD.RecordDeleted, 'N') = 'N'
		AND ISNULL(Doc.RecordDeleted, 'N') = 'N'
	ORDER BY Doc.EffectiveDate DESC
		,Doc.ModifiedDate DESC
		
	SET @LatestAssessmentDocumentVersionID = ISNULL(@LatestAssessmentDocumentVersionID, - 1)
	
	
	SELECT top 1 @PresentingProblem = PresentingProblem from CustomHRMAssessments where DocumentVersionId = @LatestAssessmentDocumentVersionID
	--END PresentingProblem
		
	
		SELECT DocumentVersionId,
		CreatedBy,
		CreatedDate,
		ModifiedBy,
		ModifiedDate,
		RecordDeleted,
		DeletedBy,
		DeletedDate,
		NewPrimaryClientProgramId,
		DischargeType,
		TransitionDischarge,
		DischargeDetails,
		OverallProgress, 
		StatusLastContact,
		EducationLevel,
		MaritalStatus,
		EducationStatus,
		EmploymentStatus,
		ForensicCourtOrdered, 
		CurrentlyServingMilitary,
		Legal,
		JusticeSystem,
		LivingArrangement, 
		Arrests,
		AdvanceDirective,
		TobaccoUse,
		AgeOfFirstTobaccoUse,
		CountyResidence,
		CountyFinancialResponsibility,
		NoReferral, 
		SymptomsReoccur, 
		ReferredTo, 
		Reason,
		DatesTimes,
		ReferralDischarge,
		Treatmentcompletion,
		--@SummaryOfServiceProvided AS 'SummaryOfServicesProvided'
		ISNULL(@SummaryOfServiceProvided, '') AS 'SummaryOfServicesProvided'
		,ISNULL(@PresentingProblem, 'No formal assessment') AS 'PresentingProblems'
		,CoOccurringHealthProblem 
		,ClientType
		,HealthInsurance
		,VocationalRehab
		,SchoolAttendance
		,StableHousing
		,NumberOfMonthsEmployed
		,NumberOfEmployers
		,ArrestsInLast12Months
		,IncarceratedInLast12Months
		,GrossAnnualHouseholdIncome
		FROM CustomDocumentDischarges Where DocumentVersionId = @DocumentVersionId			  
		
		
		SELECT CP.ClientProgramId      
		  ,CP.ClientId      
		  ,CP.ProgramId      
		  ,CP.Status      
		  ,CP.RequestedDate      
		  ,CP.EnrolledDate      
		  ,CP.DischargedDate      
		  ,CP.PrimaryAssignment      
		  ,CP.Comment      
		  ,AssignedStaffId 
		  ,CP.CreatedBy      
		  ,CP.CreatedDate		
		  ,CP.ModifiedBy      
		  ,CP.ModifiedDate      
		  ,CP.RecordDeleted      
		  ,CP.DeletedDate      
		  ,CP.DeletedBy 
		  ,@DocumentVersionId AS 'CurrentDocumentVersionId' 
		  ,PriorityPopulation
		  ,PriorityNumber
		  ,Emergent
		  ,MustBeEnrolledByDate
		  ,Prerequisite
		  ,WaitlistPriorityComment       
	  FROM ClientPrograms CP     
	  INNER JOIN Programs Prog ON CP.ProgramId=Prog.ProgramId   
	  WHERE CP.ClientId =@ClientId  AND IsNull(Prog.RecordDeleted,'N')='N' AND  ISNULL(CP.RecordDeleted,'N')='N' AND CP.[Status] IN(4,1) /*Program Status 'Reguested','Enrolled' */ --CP.Status<>5       
	  --AND Prog.ProgramType=(SELECT GlobalCodeId FROM globalcodes WHERE  Code='TEAM' and category='PROGRAMTYPE')  
	  
	SELECT DischargeProgramId
		,CreatedBy
		,CreatedDate
		,ModifiedBy
		,ModifiedDate
		,RecordDeleted
		,DeletedDate
		,DeletedBy
		,DocumentVersionId
		,ClientProgramId
	FROM CustomDischargePrograms
	WHERE DocumentVersionId = @DocumentVersionId
		
SELECT
		CR.DischargeReferralId,
		CR.CreatedBy,
		CR.CreatedDate,
		CR.ModifiedBy,
		CR.ModifiedDate,
		CR.RecordDeleted,
		CR.DeletedBy,
		CR.DeletedDate,
		CR.DocumentVersionId,
		CR.Referral,
		CR.Program,
		GC.CodeName as ReferralText,
		cp.ProgramName ProgramText
	FROM CustomDischargeReferrals CR 
	  left join GlobalCodes GC 
	  ON CR.Referral = GC.GlobalCodeId  left join GlobalSubCodes GSC ON CR.Program = GSC.GlobalSubCodeId
	  left join Programs cp on cp.ProgramId = CR.Program   
	WHERE CR.DocumentVersionId = @DocumentVersionId
		
		
			
		--select cp.ProgramId,pr.ProgramName from Programs pr inner join ClientPrograms cp  on cp.ProgramId = pr.ProgramId where CP.ClientId =2
		
		--AND IsNull(CP.RecordDeleted, 'N') = 'N'  AND CP.[Status] IN (4)
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_SCGetCustomDocumentDischarges') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.
				16
				,-- Severity.
				1 -- State.
				);
	END CATCH
END

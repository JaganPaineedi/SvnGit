/****** Object:  StoredProcedure [dbo].[csp_SCGetCustomDocumentCommunityBasedAssessment]    Script Date: 06/19/2013 17:49:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomDocumentCommunityBasedAssessment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetCustomDocumentCommunityBasedAssessment]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomDocumentCommunityBasedAssessment]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE	procedure 

[dbo].[csp_SCGetCustomDocumentCommunityBasedAssessment]
	@DocumentVersionId int
AS

SELECT	[DocumentVersionId],   
        [CreatedBy],            
        [CreatedDate],         
        [ModifiedBy],           
        [ModifiedDate],         
        [RecordDeleted],        
        [DeletedDate],         
        [DeletedBy],
        
        [AuthorizationNumber],
        [EmploymentSite],
        [ReferralSource],
        [Dates],
        [HoursBilled],
        [Position],
        [Background],
        
--	Week 1 - Days 1 Through 5
		[Week1Date1],
		[Week1Date2],
		[Week1Date3],
		[Week1Date4],
		[Week1Date5],
		[AcceptsSupervisionW1D1],
		[AcceptsSupervisionW1D2],
		[AcceptsSupervisionW1D3],
		[AcceptsSupervisionW1D4],
		[AcceptsSupervisionW1D5],
		[BelievesInSelfW1D1],
		[BelievesInSelfW1D2],
		[BelievesInSelfW1D3],
		[BelievesInSelfW1D4],
		[BelievesInSelfW1D5],
		[CommunicatesW1D1],
		[CommunicatesW1D2],
		[CommunicatesW1D3],
		[CommunicatesW1D4],
		[CommunicatesW1D5],
		[QualityW1D1],
		[QualityW1D2],
		[QualityW1D3],
		[QualityW1D4],
		[QualityW1D5],
		[ConcentratesW1D1],
		[ConcentratesW1D2],
		[ConcentratesW1D3],
		[ConcentratesW1D4],
		[ConcentratesW1D5],
		[ProblemSolvesW1D1],
		[ProblemSolvesW1D2],
		[ProblemSolvesW1D3],
		[ProblemSolvesW1D4],
		[ProblemSolvesW1D5],
		[ContinuesW1D1],
		[ContinuesW1D2],
		[ContinuesW1D3],
		[ContinuesW1D4],
		[ContinuesW1D5],
		[ControlsFrustrationW1D1],
		[ControlsFrustrationW1D2],
		[ControlsFrustrationW1D3],
		[ControlsFrustrationW1D4],
		[ControlsFrustrationW1D5],
		[CooperatesW1D1],
		[CooperatesW1D2],
		[CooperatesW1D3],
		[CooperatesW1D4],
		[CooperatesW1D5],
		[FollowsInstructionsW1D1],
		[FollowsInstructionsW1D2],
		[FollowsInstructionsW1D3],
		[FollowsInstructionsW1D4],
		[FollowsInstructionsW1D5],
		[TemperamentW1D1],
		[TemperamentW1D2],
		[TemperamentW1D3],
		[TemperamentW1D4],
		[TemperamentW1D5],
		[MotivationW1D1],
		[MotivationW1D2],
		[MotivationW1D3],
		[MotivationW1D4],
		[MotivationW1D5],
		[SelfEsteemW1D1],
		[SelfEsteemW1D2],
		[SelfEsteemW1D3],
		[SelfEsteemW1D4],
		[SelfEsteemW1D5],
		[StaminaW1D1],
		[StaminaW1D2],
		[StaminaW1D3],
		[StaminaW1D4],
		[StaminaW1D5],
		[DecisionsW1D1],
		[DecisionsW1D2],
		[DecisionsW1D3],
		[DecisionsW1D4],
		[DecisionsW1D5],
		[RespondsToChangeW1D1],
		[RespondsToChangeW1D2],
		[RespondsToChangeW1D3],
		[RespondsToChangeW1D4],
		[RespondsToChangeW1D5],
		[ToleratesPressureW1D1],
		[ToleratesPressureW1D2],
		[ToleratesPressureW1D3],
		[ToleratesPressureW1D4],
		[ToleratesPressureW1D5],
		[WorksAloneW1D1],
		[WorksAloneW1D2],
		[WorksAloneW1D3],
		[WorksAloneW1D4],
		[WorksAloneW1D5],
		[EmployabilityW1D1],
		[EmployabilityW1D2],
		[EmployabilityW1D3],
		[EmployabilityW1D4],
		[EmployabilityW1D5],
	
--	Week 2 - Days 1 Through 5
		[Week2Date1],
		[Week2Date2],
		[Week2Date3],
		[Week2Date4],
		[Week2Date5],
		[AcceptsSupervisionW2D1],
		[AcceptsSupervisionW2D2],
		[AcceptsSupervisionW2D3],
		[AcceptsSupervisionW2D4],
		[AcceptsSupervisionW2D5],
		[BelievesInSelfW2D1],
		[BelievesInSelfW2D2],
		[BelievesInSelfW2D3],
		[BelievesInSelfW2D4],
		[BelievesInSelfW2D5],
		[CommunicatesW2D1],
		[CommunicatesW2D2],
		[CommunicatesW2D3],
		[CommunicatesW2D4],
		[CommunicatesW2D5],
		[QualityW2D1],
		[QualityW2D2],
		[QualityW2D3],
		[QualityW2D4],
		[QualityW2D5],
		[ConcentratesW2D1],
		[ConcentratesW2D2],
		[ConcentratesW2D3],
		[ConcentratesW2D4],
		[ConcentratesW2D5],
		[ProblemSolvesW2D1],
		[ProblemSolvesW2D2],
		[ProblemSolvesW2D3],
		[ProblemSolvesW2D4],
		[ProblemSolvesW2D5],
		[ContinuesW2D1],
		[ContinuesW2D2],
		[ContinuesW2D3],
		[ContinuesW2D4],
		[ContinuesW2D5],
		[ControlsFrustrationW2D1],
		[ControlsFrustrationW2D2],
		[ControlsFrustrationW2D3],
		[ControlsFrustrationW2D4],
		[ControlsFrustrationW2D5],
		[CooperatesW2D1],
		[CooperatesW2D2],
		[CooperatesW2D3],
		[CooperatesW2D4],
		[CooperatesW2D5],
		[FollowsInstructionsW2D1],
		[FollowsInstructionsW2D2],
		[FollowsInstructionsW2D3],
		[FollowsInstructionsW2D4],
		[FollowsInstructionsW2D5],
		[TemperamentW2D1],
		[TemperamentW2D2],
		[TemperamentW2D3],
		[TemperamentW2D4],
		[TemperamentW2D5],
		[MotivationW2D1],
		[MotivationW2D2],
		[MotivationW2D3],
		[MotivationW2D4],
		[MotivationW2D5],
		[SelfEsteemW2D1],
		[SelfEsteemW2D2],
		[SelfEsteemW2D3],
		[SelfEsteemW2D4],
		[SelfEsteemW2D5],
		[StaminaW2D1],
		[StaminaW2D2],
		[StaminaW2D3],
		[StaminaW2D4],
		[StaminaW2D5],
		[DecisionsW2D1],
		[DecisionsW2D2],
		[DecisionsW2D3],
		[DecisionsW2D4],
		[DecisionsW2D5],
		[RespondsToChangeW2D1],
		[RespondsToChangeW2D2],
		[RespondsToChangeW2D3],
		[RespondsToChangeW2D4],
		[RespondsToChangeW2D5],
		[ToleratesPressureW2D1],
		[ToleratesPressureW2D2],
		[ToleratesPressureW2D3],
		[ToleratesPressureW2D4],
		[ToleratesPressureW2D5],
		[WorksAloneW2D1],
		[WorksAloneW2D2],
		[WorksAloneW2D3],
		[WorksAloneW2D4],
		[WorksAloneW2D5],
		[EmployabilityW2D1],
		[EmployabilityW2D2],
		[EmployabilityW2D3],
		[EmployabilityW2D4],
		[EmployabilityW2D5],	
		
		[SelfRating],	
		[Attendance],	
		[Punctuality],	
		[GettingAlongCoworkers],	
		[GettingAlongSupervisors],	
		[Summary]

FROM	CustomDocumentCommunityBasedAssessment
WHERE	(ISNULL(RecordDeleted, ''N'') = ''N'')
AND	([DocumentVersionId] = @DocumentVersionId)  



' 
END
GO

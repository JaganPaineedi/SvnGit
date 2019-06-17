/****** Object:  StoredProcedure [dbo].[csp_SCGetCustomDocumentSharedCoachingAssessment]    Script Date: 06/19/2013 17:49:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomDocumentSharedCoachingAssessment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetCustomDocumentSharedCoachingAssessment]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomDocumentSharedCoachingAssessment]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE procedure [dbo].[csp_SCGetCustomDocumentSharedCoachingAssessment]
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
        
--	Week 1 - Days 1 Through 3
		[Week1Date1],
		[Week1Date2],
		[Week1Date3],
		[AcceptsSupervisionW1D1],
		[AcceptsSupervisionW1D2],
		[AcceptsSupervisionW1D3],
		[BelievesInSelfW1D1],
		[BelievesInSelfW1D2],
		[BelievesInSelfW1D3],
		[CommunicatesW1D1],
		[CommunicatesW1D2],
		[CommunicatesW1D3],
		[QualityW1D1],
		[QualityW1D2],
		[QualityW1D3],
		[ConcentratesW1D1],
		[ConcentratesW1D2],
		[ConcentratesW1D3],
		[ProblemSolvesW1D1],
		[ProblemSolvesW1D2],
		[ProblemSolvesW1D3],
		[ContinuesW1D1],
		[ContinuesW1D2],
		[ContinuesW1D3],
		[ControlsFrustrationW1D1],
		[ControlsFrustrationW1D2],
		[ControlsFrustrationW1D3],
		[CooperatesW1D1],
		[CooperatesW1D2],
		[CooperatesW1D3],
		[FollowsInstructionsW1D1],
		[FollowsInstructionsW1D2],
		[FollowsInstructionsW1D3],
		[TemperamentW1D1],
		[TemperamentW1D2],
		[TemperamentW1D3],
		[MotivationW1D1],
		[MotivationW1D2],
		[MotivationW1D3],
		[SelfEsteemW1D1],
		[SelfEsteemW1D2],
		[SelfEsteemW1D3],
		[StaminaW1D1],
		[StaminaW1D2],
		[StaminaW1D3],
		[DecisionsW1D1],
		[DecisionsW1D2],
		[DecisionsW1D3],
		[RespondsToChangeW1D1],
		[RespondsToChangeW1D2],
		[RespondsToChangeW1D3],
		[ToleratesPressureW1D1],
		[ToleratesPressureW1D2],
		[ToleratesPressureW1D3],
		[WorksAloneW1D1],
		[WorksAloneW1D2],
		[WorksAloneW1D3],
		[EmployabilityW1D1],
		[EmployabilityW1D2],
		[EmployabilityW1D3],
	
--	Week 2 - Days 1 Through 3
		[Week2Date1],
		[Week2Date2],
		[Week2Date3],
		[AcceptsSupervisionW2D1],
		[AcceptsSupervisionW2D2],
		[AcceptsSupervisionW2D3],
		[BelievesInSelfW2D1],
		[BelievesInSelfW2D2],
		[BelievesInSelfW2D3],
		[CommunicatesW2D1],
		[CommunicatesW2D2],
		[CommunicatesW2D3],
		[QualityW2D1],
		[QualityW2D2],
		[QualityW2D3],
		[ConcentratesW2D1],
		[ConcentratesW2D2],
		[ConcentratesW2D3],
		[ProblemSolvesW2D1],
		[ProblemSolvesW2D2],
		[ProblemSolvesW2D3],
		[ContinuesW2D1],
		[ContinuesW2D2],
		[ContinuesW2D3],
		[ControlsFrustrationW2D1],
		[ControlsFrustrationW2D2],
		[ControlsFrustrationW2D3],
		[CooperatesW2D1],
		[CooperatesW2D2],
		[CooperatesW2D3],
		[FollowsInstructionsW2D1],
		[FollowsInstructionsW2D2],
		[FollowsInstructionsW2D3],
		[TemperamentW2D1],
		[TemperamentW2D2],
		[TemperamentW2D3],
		[MotivationW2D1],
		[MotivationW2D2],
		[MotivationW2D3],
		[SelfEsteemW2D1],
		[SelfEsteemW2D2],
		[SelfEsteemW2D3],
		[StaminaW2D1],
		[StaminaW2D2],
		[StaminaW2D3],
		[DecisionsW2D1],
		[DecisionsW2D2],
		[DecisionsW2D3],
		[RespondsToChangeW2D1],
		[RespondsToChangeW2D2],
		[RespondsToChangeW2D3],
		[ToleratesPressureW2D1],
		[ToleratesPressureW2D2],
		[ToleratesPressureW2D3],
		[WorksAloneW2D1],
		[WorksAloneW2D2],
		[WorksAloneW2D3],
		[EmployabilityW2D1],
		[EmployabilityW2D2],
		[EmployabilityW2D3],
		
--	Week 3 - Days 1 Through 3
		[Week3Date1],
		[Week3Date2],
		[Week3Date3],
		[AcceptsSupervisionW3D1],
		[AcceptsSupervisionW3D2],
		[AcceptsSupervisionW3D3],
		[BelievesInSelfW3D1],
		[BelievesInSelfW3D2],
		[BelievesInSelfW3D3],
		[CommunicatesW3D1],
		[CommunicatesW3D2],
		[CommunicatesW3D3],
		[QualityW3D1],
		[QualityW3D2],
		[QualityW3D3],
		[ConcentratesW3D1],
		[ConcentratesW3D2],
		[ConcentratesW3D3],
		[ProblemSolvesW3D1],
		[ProblemSolvesW3D2],
		[ProblemSolvesW3D3],
		[ContinuesW3D1],
		[ContinuesW3D2],
		[ContinuesW3D3],
		[ControlsFrustrationW3D1],
		[ControlsFrustrationW3D2],
		[ControlsFrustrationW3D3],
		[CooperatesW3D1],
		[CooperatesW3D2],
		[CooperatesW3D3],
		[FollowsInstructionsW3D1],
		[FollowsInstructionsW3D2],
		[FollowsInstructionsW3D3],
		[TemperamentW3D1],
		[TemperamentW3D2],
		[TemperamentW3D3],
		[MotivationW3D1],
		[MotivationW3D2],
		[MotivationW3D3],
		[SelfEsteemW3D1],
		[SelfEsteemW3D2],
		[SelfEsteemW3D3],
		[StaminaW3D1],
		[StaminaW3D2],
		[StaminaW3D3],
		[DecisionsW3D1],
		[DecisionsW3D2],
		[DecisionsW3D3],
		[RespondsToChangeW3D1],
		[RespondsToChangeW3D2],
		[RespondsToChangeW3D3],
		[ToleratesPressureW3D1],
		[ToleratesPressureW3D2],
		[ToleratesPressureW3D3],
		[WorksAloneW3D1],
		[WorksAloneW3D2],
		[WorksAloneW3D3],
		[EmployabilityW3D1],
		[EmployabilityW3D2],
		[EmployabilityW3D3],
		
--	Week 4 - Days 1 Through 3
		[Week4Date1],
		[Week4Date2],
		[Week4Date3],
		[AcceptsSupervisionW4D1],
		[AcceptsSupervisionW4D2],
		[AcceptsSupervisionW4D3],
		[BelievesInSelfW4D1],
		[BelievesInSelfW4D2],
		[BelievesInSelfW4D3],
		[CommunicatesW4D1],
		[CommunicatesW4D2],
		[CommunicatesW4D3],
		[QualityW4D1],
		[QualityW4D2],
		[QualityW4D3],
		[ConcentratesW4D1],
		[ConcentratesW4D2],
		[ConcentratesW4D3],
		[ProblemSolvesW4D1],
		[ProblemSolvesW4D2],
		[ProblemSolvesW4D3],
		[ContinuesW4D1],
		[ContinuesW4D2],
		[ContinuesW4D3],
		[ControlsFrustrationW4D1],
		[ControlsFrustrationW4D2],
		[ControlsFrustrationW4D3],
		[CooperatesW4D1],
		[CooperatesW4D2],
		[CooperatesW4D3],
		[FollowsInstructionsW4D1],
		[FollowsInstructionsW4D2],
		[FollowsInstructionsW4D3],
		[TemperamentW4D1],
		[TemperamentW4D2],
		[TemperamentW4D3],
		[MotivationW4D1],
		[MotivationW4D2],
		[MotivationW4D3],
		[SelfEsteemW4D1],
		[SelfEsteemW4D2],
		[SelfEsteemW4D3],
		[StaminaW4D1],
		[StaminaW4D2],
		[StaminaW4D3],
		[DecisionsW4D1],
		[DecisionsW4D2],
		[DecisionsW4D3],
		[RespondsToChangeW4D1],
		[RespondsToChangeW4D2],
		[RespondsToChangeW4D3],
		[ToleratesPressureW4D1],
		[ToleratesPressureW4D2],
		[ToleratesPressureW4D3],
		[WorksAloneW4D1],
		[WorksAloneW4D2],
		[WorksAloneW4D3],
		[EmployabilityW4D1],
		[EmployabilityW4D2],
		[EmployabilityW4D3],
		
		[SelfRating],	
		[Attendance],	
		[Punctuality],	
		[GettingAlongCoworkers],	
		[GettingAlongSupervisors],	
		[Summary]

FROM	CustomDocumentSharedCoachingAssessment
WHERE	(ISNULL(RecordDeleted, ''N'') = ''N'')
AND	([DocumentVersionId] = @DocumentVersionId)  



' 
END
GO

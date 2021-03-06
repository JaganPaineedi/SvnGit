/****** Object:  StoredProcedure [dbo].[csp_RDLCustomDocumentCommunityBasedAssessmentViewMode]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDocumentCommunityBasedAssessmentViewMode]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomDocumentCommunityBasedAssessmentViewMode]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDocumentCommunityBasedAssessmentViewMode]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE	PROCEDURE   [dbo].[csp_RDLCustomDocumentCommunityBasedAssessmentViewMode]  
(  
@DocumentVersionId  int   
)  
AS  
--*/

/*
DECLARE	@DocumentVersionId  int   
SELECT	@DocumentVersionId = 1186
--*/

/************************************************************************************/
/* Stored Procedure: dbo.[csp_RDLCustomDocumentCommunityBasedAssessmentViewMode]	*/
/* Purpose:  Get Data for csp_RDLCustomDocumentCommunityBasedAssessment Pages		*/
/*																					*/
/* Updates:																			*/
/* Date:	Author:		Purpose:													*/
/* 6/04/12	Jess		Created														*/
/*3/Aug/2012		Jagdeep			Task No. 1851 - Harbor Go Live (To handle 2nd version exception in case of RDL)*/
/************************************************************************************/


BEGIN  

--BEGIN TRY  

SELECT	SystemConfig.OrganizationName,  
		C.FirstName + '' '' + C.LastName as ClientName,  
--		S.FirstName + '' '' + S.LastName as JobCoach,  
		D.ClientID,  
		DC.DocumentName as DocumentName,
		CONVERT(VARCHAR(10), D.EffectiveDate, 101) as EffectiveDate,
		CASE	WHEN	substring(convert(varchar, D.CreatedDate, 108), 1, 2) = 00
				THEN	convert(varchar(2), 12) + substring(convert(varchar, D.CreatedDate, 108), 3, 3) + ''AM''
				WHEN	substring(convert(varchar, D.CreatedDate, 108), 1, 2) < 12
				THEN	substring(convert(varchar, D.CreatedDate, 108), 1, 5) + ''AM''
				WHEN	substring(convert(varchar, D.CreatedDate, 108), 1, 2) = 12
				THEN	substring(convert(varchar, D.CreatedDate, 108), 1, 5) + ''PM''
				WHEN	convert(varchar(2), substring(convert(varchar, D.CreatedDate, 108), 1, 2) - 12) < 10
				THEN	''0'' + convert(varchar(2), substring(convert(varchar, D.CreatedDate, 108), 1, 2) - 12) +
					convert(varchar(3), substring(convert(varchar, D.CreatedDate, 108), 3, 3)) + ''PM''
				ELSE	convert(varchar(2), substring(convert(varchar, D.CreatedDate, 108), 1, 2) - 12) +
					convert(varchar(3), substring(convert(varchar, D.CreatedDate, 108), 3, 3)) + ''PM''
		END	AS	''EffectiveTime'',
		CASE	WHEN	GC.CodeName IS NULL
				THEN	S.FirstName + '' '' + S.LastName
				ELSE	S.FirstName + '' '' + S.LastName + '', '' + GC.CodeName
		END		AS		ClinicianName,
		--CASE	DS.VerificationMode 
		--		WHEN	''P''
		--		THEN	''''
		--		WHEN	''S''
		--		THEN	(SELECT PhysicalSignature FROM DocumentSignatures DS WHERE dv.DocumentId = DS.DocumentId) 
		--END	AS	Signature,
		--CONVERT(VARCHAR(10), DS.SignatureDate, 101) as SignatureDate,
		--DS.VerificationMode as VerificationStyle, 
--		LTRIM(RIGHT(CONVERT(VARCHAR(10), SE.DateOfService, 100), 7)) as StartTime,  
--		convert(varchar(10),SE.Unit)+'' ''+ GC2.CodeName  as Duration,  
--		L.LocationName as Location,  
--		PC.ProcedureCodeName as ProcedureName,  
		
--		CBA.*

		CBA.DocumentVersionId,
		CBA.CreatedBy,
		CBA.CreatedDate,
		CBA.ModifiedBy,
		CBA.ModifiedDate,
		CBA.RecordDeleted,
		CBA.DeletedBy,
		CBA.DeletedDate,
	
	
		CBA.AuthorizationNumber,
		CBA.EmploymentSite,
		CBA.ReferralSource,
		CBA.Dates,
		CBA.HoursBilled,
		CBA.Position,
		CBA.Background,

	--	Week 1 - Days 1 Through 3
		CBA.Week1Date1,
		CBA.Week1Date2,
		CBA.Week1Date3,
		CBA.Week1Date4,
		CBA.Week1Date5,
		dbo.csf_GetGlobalCodeNameById(CBA.AcceptsSupervisionW1D1) AS AcceptsSupervisionW1D1,
		dbo.csf_GetGlobalCodeNameById(CBA.AcceptsSupervisionW1D2) AS AcceptsSupervisionW1D2,
		dbo.csf_GetGlobalCodeNameById(CBA.AcceptsSupervisionW1D3) AS AcceptsSupervisionW1D3,
		dbo.csf_GetGlobalCodeNameById(CBA.AcceptsSupervisionW1D4) AS AcceptsSupervisionW1D4,
		dbo.csf_GetGlobalCodeNameById(CBA.AcceptsSupervisionW1D5) AS AcceptsSupervisionW1D5,
		dbo.csf_GetGlobalCodeNameById(CBA.BelievesInSelfW1D1) AS BelievesInSelfW1D1,
		dbo.csf_GetGlobalCodeNameById(CBA.BelievesInSelfW1D2) AS BelievesInSelfW1D2,
		dbo.csf_GetGlobalCodeNameById(CBA.BelievesInSelfW1D3) AS BelievesInSelfW1D3,
		dbo.csf_GetGlobalCodeNameById(CBA.BelievesInSelfW1D4) AS BelievesInSelfW1D4,
		dbo.csf_GetGlobalCodeNameById(CBA.BelievesInSelfW1D5) AS BelievesInSelfW1D5,
		dbo.csf_GetGlobalCodeNameById(CBA.CommunicatesW1D1) AS CommunicatesW1D1,
		dbo.csf_GetGlobalCodeNameById(CBA.CommunicatesW1D2) AS CommunicatesW1D2,
		dbo.csf_GetGlobalCodeNameById(CBA.CommunicatesW1D3) AS CommunicatesW1D3,
		dbo.csf_GetGlobalCodeNameById(CBA.CommunicatesW1D4) AS CommunicatesW1D4,
		dbo.csf_GetGlobalCodeNameById(CBA.CommunicatesW1D5) AS CommunicatesW1D5,
		dbo.csf_GetGlobalCodeNameById(CBA.QualityW1D1) AS QualityW1D1,
		dbo.csf_GetGlobalCodeNameById(CBA.QualityW1D2) AS QualityW1D2,
		dbo.csf_GetGlobalCodeNameById(CBA.QualityW1D3) AS QualityW1D3,
		dbo.csf_GetGlobalCodeNameById(CBA.QualityW1D4) AS QualityW1D4,
		dbo.csf_GetGlobalCodeNameById(CBA.QualityW1D5) AS QualityW1D5,
		dbo.csf_GetGlobalCodeNameById(CBA.ConcentratesW1D1) AS ConcentratesW1D1,
		dbo.csf_GetGlobalCodeNameById(CBA.ConcentratesW1D2) AS ConcentratesW1D2,
		dbo.csf_GetGlobalCodeNameById(CBA.ConcentratesW1D3) AS ConcentratesW1D3,
		dbo.csf_GetGlobalCodeNameById(CBA.ConcentratesW1D4) AS ConcentratesW1D4,
		dbo.csf_GetGlobalCodeNameById(CBA.ConcentratesW1D5) AS ConcentratesW1D5,
		dbo.csf_GetGlobalCodeNameById(CBA.ProblemSolvesW1D1) AS ProblemSolvesW1D1,
		dbo.csf_GetGlobalCodeNameById(CBA.ProblemSolvesW1D2) AS ProblemSolvesW1D2,
		dbo.csf_GetGlobalCodeNameById(CBA.ProblemSolvesW1D3) AS ProblemSolvesW1D3,
		dbo.csf_GetGlobalCodeNameById(CBA.ProblemSolvesW1D4) AS ProblemSolvesW1D4,
		dbo.csf_GetGlobalCodeNameById(CBA.ProblemSolvesW1D5) AS ProblemSolvesW1D5,
		dbo.csf_GetGlobalCodeNameById(CBA.ContinuesW1D1) AS ContinuesW1D1,
		dbo.csf_GetGlobalCodeNameById(CBA.ContinuesW1D2) AS ContinuesW1D2,
		dbo.csf_GetGlobalCodeNameById(CBA.ContinuesW1D3) AS ContinuesW1D3,
		dbo.csf_GetGlobalCodeNameById(CBA.ContinuesW1D4) AS ContinuesW1D4,
		dbo.csf_GetGlobalCodeNameById(CBA.ContinuesW1D5) AS ContinuesW1D5,
		dbo.csf_GetGlobalCodeNameById(CBA.ControlsFrustrationW1D1) AS ControlsFrustrationW1D1,
		dbo.csf_GetGlobalCodeNameById(CBA.ControlsFrustrationW1D2) AS ControlsFrustrationW1D2,
		dbo.csf_GetGlobalCodeNameById(CBA.ControlsFrustrationW1D3) AS ControlsFrustrationW1D3,
		dbo.csf_GetGlobalCodeNameById(CBA.ControlsFrustrationW1D4) AS ControlsFrustrationW1D4,
		dbo.csf_GetGlobalCodeNameById(CBA.ControlsFrustrationW1D5) AS ControlsFrustrationW1D5,
		dbo.csf_GetGlobalCodeNameById(CBA.CooperatesW1D1) AS CooperatesW1D1,
		dbo.csf_GetGlobalCodeNameById(CBA.CooperatesW1D2) AS CooperatesW1D2,
		dbo.csf_GetGlobalCodeNameById(CBA.CooperatesW1D3) AS CooperatesW1D3,
		dbo.csf_GetGlobalCodeNameById(CBA.CooperatesW1D4) AS CooperatesW1D4,
		dbo.csf_GetGlobalCodeNameById(CBA.CooperatesW1D5) AS CooperatesW1D5,
		dbo.csf_GetGlobalCodeNameById(CBA.FollowsInstructionsW1D1) AS FollowsInstructionsW1D1,
		dbo.csf_GetGlobalCodeNameById(CBA.FollowsInstructionsW1D2) AS FollowsInstructionsW1D2,
		dbo.csf_GetGlobalCodeNameById(CBA.FollowsInstructionsW1D3) AS FollowsInstructionsW1D3,
		dbo.csf_GetGlobalCodeNameById(CBA.FollowsInstructionsW1D4) AS FollowsInstructionsW1D4,
		dbo.csf_GetGlobalCodeNameById(CBA.FollowsInstructionsW1D5) AS FollowsInstructionsW1D5,
		dbo.csf_GetGlobalCodeNameById(CBA.TemperamentW1D1) AS TemperamentW1D1,
		dbo.csf_GetGlobalCodeNameById(CBA.TemperamentW1D2) AS TemperamentW1D2,
		dbo.csf_GetGlobalCodeNameById(CBA.TemperamentW1D3) AS TemperamentW1D3,
		dbo.csf_GetGlobalCodeNameById(CBA.TemperamentW1D4) AS TemperamentW1D4,
		dbo.csf_GetGlobalCodeNameById(CBA.TemperamentW1D5) AS TemperamentW1D5,
		dbo.csf_GetGlobalCodeNameById(CBA.MotivationW1D1) AS MotivationW1D1,
		dbo.csf_GetGlobalCodeNameById(CBA.MotivationW1D2) AS MotivationW1D2,
		dbo.csf_GetGlobalCodeNameById(CBA.MotivationW1D3) AS MotivationW1D3,
		dbo.csf_GetGlobalCodeNameById(CBA.MotivationW1D4) AS MotivationW1D4,
		dbo.csf_GetGlobalCodeNameById(CBA.MotivationW1D5) AS MotivationW1D5,
		dbo.csf_GetGlobalCodeNameById(CBA.SelfEsteemW1D1) AS SelfEsteemW1D1,
		dbo.csf_GetGlobalCodeNameById(CBA.SelfEsteemW1D2) AS SelfEsteemW1D2,
		dbo.csf_GetGlobalCodeNameById(CBA.SelfEsteemW1D3) AS SelfEsteemW1D3,
		dbo.csf_GetGlobalCodeNameById(CBA.SelfEsteemW1D4) AS SelfEsteemW1D4,
		dbo.csf_GetGlobalCodeNameById(CBA.SelfEsteemW1D5) AS SelfEsteemW1D5,
		dbo.csf_GetGlobalCodeNameById(CBA.StaminaW1D1) AS StaminaW1D1,
		dbo.csf_GetGlobalCodeNameById(CBA.StaminaW1D2) AS StaminaW1D2,
		dbo.csf_GetGlobalCodeNameById(CBA.StaminaW1D3) AS StaminaW1D3,
		dbo.csf_GetGlobalCodeNameById(CBA.StaminaW1D4) AS StaminaW1D4,
		dbo.csf_GetGlobalCodeNameById(CBA.StaminaW1D5) AS StaminaW1D5,
		dbo.csf_GetGlobalCodeNameById(CBA.DecisionsW1D1) AS DecisionsW1D1,
		dbo.csf_GetGlobalCodeNameById(CBA.DecisionsW1D2) AS DecisionsW1D2,
		dbo.csf_GetGlobalCodeNameById(CBA.DecisionsW1D3) AS DecisionsW1D3,
		dbo.csf_GetGlobalCodeNameById(CBA.DecisionsW1D4) AS DecisionsW1D4,
		dbo.csf_GetGlobalCodeNameById(CBA.DecisionsW1D5) AS DecisionsW1D5,
		dbo.csf_GetGlobalCodeNameById(CBA.RespondsToChangeW1D1) AS RespondsToChangeW1D1,
		dbo.csf_GetGlobalCodeNameById(CBA.RespondsToChangeW1D2) AS RespondsToChangeW1D2,
		dbo.csf_GetGlobalCodeNameById(CBA.RespondsToChangeW1D3) AS RespondsToChangeW1D3,
		dbo.csf_GetGlobalCodeNameById(CBA.RespondsToChangeW1D4) AS RespondsToChangeW1D4,
		dbo.csf_GetGlobalCodeNameById(CBA.RespondsToChangeW1D5) AS RespondsToChangeW1D5,
		dbo.csf_GetGlobalCodeNameById(CBA.ToleratesPressureW1D1) AS ToleratesPressureW1D1,
		dbo.csf_GetGlobalCodeNameById(CBA.ToleratesPressureW1D2) AS ToleratesPressureW1D2,
		dbo.csf_GetGlobalCodeNameById(CBA.ToleratesPressureW1D3) AS ToleratesPressureW1D3,
		dbo.csf_GetGlobalCodeNameById(CBA.ToleratesPressureW1D4) AS ToleratesPressureW1D4,
		dbo.csf_GetGlobalCodeNameById(CBA.ToleratesPressureW1D5) AS ToleratesPressureW1D5,
		dbo.csf_GetGlobalCodeNameById(CBA.WorksAloneW1D1) AS WorksAloneW1D1,
		dbo.csf_GetGlobalCodeNameById(CBA.WorksAloneW1D2) AS WorksAloneW1D2,
		dbo.csf_GetGlobalCodeNameById(CBA.WorksAloneW1D3) AS WorksAloneW1D3,
		dbo.csf_GetGlobalCodeNameById(CBA.WorksAloneW1D4) AS WorksAloneW1D4,
		dbo.csf_GetGlobalCodeNameById(CBA.WorksAloneW1D5) AS WorksAloneW1D5,
		dbo.csf_GetGlobalCodeNameById(CBA.EmployabilityW1D1) AS EmployabilityW1D1,
		dbo.csf_GetGlobalCodeNameById(CBA.EmployabilityW1D2) AS EmployabilityW1D2,
		dbo.csf_GetGlobalCodeNameById(CBA.EmployabilityW1D3) AS EmployabilityW1D3,
		dbo.csf_GetGlobalCodeNameById(CBA.EmployabilityW1D4) AS EmployabilityW1D4,
		dbo.csf_GetGlobalCodeNameById(CBA.EmployabilityW1D5) AS EmployabilityW1D5,
		
	--	Week 2 - Days 1 Through 3
		CBA.Week2Date1,
		CBA.Week2Date2,
		CBA.Week2Date3,
		CBA.Week2Date4,
		CBA.Week2Date5,
		dbo.csf_GetGlobalCodeNameById(CBA.AcceptsSupervisionW2D1) AS AcceptsSupervisionW2D1,
		dbo.csf_GetGlobalCodeNameById(CBA.AcceptsSupervisionW2D2) AS AcceptsSupervisionW2D2,
		dbo.csf_GetGlobalCodeNameById(CBA.AcceptsSupervisionW2D3) AS AcceptsSupervisionW2D3,
		dbo.csf_GetGlobalCodeNameById(CBA.AcceptsSupervisionW2D4) AS AcceptsSupervisionW2D4,
		dbo.csf_GetGlobalCodeNameById(CBA.AcceptsSupervisionW2D5) AS AcceptsSupervisionW2D5,
		dbo.csf_GetGlobalCodeNameById(CBA.BelievesInSelfW2D1) AS BelievesInSelfW2D1,
		dbo.csf_GetGlobalCodeNameById(CBA.BelievesInSelfW2D2) AS BelievesInSelfW2D2,
		dbo.csf_GetGlobalCodeNameById(CBA.BelievesInSelfW2D3) AS BelievesInSelfW2D3,
		dbo.csf_GetGlobalCodeNameById(CBA.BelievesInSelfW2D4) AS BelievesInSelfW2D4,
		dbo.csf_GetGlobalCodeNameById(CBA.BelievesInSelfW2D5) AS BelievesInSelfW2D5,
		dbo.csf_GetGlobalCodeNameById(CBA.CommunicatesW2D1) AS CommunicatesW2D1,
		dbo.csf_GetGlobalCodeNameById(CBA.CommunicatesW2D2) AS CommunicatesW2D2,
		dbo.csf_GetGlobalCodeNameById(CBA.CommunicatesW2D3) AS CommunicatesW2D3,
		dbo.csf_GetGlobalCodeNameById(CBA.CommunicatesW2D4) AS CommunicatesW2D4,
		dbo.csf_GetGlobalCodeNameById(CBA.CommunicatesW2D5) AS CommunicatesW2D5,
		dbo.csf_GetGlobalCodeNameById(CBA.QualityW2D1) AS QualityW2D1,
		dbo.csf_GetGlobalCodeNameById(CBA.QualityW2D2) AS QualityW2D2,
		dbo.csf_GetGlobalCodeNameById(CBA.QualityW2D3) AS QualityW2D3,
		dbo.csf_GetGlobalCodeNameById(CBA.QualityW2D4) AS QualityW2D4,
		dbo.csf_GetGlobalCodeNameById(CBA.QualityW2D5) AS QualityW2D5,
		dbo.csf_GetGlobalCodeNameById(CBA.ConcentratesW2D1) AS ConcentratesW2D1,
		dbo.csf_GetGlobalCodeNameById(CBA.ConcentratesW2D2) AS ConcentratesW2D2,
		dbo.csf_GetGlobalCodeNameById(CBA.ConcentratesW2D3) AS ConcentratesW2D3,
		dbo.csf_GetGlobalCodeNameById(CBA.ConcentratesW2D4) AS ConcentratesW2D4,
		dbo.csf_GetGlobalCodeNameById(CBA.ConcentratesW2D5) AS ConcentratesW2D5,
		dbo.csf_GetGlobalCodeNameById(CBA.ProblemSolvesW2D1) AS ProblemSolvesW2D1,
		dbo.csf_GetGlobalCodeNameById(CBA.ProblemSolvesW2D2) AS ProblemSolvesW2D2,
		dbo.csf_GetGlobalCodeNameById(CBA.ProblemSolvesW2D3) AS ProblemSolvesW2D3,
		dbo.csf_GetGlobalCodeNameById(CBA.ProblemSolvesW2D4) AS ProblemSolvesW2D4,
		dbo.csf_GetGlobalCodeNameById(CBA.ProblemSolvesW2D5) AS ProblemSolvesW2D5,
		dbo.csf_GetGlobalCodeNameById(CBA.ContinuesW2D1) AS ContinuesW2D1,
		dbo.csf_GetGlobalCodeNameById(CBA.ContinuesW2D2) AS ContinuesW2D2,
		dbo.csf_GetGlobalCodeNameById(CBA.ContinuesW2D3) AS ContinuesW2D3,
		dbo.csf_GetGlobalCodeNameById(CBA.ContinuesW2D4) AS ContinuesW2D4,
		dbo.csf_GetGlobalCodeNameById(CBA.ContinuesW2D5) AS ContinuesW2D5,
		dbo.csf_GetGlobalCodeNameById(CBA.ControlsFrustrationW2D1) AS ControlsFrustrationW2D1,
		dbo.csf_GetGlobalCodeNameById(CBA.ControlsFrustrationW2D2) AS ControlsFrustrationW2D2,
		dbo.csf_GetGlobalCodeNameById(CBA.ControlsFrustrationW2D3) AS ControlsFrustrationW2D3,
		dbo.csf_GetGlobalCodeNameById(CBA.ControlsFrustrationW2D4) AS ControlsFrustrationW2D4,
		dbo.csf_GetGlobalCodeNameById(CBA.ControlsFrustrationW2D5) AS ControlsFrustrationW2D5,
		dbo.csf_GetGlobalCodeNameById(CBA.CooperatesW2D1) AS CooperatesW2D1,
		dbo.csf_GetGlobalCodeNameById(CBA.CooperatesW2D2) AS CooperatesW2D2,
		dbo.csf_GetGlobalCodeNameById(CBA.CooperatesW2D3) AS CooperatesW2D3,
		dbo.csf_GetGlobalCodeNameById(CBA.CooperatesW2D4) AS CooperatesW2D4,
		dbo.csf_GetGlobalCodeNameById(CBA.CooperatesW2D5) AS CooperatesW2D5,
		dbo.csf_GetGlobalCodeNameById(CBA.FollowsInstructionsW2D1) AS FollowsInstructionsW2D1,
		dbo.csf_GetGlobalCodeNameById(CBA.FollowsInstructionsW2D2) AS FollowsInstructionsW2D2,
		dbo.csf_GetGlobalCodeNameById(CBA.FollowsInstructionsW2D3) AS FollowsInstructionsW2D3,
		dbo.csf_GetGlobalCodeNameById(CBA.FollowsInstructionsW2D4) AS FollowsInstructionsW2D4,
		dbo.csf_GetGlobalCodeNameById(CBA.FollowsInstructionsW2D5) AS FollowsInstructionsW2D5,
		dbo.csf_GetGlobalCodeNameById(CBA.TemperamentW2D1) AS TemperamentW2D1,
		dbo.csf_GetGlobalCodeNameById(CBA.TemperamentW2D2) AS TemperamentW2D2,
		dbo.csf_GetGlobalCodeNameById(CBA.TemperamentW2D3) AS TemperamentW2D3,
		dbo.csf_GetGlobalCodeNameById(CBA.TemperamentW2D4) AS TemperamentW2D4,
		dbo.csf_GetGlobalCodeNameById(CBA.TemperamentW2D5) AS TemperamentW2D5,
		dbo.csf_GetGlobalCodeNameById(CBA.MotivationW2D1) AS MotivationW2D1,
		dbo.csf_GetGlobalCodeNameById(CBA.MotivationW2D2) AS MotivationW2D2,
		dbo.csf_GetGlobalCodeNameById(CBA.MotivationW2D3) AS MotivationW2D3,
		dbo.csf_GetGlobalCodeNameById(CBA.MotivationW2D4) AS MotivationW2D4,
		dbo.csf_GetGlobalCodeNameById(CBA.MotivationW2D5) AS MotivationW2D5,
		dbo.csf_GetGlobalCodeNameById(CBA.SelfEsteemW2D1) AS SelfEsteemW2D1,
		dbo.csf_GetGlobalCodeNameById(CBA.SelfEsteemW2D2) AS SelfEsteemW2D2,
		dbo.csf_GetGlobalCodeNameById(CBA.SelfEsteemW2D3) AS SelfEsteemW2D3,
		dbo.csf_GetGlobalCodeNameById(CBA.SelfEsteemW2D4) AS SelfEsteemW2D4,
		dbo.csf_GetGlobalCodeNameById(CBA.SelfEsteemW2D5) AS SelfEsteemW2D5,
		dbo.csf_GetGlobalCodeNameById(CBA.StaminaW2D1) AS StaminaW2D1,
		dbo.csf_GetGlobalCodeNameById(CBA.StaminaW2D2) AS StaminaW2D2,
		dbo.csf_GetGlobalCodeNameById(CBA.StaminaW2D3) AS StaminaW2D3,
		dbo.csf_GetGlobalCodeNameById(CBA.StaminaW2D4) AS StaminaW2D4,
		dbo.csf_GetGlobalCodeNameById(CBA.StaminaW2D5) AS StaminaW2D5,
		dbo.csf_GetGlobalCodeNameById(CBA.DecisionsW2D1) AS DecisionsW2D1,
		dbo.csf_GetGlobalCodeNameById(CBA.DecisionsW2D2) AS DecisionsW2D2,
		dbo.csf_GetGlobalCodeNameById(CBA.DecisionsW2D3) AS DecisionsW2D3,
		dbo.csf_GetGlobalCodeNameById(CBA.DecisionsW2D4) AS DecisionsW2D4,
		dbo.csf_GetGlobalCodeNameById(CBA.DecisionsW2D5) AS DecisionsW2D5,
		dbo.csf_GetGlobalCodeNameById(CBA.RespondsToChangeW2D1) AS RespondsToChangeW2D1,
		dbo.csf_GetGlobalCodeNameById(CBA.RespondsToChangeW2D2) AS RespondsToChangeW2D2,
		dbo.csf_GetGlobalCodeNameById(CBA.RespondsToChangeW2D3) AS RespondsToChangeW2D3,
		dbo.csf_GetGlobalCodeNameById(CBA.RespondsToChangeW2D4) AS RespondsToChangeW2D4,
		dbo.csf_GetGlobalCodeNameById(CBA.RespondsToChangeW2D5) AS RespondsToChangeW2D5,
		dbo.csf_GetGlobalCodeNameById(CBA.ToleratesPressureW2D1) AS ToleratesPressureW2D1,
		dbo.csf_GetGlobalCodeNameById(CBA.ToleratesPressureW2D2) AS ToleratesPressureW2D2,
		dbo.csf_GetGlobalCodeNameById(CBA.ToleratesPressureW2D3) AS ToleratesPressureW2D3,
		dbo.csf_GetGlobalCodeNameById(CBA.ToleratesPressureW2D4) AS ToleratesPressureW2D4,
		dbo.csf_GetGlobalCodeNameById(CBA.ToleratesPressureW2D5) AS ToleratesPressureW2D5,
		dbo.csf_GetGlobalCodeNameById(CBA.WorksAloneW2D1) AS WorksAloneW2D1,
		dbo.csf_GetGlobalCodeNameById(CBA.WorksAloneW2D2) AS WorksAloneW2D2,
		dbo.csf_GetGlobalCodeNameById(CBA.WorksAloneW2D3) AS WorksAloneW2D3,
		dbo.csf_GetGlobalCodeNameById(CBA.WorksAloneW2D4) AS WorksAloneW2D4,
		dbo.csf_GetGlobalCodeNameById(CBA.WorksAloneW2D5) AS WorksAloneW2D5,
		dbo.csf_GetGlobalCodeNameById(CBA.EmployabilityW2D1) AS EmployabilityW2D1,
		dbo.csf_GetGlobalCodeNameById(CBA.EmployabilityW2D2) AS EmployabilityW2D2,
		dbo.csf_GetGlobalCodeNameById(CBA.EmployabilityW2D3) AS EmployabilityW2D3,
		dbo.csf_GetGlobalCodeNameById(CBA.EmployabilityW2D4) AS EmployabilityW2D4,
		dbo.csf_GetGlobalCodeNameById(CBA.EmployabilityW2D5) AS EmployabilityW2D5,
		

		dbo.csf_GetGlobalCodeNameById(CBA.SelfRating) AS SelfRating,	
		dbo.csf_GetGlobalCodeNameById(CBA.Attendance) AS Attendance,	
		dbo.csf_GetGlobalCodeNameById(CBA.Punctuality) AS Punctuality,	
		dbo.csf_GetGlobalCodeNameById(CBA.GettingAlongCoworkers) AS GettingAlongCoworkers,	
		dbo.csf_GetGlobalCodeNameById(CBA.GettingAlongSupervisors) AS GettingAlongSupervisors,	
		CBA.Summary

FROM	CustomDocumentCommunityBasedAssessment CBA
JOIN	DocumentVersions DV	ON	dv.DocumentVersionId = CBA.DocumentVersionId
JOIN	Documents D	ON	d.DocumentId = dv.DocumentId
JOIN	Staff S	ON	d.AuthorId = S.StaffId
JOIN	Clients C	ON	d.ClientId = C.ClientId
LEFT JOIN	GlobalCodes GC	ON	S.Degree = GC.GlobalCodeId
--LEFT JOIN	Services SE	ON	d.ServiceId = SE.ServiceId
--LEFT JOIN	GlobalCodes GC2	ON	SE.UnitType = GC2.GlobalCodeId   
--LEFT JOIN	ProcedureCodes PC	ON	SE.ProcedureCodeId = PC.ProcedureCodeId   
--LEFT JOIN	GlobalCodes GC3	ON	SE.Status = GC3.GlobalCodeId 
--LEFT JOIN	DocumentSignatures DS	ON	dv.DocumentId = DS.DocumentId
--LEFT JOIN	Locations L	ON	SE.LocationId = L.LocationId  
LEFT JOIN	DocumentCodes DC	ON	dc.DocumentCodeId = D.DocumentCodeId
CROSS JOIN	SystemConfigurations as SystemConfig
WHERE	CBA.DocumentVersionId = @DocumentVersionId   
AND		isnull(D.RecordDeleted, ''N'') = ''N''  
AND		isnull(S.RecordDeleted, ''N'') = ''N'' 
AND		isnull(C.RecordDeleted, ''N'') = ''N''
AND		isNull(GC.RecordDeleted, ''N'') = ''N''   
--AND		isNull(SE.RecordDeleted, ''N'') = ''N''
--AND		isNull(GC2.RecordDeleted, ''N'') = ''N''  
--AND		ISNULL(PC.RecordDeleted, ''N'') = ''N'' 
--AND		ISNULL(GC3.RecordDeleted, ''N'') = ''N''
--AND		isNull(DS.RecordDeleted, ''N'') = ''N''
--AND		isNull(SG.RecordDeleted, ''N'') = ''N''
--AND		isNull(TN.RecordDeleted, ''N'') = ''N''
--AND		isNull(SO.RecordDeleted, ''N'') = ''N''
--AND		isNull(TON.RecordDeleted, ''N'') = ''N''
  
--END TRY  
    

END  
/*
BEGIN CATCH  

   DECLARE @Error VARCHAR(8000)         
  SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + ''*****'' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                              
   + ''*****'' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),''csp_RDLCustomDocumentSuicideStatusForm'')                                                                                               
   + ''*****'' + CONVERT(VARCHAR,ERROR_LINE()) + ''*****'' + CONVERT(VARCHAR,ERROR_SEVERITY())                                                                                                
   + ''*****'' + CONVERT(VARCHAR,ERROR_STATE())  
  RAISERROR  
  (  
   @Error, -- Message text.  
   16,  -- Severity.  
   1  -- State.  
  );  
END CATCH  
  
*/

' 
END
GO

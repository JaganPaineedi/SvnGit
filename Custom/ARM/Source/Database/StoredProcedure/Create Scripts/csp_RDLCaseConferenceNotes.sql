/****** Object:  StoredProcedure [dbo].[csp_RDLCaseConferenceNotes]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCaseConferenceNotes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCaseConferenceNotes]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCaseConferenceNotes]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE   [dbo].[csp_RDLCaseConferenceNotes]
(
@DocumentVersionId  int 
)
AS

/*********************************************************************************************/
/* 
Date			Author					Purpose
3/Aug/2012		Jagdeep			Task No. 1851 - Harbor Go Live (To handle 2nd version exception in case of RDL)
/*22.12.2017 - Kavya.N     - Changed clientname and ClinicianName format to (Firstname Lastname)*/
*/
/*********************************************************************************************/
Begin

BEGIN TRY
SELECT top 1 C.Firstname + '' '' + C.LastName as ClientName,		
		CONVERT(VARCHAR(10), DOCUMENTS.EffectiveDate, 101) as EffectiveDate,
		S.Firstname + '' '' + S.LastName+ '' '' +ISNull(GC.CodeName,'''') as ClinicianName, 
		--CASE DS.VerificationMode 
		--WHEN ''P'' THEN
		--''''
		--WHEN ''S'' THEN 
		--(SELECT PhysicalSignature FROM DocumentSignatures DS WHERE dv.DocumentId=DS.DocumentId) 
		--END as [Signature],
		--CONVERT(VARCHAR(10), DS.SignatureDate, 101) as SignatureDate,
		--DS.VerificationMode as VerificationStyle,
		Documents.ClientId,
		CE.ClientEpisodeId,
        CDCC.PurposeProblemSolving,
        CDCC.PurposeTransferCase,
        CDCC.PurposeAddtionalServicesNeeded,
        CDCC.PurposeOther,
        CDCC.PurposeOtherComment,
        CDCC.StaffedWithCSPCaseManager,
        CDCC.StaffedWithVocationalStaff,
        CDCC.StaffedWithPsychologyStaff,
        CDCC.StaffedWithEAPConsultant,
        CDCC.StaffedWithSupervisor,
        CDCC.StaffedWithMedicalStaff,
        CDCC.StaffedWithQI,
        CDCC.StaffedWithClinicalTeamMeeting,
        CDCC.StaffedWithTherapist,
        CDCC.StaffedWithOpportunityManagement,
        CDCC.StaffedWithOther,
        CDCC.StaffedWithOtherComment,
        CDCC.IssuesProblem,
        CDCC.InterventionsContracting,
        CDCC.InterventionsMeetingParentsFamilyOther,
        CDCC.InterventionsClassroomReorganization,
        CDCC.InterventionsIndividualCounseling,
        CDCC.InterventionsCommunitySupport,
        CDCC.InterventionsClassroomConsultation,
        CDCC.InterventionsMeetingInterventionTeam,
        CDCC.InterventionsStaffing,
        CDCC.Interventions1to1Intervention,
        CDCC.InterventionsGroupCounseling,
        CDCC.InterventionsVocationServices,
        CDCC.InterventionsOther,
        CDCC.InterventionsOtherComment,
        CDCC.WorkedPastWithClient,
        SpecificTimeDayWeek,
        NaturalSupportsAvailable,
        CDCC.ClientStrengthsSupportProgress,
        CDCC.PlanOfAction
FROM [CustomDocumentCaseConferenceNotes] CDCC
join DocumentVersions as dv on dv.DocumentVersionId = CDCC.DocumentVersionId
join Documents ON  Documents.DocumentId = dv.DocumentId 
join Staff S on Documents.AuthorId= S.StaffId 
join Clients C on Documents.ClientId= C.ClientId 
left join ClientEpisodes CE on Documents.ClientId= CE.ClientId 
Left Join GlobalCodes GC On S.Degree=GC.GlobalCodeId 
--left join DocumentSignatures DS on dv.DocumentId=DS.DocumentId 
left join Services SE on Documents.ServiceId=SE.ServiceId
left join Locations L on SE.LocationId=L.LocationId
Cross Join SystemConfigurations as SystemConfig
where CDCC.DocumentVersionId=@DocumentVersionId 
and isnull(Documents.RecordDeleted,''N'')=''N''
and isnull(S.RecordDeleted,''N'')=''N''
and isnull(C.RecordDeleted,''N'')=''N''
and isnull(CE.RecordDeleted,''N'')=''N''
and isNull(GC.RecordDeleted,''N'')=''N''
--and isNull(DS.RecordDeleted,''N'')=''N''

END TRY
BEGIN CATCH
DECLARE @Error VARCHAR(8000)       
		SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + ''*****'' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                            
			+ ''*****'' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),''csp_RDLCaseConferenceNotes'')                                                                                             
			+ ''*****'' + CONVERT(VARCHAR,ERROR_LINE()) + ''*****'' + CONVERT(VARCHAR,ERROR_SEVERITY())                                                                                              
			+ ''*****'' + CONVERT(VARCHAR,ERROR_STATE())
		RAISERROR
		(
			@Error, -- Message text.
			16,		-- Severity.
			1		-- State.
		);
END CATCH
End





' 
END
GO

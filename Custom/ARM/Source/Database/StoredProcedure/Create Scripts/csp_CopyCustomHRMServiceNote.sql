/****** Object:  StoredProcedure [dbo].[csp_CopyCustomHRMServiceNote]    Script Date: 06/19/2013 17:49:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CopyCustomHRMServiceNote]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_CopyCustomHRMServiceNote]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CopyCustomHRMServiceNote]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE procedure [dbo].[csp_CopyCustomHRMServiceNote]
-- =============================================
-- Author:		Wasif Butt
-- Create date: Oct, 6 2011
-- Description:	Copy client docs from clinician doc
-- Modifications:
--		2011.11.23 - T. Remisoski - Create Documents, versions and notes where missing
-- =============================================
      @GroupServiceId INT ,
      @StaffId INT   
AS 
begin try
begin tran

	declare @tNewDocuments table (
		DocumentId int
	)
	
	declare @tNewDocumentVersions table (
		DocumentId int,
		DocumentVersionId int
	)

	-- new documents for this author
	insert into dbo.Documents (
		ClientId,
		ServiceId,
		GroupServiceId,
		DocumentCodeId,
		EffectiveDate,
		[Status],
		AuthorId,
		DocumentShared,
		SignedByAuthor,
		SignedByAll,
		CurrentVersionStatus
	)
	output inserted.DocumentId into @tNewDocuments(DocumentId)
    select
		s.ClientId,
		s.ServiceId,
		gs.GroupServiceId,
		g.GroupNoteDocumentCodeId,
		dbo.RemoveTimeStamp(s.DateOfService),
		21,
		s.NoteAuthorId,
		''N'',
		''N'',
		''N'',
		21
    from dbo.Services as s
    join dbo.GroupServices as gs on gs.GroupServiceId = s.GroupServiceId
    join dbo.Groups as g on g.GroupId = gs.GroupId
    where gs.GroupServiceId = @GroupServiceId
    and s.ClinicianId = @StaffId
    and s.[Status] in (70, 71)
    and not exists (
		select *
		from dbo.Documents as d2
		where d2.ServiceId = s.ServiceId
		and d2.ClientId = s.ClientId
		and ISNULL(d2.RecordDeleted, ''N'') <> ''Y''
	)

	-- Document versions for documents
	insert into dbo.DocumentVersions 
	        (
	         DocumentId,
	         Version,
	         AuthorId,
	         EffectiveDate,
	         RevisionNumber
	        )
	output inserted.DocumentId, inserted.DocumentVersionId into @tNewDocumentVersions(DocumentId, DocumentVersionId)
	select t.DocumentId,
		1,
		@StaffId,
		d.EffectiveDate,
		1
	from @tNewDocuments as t
	join dbo.Documents as d on d.DocumentId = t.DocumentId
	
	-- go back and update documents with version data
	update d set
		CurrentDocumentVersionId = t.DocumentVersionId,
		InProgressDocumentVersionId = t.DocumentVersionId
	from Documents as d
	join @tNewDocumentVersions as t on t.DocumentId = d.DocumentId
	
	-- signatures
	insert into dbo.DocumentSignatures 
	        (
	         DocumentId,
	         SignedDocumentVersionId,
	         StaffId,
	         SignatureOrder,
	         RevisionNumber
	        )
	select t.DocumentId,
		t.DocumentVersionId,
		@StaffId,
		1,
		1
	from @tNewDocumentVersions as t
	
	-- create the custom table records
	insert into CustomHRMServiceNotes (
		DocumentVersionId
	)
	select DocumentVersionId
	from @tNewDocumentVersions
	
	declare @GroupId INT              

	select  @GroupId = Groupid
	from    GroupServices
	where   GroupServiceId = @GroupServiceId              
        
        
        
	UPDATE  hrm
	SET     ServiceType = grp.ServiceType ,
			ServiceModality = grp.ServiceModality ,
			ServiceModalityComment = grp.ServiceModalityComment ,
			Diagnosis = grp.Diagnosis ,
			ChangeMoodAffect = grp.ChangeMoodAffect ,
			ChangeMoodAffectComment = grp.ChangeMoodAffectComment ,
			ChangeThoughtProcess = grp.ChangeThoughtProcess ,
			ChangeThoughtProcessComment = grp.ChangeThoughtProcessComment ,
			ChangeBehavior = grp.ChangeBehavior ,
			ChangeBehaviorComment = grp.ChangeBehaviorComment ,
			ChangeMedicalCondition = grp.ChangeMedicalCondition ,
			ChangeMedicalConditionComment = grp.ChangeMedicalConditionComment ,
			ChangeSubstanceUse = grp.ChangeSubstanceUse ,
			ChangeSubstanceUseComment = grp.ChangeSubstanceUseComment ,
			RiskNoneReported = grp.RiskNoneReported ,
			RiskSelf = grp.RiskSelf ,
			RiskOthers = grp.RiskOthers ,
			RiskProperty = grp.RiskProperty ,
			RiskIdeation = grp.RiskIdeation ,
			RiskPlan = grp.RiskPlan ,
			RiskIntent = grp.RiskIntent ,
			RiskAttempt = grp.RiskAttempt ,
			RiskOther = grp.RiskOther ,
			RiskOtherComment = grp.RiskOtherComment ,
			RiskResponseComment = grp.RiskResponseComment ,
			MedicationConcerns = grp.MedicationConcerns ,
			MedicationConcernsComment = grp.MedicationConcernsComment ,
			ProgressTowardOutcomeComment = grp.ProgressTowardOutcomeComment ,
			ClinicalInterventionComment = grp.ClinicalInterventionComment ,
			AxisV = grp.AxisV ,
			ProgressTowardOutcomeAndClinicalInterventionComment = grp.ProgressTowardOutcomeAndClinicalInterventionComment ,
			NotifyStaffId1 = grp.NotifyStaffId1 ,
			NotifyStaffId2 = grp.NotifyStaffId2 ,
			NotifyStaffId3 = grp.NotifyStaffId3 ,
			NotifyStaffId4 = grp.NotifyStaffId4 ,
			NotificationMessage = grp.NotificationMessage
	FROM    Documents D
			JOIN CustomHRMServiceNotes HRM ON HRM.DocumentVersionId = D.CurrentDocumentVersionId
			JOIN ( SELECT   DocumentVersionId ,
							ServiceType ,
							ServiceModality ,
							ServiceModalityComment ,
							Diagnosis ,
							ChangeMoodAffect ,
							ChangeMoodAffectComment ,
							ChangeThoughtProcess ,
							ChangeThoughtProcessComment ,
							ChangeBehavior ,
							ChangeBehaviorComment ,
							ChangeMedicalCondition ,
							ChangeMedicalConditionComment ,
							ChangeSubstanceUse ,
							ChangeSubstanceUseComment ,
							RiskNoneReported ,
							RiskSelf ,
							RiskOthers ,
							RiskProperty ,
							RiskIdeation ,
							RiskPlan ,
							RiskIntent ,
							RiskAttempt ,
							RiskOther ,
							RiskOtherComment ,
							RiskResponseComment ,
							MedicationConcerns ,
							MedicationConcernsComment ,
							ProgressTowardOutcomeComment ,
							ClinicalInterventionComment ,
							AxisV ,
							ProgressTowardOutcomeAndClinicalInterventionComment ,
							NotifyStaffId1 ,
							NotifyStaffId2 ,
							NotifyStaffId3 ,
							NotifyStaffId4 ,
							NotificationMessage ,
							GroupServiceId
				   FROM     Documents D
							JOIN CustomHRMServiceNotes HRM ON HRM.DocumentVersionId = D.CurrentDocumentVersionId
				   WHERE    GroupServiceId = @GroupServiceId
							AND ClientId IS NULL
				 ) AS GRP ON grp.GroupServiceId = d.GroupServiceId
	WHERE   d.GroupServiceId = @GroupServiceId
			AND ClientId IS NOT NULL
			AND D.DocumentCodeId = 353
			AND AuthorId = @StaffId
			AND Status <> 22
                              
	commit tran
end try
begin catch
	--if @@TRANCOUNT > 0 rollback tran
	declare @error_message nvarchar(4000)
	set @error_message = ERROR_MESSAGE()
	raiserror (@error_message, 16, 1)
end catch


' 
END
GO

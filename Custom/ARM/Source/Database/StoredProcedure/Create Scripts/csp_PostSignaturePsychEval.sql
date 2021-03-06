/****** Object:  StoredProcedure [dbo].[csp_PostSignaturePsychEval]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PostSignaturePsychEval]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_PostSignaturePsychEval]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PostSignaturePsychEval]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


create procedure [dbo].[csp_PostSignaturePsychEval]
	@ScreenKeyId int,
	@StaffId int,
	@CurrentUser varchar(30),
	@CustomParameters xml
/****************************************************************/
-- PROCEDURE: csp_PostSignaturePsychEval
-- PURPOSE: Post eval signature events.
-- CALLED BY: SmartCare on post-update (signature)
-- REVISION HISTORY:
--		2011.10.02 - T. Remisoski - Created.
/****************************************************************/

as

begin try
begin tran

declare @DocumentVersionId int
select @DocumentVersionId = CurrentDocumentVersionId from Documents where DocumentId = @ScreenKeyId

-- CONSTANTS
declare @constReferralDocumentCodeId int = 15001, @constTransferDocumentCodeId int = 15002, @constDocumentInProgress int = 21

declare @constReferralStatusSent int
select @constReferralStatusSent = GlobalCodeId from GlobalCodes where Category = ''REFERRALSTATUS'' and CodeName = ''Sent''

declare @constDocumentSigned int = 22
declare @constDocumentCodeDiagnosis int = 5


--select * from dbo.DocumentCodes where DocumentName like ''%refer%'' and DocumentType = 10
declare
	@ReceivingStaffId int,
	@ServiceRecommended int,
	@ServiceAmount int,
	@ServiceUnitType int,
	@ServiceFrequency int,
	@AssessedNeedForReferral varchar(500),
	@ClientParticipatedReferral type_YOrN

declare @newDocumentId int, @ClientId int

declare @tDocumentsCreated table (
	DocumentId int
)

declare @tDocuments table (
	DocumentId int
)

declare @tDocumentVersions table (
	DocumentVersionId int
)
	
declare @lastStaffId int = 0, @lastAssessedNeed varchar(500) = '''', @lastClientParticipatedReferral char(1) = ''''

-- Gather the data needed for referral documents

declare @cReferralItems cursor
set @cReferralItems =
cursor for
select  cr.ReceivingStaffId,
        cr.ServiceRecommended,
        cr.ServiceAmount,
        cr.ServiceUnitType,
        cr.ServiceFrequency,
        ISNULL(cr.AssessedNeedForReferral, ''''),
        cr.ClientParticipatedReferral
from dbo.CustomDocumentPsychiatricEvaluationReferrals as cr
join dbo.CustomDocumentPsychiatricEvaluations as da on da.DocumentVersionId = cr.DocumentVersionId
where cr.DocumentVersionId = @DocumentVersionId
and ISNULL(cr.RecordDeleted, ''N'') <> ''Y''
order by cr.ReceivingStaffId, cr.AssessedNeedForReferral, cr.ClientParticipatedReferral

open @cReferralItems

fetch @cReferralItems into
	@ReceivingStaffId,
	@ServiceRecommended,
	@ServiceAmount,
	@ServiceUnitType,
	@ServiceFrequency,
	@AssessedNeedForReferral,
	@ClientParticipatedReferral

while @@FETCH_STATUS = 0
begin

	-- check for new document break
	if (@AssessedNeedForReferral <> @lastAssessedNeed)
		or (@lastStaffId <> @ReceivingStaffId)
--		or (@lastClientParticipatedReferral <> @ClientParticipatedReferral)
	begin

		delete from @tDocuments
		delete from @tDocumentVersions
		
		-- Documents
		insert into dbo.Documents
		        (
		         ClientId,
		         DocumentCodeId,
		         EffectiveDate,
		         Status,
		         AuthorId,
		         DocumentShared,
		         SignedByAuthor,
		         SignedByAll
		        )
		output inserted.DocumentId into @tDocuments(DocumentId)
		select d.ClientId,
				@constReferralDocumentCodeId,
				d.EffectiveDate,
				@constDocumentInProgress,
				@ReceivingStaffId,
				''Y'',
				''N'',
				''N''
		from dbo.Documents as d
		where d.CurrentDocumentVersionId = @DocumentVersionId
		
		-- DocumentVersions
		insert into dbo.DocumentVersions
		        (
		         DocumentId,
		         Version,
		         AuthorId,
		         EffectiveDate,
				 RevisionNumber
		        )
		output inserted.DocumentVersionId into @tDocumentVersions(DocumentVersionId)
		select td.DocumentId,
				1,
				@ReceivingStaffId,
				d.EffectiveDate,
				1
		from @tDocuments as td
		join dbo.Documents as d on d.DocumentId = td.DocumentId
		
		-- Link the new documentversionid back to the document
		update d set
			CurrentDocumentVersionId = tdv.DocumentVersionId,
			InProgressDocumentVersionId = tdv.DocumentVersionId,
			CurrentVersionStatus = @constDocumentInProgress
		from Documents as d
		join @tDocuments as td on td.DocumentId = d.DocumentId
		cross join @tDocumentVersions as tdv
		
		-- DocumentSignatures
		insert into dbo.DocumentSignatures
		        (
		         DocumentId,
		         StaffId,
		         SignatureOrder,
		         SignedDocumentVersionId
		        )
		select td.DocumentId,
				@ReceivingStaffId,
				1,
				tdv.DocumentVersionid
		from @tDocuments as td
		cross join @tDocumentVersions as tdv
		
		-- The referral document "header"
		insert into dbo.CustomDocumentReferrals
		        (
		         DocumentVersionId,
		         ReferralStatus,
		         ReferringStaff,
		         AssessedNeedForReferral,
		         ReceivingStaff,
		         ClientParticpatedWithReferral,
		         ReferralSentDate
		        )
		select tdv.DocumentVersionId,
				@constReferralStatusSent,
				d.AuthorId,
				@AssessedNeedForReferral,
				@ReceivingStaffId,
				@ClientParticipatedReferral,
				GETDATE()
		from @tDocumentVersions as tdv
		cross join dbo.Documents as d
		where d.CurrentDocumentVersionId = @DocumentVersionId

		select @newDocumentId = d.DocumentId, @ClientId = d.ClientId
		from @tDocuments as td
		join dbo.Documents as d on d.DocumentId = td.DocumentId

		exec dbo.csp_CustomDocumentReferralTransferAlert @DocumentId = @newDocumentId, -- int
			@ClientId = @ClientId, -- int
			@RecipientStaffId = @ReceivingStaffId, -- int
			@Subject = ''New Referral Document Sent'', -- varchar(700)
			@Message = ''A new referral document has been sent and is awaiting your response.  Click the document reference link to edit to respond.'' -- varchar(3000)
		
		-- create a record of the document that was created
		insert into @tDocumentsCreated(DocumentId) select DocumentId from @tDocuments
								
		set @lastStaffId = @ReceivingStaffId
		set @lastAssessedNeed = @AssessedNeedForReferral
		set @lastClientParticipatedReferral = @ClientParticipatedReferral
	end


	-- create the child record
	insert into dbo.CustomDocumentReferralServices
	        (
	         DocumentVersionId,
	         AuthorizationCodeId
	        )
	select td.DocumentVersionId,
		@ServiceRecommended
	from @tDocumentVersions as td


	
	fetch @cReferralItems into
		@ReceivingStaffId,
		@ServiceRecommended,
		@ServiceAmount,
		@ServiceUnitType,
		@ServiceFrequency,
		@AssessedNeedForReferral,
		@ClientParticipatedReferral

end

close @cReferralItems

deallocate @cReferralItems

--select * from @tDocumentsCreated

-- create treatment plan goals
if exists(select * from dbo.CustomDocumentPsychiatricEvaluations where DocumentVersionId = @DocumentVersionId and CreateMedicatlTxPlan = ''Y'')
	exec csp_PostSignaturePsychEvalCreateMedTreatmentPlanGoals @DocumentVersionId
	
-- create diagnosis
-- if diagnosis records exist, create the diagnosis document
if exists (select * from dbo.DiagnosesIAndII as dx where dx.DocumentVersionId = @DocumentVersionId and ISNULL(dx.RecordDeleted, ''N'') <> ''Y'')
begin
	-- create the diagnosis document
	-- Documents
	delete from @tDocuments
	delete from @tDocumentVersions

    insert  into dbo.Documents
            (
             ClientId,
             DocumentCodeId,
             EffectiveDate,
             Status,
             AuthorId,
             DocumentShared,
             SignedByAuthor,
             SignedByAll
	        
            )
    output  inserted.DocumentId
            into @tDocuments (DocumentId)
            select  d.ClientId,
                    @constDocumentCodeDiagnosis,
                    d.EffectiveDate,
                    @constDocumentSigned,
                    d.AuthorId,
                    ''Y'',
                    ''Y'',
                    ''Y''
            from    dbo.Documents as d
            where   d.CurrentDocumentVersionId = @DocumentVersionId
		
	-- DocumentVersions
    insert  into dbo.DocumentVersions
            (
             DocumentId,
             Version,
             AuthorId,
             EffectiveDate,
             RevisionNumber
	        
            )
    output  inserted.DocumentVersionId
            into @tDocumentVersions (DocumentVersionId)
            select  td.DocumentId,
                    1,
                    d.AuthorId,
                    d.EffectiveDate,
                    1
            from    @tDocuments as td
            join    dbo.Documents as d on d.DocumentId = td.DocumentId
		
	-- Link the new documentversionid back to the document
    update  d
    set
			CurrentDocumentVersionId = tdv.DocumentVersionId,
			InProgressDocumentVersionId = tdv.DocumentVersionId,
			CurrentVersionStatus = @constDocumentSigned
    from    Documents as d
    join    @tDocuments as td on td.DocumentId = d.DocumentId
    cross join @tDocumentVersions as tdv
		
	-- DocumentSignatures
    insert  into dbo.DocumentSignatures
            (
             DocumentId,
             StaffId,
             SignatureOrder,
             SignedDocumentVersionId,
             SignerName,
             SignatureDate
	        
            )
            select  td.DocumentId,
                    ds.StaffId,
                    ds.signatureOrder,
                    tdv.DocumentVersionid,
                    ds.SignerName,
					GETDATE()
            from    @tDocuments as td
            join    dbo.Documents as d on d.DocumentId = td.DocumentId
            cross join @tDocumentVersions as tdv
            cross join dbo.DocumentVersions as dv
            join dbo.DocumentSignatures as ds on ds.SignedDocumentVersionId = dv.DocumentVersionId
            where dv.DocumentVersionId = @DocumentVersionId
			
	-- Create the actual custom Document
	insert into dbo.DiagnosesIAndII
	        (
	         DocumentVersionId,
	         Axis,
	         DSMCode,
	         DSMNumber,
	         DiagnosisType,
	         RuleOut,
	         Billable,
	         Severity,
	         DSMVersion,
	         DiagnosisOrder,
	         Specifier,
	         Remission,
	         Source
	        )
	select  dv.DocumentVersionId,
	         dx.Axis,
	         dx.DSMCode,
	         dx.DSMNumber,
	         dx.DiagnosisType,
	         dx.RuleOut,
	         dx.Billable,
	         dx.Severity,
	         dx.DSMVersion,
	         dx.DiagnosisOrder,
	         dx.Specifier,
	         dx.Remission,
	         dx.Source
	from @tDocumentVersions as dv
	cross join dbo.DiagnosesIAndII as dx
	where dx.DocumentVersionId = @DocumentVersionId
	and ISNULL(dx.RecordDeleted, ''N'') <> ''Y''

	insert into dbo.DiagnosesIII
	        (
	         DocumentVersionId,
	         Specification
	        )
	select  dv.DocumentVersionId,
		dx.Specification
	from @tDocumentVersions as dv
	cross join dbo.DiagnosesIII as dx
	where dx.DocumentVersionId = @DocumentVersionId
	and ISNULL(dx.RecordDeleted, ''N'') <> ''Y''

	insert into dbo.DiagnosesIIICodes
	        (
	         DocumentVersionId,
	         ICDCode,
	         Billable
	        )
	select  dv.DocumentVersionId,
		dx.ICDCode,
		dx.Billable
	from @tDocumentVersions as dv
	cross join dbo.DiagnosesIIICodes as dx
	where dx.DocumentVersionId = @DocumentVersionId
	and ISNULL(dx.RecordDeleted, ''N'') <> ''Y''

	insert dbo.DiagnosesIV 
	        (
	         DocumentVersionId,
	         PrimarySupport,
	         SocialEnvironment,
	         Educational,
	         Occupational,
	         Housing,
	         Economic,
	         HealthcareServices,
	         Legal,
	         Other,
	         Specification
	        )
	select  dv.DocumentVersionId,
	         dx.PrimarySupport,
	         dx.SocialEnvironment,
	         dx.Educational,
	         dx.Occupational,
	         dx.Housing,
	         dx.Economic,
	         dx.HealthcareServices,
	         dx.Legal,
	         dx.Other,
	         dx.Specification
	from @tDocumentVersions as dv
	cross join dbo.DiagnosesIV as dx
	where dx.DocumentVersionId = @DocumentVersionId
	and ISNULL(dx.RecordDeleted, ''N'') <> ''Y''

	insert into dbo.DiagnosesV
	        (
	         DocumentVersionId,
	         AxisV
	        )
	select  dv.DocumentVersionId,
		dx.AxisV
	from @tDocumentVersions as dv
	cross join dbo.DiagnosesV as dx
	where dx.DocumentVersionId = @DocumentVersionId
	and ISNULL(dx.RecordDeleted, ''N'') <> ''Y''

	-- send a notification to the treatment team
	declare @NotificationReference int, @AuthorId int
	select @NotificationReference = t.DocumentId, @AuthorId = d.AuthorId from @tDocuments as t join Documents as d on d.DocumentId = t.DocumentId
	
	if @NotificationReference is not null
		exec dbo.csp_CreateAlertHarborTreatmentTeam @TriggeringStaffId = @AuthorId, -- int
			@ClientId = @ClientId, -- int
			@msgSubject = ''Diagnosis updated based on results of psychatric evaluation.'', -- varchar(700)
			@msgBody = ''Diagnosis updated based on results of psychatric evaluation.'', -- varchar(3000)
			@DocumentReference = @NotificationReference

end


commit tran
end try
begin catch

if @@TRANCOUNT > 0 rollback tran

declare @errorMessage nvarchar(4000)
set @errorMessage = ERROR_MESSAGE()

raiserror(@errorMessage, 16, 1)

end catch



' 
END
GO

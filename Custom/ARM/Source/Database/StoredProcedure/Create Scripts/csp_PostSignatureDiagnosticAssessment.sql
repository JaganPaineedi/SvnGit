IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PostSignatureDiagnosticAssessment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_PostSignatureDiagnosticAssessment]
GO

Create procedure [dbo].[csp_PostSignatureDiagnosticAssessment]
	@ScreenKeyId int,
	@StaffId int,
	@CurrentUser varchar(30),
	@CustomParameters xml
/****************************************************************/
-- PROCEDURE: csp_PostSignatureDiagnosticAssessment
-- PURPOSE: Post assessment signature events.
-- CALLED BY: SmartCare on post-update (signature)
-- REVISION HISTORY:
--		2011.10.02 - T. Remisoski - Created.
--		2012.02.23 - T. Remisoski - Remove program copy for now.  Need to map global code to Program in configuration.
--		2012.11.10 - T. Remisoski - Removed "psych testing" from list of auto-accepted referral codes.
/****************************************************************/

as

begin try
set transaction isolation level read uncommitted
begin tran

declare @DocumentVersionId int
select @DocumentVersionId = CurrentDocumentVersionId from Documents where DocumentId = @ScreenKeyId

-- CONSTANTS
declare @constReferralDocumentCodeId int = 15001, @constTransferDocumentCodeId int = 15002, @constDocumentInProgress int = 21
declare @constDocumentCodeTreatmentPlanInitial int = 1483,
        @constDocumentSigned int = 22,
        @constObjectiveStatusActive int = 1
declare @constDocumentCodeDiagnosis int = 1601

declare @AutoApproveReferralAuthorizationCodes table (
	AuthorizationCodeId int
)
insert into @AutoApproveReferralAuthorizationCodes
        (AuthorizationCodeId)	-- from AuthorizationCodes table
values 
	(10),	--	Developmental Pediatric Consultation
	(11),	--	Integrated Primary Care
	(13),	--	Pharmacologic Management
	(14)	--	Psychiatric Evaluation
	-- psych testing only approved on "forward" action (15)	--	Psychological Testing

-- get out of custom global code hell
declare @constReferralStatusSent int, @constReferralStatusComplete int, @constReceivingActionAccept int
select @constReferralStatusSent = GlobalCodeId from GlobalCodes where Category = 'REFERRALSTATUS' and CodeName = 'Sent'
select @constReferralStatusComplete = GlobalCodeId from GlobalCodes where Category = 'REFERRALSTATUS' and CodeName = 'Complete'
select @constReceivingActionAccept = GlobalCodeId from GlobalCodes where Category = 'RECEIVINGACTION' and CodeName = 'Accept'

--select * from dbo.DocumentCodes where DocumentName like '%refer%' and DocumentType = 10
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
	
declare @lastStaffId int = 0, @lastAssessedNeed varchar(500) = '', @lastClientParticipatedReferral char(1) = ''

-- Gather the data needed for referral documents

declare cReferralItems insensitive cursor for
select  cr.ReceivingStaffId,
        cr.ServiceRecommended,
        cr.ServiceAmount,
        cr.ServiceUnitType,
        cr.ServiceFrequency,
        ISNULL(cr.AssessedNeedForReferral, ''),
        cr.ClientParticipatedReferral
from dbo.CustomDocumentAssessmentReferrals as cr
join dbo.CustomDocumentDiagnosticAssessments as da on da.DocumentVersionId = cr.DocumentVersionId
where cr.DocumentVersionId = @DocumentVersionId
and ISNULL(cr.RecordDeleted, 'N') <> 'Y'
order by cr.ReceivingStaffId, cr.AssessedNeedForReferral, cr.ClientParticipatedReferral

open cReferralItems

fetch cReferralItems into
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
				'Y',
				'N',
				'N'
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


	
	fetch cReferralItems into
		@ReceivingStaffId,
		@ServiceRecommended,
		@ServiceAmount,
		@ServiceUnitType,
		@ServiceFrequency,
		@AssessedNeedForReferral,
		@ClientParticipatedReferral

end

close cReferralItems

deallocate cReferralItems

-- loop through all of the documents created and either auto-approve or send notifications to users
declare @refDocumentId int, @refDocumentVersionId int

declare cReferralDocs insensitive cursor for
select d.DocumentId, d.CurrentDocumentVersionId, d.AuthorId
from @tDocumentsCreated as t
join dbo.Documents as d on d.DocumentId = t.DocumentId

open cReferralDocs

fetch cReferralDocs into @refDocumentId, @refDocumentVersionId, @ReceivingStaffId

while @@fetch_status = 0
begin
	-- if the referral services in this document are only for the ones listed as "auto-approve", set the document status accordingly.  Otherwise send the alert
	if (0 < (select COUNT(*) from dbo.CustomDocumentReferralServices as rs join @AutoApproveReferralAuthorizationCodes as a on a.AuthorizationCodeId = rs.AuthorizationCodeId where rs.DocumentVersionId = @refDocumentVersionId and ISNULL(rs.RecordDeleted, 'N') <> 'Y'))
	and (0 = (select COUNT(*) from dbo.CustomDocumentReferralServices as rs where rs.DocumentVersionId = @refDocumentVersionId and ISNULL(rs.RecordDeleted, 'N') <> 'Y' and not exists (select * from @AutoApproveReferralAuthorizationCodes as a where a.AuthorizationCodeId = rs.AuthorizationCodeId)))
	begin
	
		-- update the status to accepted with comment
		update cdr set
			ReferralStatus = @constReferralStatusComplete,
			ReceivingComment = 'Services on the referral are configured for "auto-acceptance".',
			ReceivingAction = @ConstReceivingActionAccept,
			ReceivingActionDate = GETDATE()
		from dbo.CustomDocumentReferrals as cdr
		where cdr.DocumentVersionId = @refDocumentVersionId
		
		-- set the author of the referral document back to the person who authored it originally
		update ds set
			StaffId = d.AuthorId,
			SignatureDate = GETDATE(),
			SignerName = s.FirstName + ' ' + s.LastName + case when s.SigningSuffix is not null then ', ' + s.SigningSuffix else '' end
		from dbo.DocumentVersions as dv
		join dbo.DocumentSignatures as ds on ds.DocumentId = dv.DocumentId and ds.SignedDocumentVersionId = dv.DocumentVersionId
		cross join dbo.Documents as d
		join Staff as s on s.StaffId = d.AuthorId		-- get the author of the assessment document
		where dv.DocumentVersionId = @refDocumentVersionId
		and d.CurrentDocumentVersionId = @DocumentVersionId
		
		-- set the referral document as signed
		update d set
			AuthorId = d2.AuthorId,
			Status = @constDocumentSigned,
			CurrentVersionStatus = @constDocumentSigned
		from Documents as d
		cross join dbo.Documents as d2
		where 
		d.DocumentId = @refDocumentId
		and d2.CurrentDocumentVersionId = @DocumentVersionId

	end
	else
	begin
		exec dbo.csp_CustomDocumentReferralTransferAlert @DocumentId = @newDocumentId, -- int
			@ClientId = @ClientId, -- int
			@RecipientStaffId = @ReceivingStaffId, -- int
			@Subject = 'New Referral Document Sent', -- varchar(700)
			@Message = 'A new referral document has been sent and is awaiting your response.  Click the document reference link to edit to respond.' -- varchar(3000)
	end

	fetch cReferralDocs into @refDocumentId, @refDocumentVersionId, @ReceivingStaffId

end

close cReferralDocs

deallocate cReferralDocs

-- Now create any transfer documents
declare @AssessedNeedForTransfer varchar(250)
declare @TransferReceivingProgram int
declare @TransferClientParticipated char(1)

if exists (select * from dbo.CustomDocumentDiagnosticAssessments as da where da.DocumentVersionId = @DocumentVersionId and PrimaryClinicianTransfer = 'Y' and TransferReceivingStaff is not null)
begin

	select
		@ReceivingStaffId = TransferReceivingStaff,
		@AssessedNeedForTransfer = TransferAssessedNeed,
		@TransferReceivingProgram = TransferReceivingProgram,
		@TransferClientParticipated = TransferClientParticipated
	from dbo.CustomDocumentDiagnosticAssessments
	where DocumentVersionId = @DocumentVersionid
	
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
			@constTransferDocumentCodeId,
			d.EffectiveDate,
			@constDocumentInProgress,
			@ReceivingStaffId,
			'Y',
			'N',
			'N'
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
	
	-- create the custom transfer documents entry
	insert into dbo.CustomDocumentTransfers
	        (
	         DocumentVersionId,
	         TransferStatus,
	         TransferringStaff,
	         AssessedNeedForTransfer,
	         ReceivingStaff,
	         ReceivingProgram,
	         ClientParticpatedWithTransfer,
	         TransferSentDate
	        )
	select dv.DocumentVersionId,
			@constReferralStatusSent,
			d.AuthorId,
			@AssessedNeedForTransfer,
			@ReceivingStaffId,
			null,	-- @TransferReceivingProgram,
			@TransferClientParticipated,
			GETDATE()
	from @tDocumentVersions as dv
	cross join dbo.Documents as d
	where d.CurrentDocumentVersionId = @DocumentVersionId

	-- create the transfer services if any
	insert into dbo.CustomDocumentTransferServices
	        (
	         DocumentVersionId,
	         AuthorizationCodeId
	        )
	select dv.DocumentVersionId,
	sv.TransferService
	from @tDocumentVersions as dv
	cross join dbo.CustomDocumentAssessmentTransferServices as sv
	where sv.DocumentVersionId = @DocumentVersionId
	and ISNULL(sv.RecordDeleted, 'N') <> 'Y'

	select @newDocumentId = d.DocumentId, @ClientId = d.ClientId
	from @tDocuments as td
	join dbo.Documents as d on d.DocumentId = td.DocumentId

	exec dbo.csp_CustomDocumentReferralTransferAlert @DocumentId = @newDocumentId, -- int
		@ClientId = @ClientId, -- int
		@RecipientStaffId = @ReceivingStaffId, -- int
		@Subject = 'New Transfer Document Sent', -- varchar(700)
		@Message = 'A new transfer document has been sent and is awaiting your response.  Click the document reference link to edit to respond.' -- varchar(3000)

end

-- if this is an "initial" assessment, set the primary clinician to the author of the document
if exists (select * from dbo.CustomDocumentDiagnosticAssessments where DocumentVersionId = @DocumentVersionid and InitialOrUpdate = 'I')
begin
	

	update c set
		PrimaryClinicianId = d.AuthorId
	from dbo.Clients as c
	join dbo.Documents as d on d.ClientId = c.ClientId
	where d.CurrentDocumentVersionId = @DocumentVersionid
end
-- if this is an "initial" assessment, and diagnosis records exist, create the diagnosis document
--if exists (select * from dbo.CustomDocumentDiagnosticAssessments where DocumentVersionId = @DocumentVersionid and InitialOrUpdate = 'I')
--	and exists (select * from dbo.DocumentDiagnosis as dx where dx.DocumentVersionId = @DocumentVersionId and ISNULL(dx.RecordDeleted, 'N') <> 'Y')
--begin
--	-- create the diagnosis document
--	-- Documents
--	delete from @tDocuments
--	delete from @tDocumentVersions

--    insert  into dbo.Documents
--            (
--             ClientId,
--             DocumentCodeId,
--             EffectiveDate,
--             Status,
--             AuthorId,
--             DocumentShared,
--             SignedByAuthor,
--             SignedByAll
	        
--            )
--    output  inserted.DocumentId
--            into @tDocuments (DocumentId)
--            select  d.ClientId,
--                    @constDocumentCodeDiagnosis,
--                    d.EffectiveDate,
--                    @constDocumentSigned,
--                    d.AuthorId,
--                    'Y',
--                    'Y',
--                    'Y'
--            from    dbo.Documents as d
--            where   d.CurrentDocumentVersionId = @DocumentVersionId
		
--	-- DocumentVersions
--    insert  into dbo.DocumentVersions
--            (
--             DocumentId,
--             Version,
--             AuthorId,
--             EffectiveDate,
--             RevisionNumber
	        
--            )
--    output  inserted.DocumentVersionId
--            into @tDocumentVersions (DocumentVersionId)
--            select  td.DocumentId,
--                    1,
--                    d.AuthorId,
--                    d.EffectiveDate,
--                    1
--            from    @tDocuments as td
--            join    dbo.Documents as d on d.DocumentId = td.DocumentId
		
--	-- Link the new documentversionid back to the document
--    update  d
--    set
--			CurrentDocumentVersionId = tdv.DocumentVersionId,
--			InProgressDocumentVersionId = tdv.DocumentVersionId,
--			CurrentVersionStatus = @constDocumentSigned
--    from    Documents as d
--    join    @tDocuments as td on td.DocumentId = d.DocumentId
--    cross join @tDocumentVersions as tdv
		
--	-- DocumentSignatures
--    insert  into dbo.DocumentSignatures
--            (
--             DocumentId,
--             StaffId,
--             SignatureOrder,
--             SignedDocumentVersionId,
--             SignerName,
--             SignatureDate
	        
--            )
--            select  td.DocumentId,
--                    ds.StaffId,
--                    ds.signatureOrder,
--                    tdv.DocumentVersionid,
--                    ds.SignerName,
--					GETDATE()
--            from    @tDocuments as td
--            join    dbo.Documents as d on d.DocumentId = td.DocumentId
--            cross join @tDocumentVersions as tdv
--            cross join dbo.DocumentVersions as dv
--            join dbo.DocumentSignatures as ds on ds.SignedDocumentVersionId = dv.DocumentVersionId
--            where dv.DocumentVersionId = @DocumentVersionId
			
--	-- Create the actual custom Document
--	insert into dbo.DocumentDiagnosis
--	        (
--	         DocumentVersionId,
--	         ScreeeningTool,
--			 OtherMedicalCondition,
--			 FactorComments,
--			 GAFScore,
--			 WHODASScore,
--			 CAFASScore,
--			 NoDiagnosis
--	        )
--	select  dv.DocumentVersionId,
--	         dx.ScreeeningTool,
--			 dx.OtherMedicalCondition,
--			 dx.FactorComments,
--			 dx.GAFScore,
--			 dx.WHODASScore,
--			 dx.CAFASScore,
--			 dx.NoDiagnosis
--	from @tDocumentVersions as dv
--	cross join dbo.DocumentDiagnosis as dx
--	where dx.DocumentVersionId = @DocumentVersionId
--	and ISNULL(dx.RecordDeleted, 'N') <> 'Y'

--	insert into dbo.DocumentDiagnosisCodes
--	        (
--	         DocumentVersionId,
--	         ICD10CodeId,
--			 ICD10Code,
--			 ICD9Code,
--			 DiagnosisType,
--			 RuleOut,
--			 Billable,
--			 Severity,
--			 DiagnosisOrder,
--			 Specifier,
--			 Remission,
--			 Source,
--			 Comments,
--			 SNOMEDCODE
--	        )
--	select  dv.DocumentVersionId,
--		     dx.ICD10CodeId,
--			 dx.ICD10Code,
--			 dx.ICD9Code,
--			 dx.DiagnosisType,
--			 dx.RuleOut,
--			 dx.Billable,
--			 dx.Severity,
--			 dx.DiagnosisOrder,
--			 dx.Specifier,
--			 dx.Remission,
--			 dx.Source,
--			 dx.Comments,
--			 dx.SNOMEDCODE
--	from @tDocumentVersions as dv
--	cross join dbo.DocumentDiagnosisCodes as dx
--	where dx.DocumentVersionId = @DocumentVersionId
--	and ISNULL(dx.RecordDeleted, 'N') <> 'Y'

--	insert into dbo.DocumentDiagnosisFactors
--	        (
--	         DocumentVersionId,
--	         FactorId
--	        )
--	select  dv.DocumentVersionId,
--		dx.FactorId
--	from @tDocumentVersions as dv
--	cross join dbo.DocumentDiagnosisFactors as dx
--	where dx.DocumentVersionId = @DocumentVersionId
--	and ISNULL(dx.RecordDeleted, 'N') <> 'Y'

--end
-- if this is an "initial" assessment, and goals exist, create the initial treatment plan
if exists (select * from dbo.CustomDocumentDiagnosticAssessments where DocumentVersionId = @DocumentVersionid and InitialOrUpdate = 'I')
	and exists (select * from dbo.CustomTPGoals as tpg where tpg.DocumentVersionId = @DocumentVersionId and LEN(LTRIM(RTRIM(ISNULL(tpg.GoalText, '')))) > 0 and ISNULL(tpg.RecordDeleted, 'N') <> 'Y')
begin
	-- create the initial treatment plan
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
                    @constDocumentCodeTreatmentPlanInitial,
                    d.EffectiveDate,
                    @constDocumentSigned,
                    d.AuthorId,
                    'Y',
                    'Y',
                    'Y'
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
	insert into dbo.CustomTreatmentPlans
	        (
	         DocumentVersionId,
	         CurrentDiagnosis,
	         ClientStrengths,
	         DischargeTransitionCriteria,
	         ClientParticipatedAndIsInAgreement
	        )
	select  dv.DocumentVersionId,
	da.CurrentDiagnosis,
	da.ClientStrengths,
	da.DischargeTransitionCriteria,
	da.ClientParticipatedAndIsInAgreement
	from @tDocumentVersions as dv
	cross join dbo.CustomTreatmentPlans as da
	where da.DocumentVersionId = @DocumentVersionId

         

	declare @tCustomTPGoalMap table (
		OldGoalId int,
		NewGoalId int
	)
	declare @OldGoalId int
	
	declare cGoals insensitive cursor for
	select TPGoalId
	from dbo.CustomTPGoals
	where DocumentVersionId = @DocumentVersionId
	and ISNULL(RecordDeleted, 'N') <> 'Y'
	
	open cGoals
	
	fetch cGoals into @OldGoalId
	
	while @@fetch_status = 0
	begin
		-- create the new tp goals and save a map back to the old ones
		insert into dbo.CustomTPGoals
				(
				 DocumentVersionId,
				 GoalNumber,
				 GoalText,
				 TargeDate,
				 Active,
				 ProgressTowardsGoal,
				 DeletionNotAllowed
				)
		output @OldGoalId, inserted.TPGoalId into @tCustomTPgoalMap (OldGoalId, NewGoalId)
		select dv.DocumentVersionId,
		g.GoalNumber,
		g.GoalText,
		g.TargeDate,
		ISNULL(g.Active, 'Y'),
		g.ProgressTowardsGoal,
		g.DeletionNotAllowed
		from @tDocumentVersions as dv
		cross join dbo.CustomTPGoals as g
		where g.TPGoalId = @OldGoalId
	
		fetch cGoals into @OldGoalId
	end
	
	close cGoals
	
	deallocate cGoals
	
	-- Create goal needs
	insert into dbo.CustomTPGoalNeeds
	        (
	         TPGoalId,
	         NeedId,
	         DateNeedAddedToPlan
	        )
	select n.NewGoalId,
	o.NeedId,
	o.DateNeedAddedToPlan
	from @tCustomTPGoalMap as n
	join dbo.CustomTPGoalNeeds as o on o.TPGoalId = n.OldGoalId
	where ISNULL(o.RecordDeleted, 'N') <> 'Y'
	
	-- create objectives
	insert into dbo.CustomTPObjectives
	        (
	         TPGoalId,
	         ObjectiveNumber,
	         ObjectiveText,
	         TargetDate,
	         Status,
	         DeletionNotAllowed
	        )
	select n.NewGoalId,
	o.ObjectiveNumber,
	o.ObjectiveText,
	o.TargetDate,
	o.Status,
	o.DeletionNotAllowed
	from @tCustomTPGoalMap as n
	join CustomTPObjectives as o on o.TPGoalId = n.OldGoalId
	where ISNULL(o.RecordDeleted, 'N') <> 'Y'

	insert into dbo.CustomTPServices 
	        (
	         TPGoalId,
	         ServiceNumber,
	         AuthorizationCodeId,
	         Units,
	         FrequencyType,
	         Status,
	         DeletionNotAllowed
	        )
	select n.NewGoalId,
	o.ServiceNumber,
	o.AuthorizationCodeId,
	o.Units,
	o.FrequencyType,
	o.Status,
	o.DeletionNotAllowed
	from @tCustomTPGoalMap as n
	join dbo.CustomTPServices as o on o.TPGoalId = n.OldGoalId
	where ISNULL(o.RecordDeleted,'N') <> 'Y'


end

commit tran
end try
begin catch

if @@TRANCOUNT > 0 rollback tran

declare @errorMessage nvarchar(4000)
set @errorMessage = ERROR_MESSAGE()

raiserror(@errorMessage, 16, 1)

end catch


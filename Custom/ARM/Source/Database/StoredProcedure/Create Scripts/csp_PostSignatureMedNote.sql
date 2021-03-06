/****** Object:  StoredProcedure [dbo].[csp_PostSignatureMedNote]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PostSignatureMedNote]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_PostSignatureMedNote]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PostSignatureMedNote]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'





CREATE procedure [dbo].[csp_PostSignatureMedNote]
	@ScreenKeyId int,
	@StaffId int,
	@CurrentUser varchar(30),
	@CustomParameters xml
/****************************************************************/
-- PROCEDURE: csp_PostSignatureMedNote
-- PURPOSE: Post med note signature events.
-- CALLED BY: SmartCare on post-update (signature)
-- REVISION HISTORY:
--		2011.10.02 - T. Remisoski - Created.
--      2012.12.07 - S. Stevens   - Make sure the med note diagnosis data does not match existing diagnosis
--                                  before creating.  Uses the csf_DiagnosesMatch function.
/****************************************************************/

as

begin try
begin tran

declare @DocumentVersionId int
select @DocumentVersionId = CurrentDocumentVersionId from Documents where DocumentId = @ScreenKeyId

-- CONSTANTS
declare @constDocumentInProgress int = 21
declare @constDocumentSigned int = 22
declare @constDocumentCodeDiagnosis int = 5


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
	

-- create diagnosis
-- if diagnosis records exist, create the diagnosis document
if exists (select * from dbo.DiagnosesIAndII as dx where dx.DocumentVersionId = @DocumentVersionId and ISNULL(dx.RecordDeleted, ''N'') <> ''Y'')
begin

  --
  -- Check to see if changes were made to the diagnosis - do not create if the med not did not change the overall diagnosis
  declare @ClientId_5 int 
  declare @DocumentVersionId_5 int  
  declare @DiagnosisMatch bit
  declare @False bit = 0
  
  Select @ClientID_5 = ClientID from dbo.Documents as d join dbo.DocumentVersions as dv
   on dv.documentid = d.documentid
   where dv.DocumentVersionId = @DocumentVersionId;
   
  set @DocumentVersionId_5 = (select top 1 CurrentDocumentVersionId from dbo.documents
   where DocumentCodeId = 5
   and ClientId = @ClientId_5
   and ISNULL(recorddeleted,''N'') <> ''Y''
   and Status = 22
   order by EffectiveDate desc,
            DocumentId desc)
  
  set @DiagnosisMatch = dbo.csf_DiagnosesMatch(@DocumentVersionId, @DocumentVersionId_5)
  If  @DiagnosisMatch = @False 
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
			@msgSubject = ''Diagnosis updated based on results of medication revew.'', -- varchar(700)
			@msgBody = ''Diagnosis updated based on results of medication review.'', -- varchar(3000)
			@DocumentReference = @NotificationReference

  end
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

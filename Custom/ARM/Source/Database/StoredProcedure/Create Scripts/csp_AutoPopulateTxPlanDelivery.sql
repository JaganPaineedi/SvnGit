/****** Object:  StoredProcedure [dbo].[csp_AutoPopulateTxPlanDelivery ]    Script Date: 06/19/2013 17:49:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_AutoPopulateTxPlanDelivery ]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_AutoPopulateTxPlanDelivery ]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_AutoPopulateTxPlanDelivery ]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[csp_AutoPopulateTxPlanDelivery ]
/*******************************************************************************      
**  Change History      
*******************************************************************************      
**  Date:			Author:    Description:      
**  --------		--------    ----------------------------------------------------      
	02/15/2011		dharvey		Replaced EffectiveDate with Signature Date on the 
								Documents table insert so that the DateOfService
								and EffectiveDate of the new TxPlanDelivery match.
								Also extended EndDateOfService to properly reflect
								units in minutes.
*******************************************************************************/    

	@DocumentVersionId int
	
as

Declare @TxPlanDeliveredProcedureCodeId int
Declare @TxPlanDeliveredProgramId int
Declare @TxPlanDeliveredLocationId int
Declare @NewDocumentId int
Declare @NewServiceId int
Declare @NewDocumentVersionId int
Declare @OrigDocumentEffectiveDate datetime

set @TxPlanDeliveredProcedureCodeId = 814
set @TxPlanDeliveredProgramId = 32
set @TxPlanDeliveredLocationId = null

select @OrigDocumentEffectiveDate = d.EffectiveDate
From Documents d 
where d.CurrentDocumentVersionId = @DocumentVersionId


Insert into Services
(ClientId, ProcedureCodeid, DateOfService, EndDateOfService
	, Unit, UnitType, Status, ClinicianId, ProgramId, LocationId
	, Billable, ClientWasPresent, AuthorizationsNeeded, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
Select 
d.Clientid, @TxPlanDeliveredProcedureCodeId, ds.SignatureDate, dateadd(mi,1,ds.SignatureDate)
	, 1, 113, 71, d.AuthorId,  @TxPlanDeliveredProgramId, @TxPlanDeliveredLocationId
	, ''N'', ''N'', 0, ''TxPlanDelivery'', getdate(), ''TxPlanDelivery'', getdate()
from Documents d
join DocumentSignatures ds on ds.DocumentId = d.DocumentId and ds.StaffId = d.AuthorId
Where d.CurrentDocumentVersionId = @DocumentVersionId
and isnull(d.RecordDeleted, ''N'')= ''N''
and isnull(ds.RecordDeleted, ''N'')= ''N''

Set @NewServiceId = @@Identity

Insert into Documents
(ClientId, DocumentCodeId, ServiceId, EffectiveDate, Status, AuthorId, SignedByAuthor, SignedByAll)
Select d.ClientId, 115, @NewServiceId, dbo.RemoveTimeStamp(ds.SignatureDate), 21, d.AuthorId, ''N'', ''N''
From Documents d
join DocumentSignatures ds on ds.DocumentId = d.DocumentId and ds.StaffId = d.AuthorId
Where d.CurrentDocumentVersionId = @DocumentVersionId
and isnull(d.RecordDeleted, ''N'')= ''N''
and isnull(ds.RecordDeleted, ''N'')= ''N''

Set @NewDocumentId = @@Identity


Insert into DocumentVersions
(DocumentId, Version)
Values (@NewDocumentId, 1)

Set @NewDocumentVersionId = @@Identity

update d
set CurrentDocumentVersionId = @NewDocumentVersionId
from Documents d
where DocumentId = @NewDocumentId

Insert into DocumentSignatures
(DocumentId, SignedDocumentVersionId, StaffId, SignerName, SignatureOrder)
Select @NewDocumentId, @NewDocumentVersionId, d.AuthorId, s.FirstName + s.LastName + case when isnull(s.SigningSuffix, '''') <> '''' then '', '' + s.SigningSuffix else '''' end, 1
From Documents d
Join staff s on s.staffid = d.AuthorId
Where d.DocumentId = @NewDocumentId
and isnull(d.RecordDeleted, ''N'')= ''N''


Insert into CustomFieldsData
(DocumentType, PrimaryKey1, PrimaryKey2)	
Values
(4943, @NewServiceId, 0)


Insert into CustomMiscellaneousNotes
(DocumentVersionId, Narration)
Values (@NewDocumentVersionId, 
''For Treatment Plan/Addendum effective: '' +convert(varchar(20), @OrigDocumentEffectiveDate, 101) + char(13) + char(10) + char(13) + char(10)+
''Indicate below when the completed Treatment Plan/Addendum was delivered (date), to whom it was delivered (i.e., customer, specific provider, guardian, etc.), and how it was delivered (i.e., in person, mail):'' 
+ char(13) +  char(10) + char(13) +  char(10)
)
' 
END
GO

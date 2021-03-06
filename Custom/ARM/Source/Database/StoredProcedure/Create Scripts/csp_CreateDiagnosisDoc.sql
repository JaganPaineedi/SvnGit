/****** Object:  StoredProcedure [dbo].[csp_CreateDiagnosisDoc]    Script Date: 06/19/2013 17:49:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CreateDiagnosisDoc]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_CreateDiagnosisDoc]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CreateDiagnosisDoc]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[csp_CreateDiagnosisDoc](@StaffID int,@DocumentID int,@NewDocumentID int output )
as
/*

Modified ssp_SCSignatureCreateDiagnosisDoc to use current version to create new dx based on most recent Version

*/

DECLARE @TotalValues int
Set @TotalValues=0
DECLARE @CurrentDocumentVersionId int
	
Select @CurrentDocumentVersionId = d.CurrentDocumentVersionId from documents d where d.documentId = @DocumentId
DECLARE @CreatedBy varchar(30)
select @CreatedBy=CreatedBy from Documents where documentid=@DocumentID and isNull(RecordDeleted,''N'')<>''Y''
--Check there is data exists in the tables or not if exists then GoTo Label and insert a new record in the tables

IF exists(Select * from DiagnosesIAndII where DocumentVersionId=@CurrentDocumentVersionId and isNull(RecordDeleted,''N'')<>''Y'')
	GOTO NewDiagnosis

IF exists(Select * from DiagnosesIII where isNull(RecordDeleted,''N'')<>''Y'' and  DocumentVersionId=@CurrentDocumentVersionId
	AND (LTRIM(RTRIM(ISNULL(Specification,'''')))!=''''))
   GOTO NewDiagnosis

IF exists(Select * from DiagnosesIIICodes where isNull(RecordDeleted,''N'')<>''Y'' and  DocumentVersionId=@CurrentDocumentVersionId) 
   GOTO NewDiagnosis


IF exists(Select * from DiagnosesIV where isNull(RecordDeleted,''N'')<>''Y'' and DocumentVersionId=@CurrentDocumentVersionId
	AND ( PrimarySupport IS NOT NULL 
	OR SocialEnvironment IS NOT NULL
	OR Educational IS NOT NULL
	OR Occupational IS NOT NULL
	OR Housing  IS NOT NULL 
	OR Economic IS NOT NULL 
	OR HealthcareServices IS NOT NULL 
	OR Legal IS NOT NULL 
	OR Other IS NOT NULL
	OR LTRIM(RTRIM(ISNULL(Specification,'''')))!=''''))
  GOTO NewDiagnosis

IF exists(Select * from DiagnosesV where isNull(RecordDeleted,''N'')<>''Y'' and DocumentVersionId=@CurrentDocumentVersionId AND ISNULL(AxisV,'''')!='''')
	GOTO NewDiagnosis

RETURN(0)

NewDiagnosis:

	DECLARE @NewDocumentVersionId int

	BEGIN TRAN

--create table temptable1(DocumentID int) 
	insert into documents(ClientId,ServiceId,DocumentCodeId,EffectiveDate,DueDate,Status,AuthorId, CreatedBy,ModifiedBy,SignedByAuthor,DocumentShared) select ClientId,NULL,5,EffectiveDate,DueDate,22,AuthorId,CreatedBy,ModifiedBy,''Y'',''Y'' from documents where documentid=@DocumentID and isNull(RecordDeleted,''N'')<>''Y''

	IF @@error <> 0 GOTO error
	
	set @NewDocumentId =@@identity
	--insert into temptable1 values(@varNewDocId)
--	set @NewDocumentID= @varNewDocId
	
	insert into  documentVersions(DocumentId,Version,CreatedBy,ModifiedBy) values(@NewDocumentId ,1,@CreatedBy,@CreatedBy)
	IF @@error <> 0 GOTO error

	set @NewDocumentVersionId =@@identity
	
	update d
	set CurrentDocumentVersionId = @NewDocumentVersionId
	from Documents d
	where DocumentId = @NewDocumentID
	IF @@error <> 0 GOTO error

	insert into DiagnosesIAndII(DocumentVersionId,Axis,DSMCode,DSMNumber,DiagnosisType,RuleOut,Billable,Severity,DSMVersion,Diagnosisorder,Specifier,CreatedBy,ModifiedBy) select @NewDocumentVersionId,Axis,DSMCode,DSMNumber,DiagnosisType,RuleOut,Billable,Severity,DSMVersion,Diagnosisorder,Specifier,CreatedBy,ModifiedBy from DiagnosesIAndII where DocumentVersionId=@CurrentDocumentVersionId and isNull(RecordDeleted,''N'')<>''Y''
	IF @@error <> 0 GOTO error

	insert into DiagnosesIII ([DocumentVersionId], [Specification],CreatedBy,ModifiedBy) select @NewDocumentVersionId, [Specification],CreatedBy,ModifiedBy  from DiagnosesIII where  DocumentVersionId=@CurrentDocumentVersionId and isNull(RecordDeleted,''N'')<>''Y''
	IF @@error <> 0 GOTO error

	insert into DiagnosesIIICodes (DocumentVersionId, ICDCode, Billable,CreatedBy,ModifiedBy) select @NewDocumentVersionId, ICDCode, Billable, CreatedBy,ModifiedBy  from DiagnosesIIICodes where  DocumentVersionId=@CurrentDocumentVersionId and isNull(RecordDeleted,''N'')<>''Y''
	IF @@error <> 0 GOTO error

	insert into DiagnosesIV ([DocumentVersionId],  [SocialEnvironment],  [Housing], [Economic], [HealthcareServices], [Legal], [Other], [Specification] , [PrimarySupport], [Educational], [Occupational],CreatedBy,ModifiedBy ) select @NewDocumentVersionId, [SocialEnvironment],  [Housing], [Economic], [HealthcareServices], [Legal], [Other], [Specification] , [PrimarySupport], [Educational], [Occupational],CreatedBy,ModifiedBy from DiagnosesIV where DocumentVersionId=@CurrentDocumentVersionId and isNull(RecordDeleted,''N'')<>''Y''
	IF @@error <> 0 GOTO error

	Insert into DiagnosesV ([DocumentVersionId], [AxisV],CreatedBy,ModifiedBy) select @NewDocumentVersionId,AxisV,CreatedBy,ModifiedBy from DiagnosesV where DocumentVersionId=@CurrentDocumentVersionId and isNull(RecordDeleted,''N'')<>''Y''
	IF @@error <> 0 GOTO error


	/*Commented and modified by Shifali in ref to remove RowIdentifier,ExternalReferenceId columns from DocumentSignatures tabe as per new DM Change*/
	--INSERT INTO DocumentSignatures (DocumentId,SignedDocumentVersionId,StaffId,ClientId,IsClient,SignerName,SignatureOrder,SignatureDate,VerificationMode,PhysicalSignature,DeclinedSignature,ClientSignedPaper,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate) select @NewDocumentID,@NewDocumentVersionId,StaffId,ClientId,IsClient,SignerName,SignatureOrder,SignatureDate,VerificationMode,PhysicalSignature,DeclinedSignature,ClientSignedPaper,newID(),NULL,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate from DocumentSignatures where DocumentID=@DocumentID and SignatureOrder=1 and isNull(RecordDeleted,''N'')<>''Y''
	INSERT INTO DocumentSignatures (DocumentId,SignedDocumentVersionId,StaffId,ClientId,IsClient,SignerName,SignatureOrder,SignatureDate,VerificationMode,PhysicalSignature,DeclinedSignature,ClientSignedPaper,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate) select @NewDocumentID,@NewDocumentVersionId,StaffId,ClientId,IsClient,SignerName,SignatureOrder,SignatureDate,VerificationMode,PhysicalSignature,DeclinedSignature,ClientSignedPaper,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate from DocumentSignatures where DocumentID=@DocumentID and SignatureOrder=1 and isNull(RecordDeleted,''N'')<>''Y''

	IF @@error <> 0 GOTO error
--SELECT   * FROM DocumentS where DocumentCodeID=101 and ClientID=98 order by 1  ignatures where SignatureDate is NULL

	Commit tran
	--rollback tran

RETURN(0)
error:
	rollback tran
	RAISERROR(''Error in ssp_SignatureCreateDiagnosisDoc procedure'', 16, 1)
' 
END
GO

IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'ssp_MoveSignedDocs')
                    AND type IN ( N'P', N'PC' ) )
					begin
					drop procedure ssp_MoveSignedDocs
					end
go

create procedure ssp_MoveSignedDocs
 @DocumentId int,
@NewClientId int,
@ExecutedByStaffId int,
@MoveSignedDocumentLogId int output
/*******************************************************************
* Filename - ssp_MoveSignedDocs
* Created Date - 12/22/2015
* Created By - Jcarlson
* Purpose - To move a document from one client to another
* Input Parameters - @DocumentId int : Document to move
*				   - @NewClientId int : Client to move document to
*				   - @ExecutedByStaffId int : Staff who moved the document
* OutPut Parameters - @MoveSignedDocumentLogId : The primary key of the log record that was created to track changes
* Called By - ssp_RDLMoveSignedDocs
* Change Log History
* Date			Modified By       Reason
* 12/22/2015	jcarlson		  created
********************************************************************/
as
begin try
begin transaction

Declare @errorMessage varchar(max)
/**********************************************************************
*	Do not allow document codes that are service notes, attached to services, status other then signed, current version <> inprogress version,
*		clientid does not exists, clientid not active... to be moved 
**********************************************************************/
if not exists (
				select 1 from dbo.Documents d
				where d.DocumentId = @DocumentId
				and isnull(d.RecordDeleted,'N')='N'
				)
begin
	select @errorMessage = 'This Document Id entered does not exist or this document has been record deleted.'
	raiserror(@errorMessage,16,1)
return
end

if not exists (
				select 1 from dbo.Clients c
				where c.ClientId = @NewClientId
				and isnull(c.RecordDeleted,'N')='N'
			  )
begin
	select @errorMessage = 'The client Id entered does not exist or it has been record deleted.'
	raiserror(@errorMessage,16,1)
end

if exists (
			select 1 from dbo.Clients c
			where c.ClientId = @NewClientId
			and isnull(c.RecordDeleted,'N')='N'
			and c.Active = 'N'
		  )
begin
	select @errorMessage = 'The client selected is inactive, this process cannot move documents to inactive clients.'
	raiserror(@errorMessage,16,1)
end

if exists (
			Select 1 From dbo.Documents d 
			join dbo.DocumentCodes dc on d.DocumentCodeId = dc.DocumentCodeId
			and isnull(dc.RecordDeleted,'N')='N'
			and isnull(dc.ServiceNote,'N') ='Y' 
			where d.DocumentId = @DocumentId
			and isnull(d.RecordDeleted,'N')='N'
		   )
begin
	select @errorMessage = 'This process cannot move documents that are service notes.'
	raiserror(@errorMessage,16,1)
end

if exists (
			Select 1 From dbo.Documents d 
			where d.DocumentId = @DocumentId
			and isnull(d.RecordDeleted,'N')='N'
			and d.ServiceId is not null
		   )
begin
	select @errorMessage = 'This process cannot move documents that are associated to a service.'
	raiserror(@errorMessage,16,1)
end

if exists (
			select 1 from dbo.Documents d
			where d.DocumentId = @DocumentId
			and isnull(d.RecordDeleted,'N')='N'
			and ( ( d.[Status] <> 22 ) or ( d.CurrentVersionStatus <> 22 ) ) 
			--22 means siqned
		  )
begin
	select @errorMessage = 'This process cannot move documents that have a status other then "signed"'
	raiserror(@errorMessage,16,1)
return

end

if exists (
			select 1 from dbo.Documents d
			where d.DocumentId = @DocumentId
			and isnull(d.RecordDeleted,'N')='N'
			and d.CurrentDocumentVersionId <> d.InProgressDocumentVersionId
		  )
begin
	select @errorMessage = 'This process cannot move documents where the current document version is not the same as the in progress document version.'
	raiserror(@errorMessage,16,1)

return

end

/**********************************************************************
*							Declare Variables
**********************************************************************/
declare @OrgDocumentInfo varchar(max)
declare @OrgDocumentSignatureInfo varchar(max)
declare @RecodeCategoryId int 
declare @RecodeId int
Declare @DocumentVersionViewsLocation varchar(max)
Declare @ReportServerConnectionInfo varchar(max)

/**********************************************************************
*							Init Variables
*				Grab All Orginal Values in Document
**********************************************************************/
select @RecodeCategoryId = rc.RecodeCategoryId
From dbo.RecodeCategories rc
where rc.CategoryName= 'MoveSignedDocumentIdException'
and isnull(rc.RecordDeleted,'N')='N'

--Orginal Document Values
select @OrgDocumentInfo = STUFF((Select distinct ', ' + 'Original ClientId: ' + isnull(QUOTENAME(d.ClientId),'') + ', ' + CHAR(13) + Char(10) 
								+ 'Original Status: ' + isnull(QUOTENAME(d.[Status]),'') + ', ' + CHAR(13) + Char(10) 
								+ 'Original Current Document Version: ' + isnull(QUOTENAME(d.CurrentDocumentVersionId),'') + ', ' + CHAR(13) + Char(10) 
								+ 'Original InProgress Document Version: ' + isnull(QUOTENAME(d.InProgressDocumentVersionId),'') + ', ' + CHAR(13) + Char(10) 
								+ 'Original Current Version Status: ' + isnull(QUOTENAME(d.CurrentVersionStatus),'') 
								 From dbo.Documents d
								 where d.DocumentId = @DocumentId
								 and isnull(d.RecordDeleted,'N')='N'
								 FOR XML PATH(''), type).value('.','varchar(max)'),1,1,'')

--Orginal Document Signature Values
select @OrgDocumentSignatureInfo = coalesce(@OrgDocumentSignatureInfo + ', ' , '')  + 'Original Signed Document VersionId: '  + isnull(QUOTENAME(ds.SignedDocumentVersionId),'') + ', ' + CHAR(13) + Char(10) 
														+ 'Original Signature Date: ' + isnull(QUOTENAME(ds.SignatureDate),'') + ', ' + CHAR(13) + Char(10) 
														+ 'Original Verification Mode: ' + isnull(QUOTENAME(ds.VerificationMode),'') + ', ' + CHAR(13) + Char(10) 
														+ 'Original Physcial Signature: '+ isnull(convert(varchar(max),converT(varbinary(max),ds.PhysicalSignature)),'') + ', ' + CHAR(13) + Char(10) 
													    + 'Original Declined Signature: '+ isnull(QUOTENAME(ds.DeclinedSignature),'') + ', ' + CHAR(13) + Char(10) 
														+ 'Original Revision Number: '+ isnull(QUOTENAME(ds.RevisionNumber),'') + ', ' + CHAR(13) + Char(10) 
														+ 'Original Reason For Decline: '+ isnull(QUOTENAME(ds.ReasonForDecline),'') + CHAR(13)+Char(10)
														+ 'Original Client Id: ' + isnull(QUOTENAME(ds.ClientId),'') + CHAR(13)+Char(10)
														+ 'Document Signature Id: ' + isnull(QUOTENAME(ds.SignatureId),'')
														From dbo.DocumentSignatures ds
														where ds.DocumentId = @DocumentId
														--and isnull(ds.RecordDeleted,'N')='N' --maybe grab all even record deleted ones just for consistency, leave them record deleted tho


/**********************************************************************
*				Exit if we cannot find a value for each variable
**********************************************************************/
if @RecodeCategoryId is null or len(ltrim(rtrim(isnull(@RecodeCategoryId,'')))) = 0
Begin
	select @errorMessage = 'Cannot find MoveSignedDocumentIdException recode category'
	Raiserror(@errorMessage,16,1)
	return
end

if @OrgDocumentInfo is null or len(ltrim(rtrim(isnull(@OrgDocumentInfo,'')))) = 0
begin
	select @errorMessage = 'Unable to grab Original document information.'
	raiserror(@errorMessage,16,1)
	return 
end
if @OrgDocumentSignatureInfo is null or len(ltrim(rtrim(isnull(@OrgDocumentSignatureInfo,'')))) = 0
and exists (Select 1 from dbo.DocumentSignatures ds where ds.DocumentId = @DocumentId )
begin
	select @errorMessage = 'Unable to grab Original document signatures information.'
	raiserror(@errorMessage,16,1)
	return
end

/**********************************************************************
* Temp insert the documents documentid so we can change the document from signed to inprogress
* without the documents table trigger stopping us
**********************************************************************/
insert into dbo.Recodes (createdby,IntegerCodeId,CodeName,RecodeCategoryId)
values 
('ChangeDocClientId',@DocumentId,'Temp',@RecodeCategoryId)
--grab the Id so we can remove it later
set @RecodeId = scope_Identity();


if @RecodeId is null or len(ltrim(rtrim(isnull(@RecodeId,'')))) = 0
	begin
		select @errorMessage = 'Unexpected error occured when inserting Document Id into recode category.'
		raiserror(@errorMessage,16,1)
	return
end

/**********************************************************************
*					Update document with new values
**********************************************************************/
update d
set d.ClientId = @NewClientId,
	d.[Status] = 21, --in progress
	d.SignedByAuthor = 'N',
	d.SignedByAll = 'N',
	d.ToSign = 'Y',
	d.CurrentVersionStatus = 21, --in progress
	d.ModifiedBy = 'ChangeDocClientId',
	d.ModifiedDate = getDate()
From dbo.Documents d
where d.DocumentId = @DocumentId
and isnull(d.RecordDeleted,'N')='N'

/**********************************************************************
*			Update document signatures with new ClientId
**********************************************************************/
update ds
set ds.ClientId = @NewClientId,
	ds.ModifiedBy = 'ChangeDocClientId',
	ds.ModifiedDate = getDate()
from dbo.DocumentSignatures ds
where ds.DocumentId = @DocumentId
and isnull(ds.IsClient,'N')='Y' --only client signature records ,,do this to all even record deleted ones for consistency

/**********************************************************************
*	Update all signatures for this document to unsigned
**********************************************************************/
update ds
set ds.SignedDocumentVersionId = null,
 ds.SignatureDate = null,
 ds.PhysicalSignature = null,
 ds.VerificationMode = null,
 ds.ModifiedBy = 'ChangeDocClientId',
 ds.ModifiedDate = getDate()
From dbo.DocumentSignatures ds
where ds.DocumentId = @DocumentId

/**********************************************************************
*Remove All Document Version Views for every Version of this document
**********************************************************************/
---find the database where the version views are located
declare @LinkedServer varchar(max)
select @LinkedServer = ck.Value
from dbo.SystemConfigurationKeys ck
where ck.[Key] = 'DocumentVersionViewsLinkedServer'
and isnull(ck.RecordDeleted,'N')='N'

declare @sql varchar(max)

if @LinkedServer is null or len(ltrim(rtrim(isnull(@LinkedServer,'')))) = 0
begin
--look for configuration key that has value, otherwise parse report server connection string to find database name
		 select @ReportServerConnectionInfo = reportserverconnection from dbo.SystemConfigurations

		 --parse out the db name where document version views are stored in the report server configuration field in systemconfigurations
		select @DocumentVersionViewsLocation = item
		From dbo.fnsplitwithindex((select item from dbo.fnsplitwithindex(@ReportServerConnectionInfo,';') where [index] = 1
		),'=') where [index] = 1 

		--if the location is different from the current db then build the string to delete from dvv
			if @DocumentVersionViewsLocation <>  DB_NAME()
			begin
					
					select @sql = 'delete from dvv
				from '+ @DocumentVersionViewsLocation + '.dbo.DocumentVersionViews dvv
				Join dbo.DocumentVersions dv on dvv.DocumentVersionId = dv.DocumentVersionId
				Join dbo.Documents d on dv.DocumentId = d.DocumentId
				and d.DocumentId = @DocumentId
				and isnull(d.RecordDeleted,''N'')=''N'''

				exec(@sql)
					
			end
			else
			--if the location of dvv is the same as current dv run this
			begin
				delete from dvv
				from dbo.DocumentVersionViews dvv
				Join dbo.DocumentVersions dv on dvv.DocumentVersionId = dv.DocumentVersionId
				Join dbo.Documents d on dv.DocumentId = d.DocumentId
				and d.DocumentId = @DocumentId
				and isnull(d.RecordDeleted,'N')='N'
			end
end
else
			begin
				--if there is a configuration key use that location and build the statement
					
					select @sql = 'delete from dvv
					from '+ @LinkedServer + '.dbo.DocumentVersionViews dvv
					Join dbo.DocumentVersions dv on dvv.DocumentVersionId = dv.DocumentVersionId
					Join dbo.Documents d on dv.DocumentId = d.DocumentId
					and d.DocumentId = @DocumentId
					and isnull(d.RecordDeleted,''N'')=''N'''

					exec(@sql)
			end


/**********************************************************************
*	Remove the documentid from the MoveSignedDocumentIdException recode category
*						maybe record delete instead?
**********************************************************************/
delete from r
from dbo.Recodes r
where r.RecodeId = @RecodeId
and isnull(r.RecordDeleted,'N')='N'


/**********************************************************************
*	Grab all the new Values 
**********************************************************************/
declare @CurrentDocumentInfo varchar(max), @CurrentDocumentSignatureInfo varchar(max)
--Current Document Values
select @CurrentDocumentInfo = STUFF((Select distinct ', ' + 'Current ClientId: ' + isnull(QUOTENAME(d.ClientId),'') + ', ' + CHAR(13) + Char(10) 
								+ 'Current Status: ' + isnull(QUOTENAME(d.[Status]),'') + ', '+ CHAR(13) + Char(10) 
								+ 'Current Current Document Version: ' + isnull(QUOTENAME(d.CurrentDocumentVersionId),'') + ', ' + CHAR(13) + Char(10) 
								+ 'Current InProgress Document Version: ' + isnull(QUOTENAME(d.InProgressDocumentVersionId),'') + ', ' + CHAR(13) + Char(10) 
								+ 'Current Current Version Status: ' + isnull(QUOTENAME(d.CurrentVersionStatus),'')
								 From dbo.Documents d
								 where d.DocumentId = @DocumentId
								 and isnull(d.RecordDeleted,'N')='N'
								 FOR XML PATH(''), type).value('.','varchar(max)'),1,1,'')

--New Document Signature Values
select @CurrentDocumentSignatureInfo = coalesce(@CurrentDocumentSignatureInfo + ', ' , '') + 'Current Signed Document VersionId: '  + isnull(QUOTENAME(ds.SignedDocumentVersionId),'') + ', ' + CHAR(13) + Char(10) 
														+ 'Current Signature Date: ' + isnull(QUOTENAME(ds.SignatureDate),'') + ', ' + CHAR(13) + Char(10) 
														+ 'Current Verification Mode: ' + isnull(QUOTENAME(ds.VerificationMode),'') + ', ' + CHAR(13) + Char(10) 
														+ 'Current Physcial Signature: '+ isnull(convert(varchar(max),converT(varbinary(max),ds.PhysicalSignature)),'') + ', ' + CHAR(13) + Char(10) 
													    + 'Current Declined Signature: '+ isnull(QUOTENAME(ds.DeclinedSignature),'') + ', ' + CHAR(13) + Char(10) 
														+ 'Current Revision Number: '+ isnull(QUOTENAME(ds.RevisionNumber),'') + ', ' + CHAR(13) + Char(10) 
														+ 'Current Reason For Decline: '+ isnull(QUOTENAME(ds.ReasonForDecline),'') + CHAR(13)+Char(10)
														+ 'Current Client Id: ' + isnull(QUOTENAME(ds.ClientId),'') + CHAR(13)+Char(10)
														+ 'Document Signature Id: ' + isnull(QUOTENAME(ds.SignatureId),'')
														From dbo.DocumentSignatures ds
														where ds.DocumentId = @DocumentId
														and isnull(ds.RecordDeleted,'N')='N' --maybe move all even record deleted but leave record deleted


/**********************************************************************
*				Exit if we cannot find a value for each variable
**********************************************************************/

if @CurrentDocumentInfo is null or len(ltrim(rtrim(isnull(@CurrentDocumentInfo,'')))) = 0
	begin
		select @errorMessage = 'Unable to grab current document information.'
		raiserror(@errorMessage,16,1)
	return
end
if @CurrentDocumentSignatureInfo is null or len(ltrim(rtrim(isnull(@CurrentDocumentSignatureInfo,'')))) = 0
and exists (Select 1 from dbo.DocumentSignatures ds where ds.DocumentId = @DocumentId )
	begin
		select @errorMessage = 'Unable to grab current document signatures information.'
		raiserror(@errorMessage,16,1)
	return
end


/**********************************************************************
*	Insert everything we just did into out log table
**********************************************************************/
insert into MoveSignedDocumentsLog (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,DocumentId,OrginalDocumentInformation,CurrentDocumentInformation,NewClientId,DateMoved)
values
(@ExecutedByStaffId,getDate(),@ExecutedByStaffId,getDate(),@DocumentId,@OrgDocumentInfo + ' | ' + @OrgDocumentSignatureInfo,@CurrentDocumentInfo + ' | ' + @CurrentDocumentSignatureInfo, @NewClientId,getDate())
set @MoveSignedDocumentLogId = scope_Identity()


commit
end try

begin catch

	if @@TranCount > 0
	begin
		rollback tran
	end

	select @errorMessage = ERROR_MESSAGE() + CHAR(13)+CHAR(10) + ERROR_PROCEDURE()
	raiserror(@errorMessage,16,1)

end catch
go
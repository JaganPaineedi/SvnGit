IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'ssp_RDLMoveSignedDocs')
                    AND type IN ( N'P', N'PC' ) )
					begin
					drop procedure ssp_RDLMoveSignedDocs
					end
go

create procedure ssp_RDLMoveSignedDocs
@DocumentId int,
@NewClientId int,
@ExecutedByStaffId int
/*******************************************************************
* Filename - ssp_RDLMoveSignedDocs
* Created Date - 12/22/2015
* Created By - Jcarlson
* Purpose - To move a document from one client to another
* Input Parameters - @DocumentId int : Document to move
*				   - @NewClientId int : Client to move document to
*				   - @ExecutedByStaffId int : Staff who moved the document
* Called By - MoveSignedDocuments.rdl
* Calls - ssp_MoveSignedDocs
* Change Log History
* Date			Modified By       Reason
* 12/22/2015	jcarlson		  created
********************************************************************/
as

begin try
begin transaction
set nocount on

declare @MoveSignedDocumentLogId int
declare @errorMessage varchar(max)

declare @Results table
(
OrginalDoc varchar(max),
CurrentDoc varchaR(max),
NewClientId int
)
/**********************************************************************
*				Call MoveSignedDocs to move the docs
**********************************************************************/
if exists (
			select 1             FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'ssp_MoveSignedDocs')
                    AND type IN ( N'P', N'PC' ) 
		  )
			begin
			
				exec ssp_MoveSignedDocs @DocumentId = @DocumentId, 
					@NewClientId = @NewClientId, 
					@ExecutedByStaffId = @ExecutedByStaffId,
					@MoveSignedDocumentLogId = @MoveSignedDocumentLogId output
			---Take the PK of the Log Record and insert that into the table variable		
				insert into @Results (OrginalDoc,CurrentDoc,NewClientId)
				select a.OrginalDocumentInformation,CurrentDocumentInformation,a.NewClientId 
				from dbo.MoveSignedDocumentsLog a
				join dbo.Documents d on a.DocumentId = d.DocumentId
				and isnull(d.RecordDeleted,'N')='N'
				where a.MoveSignedDocumentsLogId = (select @MoveSignedDocumentLogId)
			end
else
			begin
				if @@TranCount > 0
				begin
					rollback tran
				end
				select @errorMessage = 'Cannot find stored procedure ssp_MoveSignedDocs'
				raiserror(@errorMessage,16,1)
				return
			end

--return data set to MoveSignedDocuments.rdl
selecT 
r.OrginalDoc,
r.CurrentDoc,
r.NewCLientId
From @Results r

set nocount off
commit
end try
begin catch
	if @@TranCount > 0
	begin
		rollback tran
	end

	select @errorMessage = ERROR_MESSAGE() + CHAR(13)+CHAR(13) + ERROR_PROCEDURE()
	raiserror(@errorMessage,16,1)
end catch
go
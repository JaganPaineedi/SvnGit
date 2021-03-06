/****** Object:  StoredProcedure [dbo].[ssp_SCPostDocumentCompleteUpdates]    Script Date: 12/21/2011 17:58:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCPostDocumentCompleteUpdates]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCPostDocumentCompleteUpdates]
GO

 CREATE PROC [dbo].[ssp_SCPostDocumentCompleteUpdates]
(
	@StaffID int,
	@DocumentID int,
	@Version int,
	@DocumentVersionId int
)                    
as                    
/*********************************************************************/                    
/* Stored Procedure: dbo.ssp_SignatureSignedStaffWithPad                */                    
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */                    
/* Creation Date:    7/24/05                                         */                    
/*                                                                   */                    
/* Purpose:  changes the status of signature and insert staff's signature in database */                    
/*                                                                   */                  
/* Input Parameters:@StaffID - StaffID                          
     @DocumentID - DocumentID                  
     @Version - Version                  
     @ClientSignedPaper - ClientSignedPaper                  
     @SignatureData - SignatureData                  
                 */                  
/*                                                                   */                    
/* Output Parameters:   None                           */                    
/*                                                                   */                    
/* Return:                                */                    
/*                                                                   */                    
/* Called By:                                                        */                    
/*                                                                   */                    
/* Calls:                                                            */                    
/*                                                                   */                    
/* Data Modifications:                                               */                    
/*                                                                   */                    
/* Updates:                                                          */                    
/*   Date     Author       Purpose   Modified  Purpose               */                    
/*  7/24/05   Kulwinder    Created   Saurabh   Transfer Document functionality Added */                    
/*  11/16/2011 Shifali Modified Ref task#11 made changes to be reviewed document status */
/*	31 Jan 2012	Sourabh		Modified to resolve status issue on complete document	*/
/*  29 Jan 2015 Arjun KR    Modified to Fix Admission Event Issue Task #205 CM to SC Env Issues Tracking. */
/*--15 December 2016 Manjunath K Modified Existing conditions to create entries into TimelineServices for all services. */
/*								 For AspenPointe-Environment Issues  #35.*/
/*13 April 2017    Manjunath K   Passing @DocumentVersinID instead of @DocumentId to ssp_SCUpdateTimeline.*/
/*								 For AspenPoite Environment Issue tracking 35.    */
/*16 May 2017 Manjunath K		 Modified Existing conditions to create entries into TimelineServices for DSM Diagnosis document as well. */
/*								 For AspenPointe-Environment Issues  #35.*/
/*********************************************************************/                   
BEGIN                  
declare @varNewDocId int                      
declare @DocumentCodeId int                    
declare @Coordinator varchar(10)                    
declare @NewDocumentID INT      
declare @FirstName varchar(100)                    
declare @LastName varchar(100)                    
declare @SigningSuffix varchar(100)
/*Added by Shifali */
DECLARE @RevisionNumber int     

SELECT @RevisionNumber = RevisionNumber FROM DocumentVersions DV
WHERE DV.DocumentVersionId = @DocumentVersionId

/*Ends here */

--Changes by Sourabh
 Declare @EventID as int  
 Declare @documentversion as int  
  
 select @documentversion = v.version ,@EventId=EventId            
 from Documents as d         
 inner join DocumentVersions V        
 on  d.CurrentDocumentVersionId=V.DocumentVersionId              
 where d.DocumentId = @DocumentId   
    
 if(@EventID > 0 and @documentversion = 1)  
 begin  
 --Update events status as completed  whenever document get signed first time   
 Update [Events] set [Status] = 2063  
 where EventId = @EventID  
 end  

--changes end here


/*commented by Shifali
--declare @DocumentVersionId int     

--Get DocumentVersionId using DocumentID,Version
--Select @DocumentVersionId=DocumentVersionId from DocumentVersions V where
--V.DocumentId=@DocumentID and V.Version=@Version  and ISNULL(V.RecordDeleted,'N')='N'
   
Changes Ends here by Shifali*/
                  
--Raman  
select @FirstName = FirstName, @LastName=LastName, @SigningSuffix=isnull(SigningSuffix,'') from Staff where StaffID = @StaffID and isnull(RecordDeleted,'N')<>'Y'                   
--By saurabh                    
select @DocumentCodeId = DocumentCodeId from Documents where Documentid = @DocumentID and isnull(RecordDeleted,'N')<>'Y'                   
 if(@DocumentCodeId=102)--Transfer Document                    
 BEGIN                    
 declare @IsFirstUser varchar(10)                    
  if exists(select CusTran.RequestingTeamCoordinator,CusTran.ReceivingTeamCoordinator from CustomTransfers CusTran             
  join Documentsignatures DocSig on DocSig.SignedDocumentVersionId = CusTran.DocumentVersionId             
  join Documents Doc on DocSig.Documentid  = Doc.Documentid            
  where CusTran.DocumentVersionId = @DocumentVersionId      
  and isnull(CusTran.RequestingDecision,'')=''             
  and isnull(CusTran.ReceivedDecision,'')=''             
  and isnull(DocSig.SignatureDate,'')=''            
  and isnull(CusTran.RecordDeleted,'N')<>'Y'             
  and isnull(Doc.RecordDeleted,'N')<>'Y'             
  and isnull(DocSig.RecordDeleted,'N')<>'Y'             
  and Doc.AuthorId = @StaffID)          
      
   select @IsFirstUser = 'True'                    
    else                    
   select @IsFirstUser = 'False'                    
                       
  if(@IsFirstUser ='True')                    
  BEGIN                    
   if Exists(select RequestingTeamCoordinator from CustomTransfers where DocumentVersionId = @DocumentVersionId 
		and isnull(RequestingTeamCoordinator,'')<>''  and isnull(RecordDeleted,'N')<>'Y')                    
   Begin                    
    select @Coordinator = RequestingTeamCoordinator from CustomTransfers where DocumentVersionId = @DocumentVersionId
		 and isnull(RequestingTeamCoordinator,'')<>'' and isnull(RecordDeleted,'N')<>'Y'                    
    Begin Transaction                    
     Update Documents set AuthorId =  @Coordinator where DocumentId = @DocumentID  and isnull(RecordDeleted,'N')<>'Y'                   
     Update CustomTransfers set SentDate1 = getdate() where DocumentVersionId = @DocumentVersionId 
		and isnull(RecordDeleted,'N')<>'Y'                    
     IF @@error <> 0 goto error                  
    Commit Transaction                     
   End                    
   else if Exists(select ReceivingTeamCoordinator from CustomTransfers where DocumentVersionId = @DocumentVersionId and isnull(ReceivingTeamCoordinator,'')<>'' and isnull(RecordDeleted,'N')<>'Y')                    
   Begin                    
    select @Coordinator = ReceivingTeamCoordinator from CustomTransfers where DocumentVersionId = @DocumentVersionId 
		and isnull(ReceivingTeamCoordinator,'')<>'' and isnull(RecordDeleted,'N')<>'Y'                    
    Begin Transaction                    
     Update Documents set AuthorId =  @Coordinator where DocumentId = @DocumentID and isnull(RecordDeleted,'N')<>'Y'                    
     Update CustomTransfers set  SentDate2 = getdate() where DocumentVersionId = @DocumentVersionId 
		and isnull(RecordDeleted,'N')<>'Y'                
  
     IF @@error <> 0 goto error                  
    Commit Transaction                     
   End                    
  End                    
  else if(@IsFirstUser ='False')              -- if not first user          
  begin     
   BEGIN TRAN      
    --Update the documentSignature Table                  
  
update documentSignatures set SignatureDate=getdate() where documentid=@DocumentID and StaffID=@StaffID and isnull(RecordDeleted,'N')<>'Y'                    
  
                     
    --Update the documents table                  
    UPDATE Documents SET DocumentShared='Y',Status=22 where  documentid=@DocumentID and AuthorID=@StaffID and isnull(RecordDeleted,'N')<>'Y'                    
     IF @@error <> 0 goto error                  
         
    if exists(select CreateAssignment from CustomTransfers where CreateAssignment = 'Y' 
		and DocumentVersionId =@DocumentVersionId and isnull(RecordDeleted,'N')<>'Y' )      
     exec ssp_SCCreateAssignmentTransfer      
     IF @@error <> 0 goto error                      
     
   COMMIT TRAN      
 end     
 END            --END Transfer Document  CODE      
 ELSE             -- IF DOCUMENTCODEID NOT 102      
 BEGIN    
	BEGIN TRAN                  
	--Update the documentSignature Table                  

	update documentSignatures set SignatureDate=getdate(),
	ModifiedDate=getdate(),
	SignerName= @FirstName + ' ' + @LastName + ' ' + case when @SigningSuffix='' then '' else ', ' + @SigningSuffix      end,
	RevisionNumber = @RevisionNumber 
    ,SignedDocumentVersionId = @DocumentVersionId      
	where documentid=@DocumentID and StaffID=@StaffID and
	isnull(RecordDeleted,'N')<>'Y'                               
	AND SignedDocumentVersionId IS NULL
	
	--Update the documents table    

	UPDATE Documents SET SignedByAuthor='N',DocumentShared='Y',Status=22 
	,CurrentVersionStatus = 22
   ,CurrentDocumentVersionId = @DocumentVersionId  
	where  documentid=@DocumentID and
	(AuthorID=@StaffID or ReviewerId=@StaffID) and isnull(RecordDeleted,'N')<>'Y'                    
		
	IF @@error <> 0 goto error                  

	--15 December 2016 Manjunath K                   
	if exists(select * from Documents D
	Inner Join DocumentCodes DC on DC.DocumentCodeId=D.DocumentCodeId
	where AuthorID=@StaffID and DocumentID=@DocumentID 
	--and (DocumentCodeId=5 OR DocumentCodeId=6 OR DocumentCodeId=101) 
	and isnull(D.RecordDeleted,'N')<>'Y' 
	AND (DC.ServiceNote='Y' OR DC.DocumentCodeId=1601) ) --16 May 2017 Manjunath K                     
	exec ssp_SCUpdateTimeline @DocumentVersionId                  
	IF @@error <> 0 goto error                  

	--If documentCodeId is 101 'Assessment ' create a new dianosis document                  
	IF exists(select * from Documents where AuthorID=@StaffID and  DocumentID=@DocumentID and DocumentCodeId=101 and			isnull(RecordDeleted,'N')<>'Y')                  
	Begin  
		-- Added by vikas  for taks no 1142 on ace  need Dx or not  
		declare @varNeedDx varchar(2)  
		select @varNeedDx =AutoCreateDiagnosisFromAssessment from SystemConfigurations   
		if(@varNeedDx ='Y')  
		begin  
		--exec ssp_SCSignatureCreateDiagnosisDoc @StaffID,@DocumentID,@NewDocumentID out                  
		IF @@error <> 0 goto error                  
		end  
		end  
		--End of Added by vikas  		

		select isnull(@NewDocumentID ,0)     
		COMMIT TRAN      
	END 
	
	IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'scsp_SCPostDocumentCompleteUpdates')  
         BEGIN  
             EXEC scsp_SCPostDocumentCompleteUpdates @DocumentVersionId,@DocumentID
         END     
END      
RETURN(0)                  
                  
error:  
 if @@TRANCOUNT > 0 rollback transaction                
rollback tran                  
RAISERROR('Error in ssp_SCPostDocumentCompleteUpdates procedure', 16, 1)  
  
  
  
  
  
  
  
  
  

GO



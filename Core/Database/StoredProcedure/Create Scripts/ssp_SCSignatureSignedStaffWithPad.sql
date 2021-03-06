/****** Object:  StoredProcedure [dbo].[ssp_SCSignatureSignedStaffWithPad]    Script Date: 11/18/2011 16:25:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCSignatureSignedStaffWithPad]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCSignatureSignedStaffWithPad]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCSignatureSignedStaffWithPad]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'      
          
          
CREATE Procedure [dbo].[ssp_SCSignatureSignedStaffWithPad]               
(
	@StaffID int,
	@DocumentID int,
	@ClientSignedPaper varchar(1),
	@SignatureData image,
	@DocumentVersionId INT
)                                
as                                
/*********************************************************************/                                
/* Stored Procedure: dbo.ssp_SignatureSignedStaffWithPad                */                                
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */                                
/* Creation Date:    7/24/05                                         */                                
/*                                                                   */                                
/* Purpose:  changes the status of signature and insert staff''s signature in database */                                
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
/* 11/30/2007 Vikas Vyas   Update Modified Date In DocumentSignature Table*/       
/*11Aug2011	 Shifali	  Added CurrentVersionStatus = 22 in Update Document when documentcodeId<>102 */           
/*11Aug2011  Shifali	  Added Logic to Update RevisionNumber in DocumentSignatures table	*/
/*07Sept2011 Shifali	  Added Update for Documents.CurrentDocumentVersionId on sign equal to InProgressDocumentVersionId*/
/*03Oct2011	 Shifali	  Added condition AND SignedDocumentVersionId IS NULL*/  
/*20Apl2013	 Bernardin	  Added condition SignatureDate IS NULL */   
/*24Sept2013 Md Hussain Khusro  Removed white space after Last Name of Signer Name*/
/*15 December 2016 Manjunath K   Modified Existing conditions to create entries into TimelineServices for all services. */
/*								 For AspenPointe-Environment Issues  #35.*/
/*13 April 2017    Manjunath K   Passing @DocumentVersinID instead of @DocumentId to ssp_SCUpdateTimeline.*/
/*								 For AspenPoite Environment Issue tracking 35.    */
/*16 May 2017 Manjunath K   Modified Existing conditions to create entries into TimelineServices for DSM Diagnosis document as well. */
/*								 For AspenPointe-Environment Issues  #35.*/
/*13 Nov 2018 Chita Ranjan		 What:Added condition to Update the VerificationMode column in DocumentSignatures table dynamically based on selection in Signature Popup*/
/*                      		 Why: PEP - Customizations #10212*/
/*********************************************************************/                               
BEGIN                              
declare @varNewDocId int                                  
declare @DocumentCodeId int                                
declare @Coordinator varchar(10)                                
declare @NewDocumentID INT                  
declare @FirstName varchar(100)                                
declare @LastName varchar(100)                                
declare @SigningSuffix varchar(100)        
DECLARE @RevisionNumber int 

DECLARE @VerificationMode varchar(1)  = ''S'' --Chita Ranjan 13/11/2018
  
	  IF (@ClientSignedPaper = ''V'')
	  BEGIN
	  SET @VerificationMode = ''V''
	  SET @ClientSignedPaper=''N''
	  END
	  
/*commented by Shifali as we are added DocumentVersionId as param only*/
--Get DocumentVersionId using DocumentID,Version
--Select @DocumentVersionId=SignedDocumentVersionId from DocumentSignatures where
--DocumentId=@DocumentID and StaffId =@StaffID  and ISNULL(RecordDeleted,''N'')=''N''

	/*Added by Shifali in ref to update DocumentSignatures.RevisionNumber on Sign*/
	SELECT @RevisionNumber = RevisionNumber FROM DocumentVersions DV
	WHERE DV.DocumentVersionId = @DocumentVersionId


select @FirstName = FirstName, @LastName=LastName, @SigningSuffix=isnull(SigningSuffix,'''') from Staff where StaffID = @StaffID and isnull(RecordDeleted,''N'')<>''Y''                               
    
select @DocumentCodeId = DocumentCodeId from Documents where Documentid = @DocumentID and isnull(RecordDeleted,''N'')<>''Y''                               
 if(@DocumentCodeId=102)--Transfer Document                                
 BEGIN                                
 declare @IsFirstUser varchar(10)                                
  if exists(select CusTran.RequestingTeamCoordinator,CusTran.ReceivingTeamCoordinator from CustomTransfers CusTran                         
  join Documentsignatures DocSig on DocSig.signedDocumentVersionId = CusTran.DocumentVersionId            
  join Documents Doc ON Doc.DocumentId = DocSig.DocumentId    
  where CusTran.DocumentVersionId = @DocumentVersionId                  
  and isnull(CusTran.RequestingDecision,'''')=''''                         
  and isnull(CusTran.ReceivedDecision,'''')=''''                         
  and isnull(DocSig.SignatureDate,'''')=''''                        
  and isnull(CusTran.RecordDeleted,''N'')<>''Y''                        
  and isnull(Doc.RecordDeleted,''N'')<>''Y''                         
  and isnull(DocSig.RecordDeleted,''N'')<>''Y''                         
  and Doc.AuthorId = @StaffID)                      
                  
   select @IsFirstUser = ''True''                                
    else                                
   select @IsFirstUser = ''False''                                
                                   
  if(@IsFirstUser =''True'')                                
  BEGIN                                
   if Exists(select RequestingTeamCoordinator from CustomTransfers where DocumentVersionId = @DocumentVersionId    
    and isnull(RequestingTeamCoordinator,'''')<>''''  and isnull(RecordDeleted,''N'')<>''Y'')                                
   Begin                                
    select @Coordinator = RequestingTeamCoordinator from CustomTransfers where DocumentVersionId = @DocumentVersionId    
    and isnull(RequestingTeamCoordinator,'''')<>'''' and isnull(RecordDeleted,''N'')<>''Y''                                
    Begin Transaction                                
     Update Documents set AuthorId =  @Coordinator where DocumentId = @DocumentID  and isnull(RecordDeleted,''N'')<>''Y''                               
     Update CustomTransfers set SentDate1 = getdate() where DocumentVersionId = @DocumentVersionId      
  and isnull(RecordDeleted,''N'')<>''Y''                            
     Delete From DocumentSignatures where DocumentId = @DocumentID and isnull(RecordDeleted,'''')<>''Y''                                
     IF @@error <> 0 goto error                              
    Commit Transaction                                 
   End                                
   else if Exists(select ReceivingTeamCoordinator from CustomTransfers where DocumentVersionId = @DocumentVersionId     
  and isnull(ReceivingTeamCoordinator,'''')<>'''' and isnull(RecordDeleted,''N'')<>''Y'')                                
   Begin                                
    select @Coordinator = ReceivingTeamCoordinator from CustomTransfers     
  where DocumentVersionId = @DocumentVersionId     
  and isnull(ReceivingTeamCoordinator,'''')<>'''' and isnull(RecordDeleted,''N'')<>''Y''                                
    Begin Transaction                                
     Update Documents set AuthorId =  @Coordinator where DocumentId = @DocumentID and isnull(RecordDeleted,''N'')<>''Y''                                
     Update CustomTransfers set  SentDate2 = getdate() where DocumentVersionId = @DocumentVersionId    
  and isnull(RecordDeleted,''N'')<>''Y''                            
     Delete From DocumentSignatures where DocumentId = @DocumentID and isnull(RecordDeleted,''N'')<>''Y''                                
     IF @@error <> 0 goto error                              
    Commit Transaction                                 
   End                                
  End                                
  else if(@IsFirstUser =''False'')              -- if not first user                      
  begin                 
   BEGIN TRAN                  
    --Update the documentSignature Table           
    update documentSignatures set SignatureDate=getdate(),ModifiedDate=getdate(),    
  ClientSignedPaper=@ClientSignedPaper,VerificationMode=@VerificationMode,PhysicalSignature=@SignatureData,     
  SignerName= @FirstName + '' '' + @LastName + '''' +             
  case when @SigningSuffix='''' then ''''             else '', '' + @SigningSuffix end             
  where documentid=@DocumentID and StaffID=@StaffID and isnull(RecordDeleted,''N'')<>''Y''                                
     IF @@error <> 0 goto error                              
                                 
    --Update the documents table                              
    UPDATE Documents SET SignedByAuthor=''Y'',DocumentShared=''Y'',Status=22 where  documentid=@DocumentID and AuthorID=@StaffID and isnull(RecordDeleted,''N'')<>''Y''                                
     IF @@error <> 0 goto error                    
                     
    if exists(select CreateAssignment from CustomTransfers where CreateAssignment = ''Y''     
  and DocumentVersionId=@DocumentVersionId and isnull(RecordDeleted,''N'')<>''Y'' )               
  exec ssp_SCCreateAssignmentTransfer                  
     IF @@error <> 0 goto error                                  
                 
   COMMIT TRAN                  
 end                 
 END            --END Transfer Document CODE                  
 ELSE             -- IF DOCUMENTCODEID NOT 102                  
 BEGIN                
  BEGIN TRAN                              
   --Update the documentSignature Table             
               
   update documentSignatures set SignatureDate=getdate(),ModifiedDate=getdate(),
   ClientSignedPaper=@ClientSignedPaper,
   VerificationMode=@VerificationMode,PhysicalSignature=@SignatureData , 
   SignerName= @FirstName + '' '' + @LastName + '''' + case when @SigningSuffix='''' then '''' else '', '' +  @SigningSuffix	    end,RevisionNumber = @RevisionNumber
   ,SignedDocumentVersionId = @DocumentVersionId               
   where documentid=@DocumentID and StaffID=@StaffID AND SignatureDate IS NULL 
   and isnull(RecordDeleted,''N'')<>''Y''     
   --AND SignedDocumentVersionId = @DocumentVersionId
                              
    IF @@error <> 0 goto error                              
                         
   --Update the documents table                              
   UPDATE Documents SET SignedByAuthor=''Y'',DocumentShared=''Y'',Status=22 ,
   CurrentVersionStatus=22
   ,CurrentDocumentVersionId = @DocumentVersionId              
   where  documentid=@DocumentID and (AuthorID=@StaffID or ReviewerId=@StaffID) and isnull(RecordDeleted,''N'')<>''Y''                                
    IF @@error <> 0 goto error                              
                           
   --15 December 2016 Manjunath K                              
   if exists(select * from Documents D 
   Inner Join DocumentCodes DC on DC.DocumentCodeId = D.DocumentCodeId
   WHERE D.AuthorID=@StaffID and D.DocumentID=@DocumentID 
   AND (DC.ServiceNote = ''Y'' OR DC.DocumentCodeId=1601) --16 May 2017 Manjunath K
   --and (DocumentCodeId=5 OR DocumentCodeId=6 OR DocumentCodeId=101) 
   AND isnull(D.RecordDeleted,''N'')<>''Y'' )                              
    exec ssp_SCUpdateTimeline @DocumentVersionId                              
     IF @@error <> 0 goto error                              
                           
   --If documentCodeId is 101 ''Assessment '' create a new dianosis document                              
   IF exists(select * from Documents where AuthorID=@StaffID and  DocumentID=@DocumentID and DocumentCodeId=101 and isnull(RecordDeleted,''N'')<>''Y'')                              
    Begin              
  -- Added by vikas  for taks no 1142 on ace  need Dx or not              
   declare @varNeedDx varchar(2)              
   select @varNeedDx =AutoCreateDiagnosisFromAssessment from SystemConfigurations               
   if(@varNeedDx =''Y'')              
    begin              
        --exec ssp_SCSignatureCreateDiagnosisDoc @StaffID,@DocumentID,@NewDocumentID out              
  Update CustomAssessments Set DiagnosisDocumentId=@NewDocumentID            
        where DocumentVersionId=@DocumentVersionId                            
        IF @@error <> 0 goto error                              
    end              
 end              
 --End of Added by vikas              
                  
   select isnull(@NewDocumentID ,0)                 
  COMMIT TRAN                  
 END                
END                  
RETURN(0)                              
                              
error:                              
rollback tran                              
RAISERROR(''Error in ssp_SCSignatureSignedStaffWithPad procedure'', 16, 1)              
               ' 
END
GO

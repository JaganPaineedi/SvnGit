/****** Object:  StoredProcedure [dbo].[ssp_SCWebGetEventNoteDocumentData]    Script Date: 12/12/2012 17:01:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCWebGetEventNoteDocumentData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCWebGetEventNoteDocumentData]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCWebGetEventNoteDocumentData]    Script Date: 12/12/2012 17:01:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

                        
CREATE procedure [dbo].[ssp_SCWebGetEventNoteDocumentData]                                   
(                                                                                                                                                                                          
 @EventId int,                                                                                                                                                                                 
 @DocumentVersionId int,                                                      
 @CustomStoredProcedure varchar(100),                                                      
 @FillCustomTablesData AS CHAR(1)='Y'                                                      
)                                                                                                                                                                                          
As                                                                                                                                                                                          
/*********************************************************************                                                                                                          
-- Stored Procedure: dbo.ssp_SCWebGetEventNoteDocumentData                                                                                                          
--                                                                                                          
-- Copyright: 2006 Provider Claim Management System                                                                                                          
--                                                                                                          
-- Creation Date:  19/03/2010                                                                                                          
--                                                                                                          
-- Purpose: Gets Events Note  Values                                                                                                          
--                                                                                                          
--                                                                                                          
-- Data Modifications:                                                                                                          
--                                                                                                          
-- Updates:                                                                                                          
-- Date             Author             Purpose                                                                                                          
   19th March 2010  Vikas Vyas         Get Events Data                      
   13 August        Sweety kamboj on   Modified by//Commented e.UserId*/               
/*12 Jan 2012	Sourabh	  Remove rowidentifier and ExternalReferenceId column Add InProgressDocumentVersionId,ReviewerId,ClientLifeEventId and CurrentVersionStatus according to PhaseIII DataModal*/ 									 
/*1 Feb 2012	Sourabh	  Modified to get documentverionid when it is 0*/		
/*25.10.2012    Sanjayb   Merge from 2.x to 3.5xMerge By  - Ref Task No. 259 SC Web Phase II - Bugs/Features -13-July-2012 - Document Version Views:  Refresh repository PDF*/
/*12.12.2012    Rakesh Garg    W.rf to change in core datamode 12.28 in documents table by Adding new field AppointmentId for avoiding concurrency issues*/
/*19/july/2014	Malathi Shiva	Added defensive code when the CustomStoredProcedure is empty */
/*12-Aug-2014	Rohith Uppin	DocumentInitializationLog talbe used without where condition and it was causing System out of memory Exception. Now where clause is included. #Task41 CM to SC. */
/*7-May-2015    Deej			Added a column "ReasonForNewVersion" in DocumentVersions select statement.*/
/**********************************************************************/                                                                                                                                      
	DECLARE @EventTypeID int 
	Declare @DocumentId int                                  
	BEGIN TRY                                    
            
		if @EventId=0        
		Begin        
			select @EventId=EventId,@DocumentId=Documents.DocumentId        
			from Documents        
			join DocumentVersions        
			on DocumentVersions.DocumentVersionId=Documents.CurrentDocumentVersionId        
			and DocumentVersions.DocumentVersionId=@DocumentVersionId   
        End
        else
        Begin        
			select @DocumentId=DocumentId        
			from Documents        
			where EventId=@EventId
        End                                                                                        
                                                                 
SELECT E.[EventId]                                 
     -- ,E.[UserId]     
      ,E.[StaffId]                                  
      ,E.[ClientId]                
      ,E.[EventTypeId]                                  
      ,E.[EventDateTime]                            
      ,E.[Status]                                  
      ,E.[FollowUpEventId]                                  
      ,E.[ProviderId]                 
      ,E.[InsurerId]                                 
      ,E.[RowIdentifier]                                  
      ,E.[CreatedBy]                                  
      ,E.[CreatedDate]                                  
      ,E.[ModifiedBy]                                  
      ,E.[ModifiedDate]                                  
      ,E.[RecordDeleted]                                  
      ,E.[DeletedDate]                                  
      ,E.[DeletedBy]                                  
      ,ET.DisplayNextEventGroup                                   
     ,NE.EventTypeId as NextEventTypeId,                                  
     NE.EventDateTime as NextEventDateTime,                                  
      NE.StaffId as NextEventStaffId  ,              
      NE.InsurerId as NextInsurerId,              
      NE.ProviderId as NextProviderId ,            
      NE.[Status] as NextEventStatus            
                                    
     FROM [Events] E                                
     left join Events NE on NE.EventId=E.FollowUpEventId   and ISNULL(NE.RecordDeleted,'N')<>'Y'                 
     jOin EventTypes ET on E.EventTypeId=ET.EventTypeId                               
     Where e.EventId=@EventId  and ISNULL(e.RecordDeleted,'N')<>'Y'                                  
                                           
 --if(@DocumentVersionId=0)                              
	--begin                              
 --            set @DocumentVersionId=-1                                                                                                           
	--end   
 
 -- Get documentversionId  
 
if(@DocumentVersionId=0)                                                                                                         
Begin                                                                                                
 --Select @Version = CurrentVersion from Documents where DocumentID = @DocumentID                                                                                                                                                            
	if Exists (select DocumentVersions.DocumentVersionId from documents inner join DocumentVersions on 
			DocumentVersions.DocumentVersionId = case when documents.Status = 22 then
			Documents.InProgressDocumentVersionId else Documents.CurrentDocumentVersionId  end
			where Documents.DocumentId=@DocumentID  
			and ISNULL(Documents.RecordDeleted,'N')<>'Y')                
	Begin                
			Select @DocumentVersionId = DocumentVersions.DocumentVersionId from documents inner join DocumentVersions on 
			DocumentVersions.DocumentVersionId  
			 = case when documents.Status = 22 then
			 Documents.InProgressDocumentVersionId
			 else Documents.CurrentDocumentVersionId  end
			   where Documents.DocumentId=@DocumentID 
			   and ISNULL(Documents.RecordDeleted,'N')<>'Y'                
	End  
	Else                
			set @DocumentVersionId=-1 
End	                                                                                                   
 -- End here  
                                                                                   
                                    
  SELECT  TOP 1 [DocumentId] 
      ,[CreatedBy]                                  
      ,[CreatedDate]                                  
      ,[ModifiedBy]                                  
      ,[ModifiedDate]                                  
      ,[RecordDeleted]                                  
      ,[DeletedDate]                                  
      ,[DeletedBy]                                 
      ,[ClientId]                                  
      ,[ServiceId]                                  
      ,[GroupServiceId]                                  
      ,[EventId]                                  
      ,[ProviderId]                                  
      ,[DocumentCodeId]                                  
      ,[EffectiveDate]                                  
      ,[DueDate]                                  
      ,[Status]                                  
      ,[AuthorId]                                  
      ,[CurrentDocumentVersionId]                                  
      ,[DocumentShared]                                  
      ,[SignedByAuthor]                                  
      ,[SignedByAll]                                  
      ,[ToSign]                                  
      ,[ProxyId]                                  
      ,[UnderReview]                                  
      ,[UnderReviewBy]                                  
      ,[RequiresAuthorAttention]
      ,[InitializedXML]
      ,[BedAssignmentId]
      ,[CurrentVersionStatus]
      ,[ReviewerId]
      ,[InProgressDocumentVersionId]   
      ,[ClientLifeEventId]
      ,AppointmentId      --Added by Rakesh Garg w.rf to change in core datamode 12.28 in documents table by Adding new field AppointmentId , As there columns are missing in get sp                            
	FROM [Documents]                                                               
    Where                               
    ISNULL(RecordDeleted,'N')='N'   
    AND DocumentID = @DocumentID
    --AND CurrentDocumentVersionId=@DocumentVersionId                               
                              
                                    
--if exists (Select DocumentId           
--from Documents           
--where CurrentDocumentVersionId=@DocumentVersionId            
--and ISNULL(RecordDeleted,'N')='N')                                                                                                               
--begin                                                                                                                         
 SELECT [DocumentVersionId]                                  
      ,[DocumentId]                                  
      ,[Version]                                 
      ,[EffectiveDate]                                  
      ,[DocumentChanges]                                  
      ,[ReasonForChanges]                                  
      --,[RowIdentifier]                                  
      --,[ExternalReferenceId]                                  
      ,[CreatedBy]                                  
      ,[CreatedDate]                                  
      ,[ModifiedBy]                                  
      ,[ModifiedDate]                                  
     ,[RecordDeleted]                                  
      ,[DeletedDate]                                  
      ,[DeletedBy] 
      ,[AuthorId]
      ,[RevisionNumber]     
      ,[RefreshView] --Task#259 
	  ,[ReasonForNewVersion]                                                            
  FROM [DocumentVersions]                                  
  Where DocumentVersionId=@DocumentVersionId                                  
  and ISNULL(RecordDeleted,'N')<>'Y'            
--end                                  
                       
   --select null as InitializationStatus  from  DocumentInitializationLog where 1 = 2                        
   SELECT [DocumentInitializationLogId]                            
      ,[DocumentId]                                  
      ,[TableName]                                  
      ,[ColumnName]                                  
      ,[InitializationStatus]                                  
      ,[ChildRecordId]                                  
      ,[RowIdentifier]       
      ,[CreatedBy]                                  
      ,[CreatedDate]                                  
      ,[ModifiedBy]                             
      ,[ModifiedDate]                                  
      ,[RecordDeleted]                                  
      ,[DeletedDate]                           
      ,[DeletedBy]                                  
  FROM [DocumentInitializationLog]                                      
   WHERE ISNull(RecordDeleted,'N')='N' and DocumentId=@DocumentID
                                                                                
                                                         
                  
                                  
                                  
if(@FillCustomTablesData='Y')                                  
begin   
if(@CustomStoredProcedure != '')        
begin                       
 exec @CustomStoredProcedure @DocumentVersionId 
 end                                 
end                                  
                                  
                                
                                      
                                          
END TRY                                                          
                                                        
BEGIN CATCH                                                          
 declare @Error varchar(8000)                        
 set @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                           
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_SCWebGetEventNoteDocumentData')                           
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                            
    + '*****' + Convert(varchar,ERROR_STATE())                                                          
                                       RAISERROR                                                           
 (                                                          
  @Error, -- Message text.                                                          
  16,  -- Severity.                                                          
  1  -- State.                                                          
 );                                                     
                                                          
END CATCH 
GO

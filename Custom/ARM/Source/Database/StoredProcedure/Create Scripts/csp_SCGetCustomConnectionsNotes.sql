/****** Object:  StoredProcedure [dbo].[csp_SCGetCustomConnectionsNotes]    Script Date: 06/19/2013 17:49:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomConnectionsNotes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetCustomConnectionsNotes]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomConnectionsNotes]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'Create PROCEDURE [dbo].[csp_SCGetCustomConnectionsNotes]                                     
(                                          
  @DocumentId int,                                          
  @DocumentVersionId int                                       
)                                          
As                                          
 /****************************************************************************/                                                    
 /* Stored Procedure:csp_SCGetCustomConnectionsNotes                   */                                           
 /* Copyright: 2006 Streamlin Healthcare Solutions                           */         
 /* Author: Pradeep                                                          */                                                   
 /* Creation Date:  Sept11,2009                                              */                                                    
 /* Purpose: Gets Data for PrePlanning CheckList Document                    */                                                   
 /* Input Parameters: @DocumentId, @DocumentVersionId                        */                                                  
 /* Output Parameters:None                                                   */                                                    
 /* Return:                                                                  */                                                    
 /* Calls:                                                                   */        
 /* Called From:                                                             */                                                    
 /* Data Modifications:                                                      */                                                    
 /*                                                                          */    
 /*-------------Modification History--------------------------               */    
 /****************************************************************************/                                                     
BEGIN                        
   BEGIN TRY     
   /* Documents Table*/                               
  SELECT [DocumentId]    
      ,[ClientId]    
      ,[ServiceId]    
      ,[GroupServiceId]    
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
      ,[CreatedBy]    
      ,[CreatedDate]    
      ,[ModifiedBy]    
      ,[ModifiedDate]    
      ,[RecordDeleted]    
      ,[DeletedDate]    
      ,[DeletedBy]                                        
   FROM [Documents]                                         
   WHERE ISNull(RecordDeleted,''N'')=''N'' and DocumentId=@DocumentId                                           
    /* DocumentVersions Table*/                                         
   SELECT [DocumentVersionId]    
      ,[DocumentId]    
      ,[Version]    
      ,[EffectiveDate]    
      ,[DocumentChanges]    
      ,[ReasonForChanges]    
      ,[CreatedBy]    
      ,[CreatedDate]    
      ,[ModifiedBy]    
      ,[ModifiedDate]    
      ,[RecordDeleted]    
      ,[DeletedDate]    
      ,[DeletedBy]                                        
   FROM [DocumentVersions]                                        
   WHERE ISNull(RecordDeleted,''N'')=''N'' and DocumentVersionId=@DocumentVersionId                                                            
   --For CustomConnectionsNotes Table                     
   SELECT [DocumentVersionId]
      ,[Purpose]
      ,[Location]
      ,[EmploymentStatus]
      ,[HoursWorked]
      ,[Narrative]
      ,[OnTime]
      ,[Appearance]
      ,[ProductiveWork]
      ,[AppropriatePlacement]
      ,[InteractSupervisor]
      ,[InteractCoWorker]
      ,[Hygiene]
      ,[SatisfactoryWork]
      ,[ProductiveSession]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[ModifiedBy]
      ,[ModifiedDate]
      ,[RecordDeleted]
      ,[DeletedDate]
      ,[DeletedBy]        
      FROM CustomConnectionsNotes              
   WHERE ISNull(RecordDeleted,''N'')=''N'' AND DocumentVersionId=@DocumentVersionId                                                       
 END TRY                        
 BEGIN CATCH                        
    DECLARE @Error varchar(8000)                                                           
   set @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                          
   + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''[csp_SCGetCustomConnectionsNotes]'')                                                           
   + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****ERROR_SEVERITY='' + Convert(varchar,ERROR_SEVERITY())                                                          
   + ''*****ERROR_STATE='' + Convert(varchar,ERROR_STATE())                                                          
   RAISERROR                                                           
   (                     
   @Error, -- Message text.                                                           
   16, -- Severity.                                                           
   1 -- State.                                                           
   )                        
 END CATCH                                      
End
' 
END
GO

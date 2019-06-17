/****** Object:  StoredProcedure [dbo].[ssp_GetImageRecordDetailsByBatchId]    Script Date: 04/04/2013 18:28:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetImageRecordDetailsByBatchId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetImageRecordDetailsByBatchId]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetImageRecordDetailsByBatchId]    Script Date: 04/04/2013 18:28:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO  
/*            
 Created By:Rajesh           
 CreatedOn:12-10-2015         
 Purpose:GetImageRecords            
             
             
 */   
CREATE procedure [dbo].[ssp_GetImageRecordDetailsByBatchId]                         
@BatchId int,                            
@LoggedInStaffId int                            
/********************************************************************************                                                                                                                            
     
*********************************************************************************/                                                                                                 
as                            
                                             
declare @ImageServerId int                            
declare @AssociatedWith int                            
declare @AssociatedWithId int                            
declare @AssociatedWithName varchar(250)                            
declare @ClientId int                            
declare @ProviderId int                            
declare @StaffId int                            
declare @DocumentVersionId int                            
declare @DocumentId int                            
declare @EventId int     
  
if @BatchId > 0                           
  select TOP 1 @ImageServerId = imr.ImageServerId                          
                                  
    from ImageRecords imr                          
                                  
   where imr.BatchId = @BatchId                          
else                          
  select @ImageServerId = DefaultImageServerId                          
    from Staff s                          
   where s.StaffId = @LoggedInStaffId                          
     and isnull(s.RecordDeleted, 'N') = 'N'    
       
   
     
-- Table 1 - Image Server URL                          
select s.ImageServerURL                                
  from ImageServers s                          
 where s.ImageServerId = @ImageServerId                          
                          
-- Table 2 - Associated With                          
       
SELECT   
 IMR.ImageRecordId  
 ,IMR.BatchId  
 ,IMR.ClientId  
 ,Cl.LastName + ', ' + Cl.FirstName   
FROM  
 ImageRecords IMR   
 LEFT JOIN Clients Cl ON Cl.ClientId = IMR.ClientId  
WHERE  
 IMR.BatchId = @BatchId    
 AND ISNULL(IMR.RecordDeleted, 'N') = 'N'                    
        
-- Table 3 - Image Records                            
SELECT [ImageRecordId]                    
      ,[ScannedOrUploaded]                    
      ,[DocumentVersionId]                    
      ,[ImageServerId]                    
      ,[ClientId]                    
      ,[AssociatedId]                    
      ,[AssociatedWith]                    
      ,[RecordDescription]                    
      ,[EffectiveDate]                    
      ,[NumberOfItems]                    
      ,[AssociatedWithDocumentId]                    
      ,[AppealId]                    
      ,[StaffId]                    
      ,[EventId]                    
      ,[ProviderId]                    
      ,[TaskId]                    
      ,[AuthorizationDocumentId]                    
      ,[ScannedBy]                    
      --,[RowIdentifier]                    
      ,[CreatedBy]                    
      ,[CreatedDate]                    
      ,[ModifiedBy]                    
      ,[ModifiedDate]                    
      ,[RecordDeleted]                    
      ,[DeletedDate]                    
      ,[DeletedBy]               
      ,[CoveragePlanID]      
      ,[ProviderAuthorizationDocumentId]      
      ,[BatchId]    
  FROM [ImageRecords]                          
 WHERE BatchId = @BatchId                            
 AND  ISNULL(RecordDeleted, 'N') = 'N'            
             
                         
-- Table 4 - Documents                          
SELECT D.[DocumentId]                  
      ,D.[CreatedBy]                  
      ,D.[CreatedDate]                  
      ,D.[ModifiedBy]                  
      ,D.[ModifiedDate]                  
      ,D.[RecordDeleted]                  
      ,D.[DeletedDate]                  
      ,D.[DeletedBy]                  
      ,D.[ClientId]                  
      ,D.[ServiceId]                  
      ,D.[GroupServiceId]                  
      ,D.[EventId]                  
      ,D.[ProviderId]                  
      ,D.[DocumentCodeId]                  
      ,D.[EffectiveDate]                  
      ,D.[DueDate]                  
      ,D.[Status]                  
      ,D.[AuthorId]                  
      ,D.[CurrentDocumentVersionId]                  
      ,D.[DocumentShared]                  
      ,D.[SignedByAuthor]                  
      ,D.[SignedByAll]                  
      ,D.[ToSign]                  
      ,D.[ProxyId]                  
      ,D.[UnderReview]                  
      ,D.[UnderReviewBy]                  
      ,D.[RequiresAuthorAttention]                  
      ,D.[InitializedXML]                  
      ,D.[BedAssignmentId]    
      ,D.ReviewerId    
      ,D.ClientLifeEventId    
      ,D.InProgressDocumentVersionId    
      ,D.CurrentVersionStatus    
      ,D.AppointmentId ----Added by Rakesh Garg w.rf to change in core datamode 12.28 in documents table by Adding new field AppointmentId , As there columns are missing in get sp     
  FROM [dbo].[Documents]   D     
  JOIN   DocumentVersions DV ON DV.DocumentId = D.DocumentId  
  JOIN  [ImageRecords] IR ON IR.DocumentVersionId = DV.DocumentVersionId   
  and isnull(IR.RecordDeleted,'N')='N'                
 WHERE IR.BatchId = @BatchId                   
                         
                          
-- Table 5 - Document Versions                          
select dv.DocumentVersionId                          
      ,dv.DocumentId                          
      ,dv.[Version]                          
      ,dv.EffectiveDate                          
      ,dv.DocumentChanges                          
      ,dv.ReasonForChanges                          
      --,dv.RowIdentifier --,dv.ExternalReferenceId                          
      ,dv.CreatedBy                          
      ,dv.CreatedDate                          
      ,dv.ModifiedBy                          
      ,dv.ModifiedDate                          
      ,dv.RecordDeleted                          
      ,dv.DeletedDate                          
      ,dv.DeletedBy    
      ,dv.RevisionNumber      
      ,dv.AuthorId                        
      ,dv.RefreshView    
  from DocumentVersions dv         
  JOIN ImageRecords IR ON IR.DocumentVersionId = dv.DocumentVersionId     
  and isnull(IR.RecordDeleted,'N')='N'              
 where IR.BatchId = @BatchId                           
                          
-- Table 6 - Events                          
SELECT [EventId]                  
      ,[StaffId]                  
      ,[ClientId]                  
      ,[EventTypeId]                  
      ,[EventDateTime]                  
      ,[Status]                  
      ,[FollowUpEventId]                  
      ,[ProviderId]                  
      ,[InsurerId]  
      ,[RowIdentifier]                  
      ,[CreatedBy]                  
      ,[CreatedDate]                  
      ,[ModifiedBy]                  
      ,[ModifiedDate]                  
      ,[RecordDeleted]                  
      ,[DeletedDate]                  
      ,[DeletedBy]                  
  FROM [dbo].[Events]                         
 where EventId = @EventId 
 
 
  SELECT BatchId,  
 CreatedBy,  
CreatedDate,  
ModifiedBy,  
ModifiedDate,  
RecordDeleted,  
DeletedBy,  
DeletedDate  
FROM   
 MedicalRecordBatches  WHERE BatchId= @BatchId  
 
 
 

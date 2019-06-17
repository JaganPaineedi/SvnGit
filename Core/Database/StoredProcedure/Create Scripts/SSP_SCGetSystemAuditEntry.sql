IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'SSP_SCGetSystemAuditEntry')
	BEGIN
		DROP  Procedure  SSP_SCGetSystemAuditEntry
	END

GO

CREATE procedure [dbo].[SSP_SCGetSystemAuditEntry]                             
@SystemAuditEntryId int                                                                
                                          
as                                                                  
/**********************************************************************/                                                                      
/* Stored Procedure: dbo.[SSP_SCGetSystemAuditEntry]             */                                                                                                                                           
/*********************************************************************/            
BEGIN  
BEGIN TRY 
 Declare @MaxRowId int
 SET @MaxRowId =  (Select Max(SystemAuditEntryId) From SystemAuditEntry)
 
if(@SystemAuditEntryId=-1)    
BEGIN  
if(@MaxRowId is not null)
BEGIN
SELECT [SystemAuditEntryId]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[ModifiedBy]
      ,[ModifiedDate]
      ,[RecordDeleted]
      ,[DeletedDate]
      ,[DeletedBy]
      ,[StaffId]
      ,[EntryDate]
      ,[EntryType]
  FROM [dbo].[SystemAuditEntry]      
where IsNull(RecordDeleted,'N')='N' and SystemAuditEntryId=@MaxRowId
END

Else
BEGIN
                                
 SELECT
      -1 AS [SystemAuditEntryId]
      ,'' AS [CreatedBy]
      ,getdate() AS [CreatedDate]
      ,'' AS [ModifiedBy]
      ,getdate() AS [ModifiedDate]
      ,NULL AS [RecordDeleted]
      ,NULL AS [DeletedDate]
      ,NULL AS [DeletedBy]
      ,NULL AS [StaffId]
      ,getdate() AS[EntryDate]
      ,NULL AS [EntryType]  
      END   
END   
else
BEGIN
SELECT [SystemAuditEntryId]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[ModifiedBy]
      ,[ModifiedDate]
      ,[RecordDeleted]
      ,[DeletedDate]
      ,[DeletedBy]
      ,[StaffId]
      ,[EntryDate]
      ,[EntryType]
  FROM [dbo].[SystemAuditEntry]      
where IsNull(RecordDeleted,'N')='N' and SystemAuditEntryId=@SystemAuditEntryId  
END  
        
END TRY                                              
                                            
BEGIN CATCH                                               
DECLARE @Error varchar(8000)                                                
 SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                 
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'SSP_SCGetSystemAuditEntry')                 
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                  
    + '*****' + Convert(varchar,ERROR_STATE())                                                       
                                            
 RAISERROR                                                 
 (                                                
  @Error, -- Message text.                                                
  16, -- Severity.                                                
  1 -- State.                                                
 );                                                
                                                
END CATCH                                             
END 








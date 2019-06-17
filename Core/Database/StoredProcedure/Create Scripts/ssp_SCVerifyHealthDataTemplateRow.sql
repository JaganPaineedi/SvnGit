SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('ssp_SCVerifyHealthDataTemplateRow', 'P') IS NOT NULL 
    DROP PROCEDURE [dbo].[ssp_SCVerifyHealthDataTemplateRow]
go

CREATE Procedure [dbo].[ssp_SCVerifyHealthDataTemplateRow]                
@ClientId INT  ,              
@HealthDataTemplateId INT,              
@HealthRecordDate datetime              
              
/********************************************************************************                                                                                                                                                                          
-- Date			Author			 Purpose                                                                        
   Nov-27-2016	Lakshmi          Added logic to identify row from the ClientHealthDataAttributes table, Valley Support Go live #955 
*********************************************************************************/                                                                        
as                  
BEGIN                  
BEGIN TRY                  
                
   ---------------------------ClientHealthDataAttributes----------------------------                  
                 
SELECT               
      CHDA.ClientHealthDataAttributeId              
      ,CHDA.HealthDataAttributeId              
      ,CHDA.Value              
      ,CHDA.ClientId              
      ,CHDA.HealthRecordDate              
      ,CHDA.HealthDataSubTemplateId              
      ,CHDA.SubTemplateCompleted              
      ,CHDA.CreatedBy              
      ,CHDA.CreatedDate              
      ,CHDA.ModifiedBy              
      ,CHDA.ModifiedDate              
      ,CHDA.RecordDeleted              
      ,CHDA.DeletedDate              
      ,CHDA.DeletedBy    
      ,CHDA.HealthDataTemplateId  
   ,CHDA.Flag  
   ,CHDA.Range  
   ,CHDA.IsCorrected  
   ,REPLACE(CHDA.Comments,CHAR(13), '<br/>') AS Comments        
   ,CHDA.ResultStatus  
   ,CHDA.Locked
   ,CHDA.LockedBy
   ,CHDA.LockedDate  
   ,(SELECT TOP 1 S.LastName + ', ' + S.FirstName FROM Staff S WHERE S.UserCode = CHDA.LockedBy AND ISNULL(RecordDeleted,'N') = 'N') AS CompletedBy  
  FROM ClientHealthDataAttributes CHDA
WHERE  (CHDA.ClientId =@ClientId )        
-- Chethan N changes          
 -- AND ( HealthRecordDate=@HealthRecordDate)  
   AND   
 CONVERT(VARCHAR(17),CHDA.HealthRecordDate,113)  =  CONVERT(VARCHAR(17),@HealthRecordDate,113)     
   -- End Chethan N changes  
AND (CHDA.HealthDataTemplateId = @HealthDataTemplateId OR CHDA.HealthDataTemplateId IS NULL OR @HealthDataTemplateId IS NULL)
AND ISNULL(CHDA.RecordDeleted,'N')='N'             
END TRY              
                   
 BEGIN CATCH                  
  DECLARE @Error VARCHAR(8000)                         
  SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                                              
   + '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_SCVerifyHealthDataTemplateRow.sql')                        
   + '*****' + CONVERT(VARCHAR,ERROR_LINE()) + '*****' + Convert(VARCHAR,ERROR_SEVERITY())                                                                                                                
   + '*****' + CONVERT(VARCHAR,ERROR_STATE())                  
  RAISERROR                  
  (                  
   @Error, -- Message text.                  
   16,  -- Severity.                  
   1  -- State.                  
  );                  
 END CATCH                  
 SET TRANSACTION ISOLATION LEVEL READ COMMITTED                   
                  
END
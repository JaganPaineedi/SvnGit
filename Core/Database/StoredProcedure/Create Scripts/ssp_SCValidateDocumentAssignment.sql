IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'ssp_SCValidateDocumentAssignment')
BEGIN
	DROP  PROCEDURE ssp_SCValidateDocumentAssignment --2,3,null
END

GO
CREATE PROCEDURE [dbo].[ssp_SCValidateDocumentAssignment]    
 @CurrentUserId INT,        
 @ScreenKeyId INT      
/******************************************************************************                                                  
**  File:                                                   
**  Name: [ssp_SCValidateDocumentAssignment] 4,21                                                 
**  Desc: Validation stored procedure of Admin Document Assignment Detail page        
**                                                                
**  Parameters:                                                  
**  Input           
 @CurrentUserId INT,        
 @ScreenKeyId INT                           
      
**  Output     ----------       -----------      
**       
      
**  Auth:  vandana      
**  Date:       
*******************************************************************************                                                  
**  Change History       
*******************************************************************************                                                  

*******************************************************************************/         
AS        
BEGIN TRY        
       

 ------------------------------------------------------------    
  
 ---- Create Temp Table for Validation -----        
 DECLARE @validationReturnTable TABLE            
 (        
 TableName  VARCHAR(200),        
 ColumnName  VARCHAR(200),        
 ErrorMessage VARCHAR(1000),  
 ValidationOrder Int        
 )        
 -------------------------------------------        

---- Insert row in Validation Table ------        
INSERT    
INTO    
 @validationReturnTable    
 (    
  TableName,    
  ColumnName,    
  ErrorMessage,   
  ValidationOrder   
 )    
    
---- Validate First/Last Name for Clients ---------    
SELECT 'DocumentAssignments', 'PacketName', 'General- Packet Name is required' ,1   
FROM DocumentAssignments    
WHERE isnull(PacketName,'') = ''and DocumentAssignmentId=@ScreenKeyId   
 
------------------------------------------------------------------------------------------         
    
SELECT distinct TableName    
  , ColumnName    
  , ErrorMessage  
  ,ValidationOrder    
FROM    
 @validationReturnTable    order by  ValidationOrder       
      
 IF EXISTS (SELECT *    
   FROM    
    @validationReturnTable)            
  BEGIN    
SELECT 1 AS ValidationStatus            
  END        
 ELSE        
  BEGIN    
SELECT 0 AS ValidationStatus            
  END        
END TRY        
      
BEGIN CATCH        
 DECLARE @ErrorMessage NVARCHAR(4000);        
    DECLARE @ErrorSeverity INT;        
    DECLARE @ErrorState INT;    
    
SELECT @ErrorMessage = ERROR_MESSAGE()    
  , @ErrorSeverity = ERROR_SEVERITY()    
  , @ErrorState = ERROR_STATE();        
    RAISERROR (@ErrorMessage, -- Message text.        
               @ErrorSeverity, -- Severity.        
               @ErrorState -- State.        
               );         
END CATCH   
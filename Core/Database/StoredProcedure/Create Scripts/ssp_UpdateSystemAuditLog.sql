IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'ssp_UpdateSystemAuditLog')
	BEGIN
		DROP  Procedure  ssp_UpdateSystemAuditLog
	END

GO

CREATE procedure [dbo].[ssp_UpdateSystemAuditLog]                             
@DisableAudit char                                                                
                                          
as                                                                  
/**********************************************************************/                                                                      
/* Stored Procedure: dbo.[ssp_UpdateSystemAuditLog]             */                                                                                                                                           
/*********************************************************************/            
BEGIN  
BEGIN TRY 
 update SystemConfigurations set DisableAuditLog=@DisableAudit
        
END TRY                                              
                                            
BEGIN CATCH                                               
DECLARE @Error varchar(8000)                                                
 SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                 
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_UpdateSystemAuditLog')                 
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








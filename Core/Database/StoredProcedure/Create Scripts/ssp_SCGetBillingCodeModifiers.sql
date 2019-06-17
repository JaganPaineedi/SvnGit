IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'ssp_SCGetBillingCodeModifiers')
	BEGIN
		DROP  Procedure  ssp_SCGetBillingCodeModifiers
	END

GO

CREATE Procedure ssp_SCGetBillingCodeModifiers
AS                                              
/******************************************************************************                                                    
**  File: Shared Tables (SmartCare - Web)                                                    
**  Name:                                   
**  Desc:                                    
**  Return values:                                                    
**  Called by: ssp_SCGetBillingCodeModifiers                                                     
**  Parameters:                                                    
**  Input    Output                                 
**                              
**                              
**                                                 
                
*******************************************************************************                                                    
**  Change History                                                    
*******************************************************************************                                                    
**  Date:            Author:      Description:                                                    
**  --------         --------     ----------------------------------------------------                                                        
   10 April 2012     Rakesh       Used for getting All billing code modifiers   
-- 13 March 2015     Shruthi.S    Added new field ProcedureCodeId.   
-- 18 December 2018  Arjun K R    Added StartDate,EndDate and Active new columns to BillingCodeModifiers.Task #900.77 KCMHSAS Enhancement                                 
*******************************************************************************/                                                  
BEGIN                                              
BEGIN TRY                                              
                
 SELECT [BillingCodeModifierId]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[ModifiedBy]
      ,[ModifiedDate]
      ,[RecordDeleted]
      ,[DeletedDate]
      ,[DeletedBy]
      ,[BillingCodeId]
      ,[Modifier1]
      ,[Modifier2]
      ,[Modifier3]
      ,[Modifier4]
      ,[Description]
      ,[ProcedureCodeId]
      ,[StartDate]
      ,[EndDate]
      ,[Active]
  FROM [BillingCodeModifiers]   
  WHERE ISNULL(RecordDeleted,'N')='N'
  AND ISNULL(Active,'Y')='Y'        
                         
END TRY                                                
                                              
BEGIN CATCH                                                 
DECLARE @Error varchar(8000)                                                  
 SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                   
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_SCGetBillingCodeModifiers')                                                   
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


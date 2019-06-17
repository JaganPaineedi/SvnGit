IF OBJECT_ID('[csp_ReportReceptionGetReceptionStatus]') IS NOT NULL
	DROP PROCEDURE [csp_ReportReceptionGetReceptionStatus]
GO

SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO
Create PROCEDURE  [dbo].[csp_ReportReceptionGetReceptionStatus]                        
                            
As   
begin                   
/**************************************************************  
Created By   : Rachna Singh  
Created Date : 26th-FEB-2012  
Description  : Used to Bind The Status Dropdown in Reception Report w.r.t #165 in 'Primary Care Bugs/Features' 	   
**************************************************************/  
  
BEGIN TRY 
IF Exists(Select 1 from GlobalCodes Where Category='ReceptionStatus')
BEGIN   
Select 0 as GlobalCodeId,' All Statuses' as  CodeName
union             
Select GlobalCodeId,CodeName 
FROM GlobalCodes 
WHERE Category='ReceptionStatus' AND ISNull(RecordDeleted,'N')='N' AND ISNull(Active,'Y')='Y'
ORDER BY CodeName
END 
  END TRY                                                                        
BEGIN CATCH                            
DECLARE @Error varchar(8000)                                                                         
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                   
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_ReportReceptionGetReceptionStatus')                                                                                                       
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
GO

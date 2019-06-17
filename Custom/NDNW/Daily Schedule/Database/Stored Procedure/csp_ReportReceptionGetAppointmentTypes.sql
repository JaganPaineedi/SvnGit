IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'csp_ReportReceptionGetAppointmentTypes')
BEGIN
     DROP  Procedure  csp_ReportReceptionGetAppointmentTypes
                 
END

GO
Create PROCEDURE  [dbo].[csp_ReportReceptionGetAppointmentTypes]                        
                             
As   
begin                   
/**************************************************************  
Created By   : Rachna Singh  
Created Date : 26th-FEB-2012  
Description  : Used to Bind The AppoinmentType Dropdown in Reception Report w.r.t #165 in 'Primary Care Bugs/Features' 	
Modified By Vishant Garg -  comment code to add option of both in parameter dropdown .
**************************************************************/  
  
BEGIN TRY 
IF Exists(Select 1 from GlobalCodes Where Category='ReceptionApptType' and GlobalCodeId=8241)
BEGIN                 
Select GlobalSubCodeId,SubCodeName
FROM GlobalSubCodes 
WHERE GlobalCodeId=8241 
--AND GlobalSubCodeId<>5401 
AND ISNull(RecordDeleted,'N')='N' AND ISNull(Active,'Y')='Y'
END 
  END TRY                                                                        
BEGIN CATCH                            
DECLARE @Error varchar(8000)                                                                         
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                   
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_ReportReceptionGetAppointmentTypes')                                                                                                       
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
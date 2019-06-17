IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'csp_RDLCustomProviderServices')
	BEGIN
		DROP  Procedure csp_RDLCustomProviderServices
		                 
	END
GO
CREATE PROCEDURE  [dbo].[csp_RDLCustomProviderServices]                        
(                              
 @CustomServiceDispositionId  int                              
)                              
As   
begin                   
/**************************************************************  
Created By   : Sudhir Singh  
Created Date : 12th-JAN-2012  
Description  : Used to Bind The RDL for Disposition Control on any page  
Called From  : 'Disposition'  
Modified By  : Saurav Pande on 26th June 2012 with ref. to task 1732 in Kalamazoo bugs Go live.


**************************************************************/  
  
BEGIN TRY                      
Select
	CPS.CustomProviderServiceId
	,CPS.CreatedBy
	,CPS.CreatedDate
	,CPS.ModifiedBy
	,CPS.ModifiedDate
	,CPS.RecordDeleted
	,CPS.DeletedBy
	,CPS.DeletedDate
	,Pr.ProgramName AS Program
	,CPS.CustomServiceDispositionId
  FROM CustomProviderServices CPS
 -- LEFT OUTER JOIN CustomServiceTypePrograms CSTP ON CPS.ProgramId = CSTP.CustomServiceTypeProgramId
  INNER JOIN Programs Pr ON Pr.ProgramId = CPS.ProgramId
  WHERE ISNull(CPS.RecordDeleted,'N')='N' AND CPS.[CustomServiceDispositionId]=@CustomServiceDispositionId    
  END TRY                                                                        
BEGIN CATCH                            
DECLARE @Error varchar(8000)                                                                         
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                   
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_RDLCustomProviderServices')                                                                                                       
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
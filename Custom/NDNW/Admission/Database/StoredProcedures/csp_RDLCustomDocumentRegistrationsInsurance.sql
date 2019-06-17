IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDocumentRegistrationsInsurance]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomDocumentRegistrationsInsurance]
GO



CREATE PROCEDURE  [dbo].[csp_RDLCustomDocumentRegistrationsInsurance]                            
(                                      
@DocumentVersionId  int       
)                                      
As                                      
/************************************************************************/                                                
/* Stored Procedure: csp_RDLCustomDocumentRegistrationsInsurance    */                                                                   
/* Copyright: 2014  Streamline SmartCare                            */                                                                            
/* Creation Date:  oct 19 ,2014                                   */                                                
/*                                                                 */                                                
/* Purpose: Gets Data for CustomRegistrations      */                                               
/*                                                                 */                                              
/* Input Parameters: @DocumentVersionId                            */                                              
/*                                                                 */                                                 
/* Output Parameters:                                              */                                                
/* Purpose: Use For Rdl Report                                     */    
/* Call By:                                                        */                                      
/* Calls:                                                          */                                                
/*                                                                 */                                                
/* Author: Malathui Shiva                                          */  

/************************************************************************/   
                                                                    

BEGIN TRY
BEGIN
   Select RegistrationCoveragePlanId
  ,CP.CoveragePlanName  
  ,CRCP.CreatedBy         
  ,CRCP.CreatedDate         
  ,CRCP.ModifiedBy         
  ,CRCP.ModifiedDate        
  ,CRCP.RecordDeleted      
  ,CRCP.DeletedBy         
  ,CRCP.DeletedDate         
  ,CRCP.DocumentVersionId       
  ,CRCP.CoveragePlanId          
  ,CRCP.InsuredId         
  ,CRCP.GroupId          
  ,CRCP.Comment
  FROM CustomRegistrationCoveragePlans as CRCP
  LEFT JOIN CoveragePlans as CP ON CP.CoveragePlanId=CRCP.CoveragePlanId
  WHERE CRCP.DocumentVersionId = @DocumentVersionId AND isNull(CRCP.RecordDeleted,'N')<>'Y'             
END                                                                                        
END TRY                                                                                                 
BEGIN CATCH                                                   
   DECLARE @Error varchar(8000)                                                                                                                                 
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                      
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_RDLCustomDocumentRegistrationsInsurance')                     
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(varchar,ERROR_SEVERITY())                                                                                      
   + '*****ERROR_STATE=' + Convert(varchar,ERROR_STATE())                                                                                                                            
   RAISERROR (@Error /* Message text*/,  16 /*Severity*/,   1/*State*/   )                               
                                                                                                                                
END CATCH          


GO





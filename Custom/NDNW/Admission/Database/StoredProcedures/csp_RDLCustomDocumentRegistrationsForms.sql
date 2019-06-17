IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDocumentRegistrationsForms]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomDocumentRegistrationsForms]
GO



CREATE PROCEDURE  [dbo].[csp_RDLCustomDocumentRegistrationsForms]                          
(                                      
@DocumentVersionId  int       
)                                      
As                                      
/************************************************************************/                                                
/* Stored Procedure: csp_RDLCustomDocumentRegistrationsForms    */                                                                   
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
      SELECT CustomRegistrationFormAndAgreementId
		,CreatedBy
		,CreatedDate
		,ModifiedBy
		,ModifiedDate
		,RecordDeleted
		,DeletedBy
		,DeletedDate
		,DocumentVersionId
		,dbo.csf_GetGlobalCodeNameById([Form]) as Form
		--,dbo.csf_GetGlobalCodeNameById(CRFA.[Form]) as Form
		--,dbo.fn_GetGlobalCode(Form)
		--,Form
		,EnglishForm
		,SpanishForm
		,NoForm
		,DeclinedForm
		,NotApplicableForm
	FROM CustomRegistrationFormsAndAgreements as CRFA
	WHERE ISNull(CRFA.RecordDeleted, 'N') = 'N'
		AND CRFA.DocumentVersionId = @DocumentVersionId
	ORDER BY CustomRegistrationFormAndAgreementId ASC             
END                                                                                        
END TRY                                                                                                 
BEGIN CATCH                                                   
   DECLARE @Error varchar(8000)                                                                                                                                 
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                      
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_RDLCustomDocumentRegistrationsForms')                     
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(varchar,ERROR_SEVERITY())                                                                                      
   + '*****ERROR_STATE=' + Convert(varchar,ERROR_STATE())                                                                                                                            
   RAISERROR (@Error /* Message text*/,  16 /*Severity*/,   1/*State*/   )                               
                                                                                                                                
END CATCH          


GO







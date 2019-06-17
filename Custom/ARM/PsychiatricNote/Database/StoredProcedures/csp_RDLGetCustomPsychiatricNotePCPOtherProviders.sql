
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLGetCustomPsychiatricNotePCPOtherProviders]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[csp_RDLGetCustomPsychiatricNotePCPOtherProviders]
GO

CREATE PROCEDURE [dbo].[csp_RDLGetCustomPsychiatricNotePCPOtherProviders]
 @DocumentVersionId as int        
AS   
Select
GC.CodeName as TypeOfProvider
,ERP.OrganizationName 
,ERP.Name      
,ERP.PhoneNumber    
,ERP.Email   
FROM ExternalReferralProviders  ERP  
LEFT JOIN states S ON S.stateFIPS=  ERP.state 
INNER JOIN GlobalCodes GC ON GC.GlobalCodeId= ERP.Type
Inner Join CustomPsychiatricPCPProviders CDERP ON CDERP.ExternalReferralProviderId= ERP.ExternalReferralProviderId   
WHERE (CDERP.DocumentVersionId = @DocumentVersionId ) AND ISNULL(CDERP.RecordDeleted,'N')='N' AND ISNULL(ERP.RecordDeleted,'N')='N' ORDER by NAME ASC             
BEGIN         
If (@@error!=0)  
 Begin  
  RAISERROR  ( 'csp_RDLGetCustomPsychiatricNotePCPOtherProviders : An Error Occured',16,1)  
  Return  
 End  
End      
  
  
GO

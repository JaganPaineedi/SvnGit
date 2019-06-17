IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'csp_SubreportAssessmentNeedList')
	BEGIN
		DROP  Procedure  csp_SubreportAssessmentNeedList 
	END

GO
CREATE PROCEDURE [dbo].[csp_SubreportAssessmentNeedList]                                          
(    
@DocumentVersionId  int         
)  
AS                                                                                                                                                      
/****************************************************************************/                                                                                          
/* Stored Procedure: [csp_SubreportAssessmentNeedList]      */                                                                                 
/* Creation Date:18/Jan/2012             */                                                                                          
/* Created By: Jagdeep Hundal              */                                                                                          
/* Purpose: To Initialize CustomDocumentNeeds         */   
/* Input Parameters:  @DocumentVersionId       */  
/* Output Parameters:               */                                                                                          
/* Return:  CustomDocumentNeeds Table          */  
/* Called By:  MHA Need List RDL        */                                                                                
/* Calls:                  */                                                                                          
/*                    */                                                                                          
/* Data Modifications:               */                                                                                          
/* Updates:                 */                                                                                          
/* Date           Author   Purpose          */      
/************************************************************************************/                       
BEGIN TRY  
  
BEGIN  
 SELECT CPN.[CarePlanNeedId]  
  ,CPN.[DocumentVersionId]  
  ,CPN.[CarePlanDomainNeedId]  
  ,CPN.[NeedDescription]  
  ,CPN.[AddressOnCarePlan]  
  ,CPN.[Source]  
  ,CPD.[CarePlanDomainId]  
  ,CPDN.[NeedName]  
  ,CASE CPN.[Source]  
   WHEN 'C' THEN 'Care Plan'   
   END AS SourceName  
   ,CPD.DomainName
 FROM CarePlanNeeds CPN  
 JOIN CarePlanDomainNeeds CPDN ON CPDN.CarePlanDomainNeedId = CPN.CarePlanDomainNeedId  
 JOIN CarePlanDomains CPD ON CPD.CarePlanDomainId = CPDN.CarePlanDomainId  
 WHERE ISNull(CPN.RecordDeleted, 'N') = 'N'  
  AND CPN.DocumentVersionId = @DocumentVersionId  
  
END  
  
END TRY                                                                          
BEGIN CATCH                              
DECLARE @Error varchar(8000)                                                                        
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                     
+ '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_SubreportAssessmentNeedList')                                                                                                         
+ '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                                          
+ '*****' + Convert(varchar,ERROR_STATE())                                                      
RAISERROR                                                                                                         
(                                                                           
@Error, -- Message text.       
16, -- Severity.       
1 -- State.                                                         
);                                                                                                      
END CATCH    
  
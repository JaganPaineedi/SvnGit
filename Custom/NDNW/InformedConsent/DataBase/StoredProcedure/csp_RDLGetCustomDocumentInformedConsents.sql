/****** Object:  StoredProcedure [dbo].[csp_RDLGetCustomDocumentInformedConsents]    ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLGetCustomDocumentInformedConsents]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLGetCustomDocumentInformedConsents]
GO


/****** Object:  StoredProcedure [dbo].[csp_RDLGetCustomDocumentInformedConsents]     ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE Procedure [dbo].[csp_RDLGetCustomDocumentInformedConsents]  --168595
(                                
 @DocumentVersionId  int                                                                                                                                                   
)                                
As                      
 /*********************************************************************/                                                                                          
 /* Stored Procedure: [csp_RDLGetCustomDocumentInformedConsents]               */                                                                                 
 /* Creation Date:  11/Jan/2012                                      */                                                                                          
 /* Purpose: To Initialize */                                                                                         
 /* Input Parameters:   @DocumentVersionId */                                                                                        
 /* Output Parameters:                                */                                                                                          
 /* Return:   */                                                                                          
 /* Called By: Custom Document Informed Consents  */                                                                                
 /* Calls:                                                            */                                                                                          
 /*                                                                   */                                                                                           
 /* Date              Author                  Purpose    */      
 /* 11/Jan/2012         Amit Kumar Srivastava   get data from  CustomDocumentInformedConsents  for RDL       */    
          
 /*********************************************************************/    
                        
BEGIN TRY      
                      
      
                                           
SELECT Top 1 CSLD.[DocumentVersionId]   
      ,CSLD.MemberRefusedSignature
	  ,CSLD.MemberRefusedExplaination  
      ,C.LastName + ', ' + C.FirstName as ClientName    
      ,Documents.ClientID    
      ,Documents.EffectiveDate   
      ,(select OrganizationName from SystemConfigurations) as 'OrganizationName'              
From Documents                      
INNER JOIN DocumentVersions on Documents.DocumentId = DocumentVersions.DocumentId                   
Left Join [CustomDocumentInformedConsents] CSLD on CSLD.DocumentVersionId = DocumentVersions.DocumentVersionId                 
INNER JOIN Clients C on C.ClientId = Documents.ClientId                                                           
Where CSLD.DocumentVersionId = @DocumentVersionId               
and ISNULL(Documents.RecordDeleted,'N')='N'                    
and ISNULL(DocumentVersions.RecordDeleted,'N')='N'                                 
and ISNULL(CSLD.RecordDeleted,'N')='N'                                   
and ISNULL(C.RecordDeleted,'N')='N' 
order by CSLD.[DocumentVersionId] desc
END TRY                        
                      
BEGIN CATCH                        
 declare @Error varchar(8000)                        
 set @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                         
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_RDLGetCustomDocumentInformedConsents')                         
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                          
    + '*****' + Convert(varchar,ERROR_STATE())                        
 RAISERROR                         
 (                        
  @Error, -- Message text.                        
  16,  -- Severity.                        
  1  -- State.                        
 );                     
END CATCH

GO



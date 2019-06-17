/****** Object:  StoredProcedure [dbo].[csp_SCGetCustomDocumentInformedConsents]    ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomDocumentInformedConsents]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetCustomDocumentInformedConsents]
GO

/****** Object:  StoredProcedure [dbo].[csp_SCGetCustomDocumentInformedConsents]    ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE Procedure [dbo].[csp_SCGetCustomDocumentInformedConsents]  
(                                
 @DocumentVersionId  int                                                                                                                                                   
)                                
As                      
 /*********************************************************************/                                                                                          
 /* Stored Procedure: [csp_SCGetCustomDocumentInformedConsents]               */                                                                                 
 /* Creation Date:  10/Jan/2012                                    */                                                                                          
 /* Purpose: To Initialize */                                                                                         
 /* Input Parameters:   @DocumentVersionId */                                                                                        
 /* Output Parameters:                                */                                                                                          
 /* Return:   */                                                                                          
 /* Called By: Custom Document Informed Consents */                                                                                
 /* Calls:                                                            */                                                                                          
 /*                                                                   */                                                                                           
 /* Date              Author                  Purpose    */      
 /* 10/Jan/2012       Amit Kumar Srivastava   get data from  CustomDocumentInformedConsents         */    
          
 /*********************************************************************/    
                        
BEGIN TRY      
                      
SELECT DocumentVersionId,
	CreatedBy,
	CreatedDate,
	ModifiedBy,
	ModifiedDate,
	RecordDeleted,
	DeletedBy,
	DeletedDate,
	MemberRefusedSignature ,MemberRefusedExplaination
  FROM [CustomDocumentInformedConsents] CSLD         
  WHERE ISNull(CSLD.RecordDeleted,'N')='N' AND CSLD.DocumentVersionId=@DocumentVersionId     
      
       
          
END TRY                        
                      
BEGIN CATCH                        
 declare @Error varchar(8000)                        
 set @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                         
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_SCGetCustomDocumentInformedConsents')                         
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



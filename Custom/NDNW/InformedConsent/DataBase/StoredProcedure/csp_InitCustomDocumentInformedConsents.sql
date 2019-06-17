/****** Object:  StoredProcedure [dbo].[csp_InitCustomDocumentInformedConsents]     ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomDocumentInformedConsents]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCustomDocumentInformedConsents]
GO

/****** Object:  StoredProcedure [dbo].[csp_InitCustomDocumentInformedConsents]    ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE Procedure [dbo].[csp_InitCustomDocumentInformedConsents]  
(                                                      
 @ClientID int,                                
 @StaffID int,                              
 @CustomParameters xml                                                      
)                                                                              
As                                                                                      
/*********************************************************************/                                                                                          
 /* Stored Procedure: [csp_InitCustomDocumentInformedConsents]               */                                                                                 
 /* Creation Date:  10/Jan/2012                                    */                                                                                          
 /* Purpose: To Initialize */                                                                                         
 /* Input Parameters:   @ClientID,@StaffID ,@CustomParameters*/                                                                                        
 /* Output Parameters:                                */                                                                                          
 /* Return:   */                                                                                          
 /* Called By:Custom Document Informed Consents  */                                                                                
 /* Calls:                                                            */                                                                                          
 /*                                                                   */            
 /*       Date              Author                  Purpose    */      
  /*     10/Jan/2012       Amit Kumar Srivastava    initialise table Field of CustomDocumentInformedConsents  */  
 /*********************************************************************/       
      
                                                                                           
Begin                            
Begin try                 
              
DECLARE @LatestDocumentVersionID int                
    
    
SET @LatestDocumentVersionID =(SELECT TOP 1 CurrentDocumentVersionId from CustomDocumentInformedConsents C inner join Documents Doc                                                                                     
  on C.DocumentVersionId=Doc.CurrentDocumentVersionId   
  and Doc.ClientId=@ClientID                   
  and Doc.Status=22    
  and IsNull(C.RecordDeleted,'N')='N'   
  and IsNull(Doc.RecordDeleted,'N')='N'                                                         
 ORDER BY Doc.EffectiveDate DESC,Doc.ModifiedDate desc                                                              
)             
         
 SELECT top 1 Placeholder.TableName,ISNULL(CSLD.DocumentVersionId,-1) AS DocumentVersionId          
       ,CSLD.DocumentVersionId
		,CSLD.CreatedBy
		,CSLD.CreatedDate
		,CSLD.ModifiedBy
		,CSLD.ModifiedDate
		,CSLD.RecordDeleted
		,CSLD.DeletedBy
		,CSLD.DeletedDate
		,CSLD.MemberRefusedSignature 
		             
 FROM (SELECT 'CustomDocumentInformedConsents' AS TableName) AS Placeholder      
 LEFT JOIN CustomDocumentInformedConsents CSLD ON ( CSLD.DocumentVersionId  = @LatestDocumentVersionID      
 AND ISNULL(CSLD.RecordDeleted,'N') <> 'Y' )    
     
                           
END TRY                                                                        
BEGIN CATCH                            
DECLARE @Error varchar(8000)                                                                         
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                   
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_InitCustomDocumentInformedConsents')                                                                                                       
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



/****** Object:  StoredProcedure [dbo].[csp_SCGetCustomDocumentLocuss]    Script Date: 11/21/2013******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomDocumentLocuss]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[csp_SCGetCustomDocumentLocuss]
GO

/****** Object:  StoredProcedure [dbo].[csp_SCGetCustomDocumentLocuss]     Script Date: 11/21/2013******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE  [dbo].[csp_SCGetCustomDocumentLOCUSs]                        
(                              
 @DocumentVersionId  int                                                                                                                                                 
)                              
As                    
 /*********************************************************************/                                                                                        
 /* Stored Procedure: [csp_SCGetCustomDocumentLOCUSs]               */                                                                               
 /* Creation Date:  05-02-2014                                  */                                                                                        
 /* Purpose: To Initialize */                                                                                       
 /* Input Parameters:   @DocumentVersionId */                                                                                      
 /* Output Parameters:                                */                                                                                        
 /* Return:   */                                                                                        
 /* Called By: Custom ssessment Locus Documents  */                                                                              
 /* Calls:                                                            */                                                                                        
 /*                                                                   */                                                                                        
 /* Data Modifications:                                               */                                                                                        
 /*   Updates:                                                          */                                                                                        
 /*       Date              Author                  Purpose    */    
   /*     05-02-2014      Dhanil Manuel      get data from  CustomDocumentLOCUSs                            */  
 /*********************************************************************/  
                      
BEGIN TRY    
                    
Select   
        CSLD.[DocumentVersionId]  
       ,CSLD.[CreatedBy]  
       ,CSLD.[CreatedDate]  
       ,CSLD.[ModifiedBy]  
       ,CSLD.[ModifiedDate]  
       ,CSLD.[RecordDeleted]  
       ,CSLD.[DeletedDate]  
       ,CSLD.[DeletedBy]  
       ,CSLD.[SectionIScore]  
       ,CSLD.[SectionIIScore]  
       ,CSLD.[SectionIIIScore]  
       ,CSLD.[SectionIVaScore]  
       ,CSLD.[SectionIVbScore]  
       ,CSLD.[SectionVScore]  
       ,CSLD.[SectionVIScore]  
       ,CSLD.[CompositeScore]  
       ,CSLD.[LOCUSRecommendedLevelOfCare]
       ,CSLD.[AssessorRecommendedLevelOfCare]
       ,CSLD.[ReasonForDeviation]
       ,CSLD.[Comments]
        FROM [CustomDocumentLOCUSs] CSLD       
  WHERE ISNull(CSLD.RecordDeleted,'N')='N' AND CSLD.DocumentVersionId=@DocumentVersionId   
    
    select * from CustomDocumentLOCUSs 
        
END TRY                      
                    
BEGIN CATCH                      
 declare @Error varchar(8000)                      
 set @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                       
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_SCGetCustomDocumentLOCUSs')                       
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                        
    + '*****' + Convert(varchar,ERROR_STATE())                      
 RAISERROR                       
 (                      
  @Error, -- Message text.                      
  16,  -- Severity.                      
  1  -- State.                      
 );                   
END CATCH 

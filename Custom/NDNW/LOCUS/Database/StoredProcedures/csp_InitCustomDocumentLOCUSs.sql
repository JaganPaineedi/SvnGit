IF EXISTS ( SELECT  *
            FROM    sys.procedures
            WHERE   name = 'csp_InitCustomDocumentLOCUSs'
                    AND type = 'P' )
    DROP PROCEDURE csp_InitCustomDocumentLOCUSs
GO


SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[csp_InitCustomDocumentLOCUSs]
    (
      @ClientID INT ,
      @StaffID INT ,
      @CustomParameters XML                                                    
    )
AS /*********************************************************************/                                                                                        
 /* Stored Procedure: [csp_InitCustomDocumentLOCUSs]               */                                                                               
 /* Creation Date:  05-05-2014                                   */                                                                                        
 /* Purpose: To Initialize */                                                                                       
 /* Input Parameters:   @ClientID,@StaffID ,@CustomParameters*/                                                                                      
 /* Output Parameters:                                */                                                                                        
 /* Return:   */                                                                                        
 /* Called By:Custom Assessment Locus Documents  */                                                                              
 /* Calls:                                                            */                                                                                        
 /*                                                                   */                                                                                        
 /* Data Modifications:                                               */                                                                                        
 /*   Updates:                                                          */                                                                                        
 /*       Date              Author                  Purpose    */    
  /*     02-05-2014      Dhanil Manuel                  initialise table Field of CustomDocumentLOCUSs                            */  
  /*	 10/03/2014			NJain				Commented out initialization logic */
  /*	14.Jan.2015			Rohith Uppin		Comments removed from initialization logic(verified with Threshold SVN thread). Task#116.3 SWMBH - Enhancements */
  /*     05-Feb-2015	   Ponnin				Initialize based on Documentcodeid */
 /*********************************************************************/     
    
                                                                                         
    BEGIN                          
        BEGIN TRY               
            
            DECLARE @LatestDocumentVersionID INT = -1             
  
  
            
           SET @LatestDocumentVersionID = (
		SELECT TOP 1 CLA.DocumentVersionId
		FROM CustomDocumentLOCUSs CLA
		INNER JOIN Documents Doc ON CLA.DocumentVersionId = Doc.CurrentDocumentVersionId
		WHERE Doc.ClientId = @ClientID
			AND Doc.STATUS = 22
			AND Doc.DocumentCodeId = 30027
			AND IsNull(CLA.RecordDeleted, 'N') = 'N'
			AND IsNull(Doc.RecordDeleted, 'N') = 'N'
		ORDER BY Doc.EffectiveDate DESC
			,Doc.ModifiedDate DESC
		)
                    
       
            SELECT TOP 1
                    Placeholder.TableName ,
                    ISNULL(CSLD.DocumentVersionId, -1) AS DocumentVersionId ,
                    CSLD.[CreatedBy] ,
                    CSLD.[CreatedDate] ,
                    CSLD.[ModifiedBy] ,
                    CSLD.[ModifiedDate] ,
                    CSLD.[RecordDeleted] ,
                    CSLD.[DeletedDate] ,
                    CSLD.[DeletedBy] ,
                    CSLD.[SectionIScore] ,
                    CSLD.[SectionIIScore] ,
                    CSLD.[SectionIIIScore] ,
                    CSLD.[SectionIVaScore] ,
                    CSLD.[SectionIVbScore] ,
                    CSLD.[SectionVScore] ,
                    CSLD.[SectionVIScore] ,
                    CSLD.[CompositeScore] ,
                    CSLD.[LOCUSRecommendedLevelOfCare] ,
                    CSLD.[AssessorRecommendedLevelOfCare] ,
                    CSLD.[ReasonForDeviation],
                    CSLD.[Comments]
            FROM    ( SELECT    'CustomDocumentLOCUSs' AS TableName
                    ) AS Placeholder
                    LEFT JOIN CustomDocumentLOCUSs CSLD ON ( CSLD.DocumentVersionId = @LatestDocumentVersionID
                                                             AND ISNULL(CSLD.RecordDeleted, 'N') <> 'Y'
                                                           )  
   
                         
        END TRY                                                                      
        BEGIN CATCH                          
            DECLARE @Error VARCHAR(8000)                                                                       
            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_InitCustomDocumentLOCUSs') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())                                                  
            RAISERROR                                                                                                     
 (                                                                       
  @Error, -- Message text.                                                                                                    
  16, -- Severity.                                                                                                    
  1 -- State.                                                                                                    
 );                                                                                                  
        END CATCH                                                 
    END   
GO


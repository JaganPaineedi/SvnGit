IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCValidateInpatientCodingDocument]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCValidateInpatientCodingDocument]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCValidateInpatientCodingDocument] @DocumentVersionId INT
AS
/*********************************************************************/
/* Stored Procedure: [ssp_SCValidateInpatientCodingDocument]      */
/* Date              Author                  Purpose                 */
/* 4/17/2015         Hemant kumar            what:This sp is used validate the Inpatient Coding Document  why:Inpatient Coding Document #228      */
/* 11/22/2016	     Bibhu	                 What: Executed SCSP_SCValidateDocumentEffectiveDate           
**						                     Why:task #197 Bradford - Customizations      */
/*********************************************************************/                                                                        
/**  Change History **/                                                                         
/********************************************************************************/                                                                           
/**  Date:    Author:     Description: **/                                                                         
/**  --------  --------    ------------------------------------------- */  
BEGIN 
BEGIN TRY   
-- Declare Variables  
DECLARE @DocumentType VARCHAR(10)
-- Get ClientId  
DECLARE @ClientId INT

SELECT @ClientId = d.ClientId
FROM Documents d
WHERE d.InProgressDocumentVersionId = @DocumentVersionId

-- Set Variables sql text  
DECLARE @Variables VARCHAR(max)

SET @Variables = 'DECLARE @DocumentVersionId int  
      SET @DocumentVersionId = ' + convert(VARCHAR(20), @DocumentVersionId) + ' DECLARE @ClientId int  
      SET @ClientId = ' + convert(VARCHAR(20), @ClientId)
----- 11/22/2016	     Bibhu 
 IF EXISTS ( SELECT  *  
            FROM    sys.objects  
            WHERE   object_id = OBJECT_ID(N'SCSP_SCValidateDocumentEffectiveDate')  
                    AND type IN ( N'P', N'PC' ) ) 
                    BEGIN     
   EXEC SCSP_SCValidateDocumentEffectiveDate @DocumentVersionId 
                    END  
                    
IF NOT EXISTS (
		SELECT *
		FROM CustomDocumentValidationExceptions
		WHERE DocumentVersionId = @DocumentVersionId
			AND DocumentValidationid IS NULL
		)
BEGIN
	EXEC csp_validateDocumentsTableSelect @DocumentVersionId
		,1628
		,@DocumentType
		,@Variables
END		
END TRY   
BEGIN CATCH                      
 DECLARE @ERROR VARCHAR(8000)                      
 SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                       
    + '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_SCValidateInpatientCodingDocument')                       
    + '*****' + CONVERT(VARCHAR,ERROR_LINE()) + '*****' + CONVERT(VARCHAR,ERROR_SEVERITY())                        
    + '*****' + CONVERT(VARCHAR,ERROR_STATE())                      
 RAISERROR                       
 (                      
  @Error, -- Message text.                      
  16,  -- Severity.                      
  1  -- State.                      
 );                   
END CATCH  

END
GO


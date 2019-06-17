/****** Object:  StoredProcedure [dbo].[ssp_InitDocumentSyndromicSurveillance]    Script Date: 05/25/2016 17:40:09 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_InitDocumentSyndromicSurveillance]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_InitDocumentSyndromicSurveillance]
GO

/****** Object:  StoredProcedure [dbo].[ssp_InitDocumentSyndromicSurveillance]     Script Date: 05/25/2016 17:40:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_InitDocumentSyndromicSurveillance] (
	@ClientID INT
	,@StaffID INT
	,@CustomParameters XML
	)
AS
/******************************************************************************                                                
**  File: ssp_InitDocumentSyndromicSurveillance                                            
**  Name: ssp_InitDocumentSyndromicSurveillance                        
**  Desc: To Initialize Syndromic Surveillance Document                                                             
**  Called by:                                                 
**  Parameters:                            
**  Auth:  Varun 
/* What : Syndromic Surveillance Document		*/
/* whay : Task #22.1 Meaningful Use - Stage 3   */
*******************************************************************************                                                
**  Change History                                          
*******************************************************************************                                          
 
--*******************************************************************************/
BEGIN
	BEGIN TRY
	
		
		SELECT 'DocumentSyndromicSurveillances' AS TableName
			,- 1 AS 'DocumentVersionId'
			,DSS.CreatedBy
			,DSS.CreatedDate
			,DSS.ModifiedBy
			,DSS.ModifiedDate
			,DSS.RecordDeleted
			,DSS.DeletedDate
			,DSS.DeletedBy
		FROM systemconfigurations SC
		LEFT JOIN DocumentSyndromicSurveillances DSS ON SC.DatabaseVersion = - 1

		EXEC ssp_InitCustomDiagnosisStandardInitializationNew @ClientID
			,@StaffID
			,@CustomParameters
			
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_InitDocumentSyndromicSurveillance') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                                                            
				16
				,-- Severity.                                                                                                            
				1 -- State.                                                                                                            
				);
	END CATCH
END
GO


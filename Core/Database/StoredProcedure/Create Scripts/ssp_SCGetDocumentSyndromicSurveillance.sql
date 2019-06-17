/****** Object:  StoredProcedure [dbo].[ssp_SCGetDocumentSyndromicSurveillance]    ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetDocumentSyndromicSurveillance]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCGetDocumentSyndromicSurveillance]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetDocumentSyndromicSurveillance]    ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/******************************************************************************                                   
**  File: ssp_SCGetDocumentSyndromicSurveillance                                            
**  Name: ssp_SCGetDocumentSyndromicSurveillance                        
**  Desc: GetData for Syndromic Surveillance Document
**  Called by:                                                 
**  Parameters:                            
**  Auth:  Varun 
/* What : Syndromic Surveillance Document		*/
/* whay : Task #22.1 Meaningful Use - Stage 3   */
*******************************************************************************                                                
**  Change History                                          
*******************************************************************************                                          
**  Date:       Author:       Description:                                    
*******************************************************************************/
CREATE PROCEDURE [dbo].[ssp_SCGetDocumentSyndromicSurveillance] (@DocumentVersionId INT)
AS
BEGIN
	BEGIN TRY
		SELECT [DocumentVersionId]
			,[CreatedBy]
			,[CreatedDate]
			,[ModifiedBy]
			,[ModifiedDate]
			,[RecordDeleted]
			,[DeletedBy]
			,[DeletedDate]
			,[GeneralType]
			,[AdmissionDateTime]
			,[DischargeDateTime]
			,[DeathDateTime]
			,[DischargeReason]
			,[ChiefComplaint]
			,[FacilityVisitType]
		FROM [DocumentSyndromicSurveillances]
		WHERE (ISNULL(RecordDeleted, 'N') = 'N')
			AND (DocumentVersionId = @DocumentVersionId)

		EXEC ssp_SCGetDataDiagnosisNew @DocumentVersionId
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), '[ssp_SCGetDocumentSyndromicSurveillance]') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****ERROR_STATE=' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error /* Message text*/
				,16 /*Severity*/
				,1 /*State*/
				)
	END CATCH
END
GO


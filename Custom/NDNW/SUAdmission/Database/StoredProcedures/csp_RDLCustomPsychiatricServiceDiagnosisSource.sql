IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomPsychiatricServiceDiagnosisSource]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomPsychiatricServiceDiagnosisSource]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[csp_RDLCustomPsychiatricServiceDiagnosisSource] 
(@DocumentVersionId INT = 0)
	/*************************************************
  Date:			Author:       Description:                            
  
  -------------------------------------------------------------------------            
 02-Jan-2015     Revathi      What:Get PsychiatricService Previous Diagnosis Informations
							  Why:task #823 Woods-Customizations
--Copied from valley to New Directions Customization Task 4							  
************************************************/
AS
BEGIN
	BEGIN TRY
		DECLARE @ClientId INT
		DECLARE @EffectiveDate DATETIME

		SELECT @ClientId = D.ClientId
			,@EffectiveDate = D.EffectiveDate
		FROM Documents D
		WHERE D.CurrentDocumentVersionId = @DocumentVersionId
			AND ISNULL(D.RecordDeleted, 'N') = 'N'

		DECLARE @LatestICD10DocumentVersionID INT
		DECLARE @LastEffectiveDate DATETIME

		SELECT TOP 1 @LatestICD10DocumentVersionID = a.CurrentDocumentVersionId
			,@LastEffectiveDate = a.EffectiveDate
		FROM Documents a
		INNER JOIN DocumentCodes Dc ON Dc.DocumentCodeid = a.DocumentCodeid
		WHERE a.ClientId = @ClientID
			AND a.EffectiveDate <= @EffectiveDate
			AND a.[Status] = 22
			AND Dc.DiagnosisDocument = 'Y'
			AND isNull(a.RecordDeleted, 'N') <> 'Y'
			AND isNull(Dc.RecordDeleted, 'N') <> 'Y'
			AND a.CurrentDocumentVersionId < @DocumentVersionId
		ORDER BY a.EffectiveDate DESC
			,a.ModifiedDate DESC

		SELECT FactorId
			,dbo.csf_GetGlobalCodeNameById(FactorId) AS 'Factors'
		FROM DocumentDiagnosisFactors
		WHERE (DocumentVersionId = @LatestICD10DocumentVersionID)
			AND (ISNULL(RecordDeleted, 'N') = 'N')
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' +
		CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' +
		 ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_RDLCustomPsychiatricServiceDiagnosisSource') + '*****'
		 + CONVERT(VARCHAR, ERROR_LINE()) + '*****' +
		  CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + 
		  CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.
				16
				,-- Severity.
				1 -- State.
				);
	END CATCH
END

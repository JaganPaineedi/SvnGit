IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetCurrentDiagnosisForHL7]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCGetCurrentDiagnosisForHL7] --20295
GO

CREATE PROCEDURE [dbo].[ssp_SCGetCurrentDiagnosisForHL7] @ClientId INT
AS
/*********************************************************************/
/* Stored Procedure:[ssp_SCGetCurrentDiagnosisForHL7]                       */
/* Creation Date:8/18/2015                                            */
/*                                                                    */
/* Purpose: To Retrieve client CurrentDiagnosis                       */
/*                                                                    */
/* Created By:Hemant Kumar                                            */
/*                                                                    */
/*   Updates:                                                         */
/*       Date              Author                  Purpose            */
/*********************************************************************/
BEGIN
	BEGIN TRY
		DECLARE @EffectiveDate VARCHAR(30);
		DECLARE @LatestICD10DocumentVersionID INT
		DECLARE @LatestICD9DocumentVersionID INT
		DECLARE @LatestICD9ICD10DocumentVersionID INT
		DECLARE @DSMV CHAR(1)

		SELECT TOP 1 @LatestICD9ICD10DocumentVersionID = a.CurrentDocumentVersionId
			,@EffectiveDate = CONVERT(VARCHAR(10), a.EffectiveDate, 101)
		FROM Documents AS a
		INNER JOIN DocumentCodes AS Dc ON Dc.DocumentCodeId = a.DocumentCodeId
		WHERE a.ClientId = @ClientId
			AND a.EffectiveDate <= convert(DATETIME, convert(VARCHAR, getDate(), 101))
			AND a.STATUS = 22
			AND Dc.DiagnosisDocument = 'Y'
			AND isNull(a.RecordDeleted, 'N') <> 'Y'
			AND isNull(Dc.RecordDeleted, 'N') <> 'Y'
		ORDER BY a.EffectiveDate DESC
			,a.ModifiedDate DESC

		IF EXISTS (
				SELECT 1
				FROM DiagnosesIandII
				WHERE DocumentVersionId = @LatestICD9ICD10DocumentVersionID
				)
		BEGIN
			SET @DSMV = 'N'
		END

		IF EXISTS (
				SELECT 1
				FROM DocumentDiagnosisCodes
				WHERE DocumentVersionId = @LatestICD9ICD10DocumentVersionID
				)
		BEGIN
			SET @DSMV = 'Y'
			SET @LatestICD10DocumentVersionID = @LatestICD9ICD10DocumentVersionID
		END

		IF @DSMV = 'Y'
		BEGIN
			SELECT D.ICD10Code
				,D.ICD9Code
				,ICD10.ICDDescription AS DSMDescription				
			FROM DocumentDiagnosisCodes AS D
			INNER JOIN DiagnosisICD10Codes ICD10 ON ICD10.ICD10CodeId = D.ICD10CodeId
			WHERE (D.DocumentVersionId = @LatestICD10DocumentVersionID)
				AND (ISNULL(D.RecordDeleted, 'N') = 'N')

		END
		ELSE
		BEGIN
			SET @LatestICD9DocumentVersionID = (
					SELECT TOP 1 a.CurrentDocumentVersionId
					FROM Documents AS a
					INNER JOIN DocumentCodes AS Dc ON Dc.DocumentCodeId = a.DocumentCodeId
					INNER JOIN DiagnosesIII AS DIII ON a.CurrentDocumentVersionId = DIII.DocumentVersionId
					WHERE a.ClientId = @ClientID
						AND a.EffectiveDate <= convert(DATETIME, convert(VARCHAR, getDate(), 101))
						AND a.STATUS = 22
						AND Dc.DiagnosisDocument = 'Y'
						AND isNull(a.RecordDeleted, 'N') <> 'Y'
						AND isNull(Dc.RecordDeleted, 'N') <> 'Y'
					ORDER BY a.EffectiveDate DESC
						,a.ModifiedDate DESC
					)

			IF @LatestICD9DocumentVersionID IS NOT NULL
			BEGIN
				SELECT NULL AS ICD10Code
					,DIandII.DSMCode AS ICD9Code
					,DSM.DSMDescription				
				FROM DiagnosesIAndII DIandII 
				INNER JOIN DiagnosisDSMDescriptions DSM ON (
						DSM.DSMCode = DIandII.DSMCode
						AND DSM.DSMNumber = DIandII.DSMNumber
						)
				WHERE (
						DIandII.DocumentVersionId = @LatestICD9DocumentVersionID
						AND ISNULL(DIandII.RecordDeleted, 'N') <> 'Y'
						)		
				
			END
		END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetCurrentDiagnosisForHL7') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.
				16
				,-- Severity.
				1 -- State.
				);
	END CATCH
END
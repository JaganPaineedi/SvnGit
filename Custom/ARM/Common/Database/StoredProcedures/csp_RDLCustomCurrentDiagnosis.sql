IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'csp_RDLCustomCurrentDiagnosis')
	BEGIN
		DROP  Procedure csp_RDLCustomCurrentDiagnosis
		                 
	END
GO

CREATE PROCEDURE [dbo].[csp_RDLCustomCurrentDiagnosis] (@DocumentVersionId INT = 0)
	/*************************************************
  Date:			Author:       Description:                            
  
  -------------------------------------------------------------------------            
 02-Jan-2015     Revathi     What:Get Psychiatric Service Previous Diagnosis
                             Why:task #823 Woods-Customizations
 12-Jan-2015     Akwinass    What:Date format implemented to remove time from Effective Date
                             Why:task #822 Woods-Customizations
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

		SELECT TOP 1 @LatestICD10DocumentVersionID = CurrentDocumentVersionId
			,@LastEffectiveDate = CONVERT(VARCHAR(10), a.EffectiveDate, 101)
		FROM Documents a
		INNER JOIN DocumentCodes Dc ON Dc.DocumentCodeid = a.DocumentCodeid
		WHERE a.ClientId = @ClientID
			AND a.EffectiveDate <= convert(DATETIME, convert(VARCHAR, getDate(), 101))
			AND a.STATUS = 22
			AND Dc.DiagnosisDocument = 'Y'
			AND isNull(a.RecordDeleted, 'N') <> 'Y'
			AND isNull(Dc.RecordDeleted, 'N') <> 'Y'
		ORDER BY a.EffectiveDate DESC
			,a.ModifiedDate DESC

		SELECT D.ICD10CodeId
			,D.ICD10Code
			,D.ICD9Code
			,D.DiagnosisType
			,D.RuleOut
			,D.Billable
			,D.Severity
			,D.DiagnosisOrder
			,D.Specifier
			,D.Remission
			,D.[Source]
			,DSM.ICDDescription
			,CONVERT(VARCHAR(10), @LastEffectiveDate, 101) AS EffectiveDate
			,CASE D.RuleOut
				WHEN 'Y'
					THEN 'R/O'
				ELSE ''
				END AS RuleOutText
			,CASE DSM.DSMVCode
					WHEN 'Y'
						THEN 'Yes'
					ELSE 'No'
					END AS DSMVCode
			,dbo.csf_GetGlobalCodeNameById(D.DiagnosisType) AS 'DiagnosisTypeText'
			,dbo.csf_GetGlobalCodeNameById(D.Severity) AS 'SeverityText'
		FROM DocumentDiagnosisCodes AS D
		INNER JOIN DiagnosisICD10Codes DSM ON DSM.ICD10CodeId = D.ICD10CodeId
		WHERE (D.DocumentVersionId = @LatestICD10DocumentVersionID)
			AND (ISNULL(D.RecordDeleted, 'N') = 'N')
		
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_RDLCustomCurrentDiagnosis') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.
				16
				,-- Severity.
				1 -- State.
				);
	END CATCH
END



/****** Object:  StoredProcedure [dbo].[csp_SCGetPreviousDiagnosis]    Script Date: 08/13/2015 15:03:28 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetPreviousDiagnosis]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetPreviousDiagnosis]
GO


/****** Object:  StoredProcedure [dbo].[csp_SCGetPreviousDiagnosis]    Script Date: 08/13/2015 15:03:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[csp_SCGetPreviousDiagnosis] @ClientId INT
AS
/*********************************************************************/
/* Stored Procedure: [csp_SCGetPreviousDiagnosis]   */
/*       Date              Author                  Purpose                   */
/*      11-18-2014     Dhanil Manuel               To Retrieve Data           */
/*      01-06-2015     DiagnosisICD10Codes		   Included DiagnosisICD10Codes table*/
--23-March-2015 SuryaBalan Copied from valley to New Directions Customization Task 4
/*********************************************************************/
BEGIN
	BEGIN TRY
		DECLARE @EffectiveDate VARCHAR(30);
		DECLARE @LatestICD10DocumentVersionID INT
		DECLARE @LatestICD9DocumentVersionID INT

		SELECT TOP 1 @LatestICD10DocumentVersionID = CurrentDocumentVersionId
			,@EffectiveDate = CONVERT(VARCHAR(10), a.EffectiveDate, 101)
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

		IF @LatestICD10DocumentVersionID IS NOT NULL
		BEGIN
			SELECT D.DocumentDiagnosisCodeId
				,D.CreatedBy
				,D.CreatedDate
				,D.ModifiedBy
				,D.ModifiedDate
				,D.RecordDeleted
				,D.DeletedDate
				,D.DeletedBy
				,D.DocumentVersionId
				,D.ICD10CodeId
				,D.ICD10Code
				,D.ICD9Code
				,dbo.csf_GetGlobalCodeNameById(D.DiagnosisType) AS DiagnosisType
				,D.RuleOut
				,D.Billable
				,dbo.csf_GetGlobalCodeNameById(D.Severity) AS Severity
				,D.DiagnosisOrder
				,D.Specifier
				,D.Remission
				,D.[Source]
				--,DSM.DSMDescription
				,ICD10.ICDDescription AS DSMDescription
				,CASE D.RuleOut
					WHEN 'Y'
						THEN 'R/O'
					ELSE ''
					END AS RuleOutText
				,dbo.csf_GetGlobalCodeNameById(D.DiagnosisType) AS 'DiagnosisTypeText'
				,dbo.csf_GetGlobalCodeNameById(D.Severity) AS 'SeverityText'
			FROM DocumentDiagnosisCodes AS D --left JOIN              
				INNER JOIN DiagnosisICD10Codes ICD10 ON ICD10.ICD10CodeId = D.ICD10CodeId
			WHERE (D.DocumentVersionId = @LatestICD10DocumentVersionID)
				AND (ISNULL(D.RecordDeleted, 'N') = 'N')

			SELECT DocumentDiagnosisId
				,CreatedBy
				,CreatedDate
				,ModifiedBy
				,ModifiedDate
				,RecordDeleted
				,DeletedDate
				,DeletedBy
				,DocumentVersionId
				,ScreeeningTool
				,OtherMedicalCondition
				,FactorComments
				,GAFScore
				,WHODASScore
				,CAFASScore
				,@EffectiveDate AS EffectiveDate
			FROM DocumentDiagnosis
			WHERE (DocumentVersionId = @LatestICD10DocumentVersionID)
				AND (ISNULL(RecordDeleted, 'N') = 'N')

			SELECT DocumentDiagnosisFactorId
				,CreatedBy
				,CreatedDate
				,ModifiedBy
				,ModifiedDate
				,RecordDeleted
				,DeletedDate
				,DeletedBy
				,DocumentVersionId
				,FactorId
				,dbo.csf_GetGlobalCodeNameById(FactorId) AS 'Factors'
			FROM DocumentDiagnosisFactors
			WHERE (DocumentVersionId = @LatestICD10DocumentVersionID)
				AND (ISNULL(RecordDeleted, 'N') = 'N')
		END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_SCGetPreviousDiagnosis') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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



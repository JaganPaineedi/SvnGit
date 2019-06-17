IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'csp_RDLCustomPsychiatricServicePreviousDiagnosis')
                    AND type IN ( N'P', N'PC' ) )
                    BEGIN 
                    DROP PROCEDURE csp_RDLCustomPsychiatricServicePreviousDiagnosis
                    end 
                    
                    go

create PROCEDURE [dbo].[csp_RDLCustomPsychiatricServicePreviousDiagnosis] (@DocumentVersionId INT = 0)
	/*************************************************
  Date:			Author:       Description:                            
  
  -------------------------------------------------------------------------            
 02-Jan-2015     Revathi     What:Get Psychiatric Service Previous Diagnosis
                             Why:task #823 Woods-Customizations
 12-Jan-2015     Akwinass    What:Date format implemented to remove time from Effective Date
                             Why:task #822 Woods-Customizations
 --23-March-2015 SuryaBalan Copied from valley to New Directions Customization Task 4
 -- 1/27/2015	 jcarlson		changed ICDCode to ICDCodeId to prevent duplicates from being returned
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
			,dbo.csf_GetGlobalCodeNameById(D.DiagnosisType) AS 'DiagnosisTypeText'
			,dbo.csf_GetGlobalCodeNameById(D.Severity) AS 'SeverityText'
		FROM DocumentDiagnosisCodes AS D
		INNER JOIN DiagnosisICD10Codes AS DSM ON DSM.ICD10CodeId = D.ICD10CodeId
		WHERE (D.DocumentVersionId = @LatestICD10DocumentVersionID)
			AND (ISNULL(D.RecordDeleted, 'N') = 'N')
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_RDLCustomPsychiatricServicePreviousDiagnosis') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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



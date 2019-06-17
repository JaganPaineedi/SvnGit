/****** Object:  StoredProcedure [dbo].[ssp_SCRDLInpatientCodingDiagnosisList]    Script Date: 10/21/2015 11:59:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[ssp_SCRDLInpatientCodingDiagnosisList]
    (
      @DocumentVersionId AS INT
    )
AS /*********************************************************************/
/* Stored Procedure: [ssp_RDLInpatientCodingDiagnosisList]             */
/* Date              Author                 Purpose                 */
/* 4/17/2015         Hemant kumar           what:This sp will get the client DiagnosisList why:Inpatient Coding Document #228                        */
/* 09/02/2015		 Chethan N				What : Added New column AttendingPhysicianId
											Why : Philhaven Development task# 338 */    
/* 10/21/2015		 NJain					Updated to LEFT JOIN TO ICD-10 and get ICD-9 description when ICD10 Code is not present*/											
/*********************************************************************/
    BEGIN
        BEGIN TRY
		--DECLARE @ClientId INT
		--DECLARE @DiagnosisDocumentCodeID INT
		--DECLARE @CurDiagnosisDocumentCodeID INT
		--DECLARE @LatestDiagnosisDocumentVersionId INT

		--SET @ClientId = (
		--		SELECT ClientId
		--		FROM documents doc
		--		INNER JOIN DocumentVersions docv ON docv.DocumentId = doc.DocumentId
		--		WHERE DocumentVersionId = @DocumentVersionId
		--			AND ISNULL(docv.RecordDeleted, 'N') <> 'Y'
		--		)
		--SET @LatestDiagnosisDocumentVersionId = (
		--		SELECT TOP 1 CurrentDocumentVersionId
		--		FROM Documents a
		--		INNER JOIN DocumentCodes Dc ON Dc.DocumentCodeid = a.DocumentCodeid
		--		WHERE a.ClientId = @ClientId
		--			AND a.[Status] = 22
		--			AND Dc.DiagnosisDocument = 'Y'
		--			AND a.EffectiveDate <= CONVERT(DATETIME, CONVERT(VARCHAR, GETDATE(), 101))
		--			AND isNull(a.RecordDeleted, 'N') <> 'Y'
		--			AND isNull(Dc.RecordDeleted, 'N') <> 'Y'
		--		ORDER BY a.EffectiveDate DESC
		--			,a.ModifiedDate DESC
		--		)
		--SET @DiagnosisDocumentCodeID = (
		--		SELECT TOP 1 DocumentCodeId
		--		FROM Documents
		--		WHERE CurrentDocumentVersionId = @LatestDiagnosisDocumentVersionId
		--		)
		--SET @CurDiagnosisDocumentCodeID = (
		--		SELECT TOP 1 DocumentCodeId
		--		FROM DocumentCodes
		--		WHERE DocumentCodeId = @DiagnosisDocumentCodeID
		--			AND DSMV = 'Y'
		--		)

		--IF (@CurDiagnosisDocumentCodeID IS NULL)
		--BEGIN
		--	SELECT ICDIA.InpatientCodingDiagnosisId
		--		,ICDIA.DocumentVersionId
		--		,ICDIA.ICD9Code AS ICD9Code
		--		,ICDIA.DiagnosisType
		--		,ICDIA.RuleOut
		--		--,dbo.ssf_GetGlobalCodeNameById(ICDIA.DiagnosisOrder) AS 'DiagnosisOrder'
		--		,ICDIA.DiagnosisOrder
		--		,ICDIA.CreatedBy
		--		,ICDIA.CreatedDate
		--		,ICDIA.ModifiedBy
		--		,ICDIA.ModifiedDate
		--		,ICDIA.RecordDeleted
		--		,ICDIA.DeletedDate
		--		,ICDIA.DeletedBy
		--		,DSM.DSMDescription
		--		,dbo.ssf_GetGlobalCodeNameById(ICDIA.OnAdmit) AS 'OnAdmit'
		--		,gc.CodeName AS 'DiagnosisTypeText'
		--	FROM InpatientCodingDiagnoses ICDIA
		--	LEFT JOIN globalcodes gc ON ICDIA.DiagnosisType = gc.globalcodeid
		--	INNER JOIN DiagnosisDSMDescriptions DSM ON (DSM.DSMCode = ICDIA.ICD9Code)
		--	AND DSM.DSMNumber = ICDIA.DSMNumber
		--	WHERE ICDIA.DocumentVersionId = @DocumentVersionId
		--		AND ISNULL(ICDIA.RecordDeleted, 'N') <> 'Y'
				
				
		--	UNION
			
		--	SELECT 
		--		ICDIG.InpatientCodingDiagnosisId
		--		,ICDIG.DocumentVersionId
		--		,ICDIG.ICD9Code
		--		,ICDIG.DiagnosisType
		--		,ICDIG.RuleOut
		--		--,dbo.ssf_GetGlobalCodeNameById(ICDIG.DiagnosisOrder) AS 'DiagnosisOrder'
		--		,ICDIG.DiagnosisOrder
		--		,ICDIG.CreatedBy
		--		,ICDIG.CreatedDate
		--		,ICDIG.ModifiedBy
		--		,ICDIG.ModifiedDate
		--		,ICDIG.RecordDeleted
		--		,ICDIG.DeletedDate
		--		,ICDIG.DeletedBy
		--		,ICD.ICDDescription AS DSMDescription
		--		,dbo.ssf_GetGlobalCodeNameById(ICDIG.OnAdmit) AS 'OnAdmit'
		--		,gc.CodeName AS 'DiagnosisTypeText'
		--	FROM InpatientCodingDiagnoses ICDIG
		--	LEFT JOIN DiagnosesIIICodes DIIICodes ON DIIICodes.ICDCode = ICDIG.ICD9Code
		--	LEFT JOIN globalcodes gc ON ICDIG.DiagnosisType = gc.globalcodeid
		--	INNER JOIN DiagnosisICDCodes ICD ON (ICD.ICDCode = ICDIG.ICD9Code)
		--	WHERE ICDIG.DocumentVersionId = @DocumentVersionId
		--		AND ICDIG.DSMNUMBER IS NULL
		--		AND ISNULL(ICDIG.RecordDeleted, 'N') <> 'Y'
		--END
		--ELSE
		--BEGIN
            SELECT  ICDIAG.InpatientCodingDiagnosisId ,
                    ICDIAG.CreatedBy ,
                    ICDIAG.CreatedDate ,
                    ICDIAG.ModifiedBy ,
                    ICDIAG.ModifiedDate ,
                    ICDIAG.RecordDeleted ,
                    ICDIAG.DeletedDate ,
                    ICDIAG.DeletedBy ,
                    ICDIAG.DocumentVersionId ,
                    dbo.ssf_GetGlobalCodeNameById(ICDIAG.OnAdmit) AS 'OnAdmit' ,
                    ICDIAG.ICD10CodeId ,
                    ICD10.ICD10Code AS ICD10Code ,
                    ICDIAG.ICD9Code ,
                    ICDIAG.DiagnosisType ,
                    ICDIAG.RuleOut
				--,dbo.ssf_GetGlobalCodeNameById(ICDIAG.DiagnosisOrder) AS 'DiagnosisOrder'
                    ,
                    ICDIAG.DiagnosisOrder ,
                    ICDIAG.SNOMEDCODE ,
                    dbo.ssf_GetGlobalCodeNameById(ICDIAG.DiagnosisType) AS 'DiagnosisTypeText' ,
                    CASE WHEN ISNULL(ICD10.ICD10Code, '') = '' THEN ICD9.ICDDescription
                         ELSE ICD10.ICDDescription
                    END AS DSMDescription
            FROM    InpatientCodingDiagnoses ICDIAG
                    LEFT JOIN DiagnosisICD10Codes ICD10 ON ICD10.ICD10CodeId = ICDIAG.ICD10CodeId
                    LEFT JOIN SNOMEDCTCodes SNC ON SNC.SNOMEDCTCode = ICDIAG.SNOMEDCODE
                    LEFT JOIN dbo.DiagnosisICDCodes ICD9 ON ICD9.ICDCode = ICDIAG.ICD9Code
            WHERE   ICDIAG.DocumentVersionId = @DocumentVersionId
                    AND ISNULL(ICDIAG.RecordDeleted, 'N') <> 'Y'
		--END
        END TRY

        BEGIN CATCH
            DECLARE @Error VARCHAR(8000)

            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLInpatientCodingDiagnosisList') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

            RAISERROR (
				@Error
				,-- Message text.                                                          
				16
				,-- Severity.                                                          
				1 -- State.                                                          
				)
        END CATCH
    END
GO

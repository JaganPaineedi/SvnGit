IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetInpatientCodingDocument]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCGetInpatientCodingDocument] --16928
GO

CREATE PROCEDURE [dbo].[ssp_SCGetInpatientCodingDocument] (@DocumentVersionId INT)
AS
/*********************************************************************/
/* Stored Procedure: [ssp_SCGetInpatientCodingDocument]              */
/* Date              Author                  Purpose                 */
/* 4/17/2015         Hemant kumar            what:This sp will call after save why:Inpatient Coding Document #228                       */
/*********************************************************************/
/**  Change History **/
/********************************************************************************/
/**  Date:			Author:			Description: **/
/*   09/02/2015     Chethan N       What : Added New column AttendingPhysicianId
									Why : Philhaven Development task# 338 */    
/**  --------  --------    ------------------------------------------- */
BEGIN
	BEGIN TRY
		DECLARE @ClientId INT
		DECLARE @DiagnosisDocumentCodeID INT
		DECLARE @CurDiagnosisDocumentCodeID INT
		DECLARE @LatestDiagnosisDocumentVersionId INT
		DECLARE @effectivedatepara DATETIME
		DECLARE @ICD10CodeId INT

		DELETE
		FROM InpatientCodingDiagnoses
		WHERE RecordDeleted = 'Y'
			AND DocumentVersionId = @DocumentVersionId

		SET @ICD10CodeId = (
				SELECT TOP 1 ICD10CodeId
				FROM InpatientCodingDiagnoses
				WHERE DocumentVersionId = @DocumentVersionId
				)
		SET @ClientId = (
				SELECT ClientId
				FROM documents doc
				INNER JOIN DocumentVersions docv ON docv.DocumentId = doc.DocumentId
				WHERE DocumentVersionId = @DocumentVersionId
					AND ISNULL(docv.RecordDeleted, 'N') <> 'Y'
				)
		SET @effectivedatepara = (
				SELECT doc.EffectiveDate
				FROM documents doc
				INNER JOIN DocumentVersions docv ON docv.DocumentId = doc.DocumentId
				WHERE DocumentVersionId = @DocumentVersionId
					AND doc.ClientId = @ClientId
					AND ISNULL(docv.RecordDeleted, 'N') <> 'Y'
				)
		SET @LatestDiagnosisDocumentVersionId = (
				SELECT TOP 1 CurrentDocumentVersionId
				FROM Documents a
				INNER JOIN DocumentCodes Dc ON Dc.DocumentCodeid = a.DocumentCodeid
				WHERE a.ClientId = @ClientId
					AND a.[Status] = 22
					AND Dc.DiagnosisDocument = 'Y'
					AND a.EffectiveDate <= @effectivedatepara
					AND isNull(a.RecordDeleted, 'N') <> 'Y'
					AND isNull(Dc.RecordDeleted, 'N') <> 'Y'
				ORDER BY a.EffectiveDate DESC
					,a.ModifiedDate DESC
				)
		SET @DiagnosisDocumentCodeID = (
				SELECT TOP 1 DocumentCodeId
				FROM Documents
				WHERE CurrentDocumentVersionId = @LatestDiagnosisDocumentVersionId
				)
		SET @CurDiagnosisDocumentCodeID = (
				SELECT TOP 1 DocumentCodeId
				FROM DocumentCodes
				WHERE DocumentCodeId = @DiagnosisDocumentCodeID
					AND DSMV = 'Y'
				)

		SELECT DocumentVersionId
			,CreatedBy
			,CreatedDate
			,ModifiedBy
			,ModifiedDate
			,RecordDeleted
			,DeletedBy
			,DeletedDate
			,ClientInpatientVisitId
			,AdmitType
			,AdmissionSource
			,DischargeType
			,DRG
			,AttendingPhysicianId
		FROM InpatientCodingDocuments
		WHERE (DocumentVersionId = @DocumentVersionId)
			AND (ISNULL(RecordDeleted, 'N') = 'N')

		IF (@ICD10CodeId IS NULL)
		BEGIN
			SELECT Placeholder.TableName
				,ICDIG.InpatientCodingDiagnosisId
				,ICDIG.DocumentVersionId
				,ICDIG.ICD9Code
				,ICDIG.DiagnosisType
				,ICDIG.RuleOut
				,ICDIG.DiagnosisOrder
				,ICDIG.CreatedBy
				,ICDIG.CreatedDate
				,ICDIG.ModifiedBy
				,ICDIG.ModifiedDate
				,ICDIG.RecordDeleted
				,ICDIG.DeletedDate
				,ICDIG.DeletedBy
				,DSM.DSMDescription
				,ICDIG.OnAdmit
				,gc.CodeName AS 'DiagnosisTypeText'
				,DSM.DSMNumber
			FROM (
				SELECT 'InpatientCodingDiagnoses' AS TableName
				) AS Placeholder
			LEFT JOIN InpatientCodingDiagnoses ICDIG ON (
					ICDIG.DocumentVersionId = @DocumentVersionId
					AND ISNULL(ICDIG.RecordDeleted, 'N') <> 'Y'
					)
			LEFT JOIN globalcodes gc ON ICDIG.DiagnosisType = gc.globalcodeid
			INNER JOIN DiagnosisDSMDescriptions DSM ON (
					DSM.DSMCode = ICDIG.ICD9Code
					AND DSM.DSMNumber = ICDIG.DSMNumber
					)
			
			UNION
			
			SELECT 'InpatientCodingDiagnoses' AS tablename
				,ICDIG.InpatientCodingDiagnosisId
				,ICDIG.DocumentVersionId
				,ICDIG.ICD9Code
				,ICDIG.DiagnosisType
				,ICDIG.RuleOut
				,ICDIG.DiagnosisOrder
				,ICDIG.CreatedBy
				,ICDIG.CreatedDate
				,ICDIG.ModifiedBy
				,ICDIG.ModifiedDate
				,ICDIG.RecordDeleted
				,ICDIG.DeletedDate
				,ICDIG.DeletedBy
				,ICD.ICDDescription AS DSMDescription
				,ICDIG.OnAdmit
				,gc.CodeName AS 'DiagnosisTypeText'
				,ICDIG.DSMNumber
			FROM InpatientCodingDiagnoses ICDIG
			LEFT JOIN DiagnosesIIICodes DIIICodes ON DIIICodes.ICDCode = ICDIG.ICD9Code
			LEFT JOIN globalcodes gc ON ICDIG.DiagnosisType = gc.globalcodeid
			INNER JOIN DiagnosisICDCodes ICD ON (ICD.ICDCode = ICDIG.ICD9Code)
			WHERE ICDIG.DocumentVersionId = @DocumentVersionId
				AND ICDIG.DSMNUMBER IS NULL
				AND ISNULL(ICDIG.RecordDeleted, 'N') <> 'Y'
		END
		ELSE
		BEGIN
			SELECT ICDD.InpatientCodingDiagnosisId
				,ICDD.CreatedBy
				,ICDD.CreatedDate
				,ICDD.ModifiedBy
				,ICDD.ModifiedDate
				,ICDD.RecordDeleted
				,ICDD.DeletedDate
				,ICDD.DeletedBy
				,ICDD.DocumentVersionId
				,ICDD.OnAdmit
				,ICDD.ICD10CodeId
				,ICD10.ICD10Code AS ICD10Code
				,ICDD.ICD9Code
				,ICDD.DiagnosisType
				,dbo.ssf_GetGlobalCodeNameById(ICDD.DiagnosisType) AS 'DiagnosisTypeText'
				,ICDD.RuleOut
				,ICDD.DiagnosisOrder
				,ICDD.SNOMEDCODE
				,ICD10.ICDDescription AS 'DSMDescription'
			FROM InpatientCodingDiagnoses ICDD
			INNER JOIN DiagnosisICD10Codes ICD10 ON ICD10.ICD10CodeId = ICDD.ICD10CodeId
			LEFT JOIN SNOMEDCTCodes SNC ON SNC.SNOMEDCTCode = ICDD.SNOMEDCODE
			WHERE ICDD.DocumentVersionId = @DocumentVersionId
				AND ISNULL(ICDD.RecordDeleted, 'N') <> 'Y'
		END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetInpatientCodingDocument') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****ERROR_STATE=' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error /* Message text*/
				,16 /*Severity*/
				,1 /*State*/
				)
	END CATCH
END
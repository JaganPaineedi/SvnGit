
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomDiagnosisMedicationReviewNote]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[csp_InitCustomDiagnosisMedicationReviewNote]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_InitCustomDiagnosisMedicationReviewNote] 
(
	@ClientId INT
	,@StaffID INT
	,@CustomParameters XML
)
AS
/**********************************************************************************************************************/
/* Stored Procedure:[csp_InitCustomDiagnosisMedicationReviewNote]                                                     */
/* Creation Date: 12 December 2016                                                                                    */
/*                                                                                                                    */
/* Purpose: To Initialize the Medication Review Note                                                                  */
/*																												      */
/* Created By: Ting-Yu Mu																							  */
/*																													  */
/* Update Log:																										  */
/*		Date				Author                  Purpose															  */
/*		12/12/2016			Ting-Yu Mu				To pull the Dx from the most recent signed DSM5 Dx document only  */
/*		01/16/2017			Ting-Yu Mu				To pull only the billable Dx from the most recent signed DSM5 Dx  */
/*      12/20/2018			Ponnin					Added logic to pull Dx from most recent signed DSM5 Dx, Psychiatric Note and Diagnostic Assessment                                                                                                    */
/*                                                  Why : A Renewed Mind - Support  #1030   */
/*      12/26/2018			Rajeshwari S			Added logic to pull Dx from most recent signed Diagnosis Document.                                                                                                     */
/*                                                  Why : A Renewed Mind - Support  #988   */
/**********************************************************************************************************************/
BEGIN
	BEGIN TRY
		DECLARE @LatestICD10DocumentVersionID INT
		DECLARE @LatestICD9DocumentVersionID INT
		DECLARE @GAF INT = 0
		DECLARE @OtherMedicalCondition VARCHAR(max)
		DECLARE @Value VARCHAR(5)
		DECLARE @usercode VARCHAR(100)
		


		SELECT @usercode = UserCode
		FROM Staff
		WHERE StaffId = @StaffID

		SET @Value = (
				SELECT Value
				FROM SystemConfigurationKeys
				WHERE [Key] = 'InitializeAxisIVToFactorsLookupInDSM5'
				)
				
		SET @LatestICD10DocumentVersionID = (
				SELECT TOP 1 a.CurrentDocumentVersionId
				FROM Documents AS a
				INNER JOIN DocumentCodes AS Dc ON Dc.DocumentCodeId = a.DocumentCodeId
				INNER JOIN DocumentDiagnosis AS DDC ON a.CurrentDocumentVersionId = DDC.DocumentVersionId
				INNER JOIN DocumentDiagnosisCodes AS CDC ON a.CurrentDocumentVersionId = CDC.DocumentVersionId  -- tmu modification here
				WHERE a.ClientId = @ClientId
					AND a.EffectiveDate <= GETDATE()
					AND a.STATUS = 22
					AND Dc.DiagnosisDocument = 'Y'
					AND CDC.Billable = 'Y'  -- tmu modification here
					AND ISNULL(a.RecordDeleted, 'N') <> 'Y'
					AND ISNULL(Dc.RecordDeleted, 'N') <> 'Y'
					AND ISNULL(DDC.RecordDeleted, 'N') <> 'Y'
					AND ISNULL(CDC.RecordDeleted, 'N') <> 'Y'
				ORDER BY a.EffectiveDate DESC
						,a.ModifiedDate DESC
						--,a.DocumentId DESC
				)

		IF @LatestICD10DocumentVersionID IS NOT NULL
		BEGIN
			SELECT Placeholder.TableName
				,DDC.CreatedBy
				,DDC.CreatedDate
				,DDC.ModifiedBy
				,DDC.ModifiedDate
				,DDC.RecordDeleted
				,DDC.DeletedDate
				,DDC.DeletedBy
				,ISNULL(DDC.DocumentVersionId, - 1) AS DocumentVersionId
				,DDC.ICD10CodeId
				,DDC.ICD10Code
				,DDC.ICD9Code
				,ISNULL(DDC.DiagnosisType, 142) AS DiagnosisType
				,DDC.RuleOut
				,DDC.Billable
				,DDC.Severity
				,DDC.DiagnosisOrder
				,DDC.Specifier
				,DDC.Remission
				,DDC.[Source]
				,ICD10.ICDDescription AS DSMDescription
				,CASE DDC.RuleOut
					WHEN 'Y'
						THEN 'R/O'
					ELSE ''
					END AS RuleOutText
				,dbo.csf_GetGlobalCodeNameById(DDC.DiagnosisType) AS 'DiagnosisTypeText'
				,dbo.csf_GetGlobalCodeNameById(DDC.Severity) AS 'SeverityText'
				,DDC.Comments
				,DDC.SNOMEDCODE
				,SNC.SNOMEDCTDescription
			FROM (
				SELECT 'DocumentDiagnosisCodes' AS TableName
				) AS Placeholder
			LEFT JOIN DocumentDiagnosisCodes DDC ON (
					DDC.DocumentVersionId = @LatestICD10DocumentVersionID
					AND ISNULL(DDC.RecordDeleted, 'N') <> 'Y'
					AND DDC.Billable = 'Y' -- tmu modification here
					)
			INNER JOIN DiagnosisICD10Codes ICD10 ON ICD10.ICD10CodeId = DDC.ICD10CodeId
			LEFT JOIN SNOMEDCTCodes SNC ON SNC.SNOMEDCTCode = DDC.SNOMEDCODE

			IF (
					@Value = 'Y'
					OR @Value = 'N'
					)
			BEGIN
				SELECT Placeholder.TableName
					,@usercode AS [CreatedBy]
					,GETDATE() AS [CreatedDate]
					,@usercode AS [ModifiedBy]
					,GETDATE() AS [ModifiedDate]
					,ISNULL(DDF.DocumentVersionId, - 1) AS DocumentVersionId
					,FactorId
					,dbo.csf_GetGlobalCodeNameById(FactorId) AS 'Factors'
				FROM (
					SELECT 'DocumentDiagnosisFactors' AS TableName
					) AS Placeholder
				INNER JOIN DocumentDiagnosisFactors DDF ON (
						DDF.DocumentVersionId = @LatestICD10DocumentVersionID
						AND ISNULL(DDF.RecordDeleted, 'N') <> 'Y'
						)
					AND FactorId IS NOT NULL
			END
		END
		ELSE
		BEGIN
			SET @LatestICD9DocumentVersionID = (
					SELECT TOP 1 a.CurrentDocumentVersionId
					FROM Documents AS a
					INNER JOIN DocumentCodes AS Dc ON Dc.DocumentCodeId = a.DocumentCodeId
					LEFT OUTER JOIN DiagnosesIAndII AS DIAndII ON a.CurrentDocumentVersionId = DIAndII.DocumentVersionId
					LEFT OUTER JOIN DiagnosesIIICodes AS DIII ON a.CurrentDocumentVersionId = DIII.DocumentVersionId
					WHERE a.ClientId = @ClientId
						AND a.EffectiveDate <= getDate()
						AND a.STATUS = 22
						AND Dc.DiagnosisDocument = 'Y'
						AND isNull(a.RecordDeleted, 'N') <> 'Y'
						AND isNull(Dc.RecordDeleted, 'N') <> 'Y'
						AND isNull(DIAndII.RecordDeleted, 'N') <> 'Y'
						AND isNull(DIII.RecordDeleted, 'N') <> 'Y'
					ORDER BY a.EffectiveDate DESC
						,a.ModifiedDate DESC
					)
			SET @GAF = (
					SELECT AxisV
					FROM DiagnosesV
					WHERE DocumentVersionId = @LatestICD9DocumentVersionID
					)
			SET @OtherMedicalCondition = (
					SELECT Specification
					FROM DiagnosesIII
					WHERE DocumentVersionId = @LatestICD9DocumentVersionID
					)

			SELECT 'DocumentDiagnosisCodes' AS TableName
				,DIandII.CreatedBy
				,DIandII.CreatedDate
				,DIandII.ModifiedBy
				,DIandII.ModifiedDate
				,DIandII.RecordDeleted
				,DIandII.DeletedDate
				,DIandII.DeletedBy
				,ISNULL(DIandII.DocumentVersionId, - 1) AS DocumentVersionId
				,CASE 
					WHEN (
							SELECT COUNT(SubMapping.ICD9Code) AS Rcount
							FROM DiagnosisICD10ICD9Mapping AS SubMapping
							INNER JOIN DiagnosisICD10Codes AS DSMVCodes ON SubMapping.ICD10CodeId = DSMVCodes.ICD10CodeId
							INNER JOIN DiagnosesIAndII ON SubMapping.ICD9Code = DiagnosesIAndII.DSMCode
							WHERE DSMVCodes.ICD10Code IS NOT NULL
								AND SubMapping.ICD9Code = Mapping.ICD9Code
								AND DiagnosesIAndII.DocumentVersionId = @LatestICD9DocumentVersionID
								AND ISNULL(DiagnosesIAndII.RecordDeleted, 'N') <> 'Y'
							) > 1
						THEN '<img src="../App_Themes/Includes/Images/Alert2.png" title="Diagnosis ' + Mapping.ICD9Code + ' has been converted to ' + DSMVCodes.ICD10Code + '"/>     ' + DSMVCodes.ICDDescription
					ELSE DSMVCodes.ICDDescription
					END AS DSMDescription
				,DSMVCodes.ICD10Code + CASE DSMVCodes.DSMVCode
					WHEN 'Y'
						THEN '*'
					ELSE ''
					END AS ICD10Code
				,Mapping.ICD9Code
				,DSMVCodes.ICD10CodeId
				,ISNULL(DIandII.DiagnosisType, 142) AS DiagnosisType
				,DIandII.RuleOut
				,DIandII.Billable
				,DIandII.Severity
				--,DIandII.DSMVersion
				,DIandII.DiagnosisOrder
				,Convert(VARCHAR(max), DIandII.Specifier) AS Specifier
				,DIandII.[Source]
				,DIandII.Remission
				,CASE DIandII.RuleOut
					WHEN 'Y'
						THEN 'R/O'
					ELSE ''
					END AS RuleOutText
				,dbo.csf_GetGlobalCodeNameById(DIandII.DiagnosisType) AS 'DiagnosisTypeText'
				,dbo.csf_GetGlobalCodeNameById(DIandII.Severity) AS 'SeverityText'
				,CASE 
					WHEN (
							SELECT COUNT(SubMapping.ICD9Code) AS Rcount
							FROM DiagnosisICD10ICD9Mapping AS SubMapping
							INNER JOIN DiagnosisICD10Codes AS DSMVCodes ON SubMapping.ICD10CodeId = DSMVCodes.ICD10CodeId
							INNER JOIN DiagnosesIAndII ON SubMapping.ICD9Code = DiagnosesIAndII.DSMCode
							WHERE DSMVCodes.ICD10Code IS NOT NULL
								AND SubMapping.ICD9Code = Mapping.ICD9Code
								AND DiagnosesIAndII.DocumentVersionId = @LatestICD9DocumentVersionID
								AND ISNULL(DiagnosesIAndII.RecordDeleted, 'N') <> 'Y'
							) > 1
						THEN 'Y'
					ELSE 'N'
					END AS MultipleDiagnosis
				,@LatestICD9DocumentVersionID AS ICD9DocumentVersionId
			FROM (
				SELECT 'DiagnosesIAndII' AS TableName
				) AS Placeholder
			LEFT JOIN DiagnosesIAndII DIandII ON (
					DIandII.DocumentVersionId = @LatestICD9DocumentVersionID
					AND ISNULL(DIandII.RecordDeleted, 'N') <> 'Y'
					)
			LEFT OUTER JOIN DiagnosisICD10ICD9Mapping Mapping ON DIandII.DSMCode = Mapping.ICD9Code
			INNER JOIN DiagnosisICD10Codes DSMVCodes ON Mapping.ICD10CodeId = DSMVCodes.ICD10CodeId
			WHERE DSMVCodes.ICD10Code IS NOT NULL
			
			UNION
			
			SELECT 'DocumentDiagnosisCodes' AS TableName
				,DIII.CreatedBy
				,DIII.CreatedDate
				,DIII.ModifiedBy
				,DIII.ModifiedDate
				,DIII.RecordDeleted
				,DIII.DeletedDate
				,DIII.DeletedBy
				,- 1 AS DocumentVersionId
				,CASE 
					WHEN (
							SELECT COUNT(SubMapping.ICD9Code) AS Rcount
							FROM DiagnosisICD10ICD9Mapping AS SubMapping
							INNER JOIN DiagnosisICD10Codes AS DSMVCodes ON SubMapping.ICD10CodeId = DSMVCodes.ICD10CodeId
							INNER JOIN DiagnosesIIICodes ON SubMapping.ICD9Code = DiagnosesIIICodes.ICDCode
							WHERE DSMVCodes.ICD10Code IS NOT NULL
								AND SubMapping.ICD9Code = Mapping.ICD9Code
								AND DiagnosesIIICodes.DocumentVersionId = @LatestICD9DocumentVersionID
								AND ISNULL(DiagnosesIIICodes.RecordDeleted, 'N') <> 'Y'
							) > 1
						THEN '<img src="../App_Themes/Includes/Images/Alert2.png" title="Diagnosis ' + Mapping.ICD9Code + ' has been converted to ' + DSMVCodes.ICD10Code + '"/>     ' + DSMVCodes.ICDDescription
					ELSE DSMVCodes.ICDDescription
					END AS DSMDescription
				,DSMVCodes.ICD10Code + CASE DSMVCodes.DSMVCode
					WHEN 'Y'
						THEN '*'
					ELSE ''
					END AS ICD10Code
				,DIII.ICDCode AS ICD9Code
				,DSMVCodes.ICD10CodeId
				,142 AS DiagnosisType
				,NULL AS RuleOut
				,DIII.Billable
				,NULL AS Severity
				,CONVERT(INT, ROWCOUNT_BIG()) AS DiagnosisOrder
				,NULL AS Specifier
				,NULL AS [Source]
				,NULL AS Remission
				,'' AS RuleOutText
				,dbo.csf_GetGlobalCodeNameById(142) AS 'DiagnosisTypeText'
				,NULL AS 'SeverityText'
				,CASE 
					WHEN (
							SELECT COUNT(SubMapping.ICD9Code) AS Rcount
							FROM DiagnosisICD10ICD9Mapping AS SubMapping
							INNER JOIN DiagnosisICD10Codes AS DSMVCodes ON SubMapping.ICD10CodeId = DSMVCodes.ICD10CodeId
							INNER JOIN DiagnosesIIICodes ON SubMapping.ICD9Code = DiagnosesIIICodes.ICDCode
							WHERE DSMVCodes.ICD10Code IS NOT NULL
								AND SubMapping.ICD9Code = Mapping.ICD9Code
								AND DiagnosesIIICodes.DocumentVersionId = @LatestICD9DocumentVersionID
								AND ISNULL(DiagnosesIIICodes.RecordDeleted, 'N') <> 'Y'
							) > 1
						THEN 'Y'
					ELSE 'N'
					END AS MultipleDiagnosis
				,@LatestICD9DocumentVersionID AS ICD9DocumentVersionId
			FROM (
				SELECT 'DiagnosesIIICodes' AS TableName
				) AS Placeholder
			LEFT JOIN DiagnosesIIICodes DIII ON (
					DIII.DocumentVersionId = @LatestICD9DocumentVersionID
					AND ISNULL(DIII.RecordDeleted, 'N') <> 'Y'
					)
			LEFT OUTER JOIN DiagnosisICD10ICD9Mapping Mapping ON DIII.ICDCode = Mapping.ICD9Code
			INNER JOIN DiagnosisICD10Codes DSMVCodes ON Mapping.ICD10CodeId = DSMVCodes.ICD10CodeId
			WHERE DSMVCodes.ICD10Code IS NOT NULL

			IF (@Value = 'Y')
			BEGIN
				DECLARE @PrimarySupport CHAR(1)
				DECLARE @SocialEnvironment CHAR(1)
				DECLARE @Educational CHAR(1)
				DECLARE @Occupational CHAR(1)
				DECLARE @Housing CHAR(1)
				DECLARE @Economic CHAR(1)
				DECLARE @HealthcareServices CHAR(1)
				DECLARE @Legal CHAR(1)
				DECLARE @Other CHAR(1)

				CREATE TABLE #FactorsLookup (
					TableName VARCHAR(25) NULL
					,CreatedBy VARCHAR(30) NOT NULL
					,CreatedDate DATETIME NOT NULL
					,ModifiedBy VARCHAR(30) NOT NULL
					,ModifiedDate DATETIME NOT NULL
					,DocumentVersionId INT NULL
					,FactorId INT NULL
					,Factors VARCHAR(70) NULL
					)

				SELECT @PrimarySupport = PrimarySupport
					,@SocialEnvironment = SocialEnvironment
					,@Educational = Educational
					,@Occupational = Occupational
					,@Housing = Housing
					,@Economic = Economic
					,@HealthcareServices = HealthcareServices
					,@Legal = Legal
					,@Other = Other
				FROM DiagnosesIV
				WHERE DocumentVersionId = @LatestICD9DocumentVersionID

				IF @PrimarySupport = 'Y'
					INSERT INTO #FactorsLookup (
						TableName
						,CreatedBy
						,CreatedDate
						,ModifiedBy
						,ModifiedDate
						,DocumentVersionId
						,FactorId
						,Factors
						)
					SELECT Placeholder.TableName
						,@usercode AS [CreatedBy]
						,GETDATE() AS [CreatedDate]
						,@usercode AS [ModifiedBy]
						,GETDATE() AS [ModifiedDate]
						,ISNULL(DDF.DocumentVersionId, - 1) AS DocumentVersionId
						,8810 AS FactorId
						,dbo.csf_GetGlobalCodeNameById(8810) AS 'Factors'
					FROM (
						SELECT 'DocumentDiagnosisFactors' AS TableName
						) AS Placeholder
					INNER JOIN DocumentDiagnosisFactors DDF ON (
							DDF.DocumentVersionId = @LatestICD9DocumentVersionID
							AND ISNULL(DDF.RecordDeleted, 'N') <> 'Y'
							)
						AND FactorId IS NOT NULL

				IF @SocialEnvironment = 'Y'
					INSERT INTO #FactorsLookup (
						TableName
						,CreatedBy
						,CreatedDate
						,ModifiedBy
						,ModifiedDate
						,DocumentVersionId
						,FactorId
						,Factors
						)
					SELECT Placeholder.TableName
						,@usercode AS [CreatedBy]
						,GETDATE() AS [CreatedDate]
						,@usercode AS [ModifiedBy]
						,GETDATE() AS [ModifiedDate]
						,ISNULL(DDF.DocumentVersionId, - 1) AS DocumentVersionId
						,8811 AS FactorId
						,dbo.csf_GetGlobalCodeNameById(8811) AS 'Factors'
					FROM (
						SELECT 'DocumentDiagnosisFactors' AS TableName
						) AS Placeholder
					INNER JOIN DocumentDiagnosisFactors DDF ON (
							DDF.DocumentVersionId = @LatestICD9DocumentVersionID
							AND ISNULL(DDF.RecordDeleted, 'N') <> 'Y'
							)
						AND FactorId IS NOT NULL

				IF @Educational = 'Y'
					INSERT INTO #FactorsLookup (
						TableName
						,CreatedBy
						,CreatedDate
						,ModifiedBy
						,ModifiedDate
						,DocumentVersionId
						,FactorId
						,Factors
						)
					SELECT Placeholder.TableName
						,@usercode AS [CreatedBy]
						,GETDATE() AS [CreatedDate]
						,@usercode AS [ModifiedBy]
						,GETDATE() AS [ModifiedDate]
						,ISNULL(DDF.DocumentVersionId, - 1) AS DocumentVersionId
						,8812 AS FactorId
						,dbo.csf_GetGlobalCodeNameById(8812) AS 'Factors'
					FROM (
						SELECT 'DocumentDiagnosisFactors' AS TableName
						) AS Placeholder
					INNER JOIN DocumentDiagnosisFactors DDF ON (
							DDF.DocumentVersionId = @LatestICD9DocumentVersionID
							AND ISNULL(DDF.RecordDeleted, 'N') <> 'Y'
							)
						AND FactorId IS NOT NULL

				IF @Occupational = 'Y'
					INSERT INTO #FactorsLookup (
						TableName
						,CreatedBy
						,CreatedDate
						,ModifiedBy
						,ModifiedDate
						,DocumentVersionId
						,FactorId
						,Factors
						)
					SELECT Placeholder.TableName
						,@usercode AS [CreatedBy]
						,GETDATE() AS [CreatedDate]
						,@usercode AS [ModifiedBy]
						,GETDATE() AS [ModifiedDate]
						,ISNULL(DDF.DocumentVersionId, - 1) AS DocumentVersionId
						,8813 AS FactorId
						,dbo.csf_GetGlobalCodeNameById(8813) AS 'Factors'
					FROM (
						SELECT 'DocumentDiagnosisFactors' AS TableName
						) AS Placeholder
					INNER JOIN DocumentDiagnosisFactors DDF ON (
							DDF.DocumentVersionId = @LatestICD9DocumentVersionID
							AND ISNULL(DDF.RecordDeleted, 'N') <> 'Y'
							)
						AND FactorId IS NOT NULL

				IF @Housing = 'Y'
					INSERT INTO #FactorsLookup (
						TableName
						,CreatedBy
						,CreatedDate
						,ModifiedBy
						,ModifiedDate
						,DocumentVersionId
						,FactorId
						,Factors
						)
					SELECT Placeholder.TableName
						,@usercode AS [CreatedBy]
						,GETDATE() AS [CreatedDate]
						,@usercode AS [ModifiedBy]
						,GETDATE() AS [ModifiedDate]
						,ISNULL(DDF.DocumentVersionId, - 1) AS DocumentVersionId
						,8814 AS FactorId
						,dbo.csf_GetGlobalCodeNameById(8814) AS 'Factors'
					FROM (
						SELECT 'DocumentDiagnosisFactors' AS TableName
						) AS Placeholder
					INNER JOIN DocumentDiagnosisFactors DDF ON (
							DDF.DocumentVersionId = @LatestICD9DocumentVersionID
							AND ISNULL(DDF.RecordDeleted, 'N') <> 'Y'
							)
						AND FactorId IS NOT NULL

				IF @Economic = 'Y'
					INSERT INTO #FactorsLookup (
						TableName
						,CreatedBy
						,CreatedDate
						,ModifiedBy
						,ModifiedDate
						,DocumentVersionId
						,FactorId
						,Factors
						)
					SELECT Placeholder.TableName
						,@usercode AS [CreatedBy]
						,GETDATE() AS [CreatedDate]
						,@usercode AS [ModifiedBy]
						,GETDATE() AS [ModifiedDate]
						,ISNULL(DDF.DocumentVersionId, - 1) AS DocumentVersionId
						,8815 AS FactorId
						,dbo.csf_GetGlobalCodeNameById(8815) AS 'Factors'
					FROM (
						SELECT 'DocumentDiagnosisFactors' AS TableName
						) AS Placeholder
					INNER JOIN DocumentDiagnosisFactors DDF ON (
							DDF.DocumentVersionId = @LatestICD9DocumentVersionID
							AND ISNULL(DDF.RecordDeleted, 'N') <> 'Y'
							)
						AND FactorId IS NOT NULL

				IF @HealthcareServices = 'Y'
					INSERT INTO #FactorsLookup (
						TableName
						,CreatedBy
						,CreatedDate
						,ModifiedBy
						,ModifiedDate
						,DocumentVersionId
						,FactorId
						,Factors
						)
					SELECT Placeholder.TableName
						,@usercode AS [CreatedBy]
						,GETDATE() AS [CreatedDate]
						,@usercode AS [ModifiedBy]
						,GETDATE() AS [ModifiedDate]
						,ISNULL(DDF.DocumentVersionId, - 1) AS DocumentVersionId
						,8816 AS FactorId
						,dbo.csf_GetGlobalCodeNameById(8816) AS 'Factors'
					FROM (
						SELECT 'DocumentDiagnosisFactors' AS TableName
						) AS Placeholder
					INNER JOIN DocumentDiagnosisFactors DDF ON (
							DDF.DocumentVersionId = @LatestICD9DocumentVersionID
							AND ISNULL(DDF.RecordDeleted, 'N') <> 'Y'
							)
						AND FactorId IS NOT NULL

				IF @Legal = 'Y'
					INSERT INTO #FactorsLookup (
						TableName
						,CreatedBy
						,CreatedDate
						,ModifiedBy
						,ModifiedDate
						,DocumentVersionId
						,FactorId
						,Factors
						)
					SELECT Placeholder.TableName
						,@usercode AS [CreatedBy]
						,GETDATE() AS [CreatedDate]
						,@usercode AS [ModifiedBy]
						,GETDATE() AS [ModifiedDate]
						,ISNULL(DDF.DocumentVersionId, - 1) AS DocumentVersionId
						,8817 AS FactorId
						,dbo.csf_GetGlobalCodeNameById(8817) AS 'Factors'
					FROM (
						SELECT 'DocumentDiagnosisFactors' AS TableName
						) AS Placeholder
					INNER JOIN DocumentDiagnosisFactors DDF ON (
							DDF.DocumentVersionId = @LatestICD9DocumentVersionID
							AND ISNULL(DDF.RecordDeleted, 'N') <> 'Y'
							)
						AND FactorId IS NOT NULL

				IF @Other = 'Y'
					INSERT INTO #FactorsLookup (
						TableName
						,CreatedBy
						,CreatedDate
						,ModifiedBy
						,ModifiedDate
						,DocumentVersionId
						,FactorId
						,Factors
						)
					SELECT Placeholder.TableName
						,@usercode AS [CreatedBy]
						,GETDATE() AS [CreatedDate]
						,@usercode AS [ModifiedBy]
						,GETDATE() AS [ModifiedDate]
						,ISNULL(DDF.DocumentVersionId, - 1) AS DocumentVersionId
						,8818 AS FactorId
						,dbo.csf_GetGlobalCodeNameById(8818) AS 'Factors'
					FROM (
						SELECT 'DocumentDiagnosisFactors' AS TableName
						) AS Placeholder
					INNER JOIN DocumentDiagnosisFactors DDF ON (
							DDF.DocumentVersionId = @LatestICD9DocumentVersionID
							AND ISNULL(DDF.RecordDeleted, 'N') <> 'Y'
							)
						AND FactorId IS NOT NULL

				SELECT *
				FROM #FactorsLookup

				DROP TABLE #FactorsLookup
			END
		END

		SELECT Placeholder.TableName
			,@usercode AS [CreatedBy]
			,GETDATE() AS [CreatedDate]
			,@usercode AS [ModifiedBy]
			,GETDATE() AS [ModifiedDate]
			,ISNULL(DD.DocumentVersionId, - 1) AS DocumentVersionId
			,DD.ScreeeningTool
			,@OtherMedicalCondition AS OtherMedicalCondition
			,DD.FactorComments
			,CASE @GAF
				WHEN 0
					THEN DD.GAFScore
				ELSE @GAF
				END AS GAFScore
			,DD.WHODASScore
			,DD.CAFASScore
		FROM (
			SELECT 'DocumentDiagnosis' AS TableName
			) AS Placeholder
		LEFT JOIN DocumentDiagnosis DD ON (
				DD.DocumentVersionId = @LatestICD10DocumentVersionID
				AND ISNULL(DD.RecordDeleted, 'N') <> 'Y'
				)
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_InitCustomDiagnosisStandardInitializationNew') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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

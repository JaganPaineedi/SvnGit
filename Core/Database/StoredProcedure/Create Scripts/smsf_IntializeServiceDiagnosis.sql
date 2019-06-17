/****** Object:  UserDefinedFunction [dbo].[smsf_IntializeServiceDiagnosis]    Script Date: 11/22/2016 12:47:27 PM ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[smsf_IntializeServiceDiagnosis]')
			AND type IN (
				N'FN'
				,N'IF'
				,N'TF'
				,N'FS'
				,N'FT'
				)
		)
	DROP FUNCTION [dbo].[smsf_IntializeServiceDiagnosis]
GO

/****** Object:  UserDefinedFunction [dbo].[smsf_IntializeServiceDiagnosis]    Script Date: 11/22/2016 12:47:27 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[smsf_IntializeServiceDiagnosis] (
	@ClientId INT
	,@Date DATETIME = NULL
	,@VarProgramId INT = NULL
	)
RETURNS VARCHAR(MAX)
AS
BEGIN
	DECLARE @DiagnosisDocumentCodeID INT
	DECLARE @CurDiagnosisDocumentCodeID INT
	DECLARE @LatestDiagnosisDocumentVersionId INT
	DECLARE @RuleOut CHAR(1)
	DECLARE @JsonResult VARCHAR(MAX)

	SELECT TOP 1 @RuleOut = CASE 
			WHEN ISNULL(Value, 'N') = 'N'
				THEN 'N'
			ELSE 'Y'
			END
	FROM SystemConfigurationKeys
	WHERE [key] = 'INCLUDEBILLINGDIAGNOSISRULEOUT'
		AND ISNULL(RecordDeleted, 'N') = 'N'

	DECLARE @BillingDiagnoses TABLE (
		DocumentId INT
		,DSMCode CHAR(6)
		,DSMNumber INT
		,Version INT
		,EffectiveDate DATETIME
		,DiagnosisOrder INT
		,SortOrder INT
		,ICD10Code VARCHAR(20)
		,ICD9Code VARCHAR(20)
		,DSMVCodeId INT
		,Description VARCHAR(500)
		,[Order] INT
		,[Billable] CHAR(1)
		)
	DECLARE @varDocumentid INT
		,@varVersion INT
		,@varVersion10 INT
		,@varEffectiveDate DATETIME

	IF (@Date IS NULL)
		SET @Date = GETDATE()

	SELECT TOP 1 @varVersion10 = CurrentDocumentVersionId
	FROM DocumentDiagnosisCodes DI
		,Documents Doc
	WHERE DI.DocumentVersionId = Doc.CurrentDocumentVersionId
		AND Doc.ClientId = @ClientId
		AND Doc.STATUS = 22
		AND ISNULL(DI.RecordDeleted, 'N') = 'N'
		AND ISNULL(Doc.RecordDeleted, 'N') = 'N'
		AND Doc.EffectiveDate <= CONVERT(DATETIME, CONVERT(VARCHAR, @Date, 101))
	ORDER BY Doc.EffectiveDate DESC
		,Doc.ModifiedDate DESC

	DECLARE @UseProblemListForDiagnosis CHAR(1)
		,@UseDiagnosisDocument CHAR(1)
		,@DiagnosisDocumentCategory CHAR(1)
		,@ProgramId INT

	SET @ProgramId = @VarProgramId

	IF @ProgramId = NULL
	BEGIN
		SET @ProgramId = 0
	END

	IF @ProgramId > 0
	BEGIN
		SELECT @UseProblemListForDiagnosis = UseProblemListForDiagnosis
			,@UseDiagnosisDocument = UseDiagnosisDocument
			,@DiagnosisDocumentCategory = DiagnosisDocumentCategoryAll
		FROM Programs
		WHERE ProgramId = @ProgramId
	END

	SET @LatestDiagnosisDocumentVersionId = (
			SELECT TOP 1 CurrentDocumentVersionId
			FROM Documents a
			INNER JOIN DocumentCodes Dc ON Dc.DocumentCodeid = a.DocumentCodeid
			WHERE a.ClientId = @ClientId
				AND a.STATUS = 22
				AND Dc.DiagnosisDocument = 'Y'
				AND a.EffectiveDate <= CONVERT(DATETIME, CONVERT(VARCHAR, @Date, 101))
				AND ISNULL(a.RecordDeleted, 'N') <> 'Y'
				AND ISNULL(Dc.RecordDeleted, 'N') <> 'Y'
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

	IF (@CurDiagnosisDocumentCodeID IS NULL)
	BEGIN
		IF (
				ISNULL(@UseDiagnosisDocument, '') = ''
				AND ISNULL(@UseProblemListForDiagnosis, 'N') = 'N'
				)
			OR ISNULL(@UseDiagnosisDocument, '') = 'Y'
			OR @ProgramId <= 0
		BEGIN
			INSERT INTO @BillingDiagnoses (
				DSMCode
				,DsmNumber
				,SortOrder
				,DiagnosisOrder
				,Description
				,Billable
				)
			SELECT D.DSMCode
				,D.DSMNumber
				,CASE 
					WHEN DiagnosisType = 140
						THEN 1
					ELSE 2
					END AS SortOrder
				,DiagnosisOrder
				,DD.DSMDescription
				,ISNULL(D.Billable, 'N')
			FROM dbo.DiagnosesIAndII D
			JOIN DiagnosisDSMDescriptions DD ON DD.DSMCode = D.DSMCode
				AND DD.DSMNumber = D.DSMNumber
			WHERE DocumentVersionId = @LatestDiagnosisDocumentVersionId
				AND ISNULL(D.RecordDeleted, 'N') = 'N'
				AND (
					ISNULL(D.RuleOut, 'N') = @RuleOut
					OR @RuleOut = 'Y'
					)
		END

		IF ISNULL(@UseProblemListForDiagnosis, 'N') = 'Y'
		BEGIN
			INSERT INTO @BillingDiagnoses (
				DSMCode
				,DsmNumber
				,Description
				,Billable
				)
			SELECT CP.DSMCode
				,NULL
				,DC.ICDDescription
				,'N'
			FROM ClientProblems CP
			JOIN DiagnosisICDCodes DC ON CP.DSMCode = DC.ICDCode
				AND ISNULL(CP.RecordDeleted, 'N') = 'N'
			WHERE CP.ClientId = @ClientId
				AND CP.DSMCode NOT IN (
					SELECT DISTINCT DSMCode
					FROM @BillingDiagnoses
					)
		END
	END
	ELSE
	BEGIN
		IF (
				ISNULL(@UseDiagnosisDocument, '') = ''
				AND ISNULL(@UseProblemListForDiagnosis, 'N') = 'N'
				)
			OR ISNULL(@UseDiagnosisDocument, '') = 'Y'
			OR @ProgramId <= 0
		BEGIN
			INSERT INTO @BillingDiagnoses (
				DSMVCodeId
				,ICD10Code
				,ICD9Code
				,DiagnosisOrder
				,Description
				,Billable
				)
			SELECT D.ICD10CodeId
				,D.ICD10Code
				,D.ICD9Code
				,D.DiagnosisOrder
				,DD.ICDDescription AS DSMDescription
				,ISNULL(D.Billable, 'N')
			FROM DocumentDiagnosisCodes D
			JOIN DiagnosisICD10Codes DD ON D.ICD10CodeId = DD.ICD10CodeId
				AND D.ICD10Code = DD.ICD10Code
			WHERE DocumentVersionId = @LatestDiagnosisDocumentVersionId
				AND ISNULL(D.RecordDeleted, 'N') = 'N'
				AND (
					ISNULL(D.RuleOut, 'N') = @RuleOut
					OR @RuleOut = 'Y'
					)

			IF NOT EXISTS (
					SELECT 1
					FROM @BillingDiagnoses
					)
				AND @Date < '10/1/15'
			BEGIN
				INSERT INTO @BillingDiagnoses (
					DSMVCodeId
					,DSMCode
					,DsmNumber
					,SortOrder
					,DiagnosisOrder
					,Description
					,Billable
					)
				SELECT - (
						ROW_NUMBER() OVER (
							ORDER BY d.dsmcode
							)
						)
					,D.DSMCode
					,D.DSMNumber
					,CASE 
						WHEN DiagnosisType = 140
							THEN 1
						ELSE 2
						END AS SortOrder
					,DiagnosisOrder
					,DD.DSMDescription
					,ISNULL(D.Billable, 'N')
				FROM dbo.DiagnosesIAndII D
				JOIN DiagnosisDSMDescriptions DD ON DD.DSMCode = D.DSMCode
					AND DD.DSMNumber = D.DSMNumber
				WHERE DocumentVersionId = @LatestDiagnosisDocumentVersionId
					AND ISNULL(D.RecordDeleted, 'N') = 'N'
					AND (
						ISNULL(D.RuleOut, 'N') = @RuleOut
						OR @RuleOut = 'Y'
						)
			END
		END

		IF ISNULL(@UseProblemListForDiagnosis, 'N') = 'Y'
		BEGIN
			IF (
					SELECT COUNT(*)
					FROM @BillingDiagnoses
					) = 0
			BEGIN
				INSERT INTO @BillingDiagnoses (
					DSMCode
					,DsmNumber
					,Description
					,Billable
					)
				SELECT CP.DSMCode
					,NULL
					,DC.ICDDescription
					,'N'
				FROM ClientProblems CP
				JOIN DiagnosisICDCodes DC ON CP.DSMCode = DC.ICDCode
					AND ISNULL(CP.RecordDeleted, 'N') = 'N'
				WHERE CP.ClientId = @ClientId
			END
		END
	END

	UPDATE @BillingDiagnoses
	SET [Order] = 1
		,DiagnosisOrder = 1
	WHERE SortOrder = 1

	UPDATE @BillingDiagnoses
	SET DiagnosisOrder = 8
	WHERE SortOrder <> 1
		AND DiagnosisOrder = 1

	DECLARE @InitializeDiagnosisOrder CHAR(1)

	SELECT TOP 1 @InitializeDiagnosisOrder = Value
	FROM SystemConfigurationKeys
	WHERE [key] = 'INITIALIZEDIAGNOSISORDER'

	IF ISNULL(@InitializeDiagnosisOrder, 'N') = 'Y'
	BEGIN
		IF (@CurDiagnosisDocumentCodeID IS NULL)
		BEGIN
			DECLARE @BillingDiagnosesDiagnosisOrder TABLE (
				DSMCode CHAR(6)
				,DSMNumber INT
				,SortOrder INT
				,DiagnosisOrder INT
				,[Description] VARCHAR(500)
				,[Billable] CHAR(1)
				)

			INSERT INTO @BillingDiagnosesDiagnosisOrder (
				DSMCode
				,DsmNumber
				,SortOrder
				,DiagnosisOrder
				,[Description]
				,Billable
				)
			SELECT DSMCode
				,DsmNumber
				,SortOrder
				,DiagnosisOrder
				,[Description]
				,Billable
			FROM (
				SELECT *
					,(
						ROW_NUMBER() OVER (
							ORDER BY DiagnosisOrder ASC
							) + 1
						) tn
				FROM @BillingDiagnoses
				WHERE SortOrder <> 1
				) AS BD
			WHERE --tn = 1 AND
				ISNULL(DiagnosisOrder, 0) <= 8

			UPDATE BD
			SET BD.[Order] = BDDO.DiagnosisOrder
			FROM @BillingDiagnoses BD
			INNER JOIN @BillingDiagnosesDiagnosisOrder BDDO ON BD.DSMCode = BDDO.DSMCode
				AND BD.DsmNumber = BDDO.DsmNumber
				AND BD.SortOrder = BDDO.SortOrder
				--AND BD.DiagnosisOrder = BDDO.DiagnosisOrder
				AND BD.[Description] = BDDO.[Description]
				AND BD.Billable = BDDO.Billable
			WHERE BD.SortOrder <> 1
				--DROP TABLE @BillingDiagnosesDiagnosisOrder
		END
		ELSE
		BEGIN
			DECLARE @BillingDiagnosesICD10DiagnosisOrder TABLE (
				DSMVCodeId INT
				,ICD10Code VARCHAR(20)
				,ICD9Code VARCHAR(20)
				,DiagnosisOrder INT
				,[Description] VARCHAR(500)
				,[Billable] CHAR(1)
				)

			INSERT INTO @BillingDiagnosesICD10DiagnosisOrder (
				DSMVCodeId
				,ICD10Code
				,ICD9Code
				,DiagnosisOrder
				,[Description]
				,Billable
				)
			SELECT DSMVCodeId
				,ICD10Code
				,ICD9Code
				,DiagnosisOrder
				,[Description]
				,Billable
			FROM (
				SELECT *
					,ROW_NUMBER() OVER (
						PARTITION BY [DiagnosisOrder] ORDER BY DiagnosisOrder ASC
						) tn
				FROM @BillingDiagnoses
				) AS BD
			WHERE ISNULL(DiagnosisOrder, 0) <= 8

			UPDATE BD
			SET BD.[Order] = BDDO.DiagnosisOrder
			FROM @BillingDiagnoses BD
			INNER JOIN @BillingDiagnosesICD10DiagnosisOrder BDDO ON BD.DSMVCodeId = BDDO.DSMVCodeId
				AND isnull(BD.ICD10Code, '') = isnull(BDDO.ICD10Code, '') -- this can be empty in some cases
				AND isnull(BD.ICD9Code, '') = isnull(BDDO.ICD9Code, '') -- this can be empty in some cases
				AND BD.DiagnosisOrder = BDDO.DiagnosisOrder
				AND BD.[Description] = BDDO.[Description]
				AND BD.Billable = BDDO.Billable

			UPDATE @BillingDiagnoses
			SET DSMVCodeId = NULL
			WHERE DSMVCodeId <= 0
				--DROP TABLE #BillingDiagnosesICD10DiagnosisOrder
		END
	END
	ELSE IF ISNULL(@InitializeDiagnosisOrder, 'N') = 'N'
	BEGIN
		IF @ProgramId > 0
		BEGIN
			IF (@CurDiagnosisDocumentCodeID IS NULL)
			BEGIN
				DECLARE @DiagnosisDSMDescriptionCategories TABLE (
					OrderId INT IDENTITY(1, 1)
					,DSMCode VARCHAR(10)
					,DSMNumber INT
					)

				IF ISNULL(@UseDiagnosisDocument, 'N') = 'Y'
				BEGIN
					IF ISNULL(@DiagnosisDocumentCategory, '') = 'Y'
					BEGIN
						INSERT INTO @DiagnosisDSMDescriptionCategories (
							DSMCode
							,DSMNumber
							)
						SELECT BD.DSMCode
							,BD.DSMNumber
						FROM @BillingDiagnoses BD
						WHERE BD.Billable = 'Y'
						ORDER BY DiagnosisOrder ASC
					END
					ELSE IF ISNULL(@DiagnosisDocumentCategory, '') = 'N'
					BEGIN
						INSERT INTO @DiagnosisDSMDescriptionCategories (
							DSMCode
							,DSMNumber
							)
						SELECT DDC.DSMCode
							,ISNULL(DDC.DSMNumber, 1)
						FROM DiagnosisDSMDescriptionCategories DDC
						INNER JOIN @BillingDiagnoses BD ON DDC.DSMCode = BD.DSMCode
							AND DDC.DSMNumber = BD.DSMNumber
							AND BD.Billable = 'Y'
						LEFT JOIN (
							SELECT PDC.DiagnosisCategory
							FROM ProgramDiagnosisCategories PDC
							INNER JOIN GlobalCodes GC ON PDC.DiagnosisCategory = GC.GlobalCodeId
								AND ISNULL(PDC.RecordDeleted, 'N') = 'N'
								AND ISNULL(GC.RecordDeleted, 'N') = 'N'
							WHERE ProgramId = @ProgramId
							) B ON DDC.DiagnosisCategory = B.DiagnosisCategory
							AND ISNULL(DDC.RecordDeleted, 'N') = 'N'
							AND DDC.DiagnosisCategory IS NOT NULL
						WHERE B.DiagnosisCategory IS NOT NULL
					END
				END

				UPDATE A
				SET [Order] = B.OrderId
				FROM @BillingDiagnoses A
				JOIN @DiagnosisDSMDescriptionCategories B ON A.DSMCode = B.DSMCode
					AND A.DSMNumber = B.DSMNumber
				WHERE B.OrderId <= 8
			END
			ELSE
			BEGIN
				DECLARE @DiagnosisDSMVCodeCategories TABLE (
					OrderId INT IDENTITY(1, 1)
					,ICD10Code VARCHAR(20)
					)

				IF ISNULL(@UseDiagnosisDocument, 'N') = 'Y'
				BEGIN
					IF ISNULL(@DiagnosisDocumentCategory, '') = 'Y'
					BEGIN
						INSERT INTO @DiagnosisDSMVCodeCategories (ICD10Code)
						SELECT DISTINCT BD.ICD10Code
						FROM @BillingDiagnoses BD
						WHERE BD.Billable = 'Y'
					END
					ELSE IF ISNULL(@DiagnosisDocumentCategory, '') = 'N'
					BEGIN
						INSERT INTO @DiagnosisDSMVCodeCategories (ICD10Code)
						SELECT DISTINCT DDC.ICD10Code
						FROM DiagnosisDSMVCodeCategories DDC
						INNER JOIN @BillingDiagnoses BD ON DDC.ICD10Code = BD.ICD10Code
							AND BD.Billable = 'Y'
						LEFT JOIN (
							SELECT PDC.DiagnosisCategory
							FROM ProgramDiagnosisCategories PDC
							INNER JOIN GlobalCodes GC ON PDC.DiagnosisCategory = GC.GlobalCodeId
								AND ISNULL(PDC.RecordDeleted, 'N') = 'N'
								AND ISNULL(GC.RecordDeleted, 'N') = 'N'
							WHERE ProgramId = @ProgramId
							) B ON DDC.DiagnosisCategory = B.DiagnosisCategory
							AND ISNULL(DDC.RecordDeleted, 'N') = 'N'
							AND DDC.DiagnosisCategory IS NOT NULL
						WHERE B.DiagnosisCategory IS NOT NULL
					END
				END

				UPDATE A
				SET [Order] = B.OrderId
				FROM @BillingDiagnoses A
				JOIN @DiagnosisDSMVCodeCategories B ON A.ICD10Code = B.ICD10Code
				WHERE B.OrderId <= 8
			END
		END
	END
	ELSE IF ISNULL(@InitializeDiagnosisOrder, 'N') = 'B'
	BEGIN
		UPDATE @BillingDiagnoses
		SET DSMVCodeId = NULL
			,[Order] = NULL
		WHERE DSMVCodeId <= 0
	END

	SELECT @JsonResult = dbo.smsf_FlattenedJSON((
				SELECT DSMCode
					,DSMNumber
					,SortOrder
					,[Version]
					,DiagnosisOrder
					,DSMVCodeId
					,ICD10Code
					,ICD9Code
					,Description
					,[Order]
				FROM @BillingDiagnoses
				ORDER BY SortOrder
					,DiagnosisOrder
				FOR XML path
					,root
				))

	RETURN REPLACE(@JsonResult, '"', '''')
END
GO



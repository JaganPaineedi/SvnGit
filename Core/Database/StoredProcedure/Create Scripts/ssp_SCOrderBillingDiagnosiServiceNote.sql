IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCOrderBillingDiagnosiServiceNote]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCOrderBillingDiagnosiServiceNote]
GO

CREATE PROCEDURE [dbo].[ssp_SCOrderBillingDiagnosiServiceNote] @DataSetXML XML
	,@Mode CHAR(20)
	,@ProgramId INT
AS /*********************************************************************/
/* Purpose:  it will return the biling diagnosis for the service note  */
/* Updates:                                                          */
/*  Date			Author			Purpose																							*/
/*  --------------------------------------------------------------------------------------------------------------------------------*/
/*  18/JAN/2016		Akwinass		Created (Engineering Improvement Initiatives- NBL(I) #272)*/
/************************************************************************************************************************************/
BEGIN
	BEGIN TRY
		CREATE TABLE #BillingDiagnoses (
			DSMCode CHAR(6)
			,DSMNumber INT
			,DiagnosisOrder INT
			,ICD10Code VARCHAR(20)
			,ICD9Code VARCHAR(20)
			,ICD10CodeId INT
			,DSMDescription VARCHAR(500)
			,[Order] INT
			,[Billable] CHAR(1)
			,[RuleOut] CHAR(1)
			,[RecordDeleted] CHAR(1)
			)

		IF ISNULL(@Mode, '') = 'ICD10'
		BEGIN
			INSERT INTO #BillingDiagnoses (
				ICD10Code
				,ICD9Code
				,ICD10CodeId
				,DSMDescription
				,Billable
				,DiagnosisOrder
				,RuleOut
				,RecordDeleted
				)
			SELECT a.b.value('ICD10Code[1]', 'VARCHAR(20)')
				,a.b.value('ICD9Code[1]', 'VARCHAR(20)')
				,a.b.value('ICD10CodeId[1]', 'INT')
				,a.b.value('DSMDescription[1]', 'VARCHAR(500)')
				,a.b.value('Billable[1]', 'CHAR(1)')
				,a.b.value('DiagnosisOrder[1]', 'INT')
				,a.b.value('RuleOut[1]', 'CHAR(1)')
				,a.b.value('RecordDeleted[1]', 'CHAR(1)')
			FROM @DataSetXML.nodes('NewDataSet/DocumentDiagnosisCodes') a(b)
			WHERE ISNULL(a.b.value('RecordDeleted[1]', 'CHAR(1)'), 'N') = 'N'
		END
		ELSE
		BEGIN
			INSERT INTO #BillingDiagnoses (
				DSMCode
				,DSMNumber
				,DSMDescription
				,Billable
				,DiagnosisOrder
				,RuleOut
				,RecordDeleted
				)
			SELECT a.b.value('DSMCode[1]', 'CHAR(6)')
				,a.b.value('DSMNumber[1]', 'INT')
				,a.b.value('DSMDescription[1]', 'VARCHAR(500)')
				,a.b.value('Billable[1]', 'CHAR(1)')
				,a.b.value('DiagnosisOrder[1]', 'INT')
				,a.b.value('RuleOut[1]', 'CHAR(1)')
				,a.b.value('RecordDeleted[1]', 'CHAR(1)')
			FROM @DataSetXML.nodes('NewDataSet/DiagnosesIAndII') a(b)
			WHERE ISNULL(a.b.value('RecordDeleted[1]', 'CHAR(1)'), 'N') = 'N'
		END

		DECLARE @InitializeDiagnosisOrder CHAR(1)

		SELECT TOP 1 @InitializeDiagnosisOrder = Value
		FROM SystemConfigurationKeys
		WHERE [key] = 'INITIALIZEDIAGNOSISORDER'

		DECLARE @UseProblemListForDiagnosis CHAR(1)
			,@UseDiagnosisDocument CHAR(1)
			,@DiagnosisDocumentCategory CHAR(1)

		IF @ProgramId > 0
		BEGIN
			SELECT @UseProblemListForDiagnosis = UseProblemListForDiagnosis
				,@UseDiagnosisDocument = UseDiagnosisDocument
				,@DiagnosisDocumentCategory = DiagnosisDocumentCategoryAll
			FROM Programs
			WHERE ProgramId = @ProgramId
		END

		IF ISNULL(@InitializeDiagnosisOrder, 'N') = 'N'
		BEGIN
			IF @ProgramId > 0
			BEGIN
				IF (ISNULL(@Mode, '') = '')
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
							FROM #BillingDiagnoses BD
							WHERE BD.Billable = 'Y'
							ORDER BY DiagnosisOrder ASC
						END
						ELSE
							IF ISNULL(@DiagnosisDocumentCategory, '') = 'N'
							BEGIN
								INSERT INTO @DiagnosisDSMDescriptionCategories (
									DSMCode
									,DSMNumber
									)
								SELECT DDC.DSMCode
									,ISNULL(DDC.DSMNumber, 1)
								FROM DiagnosisDSMDescriptionCategories DDC
								INNER JOIN #BillingDiagnoses BD ON DDC.DSMCode = BD.DSMCode
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
					FROM #BillingDiagnoses A
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
							FROM #BillingDiagnoses BD
							WHERE BD.Billable = 'Y'
						END
						ELSE
							IF ISNULL(@DiagnosisDocumentCategory, '') = 'N'
							BEGIN
								INSERT INTO @DiagnosisDSMVCodeCategories (ICD10Code)
								SELECT DISTINCT DDC.ICD10Code
								FROM DiagnosisDSMVCodeCategories DDC
								INNER JOIN #BillingDiagnoses BD ON DDC.ICD10Code = BD.ICD10Code
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
					FROM #BillingDiagnoses A
					JOIN @DiagnosisDSMVCodeCategories B ON A.ICD10Code = B.ICD10Code
					WHERE B.OrderId <= 8
				END
			END
		END

		SELECT DSMCode
			,DSMNumber
			,ICD10CodeId
			,ICD10Code
			,ICD9Code
			,DSMDescription
			,[Order] AS DiagnosisOrder
			,[Billable]
			,[RuleOut]
			,RecordDeleted
		FROM #BillingDiagnoses
		ORDER BY [Order]

		IF (@@error != 0)
		BEGIN
			RAISERROR 20002 'ssp_SCOrderBillingDiagnosiServiceNote: An Error Occured'

			RETURN (1)
		END

		RETURN (0)
	END TRY

	BEGIN CATCH
		DECLARE @error VARCHAR(8000)

		SET @error = CONVERT(VARCHAR, Error_number()) + '*****' + CONVERT(VARCHAR(4000), Error_message()) + '*****' + Isnull(CONVERT(VARCHAR, Error_procedure()), 'ssp_SCOrderBillingDiagnosiServiceNote') + '*****' + CONVERT(VARCHAR, Error_line()) + '*****' + CONVERT(VARCHAR, Error_severity()) + '*****' + CONVERT(VARCHAR, Error_state())

		RAISERROR (
				@error
				,-- Message text.
				16
				,-- Severity.
				1 -- State.
				);
	END CATCH
END

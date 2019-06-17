/********************************************************************************                                                   
-- Purpose: This Script will do Insert into ServiceDiagnosis Table for the Signed Services Which does not has Billing Diagnosis.
-- Author:  Akwinass
-- Date:    18-AUG-2015
/*  Date			Author			Purpose																							*/ 
/*  --------------------------------------------------------------------------------------------------------------------------------*/           
/*  18-AUG-2015    Akwinass         Modified "DSMVCodeId" column to ICD10CodeId*/
*********************************************************************************/
BEGIN TRY
UPDATE DocumentCodes
SET DSMV = 'Y'
WHERE TableList LIKE '%DocumentDiagnosisCodes,%'

IF OBJECT_ID('tempdb..#ServiceIds') IS NOT NULL
	DROP TABLE #ServiceIds
IF OBJECT_ID('tempdb..#BillingDiagnoses') IS NOT NULL
	DROP TABLE #BillingDiagnoses
IF OBJECT_ID('tempdb..#BillingDiagnosesDiagnosisOrder') IS NOT NULL
	DROP TABLE #BillingDiagnosesDiagnosisOrder
IF OBJECT_ID('tempdb..#BillingDiagnosesICD10DiagnosisOrder') IS NOT NULL
	DROP TABLE #BillingDiagnosesICD10DiagnosisOrder
IF OBJECT_ID('tempdb..#BillingDiagnosesDiagnosisOrder1') IS NOT NULL
	DROP TABLE #BillingDiagnosesDiagnosisOrder1
IF OBJECT_ID('tempdb..#BillingDiagnosesICD10DiagnosisOrder1') IS NOT NULL
	DROP TABLE #BillingDiagnosesICD10DiagnosisOrder1

	
CREATE TABLE #ServiceIds (ServiceId INT)

INSERT INTO #ServiceIds
SELECT Doc.ServiceId
FROM Documents Doc
WHERE Doc.[Status] = 22
	AND ISNULL(Doc.RecordDeleted, 'N') = 'N'
	AND ServiceId IS NOT NULL
	AND NOT EXISTS (SELECT * FROM ServiceDiagnosis SD WHERE SD.ServiceId = Doc.ServiceId AND ISNULL(SD.RecordDeleted, 'N') = 'N')
ORDER BY 1 ASC

DECLARE @ServiceId INT
DECLARE @varClientId INT
DECLARE @varDate DATETIME
DECLARE @varProgramId INT
DECLARE @DiagnosisDocumentCodeID INT
DECLARE @CurDiagnosisDocumentCodeID INT
DECLARE @LatestDiagnosisDocumentVersionId INT
DECLARE @varDocumentid INT
	,@varVersion INT
	,@varVersion10 INT
	,@varEffectiveDate DATETIME
DECLARE @UseProblemListForDiagnosis CHAR(1)
	,@UseDiagnosisDocument CHAR(1)
	,@DiagnosisDocumentCategory CHAR(1)
	,@ProgramId INT

CREATE TABLE #BillingDiagnoses (
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

DECLARE FA_cursor CURSOR FAST_FORWARD FOR
SELECT DISTINCT ServiceId FROM #ServiceIds ORDER BY ServiceId ASC

OPEN FA_cursor
FETCH NEXT FROM FA_cursor INTO @ServiceId

WHILE @@FETCH_STATUS = 0
BEGIN
	BEGIN TRY
	IF NOT EXISTS(SELECT * FROM ServiceDiagnosis WHERE ServiceId = @ServiceId AND ISNULL(RecordDeleted, 'N') = 'N')	
	BEGIN
		DELETE FROM #BillingDiagnoses
		SET @varClientId = NULL
		SET @varDate = NULL
		SET @varProgramId = NULL
		SET @DiagnosisDocumentCodeID = NULL
		SET @CurDiagnosisDocumentCodeID = NULL
		SET @LatestDiagnosisDocumentVersionId = NULL
		SET @varDocumentid = NULL
		SET @varVersion = NULL
		SET @varVersion10 = NULL
		SET @varEffectiveDate = NULL
		SET @UseProblemListForDiagnosis = NULL
		SET @UseDiagnosisDocument = NULL
		SET @DiagnosisDocumentCategory = NULL
		SET @ProgramId = NULL
		
		SELECT @varClientId = ClientId,@varDate = DateOfService,@varProgramId = ProgramId FROM Services WHERE ServiceId = @ServiceId AND ISNULL(RecordDeleted, 'N') = 'N'

		IF (@varDate IS NULL)
			SET @varDate = getdate()
				
		SELECT TOP 1 @varVersion10 = CurrentDocumentVersionId
		FROM DocumentDiagnosisCodes DI
			,Documents Doc
		WHERE DI.DocumentVersionId = Doc.CurrentDocumentVersionId
			AND Doc.ClientId = @varClientId
			AND Doc.[Status] = 22
			AND IsNull(DI.RecordDeleted, 'N') = 'N'
			AND IsNull(Doc.RecordDeleted, 'N') = 'N'
			AND Doc.EffectiveDate <= convert(DATETIME, convert(VARCHAR, @varDate, 101))
		ORDER BY Doc.EffectiveDate DESC
			,Doc.ModifiedDate DESC
			
		IF @varClientId	 > 0
		BEGIN
		SET @ProgramId = @varProgramId

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
				WHERE a.ClientId = @varClientId
					AND a.[Status] = 22
					AND Dc.DiagnosisDocument = 'Y'
					AND a.EffectiveDate <= CONVERT(DATETIME, CONVERT(VARCHAR, GETDATE(), 101))
					AND isNull(a.RecordDeleted, 'N') <> 'Y'
					AND isNull(Dc.RecordDeleted, 'N') <> 'Y'
				ORDER BY a.EffectiveDate DESC
					,a.ModifiedDate DESC
				)
			
				

		SET @DiagnosisDocumentCodeID = (SELECT TOP 1 DocumentCodeId FROM Documents WHERE CurrentDocumentVersionId = @LatestDiagnosisDocumentVersionId)
		SET @CurDiagnosisDocumentCodeID = (SELECT TOP 1 DocumentCodeId FROM DocumentCodes WHERE DocumentCodeId = @DiagnosisDocumentCodeID AND DSMV = 'Y')

		IF (@CurDiagnosisDocumentCodeID IS NULL)
		BEGIN	
			IF (ISNULL(@UseDiagnosisDocument, '') = '' AND ISNULL(@UseProblemListForDiagnosis, 'N') = 'N') OR ISNULL(@UseDiagnosisDocument, '') = 'Y' OR @ProgramId <= 0 
			BEGIN
				INSERT INTO #BillingDiagnoses (DSMCode,DsmNumber,SortOrder,DiagnosisOrder,Description,Billable)
				SELECT D.DSMCode,D.DSMNumber ,CASE WHEN DiagnosisType = 140	THEN 1 ELSE 2 END AS SortOrder,DiagnosisOrder,DD.DSMDescription,ISNULL(D.Billable, 'N')
				FROM dbo.DiagnosesIAndII D
				JOIN DiagnosisDSMDescriptions DD ON DD.DSMCode = D.DSMCode
					AND DD.DSMNumber = D.DSMNumber
				WHERE DocumentVersionId = @LatestDiagnosisDocumentVersionId
					AND ISNULL(D.RecordDeleted, 'N') = 'N'
			END

			IF ISNULL(@UseProblemListForDiagnosis, 'N') = 'Y'
			BEGIN
				INSERT INTO #BillingDiagnoses (DSMCode,DsmNumber,Description,Billable)
				SELECT CP.DSMCode,NULL,DC.ICDDescription,'N'
				FROM ClientProblems CP
				JOIN DiagnosisICDCodes DC ON CP.DSMCode = DC.ICDCode
					AND ISNULL(CP.RecordDeleted, 'N') = 'N'
				WHERE CP.ClientId = @varClientId
					AND CP.DSMCode NOT IN (SELECT DISTINCT DSMCode FROM #BillingDiagnoses)
			END
		END
		ELSE
		BEGIN	
			IF (ISNULL(@UseDiagnosisDocument, '') = '' AND ISNULL(@UseProblemListForDiagnosis, 'N') = 'N') OR ISNULL(@UseDiagnosisDocument, '') = 'Y' OR @ProgramId <= 0
			BEGIN
				INSERT INTO #BillingDiagnoses (DSMVCodeId,ICD10Code,ICD9Code,DiagnosisOrder,Description,Billable)
				SELECT D.ICD10CodeId,D.ICD10Code,D.ICD9Code,D.DiagnosisOrder,DD.ICDDescription AS DSMDescription,ISNULL(D.Billable, 'N')
				FROM DocumentDiagnosisCodes D
				JOIN DiagnosisICD10Codes DD ON D.ICD10CodeId = DD.ICD10CodeId AND D.ICD10Code = DD.ICD10Code
				WHERE DocumentVersionId = @LatestDiagnosisDocumentVersionId
					AND ISNULL(D.RecordDeleted, 'N') = 'N'
			END

			IF ISNULL(@UseProblemListForDiagnosis, 'N') = 'Y'
			BEGIN
				IF (SELECT COUNT(*) FROM #BillingDiagnoses) = 0
				BEGIN
					INSERT INTO #BillingDiagnoses (DSMCode,DsmNumber,Description,Billable)
					SELECT CP.DSMCode,NULL,DC.ICDDescription,'N'
					FROM ClientProblems CP
					JOIN DiagnosisICDCodes DC ON CP.DSMCode = DC.ICDCode
						AND ISNULL(CP.RecordDeleted, 'N') = 'N'
					WHERE CP.ClientId = @varClientId
				END
			END
		END
		
		IF (@CurDiagnosisDocumentCodeID IS NULL)
		BEGIN
			IF OBJECT_ID('tempdb..#BillingDiagnosesDiagnosisOrder') IS NOT NULL
				DROP TABLE #BillingDiagnosesDiagnosisOrder
			CREATE TABLE #BillingDiagnosesDiagnosisOrder (DSMCode CHAR(6),DSMNumber INT,SortOrder INT,DiagnosisOrder INT,[Description] VARCHAR(500),[Billable] CHAR(1))
		   
			INSERT INTO #BillingDiagnosesDiagnosisOrder(DSMCode,DsmNumber,SortOrder,DiagnosisOrder,[Description],Billable)
			SELECT DSMCode,DsmNumber,SortOrder,DiagnosisOrder,[Description],Billable
			FROM (SELECT *,ROW_NUMBER() OVER (PARTITION BY [DiagnosisOrder] ORDER BY DiagnosisOrder ASC) tn FROM #BillingDiagnoses) AS BD
			WHERE tn = 1 AND
			ISNULL(DiagnosisOrder, 0) <= 8
			
			UPDATE BD
			SET BD.[Order] = BDDO.DiagnosisOrder
			FROM #BillingDiagnoses BD
			INNER JOIN #BillingDiagnosesDiagnosisOrder BDDO ON BD.DSMCode = BDDO.DSMCode
				AND BD.DsmNumber = BDDO.DsmNumber
				AND BD.SortOrder = BDDO.SortOrder
				AND BD.DiagnosisOrder = BDDO.DiagnosisOrder
				AND BD.[Description] = BDDO.[Description]
				AND BD.Billable = BDDO.Billable		
		END
		ELSE
		BEGIN
			IF OBJECT_ID('tempdb..#BillingDiagnosesICD10DiagnosisOrder') IS NOT NULL
				DROP TABLE #BillingDiagnosesICD10DiagnosisOrder
			CREATE TABLE #BillingDiagnosesICD10DiagnosisOrder (DSMVCodeId INT,ICD10Code VARCHAR(20),ICD9Code VARCHAR(20),DiagnosisOrder INT,[Description] VARCHAR(500),[Billable] CHAR(1))
			
			INSERT INTO #BillingDiagnosesICD10DiagnosisOrder(DSMVCodeId,ICD10Code,ICD9Code, DiagnosisOrder,[Description],Billable)
			SELECT DSMVCodeId,ICD10Code,ICD9Code, DiagnosisOrder,[Description],Billable
			FROM (SELECT *,ROW_NUMBER() OVER (PARTITION BY [DiagnosisOrder] ORDER BY DiagnosisOrder ASC) tn FROM #BillingDiagnoses) AS BD
			WHERE tn = 1 AND
			ISNULL(DiagnosisOrder, 0) <= 8
			
			UPDATE BD
			SET BD.[Order] = BDDO.DiagnosisOrder
			FROM #BillingDiagnoses BD
			INNER JOIN #BillingDiagnosesICD10DiagnosisOrder BDDO ON BD.DSMVCodeId = BDDO.DSMVCodeId
				AND BD.ICD10Code = BDDO.ICD10Code
				AND BD.ICD9Code = BDDO.ICD9Code
				AND BD.DiagnosisOrder = BDDO.DiagnosisOrder
				AND BD.[Description] = BDDO.[Description]
				AND BD.Billable = BDDO.Billable
		END
		
		IF NOT EXISTS(SELECT * FROM ServiceDiagnosis WHERE ServiceId = @ServiceId AND ISNULL(RecordDeleted, 'N') = 'N')	
		BEGIN
			INSERT INTO ServiceDiagnosis(ServiceId,DSMCode,DSMNumber,DSMVCodeId,ICD10Code,ICD9Code,[Order])
			SELECT @ServiceId,DSMCode,DSMNumber,DSMVCodeId,ICD10Code,ICD9Code,[Order] FROM  #BillingDiagnoses WHERE ISNULL(DiagnosisOrder, 0) BETWEEN 1 AND 8  ORDER BY [Order] ASC
		END
		
		IF (SELECT COUNT(*) FROM #BillingDiagnoses) = 0
		BEGIN
			SET @LatestDiagnosisDocumentVersionId = (
				SELECT TOP 1 CurrentDocumentVersionId
				FROM Documents a
				INNER JOIN DocumentCodes Dc ON Dc.DocumentCodeid = a.DocumentCodeid
				WHERE a.ClientId = @varClientId
					AND a.[Status] = 22
					AND Dc.DiagnosisDocument = 'Y'
					AND Dc.DocumentCodeId IN (5,1601)
					AND a.EffectiveDate <= CONVERT(DATETIME, CONVERT(VARCHAR, GETDATE(), 101))
					AND isNull(a.RecordDeleted, 'N') <> 'Y'
					AND isNull(Dc.RecordDeleted, 'N') <> 'Y'
				ORDER BY a.EffectiveDate DESC
					,a.ModifiedDate DESC
				)
			
				

			SET @DiagnosisDocumentCodeID = (SELECT TOP 1 DocumentCodeId FROM Documents WHERE CurrentDocumentVersionId = @LatestDiagnosisDocumentVersionId)
			SET @CurDiagnosisDocumentCodeID = (SELECT TOP 1 DocumentCodeId FROM DocumentCodes WHERE DocumentCodeId = @DiagnosisDocumentCodeID AND DSMV = 'Y')
			
			IF (@CurDiagnosisDocumentCodeID IS NULL)
			BEGIN	
				IF (ISNULL(@UseDiagnosisDocument, '') = '' AND ISNULL(@UseProblemListForDiagnosis, 'N') = 'N') OR ISNULL(@UseDiagnosisDocument, '') = 'Y' OR @ProgramId <= 0 
				BEGIN
					INSERT INTO #BillingDiagnoses (DSMCode,DsmNumber,SortOrder,DiagnosisOrder,Description,Billable)
					SELECT D.DSMCode,D.DSMNumber ,CASE WHEN DiagnosisType = 140	THEN 1 ELSE 2 END AS SortOrder,DiagnosisOrder,DD.DSMDescription,ISNULL(D.Billable, 'N')
					FROM dbo.DiagnosesIAndII D
					JOIN DiagnosisDSMDescriptions DD ON DD.DSMCode = D.DSMCode
						AND DD.DSMNumber = D.DSMNumber
					WHERE DocumentVersionId = @LatestDiagnosisDocumentVersionId
						AND ISNULL(D.RecordDeleted, 'N') = 'N'
				END

				IF ISNULL(@UseProblemListForDiagnosis, 'N') = 'Y'
				BEGIN
					INSERT INTO #BillingDiagnoses (DSMCode,DsmNumber,Description,Billable)
					SELECT CP.DSMCode,NULL,DC.ICDDescription,'N'
					FROM ClientProblems CP
					JOIN DiagnosisICDCodes DC ON CP.DSMCode = DC.ICDCode
						AND ISNULL(CP.RecordDeleted, 'N') = 'N'
					WHERE CP.ClientId = @varClientId
						AND CP.DSMCode NOT IN (SELECT DISTINCT DSMCode FROM #BillingDiagnoses)
				END
			END
			ELSE
			BEGIN	
				IF (ISNULL(@UseDiagnosisDocument, '') = '' AND ISNULL(@UseProblemListForDiagnosis, 'N') = 'N') OR ISNULL(@UseDiagnosisDocument, '') = 'Y' OR @ProgramId <= 0
				BEGIN
					INSERT INTO #BillingDiagnoses (DSMVCodeId,ICD10Code,ICD9Code,DiagnosisOrder,Description,Billable)
					SELECT D.ICD10CodeId,D.ICD10Code,D.ICD9Code,D.DiagnosisOrder,DD.ICDDescription AS DSMDescription,ISNULL(D.Billable, 'N')
					FROM DocumentDiagnosisCodes D
					JOIN DiagnosisICD10Codes DD ON D.ICD10CodeId = DD.ICD10CodeId AND D.ICD10Code = DD.ICD10Code
					WHERE DocumentVersionId = @LatestDiagnosisDocumentVersionId
						AND ISNULL(D.RecordDeleted, 'N') = 'N'
				END

				IF ISNULL(@UseProblemListForDiagnosis, 'N') = 'Y'
				BEGIN
					IF (SELECT COUNT(*) FROM #BillingDiagnoses) = 0
					BEGIN
						INSERT INTO #BillingDiagnoses (DSMCode,DsmNumber,Description,Billable)
						SELECT CP.DSMCode,NULL,DC.ICDDescription,'N'
						FROM ClientProblems CP
						JOIN DiagnosisICDCodes DC ON CP.DSMCode = DC.ICDCode
							AND ISNULL(CP.RecordDeleted, 'N') = 'N'
						WHERE CP.ClientId = @varClientId
					END
				END
			END
			
			IF (@CurDiagnosisDocumentCodeID IS NULL)
			BEGIN
				IF OBJECT_ID('tempdb..#BillingDiagnosesDiagnosisOrder1') IS NOT NULL
					DROP TABLE #BillingDiagnosesDiagnosisOrder1
				CREATE TABLE #BillingDiagnosesDiagnosisOrder1 (DSMCode CHAR(6),DSMNumber INT,SortOrder INT,DiagnosisOrder INT,[Description] VARCHAR(500),[Billable] CHAR(1))
			   
				INSERT INTO #BillingDiagnosesDiagnosisOrder1(DSMCode,DsmNumber,SortOrder,DiagnosisOrder,[Description],Billable)
				SELECT DSMCode,DsmNumber,SortOrder,DiagnosisOrder,[Description],Billable
				FROM (SELECT *,ROW_NUMBER() OVER (PARTITION BY [DiagnosisOrder] ORDER BY DiagnosisOrder ASC) tn FROM #BillingDiagnoses) AS BD
				WHERE tn = 1 AND
				ISNULL(DiagnosisOrder, 0) <= 8
				
				UPDATE BD
				SET BD.[Order] = BDDO.DiagnosisOrder
				FROM #BillingDiagnoses BD
				INNER JOIN #BillingDiagnosesDiagnosisOrder1 BDDO ON BD.DSMCode = BDDO.DSMCode
					AND BD.DsmNumber = BDDO.DsmNumber
					AND BD.SortOrder = BDDO.SortOrder
					AND BD.DiagnosisOrder = BDDO.DiagnosisOrder
					AND BD.[Description] = BDDO.[Description]
					AND BD.Billable = BDDO.Billable		
			END
			ELSE
			BEGIN
				IF OBJECT_ID('tempdb..#BillingDiagnosesICD10DiagnosisOrder1') IS NOT NULL
					DROP TABLE #BillingDiagnosesICD10DiagnosisOrder1
				CREATE TABLE #BillingDiagnosesICD10DiagnosisOrder1 (DSMVCodeId INT,ICD10Code VARCHAR(20),ICD9Code VARCHAR(20),DiagnosisOrder INT,[Description] VARCHAR(500),[Billable] CHAR(1))
				
				INSERT INTO #BillingDiagnosesICD10DiagnosisOrder1(DSMVCodeId,ICD10Code,ICD9Code, DiagnosisOrder,[Description],Billable)
				SELECT DSMVCodeId,ICD10Code,ICD9Code, DiagnosisOrder,[Description],Billable
				FROM (SELECT *,ROW_NUMBER() OVER (PARTITION BY [DiagnosisOrder] ORDER BY DiagnosisOrder ASC) tn FROM #BillingDiagnoses) AS BD
				WHERE tn = 1 AND
				ISNULL(DiagnosisOrder, 0) <= 8
				
				UPDATE BD
				SET BD.[Order] = BDDO.DiagnosisOrder
				FROM #BillingDiagnoses BD
				INNER JOIN #BillingDiagnosesICD10DiagnosisOrder1 BDDO ON BD.DSMVCodeId = BDDO.DSMVCodeId
					AND BD.ICD10Code = BDDO.ICD10Code
					AND BD.ICD9Code = BDDO.ICD9Code
					AND BD.DiagnosisOrder = BDDO.DiagnosisOrder
					AND BD.[Description] = BDDO.[Description]
					AND BD.Billable = BDDO.Billable
			END
			
			IF NOT EXISTS(SELECT * FROM ServiceDiagnosis WHERE ServiceId = @ServiceId AND ISNULL(RecordDeleted, 'N') = 'N')	
			BEGIN
				INSERT INTO ServiceDiagnosis(ServiceId,DSMCode,DSMNumber,DSMVCodeId,ICD10Code,ICD9Code,[Order])
				SELECT @ServiceId,DSMCode,DSMNumber,DSMVCodeId,ICD10Code,ICD9Code,[Order] FROM  #BillingDiagnoses WHERE ISNULL(DiagnosisOrder, 0) BETWEEN 1 AND 8  ORDER BY [Order] ASC
			END			
		END

		END	
    END
    
    END TRY
	BEGIN CATCH
		 PRINT 'ERROR' + CAST(@ServiceId AS VARCHAR(25))
	END CATCH
    FETCH NEXT FROM FA_cursor INTO @ServiceId
END

CLOSE FA_cursor
DEALLOCATE FA_cursor

IF OBJECT_ID('tempdb..#ServiceIds') IS NOT NULL
	DROP TABLE #ServiceIds
END TRY
BEGIN CATCH
     PRINT 'ERROR'
END CATCH
UPDATE ClientOrdersDiagnosisIIICodes
SET RecordDeleted = 'Y'
	,DeletedBy = 'TexasGoLiveBuildIssues255'
	,DeletedDate = GETDATE()
WHERE DiagnosisIIICodeId IN (
		SELECT DiagnosisIIICodeId
		FROM (
			SELECT ROW_NUMBER() OVER (
					PARTITION BY ClientOrderId
					,ICD10CodeId ORDER BY ClientOrderId
					) AS RowNum
				,ClientOrderId
				,ICDCode
				,[Description]
				,ICD10CodeId
				,DiagnosisIIICodeId
			FROM ClientOrdersDiagnosisIIICodes
			) AS DiagnosisIIICodes
		WHERE RowNum > 1
		)
	AND ISNULL(RecordDeleted, 'N') = 'N'


UPDATE DocumentVersions
SET RefreshView = 'Y'
WHERE DocumentVersionId IN (
		SELECT CurrentDocumentVersionId
		FROM Documents
		WHERE DocumentCodeId = 1653
			AND ISNULL(RecordDeleted, 'N') = 'N'
			AND [Status] = 22
		)
	AND ISNULL(RecordDeleted, 'N') = 'N'

UPDATE DocumentVersions
SET RefreshView = 'Y'
WHERE DocumentVersionId IN (
		SELECT InProgressDocumentVersionId
		FROM Documents
		WHERE DocumentCodeId = 1653
			AND ISNULL(RecordDeleted, 'N') = 'N'
			AND [Status] = 22
		)
	AND ISNULL(RecordDeleted, 'N') = 'N'
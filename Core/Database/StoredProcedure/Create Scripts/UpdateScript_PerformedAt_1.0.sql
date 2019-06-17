IF OBJECT_ID('PHQ9Documents') IS NOT NULL
BEGIN
	IF COL_LENGTH('PHQ9Documents', 'PerformedAt') IS NOT NULL
	BEGIN
		UPDATE P
		SET P.PerformedAt = D.CreatedDate
			,P.ModifiedBy = 'AHN-Support Go Live #522'
			,P.ModifiedDate = GETDATE()
		FROM Documents D
		JOIN PHQ9Documents P ON D.InProgressDocumentVersionId = P.DocumentVersionId
			AND ISNULL(D.RecordDeleted, 'N') = 'N'
			AND ISNULL(P.RecordDeleted, 'N') = 'N'
			AND P.PerformedAt IS NULL

		UPDATE P
		SET P.PerformedAt = D.CreatedDate
			,P.ModifiedBy = 'AHN-Support Go Live #522'
			,P.ModifiedDate = GETDATE()
		FROM Documents D
		JOIN PHQ9Documents P ON D.CurrentDocumentVersionId = P.DocumentVersionId
			AND ISNULL(D.RecordDeleted, 'N') = 'N'
			AND ISNULL(P.RecordDeleted, 'N') = 'N'
			AND P.PerformedAt IS NULL
	END
END

IF OBJECT_ID('PHQ9ADocuments') IS NOT NULL
BEGIN
	IF COL_LENGTH('PHQ9ADocuments', 'PerformedAt') IS NOT NULL
	BEGIN
		UPDATE P
		SET P.PerformedAt = D.CreatedDate
			,P.ModifiedBy = 'AHN-Support Go Live #522'
			,P.ModifiedDate = GETDATE()
		FROM Documents D
		JOIN PHQ9ADocuments P ON D.InProgressDocumentVersionId = P.DocumentVersionId
			AND ISNULL(D.RecordDeleted, 'N') = 'N'
			AND ISNULL(P.RecordDeleted, 'N') = 'N'
			AND P.PerformedAt IS NULL

		UPDATE P
		SET P.PerformedAt = D.CreatedDate
			,P.ModifiedBy = 'AHN-Support Go Live #522'
			,P.ModifiedDate = GETDATE()
		FROM Documents D
		JOIN PHQ9ADocuments P ON D.CurrentDocumentVersionId = P.DocumentVersionId
			AND ISNULL(D.RecordDeleted, 'N') = 'N'
			AND ISNULL(P.RecordDeleted, 'N') = 'N'
			AND P.PerformedAt IS NULL
	END
END

IF OBJECT_ID('SuicideRiskAssessmentDocuments') IS NOT NULL
BEGIN
	IF COL_LENGTH('SuicideRiskAssessmentDocuments', 'PerformedAt') IS  NOT NULL
	BEGIN
		UPDATE P
		SET P.PerformedAt = D.CreatedDate
			,P.ModifiedBy = 'AHN-Support Go Live #522'
			,P.ModifiedDate = GETDATE()
		FROM Documents D
		JOIN SuicideRiskAssessmentDocuments P ON D.InProgressDocumentVersionId = P.DocumentVersionId
			AND ISNULL(D.RecordDeleted, 'N') = 'N'
			AND ISNULL(P.RecordDeleted, 'N') = 'N'
			AND P.PerformedAt IS NULL

		UPDATE P
		SET P.PerformedAt = D.CreatedDate
			,P.ModifiedBy = 'AHN-Support Go Live #522'
			,P.ModifiedDate = GETDATE()
		FROM Documents D
		JOIN SuicideRiskAssessmentDocuments P ON D.CurrentDocumentVersionId = P.DocumentVersionId
			AND ISNULL(D.RecordDeleted, 'N') = 'N'
			AND ISNULL(P.RecordDeleted, 'N') = 'N'
			AND P.PerformedAt IS NULL
	END
END

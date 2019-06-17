-- XCQM161SuicideAssessmentDocCodes
BEGIN
	DECLARE @SUICIDERISK_RecodeCategoryId INT = 0

	SELECT @SUICIDERISK_RecodeCategoryId = RecodeCategoryId
	FROM RecodeCategories
	WHERE CategoryCode = 'XCQM161SuicideAssessmentDocCodes'

	IF iSNULL(@SUICIDERISK_RecodeCategoryId, 0) = 0
	BEGIN
		INSERT INTO RecodeCategories (
			CategoryCode
			,CategoryName
			,[Description]
			,MappingEntity
			)
		VALUES (
			'XCQM161SuicideAssessmentDocCodes'
			,'XCQM161SuicideAssessmentDocCodes'
			,'Group of Document Codes for Suicide and Risk Assessment Documents'
			,'DocumentCodeId'
			)

		SET @SUICIDERISK_RecodeCategoryId = SCOPE_IDENTITY()
	END

	INSERT INTO dbo.recodes (
		integercodeid
		,fromdate
		,recodecategoryid
		)
	SELECT d.DocumentCodeId
		,Getdate()
		,@SUICIDERISK_RecodeCategoryId
	FROM DocumentCodes d
	WHERE d.DocumentName LIKE '%risk%'
		AND NOT EXISTS (
			SELECT 1
			FROM recodes
			WHERE integercodeid = d.DocumentCodeId
			)
END

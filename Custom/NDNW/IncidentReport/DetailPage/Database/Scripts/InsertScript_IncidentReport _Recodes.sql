DECLARE @RecodeCategoryId INT
-- Insertion Recode Categories

IF NOT EXISTS (
		SELECT *
		FROM RecodeCategories
		WHERE CategoryCode = 'XBrian’s House'
		)
BEGIN
	INSERT INTO RecodeCategories (
		CategoryCode
		,CategoryName
		,Description
		,MappingEntity
		)
	VALUES (
		'XBrian’s House'
		,'Brian’s House'
		,'Brian’s House'
		,'ProgramId'
		)

	SET @RecodeCategoryId = @@IDENTITY
END
ELSE
BEGIN
	SELECT TOP 1 @RecodeCategoryId = RecodeCategoryId
	FROM RecodeCategories
	WHERE CategoryCode = 'XBrian’s House'
END

--INSERT INTO Recodes

--IF NOT EXISTS (
--		SELECT *
--		FROM Recodes
--		WHERE IntegerCodeId = '77'
--			AND RecodeCategoryId = @RecodeCategoryId
--			AND CodeName = 'Brian’s House'
--		)
--BEGIN
--	INSERT INTO Recodes (
--		IntegerCodeId
--		,CodeName
--		,FromDate
--		,ToDate
--		,RecodeCategoryId
--		)
--	VALUES (
--		'77'
--		,'Brian’s House'
--		,GETDATE()
--		,NULL
--		,@RecodeCategoryId
--		)
--END

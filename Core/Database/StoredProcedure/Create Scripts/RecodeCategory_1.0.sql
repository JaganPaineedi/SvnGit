
-- Insertion Recode Categories
-- Task:  Comprehensive SGL #11
-- Date: Dec/05/2018


IF NOT EXISTS (
		SELECT *
		FROM RecodeCategories
		WHERE CategoryCode = 'ClientFeeListProgramType'
		)
BEGIN
	INSERT INTO RecodeCategories (
		CategoryCode
		,CategoryName
		,Description
		,MappingEntity
		)
	VALUES (
		'ClientFeeListProgramType'
		,'ProgramType'
		,'ProgramType'
		,'GlobalCodeId'
		)

	
END

DELETE FROM GLOBALCODES WHERE CATEGORY = 'FORMTYPE'

SET IDENTITY_INSERT dbo.GlobalCodes ON
IF EXISTS(SELECT 1 FROM GlobalCodeCategories WHERE Category = 'FORMTYPE')
BEGIN
	IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE Category = 'FORMTYPE' AND Code = 'ListPage')
	BEGIN
		INSERT INTO [GlobalCodes]
				(
				[GlobalCodeId]
				,[Category]
				,[CodeName]
				,[Code]
				,[Description]
				,[Active]
				,[CannotModifyNameOrDelete]
				,[SortOrder]
				,[ExternalCode1]
				,[ExternalSource1]
				,[ExternalCode2]
				,[ExternalSource2]
				,[Bitmap]
				,[BitmapImage]
				,[Color])
			VALUES
				(
				9470
				,'FORMTYPE'
				,'List Page'
				,'ListPage'
				,NULL
				,'Y'
				,'N'
				,NULL
				,NULL
				,NULL
				,NULL
				,NULL
				,NULL
				,NULL
				,NULL)
	END



	IF NOT EXISTS(SELECT 1 FROM GlobalCodes WHERE Category = 'FORMTYPE' AND Code = 'Documents')
	BEGIN
		INSERT INTO [GlobalCodes]
				(
				[GlobalCodeId]
				,[Category]
				,[CodeName]
				,[Code]
				,[Description]
				,[Active]
				,[CannotModifyNameOrDelete]
				,[SortOrder]
				,[ExternalCode1]
				,[ExternalSource1]
				,[ExternalCode2]
				,[ExternalSource2]
				,[Bitmap]
				,[BitmapImage]
				,[Color])
			VALUES
				(9469,
				'FORMTYPE'
				,'Documents'
				,'Documents'
				,NULL
				,'Y'
				,'N'
				,NULL
				,NULL
				,NULL
				,NULL
				,NULL
				,NULL
				,NULL
				,NULL)
	END
	
	IF NOT EXISTS(SELECT 1 FROM GlobalCodes WHERE Category = 'FORMTYPE' AND Code = 'DetailPage')
	BEGIN
		INSERT INTO [GlobalCodes]
				(
				[GlobalCodeId]
				,[Category]
				,[CodeName]
				,[Code]
				,[Description]
				,[Active]
				,[CannotModifyNameOrDelete]
				,[SortOrder]
				,[ExternalCode1]
				,[ExternalSource1]
				,[ExternalCode2]
				,[ExternalSource2]
				,[Bitmap]
				,[BitmapImage]
				,[Color])
			VALUES
				(9468
				,'FORMTYPE'
				,'Detail Page'
				,'DetailPage'
				,NULL
				,'Y'
				,'N'
				,NULL
				,NULL
				,NULL
				,NULL
				,NULL
				,NULL
				,NULL
				,NULL)
	END
	
	
	IF NOT EXISTS(SELECT 1 FROM GlobalCodes WHERE Category = 'FORMTYPE' AND Code = 'CustomFields')
	BEGIN
		INSERT INTO [GlobalCodes]
				(GlobalCodeId
				,[Category]
				,[CodeName]
				,[Code]
				,[Description]
				,[Active]
				,[CannotModifyNameOrDelete]
				,[SortOrder]
				,[ExternalCode1]
				,[ExternalSource1]
				,[ExternalCode2]
				,[ExternalSource2]
				,[Bitmap]
				,[BitmapImage]
				,[Color])
			VALUES
				( 9467	
				,'FORMTYPE'
				,'Custom Fields'
				,'CustomFields'
				,NULL
				,'Y'
				,'N'
				,NULL
				,NULL
				,NULL
				,NULL
				,NULL
				,NULL
				,NULL
				,NULL)
	END
END
SET IDENTITY_INSERT dbo.GlobalCodes OFF
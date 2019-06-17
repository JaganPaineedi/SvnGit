


DELETE FROM GLOBALCODES WHERE CATEGORY = 'FORMCOLLECTIONTYPE'

--SET IDENTITY_INSERT dbo.GlobalCodes ON
IF EXISTS(SELECT 1 FROM GlobalCodeCategories WHERE Category = 'FORMCOLLECTIONTYPE')
BEGIN
	IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE Category = 'FORMCOLLECTIONTYPE' AND Code = 'ListPage')
	BEGIN
		INSERT INTO [GlobalCodes]
				(
				[Category]
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
				'FORMCOLLECTIONTYPE'
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



	IF NOT EXISTS(SELECT 1 FROM GlobalCodes WHERE Category = 'FORMCOLLECTIONTYPE' AND Code = 'Documents')
	BEGIN
		INSERT INTO [GlobalCodes]
				(
				[Category]
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
				('FORMCOLLECTIONTYPE'
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
	
	IF NOT EXISTS(SELECT 1 FROM GlobalCodes WHERE Category = 'FORMCOLLECTIONTYPE' AND Code = 'DetailPage')
	BEGIN
		INSERT INTO [GlobalCodes]
				(
				[Category]
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
				('FORMCOLLECTIONTYPE'
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
	
	
END
--SET IDENTITY_INSERT dbo.GlobalCodes OFF
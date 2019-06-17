IF EXISTS(SELECT 1 FROM GlobalCodeCategories WHERE Category = 'XVACCINEREACTION')
BEGIN
	IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE Category = 'XVACCINEREACTION' AND CodeName = 'No adverse reaction noted')
	BEGIN
		INSERT INTO [GlobalCodes]
				([CreatedBy]
				,[CreatedDate]
				,[ModifiedBy]
				,[ModifiedDate]
				,[RecordDeleted]
				,[DeletedBy]
				,[DeletedDate]
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
				('sfarber'
				,CAST('20161011 13:26:16.737' as DATETIME)
				,'sfarber'
				,CAST('20161011 13:26:16.737' as DATETIME)
				,NULL
				,NULL
				,NULL
				,'XVACCINEREACTION'
				,'No adverse reaction noted'
				,NULL
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



	IF NOT EXISTS(SELECT 1 FROM GlobalCodes WHERE Category = 'XVACCINEREACTION' AND CodeName = 'Adverse reaction noted')
	BEGIN
		INSERT INTO [GlobalCodes]
				([CreatedBy]
				,[CreatedDate]
				,[ModifiedBy]
				,[ModifiedDate]
				,[RecordDeleted]
				,[DeletedBy]
				,[DeletedDate]
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
				('sfarber'
				,CAST('20161011 13:26:16.737' as DATETIME)
				,'sfarber'
				,CAST('20161011 13:26:16.737' as DATETIME)
				,NULL
				,NULL
				,NULL
				,'XVACCINEREACTION'
				,'Adverse reaction noted'
				,NULL
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
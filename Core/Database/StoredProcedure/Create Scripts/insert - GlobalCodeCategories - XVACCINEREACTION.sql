IF NOT EXISTS(SELECT 1 FROM GlobalCodeCategories WHERE Category = 'XVACCINEREACTION')
BEGIN
		INSERT INTO [GlobalCodeCategories]
				([Category]
				,[CategoryName]
				,[Active]
				,[AllowAddDelete]
				,[AllowCodeNameEdit]
				,[AllowSortOrderEdit]
				,[Description]
				,[UserDefinedCategory]
				,[HasSubcodes]
				,[UsedInPracticeManagement]
				,[UsedInCareManagement]
				,[ExternalReferenceId]
				,[RowIdentifier]
				,[CreatedBy]
				,[CreatedDate]
				,[ModifiedBy]
				,[ModifiedDate]
				,[RecordDeleted]
				,[DeletedDate]
				,[DeletedBy])
			VALUES
				('XVACCINEREACTION'
				,'XVACCINEREACTION'
				,'Y'
				,'Y'
				,'Y'
				,'Y'
				,NULL
				,'Y'
				,'Y'
				,NULL
				,NULL
				,NULL
				,CAST ('2848747a-0c6c-47a3-9acc-df6906736cd8' as uniqueidentifier)
				,'sfarber'
				,CAST('20161011 13:23:55.680' as DATETIME)
				,'sfarber'
				,CAST('20161011 13:23:55.680' as DATETIME)
				,NULL
				,NULL
				,NULL)
END
GO

--Why: MHP-Customizations - Task 121

IF EXISTS(SELECT 1 FROM GlobalCodeCategories WHERE Category = 'PERMISSIONTEMPLATETP')
BEGIN
	IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE Category = 'PERMISSIONTEMPLATETP' AND CodeName = 'Tool Tip')
	BEGIN
	SET IDENTITY_INSERT GlobalCodes ON
		INSERT INTO [GlobalCodes]
				(
				[GlobalCodeId]
				,[CreatedBy]
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
				(
				5930
				,'Streamline'
				,GETDATE()
				,'Streamline'
				,GETDATE()
				,NULL
				,NULL
				,NULL
				,'PERMISSIONTEMPLATETP'
				,'Tool Tip'
				,'TOOLTIP'
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
				
				SET IDENTITY_INSERT GlobalCodes OFF
	END

END

	
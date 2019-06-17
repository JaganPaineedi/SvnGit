IF NOT EXISTS (SELECT TOP 1 * FROM SystemConfigurationKeys WHERE [Key]='ShowCustomTabInCMClientAuthorization')
	BEGIN
		INSERT INTO [SystemConfigurationKeys]
           ([CreatedBy]
           ,[CreateDate]
           ,[ModifiedBy]
           ,[ModifiedDate]
           ,[RecordDeleted]
           ,[DeletedDate]
           ,[DeletedBy]
           ,[Key]
           ,[Value]
           ,[Description]
           ,[AcceptedValues]
           ,[ShowKeyForViewingAndEditing]
           ,[Modules]
           ,[Screens]
           ,[Comments]
           ,[SourceTableName]
           ,[AllowEdit])
     VALUES
           ('Task 963 SWMBH Enhancement'
           ,getdate()
           ,'Task 963 SWMBH Enhancement'
           ,getdate()
           ,'N'
           ,NULL
           ,NULL
           ,'ShowCustomTabInCMClientAuthorization'
           ,'No'
           ,'When the value of the key SetCustomTabDFAForCMClientAuthorization is set to Yes, the system will show custom tab in CM Client Authorization screen. 
            When the value of the key SetCustomTabDFAForCMClientAuthorization is set to No, then system will hide custom tab in CM Client Authorization screen.
            Default value will be No, in this case system will  hide custom tab in CM Client Authorization screen.'
           ,'Yes,No'
           ,'Y'
           ,'CM Client Authorization'
           ,'CM Client Authorization'
           ,''
           ,NULL
           ,'Y')

	END







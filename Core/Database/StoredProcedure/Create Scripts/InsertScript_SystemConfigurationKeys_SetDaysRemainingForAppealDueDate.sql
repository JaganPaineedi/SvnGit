IF NOT EXISTS (SELECT TOP 1 * FROM SystemConfigurationKeys WHERE [Key]='SetDaysRemainingForAppealDueDate')
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
           ('Task 20.1'
           ,getdate()
           ,'Task 20.1'
           ,getdate()
           ,'N'
           ,NULL
           ,NULL
           ,'SetDaysRemainingForAppealDueDate'
           ,60
           ,'Description : Read Key as --- "Set Days Remaining For Appeal Due Date".DaysLeft in Appeals List Page is calculated based on the value of the key ''SetDaysRemainingForAppealDueDate'' 
             Ex: If the value is set to as 90 and DateReceived is 06/01/2018, sysem calculates days left from DateReceived based on current/today''s date (06/13/2018). So the days left is 78.'
           ,'Positive Numbers'
           ,'Y'
           ,'appeal'
           ,'appeal'
           ,''
           ,NULL
           ,'Y')

	END







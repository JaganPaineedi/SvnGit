IF( NOT EXISTS(SELECT [Key] 
               FROM   [SystemConfigurationKeys] 
               WHERE  [Key] = 'INTIALIZETREATMENTEAMCP') ) 
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
      VALUES      ('Task 13'
                   ,getdate()
                   ,'Task 13'
                   ,getdate()
                   ,'N'
                   ,NULL
                   ,NULL
                   ,'INTIALIZETREATMENTEAMCP'
                   ,'NO'
                   ,'Description : When Key is set to YES, on the Care Plan - Supports/Treatment Program Tab - Treatment Program section, when the user clicks on ''Add'' button,
                     the staff drop down will be only staff in the clietns treatment team instead of all staff'
                   ,'YES,NO'
                   ,'Y'
                   ,'Care Plan'
                   ,'Care Plan'
                   ,''
                   ,NULL
				   ,'Y') 
  END 
ELSE 
  BEGIN 
      UPDATE [SystemConfigurationKeys] 
      SET   [CreatedBy]='Task 13'
		   ,[CreateDate]=getdate()
           ,[ModifiedBy]='Task 13'
           ,[ModifiedDate]=getdate()
           ,[RecordDeleted]='N'
           ,[DeletedDate]=NULL
           ,[DeletedBy]=NULL
           ,[Key]='INTIALIZETREATMENTEAMCP'
           ,[Value]='NO'
           ,[Description]='Description : When Key is set to YES, on the Care Plan - Supports/Treatment Program Tab - Treatment Program section, when the user clicks on ''Add'' button,
                     the staff drop down will be only staff in the clietns treatment team instead of all staff'
           ,[AcceptedValues]='YES,NO'
           ,[ShowKeyForViewingAndEditing]='Y'
		   ,[Modules]='Care Plan'
		   ,[Screens]='Care Plan'
		   ,[Comments]=''
		   ,[SourceTableName]=NULL
		   ,[AllowEdit]='Y'
      WHERE [Key]='INTIALIZETREATMENTEAMCP'
  END 
IF NOT EXISTS (SELECT * FROM systemconfigurationkeys WHERE [Key] = 'FLOWSHEETDEFAULTTEMPLATE') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName
				,AllowEdit) 
		values('FLOWSHEETDEFAULTTEMPLATE' 
				,110 
				,'HealthDataTemplateId'
				,'To Set Default HealthDataTemplateId in Flowsheet List Page' 
				,'Y' 
				,'To Set Default HealthDataTemplateId in Flowsheet List Page'
				,'HealthDataTemplates'
				,'Y')
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = 110
		   ,AcceptedValues = 'HealthDataTemplateId'
		   ,[Description]= 'To Set Default HealthDataTemplateId in Flowsheet List Page' 
		   ,ShowKeyForViewingAndEditing= 'Y'
		   ,Comments= 'To Set Default HealthDataTemplateId in Flowsheet List Page' 
		   ,SourceTableName= 'HealthDataTemplates'
		   ,AllowEdit = 'Y'
			WHERE [Key]='FLOWSHEETDEFAULTTEMPLATE';
   END	
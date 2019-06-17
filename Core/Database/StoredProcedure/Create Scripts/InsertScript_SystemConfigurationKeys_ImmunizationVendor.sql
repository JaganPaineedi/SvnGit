IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ImmunizationAdministrationVendorId') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ImmunizationAdministrationVendorId' 
				,NULL
				,NULL
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = NULL
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ImmunizationAdministrationVendorId';
   END	 	


   IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ImmunizationHistoryForecastVendorId') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ImmunizationHistoryForecastVendorId' 
				,NULL
				,NULL
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = NULL
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ImmunizationHistoryForecastVendorId';
   END	 

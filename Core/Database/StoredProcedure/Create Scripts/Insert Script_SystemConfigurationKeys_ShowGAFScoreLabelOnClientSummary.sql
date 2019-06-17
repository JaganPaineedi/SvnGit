IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ShowGAFScoreLabelOnClientSummary') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName
				,Value
				,AllowEdit) 
		VALUES ('ShowGAFScoreLabelOnClientSummary' 
				,NULL
				,NULL
				,'N' 
				,'Client Summary'
				,'19'
				,NULL 
				,NULL
				,'Y'
				,'Y')
  END
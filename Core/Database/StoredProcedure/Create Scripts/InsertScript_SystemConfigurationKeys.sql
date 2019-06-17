IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'USESPFORCUSTOMGROUPSERVICE') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Value
				,Comments
				) 
		VALUES ('USESPFORCUSTOMGROUPSERVICE' 
				,NULL
				,'Sp to Update Custom fields from Group Service Entry'
				,'N' 
				,'Group Service Entry'
				,'csp_SCUpdateGroupCustomServices'
				,NULL 
				)
  END	
--- Insert script for GlobalCode category      
-- Valley Enhancements # 1212
  
	IF NOT EXISTS(SELECT 1 FROM GlobalCodes WHERE Category='CHARGECLAIMSACTION' AND Code='REMOVE FROM TO BE REPLACED')
	BEGIN		
		INSERT INTO globalcodes (
		Category
		,CodeName
		,Code
		,Description
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		)
	VALUES (
		'CHARGECLAIMSACTION'
		,'Remove from To Be Replaced'
		,'REMOVE FROM TO BE REPLACED'
		,NULL
		,'Y'
		,'Y'
		,1
		,''
		)
	END
	
	IF NOT EXISTS(SELECT 1 FROM GlobalCodes WHERE Category='CHARGECLAIMSACTION' AND Code='REMOVE FROM TO BE VOIDED')
	BEGIN	
		INSERT INTO globalcodes (
		Category
		,CodeName
		,Code
		,Description
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		)
	VALUES (
		'CHARGECLAIMSACTION'
		,'Remove from To be Voided'
		,'REMOVE FROM TO BE VOIDED'
		,NULL
		,'Y'
		,'Y'
		,1
		,''
		)
	END
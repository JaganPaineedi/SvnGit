--What : Adding new RecodeCategory for ChargeError Types that should cascade but retain same priority - 'CascadePayerChargeErrorsKeepPriority'
--       
--Why  : Boundless Support Go Live 232

IF NOT EXISTS (
		SELECT 1
		FROM dbo.RecodeCategories
		WHERE CategoryCode = 'CascadePayerChargeErrorsKeepPriority'
		)
BEGIN

INSERT INTO RecodeCategories
	(CreatedBy, 
	CreatedDate, 
	ModifiedBy, 
	ModifiedDate, 
	CategoryCode, 
	CategoryName, 
	Description, 
	MappingEntity, 
	RecodeType, 
	RangeType)
VALUES 
		(SYSTEM_USER
		,CURRENT_TIMESTAMP
		,SYSTEM_USER
		,CURRENT_TIMESTAMP,
		'CascadePayerChargeErrorsKeepPriority', 
		'CascadePayerChargeErrorsKeepPriority', 
		'Charges Errors that cause a service to be cascaded to the next payer but will keep same Charge Priority', 
		'GlobalCodes.GlobalCodeId', 
		8401, 
		8410)
END
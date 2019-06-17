


IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='XTEMPATURELOCATION' AND CodeName= 'Temporal' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Active],[CannotModifyNameOrDelete])
	VALUES('XTEMPATURELOCATION','Temporal','Y','N')
END

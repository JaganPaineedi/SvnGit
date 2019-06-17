	If Exists(select * from documentcodes where DocumentCodeId = 10013)
	Begin
	UPDATE documentcodes
	SET SignatureDateAsEffectiveDate = NULL
	WHERE DocumentCodeId = 10013
	End
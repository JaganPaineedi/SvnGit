If Not Exists (Select 1 from SystemConfigurationKeys Where [Key]='REQUIRECLAIMLINEREVERTREASON')
Begin
	insert into SystemConfigurationKeys ([Key],Value,[Description],AcceptedValues,ShowKeyForViewingAndEditing,Modules)
	values ('REQUIRECLAIMLINEREVERTREASON','Y','This Key is used to add Required validation for RevertReason','Y,N','Y','RevertClaims')
End
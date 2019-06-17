-------------------------------------------------
--Author : Lakshmi kanth
--Date   : 25/03/2016
--Purpose: Make DisclosedTo As TypeableSearch,  for task#613.8 Network 180
-------------------------------------------------

IF NOT EXISTS(SELECT 1 FROM SystemConfigurationKeys WHERE [Key]='MakeDisclosedToAsTypeableSearch')
BEGIN
	INSERT INTO SystemConfigurationKeys([Key],Value,[Description],AcceptedValues,ShowKeyForViewingAndEditing,Modules,Screens,Comments)
	VALUES ('MakeDisclosedToAsTypeableSearch','N','Make DisclosedTo As TypeableSearch','Y,N','Y','Disclosure/Request',NULL,NULL)
END




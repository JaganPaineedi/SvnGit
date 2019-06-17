/*-------Date----Author-------Purpose---------------------------------------*/ 
/*   20-Jun-2016  Deej    Created to enable/disable the verbosemode			*/
/****************************************************************************/
IF NOT EXISTS (SELECT * FROM SystemConfigurationKeys WHERE [Key] = 'EnableVerboseMode')
BEGIN
	INSERT INTO SystemConfigurationKeys (CreatedBy,CreateDate,ModifiedBy,ModifiedDate,[Key],Value,Description,AcceptedValues,ShowKeyForViewingAndEditing,Modules)
	VALUES (SYSTEM_USER,CURRENT_TIMESTAMP,SYSTEM_USER,CURRENT_TIMESTAMP,'EnableVerboseMode','N','This key is used to enable/disable VerboseMode data collection.','Y,N','Y','Core')
END

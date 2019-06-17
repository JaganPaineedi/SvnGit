-- Insert script for SystemConfigurationKeys SETSTARTDATEFORMARCREATION
IF NOT EXISTS (
		SELECT [key]
		FROM SystemConfigurationKeys
		WHERE [key] = 'SETSTARTDATEFORMARCREATION'
		)
BEGIN
	INSERT INTO [dbo].[SystemConfigurationKeys] (
		CreatedBy
		,CreateDate
		,ModifiedBy
		,ModifiedDate
		,[Key]
		,Value
		,Description
		)
	VALUES (
		'SHSDBA'
		,GETDATE()
		,'SHSDBA'
		,GETDATE()
		,'SETSTARTDATEFORMARCREATION'
		,NULL
		,'Significance:  This key configuration helps in defining the Start date to create MAR entry to create old data.'
		)
END
ELSE
BEGIN
	UPDATE SystemConfigurationKeys
	SET value = NULL
		,Description = 'Significance:  This key configuration helps in defining the Start date to create MAR entry to create old data.'
	WHERE [key] = 'SETSTARTDATEFORMARCREATION'
END
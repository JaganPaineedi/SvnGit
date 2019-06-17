/********************************************************************************************
Author		:	Pradeep A
CreatedDate	:	Apr/20/2016 
Purpose		:	To Clear Insurance Id based on this flag while making the eligibility Verification
*********************************************************************************************/
IF NOT EXISTS (
		SELECT *
		FROM SystemConfigurationKeys
		WHERE [key] = 'SENDMINIMALINFORMATION'
		)
BEGIN
	INSERT INTO [dbo].[SystemConfigurationKeys] (
		[Key]
		,[Value]
		)
	VALUES (
		'SENDMINIMALINFORMATION'
		,'Y'
		)
END
ELSE
BEGIN
	UPDATE SystemConfigurationKeys
	SET Value = 'Y'
	WHERE [key] = 'SENDMINIMALINFORMATION'
END

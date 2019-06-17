/********************************************************************************************
Author		:	Pradeep A
CreatedDate	:	Apr/20/2016 
Purpose		:	To Clear Insurance Id based on this flag while making the eligibility Verification
*********************************************************************************************/
IF NOT EXISTS (
		SELECT *
		FROM SystemConfigurationKeys
		WHERE [key] = 'CLEARMEDICAID'
		)
BEGIN
	INSERT INTO [dbo].[SystemConfigurationKeys] (
		[Key]
		,[Value]
		)
	VALUES (
		'CLEARMEDICAID'
		,'Y'
		)
END
ELSE
BEGIN
	UPDATE SystemConfigurationKeys
	SET Value = 'Y'
	WHERE [key] = 'CLEARMEDICAID'
END

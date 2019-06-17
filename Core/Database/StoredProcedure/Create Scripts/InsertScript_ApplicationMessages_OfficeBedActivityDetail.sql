DECLARE @APPLICATIONMESSAGEID INT
-------------INSERT SCRIPT FOR ApplicationMessages CODE CREATESCHEDULEDDISCHARGE
IF NOT EXISTS (SELECT ApplicationMessageId	FROM ApplicationMessages WHERE MessageCode = 'CREATESCHEDULEDDISCHARGE' AND PrimaryScreenId = '911')
BEGIN
	INSERT INTO ApplicationMessages (
		PrimaryScreenId
		,MessageCode
		,OriginalText
		,Override
		,OverrideText
		)
	VALUES (
		'911'
		,'CREATESCHEDULEDDISCHARGE'
		,'Are you sure you want to create a scheduled discharge? If you do not want to create a scheduled discharge click ‘Cancel’'
		,'Y'
		,'Are you sure you want to create a scheduled discharge? If you do not want to create a scheduled discharge click ‘Cancel’'
		)
END

IF EXISTS (SELECT @APPLICATIONMESSAGEID	FROM ApplicationMessages WHERE MessageCode ='CREATESCHEDULEDDISCHARGE' AND PrimaryScreenId ='911')
BEGIN
	SET @APPLICATIONMESSAGEID = (SELECT ApplicationMessageId FROM ApplicationMessages
	WHERE MessageCode = 'CREATESCHEDULEDDISCHARGE' AND PrimaryScreenId = '911')
	IF NOT EXISTS (SELECT ApplicationMessageScreenId FROM ApplicationMessageScreens	WHERE ApplicationMessageId = @APPLICATIONMESSAGEID)
	BEGIN
		INSERT INTO ApplicationMessageScreens (ApplicationMessageId,ScreenId)
		VALUES (@APPLICATIONMESSAGEID,'911');
	END
END

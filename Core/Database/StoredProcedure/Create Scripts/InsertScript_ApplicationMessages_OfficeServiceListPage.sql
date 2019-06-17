DECLARE @APPLICATIONMESSAGEID INT
-------------INSERT SCRIPT FOR ApplicationMessages CODE SELECTPROGRAMORORGANIZATIONALHIERARCHY
IF NOT EXISTS (SELECT ApplicationMessageId	FROM ApplicationMessages WHERE MessageCode = 'SELECTPROGRAMORORGANIZATIONALHIERARCHY' 
		AND PrimaryScreenId = '357')
BEGIN
	INSERT INTO ApplicationMessages (
		PrimaryScreenId
		,MessageCode
		,OriginalText
		,Override
		,OverrideText
		)
	VALUES (
		'357'
		,'SELECTPROGRAMORORGANIZATIONALHIERARCHY'
		,'Please select the Program or select an Organizational Hierarchy'
		,'Y'
		,'Please select the Program or select an Organizational Hierarchy'
		)
END

IF EXISTS (SELECT @APPLICATIONMESSAGEID	FROM ApplicationMessages WHERE MessageCode ='SELECTPROGRAMORORGANIZATIONALHIERARCHY' AND PrimaryScreenId ='357')
BEGIN
	SET @APPLICATIONMESSAGEID = (SELECT ApplicationMessageId FROM ApplicationMessages
	WHERE MessageCode = 'SELECTPROGRAMORORGANIZATIONALHIERARCHY' AND PrimaryScreenId = '357')
	IF NOT EXISTS (SELECT ApplicationMessageScreenId FROM ApplicationMessageScreens	WHERE ApplicationMessageId = @APPLICATIONMESSAGEID)
	BEGIN
		INSERT INTO ApplicationMessageScreens (ApplicationMessageId,ScreenId)
		VALUES (@APPLICATIONMESSAGEID,'357');
	END
END

-------------INSERT SCRIPT FOR ApplicationMessages CODE SELECTATLEASTONESERVICE
IF NOT EXISTS (SELECT ApplicationMessageId	FROM ApplicationMessages WHERE MessageCode = 'SELECTATLEASTONESERVICE'AND PrimaryScreenId = '357')
BEGIN
	INSERT INTO ApplicationMessages (
		PrimaryScreenId
		,MessageCode
		,OriginalText
		,Override
		,OverrideText
		)
	VALUES (
		'357'
		,'SELECTATLEASTONESERVICE'
		,'Please select atleast one Service'
		,'Y'
		,'Please select atleast one Service'
		)
END

IF EXISTS (SELECT @APPLICATIONMESSAGEID	FROM ApplicationMessages WHERE MessageCode = 'SELECTATLEASTONESERVICE'	AND PrimaryScreenId = '357'	)
BEGIN
	SET @APPLICATIONMESSAGEID = (SELECT ApplicationMessageId FROM ApplicationMessages
	WHERE MessageCode = 'SELECTATLEASTONESERVICE' AND PrimaryScreenId = '357')
	IF NOT EXISTS (SELECT ApplicationMessageScreenId FROM ApplicationMessageScreens	WHERE ApplicationMessageId = @APPLICATIONMESSAGEID)
	BEGIN
		INSERT INTO ApplicationMessageScreens (ApplicationMessageId,ScreenId)
		VALUES (@APPLICATIONMESSAGEID,'357');
	END
END

-------------INSERT SCRIPT FOR ApplicationMessages CODE ACTIONCANONLYBEEXECUTEDONONESERVICEATATIME
IF NOT EXISTS (SELECT ApplicationMessageId	FROM ApplicationMessages WHERE MessageCode = 'ACTIONCANONLYBEEXECUTEDONONESERVICEATATIME'AND PrimaryScreenId = '357')
BEGIN
	INSERT INTO ApplicationMessages (
		PrimaryScreenId
		,MessageCode
		,OriginalText
		,Override
		,OverrideText
		)
	VALUES (
		'357'
		,'ACTIONCANONLYBEEXECUTEDONONESERVICEATATIME'
		,'This action can only be executed on one service at a time'
		,'Y'
		,'This action can only be executed on one service at a time'
		)
END

IF EXISTS (SELECT @APPLICATIONMESSAGEID	FROM ApplicationMessages WHERE MessageCode = 'ACTIONCANONLYBEEXECUTEDONONESERVICEATATIME'	AND PrimaryScreenId = '357'	)
BEGIN
	SET @APPLICATIONMESSAGEID = (SELECT ApplicationMessageId FROM ApplicationMessages
	WHERE MessageCode = 'ACTIONCANONLYBEEXECUTEDONONESERVICEATATIME' AND PrimaryScreenId = '357')
	IF NOT EXISTS (SELECT ApplicationMessageScreenId FROM ApplicationMessageScreens	WHERE ApplicationMessageId = @APPLICATIONMESSAGEID)
	BEGIN
		INSERT INTO ApplicationMessageScreens (ApplicationMessageId,ScreenId)
		VALUES (@APPLICATIONMESSAGEID,'357');
	END
END
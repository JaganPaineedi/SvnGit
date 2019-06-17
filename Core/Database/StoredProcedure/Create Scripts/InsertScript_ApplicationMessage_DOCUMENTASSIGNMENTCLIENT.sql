DECLARE @APPLICATIONMESSAGEID int

-------------INSERT SCRIPT FOR MESSAGE CODE DOCUMENTASSIGNMENTADMIN
IF NOT EXISTS (SELECT ApplicationMessageId from ApplicationMessages where MessageCode='DOCUMENTASSIGNMENTCLIENT' and PrimaryScreenId='2203') 
BEGIN  
	INSERT INTO ApplicationMessages(PrimaryScreenId,MessageCode,OriginalText,Override,OverrideText)  
	VALUES(2203,'DOCUMENTASSIGNMENTCLIENT','Documents can not be assigned to this client.','N','Documents can not be assigned to this client.') 
END


IF EXISTS(SELECT @APPLICATIONMESSAGEID FROM ApplicationMessages WHERE MessageCode='DOCUMENTASSIGNMENTCLIENT' AND  PrimaryScreenId='2203')
BEGIN
	SET @APPLICATIONMESSAGEID=(SELECT ApplicationMessageId FROM ApplicationMessages WHERE MessageCode='DOCUMENTASSIGNMENTCLIENT' AND PrimaryScreenId='2203')
	IF NOT EXISTS(SELECT ApplicationMessageScreenId FROM ApplicationMessageScreens WHERE ApplicationMessageId=@APPLICATIONMESSAGEID)
	BEGIN
		INSERT INTO ApplicationMessageScreens(ApplicationMessageId,ScreenId)
		VALUES(@APPLICATIONMESSAGEID,'2203');
	END
END
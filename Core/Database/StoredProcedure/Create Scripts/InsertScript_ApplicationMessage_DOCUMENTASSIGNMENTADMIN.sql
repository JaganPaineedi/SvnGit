DECLARE @APPLICATIONMESSAGEID int

-------------INSERT SCRIPT FOR MESSAGE CODE DOCUMENTASSIGNMENTADMIN
IF NOT EXISTS (SELECT ApplicationMessageId from ApplicationMessages where MessageCode='DOCUMENTASSIGNMENTADMIN' and PrimaryScreenId='2202') 
BEGIN  
	INSERT INTO ApplicationMessages(PrimaryScreenId,MessageCode,OriginalText,Override,OverrideText)  
	VALUES('2202','DOCUMENTASSIGNMENTADMIN','Document has been already assigned','N','Document has been already assigned') 
END


IF EXISTS(SELECT @APPLICATIONMESSAGEID FROM ApplicationMessages WHERE MessageCode='DOCUMENTASSIGNMENTADMIN' AND  PrimaryScreenId='2202')
BEGIN
	SET @APPLICATIONMESSAGEID=(SELECT ApplicationMessageId FROM ApplicationMessages WHERE MessageCode='DOCUMENTASSIGNMENTADMIN' AND PrimaryScreenId='2202')
	IF NOT EXISTS(SELECT ApplicationMessageScreenId FROM ApplicationMessageScreens WHERE ApplicationMessageId=@APPLICATIONMESSAGEID)
	BEGIN
		INSERT INTO ApplicationMessageScreens(ApplicationMessageId,ScreenId)
		VALUES(@APPLICATIONMESSAGEID,'2202');
	END
END
DECLARE @APPLICATIONMESSAGEID int

-------------INSERT SCRIPT FOR MESSAGE CODE DOCUMENTASSIGNMENTADMIN
IF NOT EXISTS (SELECT ApplicationMessageId from ApplicationMessages where MessageCode='ALLOWFUTUREDATEANDTIME' and PrimaryScreenId='716') 
BEGIN  
	INSERT INTO ApplicationMessages(PrimaryScreenId,MessageCode,OriginalText,Override,OverrideText)  
	VALUES('716','ALLOWFUTUREDATEANDTIME','Record date/time can not be greater than current date/time. Please change the date/time to proceed','N','Record date/time can not be greater than current date/time. Please change the date/time to proceed') 
END


IF EXISTS(SELECT @APPLICATIONMESSAGEID FROM ApplicationMessages WHERE MessageCode='ALLOWFUTUREDATEANDTIME' AND  PrimaryScreenId='716')
BEGIN
	SET @APPLICATIONMESSAGEID=(SELECT ApplicationMessageId FROM ApplicationMessages WHERE MessageCode='ALLOWFUTUREDATEANDTIME' AND PrimaryScreenId='716')
	IF NOT EXISTS(SELECT ApplicationMessageScreenId FROM ApplicationMessageScreens WHERE ApplicationMessageId=@APPLICATIONMESSAGEID)
	BEGIN
		INSERT INTO ApplicationMessageScreens(ApplicationMessageId,ScreenId)
		VALUES(@APPLICATIONMESSAGEID,'716');
	END
END
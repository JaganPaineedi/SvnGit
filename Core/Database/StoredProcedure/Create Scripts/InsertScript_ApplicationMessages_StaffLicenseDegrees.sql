DECLARE @APPLICATIONMESSAGEID int

-------------INSERT SCRIPT FOR ApplicationMessages CODE BILLINGLICENSESETFORANOTHER
IF NOT EXISTS (SELECT ApplicationMessageId from ApplicationMessages where MessageCode='BILLINGLICENSESETFORANOTHER' and PrimaryScreenId='329') 
BEGIN  
	INSERT INTO ApplicationMessages(PrimaryScreenId,MessageCode,OriginalText,Override,OverrideText)  
	VALUES('329','BILLINGLICENSESETFORANOTHER','Primary License has already been set for another record.  Do you want to make this record the Primary License?','Y','Primary License has already been set for another record.  Do you want to make this record the Primary License?') 
END


IF EXISTS(SELECT @APPLICATIONMESSAGEID FROM ApplicationMessages WHERE MessageCode='BILLINGLICENSESETFORANOTHER' AND  PrimaryScreenId='329')
BEGIN
	SET @APPLICATIONMESSAGEID=(SELECT ApplicationMessageId FROM ApplicationMessages WHERE MessageCode='BILLINGLICENSESETFORANOTHER' AND PrimaryScreenId='329')
	IF NOT EXISTS(SELECT ApplicationMessageScreenId FROM ApplicationMessageScreens WHERE ApplicationMessageId=@APPLICATIONMESSAGEID)
	BEGIN
		INSERT INTO ApplicationMessageScreens(ApplicationMessageId,ScreenId)
		VALUES(@APPLICATIONMESSAGEID,'329');
	END
END


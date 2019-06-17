---------------------------------------
--Author: Bernardin
--Purpose: Core Bugs Task# 1989
--------------------------------------

DECLARE @APPLICATIONMESSAGEID int

-------------INSERT SCRIPT FOR MESSAGE CODE ALLINSURERORSTAFFINSURER
IF NOT EXISTS (SELECT ApplicationMessageId from ApplicationMessages where MessageCode='CLIENTACCOUNTHASACTIVITY' and PrimaryScreenId='335') 
BEGIN  
	INSERT INTO ApplicationMessages(PrimaryScreenId,MessageCode,OriginalText,Override,OverrideText)  
	VALUES('335','CLIENTACCOUNTHASACTIVITY','Can not delete this coverage plan since it has client account activities.','Y','Can not delete this coverage plan since it has client account activities.') 
END

IF EXISTS(SELECT @APPLICATIONMESSAGEID FROM ApplicationMessages WHERE MessageCode='CLIENTACCOUNTHASACTIVITY' AND  PrimaryScreenId='335')
BEGIN
	SET @APPLICATIONMESSAGEID=(SELECT ApplicationMessageId FROM ApplicationMessages WHERE MessageCode='CLIENTACCOUNTHASACTIVITY' AND PrimaryScreenId='335')
	IF NOT EXISTS(SELECT ApplicationMessageScreenId FROM ApplicationMessageScreens WHERE ApplicationMessageId=@APPLICATIONMESSAGEID)
	BEGIN
		INSERT INTO ApplicationMessageScreens(ApplicationMessageId,ScreenId)
		VALUES(@APPLICATIONMESSAGEID,'335');
	END
END


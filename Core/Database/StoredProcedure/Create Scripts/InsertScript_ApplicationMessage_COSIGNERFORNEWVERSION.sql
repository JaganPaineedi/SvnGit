---------------------------------------
--Author: Bernardin
--Purpose: WMU - Support Go Live Task# 232
--------------------------------------

DECLARE @APPLICATIONMESSAGEID int

-------------INSERT SCRIPT FOR MESSAGE CODE COSIGNERFORNEWVERSION
IF NOT EXISTS (SELECT ApplicationMessageId from ApplicationMessages where MessageCode='COSIGNERFORNEWVERSION' and PrimaryScreenId='0') 
BEGIN  
	INSERT INTO ApplicationMessages(PrimaryScreenId,MessageCode,OriginalText,Override,OverrideText)  
	VALUES('0','COSIGNERFORNEWVERSION','Save the new version before adding co-signer','Y','Save the new version before adding co-signer') 
END

IF EXISTS(SELECT @APPLICATIONMESSAGEID FROM ApplicationMessages WHERE MessageCode='COSIGNERFORNEWVERSION' AND  PrimaryScreenId='0')
BEGIN
	SET @APPLICATIONMESSAGEID=(SELECT ApplicationMessageId FROM ApplicationMessages WHERE MessageCode='COSIGNERFORNEWVERSION' AND PrimaryScreenId='0')
	IF NOT EXISTS(SELECT ApplicationMessageScreenId FROM ApplicationMessageScreens WHERE ApplicationMessageId=@APPLICATIONMESSAGEID)
	BEGIN
		INSERT INTO ApplicationMessageScreens(ApplicationMessageId,ScreenId)
		VALUES(@APPLICATIONMESSAGEID,'0');
	END
END
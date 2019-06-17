

/*******************************************************************/
/**********Validation Message scripts*************/
/******Insert Script for ApplicationMessage***************/
/******************************************************************/



DECLARE @APPLICATIONMESSAGEID int

IF NOT EXISTS (SELECT ApplicationMessageId from ApplicationMessages where MessageCode='TIMESHEETFUTUREDATE' and PrimaryScreenId=1172 and ISNULL(RecordDeleted, 'N') = 'N') 
BEGIN  
	INSERT INTO ApplicationMessages(PrimaryScreenId,MessageCode,OriginalText,Override,OverrideText)  
	VALUES(1172,'TIMESHEETFUTUREDATE','Future Date is not allowed', 'Y', 'Future Date is not allowed') 
	
	select top 1 @APPLICATIONMESSAGEID=ApplicationMessageId from ApplicationMessages
	where MessageCode='TIMESHEETFUTUREDATE'
END
ELSE
BEGIN
	select top 1 @APPLICATIONMESSAGEID=ApplicationMessageId from ApplicationMessages
	where MessageCode='TIMESHEETFUTUREDATE'
END


IF NOT EXISTS(SELECT 1 FROM ApplicationMessageScreens WHERE  ScreenId=1172 and ApplicationMessageId=@APPLICATIONMESSAGEID and ISNULL(RecordDeleted, 'N') = 'N')
BEGIN
	INSERT INTO ApplicationMessageScreens(ApplicationMessageId,ScreenId)
	VALUES(@APPLICATIONMESSAGEID,1172);
END
ELSE 
BEGIN
	UPDATE ApplicationMessageScreens set 
	ScreenId=1172 where ApplicationMessageId = @APPLICATIONMESSAGEID 
END

-------------------------------------------------------


IF NOT EXISTS (SELECT ApplicationMessageId from ApplicationMessages where MessageCode='TIMESHEETENDTIMEGREATER' and PrimaryScreenId=1172 and ISNULL(RecordDeleted, 'N') = 'N') 
BEGIN  
	INSERT INTO ApplicationMessages(PrimaryScreenId,MessageCode,OriginalText,Override,OverrideText)  
	VALUES(1172,'TIMESHEETENDTIMEGREATER','End Time should be greater then Start time', 'Y', 'End Time should be greater then Start time') 
	
	select top 1 @APPLICATIONMESSAGEID=ApplicationMessageId from ApplicationMessages
	where MessageCode='TIMESHEETENDTIMEGREATER'
END
ELSE
BEGIN
	select top 1 @APPLICATIONMESSAGEID=ApplicationMessageId from ApplicationMessages
	where MessageCode='TIMESHEETENDTIMEGREATER'
END


IF NOT EXISTS(SELECT 1 FROM ApplicationMessageScreens WHERE  ScreenId=1172 and ApplicationMessageId=@APPLICATIONMESSAGEID and ISNULL(RecordDeleted, 'N') = 'N')
BEGIN
	INSERT INTO ApplicationMessageScreens(ApplicationMessageId,ScreenId)
	VALUES(@APPLICATIONMESSAGEID,1172);
END
ELSE 
BEGIN
	UPDATE ApplicationMessageScreens set 
	ScreenId=1172 where ApplicationMessageId = @APPLICATIONMESSAGEID 
END


------------------------------------------------------------------------------



IF NOT EXISTS (SELECT ApplicationMessageId from ApplicationMessages where MessageCode='TIMESHEETTIME' and PrimaryScreenId=1172 and ISNULL(RecordDeleted, 'N') = 'N') 
BEGIN  
	INSERT INTO ApplicationMessages(PrimaryScreenId,MessageCode,OriginalText,Override,OverrideText)  
	VALUES(1172,'TIMESHEETTIME','Please enter Start Time and End Time', 'Y', 'Please enter Start Time and End Time') 
	
	select top 1 @APPLICATIONMESSAGEID=ApplicationMessageId from ApplicationMessages
	where MessageCode='TIMESHEETTIME'
END
ELSE
BEGIN
	select top 1 @APPLICATIONMESSAGEID=ApplicationMessageId from ApplicationMessages
	where MessageCode='TIMESHEETTIME'
END


IF NOT EXISTS(SELECT 1 FROM ApplicationMessageScreens WHERE  ScreenId=1172 and ApplicationMessageId=@APPLICATIONMESSAGEID and ISNULL(RecordDeleted, 'N') = 'N')
BEGIN
	INSERT INTO ApplicationMessageScreens(ApplicationMessageId,ScreenId)
	VALUES(@APPLICATIONMESSAGEID,1172);
END
ELSE 
BEGIN
	UPDATE ApplicationMessageScreens set 
	ScreenId=1172 where ApplicationMessageId = @APPLICATIONMESSAGEID 
END


------------------------------------------------------------------------------



--IF NOT EXISTS (SELECT ApplicationMessageId from ApplicationMessages where MessageCode='TIMESHEETTIMEOFFOVERLAPTIME' and PrimaryScreenId=1172 and ISNULL(RecordDeleted, 'N') = 'N') 
--BEGIN  
--	INSERT INTO ApplicationMessages(PrimaryScreenId,MessageCode,OriginalText,Override,OverrideText)  
--	VALUES(1172,'TIMESHEETTIMEOFFOVERLAPTIME','Time off time cannot be the same as entered time', 'Y', 'Time off time cannot be the same as entered time') 
	
--	select top 1 @APPLICATIONMESSAGEID=ApplicationMessageId from ApplicationMessages
--	where MessageCode='TIMESHEETTIMEOFFOVERLAPTIME'
--END
--ELSE
--BEGIN
--	select top 1 @APPLICATIONMESSAGEID=ApplicationMessageId from ApplicationMessages
--	where MessageCode='TIMESHEETTIMEOFFOVERLAPTIME'
--END


IF NOT EXISTS(SELECT 1 FROM ApplicationMessageScreens WHERE  ScreenId=1172 and ApplicationMessageId=@APPLICATIONMESSAGEID and ISNULL(RecordDeleted, 'N') = 'N')
BEGIN
	INSERT INTO ApplicationMessageScreens(ApplicationMessageId,ScreenId)
	VALUES(@APPLICATIONMESSAGEID,1172);
END
ELSE 
BEGIN
	UPDATE ApplicationMessageScreens set 
	ScreenId=1172 where ApplicationMessageId = @APPLICATIONMESSAGEID 
END

----------------------------------------


IF NOT EXISTS (SELECT ApplicationMessageId from ApplicationMessages where MessageCode='TIMESHEETTIMEAWAYOVERLAPTIME' and PrimaryScreenId=1172 and ISNULL(RecordDeleted, 'N') = 'N') 
BEGIN  
	INSERT INTO ApplicationMessages(PrimaryScreenId,MessageCode,OriginalText,Override,OverrideText)  
	VALUES(1172,'TIMESHEETTIMEAWAYOVERLAPTIME','Time Away –  Start Time and End Time Overlapped', 'Y', 'Time Away –  Start Time and End Time Overlapped') 
	
	select top 1 @APPLICATIONMESSAGEID=ApplicationMessageId from ApplicationMessages
	where MessageCode='TIMESHEETTIMEAWAYOVERLAPTIME'
END
ELSE
BEGIN
	select top 1 @APPLICATIONMESSAGEID=ApplicationMessageId from ApplicationMessages
	where MessageCode='TIMESHEETTIMEAWAYOVERLAPTIME'
END


IF NOT EXISTS(SELECT 1 FROM ApplicationMessageScreens WHERE  ScreenId=1172 and ApplicationMessageId=@APPLICATIONMESSAGEID and ISNULL(RecordDeleted, 'N') = 'N')
BEGIN
	INSERT INTO ApplicationMessageScreens(ApplicationMessageId,ScreenId)
	VALUES(@APPLICATIONMESSAGEID,1172);
END
ELSE 
BEGIN
	UPDATE ApplicationMessageScreens set 
	ScreenId=1172 where ApplicationMessageId = @APPLICATIONMESSAGEID 
END



----------------------------------------


IF NOT EXISTS (SELECT ApplicationMessageId from ApplicationMessages where MessageCode='TIMESHEETSECONDARYACTIVITYOVERLAPTIME' and PrimaryScreenId=1172 and ISNULL(RecordDeleted, 'N') = 'N') 
BEGIN  
	INSERT INTO ApplicationMessages(PrimaryScreenId,MessageCode,OriginalText,Override,OverrideText)  
	VALUES(1172,'TIMESHEETSECONDARYACTIVITYOVERLAPTIME','Secondary Activity –  Start Time and End Time Overlapped', 'Y', 'Secondary Activity –  Start Time and End Time Overlapped') 
	
	select top 1 @APPLICATIONMESSAGEID=ApplicationMessageId from ApplicationMessages
	where MessageCode='TIMESHEETSECONDARYACTIVITYOVERLAPTIME'
END
ELSE
BEGIN
	select top 1 @APPLICATIONMESSAGEID=ApplicationMessageId from ApplicationMessages
	where MessageCode='TIMESHEETSECONDARYACTIVITYOVERLAPTIME'
END


IF NOT EXISTS(SELECT 1 FROM ApplicationMessageScreens WHERE  ScreenId=1172 and ApplicationMessageId=@APPLICATIONMESSAGEID and ISNULL(RecordDeleted, 'N') = 'N')
BEGIN
	INSERT INTO ApplicationMessageScreens(ApplicationMessageId,ScreenId)
	VALUES(@APPLICATIONMESSAGEID,1172);
END
ELSE 
BEGIN
	UPDATE ApplicationMessageScreens set 
	ScreenId=1172 where ApplicationMessageId = @APPLICATIONMESSAGEID 
END
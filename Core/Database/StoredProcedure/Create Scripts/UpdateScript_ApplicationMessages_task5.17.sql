/*Script to Update MessageCode='TIMESHEETTIMEOFFOVERLAPTIME'*/

DECLARE @ApplicationMessageId INT
SELECT @ApplicationMessageId = ApplicationMessageId from ApplicationMessages where MessageCode='TIMESHEETTIMEOFFOVERLAPTIME' and PrimaryScreenId=1172

DELETE FROM ApplicationMessages WHERE ApplicationMessageId=@ApplicationMessageId

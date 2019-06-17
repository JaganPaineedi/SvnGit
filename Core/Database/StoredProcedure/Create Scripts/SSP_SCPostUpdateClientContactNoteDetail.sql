IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = 
                  Object_id(N'[dbo].[SSP_SCPostUpdateClientContactNoteDetail]') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[SSP_SCPostUpdateClientContactNoteDetail] 

go 

/****** Object:  StoredProcedure [dbo].[SSP_SCPostUpdateClientContactNoteDetail]    Script Date: 03/11/2014 ******/ 
SET ansi_nulls ON 

go 

SET quoted_identifier ON 

go 

CREATE PROCEDURE [dbo].[Ssp_scpostupdateclientcontactnotedetail]
 @ScreenKeyId INT, 
 @StaffId INT, 
 @CurrentUser VARCHAR(30), 
 @CustomParameters XML 
/********************************************************************************                                           
-- Stored Procedure: dbo.SSP_SCPostUpdateClientContactNoteDetail                                             
                                          
-- Copyright: 2009 Streamline Healthcate Solutions                                                                                   
-- Updates:                                                                                                  
-- Date        Author      Purpose                                           
-- 11-MAR-2014 KIRTEE      Created sp for Task #1409 "CORE BUGS",Create a Notification message for selected staff and update the NotificationSentDateTime field in ClientContactNotes Table.  
-- 12-MAR-2014 TREMISOSKI   Maintainability: Renamed proc name to refer to table entity rather than column. 
              Logic: Removed logic associated with team notification.  Changed date format. 
              Future: Core team notification requirements need to be fully defined by product management and will be implemented at a later date.  
--13-Mar-2014  KIRTEE    Logic:  NotificationSentDateTime of ClientContactNotes Table is updated only when ContactNotes Temp table will have data  
                            and same will get inserted into Message table.     
--05-April-2015  Venkatesh    Logic:  Updated ReferenceId user creates new contact note from ContactNote detail screen

*********************************************************************************/ 
AS 
BEGIN 
Declare @ReferenceType INT
IF Object_id('tempdb..#ContactNotes') IS NOT NULL 
DROP TABLE #contactnotes 

BEGIN try 
BEGIN TRAN 

CREATE TABLE #contactnotes 
( 
ClientId        INT, 
ToStaffId       INT, 
ContactDetails  VARCHAR(max), 
ContactDateTime DATETIME, 
ContactReason   VARCHAR(250) 
) 

IF(SELECT Count(1) 
FROM   clientcontactnotes CCN 
LEFT JOIN dbo.globalcodes AS gcStatus 
ON gcStatus.GlobalCodeId = CCN.ContactStatus 
WHERE  ClientContactNoteId = @ScreenKeyId 
AND gcstatus.ExternalCode1 = 'C' 
AND Isnull(CCN.RecordDeleted, 'N') = 'N') > 0 
BEGIN 
INSERT INTO #contactnotes 
(ClientId, 
ToStaffId, 
ContactDetails, 
ContactDateTime, 
ContactReason) 
SELECT CCN.ClientId, 
CCN.NotifyStaffId, 
Isnull(GC.CodeName, '') + ' - ' 
+ Isnull(CCN.ContactDetails, ''), 
CCN.ContactDateTime, 
GC.CodeName 
FROM   clientcontactnotes CCN 
LEFT JOIN globalcodes GC 
ON CCN.ContactReason = GlobalCodeId 
JOIN dbo.globalcodes AS gcStatus 
ON gcStatus.GlobalCodeId = CCN.ContactStatus 
WHERE  ClientContactNoteId = @ScreenKeyId 
AND Isnull(CCN.RecordDeleted, 'N') = 'N' 
AND CCN.NotifyStaff = 'Y' 
AND CCN.NotifyStaffId IS NOT NULL 
AND CCN.NotificationSentDateTime IS NULL 
AND gcstatus.ExternalCode1 = 'C' 

IF(SELECT Count(1) FROM   #contactnotes) > 0 
BEGIN 
INSERT INTO [messages] 
(FROMSTAFFID, 
TOSTAFFID, 
CLIENTID, 
UNREAD, 
DATERECEIVED, 
SUBJECT, 
MESSAGE, 
PRIORITY, 
RECORDDELETED) 
SELECT @StaffId, 
TOSTAFFID, 
CLIENTID, 
'Y', 
Getdate(), 
'Contact Note:' + ' ' + Isnull(ContactReason, '')+ ' Contact date/time: ' + CONVERT(VARCHAR(20), ContactDateTime, 100),-- use default formatting 
ContactDetails, 
60, 
'N' 
FROM   #contactnotes CN 

UPDATE clientcontactnotes 
SET    NotificationSentDateTime = Getdate()
WHERE  ClientContactNoteId = @ScreenKeyId 
END 
END 

-- Added by venkatesh
SELECT @ReferenceType=ReferenceType From clientcontactnotes WHERE ClientContactNoteId = @ScreenKeyId

If(@ReferenceType = 9381)
BEGIN
	UPDATE clientcontactnotes SET ReferenceId=@ScreenKeyId   WHERE  ClientContactNoteId = @ScreenKeyId	
END


COMMIT TRAN 
END try 

BEGIN catch 
DECLARE @Error VARCHAR(8000) 

IF @@TRANCOUNT > 0 
ROLLBACK TRAN 

SET @Error= CONVERT(VARCHAR, Error_number()) + '*****' 
+ CONVERT(VARCHAR(4000), Error_message()) 
+ '*****' 
+ Isnull(CONVERT(VARCHAR, Error_procedure()), 
'[SSP_SCPostUpdateClientContactNoteDetail]') 
+ '*****' + CONVERT(VARCHAR, Error_line()) 
+ '*****' + CONVERT(VARCHAR, Error_severity()) 
+ '*****' + CONVERT(VARCHAR, Error_state()) 

RAISERROR ( @Error, 
-- Message text.                                                                                   
16, 
-- Severity.                                                                                   
1 
-- State.                                                                                   
); 
END catch 
END 

go  
/* Insert Script to insert records in StaffNotifications,StaffNotificationStaff,StaffPreferences tables.	*/
/* Reason to insert: Staff Notifcation messages will show based on the staff notifications setup in My Preferences - Check in Notifications tab.*/
/* Default entries with all permissions should be there to work the normal notifications for all customers */
/* Why: Harbor #1262.2, #1262.1 Harbor Support*/
BEGIN TRAN

----------StaffNotifications------------------------------
Insert into StaffNotifications
(CreatedBy
,CreatedDate
,ModifiedBy
,ModifiedDate
,StaffId
,Active
,Monday
,Tuesday
,Wednesday
,Thursday
,Friday
,Saturday
,Sunday
,AllProgram
,ProgramGroupName
,AllProcedure
,ProcedureGroupName
,AllStaff
,StaffGroupName
,AllLocation
,LocationGroupName
)
Select 'Core Fix'
,GetDate()
,'Core Fix'
,GetDate()
,s.StaffId
,'Y'
,'Y'
,'Y'
,'Y'
,'Y'
,'Y'
,'Y'
,'Y'
,'Y'
,'ALL'
,'Y'
,'ALL'
,'N'
,s.LastName+','+s.FirstName
,'Y'
,'ALL'
FROM Staff s
	WHERE s.Active = 'Y'
	AND s.TempClientId is null
	AND ISNULL(s.RecordDeleted,'N')<>'Y'
	AND NOT EXISTS (SELECT 1 FROM StaffNotifications sn1 WHERE sn1.StaffId = s.StaffId AND ISNULL(sn1.RecordDeleted,'N')<>'Y') 
----------StaffNotifications------------------------------


----------StaffNotificationStaff--------------------------
INSERT INTO StaffNotificationStaff
(CreatedBy
,CreatedDate
,ModifiedBy
,ModifiedDate
,StaffNotificationId
,StaffId
)
SELECT 'Core Fix'
,GetDate()
,'Core Fix'
,GetDate()
,sn.staffnotificationid
,sn.staffid
FROM StaffNotifications sn
	WHERE ISNULL(sn.RecordDeleted,'N')<>'Y'
	AND NOT EXISTS (SELECT 1 FROM StaffNotificationStaff sns WHERE sns.StaffId = sn.StaffId AND ISNULL(sns.RecordDeleted, 'N')<>'Y')
----------StaffNotificationStaff--------------------------

----------StaffPreferences--------------------------------
INSERT INTO StaffPreferences
(CreatedBy
,CreatedDate
,ModifiedBy
,ModifiedDate
,StaffId
,MobileCalendarEventsDaysLookUpInFuture
,MobileCalendarEventsDaysLookUpInPast
,NotifyMeOfMyServices
)
SELECT 'Core Fix'
,GetDate()
,'Core Fix'
,GetDate()
,sn.StaffId
,15
,15
,'Y'
FROM StaffNotifications sn
WHERE ISNULL(sn.RecordDeleted,'N')<>'Y'
AND NOT EXISTS (SELECT 1 FROM StaffPreferences sp1 WHERE sp1.StaffId = sn.StaffId AND ISNULL(sp1.RecordDeleted,'N')<>'Y')
----------StaffPreferences--------------------------------

COMMIT TRAN
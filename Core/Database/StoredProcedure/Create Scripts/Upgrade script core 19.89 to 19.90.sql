----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 19.89)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 19.89 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
-----
------ STEP 2 ----------

-----End of Step 2 -------

------ STEP 3 ------------
	
----Add New Column in NotificationQueues Table 	
IF OBJECT_ID('NotificationQueues') IS NOT NULL
BEGIN
		IF COL_LENGTH('NotificationQueues','NotificationMethod')IS NULL
		BEGIN
		 ALTER TABLE NotificationQueues ADD  NotificationMethod  type_GlobalCode	NULL
		
		EXEC sys.sp_addextendedproperty 'NotificationQueues_Description'
	 ,'NotificationMethod Column stores GlobalCodeIds of Category ''NOTIFICATIONMETHODS''.'
	 ,'schema'
	 ,'dbo'
	 ,'table'
	 ,'NotificationQueues'
	 ,'column'
	 ,'NotificationMethod' 
	 
 END
 
 IF COL_LENGTH('NotificationQueues','NotificationRetryCount')IS NULL
		BEGIN
		 ALTER TABLE NotificationQueues ADD  NotificationRetryCount  int	NULL
		
		EXEC sys.sp_addextendedproperty 'NotificationQueues_Description'
	 ,'NotificationRetryCount Column stores the Number how any times tried to send the notification.'
	 ,'schema'
	 ,'dbo'
	 ,'table'
	 ,'NotificationQueues'
	 ,'column'
	 ,'NotificationRetryCount' 
	 
 END

END
GO

IF  EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='StaffNotificationSubscriptions')
BEGIN
	IF COL_LENGTH('StaffNotificationSubscriptions','SubscriptionId')IS NOT NULL
	BEGIN
		DROP TABLE StaffNotificationSubscriptions
	END
END

		PRINT 'STEP 3 COMPLETED'


------ END Of STEP 3 ------------

------ STEP 4 ---------------

 ----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------
IF ((select DataModelVersion FROM SystemConfigurations)  = 19.89)
BEGIN
Update SystemConfigurations set DataModelVersion=19.90
PRINT 'STEP 7 COMPLETED'
END

Go

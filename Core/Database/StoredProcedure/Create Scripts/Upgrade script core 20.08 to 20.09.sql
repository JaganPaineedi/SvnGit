----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 20.08)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 20.08 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END

------ STEP 2 ----------

-----End of Step 2 -------
------ STEP 3 -----------

----------------------------------------------------------------------------
IF OBJECT_ID('MedAdminRecords') IS NOT NULL
BEGIN

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('MedAdminRecords') AND name='XIE1_MedAdminRecords')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_MedAdminRecords] ON [dbo].[MedAdminRecords] 
		(
		ClientOrderId ASC
		)
		INCLUDE ([RecordDeleted],
				[ScheduledDate],
				[ScheduledTime],
				[AdministeredDate],
				[AdministeredTime],
				[Status],
				[ClientMedicationInstructionId],
				[ServiceId]
				)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('MedAdminRecords') AND name='XIE1_MedAdminRecords')
		PRINT '<<< CREATED INDEX MedAdminRecords.XIE1_MedAdminRecords >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX MedAdminRecords.XIE1_MedAdminRecords >>>', 16, 1)		
		END	 


PRINT 'STEP 3 COMPLETED'	

END		
------ END Of STEP 3 ------------

------ STEP 4 ---------------

 ----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------
IF ((select DataModelVersion FROM SystemConfigurations)  = 20.08)
BEGIN
Update SystemConfigurations set DataModelVersion=20.09
PRINT 'STEP 7 COMPLETED'
END

Go

----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 16.04)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 16.04 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 -----------

-----End of Step 2 -------

------ STEP 3 ------------
-----END Of STEP 3---------

------ STEP 4 ------------

IF OBJECT_ID('ClientHealthDataAttributes')IS NOT NULL
BEGIN
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ClientHealthDataAttributes]') AND name = N'XIE2_ClientHealthDataAttributes')
	BEGIN
		CREATE NONCLUSTERED INDEX [XIE2_ClientHealthDataAttributes] ON [dbo].[ClientHealthDataAttributes] 
		(
		[ClientId],
		[HealthRecordDate]
		)
		INCLUDE ([RecordDeleted],[HealthDataAttributeId],[HealthDataSubTemplateId],[HealthDataTemplateId])
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('ClientHealthDataAttributes') AND name='XIE2_ClientHealthDataAttributes')
		PRINT '<<< CREATED INDEX ClientHealthDataAttributes.XIE2_ClientHealthDataAttributes >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX ClientHealthDataAttributes.XIE2_ClientHealthDataAttributes >>>', 16, 1)		
	END
	PRINT 'STEP 3 COMPLETED'
END

----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 16.04)
BEGIN
Update SystemConfigurations set DataModelVersion=16.05
PRINT 'STEP 7 COMPLETED'
END
Go



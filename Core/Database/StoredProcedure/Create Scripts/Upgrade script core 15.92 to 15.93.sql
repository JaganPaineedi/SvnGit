----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 15.92)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 15.92 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------

-----End of STEP 2 -------

------ STEP 3 ----------------

IF OBJECT_ID('ClientContactNotes')IS NOT NULL
BEGIN
		IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('ClientContactNotes') AND name='XIE1_ClientContactNotes')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_ClientContactNotes] ON [dbo].[ClientContactNotes] 
		(
		ClientId,
		ContactReason
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('ClientContactNotes') AND name='XIE1_ClientContactNotes')
		PRINT '<<< CREATED INDEX ClientContactNotes.XIE1_ClientContactNotes >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX ClientContactNotes.XIE1_ClientContactNotes >>>', 16, 1)		
		END	
		
		
		IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('ClientContactNotes') AND name='XIE2_ClientContactNotes')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE2_ClientContactNotes] ON [dbo].[ClientContactNotes] 
		(
		ContactDateTime,
		ContactReason
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('ClientContactNotes') AND name='XIE2_ClientContactNotes')
		PRINT '<<< CREATED INDEX ClientContactNotes.XIE2_ClientContactNotes >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX ClientContactNotes.XIE2_ClientContactNotes >>>', 16, 1)		
	END	
		
PRINT 'STEP 3 COMPLETED'	
END	
 
-----END Of STEP 3------------

------ STEP 4 ----------------

----END Of STEP 4-------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ---------------

------ STEP 7 ----------------

IF ((select DataModelVersion FROM SystemConfigurations)  = 15.92)
BEGIN
Update SystemConfigurations set DataModelVersion=15.93
PRINT 'STEP 7 COMPLETED'
END
Go




----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 16.21)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 16.21 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END

------ STEP 2 -----------

-----End of Step 2 -------

------ STEP 3 ------------
IF OBJECT_ID('AdjudicationDenialPendedReasons')IS NOT NULL
BEGIN
	IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('AdjudicationDenialPendedReasons') AND name='XIE1_AdjudicationDenialPendedReasons')
			BEGIN
			CREATE NONCLUSTERED INDEX [XIE1_AdjudicationDenialPendedReasons] ON [dbo].[AdjudicationDenialPendedReasons] 
			(
			AdjudicationId ASC
			)
			WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
			IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('AdjudicationDenialPendedReasons') AND name='XIE1_AdjudicationDenialPendedReasons')
			PRINT '<<< CREATED INDEX AdjudicationDenialPendedReasons.XIE1_AdjudicationDenialPendedReasons >>>'
			ELSE
			RAISERROR('<<< FAILED CREATING INDEX AdjudicationDenialPendedReasons.XIE1_AdjudicationDenialPendedReasons >>>', 16, 1)		
			END	
	PRINT 'STEP 3 COMPLETED'
END

IF OBJECT_ID('HealthDataAttributes') IS NOT NULL
BEGIN
	 IF COL_LENGTH('HealthDataAttributes','DropdownType') IS NULL
	 BEGIN
		ALTER TABLE  HealthDataAttributes  ADD DropdownType CHAR(1)	 NULL
	 END
	 
	 IF COL_LENGTH('HealthDataAttributes','SharedTableName') IS NULL
	 BEGIN
		ALTER TABLE  HealthDataAttributes  ADD SharedTableName VARCHAR(100)	 NULL
	 END
	 
	 IF COL_LENGTH('HealthDataAttributes','StoredProcedureName') IS NULL
	 BEGIN
		ALTER TABLE  HealthDataAttributes  ADD StoredProcedureName VARCHAR(100)	 NULL
	 END
	 
	 IF COL_LENGTH('HealthDataAttributes','ValueField') IS NULL
	 BEGIN
		ALTER TABLE  HealthDataAttributes  ADD ValueField VARCHAR(100)	 NULL
	 END
	 
	 IF COL_LENGTH('HealthDataAttributes','TextField') IS NULL
	 BEGIN
		ALTER TABLE  HealthDataAttributes  ADD TextField VARCHAR(100)	 NULL
	 END
	 
PRINT 'STEP 3 COMPLETED'
END

----END Of STEP 3--------
------ STEP 4 ------------
----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 16.21)
BEGIN
Update SystemConfigurations set DataModelVersion=16.22
PRINT 'STEP 7 COMPLETED'
END
Go
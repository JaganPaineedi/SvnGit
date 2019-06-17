----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 16.13)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 16.13 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 -----------

-----End of Step 2 -------

------ STEP 3 ------------

-----END Of STEP 3---------
-- added columns  in ClientHealthDataAttributes

IF OBJECT_ID('ClientHealthDataAttributes')IS NOT NULL
BEGIN
	IF COL_LENGTH('ClientHealthDataAttributes','Locked') IS NULL
	BEGIN
		ALTER TABLE ClientHealthDataAttributes ADD  Locked type_YOrN	NULL
											   CHECK (Locked in ('Y','N'))
	END		
	
	IF COL_LENGTH('ClientHealthDataAttributes','LockedBy') IS NULL
	BEGIN
		ALTER TABLE ClientHealthDataAttributes ADD  LockedBy type_UserId NULL
	END		
	
	IF COL_LENGTH('ClientHealthDataAttributes','LockedDate') IS NULL
	BEGIN
		ALTER TABLE ClientHealthDataAttributes ADD  LockedDate datetime NULL
	END	
	    PRINT 'STEP 3 COMPLETED'
END    

------ STEP 4 ------------

----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 16.13)
BEGIN
Update SystemConfigurations set DataModelVersion=16.14
PRINT 'STEP 7 COMPLETED'
END
Go


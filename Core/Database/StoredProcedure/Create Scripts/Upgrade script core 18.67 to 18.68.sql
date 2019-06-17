----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 18.67)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 18.67 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------
-------------------------------------------------------------

------ STEP 3 ------------
IF OBJECT_ID('ClientOrderObservations') IS NOT NULL
BEGIN

	IF COL_LENGTH('ClientOrderObservations','ObservationRange') IS NULL
	BEGIN
		 ALTER TABLE ClientOrderObservations ADD ObservationRange varchar(200) NULL
	END

	PRINT 'STEP 3 COMPLETED'

END
	
--END Of STEP 3------------
------ STEP 4 ----------

------END Of STEP 4---------------

------ STEP 5 ----------------

-------END STEP 5-------------
------ STEP 6  ----------

----END Of STEP 6 ------------

------ STEP 7 -----------
IF ((select DataModelVersion FROM SystemConfigurations)  = 18.67)
BEGIN
Update SystemConfigurations set DataModelVersion=18.68
PRINT 'STEP 7 COMPLETED'
END
Go

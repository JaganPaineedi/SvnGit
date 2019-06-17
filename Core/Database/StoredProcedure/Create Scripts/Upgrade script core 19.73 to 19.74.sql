----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 19.73)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 19.73 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------
--Part1 Begin
--Part1 Ends

--Part2 Begins


--Part2 Ends
-----End of Step 2 -------

------ STEP 3 ------------

IF OBJECT_ID('ClaimUB04s') IS NOT NULL
BEGIN

	IF COL_LENGTH('ClaimUB04s','Field76AttendingProviderId') IS NOT NULL
	BEGIN
	 ALTER TABLE ClaimUB04s ALTER COLUMN  Field76AttendingProviderId varchar(25) NULL
	END

	 PRINT 'STEP 3 COMPLETED'
END
------ END OF STEP 3 -----

------ STEP 4 ----------

--END Of STEP 4

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------
------ STEP 7 -----------
IF ((select DataModelVersion FROM SystemConfigurations)  = 19.73)
BEGIN
Update SystemConfigurations set DataModelVersion=19.74
PRINT 'STEP 7 COMPLETED'
END
Go
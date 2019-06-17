----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 15.49)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 15.49 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END

------ STEP 2 ----------
--Part1 Begin

--Part1 Ends

--Part2 Begins

--Part2 Ends	

-----End of Step 2 -------

------ STEP 3 ------------
-----END Of STEP 3--------------------

IF OBJECT_ID('Clients') IS NOT NULL
BEGIN
IF COL_LENGTH('Clients','GenderIdentity') IS  NULL
	BEGIN
	 ALTER TABLE Clients ADD  GenderIdentity type_GlobalCode	NULL										 
	END
PRINT 'STEP 3 COMPLETED'
END
------ STEP 4 ------------

----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------
------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 15.49)
BEGIN
Update SystemConfigurations set DataModelVersion=15.50
PRINT 'STEP 7 COMPLETED'
END
Go
----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 15.26)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 15.26 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END

------ STEP 2 ----------
--Part1 Begin


--Part1 Ends

--Part2 Begins

--Part2 Ends	

-----End of Step 2 -------

 

------ STEP 3 ------------

IF OBJECT_ID('ClientFees') IS NOT NULL
BEGIN
	IF COL_LENGTH('ClientFees','Priority')IS NULL
	BEGIN 
		ALTER TABLE ClientFees ADD Priority int NULL										
	END	
	PRINT 'STEP 3 COMPLETED'
END
GO

-----END Of STEP 3--------------------

------ STEP 4 ------------
----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------
------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 15.26)
BEGIN
Update SystemConfigurations set DataModelVersion=15.27
PRINT 'STEP 7 COMPLETED'
END
Go
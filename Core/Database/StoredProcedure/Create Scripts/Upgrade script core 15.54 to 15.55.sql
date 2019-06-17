----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 15.54)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 15.54 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END

------ STEP 2 ----------
--Part1 Begin


--Part1 Ends

--Part2 Begins

--Part2 Ends	

-----End of Step 2 ------- 

------ STEP 3 ------------
IF OBJECT_ID('ClaimNPIHCFA1500s')  IS NOT NULL
BEGIN
		IF COL_LENGTH('ClaimNPIHCFA1500s','Field21Diagnosis12') IS NOT NULL
		BEGIN
		 ALTER TABLE ClaimNPIHCFA1500s ALTER COLUMN Field21Diagnosis12 VARCHAR(4)  NULL
		END
		
		IF COL_LENGTH('ClaimNPIHCFA1500s','Field21Diagnosis22') IS NOT NULL
		BEGIN
		 ALTER TABLE ClaimNPIHCFA1500s ALTER COLUMN Field21Diagnosis22 VARCHAR(4)  NULL
		END
		
		IF COL_LENGTH('ClaimNPIHCFA1500s','Field21Diagnosis32') IS NOT NULL
		BEGIN
		 ALTER TABLE ClaimNPIHCFA1500s ALTER COLUMN Field21Diagnosis32 VARCHAR(4)  NULL
		END
		
		IF COL_LENGTH('ClaimNPIHCFA1500s','Field21Diagnosis42') IS NOT NULL
		BEGIN
		 ALTER TABLE ClaimNPIHCFA1500s ALTER COLUMN Field21Diagnosis42 VARCHAR(4)  NULL
		END
PRINT 'STEP 3 COMPLETED'		
END	
-----END Of STEP 3--------------------

------ STEP 4 ------------
----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------
------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 15.54)
BEGIN
Update SystemConfigurations set DataModelVersion=15.55
PRINT 'STEP 7 COMPLETED'
END
Go
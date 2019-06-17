----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 15.71)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 15.71 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------

-----End of STEP 2 -------

------ STEP 3 ----------------

-- Added column ICD10CodeType  in DiagnosisICD10Codes Table

IF OBJECT_ID('DiagnosisICD10Codes')  IS NOT NULL
BEGIN
		IF COL_LENGTH('DiagnosisICD10Codes','ICD10CodeType') IS NULL
		BEGIN
		 ALTER TABLE DiagnosisICD10Codes ADD ICD10CodeType  char(3)  NULL
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

IF ((select DataModelVersion FROM SystemConfigurations)  = 15.71)
BEGIN
Update SystemConfigurations set DataModelVersion=15.72
PRINT 'STEP 7 COMPLETED'
END
Go




----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 16.24)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 16.24 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ------------

-----End of Step 2 -------

------ STEP 3 ------------

IF OBJECT_ID('DocumentLOCUS') IS NOT NULL
BEGIN
	IF COL_LENGTH('DocumentLOCUS','CurrentLevelOfCare') IS NULL
	BEGIN
		ALTER TABLE DocumentLOCUS ADD CurrentLevelOfCare VARCHAR(250) NULL
	END
	
	IF COL_LENGTH('DocumentLOCUS','ActualDisposition') IS NULL
	BEGIN
		ALTER TABLE DocumentLOCUS ADD ActualDisposition type_GlobalCode NULL
	END
	
	IF COL_LENGTH('DocumentLOCUS','ReasonForVariance') IS NULL
	BEGIN
		ALTER TABLE DocumentLOCUS ADD ReasonForVariance type_GlobalCode NULL
	END
	
	IF COL_LENGTH('DocumentLOCUS','ProgramReferredTo') IS NULL
	BEGIN
		ALTER TABLE DocumentLOCUS ADD ProgramReferredTo type_GlobalCode NULL
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

IF ((select DataModelVersion FROM SystemConfigurations)  = 16.24)
BEGIN
Update SystemConfigurations set DataModelVersion=16.25
PRINT 'STEP 7 COMPLETED'
END
Go




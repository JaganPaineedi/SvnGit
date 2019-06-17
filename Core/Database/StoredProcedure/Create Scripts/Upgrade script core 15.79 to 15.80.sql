----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 15.79)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 15.79 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------

-----End of STEP 2 -------

------ STEP 3 ----------------

-- Added column(s) in DocumentFamilyHistory Table

IF OBJECT_ID('DocumentFamilyHistory')  IS NOT NULL
BEGIN
		IF COL_LENGTH('DocumentFamilyHistory','ICD9Code') IS NULL
		BEGIN
		 ALTER TABLE DocumentFamilyHistory ADD ICD9Code  varchar(20)  NULL
		END
		
		IF COL_LENGTH('DocumentFamilyHistory','ICD10CodeId') IS NULL
		BEGIN
		 ALTER TABLE DocumentFamilyHistory ADD ICD10CodeId  INT  NULL
		END
		
		IF COL_LENGTH('DocumentFamilyHistory','SNOMEDCODE') IS NULL
		BEGIN
		 ALTER TABLE DocumentFamilyHistory ADD SNOMEDCODE  varchar(20)  NULL
		END 
		
		IF COL_LENGTH('DocumentFamilyHistory','ICD10CodeId') IS NOT NULL
		BEGIN
			IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[DiagnosisICD10Codes_DocumentFamilyHistory_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[DocumentFamilyHistory]'))
			BEGIN
			ALTER TABLE DocumentFamilyHistory   ADD  CONSTRAINT DiagnosisICD10Codes_DocumentFamilyHistory_FK
				FOREIGN KEY(ICD10CodeId)
				REFERENCES DiagnosisICD10Codes(ICD10CodeId)
			END
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

IF ((select DataModelVersion FROM SystemConfigurations)  = 15.79)
BEGIN
Update SystemConfigurations set DataModelVersion=15.80
PRINT 'STEP 7 COMPLETED'
END
Go




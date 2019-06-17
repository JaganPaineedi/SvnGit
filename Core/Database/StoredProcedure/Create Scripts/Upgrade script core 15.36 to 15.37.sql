----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  <  15.36)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version  15.36 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END

------ STEP 2 ----------
--Part1 Begin


--Part1 Ends

--Part2 Begins

--Part2 Ends	

-----End of Step 2 ------- 

------ STEP 3 ------------

IF OBJECT_ID('MedAdminRecords') IS NOT NULL
BEGIN	
	IF COL_LENGTH('MedAdminRecords','ClientMedicationInstructionId') IS NULL
	BEGIN
		ALTER TABLE MedAdminRecords ADD ClientMedicationInstructionId   int	NULL			  
	END
	
	IF COL_LENGTH('MedAdminRecords','ClientMedicationInstructionId')IS  NOT NULL
	BEGIN
		IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[ClientMedicationInstructions_MedAdminRecords_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[MedAdminRecords]'))	
		BEGIN
			ALTER TABLE MedAdminRecords ADD CONSTRAINT ClientMedicationInstructions_MedAdminRecords_FK
			FOREIGN KEY (ClientMedicationInstructionId)
			REFERENCES ClientMedicationInstructions(ClientMedicationInstructionId)	 
		END 
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

IF ((select DataModelVersion FROM SystemConfigurations)  =  15.36)
BEGIN
Update SystemConfigurations set DataModelVersion= 15.37
PRINT 'STEP 7 COMPLETED'
END
Go
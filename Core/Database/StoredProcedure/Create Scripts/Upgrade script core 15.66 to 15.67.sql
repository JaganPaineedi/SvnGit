----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  <  15.66)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version  15.66 for update.Upgrade Script Failed.>>>', 16, 1)
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
IF OBJECT_ID('HL7DocumentInboundMessageMappings') IS NOT NULL
BEGIN
IF COL_LENGTH('HL7DocumentInboundMessageMappings','ExternalRXOrderNumber') IS  NULL
	BEGIN
	 ALTER TABLE HL7DocumentInboundMessageMappings ADD  ExternalRXOrderNumber varchar(50) NULL
	END
	
IF COL_LENGTH('HL7DocumentInboundMessageMappings','Status') IS  NULL
	BEGIN
	 ALTER TABLE HL7DocumentInboundMessageMappings ADD  Status type_GlobalCode  NULL
	END	


IF COL_LENGTH('HL7DocumentInboundMessageMappings','Comment') IS  NULL
	BEGIN
	 ALTER TABLE HL7DocumentInboundMessageMappings ADD  Comment type_Comment2  NULL
	END	


END
IF OBJECT_ID('ClientMedicationReconciliations') IS NOT NULL
BEGIN
IF COL_LENGTH('ClientMedicationReconciliations','ClientMedicationId') IS  NULL
	BEGIN
	 ALTER TABLE ClientMedicationReconciliations ADD  ClientMedicationId  int NULL
	END
	
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[ClientMedications_ClientMedicationReconciliations_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[ClientMedicationReconciliations]'))
		BEGIN
		ALTER TABLE ClientMedicationReconciliations   ADD  CONSTRAINT ClientMedications_ClientMedicationReconciliations_FK
			FOREIGN KEY(ClientMedicationId)
			REFERENCES ClientMedications(ClientMedicationId)
		END	
END	
PRINT 'STEP 3 COMPLETED'

------ STEP 4 ------------

----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------
------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  =  15.66)
BEGIN
Update SystemConfigurations set DataModelVersion= 15.67
PRINT 'STEP 7 COMPLETED'
END
Go
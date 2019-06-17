----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 15.60)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 15.60 for update.Upgrade Script Failed.>>>', 16, 1)
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

------ STEP 4 ------------

IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='MDMedicationsRxNorm')
BEGIN
/* 
 * TABLE: MDMedicationsRxNorm 
 */
CREATE TABLE MDMedicationsRxNorm(
			MedicationsRxNormId							int	identity(1,1)		NOT NULL,
			CreatedBy									type_CurrentUser        NULL,
			CreatedDate									type_CurrentDatetime    NULL,
			ModifiedBy									type_CurrentUser        NULL,
			ModifiedDate								type_CurrentDatetime    NULL,
			RecordDeleted								type_YOrN               NULL
														CHECK (RecordDeleted in ('Y','N')),
			DeletedBy									type_UserId             NULL,
			DeletedDate									datetime				NULL,
			MedicationId								int						NULL,
			RxNorm										varchar(max)			NULL,
			SemanticClinicalDrug						varchar(5)				NULL,
			SemanticBrandedDrug							varchar(5)				NULL,
			DerivationViaClinicalFormulation			varchar(5)				NULL,
			DerivationViaCommonNDC						varchar(5)				NULL,
			CONSTRAINT MDMedicationsRxNorm_PK PRIMARY KEY CLUSTERED (MedicationsRxNormId) 
 )
 

  IF OBJECT_ID('MDMedicationsRxNorm') IS NOT NULL
    PRINT '<<< CREATED TABLE MDMedicationsRxNorm >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE MDMedicationsRxNorm >>>', 16, 1)
    
    IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[MDMedicationsRxNorm]') AND name = N'XIE1_MDMedicationsRxNorm')
	BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_MDMedicationsRxNorm] ON [dbo].[MDMedicationsRxNorm] 
		(
		[MedicationId] ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('MDMedicationsRxNorm') AND name='XIE1_MDMedicationsRxNorm')
		PRINT '<<< CREATED INDEX MDMedicationsRxNorm.XIE1_MDMedicationsRxNorm >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX MDMedicationsRxNorm.XIE1_MDMedicationsRxNorm >>>', 16, 1)		
	END

	
/* 
 * TABLE: MDMedicationsRxNorm 
 */ 
 
ALTER TABLE MDMedicationsRxNorm ADD CONSTRAINT MDMedications_MDMedicationsRxNorm_FK 
	FOREIGN KEY (MedicationId)
	REFERENCES MDMedications(MedicationId)
 
	PRINT 'STEP 4(A) COMPLETED'
END

IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='MDNDCMedications')
BEGIN
/* 
 * TABLE: MDNDCMedications 
 */
CREATE TABLE MDNDCMedications(
			NDCMedicationId								int	identity(1,1)		NOT NULL,
			CreatedBy									type_CurrentUser        NULL,
			CreatedDate									type_CurrentDatetime    NULL,
			ModifiedBy									type_CurrentUser        NULL,
			ModifiedDate								type_CurrentDatetime    NULL,
			RecordDeleted								type_YOrN               NULL
														CHECK (RecordDeleted in ('Y','N')),
			DeletedBy									type_UserId             NULL,
			DeletedDate									datetime				NULL,
			MedicationId								int						NULL,
			NDCCode										varchar(30)				NULL,
			CONSTRAINT MDNDCMedications_PK PRIMARY KEY CLUSTERED (NDCMedicationId) 
 )
 
  IF OBJECT_ID('MDNDCMedications') IS NOT NULL
    PRINT '<<< CREATED TABLE MDNDCMedications >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE MDNDCMedications >>>', 16, 1)
    
     IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[MDNDCMedications]') AND name = N'XIE1_MDNDCMedications')
	BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_MDNDCMedications] ON [dbo].[MDNDCMedications] 
		(
		[MedicationId] ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('MDNDCMedications') AND name='XIE1_MDNDCMedications')
		PRINT '<<< CREATED INDEX MDNDCMedications.XIE1_MDNDCMedications >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX MDNDCMedications.XIE1_MDNDCMedications >>>', 16, 1)		
	END

	
/* 
 * TABLE: MDNDCMedications 
 */ 
 
ALTER TABLE MDNDCMedications ADD CONSTRAINT MDMedications_MDNDCMedications_FK 
	FOREIGN KEY (MedicationId)
	REFERENCES MDMedications(MedicationId)
  
	PRINT 'STEP 4(B) COMPLETED'
END

----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------
------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 15.60)
BEGIN
Update SystemConfigurations set DataModelVersion=15.61
PRINT 'STEP 7 COMPLETED'
END
Go
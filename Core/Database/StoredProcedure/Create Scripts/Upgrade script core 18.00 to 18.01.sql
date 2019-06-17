----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 18.00)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 18.00 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------

-----End of Step 2 -------
------ STEP 3 ------------

------ STEP 4 ---------------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='ADTHospitalMaster')
BEGIN
/* 
 * TABLE:  ADTHospitalMaster 
 */
 
 CREATE TABLE ADTHospitalMaster(
		ADTHospitalMasterId					INT IDENTITY(1,1)		NOT NULL,
		CreatedBy							type_CurrentUser		NOT NULL,
		CreatedDate							type_CurrentDatetime	NOT NULL,
		ModifiedBy							type_CurrentUser		NOT NULL,
		ModifiedDate						type_CurrentDatetime	NOT NULL,
		RecordDeleted						type_YOrN				NULL
											CHECK (RecordDeleted in	('Y','N')),	
		DeletedBy							type_UserId				NULL,
		DeletedDate							datetime				NULL,
		HospitalName						varchar(250)			NULL,
		SendingFacilityIdentifier			varchar(500)			NULL,
		HealthSystem						varchar(500)			NULL,
		ADT									varchar(5)				NULL,	
		CONSTRAINT ADTHospitalMaster_PK PRIMARY KEY CLUSTERED (ADTHospitalMasterId)
 ) 
 IF OBJECT_ID('ADTHospitalMaster') IS NOT NULL
	PRINT '<<< CREATED TABLE ADTHospitalMaster >>>'
ELSE
	RAISERROR('<<< FAILED CREATING TABLE ADTHospitalMaster >>>', 16, 1)	
		
/* 
 * TABLE: ADTHospitalMaster 
 */	

		
PRINT 'STEP 4(A) COMPLETED'
		
END

 
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='ADTHospitalizations')
BEGIN
/* 
 * TABLE:  ADTHospitalizations 
 */
 
 CREATE TABLE ADTHospitalizations(
		ADTHospitalizationId				INT IDENTITY(1,1)		NOT NULL,
		CreatedBy							type_CurrentUser		NOT NULL,
		CreatedDate							type_CurrentDatetime	NOT NULL,
		ModifiedBy							type_CurrentUser		NOT NULL,
		ModifiedDate						type_CurrentDatetime	NOT NULL,
		RecordDeleted						type_YOrN				NULL
											CHECK (RecordDeleted in	('Y','N')),	
		DeletedBy							type_UserId				NULL,
		DeletedDate							datetime				NULL,
		ClientId							int						NULL,
		AssignedReviewerId					int						NULL,
		AdmissionDateTime					datetime				NULL,
		DischargeDateTime					datetime				NULL,		
		CONSTRAINT ADTHospitalizations_PK PRIMARY KEY CLUSTERED (ADTHospitalizationId)
 ) 
 IF OBJECT_ID('ADTHospitalizations') IS NOT NULL
	PRINT '<<< CREATED TABLE ADTHospitalizations >>>'
ELSE
	RAISERROR('<<< FAILED CREATING TABLE ADTHospitalizations >>>', 16, 1)	
	
 IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('ADTHospitalizations') AND name='XIE1_ADTHospitalizations')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_ADTHospitalizations] ON [dbo].[ADTHospitalizations] 
		(
		ClientId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('ADTHospitalizations') AND name='XIE1_ADTHospitalizations')
		PRINT '<<< CREATED INDEX ADTHospitalizations.XIE1_ADTHospitalizations >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX ADTHospitalizations.XIE1_ADTHospitalizations >>>', 16, 1)		
		END 
		
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('ADTHospitalizations') AND name='XIE2_ADTHospitalizations')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE2_ADTHospitalizations] ON [dbo].[ADTHospitalizations] 
		(
		AssignedReviewerId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('ADTHospitalizations') AND name='XIE2_ADTHospitalizations')
		PRINT '<<< CREATED INDEX ADTHospitalizations.XIE2_ADTHospitalizations >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX ADTHospitalizations.XIE2_ADTHospitalizations >>>', 16, 1)		
		END 
		
	
/* 
 * TABLE: ADTHospitalizations 
 */	

ALTER TABLE ADTHospitalizations ADD CONSTRAINT Clients_ADTHospitalizations_FK 
	FOREIGN KEY (ClientId)
	REFERENCES Clients(ClientId)
	
ALTER TABLE ADTHospitalizations ADD CONSTRAINT Staff_ADTHospitalizations_FK 
	FOREIGN KEY (AssignedReviewerId)
	REFERENCES Staff(StaffId)
	
		
PRINT 'STEP 4(B) COMPLETED'
		
END

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='ADTHospitalizationDetails')
BEGIN
/* 
 * TABLE:  ADTHospitalizationDetails 
 */
 
 CREATE TABLE ADTHospitalizationDetails(
		ADTHospitalizationDetailId			INT IDENTITY(1,1)		NOT NULL,
		CreatedBy							type_CurrentUser		NOT NULL,
		CreatedDate							type_CurrentDatetime	NOT NULL,
		ModifiedBy							type_CurrentUser		NOT NULL,
		ModifiedDate						type_CurrentDatetime	NOT NULL,
		RecordDeleted						type_YOrN				NULL
											CHECK (RecordDeleted in	('Y','N')),	
		DeletedBy							type_UserId				NULL,
		DeletedDate							datetime				NULL,
		ADTHospitalizationId				int						NULL,
		MessageType							type_GlobalCode			NULL,
		PatientName							varchar(150)			NULL,
		DateOfBirth							datetime				NULL,						
		PatientAddress						varchar(max)			NULL,
		MaritalStatus						varchar(250)			NULL,
		MRN									varchar(30)				NULL,			
		SSN									varchar(25)				NULL,
		Gender								varchar(50)				NULL,
		Race								varchar(250)			NULL,
		PrimaryLanguage						varchar(250)			NULL,
		PhoneNumber							varchar(80)				NULL,
		InsuranceCompany					varchar(250)			NULL,
		PolicyId							varchar(150)			NULL,
		VisitType							varchar(250)			NULL,
		Hospital							varchar(500)			NULL,
		PresentingProblem					type_Comment2			NULL,
		AdmissionDateTime					datetime				NULL,					
		DischargeDateTime					datetime				NULL,
		UpdateDateTime						datetime				NULL,
		TransferDateTime					datetime				NULL,
		CurrentBed							varchar(250)			NULL,
		PreviousBed							varchar(250)			NULL,
		DischargeDisposition				type_Comment2			NULL,		
		CONSTRAINT ADTHospitalizationDetails_PK PRIMARY KEY CLUSTERED (ADTHospitalizationDetailId)
 ) 
 IF OBJECT_ID('ADTHospitalizationDetails') IS NOT NULL
	PRINT '<<< CREATED TABLE ADTHospitalizationDetails >>>'
ELSE
	RAISERROR('<<< FAILED CREATING TABLE ADTHospitalizationDetails >>>', 16, 1)	
	
 IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('ADTHospitalizationDetails') AND name='XIE1_ADTHospitalizationDetails')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_ADTHospitalizationDetails] ON [dbo].[ADTHospitalizationDetails] 
		(
		ADTHospitalizationId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('ADTHospitalizationDetails') AND name='XIE1_ADTHospitalizationDetails')
		PRINT '<<< CREATED INDEX ADTHospitalizationDetails.XIE1_ADTHospitalizationDetails >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX ADTHospitalizationDetails.XIE1_ADTHospitalizationDetails >>>', 16, 1)		
		END 
		
	
/* 
 * TABLE: ADTHospitalizationDetails 
 */	



ALTER TABLE ADTHospitalizationDetails ADD CONSTRAINT ADTHospitalizations_ADTHospitalizationDetails_FK 
	FOREIGN KEY (ADTHospitalizationId)
	REFERENCES ADTHospitalizations(ADTHospitalizationId)
		
PRINT 'STEP 4(C) COMPLETED'
		
END


IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='ADTHospitalizationDiagnosis')
BEGIN
/* 
 * TABLE:  ADTHospitalizationDiagnosis 
 */
 
 CREATE TABLE ADTHospitalizationDiagnosis(
		ADTHospitalizationDiagnosisId		INT IDENTITY(1,1)		NOT NULL,
		CreatedBy							type_CurrentUser		NOT NULL,
		CreatedDate							type_CurrentDatetime	NOT NULL,
		ModifiedBy							type_CurrentUser		NOT NULL,
		ModifiedDate						type_CurrentDatetime	NOT NULL,
		RecordDeleted						type_YOrN				NULL
											CHECK (RecordDeleted in	('Y','N')),	
		DeletedBy							type_UserId				NULL,
		DeletedDate							datetime				NULL,
		ADTHospitalizationDetailId			int						NULL,
		Code								varchar(250)			NULL,
		DiagnosisDescription				type_Comment2			NULL,
		DiagnosisType						varchar(50)				NULL,										
		CONSTRAINT ADTHospitalizationDiagnosis_PK PRIMARY KEY CLUSTERED (ADTHospitalizationDiagnosisId)
 ) 
 IF OBJECT_ID('ADTHospitalizationDiagnosis') IS NOT NULL
	PRINT '<<< CREATED TABLE ADTHospitalizationDiagnosis >>>'
ELSE
	RAISERROR('<<< FAILED CREATING TABLE ADTHospitalizationDiagnosis >>>', 16, 1)	
	
 IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('ADTHospitalizationDiagnosis') AND name='XIE1_ADTHospitalizationDiagnosis')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_ADTHospitalizationDiagnosis] ON [dbo].[ADTHospitalizationDiagnosis] 
		(
		ADTHospitalizationDetailId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('ADTHospitalizationDiagnosis') AND name='XIE1_ADTHospitalizationDiagnosis')
		PRINT '<<< CREATED INDEX ADTHospitalizationDiagnosis.XIE1_ADTHospitalizationDiagnosis >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX ADTHospitalizationDiagnosis.XIE1_ADTHospitalizationDiagnosis >>>', 16, 1)		
		END 
		
	
/* 
 * TABLE: ADTHospitalizationDiagnosis 
 */	



ALTER TABLE ADTHospitalizationDiagnosis ADD CONSTRAINT ADTHospitalizationDetails_ADTHospitalizationDiagnosis_FK 
	FOREIGN KEY (ADTHospitalizationDetailId)
	REFERENCES ADTHospitalizationDetails(ADTHospitalizationDetailId)
		
PRINT 'STEP 4(D) COMPLETED'
		
END


IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='ADTHospitalizationDetailMessages')
BEGIN
/* 
 * TABLE:  ADTHospitalizationDetailMessages 
 */
 
 CREATE TABLE ADTHospitalizationDetailMessages(
		ADTHospitalizationDetailMessageId	INT IDENTITY(1,1)		NOT NULL,
		CreatedBy							type_CurrentUser		NOT NULL,
		CreatedDate							type_CurrentDatetime	NOT NULL,
		ModifiedBy							type_CurrentUser		NOT NULL,
		ModifiedDate						type_CurrentDatetime	NOT NULL,
		RecordDeleted						type_YOrN				NULL
											CHECK (RecordDeleted in	('Y','N')),	
		DeletedBy							type_UserId				NULL,
		DeletedDate							datetime				NULL,
		ADTHospitalizationDetailId			int						NULL,
		InboundMessage						xml						NULL,								
		CONSTRAINT ADTHospitalizationDetailMessages_PK PRIMARY KEY CLUSTERED (ADTHospitalizationDetailMessageId)
 ) 
 IF OBJECT_ID('ADTHospitalizationDetailMessages') IS NOT NULL
	PRINT '<<< CREATED TABLE ADTHospitalizationDetailMessages >>>'
ELSE
	RAISERROR('<<< FAILED CREATING TABLE ADTHospitalizationDetailMessages >>>', 16, 1)	
	
 IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('ADTHospitalizationDetailMessages') AND name='XIE1_ADTHospitalizationDetailMessages')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_ADTHospitalizationDetailMessages] ON [dbo].[ADTHospitalizationDetailMessages] 
		(
		ADTHospitalizationDetailId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('ADTHospitalizationDetailMessages') AND name='XIE1_ADTHospitalizationDetailMessages')
		PRINT '<<< CREATED INDEX ADTHospitalizationDetailMessages.XIE1_ADTHospitalizationDetailMessages >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX ADTHospitalizationDetailMessages.XIE1_ADTHospitalizationDetailMessages >>>', 16, 1)		
		END 
		
	
/* 
 * TABLE: ADTHospitalizationDetailMessages 
 */	



ALTER TABLE ADTHospitalizationDetailMessages ADD CONSTRAINT ADTHospitalizationDetails_ADTHospitalizationDetailMessages_FK 
	FOREIGN KEY (ADTHospitalizationDetailId)
	REFERENCES ADTHospitalizationDetails(ADTHospitalizationDetailId)
		
PRINT 'STEP 4(E) COMPLETED'
		
END

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='ADTHospitalizationDocumentVersions')
BEGIN
/* 
 * TABLE:  ADTHospitalizationDocumentVersions 
 */
 
 CREATE TABLE ADTHospitalizationDocumentVersions(
		ADTHospitalizationDocumentVersionId		INT IDENTITY(1,1)		NOT NULL,
		CreatedBy								type_CurrentUser		NOT NULL,
		CreatedDate								type_CurrentDatetime	NOT NULL,
		ModifiedBy								type_CurrentUser		NOT NULL,
		ModifiedDate							type_CurrentDatetime	NOT NULL,
		RecordDeleted							type_YOrN				NULL
												CHECK (RecordDeleted in	('Y','N')),	
		DeletedBy								type_UserId				NULL,
		DeletedDate								datetime				NULL,
		ADTHospitalizationId					int						NULL,
		DocumentVersionId						int						NULL,								
		CONSTRAINT ADTHospitalizationDocumentVersions_PK PRIMARY KEY CLUSTERED (ADTHospitalizationDocumentVersionId)
 ) 
 IF OBJECT_ID('ADTHospitalizationDocumentVersions') IS NOT NULL
	PRINT '<<< CREATED TABLE ADTHospitalizationDocumentVersions >>>'
ELSE
	RAISERROR('<<< FAILED CREATING TABLE ADTHospitalizationDocumentVersions >>>', 16, 1)	
	
 IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('ADTHospitalizationDocumentVersions') AND name='XIE1_ADTHospitalizationDocumentVersions')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_ADTHospitalizationDocumentVersions] ON [dbo].[ADTHospitalizationDocumentVersions] 
		(
		ADTHospitalizationId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('ADTHospitalizationDocumentVersions') AND name='XIE1_ADTHospitalizationDocumentVersions')
		PRINT '<<< CREATED INDEX ADTHospitalizationDocumentVersions.XIE1_ADTHospitalizationDocumentVersions >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX ADTHospitalizationDocumentVersions.XIE1_ADTHospitalizationDocumentVersions >>>', 16, 1)		
		END 
		
 IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('ADTHospitalizationDocumentVersions') AND name='XIE2_ADTHospitalizationDocumentVersions')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE2_ADTHospitalizationDocumentVersions] ON [dbo].[ADTHospitalizationDocumentVersions] 
		(
		DocumentVersionId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('ADTHospitalizationDocumentVersions') AND name='XIE2_ADTHospitalizationDocumentVersions')
		PRINT '<<< CREATED INDEX ADTHospitalizationDocumentVersions.XIE2_ADTHospitalizationDocumentVersions >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX ADTHospitalizationDocumentVersions.XIE2_ADTHospitalizationDocumentVersions >>>', 16, 1)		
		END 
		
	
/* 
 * TABLE: ADTHospitalizationDocumentVersions 
 */	



ALTER TABLE ADTHospitalizationDocumentVersions ADD CONSTRAINT ADTHospitalizations_ADTHospitalizationDocumentVersions_FK 
	FOREIGN KEY (ADTHospitalizationId)
	REFERENCES ADTHospitalizations(ADTHospitalizationId)
	
ALTER TABLE ADTHospitalizationDocumentVersions ADD CONSTRAINT DocumentVersions_ADTHospitalizationDocumentVersions_FK 
	FOREIGN KEY (DocumentVersionId)
	REFERENCES DocumentVersions(DocumentVersionId)
		
PRINT 'STEP 4(F) COMPLETED'
		
END

----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 18.00)
BEGIN
Update SystemConfigurations set DataModelVersion=18.01
PRINT 'STEP 7 COMPLETED'
END
Go


----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 15.63)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 15.63 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------
--Part1 Begin

--Part1 Ends

--Part2 Begins

--Part2 Ends	

-----End of Step 2 -------

------ STEP 3 ------------

IF OBJECT_ID('HL7DocumentInboundMessageMappings') IS NOT NULL
BEGIN

-- dropped the columns from HL7DocumentInboundMessageMappings

	IF COL_LENGTH('HL7DocumentInboundMessageMappings','Schedule') IS NOT NULL
	BEGIN
	 ALTER TABLE HL7DocumentInboundMessageMappings DROP COLUMN Schedule 					  
	END
	
	IF COL_LENGTH('HL7DocumentInboundMessageMappings','ScheduleId') IS NOT NULL
	BEGIN
	 ALTER TABLE HL7DocumentInboundMessageMappings DROP COLUMN ScheduleId 					  
	END
	
	IF COL_LENGTH('HL7DocumentInboundMessageMappings','MedicationStartDate') IS NOT NULL
	BEGIN
	 ALTER TABLE HL7DocumentInboundMessageMappings DROP COLUMN MedicationStartDate 					  
	END
	
	IF COL_LENGTH('HL7DocumentInboundMessageMappings','MedicationEndDate') IS NOT NULL
	BEGIN
	 ALTER TABLE HL7DocumentInboundMessageMappings DROP COLUMN MedicationEndDate 					  
	END
	
	IF COL_LENGTH('HL7DocumentInboundMessageMappings','TextInstruction') IS NOT NULL
	BEGIN
	 ALTER TABLE HL7DocumentInboundMessageMappings DROP COLUMN TextInstruction 					  
	END
	
	-- changed column 
	IF COL_LENGTH('HL7DocumentInboundMessageMappings','Quantity') IS NOT NULL
	BEGIN
	 ALTER TABLE HL7DocumentInboundMessageMappings ALTER COLUMN Quantity DECIMAL(10,2) NULL					  
	END
	
	-- added column 
	IF COL_LENGTH('HL7DocumentInboundMessageMappings','SequenceNo') IS  NULL
	BEGIN
	 ALTER TABLE HL7DocumentInboundMessageMappings ADD SequenceNo INT NULL					  
	END
	
	IF COL_LENGTH('HL7DocumentInboundMessageMappings','ExternalRXOrderNumber') IS  NULL
	BEGIN
	 ALTER TABLE HL7DocumentInboundMessageMappings ADD ExternalRXOrderNumber varchar(50) NULL 					  
	END
	
	IF COL_LENGTH('HL7DocumentInboundMessageMappings','Status') IS  NULL
	BEGIN
	 ALTER TABLE HL7DocumentInboundMessageMappings ADD [Status] type_GlobalCode  NULL					  
	END
	
	IF COL_LENGTH('HL7DocumentInboundMessageMappings','Comment') IS  NULL
	BEGIN
	 ALTER TABLE HL7DocumentInboundMessageMappings ADD Comment type_Comment2  NULL 					  
	END
	
END

-----END Of STEP 3--------------------

------ STEP 4 ------------
IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='HL7FrequencyMappings')
BEGIN
/* 
 * TABLE: HL7FrequencyMappings 
 */ 
CREATE TABLE HL7FrequencyMappings(
		HL7FrequencyMappingId		int identity(1,1)			NOT NULL,
		CreatedBy					type_CurrentUser			NOT NULL,
		CreatedDate					type_CurrentDatetime		NOT NULL,
		ModifiedBy					type_CurrentUser			NOT NULL,
		ModifiedDate				type_CurrentDatetime		NOT NULL,
		RecordDeleted				type_YOrN					NULL
									CHECK (RecordDeleted in ('Y','N')),
		DeletedBy					type_UserId					NULL,
		DeletedDate					datetime					NULL,
		VendorId					int							NULL,
		FrequencyId					type_GlobalCode				NULL,
		Frequency					varchar(10)					NULL,
		CONSTRAINT HL7FrequencyMappings_PK PRIMARY KEY CLUSTERED (HL7FrequencyMappingId)		 	
)
 IF OBJECT_ID('HL7FrequencyMappings') IS NOT NULL
    PRINT '<<< CREATED TABLE HL7FrequencyMappings >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE HL7FrequencyMappings >>>', 16, 1)
	
/*  
 * TABLE: HL7FrequencyMappings 
 */ 
 
 ALTER TABLE HL7FrequencyMappings ADD CONSTRAINT GlobalCodes_HL7FrequencyMappings_FK
    FOREIGN KEY (FrequencyId)
    REFERENCES GlobalCodes(GlobalCodeId)
    
 ALTER TABLE HL7FrequencyMappings ADD CONSTRAINT HL7CPVendorConfigurations_HL7FrequencyMappings_FK
    FOREIGN KEY (VendorId)
    REFERENCES  HL7CPVendorConfigurations(VendorId)
    
 PRINT 'STEP 4(A) COMPLETED'
END 


IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='HL7DosageMappings')
BEGIN
/* 
 * TABLE: HL7DosageMappings 
 */ 
CREATE TABLE HL7DosageMappings(
		HL7DosageMappingId			int identity(1,1)			NOT NULL,
		CreatedBy					type_CurrentUser			NOT NULL,
		CreatedDate					type_CurrentDatetime		NOT NULL,
		ModifiedBy					type_CurrentUser			NOT NULL,
		ModifiedDate				type_CurrentDatetime		NOT NULL,
		RecordDeleted				type_YOrN					NULL
									CHECK (RecordDeleted in ('Y','N')),
		DeletedBy					type_UserId					NULL,
		DeletedDate					datetime					NULL,
		VendorId					int							NULL,
		DosageFormId				int							NULL,
		Dosage						varchar(10)					NULL,	
		CONSTRAINT HL7DosageMappings_PK PRIMARY KEY CLUSTERED (HL7DosageMappingId)		 	
)
 IF OBJECT_ID('HL7DosageMappings') IS NOT NULL
    PRINT '<<< CREATED TABLE HL7DosageMappings >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE HL7DosageMappings >>>', 16, 1)
	
/*  
 * TABLE: HL7DosageMappings 
 */ 
 
 ALTER TABLE HL7DosageMappings ADD CONSTRAINT HL7CPVendorConfigurations_HL7DosageMappings_FK
    FOREIGN KEY (VendorId)
    REFERENCES HL7CPVendorConfigurations(VendorId)
    
 ALTER TABLE HL7DosageMappings ADD CONSTRAINT MDDosageForms_HL7DosageMappings_FK
    FOREIGN KEY (DosageFormId)
    REFERENCES  MDDosageForms(DosageFormId)
        
 PRINT 'STEP 4(B) COMPLETED'
END 


IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='HL7DocumentInboundMessageMappingsDeatils')
BEGIN
/* 
 * TABLE: HL7DocumentInboundMessageMappingsDeatils 
 */
CREATE TABLE HL7DocumentInboundMessageMappingsDeatils(
			HL7DocumentInboundMessageMappingsDeatilId	int	identity(1,1)		NOT NULL,
			CreatedBy									type_CurrentUser        NOT NULL,
			CreatedDate									type_CurrentDatetime    NOT NULL,
			ModifiedBy									type_CurrentUser        NOT NULL,
			ModifiedDate								type_CurrentDatetime    NOT NULL,
			RecordDeleted								type_YOrN               NULL
														CHECK (RecordDeleted in ('Y','N')),
			DeletedBy									type_UserId             NULL,
			DeletedDate									datetime				NULL,
			DocumentVersionId							int						NULL,
		    Schedule									varchar(100)			NULL,
		    ScheduleId									int						NULL,
		    MedicationStartDate							datetime				NULL,
		    MedicationEndDate							datetime				NULL,
		    TextInstruction								varchar(max)			NULL,
			CONSTRAINT HL7DocumentInboundMessageMappingsDeatils_PK PRIMARY KEY CLUSTERED (HL7DocumentInboundMessageMappingsDeatilId) 
 )
 
  IF OBJECT_ID('HL7DocumentInboundMessageMappingsDeatils') IS NOT NULL
    PRINT '<<< CREATED TABLE HL7DocumentInboundMessageMappingsDeatils >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE HL7DocumentInboundMessageMappingsDeatils >>>', 16, 1)  
	
/* 
 * TABLE: HL7DocumentInboundMessageMappingsDeatils 
 */ 
 
ALTER TABLE HL7DocumentInboundMessageMappingsDeatils ADD CONSTRAINT DocumentVersions_HL7DocumentInboundMessageMappingsDeatils_FK
	FOREIGN KEY (DocumentVersionId)
	REFERENCES DocumentVersions(DocumentVersionId)	 
		
 
	PRINT 'STEP 4(C) COMPLETED'
END

IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='HL7DocumentInboundMessageMappings')
BEGIN
/* 
 * TABLE: HL7DocumentInboundMessageMappings 
 */ 
CREATE TABLE HL7DocumentInboundMessageMappings(
		DocumentVersionId					int identity(1,1)			NOT NULL,
		CreatedBy							type_CurrentUser			NOT NULL,
		CreatedDate							type_CurrentDatetime		NOT NULL,
		ModifiedBy							type_CurrentUser			NOT NULL,
		ModifiedDate						type_CurrentDatetime		NOT NULL,
		RecordDeleted						type_YOrN					NULL
											CHECK (RecordDeleted in ('Y','N')),
		DeletedBy							type_UserId					NULL,
		DeletedDate							datetime					NULL,
		HL7CPQueueMessageID					int							NULL,
		ClientId							int							NULL,
		NationalDrugCode					varchar(11)					NULL,
		RxNormCode							varchar(100)				NULL,
		Quantity							decimal(10,2)				NULL,
		Unit								varchar(100)				NULL,
		UnitId								int							NULL,
		StrengthDescription					varchar(100)				NULL,
		StrengthId							int							NULL,
		MedicationName						varchar(100)				NULL,
		MedicationNameId					int							NULL,
		[Route]								varchar(100)				NULL,
		RouteId								int							NULL,
		SequenceNo							int							NULL,
		ExternalRXOrderNumber				varchar(50)					NULL,
		[Status]							type_GlobalCode			    NULL,
		Comment								type_Comment2				NULL,
		CONSTRAINT HL7DocumentInboundMessageMappings_PK PRIMARY KEY CLUSTERED (DocumentVersionId)		 	
)
 IF OBJECT_ID('HL7DocumentInboundMessageMappings') IS NOT NULL
    PRINT '<<< CREATED TABLE HL7DocumentInboundMessageMappings >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE HL7DocumentInboundMessageMappings >>>', 16, 1)
	
/*  
 * TABLE: HL7DocumentInboundMessageMappings 
 */ 
 
 ALTER TABLE HL7DocumentInboundMessageMappings ADD CONSTRAINT Clients_HL7DocumentInboundMessageMappings_FK
    FOREIGN KEY (ClientId)
    REFERENCES Clients(ClientId)
    
 ALTER TABLE HL7DocumentInboundMessageMappings ADD CONSTRAINT DocumentVersions_HL7DocumentInboundMessageMappings_FK
    FOREIGN KEY (DocumentVersionId)
    REFERENCES  DocumentVersions(DocumentVersionId)
    
 ALTER TABLE HL7DocumentInboundMessageMappings ADD CONSTRAINT HL7CPQueueMessages_HL7DocumentInboundMessageMappings_FK
    FOREIGN KEY (HL7CPQueueMessageID)
    REFERENCES  HL7CPQueueMessages(HL7CPQueueMessageID)
        
PRINT 'STEP 4(D) COMPLETED'
END


IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='HL7UnitMappings')
BEGIN
/* 
 * TABLE: HL7UnitMappings 
 */ 
CREATE TABLE HL7UnitMappings(
		HL7UnitMappingId			int identity(1,1)			NOT NULL,
		CreatedBy					type_CurrentUser			NOT NULL,
		CreatedDate					type_CurrentDatetime		NOT NULL,
		ModifiedBy					type_CurrentUser			NOT NULL,
		ModifiedDate				type_CurrentDatetime		NOT NULL,
		RecordDeleted				type_YOrN					NULL
									CHECK (RecordDeleted in ('Y','N')),
		DeletedBy					type_UserId					NULL,
		DeletedDate					datetime					NULL,
		VendorId					int							NULL,
		UnitId						int							NULL,
		Unit						varchar(10)					NULL,
		CONSTRAINT HL7UnitMappings_PK PRIMARY KEY CLUSTERED (HL7UnitMappingId)		 	
)
 IF OBJECT_ID('HL7UnitMappings') IS NOT NULL
    PRINT '<<< CREATED TABLE HL7UnitMappings >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE HL7UnitMappings >>>', 16, 1)
	
/*  
 * TABLE: HL7UnitMappings 
 */ 
 
 ALTER TABLE HL7UnitMappings ADD CONSTRAINT GlobalCodes_HL7UnitMappings_FK
    FOREIGN KEY (UnitId)
    REFERENCES GlobalCodes(GlobalCodeId)
    
 ALTER TABLE HL7UnitMappings ADD CONSTRAINT HL7CPVendorConfigurations_HL7UnitMappings_FK
    FOREIGN KEY (VendorId)
    REFERENCES  HL7CPVendorConfigurations(VendorId)
    
 PRINT 'STEP 4(E) COMPLETED'
END


IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='HL7RouteMappings')
BEGIN
/* 
 * TABLE: HL7RouteMappings 
 */ 
CREATE TABLE HL7RouteMappings(
		HL7RouteMappingId			int identity(1,1)			NOT NULL,
		CreatedBy					type_CurrentUser			NOT NULL,
		CreatedDate					type_CurrentDatetime		NOT NULL,
		ModifiedBy					type_CurrentUser			NOT NULL,
		ModifiedDate				type_CurrentDatetime		NOT NULL,
		RecordDeleted				type_YOrN					NULL
									CHECK (RecordDeleted in ('Y','N')),
		DeletedBy					type_UserId					NULL,
		DeletedDate					datetime					NULL,
		VendorId					int							NULL,
		RouteId						int							NULL,	
		[Route]						varchar(10)					NULL,
		CONSTRAINT HL7RouteMappings_PK PRIMARY KEY CLUSTERED (HL7RouteMappingId)		 	
)
 IF OBJECT_ID('HL7RouteMappings') IS NOT NULL
    PRINT '<<< CREATED TABLE HL7RouteMappings >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE HL7RouteMappings >>>', 16, 1)
	
/*  
 * TABLE: HL7RouteMappings 
 */ 
 
 ALTER TABLE HL7RouteMappings ADD CONSTRAINT HL7CPVendorConfigurations_HL7RouteMappings_FK
    FOREIGN KEY (VendorId)
    REFERENCES HL7CPVendorConfigurations(VendorId)
    
 ALTER TABLE HL7RouteMappings ADD CONSTRAINT MDRoutes_HL7RouteMappings_FK
    FOREIGN KEY (RouteId)
    REFERENCES  MDRoutes(RouteId)
    
 PRINT 'STEP 4(F) COMPLETED'
END 

----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 15.63)
BEGIN
Update SystemConfigurations set DataModelVersion=15.64
PRINT 'STEP 7 COMPLETED'
END
Go

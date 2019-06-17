----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 18.31)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 18.31 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------

-----End of Step 2 -------

------ STEP 3 ------------

------ END Of STEP 3 ------------

------ STEP 4 ---------------
IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='ImmunizationTransmissionLog')
BEGIN
/* 
 * TABLE: ImmunizationTransmissionLog 
 */
CREATE TABLE ImmunizationTransmissionLog(
	ImmunizationTransmissionLogId			int  identity(1,1)		NOT NULL,
    CreatedBy								type_CurrentUser        NOT NULL,
    CreatedDate								type_CurrentDatetime    NOT NULL,
    ModifiedBy								type_CurrentUser        NOT NULL,
    ModifiedDate							type_CurrentDatetime    NOT NULL,
    RecordDeleted							type_YOrN               NULL
											CHECK (RecordDeleted in ('Y','N')),
    DeletedBy								type_UserId             NULL,
    DeletedDate								datetime                NULL,
    ClientId								int						NULL,
	VaccineName								type_Comment2			NULL,
	ActionType								type_GlobalCode			NULL,
	ExportDateTime							datetime				NULL,
	AckResponse								datetime				NULL,
	AdministrationHL7Message				type_Comment2			NULL,
	AckHL7Message							type_Comment2			NULL,
	QueryHL7Message							type_Comment2			NULL,
	ResponseHL7Message						type_Comment2			NULL,
    CONSTRAINT ImmunizationTransmissionLog_PK PRIMARY KEY CLUSTERED (ImmunizationTransmissionLogId)
)
      
IF OBJECT_ID('ImmunizationTransmissionLog') IS NOT NULL
PRINT '<<< CREATED TABLE ImmunizationTransmissionLog >>>'
ELSE
RAISERROR('<<< FAILED CREATING TABLE ImmunizationTransmissionLog >>>', 16, 1)

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('ImmunizationTransmissionLog') AND name='XIE1_ImmunizationTransmissionLog')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_ImmunizationTransmissionLog] ON [dbo].[ImmunizationTransmissionLog] 
		(
		ClientId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('ImmunizationTransmissionLog') AND name='XIE1_ImmunizationTransmissionLog')
		PRINT '<<< CREATED INDEX ImmunizationTransmissionLog.XIE1_ImmunizationTransmissionLog >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX ImmunizationTransmissionLog.XIE1_ImmunizationTransmissionLog >>>', 16, 1)		
		END 
				
/* 
 * TABLE: ImmunizationTransmissionLog	 
 */
 
   
ALTER TABLE ImmunizationTransmissionLog ADD CONSTRAINT Clients_ImmunizationTransmissionLog_FK
    FOREIGN KEY (ClientId)
    REFERENCES Clients(ClientId) 
 

 PRINT 'STEP 4(A) COMPLETED'  
END

IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='ImmunizationAdministrationLog')
BEGIN
/* 
 * TABLE: ImmunizationAdministrationLog 
 */
CREATE TABLE ImmunizationAdministrationLog(
	ImmunizationAdministrationLogId			int  identity(1,1)		NOT NULL,
    CreatedBy								type_CurrentUser        NOT NULL,
    CreatedDate								type_CurrentDatetime    NOT NULL,
    ModifiedBy								type_CurrentUser        NOT NULL,
    ModifiedDate							type_CurrentDatetime    NOT NULL,
    RecordDeleted							type_YOrN               NULL
											CHECK (RecordDeleted in ('Y','N')),
    DeletedBy								type_UserId             NULL,
    DeletedDate								datetime                NULL,
    ImmunizationTransmissionLogId			int						NULL,
    ClientImmunizationId					int						NULL,
    CONSTRAINT ImmunizationAdministrationLog_PK PRIMARY KEY CLUSTERED (ImmunizationAdministrationLogId)
)
      
IF OBJECT_ID('ImmunizationAdministrationLog') IS NOT NULL
PRINT '<<< CREATED TABLE ImmunizationAdministrationLog >>>'
ELSE
RAISERROR('<<< FAILED CREATING TABLE ImmunizationAdministrationLog >>>', 16, 1)

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('ImmunizationAdministrationLog') AND name='XIE1_ImmunizationAdministrationLog')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_ImmunizationAdministrationLog] ON [dbo].[ImmunizationAdministrationLog] 
		(
		ImmunizationTransmissionLogId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('ImmunizationAdministrationLog') AND name='XIE1_ImmunizationAdministrationLog')
		PRINT '<<< CREATED INDEX ImmunizationAdministrationLog.XIE1_ImmunizationAdministrationLog >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX ImmunizationAdministrationLog.XIE1_ImmunizationAdministrationLog >>>', 16, 1)		
		END 
		
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('ImmunizationAdministrationLog') AND name='XIE2_ImmunizationAdministrationLog')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE2_ImmunizationAdministrationLog] ON [dbo].[ImmunizationAdministrationLog] 
		(
		ClientImmunizationId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('ImmunizationAdministrationLog') AND name='XIE2_ImmunizationAdministrationLog')
		PRINT '<<< CREATED INDEX ImmunizationAdministrationLog.XIE2_ImmunizationAdministrationLog >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX ImmunizationAdministrationLog.XIE2_ImmunizationAdministrationLog >>>', 16, 1)		
		END 
		
				
/* 
 * TABLE: ImmunizationAdministrationLog	 
 */
 
   
ALTER TABLE ImmunizationAdministrationLog ADD CONSTRAINT ImmunizationTransmissionLog_ImmunizationAdministrationLog_FK
    FOREIGN KEY (ImmunizationTransmissionLogId)
    REFERENCES ImmunizationTransmissionLog(ImmunizationTransmissionLogId) 
    
ALTER TABLE ImmunizationAdministrationLog ADD CONSTRAINT ClientImmunizations_ImmunizationAdministrationLog_FK
    FOREIGN KEY (ClientImmunizationId)
    REFERENCES ClientImmunizations(ClientImmunizationId) 
 

 PRINT 'STEP 4(B) COMPLETED'  
END

 ----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------
IF ((select DataModelVersion FROM SystemConfigurations)  = 18.31)
BEGIN
Update SystemConfigurations set DataModelVersion=18.32
PRINT 'STEP 7 COMPLETED'
END
Go

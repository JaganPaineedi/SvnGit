----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 17.90)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 17.90 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------

-----End of Step 2 -------

------ STEP 3 ------------

------ STEP 4 ---------------
 
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='TreatmentEpisodes')
BEGIN
/*  
 * TABLE:  TreatmentEpisodes 
 */
 
 CREATE TABLE TreatmentEpisodes(
		TreatmentEpisodeId					INT IDENTITY(1,1)		NOT NULL,
		CreatedBy							type_CurrentUser		NOT NULL,
		CreatedDate							type_CurrentDatetime	NOT NULL,
		ModifiedBy							type_CurrentUser		NOT NULL,
		ModifiedDate						type_CurrentDatetime	NOT NULL,
		RecordDeleted						type_YOrN				NULL
											CHECK (RecordDeleted in	('Y','N')),	
		DeletedBy							type_UserId				NULL,
		DeletedDate							datetime				NULL,
		ClientId							int					    NULL,
		ServiceAreaId						int					    NULL,
		IntakeStaffId						int						NULL,
		StaffAssociatedId					int						NULL,
		TreatmentEpisodeType				type_GlobalCode			NULL,
		TreatmentEpisodeSubType				type_GlobalSubCode		NULL,
		TreatmentEpisodeStatus				type_GlobalCode			NULL,
		RegistrationDate					datetime				NULL,
		DischargeDate						datetime				NULL,
		RequestDate							datetime				NULL,
		AssessmentDate						datetime				NULL,
		AssessmentOfferedDate				datetime				NULL,
		AssessmentDeclineReason 			type_GlobalCode			NULL,
		TxStartDate							datetime				NULL,
		TxStartOfferedDate					datetime				NULL,
		TxStartDeclineReason				type_GlobalCode			NULL,
		Comments							type_Comment2			NULL,
		CONSTRAINT TreatmentEpisodes_PK PRIMARY KEY CLUSTERED (TreatmentEpisodeId)
 ) 
 IF OBJECT_ID('TreatmentEpisodes') IS NOT NULL
	PRINT '<<< CREATED TABLE TreatmentEpisodes >>>'
ELSE
	RAISERROR('<<< FAILED CREATING TABLE TreatmentEpisodes >>>', 16, 1)	
	
 IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('TreatmentEpisodes') AND name='XIE1_TreatmentEpisodes')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_TreatmentEpisodes] ON [dbo].[TreatmentEpisodes] 
		(
		ServiceAreaId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('TreatmentEpisodes') AND name='XIE1_TreatmentEpisodes')
		PRINT '<<< CREATED INDEX TreatmentEpisodes.XIE1_TreatmentEpisodes >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX TreatmentEpisodes.XIE1_TreatmentEpisodes >>>', 16, 1)		
		END 
		
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('TreatmentEpisodes') AND name='XIE2_TreatmentEpisodes')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE2_TreatmentEpisodes] ON [dbo].[TreatmentEpisodes] 
		(
		StaffAssociatedId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('TreatmentEpisodes') AND name='XIE2_TreatmentEpisodes')
		PRINT '<<< CREATED INDEX TreatmentEpisodes.XIE2_TreatmentEpisodes >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX TreatmentEpisodes.XIE2_TreatmentEpisodes >>>', 16, 1)		
		END 
		
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('TreatmentEpisodes') AND name='XIE3_TreatmentEpisodes')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE3_TreatmentEpisodes] ON [dbo].[TreatmentEpisodes] 
		(
		ClientId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('TreatmentEpisodes') AND name='XIE3_TreatmentEpisodes')
		PRINT '<<< CREATED INDEX TreatmentEpisodes.XIE3_TreatmentEpisodes >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX TreatmentEpisodes.XIE3_TreatmentEpisodes >>>', 16, 1)		
		END 
		
	
/* 
 * TABLE: TreatmentEpisodes 
 */	

ALTER TABLE TreatmentEpisodes ADD CONSTRAINT Clients_TreatmentEpisodes_FK 
	FOREIGN KEY (ClientId)
	REFERENCES Clients(ClientId)	
	
ALTER TABLE TreatmentEpisodes ADD CONSTRAINT ServiceAreas_TreatmentEpisodes_FK 
	FOREIGN KEY (ServiceAreaId)
	REFERENCES ServiceAreas(ServiceAreaId)	
	
ALTER TABLE TreatmentEpisodes ADD CONSTRAINT Staff_TreatmentEpisodes_FK 
	FOREIGN KEY (StaffAssociatedId)
	REFERENCES Staff(StaffId)
	
ALTER TABLE TreatmentEpisodes ADD CONSTRAINT Staff_TreatmentEpisodes_FK2
	FOREIGN KEY (IntakeStaffId)
	REFERENCES Staff(StaffId)		
		
PRINT 'STEP 4(A) COMPLETED'
		
END

------------------------SystemConfigurationKey for RequireClientEpisodeForTxEpisode
IF NOT EXISTS (
			SELECT 1
			FROM SystemConfigurationKeys
			WHERE [Key] = 'RequireClientEpisodeForTxEpisode'
		)
BEGIN
	INSERT INTO SystemConfigurationKeys (
		CreatedBy
		,CreateDate
		,ModifiedBy
		,ModifiedDate
		,[Key]
		,Value
		,AcceptedValues
		,[Description]
		,AllowEdit
		)
	VALUES (
		SYSTEM_USER
		,CURRENT_TIMESTAMP
		,SYSTEM_USER
		,CURRENT_TIMESTAMP
		,'RequireClientEpisodeForTxEpisode'
		,'Y'
		,'Y,N'
		,'If set to Y, Require that a client Episode be open in order to create a Treatment Episode.If set to N, Do not require a client episode be open in order to create a treatment episode'
		,'Y'
		)
END

----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 17.90)
BEGIN
Update SystemConfigurations set DataModelVersion=17.91
PRINT 'STEP 7 COMPLETED'
END
Go


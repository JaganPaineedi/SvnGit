----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 16.01)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 16.01 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 -----------

-----End of Step 2 -------

------ STEP 3 ------------

-----END Of STEP 3--------

------ STEP 4 ------------

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='ClaimBatchDirectEntries')
 BEGIN
/* 
 * TABLE: drop table ClaimBatchDirectEntries 
 */
CREATE TABLE ClaimBatchDirectEntries(
    ClaimBatchDirectEntryId							int identity(1,1)       NOT NULL,
    CreatedBy										type_CurrentUser        NOT NULL,
    CreatedDate										type_CurrentDatetime    NOT NULL,
    ModifiedBy										type_CurrentUser        NOT NULL,
    ModifiedDate									type_CurrentDatetime    NOT NULL,
    RecordDeleted									type_YOrN               NULL
													CHECK (RecordDeleted in ('Y','N')),
    DeletedBy										type_UserId             NULL, 
	DeletedDate										datetime                NULL,
	ClaimLineId	 									int						NULL,
	InsurerId	 									int						NULL,
	SiteId	 										int						NULL,
	ClientId	 									int						NULL,
	RenderingProviderId	 							int						NULL,
	FromDate	 									datetime				NULL,
	ToDate	 										datetime				NULL,
	StartTime	 									datetime				NULL,
	EndTime	 										datetime				NULL,
	BillingCode										varchar(20)				NULL,	
	BillingCodeModifier1							varchar(10)				NULL,
	BillingCodeModifier2							varchar(10)				NULL,
	BillingCodeModifier3							varchar(10)				NULL,
	BillingCodeModifier4							varchar(10)				NULL,
	Units	 										decimal(18,2)			NULL,
	Charge	 										type_Money				NULL,
	PlaceOfService	 								type_GlobalCode			NULL,
	Diagnosis1										varchar(10)				NULL,
	Diagnosis2										varchar(10)				NULL,
	Diagnosis3										varchar(10)				NULL,
	RenderingProviderName	 						varchar(100)			NULL,
	PreviousPayer1	 								varchar(100)			NULL,
	AllowedAmount1	 								type_Money				NULL,
	PaidAmount1	 									type_Money				NULL,
	AdjustmentAmount1	 							type_Money				NULL,
	AdjustmentGroupCode1	 						type_GlobalCode			NULL,
	AdjustmentReason1	 							type_GlobalCode			NULL,
	PreviousPayer2	 								varchar(100)			NULL,
	AllowedAmount2	 								type_Money				NULL,
	PaidAmount2	 									type_Money				NULL,
	AdjustmentAmount2	 							type_Money				NULL,
	AdjustmentGroupCode2	 						type_GlobalCode			NULL,
	AdjustmentReason2								type_GlobalCode			NULL,
	Warning	        								varchar(max)			NULL,
	BatchStatus										type_GlobalCode			NULL,
    CONSTRAINT ClaimBatchDirectEntries_PK PRIMARY KEY CLUSTERED (ClaimBatchDirectEntryId)
)
IF OBJECT_ID('ClaimBatchDirectEntries') IS NOT NULL
    PRINT '<<< CREATED TABLE ClaimBatchDirectEntries >>>'
ELSE
   RAISERROR('<<< FAILED CREATING TABLE ClaimBatchDirectEntries >>>', 16, 1)
   
   IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('ClaimBatchDirectEntries') AND name='XIE1_ClaimBatchDirectEntries')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_ClaimBatchDirectEntries] ON [dbo].[ClaimBatchDirectEntries] 
		(
		ClientId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('ClaimBatchDirectEntries') AND name='XIE1_ClaimBatchDirectEntries')
		PRINT '<<< CREATED INDEX ClaimBatchDirectEntries.XIE1_ClaimBatchDirectEntries >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX ClaimBatchDirectEntries.XIE1_ClaimBatchDirectEntries >>>', 16, 1)		
		END	
		
    IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('ClaimBatchDirectEntries') AND name='XIE2_ClaimBatchDirectEntries')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE2_ClaimBatchDirectEntries] ON [dbo].[ClaimBatchDirectEntries] 
		(
		RenderingProviderId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('ClaimBatchDirectEntries') AND name='XIE2_ClaimBatchDirectEntries')
		PRINT '<<< CREATED INDEX ClaimBatchDirectEntries.XIE2_ClaimBatchDirectEntries >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX ClaimBatchDirectEntries.XIE2_ClaimBatchDirectEntries >>>', 16, 1)		
		END	
	
	
	IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('ClaimBatchDirectEntries') AND name='XIE3_ClaimBatchDirectEntries')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE3_ClaimBatchDirectEntries] ON [dbo].[ClaimBatchDirectEntries] 
		(
		FromDate DESC,
		ToDate DESC,
		BatchStatus ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('ClaimBatchDirectEntries') AND name='XIE3_ClaimBatchDirectEntries')
		PRINT '<<< CREATED INDEX ClaimBatchDirectEntries.XIE3_ClaimBatchDirectEntries >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX ClaimBatchDirectEntries.XIE3_ClaimBatchDirectEntries >>>', 16, 1)		
		END	
	



/* 
 * TABLE: ClaimBatchDirectEntries 
 */
    
     PRINT 'STEP 4(A) COMPLETED'
END


/****** Object:  UserDefinedTableType [dbo].[BatchClaimType]    Script Date: 08/31/2016 16:32:47 ******/
IF NOT EXISTS (SELECT * FROM sys.types st JOIN sys.schemas ss ON st.schema_id = ss.schema_id WHERE st.name = N'BatchClaimType' AND ss.name = N'dbo')
BEGIN
/****** Object:  UserDefinedTableType [dbo].[BatchClaimType]    Script Date: 08/31/2016 16:32:47 ******/
CREATE TYPE [dbo].[BatchClaimType] AS TABLE(
	[CreatedBy] [varchar](30) NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedBy] [varchar](30) NULL,
	[ModifiedDate] [datetime] NULL,
	[RecordDeleted] [char](1) NULL,
	[DeletedBy] [varchar](30) NULL,
	[DeletedDate] [datetime] NULL,
	[ClaimLineId] [int] NULL,
	[InsurerId] [int] NULL,
	[SiteId] [int] NULL,
	[ClientId] [int] NULL,
	[RenderingProviderId] [int] NULL,
	[FromDate] [datetime] NULL,
	[ToDate] [datetime] NULL,
	[StartTime] [datetime] NULL,
	[EndTime] [datetime] NULL,
	[BillingCode] [varchar](20) NULL,
	[BillingCodeModifier1] [varchar](10) NULL,
	[BillingCodeModifier2] [varchar](10) NULL,
	[BillingCodeModifier3] [varchar](10) NULL,
	[BillingCodeModifier4] [varchar](10) NULL,
	[Units] [decimal](18, 2) NULL,
	[Charge] [decimal](18, 4) NULL,
	[PlaceOfService] [int] NULL,
	[Diagnosis1] [varchar](10) NULL,
	[Diagnosis2] [varchar](10) NULL,
	[Diagnosis3] [varchar](10) NULL,
	[RenderingProviderName] [varchar](100) NULL,
	[PreviousPayer1] [varchar](100) NULL,
	[AllowedAmount1] [decimal](18, 4) NULL,
	[PaidAmount1] [decimal](18, 4) NULL,
	[AdjustmentAmount1] [decimal](18, 4) NULL,
	[AdjustmentGroupCode1] [int] NULL,
	[AdjustmentReason1] [int] NULL,
	[PreviousPayer2] [varchar](100) NULL,
	[AllowedAmount2] [decimal](18, 4) NULL,
	[PaidAmount2] [decimal](18, 4) NULL,
	[AdjustmentAmount2] [decimal](18, 4) NULL,
	[AdjustmentGroupCode2] [int] NULL,
	[AdjustmentReason2] [int] NULL
)
END
GO



----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 16.01)
BEGIN
Update SystemConfigurations set DataModelVersion=16.02
PRINT 'STEP 7 COMPLETED'
END
Go




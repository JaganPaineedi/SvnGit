----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 18.25)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 18.25 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------

-----End of Step 2 -------

------ STEP 3 ------------

------ END Of STEP 3 ------------

------ STEP 4 ---------------
IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='ImplantableDevices')
BEGIN
/* 
 * TABLE: ImplantableDevices 
 */
CREATE TABLE ImplantableDevices(
	ImplantableDeviceId				int  identity(1,1)		NOT NULL,
    CreatedBy						type_CurrentUser        NOT NULL,
    CreatedDate						type_CurrentDatetime    NOT NULL,
    ModifiedBy						type_CurrentUser        NOT NULL,
    ModifiedDate					type_CurrentDatetime    NOT NULL,
    RecordDeleted					type_YOrN               NULL
									CHECK (RecordDeleted in ('Y','N')),
    DeletedBy						type_UserId             NULL,
    DeletedDate						datetime                NULL,
    ClientId						int						NULL,
	GlobalUDI						varchar(500)			NULL,
	LotOrBatchNumber				varchar(500)			NULL,
	BrandName						varchar(250)			NULL,
	Descrpition						type_Comment2			NULL,
	SerialNumber					varchar(500)			NULL,
	VersionOrModel					varchar(250)			NULL,
	ManufacturingDate				datetime				NULL,
	CompanyName						varchar(500)			NULL,
	ExpirationDate					datetime				NULL,
	MRISafety						varchar(250)			NULL,
	HCTOrPIndicator					varchar(500)			NULL,
	ContainsNaturalRubber			varchar(500)			NULL,
	ImplantDate						datetime				NULL,
	Active							type_GlobalCode			NULL,
	InactiveReason					type_GlobalCode			NULL,
    CONSTRAINT ImplantableDevices_PK PRIMARY KEY CLUSTERED (ImplantableDeviceId)
)
      
IF OBJECT_ID('ImplantableDevices') IS NOT NULL
PRINT '<<< CREATED TABLE ImplantableDevices >>>'
ELSE
RAISERROR('<<< FAILED CREATING TABLE ImplantableDevices >>>', 16, 1)

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('ImplantableDevices') AND name='XIE1_ImplantableDevices')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_ImplantableDevices] ON [dbo].[ImplantableDevices] 
		(
		ClientId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('ImplantableDevices') AND name='XIE1_ImplantableDevices')
		PRINT '<<< CREATED INDEX ImplantableDevices.XIE1_ImplantableDevices >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX ImplantableDevices.XIE1_ImplantableDevices >>>', 16, 1)		
		END 
				
/* 
 * TABLE: ImplantableDevices	 
 */
 
   
ALTER TABLE ImplantableDevices ADD CONSTRAINT Clients_ImplantableDevices_FK
    FOREIGN KEY (ClientId)
    REFERENCES Clients(ClientId) 
 

 PRINT 'STEP 4(A) COMPLETED'  
END

 ----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 18.25)
BEGIN
Update SystemConfigurations set DataModelVersion=18.26
PRINT 'STEP 7 COMPLETED'
END
Go


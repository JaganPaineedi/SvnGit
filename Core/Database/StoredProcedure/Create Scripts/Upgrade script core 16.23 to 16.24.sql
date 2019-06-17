----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 16.23)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 16.23 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 -----------

-----End of Step 2 -------

------ STEP 3 ------------
-----END Of STEP 3---------

------ STEP 4 ------------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='BlockBeds')
 BEGIN
/*  
 * TABLE: BlockBeds 
 */

CREATE TABLE BlockBeds(
    BlockBedId						int	identity(1,1)		NOT NULL,
    CreatedBy						type_CurrentUser		NOT NULL,
    CreatedDate						type_CurrentDatetime    NOT NULL,
    ModifiedBy						type_CurrentUser        NOT NULL,
    ModifiedDate					type_CurrentDatetime    NOT NULL,
    RecordDeleted					type_YOrN               NULL
									CHECK (RecordDeleted in ('Y','N')),
    DeletedBy						type_UserId             NULL,
	DeletedDate						datetime                NULL,
	BedId							int						NULL,
	StartDate						datetime                NULL,
	EndDate							datetime                NULL,
	BlockedReason					type_GlobalCode			NULL,
	BlockedReasonComment			type_Comment2			NULL,
	CONSTRAINT BlockBeds_PK PRIMARY KEY CLUSTERED (BlockBedId)
)

IF OBJECT_ID('BlockBeds') IS NOT NULL
    PRINT '<<< CREATED TABLE BlockBeds >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE BlockBeds >>>', 16, 1)
    
 IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('BlockBeds') AND name='XIE1_BlockBeds')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_BlockBeds] ON [dbo].[BlockBeds] 
		(
			BedId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('BlockBeds') AND name='XIE1_BlockBeds')
		PRINT '<<< CREATED INDEX BlockBeds.XIE1_BlockBeds >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX BlockBeds.XIE1_BlockBeds >>>', 16, 1)		
		END	    

/* 
 * TABLE: BlockBeds 
 */

ALTER TABLE BlockBeds ADD CONSTRAINT Beds_BlockBeds_FK 
    FOREIGN KEY (BedId)
    REFERENCES Beds(BedId)
    
    PRINT 'STEP 4(A) COMPLETED'
END
----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 16.23)
BEGIN
Update SystemConfigurations set DataModelVersion=16.24
PRINT 'STEP 7 COMPLETED'
END
Go



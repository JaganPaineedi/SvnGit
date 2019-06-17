----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 16.02)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 16.02 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 -----------

-----End of Step 2 -------

------ STEP 3 ------------

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='ClaimBatchUploads')
BEGIN  
/* 
 * TABLE: ClaimBatchUploads 
 */
 CREATE TABLE ClaimBatchUploads(
    ClaimBatchUploadId			int identity(1,1)		NOT NULL,
    CreatedBy					type_CurrentUser		NOT NULL,
    CreatedDate					type_CurrentDatetime	NOT NULL,
    ModifiedBy					type_CurrentUser		NOT NULL,
    ModifiedDate				type_CurrentDatetime	NOT NULL,
    RecordDeleted				type_YOrN				NULL
								CHECK (RecordDeleted in ('Y','N')),
	DeletedBy					type_UserId				NULL,
    DeletedDate					datetime				NULL,
    UploadedFileName	  		varchar(500)			NULL,
	UploadedDate	  			datetime				NULL,
	UploadedBy	  				type_CurrentUser		NULL,
	ProviderId					int						NULL,
    CONSTRAINT ClaimBatchUploads_PK PRIMARY KEY CLUSTERED (ClaimBatchUploadId)
    )  
IF OBJECT_ID('ClaimBatchUploads') IS NOT NULL
    PRINT '<<< CREATED TABLE ClaimBatchUploads >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE ClaimBatchUploads >>>', 16, 1)

/* 
 * TABLE: BatchClaimUploads 
 */ 
 
 PRINT 'STEP 4 COMPLETED'	
END

IF OBJECT_ID('ClaimBatchDirectEntries')IS NOT NULL
BEGIN
IF COL_LENGTH('ClaimBatchDirectEntries','ClaimBatchUploadId') IS NULL
BEGIN
	ALTER TABLE ClaimBatchDirectEntries ADD  ClaimBatchUploadId INT
END

IF COL_LENGTH('ClaimBatchDirectEntries','ClaimBatchUploadId')IS  NOT NULL
		BEGIN
			IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[ClaimBatchUploads_ClaimBatchDirectEntries_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[ClaimBatchDirectEntries]'))	
			BEGIN
				ALTER TABLE ClaimBatchDirectEntries ADD CONSTRAINT ClaimBatchUploads_ClaimBatchDirectEntries_FK 
				FOREIGN KEY (ClaimBatchUploadId)
				REFERENCES ClaimBatchUploads(ClaimBatchUploadId) 
			END 
		END
END    

-----END Of STEP 3---------

------ STEP 4 ------------

----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 16.02)
BEGIN
Update SystemConfigurations set DataModelVersion=16.03
PRINT 'STEP 7 COMPLETED'
END
Go



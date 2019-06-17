----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 18.10)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 18.10 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------
-----End of Step 2 -------
------ STEP 3 ------------

-----End of Step 3 -------

------ STEP 4 ---------------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='ContractRateCoveragePlans')
BEGIN
/* 
 * TABLE:  ContractRateCoveragePlans 
 */
 
 CREATE TABLE ContractRateCoveragePlans(
		ContractRateCoveragePlanId			INT IDENTITY(1,1)		NOT NULL,
		CreatedBy							type_CurrentUser		NOT NULL,
		CreatedDate							type_CurrentDatetime	NOT NULL,
		ModifiedBy							type_CurrentUser		NOT NULL,
		ModifiedDate						type_CurrentDatetime	NOT NULL,
		RecordDeleted						type_YOrN				NULL
											CHECK (RecordDeleted in	('Y','N')),	
		DeletedBy							type_UserId				NULL,
		DeletedDate							datetime				NULL,
		ContractRateId						int						NOT NULL,
		CoveragePlanId						int						NOT NULL,
		CONSTRAINT ContractRateCoveragePlans_PK PRIMARY KEY CLUSTERED (ContractRateCoveragePlanId)
 ) 
 IF OBJECT_ID('ContractRateCoveragePlans') IS NOT NULL
	PRINT '<<< CREATED TABLE ContractRateCoveragePlans >>>'
ELSE
	RAISERROR('<<< FAILED CREATING TABLE ContractRateCoveragePlans >>>', 16, 1)	
	
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('ContractRateCoveragePlans') AND name='XIE1_ContractRateCoveragePlans')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_ContractRateCoveragePlans] ON [dbo].[ContractRateCoveragePlans] 
		(
		ContractRateId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('ContractRateCoveragePlans') AND name='XIE1_ContractRateCoveragePlans')
		PRINT '<<< CREATED INDEX ContractRateCoveragePlans.XIE1_ContractRateCoveragePlans >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX ContractRateCoveragePlans.XIE1_ContractRateCoveragePlans >>>', 16, 1)		
		END 
		
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('ContractRateCoveragePlans') AND name='XIE2_ContractRateCoveragePlans')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE2_ContractRateCoveragePlans] ON [dbo].[ContractRateCoveragePlans] 
		(
		CoveragePlanId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('ContractRateCoveragePlans') AND name='XIE2_ContractRateCoveragePlans')
		PRINT '<<< CREATED INDEX ContractRateCoveragePlans.XIE2_ContractRateCoveragePlans >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX ContractRateCoveragePlans.XIE2_ContractRateCoveragePlans >>>', 16, 1)		
		END 
	
/* 
 * TABLE: ContractRateCoveragePlans 
 */	
 
 ALTER TABLE ContractRateCoveragePlans ADD CONSTRAINT ContractRates_ContractRateCoveragePlans_FK 
	FOREIGN KEY (ContractRateId)
	REFERENCES ContractRates(ContractRateId)
	
ALTER TABLE ContractRateCoveragePlans ADD CONSTRAINT CoveragePlans_ContractRateCoveragePlans_FK 
	FOREIGN KEY (CoveragePlanId)
	REFERENCES CoveragePlans(CoveragePlanId)
	
		
PRINT 'STEP 4(A) COMPLETED'
		
END

----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 18.10)
BEGIN
Update SystemConfigurations set DataModelVersion=18.11
PRINT 'STEP 7 COMPLETED'
END
Go


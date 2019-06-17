----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 15.84)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 15.84 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------

-----End of STEP 2 -------

------ STEP 3 ----------------

-- Added AllBillingCodesMinimumUnitsPerPeriod column in ClaimBundles  Table

IF OBJECT_ID('ClaimBundles')  IS NOT NULL
BEGIN
	IF COL_LENGTH('ClaimBundles','AllBillingCodesMinimumUnitsPerPeriod') IS NULL
	BEGIN
	     ALTER TABLE ClaimBundles ADD AllBillingCodesMinimumUnitsPerPeriod  decimal(18,2)  NULL
	END
		
PRINT 'STEP 3 COMPLETED'
	
END	
 
-----END Of STEP 3------------

------ STEP 4 ----------------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='ClaimBundleBillingCodeGroups')
BEGIN
/*		
 * TABLE: ClaimBundleBillingCodeGroups 
 */
 CREATE TABLE ClaimBundleBillingCodeGroups( 
		ClaimBundleBillingCodeGroupId	int	identity(1,1)	 NOT NULL,
		CreatedBy						type_CurrentUser     NOT NULL,
		CreatedDate						type_CurrentDatetime NOT NULL,
		ModifiedBy						type_CurrentUser     NOT NULL,
		ModifiedDate					type_CurrentDatetime NOT NULL,
		RecordDeleted					type_YOrN			 NULL
										CHECK (RecordDeleted in ('Y','N')),
		DeletedBy						type_UserId          NULL,
		DeletedDate						datetime             NULL,
		ClaimBundleId					int					 NULL,
		BillingCodeGroupName			varchar(250)		 NULL,
		MinimumUnitsPerPeriod			decimal(18,2)		 NULL,
		CONSTRAINT ClaimBundleBillingCodeGroups_PK PRIMARY KEY CLUSTERED (ClaimBundleBillingCodeGroupId)											
 )
 
  IF OBJECT_ID('ClaimBundleBillingCodeGroups') IS NOT NULL
    PRINT '<<< CREATED TABLE ClaimBundleBillingCodeGroups >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE ClaimBundleBillingCodeGroups >>>', 16, 1)
    
/* 
 * TABLE: ClaimBundleBillingCodeGroups 
 */ 
 
 ALTER TABLE ClaimBundleBillingCodeGroups ADD CONSTRAINT ClaimBundles_ClaimBundleBillingCodeGroups_FK 
    FOREIGN KEY (ClaimBundleId)
    REFERENCES ClaimBundles(ClaimBundleId)

 PRINT 'STEP 4(A) COMPLETED'
 END
 
 IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='ClaimBundleBillingCodeGroupBillingCodes')
BEGIN
/*		
 * TABLE: ClaimBundleBillingCodeGroupBillingCodes 
 */
 CREATE TABLE ClaimBundleBillingCodeGroupBillingCodes( 
		ClaimBundleBillingCodeGroupBillingCodeId	int	identity(1,1)	 NOT NULL,
		CreatedBy									type_CurrentUser     NOT NULL,
		CreatedDate									type_CurrentDatetime NOT NULL,
		ModifiedBy									type_CurrentUser     NOT NULL,
		ModifiedDate								type_CurrentDatetime NOT NULL,
		RecordDeleted								type_YOrN			 NULL
													CHECK (RecordDeleted in ('Y','N')),
		DeletedBy									type_UserId          NULL,
		DeletedDate									datetime             NULL,
		ClaimBundleBillingCodeGroupId				int					 NULL,
		BillingCodeModifierId						int					 NULL,
		ApplyToAllModifiers						    type_YOrN			 NULL
													CHECK (ApplyToAllModifiers in ('Y','N')),
		CONSTRAINT ClaimBundleBillingCodeGroupBillingCodes_PK PRIMARY KEY CLUSTERED (ClaimBundleBillingCodeGroupBillingCodeId)											
 )
 
  IF OBJECT_ID('ClaimBundleBillingCodeGroupBillingCodes') IS NOT NULL
    PRINT '<<< CREATED TABLE ClaimBundleBillingCodeGroupBillingCodes >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE ClaimBundleBillingCodeGroupBillingCodes >>>', 16, 1)
    
/* 
 * TABLE: ClaimBundleBillingCodeGroupBillingCodes 
 */ 
 
 ALTER TABLE ClaimBundleBillingCodeGroupBillingCodes ADD CONSTRAINT ClaimBundleBillingCodeGroups_ClaimBundleBillingCodeGroupBillingCodes_FK 
    FOREIGN KEY (ClaimBundleBillingCodeGroupId)
    REFERENCES ClaimBundleBillingCodeGroups(ClaimBundleBillingCodeGroupId)
    
 ALTER TABLE ClaimBundleBillingCodeGroupBillingCodes ADD CONSTRAINT BillingCodeModifiers_ClaimBundleBillingCodeGroupBillingCodes_FK 
    FOREIGN KEY (BillingCodeModifierId)
    REFERENCES BillingCodeModifiers(BillingCodeModifierId)   

 PRINT 'STEP 4(B) COMPLETED'
 END
 
----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 15.84)
BEGIN
Update SystemConfigurations set DataModelVersion=15.85
PRINT 'STEP 7 COMPLETED'
END
Go




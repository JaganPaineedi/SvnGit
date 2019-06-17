----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 15.24 )
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 15.24 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END

------ STEP 2 ----------
--Part1 Begin


--Part1 Ends

--Part2 Begins

--Part2 Ends	

-----End of Step 2 -------

------ STEP 3 ------------

-----END Of STEP 3--------------------

------ STEP 4 ------------

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CoveragePlanClaimBundlingCriteria')
BEGIN
/* 
 * TABLE: CoveragePlanClaimBundlingCriteria 
 */
 CREATE TABLE CoveragePlanClaimBundlingCriteria( 
		  CoveragePlanClaimBundlingCriteriaId	int IDENTITY(1,1)	NOT NULL,
		  CreatedBy								type_CurrentUser		NOT NULL,
		  CreatedDate							type_CurrentDatetime	NOT NULL,
		  ModifiedBy							type_CurrentUser		NOT NULL,
		  ModifiedDate							type_CurrentDatetime	NOT NULL,
		  RecordDeleted							type_YOrN				NULL
		 										CHECK (RecordDeleted in ('Y','N')),
		  DeletedBy								type_UserId				NULL,
		  DeletedDate							datetime				NULL,
		  CoveragePlanId						int						NULL,
		  ClaimFormatId							int						NULL,
		  BillingProviderNPI					type_YOrN				NULL
		 										CHECK (BillingProviderNPI in ('Y','N')),
		  PlaceOfService						type_YOrN				NULL
		 										CHECK (PlaceOfService in ('Y','N')),
		  ClientId								type_YOrN				NULL
		 										CHECK (ClientId in ('Y','N')),
		  RenderingProviderNPI					type_YOrN				NULL
		 										CHECK (RenderingProviderNPI in ('Y','N')),
		  RenderingProviderSecondaryId			type_YOrN				NULL
		 										CHECK (RenderingProviderSecondaryId in ('Y','N')),
		  AuthorizationId						type_YOrN				NULL
		 										CHECK (AuthorizationId in ('Y','N')),
		  BundlingTimeFrame						CHAR(1)				   NULL			-- Add Constraint for these values:  A, M, W, N, NULL
												CHECK (BundlingTimeFrame in ('A','M','W','N')),
		  PrimaryDiagnosis						type_YOrN				NULL
		 										CHECK (PrimaryDiagnosis in ('Y','N')),
		  BillingCode							type_YOrN				NULL
		 										CHECK (BillingCode in ('Y','N')),
		  Modifier1								type_YOrN				NULL
		 										CHECK (Modifier1 in ('Y','N')),
		  Modifier2								type_YOrN				NULL
		 										CHECK (Modifier2 in ('Y','N')),
		  Modifier3								type_YOrN				NULL
		 										CHECK (Modifier3 in ('Y','N')),
		  Modifier4								type_YOrN				NULL
		 										CHECK (Modifier4 in ('Y','N')),
		  RevenueCode							type_YOrN				NULL
		 										CHECK (RevenueCode in ('Y','N')),
		  RevenueCodeDescription				type_YOrN				NULL
		 										CHECK (RevenueCodeDescription in ('Y','N')),
		  CONSTRAINT CoveragePlanClaimBundlingCriteria_PK PRIMARY KEY CLUSTERED (CoveragePlanClaimBundlingCriteriaId)
 )
  IF OBJECT_ID('CoveragePlanClaimBundlingCriteria') IS NOT NULL
    PRINT '<<< CREATED TABLE CoveragePlanClaimBundlingCriteria >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CoveragePlanClaimBundlingCriteria >>>', 16, 1)
/* 
 * TABLE: CoveragePlanClaimBundlingCriteria 
 */ 
 
	ALTER TABLE CoveragePlanClaimBundlingCriteria ADD CONSTRAINT CoveragePlans_CoveragePlanClaimBundlingCriteria_FK 
		FOREIGN KEY (CoveragePlanId)
		REFERENCES CoveragePlans(CoveragePlanId)
		
	ALTER TABLE CoveragePlanClaimBundlingCriteria ADD CONSTRAINT ClaimFormats_CoveragePlanClaimBundlingCriteria_FK 
		FOREIGN KEY (ClaimFormatId)
		REFERENCES ClaimFormats(ClaimFormatId)
               
    PRINT 'STEP 4(A) COMPLETED'
END

----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------
------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 15.24)
BEGIN
Update SystemConfigurations set DataModelVersion=15.25
PRINT 'STEP 7 COMPLETED'
END
Go
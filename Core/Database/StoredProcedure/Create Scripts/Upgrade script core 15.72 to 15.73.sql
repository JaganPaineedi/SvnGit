----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 15.72)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 15.72 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END

------ STEP 2 ----------
--Part1 Begin

--Part1 Ends

--Part2 Begins

--Part2 Ends	

-----End of Step 2 -------

------ STEP 3 ------------

IF OBJECT_ID('ClaimBundles') IS NOT NULL
BEGIN
	IF COL_LENGTH('ClaimBundles','InsurerId') IS  NULL
		BEGIN
		 ALTER TABLE ClaimBundles ADD  InsurerId  INT	NULL
		END
		
	IF COL_LENGTH('ClaimBundles','AllClients') IS  NULL
		BEGIN
		 ALTER TABLE ClaimBundles ADD  AllClients  type_YOrN	NULL
								  CHECK (AllClients in ('Y','N'))
		END
		
	IF COL_LENGTH('ClaimBundles','AllBillingCodes') IS  NULL
		BEGIN
		 ALTER TABLE ClaimBundles ADD  AllBillingCodes  type_YOrN	NULL
								  CHECK (AllBillingCodes in ('Y','N'))
		END
		
	IF COL_LENGTH('ClaimBundles','BundledClaimStatus') IS  NULL
		BEGIN
		 ALTER TABLE ClaimBundles ADD  BundledClaimStatus  char(1)	NULL --DEFAULT 'R' NOT NULL
								  CHECK (BundledClaimStatus in ('G','R'))
		
		EXEC sys.sp_addextendedproperty 'ClaimBundles_Description'
		,'cloumn BundledClaimStatus store G and R , by default it store R, R-Recieve, G-Generate'
		,'schema'
		,'dbo'
		,'table'
		,'ClaimBundles'
		,'column'
		,'BundledClaimStatus'
		
		END
		
	IF COL_LENGTH('ClaimBundles','ClientSameAsAbove') IS  NULL
		BEGIN
		 ALTER TABLE ClaimBundles ADD  ClientSameAsAbove  type_YOrN	 NULL
								  CHECK (ClientSameAsAbove in ('Y','N'))
		END
	IF COL_LENGTH('ClaimBundles','ProviderSiteGroupName') IS  NULL
		BEGIN
		 ALTER TABLE ClaimBundles ADD  ProviderSiteGroupName  Varchar(250)	NULL
		END	
	IF COL_LENGTH('ClaimBundles','InsurerId')IS  NOT NULL
		BEGIN
			IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Insurers_ClaimBundles_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[ClaimBundles]'))	
			BEGIN
				ALTER TABLE ClaimBundles ADD CONSTRAINT Insurers_ClaimBundles_FK
				FOREIGN KEY (InsurerId)
				REFERENCES Insurers(InsurerId)	 
			END 
		END
			
	PRINT 'STEP 3 COMPLETED'
END
-----END Of STEP 3--------------------

------ STEP 4 ------------

----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 15.72)
BEGIN
Update SystemConfigurations set DataModelVersion=15.73
PRINT 'STEP 7 COMPLETED'
END
Go
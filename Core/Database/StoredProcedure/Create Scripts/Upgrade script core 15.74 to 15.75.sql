--- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 15.74)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 15.74 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END

---- STEP 2 ----------
--Part1 Begin

--Part1 Ends

--Part2 Begins

--Part2 Ends	

---End of Step 2 -------

---- STEP 3 ------------
---END Of STEP 3--------------------

IF OBJECT_ID('ClaimBundleSites') IS NOT NULL
BEGIN
IF COL_LENGTH('ClaimBundleSites','ProviderId') IS NULL
	BEGIN
	 ALTER TABLE ClaimBundleSites ADD ProviderId INT NULL
	 	 
	 EXEC sys.sp_addextendedproperty 'ClaimBundleSites_Description'
	,'If provider is specified and no site then all sites for the given provider can be exchanged and when a site is specified then the provider must be what is specified on the site table'
	,'schema'
	,'dbo'
	,'table'
	,'ClaimBundleSites'
	,'column'
	,'ProviderId'	
																 
	END
END
go

IF OBJECT_ID('ClaimBundleSites') IS NOT NULL
BEGIN
IF COL_LENGTH('ClaimBundleSites','ProviderId')IS  NOT NULL
	BEGIN
		IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Providers_ClaimBundleSites_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[ClaimBundleSites]'))	
		BEGIN
			ALTER TABLE ClaimBundleSites ADD CONSTRAINT Providers_ClaimBundleSites_FK
			FOREIGN KEY (ProviderId)
			REFERENCES Providers(ProviderId)	 
		END 
	END	
	

	
IF NOT EXISTS (SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'CK_ClaimBundleSites_ProviderId_Or_SiteId' AND OBJECT_NAME(id) = 'ClaimBundleSites')
BEGIN	
		ALTER TABLE ClaimBundleSites ADD CONSTRAINT CK_ClaimBundleSites_ProviderId_Or_SiteId
		CHECK ((ProviderId IS NOT NULL AND SiteId IS NULL)
				OR (ProviderId IS NULL AND SiteId IS NOT NULL)  )
END		

END
PRINT 'STEP 3 COMPLETED'

------ STEP 4 ------------

----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------
------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 15.74)
BEGIN
Update SystemConfigurations set DataModelVersion=15.75
PRINT 'STEP 7 COMPLETED'
END
Go
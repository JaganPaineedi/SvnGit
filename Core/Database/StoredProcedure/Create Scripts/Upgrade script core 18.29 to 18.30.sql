----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 18.29)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 18.29 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------

-----End of Step 2 -------

------ STEP 3 ------------


IF OBJECT_ID('ClientEpisodes') IS NOT NULL
BEGIN

	IF COL_LENGTH('ClientEpisodes','ProviderType')IS   NULL
	BEGIN
		ALTER TABLE ClientEpisodes   ADD   ProviderType  type_GlobalCode    NULL
	END
	
	IF COL_LENGTH('ClientEpisodes','ProviderId')IS   NULL
	BEGIN
		ALTER TABLE ClientEpisodes   ADD   ProviderId  int    NULL
	END
	

	IF COL_LENGTH('ClientEpisodes','ProviderId')IS NOT NULL
	 BEGIN
			IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[ExternalReferralProviders_ClientEpisodes_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[ClientEpisodes]'))
			BEGIN
				ALTER TABLE ClientEpisodes ADD CONSTRAINT ExternalReferralProviders_ClientEpisodes_FK
				FOREIGN KEY (ProviderId)
				REFERENCES ExternalReferralProviders(ExternalReferralProviderId) 
			END
	  END
	  
	 
	  IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('ClientEpisodes') AND name='XIE2_ClientEpisodes')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE2_ClientEpisodes] ON [dbo].[ClientEpisodes] 
		(
		ProviderId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('ClientEpisodes') AND name='XIE2_ClientEpisodes')
		PRINT '<<< CREATED INDEX ClientEpisodes.XIE2_ClientEpisodes >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX ClientEpisodes.XIE2_ClientEpisodes >>>', 16, 1)		
		END	 
	
	PRINT 'STEP 3 COMPLETED'	
END


 
------ END Of STEP 3 ------------

------ STEP 4 ---------------

 ----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 18.29)
BEGIN
Update SystemConfigurations set DataModelVersion=18.30
PRINT 'STEP 7 COMPLETED'
END
Go


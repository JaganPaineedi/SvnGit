----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 15.99)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 15.99 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------

-----End of Step 2 -------

------ STEP 3 --------------

/* Added ReferringProviderId Column in ClientPrimaryCareExternalReferrals table */

IF OBJECT_ID('ClientPrimaryCareExternalReferrals')  IS NOT NULL
BEGIN
	IF COL_LENGTH('ClientPrimaryCareExternalReferrals','ReferringProviderId') IS NULL
	BEGIN
		 ALTER TABLE ClientPrimaryCareExternalReferrals ADD ReferringProviderId INT NULL
	END

	IF COL_LENGTH('ClientPrimaryCareExternalReferrals','ReferringProviderId')IS NOT NULL
		BEGIN
			IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Staff_ClientPrimaryCareExternalReferrals_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[ClientPrimaryCareExternalReferrals]'))
			BEGIN
			ALTER TABLE ClientPrimaryCareExternalReferrals ADD CONSTRAINT Staff_ClientPrimaryCareExternalReferrals_FK 
				FOREIGN KEY (ReferringProviderId)
				REFERENCES Staff(StaffId) 
			END
		END
		
		IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('ClientPrimaryCareExternalReferrals') AND name='XIE1_ClientPrimaryCareExternalReferrals')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_ClientPrimaryCareExternalReferrals] ON [dbo].[ClientPrimaryCareExternalReferrals] 
		(
			ClientId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('ClientPrimaryCareExternalReferrals') AND name='XIE1_ClientPrimaryCareExternalReferrals')
		PRINT '<<< CREATED INDEX ClientPrimaryCareExternalReferrals.XIE1_ClientInpatientVisits >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX ClientPrimaryCareExternalReferrals.XIE1_ClientInpatientVisits >>>', 16, 1)		
		END	
		
	PRINT 'STEP 3 COMPLETED'
END
		
------ END OF STEP 3 -------

------ STEP 4 ---------------
  
 ------END Of STEP 4----------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 15.99)
BEGIN
Update SystemConfigurations set DataModelVersion=16.00
PRINT 'STEP 7 COMPLETED'
END
Go

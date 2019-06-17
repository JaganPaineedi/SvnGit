----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 18.15)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 18.15 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------

-----End of Step 2 -------
------ STEP 3 ------------

-----End of Step 3 -------

------ STEP 4 ---------------
-------------------add new column NoKnownAllergiesLastUpdatedBy in Clients table ---------------

IF OBJECT_ID('Clients') IS NOT NULL
BEGIN

	IF COL_LENGTH('Clients','NoKnownAllergiesLastUpdatedBy')IS   NULL
	BEGIN
		ALTER TABLE Clients   ADD   NoKnownAllergiesLastUpdatedBy  int NULL	
	END
	
	IF COL_LENGTH('Clients','NoKnownAllergiesLastUpdatedDate')IS   NULL
	BEGIN
		ALTER TABLE Clients   ADD   NoKnownAllergiesLastUpdatedDate  datetime NULL	
	END
	
	IF COL_LENGTH('Clients','NoKnownAllergiesLastUpdatedBy')IS NOT NULL
	 BEGIN
			IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Staff_Clients_FK6]') AND parent_object_id = OBJECT_ID(N'[dbo].[Clients]'))
			BEGIN
				ALTER TABLE Clients ADD CONSTRAINT Staff_Clients_FK6
				FOREIGN KEY (NoKnownAllergiesLastUpdatedBy)
				REFERENCES Staff(StaffId) 
			END
	  END
	  
	  IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('Clients') AND name='XIE7_Clients')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE7_Clients] ON [dbo].[Clients] 
		(
		NoKnownAllergiesLastUpdatedBy ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('Clients') AND name='XIE7_Clients')
		PRINT '<<< CREATED INDEX Clients.XIE7_Clients >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX Clients.XIE7_Clients >>>', 16, 1)		
		END	
		
	PRINT 'STEP 3 COMPLETED'	
END



----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 18.15)
BEGIN
Update SystemConfigurations set DataModelVersion=18.16
PRINT 'STEP 7 COMPLETED'
END
Go


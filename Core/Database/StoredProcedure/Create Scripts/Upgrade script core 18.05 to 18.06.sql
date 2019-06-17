----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 18.05)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 18.05 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------
-----End of Step 2 -------
------ STEP 3 ------------

-----End of Step 3 -------

------ STEP 4 ---------------

IF OBJECT_ID('ClientDisclosures')IS NOT NULL
BEGIN
		
	IF COL_LENGTH('ClientDisclosures','AssignedToStaffId') IS NULL
	BEGIN
		 ALTER TABLE ClientDisclosures ADD AssignedToStaffId int NULL
	END
	
	IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('ClientDisclosures') AND name='XIE2_ClientDisclosures')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE2_ClientDisclosures] ON [dbo].[ClientDisclosures] 
		(
		AssignedToStaffId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('ClientDisclosures') AND name='XIE2_ClientDisclosures')
		PRINT '<<< CREATED INDEX ClientDisclosures.XIE2_ClientDisclosures >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX ClientDisclosures.XIE2_ClientDisclosures >>>', 16, 1)		
		END	 
	
	 IF COL_LENGTH('ClientDisclosures','AssignedToStaffId')IS NOT NULL
	 BEGIN
			IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Staff_ClientDisclosures_FK2]') AND parent_object_id = OBJECT_ID(N'[dbo].[ClientDisclosures]'))
			BEGIN
				ALTER TABLE ClientDisclosures ADD CONSTRAINT Staff_ClientDisclosures_FK2
				FOREIGN KEY (AssignedToStaffId)
				REFERENCES Staff(StaffId) 
			END
	  END
	
	 PRINT 'STEP 3 COMPLETED'
END
----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 18.05)
BEGIN
Update SystemConfigurations set DataModelVersion=18.06
PRINT 'STEP 7 COMPLETED'
END
Go


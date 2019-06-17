----- STEP 1 ----------
IF (((SELECT value FROM SystemConfigurationKeys WHERE [key] = 'CDM_Common')  < 1.0 )or 
Not exists(SELECT 1 FROM SystemConfigurationKeys WHERE [key] = 'CDM_Common'))
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 1.0 for CDM_Common update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
----- END Of STEP 1 ----------

------ STEP 2 ----------

-----END Of STEP 2 -------

------ STEP 3 ------------

-- Added column BillingDegreeAfterBHRedesignSUD in CustomStaff Table

IF OBJECT_ID('CustomStaff')  IS NOT NULL
BEGIN

	IF COL_LENGTH('CustomStaff','BillingDegreeAfterBHRedesignSUD') IS NULL
	BEGIN
		ALTER TABLE CustomStaff ADD BillingDegreeAfterBHRedesignSUD  int NULL
	END
	
	IF COL_LENGTH('CustomStaff','BillingDegreeAfterBHRedesignSUD')IS NOT NULL
	 BEGIN
			IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[StaffLicenseDegrees_CustomStaff_FK3]') AND parent_object_id = OBJECT_ID(N'[dbo].[CustomStaff]'))
			BEGIN
				ALTER TABLE CustomStaff ADD CONSTRAINT StaffLicenseDegrees_CustomStaff_FK3
				FOREIGN KEY (BillingDegreeAfterBHRedesignSUD)
				REFERENCES StaffLicenseDegrees(StaffLicenseDegreeId) 
			END
	  END
	  
	   IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('CustomStaff') AND name='XIE3_CustomStaff')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE3_CustomStaff] ON [dbo].[CustomStaff] 
		(
		BillingDegreeAfterBHRedesignSUD ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CustomStaff') AND name='XIE3_CustomStaff')
		PRINT '<<< CREATED INDEX CustomStaff.XIE3_CustomStaff >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX CustomStaff.XIE3_CustomStaff >>>', 16, 1)		
		END	 
	
	
	
PRINT 'STEP 3 COMPLETED'	
END	


------ END OF STEP 3 -----

------ STEP 4 -------------

-------END Of STEP 4------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((SELECT cast(value as decimal(10,2)) FROM SystemConfigurationKeys WHERE [key] = 'CDM_Common')  = 1.0)
BEGIN
	UPDATE SystemConfigurationKeys SET value ='1.1' WHERE [key] = 'CDM_Common'
		PRINT 'STEP 7 COMPLETED'
END
GO

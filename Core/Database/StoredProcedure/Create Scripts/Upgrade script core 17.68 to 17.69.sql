----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 17.68)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 17.68 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------

-----End of Step 2 -------

------ STEP 3 ------------
IF OBJECT_ID('LicenseAndDegreeGroups')  IS NOT NULL
BEGIN
	IF COL_LENGTH('LicenseAndDegreeGroups','StartDate') IS  NULL
	BEGIN
		ALTER TABLE LicenseAndDegreeGroups ADD  StartDate  DATETIME NULL
	END
	
	IF COL_LENGTH('LicenseAndDegreeGroups','EndDate') IS  NULL
	BEGIN
		ALTER TABLE LicenseAndDegreeGroups ADD  EndDate  DATETIME NULL
	END
	
	IF COL_LENGTH('LicenseAndDegreeGroups','Active') IS  NULL
	BEGIN
		ALTER TABLE LicenseAndDegreeGroups ADD  Active  type_YOrN NULL
										   CHECK (Active in ('Y','N'))
	END	
		
END

IF OBJECT_ID('ContractRates')  IS NOT NULL
BEGIN

	IF COL_LENGTH('ContractRates','LicenseAndDegreeGroupId') IS  NULL
	BEGIN
		ALTER TABLE ContractRates ADD  LicenseAndDegreeGroupId  INT NULL
	END
	
	IF COL_LENGTH('ContractRates','PlaceOfServiceId') IS  NULL
	BEGIN
		ALTER TABLE ContractRates ADD  PlaceOfServiceId  INT NULL
	END
		
	IF COL_LENGTH('ContractRates','ClaimLineItemGroupId')IS NOT NULL
	BEGIN
		   IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[LicenseAndDegreeGroups_ContractRates_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[ContractRates]'))
		   BEGIN
			 ALTER TABLE ContractRates ADD CONSTRAINT LicenseAndDegreeGroups_ContractRates_FK 
			 FOREIGN KEY (LicenseAndDegreeGroupId)
			 REFERENCES LicenseAndDegreeGroups(LicenseAndDegreeGroupId) 
		   END
	END
	
	IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ContractRates]') AND name = N'XIE2_ContractRates')
		BEGIN
			CREATE NONCLUSTERED INDEX [XIE2_ContractRates] ON [dbo].[ContractRates] 
			(
			[LicenseAndDegreeGroupId]  ASC
			)
			WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
			IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('ContractRates') AND name='XIE2_ContractRates')
			PRINT '<<< CREATED INDEX ContractRates.XIE2_ContractRates>>>'
			ELSE
			RAISERROR('<<< FAILED CREATING INDEX ContractRates.XIE2_ContractRates>>>', 16, 1)		
		END	
	
END	

	PRINT 'STEP 3 COMPLETED'

------ End of STEP 3 ------------
------ STEP 4 ---------------
 
----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 17.68)
BEGIN
Update SystemConfigurations set DataModelVersion=17.69
PRINT 'STEP 7 COMPLETED'
END
Go


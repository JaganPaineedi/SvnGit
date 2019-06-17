----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 16.00)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 16.00 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------
--Part1 Begin

--Part1 Ends

--Part2 Begins

--Part2 Ends	

-----End of Step 2 -------

------ STEP 3 ------------

-- Added Column(s)  in StaffLicenseDegrees Table

IF OBJECT_ID('StaffLicenseDegrees')IS NOT NULL
BEGIN
	IF COL_LENGTH('StaffLicenseDegrees','StateFIPS')IS NULL
	BEGIN
		ALTER TABLE StaffLicenseDegrees ADD StateFIPS type_State  NULL
		 
	EXEC sys.sp_addextendedproperty 'StaffLicenseDegrees_Description'
	,'StateFIPS columns stores state code for which Individual Staff Licenense is applicable'
	,'schema'
	,'dbo'
	,'table'
	,'StaffLicenseDegrees'
	,'column'
	,'StateFIPS'
	
	END
	
	IF COL_LENGTH('StaffLicenseDegrees','PrimaryValue')IS NULL
	BEGIN
		ALTER TABLE StaffLicenseDegrees	ADD PrimaryValue type_YOrN	NULL
										CHECK (PrimaryValue in ('Y','N'))
		
	EXEC sys.sp_addextendedproperty 'StaffLicenseDegrees_Description'
	,'Column is to identify the Primary License '
	,'schema'
	,'dbo'
	,'table'
	,'StaffLicenseDegrees'
	,'column'
	,'PrimaryValue'
	
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

IF ((select DataModelVersion FROM SystemConfigurations)  = 16.00)
BEGIN
Update SystemConfigurations set DataModelVersion=16.01
PRINT 'STEP 7 COMPLETED'
END
Go



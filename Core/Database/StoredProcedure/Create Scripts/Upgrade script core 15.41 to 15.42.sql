------- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 15.41 )
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 15.41 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------
--Part1 Begin


--Part1 Ends

--Part2 Begins

--Part2 Ends	

-----End of Step 2 -------

------ STEP 3 ------------

 IF OBJECT_ID('DocumentCarePlans') IS NOT NULL
 BEGIN
 
	IF EXISTS( select 1 from INFORMATION_SCHEMA.COLUMNS IC where TABLE_NAME = 'DocumentCarePlans' and COLUMN_NAME = 'MHAssessmentLevelOfCare'  and DATA_TYPE='varchar')
	 BEGIN
		ALTER TABLE DocumentCarePlans ALTER COLUMN  MHAssessmentLevelOfCare type_Comment2  NULL
	 END
	 
	 IF EXISTS( select 1 from INFORMATION_SCHEMA.COLUMNS IC where TABLE_NAME = 'DocumentCarePlans' and COLUMN_NAME = 'ASAMLevelOfCare'  and DATA_TYPE='varchar')
	 BEGIN
		ALTER TABLE DocumentCarePlans ALTER COLUMN  ASAMLevelOfCare type_Comment2  NULL
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

IF ((select DataModelVersion FROM SystemConfigurations)  = 15.41)
BEGIN
Update SystemConfigurations set DataModelVersion=15.42
PRINT 'STEP 7 COMPLETED'
END
Go


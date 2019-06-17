----- STEP 1 ----------
IF ((SELECT value FROM SystemConfigurationKeys WHERE [key] = 'CDM_CrisisServiceNote')  < 1.0 ) or
Not exists(SELECT 1 FROM SystemConfigurationKeys WHERE [key] = 'CDM_CrisisServiceNote')
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 1.0 for CDM_CrisisServiceNote update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------
--Part1 Begin

--Part1 Ends

--Part2 Begins


--Part2 Ends
-----End of Step 2 -------

------ STEP 3 -----------
IF EXISTS( select 1 from INFORMATION_SCHEMA.COLUMNS IC where TABLE_NAME = 'CustomAcuteServicesPrescreens' and COLUMN_NAME = 'ActionTakenPsychiatricPlacementHospital'  and DOMAIN_NAME='type_GlobalCode')
 BEGIN 
	UPDATE  CustomAcuteServicesPrescreens  SET ActionTakenPsychiatricPlacementHospital=NULL
	ALTER TABLE CustomAcuteServicesPrescreens  ALTER COLUMN ActionTakenPsychiatricPlacementHospital int  NULL					
END
 
IF  NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Sites_CustomAcuteServicesPrescreens_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[CustomAcuteServicesPrescreens]'))
BEGIN
	ALTER TABLE CustomAcuteServicesPrescreens ADD CONSTRAINT Sites_CustomAcuteServicesPrescreens_FK 
		FOREIGN KEY (ActionTakenPsychiatricPlacementHospital)
		REFERENCES Sites(SiteId)
END		
		
 PRINT 'STEP 3 COMPLETED'
 
----END Of STEP 3--------
------ STEP 4 -----------
 
--END Of STEP 4

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------
IF ((SELECT cast(value as decimal(10,2)) FROM SystemConfigurationKeys WHERE [key] = 'CDM_CrisisServiceNote')  = 1.0 )
BEGIN
	UPDATE SystemConfigurationKeys SET value ='1.1' WHERE [key] = 'CDM_CrisisServiceNote'
		PRINT 'STEP 7 COMPLETED'
END
GO
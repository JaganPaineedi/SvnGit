IF (((SELECT value FROM SystemConfigurationKeys WHERE [key] = 'CDM_PsychiatricNote')  < 1.0 )or 
Not exists(SELECT 1 FROM SystemConfigurationKeys WHERE [key] = 'CDM_PsychiatricNote'))
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 1.0 for CDM_PsychiatricNote update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------
--Part1 Begin

--Part1 Ends

--Part2 Begins

--Part2 Ends

-----End of Step 2 -------

------ STEP 3 ------------

IF OBJECT_ID('CustomDocumentPsychiatricNoteGenerals')IS NOT NULL
BEGIN
		
	IF COL_LENGTH('CustomDocumentPsychiatricNoteGenerals','AllergiesSmokePerday') IS NOT NULL
	BEGIN
		 ALTER TABLE CustomDocumentPsychiatricNoteGenerals ALTER COLUMN  AllergiesSmokePerday varchar(100) NULL
	END
	
	 PRINT 'STEP 3 COMPLETED'
END
------ END OF STEP 3 -----

------ STEP 4 ----------
--------------------------------------------------------------
--END Of STEP 4

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((SELECT cast(value as decimal(10,2)) FROM SystemConfigurationKeys WHERE [key] = 'CDM_PsychiatricNote')  = 1.0 )
BEGIN
	Update SystemConfigurationKeys set value ='1.1' Where [key] = 'CDM_PsychiatricNote'


 PRINT 'STEP 7 COMPLETED'
END
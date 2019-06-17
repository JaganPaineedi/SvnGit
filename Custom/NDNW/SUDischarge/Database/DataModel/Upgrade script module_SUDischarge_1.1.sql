----- STEP 1 ----------
IF ((SELECT value FROM SystemConfigurationKeys WHERE [key] = 'CDM_SUDischarge')  < 1.0 ) or
Not exists(SELECT 1 FROM SystemConfigurationKeys WHERE [key] = 'CDM_SUDischarge')
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 1.0 for CDM_SUDischarge update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------
--Part1 Begin

--Part1 Ends

--Part2 Begins


--Part2 Ends

-----End of Step 2 -------

------ STEP 3 ------------
IF COL_LENGTH('CustomDocumentSUDischarges','Severity1') IS NULL
BEGIN
 ALTER TABLE CustomDocumentSUDischarges ADD Severity1 type_GlobalCode NULL
END

IF COL_LENGTH('CustomDocumentSUDischarges','Severity2') IS NULL
BEGIN
 ALTER TABLE CustomDocumentSUDischarges ADD Severity2 type_GlobalCode NULL
END

IF COL_LENGTH('CustomDocumentSUDischarges','Severity3') IS NULL
BEGIN
 ALTER TABLE CustomDocumentSUDischarges ADD Severity3 type_GlobalCode NULL
END

PRINT 'STEP 3 COMPLETED'

-----End of Step 3 -------
------ STEP 4 ----------
---------------------------------------------------------------
--END Of STEP 4

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------
IF ((SELECT cast(value as decimal(10,2)) FROM SystemConfigurationKeys WHERE [key] = 'CDM_SUDischarge')  = 1.0 )
BEGIN
	UPDATE SystemConfigurationKeys SET value ='1.1' WHERE [key] = 'CDM_SUDischarge'
	PRINT 'STEP 7 COMPLETED'
END
GO	

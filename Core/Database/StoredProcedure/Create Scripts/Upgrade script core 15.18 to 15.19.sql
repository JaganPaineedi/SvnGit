----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 15.18)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 15.18 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------
--Part1 Begin

--Part1 Ends

--Part2 Begins


--Part2 Ends

-----End of Step 2 -------

------ STEP 3 ------------

------ END OF STEP 3 -----

------ STEP 4 ---------- 
IF OBJECT_ID('ClientMedicationScripts') IS NOT NULL
BEGIN
	IF COL_LENGTH('ClientMedicationScripts','VerbalOrderReadBack') IS  NULL
	BEGIN
		ALTER TABLE ClientMedicationScripts ADD  VerbalOrderReadBack  type_YOrN  NULL
											CHECK (VerbalOrderReadBack in ('Y','N'))
	END
	PRINT 'STEP 3 COMPLETED'
END
--END Of STEP 4 ------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 15.18)
BEGIN
Update SystemConfigurations set DataModelVersion=15.19
PRINT 'STEP 7 COMPLETED'
END
Go

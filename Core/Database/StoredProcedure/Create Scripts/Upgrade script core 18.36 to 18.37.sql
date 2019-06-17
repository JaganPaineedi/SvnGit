----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 18.36)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 18.36 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------

-----End of Step 2 -------


------ STEP 3 ------------

IF OBJECT_ID('ClientAllergies') IS NOT NULL
BEGIN

	IF COL_LENGTH('ClientAllergies','AllergyReaction')IS   NULL
	BEGIN
		ALTER TABLE ClientAllergies   ADD   AllergyReaction  type_GlobalCode    NULL
	END
	
	IF COL_LENGTH('ClientAllergies','AllergySeverity')IS   NULL
	BEGIN
		ALTER TABLE ClientAllergies   ADD   AllergySeverity  type_GlobalCode    NULL
	END
	
END

IF OBJECT_ID('ClientAllergyHistory') IS NOT NULL
BEGIN

	IF COL_LENGTH('ClientAllergyHistory','AllergyReaction')IS   NULL
	BEGIN
		ALTER TABLE ClientAllergyHistory   ADD   AllergyReaction  type_GlobalCode    NULL
	END
	
	IF COL_LENGTH('ClientAllergyHistory','AllergySeverity')IS   NULL
	BEGIN
		ALTER TABLE ClientAllergyHistory   ADD   AllergySeverity  type_GlobalCode    NULL
	END

END

PRINT 'STEP 3 COMPLETED'	
------ END Of STEP 3 ------------

------ STEP 4 ---------------

 ----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------
IF ((select DataModelVersion FROM SystemConfigurations)  = 18.36)
BEGIN
Update SystemConfigurations set DataModelVersion=18.37
PRINT 'STEP 7 COMPLETED'
END
Go

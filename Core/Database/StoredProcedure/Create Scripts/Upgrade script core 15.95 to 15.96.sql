----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 15.95)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 15.95 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 -----------

-----End of Step 2 -------

------ STEP 3 ------------

-- Added Column(s) in PHQ9Documents Table

IF OBJECT_ID('PHQ9Documents')IS NOT NULL
BEGIN
	IF COL_LENGTH('PHQ9Documents','PharmacologicalIntervention')IS NULL
	BEGIN
		ALTER TABLE PHQ9Documents ADD PharmacologicalIntervention type_YOrN  NULL
								 CHECK (PharmacologicalIntervention in ('Y','N'))
	END

	IF COL_LENGTH('PHQ9Documents','OtherInterventions')IS NULL
	BEGIN
		ALTER TABLE PHQ9Documents ADD OtherInterventions type_YOrN  NULL
								 CHECK (OtherInterventions in ('Y','N'))
	END

	IF COL_LENGTH('PHQ9Documents','DocumentationFollowUp')IS NULL
	BEGIN
		ALTER TABLE PHQ9Documents ADD DocumentationFollowUp type_Comment2  NULL
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

IF ((select DataModelVersion FROM SystemConfigurations)  = 15.95)
BEGIN
Update SystemConfigurations set DataModelVersion=15.96
PRINT 'STEP 7 COMPLETED'
END
Go



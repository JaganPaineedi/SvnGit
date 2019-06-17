----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 19.03)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 19.03 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------

-----End of Step 2 -------

------ STEP 3 ------------
-- added new column PreferredGenderPronoun in  Clients table 

IF OBJECT_ID('Clients')  IS NOT NULL
BEGIN

	IF COL_LENGTH('Clients','PreferredGenderPronoun') IS NULL
	BEGIN
		ALTER TABLE Clients ADD PreferredGenderPronoun  type_GlobalCode NULL
	END
		
	PRINT 'STEP 3 COMPLETED'

END
------ End of STEP 3 ------------
------ STEP 4 ---------------
 
----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 19.03)
BEGIN
Update SystemConfigurations set DataModelVersion=19.04
PRINT 'STEP 7 COMPLETED'
END
Go


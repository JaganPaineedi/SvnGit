----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 19.02)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 19.02 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------

-----End of Step 2 -------

------ STEP 3 ------------
-- added new column ClinicalLocation in  Orders table 
IF OBJECT_ID('Orders')  IS NOT NULL
BEGIN
	IF COL_LENGTH('Orders','ClinicalLocation') IS NULL
	BEGIN
		ALTER TABLE Orders ADD ClinicalLocation  type_GlobalCode NULL
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

IF ((select DataModelVersion FROM SystemConfigurations)  = 19.02)
BEGIN
Update SystemConfigurations set DataModelVersion=19.03
PRINT 'STEP 7 COMPLETED'
END
Go


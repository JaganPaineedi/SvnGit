----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 18.14)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 18.14 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------

-----End of Step 2 -------
------ STEP 3 ------------

-----End of Step 3 -------

------ STEP 4 ---------------
-------------------ClientContacts---------------

IF OBJECT_ID('ClientContacts') IS NOT NULL
BEGIN

	IF COL_LENGTH('ClientContacts','Organization')IS  NOT NULL
	BEGIN
		ALTER TABLE ClientContacts   ALTER COLUMN  Organization  varchar(200) NULL	
	END
	
	PRINT 'STEP 3 COMPLETED'	
END



----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 18.14)
BEGIN
Update SystemConfigurations set DataModelVersion=18.15
PRINT 'STEP 7 COMPLETED'
END
Go


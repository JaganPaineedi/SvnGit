----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 15.90)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 15.90 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------

-----End of STEP 2 -------

------ STEP 3 ------------

-- Added Column(s) in StaffLoginHistory Table

IF OBJECT_ID('StaffLoginHistory')IS NOT NULL
BEGIN
	IF COL_LENGTH('StaffLoginHistory','SessionId')IS NULL
	BEGIN
		ALTER TABLE StaffLoginHistory ADD SessionId VARCHAR(30)
	END
	
	IF COL_LENGTH('StaffLoginHistory','LogoutTime')IS NULL
	BEGIN
		ALTER TABLE StaffLoginHistory ADD LogoutTime DATETIME
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

IF ((select DataModelVersion FROM SystemConfigurations)  = 15.90)
BEGIN
Update SystemConfigurations set DataModelVersion=15.91
PRINT 'STEP 7 COMPLETED'
END
Go




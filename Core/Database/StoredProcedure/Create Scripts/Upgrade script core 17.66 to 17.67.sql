----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 17.66)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 17.66 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
-- ------ STEP 2 ----------

-- -----End of Step 2 -------

-- ------ STEP 3 ------------
-- IF OBJECT_ID('StaffPreferences')  IS NOT NULL
-- BEGIN
	-- IF COL_LENGTH('StaffPreferences','StreamlineStaff') IS  NULL
	-- BEGIN
		-- ALTER TABLE StaffPreferences ADD  StreamlineStaff  type_YOrN NULL
									 -- CHECK (StreamlineStaff in('Y','N'))
	-- END
		
	-- PRINT 'STEP 3 COMPLETED'

-- END
-- ------ End of STEP 3 ------------
-- ------ STEP 4 ---------------
 
-- ----END Of STEP 4------------

-- ------ STEP 5 ----------------

-- -------END STEP 5-------------

-- ------ STEP 6  ----------

-- ------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 17.66)
BEGIN
Update SystemConfigurations set DataModelVersion=17.67
PRINT 'STEP 7 COMPLETED'
END
Go


----- STEP 1 ----------
-- Reverted change for ARLedger constraint.  This constraint failed for some legacy customers.
-- Therefore this DM script does nothing.
IF ((select DataModelVersion FROM SystemConfigurations)  < 19.09)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 19.09 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------
-- THIS SECTION INTENTIONALLY BLANK
-----End of Step 2 -------

------  STEP 3 ------------
-- THIS SECTION INTENTIONALLY BLANK
------ END OF STEP 3 ------------

------ STEP 4 ---------------
-- THIS SECTION INTENTIONALLY BLANK
 ----END Of STEP 4------------

------ STEP 5 ----------------
-- THIS SECTION INTENTIONALLY BLANK
-------END STEP 5-------------

------ STEP 6  ----------
-- THIS SECTION INTENTIONALLY BLANK
-------END STEP 6-------------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 19.09)
BEGIN
Update SystemConfigurations set DataModelVersion=19.10
PRINT 'STEP 7 COMPLETED'
END
Go


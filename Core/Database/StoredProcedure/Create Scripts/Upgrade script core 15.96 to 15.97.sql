----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 15.96)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 15.96 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 -----------

-----End of Step 2 -------

------ STEP 3 ------------

-- Added Column(s) in LandingPageMessages Table

IF OBJECT_ID('LandingPageMessages')IS NOT NULL
BEGIN
	IF COL_LENGTH('LandingPageMessages','StartDate')IS NULL
	BEGIN
		ALTER TABLE LandingPageMessages ADD StartDate datetime  NULL
		 
	EXEC sys.sp_addextendedproperty 'LandingPageMessages_Description'
	,'StartDate Field store the Start Date and Time. message will be displayed From the sart date time'
	,'schema'
	,'dbo'
	,'table'
	,'LandingPageMessages'
	,'column'
	,'StartDate'

	END

	IF COL_LENGTH('LandingPageMessages','EndDate')IS NULL
	BEGIN
		ALTER TABLE LandingPageMessages ADD EndDate datetime  NULL
		 
	EXEC sys.sp_addextendedproperty 'LandingPageMessages_Description'
	,'EndDate Field Store the  End Date and Time Message will not dispaly after the end date time '
	,'schema'
	,'dbo'
	,'table'
	,'LandingPageMessages'
	,'column'
	,'EndDate'

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

IF ((select DataModelVersion FROM SystemConfigurations)  = 15.96)
BEGIN
Update SystemConfigurations set DataModelVersion=15.97
PRINT 'STEP 7 COMPLETED'
END
Go



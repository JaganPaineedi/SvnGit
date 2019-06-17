----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 18.07)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 18.07 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------
-----End of Step 2 -------
------ STEP 3 ------------

-----End of Step 3 -------

------ STEP 4 ---------------
IF OBJECT_ID('UnsavedChanges') IS NOT NULL
BEGIN	
	IF COL_LENGTH('UnsavedChanges','OriginalXML') IS NULL
	BEGIN
		 ALTER TABLE UnsavedChanges ADD OriginalXML XML NULL
	END
	
	IF COL_LENGTH('UnsavedChanges','MissingColumns') IS NULL
	BEGIN
		 ALTER TABLE UnsavedChanges ADD MissingColumns varchar(max)  NULL
	
	 EXEC sys.sp_addextendedproperty 'UnsavedChanges_Description'
	,'MissingColumns column stores which will have the columns which are null'
	,'schema'
	,'dbo'
	,'table'
	,'UnsavedChanges'
	,'column'
	,'MissingColumns'
	END
	
	PRINT 'STEP 3 COMPLETED'
END
----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 18.07)
BEGIN
Update SystemConfigurations set DataModelVersion=18.08
PRINT 'STEP 7 COMPLETED'
END
Go


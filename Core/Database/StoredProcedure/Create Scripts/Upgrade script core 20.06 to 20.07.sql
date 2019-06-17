----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 20.06)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 20.06 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END

------ STEP 2 ----------

-----End of Step 2 -------

------ STEP 3 ------------

----Add New Column in KPIMaster Table 	
IF OBJECT_ID('KPIMaster') IS NOT NULL
BEGIN
		IF COL_LENGTH('KPIMaster','ProcessingStoredProcedure')IS NULL
		BEGIN
		 ALTER TABLE KPIMaster ADD  ProcessingStoredProcedure varchar(100)	NULL

EXEC sys.sp_addextendedproperty 'KPIMaster_Description'
	,'This column contains the StoredProcedure name which will be called from mobile API which is 
	  used for sending alert log information to the user present in the alert list column.'
	,'schema'
	,'dbo'
	,'table'
	,'KPIMaster'
	,'column'
	,'ProcessingStoredProcedure' 
	 
END
	PRINT 'STEP 3 COMPLETED'																			
END


------ END Of STEP 3 ------------

------ STEP 4 ---------------

 ----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------
IF ((select DataModelVersion FROM SystemConfigurations)  = 20.06)
BEGIN
Update SystemConfigurations set DataModelVersion=20.07
PRINT 'STEP 7 COMPLETED'
END

Go

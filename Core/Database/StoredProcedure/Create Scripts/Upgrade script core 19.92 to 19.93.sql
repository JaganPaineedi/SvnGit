----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 19.92)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 19.92 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
-----
------ STEP 2 ----------

-----End of Step 2 -------

------ STEP 3 ------------
		
----Add New Columns in ProcedureCodes Table 	
IF OBJECT_ID('ProcedureCodes') IS NOT NULL
BEGIN
		IF COL_LENGTH('ProcedureCodes','RequireSignedNoteForNonBillableService')IS NULL
		BEGIN
		 ALTER TABLE ProcedureCodes ADD  RequireSignedNoteForNonBillableService  type_YOrN	NULL
									CHECK (RequireSignedNoteForNonBillableService in ('Y','N'))		
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
IF ((select DataModelVersion FROM SystemConfigurations)  = 19.92)
BEGIN
Update SystemConfigurations set DataModelVersion=19.93
PRINT 'STEP 7 COMPLETED'
END

Go

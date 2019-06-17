----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 19.95)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 19.95 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
-----
------ STEP 2 ----------

-----End of Step 2 -------

------ STEP 3 ------------
		
----Dropped index in EMCodeProcedureCodes  Table 	
IF  EXISTS (SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[EMCodeProcedureCodes]') AND name = N'EMCodeProcedureCodes_UX')
BEGIN
	
	ALTER TABLE EMCodeProcedureCodes DROP CONSTRAINT  [EMCodeProcedureCodes_UX]
	
PRINT 'STEP 3 COMPLETED'
END

	
------ END Of STEP 3 ------------

------ STEP 4 ---------------

 ----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------
IF ((select DataModelVersion FROM SystemConfigurations)  = 19.95)
BEGIN
Update SystemConfigurations set DataModelVersion=19.96
PRINT 'STEP 7 COMPLETED'
END

Go

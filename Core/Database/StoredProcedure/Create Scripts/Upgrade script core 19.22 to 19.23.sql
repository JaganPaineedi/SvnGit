----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 19.22)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 19.22 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
-----
------ STEP 2 ----------

-----End of Step 2 -------

------ STEP 3 ------------
------ STEP 3 ------------

--Add column in DocumentCodes Table

IF OBJECT_ID('DocumentCodes') IS NOT NULL
BEGIN
	IF COL_LENGTH('DocumentCodes','AllowVersionAuthorToSign') IS NULL
	BEGIN
		ALTER TABLE DocumentCodes ADD AllowVersionAuthorToSign type_YOrN	DEFAULT('N') NULL 
								  CHECK(AllowVersionAuthorToSign in('Y','N'))																	  
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
IF ((select DataModelVersion FROM SystemConfigurations)  = 19.22)
BEGIN
Update SystemConfigurations set DataModelVersion=19.23
PRINT 'STEP 7 COMPLETED'
END
Go

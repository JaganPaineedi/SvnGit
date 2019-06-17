----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 17.86 )
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 17.86 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END

------ STEP 2 ----------
--Part1 Begin


--Part1 Ends

--Part2 Begins

--Part2 Ends	

-----End of Step 2 -------

------ STEP 3 ------------


IF COL_LENGTH('ProviderAuthorizationDocuments','LastReviewedBy') IS NOT NULL
BEGIN
	ALTER TABLE ProviderAuthorizationDocuments ALTER COLUMN LastReviewedBy varchar(250) NULL
END


PRINT 'STEP 3 COMPLETED'


-----END Of STEP 3--------------------

------ STEP 4 ------------

----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------
------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 17.86)
BEGIN
Update SystemConfigurations set DataModelVersion=17.87
PRINT 'STEP 7 COMPLETED'
END
Go
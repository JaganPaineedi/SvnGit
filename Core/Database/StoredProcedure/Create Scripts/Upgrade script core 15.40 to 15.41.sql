----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 15.40 )
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 15.40 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END

------ STEP 2 ----------
--Part1 Begin


--Part1 Ends

--Part2 Begins

--Part2 Ends	

-----End of Step 2 ------- 

------ STEP 3 ------------

IF OBJECT_ID('BillingCodes') IS NOT NULL
BEGIN	

	IF COL_LENGTH('BillingCodes','Category1') IS NULL
	BEGIN
		ALTER TABLE BillingCodes ADD Category1   type_GlobalCode	NULL			  
	END
	
	IF COL_LENGTH('BillingCodes','Category2') IS NULL
	BEGIN
		ALTER TABLE BillingCodes ADD Category2   type_GlobalCode	NULL			  
	END
	
	IF COL_LENGTH('BillingCodes','Category3') IS NULL
	BEGIN
		ALTER TABLE BillingCodes ADD Category3   type_GlobalCode	NULL			  
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
------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 15.40)
BEGIN
Update SystemConfigurations set DataModelVersion=15.41
PRINT 'STEP 7 COMPLETED'
END
Go
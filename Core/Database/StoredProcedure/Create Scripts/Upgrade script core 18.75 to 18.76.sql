----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 18.75)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 18.75 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------
-------------------------------------------------------------

------ STEP 3 ------------

--ProcedureCodes

IF OBJECT_ID('ProcedureCodes') IS NOT NULL
BEGIN

	IF COL_LENGTH('ProcedureCodes','ExternalCode3')IS  NULL
	 BEGIN 	
		ALTER TABLE ProcedureCodes ADD  ExternalCode3 varchar(25) NULL
	  END
	  
	  IF COL_LENGTH('ProcedureCodes','ExternalSource3')IS  NULL
	 BEGIN 	
		ALTER TABLE ProcedureCodes ADD  ExternalSource3 type_GlobalCode NULL
	  END
	  	  
END

--BillingCodes
IF OBJECT_ID('BillingCodes') IS NOT NULL
BEGIN

	IF COL_LENGTH('BillingCodes','ExternalCode3')IS  NULL
	 BEGIN 	
		ALTER TABLE BillingCodes ADD  ExternalCode3 varchar(25) NULL
	  END
	  
	  IF COL_LENGTH('BillingCodes','ExternalSource3')IS  NULL
	 BEGIN 	
		ALTER TABLE BillingCodes ADD  ExternalSource3 type_GlobalCode NULL
	  END
	  	  
END
	  	PRINT 'STEP 3 COMPLETED'



--END Of STEP 3------------
------ STEP 4 ----------

------END Of STEP 4---------------

------ STEP 5 ----------------

-------END STEP 5-------------
------ STEP 6  ----------

----END Of STEP 6 ------------

------ STEP 7 -----------
IF ((select DataModelVersion FROM SystemConfigurations)  = 18.75)
BEGIN
Update SystemConfigurations set DataModelVersion=18.76
	PRINT 'STEP 7 COMPLETED'
END
Go

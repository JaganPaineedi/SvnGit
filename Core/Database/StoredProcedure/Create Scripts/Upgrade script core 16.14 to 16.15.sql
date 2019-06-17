----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 16.14)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 16.14 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 -----------

-----End of Step 2 -------

------ STEP 3 ------------

-- added column(s) in ClientImmunizations Tables.

IF OBJECT_ID('ClientImmunizations')IS NOT NULL
BEGIN
	IF COL_LENGTH('ClientImmunizations','ResidentMonitored') IS NULL
	BEGIN
		ALTER TABLE ClientImmunizations ADD  ResidentMonitored type_YOrN NULL
										CHECK (ResidentMonitored in ('Y','N'))
	END		
	
	IF COL_LENGTH('ClientImmunizations','ReactionNoted') IS NULL
	BEGIN
		ALTER TABLE ClientImmunizations ADD  ReactionNoted type_GlobalCode NULL
	END	
	
	PRINT 'STEP 3 COMPLETED'
END    

-----END Of STEP 3---------

------ STEP 4 ------------

----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 16.14)
BEGIN
Update SystemConfigurations set DataModelVersion=16.15
PRINT 'STEP 7 COMPLETED'
END
Go



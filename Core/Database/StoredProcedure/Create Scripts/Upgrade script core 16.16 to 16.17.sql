----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 16.16)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 16.16 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------
--Part1 Begin

--Part1 Ends

--Part2 Begins

--Part2 Ends	

-----End of Step 2 -------

------ STEP 3 ------------
IF OBJECT_ID('Adjudications')IS NOT NULL
BEGIN
	IF COL_LENGTH('Adjudications','ClaimBundleId')IS  NULL
	BEGIN
		ALTER TABLE Adjudications ADD  ClaimBundleId INT  NULL
	END
	
	IF COL_LENGTH('Adjudications','ClaimDenialOverrideId')IS  NULL
	BEGIN
		ALTER TABLE Adjudications ADD  ClaimDenialOverrideId INT  NULL
	END
	
	IF COL_LENGTH('Adjudications','ClaimBundleId')IS  NOT NULL
	BEGIN
		IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[ClaimBundles_Adjudications_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[Adjudications]'))	
		BEGIN
			ALTER TABLE Adjudications ADD CONSTRAINT ClaimBundles_Adjudications_FK
			FOREIGN KEY (ClaimBundleId)
			REFERENCES ClaimBundles(ClaimBundleId)	 
		END 
	END
	
	IF COL_LENGTH('Adjudications','ClaimDenialOverrideId')IS  NOT NULL
	BEGIN
		IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[ClaimDenialOverrides_Adjudications_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[Adjudications]'))	
		BEGIN
			ALTER TABLE Adjudications ADD CONSTRAINT ClaimDenialOverrides_Adjudications_FK
			FOREIGN KEY (ClaimDenialOverrideId)
			REFERENCES ClaimDenialOverrides(ClaimDenialOverrideId)	 
		END 
	END
	
END 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AdjudicationDenialOverrides]') AND type in (N'U'))
BEGIN
	DROP TABLE [dbo].[AdjudicationDenialOverrides]
END


PRINT 'STEP 3 COMPLETED'

-----END Of STEP 3--------------------

------ STEP 4 ------------

----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 16.16)
BEGIN
Update SystemConfigurations set DataModelVersion=16.17
PRINT 'STEP 7 COMPLETED'
END
Go




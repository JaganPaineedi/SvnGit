----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 15.25 )
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 15.25 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
-------- STEP 2 ----------
--Part1 Begin


--Part1 Ends

--Part2 Begins

--Part2 Ends	

-----End of Step 2 -------


------ STEP 3 ------------ 

IF OBJECT_ID('PlacementFamilies')IS NOT NULL
BEGIN
	IF COL_LENGTH('PlacementFamilies','LinkedProviderId')IS  NULL
	BEGIN
		ALTER TABLE PlacementFamilies ADD  LinkedProviderId INT  NULL
	END
	IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Providers_PlacementFamilies_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[PlacementFamilies]'))	
	BEGIN
		ALTER TABLE PlacementFamilies ADD CONSTRAINT Providers_PlacementFamilies_FK
		FOREIGN KEY (LinkedProviderId)
		REFERENCES Providers(ProviderId)	 
	END 
	PRINT 'STEP 3 COMPLETED'
END 
------ END Of STEP 3 ------------ 
------ STEP 4----------------


--END Of STEP 4

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 15.25)
BEGIN
Update SystemConfigurations set DataModelVersion=15.26
PRINT 'STEP 7 COMPLETED'
END
Go



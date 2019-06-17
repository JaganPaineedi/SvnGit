----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  <  15.34)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version  15.34 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END

------ STEP 2 ----------
--Part1 Begin


--Part1 Ends

--Part2 Begins

--Part2 Ends	

-----End of Step 2 -------

 

------ STEP 3 ------------

IF OBJECT_ID('ClientInpatientVisits') IS NOT NULL
BEGIN
	IF COL_LENGTH('ClientInpatientVisits','PhysicianId')IS NULL
	BEGIN 
		ALTER TABLE ClientInpatientVisits ADD PhysicianId int NULL										
	END	
	
	IF COL_LENGTH('ClientInpatientVisits','ClinicianId')IS NULL
	BEGIN 
		ALTER TABLE ClientInpatientVisits ADD ClinicianId int NULL										
	END	
	
IF COL_LENGTH('ClientInpatientVisits','PhysicianId')IS  NOT NULL
BEGIN
	IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Staff_ClientInpatientVisits_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[ClientInpatientVisits]'))	
	BEGIN
		ALTER TABLE ClientInpatientVisits ADD CONSTRAINT Staff_ClientInpatientVisits_FK
		FOREIGN KEY (PhysicianId)
		REFERENCES Staff(StaffId)	 
	END 
END

IF COL_LENGTH('ClientInpatientVisits','ClinicianId')IS  NOT NULL
BEGIN
	IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Staff_ClientInpatientVisits_FK2]') AND parent_object_id = OBJECT_ID(N'[dbo].[ClientInpatientVisits]'))	
	BEGIN
		ALTER TABLE ClientInpatientVisits ADD CONSTRAINT Staff_ClientInpatientVisits_FK2
		FOREIGN KEY (ClinicianId)
		REFERENCES Staff(StaffId)	 
	END 
END

	PRINT 'STEP 3 COMPLETED'
END
GO

-----END Of STEP 3--------------------

------ STEP 4 ------------
----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------
------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  =  15.34)
BEGIN
Update SystemConfigurations set DataModelVersion= 15.35
PRINT 'STEP 7 COMPLETED'
END
Go
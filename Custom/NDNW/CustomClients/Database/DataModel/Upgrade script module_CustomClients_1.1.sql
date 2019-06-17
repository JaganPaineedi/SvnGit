------- STEP 1 ----------
IF ((SELECT value FROM SystemConfigurationKeys WHERE [key] = 'CDM_CustomClients')  < 1.0 ) or
Not exists(SELECT 1 FROM SystemConfigurationKeys WHERE [key] = 'CDM_CustomClients')
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 1.0 for CDM_CustomClients update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------
--Part1 Begin
--Part1 Ends

--Part2 Begins 

--Part2 Ends
-----End of Step 2 -------

------ STEP 3 ------------

IF COL_LENGTH('CustomClients','ChildMedicaidId1')IS NULL
BEGIN
	ALTER TABLE  CustomClients ADD ChildMedicaidId1 INT NULL												
END

IF COL_LENGTH('CustomClients','ChildMedicaidId2')IS NULL
BEGIN
	ALTER TABLE  CustomClients ADD ChildMedicaidId2 INT NULL												
END

IF COL_LENGTH('CustomClients','ChildMedicaidId3')IS NULL
BEGIN
	ALTER TABLE  CustomClients ADD ChildMedicaidId3 INT NULL												
END

IF COL_LENGTH('CustomClients','FoodStampsAdmissionDate')IS NULL
BEGIN
	ALTER TABLE  CustomClients ADD FoodStampsAdmissionDate DATE NULL												
END

IF COL_LENGTH('CustomClients','FoodStampsSubmittedDate')IS NULL
BEGIN
	ALTER TABLE  CustomClients ADD FoodStampsSubmittedDate DATE NULL												
END

IF COL_LENGTH('CustomClients','FoodStampsApprovalDate')IS NULL
BEGIN
	ALTER TABLE  CustomClients ADD FoodStampsApprovalDate DATE NULL												
END

IF COL_LENGTH('CustomClients','FoodStampsClientLeaveDate')IS NULL
BEGIN
	ALTER TABLE  CustomClients ADD FoodStampsClientLeaveDate DATE NULL												
END

IF COL_LENGTH('CustomClients','FoodStampsClientLeaveTime')IS NULL
BEGIN
	ALTER TABLE  CustomClients ADD FoodStampsClientLeaveTime DATETIME NULL												
END

IF COL_LENGTH('CustomClients','SIDNumber') IS NULL 
BEGIN
 ALTER TABLE CustomClients ADD  SIDNumber int NULL
END

IF COL_LENGTH('CustomClients','ODLOINumber') IS NULL 
BEGIN
 ALTER TABLE CustomClients ADD  ODLOINumber int NULL
END

 PRINT 'STEP 3 COMPLETED'
-----End of Step 3 -------

------ STEP 4 ----------
 --END Of STEP 4

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------


------ STEP 7 -----------
IF ((SELECT cast(value as decimal(10,2)) FROM SystemConfigurationKeys WHERE [key] = 'CDM_CustomClients')  = 1.0 )
BEGIN
	UPDATE SystemConfigurationKeys SET value ='1.1' WHERE [key] = 'CDM_CustomClients'
	PRINT 'STEP 7 COMPLETED'
END
GO	
----- STEP 1 ----------

------ STEP 2 ----------
--Part1 Begin

--Part1 Ends

--Part2 Begins


--Part2 Ends

-----End of Step 2 -------

------ STEP 3 ------------

------ END OF STEP 3 -----

------ STEP 4 ----------

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

PRINT 'STEP 3 COMPLETED'
---------------------------------------------------------------
--END Of STEP 4

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------


IF NOT EXISTS (SELECT [key] FROM SystemConfigurationKeys WHERE [key] = 'CDM_Common')
 BEGIN
  INSERT INTO [dbo].[SystemConfigurationKeys]
       (CreatedBy
       ,CreateDate 
       ,ModifiedBy
       ,ModifiedDate
       ,[Key]
       ,Value
       )
    VALUES    
       ('SHSDBA'
       ,GETDATE()
       ,'SHSDBA'
       ,GETDATE()
       ,'CDM_Common'
       ,'1.0'
       )
            
 END
ELSE
 BEGIN
  UPDATE SystemConfigurationKeys SET value ='1.0' WHERE [key] = 'CDM_Common'
 END
GO

PRINT 'STEP 7 COMPLETED'


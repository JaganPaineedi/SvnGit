------- STEP 1 ----------
IF ((SELECT value FROM SystemConfigurationKeys WHERE [key] = 'CDM_CustomClients')  < 1.1 ) or
Not exists(SELECT 1 FROM SystemConfigurationKeys WHERE [key] = 'CDM_CustomClients')
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 1.1 for CDM_CustomClients update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------
--Part1 Begin
--Part1 Ends

--Part2 Begins 

--Part2 Ends
-----End of Step 2 -------

------ STEP 3 ------------

IF COL_LENGTH('CustomClients','AIPSIDNumber') IS NULL 
BEGIN
 ALTER TABLE CustomClients ADD  AIPSIDNumber int NULL
 PRINT 'STEP 3 COMPLETED'
END
-----End of Step 3 -------

------ STEP 4 ----------
 --END Of STEP 4

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------
IF ((SELECT cast(value as decimal(10,2)) FROM SystemConfigurationKeys WHERE [key] = 'CDM_CustomClients')  = 1.1 )
BEGIN
	UPDATE SystemConfigurationKeys SET value ='1.2' WHERE [key] = 'CDM_CustomClients'
	PRINT 'STEP 7 COMPLETED'
END
GO	
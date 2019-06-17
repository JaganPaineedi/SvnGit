------- STEP 1 ----------
IF (((SELECT value FROM SystemConfigurationKeys WHERE [key] = 'CDM_InvoluntaryService')  < 1.0 )or 
Not exists(SELECT 1 FROM SystemConfigurationKeys WHERE [key] = 'CDM_InvoluntaryService'))
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 1.0 for CDM_InvoluntaryService update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------
--Part1 Begin
--Part1 Ends

--Part2 Begins 

--Part2 Ends
-----End of Step 2 -------

------ STEP 3 ------------

IF OBJECT_ID('CustomClients') IS NOT NULL
BEGIN
IF EXISTS( select 1 from INFORMATION_SCHEMA.COLUMNS IC where TABLE_NAME = 'CustomDocumentInvoluntaryServices' and COLUMN_NAME = 'SIDNumber'  and DATA_TYPE='int')
 	BEGIN
		ALTER TABLE CustomDocumentInvoluntaryServices ALTER COLUMN  SIDNumber  varchar(30)  NULL										
	END
PRINT 'STEP 3 COMPLETED'
END
-----End of Step 3 -------

------ STEP 4 ----------

 --END Of STEP 4

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------


------ STEP 7 -----------

IF ((SELECT cast(value as decimal(10,2)) FROM SystemConfigurationKeys WHERE [key] = 'CDM_InvoluntaryService')  = 1.0 )
BEGIN
	UPDATE SystemConfigurationKeys SET value ='1.1' WHERE [key] = 'CDM_InvoluntaryService'
	PRINT 'STEP 7 COMPLETED'
END
GO


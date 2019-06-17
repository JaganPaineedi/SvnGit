------- STEP 1 ----------
IF (((SELECT value FROM SystemConfigurationKeys WHERE [key] = 'CDM_Common')  < 1.2 )or 
Not exists(SELECT 1 FROM SystemConfigurationKeys WHERE [key] = 'CDM_Common'))
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 1.2 for CDM_Common update.Upgrade Script Failed.>>>', 16, 1)
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
	IF COL_LENGTH('CustomClients','WellVisitLast12Months')IS NULL
	BEGIN
		ALTER TABLE  CustomClients ADD WellVisitLast12Months type_YOrN  NULL
								   CHECK (WellVisitLast12Months in ('Y','N'))												
	END
	IF COL_LENGTH('CustomClients','WellVisitLastDate')IS NULL
	BEGIN
		ALTER TABLE  CustomClients ADD WellVisitLastDate DATETIME  NULL						
	END
	
	IF COL_LENGTH('CustomClients','WellVisitReferralDate')IS NULL
	BEGIN
		ALTER TABLE  CustomClients ADD WellVisitReferralDate DATETIME  NULL						
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

IF ((SELECT cast(value as decimal(10,2)) FROM SystemConfigurationKeys WHERE [key] = 'CDM_Common')  = 1.2)
BEGIN
	UPDATE SystemConfigurationKeys SET value ='1.3' WHERE [key] = 'CDM_Common'
	PRINT 'STEP 7 COMPLETED'
END
GO


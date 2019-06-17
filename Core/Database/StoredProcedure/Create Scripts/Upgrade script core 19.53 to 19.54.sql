----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 19.53)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 19.53 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------
-------------------------------------------------------------

------ STEP 3 ------------
-- HealthDataAttributes    

IF OBJECT_ID('HealthDataAttributes ') IS NOT NULL
BEGIN
	IF COL_LENGTH('HealthDataAttributes','EMCalculation') IS NULL
		BEGIN
		ALTER TABLE HealthDataAttributes  ADD EMCalculation  type_YOrN	NULL
										  CHECK (EMCalculation in ('Y','N'))
		 EXEC sys.sp_addextendedproperty 'HealthDataAttributes_Description'
		,'EMCalculation column stores Y and N .If this checkbox is selected it is included in EM Coding Calculation'
		,'schema'
		,'dbo'
		,'table'
		,'HealthDataAttributes'
		,'column'
		,'EMCalculation'
		
		END
	
PRINT 'STEP 3 COMPLETED'

END

	
--END Of STEP 3------------
------ STEP 4 ----------

------END Of STEP 4---------------

------ STEP 5 ----------------

-------END STEP 5-------------
------ STEP 6  ----------

----END Of STEP 6 ------------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 19.53)
BEGIN
Update SystemConfigurations set DataModelVersion=19.54
PRINT 'STEP 7 COMPLETED'
END
Go

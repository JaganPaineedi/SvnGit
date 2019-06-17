----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 18.44)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 18.44 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------
-------------------------------------------------------------

------ STEP 3 ------------
IF OBJECT_ID('EMCodeProcedureCodes') IS NOT NULL
BEGIN

	IF COL_LENGTH('EMCodeProcedureCodes','ScheduledProcedureCodeId')IS   NULL
	BEGIN
		ALTER TABLE EMCodeProcedureCodes   ADD   ScheduledProcedureCodeId  int    NULL
	END
	
	IF COL_LENGTH('EMCodeProcedureCodes','EMCode')IS   NOT NULL and COL_LENGTH('EMCodeProcedureCodes','ProcedureCodeId')IS  NOT NULL
	BEGIN
	IF NOT EXISTS(SELECT * FROM sys.indexes ind WHERE name='EMCodeProcedureCodes_UX' and object_name(object_id)='EMCodeProcedureCodes')
	BEGIN
		 ALTER TABLE EMCodeProcedureCodes ADD Constraint  [EMCodeProcedureCodes_UX] UNIQUE NONCLUSTERED (EMCode,ProcedureCodeId)
	END
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
IF ((select DataModelVersion FROM SystemConfigurations)  = 18.44)
BEGIN
Update SystemConfigurations set DataModelVersion=18.45
PRINT 'STEP 7 COMPLETED'
END
Go

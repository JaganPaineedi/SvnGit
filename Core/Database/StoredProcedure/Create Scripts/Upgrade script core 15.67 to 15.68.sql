----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 15.67)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 15.67 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------

-----End of STEP 2 -------

------ STEP 3 ------------

-- Added Column IsNewGoal in CarePlanGoals Table

IF OBJECT_ID('CarePlanGoals')IS NOT NULL
BEGIN
	IF COL_LENGTH('CarePlanGoals','IsNewGoal')IS NULL
	BEGIN
		ALTER TABLE CarePlanGoals ADD IsNewGoal type_YOrN   NULL
								  CHECK (IsNewGoal in ('Y','N'))
	END
END 

-- Added Column IsNewObjective in CarePlanObjectives Table

IF OBJECT_ID('CarePlanObjectives')IS NOT NULL
BEGIN
	IF COL_LENGTH('CarePlanObjectives','IsNewObjective')IS NULL
	BEGIN
		ALTER TABLE CarePlanObjectives ADD IsNewObjective type_YOrN   NULL
								  CHECK (IsNewObjective in ('Y','N'))
	END
END 

PRINT 'STEP 3 COMPLETED'

-----END Of STEP 3--------------------

------ STEP 4 ------------

----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 15.67)
BEGIN
Update SystemConfigurations set DataModelVersion=15.68
PRINT 'STEP 7 COMPLETED'
END
Go




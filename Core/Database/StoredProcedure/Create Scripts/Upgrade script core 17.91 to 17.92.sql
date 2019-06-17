----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 17.91)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 17.91 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 -----------

-----End of Step 2 -------

------ STEP 3 ------------
-- Added column(s) for CoveragePlans table.

IF OBJECT_ID('CoveragePlans')IS NOT NULL
BEGIN
		IF COL_LENGTH('CoveragePlans','DaysToRetroBill') IS NULL
		BEGIN
			ALTER TABLE CoveragePlans ADD  DaysToRetroBill int NULL
	
		EXEC sys.sp_addextendedproperty 'CoveragePlans_Description'
		,'DaysToRetroBill column store the number of days retro for which charges can be reallocated off of this plan'
		,'schema'
		,'dbo'
		,'table'
		,'CoveragePlans'
		,'column'
		,'DaysToRetroBill'
		
		END
		
		IF COL_LENGTH('CoveragePlans','ReallocationStartDate') IS NULL
		BEGIN
			ALTER TABLE CoveragePlans ADD  ReallocationStartDate datetime NULL
	
		EXEC sys.sp_addextendedproperty 'CoveragePlans_Description'
		,'ReallocationStartDate column Stores Reallocation start date'
		,'schema'
		,'dbo'
		,'table'
		,'CoveragePlans'
		,'column'
		,'ReallocationStartDate'
		
		END
		
		IF COL_LENGTH('CoveragePlans','ReallocationEndDate') IS NULL
		BEGIN
			ALTER TABLE CoveragePlans ADD  ReallocationEndDate datetime NULL
	
		EXEC sys.sp_addextendedproperty 'CoveragePlans_Description'
		,'ReallocationEndDate column stores reallocation end date'
		,'schema'
		,'dbo'
		,'table'
		,'CoveragePlans'
		,'column'
		,'ReallocationEndDate'
		
		END
		
 PRINT 'STEP 3 COMPLETED'
END

-----END Of STEP 3---------

------ STEP 4 ------------

----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 17.91)
BEGIN
Update SystemConfigurations set DataModelVersion=17.92
PRINT 'STEP 7 COMPLETED'
END
Go



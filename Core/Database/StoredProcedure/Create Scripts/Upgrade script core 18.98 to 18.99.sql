----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 18.98)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 18.98 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------

-----End of Step 2 -------

------ STEP 3 ------------
IF OBJECT_ID('CoveragePlanRuleVariables') IS NOT NULL
BEGIN
	IF COL_LENGTH('CoveragePlanRuleVariables','AppliesToAllPrograms')IS  NULL
	 BEGIN
		ALTER TABLE CoveragePlanRuleVariables ADD AppliesToAllPrograms type_YOrN	 NULL
											  CHECK(AppliesToAllPrograms in('Y','N'))
	END
	
	IF COL_LENGTH('CoveragePlanRuleVariables','ProgramId')IS  NULL
	 BEGIN
		ALTER TABLE CoveragePlanRuleVariables ADD ProgramId int	NULL
	END
	
	IF COL_LENGTH('CoveragePlanRuleVariables','ProgramId')IS NOT NULL
	 BEGIN
			IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Programs_CoveragePlanRuleVariables_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[CoveragePlanRuleVariables]'))
			BEGIN
				ALTER TABLE CoveragePlanRuleVariables ADD CONSTRAINT Programs_CoveragePlanRuleVariables_FK
				FOREIGN KEY (ProgramId)
				REFERENCES Programs(ProgramId) 
			END
	  END
	  
	  IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('CoveragePlanRuleVariables') AND name='XIE4_CoveragePlanRuleVariables')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE4_CoveragePlanRuleVariables] ON [dbo].[CoveragePlanRuleVariables] 
		(
		ProgramId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CoveragePlanRuleVariables') AND name='XIE4_CoveragePlanRuleVariables')
		PRINT '<<< CREATED INDEX CoveragePlanRuleVariables.XIE4_CoveragePlanRuleVariables >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX CoveragePlanRuleVariables.XIE4_CoveragePlanRuleVariables >>>', 16, 1)		
		END	
	
	 
	
	PRINT 'STEP 3 COMPLETED'
	
END
------ STEP 4 ---------------
 

----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 18.98)
BEGIN
Update SystemConfigurations set DataModelVersion=18.99
PRINT 'STEP 7 COMPLETED'
END
Go


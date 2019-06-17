----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 15.42)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 15.42 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END

------ STEP 2 ----------
--Part1 Begin


--Part1 Ends

--Part2 Begins

--Part2 Ends	

-----End of Step 2 -------

 

------ STEP 3 ------------

IF OBJECT_ID('CoveragePlanRuleVariables') IS NOT NULL
BEGIN
			
	IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CoveragePlanRuleVariables]') AND name = N'ix_CoveragePlanRuleVariables_ProcedureCodeId_CoveragePlanRuleId')
	BEGIN
		DROP INDEX [ix_CoveragePlanRuleVariables_ProcedureCodeId_CoveragePlanRuleId] ON [dbo].[CoveragePlanRuleVariables] 
	END	
	
	IF  NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CoveragePlanRuleVariables]') AND name = N'IX_CoveragePlanRuleVariables_Compound_NC2013'  or name = N'IX_CoveragePlanRuleVariables_ProcedurecodeId_NC2014') 
	BEGIN
	
		IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CoveragePlanRuleVariables]') AND name = N'XIE2_CoveragePlanRuleVariables')
		BEGIN
			CREATE NONCLUSTERED INDEX [XIE2_CoveragePlanRuleVariables] ON [dbo].[CoveragePlanRuleVariables] 
			(
			[ProcedureCodeId] ASC
			)
			INCLUDE ([CoveragePlanRuleId])
			WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
			IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CoveragePlanRuleVariables') AND name='XIE2_CoveragePlanRuleVariables')
			PRINT '<<< CREATED INDEX CoveragePlanRuleVariables.XIE2_CoveragePlanRuleVariables >>>'
			ELSE
			RAISERROR('<<< FAILED CREATING INDEX CoveragePlanRuleVariables.XIE2_CoveragePlanRuleVariables >>>', 16, 1)		
		END		
	END
PRINT 'STEP 3 COMPLETED'
END
GO


-----END Of STEP 3--------------------

------ STEP 4 ------------


----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------
------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 15.42)
BEGIN
Update SystemConfigurations set DataModelVersion=15.43
PRINT 'STEP 7 COMPLETED'
END
Go
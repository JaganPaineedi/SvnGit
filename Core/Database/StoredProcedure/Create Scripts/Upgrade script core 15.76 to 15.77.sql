----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 15.76)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 15.76 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------
--Part1 Begin

--Part1 Ends

--Part2 Begins

--Part2 Ends	

-----End of Step 2 -------

-------- STEP 3 ------------
--IF OBJECT_ID('Adjudications')IS NOT NULL
--BEGIN
--	IF COL_LENGTH('Adjudications','BundleAdjudicationId')IS  NULL
--	BEGIN
--		ALTER TABLE Adjudications ADD  BundleAdjudicationId INT  NULL
--	END
--	IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Adjudications_Adjudications_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[Adjudications]'))	
--	BEGIN
--		ALTER TABLE Adjudications ADD CONSTRAINT Adjudications_Adjudications_FK
--		FOREIGN KEY (BundleAdjudicationId)
--		REFERENCES Adjudications(AdjudicationId)	 
--	END 
	

--	IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('Adjudications') AND name='XIE5_Adjudications')
--	BEGIN
--		CREATE NONCLUSTERED INDEX [XIE5_Adjudications] ON [dbo].[Adjudications] 
--		(
--		[BundleAdjudicationId] ASC
--		)
--		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
--		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('Adjudications') AND name='XIE5_Adjudications')
--		PRINT '<<< CREATED INDEX Adjudications.XIE5_Adjudications >>>'
--		ELSE
--		RAISERROR('<<< FAILED CREATING INDEX Adjudications.XIE5_Adjudications >>>', 16, 1)		
--	END			

--	PRINT 'STEP 3 COMPLETED'
--END 

---- insert script for core global codes (2549,2550) & AdjudicationRules for task Network 180 - Claims Bundle - Task #608.1
--set identity_insert GlobalCodes on

--if not exists ( select  *
--                from    GlobalCodes
--                where   GlobalCodeId = 2549 ) 
--  begin
    
--    insert  into GlobalCodes
--            (GlobalCodeId,
--             Category,
--             CodeName,
--             Active,
--             CannotModifyNameOrDelete)
--    values  (2549,
--             'DENIALREASON',
--             'Activity claim line cannot be adjudicated without an associated bundle claim line',
--             'Y',
--             'N')
  
    
--  end

--if not exists ( select  *
--                from    GlobalCodes
--                where   GlobalCodeId = 2550 ) 
--  begin
    
--    insert  into GlobalCodes
--            (GlobalCodeId,
--             Category,
--             CodeName,
--             Active,
--             CannotModifyNameOrDelete)
--    values  (2550,
--             'DENIALREASON',
--             'Bundle claim line does not have the correct associated claim lines to bill',
--             'Y',
--             'N')
  
    
--  end

--set identity_insert GlobalCodes off

--insert  into AdjudicationRules
--        (RuleTypeId,
--         RuleName,
--         SystemRequiredRule,
--         Active,
--         ClaimLineStatusIfBroken,
--         MarkClaimLineToBeWorked,
--         ToBeWorkedDays,
--         AllInsurers)
--        select  gc.GlobalCodeId,
--                gc.CodeName,
--                'Y',
--                'Y',
--                'P',
--                'N',
--                30,
--                'Y'
--        from    GlobalCodes gc
--        where   gc.GlobalCodeId in (2549, 2550)
--                and not exists ( select *
--                                 from   dbo.AdjudicationRules ar
--                                 where  ar.RuleTypeId = gc.GlobalCodeId
--                                        and isnull(ar.RecordDeleted, 'N') = 'N' ) 


-------END Of STEP 3--------------------

-------- STEP 4 ------------

------END Of STEP 4------------

-------- STEP 5 ----------------

---------END STEP 5-------------

-------- STEP 6  ----------

-------- STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 15.76)
BEGIN
Update SystemConfigurations set DataModelVersion=15.77
PRINT 'STEP 7 COMPLETED'
END
Go




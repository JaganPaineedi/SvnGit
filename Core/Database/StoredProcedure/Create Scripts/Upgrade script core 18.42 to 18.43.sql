----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 18.42)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 18.42 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------
-------------------------------------------------------------

------ STEP 3 ------------
IF OBJECT_ID('ClaimLines') IS NOT NULL
BEGIN

	IF COL_LENGTH('ClaimLines','LastAdjudicationId')IS   NULL
	BEGIN
		ALTER TABLE ClaimLines   ADD   LastAdjudicationId  int    NULL
	END
	
	IF COL_LENGTH('ClaimLines','LastAdjudicationDate')IS   NULL
	BEGIN
		ALTER TABLE ClaimLines   ADD   LastAdjudicationDate  datetime    NULL
	END
	

	IF COL_LENGTH('ClaimLines','LastAdjudicationId')IS NOT NULL
	 BEGIN
			IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Adjudications_ClaimLines_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[ClaimLines]'))
			BEGIN
				ALTER TABLE ClaimLines ADD CONSTRAINT Adjudications_ClaimLines_FK
				FOREIGN KEY (LastAdjudicationId)
				REFERENCES Adjudications(AdjudicationId) 
			END
	  END
	  
	 
	  IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('ClaimLines') AND name='XIE8_ClaimLines')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE8_ClaimLines] ON [dbo].[ClaimLines] 
		(
		LastAdjudicationId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('ClaimLines') AND name='XIE8_ClaimLines')
		PRINT '<<< CREATED INDEX ClaimLines.XIE8_ClaimLines >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX ClaimLines.XIE8_ClaimLines >>>', 16, 1)		
		END	 
	
	PRINT 'STEP 3 COMPLETED'	
END
Go

;
with  CTE_Adjudication
        as (select  clh.ClaimLineId,
                    clh.AdjudicationId,
                    clh.ActivityDate,
                    row_number() over (partition by clh.ClaimLineId order by clh.ActivityDate desc) as Ranking
            from    ClaimLineHistory clh
            where   clh.AdjudicationId is not null
                    and isnull(clh.RecordDeleted, 'N') = 'N')
  update  cl
  set     LastAdjudicationId = a.AdjudicationId,
          LastAdjudicationDate = a.ActivityDate
  from    ClaimLines cl
          join CTE_Adjudication a on a.ClaimLineId = cl.ClaimLineId
                                     and a.Ranking = 1

Go
--END Of STEP 3------------
------ STEP 4 ----------

------END Of STEP 4---------------

------ STEP 5 ----------------

-------END STEP 5-------------
------ STEP 6  ----------

----END Of STEP 6 ------------

------ STEP 7 -----------
IF ((select DataModelVersion FROM SystemConfigurations)  = 18.42)
BEGIN
Update SystemConfigurations set DataModelVersion=18.43
PRINT 'STEP 7 COMPLETED'
END
Go

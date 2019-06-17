----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 19.69)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 19.69 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------
--Part1 Begin
--Part1 Ends

--Part2 Begins


--Part2 Ends
-----End of Step 2 -------

------ STEP 3 ------------
-------Add Column in CourseSchedules Table 

IF OBJECT_ID('CourseSchedules') IS NOT NULL
BEGIN
		IF COL_LENGTH('CourseSchedules','ProgramId') IS NULL
		BEGIN
			ALTER TABLE CourseSchedules ADD ProgramId   int	 NULL									
		END
		
		IF COL_LENGTH('CourseSchedules','ProgramId')IS NOT NULL
		BEGIN
			IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Programs_CourseSchedules_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[CourseSchedules]'))
			BEGIN
		
				ALTER TABLE CourseSchedules ADD CONSTRAINT Programs_CourseSchedules_FK
				FOREIGN KEY (ProgramId)
				REFERENCES Programs(ProgramId) 
			END
		END
	  
	 
	  IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('CourseSchedules') AND name='XIE3_CourseSchedules')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE3_CourseSchedules] ON [dbo].[CourseSchedules] 
		(
		ProgramId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CourseSchedules') AND name='XIE3_CourseSchedules')
		PRINT '<<< CREATED INDEX CourseSchedules.XIE3_CourseSchedules >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX CourseSchedules.XIE3_CourseSchedules >>>', 16, 1)		
		END
	
PRINT 'STEP 3 COMPLETED'

END

------ END OF STEP 3 -----

------ STEP 4 ----------

---------------------------------------------------------------
--END Of STEP 4

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------
------ STEP 7 -----------
IF ((select DataModelVersion FROM SystemConfigurations)  = 19.69)
BEGIN
Update SystemConfigurations set DataModelVersion=19.70
PRINT 'STEP 7 COMPLETED'
END
Go
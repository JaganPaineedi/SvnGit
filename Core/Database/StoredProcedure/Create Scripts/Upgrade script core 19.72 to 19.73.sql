----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 19.72)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 19.72 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------
--Part1 Begin
--Part1 Ends

--Part2 Begins


--Part2 Ends
-----End of Step 2 -------

------ STEP 3 ------------

IF OBJECT_ID('Clientorders') IS NOT NULL
BEGIN

  IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('Clientorders') AND name='XIE5_Clientorders')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE5_Clientorders] ON [dbo].[Clientorders] 
		(
		DocumentVersionId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('Clientorders') AND name='XIE5_Clientorders')
		PRINT '<<< CREATED INDEX Clientorders.XIE5_Clientorders >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX Clientorders.XIE5_Clientorders >>>', 16, 1)		
		END
	PRINT 'STEP 3 COMPLETED'	
END
------ END OF STEP 3 -----

------ STEP 4 ----------

--END Of STEP 4

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------
------ STEP 7 -----------
IF ((select DataModelVersion FROM SystemConfigurations)  = 19.72)
BEGIN
Update SystemConfigurations set DataModelVersion=19.73
PRINT 'STEP 7 COMPLETED'
END
Go
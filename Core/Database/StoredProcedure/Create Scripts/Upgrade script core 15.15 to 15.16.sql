----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 15.15)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 15.15 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END

------ STEP 2 ----------
--Part1 Begin


--Part1 Ends

--Part2 Begins

--Part2 Ends	

-----End of Step 2 -------

 

------ STEP 3 ------------

IF OBJECT_ID('ERClaimLineItemLog') IS NOT NULL
BEGIN
	IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('ERClaimLineItemLog') AND name='XIE2_ERClaimLineItemLog')
	BEGIN
		CREATE NONCLUSTERED INDEX [XIE2_ERClaimLineItemLog] ON [dbo].[ERClaimLineItemLog] 
		(
		[ERMessageType] ASC
		)
		INCLUDE ([ERClaimLineItemId])
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('ERClaimLineItemLog') AND name='XIE2_ERClaimLineItemLog')
		PRINT '<<< CREATED INDEX ERClaimLineItemLog.XIE2_ERClaimLineItemLog >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX ERClaimLineItemLog.XIE2_ERClaimLineItemLog >>>', 16, 1)		
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

IF ((select DataModelVersion FROM SystemConfigurations)  = 15.15)
BEGIN
Update SystemConfigurations set DataModelVersion=15.16
PRINT 'STEP 7 COMPLETED'
END
Go
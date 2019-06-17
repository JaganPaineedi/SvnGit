----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 16.27)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 16.27 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ------------

-----End of Step 2 -------

------ STEP 3 ------------

-----END Of STEP 3--------

------ STEP 4 ---------------

--Added column(s) in Refunds Table.
IF OBJECT_ID('Refunds') IS NOT NULL
BEGIN
	IF COL_LENGTH('Refunds','RefundAdjustmentTo') IS NULL
	BEGIN
		 ALTER TABLE Refunds ADD RefundAdjustmentTo varchar(250) NULL
	END
	
	IF COL_LENGTH('Refunds','RefundAdjustmentAddress') IS NULL
	BEGIN
		 ALTER TABLE Refunds ADD RefundAdjustmentAddress varchar(250) NULL
	END
	
	IF COL_LENGTH('Refunds','RefundSent') IS NULL
	BEGIN
		 ALTER TABLE Refunds ADD RefundSent type_YOrN	 NULL
							 CHECK (RefundSent in ('Y','N'))
	END
	
	IF COL_LENGTH('Refunds','RefundsAdjustment') IS NULL
	BEGIN
		ALTER TABLE Refunds ADD RefundsAdjustment char(1)  NULL
							CHECK (RefundsAdjustment in ('R','A'))
        
	  EXEC sys.sp_addextendedproperty 'Refunds_Description'
	   ,'RefundsAdjustment  columns stores R,A. R- Refund, A- Adjustment'
	   ,'schema'
	   ,'dbo'
	   ,'table'
	   ,'Refunds'
	   ,'column'
	   ,'RefundsAdjustment'   
	   
	  
	END
	
	PRINT 'STEP 3 COMPLETED'
END
go

IF OBJECT_ID('Refunds') IS NOT NULL
BEGIN
IF COL_LENGTH('Refunds','RefundsAdjustment') IS NOT NULL
	BEGIN
	 UPDATE  Refunds SET RefundsAdjustment='R' WHERE RefundsAdjustment IS NULL
	END
END

----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 16.27)
BEGIN
Update SystemConfigurations set DataModelVersion=16.28
PRINT 'STEP 7 COMPLETED'
END
Go




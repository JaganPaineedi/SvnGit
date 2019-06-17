----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 15.48)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 15.48 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END

------ STEP 2 ----------
--Part1 Begin

--Part1 Ends

--Part2 Begins

--Part2 Ends	

-----End of Step 2 -------

------ STEP 3 ------------

IF OBJECT_ID('ImageRecords') IS NOT NULL
BEGIN
	IF COL_LENGTH('ImageRecords','PaymentId') IS  NULL
		BEGIN
		 ALTER TABLE ImageRecords ADD  PaymentId  INT	NULL
		END
			
	IF COL_LENGTH('ImageRecords','PaymentId')IS  NOT NULL
		BEGIN
			IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Payments_ImageRecords_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[ImageRecords]'))	
			BEGIN
				ALTER TABLE ImageRecords ADD CONSTRAINT Payments_ImageRecords_FK
				FOREIGN KEY (PaymentId)
				REFERENCES Payments(PaymentId)	 
			END 
		END
			
	PRINT 'STEP 3 COMPLETED'
END
-----END Of STEP 3--------------------

------ STEP 4 ------------

----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 15.48)
BEGIN
Update SystemConfigurations set DataModelVersion=15.49
PRINT 'STEP 7 COMPLETED'
END
Go
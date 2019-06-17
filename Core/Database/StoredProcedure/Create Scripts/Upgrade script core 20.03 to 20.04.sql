----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 20.03)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 20.03 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END

------ STEP 2 ----------

-----End of Step 2 -------

------ STEP 3 ------------

----Add New Columns in ERSenders Table 	
IF OBJECT_ID('ERSenders') IS NOT NULL
BEGIN
		IF COL_LENGTH('ERSenders','PostOutOfBalanceBatches')IS NULL
		BEGIN
		 ALTER TABLE ERSenders ADD  PostOutOfBalanceBatches type_YOrN	DEFAULT ('N')	NULL
									CHECK (PostOutOfBalanceBatches in ('Y','N'))
				
	EXEC sys.sp_addextendedproperty 'ERSenders_Description'
		,'If an 835 contains a batch that does not balance and "PostOutOfBalanceBatches" column is "N" nothing from the 835 file will post.'
		,'schema'
		,'dbo'
		,'table'
		,'ERSenders'
		,'column'
		,'PostOutOfBalanceBatches' 
	END																					 
	PRINT 'STEP 3 COMPLETED'
END

------ END Of STEP 3 ------------

------ STEP 4 ---------------

 ----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------
IF ((select DataModelVersion FROM SystemConfigurations)  = 20.03)
BEGIN
Update SystemConfigurations set DataModelVersion=20.04
PRINT 'STEP 7 COMPLETED'
END

Go

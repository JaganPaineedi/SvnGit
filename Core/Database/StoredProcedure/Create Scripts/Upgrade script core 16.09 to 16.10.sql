----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 16.09)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 16.09 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 -----------

-----End of Step 2 -------

------ STEP 3 ------------

IF OBJECT_ID('CoveragePlans') IS NOT NULL
BEGIN
	 IF COL_LENGTH('CoveragePlans','Adjustment') IS NULL
	 BEGIN
		ALTER TABLE  CoveragePlans  ADD Adjustment CHAR(2)	  NULL
								    CHECK (Adjustment in ('CH','CL'))
										   
	EXEC sys.sp_addextendedproperty 'CoveragePlans_Description'
	,'Adjustment columns stores CH and CL, CH - coverage plan on whether to adjust after charge creation  and CL - coverage plan on whether to adjust after claim creation'
	,'schema'
	,'dbo'
	,'table'
	,'CoveragePlans'
	,'column'
	,'Adjustment'								   
	 END
	 
	 IF COL_LENGTH('CoveragePlans','AllowedAmountAdjustmentCode') IS NULL
	 BEGIN
		ALTER TABLE  CoveragePlans  ADD AllowedAmountAdjustmentCode type_GlobalCode	 NULL
	 END
END

IF OBJECT_ID('ExpectedPayment') IS NOT NULL
BEGIN
	 IF COL_LENGTH('ExpectedPayment','AllowedAmountAdjustmentCode') IS NULL
	 BEGIN
		ALTER TABLE  ExpectedPayment  ADD AllowedAmountAdjustmentCode type_GlobalCode	 NULL
	 END
END
PRINT 'STEP 3 COMPLETED'

-----END Of STEP 3---------

------ STEP 4 ------------

----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 16.09)
BEGIN
Update SystemConfigurations set DataModelVersion=16.10
PRINT 'STEP 7 COMPLETED'
END
Go



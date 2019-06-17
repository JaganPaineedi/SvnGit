----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 15.93)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 15.93 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------

-----End of Step 2 -------

------ STEP 3 --------------

/* Added LeaveProcedureCodeId Column in ClientInpatientVisits table */

IF OBJECT_ID('ClientInpatientVisits')  IS NOT NULL
BEGIN
		
	IF COL_LENGTH('ClientInpatientVisits','LeaveProcedureCodeId') IS NULL
	BEGIN
		 ALTER TABLE ClientInpatientVisits ADD LeaveProcedureCodeId INT NULL
		 
	EXEC sys.sp_addextendedproperty 'ClientInpatientVisits_Description'
	,'LeaveProcedureCodeId stores ProcedureCodeId If Client is On Leave'
	,'schema'
	,'dbo'
	,'table'
	,'ClientInpatientVisits'
	,'column'
	,'LeaveProcedureCodeId'
	
	END
	
	IF COL_LENGTH('ClientInpatientVisits','BedProcedureCodeId') IS NULL
	BEGIN
		ALTER TABLE ClientInpatientVisits ADD BedProcedureCodeId  INT NULL
	 
	 EXEC sys.sp_addextendedproperty 'ClientInpatientVisits_Description'
	,'BedProcedureCodeId stores ProcedureCodeId (BillingProcedureCodeId) If Client BedAssignments Status is Occupied'
	,'schema'
	,'dbo'
	,'table'
	,'ClientInpatientVisits'
	,'column'
	,'BedProcedureCodeId'
	END

	IF COL_LENGTH('ClientInpatientVisits','LeaveProcedureCodeId')IS NOT NULL
		BEGIN
			IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[ProcedureCodes_ClientInpatientVisits_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[ClientInpatientVisits]'))
			BEGIN
			ALTER TABLE ClientInpatientVisits ADD CONSTRAINT ProcedureCodes_ClientInpatientVisits_FK 
				FOREIGN KEY (LeaveProcedureCodeId)
				REFERENCES ProcedureCodes(ProcedureCodeId) 
			END
		END
		
	IF COL_LENGTH('ClientInpatientVisits','BedProcedureCodeId')IS NOT NULL
		BEGIN
			IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[ProcedureCodes_ClientInpatientVisits_FK2]') AND parent_object_id = OBJECT_ID(N'[dbo].[ClientInpatientVisits]'))
			BEGIN
			ALTER TABLE ClientInpatientVisits ADD CONSTRAINT ProcedureCodes_ClientInpatientVisits_FK2 
				FOREIGN KEY (BedProcedureCodeId)
				REFERENCES ProcedureCodes(ProcedureCodeId) 
			END
		END
		
		
	PRINT 'STEP 3 COMPLETED'
END
		
------ END OF STEP 3 -------

------ STEP 4 ---------------
  
 ------END Of STEP 4----------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 15.93)
BEGIN
Update SystemConfigurations set DataModelVersion=15.94
PRINT 'STEP 7 COMPLETED'
END
Go

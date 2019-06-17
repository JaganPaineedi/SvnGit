----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 18.34)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 18.34 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------

-----End of Step 2 -------

------ STEP 3 ------------

IF OBJECT_ID('TransitionOfCareDocuments') IS NOT NULL
BEGIN

	IF COL_LENGTH('TransitionOfCareDocuments','FromDate')IS   NULL
	BEGIN
		ALTER TABLE TransitionOfCareDocuments   ADD   FromDate  datetime    NULL
	END
	
	IF COL_LENGTH('TransitionOfCareDocuments','ToDate')IS   NULL
	BEGIN
		ALTER TABLE TransitionOfCareDocuments   ADD   ToDate  datetime    NULL
	END
	
	IF COL_LENGTH('TransitionOfCareDocuments','TransitionType')IS   NULL
	BEGIN
		ALTER TABLE TransitionOfCareDocuments   ADD   TransitionType  char(1)    NULL
												CHECK(TransitionType in('O','I','P'))
		EXEC sys.sp_addextendedproperty 'TransitionOfCareDocuments_Description'
		,'MedicationType Column stores O,I,P .O-Outpatient,I-Inpatient,P-Primary Care'
		,'schema'
		,'dbo'
		,'table'
		,'TransitionOfCareDocuments'
		,'column'
		,'TransitionType' 
	END
	
	IF COL_LENGTH('TransitionOfCareDocuments','ConfidentialityCode')IS   NULL
	BEGIN
		ALTER TABLE TransitionOfCareDocuments   ADD   ConfidentialityCode  char(1)    NULL
												CHECK(ConfidentialityCode in('N','R','V'))
		EXEC sys.sp_addextendedproperty 'TransitionOfCareDocuments_Description'
		,'MedicationType Column stores N,R,V .N-Normal,R-restricted,V-very restricted'
		,'schema'
		,'dbo'
		,'table'
		,'TransitionOfCareDocuments'
		,'column'
		,'ConfidentialityCode' 
	END
	
	IF COL_LENGTH('TransitionOfCareDocuments','LocationId') IS NULL
	BEGIN
		 ALTER TABLE TransitionOfCareDocuments ADD LocationId INT  NULL
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
IF ((select DataModelVersion FROM SystemConfigurations)  = 18.34)
BEGIN
Update SystemConfigurations set DataModelVersion=18.35
PRINT 'STEP 7 COMPLETED'
END
Go

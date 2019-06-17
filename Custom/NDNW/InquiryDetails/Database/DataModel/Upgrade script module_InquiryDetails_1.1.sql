----- STEP 1 ----------
IF ((SELECT value FROM SystemConfigurationKeys WHERE [key] = 'CDM_InquiryDetails')  < 1.0 ) or
NOT EXISTS(SELECT 1 FROM SystemConfigurationKeys WHERE [key] = 'CDM_InquiryDetails')
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 1.0 for CDM_InquiryDetails update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
-------- STEP 2 ----------
--Part1 Begin

--Part1 Ends

--Part2 Begins

--Part2 Ends	

-----End of Step 2 -------

------ STEP 3 ------------ 
IF COL_LENGTH('CustomInquiries','Ethnicity')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD Ethnicity type_GlobalCode NULL										
	END
IF COL_LENGTH('CustomInquiries','InterpreterNeeded')IS NULL
	BEGIN 
		ALTER TABLE CustomInquiries ADD InterpreterNeeded type_GlobalCode NULL										
	END

PRINT 'STEP 3 COMPLETED'

-----END Of STEP 3--------------------
------ STEP 4 ------------
----END Of STEP 4------------
------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------
------ STEP 7 -----------

IF ((SELECT cast(value as decimal(10,2)) FROM SystemConfigurationKeys WHERE [key] = 'CDM_InquiryDetails')  = 1.0 )
BEGIN
	UPDATE SystemConfigurationKeys SET value ='1.1' WHERE [key] = 'CDM_InquiryDetails'
	PRINT 'STEP 7 COMPLETED'
END
GO
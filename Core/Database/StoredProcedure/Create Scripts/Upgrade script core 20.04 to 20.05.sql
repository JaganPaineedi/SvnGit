----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 20.04)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 20.04 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END

------ STEP 2 ----------

-----End of Step 2 -------

------ STEP 3 ------------

----Add New Column in ElectronicEligibilityVerificationRequests Table 	
IF OBJECT_ID('ElectronicEligibilityVerificationRequests') IS NOT NULL
BEGIN
		IF COL_LENGTH('ElectronicEligibilityVerificationRequests','UserCode')IS NULL
		BEGIN
		 ALTER TABLE ElectronicEligibilityVerificationRequests ADD  UserCode varchar(30)	NULL
		END																					 
	PRINT 'STEP 3 COMPLETED'
END

------ END Of STEP 3 ------------

------ STEP 4 ---------------

 ----END Of STEP 4------------

------ STEP 5 ----------------
-- Insert script for SystemConfigurationKeys IncludeUserCodeForTheseTCPIPEligibilityConnectors
-- Renaissance - Current Project Tasks #22
IF NOT EXISTS (
		SELECT 1
		FROM SystemConfigurationKeys
		WHERE [Key] = 'IncludeUserCodeForTheseTCPIPEligibilityConnectors'
		)
BEGIN
	INSERT INTO SystemConfigurationKeys (
		CreatedBy
		,CreateDate
		,ModifiedBy
		,ModifiedDate
		,[Key]
		,Value
		,AcceptedValues
		,[Description]
		,AllowEdit
		,Modules
		,Screens
		)
	VALUES (
		SYSTEM_USER
		,CURRENT_TIMESTAMP
		,SYSTEM_USER
		,CURRENT_TIMESTAMP
		,'IncludeUserCodeForTheseTCPIPEligibilityConnectors'
		,'None'
		,'None/Provider Name(s)(comma separated values of ''ProviderName'' column from  ElectronicEligibilityVerificationConfigurations table (especially those Provider Name(s) that use TCP/IP based eligibility connectors)) '
		,'Read Key as ---  "Include UserCode For These TCPIP Eligibility Connectors"  
		  When the value of the key ''IncludeUserCodeForTheseTCPIPEligibilityConnectors'' is set to comma separated values of ''ProviderName'' column from  ElectronicEligibilityVerificationConfigurations table (especially those Provider Name(s) that use TCP/IP based eligibility connectors), then the system includes the ''UserCode'' value in the request sent to clearing house, since TCP/IP connector requires ''UserCode'' for processing.
		  When the value of the key ''IncludeUserCodeForTheseTCPIPEligibilityConnectors'' is set to ''None'', the ''UserCode'' will not be included. And the system does not require UserCode  while sending the request to clearing house(s) or Medicaid who do Not use TCP/IP as their communication protocol. They probably will use HTTP as their communication protocol. 
		  The default value of this key will be set to ''None''. This will ensure that the system will send the electronic eligibility requests to clearing house(s) without ''UserCode'' information, as it functions today (before the introduction of this key).'
		,'Y'
		,'ElectronicEligibility'
		,'Client Plan and Time Spans'
		)
END

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------
IF ((select DataModelVersion FROM SystemConfigurations)  = 20.04)
BEGIN
Update SystemConfigurations set DataModelVersion=20.05
PRINT 'STEP 7 COMPLETED'
END

Go

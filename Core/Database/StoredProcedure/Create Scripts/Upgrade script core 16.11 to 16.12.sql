----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 16.11)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 16.11 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 -----------

-----End of Step 2 -------

------ STEP 3 ------------
-- Added column(s) for WhiteBoard table.

IF OBJECT_ID('WhiteBoard')IS NOT NULL
BEGIN
		IF COL_LENGTH('WhiteBoard','LegalStatus') IS NULL
		BEGIN
			ALTER TABLE WhiteBoard ADD  LegalStatus type_GlobalCode NULL
	
	EXEC sys.sp_addextendedproperty 'WhiteBoard_Description'
	,'user to click in the field and get a popup to choose Voluntary or Involuntary of legal status'
	,'schema'
	,'dbo'
	,'table'
	,'WhiteBoard'
	,'column'
	,'LegalStatus'
	
	END
		
IF COL_LENGTH('WhiteBoard','CompetencyStatus') IS NULL
BEGIN
	ALTER TABLE WhiteBoard ADD  CompetencyStatus type_GlobalCode NULL
				   
		EXEC sys.sp_addextendedproperty 'WhiteBoard_Description'
		,'Competency Status.  Allow users to click in the field to get a pop up to change the status from C (Competent), I (Incompetent), NA (New Admission).  Display only C, I, and NA on the screen'
		,'schema'
		,'dbo'
		,'table'
		,'WhiteBoard'
		,'column'
		,'CompetencyStatus'
	
		END

IF COL_LENGTH('WhiteBoard','PapersToCourt') IS NULL
BEGIN
	ALTER TABLE WhiteBoard ADD  PapersToCourt datetime NULL
			
		EXEC sys.sp_addextendedproperty 'WhiteBoard_Description'
		,'Papers to Court (PTC).need the ability to change the date from the whiteboard'
		,'schema'
		,'dbo'
		,'table'
		,'WhiteBoard'
		,'column'
		,'PapersToCourt'
		
		END
		    PRINT 'STEP 3 COMPLETED'
END

--added SystemConfigurationKey WBLegalStatus

IF NOT EXISTS (
		SELECT 1
		FROM SystemConfigurationKeys
		WHERE [Key] = 'WBLegalStatus'
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
		)
	VALUES (
		SYSTEM_USER
		,CURRENT_TIMESTAMP
		,SYSTEM_USER
		,CURRENT_TIMESTAMP
		,'WBLegalStatus'
		,'N'
		,'Y,N'
		,'Allow the user to choose between the current setup of legal status (orders)in Whiteboard'
		)
END


-----END Of STEP 3---------

------ STEP 4 ------------

----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 16.11)
BEGIN
Update SystemConfigurations set DataModelVersion=16.12
PRINT 'STEP 7 COMPLETED'
END
Go



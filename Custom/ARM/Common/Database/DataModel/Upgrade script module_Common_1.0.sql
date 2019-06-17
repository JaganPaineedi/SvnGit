----- STEP 1 ----------

------ STEP 2 ----------

-----End of Step 2 -------

------ STEP 3 ------------
IF OBJECT_ID('CustomStaff') IS NOT NULL
BEGIN

	IF COL_LENGTH('CustomStaff','BillingDegreePriorToBHRedesign')IS   NULL
	BEGIN
		ALTER TABLE CustomStaff   ADD   BillingDegreePriorToBHRedesign  int    NULL
	
	EXEC sys.sp_addextendedproperty 'CustomStaff_Description'
	,'The billing degree used for services provided during FY2016'
	,'schema'
	,'dbo'
	,'table'
	,'CustomStaff'
	,'column'
	,'BillingDegreePriorToBHRedesign'
		
	END
	
	IF COL_LENGTH('CustomStaff','BillingDegreeAfterBHRedesign')IS   NULL
	BEGIN
		ALTER TABLE CustomStaff   ADD   BillingDegreeAfterBHRedesign  int    NULL
		
	EXEC sys.sp_addextendedproperty 'CustomStaff_Description'
	,'The billing degree used for services provided during FY2017'
	,'schema'
	,'dbo'
	,'table'
	,'CustomStaff'
	,'column'
	,'BillingDegreeAfterBHRedesign'
	END
	
	IF COL_LENGTH('CustomStaff','BillingDegreePriorToBHRedesign')IS NOT NULL
	 BEGIN
			IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[StaffLicenseDegrees_CustomStaff_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[CustomStaff]'))
			BEGIN
				ALTER TABLE CustomStaff ADD CONSTRAINT StaffLicenseDegrees_CustomStaff_FK
				FOREIGN KEY (BillingDegreePriorToBHRedesign)
				REFERENCES StaffLicenseDegrees(StaffLicenseDegreeId) 
			END
	  END
	  
	  IF COL_LENGTH('CustomStaff','BillingDegreeAfterBHRedesign')IS NOT NULL
	 BEGIN
			IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[StaffLicenseDegrees_CustomStaff_FK2]') AND parent_object_id = OBJECT_ID(N'[dbo].[CustomStaff]'))
			BEGIN
				ALTER TABLE CustomStaff ADD CONSTRAINT StaffLicenseDegrees_CustomStaff_FK2
				FOREIGN KEY (BillingDegreeAfterBHRedesign)
				REFERENCES StaffLicenseDegrees(StaffLicenseDegreeId) 
			END
	  END
	  
	  IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('CustomStaff') AND name='XIE1_CustomStaff')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_CustomStaff] ON [dbo].[CustomStaff] 
		(
		BillingDegreePriorToBHRedesign ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CustomStaff') AND name='XIE1_CustomStaff')
		PRINT '<<< CREATED INDEX CustomStaff.XIE1_CustomStaff >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX CustomStaff.XIE1_CustomStaff >>>', 16, 1)		
		END	 
		
	 IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('CustomStaff') AND name='XIE2_CustomStaff')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE2_CustomStaff] ON [dbo].[CustomStaff] 
		(
		BillingDegreeAfterBHRedesign ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CustomStaff') AND name='XIE2_CustomStaff')
		PRINT '<<< CREATED INDEX CustomStaff.XIE2_CustomStaff >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX CustomStaff.XIE2_CustomStaff >>>', 16, 1)		
		END	 
	
	PRINT 'STEP 3 COMPLETED'
END	
	

------ END OF STEP 3 -----

------ STEP 4 ----------

--END Of STEP 4

------ STEP 5 ----------------
-- Insert script for SystemConfigurationKeys XBHRedesignBillingDegreeLogicEffectiveDate  Harbor - Support #797
IF NOT EXISTS (			
		SELECT 1
		FROM SystemConfigurationKeys
		WHERE [Key] = 'XBHRedesignBillingDegreeLogicEffectiveDate'
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
		,'XBHRedesignBillingDegreeLogicEffectiveDate'
		,NULL
		,'Date Values'
		,'Services provided prior to the Configured date will use the Billing Degree Prior To BH Redesign staff custom field field to determine the procedure rate and billing codes. Services provided After the configured date will use the Billing Degree After BH redesign field to determine the rate and billing codes for the service.'
		,'Y'
		,'Common'
		,'Staff Details, Service Detail, Charges/claims'
		)
END



-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------


IF NOT EXISTS (SELECT [key] FROM SystemConfigurationKeys WHERE  [key] = 'CDM_Common')
	BEGIN
		INSERT INTO [dbo].[SystemConfigurationKeys]
				   (CreatedBy
				   ,CreateDate 
				   ,ModifiedBy
				   ,ModifiedDate
				   ,[Key]
				   ,Value
				   )
			 VALUES    
				   ('SHSDBA'
				   ,GETDATE()
				   ,'SHSDBA'
				   ,GETDATE()
				   ,'CDM_Common'
				   ,'1.0'
				   )  

PRINT 'STEP 7 COMPLETED'
END
Go



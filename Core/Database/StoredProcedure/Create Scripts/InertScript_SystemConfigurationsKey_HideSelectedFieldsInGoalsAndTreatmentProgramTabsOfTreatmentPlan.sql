-- Insert script for SystemConfigurationKeys HideSelectedFieldsInGoalsAndTreatmentProgramTabsOfTreatmentPlan
-- task HighPlains - Customizations Project #10003  

IF NOT EXISTS (
		SELECT 1
		FROM SystemConfigurationKeys
		WHERE [Key] = 'HideSelectedFieldsInGoalsAndTreatmentProgramTabsOfTreatmentPlan'
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
		,'HideSelectedFieldsInGoalsAndTreatmentProgramTabsOfTreatmentPlan'
		,'No'
		,'Yes, No'
		,'Read key as -- "Hide Selected Fields In Goals And Treatment Program Tabs Of Treatment Plan"  
		  When the key value is set as "Yes", some of the fields(Staff/Supports/Service Details, Client Actions,Use of Natural Supports)
		  in Goals/Objectives Tab as well as fields(Supports Involvement,Treatment Program Section) in Supports/Treatment Program Tab should
		  be hidden in Treatment Plan RDL.
		  If the Value is set as "No", some of the fields in Goals/Objectives Tab as well as in 
		  Supports/Treatment Program Tab should be displayed in Treatment Plan RDL. This is the current behavior of the system'
		,'Y'
		,'Care Plan(Treatment Plan)'
		,NULL
		)
END

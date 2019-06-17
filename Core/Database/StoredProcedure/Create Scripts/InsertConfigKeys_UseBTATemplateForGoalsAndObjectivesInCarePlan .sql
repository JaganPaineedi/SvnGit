-- Insert script for SystemConfigurationKeys UseBTATemplateForGoalsAndObjectivesInCarePlan     PEP-Customizationns#10188
IF NOT EXISTS (
		SELECT 1
		FROM SystemConfigurationKeys
		WHERE [Key] = 'UseBTATemplateForGoalsAndObjectivesInCarePlan'
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
		,'UseBTATemplateForGoalsAndObjectivesInCarePlan'
		,'No'
		,'Yes/No'
		,'Read Key as --- Use BTA Template For Goals And Objectives In Care Plan 
		When the value of the key  UseBTATemplateForGoalsAndObjectivesInCarePlan is set to ''Yes'', then
			1. In both Goals and/or Objectives pop up, copy the label of Goal or the Objective radio-button into the empty text box upon selection, so that it may be edited before choosing OK.
			2. Remove the {Client First Name} from all goals and objectives
			When the value of the key UseBTATemplateForGoalsAndObjectivesInCarePlan is set to  ''No'', then
			It will behave as per the current existing functionality'
		,'Y'
		,'Care Plan'
		,'Care Plan'
		)
END


-- What: Added a new SystemConfigurationKeys 'ShowAllTypesOfServicesOnReception' to display the Services which are Bed Procedure Code, Medication Procedure on Reception list page
-- Why: Journey - Support Go Live Task #23
IF NOT EXISTS (
		SELECT *
		FROM SystemConfigurationKeys
		WHERE [Key] = 'ShowAllTypesOfServicesOnReception' 
		)
BEGIN
	INSERT INTO SystemConfigurationKeys ([Key], Value,AcceptedValues
		,[Description]
		, ShowKeyForViewingAndEditing, Modules
		,Screens, Comments, SourceTableName, AllowEdit
		)
	VALUES (
		'ShowAllTypesOfServicesOnReception', NULL,'Yes, No, NULL',
		'Show All Types Of Services On Reception. 
		When the value of the key ''ShowAllTypesOfServicesOnReception'' is set to ''No or NULL (Default NULL)'', the system will function as today, i.e., will display only those services which are not set as ''Bed Procedure Codes'', ''Medication Procedure Codes'' and ''Not on Calendar''.
		When the value of the key ''ShowAllTypesOfServicesOnReception'' is set to ''Yes'', then on Reception list page, user will be able to see all the services including those that are of type -- ''Bed Procedure Codes'', ''Medication Procedure Codes.'''
		,'Y'
		,'Reception list page'
		,324
		,NULL
		,NULL
		,'Y'
		)
END
Else
Update SystemConfigurationKeys Set [Description] ='Show All Types Of Services On Reception. 
		When the value of the key ''ShowAllTypesOfServicesOnReception'' is set to ''No or NULL (Default NULL)'', the system will function as today, i.e., will display only those services which are not set as ''Bed Procedure Codes'', ''Medication Procedure Codes'' and ''Not on Calendar''.
		When the value of the key ''ShowAllTypesOfServicesOnReception'' is set to ''Yes'', then on Reception list page, user will be able to see all the services including those that are of type -- ''Bed Procedure Codes'', ''Medication Procedure Codes.'''
		WHERE [Key] = 'ShowAllTypesOfServicesOnReception'
		
Go
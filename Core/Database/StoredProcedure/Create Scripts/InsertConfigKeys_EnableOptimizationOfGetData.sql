-- Insert script for SystemConfigurationKeys EnableOptimizationOfGetData   task EI#507.1
IF NOT EXISTS (
		SELECT 1
		FROM SystemConfigurationKeys
		WHERE [Key] = 'EnableOptimizationOfGetData'
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
		)
	VALUES (
		SYSTEM_USER
		,CURRENT_TIMESTAMP
		,SYSTEM_USER
		,CURRENT_TIMESTAMP
		,'EnableOptimizationOfGetData'
		,'No'
		,'Yes,No'
		,'Reads as --- "Enable Optimization Of GetData" Default Value = No. As the system is behaving today, displaying UnsavedChanges from stored procedure if this key is set to  "No". Yes = Displaying UnsavedChnages in an optimized way by just merging Session objects OriginlXML(initial state of the screen), UnSavedChanges'
		,'Y'
		,'UnsavedChanges'
		)
END
ELSE 
BEGIN

UPDATE SystemConfigurationKeys
SET		 Value='No'
		,AcceptedValues='Yes,No'
		,[Description]=	'Reads as --- "Enable Optimization Of GetData" Default Value = No. As the system is behaving today, displaying UnsavedChanges from stored procedure if this key is set to  "No". Yes = Displaying UnsavedChnages in an optimized way by just merging Session objects OriginlXML(initial state of the screen), UnSavedChanges'
		,ModifiedBy=SYSTEM_USER
		,ModifiedDate=CURRENT_TIMESTAMP	

WHERE [Key] = 'EnableOptimizationOfGetData'

END 




-- Insert script for SystemConfigurationKeys WhiteBoardFirstName  
-- Westbridge-Customizations, #4750 
IF NOT EXISTS (
		SELECT 1
		FROM SystemConfigurationKeys
		WHERE [Key] = 'WhiteBoardFirstName'
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
		,'WhiteBoardFirstName'
		,'FullFirstName'
		,'FullFirstName,FirstInitial,FirstThreeLetter'
		,'Read Key as --- "White Board First Name". When this key WhiteBoardFirstName value is set to FullFirstName then Full first name will be displayed(current behavior).
		   When this key WhiteBoardFirstName value is set to FirstInitial then it will first letter of first name. 
		   When this key WhiteBoardFirstName value is set to FirstThreeLetter then it will first three letter of first name.'
		,'Y'
		,'WhiteBoard'
		)
END



-- Insert script for SystemConfigurationKeys WhiteBoardLastName   
IF NOT EXISTS (
		SELECT 1
		FROM SystemConfigurationKeys
		WHERE [Key] = 'WhiteBoardLastName'
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
		,'WhiteBoardLastName'
		,'FullLastName'
		,'FullLastName,FirstInitial,FirstThreeLetter'
		,'Read Key as --- "White Board Last Name". When this key WhiteBoardLastName value is set to FullLastName then Full Last name will be displayed on whiteboard(current behavior).
		   When this key WhiteBoardLastName value is set to FirstInitial then it will display first letter of last name on whiteboard. 
		   When this key WhiteBoardLastName value is set to FirstThreeLetter then it will first three letter of last name on whiteboard.'
		,'Y'
		,'WhiteBoard'
		)
END


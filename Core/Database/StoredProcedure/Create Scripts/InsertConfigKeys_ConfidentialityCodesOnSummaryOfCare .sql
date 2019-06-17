-- Insert script for SystemConfigurationKeys TextForNormalConfidentialityCodeOnSummaryOfCare     Task:   Meaningful Use Stage 3 - Task#25.4
IF NOT EXISTS (
		SELECT 1
		FROM SystemConfigurationKeys
		WHERE [Key] = 'TextForNormalConfidentialityCodeOnSummaryOfCare'
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
		,'TextForNormalConfidentialityCodeOnSummaryOfCare'
		,'This notice accompanies a disclosure of information concerning a client in alcohol/drug treatment,made to you with the consent of such client.This information has been disclosed to you from records protected by federal confidentiality rules (42 C.F.R. Part 2).The federal rules prohibit you from making any further disclosure of this information unless further disclosure is expressly permitted by the written consent of the person to whom it pertains or as otherwise permitted by 42 C.F.R.Part 2.A general authorization for the release of medical or other information is NOT sufficient for this purpose.The federal rules restrict any use of the information to criminally investigate or prosecute any alcohol or drug abuse patient.'
		,Null
		,'This key will pull the value when Confidentiality code is selected as Normal'
		,'Y'
		,'Meaningful Use Stage 3'
		,'Summary Of Care'
		)
END



-- Insert script for SystemConfigurationKeys TextForRestrictedConfidentialityCodeOnSummaryOfCare   Task:   Meaningful Use Stage 3 - Task#25.4
IF NOT EXISTS (
		SELECT 1
		FROM SystemConfigurationKeys
		WHERE [Key] = 'TextForRestrictedConfidentialityCodeOnSummaryOfCare'
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
		,'TextForRestrictedConfidentialityCodeOnSummaryOfCare'
		,'This notice accompanies a disclosure of information concerning a client in alcohol/drug treatment,made to you with the consent of such client.This information has been disclosed to you from records protected by federal confidentiality rules (42 C.F.R. Part 2).The federal rules prohibit you from making any further disclosure of this information unless further disclosure is expressly permitted by the written consent of the person to whom it pertains or as otherwise permitted by 42 C.F.R.Part 2.A general authorization for the release of medical or other information is NOT sufficient for this purpose.The federal rules restrict any use of the information to criminally investigate or prosecute any alcohol or drug abuse patient.'
		,Null
		,'This key will pull the value when Confidentiality code is selected as Restricted'
		,'Y'
		,'Meaningful Use Stage 3'
		,'Summary Of Care'
		)
END



-- Insert script for SystemConfigurationKeys TextForVeryRestrictedConfidentialityCodeOnSummaryOfCare   Task:   Meaningful Use Stage 3 - Task#25.4
IF NOT EXISTS (
		SELECT 1
		FROM SystemConfigurationKeys
		WHERE [Key] = 'TextForVeryRestrictedConfidentialityCodeOnSummaryOfCare'
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
		,'TextForVeryRestrictedConfidentialityCodeOnSummaryOfCare'
		,'This notice accompanies a disclosure of information concerning a client in alcohol/drug treatment,made to you with the consent of such client.This information has been disclosed to you from records protected by federal confidentiality rules (42 C.F.R. Part 2).The federal rules prohibit you from making any further disclosure of this information unless further disclosure is expressly permitted by the written consent of the person to whom it pertains or as otherwise permitted by 42 C.F.R.Part 2.A general authorization for the release of medical or other information is NOT sufficient for this purpose.The federal rules restrict any use of the information to criminally investigate or prosecute any alcohol or drug abuse patient.'
		,Null
		,'This key will pull the value when Confidentiality code is selected as VeryRestricted'
		,'Y'
		,'Meaningful Use Stage 3'
		,'Summary Of Care'
		)
END




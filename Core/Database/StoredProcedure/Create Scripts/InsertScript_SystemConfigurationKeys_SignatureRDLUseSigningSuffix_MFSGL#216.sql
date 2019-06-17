

-- Task: MFS - Support Go Live #216
-- Date: 02/06/2018

IF NOT EXISTS (
		SELECT 1
		FROM SystemConfigurationKeys
		WHERE [Key] = 'ShowSigningSuffixORBillingDegreeInSignatureRDL'
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
		,ShowKeyForViewingAndEditing
		,Modules
		,Screens
		,AllowEdit
		)
	VALUES (
		SYSTEM_USER
		,CURRENT_TIMESTAMP
		,SYSTEM_USER
		,CURRENT_TIMESTAMP
		,'ShowSigningSuffixORBillingDegreeInSignatureRDL'
		,'BillingDegree'
		,'BillingDegree,SigningSuffix'
		,'With current core behavior, staff info accompanying signatures are printed as "FirstName LastName, BillingDegree". Propose adding a SystemConfigurationKey named "ShowSigningSuffixORBillingDegreeInSignatureRDL". Changed SSP_RDLSubReportSignatureImages to look for this key. If it exists and it is set to "SigningSuffix", then system will render the staff info as "FirstName LastName, SigningSuffix". If value is set as "BillingDegree" then system will render the staff info as "FirstName LastName, BillingDegree" which is the current core behavior.'
		,'Y'
		,'All Core Documents and Service Notes'
		,'All Core Documents and Service Notes'
		,'Y'
		)
END
GO
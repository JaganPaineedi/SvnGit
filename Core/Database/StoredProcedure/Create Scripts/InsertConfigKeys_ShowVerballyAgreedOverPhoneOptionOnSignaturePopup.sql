-- Insert script for SystemConfigurationKeys ShowVerballyAgreedOverPhoneOptionOnSignaturePopup       PEP - Customizations #10212
IF NOT EXISTS (
		SELECT 1
		FROM SystemConfigurationKeys
		WHERE [Key] = 'ShowVerballyAgreedOverPhoneOptionOnSignaturePopup'
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
		,'ShowVerballyAgreedOverPhoneOptionOnSignaturePopup'
		,'No'
		,'Yes/No'
		,'Read Key as  " Show Verbally Agreed Over Phone Option On Signature Popup".  
		  When the key value is set to “Yes”, a new radio button selection-option called ''Verbally Agreed Over Phone'' will appear on the signature Popup. The user will be able to sign document or note after selecting this option.
		  When the key value is set to "No", this option will not be visible on the signature popup.'
		,'Y'
		,'Core signature popup'
		,'Service Note'
		)
END


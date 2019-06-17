--Added by Neha as part of MHP Enhancements #107.

IF NOT EXISTS (
		SELECT 1
		FROM SystemConfigurationKeys
		WHERE [Key] = 'SaveAndDisplayDocumentEffectiveDateWithTime'
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
		,'SaveAndDisplayDocumentEffectiveDateWithTime'
		,'No'
		,'Yes,No'
		,'Read Key as ---"Save And Display Document Effective Date With Time". 
		 When this key, SaveAndDisplayDocumentEffectiveDateWithTime value is set to Yes, it saves the Effective date with time in the documents table. Also, displays the Effective date along with time in Documents list page and My Documents list page.
		 If the value is set to No, it saves the Document Effective Date only without time (current behavior).'
		,'Y'
		,'My documents, Documents'
		,'My documents, Documents'
		)
END




INSERT	INTO dbo.SystemConfigurationKeys
		( CreatedBy
		, CreateDate
		, ModifiedBy
		, ModifiedDate
		, [Key]
		, Value
		, Description
		, AcceptedValues
		, ShowKeyForViewingAndEditing
		, Modules
		, Screens
		, Comments
		)
		SELECT	'dknewtson'  -- CreatedBy - type_CurrentUser
			  , GETDATE()-- CreateDate - type_CurrentDatetime		
			  , 'dknewtson'-- ModifiedBy - type_CurrentUser
			  , GETDATE()-- ModifiedDate - type_CurrentDatetime
			  , 'ALLOWSERVICEERRORWITHPAYMENT'-- Key - varchar(200)
			  , 'N'-- Value - varchar(max)
			  , 'Allow services with payments to be errored'-- Description - type_Comment2
			  , 'Y,N'-- AcceptedValues - varchar(max)
			  , 'Y'-- ShowKeyForViewingAndEditing - type_YOrN
			  , 'ServiceDetail,ServiceNotes'-- Modules - varchar(500)
			  , 'Service Detail, Service Notes'-- Screens - varchar(500)
			  , 'Payments on the service will not be reversed when the service is errored'-- Comments - type_Comment2
		WHERE	NOT EXISTS ( SELECT	1
							 FROM	dbo.SystemConfigurationKeys AS sck
							 WHERE	sck.[Key] = 'ALLOWSERVICEERRORWITHPAYMENT' )
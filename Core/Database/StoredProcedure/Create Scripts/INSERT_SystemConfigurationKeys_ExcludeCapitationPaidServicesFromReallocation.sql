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
			  , 'ExcludeCapitationPaidServicesFromReallocation' -- Key - varchar(200)
			  , 'N'-- Value - varchar(max)
			  , 'Causes services with capitated payments to be excluded when reallocating'-- Description - type_Comment2
			  , 'Y,N'-- AcceptedValues - varchar(max)
			  , 'Y'-- ShowKeyForViewingAndEditing - type_YOrN
			  , 'Reallocation'-- Modules - varchar(500)
			  , NULL-- Screens - varchar(500)
			  , 'Default is N. May cause capitated checks to be temporarily out of balance.'-- Comments - type_Comment2
		WHERE	NOT EXISTS ( SELECT	1
							 FROM	dbo.SystemConfigurationKeys AS sck
							 WHERE	sck.[Key] = 'ExcludeCapitationPaidServicesFromReallocation' )


							 

		


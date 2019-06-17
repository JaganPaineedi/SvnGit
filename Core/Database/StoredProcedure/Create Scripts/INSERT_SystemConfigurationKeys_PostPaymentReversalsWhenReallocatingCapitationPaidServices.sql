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
			  , 'PostPaymentReversalsWhenReallocatingCapitationPaidServices' -- Key - varchar(200)
			  , 'Y'-- Value - varchar(max)
			  , 'Posts reversals for capitated payments when reallocating capitated charges'-- Description - type_Comment2
			  , 'Y,N'-- AcceptedValues - varchar(max)
			  , 'Y'-- ShowKeyForViewingAndEditing - type_YOrN
			  , 'Reallocation'-- Modules - varchar(500)
			  , NULL-- Screens - varchar(500)
			  , 'Default is Y. May cause capitated payments to be temporarily out of balance.'-- Comments - type_Comment2
		WHERE	NOT EXISTS ( SELECT	1
							 FROM	dbo.SystemConfigurationKeys AS sck
							 WHERE	sck.[Key] = 'PostPaymentReversalsWhenReallocatingCapitationPaidServices' )
		

		
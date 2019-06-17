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
			  , 'RecalculateChargePriorityWhenPostingToARLedger' -- Key - varchar(200)
			  , 'N'-- Value - varchar(max)
			  , 'Whenever changes are made to the ledger for a service (payment posting, corrections, adjustments/transfers) the system will automatically recalculate the Charge Priority for billing purposes based on the client''s coverage and the following rule:

If the client no longer has coverage, move the charge to the bottom of the priority list.
If the client does have coverage but the charge has a charge error that causes cascade the system will move the charge to the end of the priority list.
Otherwise as the COB order on the client''s coverage history.'-- Description - type_Comment2
			  , 'Y,N'-- AcceptedValues - varchar(max)
			  , 'Y'-- ShowKeyForViewingAndEditing - type_YOrN
			  , 'PaymentPosting'-- Modules - varchar(500)
			  , NULL-- Screens - varchar(500)
			  , 'Default is N.'-- Comments - type_Comment2
		WHERE	NOT EXISTS ( SELECT	1
							 FROM	dbo.SystemConfigurationKeys AS sck
							 WHERE	sck.[Key] = 'RecalculateChargePriorityWhenPostingToARLedger' )


							 

		


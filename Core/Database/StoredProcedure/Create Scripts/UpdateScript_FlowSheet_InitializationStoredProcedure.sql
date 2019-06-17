UPDATE Screens
SET InitializationStoredProcedure = 'ssp_InitNewEntryFlowSheet'
WHERE ScreenId = 716

IF NOT EXISTS (
		SELECT 1
		FROM ScreenPermissionControls
		WHERE ScreenId = 716
			AND ControlName = 'ButtonLock'
		)

BEGIN
	INSERT [dbo].[ScreenPermissionControls] (
		[ScreenId]
		,[ControlName]
		,[DisplayAs]
		,[Active]
		,[CreatedBy]
		,[CreatedDate]
		,[ModifiedBy]
		,[ModifiedDate]
		,[RecordDeleted]
		,[DeletedDate]
		,[DeletedBy]
		)
	VALUES (
		716
		,N'ButtonLock'
		,N'ButtonLock'
		,N'Y'
		,N'WSGL111'
		,GETDATE()
		,N'WSGL111'
		,GETDATE()
		,NULL
		,NULL
		,NULL
		)
END


IF NOT EXISTS (
		SELECT 1
		FROM ScreenPermissionControls
		WHERE ScreenId = 716
			AND ControlName = 'ButtonUnLock'
		)

BEGIN
	INSERT [dbo].[ScreenPermissionControls] (
		[ScreenId]
		,[ControlName]
		,[DisplayAs]
		,[Active]	
		,[CreatedBy]
		,[CreatedDate]
		,[ModifiedBy]
		,[ModifiedDate]
		,[RecordDeleted]
		,[DeletedDate]
		,[DeletedBy]
		)
	VALUES (
		716
		,N'ButtonUnLock'
		,N'ButtonUnLock'
		,N'Y'	
		,N'WSGL111'
		,GETDATE()
		,N'WSGL111'
		,GETDATE()
		,NULL
		,NULL
		,NULL
		)
END

/*Added by Vichee Network 180 Customization #609*/
IF NOT EXISTS (
		SELECT [SCREENNAME]
		FROM SCREENS
		WHERE [SCREENID] = 1168
		)
BEGIN
	SET IDENTITY_INSERT [SCREENS] ON

	INSERT INTO [DBO].[SCREENS] (
		[SCREENID]
		,[SCREENNAME]
		,[SCREENTYPE]
		,[SCREENURL]
		,[TABID]
		)
	VALUES (
		1168
		,'EIN View'
		,5765
		,'/CommonUserControls/EINView.ascx'
		,2
		)

	SET IDENTITY_INSERT [SCREENS] OFF
END
GO


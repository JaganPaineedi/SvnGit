IF NOT EXISTS (SELECT 1 FROM screens WHERE ScreenId = 1305)
BEGIN
	SET IDENTITY_INSERT [dbo].[Screens] ON

	INSERT INTO [Screens] ([ScreenId],[ScreenName],[ScreenType],[ScreenURL],[TabId])
	
	VALUES (1305,'ErrorLogViewer',5762,'/ActivityPages/Admin/ListPages/ErrorLog.ascx',4)
	SET IDENTITY_INSERT [dbo].[Screens] OFF
END
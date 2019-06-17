IF NOT EXISTS (SELECT 1 FROM screens WHERE ScreenId = 1306)
BEGIN
	SET IDENTITY_INSERT [dbo].[Screens] ON

	INSERT INTO [Screens] ([ScreenId],[ScreenName],[ScreenType],[ScreenURL],[TabId])
	
	VALUES (1306,'ErrorLog Details',5761,'/ActivityPages/Admin/Detail/ErroLogDetails.ascx',4)
	SET IDENTITY_INSERT [dbo].[Screens] OFF
END


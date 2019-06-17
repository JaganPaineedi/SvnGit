/*Core Screens and Banners for the Client Statements List Page 
---Author: Manjunath K
---Date: 23/05/2017
---Task: Engineering Improvement Initiatives- NBL(I) #529*/



DECLARE @DefaultOrder INT
DECLARE @IsCustom VARCHAR(1)
DECLARE @ScreenToolbarURL VARCHAR(200)
DECLARE @ScreenId INT
DECLARE @ScreenType INT
DECLARE @ScreenName VARCHAR(64)
DECLARE @ScreenURL VARCHAR(200)
DECLARE @ScreenPostUpdateSP VARCHAR(64)
DECLARE @TabId INT



SET @ScreenId = 2222
SET @ScreenType = 5762
SET @ScreenName = 'Statements'
SET @ScreenURL = '/ActivityPages/Client/ListPages/PastClientStatements.ascx'
SET @ScreenToolbarURL = NULL
SET @IsCustom = 'N'
SET @DefaultOrder = 1
SET @TabId = 2

IF NOT EXISTS (
			SELECT *
			FROM Screens
			WHERE ScreenId = @ScreenId
			)
	BEGIN
		SET IDENTITY_INSERT Screens ON

		INSERT INTO Screens (
			ScreenId
			,ScreenName
			,ScreenType
			,ScreenURL
			,PostUpdateStoredProcedure
			,TabId
			,ScreenToolBarURL
			)
		VALUES (
			@ScreenId
			,@ScreenName
			,@ScreenType
			,@ScreenURL
			,@ScreenPostUpdateSP
			,@TabId
			,@ScreenToolbarURL
			)

		SET IDENTITY_INSERT Screens OFF
	END
	ELSE
	BEGIN
		UPDATE Screens
		SET ScreenName = @ScreenName
			,ScreenType = @ScreenType
			,ScreenURL = @ScreenURL
			,PostUpdateStoredProcedure = @ScreenPostUpdateSP
			,TabId = @TabId
			,ScreenToolbarURL = @ScreenToolbarURL
			,RecordDeleted = NULL
		WHERE ScreenId = @ScreenId
	END
GO


/*Banners Insert Script*/
DECLARE @DefaultOrder INT
DECLARE @BannerName VARCHAR(100)
DECLARE @DisplayAs VARCHAR(100)
DECLARE @Active CHAR
DECLARE @Custom CHAR
DECLARE @ScreenId INT
DECLARE @ParentBannerId INT
DECLARE @TabId INT

SET @ScreenId = 2222
SET @ParentBannerId = NULL
SET @BannerName = 'Statements'
SET @DisplayAs = 'Statements'
SET @Active = 'Y'
SET @Custom = 'N'
SET @DefaultOrder = 1
SET @TabId = 2

IF NOT EXISTS (
		SELECT *
		FROM Banners
		WHERE [ScreenId] = @ScreenId
		)
BEGIN
	INSERT INTO [dbo].[Banners] (
		[BannerName]
		,[DisplayAs]
		,[Active]
		,[DefaultOrder]
		,[Custom]
		,[TabId]
		,[ParentBannerId]
		,[ScreenId]
		)
	VALUES (
		@BannerName
		,@DisplayAs
		,@Active
		,@DefaultOrder
		,@Custom
		,@TabId
		,@ParentBannerId
		,@ScreenId
		)
END
ELSE
BEGIN
	UPDATE Banners
	SET BannerName = @BannerName
		,DisplayAs = @DisplayAs
		,Active = @Active
		,DefaultOrder = @DefaultOrder
		,Custom = @Custom
		,TabId = @TabId
		,ParentBannerId = @ParentBannerId
		,ScreenId = @ScreenId
		,RecordDeleted = NULL
	WHERE ScreenId = @ScreenId
END
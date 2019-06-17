/************************************************************************************************/
/* INSERT SCRIPT: TABLE SCREENS,BANNERS          */
/* SCREEN TYPE - LIST PAGE  */
/* COPYRIGHT: 2005 STREAMLINE HEALTHCARE SOLUTIONS,  LLC          */
/* CREATION DATE:    01/May/2015                */
/* PURPOSE:  TO INSERT THE NEW ENTRY INTO SCREENS AND BANNERS PER THE TASK #818(Woods Customization) */
/* CREATED:																  */
/* DATE				AUTHOR					PURPOSE								  */
/* 1/May/2015      Vichee Humane			CREATED								  */
/************************************************************************************************/
SET IDENTITY_INSERT [SCREENS] ON
GO

IF NOT EXISTS (
		SELECT [SCREENNAME]
		FROM SCREENS
		WHERE [SCREENID] = 10915
		)
BEGIN
	INSERT INTO [DBO].[SCREENS] (
		[SCREENID]
		,[SCREENNAME]
		,[SCREENTYPE]
		,[SCREENURL]
		,[TABID]
		)
	VALUES (
		10915
		,'Incident Reports'
		,5762
		,'Custom/IncidentReport/ListPage/WebPages/IncidentReportsRestrictiveProcedures.ascx'
		,1
		)
END
ELSE
BEGIN
	UPDATE Screens
	SET [SCREENNAME] = 'Incident Reports'
		,[SCREENTYPE] = 5762
		,[SCREENURL] = 'Custom/IncidentReport/ListPage/WebPages/IncidentReportsRestrictiveProcedures.ascx'
		,[TABID] = 1
	WHERE [SCREENID] = 10915
END
GO

SET IDENTITY_INSERT [SCREENS] OFF
GO

--------------------------------------   Banner Table   -----------------------------------  
DECLARE @BannerName VARCHAR(100)
DECLARE @dispalyAs VARCHAR(100)
DECLARE @BannerActive CHAR(1)
DECLARE @BannerOrder INT
DECLARE @IsCustom CHAR(1)

SET @BannerName = 'Incident Report '
SET @dispalyAs = 'Incident Report'
SET @BannerActive = 'N'
SET @BannerOrder = 1
SET @IsCustom = 'Y'

IF NOT EXISTS (
		SELECT 1
		FROM dbo.Banners
		WHERE ScreenId = 10915
		)
BEGIN
	INSERT dbo.Banners (
		BannerName
		,DisplayAs
		,Active
		,DefaultOrder
		,Custom
		,TabId
		,ScreenId
		)
	VALUES (
		@BannerName
		,-- BannerName - varchar(100)
		@dispalyAs
		,-- DisplayAs - varchar(100)
		@BannerActive
		,-- Active - type_Active
		@BannerOrder
		,-- DefaultOrder - int
		@IsCustom
		,-- Custom - type_YOrN
		1
		,-- TabId - int
		10915 -- ScreenId - int
		)
END
ELSE
BEGIN
	UPDATE Banners
	SET BannerName=@BannerName
		,DisplayAs=@dispalyAs
		,Active=@BannerActive
		,DefaultOrder=@BannerOrder
		,Custom=@IsCustom
		,TabId=1		
	WHERE [SCREENID] = 10915
END

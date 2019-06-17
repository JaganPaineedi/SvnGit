-- Added by K.Soujanya : 03 August 2018
---INSERT INTO RecodeCategories Table for EVENTATTACHMENTS
IF NOT EXISTS (
		SELECT CategoryCode
		FROM RecodeCategories
		WHERE CategoryCode = 'EVENTATTACHMENTS'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO RecodeCategories (
		CategoryCode
		,CategoryName
		,Description
		,MappingEntity
		)
	VALUES (
		'EVENTATTACHMENTS'
		,'EVENTATTACHMENTS'
		,'To get documentcodeid which has attachments tab'
		,'DocumentCodeId'
		)
END

-------------------------------------------------------------------------------------------------------------------------
DECLARE @categoryId INT

SET @categoryId = (
		SELECT TOP 1 RecodeCategoryId
		FROM RecodeCategories
		WHERE CategoryCode = 'EVENTATTACHMENTS'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)

IF NOT EXISTS (
		SELECT *
		FROM Recodes
		WHERE RecodeCategoryId = @categoryId
			AND CodeName = 'Authorization Request'
		)
BEGIN
	INSERT INTO dbo.Recodes (
		IntegerCodeId
		,CharacterCodeId
		,CodeName
		,FromDate
		,ToDate
		,RecodeCategoryId
		)
	SELECT DC.DocumentCodeId
		,NULL
		,'Authorization Request'
		,GETDATE()
		,NULL
		,@categoryId
	FROM Screens S
	JOIN DocumentCodes DC ON S.DocumentcodeId = DC.DocumentcodeId
		AND ISNULL(S.RecordDeleted, 'N') = 'N'
		AND ISNULL(DC.RecordDeleted, 'N') = 'N'
	WHERE ScreenURL = '/Modules/CareManagement/ActivityPages/Client/Events/Authorization Request/AuthorizationTabs.ascx'
		AND ScreenName = 'Authorization Request'
END
		-------------------------------------------------------------------------------------------------------------------------

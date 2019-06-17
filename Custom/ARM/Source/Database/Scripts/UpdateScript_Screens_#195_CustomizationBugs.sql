
--Date: 07/31/2015
--Task: #195 Customization Bugs


IF EXISTS (SELECT 1 FROM Screens WHERE ScreenId=10681)
BEGIN
	UPDATE Screens 
	SET ScreenName='24-Hour Access Report',
	ScreenType=5763,
	ScreenURL='/Custom/WebPages/24HourAccessReportDocument.ascx',
	ScreenToolbarURL=NULL,
	TabId=2,
	InitializationStoredProcedure='csp_InitCustom24HourAccessReport',
	ValidationStoredProcedureComplete='csp_ValidateCustomDocument24HourAccess',
	DocumentCodeId=1491,
	CustomFieldFormId=NULL 
	WHERE ScreenId=10681
END

IF NOT EXISTS (SELECT 1 FROM DocumentNavigations WHERE ScreenId = 10681 and BannerId=292) 
BEGIN 
	INSERT INTO DocumentNavigations(NavigationName, DisplayAs, Active, ParentDocumentNavigationId, BannerId,ScreenId) 
	values('24-Hour Access Report','24-Hour Access Report','Y',5,292,10681)
END


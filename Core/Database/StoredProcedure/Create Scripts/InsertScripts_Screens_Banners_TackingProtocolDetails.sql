-- =============================================   
-- Author:    Vijay 
-- Create date: Feb 01, 2018
-- Description: What:Added a Banner entry for Tacking Protocols in Administration Tab 
/*              Why:Engineering Improvement Initiatives- NBL(I)  - Task# 590 

   Modified Date    Modidifed By    Purpose  
*/ 
-- =============================================     
DECLARE @ScreenId int
IF NOT EXISTS (SELECT * FROM dbo.SCREENS WHERE ScreenName = 'Tracking Protocols' and ScreenType = '5762')
BEGIN
	SET IDENTITY_INSERT Screens OFF	
	INSERT INTO Screens([ScreenName], [ScreenType], [ScreenURL], [ScreenToolbarURL], [TabId], [InitializationStoredProcedure], [ValidationStoredProcedureUpdate], [ValidationStoredProcedureComplete], [WarningStoredProcedureComplete], [PostUpdateStoredProcedure], [RefreshPermissionsAfterUpdate], [DocumentCodeId], [CustomFieldFormId], [HelpURL], [MessageReferenceType], [PrimaryKeyName], [WarningStoreProcedureUpdate], [KeyPhraseCategory], [ScreenParamters],[Code])
	VALUES( 'Tracking Protocols', '5762', '/Modules/ClientTracking/Admin/ListPages/TrackingProtocols.ascx', NULL, '4', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,'Tracking Protocols')
	SET IDENTITY_INSERT Screens OFF		
END
SELECT @ScreenId = ScreenId FROM SCREENS WHERE ScreenName = 'Tracking Protocols' and ScreenType = '5762'

IF NOT EXISTS (SELECT * FROM dbo.BANNERS WHERE BannerName = 'Tracking Protocols' and ScreenId = @ScreenId)
BEGIN
	SET IDENTITY_INSERT BANNERS OFF
	INSERT INTO BANNERS([BannerName], [DisplayAs], [Active], [DefaultOrder], [Custom], [TabId], [ParentBannerId], [ScreenId], [ScreenParameters])
	VALUES('Tracking Protocols', 'Tracking Protocols', 'Y', '1', 'N', '4', NULL, @ScreenId, NULL)
	SET IDENTITY_INSERT BANNERS OFF	
END


IF NOT EXISTS (SELECT * FROM dbo.SCREENS WHERE ScreenName = 'Tracking Protocol Details' and ScreenType = '5761')
BEGIN
	SET IDENTITY_INSERT Screens ON	
	INSERT INTO Screens(ScreenId, [ScreenName], [ScreenType], [ScreenURL], [ScreenToolbarURL], [TabId], [InitializationStoredProcedure], [ValidationStoredProcedureUpdate], [ValidationStoredProcedureComplete], [WarningStoredProcedureComplete], [PostUpdateStoredProcedure], [RefreshPermissionsAfterUpdate], [DocumentCodeId], [CustomFieldFormId], [HelpURL], [MessageReferenceType], [PrimaryKeyName], [WarningStoreProcedureUpdate], [KeyPhraseCategory], [ScreenParamters],[Code])
	VALUES(1313, 'Tracking Protocol Details', '5761', '/Modules/ClientTracking/Admin/Detail/TrackingProtocolDetails.ascx', NULL, '4', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,'TrackingProtocolDetails')
	SET IDENTITY_INSERT Screens OFF		
END

--GLOBALCODECATEGORIES
IF NOT EXISTS (SELECT * FROM dbo.GlobalCodeCategories WHERE Category = 'CREATEPROTOCOL') BEGIN  
INSERT INTO GlobalCodeCategories([Category], [CategoryName], [Active], [AllowAddDelete], [AllowCodeNameEdit], [AllowSortOrderEdit], [Description], [UserDefinedCategory], [HasSubcodes], [UsedInPracticeManagement], [UsedInCareManagement], [ExternalReferenceId]) 
VALUES('CREATEPROTOCOL', 'Create Protocol', 'Y', 'Y', 'Y', 'Y', NULL, 'Y', 'N', 'Y', NULL, NULL) END

--GLOBALCODES Manually
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'CREATEPROTOCOL' and Code = 'Manually') 
BEGIN SET IDENTITY_INSERT dbo.GlobalCodes OFF  
	INSERT INTO GLOBALCODES([Category], [CodeName], [Description], [Active], [CannotModifyNameOrDelete], [SortOrder], [ExternalCode1], [ExternalSource1], [ExternalCode2], [ExternalSource2], [Bitmap], [BitmapImage], [Color], [Code])
	VALUES('CREATEPROTOCOL', 'Manually', NULL, 'Y', 'Y', '1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Manually')
SET IDENTITY_INSERT dbo.GlobalCodes OFF END 

--GLOBALCODES On Episode Start
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'CREATEPROTOCOL' and Code = 'On Episode Start') 
BEGIN SET IDENTITY_INSERT dbo.GlobalCodes OFF  
	INSERT INTO GLOBALCODES([Category], [CodeName], [Description], [Active], [CannotModifyNameOrDelete], [SortOrder], [ExternalCode1], [ExternalSource1], [ExternalCode2], [ExternalSource2], [Bitmap], [BitmapImage], [Color], [Code])
	VALUES('CREATEPROTOCOL', 'On Episode Start', NULL, 'Y', 'Y', '2', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'On Episode Start')
SET IDENTITY_INSERT dbo.GlobalCodes OFF END 

--GLOBALCODES On Program Enrollment
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'CREATEPROTOCOL' and Code = 'On Program Enrollment') 
BEGIN SET IDENTITY_INSERT dbo.GlobalCodes OFF  
	INSERT INTO GLOBALCODES([Category], [CodeName], [Description], [Active], [CannotModifyNameOrDelete], [SortOrder], [ExternalCode1], [ExternalSource1], [ExternalCode2], [ExternalSource2], [Bitmap], [BitmapImage], [Color], [Code])
	VALUES('CREATEPROTOCOL', 'On Program Enrollment', NULL, 'Y', 'Y', '3', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'On Program Enrollment')
SET IDENTITY_INSERT dbo.GlobalCodes OFF END 

--GLOBALCODES On Program Requested
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'CREATEPROTOCOL' and Code = 'On Program Requested') 
BEGIN SET IDENTITY_INSERT dbo.GlobalCodes OFF  
	INSERT INTO GLOBALCODES([Category], [CodeName], [Description], [Active], [CannotModifyNameOrDelete], [SortOrder], [ExternalCode1], [ExternalSource1], [ExternalCode2], [ExternalSource2], [Bitmap], [BitmapImage], [Color], [Code])
	VALUES('CREATEPROTOCOL', 'On Program Requested', NULL, 'Y', 'Y', '4', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'On Program Requested')
SET IDENTITY_INSERT dbo.GlobalCodes OFF END

--GLOBALCODES On Program Discharge
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'CREATEPROTOCOL' and Code = 'On Program Discharge') 
BEGIN SET IDENTITY_INSERT dbo.GlobalCodes OFF  
	INSERT INTO GLOBALCODES([Category], [CodeName], [Description], [Active], [CannotModifyNameOrDelete], [SortOrder], [ExternalCode1], [ExternalSource1], [ExternalCode2], [ExternalSource2], [Bitmap], [BitmapImage], [Color], [Code])
	VALUES('CREATEPROTOCOL', 'On Program Discharge', NULL, 'Y', 'Y', '5', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'On Program Discharge')
SET IDENTITY_INSERT dbo.GlobalCodes OFF END  


--GLOBALCODECATEGORIES - Protocol Due Date
IF NOT EXISTS (SELECT * FROM dbo.GlobalCodeCategories WHERE Category = 'PROTOCOLDUEDATE') BEGIN  
INSERT INTO GlobalCodeCategories([Category], [CategoryName], [Active], [AllowAddDelete], [AllowCodeNameEdit], [AllowSortOrderEdit], [Description], [UserDefinedCategory], [HasSubcodes], [UsedInPracticeManagement], [UsedInCareManagement], [ExternalReferenceId]) 
VALUES('PROTOCOLDUEDATE', 'Protocol Due Date Unit Type', 'Y', 'Y', 'Y', 'Y', NULL, 'Y', 'N', 'Y', NULL, NULL) END

--GLOBALCODES Day(s)
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'PROTOCOLDUEDATE' and Code = 'Day(s)') 
BEGIN SET IDENTITY_INSERT dbo.GlobalCodes OFF  
	INSERT INTO GLOBALCODES([Category], [CodeName], [Description], [Active], [CannotModifyNameOrDelete], [SortOrder], [ExternalCode1], [ExternalSource1], [ExternalCode2], [ExternalSource2], [Bitmap], [BitmapImage], [Color], [Code])
	VALUES('PROTOCOLDUEDATE', 'Day(s)', NULL, 'Y', 'Y', '1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Day(s)')
SET IDENTITY_INSERT dbo.GlobalCodes OFF END  

--GLOBALCODES Month(s)
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'PROTOCOLDUEDATE' and Code = 'Month(s)') 
BEGIN SET IDENTITY_INSERT dbo.GlobalCodes OFF  
	INSERT INTO GLOBALCODES([Category], [CodeName], [Description], [Active], [CannotModifyNameOrDelete], [SortOrder], [ExternalCode1], [ExternalSource1], [ExternalCode2], [ExternalSource2], [Bitmap], [BitmapImage], [Color], [Code])
	VALUES('PROTOCOLDUEDATE', 'Month(s)', NULL, 'Y', 'Y', '2', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Month(s)')
SET IDENTITY_INSERT dbo.GlobalCodes OFF END

--GLOBALCODES Year
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'PROTOCOLDUEDATE' and Code = 'Year') 
BEGIN SET IDENTITY_INSERT dbo.GlobalCodes OFF  
	INSERT INTO GLOBALCODES([Category], [CodeName], [Description], [Active], [CannotModifyNameOrDelete], [SortOrder], [ExternalCode1], [ExternalSource1], [ExternalCode2], [ExternalSource2], [Bitmap], [BitmapImage], [Color], [Code])
	VALUES('PROTOCOLDUEDATE', 'Year', NULL, 'Y', 'Y', '3', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Year')
SET IDENTITY_INSERT dbo.GlobalCodes OFF END  


--GLOBALCODECATEGORIES - First Due Date
IF NOT EXISTS (SELECT * FROM dbo.GlobalCodeCategories WHERE Category = 'PROTOCOLFSTDUEDATE') BEGIN  
INSERT INTO GlobalCodeCategories([Category], [CategoryName], [Active], [AllowAddDelete], [AllowCodeNameEdit], [AllowSortOrderEdit], [Description], [UserDefinedCategory], [HasSubcodes], [UsedInPracticeManagement], [UsedInCareManagement], [ExternalReferenceId]) 
VALUES('PROTOCOLFSTDUEDATE', 'Protocol First Due Date', 'Y', 'Y', 'Y', 'Y', NULL, 'Y', 'N', 'Y', NULL, NULL) END

--GLOBALCODES Same as Due Date
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'PROTOCOLFSTDUEDATE' and Code = 'Same as Due Date') 
BEGIN SET IDENTITY_INSERT dbo.GlobalCodes OFF  
	INSERT INTO GLOBALCODES([Category], [CodeName], [Description], [Active], [CannotModifyNameOrDelete], [SortOrder], [ExternalCode1], [ExternalSource1], [ExternalCode2], [ExternalSource2], [Bitmap], [BitmapImage], [Color], [Code])
	VALUES('PROTOCOLFSTDUEDATE', 'Same as Due Date', NULL, 'Y', 'Y', '1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Same as Due Date')
SET IDENTITY_INSERT dbo.GlobalCodes OFF END

--GLOBALCODES Different from Due Date
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'PROTOCOLFSTDUEDATE' and Code = 'Different from Due Date') 
BEGIN SET IDENTITY_INSERT dbo.GlobalCodes OFF  
	INSERT INTO GLOBALCODES([Category], [CodeName], [Description], [Active], [CannotModifyNameOrDelete], [SortOrder], [ExternalCode1], [ExternalSource1], [ExternalCode2], [ExternalSource2], [Bitmap], [BitmapImage], [Color], [Code])
	VALUES('PROTOCOLFSTDUEDATE', 'Different from Due Date', NULL, 'Y', 'Y', '2', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Different from Due Date')
SET IDENTITY_INSERT dbo.GlobalCodes OFF END  



--GLOBALCODECATEGORIES - Due Date Based On
IF NOT EXISTS (SELECT * FROM dbo.GlobalCodeCategories WHERE Category = 'PROTOCOLDDBASEDON') BEGIN  
INSERT INTO GlobalCodeCategories([Category], [CategoryName], [Active], [AllowAddDelete], [AllowCodeNameEdit], [AllowSortOrderEdit], [Description], [UserDefinedCategory], [HasSubcodes], [UsedInPracticeManagement], [UsedInCareManagement], [ExternalReferenceId]) 
VALUES('PROTOCOLDDBASEDON', 'Protocol Due Date Based On', 'Y', 'Y', 'Y', 'Y', NULL, 'Y', 'N', 'Y', NULL, NULL) END

--GLOBALCODES Open Date
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'PROTOCOLDDBASEDON' and Code = 'Open Date') 
BEGIN SET IDENTITY_INSERT dbo.GlobalCodes OFF  
	INSERT INTO GLOBALCODES([Category], [CodeName], [Description], [Active], [CannotModifyNameOrDelete], [SortOrder], [ExternalCode1], [ExternalSource1], [ExternalCode2], [ExternalSource2], [Bitmap], [BitmapImage], [Color], [Code])
	VALUES('PROTOCOLDDBASEDON', 'Open Date', NULL, 'Y', 'Y', '1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Open Date')
SET IDENTITY_INSERT dbo.GlobalCodes OFF END

--GLOBALCODES Previous Due Date
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'PROTOCOLDDBASEDON' and Code = 'Previous Due Date') 
BEGIN SET IDENTITY_INSERT dbo.GlobalCodes OFF  
	INSERT INTO GLOBALCODES([Category], [CodeName], [Description], [Active], [CannotModifyNameOrDelete], [SortOrder], [ExternalCode1], [ExternalSource1], [ExternalCode2], [ExternalSource2], [Bitmap], [BitmapImage], [Color], [Code])
	VALUES('PROTOCOLDDBASEDON', 'Previous Due Date', NULL, 'Y', 'Y', '2', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Previous Due Date')
SET IDENTITY_INSERT dbo.GlobalCodes OFF END



--GLOBALCODECATEGORIES - Start Date
IF NOT EXISTS (SELECT * FROM dbo.GlobalCodeCategories WHERE Category = 'PROTOCOLSTARTDATE') BEGIN  
INSERT INTO GlobalCodeCategories([Category], [CategoryName], [Active], [AllowAddDelete], [AllowCodeNameEdit], [AllowSortOrderEdit], [Description], [UserDefinedCategory], [HasSubcodes], [UsedInPracticeManagement], [UsedInCareManagement], [ExternalReferenceId]) 
VALUES('PROTOCOLSTARTDATE', 'Protocol Start Date', 'Y', 'Y', 'Y', 'Y', NULL, 'Y', 'N', 'Y', NULL, NULL) END

--GLOBALCODES Open Date
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'PROTOCOLSTARTDATE' and Code = 'Open Date') 
BEGIN SET IDENTITY_INSERT dbo.GlobalCodes OFF  
	INSERT INTO GLOBALCODES([Category], [CodeName], [Description], [Active], [CannotModifyNameOrDelete], [SortOrder], [ExternalCode1], [ExternalSource1], [ExternalCode2], [ExternalSource2], [Bitmap], [BitmapImage], [Color], [Code])
	VALUES('PROTOCOLSTARTDATE', 'Open Date', NULL, 'Y', 'Y', '1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Open Date')
SET IDENTITY_INSERT dbo.GlobalCodes OFF END

--GLOBALCODES # of Days Before Due Date
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'PROTOCOLSTARTDATE' and Code = '# of Days Before Due Date') 
BEGIN SET IDENTITY_INSERT dbo.GlobalCodes OFF  
	INSERT INTO GLOBALCODES([Category], [CodeName], [Description], [Active], [CannotModifyNameOrDelete], [SortOrder], [ExternalCode1], [ExternalSource1], [ExternalCode2], [ExternalSource2], [Bitmap], [BitmapImage], [Color], [Code])
	VALUES('PROTOCOLSTARTDATE', '# of Days Before Due Date', NULL, 'Y', 'Y', '2', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '# of Days Before Due Date')
SET IDENTITY_INSERT dbo.GlobalCodes OFF END




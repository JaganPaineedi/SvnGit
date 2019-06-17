-- =============================================   
-- Author:    Vijay 
-- Create date: Feb 27, 2018
-- Description: What:Added a Banner entry for Client Tracking in Client Tab 
/*              Why:Engineering Improvement Initiatives- NBL(I)  - Task# 590 

   Modified Date    Modidifed By    Purpose  
*/ 
-- =============================================     
DECLARE @ScreenId int
IF NOT EXISTS (SELECT * FROM dbo.SCREENS WHERE ScreenName = 'Client Tracking' and ScreenType = '5762')
BEGIN
	SET IDENTITY_INSERT Screens OFF	
	INSERT INTO Screens([ScreenName], [ScreenType], [ScreenURL], [ScreenToolbarURL], [TabId], [InitializationStoredProcedure], [ValidationStoredProcedureUpdate], [ValidationStoredProcedureComplete], [WarningStoredProcedureComplete], [PostUpdateStoredProcedure], [RefreshPermissionsAfterUpdate], [DocumentCodeId], [CustomFieldFormId], [HelpURL], [MessageReferenceType], [PrimaryKeyName], [WarningStoreProcedureUpdate], [KeyPhraseCategory], [ScreenParamters], [Code])
	VALUES( 'Client Tracking', '5762', '/Modules/ClientTracking/Client/ListPages/ClientTracking.ascx', NULL, '2', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'ClientTracking')
	SET IDENTITY_INSERT Screens OFF		
END
SELECT @ScreenId = ScreenId FROM SCREENS WHERE ScreenName = 'Client Tracking' and ScreenType = '5762'

IF NOT EXISTS (SELECT * FROM dbo.BANNERS WHERE BannerName = 'Client Tracking' and ScreenId = @ScreenId)
BEGIN
	SET IDENTITY_INSERT BANNERS OFF
	INSERT INTO BANNERS([BannerName], [DisplayAs], [Active], [DefaultOrder], [Custom], [TabId], [ParentBannerId], [ScreenId], [ScreenParameters])
	VALUES('Client Tracking', 'Client Tracking', 'Y', '1', 'N', '2', NULL, @ScreenId, NULL)
	SET IDENTITY_INSERT BANNERS OFF	
END


-- Client Tracking Multi Action(Inactive, Delete, Complete) Popup-----------------------
DECLARE @PopUpScreenId int
IF NOT EXISTS (SELECT * FROM dbo.SCREENS WHERE ScreenName = 'ClientTrackingMultiActionPopUp' and ScreenType = '5765')
BEGIN
	SET IDENTITY_INSERT Screens OFF	
	INSERT INTO Screens([ScreenName], [ScreenType], [ScreenURL], [ScreenToolbarURL], [TabId], [InitializationStoredProcedure], [ValidationStoredProcedureUpdate], [ValidationStoredProcedureComplete], [WarningStoredProcedureComplete], [PostUpdateStoredProcedure], [RefreshPermissionsAfterUpdate], [DocumentCodeId], [CustomFieldFormId], [HelpURL], [MessageReferenceType], [PrimaryKeyName], [WarningStoreProcedureUpdate], [KeyPhraseCategory], [ScreenParamters],[Code])
	VALUES( 'ClientTrackingMultiActionPopUp', '5765', '/Modules/ClientTracking/Client/ListPages/ClientTrackingMultiActionPopUp.ascx', NULL, '2', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,'ClientTrackingMultiActionPopUp')
	SET IDENTITY_INSERT Screens OFF		
END

-- Client Tracking Complete Flags Popup-----------------------
IF NOT EXISTS (SELECT 1 FROM dbo.SCREENS WHERE ScreenName = 'ClientTrackingCompleteFlagsPopUp' and ScreenType = '5765')
BEGIN
	SET IDENTITY_INSERT Screens OFF	
	INSERT INTO Screens([ScreenName], [ScreenType], [ScreenURL], [ScreenToolbarURL], [TabId], [InitializationStoredProcedure], [ValidationStoredProcedureUpdate], [ValidationStoredProcedureComplete], [WarningStoredProcedureComplete], [PostUpdateStoredProcedure], [RefreshPermissionsAfterUpdate], [DocumentCodeId], [CustomFieldFormId], [HelpURL], [MessageReferenceType], [PrimaryKeyName], [WarningStoreProcedureUpdate], [KeyPhraseCategory], [ScreenParamters],[Code])
	VALUES( 'ClientTrackingCompleteFlagsPopUp', '5765', '/Modules/ClientTracking/Client/ListPages/ClientTrackingCompleteFlagsPopUp.ascx', NULL, '2', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,'ClientTrackingCompleteFlagsPopUp')
	SET IDENTITY_INSERT Screens OFF		
END

Update Screens Set Code = 'ClientFlagDetails' where Screenname  = 'Client Flag Details' and ScreenType =5761 and TabId = 2
Update Screens Set Code = 'FlagTypeDetails' where Screenname  = 'Flag Type Details' and ScreenType =5761 and TabId = 4

--======================================
--If SystemEventConfigurations.RealTime is "Y"  then flags will create based on Program Enrolment, Request, Discharge 
--and Episode Start using UI otherwise SQL JOB will create flags
--======================================
Update SystemEventConfigurations Set RealTime = 'Y' where EventTypeCode in ('ProgramEnrollment','ProgramRequested','ProgramDischarge','EpisodeStart')

/********************************************************************************                                                   
--  
-- Copyright: Streamline Healthcare Solutions  
-- "CQM Solutions External Link - Banner and ExternalScreen"
-- Purpose: Provides a link to the CQM Solutions website 
--  
-- Author:  Ray Stratton
-- Date:    12/13/2017
--  
-- *****History****  
--   12/13/2017 - Ray Stratton
*********************************************************************************/
DECLARE @ScreenId INT
DECLARE @ScreenType INT
DECLARE @ScreenName VARCHAR(255)
DECLARE @ScreenURL VARCHAR(200)

DECLARE @DefaultOrder INT
DECLARE @BannerName VARCHAR(100)
DECLARE @DisplayAs VARCHAR(100)
DECLARE @Active CHAR
DECLARE @Custom CHAR
DECLARE @ParentBannerId INT
DECLARE @TabId INT

DECLARE @SystemConfigurationKey VARCHAR(255)
DECLARE @SystemConfigurationValue VARCHAR(255)
DECLARE @SystemConfigurationDescription VARCHAR(255)
DECLARE @SystemConfigurationScreens VARCHAR(255)
DECLARE @SystemConfigurationAllowEdit VARCHAR(1)

DECLARE @SystemConfigurationKey2 VARCHAR(255)
DECLARE @SystemConfigurationValue2 VARCHAR(255)
DECLARE @SystemConfigurationDescription2 VARCHAR(255)
DECLARE @SystemConfigurationScreens2 VARCHAR(255)
DECLARE @SystemConfigurationAllowEdit2 VARCHAR(1)

DECLARE @SystemConfigurationKey3 VARCHAR(255)
DECLARE @SystemConfigurationValue3 VARCHAR(255)
DECLARE @SystemConfigurationDescription3 VARCHAR(255)
DECLARE @SystemConfigurationScreens3 VARCHAR(255)
DECLARE @SystemConfigurationAllowEdit3 VARCHAR(1)

DECLARE @SystemConfigurationKey4 VARCHAR(255)
DECLARE @SystemConfigurationValue4 VARCHAR(255)
DECLARE @SystemConfigurationDescription4 VARCHAR(255)
DECLARE @SystemConfigurationScreens4 VARCHAR(255)
DECLARE @SystemConfigurationAllowEdit4 VARCHAR(1)

SET @SystemConfigurationKey = 'CQMSolutionsBaseURL'
SET @SystemConfigurationValue = 'http://devweb.smartcarenet.com:83/Services/SSOSvc.asmx/GetAccessGUID'
SET @SystemConfigurationDescription = 'Links to the CQM Certification server'
SET @SystemConfigurationAllowEdit = 'Y'
SET @SystemConfigurationScreens = '119'

SET @SystemConfigurationKey2 = 'CQMSolutionsSSOUrl'
SET @SystemConfigurationValue2 = 'http://devweb.smartcarenet.com:83/Account/login.aspx'
SET @SystemConfigurationDescription2 = 'Links to the CQM Certification server'
SET @SystemConfigurationAllowEdit2 = 'Y'
SET @SystemConfigurationScreens2 = '119'

SET @SystemConfigurationKey3 = 'CQMSolutionsExternalPracticeID'
SET @SystemConfigurationValue3 = 'SmartcareMU3'
SET @SystemConfigurationDescription3 = 'ExternalPracticeID from the Practice table of CQMsolution DB'
SET @SystemConfigurationAllowEdit3 = 'Y'
SET @SystemConfigurationScreens3 = '119'

SET @SystemConfigurationKey4 = 'CQMSolutionsSharedKey'
SET @SystemConfigurationValue4 = '0eb29d1f-20a4-4701-9d2f-35b2af8837da'
SET @SystemConfigurationDescription4 = 'Non hashed/salted key that is located in SSOKeyCQM table'
SET @SystemConfigurationAllowEdit4 = 'Y'
SET @SystemConfigurationScreens4 = '119'


SET @ScreenId = 119
SET @ScreenName = 'CQMSolutions'
SET @ScreenType = 5766 -- ExternalScreen
SET @ScreenURL = '/Modules/CQMSolutions/Client/ExternalScreens/CQMSolutions.ascx'

SET @ParentBannerId = NULL
SET @BannerName = 'CQM'
SET @DisplayAs = 'CQM'
SET @Active = 'Y'
SET @Custom = 'N'
SET @DefaultOrder = 9999
SET @TabId = 1
DECLARE @err_message nvarchar(255)


IF NOT EXISTS (
		SELECT ScreenId
		FROM Screens
		WHERE ScreenId = @ScreenId
		)
BEGIN

	SET IDENTITY_INSERT [dbo].[Screens] ON
	INSERT INTO [dbo].[Screens] -- 60071
		(ScreenId, RecordDeleted, DeletedBy, DeletedDate, ScreenName, ScreenType, ScreenURL, 
		ScreenToolbarURL, TabId)
	VALUES
		(@ScreenId, NULL, NULL,NULL, @ScreenName, @ScreenType, @ScreenURL, NULL, @TabId)
	SET IDENTITY_INSERT [dbo].[Screens] OFF



	INSERT INTO Banners
	(RecordDeleted, DeletedBy, DeletedDate,	BannerName, DisplayAs, Active, DefaultOrder, [Custom],
		 TabId, ParentBannerId, ScreenId, ScreenParameters)
	VALUES
	(NULL, NULL, NULL, @BannerName, @DisplayAs, @Active, @DefaultOrder, @Custom, @TabId, @ParentBannerId, @ScreenId, NULL)

	INSERT INTO SystemConfigurationKeys
	(RecordDeleted, DeletedDate, DeletedBy,
		[Key], [Value], [Description], AcceptedValues, ShowKeyForViewingAndEditing, Modules, Screens,
		Comments, SourceTableName, AllowEdit)
	VALUES
		(null, null, null, @SystemConfigurationKey, @SystemConfigurationValue,@SystemConfigurationDescription,
		 null, null, null, @SystemConfigurationScreens, null, null, @SystemConfigurationAllowEdit)
		 
	INSERT INTO SystemConfigurationKeys
	(RecordDeleted, DeletedDate, DeletedBy,
		[Key], [Value], [Description], AcceptedValues, ShowKeyForViewingAndEditing, Modules, Screens,
		Comments, SourceTableName, AllowEdit)
	VALUES
		(null, null, null, @SystemConfigurationKey2, @SystemConfigurationValue2,@SystemConfigurationDescription2,
		 null, null, null, @SystemConfigurationScreens2, null, null, @SystemConfigurationAllowEdit2)

	INSERT INTO SystemConfigurationKeys
	(RecordDeleted, DeletedDate, DeletedBy,
		[Key], [Value], [Description], AcceptedValues, ShowKeyForViewingAndEditing, Modules, Screens,
		Comments, SourceTableName, AllowEdit)
	VALUES
		(null, null, null, @SystemConfigurationKey3, @SystemConfigurationValue3,@SystemConfigurationDescription3,
		 null, null, null, @SystemConfigurationScreens3, null, null, @SystemConfigurationAllowEdit3)

	INSERT INTO SystemConfigurationKeys
	(RecordDeleted, DeletedDate, DeletedBy,
		[Key], [Value], [Description], AcceptedValues, ShowKeyForViewingAndEditing, Modules, Screens,
		Comments, SourceTableName, AllowEdit)
	VALUES
		(null, null, null, @SystemConfigurationKey4, @SystemConfigurationValue4,@SystemConfigurationDescription4,
		 null, null, null, @SystemConfigurationScreens4, null, null, @SystemConfigurationAllowEdit4)		 
END
ELSE
BEGIN
	SET @err_message = @SystemConfigurationScreens + ' already exists. We need to pick a different reserved ScreenId'
	RAISERROR( @err_message, 10, 1);
END
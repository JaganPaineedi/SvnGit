SET IDENTITY_INSERT Screens ON;
INSERT INTO dbo.Screens ( ScreenId,ScreenName, ScreenType, ScreenURL,
                           TabId, InitializationStoredProcedure )
SELECT 897,'Direct Message',5761,'/Modules/DirectMessaging/Office/Detail/DirectMessage.ascx',1,'ssp_SCInitDirectMessage'
SET IDENTITY_INSERT Screens OFF;

SET IDENTITY_INSERT Screens ON;
INSERT INTO dbo.Screens ( ScreenId,ScreenName, ScreenType, ScreenURL,
                           TabId )
SELECT 898,'UploadAttachment',5765,'/Modules/DirectMessaging/Office/Custom/UploadAttachment.ascx',1
SET IDENTITY_INSERT Screens OFF;

SET IDENTITY_INSERT Screens ON;
INSERT INTO dbo.Screens ( ScreenId,ScreenName, ScreenType, ScreenURL,
                           TabId,ScreenToolbarURL )
SELECT 896,'Direct Messages',5762,'/Modules/DirectMessaging/Office/ListPages/DirectMessages.ascx',1,'/Modules/DirectMessaging/Office/DirectMessageToolbar.ascx'
SET IDENTITY_INSERT Screens OFF;
--Update the banner with the new list page 
UPDATE b
SET b.ScreenId = 896
FROM Banners AS b 
WHERE b.ScreenId = 892

--Insert Direct Account screens
SET IDENTITY_INSERT Screens ON;
INSERT INTO dbo.Screens ( ScreenId,ScreenName, ScreenType, ScreenURL,
                           TabId, InitializationStoredProcedure )
SELECT 895,'Direct Account',5761,'/Modules/DirectMessaging/Admin/Detail/DirectAccount.ascx',1,'ssp_SCInitDirectAccount'
SET IDENTITY_INSERT Screens OFF;

SET IDENTITY_INSERT Screens ON;
INSERT INTO dbo.Screens ( ScreenId,ScreenName, ScreenType, ScreenURL,
                           TabId )
SELECT 899,'Direct Accounts',5762,'/Modules/DirectMessaging/Admin/ListPages/DirectAccounts.ascx',1
SET IDENTITY_INSERT Screens OFF;

INSERT INTO dbo.Banners ( BannerName, DisplayAs, Active, DefaultOrder,
                           Custom, TabId,  ScreenId )
SELECT 'Direct Accounts','Direct Accounts','Y',999999,'N',4,899
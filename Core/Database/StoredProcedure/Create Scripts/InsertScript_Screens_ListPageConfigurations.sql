/*******************************************************************************
* Insert Script Screens
*******************************************************************************/
DECLARE @ScreenId INT = 2208
SET IDENTITY_INSERT dbo.Screens ON 
INSERT INTO dbo.Screens ( ScreenId, ScreenName, ScreenType, ScreenURL,
                       ScreenToolbarURL, TabId, InitializationStoredProcedure )
SELECT @ScreenId, 'List Page Configurations',5761,'/Modules/ListPageConfigurations/WebPages/ListPageConfigurations.ascx',NULL,1,'ssp_SCInitListPageConfigurations'
SET IDENTITY_INSERT dbo.Screens OFF
/********************************************************************************                                                      
-- Copyright: Streamline Healthcare Solutions    
-- Purpose: Adding Screen and Banner items for 'Client Plans And Time Spans'.  
-- Author:  Alok Kumar
-- Date:    13 June 2018
*********************************************************************************/



-- 'Client Plans And Time Spans' Screen Entry
-----------------------------------------------Start--------------------------------------------  
  
DECLARE @ScreenId INT
DECLARE @ScreenCode VARCHAR(100)
DECLARE @ScreenName VARCHAR(100) 
DECLARE @ScreenType INT 
DECLARE @ScreenURL VARCHAR(200) 
DECLARE @ScreenToolbarURL VARCHAR(200) 
DECLARE @TabId INT 
DECLARE @InitializationStoredProcedure VARCHAR(500)
DECLARE @ValidationStoredProcedureUpdate VARCHAR(500) 
DECLARE @ValidationStoredProcedureComplete VARCHAR(500) 
DECLARE @WarningStoredProcedureComplete VARCHAR(500) 
DECLARE @PostUpdateStoredProcedure VARCHAR(500) 
DECLARE @RefreshPermissionsAfterUpdate VARCHAR(500) 
DECLARE @DocumentCodeId INT
DECLARE @HelpURL Varchar(max)

--SET @ScreenId = 1304
SET @ScreenCode = 'ClientCoveragePlanNotes'
SET @ScreenName = 'Client Plans And Time Spans' 
SET @ScreenType = 5761 
SET @ScreenURL = '/Modules/ClientPlans/WebPages/ClientPlanMain.ascx'
SET @ScreenToolbarURL = '/ScreenToolBars/ClientPlansAndTimeSpansToolBar.ascx'
SET @TabId = 2   
SET @InitializationStoredProcedure = NULL 
SET @ValidationStoredProcedureUpdate = NULL 
SET @ValidationStoredProcedureComplete = NULL 
SET @WarningStoredProcedureComplete = NULL
SET @PostUpdateStoredProcedure = NULL 
SET @RefreshPermissionsAfterUpdate = NULL 
SET @HelpURL = '../Help/New Help Files/WebHelp/mergedProjects/Client Plans and Time Spans/index.htm#client_plans_and_time_spans/client_plans_and_time_spans.htm'


IF NOT EXISTS (SELECT ScreenId 
               FROM   Screens 
               WHERE  Code = @ScreenCode) 
  BEGIN 
      --SET IDENTITY_INSERT [dbo].[Screens] ON 

      INSERT INTO [Screens] 
                  (--[ScreenId],
                   [Code],
                   [ScreenName], 
                   [ScreenType], 
                   [ScreenURL], 
                   [ScreenToolbarURL],
                   [TabId], 
                   [InitializationStoredProcedure], 
                   [ValidationStoredProcedureUpdate], 
                   [ValidationStoredProcedureComplete], 
                   [PostUpdateStoredProcedure], 
                   [RefreshPermissionsAfterUpdate], 
                   [DocumentCodeId],
                   [HelpURL]) 
      VALUES      ( --@ScreenId, 
					@ScreenCode,
                    @ScreenName, 
                    @ScreenType, 
                    @ScreenURL,
                    @ScreenToolbarURL, 
                    @TabId, 
                    @InitializationStoredProcedure, 
                    @ValidationStoredProcedureUpdate, 
                    @ValidationStoredProcedureComplete, 
                    @PostUpdateStoredProcedure, 
                    @RefreshPermissionsAfterUpdate, 
                    @DocumentCodeId,
                    @HelpURL) 

      --SET IDENTITY_INSERT [dbo].[Screens] OFF 
  END 
ELSE 
  BEGIN 
      UPDATE Screens 
      SET    ScreenName = @ScreenName, 
             ScreenType = @ScreenType, 
             ScreenURL = @ScreenURL, 
             ScreenToolbarURL = @ScreenToolbarURL,
             TabId = @TabId, 
             InitializationStoredProcedure = @InitializationStoredProcedure, 
             ValidationStoredProcedureUpdate = @ValidationStoredProcedureUpdate, 
             ValidationStoredProcedureComplete = @ValidationStoredProcedureComplete, 
             PostUpdateStoredProcedure = @PostUpdateStoredProcedure, 
             RefreshPermissionsAfterUpdate = @RefreshPermissionsAfterUpdate, 
             DocumentCodeId = @DocumentCodeId,
             HelpURL = @HelpURL
      WHERE  Code = @ScreenCode		--ScreenId = @ScreenId
  END 
  
 -----------------------------------------------END--------------------------------------------  






-- Inquiry List(My Office) Banner Entry
----------------------------------------   Banner Table   -----------------------------------  
DECLARE @BannerName VARCHAR(100)
DECLARE @dispalyAs VARCHAR(100) 
DECLARE @BannerActive CHAR(1)
DECLARE @DefaultOrder INT
DECLARE @IsCustom CHAR(1)
DECLARE @ParentBannerId INT
DECLARE @ParentBannerIdForNavigation INT
DECLARE @InquiriesBannerId INT

SET @ScreenId = (Select  top 1 ScreenId from Screens WHERE  Code = @ScreenCode)

SET @BannerName = 'Client Plans And Time Spans'
SET @dispalyAs = 'Client Plans And Time Spans'
SET @BannerActive = 'Y'
SET @DefaultOrder = 2
SET @IsCustom = 'N'
SET @ParentBannerId = NULL

IF NOT EXISTS (SELECT 1 FROM dbo.Banners WHERE ScreenId =@ScreenId AND BannerName = @BannerName)

	BEGIN	
		INSERT dbo.Banners
				( 
				  BannerName ,
				  DisplayAs ,
				  Active ,
				  DefaultOrder ,
				  Custom ,
				  TabId ,
				  ParentBannerId,
				  ScreenId		  
				)
		VALUES  ( @BannerName , -- BannerName - varchar(100)
				  @dispalyAs , -- DisplayAs - varchar(100)
				  @BannerActive , -- Active - type_Active
				  @DefaultOrder , -- DefaultOrder - int
				  @IsCustom , -- Custom - type_YOrN
				  @TabId , -- TabId - int
				  @ParentBannerId,
				  @ScreenId
				)		
	END	
ELSE
	BEGIN
		UPDATE Banners 
		SET		BannerName = @BannerName,
				DisplayAs = @dispalyAs,
				Active = @BannerActive,
				DefaultOrder = @DefaultOrder,
				Custom = @IsCustom,
				TabId = @TabId,
				ParentBannerId = @ParentBannerId,
				ScreenId = @ScreenId
		WHERE	ScreenId = @ScreenId
	END

 -----------------------------------------------END--------------------------------------------  





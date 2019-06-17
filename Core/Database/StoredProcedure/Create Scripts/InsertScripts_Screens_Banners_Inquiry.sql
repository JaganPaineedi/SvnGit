/********************************************************************************                                                      
-- Copyright: Streamline Healthcare Solutions    
-- Purpose: Adding Screen and Banner items for Inquiry Gold Document.  
-- Author:  Alok Kumar
-- Date:    13 June 2018
*********************************************************************************/



-- Inquiry Details Screen Entry
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


--SET @ScreenId = 1304
SET @ScreenCode = 'Inquiries'
SET @ScreenName = 'Inquiry Details' 
SET @ScreenType = 5761 
SET @ScreenURL = '/Modules/Inquiry/Client/Details/WebPages/InquiryDetail.ascx'
SET @ScreenToolbarURL = '/Modules/Inquiry/Client/Details/ScreenToolBars/InquiryToolBar.ascx'
SET @TabId = 1   
SET @InitializationStoredProcedure = 'ssp_InitInquiry' 
SET @ValidationStoredProcedureUpdate = NULL 
SET @ValidationStoredProcedureComplete = NULL 
SET @WarningStoredProcedureComplete = NULL
SET @PostUpdateStoredProcedure = 'ssp_PostUpdateInquiry' 
SET @RefreshPermissionsAfterUpdate = NULL 


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
                   [DocumentCodeId]) 
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
                    @DocumentCodeId) 

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
             DocumentCodeId = @DocumentCodeId
      WHERE  Code = @ScreenCode		--ScreenId = @ScreenId
  END 
  
 -----------------------------------------------END--------------------------------------------  






----------------------------------------   Screens Table   -----------------------------------  
/*   
  Please change these variables for supporting a new page/document/widget   
  Screen Types:   
    None:               0,   
        Detail:             5761,   
        List:               5762,   
        Document:           5763,   
        Summary:            5764,   
        Custom:             5765,   
        ExternalScreen:     5766   
*/


-- Inquiry List(My Office) Screen Entry
-----------------------------------------------Start--------------------------------------------  



--SET @ScreenId = 1303
SET @ScreenCode = 'Inquiries_1'
SET @ScreenName = 'Inquiries' 
SET @ScreenType = 5762 
SET @ScreenURL = '/Modules/Inquiry/Office/ListPages/WebPages/InquiryList.ascx'
SET @ScreenToolbarURL = NULL
SET @TabId = 1 
SET @InitializationStoredProcedure = NULL 
SET @ValidationStoredProcedureUpdate = NULL 
SET @ValidationStoredProcedureComplete = NULL 
SET @WarningStoredProcedureComplete = NULL
SET @PostUpdateStoredProcedure = NULL 
SET @RefreshPermissionsAfterUpdate = NULL 


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
                   [TabId], 
                   [InitializationStoredProcedure], 
                   [ValidationStoredProcedureUpdate], 
                   [ValidationStoredProcedureComplete], 
                   [PostUpdateStoredProcedure], 
                   [RefreshPermissionsAfterUpdate], 
                   [DocumentCodeId]) 
      VALUES      ( --@ScreenId, 
					@ScreenCode,
                    @ScreenName, 
                    @ScreenType, 
                    @ScreenURL, 
                    @TabId, 
                    @InitializationStoredProcedure, 
                    @ValidationStoredProcedureUpdate, 
                    @ValidationStoredProcedureComplete, 
                    @PostUpdateStoredProcedure, 
                    @RefreshPermissionsAfterUpdate, 
                    @DocumentCodeId) 

      --SET IDENTITY_INSERT [dbo].[Screens] OFF 
  END 
ELSE 
  BEGIN 
      UPDATE Screens 
      SET    ScreenName = @ScreenName, 
             ScreenType = @ScreenType, 
             ScreenURL = @ScreenURL, 
             TabId = @TabId, 
             InitializationStoredProcedure = @InitializationStoredProcedure, 
             ValidationStoredProcedureUpdate = @ValidationStoredProcedureUpdate, 
             ValidationStoredProcedureComplete = @ValidationStoredProcedureComplete, 
             PostUpdateStoredProcedure = @PostUpdateStoredProcedure, 
             RefreshPermissionsAfterUpdate = @RefreshPermissionsAfterUpdate, 
             DocumentCodeId = @DocumentCodeId
      WHERE  Code = @ScreenCode
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

SET @ScreenCode = 'Inquiries_1'
SET @ScreenId = (Select  top 1 ScreenId from Screens WHERE  Code = @ScreenCode)

SET @BannerName = 'Inquiries'
SET @dispalyAs = 'Inquiries'
SET @BannerActive = 'Y'
SET @DefaultOrder = 1
SET @IsCustom = 'N'
SET @ParentBannerId = NULL

IF NOT EXISTS (SELECT 1 FROM dbo.Banners WHERE ScreenId =@ScreenId AND BannerName = 'Inquiries')

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






-- Inquiry List(Clients) Screen Entry
-----------------------------------------------Start--------------------------------------------  

--SET @ScreenId = 1303
SET @ScreenCode = 'Inquiries_2'
SET @ScreenName = 'Client Inquiries' 
SET @ScreenType = 5762 
SET @ScreenURL = '/Modules/Inquiry/Client/ListPages/WebPages/MemberInquiriesList.ascx'
SET @ScreenToolbarURL = NULL
SET @TabId = 2 
SET @InitializationStoredProcedure = NULL 
SET @ValidationStoredProcedureUpdate = NULL 
SET @ValidationStoredProcedureComplete = NULL 
SET @WarningStoredProcedureComplete = NULL
SET @PostUpdateStoredProcedure = NULL 
SET @RefreshPermissionsAfterUpdate = NULL 


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
                   [TabId], 
                   [InitializationStoredProcedure], 
                   [ValidationStoredProcedureUpdate], 
                   [ValidationStoredProcedureComplete], 
                   [PostUpdateStoredProcedure], 
                   [RefreshPermissionsAfterUpdate], 
                   [DocumentCodeId]) 
      VALUES      ( --@ScreenId, 
					@ScreenCode,
                    @ScreenName, 
                    @ScreenType, 
                    @ScreenURL, 
                    @TabId, 
                    @InitializationStoredProcedure, 
                    @ValidationStoredProcedureUpdate, 
                    @ValidationStoredProcedureComplete, 
                    @PostUpdateStoredProcedure, 
                    @RefreshPermissionsAfterUpdate, 
                    @DocumentCodeId) 

      --SET IDENTITY_INSERT [dbo].[Screens] OFF 
  END 
ELSE 
  BEGIN 
      UPDATE Screens 
      SET    ScreenName = @ScreenName, 
             ScreenType = @ScreenType, 
             ScreenURL = @ScreenURL, 
             TabId = @TabId, 
             InitializationStoredProcedure = @InitializationStoredProcedure, 
             ValidationStoredProcedureUpdate = @ValidationStoredProcedureUpdate, 
             ValidationStoredProcedureComplete = @ValidationStoredProcedureComplete, 
             PostUpdateStoredProcedure = @PostUpdateStoredProcedure, 
             RefreshPermissionsAfterUpdate = @RefreshPermissionsAfterUpdate, 
             DocumentCodeId = @DocumentCodeId
      WHERE  Code = @ScreenCode
  END 
  
 -----------------------------------------------END--------------------------------------------  



-- Inquiry List(Clients) Banner Entry
----------------------------------------   Banner Table   -----------------------------------  

SET @ScreenCode = 'Inquiries_2'
SET @ScreenId = (Select  top 1 ScreenId from Screens WHERE  Code = @ScreenCode)

SET @BannerName = 'Client Inquiries'
SET @dispalyAs = 'Client Inquiries'
SET @BannerActive = 'Y'
SET @DefaultOrder = 2
SET @IsCustom = 'N'
SET @ParentBannerId = NULL

IF NOT EXISTS (SELECT 1 FROM dbo.Banners WHERE ScreenId =@ScreenId AND BannerName = 'Client Inquiries')

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






-- Guardian Information Screen Entry
-----------------------------------------------Start--------------------------------------------  

--SET @ScreenId = 1305
SET @ScreenCode = 'Inquiries_3'
SET @ScreenName = 'Guardian Information' 
SET @ScreenType = 5761 
SET @ScreenURL = '/Modules/Inquiry/Client/Details/WebPages/InquiryGuardianInformation.ascx'
SET @ScreenToolbarURL = NULL
SET @TabId = 1  
SET @InitializationStoredProcedure = NULL 
SET @ValidationStoredProcedureUpdate = NULL 
SET @ValidationStoredProcedureComplete = NULL 
SET @WarningStoredProcedureComplete = NULL
SET @PostUpdateStoredProcedure = NULL 
SET @RefreshPermissionsAfterUpdate = NULL 


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
                   [DocumentCodeId]) 
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
                    @DocumentCodeId) 

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
             DocumentCodeId = @DocumentCodeId
      WHERE  Code = @ScreenCode		
  END 
  
 -----------------------------------------------END--------------------------------------------  
 
 
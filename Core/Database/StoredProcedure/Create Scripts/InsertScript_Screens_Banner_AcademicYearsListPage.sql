-- ============================================= 
-- Author:    Chita Ranjan
-- Create date: April 04, 2018
-- Description:  Screens,Banners entry for Academic Years List page (PEP-Customizations #10005). 

-- =============================================   

-------------------------Screens----------------------------------------------------------- 
IF( NOT( EXISTS(SELECT screenId 
                FROM   screens 
                WHERE  screenId = 1324) ) ) 
  BEGIN 
      SET IDENTITY_INSERT [dbo].[Screens] ON 

      INSERT INTO [Screens] 
                  ([ScreenId], 
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
                   [CustomFieldFormId]) 
      VALUES     (1324, 
                  'Academic Years', 
                  5762, 
                 'Modules/Classroom/WebPages/AcademicYearsListPage.ascx', 
                 NULL, 
                  4, 
                NULL,
                 NULL, 
                NULL, 
                NULL, 
                 NULL, 
                 NULL, 
                 NULL) 

      SET IDENTITY_INSERT [dbo].[Screens] OFF 
  END 
ELSE 
  BEGIN 
      UPDATE SCREENS 
      SET    [ScreenName] = 'Academic Years', 
             [ScreenType] = 5762, 
             [ScreenURL] ='Modules/Classroom/WebPages/AcademicYearsListPage.ascx', 
             [ScreenToolbarURL] = NULL, 
             [TabId] = 4, 
             [InitializationStoredProcedure] = NULL, 
             [ValidationStoredProcedureUpdate] = NULL, 
             [ValidationStoredProcedureComplete] = NULL,
             [PostUpdateStoredProcedure] = NULL, 
             [RefreshPermissionsAfterUpdate] = NULL, 
             [DocumentCodeId] = NULL, 
             [CustomFieldFormId] = NULL 
      WHERE  SCREENID = 1324
  END 
---------------------------End---------------------------------------------------------------------- 
---------------------------Banners------------------------------------------------------------------ 
IF( NOT( EXISTS(SELECT bannerId 
                FROM   banners 
                WHERE  bannerId = 1324) ) ) 
  BEGIN 
      SET IDENTITY_INSERT [dbo].[Banners] ON 

      INSERT INTO [Banners] 
                  ([BannerId], 
                   [BannerName], 
                   [DisplayAs], 
                   [Active], 
                   [DefaultOrder], 
                   [Custom], 
                   [TabId], 
                   [ScreenId], 
                   [ParentBannerId]) 
      VALUES      (1324, 
                   'Academic Years', 
                   'Academic Years', 
                   'Y', 
                   500, 
                   'N', 
                   4, 
                   1324, 
                   Null) 

      SET IDENTITY_INSERT [dbo].[Banners] OFF 
  END 
ELSE 
  BEGIN 
      UPDATE Banners 
      SET    [BannerName] = 'Academic Years', 
             [DisplayAs] = 'Academic Years', 
             [Active] = 'Y', 
             [DefaultOrder] = 500, 
             [Custom] = 'N', 
             [TabId] = 4, 
             [ScreenId] = 1324, 
             [ParentBannerId] = Null
      WHERE  BANNERID = 1324
  END 

GO 


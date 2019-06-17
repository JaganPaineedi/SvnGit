-- ============================================= 
-- Author:    Chita Ranjan
-- Create date: April 17 2018
-- Description:  Screens,Banners entry for Courses List Page (PEP-Customizations #10005). 

-- =============================================   

-------------------------Screens----------------------------------------------------------- 
IF( NOT( EXISTS(SELECT screenId 
                FROM   screens 
                WHERE  screenId = 1329) ) ) 
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
      VALUES     (1329, 
                  'Courses List Page', 
                  5762, 
                 'Modules/Classroom/WebPages/CourseListPage.ascx', 
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
      SET    [ScreenName] = 'Courses List Page', 
             [ScreenType] = 5762, 
             [ScreenURL] ='Modules/Classroom/WebPages/CourseListPage.ascx', 
             [ScreenToolbarURL] = NULL, 
             [TabId] = 4, 
             [InitializationStoredProcedure] = NULL, 
             [ValidationStoredProcedureUpdate] = NULL, 
             [ValidationStoredProcedureComplete] = NULL,
             [PostUpdateStoredProcedure] = NULL, 
             [RefreshPermissionsAfterUpdate] = NULL, 
             [DocumentCodeId] = NULL, 
             [CustomFieldFormId] = NULL 
      WHERE  SCREENID = 1329
  END 
---------------------------End---------------------------------------------------------------------- 
---------------------------Banners------------------------------------------------------------------ 
IF( NOT( EXISTS(SELECT bannerId 
                FROM   banners 
                WHERE  bannerId = 1329) ) ) 
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
      VALUES      (1329, 
                   'Courses List Page', 
                   'Courses List Page', 
                   'Y', 
                   500, 
                   'N', 
                   4, 
                   1329, 
                   Null) 

      SET IDENTITY_INSERT [dbo].[Banners] OFF 
  END 
ELSE 
  BEGIN 
      UPDATE Banners 
      SET    [BannerName] = 'Courses List Page', 
             [DisplayAs] = 'Courses List Page', 
             [Active] = 'Y', 
             [DefaultOrder] = 500, 
             [Custom] = 'N', 
             [TabId] = 4, 
             [ScreenId] = 1329, 
             [ParentBannerId] = Null
      WHERE  BANNERID = 1329
  END 

GO 


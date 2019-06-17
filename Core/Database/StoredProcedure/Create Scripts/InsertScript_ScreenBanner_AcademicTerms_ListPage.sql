-- ============================================= 
-- Author:    Chita Ranjan
-- Create date: April 04 2018
-- Description:  Screens,Banners entry for Academic Terms List page (PEP-Customizations #10005). 

-- =============================================   

-------------------------Screens----------------------------------------------------------- 
IF( NOT( EXISTS(SELECT screenId 
                FROM   screens 
                WHERE  screenId = 1327) ) ) 
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
      VALUES     (1327, 
                  'Academic Terms', 
                  5762, 
                 'Modules/Classroom/WebPages/AcademicTermsListPage.ascx', 
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
      SET    [ScreenName] = 'Academic Terms', 
             [ScreenType] = 5762, 
             [ScreenURL] ='Modules/Classroom/WebPages/AcademicTermsListPage.ascx', 
             [ScreenToolbarURL] = NULL, 
             [TabId] = 4, 
             [InitializationStoredProcedure] = NULL, 
             [ValidationStoredProcedureUpdate] = NULL, 
             [ValidationStoredProcedureComplete] = NULL,
             [PostUpdateStoredProcedure] = NULL, 
             [RefreshPermissionsAfterUpdate] = NULL, 
             [DocumentCodeId] = NULL, 
             [CustomFieldFormId] = NULL 
      WHERE  SCREENID = 1327
  END 
---------------------------End---------------------------------------------------------------------- 
---------------------------Banners------------------------------------------------------------------ 
IF( NOT( EXISTS(SELECT bannerId 
                FROM   banners 
                WHERE  bannerId = 1327) ) ) 
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
      VALUES      (1327, 
                   'Academic Terms', 
                   'Academic Terms', 
                   'Y', 
                   500, 
                   'N', 
                   4, 
                   1327, 
                   Null) 

      SET IDENTITY_INSERT [dbo].[Banners] OFF 
  END 
ELSE 
  BEGIN 
      UPDATE Banners 
      SET    [BannerName] = 'Academic Terms', 
             [DisplayAs] = 'Academic Terms', 
             [Active] = 'Y', 
             [DefaultOrder] = 500, 
             [Custom] = 'N', 
             [TabId] = 4, 
             [ScreenId] = 1327, 
             [ParentBannerId] = Null
      WHERE  BANNERID = 1327
  END 

GO 


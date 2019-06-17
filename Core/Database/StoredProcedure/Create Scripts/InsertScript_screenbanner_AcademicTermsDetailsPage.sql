-- ============================================= 
-- Author:    Animesh Gaurav
-- Create date: Mar 7, 2018
-- Description:  Screens,Banners entry for Academic Terms List page (PEP-Customizations #10005). 

-- =============================================   

-------------------------Screens----------------------------------------------------------- 
IF( NOT( EXISTS(SELECT screenId 
                FROM   screens 
                WHERE  screenId = 1326) ) ) 
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
      VALUES     (1326, 
                  'Academic Terms', 
                  5761, 
                 'Modules/Classroom/WebPages/AcademicTermsMain.ascx', 
                 NULL, 
                  4, 
                'ssp_InitAcademicTerms',
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
             [ScreenType] = 5761, 
             [ScreenURL] ='Modules/Classroom/WebPages/AcademicTermsMain.ascx', 
             [ScreenToolbarURL] = NULL, 
             [TabId] = 4, 
             [InitializationStoredProcedure] = 'ssp_InitAcademicTerms', 
             [ValidationStoredProcedureUpdate] = NULL, 
             [ValidationStoredProcedureComplete] = NULL,
             [PostUpdateStoredProcedure] = NULL, 
             [RefreshPermissionsAfterUpdate] = NULL, 
             [DocumentCodeId] = NULL, 
             [CustomFieldFormId] = NULL 
      WHERE  SCREENID = 1326
  END 
 
 
  
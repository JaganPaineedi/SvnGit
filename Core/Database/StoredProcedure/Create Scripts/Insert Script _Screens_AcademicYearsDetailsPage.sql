-- ============================================= 
-- Author:    Swatika Shinde
-- Create date: Mar 8, 2018
-- Description:  Screens entry for Academic Years Details page (PEP-Customizations #10005). 

-- =============================================   

-------------------------Screens----------------------------------------------------------- 
IF( NOT( EXISTS(SELECT screenId 
                FROM   screens 
                WHERE  screenId = 1325) ) ) 
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
      VALUES     (1325,
                  'Academic Years', 
                  5761, 
                 'Modules/Classroom/WebPages/AcademicYearsMain.ascx', 
                 NULL, 
                  4, 
                'ssp_InitAcademicYears',
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
             [ScreenType] = 5761, 
             [ScreenURL] ='Modules/Classroom/WebPages/AcademicYearsMain.ascx', 
             [ScreenToolbarURL] = NULL, 
             [TabId] = 4, 
             [InitializationStoredProcedure] = 'ssp_InitAcademicYears', 
             [ValidationStoredProcedureUpdate] = NULL, 
             [ValidationStoredProcedureComplete] = NULL,
             [PostUpdateStoredProcedure] = NULL, 
             [RefreshPermissionsAfterUpdate] = NULL, 
             [DocumentCodeId] = NULL, 
             [CustomFieldFormId] = NULL 
      WHERE  SCREENID = 1325
  END 
---------------------------End---------------------------------------------------------------------- 
GO 


-- ============================================= 
-- Author:    Chita Ranjan
-- Create date: April 04, 2018
-- Description:  Screens entry for Course Information Details page (PEP-Customizations #10005). 

-- =============================================   

-------------------------Screens----------------------------------------------------------- 
IF( NOT( EXISTS(SELECT screenId 
                FROM   screens 
                WHERE  screenId = 1321) ) ) 
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
      VALUES     (1321,
                  'Course Information', 
                  5761, 
                 '/Modules/Classroom/WebPages/ClassroomCourseMain.ascx', 
                 NULL, 
                  4, 
                'ssp_InitCourseDetails',
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
      SET    [ScreenName] = 'Course Information', 
             [ScreenType] = 5761, 
             [ScreenURL] ='/Modules/Classroom/WebPages/ClassroomCourseMain.ascx', 
             [ScreenToolbarURL] = NULL, 
             [TabId] = 4, 
             [InitializationStoredProcedure] = 'ssp_InitCourseDetails', 
             [ValidationStoredProcedureUpdate] = NULL, 
             [ValidationStoredProcedureComplete] = NULL,
             [PostUpdateStoredProcedure] = NULL, 
             [RefreshPermissionsAfterUpdate] = NULL, 
             [DocumentCodeId] = NULL, 
             [CustomFieldFormId] = NULL 
      WHERE  SCREENID = 1321
  END 
---------------------------End---------------------------------------------------------------------- 
GO 


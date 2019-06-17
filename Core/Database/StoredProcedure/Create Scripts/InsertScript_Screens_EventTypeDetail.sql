/*Core Screens and Banners for the Event Type Detail Page  
---Author: Rajeshwari S 
---Date: 22/11/2017 
---Task: Engineering Improvement Initiatives- NBL(I) 606#*/ 
---------------------------Screens----------------------------------------------------------- 
IF NOT EXISTS (SELECT * 
               FROM   Screens 
               WHERE  ScreenId = 1310) 
  BEGIN 
      SET IDENTITY_INSERT screens ON 

      INSERT INTO [Screens] (
                    ScreenId,
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
      VALUES      ( 1310,
                    'Event Type Detail', 
                    5761, 
                    '/ActivityPages/Admin/DEtail/EventTypeDetail.ascx', 
                    NULL, 
                    4, 
                    NULL, 
                    NULL, 
                    NULL, 
                    NULL, 
                    NULL, 
                    NULL, 
                    NULL ) 

      SET IDENTITY_INSERT screens OFF 
  END 
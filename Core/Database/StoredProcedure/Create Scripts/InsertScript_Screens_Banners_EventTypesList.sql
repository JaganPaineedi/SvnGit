/*Core Screens and Banners for the Event Types List Page  
---Author: Rajeshwari S 
---Date: 22/11/2017 
---Task: Engineering Improvement Initiatives- NBL(I) 606#*/ 
---------------------------Screens----------------------------------------------------------- 
IF NOT EXISTS (SELECT * 
               FROM   Screens 
               WHERE  ScreenId = 1309) 
  BEGIN 
      SET IDENTITY_INSERT screens ON 

      INSERT INTO [Screens] 
                  (ScreenId, 
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
      VALUES      ( 1309, 
                    'Event Types', 
                    5762, 
                    '/ActivityPages/Admin/ListPages/EventTypeList.ascx', 
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
GO
---------------------------Banners----------------------------------------------------------- 
IF NOT EXISTS (SELECT * 
               FROM   Banners 
               WHERE  [ScreenId] = 1309) 
  BEGIN 
      INSERT INTO Banners 
                  (BannerName, 
                   DisplayAs, 
                   Active, 
                   DefaultOrder, 
                   Custom, 
                   TabId, 
                   ScreenId) 
      VALUES     ( 'Event Types', 
                   'Event Types', 
                   'Y', 
                   13, 
                   'Y', 
                   4, 
                   1309) 
  END 
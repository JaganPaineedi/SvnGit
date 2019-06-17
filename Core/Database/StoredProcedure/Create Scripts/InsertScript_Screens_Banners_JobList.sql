/*Core Screens and Banners for the SQL Jobs List Page  
---Author: Rajeshwari S 
---Date: 22/11/2017 */ 
---------------------------Screens----------------------------------------------------------- 
IF NOT EXISTS (SELECT * 
               FROM   Screens 
               WHERE  ScreenId = 1311) 
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
      VALUES      ( 1311, 
                    'SQL Jobs', 
                    5762, 
                    '/ActivityPages/Admin/ListPages/JobList.ascx', 
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
go 

---------------------------Banners----------------------------------------------------------- 
IF NOT EXISTS (SELECT * 
               FROM   Banners 
               WHERE  [ScreenId] = 1311) 
  BEGIN 
      INSERT INTO Banners 
                  (BannerName, 
                   DisplayAs, 
                   Active, 
                   DefaultOrder, 
                   Custom, 
                   TabId, 
                   ScreenId) 
      VALUES     ( 'SQL Jobs', 
                   'SQL Jobs', 
                   'Y', 
                   13, 
                   'N', 
                   4, 
                   1311) 
  END 

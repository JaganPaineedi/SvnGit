/*Core Screens and Banners for the School District List Page  
---Author: Pradeep Kumar Yadav
---Date: 22/11/2017 
---Task: PEP - Customization #10005 */ 
---------------------------Screens----------------------------------------------------------- 

IF NOT EXISTS (SELECT * 
               FROM   Screens 
               WHERE  ScreenId = 1317) 
  BEGIN 
      SET IDENTITY_INSERT screens ON 

      INSERT INTO [Screens] 
                  (screenid, 
                   [ScreenName], 
                   [ScreenType], 
                   [ScreenURL], 
                   [ScreenToolbarURL], 
                   [TabId])
                  
      VALUES     ( 1317, 
                    'School District', 
                    5762, 
                    '/Modules/Classroom/WebPages/SchoolDistrictList.ascx', 
                    NULL, 
                    4
                    ) 

      SET IDENTITY_INSERT screens OFF 
  END 
GO
---------------------------Banners---------------------------------------------------------------------- 
IF NOT EXISTS (SELECT * 
               FROM   Banners 
               WHERE  [ScreenId] = 1317) 
BEGIN
INSERT INTO Banners 
            (BannerName, 
             DisplayAs, 
             Active, 
             DefaultOrder, 
             Custom, 
             TabId, 
             ScreenId) 
VALUES     ( 'School District', 
             'School District', 
             'Y', 
             5, 
             'Y', 
             4, 
             1317)
END 



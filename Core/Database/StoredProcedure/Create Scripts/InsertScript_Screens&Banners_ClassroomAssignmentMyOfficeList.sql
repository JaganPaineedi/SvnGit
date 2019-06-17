/*Core Screens and Banners for the Classroom Assignments MyOffice List Page  
---Author: Pradeep Kumar Yadav
---Date: 19/03/2018	 
---Task: PEP - Customization #10005 */ 
---------------------------Screens----------------------------------------------------------- 

IF NOT EXISTS (SELECT * 
               FROM   Screens 
               WHERE  ScreenId = 1332) 
  BEGIN 
      SET IDENTITY_INSERT screens ON 

      INSERT INTO [Screens] 
                  (screenid, 
                   [ScreenName], 
                   [ScreenType], 
                   [ScreenURL], 
                   [ScreenToolbarURL], 
                   [TabId])
                  
      VALUES     ( 1332, 
                    'Classroom Assignments', 
                    5762, 
                    '/Modules/Classroom/WebPages/ClassroomAssignmentMyOfficeList.ascx', 
                    NULL, 
                    1
                    ) 

      SET IDENTITY_INSERT screens OFF 
  END 
GO
---------------------------Banners---------------------------------------------------------------------- 
IF NOT EXISTS (SELECT * 
               FROM   Banners 
               WHERE  [ScreenId] = 1332) 
BEGIN
INSERT INTO Banners 
            (BannerName, 
             DisplayAs, 
             Active, 
             DefaultOrder, 
             Custom, 
             TabId, 
             ScreenId) 
VALUES     ( 'Classroom Assignments', 
             'Classroom Assignments', 
             'Y', 
             5, 
             'N', 
             1, 
             1332)
END 






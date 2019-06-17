/*Core Screens and Banners for the Classroom Assignments List Page  
---Author: Pradeep Kumar Yadav
---Date: 19/03/2018	 
---Task: PEP - Customization #10005 */ 
---------------------------Screens----------------------------------------------------------- 

IF NOT EXISTS (SELECT * 
               FROM   Screens 
               WHERE  ScreenId = 1322) 
  BEGIN 
      SET IDENTITY_INSERT screens ON 

      INSERT INTO [Screens] 
                  (screenid, 
                   [ScreenName], 
                   [ScreenType], 
                   [ScreenURL], 
                   [ScreenToolbarURL], 
                   [TabId])
                  
      VALUES     ( 1322, 
                    'Classroom Assignments', 
                    5762, 
                    '/Modules/Classroom/WebPages/ClassroomAssignmentList.ascx', 
                    NULL, 
                    2
                    ) 

      SET IDENTITY_INSERT screens OFF 
  END 
GO
---------------------------Banners---------------------------------------------------------------------- 
IF NOT EXISTS (SELECT * 
               FROM   Banners 
               WHERE  [ScreenId] = 1322) 
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
             2, 
             1322)
END 






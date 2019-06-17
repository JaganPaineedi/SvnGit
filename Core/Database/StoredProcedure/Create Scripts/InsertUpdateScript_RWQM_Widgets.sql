/********************************************************************************                                                  
--  
-- Copyright: Streamline Healthcare Solutions  
--  
-- Purpose: Contacts/Flags/RWQM Widget.  
--  
-- Author:  Ponnin  
-- Date:    25-May-2018  
--  
** Date            Author              Purpose    
**  25-May-2018     Ponnin             What:Task #44 AHN-Customizations 
*********************************************************************************/ 


UPDATE Widgets set WidgetName='Contacts/Flags Widget' ,DisplayAs='Contacts/Flags Widget' where DisplayAs='Contacts/Flags/RWQM Widget' 
AND WidgetURL='/ActivityPages/Office/Summary/Widgets/ContactsFlags.ascx'



IF NOT EXISTS (SELECT * 
               FROM   WIDGETS 
               WHERE  WIDGETNAME = 'Contacts/Flags/RWQM Widget' AND WIDGETURL =  '/Modules/RWQM/WebPages/ContactsFlagsRWQMWidget.ascx' ) 
  BEGIN 
      INSERT INTO [dbo].[WIDGETS] 
                    ([WIDGETNAME] 
                   ,[WIDGETURL] 
                   ,[CUSTOMWIDGET] 
                   ,[WIDTH] 
                   ,[HEIGHT] 
                   ,[REFRESHINTERVAL] 
                   ,[AUTOREFRESHINTERVAL] 
                   ,[DISPLAYAS]) 
      SELECT 
             N'Contacts/Flags/RWQM Widget' 
             ,N'/Modules/RWQM/WebPages/ContactsFlagsRWQMWidget.ascx' 
             ,N'N' 
             ,1 
             ,1 
             ,400 
             ,77777 
             ,'Contacts/Flags/RWQM Widget' 
  END 

GO 
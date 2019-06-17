/********************************************************************************                                                  
--  
-- Copyright: Streamline Healthcare Solutions  
--  
-- Purpose: Adding Verbal/Queueorder Data to the Widget Table.  
--  
-- Author:  Anto  
-- Date:    14-July-2016  
--  
** Date            Author              Purpose    
** 14-July-2016     Anto             What:Task #312 Camino - Environment Issues Tracking 
*********************************************************************************/ 
IF NOT EXISTS (SELECT * 
               FROM   WIDGETS 
               WHERE  WIDGETNAME = 'Verbal/ Queued Orders') 
  BEGIN 
      INSERT INTO [dbo].[WIDGETS] 
                  ([CREATEDBY] 
                   ,[CREATEDDATE] 
                   ,[MODIFIEDBY] 
                   ,[MODIFIEDDATE] 
                   ,[WIDGETNAME] 
                   ,[WIDGETURL] 
                   ,[CUSTOMWIDGET] 
                   ,[WIDTH] 
                   ,[HEIGHT] 
                   ,[REFRESHINTERVAL] 
                   ,[AUTOREFRESHINTERVAL] 
                   ,[DISPLAYAS]) 
      SELECT N'ajenkins' 
             ,Getdate() 
             ,N'ajenkins' 
             ,Getdate() 
             ,N'Verbal/ Queued Orders' 
             ,N'/ActivityPages/Office/Summary/Widgets/VerbalQueueOrder.ascx' 
             ,N'N' 
             ,1 
             ,1 
             ,400 
             ,77777 
             ,'Verbal/Queued Orders - Awaiting Approval' 
  END 
ELSE 
  BEGIN 
      UPDATE WIDGETS 
      SET    CREATEDBY = N'ajenkins' 
             ,CREATEDDATE = Getdate() 
             ,MODIFIEDBY = N'ajenkins' 
             ,MODIFIEDDATE = Getdate() 
             ,WIDGETNAME = N'Verbal/ Queued Orders' 
             ,WIDGETURL = 
              N'/ActivityPages/Office/Summary/Widgets/VerbalQueueOrder.ascx' 
             ,CUSTOMWIDGET = N'N' 
             ,WIDTH = 1 
             ,HEIGHT = 1 
             ,REFRESHINTERVAL = 400 
             ,AUTOREFRESHINTERVAL = 77777 
             ,DISPLAYAS = 'Verbal/Queued Orders - Awaiting Approval' 
      WHERE  WIDGETNAME = 'Verbal/ Queued Orders' 
  END 

GO 
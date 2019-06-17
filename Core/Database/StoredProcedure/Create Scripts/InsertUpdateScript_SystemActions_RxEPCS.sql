-- =============================================  
-- Author:    Malathi Shiva 
-- Create date: May 6, 2016 
-- Description: To Enable EPCS related functionlities based on the EPCS System Actions Permission.  
/* 
Modified Date    Modidifed By    Purpose 
3 Mar 2016		Malathi Shiva	EPCS : Task# 1 - EPCS related functionalities will be enabled when this permission is given to a staff
*/ 
-- =============================================    

DECLARE @Action VARCHAR(20)
SET @Action = 'EPCS'

DECLARE @ActionId VARCHAR(20)
SET @ActionId = 10074

IF NOT EXISTS(SELECT * 
              FROM   SystemActions 
              WHERE  ApplicationId = 5 and ActionId = 10074) 
  BEGIN 
  
  SET IDENTITY_INSERT SystemActions ON
  
      INSERT INTO SystemActions 
                  (CreatedBy 
                   ,CreatedDate 
                   ,ModifiedBy 
                   ,ModifiedDate 
                   ,RowIdentifier 
                   ,Action 
                   ,ScreenName
                   ,ApplicationId
                   ,ActionId) 
      VALUES      ('mshiva' 
                   ,Getdate() 
                   ,'mshiva' 
                   ,Getdate() 
                   ,NEWID()  
                   ,@Action
                   ,@Action
                   ,5
                   ,@ActionId) 
                   
     SET IDENTITY_INSERT SystemActions OFF
  END 

GO 


-- =============================================  
-- Author:    Malathi Shiva 
-- Create date: July 9, 2018 
-- Description: To Enable PMP related functionlities based on the PMP System Actions Permission.  
/* 
Modified Date    Modidifed By    Purpose 
*/ 
-- =============================================    

DECLARE @Action VARCHAR(20)
SET @Action = 'PMP'

DECLARE @ActionId VARCHAR(20)
SET @ActionId = 10167

IF NOT EXISTS(SELECT 1
              FROM   SystemActions 
              WHERE  ApplicationId = 5 and ActionId = 10167) 
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
                   ,PageName
                   ,ApplicationId
                   ,ActionId) 
      VALUES      ('mshiva' 
                   ,Getdate() 
                   ,'mshiva' 
                   ,Getdate() 
                   ,NEWID()  
                   ,@Action
                   ,'Medication Management'
                   ,'Patient Summary'
                   ,5
                   ,@ActionId) 
                   
     SET IDENTITY_INSERT SystemActions OFF
  END 

GO 


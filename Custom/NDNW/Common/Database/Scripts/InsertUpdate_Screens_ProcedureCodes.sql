/*
-------- Insert Core Screen Script for Procedure Codes detail page -------------   
Created By: Malathi Shiva
Created Date: 26/Mar/2015
*/


IF NOT EXISTS(SELECT 1 
              FROM   Screens 
              WHERE  ScreenId = 454) 
  BEGIN 
      SET IDENTITY_INSERT Screens ON 

      INSERT INTO Screens 
                  (ScreenId 
                   ,CreatedBy 
                   ,CreatedDate 
                   ,ModifiedBy 
                   ,ModifiedDate 
                   ,ScreenName 
                   ,ScreenType 
                   ,ScreenURL 
                   ,TabId) 
      SELECT 454 
             ,'mshiva' 
             ,Getdate() 
             ,'mshiva' 
             ,Getdate() 
             ,'Procedure Code Details' 
             ,5761 
             ,'/ActivityPages/Admin/Detail/ProcedureRateGeneral.ascx' 
             ,4 

      SET IDENTITY_INSERT Screens OFF 
  END 
  
  
  IF NOT EXISTS(SELECT 1 
              FROM   Screens 
              WHERE  ScreenId = 452) 
  BEGIN 
      SET IDENTITY_INSERT Screens ON 

      INSERT INTO Screens 
                  (ScreenId 
                   ,CreatedBy 
                   ,CreatedDate 
                   ,ModifiedBy 
                   ,ModifiedDate 
                   ,ScreenName 
                   ,ScreenType 
                   ,ScreenURL 
                   ,TabId) 
      SELECT 452 
             ,'mshiva' 
             ,Getdate() 
             ,'mshiva' 
             ,Getdate() 
             ,'Procedure Code Details' 
             ,5761 
             ,'/ActivityPages/Admin/Detail/ProcedureRateBillingCode.ascx' 
             ,4 

      SET IDENTITY_INSERT Screens OFF 
  END 
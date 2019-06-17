/*
-------- Insert Core Screen Script for Client Authorization List Page -------------   
Created By: Malathi Shiva
Created Date: 26/Mar/2015
*/


IF NOT EXISTS(SELECT 1 
              FROM   Screens 
              WHERE  ScreenId = 740) 
  BEGIN 
      SET IDENTITY_INSERT Screens ON 

      INSERT INTO Screens 
                  (ScreenId 
                   ,ScreenName 
                   ,ScreenType 
                   ,ScreenURL 
                   ,ScreenToolbarURL 
                   ,TabId) 
      VALUES      ( 740 
                    ,'Authorizations' 
                    ,5762 
                    ,'/ActivityPages/Client/ListPages/ClientAuthList.ascx' 
                    ,NULL 
                    ,2 ) 

      SET IDENTITY_INSERT Screens OFF 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   Banners 
              WHERE  ScreenId = 740) 
  BEGIN 
      INSERT INTO Banners 
                  (BannerName 
                   ,DisplayAs 
                   ,Active 
                   ,DefaultOrder 
                   ,Custom 
                   ,TabId 
                   ,ScreenId) 
      VALUES      ( 'Authorizations' 
                    ,'Authorizations' 
                    ,'Y' 
                    ,65 
                    ,'N' 
                    ,2 
                    ,740) 
  END 

IF EXISTS(SELECT 1 
          FROM   Banners 
          WHERE  ScreenId = 21) 
  BEGIN 
      UPDATE Banners 
      SET    Active = 'N' 
      WHERE  ScreenId = 21 
  END 

IF EXISTS(SELECT 1 
          FROM   Banners 
          WHERE  ScreenId = 166) 
  BEGIN 
      UPDATE Banners 
      SET    Active = 'N' 
      WHERE  ScreenId = 166 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   ScreenPermissionControls 
              WHERE  ScreenId = 740) 
  BEGIN 
      INSERT INTO ScreenPermissionControls 
                  (ScreenId 
                   ,ControlName 
                   ,DisplayAs 
                   ,Active) 
      VALUES      ( 740 
                    ,'ButtonExport' 
                    ,'Export' 
                    ,'Y') 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   ScreenPermissionControls 
              WHERE  ScreenId = 740) 
  BEGIN 
      INSERT INTO ScreenPermissionControls 
                  (ScreenId 
                   ,ControlName 
                   ,DisplayAs 
                   ,Active) 
      VALUES      ( 740 
                    ,'ButtonNew' 
                    ,'New' 
                    ,'Y') 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   Screens 
              WHERE  ScreenId = 741) 
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
      SELECT 741 
             ,'mshiva' 
             ,Getdate() 
             ,'mshiva' 
             ,Getdate() 
             ,'Upload File Detail' 
             ,5765 
             ,'/ActivityPages/Office/Custom/UploadMedicalRecordDetail.ascx' 
             ,2 

      SET IDENTITY_INSERT Screens OFF 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   Screens 
              WHERE  ScreenId = 742) 
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
      SELECT 742 
             ,'mshiva' 
             ,Getdate() 
             ,'mshiva' 
             ,Getdate() 
             ,'Scanned Medical Record Detail' 
             ,5765 
             ,'/ActivityPages/Office/Custom/ScannedImageMedicalRecordDetail.ascx' 
             ,2 

      SET IDENTITY_INSERT Screens OFF 
  END 
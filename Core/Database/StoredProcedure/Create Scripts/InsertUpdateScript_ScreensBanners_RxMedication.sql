-- =============================================   
-- Author:    Malathi Shiva  
-- Create date: July 14, 2016  
-- Description: Added a Banner entry for Medication Pop up in My Office Tab and It redirects to the Rx Medication Pop up - Start Page 
/*  
Modified Date    Modidifed By    Purpose  
14 July 2016     Malathi Shiva   Camino - Environment Issues Tracking: Task# 311 - Added a Banner entry for Medication Pop up in My Office Tab and It redirects to the Rx Medication Pop up - Start Page 
*/ 
-- =============================================     
DECLARE @ScreenId   INT, 
        @ScreenName VARCHAR(100), 
        @ScreenType INT, 
        @ScreenURL  VARCHAR(200), 
        @TabId      INT, 
        @BannerName VARCHAR(100), 
        @DisplayAs  VARCHAR(100), 
        @Active     CHAR(1), 
        @DefaultOrder INT,
        @Custom     CHAR(1) 

SET @ScreenId = 1197 
SET @ScreenName = 'MedicationManagement' 
SET @ScreenType =5766 
SET @ScreenURL ='ActivityPages/Client/ExternalScreens/MedicationManagement.ascx' 
SET @TabId = 1 
SET @BannerName = 'Medications' 
SET @DisplayAs = 'Medications' 
SET @Active = 'Y' 
SET @DefaultOrder = 9999
SET @Custom = 'N' 

IF NOT EXISTS(SELECT * 
              FROM   Screens 
              WHERE  ScreenId = 1197) 
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
      VALUES      (@ScreenId 
                   ,'mshiva' 
                   ,Getdate() 
                   ,'mshiva' 
                   ,Getdate() 
                   ,@ScreenName 
                   ,@ScreenType 
                   ,@ScreenURL 
                   ,@TabId) 

      SET IDENTITY_INSERT Screens OFF 
  END 
ELSE 
  BEGIN 
      UPDATE Screens 
      SET    ScreenName = @ScreenName 
             ,ScreenType = @ScreenType 
             ,ScreenURL = @ScreenURL 
             ,TabId = @TabId 
      WHERE  ScreenId = 1197 
  END 

IF NOT EXISTS(SELECT * 
              FROM   Banners 
              WHERE  ScreenId = 1197) 
  BEGIN 
      INSERT INTO Banners 
                  (CreatedBy 
                   ,CreatedDate 
                   ,ModifiedBy 
                   ,ModifiedDate 
                   ,BannerName 
                   ,DisplayAs 
                   ,Active 
                   ,DefaultOrder, 
                   Custom 
                   ,TabId 
                   ,ScreenId) 
      VALUES      ('mshiva' 
                   ,Getdate() 
                   ,'mshiva' 
                   ,Getdate() 
                   ,@BannerName 
                   ,@DisplayAs 
                   ,@Active 
                   ,@DefaultOrder 
                   ,@Custom 
                   ,@TabId 
                   ,@ScreenId) 
  END 
ELSE 
  BEGIN 
      UPDATE Banners 
      SET    BannerName = @BannerName 
             ,DisplayAs = @DisplayAs 
             ,Active = @Active 
             , 
             --DefaultOrder= @DefaultOrder, 
             Custom = @Custom 
             ,TabId = @TabId 
             ,ScreenId = @ScreenId 
      WHERE  ScreenId = 1197 
  END 

GO 
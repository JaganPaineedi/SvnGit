 /********************************************************************************                                                          
-- Insert Script of Associated Documents.                                                         
--                                                          
-- Copyright: Streamline Healthcate Solutions                                                          
--                                                          
-- Purpose: To create the Associated documents Page #838 Threshold Enhancements.                                                        
--     Author    :  Sunil.D
---- Created Date: 12/09/2017                                                     
-- Updates:                                                                                                                 
-- Date        Author      Purpose    

*********************************************************************************/    
DECLARE @ScreenId INT
DECLARE @DocumentCodeId INT
DECLARE @ScreenName VARCHAR(100) 
DECLARE @ScreenType INT 
DECLARE @ScreenURL VARCHAR(200) 
DECLARE @ScreenToolbarURL VARCHAR(200) 
DECLARE @TabId INT 
DECLARE @ValidationStoredProcedureUpdate VARCHAR(500) 
DECLARE @ValidationStoredProcedureComplete VARCHAR(500) 
DECLARE @WarningStoredProcedureComplete VARCHAR(500) 
DECLARE @PostUpdateStoredProcedure VARCHAR(500) 
DECLARE @RefreshPermissionsAfterUpdate VARCHAR(500) 
DECLARE @HelpURL VARCHAR(500)='../Help/Thresh_Custom/overview.htm'


SET @ScreenId = 1263
SET @DocumentCodeId=null
SET @ScreenName = 'Associate Documents' 
SET @ScreenType = 5761 
SET @ScreenURL = '/Modules/AssociateDocuments/ActivityPages/Client/WebPages/AttachAssociateDocuments.ascx' 
SET @ScreenToolbarURL = NULL
SET @TabId = 2  
SET @ValidationStoredProcedureUpdate = NULL 
SET @ValidationStoredProcedureComplete= null
SET @WarningStoredProcedureComplete= NULL
SET @PostUpdateStoredProcedure= NULL
SET @RefreshPermissionsAfterUpdate= NULL 


IF NOT EXISTS (SELECT ScreenId 
               FROM   Screens 
               WHERE  ScreenId = @ScreenId) 
  BEGIN 
      SET IDENTITY_INSERT [dbo].[Screens] ON 

      INSERT INTO [Screens] 
                  ([ScreenId], 
                   [ScreenName], 
                   [ScreenType], 
                   [ScreenURL], 
                   [TabId],  
                   [ValidationStoredProcedureUpdate], 
                   [ValidationStoredProcedureComplete], 
                   [PostUpdateStoredProcedure], 
                   [RefreshPermissionsAfterUpdate], 
                   [DocumentCodeId]
                   ,HelpURL) 
      VALUES      ( @ScreenId, 
                    @ScreenName, 
                    @ScreenType, 
                    @ScreenURL, 
                    @TabId,
                    @ValidationStoredProcedureUpdate, 
                    @ValidationStoredProcedureComplete, 
                    @PostUpdateStoredProcedure, 
                    @RefreshPermissionsAfterUpdate, 
                    @DocumentCodeId
                    ,@HelpURL) 

      SET IDENTITY_INSERT [dbo].[Screens] OFF 
  END 
ELSE 
  BEGIN 
      UPDATE Screens 
      SET    ScreenName = @ScreenName, 
             ScreenType = @ScreenType, 
             ScreenURL = @ScreenURL, 
             TabId = @TabId,  
             ValidationStoredProcedureUpdate = @ValidationStoredProcedureUpdate, 
             ValidationStoredProcedureComplete = @ValidationStoredProcedureComplete, 
             PostUpdateStoredProcedure = @PostUpdateStoredProcedure, 
             RefreshPermissionsAfterUpdate = @RefreshPermissionsAfterUpdate, 
             DocumentCodeId = @DocumentCodeId,
             HelpURL = @HelpURL
      WHERE  ScreenId = @ScreenId
  END 
  
  
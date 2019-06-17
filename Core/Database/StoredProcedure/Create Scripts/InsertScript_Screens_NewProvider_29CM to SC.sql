/********************************************************************************                                                    
--    
-- Copyright: Streamline Healthcare Solutions    
--    
-- Purpose: Adding Screen for New Provider.
   
-- Author:  Rohith Uppin
-- Date:    10 SEP 2014


*********************************************************************************/ 
----------------------------------------   Screens Table   -----------------------------------  
/*   
  Please change these variables for supporting a new page/document/widget   
  Screen Types:   
    None:               0,   
        Detail:             5761,   
        List:               5762,   
        Document:           5763,   
        Summary:            5764,   
        Custom:             5765,   
        ExternalScreen:     5766   
*/

DECLARE @screenId INT 

DECLARE @ScreenName VARCHAR(500) 
DECLARE @TabId INT
DECLARE @ScreenType INT 
DECLARE @ScreenURL VARCHAR(500) 
DECLARE @ValidationStoredProcedureUpdate VARCHAR(500) 
DECLARE @ValidationStoredProcedureComplete VARCHAR(500) 
DECLARE @WarningStoredProcedureComplete VARCHAR(500) 
DECLARE @PostUpdateStoredProcedure VARCHAR(500) 
DECLARE @RefreshPermissionsAfterUpdate VARCHAR(500) 
DECLARE @InitializationStoredProcedure VARCHAR(500)

SET @screenId = 1038

SET @ScreenName = 'New Provider'
SET @TabId = 6
SET @ScreenType = 5765
SET @ScreenURL = 'Modules/CareManagement/ActivityPages/Provider/Detail/NewProvider.ascx'
SET @InitializationStoredProcedure = NULL
SET @ValidationStoredProcedureUpdate = NULL 
SET @ValidationStoredProcedureComplete=  NULL 
SET @WarningStoredProcedureComplete= NULL 
SET @PostUpdateStoredProcedure= NULL 
SET @RefreshPermissionsAfterUpdate= NULL 

IF NOT EXISTS (SELECT ScreenId FROM   Screens WHERE  ScreenId = @screenId) 
  BEGIN 
      SET IDENTITY_INSERT [dbo].[Screens] ON 

      INSERT INTO [Screens] 
                  ([ScreenId], 
                   [ScreenName], 
                   [ScreenType], 
                   [ScreenURL], 
                   [TabId], 
                   [InitializationStoredProcedure], 
                   [ValidationStoredProcedureUpdate], 
                   [ValidationStoredProcedureComplete], 
                   [PostUpdateStoredProcedure], 
                   [RefreshPermissionsAfterUpdate]) 
      VALUES      ( @screenId, 
                    @ScreenName, 
                    @ScreenType, 
                    @ScreenURL, 
                    @TabId, 
                    @InitializationStoredProcedure, 
                    @ValidationStoredProcedureUpdate, 
                    @ValidationStoredProcedureComplete, 
                    @PostUpdateStoredProcedure, 
                    @RefreshPermissionsAfterUpdate) 

      SET IDENTITY_INSERT [dbo].[Screens] OFF 
  END 
ELSE 
  BEGIN 
      UPDATE Screens 
      SET    ScreenName = @ScreenName, 
             ScreenType = @ScreenType, 
             ScreenURL = @ScreenURL, 
             TabId = @TabId, 
             InitializationStoredProcedure = @InitializationStoredProcedure, 
             ValidationStoredProcedureUpdate = @ValidationStoredProcedureUpdate, 
             ValidationStoredProcedureComplete = @ValidationStoredProcedureComplete, 
             PostUpdateStoredProcedure = @PostUpdateStoredProcedure, 
             RefreshPermissionsAfterUpdate = @RefreshPermissionsAfterUpdate             
      WHERE  ScreenId = @screenId 
  END
-----------------------------------------------END--------------------------------------------
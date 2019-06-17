IF EXISTS (SELECT * 
           FROM   SYS.objects 
           WHERE  object_id = 
                  Object_id(N'[dbo].[ssp_SCDeleteListPageFilterFavourites]') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[ssp_SCDeleteListPageFilterFavourites] 

GO 

SET ANSI_NULLS ON 

GO 

SET QUOTED_IDENTIFIER ON 

GO 

CREATE PROCEDURE [dbo].[ssp_SCDeleteListPageFilterFavourites] ( 
@Key          VARCHAR(MAX),
@UserCode		VARCHAR(250) ) 
AS 
  /******************************************************************************                                     
  **  File:                                   
  **  Name:                    
  **  Desc: Stored Procedure Used to store the Filter Value                    
  **  Return values:                                      
  **  Called by:                                      
  **  Parameters: @UserCode,ScreenId,@FilterValue                
  **  Auth:  Malathi Shiva               
                               
  *******************************************************************************                                     
  **  Change History                                     
  *******************************************************************************                                     
  **  Date:       Author:       Description:                                     
  **  --------    --------        ----------------------------------------------------                                     
  *******************************************************************************/ 
  BEGIN 
      BEGIN TRY
       
          IF( @Key > 0 ) 
            BEGIN 
				DECLARE @ScreenId INT 
				DECLARE @StaffId INT
				
				SELECT @ScreenId = SFT.ScreenId, @StaffId = SFT.StaffId
				FROM StaffScreenFilterFavorites SFT WHERE StaffScreenFilterFavoriteId = @Key
				
                UPDATE StaffScreenFilterFavorites
                SET RecordDeleted = 'Y'
					,DeletedBy = @UserCode
					,DeletedDate = GETDATE()
                WHERE StaffScreenFilterFavoriteId = @Key
                
				EXEC ssp_SCGetListPageFilterFavourites @ScreenId,@StaffId
            END 
          
      END TRY 

      BEGIN CATCH 
          DECLARE @Error VARCHAR(8000) 

          SET @Error= CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' 
                      + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) 
                      + '*****' 
                      + isnull(CONVERT(VARCHAR, ERROR_PROCEDURE()), 
                      'ssp_SCWebInsertFilters') 
                      + '*****' + CONVERT(VARCHAR, ERROR_LINE()) 
                      + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) 
                      + '*****' + CONVERT(VARCHAR, ERROR_STATE()) 

          RAISERROR ( @Error,-- Message text.                                   
                      16,-- Severity.                                   
                      1 -- State.                                   
          ); 
      END CATCH 
  END 

GO   
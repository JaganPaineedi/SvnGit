IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCInsertListPageFilterFavourites]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCInsertListPageFilterFavourites]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCInsertListPageFilterFavourites] ( 
@Key          VARCHAR(MAX) 
,@StaffId     INT 
,@ScreenId    INT 
,@FilterValue VARCHAR(MAX) 
,@FilterName  VARCHAR(250) 
,@UserCode    VARCHAR(100) 
,@ClientId    INT
,@ReportId INT = NULL) 
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
  **  18-JAN-2018 Akwinass      What: Added @ReportId and Modified code to get report favorites.
								Why: Task#554.1 in Engineering Improvement Initiatives- NBL(I).                                   
  *******************************************************************************/ 
  BEGIN 
      BEGIN TRY
      
      if(@ClientId = 0)
      BEGIN
      SET @ClientId = NULL
      END
      
      IF( @Key > 0 ) 
            BEGIN 
                UPDATE StaffScreenFilterFavorites 
                SET    FilterName = @FilterName 
                       ,FiltersXML = @FilterValue 
                       ,ModifiedBy = @UserCode 
                       ,ModifiedDate = Getdate() 
                       ,ScreenId = CASE WHEN ISNULL(@ScreenId,0) <= 0 THEN NULL ELSE @ScreenId END
                       ,StaffId = @StaffId
                       ,ReportId = CASE WHEN ISNULL(@ReportId,0) <= 0 THEN NULL ELSE @ReportId END 
                WHERE  StaffScreenFilterFavoriteId = @Key 
            END 
          ELSE 
            BEGIN 
                INSERT INTO StaffScreenFilterFavorites 
                            (FilterName 
                             ,StaffId 
                             ,ScreenId 
                             ,ClientId 
                             ,FiltersXML 
                             ,CreatedBy 
                             ,CreatedDate 
                             ,ModifiedBy 
                             ,ModifiedDate
                             ,ReportId) 
                VALUES     (@FilterName 
                            ,@StaffId 
                            ,CASE WHEN ISNULL(@ScreenId,0) <= 0 THEN NULL ELSE @ScreenId END 
                            ,@ClientId 
                            ,@FilterValue 
                            ,@UserCode 
                            ,Getdate() 
                            ,@UserCode 
                            ,Getdate()
                            ,CASE WHEN ISNULL(@ReportId,0) <= 0 THEN NULL ELSE @ReportId END) 
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



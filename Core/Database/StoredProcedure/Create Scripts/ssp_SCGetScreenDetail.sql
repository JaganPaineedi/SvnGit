IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'ssp_SCGetScreenDetail')
	BEGIN
		DROP  Procedure  ssp_SCGetScreenDetail
	END

GO

CREATE PROCEDURE [dbo].[ssp_SCGetScreenDetail]
(
@ScreenId int
)
AS
/******************************************************************************                    
**  File:                     
**  Name: [dbo].[ssp_SCGetScreenDetail]                 
**  Desc: It is used to get the details of screen                   
**                    
**  This template can be customized:                    
**                                  
**  Return values:                    
**                     
**  Called by:  Screen Detail Page                     
**                                  
**  Parameters:                  
**  Input                               
**  @ScreenId int                  
**  
**	Output:                     
**  Auth:    Vishant Garg                 
**  Date:    04/16/2012                 
*******************************************************************************                    
**  Change History                    
*******************************************************************************                    
**  Date:  Author:    Description:                    
**  --------  --------    -------------------------------------------                    
**  12/27/2018 Rajesh	Added screenobjectcollection - Engineering Improvement initiative - 579                      
*******************************************************************************/    
BEGIN
     BEGIN TRY
     SELECT 
	   [ScreenId]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[ModifiedBy]
      ,[ModifiedDate]
      ,[RecordDeleted]
      ,[DeletedBy]
      ,[DeletedDate]
      ,[ScreenName]
      ,[ScreenType]
      ,[ScreenURL]
      ,[ScreenToolbarURL]
      ,[TabId]
      ,[InitializationStoredProcedure]
      ,[ValidationStoredProcedureUpdate]
      ,[ValidationStoredProcedureComplete]
      ,[WarningStoredProcedureComplete]
      ,[PostUpdateStoredProcedure]
      ,[RefreshPermissionsAfterUpdate]
      ,[DocumentCodeId]
      ,[CustomFieldFormId]
      ,[HelpURL]
      ,[MessageReferenceType]
      ,[PrimaryKeyName]
      ,[WarningStoreProcedureUpdate]
      ,[KeyPhraseCategory]
      ,[ScreenParamters]
      FROM Screens 
      WHERE ScreenId=@ScreenId
      AND (RecordDeleted <> 'Y' OR RecordDeleted IS NULL) 
      
      
        SELECT     
			  ScreenObjectCollectionId    
			  ,ScreenId    
			  ,FormCollectionId    
			  ,CreatedBy    
			  ,CreatedDate    
			  ,ModifiedBy    
			  ,ModifiedDate    
			  ,RecordDeleted    
			  ,DeletedBy    
			  ,DeletedDate    
       FROM ScreenObjectCollections     
       WHERE     
			  ScreenId=@ScreenId      
			  AND (RecordDeleted <> 'Y' OR RecordDeleted IS NULL)
  
  
      END TRY
      BEGIN CATCH
      DECLARE @Error varchar(8000)                                                                                                                                      
      SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                                                                       
      + '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_SCGetScreenDetail')                                                                                                                                       
      + '*****' + CONVERT(VARCHAR,ERROR_LINE()) + '*****' + CONVERT(VARCHAR,ERROR_SEVERITY())                                                                                                                                       
      + '*****' + CONVERT(VARCHAR,ERROR_STATE())                                                                                                                     
      RAISERROR            
      (                                                                                
      @Error, -- Message text.                                                                                                    
      16, -- Severity.                         
      1 -- State.                                                                
      );       
      END CATCH
END

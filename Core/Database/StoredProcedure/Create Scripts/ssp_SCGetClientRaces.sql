
/****** Object:  StoredProcedure [dbo].[ssp_SCGetClientRaces]    Script Date: 05/15/2013 18:10:12 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetClientRaces]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetClientRaces]
GO



/****** Object:  StoredProcedure [dbo].[ssp_SCGetClientRaces]    Script Date: 05/15/2013 18:10:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCGetClientRaces]
	@ClientId int
/*********************************************************************                                                                                          
-- Stored Procedure: dbo.ssp_SCGetClientInformation                                                                                                                             
-- Copyright: 2005 Streamline Healthcare Solutions,  LLC                                                                                           
-- Creation Date:    7/24/05                                                                                          
--                                                                                           
-- Purpose:  Return Tables for ClientInformations and fill the type Dataset                                                                                          
--                                                                                          
-- Updates:                                                                                          
--   Date       Author        Purpose                                                                                          
--  23-05-2014  Vkhare       Added ClientDemographicInformationDeclines   table  
--  29-04-2015	PradeepA	 Added ClientPictures table
--  17 May 2016 Varun Added ClientEthnicities table
                Ref: Meaningful Use Stage 3 - #4
*************************************  ********************************/                                                                                                                               

AS
BEGIN
 BEGIN TRY 
	SELECT     ClientRaceId, ClientId, RaceId, RowIdentifier, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted, DeletedDate, DeletedBy                                            
FROM         ClientRaces                                            
WHERE     (ClientId = @ClientID) AND (RecordDeleted IS NULL OR                                            
  RecordDeleted = 'N')   
  
  
SELECT   ClientDemographicInformationDeclineId,
CreatedBy,
CreatedDate,
ModifiedBy,
ModifiedDate,
RecordDeleted,
DeletedBy,
DeletedDate,
ClientId,
ClientDemographicsId FROM ClientDemographicInformationDeclines WHERE     (ClientId = @ClientID) AND (RecordDeleted IS NULL OR                                            
  RecordDeleted = 'N')     
  
   EXEC SSP_GetClientPicture @ClientId,'N'
   
   --ClientEthnicities
  SELECT [ClientEthnicityId]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[ModifiedBy]
      ,[ModifiedDate]
      ,[RecordDeleted]
      ,[DeletedDate]
      ,[DeletedBy]
      ,[ClientId]
      ,[EthnicityId]
  FROM [dbo].[ClientEthnicities]
  WHERE     (ClientId = @ClientID) AND  ISNULL(RecordDeleted, 'N') = 'N' 
   
END TRY                                                      
                                                                                      
BEGIN CATCH          
        
DECLARE @Error varchar(8000)                                                       
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                     
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_SCGetClientRaces')                                                                                     
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                      
    + '*****' + Convert(varchar,ERROR_STATE())                                   
 RAISERROR                                                                                     
 (                                                       
  @Error, -- Message text.                                                                                    
  16, -- Severity.                                                                                    
  1 -- State.                                                                                    
 );                                                                                 
END CATCH     
END

GO



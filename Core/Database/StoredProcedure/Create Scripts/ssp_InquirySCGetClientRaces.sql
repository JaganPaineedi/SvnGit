/****** Object:  StoredProcedure [dbo].[ssp_InquirySCGetClientRaces]    Script Date: 06/11/2018 03:53:09 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_InquirySCGetClientRaces]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_InquirySCGetClientRaces]
GO

/****** Object:  StoredProcedure [dbo].[ssp_InquirySCGetClientRaces]   Script Date: 06/11/2018 03:53:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_InquirySCGetClientRaces]          
 --@ClientId int      
 @InquiryId int        
/*********************************************************************                                                                                                    
-- Stored Procedure: dbo.ssp_SCGetClientInformation                                                                                                                                       
-- Copyright: 2005 Streamline Healthcare Solutions,  LLC                                                                                                     
-- Creation Date:    7/24/05                                                                                                    
--                                                                                                     
-- Purpose:  Return Tables for ClientInformations and fill the type Dataset                                                                                                    
--                                                                                                    
-- Updates:                                                                                                    
--   Date       Author        Purpose                                                                                                    
--  23-05-2014  RK       Get the client Races, DemographicInformationDecline and  Ethnicities         
*************************************  ********************************/                                                                                                                                         
          
AS          
BEGIN          
 BEGIN TRY           
 SELECT     InquiryClientRaceId, InquiryId, RaceId,  CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted, DeletedDate, DeletedBy                                                      
FROM        InquiryClientRaces                                                      
WHERE     (InquiryId = @InquiryId) AND (RecordDeleted IS NULL OR                                                      
  RecordDeleted = 'N')             
            
SELECT   InquiryClientDemographicInformationDeclineId,          
CreatedBy,          
CreatedDate,          
ModifiedBy,          
ModifiedDate,          
RecordDeleted,          
DeletedBy,          
DeletedDate,          
InquiryId,          
ClientDemographicsId FROM InquiryClientDemographicInformationDeclines WHERE     (InquiryId = @InquiryId) AND (RecordDeleted IS NULL OR                                                      
  RecordDeleted = 'N')               
            
   --ClientEthnicities          
  SELECT [InquiryClientEthnicityId]          
      ,[CreatedBy]          
      ,[CreatedDate]          
      ,[ModifiedBy]          
      ,[ModifiedDate]          
      ,[RecordDeleted]          
      ,[DeletedDate]          
      ,[DeletedBy]          
      ,[InquiryId]          
      ,[EthnicityId]          
  FROM [dbo].[InquiryClientEthnicities]          
  WHERE     (InquiryId = @InquiryId) AND  ISNULL(RecordDeleted, 'N') = 'N'           
       
    --ClientPictures           
    EXEC SSP_GetInquiryClientPicture @InquiryId,'N'   --EarlierValue 'N" rk      
          
             
END TRY                                                                
                                                                                                
BEGIN CATCH                    
                  
DECLARE @Error varchar(8000)                                                                 
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                               
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_InquirySCGetClientRaces')                                                                                               
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
IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = Object_id(N'[dbo].[ssp_InitDocumentRevokeROI]') 
                  AND type IN ( N'P', N'PC' )) 
  BEGIN 
      DROP PROCEDURE [dbo].[ssp_InitDocumentRevokeROI] 
  END 

go 

/********************************************************************************                                                    
-- Stored Procedure: ssp_InitDocumentRevokeROI     550,2 ,null
--     
-- Copyright: Streamline Healthcare Solutions     
--     
-- Purpose:initialization     
--     
-- Author:  Alok Kumar 
-- Date:    22 November 2017  
-- Ref:		Task#2013 Spring River - Customizations

Modified Date      Modified By      Description 

*********************************************************************************/ 
CREATE PROCEDURE [ssp_InitDocumentRevokeROI] 
--897,50062,N'' 
(@StaffId          INT, 
 @ClientId         INT, 
 @CustomParameters XML) 
AS 
  BEGIN 
      BEGIN try 
          SELECT TOP 1 'DocumentRevokeReleaseOfInformations' AS TableName 
						,-1  AS  [DocumentVersionId] 
						,DRRI.CreatedBy
						,DRRI.CreatedDate
						,DRRI.ModifiedBy
						,DRRI.ModifiedDate
						,DRRI.RecordDeleted
						,DRRI.DeletedDate
						,DRRI.DeletedBy
						,DRRI.ClientInformationReleaseId 
						--,CONVERT(DATETIME, CONVERT(VARCHAR(10), Getdate(), 101)) AS [RevokeEndDate]
						,Getdate() AS [RevokeEndDate] 
          FROM   SystemConfigurations s 
                 LEFT OUTER JOIN DocumentRevokeReleaseOfInformations DRRI
                              ON s.databaseversion = -1 
      END try 

      BEGIN catch 
          DECLARE @Error VARCHAR(8000) 

          SET @Error= CONVERT(VARCHAR, Error_number()) + '*****' 
                      + CONVERT(VARCHAR(4000), Error_message()) 
                      + '*****' 
                      + Isnull(CONVERT(VARCHAR, Error_procedure()), 
                      'ssp_InitDocumentRevokeROI' ) 
                      + '*****' + CONVERT(VARCHAR, Error_line()) 
                      + '*****' + CONVERT(VARCHAR, Error_severity()) 
                      + '*****' + CONVERT( VARCHAR, Error_state()) 

          RAISERROR ( @Error, 
                      -- Message text.                                                                                                                                    
                      16, 
                      -- Severity.                                                                                                                                                                                                                         
                      1 
          -- State.                                                                                                                                                                                                                                             
          ); 
      END catch 
  END 
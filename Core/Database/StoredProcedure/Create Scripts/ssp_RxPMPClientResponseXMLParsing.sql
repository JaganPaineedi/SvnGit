IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = 
                  Object_id(N'[dbo].[ssp_RxPMPClientResponseXMLParsing]' 
                  ) 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[ssp_RxPMPClientResponseXMLParsing] 

GO 

SET ANSI_NULLS ON 

GO 

SET QUOTED_IDENTIFIER ON 

GO 

CREATE PROCEDURE [dbo].[ssp_RxPMPClientResponseXMLParsing] @PMPAuditTrailId INT 
/*    
Store Procedure : exec ssp_RxPMPClientResponseXMLParsing 1  
Created Date  : 09/July/2018       
Author      : Malathi Shiva   
Purpose      : Multi-Customer Project: Task# 2 - Rx - This sp is used to split the Respose XML received from the PMP gateway and inserting the Narx Scores and Narx Messages into respective tables   
     
*/ 
AS 
  BEGIN 
      BEGIN TRY 

          DECLARE @docHandle INT 
          DECLARE @xVar NVARCHAR(MAX) 

          SELECT @xVar = Replace(Cast(AT.ResponseMessageXML AS NVARCHAR(max)), 
                         N' xmlns="http://xml.appriss.com/gateway/v5_1"', 
                         '') 
          FROM   PMPAuditTrails AS AT 
          WHERE  AT.PMPAuditTrailId = @PMPAuditTrailId 

          -- this text throws off the "preparedocument" call     
          SET @xVar = Replace(@xVar, '<?xml version="1.0" encoding="utf-8"?>', 
                      '') 

          EXEC sp_xml_preparedocument 
            @docHandle OUTPUT, 
            @xVar 
            

          INSERT INTO #NarxScoreresults 
                         (ScoreType 
                       ,ScoreValue) 
          SELECT ScoreType 
                 ,ScoreValue 
          FROM   OPENXML(@docHandle, N'/PatientResponse/Report/NarxScores/Score' 
                 , 
                 3) 
                    WITH (ScoreType   VARCHAR(15) 
                          ,ScoreValue VARCHAR(15)) 

          INSERT INTO #NarxMessageresults 
                      (MessageType 
                       ,MessageText 
                       ,MessageSeverity) 
          SELECT MessageType 
                 ,MessageText 
                 ,MessageSeverity 
          FROM   OPENXML(@docHandle, 
                 N'/PatientResponse/Report/NarxMessages/Message', 
                 3) 
                    WITH (MessageType      VARCHAR(150) 
                          ,MessageText     VARCHAR(max) 
                          ,MessageSeverity VARCHAR(10)) 

          INSERT INTO #NarxReportURL 
               (ViewableReport) 
          SELECT ViewableReport 
          FROM   OPENXML(@docHandle, 
                 N'/PatientResponse/Report/ReportRequestURLs', 
                 3) 
                    WITH (ViewableReport VARCHAR(250)) 

          EXEC sp_xml_removedocument 
            @docHandle 
            
      END TRY 

      BEGIN CATCH 
          DECLARE @Error VARCHAR(8000) 

          SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' 
                       + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) 
                       + '*****' 
                       + isnull(CONVERT(VARCHAR, ERROR_PROCEDURE()), 
                       'ssp_ValidationProviderAuthorizationDefault') 
                       + '*****' + CONVERT(VARCHAR, ERROR_LINE()) 
                       + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) 
                       + '*****' + CONVERT(VARCHAR, ERROR_STATE()) 
      END CATCH 
  END 
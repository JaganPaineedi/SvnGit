IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = Object_id(N'[dbo].[ssp_RxUpdatePMPAuditTrails]') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[ssp_RxUpdatePMPAuditTrails] 

GO 

SET ANSI_NULLS ON 

GO 

SET QUOTED_IDENTIFIER ON 

GO 

CREATE PROCEDURE [dbo].[ssp_RxUpdatePMPAuditTrails] ( @PMPAuditTrailId   INT 
                                                    ,@ResponseXML VARCHAR(MAX))    
/*    
Store Procedure : exec ssp_RxUpdatePMPAuditTrails 27, '"\"<?xml version=\\\"1.0\\\" encoding=\\\"UTF-8\\\"?>\\n<PatientResponse xmlns=\\\"http://xml.appriss.com/gateway/v5_1\\\">\\n  <RequestId>689448</RequestId>\\n  <LicenseeRequestId>EDB6A708-AB35-4768-AB94-B3B9CD78357A</LicenseeRequestId>\\n  <Report>\\n    <ResponseDestinations>\\n      <Pmp>OH</Pmp>\\n      <Pmp>KS</Pmp>\\n    </ResponseDestinations>\\n    <NarxScores>\\n      <Score>\\n        <ScoreType>Narcotics</ScoreType>\\n        <ScoreValue>170</ScoreValue>\\n      </Score>\\n      <Score>\\n        <ScoreType>Stimulants</ScoreType>\\n        <ScoreValue>000</ScoreValue>\\n      </Score>\\n      <Score>\\n        <ScoreType>Sedatives</ScoreType>\\n        <ScoreValue>432</ScoreValue>\\n      </Score>\\n      <Score>\\n        <ScoreType>Overdose</ScoreType>\\n        <ScoreValue>130</ScoreValue>\\n      </Score>\\n    </NarxScores>\\n    <Message>We were unable to retrieve prescription data from your state PMP (Reference #689448).</Message>\\n    <ReportExpiration>2018-07-26T18:28:35Z</ReportExpiration>\\n    <ReportRequestURLs>\\n      <ViewableReport Content-Type=\\\"text/html\\\">https://gateway-ssl-prep.pmp.appriss.com/v5_1/report/461051</ViewableReport>\\n    </ReportRequestURLs>\\n  </Report>\\n  <Response>\\n    <ResponseDestinations>\\n      <Pmp>MI</Pmp>\\n    </ResponseDestinations>\\n    <Error>\\n      <Message> There was a problem at pmp interconnect making this request : \\n    There was an HTTP error from trying to contact Michigan. response code : 503\\n  </Message>\\n      <Details><![CDATA[Details of error can be found at https://gateway-prep.pmp.appriss.com/error_details/427456]]></Details>\\n      <Source>PMP</Source>\\n    </Error>\\n  </Response>\\n  <Disclaimer>Disclaimer: PMP Gateway, NARxCHECK, and NarxCare rely upon data provided by state Prescription Monitoring Programs. You agree that you are solely responsible for the medical decisions made using this information and agree to indemnify and hold harmless, the providers of this service and the information for all claims based on your use thereof. If you believe the information is incomplete, please log into the state prescription monitoring program website to verify.</Disclaimer>\\n</PatientResponse>\\n\""'  
Created Date  : 09/July/2018       
Author      : Malathi Shiva   
Purpose      : Multi-Customer Project: Task# 2 - Rx - To split the Respose XML received from the PMP gateway and inserting the Narx Scores and Narx Messages into respective tables   
     
*/ 
AS 
  BEGIN 
      BEGIN TRY 
          DECLARE @ReportURL VARCHAR(250) 
          DECLARE @StaffId INT
          DECLARE @ClientId INT
          
          CREATE TABLE #NarxScoreresults 
            ( 
               ScoreType   VARCHAR(15) 
               ,ScoreValue VARCHAR(3) 
            ) 

          CREATE TABLE #NarxMessageresults 
            ( 
               MessageType      VARCHAR(150) 
               ,MessageText     VARCHAR(max) 
               ,MessageSeverity VARCHAR(10) 
            ) 

          CREATE TABLE #NarxReportURL 
            ( 
               ViewableReport VARCHAR(250) 
            ) 
            
          CREATE TABLE #PatientResponseError
            ( 
               [Message] VARCHAR(max) 
            ) 
            
 SET @ResponseXML = REPLACE(@ResponseXML, '"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<PatientResponse xmlns=\"http://xml.appriss.com/gateway/v5_1\">\n', '<?xml version="1.0" encoding="UTF-8"?><PatientResponse xmlns="http://xml.appriss.com/gateway/v5_1">');        
   SET @ResponseXML = REPLACE(@ResponseXML, '\n"', ''); 
SET @ResponseXML = REPLACE(@ResponseXML, '\n', '');   
    SET @ResponseXML = REPLACE(@ResponseXML, '\"', '"'); 
		
		SELECT  @StaffId = AT.StaffId, @ClientId = AT.ClientId
		FROM PMPAuditTrails AT
		WHERE AT.PMPAuditTrailId = @PMPAuditTrailId
		
          UPDATE PMPAuditTrails 
          SET    ResponseDateTime = Getdate() 
                 ,ResponseMessageXML = CONVERT(XML,@ResponseXML) 
                 ,PMPConnectionStatus = 'RESPONSE RECEIVED SUCCESSFULLY' 
          WHERE  PMPAuditTrailId = @PMPAuditTrailId 

          --EXEC ssp_RxPMPClientResponseXMLParsing 
          --  @PMPAuditTrailId = @PMPAuditTrailId 


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
                    
         INSERT INTO #PatientResponseError 
               ([Message]) 
          SELECT [Message] 
          FROM   OPENXML(@docHandle, 
                 N'/PatientResponse/Response/Error', 
                 3) 
                    WITH ([Message] VARCHAR(250))
                    
                    
          INSERT INTO #PatientResponseError 
               ([Message]) 
          SELECT [Message] 
          FROM   OPENXML(@docHandle, 
                 N'/PatientResponse/Response/Disallowed', 
                 3) 
                 WITH ([Message] VARCHAR(250))  

          EXEC sp_xml_removedocument 
            @docHandle 
            
            
          DELETE CN 
          FROM   ClientNarxScores CN 
                 LEFT JOIN PMPAuditTrails AT 
                        ON AT.PMPAuditTrailId = CN.PMPAuditTrailId 
          WHERE  AT.PMPAuditTrailId = @PMPAuditTrailId 

          DELETE CN 
          FROM   ClientNarxMessages CN 
                 LEFT JOIN PMPAuditTrails AT 
                        ON AT.PMPAuditTrailId = CN.PMPAuditTrailId 
          WHERE  AT.PMPAuditTrailId = @PMPAuditTrailId

          INSERT INTO ClientNarxScores 
                      (CreatedBy 
                       ,CreatedDate 
                       ,ModifiedBy 
                       ,ModifiedDate 
                       ,PMPAuditTrailId 
                       ,ScoreType 
                       ,ScoreValue) 
          SELECT @StaffId 
                 ,Getdate() 
                 ,@StaffId 
                 ,Getdate() 
                 ,@PMPAuditTrailId 
                 ,ScoreType 
                 ,ScoreValue 
          FROM   #NarxScoreresults 

          INSERT INTO ClientNarxMessages 
                      (CreatedBy 
                       ,CreatedDate 
                       ,ModifiedBy 
                       ,ModifiedDate 
                       ,PMPAuditTrailId 
                       ,MessageType 
                       ,MessageText 
                       ,MessageSeverity) 
          SELECT @StaffId 
                 ,Getdate() 
                 ,@StaffId 
                 ,Getdate() 
                 ,@PMPAuditTrailId 
                 ,MessageType 
                 ,MessageText 
                 ,MessageSeverity 
          FROM   #NarxMessageresults 

          UPDATE PMPAuditTrails 
          SET    ReportURL = (SELECT ViewableReport 
                              FROM   #NarxReportURL) 
          WHERE  PMPAuditTrailId = @PMPAuditTrailId 
          
          --Report request Generation sp 
          DECLARE @ReportRequestMessageXML  VARCHAR(MAX)
		  exec ssp_RxPMPReportRequestXMLGeneration @ClientId,@StaffId,@XMLData = @ReportRequestMessageXML OUTPUT
          
          UPDATE PMPAuditTrails 
          SET    ReportRequestDateTime = GETDATE()
				,ReportRequestMessageXML = CONVERT(XML,@ReportRequestMessageXML)
          WHERE  PMPAuditTrailId = @PMPAuditTrailId 
          
          SELECT ReportURL = (SELECT ViewableReport 
                              FROM   #NarxReportURL), ReportRequestMessageXML
                 ,PatientResponseErrorMsg = (SELECT TOP 1 [Message] 
                              FROM   #PatientResponseError)
          FROM PMPAuditTrails
          WHERE  PMPAuditTrailId = @PMPAuditTrailId 
          

          DROP TABLE #NarxMessageresults 
          DROP TABLE #NarxScoreresults 
          DROP TABLE #NarxReportURL 
          
         
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
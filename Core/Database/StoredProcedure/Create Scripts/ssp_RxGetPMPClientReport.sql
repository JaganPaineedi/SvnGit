IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = Object_id(N'[dbo].[ssp_RxGetPMPClientReport]') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[ssp_RxGetPMPClientReport] 

GO 

SET ANSI_NULLS ON 

GO 

SET QUOTED_IDENTIFIER ON 

GO 

CREATE PROCEDURE [dbo].[ssp_RxGetPMPClientReport]  ( @PMPAuditTrailId   INT 
                                                    ,@ReportResponseXML VARCHAR(MAX)) 
             
/*    
Store Procedure : exec ssp_RxGetPMPClientReport 50,'"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<ReportResponse xmlns=\"http://xml.appriss.com/gateway/v5_1\">\n  <ReportRequestId>273697</ReportRequestId>\n  <Error>\n    <Message>MI PMP requires authorization and this provider is not allowed to make requests.</Message>\n    <Source>GATEWAY</Source>\n  </Error>\n</ReportResponse>\n"'
Created Date    : 09/July/2018       
Author          : Malathi Shiva   
Purpose         : Multi-Customer Project: Task# 2 - Rx - To save the Report Response XML received from the PMP gateway and saving the Report URL 
     
*/    
AS     
 BEGIN           
          
  BEGIN TRY   
   
  SET @ReportResponseXML = REPLACE(@ReportResponseXML, '"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<ReportResponse xmlns=\"http://xml.appriss.com/gateway/v5_1\">\n  ', '<?xml version="1.0" encoding="UTF-8"?><ReportResponse xmlns="http://xml.appriss.com/gateway/v5_1">');        
   SET @ReportResponseXML = REPLACE(@ReportResponseXML, '\n"', ''); 
SET @ReportResponseXML = REPLACE(@ReportResponseXML, '\n', '');   
    SET @ReportResponseXML = REPLACE(@ReportResponseXML, '\"', '"'); 
    
    
 		 UPDATE PMPAuditTrails 
          SET    ReportResponseDateTime = GETDATE(),
				 ReportResponseMessageXML = CONVERT(XML,@ReportResponseXML)
          WHERE  PMPAuditTrailId = @PMPAuditTrailId 
          
                    
		  DECLARE @docHandle INT 
          DECLARE @xVar NVARCHAR(MAX) 

          SELECT @xVar = Replace(Cast(AT.ReportResponseMessageXML AS NVARCHAR(max)), 
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
          

 CREATE TABLE #ReportResults 
            ( 
               ReportLink   VARCHAR(MAX) 
            ) 
            

          INSERT INTO #ReportResults 
                         (ReportLink) 
          SELECT ReportLink
          FROM   OPENXML(@docHandle, N'/ReportResponse' 
                 , 
                 3) 
                    WITH (ReportLink   VARCHAR(100)) 


                     
		  DECLARE @ErrorMessage VARCHAR(MAX)
 
		  SELECT @ErrorMessage = [Message]
          FROM   OPENXML(@docHandle, N'/ReportResponse/Error' 
                 , 
                 3) 
                    WITH ([Message]   VARCHAR(100)) 
                    
                    
          UPDATE PMPAuditTrails 
          SET    ReportURL = (SELECT ReportLink 
                              FROM   #ReportResults) 
          WHERE  PMPAuditTrailId = @PMPAuditTrailId 

	Drop table #ReportResults
    
  SELECT ReportURL, @ErrorMessage as ErrorMessage  from  PMPAuditTrails 
  where PMPAuditTrailId = @PMPAuditTrailId
   AND ISNULL(RecordDeleted,'N')='N'  
 
 
  END TRY   
  
  BEGIN CATCH          
   DECLARE @Error VARCHAR(8000)                                 
   SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****'    
    + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'    
    + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),    
       'ssp_RxGetPMPClientReport') + '*****'    
    + CONVERT(VARCHAR, ERROR_LINE()) + '*****'    
    + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****'    
    + CONVERT(VARCHAR, ERROR_STATE())                                                              
   RAISERROR                                                               
  (                                                              
   @Error, -- Message text.                                                          
   16, -- Severity.                                                              
   1 -- State.                                                              
  );                      
  END CATCH          
        
 END 
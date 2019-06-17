   
IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = Object_id(N'ssp_NCPDPGetRequest') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE ssp_NCPDPGetRequest

GO 

SET ANSI_NULLS ON 

GO 

SET QUOTED_IDENTIFIER ON 

GO 



CREATE PROCEDURE ssp_NCPDPGetRequest
/*****************************************************************************************************/
/*
Stored Procedure: dbo.ssp_NCPDPGetRequest

Purpose:
	Get NCPDP Requests

Input Parameters:
 
Output Parameters:

Return:
	None

Calls:

Called by:
	Surescripts Client Windows Service
Created By- Pranay Bodhu
Created Date- 09/28/2018
Modifications:
Date                          ModifiedBy                          Purpose
	
*/
/*****************************************************************************************************/
AS
    BEGIN TRY
      
        SELECT  PMPAuditTrailId ,
                RequestMessageXML
        FROM    dbo.PMPAuditTrails
        WHERE   RequestType = 'X'
                AND ISNULL(RecordDeleted, 'N') = 'N'
                AND ResponseMessageXML IS  NULL
                AND ISNULL(PMPConnectionStatus, '') = ''
				ORDER BY RequestDateTime ASC
				;
    END TRY
    BEGIN CATCH

        DECLARE @Error VARCHAR(8000);                                 
        SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****'
            + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
            + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),
                     'ssp_NCPDPGetRequest') + '*****'
            + CONVERT(VARCHAR, ERROR_LINE()) + '*****'
            + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****'
            + CONVERT(VARCHAR, ERROR_STATE());                                                              
        RAISERROR                                                               
  (                                                              
   @Error, -- Message text.                                                          
   16, -- Severity.                                                              
   1 -- State.                                                              
  );                           
    END CATCH;	



GO



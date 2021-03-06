   
IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = Object_id(N'ssp_NCPDPUpdateMessageStatus') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE ssp_NCPDPUpdateMessageStatus

GO 

SET ANSI_NULLS ON 

GO 

SET QUOTED_IDENTIFIER ON 

GO 


Create PROCEDURE ssp_NCPDPUpdateMessageStatus
/*****************************************************************************************************/
/*
Stored Procedure: dbo.ssp_NCPDPUpdateMessageStatus

Purpose:
	Update message status from Surescripts based on response.

Input Parameters:
   @RequestId varchar(35)		-- Surescripts message Id
   @StatusDescription varchar(250)			-- status description
   @responseText type_Comment2				-- Raw xml of the message


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
    @RequestId VARCHAR(35) ,
    @StatusCode VARCHAR(250) ,
    @responseText type_Comment2
AS
    BEGIN TRY
      
        IF ( ISNULL(@RequestId, '') != '' )
            BEGIN TRAN;
        BEGIN
              
            UPDATE  dbo.PMPAuditTrails
            SET     ModifiedBy = 'SSService' ,
                    ModifiedDate = GETDATE() ,
                    ResponseDateTime = GETDATE() ,
                    ResponseMessageXML = @responseText ,
                    PMPConnectionStatus = @StatusCode
            WHERE   RequestType = 'X'
                    AND PMPAuditTrailId = @RequestId
                    AND ISNULL(RecordDeleted, 'N') = 'N';
        END;
        
        COMMIT TRAN;
    END TRY
    BEGIN CATCH

        IF @@trancount > 0
            ROLLBACK TRAN;            
    END CATCH	


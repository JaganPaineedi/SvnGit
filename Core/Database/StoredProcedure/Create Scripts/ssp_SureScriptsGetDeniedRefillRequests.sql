IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SureScriptsGetDeniedRefillRequests]') AND type in (N'P', N'PC'))
DROP PROCEDURE ssp_SureScriptsGetDeniedRefillRequests
GO


CREATE PROCEDURE [dbo].[ssp_SureScriptsGetDeniedRefillRequests]
AS /*****************************************************************************************************/
/*
Stored Procedure: dbo.ssp_SureScriptsGetDeniedRefillRequests

Copyright: 2011 Streamline Healthcare Solutions, LLC

Creation Date:  2011.03.04

Purpose:
	Get refill request responses that have been denied but not sent to Surescripts yet.

Input Parameters: None

Output Parameters:

Return:
	Data table with format as required by windows service

Calls:

Called by:
	Surescripts Client Windows Service

Log:
	2011.03.04 - Created.

Sept 9, 2013 - Kalpers changed the date written to use ssf_SureScriptsFormatDate to format the date and changed the date field size from 8 to 10 characters
Sept 9, 2013 - Kalpers replaced customSurescriptsRefillDenials with SurescriptsRefillDenials
Oct 8, 2013 - Kalpers added DenialMessageId
Feb 2, 2018-PranyB Added @tempRESPONSE_XML AspenPointe SGL #712: Controlled substance errors
*/
/*****************************************************************************************************/
    BEGIN TRY

        DECLARE @STATUSINQUEUE INT ,
            @STATUSPENDING INT ,
            @MESSAGESTATUSAWAITINGCREATION INT
        DECLARE @tempRESPONSE_XML XML
        SET @STATUSINQUEUE = 5561
        SET @STATUSPENDING = 5562
        SET @MESSAGESTATUSAWAITINGCREATION = 5541

        BEGIN TRAN

        DECLARE @results TABLE
            (
              SurescriptsRefillRequestId INT ,
              DenialReasonCode VARCHAR(2) ,
              DenialReasonText VARCHAR(70) ,
              SurescriptsOutgoingMessageId INT ,
              RequestXML type_Comment2,             -- The xml of the original refill request
			  DenialMessageId VARCHAR(35)
            )



        DECLARE @currRefillRequestId INT ,
            @currDenialReasonCode VARCHAR(2) ,
            @currDenialReasonText VARCHAR(70) ,
            @currRequestXML type_Comment2,
			@DenialMessageId VARCHAR(35)


        DECLARE curDeniedRequests CURSOR fast_forward
        FOR
            SELECT  rr.SurescriptsRefillRequestId ,
                    gc.ExternalCode1 ,
                    rd.RefillDenialReasonText ,
                    im.MessageText,
					ISNULL(rd.DeniedMessageId,'')
            FROM    SurescriptsRefillRequests AS rr
                    JOIN SurescriptsRefillDenials AS rd ON (rd.SurescriptsRefillRequestId = rr.SurescriptsRefillRequestId AND ISNULL(rd.NewRxScriptToFollow,'N') = 'N')
                    JOIN SurescriptsIncomingMessages AS im ON im.SurescriptsIncomingMessageId = rr.SurescriptsIncomingMessageId
                    JOIN GlobalCodes AS gc ON gc.GlobalCodeId = rd.RefillDenialReasonCode
            WHERE   rd.SurescriptsOutgoingMessageId IS NULL

        DECLARE @OutgoingMessageId INT

        OPEN curDeniedRequests

        FETCH curDeniedRequests INTO @currRefillRequestId,
            @currDenialReasonCode, @currDenialReasonText, @currRequestXML, @DenialMessageId

        WHILE @@fetch_status = 0 
            BEGIN

   -- Create the outgoing message
                INSERT  INTO SureScriptsOutgoingMessages
                        ( MessageType ,
                          MessageStatus
                        )
                VALUES  ( 'DENIEDRX' ,
                          @MESSAGESTATUSAWAITINGCREATION
                        )
                SET @OutgoingMessageId = @@identity

                INSERT  INTO @results
                        ( SurescriptsRefillRequestId ,
                          DenialReasonCode ,
                          DenialReasonText ,
                          RequestXML ,
                          SurescriptsOutgoingMessageId,
						  DenialMessageId
                        )
                VALUES  ( @currRefillRequestId ,
                          @currDenialReasonCode ,
                          @currDenialReasonText ,
                          @currRequestXML ,
                          @OutgoingMessageId,
						  @DenialMessageId
                        )

                FETCH curDeniedRequests INTO @currRefillRequestId,
                    @currDenialReasonCode, @currDenialReasonText,
                    @currRequestXML, @DenialMessageId

            END

        CLOSE curDeniedRequests

        DEALLOCATE curDeniedRequests

-- Set the outgoing message identifiers
        UPDATE  a
        SET     SurescriptsOutgoingMessageId = r.SurescriptsOutgoingMessageId
        FROM    SurescriptsRefillDenials AS a
                JOIN @results AS r ON r.SurescriptsRefillRequestId = a.SurescriptsRefillRequestId

        DECLARE @writtenDate VARCHAR(10)
        SET @writtenDate = dbo.ssf_SureScriptsFormatDate(GETDATE())
		
		SELECT @tempRESPONSE_XML = RequestXML
        FROM   @results AS r 
		 IF @tempRESPONSE_XML is not null
			 BEGIN
		      	   SET @tempRESPONSE_XML.modify(' declare default element namespace "http://www.ncpdp.org/schema/SCRIPT"; 
                delete /Message/Body/RefillRequest/MedicationDispensed/SoldDate
                ') 
		     END 
	    UPDATE @results SET RequestXML= CAST(@tempRESPONSE_XML AS VARCHAR(max))
		
		SELECT  SurescriptsRefillRequestId ,
                DenialReasonCode ,
                dbo.ssf_SurescriptsXMLCharReplace(DenialReasonText,70) AS DenialReasonText ,
                SurescriptsOutgoingMessageId ,
                RequestXML ,
                @writtenDate AS WRITTEN_DATE,
				DenialMessageId
        FROM    @results

        COMMIT TRAN

    END TRY
    BEGIN CATCH

        IF @@trancount > 0 
            ROLLBACK TRAN

        DECLARE @errMessage NVARCHAR(4000)
        SET @errMessage = ERROR_MESSAGE()

        RAISERROR(@errMessage, 16, 1)
    END CATCH





IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SureScriptsGetDeniedChangeRequests]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SureScriptsGetDeniedChangeRequests]
GO

create PROCEDURE [dbo].[ssp_SureScriptsGetDeniedChangeRequests]
AS /*****************************************************************************************************/
/*
Stored Procedure: dbo.ssp_SureScriptsGetDeniedChangeRequests

Copyright: 2011 Streamline Healthcare Solutions, LLC

Creation Date:  2011.03.04

Purpose:
	Get DeniedChangeRequests that are not sent to Surescripts yet.

Input Parameters: None

Output Parameters:

Return:
	Data table with format as required by windows service

Calls:

Called by:
	Surescripts Client Windows Service

Log:
	2011.03.04 - Created from ssp_SureScriptsGetDeniedRefillRequests

Sept 9, 2013 - Kalpers changed the date written to use ssf_SureScriptsFormatDate to format the date and changed the date field size from 8 to 10 characters
Sept 9, 2013 - Kalpers replaced customSurescriptsRefillDenials with SurescriptsRefillDenials
Oct 8, 2013 - Kalpers added DenialMessageId
*/
/*****************************************************************************************************/
    BEGIN TRY

        DECLARE @STATUSINQUEUE INT ,
            @STATUSPENDING INT ,
            @MESSAGESTATUSAWAITINGCREATION INT

        SET @STATUSINQUEUE = 5561
        SET @STATUSPENDING = 5562
        SET @MESSAGESTATUSAWAITINGCREATION = 5541

        BEGIN TRAN

        DECLARE @results TABLE
            (
              SurescriptsChangeRequestId INT ,
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
            SELECT  rr.SurescriptsChangeRequestId ,
                    gc.ExternalCode1 ,
                    rd.ChangeDenialReasonText ,
                    im.MessageText,
					ISNULL(rd.DeniedMessageId,'')
            FROM    SurescriptsChangeRequests AS rr
                    JOIN SurescriptsChangeDenials AS rd ON (rd.SurescriptsChangeRequestId = rr.SurescriptsChangeRequestId AND ISNULL(rd.NewRxScriptToFollow,'N') = 'N')
                    JOIN SurescriptsIncomingMessages AS im ON im.SurescriptsIncomingMessageId = rr.SurescriptsIncomingMessageId
                    JOIN GlobalCodes AS gc ON gc.GlobalCodeId = rd.ChangeDenialReasonCode
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
                VALUES  ( 'DENIEDRXCHG' ,
                          @MESSAGESTATUSAWAITINGCREATION
                        )
                SET @OutgoingMessageId = @@identity

                INSERT  INTO @results
                        ( SurescriptsChangeRequestId ,
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
        FROM    SurescriptsChangeDenials AS a
                JOIN @results AS r ON r.SurescriptsChangeRequestId = a.SurescriptsChangeRequestId

        DECLARE @writtenDate VARCHAR(10)
        SET @writtenDate = dbo.ssf_SureScriptsFormatDate(GETDATE())
		
		SELECT  SurescriptsChangeRequestId ,
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






GO


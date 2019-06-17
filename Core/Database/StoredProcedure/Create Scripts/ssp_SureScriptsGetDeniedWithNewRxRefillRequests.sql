/****** Object:  StoredProcedure [dbo].[ssp_SureScriptsGetDeniedWithNewRxRefillRequests]    Script Date: 9/13/2013 2:02:52 PM ******/
DROP PROCEDURE [dbo].[ssp_SureScriptsGetDeniedWithNewRxRefillRequests]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SureScriptsGetDeniedWithNewRxRefillRequests]    Script Date: 9/13/2013 2:02:52 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SureScriptsGetDeniedWithNewRxRefillRequests]
AS /*****************************************************************************************************/
/*
Stored Procedure: dbo.ssp_SureScriptsGetDeniedWithNewRxRefillRequests

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
Oct 8, 2013 - Kalpers Added DenialMessageId to the selection
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
              ClientMedicationScriptActivityId INT ,
              Reason VARCHAR(2) ,
              NOTE VARCHAR(210) ,                     -- NOTE ADDED FOR THIS MEDICATION
              ClientMedicationScriptId INT ,
              SurescriptsOutgoingMessageId INT ,
              RESPONSE_XML type_Comment2 ,             -- The xml of the original refill request
              WRITTEN_DATE VARCHAR(10),
			  DenialMessageId VARCHAR(35)
            )

        DECLARE @ScriptOutput TABLE
            (
              ClientMedicationScriptId INT ,
              PON VARCHAR(35) ,
              RxReferenceNumber VARCHAR(35) ,
              DrugDescription VARCHAR(250) ,
              SureScriptsQuantityQualifier VARCHAR(3) ,
              SureScriptsQuantity DECIMAL(29, 14) ,
              TotalDaysInScript INT ,
              ScriptInstructions VARCHAR(140) ,
              ScriptNote VARCHAR(210) ,
              Refills INT ,
              DispenseAsWritten CHAR(1) , -- Y/N
              OrderDate DATETIME
            )



        DECLARE @currScriptId INT ,
            @currScriptActivityId INT ,
            @currLocationId INT ,
            @currSureScriptsRefillRequestId INT ,
            @currReason VARCHAR(2) ,
            @CurrNote VARCHAR(MAX),
			@DenialMessageId VARCHAR(35)


        DECLARE currScripts CURSOR fast_forward
        FOR
            SELECT  cmsa.ClientMedicationScriptId ,
                    cmsa.ClientMedicationScriptActivityId ,
                    cms.LocationId ,
                    cms.SureScriptsRefillRequestId ,
                    ISNULL(gcd.ExternalCode1, '') ,
                    ISNULL(sfd.RefillDenialReasonText, CASE WHEN sfd.SurescriptsRefillRequestId IS NULL THEN 'Prescriber system cannot transmit approved controlled e prescription' ELSE '' END),
					ISNULL(sfd.DeniedMessageId, '')
            FROM    ClientMedicationScriptActivities AS cmsa
                    JOIN ClientMedicationScripts AS cms ON cms.ClientMedicationScriptId = cmsa.ClientMedicationScriptId
                    JOIN SureScriptsRefillRequests AS ssrr ON ssrr.SureScriptsRefillRequestId = cms.SureScriptsRefillRequestId
                    LEFT JOIN dbo.SurescriptsRefillDenials sfd ON ( cms.SureScriptsRefillRequestId = sfd.SurescriptsRefillRequestId )
                    LEFT JOIN dbo.GlobalCodes gcd ON ( gcd.GlobalCodeId = sfd.RefillDenialReasonCode )
            WHERE   cms.SurescriptsRefillRequestId IS NOT NULL
                    AND ssrr.StatusOfRequest = 'N'
                    AND ISNULL(cms.RecordDeleted, 'N') <> 'Y'
                    AND ISNULL(cmsa.RecordDeleted, 'N') <> 'Y'
                    AND ISNULL(ssrr.RecordDeleted, 'N') <> 'Y'
                    AND ISNULL(sfd.recorddeleted, 'N') <> 'Y'
                    AND NOT EXISTS ( SELECT *
                                     FROM   SureScriptsOutgoingMessages AS ssom
                                     WHERE  ssom.ClientMedicationScriptId = cmsa.ClientMedicationScriptId
                                            AND ssom.MessageType = 'DENIEDNEWRX'
                                            AND ISNULL(ssom.RecordDeleted, 'N') <> 'Y' )
            ORDER BY cmsa.ClientMedicationScriptActivityId  -- FIFO


        DECLARE @OutgoingMessageId INT

        OPEN currScripts

        FETCH currScripts INTO @currScriptId, @currScriptActivityId,
            @currLocationid, @currSureScriptsRefillRequestId, @currReason,
            @currNote, @DenialMessageId

        WHILE @@fetch_status = 0 
            BEGIN

   -- Create the outgoing message
                INSERT  INTO SureScriptsOutgoingMessages
                        ( MessageType ,
                          MessageStatus ,
                          ClientMedicationScriptId
                        )
                VALUES  ( 'DENIEDNEWRX' ,
                          @MESSAGESTATUSAWAITINGCREATION ,
                          @currScriptId
                        )
                SET @OutgoingMessageId = @@identity

                UPDATE  dbo.SurescriptsRefillDenials
                SET     SurescriptsOutgoingMessageId = @OutgoingMessageId
                WHERE   SurescriptsRefillRequestId = @currSureScriptsRefillRequestId

                INSERT  INTO @results
                        ( ClientMedicationScriptActivityId ,
                          Reason ,
                          NOTE ,
                          ClientMedicationScriptId ,
                          SurescriptsOutgoingMessageId,
						  DenialMessageId
                        )
                VALUES  ( @currScriptActivityId ,
                          @currReason ,
                          @currNote ,
                          @currScriptId ,
                          @OutgoingMessageId,
						  @DenialMessageId
                        )

                FETCH currScripts INTO @currScriptId, @currScriptActivityId,
                    @currLocationid, @currSureScriptsRefillRequestId,
                    @currReason, @currNote, @DenialMessageId

            END

        CLOSE currScripts

        DEALLOCATE currScripts


        UPDATE  r
        SET     RESPONSE_XML = ssim.MessageText ,
                WRITTEN_DATE = dbo.ssf_SureScriptsFormatDate(GETDATE())
        FROM    ClientMedicationScriptActivities AS cmsa
                JOIN ClientMedicationScripts AS cms ON cms.ClientMedicationScriptId = cmsa.ClientMedicationScriptId
                JOIN SureScriptsRefillRequests AS ssrr ON ssrr.SureScriptsRefillRequestId = cms.SureScriptsRefillRequestId
                JOIN SureScriptsIncomingMessages AS ssim ON ssim.SureScriptsIncomingMessageId = ssrr.SureScriptsIncomingMessageId
                JOIN @results AS r ON r.ClientMedicationScriptActivityId = cmsa.ClientMedicationScriptActivityId

        SELECT  *
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



/****** Object:  StoredProcedure [dbo].[ssp_SureScriptsUpdatePendingRxRequest]    Script Date: 10/30/2012 11:16:21 AM ******/
IF EXISTS ( SELECT  1
            FROM    INFORMATION_SCHEMA.ROUTINES
            WHERE   SPECIFIC_SCHEMA = 'dbo'
                    AND SPECIFIC_NAME = 'ssp_SureScriptsUpdatePendingRxRequest' ) 
    DROP PROCEDURE [dbo].[ssp_SureScriptsUpdatePendingRxRequest]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SureScriptsUpdatePendingRxRequest]    Script Date: 10/30/2012 11:16:21 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SureScriptsUpdatePendingRxRequest]
/*****************************************************************************************************/
/*
Stored Procedure: dbo.ssp_SureScriptsUpdatePendingRxRequest

Copyright: 2011 Streamline Healthcare Solutions, LLC

Creation Date:  2011.03.04

Purpose:
	Update message status indicating refill denied response message is ready to be created for Surescripts

Input Parameters:
   @ClientMedicationScriptActivityId int		-- SmartCareRx script activity Id
   @SureScriptsMessageId varchar(35)			-- Surescripts message Identifier
   @MessageText type_Comment2					-- Raw xml message text


Output Parameters:

Return:
	None

Calls:

Called by:
	Surescripts Client Windows Service

Log:
	2011.03.04 - Created.
*/
/*****************************************************************************************************/
    @ClientMedicationScriptActivityId INT ,
    @SureScriptsMessageId VARCHAR(35) ,
    @MessageText type_Comment2,
	@SignHash VARCHAR(max)
AS 
    DECLARE @STATUSINQUEUE INT ,
        @STATUSPENDING INT ,
        @MESSAGESTATUSAWAITINGCREATION INT

    SET @STATUSINQUEUE = 5561
    SET @STATUSPENDING = 5562
    SET @MESSAGESTATUSAWAITINGCREATION = 5541

    BEGIN TRY

        BEGIN TRAN

        UPDATE  ClientMedicationScriptActivities
        SET     Status = @STATUSPENDING ,
                StatusDescription = 'Surescripts Message Pending'				
        WHERE   ClientMedicationScriptActivityId = @ClientMedicationScriptActivityId

        UPDATE  ssom
        SET     SureScriptsMessageId = @SureScriptsMessageId ,
                MessageText = @MessageText,
				SignHash = @SignHash
        FROM    SureScriptsOutgoingMessages AS ssom
                JOIN ClientMedicationScriptActivities AS cmsa ON cmsa.ClientMedicationScriptId = ssom.ClientMedicationScriptId
        WHERE   cmsa.ClientMedicationScriptActivityId = @ClientMedicationScriptActivityId
                AND ssom.MessageStatus = @MESSAGESTATUSAWAITINGCREATION


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



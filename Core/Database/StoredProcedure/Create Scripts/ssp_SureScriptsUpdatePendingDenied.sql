/****** Object:  StoredProcedure [dbo].[ssp_SureScriptsUpdatePendingDenied]    Script Date: 10/30/2012 11:13:56 AM ******/
IF EXISTS ( SELECT  1
            FROM    INFORMATION_SCHEMA.ROUTINES
            WHERE   SPECIFIC_SCHEMA = 'dbo'
                    AND SPECIFIC_NAME = 'ssp_SureScriptsUpdatePendingDenied' ) 
    DROP PROCEDURE [dbo].[ssp_SureScriptsUpdatePendingDenied]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SureScriptsUpdatePendingDenied]    Script Date: 10/30/2012 11:13:56 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SureScriptsUpdatePendingDenied]
/*****************************************************************************************************/
/*
Stored Procedure: dbo.ssp_SureScriptsUpdatePendingDenied

Copyright: 2011 Streamline Healthcare Solutions, LLC

Creation Date:  2011.03.04

Purpose:
	Update message status indicating refill denied response message is ready to be created for Surescripts

Input Parameters:
   @SurescriptsOutGoingMessageId int		-- SmartCareRx Outgoing message id
   @SurescriptsMessageId varchar(35)		-- Surescripts message id
   @MessageText type_Comment2				-- Raw xml of the message


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
    @SurescriptsOutGoingMessageId INT ,
    @SurescriptsMessageId VARCHAR(35) ,
    @MessageText type_Comment2
AS 
    DECLARE @MESSAGESTATUSPENDING INT ,
        @MESSAGESTATUSAWAITINGCREATION INT


    SET @MESSAGESTATUSPENDING = -1
    SET @MESSAGESTATUSAWAITINGCREATION = 5541

    BEGIN TRY

        BEGIN TRAN


        UPDATE  ssom
        SET     SureScriptsMessageId = @SureScriptsMessageId ,
                MessageText = @MessageText ,
                MessageStatus = -1     -- pending
        FROM    SureScriptsOutgoingMessages AS ssom
        WHERE   ssom.SureScriptsOutgoingMessageId = @SurescriptsOutGoingMessageId

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



IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SureScriptsUpdatePendingCancelledRx]') AND type in (N'P', N'PC'))
DROP PROCEDURE ssp_SureScriptsUpdatePendingCancelledRx
GO

/****** Object:  StoredProcedure [dbo].[ssp_SureScriptsUpdatePendingCancelledRx]    Script Date: 1/29/2014 1:34:38 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[ssp_SureScriptsUpdatePendingCancelledRx]
/*****************************************************************************************************/
/*
Stored Procedure: ssp_SureScriptsUpdatePendingCancelledRx

Copyright: 2014 Streamline Healthcare Solutions, LLC

Creation Date:  2014.01.07

Purpose:
	Update message status

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
	2014.1.7 - Created.
*/
/*****************************************************************************************************/
    @SurescriptsOutGoingMessageId INT ,
    @SurescriptsMessageId VARCHAR(35) ,
    @MessageText type_Comment2
AS 
    DECLARE @STATUSINQUEUE INT ,
        @STATUSPENDING INT ,
        @MESSAGESTATUSAWAITINGCREATION INT

    SET @STATUSINQUEUE = 5561
    SET @STATUSPENDING = 5562
    SET @MESSAGESTATUSAWAITINGCREATION = 5541

    DECLARE @ScriptActivityId INT

    BEGIN TRY

        BEGIN TRAN

        INSERT  INTO dbo.ClientMedicationScriptActivities
                ( ClientMedicationScriptId ,
                  Method ,
                  IncludeChartCopy ,
                  PharmacyId ,
                  Status ,
                  StatusDescription ,
				  FaxStatusDate,
                  PrescriberOrderNumber ,
                  SureScriptsOutgoingMessageId
		        )
                SELECT  csa.ClientMedicationScriptId ,
                        'E' ,
                        'N' ,
                        csa.PharmacyId ,
                        @STATUSPENDING ,
                        'Surescripts Message Pending' ,
                        GETDATE() ,
                        @SurescriptsMessageId ,
                        @SurescriptsOutGoingMessageId
                FROM    dbo.SureScriptsOutgoingMessages ssom
                        JOIN dbo.SurescriptsCancelRequests scr ON ( ssom.SureScriptsOutgoingMessageId = scr.SurescriptsOutgoingMessageId )
                        JOIN dbo.ClientMedicationScriptActivities csa ON ( scr.OriginalSurescriptsOutgoingMessageId = csa.SurescriptsOutgoingMessageId )
                WHERE   ssom.SureScriptsOutgoingMessageId = @SurescriptsOutGoingMessageId

        SELECT  @ScriptActivityId = SCOPE_IDENTITY()

        INSERT  INTO dbo.ClientMedicationScriptActivitiesPending
                ( ClientMedicationScriptActivityId
                )
        VALUES  ( @ScriptActivityId
                )

        UPDATE  ssom
        SET     SureScriptsMessageId = @SureScriptsMessageId ,
                MessageText = @MessageText ,
                MessageStatus = -1,     -- pending
				ClientMedicationScriptId = cmsa.ClientMedicationScriptId
        FROM    SureScriptsOutgoingMessages AS ssom
				JOIN dbo.ClientMedicationScriptActivities cmsa ON(ssom.SureScriptsOutgoingMessageId = cmsa.SureScriptsOutgoingMessageId)
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



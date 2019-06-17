IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SureScriptsUpdateMessageStatus]') AND type in (N'P', N'PC'))
DROP PROCEDURE ssp_SureScriptsUpdateMessageStatus
GO


/****** Object:  StoredProcedure [dbo].[ssp_SureScriptsUpdateMessageStatus]    Script Date: 1/29/2014 1:44:33 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SureScriptsUpdateMessageStatus]
/*****************************************************************************************************/
/*
Stored Procedure: dbo.ssp_SureScriptsUpdateMessageStatus

Copyright: 2011 Streamline Healthcare Solutions, LLC

Creation Date:  2011.03.04

Purpose:
	Update message status from Surescripts based on response.

Input Parameters:
   @SureScriptsMessageId varchar(35)		-- Surescripts message Id
   @SentStatus int							-- status of the message
   @StatusDescription varchar(250)			-- status description
   @ResponseType int						-- not used
   @PatientNumber varchar(35)				-- Patient Identifier from Surescripts
   @ncpdpId varchar(35)						-- Pharmacy Id
   @spiId varchar(35)						-- Prescriber Id
   @drugDesc varchar(250)					-- Drug description
   @prescriberOrderNo varchar(35)			-- PON sent from SmartCareRx
   @responseText type_Comment2				-- Raw xml of the message


Output Parameters:

Return:
	None

Calls:

Called by:
	Surescripts Client Windows Service

Log:
	2011.03.04 -  Created.   Purpose
	09/18/2013   Kalpers     added check to make sure the denied with new rx requests where coming through this sproc
	02/07/2018   PranayB     When SendStatus=-1 changed to @STATUSSUCCESSFUL   
	02/28/2018   PranayB    PON# not getting updated. added  CASE WHEN ISNULL(@prescriberOrderNo,'')='' THEN PrescriberOrderNumber ELSE @prescriberOrderNo end w.r.t Andrews center 108
*/
/*****************************************************************************************************/
    @SureScriptsMessageId VARCHAR(35) ,
    @SentStatus INT ,
    @StatusDescription VARCHAR(250) ,
    @ResponseType INT ,
    @PatientNumber VARCHAR(35) ,
    @ncpdpId VARCHAR(35) ,
    @spiId VARCHAR(35) ,
    @drugDesc VARCHAR(250) ,
    @prescriberOrderNo VARCHAR(35) ,
    @responseText type_Comment2
AS 
    DECLARE @STATUSSUCCESSFUL INT ,
        @STATUSFAILURE INT ,
        @STATUSPENDING INT
    SET @STATUSSUCCESSFUL = 5563
    SET @STATUSFAILURE = 5564
    SET @STATUSPENDING = 5562

    BEGIN TRY

        BEGIN TRAN
  
        DECLARE @MessageType VARCHAR(25)
        DECLARE @SureScriptsOutgoingMessageId INT
        DECLARE @ClientMedicationScriptId INT      

        SELECT  @MessageType = ISNULL(MessageType, '') ,
                @SureScriptsOutgoingMessageId = SureScriptsOutgoingMessageId ,
                @ClientMedicationScriptId = ClientMedicationScriptId
        FROM    dbo.SureScriptsOutgoingMessages
        WHERE   SureScriptsMessageId = @SureScriptsMessageId      

        UPDATE  SureScriptsOutgoingMessages
        SET     MessageStatus = @SentStatus ,
                ResponseDateTime = GETDATE() ,
                ResponseMessageText = @responseText
        WHERE   SureScriptsOutgoingMessageId = @SureScriptsOutgoingMessageId

		IF ( @MessageType <> 'DENIEDNEWRX' ) 
            BEGIN
                UPDATE  cmsa
                SET     Status = CASE WHEN @SentStatus = 1
                                      THEN @STATUSSUCCESSFUL
                                      WHEN @SentStatus = 0 THEN @STATUSFAILURE
                                      WHEN @SentStatus = -1
                                      THEN @STATUSSUCCESSFUL
                                      ELSE Status
                                 END ,
                        StatusDescription = @StatusDescription ,
                        PrescriberOrderNumber =  CASE WHEN ISNULL(@prescriberOrderNo,'')='' THEN PrescriberOrderNumber ELSE @prescriberOrderNo end,
                        SureScriptsOutgoingMessageId = @SureScriptsOutgoingMessageId
                FROM    ClientMedicationScriptActivities AS cmsa
                        JOIN SureScriptsOutgoingMessages AS ssom ON ( ssom.ClientMedicationScriptId = cmsa.ClientMedicationScriptId
                                                              AND ( cmsa.SureScriptsOutgoingMessageId = @SureScriptsOutgoingMessageId
                                                              OR cmsa.SureScriptsOutgoingMessageId IS NULL
                                                              )
                                                              )
                WHERE   ssom.SureScriptsMessageId = @SureScriptsMessageId
                        AND ISNULL(MessageType, '') <> 'DENIEDNEWRX'
            END
        ELSE 
            BEGIN
                IF EXISTS ( SELECT  *
                            FROM    ClientMedicationScriptActivities
                            WHERE   SureScriptsOutgoingMessageId = @SureScriptsOutgoingMessageId ) 
                    BEGIN
                        UPDATE  cmsa
                        SET     Status = CASE WHEN @SentStatus = 1
                                              THEN @STATUSSUCCESSFUL
                                              WHEN @SentStatus = 0
                                              THEN @STATUSFAILURE
                                              WHEN @SentStatus = -1
                                              THEN @STATUSSUCCESSFUL

                                              ELSE Status
                                         END ,
                                StatusDescription = @StatusDescription ,
                                PrescriberOrderNumber =  CASE WHEN ISNULL(@prescriberOrderNo,'')='' THEN PrescriberOrderNumber ELSE @prescriberOrderNo end
                        FROM    ClientMedicationScriptActivities AS cmsa
                        WHERE   SureScriptsOutgoingMessageId = @SureScriptsOutgoingMessageId
                    END          
                ELSE 
                    BEGIN
                        INSERT  INTO dbo.ClientMedicationScriptActivities
                                ( ClientMedicationScriptId ,
                                  Method ,
                                  IncludeChartCopy ,
                                  PharmacyId ,
                                  Reason ,
                                  Status ,
                                  StatusDescription ,
                                  FaxImageData ,
                                  FaxStatusDate ,
                                  FaxExternalIdentifier ,
                                  FaxDetailedHistory ,
                                  PrescriberReviewDateTime ,
                                  RowIdentifier ,
                                  CreatedBy ,
                                  CreatedDate ,
                                  ModifiedBy ,
                                  ModifiedDate ,
                                  RecordDeleted ,
                                  DeletedDate ,
                                  DeletedBy ,
                                  PrescriberOrderNumber ,
                                  SureScriptsOutgoingMessageId
				                )
                                SELECT  @ClientMedicationScriptId ,
                                        'E' ,
                                        IncludeChartCopy ,
                                        PharmacyId ,
                                        Reason ,
                                        CASE WHEN @SentStatus = 1
                                             THEN @STATUSSUCCESSFUL
                                             WHEN @SentStatus = 0
                                             THEN @STATUSFAILURE
                                             WHEN @SentStatus = -1
                                             THEN @STATUSSUCCESSFUL

                                             ELSE Status
                                        END ,
                                        @StatusDescription ,
                                        NULL ,
                                        FaxStatusDate ,
                                        FaxExternalIdentifier ,
                                        FaxDetailedHistory ,
                                        PrescriberReviewDateTime ,
                                        NEWID() ,
                                        'SSMessageUpdate' ,
                                        GETDATE() ,
                                        'SSMessageUpdate' ,
                                        GETDATE() ,
                                        RecordDeleted ,
                                        DeletedDate ,
                                        DeletedBy ,
                                        @prescriberOrderNo ,
                                        @SureScriptsOutgoingMessageId
                                FROM    ClientMedicationScriptActivities AS cmsa
                                WHERE   cmsa.ClientMedicationScriptId = @ClientMedicationScriptId
				
                    END          
            END      

			IF EXISTS( SELECT *FROM dbo.SureScriptsChangeApprovals WHERE PON=@prescriberOrderNo)   -- Added By Pranay to update status of Prior Authorization Change
			  BEGIN

			  select top 1 @SureScriptsOutgoingMessageId = ssca.SurescriptsOutgoingMessageId from dbo.SureScriptsChangeApprovals as ssca  where ssca.PON = @prescriberOrderNo

			  UPDATE dbo.SureScriptsChangeApprovals 
			  set ApprovedMessageId=@SureScriptsMessageId
			  WHERE PON=@prescriberOrderNo and ApprovedMessageId is null 

				
			update dbo.SureScriptsOutgoingMessages
			set ModifiedDate=GETDATE()
			, MessageStatus = @SentStatus 
			, ResponseMessageText=@responseText
			, SureScriptsMessageId = @SureScriptsMessageId
			, ResponseDateTime = getdate()
			where SureScriptsOutgoingMessageId = @SureScriptsOutgoingMessageId

			  end

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



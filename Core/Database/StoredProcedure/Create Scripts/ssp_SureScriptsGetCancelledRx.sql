IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SureScriptsGetCancelledRx]') AND type in (N'P', N'PC'))
DROP PROCEDURE ssp_SureScriptsGetCancelledRx
GO


/****** Object:  StoredProcedure [dbo].[ssp_SureScriptsGetCancelledRx]    Script Date: 1/29/2014 1:31:26 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Kneale Alpers
-- Create date: January 7, 2014
-- Description:	Get cancelled scripts that have either been cancelled or discontinued
-- Modifications:
-- Date                Name                   Purpose

--11/13/2017          PranayB              Added tempRESPONSE_XML to Remove the Element 'BenefitsCoordination' from the OrignalXml
--05/18/2018          PranayB           Added null check on tempRESPONSE_XML   AspenPointe - Support Go Live: #771 Rx: SureScripts EHRWEB1 Event Log
-- =============================================
CREATE PROCEDURE [dbo].[ssp_SureScriptsGetCancelledRx]
AS 
    BEGIN
        SET NOCOUNT ON;

        BEGIN TRY 
            DECLARE @STATUSINQUEUE INT = 5561 ,
                @STATUSPENDING INT = 5562 ,
                @MESSAGESTATUSAWAITINGCREATION INT = 5541 ,
                @OutgoingMessageId INT
		
            DECLARE @results TABLE
                (
                  OriginalSurescriptsOutgoingMessageId INT ,
                  OriginalSurescriptMessageId VARCHAR(35) ,
                  OriginalRequestXML type_Comment2 ,
                  ChangeRequestType VARCHAR(3) ,
                  ChangeOfPrescriptionStatusFlag CHAR(1) ,
                  SurescriptsOutgoingMessageId INT,
				  SureScriptsProviderId VARCHAR(20)
                )

            DECLARE @currentOriginalSurescriptsOutgoingMessageId INT ,
                @currentOriginalSurescriptMessageId VARCHAR(35) ,
                @currentOriginalRequestXML type_Comment2 ,
                @currentChangeRequestType VARCHAR(3) ,
                @currentChangeOfPrescriptionStatusFlag CHAR(1),
				@spi VARCHAR(20)

            BEGIN TRAN 

            DECLARE currentCancelRxRequests CURSOR FAST_FORWARD
            FOR
                SELECT  cr.OriginalSurescriptsOutgoingMessageId ,
                        om.SureScriptsMessageId ,
                        om.MessageText ,
                        cr.ChangeRequestType ,
                        cr.ChangeOfPrescriptionStatusFlag,
						ISNULL(s.SureScriptsPrescriberId,'') + ISNULL(s.SureScriptsLocationId,'')
                FROM    dbo.SurescriptsCancelRequests cr
                        JOIN dbo.SureScriptsOutgoingMessages om ON ( cr.OriginalSurescriptsOutgoingMessageId = om.SureScriptsOutgoingMessageId )
						LEFT JOIN staff s ON(cr.prescriberid = s.staffid)
                WHERE   cr.SurescriptsOutgoingMessageId IS NULL AND ISNULL(cr.RecordDeleted,'N') <> 'Y'
  
            OPEN currentCancelRxRequests

            FETCH currentCancelRxRequests INTO @currentOriginalSurescriptsOutgoingMessageId,
                @currentOriginalSurescriptMessageId,
                @currentOriginalRequestXML, @currentChangeRequestType,
                @currentChangeOfPrescriptionStatusFlag, @spi

            WHILE @@FETCH_STATUS = 0 
                BEGIN 
                    INSERT  INTO dbo.SureScriptsOutgoingMessages
                            ( MessageType ,
                              MessageStatus
				            )
                    VALUES  ( 'CANRX' ,
                              @MESSAGESTATUSAWAITINGCREATION
                            )

                    SET @OutgoingMessageId = @@identity

                    INSERT  INTO @results
                            ( OriginalSurescriptsOutgoingMessageId ,
                              OriginalSurescriptMessageId ,
                              OriginalRequestXML ,
                              ChangeRequestType ,
                              ChangeOfPrescriptionStatusFlag ,
                              SurescriptsOutgoingMessageId,
							  SureScriptsProviderId
				            )
                    VALUES  ( @currentOriginalSurescriptsOutgoingMessageId ,
                              @currentOriginalSurescriptMessageId ,
                              @currentOriginalRequestXML ,
                              @currentChangeRequestType ,
                              @currentChangeOfPrescriptionStatusFlag ,
                              @OutgoingMessageId,
							  @spi
				            )

                    FETCH currentCancelRxRequests INTO @currentOriginalSurescriptsOutgoingMessageId,
                        @currentOriginalSurescriptMessageId,
                        @currentOriginalRequestXML, @currentChangeRequestType,
                        @currentChangeOfPrescriptionStatusFlag, @spi

                END

            CLOSE currentCancelRxRequests
            DEALLOCATE currentCancelRxRequests

            UPDATE  a
            SET     SurescriptsOutgoingMessageId = r.SurescriptsOutgoingMessageId
            FROM    dbo.SurescriptsCancelRequests a
                    JOIN @results r ON ( a.OriginalSurescriptsOutgoingMessageId = r.OriginalSurescriptsOutgoingMessageId )

            DECLARE @writtenDate VARCHAR(10) = dbo.ssf_SureScriptsFormatDate(GETDATE())
			DECLARE @tempRESPONSE_XML XML

		    SELECT @tempRESPONSE_XML=OriginalRequestXML FROM @results
			IF @tempRESPONSE_XML IS NOT NULL
			BEGIN
		       	SET @tempRESPONSE_XML.modify(' declare default element namespace "http://www.ncpdp.org/schema/SCRIPT"; 
                delete /Message/Body/NewRx/BenefitsCoordination')
		     END 
            SELECT  OriginalSurescriptMessageId ,
                    @writtenDate AS writtendate ,
                    CAST(@tempRESPONSE_XML AS VARCHAR(max)) AS OriginalRequestXML , 
                    ChangeRequestType ,
					ChangeOfPrescriptionStatusFlag  ,
                    SurescriptsOutgoingMessageId,
					SureScriptsProviderId
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
    END

GO



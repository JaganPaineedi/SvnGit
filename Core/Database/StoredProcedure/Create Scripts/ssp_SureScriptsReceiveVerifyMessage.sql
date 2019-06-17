/****** Object:  StoredProcedure [dbo].[ssp_SureScriptsReceiveVerifyMessage]    Script Date: 9/13/2013 2:04:28 PM ******/
DROP PROCEDURE [dbo].[ssp_SureScriptsReceiveVerifyMessage]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SureScriptsReceiveVerifyMessage]    Script Date: 9/13/2013 2:04:28 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* =============================================
-- Author:		Kneale Alpers
-- Create date: September 12, 2013
-- Description:	SureScripts - inserts data into incoming messages for verify messages
--Data Modifications:
-- Date            Author              Purpose   
08/28/2017        PranayB              Added Case statement for the @Receivedatetime w.r.t task# 414 Aspeen Point
                                       to support xsd:date time format.
-- ============================================= */
CREATE PROCEDURE [dbo].[ssp_SureScriptsReceiveVerifyMessage] 
    @IncomingMessageId VARCHAR(35) ,
    @ReceivedDateTime VARCHAR(35) ,
    @RelatesToMessageId VARCHAR(35) ,
    @VerifyMessageStatus INT ,
    @VerifyMessageText VARCHAR(250) ,
    @IncomingMessageXml type_Comment2
AS
BEGIN
	INSERT  INTO SurescriptsIncomingMessages
            ( SureScriptsMessageId ,
              MessageType ,
              ReceivedDateTime ,
              MessageText
            )
    VALUES  ( @IncomingMessageId ,
              'VerifyMSG' ,
              CASE when len(@ReceivedDateTime) > 19 THEN  
			  cast (SUBSTRING ( @ReceivedDateTime ,1 , 19 )+'Z' AS DATETIME) 
			  else CAST (@ReceivedDateTime AS DATETIME) END ,
              @IncomingMessageXml
            )
	
	EXEC ssp_SureScriptsUpdateMessageStatus @SureScriptsMessageId = @RelatesToMessageId,
        @SentStatus = @VerifyMessageStatus,
        @StatusDescription = @VerifyMessageText, @ResponseType = NULL,
        @PatientNumber = NULL, @ncpdpId = NULL, @spiId = NULL,
        @drugDesc = NULL, @prescriberOrderNo = NULL,
        @responseText = @IncomingMessageXml

END

GO



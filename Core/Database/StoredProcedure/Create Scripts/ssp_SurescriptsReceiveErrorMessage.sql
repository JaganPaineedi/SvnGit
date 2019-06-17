IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SurescriptsReceiveErrorMessage]') AND type in (N'P', N'PC'))
DROP PROCEDURE ssp_SurescriptsReceiveErrorMessage
GO


/****** Object:  StoredProcedure [dbo].[ssp_SurescriptsReceiveErrorMessage]    Script Date: 1/29/2014 1:25:29 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SurescriptsReceiveErrorMessage]
/*****************************************************************************************************/
/*
Stored Procedure: dbo.ssp_SurescriptsReceiveErrorMessage

Copyright: 2011 Streamline Healthcare Solutions, LLC

Creation Date:  2011.03.04

Purpose:
	Process error message received from Surescripts

Input Parameters:
   @IncomingMessageId varchar(35)		-- Surescripts-generated unique message identifier
   @ReceivedDateTime varchar(35)		-- Date/time received (from Surescripts message header)
   @RelatesToMessageId varchar(35)		-- Reference to message that generated this error
   @ErrorMessageStatus int				-- Error code
   @ErrorMessageText varchar(250)		-- Error text
   @IncomingMessageXml type_Comment2	-- Raw xml of the message


Output Parameters:

Return:
	Data table with format as required by web service

Calls:

Called by:
	Surescripts Client Windows Service

Log:
	2011.03.04 - Created.
	2014.01.22 - Kalpers added error text to the xml message inside the incoming messages
*/
/*****************************************************************************************************/
    @IncomingMessageId VARCHAR(35) ,
    @ReceivedDateTime VARCHAR(35) ,
    @RelatesToMessageId VARCHAR(35) ,
    @ErrorMessageStatus INT ,
    @ErrorMessageText VARCHAR(250) ,
    @IncomingMessageXml type_Comment2
AS --
-- Create the incoming Message
--

    INSERT  INTO SurescriptsIncomingMessages
            ( SureScriptsMessageId ,
              MessageType ,
              ReceivedDateTime ,
              MessageText
            )
    VALUES  ( @IncomingMessageId ,
              'AsyncError' ,
              CAST(@ReceivedDateTime AS DATETIME) ,
              'ErrorMessage: (' + @ErrorMessageText + ') XML Response: [' + @IncomingMessageXml + ']'
            )


--
-- Now update the relates to message Id
--

    EXEC ssp_SureScriptsUpdateMessageStatus @SureScriptsMessageId = @RelatesToMessageId,
        @SentStatus = @ErrorMessageStatus,
        @StatusDescription = @ErrorMessageText, @ResponseType = NULL,
        @PatientNumber = NULL, @ncpdpId = NULL, @spiId = NULL,
        @drugDesc = NULL, @prescriberOrderNo = NULL,
        @responseText = @IncomingMessageXml


GO



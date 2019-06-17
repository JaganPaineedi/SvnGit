IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SureScriptsCancelRxResponseMessage]') AND type in (N'P', N'PC'))
DROP PROCEDURE ssp_SureScriptsCancelRxResponseMessage
GO


/****** Object:  StoredProcedure [dbo].[ssp_SureScriptsCancelRxResponseMessage]    Script Date: 1/29/2014 1:42:37 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Kneale Alpers
-- Create date: January 22, 2014
-- Description:	SureScripts - inserts data into incoming messages for cancel rx messages
-- =============================================
CREATE PROCEDURE [dbo].[ssp_SureScriptsCancelRxResponseMessage]
    @IncomingMessageId VARCHAR(35) ,
    @ReceivedDateTime VARCHAR(35) ,
    @RelatesToMessageId VARCHAR(35) ,
    @CancelRxResponseMessageText VARCHAR(MAX) ,
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
                  'CancelRxResponse' ,
                  CAST(@ReceivedDateTime AS DATETIME) ,
                  @IncomingMessageXml
                )
 
        UPDATE  dbo.SurescriptsCancelRequests
        SET     ModifiedDate = GETDATE() ,
                ModifiedBy = 'SSMessageUpdate' ,
                CancelRxResponse = @CancelRxResponseMessageText
        WHERE   SurescriptsOutgoingMessageId IN (
                SELECT  SurescriptsOutgoingMessageId
                FROM    dbo.SureScriptsOutgoingMessages
                WHERE   SureScriptsMessageId = @RelatesToMessageId ) 


    END


GO



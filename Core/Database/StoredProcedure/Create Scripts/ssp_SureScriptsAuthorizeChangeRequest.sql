IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[ssp_SureScriptsAuthorizeChangeRequest]')
                    AND type IN ( N'P', N'PC' ) )
    DROP PROCEDURE ssp_SureScriptsAuthorizeChangeRequest;
GO


SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO
CREATE PROC ssp_SureScriptsAuthorizeChangeRequest
    @SureScriptChangeRequestId INT
AS


					insert into dbo.SureScriptsChangeApprovals
					        ( SureScriptsChangeRequestId
					        , PON
					        )
					values  ( @SureScriptChangeRequestId  -- SureScriptsChangeRequestId - int
					        , 'CHRES'
                                        + CAST(@SureScriptChangeRequestId AS VARCHAR)
                                      --  + CASE WHEN ss.SureScriptsIncomingMessageId IS NULL
                                         --      THEN ''
                                         --      ELSE '_'
                                          --          + CAST(ss.SureScriptsIncomingMessageId AS VARCHAR)
                                        --  END
										   + '_'
                                        + REPLACE(REPLACE(CONVERT(VARCHAR(19), GETDATE(), 126),
                                                          ':', ''), '-', '') 
					        )
				declare @SureScriptsChangeApprovalId int = @@IDENTITY

					declare @xml xml 
					
					select top 10 @xml = ss.MessageText
					from    dbo.SureScriptsChangeRequests scr
                    JOIN dbo.SureScriptsIncomingMessages ss ON ss.SureScriptsIncomingMessageId = scr.SureScriptsIncomingMessageId
					WHERE scr.SureScriptsChangeRequestId=@SureScriptChangeRequestId;

					set @xml.modify(' declare default element namespace "http://www.ncpdp.org/schema/SCRIPT"; 
                delete /Message/Body/RxChangeRequest/BenefitsCoordination
                ')

				insert into dbo.SureScriptsOutgoingMessages
			        ( MessageType
			        , SentDateTime
			        , MessageText
			        )
			SELECT  'CHAPR' , -- MessageType - varchar(25)
                    GETDATE() , -- ReceivedDateTime - datetime
                    cast(@xml as varchar(max))  -- MessageText - type_Comment2

					declare @SureScriptsOutgoingMessageId int = @@IDENTITY


				update dbo.SureScriptsChangeApprovals 
				set SurescriptsOutgoingMessageId = @SureScriptsOutgoingMessageId
				where SureScriptsChangeApprovalId =  @SureScriptsChangeApprovalId
					
			

GO
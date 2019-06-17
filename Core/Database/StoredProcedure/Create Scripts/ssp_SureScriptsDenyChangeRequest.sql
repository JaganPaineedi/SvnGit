IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[ssp_SureScriptsDenyChangeRequest]')
                    AND type IN ( N'P', N'PC' ) )
    DROP PROCEDURE ssp_SureScriptsDenyChangeRequest;
GO



SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[ssp_SureScriptsDenyChangeRequest]
    @SureScriptsChangeRequestId INT ,
    @UserCode VARCHAR(20) ,
    @DenialReasonCode INT ,
    @DenialReasonText VARCHAR(70) ,
    @NewRxScriptToFollow type_YOrN = 'N',
	@DeniedMessageId VARCHAR(35) = NULL
AS 
/*********************************************************************/        
---Copyright: 2011 Streamline Healthcare Solutions, LLC

---Creation Date: 09/22/2017

--Author : Pranay

---Purpose:To get the change request

---Input Parameters: @SureScriptsChangeRequestId INT ,
   -- @UserCode VARCHAR(20) ,
   -- @DenialReasonCode INT ,
   -- @DenialReasonText VARCHAR(70) ,
   -- @NewRxScriptToFollow type_YOrN = 'N',
	--@DeniedMessageId VARCHAR(35) = NULL

---Called by:Application
---Log:
--	Date                     Author                             Purpose
/*********************************************************************/      
    BEGIN TRY

        IF ( @DenialReasonCode = 0 ) 
            BEGIN 
                SET @DenialReasonCode = NULL 
            END

        IF NOT EXISTS ( SELECT  *
                        FROM    dbo.SurescriptsChangeDenials
                        WHERE   SurescriptsChangeRequestId = @SureScriptsChangeRequestId ) 
            BEGIN
                INSERT  INTO SurescriptsChangeDenials
                        ( SurescriptsChangeRequestId ,
                          ChangeDenialReasonCode ,
                          ChangeDenialReasonText ,
                          NewRxScriptToFollow ,
						  DeniedMessageId,
                          CreatedBy ,
                          ModifiedBy
						)
                VALUES  ( @SureScriptsChangeRequestId ,
                          @DenialReasonCode ,
                          @DenialReasonText ,
                          @NewRxScriptToFollow ,
						  @DeniedMessageId,
                          @UserCode ,
                          @UserCode
						)
            END 
        ELSE 
            BEGIN 
                UPDATE  dbo.SurescriptsChangeDenials
                SET     ChangeDenialReasonCode = @DenialReasonCode ,
                        ChangeDenialReasonText = @DenialReasonText ,
                        NewRxScriptToFollow = @NewRxScriptToFollow ,
						DeniedMessageId = @DeniedMessageId,
                        ModifiedBy = @UserCode
                WHERE   SurescriptsChangeRequestId = @SureScriptsChangeRequestId
            END
		  		   
        RETURN 0

    END TRY
    BEGIN CATCH
        DECLARE @error_message NVARCHAR(4000)
        SET @error_message = 'ssp_SureScriptsDenyChangeRequest: '
            + ERROR_MESSAGE()
        RAISERROR(@error_message, 16, 1)
    END CATCH



GO


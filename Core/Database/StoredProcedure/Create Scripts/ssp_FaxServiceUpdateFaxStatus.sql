 IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_FaxServiceUpdateFaxStatus]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE ssp_FaxServiceUpdateFaxStatus
GO


SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[ssp_FaxServiceUpdateFaxStatus]
/*========================================================================================================
-Stored Procedure: dbo.ssp_FaxServiceUpdateFaxStatus
-Creation Date:  01/15/2018
-Created By: Pranay Bodhu
-Purpose:
	Update  status in the OutgoingFaxes based on response.

-Input Parameters:
   @OutgoingFaxId Int               		    -- OutgoingFaxId message Id
   @FaxIdentifier VARCHAR(250)					-- FaxIdentifier is sent from FaxServer
   @Status type_GlobalCode			            -- status description 6861-Queued,6862-Pending,6863-Failed,6864-Sucess
   @Attempt int						            -- not used
   
-Output Parameters:

-Return:
	None

-Called by:
	FaxSerive Client Windows Service

Log:
-Date                           Name                                      Purpose
	
========================================================================================================*/
    @OutgoingFaxId INT ,
    @FaxIdentifier VARCHAR(250) ,
    @Status type_GlobalCode ,
    @Attempt INT
AS
    DECLARE @STATUSSUCCESSFUL INT ,
        @STATUSFAILURE INT ,
        @STATUSPENDING INT;
    SET @STATUSSUCCESSFUL = 5563;
    SET @STATUSFAILURE = 5564;
    SET @STATUSPENDING = 5562;

    BEGIN TRY

        BEGIN TRAN;
        UPDATE  dbo.OutgoingFaxes
        SET     Status = @Status ,
                ModifiedBy = 'FaxService' ,
                ModifiedDate = GETDATE() ,
                Attempt = CASE WHEN ISNULL(@Attempt, 0) = 0 THEN Attempt
                               ELSE @Attempt
                          END ,
                FaxExternalIdentifier = CASE WHEN ISNULL(@FaxIdentifier, '') = ''
                                             THEN FaxExternalIdentifier
                                             ELSE @FaxIdentifier
                                        END
        WHERE   OutgoingFaxId = @OutgoingFaxId;
  
        COMMIT TRAN;

    END TRY
    BEGIN CATCH

        IF @@trancount > 0
            ROLLBACK TRAN;

        DECLARE @errMessage NVARCHAR(4000);
        SET @errMessage = ERROR_MESSAGE();

        RAISERROR(@errMessage, 16, 1);

    END CATCH;




GO


IF EXISTS ( SELECT
                    *
                FROM
                    sys.objects
                WHERE
                    object_id = OBJECT_ID(N'[dbo].ssp_SCInitSendEmail')
                    AND type IN ( N'P' , N'PC' ) )
    DROP PROCEDURE [dbo].ssp_SCInitSendEmail;
GO

/****** Object:  StoredProcedure [dbo].[myplaceholderr]    Script Date:   ******/
SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

CREATE PROCEDURE [dbo].ssp_SCInitSendEmail
    @StaffId INT ,
    @ClientID INT ,
    @CustomParameters XML
AS /******************************************************************************
**		File: ssp_SCInitSendEmail.sql
**		Name: ssp_SCInitSendEmail
**		Desc: 
**
**		This template can be customized:
**              
**		Return values:
** 
**		Called by:   
**              
**		Parameters:
**		Input							Output
**     ----------							-----------
**
**		Auth: jcarlson
**		Date: 10/5/2017
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:	    	Author:	     			Description:
**		--------		--------				-------------------------------------------
**	    10/5/2017          jcarlson	            created
*******************************************************************************/     
    BEGIN
        BEGIN TRY
			DECLARE @CurrentUser VARCHAR(30), @CurrentDate DATETIME = GETDATE()
			DECLARE @MessageFrom VARCHAR(MAX)

			SELECT @MessageFrom = EmailId
			FROM dbo.CustomerForgotUsernameMailCredentials

			SELECT @CurrentUser = UserCode
			FROM Staff 
			WHERE StaffId = @StaffId
            DECLARE @PrimaryKey INT = -1;
 --do this for each table you need, remove top 1 if need more than 1 row
            SELECT TOP 1
                    'SentEmails' AS TableName ,
                    -1 AS SentEmailId ,
                    @CurrentUser AS CreatedBy ,
                    @CurrentDate AS CreatedDate ,
                    @CurrentUser AS ModifiedBy ,
                    @CurrentDate AS ModifiedDate ,
					@MessageFrom AS MessageFrom,
					@StaffId AS StaffId,
					@ClientId AS ClientId
					--Rest of columns
                FROM
                    SystemConfigurations s
                LEFT OUTER JOIN SentEmails AS se ON se.SentEmailId = @PrimaryKey;


				
        END TRY

        BEGIN CATCH
            DECLARE @Error VARCHAR(8000);

            SET @Error = CONVERT(VARCHAR , ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000) , ERROR_MESSAGE())
                + '*****' + ISNULL(CONVERT(VARCHAR , ERROR_PROCEDURE()) , 'ssp_SCInitSendEmail') + '*****'
                + CONVERT(VARCHAR , ERROR_LINE()) + '*****' + CONVERT(VARCHAR , ERROR_SEVERITY()) + '*****'
                + CONVERT(VARCHAR , ERROR_STATE());

            RAISERROR (
				@Error
				,-- Message text.                                                                     
				16
				,-- Severity.                                                            
				1 -- State.                                                         
				);
        END CATCH;
    END;
GO


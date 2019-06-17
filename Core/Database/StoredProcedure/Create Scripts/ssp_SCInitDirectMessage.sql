IF EXISTS ( SELECT
                    *
                FROM
                    sys.objects
                WHERE
                    object_id = OBJECT_ID(N'[dbo].[ssp_SCInitDirectMessage]')
                    AND type IN ( N'P' , N'PC' ) )
    DROP PROCEDURE [dbo].ssp_SCInitDirectMessage;
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCInitDirectMessager]    Script Date:   ******/
SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

CREATE PROCEDURE [dbo].ssp_SCInitDirectMessage
    @StaffId INT ,
    @ClientID INT ,
    @CustomParameters XML
AS /******************************************************************************
**		File: ssp_SCInitDirectMessage.sql
**		Name: ssp_SCInitDirectMessage
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
**		Date: 6/26/2017
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:	    	Author:	     			Description:
**		--------		--------				-------------------------------------------
**	    6/26/2017          jcarlson	            created
*******************************************************************************/     
    BEGIN
        BEGIN TRY
			DECLARE @UserCode VARCHAR(30), @EmailAddress VARCHAR(MAX)
			SELECT @UserCode = UserCode,
			@EmailAddress = DirectEmailAddress
			FROM Staff 
			WHERE StaffId = @StaffId

			DECLARE @MessageStatus INT 
			SELECT @MessageStatus = GlobalCodeId
			FROM GlobalCodes 
			WHERE Category = 'DirectMessageStatus'
			AND Code = 'NM'
			AND ISNULL(RecordDeleted,'N')='N'

			DECLARE @DirectAccountId INT 

			SELECT @DirectAccountId = DirectAccountId
			FROM dbo.DirectAccounts
			WHERE StaffId = @StaffId
			AND ISNULL(RecordDeleted,'N')='N'

            DECLARE @PrimaryKey INT = -1;
 --do this for each table you need, remove top 1 if need more than 1 row
            SELECT TOP 1
                    'DirectMessages' AS TableName ,
                    -1 AS DirectMessageId,
                    @UserCode AS CreatedBy ,
                    GETDATE() AS CreatedDate ,
                    @UserCode AS ModifiedBy ,
                    GETDATE() AS ModifiedDate ,
					'O' AS MessageType,
					@EmailAddress AS MessageFrom,
					@StaffId AS StaffId,
					@EmailAddress AS StaffDirectMessageEmail,
					@MessageStatus AS MessageStatus,
					'N' AS MessageRead,
					@DirectAccountId AS DirectAccountId
                FROM
                    SystemConfigurations s
                LEFT OUTER JOIN dbo.DirectMessages AS dm ON dm.DirectMessageId = @PrimaryKey;


				
        END TRY

        BEGIN CATCH
            DECLARE @Error VARCHAR(8000);

            SET @Error = CONVERT(VARCHAR , ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000) , ERROR_MESSAGE())
                + '*****' + ISNULL(CONVERT(VARCHAR , ERROR_PROCEDURE()) , 'ssp_SCInitDirectMessage') + '*****'
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


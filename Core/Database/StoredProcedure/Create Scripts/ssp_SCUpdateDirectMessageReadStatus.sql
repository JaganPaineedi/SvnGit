IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'ssp_SCUpdateDirectMessageReadStatus')
                    AND type IN ( N'P', N'PC' ) )
    BEGIN
        DROP PROCEDURE ssp_SCUpdateDirectMessageReadStatus;
    END;
GO

CREATE PROCEDURE ssp_SCUpdateDirectMessageReadStatus
    @CurrentUser VARCHAR(30)
  , @DirectMessageIds VARCHAR(MAX)
  , @Read CHAR(1)
AS /******************************************************************************
**		File: /Database/Modules/DirectMessaging/StoredProcedures
**		Name: ssp_SCUpdateDirectMessageReadStatus
**		Desc: The purpose of this stored procedure is to update the MessageRead field
**
**              
**		Return values:
** 
**		Called by: DirectMessageAjax.ashx > SetReadStatus method
**              
**		Parameters: @CurrentUser = UserCode of logged in staff
**					@DirectMessageIds = Comma delimited list of Direct Message Ids
**					@Read = Y or N, new status of the MessageRead field
**
**		Auth: jcarlson
**		Date: 7/26/2017
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		    Author:				    Description:
**		--------		--------				-------------------------------------------
**      07/26/2017      jcarlson				created
**		07/27/2017		jcarlson				Modified logic to only update rows where MessageRead <> @Read
*******************************************************************************/
    BEGIN TRY
        BEGIN TRAN;
     
        CREATE TABLE #Ids ( DirectMessageId INT );
        INSERT  INTO #Ids ( DirectMessageId )
        SELECT  CONVERT(INT, item)
        FROM    dbo.fnSplitWithIndex(@DirectMessageIds, ',');


        UPDATE  a
        SET     a.ModifiedBy = @CurrentUser, a.ModifiedDate = GETDATE(), a.MessageRead = @Read
        FROM    dbo.DirectMessages AS a
        JOIN    #Ids AS b ON b.DirectMessageId = a.DirectMessageId
        WHERE   a.MessageRead <> @Read;

        COMMIT TRAN; 
    END TRY
    BEGIN CATCH
        IF @@Trancount > 0
            BEGIN
                ROLLBACK TRAN;
            END;
    
        DECLARE @Error VARCHAR(8000);
        SELECT  @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
                + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCUpdateDirectMessageReadStatus') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****'
                + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE());		
        RAISERROR (	@Error,		16,	1 	);

    END CATCH;
IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'ssp_SCGetDirectMessageOffset')
                    AND type IN ( N'P', N'PC' ) )
    BEGIN
        DROP PROCEDURE ssp_SCGetDirectMessageOffset;
    END;
GO

CREATE PROCEDURE ssp_SCGetDirectMessageOffset
@StaffId INT
AS
/******************************************************************************
**		File: 
**		Name: ssp_SCGetDirectMessageOffset
**		Desc: 
**
**              
**		Return values:
** 
**		Called by:   
**              
**		Parameters:
**
**		Auth: jcarlson
**		Date: 8/15/2017
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		    Author:				    Description:
**		--------		--------				-------------------------------------------
**      8/15/2017          jcarlson             created
*******************************************************************************/
    BEGIN TRY

	Declare @Offset INT = 0;

	DECLARE @DirectAccountId INT 
	SELECT @DirectAccountId = a.DirectAccountId
	FROM dbo.DirectAccounts AS a
	WHERE a.StaffId = @StaffId

	SELECT @Offset = COUNT(*)
	FROM dbo.DirectMessages AS a
	WHERE a.StaffId = @StaffId
	AND ISNULL(a.RecordDeleted,'N')='N'
	AND a.MessageType = 'I'
	AND a.DirectAccountId = @DirectAccountId

	SELECT @Offset AS Offset

    END TRY
    BEGIN CATCH
        DECLARE @Error VARCHAR(8000);
        SELECT  @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
                + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetDirectMessageOffset') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****'
                + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE());		
        RAISERROR(@Error,		16,1 );

    END CATCH;
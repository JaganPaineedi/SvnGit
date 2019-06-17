IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'ssp_SCGetDirectAccountId')
                    AND type IN ( N'P', N'PC' ) )
    BEGIN
        DROP PROCEDURE ssp_SCGetDirectAccountId;
    END;
GO

CREATE PROCEDURE ssp_SCGetDirectAccountId
@StaffId INT
AS
/******************************************************************************
**		File: 
**		Name: ssp_SCGetDirectAccountId
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
**		Date: 8/24/2017
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		    Author:				    Description:
**		--------		--------				-------------------------------------------
**      8/24/2017          jcarlson             created
**		2/19/2018		jcarlson				Texas Go Live Build Issues 26 - added missing StaffId field
*******************************************************************************/
    BEGIN TRY

      SELECT DirectAccountId,StaffId
	  FROM dbo.DirectAccounts 
	  WHERE StaffId = @StaffId
	  AND ISNULL(RecordDeleted,'N')='N'

    END TRY
    BEGIN CATCH
        DECLARE @Error VARCHAR(8000);
        SELECT  @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
                + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetDirectAccountId') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****'
                + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE());		
        RAISERROR(@Error,		16,1 );

    END CATCH;
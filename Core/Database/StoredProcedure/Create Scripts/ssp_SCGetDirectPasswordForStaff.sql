IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'ssp_SCGetDirectPasswordForStaff')
                    AND type IN ( N'P', N'PC' ) )
    BEGIN
        DROP PROCEDURE ssp_SCGetDirectPasswordForStaff;
    END;
GO

CREATE PROCEDURE ssp_SCGetDirectPasswordForStaff
@CurrentUserId INT 
AS
/******************************************************************************
**		File: 
**		Name: ssp_SCGetDirectPasswordForStaff
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
**		Date: 10/15/2017
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		    Author:				    Description:
**		--------		--------				-------------------------------------------
**      10/15/2017          jcarlson             created
*******************************************************************************/
    BEGIN TRY

	SELECT StaffId,DirectEmailAddress,DirectEmailPassword
	FROM Staff 
	WHERE StaffId = @CurrentUserId
        RETURN;


    END TRY
    BEGIN CATCH
        DECLARE @Error VARCHAR(8000);
        SELECT  @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
                + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetDirectPasswordForStaff') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****'
                + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE());		
        RAISERROR(@Error,		16,1 );

    END CATCH;
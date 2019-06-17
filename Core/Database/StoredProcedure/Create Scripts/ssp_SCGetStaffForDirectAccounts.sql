IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'ssp_SCGetStaffForDirectAccounts')
                    AND type IN ( N'P', N'PC' ) )
    BEGIN
        DROP PROCEDURE ssp_SCGetStaffForDirectAccounts;
    END;
GO

CREATE PROCEDURE ssp_SCGetStaffForDirectAccounts
@CurrentUserId INT,
@Letters VARCHAR(max)
AS
/******************************************************************************
**		File: 
**		Name: ssp_SCGetStaffForDirectAccounts
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
**      02/18/2019      jcarlson                PSS SGL 358 - Only pull the first 250 results in, this prevents issues if the client has a large number of staff records
**                                              e.g Client uses patient portal
**	   02/20/2019	    jcarlson			   PSS SGL 358 - Do not pull in patient portal accounts
*******************************************************************************/
    BEGIN TRY

	SELECT top 250 StaffId,FirstName,LastName,DisplayAs
	FROM dbo.Staff AS s
	WHERE  ISNULL(s.NonStaffUser,'N')='N'
		AND (
			s.FirstName LIKE '%' + @Letters + '%'
			OR s.LastName LIKE '%' + @Letters + '%'
			OR s.DisplayAs LIKE '%' + @Letters + '%'
			)

    END TRY
    BEGIN CATCH
        DECLARE @Error VARCHAR(8000);
        SELECT  @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
                + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetStaffForDirectAccounts') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****'
                + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE());		
        RAISERROR(@Error,		16,1 );

    END CATCH;
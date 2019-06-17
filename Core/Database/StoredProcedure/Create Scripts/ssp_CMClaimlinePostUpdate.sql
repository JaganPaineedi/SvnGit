IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'ssp_CMClaimlinePostUpdate')
                    AND type IN ( N'P', N'PC' ) )
    BEGIN
        DROP PROCEDURE ssp_CMClaimlinePostUpdate;
    END;
GO

CREATE PROCEDURE ssp_CMClaimlinePostUpdate
    @ScreenKeyId INT
  , @StaffId INT
  , @CurrentUser VARCHAR(30)
  , @CustomParameters XML
AS /******************************************************************************
**		File: /Database/Modules/CareManagement/ssp_CMClaimlinePostUpdate.sql
**		Name: ssp_CMClaimLinePostUpdate
**		Desc: Post update stored procedure for Claim Line Detail screen 
**				'/Modules/CareManagement/ActivityPages/Office/Detail/ClaimLineDetail.ascx'
**
**              
**		Return values:
** 
**		Called by:   
**              
**		Parameters:
**
**		Auth: jcarlson
**		Date: 11/3/2017
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		    Author:				    Description:
**		--------		--------				-------------------------------------------
**      01/22/2018       jcarlson				created
**		01/22/2018		jcarlson				Heartland SGL 12: Added call to ssp_CMManageOpenClaims to manage OpenClaims table  
*******************************************************************************/
    BEGIN TRY
	
	IF EXISTS ( SELECT  *
	            FROM    sys.objects
	            WHERE   object_id = OBJECT_ID(N'scsp_CMClaimlinePostUpdate')
	                    AND type IN ( N'P', N'PC' ) )
	    BEGIN
	        EXEC scsp_CMClaimlinePostUpdate @ScreenKeyId = @ScreenKeyId, @StaffId = @StaffId, @CurrentUser = @CurrentUser, @CustomParameters = @CustomParameters;
	    END;

	EXEC dbo.ssp_CMManageOpenClaims @ClaimLineId = @ScreenKeyId, @UserCode = @CurrentUser

    END TRY
    BEGIN CATCH
        DECLARE @Error VARCHAR(8000);
        SELECT  @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
                + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_CMClaimlinePostUpdate') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****'
                + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE());		
        RAISERROR(@Error,		16,1 );

    END CATCH;
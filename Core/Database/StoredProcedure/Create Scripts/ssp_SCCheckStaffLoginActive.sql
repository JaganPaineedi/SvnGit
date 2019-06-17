IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'ssp_SCCheckStaffLoginActive')
                    AND type IN ( N'P', N'PC' ) )
    BEGIN
        DROP PROCEDURE ssp_SCCheckStaffLoginActive;
    END;
GO

CREATE PROCEDURE ssp_SCCheckStaffLoginActive
AS
/******************************************************************************
**		File: 
**		Name: ssp_SCCheckStaffLoginActive
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
**		Date: 3/6/2018
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		    Author:				    Description:
**		--------		--------				-------------------------------------------
**      3/6/2018          jcarlson             created
*******************************************************************************/
    BEGIN TRY
	BEGIN TRAN
        DECLARE @LastRequestTime INT = 125;

		SELECT 
		@LastRequestTime = ABS(CONVERT(INT,Value))
		FROM dbo.SystemConfigurationKeys
		WHERE ISNULL(RecordDeleted,'N')='N'
		AND [Key] = 'MaxTimeSinceLastStaffRequest'
		AND ISNUMERIC(Value) = 1

		--If the current time is more than @LastRequestTime seconds past the LastRequest Time, set the logout time to the last request time
		UPDATE dbo.StaffLoginHistory
		SET LogoutTime = LastRequest
		WHERE DATEDIFF(SECOND,LastRequest,GETDATE()) > @LastRequestTime
		AND LogoutTime IS NULL
		

    COMMIT TRAN 
    END TRY
    BEGIN CATCH
	IF @@Trancount > 0
	BEGIN
    ROLLBACK TRAN
	END
        DECLARE @ErrorDate DATETIME = GETDATE();
        DECLARE @Error VARCHAR(8000);
        SELECT  @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
                + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCCheckStaffLoginActive') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****'
                + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE());		
		
		EXEC dbo.ssp_SCLogError @ErrorMessage = 'Unable to check and update Staff Logout times.', -- text
		    @VerboseInfo = @Error, -- text
		    @ErrorType = 'Error', -- varchar(50)
		    @CreatedBy = 'ssp_SCCheckStaffLoginActive', -- varchar(30)
		    @CreatedDate = @ErrorDate, -- datetime
		    @DatasetInfo = '' -- text
		
        RAISERROR (	@Error,	16,	1 );

    END CATCH;
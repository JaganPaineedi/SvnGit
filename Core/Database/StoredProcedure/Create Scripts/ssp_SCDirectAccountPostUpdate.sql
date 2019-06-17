IF EXISTS (SELECT *
             FROM sys.objects
            WHERE object_id = OBJECT_ID(N'ssp_SCDirectAccountPostUpdate')
              AND type IN ( N'P', N'PC' ))
BEGIN
    DROP PROCEDURE ssp_SCDirectAccountPostUpdate;
END;
GO

CREATE PROCEDURE ssp_SCDirectAccountPostUpdate
    @ScreenKeyId INT = 0, -- int
    @StaffId INT = 0, -- int
    @CurrentUser VARCHAR(30) = '', -- varchar(30)
    @CustomParameters XML = NULL -- xml
AS
/******************************************************************************
**		File: 
**		Name: ssp_SCDirectAccountPostUpdate
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
**		Date: 8/10/2017
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		    Author:				    Description:
**		--------		--------				-------------------------------------------
**      8/10/2017          jcarlson             created
*******************************************************************************/
BEGIN TRY
    BEGIN TRAN;

	DECLARE @PrevStaffId INT;

	  DECLARE @locCustomParameters XML = CONVERT(XML, @CustomParameters);
	--grab all the client address ids that have been modified
         SELECT   @PrevStaffId = a.value('@PrevStaffId', 'int')
         FROM      @locCustomParameters.nodes('/Root/Parameters') AS XTable ( a )
                           
    IF EXISTS (SELECT 1
                 FROM DirectAccounts AS a
                WHERE a.DirectAccountId = @ScreenKeyId
                  AND a.StaffId IS NULL)
    BEGIN
        UPDATE st
           SET st.DirectEmailAddress = NULL,
               st.DirectEmailPassword = NULL
          FROM Staff AS st
         WHERE ISNULL(st.RecordDeleted, 'N') = 'N'
		 AND st.StaffId = @PrevStaffId
		 AND @PrevStaffId <> -1;
    END;
    ELSE 
    BEGIN
        UPDATE st
           SET st.DirectEmailAddress = da.DirectEmailAddress,
               st.DirectEmailPassword = da.DirectPassword
          FROM Staff AS st
          JOIN dbo.DirectAccounts AS da
            ON da.StaffId         = st.StaffId
           AND da.DirectAccountId = @ScreenKeyId
         WHERE ISNULL(st.RecordDeleted, 'N') = 'N';
    END;

    IF EXISTS ( SELECT  1
                FROM    dbo.DirectAccounts AS a
                WHERE   a.DirectAccountId = @ScreenKeyId
                        AND a.StaffId <> @PrevStaffId 
						AND @PrevStaffId <> -1)
        BEGIN
            UPDATE  st
            SET     st.DirectEmailAddress = NULL, st.DirectEmailPassword = NULL
            FROM    Staff AS st
            WHERE   ISNULL(st.RecordDeleted, 'N') = 'N'
                    AND st.StaffId = @PrevStaffId;

        END;

    COMMIT TRAN;
END TRY
BEGIN CATCH
    IF @@Trancount > 0
    BEGIN
        ROLLBACK TRAN;
    END;

    DECLARE @Error VARCHAR(8000);
    SELECT @Error
        = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
          + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCDirectAccountPostUpdate') + '*****'
          + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****'
          + CONVERT(VARCHAR, ERROR_STATE());
    RAISERROR(@Error, 16, 1);

END CATCH;
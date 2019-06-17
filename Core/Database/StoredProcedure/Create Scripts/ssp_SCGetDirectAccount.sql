IF EXISTS ( SELECT
                    *
                FROM
                    sys.objects
                WHERE
                    object_id = OBJECT_ID(N'ssp_SCGetDirectAccount')
                    AND type IN ( N'P' , N'PC' ) )
    BEGIN 
        DROP PROCEDURE ssp_SCGetDirectAccount; 
    END;
                    GO

SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO
CREATE PROCEDURE ssp_SCGetDirectAccount @DirectAccountId INT
AS /******************************************************************************
**		File: ssp_SCGetDirectAccount.sql
**		Name: ssp_SCGetDirectAccount
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
**		Auth: 
**		Date: 
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		    Author:				    Description:
**		--------		--------				-------------------------------------------
**	    11/25/2016      jcarlson			    created
*******************************************************************************/ 
    BEGIN
	
        BEGIN TRY
        SELECT a.DirectAccountId, a.CreatedBy, a.CreatedDate, a.ModifiedBy, a.ModifiedDate, a.RecordDeleted, a.DeletedBy, a.DeletedDate, a.DirectFirstName,
             a.DirectLastName, a.DirectEmailAddress, a.DirectPassword, a.DirectAlternativeEmail, a.DirectDescription, a.StaffId,st.DisplayAs AS StaffName, st.StaffId AS PrevStaffId
		FROM dbo.DirectAccounts AS a
		LEFT JOIN Staff AS st ON a.StaffId = st.StaffId
		WHERE a.DirectAccountId = @DirectAccountId

        END TRY

        BEGIN CATCH
            DECLARE @Error VARCHAR(8000);

            SET @Error = CONVERT(VARCHAR , ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000) , ERROR_MESSAGE())
                + '*****' + ISNULL(CONVERT(VARCHAR , ERROR_PROCEDURE()) , 'ssp_SCGetDirectAccount') + '*****'
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


IF EXISTS ( SELECT
                    *
                FROM
                    sys.objects
                WHERE
                    object_id = OBJECT_ID(N'[dbo].[ssp_SCInitDirectAccount]')
                    AND type IN ( N'P' , N'PC' ) )
    DROP PROCEDURE [dbo].ssp_SCInitDirectAccount;
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCInitDirectAccountr]    Script Date:   ******/
SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

CREATE PROCEDURE [dbo].ssp_SCInitDirectAccount
    @StaffId INT ,
    @ClientID INT ,
    @CustomParameters XML
AS /******************************************************************************
**		File: ssp_SCInitDirectAccount.sql
**		Name: ssp_SCInitDirectAccount
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
**		Date: 7/19/2017
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:	    	Author:	     			Description:
**		--------		--------				-------------------------------------------
**	    7/19/2017          jcarlson	            created
*******************************************************************************/     
    BEGIN
        BEGIN TRY
	
            DECLARE @PrimaryKey INT = -1;
 --do this for each table you need, remove top 1 if need more than 1 row
            SELECT TOP 1
                    'DirectAccounts' AS TableName ,
                    -1 AS DirectAccountId,
                    '' AS CreatedBy ,
                    GETDATE() AS CreatedDate ,
                    '' AS ModifiedBy ,
                    GETDATE() AS ModifiedDate,
					'' AS StaffName,
					0 AS StaffId
					--Rest of columns
                FROM
                    SystemConfigurations s
                LEFT OUTER JOIN DirectAccounts AS a ON a.DirectAccountId = @PrimaryKey;


				
        END TRY

        BEGIN CATCH
            DECLARE @Error VARCHAR(8000);

            SET @Error = CONVERT(VARCHAR , ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000) , ERROR_MESSAGE())
                + '*****' + ISNULL(CONVERT(VARCHAR , ERROR_PROCEDURE()) , 'ssp_SCInitDirectAccount') + '*****'
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


/****** Object:  StoredProcedure [dbo].[smsp_GetServiceAttending]    Script Date: 8/30/2016 5:06:40 PM ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[smsp_GetServiceAttending]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[smsp_GetServiceAttending]
GO

/****** Object:  StoredProcedure [dbo].[smsp_GetServiceAttending]    Script Date: 8/30/2016 5:06:40 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[smsp_GetServiceAttending] @StaffId INT
AS -- =============================================      
-- Author:  Pradeep      
-- Create date: 14-06-2016
-- Description: Get StaffProcedureCodes
/*      
 Author			Modified Date			Reason      
   
      
*/
-- =============================================      
    BEGIN
        BEGIN TRY
            SELECT  SP.StaffId ,
                    S.LastName + ', ' + S.FirstName AS StaffName
            FROM    dbo.StaffProxies SP
                    JOIN dbo.Staff S ON S.StaffId = SP.StaffId
            WHERE   S.Active = 'Y'
                    AND ISNULL(SP.RecordDeleted, 'N') = 'N'
                    AND ISNULL(S.RecordDeleted, 'N') = 'N'
                    AND SP.StaffId = @StaffId;
        END TRY

        BEGIN CATCH
            DECLARE @Error VARCHAR(8000);

            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****'
                + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
                + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),
                         'smsp_GetServiceAttending') + '*****'
                + CONVERT(VARCHAR, ERROR_LINE()) + '*****'
                + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****'
                + CONVERT(VARCHAR, ERROR_STATE());

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



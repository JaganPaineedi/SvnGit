/****** Object:  StoredProcedure [dbo].[smsp_GetServiceDropDownValues]    Script Date: 9/2/2016 12:33:29 PM ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[smsp_GetServiceDropDownValues]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[smsp_GetServiceDropDownValues]
GO

/****** Object:  StoredProcedure [dbo].[smsp_GetServiceDropDownValues]    Script Date: 9/2/2016 12:33:29 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[smsp_GetServiceDropDownValues] @StaffId INT --,
    --@JsonResult VARCHAR(MAX) OUTPUT
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
            EXEC smsp_GetStaffProcedureCodes @StaffId;
            EXEC smsp_GetStaffPrograms @StaffId;
            EXEC smsp_GetStaffLocations @StaffId;
            EXEC smsp_GetServiceAttending @StaffId;
			EXEC smsp_GetServiceClinicians @StaffId;
        END TRY

        BEGIN CATCH
            DECLARE @Error VARCHAR(8000);

            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****'
                + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
                + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),
                         'smsp_GetServiceDropDownValues') + '*****'
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



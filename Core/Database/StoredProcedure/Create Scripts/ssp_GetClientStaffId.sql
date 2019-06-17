
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetClientStaffId]    Script Date: 06/17/2015 05:56:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetClientStaffId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetClientStaffId]
GO


GO

/****** Object:  StoredProcedure [dbo].[ssp_GetClientStaffId]    Script Date: 06/17/2015 05:56:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_GetClientStaffId]
	/*************************************************************/
	/* Stored Procedure: dbo.ssp_GetClientStaffId	             */
	/* Creation Date:  May 20 2013                                */
	/* Purpose: To Get Patient Portal StaffId 				 */
	/*  Date                  Author                 Purpose     */
	/* May 20 2014           Chethan N            Created     */
	/* Jun 16 2014		     Pradeep.A			  Changed StaffId to UserStaffId */
	/* Oct 22 2014			 Chethan N			  Get StaffId from Staff table	*/
	/*************************************************************/
	@ClientId INT
AS
BEGIN
	BEGIN TRY
		SELECT S.StaffId
		FROM Staff S
		WHERE S.TempClientId = @ClientId AND S.TempClientContactId is NULL AND ISNULL(S.RecordDeleted, 'N') <> 'Y'
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetClientStaffId') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.          
				16
				,-- Severity.          
				1 -- State.          
				);
	END CATCH
END

GO


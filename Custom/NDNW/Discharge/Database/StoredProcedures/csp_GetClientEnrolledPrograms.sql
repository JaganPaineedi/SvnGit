
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetClientEnrolledPrograms]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_GetClientEnrolledPrograms]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[csp_GetClientEnrolledPrograms] @ClientId INT
AS
/*********************************************************************/
/* Stored Procedure: [csp_GetClientEnrolledPrograms]   */
/*       Date              Author                  Purpose                   */

/*********************************************************************/
BEGIN
	BEGIN TRY
		
		select Distinct 'ClientEnrolledPrograms' AS TableName 
		
	,cp.ProgramId,pr.ProgramName from Programs pr inner join ClientPrograms cp  on cp.ProgramId = pr.ProgramId where CP.ClientId =@ClientID AND IsNull(CP.RecordDeleted, 'N') = 'N'  AND CP.[Status] IN (4)  		
		
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_GetClientEnrolledPrograms') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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



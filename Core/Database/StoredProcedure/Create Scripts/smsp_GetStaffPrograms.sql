/****** Object:  StoredProcedure [dbo].[smsp_GetStaffPrograms]    Script Date: 8/30/2016 5:05:55 PM ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[smsp_GetStaffPrograms]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[smsp_GetStaffPrograms]
GO

/****** Object:  StoredProcedure [dbo].[smsp_GetStaffPrograms]    Script Date: 8/30/2016 5:05:55 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[smsp_GetStaffPrograms] @StaffId INT
AS
BEGIN
	BEGIN TRY
		SELECT S.ProgramId
			,P.ProgramCode
		FROM dbo.StaffPrograms S
		JOIN dbo.Programs P ON P.ProgramId = S.ProgramId
		WHERE StaffId = @StaffId
			AND ISNULL(S.RecordDeleted, 'N') = 'N'
			AND ISNULL(P.RecordDeleted, 'N') = 'N'
			AND P.Active = 'Y'
			AND P.Mobile = 'Y'
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000);

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'smsp_GetStaffPrograms') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE());

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



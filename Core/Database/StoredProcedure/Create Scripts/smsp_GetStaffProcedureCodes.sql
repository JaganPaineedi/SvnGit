/****** Object:  StoredProcedure [dbo].[smsp_GetStaffProcedureCodes]    Script Date: 8/30/2016 5:05:11 PM ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[smsp_GetStaffProcedureCodes]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[smsp_GetStaffProcedureCodes]
GO

/****** Object:  StoredProcedure [dbo].[smsp_GetStaffProcedureCodes]    Script Date: 8/30/2016 5:05:11 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[smsp_GetStaffProcedureCodes] @StaffId INT
AS -- =============================================      
-- Author:  Pradeep      
-- Create date: 14-06-2016
-- Description: Get StaffProcedureCodes
/*      
 Author			Modified Date			Reason      
 Pradeep		Mar 27 2017				Return MobileAssociatedNoteId as AssociatedNoteId
 Pradeep		Mar 30 2017				Changed DisplayAS to ProcedureCodeName     
*/
-- =============================================      
BEGIN
	BEGIN TRY
		SELECT DISTINCT SP.ProcedureCodeId
			,PC.ProcedureCodeName AS ProcedureCodeName
			,PC.MobileAssociatedNoteId AS AssociatedNoteId
		FROM dbo.StaffProcedures SP
		JOIN dbo.ProcedureCodes PC ON SP.ProcedureCodeId = PC.ProcedureCodeId
		WHERE PC.Active = 'Y'
			AND PC.Mobile = 'Y'
			AND ISNULL(SP.RecordDeleted, 'N') = 'N'
			AND ISNULL(PC.RecordDeleted, 'N') = 'N'
			AND SP.StaffId = @StaffId
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000);

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'smsp_GetStaffProcedureCodes') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE());

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



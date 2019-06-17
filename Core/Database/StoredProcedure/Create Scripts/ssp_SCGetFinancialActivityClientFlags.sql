/****** Object:  StoredProcedure [dbo].[ssp_SCGetFinancialActivityClientFlags]    Script Date: 02/06/2015 13:03:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetFinancialActivityClientFlags]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetFinancialActivityClientFlags]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetFinancialActivityClientFlags]    Script Date: 02/06/2015 13:03:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCGetFinancialActivityClientFlags] (@ClientId INT
	,@StaffId INT
	,@FromDate DATETIME
	,@ToDate DATETIME
	,@Mode VARCHAR(10))
AS
/********************************************************************************                                                        
-- Stored Procedure: ssp_SCGetFinancialActivityClientFlags      
--      
-- Copyright: Streamline Healthcate Solutions      
--      
-- Purpose: Query to return data for the Client Flags.      
--      
-- Author:  Akwinass      
-- Date:    04 Feb 2015     
--      
-- *****History**** 
-- 25 FEB 2015     Akwinass        Implemented Null Check for Start and End Date (Task #952 in Valley - Customizations)
*********************************************************************************/
BEGIN
	BEGIN TRY
		IF @Mode = 'CREATED'
		BEGIN
			SELECT DISTINCT CN.CreatedDate AS ActivityDate	
				,'Flag Created' AS Activity
				,ISNULL(FT.FlagType,'') + ' – ' + ISNULL(CN.Note,'') + ' – ' + CASE WHEN CN.StartDate IS NOT NULL THEN CONVERT(VARCHAR(10), CN.StartDate, 110) ELSE 'No Start Date' END + ' – ' + CASE WHEN CN.EndDate IS NOT NULL THEN CONVERT(VARCHAR(10), CN.EndDate, 110) ELSE 'No End Date' END AS [Description]
				,S.LastName + ', ' + S.FirstName AS Staff	
				,CASE WHEN ISNULL(CN.RecordDeleted,'N') = 'N' THEN CN.ClientNoteId ELSE NULL END AS ClientNoteId
				,CASE WHEN ISNULL(CN.RecordDeleted,'N') = 'N' THEN CN.NoteType ELSE NULL END AS NoteType
				,CASE WHEN ISNULL(CN.RecordDeleted,'N') = 'N' THEN CN.NoteLevel ELSE NULL END AS NoteLevel
				,CASE WHEN ISNULL(CN.RecordDeleted,'N') = 'N' THEN CN.CreatedBy ELSE NULL END AS  NoteCreatedBy		
			FROM ClientNotes CN
			LEFT JOIN FlagTypes FT ON FT.FlagTypeId = CN.NoteType
			LEFT JOIN GlobalCodes GC2 ON GC2.GlobalCodeId = CN.NoteLevel
			LEFT JOIN Staff S ON CN.CreatedBy = S.UserCode AND (S.StaffId = @StaffId OR @StaffId = 0)
			WHERE (ClientId = @ClientId) AND CAST(CN.CreatedDate AS DATE) >= CAST(@FromDate AS Date)
			AND CAST(CN.CreatedDate AS DATE) <= CAST(@ToDate AS Date)
			AND S.StaffId IS NOT NULL
		END
		ELSE IF @Mode = 'REMOVED'
		BEGIN
			SELECT DISTINCT CN.DeletedDate AS ActivityDate	
				,'Flag Removed' AS Activity
				,ISNULL(FT.FlagType,'') + ' – ' + ISNULL(CN.Note,'') + ' – ' + CASE WHEN CN.StartDate IS NOT NULL THEN CONVERT(VARCHAR(10), CN.StartDate, 110) ELSE 'No Start Date' END + ' – ' + CASE WHEN CN.EndDate IS NOT NULL THEN CONVERT(VARCHAR(10), CN.EndDate, 110) ELSE 'No End Date' END AS [Description]
				,S.LastName + ', ' + S.FirstName AS Staff
			FROM ClientNotes CN
			LEFT JOIN FlagTypes FT ON FT.FlagTypeId = CN.NoteType
			LEFT JOIN GlobalCodes GC2 ON GC2.GlobalCodeId = CN.NoteLevel
			LEFT JOIN Staff S ON CN.DeletedBy = S.UserCode AND (S.StaffId = @StaffId OR @StaffId = 0)
			WHERE (ClientId = @ClientId) AND ISNULL(CN.RecordDeleted,'N') = 'Y'
			AND CAST(CN.DeletedDate AS DATE) >= CAST(@FromDate AS Date)
			AND CAST(CN.DeletedDate AS DATE) <= CAST(@ToDate AS Date)
			AND S.StaffId IS NOT NULL
		END

	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetFinancialActivityClientFlags') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


